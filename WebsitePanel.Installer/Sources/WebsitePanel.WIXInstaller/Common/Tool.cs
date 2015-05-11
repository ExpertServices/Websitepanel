using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Microsoft.Deployment.WindowsInstaller;
using Microsoft.Win32;
using WebsitePanel.Setup;

namespace WebsitePanel.WIXInstaller.Common
{
    internal static class Tool
    {
        public const int MINIMUM_WEBSERVER_MAJOR_VERSION = 6;
        public static SetupVariables GetSetupVars(Session Ctx)
        {
            return new SetupVariables
                {
                    SetupAction = SetupActions.Install,
                    IISVersion = Global.IISVersion
                };
        }
        public static Version GetWebServerVersion()
        {
            var WebServerKey = "SOFTWARE\\Microsoft\\InetStp";
            RegistryKey Key = Registry.LocalMachine.OpenSubKey(WebServerKey);
            if (Key == null)
                return new Version(0,0);
            var Major = int.Parse(Key.GetValue("MajorVersion", 0).ToString());
            var Minor = int.Parse(Key.GetValue("MinorVersion", 0).ToString());
            return new Version(Major, Minor);
        }
        public static bool GetIsWebRoleInstalled()
        {
            var WebServer = GetWebServerVersion();
            return WebServer.Major >= Tool.MINIMUM_WEBSERVER_MAJOR_VERSION;
        }
        public static bool GetIsWebFeaturesInstalled()
        {
            bool Result = false;
            var LMKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32);
            Result |= CheckAspNetRegValue(LMKey);
            LMKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64);
            Result |= CheckAspNetRegValue(LMKey);
            return Result;
        }
        public static bool CheckAspNetRegValue(RegistryKey BaseKey)
        {
            var WebComponentsKey = "SOFTWARE\\Microsoft\\InetStp\\Components";
            var AspNet = "ASPNET";
            var AspNet45 = "ASPNET45";
            RegistryKey Key = BaseKey.OpenSubKey(WebComponentsKey);
            if (Key == null)
                return false;
            var Value = int.Parse(Key.GetValue(AspNet, 0).ToString());
            if (Value != 1)
                Value = int.Parse(Key.GetValue(AspNet45, 0).ToString());
            return Value == 1;
        }
        public static bool InstallWebRole(out string Msg)
        {
            Msg = string.Empty;
            var OSV = Global.OSVersion;
            switch (OSV)
            {
                case OS.WindowsVersion.WindowsServer2008:
                    {
                        var Features = new[]
                        { 
                            "Web-Server"
                        };
                        Msg = InstallWebViaServerManagerCmd(Features);
                    }
                    break;
                case OS.WindowsVersion.WindowsServer2008R2:
                case OS.WindowsVersion.WindowsServer2012:
                case OS.WindowsVersion.WindowsServer2012R2:
                case OS.WindowsVersion.Windows7:
                case OS.WindowsVersion.Windows8:
                    {
                        var Features = new[]
                        { 
                            "IIS-WebServer",
                            "IIS-WebServerRole",                
                            "IIS-CommonHttpFeatures",
                            "IIS-DefaultDocument",
                            "IIS-ISAPIExtensions",
                            "IIS-ISAPIFilter",
                            "IIS-ManagementConsole",
                            "IIS-NetFxExtensibility",
                            "IIS-RequestFiltering",
                            "IIS-Security",
                            "IIS-StaticContent"                
                        };
                        Msg = InstallWebViaDism(Features);
                    }
                    break;
                default:
                    return false;
            }
            return true;
        }
        public static bool InstallWebFeatures(out string Msg)
        {
            Msg = string.Empty;
            var OSV = Global.OSVersion;
            switch (OSV)
            {
                case OS.WindowsVersion.WindowsServer2008:
                    {
                        var Features = new[]
                        {
                            "Web-Asp-Net"              
                        };
                        Msg += InstallWebViaServerManagerCmd(Features);
                        Msg += PrepareAspNet();
                    }
                    break;
                case OS.WindowsVersion.WindowsServer2008R2:
                case OS.WindowsVersion.WindowsServer2012:
                case OS.WindowsVersion.WindowsServer2012R2:
                case OS.WindowsVersion.Windows7:
                case OS.WindowsVersion.Windows8:
                    {
                        var Features = new[]
                        { 
                            "IIS-ApplicationDevelopment",
                            "IIS-ASPNET",
                            "IIS-ASPNET45"
                        };
                        Msg = InstallWebViaDism(Features);
                    }
                    break;
                default:
                    return false;
            }
            return true;
        }
        public static string PrepareAspNet()
        {
            var Cmd = string.Format(@"Microsoft.NET\Framework{0}\v4.0.30319\aspnet_regiis.exe", Environment.Is64BitOperatingSystem ? "64" : "" );
            return RunTool(Path.Combine(OS.GetWindowsDirectory(), Cmd), "-i -enable");
        }
        private static string InstallWebViaDism(params string[] Features)
        {
            var Params = string.Format("/NoRestart /Online /Enable-Feature {0}",
                                       string.Join(" ", Features.Select(
                                           Feature => string.Format("/FeatureName:{0} /All", Feature)
                                       )));
            return RunTool(Path.Combine(OS.GetWindowsDirectory(), @"SysNative\dism.exe"), Params);
        }
        private static string InstallWebViaServerManagerCmd(params string[] Features)
        {
            var Params = string.Format("-install {0}",
                                       string.Join(" ", Features)
                                       );
            return RunTool(Path.Combine(OS.GetWindowsDirectory(), @"SysNative\servermanagercmd.exe"), Params);
        }
        private static string RunTool(string Name, string Params)
        {
            var ToolProcessInfo = new ProcessStartInfo
            {
                FileName = Name,
                Arguments = Params,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                CreateNoWindow = true,
                WindowStyle = ProcessWindowStyle.Hidden
            };
            using (var ToolProcess = Process.Start(ToolProcessInfo))
            {
                var Result = ToolProcess.StandardOutput.ReadToEnd();
                ToolProcess.WaitForExit();
                return Result;
            }
        }
    }
}
