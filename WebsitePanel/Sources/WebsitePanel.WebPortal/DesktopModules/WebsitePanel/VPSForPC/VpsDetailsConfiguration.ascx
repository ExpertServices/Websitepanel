﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VpsDetailsConfiguration.ascx.cs" Inherits="WebsitePanel.Portal.VPSForPC.VpsDetailsConfiguration" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CheckBoxOption.ascx" TagName="CheckBoxOption" TagPrefix="wsp" %>
<%@ Register Src="UserControls/ServerTabs.ascx" TagName="ServerTabs" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="UserControls/FormTitle.ascx" TagName="FormTitle" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="VpsContainer">
    <div class="Module">

	    <div class="Header">
		    <wsp:Breadcrumb id="breadcrumb" runat="server" />
	    </div>
    	
	    <div class="Left">
		    <wsp:Menu id="menu" runat="server" SelectedItem="" />
	    </div>
    	
	    <div class="Content">
		    <div class="Center">
			    <div class="Title">
				    <asp:Image ID="imgIcon" SkinID="ServerConfig48" runat="server" />
				    <wsp:FormTitle ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Configuration" />
			    </div>
			    <div class="FormBody">
			        <wsp:ServerTabs id="tabs" runat="server" SelectedTab="vps_config" />	
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                   
                    <wsp:CollapsiblePanel id="secSoftware" runat="server"
                        TargetControlID="SoftwarePanel" meta:resourcekey="secSoftware" Text="Software">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="SoftwarePanel" runat="server" Height="0" style="overflow:hidden;padding:5px;">
                        <table cellspacing="5">
                            <tr>
                                <td><asp:Localize ID="locOperatingSystem" runat="server"
                                    meta:resourcekey="locOperatingSystem" Text="Operating system:"></asp:Localize></td>
                                <td>
                                    <asp:Literal ID="litOperatingSystem" runat="server" Text="[OS]"></asp:Literal>
                                </td>
                            </tr>
                            <tr>
                                <td><asp:Localize ID="locAdministratorPassword" runat="server"
                                    meta:resourcekey="locAdministratorPassword" Text="Administrator password:"></asp:Localize></td>
                                <td>
                                    ********
                                    <asp:LinkButton ID="btnChangePasswordPopup" runat="server" CausesValidation="false"
                                        Text="Change" meta:resourcekey="btnChangePasswordPopup"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    

                    <wsp:CollapsiblePanel id="secResources" runat="server"
                        TargetControlID="ResourcesPanel" meta:resourcekey="secResources" Text="Resources">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="ResourcesPanel" runat="server" Height="0" style="overflow:hidden;padding:10px;width:400px;">
                        <table cellspacing="5">
                            <tr>
                                <td class="Medium"><asp:Localize ID="lblCpu" runat="server"
                                        meta:resourcekey="lblCpu" Text="CPU:" /></td>
                                <td class="MediumBold">
                                    <asp:Literal ID="litCpu" runat="server" Text="[cpu]"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                        <table cellspacing="5">
                            <tr>
                                <td class="Medium"><asp:Localize ID="lblRam" runat="server"
                                        meta:resourcekey="lblRam" Text="RAM:" /></td>
                                <td class="MediumBold">
                                    <asp:Literal ID="litRam" runat="server" Text="[ram]"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                        <table cellspacing="5">
                            <tr>
                                <td class="Medium"><asp:Localize ID="lblHdd" runat="server"
                                        meta:resourcekey="lblHdd" Text="HDD:" /></td>
                                <td class="MediumBold">
                                    <asp:Literal ID="litHdd" runat="server" Text="[hdd]"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    
                    <wsp:CollapsiblePanel id="secActions" runat="server"
                        TargetControlID="ActionsPanel" meta:resourcekey="secActions" Text="Allowed actions">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="ActionsPanel" runat="server" Height="0" style="overflow:hidden;padding:5px;">
                        <table style="width:400px;" cellspacing="5">
                            <tr>
                                <td style="width:200px;">
                                    <wsp:CheckBoxOption id="optionStartShutdown" runat="server"
                                        Text="Start, Turn off and Shutdown" meta:resourcekey="optionStartShutdown" Value="True" />
                                </td>
                                <td>
                                    <wsp:CheckBoxOption id="optionReset" runat="server"
                                        Text="Reset" meta:resourcekey="optionReset" Value="True" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <wsp:CheckBoxOption id="optionPauseResume" runat="server"
                                        Text="Pause, Resume" meta:resourcekey="optionPauseResume" Value="False" />
                                </td>
                                <td>
                                    <wsp:CheckBoxOption id="optionReinstall" runat="server"
                                        Text="Re-install" meta:resourcekey="optionReinstall" Value="True" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <wsp:CheckBoxOption id="optionReboot" runat="server"
                                        Text="Reboot" meta:resourcekey="optionReboot" Value="True" />
                                </td>
                                <td>
                                    
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    
                    <wsp:CollapsiblePanel id="secNetwork" runat="server"
                        TargetControlID="NetworkPanel" meta:resourcekey="secNetwork" Text="Network">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="NetworkPanel" runat="server" Height="0" style="overflow:hidden;padding:5px;">
                        <table cellspacing="5">
                            <tr>
                                <td><wsp:CheckBoxOption id="optionExternalNetwork" runat="server"
                                        Text="External network enabled" meta:resourcekey="optionExternalNetwork" Value="True" />
                                </td>
                            </tr>
                            <tr>
                                <td><wsp:CheckBoxOption id="optionPrivateNetwork" runat="server"
                                        Text="Private network enabled" meta:resourcekey="optionPrivateNetwork" Value="True" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    
                    <p style="padding: 5px;">
                        <asp:Button ID="btnEdit" runat="server" CssClass="Button1"
			                 meta:resourcekey="btnEdit" Text="Edit configuration" CausesValidation="false"  Enabled="false"
                            onclick="btnEdit_Click" />
                    </p>

			    </div>
		    </div>
		    <div class="Right">
			    <asp:Localize ID="FormComments" runat="server" meta:resourcekey="FormComments"></asp:Localize>
		    </div>
	    </div>
    	
    </div>
</div>

<asp:Panel ID="ChangePasswordPanel" runat="server" CssClass="Popup" style="display:none;">
	<table class="Popup-Header" cellpadding="0" cellspacing="0">
		<tr>
			<td class="Popup-HeaderLeft"></td>
			<td class="Popup-HeaderTitle">
				<asp:Localize ID="locChangePassword" runat="server" Text="Change Administrator Password"
				    meta:resourcekey="locChangePassword"></asp:Localize>
			</td>
			<td class="Popup-HeaderRight"></td>
		</tr>
	</table>
	<div class="Popup-Content">
		<div class="Popup-Body">
			<br />
			
			<table cellspacing="7" style="margin-left:20px;">
			    <tr>
			        <td>
			            <asp:Localize ID="locNewPassword" runat="server" Text="Enter new password:"
				            meta:resourcekey="locNewPassword"></asp:Localize>
			        </td>
			    </tr>
			    <tr>
			        <td>
			            <wsp:PasswordControl id="password" runat="server"
			                ValidationGroup="ChangePassword"></wsp:PasswordControl>
			        </td>
			    </tr>
			</table>
			
                                                
			<br />
		</div>
		
		<div class="FormFooter">
		    <asp:Button ID="btnChangePassword" runat="server" CssClass="Button1"
		        meta:resourcekey="btnChangePassword" Text="Change password" 
                ValidationGroup="ChangePassword" onclick="btnChangePassword_Click" />
		        
			<asp:Button ID="btnCancelChangePassword" runat="server" CssClass="Button1"
			    meta:resourcekey="btnCancelChangePassword" Text="Cancel" CausesValidation="false" />
		</div>
	</div>
</asp:Panel>

<ajaxToolkit:ModalPopupExtender ID="ChangePasswordModal" runat="server" BehaviorID="PasswordModal"
	TargetControlID="btnChangePasswordPopup" PopupControlID="ChangePasswordPanel"
	BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelChangePassword" />