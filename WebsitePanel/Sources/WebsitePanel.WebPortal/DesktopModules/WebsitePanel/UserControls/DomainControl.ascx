<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DomainControl.ascx.cs" Inherits="WebsitePanel.Portal.UserControls.DomainControl" %>

<asp:TextBox ID="txtDomainName" runat="server" Width="300" CssClass="HugeTextBox" OnTextChanged="txtDomainName_TextChanged"></asp:TextBox>
<asp:Literal runat="server" ID="SubDomainSeparator" Visible="False">.</asp:Literal>
<asp:DropDownList ID="DomainsList" Runat="server" CssClass="NormalTextBox" DataTextField="DomainName" DataValueField="DomainName" Visible="False"></asp:DropDownList>
<asp:RequiredFieldValidator id="DomainRequiredValidator" runat="server" meta:resourcekey="DomainRequiredValidator"
    ControlToValidate="txtDomainName" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
<asp:CustomValidator id="DomainFormatValidator" runat="server" meta:resourcekey="DomainFormatValidator" EnableClientScript="False" ValidateEmptyText="False"
	ControlToValidate="txtDomainName" Display="Dynamic" SetFocusOnError="true" OnServerValidate="DomainFormatValidator_ServerValidate"></asp:CustomValidator>

