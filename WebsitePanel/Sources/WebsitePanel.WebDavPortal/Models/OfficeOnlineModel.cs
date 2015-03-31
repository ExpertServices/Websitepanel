using WebsitePanel.WebDavPortal.Models.Common;

namespace WebsitePanel.WebDavPortal.Models
{
    public class OfficeOnlineModel : BaseModel
    {
        public string Url { get; set; }
        public string FileName { get; set; }
        public string Backurl { get; set; }

        public OfficeOnlineModel(string url, string fileName, string backUrl)
        {
            Url = url;
            FileName = fileName;
            Backurl = backUrl;
        }
    }
}