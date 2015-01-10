using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using WebsitePanel.WebDavPortal.Cryptography;
using WebsitePanel.WebDavPortal.DependencyInjection.Providers;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.DependencyInjection
{
    public class PortalDependencies
    {
        public static void Configure(IKernel kernerl)
        {
            kernerl.Bind<HttpSessionState>().ToProvider<HttpSessionStateProvider>();
            kernerl.Bind<IWebDavManager>().ToProvider<WebDavManagerProvider>();
            kernerl.Bind<AccountModel>().ToProvider<AccountInfoProvider>();
            kernerl.Bind<ICryptography>().To<CryptoUtils>();
        }
    }
}