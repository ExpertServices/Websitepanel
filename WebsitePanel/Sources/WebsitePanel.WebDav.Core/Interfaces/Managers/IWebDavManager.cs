using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;

namespace WebsitePanel.WebDav.Core.Interfaces.Managers
{
    public interface IWebDavManager
    {
        IEnumerable<IHierarchyItem> OpenFolder(string path);
        bool IsFile(string path);
        byte[] GetFileBytes(string path);
        IResource GetResource(string path);
        string GetFileUrl(string path);
    }
}