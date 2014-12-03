using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class UserDomainElement : ConfigurationElement
    {
        private const string ValueKey = "value";

        [ConfigurationProperty(ValueKey, IsKey = true, IsRequired = true)]
        public string Value
        {
            get { return (string) this[ValueKey]; }
            set { this[ValueKey] = value; }
        }
    }
}