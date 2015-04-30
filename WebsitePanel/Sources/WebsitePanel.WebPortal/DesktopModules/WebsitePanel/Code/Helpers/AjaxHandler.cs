using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Data;
using WebsitePanel.Portal;

namespace WebsitePanel.WebPortal
{
    public class WebsitePanelAjaxHandler : IHttpHandler
    {
        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext context)
        {
            String filterValue = context.Request.Params["term"];
            String fullType = context.Request.Params["fullType"];
            String columnType = context.Request.Params["columnType"];
            String numResults = context.Request.Params["itemCount"];
            int iNumResults = 15;
            if ((numResults != null) && (numResults.Length > 0))
            {
                int num = Int32.Parse(numResults);
                if (num > 0)
                    iNumResults = num;
            }

            if (fullType == "Spaces")
            {
                String strItemType = context.Request.Params["itemType"];
                int itemType = Int32.Parse(strItemType);
                DataSet dsObjectItems = ES.Services.Packages.SearchServiceItemsPaged(PanelSecurity.EffectiveUserId, itemType,
                    String.Format("%{0}%", filterValue),
                   "", 0, iNumResults);
                DataTable dt = dsObjectItems.Tables[1];
                List<Dictionary<string, string>> dataList = new List<Dictionary<string, string>>();
                for (int i = 0; i < dt.Rows.Count; ++i)
                {
                    DataRow row = dt.Rows[i];
                    Dictionary<string, string> obj = new Dictionary<string, string>();
                    obj["ColumnType"] = "PackageName";
                    obj["TextSearch"] = row["PackageName"].ToString();
                    obj["ItemID"] = row["ItemID"].ToString();
                    obj["PackageID"] = row["PackageID"].ToString();
                    obj["FullType"] = "Space";
                    dataList.Add(obj);
                }

                var jsonSerialiser = new JavaScriptSerializer();
                var json = jsonSerialiser.Serialize(dataList);
                context.Response.ContentType = "text/plain";
                context.Response.Write(json);
            }
            else
            {
                DataSet dsObjectItems = ES.Services.Packages.GetSearchObject(PanelSecurity.EffectiveUserId, null,
                    String.Format("%{0}%", filterValue),
                   0, 0, "", 0, iNumResults, columnType, fullType);
                DataTable dt = dsObjectItems.Tables[2];
                List<Dictionary<string, string>> dataList = new List<Dictionary<string, string>>();
                for (int i = 0; i < dt.Rows.Count; ++i)
                {
                    DataRow row = dt.Rows[i];
                    if ((fullType == null) || (fullType.Length == 0) || (fullType == row["FullType"].ToString()))
                    {
                        Dictionary<string, string> obj = new Dictionary<string, string>();
                        obj["ColumnType"] = row["ColumnType"].ToString();
                        obj["TextSearch"] = row["TextSearch"].ToString();
                        obj["ItemID"] = row["ItemID"].ToString();
                        obj["PackageID"] = row["PackageID"].ToString();
                        obj["FullType"] = row["FullType"].ToString();
                        dataList.Add(obj);
                    }
                }

                var jsonSerialiser = new JavaScriptSerializer();
                var json = jsonSerialiser.Serialize(dataList);
                context.Response.ContentType = "text/plain";
                context.Response.Write(json);
            }
        }
    }
};