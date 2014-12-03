using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class AppConnectionStringsElement : ConfigurationElement
    {
        private const string ConnectionStringKey = "key";
        private const string ConnectionStringValue = "connectionString";

        public const string WebdavConnectionStringKey = "WebDavServerConnectionString";
        public const string LdapConnectionStringKey = "LdapServerConnectionString";

        [ConfigurationProperty(ConnectionStringKey, IsKey = true, IsRequired = true)]
        public string Key
        {
            get { return (string) this[ConnectionStringKey]; }
            set { this[ConnectionStringKey] = value; }
        }

        [ConfigurationProperty(ConnectionStringValue, IsKey = true, IsRequired = true)]
        public string ConnectionString
        {
            get { return (string) this[ConnectionStringValue]; }
            set { this[ConnectionStringValue] = value; }
        }
    }
}