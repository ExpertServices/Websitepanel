// Copyright (c) 2011, Outercurve Foundation.
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

namespace WebsitePanel.Portal.Lync
{
    public partial class LyncUserPlans : WebsitePanelModuleBase
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
                BindPlans();
			}

		}

        public string GetPlanDisplayUrl(string LyncUserPlanId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "add_lyncuserplan",
                    "LyncUserPlanId=" + LyncUserPlanId,
                    "ItemID=" + PanelRequest.ItemID);
        }


        private void BindPlans()
        {
            LyncUserPlan[] list = ES.Services.Lync.GetLyncUserPlans(PanelRequest.ItemID);

            gvPlans.DataSource = list;
            gvPlans.DataBind();

            //check if organization has only one default domain
            if (gvPlans.Rows.Count == 1)
            {
                btnSetDefaultPlan.Enabled = false;
            }
        }

        public string IsChecked(bool val)
        {
            return val ? "checked" : "";
        }

        protected void btnAddPlan_Click(object sender, EventArgs e)
        {
            btnSetDefaultPlan.Enabled = true;
            Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "add_lyncuserplan",
                "SpaceID=" + PanelSecurity.PackageId));
        }

        protected void gvPlan_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int planId = Utils.ParseInt(e.CommandArgument.ToString(), 0);

                try
                {
                    int result = ES.Services.Lync.DeleteLyncUserPlan(PanelRequest.ItemID, planId);

                    if (result < 0)
                    {
                        messageBox.ShowResultMessage(result);
                        return;
                    }

                }
                catch (Exception)
                {
                    messageBox.ShowErrorMessage("LYNC_DELETE_PLAN");
                }

                BindPlans();
            }
        }

        protected void btnSetDefaultPlan_Click(object sender, EventArgs e)
        {
            // get domain
            int planId = Utils.ParseInt(Request.Form["DefaultPlan"], 0);

            try
            {
                ES.Services.Lync.SetOrganizationDefaultLyncUserPlan(PanelRequest.ItemID, planId);

                // rebind domains
                BindPlans();
            }
            catch (Exception ex)
            {
                ShowErrorMessage("LYNC_SET_DEFAULT_PLAN", ex);
            }
        }
	}
}