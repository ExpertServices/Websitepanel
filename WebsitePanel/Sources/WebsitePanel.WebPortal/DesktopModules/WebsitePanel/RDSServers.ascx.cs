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
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.Common;
using AjaxControlToolkit;

namespace WebsitePanel.Portal
{
    public partial class RDSServers : WebsitePanelModuleBase
	{
		protected void Page_Load(object sender, EventArgs e)
		{            
			if (!IsPostBack)
			{
                gvRDSServers.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);
                gvRDSServers.Sort("Name", System.Web.UI.WebControls.SortDirection.Ascending);
			}
        }

        protected void odsRDSServersPaged_Selected(object sender, ObjectDataSourceStatusEventArgs e)
		{
			if (e.Exception != null)
			{
				ProcessException(e.Exception.InnerException);
				this.DisableControls = true;
				e.ExceptionHandled = true;
			}
		}

        protected void btnAddRDSServer_Click(object sender, EventArgs e)
		{
            Response.Redirect(EditUrl("add_rdsserver"));
		}

        protected void gvRDSServers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                // delete rds server
                int rdsServerId;
                bool hasValue = int.TryParse(e.CommandArgument.ToString(), out rdsServerId);

                ResultObject result = new ResultObject();
                result.IsSuccess = false;

                try
                {
                    if (hasValue)
                    {
                        result = ES.Services.RDS.RemoveRdsServer(rdsServerId);
                    }

                    ((ModalPopupExtender)asyncTasks.FindControl("ModalPopupProperties")).Hide();

                    if (!result.IsSuccess)
                    {
                        messageBox.ShowMessage(result, "REMOTE_DESKTOP_SERVICES_REMOVE_RDSSERVER", "RDS");
                        return;
                    }

                    gvRDSServers.DataBind();
                }
                catch (Exception ex)
                {
                    ShowErrorMessage("REMOTE_DESKTOP_SERVICES_REMOVE_RDSSERVER", ex);
                }
            }
            else if (e.CommandName == "ViewInfo")
            {
                try
                {
                    ShowInfo(e.CommandArgument.ToString());
                }
                catch (Exception)
                {
                }
            }
            else if (e.CommandName == "Restart")
            {
                Restart(e.CommandArgument.ToString());
            }
            else if (e.CommandName == "ShutDown")
            {
                ShutDown(e.CommandArgument.ToString());
            }
            else if (e.CommandName == "InstallCertificate")
            {
                InstallCertificate(e.CommandArgument.ToString());
            }
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvRDSServers.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);

            gvRDSServers.DataBind();
        }

        private void ShowInfo(string serverId)
        {
            ViewInfoModal.Show();
            var rdsServer = ES.Services.RDS.GetRdsServer(Convert.ToInt32(serverId));
            var serverInfo = ES.Services.RDS.GetRdsServerInfo(null, rdsServer.FqdName);
            litProcessor.Text = string.Format("{0}x{1} MHz", serverInfo.NumberOfCores, serverInfo.MaxClockSpeed);
            litLoadPercentage.Text = string.Format("{0}%", serverInfo.LoadPercentage);
            litMemoryAllocated.Text = string.Format("{0} MB", serverInfo.MemoryAllocatedMb);
            litFreeMemory.Text = string.Format("{0} MB", serverInfo.FreeMemoryMb);
            rpServerDrives.DataSource = serverInfo.Drives;
            rpServerDrives.DataBind();
            ((ModalPopupExtender)asyncTasks.FindControl("ModalPopupProperties")).Hide();
        }

        private void Restart(string serverId)
        {
            var rdsServer = ES.Services.RDS.GetRdsServer(Convert.ToInt32(serverId));
            ES.Services.RDS.RestartRdsServer(null, rdsServer.FqdName);
            Response.Redirect(Request.Url.ToString(), true);
        }

        private void ShutDown(string serverId)
        {
            var rdsServer = ES.Services.RDS.GetRdsServer(Convert.ToInt32(serverId));
            ES.Services.RDS.ShutDownRdsServer(null, rdsServer.FqdName);
            Response.Redirect(Request.Url.ToString(), true);
        }

        private void RefreshServerInfo()
        {
            var servers = odsRDSServersPaged.Select();
            gvRDSServers.DataSource = servers;
            gvRDSServers.DataBind();
            ((ModalPopupExtender)asyncTasks.FindControl("ModalPopupProperties")).Hide();
        }

        private void InstallCertificate(string serverId)
        {
            var rdsServer = ES.Services.RDS.GetRdsServer(Convert.ToInt32(serverId));            

            try
            {
                ES.Services.RDS.InstallSessionHostsCertificate(rdsServer);
                ((ModalPopupExtender)asyncTasks.FindControl("ModalPopupProperties")).Hide();
                ShowSuccessMessage("RDSSESSIONHOST_CERTIFICATE_INSTALLED");
            }
            catch(Exception ex)
            {
                ShowErrorMessage("RDSSESSIONHOST_CERTIFICATE_NOT_INSTALLED", ex);
            }

            messageBoxPanel.Update();
//            Response.Redirect(Request.Url.ToString(), true);
        }
	}
}
