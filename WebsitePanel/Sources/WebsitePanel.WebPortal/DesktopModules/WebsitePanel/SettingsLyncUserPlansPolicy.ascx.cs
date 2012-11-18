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
    public partial class SettingsLyncUserPlansPolicy : WebsitePanelControlBase, IUserSettingsEditorControl
    {

        internal static List<LyncUserPlan> list;


        public void BindSettings(UserSettings settings)
        {
            BindPlans();

            txtStatus.Visible = false;
        }


        private void BindPlans()
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
                LyncUserPlan[] list = ES.Services.Lync.GetLyncUserPlans(orgs[0].Id);

                gvPlans.DataSource = list;
                gvPlans.DataBind();
            }

            btnUpdatePlan.Enabled = (string.IsNullOrEmpty(txtPlan.Text)) ? false : true;
        }



        public string IsChecked(bool val)
        {
            return val ? "checked" : "";
        }


        public void btnAddPlan_Click(object sender, EventArgs e)
        {
            int count = 0;
            if (list != null)
            {
                foreach (LyncUserPlan p in list)
                {
                    p.LyncUserPlanId = count;
                    count++;
                }
            }


            LyncUserPlan plan = new LyncUserPlan();
            plan.LyncUserPlanName = txtPlan.Text;
            plan.IsDefault = false;

            plan.IM = true;
            plan.Mobility = chkMobility.Checked;
            plan.Federation = chkFederation.Checked;
            plan.Conferencing = chkConferencing.Checked;

            plan.EnterpriseVoice = chkEnterpriseVoice.Checked;
            if (!plan.EnterpriseVoice)
            {
                plan.VoicePolicy = LyncVoicePolicyType.None;
            }
            else
            {
                if (chkEmergency.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.Emergency;
                else if (chkNational.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.National;
                else if (chkMobile.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.Mobile;
                else if (chkInternational.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.International;
                else
                    plan.VoicePolicy = LyncVoicePolicyType.None;

            }
            
            if (PanelSecurity.SelectedUser.Role == UserRole.Administrator)
                plan.LyncUserPlanType = (int)LyncUserPlanType.Administrator;
            else
                if (PanelSecurity.SelectedUser.Role == UserRole.Reseller)
                    plan.LyncUserPlanType = (int)LyncUserPlanType.Reseller;


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
                int result = ES.Services.Lync.AddLyncUserPlan(orgs[0].Id, plan);

                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }
            }

            BindPlans();
        }

        protected void gvPlan_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int planId = Utils.ParseInt(e.CommandArgument.ToString(), 0);
            Providers.HostedSolution.Organization[] orgs = null;
            Providers.HostedSolution.LyncUserPlan plan;
            int result = 0;


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

                        plan = ES.Services.Lync.GetLyncUserPlan(orgs[0].Id, planId);

                        if (plan.ItemId != orgs[0].Id)
                        {
                            messageBox.ShowErrorMessage("EXCHANGE_UNABLE_USE_SYSTEMPLAN");
                            BindPlans();
                            return;
                        }


                        result = ES.Services.Lync.DeleteLyncUserPlan(orgs[0].Id, planId);
                        if (result < 0)
                        {
                            messageBox.ShowResultMessage(result);
                            return;
                        }
                        ViewState["LyncUserPlanID"] = null; 

                        txtPlan.Text = string.Empty;

                        btnUpdatePlan.Enabled = (string.IsNullOrEmpty(txtPlan.Text)) ? false : true;

                    }
                    catch (Exception)
                    {
                        messageBox.ShowErrorMessage("EXCHANGE_DELETE_MAILBOXPLAN");
                    }

                    BindPlans();

                    break;

                case "EditItem":
                    try
                    {

                        ViewState["LyncUserPlanID"] = planId;

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


                        plan = ES.Services.Lync.GetLyncUserPlan(orgs[0].Id, planId);

                        txtPlan.Text = plan.LyncUserPlanName;
                        chkIM.Checked = plan.IM;
                        chkIM.Enabled = false;
                        chkFederation.Checked = plan.Federation;
                        chkConferencing.Checked = plan.Conferencing;
                        chkMobility.Checked = plan.Mobility;
                        chkEnterpriseVoice.Checked = plan.EnterpriseVoice;
                        switch (plan.VoicePolicy)
                        {
                            case LyncVoicePolicyType.None:
                                break;
                            case LyncVoicePolicyType.Emergency:
                                chkEmergency.Checked = true;
                                break;
                            case LyncVoicePolicyType.National:
                                chkNational.Checked = true;
                                break;
                            case LyncVoicePolicyType.Mobile:
                                chkMobile.Checked = true;
                                break;
                            case LyncVoicePolicyType.International:
                                chkInternational.Checked = true;
                                break;
                            default:
                                chkNone.Checked = true;
                                break;
                        }

                        btnUpdatePlan.Enabled  = (string.IsNullOrEmpty(txtPlan.Text)) ? false : true;

                        break;
                    }
                    catch (Exception)
                    {
                        messageBox.ShowErrorMessage("EXCHANGE_DELETE_MAILBOXPLAN");
                    }

                    BindPlans();

                    break;
                case "RestampItem":
                    RestampLyncUsers(planId, planId);
                    break;
            }
        }


        public string GetPlanType(int planType)
        {
            string imgName = string.Empty;

            LyncUserPlanType type = (LyncUserPlanType)planType;
            switch (type)
            {
                case LyncUserPlanType.Reseller:
                    imgName = "company24.png";
                    break;
                case LyncUserPlanType.Administrator:
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
            settings["LyncUserPlansPolicy"] = "";
        }


        protected void btnUpdatePlan_Click(object sender, EventArgs e)
        {

            if (ViewState["LyncUserPlanID"] == null)
                return;

            int planId = (int)ViewState["LyncUserPlanID"];
            Providers.HostedSolution.Organization[] orgs = null;
            Providers.HostedSolution.LyncUserPlan plan;


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

            plan = ES.Services.Lync.GetLyncUserPlan(orgs[0].Id, planId);

            if (plan.ItemId != orgs[0].Id)
            {
                messageBox.ShowErrorMessage("EXCHANGE_UNABLE_USE_SYSTEMPLAN");
                BindPlans();
                return;
            }

            plan = new Providers.HostedSolution.LyncUserPlan();
            plan.LyncUserPlanId = (int)ViewState["LyncUserPlanID"];

            plan.LyncUserPlanName = txtPlan.Text;
            plan.IsDefault = false;

            plan.IM = true;
            plan.Mobility = chkMobility.Checked;
            plan.Federation = chkFederation.Checked;
            plan.Conferencing = chkConferencing.Checked;

            plan.EnterpriseVoice = chkEnterpriseVoice.Checked;
            if (!plan.EnterpriseVoice)
            {
                plan.VoicePolicy = LyncVoicePolicyType.None;
            }
            else
            {
                if (chkEmergency.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.Emergency;
                else if (chkNational.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.National;
                else if (chkMobile.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.Mobile;
                else if (chkInternational.Checked)
                    plan.VoicePolicy = LyncVoicePolicyType.International;
                else
                    plan.VoicePolicy = LyncVoicePolicyType.None;

            }
            
            if (PanelSecurity.SelectedUser.Role == UserRole.Administrator)
                plan.LyncUserPlanType = (int)LyncUserPlanType.Administrator;
            else
                if (PanelSecurity.SelectedUser.Role == UserRole.Reseller)
                    plan.LyncUserPlanType = (int)LyncUserPlanType.Reseller;


            if ((orgs != null) & (orgs.GetLength(0) > 0))
            {
                int result = ES.Services.Lync.UpdateLyncUserPlan(orgs[0].Id, plan);

                if (result < 0)
                {
                    messageBox.ShowErrorMessage("EXCHANGE_UPDATEPLANS");
                }
                else
                {
                    messageBox.ShowSuccessMessage("EXCHANGE_UPDATEPLANS");
                }
            }

            BindPlans();
        }


        private bool PlanExists(LyncUserPlan plan, LyncUserPlan[] plans)
        {
            bool result = false;

            foreach (LyncUserPlan p in plans)
            {
                if (p.LyncUserPlanName.ToLower() == plan.LyncUserPlanName.ToLower())
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        protected void txtMailboxPlan_TextChanged(object sender, EventArgs e)
        {
            btnUpdatePlan.Enabled = (string.IsNullOrEmpty(txtPlan.Text)) ? false : true;
        }

        private void RestampLyncUsers(int sourcePlanId, int destinationPlanId)
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
                                    if (!string.IsNullOrEmpty(org.LyncTenantId))
                                    {
                                        LyncUser[] Accounts = ES.Services.Lync.GetLyncUsersByPlanId(org.Id, sourcePlanId);

                                        foreach (LyncUser a in Accounts)
                                        {
                                            txtStatus.Text = "Completed";
                                            Providers.ResultObjects.LyncUserResult result = ES.Services.Lync.SetUserLyncPlan(org.Id, a.AccountID, destinationPlanId);
                                            if (!result.IsSuccess)
                                            {
                                                BindPlans();
                                                txtStatus.Text = "Error: " + a.DisplayName;
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

            BindPlans();
        }


    }
}