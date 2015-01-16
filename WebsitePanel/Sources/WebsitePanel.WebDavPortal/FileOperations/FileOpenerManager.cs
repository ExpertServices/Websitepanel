using System.Collections.Generic;
using System.Linq;
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
                _operationTypes.AddRange(WebDavAppConfigManager.Instance.OfficeOnline.ToDictionary(x => x, y => FileOpenerType.OfficeOnline));
        }

        public FileOpenerType this[string fileExtension]
        {
            get
            {
                FileOpenerType result;
                if (_operationTypes.TryGetValue(fileExtension, out result))
                    return result;
                return FileOpenerType.Download;
            }
        }
    }
}