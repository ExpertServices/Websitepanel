namespace WebsitePanel.EnterpriseServer.Base.HostedSolution
{
    public class AdditionalGroup
    {
        int groupId;
        string groupName;

        public int GroupId
        {
            get { return this.groupId; }
            set { this.groupId = value; }
        }

        public string GroupName
        {
            get { return this.groupName; }
            set { this.groupName = value; }
        }
    }
}
