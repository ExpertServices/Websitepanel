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
                                                <ItemStyle Width="30%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Literal ID="litUserName" runat="server" Text='<%# Eval("UserName") %>'/>
                                                    <asp:HiddenField ID="hfUnifiedSessionId" runat="server"  Value='<%# Eval("UnifiedSessionId") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField meta:resourcekey="gvHostServer" HeaderText="gvHostServer">
                                                <ItemStyle Width="30%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Literal ID="litHostServer" runat="server" Text='<%# Eval("HostServer") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField meta:resourcekey="gvSessionState" HeaderText="gvSessionState">
                                                <ItemStyle Width="30%" Wrap="false"/>
                                                <ItemTemplate>
                                                    <asp:Literal ID="litSessionState" runat="server" Text='<%# Eval("SessionState") %>'/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>                                            
                                                    <asp:LinkButton ID="lnkLogOff" runat="server" Text="Log Off" CommandName="LogOff" CommandArgument='<%# Eval("UnifiedSessionId") + ";" + Eval("HostServer") %>'
                                                        meta:resourcekey="cmdLogOff" OnClientClick="return confirm('Are you sure you want to log off selected user?')"></asp:LinkButton>
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
                        </ContentTemplate>
                    </asp:UpdatePanel>
				</div>
			</div>
		</div>
	</div>
</div>