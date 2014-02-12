using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Providers;
using WebsitePanel.Providers.Web;
using Microsoft.Web.Administration;
using WebsitePanel.Providers.Web.Extensions;

namespace WebsitePanel.Providers.Web
{
    public class WebDav : IWebDav
    {
        #region Fields

        protected WebDavSetting _Setting;

        #endregion

        public WebDav(WebDavSetting setting)
        {
            _Setting = setting;
        }

        public void CreateWebDavRule(string organizationId, string folder, WebDavFolderRule rule)
        {
            using (ServerManager serverManager = new ServerManager())
            {
                Configuration config = serverManager.GetApplicationHostConfiguration();

                ConfigurationSection authoringRulesSection = config.GetSection("system.webServer/webdav/authoringRules", string.Format("{0}/{1}/{2}", _Setting.Domain, organizationId, folder));

                ConfigurationElementCollection authoringRulesCollection = authoringRulesSection.GetCollection();

                ConfigurationElement addElement = authoringRulesCollection.CreateElement("add");

                if (rule.Users.Any())
                {
                    addElement["users"] = string.Join(", ", rule.Users.Select(x => x.ToString()).ToArray());
                }

                if (rule.Roles.Any())
                {
                    addElement["roles"] = string.Join(", ", rule.Roles.Select(x => x.ToString()).ToArray());
                }

                if (rule.Pathes.Any())
                {
                    addElement["path"] = string.Join(", ", rule.Pathes.ToArray());
                }

                addElement["access"] = rule.AccessRights;
                authoringRulesCollection.Add(addElement);

                serverManager.CommitChanges();
            }
        }
        public bool DeleteWebDavRule(string organizationId, string folder, WebDavFolderRule rule)
        {
            using (ServerManager serverManager = new ServerManager())
            {
                Configuration config = serverManager.GetApplicationHostConfiguration();

                ConfigurationSection authoringRulesSection = config.GetSection("system.webServer/webdav/authoringRules", string.Format("{0}/{1}/{2}", _Setting.Domain, organizationId, folder));

                ConfigurationElementCollection authoringRulesCollection = authoringRulesSection.GetCollection();

                var toDeleteRule = authoringRulesCollection.FindWebDavRule(rule);

                if (toDeleteRule != null)
                {
                    authoringRulesCollection.Remove(toDeleteRule);
                    serverManager.CommitChanges();
                    return true;
                }
                return false;
            }
        }

        public bool SetFolderWebDavRules(string organizationId, string folder, WebDavFolderRule[] newRules)
        {
            try
            {
                if (DeleteAllWebDavRules(organizationId, folder))
                {
                    if (newRules != null)
                    {
                        foreach (var rule in newRules)
                        {
                            CreateWebDavRule(organizationId, folder, rule);
                        }
                    }

                    return true;
                }
            }
            catch {  }
            return false;
        }

        public WebDavFolderRule[] GetFolderWebDavRules(string organizationId, string folder)
        {
            var rules = new List<WebDavFolderRule>();
            try
            {
                using (ServerManager serverManager = new ServerManager())
                {
                    Configuration config = serverManager.GetApplicationHostConfiguration();

                    ConfigurationSection authoringRulesSection = config.GetSection("system.webServer/webdav/authoringRules", string.Format("{0}/{1}/{2}", _Setting.Domain, organizationId, folder));

                    ConfigurationElementCollection authoringRulesCollection = authoringRulesSection.GetCollection();


                    foreach (var rule in authoringRulesCollection)
                    {
                        rules.Add(rule.ToWebDavFolderRule());
                    }
                }
            }
            catch { }

            return rules.ToArray();
        }


        public bool DeleteAllWebDavRules(string organizationId, string folder)
        {
            try
            {
                using (ServerManager serverManager = new ServerManager())
                {

                    Configuration config = serverManager.GetApplicationHostConfiguration();

                    config.RemoveLocationPath(string.Format("{0}/{1}/{2}", _Setting.Domain, organizationId, folder));
                    serverManager.CommitChanges();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
