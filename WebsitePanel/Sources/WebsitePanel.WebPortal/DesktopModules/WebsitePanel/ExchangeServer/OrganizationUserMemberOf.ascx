<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationUserMemberOf.ascx.cs" Inherits="WebsitePanel.Portal.HostedSolution.UserMemberOf" %>
<%@ Register Src="UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CountrySelector.ascx" TagName="CountrySelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>

<%@ Register Src="../UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<%@ Register Src="UserControls/AccountsList.ascx" TagName="AccountsList" TagPrefix="wsp" %>
<%@ Register Src="UserControls/GroupsList.ascx" TagName="GroupsList" TagPrefix="wsp" %>



<%@ Register src="UserControls/UserTabs.ascx" tagname="UserTabs" tagprefix="uc1" %>
<%@ Register src="UserControls/MailboxTabs.ascx" tagname="MailboxTabs" tagprefix="uc1" %>



<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Header">
			<wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" />
		</div>
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="mailboxes" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="OrganizationUser48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit User"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>

				<div class="FormBody">
                    <uc1:UserTabs ID="UserTabsId" runat="server" SelectedTab="user_memberof" />
                    <uc1:MailboxTabs ID="MailboxTabsId" runat="server" SelectedTab="user_memberof" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<wsp:CollapsiblePanel id="secDistributionLists" runat="server" TargetControlID="DistributionListsPanel" meta:resourcekey="secDistributionLists" Text="Distribution Lists"></wsp:CollapsiblePanel>
                    <asp:Panel ID="DistributionListsPanel" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="DLGeneralUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>

                                <wsp:AccountsList id="distrlists" runat="server"
                                            MailboxesEnabled="false" 
                                            EnableMailboxOnly="true" 
										    ContactsEnabled="false"
										    DistributionListsEnabled="true"  />

							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>
					
                    <wsp:CollapsiblePanel id="secSecurityGroups" runat="server" TargetControlID="SecurityGroupsPanel" meta:resourcekey="secSecurityGroups" Text="Groups"></wsp:CollapsiblePanel>
                    <asp:Panel ID="SecurityGroupsPanel" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="SCGeneralUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>

                                <wsp:GroupsList id="securegroups" runat="server" />

							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>
					
				    <div class="FormFooterClean">
					    <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1"
							meta:resourcekey="btnSave" ValidationGroup="EditMailbox" OnClick="btnSave_Click"></asp:Button>
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="EditMailbox" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>