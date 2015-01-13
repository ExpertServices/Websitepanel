using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.Models;
using System.Net;

namespace WebsitePanel.WebDavPortal.Controllers

{
    [ValidateInput(false)]
    [LdapAuthorization]
    public class FileSystemController : Controller
    {
        private readonly IWebDavManager _webdavManager;

        public FileSystemController(IWebDavManager webdavManager)
        {
            _webdavManager = webdavManager;
        }

        [HttpGet]
        public ActionResult ShowContent(string org, string pathPart = "")
        {
            if (org != WspContext.User.OrganizationId)
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            
            string fileName = pathPart.Split('/').Last();
            if (_webdavManager.IsFile(fileName))
            {
                var fileBytes = _webdavManager.GetFileBytes(fileName);
                return File(fileBytes, MediaTypeNames.Application.Octet, fileName);
            }

            try
            {
                _webdavManager.OpenFolder(pathPart);
                IEnumerable<IHierarchyItem> children = _webdavManager.GetChildren().Where(x => !WebDavAppConfigManager.Instance.ElementsRendering.ElementsToIgnore.Contains(x.DisplayName.Trim('/')));

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
            string fileUrl = _webdavManager.RootPath.TrimEnd('/') + "/" + pathPart.TrimStart('/');
            var uri = new Uri(WebDavAppConfigManager.Instance.OfficeOnline.Url).AddParameter("src", fileUrl).ToString();

            return View(new OfficeOnlineModel(uri, new Uri(fileUrl).Segments.Last()));
        }

        [HttpPost]
        public ActionResult ShowAdditionalContent()
        {
            if (Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] != null)
            {
                var renderedElementsCount = (int)Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount];

                IEnumerable<IHierarchyItem> children = _webdavManager.GetChildren();

                var result = children.Skip(renderedElementsCount).Take(WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount);

                Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] = renderedElementsCount + WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount;

                return PartialView("_ResourseCollectionPartial", result);
            }

            return new HttpStatusCodeResult(HttpStatusCode.NoContent); ;
        }
    }
}