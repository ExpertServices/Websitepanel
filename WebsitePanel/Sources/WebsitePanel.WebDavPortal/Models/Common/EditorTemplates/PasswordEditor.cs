using System.ComponentModel.DataAnnotations;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDavPortal.CustomAttributes;

namespace WebsitePanel.WebDavPortal.Models.Common.EditorTemplates
{
    public class PasswordEditor 
    {

        [Display(ResourceType = typeof(Resources.UI), Name = "NewPassword")]
        [Required(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "Required")]
        [OrganizationPasswordPolicy]
        public string NewPassword { get; set; }

        [Display(ResourceType = typeof(Resources.UI), Name = "NewPasswordConfirmation")]
        [Required(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "Required")]
        [Compare("NewPassword", ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PasswordDoesntMatch")]
        public string NewPasswordConfirmation { get; set; }

        public OrganizationPasswordSettings Settings { get; set; } 
    }
}