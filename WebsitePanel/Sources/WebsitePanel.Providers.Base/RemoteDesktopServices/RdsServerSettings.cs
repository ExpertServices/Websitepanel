using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace WebsitePanel.EnterpriseServer.Base.RDS
{
    public class RdsServerSettings
    {
        private List<RdsServerSetting> settings = null;

        public const string LOCK_SCREEN_TIMEOUT = "LockScreenTimeout";        
        public const string REMOVE_RUN_COMMAND = "RemoveRunCommand";        
        public const string REMOVE_POWERSHELL_COMMAND = "RemovePowershellCommand";        
        public const string HIDE_C_DRIVE = "HideCDrive";        
        public const string REMOVE_SHUTDOWN_RESTART = "RemoveShutdownRestart";        
        public const string DISABLE_TASK_MANAGER = "DisableTaskManager";
        public const string CHANGE_DESKTOP_DISABLED = "ChangingDesktopDisabled";        
        public const string SCREEN_SAVER_DISABLED = "ScreenSaverDisabled";        
        public const string DRIVE_SPACE_THRESHOLD = "DriveSpaceThreshold";

        public const string LOCK_SCREEN_TIMEOUT_VALUE = "LockScreenTimeoutValue";
        public const string LOCK_SCREEN_TIMEOUT_ADMINISTRATORS = "LockScreenTimeoutAdministrators";
        public const string LOCK_SCREEN_TIMEOUT_USERS = "LockScreenTimeoutUsers";
        public const string REMOVE_RUN_COMMAND_ADMINISTRATORS = "RemoveRunCommandAdministrators";
        public const string REMOVE_RUN_COMMAND_USERS = "RemoveRunCommandUsers";
        public const string REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS = "RemovePowershellCommandAdministrators";
        public const string REMOVE_POWERSHELL_COMMAND_USERS = "RemovePowershellCommandUsers";
        public const string HIDE_C_DRIVE_ADMINISTRATORS = "HideCDriveAdministrators";
        public const string HIDE_C_DRIVE_USERS = "HideCDriveUsers";
        public const string REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS = "RemoveShutdownRestartAdministrators";
        public const string REMOVE_SHUTDOWN_RESTART_USERS = "RemoveShutdownRestartUsers";
        public const string DISABLE_TASK_MANAGER_ADMINISTRATORS = "DisableTaskManagerAdministrators";
        public const string DISABLE_TASK_MANAGER_USERS = "DisableTaskManagerUsers";
        public const string CHANGE_DESKTOP_DISABLED_ADMINISTRATORS = "ChangingDesktopDisabledAdministrators";
        public const string CHANGE_DESKTOP_DISABLED_USERS = "ChangingDesktopDisabledUsers";
        public const string SCREEN_SAVER_DISABLED_ADMINISTRATORS = "ScreenSaverDisabledAdministrators";
        public const string SCREEN_SAVER_DISABLED_USERS = "ScreenSaverDisabledUsers";
        public const string DRIVE_SPACE_THRESHOLD_VALUE = "DriveSpaceThresholdValue";        

        public string SettingsName { get; set; }
        public int ServerId { get; set; }

        public List<RdsServerSetting> Settings
        {
            get
            {
                if (settings == null)
                {
                    settings = new List<RdsServerSetting>();
                }
                return settings;
            }
            set
            {
                settings = value;
            }
        }

        public static List<KeyValuePair<string, string>> ScreenSaverTimeOuts
        {
            get
            {
                return new List<KeyValuePair<string, string>> {
                    new KeyValuePair<string, string>("", "None"),
                    new KeyValuePair<string, string>("10", "10"),
                    new KeyValuePair<string, string>("20", "20"),
                    new KeyValuePair<string, string>("30", "30"),
                    new KeyValuePair<string, string>("40", "40"),
                    new KeyValuePair<string, string>("50", "50"),
                    new KeyValuePair<string, string>("60", "60")
                };
            }
        }
    }
}
