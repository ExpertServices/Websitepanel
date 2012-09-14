using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.Web
{
    public class IIs80 : IIs70, IWebServer
    {
        public IIs80() : base()
        {
        }

        public override bool IsIISInstalled()
        {
            int value = 0;
            RegistryKey root = Registry.LocalMachine;
            RegistryKey rk = root.OpenSubKey("SOFTWARE\\Microsoft\\InetStp");
            if (rk != null)
            {
                value = (int)rk.GetValue("MajorVersion", null);
                rk.Close();
            }

            return value == 8;
        }

        public override bool IsInstalled()
        {
            return IsIISInstalled();
        }
    }
}
