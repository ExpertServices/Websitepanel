using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using WebsitePanel.WebPortal;
using System.Xml;

namespace WebsitePanel.Portal
{
    public partial class SearchObject : WebsitePanelModuleBase
    {
        const string TYPE_WEBSITE = "WebSite";
        const string TYPE_DOMAIN = "Domain";
        const string TYPE_ORGANIZATION = "Organization";
        const string TYPE_EXCHANGEACCOUNT = "ExchangeAccount";
        const string TYPE_RDSCOLLECTION = "RDSCollection";
        const string TYPE_LYNC = "LyncAccount";
        const string TYPE_FOLDER = "WebDAVFolder";
        const string TYPE_SHAREPOINT = "SharePointFoundationSiteCollection";
        const string TYPE_SHAREPOINTENTERPRISE = "SharePointEnterpriseSiteCollection";

        const string PID_SPACE_WEBSITES = "SpaceWebSites";
        const string PID_SPACE_DIMAINS = "SpaceDomains";
        const string PID_SPACE_EXCHANGESERVER = "SpaceExchangeServer";

        String m_strColTypes = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                var jsonSerialiser = new JavaScriptSerializer();
                String[] aTypes = jsonSerialiser.Deserialize<String[]>(tbFilters.Text);
                if ((aTypes != null) && (aTypes.Length > 0))
                    m_strColTypes = "'" + String.Join("','", aTypes) + "'";
                else
                    m_strColTypes = "";
            }
        }

        protected void odsObjectPaged_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["colType"] = m_strColTypes;
        }

        protected void odsObjectPaged_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                ProcessException(e.Exception.InnerException);
                e.ExceptionHandled = true;
            }
        }

        protected string GetTypeDisplayName(string type)
        {
            return GetSharedLocalizedString("ServiceItemType." + type)
                ?? GetSharedLocalizedString("UserItemType." + type)
                ?? type;
        }

        public string GetItemPageUrl(string fullType, string itemType, int itemId, int spaceId, int accountId, string textSearch = "")
        {
            string res = "";
            if (fullType.Equals("Users"))
            {
                res = PortalUtils.GetUserHomePageUrl(itemId);
            }
            else
            {
                switch (itemType)
                {
                    case TYPE_WEBSITE:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_WEBSITES, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, DefaultPage.CONTROL_ID_PARAM + "=" + "edit_item",
                            "moduleDefId=websites");
                        break;
                    case TYPE_DOMAIN:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_DIMAINS, "DomainID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, DefaultPage.CONTROL_ID_PARAM + "=" + "edit_item",
                            "moduleDefId=domains");
                        break;
                    case TYPE_ORGANIZATION:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, DefaultPage.CONTROL_ID_PARAM + "=" + "organization_home",
                            "moduleDefId=ExchangeServer");
                        break;
                    case TYPE_EXCHANGEACCOUNT:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, "ctl=edit_user",//"mid="+this.ModuleID.ToString(),
                            "AccountID=" + accountId, "Context=User",
                            "moduleDefId=ExchangeServer");
                        break;
                    case TYPE_RDSCOLLECTION:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, "ctl=rds_edit_collection",
                            "CollectionId=" + accountId, "moduleDefId=ExchangeServer");
                        break;
                    case TYPE_LYNC:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId.ToString(), "ctl=edit_lync_user",
                            "AccountID=" + accountId, "moduleDefId=ExchangeServer");
                        break;
                    case TYPE_FOLDER:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId.ToString(), "ctl=enterprisestorage_folder_settings",
                            "FolderID=" + textSearch, "moduleDefId=ExchangeServer");
                        break;
                    case TYPE_SHAREPOINT:
                    case TYPE_SHAREPOINTENTERPRISE:
                        res = PortalUtils.NavigatePageURL(PID_SPACE_EXCHANGESERVER, "ItemID", itemId.ToString(),
                            PortalUtils.SPACE_ID_PARAM + "=" + spaceId, "ctl=" + (itemType == TYPE_SHAREPOINT ? "sharepoint_edit_sitecollection" : "sharepoint_enterprise_edit_sitecollection"),
                            "SiteCollectionID=" + accountId, "moduleDefId=ExchangeServer");
                        break;
                    default:
                        res = PortalUtils.GetSpaceHomePageUrl(spaceId);
                        break;
                }
            }

            return res;
        }

    }
}