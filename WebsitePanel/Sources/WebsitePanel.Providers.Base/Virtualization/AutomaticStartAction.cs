using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.Virtualization
{
    public enum AutomaticStartAction
    {
        Undefined = 100,
        Nothing = 0,
        StartIfRunning = 1,
        Start = 2,
    }
}
