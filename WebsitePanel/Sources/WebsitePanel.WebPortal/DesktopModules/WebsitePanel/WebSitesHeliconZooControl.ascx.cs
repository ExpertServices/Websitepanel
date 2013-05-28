using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.Providers.HeliconZoo;
using WebsitePanel.Providers.ResultObjects;
using WebsitePanel.Providers.Web;
using WebsitePanel.Providers.WebAppGallery;

namespace WebsitePanel.Portal
{
    public class ShortHeliconZooEngineComparer:IComparer<ShortHeliconZooEngine>
    {
        public int Compare(ShortHeliconZooEngine x, ShortHeliconZooEngine y)
        {
            return string.Compare(x.DisplayName, y.DisplayName, StringComparison.OrdinalIgnoreCase);
        }
    }

    public partial class WebSitesHeliconZooControl : WebsitePanelControlBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void BindWebItem(WebSite site)
        {
            ViewState["WebSiteId"] = site.SiteId;
            ViewState["WebSitePackageId"] = site.PackageId;

            BindEngines(site);
            BindInstalledApplications();
            BindApplications();
        }

        private void BindEngines(WebSite site)
        {
            // get allowed engines for current hosting plan
            ShortHeliconZooEngine[] allowedEngineArray =
                ES.Services.HeliconZoo.GetAllowedHeliconZooQuotasForPackage(site.PackageId);
            Array.Sort(allowedEngineArray, new ShortHeliconZooEngineComparer());


            

            // get enabled engines for this site from applicationHost.config
            string[] enabledEngineNames = ES.Services.HeliconZoo.GetEnabledEnginesForSite(site.SiteId, site.PackageId);
            ViewState["EnabledEnginesNames"] = enabledEngineNames;

            //console allowed in applicationHost.config
            ViewState["IsZooWebConsoleEnabled"] = enabledEngineNames.Contains("console", StringComparer.OrdinalIgnoreCase);
    
            


            List<ShortHeliconZooEngine> allowedEngines = new List<ShortHeliconZooEngine>(allowedEngineArray);

            foreach (ShortHeliconZooEngine engine in allowedEngines)
            {
                engine.Name = engine.Name.Replace("HeliconZoo.", "");
                //engine.Enabled = enabledEngineNames.Contains(engine.Name, StringComparer.OrdinalIgnoreCase);

                if (engine.Name == "console")
                {
                    //console allowed in hosting plan
                    ViewState["IsZooWebConsoleEnabled"] = engine.Enabled;
                }
   
            }

            ViewState["AllowedEngines"] = allowedEngines;

        }

        private void BindInstalledApplications()
        {
            if ((bool) ViewState["IsZooWebConsoleEnabled"])
            {
                gvInstalledApplications.DataSource = ES.Services.WebServers.GetZooApplications(PanelRequest.ItemID);
                gvInstalledApplications.DataBind();
            }
            else
            {
                gvInstalledApplications.Visible = false;
                lblConsole.Visible = false;
            }

        }

        private void BindApplications()
        {


            WebAppGalleryHelpers helper = new WebAppGalleryHelpers();

            GalleryApplicationsResult result = helper.GetGalleryApplications("ZooTemplate", PanelSecurity.PackageId);

            List<GalleryApplication> applications = result.Value as List<GalleryApplication>;
            List<GalleryApplication> filteredApplications = new List<GalleryApplication>();

            List<ShortHeliconZooEngine> allowedEngines = (List<ShortHeliconZooEngine>)ViewState["AllowedEngines"];
            if (null != allowedEngines)
            {
                foreach (GalleryApplication application in applications)
                {
                    

                    foreach (string keyword in application.Keywords)
                    {
                        bool appAlreadyAdded = false;
                        if (keyword.StartsWith("ZooEngine", StringComparison.OrdinalIgnoreCase))
                        {
                            string appEngine = keyword.Substring("ZooEngine".Length);
                            
                            foreach (ShortHeliconZooEngine engine in allowedEngines)
                            {
                                if (!engine.Enabled)
                                {
                                    continue; //skip
                                }

                                if (string.Equals(appEngine, engine.KeywordedName, StringComparison.OrdinalIgnoreCase))
                                {
                                    
                                    filteredApplications.Add(application);
                                    appAlreadyAdded = true;
                                    break;
                                }
                            }
                            if (appAlreadyAdded)
                            {
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                filteredApplications.AddRange(applications);
            }


            gvApplications.DataSource = filteredApplications;
            gvApplications.DataBind();
        }

        public void SaveWebItem(WebSite site)
        {
            UpdatedAllowedEngines();
        }

        protected void gvApplications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Install")
            {
                UpdatedAllowedEngines();
                Response.Redirect(GetWebAppInstallUrl(e.CommandArgument.ToString()));
            }
        }

        private void UpdatedAllowedEngines()
        {
            List<ShortHeliconZooEngine> allowedEngines = (List<ShortHeliconZooEngine>)ViewState["AllowedEngines"];
            string[] enabledEngineNames = (string[])ViewState["EnabledEnginesNames"];

            // check that all allowed engines are enabled
            bool allAllowedAreEnabled = true;

            if (allowedEngines.Count != enabledEngineNames.Length)
            {
                allAllowedAreEnabled = false;
            }
            else
            {
                foreach (ShortHeliconZooEngine allowedEngine in allowedEngines)
                {
                    if (!enabledEngineNames.Contains(allowedEngine.Name, StringComparer.OrdinalIgnoreCase))
                    {
                        allAllowedAreEnabled = false;
                    }
                }
            }

            if (!allAllowedAreEnabled)
            {
                List<string> updateEnabledEngineNames = new List<string>();

                // by default allow for site all engines allowed by hosting plan
                foreach (ShortHeliconZooEngine heliconZooEngine in allowedEngines)
                {
                    updateEnabledEngineNames.Add(heliconZooEngine.Name);
                }

                string siteId = ViewState["WebSiteId"] as string;
                int packageId = (int) ViewState["WebSitePackageId"];

                ES.Services.HeliconZoo.SetEnabledEnginesForSite(siteId, packageId, updateEnabledEngineNames.ToArray());
            }

        }

        protected void gvApplications_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvApplications.PageIndex = e.NewPageIndex;
            // categorized app list
            BindApplications();
        }

        protected string GetIconUrlOrDefault(string url)
        {
            if (string.IsNullOrEmpty(url))
            {
                return "/App_Themes/Default/icons/sphere_128.png";
            }

            return "~/DesktopModules/WebsitePanel/ResizeImage.ashx?width=120&height=120&url=" + Server.UrlEncode(url);
        }

        protected string GetWebAppInstallUrl(string appId)
        {
            //http://localhost:9001/Default.aspx?pid=SpaceWebApplicationsGallery&mid=122&ctl=edit&ApplicationID=DotNetNuke&SpaceID=7

            List<string> url = new List<string>();
            url.Add("pid=SpaceWebApplicationsGallery");
            url.Add("mid=122");
            url.Add("ctl=edit");
            url.Add("SpaceID="+PanelSecurity.PackageId.ToString(CultureInfo.InvariantCulture));
            url.Add("ApplicationID=" + appId);
            string siteId = ViewState["WebSiteId"] as string;
            if (!string.IsNullOrEmpty(siteId))
            {
                url.Add("SiteId="+siteId);
            }
            url.Add("ReturnUrl=" + Server.UrlEncode(Request.RawUrl));

            return "~/Default.aspx?" + String.Join("&", url.ToArray());
        }

        protected void gvInstalledApplications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EnableConsole")
            {
                UpdatedAllowedEngines();

                string appName = e.CommandArgument.ToString();

                ES.Services.WebServers.SetZooConsoleEnabled(PanelRequest.ItemID, appName);

                BindInstalledApplications();
            }

            if (e.CommandName == "DisableConsole")
            {
                UpdatedAllowedEngines();

                string appName = e.CommandArgument.ToString();

                ES.Services.WebServers.SetZooConsoleDisabled(PanelRequest.ItemID, appName);

                BindInstalledApplications();
            }

          
        }


        protected bool IsNullOrEmpty(string value)
        {
            return string.IsNullOrEmpty(value);
        }

        protected string GetConsoleFullUrl(string consoleUrl)
        {
            WebSite site = ES.Services.WebServers.GetWebSite(PanelRequest.ItemID);
            return "http://" + site.Name + consoleUrl;
        }
    }
}