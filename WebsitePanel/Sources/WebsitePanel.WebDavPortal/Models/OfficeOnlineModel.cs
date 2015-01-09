namespace WebsitePanel.WebDavPortal.Models
{
    public class OfficeOnlineModel
    {
        public string Url { get; set; }
        public string FileName { get; set; }

        public OfficeOnlineModel(string url, string fileName)
        {
            Url = url;
            FileName = fileName;
        }
    }
}