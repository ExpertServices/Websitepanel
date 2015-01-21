using System;
using System.Linq;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;
using WebsitePanel.WebDav.Core.Wsp.Framework;

namespace WebsitePanel.WebDav.Core.Security.Authorization
{
    public class WebDavAuthorizationService : IWebDavAuthorizationService
    {
        public bool HasAccess(WspPrincipal principal, string path)
        {
            var permissions = GetPermissions(principal, path);

            return permissions.HasFlag(WebDavPermissions.Read) || permissions.HasFlag(WebDavPermissions.Write);
        }

        public WebDavPermissions GetPermissions(WspPrincipal principal, string path)
        {
            if (string.IsNullOrEmpty(path))
            {
                return WebDavPermissions.Read;
            }

            var resultPermissions = WebDavPermissions.Empty;

            var rootFolder = GetRootFolder(path);

            var userGroups = WSP.Services.Organizations.GetSecurityGroupsByMember(principal.ItemId, principal.AccountId);

            var rootFolders = WSP.Services.EnterpriseStorage.GetEnterpriseFolders(principal.ItemId);

            var esRootFolder = rootFolders.FirstOrDefault(x => x.Name == rootFolder);

            if (esRootFolder == null)
            {
                return WebDavPermissions.None;
            }

            var permissions = WSP.Services.EnterpriseStorage.GetEnterpriseFolderPermissions(principal.ItemId, esRootFolder.Name);

            foreach (var permission in permissions)
            {
                if ((!permission.IsGroup
                        && (permission.DisplayName == principal.UserName || permission.DisplayName == principal.DisplayName))
                    || (permission.IsGroup && userGroups.Any(x => x.DisplayName == permission.DisplayName)))
                {
                    if (permission.Access.ToLowerInvariant().Contains("read"))
                    {
                        resultPermissions |= WebDavPermissions.Read;
                    }

                    if (permission.Access.ToLowerInvariant().Contains("write"))
                    {
                        resultPermissions |= WebDavPermissions.Write;
                    }
                }
            }

            return resultPermissions;
        }

        private string GetRootFolder(string path)
        {
            return path.Split(new[]{'/'}, StringSplitOptions.RemoveEmptyEntries)[0];
        }
    }
}