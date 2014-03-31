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
using System.Data;
using System.Collections.Generic;
using System.Text;

using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.EnterpriseServer;

using System.Web;
using WebsitePanel.WebPortal;

namespace WebsitePanel.Portal
{
	public class ExchangeHelper
	{
		#region Exchange Organizations
		DataSet orgs;

		public int GetExchangeOrganizationsPagedCount(int packageId,
			bool recursive, string filterColumn, string filterValue)
		{
			return (int)orgs.Tables[0].Rows[0][0];
		}

		public DataTable GetExchangeOrganizationsPaged(int packageId,
			bool recursive, string filterColumn, string filterValue,
			int maximumRows, int startRowIndex, string sortColumn)
		{
			if (!String.IsNullOrEmpty(filterValue))
				filterValue = filterValue + "%";

			orgs = ES.Services.ExchangeServer.GetRawExchangeOrganizationsPaged(packageId,
				recursive, filterColumn, filterValue, sortColumn, startRowIndex, maximumRows);

			return orgs.Tables[1];
		}
		#endregion

		#region Accounts
		ExchangeAccountsPaged accounts;

		public int GetExchangeAccountsPagedCount(int itemId, string accountTypes,
			string filterColumn, string filterValue)
		{
			return accounts.RecordsCount;
		}

		public ExchangeAccount[] GetExchangeAccountsPaged(int itemId, string accountTypes,
			string filterColumn, string filterValue,
			int maximumRows, int startRowIndex, string sortColumn)
		{
			if (!String.IsNullOrEmpty(filterValue))
				filterValue = filterValue + "%";

			accounts = ES.Services.ExchangeServer.GetAccountsPaged(itemId,
                accountTypes, filterColumn, filterValue, sortColumn, startRowIndex, maximumRows);

			return accounts.PageItems;
		}

		#endregion

        #region Utils

        public static string BuildUrl(string keyName, string keyValue, string controlKey, params string[] additionalParams)
        {
            List<string> url = new List<string>();

            string pageId = HttpContext.Current.Request[DefaultPage.PAGE_ID_PARAM];

            if (!String.IsNullOrEmpty(pageId))
                url.Add(String.Concat(DefaultPage.PAGE_ID_PARAM, "=", pageId));

            url.Add(String.Concat(DefaultPage.MODULE_ID_PARAM, "=", HttpContext.Current.Request.QueryString["mid"]));
            url.Add(String.Concat(DefaultPage.CONTROL_ID_PARAM, "=", controlKey));

            if (!String.IsNullOrEmpty(keyName) && !String.IsNullOrEmpty(keyValue))
            {
                url.Add(String.Concat(keyName, "=", keyValue));
            }

            if (additionalParams != null)
            {
                foreach (string additionalParam in additionalParams)
                    url.Add(additionalParam);
            }

            return "~/Default.aspx?" + String.Join("&", url.ToArray());
        }

        public static string GetLocalizedString(string virtualPath, string resourceKey)
        {
            return (string)HttpContext.GetLocalResourceObject(virtualPath, resourceKey);
        }

        #endregion
    }
}
