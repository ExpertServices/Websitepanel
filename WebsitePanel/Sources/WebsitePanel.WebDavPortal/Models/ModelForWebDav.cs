using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;
using WebsitePanel.WebDavPortal.Models.Common;

namespace WebsitePanel.WebDavPortal.Models
{
    public class ModelForWebDav : BaseModel
    {
        public IEnumerable<IHierarchyItem> Items { get; set; }
        public string UrlSuffix { get; set; }
        public string Error { get; set; }
        public WebDavPermissions Permissions { get; set; }
    }
}