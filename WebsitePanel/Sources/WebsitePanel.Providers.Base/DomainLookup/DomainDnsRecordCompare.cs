using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DomainDnsRecordCompare
    {
        public DnsRecordInfo DbRecord { get; set; }
        public DnsRecordInfo DnsRecord { get; set; }
        public DomainDnsRecordStatuses Status { get; set; }
    }
}
