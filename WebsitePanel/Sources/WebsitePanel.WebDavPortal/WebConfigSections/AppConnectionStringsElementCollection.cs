using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    [ConfigurationCollection(typeof (AppConnectionStringsElement))]
    public class AppConnectionStringsElementCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new AppConnectionStringsElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((AppConnectionStringsElement) element).Key;
        }
    }
}