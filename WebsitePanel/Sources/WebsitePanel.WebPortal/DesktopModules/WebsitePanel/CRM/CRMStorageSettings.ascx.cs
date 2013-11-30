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
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal
{
    public partial class CRMStorageSettings : WebsitePanelModuleBase
    {
        public string SizeValueToString(long val)
        {
            return (val == -1) ? GetSharedLocalizedString("Text.Unlimited") : val.ToString();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            warningValue.UnlimitedText = GetLocalizedString("WarningUnlimitedValue");
            
            if (!IsPostBack)
            {
                BindValues();
            }
        }

        private void BindValues()
        {
            Organization org = ES.Services.Organizations.GetOrganization(PanelRequest.ItemID);
            PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);

            maxStorageSettingsValue.ParentQuotaValue = cntx.Quotas[Quotas.CRM_MAXDATABASESIZE].QuotaAllocatedValue;

            long maxDBSize = ES.Services.CRM.GetMaxDBSize(PanelRequest.ItemID, PanelSecurity.PackageId);
            long DBSize = ES.Services.CRM.GetDBSize(PanelRequest.ItemID, PanelSecurity.PackageId);

            DBSize = DBSize > 0 ? DBSize = DBSize / (1024 * 1024) : DBSize;
            maxDBSize = maxDBSize > 0 ? maxDBSize = maxDBSize / (1024 * 1024) : maxDBSize;

            maxStorageSettingsValue.QuotaValue = Convert.ToInt32(maxDBSize);

            lblDBSize.Text = SizeValueToString(DBSize);
            lblMAXDBSize.Text = SizeValueToString(maxDBSize);
        }

        private void Save()
        {            
            try
            {
                PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);
                int limitSize = cntx.Quotas[Quotas.CRM_MAXDATABASESIZE].QuotaAllocatedValue;

                int maxSize = maxStorageSettingsValue.QuotaValue;

                if (limitSize != -1)
                {
                    if (maxSize == -1) maxSize = limitSize;
                    if (maxSize > limitSize) maxSize = limitSize;
                }

                if (maxSize > 0)
                {
                    maxSize = maxSize * 1024 * 1024;
                }

                ES.Services.CRM.SetMaxDBSize(PanelRequest.ItemID, PanelSecurity.PackageId, maxSize);

                messageBox.ShowSuccessMessage("HOSTED_SHAREPOINT_UPDATE_QUOTAS");

                BindValues();
            }
            catch (Exception)
            {
                messageBox.ShowErrorMessage("HOSTED_SHAREPOINT_UPDATE_QUOTAS");
            }

        }
        
        protected void btnSave_Click(object sender, EventArgs e)
        {
            Save();            
        }

    }
}