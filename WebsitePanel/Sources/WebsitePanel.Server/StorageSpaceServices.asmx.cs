using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Microsoft.Web.Services3;
using WebsitePanel.Providers;
using WebsitePanel.Providers.EnterpriseStorage;
using WebsitePanel.Providers.OS;
using WebsitePanel.Providers.StorageSpaces;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Server
{
    /// <summary>
    /// Summary description for StorageSpace
    /// </summary>
    [WebService(Namespace = "http://smbsaas/websitepanel/server/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [Policy("ServerPolicy")]
    [ToolboxItem(false)]
    public class StorageSpaceServices : HostingServiceProviderWebService, IStorageSpace
    {
        private IStorageSpace StorageSpaceProvider
        {
            get { return (IStorageSpace)Provider; }
        }

        [WebMethod, SoapHeader("settings")]
        public List<SystemFile> GetAllDriveLetters()
        {
            try
            {
                Log.WriteStart("'{0}' GetAllDriveLetters", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.GetAllDriveLetters();
                Log.WriteEnd("'{0}' GetAllDriveLetters", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetAllDriveLetters", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public List<SystemFile> GetSystemSubFolders(string path)
        {
            try
            {
                Log.WriteStart("'{0}' GetSystemFolders", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.GetSystemSubFolders(path);
                Log.WriteEnd("'{0}' GetSystemFolders", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetSystemFolders", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void UpdateStorageSettings(string fullPath, long qouteSizeBytes, QuotaType type)
        {
            try
            {
                Log.WriteStart("'{0}' UpdateStorageSettings", ProviderSettings.ProviderName);
                StorageSpaceProvider.UpdateStorageSettings(fullPath, qouteSizeBytes, type);
                Log.WriteEnd("'{0}' UpdateStorageSettings", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' UpdateStorageSettings", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void ClearStorageSettings(string fullPath, string uncPath)
        {
            try
            {
                Log.WriteStart("'{0}' ClearStorageSettings", ProviderSettings.ProviderName);
                StorageSpaceProvider.ClearStorageSettings(fullPath, uncPath);
                Log.WriteEnd("'{0}' ClearStorageSettings", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' ClearStorageSettings", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void UpdateFolderQuota(string fullPath, long qouteSizeBytes, QuotaType type)
        {
            try
            {
                Log.WriteStart("'{0}' UpdateFolderQuota", ProviderSettings.ProviderName);
                StorageSpaceProvider.UpdateFolderQuota(fullPath, qouteSizeBytes, type);
                Log.WriteEnd("'{0}' UpdateFolderQuota", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' UpdateFolderQuota", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void CreateFolder(string fullPath)
        {
            try
            {
                Log.WriteStart("'{0}' CreateFolder", ProviderSettings.ProviderName);
                StorageSpaceProvider.CreateFolder(fullPath);
                Log.WriteEnd("'{0}' CreateFolder", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' CreateFolder", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public StorageSpaceFolderShare ShareFolder(string fullPath, string shareName)
        {
            try
            {
                Log.WriteStart("'{0}' ShareFolder", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.ShareFolder(fullPath, shareName);
                Log.WriteEnd("'{0}' ShareFolder", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' ShareFolder", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public Quota GetFolderQuota(string fullPath)
        {
            try
            {
                Log.WriteStart("'{0}' GetFolderQuota", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.GetFolderQuota(fullPath);
                Log.WriteEnd("'{0}' GetFolderQuota", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetFolderQuota", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void DeleteFolder(string fullPath)
        {
            try
            {
                Log.WriteStart("'{0}' DeleteFolder", ProviderSettings.ProviderName);
                StorageSpaceProvider.DeleteFolder(fullPath);
                Log.WriteEnd("'{0}' DeleteFolder", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' DeleteFolder", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool RenameFolder(string originalPath, string newName)
        {
            try
            {
                Log.WriteStart("'{0}' RenameFolder", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.RenameFolder(originalPath, newName);
                Log.WriteEnd("'{0}' RenameFolder", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' RenameFolder", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool FileOrDirectoryExist(string fullPath)
        {
            try
            {
                Log.WriteStart("'{0}' FileOrDirectoryExist", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.FileOrDirectoryExist(fullPath);
                Log.WriteEnd("'{0}' FileOrDirectoryExist", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' FileOrDirectoryExist", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void SetFolderNtfsPermissions(string fullPath, UserPermission[] permissions, bool isProtected, bool preserveInheritance)
        {
            try
            {
                Log.WriteStart("'{0}' SetFolderNtfsPermissions", ProviderSettings.ProviderName);
                StorageSpaceProvider.SetFolderNtfsPermissions(fullPath, permissions, isProtected, preserveInheritance);
                Log.WriteEnd("'{0}' SetFolderNtfsPermissions", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' SetFolderNtfsPermissions", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public SystemFile[] Search(string[] searchPaths, string searchText, bool recursive)
        {
            try
            {
                Log.WriteStart("'{0}' Search", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.Search(searchPaths, searchText, recursive);
                Log.WriteEnd("'{0}' Search", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' Search", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public byte[] GetFileBinaryChunk(string path, int offset, int length)
        {
            try
            {
                Log.WriteStart("'{0}' GetFileBinaryChunk", ProviderSettings.ProviderName);
                var result = StorageSpaceProvider.GetFileBinaryChunk(path, offset, length);
                Log.WriteEnd("'{0}' GetFileBinaryChunk", ProviderSettings.ProviderName);

                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetFileBinaryChunk", ProviderSettings.ProviderName), ex);
                throw;
            }
        }
    }
}
