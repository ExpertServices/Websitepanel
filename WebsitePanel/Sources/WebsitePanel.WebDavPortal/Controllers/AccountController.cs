using System.Linq;
using System.Net;
using System.Web.Mvc;
using System.Web.Routing;
using AutoMapper;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Security.Authentication;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Models;
using WebsitePanel.WebDavPortal.Models.Account;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Models.Common.EditorTemplates;
using WebsitePanel.WebDavPortal.Models.Common.Enums;
using WebsitePanel.WebDavPortal.UI.Routes;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core;

namespace WebsitePanel.WebDavPortal.Controllers
{
    [LdapAuthorization]
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
        [AllowAnonymous]

        public ActionResult Login()
        {
            if (WspContext.User != null && WspContext.User.Identity.IsAuthenticated)
            {
                return RedirectToRoute(FileSystemRouteNames.ShowContentPath, new { org = WspContext.User.OrganizationId });
            }

            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult Login(AccountModel model)
        {
            var user = _authenticationService.LogIn(model.Login, model.Password);
            
            ViewBag.LdapIsAuthentication = user != null;

            if (user != null && user.Identity.IsAuthenticated)
            {
                _authenticationService.CreateAuthenticationTicket(user);

                return RedirectToRoute(FileSystemRouteNames.ShowContentPath, new { org = WspContext.User.OrganizationId });
            }

            return View(new AccountModel { LdapError = "The user name or password is incorrect" });
        }

        [HttpGet]
        public ActionResult Logout()
        {
            _authenticationService.LogOut();

            Session.Clear();

            return RedirectToRoute(AccountRouteNames.Login);
        }

        [HttpGet]
        public ActionResult UserProfile()
        {
            var model = GetUserProfileModel(WspContext.User.ItemId, WspContext.User.AccountId);

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult UserProfile(UserProfile model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            int result = UpdateUserProfile(WspContext.User.ItemId, WspContext.User.AccountId, model);

            model.AddMessage(MessageType.Success, Resources.UI.UserProfileSuccessfullyUpdated);

            return View(model);
        }

        [HttpGet]
        public ActionResult PasswordChange()
        {
            var model = new PasswordChangeModel();
            model.PasswordEditor.Settings = WspContext.Services.Organizations.GetOrganizationPasswordSettings(WspContext.User.ItemId);

            return View(model);
        }

        [HttpPost]
        public ActionResult PasswordChange(PasswordChangeModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            if (_authenticationService.ValidateAuthenticationData(WspContext.User.Login, model.OldPassword) == false)
            {
                model.AddMessage(MessageType.Error, Resources.Messages.OldPasswordIsNotCorrect);

                return View(model);
            }

            WspContext.Services.Organizations.SetUserPassword(
                    WspContext.User.ItemId, WspContext.User.AccountId,
                    model.PasswordEditor.NewPassword);

            return RedirectToRoute(AccountRouteNames.UserProfile);
        }

        #region Helpers

        private UserProfile GetUserProfileModel(int itemId, int accountId)
        {
            var user = WspContext.Services.Organizations.GetUserGeneralSettings(itemId, accountId);

            return Mapper.Map<OrganizationUser, UserProfile>(user);
        }

        private int UpdateUserProfile(int itemId, int accountId, UserProfile model)
        {
            var user = WspContext.Services.Organizations.GetUserGeneralSettings(itemId, accountId);

            return WspContext.Services.Organizations.SetUserGeneralSettings(
                itemId, accountId,
                model.DisplayName,
                string.Empty,
                false,
                user.Disabled,
                user.Locked,

                model.FirstName,
                model.Initials,
                model.LastName,

                model.Address,
                model.City,
                model.State,
                model.Zip,
                model.Country,

                user.JobTitle,
                user.Company,
                user.Department,
                user.Office,
                user.Manager == null ? null : user.Manager.AccountName,

                model.BusinessPhone,
                model.Fax,
                model.HomePhone,
                model.MobilePhone,
                model.Pager,
                model.WebPage,
                model.Notes,
                model.ExternalEmail,
                user.SubscriberNumber,
                user.LevelId,
                user.IsVIP,
                user.UserMustChangePassword);
        }

        #endregion

    }
}