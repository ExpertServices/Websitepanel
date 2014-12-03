using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class ConnectionStringsCollection : AbstractConfigCollection
    {
        private readonly IEnumerable<AppConnectionStringsElement> _appConnectionStringsElements;

        public ConnectionStringsCollection()
        {
            _appConnectionStringsElements = ConfigSection.ConnectionStrings.Cast<AppConnectionStringsElement>();
        }

        public string WebDavServer
        {
            get
            {
                AppConnectionStringsElement connectionStr =
                    _appConnectionStringsElements.FirstOrDefault(
                        x => x.Key == AppConnectionStringsElement.WebdavConnectionStringKey);
                return connectionStr != null ? connectionStr.ConnectionString : null;
            }
        }

        public string LdapServer
        {
            get
            {
                AppConnectionStringsElement connectionStr =
                    _appConnectionStringsElements.FirstOrDefault(
                        x => x.Key == AppConnectionStringsElement.LdapConnectionStringKey);
                return connectionStr != null ? connectionStr.ConnectionString : null;
            }
        }
    }
}