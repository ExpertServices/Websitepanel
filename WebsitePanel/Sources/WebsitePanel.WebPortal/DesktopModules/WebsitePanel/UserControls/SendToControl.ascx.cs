using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebsitePanel.Portal.UserControls
{
    public partial class SendToControl : WebsitePanelControlBase
    {
        public string ValidationGroup
        {
            get { return valEmailAddress.ValidationGroup; }
            set
            {
                valEmailAddress.ValidationGroup = value; 
                regexEmailValid.ValidationGroup = value;
                valMobile.ValidationGroup = value; 
                regexMobileValid.ValidationGroup = value;
            }
        }

        public bool IsRequestSend
        {
            get { return chkSendPasswordResetEmail.Checked; }
        }

        public bool SendEmail
        {
            get { return chkSendPasswordResetEmail.Checked && rbtnEmail.Checked; }
        }

        public bool SendMobile
        {
            get { return chkSendPasswordResetEmail.Checked && rbtnMobile.Checked; }
        }

        public string Email
        {
            get { return txtEmailAddress.Text; }
        }

        public string Mobile
        {
            get { return txtMobile.Text; }
        }

        public string ControlToHide { get; set; }

        protected void SendToGroupCheckedChanged(object sender, EventArgs e)
        {
            EmailRow.Visible = rbtnEmail.Checked;
            MobileRow.Visible = !rbtnEmail.Checked;
        }

        protected void chkSendPasswordResetEmail_StateChanged(object sender, EventArgs e)
        {
            SendToBody.Visible = chkSendPasswordResetEmail.Checked;

            if (!string.IsNullOrEmpty(ControlToHide))
            {
                var control = Parent.FindControl(ControlToHide);

                if (control != null)
                {
                    control.Visible = !chkSendPasswordResetEmail.Checked;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            var isTwilioEnabled = ES.Services.System.CheckIsTwilioEnabled();

            rbtnMobile.Visible = isTwilioEnabled;

            if (!Page.IsPostBack)
            {
                if (isTwilioEnabled)
                {
                    rbtnMobile.Checked = true;
                    rbtnEmail.Checked = false;
                    SendToGroupCheckedChanged(null, null);
                }

                chkSendPasswordResetEmail_StateChanged(null, null);
            }
        }
    }
}