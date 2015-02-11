using System.Configuration;

namespace WebsitePanel.WebDav.Core.Config.WebConfigSections
{
    public class ElementsRenderingElement : ConfigurationElement
    {
        private const string DefaultCountKey = "defaultCount";
        private const string AddElementsCountKey = "addElementsCount";
        private const string ElementsToIgnoreKey = "elementsToIgnoreKey";

        [ConfigurationProperty(DefaultCountKey, IsKey = true, IsRequired = true, DefaultValue = 30)]
        public int DefaultCount
        {
            get { return (int)this[DefaultCountKey]; }
            set { this[DefaultCountKey] = value; }
        }

        [ConfigurationProperty(AddElementsCountKey, IsKey = true, IsRequired = true, DefaultValue = 20)]
        public int AddElementsCount
        {
            get { return (int)this[AddElementsCountKey]; }
            set { this[AddElementsCountKey] = value; }
        }

        [ConfigurationProperty(ElementsToIgnoreKey, IsKey = true, IsRequired = true, DefaultValue = "")]
        public string ElementsToIgnore
        {
            get { return (string)this[ElementsToIgnoreKey]; }
            set { this[ElementsToIgnoreKey] = value; }
        }
    }
}