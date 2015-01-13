using System.Web.Mvc;
using System.Web.Routing;
using WebsitePanel.WebDavPortal.UI.Routes;

namespace WebsitePanel.WebDavPortal
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            #region Account

            routes.MapRoute(
                name: AccountRouteNames.Logout,
                url: "account/logout",
                defaults: new { controller = "Account", action = "Logout" }
                );

            routes.MapRoute(
                name: AccountRouteNames.Login,
                url: "account/login",
                defaults: new { controller = "Account", action = "Login" }
                ); 

            #endregion

            routes.MapRoute(
                name: "Office365DocumentRoute",
                url: "office365/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowOfficeDocument", pathPart = UrlParameter.Optional }
                );
        
            routes.MapRoute(
                name: FileSystemRouteNames.FilePath,
                url: "{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowContent", pathPart = UrlParameter.Optional },
                constraints: new { org = new Constraints.OrganizationRouteConstraint() }
                );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}",
                defaults: new { controller = "Account", action = "Login" }
            );
        }
    }
}
