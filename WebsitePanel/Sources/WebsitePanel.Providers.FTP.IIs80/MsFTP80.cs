using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.FTP
{
    public class MsFTP80 : MsFTP
    {
        public MsFTP80() : base()
        {
        }

        protected override bool IsMsFTPInstalled()
        {
            int value = 0;
            RegistryKey root = Registry.LocalMachine;
            RegistryKey rk = root.OpenSubKey("SOFTWARE\\Microsoft\\InetStp");
            if (rk != null)
            {
                value = (int)rk.GetValue("MajorVersion", null);
                rk.Close();
            }

            RegistryKey ftp = root.OpenSubKey("SYSTEM\\CurrentControlSet\\Services\\ftpsvc");
            bool res = (value == 8) && ftp != null;
            if (ftp != null)
                ftp.Close();

            return res;
        }

        public override bool IsInstalled()
        {
            return IsMsFTPInstalled();
        }
    }
}
