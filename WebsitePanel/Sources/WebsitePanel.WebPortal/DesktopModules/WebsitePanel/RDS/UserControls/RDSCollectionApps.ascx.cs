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
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;
using System.Linq;
using WebsitePanel.Providers.Web;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.Providers.RemoteDesktopServices;

namespace WebsitePanel.Portal.RDS.UserControls
{
    public partial class RDSCollectionApps : WebsitePanelControlBase
	{
        public const string DirectionString = "DirectionString";

		protected enum SelectedState
		{
			All,
			Selected,
			Unselected
		}

        public void SetApps(RemoteApplication[] apps)
		{
            BindApps(apps, false);
		}

        public void SetApps(RemoteApplication[] apps, WebPortal.PageModule module)
        {
            Module = module;
            BindApps(apps, false);            
        }

        public RemoteApplication[] GetApps()
        {
            return GetGridViewApps(SelectedState.All).ToArray();
        }

		protected void Page_Load(object sender, EventArgs e)
		{
			// register javascript
			if (!Page.ClientScript.IsClientScriptBlockRegistered("SelectAllCheckboxes"))
			{
				string script = @"    function SelectAllCheckboxes(box)
                {
		            var state = box.checked;
                    var elm = box.parentElement.parentElement.parentElement.parentElement.getElementsByTagName(""INPUT"");
                    for(i = 0; i < elm.length; i++)
                        if(elm[i].type == ""checkbox"" && elm[i].id != box.id && elm[i].checked != state && !elm[i].disabled)
		                    elm[i].checked = state;
                }";
                Page.ClientScript.RegisterClientScriptBlock(typeof(RDSCollectionUsers), "SelectAllCheckboxes",
					script, true);
			}
		}

		protected void btnAdd_Click(object sender, EventArgs e)
		{
			// bind all servers
			BindPopupApps();

			// show modal
			AddAppsModal.Show();
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
            List<RemoteApplication> selectedApps = GetGridViewApps(SelectedState.Unselected);

            BindApps(selectedApps.ToArray(), false);
		}

		protected void btnAddSelected_Click(object sender, EventArgs e)
		{
            List<RemoteApplication> selectedApps = GetPopUpGridViewApps();

            BindApps(selectedApps.ToArray(), true);

		}

        protected void BindPopupApps()
		{
            RdsCollection collection = ES.Services.RDS.GetRdsCollection(PanelRequest.CollectionID);
            StartMenuApp[] apps = ES.Services.RDS.GetAvailableRemoteApplications(PanelRequest.ItemID, collection.Name);

            apps = apps.Where(x => !GetApps().Select(p => p.DisplayName).Contains(x.DisplayName)).ToArray();
            Array.Sort(apps, CompareAccount);
            if (Direction == SortDirection.Ascending)
            {
                Array.Reverse(apps);
                Direction = SortDirection.Descending;
            }
            else
                Direction = SortDirection.Ascending;

            gvPopupApps.DataSource = apps;
            gvPopupApps.DataBind();
		}

        protected void BindApps(RemoteApplication[] newApps, bool preserveExisting)
		{
			// get binded addresses
            List<RemoteApplication> apps = new List<RemoteApplication>();
			if(preserveExisting)
                apps.AddRange(GetGridViewApps(SelectedState.All));

            // add new servers
            if (newApps != null)
			{
                foreach (RemoteApplication newApp in newApps)
				{
					// check if exists
					bool exists = false;
                    foreach (RemoteApplication app in apps)
					{
                        if (app.DisplayName == newApp.DisplayName)
						{
							exists = true;
							break;
						}
					}

					if (exists)
						continue;

                    apps.Add(newApp);
				}
			}

            gvApps.DataSource = apps;
            gvApps.DataBind();
		}

        protected List<RemoteApplication> GetGridViewApps(SelectedState state)
        {
            List<RemoteApplication> apps = new List<RemoteApplication>();
            for (int i = 0; i < gvApps.Rows.Count; i++)
            {
                GridViewRow row = gvApps.Rows[i];
                CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");
                if (chkSelect == null)
                    continue;

                RemoteApplication app = new RemoteApplication();
                app.Alias = (string)gvApps.DataKeys[i][0];
                app.DisplayName = ((Literal)row.FindControl("litDisplayName")).Text;
                app.FilePath = ((HiddenField)row.FindControl("hfFilePath")).Value;

                if (state == SelectedState.All ||
                    (state == SelectedState.Selected && chkSelect.Checked) ||
                    (state == SelectedState.Unselected && !chkSelect.Checked))
                    apps.Add(app);
            }

            return apps;
        }

        protected List<RemoteApplication> GetPopUpGridViewApps()
        {
            List<RemoteApplication> apps = new List<RemoteApplication>();
            for (int i = 0; i < gvPopupApps.Rows.Count; i++)
            {
                GridViewRow row = gvPopupApps.Rows[i];
                CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");
                if (chkSelect == null)
                    continue;

                if (chkSelect.Checked)
                {
                    apps.Add(new RemoteApplication
                    {
                        Alias = (string)gvPopupApps.DataKeys[i][0],
                        DisplayName = ((Literal)row.FindControl("litName")).Text,
                        FilePath = ((HiddenField)row.FindControl("hfFilePathPopup")).Value
                    });
                }
            }

            return apps;

        }

		protected void cmdSearch_Click(object sender, ImageClickEventArgs e)
		{
			BindPopupApps();
		}

        protected SortDirection Direction
        {
            get { return ViewState[DirectionString] == null ? SortDirection.Descending : (SortDirection)ViewState[DirectionString]; }
            set { ViewState[DirectionString] = value; }
        }

        protected static int CompareAccount(StartMenuApp app1, StartMenuApp app2)
        {
            return string.Compare(app1.DisplayName, app2.DisplayName);
        }

        public string GetCollectionUsersEditUrl(string appId)
        {
            return EditUrl("SpaceID", PanelSecurity.PackageId.ToString(), "rds_application_edit_users",
                    "CollectionId=" + PanelRequest.CollectionID, "ItemID=" + PanelRequest.ItemID, "ApplicationID=" + appId);
        }
	}
}
