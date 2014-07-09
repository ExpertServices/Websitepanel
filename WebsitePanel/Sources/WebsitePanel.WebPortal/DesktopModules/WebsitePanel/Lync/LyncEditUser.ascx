<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncEditUser.ascx.cs" Inherits="WebsitePanel.Portal.Lync.EditLyncUser" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register src="../ExchangeServer/UserControls/MailboxSelector.ascx" tagname="MailboxSelector" tagprefix="uc1" %>
<%@ Register Src="UserControls/LyncUserPlanSelector.ascx" TagName="LyncUserPlanSelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/LyncUserSettings.ascx" TagName="LyncUserSettings" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />
<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                    -
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
                <div class="FormBody">
                    
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <table>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize ID="locPlanName" runat="server" meta:resourcekey="locPlanName" Text="Plan Name: *"></asp:Localize>
                            </td>
                            <td>                                
                                <wsp:LyncUserPlanSelector ID="planSelector" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize ID="locSipAddress" runat="server" meta:resourcekey="locSipAddress" Text="SIP Address: *"></asp:Localize>
                            </td>
                            <td>                                
                                <wsp:LyncUserSettings ID="lyncUserSettings" runat="server" />
                            </td>
                        </tr>
                    </table>

                    <asp:Panel runat="server" ID="pnEnterpriseVoice">
                    <table>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize runat="server" ID="locPhoneNumber" meta:resourcekey="locPhoneNumber" Text="Phone Number:" />
                            </td>
                            <td>
                                <!-- <asp:TextBox runat="server" ID="tb_PhoneNumber" /> -->
                                <asp:dropdownlist id="ddlPhoneNumber" Runat="server" CssClass="NormalTextBox"></asp:dropdownlist>
                                <asp:RegularExpressionValidator ID="PhoneFormatValidator" runat="server"
		                        ControlToValidate="ddlPhoneNumber" Display="Dynamic" ValidationGroup="Validation1" SetFocusOnError="true"
		                        ValidationExpression="^([0-9])*$"
                                ErrorMessage="Must contain only numbers.">
                                </asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize runat="server" ID="locLyncPin" meta:resourcekey="locLyncPin" Text="Lync Pin:" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="tbPin" />
                                <asp:RegularExpressionValidator ID="PinRegularExpressionValidator" runat="server"
		                        ControlToValidate="tbPin" Display="Dynamic" ValidationGroup="Validation1" SetFocusOnError="true"
		                        ValidationExpression="^([0-9])*$"
                                ErrorMessage="Must contain only numbers.">
                                </asp:RegularExpressionValidator>
                            </td>
                        </tr>
					</table>
                    </asp:Panel>
                        
					<div class="FormFooterClean">
					 <asp:Button runat="server" ID="btnSave" meta:resourcekey="btnSave" ValidationGroup="Validation1"
                        CssClass="Button1" onclick="btnSave_Click"  />					 					                                                
				    </div>			
                </div>
            </div>
        </div>
    </div>
</div>
