using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace WebsitePanel.Providers.Virtualization
{
    static class PSObjectExtension
    {
        public static object GetProperty(this PSObject obj, string name)
        {
            return obj.Members[name].Value;
        }
        public static T GetProperty<T>(this PSObject obj, string name)
        {
            return (T)obj.Members[name].Value;
        }
        public static T GetEnum<T>(this PSObject obj, string name) where T : struct
        {
            return (T)Enum.Parse(typeof(T), GetProperty(obj, name).ToString());
        }
        public static int GetInt(this PSObject obj, string name)
        {
            return Convert.ToInt32(obj.Members[name].Value);
        }
        public static long GetLong(this PSObject obj, string name)
        {
            return Convert.ToInt64(obj.Members[name].Value);
        }
        public static string GetString(this PSObject obj, string name)
        {
            return obj.Members[name].Value == null ? "" : obj.Members[name].Value.ToString();
        }
    }
}
