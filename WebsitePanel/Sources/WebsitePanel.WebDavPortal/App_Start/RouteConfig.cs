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

            #region Owa

            routes.MapRoute(
                name: FileSystemRouteNames.ViewOfficeOnline,
                url: "office365/view/{org}/{*pathPart}",
                defaults:
                    new {controller = "FileSystem", action = "ViewOfficeDocument", pathPart = UrlParameter.Optional}
                );

            routes.MapRoute(
                name: FileSystemRouteNames.EditOfficeOnline,
                url: "office365/edit/{org}/{*pathPart}",
                defaults:
                    new {controller = "FileSystem", action = "EditOfficeDocument", pathPart = UrlParameter.Optional}
                );

            #endregion

            #region Enterprise storage 

            routes.MapRoute(
                    name: FileSystemRouteNames.ChangeWebDavViewType,
                    url: "storage/change-view-type/{viewType}",
                    defaults: new { controller = "FileSystem", action = "ChangeViewType" }
                    );

            routes.MapRoute(
                    name: FileSystemRouteNames.DeleteFiles,
                    url: "storage/files-group-action/delete",
                    defaults: new { controller = "FileSystem", action = "DeleteFiles" }
                    );

            routes.MapRoute(
                name: FileSystemRouteNames.UploadFile,
                url: "storage/upload-files/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "UploadFiles" }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.DownloadFile,
                url: "storage/download-file/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "DownloadFile" }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.ShowAdditionalContent,
                url: "storage/show-additional-content/{*path}",
                defaults: new { controller = "FileSystem", action = "ShowAdditionalContent", path = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.ShowContentDetails,
                url: "storage/details/{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "GetContentDetails", pathPart = UrlParameter.Optional }
                );

            routes.MapRoute(
                name: FileSystemRouteNames.ShowContentPath,
                url: "{org}/{*pathPart}",
                defaults: new { controller = "FileSystem", action = "ShowContent", pathPart = UrlParameter.Optional }
                ); 
            #endregion

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}",
                defaults: new { controller = "Account", action = "Login" }
            );
        }
    }
}
