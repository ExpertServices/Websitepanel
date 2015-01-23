using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;

namespace WebsitePanel.WebDavPortal.Models
{
    public class ModelForWebDav
    {
        public IEnumerable<IHierarchyItem> Items { get; set; }
        public string UrlSuffix { get; set; }
        public string Error { get; set; }
        public WebDavPermissions Permissions { get; set; }
    }
}