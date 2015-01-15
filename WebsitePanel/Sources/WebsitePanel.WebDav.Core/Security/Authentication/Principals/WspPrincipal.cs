using System.Security.Principal;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Xml.Serialization;

namespace WebsitePanel.WebDav.Core.Security.Authentication.Principals
{
    public class WspPrincipal : IPrincipal
    {
        public int AccountId { get; set; }
        public string OrganizationId { get; set; }
        public int ItemId { get; set; }

        public string Login { get; set; }
        public string EncryptedPassword { get; set; }

        public string DisplayName { get; set; }

        public string UserName
        {
            get
            {
                return !string.IsNullOrEmpty(Login) ? Login.Split('@')[0] : string.Empty;
            }
        }

        [XmlIgnore, ScriptIgnore]
        public IIdentity Identity { get; private set; }

        public WspPrincipal(string username)
        {
            Identity = new GenericIdentity(username);//new WindowsIdentity(username, "WindowsAuthentication");
            Login = username;
	    }

        public WspPrincipal()
        {
        }

        public bool IsInRole(string role)
        {
            return Identity.IsAuthenticated 
                && !string.IsNullOrWhiteSpace(role) 
                && Roles.IsUserInRole(Identity.Name, role);
        }
    }
}
