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
    public static class NetworkAdapterHelper
    { 
        #region Constants
        
        private const string EXTERNAL_NETWORK_ADAPTER_NAME = "External Network Adapter";
        private const string PRIVATE_NETWORK_ADAPTER_NAME = "Private Network Adapter";
        private const string MANAGEMENT_NETWORK_ADAPTER_NAME = "Management Network Adapter";

        #endregion

        public static VirtualMachineNetworkAdapter[] Get(PowerShellManager powerShell, string vmName)
        {
            List<VirtualMachineNetworkAdapter> adapters = new List<VirtualMachineNetworkAdapter>();

            Command cmd = new Command("Get-VMNetworkAdapter");
            if (!string.IsNullOrEmpty(vmName)) cmd.Parameters.Add("VMName", vmName);

            Collection<PSObject> result = powerShell.Execute(cmd, false);
            if (result != null && result.Count > 0)
            {
                foreach (PSObject psAdapter in result)
                {
                    VirtualMachineNetworkAdapter adapter = new VirtualMachineNetworkAdapter();

                    adapter.Name = psAdapter.GetString("Name");
                    adapter.MacAddress = psAdapter.GetString("MacAddress");
                    adapter.SwitchName = psAdapter.GetString("SwitchName");

                    adapters.Add(adapter);
                }
            }
            return adapters.ToArray();
        }

        public static VirtualMachineNetworkAdapter Get(PowerShellManager powerShell, string vmName, string macAddress)
        {
            var adapters = Get(powerShell, vmName);
            return adapters.FirstOrDefault(a => a.MacAddress == macAddress);
        }

        public static void Update(PowerShellManager powerShell, VirtualMachine vm, string switchId, string portName, string macAddress, string adapterName, bool legacyAdapter)
        {
            // External NIC
            if (!vm.ExternalNetworkEnabled && !String.IsNullOrEmpty(vm.ExternalNicMacAddress))
            {
                // delete adapter
                Delete(powerShell, vm.Name, vm.ExternalNicMacAddress);
                vm.ExternalNicMacAddress = null; // reset MAC
            }
            else if (vm.ExternalNetworkEnabled && !String.IsNullOrEmpty(vm.ExternalNicMacAddress))
            {
                // add external adapter
                Add(powerShell, vm.Name, vm.ExternalSwitchId, vm.ExternalNicMacAddress, EXTERNAL_NETWORK_ADAPTER_NAME, vm.LegacyNetworkAdapter);
            }

            // Private NIC
            if (!vm.PrivateNetworkEnabled && !String.IsNullOrEmpty(vm.PrivateNicMacAddress))
            {
                Delete(powerShell, vm.Name, vm.PrivateNicMacAddress);
                vm.PrivateNicMacAddress = null; // reset MAC
            }
            else if (vm.PrivateNetworkEnabled && !String.IsNullOrEmpty(vm.PrivateNicMacAddress))
            {
                Add(powerShell, vm.Name, vm.ExternalSwitchId, vm.ExternalNicMacAddress, PRIVATE_NETWORK_ADAPTER_NAME, vm.LegacyNetworkAdapter);
            }
        }

        public static void Add(PowerShellManager powerShell, string vmName, string switchId, string macAddress, string adapterName, bool legacyAdapter)
        {
            //var dvd = Get(powerShell, vmName);

            //Command cmd = new Command("Add-VMDvdDrive");

            //cmd.Parameters.Add("VMName", vmName);
            //cmd.Parameters.Add("ControllerNumber", dvd.ControllerNumber);
            //cmd.Parameters.Add("ControllerLocation", dvd.ControllerLocation);

            //powerShell.Execute(cmd, false);
        }
        public static void Delete(PowerShellManager powerShell, string vmName, string macAddress)
        {
            //var dvd = Get(powerShell, vmName);

            //Command cmd = new Command("Add-VMDvdDrive");

            //cmd.Parameters.Add("VMName", vmName);
            //cmd.Parameters.Add("ControllerNumber", dvd.ControllerNumber);
            //cmd.Parameters.Add("ControllerLocation", dvd.ControllerLocation);

            //powerShell.Execute(cmd, false);
        }
    }
}
