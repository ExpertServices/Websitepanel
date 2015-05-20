using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Providers.RemoteDesktopServices
{
    public static class RdsRunspaceExtensions
    {
        public static RdsCollection GetCollection(this Runspace runspace, string collectionName, string connectionBroker, string primaryDomainController)
        {
            RdsCollection collection = null;
            Command cmd = new Command("Get-RDSessionCollection");
            cmd.Parameters.Add("CollectionName", collectionName);
            cmd.Parameters.Add("ConnectionBroker", connectionBroker);

            var collectionPs = ExecuteShellCommand(runspace, cmd, false, primaryDomainController).FirstOrDefault();

            if (collectionPs != null)
            {
                collection = new RdsCollection();
                collection.Name = Convert.ToString(GetPSObjectProperty(collectionPs, "CollectionName"));
                collection.Description = Convert.ToString(GetPSObjectProperty(collectionPs, "CollectionDescription"));
            }

            return collection;
        }

        public static List<RdsCollectionSetting> GetCollectionSettings(this Runspace runspace, string collectionName, string connectionBroker, string primaryDomainController, out object[] errors)
        {
            var result = new List<RdsCollectionSetting>();
            var errorsList = new List<object>();

            result.AddRange(GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "Connection", out errors));
            errorsList.AddRange(errors);
            result.AddRange(GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "UserProfileDisk", out errors));
            errorsList.AddRange(errors);
            result.AddRange(GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "Security", out errors));
            errorsList.AddRange(errors);
            result.AddRange(GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "LoadBalancing", out errors));
            errorsList.AddRange(errors);
            result.AddRange(GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "Client", out errors));
            errorsList.AddRange(errors);
            errors = errorsList.ToArray();

            return result;
        }

        public static List<RdsCollectionSetting> GetCollectionUserGroups(this Runspace runspace, string collectionName, string connectionBroker, string primaryDomainController, out object[] errors)
        {
            return GetCollectionSettings(runspace, collectionName, connectionBroker, primaryDomainController, "UserGroup", out errors);
        }

        public static List<string> GetSessionHosts(this Runspace runspace, string collectionName, string connectionBroker, string primaryDomainController, out object[] errors)
        {
            Command cmd = new Command("Get-RDSessionHost");
            cmd.Parameters.Add("CollectionName", collectionName);
            cmd.Parameters.Add("ConnectionBroker", connectionBroker);

            var psObjects = ExecuteShellCommand(runspace, cmd, false, primaryDomainController, out errors);
            var rdsServers = new List<string>();

            if (psObjects != null)
            {
                foreach(var psObject in psObjects)
                {
                    rdsServers.Add(GetPSObjectProperty(psObject, "SessionHost").ToString());
                }
            }

            return rdsServers;
        }

        private static List<RdsCollectionSetting> GetCollectionSettings(this Runspace runspace, string collectionName, string connectionBroker, string primaryDomainController, string param, out object[] errors)
        {
            Command cmd = new Command("Get-RDSessionCollectionConfiguration");
            cmd.Parameters.Add("CollectionName", collectionName);
            cmd.Parameters.Add("ConnectionBroker", connectionBroker);

            if (!string.IsNullOrEmpty(param))
            {
                cmd.Parameters.Add(param, true);
            }

            var psObject = ExecuteShellCommand(runspace, cmd, false, primaryDomainController, out errors).FirstOrDefault();

            var properties = typeof(RdsCollectionSettings).GetProperties().Select(p => p.Name.ToLower());
            var collectionSettings = new RdsCollectionSettings();
            var result = new List<RdsCollectionSetting>();

            if (psObject != null)
            {
                foreach (var prop in psObject.Properties)
                {                    
                    if (prop.Name.ToLower() != "id" && prop.Name.ToLower() != "rdscollectionid")
                    {
                        result.Add(new RdsCollectionSetting
                        {
                            PropertyName = prop.Name,
                            PropertyValue = prop.Value
                        });
                    }
                }
            }

            return result;
        }

        private static Collection<PSObject> ExecuteShellCommand(Runspace runSpace, Command cmd, bool useDomainController, string primaryDomainController)
        {
            object[] errors;
            return ExecuteShellCommand(runSpace, cmd, useDomainController, primaryDomainController, out errors);
        }

        private static Collection<PSObject> ExecuteShellCommand(Runspace runSpace, Command cmd, bool useDomainController, string primaryDomainController,
            out object[] errors)
        {
            Log.WriteStart("ExecuteShellCommand");
            List<object> errorList = new List<object>();

            if (useDomainController)
            {
                CommandParameter dc = new CommandParameter("DomainController", primaryDomainController);
                if (!cmd.Parameters.Contains(dc))
                {
                    cmd.Parameters.Add(dc);
                }
            }

            Collection<PSObject> results = null;
            // Create a pipeline
            Pipeline pipeLine = runSpace.CreatePipeline();
            using (pipeLine)
            {
                // Add the command
                pipeLine.Commands.Add(cmd);
                // Execute the pipeline and save the objects returned.
                results = pipeLine.Invoke();

                // Log out any errors in the pipeline execution
                // NOTE: These errors are NOT thrown as exceptions! 
                // Be sure to check this to ensure that no errors 
                // happened while executing the command.
                if (pipeLine.Error != null && pipeLine.Error.Count > 0)
                {
                    foreach (object item in pipeLine.Error.ReadToEnd())
                    {
                        errorList.Add(item);
                        string errorMessage = string.Format("Invoke error: {0}", item);
                        Log.WriteWarning(errorMessage);
                    }
                }
            }
            pipeLine = null;
            errors = errorList.ToArray();
            Log.WriteEnd("ExecuteShellCommand");
            return results;
        }

        private static object GetPSObjectProperty(PSObject obj, string name)
        {
            return obj.Members[name].Value;
        }
    }
}
