using System.Collections;
using System.Collections.Generic;
using System.Linq;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDav.Core.Config.Entities
{
    public class OfficeOnlineCollection : AbstractConfigCollection, IReadOnlyCollection<OfficeOnlineElement>
    {
        private readonly IList<OfficeOnlineElement> _officeExtensions;

        public OfficeOnlineCollection()
        {
            IsEnabled = ConfigSection.OfficeOnline.IsEnabled;
            Url = ConfigSection.OfficeOnline.Url;
            NewFilePath = ConfigSection.OfficeOnline.CobaltNewFilePath;
            CobaltFileTtl = ConfigSection.OfficeOnline.CobaltFileTtl;
            _officeExtensions = ConfigSection.OfficeOnline.Cast<OfficeOnlineElement>().ToList();
        }

        public bool IsEnabled { get; private set; }
        public string Url { get; private set; }
        public string NewFilePath { get; private set; }
        public int CobaltFileTtl { get; private set; }

        public IEnumerator<OfficeOnlineElement> GetEnumerator()
        {
            return _officeExtensions.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public int Count
        {
            get { return _officeExtensions.Count; }
        }

        public bool Contains(string extension)
        {
            return _officeExtensions.Any(x=>x.Extension == extension);
        }
    }
}