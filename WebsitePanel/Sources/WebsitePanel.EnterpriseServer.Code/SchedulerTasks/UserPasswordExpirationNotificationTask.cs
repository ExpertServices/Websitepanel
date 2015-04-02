using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.EnterpriseServer
{
    public class UserPasswordExpirationNotificationTask : SchedulerTask
    {
        private static readonly string TaskId = "SCHEDULE_TASK_DOMAIN_EXPIRATION";

        // Input parameters:
        private static readonly string DaysBeforeNotify = "DAYS_BEFORE_EXPIRATION";

        public override void DoWork()
        {
            BackgroundTask topTask = TaskManager.TopTask;

            int daysBeforeNotify;

            // check input parameters
            if (!int.TryParse((string)topTask.GetParamValue(DaysBeforeNotify), out daysBeforeNotify))
            {
                TaskManager.WriteWarning("Specify 'Notify before (days)' task parameter");
                return;
            }

            var owner = UserController.GetUser(topTask.EffectiveUserId);

            var packages = PackageController.GetMyPackages(topTask.EffectiveUserId);

            foreach (var package in packages)
            {
                var organizations = ExchangeServerController.GetExchangeOrganizations(package.PackageId, true);
                
                foreach (var organization in organizations)
                {
                    var usersWithExpiredPasswords = OrganizationController.GetOrganizationUsersWithExpiredPassword(organization.Id, daysBeforeNotify);

                    foreach (var user in usersWithExpiredPasswords)
                    {
                        if (string.IsNullOrEmpty(user.PrimaryEmailAddress))
                        {
                            TaskManager.WriteWarning(string.Format("Unable to send email to {0} user (organization: {1}), user primary email address is not set.", user.DisplayName, organization.OrganizationId));
                            continue;
                        }

                        TaskManager.Write(string.Format("Email sent to {0} user (organization: {1}).", user.DisplayName, organization.OrganizationId));

                        OrganizationController.SendResetUserPasswordEmail(owner, user, user.PrimaryEmailAddress, string.Empty);
                    }
                }
            }

            // send mail message
           // MailHelper.SendMessage(mailFrom, mailTo, mailSubject, mailBody, false);
        }

        
    }
}