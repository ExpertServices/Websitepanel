using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Cryptography;

namespace WebsitePanel.WebDavPortal.Controllers
{
    [AllowAnonymous]
    public class OwaController : Controller
    {
        private readonly IWopiServer _wopiServer;
        private readonly IWebDavManager _webDavManager;
        private readonly IAuthenticationService _authenticationService;

        public OwaController(IWopiServer wopiServer, IWebDavManager webDavManager, IAuthenticationService authenticationService)
        {
            _wopiServer = wopiServer;
            _webDavManager = webDavManager;
            _authenticationService = authenticationService;
        }

        public JsonResult CheckFileInfo( string encodedPath)
        {
            var path = _webDavManager.FilePathFromId(encodedPath);

            var fileInfo = _wopiServer.GetCheckFileInfo(path);

            return Json(fileInfo, JsonRequestBehavior.AllowGet);
        }

        public FileResult GetFile(string encodedPath)
        {
            var path = _webDavManager.FilePathFromId(encodedPath);

            return _wopiServer.GetFile(path);
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);

            if (!string.IsNullOrEmpty(Request["access_token"]))
            {
                _authenticationService.LogIn(Request["access_token"]);
            }
        }
    }
}