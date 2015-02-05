<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeMailboxes.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeMailboxes" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/UserActions.ascx" TagName="UserActions" TagPrefix="wsp" %>

<script src="JavaScript/jquery-1.4.4.min.js" type="text/javascript"></script>

<script language="javascript">
    function SelectAllCheckboxes(box) {
        $(".NormalGridView tbody :checkbox").attr("checked", $(box).attr("checked"));
    }
</script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeMailbox48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" Text="Mailboxes"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnCreateMailbox" runat="server" meta:resourcekey="btnCreateMailbox"
                            Text="Create New Mailbox" CssClass="Button1" OnClick="btnCreateMailbox_Click" />
                        </div>
                        <div class="FormButtonsBarCleanMiddle">
                            <table>
                                <tr>
                                    <td>
                                        <wsp:UserActions ID="userActions" runat="server" />
                                    </td>
                                    <td class="FormButtonsBarCleanSeparatorSmall"></td>
                                    <td>
                                        <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                                            <asp:CheckBox ID="chkMailboxes" runat="server" meta:resourcekey="chkMailboxes" Text="Mailboxes" AutoPostBack="true" OnCheckedChanged="chkMailboxes_CheckedChanged" />
                                            <asp:CheckBox ID="chkResourceMailboxes" runat="server" meta:resourcekey="chkResourceMailboxes" Text="Resource Mailboxes" AutoPostBack="true" OnCheckedChanged="chkMailboxes_CheckedChanged" />
                                            <asp:CheckBox ID="chkSharedMailboxes" runat="server" meta:resourcekey="chkSharedMailboxes" Text="Shared Mailboxes" AutoPostBack="true" OnCheckedChanged="chkMailboxes_CheckedChanged" />
                                            <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                                                <asp:ListItem>10</asp:ListItem>
                                                <asp:ListItem Selected="True">20</asp:ListItem>
                                                <asp:ListItem>50</asp:ListItem>

                                                <asp:ListItem>100</asp:ListItem>

                                            </asp:DropDownList>

                                            <asp:DropDownList ID="ddlSearchColumn" runat="server" CssClass="NormalTextBox">
                                                <asp:ListItem Value="DisplayName" meta:resourcekey="ddlSearchColumnDisplayName">DisplayName</asp:ListItem>
                                                <asp:ListItem Value="PrimaryEmailAddress" meta:resourcekey="ddlSearchColumnEmail">Email</asp:ListItem>
                                                <asp:ListItem Value="AccountName" meta:resourcekey="ddlSearchColumnAccountName">AccountName</asp:ListItem>
                                                <asp:ListItem Value="SubscriberNumber" meta:resourcekey="ddlSearchColumnSubscriberNumber">Account Number</asp:ListItem>
                                                <asp:ListItem Value="UserPrincipalName" meta:resourcekey="ddlSearchColumnUserPrincipalName">Login</asp:ListItem>
                                            </asp:DropDownList><asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"></asp:TextBox><asp:ImageButton ID="cmdSearch" runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton"
                                                CausesValidation="false" />
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

				    <asp:GridView ID="gvMailboxes" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvMailboxes" CssSelectorClass="NormalGridView" DataKeyNames="AccountId"
					    OnRowCommand="gvMailboxes_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsAccountsPaged" PageSize="20">
					    <Columns>
                            <asp:TemplateField>
							    <ItemTemplate>							        
								    <asp:Image ID="img2" runat="server" Width="16px" Height="16px" ImageUrl='<%# GetStateImage((bool)Eval("Locked"),(bool)Eval("Disabled")) %>' ImageAlign="AbsMiddle" />
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:CheckBox ID="selectAll" Runat="server" onclick="javascript:SelectAllCheckboxes(this);" CssClass="HeaderCheckbox"></asp:CheckBox>
                                </HeaderTemplate>
			                    <ItemTemplate>							        
				                    <asp:CheckBox runat="server" ID="chkSelectedUsersIds"></asp:CheckBox>
			                    </ItemTemplate>
		                    </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvMailboxesDisplayName" SortExpression="DisplayName">
							    <ItemStyle Width="20%"></ItemStyle>
							    <ItemTemplate>
							        <asp:Image ID="img1" runat="server" ImageUrl='<%# GetAccountImage((int)Eval("AccountType"),(bool)Eval("IsVIP")) %>' ImageAlign="AbsMiddle" />
								    <asp:hyperlink id="lnk1" runat="server"
									    NavigateUrl='<%# GetMailboxEditUrl(Eval("AccountId").ToString()) %>'>
									    <%# Eval("DisplayName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvUsersLogin" SortExpression="UserPrincipalName">
							    <ItemStyle Width="20%"></ItemStyle>
							    <ItemTemplate>							        
								    <asp:hyperlink id="lnk2" runat="server"
									    NavigateUrl='<%# GetOrganizationUserEditUrl(Eval("AccountId").ToString()) %>'>
									    <%# Eval("UserPrincipalName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvServiceLevel">
                                <ItemStyle Width="15%"></ItemStyle>
                                <ItemTemplate>
                                    <asp:Label id="lbServLevel" runat="server" ToolTip = '<%# GetServiceLevel((int)Eval("LevelId")).LevelDescription%>'>
                                        <%# GetServiceLevel((int)Eval("LevelId")).LevelName%>
                                    </asp:Label>
							    </ItemTemplate>
                            </asp:TemplateField>
						    <asp:BoundField HeaderText="gvMailboxesEmail" DataField="PrimaryEmailAddress" SortExpression="PrimaryEmailAddress" ItemStyle-Width="25%" />
                            <asp:BoundField HeaderText="gvSubscriberNumber" DataField="SubscriberNumber" ItemStyle-Width="10%" />
                            <asp:BoundField HeaderText="gvMailboxesMailboxPlan" DataField="MailboxPlan" SortExpression="MailboxPlan" ItemStyle-Width="50%" />
						    <asp:TemplateField>
							    <ItemTemplate>
								    <asp:ImageButton ID="cmdDelete" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("AccountId") %>'
									    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Remove this item?');"></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
					<asp:ObjectDataSource ID="odsAccountsPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetExchangeAccountsPagedCount"
							SelectMethod="GetExchangeAccountsPaged"
							SortParameterName="sortColumn"
							TypeName="WebsitePanel.Portal.ExchangeHelper"
                            OnSelecting="odsAccountsPaged_Selecting"
							OnSelected="odsAccountsPaged_Selected">
						<SelectParameters>
							<asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
							<asp:Parameter Name="accountTypes" DefaultValue="1,5,6,10" />
							<asp:ControlParameter Name="filterColumn" ControlID="ddlSearchColumn" PropertyName="SelectedValue" />
							<asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
                            <asp:Parameter Name="archiving" Type="Boolean" />
						</SelectParameters>
					</asp:ObjectDataSource>
				    <br />
                    <div>
				        <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Mailboxes Created:"></asp:Localize>
				        &nbsp;&nbsp;&nbsp;
				        <wsp:QuotaViewer ID="mailboxesQuota" runat="server" QuotaTypeId="2" />
                    </div>
				    <asp:Repeater ID="dlServiceLevelQuotas" runat="server" EnableViewState="false">
                    
                        <ItemTemplate>
                            <div>
                                <asp:Localize ID="locServiceLevelQuota" runat="server" Text='<%# Eval("QuotaDescription") %>'></asp:Localize>
                                &nbsp;&nbsp;&nbsp;
                                <wsp:QuotaViewer ID="serviceLevelQuota" runat="server"
                                    QuotaTypeId='<%# Eval("QuotaTypeId") %>'
                                    QuotaUsedValue='<%# Eval("QuotaUsedValue") %>'
                                    QuotaValue='<%# Eval("QuotaValue") %>'
                                    QuotaAvailable='<%# Eval("QuotaAvailable")%>'/>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
				    
				</div>
			</div>
		</div>
	</div>
</div>