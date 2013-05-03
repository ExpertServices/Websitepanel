using System;

namespace WebsitePanel.Providers
{
    [Serializable]
    public enum AppPoolState
    {
        Unknown = 0,
        Start = 1,
        Stop = 2,
        Recycle = 3
    }
}
