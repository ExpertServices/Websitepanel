using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace WebsitePanel.Providers
{
    [AttributeUsage(AttributeTargets.Property)]
    public class LogPropertyAttribute : Attribute
    {
        public LogPropertyAttribute(bool withNameDecoration = true)
        {
            NameDecoration = withNameDecoration;
        }

        public LogPropertyAttribute(string nameInLog)
        {
            NameInLog = nameInLog;
        }

        public string NameInLog { get; set; }

        public bool NameDecoration { get; set; }

        public string GetLogString(object obj, PropertyInfo propertyInfo)
        {
            if (propertyInfo != null)
            {
                var value = LogExtensionHelper.GetString(propertyInfo.GetValue(obj, null));
                return GetLogString(propertyInfo.Name, value);
            }

            return "";
        }

        public string GetLogString(string name, string value)
        {
            string logName;

            if (string.IsNullOrEmpty(NameInLog))
                logName = NameDecoration ? LogExtensionHelper.DecorateName(name) : name;
            else
                logName = NameInLog;

            return LogExtensionHelper.CombineString(logName, value);
        }

    }
}
