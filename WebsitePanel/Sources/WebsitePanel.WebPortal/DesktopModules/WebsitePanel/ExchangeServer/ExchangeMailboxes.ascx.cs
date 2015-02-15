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
using System.Linq;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using System.Collections.Generic;

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class ExchangeMailboxes : WebsitePanelModuleBase
    {
        private bool ArchivingBoxes
        {
            get
            {
                return PanelRequest.Ctl.ToLower().Contains("archiving");
            }
        }

        private PackageContext cntx;

        private ServiceLevel[] ServiceLevels;

        protected void Page_Load(object sender, EventArgs e)
        {
            locTitle.Text = ArchivingBoxes ? GetLocalizedString("locTitleArchiving.Text") : GetLocalizedString("locTitle.Text");

            btnCreateMailbox.Visible = !ArchivingBoxes;

            cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);

            if (!IsPostBack)
            {
                chkMailboxes.Checked = true;
                chkResourceMailboxes.Checked = true;
                chkSharedMailboxes.Checked = true;

                BindStats();
            }

            BindServiceLevels();

            if (cntx.Quotas.ContainsKey(Quotas.EXCHANGE2007_ISCONSUMER))
            {
                if (cntx.Quotas[Quotas.EXCHANGE2007_ISCONSUMER].QuotaAllocatedValue != 1)
                {
                    gvMailboxes.Columns[6].Visible = false;
                }
            }

            gvMailboxes.Columns[4].Visible = cntx.Groups.ContainsKey(ResourceGroups.ServiceLevels);
        }

        private void BindServiceLevels()
        {
            ServiceLevels = ES.Services.Organizations.GetSupportServiceLevels();
        }

        private void BindStats()
        {
            // quota values
            OrganizationStatistics stats = ES.Services.ExchangeServer.GetOrganizationStatisticsByOrganization(PanelRequest.ItemID);
            OrganizationStatistics tenantStats = ES.Services.ExchangeServer.GetOrganizationStatistics(PanelRequest.ItemID);
            mailboxesQuota.QuotaUsedValue = stats.CreatedMailboxes;
            mailboxesQuota.QuotaValue = stats.AllocatedMailboxes;
            if (stats.AllocatedMailboxes != -1) mailboxesQuota.QuotaAvailable = tenantStats.AllocatedMailboxes - tenantStats.CreatedMailboxes;

            if (cntx != null && cntx.Groups.ContainsKey(ResourceGroups.ServiceLevels)) BindServiceLevelsStats();
        }

        private void BindServiceLevelsStats()
        {
            ServiceLevels = ES.Services.Organizations.GetSupportServiceLevels();
            OrganizationUser[] accounts = ES.Services.Organizations.SearchAccounts(PanelRequest.ItemID, "", "", "", true);

            List<ServiceLevelQuotaValueInfo> serviceLevelQuotas = new List<ServiceLevelQuotaValueInfo>();
            foreach (var quota in Array.FindAll<QuotaValueInfo>(
                   cntx.QuotasArray, x => x.QuotaName.Contains(Quotas.SERVICE_LEVELS)))
            {
                int levelId = ServiceLevels.Where(x => x.LevelName == quota.QuotaName.Replace(Quotas.SERVICE_LEVELS, "")).FirstOrDefault().LevelId;
                int usedInOrgCount = accounts.Where(x => x.LevelId == levelId).Count();

                serviceLevelQuotas.Add(new ServiceLevelQuotaValueInfo
                {
                    QuotaName = quota.QuotaName,
                    QuotaDescription = quota.QuotaDescription + " in this Organization:",
                    QuotaTypeId = quota.QuotaTypeId,
                    QuotaValue = quota.QuotaAllocatedValue,
                    QuotaUsedValue = usedInOrgCount,
                    //QuotaUsedValue = quota.QuotaUsedValue,
                    QuotaAvailable = quota.QuotaAllocatedValue - quota.QuotaUsedValue
                });
            }
            dlServiceLevelQuotas.DataSource = serviceLevelQuotas;
            dlServiceLevelQuotas.DataBind();
        }

        protected void btnCreateMailbox_Click(object sender, EventArgs e)
        {
            Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "create_mailbox",
                "SpaceID=" + PanelSecurity.PackageId));
        }

        public string GetMailboxEditUrl(string accountId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "mailbox_settings",
                    "AccountID=" + accountId,
                    "ItemID=" + PanelRequest.ItemID);
        }

        protected void odsAccountsPaged_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                messageBox.ShowErrorMessage("EXCHANGE_GET_MAILBOXES", e.Exception);
                e.ExceptionHandled = true;
            }
        }

        public string GetAccountImage(int accountTypeId, bool vip)
        {
            ExchangeAccountType accountType = (ExchangeAccountType)accountTypeId;
            string imgName = "mailbox_16.gif";

            if (accountType == ExchangeAccountType.Contact)
                imgName = "contact_16.gif";
            else if (accountType == ExchangeAccountType.DistributionList)
                imgName = "dlist_16.gif";
            else if (accountType == ExchangeAccountType.Room)
                imgName = "room_16.gif";
            else if (accountType == ExchangeAccountType.Equipment)
                imgName = "equipment_16.gif";
            else if (accountType == ExchangeAccountType.SharedMailbox)
                imgName = "shared_16.gif";

            if (vip && cntx.Groups.ContainsKey(ResourceGroups.ServiceLevels)) imgName = "vip_user_16.png";

            return GetThemedImage("Exchange/" + imgName);
        }

        public string GetStateImage(bool locked, bool disabled)
        {
            string imgName = "enabled.png";

            if (locked)
                imgName = "locked.png";
            else
                if (disabled)
                    imgName = "disabled.png";

            return GetThemedImage("Exchange/" + imgName);
        }

        protected void gvMailboxes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                // delete mailbox
                int accountId = Utils.ParseInt(e.CommandArgument.ToString(), 0);

                try
                {
                    int result = ES.Services.ExchangeServer.DisableMailbox(PanelRequest.ItemID, accountId);
                    if (result < 0)
                    {
                        messageBox.ShowResultMessage(result);
                        return;
                    }

                    // rebind grid
                    gvMailboxes.DataBind();

                    // bind stats
                    BindStats();
                }
                catch (Exception ex)
                {
                    messageBox.ShowErrorMessage("EXCHANGE_DELETE_MAILBOX", ex);
                }
            }
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)   
        {   
            gvMailboxes.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);   
       
            // rebind grid   
            gvMailboxes.DataBind();   
       
            // bind stats   
            BindStats();   
       
        }


        public string GetOrganizationUserEditUrl(string accountId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "edit_user",
                    "AccountID=" + accountId,
                    "ItemID=" + PanelRequest.ItemID,
                    "Context=User");
        }

        protected void odsAccountsPaged_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["archiving"] = ArchivingBoxes;
        }

        public ServiceLevel GetServiceLevel(int levelId)
        {
            ServiceLevel serviceLevel = ServiceLevels.Where(x => x.LevelId == levelId).DefaultIfEmpty(new ServiceLevel { LevelName = "", LevelDescription = "" }).FirstOrDefault();

            bool enable = !string.IsNullOrEmpty(serviceLevel.LevelName);

            enable = enable ? cntx.Quotas.ContainsKey(Quotas.SERVICE_LEVELS + serviceLevel.LevelName) : false;
            enable = enable ? cntx.Quotas[Quotas.SERVICE_LEVELS + serviceLevel.LevelName].QuotaAllocatedValue != 0 : false;

            if (!enable)
            {
                serviceLevel.LevelName = "";
                serviceLevel.LevelDescription = "";
            }

            return serviceLevel;
        }

        protected void chkMailboxes_CheckedChanged(object sender, EventArgs e)
        {
            List<string> accountTypes = new List<string>();

            if ((!chkMailboxes.Checked)&&(!chkSharedMailboxes.Checked)&&(!chkResourceMailboxes.Checked))
                chkMailboxes.Checked = true;

            if (chkMailboxes.Checked)
                accountTypes.Add("1");

            if (chkSharedMailboxes.Checked)
                accountTypes.Add("10");

            if (chkResourceMailboxes.Checked)
                accountTypes.AddRange(new string[] {"5","6"});

            odsAccountsPaged.SelectParameters["accountTypes"].DefaultValue = string.Join(",", accountTypes);
        }

        protected void userActions_OnExecutingUserAction(object sender, EventArgs e)
        {
            // Get checked users
            var userIds = Utils.GetCheckboxValuesFromGrid<int>(gvMailboxes, "chkSelectedUsersIds");

            if (userActions.SelectedAction != UserActionTypes.None)
            {
                if (userIds.Count > 0)
                {
                    try
                    {
                        var result = userActions.DoUserActions(userIds);

                        if (result < 0)
                        {
                            messageBox.ShowResultMessage(result);
                            return;
                        }

                        messageBox.ShowSuccessMessage("ORGANIZATION_USERS_ACTIONS");
                    }
                    catch (Exception ex)
                    {
                        messageBox.ShowErrorMessage("ORGANIZATION_USERS_ACTIONS", ex);
                    }

                    // Refresh users grid
                    gvMailboxes.DataBind();
                }
                else
                {
                    messageBox.ShowWarningMessage("ORGANIZATION_USERS_ACTIONS");
                }
            }
        }
    }
}
