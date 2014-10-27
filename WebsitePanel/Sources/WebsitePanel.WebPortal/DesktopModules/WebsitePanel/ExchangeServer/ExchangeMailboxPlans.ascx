<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeMailboxPlans.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeMailboxPlans" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/MailboxPlanSelector.ascx" TagName="MailboxPlanSelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainName48" runat="server" />
					<asp:Localize ID="locTitle" runat="server"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <asp:Button ID="btnAddMailboxPlan" runat="server" meta:resourcekey="btnAddMailboxPlan"
                            Text="Add New" CssClass="Button1" OnClick="btnAddMailboxPlan_Click" />
                    </div>

				    <asp:GridView ID="gvMailboxPlans" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvMailboxPlans" CssSelectorClass="NormalGridView" OnRowCommand="gvMailboxPlan_RowCommand">
					    <Columns>
						    <asp:TemplateField>
							    <ItemTemplate>							        
								    <asp:Image ID="img2" runat="server" Width="16px" Height="16px" ImageUrl='<%# GetPlanType((int)Eval("MailboxPlanType")) %>' ImageAlign="AbsMiddle" />
							    </ItemTemplate>
						    </asp:TemplateField>

						    <asp:TemplateField HeaderText="gvMailboxPlan">
							    <ItemStyle Width="70%"></ItemStyle>
							    <ItemTemplate>
								    <asp:hyperlink id="lnkDisplayMailboxPlan" runat="server" EnableViewState="false"
									    NavigateUrl='<%# GetMailboxPlanDisplayUrl(Eval("MailboxPlanId").ToString()) %>'>
									    <%# Eval("MailboxPlan")%> 
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvMailboxPlanDefault">
							    <ItemTemplate>
							        <div style="text-align:center">
								        <input type="radio" name="DefaultMailboxPlan" value='<%# Eval("MailboxPlanId") %>' <%# IsChecked((bool)Eval("IsDefault")) %> />
								    </div>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField >
							    <ItemTemplate>
									&nbsp;<asp:ImageButton ID="imgDelMailboxPlan" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("MailboxPlanId") %>' 
									    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected?')" ></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
				    <br />
				    <div style="text-align: center">
				        <asp:Button ID="btnSetDefaultMailboxPlan" runat="server" meta:resourcekey="btnSetDefaultMailboxPlan"
                            Text="Set Default Mailboxplan" CssClass="Button1" OnClick="btnSetDefaultMailboxPlan_Click" />
                    </div>

					<wsp:CollapsiblePanel id="secMainTools" runat="server" IsCollapsed="true" TargetControlID="ToolsPanel" meta:resourcekey="secMainTools" Text="Mailbox plan maintenance">
					</wsp:CollapsiblePanel>
					<asp:Panel ID="ToolsPanel" runat="server" Height="0" Style="overflow: hidden;">
						<table id="tblMaintenance" runat="server" cellpadding="10">
					        <tr>
					            <td class="FormLabel150"><asp:Localize ID="lblSourcePlan" runat="server" meta:resourcekey="locSourcePlan" Text="Replace"></asp:Localize></td>
					            <td>                                
                                    <wsp:MailboxPlanSelector ID="mailboxPlanSelectorSource" runat="server" AddNone="true"/>
                                </td>
					        </tr>
					        <tr>
					            <td class="FormLabel150"><asp:Localize ID="lblTargetPlan" runat="server" meta:resourcekey="locTargetPlan" Text="With"></asp:Localize></td>
					            <td>                                
                                    <wsp:MailboxPlanSelector ID="mailboxPlanSelectorTarget" runat="server" AddNone="false"/>
                                </td>
					        </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtStatus" runat="server" CssClass="TextBox400" MaxLength="128" ReadOnly="true"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                            </tr>
						</table>
				        <div class="FormFooterClean">
					        <asp:Button id="btnSave" runat="server" Text="Stamp mailboxes" CssClass="Button1"
							    meta:resourcekey="btnSave" OnClick="btnSave_Click" OnClientClick = "ShowProgressDialog('Stamping mailboxes, this might take a while ...');"> </asp:Button>
				        </div>


					</asp:Panel>

		    
				</div>
			</div>
		</div>
	</div>
</div>