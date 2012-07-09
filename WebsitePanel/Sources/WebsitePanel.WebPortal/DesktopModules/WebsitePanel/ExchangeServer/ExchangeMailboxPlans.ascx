<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeMailboxPlans.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeMailboxPlans" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Header">
			<wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" />
		</div>
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="domains" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainName48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Domain Names"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <asp:Button ID="btnAddMailboxPlan" runat="server" meta:resourcekey="btnAddMailboxPlan"
                            Text="Add New Mailboxplan" CssClass="Button1" OnClick="btnAddMailboxPlan_Click" />
                    </div>

				    <asp:GridView ID="gvMailboxPlans" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvMailboxPlans" CssSelectorClass="NormalGridView" OnRowCommand="gvMailboxPlan_RowCommand">
					    <Columns>
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
						    <asp:TemplateField>
							    <ItemTemplate>
									&nbsp;<asp:ImageButton ID="imgDelMailboxPlan" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("MailboxPlanId") %>' 
									    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected mailbox plan?')"></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
				    <br />
				    <div style="text-align: center">
				        <asp:Button ID="btnSetDefaultMailboxPlan" runat="server" meta:resourcekey="btnSetDefaultMailboxPlan"
                            Text="Set Default Mailboxplan" CssClass="Button1" OnClick="btnSetDefaultMailboxPlan_Click" />
                    </div>
				    
				</div>
			</div>
			<div class="Right">
				<asp:Localize ID="FormComments" runat="server" meta:resourcekey="HSFormComments"></asp:Localize>
			</div>
		</div>
	</div>
</div>