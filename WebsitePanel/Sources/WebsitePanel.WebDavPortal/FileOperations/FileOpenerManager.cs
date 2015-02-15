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

            string key = string.Empty;

            foreach (var supportedKey in WebDavAppConfigManager.Instance.OwaSupportedBrowsers.Keys)
            {
                if (supportedKey.Split(';').Contains(request.Browser.Browser))
                {
                    key = supportedKey;
                    break;
                }
            }

            if (WebDavAppConfigManager.Instance.OwaSupportedBrowsers.TryGetValue(key, out supportedVersion) == false)
            {
                return false;
            }

            return supportedVersion <= request.Browser.MajorVersion;
        }
    }
}