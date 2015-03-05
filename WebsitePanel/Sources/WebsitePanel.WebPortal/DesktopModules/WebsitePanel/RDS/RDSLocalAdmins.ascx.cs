using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.Providers.RemoteDesktopServices;

namespace WebsitePanel.Portal.RDS
{
    public partial class RdsLocalAdmins : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {                
                var collectionLocalAdmins = ES.Services.RDS.GetRdsCollectionLocalAdmins(PanelRequest.CollectionID);
                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);

                litCollectionName.Text = collection.DisplayName;
                users.SetUsers(collectionLocalAdmins);
            }
        }

        private bool SaveLocalAdmins()
        {
            try
            {
                ES.Services.RDS.SaveRdsCollectionLocalAdmins(users.GetUsers(), PanelRequest.CollectionID);
            }
            catch (Exception ex)
            {
                ShowErrorMessage("RDSLOCALADMINS_NOT_ADDED", ex);
                return false;
            }

            return true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            SaveLocalAdmins();
        }

        protected void btnSaveExit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            if (SaveLocalAdmins())
            {
                Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "rds_collections", "SpaceID=" + PanelSecurity.PackageId));
            }
        }
    }
}