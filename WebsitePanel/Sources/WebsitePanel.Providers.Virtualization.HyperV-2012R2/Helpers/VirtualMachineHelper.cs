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
        #region Constants
  
        private const Int64 Size1G = 0x40000000;
        private const Int64 Size1M = 0x100000;

        #endregion

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
                info.Startup = Convert.ToInt64(result[0].GetProperty("Startup")) / Size1M;
                info.Minimum = Convert.ToInt64(result[0].GetProperty("Minimum")) / Size1M;
                info.Maximum = Convert.ToInt64(result[0].GetProperty("Maximum")) / Size1M;
                info.Buffer = Convert.ToInt32(result[0].GetProperty("Buffer"));
                info.Priority = Convert.ToInt32(result[0].GetProperty("Priority"));
            }
            return info;
        }


        public static VirtualHardDiskInfo[] GetVirtualHardDisks(PowerShellManager powerShell, string name)
        {
            List<VirtualHardDiskInfo> disks = new List<VirtualHardDiskInfo>();

            Collection<PSObject> result = GetVirtualHardDisksPS(powerShell, name);

            if (result != null && result.Count > 0)
            {
                foreach (PSObject d in result)
                {
                    VirtualHardDiskInfo disk = new VirtualHardDiskInfo();

                    disk.SupportPersistentReservations = Convert.ToBoolean(d.GetProperty("SupportPersistentReservations"));
                    disk.MaximumIOPS = Convert.ToUInt64(d.GetProperty("MaximumIOPS"));
                    disk.MinimumIOPS = Convert.ToUInt64(d.GetProperty("MinimumIOPS"));
                    disk.VHDControllerType = d.GetEnum<ControllerType>("ControllerType");
                    disk.ControllerNumber = Convert.ToInt32(d.GetProperty("ControllerNumber"));
                    disk.ControllerLocation = Convert.ToInt32(d.GetProperty("ControllerLocation"));
                    disk.Path = d.GetProperty("Path").ToString();
                    disk.Name = d.GetProperty("Name").ToString();

                    GetVirtualHardDiskDetail(powerShell, disk.Path, ref disk);

                    disks.Add(disk);
                }
            }
            return disks.ToArray();
        }

        public static Collection<PSObject> GetVirtualHardDisksPS(PowerShellManager powerShell, string name)
        {
            Command cmd = new Command("Get-VMHardDiskDrive");
            cmd.Parameters.Add("VMName", name);

            return powerShell.Execute(cmd, false);
        }

        public static void GetVirtualHardDiskDetail(PowerShellManager powerShell, string path, ref VirtualHardDiskInfo disk)
        {
            if (!string.IsNullOrEmpty(path))
            {
                Command cmd = new Command("Get-VHD");
                cmd.Parameters.Add("Path", path);
                Collection<PSObject> result = powerShell.Execute(cmd, false);
                if (result != null && result.Count > 0)
                {
                    disk.DiskFormat = result[0].GetEnum<VirtualHardDiskFormat>("VhdFormat");
                    disk.DiskType = result[0].GetEnum<VirtualHardDiskType>("VhdType");
                    disk.ParentPath = result[0].GetProperty<string>("ParentPath");
                    disk.MaxInternalSize = Convert.ToInt64(result[0].GetProperty("Size")) / Size1G;
                    disk.FileSize = Convert.ToInt64(result[0].GetProperty("FileSize")) / Size1G;
                    disk.Attached = Convert.ToBoolean(result[0].GetProperty("Attached"));
                }
            }
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
            cmd.Parameters.Add("StartupBytes", ramMB * Size1M);

            powerShell.Execute(cmd, false);
        }
    }
}
