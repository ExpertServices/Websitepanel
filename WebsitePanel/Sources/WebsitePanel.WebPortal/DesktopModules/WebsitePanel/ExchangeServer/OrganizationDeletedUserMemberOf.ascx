<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationDeletedUserMemberOf.ascx.cs" Inherits="WebsitePanel.Portal.HostedSolution.DeletedUserMemberOf" %>
<%@ Register Src="UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CountrySelector.ascx" TagName="CountrySelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>

<%@ Register Src="../UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<%@ Register Src="UserControls/AccountsList.ascx" TagName="AccountsList" TagPrefix="wsp" %>
<%@ Register Src="UserControls/GroupsList.ascx" TagName="GroupsList" TagPrefix="wsp" %>



<%@ Register src="UserControls/DeletedUserTabs.ascx" tagname="UserTabs" tagprefix="uc1" %>
<%@ Register src="UserControls/MailboxTabs.ascx" tagname="MailboxTabs" tagprefix="uc1" %>

<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>


<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
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
                    <uc1:UserTabs ID="UserTabsId" runat="server" SelectedTab="deleted_user_memberof" />
                    <uc1:MailboxTabs ID="MailboxTabsId" runat="server" SelectedTab="deleted_user_memberof" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<wsp:CollapsiblePanel id="secGroups" runat="server" TargetControlID="GroupsPanel" meta:resourcekey="secGroups" Text="Groups"></wsp:CollapsiblePanel>
                    <asp:Panel ID="GroupsPanel" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="GeneralUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>

                                <wsp:AccountsList id="groups" runat="server"
                                            Disabled="true"
                                            MailboxesEnabled="false" 
                                            EnableMailboxOnly="true" 
										    ContactsEnabled="false"
										    DistributionListsEnabled="true"
                                            SecurityGroupsEnabled="true" />

							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>
				</div>
			</div>
		</div>
	</div>
</div>