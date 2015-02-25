using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml.Serialization;
using log4net;
using WebsitePanel.Providers.OS;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDav.Core.Extensions;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Resources;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Managers
{
    public class WebDavManager : IWebDavManager
    {
        private readonly ICryptography _cryptography;
        private readonly WebDavSession _webDavSession;
        private readonly IWebDavAuthorizationService _webDavAuthorizationService;

        private readonly ILog Log;

        private bool _isRoot = true;
        private IFolder _currentFolder;

        public WebDavManager(ICryptography cryptography, IWebDavAuthorizationService webDavAuthorizationService)
        {
            _cryptography = cryptography;
            _webDavAuthorizationService = webDavAuthorizationService;
            Log = LogManager.GetLogger(this.GetType());

            _webDavSession = new WebDavSession();
        }

        public IEnumerable<IHierarchyItem> OpenFolder(string pathPart)
        {
            IHierarchyItem[] children;

            if (string.IsNullOrWhiteSpace(pathPart))
            {
                children = ConnectToWebDavServer().Select(x => new WebDavResource
                {
                    Href = new Uri(x.Url), 
                    ItemType = ItemType.Folder, 
                    ContentLength = x.Size, 
                    AllocatedSpace = x.FRSMQuotaMB, 
                    IsRootItem = true
                }).ToArray();
            }
            else
            {
                if (_currentFolder == null || _currentFolder.Path.ToString() != pathPart)
                {
                    _webDavSession.Credentials = new NetworkCredential(WspContext.User.Login,
                        _cryptography.Decrypt(WspContext.User.EncryptedPassword),
                        WebDavAppConfigManager.Instance.UserDomain);

                    _currentFolder = _webDavSession.OpenFolder(string.Format("{0}{1}/{2}", WebDavAppConfigManager.Instance.WebdavRoot, WspContext.User.OrganizationId, pathPart.TrimStart('/')));
                }

                children = FilterResult(_currentFolder.GetChildren()).ToArray();
            }

            List<IHierarchyItem> sortedChildren = children.Where(x => x.ItemType == ItemType.Folder).OrderBy(x => x.DisplayName).ToList();
            sortedChildren.AddRange(children.Where(x => x.ItemType != ItemType.Folder).OrderBy(x => x.DisplayName));

            return sortedChildren;
        }

        public IEnumerable<IHierarchyItem> SearchFiles(int itemId, string pathPart, string searchValue, string uesrPrincipalName, bool recursive)
        {
            pathPart = (pathPart ?? string.Empty).Replace("/","\\");

            var items = WspContext.Services.EnterpriseStorage.SearchFiles(itemId, pathPart, searchValue, uesrPrincipalName, recursive);

            var resources = Convert(items, new Uri(WebDavAppConfigManager.Instance.WebdavRoot).Append(WspContext.User.OrganizationId, pathPart));

            if (string.IsNullOrWhiteSpace(pathPart))
            {
                var rootItems = ConnectToWebDavServer().ToArray();

                foreach (var resource in resources)
                {
                    var rootItem = rootItems.FirstOrDefault(x => x.Name == resource.DisplayName);

                    if (rootItem == null)
                    {
                        continue;
                    }

                    resource.ContentLength = rootItem.Size;
                    resource.AllocatedSpace = rootItem.FRSMQuotaMB;
                    resource.IsRootItem = true;
                }
            }

            return FilterResult(resources);
        }

        public bool IsFile(string path)
        {
            string folder = GetFileFolder(path);

            if (string.IsNullOrWhiteSpace(folder))
            {
                return false;
            }

            var resourceName = GetResourceName(path);

            OpenFolder(folder);

            IResource resource = _currentFolder.GetResource(resourceName);

            return resource.ItemType != ItemType.Folder;
        }


        public byte[] GetFileBytes(string path)
        {
            try
            {
                string folder = GetFileFolder(path);

                var resourceName = GetResourceName(path);

                OpenFolder(folder);

                IResource resource = _currentFolder.GetResource(resourceName);

                Stream stream = resource.GetReadStream();
                byte[] fileBytes = ReadFully(stream);

                return fileBytes;
            }
            catch (InvalidOperationException exception)
            {
                throw new ResourceNotFoundException("Resource not found", exception);
            }
        }

        public void UploadFile(string path, HttpPostedFileBase file)
        {
            var resource = new WebDavResource();

            var fileUrl = new Uri(WebDavAppConfigManager.Instance.WebdavRoot)
                .Append(WspContext.User.OrganizationId)
                .Append(path)
                .Append(Path.GetFileName(file.FileName));

            resource.SetHref(fileUrl);
            resource.SetCredentials(new NetworkCredential(WspContext.User.Login,  _cryptography.Decrypt(WspContext.User.EncryptedPassword)));

            file.InputStream.Seek(0, SeekOrigin.Begin);
            var bytes = ReadFully(file.InputStream);

            resource.Upload(bytes);
        }

        public void UploadFile(string path, byte[] bytes)
        {
            var resource = new WebDavResource();

            var fileUrl = new Uri(WebDavAppConfigManager.Instance.WebdavRoot)
                .Append(WspContext.User.OrganizationId)
                .Append(path);

            resource.SetHref(fileUrl);
            resource.SetCredentials(new NetworkCredential(WspContext.User.Login, _cryptography.Decrypt(WspContext.User.EncryptedPassword)));

            resource.Upload(bytes);
        }

        public void UploadFile(string path, Stream stream)
        {
            var resource = new WebDavResource();

            var fileUrl = new Uri(WebDavAppConfigManager.Instance.WebdavRoot)
                .Append(WspContext.User.OrganizationId)
                .Append(path);

            resource.SetHref(fileUrl);
            resource.SetCredentials(new NetworkCredential(WspContext.User.Login, _cryptography.Decrypt(WspContext.User.EncryptedPassword)));

            var bytes = ReadFully(stream);

            resource.Upload(bytes);
        }

        public void LockFile(string path)
        {
            var resource = new WebDavResource();

            var fileUrl = new Uri(WebDavAppConfigManager.Instance.WebdavRoot)
                .Append(WspContext.User.OrganizationId)
                .Append(path);

            resource.SetHref(fileUrl);
            resource.SetCredentials(new NetworkCredential(WspContext.User.Login, _cryptography.Decrypt(WspContext.User.EncryptedPassword)));

            resource.Lock();
        }

        public void DeleteResource(string path)
        {
            path = RemoveLeadingFromPath(path, "office365");
            path = RemoveLeadingFromPath(path, "view");
            path = RemoveLeadingFromPath(path, "edit");
            path = RemoveLeadingFromPath(path, WspContext.User.OrganizationId);

            string folderPath = GetFileFolder(path);

            OpenFolder(folderPath);

            var resourceName = GetResourceName(path);

            IResource resource = _currentFolder.GetResource(resourceName);

            if (resource.ItemType == ItemType.Folder && GetFoldersItemsCount(path) > 0)
            {
                throw new WebDavException(string.Format(WebDavResources.FolderIsNotEmptyFormat, resource.DisplayName));
            }

            resource.Delete();
        }

        public IResource GetResource(string path)
        {
            try
            {
                string folder = GetFileFolder(path);

                var resourceName = GetResourceName(path);

                OpenFolder(folder);

                return _currentFolder.GetResource(resourceName);
            }
            catch (InvalidOperationException exception)
            {
                throw new ResourceNotFoundException("Resource not found", exception);
            }
        }

        public bool FileExist(string path)
        {
            try
            {
                string folder = GetFileFolder(path);

                var resourceName = GetResourceName(path);

                OpenFolder(folder);

                var resource = _currentFolder.GetResource(resourceName);

                return resource != null;
            }
            catch (InvalidOperationException exception)
            {
                return false;
            }
        }

        public string GetFileUrl(string path)
        {
            try
            {
                string folder = GetFileFolder(path);

                var resourceName = GetResourceName(path);

                OpenFolder(folder);

                IResource resource =  _currentFolder.GetResource(resourceName);
                return resource.Href.ToString();
            }
            catch (InvalidOperationException exception)
            {
                throw new ResourceNotFoundException("Resource not found", exception);
            }
        }

        private IList<SystemFile> ConnectToWebDavServer()
        {
            var rootFolders = new List<SystemFile>();
            var user = WspContext.User;

            var userGroups = WSP.Services.Organizations.GetSecurityGroupsByMember(user.ItemId, user.AccountId);

            foreach (var folder in WSP.Services.EnterpriseStorage.GetEnterpriseFolders(WspContext.User.ItemId))
            {
                var permissions = WSP.Services.EnterpriseStorage.GetEnterpriseFolderPermissions(WspContext.User.ItemId, folder.Name);

                foreach (var permission in permissions)
                {
                    if ((!permission.IsGroup 
                            && (permission.DisplayName == user.UserName || permission.DisplayName == user.DisplayName))
                        || (permission.IsGroup && userGroups.Any(x => x.DisplayName == permission.DisplayName)))
                    {
                        rootFolders.Add(folder);
                        break;
                    }
                }
            }

            return rootFolders;
        }

        private int GetFoldersItemsCount(string path)
        {
            var items = OpenFolder(path);

            return items.Count();
        }

        #region Helpers

        private string RemoveLeadingFromPath(string pathPart, string toRemove)
        {
            return pathPart.StartsWith('/' + toRemove) ? pathPart.Substring(toRemove.Length + 1) : pathPart;
        }

        private IEnumerable<WebDavResource> Convert(IEnumerable<SystemFile> files, Uri baseUri)
        {
            var convertResult = new List<WebDavResource>();

            var credentials = new NetworkCredential(WspContext.User.Login,
                _cryptography.Decrypt(WspContext.User.EncryptedPassword),
                WebDavAppConfigManager.Instance.UserDomain);

            foreach (var file in files)
            {
                 var webDavitem = new WebDavResource();

                webDavitem.SetCredentials(credentials);

                webDavitem.SetHref(baseUri.Append(file.RelativeUrl.Replace("\\","/")));

                webDavitem.SetItemType(file.IsDirectory? ItemType.Folder : ItemType.Resource);
                webDavitem.SetLastModified(file.Changed);
                webDavitem.ContentLength = file.Size;
                webDavitem.AllocatedSpace = file.FRSMQuotaMB;

                convertResult.Add(webDavitem);
            }

            return convertResult;
        }

        private byte[] ReadFully(Stream input)
        {
            var buffer = new byte[16 * 1024];
            using (var ms = new MemoryStream())
            {
                int read;
                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                    ms.Write(buffer, 0, read);
                return ms.ToArray();
            }
        }

        public void WriteTo(Stream sourceStream, Stream targetStream)
        {
            byte[] buffer = new byte[16 * 1024];
            int n;
            while ((n = sourceStream.Read(buffer, 0, buffer.Length)) != 0)
                targetStream.Write(buffer, 0, n);
        }

        private string GetFileFolder(string path)
        {
            path = path.TrimEnd('/');

            if (string.IsNullOrEmpty(path) || !path.Contains('/'))
            {
                return string.Empty;
            }

            string fileName = path.Split('/').Last();
            int index = path.LastIndexOf(fileName, StringComparison.InvariantCultureIgnoreCase);
            string folder = string.IsNullOrEmpty(fileName)? path : path.Remove(index - 1, fileName.Length + 1);

            return folder;
        }

        private string GetResourceName(string path)
        {
            path = path.TrimEnd('/');

            if (string.IsNullOrEmpty(path) || !path.Contains('/'))
            {
                return string.Empty;
            }

            return path.Split('/').Last(); ;
        }

        private IEnumerable<IHierarchyItem> FilterResult(IEnumerable<IHierarchyItem> items)
        {
            var result = items.ToList();

            foreach (var item in items)
            {
                foreach (var itemToIgnore in WebDavAppConfigManager.Instance.FilesToIgnore)
                {
                    var regex = new Regex(itemToIgnore.Regex);

                    Match match = regex.Match(item.DisplayName.Trim('/'));

                    if (match.Success && result.Contains(item))
                    {
                        result.Remove(item);

                        break;
                    }
                }
            }

            return result;
        }

        #endregion
    }
}