namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class ElementsRendering : AbstractConfigCollection
    {
        public int DefaultCount { get; private set; }
        public int AddElementsCount { get; private set; }

        public ElementsRendering()
        {
            DefaultCount = ConfigSection.ElementsRendering.DefaultCount;
            AddElementsCount = ConfigSection.ElementsRendering.AddElementsCount;
        }
    }
}