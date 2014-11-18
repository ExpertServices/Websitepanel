using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DomainChanges
    {
        public string Domain { get; set; }

        public List<DomainDnsRecordsChanges> MxChanges { get; set; }
        public List<DomainDnsRecordsChanges> NsChanges { get; set; }

        public DomainChanges()
        {
            MxChanges = new List<DomainDnsRecordsChanges>();
            NsChanges = new List<DomainDnsRecordsChanges>();
        }
    }
}
