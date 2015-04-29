using System;
using System.Globalization;
using log4net;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Interfaces.Services;

namespace WebsitePanel.WebDav.Core.Security.Authentication
{
    public class SmsAuthenticationService : ISmsAuthenticationService
    {
        private ISmsDistributionService _smsService;
        private readonly ILog Log;

        public SmsAuthenticationService(ISmsDistributionService smsService)
        {
            _smsService = smsService;
            Log = LogManager.GetLogger(this.GetType());
        }

        public bool VerifyResponse( Guid token, string response)
        {
            var accessToken = WspContext.Services.Organizations.GetPasswordresetAccessToken(token);

            if (accessToken == null)
            {
                return false;
            }

            return string.Compare(accessToken.SmsResponse, response, StringComparison.InvariantCultureIgnoreCase) == 0;
        }

        public string SendRequestMessage(string phoneTo)
        {
            var response = GenerateResponse();

            var result = _smsService.SendMessage(WebDavAppConfigManager.Instance.TwilioParameters.PhoneFrom, phoneTo, response);

            return result ? response : string.Empty;
        }

        public string GenerateResponse()
        {
            var random = new Random(Guid.NewGuid().GetHashCode());

            return random.Next(10000, 99999).ToString(CultureInfo.InvariantCulture);
        }
    }
}