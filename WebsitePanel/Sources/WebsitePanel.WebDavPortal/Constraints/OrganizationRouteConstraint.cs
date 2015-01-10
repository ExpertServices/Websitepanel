using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.Constraints
{
    public class OrganizationRouteConstraint : IRouteConstraint
    {
        private static string actualOrgName;

        public bool Match(HttpContextBase httpContext, Route route, string parameterName, RouteValueDictionary values, RouteDirection routeDirection)
        {
            object value;
            if (!values.TryGetValue(parameterName, out value)) 
                return false;

            var str = value as string;
            if (str == null) 
                return false;
           
            if (routeDirection == RouteDirection.IncomingRequest)
                return actualOrgName == str;

            if (httpContext.Session == null)
                return false;

            IKernel kernel = new StandardKernel(new WebDavExplorerAppModule());
            var webDavManager = kernel.Get<IWebDavManager>();
            if (webDavManager != null && str == webDavManager.OrganizationName)
            {
                actualOrgName = str;
                return true;
            }

            return false;
        }
    }
}