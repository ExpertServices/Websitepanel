<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WebSitesAddPointer.ascx.cs" Inherits="WebsitePanel.Portal.WebSitesAddPointer" %>
<%@ Register Src="DomainsSelectDomainControl.ascx" TagName="DomainsSelectDomainControl" TagPrefix="uc1" %>
<div class="FormBody">
<table cellSpacing="0" cellPadding="4">
	<tr>
		<td class="SubHead">
		    <asp:Label ID="lblDomainName" runat="server" meta:resourcekey="lblDomainName" Text="Domain name:"></asp:Label>
		</td>
		<td>
			<asp:TextBox ID="txtHostName" runat="server" CssClass="TextBox100" MaxLength="64" Text="www"></asp:TextBox>.<uc1:DomainsSelectDomainControl ID="domainsSelectDomainControl" runat="server" HideWebSites="false" HideDomainPointers="true" HideInstantAlias="true"/>
            <asp:RequiredFieldValidator ID="valRequireHostName" runat="server" meta:resourcekey="valRequireHostName" ControlToValidate="txtHostName"
	            ErrorMessage="Enter hostname" ValidationGroup="CreateSite" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="valRequireCorrectHostName" runat="server"
	                ErrorMessage="Enter valid hostname" ControlToValidate="txtHostName" Display="Dynamic"
	                meta:resourcekey="valRequireCorrectHostName" ValidationExpression="^([0-9a-zA-Z])*[0-9a-zA-Z]+$" SetFocusOnError="True"></asp:RegularExpressionValidator>
		</td>
	</tr>
</table>
</div>
<div class="FormFooter">
    <asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd" Text="Add" CssClass="Button2" OnClick="btnAdd_Click" />
    <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" CausesValidation="false" Text="Cancel" CssClass="Button1" OnClick="btnCancel_Click" />
</div>