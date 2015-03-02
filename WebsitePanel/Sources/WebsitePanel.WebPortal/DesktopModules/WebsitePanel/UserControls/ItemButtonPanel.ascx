<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ItemButtonPanel.ascx.cs" Inherits="WebsitePanel.Portal.ItemButtonPanel" %>
<asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" meta:resourcekey="btnSave" 
    OnClick="btnSave_Click" OnClientClick="ShowProgressDialog('Updating ...');"></asp:Button>
<asp:Button id="btnSaveExit" runat="server" Text="Save Changes and Exit" CssClass="Button1" meta:resourcekey="btnSaveExit" 
    OnClick="btnSaveExit_Click" OnClientClick="ShowProgressDialog('Updating ...');"></asp:Button>