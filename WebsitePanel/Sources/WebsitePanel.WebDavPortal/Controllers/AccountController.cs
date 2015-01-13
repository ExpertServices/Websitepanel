using System.Linq;
using System.Net;
using System.Web.Mvc;
using System.Web.Routing;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.Exceptions;
using WebsitePanel.WebDavPortal.Models;
using WebsitePanel.WebDavPortal.UI.Routes;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core;

namespace WebsitePanel.WebDavPortal.Controllers
{
    public class AccountController : Controller
    {
        private readonly ICryptography _cryptography;
        private readonly IAuthenticationService _authenticationService;

        public AccountController(ICryptography cryptography, IAuthenticationService authenticationService)
        {
            _cryptography = cryptography;
            _authenticationService = authenticationService;
        }
        
        [HttpGet]
        public ActionResult Login()
        {
            if (WspContext.User != null && WspContext.User.Identity.IsAuthenticated)
            {
                return RedirectToRoute(FileSystemRouteNames.FilePath, new { org = WspContext.User.OrganizationId });
            }

            return View();
        }

        [HttpPost]
        public ActionResult Login(AccountModel model)
        {
            var user = _authenticationService.LogIn(model.Login, model.Password);

            ViewBag.LdapIsAuthentication = user.Identity.IsAuthenticated;

            if (user.Identity.IsAuthenticated)
            {
                return RedirectToRoute(FileSystemRouteNames.FilePath, new { org = WspContext.User.OrganizationId });
            }

            return View(new AccountModel { LdapError = "The user name or password is incorrect" });
        }

        [HttpGet]
        public ActionResult Logout()
        {
            _authenticationService.LogOut();

            return RedirectToRoute(AccountRouteNames.Login);
        }
    }
}