using WebsitePanel.WebDav.Core.Attributes.Resources;
using WebsitePanel.WebDav.Core.Resources;

namespace WebsitePanel.WebDav.Core
{
    namespace Client
    {
        public enum ItemType
        {
            [LocalizedDescription(typeof(WebDavResources), "ItemTypeResource")]
            Resource,
            [LocalizedDescription(typeof(WebDavResources), "ItemTypeFolder")]
            Folder,
            Version,
            VersionHistory
        }
    }
}