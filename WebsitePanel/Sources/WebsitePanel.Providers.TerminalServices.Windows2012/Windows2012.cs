using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using Microsoft.Win32;

using WebsitePanel.Server.Utils;
using WebsitePanel.Providers.Utils;
using WebsitePanel.Providers.OS;


namespace WebsitePanel.Providers.RemoteDesktopServices
{
    public class Windows2012 : HostingServiceProviderBase
    {

        #region Properties
        protected string UsersHome
        {
            get { return FileUtils.EvaluateSystemVariables(ProviderSettings["UsersHome"]); }
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
