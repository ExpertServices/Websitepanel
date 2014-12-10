using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Portal.UserControls.ScheduleTaskView;

namespace WebsitePanel.Portal.ScheduleTaskControls
{
    public partial class DomainExpirationView : EmptyView
    {
        private static readonly string DaysBeforeParameter = "DAYS_BEFORE";
        private static readonly string MailToParameter = "MAIL_TO";
        private static readonly string EnableNotificationParameter = "ENABLE_NOTIFICATION";
        private static readonly string IncludeNonExistenDomainsParameter = "INCLUDE_NONEXISTEN_DOMAINS";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Sets scheduler task parameters on view.
        /// </summary>
        /// <param name="parameters">Parameters list to be set on view.</param>
        public override void SetParameters(ScheduleTaskParameterInfo[] parameters)
        {
            base.SetParameters(parameters);

            this.SetParameter(this.txtDaysBeforeNotify, DaysBeforeParameter);
            this.SetParameter(this.txtMailTo, MailToParameter);
            this.SetParameter(this.cbEnableNotify, EnableNotificationParameter);
            this.SetParameter(this.cbIncludeNonExistenDomains, IncludeNonExistenDomainsParameter);
        }

        /// <summary>
        /// Gets scheduler task parameters from view.
        /// </summary>
        /// <returns>Parameters list filled  from view.</returns>
        public override ScheduleTaskParameterInfo[] GetParameters()
        {
            ScheduleTaskParameterInfo daysBefore = this.GetParameter(this.txtDaysBeforeNotify, DaysBeforeParameter);
            ScheduleTaskParameterInfo mailTo = this.GetParameter(this.txtMailTo, MailToParameter);
            ScheduleTaskParameterInfo enableNotification = this.GetParameter(this.cbEnableNotify, EnableNotificationParameter);
            ScheduleTaskParameterInfo includeNonExistenDomains = this.GetParameter(this.cbIncludeNonExistenDomains, IncludeNonExistenDomainsParameter);

            return new ScheduleTaskParameterInfo[4] { daysBefore, mailTo, enableNotification, includeNonExistenDomains };
        }
    }
}