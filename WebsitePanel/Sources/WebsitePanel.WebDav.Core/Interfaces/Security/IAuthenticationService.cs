using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;

namespace WebsitePanel.WebDav.Core.Interfaces.Security
{
    public interface IAuthenticationService
    {
        WspPrincipal LogIn(string login, string password);
        void CreateAuthenticationTicket(WspPrincipal principal);
        void LogOut();
    }
}
