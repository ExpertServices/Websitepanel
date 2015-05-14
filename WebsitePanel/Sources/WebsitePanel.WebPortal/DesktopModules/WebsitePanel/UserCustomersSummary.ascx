<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserCustomersSummary.ascx.cs" Inherits="WebsitePanel.Portal.UserCustomersSummary" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="UserControls/SearchBox.ascx" TagName="SearchBox" TagPrefix="uc1" %>

<%@ Import Namespace="WebsitePanel.Portal" %>
<div class="FormButtonsBar">
	<div class="Left">
		<asp:Button id="btnCreate" onclick="btnCreate_Click" Text="Create Customer" meta:resourcekey="btnCreate"
			runat="server" CssClass="Button1"></asp:Button>
	</div>
	<div class="Right">
		<asp:Panel ID="tblSearch" runat="server" CssClass="NormalBold">
            <uc1:SearchBox ID="searchBox" runat="server" />
		</asp:Panel>
	</div>
</div>
<div class="FormBody">

	<wsp:CollapsiblePanel id="allCustomers" runat="server"
		TargetControlID="AllCustomersPanel" resourcekey="AllCustomersPanel" Text="All Customers">
	</wsp:CollapsiblePanel>
	<asp:Panel ID="AllCustomersPanel" runat="server" CssClass="FormRow">
		<asp:HyperLink ID="lnkAllCustomers" runat="server" Text="All Customers" meta:resourcekey="lnkAllCustomers"></asp:HyperLink>
	</asp:Panel>
	<wsp:CollapsiblePanel id="byStatus" runat="server"
		TargetControlID="ByStatusPanel" resourcekey="ByStatusPanel" Text="By Status">
	</wsp:CollapsiblePanel>
	<asp:Panel ID="ByStatusPanel" runat="server" CssClass="FormRow">
		<asp:Repeater ID="repUserStatuses" runat="server" EnableViewState="false">
			<ItemTemplate>
				<asp:HyperLink ID="lnkBrowseStatus" runat="server" NavigateUrl='<%# GetUserCustomersPageUrl("StatusID", Eval("StatusID").ToString()) %>'>
					<%# PanelFormatter.GetAccountStatusName((int)Eval("StatusID"))%> (<%# Eval("UsersNumber")%>)
				</asp:HyperLink>
			</ItemTemplate>
			<SeparatorTemplate>&nbsp;&nbsp;</SeparatorTemplate>
		</asp:Repeater>
	</asp:Panel>
	<wsp:CollapsiblePanel id="byRole" runat="server"
		TargetControlID="ByRolePanel" resourcekey="ByRolePanel" Text="By Role">
	</wsp:CollapsiblePanel>
	<asp:Panel ID="ByRolePanel" runat="server" CssClass="FormRow">
		<asp:Repeater ID="repUserRoles" runat="server" EnableViewState="false">
			<ItemTemplate>
				<asp:HyperLink ID="lnkBrowseRole" runat="server" NavigateUrl='<%# GetUserCustomersPageUrl("RoleID", Eval("RoleID").ToString()) %>'>
					<%# PanelFormatter.GetUserRoleName((int)Eval("RoleID"))%> (<%# Eval("UsersNumber")%>)
				</asp:HyperLink>
			</ItemTemplate>
			<SeparatorTemplate>&nbsp;&nbsp;</SeparatorTemplate>
		</asp:Repeater>
	</asp:Panel>
</div>
