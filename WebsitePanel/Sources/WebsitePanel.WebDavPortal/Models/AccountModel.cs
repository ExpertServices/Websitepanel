using System.ComponentModel.DataAnnotations;

namespace WebsitePanel.WebDavPortal.Models
{
    public class AccountModel
    {
        [Required]
        [Display(Name = @"Login")]
        public string Login { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = @"Password")]
        public string Password { get; set; }

        public string LdapError { get; set; }
    }
}