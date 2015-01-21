using System.Collections.Generic;
using System.Web;
using WebsitePanel.WebDav.Core.Client;

namespace WebsitePanel.WebDav.Core.Interfaces.Managers
{
    public interface IWebDavManager
    {
        IEnumerable<IHierarchyItem> OpenFolder(string path);
        bool IsFile(string path);
        byte[] GetFileBytes(string path);
        void UploadFile(string path, HttpPostedFileBase file);
        IResource GetResource(string path);
        string GetFileUrl(string path);
    }
}