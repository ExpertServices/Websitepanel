using WebsitePanel.EnterpriseServer;
using WebsitePanel.WebDav.Core.Entities.Account;
using WebsitePanel.WebDav.Core.Entities.Account.Enums;
using WebsitePanel.WebDav.Core.Helper;
using WebsitePanel.WebDav.Core.Interfaces.Managers.Users;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Managers.Users
{
    public class UserSettingsManager : IUserSettingsManager
    {
        public UserPortalSettings GetUserSettings(int accountId)
        {
            string xml = WSP.Services.EnterpriseStorage.GetWebDavPortalUserSettingsByAccountId(accountId);

            if (string.IsNullOrEmpty(xml))
            {
                return new UserPortalSettings();
            }

            return SerializeHelper.Deserialize<UserPortalSettings>(xml);
        }

        public void UpdateSettings(int accountId, UserPortalSettings settings)
        {
            var xml = SerializeHelper.Serialize(settings);

            WSP.Services.EnterpriseStorage.UpdateWebDavPortalUserSettings(accountId, xml);
        }

        public void ChangeWebDavViewType(int accountId, FolderViewTypes type)
        {
            var settings = GetUserSettings(accountId);

            settings.WebDavViewType = type;

            UpdateSettings(accountId, settings);
        }
    }
}