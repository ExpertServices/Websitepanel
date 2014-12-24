<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollectionApps.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollectionApps" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionApps.ascx" TagName="CollectionApps" TagPrefix="wsp"%>
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
				</div>
				<div class="FormContentRDS">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />

					<table>
					        <tr>
						        <td class="FormLabel150" style="width: 100px;"><asp:Localize ID="locCollectionName" runat="server" meta:resourcekey="locCollectionName" Text="Collection Name"></asp:Localize></td>
						        <td class="FormLabel150">
                                    <asp:Localize ID="locCName" runat="server" Text="RDS Collection 1" />
						        </td>
					        </tr>
					    </table> 

                    <fieldset id="RemoteAppsPanel" runat="server">
                        <legend><asp:Localize ID="locRemoteAppsSection" runat="server" meta:resourcekey="locRemoteAppsSection" Text="Remote Applications"></asp:Localize></legend>
                        <div style="padding: 10px;">
                            <wsp:CollectionApps id="remoreApps" runat="server" />
                        </div>  
                    </fieldset>
                      
				    <div class="FormFooter">
					    <asp:Button id="btnSave" runat="server" Text="Save Changes" CssClass="Button1" meta:resourcekey="btnSave" ValidationGroup="SaveRDSCollectoin" OnClick="btnSave_Click"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="SaveRDSCollectoin" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>