using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Entities.Owa;

namespace WebsitePanel.WebDav.Core.Interfaces.Owa
{
    public interface IWopiServer
    {
        CheckFileInfo GetCheckFileInfo(WebDavAccessToken token);
        byte[] GetFileBytes(int accessTokenId);
    }
}