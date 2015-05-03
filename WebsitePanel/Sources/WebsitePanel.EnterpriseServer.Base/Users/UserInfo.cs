// Copyright (c) 2015, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace WebsitePanel.EnterpriseServer
{
    /// <summary>
    /// User account.
    /// </summary>
    [Serializable]
    public class UserInfo
    {
        private int userId;
        private int ownerId;
        private int roleId;
        private int statusId;
        private int loginStatusId;
        private int failedLogins;
        private DateTime created;
        private DateTime changed;
        private bool isPeer;
        private bool isDemo;
        private string comments;
        private string username;
        private string password;
        private string firstName;
        private string lastName;
        private string email;
        private string secondaryEmail;
        private string address;
        private string city;
        private string country;
        private string state;
        private string zip;
        private string primaryPhone;
        private string secondaryPhone;
        private string fax;
        private string instantMessenger;
        private bool htmlMail;
        private string companyName;
        private bool ecommerceEnabled;
        private string subscriberNumber;


        /// <summary>
        /// Creates a new instance of UserInfo class.
        /// </summary>
        public UserInfo()
        {
        }

        /// <summary>
        /// User role ID:
        /// 		Administrator = 1,
        /// 		Reseller = 2,
        /// 		User = 3
        /// </summary>
        public int RoleId
        {
            get { return roleId; }
            set { roleId = value; }
        }


        /// <summary>
        /// User role.
        /// </summary>
        public UserRole Role
        {
            get { return (UserRole)roleId; }
            set { roleId = (int)value; }
        }

        /// <summary>
        /// User account status:
        /// Active = 1,
        /// Suspended = 2,
        /// Cancelled = 3,
        /// Pending = 4
        /// </summary>
        public int StatusId
        {
            get { return statusId; }
            set { statusId = value; }
        }

        /// <summary>
        /// User account status.
        /// </summary>
        public UserStatus Status
        {
            get { return (UserStatus)statusId; }
            set { statusId = (int)value; }
        }


        public int LoginStatusId
        {
            get { return loginStatusId; }
            set { loginStatusId = value; }
        }

        public UserLoginStatus LoginStatus
        {
            get { return (UserLoginStatus)loginStatusId; }
            set { loginStatusId = (int)value; }
        }

        public int FailedLogins
        {
            get { return failedLogins; }
            set { failedLogins = value; }
        }



        /// <summary>
        /// User account unique identifier.
        /// </summary>
        public int UserId
        {
            get { return userId; }
            set { userId = value; }
        }

        public int OwnerId
        {
            get { return ownerId; }
            set { ownerId = value; }
        }

        public bool IsPeer
        {
            get { return isPeer; }
            set { isPeer = value; }
        }

        public DateTime Created
        {
            get { return created; }
            set { created = value; }
        }

        public DateTime Changed
        {
            get { return changed; }
            set { changed = value; }
        }

        public bool IsDemo
        {
            get { return isDemo; }
            set { isDemo = value; }
        }

        public string Comments
        {
            get { return comments; }
            set { comments = value; }
        }

        public string LastName
        {
            get { return this.lastName; }
            set { this.lastName = value; }
        }

        public string Username
        {
            get { return this.username; }
            set { this.username = value; }
        }

        public string Password
        {
            get { return this.password; }
            set { this.password = value; }
        }

        public string FirstName
        {
            get { return this.firstName; }
            set { this.firstName = value; }
        }

        public string Email
        {
            get { return this.email; }
            set { this.email = value; }
        }

        public string PrimaryPhone
        {
            get { return this.primaryPhone; }
            set { this.primaryPhone = value; }
        }

        public string Zip
        {
            get { return this.zip; }
            set { this.zip = value; }
        }

        public string InstantMessenger
        {
            get { return this.instantMessenger; }
            set { this.instantMessenger = value; }
        }

        public string Fax
        {
            get { return this.fax; }
            set { this.fax = value; }
        }

        public string SecondaryPhone
        {
            get { return this.secondaryPhone; }
            set { this.secondaryPhone = value; }
        }

        public string SecondaryEmail
        {
            get { return this.secondaryEmail; }
            set { this.secondaryEmail = value; }
        }

        public string Country
        {
            get { return this.country; }
            set { this.country = value; }
        }

        public string Address
        {
            get { return this.address; }
            set { this.address = value; }
        }

        public string City
        {
            get { return this.city; }
            set { this.city = value; }
        }

        public string State
        {
            get { return this.state; }
            set { this.state = value; }
        }

        public bool HtmlMail
        {
            get { return this.htmlMail; }
            set { this.htmlMail = value; }
        }

        public string CompanyName
        {
            get { return this.companyName; }
            set { this.companyName = value; }
        }

        public bool EcommerceEnabled
        {
            get { return this.ecommerceEnabled; }
            set { this.ecommerceEnabled = value; }
        }

        public string SubscriberNumber
        {
            get { return this.subscriberNumber; }
            set { this.subscriberNumber = value; }
        }

        

        public string AdditionalParams { get; set; }

        public List<UserVlan> Vlans
        {
            get
            {
                List<UserVlan> result = new List<UserVlan>();
                try
                {

                    if (AdditionalParams != null)
                    {
                        XDocument doc = XDocument.Parse(AdditionalParams);
                        if (doc != null && doc.Root != null)
                        {
                            XElement vLansElement = doc.Root.Element("VLans");
                            if (vLansElement != null)
                            {
                                foreach (var item in vLansElement.Elements("VLan"))
                                    result.Add(new UserVlan
                                    {
                                        VLanID = item.Attribute("VLanID") != null ? ushort.Parse(item.Attribute("VLanID").Value) : (ushort)0,
                                        Comment = item.Attribute("Comment") != null ? item.Attribute("Comment").Value : null
                                    });
                            }
                        }
                        return result;
                    }
                }
                catch { }
                return result;
            }
        }
    }

    /// <summary>
    /// User's VLans
    /// </summary>
    [Serializable]
    public class UserVlan
    {
        public ushort VLanID { get; set; }
        public string Comment { get; set; }
    }
}



  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esAuthentication.asmx.cs(51):        public int AuthenticateUser(string username, string password, string ip)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esAuthentication.asmx.cs(57):        public UserInfo GetUserByUsernamePassword(string username, string password, string ip)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esAuthentication.asmx.cs(63):        public int ChangeUserPasswordByUsername(string username, string oldPassword, string newPassword, string ip)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esAuthentication.asmx.cs(69):        public int SendPasswordReminder(string username, string ip)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esAuthentication.asmx.cs(81):		public int SetupControlPanelAccounts(string passwordA, string passwordB, string ip)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esBlackBerry.asmx.cs(92):        public ResultObject SetActivationPasswordWithExpirationTime(int itemId, int accountId, string password, int time)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esExchangeServer.asmx.cs(221):        public bool CheckAccountCredentials(int itemId, string email, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esExchangeServer.asmx.cs(231):       public int CreateMailbox(int itemId, int accountId, ExchangeAccountType accountType, string accountName, string displayName,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esExchangeServer.asmx.cs(231):            string name, string domain, string password, bool sendSetupInstructions, string setupInstructionMailAddress, int mailboxPlanId, int archivedPlanId, string subscriberNumber, bool EnableArchiving)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(195):        public ResultObject SendResetUserPasswordLinkSms(int itemId, int accountId, string reason, string phoneTo = null)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(197):           return  OrganizationController.SendResetUserPasswordLinkSms(itemId, accountId, reason, phoneTo);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(202):        public ResultObject SendResetUserPasswordPincodeSms(Guid token, string phoneTo = null)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(204):            return OrganizationController.SendResetUserPasswordPincodeSms(token, phoneTo);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(259):        public int CreateUser(int itemId, string displayName, string name, string domain, string password, string subscriberNumber, bool sendNotification, string to)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(262):            return OrganizationController.CreateUser(itemId, displayName, name, domain, password, subscriberNumber, true, sendNotification, to, out accountName);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(266):        public int ImportUser(int itemId, string accountName, string displayName, string name, string domain, string password, string subscriberNumber)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(268):            return OrganizationController.ImportUser(itemId, accountName, displayName, name, domain, password, subscriberNumber);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(293):            string password, bool hideAddressBook, bool disabled, bool locked, string firstName, string initials,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(298):            bool userMustChangePassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(301):                password, hideAddressBook, disabled, locked, firstName, initials,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(305):                webPage, notes, externalEmail, subscriberNumber, levelId, isVIP, userMustChangePassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(318):        public int SetUserPassword(int itemId, int accountId, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(320):            return OrganizationController.SetUserPassword(itemId, accountId, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(353):        public PasswordPolicyResult GetPasswordPolicy(int itemId)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(355):            return OrganizationController.GetPasswordPolicy(itemId);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(359):        public void SendResetUserPasswordEmail(int itemId, int accountId, string reason, string mailTo, bool finalStep)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esOrganizations.asmx.cs(361):            OrganizationController.SendResetUserPasswordEmail(itemId, accountId, reason, mailTo, finalStep);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esPackages.asmx.cs(449):        public int CreateUserWizard(int parentPackageId, string username, string password,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esPackages.asmx.cs(456):            return UserCreationWizard.CreateUserAccount(parentPackageId, username, password,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(108):        public int CheckServerAvailable(string serverUrl, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(110):            return ServerController.CheckServerAvailable(serverUrl, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(126):        public int UpdateServerConnectionPassword(int serverId, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(128):            return ServerController.UpdateServerConnectionPassword(serverId, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(132):        public int UpdateServerADPassword(int serverId, string adPassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esServers.asmx.cs(134):            return ServerController.UpdateServerADPassword(serverId, adPassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esUsers.asmx.cs(152):		    string password,
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esUsers.asmx.cs(178):            user.Password = password;
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esUsers.asmx.cs(272):        public int ChangeUserPassword(int userId, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esUsers.asmx.cs(274):            return UserController.ChangeUserPassword(userId, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(127):            return WebServerController.InstallFrontPage(siteItemId, username, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(137):        public int ChangeFrontPagePassword(int siteItemId, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(139):            return WebServerController.ChangeFrontPagePassword(siteItemId, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(337):        public ResultObject GrantWebDeployPublishingAccess(int siteItemId, string accountName, string accountPassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(339):            return WebServerController.GrantWebDeployPublishingAccess(siteItemId, accountName, accountPassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(361):        public ResultObject ChangeWebDeployPublishingPassword(int siteItemId, string newAccountPassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(363):            return WebServerController.ChangeWebDeployPublishingPassword(siteItemId, newAccountPassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(536):        public ResultObject GrantWebManagementAccess(int siteItemId, string accountName, string accountPassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(538):            return WebServerController.GrantWebManagementAccess(siteItemId, accountName, accountPassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(548):        public ResultObject ChangeWebManagementAccessPassword(int siteItemId, string accountPassword)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(550):            return WebServerController.ChangeWebManagementAccessPassword(siteItemId, accountPassword);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(567):        public ResultObject InstallPfx(byte[] certificate, int siteItemId, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(569):            return WebServerController.InstallPfx(certificate, siteItemId, password);
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(597):        public byte[] ExportCertificate(int siteId, string serialNumber, string password)
  //C:\Work\WSPExpert\WebsitePanel\Sources\WebsitePanel.EnterpriseServer\esWebServers.asmx.cs(599):            return WebServerController.ExportCertificate(siteId, serialNumber, password);