using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.EnterpriseServer.Base.RDS;

namespace WebsitePanel.Providers.RemoteDesktopServices
{
    public class ImportedRdsCollection
    {
        public string CollectionName { get; set; }
        public string Description { get; set; }
        public List<RdsCollectionSetting> CollectionSettings { get; set; }
        public List<RdsCollectionSetting> UserGroups { get; set; }
        public List<string> SessionHosts { get; set; }
    }
}
