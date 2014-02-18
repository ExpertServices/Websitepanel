using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.Web
{
    public class WebDavSetting
    {
        public string LocationDrive { get; set; }
        public string HomeFolder { get; set; }
        public string Domain { get; set; }

        public WebDavSetting() { }

        public WebDavSetting(string locationDrive, string homeFolder, string domain)
        {
            LocationDrive = locationDrive;
            HomeFolder = homeFolder;
            Domain = domain;
        }

        public bool IsEmpty()
        {
            return string.IsNullOrEmpty(LocationDrive) && string.IsNullOrEmpty(HomeFolder) && string.IsNullOrEmpty(Domain);
        }
    }
}
