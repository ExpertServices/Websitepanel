using System.ComponentModel;
using System.Configuration.Install;
using System.ServiceProcess;

namespace WebsitePanel.SchedulerService
{
    [RunInstaller(true)]
    public class SchedulerServiceInstaller : Installer
    {
        #region Constructor

        public SchedulerServiceInstaller()
        {
            var processInstaller = new ServiceProcessInstaller();
            var serviceInstaller = new ServiceInstaller();

            processInstaller.Account = ServiceAccount.LocalSystem;
            serviceInstaller.DisplayName = "WebsitePanel Scheduler";
            serviceInstaller.StartType = ServiceStartMode.Automatic;
            serviceInstaller.ServiceName = "WebsitePanel Scheduler";

            Installers.Add(processInstaller);
            Installers.Add(serviceInstaller);
        }

        #endregion
    }
}