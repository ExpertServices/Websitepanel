using System.Collections.Generic;
using System.Linq;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Config.WebConfigSections;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDav.Core.Config.Entities
{
    public class SessionKeysCollection : AbstractConfigCollection
    {
        private readonly IEnumerable<SessionKeysElement> _sessionKeys;

        public SessionKeysCollection()
        {
            _sessionKeys = ConfigSection.SessionKeys.Cast<SessionKeysElement>();
        }

        public string AuthTicket
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.AuthTicketKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string WebDavManager
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.WebDavManagerKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string UserGroupsKey
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.UserGroupsKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string OwaEditFoldersSessionKey
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.OwaEditFoldersSessionKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string WebDavRootFoldersPermissions
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.WebDavRootFolderPermissionsKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string PasswordResetSmsKey
        {
            get
            {
                SessionKeysElement sessionKey =
                    _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.PasswordResetSmsKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string ResourseRenderCount
        {
            get
            {
                SessionKeysElement sessionKey = _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.ResourseRenderCountKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }

        public string ItemId
        {
            get
            {
                SessionKeysElement sessionKey = _sessionKeys.FirstOrDefault(x => x.Key == SessionKeysElement.ItemIdSessionKey);
                return sessionKey != null ? sessionKey.Value : null;
            }
        }
    }
}