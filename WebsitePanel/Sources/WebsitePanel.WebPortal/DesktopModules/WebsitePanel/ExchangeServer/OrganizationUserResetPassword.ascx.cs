using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class OrganizationUserResetPassword : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSettings();
            }
        }

        private void BindSettings()
        {
            OrganizationUser user = ES.Services.Organizations.GetUserGeneralSettings(PanelRequest.ItemID,
                PanelRequest.AccountID);

            litDisplayName.Text = PortalAntiXSS.Encode(user.DisplayName);

            txtEmailAddress.Text = user.PrimaryEmailAddress;

            txtMobile.Text = user.MobilePhone;
        }

        protected void btnResetPassoword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            if (rbtnEmail.Checked)
            {
                ES.Services.Organizations.SendResetUserPasswordEmail(PanelRequest.ItemID,PanelRequest.AccountID, txtReason.Text, txtEmailAddress.Text);
            }
            else
            {
               var result = ES.Services.Organizations.SendResetUserPasswordLinkSms(PanelRequest.ItemID, PanelRequest.AccountID, txtReason.Text, txtMobile.Text);

                if (!result.IsSuccess)
                {
                    ShowErrorMessage("SEND_USER_PASSWORD_RESET_SMS");

                    return;
                }
            }

            Response.Redirect(PortalUtils.EditUrl("ItemID", PanelRequest.ItemID.ToString(),
                (PanelRequest.Context == "Mailbox") ? "mailboxes" : "users",
                "SpaceID=" + PanelSecurity.PackageId));
        }

        protected void SendToGroupCheckedChanged(object sender, EventArgs e)
        {
            EmailRow.Visible = rbtnEmail.Checked;
            MobileRow.Visible = !rbtnEmail.Checked;
        }
    }
}