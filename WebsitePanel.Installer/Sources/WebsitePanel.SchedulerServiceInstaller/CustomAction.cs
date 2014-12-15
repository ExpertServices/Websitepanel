// Copyright (c) 2012, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.Configuration.Install;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text.RegularExpressions;
using System.Threading;
using Microsoft.Deployment.WindowsInstaller;
using WebsitePanel.Setup;

namespace WebsitePanel.SchedulerServiceInstaller
{
    public class CustomActions
    {
        [CustomAction]
        public static ActionResult CheckConnection(Session session)
        {
            string testConnectionString = session["AUTHENTICATIONTYPE"].Equals("Windows Authentication") ? GetConnectionString(session["SERVERNAME"], "master") : GetConnectionString(session["SERVERNAME"], "master", session["LOGIN"], session["PASSWORD"]);

            if (CheckConnection(testConnectionString))
            {
                session["CORRECTCONNECTION"] = "1";
                session["CONNECTIONSTRING"] = session["AUTHENTICATIONTYPE"].Equals("Windows Authentication") ? GetConnectionString(session["SERVERNAME"], session["DATABASENAME"]) : GetConnectionString(session["SERVERNAME"], session["DATABASENAME"], session["LOGIN"], session["PASSWORD"]);
            }
            else
            {
                session["CORRECTCONNECTION"] = "0";
            }

            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult FinalizeInstall(Session session)
        {
            ChangeConfigString("installer.connectionstring", session["CONNECTIONSTRING"], session["INSTALLFOLDER"]);
            ChangeCryptoKey(session["INSTALLFOLDER"]);
            InstallService(session["INSTALLFOLDER"]);

            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult FinalizeUnInstall(Session session)
        {
            UnInstallService();

            return ActionResult.Success;
        }

        private static void InstallService(string installFolder)
        {
            try
            {
                var schedulerService =
                    ServiceController.GetServices().FirstOrDefault(
                        s => s.DisplayName.Equals("WebsitePanel Scheduler", StringComparison.CurrentCultureIgnoreCase));

                if (schedulerService != null)
                {
                    StopService(schedulerService.ServiceName);

                    SecurityUtils.DeleteService(schedulerService.ServiceName);
                }

                ManagedInstallerClass.InstallHelper(new[] { "/i", Path.Combine(installFolder, "WebsitePanel.SchedulerService.exe") });

                StartService("WebsitePanel Scheduler");
            }
            catch (Exception)
            {
            }
        }

        private static void UnInstallService()
        {
            try
            {
                var schedulerService =
                    ServiceController.GetServices().FirstOrDefault(
                        s => s.DisplayName.Equals("WebsitePanel Scheduler", StringComparison.CurrentCultureIgnoreCase));

                if (schedulerService != null)
                {
                    StopService(schedulerService.ServiceName);

                    SecurityUtils.DeleteService(schedulerService.ServiceName);
                }
            }
            catch (Exception)
            {
            }
        }

        private static void ChangeCryptoKey(string installFolder)
        {
            string path = Path.Combine(installFolder.Replace("SchedulerService", "Enterprise Server"), "web.config");            
            string cryptoKey = "0123456789";

            if (File.Exists(path))
            {
                using (var reader = new StreamReader(path))
                {
                    string content = reader.ReadToEnd();
                    var pattern = new Regex(@"(?<=<add key=""WebsitePanel.CryptoKey"" .*?value\s*=\s*"")[^""]+(?="".*?>)");                    
                    Match match = pattern.Match(content);                    
                    cryptoKey = match.Value;
                }
            }            

            ChangeConfigString("installer.cryptokey", cryptoKey, installFolder);
        }

        private static void ChangeConfigString(string searchString, string replaceValue, string installFolder)
        {
            string content;
            string path = Path.Combine(installFolder, "WebsitePanel.SchedulerService.exe.config");

            using (var reader = new StreamReader(path))
            {
                content = reader.ReadToEnd();
            }

            var re = new Regex("\\$\\{" + searchString + "\\}+", RegexOptions.IgnoreCase);
            content = re.Replace(content, replaceValue);

            using (var writer = new StreamWriter(path))
            {
                writer.Write(content);
            }
        }

        private static void StopService(string serviceName)
        {
            var sc = new ServiceController(serviceName);

            if (sc.Status == ServiceControllerStatus.Running)
            {
                sc.Stop();
                sc.WaitForStatus(ServiceControllerStatus.Stopped);
            }
        }

        private static void StartService(string serviceName)
        {
            var sc = new ServiceController(serviceName);

            if (sc.Status == ServiceControllerStatus.Stopped)
            {
                sc.Start();
                sc.WaitForStatus(ServiceControllerStatus.Running);
            }
        }

        private static string GetConnectionString(string serverName, string databaseName)
        {
            return string.Format("Server={0};database={1};Trusted_Connection=true;", serverName, databaseName);
        }

        private static string GetConnectionString(string serverName, string databaseName, string login, string password)
        {
            return string.Format("Server={0};database={1};uid={2};password={3};", serverName, databaseName, login, password);
        }

        private static bool CheckConnection(string connectionString)
        {
            var connection = new SqlConnection(connectionString);
            bool result = true;

            try
            {
                connection.Open();
            }
            catch (Exception)
            {
                result = false;
            }
            finally
            {
                if (connection != null && connection.State == ConnectionState.Open)
                {
                    connection.Close();
                }
            }

            return result;
        }
    }
}