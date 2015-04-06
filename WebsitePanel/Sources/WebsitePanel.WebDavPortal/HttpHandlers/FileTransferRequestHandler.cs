using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Web.Hosting;
using WebsitePanel.WebDavPortal.DependencyInjection;
using WebsitePanel.WebDavPortal.Models;

namespace WebsitePanel.WebDavPortal.HttpHandlers
{
    public class FileTransferRequestHandler : IHttpHandler 
    {
        public void ProcessRequest(HttpContext context) 
        {
            context.Response.WriteFile(context.Request.RawUrl.TrimEnd('?'));
            context.Response.End();
        }

        public bool IsReusable
        {
            get { return true; }
        }
    }
}