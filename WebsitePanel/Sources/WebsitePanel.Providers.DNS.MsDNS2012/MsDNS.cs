// Copyright (c) 2012 - 2013, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.Management;
using System.Collections.Generic;
using System.Text;
using Microsoft.Win32;

using WebsitePanel.Server.Utils;
using WebsitePanel.Providers.Utils;

namespace WebsitePanel.Providers.DNS
{
	public class MsDNS2012: HostingServiceProviderBase, IDnsServer
	{
		protected int ExpireLimit
		{
			get { return ProviderSettings.GetInt( "ExpireLimit" ); }
		}

		protected int MinimumTTL
		{
			get { return ProviderSettings.GetInt( "MinimumTTL" ); }
		}

		protected int RefreshInterval
		{
			get { return ProviderSettings.GetInt( "RefreshInterval" ); }
		}

		protected int RetryDelay
		{
			get { return ProviderSettings.GetInt( "RetryDelay" ); }
		}

		protected bool AdMode
		{
			get { return ProviderSettings.GetBool( "AdMode" ); }
		}

		private PowerShellHelper ps = null;
		private WmiHelper wmi = null;	//< We still need WMI because PowerShell doesn't support SOA updates.
		private bool bulkRecords;

		public MsDNS2012()
		{
			// Create PowerShell helper
			ps = new PowerShellHelper();
			if( !this.IsInstalled() )
				return;

			// Create WMI helper
			wmi = new WmiHelper( "root\\MicrosoftDNS" );
		}

		#region Zones

		public virtual string[] GetZones()
		{
			return ps.Get_DnsServerZone_Names();
		}

		public virtual bool ZoneExists( string zoneName )
		{
			return ps.ZoneExists( zoneName );
		}

		public virtual DnsRecord[] GetZoneRecords( string zoneName )
		{
			return ps.GetZoneRecords( zoneName );
		}

		public virtual void AddPrimaryZone( string zoneName, string[] secondaryServers )
		{
			ps.Add_DnsServerPrimaryZone( zoneName, secondaryServers );

			// delete orphan NS records
			DeleteOrphanNsRecords( zoneName );
		}

		public virtual void AddSecondaryZone( string zoneName, string[] masterServers )
		{
			ps.Add_DnsServerSecondaryZone( zoneName, masterServers );

			// delete orphan NS records
			DeleteOrphanNsRecords( zoneName );
		}

		public virtual void DeleteZone( string zoneName )
		{
			try
			{
				ps.Remove_DnsServerZone( zoneName );
			}
			catch( Exception ex )
			{
				Log.WriteError( ex );
			}
		}

		public virtual void AddZoneRecord( string zoneName, DnsRecord record )
		{
			try
			{
				string name = record.RecordName;
				if( String.IsNullOrEmpty( name ) )
					name = ".";

				if( record.RecordType == DnsRecordType.A )
					ps.Add_DnsServerResourceRecordA( zoneName, name, record.RecordData );
				else if( record.RecordType == DnsRecordType.AAAA )
					ps.Add_DnsServerResourceRecordAAAA( zoneName, name, record.RecordData );
				else if( record.RecordType == DnsRecordType.CNAME )
					ps.Add_DnsServerResourceRecordCName( zoneName, name, record.RecordData );
				else if( record.RecordType == DnsRecordType.MX )
					ps.Add_DnsServerResourceRecordMX( zoneName, name, record.RecordData, (ushort)record.MxPriority );
				else if( record.RecordType == DnsRecordType.NS )
					ps.Add_DnsServerResourceRecordNS( zoneName, name, record.RecordData );
				else if( record.RecordType == DnsRecordType.TXT )
					ps.Add_DnsServerResourceRecordTXT( zoneName, name, record.RecordData );
				else if( record.RecordType == DnsRecordType.SRV )
					ps.Add_DnsServerResourceRecordSRV( zoneName, name, record.RecordData, (ushort)record.SrvPort, (ushort)record.SrvPriority, (ushort)record.SrvWeight );
				else
					throw new Exception( "Unknown record type" );
			}
			catch( Exception ex )
			{
				// log exception
				Log.WriteError( ex );
			}
		}

		public virtual void AddZoneRecords( string zoneName, DnsRecord[] records )
		{
			bulkRecords = true;
			try
			{
				foreach( DnsRecord record in records )
					AddZoneRecord( zoneName, record );
			}
			finally
			{
				bulkRecords = false;
			}

			UpdateSoaRecord( zoneName );
		}

		public virtual void DeleteZoneRecord( string zoneName, DnsRecord record )
		{
			try
			{
				string rrType;
				if( !RecordTypes.rrTypeFromRecord.TryGetValue( record.RecordType, out rrType ) )
					throw new Exception( "Unknown record type" );
				ps.Remove_DnsServerResourceRecord( zoneName, record.RecordName, rrType );
			}
			catch( Exception ex )
			{
				// log exception
				Log.WriteError( ex );
			}
		}

		public virtual void DeleteZoneRecords( string zoneName, DnsRecord[] records )
		{
			foreach( DnsRecord record in records )
				DeleteZoneRecord( zoneName, record );
		}

		public void AddZoneRecord( string zoneName, string recordText )
		{
			try
			{
				Log.WriteStart( string.Format( "Adding MS DNS Server zone '{0}' record '{1}'", zoneName, recordText ) );
				AddDnsRecord( zoneName, recordText );
				Log.WriteEnd( "Added MS DNS Server zone record" );
			}
			catch( Exception ex )
			{
				Log.WriteError( ex );
				throw;
			}
		}
		#endregion

		#region SOA Record
		public virtual void UpdateSoaRecord( string zoneName, string host, string primaryNsServer, string primaryPerson )
		{
			host = CorrectHostName( zoneName, host );

			// delete record if exists
			DeleteSoaRecord( zoneName );

			// format record data
			string recordText = GetSoaRecordText( host, primaryNsServer, primaryPerson );

			// add record
			AddDnsRecord( zoneName, recordText );

			// update SOA record
			UpdateSoaRecord( zoneName );
		}

		private void DeleteSoaRecord( string zoneName )
		{
			// TODO: find a PowerShell replacement

			string query = String.Format( "SELECT * FROM MicrosoftDNS_SOAType " +
	"WHERE OwnerName = '{0}'",
	zoneName );
			using( ManagementObjectCollection objRRs = wmi.ExecuteQuery( query ) )
			{
				foreach( ManagementObject objRR in objRRs ) using( objRR )
						objRR.Delete();
			}

			// This doesn't work: no errors in PS, but the record stays in the DNS
			/* try
			{
				ps.Remove_DnsServerResourceRecord( zoneName, "@", "Soa" );
			}
			catch( System.Exception ex )
			{
				Log.WriteWarning( "{0}", ex.Message );
			} */
		}

		private string GetSoaRecordText( string host, string primaryNsServer, string primaryPerson )
		{
			return String.Format( "{0} IN SOA {1} {2} 1 900 600 86400 3600", host, primaryNsServer, primaryPerson );
		}

		private static string RemoveTrailingDot( string str )
		{
			return ( str.EndsWith( "." ) ) ? str.Substring( 0, str.Length - 1 ) : str;
		}

		private void UpdateSoaRecord( string zoneName )
		{
			if( bulkRecords )
				return;

			// TODO: find a PowerShell replacement

			// get existing SOA record in order to read serial number
			try
			{

				ManagementObject objSoa = wmi.GetWmiObject( "MicrosoftDNS_SOAType", "ContainerName = '{0}'", RemoveTrailingDot( zoneName ) );

				if( objSoa != null )
				{
					if( objSoa.Properties[ "OwnerName" ].Value.Equals( zoneName ) )
					{
						string primaryServer = (string)objSoa.Properties[ "PrimaryServer" ].Value;
						string responsibleParty = (string)objSoa.Properties[ "ResponsibleParty" ].Value;
						UInt32 serialNumber = (UInt32)objSoa.Properties[ "SerialNumber" ].Value;

						// update record's serial number
						string sn = serialNumber.ToString();
						string todayDate = DateTime.Now.ToString( "yyyyMMdd" );
						if( sn.Length < 10 || !sn.StartsWith( todayDate ) )
						{
							// build a new serial number
							sn = todayDate + "01";
							serialNumber = UInt32.Parse( sn );
						}
						else
						{
							// just increment serial number
							serialNumber += 1;
						}

						// update SOA record
						using( ManagementBaseObject methodParams = objSoa.GetMethodParameters( "Modify" ) )
						{
							methodParams[ "ResponsibleParty" ] = responsibleParty;
							methodParams[ "PrimaryServer" ] = primaryServer;
							methodParams[ "SerialNumber" ] = serialNumber;

							methodParams[ "ExpireLimit" ] = ExpireLimit;
							methodParams[ "MinimumTTL" ] = MinimumTTL;
							methodParams[ "TTL" ] = MinimumTTL;
							methodParams[ "RefreshInterval" ] = RefreshInterval;
							methodParams[ "RetryDelay" ] = RetryDelay;

							ManagementBaseObject outParams = objSoa.InvokeMethod( "Modify", methodParams, null );
						}
						//
						objSoa.Dispose();
					}

				}
			}
			catch( Exception ex )
			{
				Log.WriteError( ex );
			}
		}

		#endregion

		private void DeleteOrphanNsRecords( string zoneName )
		{
			// TODO: find a PowerShell replacement
			string machineName = System.Net.Dns.GetHostEntry( "LocalHost" ).HostName.ToLower();
			string computerName = Environment.MachineName.ToLower();

			using( ManagementObjectCollection objRRs = wmi.ExecuteQuery( String.Format( "SELECT * FROM MicrosoftDNS_NSType WHERE DomainName = '{0}'", zoneName ) ) )
			{
				foreach( ManagementObject objRR in objRRs )
				{
					using( objRR )
					{
						string ns = ( (string)objRR.Properties[ "NSHost" ].Value ).ToLower();
						if( ns.StartsWith( machineName ) || ns.StartsWith( computerName ) )
							objRR.Delete();

					}
				}
			}
		}

		#region private helper methods

		private string GetDnsServerName()
		{
			// TODO: find a PowerShell replacement
			using( ManagementObject objServer = wmi.GetObject( "MicrosoftDNS_Server.Name=\".\"" ) )
			{
				return (string)objServer.Properties[ "Name" ].Value;
			}
		}

		private string AddDnsRecord( string zoneName, string recordText )
		{
			// get the name of the server
			string serverName = GetDnsServerName();

			// TODO: find a PowerShell replacement
			// add record
			using( ManagementClass clsRR = wmi.GetClass( "MicrosoftDNS_ResourceRecord" ) )
			{
				object[] prms = new object[] { serverName, zoneName, recordText, null };
				clsRR.InvokeMethod( "CreateInstanceFromTextRepresentation", prms );
				return (string)prms[ 3 ];
			}
		}

		private string CorrectHostName( string zoneName, string host )
		{
			// if host is empty or null
			if( host == null || host == "" )
				return zoneName;

				// if there are not dot at all
			else if( host.IndexOf( "." ) == -1 )
				return host + "." + zoneName;

				// if only one dot at the end
			else if( host[ host.Length - 1 ] == '.' && host.IndexOf( "." ) == ( host.Length - 1 ) )
				return host + zoneName;

				// other cases
			else
				return host;
		}
		#endregion

		public override void DeleteServiceItems( ServiceProviderItem[] items )
		{
			foreach( ServiceProviderItem item in items )
			{
				if( item is DnsZone )
				{
					try
					{
						// delete DNS zone
						DeleteZone( item.Name );
					}
					catch( Exception ex )
					{
						Log.WriteError( String.Format( "Error deleting '{0}' MS DNS zone", item.Name ), ex );
					}
				}
			}
		}

		public override bool IsInstalled()
		{
			return ps.Test_DnsServer();
		}
	}
}