using System.ComponentModel.DataAnnotations;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Resources;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class PasswordResetEmailModel 
    {
        [Required]
        [Display(ResourceType = typeof(Resources.UI), Name = "Email")]
        [EmailAddress(ErrorMessageResourceType = typeof(Messages), ErrorMessageResourceName = "EmailInvalid",ErrorMessage = null)]
        public string Email { get; set; }
    }
}