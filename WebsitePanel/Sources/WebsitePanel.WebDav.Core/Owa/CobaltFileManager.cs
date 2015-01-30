using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.Caching;
using Cobalt;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Interfaces.Managers;
using WebsitePanel.WebDav.Core.Interfaces.Owa;
using WebsitePanel.WebDav.Core.Interfaces.Storages;

namespace WebsitePanel.WebDav.Core.Owa
{
    public class CobaltFileManager : IWopiFileManager
    {
        private readonly IWebDavManager _webDavManager;
        private readonly IAccessTokenManager _tokenManager;
        private readonly ITtlStorage _storage;

        public CobaltFileManager(IWebDavManager webDavManager, IAccessTokenManager tokenManager, ITtlStorage storage)
        {
            _webDavManager = webDavManager;

            _tokenManager = tokenManager;
            _storage = storage;
        }

        public CobaltFile Create(int accessTokenId)
        {
            var disposal = new DisposalEscrow(accessTokenId.ToString(CultureInfo.InvariantCulture));

            var content = new CobaltFilePartitionConfig
            {
                IsNewFile = true,
                HostBlobStore = new TemporaryHostBlobStore(new TemporaryHostBlobStore.Config(), disposal, accessTokenId + @".Content"),
                cellSchemaIsGenericFda = true,
                CellStorageConfig = new CellStorageConfig(),
                Schema = CobaltFilePartition.Schema.ShreddedCobalt,
                PartitionId = FilePartitionId.Content
            };

            var coauth = new CobaltFilePartitionConfig
            {
                IsNewFile = true,
                HostBlobStore = new TemporaryHostBlobStore(new TemporaryHostBlobStore.Config(), disposal, accessTokenId + @".CoauthMetadata"),
                cellSchemaIsGenericFda = false,
                CellStorageConfig = new CellStorageConfig(),
                Schema = CobaltFilePartition.Schema.ShreddedCobalt,
                PartitionId = FilePartitionId.CoauthMetadata
            };

            var wacupdate = new CobaltFilePartitionConfig
            {
                IsNewFile = true,
                HostBlobStore = new TemporaryHostBlobStore(new TemporaryHostBlobStore.Config(), disposal, accessTokenId + @".WordWacUpdate"),
                cellSchemaIsGenericFda = false,
                CellStorageConfig = new CellStorageConfig(),
                Schema = CobaltFilePartition.Schema.ShreddedCobalt,
                PartitionId = FilePartitionId.WordWacUpdate
            };

            var partitionConfs = new Dictionary<FilePartitionId, CobaltFilePartitionConfig>
            {
                {FilePartitionId.Content, content},
                {FilePartitionId.WordWacUpdate, wacupdate},
                {FilePartitionId.CoauthMetadata, coauth}
            };

            var cobaltFile = new CobaltFile(disposal, partitionConfs, new CobaltHostLockingStore(), null);

            var token = _tokenManager.GetToken(accessTokenId);

            var fileBytes = _webDavManager.GetFileBytes(token.FilePath);

            var atom = new AtomFromByteArray(fileBytes);

            Cobalt.Metrics o1;
            cobaltFile.GetCobaltFilePartition(FilePartitionId.Content).SetStream(RootId.Default.Value, atom, out o1);
            cobaltFile.GetCobaltFilePartition(FilePartitionId.Content).GetStream(RootId.Default.Value).Flush();

            Add(accessTokenId, cobaltFile);

            return cobaltFile;
        }

        public CobaltFile Get(int accessTokenId)
        {
            return _storage.Get<CobaltFile>(GetFileKey(accessTokenId)); 
        }

        public bool Add(int accessTokenId, CobaltFile file)
        {
            return _storage.Add(GetFileKey(accessTokenId), file);
        }

        public bool Delete(int accessTokenId)
        {
            return _storage.Delete(GetFileKey(accessTokenId));
        }

        private string GetFileKey(int accessTokenId)
        {
            return string.Format("{0}", accessTokenId);
        }
    }
}