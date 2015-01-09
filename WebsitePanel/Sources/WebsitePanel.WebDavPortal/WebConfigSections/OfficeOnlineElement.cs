using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class OfficeOnlineElement : ConfigurationElement
    {
        private const string ExtensionKey = "extension";

        [ConfigurationProperty(ExtensionKey, IsKey = true, IsRequired = true)]
        public string Extension
        {
            get { return this[ExtensionKey].ToString(); }
            set { this[ExtensionKey] = value; }
        }
    }
}