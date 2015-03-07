using System;
using System.Threading;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.SessionState;
using AutoMapper;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDavPortal.App_Start;
using WebsitePanel.WebDavPortal.Controllers;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.HttpHandlers;
using WebsitePanel.WebDavPortal.Mapping;

namespace WebsitePanel.WebDavPortal
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            WebApiConfig.Register(GlobalConfiguration.Configuration);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            GlobalConfiguration.Configuration.MessageHandlers.Add(new AccessTokenHandler());

            DependencyResolver.SetResolver(new NinjectDependecyResolver());

            AutoMapperPortalConfiguration.Configure();

            Mapper.AssertConfigurationIsValid();

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

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            var s = HttpContext.Current.Request;
        }

        protected void Application_PostAuthenticateRequest(Object sender, EventArgs e)
        {
            if (!IsOwaRequest())
            {
                var contextWrapper = new HttpContextWrapper(Context);
                HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];

                var authService = DependencyResolver.Current.GetService<IAuthenticationService>();
                var cryptography = DependencyResolver.Current.GetService<ICryptography>();

                if (authCookie != null)
                {
                    FormsAuthenticationTicket authTicket = FormsAuthentication.Decrypt(authCookie.Value);

                    var serializer = new JavaScriptSerializer();

                    var principalSerialized = serializer.Deserialize<WspPrincipal>(authTicket.UserData);

                    authService.LogIn(principalSerialized.Login,
                        cryptography.Decrypt(principalSerialized.EncryptedPassword));

                    if (!contextWrapper.Request.IsAjaxRequest())
                    {
                        SetAuthenticationExpirationTicket();
                    }
                }
            }
        }



        private bool IsOwaRequest()
        {
            return HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath.StartsWith("~/owa");
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