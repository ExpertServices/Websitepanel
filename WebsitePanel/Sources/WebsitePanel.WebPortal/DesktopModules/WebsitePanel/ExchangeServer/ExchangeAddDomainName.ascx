<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeAddDomainName.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeAddDomainName" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="domains" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainNameAdd48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Add Domain"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
					<table>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locDomainName" runat="server" meta:resourcekey="locDomainName" Text="Domain Name:"></asp:Localize></td>
							<td>
                            <asp:DropDownList id="ddlDomains" runat="server" CssClass="NormalTextBox" DataTextField="DomainName" DataValueField="DomainID" style="vertical-align:middle;"></asp:DropDownList>
							</td>
						</tr>
					</table>
					<br />
				    <div class="FormFooterClean">
					    <asp:Button id="btnAdd" runat="server" Text="Add Domain" CssClass="Button1" meta:resourcekey="btnAdd" ValidationGroup="CreateDomain" OnClick="btnAdd_Click" OnClientClick="ShowProgressDialog('Creating Domain...');"></asp:Button>
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreateDomain" />
                        <asp:Button id="btnCancel" runat="server" Text="Cancel" CssClass="Button1" meta:resourcekey="btnCancel" OnClick="btnCancel_Click"></asp:Button>
				    </div>
				</div>
			</div>

		</div>
	</div>
</div>