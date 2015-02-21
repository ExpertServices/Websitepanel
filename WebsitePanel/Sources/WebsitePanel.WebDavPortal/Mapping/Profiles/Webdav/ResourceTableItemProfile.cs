using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using AutoMapper;
using WebsitePanel.WebDav.Core.Client;
using WebsitePanel.WebDav.Core.Config;
using WebsitePanel.WebDav.Core.Extensions;
using WebsitePanel.WebDavPortal.FileOperations;
using WebsitePanel.WebDavPortal.Models.FileSystem;

namespace WebsitePanel.WebDavPortal.Mapping.Profiles.Webdav
{
    public class ResourceTableItemProfile : Profile
    {
        /// <summary>
        ///     Gets the name of the profile.
        /// </summary>
        /// <value>
        ///     The name of the profile.
        /// </value>
        public override string ProfileName
        {
            get
            {
                return this.GetType().Name;
            }
        }

        /// <summary>
        ///     Override this method in a derived class and call the CreateMap method to associate that map with this profile.
        ///     Avoid calling the <see cref="T:AutoMapper.Mapper" /> class from this method.
        /// </summary>
        protected override void Configure()
        {
            var openerManager = new FileOpenerManager();

            Mapper.CreateMap<IHierarchyItem, ResourceTableItemModel>()
                .ForMember(ti => ti.DisplayName, x => x.MapFrom(hi => hi.DisplayName.Trim('/')))
                .ForMember(ti => ti.Url, x => x.MapFrom(hi => openerManager.GetUrl(hi)))
                .ForMember(ti => ti.IsTargetBlank, x => x.MapFrom(hi => openerManager.GetIsTargetBlank(hi)))
                .ForMember(ti => ti.Type, x => x.MapFrom(hi => (new WebDavResource(null, hi)).ItemType.GetDescription().ToLowerInvariant()))
                .ForMember(ti => ti.IconHref, x => x.MapFrom(hi => (new WebDavResource(null, hi)).ItemType == ItemType.Folder ? WebDavAppConfigManager.Instance.FileIcons.FolderPath.Trim('~') : WebDavAppConfigManager.Instance.FileIcons[Path.GetExtension(hi.DisplayName.Trim('/'))].Trim('~')))
                .ForMember(ti => ti.LastModified, x => x.MapFrom(hi => (new WebDavResource(null, hi)).LastModified))
                .ForMember(ti => ti.LastModifiedFormated,
                            x => x.MapFrom(hi => (new WebDavResource(null, hi)).LastModified == DateTime.MinValue ? "--" : (new WebDavResource(null, hi)).LastModified.ToString("dd/MM/yyyy hh:mm tt")))

                .ForMember(ti => ti.Size, x => x.MapFrom(hi => (new WebDavResource(null,hi)).ContentLength))
                .ForMember(ti => ti.IsFolder, x => x.MapFrom(hi => (new WebDavResource(null, hi)).ItemType == ItemType.Folder));
        }
    }
}