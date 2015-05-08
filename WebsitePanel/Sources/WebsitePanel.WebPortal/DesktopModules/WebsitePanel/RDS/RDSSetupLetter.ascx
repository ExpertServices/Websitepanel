<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSSetupLetter.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSSeupLetter" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionTabs.ascx" TagName="CollectionTabs" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgEditRDSCollection" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Setup Instructions"></asp:Localize>                    
                </div>
				<div class="FormBody">                    
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_collection_edit_users" />

                    <wsp:CollapsiblePanel id="secEmail" runat="server" IsCollapsed="true"
                        TargetControlID="EmailPanel" meta:resourcekey="secEmail" Text="Send via E-Mail">
                    </wsp:CollapsiblePanel>
	                <asp:Panel ID="EmailPanel" runat="server" Height="0" style="overflow:hidden;">
                        <table id="tblEmail" runat="server" cellpadding="2">
                            <tr>
                                <td class="SubHead" width="30" nowrap>
                                    <asp:Label ID="lblTo" runat="server" meta:resourcekey="lblTo" Text="To:"></asp:Label>
                                </td>
                                <td class="Normal">
                                    <asp:TextBox ID="txtTo" runat="server" CssClass="NormalTextBox" Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="valRequireEmail" runat="server" ControlToValidate="txtTo" Display="Dynamic"
                                        ErrorMessage="Enter e-mail" ValidationGroup="SendEmail" meta:resourcekey="valRequireEmail"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="SubHead">
                                    <asp:Label ID="lblCC" runat="server" meta:resourcekey="lblCC" Text="CC:"></asp:Label>
                                </td>
                                <td class="Normal">
                                    <asp:TextBox ID="txtCC" runat="server" CssClass="NormalTextBox" Width="300px"></asp:TextBox></td>
                            </tr>                            
                        </table>
                        <div class="FormFooterClean">
                        <asp:Button id="btnExit" runat="server" Text="Back to Users List" CssClass="Button1" meta:resourcekey="btnExit" 
                                        OnClick="btnExit_Click" OnClientClick="ShowProgressDialog('Loading ...');"/>
                        <asp:Button ID="btnSend" runat="server" CssClass="Button2" meta:resourcekey="btnSend" Text="Send" OnClick="btnSend_Click" ValidationGroup="SendEmail" />
			        </div>
                    </asp:Panel>
					
                    <div class="PreviewArea">
                        <asp:Literal ID="litContent" runat="server"></asp:Literal>
                    </div>										
				</div>
			</div>
		</div>
	</div>
</div>