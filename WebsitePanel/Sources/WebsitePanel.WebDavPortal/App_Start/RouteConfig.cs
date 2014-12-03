using System.Web.Mvc;
using System.Web.Routing;

namespace WebsitePanel.WebDavPortal
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "FilePathRoute",
                url: "root/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowContent", pathPart = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: "Office365DocumentRoute",
                url: "office365/root/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowOfficeDocument", pathPart = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}",
                defaults: new { controller = "Account", action = "Login" }
            );
        }
    }
}
