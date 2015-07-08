<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSUserSessions.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSUserSessions" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionTabs.ascx" TagName="CollectionTabs" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgEditRDSCollection" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit RDS Collection"></asp:Localize>
                    -
					<asp:Literal ID="litCollectionName" runat="server" Text="" />
				</div>
				<div class="FormBody">
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_user_sessions" />
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />  
                    <asp:UpdatePanel ID="RDAppsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            <div class="FormButtonsBarCleanRight">
                                <div class="FormButtonsBarClean">
                                    <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="Button1" OnClick="btnRefresh_Click" OnClientClick="ShowProgressDialog('Loading'); return true;" meta:resourcekey="btnRefresh"  />
                                    <asp:Button ID="btnRecentMessages" runat="server" Text="Recent Messages" CssClass="Button1" OnClick="btnRecentMessages_Click" OnClientClick="ShowProgressDialog('Loading'); return true;" meta:resourcekey="btnRecentMessages"  />
                                    <asp:Button ID="btnSendMessage" runat="server" Text="Send Message" CssClass="Button1" OnClick="btnSendMessage_Click" meta:resourcekey="cmdSendMessage"  />
                                </div>
                            </div>                 
                            <wsp:CollapsiblePanel id="secRdsUserSessions" runat="server"
                                TargetControlID="panelRdsUserSessions" meta:resourcekey="secRdsUserSessions" Text="">
                            </wsp:CollapsiblePanel>		
                            <asp:Panel runat="server" ID="panelRdsUserSessions">                                                
                                <div style="padding: 10px;">                            
                                    <asp:GridView ID="gvRDSUserSessions" runat="server" AutoGenerateColumns="False" EnableViewState="true"
                                        Width="100%" EmptyDataText="gvRDSUserSessions" CssSelectorClass="NormalGridView"
                                        OnRowCommand="gvRDSCollections_RowCommand" AllowPaging="True" AllowSorting="True">
                                        <Columns>                                            
                                            <asp:TemplateField meta:resourcekey="gvUserName" HeaderText="gvUserName">
                                                <ItemStyle Width="20%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Image ID="vipImage" runat="server" ImageUrl='<%# GetAccountImage(Convert.ToBoolean(Eval("IsVip"))) %>' ImageAlign="AbsMiddle"/>
                                                    <asp:Literal ID="litUserName" runat="server" Text='<%# Eval("UserName") %>'/>
                                                    <asp:HiddenField ID="hfUnifiedSessionId" runat="server"  Value='<%# Eval("UnifiedSessionId") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField meta:resourcekey="gvHostServer" HeaderText="gvHostServer">
                                                <ItemStyle Width="20%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Literal ID="litHostServer" runat="server" Text='<%# Eval("HostServer") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField meta:resourcekey="gvSessionState" HeaderText="gvSessionState">
                                                <ItemStyle Width="20%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Literal ID="litSessionState" runat="server" Text='<%# Eval("SessionState") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>                                            
                                                    <asp:LinkButton ID="lnkViewSession" runat="server" Text="View" CommandName="View" CommandArgument='<%# Eval("UnifiedSessionId") + ";" + Eval("HostServer") %>'
                                                        meta:resourcekey="cmdViewSession" OnClientClick="ShowProgressDialog('Loading'); return true;"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>                                            
                                                    <asp:LinkButton ID="lnkControlSession" runat="server" Text="Control" CommandName="Control" CommandArgument='<%# Eval("UnifiedSessionId") + ";" + Eval("HostServer") %>'
                                                        meta:resourcekey="cmdControlSession" OnClientClick="ShowProgressDialog('Loading'); return true;"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>                                            
                                                    <asp:LinkButton ID="lnkLogOff" runat="server" Text="Log Off" CommandName="LogOff" CommandArgument='<%# Eval("UnifiedSessionId") + ";" + Eval("HostServer") %>'
                                                        meta:resourcekey="cmdLogOff" OnClientClick="return confirm('Are you sure you want to log off selected user?')"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>                                            
                                                    <asp:LinkButton ID="lnkSendMessage" runat="server" Text="Send Message" CommandName="SendMessage" CommandArgument='<%# Eval("HostServer") + ":" + Eval("UserName") + ":" + Eval("UnifiedSessionId") %>'
                                                        meta:resourcekey="cmdSendMessage"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>             
                            </asp:Panel>
                            <div class="FormFooterClean">
                                <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                                    OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
                            </div>   

                            <asp:Panel ID="MessagesHistoryPanel" runat="server" CssClass="Popup" style="display:none">
                                <table class="Popup-Header" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="Popup-HeaderLeft"></td>
                                        <td class="Popup-HeaderTitle">
                                            <asp:Localize ID="headerMessagesHistory" runat="server" meta:resourcekey="headerMessagesHistory"></asp:Localize>
                                        </td>
                                        <td class="Popup-HeaderRight"></td>
                                    </tr>
                                </table>
                                <div class="Popup-Content">
                                    <div class="Popup-Body">
                                        <br />
                                        <asp:UpdatePanel ID="MessagesHistoryUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                            <ContentTemplate>
                                                <div class="Popup-Scroll">
                                                    <asp:GridView ID="gvMessagesHistory" runat="server" meta:resourcekey="gvMessagesHistory" AutoGenerateColumns="False"
                                                        Width="100%" CssSelectorClass="NormalGridView" DataKeyNames="Id">
                                                        <Columns>
                                                            <asp:TemplateField meta:resourcekey="gvMessageText">
                                                                <ItemStyle Width="70%"/>
                                                                <ItemTemplate>
                                                                    <asp:Literal ID="litMessage" runat="server" Text='<%# Eval("MessageText") %>'></asp:Literal>
                                                                </ItemTemplate>
                                                            </asp:TemplateField> 
                                                            <asp:TemplateField meta:resourcekey="gvUser" HeaderText="gvUser">
                                                                <ItemStyle Width="15%" Wrap="false"/>
                                                                <ItemTemplate>
                                                                    <asp:Literal ID="litUserName" runat="server" Text='<%# Eval("UserName") %>'/>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>                                            
                                                                    <asp:Literal ID="litDate" runat="server" Text='<%# Convert.ToDateTime(Eval("Date")).ToShortDateString() %>'/>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>                           
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <br />
                                    </div>
                                    <div class="FormFooter">                                        
                                        <asp:Button ID="btnCancelMessagesHistory" runat="server" CssClass="Button1" meta:resourcekey="btnCancel" Text="Cancel" CausesValidation="false" />
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="EnterMessagePanel" runat="server" CssClass="Popup" style="display:none">
                                <table class="Popup-Header" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="Popup-HeaderLeft"></td>
                                        <td class="Popup-HeaderTitle">
                                            <asp:Localize ID="headerEnterMessage" runat="server" meta:resourcekey="headerEnterMessage"></asp:Localize>
                                        </td>
                                        <td class="Popup-HeaderRight"></td>
                                    </tr>
                                </table>
                                <div class="Popup-Content">
                                    <div class="Popup-Body" style="width:100%;">
                                        <br />
                                        <asp:TextBox id="txtMessage" TextMode="multiline" Columns="70" Rows="15" runat="server" />
                                        <br />
                                    </div>
                                    <div class="FormFooter">                                        
                                        <asp:Button ID="btnAddMessage" runat="server" CssClass="Button1" meta:resourcekey="btnAdd" Text="Add" CausesValidation="false" OnClick="btnAddMessage_Click" />
                                        <asp:Button ID="btnCancelEnterMessage" runat="server" CssClass="Button1" meta:resourcekey="btnCancel" Text="Cancel" CausesValidation="false" />
                                    </div>
                                </div>
                            </asp:Panel>


                            <asp:Button ID="btnEnterMessageFake" runat="server" style="display:none;" />
                            <ajaxToolkit:ModalPopupExtender ID="EnterMessageModal" runat="server" TargetControlID="btnEnterMessageFake" PopupControlID="EnterMessagePanel" 
                                BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelEnterMessage"/>
                            <asp:Button ID="btnMessagesHistoryFake" runat="server" style="display:none;" />
                            <ajaxToolkit:ModalPopupExtender ID="MessagesHistoryModal" runat="server" TargetControlID="btnMessagesHistoryFake" PopupControlID="MessagesHistoryPanel" 
                                BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelMessagesHistory"/>
                        </ContentTemplate>
                    </asp:UpdatePanel>
				</div>
			</div>
		</div>
	</div>
</div>