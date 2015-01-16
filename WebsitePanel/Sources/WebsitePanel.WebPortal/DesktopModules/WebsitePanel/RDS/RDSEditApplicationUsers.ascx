<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditApplicationUsers.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditApplicationUsers" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionUsers.ascx" TagName="CollectionUsers" TagPrefix="wsp"%>
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
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit RDS Application"></asp:Localize>
				</div>
				<div class="FormContentRDS">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />

					<table>
					        <tr>
						        <td class="FormLabel150" style="width: 100px;"><asp:Localize ID="locApplicationName" runat="server" meta:resourcekey="locApplicationName" Text="Collection Name:"></asp:Localize></td>
						        <td class="FormLabel150">
                                    <asp:Localize ID="locCName" runat="server" Text="" />
						        </td>
					        </tr>
					    </table> 

                    <fieldset id="UsersPanel" runat="server">
                        <legend><asp:Localize ID="locUsersSection" runat="server" meta:resourcekey="locUsersSection" Text="Users"></asp:Localize></legend>
                        <div style="padding: 10px;">
                            <wsp:CollectionUsers id="users" runat="server" />
                        </div>
                    </fieldset>
                      
				    <div class="FormFooter">
					    <asp:Button id="btnSave" runat="server" Text="Save" CssClass="Button1" meta:resourcekey="btnSave" ValidationGroup="SaveRDSCollectoin" OnClick="btnSave_Click"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="SaveRDSCollectoin" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>