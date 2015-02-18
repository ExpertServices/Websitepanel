using WebsitePanel.EnterpriseServer;
using WebsitePanel.WebDav.Core.Entities.Account;
using WebsitePanel.WebDav.Core.Entities.Account.Enums;

namespace WebsitePanel.WebDav.Core.Interfaces.Managers.Users
{
    public interface IUserSettingsManager
    {
        UserPortalSettings GetUserSettings(int accountId);
        void UpdateSettings(int accountId, UserPortalSettings settings);
        void ChangeWebDavViewType(int accountId, FolderViewTypes type);
    }
}