using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WebsitePanel.Setup.Actions;

namespace WebsitePanel.Setup
{
    /// <summary>
    /// Release 2.0.0
    /// </summary>
    public class Portal200 : Portal
    {
        public static new object Install(object obj)
        {
            //
            return Portal.InstallBase(obj, minimalInstallerVersion: "2.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return Portal.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return Portal.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj,
                minimalInstallerVersion: "2.0.0",
                versionToUpgrade: "1.2.1",
                updateSql: false);
        }
    }
}
