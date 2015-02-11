<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationUsers.ascx.cs" Inherits="WebsitePanel.Portal.HostedSolution.OrganizationUsers" %>

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
					<asp:Image ID="Image1" SkinID="OrganizationUser48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Users"></asp:Localize>
				</div>

				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnCreateUser" runat="server" meta:resourcekey="btnCreateUser"
                            Text="Create New User" CssClass="Button1" OnClick="btnCreateUser_Click" />
                        </div>
                        <div class="FormButtonsBarCleanMiddle">
                            <table>
                                <tr>
                                    <td>
                                        <wsp:UserActions ID="userActions" runat="server" OnExecutingUserAction="userActions_OnExecutingUserAction" />
                                    </td>
                                    <td class="FormButtonsBarCleanSeparator"></td>
                                    <td>
                                        <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
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
                    <br />
                    <asp:Panel ID="UsersPanel" runat="server">
						<asp:UpdatePanel ID="UsersUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
							<ContentTemplate>
				                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					                Width="100%" EmptyDataText="gvUsers" CssSelectorClass="NormalGridView" DataKeyNames="AccountId,AccountType"
					                OnRowCommand="gvUsers_RowCommand" AllowPaging="True" AllowSorting="True"
					                DataSourceID="odsAccountsPaged" PageSize="20">
					                <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="selectAll" Runat="server" onclick="javascript:SelectAllCheckboxes(this);" CssClass="HeaderCheckbox"></asp:CheckBox>
                                            </HeaderTemplate>
			                                <ItemTemplate>							        
				                                <asp:CheckBox runat="server" ID="chkSelectedUsersIds" CssClass="GridCheckbox"></asp:CheckBox>
			                                </ItemTemplate>
		                                </asp:TemplateField>	
						                <asp:TemplateField>
							                <ItemTemplate>							        
								                <asp:Image ID="img2" runat="server" Width="16px" Height="16px" ImageUrl='<%# GetStateImage((bool)Eval("Locked"),(bool)Eval("Disabled")) %>' ImageAlign="AbsMiddle" />
							                </ItemTemplate>
						                </asp:TemplateField>
						                <asp:TemplateField HeaderText="gvUsersDisplayName" SortExpression="DisplayName">
							                <ItemStyle Width="25%"></ItemStyle>
							                <ItemTemplate>							        
								                <asp:Image ID="img1" runat="server" ImageUrl='<%# GetAccountImage((int)Eval("AccountType"),(bool)Eval("IsVIP")) %>' ImageAlign="AbsMiddle"/>
								                <asp:hyperlink id="lnk1" runat="server"
									                NavigateUrl='<%# GetUserEditUrl(Eval("AccountId").ToString()) %>'>
									                <%# Eval("DisplayName") %>
								                </asp:hyperlink>
							                </ItemTemplate>
						                </asp:TemplateField>
                                        <asp:BoundField HeaderText="gvUsersLogin" DataField="UserPrincipalName" SortExpression="UserPrincipalName" ItemStyle-Width="25%" />
                                        <asp:TemplateField HeaderText="gvServiceLevel">
                                            <ItemStyle Width="25%"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Label id="lbServLevel" runat="server" ToolTip = '<%# GetServiceLevel((int)Eval("LevelId")).LevelDescription%>'>
                                                    <%# GetServiceLevel((int)Eval("LevelId")).LevelName%>
                                                </asp:Label>
							                </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="gvUsersEmail" DataField="PrimaryEmailAddress" SortExpression="PrimaryEmailAddress" ItemStyle-Width="25%" />                            
                                        <asp:BoundField HeaderText="gvSubscriberNumber" DataField="SubscriberNumber" ItemStyle-Width="20%" />						    
						                <asp:TemplateField ItemStyle-Wrap="False">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="Image2" runat="server" Width="16px" Height="16px" ToolTip="Mail" ImageUrl='<%# GetMailImage((int)Eval("AccountType")) %>' CommandName="OpenMailProperties" CommandArgument='<%# Eval("AccountId") %>' Enabled=<%# EnableMailImageButton((int)Eval("AccountType")) %>/>
                                                <asp:ImageButton ID="Image3" runat="server" Width="16px" Height="16px" ToolTip="UC" ImageUrl='<%# GetOCSImage((bool)Eval("IsOCSUser"),(bool)Eval("IsLyncUser")) %>' CommandName="OpenUCProperties" CommandArgument='<%# GetOCSArgument((int)Eval("AccountId"),(bool)Eval("IsOCSUser"),(bool)Eval("IsLyncUser")) %>' Enabled=<%# EnableOCSImageButton((bool)Eval("IsOCSUser"),(bool)Eval("IsLyncUser")) %>/>
                                                <asp:ImageButton ID="Image4" runat="server" Width="16px" Height="16px" ToolTip="BlackBerry" ImageUrl='<%# GetBlackBerryImage((bool)Eval("IsBlackBerryUser")) %>' CommandName="OpenBlackBerryProperties" CommandArgument='<%# Eval("AccountId") %>' Enabled=<%# EnableBlackBerryImageButton((bool)Eval("IsBlackBerryUser")) %>/>
                                                <asp:Image ID="Image5" runat="server" Width="16px" Height="16px" ToolTip="CRM" ImageUrl='<%# GetCRMImage((Guid)Eval("CrmUserId")) %>'  />
                                            </ItemTemplate>
						                </asp:TemplateField>
						                <asp:TemplateField>
							                <ItemTemplate>
								                <asp:ImageButton ID="cmdDelete" runat="server" Text="Delete" SkinID="ExchangeDelete" CommandName="DeleteItem"
                                                    CommandArgument='<%# Container.DataItemIndex %>' meta:resourcekey="cmdDelete"></asp:ImageButton>
							                </ItemTemplate>
                                        </asp:TemplateField>
					                </Columns>
				                </asp:GridView>
					            <asp:ObjectDataSource ID="odsAccountsPaged" runat="server" EnablePaging="True"
							            SelectCountMethod="GetOrganizationUsersPagedCount"
							            SelectMethod="GetOrganizationUsersPaged"
							            SortParameterName="sortColumn"
							            TypeName="WebsitePanel.Portal.OrganizationsHelper"
							            OnSelected="odsAccountsPaged_Selected">
						            <SelectParameters>
							            <asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />							
							            <asp:ControlParameter Name="filterColumn" ControlID="ddlSearchColumn" PropertyName="SelectedValue" />
							            <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
						            </SelectParameters>
					            </asp:ObjectDataSource>
                                <asp:Panel ID="DeleteUserPanel" runat="server" CssClass="Popup" style="display:none">
	                            <table class="Popup-Header" cellpadding="0" cellspacing="0">
		                            <tr>
			                            <td class="Popup-HeaderLeft"></td>
			                            <td class="Popup-HeaderTitle">
				                            <asp:Localize ID="headerDeleteUser" runat="server" meta:resourcekey="headerDeleteUser"></asp:Localize>
			                            </td>
			                            <td class="Popup-HeaderRight"></td>
		                            </tr>
	                            </table>
	                            <div class="Popup-Content">
		                            <div class="Popup-Body">
			                            <br />
                                        <asp:UpdatePanel ID="DeleteUserUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                            <ContentTemplate>
                                                <asp:HiddenField ID="hdAccountId" runat="server" Value="0" />
                                                <asp:Literal ID="litDeleteUser" runat="server" meta:resourcekey="litDeleteUser"></asp:Literal>
                                                <br />
                                                <asp:CheckBox ID="chkEnableForceArchiveMailbox" runat="server" meta:resourcekey="chkEnableForceArchiveMailbox" Visible="false" Checked="false" />
	                                        </ContentTemplate>
                                        </asp:UpdatePanel>
			                            <br />
		                            </div>
		                            <div class="FormFooter">
			                            <asp:Button ID="btnDeleteUser" runat="server" CssClass="Button1" meta:resourcekey="btnDelete" Text="Delete" OnClientClick="return ShowProgressDialog('Deleting user...');" OnClick="btnDelete_Click" />
			                            <asp:Button ID="btnCancelDelete" runat="server" CssClass="Button1" meta:resourcekey="btnCancel" Text="Cancel" CausesValidation="false" />
		                            </div>
	                            </div>
                            </asp:Panel>
                            <asp:Button ID="btnDeleteUserFake" runat="server" style="display:none;" />
                            <ajaxToolkit:ModalPopupExtender ID="DeleteUserModal" runat="server" TargetControlID="btnDeleteUserFake" EnableViewState="true"
	                            PopupControlID="DeleteUserPanel" BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelDelete" />
                            </ContentTemplate>
                            <triggers>
			                    <asp:PostBackTrigger ControlID="btnDeleteUser" />
			                </triggers>
					    </asp:UpdatePanel>
				    </asp:Panel>
				    <br />
                    <div>
				        <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Users Created:"></asp:Localize>
				        &nbsp;&nbsp;&nbsp;
				        <wsp:QuotaViewer ID="usersQuota" runat="server" QuotaTypeId="2" />
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