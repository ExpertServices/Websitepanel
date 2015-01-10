using System.Web.SessionState;
using Ninject;
using Ninject.Activation;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.DependencyInjection.Providers
{
    public class WebDavManagerProvider : Provider<WebDavManager>
    {
        protected override WebDavManager CreateInstance(IContext context)
        {
            var session = context.Kernel.Get<HttpSessionState>();

            WebDavManager webDavManager = null;

            if (session != null)
            {
                webDavManager = session[WebDavAppConfigManager.Instance.SessionKeys.WebDavManager] as WebDavManager;
            }

            return webDavManager;
        }
    }
}