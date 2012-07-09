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
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class ExchangeMailboxPlans : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // bind mailboxplans
                BindMailboxPlans();
            }

        }

        public string GetMailboxPlanDisplayUrl(string MailboxPlanId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "add_mailboxplan",
                    "MailboxPlanId=" + MailboxPlanId,
                    "ItemID=" + PanelRequest.ItemID);
        }


        private void BindMailboxPlans()
        {
            ExchangeMailboxPlan[] list = ES.Services.ExchangeServer.GetExchangeMailboxPlans(PanelRequest.ItemID);

            gvMailboxPlans.DataSource = list;
            gvMailboxPlans.DataBind();

            //check if organization has only one default domain
            if (gvMailboxPlans.Rows.Count == 1)
            {
                btnSetDefaultMailboxPlan.Enabled = false;
            }
        }

        public string IsChecked(bool val)
        {
            return val ? "checked" : "";
        }

        protected void btnAddMailboxPlan_Click(object sender, EventArgs e)
        {
            btnSetDefaultMailboxPlan.Enabled = true;
            Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "add_mailboxplan",
                "SpaceID=" + PanelSecurity.PackageId));
        }

        protected void gvMailboxPlan_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int mailboxPlanId = Utils.ParseInt(e.CommandArgument.ToString(), 0);

                try
                {
                    int result = ES.Services.ExchangeServer.DeleteExchangeMailboxPlan(PanelRequest.ItemID, mailboxPlanId);

                    if (result < 0)
                    {
                        messageBox.ShowResultMessage(result);
                        return;
                    }

                }
                catch (Exception)
                {
                    messageBox.ShowErrorMessage("EXCHANGE_DELETE_MAILBOXPLAN");
                }

                BindMailboxPlans();
            }
        }

        protected void btnSetDefaultMailboxPlan_Click(object sender, EventArgs e)
        {
            // get domain
            int mailboxPlanId = Utils.ParseInt(Request.Form["DefaultMailboxPlan"], 0);

            try
            {
                ES.Services.ExchangeServer.SetOrganizationDefaultExchangeMailboxPlan(PanelRequest.ItemID, mailboxPlanId);

                // rebind domains
                BindMailboxPlans();
            }
            catch (Exception ex)
            {
                ShowErrorMessage("EXCHANGE_SET_DEFAULT_MAILBOXPLAN", ex);
            }
        }
    }
}