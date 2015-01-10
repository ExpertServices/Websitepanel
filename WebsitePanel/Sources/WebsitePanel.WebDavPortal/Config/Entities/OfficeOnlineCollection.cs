using System.Collections;
using System.Collections.Generic;
using System.Linq;
using WebsitePanel.WebDavPortal.WebConfigSections;

namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class OfficeOnlineCollection : AbstractConfigCollection, IReadOnlyCollection<string>
    {
        private readonly IList<string> _officeExtensions;

        public OfficeOnlineCollection()
        {
            IsEnabled = ConfigSection.OfficeOnline.IsEnabled;
            Url = ConfigSection.OfficeOnline.Url;
            _officeExtensions = ConfigSection.OfficeOnline.Cast<OfficeOnlineElement>().Select(x => x.Extension).ToList();
        }

        public bool IsEnabled { get; private set; }
        public string Url { get; private set; }

        public IEnumerator<string> GetEnumerator()
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
            return _officeExtensions.Contains(extension);
        }
    }
}