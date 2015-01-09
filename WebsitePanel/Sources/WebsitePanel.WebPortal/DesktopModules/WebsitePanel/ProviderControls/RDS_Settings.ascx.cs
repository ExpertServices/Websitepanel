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
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.Common;

namespace WebsitePanel.Portal.ProviderControls
{
    public partial class RDS_Settings : WebsitePanelControlBase, IHostingServiceProviderSettings
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string GWServers
        {
            get
            {
                return ViewState["GWServers"] != null ? ViewState["GWServers"].ToString() : string.Empty;
            }
            set
            {
                ViewState["GWServers"] = value;
            }
        }

        public void BindSettings(System.Collections.Specialized.StringDictionary settings)
        {
            txtConnectionBroker.Text = settings["ConnectionBroker"];

            GWServers = settings["GWServrsList"];

            UpdateLyncServersGrid();

            txtRootOU.Text = settings["RootOU"];
            txtPrimaryDomainController.Text = settings["PrimaryDomainController"];

            if (!string.IsNullOrEmpty(settings["UseCentralNPS"]) && bool.TrueString == settings["UseCentralNPS"])
            {
                chkUseCentralNPS.Checked = true;
                txtCentralNPS.Enabled = true;
                txtCentralNPS.Text = settings["CentralNPS"];
            }
            else
            {
                chkUseCentralNPS.Checked = false;
                txtCentralNPS.Enabled = false;
                txtCentralNPS.Text = string.Empty;
            }
        }

        public void SaveSettings(System.Collections.Specialized.StringDictionary settings)
        {
            settings["ConnectionBroker"] = txtConnectionBroker.Text;
            settings["RootOU"] = txtRootOU.Text;
            settings["PrimaryDomainController"] = txtPrimaryDomainController.Text;
            settings["UseCentralNPS"] = chkUseCentralNPS.Checked.ToString();
            settings["CentralNPS"] = chkUseCentralNPS.Checked ? txtCentralNPS.Text : string.Empty;

            settings["GWServrsList"] = GWServers;	
        }

        protected void chkUseCentralNPS_CheckedChanged(object sender, EventArgs e)
        {
            txtCentralNPS.Enabled = chkUseCentralNPS.Checked;
            txtCentralNPS.Text = chkUseCentralNPS.Checked ? txtCentralNPS.Text : string.Empty;
        }

        protected void btnAddGWServer_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(GWServers))
                GWServers += ";";

            GWServers += txtAddGWServer.Text;

            txtAddGWServer.Text = string.Empty;

            UpdateLyncServersGrid();
        }

        public List<GWServer> GetServices(string data)
        {
            if (string.IsNullOrEmpty(data))
                return null;
            List<GWServer> list = new List<GWServer>();
            string[] serversNames = data.Split(';');
            foreach (string current in serversNames)
            {
                list.Add(new GWServer { ServerName = current });
            }

            return list;
        }

        private void UpdateLyncServersGrid()
        {
            gvGWServers.DataSource = GetServices(GWServers);
            gvGWServers.DataBind();
        }

        protected void gvGWServers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveServer")
            {
                string str = string.Empty;
                List<GWServer> servers = GetServices(GWServers);
                foreach (GWServer current in servers)
                {
                    if (current.ServerName == e.CommandArgument.ToString())
                        continue;

                    str += current.ServerName + ";";
                }

                GWServers = str.TrimEnd(';');
                UpdateLyncServersGrid();
            }
        }
    }

    public class GWServer
    {
        public string ServerName { get; set; }
    }
}
