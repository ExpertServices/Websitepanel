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
                name: FileSystemRouteNames.DeleteFiles,
                url: "files-group-action/delete",
                defaults: new { controller = "FileSystem", action = "DeleteFiles" }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.UploadFile,
                url: "upload-file/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "UploadFile" }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.DownloadFile,
                url: "download-file/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "DownloadFile" }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.ViewOfficeOnline,
                url: "office365/view/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ViewOfficeDocument", pathPart = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.EditOfficeOnline,
                url: "office365/edit/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "EditOfficeDocument", pathPart = UrlParameter.Optional }
                );

            //routes.MapRoute(
            //    name: FileSystemRouteNames.ShowOfficeOnlinePath,
            //    url: "office365/{org}/{*pathPart}",
            //    defaults: new { controller = "FileSystem", action = "ShowOfficeDocument", pathPart = UrlParameter.Optional }
            //    );

            routes.MapRoute(
                name: FileSystemRouteNames.ShowAdditionalContent,
                url: "show-additional-content/{*path}",
                defaults: new { controller = "FileSystem", action = "ShowAdditionalContent", path = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.ShowContentPath,
                url: "{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowContent", pathPart = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}",
                defaults: new { controller = "Account", action = "Login" }
            );
        }
    }
}
