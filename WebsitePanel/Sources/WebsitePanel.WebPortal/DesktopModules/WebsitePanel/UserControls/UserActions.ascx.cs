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
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Web.Services3.Referral;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.Portal.UserControls;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal
{
    public enum UserActionTypes
    {
        None = 0,
        Disable = 1,
        Enable = 2,
        SetServiceLevel = 3,
        SetVIP = 4,
        UnsetVIP = 5,
        SetMailboxPlan = 6
    }

    public partial class UserActions : ActionListControlBase<UserActionTypes>
    {
        public bool ShowSetMailboxPlan { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Remove Service Level item and VIP item from Action List if current Hosting plan does not allow Service Levels
            if (!PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId).Groups.ContainsKey(ResourceGroups.ServiceLevels))
            {
                RemoveActionItem(UserActionTypes.SetServiceLevel);
                RemoveActionItem(UserActionTypes.SetVIP);
                RemoveActionItem(UserActionTypes.UnsetVIP);
            }

            if (!ShowSetMailboxPlan)
                RemoveActionItem(UserActionTypes.SetMailboxPlan);
        }

        protected override DropDownList ActionsList
        {
            get { return ddlUserActions; }
        }

        protected override int DoAction(List<int> userIds)
        {
            switch (SelectedAction)
            {
                case UserActionTypes.Disable:
                    return ChangeUsersSettings(userIds, true, null, null);
                case UserActionTypes.Enable:
                    return ChangeUsersSettings(userIds, false, null, null);
                case UserActionTypes.SetServiceLevel:
                    return ChangeUsersSettings(userIds, null, SelectedServiceId, null);
                case UserActionTypes.SetVIP:
                    return ChangeUsersSettings(userIds, null, null, true);
                case UserActionTypes.UnsetVIP:
                    return ChangeUsersSettings(userIds, null, null, false);
                case UserActionTypes.SetMailboxPlan:
                    return SetMailboxPlan(userIds);
            }

            return 0;
        }

        protected void btnModalOk_Click(object sender, EventArgs e)
        {
            FireExecuteAction();
        }

        protected void btnModalCancel_OnClick(object sender, EventArgs e)
        {
            ResetSelection();
        }

        protected int ChangeUsersSettings(List<int> userIds, bool? disable, int? serviceLevelId, bool? isVIP)
        {
            foreach (var userId in userIds)
            {
                OrganizationUser user = ES.Services.Organizations.GetUserGeneralSettings(PanelRequest.ItemID, userId);

                int result = ES.Services.Organizations.SetUserGeneralSettings(
                    PanelRequest.ItemID,
                    userId,

                    user.DisplayName,
                    string.Empty,
                    false,
                    disable ?? user.Disabled,
                    user.Locked,

                    user.FirstName,
                    user.Initials,
                    user.LastName,

                    user.Address,
                    user.City,
                    user.State,
                    user.Zip,
                    user.Country,

                    user.JobTitle,
                    user.Company,
                    user.Department,
                    user.Office,
                    user.Manager != null ? user.Manager.AccountName : String.Empty,

                    user.BusinessPhone,
                    user.Fax,
                    user.HomePhone,
                    user.MobilePhone,
                    user.Pager,
                    user.WebPage,
                    user.Notes,
                    user.ExternalEmail,
                    user.SubscriberNumber,
                    serviceLevelId ?? user.LevelId,
                    isVIP ?? user.IsVIP, 
                    user.UserMustChangePassword);

                if (result < 0)
                    return result;
            }

            return 0;
        }


        #region ServiceLevel

        protected int SetMailboxPlan(List<int> userIds)
        {
            int planId;
            
            if (!int.TryParse(mailboxPlanSelector.MailboxPlanId, out planId))
                return 0;

            if (planId < 0) return 0;

            foreach (int userId in userIds)
            {
                ExchangeAccount account = ES.Services.ExchangeServer.GetAccount(PanelRequest.ItemID, userId);

                int result = ES.Services.ExchangeServer.SetExchangeMailboxPlan(PanelRequest.ItemID, userId, planId,
                    account.ArchivingMailboxPlanId, account.EnableArchiving);

                if (result < 0)
                    return result;
            }

            return 0;
        }

        protected int? SelectedServiceId
        {
            get
            {
                if (ddlServiceLevels.SelectedValue == string.Empty)
                    return null;

                return Convert.ToInt32(ddlServiceLevels.SelectedValue);
            }
        }

        protected void FillServiceLevelsList()
        {
            PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);

            if (cntx.Groups.ContainsKey(ResourceGroups.ServiceLevels))
            {
                List<ServiceLevel> enabledServiceLevels = new List<ServiceLevel>();

                foreach (var quota in cntx.Quotas.Where(x => x.Key.Contains(Quotas.SERVICE_LEVELS)))
                {
                    foreach (var serviceLevel in ES.Services.Organizations.GetSupportServiceLevels())
                    {
                        if (quota.Key.Replace(Quotas.SERVICE_LEVELS, "") == serviceLevel.LevelName && CheckServiceLevelQuota(quota.Value))
                        {
                            enabledServiceLevels.Add(serviceLevel);
                        }
                    }
                }

                ddlServiceLevels.DataSource = enabledServiceLevels;
                ddlServiceLevels.DataTextField = "LevelName";
                ddlServiceLevels.DataValueField = "LevelId";
                ddlServiceLevels.DataBind();

                ddlServiceLevels.Items.Insert(0, new ListItem("<Select Service Level>", string.Empty));
                ddlServiceLevels.Items.FindByValue(string.Empty).Selected = true;
            }
        }

        private bool CheckServiceLevelQuota(QuotaValueInfo quota)
        {
            if (quota.QuotaAllocatedValue != -1)
            {
                return quota.QuotaAllocatedValue > quota.QuotaUsedValue;
            }

            return true;
        }

        #endregion

        protected void btnApply_Click(object sender, EventArgs e)
        {
            switch (SelectedAction)
            {
                case UserActionTypes.Disable:
                case UserActionTypes.Enable:
                case UserActionTypes.SetVIP:
                case UserActionTypes.UnsetVIP:
                    FireExecuteAction();
                    break;
                case UserActionTypes.SetServiceLevel:
                    FillServiceLevelsList();
                    Modal.PopupControlID = ServiceLevelPanel.ID;
                    Modal.Show();
                    break;
                case UserActionTypes.SetMailboxPlan:
                    Modal.PopupControlID = MailboxPlanPanel.ID;
                    Modal.Show();
                    break;

            }

        }

    }
}
