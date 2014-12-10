using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using WebsitePanel.Providers.DNS;
using WebsitePanel.Providers.DomainLookup;

namespace WebsitePanel.EnterpriseServer
{
    public class DomainLookupViewTask : SchedulerTask
    {
        private static readonly string TaskId = "SCHEDULE_TASK_DOMAIN_LOOKUP";

        // Input parameters:
        private static readonly string DnsServersParameter = "DNS_SERVERS";
        private static readonly string MailToParameter = "MAIL_TO";

        private static readonly string MailBodyTemplateParameter = "MAIL_BODY";
        private static readonly string MailBodyDomainRecordTemplateParameter = "MAIL_DOMAIN_RECORD";

        public override void DoWork()
        {
            BackgroundTask topTask = TaskManager.TopTask;

            List<DomainDnsChanges> domainsChanges = new List<DomainDnsChanges>();

            // get input parameters
            string dnsServersString = (string)topTask.GetParamValue(DnsServersParameter);

            // check input parameters
            if (String.IsNullOrEmpty(dnsServersString))
            {
                TaskManager.WriteWarning("Specify 'DNS' task parameter.");
                return;
            }

            if (String.IsNullOrEmpty((string)topTask.GetParamValue("MAIL_TO")))
            {
                TaskManager.WriteWarning("The e-mail message has not been sent because 'Mail To' is empty.");
                return;
            }

            var user = UserController.GetUser(topTask.UserId);

            var dnsServers = dnsServersString.Split(';');

            var packages = ObjectUtils.CreateListFromDataReader<PackageInfo>(DataProvider.GetAllPackages());

            foreach (var package in packages)
            {
                var domains = ServerController.GetDomains(package.PackageId);

                domains = domains.Where(x => !x.IsSubDomain && !x.IsDomainPointer).ToList(); //Selecting top-level domains

                domains = domains.Where(x => x.ZoneItemId > 0).ToList(); //Selecting only dns enabled domains

                foreach (var domain in domains)
                {
                    if (domainsChanges.Any(x => x.DomainName == domain.DomainName))
                    {
                        continue;
                    }

                    DomainDnsChanges domainChanges = new DomainDnsChanges();
                    domainChanges.DomainName = domain.DomainName;

                    var mxRecords = ObjectUtils.CreateListFromDataReader<DnsRecordInfo>(DataProvider.GetDomainDnsRecords(domain.DomainId, DnsRecordType.MX));
                    var nsRecords = ObjectUtils.CreateListFromDataReader<DnsRecordInfo>(DataProvider.GetDomainDnsRecords(domain.DomainId, DnsRecordType.NS));

                    //execute server
                    foreach (var dnsServer in dnsServers)
                    {
                        var dnsMxRecords = OperatingSystemController.GetDomainRecords(domain.PackageId, domain.DomainName, dnsServer, DnsRecordType.MX);
                        var dnsNsRecords = OperatingSystemController.GetDomainRecords(domain.PackageId, domain.DomainName, dnsServer, DnsRecordType.NS);

                        FillRecordData(dnsMxRecords, domain, dnsServer);
                        FillRecordData(dnsNsRecords, domain, dnsServer);

                        domainChanges.DnsChanges.AddRange(ApplyDomainRecordsChanges(mxRecords, dnsMxRecords, dnsServer));
                        domainChanges.DnsChanges.AddRange(ApplyDomainRecordsChanges(nsRecords, dnsNsRecords, dnsServer));
                    }

                    domainsChanges.Add(domainChanges);
                }
            }

            var changedDomains = FindDomainsWithChangedRecords(domainsChanges);

            if (changedDomains.Any())
            {
                SendMailMessage(user,changedDomains);
            }
        }

        

        #region Helpers

        private IEnumerable<DomainDnsChanges> FindDomainsWithChangedRecords(IEnumerable<DomainDnsChanges> domainsChanges)
        {
            var changedDomains = new List<DomainDnsChanges>();

            foreach (var domainChanges in domainsChanges)
            {
                var firstTimeAdditon = domainChanges.DnsChanges.All(x => x.Status == DomainDnsRecordStatuses.Added);

                if (firstTimeAdditon)
                {
                    continue;
                }

                bool isChanged = domainChanges.DnsChanges.Any(d =>  d.Status != DomainDnsRecordStatuses.NotChanged);

                if (isChanged)
                {
                    changedDomains.Add(domainChanges);
                }
            }

            return changedDomains;
        }

        private IEnumerable<DnsRecordInfoChange> ApplyDomainRecordsChanges(List<DnsRecordInfo> dbRecords, List<DnsRecordInfo> dnsRecords, string dnsServer)
        {
            var dnsRecordChanges = new List<DnsRecordInfoChange>();

            var filteredDbRecords = dbRecords.Where(x => x.DnsServer == dnsServer);

            foreach (var record in filteredDbRecords)
            {
                var dnsRecord = dnsRecords.FirstOrDefault(x => x.Value == record.Value);

                if (dnsRecord != null)
                {
                    dnsRecordChanges.Add(new DnsRecordInfoChange { Record = record, Type = record.RecordType, Status = DomainDnsRecordStatuses.NotChanged, DnsServer = dnsServer });

                    dnsRecords.Remove(dnsRecord);
                }
                else
                {
                    dnsRecordChanges.Add(new DnsRecordInfoChange { Record = record, Type = record.RecordType, Status = DomainDnsRecordStatuses.Removed, DnsServer = dnsServer });

                    RemoveRecord(record);
                }
            }

            foreach (var record in dnsRecords)
            {
                dnsRecordChanges.Add(new DnsRecordInfoChange { Record = record, Type = record.RecordType, Status = DomainDnsRecordStatuses.Added, DnsServer= dnsServer});

                AddRecord(record);
            }

            return dnsRecordChanges;
        }

        private void FillRecordData(IEnumerable<DnsRecordInfo> records, DomainInfo domain, string dnsServer)
        {
            foreach (var record in records)
            {
                FillRecordData(record, domain, dnsServer);
            }
        }

        private void FillRecordData(DnsRecordInfo record, DomainInfo domain, string dnsServer)
        {
            record.DomainId = domain.DomainId;
            record.Date = DateTime.Now;
            record.DnsServer = dnsServer;
        }

        private void RemoveRecords(IEnumerable<DnsRecordInfo> dnsRecords)
        {
            foreach (var record in dnsRecords)
            {
                RemoveRecord(record);
            }
        }

        private void RemoveRecord(DnsRecordInfo dnsRecord)
        {
            DataProvider.DeleteDomainDnsRecord(dnsRecord.Id);
        }

        private void AddRecords(IEnumerable<DnsRecordInfo> dnsRecords)
        {
            foreach (var record in dnsRecords)
            {
                AddRecord(record);
            }
        }

        private void AddRecord(DnsRecordInfo dnsRecord)
        {
            DataProvider.AddDomainDnsRecord(dnsRecord);
        }

        private void SendMailMessage(UserInfo user, IEnumerable<DomainDnsChanges> domainsChanges)
        {
            BackgroundTask topTask = TaskManager.TopTask;

            UserSettings settings = UserController.GetUserSettings(user.UserId, UserSettings.DOMAIN_LOOKUP_LETTER);

            string from = settings["From"];

            var bcc = settings["CC"];

            string subject = settings["Subject"];
            string body = user.HtmlMail ? settings["HtmlBody"] : settings["TextBody"];
            bool isHtml = user.HtmlMail;

            MailPriority priority = MailPriority.Normal;
            if (!String.IsNullOrEmpty(settings["Priority"]))
                priority = (MailPriority)Enum.Parse(typeof(MailPriority), settings["Priority"], true);

            // input parameters
            string mailTo = (string)topTask.GetParamValue("MAIL_TO");

            Hashtable items = new Hashtable();

            items["user"] = user;
            items["Domains"] = domainsChanges;

            body = PackageController.EvaluateTemplate(body, items);

            // send mail message
            MailHelper.SendMessage(from, mailTo, bcc, subject, body, priority, isHtml);
        }

        #endregion
    }
}
