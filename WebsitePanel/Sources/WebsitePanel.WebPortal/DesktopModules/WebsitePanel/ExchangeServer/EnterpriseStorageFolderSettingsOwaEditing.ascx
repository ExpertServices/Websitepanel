<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageFolderSettingsOwaEditing.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageFolderSettingsOwaEditing" %>


<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnterpriseStorageOwaUsersList.ascx" TagName="OwaUsers" TagPrefix="wsp"%>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
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
				    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="enterprisestorage_folder_settings_owa_editing" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <wsp:CollapsiblePanel id="colOwaEditing" runat="server"
                        TargetControlID="panelFolderPermissions" meta:resourcekey="colOwaEditing" Text="">
                    </wsp:CollapsiblePanel>		
                    
                     <asp:Panel runat="server" ID="panelFolderPermissions">                                                
					    <table>
						    <tr>
							    <td colspan="2">
                                    <fieldset id="OwaUsersPanel" runat="server">
                                        <legend><asp:Localize ID="locOwaEditingSection" runat="server" meta:resourcekey="locOwaEditingSection" Text="Users"></asp:Localize></legend>
                                        <wsp:OwaUsers id="owaUsers" runat="server" />
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