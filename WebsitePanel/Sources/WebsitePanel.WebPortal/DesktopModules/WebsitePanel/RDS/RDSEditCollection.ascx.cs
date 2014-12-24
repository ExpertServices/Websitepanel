using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.RemoteDesktopServices;

namespace WebsitePanel.Portal.RDS
{
    public partial class RDSEditCollection : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                if (servers.GetServers().Count < 1)
                {
                    messageBox.ShowErrorMessage("RDS_CREATE_COLLECTION_RDSSERVER_REQUAIRED");
                    return;
                }
                
                RdsCollection collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                collection.Servers = servers.GetServers();

                ES.Services.RDS.EditRdsCollection(PanelRequest.ItemID, collection);

                Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "rds_collections",
                    "SpaceID=" + PanelSecurity.PackageId));
            }
            catch { }
        }
    }
}