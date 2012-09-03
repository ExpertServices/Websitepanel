// Copyright (c) 2012, Outercurve Foundation.
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
// - Neither  the  name  of  the  SMB SAAS Systems Inc.  nor   the   names  of  its
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
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.Portal.HostedSolution
{
    public partial class OrganizationUsers : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindStats();
            }


            PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);
            if (cntx.Quotas.ContainsKey(Quotas.EXCHANGE2007_ISCONSUMER))
            {
                if (cntx.Quotas[Quotas.EXCHANGE2007_ISCONSUMER].QuotaAllocatedValue != 1)
                {
                    gvUsers.Columns[3].Visible = false;
                }
            }


        }

        private void BindStats()
        {
            // quota values
            OrganizationStatistics stats =
                ES.Services.Organizations.GetOrganizationStatistics(PanelRequest.ItemID);
            usersQuota.QuotaUsedValue = stats.CreatedUsers;
            usersQuota.QuotaValue = stats.AllocatedUsers;
        }

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "create_user",
                "SpaceID=" + PanelSecurity.PackageId));
        }

        public string GetUserEditUrl(string accountId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "edit_user",
                    "AccountID=" + accountId,
                    "ItemID=" + PanelRequest.ItemID,
                    "Context=User");
        }

        protected void odsAccountsPaged_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                messageBox.ShowErrorMessage("ORGANZATION_GET_USERS", e.Exception);
                e.ExceptionHandled = true;
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                // delete user
                int accountId = Utils.ParseInt(e.CommandArgument.ToString(), 0);

                try
                {
                    int result = ES.Services.Organizations.DeleteUser(PanelRequest.ItemID, accountId);
                    if (result < 0)
                    {
                        messageBox.ShowResultMessage(result);
                        return;
                    }

                    // rebind grid
                    gvUsers.DataBind();

                    // bind stats
                    BindStats();
                }
                catch (Exception ex)
                {
                    messageBox.ShowErrorMessage("ORGANIZATIONS_DELETE_USERS", ex);
                }
            }
        }


        public string GetAccountImage(int accountTypeId)
        {
            string imgName = string.Empty;

            ExchangeAccountType accountType = (ExchangeAccountType)accountTypeId;
            switch (accountType)
            {
                case ExchangeAccountType.Room:
                    imgName = "room_16.gif";
                    break;
                case ExchangeAccountType.Equipment:
                    imgName = "equipment_16.gif";
                    break;
                default:
                    imgName = "admin_16.png";
                    break;
            }

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


        public string GetMailImage(int accountTypeId)
        {
            string imgName = "exchange24.png";

            ExchangeAccountType accountType = (ExchangeAccountType)accountTypeId;

            if (accountType == ExchangeAccountType.User)
                imgName = "blank16.gif";

            return GetThemedImage("Exchange/" + imgName);
        }

        public string GetOCSImage(bool IsOCSUser, bool IsLyncUser)
        {
            string imgName = "blank16.gif";

            if (IsLyncUser)
                imgName = "lync16.png";
            else
                if ((IsOCSUser))
                    imgName = "ocs16.png";

            return GetThemedImage("Exchange/" + imgName);
        }

        public string GetBlackBerryImage(bool IsBlackBerryUser)
        {
            string imgName = "blank16.gif";

            if (IsBlackBerryUser)
                imgName = "blackberry16.png";

            return GetThemedImage("Exchange/" + imgName);
        }

        public string GetCRMImage(Guid CrmUserId)
        {
            string imgName = "blank16.gif";

            if (CrmUserId != Guid.Empty)
                imgName = "crm_16.png";

            return GetThemedImage("Exchange/" + imgName);
        }


        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)   
        {   
            gvUsers.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);   
                 
            // rebind grid   
            gvUsers.DataBind();   
       
            // bind stats   
            BindStats();   
        }  

    }
}