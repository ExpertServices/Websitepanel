using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Models.Common.Enums;

namespace WebsitePanel.WebDavPortal.Controllers
{
    public class BaseController : Controller
    {
        public const string MessagesKey = "messagesKey";

        public void AddMessage(MessageType type, string value)
        {
            var messages = TempData[MessagesKey] as List<Message>;

            if (messages == null)
            {
                messages = new List<Message>();
            }

            messages.Add(new Message
            {
                Type = type,
                Value = value
            });

            TempData[MessagesKey] = messages;
        }
    }
}