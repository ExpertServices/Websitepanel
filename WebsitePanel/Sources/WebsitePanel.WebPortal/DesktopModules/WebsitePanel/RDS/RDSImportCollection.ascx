<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSImportCollection.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSImportCollection" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>
<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgAddRDSServer" SkinID="AddRDSServer48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Import RDS Collection"></asp:Localize>
				</div>
				<div class="FormContentRDS">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />

					<table>
					    <tr>
						    <td class="FormLabel150" style="width: 100px;"><asp:Localize ID="locCollectionName" runat="server" meta:resourcekey="locCollectionName" Text="Collection Name"></asp:Localize></td>
						    <td>
                                <asp:TextBox ID="txtCollectionName" runat="server" CssClass="TextBox300" />
                                <asp:RequiredFieldValidator ID="valCollectionName" runat="server" ErrorMessage="*" ControlToValidate="txtCollectionName" ValidationGroup="SaveRDSCollection"></asp:RequiredFieldValidator>
						    </td>                            
					    </tr>                        
					</table>                                                                                                  
                      
				    <div class="FormFooter">
					    <asp:Button id="btnSave" runat="server" Text="Import" CssClass="Button1" meta:resourcekey="btnSave" OnClick="btnSave_Click" OnClientClick="ShowProgressDialog('Importing collection...');" ValidationGroup="SaveRDSCollection"></asp:Button>
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>