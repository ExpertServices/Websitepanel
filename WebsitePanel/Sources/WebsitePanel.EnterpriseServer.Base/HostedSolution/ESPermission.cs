using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.EnterpriseServer.Base.HostedSolution
{
    public class ESPermission
    {
        string account;
        string access;
        bool isGroup;

        public string Account
        {
            get { return account; }
            set { account = value; }
        }

        public string Access
        {
            get { return access; }
            set { access = value; }
        }

        public bool IsGroup
        {
            get { return isGroup; }
            set { isGroup = value; }       
        }
    }
}
