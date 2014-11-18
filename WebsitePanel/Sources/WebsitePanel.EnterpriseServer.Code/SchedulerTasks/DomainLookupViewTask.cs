using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Providers.DNS;
using WebsitePanel.Providers.DomainLookup;

namespace WebsitePanel.EnterpriseServer
{
    public class DomainLookupViewTask : SchedulerTask
    {
        // Input parameters:
        private static readonly string DnsServersParameter = "DNS_SERVERS";
        private static readonly string MailToParameter = "MAIL_TO";

        public override void DoWork()
        {
            BackgroundTask topTask = TaskManager.TopTask;

            List<DomainChanges> domainsChanges = new List<DomainChanges>();

            // get input parameters
            string dnsServersString = (string)topTask.GetParamValue(DnsServersParameter);

            // check input parameters
            if (String.IsNullOrEmpty(dnsServersString))
            {
                TaskManager.WriteWarning("Specify 'DNS' task parameter.");
                return;
            }

            var dnsServers = dnsServersString.Split(';');

            var packages = ObjectUtils.CreateListFromDataReader<PackageInfo>(DataProvider.GetAllPackagesIds());

            foreach (var package in packages)
            {

                PackageContext cntx = PackageController.GetPackageContext(package.PackageId);

                if (cntx == null)
                {
                    continue;
                }

                bool dnsEnabled = cntx.GroupsArray.Any(x => x.GroupName == ResourceGroups.Dns);

                if (!dnsEnabled)
                {
                    continue;
                }

                var domains = ServerController.GetDomains(package.PackageId);

                domains = domains.Where(x => !x.IsSubDomain && !x.IsDomainPointer).ToList(); //Selecting top-level domains

                foreach (var domain in domains)
                {
                    DomainChanges domainChanges = new DomainChanges();

                    var mxRecords = ObjectUtils.CreateListFromDataReader<DnsRecordInfo>(DataProvider.GetDomainMXRecords(domain.DomainId, DnsRecordType.MX));
                    var nsRecords = ObjectUtils.CreateListFromDataReader<DnsRecordInfo>(DataProvider.GetDomainMXRecords(domain.DomainId, DnsRecordType.NS));

                    //execute server
                    foreach (var dnsServer in dnsServers)
                    {
                        var dnsMxRecords = OperatingSystemController.GetDomainRecords(domain.PackageId, domain.DomainName, dnsServer, DnsRecordType.MX);
                        var dnsNsRecords = OperatingSystemController.GetDomainRecords(domain.PackageId, domain.DomainName, dnsServer, DnsRecordType.NS);

                        FillRecordData(dnsMxRecords, domain, dnsServer);
                        FillRecordData(dnsNsRecords, domain, dnsServer);

                        domainChanges.MxChanges.Add(ApplyDomainRecordsChanges(mxRecords, dnsMxRecords, dnsServer));
                        domainChanges.NsChanges.Add(ApplyDomainRecordsChanges(nsRecords, dnsNsRecords, dnsServer));
                    }

                    domainsChanges.Add(domainChanges);
                }
            }

            var changedDomains = FindDomainsWithChangedRecords(domainsChanges);

            if (changedDomains.Any())
            {
                SendMailMessage(changedDomains);
            }
        }

        

        #region Helpers

        private IEnumerable<DomainChanges> FindDomainsWithChangedRecords(IEnumerable<DomainChanges> domainsChanges)
        {
            var changedDomains = new List<DomainChanges>();

            foreach (var domainChanges in domainsChanges)
            {
                var firstTimeAdditon = domainChanges.MxChanges.All(x => x.DnsRecordsCompare.All(dns => dns.DbRecord == null))
                                        && domainChanges.NsChanges.All(x => x.DnsRecordsCompare.All(dns => dns.DbRecord == null));

                if (firstTimeAdditon)
                {
                    continue;
                }

                bool mxIsChanged = domainChanges.MxChanges.Any(x => x.DnsRecordsCompare.Any(d => d.Status != DomainDnsRecordStatuses.NotChanged));
                bool nsIsChanged = domainChanges.NsChanges.Any(x => x.DnsRecordsCompare.Any(d => d.Status != DomainDnsRecordStatuses.NotChanged));

                if (mxIsChanged || nsIsChanged)
                {
                    changedDomains.Add(domainChanges);
                }
            }

            return changedDomains;
        }

        private DomainDnsRecordsChanges ApplyDomainRecordsChanges(List<DnsRecordInfo> dbRecords, List<DnsRecordInfo> dnsRecords, string dnsServer)
        {
            var domainRecordChanges = new DomainDnsRecordsChanges();
            domainRecordChanges.DnsServer = dnsServer;

            var filteredDbRecords = dbRecords.Where(x => x.DnsServer == dnsServer);

            foreach (var record in filteredDbRecords)
            {
                var dnsRecord = dnsRecords.FirstOrDefault(x => x.Value == record.Value);

                if (dnsRecord != null)
                {
                    domainRecordChanges.DnsRecordsCompare.Add(new DomainDnsRecordCompare { DbRecord = record, DnsRecord = dnsRecord, Status = DomainDnsRecordStatuses.NotChanged });

                    dnsRecords.Remove(dnsRecord);
                }
                else
                {
                    domainRecordChanges.DnsRecordsCompare.Add(new DomainDnsRecordCompare { DbRecord = record, DnsRecord = null, Status = DomainDnsRecordStatuses.Removed });

                    RemoveRecord(record);

                    domainRecordChanges.IsChanged = true;
                }
            }

            foreach (var record in dnsRecords)
            {
                domainRecordChanges.DnsRecordsCompare.Add(new DomainDnsRecordCompare { DbRecord = null, DnsRecord = record, Status = DomainDnsRecordStatuses.Added });

                AddRecord(record);

                domainRecordChanges.IsChanged = true;
            }

            return domainRecordChanges;
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

        private void SendMailMessage(IEnumerable<DomainChanges> domainsChanges)
        {
            BackgroundTask topTask = TaskManager.TopTask;

            // input parameters
            string mailFrom = "wsp@scheduler.noreply";
            string mailTo = (string)topTask.GetParamValue("MAIL_TO");
            string mailSubject = "WSP MX and NS notification";
            string mailBody = "Hello!<br><br>";

            if (String.IsNullOrEmpty(mailTo))
            {
                TaskManager.WriteWarning("The e-mail message has not been sent because 'Mail To' is empty.");
            }
            else
            {
                // send mail message
               // MailHelper.SendMessage(mailFrom, mailTo, mailSubject, mailBody, false);
            }
        } 

        #endregion
    }
}
