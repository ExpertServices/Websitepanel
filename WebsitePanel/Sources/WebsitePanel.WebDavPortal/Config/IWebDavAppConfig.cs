using WebsitePanel.WebDavPortal.Config.Entities;

namespace WebsitePanel.WebDavPortal.Config
{
    public interface IWebDavAppConfig
    {
        string UserDomain { get; }
        string ApplicationName { get; }
        ElementsRendering ElementsRendering { get; }
        WebsitePanelConstantUserParameters WebsitePanelConstantUserParameters { get; }
        Rfc2898CryptographyParameters Rfc2898CryptographyParameters { get; }
        ConnectionStringsCollection ConnectionStrings { get; }
        SessionKeysCollection SessionKeys { get; }
        FileIconsDictionary FileIcons { get; }
        HttpErrorsCollection HttpErrors { get; }
        OfficeOnlineCollection OfficeOnline { get; }
    }
}