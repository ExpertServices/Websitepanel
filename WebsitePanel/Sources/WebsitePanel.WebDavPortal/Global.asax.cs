using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Script.Serialization;
using System.Web.Security;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDavPortal.Controllers;
using WebsitePanel.WebDavPortal.DependencyInjection;

namespace WebsitePanel.WebDavPortal
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            DependencyResolver.SetResolver(new NinjectDependecyResolver());

            log4net.Config.XmlConfigurator.Configure();
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception lastError = Server.GetLastError();
            Server.ClearError();

            int statusCode;

            if (lastError.GetType() == typeof (HttpException))
                statusCode = ((HttpException) lastError).GetHttpCode();
            else
                statusCode = 500;

            var contextWrapper = new HttpContextWrapper(Context);

            var routeData = new RouteData();
            routeData.Values.Add("controller", "Error");
            routeData.Values.Add("action", "Index");
            routeData.Values.Add("statusCode", statusCode);
            routeData.Values.Add("exception", lastError);
            routeData.Values.Add("isAjaxRequet", contextWrapper.Request.IsAjaxRequest());

            IController controller = new ErrorController();
            var requestContext = new RequestContext(contextWrapper, routeData);
            controller.Execute(requestContext);
            Response.End();
        }

        protected void Application_PostAuthenticateRequest(Object sender, EventArgs e)
        {
            HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            var contextWrapper = new HttpContextWrapper(Context);

            if (authCookie != null)
            {
                FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

                var serializer = new JavaScriptSerializer();

                var principalSerialized = serializer.Deserialize<WspPrincipal>(authTicket.UserData);

                var principal = new WspPrincipal(principalSerialized.Login);

                principal.AccountId = principalSerialized.AccountId;
                principal.ItemId = principalSerialized.ItemId;
                principal.OrganizationId = principalSerialized.OrganizationId;
                principal.DisplayName = principalSerialized.DisplayName;
                principal.EncryptedPassword = principalSerialized.EncryptedPassword;

                HttpContext.Current.User = principal;

                if (!contextWrapper.Request.IsAjaxRequest())
                {
                    SetAuthenticationExpirationTicket();
                }
            }
        }

        public static void SetAuthenticationExpirationTicket()
        {
            var expirationDateTimeInUtc = DateTime.UtcNow.AddMinutes(FormsAuthentication.Timeout.TotalMinutes).AddSeconds(1);
            var authenticationExpirationTicketCookie = new HttpCookie(WebDavAppConfigManager.Instance.AuthTimeoutCookieName);
            
            authenticationExpirationTicketCookie.Value = expirationDateTimeInUtc.Subtract(new DateTime(1970, 1, 1)).TotalMilliseconds.ToString("F0");
            authenticationExpirationTicketCookie.HttpOnly = false; 
            authenticationExpirationTicketCookie.Secure = FormsAuthentication.RequireSSL;

            HttpContext.Current.Response.Cookies.Add(authenticationExpirationTicketCookie);
        }
    }
}