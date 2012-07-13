using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Configuration;
using System.Collections.ObjectModel;
using System.Collections;
using System.Collections.Specialized;
using System.Xml;
using Microsoft.Exchange.Data.Transport;
using Microsoft.Exchange.Data.Transport.Routing;
using Microsoft.Exchange.Data.Mime;
using System.DirectoryServices;


namespace WSPTransportAgent
{
    public class WSPRoutingAgentFactory : RoutingAgentFactory
    {
        public override RoutingAgent CreateAgent(SmtpServer server)
        {
            return new WSPRoutingAgent(server);
        }
    }

    public class WSPRoutingAgent : RoutingAgent
    {
        private string routingDomain;
        private bool enableVerboseLogging;
        private string logFile;
        private Hashtable htAcceptedDomains;
        private bool blockInternalInterTenantOOF;

        public WSPRoutingAgent(SmtpServer server)
        {
            //subscribe to different events
            loadConfiguration();

            WriteLine("WSPRoutingAgent Registration started");
            loadAcceptedDomains(server);
            //GetAcceptedDomains();
            WriteLine("\trouting Domain: " + routingDomain);

            base.OnResolvedMessage += new ResolvedMessageEventHandler(WSPRoutingAgent_OnResolvedMessage);

            WriteLine("WSPRoutingAgent Registration completed");
        }

        private void loadConfiguration()
        {
            this.routingDomain = ".tmpdefault";
            this.enableVerboseLogging = true;
            this.logFile = "C:\\WSP.LOG";

            try
            {
                ExeConfigurationFileMap map = new ExeConfigurationFileMap();
                map.ExeConfigFilename = System.Reflection.Assembly.GetExecutingAssembly().Location + ".config";
                Configuration libConfig = ConfigurationManager.OpenMappedExeConfiguration(map, ConfigurationUserLevel.None);
                AppSettingsSection section = (libConfig.GetSection("appSettings") as AppSettingsSection);

                this.routingDomain = section.Settings["routingDomain"].Value;
                this.enableVerboseLogging = (section.Settings["enableVerboseLogging"].Value == "true");
                this.blockInternalInterTenantOOF = (section.Settings["blockInternalInterTenantOOF"].Value == "true");
                this.logFile = section.Settings["logFile"].Value;
            }
            catch (Exception ex)
            {
                WriteLine("\t[Error] " + ex.Message);
                LogErrorToEventLog("[Error] [loadConfiguration] Error :" + ex.Message);
            }


        }


        private void loadAcceptedDomains(SmtpServer server)
        {
            try
            {
                if (htAcceptedDomains == null)
                    this.htAcceptedDomains = new Hashtable();
                else
                    this.htAcceptedDomains.Clear();

                foreach (AcceptedDomain domain in server.AcceptedDomains)
                {
                    htAcceptedDomains.Add(domain.ToString(), "1");
                    WriteLine("\tAccepted Domain: " + domain.ToString());
                }
            }
            catch (Exception ex)
            {
                WriteLine("\t[Error] " + ex.Message);
                LogErrorToEventLog("[Error] [loadAcceptedDomains] Error :" + ex.Message);
            }
        }


        void WSPRoutingAgent_OnResolvedMessage(ResolvedMessageEventSource source, QueuedMessageEventArgs e)
        {
            try
            {

                WriteLine("Start WSPRoutingAgent_OnResolvedMessage");

                WriteLine("\tFromAddress: " + e.MailItem.FromAddress.ToString());
                WriteLine("\tSubject: " + e.MailItem.Message.Subject.ToString());
                WriteLine("\tMapiMessageClass: " + e.MailItem.Message.MapiMessageClass.ToString());

                MimeDocument mdMimeDoc = e.MailItem.Message.MimeDocument;
                HeaderList hlHeaderlist = mdMimeDoc.RootPart.Headers;
                Header mhProcHeader = hlHeaderlist.FindFirst("X-WSP");

                if (mhProcHeader == null)
                {
                    WriteLine("\tTouched: " + "No");

                    if (!e.MailItem.Message.IsSystemMessage)
                    {
                        bool touched = false;

                        if (e.MailItem.FromAddress.DomainPart != null)
                        {
                            foreach (EnvelopeRecipient recp in e.MailItem.Recipients)
                            {
                                WriteLine("\t\tTo: " + recp.Address.ToString().ToLower());
                                if (IsMessageBetweenTenants(e.MailItem.FromAddress.DomainPart.ToLower(), recp.Address.DomainPart.ToLower()))
                                {
                                    WriteLine("\t\tMessage routed to domain: " + recp.Address.DomainPart.ToLower() + routingDomain);
                                    RoutingDomain myRoutingDomain = new RoutingDomain(recp.Address.DomainPart.ToLower() + routingDomain);
                                    RoutingOverride myRoutingOverride = new RoutingOverride(myRoutingDomain, DeliveryQueueDomain.UseOverrideDomain);
                                    source.SetRoutingOverride(recp, myRoutingOverride);
                                    touched = true;
                                }
                            }
                        }
                        else
                        {
                            if ((e.MailItem.Message.MapiMessageClass.ToString() == "IPM.Note.Rules.OofTemplate.Microsoft") &
                                blockInternalInterTenantOOF)
                            {
                                WriteLine("\t\tOOF From: " + e.MailItem.Message.From.SmtpAddress);
                                if (e.MailItem.Message.From.SmtpAddress.Contains("@"))
                                {
                                    string[] tmp = e.MailItem.Message.From.SmtpAddress.Split('@');
                                    foreach (EnvelopeRecipient recp in e.MailItem.Recipients)
                                    {
                                        WriteLine("\t\tTo: " + recp.Address.ToString().ToLower());
                                        if (IsMessageBetweenTenants(tmp[1].ToLower(), recp.Address.DomainPart.ToLower()))
                                        {
                                            WriteLine("\t\tRemove: " + recp.Address.DomainPart.ToLower());
                                            e.MailItem.Recipients.Remove(recp);
                                        }
                                    }
                                }
                            }
                        }

                        if (touched)
                        {
                            MimeNode lhLasterHeader = hlHeaderlist.LastChild;
                            TextHeader nhNewHeader = new TextHeader("X-WSP", "Logged00");
                            hlHeaderlist.InsertBefore(nhNewHeader, lhLasterHeader);
                        }
                    }
                    else
                        WriteLine("\tSystem Message");
                }
                else
                    WriteLine("\tTouched: " + "Yes");

            }

            catch (Exception ex)
            {
                WriteLine("\t[Error] Error :" + ex.Message);
                LogErrorToEventLog("[Error] [OnResolvedMessage] Error :" + ex.Message);
            }

            WriteLine("End WSPRoutingAgent_OnResolvedMessage");
        }

        private bool IsMessageBetweenTenants(string senderDomain, string recipientDomain)
        {
            if (senderDomain == recipientDomain) return false;

            if ((htAcceptedDomains[senderDomain] != null) &&
                (htAcceptedDomains[recipientDomain] != null))
                return true;

            return false;
        }

        /*
                private void GetAcceptedDomains()
                {
                    try
                    {
                        htAcceptedDomains.Clear();
                        DirectoryEntry rdRootDSE = new DirectoryEntry("LDAP://RootDSE");
                        DirectoryEntry cfConfigPartition = new DirectoryEntry("LDAP://" + rdRootDSE.Properties["configurationnamingcontext"].Value);
                        DirectorySearcher cfConfigPartitionSearch = new DirectorySearcher(cfConfigPartition);
                        cfConfigPartitionSearch.Filter = "(objectClass=msExchAcceptedDomain)";
                        cfConfigPartitionSearch.SearchScope = SearchScope.Subtree;
                        SearchResultCollection srSearchResults = cfConfigPartitionSearch.FindAll();

                        foreach (SearchResult srSearchResult in srSearchResults)
                        {
                            DirectoryEntry acDomain = srSearchResult.GetDirectoryEntry();
                            htAcceptedDomains.Add(acDomain.Properties["msexchaccepteddomainname"].Value.ToString().ToLower(), "1");
                            WriteLine("\tAccepted Domain :" + acDomain.Properties["msexchaccepteddomainname"].Value.ToString().ToLower());
                        }
                    }
                    catch (Exception ex)
                    {
                        WriteLine("\tError :" + ex.Message);
                        EventLog.WriteEntry("WSP Transport Agent", ex.Message, EventLogEntryType.Error);
                    }
                }
        */


        private void WriteLine(string Line)
        {
            if (!enableVerboseLogging) return;

            try
            {
                StreamWriter writer = new StreamWriter(logFile, true, System.Text.Encoding.ASCII);
                writer.WriteLine("[" + DateTime.Now.ToString() + "]" + Line);
                writer.Close();
            }
            catch (Exception e)
            {

            }
        }


        private void LogErrorToEventLog(string Line)
        {
            try
            {
                if (EventLog.SourceExists("WSPTransportAgent"))
                {
                    EventLog.WriteEntry("WSPTransportAgent", Line, EventLogEntryType.Error);
                }
            }
            catch (Exception ex)
            {
                WriteLine("[Error] WritingEventLog :" + ex.Message);
            }
        }


    }

}
