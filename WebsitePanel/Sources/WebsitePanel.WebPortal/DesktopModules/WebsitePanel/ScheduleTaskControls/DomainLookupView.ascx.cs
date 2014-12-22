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
    public partial class DomainLookupView : EmptyView
    {
        private static readonly string DnsServersParameter = "DNS_SERVERS";
        private static readonly string MailToParameter = "MAIL_TO";
        private static readonly string ServerNameParameter = "SERVER_NAME";
        private static readonly string PauseBetweenQueriesParameter = "PAUSE_BETWEEN_QUERIES";

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

            this.SetParameter(this.txtDnsServers, DnsServersParameter);
            this.SetParameter(this.txtMailTo, MailToParameter);
            this.SetParameter(this.txtPause, PauseBetweenQueriesParameter);
            this.SetParameter(this.ddlServers, ServerNameParameter);

            var servers = ES.Services.Servers.GetAllServers();

            var osGroup = ES.Services.Servers.GetResourceGroups().First(x => x.GroupName == ResourceGroups.Os);
            var osProviders = ES.Services.Servers.GetProvidersByGroupId(osGroup.GroupId);

            var osServers = new List<ServerInfo>();

            foreach (var server in servers)
            {
                var services = ES.Services.Servers.GetServicesByServerId(server.ServerId);

                if (services.Any(x => osProviders.Any(p=>p.ProviderId  == x.ProviderId)))
                {
                    osServers.Add(server);
                }
            }

            ddlServers.DataSource = osServers.Select(x => new { Id = x.ServerName, Name = x.ServerName });
            ddlServers.DataTextField = "Name";
            ddlServers.DataValueField = "Id";
            ddlServers.DataBind();

            ScheduleTaskParameterInfo parameter = this.FindParameterById(ServerNameParameter);

            ddlServers.SelectedValue = parameter.ParameterValue;
        }

        /// <summary>
        /// Gets scheduler task parameters from view.
        /// </summary>
        /// <returns>Parameters list filled  from view.</returns>
        public override ScheduleTaskParameterInfo[] GetParameters()
        {
            ScheduleTaskParameterInfo dnsServers = this.GetParameter(this.txtDnsServers, DnsServersParameter);
            ScheduleTaskParameterInfo mailTo = this.GetParameter(this.txtMailTo, MailToParameter);
            ScheduleTaskParameterInfo serverName = this.GetParameter(this.ddlServers, ServerNameParameter);
            ScheduleTaskParameterInfo pause = this.GetParameter(this.txtPause, PauseBetweenQueriesParameter);

            return new ScheduleTaskParameterInfo[4] { dnsServers, mailTo, serverName, pause };
        }
    }
}