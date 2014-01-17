using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Web.Administration;

namespace WebsitePanel.Providers.Web.Extensions
{
    public static class WebDavExtensions
    {
        public static WebDavFolderRule ToWebDavFolderRule(this ConfigurationElement element)
        {
            var result = new WebDavFolderRule();

            if(!string.IsNullOrEmpty(element["users"].ToString()))
            {
                var users = element["users"].ToString().Split(',');

                foreach (var user in users)
                {
                    result.Users.Add(user.Trim());
                }
            }

            if (!string.IsNullOrEmpty(element["roles"].ToString()))
            {
                var roles = element["roles"].ToString().Split(',');

                foreach (var role in roles)
                {
                    result.Roles.Add(role.Trim());
                }
            }

            if (!string.IsNullOrEmpty(element["path"].ToString()))
            {
                var pathes = element["path"].ToString().Split(',');

                foreach (var path in pathes)
                {
                    result.Pathes.Add(path.Trim());
                }
            }

            var access = (int)element["access"] ;

            result.Write = (access & (int)WebDavAccess.Write) == (int)WebDavAccess.Write;
            result.Read = (access & (int)WebDavAccess.Read) == (int)WebDavAccess.Read;
            result.Source = (access & (int)WebDavAccess.Source) == (int)WebDavAccess.Source;

            return result;
        }

        public static bool ExistsWebDavRule(this ConfigurationElementCollection collection, WebDavFolderRule settings)
        {
            return collection.FindWebDavRule(settings) != null;
        }

        public static ConfigurationElement FindWebDavRule(this ConfigurationElementCollection collection, WebDavFolderRule settings)
        {
            return collection.FirstOrDefault(x =>
            {
                var s = x["users"].ToString();
                if (settings.Users.Any()
                    && x["users"].ToString() != string.Join(", ", settings.Users.ToArray()))
                {
                    return false;
                }

                if (settings.Roles.Any()
                    && x["roles"].ToString() != string.Join(", ", settings.Roles.ToArray()))
                {
                    return false;
                }

                if (settings.Pathes.Any()
                    && x["path"].ToString() != string.Join(", ", settings.Pathes.ToArray()))
                {
                    return false;
                }

                //if ((int)x["access"] != settings.AccessRights)
                //{
                //    return false;
                //}

                return true;
            });
        }
    }
}
