using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.HostedSolution
{
    public class OrganizationSecurityGroup
    {
        public string DisplayName
        {
            get;
            set;
        }

        public string AccountName
        {
            get;
            set;
        }

        public OrganizationUser[] MembersAccounts
        {
            get;
            set;
        }

        public OrganizationUser ManagerAccount
        {
            get;
            set;
        }

        public string Notes
        {
            get;
            set;
        }

        public string SAMAccountName
        {
            get;
            set;
        }

        public bool IsDefault
        {
            get;
            set;
        }
    }
}