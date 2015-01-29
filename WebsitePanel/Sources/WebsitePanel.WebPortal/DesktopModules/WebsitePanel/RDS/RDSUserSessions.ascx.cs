using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.RemoteDesktopServices;

namespace WebsitePanel.Portal.RDS
{
    public partial class RDSUserSessions : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            buttonPanel.ButtonSaveVisible = false;            
      
            if (!IsPostBack)
            {
                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                litCollectionName.Text = collection.Name;
                BindGrid();
            }
        }

        protected void gvRDSCollections_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "LogOff")
            {
                var arguments = e.CommandArgument.ToString().Split(';');
                string unifiedSessionId = arguments[0];
                string hostServer = arguments[1];

                try
                {
                    ES.Services.RDS.LogOffRdsUser(PanelRequest.ItemID, unifiedSessionId, hostServer);                    
                    BindGrid();

                }
                catch (Exception ex)
                {
                    ShowErrorMessage("REMOTE_DESKTOP_SERVICES_LOG_OFF_USER", ex);
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }
        }

        protected void btnSaveExit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "rds_collections", "SpaceID=" + PanelSecurity.PackageId));
        }

        private void BindGrid()
        {
            var userSessions = new List<RdsUserSession>();

            try
            {
                userSessions = ES.Services.RDS.GetRdsUserSessions(PanelRequest.CollectionID).ToList();
            }
            catch(Exception ex)
            {
                ShowErrorMessage("REMOTE_DESKTOP_SERVICES_USER_SESSIONS", ex);
            }

            gvRDSUserSessions.DataSource = userSessions;
            gvRDSUserSessions.DataBind();
        }
    }
}