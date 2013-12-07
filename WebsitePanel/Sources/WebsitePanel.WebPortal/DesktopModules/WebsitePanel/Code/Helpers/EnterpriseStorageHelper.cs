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
    }
}