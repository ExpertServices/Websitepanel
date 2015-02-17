<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSCollectionServers.ascx.cs" Inherits="WebsitePanel.Portal.RDS.UserControls.RDSCollectionServers" %>
<%@ Register Src="../../UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../../UserControls/CollapsiblePanel.ascx" %>

<asp:UpdatePanel ID="UsersUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
	<div class="FormButtonsBarClean">
		<asp:Button ID="btnAdd" runat="server" Text="Add..." CssClass="Button1"  OnClick="btnAdd_Click" meta:resourcekey="btnAdd"  />
		<asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="Button1" OnClick="btnDelete_Click" meta:resourcekey="btnDelete"/>
        <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="Button1" OnClick="btnRefresh_Click" OnClientClick="ShowProgressDialog('Refreshing...'); return true;" meta:resourcekey="btnRefresh"  />
	</div>
	<asp:GridView ID="gvServers" runat="server" meta:resourcekey="gvServers" AutoGenerateColumns="False"
		Width="600px" CssSelectorClass="NormalGridView"
		DataKeyNames="Id" OnRowCommand="gvServers_RowCommand">
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
			<asp:TemplateField meta:resourcekey="gvServerName" HeaderText="gvServerName">
				<ItemStyle Width="30%" Wrap="false">
				</ItemStyle>
				<ItemTemplate>
                    <asp:Literal ID="litFqdName" runat="server" Text='<%# Eval("FqdName") %>'></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
            <asp:TemplateField meta:resourcekey="gvPopupStatus">
                <ItemStyle Width="30%" HorizontalAlign="Left" />
                <ItemTemplate>
                    <asp:Literal ID="litStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Literal>
                    <asp:HiddenField ID="hdnRdsCollectionId" runat="server" Value='<%# Eval("RdsCollectionId") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField meta:resourcekey="gvViewInfo">
                <ItemStyle Width="10%" HorizontalAlign="Right"/>
                <ItemTemplate>
                    <asp:LinkButton OnClientClick="ShowProgressDialog('Getting Server Info ...');return true;" Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>' CommandName="ViewInfo" CommandArgument='<%# Eval("FqdName")%>' ID="lbViewInfo" runat="server" Text="View Info"/>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField meta:resourcekey="gvRestart">
                <ItemStyle Width="10%" HorizontalAlign="Right"/>
                <ItemTemplate>
                    <asp:LinkButton ID="lbRestart" CommandName="Restart" CommandArgument='<%# Eval("FqdName")%>' Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>'
                        runat="server" Text="Restart" OnClientClick="return confirm('Are you sure you want to restart selected server?')"/>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField meta:resourcekey="gvShutdown">
                <ItemStyle Width="10%" HorizontalAlign="Right"/>
                <ItemTemplate>
                    <asp:LinkButton ID="lbShutdown" CommandName="ShutDown" CommandArgument='<%# Eval("FqdName")%>' Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>'
                        runat="server" Text="Shut Down" OnClientClick="return confirm('Are you sure you want to shu down selected server?')"/>
                </ItemTemplate>
            </asp:TemplateField>
		</Columns>
	</asp:GridView>
    <br />

    <asp:Panel ID="ServerInfoPanel" runat="server" CssClass="Popup" style="display:none">
        <table class="Popup-Header" cellpadding="0" cellspacing="0">
            <tr>
                <td class="Popup-HeaderLeft"/>
                <td class="Popup-HeaderTitle">
                    <asp:Localize ID="Localize1" runat="server" meta:resourcekey="headerServerInfo"></asp:Localize>
                </td>
                <td class="Popup-HeaderRight"/>
            </tr>
        </table>
        <div class="Popup-Content">
            <div class="Popup-Body">
                <br />
                <asp:UpdatePanel ID="serverInfoUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                    <ContentTemplate>
                        <div class="Popup-Scroll" style="height:auto;">
                            <wsp:CollapsiblePanel id="secServerInfo" runat="server" TargetControlID="panelHardwareInfo" meta:resourcekey="secRdsApplicationEdit" Text=""/>                            
                            <asp:Panel runat="server" ID="panelHardwareInfo">
                                <table>
                                    <tr>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="locProcessor" runat="server" Text="Processor:"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="litProcessor" runat="server"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="locLoadPercentage" Text="Load Percentage:" runat="server"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="litLoadPercentage" runat="server"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="locMemoryAllocated" runat="server" Text="Allocated Memory:"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="litMemoryAllocated" runat="server"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="locFreeMemory" Text="Free Memory:" runat="server"/>
                                        </td>
                                        <td class="FormLabel150" style="width: 150px;">
                                            <asp:Literal ID="litFreeMemory" runat="server"/>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <wsp:CollapsiblePanel id="secRdsApplicationEdit" runat="server" TargetControlID="panelDiskDrives" meta:resourcekey="secRdsApplicationEdit" Text="Disk Drives"/>
                            <asp:Panel runat="server" ID="panelDiskDrives">
                                <table>
                                    <asp:Repeater ID="rpServerDrives" runat="server" EnableViewState="false">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="litDeviceId" runat="server" Text='<%# Eval("DeviceId") %>'/>
                                                </td>
                                                <td class="FormLabel150" style="width: 150px;"/>                                                                                                                                    
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="locVolumeName" Text="Volume Name:" runat="server"/>
                                                </td>
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="litVolumeName" Text='<%# Eval("VolumeName") %>' runat="server"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="locSize" Text="Size:" runat="server"/>
                                                </td>
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="litSize" Text='<%# Eval("SizeMb") + " MB" %>' runat="server"/>
                                                </td>                                                                                                                                    
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="locFreeSpace" Text="Free Space:" runat="server"/>
                                                </td>
                                                <td class="FormLabel150" style="width: 150px;">
                                                    <asp:Literal ID="litFreeSpace" Text='<%# Eval("FreeSpaceMb") + " MB" %>' runat="server"/>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                            </asp:Panel>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
			<br />
            </div>
            <div class="FormFooter">                
                <asp:Button ID="btnCancelServerInfo" runat="server" CssClass="Button1" meta:resourcekey="btnServerInfoCancel" Text="Cancel" CausesValidation="false" />
            </div>
        </div>
    </asp:Panel>
        
        <asp:Panel ID="AddServersPanel" runat="server" CssClass="Popup" style="display:none">
	<table class="Popup-Header" cellpadding="0" cellspacing="0">
		<tr>
			<td class="Popup-HeaderLeft"></td>
			<td class="Popup-HeaderTitle">
				<asp:Localize ID="headerAddServers" runat="server" meta:resourcekey="headerAddServers"></asp:Localize>
			</td>
			<td class="Popup-HeaderRight"></td>
		</tr>
	</table>
	<div class="Popup-Content">
		<div class="Popup-Body">
			<br />
<asp:UpdatePanel ID="AddServersUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
	            
                <div class="FormButtonsBarClean">
                    <div class="FormButtonsBarCleanRight">
                        <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                            <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"></asp:TextBox><asp:ImageButton ID="cmdSearch" Runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton"
	                            CausesValidation="false" OnClick="cmdSearch_Click"/>
                        </asp:Panel>
                    </div>
                </div>
                <div class="Popup-Scroll">
					<asp:GridView ID="gvPopupServers" runat="server" meta:resourcekey="gvPopupServers" AutoGenerateColumns="False"
						Width="100%" CssSelectorClass="NormalGridView"
						DataKeyNames="Id">
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
							<asp:TemplateField meta:resourcekey="gvPopupServerName">
								<ItemStyle Width="70%"/>
								<ItemTemplate>
									<asp:Literal ID="litName" runat="server" Text='<%# Eval("FqdName") %>'></asp:Literal>
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

        <asp:Button ID="btnViewInfoFake" runat="server" style="display:none;" />
        <ajaxToolkit:ModalPopupExtender ID="ViewInfoModal" runat="server" TargetControlID="btnViewInfoFake" PopupControlID="ServerInfoPanel" 
            BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelServerInfo"/>
        
        <asp:Button ID="btnAddServersFake" runat="server" style="display:none;" />
        <ajaxToolkit:ModalPopupExtender ID="AddServersModal" runat="server" TargetControlID="btnAddServersFake" PopupControlID="AddServersPanel"
            BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelAdd"/>
	</ContentTemplate>
</asp:UpdatePanel>