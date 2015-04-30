using System.Configuration;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDav.Core.Config.WebConfigSections
{
    [ConfigurationCollection(typeof (SessionKeysElement))]
    public class SessionKeysElementCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new SessionKeysElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((SessionKeysElement) element).Key;
        }
    }
}