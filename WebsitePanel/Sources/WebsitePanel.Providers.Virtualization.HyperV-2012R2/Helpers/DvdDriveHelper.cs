using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;

namespace WebsitePanel.Providers.Virtualization
{
    public static class DvdDriveHelper
    {
        public static DvdDriveInfo Get(PowerShellManager powerShell, string vmName)
        {
            DvdDriveInfo info = new DvdDriveInfo();

            Command cmd = new Command("Get-VMDvdDrive");

            cmd.Parameters.Add("VMName", vmName);

            Collection<PSObject> result = powerShell.Execute(cmd, false);

            if (result != null && result.Count > 0)
            {
                info.Id = result[0].GetString("Id");
                info.Name = result[0].GetString("Name");
                info.ControllerType = result[0].GetEnum<ControllerType>("ControllerType");
                info.ControllerNumber = result[0].GetInt("ControllerNumber");
                info.ControllerLocation = result[0].GetInt("ControllerLocation");
            }
            return info;
        }

        public static void Set(PowerShellManager powerShell, string vmName, string path)
        {
            var dvd = Get(powerShell, vmName);
 
            Command cmd = new Command("Set-VMDvdDrive");

            cmd.Parameters.Add("VMName", vmName);
            cmd.Parameters.Add("Path", path);
            cmd.Parameters.Add("ControllerNumber", dvd.ControllerNumber);
            cmd.Parameters.Add("ControllerLocation", dvd.ControllerLocation);

            powerShell.Execute(cmd, false);
        }

        public static void Update(PowerShellManager powerShell, VirtualMachine vm, bool dvdDriveShouldBeInstalled)
        {
            if (!vm.DvdDriveInstalled && dvdDriveShouldBeInstalled)
                Add(powerShell, vm.Name);
            else if (vm.DvdDriveInstalled && !dvdDriveShouldBeInstalled)
                Remove(powerShell, vm.Name);
        }

        public static void Add(PowerShellManager powerShell, string vmName)
        {
            var dvd = Get(powerShell, vmName);

            Command cmd = new Command("Add-VMDvdDrive");

            cmd.Parameters.Add("VMName", vmName);
            cmd.Parameters.Add("ControllerNumber", dvd.ControllerNumber);
            cmd.Parameters.Add("ControllerLocation", dvd.ControllerLocation);

            powerShell.Execute(cmd, false);
        }

        public static void Remove(PowerShellManager powerShell, string vmName)
        {
            var dvd = Get(powerShell, vmName);

            Command cmd = new Command("Remove-VMDvdDrive");

            cmd.Parameters.Add("VMName", vmName);
            cmd.Parameters.Add("ControllerNumber", dvd.ControllerNumber);
            cmd.Parameters.Add("ControllerLocation", dvd.ControllerLocation);

            powerShell.Execute(cmd, false);
        }
    }
}
