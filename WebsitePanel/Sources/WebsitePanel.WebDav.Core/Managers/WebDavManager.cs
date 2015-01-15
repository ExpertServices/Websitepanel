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

        private IFolder _currentFolder;
        private bool _isRoot = true;

        private Lazy<IList<SystemFile>> _rootFolders;
        private Lazy<string> _webDavRootPath;

        public string RootPath 
        {
            get { return _webDavRootPath.Value; }
        }

        public WebDavManager(ICryptography cryptography)
        {
            _cryptography = cryptography;
            Log = LogManager.GetLogger(this.GetType());

            _webDavSession = new WebDavSession();

            _rootFolders = new Lazy<IList<SystemFile>>(ConnectToWebDavServer);
            _webDavRootPath = new Lazy<string>(() =>
            {
                if (_rootFolders.Value.Any())
                {
                    var folder = _rootFolders.Value.First();
                    var uri = new Uri(folder.Url);
                    return uri.Scheme + "://" + uri.Host + uri.Segments[0] + uri.Segments[1];
                }

                return string.Empty;
            });
            
        }

        public void OpenFolder(string pathPart)
        {
            if (string.IsNullOrWhiteSpace(pathPart))
            {
                _isRoot = true;
                return;
            }

            _isRoot = false;

            _webDavSession.Credentials = new NetworkCredential(WspContext.User.Login, _cryptography.Decrypt(WspContext.User.EncryptedPassword), WebDavAppConfigManager.Instance.UserDomain);

            _currentFolder = _webDavSession.OpenFolder(_webDavRootPath.Value + pathPart);
        }

        public IEnumerable<IHierarchyItem> GetChildren()
        {
            IHierarchyItem[] children;

            if (_isRoot)
            {
                children = _rootFolders.Value.Select(x => new WebDavHierarchyItem {Href = new Uri(x.Url), ItemType = ItemType.Folder}).ToArray();
            }
            else
	        {
                children = _currentFolder.GetChildren();
	        }

            List<IHierarchyItem> sortedChildren = children.Where(x => x.ItemType == ItemType.Folder).OrderBy(x => x.DisplayName).ToList();
            sortedChildren.AddRange(children.Where(x => x.ItemType != ItemType.Folder).OrderBy(x => x.DisplayName));

            return sortedChildren;
        }

        public bool IsFile(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName) | _currentFolder == null)
                return false;

            try
            {
                IResource resource = _currentFolder.GetResource(fileName);
                //Stream stream = resource.GetReadStream();
                return true;
            }
            catch (InvalidOperationException)
            {
            }
            return false;
        }

        public byte[] GetFileBytes(string fileName)
        {
            try
            {
                IResource resource = _currentFolder.GetResource(fileName);
                Stream stream = resource.GetReadStream();
                byte[] fileBytes = ReadFully(stream);
                return fileBytes;
            }
            catch (InvalidOperationException exception)
            {
                throw new ResourceNotFoundException("Resource not found", exception);
            }
        }

        public IResource GetResource(string fileName)
        {
            try
            {
                IResource resource = _currentFolder.GetResource(fileName);
                return resource;
            }
            catch (InvalidOperationException exception)
            {
                throw new ResourceNotFoundException("Resource not found", exception);
            }
        }

        public string GetFileUrl(string fileName)
        {
            try
            {
                IResource resource = _currentFolder.GetResource(fileName);
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

        private byte[] ReadFully(Stream input)
        {
            var buffer = new byte[16*1024];
            using (var ms = new MemoryStream())
            {
                int read;
                while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
                    ms.Write(buffer, 0, read);
                return ms.ToArray();
            }
        }


        public string CreateFileId(string path)
        {
            return _cryptography.Encrypt(path).Replace("/", "AAAAA");
        }

        public string FilePathFromId(string id)
        {
            return _cryptography.Decrypt(id.Replace("AAAAA", "/"));
        }
    }
}