using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Providers.Virtualization
{
    public class PowerShellManager : IDisposable
    {
        protected static InitialSessionState session = null;

        protected Runspace RunSpace { get; set; }

        public PowerShellManager()
        {
            OpenRunspace();
        }

        protected void OpenRunspace()
        {
            HostedSolutionLog.LogStart("OpenRunspace");

            if (session == null)
            {
                session = InitialSessionState.CreateDefault();
                session.ImportPSModule(new[] {"Hyper-V"});
            }

            Runspace runSpace = RunspaceFactory.CreateRunspace(session);
            runSpace.Open();
            runSpace.SessionStateProxy.SetVariable("ConfirmPreference", "none");

            RunSpace = runSpace;
   
            HostedSolutionLog.LogEnd("OpenRunspace");
        }

        public void Dispose()
        {
            try
            {
                if (RunSpace != null && RunSpace.RunspaceStateInfo.State == RunspaceState.Opened)
                {
                    RunSpace.Close();
                    RunSpace = null;
                }
            }
            catch (Exception ex)
            {
                HostedSolutionLog.LogError("Runspace error", ex);
            }
        }

        public Collection<PSObject> Execute(Command cmd)
        {
            return Execute(cmd, true);
        }

        public Collection<PSObject> Execute(Command cmd, bool useDomainController)
        {
            object[] errors;
            return Execute(cmd, useDomainController, out errors);
        }

        public Collection<PSObject> Execute(Command cmd, out object[] errors)
        {
            return Execute(cmd, true, out errors);
        }

        public Collection<PSObject> Execute(Command cmd, bool useDomainController, out object[] errors)
        {
            HostedSolutionLog.LogStart("Execute");
            List<object> errorList = new List<object>();

            HostedSolutionLog.DebugCommand(cmd);
            Collection<PSObject> results = null;
            // Create a pipeline
            Pipeline pipeLine = RunSpace.CreatePipeline();
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
                        HostedSolutionLog.LogWarning(errorMessage);
                    }
                }
            }
            pipeLine = null;
            errors = errorList.ToArray();
            HostedSolutionLog.LogEnd("Execute");
            return results;
        }


        /// <summary>
        /// Returns the identity of the object from the shell execution result
        /// </summary>
        /// <param name="result"></param>
        /// <returns></returns>
        public static string GetResultObjectIdentity(Collection<PSObject> result)
        {
            HostedSolutionLog.LogStart("GetResultObjectIdentity");
            if (result == null)
                throw new ArgumentNullException("result", "Execution result is not specified");

            if (result.Count < 1)
                throw new ArgumentException("Execution result is empty", "result");

            if (result.Count > 1)
                throw new ArgumentException("Execution result contains more than one object", "result");

            PSMemberInfo info = result[0].Members["Identity"];
            if (info == null)
                throw new ArgumentException("Execution result does not contain Identity property", "result");

            string ret = info.Value.ToString();
            HostedSolutionLog.LogEnd("GetResultObjectIdentity");
            return ret;
        }

        public static string GetResultObjectDN(Collection<PSObject> result)
        {
            HostedSolutionLog.LogStart("GetResultObjectDN");
            if (result == null)
                throw new ArgumentNullException("result", "Execution result is not specified");

            if (result.Count < 1)
                throw new ArgumentException("Execution result does not contain any object");

            if (result.Count > 1)
                throw new ArgumentException("Execution result contains more than one object");

            PSMemberInfo info = result[0].Members["DistinguishedName"];
            if (info == null)
                throw new ArgumentException("Execution result does not contain DistinguishedName property", "result");

            string ret = info.Value.ToString();
            HostedSolutionLog.LogEnd("GetResultObjectDN");
            return ret;
        }
    }
}
