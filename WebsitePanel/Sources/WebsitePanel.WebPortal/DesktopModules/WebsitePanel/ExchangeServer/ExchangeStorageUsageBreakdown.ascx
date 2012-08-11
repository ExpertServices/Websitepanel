<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeStorageUsageBreakdown.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeStorageUsageBreakdown" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
<div id="ExchangeContainer">
	<div class="Module">
		<div class="Header">
			<wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" />
		</div>
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="storage_usage" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeStorage48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Storage Usage Breakdown"></asp:Localize>
				</div>
				
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
				    <wsp:CollapsiblePanel id="secMailboxesReport" runat="server"
                        TargetControlID="MailboxesReport" meta:resourcekey="secMailboxesReport" Text="Mailboxes">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="MailboxesReport" runat="server" Height="0" style="overflow:hidden;">
				        <asp:GridView ID="gvMailboxes" runat="server" AutoGenerateColumns="False"
					        Width="100%" EmptyDataText="gvMailboxes" CssSelectorClass="NormalGridView">
					        <Columns>
						        <asp:BoundField HeaderText="gvMailboxesEmail" DataField="ItemName" />
						        <asp:BoundField HeaderText="gvMailboxesItems" DataField="TotalItems" />
						        <asp:BoundField HeaderText="gvMailboxesSize" DataField="TotalSizeMB" />
						        <asp:TemplateField HeaderText="gvMailboxesLastLogon">
									<ItemTemplate>&nbsp;<%# Utils.FormatDateTime((DateTime)Eval("LastLogon"))%></ItemTemplate>
						        </asp:TemplateField>
						        <asp:TemplateField HeaderText="gvMailboxesLastLogoff">
									<ItemTemplate>&nbsp;<%# Utils.FormatDateTime((DateTime)Eval("LastLogoff")) %></ItemTemplate>
						        </asp:TemplateField>
					        </Columns>
				        </asp:GridView>
				        <br />
			            <table cellpadding="2">
					        <tr>
					            <td class="FormLabel150"><asp:Localize ID="locTotalMailboxItems" runat="server" meta:resourcekey="locTotalMailboxItems" Text="Total Items:"></asp:Localize></td>
					            <td><asp:Label ID="lblTotalMailboxItems" runat="server" CssClass="NormalBold">177</asp:Label></td>
					        </tr>
					        <tr>
					            <td class="FormLabel150"><asp:Localize ID="locTotalMailboxesSize" runat="server" meta:resourcekey="locTotalMailboxesSize" Text="Total Size (MB):"></asp:Localize></td>
					            <td><asp:Label ID="lblTotalMailboxSize" runat="server" CssClass="NormalBold">100</asp:Label></td>
					        </tr>
				        </table>
				        <br />
				    </asp:Panel>
			        <br />
                </div>
			</div>
		</div>
	</div>
</div>