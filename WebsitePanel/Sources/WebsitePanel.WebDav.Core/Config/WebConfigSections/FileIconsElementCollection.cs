using System.Configuration;

namespace WebsitePanel.WebDav.Core.Config.WebConfigSections
{
    [ConfigurationCollection(typeof (FileIconsElement))]
    public class FileIconsElementCollection : ConfigurationElementCollection
    {
        private const string DefaultPathKey = "defaultPath";

        [ConfigurationProperty(DefaultPathKey, IsRequired = false, DefaultValue = "/")]
        public string DefaultPath
        {
            get { return (string) this[DefaultPathKey]; }
            set { this[DefaultPathKey] = value; }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new FileIconsElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((FileIconsElement) element).Extension;
        }
    }
}