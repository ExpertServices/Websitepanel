using System.Configuration;

namespace WebsitePanel.WebDav.Core.Config.WebConfigSections
{
    public class EnterpriseServerElement : ConfigurationElement
    {
        private const string ValueKey = "url";

        [ConfigurationProperty(ValueKey, IsKey = true, IsRequired = true)]
        public string Value
        {
            get { return (string)this[ValueKey]; }
            set { this[ValueKey] = value; }
        }
    }
}