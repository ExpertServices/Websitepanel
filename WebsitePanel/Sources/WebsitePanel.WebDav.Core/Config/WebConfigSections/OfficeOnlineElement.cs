using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class OfficeOnlineElement : ConfigurationElement
    {
        private const string ExtensionKey = "extension";
        private const string OwaViewKey = "OwaView";
        private const string OwaEditorKey = "OwaEditor";

        [ConfigurationProperty(ExtensionKey, IsKey = true, IsRequired = true)]
        public string Extension
        {
            get { return this[ExtensionKey].ToString(); }
            set { this[ExtensionKey] = value; }
        }

        [ConfigurationProperty(OwaViewKey, IsKey = true, IsRequired = true)]
        public string OwaView
        {
            get { return this[OwaViewKey].ToString(); }
            set { this[OwaViewKey] = value; }
        }

        [ConfigurationProperty(OwaEditorKey, IsKey = true, IsRequired = true)]
        public string OwaEditor
        {
            get { return this[OwaEditorKey].ToString(); }
            set { this[OwaEditorKey] = value; }
        }
    }
}