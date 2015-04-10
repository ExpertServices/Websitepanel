using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Security.AccessControl;
using WebsitePanel.WebDavPortal.CustomAttributes;
using WebsitePanel.WebDavPortal.Models.Common;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class UserProfile : BaseModel
    {
        [Display(ResourceType = typeof(Resources.UI), Name = "PrimaryEmail")]
        [Required(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "Required")]
        [EmailAddress(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "EmailInvalid", ErrorMessage = null)]
        public string PrimaryEmailAddress { get; set; }

        [Display(ResourceType = typeof(Resources.UI), Name = "DisplayName")]
        [Required(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "Required")]
        public string DisplayName { get; set; }
        public string AccountName { get; set; }
        public string FirstName { get; set; }
        public string Initials { get; set; }
        public string LastName { get; set; }
        public string JobTitle { get; set; }
        public string Company { get; set; }
        public string Department { get; set; }
        public string Office { get; set; }

        [PhoneNumber(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PhoneNumberInvalid")]
        public string BusinessPhone { get; set; }

        [PhoneNumber(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PhoneNumberInvalid")]
        public string Fax { get; set; }

        [PhoneNumber(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PhoneNumberInvalid")]
        public string HomePhone { get; set; }

        [Display(ResourceType = typeof(Resources.UI), Name = "MobilePhone")]
        [Required(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "Required")]
        [PhoneNumber(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PhoneNumberInvalid")]
        public string MobilePhone { get; set; }

        [PhoneNumber(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "PhoneNumberInvalid")]
        public string Pager { get; set; }

        [Url(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "UrlInvalid", ErrorMessage = null)]
        public string WebPage { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }

        [EmailAddress(ErrorMessageResourceType = typeof(Resources.Messages), ErrorMessageResourceName = "EmailInvalid", ErrorMessage = null)]
        public string ExternalEmail { get; set; }

        [UIHint("CountrySelector")]
        public string Country { get; set; }

        public string Notes { get; set; }
        public DateTime PasswordExpirationDateTime { get; set; }
    }
}