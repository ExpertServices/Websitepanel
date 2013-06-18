using System.ServiceProcess;
using System.Threading;
using WebsitePanel.EnterpriseServer;

namespace WebsitePanel.SchedulerService
{
    public partial class SchedulerService : ServiceBase
    {
        private Timer _Timer;
        private static bool _isRuninng;
        #region Construcor

        public SchedulerService()
        {
            InitializeComponent();

            _Timer = new Timer(Process, null, 5000, 5000);
            _isRuninng = false;
        }

        #endregion

        #region Methods

        protected override void OnStart(string[] args)
        {
        }

        protected static void Process(object callback)
        {
            //check running service
            if (_isRuninng)
                return;

            _isRuninng = true;
             Scheduler.Start();
            _isRuninng = false;
        }

        #endregion
    }
}