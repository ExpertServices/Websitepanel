using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace WebsitePanel.Setup
{
    /// <summary>
    /// Release 2.0.0
    /// </summary>
    public class StandaloneServerSetup200 : StandaloneServerSetup
    {
        public static new object Install(object obj)
        {
            return StandaloneServerSetup.InstallBase(obj, minimalInstallerVersion: "2.0.0");
        }
    }
}
