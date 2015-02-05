using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDavPortal.Extensions;

namespace WebsitePanel.WebDavPortal.FileOperations
{
    public class FileOpenerManager
    {
        private readonly IDictionary<string, FileOpenerType> _operationTypes = new Dictionary<string, FileOpenerType>();

        public FileOpenerManager()
        {
            if (WebDavAppConfigManager.Instance.OfficeOnline.IsEnabled)
                _operationTypes.AddRange(WebDavAppConfigManager.Instance.OfficeOnline.ToDictionary(x => x.Extension, y => FileOpenerType.OfficeOnline));
        }

        public FileOpenerType this[string fileExtension]
        {
            get
            {
                FileOpenerType result;
                if (_operationTypes.TryGetValue(fileExtension, out result) && CheckBrowserSupport())
                    return result;
                return FileOpenerType.Download;
            }
        }

        private bool CheckBrowserSupport()
        {
            var request = HttpContext.Current.Request;
            int supportedVersion;

            if (WebDavAppConfigManager.Instance.OwaSupportedBrowsers.TryGetValue(request.Browser.Browser, out supportedVersion) == false)
            {
                return false;
            }

            return supportedVersion <= request.Browser.MajorVersion;
        }
    }
}