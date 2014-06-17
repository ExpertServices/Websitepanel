<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpaceOrganizationsSelector.ascx.cs" Inherits="WebsitePanel.Portal.SkinControls.SpaceOrganizationsSelector" %>

<span id="spanOrgsSelector" style="float:right;padding-right:10px;" runat="server" >
    <asp:DropDownList ID="ddlSpaceOrgs" runat="server" CssClass="NormalTextBox" Width="150px" style="vertical-align: middle;" 
        OnSelectedIndexChanged="ddlSpaceOrgs_SelectedIndexChanged" EnableViewState="true" AutoPostBack="true">
    </asp:DropDownList> 
    |
    <asp:HyperLink ID="lnkOrgnsList" runat="server">Edit</asp:HyperLink>
</span>               
