using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Providers.DNS
{
	/// <summary>This class is a generic helper hosting the PowerShell runtime.</summary>
	/// <remarks>It's probably a good idea to move to some utility module.</remarks>
	public class PowerShellHelper: IDisposable
	{
		private static InitialSessionState s_session = null;

		static PowerShellHelper()
		{
			s_session = InitialSessionState.CreateDefault();
			// s_session.ImportPSModule( new string[] { "FileServerResourceManager" } );
		}

		public PowerShellHelper()
		{
			Log.WriteStart( "PowerShellHelper::ctor" );

			Runspace rs = RunspaceFactory.CreateRunspace( s_session );
			rs.Open();
			// rs.SessionStateProxy.SetVariable( "ConfirmPreference", "none" );

			this.runSpace = rs;
			Log.WriteEnd( "PowerShellHelper::ctor" );
		}

		public void Dispose()
		{
			try
			{
				if( this.runSpace == null )
					return;
				if( this.runSpace.RunspaceStateInfo.State == RunspaceState.Opened )
					this.runSpace.Close();
				this.runSpace = null;
			}
			catch( Exception ex )
			{
				Log.WriteError( "Runspace error", ex );
			}
		}

		public Runspace runSpace { get; private set; }

		public Collection<PSObject> RunPipeline( params Command[] pipelineCommands )
		{
			Log.WriteStart( "ExecuteShellCommand" );
			List<object> errorList = new List<object>();

			Collection<PSObject> results = null;
			using( Pipeline pipeLine = runSpace.CreatePipeline() )
			{
				// Add the command
				foreach( var cmd in pipelineCommands )
					pipeLine.Commands.Add( cmd );

				// Execute the pipeline and save the objects returned.
				results = pipeLine.Invoke();

				// Only non-terminating errors are delivered here.
				// Terminating errors raise exceptions instead.
				if( null != pipeLine.Error && pipeLine.Error.Count > 0 )
				{
					foreach( object item in pipeLine.Error.ReadToEnd() )
					{
						errorList.Add( item );
						string errorMessage = string.Format( "Invoke error: {0}", item );
						Log.WriteWarning( errorMessage );
					}
				}
			}
			// errors = errorList.ToArray();
			Log.WriteEnd( "ExecuteShellCommand" );
			return results;
		}
	}
}