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
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class ExchangeMailboxGeneralSettings : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSettings();
            }

        }

        private void BindSettings()
        {
            try
            {
                // get settings
                ExchangeMailbox mailbox = ES.Services.ExchangeServer.GetMailboxGeneralSettings(PanelRequest.ItemID,
                    PanelRequest.AccountID);

                //get statistics
                ExchangeMailboxStatistics stats = ES.Services.ExchangeServer.GetMailboxStatistics(PanelRequest.ItemID,
                    PanelRequest.AccountID);

                // title
                litDisplayName.Text = mailbox.DisplayName;

                // bind form
                chkHideAddressBook.Checked = mailbox.HideFromAddressBook;
                chkDisable.Checked = mailbox.Disabled;

                // get account meta
                ExchangeAccount account = ES.Services.ExchangeServer.GetAccount(PanelRequest.ItemID, PanelRequest.AccountID);
                chkPmmAllowed.Checked = (account.MailboxManagerActions & MailboxManagerActions.GeneralSettings) > 0;

                if (account.MailboxPlanId == 0)
                {
                    mailboxPlanSelector.AddNone = true;
                    mailboxPlanSelector.MailboxPlanId = "-1";
                }
                else
                {
                    mailboxPlanSelector.MailboxPlanId = account.MailboxPlanId.ToString();
                }

                mailboxSize.QuotaUsedValue = Convert.ToInt32(stats.TotalSize / 1024 / 1024);
                mailboxSize.QuotaValue = (stats.MaxSize == -1) ? -1: (int)Math.Round((double)(stats.MaxSize / 1024 / 1024));

                if ((account.AccountType == ExchangeAccountType.Equipment) | (account.AccountType == ExchangeAccountType.Room))
                    secCalendarSettings.Visible = true;
                else
                    secCalendarSettings.Visible = false;


            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("EXCHANGE_GET_MAILBOX_SETTINGS", ex);
            }
        }

        private void SaveSettings()
        {
            if (!Page.IsValid)
                return;

            try
            {
                if (mailboxPlanSelector.MailboxPlanId == "-1")
                {
                    messageBox.ShowErrorMessage("EXCHANGE_SPECIFY_PLAN");
                    return;
                }

                int result = ES.Services.ExchangeServer.SetMailboxGeneralSettings(
                    PanelRequest.ItemID, PanelRequest.AccountID,
                    chkHideAddressBook.Checked,
                    chkDisable.Checked);

                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }
                else
                {
                    result = ES.Services.ExchangeServer.SetExchangeMailboxPlan(PanelRequest.ItemID, PanelRequest.AccountID, Convert.ToInt32(mailboxPlanSelector.MailboxPlanId));
                    if (result < 0)
                    {
                        messageBox.ShowResultMessage(result);
                        return;
                    }
                }

                messageBox.ShowSuccessMessage("EXCHANGE_UPDATE_MAILBOX_SETTINGS");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("EXCHANGE_UPDATE_MAILBOX_SETTINGS", ex);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveSettings();
        }

        protected void chkPmmAllowed_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                int result = ES.Services.ExchangeServer.SetMailboxManagerSettings(PanelRequest.ItemID, PanelRequest.AccountID,
                chkPmmAllowed.Checked, MailboxManagerActions.GeneralSettings);

                if (result < 0)
                {
                    messageBox.ShowResultMessage(result);
                    return;
                }

                messageBox.ShowSuccessMessage("EXCHANGE_UPDATE_MAILMANAGER");
            }
            catch (Exception ex)
            {
                messageBox.ShowErrorMessage("EXCHANGE_UPDATE_MAILMANAGER", ex);
            }
        }

        private int ConvertMbxSizeToIntMB(string inputValue)
        {
            int result = 0;

            if ((inputValue == null) || (inputValue == ""))
                return 0;

            if (inputValue.Contains("TB"))
            {
                result = Convert.ToInt32(inputValue.Replace(" TB", ""));
                result = result * 1024 * 1024;
            }
            else
                if (inputValue.Contains("GB"))
                {
                    result = Convert.ToInt32(inputValue.Replace(" GB", ""));
                    result = result * 1024;
                }
                else
                    if (inputValue.Contains("MB"))
                    {
                        result = Convert.ToInt32(inputValue.Replace(" MB", ""));
                    }

            return result;
        }

    }
}