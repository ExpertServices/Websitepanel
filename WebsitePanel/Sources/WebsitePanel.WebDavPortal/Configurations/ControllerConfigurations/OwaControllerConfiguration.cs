using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;
using WebsitePanel.WebDavPortal.Configurations.ActionSelectors;

namespace WebsitePanel.WebDavPortal.Configurations.ControllerConfigurations
{
    public class OwaControllerConfiguration : Attribute, IControllerConfiguration
    {
        public void Initialize(HttpControllerSettings controllerSettings, HttpControllerDescriptor controllerDescriptor)
        {
            controllerSettings.Services.Replace(typeof(IHttpActionSelector), new OwaActionSelector());
        }
    }
}