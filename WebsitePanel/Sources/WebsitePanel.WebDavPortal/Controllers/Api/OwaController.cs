using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Http;
using Cobalt;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Entities.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Security;
using WebsitePanel.WebDav.Core.Security.Cryptography;
using WebsitePanel.WebDav.Core.Wsp.Framework;
using WebsitePanel.WebDavPortal.Configurations.ControllerConfigurations;

namespace WebsitePanel.WebDavPortal.Controllers.Api
{
    [Authorize]
    [OwaControllerConfiguration]
    public class OwaController : ApiController
    {
        private readonly IWopiServer _wopiServer;
        private readonly IWebDavManager _webDavManager;
        private readonly IAuthenticationService _authenticationService;
        private readonly IAccessTokenManager _tokenManager;
        private readonly ICryptography _cryptography;
        //private static WopiSession _session;
        private readonly ICobaltManager _cobaltManager;

        public OwaController(IWopiServer wopiServer, IWebDavManager webDavManager, IAuthenticationService authenticationService, IAccessTokenManager tokenManager, ICryptography cryptography, ICobaltManager cobaltManager)
        {
            _wopiServer = wopiServer;
            _webDavManager = webDavManager;
            _authenticationService = authenticationService;
            _tokenManager = tokenManager;
            _cryptography = cryptography;
            _cobaltManager = cobaltManager;
        }

        [HttpGet]
        public CheckFileInfo CheckFileInfo(int accessTokenId)
        {
            var token = _tokenManager.GetToken(accessTokenId);

            var fileInfo = _wopiServer.GetCheckFileInfo(token.FilePath);

            return fileInfo;
        }

        public HttpResponseMessage GetFile(int accessTokenId)
        {
            var token = _tokenManager.GetToken(accessTokenId);

            var bytes = _webDavManager.GetFileBytes(token.FilePath);

            var result = new HttpResponseMessage(HttpStatusCode.OK);

            var stream = new MemoryStream(bytes);

            result.Content = new StreamContent(stream);
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");

            return result;
        }

        [HttpPost]
        public async Task<HttpResponseMessage> Cobalt(int accessTokenId)
        {
            var memoryStream = new MemoryStream();

            await Request.Content.CopyToAsync(memoryStream);

            var responseBatch = _cobaltManager.ProcessRequest(accessTokenId, memoryStream);

            var correlationId = Request.Headers.GetValues("X-WOPI-CorrelationID").FirstOrDefault() ?? "";

            var response = new HttpResponseMessage();

            response.Content = new PushStreamContent(
                (stream, content, context) =>
                {
                    responseBatch.CopyTo(stream);
                    stream.Close();
                });

            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            response.Content.Headers.ContentLength = responseBatch.Length;

            response.Headers.Add("X-WOPI-CorellationID", correlationId);
            response.Headers.Add("request-id", correlationId);

            return response;
        }

        [HttpPost]
        public HttpResponseMessage Lock(int accessTokenId)
        {
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        public HttpResponseMessage UnLock(int accessTokenId)
        {
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        public async Task<HttpResponseMessage> Put(int accessTokenId)
        {
            var token = _tokenManager.GetToken(accessTokenId);

            var bytes = await Request.Content.ReadAsByteArrayAsync();

            _webDavManager.UploadFile(token.FilePath, bytes);

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}