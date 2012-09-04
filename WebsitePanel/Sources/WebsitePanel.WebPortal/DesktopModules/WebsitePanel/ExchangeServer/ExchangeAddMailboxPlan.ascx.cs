// Copyright (c) 2011, Outercurve Foundation.
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
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.Providers.ResultObjects;

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class ExchangeAddMailboxPlan : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                PackageContext cntx = ES.Services.Packages.GetPackageContext(PanelSecurity.PackageId);

                if (PanelRequest.GetInt("MailboxPlanId") != 0)
                {
                    Providers.HostedSolution.ExchangeMailboxPlan plan = ES.Services.ExchangeServer.GetExchangeMailboxPlan(PanelRequest.ItemID, PanelRequest.GetInt("MailboxPlanId"));
                    txtMailboxPlan.Text = plan.MailboxPlan;
                    mailboxSize.QuotaValue = plan.MailboxSizeMB;
                    maxRecipients.QuotaValue = plan.MaxRecipients;
                    maxSendMessageSizeKB.QuotaValue = plan.MaxSendMessageSizeKB;
                    maxReceiveMessageSizeKB.QuotaValue = plan.MaxReceiveMessageSizeKB;
                    chkPOP3.Checked = plan.EnablePOP;
                    chkIMAP.Checked = plan.EnableIMAP;
                    chkOWA.Checked = plan.EnableOWA;
                    chkMAPI.Checked = plan.EnableMAPI;
                    chkActiveSync.Checked = plan.EnableActiveSync;
                    sizeIssueWarning.ValueKB = plan.IssueWarningPct;
                    sizeProhibitSend.ValueKB = plan.ProhibitSendPct;
                    sizeProhibitSendReceive.ValueKB = plan.ProhibitSendReceivePct;
                    daysKeepDeletedItems.ValueDays = plan.KeepDeletedItemsDays;
                    chkHideFromAddressBook.Checked = plan.HideFromAddressBook;

                    /*
                    txtMailboxPlan.Enabled = false;
                    mailboxSize.Enabled = false;
                    maxRecipients.Enabled = false;
                    maxSendMessageSizeKB.Enabled = false;
                    maxReceiveMessageSizeKB.Enabled = false;
                    chkPOP3.Enabled = false;
                    chkIMAP.Enabled = false;
                    chkOWA.Enabled = false;
                    chkMAPI.Enabled = false;
                    chkActiveSync.Enabled = false;
                    sizeIssueWarning.Enabled = false;
                    sizeProhibitSend.Enabled = false;
                    sizeProhibitSendReceive.Enabled = false;
                    daysKeepDeletedItems.Enabled = false;
                    chkHideFromAddressBook.Enabled = false;

                    btnAdd.Enabled = false;
                     */

                    locTitle.Text = plan.MailboxPlan;
                    this.DisableControls = true;

                }
                else
                {

                    if (cntx != null)
                    {
                        foreach (QuotaValueInfo quota in cntx.QuotasArray)
                        {
                            switch (quota.QuotaId)
                            {
                                case 77:
                                    break;
                                case 365:
                                    if (quota.QuotaAllocatedValue != -1)
                                    {
                                        maxRecipients.QuotaValue = quota.QuotaAllocatedValue;
                                    }
                                    break;
                                case 366:
                                    if (quota.QuotaAllocatedValue != -1)
                                    {
                                        maxSendMessageSizeKB.QuotaValue = quota.QuotaAllocatedValue;
                                    }
                                    break;
                                case 367:
                                    if (quota.QuotaAllocatedValue != -1)
                                    {
                                        maxReceiveMessageSizeKB.QuotaValue = quota.QuotaAllocatedValue;
                                    }
                                    break;
                                case 83:
                                    chkPOP3.Checked = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    chkPOP3.Enabled = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    break;
                                case 84:
                                    chkIMAP.Checked = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    chkIMAP.Enabled = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    break;
                                case 85:
                                    chkOWA.Checked = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    chkOWA.Enabled = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    break;
                                case 86:
                                    chkMAPI.Checked = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    chkMAPI.Enabled = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    break;
                                case 87:
                                    chkActiveSync.Checked = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    chkActiveSync.Enabled = Convert.ToBoolean(quota.QuotaAllocatedValue);
                                    break;
                                case 364:
                                    daysKeepDeletedItems.ValueDays = quota.QuotaAllocatedValue;
                                    daysKeepDeletedItems.RequireValidatorEnabled = true;
                                    break;
                            }

                            sizeIssueWarning.ValueKB = 100;
                            sizeProhibitSend.ValueKB = 100;
                            sizeProhibitSendReceive.ValueKB = 100;
                        }
                    }
                    else
                        this.DisableControls = true;
                }
            }

        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            AddMailboxPlan();
        }

        private void AddMailboxPlan()
        {
            try
            {
                Providers.HostedSolution.ExchangeMailboxPlan plan = new Providers.HostedSolution.ExchangeMailboxPlan();
                plan.MailboxPlan = txtMailboxPlan.Text;

                plan.MailboxSizeMB = mailboxSize.QuotaValue;

                plan.IsDefault = false;
                plan.MaxRecipients = maxRecipients.QuotaValue;
                plan.MaxSendMessageSizeKB = maxSendMessageSizeKB.QuotaValue;
                plan.MaxReceiveMessageSizeKB = maxReceiveMessageSizeKB.QuotaValue; 
                plan.EnablePOP = chkPOP3.Checked;
                plan.EnableIMAP = chkIMAP.Checked;
                plan.EnableOWA = chkOWA.Checked;
                plan.EnableMAPI = chkMAPI.Checked;
                plan.EnableActiveSync = chkActiveSync.Checked;
                plan.IssueWarningPct = sizeIssueWarning.ValueKB;
                if ((plan.IssueWarningPct == 0)) plan.IssueWarningPct = 100;
                plan.ProhibitSendPct = sizeProhibitSend.ValueKB;
                if ((plan.ProhibitSendPct == 0)) plan.ProhibitSendPct = 100;
                plan.ProhibitSendReceivePct = sizeProhibitSendReceive.ValueKB;
                if ((plan.ProhibitSendReceivePct == 0)) plan.ProhibitSendReceivePct = 100;
                plan.KeepDeletedItemsDays = daysKeepDeletedItems.ValueDays;
                plan.HideFromAddressBook = chkHideFromAddressBook.Checked;

                int result = ES.Services.ExchangeServer.AddExchangeMailboxPlan(PanelRequest.ItemID,
                                                                                plan);


                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }

                Response.Redirect(EditUrl("ItemID", PanelRequest.ItemID.ToString(), "mailboxplans",
                    "SpaceID=" + PanelSecurity.PackageId));
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("EXCHANGE_ADD_MAILBOXPLAN", ex);
            }
        }
    }
}