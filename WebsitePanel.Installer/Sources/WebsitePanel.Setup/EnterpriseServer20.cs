using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WebsitePanel.Setup.Actions;

namespace WebsitePanel.Setup
{
    /// <summary>
    /// Release 2.1.0
    /// </summary>
    public class EnterpriseServer210 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            //
            return EnterpriseServer.InstallBase(obj, minimalInstallerVersion: "2.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj,
                minimalInstallerVersion: "2.0.0",
                versionToUpgrade: "2.0.0,2.1.0",
                updateSql: true);
        }
    }

    /// <summary>
    /// Release 2.0.0
    /// </summary>
    public class EnterpriseServer200 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            //
            return EnterpriseServer.InstallBase(obj, minimalInstallerVersion: "2.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj,
                minimalInstallerVersion: "2.0.0",
                versionToUpgrade: "1.2.1,2.0.0",
                updateSql: true);
        }
    }
}
