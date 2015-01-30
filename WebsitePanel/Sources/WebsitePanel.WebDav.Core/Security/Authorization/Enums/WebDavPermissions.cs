using System;

namespace WebsitePanel.WebDav.Core.Security.Authorization.Enums
{
    [Flags]
    public enum WebDavPermissions
    {
        Empty = 0,
        None = 1,
        Read = 2,
        Write = 4
    }
}