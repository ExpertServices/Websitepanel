using System.Collections.Generic;
using System.Web.Mvc;
using WebsitePanel.WebDavPortal.Models.Common.Enums;

namespace WebsitePanel.WebDavPortal.Models.Common
{
    public class BaseModel
    {
        public BaseModel()
        {
            Messages = new List<Message>();
        }

        public List<Message> Messages { get; private set; }

        public void AddMessage(MessageType type, string value)
        {
            Messages.Add(new Message
            {
                Type = type,
                Value = value
            });
        }
    }
}