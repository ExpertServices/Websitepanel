using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.RemoteDesktopServices;

namespace WebsitePanel.Portal.RDS
{
    public partial class RDSEditApplicationUsers : WebsitePanelModuleBase
    {        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                var applications = ES.Services.RDS.GetCollectionRemoteApplications(PanelRequest.ItemID, collection.Name);
                var remoteApp = applications.Where(x => x.DisplayName.Equals(PanelRequest.ApplicationID, StringComparison.CurrentCultureIgnoreCase)).FirstOrDefault();
                var collectionUsers = ES.Services.RDS.GetRdsCollectionUsers(PanelRequest.CollectionID);
                var applicationUsers = ES.Services.RDS.GetApplicationUsers(PanelRequest.ItemID, PanelRequest.CollectionID, remoteApp);

                locCName.Text = collection.Name;

                users.SetUsers(collectionUsers.Where(x => applicationUsers.Contains(x.SamAccountName)).ToArray());
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                var collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
                var applications = ES.Services.RDS.GetCollectionRemoteApplications(PanelRequest.ItemID, collection.Name);
                var remoteApp = applications.Where(x => x.DisplayName.Equals(PanelRequest.ApplicationID, StringComparison.CurrentCultureIgnoreCase)).FirstOrDefault();
                ES.Services.RDS.SetApplicationUsers(PanelRequest.ItemID, PanelRequest.CollectionID, remoteApp, users.GetUsers().Select(x => x.AccountName).ToArray());

                Response.Redirect(EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "rds_collection_edit_apps", "CollectionId=" + PanelRequest.CollectionID, "ItemID=" + PanelRequest.ItemID));
            }
            catch (Exception)
            {
            }
        }
    }
}