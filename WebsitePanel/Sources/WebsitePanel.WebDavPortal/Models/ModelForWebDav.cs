using System.Collections.Generic;
using WebsitePanel.WebDav.Core.Client;

namespace WebsitePanel.WebDavPortal.Models
{
    public class ModelForWebDav
    {
        public IEnumerable<IHierarchyItem> Items { get; set; }
        public string UrlSuffix { get; set; }
        public string Error { get; set; }
    }
}