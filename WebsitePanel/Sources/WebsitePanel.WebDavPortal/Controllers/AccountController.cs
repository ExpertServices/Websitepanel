using System;
using System.Configuration;
using System.DirectoryServices;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using Microsoft.Win32;
using Ninject;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Portal;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.Cryptography;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Exceptions;
using WebsitePanel.WebDavPortal.Models;
using System.Collections.Generic;
using WebsitePanel.Providers.OS;
using WebDAV;
using WebsitePanel.WebDavPortal.UI.Routes;

namespace WebsitePanel.WebDavPortal.Controllers
{
    public class AccountController : Controller
    {
        private readonly IKernel _kernel = new StandardKernel(new NinjectSettings {AllowNullInjection = true}, new WebDavExplorerAppModule());
        
        [HttpGet]
        public ActionResult Login()
        {
            object isAuthentication = _kernel.Get<AccountModel>();
            if (isAuthentication != null)
                return RedirectToAction("ShowContent", "FileSystem");
            return View();
        }

        [HttpPost]
        public ActionResult Login(AccountModel model)
        {
            AutheticationToServicesUsingWebsitePanelUser();
            var exchangeAccount = ES.Services.ExchangeServer.GetAccountByAccountNameWithoutItemId(model.Login);
            var isAuthenticated = exchangeAccount != null && exchangeAccount.AccountPassword == model.Password;
            
            ViewBag.LdapIsAuthentication = isAuthenticated;

            if (isAuthenticated)
            {
                Session[WebDavAppConfigManager.Instance.SessionKeys.ItemId] = exchangeAccount.ItemId;

                model.Groups = ES.Services.Organizations.GetSecurityGroupsByMember(exchangeAccount.ItemId, exchangeAccount.AccountId);

                try
                {
                    Session[WebDavAppConfigManager.Instance.SessionKeys.AccountInfo] = model;
                    Session[WebDavAppConfigManager.Instance.SessionKeys.WebDavManager] = new WebDavManager(new NetworkCredential(model.Login, model.Password, WebDavAppConfigManager.Instance.UserDomain), exchangeAccount.ItemId);
                }
                catch (ConnectToWebDavServerException exception)
                {
                    return View(new AccountModel { LdapError = exception.Message });
                }
                return RedirectToAction("ShowContent", "FileSystem", new { org = _kernel.Get<IWebDavManager>().OrganizationName });
            }
            return View(new AccountModel { LdapError = "The user name or password is incorrect" });
        }

        [HttpGet]
        public ActionResult Logout()
        {
            Session[WebDavAppConfigManager.Instance.SessionKeys.AccountInfo] = null;

            return RedirectToRoute(AccountRouteNames.Login);
        }

        private void AutheticationToServicesUsingWebsitePanelUser()
        {
            var crypto = _kernel.Get<ICryptography>();
            var websitePanelLogin = WebDavAppConfigManager.Instance.WebsitePanelConstantUserParameters.Login;
            var websitePanelPassword = crypto.Decrypt(WebDavAppConfigManager.Instance.WebsitePanelConstantUserParameters.Password);
            var authTicket = new FormsAuthenticationTicket(1, websitePanelLogin, DateTime.Now, DateTime.Now.Add(FormsAuthentication.Timeout),
                FormsAuthentication.SlidingExpiration, websitePanelPassword + Environment.NewLine);
            var encryptedTicket = FormsAuthentication.Encrypt(authTicket);
            var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
            if (FormsAuthentication.SlidingExpiration)
                authCookie.Expires = authTicket.Expiration;
            Response.Cookies.Add(authCookie);
        } 
    }
}