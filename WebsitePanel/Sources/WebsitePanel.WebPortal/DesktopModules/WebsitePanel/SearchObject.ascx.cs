using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using WebsitePanel.WebPortal;

namespace WebsitePanel.Portal
{
    public partial class SearchObject : WebsitePanelModuleBase
    {
        const string TYPE_WEBSITE = "WebSite";
        const string TYPE_DOMAIN = "Domain";
        const string TYPE_ORGANIZATION = "Organization";
        const string TYPE_EXCHANGEACCOUNT = "ExchangeAccount";
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

        public string GetItemPageUrl(string fullType, string itemType, int itemId, int spaceId, int accountId)
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
                    default:
                        res = PortalUtils.GetSpaceHomePageUrl(itemId);
                        break;
                }
            }

            return res;
        }

    }
}