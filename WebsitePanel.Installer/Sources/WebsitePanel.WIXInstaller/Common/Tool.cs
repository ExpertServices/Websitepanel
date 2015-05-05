using Microsoft.Deployment.WindowsInstaller;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebsitePanel.Setup;

namespace WebsitePanel.WIXInstaller.Common
{
    internal static class Tool
    {
        public static SetupVariables GetSetupVars(Session Ctx)
        {
            return new SetupVariables
                {
                    SetupAction = SetupActions.Install,
                    IISVersion = Global.IISVersion
                };
        }

        public static void FillServerVariables(SetupVariables Vars)
        {

        }

        public static void FillEServerVariables(SetupVariables Vars)
        {

        }

        public static void FillPortalVariables(SetupVariables Vars)
        {

        }
    }
}
