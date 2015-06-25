<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageCreateFolder.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageCreateFolder" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgESS" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Create New Folder"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
					<table>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locFolderName" runat="server" meta:resourcekey="locFolderName" Text="Folder Name: *"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtFolderName" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
								<asp:RequiredFieldValidator ID="valRequireFolderName" runat="server" meta:resourcekey="valRequireFolderName" ControlToValidate="txtFolderName"
									ErrorMessage="Enter Folder Name" ValidationGroup="CreateFolder" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
							</td>
						</tr>
                        <tr>
                            <tr>
							<td class="FormLabel150"><asp:Localize ID="locFolderSize" runat="server" meta:resourcekey="locFolderSize" Text="Folder Limit Size (Gb):"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtFolderSize" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireFolderSize" runat="server" meta:resourcekey="valRequireFolderSize" ControlToValidate="txtFolderSize"
									ErrorMessage="Enter Folder Size" ValidationGroup="CreateFolder" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rangeFolderSize" runat="server" ControlToValidate="txtFolderSize" MaximumValue="99999999" MinimumValue="0.01" Type="Double"
                                    ValidationGroup="CreateFolder" Display="Dynamic" Text="*" SetFocusOnError="True"
                                    ErrorMessage="The quota you’ve entered exceeds the available quota for tenant" />
							</td>
						</tr>
                        <tr>
                            <td class="FormLabel150"><asp:Localize ID="locQuotaType" runat="server" meta:resourcekey="locQuotaType" Text="Quota Type:"></asp:Localize></td>
                            <td class="FormRBtnL">
                                <asp:RadioButton ID="rbtnQuotaSoft" runat="server" meta:resourcekey="rbtnQuotaSoft" Text="Soft" GroupName="QuotaType"  />
                                <asp:RadioButton ID="rbtnQuotaHard" runat="server" meta:resourcekey="rbtnQuotaHard" Text="Hard" GroupName="QuotaType" Checked="true" />
                            </td>
                        </tr>
                        <tr>
                            <td class="FormLabel150"><asp:Localize ID="locAddDefaultGroup" runat="server" meta:resourcekey="locAddDefaultGroup" Text="Add Default Group:"></asp:Localize></td>
						    <td>
							    <asp:CheckBox id="chkAddDefaultGroup" runat="server" Checked="false"></asp:CheckBox>
						    </td>
					    </tr>
					</table>
				    <div class="FormFooterClean">
					    <asp:Button id="btnCreate" runat="server" Text="Create Folder" CssClass="Button1" meta:resourcekey="btnCreate" ValidationGroup="CreateFolder" OnClick="btnCreate_Click"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreateFolder" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>