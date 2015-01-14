using System;
using System.Collections.Generic;

namespace WebsitePanel.Providers.RemoteDesktopServices
{
    [Serializable]
    public class RdsCollection
    {
        public RdsCollection()
        {
            Servers = new List<RdsServer>();
        }

        public int Id { get; set; }
        public int ItemId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string DisplayName { get; set; }
        public List<RdsServer> Servers { get; set; }
    }
}