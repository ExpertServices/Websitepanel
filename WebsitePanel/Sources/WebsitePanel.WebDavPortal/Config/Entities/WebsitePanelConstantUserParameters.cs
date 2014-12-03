namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class WebsitePanelConstantUserParameters : AbstractConfigCollection
    {
        public string Login { get; private set; }
        public string Password { get; private set; }

        public WebsitePanelConstantUserParameters()
        {
            Login = ConfigSection.WebsitePanelConstantUser.Login;
            Password = ConfigSection.WebsitePanelConstantUser.Password;
        }
    }
}