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

﻿using System;
using System.Collections.Generic;
﻿using System.Collections.Specialized;
﻿using System.Linq;
﻿using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.Common;
using WebsitePanel.Providers.Virtualization;

namespace WebsitePanel.Portal.VPS2012
{
    public partial class VpsDetailsReplications : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind();
            }

            Toogle();
        }

        private void Toogle()
        {
            ReplicaTable.Visible = chbEnable.Checked;

            switch (radRecoveryPoints.SelectedValue)
            {
                case "OnlyLast":
                    tabAdditionalRecoveryPoints.Visible = false;
                    break;
                case "Additional":
                    tabAdditionalRecoveryPoints.Visible = true;
                    VSSdiv.Visible = chbVSS.Checked;
                    break;
            }
        }

        private void Bind()
        {
            try
            {
                const string na = "n/a";

                var packageVm = ES.Services.VPS2012.GetVirtualMachineItem(PanelRequest.ItemID);
                var vm = ES.Services.VPS2012.GetVirtualMachineExtendedInfo(packageVm.ServiceId, packageVm.VirtualMachineId);
                var serviceSettings = ConvertArrayToDictionary(ES.Services.Servers.GetServiceSettings(packageVm.ServiceId));

                //var replicaMode = Enum.Parse(typeof(ReplicaMode), serviceSettings["ReplicaMode"]);
                var computerName = serviceSettings["ServerName"];

                var vmReplica = ES.Services.VPS2012.GetReplication(PanelRequest.ItemID);
                var vmReplicaInfo = ES.Services.VPS2012.GetReplicationInfo(PanelRequest.ItemID);

                // Enable checkpoint
                chbEnable.Checked = ReplicaTable.Visible = vmReplica != null;

                // General labels
                if (vmReplicaInfo != null)
                {
                    labPrimaryServer.Text = vmReplicaInfo.PrimaryServerName;
                    labReplicaServer.Text = vmReplicaInfo.ReplicaServerName;
                    labLastSynchronized.Text = vmReplicaInfo.LastSynhronizedAt.ToShortTimeString();
                }
                else
                {
                    labPrimaryServer.Text = labReplicaServer.Text = labLastSynchronized.Text = na;
                }

                // Certificates list
                var certificates = ES.Services.VPS2012.GetCertificates(packageVm.ServiceId, computerName);
                foreach (var cert in certificates)
                {
                    ddlCeritficate.Items.Add(new ListItem(cert.Title, cert.Thumbprint));
                }
                if (!string.IsNullOrEmpty(computerName))
                {
                    ddlCeritficateDiv.Visible = true;
                    txtCeritficateDiv.Visible = false;
                }
                else
                {
                    ddlCeritficateDiv.Visible = true;
                    txtCeritficateDiv.Visible = false;
                }

                // VHDs editable
                trVHDEditable.Visible = true;
                trVHDReadOnly.Visible = false; 
                chlVHDs.Items.Clear();
                chlVHDs.Items.AddRange(vm.Disks.Select(d => new ListItem(d.Path) {Selected = true}).ToArray());

                if (vmReplica != null)
                {
                    // VHDs readonly
                    labVHDs.Text = "";
                    foreach (var disk in vm.Disks)
                    {
                        if (string.Equals(vmReplica.VhdToReplicate, disk.Path, StringComparison.OrdinalIgnoreCase))
                            labVHDs.Text += disk.Path + "<br>";
                    }
                    trVHDEditable.Visible = false;
                    trVHDReadOnly.Visible = true;

                    // Certificates
                    ddlCeritficate.SelectedValue = txtCeritficate.Text = vmReplica.Thumbprint;

                    // Frequency
                    ddlFrequency.SelectedValue = ((int) vmReplica.ReplicaFrequency).ToString();

                    // Recovery points
                    if (vmReplica.AdditionalRecoveryPoints == 0)
                    {
                        radRecoveryPoints.SelectedValue = "OnlyLast";
                        tabAdditionalRecoveryPoints.Visible = false;
                    }
                    else
                    {
                        radRecoveryPoints.SelectedValue = "Additional";
                        tabAdditionalRecoveryPoints.Visible = true;
                        txtRecoveryPointsAdditional.Text = vmReplica.AdditionalRecoveryPoints.ToString();

                        // VSS
                        if (vmReplica.VSSSnapshotFrequencyHour == 0)
                        {
                            chbVSS.Checked = false;
                            VSSdiv.Visible = false;
                        }
                        else
                        {
                            chbVSS.Checked = true;
                            VSSdiv.Visible = true;
                            txtRecoveryPointsVSS.Text = vmReplica.VSSSnapshotFrequencyHour.ToString();
                        }
                    }
                }

                secReplicationDetails.Visible = ReplicationDetailsPanel.Visible = vmReplica != null;
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("VPS_ERROR_GET_VM_REPLICATION", ex);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (chbEnable.Checked)
                SetReplication();
            else
                DisableReplication();
        }

        private void SetReplication()
        {
            var vmReplica = new VmReplication();

            vmReplica.VhdToReplicate = chlVHDs.Items.Cast<ListItem>()
                .Where(li => li.Selected)
                .Select(li => li.Value)
                .ToList()
                .FirstOrDefault();

            vmReplica.Thumbprint = ddlCeritficateDiv.Visible ? ddlCeritficate.SelectedValue : txtCeritficate.Text;
            vmReplica.ReplicaFrequency = (ReplicaFrequency) Convert.ToInt32(ddlFrequency.SelectedValue);
            vmReplica.AdditionalRecoveryPoints = radRecoveryPoints.SelectedValue == "OnlyLast" ? 0 : Convert.ToInt32(txtRecoveryPointsAdditional.Text);
            vmReplica.VSSSnapshotFrequencyHour = chbVSS.Checked ? Convert.ToInt32(txtRecoveryPointsVSS.Text) : 0;

            try
            {
                ResultObject res = ES.Services.VPS2012.SetVmReplication(PanelRequest.ItemID, vmReplica);

                if (res.IsSuccess)
                    Bind();
                else
                    messageBox.ShowMessage(res, "VPS_ERROR_SET_VM_REPLICATION", "VPS");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("VPS_ERROR_SET_VM_REPLICATION", ex);
            }
        }

        private void DisableReplication()
        {
            try
            {
                ResultObject res = ES.Services.VPS2012.DisableVmReplication(PanelRequest.ItemID);

                if (res.IsSuccess)
                    Bind();
                else
                    messageBox.ShowMessage(res, "VPS_ERROR_DISABLE_VM_REPLICATION", "VPS");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("VPS_ERROR_DISABLE_VM_REPLICATION", ex);
            }
        }

        private StringDictionary ConvertArrayToDictionary(string[] settings)
        {
            StringDictionary r = new StringDictionary();
            foreach (string setting in settings)
            {
                int idx = setting.IndexOf('=');
                r.Add(setting.Substring(0, idx), setting.Substring(idx + 1));
            }
            return r;
        }
    }
}
