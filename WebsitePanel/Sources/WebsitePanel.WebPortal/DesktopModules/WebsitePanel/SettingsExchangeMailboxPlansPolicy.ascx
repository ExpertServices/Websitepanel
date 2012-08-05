<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SettingsExchangeMailboxPlansPolicy.ascx.cs" Inherits="WebsitePanel.Portal.SettingsExchangeMailboxPlansPolicy" %>
<%@ Register Src="ExchangeServer/UserControls/SizeBox.ascx" TagName="SizeBox" TagPrefix="wsp" %>
<%@ Register Src="ExchangeServer/UserControls/DaysBox.ascx" TagName="DaysBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

    <wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>
    <wsp:SimpleMessageBox id="messageBox" runat="server" />
	<asp:GridView id="gvMailboxPlans" runat="server"  EnableViewState="true" AutoGenerateColumns="false"
		Width="100%" EmptyDataText="gvMailboxPlans" CssSelectorClass="NormalGridView" OnRowCommand="gvMailboxPlan_RowCommand" >
		<Columns>
            <asp:TemplateField HeaderText="gvMailboxPlanEdit">
                <ItemTemplate>
                    <asp:ImageButton ID="cmdEdit" runat="server" SkinID="EditSmall" CommandName="EditItem" AlternateText="Edit record" CommandArgument='<%# Eval("MailboxPlanId") %>' ></asp:ImageButton>
                </ItemTemplate>
             </asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>							        
					<asp:Image ID="img2" runat="server" Width="16px" Height="16px" ImageUrl='<%# GetPlanType((int)Eval("MailboxPlanType")) %>' ImageAlign="AbsMiddle" />
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="gvMailboxPlan">
				<ItemStyle Width="70%"></ItemStyle>
				<ItemTemplate>
					<asp:Label id="lnkDisplayMailboxPlan" runat="server" EnableViewState="true" ><%# Eval("MailboxPlan")%></asp:Label>
                 </ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					&nbsp;<asp:ImageButton id="imgDelMailboxPlan" runat="server" Text="Delete" SkinID="ExchangeDelete"
						CommandName="DeleteItem" CommandArgument='<%# Eval("MailboxPlanId") %>' 
						meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected mailbox plan?')"></asp:ImageButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<br />
    	<wsp:CollapsiblePanel id="secMailboxPlan" runat="server"
            TargetControlID="MailboxPlan" meta:resourcekey="secMailboxPlan" Text="Mailboxplan">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="MailboxPlan" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td class="FormLabel200" align="right">
									
					</td>
					<td>
						<asp:TextBox ID="txtMailboxPlan" runat="server" CssClass="TextBox200" 
                            ontextchanged="txtMailboxPlan_TextChanged" ></asp:TextBox>
                        <asp:RequiredFieldValidator ID="valRequireMailboxPlan" runat="server" meta:resourcekey="valRequireMailboxPlan" ControlToValidate="txtMailboxPlan"
						ErrorMessage="Enter mailbox plan name" ValidationGroup="CreateMailboxPlan" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>

		<wsp:CollapsiblePanel id="secMailboxFeatures" runat="server"
            TargetControlID="MailboxFeatures" meta:resourcekey="secMailboxFeatures" Text="Mailbox Features">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="MailboxFeatures" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td>
						<asp:CheckBox ID="chkPOP3" runat="server" meta:resourcekey="chkPOP3" Text="POP3"></asp:CheckBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:CheckBox ID="chkIMAP" runat="server" meta:resourcekey="chkIMAP" Text="IMAP"></asp:CheckBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:CheckBox ID="chkOWA" runat="server" meta:resourcekey="chkOWA" Text="OWA/HTTP"></asp:CheckBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:CheckBox ID="chkMAPI" runat="server" meta:resourcekey="chkMAPI" Text="MAPI"></asp:CheckBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:CheckBox ID="chkActiveSync" runat="server" meta:resourcekey="chkActiveSync" Text="ActiveSync"></asp:CheckBox>
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>

		<wsp:CollapsiblePanel id="secMailboxGeneral" runat="server"
            TargetControlID="MailboxGeneral" meta:resourcekey="secMailboxGeneral" Text="Mailbox General">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="MailboxGeneral" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td>
						<asp:CheckBox ID="chkHideFromAddressBook" runat="server" meta:resourcekey="chkHideFromAddressBook" Text="Hide from Addressbook"></asp:CheckBox>
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>
				
		<wsp:CollapsiblePanel id="secStorageQuotas" runat="server"
            TargetControlID="StorageQuotas" meta:resourcekey="secStorageQuotas" Text="Storage Quotas">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="StorageQuotas" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locMailboxSize" runat="server" meta:resourcekey="locMailboxSize" Text="Mailbox size:"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="mailboxSize" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB="false"  DisplayUnitsMB="true" DisplayUnitsPct="false" RequireValidatorEnabled="false"/>
					</td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locMaxRecipients" runat="server" meta:resourcekey="locMaxRecipients" Text="Maximum Recipients:"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="maxRecipients" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB="false" DisplayUnitsMB="false" DisplayUnitsPct="false" RequireValidatorEnabled="false"/>
					</td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locMaxSendMessageSizeKB" runat="server" meta:resourcekey="locMaxSendMessageSizeKB" Text="Maximum Send Message Size (Kb):"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="maxSendMessageSizeKB" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB="true" DisplayUnitsMB="false" DisplayUnitsPct="false" RequireValidatorEnabled="false"/>
					</td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locMaxReceiveMessageSizeKB" runat="server" meta:resourcekey="locMaxReceiveMessageSizeKB" Text="Maximum Receive Message Size (Kb):"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="maxReceiveMessageSizeKB" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB="true"  DisplayUnitsMB="false" DisplayUnitsPct="false" RequireValidatorEnabled="false"/>
					</td>
				</tr>

				<tr>
					<td class="FormLabel200" colspan="2"><asp:Localize ID="locWhenSizeExceeds" runat="server" meta:resourcekey="locWhenSizeExceeds" Text="When the mailbox size exceeds the indicated amount:"></asp:Localize></td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locIssueWarning" runat="server" meta:resourcekey="locIssueWarning" Text="Issue warning at:"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="sizeIssueWarning" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB="false" DisplayUnitsMB="false" DisplayUnitsPct="true" RequireValidatorEnabled="true"/>
					</td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locProhibitSend" runat="server" meta:resourcekey="locProhibitSend" Text="Prohibit send at:"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="sizeProhibitSend" runat="server" ValidationGroup="CreateMailboxPlan"  DisplayUnitsKB="false" DisplayUnitsMB="false" DisplayUnitsPct="true" RequireValidatorEnabled="true"/>
					</td>
				</tr>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locProhibitSendReceive" runat="server" meta:resourcekey="locProhibitSendReceive" Text="Prohibit send and receive at:"></asp:Localize></td>
					<td>
						<wsp:SizeBox id="sizeProhibitSendReceive" runat="server" ValidationGroup="CreateMailboxPlan" DisplayUnitsKB=false DisplayUnitsMB="false" DisplayUnitsPct="true" RequireValidatorEnabled="true"/>
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>
					
					
		<wsp:CollapsiblePanel id="secDeleteRetention" runat="server" TargetControlID="DeleteRetention" meta:resourcekey="secDeleteRetention" Text="Delete Item Retention">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="DeleteRetention" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td class="FormLabel200" align="right"><asp:Localize ID="locKeepDeletedItems" runat="server" meta:resourcekey="locKeepDeletedItems" Text="Keep deleted items for:"></asp:Localize></td>
					<td>
						<wsp:DaysBox id="daysKeepDeletedItems" runat="server" ValidationGroup="CreateMailboxPlan" RequireValidatorEnabled="true"/>
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>

    <table>
        <tr>
            <td>
                <div class="FormButtonsBarClean">
                    <asp:Button ID="btnAddMailboxPlan" runat="server" meta:resourcekey="btnAddMailboxPlan"
                        Text="Add New Mailboxplan" CssClass="Button1" OnClick="btnAddMailboxPlan_Click" />
                </div>
            </td>
            <td>
                <div class="FormButtonsBarClean">
                        <asp:Button ID="btnUpdateMailboxPlan" runat="server" meta:resourcekey="btnUpdateMailboxPlan"
                            Text="Update Mailboxplan" CssClass="Button1" OnClick="btnUpdateMailboxPlan_Click" />
            </td>
        </tr>
    </table>

    <br />

    <wsp:CollapsiblePanel id="secTools" runat="server" TargetControlID="Tools" meta:resourcekey="secTools" Text="Tools">
        </wsp:CollapsiblePanel>
        <asp:Panel ID="Tools" runat="server" Height="0" style="overflow:hidden;">
			<table>
				<tr>
					<td>
                        <asp:Button ID="btnStamp" runat="server" meta:resourcekey="btnStamp"
                        Text="Restamp all mailboxes" CssClass="Button1" OnClick="btnStampClick" OnClientClick="if (confirm('Restamp mailboxes with these plans. \nAre you sure you want to restamp the mailbox plans ?')) ShowProgressDialog('Stamping mailboxes, this might take a while ...'); else return false;"/>
					</td>
                    <td>
                        <asp:TextBox ID="txtStatus" runat="server" CssClass="TextBox400" MaxLength="128" ReadOnly="true"></asp:TextBox>
                    </td>
				</tr>
				<tr>
					<td>
                        <asp:Button ID="btnMatchMailboxPlanToUser" runat="server" meta:resourcekey="btnMatchMailboxPlanToUser"
                            Text="Match Plan to User" CssClass="Button1" 
                            OnClientClick="if (confirm('Mail enabled users with no mailbox plan assigned will get a matching mailbox plan applied.\nMatching takes place on mailbox size and the MAPI properties.\n\nAre you sure you want to continue with this ?')) ShowProgressDialog('Applying mailbox plans, this might take a while ...'); else return false;" 
                            onclick="btnMatchMailboxPlanToUser_Click" />
					</td>
				</tr>
			</table>
			<br />
		</asp:Panel>

    