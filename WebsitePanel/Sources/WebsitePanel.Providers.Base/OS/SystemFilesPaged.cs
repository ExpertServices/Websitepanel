namespace WebsitePanel.Providers.OS
{
    public class SystemFilesPaged
    {
        int recordsCount;
        SystemFile[] pageItems;

        public int RecordsCount
        {
            get { return this.recordsCount; }
            set { this.recordsCount = value; }
        }

        public SystemFile[] PageItems
        {
            get { return this.pageItems; }
            set { this.pageItems = value; }
        }
    }
}
