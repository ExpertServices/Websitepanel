<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditApplicationUsers.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditApplicationUsers" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
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
				    <wsp:SimpleMessageBox id="SimpleMessageBox1" runat="server" />
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_edit_apps" />
                    
                    <wsp:CollapsiblePanel id="secRdsApplicationEdit" runat="server"
                        TargetControlID="panelRdsApplicationEdit" meta:resourcekey="secRdsApplicationEdit" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsApplicationEdit">                                                
                        <div style="padding: 10px;">
                            <table>
                                <tr>
                                    <td class="FormLabel150" style="width: 150px;">
                                        <asp:Localize ID="locLblApplicationName" runat="server" meta:resourcekey="locLblApplicationName" Text="Application Name"/>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtApplicationName" runat="server" CssClass="TextBox300" />
                                        <asp:RequiredFieldValidator ID="valApplicationName" runat="server" ErrorMessage="*" ControlToValidate="txtApplicationName" ValidationGroup="SaveRDSCollection"/>
                                    </td>
                                </tr>
                            </table>
                        </div>                            
                    </asp:Panel>
                    					
                    <wsp:CollapsiblePanel id="secRdsApplicationUsers" runat="server"
                        TargetControlID="panelRdsApplicationUsers" meta:resourcekey="secRdsApplicationUsers" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsApplicationUsers">                                                
                        <div style="padding: 10px;">
                            <wsp:CollectionUsers id="users" runat="server" />
                        </div>                            
                    </asp:Panel>
                    <div class="FormFooterClean">
                        <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" meta:resourcekey="btnSave" 
                            OnClick="btnSave_Click" OnClientClick="ShowProgressDialog('Updating ...');"></asp:Button>
                        <asp:Button id="btnSaveExit" runat="server" Text="Save Changes and Exit" CssClass="Button1" meta:resourcekey="btnSaveExit" 
                            OnClick="btnSaveExit_Click" OnClientClick="ShowProgressDialog('Updating ...');"></asp:Button>
                        <asp:Button id="btnExit" runat="server" Text="Back to Applications List" CssClass="Button1" meta:resourcekey="btnExit" 
                            OnClick="btnExit_Click" OnClientClick="ShowProgressDialog('Loading ...');"></asp:Button>
			        </div>
				</div>				
			</div>
		</div>
	</div>
</div>