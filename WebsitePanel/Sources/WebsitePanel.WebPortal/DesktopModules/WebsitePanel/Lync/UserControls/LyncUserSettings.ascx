<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncUserSettings.ascx.cs" Inherits="WebsitePanel.Portal.Lync.UserControls.LyncUserSettings" %>
<%@ Register Src="../../ExchangeServer/UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<asp:DropDownList ID="ddlSipAddresses" runat="server" CssClass="NormalTextBox"></asp:DropDownList>
<wsp:EmailAddress id="email" runat="server" ValidationGroup="CreateMailbox"></wsp:EmailAddress>

