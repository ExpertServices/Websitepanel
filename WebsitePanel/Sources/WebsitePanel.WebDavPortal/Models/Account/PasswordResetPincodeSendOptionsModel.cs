using WebsitePanel.WebDavPortal.Models.Account.Enums;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class PasswordResetPincodeSendOptionsModel
    {
        public PincodeSendMethod Method { get; set; }
        public string MobileNumber { get; set; }
        public string Email { get; set; }
    }
}