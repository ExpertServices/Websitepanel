using System;

namespace WebsitePanel.Providers
{
    [Serializable]
    public enum AppPoolState
    {
        Unknown = 0,
        Starting = 1,
        Started = 2,
        Stopping = 3,
        Stopped = 4,
        Recycle = 5
    }
}
