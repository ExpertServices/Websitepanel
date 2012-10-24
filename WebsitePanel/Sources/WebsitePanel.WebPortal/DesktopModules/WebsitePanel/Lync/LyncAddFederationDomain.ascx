<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncAddFederationDomain.ascx.cs" Inherits="WebsitePanel.Portal.LyncAddFederationDomain" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />

<div id="ExchangeContainer">
    <div class="Module">
        <div class="Header">
            <wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" meta:resourcekey="breadcrumb" />
        </div>
        <div class="Left">
            <wsp:Menu id="menu" runat="server" />
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                </div>
                <div class="FormBody">
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    <table id="AddFederationDomain"   runat="server" width="100%"> 					    
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize ID="locDomainName" runat="server" meta:resourcekey="locDomainName" Text="Domain Name: *"></asp:Localize>
                            </td>
                            <td>                                
                                <asp:TextBox ID="DomainName" runat="server" Width="300" CssClass="HugeTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator id="DomainRequiredValidator" runat="server" meta:resourcekey="DomainRequiredValidator"
                                    ControlToValidate="DomainName" Display="Dynamic" ValidationGroup="Domain" SetFocusOnError="true"></asp:RequiredFieldValidator>
		                        <asp:RegularExpressionValidator id="DomainFormatValidator" runat="server" meta:resourcekey="DomainFormatValidator"
		                            ControlToValidate="DomainName" Display="Dynamic" ValidationGroup="Domain" SetFocusOnError="true"
		                            ValidationExpression="^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.){1,10}[a-zA-Z]{2,6}$"></asp:RegularExpressionValidator>
                            </td>
					    </tr>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize ID="locProxyFQDN" runat="server" meta:resourcekey="locProxyFQDN" Text="Proxy FQDN: "></asp:Localize>
                            </td>
                            <td>                                
                                <asp:TextBox ID="ProxyFQDN" runat="server" Width="300" CssClass="HugeTextBox"></asp:TextBox>
		                        <asp:RegularExpressionValidator id="ProxyFqdnFormatValidator" runat="server" meta:resourcekey="ProxyFqdnFormatValidator"
		                            ControlToValidate="ProxyFQDN" Display="Dynamic" ValidationGroup="Domain" SetFocusOnError="true"
		                            ValidationExpression="^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.){1,10}[a-zA-Z]{2,6}$"></asp:RegularExpressionValidator>
                            </td>
					    </tr>
                    </table>
                    <br />
                    <div class="FormButtonsBarClean">
                        <asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd" CssClass="Button2" Text="Add Domain" ValidationGroup="Domain" OnClick="btnAdd_Click" OnClientClick="ShowProgressDialog('Adding Domain...');"/>
                        <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" CssClass="Button1" Text="Cancel" CausesValidation="false" OnClick="btnCancel_Click" />
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="Domain" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>