using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using System.Web;
using System.Web.Mvc;
using Ninject;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.Controllers
{
    [LdapAuthorization]
    public class FileSystemController : Controller
    {
        private readonly IKernel _kernel = new StandardKernel(new WebDavExplorerAppModule());

        public ActionResult ShowContent(string pathPart = "")
        {
            var webDavManager = _kernel.Get<IWebDavManager>();

            string fileName = pathPart.Split('/').Last();
            if (webDavManager.IsFile(fileName))
            {
                var fileBytes = webDavManager.GetFileBytes(fileName);
                return File(fileBytes, MediaTypeNames.Application.Octet, fileName);
            }

            try
            {
                webDavManager.OpenFolder(pathPart);
                IEnumerable<IHierarchyItem> children = webDavManager.GetChildren();
                var model = new ModelForWebDav { Items = children.Take(WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount), UrlSuffix = pathPart };
                Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] = WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount;

                return View(model);
            }
            catch (UnauthorizedException)
            {
                throw new HttpException(404, "Not Found");
            }
        }

        public ActionResult ShowOfficeDocument(string pathPart = "")
        {
            const string fileUrl = "http://my-files.ru/DownloadSave/xluyk3/test1.docx";
            var uri = new Uri(WebDavAppConfigManager.Instance.OfficeOnline.Url).AddParameter("src", fileUrl).ToString();

            return View(new OfficeOnlineModel(uri, new Uri(fileUrl).Segments.Last()));
        }

        [HttpPost]
        public ActionResult ShowAdditionalContent()
        {
            if (Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] != null)
            {
                var renderedElementsCount = (int)Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount];
                var webDavManager = _kernel.Get<IWebDavManager>();
                IEnumerable<IHierarchyItem> children = webDavManager.GetChildren();
                var result = children.Skip(renderedElementsCount).Take(WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount);
                Session[WebDavAppConfigManager.Instance.SessionKeys.ResourseRenderCount] = renderedElementsCount + WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount;

                return PartialView("_ResourseCollectionPartial", result);
            }

            return null;
        }
    }
}