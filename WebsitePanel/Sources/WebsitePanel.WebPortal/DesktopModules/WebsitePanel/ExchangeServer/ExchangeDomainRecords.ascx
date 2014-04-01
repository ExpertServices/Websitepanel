<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeDomainRecords.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeDomainRecords" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="domains" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainName48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Domain Names"></asp:Localize>
					-
					<asp:Literal ID="litDomainName" runat="server"></asp:Literal>
				</div>
				<div class="FormBody">
				
<asp:UpdatePanel ID="RecordsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
    
				<wsp:SimpleMessageBox id="messageBox" runat="server" />
		    

				<div class="FormButtonsBarClean">
					<div class="FormButtonsBarCleanLeft" style="padding-bottom: 4px;">
						<asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd" Text="Add record" CssClass="Button2" CausesValidation="False" />
					</div>
					<div class="FormButtonsBarCleanRight">
						<asp:UpdateProgress ID="recordsProgress" runat="server"
							AssociatedUpdatePanelID="RecordsUpdatePanel" DynamicLayout="false">
							<ProgressTemplate>
								<asp:Image ID="imgSep" runat="server" SkinID="AjaxIndicator" />
							</ProgressTemplate>
						</asp:UpdateProgress>
					</div>
				</div>

				<asp:GridView ID="gvRecords" runat="server" AutoGenerateColumns="False" EmptyDataText="gvRecords"
					CssSelectorClass="NormalGridView"
					OnRowEditing="gvRecords_RowEditing" OnRowDeleting="gvRecords_RowDeleting"
					AllowSorting="True" DataSourceID="odsDnsRecords">
					<Columns>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:ImageButton ID="cmdEdit" runat="server" SkinID="EditSmall" CommandName="edit" AlternateText="Edit record">
								</asp:ImageButton>
                                <asp:Literal ID="litMxPriority" runat="server" Text='<%# Eval("MxPriority") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litRecordName" runat="server" Text='<%# Eval("RecordName") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litRecordType" runat="server" Text='<%# Eval("RecordType") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litRecordData" runat="server" Text='<%# Eval("RecordData") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litSrvPriority" runat="server" Text='<%# Eval("SrvPriority") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litSrvWeight" runat="server" Text='<%# Eval("SrvWeight") %>' Visible="false"></asp:Literal>
                                <asp:Literal ID="litSrvPort" runat="server" Text='<%# Eval("SrvPort") %>' Visible="false"></asp:Literal>
							</ItemTemplate>
							<ItemStyle CssClass="NormalBold" Wrap="False" />
						</asp:TemplateField>
						<asp:BoundField DataField="RecordName" SortExpression="RecordName" HeaderText="gvRecordsName" />
						<asp:BoundField DataField="RecordType" SortExpression="RecordType" HeaderText="gvRecordsType" />
						<asp:TemplateField SortExpression="RecordData" HeaderText="gvRecordsData" >
							<ItemStyle Width="100%" />
							<ItemTemplate>
                                <%# GetRecordFullData((string)Eval("RecordType"), (string)Eval("RecordData"), (int)Eval("MxPriority"), (int)Eval("SrvPort"))%>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:ImageButton ID="cmdDelete" runat="server" SkinID="ExchangeDelete" CommandName="delete"
									AlternateText="Delete record" OnClientClick="return confirm('Delete record?');">
								</asp:ImageButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>

				<br />
				<div style="text-align: center">
					<asp:Button ID="btnBack" runat="server" meta:resourcekey="btnBack" CssClass="Button1" CausesValidation="false" 
						Text="Back" OnClick="btnBack_Click"/>
				</div>



				<asp:ObjectDataSource ID="odsDnsRecords" runat="server"
					SelectMethod="GetRawDnsZoneRecords" TypeName="WebsitePanel.Portal.ServersHelper"
						OnSelected="odsDnsRecords_Selected">
					<SelectParameters>
						<asp:QueryStringParameter DefaultValue="0" Name="domainId" QueryStringField="DomainID" />
					</SelectParameters>
				</asp:ObjectDataSource>
					
					
		<asp:Panel ID="EditRecordPanel" runat="server" CssClass="Popup" style="display:none">
			<table class="Popup-Header" cellpadding="0" cellspacing="0">
				<tr>
					<td class="Popup-HeaderLeft"></td>
					<td class="Popup-HeaderTitle">
						<asp:Localize ID="headerEditRecord" runat="server" meta:resourcekey="headerEditRecord"></asp:Localize>
					</td>
					<td class="Popup-HeaderRight"></td>
				</tr>
			</table>
			<div class="Popup-Content">
				<div class="Popup-Body">
					<br />
					
			<asp:UpdatePanel ID="EditRecordUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
				<ContentTemplate>
					<table width="450">
						<tr>
							<td class="SubHead" width="150" nowrap><asp:Label ID="lblRecordType" runat="server" meta:resourcekey="lblRecordType" Text="Record Type:"></asp:Label></td>
							<td class="NormalBold" width="100%">
								<asp:DropDownList ID="ddlRecordType" runat="server" SelectedValue='<%# Bind("RecordType") %>' CssClass="NormalTextBox" AutoPostBack="True" OnSelectedIndexChanged="ddlRecordType_SelectedIndexChanged">
                                    <asp:ListItem>A</asp:ListItem>
									<asp:ListItem>AAAA</asp:ListItem>
                                    <asp:ListItem>MX</asp:ListItem>
                                    <asp:ListItem>NS</asp:ListItem>
                                    <asp:ListItem>TXT</asp:ListItem>
                                    <asp:ListItem>CNAME</asp:ListItem>
                                    <asp:ListItem>SRV</asp:ListItem>
								</asp:DropDownList><asp:Literal ID="litRecordType" runat="server"></asp:Literal>
							</td>
						</tr>
						<tr>
							<td class="SubHead"><asp:Label ID="lblRecordName" runat="server" meta:resourcekey="lblRecordName" Text="Record Name:"></asp:Label></td>
							<td class="NormalBold">
								<asp:TextBox ID="txtRecordName" runat="server" Width="100px" CssClass="NormalTextBox"></asp:TextBox>
							</td>
						</tr>
                        <tr id="rowData" runat="server">
                            <td class="SubHead"><asp:Label ID="lblRecordData" runat="server" meta:resourcekey="lblRecordData" Text="Record Data:"></asp:Label></td>
                            <td class="NormalBold" nowrap>
				                <asp:TextBox ID="txtRecordData" runat="server" Width="260px" CssClass="NormalTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireData" runat="server" ControlToValidate="txtRecordData"
                                    ErrorMessage="*" ValidationGroup="DnsZoneRecord" Display="Dynamic"></asp:RequiredFieldValidator>
                             </td>
                        
                        </tr>
						<tr>
                            <asp:CustomValidator ID="IPValidator" runat="server" ControlToValidate="txtRecordData" ValidationGroup="DnsZoneRecord" Display="Dynamic"
                                OnServerValidate="Validate" Text="Please enter a valid IP" meta:resourcekey="IPValidator" />
						</tr>
                        <tr id="rowMXPriority" runat="server">
                            <td class="SubHead"><asp:Label ID="lblMXPriority" runat="server" meta:resourcekey="lblMXPriority" Text="MX Priority:"></asp:Label></td>
                            <td class="NormalBold">
                                <asp:TextBox ID="txtMXPriority" runat="server" Width="30" CssClass="NormalTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireMxPriority" runat="server" ControlToValidate="txtMXPriority"
                                    ErrorMessage="*" ValidationGroup="DnsZoneRecord" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="valRequireCorrectPriority" runat="server" ControlToValidate="txtMXPriority"
                                    ErrorMessage="*" ValidationExpression="\d{1,3}"></asp:RegularExpressionValidator></td>
                        </tr>

                        <tr id="rowSRVPriority" runat="server">
                            <td class="SubHead"><asp:Label ID="lblSRVPriority" runat="server" meta:resourcekey="lblSRVPriority" Text="Priority:"></asp:Label></td>
                            <td class="NormalBold">
                                <asp:TextBox ID="txtSRVPriority" runat="server" Width="30" CssClass="NormalTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireSrvPriority" runat="server" ControlToValidate="txtSRVPriority"
                                    ErrorMessage="*" ValidationGroup="DnsZoneRecord" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="valRequireCorrectSrvPriority" runat="server" ControlToValidate="txtSRVPriority"
                                    ErrorMessage="*" ValidationExpression="\d{1,3}"></asp:RegularExpressionValidator></td>
                        </tr>

                        <tr id="rowSRVWeight" runat="server">
                            <td class="SubHead"><asp:Label ID="lblSRVWeight" runat="server" meta:resourcekey="lblSRVWeight" Text="Weight:"></asp:Label></td>
                            <td class="NormalBold">
                                <asp:TextBox ID="txtSRVWeight" runat="server" Width="30" CssClass="NormalTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireSrvWeight" runat="server" ControlToValidate="txtSRVWeight"
                                    ErrorMessage="*" ValidationGroup="DnsZoneRecord" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="valRequireCorrectSrvWeight" runat="server" ControlToValidate="txtSRVWeight"
                                    ErrorMessage="*" ValidationExpression="\d{1,3}"></asp:RegularExpressionValidator></td>
                        </tr>

                        <tr id="rowSRVPort" runat="server">
                            <td class="SubHead"><asp:Label ID="lblSRVPort" runat="server" meta:resourcekey="lblSRVPort" Text="Port Number:"></asp:Label></td>
                            <td class="NormalBold">
                                <asp:TextBox ID="txtSRVPort" runat="server" Width="30" CssClass="NormalTextBox"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="valRequireSrvPort" runat="server" ControlToValidate="txtSRVPort"
                                    ErrorMessage="*" ValidationGroup="DnsZoneRecord" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="valRequireCorrectSrvPort" runat="server" ControlToValidate="txtSRVPort"
                                    ErrorMessage="*" ValidationExpression="\d{1,3}"></asp:RegularExpressionValidator></td>
                        </tr>
					</table>
					
					</ContentTemplate>
				</asp:UpdatePanel>
					
					<br />
				</div>
				<div class="FormFooter">
					<asp:Button ID="btnSave" runat="server" meta:resourcekey="btnSave" Text="Save" CssClass="Button1" OnClick="btnSave_Click" ValidationGroup="DnsZoneRecord" />
					<asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" Text="Cancel" CssClass="Button1" OnClick="btnCancel_Click" CausesValidation="False" /></td>
				</div>
			</div>
		</asp:Panel>
				    
	<ajaxToolkit:ModalPopupExtender ID="EditRecordModal" runat="server"
		TargetControlID="btnAdd" PopupControlID="EditRecordPanel"
		BackgroundCssClass="modalBackground" DropShadow="false" />

		</ContentTemplate>
	</asp:UpdatePanel>
				    
				</div>
			</div>
		</div>
	</div>
</div>