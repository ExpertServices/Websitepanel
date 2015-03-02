using System.Web.Mvc;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Entities.Owa;

namespace WebsitePanel.WebDav.Core.Interfaces.Owa
{
    public interface IWopiServer
    {
        CheckFileInfo GetCheckFileInfo(string path);
        FileResult GetFile(string path);
    }
}