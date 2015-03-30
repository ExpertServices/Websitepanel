using System;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Resources;
using WebsitePanel.WebDav.Core.Attributes.Resources;

namespace WebsitePanel.WebDav.Core.Extensions
{
    public static class EnumExtensions
    {
        public static string GetDescription(this Enum value)
        {
            FieldInfo field = value.GetType().GetField(value.ToString());

            DescriptionAttribute attribute
                    = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute))
                        as DescriptionAttribute;

            return attribute == null ? value.ToString() : attribute.Description;
        }
    }
}