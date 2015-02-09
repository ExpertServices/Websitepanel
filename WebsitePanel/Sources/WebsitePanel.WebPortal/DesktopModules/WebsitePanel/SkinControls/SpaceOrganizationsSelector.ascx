<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpaceOrganizationsSelector.ascx.cs" Inherits="WebsitePanel.Portal.SkinControls.SpaceOrganizationsSelector" %>

<span id="spanOrgsSelector" class="OrgsSelector" runat="server" >
    <asp:DropDownList ID="ddlSpaceOrgs" runat="server" CssClass="NormalTextBox"
        OnSelectedIndexChanged="ddlSpaceOrgs_SelectedIndexChanged" EnableViewState="true" AutoPostBack="true">
    </asp:DropDownList> 
    |
    <asp:HyperLink ID="lnkOrgnsList" runat="server">Edit</asp:HyperLink>
</span>               
