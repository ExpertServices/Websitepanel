using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Timers;

namespace WebsitePanel.SchedulerService
{
    public partial class SchedulerService : ServiceBase
    {
        #region Properties

        public Timer _Timer { get; protected set; }

        #endregion

        #region Construcor

        public SchedulerService()
        {
            InitializeComponent();
        }

        #endregion

        #region Methods

        protected override void OnStart(string[] args)
        {
        }

        protected override void OnStop()
        {
            _Timer.Dispose();
        }

        protected void Porcess(object state)
        {
        }

        #endregion
    }
}
