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

            if (list == null)
                list = new List<LyncUserPlan>();

            if (!string.IsNullOrEmpty(settings[UserSettings.DEFAULT_LYNCUSERPLANS]))
            {

                XmlSerializer serializer = new XmlSerializer(list.GetType());

                StringReader reader = new StringReader(settings[UserSettings.DEFAULT_LYNCUSERPLANS]);

                list = (List<LyncUserPlan>)serializer.Deserialize(reader);
            }

            gvPlans.DataSource = list;
            gvPlans.DataBind();

            if (gvPlans.Rows.Count <= 1)
            {
                btnSetDefaultPlan.Enabled = false;
            }
            else
                btnSetDefaultPlan.Enabled = true;
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

            if (list == null)
                list = new List<LyncUserPlan>();

            list.Add(plan);
            gvPlans.DataSource = list;
            gvPlans.DataBind();

            if (gvPlans.Rows.Count <= 1)
            {
                btnSetDefaultPlan.Enabled = false;
            }
            else
                btnSetDefaultPlan.Enabled = true;

        }

        protected void gvPlan_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int planId = Utils.ParseInt(e.CommandArgument.ToString(), 0);

            switch (e.CommandName)
            {
                case "DeleteItem":

                    foreach (LyncUserPlan p in list)
                    {
                        if (p.LyncUserPlanId == planId)
                        {
                            list.Remove(p);
                            break;
                        }
                    }

                    gvPlans.DataSource = list;
                    gvPlans.DataBind();

                    if (gvPlans.Rows.Count <= 1)
                    {
                        btnSetDefaultPlan.Enabled = false;
                    }
                    else
                        btnSetDefaultPlan.Enabled = true;
                    break;

                case "EditItem":
                    foreach (LyncUserPlan plan in list)
                    {
                        if (plan.LyncUserPlanId == planId)
                        {

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

                            break;
                        }
                    }

                    break;
            }
        }

        protected void btnSetDefaultPlan_Click(object sender, EventArgs e)
        {
            // get domain
            int planId = Utils.ParseInt(Request.Form["DefaultLyncUserPlan"], 0);



            foreach (LyncUserPlan p in list)
            {
                p.IsDefault = false;
            }

            foreach (LyncUserPlan p in list)
            {
                if (p.LyncUserPlanId == planId)
                {
                    p.IsDefault = true;
                    break;
                }
            }

            gvPlans.DataSource = list;
            gvPlans.DataBind();
        }

        public void SaveSettings(UserSettings settings)
        {
            XmlSerializer serializer = new XmlSerializer(list.GetType());

            StringWriter writer = new StringWriter();

            serializer.Serialize(writer, list);

            settings[UserSettings.DEFAULT_LYNCUSERPLANS] = writer.ToString();
        }



    }
}