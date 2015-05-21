using WebsitePanel.WebDavPortal.Models.Common.EditorTemplates;

namespace WebsitePanel.WebDavPortal.Models.Account
{
    public class PasswordResetFinalStepModel
    {
        public PasswordResetFinalStepModel()
        {
            PasswordEditor = new PasswordEditor();
        }

        public string Login { get; set; }
        public PasswordEditor PasswordEditor { get; set; }
    }
}