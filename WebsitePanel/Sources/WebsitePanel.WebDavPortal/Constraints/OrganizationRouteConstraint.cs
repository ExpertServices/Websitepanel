using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
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
            var webdavManager = DependencyResolver.Current.GetService<IWebDavManager>();

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

            if (webdavManager != null && str == webdavManager.OrganizationName)
            {
                actualOrgName = str;
                return true;
            }

            return false;
        }
    }
}