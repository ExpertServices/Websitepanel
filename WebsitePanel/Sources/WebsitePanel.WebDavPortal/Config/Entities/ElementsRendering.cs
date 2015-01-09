using System.Collections.Generic;
using System.Linq;

namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class ElementsRendering : AbstractConfigCollection
    {
        public int DefaultCount { get; private set; }
        public int AddElementsCount { get; private set; }
        public List<string> ElementsToIgnore { get; private set; }

        public ElementsRendering()
        {
            DefaultCount = ConfigSection.ElementsRendering.DefaultCount;
            AddElementsCount = ConfigSection.ElementsRendering.AddElementsCount;
            ElementsToIgnore = ConfigSection.ElementsRendering.ElementsToIgnore.Split(',').ToList();
        }
    }
}