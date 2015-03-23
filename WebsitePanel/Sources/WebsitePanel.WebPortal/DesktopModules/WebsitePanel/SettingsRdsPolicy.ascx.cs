using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.Portal
{
    public partial class SettingsRdsPolicy : WebsitePanelControlBase, IUserSettingsEditorControl
    {
        private const string LOCK_SCREEN_TIMEOUT_VALUE = "LockScreenTimeoutValue";
        private const string LOCK_SCREEN_TIMEOUT_ADMINISTRATORS = "LockScreenTimeoutAdministrators";
        private const string LOCK_SCREEN_TIMEOUT_USERS = "LockScreenTimeoutUsers";
        private const string REMOVE_RUN_COMMAND_ADMINISTRATORS = "RemoveRunCommandAdministrators";
        private const string REMOVE_RUN_COMMAND_USERS = "RemoveRunCommandUsers";
        private const string REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS = "RemovePowershellCommandAdministrators";
        private const string REMOVE_POWERSHELL_COMMAND_USERS = "RemovePowershellCommandUsers";
        private const string HIDE_C_DRIVE_ADMINISTRATORS = "HideCDriveAdministrators";
        private const string HIDE_C_DRIVE_USERS = "HideCDriveUsers";
        private const string REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS = "RemoveShutdownRestartAdministrators";
        private const string REMOVE_SHUTDOWN_RESTART_USERS = "RemoveShutdownRestartUsers";
        private const string DISABLE_TASK_MANAGER_ADMINISTRATORS = "DisableTaskManagerAdministrators";
        private const string DISABLE_TASK_MANAGER_USERS = "DisableTaskManagerUsers";
        private const string CHANGE_DESKTOP_DISABLED_ADMINISTRATORS = "ChangingDesktopDisabledAdministrators";
        private const string CHANGE_DESKTOP_DISABLED_USERS = "ChangingDesktopDisabledUsers";
        private const string SCREEN_SAVER_DISABLED_ADMINISTRATORS = "ScreenSaverDisabledAdministrators";
        private const string SCREEN_SAVER_DISABLED_USERS = "ScreenSaverDisabledUsers";
        private const string DRIVE_SPACE_THRESHOLD_VALUE = "DriveSpaceThresholdValue";

        public void BindSettings(UserSettings settings)
        {            
            txtTimeout.Text = settings[LOCK_SCREEN_TIMEOUT_VALUE];
            cbTimeoutAdministrators.Checked = Convert.ToBoolean(settings[LOCK_SCREEN_TIMEOUT_ADMINISTRATORS]);
            cbTimeoutUsers.Checked = Convert.ToBoolean(settings[LOCK_SCREEN_TIMEOUT_USERS]);

            cbRunCommandAdministrators.Checked = Convert.ToBoolean(settings[REMOVE_RUN_COMMAND_ADMINISTRATORS]);
            cbRunCommandUsers.Checked = Convert.ToBoolean(settings[REMOVE_RUN_COMMAND_USERS]);

            cbPowershellAdministrators.Checked = Convert.ToBoolean(settings[REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS]);
            cbPowershellUsers.Checked = Convert.ToBoolean(settings[REMOVE_POWERSHELL_COMMAND_USERS]);

            cbHideCDriveAdministrators.Checked = Convert.ToBoolean(settings[HIDE_C_DRIVE_ADMINISTRATORS]);
            cbHideCDriveUsers.Checked = Convert.ToBoolean(settings[HIDE_C_DRIVE_USERS]);

            cbShutdownAdministrators.Checked = Convert.ToBoolean(settings[REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS]);
            cbShutdownUsers.Checked = Convert.ToBoolean(settings[REMOVE_SHUTDOWN_RESTART_USERS]);

            cbTaskManagerAdministrators.Checked = Convert.ToBoolean(settings[DISABLE_TASK_MANAGER_ADMINISTRATORS]);
            cbTaskManagerUsers.Checked = Convert.ToBoolean(settings[DISABLE_TASK_MANAGER_USERS]);

            cbDesktopAdministrators.Checked = Convert.ToBoolean(settings[CHANGE_DESKTOP_DISABLED_ADMINISTRATORS]);
            cbDesktopUsers.Checked = Convert.ToBoolean(settings[CHANGE_DESKTOP_DISABLED_USERS]);

            cbScreenSaverAdministrators.Checked = Convert.ToBoolean(settings[SCREEN_SAVER_DISABLED_ADMINISTRATORS]);
            cbScreenSaverUsers.Checked = Convert.ToBoolean(settings[SCREEN_SAVER_DISABLED_USERS]);

            txtThreshold.Text = settings[DRIVE_SPACE_THRESHOLD_VALUE];
        }

        public void SaveSettings(UserSettings settings)
        {
            settings[LOCK_SCREEN_TIMEOUT_VALUE] = txtTimeout.Text;
            settings[LOCK_SCREEN_TIMEOUT_ADMINISTRATORS] = cbTimeoutAdministrators.Checked.ToString();
            settings[LOCK_SCREEN_TIMEOUT_USERS] = cbTimeoutUsers.Checked.ToString();
            settings[REMOVE_RUN_COMMAND_ADMINISTRATORS] = cbRunCommandAdministrators.Checked.ToString();
            settings[REMOVE_RUN_COMMAND_USERS] = cbRunCommandUsers.Checked.ToString();
            settings[REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS] = cbPowershellAdministrators.Checked.ToString();
            settings[REMOVE_POWERSHELL_COMMAND_USERS] = cbPowershellUsers.Checked.ToString();
            settings[HIDE_C_DRIVE_ADMINISTRATORS] = cbHideCDriveAdministrators.Checked.ToString();
            settings[HIDE_C_DRIVE_USERS] = cbHideCDriveUsers.Checked.ToString();
            settings[REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS] = cbShutdownAdministrators.Checked.ToString();
            settings[REMOVE_SHUTDOWN_RESTART_USERS] = cbShutdownUsers.Checked.ToString();
            settings[DISABLE_TASK_MANAGER_ADMINISTRATORS] = cbTaskManagerAdministrators.Checked.ToString();
            settings[DISABLE_TASK_MANAGER_USERS] = cbTaskManagerUsers.Checked.ToString();
            settings[CHANGE_DESKTOP_DISABLED_ADMINISTRATORS] = cbDesktopAdministrators.Checked.ToString();
            settings[CHANGE_DESKTOP_DISABLED_USERS] = cbDesktopUsers.Checked.ToString();
            settings[SCREEN_SAVER_DISABLED_ADMINISTRATORS] = cbScreenSaverAdministrators.Checked.ToString();
            settings[SCREEN_SAVER_DISABLED_USERS] = cbScreenSaverUsers.Checked.ToString();
            settings[DRIVE_SPACE_THRESHOLD_VALUE] = txtThreshold.Text;
        }
    }
}