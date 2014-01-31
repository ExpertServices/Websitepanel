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
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Net;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Providers.DNS
{
	/// <summary>This class wraps MS DNS server PowerShell commands used by the WebsitePanel.</summary>
	internal static class DnsCommands
	{
		/// <summary>Add parameter to PS command</summary>
		/// <param name="cmd">command</param>
		/// <param name="name">Parameter name</param>
		/// <param name="value">Parameter value</param>
		/// <returns>Same command</returns>
		private static Command addParam( this Command cmd, string name, object value )
		{
			cmd.Parameters.Add( name, value );
			return cmd;
		}

		/// <summary>Add parameter without value to the PS command</summary>
		/// <param name="cmd">command</param>
		/// <param name="name">Parameter name</param>
		/// <returns>Same command</returns>
		private static Command addParam( this Command cmd, string name )
		{
			// http://stackoverflow.com/a/10304080/126995
			cmd.Parameters.Add( name, true );
			return cmd;
		}

		/// <summary>Create "Where-Object -Property ... -eq -Value ..." command</summary>
		/// <param name="property"></param>
		/// <param name="value"></param>
		/// <returns></returns>
		private static Command where( string property, object value )
		{
			return new Command( "Where-Object" )
				.addParam( "Property", property )
				.addParam( "eq" )
				.addParam( "Value", value );
		}

		/// <summary>Test-DnsServer -IPAddress 127.0.0.1</summary>
		/// <param name="ps">PowerShell host to use</param>
		/// <returns>true if localhost is an MS DNS server</returns>
		public static bool Test_DnsServer( this PowerShellHelper ps )
		{
			if( null == ps )
				throw new ArgumentNullException( "ps" );

			var cmd = new Command( "Test-DnsServer" )
				.addParam( "IPAddress", IPAddress.Loopback );

			PSObject res = ps.RunPipeline( cmd ).FirstOrDefault();

			if( null == res || null == res.Properties )
				return false;
			PSPropertyInfo p = res.Properties[ "Result" ];
			if( null == p || null == p.Value )
				return false;
			return p.Value.ToString() == "Success";
		}

		#region Zones

		/// <summary>Get-DnsServerZone | Select-Object -Property ZoneName</summary>
		/// <remarks>Only primary DNS zones are returned</remarks>
		/// <returns>Array of zone names</returns>
		public static string[] Get_DnsServerZone_Names( this PowerShellHelper ps )
		{
			var allZones = ps.RunPipeline( new Command( "Get-DnsServerZone" ),
				where( "IsAutoCreated", false ) );

			string[] res = allZones
				.Select( pso => new
				{
					name = (string)pso.Properties[ "ZoneName" ].Value,
					type = (string)pso.Properties[ "ZoneType" ].Value
				} )
				.Where( obj => obj.type == "Primary" )
				.Select( obj => obj.name )
				.ToArray();

			Log.WriteInfo( "Get_DnsServerZone_Names: {{{0}}}", String.Join( ", ", res ) );
			return res;
		}

		/// <summary>Returns true if the specified zone exists.</summary>
		/// <remarks>The PS pipeline being run: Get-DnsServerZone | Where-Object -Property ZoneName -eq -Value "name"</remarks>
		/// <param name="ps"></param>
		/// <param name="name"></param>
		/// <returns></returns>
		public static bool ZoneExists( this PowerShellHelper ps, string name )
		{
			Log.WriteStart( "ZoneExists {0}", name );
			bool res = ps.RunPipeline( new Command( "Get-DnsServerZone" ),
				where( "ZoneName", name ) )
				.Any();
			Log.WriteEnd( "ZoneExists: {0}", res );
			return res;
		}

		/* public enum eReplicationScope: byte
		{
			Custom, Domain, Forest, Legacy
		} */

		/// <summary></summary>
		/// <param name="ps"></param>
		/// <param name="zoneName"></param>
		/// <param name="replicationScope">Specifies a partition on which to store an Active Directory-integrated zone.</param>
		/// <returns></returns>
		public static void Add_DnsServerPrimaryZone( this PowerShellHelper ps, string zoneName, string[] secondaryServers )
		{
			Log.WriteStart( "Add_DnsServerPrimaryZone {0} {{{1}}}", zoneName, String.Join( ", ", secondaryServers ) );

			// Add-DnsServerPrimaryZone -Name zzz.com -ZoneFile zzz.com.dns
			var cmd = new Command( "Add-DnsServerPrimaryZone" );
			cmd.addParam( "Name", zoneName );
			cmd.addParam( "ZoneFile", zoneName + ".dns" );
			ps.RunPipeline( cmd );

			// Set-DnsServerPrimaryZone -Name zzz.com -SecureSecondaries ... -Notify ... Servers ..
			cmd = new Command( "Set-DnsServerPrimaryZone" );
			cmd.addParam( "Name", zoneName );

			if( secondaryServers == null || secondaryServers.Length == 0 )
			{
				// transfers are not allowed
				// inParams2[ "SecureSecondaries" ] = 3;
				// inParams2[ "Notify" ] = 0;
				cmd.addParam( "SecureSecondaries", "NoTransfer" );
				cmd.addParam( "Notify", "NoNotify" );
			}
			else if( secondaryServers.Length == 1 && secondaryServers[ 0 ] == "*" )
			{
				// allowed transfer from all servers
				// inParams2[ "SecureSecondaries" ] = 0;
				// inParams2[ "Notify" ] = 1;
				cmd.addParam( "SecureSecondaries", "TransferAnyServer" );
				cmd.addParam( "Notify", "Notify" );
			}
			else
			{
				// allowed transfer from specified servers
				// inParams2[ "SecureSecondaries" ] = 2;
				// inParams2[ "SecondaryServers" ] = secondaryServers;
				// inParams2[ "NotifyServers" ] = secondaryServers;
				// inParams2[ "Notify" ] = 2;
				cmd.addParam( "SecureSecondaries", "TransferToSecureServers" );
				cmd.addParam( "Notify", "NotifyServers" );
				cmd.addParam( "SecondaryServers", secondaryServers );
				cmd.addParam( "NotifyServers", secondaryServers );
			}
			ps.RunPipeline( cmd );
			Log.WriteEnd( "Add_DnsServerPrimaryZone" );
		}

		/// <summary>Call Add-DnsServerSecondaryZone cmdlet</summary>
		/// <param name="ps"></param>
		/// <param name="zoneName">a name of a zone</param>
		/// <param name="masterServers">an array of IP addresses of the master servers of the zone. You can use both IPv4 and IPv6.</param>
		public static void Add_DnsServerSecondaryZone( this PowerShellHelper ps, string zoneName, string[] masterServers )
		{
			// Add-DnsServerSecondaryZone -Name zzz.com -ZoneFile zzz.com.dns -MasterServers ...
			var cmd = new Command( "Add-DnsServerSecondaryZone" );
			cmd.addParam( "Name", zoneName );
			cmd.addParam( "ZoneFile", zoneName + ".dns" );
			cmd.addParam( "MasterServers", masterServers );
			ps.RunPipeline( cmd );
		}

		public static void Remove_DnsServerZone( this PowerShellHelper ps, string zoneName )
		{
			var cmd = new Command( "Remove-DnsServerZone" );
			cmd.addParam( "Name", zoneName );
			cmd.addParam( "Force" );
			ps.RunPipeline( cmd );
		}
		#endregion

		/// <summary>Get all records, except the SOA</summary>
		/// <param name="ps"></param>
		/// <param name="zoneName">Name of the zone</param>
		/// <returns>Array of records</returns>
		public static DnsRecord[] GetZoneRecords( this PowerShellHelper ps, string zoneName )
		{
			// Get-DnsServerResourceRecord -ZoneName xxxx.com
			var allRecords = ps.RunPipeline( new Command( "Get-DnsServerResourceRecord" ).addParam( "ZoneName", zoneName ) );

			return allRecords.Select( o => o.asDnsRecord( zoneName ) )
				.Where( r => null != r )
				.Where( r => r.RecordType != DnsRecordType.SOA )
			//	.Where( r => !( r.RecordName == "@" && DnsRecordType.NS == r.RecordType ) )
				.ToArray();
		}

		#region Records add / remove

		public static void Add_DnsServerResourceRecordA( this PowerShellHelper ps, string zoneName, string Name, string address )
		{
			var cmd = new Command( "Add-DnsServerResourceRecordA" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "IPv4Address", address );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordAAAA( this PowerShellHelper ps, string zoneName, string Name, string address )
		{
			var cmd = new Command( "Add-DnsServerResourceRecordAAAA" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "IPv6Address", address );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordCName( this PowerShellHelper ps, string zoneName, string Name, string alias )
		{
			var cmd = new Command( "Add-DnsServerResourceRecordCName" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "HostNameAlias", alias );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordMX( this PowerShellHelper ps, string zoneName, string Name, string mx, UInt16 pref )
		{
			var cmd = new Command( "Add-DnsServerResourceRecordMX" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "MailExchange", mx );
			cmd.addParam( "Preference", pref );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordNS( this PowerShellHelper ps, string zoneName, string Name, string NameServer )
		{
			var cmd = new Command( "Add-DnsServerResourceRecord" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "NS" );
			cmd.addParam( "NameServer", NameServer );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordTXT( this PowerShellHelper ps, string zoneName, string Name, string txt )
		{
			var cmd = new Command( "Add-DnsServerResourceRecord" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "Txt" );
			cmd.addParam( "DescriptiveText", txt );
			ps.RunPipeline( cmd );
		}

		public static void Add_DnsServerResourceRecordSRV( this PowerShellHelper ps, string zoneName, string Name, string DomainName, UInt16 Port, UInt16 Priority, UInt16 Weight )
		{
			var cmd = new Command( "Add-DnsServerResourceRecord" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "Srv" );
			cmd.addParam( "DomainName", DomainName );
			cmd.addParam( "Port", Port );
			cmd.addParam( "Priority", Priority );
			cmd.addParam( "Weight", Weight );
			ps.RunPipeline( cmd );
		}

		public static void Remove_DnsServerResourceRecord( this PowerShellHelper ps, string zoneName, string Name, string type )
		{
			// Remove-DnsServerResourceRecord -ZoneName xxxx.com -Name "@" -RRType Soa -Force
			var cmd = new Command( "Remove-DnsServerResourceRecord" );
			cmd.addParam( "ZoneName", zoneName );
			cmd.addParam( "Name", Name );
			cmd.addParam( "RRType", type );
			cmd.addParam( "Force" );
			ps.RunPipeline( cmd );
		}

		#endregion
	}
}