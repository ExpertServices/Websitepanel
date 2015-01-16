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
using System.IO;
using System.Net.Mail;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Win32;
using WebsitePanel.Providers.Utils;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Providers.Mail
{
    public class IceWarp : HostingServiceProviderBase, IMailServer
    {
        protected const string API_PROGID = "IceWarpServer.APIObject";
        protected const string DOMAIN_PROGID = "IceWarpServer.DomainObject";
        protected const string ACCOUNT_PROGID = "IceWarpServer.AccountObject";
        
        private dynamic _currentApiObject = null;

        #region IceWarp Enums

        protected enum IceWarpErrorCode
        {
            S_OK = 0,
            E_FAILURE = -1, // Function failure
            E_LICENSE = -2, // Insufficient license
            E_PARAMS = -3, // Size of parameters too short
            E_PATH = -4, // Settings file does not exist
            E_CONFIG = -5, // Configuration not found
            E_PASSWORD = -6, // Password policy
            E_CONFLICT = -7, // Item already exists
            E_INVALID = -8, // Invalid mailbox / alias characters
            E_PASSWORDCHARS = -9, // Invalid password characters
            E_MIGRATION_IN_PROGRESS = -10 // User migration in progress
        }

        protected enum IceWarpAccountType
        {
            User = 0,
            MailingList = 1,
            Executable = 2,
            Notification = 3,
            StaticRoute = 4,
            Catalog = 5,
            ListServer = 6,
            UserGroup = 7
        }

        protected enum IceWarpUnknownUsersType
        {
            Reject = 0,
            ForwardToAddress = 1,
            Delete = 2
        }

        #endregion

        #region Protected Properties

        protected string MailPath
        {
            get
            {
                var apiObject = GetApiObject();
                return apiObject.GetProperty("C_System_Storage_Dir_MailPath");
            }
        }

        protected string Version
        {
            get
            {
                var apiObject = GetApiObject();
                return apiObject.GetProperty("C_Version");
            }
        }

        protected string BindIpAddress
        {
            get
            {
                var apiObject = GetApiObject();
                var adresses = ((object) apiObject.GetProperty("C_System_Services_BindIPAddress"));
                return adresses == null ? "" : adresses.ToString().Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();
            }
        }

        protected bool UseDomainDiskQuota
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToBoolean((object) apiObject.GetProperty("C_Accounts_Global_Domains_UseDiskQuota"));
            }
        }

        protected bool UseDomainLimits
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToBoolean((object) apiObject.GetProperty("C_Accounts_Global_Domains_UseDomainLimits"));
            }
        }

        protected bool UseUserLimits
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToBoolean((object) apiObject.GetProperty("C_Accounts_Global_Domains_UseUserLimits"));
            }
        }

        protected bool OverrideGlobal
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToBoolean((object) apiObject.GetProperty("C_Accounts_Global_Domains_OverrideGlobal"));
            }
        }

        protected int MaxMessageSizeInMB
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToInt32((object) apiObject.GetProperty("C_Mail_SMTP_Delivery_MaxMsgSize"))/1024/1024;
            }
        }
                
        protected int WarnMailboxUsage
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToInt32((object)apiObject.GetProperty("C_Accounts_Global_Domains_WarnMailboxUsage"));                
            }
        }

        protected int WarnDomainSize
        {
            get
            {
                var apiObject = GetApiObject();
                return Convert.ToInt32((object)apiObject.GetProperty("C_Accounts_Global_Domains_WarnDomainSize"));
            }
        }
        

        private void SaveApiSetting(dynamic apiObject)
        {
            if (!apiObject.Save())
            {
                throw new Exception("Cannot save Api Object: " + GetErrorMessage(apiObject.LastErr));
            }
        }

        #endregion

        #region Protected Methods

        protected static string GetErrorMessage(int errorCode)
        {
            switch ((IceWarpErrorCode) errorCode)
            {
                case IceWarpErrorCode.S_OK:
                    return "OK";
                case IceWarpErrorCode.E_FAILURE:
                    return "Function failure";
                case IceWarpErrorCode.E_LICENSE:
                    return "Insufficient license";
                case IceWarpErrorCode.E_PARAMS:
                    return "Size of parameters too short";
                case IceWarpErrorCode.E_PATH:
                    return "Settings file does not exist";
                case IceWarpErrorCode.E_CONFIG:
                    return "Configuration not found";
                case IceWarpErrorCode.E_PASSWORD:
                    return "IceWarp password policy denies use of this account";
                case IceWarpErrorCode.E_CONFLICT:
                    return "Item already exists";
                case IceWarpErrorCode.E_INVALID:
                    return "Invalid charcters in mailbox or alias";
                case IceWarpErrorCode.E_PASSWORDCHARS:
                    return "Invalid characters in password";
                case IceWarpErrorCode.E_MIGRATION_IN_PROGRESS:
                    return "User mgiration in progress";
                default:
                    return "";
            }
        }

        protected object CreateObject(string progId)
        {
            var associatedType = Type.GetTypeFromProgID(progId);

            if (associatedType == null)
            {
                throw new Exception("Cannot get type of " + progId);
            }

            try
            {
                var obj = Activator.CreateInstance(associatedType);
                if (obj == null)
                {
                    throw new Exception("Unable to create COM interface");
                }

                return obj;
            }
            catch (Exception ex)
            {
                throw new Exception("Unable to create COM interface", ex);
            }
        }

        protected dynamic GetApiObject()
        {
            if (_currentApiObject != null) return _currentApiObject;

            _currentApiObject = CreateObject(API_PROGID);
            if (_currentApiObject == null)
            {
                throw new Exception("Returned COM is not of appropriate type");
            }

            return _currentApiObject;
        }

        protected dynamic GetDomainObject()
        {
            var obj = CreateObject(DOMAIN_PROGID);
            if (obj == null)
            {
                throw new Exception("Returned COM is not of appropriate type");
            }

            return obj;
        }

        protected dynamic GetDomainObject(string domainName)
        {
            var obj = GetDomainObject();
            if (!obj.Open(domainName))
            {
                throw new Exception("Cannot open domain " + domainName + ": " + GetErrorMessage(obj.LastErr));
            }

            return obj;
        }

        protected dynamic GetAccountObject()
        {
            var obj = CreateObject(ACCOUNT_PROGID);
            if (obj == null)
            {
                throw new Exception("Returned COM is not of appropriate type");
            }

            return obj;
        }

        protected dynamic GetAccountObject(string accountName)
        {
            var obj = GetAccountObject();
            if (!obj.Open(accountName))
            {
                throw new Exception("Cannot open account " + accountName + ": " + GetErrorMessage(obj.LastErr));
            }

            return obj;
        }

        protected void SaveDomain(dynamic domain)
        {
            if (!domain.Save())
            {
                throw new ArgumentException("Could not save domain:" + GetErrorMessage(domain.LastErr));
            }
        }

        protected void SaveAccount(dynamic account, string accountTypeName = "account")
        {
            if (!account.Save())
            {
                throw new ArgumentException("Could not save " + accountTypeName + ":" + GetErrorMessage(account.LastErr));
            }
        }


        protected string GetEmailUser(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return string.Empty;
            }

            try
            {
                return new MailAddress(email).User;
            }
            catch
            {
                return email.Contains('@') ? email.Substring(0, email.IndexOf('@')) : string.Empty;
            }
        }

        protected string GetEmailDomain(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return string.Empty;
            }

            try
            {
                return new MailAddress(email).Host;
            }
            catch
            {
                return email.Contains('@') ? email.Substring(email.IndexOf('@') + 1) : string.Empty;
            }
        }

        protected void CheckIfDomainExists(string domainName)
        {
            if (string.IsNullOrWhiteSpace(domainName) || !DomainExists(domainName))
            {
                throw new ArgumentException("Specified domain does not exist!");
            }
        }

        protected int GetDomainCount()
        {
            var apiObject = GetApiObject();
            return apiObject.GetDomainCount();
        }

        protected T[] GetItems<T>(string domainName, IceWarpAccountType itemType, Func<dynamic, T> mailAccountCreator)
        {
            var mailAccounts = new List<T>();

            var accountObject = GetAccountObject();
            if (accountObject.FindInitQuery(domainName, "(U_Type = " + (int)itemType + ")"))
            {
                while (accountObject.FindNext())
                {
                    mailAccounts.Add(mailAccountCreator(accountObject));
                }
            }

            return mailAccounts.ToArray();
        }

        protected void SaveProviderSettingsToService()
        {
            var apiObject = GetApiObject();
            apiObject.SetProperty("C_Accounts_Global_Domains_UseDiskQuota", ProviderSettings["UseDomainDiskQuota"]);
            apiObject.SetProperty("C_Accounts_Global_Domains_UseDomainLimits", ProviderSettings["UseDomainLimits"]);
            apiObject.SetProperty("C_Accounts_Global_Domains_UseUserLimits", ProviderSettings["UseUserLimits"]);
            apiObject.SetProperty("C_Accounts_Global_Domains_OverrideGlobal", ProviderSettings["OverrideGlobal"]);
            apiObject.SetProperty("C_Accounts_Global_Domains_WarnMailboxUsage", ProviderSettings["WarnMailboxUsage"]);
            apiObject.SetProperty("C_Accounts_Global_Domains_WarnDomainSize", ProviderSettings["WarnDomainSize"]);

            apiObject.SetProperty("C_Mail_SMTP_Delivery_MaxMsgSize", Convert.ToInt32(ProviderSettings["MaxMessageSize"])*1024*1024);
            apiObject.SetProperty("C_Mail_SMTP_Delivery_LimitMsgSize", Convert.ToInt32(ProviderSettings["MaxMessageSize"]) > 0);

            SaveApiSetting(apiObject);
        }

        #endregion

 		#region IHostingServiceProvier methods

		public override SettingPair[] GetProviderDefaultSettings()
		{
            var settings = new []
            {
                new SettingPair("UseDomainDiskQuota", UseDomainDiskQuota.ToString()), 
                new SettingPair("UseDomainLimits", UseDomainLimits.ToString()), 
                new SettingPair("UseUserLimits", UseUserLimits.ToString()), 
                new SettingPair("OverrideGlobal", OverrideGlobal.ToString()), 
                new SettingPair("WarnMailboxUsage", WarnMailboxUsage.ToString()), 
                new SettingPair("WarnDomainSize", WarnDomainSize.ToString()), 
                new SettingPair("MaxMessageSize", MaxMessageSizeInMB.ToString()),
                new SettingPair("ServerIpAddress", BindIpAddress)
            };

			return settings;
		}

        public override string[] Install()
        {
            SaveProviderSettingsToService();
            return base.Install();
        }

        public override void ChangeServiceItemsState(ServiceProviderItem[] items, bool enabled)
		{
		    foreach (var item in items.OfType<MailDomain>())
		    {
		        try
		        {
		            // enable/disable mail domain
		            if (DomainExists(item.Name))
		            {
		                var mailDomain = GetDomain(item.Name);
		                mailDomain.Enabled = enabled;
		                UpdateDomain(mailDomain);
		            }
		        }
		        catch (Exception ex)
		        {
		            Log.WriteError(String.Format("Error switching '{0}' IceWarp domain", item.Name), ex);
		        }
		    }
		}

        public override void DeleteServiceItems(ServiceProviderItem[] items)
        {
            foreach (var item in items.OfType<MailDomain>())
            {
                try
                {
                    // delete mail domain
                    DeleteDomain(item.Name);
                }
                catch (Exception ex)
                {
                    Log.WriteError(String.Format("Error deleting '{0}' IceWarp domain", item.Name), ex);
                }
            }
        }

        public override ServiceProviderItemDiskSpace[] GetServiceItemsDiskSpace(ServiceProviderItem[] items)
		{
			var itemsDiskspace = new List<ServiceProviderItemDiskSpace>();

			// update items with diskspace
			foreach (var item in items.OfType<MailAccount>())
			{
			    try
			    {
			        Log.WriteStart(String.Format("Calculating mail account '{0}' size", item.Name));
			        // calculate disk space
			        var accountObject = GetAccountObject(item.Name);
			        var size = Convert.ToInt64((object)accountObject.GetProperty("U_MailboxSize"));

                    var diskspace = new ServiceProviderItemDiskSpace {ItemId = item.Id, DiskSpace = size};
			        itemsDiskspace.Add(diskspace);
			        Log.WriteEnd(String.Format("Calculating mail account '{0}' size", item.Name));
			    }
			    catch (Exception ex)
			    {
			        Log.WriteError(ex);
			    }
			}
			return itemsDiskspace.ToArray();
		}

		public override ServiceProviderItemBandwidth[] GetServiceItemsBandwidth(ServiceProviderItem[] items, DateTime since)
		{
			var itemsBandwidth = new ServiceProviderItemBandwidth[items.Length];

			// update items with diskspace
			for (int i = 0; i < items.Length; i++)
			{
				ServiceProviderItem item = items[i];

				// create new bandwidth object
				itemsBandwidth[i] = new ServiceProviderItemBandwidth
				{
				    ItemId = item.Id, 
                    Days = new DailyStatistics[0]
				};

			    if (item is MailDomain)
				{
					try
					{
						// get daily statistics
						itemsBandwidth[i].Days = GetDailyStatistics(since, item.Name);
					}
					catch (Exception ex)
					{
						Log.WriteError(ex);
						System.Diagnostics.Debug.WriteLine(ex);
					}
				}
			}

			return itemsBandwidth;
		}

        public DailyStatistics[] GetDailyStatistics(DateTime since, string maildomainName)
        {
            var days = new List<DailyStatistics>();
            var today = DateTime.Today;

            try
            {
                var api = GetApiObject();

                for (var date = since; date < today; date = date.AddDays(1))
                {
                    var stats = api.GetUserStatistics(date.ToString("yyyy\"/\"MM\"/\"dd"), date.ToString("yyyy\"/\"MM\"/\"dd"), maildomainName);

                    var statsBuffer = Encoding.ASCII.GetBytes(stats);
                    var mailSentField = 0;
                    var mailReceivedField = 0;

                    var ms = new MemoryStream(statsBuffer);
                    var reader = new StreamReader(ms);
                    while (reader.Peek() != -1)
                    {
                        var line = reader.ReadLine();
                        var fields = line.Split(',');

                        switch (line[0])
                        {
                            case '[':
                                for (var j = 1; j < fields.Length; j++)
                                {
                                    if (fields[j] == "[Received Amount]") mailReceivedField = j;
                                    if (fields[j] == "[Sent Amount]") mailSentField = j;
                                }
                                break;
                            case '*':
                                var dailyStats = new DailyStatistics
                                {
                                    Year = date.Year, 
                                    Month = date.Month, 
                                    Day = date.Day, 
                                    BytesSent = line[mailSentField], 
                                    BytesReceived = line[mailReceivedField]
                                };
                                days.Add(dailyStats);
                                continue;
                        }
                    }
                    reader.Close();
                    ms.Close();
                }
            }
            catch (Exception ex)
            {
                Log.WriteError("Could not get IceWarp domain statistics", ex);
            }

            return days.ToArray();
        }

        #endregion

        public override bool IsInstalled()
        {
            string version;

            var key32Bit = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\IceWarp\IceWarp Server");
            if (key32Bit != null)
            {
                version = key32Bit.GetValue("Version").ToString();
            }
            else
            {
                var key64Bit = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Wow6432Node\IceWarp\IceWarp Server");
                if (key64Bit != null)
                {
                    version = key64Bit.GetValue("Version").ToString();
                }
                else
                {
                    return false;
                }
            }

            if (string.IsNullOrEmpty(version))
            {
                return false;
            }

            // Checking for version 10.4.0 (released 2012-03-21) or newer
            // This version introduced L_ListFile_Contents, G_ListFile_Contents and M_ListFileContents that is the latest API variable used by this provider
            var split = version.Split(new[] {'.'});
            var majorVersion = Convert.ToInt32(split[0]);
            var minVersion = Convert.ToInt32(split[1]);

            return majorVersion >= 11 || majorVersion >= 10 && minVersion >= 4;
        }

        #region Domains

        public bool DomainExists(string domainName)
        {
            var api = GetApiObject();
            return api.GetDomainIndex(domainName) >= 0;
        }

        public string[] GetDomains()
        {
            var api = GetApiObject();
            return api.GetDomainList().Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries);
        }

        public MailDomain GetDomain(string domainName)
        {
            var domain = GetDomainObject(domainName);

            var mailDomain = new MailDomain
            {
                Name = domain.Name,
                PostmasterAccount = domain.GetProperty("D_AdminEmail"),
                CatchAllAccount = domain.GetProperty("D_UnknownForwardTo"),
                Enabled = Convert.ToBoolean((object) domain.GetProperty("D_DisableLogin")),
                MaxDomainSizeInMB = Convert.ToInt32((object) domain.GetProperty("D_DiskQuota"))/1024,
                MaxDomainUsers = Convert.ToInt32((object) domain.GetProperty("D_AccountNumber")),
                MegaByteSendLimit = Convert.ToInt32((object) domain.GetProperty("D_VolumeLimit"))/1024,
                NumberSendLimit = Convert.ToInt32((object) domain.GetProperty("D_NumberLimit")),
                DefaultUserQuotaInMB = Convert.ToInt32((object) domain.GetProperty("D_UserMailbox"))/1024,
                DefaultUserMaxMessageSizeMegaByte = Convert.ToInt32((object) domain.GetProperty("D_UserMsg"))/1024,
                DefaultUserMegaByteSendLimit = Convert.ToInt32((object) domain.GetProperty("D_UserMB")),
                DefaultUserNumberSendLimit = Convert.ToInt32((object) domain.GetProperty("D_UserNumber")),
                UseDomainDiskQuota = Convert.ToBoolean(ProviderSettings["UseDomainDiskQuota"]),
                UseDomainLimits = Convert.ToBoolean(ProviderSettings["UseDomainLimits"]),
                UseUserLimits = Convert.ToBoolean(ProviderSettings["UseUserLimits"])
            };

            return mailDomain;
        }

        public void CreateDomain(MailDomain domain)
        {
            if (string.IsNullOrWhiteSpace(domain.Name))
            {
                throw new ArgumentNullException("domain.Name");
            }

            var domainObject = GetDomainObject();

            if (!domainObject.New(domain.Name))
            {
                throw new ApplicationException("Failed to create domain: " + GetErrorMessage(domainObject.LastErr));
            }

            SaveDomain(domainObject);

            UpdateDomain(domain);
        }

        public void UpdateDomain(MailDomain domain)
        {
            var domainObject = GetDomainObject(domain.Name);

            domainObject.SetProperty("D_AdminEmail", string.IsNullOrEmpty(domain.PostmasterAccount) ? "" : domain.PostmasterAccount);

            if (string.IsNullOrEmpty(domain.CatchAllAccount))
            {
                domainObject.SetProperty("D_UnknownForwardTo", "");
                domainObject.SetProperty("D_UnknownUsersType", IceWarpUnknownUsersType.Reject);
            }
            else
            {
                domainObject.SetProperty("D_UnknownForwardTo", domain.CatchAllAccount);
                domainObject.SetProperty("D_UnknownUsersType", IceWarpUnknownUsersType.ForwardToAddress);
            }

            domainObject.SetProperty("D_DisableLogin", !domain.Enabled);
            domainObject.SetProperty("D_DiskQuota", domain.MaxDomainSizeInMB*1024);
            domainObject.SetProperty("D_AccountNumber", domain.MaxDomainUsers);
            domainObject.SetProperty("D_VolumeLimit", domain.MegaByteSendLimit*1024);
            domainObject.SetProperty("D_NumberLimit", domain.NumberSendLimit);

            domainObject.SetProperty("D_UserMailbox", domain.DefaultUserQuotaInMB*1024);
            domainObject.SetProperty("D_UserMsg", domain.DefaultUserMaxMessageSizeMegaByte*1024);
            domainObject.SetProperty("D_UserMB", domain.DefaultUserMegaByteSendLimit);
            domainObject.SetProperty("D_UserNumber", domain.DefaultUserNumberSendLimit);

            SaveDomain(domainObject);
        }

        public void DeleteDomain(string domainName)
        {
            var domainObject = GetDomainObject(domainName);

            if (domainObject.Delete())
            {
                throw new Exception("Could not delete domain");
            }
        }

        #endregion

        #region Domain alieses

        public bool DomainAliasExists(string domainName, string aliasName)
        {
            if (!DomainExists(aliasName))
            {
                return false;
            }

            var domainObject = GetDomainObject(aliasName);

            return Convert.ToInt32((object) domainObject.GetProperty("D_Type")) == 2 && string.Compare(domainObject.GetProperty("D_DomainValue").ToString(), domainName, true) == 0;
        }

        public string[] GetDomainAliases(string domainName)
        {
            var aliasList = new List<string>();

            var apiObject = GetApiObject();

            var domainCount = apiObject.GetDomainCount();

            for (var i = 0; i < domainCount; i++)
            {
                var aliasName = apiObject.GetDomain(i);
                if (DomainAliasExists(domainName, aliasName))
                {
                    aliasList.Add(aliasName);
                }
            }

            return aliasList.ToArray();
        }

        public void AddDomainAlias(string domainName, string aliasName)
        {
            var mailDomain = new MailDomain {Name = aliasName};
            CreateDomain(mailDomain);
            var domainObject = GetDomainObject(aliasName);

            domainObject.SetProperty("D_Type", 2);
            domainObject.SetProperty("D_DomainValue", domainName);
            SaveDomain(domainObject);
        }

        public void DeleteDomainAlias(string domainName, string aliasName)
        {
            DeleteDomain(aliasName);
        }

        #endregion

        #region Accounts

        public bool AccountExists(string mailboxName)
        {
            var accountObject = GetAccountObject();

            return accountObject.Open(mailboxName) && Convert.ToInt32((object) accountObject.GetProperty("U_Type")) == (int) IceWarpAccountType.User;
        }

        protected class IceWarpResponderContent
        {
            public string From { get; set; }
            public string To { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }
        }

        private static IceWarpResponderContent ParseResponderContent(string responderContent)
        {
            var result = new IceWarpResponderContent();

            if (string.IsNullOrWhiteSpace(responderContent))
            {
                return result;
            }

            var re = new Regex(@"\$\$(set\w*) (.*)\$\$\n");
            var matches = re.Matches(responderContent);

            foreach (Match match in matches)
            {
                if (match.Groups[1].Value == "setsubject")
                {
                    result.Subject = match.Groups[2].Value;
                }

                if (match.Groups[1].Value == "setactualto")
                {
                    result.To = match.Groups[2].Value;
                }

                if (match.Groups[1].Value == "setactualfrom")
                {
                    result.From = match.Groups[2].Value;
                }
            }

            result.Content = re.Replace(responderContent, "");

            return result;
        }

        protected static MailAccount CreateMailAccountFromAccountObject(dynamic accountObject)
        {
            var mailAccount = new MailAccount
            {
                Name = accountObject.EmailAddress,
                FullName = accountObject.GetProperty("U_Name"),
                Enabled = Convert.ToInt32((object) accountObject.GetProperty("U_AccountDisabled")) == 0,
                ForwardingEnabled = !string.IsNullOrWhiteSpace(accountObject.GetProperty("U_ForwardTo")) || string.IsNullOrWhiteSpace(accountObject.GetProperty("U_RemoteAddress")) && Convert.ToBoolean((object) accountObject.GetProperty("U_UseRemoteAddress")),
                IsDomainAdmin = Convert.ToBoolean((object) accountObject.GetProperty("U_DomainAdmin")),
                MaxMailboxSize = Convert.ToInt32((object) accountObject.GetProperty("U_MaxBoxSize"))/1024,
                Password = accountObject.GetProperty("U_Password"),
                ResponderEnabled = Convert.ToInt32((object) accountObject.GetProperty("U_Respond")) > 0,
                QuotaUsed = Convert.ToInt64((object) accountObject.GetProperty("U_MailBoxSize")),
                MaxMessageSizeMegaByte = Convert.ToInt32((object) accountObject.GetProperty("U_MaxMessageSize"))/1024,
                MegaByteSendLimit = Convert.ToInt32((object) accountObject.GetProperty("U_MegabyteSendLimit")),
                NumberSendLimit = Convert.ToInt32((object) accountObject.GetProperty("U_NumberSendLimit")),
                DeleteOlder = Convert.ToBoolean((object) accountObject.GetProperty("U_DeleteOlder")),
                DeleteOlderDays = Convert.ToInt32((object) accountObject.GetProperty("U_DeleteOlderDays")),
                ForwardOlder = Convert.ToBoolean((object) accountObject.GetProperty("U_ForwardOlder")),
                ForwardOlderDays = Convert.ToInt32((object) accountObject.GetProperty("U_ForwardOlderDays")),
                ForwardOlderTo = accountObject.GetProperty("U_ForwardOlderTo"),
                IceWarpAccountState = Convert.ToInt32((object) accountObject.GetProperty("U_AccountDisabled")),
                IceWarpAccountType = Convert.ToInt32((object) accountObject.GetProperty("U_AccountType")),
                IceWarpRespondType = Convert.ToInt32((object) accountObject.GetProperty("U_Respond"))
            };

            if (mailAccount.ForwardingEnabled)
            {
                mailAccount.ForwardingAddresses = new string[] {accountObject.GetProperty("U_ForwardTo") + accountObject.GetProperty("U_RemoteAddress")};
                mailAccount.DeleteOnForward = Convert.ToInt32(accountObject.GetProperty("U_UseRemoteAddress")) == 1;
                mailAccount.RetainLocalCopy = !mailAccount.DeleteOnForward;
            }

            if (mailAccount.ResponderEnabled)
            {
                var respondFromValue = accountObject.GetProperty("U_RespondBetweenFrom");
                var respondToValue = accountObject.GetProperty("U_RespondBetweenTo");
                DateTime respondFrom;
                DateTime respondTo;
                mailAccount.RespondOnlyBetweenDates = false;
                var fromDateParsed = DateTime.TryParse(respondFromValue, out respondFrom);

                if (DateTime.TryParse(respondToValue, out respondTo) && fromDateParsed)
                {
                    mailAccount.RespondOnlyBetweenDates = true;
                    mailAccount.RespondFrom = respondFrom;
                    mailAccount.RespondTo = respondTo;
                }

                mailAccount.RespondPeriodInDays = Convert.ToInt32((object) accountObject.GetProperty("U_RespondPeriod"));
                var responderContent = ParseResponderContent(accountObject.GetProperty("U_ResponderContent"));
                mailAccount.ResponderMessage = responderContent.Content;
                mailAccount.ResponderSubject = responderContent.Subject;
                mailAccount.RespondWithReplyFrom = responderContent.From;
            }

            return mailAccount;
        }

        public MailAccount[] GetAccounts(string domainName)
        {
            return GetItems(domainName, IceWarpAccountType.User, CreateMailAccountFromAccountObject);
        }

        public MailAccount GetAccount(string mailboxName)
        {
            var accountObject = GetAccountObject(mailboxName);
            return CreateMailAccountFromAccountObject(accountObject);
        }

        public void CreateAccount(MailAccount mailbox)
        {
            var accountObject = GetAccountObject();

            var emailParts = new MailAddress(mailbox.Name);
            if (!accountObject.CanCreateMailbox(emailParts.User, emailParts.User, mailbox.Password, emailParts.Host))
            {
                throw new Exception("Cannot create account: " + GetErrorMessage(accountObject.LastErr));
            }

            if (accountObject.New(mailbox.Name))
            {
                accountObject.Save();
            }

            UpdateAccount(mailbox);
        }

        public void UpdateAccount(MailAccount mailbox)
        {
            var accountObject = GetAccountObject(mailbox.Name);

            accountObject.SetProperty("U_Name", mailbox.FullName);
            accountObject.SetProperty("U_AccountDisabled", mailbox.IceWarpAccountState);
            accountObject.SetProperty("U_DomainAdmin", mailbox.IsDomainAdmin);
            accountObject.SetProperty("U_Password", mailbox.Password);
            accountObject.SetProperty("U_MaxBoxSize", mailbox.MaxMailboxSize);
            accountObject.SetProperty("U_MaxMessageSize", mailbox.MaxMessageSizeMegaByte*1024);
            accountObject.SetProperty("U_MegabyteSendLimit", mailbox.MegaByteSendLimit);
            accountObject.SetProperty("U_NumberSendLimit", mailbox.NumberSendLimit);
            accountObject.SetProperty("U_AccountType", mailbox.IceWarpAccountType);
            accountObject.SetProperty("U_Respond", mailbox.IceWarpRespondType);

            accountObject.SetProperty("U_DeleteOlder", mailbox.DeleteOlder);
            accountObject.SetProperty("U_DeleteOlderDays", mailbox.DeleteOlderDays);
            accountObject.SetProperty("U_ForwardOlder", mailbox.ForwardOlder);
            accountObject.SetProperty("U_ForwardOlderDays", mailbox.ForwardOlderDays);
            accountObject.SetProperty("U_ForwardOlderTo", mailbox.ForwardOlderTo);

            // Set initial defalt values for forwarding
            accountObject.SetProperty("U_RemoteAddress", null);
            accountObject.SetProperty("U_ForwardTo", null);
            accountObject.SetProperty("U_UseRemoteAddress", false);

            if (mailbox.ForwardingEnabled)
            {
                if (mailbox.DeleteOnForward)
                {
                    accountObject.SetProperty("U_RemoteAddress", string.Join(";", mailbox.ForwardingAddresses));
                    accountObject.SetProperty("U_UseRemoteAddress", true);
                }
                else
                {
                    accountObject.SetProperty("U_ForwardTo", string.Join(";", mailbox.ForwardingAddresses));
                }
            }


            if (mailbox.IceWarpRespondType > 0)
            {
                if (mailbox.RespondOnlyBetweenDates)
                {
                    accountObject.SetProperty("U_RespondBetweenFrom", mailbox.RespondFrom.ToShortDateString());
                    accountObject.SetProperty("U_RespondBetweenTo", mailbox.RespondTo.ToShortDateString());
                }
                else
                {
                    accountObject.SetProperty("U_RespondBetweenFrom", null);
                    accountObject.SetProperty("U_RespondBetweenTo", null);
                }

                accountObject.SetProperty("U_RespondPeriod", mailbox.RespondPeriodInDays);

                var responderContent = "";
                if (!string.IsNullOrWhiteSpace(mailbox.RespondWithReplyFrom))
                {
                    responderContent += "$$setactualfrom " + mailbox.RespondWithReplyFrom + "$$\n";
                }
                if (!string.IsNullOrWhiteSpace(mailbox.ResponderSubject))
                {
                    responderContent += "$$setsubject " + mailbox.ResponderSubject + "$$\n";
                }

                accountObject.SetProperty("U_ResponderContent", responderContent + mailbox.ResponderMessage);
            }

            SaveAccount(accountObject);
        }

        public void DeleteAccount(string mailboxName)
        {
            var accountObject = GetAccountObject(mailboxName);
            if (!accountObject.Delete())
            {
                throw new Exception("Cannot delete account: " + GetErrorMessage(accountObject.LastErr));
            }
        }

        #endregion

        #region Mail aliases

        public bool MailAliasExists(string mailAliasName)
        {
            var accountObject = GetAccountObject();

            return accountObject.Open(mailAliasName);
        }

        protected IEnumerable<string> GetAliasListFromAccountObject(dynamic accountObject)
        {
            return SplitStringProperty(accountObject, "U_EmailAlias", ';');
        }

        protected string GetForwardToAddressFromAccountObject(dynamic accountObject)
        {
            var forwardTo = accountObject.EmailAddress;
            var remoteAddress = accountObject.GetProperty("U_RemoteAddress");
            if (!string.IsNullOrWhiteSpace(remoteAddress))
            {
                forwardTo = remoteAddress;
            }

            return forwardTo;
        }

        public MailAlias[] GetMailAliases(string domainName)
        {
            var aliasList = new List<MailAlias>();

            var accountObject = GetAccountObject();

            if (accountObject.FindInitQuery(domainName, "U_Type=" + (int)IceWarpAccountType.User))
            {
                while (accountObject.FindNext())
                {
                    var forwardTo = GetForwardToAddressFromAccountObject(accountObject);
                    var aliases = GetAliasListFromAccountObject(accountObject) as IEnumerable<string>;
                    aliasList.AddRange(aliases.Where(a => a != forwardTo).Select(alias => new MailAlias {Name = alias + "@" + domainName, ForwardTo = forwardTo + "@" + domainName}));
                }

                accountObject.FindDone();
            }

            return aliasList.ToArray();
        }

        public MailAlias GetMailAlias(string mailAliasName)
        {
            var accountObject = GetAccountObject(mailAliasName);

            var forwardTo = GetForwardToAddressFromAccountObject(accountObject);

            return new MailAlias {ForwardTo = forwardTo, Name = mailAliasName};
        }

        public void CreateMailAlias(MailAlias mailAlias)
        {
            // If not forwardto-address exists or is in another domain, create a new account with remoteaddress
            if (!GetEmailDomain(mailAlias.Name).Equals(GetEmailDomain(mailAlias.ForwardTo), StringComparison.InvariantCultureIgnoreCase) || !AccountExists(mailAlias.ForwardTo))
            {
                mailAlias.ForwardingEnabled = true;
                mailAlias.DeleteOnForward = true;
                mailAlias.ForwardingAddresses = new[] {mailAlias.ForwardTo};
                mailAlias.Password = GetRandomPassword();
                CreateAccount(mailAlias);
            }
                // else open account and add alias to list
            else
            {
                var accountOject = GetAccountObject(mailAlias.ForwardTo);
                var aliases = GetAliasListFromAccountObject(accountOject).ToList();
                aliases.Add(GetEmailUser(mailAlias.Name));
                accountOject.SetProperty("U_EmailAlias", string.Join(";", aliases));

                SaveAccount(accountOject, "account when creating mail alias");
            }
        }

        private string GetRandowChars(string chars, int length)
        {
            var random = new Random();
            return new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
        }

        protected string GetRandomPassword()
        {
            var apiObject = GetApiObject();
            var minLength = apiObject.GetProperty("C_Accounts_Policies_Pass_MinLength");
            var digits = apiObject.GetProperty("C_Accounts_Policies_Pass_Digits");
            var nonAlphaNum = apiObject.GetProperty("C_Accounts_Policies_Pass_NonAlphaNum");
            var alpha = apiObject.GetProperty("C_Accounts_Policies_Pass_Alpha");

            return System.Web.Security.Membership.GeneratePassword(minLength, nonAlphaNum) + 
                GetRandowChars("0123456789", digits)+
                GetRandowChars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", alpha);
        }

        public void UpdateMailAlias(MailAlias mailAlias)
        {
            // Delete alias based on mailAlias.Name
            DeleteMailAlias(mailAlias.Name);

            // Recreate alias
            CreateMailAlias(mailAlias);
        }

        public void DeleteMailAlias(string mailAliasName)
        {
            // Find account where alias exists
            var accountObject = GetAccountObject(mailAliasName);

            // Check if it has any other aliases
            var otherAliases = ((IEnumerable<string>)GetAliasListFromAccountObject(accountObject)).Where(a => a != GetEmailUser(mailAliasName)).ToArray();
            if (otherAliases.Any())
            {
                accountObject.SetProperty("U_EmailAlias", string.Join(";", otherAliases));
                SaveAccount(accountObject, "account during alias delete");
            }
                // If no other aliases, this should be an account with a remote address and then we should delete the account
            else
            {
                DeleteAccount(mailAliasName);
            }
        }

        #endregion

        #region Groups

        public bool GroupExists(string groupName)
        {
            var accountObject = GetAccountObject();

            return accountObject.Open(groupName) && Convert.ToInt32(accountObject.GetProperty("U_Type")) == 7;
        }

        public MailGroup[] GetGroups(string domainName)
        {
            return GetItems(domainName, IceWarpAccountType.UserGroup, CreateMailGroupFromAccountObject);
        }

        protected MailGroup CreateMailGroupFromAccountObject(dynamic accountObject)
        {
            var mailGroup = new MailGroup
            {
                Name = accountObject.EmailAddress,
                Enabled = Convert.ToInt32((object) accountObject.GetProperty("U_AccountDisabled")) == 0,
                GroupName = accountObject.GetProperty("G_Name"),
                Members = ((IEnumerable<string>)SplitFileContents(accountObject, "G_ListFile_Contents")).ToArray()
            };

            return mailGroup;
        }

        public MailGroup GetGroup(string groupName)
        {
            var accountObject = GetAccountObject(groupName);
            return CreateMailGroupFromAccountObject(accountObject);
        }

        public void CreateGroup(MailGroup @group)
        {
            var accountObject = GetAccountObject();

            if (accountObject.New(group.Name))
            {
                accountObject.SetProperty("U_Type", 7);
                accountObject.SetProperty("G_GroupwareMailDelivery", false);
                SaveAccount(accountObject, "group account");
            }
            else
            {
                throw new ApplicationException("Failed to create group: " + GetErrorMessage(accountObject.LastErr));
            }

            UpdateGroup(group);
        }

        public void UpdateGroup(MailGroup @group)
        {
            var accountObject = GetAccountObject(group.Name);

            accountObject.SetProperty("G_Name", group.GroupName);
            accountObject.SetProperty("U_AccountDisabled", group.Enabled ? 0 : 2);
            accountObject.SetProperty("G_ListFile_Contents", string.Join("\n", group.Members));

            SaveAccount(accountObject, "group");
        }

        public void DeleteGroup(string groupName)
        {
            var accountObject = GetAccountObject(groupName);
            if (!accountObject.Delete())
            {
                throw new Exception("Cannot delete group: " + GetErrorMessage(accountObject.LastErr));
            }
        }

        #endregion

        #region Lists

        public bool ListExists(string maillistName)
        {
            var accountObject = GetAccountObject();

            return accountObject.Open(maillistName) && (IceWarpAccountType) Enum.Parse(typeof (IceWarpAccountType), ((object) accountObject.GetProperty("U_Type")).ToString()) == IceWarpAccountType.MailingList;
        }

        public MailList[] GetLists(string domainName)
        {
            return GetItems(domainName, IceWarpAccountType.MailingList, CreateMailListFromAccountObject);
        }

        protected IEnumerable<string> SplitStringProperty(dynamic accountObject, string propertyName, char separator)
        {
            var value = (object) accountObject.GetProperty(propertyName);
            return value == null ? new String[] {} : value.ToString().Split(new[] {separator}, StringSplitOptions.RemoveEmptyEntries);
        }

        protected IEnumerable<string> SplitFileContents(dynamic accountObject, string propertyName)
        {
            return SplitStringProperty(accountObject, propertyName, '\n');
        }

        protected MailList CreateMailListFromAccountObject(dynamic accountObject)
        {
            // IceWarp has separate settings for list server and mailing list. Together they have all the info we need for a WSP MailList
            // From an accountObject of type list server, we can fetch the mailing lists associated with it
            // So, first we search and find the list server account that is associated with this mailing list account.
            var listServerAccountObject = FindMatchingListServerAccount(accountObject.EmailAddress, true);

            var mailList = new MailList
            {
                //From mailing list account
                Name = accountObject.EmailAddress,
                Description = accountObject.GetProperty("M_Name"),
                ModeratorAddress = accountObject.GetProperty("M_OwnerAddress"),
                MembersSource = (IceWarpListMembersSource) Enum.Parse(typeof (IceWarpListMembersSource), ((object) accountObject.GetProperty("M_SendAllLists")).ToString()),
                Members = ((IEnumerable<string>)SplitFileContents(accountObject, "M_ListFile_Contents")).Select(m => m.TrimEnd(new[] {';', '0', '1', '2'})).ToArray(),
                SetReceipientsToToHeader = Convert.ToBoolean((object) accountObject.GetProperty("M_SeparateTo")),
                SubjectPrefix = accountObject.GetProperty("M_AddToSubject"),
                Originator = (IceWarpListOriginator) Enum.Parse(typeof (IceWarpListOriginator), ((object) accountObject.GetProperty("M_ListSender")).ToString()),
                PostingMode = Convert.ToBoolean((object) accountObject.GetProperty("M_MembersOnly")) ? PostingMode.MembersCanPost : PostingMode.AnyoneCanPost,
                PasswordProtection = (PasswordProtection) Enum.Parse(typeof (PasswordProtection), ((object) accountObject.GetProperty("M_Moderated")).ToString()),
                Password = accountObject.GetProperty("M_ModeratedPassword"),
                DefaultRights = (IceWarpListDefaultRights) Enum.Parse(typeof (IceWarpListDefaultRights), ((object) accountObject.GetProperty("M_DefaultRights")).ToString()),
                MaxMessageSizeEnabled = Convert.ToBoolean((object) accountObject.GetProperty("M_MaxList")),
                MaxMessageSize = Convert.ToInt32((object) accountObject.GetProperty("M_MaxListSize")),
                MaxMembers = Convert.ToInt32((object) accountObject.GetProperty("M_MaxMembers")),
                SendToSender = Convert.ToBoolean((object) accountObject.GetProperty("M_SendToSender")),
                DigestMode = Convert.ToBoolean((object) accountObject.GetProperty("M_DigestConfirmed")),
                MaxMessagesPerMinute = Convert.ToInt32((object) accountObject.GetProperty("M_ListBatch")),
                SendSubscribe = Convert.ToBoolean((object) accountObject.GetProperty("M_NotifyJoin")),
                SendUnsubscribe = Convert.ToBoolean((object) accountObject.GetProperty("M_NotifyLeave")),

                // From list server account
                ConfirmSubscription = (IceWarpListConfirmSubscription) Enum.Parse(typeof (IceWarpListConfirmSubscription), ((object) listServerAccountObject.GetProperty("L_DigestConfirmed")).ToString()),
                CommandsInSubject = Convert.ToBoolean((object) listServerAccountObject.GetProperty("L_ListSubject")),
                DisableSubscribecommand = !Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_JoinR")),
                AllowUnsubscribe = Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_LeaveR")),
                DisableListcommand = !Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_ListsR")),
                DisableWhichCommand = !Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_WhichR")),
                DisableReviewCommand = !Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_ReviewR")),
                DisableVacationCommand = !Convert.ToBoolean((object) listServerAccountObject.GetProperty("M_VacationR")),
                Moderated = Convert.ToBoolean((object) listServerAccountObject.GetProperty("L_Moderated")),
                CommandPassword = listServerAccountObject.GetProperty("L_ModeratedPassword"),
                SuppressCommandResponses = Convert.ToBoolean((object) listServerAccountObject.GetProperty("L_MaxList"))
            };


            // This is how I get values for from and replyto header values. TODO: There must be a better way, but I don't see the pattern right now...
            var ss = Convert.ToInt32((object) accountObject.GetProperty("M_SetSender"));
            var sv = Convert.ToInt32((object) accountObject.GetProperty("M_SetValue"));
            var vm = Convert.ToBoolean((object) accountObject.GetProperty("M_ValueMode"));
            var value = accountObject.GetProperty("M_HeaderValue");

            switch (ss)
            {
                case 0:
                    switch (sv)
                    {
                        case 0:
                            mailList.FromHeader = IceWarpListFromAndReplyToHeader.NoChange;
                            mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.NoChange;
                            break;
                        case 1:
                            if (vm)
                            {
                                mailList.FromHeader = IceWarpListFromAndReplyToHeader.NoChange;
                                mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                                mailList.ListReplyToAddress = value;
                            }
                            else
                            {
                                mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                                mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.NoChange;
                                mailList.ListFromAddress = value;
                            }
                            break;
                        case 2:
                            mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                            mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                            var values = value.Split('|');
                            mailList.ListFromAddress = values[0];
                            mailList.ListReplyToAddress = values[1];
                            break;
                    }
                    break;
                case 1:
                    switch (sv)
                    {
                        case 0:
                            mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToSender;
                            mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.NoChange;
                            break;
                        case 1:
                            if (vm)
                            {
                                mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToSender;
                                mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                                mailList.ListReplyToAddress = value;
                            }
                            else
                            {
                                mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToValue;
                                mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.SetToSender;
                                mailList.ListFromAddress = value;
                            }

                            break;
                    }
                    break;
                case 2:
                    mailList.FromHeader = IceWarpListFromAndReplyToHeader.SetToSender;
                    mailList.ReplyToHeader = IceWarpListFromAndReplyToHeader.SetToSender;
                    break;
            }

            return mailList;
        }

        public MailList GetList(string maillistName)
        {
            var accountObject = GetAccountObject(maillistName);
            return CreateMailListFromAccountObject(accountObject);
        }

        public void CreateList(MailList maillist)
        {
            if (string.IsNullOrWhiteSpace(maillist.Name))
            {
                throw new ArgumentNullException("maillist.Name");
            }

            var accountObject = GetAccountObject();

            if (!accountObject.New(maillist.Name))
            {
                throw new ApplicationException("Failed to create mailing list: " + GetErrorMessage(accountObject.LastErr));
            }

            accountObject.SetProperty("U_Type", IceWarpAccountType.MailingList);

            SaveAccount(accountObject, "mailing list");

            UpdateList(maillist);
        }

        protected dynamic FindMatchingListServerAccount(string mailingListName, bool createListServerAccountIfNeeded)
        {
            var listServerAccountObject = GetAccountObject();
            var forceCreatelistServerAccountObject = false;
            var listServerAccountFound = false;

            if (listServerAccountObject.FindInitQuery(GetEmailDomain(mailingListName), "U_Type=" + (int)IceWarpAccountType.ListServer))
            {
                while (listServerAccountObject.FindNext())
                {
                    var lists = ((IEnumerable<string>)SplitFileContents(listServerAccountObject, "L_ListFile_Contents")).ToList();
                    if (lists.Contains(mailingListName))
                    {
                        listServerAccountFound = true;

                        // If this list server account is responsible for more than one mailing list, force creation of a new one.
                        if (lists.Count() > 1)
                        {
                            forceCreatelistServerAccountObject = true;
                            listServerAccountObject.SetProperty("L_ListFile_Contents", string.Join("\n", lists.Remove(mailingListName)));
                            SaveAccount(listServerAccountObject, "list server account ");
                        }
                        break;
                    }
                }
            }

            // If no list server was found that was responsible for this mailing list, create one
            if (forceCreatelistServerAccountObject || !listServerAccountFound && createListServerAccountIfNeeded)
            {
                // Create list server account    
                if (!listServerAccountObject.New("srv" + mailingListName))
                {
                    throw new Exception("Cannot create listserver account to associate with mailing list." + GetErrorMessage(listServerAccountObject.LastErr));
                }

                listServerAccountObject.SetProperty("U_Type", IceWarpAccountType.ListServer);
                listServerAccountObject.SetProperty("L_SendAllLists", 0);
                listServerAccountObject.SetProperty("L_ListFile_Contents", mailingListName + "\n");

                SaveAccount(listServerAccountObject, "listserver account to associate with mailing list");
            }

            return !listServerAccountFound ? null : listServerAccountObject;
        }

        public void UpdateList(MailList maillist)
        {
            var accountObject = GetAccountObject(maillist.Name);
            var listServerAccountObject = FindMatchingListServerAccount(maillist.Name, true);

            accountObject.SetProperty("M_Name", maillist.Description);
            accountObject.SetProperty("M_OwnerAddress", maillist.ModeratorAddress);
            accountObject.SetProperty("M_SendAllLists", maillist.MembersSource);
            accountObject.SetProperty("L_ListFile_Contents", string.Join(";0;\n", maillist.Members) + ";0;\n"); // 0 means that the members will have the default rights
            // TODO: Create some way to manage list member rights. As it is now, all members will loose rights that is set using some other tool

            var setSender = 0;
            var setValue = 0;
            var valueMode = false;
            var value = "";

            switch (maillist.FromHeader)
            {
                case IceWarpListFromAndReplyToHeader.NoChange:
                    switch (maillist.ReplyToHeader)
                    {
                        case IceWarpListFromAndReplyToHeader.NoChange:
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToSender:
                            setSender = 1;
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToValue:
                            setSender = 1;
                            valueMode = true;
                            value = maillist.ListReplyToAddress;
                            break;
                    }
                    break;
                case IceWarpListFromAndReplyToHeader.SetToSender:
                    switch (maillist.ReplyToHeader)
                    {
                        case IceWarpListFromAndReplyToHeader.NoChange:
                            setSender = 1;
                            valueMode = true;
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToSender:
                            setSender = 2;
                            valueMode = true;
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToValue:
                            setSender = 1;
                            setValue = 1;
                            valueMode = true;
                            value = maillist.ListReplyToAddress;
                            break;
                    }
                    break;
                case IceWarpListFromAndReplyToHeader.SetToValue:
                    switch (maillist.ReplyToHeader)
                    {
                        case IceWarpListFromAndReplyToHeader.NoChange:
                            setValue = 1;
                            value = maillist.ListFromAddress;
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToSender:
                            setSender = 1;
                            setValue = 1;
                            value = maillist.ListFromAddress;
                            break;
                        case IceWarpListFromAndReplyToHeader.SetToValue:
                            setValue = 2;
                            value = maillist.ListFromAddress + "|" + maillist.ListReplyToAddress;
                            break;
                    }
                    break;
            }

            accountObject.SetProperty("M_SetSender", setSender);
            accountObject.SetProperty("M_SetValue", setValue);
            accountObject.SetProperty("M_ValueMode", valueMode);
            accountObject.SetProperty("M_HeaderValue", value);
            accountObject.SetProperty("M_SeparateTo", maillist.SetReceipientsToToHeader);
            accountObject.SetProperty("M_AddToSubject", maillist.SubjectPrefix);
            accountObject.SetProperty("M_ListSender", maillist.Originator);
            accountObject.SetProperty("M_MembersOnly", maillist.PostingMode == PostingMode.MembersCanPost);
            accountObject.SetProperty("M_Moderated", maillist.PasswordProtection);
            accountObject.SetProperty("M_ModeratedPassword", maillist.Password);
            accountObject.SetProperty("M_DefaultRights", maillist.DefaultRights);
            accountObject.SetProperty("M_MaxList", maillist.MaxMessageSizeEnabled);
            accountObject.SetProperty("M_MaxListSize", maillist.MaxMessageSize);
            accountObject.SetProperty("M_MaxMembers", maillist.MaxMembers);
            accountObject.SetProperty("M_SendToSender", maillist.SendToSender);
            accountObject.SetProperty("M_DigestConfirmed", maillist.DigestMode);
            accountObject.SetProperty("M_ListBatch", maillist.MaxMessagesPerMinute);
            accountObject.SetProperty("M_NotifyJoin", maillist.SendSubscribe);
            accountObject.SetProperty("M_NotifyLeave", maillist.SendUnsubscribe);

            SaveAccount(accountObject, "mailing list account");

            listServerAccountObject.SetProperty("L_Name", maillist.Description);
            listServerAccountObject.SetProperty("L_OwnerAddress", maillist.ModeratorAddress);
            listServerAccountObject.SetProperty("L_SendAllLists", 0);
            listServerAccountObject.SetProperty("L_DigestConfirmed", maillist.ConfirmSubscription);
            listServerAccountObject.SetProperty("L_ListSubject", maillist.CommandsInSubject);
            listServerAccountObject.SetProperty("M_JoinR", !maillist.DisableSubscribecommand);
            listServerAccountObject.SetProperty("M_LeaveR", maillist.AllowUnsubscribe);
            listServerAccountObject.SetProperty("M_ListsR", !maillist.DisableListcommand);
            listServerAccountObject.SetProperty("M_WhichR", !maillist.DisableWhichCommand);
            listServerAccountObject.SetProperty("M_ReviewR", !maillist.DisableReviewCommand);
            listServerAccountObject.SetProperty("M_VacationR", !maillist.DisableVacationCommand);
            listServerAccountObject.SetProperty("L_Moderated", maillist.Moderated);
            listServerAccountObject.SetProperty("L_ModeratedPassword", maillist.CommandPassword);
            listServerAccountObject.SetProperty("L_ListSender", maillist.Originator);
            listServerAccountObject.SetProperty("L_MaxList", maillist.SuppressCommandResponses);

            SaveAccount(accountObject, "listserver account associated with mailing list");
        }

        public void DeleteList(string maillistName)
        {
            var accountObject = GetAccountObject(maillistName);
            var listServerAccountObject = FindMatchingListServerAccount(maillistName, false);

            if (accountObject.Delete())
            {
                // If there is no matching list server account, we are done
                if (listServerAccountObject == null)
                {
                    return;
                }

                var lists = ((IEnumerable<string>)SplitFileContents(listServerAccountObject, "L_ListFile_Contents")).ToList();

                if (lists.Count() == 1)
                {
                    if (!listServerAccountObject.Delete())
                    {
                        throw new Exception("Deleted mail list, but list server account remains: " + GetErrorMessage(listServerAccountObject.LastErr));
                    }
                }
                else
                {
                    listServerAccountObject.SetProperty("L_ListFile_Contents", string.Join("\n", lists.Remove(maillistName)));
                    if (!listServerAccountObject.Save())
                    {
                        throw new Exception("Deleted mail list, but associated list server account could not be updated: " + GetErrorMessage(listServerAccountObject.LastErr));
                    }
                }
            }
            else
            {
                throw new Exception("Cannot delete mail list: " + GetErrorMessage(accountObject.LastErr));
            }
        }

        #endregion
    }
}
