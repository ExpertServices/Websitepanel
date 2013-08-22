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
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal.ExchangeServer.UserControls
{
    public partial class UsersList : WebsitePanelControlBase
	{
        public const string DirectionString = "DirectionString";

        private bool _enabled = true;

        public bool Enabled
        {
            get { return _enabled; }
            set { _enabled = value; }
        }

		private enum SelectedState
		{
			All,
			Selected,
			Unselected
		}

        public bool IncludeMailboxes
        {
            get
            {
                object ret = ViewState["IncludeMailboxes"];
                return (ret != null) ? (bool)ret : false;
            }
            set
            {
                ViewState["IncludeMailboxes"] = value;
            }
        }

        public bool IncludeMailboxesOnly
        {
            get
            {
                object ret = ViewState["IncludeMailboxesOnly"];
                return (ret != null) ? (bool)ret : false;
            }
            set
            {
                ViewState["IncludeMailboxesOnly"] = value;
            }
        }


        public bool ExcludeOCSUsers
        {
            get
            {
                object ret = ViewState["ExcludeOCSUsers"];
                return (ret != null) ? (bool)ret : false;
            }
            set
            {
                ViewState["ExcludeOCSUsers"] = value;
            }
        }

        public bool ExcludeLyncUsers
        {
            get
            {
                object ret = ViewState["ExcludeLyncUsers"];
                return (ret != null) ? (bool)ret : false;
            }
            set
            {
                ViewState["ExcludeLyncUsers"] = value;
            }
        }


        public bool ExcludeBESUsers
        {
            get
            {
                object ret = ViewState["ExcludeBESUsers"];
                return (ret != null) ? (bool)ret : false;
            }
            set
            {
                ViewState["ExcludeBESUsers"] = value;
            }
        }

	    public int ExcludeAccountId
		{
			get { return PanelRequest.AccountID; }
		}

		public void SetAccounts(OrganizationUser[] accounts)
		{
			BindAccounts(accounts, false);
		}

		public string[] GetAccounts()
		{
			// get selected accounts
			List<OrganizationUser> selectedAccounts = GetGridViewAccounts(gvAccounts, SelectedState.All);

			List<string> accountNames = new List<string>();
			foreach (OrganizationUser account in selectedAccounts)
				accountNames.Add(account.AccountName);

			return accountNames.ToArray();
		}

		protected void Page_Load(object sender, EventArgs e)
		{
			// register javascript
			if (!Page.ClientScript.IsClientScriptBlockRegistered("SelectAllCheckboxes"))
			{
				string script = @"    function SelectAllCheckboxes(box)
    {
		var state = box.checked;
        var elm = box.parentElement.parentElement.parentElement.parentElement.getElementsByTagName(""INPUT"");
        for(i = 0; i < elm.length; i++)
            if(elm[i].type == ""checkbox"" && elm[i].id != box.id && elm[i].checked != state && !elm[i].disabled)
		        elm[i].checked = state;
    }";
				Page.ClientScript.RegisterClientScriptBlock(typeof(AccountsList), "SelectAllCheckboxes",
					script, true);
			}

            btnAdd.Visible = Enabled;
            btnDelete.Visible = Enabled;

            gvAccounts.Columns[0].Visible = Enabled;
		}

		protected void btnAdd_Click(object sender, EventArgs e)
		{
			// bind all accounts
			BindPopupAccounts();

			// show modal
			AddAccountsModal.Show();
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			// get selected accounts
			List<OrganizationUser> selectedAccounts = GetGridViewAccounts(gvAccounts, SelectedState.Unselected);

			// add to the main list
			BindAccounts(selectedAccounts.ToArray(), false);
		}

		protected void btnAddSelected_Click(object sender, EventArgs e)
		{
			// get selected accounts
			List<OrganizationUser> selectedAccounts = GetGridViewAccounts(gvPopupAccounts, SelectedState.Selected);
			
			// add to the main list
			BindAccounts(selectedAccounts.ToArray(), true);
		}

        public string GetAccountImage(int accountTypeId)
        {
            string imgName = string.Empty;

            ExchangeAccountType accountType = (ExchangeAccountType)accountTypeId;
            switch (accountType)
            {
                case ExchangeAccountType.Room:
                    imgName = "room_16.gif";
                    break;
                case ExchangeAccountType.Equipment:
                    imgName = "equipment_16.gif";
                    break;
                default:
                    imgName = "admin_16.png";
                    break;
            }

            return GetThemedImage("Exchange/" + imgName);
        }

		private void BindPopupAccounts()
		{
			OrganizationUser[] accounts = ES.Services.Organizations.SearchAccounts(PanelRequest.ItemID,
				ddlSearchColumn.SelectedValue, txtSearchValue.Text + "%", "", IncludeMailboxes);

			if (ExcludeAccountId > 0)
			{
				List<OrganizationUser> updatedAccounts = new List<OrganizationUser>();
				foreach (OrganizationUser account in accounts)
					if (account.AccountId != ExcludeAccountId)
						updatedAccounts.Add(account);

				accounts = updatedAccounts.ToArray();
			}

            if (IncludeMailboxesOnly)
            {

                List<OrganizationUser> updatedAccounts = new List<OrganizationUser>();
                foreach (OrganizationUser account in accounts)
                {
                    bool addUser = false;
                    if (account.ExternalEmail != string.Empty) addUser = true;
                    if ((account.IsBlackBerryUser) & (ExcludeBESUsers)) addUser = false;
                    if ((account.IsLyncUser) & (ExcludeLyncUsers)) addUser = false;

                    if (addUser) updatedAccounts.Add(account);
                }

                accounts = updatedAccounts.ToArray();
            }
            else
                if ((ExcludeOCSUsers) | (ExcludeBESUsers) | (ExcludeLyncUsers))
                {

                    List<OrganizationUser> updatedAccounts = new List<OrganizationUser>();
                    foreach (OrganizationUser account in accounts)
                    {
                        bool addUser = true;
                        if ((account.IsOCSUser) & (ExcludeOCSUsers)) addUser = false;
                        if ((account.IsLyncUser) & (ExcludeLyncUsers)) addUser = false;
                        if ((account.IsBlackBerryUser) & (ExcludeBESUsers)) addUser = false;

                        if (addUser) updatedAccounts.Add(account);
                    }

                    accounts = updatedAccounts.ToArray();
                }


            Array.Sort(accounts, CompareAccount);
            if (Direction == SortDirection.Ascending)
            {
                Array.Reverse(accounts);
                Direction = SortDirection.Descending;
            }
            else
                Direction = SortDirection.Ascending;

            gvPopupAccounts.DataSource = accounts;
            gvPopupAccounts.DataBind();
		}

		private void BindAccounts(OrganizationUser[] newAccounts, bool preserveExisting)
		{
			// get binded addresses
			List<OrganizationUser> accounts = new List<OrganizationUser>();
			if(preserveExisting)
				accounts.AddRange(GetGridViewAccounts(gvAccounts, SelectedState.All));

			// add new accounts
			if (newAccounts != null)
			{
				foreach (OrganizationUser newAccount in newAccounts)
				{
					// check if exists
					bool exists = false;
					foreach (OrganizationUser account in accounts)
					{
						if (String.Compare(newAccount.AccountName, account.AccountName, true) == 0)
						{
							exists = true;
							break;
						}
					}

					if (exists)
						continue;

					accounts.Add(newAccount);
				}
			}

			gvAccounts.DataSource = accounts;
			gvAccounts.DataBind();

            btnDelete.Visible = gvAccounts.Rows.Count > 0;
		}

		private List<OrganizationUser> GetGridViewAccounts(GridView gv, SelectedState state)
		{
			List<OrganizationUser> accounts = new List<OrganizationUser>();
			for (int i = 0; i < gv.Rows.Count; i++)
			{
				GridViewRow row = gv.Rows[i];
				CheckBox chkSelect = (CheckBox)row.FindControl("chkSelect");
				if (chkSelect == null)
					continue;

				OrganizationUser account = new OrganizationUser();
				account.AccountType = (ExchangeAccountType)Enum.Parse(typeof(ExchangeAccountType), ((Literal)row.FindControl("litAccountType")).Text);
				account.AccountName = (string)gv.DataKeys[i][0];
				account.DisplayName = ((Literal)row.FindControl("litDisplayName")).Text;
				account.PrimaryEmailAddress = ((Literal)row.FindControl("litPrimaryEmailAddress")).Text;

				if(state == SelectedState.All || 
					(state == SelectedState.Selected && chkSelect.Checked) ||
					(state == SelectedState.Unselected && !chkSelect.Checked))
					accounts.Add(account);
			}
			return accounts;
		}

		protected void cmdSearch_Click(object sender, ImageClickEventArgs e)
		{
			BindPopupAccounts();
		}

        private SortDirection Direction
        {
            get { return ViewState[DirectionString] == null ? SortDirection.Descending : (SortDirection)ViewState[DirectionString]; }
            set { ViewState[DirectionString] = value; }
        }

        private static int CompareAccount(OrganizationUser user1, OrganizationUser user2)
        {
            return string.Compare(user1.DisplayName, user2.DisplayName);
        }
	}
}