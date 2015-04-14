using Twilio;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Interfaces.Services;

namespace WebsitePanel.WebDav.Core.Services
{
    public class TwillioSmsDistributionService : ISmsDistributionService
    {
        private TwilioRestClient _twilioRestClient { get; set; }

        public TwillioSmsDistributionService()
        {
            _twilioRestClient = new TwilioRestClient(WebDavAppConfigManager.Instance.TwilioParameters.AccountSid, WebDavAppConfigManager.Instance.TwilioParameters.AuthorizationToken);
        }


        public void SendMessage(string phoneFrom, string phone, string message)
        {
            _twilioRestClient.SendSmsMessage(phoneFrom, phone, message);
        }

        public void SendMessage(string phone, string message)
        {
            _twilioRestClient.SendSmsMessage(WebDavAppConfigManager.Instance.TwilioParameters.PhoneFrom, phone, message);
        }
    }
}