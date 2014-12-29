<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollection.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollection" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionServers.ascx" TagName="CollectionServers" TagPrefix="wsp"%>
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
				</div>
				<div class="FormContentRDS">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />					

                    <fieldset id="RDSServersPanel" runat="server">
                        <legend><asp:Localize ID="locRDSServersSection" runat="server" meta:resourcekey="locRDSServersSection" Text="RDS Servers"></asp:Localize></legend>
                        <div style="padding: 10px;">
                            <wsp:CollectionServers id="servers" runat="server" />
                        </div>  
                    </fieldset>
                      
				    <div class="FormFooter">
					    <asp:Button id="btnSave" runat="server" Text="Save" CssClass="Button1" meta:resourcekey="btnSave" OnClick="btnSave_Click" ValidationGroup="SaveRDSCollection"></asp:Button>
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>