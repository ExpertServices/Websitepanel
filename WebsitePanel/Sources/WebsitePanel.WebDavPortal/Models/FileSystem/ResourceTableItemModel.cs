using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDavPortal.Models.Common.DataTable;

namespace WebsitePanel.WebDavPortal.Models.FileSystem
{
    public class ResourceTableItemModel : JqueryDataTableBaseEntity
    {
        public string DisplayName { get; set; }
        public string Url { get; set; }
        public bool IsTargetBlank { get; set; }
        public long Size { get; set; }
        public string Type { get; set; }
        public string LastModified { get; set; }
        public string IconHref { get; set; }

        public override dynamic this[int index]
        {
            get
            {
                switch (index)
                {
                    case 1 :
                    {
                        return Size;
                    }
                    default:
                    {
                        return DisplayName;
                    }
                }
            }
        }
    }
}