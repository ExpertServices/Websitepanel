using WebsitePanel.Providers.OS;

namespace WebsitePanel.Portal
{
    public class EnterpriseStorageHelper
    {
        #region Folders

        SystemFilesPaged folders;

        public int GetEnterpriseFoldersPagedCount(int itemId, string filterValue)
        {
            return folders.RecordsCount;
        }

        public SystemFile[] GetEnterpriseFoldersPaged(int itemId, string filterValue,
            int maximumRows, int startRowIndex, string sortColumn)
        {
            filterValue = filterValue ?? string.Empty;

            folders = ES.Services.EnterpriseStorage.GetEnterpriseFoldersPaged(itemId,
                filterValue, sortColumn, startRowIndex, maximumRows);

            return folders.PageItems;
        }

        #endregion

        #region Drive Maps

        MappedDrivesPaged mappedDrives;

        public int GetEnterpriseDriveMapsPagedCount(int itemId, string filterValue)
        {
            return mappedDrives.RecordsCount;
        }

        public MappedDrive[] GetEnterpriseDriveMapsPaged(int itemId, string filterValue,
            int maximumRows, int startRowIndex, string sortColumn)
        {
            filterValue = filterValue ?? string.Empty;

            mappedDrives = ES.Services.EnterpriseStorage.GetDriveMapsPaged(itemId,
                filterValue, sortColumn, startRowIndex, maximumRows);

            return mappedDrives.PageItems;
        }

        #endregion
    }
}