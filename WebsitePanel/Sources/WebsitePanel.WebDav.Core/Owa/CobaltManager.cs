using System;
using System.IO;
using Cobalt;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;

namespace WebsitePanel.WebDav.Core.Owa
{
    public class CobaltManager : ICobaltManager
    {
        private readonly IWebDavManager _webDavManager;
        private readonly IWopiFileManager _fileManager;
        private readonly IAccessTokenManager _tokenManager;

        public CobaltManager(IWebDavManager webDavManager, IWopiFileManager fileManager, IAccessTokenManager tokenManager)
        {
            _webDavManager = webDavManager;
            _fileManager = fileManager;
            _tokenManager = tokenManager;
        }

        public Atom ProcessRequest(int accessTokenId, Stream requestStream)
        {
            var token = _tokenManager.GetToken(accessTokenId);

            var atomRequest = new AtomFromStream(requestStream);

            var requestBatch = new RequestBatch();

            var cobaltFile = _fileManager.Get(token.FilePath) ?? _fileManager.Create(accessTokenId);

            Object ctx;
            ProtocolVersion protocolVersion;

            requestBatch.DeserializeInputFromProtocol(atomRequest, out ctx, out protocolVersion);

            cobaltFile.CobaltEndpoint.ExecuteRequestBatch(requestBatch);

            foreach (var request in requestBatch.Requests)
            {
                if (request.GetType() == typeof(PutChangesRequest) && request.PartitionId == FilePartitionId.Content && request.CompletedSuccessfully)
                {
                    using (var saveStream = new MemoryStream())
                    {
                        GenericFdaStream myCobaltStream = new GenericFda(cobaltFile.CobaltEndpoint, null).GetContentStream();
                        myCobaltStream.CopyTo(saveStream);

                        _webDavManager.UploadFile(token.FilePath, saveStream.ToArray());
                    }
                }
            }

            return requestBatch.SerializeOutputToProtocol(protocolVersion);
        }
    }
} 