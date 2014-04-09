<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationSecurityGroupGeneralSettings.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.OrganizationSecurityGroupGeneralSettings" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/UsersList.ascx" TagName="UsersList" TagPrefix="wsp"%>
<%@ Register Src="UserControls/SecurityGroupTabs.ascx" TagName="SecurityGroupTabs" TagPrefix="wsp"%>
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
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Security Group"></asp:Localize>

					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
				<div class="FormBody">
                    <wsp:SecurityGroupTabs id="tabs" runat="server" SelectedTab="secur_group_settings" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
					<table>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locDisplayName" runat="server" meta:resourcekey="locDisplayName" Text="Display Name: *"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtDisplayName" runat="server" CssClass="HugeTextBox200" ValidationGroup="CreateMailbox"></asp:TextBox>
								<asp:RequiredFieldValidator ID="valRequireDisplayName" runat="server" meta:resourcekey="valRequireDisplayName" ControlToValidate="txtDisplayName"
									ErrorMessage="Enter Display Name" ValidationGroup="EditList" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                <br />
						        <br />
							</td>
						</tr>
                        <tr>
                            <td class="FormLabel150"><asp:Localize ID="locGroupName" runat="server" meta:resourcekey="locGroupName" Text="Windows Group Name:"></asp:Localize></td>
                            <td><asp:Label runat="server" ID="lblGroupName" /></td>
                        </tr>
					    
					    <tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="2"><asp:Localize ID="locMembers" runat="server" meta:resourcekey="locMembers" Text="Members:"></asp:Localize></td>
						</tr>
						<tr>
						    <td colspan="2">
                                <wsp:UsersList id="members" runat="server" />
                            </td>
						</tr>
					    <tr><td>&nbsp;</td></tr>
						<tr>
							<td class="FormLabel150" colspan="2"><asp:Localize ID="locNotes" runat="server" meta:resourcekey="locNotes" Text="Notes:"></asp:Localize></td>
						</tr>
					    <tr>
						    <td colspan="2">
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