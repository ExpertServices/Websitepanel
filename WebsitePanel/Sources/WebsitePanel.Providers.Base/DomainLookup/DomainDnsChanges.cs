using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DomainDnsChanges
    {
        public string DomainName { get; set; }
        public string Registrar { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public int PackageId { get; set; }

        public List<DnsRecordInfoChange> DnsChanges { get; set; }

        public DomainDnsChanges()
        {
            DnsChanges = new List<DnsRecordInfoChange>();
        }
    }
}
