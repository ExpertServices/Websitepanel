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
using System.Web.UI.WebControls;

using WebsitePanel.EnterpriseServer;
using WebsitePanel.WebPortal;


namespace WebsitePanel.Portal
{
    public partial class OrganizationMenu : WebsitePanelModuleBase
    {
        private const string PID_SPACE_EXCHANGE_SERVER = "SpaceExchangeServer";

        protected void Page_Load(object sender, EventArgs e)
        {
            // organization
            bool orgVisible = (PanelRequest.ItemID > 0 && Request[DefaultPage.PAGE_ID_PARAM].Equals(PID_SPACE_EXCHANGE_SERVER, StringComparison.InvariantCultureIgnoreCase));

            orgMenu.Visible = orgVisible;

            if (orgVisible)
            {
                MenuItem rootItem = new MenuItem(locMenuTitle.Text);
                rootItem.Selectable = false;

                menu.Items.Add(rootItem);

                BindMenu(rootItem.ChildItems);
            }
        }

        private void BindMenu(MenuItemCollection items)
        {
            PackageContext cntx = PackagesHelper.GetCachedPackageContext(PanelSecurity.PackageId);

            string imagePath = String.Concat("~/", DefaultPage.THEMES_FOLDER, "/", Page.Theme, "/", "Images/Exchange", "/");

            //Organization menu group;
            if (cntx.Groups.ContainsKey(ResourceGroups.HostedOrganizations))
            PrepareOrganizationMenuRoot(cntx, items, imagePath);

            //Exchange menu group;
            if (cntx.Groups.ContainsKey(ResourceGroups.Exchange))
                PrepareExchangeMenuRoot(cntx, items, imagePath);

            //BlackBerry Menu
            if (cntx.Groups.ContainsKey(ResourceGroups.BlackBerry))
                PrepareBlackBerryMenuRoot(cntx, items, imagePath);

            //SharePoint menu group;
            if (cntx.Groups.ContainsKey(ResourceGroups.HostedSharePoint))
                PrepareSharePointMenuRoot(cntx, items, imagePath);
            
            //CRM Menu
            if (cntx.Groups.ContainsKey(ResourceGroups.HostedCRM))
                PrepareCRMMenuRoot(cntx, items, imagePath);

            //OCS Menu
            if (cntx.Groups.ContainsKey(ResourceGroups.OCS))
                PrepareOCSMenuRoot(cntx, items, imagePath);

            //Lync Menu
            if (cntx.Groups.ContainsKey(ResourceGroups.Lync))
                PrepareLyncMenuRoot(cntx, items, imagePath);

            //EnterpriseStorage Menu
            if (cntx.Groups.ContainsKey(ResourceGroups.EnterpriseStorage))
                PrepareEnterpriseStorageMenuRoot(cntx, items, imagePath);
        }

        private void PrepareOrganizationMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            bool hideItems = false;

            UserInfo user = UsersHelper.GetUser(PanelSecurity.EffectiveUserId);

            if (user != null)
            {
                if ((user.Role == UserRole.User) & (Utils.CheckQouta(Quotas.EXCHANGE2007_ISCONSUMER, cntx)))
                    hideItems = true;
            }

            if (!hideItems)
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.OrganizationGroup"), "", imagePath + "company24.png", null);

                item.Selectable = false;

                PrepareOrganizationMenu(cntx, item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareOrganizationMenu(PackageContext cntx, MenuItemCollection items)
        {
            if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, cntx) == false)
            {
                if (Utils.CheckQouta(Quotas.ORGANIZATION_DOMAINS, cntx))
                    items.Add(CreateMenuItem("DomainNames", "org_domains"));
            }
            if (Utils.CheckQouta(Quotas.ORGANIZATION_USERS, cntx))
                items.Add(CreateMenuItem("Users", "users"));

            if (Utils.CheckQouta(Quotas.ORGANIZATION_SECURITYGROUPMANAGEMENT, cntx))
                items.Add(CreateMenuItem("SecurityGroups", "secur_groups"));
        }

        private void PrepareExchangeMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            bool hideItems = false;

            UserInfo user = UsersHelper.GetUser(PanelSecurity.EffectiveUserId);

            if (user != null)
            {
                if ((user.Role == UserRole.User) & (Utils.CheckQouta(Quotas.EXCHANGE2007_ISCONSUMER, cntx)))
                    hideItems = true;
            }

            MenuItem item = new MenuItem(GetLocalizedString("Text.ExchangeGroup"), "", imagePath + "exchange24.png", null);

            item.Selectable = false;

            PrepareExchangeMenu(cntx, item.ChildItems, hideItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareExchangeMenu(PackageContext cntx, MenuItemCollection exchangeItems, bool hideItems)
        {
            if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, cntx))
                exchangeItems.Add(CreateMenuItem("Mailboxes", "mailboxes"));

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_CONTACTS, cntx))
                exchangeItems.Add(CreateMenuItem("Contacts", "contacts"));

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_DISTRIBUTIONLISTS, cntx))
                exchangeItems.Add(CreateMenuItem("DistributionLists", "dlists"));

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_PUBLICFOLDERS, cntx))
                exchangeItems.Add(CreateMenuItem("PublicFolders", "public_folders"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_ACTIVESYNCALLOWED, cntx))
                    exchangeItems.Add(CreateMenuItem("ActiveSyncPolicy", "activesync_policy"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, cntx))
                    exchangeItems.Add(CreateMenuItem("MailboxPlans", "mailboxplans"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, cntx))
                    exchangeItems.Add(CreateMenuItem("ExchangeDomainNames", "domains"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, cntx))
                    exchangeItems.Add(CreateMenuItem("StorageUsage", "storage_usage"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_DISCLAIMERSALLOWED, cntx))
                    exchangeItems.Add(CreateMenuItem("Disclaimers", "disclaimers"));

        }

        private void PrepareCRMMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.CRMGroup"), "", imagePath + "crm_16.png", null);

            item.Selectable = false;

            PrepareCRMMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareCRMMenu(PackageContext cntx, MenuItemCollection crmItems)
        {
            crmItems.Add(CreateMenuItem("CRMOrganization", "CRMOrganizationDetails"));
            crmItems.Add(CreateMenuItem("CRMUsers", "CRMUsers"));
            crmItems.Add(CreateMenuItem("StorageLimits", "crm_storage_settings"));
        }

        private void PrepareBlackBerryMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.CRMGroup"), "", imagePath + "crm_16.png", null);

            item.Selectable = false;

            PrepareBlackBerryMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }

        }

        private void PrepareBlackBerryMenu(PackageContext cntx, MenuItemCollection bbItems)
        {
            bbItems.Add(CreateMenuItem("BlackBerryUsers", "blackberry_users"));
        }

        private void PrepareSharePointMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.SharePointGroup"), "", imagePath + "sharepoint24.png", null);

            item.Selectable = false;

            PrepareSharePointMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareSharePointMenu(PackageContext cntx, MenuItemCollection spItems)
        {
            spItems.Add(CreateMenuItem("SiteCollections", "sharepoint_sitecollections"));
            spItems.Add(CreateMenuItem("StorageUsage", "sharepoint_storage_usage"));
            spItems.Add(CreateMenuItem("StorageLimits", "sharepoint_storage_settings"));
        }

        private void PrepareOCSMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.OCSGroup"), "", imagePath + "ocs16.png", null);

            item.Selectable = false;

            PrepareOCSMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareOCSMenu(PackageContext cntx, MenuItemCollection osItems)
        {
            osItems.Add(CreateMenuItem("OCSUsers", "ocs_users"));
        }

        private void PrepareLyncMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.LyncGroup"), "", imagePath + "lync16.png", null);

            item.Selectable = false;

            PrepareLyncMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareLyncMenu(PackageContext cntx, MenuItemCollection lyncItems)
        {
            lyncItems.Add(CreateMenuItem("LyncUsers", "lync_users"));

            lyncItems.Add(CreateMenuItem("LyncUserPlans", "lync_userplans"));


            if (Utils.CheckQouta(Quotas.LYNC_FEDERATION, cntx))
                lyncItems.Add(CreateMenuItem("LyncFederationDomains", "lync_federationdomains"));

            if (Utils.CheckQouta(Quotas.LYNC_PHONE, cntx))
                lyncItems.Add(CreateMenuItem("LyncPhoneNumbers", "lync_phonenumbers"));
        }

        private void PrepareEnterpriseStorageMenuRoot(PackageContext cntx, MenuItemCollection items, string imagePath)
        {
            MenuItem item = new MenuItem(GetLocalizedString("Text.EnterpriseStorageGroup"), "", imagePath + "spaces16.png", null);

            item.Selectable = false;

            PrepareEnterpriseStorageMenu(cntx, item.ChildItems);

            if (item.ChildItems.Count > 0)
            {
                items.Add(item);
            }
        }

        private void PrepareEnterpriseStorageMenu(PackageContext cntx, MenuItemCollection enterpriseStorageItems)
        {
            enterpriseStorageItems.Add(CreateMenuItem("EnterpriseStorageFolders", "enterprisestorage_folders"));
        }

        private MenuItem CreateMenuItem(string text, string key)
        {
            MenuItem item = new MenuItem();
        
            item.Text = GetLocalizedString("Text." + text);
            item.NavigateUrl = PortalUtils.EditUrl("ItemID", PanelRequest.ItemID.ToString(), key,
                "SpaceID=" + PanelSecurity.PackageId);

            return item;
        }
    }
}