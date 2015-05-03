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
using AutoMapper;
using log4net;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Entities.Account.Enums;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDav.Core.Extensions;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Managers.Users;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Extensions;
using WebsitePanel.WebDavPortal.FileOperations;
using WebsitePanel.WebDavPortal.Helpers;
using WebsitePanel.WebDavPortal.ModelBinders.DataTables;
using WebsitePanel.WebDavPortal.Models;
using System.Net;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Models.Common.DataTable;
using WebsitePanel.WebDavPortal.Models.Common.Enums;
using WebsitePanel.WebDavPortal.Models.FileSystem;
using WebsitePanel.WebDavPortal.UI;
using WebsitePanel.WebDavPortal.UI.Routes;
using WebsitePanel.WebDav.Core.Extensions;

namespace WebsitePanel.WebDavPortal.Controllers

{
    [ValidateInput(false)]
    [LdapAuthorization]
    public class FileSystemController : BaseController
    {
        private readonly ICryptography _cryptography;
        private readonly IWebDavManager _webdavManager;
        private readonly IAuthenticationService _authenticationService;
        private readonly IAccessTokenManager _tokenManager;
        private readonly IWebDavAuthorizationService _webDavAuthorizationService;
        private readonly IUserSettingsManager _userSettingsManager;
        private readonly FileOpenerManager _openerManager;
        private readonly ILog Log;

        public FileSystemController(ICryptography cryptography, IWebDavManager webdavManager, IAuthenticationService authenticationService, IAccessTokenManager tokenManager, IWebDavAuthorizationService webDavAuthorizationService, FileOpenerManager openerManager, IUserSettingsManager userSettingsManager)
        {
            _cryptography = cryptography;
            _webdavManager = webdavManager;
            _authenticationService = authenticationService;
            _tokenManager = tokenManager;
            _webDavAuthorizationService = webDavAuthorizationService;
            _userSettingsManager = userSettingsManager;

            Log = LogManager.GetLogger(this.GetType());
            _openerManager = new FileOpenerManager();
        }

        [HttpGet]
        public ActionResult ChangeViewType(FolderViewTypes viewType, string org, string pathPart = "")
        {
            _userSettingsManager.ChangeWebDavViewType(WspContext.User.AccountId, viewType);

            return RedirectToRoute(FileSystemRouteNames.ShowContentPath, new  { org, pathPart });
        }

        public ActionResult ShowContent(string org, string pathPart = "", string searchValue = "")
        {
            if (org != WspContext.User.OrganizationId)
            {
                return new HttpStatusCodeResult(HttpStatusCode.NoContent);
            }

            if (_webdavManager.IsFile(pathPart))
            {
                var resource = _webdavManager.GetResource(pathPart);

                var mimeType = _openerManager.GetMimeType(Path.GetExtension(pathPart));

                return new FileStreamResult(resource.GetReadStream(), mimeType);
            }

            try
            {
                var model = new ModelForWebDav
                {
                    UrlSuffix = pathPart, 
                    Permissions =_webDavAuthorizationService.GetPermissions(WspContext.User, pathPart),
                    UserSettings = _userSettingsManager.GetUserSettings(WspContext.User.AccountId),
                    SearchValue = searchValue
                };

                if (Request.Browser.IsMobileDevice)
                {
                    model.UserSettings.WebDavViewType = FolderViewTypes.BigIcons;
                }

                return View(model);
            }
            catch (UnauthorizedException e)
            {
                throw new HttpException(404, "Not Found");
            }
        }

        [ChildActionOnly]
        public ActionResult ContentList(string org, ModelForWebDav model, string pathPart = "")
        {
            try
            {
                if (Request.Browser.IsMobileDevice == false && model.UserSettings.WebDavViewType == FolderViewTypes.Table)
                {
                    return PartialView("_ShowContentTable", model);
                }

                IEnumerable<IHierarchyItem> children;

                if (string.IsNullOrEmpty(model.SearchValue))
                {
                    children = _webdavManager.OpenFolder(pathPart);
                }
                else
                {
                    children = _webdavManager.SearchFiles(WspContext.User.ItemId, pathPart, model.SearchValue, WspContext.User.Login, true);
                }

                model.Items = children.Take(WebDavAppConfigManager.Instance.ElementsRendering.DefaultCount);

                return PartialView("_ShowContentBigIcons", model);
            }
            catch (UnauthorizedException e)
            {
                throw new HttpException(404, "Not Found");
            }
        }

        [HttpGet]
        public ActionResult GetContentDetails(string org, string pathPart, [ModelBinder(typeof (JqueryDataTableModelBinder))] JqueryDataTableRequest dtRequest)
        {
            IEnumerable<WebDavResource> folderItems;

            if (string.IsNullOrEmpty(dtRequest.Search.Value) == false)
            {
                folderItems = _webdavManager.SearchFiles(WspContext.User.ItemId, pathPart, dtRequest.Search.Value, WspContext.User.Login, true).Cast<WebDavResource>();
            }
            else
            {
                folderItems = _webdavManager.OpenFolder(pathPart).Cast<WebDavResource>();
            }

            var tableItems = Mapper.Map<IEnumerable<WebDavResource>, IEnumerable<ResourceTableItemModel>>(folderItems).ToList();

            FillContentModel(tableItems, org);

            var orders = dtRequest.Orders.ToList();
            orders.Insert(0, new JqueryDataTableOrder{Column = 3, Ascending = false});

            dtRequest.Orders = orders;

            var dataTableResponse = DataTableHelper.ProcessRequest(tableItems, dtRequest);

            return Json(dataTableResponse, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ShowAdditionalContent(string path = "", int resourseRenderCount = 0)
        {
            path = path.Replace(WspContext.User.OrganizationId, "").Trim('/');

            IEnumerable<IHierarchyItem> children = _webdavManager.OpenFolder(path);

            var result = children.Skip(resourseRenderCount).Take(WebDavAppConfigManager.Instance.ElementsRendering.AddElementsCount);

            return PartialView("_ResourseCollectionPartial", result);
        }

        public ActionResult SearchFiles(string org, string pathPart, string searchValue)
        {
            if (string.IsNullOrEmpty(searchValue))
            {
                return RedirectToRoute(FileSystemRouteNames.ShowContentPath);
            }

            var model = new ModelForWebDav
            {
                UrlSuffix = pathPart,
                Permissions = _webDavAuthorizationService.GetPermissions(WspContext.User, pathPart),
                UserSettings = _userSettingsManager.GetUserSettings(WspContext.User.AccountId),
                SearchValue = searchValue
            };

            return View("ShowContentSearchResultTable", model);
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
                throw new Exception(Resources.UI.NotAFile);
            }

            var fileBytes = _webdavManager.GetFileBytes(pathPart);

            return File(fileBytes, MediaTypeNames.Application.Octet, fileName);
        }

        [HttpGet]
        public ActionResult UploadFiles(string org, string pathPart)
        {
            var model = new ModelForWebDav
            {
                UrlSuffix = pathPart
            };

            return View(model);
        }

        [HttpPost]
        [ActionName("UploadFiles")]
        public ActionResult UploadFilePost(string org, string pathPart)
        {
            var uploadResults = new List<UploadFileResult>();

            foreach (string file in Request.Files)
            {
                var hpf = Request.Files[file] as HttpPostedFileBase;

                if (hpf == null || hpf.ContentLength == 0)
                {
                    continue;
                }

                _webdavManager.UploadFile(pathPart, hpf);

                uploadResults.Add(new UploadFileResult()
                {
                    name = hpf.FileName,
                    size = hpf.ContentLength,
                    type = hpf.ContentType
                });
            }

            var result = Json(new { files = uploadResults });

            //for IE8 which does not accept application/json
            if (Request.Headers["Accept"] != null && !Request.Headers["Accept"].Contains("application/json"))
            {
                result.ContentType = MediaTypeNames.Text.Plain;
            }

            return result;
        }

        [HttpPost]
        public JsonResult DeleteFiles(IEnumerable<string> filePathes = null)
        {
            var model = new DeleteFilesModel();

            if (filePathes == null)
            {
                AddMessage(MessageType.Error, Resources.UI.NoFilesAreSelected);

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
                model.AddMessage(MessageType.Success, string.Format(Resources.UI.ItemsWasRemovedFormat, model.DeletedFiles.Count));
            }

            return Json(model);
        }

        public ActionResult NewWebDavItem(string org, string pathPart)
        {
            var permissions = _webDavAuthorizationService.GetPermissions(WspContext.User, pathPart);

            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.FirstOrDefault(x => x.Extension == Path.GetExtension(pathPart));

            if (permissions.HasFlag(WebDavPermissions.Write) == false || (owaOpener != null && permissions.HasFlag(WebDavPermissions.OwaEdit) == false))
            {
                return new RedirectToRouteResult(FileSystemRouteNames.ShowContentPath, null);
            }

            if (owaOpener != null)
            {
                return ShowOfficeDocument(org, pathPart, owaOpener.OwaNewFileView);
            }

            return new RedirectToRouteResult(FileSystemRouteNames.ShowContentPath, null);
        }

        [HttpPost]
        public JsonResult ItemExist(string org, string pathPart, string newItemName)
        {
            var exist = _webdavManager.FileExist(string.Format("{0}/{1}", pathPart.TrimEnd('/'), newItemName.Trim('/')));

            return new JsonResult()
            {
                Data = !exist
            };
        }

        #region Owa Actions

        public ActionResult ShowOfficeDocument(string org, string pathPart, string owaOpenerUri)
        {
            string fileUrl = WebDavAppConfigManager.Instance.WebdavRoot + org + "/" + pathPart.TrimStart('/');
            var accessToken = _tokenManager.CreateToken(WspContext.User, pathPart);

            var urlPart = Url.HttpRouteUrl(OwaRouteNames.CheckFileInfo, new { accessTokenId = accessToken.Id });
            var url = new Uri(Request.Url, urlPart).ToString();

            string wopiSrc = Server.UrlDecode(url);

            var uri = string.Format("{0}/{1}WOPISrc={2}&access_token={3}", WebDavAppConfigManager.Instance.OfficeOnline.Url, owaOpenerUri, Server.UrlEncode(wopiSrc), Server.UrlEncode(accessToken.AccessToken.ToString("N")));

            string fileName = fileUrl.Split('/').Last();
            string folder = pathPart.ReplaceLast(fileName, "").Trim('/');

            return View("ShowOfficeDocument", new OfficeOnlineModel(uri, fileName, folder));
        }

        public ActionResult ViewOfficeDocument(string org, string pathPart)
        {
            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.Single(x => x.Extension == Path.GetExtension(pathPart));

            var owaOpenerUrl = Request.Browser.IsMobileDevice ? owaOpener.OwaMobileViev : owaOpener.OwaView;

            return ShowOfficeDocument(org, pathPart, owaOpenerUrl);
        }

        public ActionResult EditOfficeDocument(string org, string pathPart)
        {
            var permissions = _webDavAuthorizationService.GetPermissions(WspContext.User, pathPart);

            if (permissions.HasFlag(WebDavPermissions.Write) == false || permissions.HasFlag(WebDavPermissions.OwaEdit) == false || Request.Browser.IsMobileDevice)
            {
                return new RedirectToRouteResult(FileSystemRouteNames.ViewOfficeOnline, null);
            }

            var owaOpener = WebDavAppConfigManager.Instance.OfficeOnline.Single(x => x.Extension == Path.GetExtension(pathPart));

            return ShowOfficeDocument(org, pathPart, owaOpener.OwaEditor);
        }

        #endregion

        private void FillContentModel(IEnumerable<ResourceTableItemModel> items, string organizationId)
        {
            foreach (var item in items)
            {
                var opener = _openerManager[Path.GetExtension(item.DisplayName)];
                //var pathPart = item.Href.ToString().Replace("/" + WspContext.User.OrganizationId, "").TrimStart('/');
                var pathPart = item.Href.ToStringPath().Replace("/" + WspContext.User.OrganizationId, "").TrimStart('/');

                switch (opener)
                {
                    case FileOpenerType.OfficeOnline:
                    {
                        item.Url = string.Concat(Url.RouteUrl(FileSystemRouteNames.EditOfficeOnline, new {org = WspContext.User.OrganizationId, pathPart = ""}), pathPart);
                        break;
                    }
                    default:
                    {
                        item.Url = item.Href.LocalPath;
                        break;
                    }
                }

                var folderPath = Server.UrlDecode(_webdavManager.GetFileFolderPath(pathPart));

                item.FolderUrlAbsoluteString =  Server.UrlDecode(Url.RouteUrl(FileSystemRouteNames.ShowContentPath, new  {org = organizationId, pathPart = folderPath}, Request.Url.Scheme));
                item.FolderUrlLocalString = Url.RouteUrl(FileSystemRouteNames.ShowContentPath, new { org = organizationId, pathPart = folderPath });

                if (Request.Browser.IsMobileDevice)
                {
                    item.IsTargetBlank = false;
                }
            }
        }
    }
}