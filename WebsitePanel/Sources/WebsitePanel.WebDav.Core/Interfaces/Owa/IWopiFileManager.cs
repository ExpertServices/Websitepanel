using Cobalt;

namespace WebsitePanel.WebDav.Core.Interfaces.Owa
{
    public interface IWopiFileManager
    {
        CobaltFile Create(int accessTokenId);
        CobaltFile Get(int accessTokenId);
        bool Add(int accessTokenId, CobaltFile file);
        bool Delete(int accessTokenId);
    }
}