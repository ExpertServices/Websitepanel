using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDavPortal.HttpHandlers
{
    public class AccessTokenHandler : DelegatingHandler
    {
        private const string Bearer = "Bearer ";

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request, CancellationToken cancellationToken)
        {
            if (request.Headers.Contains("Authorization"))
            {
                var tokenString = request.Headers.GetValues("Authorization").First();
                if (!string.IsNullOrEmpty(tokenString) && tokenString.StartsWith(Bearer))
                {
                    try
                    {
                        var accessToken = tokenString.Substring(Bearer.Length - 1);

                        var tokenManager = DependencyResolver.Current.GetService<IAccessTokenManager>();

                        var guid = Guid.Parse(accessToken);
                        tokenManager.ClearExpiredTokens();

                        var token = tokenManager.GetToken(guid);

                        if (token != null)
                        {
                            var authenticationService = DependencyResolver.Current.GetService<IAuthenticationService>();
                            var cryptography = DependencyResolver.Current.GetService<ICryptography>();


                            var user = WSP.Services.ExchangeServer.GetAccount(token.ItemId, token.AccountId);

                            authenticationService.LogIn(user.UserPrincipalName, cryptography.Decrypt(token.AuthData));
                        }
                    }
                    catch (Exception)
                    {
                    }
                }
            }

            return await
                base.SendAsync(request, cancellationToken);
        }
    }
}