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

namespace WebsitePanel.Portal.ExchangeServer
{
    public partial class OrganizationHome : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOrgStats();
            }

        }

        private void BindExchangeStats()
        {
            OrganizationStatistics exchangeOrgStats = ES.Services.ExchangeServer.GetOrganizationStatistics(PanelRequest.ItemID);
            lnkMailboxes.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "mailboxes",
            "SpaceID=" + PanelSecurity.PackageId.ToString());

            lnkContacts.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "contacts",
            "SpaceID=" + PanelSecurity.PackageId.ToString());

            lnkLists.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "dlists",
            "SpaceID=" + PanelSecurity.PackageId.ToString());

            lnkExchangeStorage.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "storage_usage",
            "SpaceID=" + PanelSecurity.PackageId.ToString());

            mailboxesStats.QuotaUsedValue = exchangeOrgStats.CreatedMailboxes;
            mailboxesStats.QuotaValue = exchangeOrgStats.AllocatedMailboxes;

            contactsStats.QuotaUsedValue = exchangeOrgStats.CreatedContacts;
            contactsStats.QuotaValue = exchangeOrgStats.AllocatedContacts;

            listsStats.QuotaUsedValue = exchangeOrgStats.CreatedDistributionLists;
            listsStats.QuotaValue = exchangeOrgStats.AllocatedDistributionLists;

            exchangeStorageStats.QuotaUsedValue = exchangeOrgStats.UsedDiskSpace;
            exchangeStorageStats.QuotaValue = exchangeOrgStats.AllocatedDiskSpace;


        }

        private void BindOrgStats()
        {
            Organization org = ES.Services.Organizations.GetOrganization(PanelRequest.ItemID);


            lblOrganizationNameValue.Text = org.Name;
            lblOrganizationIDValue.Text = org.OrganizationId;
            lblCreatedValue.Text = org.CreatedDate.Date.ToShortDateString();


            OrganizationStatistics orgStats = ES.Services.Organizations.GetOrganizationStatistics(PanelRequest.ItemID);
            if (orgStats == null)
                return;

            domainStats.QuotaUsedValue = orgStats.CreatedDomains;
            domainStats.QuotaValue = orgStats.AllocatedDomains;

            userStats.QuotaUsedValue = orgStats.CreatedUsers;
            userStats.QuotaValue = orgStats.AllocatedUsers;



            lnkDomains.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "domains",
                "SpaceID=" + PanelSecurity.PackageId);

            lnkUsers.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "users",
                "SpaceID=" + PanelSecurity.PackageId);




            PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);
            if (cntx.Groups.ContainsKey(ResourceGroups.Exchange))
            {
                exchangeStatsPanel.Visible = true;
                BindExchangeStats();
            }
            else
                exchangeStatsPanel.Visible = false;


            //Show SharePoint statistics
            if (cntx.Groups.ContainsKey(ResourceGroups.HostedSharePoint))
            {
                sharePointStatsPanel.Visible = true;

                lnkSiteCollections.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "sharepoint_sitecollections",
                "SpaceID=" + PanelSecurity.PackageId);
                siteCollectionsStats.QuotaUsedValue = orgStats.CreatedSharePointSiteCollections;
                siteCollectionsStats.QuotaValue = orgStats.AllocatedSharePointSiteCollections;

            }
            else
                sharePointStatsPanel.Visible = false;

            if (cntx.Groups.ContainsKey(ResourceGroups.OCS))
            {
                ocsStatsPanel.Visible = true;
                BindOCSStats();
            }
            else
                ocsStatsPanel.Visible = false;

            if (cntx.Groups.ContainsKey(ResourceGroups.BlackBerry))
            {
                besStatsPanel.Visible = true;
                BindBESStats();
            }
            else
                besStatsPanel.Visible = false;

            if (cntx.Groups.ContainsKey(ResourceGroups.Lync))
            {
                lyncStatsPanel.Visible = true;
                BindLyncStats();
            }
            else
                lyncStatsPanel.Visible = false;



            if (org.CrmOrganizationId != Guid.Empty)
            {
                crmStatsPanel.Visible = true;
                BindCRMStats(orgStats);
            }
            else
                crmStatsPanel.Visible = false;


        }

        private void BindCRMStats(OrganizationStatistics orgStats)
        {
            lnkCRMUsers.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "crmusers",
                "SpaceID=" + PanelSecurity.PackageId);

            crmUsersStats.QuotaUsedValue = orgStats.CreatedCRMUsers;
            crmUsersStats.QuotaValue = orgStats.AllocatedCRMUsers;
        }

        private void BindOCSStats()
        {
            OrganizationStatistics stats = ES.Services.Organizations.GetOrganizationStatistics(PanelRequest.ItemID);
            ocsUsersStats.QuotaValue = stats.AllocatedOCSUsers;
            ocsUsersStats.QuotaUsedValue = stats.CreatedOCSUsers;

            lnkOCSUsers.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "ocs_users",
            "SpaceID=" + PanelSecurity.PackageId.ToString());
        }

        private void BindLyncStats()
        {
            /*
            OrganizationStatistics stats = ES.Services.Organizations.GetOrganizationStatistics(PanelRequest.ItemID);
            lyncUsersStats.QuotaValue = stats.AllocatedLyncUsers;
            lyncUsersStats.QuotaUsedValue = stats.CreatedLyncUsers;

            lnkLyncUsers.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "lync_users",
            "SpaceID=" + PanelSecurity.PackageId.ToString());
             */
        }


        private void BindBESStats()
        {
            OrganizationStatistics stats = ES.Services.Organizations.GetOrganizationStatistics(PanelRequest.ItemID);
            besUsersStats.QuotaValue = stats.AllocatedBlackBerryUsers;
            besUsersStats.QuotaUsedValue = stats.CreatedBlackBerryUsers;

            lnkBESUsers.NavigateUrl = EditUrl("ItemID", PanelRequest.ItemID.ToString(), "blackberry_users",
            "SpaceID=" + PanelSecurity.PackageId.ToString());
        }


    }
}