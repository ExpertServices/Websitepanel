<%@ Control AutoEventWireup="true" %>
<%@ Register TagPrefix="wsp" TagName="SiteFooter" Src="~/DesktopModules/WebsitePanel/SkinControls/SiteFooter.ascx" %>
<%@ Register  TagPrefix="wsp" TagName="Logo" Src="~/DesktopModules/WebsitePanel/SkinControls/Logo.ascx" %>

<div id="LoginSkinOutline">
  <div id="LoginSkinContent">
    <a href='<%= Page.ResolveUrl("~/") %>'><asp:Image runat="server" SkinID="Logo" alt="" /></a>
    <div id="ContentLogin">
      <asp:PlaceHolder ID="ContentPane" runat="server"></asp:PlaceHolder>
    </div>
  </div>
  <div id="Footer">
    <wsp:SiteFooter ID="SiteFooter1" runat="server" />
  </div>
</div>