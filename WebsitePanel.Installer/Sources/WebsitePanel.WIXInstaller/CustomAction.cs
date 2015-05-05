// Copyright (c) 2015, Outercurve Foundation.
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
using System.Collections.Generic;
using System.Configuration.Install;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.ServiceProcess;
using System.Text.RegularExpressions;
using System.Xml;
using Microsoft.Deployment.WindowsInstaller;
using WebsitePanel.Setup;
using WebsitePanel.Setup.Internal;
using WebsitePanel.WIXInstaller.Common;
using WebsitePanel.WIXInstaller.Common.Util;

namespace WebsitePanel.WIXInstaller
{
    public class CustomActions
    {
        public static List<string> SysDb = new List<string> { "tempdb", "master", "model", "msdb" };
        public const string CustomDataDelimiter = "-=del=-";

        #region CustomActions
        [CustomAction]
        public static ActionResult InstallWebFeatures(Session session)
        {
            var Msg = string.Empty;
            var Ctx = session;
            Ctx.AttachToSetupLog();
            var Result = ActionResult.Success;
            try
            {
                Log.WriteStart("InstallWebFeatures");
                if(Tool.GetIsWebRoleInstalled())
                {                    
                    if (!Tool.GetIsWebFeaturesInstalled())
                    {
                        Log.WriteInfo("InstallWebFeatures: ASP.NET.");
                        Tool.InstallWebFeatures(out Msg);
                    }
                }
                else
                {
                    var Tmp = string.Empty;
                    Log.WriteInfo("InstallWebFeatures: IIS and ASP.NET.");
                    Tool.InstallWebRole(out Tmp);
                    Msg += Tmp;
                    Tool.InstallWebFeatures(out Tmp);
                    Msg += Tmp;
                }
                Log.WriteInfo("InstallWebFeatures: done.");
            }
            catch(Exception ex)
            {
                Log.WriteError(string.Format("InstallWebFeatures: fail - {0}.", ex.ToString()));
                Result = ActionResult.Failure;
            }
            if(!string.IsNullOrWhiteSpace(Msg))
                Log.WriteInfo(string.Format("InstallWebFeatures Tool Log: {0}.", Msg));
            Log.WriteEnd("InstallWebFeatures");
            return Result;
        }
        // Install.
        [CustomAction]
        public static ActionResult OnServerInstall(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.InstallServer);
        }
        [CustomAction]
        public static ActionResult OnEServerInstall(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.InstallEnterpriseServer);
        }
        [CustomAction]
        public static ActionResult OnPortalInstall(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.InstallPortal);
        }
        // Remove.
        [CustomAction]
        public static ActionResult OnServerRemove(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.RemoveServer);
        }
        [CustomAction]
        public static ActionResult OnEServerRemove(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.RemoveEnterpriseServer);
        }
        [CustomAction]
        public static ActionResult OnPortalRemove(Session session)
        {
            PopUpDebugger();
            return ProcessInstall(session, WiXInstallType.RemovePortal);
        }
        // Other.
        [CustomAction]
        public static ActionResult SetEServerUrlUI(Session session)
        {
            var Ctx = session;
            Ctx["PI_ESERVER_URL"] = string.Format("http://{0}:{1}/", Ctx["PI_ESERVER_IP"], Ctx["PI_ESERVER_PORT"]);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult RecapListUI(Session session)
        {
            const string F_WSP = "WebsitePanel";
            const string F_Server = "ServerFeature";
            const string F_EServer = "EnterpriseServerFeature";
            const string F_Portal = "PortalFeature";
            const string F_Scheduler = "SchedulerServiceFeature";
            const string F_WDPosrtal = "WDPortalFeature";
            var S_Install = new List<string> { "Copy WebsitePanel Server files", "Add WebsitePanel Server website" };
            var ES_Install = new List<string> { "Copy WebsitePanel Enterprise Server files", "Install WebsitePanel database and updates", "Add WebsitePanel Enterprise Server website" };
            var P_Install = new List<string> { "Copy WebsitePanel Portal files", "Add WebsitePanel Enterprise Portal website" };
            var SCH_Install = new List<string> { "Copy WebsitePanel Scheduler Service files", "Install Scheduler Service Windows Service" };
            var WDP_Install = new List<string> { "Copy WebsitePanel WebDav Portal files" };
            var S_Uninstall = new List<string> { "Delete WebsitePanel Server files", "Remove WebsitePanel Server website" };
            var ES_Uninstall = new List<string> { "Delete WebsitePanel Enterprise Server files", "Keep WebsitePanel database and updates", "Remove WebsitePanel Enterprise Server website" };
            var P_Uninstall = new List<string> { "Delete WebsitePanel Portal files", "Remove WebsitePanel Enterprise Portal website" };
            var SCH_Uninstall = new List<string> { "Delete WebsitePanel Scheduler Service files", "Remove Scheduler Service Windows Service" };
            var WDP_Uninstall = new List<string> { "Delete WebsitePanel WebDav Portal files" };
            var RecapList = new List<string>();
            var EmptyList = new List<string>();
            var Ctx = session;
            RecapListReset(Ctx);
            foreach (var Feature in Ctx.Features)
            {
                switch (Feature.Name)
                {
                    case F_WSP:
                        break;
                    case F_Server:
                        RecapList.AddRange(Feature.RequestState == InstallState.Local ? S_Install : /*S_Uninstall*/ EmptyList);
                        break;
                    case F_EServer:
                        RecapList.AddRange(Feature.RequestState == InstallState.Local ? ES_Install : /*ES_Uninstall*/ EmptyList);
                        break;
                    case F_Portal:
                        RecapList.AddRange(Feature.RequestState == InstallState.Local ? P_Install : /*P_Uninstall*/ EmptyList);
                        break;
                    case F_Scheduler:
                        RecapList.AddRange(Feature.RequestState == InstallState.Local ? SCH_Install : /*SCH_Uninstall*/ EmptyList);
                        break;
                    case F_WDPosrtal:
                        RecapList.AddRange(Feature.RequestState == InstallState.Local ? WDP_Install : /*WDP_Uninstall*/ EmptyList);
                        break;
                    default:
                        break;
                }
            }
            RecapListAdd(Ctx, RecapList.ToArray());
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult DatabaseConnectionValidateUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidateDbNameUI(Ctx, out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult ServerAdminValidateUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidatePasswordUI(Ctx, "SERVERADMIN", out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult ServerValidateADUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidateADUI(Ctx, "PI_SERVER", out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult EServerValidateADUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidateADUI(Ctx, "PI_ESERVER", out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult PortalValidateADUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidateADUI(Ctx, "PI_PORTAL", out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult ServerAccessValidateUI(Session session)
        {
            var Ctx = session;
            bool Valid = true;
            string Msg;
            ValidationReset(Ctx);
            Valid = ValidatePasswordUI(Ctx, "SERVER_ACCESS", out Msg);
            ValidationMsg(Ctx, Msg);
            ValidationStatus(Ctx, Valid);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult SqlServerListUI(Session session)
        {
            var Ctx = session;
            var SrvList = new ComboBoxCtrl(Ctx, "DB_SERVER");
            foreach (var Srv in GetSqlInstances())
                SrvList.AddItem(Srv);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult DbListUI(Session session)
        {
            string tmp;
            var Ctrl = new ComboBoxCtrl(session, "DB_SELECT");
            if (CheckConnection(session["DB_CONN"], out tmp))
                foreach (var Db in GetDbList(ConnStr: session["DB_CONN"], ForbiddenNames: SysDb))
                {
                    Ctrl.AddItem(Db);
                    session["DB_SELECT"] = Db; // Adds available DBs to installer log.
                }
            else
                session["DB_SELECT"] = "";
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult CheckConnectionUI(Session session)
        {
            string ConnStr = session["DB_AUTH"].Equals("Windows Authentication") ? GetConnectionString(session["DB_SERVER"], "master") :
                                                                                   GetConnectionString(session["DB_SERVER"], "master", session["DB_LOGIN"], session["DB_PASSWORD"]);
            string msg;
            bool Result = CheckConnection(ConnStr, out msg);
            session["DB_CONN_CORRECT"] = Result ? "1" : "0";
            session["DB_CONN"] = Result ? ConnStr : "";
            session["DB_CONN_MSG"] = msg;
            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult FinalizeInstall(Session session)
        {
            /*var connectionString = GetCustomActionProperty(session, "ConnectionString").Replace(CustomDataDelimiter, ";");
            var serviceFolder = GetCustomActionProperty(session, "ServiceFolder");
            var previousConnectionString = GetCustomActionProperty(session, "PreviousConnectionString").Replace(CustomDataDelimiter, ";");
            var previousCryptoKey = GetCustomActionProperty(session, "PreviousCryptoKey");

            if (string.IsNullOrEmpty(serviceFolder))
            {
                return ActionResult.Success;
            }

            connectionString = string.IsNullOrEmpty(previousConnectionString)
                ? connectionString
                : previousConnectionString;

            ChangeConfigString("/configuration/connectionStrings/add[@name='EnterpriseServer']", "connectionString", connectionString, serviceFolder);
            ChangeConfigString("/configuration/appSettings/add[@key='WebsitePanel.CryptoKey']", "value", previousCryptoKey, serviceFolder);
            InstallService(serviceFolder);*/

            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult FinalizeUnInstall(Session session)
        {
           // UnInstallService();

            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult PreInstallationAction(Session session)
        {
            session["SKIPCONNECTIONSTRINGSTEP"] = "0";

            session["SERVICEFOLDER"] = session["INSTALLFOLDER"];

            var servicePath = /*SecurityUtils.GetServicePath("WebsitePanel Scheduler")*/"";

            if (!string.IsNullOrEmpty(servicePath))
            {
                string path = Path.Combine(servicePath, "WebsitePanel.SchedulerService.exe.config");

                if (File.Exists(path))
                {
                    using (var reader = new StreamReader(path))
                    {
                        string content = reader.ReadToEnd();
                        var pattern = new Regex(@"(?<=<add key=""WebsitePanel.CryptoKey"" .*?value\s*=\s*"")[^""]+(?="".*?>)");
                        Match match = pattern.Match(content);
                        session["PREVIOUSCRYPTOKEY"] = match.Value;

                        var connectionStringPattern = new Regex(@"(?<=<add name=""EnterpriseServer"" .*?connectionString\s*=\s*"")[^""]+(?="".*?>)");
                        match = connectionStringPattern.Match(content);
                        session["PREVIOUSCONNECTIONSTRING"] = match.Value.Replace(";", CustomDataDelimiter);
                    }

                    session["SKIPCONNECTIONSTRINGSTEP"] = "1";

                    if (string.IsNullOrEmpty(session["SERVICEFOLDER"]))
                    {
                        session["SERVICEFOLDER"] = servicePath;
                    }
                }

            }

            return ActionResult.Success;
        }

        [CustomAction]
        public static ActionResult PrereqCheck(Session session)
        {
            string Msg;
            var Ctx = Tool.GetSetupVars(session);
            var ros = Adapter.CheckOS(Ctx, out Msg);
            AddLog(session, Msg);
            var riis = Adapter.CheckIIS(Ctx, out Msg);
            AddLog(session, Msg);
            var raspnet = Adapter.CheckASPNET(Ctx, out Msg);
            AddLog(session, Msg);
            session[Prop.REQ_OS] = ros == CheckStatuses.Success ? YesNo.Yes : YesNo.No;
            session[Prop.REQ_IIS] = riis == CheckStatuses.Success ? YesNo.Yes : YesNo.No; ;
            session[Prop.REQ_ASPNET] = raspnet == CheckStatuses.Success ? YesNo.Yes : YesNo.No; ;
            session[Prop.REQ_SERVER] = YesNo.Yes;
            session[Prop.REQ_ESERVER] = YesNo.Yes;
            session[Prop.REQ_PORTAL] = YesNo.Yes;
            session[Prop.REQ_WDPORTAL] = YesNo.Yes;
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult PrereqCheckUI(Session session)
        {
            var ListView = new ListViewCtrl(session, "REQCHECKLIST");
            AddCheck(ListView, session, Prop.REQ_OS);
            AddCheck(ListView, session, Prop.REQ_IIS);
            AddCheck(ListView, session, Prop.REQ_ASPNET);
            AddCheck(ListView, session, Prop.REQ_SERVER);
            AddCheck(ListView, session, Prop.REQ_ESERVER);
            AddCheck(ListView, session, Prop.REQ_PORTAL);
            AddCheck(ListView, session, Prop.REQ_WDPORTAL);
            return ActionResult.Success;
        }
        [CustomAction]
        public static ActionResult FillIpListUI(Session session)
        {
            var Ctrls = new[]{ new ComboBoxCtrl(session, "PI_SERVER_IP"),
                                new ComboBoxCtrl(session, "PI_ESERVER_IP"),
                                new ComboBoxCtrl(session, "PI_PORTAL_IP") };
            foreach (var Ip in GetIpList())
                foreach (var Ctrl in Ctrls)
                    Ctrl.AddItem(Ip);
            return ActionResult.Success;
        }

        #endregion
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

        private static void ChangeConfigString(string nodePath, string attrToChange, string value, string installFolder)
        {
            string path = Path.Combine(installFolder, "WebsitePanel.SchedulerService.exe.config");

            if (!File.Exists(path))
            {
                return;
            }

            XmlDocument xmldoc = new XmlDocument();
            xmldoc.Load(path);

            XmlElement node = xmldoc.SelectSingleNode(nodePath) as XmlElement;

            if (node != null)
            {
                node.SetAttribute(attrToChange, value);

                xmldoc.Save(path);
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
            return string.Format("Server={0};database={1};Trusted_Connection=true;", serverName, databaseName)/*.Replace(";", CustomDataDelimiter)*/;
        }

        private static string GetConnectionString(string serverName, string databaseName, string login, string password)
        {
            return string.Format("Server={0};database={1};uid={2};password={3};", serverName, databaseName, login, password)/*.Replace(";", CustomDataDelimiter)*/;
        }
        static bool CheckConnection(string ConnStr, out string Info)
        {
            Info = string.Empty;
            bool Result = false;
            using (var Conn = new SqlConnection(ConnStr))
            {
                try
                {
                    Conn.Open();
                    Result = true;
                }
                catch (Exception ex)
                {
                    Info = ex.Message;
                }
            }
            return Result;
        }

        private static string GetCustomActionProperty(Session session, string key)
        {
            if (session.CustomActionData.ContainsKey(key))
            {
                return session.CustomActionData[key].Replace("-=-", ";");
            }

            return string.Empty;
        }
        private static void AddCheck(ListViewCtrl view, Session session, string PropertyID)
        {
            view.AddItem(session[PropertyID] == YesNo.Yes, session[PropertyID + "_TITLE"]);
        }
        static IList<string> GetSqlInstances()
        {
            var Result = new List<string>();
            using (var Src = SqlDataSourceEnumerator.Instance.GetDataSources())
            {
                foreach (DataRow Row in Src.Rows)
                {
                    var Instance = Row["InstanceName"].ToString();
                    Result.Add((string.IsNullOrWhiteSpace(Instance) ? "" : (Instance + "\\")) + Row["ServerName"].ToString());
                }
            }
            return Result;
        }
        static IEnumerable<string> GetDbList(string ConnStr, IList<string> ForbiddenNames = null)
        {
            using (var Conn = new SqlConnection(ConnStr))
            {
                Conn.Open();
                var Cmd = Conn.CreateCommand();
                Cmd.CommandText = "SELECT name FROM master..sysdatabases";
                if (ForbiddenNames != null && ForbiddenNames.Count > 0)
                    Cmd.CommandText += string.Format(" WHERE name NOT IN ({0})", string.Join(", ", ForbiddenNames.Select(x => string.Format("'{0}'", x))));
                var Result = Cmd.ExecuteReader();
                while (Result.Read())
                    yield return Result["name"].ToString();
            }
        }
        static IEnumerable<string> GetIpList()
        {
            foreach (var Ni in NetworkInterface.GetAllNetworkInterfaces())
                if (Ni.OperationalStatus == OperationalStatus.Up && (Ni.NetworkInterfaceType == NetworkInterfaceType.Ethernet ||
                                                                     Ni.NetworkInterfaceType == NetworkInterfaceType.Wireless80211 ||
                                                                     Ni.NetworkInterfaceType == NetworkInterfaceType.Loopback))
                    foreach (var IpInfo in Ni.GetIPProperties().UnicastAddresses)
                        if (IpInfo.Address.AddressFamily == AddressFamily.InterNetwork)
                            yield return IpInfo.Address.ToString();
        }
        internal static void AddLog(Session Ctx, string Msg)
        {
            AddTo(Ctx, "PI_PREREQ_LOG", Msg);
        }
        internal static void AddTo(Session Ctx, string TextProp, string Msg)
        {
            if (!string.IsNullOrWhiteSpace(Msg))
            {
                string tmp = Ctx[TextProp];
                if (string.IsNullOrWhiteSpace(tmp))
                    Ctx[TextProp] = Msg;
                else
                    Ctx[TextProp] = tmp + Environment.NewLine + Msg;
            }
        }
        internal static void ValidationReset(Session Ctx)
        {
            Ctx["VALIDATE_OK"] = "0";
            Ctx["VALIDATE_MSG"] = "Error occurred.";
        }
        internal static void ValidationStatus(Session Ctx, bool Value)
        {
            Ctx["VALIDATE_OK"] = Value ? YesNo.Yes : YesNo.No;
        }
        internal static void ValidationMsg(Session Ctx, string Msg)
        {
            AddTo(Ctx, "VALIDATE_MSG", Msg);
        }
        internal static bool PasswordValidate(string Password, string Confirm, out string Msg)
        {
            Msg = string.Empty;
            bool Result = false;
            if (string.IsNullOrWhiteSpace(Password))
                Msg = "Empty password.";
            else if (Password != Confirm)
                Msg = "Password does not match the confirm password. Type both passwords again.";
            else
                Result = true;
            return Result;
        }
        internal static bool ValidatePasswordUI(Session Ctx, string Ns, out string Msg)
        {
            string p1 = Ctx[Ns + "_PASSWORD"];
            string p2 = Ctx[Ns + "_PASSWORD_CONFIRM"];
            return PasswordValidate(p1, p2, out Msg);
        }
        internal static bool ValidateADDomainUI(Session Ctx, string Ns, out string Msg)
        {
            bool Result = default(bool);
            bool check = Ctx[Ns + "_CREATE_AD"] == YesNo.Yes;
            string name = Ctx[Ns + "_DOMAIN"];
            if (check && string.IsNullOrWhiteSpace(name))
            {
                Result = false;
                Msg = "The domain can't be empty.";
            }
            else
            {
                Result = true;
                Msg = string.Empty;
            }
            return Result;
        }
        internal static bool ValidateADLoginUI(Session Ctx, string Ns, out string Msg)
        {
            bool Result = default(bool);
            string name = Ctx[Ns + "_LOGIN"];
            if (string.IsNullOrWhiteSpace(name))
            {
                Result = false;
                Msg = "The login can't be empty.";
            }
            else
            {
                Result = true;
                Msg = string.Empty;
            }
            return Result;
        }
        internal static bool ValidateADUI(Session Ctx, string Ns, out string Msg)
        {
            bool Result = true;
            if (!ValidateADDomainUI(Ctx, Ns, out Msg))
                Result = false;
            else if (!ValidateADLoginUI(Ctx, Ns, out Msg))
                Result = false;
            else if (!ValidatePasswordUI(Ctx, Ns, out Msg))
                Result = false;
            return Result;
        }
        internal static bool ValidateDbNameUI(Session Ctx, out string Msg)
        {
            Msg = string.Empty;
            var Result = true;
            string DbName = Ctx["DB_DATABASE"];
            if (string.IsNullOrWhiteSpace(DbName))
            {
                Result = false;
                Msg = "The database name can't be empty.";

            }
            return Result;
        }
        internal static void RecapListReset(Session Ctx)
        {
            Ctx["CUSTOM_INSTALL_TEXT"] = string.Empty;
        }
        internal static void RecapListAdd(Session Ctx, params string[] Msgs)
        {
            foreach (var Msg in Msgs)
                AddTo(Ctx, "CUSTOM_INSTALL_TEXT", Msg); ;
        }

        internal static string GetProperty(Session Ctx, string Property)
        {
            if (Ctx.CustomActionData.ContainsKey(Property))
                return Ctx[Property];
            else
                return string.Empty;
        }

        private static ActionResult ProcessInstall(Session Ctx, WiXInstallType InstallType)
        {
            IWiXSetup Install = null;
            try
            {
                Ctx.AttachToSetupLog();
                switch (InstallType)
                {
                    case WiXInstallType.InstallServer:
                        Install = ServerSetup.Create(Ctx.CustomActionData, SetupActions.Install);
                        break;
                    case WiXInstallType.RemoveServer:
                        Install = ServerSetup.Create(Ctx.CustomActionData, SetupActions.Uninstall);
                        break;
                    case WiXInstallType.InstallEnterpriseServer:
                        Install = EServerSetup.Create(Ctx.CustomActionData, SetupActions.Install);
                        break;
                    case WiXInstallType.RemoveEnterpriseServer:
                        Install = EServerSetup.Create(Ctx.CustomActionData, SetupActions.Uninstall);
                        break;
                    case WiXInstallType.InstallPortal:
                        Install = PortalSetup.Create(Ctx.CustomActionData, SetupActions.Install);
                        break;
                    case WiXInstallType.RemovePortal:
                        Install = PortalSetup.Create(Ctx.CustomActionData, SetupActions.Uninstall);
                        break;
                    default:
                        throw new NotImplementedException();
                }
                Install.Run();
            }
            catch (WiXSetupException we)
            {
                Ctx.Log("Expected exception: " + we.ToString());
                return ActionResult.Failure;
            }
            catch (Exception ex)
            {
                Ctx.Log(ex.ToString());
                return ActionResult.Failure;
            }
            return ActionResult.Success;
        }
        [Conditional("DEBUG")]
        private static void PopUpDebugger()
        {
            Debugger.Launch();
        }
    }
    public static class SessionExtension
    {
        public static void AttachToSetupLog(this Session Ctx)
        {
            WiXSetup.InstallLogListener(new WiXLogListener(Ctx));
            WiXSetup.InstallLogListener(new InMemoryStringLogListener("WIX CA IN MEMORY"));
        }
    }

    internal enum WiXInstallType: byte
    {
        InstallServer,
        InstallEnterpriseServer,
        InstallPortal,
        RemoveServer,
        RemoveEnterpriseServer,
        RemovePortal,
        RemoveUpdate,
        RestoreUpdate
    }    
}
