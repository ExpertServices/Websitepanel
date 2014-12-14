using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Providers.DNS;

namespace WebsitePanel.Providers.DomainLookup
{
    public class DnsRecordInfo
    {
        public int Id { get; set; }
        public int DomainId { get; set; }
        public string DnsServer { get; set; }
        public DnsRecordType RecordType { get; set; }
        public string Value { get; set; }
        public DateTime Date { get; set; }
    }
}
