<%@ Control Language="C#" AutoEventWireup="false" %>
<div class="BrowseContainer">
  <div class="Header">
    <asp:Image ID="imgModuleIcon" runat="server" alt="" />                
    <asp:Label ID="lblModuleTitle" runat="server"></asp:Label>
  </div>
  <div class="Content">
    <asp:PlaceHolder ID="ContentPane" runat="server"/>
  </div>
</div>