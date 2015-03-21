using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;

namespace WebsitePanel.Providers.Virtualization
{
    public static class VirtualMachineHelper
    {
        public static OperationalStatus GetVMHeartBeatStatus(PowerShellManager powerShell, string name)
        {
            OperationalStatus status = OperationalStatus.None;

            Command cmd = new Command("Get-VMIntegrationService");

            cmd.Parameters.Add("VMName", name);
            cmd.Parameters.Add("Name", "HeartBeat");

            Collection<PSObject> result = powerShell.Execute(cmd, false);
            if (result != null && result.Count > 0)
            {
                var statusString = result[0].GetProperty("PrimaryOperationalStatus");

                if (statusString != null)
                    status = (OperationalStatus)Enum.Parse(typeof(OperationalStatus), statusString.ToString());
            }
            return status;
        }

        public static int GetVMProcessors(PowerShellManager powerShell, string name)
        {

            int procs = 0;

            Command cmd = new Command("Get-VMProcessor");

            cmd.Parameters.Add("VMName", name);

            Collection<PSObject> result = powerShell.Execute(cmd, false);
            if (result != null && result.Count > 0)
            {
                procs = Convert.ToInt32(result[0].GetProperty("Count"));

            }
            return procs;
        }

        public static MemoryInfo GetVMMemory(PowerShellManager powerShell, string name)
        {
            MemoryInfo info = new MemoryInfo();

            Command cmd = new Command("Get-VMMemory");

            cmd.Parameters.Add("VMName", name);

            Collection<PSObject> result = powerShell.Execute(cmd, false);
            if (result != null && result.Count > 0)
            {
                info.DynamicMemoryEnabled = Convert.ToBoolean(result[0].GetProperty("DynamicMemoryEnabled"));
                info.Startup = Convert.ToInt64(result[0].GetProperty("Startup")) / Constants.Size1M;
                info.Minimum = Convert.ToInt64(result[0].GetProperty("Minimum")) / Constants.Size1M;
                info.Maximum = Convert.ToInt64(result[0].GetProperty("Maximum")) / Constants.Size1M;
                info.Buffer = Convert.ToInt32(result[0].GetProperty("Buffer"));
                info.Priority = Convert.ToInt32(result[0].GetProperty("Priority"));
            }
            return info;
        }

        public static void UpdateProcessors(PowerShellManager powerShell, VirtualMachine vm, int cpuCores, int cpuLimitSettings, int cpuReserveSettings, int cpuWeightSettings)
        {
            Command cmd = new Command("Set-VMProcessor");

            cmd.Parameters.Add("VMName", vm.Name);
            cmd.Parameters.Add("Count", cpuCores);
            cmd.Parameters.Add("Maximum", Convert.ToInt64(cpuLimitSettings * 1000));
            cmd.Parameters.Add("Reserve", Convert.ToInt64(cpuReserveSettings * 1000));
            cmd.Parameters.Add("RelativeWeight", cpuWeightSettings);

            powerShell.Execute(cmd, false);
        }

        public static void UpdateMemory(PowerShellManager powerShell, VirtualMachine vm, long ramMB)
        {
            Command cmd = new Command("Set-VMMemory");

            cmd.Parameters.Add("VMName", vm.Name);
            cmd.Parameters.Add("StartupBytes", ramMB * Constants.Size1M);

            powerShell.Execute(cmd, false);
        }
    }
}
