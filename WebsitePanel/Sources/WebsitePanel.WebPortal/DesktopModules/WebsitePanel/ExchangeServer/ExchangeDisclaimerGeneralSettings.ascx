<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeDisclaimerGeneralSettings.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeDisclaimerGeneralSettings" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/AccountsList.ascx" TagName="AccountsList" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxSelector.ascx" TagName="MailboxSelector" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeList48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Distribution List"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="" />
                </div>
				<div class="FormBody">
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
					<table>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locDisplayName" runat="server" meta:resourcekey="locDisplayName" Text="Display Name: *"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtDisplayName" runat="server" CssClass="HugeTextBox200" ValidationGroup="CreateMailbox"></asp:TextBox>
								<asp:RequiredFieldValidator ID="valRequireDisplayName" runat="server" meta:resourcekey="valRequireDisplayName" ControlToValidate="txtDisplayName"
									ErrorMessage="Enter Display Name" ValidationGroup="EditList" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td class="FormLabel200"><asp:Localize ID="locNotes" runat="server" meta:resourcekey="locNotes" Text="Text:"></asp:Localize></td>
						    <td>
							    <asp:TextBox ID="txtNotes" runat="server" CssClass="TextBox200" Rows="4" TextMode="MultiLine"></asp:TextBox>
						    </td>
					    </tr>
					</table>
					
				    <div class="FormFooterClean">
					    <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" meta:resourcekey="btnSave" ValidationGroup="EditList" OnClick="btnSave_Click"></asp:Button>
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="EditList" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>