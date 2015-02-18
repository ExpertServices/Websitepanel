using System.Web.Optimization;

namespace WebsitePanel.WebDavPortal
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            var jQueryBundle = new ScriptBundle("~/bundles/jquery").Include(
                "~/Scripts/jquery-{version}.js",
                "~/Scripts/jquery.cookie.js");

            jQueryBundle.IncludeDirectory("~/Scripts", "jquery.dataTables.min.js", true);
            jQueryBundle.IncludeDirectory("~/Scripts", "dataTables.bootstrap.js", true);

            bundles.Add(jQueryBundle);

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                "~/Scripts/bootstrap.js",
                "~/Scripts/respond.js"));

            bundles.Add(new ScriptBundle("~/bundles/appScripts").Include(
                "~/Scripts/appScripts/authentication.js",
                "~/Scripts/appScripts/messages.js",
                "~/Scripts/appScripts/fileBrowsing.js",
                "~/Scripts/appScripts/dialogs.js",
                "~/Scripts/appScripts/wsp.js"
               ));

            bundles.Add(new ScriptBundle("~/bundles/appScripts/storage/bigIcons").Include(
                "~/Scripts/appScripts/recalculateResourseHeight.js",
                "~/Scripts/appScripts/uploadingData2.js"
               ));

            //bundles.Add(new ScriptBundle("~/bundles/appScripts/storage/table-view").Include(
            //  ));

            bundles.Add(new ScriptBundle("~/bundles/authScripts").Include(
               "~/Scripts/appScripts/authentication.js"));

            var styleBundle = new StyleBundle("~/Content/css");

            styleBundle.Include(
                "~/Content/bootstrap.css",
                "~/Content/site.css");

            styleBundle.IncludeDirectory("~/Content", "jquery.datatables.css", true);
            styleBundle.IncludeDirectory("~/Content", "dataTables.bootstrap.css", true);

            bundles.Add(styleBundle);

            // Set EnableOptimizations to false for debugging. For more information,
            // visit http://go.microsoft.com/fwlink/?LinkId=301862
            BundleTable.EnableOptimizations = true;
        }
    }
}