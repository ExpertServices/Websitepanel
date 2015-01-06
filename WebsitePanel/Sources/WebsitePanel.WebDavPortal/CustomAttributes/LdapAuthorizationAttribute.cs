using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Ninject;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.CustomAttributes
{
    public class LdapAuthorizationAttribute : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            IKernel kernel = new StandardKernel(new NinjectSettings { AllowNullInjection = true }, new WebDavExplorerAppModule());
            var accountInfo = kernel.Get<AccountModel>();
            if (accountInfo == null)
                return false;
            return true;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Account", action = "Login" }));
        }
    }
}