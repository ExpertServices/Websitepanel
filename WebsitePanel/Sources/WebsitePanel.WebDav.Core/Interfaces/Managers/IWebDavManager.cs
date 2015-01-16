using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;

namespace WebsitePanel.WebDav.Core.Interfaces.Managers
{
    public interface IWebDavManager
    {
        string RootPath { get; }
        void OpenFolder(string pathPart);
        IEnumerable<IHierarchyItem> GetChildren();
        bool IsFile(string fileName);
        byte[] GetFileBytes(string fileName);
        IResource GetResource( string fileName);
        string GetFileUrl(string fileName);

        string CreateFileId(string path);
        string FilePathFromId(string id);
    }
}