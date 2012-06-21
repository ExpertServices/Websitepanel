using System;
using System.Web;
using System.Web.Security;
using System.Web.Caching;
using System.Configuration;
using System.Security.Cryptography;
using System.Runtime.Serialization;
using System.Globalization;
using System.Text;
using Microsoft.Security.Application;

namespace WebsitePanel.WebPortal
{
    public class SecureSessionModule : IHttpModule
    {
        public const string DEFAULT_PAGE = "~/Default.aspx";
        public const string PAGE_ID_PARAM = "pid";

        private static string _ValidationKey = null;

        public void Init(HttpApplication app)
        {
            // Initialize validation key if not already initialized 
            if (_ValidationKey == null)
                _ValidationKey = GetValidationKey();

            // Register handlers for BeginRequest and EndRequest events 
            app.BeginRequest += new EventHandler(OnBeginRequest);
            app.EndRequest += new EventHandler(OnEndRequest);
        }

        public void Dispose() { }

        void OnBeginRequest(Object sender, EventArgs e)
        {
            // Look for an incoming cookie named "ASP.NET_SessionID" 
            HttpRequest request = ((HttpApplication)sender).Request;
            HttpCookie cookie = GetCookie(request, "ASP.NET_SessionId");

            if (cookie != null)
            {
                // Throw an exception if the cookie lacks a MAC 
                if (cookie.Value.Length <= 24)
                {
                    FormsAuthentication.SignOut();
                    HttpContext.Current.Response.Redirect(DefaultPage.GetPageUrl(PortalConfiguration.SiteSettings["DefaultPage"]));
                }

                // Separate the session ID and the MAC 
                string id = cookie.Value.Substring(0, 24);
                string mac1 = cookie.Value.Substring(24);

                // Generate a new MAC from the session ID and requestor info 
                string mac2 = GetSessionIDMac(id, request.UserHostAddress,
                    request.UserAgent, _ValidationKey);

                // Throw an exception if the MACs don't match 
                if (String.CompareOrdinal(mac1, mac2) != 0)
                {
                    FormsAuthentication.SignOut();
                    HttpContext.Current.Response.Redirect(DefaultPage.GetPageUrl(PortalConfiguration.SiteSettings["DefaultPage"]));
                }

                // Strip the MAC from the cookie before ASP.NET sees it 
                cookie.Value = id;
            }
        }

        void OnEndRequest(Object sender, EventArgs e)
        {
            // Look for an outgoing cookie named "ASP.NET_SessionID" 
            HttpRequest request = ((HttpApplication)sender).Request;
            HttpCookie cookie = GetCookie( request, "ASP.NET_SessionId");

            if (cookie != null)
            {
                // Add a MAC 
                cookie.Value += GetSessionIDMac(cookie.Value,
                    request.UserHostAddress, request.UserAgent,
                    _ValidationKey);
            }
        }

        private string GetValidationKey()
        {
            string key = ConfigurationManager.AppSettings["SessionValidationKey"];
            if (key == null || key == String.Empty)
                throw new InvalidSessionException
                    ("SessionValidationKey missing");
            return key;
        }

        private HttpCookie GetCookie(HttpRequest request, string name)
        {
            HttpCookieCollection cookies = request.Cookies;
            return FindCookie(cookies, name);
        }

        private HttpCookie GetCookie(HttpResponse response, string name)
        {
            HttpCookieCollection cookies = response.Cookies;
            return FindCookie(cookies, name);
        }

        private HttpCookie FindCookie(HttpCookieCollection cookies,
            string name)
        {
            int count = cookies.Count;

            for (int i = 0; i < count; i++)
            {
                if (String.Compare(cookies[i].Name, name, true,
                    CultureInfo.InvariantCulture) == 0)
                    return cookies[i];
            }

            return null;
        }

        private string GetSessionIDMac(string id, string ip,
            string agent, string key)
        {
            StringBuilder builder = new StringBuilder(id, 512);
            builder.Append(ip);
            builder.Append(agent);

            using (HMACSHA1 hmac = new HMACSHA1
                (Encoding.UTF8.GetBytes(key)))
            {
                return Convert.ToBase64String(hmac.ComputeHash
                   (Encoding.UTF8.GetBytes(builder.ToString())));
            }
        }
    }

    [Serializable]
    public class InvalidSessionException : Exception
    {
        public InvalidSessionException() :
            base("Session cookie is invalid") { }

        public InvalidSessionException(string message) :
            base(message) { }

        public InvalidSessionException(string message,
            Exception inner)
            : base(message, inner) { }

        protected InvalidSessionException(SerializationInfo info,
            StreamingContext context)
            : base(info, context) { }
    }
}