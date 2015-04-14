using System.ComponentModel.DataAnnotations;
using WebsitePanel.WebDavPortal.Models.Common;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class PasswordResetSmsModel : BaseModel
    {
        [Required]
        public string Sms { get; set; }
        public bool IsTokenExist { get; set; }
    }
}