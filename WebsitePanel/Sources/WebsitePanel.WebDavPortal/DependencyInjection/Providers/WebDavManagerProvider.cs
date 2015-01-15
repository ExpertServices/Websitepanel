using System.Net;
using System.Web.SessionState;
using Ninject;
using Ninject.Activation;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.Exceptions;
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

                if (webDavManager == null)
                {
                    var cryptography = context.Kernel.Get<ICryptography>();

                    webDavManager = new WebDavManager(cryptography);

                    session[WebDavAppConfigManager.Instance.SessionKeys.WebDavManager] = webDavManager;
                }
            }

            return webDavManager;
        }
    }
}