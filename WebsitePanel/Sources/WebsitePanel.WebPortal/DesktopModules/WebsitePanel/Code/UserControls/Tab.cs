using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsitePanel.Portal.Code.UserControls
{
    public class Tab
    {
        string id;
        string name;
        string url;

        public Tab(string id, string name, string url)
        {
            this.id = id;
            this.name = name;
            this.url = url;
        }

        public string Id
        {
            get { return this.id; }
            set { this.id = value; }
        }

        public string Name
        {
            get { return this.name; }
            set { this.name = value; }
        }

        public string Url
        {
            get { return this.url; }
            set { this.url = value; }
        }

    }
}

