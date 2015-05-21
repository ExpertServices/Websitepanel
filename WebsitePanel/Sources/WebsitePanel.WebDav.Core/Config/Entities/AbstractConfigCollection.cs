using System.Configuration;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDav.Core.Config.Entities
{
    public abstract class AbstractConfigCollection
    {
        protected WebDavExplorerConfigurationSettingsSection ConfigSection;

        protected AbstractConfigCollection()
        {
            ConfigSection =
                (WebDavExplorerConfigurationSettingsSection)
                    ConfigurationManager.GetSection(WebDavExplorerConfigurationSettingsSection.SectionName);
        }
    }
}