using System.Collections.Generic;
using System.Web.Mvc;

namespace WebsitePanel.WebDavPortal.Models.Common
{
    public class BaseModel
    {
        public BaseModel()
        {
            Messages = new List<Message>();
        }

        public List<Message> Messages { get; private set; }
    }
}