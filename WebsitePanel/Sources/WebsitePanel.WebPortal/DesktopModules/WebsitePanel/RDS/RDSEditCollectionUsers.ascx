<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollectionUsers.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollectionUsers" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionUsers.ascx" TagName="CollectionUsers" TagPrefix="wsp"%>
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
                        <div class="FormContentRDS">
                            <asp:UpdatePanel runat="server" ID="messageUpdatePanel">
                                <ContentTemplate>
                                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                                </ContentTemplate>                                
                            </asp:UpdatePanel>
                            <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_edit_users" />                    					
                            <wsp:CollapsiblePanel id="secRdsUsers" runat="server"
                                TargetControlID="panelRdsUsers" meta:resourcekey="secRdsUsers" Text="">
                            </wsp:CollapsiblePanel>		
                            <asp:Panel runat="server" ID="panelRdsUsers">                                                
                                <div style="padding: 10px;">
                                    <wsp:CollectionUsers id="users" runat="server" />
                                </div>                            
                            </asp:Panel>
                            <div>
                                <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Users Created:"></asp:Localize>
                                &nbsp;&nbsp;&nbsp;
                                <wsp:QuotaViewer ID="usersQuota" runat="server" QuotaTypeId="2" DisplayGauge="true" />
                            </div>
                            <div class="FormFooterClean">
                                <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                                    OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>