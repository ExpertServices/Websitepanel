using System;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Entities.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Authentication.Principals;
using WebsitePanel.WebDav.Core.Security.Authorization.Enums;

namespace WebsitePanel.WebDav.Core.Owa
{
    public class WopiServer : IWopiServer
    {
        private readonly IWebDavManager _webDavManager;
        private readonly IAccessTokenManager _tokenManager;
        private readonly IWebDavAuthorizationService _webDavAuthorizationService;

        public WopiServer(IWebDavManager webDavManager, IAccessTokenManager tokenManager, IWebDavAuthorizationService webDavAuthorizationService)
        {
            _webDavManager = webDavManager;
            _tokenManager = tokenManager;
            _webDavAuthorizationService = webDavAuthorizationService;
        }

        public CheckFileInfo GetCheckFileInfo(string path)
        {
            var resource = _webDavManager.GetResource(path);

            var readOnly = _webDavAuthorizationService.GetPermissions(WspContext.User, path).HasFlag(WebDavPermissions.Write) == false;

            var cFileInfo = new CheckFileInfo
            {
                BaseFileName = resource.DisplayName,
                OwnerId = WspContext.User.Login,
                Size = resource.ContentLength,
                Version = DateTime.Now.ToString("s"),
                SupportsCoauth = true,
                SupportsCobalt = true,
                SupportsFolders = true,
                SupportsLocks = true,
                SupportsScenarioLinks = false,
                SupportsSecureStore = false,
                SupportsUpdate = true,
                UserCanWrite = !readOnly,
                ReadOnly = readOnly
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