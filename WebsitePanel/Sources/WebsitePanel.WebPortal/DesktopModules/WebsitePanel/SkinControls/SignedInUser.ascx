<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SignedInUser.ascx.cs" Inherits="WebsitePanel.Portal.SkinControls.SignedInUser" %>
<asp:Panel ID="AnonymousPanel" runat="server">
	<asp:HyperLink ID="lnkSignIn" runat="server" meta:resourcekey="lnkSignIn">Sign In</asp:HyperLink>
</asp:Panel>
<asp:Panel ID="LoggedPanel" runat="server">
	<strong><asp:HyperLink ID="lnkEditUserDetails" runat="server" meta:resourcekey="lnkEditUserDetails">My Account</asp:HyperLink></strong>
	|
    <asp:ImageButton ID="imgSignOut" runat="server" CausesValidation="false" OnClick="cmdSignOut_Click" />
</asp:Panel>