using System;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Managers
{
    public class AccessTokenManager : IAccessTokenManager
    {
        public WebDavAccessToken CreateToken(WspPrincipal principal, string filePath)
        {
            var token = new WebDavAccessToken();

            token.AccessToken = Guid.NewGuid();
            token.AccountId = principal.AccountId;
            token.ItemId = principal.ItemId;
            token.AuthData = principal.EncryptedPassword;
            token.ExpirationDate = DateTime.Now.AddHours(3);
            token.FilePath = filePath;

            token.Id = WSP.Services.EnterpriseStorage.AddWebDavAccessToken(token);

            return token;
        }

        public WebDavAccessToken GetToken(int id)
        {
            return WSP.Services.EnterpriseStorage.GetWebDavAccessTokenById(id);
        }

        public WebDavAccessToken GetToken(Guid guid)
        {
            return WSP.Services.EnterpriseStorage.GetWebDavAccessTokenByAccessToken(guid);
        }

        public void ClearExpiredTokens()
        {
            WSP.Services.EnterpriseStorage.DeleteExpiredWebDavAccessTokens();
        }
    }
}