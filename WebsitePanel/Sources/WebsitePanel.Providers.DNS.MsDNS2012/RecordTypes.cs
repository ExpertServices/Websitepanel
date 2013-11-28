using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace WebsitePanel.Providers.DNS
{
	/// <summary>This static class holds 2 lookup tables, from/to DnsRecordType enum</summary>
	internal static class RecordTypes
	{
		static readonly Dictionary<string, DnsRecordType> s_lookup;
		static readonly Dictionary<DnsRecordType, string> s_lookupInv;

		static RecordTypes()
		{
			s_lookup = new Dictionary<string, DnsRecordType>()
			{
				{ "A",     DnsRecordType.A     },
				{ "AAAA",  DnsRecordType.AAAA  },
				{ "NS",    DnsRecordType.NS    },
				{ "MX",    DnsRecordType.MX    },
				{ "CNAME", DnsRecordType.CNAME },
				{ "SOA",   DnsRecordType.SOA   },
				{ "TXT",   DnsRecordType.TXT   },
				{ "SRV",   DnsRecordType.SRV   },
			};

			TextInfo ti = new CultureInfo( "en-US", false ).TextInfo;

			s_lookupInv = s_lookup
				.ToDictionary( kvp => kvp.Value, kvp => ti.ToTitleCase( kvp.Key ) );
		}

		/// <summary>The dictionary that maps string record types to DnsRecordType enum</summary>
		public static Dictionary<string, DnsRecordType> recordFromString { get { return s_lookup; } }

		/// <summary>the dictionary that maps DnsRecordType enum to strings, suitable for PowerShell </summary>
		public static Dictionary<DnsRecordType, string> rrTypeFromRecord { get { return s_lookupInv; } }
	}
}