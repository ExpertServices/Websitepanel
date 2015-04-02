<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollection.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollection" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionServers.ascx" TagName="CollectionServers" TagPrefix="wsp"%>
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
					<asp:Image ID="imgAddRDSServer" SkinID="AddRDSServer48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Add Server To Organization"></asp:Localize>
                    -
					<asp:Literal ID="litCollectionName" runat="server" Text="" />
				</div>
				<div class="FormBody">				    
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_edit_collection" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <wsp:CollapsiblePanel id="secRdsServers" runat="server"
                        TargetControlID="panelRdsServers" meta:resourcekey="secRdsServers" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsServers">                                                
                        <div style="padding: 10px;">
                            <wsp:CollectionServers id="servers" runat="server" />
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