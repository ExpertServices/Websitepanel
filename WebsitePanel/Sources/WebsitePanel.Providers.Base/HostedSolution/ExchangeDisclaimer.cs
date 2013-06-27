using System;
using System.Collections.Generic;
using System.Text;

namespace WebsitePanel.Providers.HostedSolution
{
    public class ExchangeDisclaimer
    {
        int exchangeDisclaimerId;
        int itemId;
        string disclaimerName;
        string disclaimerText;

        public int ItemId
        {
            get { return this.itemId; }
            set { this.itemId = value; }
        }

        public int ExchangeDisclaimerId
        {
            get { return this.exchangeDisclaimerId; }
            set { this.exchangeDisclaimerId = value; }
        }

        public string DisclaimerName
        {
            get { return this.disclaimerName; }
            set { this.disclaimerName = value; }
        }

        public string DisclaimerText
        {
            get { return this.disclaimerText; }
            set { this.disclaimerText = value; }
        }

    }
}
