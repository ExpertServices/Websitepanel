<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncCreateUser.ascx.cs" Inherits="WebsitePanel.Portal.Lync.CreateLyncUser" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="UserControls/LyncUserPlanSelector.ascx" TagName="LyncUserPlanSelector" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />
<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
            <wsp:Menu id="menu" runat="server" />
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                </div>
                <div class="FormBody">
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    <table id="ExistingUserTable"   runat="server" width="100%"> 					    
					    <tr>
					        <td class="FormLabel150"><asp:Localize ID="Localize1" runat="server" meta:resourcekey="locDisplayName" Text="Display Name: *"></asp:Localize></td>
					        <td>                                
                                <wsp:UserSelector ID="userSelector" runat="server" IncludeMailboxesOnly="false" IncludeMailboxes="true" ExcludeOCSUsers="true" ExcludeLyncUsers="true"/>
                            </td>
					    </tr>
					    	    					    					    
					</table>

					    <table>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize ID="locPlanName" runat="server" meta:resourcekey="locPlanName" Text="Plan Name: *"></asp:Localize>
                                </td>
                                <td>                                
                                    <wsp:LyncUserPlanSelector ID="planSelector" runat="server" />
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
					    <asp:Button id="btnCreate" runat="server" ValidationGroup="Validation1"
					    CssClass="Button1" meta:resourcekey="btnCreate" 
					     onclick="btnCreate_Click" ></asp:Button>					    
				    </div>			
                </div>
            </div>
        </div>
    </div>
</div>

