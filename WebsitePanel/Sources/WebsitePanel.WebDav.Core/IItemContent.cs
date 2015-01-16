using System.IO;

namespace WebsitePanel.WebDav.Core
{
    namespace Client
    {
        public interface IItemContent
        {
            long ContentLength { get; }
            string ContentType { get; }

            void Download(string filename);
            byte[] Download();
            void Upload(string filename);
            Stream GetReadStream();
            Stream GetWriteStream(long contentLength);
            Stream GetWriteStream(string contentType, long contentLength);
        }
    }
}