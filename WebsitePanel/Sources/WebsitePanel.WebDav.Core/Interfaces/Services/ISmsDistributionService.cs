namespace WebsitePanel.WebDav.Core.Interfaces.Services
{
    public interface ISmsDistributionService
    {
        void SendMessage(string phoneFrom, string phone, string message);

        void SendMessage(string phone, string message); 
    }
}