using WebsitePanel.WebDav.Core.Config.Entities;

namespace WebsitePanel.WebDav.Core.Config
{
    public interface IWebDavAppConfig
    {
        string UserDomain { get; }
        string ApplicationName { get; }
        ElementsRendering ElementsRendering { get; }
        WebsitePanelConstantUserParameters WebsitePanelConstantUserParameters { get; }
        TwilioParameters TwilioParameters { get; }
        SessionKeysCollection SessionKeys { get; }
        FileIconsDictionary FileIcons { get; }
        HttpErrorsCollection HttpErrors { get; }
        OfficeOnlineCollection OfficeOnline { get; }
        OwaSupportedBrowsersCollection OwaSupportedBrowsers { get; }
        FilesToIgnoreCollection FilesToIgnore { get; }
        OpenerCollection FileOpener { get; }
    }
}