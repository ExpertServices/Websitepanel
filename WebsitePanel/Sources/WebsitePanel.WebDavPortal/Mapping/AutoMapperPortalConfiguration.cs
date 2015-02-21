using AutoMapper;
using WebsitePanel.WebDavPortal.Mapping.Profiles.Webdav;

namespace WebsitePanel.WebDavPortal.Mapping
{
    public class AutoMapperPortalConfiguration
    {
        public static void Configure()
        {
            Mapper.Initialize(
                config =>
                {
                    config.AddProfile<ResourceTableItemProfile>();
                });
        } 
    }
}