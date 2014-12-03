using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Providers.Web
{
    public interface IWebDav
    {
        void CreateWebDavRule(string organizationId, string folder, WebDavFolderRule rule);
        bool DeleteWebDavRule(string organizationId, string folder, WebDavFolderRule rule);
        bool DeleteAllWebDavRules(string organizationId, string folder);
        bool SetFolderWebDavRules(string organizationId, string folder, WebDavFolderRule[] newRules);
        WebDavFolderRule[] GetFolderWebDavRules(string organizationId, string folder);
    }
}
