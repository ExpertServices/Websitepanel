namespace WebsitePanel.Providers.OS
{
    public class MappedDrivesPaged
    {
        int recordsCount;
        MappedDrive[] pageItems;

        public int RecordsCount
        {
            get { return this.recordsCount; }
            set { this.recordsCount = value; }
        }

        public MappedDrive[] PageItems
        {
            get { return this.pageItems; }
            set { this.pageItems = value; }
        }
    }
}
