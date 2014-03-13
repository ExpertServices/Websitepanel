// Copyright (c) 2012, Outercurve Foundation.
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
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Xml;
using System.Xml.Serialization;

using System.Collections.Generic;
using System.Collections.ObjectModel;

using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal
{
    public partial class SettingsExchangeMailboxPlansPolicy : WebsitePanelControlBase, IUserSettingsEditorControl
    {

        public void BindSettings(UserSettings settings)
        {
            BindMailboxPlans();
            
            txtStatus.Visible = false;
        }


        private void BindMailboxPlans()
        {
            Providers.HostedSolution.Organization[] orgs = null;

            if (PanelSecurity.SelectedUserId != 1)
            {
                PackageInfo[] Packages = ES.Services.Packages.GetPackages(PanelSecurity.SelectedUserId);

                if ((Packages != null) & (Packages.GetLength(0) > 0))
                {
                    orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Packages[0].PackageId, false);
                }
            }
            else
            {
                orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, false);
            }

            if ((orgs != null) & (orgs.GetLength(0) > 0))
            {
                ExchangeMailboxPlan[] list = ES.Services.ExchangeServer.GetExchangeMailboxPlans(orgs[0].Id, false);

                gvMailboxPlans.DataSource = list;
                gvMailboxPlans.DataBind();
            }

            btnUpdateMailboxPlan.Enabled = (string.IsNullOrEmpty(txtMailboxPlan.Text)) ? false : true;
        }


        public void btnAddMailboxPlan_Click(object sender, EventArgs e)
        {
            Page.Validate("CreateMailboxPlan");

            if (!Page.IsValid)
                return;
                        
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
            plan.AllowLitigationHold = chkEnableLitigationHold.Checked;
            plan.RecoverableItemsSpace = recoverableItemsSpace.QuotaValue;
            plan.RecoverableItemsWarningPct = recoverableItemsWarning.ValueKB;
            if ((plan.RecoverableItemsWarningPct == 0)) plan.RecoverableItemsWarningPct = 100;
            plan.LitigationHoldMsg = txtLitigationHoldMsg.Text.Trim();
            plan.LitigationHoldUrl = txtLitigationHoldUrl.Text.Trim(); 


            if (PanelSecurity.SelectedUser.Role == UserRole.Administrator)
                plan.MailboxPlanType = (int)ExchangeMailboxPlanType.Administrator;
            else
                if (PanelSecurity.SelectedUser.Role == UserRole.Reseller)
                    plan.MailboxPlanType = (int)ExchangeMailboxPlanType.Reseller;

            Providers.HostedSolution.Organization[] orgs = null;

            if (PanelSecurity.SelectedUserId != 1)
            {
                PackageInfo[] Packages = ES.Services.Packages.GetPackages(PanelSecurity.SelectedUserId);

                if ((Packages != null) & (Packages.GetLength(0) > 0))
                {
                    orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Packages[0].PackageId, false);
                }
            }
            else
            {
                orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, false);
            }


            if ((orgs != null) & (orgs.GetLength(0) > 0))
            {
                int result = ES.Services.ExchangeServer.AddExchangeMailboxPlan(orgs[0].Id, plan);

                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }
            }

            BindMailboxPlans();

        }

        protected void gvMailboxPlan_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int mailboxPlanId = Utils.ParseInt(e.CommandArgument.ToString(), 0);
            Providers.HostedSolution.Organization[] orgs = null;
            Providers.HostedSolution.ExchangeMailboxPlan plan;

            switch (e.CommandName)
            {
                case "DeleteItem":
                    try
                    {

                        if (PanelSecurity.SelectedUserId != 1)
                        {
                            PackageInfo[] Packages = ES.Services.Packages.GetPackages(PanelSecurity.SelectedUserId);

                            if ((Packages != null) & (Packages.GetLength(0) > 0))
                            {
                                orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Packages[0].PackageId, false);
                            }
                        }
                        else
                        {
                            orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, false);
                        }

                        plan = ES.Services.ExchangeServer.GetExchangeMailboxPlan(orgs[0].Id, mailboxPlanId);

                        if (plan.ItemId != orgs[0].Id)
                        {
                            messageBox.ShowErrorMessage("EXCHANGE_UNABLE_USE_SYSTEMPLAN");
                            BindMailboxPlans();
                            return;
                        }


                        int result = ES.Services.ExchangeServer.DeleteExchangeMailboxPlan(orgs[0].Id, mailboxPlanId);
                        if (result < 0)
                        {
                            messageBox.ShowResultMessage(result);
                            return;
                        }
                        ViewState["MailboxPlanID"] = null; 

                        txtMailboxPlan.Text = string.Empty;
                        mailboxSize.QuotaValue = 0;
                        maxRecipients.QuotaValue = 0;
                        maxSendMessageSizeKB.QuotaValue = 0;
                        maxReceiveMessageSizeKB.QuotaValue = 0;
                        chkPOP3.Checked = false;
                        chkIMAP.Checked = false;
                        chkOWA.Checked = false;
                        chkMAPI.Checked = false;
                        chkActiveSync.Checked = false;
                        sizeIssueWarning.ValueKB = -1;
                        sizeProhibitSend.ValueKB = -1;
                        sizeProhibitSendReceive.ValueKB = -1;
                        daysKeepDeletedItems.ValueDays = -1;
                        chkHideFromAddressBook.Checked = false;
                        chkEnableLitigationHold.Checked = false;
                        recoverableItemsSpace.QuotaValue = 0;
                        recoverableItemsWarning.ValueKB = -1;
                        txtLitigationHoldMsg.Text = string.Empty;
                        txtLitigationHoldUrl.Text = string.Empty;



                        btnUpdateMailboxPlan.Enabled = (string.IsNullOrEmpty(txtMailboxPlan.Text)) ? false : true;

                    }
                    catch (Exception)
                    {
                        messageBox.ShowErrorMessage("EXCHANGE_DELETE_MAILBOXPLAN");
                    }

                    BindMailboxPlans();
                break;

                case "EditItem":
                        ViewState["MailboxPlanID"] = mailboxPlanId;

                        if (PanelSecurity.SelectedUserId != 1)
                        {
                            PackageInfo[] Packages = ES.Services.Packages.GetPackages(PanelSecurity.SelectedUserId);

                            if ((Packages != null) & (Packages.GetLength(0) > 0))
                            {
                                orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Packages[0].PackageId, false);
                            }
                        }
                        else
                        {
                            orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, false);
                        }


                        plan = ES.Services.ExchangeServer.GetExchangeMailboxPlan(orgs[0].Id, mailboxPlanId);
                    
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
                        if (plan.KeepDeletedItemsDays != -1)
                            daysKeepDeletedItems.ValueDays = plan.KeepDeletedItemsDays;
                        chkHideFromAddressBook.Checked = plan.HideFromAddressBook;
                        chkEnableLitigationHold.Checked = plan.AllowLitigationHold;
                        recoverableItemsSpace.QuotaValue = plan.RecoverableItemsSpace;
                        recoverableItemsWarning.ValueKB = plan.RecoverableItemsWarningPct;
                        txtLitigationHoldMsg.Text = plan.LitigationHoldMsg;
                        txtLitigationHoldUrl.Text = plan.LitigationHoldUrl;
                        
                        btnUpdateMailboxPlan.Enabled  = (string.IsNullOrEmpty(txtMailboxPlan.Text)) ? false : true;

                    break;
                case "RestampItem":
                    RestampMailboxes(mailboxPlanId, mailboxPlanId);
                    break;
                case "StampUnassigned":
                    RestampMailboxes(-1, mailboxPlanId);
                    break;

            }
        }


        public string GetPlanType(int mailboxPlanType)
        {
            string imgName = string.Empty;

            ExchangeMailboxPlanType planType = (ExchangeMailboxPlanType)mailboxPlanType;
            switch (planType)
            {
                case ExchangeMailboxPlanType.Reseller:
                    imgName = "company24.png";
                    break;
                case ExchangeMailboxPlanType.Administrator:
                    imgName = "company24.png";
                    break;
                default:
                    imgName = "admin_16.png";
                    break;
            }

            return GetThemedImage("Exchange/" + imgName);
        }


        public void SaveSettings(UserSettings settings)
        {
            settings["ExchangeMailboxPlansPolicy"] = "";
        }


        protected void btnUpdateMailboxPlan_Click(object sender, EventArgs e)
        {

            if (ViewState["MailboxPlanID"] == null)
                return;

            int mailboxPlanId = (int)ViewState["MailboxPlanID"];
            Providers.HostedSolution.Organization[] orgs = null;
            Providers.HostedSolution.ExchangeMailboxPlan plan;


            if (PanelSecurity.SelectedUserId != 1)
            {
                PackageInfo[] Packages = ES.Services.Packages.GetPackages(PanelSecurity.SelectedUserId);

                if ((Packages != null) & (Packages.GetLength(0) > 0))
                {
                    orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Packages[0].PackageId, false);
                }
            }
            else
            {
                orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, false);
            }

            plan = ES.Services.ExchangeServer.GetExchangeMailboxPlan(orgs[0].Id, mailboxPlanId);

            if (plan.ItemId != orgs[0].Id)
            {
                messageBox.ShowErrorMessage("EXCHANGE_UNABLE_USE_SYSTEMPLAN");
                BindMailboxPlans();
                return;
            }



            plan = new Providers.HostedSolution.ExchangeMailboxPlan();
            plan.MailboxPlanId = (int)ViewState["MailboxPlanID"];
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
            plan.AllowLitigationHold = chkEnableLitigationHold.Checked;
            plan.RecoverableItemsSpace = recoverableItemsSpace.QuotaValue;
            plan.RecoverableItemsWarningPct = recoverableItemsWarning.ValueKB;
            if ((plan.RecoverableItemsWarningPct == 0)) plan.RecoverableItemsWarningPct = 100;
            plan.LitigationHoldMsg = txtLitigationHoldMsg.Text.Trim();
            plan.LitigationHoldUrl = txtLitigationHoldUrl.Text.Trim(); 


            if (PanelSecurity.SelectedUser.Role == UserRole.Administrator)
                plan.MailboxPlanType = (int)ExchangeMailboxPlanType.Administrator;
            else
                if (PanelSecurity.SelectedUser.Role == UserRole.Reseller)
                    plan.MailboxPlanType = (int)ExchangeMailboxPlanType.Reseller;


            if ((orgs != null) & (orgs.GetLength(0) > 0))
            {
                int result = ES.Services.ExchangeServer.UpdateExchangeMailboxPlan(orgs[0].Id, plan);

                if (result < 0)
                {
                    messageBox.ShowErrorMessage("EXCHANGE_UPDATEPLANS");
                }
                else
                {
                    messageBox.ShowSuccessMessage("EXCHANGE_UPDATEPLANS");
                }
            }

            BindMailboxPlans();
        }


        private bool PlanExists(ExchangeMailboxPlan plan, ExchangeMailboxPlan[] plans)
        {
            bool result = false;

            foreach (ExchangeMailboxPlan p in plans)
            {
                if (p.MailboxPlan.ToLower() == plan.MailboxPlan.ToLower())
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        protected void txtMailboxPlan_TextChanged(object sender, EventArgs e)
        {
            btnUpdateMailboxPlan.Enabled = (string.IsNullOrEmpty(txtMailboxPlan.Text)) ? false : true;
        }


        private void RestampMailboxes(int sourceMailboxPlanId, int destinationMailboxPlanId)
        {
            UserInfo[] UsersInfo = ES.Services.Users.GetUsers(PanelSecurity.SelectedUserId, true);

            try
            {
                foreach (UserInfo ui in UsersInfo)
                {
                    PackageInfo[] Packages = ES.Services.Packages.GetPackages(ui.UserId);

                    if ((Packages != null) & (Packages.GetLength(0) > 0))
                    {
                        foreach (PackageInfo Package in Packages)
                        {
                            Providers.HostedSolution.Organization[] orgs = null;

                            orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(Package.PackageId, false);

                            if ((orgs != null) & (orgs.GetLength(0) > 0))
                            {
                                foreach (Organization org in orgs)
                                {
                                    if (!string.IsNullOrEmpty(org.GlobalAddressList))
                                    {
                                        ExchangeAccount[] Accounts = ES.Services.ExchangeServer.GetExchangeAccountByMailboxPlanId(org.Id, sourceMailboxPlanId);

                                        foreach (ExchangeAccount a in Accounts)
                                        {
                                            txtStatus.Text = "Completed";
                                            int result = ES.Services.ExchangeServer.SetExchangeMailboxPlan(org.Id, a.AccountId, destinationMailboxPlanId, a.ArchivingMailboxPlanId);
                                            if (result < 0)
                                            {
                                                BindMailboxPlans();
                                                txtStatus.Text = "Error: " + a.AccountName;
                                                messageBox.ShowErrorMessage("EXCHANGE_STAMPMAILBOXES");
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                messageBox.ShowSuccessMessage("EXCHANGE_STAMPMAILBOXES");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("EXCHANGE_FAILED_TO_STAMP", ex);
            }

            BindMailboxPlans();
        }
    }
}