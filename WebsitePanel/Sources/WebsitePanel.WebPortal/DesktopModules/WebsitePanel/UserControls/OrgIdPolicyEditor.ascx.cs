using System;
using System.Text;
using System.Web.UI;

namespace WebsitePanel.Portal.UserControls
{
    public partial class OrgIdPolicyEditor : UserControl
    {
        #region Properties

        public string Value
        {
            get
            {
                var sb = new StringBuilder();
                sb.Append(enablePolicyCheckBox.Checked.ToString()).Append(";");
                sb.Append(txtMaximumLength.Text).Append(";");

                return sb.ToString();
            }
            set
            {
                if (String.IsNullOrEmpty(value))
                {
                    enablePolicyCheckBox.Checked = true;
                    txtMaximumLength.Text = "128";
                }
                else
                {
                    try
                    {
                        string[] parts = value.Split(';');
                        enablePolicyCheckBox.Checked = Utils.ParseBool(parts[0], false);
                        txtMaximumLength.Text = parts[1];
                    }
                    catch
                    {
                    }
                }

                ToggleControls();
            }
        }

        #endregion

        #region Methods

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private void ToggleControls()
        {
            PolicyTable.Visible = enablePolicyCheckBox.Checked;
        }

        #endregion

        #region Event Handlers

        protected void EnablePolicy_CheckedChanged(object sender, EventArgs e)
        {
            ToggleControls();
        }

        #endregion
    }
}