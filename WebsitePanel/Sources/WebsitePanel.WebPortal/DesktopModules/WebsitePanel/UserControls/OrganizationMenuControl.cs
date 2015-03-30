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
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using WebsitePanel.EnterpriseServer;
using System.Xml;
using System.Collections.Generic;
using WebsitePanel.WebPortal;

namespace WebsitePanel.Portal.UserControls
{
    public class OrganizationMenuControl : WebsitePanelModuleBase
    {

        virtual public int PackageId
        {
            get { return PanelSecurity.PackageId; }
            set { }
        }

        virtual public int ItemID
        {
            get { return PanelRequest.ItemID; }
            set { }
        }


        private PackageContext cntx = null;
        virtual public PackageContext Cntx
        {
            get
            {
                if (cntx == null) cntx = PackagesHelper.GetCachedPackageContext(PackageId);
                return cntx;
            }
        }

        public bool ShortMenu = false;
        public bool ShowImg = false;

        public MenuItem OrganizationMenuRoot = null;
        public MenuItem ExchangeMenuRoot = null;

        public bool PutBlackBerryInExchange = false;

        public void BindMenu(MenuItemCollection items)
        {
            if ((PackageId <= 0) || (ItemID <= 0))
                return;

            //Organization menu group;
            if (Cntx.Groups.ContainsKey(ResourceGroups.HostedOrganizations))
                PrepareOrganizationMenuRoot(items);

            //Exchange menu group;
            if (Cntx.Groups.ContainsKey(ResourceGroups.Exchange))
                PrepareExchangeMenuRoot(items);

            //BlackBerry Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.BlackBerry))
                PrepareBlackBerryMenuRoot(items);

            //SharePoint menu group;
            if (Cntx.Groups.ContainsKey(ResourceGroups.SharepointFoundationServer))
                PrepareSharePointMenuRoot(items, GetLocalizedString("Text.SharePointFoundationServerGroup"), ResourceGroups.SharepointFoundationServer.Replace(" ", ""));

            if (Cntx.Groups.ContainsKey(ResourceGroups.SharepointServer))
                PrepareSharePointMenuRoot(items, GetLocalizedString("Text.SharePointServerGroup"), ResourceGroups.SharepointServer.Replace(" ", ""));

            //CRM Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.HostedCRM2013))
                PrepareCRM2013MenuRoot(items);
            else if (Cntx.Groups.ContainsKey(ResourceGroups.HostedCRM))
                PrepareCRMMenuRoot(items);

            //OCS Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.OCS))
                PrepareOCSMenuRoot(items);

            //Lync Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.Lync))
                PrepareLyncMenuRoot(items);

            //EnterpriseStorage Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.EnterpriseStorage))
                PrepareEnterpriseStorageMenuRoot(items);

            //Remote Desktop Services Menu
            if (Cntx.Groups.ContainsKey(ResourceGroups.RDS))
                PrepareRDSMenuRoot(items);
        }

        private void PrepareOrganizationMenuRoot(MenuItemCollection items)
        {
            bool hideItems = false;

            UserInfo user = UsersHelper.GetUser(PanelSecurity.EffectiveUserId);

            if (user != null)
            {
                if ((user.Role == UserRole.User) & (Utils.CheckQouta(Quotas.EXCHANGE2007_ISCONSUMER, Cntx)))
                    hideItems = true;
            }

            if (!hideItems)
            {
                if (ShortMenu)
                {
                    PrepareOrganizationMenu(items);
                }
                else
                {
                    MenuItem item;

                    if (OrganizationMenuRoot != null) 
                        item = OrganizationMenuRoot;
                    else
                        item = new MenuItem(GetLocalizedString("Text.OrganizationGroup"), "", "", null);

                    item.Selectable = false;

                    PrepareOrganizationMenu(item.ChildItems);

                    if ((item.ChildItems.Count > 0) && (OrganizationMenuRoot == null))
                    {
                        items.Add(item);
                    }

                    OrganizationMenuRoot = item;
                }
            }
        }

        private void PrepareOrganizationMenu(MenuItemCollection items)
        {
            if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, Cntx) == false)
            {
                if (Utils.CheckQouta(Quotas.ORGANIZATION_DOMAINS, Cntx))
                    items.Add(CreateMenuItem("DomainNames", "org_domains"));
            }
            
            if (Utils.CheckQouta(Quotas.ORGANIZATION_USERS, Cntx))
                items.Add(CreateMenuItem("Users", "users", @"Icons/user_48.png"));

            if (Utils.CheckQouta(Quotas.ORGANIZATION_DELETED_USERS, Cntx))
                items.Add(CreateMenuItem("DeletedUsers", "deleted_users", @"Icons/deleted_user_48.png"));

            if (Utils.CheckQouta(Quotas.ORGANIZATION_SECURITYGROUPS, Cntx))
                items.Add(CreateMenuItem("SecurityGroups", "secur_groups", @"Icons/group_48.png"));
        }

        private void PrepareExchangeMenuRoot(MenuItemCollection items)
        {
            bool hideItems = false;

            UserInfo user = UsersHelper.GetUser(PanelSecurity.EffectiveUserId);

            if (user != null)
            {
                if ((user.Role == UserRole.User) & (Utils.CheckQouta(Quotas.EXCHANGE2007_ISCONSUMER, Cntx)))
                    hideItems = true;
            }

            if (ShortMenu)
            {
                PrepareExchangeMenu(items, hideItems);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.ExchangeGroup"), "", "", null);

                item.Selectable = false;

                PrepareExchangeMenu(item.ChildItems, hideItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }

                ExchangeMenuRoot = item;
            }
        }

        private void PrepareExchangeMenu(MenuItemCollection exchangeItems, bool hideItems)
        {
            if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, Cntx))
                exchangeItems.Add(CreateMenuItem("Mailboxes", "mailboxes", @"Icons/mailboxes_48.png"));

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_CONTACTS, Cntx))
                exchangeItems.Add(CreateMenuItem("Contacts", "contacts", @"Icons/exchange_contacts_48.png"));

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_DISTRIBUTIONLISTS, Cntx))
                exchangeItems.Add(CreateMenuItem("DistributionLists", "dlists", @"Icons/exchange_dlists_48.png"));

            //if (ShortMenu) return;

            if (Utils.CheckQouta(Quotas.EXCHANGE2007_PUBLICFOLDERS, Cntx))
                exchangeItems.Add(CreateMenuItem("PublicFolders", "public_folders", @"Icons/public_folders_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_ACTIVESYNCALLOWED, Cntx))
                    exchangeItems.Add(CreateMenuItem("ActiveSyncPolicy", "activesync_policy", @"Icons/activesync_policy_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, Cntx))
                    exchangeItems.Add(CreateMenuItem("MailboxPlans", "mailboxplans", @"Icons/mailboxplans_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2013_ALLOWRETENTIONPOLICY, Cntx))
                    exchangeItems.Add(CreateMenuItem("RetentionPolicy", "retentionpolicy", @"Icons/retentionpolicy_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2013_ALLOWRETENTIONPOLICY, Cntx))
                    exchangeItems.Add(CreateMenuItem("RetentionPolicyTag", "retentionpolicytag", @"Icons/retentionpolicytag_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, Cntx))
                    exchangeItems.Add(CreateMenuItem("ExchangeDomainNames", "domains", @"Icons/domains_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_MAILBOXES, Cntx))
                    exchangeItems.Add(CreateMenuItem("StorageUsage", "storage_usage", @"Icons/storage_usages_48.png"));

            if (!hideItems)
                if (Utils.CheckQouta(Quotas.EXCHANGE2007_DISCLAIMERSALLOWED, Cntx))
                    exchangeItems.Add(CreateMenuItem("Disclaimers", "disclaimers", @"Icons/disclaimers_48.png"));

        }

        private void PrepareCRMMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareCRMMenu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.CRMGroup"), "", "", null);

                item.Selectable = false;

                PrepareCRMMenu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareCRMMenu(MenuItemCollection crmItems)
        {
            crmItems.Add(CreateMenuItem("CRMOrganization", "CRMOrganizationDetails", @"Icons/crm_orgs_48.png"));
            crmItems.Add(CreateMenuItem("CRMUsers", "CRMUsers", @"Icons/crm_users_48.png"));

            //if (ShortMenu) return;

            crmItems.Add(CreateMenuItem("StorageLimits", "crm_storage_settings", @"Icons/crm_storage_settings_48.png"));
        }

        private void PrepareCRM2013MenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareCRM2013Menu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.CRM2013Group"), "", "", null);

                item.Selectable = false;

                PrepareCRM2013Menu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareCRM2013Menu(MenuItemCollection crmItems)
        {
            crmItems.Add(CreateMenuItem("CRMOrganization", "CRMOrganizationDetails", @"Icons/crm_orgs_48.png"));
            crmItems.Add(CreateMenuItem("CRMUsers", "CRMUsers", @"Icons/crm_users_48.png"));

            //if (ShortMenu) return;

            crmItems.Add(CreateMenuItem("StorageLimits", "crm_storage_settings", @"Icons/crm_storage_settings_48.png"));
        }

        private void PrepareBlackBerryMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareBlackBerryMenu(items);
            }
            else
            {
                MenuItem item;
                bool additem = true;

                if (PutBlackBerryInExchange && (ExchangeMenuRoot != null))
                {
                    item = ExchangeMenuRoot;
                    additem = false;
                }
                else
                    item = new MenuItem(GetLocalizedString("Text.BlackBerryGroup"), "", "", null);

                item.Selectable = false;

                PrepareBlackBerryMenu(item.ChildItems);

                additem = additem && (item.ChildItems.Count > 0);

                if (additem)
                {
                    items.Add(item);
                }
            }

        }

        private void PrepareBlackBerryMenu(MenuItemCollection bbItems)
        {
            bbItems.Add(CreateMenuItem("BlackBerryUsers", "blackberry_users", @"Icons/blackberry_users_48.png"));
        }

        private void PrepareSharePointMenuRoot(MenuItemCollection items, string menuItemText, string group)
        {
            if (ShortMenu)
            {
                PrepareSharePointMenu(items, group);
            }
            else
            {
                MenuItem item = new MenuItem(menuItemText, "", "", null);

                item.Selectable = false;

                PrepareSharePointMenu(item.ChildItems, group);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareSharePointMenu(MenuItemCollection spItems, string group)
        {                        
            spItems.Add(CreateSharepointMenuItem("Text.SiteCollections", "sharepoint_sitecollections", @"Icons/sharepoint_sitecollections_48.png", group));
            spItems.Add(CreateSharepointMenuItem("Text.StorageUsage", "sharepoint_storage_usage", @"Icons/sharepoint_storage_usage_48.png", group));
            spItems.Add(CreateSharepointMenuItem("Text.StorageLimits", "sharepoint_storage_settings", @"Icons/sharepoint_storage_settings_48.png", group));
        }

        private MenuItem CreateSharepointMenuItem(string text, string key, string img, string group)
        {
            MenuItem item = new MenuItem();
            string PID_SPACE_EXCHANGE_SERVER = "SpaceExchangeServer";
            item.Text = GetLocalizedString(text);
            item.NavigateUrl = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGE_SERVER, "ItemID", ItemID.ToString(),
                PortalUtils.SPACE_ID_PARAM + "=" + PackageId, DefaultPage.CONTROL_ID_PARAM + "=" + key, "GroupName=" + group,
                "moduleDefId=exchangeserver");

            if (ShowImg)
            {
                item.ImageUrl = PortalUtils.GetThemedIcon(img);
            }

            return item;
        }

        private void PrepareOCSMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareOCSMenu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.OCSGroup"), "", "", null);

                item.Selectable = false;

                PrepareOCSMenu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareOCSMenu(MenuItemCollection osItems)
        {
            osItems.Add(CreateMenuItem("OCSUsers", "ocs_users"));
        }

        private void PrepareLyncMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareLyncMenu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.LyncGroup"), "", "", null);

                item.Selectable = false;

                PrepareLyncMenu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareLyncMenu(MenuItemCollection lyncItems)
        {
            lyncItems.Add(CreateMenuItem("LyncUsers", "lync_users", @"Icons/lync_users_48.png"));

            //if (ShortMenu) return;

            lyncItems.Add(CreateMenuItem("LyncUserPlans", "lync_userplans", @"Icons/lync_userplans_48.png"));


            if (Utils.CheckQouta(Quotas.LYNC_FEDERATION, Cntx))
                lyncItems.Add(CreateMenuItem("LyncFederationDomains", "lync_federationdomains", @"Icons/lync_federationdomains_48.png"));

            if (Utils.CheckQouta(Quotas.LYNC_PHONE, Cntx))
                lyncItems.Add(CreateMenuItem("LyncPhoneNumbers", "lync_phonenumbers", @"Icons/lync_phonenumbers_48.png"));
        }

        private void PrepareEnterpriseStorageMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareEnterpriseStorageMenu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.EnterpriseStorageGroup"), "", "", null);

                item.Selectable = false;

                PrepareEnterpriseStorageMenu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareEnterpriseStorageMenu(MenuItemCollection enterpriseStorageItems)
        {
            enterpriseStorageItems.Add(CreateMenuItem("EnterpriseStorageFolders", "enterprisestorage_folders", @"Icons/enterprisestorage_folders_48.png"));            
        }

        private void PrepareRDSMenuRoot(MenuItemCollection items)
        {
            if (ShortMenu)
            {
                PrepareRDSMenu(items);
            }
            else
            {
                MenuItem item = new MenuItem(GetLocalizedString("Text.RDSGroup"), "", "", null);

                item.Selectable = false;

                PrepareRDSMenu(item.ChildItems);

                if (item.ChildItems.Count > 0)
                {
                    items.Add(item);
                }
            }
        }

        private void PrepareRDSMenu(MenuItemCollection rdsItems)
        {
            rdsItems.Add(CreateMenuItem("RDSCollections", "rds_collections", null));

            if (Utils.CheckQouta(Quotas.RDS_SERVERS, Cntx) && (PanelSecurity.LoggedUser.Role != UserRole.User))
            {
                rdsItems.Add(CreateMenuItem("RDSServers", "rds_servers", null));
            }

            if (Utils.CheckQouta(Quotas.ENTERPRICESTORAGE_DRIVEMAPS, Cntx))
            {
                rdsItems.Add(CreateMenuItem("EnterpriseStorageDriveMaps", "enterprisestorage_drive_maps", @"Icons/enterprisestorage_drive_maps_48.png"));
            }
        }

        private MenuItem CreateMenuItem(string text, string key)
        {
            return CreateMenuItem(text, key, null);
        }

        virtual protected MenuItem CreateMenuItem(string text, string key, string img)
        {
            MenuItem item = new MenuItem();

            item.Text = GetLocalizedString("Text." + text);
            item.NavigateUrl = PortalUtils.EditUrl("ItemID", ItemID.ToString(), key,
                "SpaceID=" + PackageId);

            if (ShowImg)
            {
                if (img==null)
                    item.ImageUrl =  PortalUtils.GetThemedIcon("Icons/tool_48.png");
                else
                    item.ImageUrl =  PortalUtils.GetThemedIcon(img);
            }

            return item;
        }

    }
}
