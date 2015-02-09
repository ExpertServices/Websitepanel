<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSCollectionApps.ascx.cs" Inherits="WebsitePanel.Portal.RDS.UserControls.RDSCollectionApps" %>
<%@ Register Src="../../UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>

<asp:UpdatePanel ID="RDAppsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
	<div class="FormButtonsBarClean">
		<asp:Button ID="btnAdd" runat="server" Text="Add..." CssClass="Button1"  OnClick="btnAdd_Click" meta:resourcekey="btnAdd"  />
		<asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="Button1" OnClick="btnDelete_Click" meta:resourcekey="btnDelete"/>        
	</div>
	<asp:GridView ID="gvApps" runat="server" meta:resourcekey="gvApps" AutoGenerateColumns="False"
		Width="600px" CssSelectorClass="NormalGridView"
		DataKeyNames="Alias">
		<Columns>
			<asp:TemplateField>
				<HeaderTemplate>
					<asp:CheckBox ID="chkSelectAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
				</HeaderTemplate>
				<ItemTemplate>
					<asp:CheckBox ID="chkSelect" runat="server" />
				</ItemTemplate>
				<ItemStyle Width="10px" />
			</asp:TemplateField>
			<asp:TemplateField meta:resourcekey="gvAppName" HeaderText="gvAppName">
				<ItemStyle Width="90%" Wrap="false">
				</ItemStyle>
				<ItemTemplate>
                    <asp:hyperlink id="lnkDisplayName" meta:resourcekey="lnkDisplayName" runat="server" Text='<%# Eval("DisplayName") %>' NavigateUrl='<%# GetCollectionUsersEditUrl(Eval("Alias").ToString()) %>'/>                    
                    <asp:HiddenField ID="hfFilePath" runat="server"  Value='<%# Eval("FilePath") %>'/>
                    <asp:HiddenField ID="hfRequiredCommandLine" runat="server"  Value='<%# Eval("RequiredCommandLine") %>'/>
				</ItemTemplate>
			</asp:TemplateField>            
		</Columns>
	</asp:GridView>
    <br />


<asp:Panel ID="AddAppsPanel" runat="server" CssClass="Popup" style="display:none">
	<table class="Popup-Header" cellpadding="0" cellspacing="0">
		<tr>
			<td class="Popup-HeaderLeft"></td>
			<td class="Popup-HeaderTitle">
				<asp:Localize ID="headerAddApps" runat="server" meta:resourcekey="headerAddApps"></asp:Localize>
			</td>
			<td class="Popup-HeaderRight"></td>
		</tr>
	</table>
	<div class="Popup-Content">
		<div class="Popup-Body">
			<br />
<asp:UpdatePanel ID="AddAppsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>	            
                <div class="FormButtonsBarClean">
                </div>
                <div class="Popup-Scroll">
					<asp:GridView ID="gvPopupApps" runat="server" meta:resourcekey="gvPopupApps" AutoGenerateColumns="False"
						Width="100%" CssSelectorClass="NormalGridView"
						DataKeyNames="DisplayName">
						<Columns>
							<asp:TemplateField>
								<HeaderTemplate>
									<asp:CheckBox ID="chkSelectAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
								</HeaderTemplate>
								<ItemTemplate>
									<asp:CheckBox ID="chkSelect" runat="server" />
								</ItemTemplate>
								<ItemStyle Width="10px" />
							</asp:TemplateField>
							<asp:TemplateField meta:resourcekey="gvPopupAppName">
								<ItemStyle Width="70%"></ItemStyle>
								<ItemTemplate>
									<asp:Literal ID="litName" runat="server" Text='<%# Eval("DisplayName") %>'></asp:Literal>
                                    <asp:HiddenField ID="hfFilePathPopup" runat="server" Value='<%# Eval("FilePath") %>'/>
                                    <asp:HiddenField ID="hfRequiredCommandLinePopup" runat="server"  Value='<%# Eval("RequiredCommandLine") %>'/>
								</ItemTemplate>
							</asp:TemplateField>
						</Columns>
					</asp:GridView>
				</div>
	</ContentTemplate>
</asp:UpdatePanel>
			<br />
		</div>
		
		<div class="FormFooter">
			<asp:Button ID="btnAddSelected" runat="server" CssClass="Button1" meta:resourcekey="btnAddSelected" Text="Add Servers" OnClick="btnAddSelected_Click" />
			<asp:Button ID="btnCancelAdd" runat="server" CssClass="Button1" meta:resourcekey="btnCancel" Text="Cancel" CausesValidation="false" />
		</div>
	</div>
</asp:Panel>

<asp:Button ID="btnAddAppsFake" runat="server" style="display:none;" />
<ajaxToolkit:ModalPopupExtender ID="AddAppsModal" runat="server"
	TargetControlID="btnAddAppsFake" PopupControlID="AddAppsPanel"
	BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelAdd" />

	</ContentTemplate>
</asp:UpdatePanel>