using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;

namespace WebsitePanel.WebDavPortal.Models
{
    public interface IWebDavManager
    {
        string RootPath { get; }
        string OrganizationName { get; }
        void OpenFolder(string pathPart);
        IEnumerable<IHierarchyItem> GetChildren();
        bool IsFile(string fileName);
        byte[] GetFileBytes(string fileName);
        string GetFileUrl(string fileName);
    }
}