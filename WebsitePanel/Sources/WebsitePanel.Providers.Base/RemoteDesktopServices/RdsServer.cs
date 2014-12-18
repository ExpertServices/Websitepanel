using System.Net;

namespace WebsitePanel.Providers.RemoteDesktopServices
{
    public class RdsServer
    {
        public int Id { get; set; }
        public int? ItemId { get; set; }
        public string Name
        {
            get
            {
                return string.IsNullOrEmpty(FqdName) ? string.Empty : FqdName.Split('.')[0];
            }
        }
        public string FqdName { get; set; }
        public string Description { get; set; }
        public string Address { get; set; }
        public string ItemName { get; set; }
        public int? RdsCollectionId { get; set; }
        public bool ConnectionEnabled { get; set; }
    }
}