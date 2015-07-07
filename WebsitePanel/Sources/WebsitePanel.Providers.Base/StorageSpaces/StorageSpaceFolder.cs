using System.IO;
using WebsitePanel.Providers.OS;

namespace WebsitePanel.Providers.StorageSpaces
{
    public class StorageSpaceFolder : StorageSpaceItem
    {
        public int Id { get; set; }
        public int StorageSpaceId { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
    }
}