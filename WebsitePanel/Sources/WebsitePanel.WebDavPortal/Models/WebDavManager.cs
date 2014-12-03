using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.Exceptions;

namespace WebsitePanel.WebDavPortal.Models
{
    public class WebDavManager : IWebDavManager
    {
        private readonly WebDavSession _webDavSession = new WebDavSession();
        private IFolder _currentFolder;
        private string _webDavRootPath;

        public WebDavManager(ICredentials credentials)
        {
            _webDavSession.Credentials = credentials;
            ConnectToWebDavServer();
        }

        public WebDavManager()
        {
            ConnectToWebDavServer();
        }

        public void OpenFolder(string pathPart)
        {
            _currentFolder = _webDavSession.OpenFolder(_webDavRootPath + pathPart);
        }

        public IEnumerable<IHierarchyItem> GetChildren()
        {
            IHierarchyItem[] children = _currentFolder.GetChildren();
            List<IHierarchyItem> sortedChildren =
                children.Where(x => x.ItemType == ItemType.Folder).OrderBy(x => x.DisplayName).ToList();
            sortedChildren.AddRange(children.Where(x => x.ItemType != ItemType.Folder).OrderBy(x => x.DisplayName));

            return sortedChildren;
        }

        public bool IsFile(string fileName)
        {
            try
            {
                IResource resource = _currentFolder.GetResource(fileName);
                Stream stream = resource.GetReadStream();
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

        private void ConnectToWebDavServer()
        {
            string webDavServerPath = WebDavAppConfigManager.Instance.ConnectionStrings.WebDavServer;

            if (webDavServerPath == null ||
                !Regex.IsMatch(webDavServerPath, @"^http(s)?://([\w-]+.)+[\w-]+(/[\w- ./?%&=])?$"))
                throw new ConnectToWebDavServerException();
            if (webDavServerPath.Last() != '/') webDavServerPath += "/";
            _webDavRootPath = webDavServerPath;

            try
            {
                _currentFolder = _webDavSession.OpenFolder(_webDavRootPath);
            }
            catch (WebException exception)
            {
                throw new ConnectToWebDavServerException(
                    string.Format("Unable to connect to a remote WebDav server \"{0}\"", webDavServerPath), exception);
            }
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
    }
}