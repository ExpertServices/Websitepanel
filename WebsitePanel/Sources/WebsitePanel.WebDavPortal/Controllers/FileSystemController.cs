using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Security.Policy;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using log4net;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.Models;
using System.Net;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Models.Common.Enums;
using WebsitePanel.WebDavPortal.Models.FileSystem;
using WebsitePanel.WebDavPortal.UI;
using WebsitePanel.WebDavPortal.UI.Routes;

namespace WebsitePanel.WebDavPortal.Controllers

{
    [ValidateInput(false)]
    [LdapAuthorization]
    public class FileSystemController : Controller
    {
        private readonly ICryptography _cryptography;
        private readonly IWebDavManager _webdavManager;
        private readonly IAuthenticationService _authenticationService;
        private readonly IAccessTokenManager _tokenManager;
        private readonly IWebDavAuthorizationService _webDavAuthorizationService;
        private readonly ILog Log;

        public FileSystemController(ICryptography cryptography, IWebDavManager webdavManager, IAuthenticationService authenticationService, IAccessTokenManager tokenManager, IWebDavAuthorizationService webDavAuthorizationService)
        {
            _cryptography = cryptography;
            _webdavManager = webdavManager;
            _authenticationService = authenticationService;
            _tokenManager = tokenManager;
            _webDavAuthorizationService = webDavAuthorizationService;

            Log = LogManager.GetLogger(this.GetType());
        }

        [HttpGet]
        public ActionResult ShowContent(string org, string pathPart = "")
        {
            if (org != WspContext.User.OrganizationId)
            {
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            }

            string fileName = pathPart.Split('/').Last();

            if (_webdavManager.IsFile(pathPart))
            {
                var fileBytes = _webdavManager.GetFileBytes(pathPart);
                return File(fileBytes, MediaTypeNames.Application.Octet, fileName);
            }

            try
            {
                IEnumerable<IHierarchyItem> children = _webdavManager.OpenFolder(pathPart);

                var permissions = _webDavAuthorizationService.GetPermissions(WspContext.User, pathPart);

                var model = new ModelForWebDav { Items = children.Take(WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount), UrlSuffix = pathPart, Permissions = permissions};

                return View(model);
            }
            catch (UnauthorizedException e)
            {
                throw new HttpException(404, "Not Found");
            }
        }

        public ActionResult ShowOfficeDocument(string org, string pathPart, string owaOpenerUri)
        {
            string fileUrl = WebDavAppConfigManager.Instance.WebdavRoot+ org + "/" + pathPart.TrimStart('/');
            var accessToken = _tokenManager.CreateToken(WspContext.User, pathPart);

            var urlPart = Url.HttpRouteUrl(OwaRouteNames.CheckFileInfo, new {accessTokenId = accessToken.Id});
            var url = new Uri(Request.Url, urlPart).ToString();

            string wopiSrc = Server.UrlDecode(url);

            var uri = string.Format("{0}/{1}WOPISrc={2}&access_token={3}", WebDavAppConfigManager.Instance.OfficeOnline.Url, owaOpenerUri, Server.UrlEncode(wopiSrc), Server.UrlEncode(accessToken.AccessToken.ToString("N")));

            string fileName = fileUrl.Split('/').Last();

            return View("ShowOfficeDocument", new OfficeOnlineModel(uri, fileName));
        }

        public ActionResult ViewOfficeDocument(string org, string pathPart)
        {
            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.Single(x => x.Extension == Path.GetExtension(pathPart));

            return ShowOfficeDocument(org, pathPart, owaOpener.OwaView);
        }

        public ActionResult EditOfficeDocument(string org, string pathPart)
        {
            var permissions = _webDavAuthorizationService.GetPermissions(WspContext.User, pathPart);

            if (permissions.HasFlag(WebDavPermissions.Write) == false)
            {
                return new RedirectToRouteResult(FileSystemRouteNames.ViewOfficeOnline, null);
            }

            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.Single(x => x.Extension == Path.GetExtension(pathPart));

            return ShowOfficeDocument(org, pathPart, owaOpener.OwaEditor);
        }

        [HttpPost]
        public ActionResult ShowAdditionalContent(string path = "", int resourseRenderCount = 0)
        {
            path = path.Replace(WspContext.User.OrganizationId, "").Trim('/');

            IEnumerable<IHierarchyItem> children = _webdavManager.OpenFolder(path);

            var result = children.Skip(resourseRenderCount).Take(WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount);

            return PartialView("_ResourseCollectionPartial", result);
        }

        [HttpGet]
        public ActionResult DownloadFile(string org, string pathPart)
        {
            if (org != WspContext.User.OrganizationId)
            {
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            }

            string fileName = pathPart.Split('/').Last();

            if (_webdavManager.IsFile(pathPart) == false)
            {
                throw new Exception(Resources.NotAFile);
            }

            var fileBytes = _webdavManager.GetFileBytes(pathPart);

            return File(fileBytes, MediaTypeNames.Application.Octet, fileName);
        }

        [HttpPost]
        public ActionResult UploadFile(string org, string pathPart)
        {
            foreach (string fileName in Request.Files)
            {
                var file = Request.Files[fileName];

                if (file == null || file.ContentLength == 0)
                {
                    continue;
                }

                _webdavManager.UploadFile(pathPart, file);
            }

            return RedirectToRoute(FileSystemRouteNames.ShowContentPath);
        }

        [HttpPost]
        public JsonResult DeleteFiles(IEnumerable<string> filePathes = null)
        {
            var model = new DeleteFilesModel();

            if (filePathes == null)
            {
                model.AddMessage(MessageType.Error, Resources.NoFilesAreSelected);

                return Json(model);
            }

            foreach (var file in filePathes)
            {
                try
                {
                    _webdavManager.DeleteResource(Server.UrlDecode(file));

                    model.DeletedFiles.Add(file);
                }
                catch (WebDavException exception)
                {
                    model.AddMessage(MessageType.Error, exception.Message);
                }
            }

            if (model.DeletedFiles.Any())
            {
                model.AddMessage(MessageType.Success, string.Format(Resources.ItemsWasRemovedFormat, model.DeletedFiles.Count));
            }

            return Json(model);
        }
    }
}