using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal.RDS
{
    public partial class RDSSeupLetter : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindInstructions();
            }
        }

        private void BindInstructions()
        {            
            int accountId = PanelRequest.AccountID > 0 ? PanelRequest.AccountID : 0;   
            litContent.Text = ES.Services.RDS.GetRdsSetupLetter(PanelRequest.ItemID, accountId);
            PackageInfo package = ES.Services.Packages.GetPackage(PanelSecurity.PackageId);

            if (package == null)
            {
                RedirectSpaceHomePage();
            }

            OrganizationUser account = ES.Services.Organizations.GetUserGeneralSettings(PanelRequest.ItemID, accountId);

            if (account != null)
            {
                txtTo.Text = account.ExternalEmail;
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                int accountId = PanelRequest.AccountID > 0 ? PanelRequest.AccountID : 0;   
                int result = ES.Services.RDS.SendRdsSetupLetter(PanelRequest.ItemID, accountId, txtTo.Text.Trim(), txtCC.Text.Trim());

                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }

                messageBox.ShowSuccessMessage("RDS_SETUP_LETTER_SEND");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("RDS_SETUP_LETTER_SEND", ex);
                return;
            }
        }
    }
}