using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.Models;
using System.Net;
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

        public FileSystemController(ICryptography cryptography, IWebDavManager webdavManager, IAuthenticationService authenticationService, IAccessTokenManager tokenManager)
        {
            _cryptography = cryptography;
            _webdavManager = webdavManager;
            _authenticationService = authenticationService;
            _tokenManager = tokenManager;
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
                IEnumerable<IHierarchyItem> children = _webdavManager.OpenFolder(pathPart).Where(x => !WebDavAppConfigManager.Instance.ElementsRendering.ElementsToIgnore.Contains(x.DisplayName.Trim('/')));

                var model = new ModelForWebDav { Items = children.Take(WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount), UrlSuffix = pathPart };
                Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] = WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount;

                return View(model);
            }
            catch (UnauthorizedException)
            {
                throw new HttpException(404, "Not Found");
            }
        }

        public ActionResult ShowOfficeDocument(string org, string pathPart = "")
        {
            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.Single(x => x.Extension == Path.GetExtension(pathPart));

            string fileUrl = WebDavAppConfigManager.Instance.WebdavRoot+ org + "/" + pathPart.TrimStart('/');
            var accessToken = _tokenManager.CreateToken(WspContext.User, pathPart);

            string wopiSrc = Server.UrlDecode(Url.RouteUrl(OwaRouteNames.CheckFileInfo, new { accessTokenId = accessToken.Id }, Request.Url.Scheme));

            var uri = string.Format("{0}/{1}?WOPISrc={2}&access_token={3}", WebDavAppConfigManager.Instance.OfficeOnline.Url, owaOpener.OwaOpener, Server.UrlEncode(wopiSrc), Server.UrlEncode(accessToken.AccessToken.ToString("N")));

            return View(new OfficeOnlineModel(uri, new Uri(fileUrl).Segments.Last()));
        }

        [HttpPost]
        public ActionResult ShowAdditionalContent(string path)
        {
            if (Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] != null)
            {
                var renderedElementsCount = (int)Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount];

                IEnumerable<IHierarchyItem> children = _webdavManager.OpenFolder(path);

                var result = children.Skip(renderedElementsCount).Take(WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount);

                Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] = renderedElementsCount + WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount;

                return PartialView("_ResourseCollectionPartial", result);
            }

            return new HttpStatusCodeResult(HttpStatusCode.NoContent);
        }
    }
}