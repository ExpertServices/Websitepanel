using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using Microsoft.Win32;

using WebsitePanel.Server.Utils;
using WebsitePanel.Providers.Utils;
using WebsitePanel.Providers.OS;

namespace WebsitePanel.Providers.EnterpriseStorage
{
    public class Windows2012 : HostingServiceProviderBase
    {

        #region Properties
        protected string UsersHome
        {
            get { return FileUtils.EvaluateSystemVariables(ProviderSettings["UsersHome"]); }
        }
        #endregion


        #region Folders
        public SystemFile[] GetFolders(string organizationId)
        {

            ArrayList items = new ArrayList();
            DirectoryInfo root = new DirectoryInfo(string.Format("{0}\\{1}", UsersHome, organizationId));

            // get directories
            DirectoryInfo[] dirs = root.GetDirectories();
            foreach (DirectoryInfo dir in dirs)
            {
                string fullName = System.IO.Path.Combine(string.Format("{0}\\{1}", UsersHome, organizationId), dir.Name);
                SystemFile fi = new SystemFile(dir.Name, fullName, true, 0, dir.CreationTime, dir.LastWriteTime);
                items.Add(fi);

                // check if the directory is empty
                fi.IsEmpty = (Directory.GetFileSystemEntries(fullName).Length == 0);
            }

            return (SystemFile[])items.ToArray(typeof(SystemFile));
        }

        public SystemFile GetFolder(string organizationId, string folder)
        {
            DirectoryInfo root = new DirectoryInfo(string.Format("{0}\\{1}\\{2}", UsersHome, organizationId, folder));
            string fullName = string.Format("{0}\\{1}\\{2}", UsersHome, organizationId, folder);
            return new SystemFile(root.Name, fullName, true, 0, root.CreationTime, root.LastWriteTime);
        }

        public void CreateFolder(string organizationId, string folder)
        {
            FileUtils.CreateDirectory(string.Format("{0}\\{1}\\{2}", UsersHome, organizationId, folder));
        }

        public void DeleteFolder(string organizationId, string folder)
        {
            FileUtils.DeleteDirectoryRecursive(string.Format("{0}\\{1}\\{2}", UsersHome, organizationId, folder));
        }

        public void SetFolderQuota(string organizationId, string folder, long quota)
        {


        }

        public bool CheckFileServicesInstallation()
        {
            return WebsitePanel.Server.Utils.OS.CheckFileServicesInstallation();
        }

        #endregion

        #region HostingServiceProvider methods
        public override string[] Install()
        {
            List<string> messages = new List<string>();

            // create folder if it not exists
            try
            {
                if (!FileUtils.DirectoryExists(UsersHome))
                {
                    FileUtils.CreateDirectory(UsersHome);
                }
            }
            catch (Exception ex)
            {
                messages.Add(String.Format("Folder '{0}' could not be created: {1}",
                    UsersHome, ex.Message));
            }
            return messages.ToArray();
        }

        public override void DeleteServiceItems(ServiceProviderItem[] items)
        {
            foreach (ServiceProviderItem item in items)
            {
                try
                {
                    if (item is HomeFolder)
                        // delete home folder
                        FileUtils.DeleteFile(item.Name);
                }
                catch (Exception ex)
                {
                    Log.WriteError(String.Format("Error deleting '{0}' {1}", item.Name, item.GetType().Name), ex);
                }
            }
        }

        public override ServiceProviderItemDiskSpace[] GetServiceItemsDiskSpace(ServiceProviderItem[] items)
        {
            List<ServiceProviderItemDiskSpace> itemsDiskspace = new List<ServiceProviderItemDiskSpace>();
            foreach (ServiceProviderItem item in items)
            {
                if (item is HomeFolder)
                {
                    try
                    {
                        string path = item.Name;

                        Log.WriteStart(String.Format("Calculating '{0}' folder size", path));

                        // calculate disk space
                        ServiceProviderItemDiskSpace diskspace = new ServiceProviderItemDiskSpace();
                        diskspace.ItemId = item.Id;
                        diskspace.DiskSpace = FileUtils.CalculateFolderSize(path);
                        itemsDiskspace.Add(diskspace);

                        Log.WriteEnd(String.Format("Calculating '{0}' folder size", path));
                    }
                    catch (Exception ex)
                    {
                        Log.WriteError(ex);
                    }
                }
            }
            return itemsDiskspace.ToArray();
        }

        #endregion

        public override bool IsInstalled()
        {
            Server.Utils.OS.WindowsVersion version = WebsitePanel.Server.Utils.OS.GetVersion();
            return version == WebsitePanel.Server.Utils.OS.WindowsVersion.WindowsServer2012;
        }
    }
}
