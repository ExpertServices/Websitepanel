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
                var timeouts = RdsServerSettings.ScreenSaverTimeOuts;
                ddTimeout.DataSource = timeouts;
                ddTimeout.DataTextField = "Value";
                ddTimeout.DataValueField = "Key";
                ddTimeout.DataBind();

                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                litCollectionName.Text = collection.DisplayName;
                BindSettings();
            }
        }

        private void BindSettings()
        {
            var serverSettings = ES.Services.RDS.GetRdsServerSettings(PanelRequest.CollectionID, string.Format("Collection-{0}-Settings", PanelRequest.CollectionID));

            if (serverSettings == null || !serverSettings.Settings.Any())
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
            var setting = GetServerSetting(settings, RdsServerSettings.LOCK_SCREEN_TIMEOUT);

            if (setting != null)
            {
                ddTimeout.SelectedValue = setting.PropertyValue;
                cbTimeoutAdministrators.Checked = setting.ApplyAdministrators;
                cbTimeoutUsers.Checked = setting.ApplyUsers;
            }

            SetCheckboxes(settings, RdsServerSettings.REMOVE_RUN_COMMAND, cbRunCommandAdministrators, cbRunCommandUsers);
            SetCheckboxes(settings, RdsServerSettings.REMOVE_POWERSHELL_COMMAND, cbPowershellAdministrators, cbPowershellUsers);
            SetCheckboxes(settings, RdsServerSettings.HIDE_C_DRIVE, cbHideCDriveAdministrators, cbHideCDriveUsers);
            SetCheckboxes(settings, RdsServerSettings.REMOVE_SHUTDOWN_RESTART, cbShutdownAdministrators, cbShutdownUsers);
            SetCheckboxes(settings, RdsServerSettings.DISABLE_TASK_MANAGER, cbTaskManagerAdministrators, cbTaskManagerUsers);
            SetCheckboxes(settings, RdsServerSettings.CHANGE_DESKTOP_DISABLED, cbDesktopAdministrators, cbDesktopUsers);
            SetCheckboxes(settings, RdsServerSettings.SCREEN_SAVER_DISABLED, cbScreenSaverAdministrators, cbScreenSaverUsers);
            SetCheckboxes(settings, RdsServerSettings.RDS_VIEW_WITHOUT_PERMISSION, cbViewSessionAdministrators, cbViewSessionUsers);
            SetCheckboxes(settings, RdsServerSettings.RDS_CONTROL_WITHOUT_PERMISSION, cbControlSessionAdministrators, cbControlSessionUsers);
            SetCheckboxes(settings, RdsServerSettings.DISABLE_CMD, cbDisableCmdAdministrators, cbDisableCmdUsers);

            setting = GetServerSetting(settings, RdsServerSettings.DRIVE_SPACE_THRESHOLD);

            if (setting != null)
            {
                ddTreshold.SelectedValue = setting.PropertyValue;
            }
        }

        private void SetCheckboxes(RdsServerSettings settings, string settingName, CheckBox cbAdministrators, CheckBox cbUsers)
        {
            var setting = GetServerSetting(settings, settingName);

            if (setting != null)
            {
                cbAdministrators.Checked = setting.ApplyAdministrators;
                cbUsers.Checked = setting.ApplyUsers;
            }
        }

        private RdsServerSetting GetServerSetting(RdsServerSettings settings, string propertyName)
        {
            return settings.Settings.FirstOrDefault(s => s.PropertyName.Equals(propertyName));
        }

        private RdsServerSettings GetSettings()
        {                                                                                               
            var settings = new RdsServerSettings();

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.LOCK_SCREEN_TIMEOUT,
                PropertyValue = ddTimeout.SelectedValue,
                ApplyAdministrators = cbTimeoutAdministrators.Checked,
                ApplyUsers = cbTimeoutUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.REMOVE_RUN_COMMAND,
                PropertyValue = "",
                ApplyAdministrators = cbRunCommandAdministrators.Checked,
                ApplyUsers = cbRunCommandUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.REMOVE_POWERSHELL_COMMAND,
                PropertyValue = "",
                ApplyAdministrators = cbPowershellAdministrators.Checked,
                ApplyUsers = cbPowershellUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.HIDE_C_DRIVE,
                PropertyValue = "",
                ApplyAdministrators = cbHideCDriveAdministrators.Checked,
                ApplyUsers = cbHideCDriveUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.REMOVE_SHUTDOWN_RESTART,
                PropertyValue = "",
                ApplyAdministrators = cbShutdownAdministrators.Checked,
                ApplyUsers = cbShutdownUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.DISABLE_TASK_MANAGER,
                PropertyValue = "",
                ApplyAdministrators = cbTaskManagerAdministrators.Checked,
                ApplyUsers = cbTaskManagerUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.CHANGE_DESKTOP_DISABLED,
                PropertyValue = "",
                ApplyAdministrators = cbDesktopAdministrators.Checked,
                ApplyUsers = cbDesktopUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.SCREEN_SAVER_DISABLED,
                PropertyValue = "",
                ApplyAdministrators = cbScreenSaverAdministrators.Checked,
                ApplyUsers = cbScreenSaverUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.DRIVE_SPACE_THRESHOLD,
                PropertyValue = ddTreshold.SelectedValue,
                ApplyAdministrators = true,
                ApplyUsers = true
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.RDS_VIEW_WITHOUT_PERMISSION,
                PropertyValue = "",
                ApplyAdministrators = cbViewSessionAdministrators.Checked,
                ApplyUsers = cbViewSessionUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.RDS_CONTROL_WITHOUT_PERMISSION,
                PropertyValue = "",
                ApplyAdministrators = cbControlSessionAdministrators.Checked,
                ApplyUsers = cbControlSessionUsers.Checked
            });

            settings.Settings.Add(new RdsServerSetting
            {
                PropertyName = RdsServerSettings.DISABLE_CMD,
                PropertyValue = "",
                ApplyAdministrators = cbDisableCmdAdministrators.Checked,
                ApplyUsers = cbDisableCmdUsers.Checked
            });

            return settings;
        }

        private void BindDefaultSettings(UserSettings settings)
        {
            ddTimeout.SelectedValue = settings[RdsServerSettings.LOCK_SCREEN_TIMEOUT_VALUE];
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

            cbViewSessionAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.RDS_VIEW_WITHOUT_PERMISSION_ADMINISTRATORS]);
            cbViewSessionUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.RDS_VIEW_WITHOUT_PERMISSION_Users]);
            cbControlSessionAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.RDS_CONTROL_WITHOUT_PERMISSION_ADMINISTRATORS]);
            cbControlSessionUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.RDS_CONTROL_WITHOUT_PERMISSION_Users]);

            cbDisableCmdAdministrators.Checked = Convert.ToBoolean(settings[RdsServerSettings.DISABLE_CMD_ADMINISTRATORS]);
            cbDisableCmdUsers.Checked = Convert.ToBoolean(settings[RdsServerSettings.DISABLE_CMD_USERS]);

            ddTreshold.SelectedValue = settings[RdsServerSettings.DRIVE_SPACE_THRESHOLD_VALUE];
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