using System;

namespace WebsitePanel.EnterpriseServer.Base.HostedSolution
{
    public class AccessToken
    {
        public int Id { get; set; }
        public Guid AccessTokenGuid { get; set; }
        public DateTime ExpirationDate { get; set; }
        public int AccountId { get; set; }
        public int ItemId { get; set; }
        public AccessTokenTypes Type { get; set; }
    }
}