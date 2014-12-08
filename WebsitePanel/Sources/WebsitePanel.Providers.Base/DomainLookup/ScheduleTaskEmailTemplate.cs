using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class ScheduleTaskEmailTemplate
    {
        public string TaskId { get; set; }
        public string From { get; set; }
        public string Subject { get; set; }
        public string Template { get; set; }
    }
}
