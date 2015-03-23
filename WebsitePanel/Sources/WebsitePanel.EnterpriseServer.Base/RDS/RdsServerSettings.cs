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
    }
}
