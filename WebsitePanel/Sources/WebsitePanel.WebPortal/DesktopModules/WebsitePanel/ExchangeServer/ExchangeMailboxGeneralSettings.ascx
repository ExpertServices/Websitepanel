<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeMailboxGeneralSettings.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeMailboxGeneralSettings" %>
<%@ Register Src="UserControls/CountrySelector.ascx" TagName="CountrySelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxSelector.ascx" TagName="MailboxSelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxTabs.ascx" TagName="MailboxTabs" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxPlanSelector.ascx" TagName="MailboxPlanSelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>

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
					<asp:Image ID="Image1" SkinID="ExchangeMailbox48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit Mailbox"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
				<div class="FormBody">
                    <wsp:MailboxTabs id="tabs" runat="server" SelectedTab="mailbox_settings" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<wsp:CollapsiblePanel id="secGeneral" runat="server" TargetControlID="General" meta:resourcekey="secGeneral" Text="General"></wsp:CollapsiblePanel>
                    <asp:Panel ID="General" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="GeneralUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>
					            <table>
						            <tr>
						                <td></td>
						                <td>
						                    <asp:CheckBox ID="chkHideAddressBook" runat="server" meta:resourcekey="chkHideAddressBook" Text="Hide from Address Book" />
						                </td>
						            </tr>
						            <tr>
						                <td></td>
						                <td>
						                    <asp:CheckBox ID="chkDisable" runat="server" meta:resourcekey="chkDisable" Text="Disable Mailbox" />
						                    <br />
						                    <br />
						                </td>
						            </tr>
					                <tr>
					                    <td class="FormLabel150"><asp:Localize ID="Localize2" runat="server" meta:resourcekey="locMailboxplanName" Text="Mailbox plan: *"></asp:Localize></td>
					                    <td>                                
                                            <wsp:MailboxPlanSelector ID="mailboxPlanSelector" runat="server" />
                                        </td>
					                </tr>
					                <tr>
					                    <td class="FormLabel150"><asp:Localize ID="locDisclaimer" runat="server" meta:resourcekey="locDisclaimer" Text="Disclaimer: "></asp:Localize></td>
					                    <td>                                
                                            <asp:DropDownList ID="ddDisclaimer" runat="server" />
                                        </td>
					                </tr>
                                    <tr>
                                        <td class="FormLabel150"><asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Mailbox Size:"></asp:Localize></td>
					                    <td>                                
                                            <wsp:QuotaViewer ID="mailboxSize" runat="server" QuotaTypeId="2" DisplayGauge="true" /> MB
                                        </td>
					                </tr>

					            </table>
							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>

                    <wsp:CollapsiblePanel id="secArchiving" runat="server" TargetControlID="Archiving" meta:resourcekey="secArchiving" Text="Archiving"></wsp:CollapsiblePanel>
                    <asp:Panel ID="Archiving" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="ArchivingUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>
					            <table>
                                    <tr>
                                        <td class="FormLabel150"></td>
                                        <td>
                                            <asp:CheckBox ID="chkArchiving" runat="server" meta:resourcekey ="chkArchiving" Text ="Enable Archiving" AutoPostBack="true" OnCheckedChanged="chkArchiving_CheckedChanged"></asp:CheckBox>
                                        </td>
                                    </tr>
					                <tr runat="server" id="mailboxArchivePlan">
					                    <td class="FormLabel150"><asp:Localize ID="locArchiveMailboxplanName" runat="server" meta:resourcekey="locArchiveMailboxplanName" Text="Archive Mailbox plan: "></asp:Localize></td>
					                    <td>                                
                                            <wsp:MailboxPlanSelector ID="mailboxArchivePlanSelector" runat="server" Archiving="true" AddNone="true" />
                                        </td>
					                </tr>
					            </table>
							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>

                    <wsp:CollapsiblePanel id="secLitigationHoldSettings" runat="server" TargetControlID="LitigationHoldSettings" meta:resourcekey="secLitigationHoldSettings" Text="Litigation Hold"></wsp:CollapsiblePanel>
                    <asp:Panel ID="LitigationHoldSettings" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="LitigationHoldUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>
					            <table>
<!--
						            <tr>
						                <td></td>
						                <td>
						                    <asp:CheckBox ID="chkEnableLitigationHold" runat="server" meta:resourcekey="chkEnableLitigationHold" Text="Enable Litigation Hold" />
						                    <br />
						                    <br />
						                </td>
						            </tr>
-->
                                    <tr>
                                        <td class="FormLabel150"><asp:Localize ID="locLitigationHoldSpace" runat="server" meta:resourcekey="locLitigationHoldSpace" Text="Litigation Hold Space:"></asp:Localize></td>
					                    <td>                                
                                            <wsp:QuotaViewer ID="litigationHoldSpace" runat="server" QuotaTypeId="2" DisplayGauge="true" /> MB
                                        </td>
					                </tr>
					            </table>
							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>

					<wsp:CollapsiblePanel id="secCalendarSettings" runat="server" TargetControlID="CalendarSettings" meta:resourcekey="secCalendarSettings" Text="General"></wsp:CollapsiblePanel>
                    <asp:Panel ID="CalendarSettings" runat="server" Height="0" style="overflow:hidden;">
						<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>
					            <table>
					            </table>
							</ContentTemplate>
						</asp:UpdatePanel>
					</asp:Panel>
					
					<table style="width:100%;margin-top:10px;">
					    <tr>
					        <td align="center">
					            <asp:CheckBox ID="chkPmmAllowed" Visible="false" runat="server" meta:resourcekey="chkPmmAllowed" AutoPostBack="true"
					                Text="Allow these settings to be managed from Personal Mailbox Manager" OnCheckedChanged="chkPmmAllowed_CheckedChanged" />
					        </td>
					    </tr>
					</table>

                    <wsp:CollapsiblePanel id="secAdvancedInfo" runat="server" TargetControlID="AdvancedInfo" meta:resourcekey="secAdvancedInfo" Text="Advanced Information" IsCollapsed="true"></wsp:CollapsiblePanel>
                    <asp:Panel ID="AdvancedInfo" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
						    <td class="FormLabel150"> <asp:Localize ID="locExchangeGuid" runat="server" meta:resourcekey="locExchangeGuid" Text="Exchange Guid:"></asp:Localize></td>
						    <td><asp:Label runat="server" ID="lblExchangeGuid" /></td>
						</tr>					   
					    </table>
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