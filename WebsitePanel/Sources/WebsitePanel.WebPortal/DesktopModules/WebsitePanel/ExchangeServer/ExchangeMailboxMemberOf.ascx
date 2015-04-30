<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeMailboxMemberOf.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeMailboxMemberOf" %>
<%@ Register Src="UserControls/CountrySelector.ascx" TagName="CountrySelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/AccountsList.ascx" TagName="AccountsList" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxTabs.ascx" TagName="MailboxTabs" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxPlanSelector.ascx" TagName="MailboxPlanSelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeMailbox48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Mailbox"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
				<div class="FormBody">
                    <wsp:MailboxTabs id="tabs" runat="server" SelectedTab="mailbox_memberof" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<wsp:CollapsiblePanel id="secGroups" runat="server" TargetControlID="GroupsPanel" meta:resourcekey="secGroups" Text="Groups"></wsp:CollapsiblePanel>
                    <asp:Panel ID="GroupsPanel" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="GeneralUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>

                                <wsp:AccountsList id="groups" runat="server"
                                            MailboxesEnabled="false" 
                                            EnableMailboxOnly="true" 
										    ContactsEnabled="false"
										    DistributionListsEnabled="true"
                                            SecurityGroupsEnabled="true"  />

							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>
					
				    <div class="FormFooterClean">
                        <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="EditMailbox" 
                            OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="EditMailbox" />
				    </div>

				</div>
			</div>
		</div>
	</div>
</div>