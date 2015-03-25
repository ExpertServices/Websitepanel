using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.EnterpriseServer.Base.RDS;

namespace WebsitePanel.Portal.RDS
{
    public partial class RDSEditUserExperience : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                litCollectionName.Text = collection.DisplayName;
                BindSettings();
            }
        }

        private void BindSettings()
        {
            var serverSettings = ES.Services.RDS.GetRdsServerSettings(PanelRequest.CollectionID, string.Format("Collection-{0}-Settings", PanelRequest.CollectionID));

            if (serverSettings == null)
            {
                var defaultSettings = ES.Services.Users.GetUserSettings(PanelSecurity.LoggedUserId, UserSettings.RDS_POLICY);
                BindDefaultSettings(defaultSettings);
            }
            else
            {
                BindSettings(serverSettings);
            }
        }

        private void BindSettings(RdsServerSettings settings)
        {

        }

        private RdsServerSettings GetSettings()
        {
            //settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_VALUE] = txtTimeout.Text;
            //settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_ADMINISTRATORS] = cbTimeoutAdministrators.Checked.ToString();
            //settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_USERS] = cbTimeoutUsers.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_RUN_COMMAND_ADMINISTRATORS] = cbRunCommandAdministrators.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_RUN_COMMAND_USERS] = cbRunCommandUsers.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS] = cbPowershellAdministrators.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_POWERSHELL_COMMAND_USERS] = cbPowershellUsers.Checked.ToString();
            //settings[RdsServerSettings.HIDE_C_DRIVE_ADMINISTRATORS] = cbHideCDriveAdministrators.Checked.ToString();
            //settings[RdsServerSettings.HIDE_C_DRIVE_USERS] = cbHideCDriveUsers.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS] = cbShutdownAdministrators.Checked.ToString();
            //settings[RdsServerSettings.REMOVE_SHUTDOWN_RESTART_USERS] = cbShutdownUsers.Checked.ToString();
            //settings[RdsServerSettings.DISABLE_TASK_MANAGER_ADMINISTRATORS] = cbTaskManagerAdministrators.Checked.ToString();
            //settings[RdsServerSettings.DISABLE_TASK_MANAGER_USERS] = cbTaskManagerUsers.Checked.ToString();
            //settings[RdsServerSettings.CHANGE_DESKTOP_DISABLED_ADMINISTRATORS] = cbDesktopAdministrators.Checked.ToString();
            //settings[RdsServerSettings.CHANGE_DESKTOP_DISABLED_USERS] = cbDesktopUsers.Checked.ToString();
            //settings[RdsServerSettings.SCREEN_SAVER_DISABLED_ADMINISTRATORS] = cbScreenSaverAdministrators.Checked.ToString();
            //settings[RdsServerSettings.SCREEN_SAVER_DISABLED_USERS] = cbScreenSaverUsers.Checked.ToString();
            //settings[RdsServerSettings.DRIVE_SPACE_THRESHOLD_VALUE] = txtThreshold.Text;

            var settings = new RdsServerSettings();
            //settings.Settings.Add(new RdsServerSetting{
            //    PropertyName = RdsServerSettings.LOCK_SCREEN_TIMEOUT_VALUE,
            //    PropertyValue = txtTimeout.Text
            //})

            return settings;
        }

        private void BindDefaultSettings(UserSettings settings)
        {
            txtTimeout.Text = settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_VALUE];
            cbTimeoutAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_ADMINISTRATORS]);
            cbTimeoutUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_USERS]);

            cbRunCommandAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_RUN_COMMAND_ADMINISTRATORS]);
            cbRunCommandUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_RUN_COMMAND_USERS]);

            cbPowershellAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_POWERSHELL_COMMAND_ADMINISTRATORS]);
            cbPowershellUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_POWERSHELL_COMMAND_USERS]);

            cbHideCDriveAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.HIDE_C_DRIVE_ADMINISTRATORS]);
            cbHideCDriveUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.HIDE_C_DRIVE_USERS]);

            cbShutdownAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_SHUTDOWN_RESTART_ADMINISTRATORS]);
            cbShutdownUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.REMOVE_SHUTDOWN_RESTART_USERS]);

            cbTaskManagerAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.DISABLE_TASK_MANAGER_ADMINISTRATORS]);
            cbTaskManagerUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.DISABLE_TASK_MANAGER_USERS]);

            cbDesktopAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.CHANGE_DESKTOP_DISABLED_ADMINISTRATORS]);
            cbDesktopUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.CHANGE_DESKTOP_DISABLED_USERS]);

            cbScreenSaverAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.SCREEN_SAVER_DISABLED_ADMINISTRATORS]);
            cbScreenSaverUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.SCREEN_SAVER_DISABLED_USERS]);

            txtThreshold.Text = settings[RdsServerSettings.DRIVE_SPACE_THRESHOLD_VALUE];
        }

        private bool SaveServerSettings()
        {
            try
            {
                ES.Services.RDS.UpdateRdsServerSettings(PanelRequest.CollectionID, string.Format("Collection-{0}-Settings", PanelRequest.CollectionID), GetSettings());
            }
            catch (Exception ex)
            {
                ShowErrorMessage("RDSLOCALADMINS_NOT_ADDED", ex);
                return false;
            }

            return true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            SaveServerSettings();
        }

        protected void btnSaveExit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            if (SaveServerSettings())
            {
                Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "rds_collections", "SpaceID=" + PanelSecurity.PackageId));
            }
        }
    }
}