using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DomainDnsRecordsChanges
    {
        public string DnsServer { get; set; }

        public bool IsChanged { get; set; }

        public List<DomainDnsRecordCompare> DnsRecordsCompare { get; set; }

        public DomainDnsRecordsChanges()
        {
            DnsRecordsCompare = new List<DomainDnsRecordCompare>();
        }
    }
}
