using WebsitePanel.Providers.OS;

namespace WebsitePanel.Providers.StorageSpaces
{
    public class StorageSpaceItem
    {
        public QuotaType FsrmQuotaType { get; set; }
        public long FsrmQuotaSizeBytes { get; set; }
        public long UsedSizeBytes { get; set; }

        public bool IsShared { get; set; }
        public string UncPath { get; set; } 
    }
}