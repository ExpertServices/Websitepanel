<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollectionApps.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollectionApps" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionApps.ascx" TagName="CollectionApps" TagPrefix="wsp"%>
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
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_edit_apps" />
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />                    

                    <wsp:CollapsiblePanel id="secRdsApplications" runat="server"
                        TargetControlID="panelRdsApplications" meta:resourcekey="secRdsApplications" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsApplications">                                                
                        <div style="padding: 10px;">
                            <wsp:CollectionApps id="remoreApps" runat="server" />
                        </div>                            
                    </asp:Panel>
                    <div class="FormFooterClean">
                        <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                            OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
			        </div>   
				</div>
			</div>
		</div>
	</div>
</div>