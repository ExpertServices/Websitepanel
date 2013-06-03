using System.ServiceProcess;
using System.Threading;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.SchedulerService
{
    public partial class SchedulerService : ServiceBase
    {
        private Timer _timer = new Timer(Process, null, 5000, 5000);               

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

        protected static void Process(object callback)
        {
            Scheduler.Start();
        }

        #endregion
    }
}