using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDavPortal.Models.Common;

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