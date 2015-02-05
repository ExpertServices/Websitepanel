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
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Web.Services3.Referral;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal
{
    public enum UserActionTypes
    {
        None = 0,
        Disable = 1,
        Enable = 2,
    }

    public partial class UserActions : WebsitePanelControlBase
    {
        public UserActionTypes SelectedAction
        {
            get
            {
                return  (UserActionTypes) Convert.ToInt32(ddlUserActions.SelectedValue);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void ResetSelection()
        {
            ddlUserActions.ClearSelection(); 
        }

        public int DoUserActions(List<int> userIds)
        {
            switch (SelectedAction)
            {
                case UserActionTypes.Disable:
                    return ChangeUsersSettings(userIds, true);
                case UserActionTypes.Enable:
                    return ChangeUsersSettings(userIds, false);
            }

            return 0;
        }

        protected int ChangeUsersSettings(List<int> userIds, bool disable)
        {
            foreach (var userId in userIds)
            {
                OrganizationUser user = ES.Services.Organizations.GetUserGeneralSettings(PanelRequest.ItemID, userId);

                int result = ES.Services.Organizations.SetUserGeneralSettings(
                    PanelRequest.ItemID,
                    userId,

                    user.DisplayName,
                    string.Empty,
                    false,
                    disable,
                    user.Locked,

                    user.FirstName,
                    user.Initials,
                    user.LastName,

                    user.Address,
                    user.City,
                    user.State,
                    user.Zip,
                    user.Country,

                    user.JobTitle,
                    user.Company,
                    user.Department,
                    user.Office,
                    user.Manager != null ? user.Manager.AccountName : String.Empty,

                    user.BusinessPhone,
                    user.Fax,
                    user.HomePhone,
                    user.MobilePhone,
                    user.Pager,
                    user.WebPage,
                    user.Notes,
                    user.ExternalEmail,
                    user.SubscriberNumber,
                    user.LevelId,
                    user.IsVIP);

                if (result < 0)
                {
                    return result;
                }
            }

            return 0;
        }
    }
}
