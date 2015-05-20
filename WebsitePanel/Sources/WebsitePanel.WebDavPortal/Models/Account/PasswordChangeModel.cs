using System.ComponentModel.DataAnnotations;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDavPortal.Models.Common;
using WebsitePanel.WebDavPortal.Models.Common.EditorTemplates;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class PasswordChangeModel 
    {
        [Display(ResourceType = typeof (Resources.UI), Name = "OldPassword")]
        [Required(ErrorMessageResourceType = typeof (Resources.Messages), ErrorMessageResourceName = "Required")]
        public string OldPassword { get; set; }

        [UIHint("PasswordEditor")]
        public PasswordEditor PasswordEditor { get; set; }


        public PasswordChangeModel()
        {
            PasswordEditor = new PasswordEditor();
        }
    }
}