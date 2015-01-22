using System.Collections.Generic;
using System.Linq;
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