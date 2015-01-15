using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class OfficeOnlineElement : ConfigurationElement
    {
        private const string ExtensionKey = "extension";
        private const string OwaOpenerKey = "owaOpener";

        [ConfigurationProperty(ExtensionKey, IsKey = true, IsRequired = true)]
        public string Extension
        {
            get { return this[ExtensionKey].ToString(); }
            set { this[ExtensionKey] = value; }
        }

        [ConfigurationProperty(OwaOpenerKey, IsKey = true, IsRequired = true)]
        public string OwaOpener
        {
            get { return this[OwaOpenerKey].ToString(); }
            set { this[OwaOpenerKey] = value; }
        }
    }
}