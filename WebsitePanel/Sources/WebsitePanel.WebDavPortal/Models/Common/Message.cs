using WebsitePanel.WebDavPortal.Models.Common.Enums;

namespace WebsitePanel.WebDavPortal.Models.Common
{
    public class Message
    {
        public MessageType Type {get;set;}
        public string Value { get; set; }
    }
}