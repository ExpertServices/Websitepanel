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
    }

    public partial class UserActions : WebsitePanelControlBase
    {
        public event EventHandler ExecutingUserAction;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Remove Service Level item and VIP item from Action List if current Hosting plan does not allow Service Levels
            if (!PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId).Groups.ContainsKey(ResourceGroups.ServiceLevels))
            {
                ddlUserActions.Items.Remove(ddlUserActions.Items.FindByValue(UserActionTypes.SetServiceLevel.ToString()));
                ddlUserActions.Items.Remove(ddlUserActions.Items.FindByValue(UserActionTypes.SetVIP.ToString()));
            }
        }

        public UserActionTypes SelectedAction
        {
            get
            {
                return (UserActionTypes)Convert.ToInt32(ddlUserActions.SelectedValue);
            }
        }

        protected void cmdApply_OnClick(object sender, ImageClickEventArgs e)
        {
            switch (SelectedAction)
            {
                case UserActionTypes.Disable:
                    Modal.PopupControlID = DisablePanel.ID;
                    break;
                case UserActionTypes.Enable:
                    Modal.PopupControlID = EnablePanel.ID;
                    break;
                case UserActionTypes.SetServiceLevel:
                    FillServiceLevelsList();
                    Modal.PopupControlID = ServiceLevelPanel.ID;
                    break;
                case UserActionTypes.SetVIP:
                    Modal.PopupControlID = VIPPanel.ID;
                    break;
                default:
                    return;
            }

            Modal.Show();
        }

        public int DoUserActions(List<int> userIds)
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
                    return ChangeUsersSettings(userIds, null, null, SelectedVIP);
            }

            return 0;
        }

        protected void btnModalOk_Click(object sender, EventArgs e)
        {
            if (ExecutingUserAction != null)
                ExecutingUserAction(this, new EventArgs());
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
                    isVIP ?? user.IsVIP);

                if (result < 0)
                {
                    return result;
                }
            }

            return 0;
        }


        #region ServiceLevel

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


        #region VIP

        protected bool? SelectedVIP
        {
            get { return ddlVIP.SelectedValue == "0"; }
        }

        #endregion

    }
}
