using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;

namespace WebsitePanel.WebDav.Core.Interfaces.Security
{
    public interface IWebDavAuthorizationService
    {
        bool HasAccess(WspPrincipal principal, string path);
        WebDavPermissions GetPermissions(WspPrincipal principal, string path);
    }
}