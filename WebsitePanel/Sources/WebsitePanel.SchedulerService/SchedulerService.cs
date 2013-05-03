using System.ServiceProcess;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.SchedulerService
{
    public partial class SchedulerService : ServiceBase
    {
        #region Construcor

        public SchedulerService()
        {
            InitializeComponent();
        }

        #endregion

        #region Methods

        protected override void OnStart(string[] args)
        {
            Scheduler.Start();
        }

        #endregion
    }
}