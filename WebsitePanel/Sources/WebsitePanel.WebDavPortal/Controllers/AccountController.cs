using System;
using System.Configuration;
using System.DirectoryServices;
using System.IO;
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

namespace WebsitePanel.WebDavPortal.Controllers
{
    public class AccountController : Controller
    {
        private readonly IKernel _kernel = new StandardKernel(new NinjectSettings {AllowNullInjection = true}, new WebDavExplorerAppModule());
        
        [HttpGet]
        public ActionResult Login()
        {
            try
            {
                const string userName = "serveradmin";
                string correctPassword = "wsp_2012" + Environment.NewLine;
                const bool createPersistentCookie = true;
                var authTicket = new FormsAuthenticationTicket(2, userName, DateTime.Now, DateTime.Now.AddMinutes(60), true, correctPassword);
                var encryptedTicket = FormsAuthentication.Encrypt(authTicket);
                var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                if (createPersistentCookie)
                    authCookie.Expires = authTicket.Expiration;
                Response.Cookies.Add(authCookie);

                const string organizationId = "System";
                var itemId = ES.Services.Organizations.GetOrganizationById(organizationId).Id;
                var folders = ES.Services.EnterpriseStorage.GetEnterpriseFolders(itemId);
            }
            catch (System.Exception exception)
            {
            }

            //============
            object isAuthentication = _kernel.Get<AccountModel>();
            if (isAuthentication != null)
                return RedirectToAction("ShowContent", "FileSystem");
            return View();
        }

        [HttpPost]
        public ActionResult Login(AccountModel model)
        {
            var ldapConnectionString = WebDavAppConfigManager.Instance.ConnectionStrings.LdapServer;
            if (ldapConnectionString == null || !Regex.IsMatch(ldapConnectionString, @"^LDAP://([\w-]+.)+[\w-]+(/[\w- ./?%&=])?$"))
                return View(new AccountModel { LdapError = "LDAP server address is invalid" });

            var principal = new WebDavPortalIdentity(model.Login, model.Password);
            bool isAuthenticated = principal.Identity.IsAuthenticated;
            var organizationId = principal.GetOrganizationId();

            ViewBag.LdapIsAuthentication = isAuthenticated;

            if (isAuthenticated)
            {
                AutheticationToServicesUsingWebsitePanelUser();

                var organization = ES.Services.Organizations.GetOrganizationById(organizationId);
                if (organization == null)
                    throw new NullReferenceException();
                Session[WebDavAppConfigManager.Instance.SessionKeys.ItemId] = organization.Id;
                
                try
                {
                    Session[WebDavAppConfigManager.Instance.SessionKeys.WebDavManager] = new WebDavManager(new NetworkCredential(WebDavAppConfigManager.Instance.UserDomain + "\\" + model.Login, model.Password));
                    Session[WebDavAppConfigManager.Instance.SessionKeys.AccountInfo] = model;
                }
                catch (ConnectToWebDavServerException exception)
                {
                    return View(new AccountModel { LdapError = exception.Message });
                }
                return RedirectToAction("ShowContent", "FileSystem");
            }
            return View(new AccountModel { LdapError = "The user name or password is incorrect" });
        }

        private void AutheticationToServicesUsingWebsitePanelUser()
        {
            var crypto = _kernel.Get<ICryptography>();
            var websitePanelLogin = crypto.Decrypt(WebDavAppConfigManager.Instance.WebsitePanelConstantUserParameters.Login);
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