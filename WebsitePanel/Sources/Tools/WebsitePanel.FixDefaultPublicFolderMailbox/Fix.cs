using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.FixDefaultPublicFolderMailbox
{
    class Fix
    {
        static private ServerContext serverContext;

        public const int ERROR_USER_WRONG_PASSWORD = -110;
        public const int ERROR_USER_WRONG_USERNAME = -109;
        public const int ERROR_USER_ACCOUNT_CANCELLED = -105;
        public const int ERROR_USER_ACCOUNT_PENDING = -103;

        private static bool Connect(string server, string username, string password)
        {
            bool ret = true;
            serverContext = new ServerContext();
            serverContext.Server = server;
            serverContext.Username = username;
            serverContext.Password = password;

            ES.InitializeServices(serverContext);
            int status = -1;
            try
            {
                status = ES.Services.Authentication.AuthenticateUser(serverContext.Username, serverContext.Password, null);
            }
            catch (Exception ex)
            {
                Log.WriteError("Authentication error", ex);
                return false;
            }

            string errorMessage = "Check your internet connection or server URL.";
            if (status != 0)
            {
                switch (status)
                {
                    case ERROR_USER_WRONG_USERNAME:
                        errorMessage = "Wrong username.";
                        break;
                    case ERROR_USER_WRONG_PASSWORD:
                        errorMessage = "Wrong password.";
                        break;
                    case ERROR_USER_ACCOUNT_CANCELLED:
                        errorMessage = "Account cancelled.";
                        break;
                    case ERROR_USER_ACCOUNT_PENDING:
                        errorMessage = "Account pending.";
                        break;
                }
                Log.WriteError(
                    string.Format("Cannot connect to the remote server. {0}", errorMessage));
                ret = false;
            }
            return ret;
        }

        public static void Start(string organizationId)
        {

            //Authenticates user
            if (!Connect(
                ConfigurationManager.AppSettings["ES.WebService"],
                ConfigurationManager.AppSettings["ES.Username"],
                ConfigurationManager.AppSettings["ES.Password"]))
                return;

            Organization[] orgs = ES.Services.ExchangeServer.GetExchangeOrganizations(1, true);

            foreach (Organization org in orgs)
            {
                if (organizationId == null)
                    FixOrganization(org);
                else if (org.OrganizationId == organizationId)
                    FixOrganization(org);
            }

        }

        public static void FixOrganization(Organization organization)
        {
            if (String.IsNullOrEmpty(organization.OrganizationId))
                return;

            Log.WriteLine("Organization " + organization.OrganizationId);

            string res = "";

            try
            {
                res = ES.Services.ExchangeServer.SetDefaultPublicFolderMailbox(organization.Id);
            }
            catch(Exception ex)
            {
                Log.WriteError(ex.ToString());
            }

            Log.WriteLine(res);

        }

    }
}
