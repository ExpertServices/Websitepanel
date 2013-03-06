using System;
using Microsoft.Web.Administration;
using Microsoft.Web.Management.Server;
using WebsitePanel.Providers.Web.Iis.Common;

namespace WebsitePanel.Providers.Web.Compression
{

    internal static class CompressionGlobals
    {
        public const int DynamicCompression = 1;
        public const int StaticCompression = 2;
    }


    internal sealed class CompressionModuleService : ConfigurationModuleService
    {
        public const string DynamicCompression = "doDynamicCompression";
        public const string StaticCompression = "doStaticCompression";

        public PropertyBag GetSettings(ServerManager srvman, string siteId)
        {
            var config = srvman.GetApplicationHostConfiguration();
            //
            var section = config.GetSection(Constants.CompressionSection, siteId);
            //
            PropertyBag bag = new PropertyBag();
            //
            bag[CompressionGlobals.DynamicCompression] = Convert.ToBoolean(section.GetAttributeValue(DynamicCompression));
            bag[CompressionGlobals.StaticCompression] = Convert.ToBoolean(section.GetAttributeValue(StaticCompression));
            //
            return bag;
        }

        public void SetSettings(string virtualPath, bool doDynamicCompression, bool doStaticCompression)
        {
            using (var srvman = GetServerManager())
            {
                var config = srvman.GetApplicationHostConfiguration();
                //
                var section = config.GetSection(Constants.CompressionSection, virtualPath);
                //
                section.SetAttributeValue(DynamicCompression, doDynamicCompression);
                section.SetAttributeValue(StaticCompression, doStaticCompression);

                //
                srvman.CommitChanges();
            }
        }

      
    }
}
