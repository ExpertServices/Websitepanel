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

            setting = GetServerSetting(settings, RdsServerSettings.REMOVE_RUN_COMMAND);

            if (setting != null)
            {
                cbRunCommandAdministrators.Checked = setting.ApplyAdministrators;
                cbRunCommandUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.REMOVE_POWERSHELL_COMMAND);

            if (setting != null)
            {
                cbPowershellAdministrators.Checked = setting.ApplyAdministrators;
                cbPowershellUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.HIDE_C_DRIVE);

            if (setting != null)
            {
                cbHideCDriveAdministrators.Checked = setting.ApplyAdministrators;
                cbHideCDriveUsers.Checked = setting.ApplyUsers;
            }
            
            setting = GetServerSetting(settings, RdsServerSettings.REMOVE_SHUTDOWN_RESTART);

            if (setting != null)
            {
                cbShutdownAdministrators.Checked = setting.ApplyAdministrators;
                cbShutdownUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.DISABLE_TASK_MANAGER);

            if (setting != null)
            {
                cbTaskManagerAdministrators.Checked = setting.ApplyAdministrators;
                cbTaskManagerUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.CHANGE_DESKTOP_DISABLED);

            if (setting != null)
            {
                cbDesktopAdministrators.Checked = setting.ApplyAdministrators;
                cbDesktopUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.SCREEN_SAVER_DISABLED);

            if (setting != null)
            {
                cbScreenSaverAdministrators.Checked = setting.ApplyAdministrators;
                cbViewSessionUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.RDS_VIEW_WITHOUT_PERMISSION);

            if (setting != null)
            {
                cbViewSessionAdministrators.Checked = setting.ApplyAdministrators;
                cbScreenSaverUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.RDS_CONTROL_WITHOUT_PERMISSION);

            if (setting != null)
            {
                cbControlSessionAdministrators.Checked = setting.ApplyAdministrators;
                cbControlSessionUsers.Checked = setting.ApplyUsers;
            }

            setting = GetServerSetting(settings, RdsServerSettings.DRIVE_SPACE_THRESHOLD);

            if (setting != null)
            {
                ddTreshold.SelectedValue = setting.PropertyValue;
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