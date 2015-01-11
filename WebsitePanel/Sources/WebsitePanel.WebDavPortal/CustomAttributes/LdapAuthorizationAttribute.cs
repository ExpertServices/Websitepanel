using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Ninject;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Models;
using WebsitePanel.WebDavPortal.UI.Routes;

namespace WebsitePanel.WebDavPortal.CustomAttributes
{
    public class LdapAuthorizationAttribute : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            var accountInfo = DependencyResolver.Current.GetService<AccountModel>();

            if (accountInfo == null)
            {
                return false;
            }

            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new RedirectToRouteResult(AccountRouteNames.Login, null);
        }
    }
}