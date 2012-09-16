using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Setup
{
    /// <summary>
    /// Release 2.0.0
    /// </summary>
    public class Server200 : Server
    {
        public static new object Install(object obj)
        {
            //
            return Server.InstallBase(obj, minimalInstallerVersion: "2.0.0");
        }

        public static new object Uninstall(object obj)
        {
            return Server.Uninstall(obj);
        }

        public static new object Setup(object obj)
        {
            return Server.Setup(obj);
        }

        public static new object Update(object obj)
        {
            return Server.UpdateBase(obj,
                minimalInstallerVersion: "2.0.0",
                versionToUpgrade: "1.2.1",
                updateSql: false);
        }
    }
}
