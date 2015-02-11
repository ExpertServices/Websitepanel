using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDavPortal.Controllers
{
    [AllowAnonymous]
    public class OwaController : Controller
    {
        private readonly IWopiServer _wopiServer;
        private readonly IWebDavManager _webDavManager;
        private readonly IAuthenticationService _authenticationService;
        private readonly IAccessTokenManager _tokenManager;
        private readonly ICryptography _cryptography;
        private WebDavAccessToken _token;


        public OwaController(IWopiServer wopiServer, IWebDavManager webDavManager, IAuthenticationService authenticationService, IAccessTokenManager tokenManager, ICryptography cryptography)
        {
            _wopiServer = wopiServer;
            _webDavManager = webDavManager;
            _authenticationService = authenticationService;
            _tokenManager = tokenManager;
            _cryptography = cryptography;
        }

        public ActionResult CheckFileInfo(int accessTokenId)
        {
            if (!CheckAccess(accessTokenId))
            {
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            }

            var fileInfo = _wopiServer.GetCheckFileInfo(_token.FilePath);

            return Json(fileInfo, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetFile(int accessTokenId)
        {
            if (!CheckAccess(accessTokenId))
            {
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            }

            return _wopiServer.GetFile((_token.FilePath));
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);

            if (!string.IsNullOrEmpty(Request["access_token"]))
            {
                var guid = Guid.Parse((Request["access_token"]));

                _tokenManager.ClearExpiredTokens();

                _token = _tokenManager.GetToken(guid);

                var user = WSP.Services.ExchangeServer.GetAccount(_token.ItemId, _token.AccountId);

                _authenticationService.LogIn(user.UserPrincipalName, _cryptography.Decrypt(_token.AuthData));
            }
        }

        private bool CheckAccess(int accessTokenId)
        {
            if (_token == null || accessTokenId != _token.Id)
            {
                return false;
            }

            return true;
        }
    }
}