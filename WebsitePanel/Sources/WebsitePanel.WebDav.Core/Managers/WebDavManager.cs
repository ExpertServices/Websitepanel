using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using log4net;
using WebsitePanel.Providers.OS;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Exceptions;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Managers
{
    public class WebDavManager : IWebDavManager
    {
        private readonly ICryptography _cryptography;
        private readonly WebDavSession _webDavSession;

        private readonly ILog Log;

        private bool _isRoot = true;
        private IFolder _currentFolder;

        public WebDavManager(ICryptography cryptography)
        {
            _cryptography = cryptography;
            Log = LogManager.GetLogger(this.GetType());

            _webDavSession = new WebDavSession();
        }

        public IEnumerable<IHierarchyItem> OpenFolder(string pathPart)
        {
            IHierarchyItem[] children;

            if (string.IsNullOrWhiteSpace(pathPart))
            {
                children = ConnectToWebDavServer().Select(x => new WebDavHierarchyItem { Href = new Uri(x.Url), ItemType = ItemType.Folder }).ToArray();
            }
            else
            {
                if (_currentFolder == null || _currentFolder.Path.ToString() != pathPart)
                {
                    _webDavSession.Credentials = new NetworkCredential(WspContext.User.Login,
                        _cryptography.Decrypt(WspContext.User.EncryptedPassword),
                        WebDavAppConfigManager.Instance.UserDomain);

                    _currentFolder = _webDavSession.OpenFolder(string.Format("{0}{1}/{2}", WebDavAppConfigManager.Instance.WebdavRoot, WspContext.User.OrganizationId, pathPart));
                }

                children = _currentFolder.GetChildren();
            }

            List<IHierarchyItem> sortedChildren = children.Where(x => x.ItemType == ItemType.Folder).OrderBy(x => x.DisplayName).ToList();
            sortedChildren.AddRange(children.Where(x => x.ItemType != ItemType.Folder).OrderBy(x => x.DisplayName));

            return sortedChildren;
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

            try
            {
                IResource resource = _currentFolder.GetResource(resourceName);

                return true;
            }
            catch (Exception e){}

            return false;
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

        #region Helpers

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

        #endregion
    }
}