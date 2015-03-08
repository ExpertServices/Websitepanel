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
    public static class BiosHelper
    {
        public static BiosInfo GetVMBios(PowerShellManager powerShell, string name, int generation)
        {
            BiosInfo info = new BiosInfo();

            // for Win2012R2+ and Win8.1+
            if (generation == 2)
            {
                Command cmd = new Command("Get-VMFirmware");

                cmd.Parameters.Add("VMName", name);

                Collection<PSObject> result = powerShell.Execute(cmd, false);
                if (result != null && result.Count > 0)
                {
                    info.NumLockEnabled = true;

                    List<string> startupOrders = new List<string>();
                    info.BootFromCD = false;

                    foreach (dynamic item in (IEnumerable)result[0].GetProperty("BootOrder"))
                    {
                        string bootType = item.BootType.ToString();

                        // bootFromCD
                        if (!startupOrders.Any() && bootType == "Drive")
                        {
                            var device = item.Device;
                            info.BootFromCD = device.GetType().Name == "DvdDrive";
                        }

                        // startupOrders
                        startupOrders.Add(bootType);
                    }

                    info.StartupOrder = startupOrders.ToArray();
                }
            }
            // for others win and linux
            else
            {
                Command cmd = new Command("Get-VMBios");

                cmd.Parameters.Add("VMName", name);

                Collection<PSObject> result = powerShell.Execute(cmd, false);
                if (result != null && result.Count > 0)
                {
                    info.NumLockEnabled = Convert.ToBoolean(result[0].GetProperty("NumLockEnabled"));

                    List<string> startupOrders = new List<string>();

                    foreach (var item in (IEnumerable)result[0].GetProperty("StartupOrder"))
                        startupOrders.Add(item.ToString());

                    info.StartupOrder = startupOrders.ToArray();
                    info.BootFromCD = false;
                    if (info.StartupOrder != null && info.StartupOrder.Length > 0)
                        info.BootFromCD = info.StartupOrder[0] == "CD";
                }
            }

            return info;
        }

        public static void UpdateBios(PowerShellManager powerShell, VirtualMachine vm, bool bootFromCD, bool numLockEnabled)
        {
            // for Win2012R2+ and Win8.1+
            if (vm.Generation == 2)
            {
                Command cmd = new Command("Set-VMFirmware");

                cmd.Parameters.Add("VMName", vm.Name);
                if (bootFromCD)
                    cmd.Parameters.Add("FirstBootDevice", DvdDriveHelper.GetPS(powerShell, vm.Name));
                else
                    cmd.Parameters.Add("FirstBootDevice", VirtualMachineHelper.GetVirtualHardDisksPS(powerShell, vm.Name).FirstOrDefault());

                powerShell.Execute(cmd, false);
            }
            // for others win and linux
            else
            {
                Command cmd = new Command("Set-VMBios");

                cmd.Parameters.Add("VMName", vm.Name);
                var bootOrder = bootFromCD
                    ? new[] { "CD", "IDE", "LegacyNetworkAdapter", "Floppy" }
                    : new[] { "IDE", "CD", "LegacyNetworkAdapter", "Floppy" };
                cmd.Parameters.Add("StartupOrder", bootOrder);

                powerShell.Execute(cmd, false);
            }
        }
    }
}
