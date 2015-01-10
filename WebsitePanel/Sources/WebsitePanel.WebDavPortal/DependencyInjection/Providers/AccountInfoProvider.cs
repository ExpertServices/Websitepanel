using System.Web.SessionState;
using Ninject;
using Ninject.Activation;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.DependencyInjection.Providers
{
    public class AccountInfoProvider : Provider<AccountModel>
    {
        protected override AccountModel CreateInstance(IContext context)
        {
            var session = context.Kernel.Get<HttpSessionState>();

            AccountModel accountInfo = null;

            if (session != null)
            {
                accountInfo = session[WebDavAppConfigManager.Instance.SessionKeys.AccountInfo] as AccountModel;
            }

            return accountInfo;
        }
    }
}