using System;
using System.Diagnostics;
using Microsoft.Deployment.WindowsInstaller;

namespace WebsitePanel.WIXInstaller.Common
{
    public class WiXLogListener : TraceListener
    {
        private Session m_Ctx;
        public WiXLogListener(Session Ctx)
            : base("WiXLogListener")
        {
            m_Ctx = Ctx;
        }

        public override void Write(string Value)
        {
            m_Ctx.Log(Value);
        }

        public override void WriteLine(string Value)
        {
            m_Ctx.Log(Value + Environment.NewLine);
        }
    }
}
