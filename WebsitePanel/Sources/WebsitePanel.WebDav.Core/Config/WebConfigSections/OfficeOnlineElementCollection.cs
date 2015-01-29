using System;
using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    [ConfigurationCollection(typeof(OfficeOnlineElement))]
    public class OfficeOnlineElementCollection : ConfigurationElementCollection
    {
        private const string UrlKey = "url";
        private const string IsEnabledKey = "isEnabled";

        [ConfigurationProperty(UrlKey, IsKey = true, IsRequired = true)]
        public string Url
        {
            get { return this[UrlKey].ToString(); }
            set { this[UrlKey] = value; }
        }

        [ConfigurationProperty(IsEnabledKey, IsKey = true, IsRequired = true, DefaultValue = false)]
        public bool IsEnabled
        {
            get { return Boolean.Parse(this[IsEnabledKey].ToString()); }
            set { this[IsEnabledKey] = value; }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new OfficeOnlineElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((OfficeOnlineElement)element).Extension;
        }
    }
}