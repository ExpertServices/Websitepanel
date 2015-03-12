using System.IO;

namespace WebsitePanel.WebDav.Core
{
    namespace Client
    {
        public interface IItemContent
        {
            long ContentLength { get; }
            long AllocatedSpace { get; set; }
            string ContentType { get; }
            string Summary { get; set; }

            void Download(string filename);
            byte[] Download();
            void Upload(string filename);
            Stream GetReadStream();
            Stream GetWriteStream(long contentLength);
            Stream GetWriteStream(string contentType, long contentLength);
        }
    }
}