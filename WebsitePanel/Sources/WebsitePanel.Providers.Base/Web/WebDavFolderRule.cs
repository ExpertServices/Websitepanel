using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Providers.Web
{
    public enum WebDavAccess
    {
        Read = 1,
        Source = 16,
        Write = 2
    }

    [Serializable]
    public class WebDavFolderRule
    {
        public List<string> Pathes { get; set; }
        public List<string> Users { get; set; }
        public List<string> Roles { get; set; }

        public int AccessRights
        {
            get
            {
                int result = 0;

                if (Read)
                {
                    result |= (int)WebDavAccess.Read;
                }

                if (Write)
                {
                    result |= (int)WebDavAccess.Write;
                }

                if (Source)
                {
                    result |= (int)WebDavAccess.Source;
                }

                return result;
            }
        }

        public bool Read { get; set; }
        public bool Write { get; set; }
        public bool Source { get; set; }

        public WebDavFolderRule()
        {
            Pathes = new List<string>();
            Users = new List<string>();
            Roles = new List<string>();
        }
    }
}
