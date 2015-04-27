<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageFolderSettingsFolderPermissions.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageFolderSettingsFolderPermissions" %>


<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnterpriseStoragePermissions.ascx" TagName="ESPermissions" TagPrefix="wsp"%>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" Namespace="WebsitePanel.Portal.ExchangeServer.UserControls" Assembly="WebsitePanel.Portal.Modules" %>
<%@ Register Src="UserControls/EnterpriseStorageEditFolderTabs.ascx" TagName="CollectionTabs" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeList48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Folder"></asp:Localize>

					<asp:Literal ID="litFolderName" runat="server" Text="Folder" />
                </div>
				<div class="FormBody">
				    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="enterprisestorage_folder_settings_folder_permissions" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <wsp:CollapsiblePanel id="colFolderPermissions" runat="server"
                        TargetControlID="panelFolderPermissions" meta:resourcekey="colFolderPermissions" Text="">
                    </wsp:CollapsiblePanel>		
                    
                     <asp:Panel runat="server" ID="panelFolderPermissions">                                                
					    <table>
						    <tr>
							    <td colspan="2">
                                    <fieldset id="PermissionsPanel" runat="server">
                                        <legend><asp:Localize ID="PermissionsSection" runat="server" meta:resourcekey="locPermissionsSection" Text="Permissions"></asp:Localize></legend>
                                        <wsp:ESPermissions id="permissions" runat="server" />
                                    </fieldset>
						    </tr>
					        <tr><td>&nbsp;</td></tr>

					    </table>
                    </asp:Panel>
					
				    <div class="FormFooterClean">
					    <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" meta:resourcekey="btnSave" ValidationGroup="EditFolder" OnClick="btnSave_Click"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="EditFolder" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>
