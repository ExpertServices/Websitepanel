using WebsitePanel.Providers.StorageSpaces;

namespace WebsitePanel.EnterpriseServer
{
    public interface IStorageSpaceSelector
    {
        StorageSpace FindBest(string groupName, long quotaSizeInBytes);
    }
}