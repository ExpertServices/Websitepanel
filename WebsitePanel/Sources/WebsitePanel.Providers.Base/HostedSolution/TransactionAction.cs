using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.HostedSolution
{
    public class TransactionAction
    {
        private TransactionActionTypes actionType;

        public TransactionActionTypes ActionType
        {
            get { return actionType; }
            set { actionType = value; }
        }

        private string id;

        public string Id
        {
            get { return id; }
            set { id = value; }
        }

        private string suffix;

        public string Suffix
        {
            get { return suffix; }
            set { suffix = value; }
        }

        private string account;

        public string Account
        {
            get { return account; }
            set { account = value; }

        }

        public enum TransactionActionTypes
        {
            CreateOrganizationUnit,
            CreateGlobalAddressList,
            CreateAddressList,
            CreateAddressBookPolicy,
            CreateOfflineAddressBook,
            CreateDistributionGroup,
            EnableDistributionGroup,
            CreateAcceptedDomain,
            AddUPNSuffix,
            CreateMailbox,
            CreateContact,
            CreatePublicFolder,
            CreateActiveSyncPolicy,
            AddMailboxFullAccessPermission,
            AddSendAsPermission,
            RemoveMailboxFullAccessPermission,
            RemoveSendAsPermission,
            EnableMailbox,
            LyncNewSipDomain,
            LyncNewSimpleUrl,
            LyncNewUser,
            LyncNewConferencingPolicy,
            LyncNewExternalAccessPolicy,
            LyncNewMobilityPolicy
        };
    }
}
