using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using WebsitePanel.Providers.DNS;
using WebsitePanel.Providers.DomainLookup;
using WebsitePanel.Server;

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
        private static readonly string ServerNameParameter = "SERVER_NAME";

        private const string MxRecordPattern = @"mail exchanger = (.+)";
        private const string NsRecordPattern = @"nameserver = (.+)";

        public override void DoWork()
        {
            BackgroundTask topTask = TaskManager.TopTask;

            List<DomainDnsChanges> domainsChanges = new List<DomainDnsChanges>();

            // get input parameters
            string dnsServersString = (string)topTask.GetParamValue(DnsServersParameter);
            string serverName = (string)topTask.GetParamValue(ServerNameParameter);

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

            // find server by name
            ServerInfo server = ServerController.GetServerByName(serverName);
            if (server == null)
            {
                TaskManager.WriteWarning(String.Format("Server with the name '{0}' was not found", serverName));
                return;
            }

            WindowsServer winServer = new WindowsServer();
            ServiceProviderProxy.ServerInit(winServer, server.ServerId);

            var user = UserController.GetUser(topTask.UserId);

            var dnsServers = dnsServersString.Split(';');

            var packages = ObjectUtils.CreateListFromDataReader<PackageInfo>(DataProvider.GetAllPackages());


            foreach (var package in packages)
            {
                var domains = ServerController.GetDomains(package.PackageId);

                domains = domains.Where(x => !x.IsSubDomain && !x.IsDomainPointer).ToList(); //Selecting top-level domains

                //domains = domains.Where(x => x.ZoneItemId > 0).ToList(); //Selecting only dns enabled domains

                foreach (var domain in domains)
                {
                    if (domainsChanges.Any(x => x.DomainName == domain.DomainName))
                    {
                        continue;
                    }

                    DomainDnsChanges domainChanges = new DomainDnsChanges();
                    domainChanges.DomainName = domain.DomainName;

                    var dbDnsRecords = ObjectUtils.CreateListFromDataReader<DnsRecordInfo>(DataProvider.GetDomainAllDnsRecords(domain.DomainId));

                    //execute server
                    foreach (var dnsServer in dnsServers)
                    {
                        var dnsMxRecords = GetDomainDnsRecords(winServer, domain.DomainName, dnsServer, DnsRecordType.MX);
                        var dnsNsRecords = GetDomainDnsRecords(winServer, domain.DomainName, dnsServer, DnsRecordType.NS);

                        FillRecordData(dnsMxRecords, domain, dnsServer);
                        FillRecordData(dnsNsRecords, domain, dnsServer);

                        domainChanges.DnsChanges.AddRange(ApplyDomainRecordsChanges(dbDnsRecords.Where(x => x.RecordType == DnsRecordType.MX), dnsMxRecords, dnsServer));
                        domainChanges.DnsChanges.AddRange(ApplyDomainRecordsChanges(dbDnsRecords.Where(x => x.RecordType == DnsRecordType.NS), dnsNsRecords, dnsServer));
                    }

                    domainsChanges.Add(domainChanges);
                }
            }

            var changedDomains = FindDomainsWithChangedRecords(domainsChanges);

            SendMailMessage(user, changedDomains);
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

        private IEnumerable<DnsRecordInfoChange> ApplyDomainRecordsChanges(IEnumerable<DnsRecordInfo> dbRecords, List<DnsRecordInfo> dnsRecords, string dnsServer)
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

            Thread.Sleep(100);
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

            Thread.Sleep(100);
        }

        private void SendMailMessage(UserInfo user, IEnumerable<DomainDnsChanges> domainsChanges)
        {
            BackgroundTask topTask = TaskManager.TopTask;

            UserSettings settings = UserController.GetUserSettings(user.UserId, UserSettings.DOMAIN_LOOKUP_LETTER);

            string from = settings["From"];

            var bcc = settings["CC"];

            string subject = settings["Subject"];

            MailPriority priority = MailPriority.Normal;
            if (!String.IsNullOrEmpty(settings["Priority"]))
                priority = (MailPriority)Enum.Parse(typeof(MailPriority), settings["Priority"], true);

            // input parameters
            string mailTo = (string)topTask.GetParamValue("MAIL_TO");

            string body = string.Empty;
            bool isHtml = user.HtmlMail;

            if (domainsChanges.Any())
            {
                body = user.HtmlMail ? settings["HtmlBody"] : settings["TextBody"];
            }
            else 
            {
                body = user.HtmlMail ? settings["NoChangesHtmlBody"] : settings["NoChangesTextBody"];
            }

            Hashtable items = new Hashtable();

            items["user"] = user;
            items["Domains"] = domainsChanges;

            body = PackageController.EvaluateTemplate(body, items);

            // send mail message
            MailHelper.SendMessage(from, mailTo, bcc, subject, body, priority, isHtml);
        }

        public List<DnsRecordInfo> GetDomainDnsRecords(WindowsServer winServer, string domain, string dnsServer, DnsRecordType recordType)
        {
            //nslookup -type=mx google.com 195.46.39.39
            var command = "nslookup";
            var args = string.Format("-type={0} {1} {2}", recordType, domain, dnsServer);

            // execute system command
            var raw = winServer.ExecuteSystemCommand(command, args);

            var records = ParseNsLookupResult(raw, dnsServer, recordType);

            return records.ToList();
        }

        private IEnumerable<DnsRecordInfo> ParseNsLookupResult(string raw, string dnsServer, DnsRecordType recordType)
        {
            var records = new List<DnsRecordInfo>();

            var recordTypePattern = string.Empty;

            switch (recordType)
            {
                case DnsRecordType.NS:
                    {
                        recordTypePattern = NsRecordPattern;
                        break;
                    }
                case DnsRecordType.MX:
                    {
                        recordTypePattern = MxRecordPattern;
                        break;
                    }
            }

            var regex = new Regex(recordTypePattern, RegexOptions.IgnoreCase);

            foreach (Match match in regex.Matches(raw))
            {
                if (match.Groups.Count != 2)
                {
                    continue;
                }

                var dnsRecord = new DnsRecordInfo
                {
                    Value = match.Groups[1].Value != null ? match.Groups[1].Value.Replace("\r\n", "").Replace("\r", "").Replace("\n", "").ToLowerInvariant().Trim() : null,
                    RecordType = recordType,
                    DnsServer = dnsServer
                };

                records.Add(dnsRecord);
            }

            return records;
        }

        #endregion
    }
}
