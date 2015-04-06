using System;
using System.DirectoryServices.AccountManagement;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Security.Authentication
{
    public class FormsAuthenticationService : IAuthenticationService
    {
        private readonly ICryptography _cryptography;
        private readonly PrincipalContext _principalContext;

        public FormsAuthenticationService(ICryptography cryptography)
        {
            _cryptography = cryptography;
            _principalContext = new PrincipalContext(ContextType.Domain, WebDavAppConfigManager.Instance.UserDomain);
        }

        public WspPrincipal LogIn(string login, string password)
        {
            if (string.IsNullOrEmpty(login) || string.IsNullOrEmpty(password))
            {
                return null;
            }

            var user = UserPrincipal.FindByIdentity(_principalContext, IdentityType.UserPrincipalName, login);

            if (user == null || _principalContext.ValidateCredentials(login, password) == false)
            {
                return null;
            }

            var principal = new WspPrincipal(login);
            
            var exchangeAccount = WSP.Services.ExchangeServer.GetAccountByAccountNameWithoutItemId(login);
            var organization = WSP.Services.Organizations.GetOrganization(exchangeAccount.ItemId);

            principal.AccountId = exchangeAccount.AccountId;
            principal.ItemId = exchangeAccount.ItemId;
            principal.OrganizationId = organization.OrganizationId;
            principal.DisplayName = exchangeAccount.DisplayName;
            principal.EncryptedPassword = _cryptography.Encrypt(password);

            if (HttpContext.Current != null)
            {
                HttpContext.Current.User = principal;
            }

            Thread.CurrentPrincipal = principal;

            return principal;
        }

        public void CreateAuthenticationTicket(WspPrincipal principal)
        {
            var serializer = new JavaScriptSerializer();
            string userData = serializer.Serialize(principal);

            var authTicket = new FormsAuthenticationTicket(1, principal.Identity.Name, DateTime.Now, DateTime.Now.Add(FormsAuthentication.Timeout),
                FormsAuthentication.SlidingExpiration, userData);

            var encTicket = FormsAuthentication.Encrypt(authTicket);

            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);

            if (FormsAuthentication.SlidingExpiration)
            {
                cookie.Expires = authTicket.Expiration;
            }

            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public void LogOut()
        {
            FormsAuthentication.SignOut();
        }
    }
}
