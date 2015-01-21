using System.Configuration;
using WebsitePanel.WebDav.Core.Config.WebConfigSections;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class WebDavExplorerConfigurationSettingsSection : ConfigurationSection
    {
        private const string UserDomainKey = "userDomain";
        private const string WebdavRootKey = "webdavRoot";
        private const string AuthTimeoutCookieNameKey = "authTimeoutCookieName";
        private const string AppName = "applicationName";
        private const string WebsitePanelConstantUserKey = "websitePanelConstantUser";
        private const string ElementsRenderingKey = "elementsRendering";
        private const string Rfc2898CryptographyKey = "rfc2898Cryptography";
        private const string ConnectionStringsKey = "appConnectionStrings";
        private const string SessionKeysKey = "sessionKeys";
        private const string FileIconsKey = "fileIcons";
        private const string OfficeOnlineKey = "officeOnline";

        public const string SectionName = "webDavExplorerConfigurationSettings";

        [ConfigurationProperty(AuthTimeoutCookieNameKey, IsRequired = true)]
        public AuthTimeoutCookieNameElement AuthTimeoutCookieName
        {
            get { return (AuthTimeoutCookieNameElement)this[AuthTimeoutCookieNameKey]; }
            set { this[AuthTimeoutCookieNameKey] = value; }
        }

        [ConfigurationProperty(WebdavRootKey, IsRequired = true)]
        public WebdavRootElement WebdavRoot
        {
            get { return (WebdavRootElement)this[WebdavRootKey]; }
            set { this[WebdavRootKey] = value; }
        }

        [ConfigurationProperty(UserDomainKey, IsRequired = true)]
        public UserDomainElement UserDomain
        {
            get { return (UserDomainElement) this[UserDomainKey]; }
            set { this[UserDomainKey] = value; }
        }

        [ConfigurationProperty(AppName, IsRequired = true)]
        public ApplicationNameElement ApplicationName
        {
            get { return (ApplicationNameElement)this[AppName]; }
            set { this[AppName] = value; }
        }

        [ConfigurationProperty(WebsitePanelConstantUserKey, IsRequired = true)]
        public WebsitePanelConstantUserElement WebsitePanelConstantUser
        {
            get { return (WebsitePanelConstantUserElement)this[WebsitePanelConstantUserKey]; }
            set { this[WebsitePanelConstantUserKey] = value; }
        }

        [ConfigurationProperty(ElementsRenderingKey, IsRequired = true)]
        public ElementsRenderingElement ElementsRendering
        {
            get { return (ElementsRenderingElement)this[ElementsRenderingKey]; }
            set { this[ElementsRenderingKey] = value; }
        }

        [ConfigurationProperty(SessionKeysKey, IsDefaultCollection = false)]
        public SessionKeysElementCollection SessionKeys
        {
            get { return (SessionKeysElementCollection) this[SessionKeysKey]; }
            set { this[SessionKeysKey] = value; }
        }

        [ConfigurationProperty(FileIconsKey, IsDefaultCollection = false)]
        public FileIconsElementCollection FileIcons
        {
            get { return (FileIconsElementCollection) this[FileIconsKey]; }
            set { this[FileIconsKey] = value; }
        }

        [ConfigurationProperty(OfficeOnlineKey, IsDefaultCollection = false)]
        public OfficeOnlineElementCollection OfficeOnline
        {
            get { return (OfficeOnlineElementCollection)this[OfficeOnlineKey]; }
            set { this[OfficeOnlineKey] = value; }
        }
    }
}