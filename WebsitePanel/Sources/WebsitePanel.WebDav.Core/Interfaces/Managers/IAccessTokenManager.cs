using System;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;

namespace WebsitePanel.WebDav.Core.Interfaces.Managers
{
    public interface IAccessTokenManager
    {
        WebDavAccessToken CreateToken(WspPrincipal principal, string filePath);
        WebDavAccessToken GetToken(int id);
        WebDavAccessToken GetToken(Guid guid);
        void ClearExpiredTokens();
    }
}