using System;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Entities.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;

namespace WebsitePanel.WebDav.Core.Owa
{
    public class WopiServer : IWopiServer
    {
        private readonly IWebDavManager _webDavManager;

        public WopiServer(IWebDavManager webDavManager)
        {
            _webDavManager = webDavManager;
        }

        public CheckFileInfo GetCheckFileInfo(string path)
        {
            var resource = _webDavManager.GetResource(path);

            var cFileInfo = new CheckFileInfo
            {
                BaseFileName = resource.DisplayName,
                OwnerId = @"4257508bfe174aa28b461536d8b6b648",
                Size = resource.ContentLength,
                Version = @"%22%7B59CCD75F%2D0687%2D4F86%2DBBCF%2D059126640640%7D%2C1%22"
            };

            return cFileInfo;
        }

        public FileResult GetFile(string path)
        {
            var fileBytes = _webDavManager.GetFileBytes(path);

            return new FileContentResult(fileBytes, MediaTypeNames.Application.Octet);
        }
    }
}