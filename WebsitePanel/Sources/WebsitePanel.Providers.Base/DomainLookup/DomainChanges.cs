using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DomainChanges
    {
        public string Domain { get; set; }

        public List<DomainDnsRecordsChanges> DnsChanges { get; set; }

        public DomainChanges()
        {
            DnsChanges = new List<DomainDnsRecordsChanges>();
        }
    }
}
