using System.Web;
using System.Web.SessionState;
using Ninject.Modules;
using WebsitePanel.WebDavPortal.Cryptography;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.DependencyInjection
{
    public class WebDavExplorerAppModule : NinjectModule
    {
        public override void Load()
        {
            Bind<HttpSessionState>().ToConstant(HttpContext.Current.Session);
            Bind<IWebDavManager>().ToProvider<WebDavManagerProvider>();
            Bind<AccountModel>().ToProvider<AccountInfoProvider>();
            Bind<ICryptography>().To<CryptoUtils>();
        }
    }
}