using System;

namespace WebsitePanel.WIXInstaller.Common
{
    internal struct Prop
    {
        public const int REQ_IIS_MINIMUM = 6;
        public const string REQ_LOG = "PI_PREREQ_LOG";
        public const string REQ_OS = "PI_PREREQ_OS";
        public const string REQ_IIS = "PI_PREREQ_IIS";
        public const string REQ_IIS_MAJOR = "PI_PREREQ_IIS_MAJOR";
        public const string REQ_IIS_MINOR = "PI_PREREQ_IIS_MINOR";
        public const string REQ_ASPNET = "PI_PREREQ_ASPNET";                
        public const string REQ_SERVER = "PI_PREREQ_WP_SERVER";
        public const string REQ_ESERVER = "PI_PREREQ_WP_ESERVER";
        public const string REQ_PORTAL = "PI_PREREQ_WP_PORTAL";
        public const string REQ_WDPORTAL = "PI_PREREQ_WP_WDPORTAL";
    }
}
