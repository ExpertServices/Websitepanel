<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationUserGeneralSettings.ascx.cs" Inherits="WebsitePanel.Portal.HostedSolution.UserGeneralSettings" %>
<%@ Register Src="UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CountrySelector.ascx" TagName="CountrySelector" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>

<%@ Register Src="../UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>



<%@ Register src="UserControls/UserTabs.ascx" tagname="UserTabs" tagprefix="uc1" %>
<%@ Register src="UserControls/MailboxTabs.ascx" tagname="MailboxTabs" tagprefix="uc1" %>

<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>


<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="OrganizationUser48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit User"></asp:Localize>
					-
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                    <asp:Image ID="imgVipUser" SkinID="VipUser16" runat="server" tooltip="VIP user" Visible="false"/>
                    <asp:Label ID="litServiceLevel" runat="server" style="float:right;padding-right:8px;" Visible="false"></asp:Label>
                </div>

				<div class="FormBody">
                    <uc1:UserTabs ID="UserTabsId" runat="server" SelectedTab="edit_user" />
                    <uc1:MailboxTabs ID="MailboxTabsId" runat="server" SelectedTab="edit_user" />
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
					<table>
						<tr>
						    <td class="FormLabel150"> <asp:Localize ID="locUserPrincipalName" runat="server" meta:resourcekey="locUserPrincipalName" Text="Login Name:"></asp:Localize></td>
						    <td>
                                <asp:Label runat="server" ID="lblUserPrincipalName" />
                                <wsp:EmailAddress id="upn" runat="server" ValidationGroup="CreateMailbox"></wsp:EmailAddress>
                                <asp:DropDownList ID="ddlEmailAddresses" runat="server" CssClass="NormalTextBox"></asp:DropDownList>
						    </td>
                            <td>
                                <asp:Button id="btnSetUserPrincipalName" runat="server" Text="Set Login" CssClass="Button1"
							meta:resourcekey="btnSetUserPrincipalName" OnClick="btnSetUserPrincipalName_Click"></asp:Button>
                            </td>
                            <td>
                                <asp:CheckBox ID="chkInherit" runat="server" meta:resourcekey="chkInherit" Text="Services inherit Login Name" checked="true"/>
                            </td>
						</tr>					   

						<tr>
							<td class="FormLabel150"><asp:Localize ID="locDisplayName" runat="server" meta:resourcekey="locDisplayName" Text="Display Name: *"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtDisplayName" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
								<asp:RequiredFieldValidator ID="valRequireDisplayName" runat="server" meta:resourcekey="valRequireDisplayName" ControlToValidate="txtDisplayName"
									ErrorMessage="Enter Display Name" ValidationGroup="EditMailbox" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
							</td>
						</tr>
						
						<tr>
							<td class="FormLabel150" valign="top"><asp:Localize ID="locPassword" runat="server" meta:resourcekey="locPassword" Text="Password:"></asp:Localize></td>
							<td>
                                <wsp:PasswordControl id="password" runat="server" ValidationGroup="ValidatePassword">
                                </wsp:PasswordControl>
                            </td>
                            <td>
                                <asp:Button id="btnSetUserPassword" runat="server" Text="Set Password" CssClass="Button1"
							meta:resourcekey="btnSetUserPassword" OnClick="btnSetUserPassword_Click" ValidationGroup="ValidatePassword"></asp:Button>
					            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="ValidatePassword" />
                            </td>
						</tr>
						
						
						<tr>
						    <td></td>
						    <td>
						        <br />
						        <asp:CheckBox ID="chkDisable" runat="server" meta:resourcekey="chkDisable" Text="Disable User" />
						        <br />
						        <asp:CheckBox ID="chkLocked" runat="server" meta:resourcekey="chkLocked" Text="Lock User" />
						        <br />
						    </td>
						</tr>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locFirstName" runat="server" meta:resourcekey="locFirstName" Text="First Name:"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBox100"></asp:TextBox>
								&nbsp;
								<asp:Localize ID="locInitials" runat="server" meta:resourcekey="locInitials" Text="Initials:" />
								<asp:TextBox ID="txtInitials" runat="server" MaxLength="6" CssClass="TextBox100"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td class="FormLabel150"><asp:Localize ID="locLastName" runat="server" meta:resourcekey="locLastName" Text="Last Name:"></asp:Localize></td>
							<td>
								<asp:TextBox ID="txtLastName" runat="server" CssClass="TextBox200"></asp:TextBox>
							</td>
						</tr>
						<tr>
						    <td class="FormLabel150" valign="top"><asp:Localize ID="locSubscriberNumber" runat="server" meta:resourcekey="locSubscriberNumber" ></asp:Localize></td>
						    <td><asp:TextBox runat="server" ID="txtSubscriberNumber"  CssClass="TextBox200"/></td>
						</tr>
						<tr>
						    <td class="FormLabel150" valign="top"><asp:Localize ID="locExternalEmailAddress" runat="server" meta:resourcekey="locExternalEmailAddress" ></asp:Localize></td>
						    <td><asp:TextBox runat="server" ID="txtExternalEmailAddress"  CssClass="TextBox200"/></td>
						</tr>

					</table>
                    <table>
					    <tr>
						    <td class="FormLabel150"><asp:Localize ID="locNotes" runat="server" meta:resourcekey="locNotes" Text="Notes:"></asp:Localize></td>
						    <td>
							    <asp:TextBox ID="txtNotes" runat="server" CssClass="TextBox200" Rows="4" TextMode="MultiLine"></asp:TextBox>
						    </td>
					    </tr>
					</table>
                    
                    <wsp:CollapsiblePanel id="secServiceLevels" runat="server" IsCollapsed="true"
                        TargetControlID="ServiceLevels" meta:resourcekey="secServiceLevels" Text="Service Level Information">
                    </wsp:CollapsiblePanel>

                    <asp:Panel ID="ServiceLevels" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locServiceLevel" runat="server" meta:resourcekey="locServiceLevel"  Text="Service Level:"></asp:Localize></td>
							    <td>
								    <asp:DropDownList ID="ddlServiceLevels" DataValueField="LevelId" DataTextField="LevelName" runat="server"></asp:DropDownList>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locVIPUser" runat="server" meta:resourcekey="locVIPUser" Text="VIP:"></asp:Localize></td>
							    <td>
								    <asp:CheckBox ID="chkVIP" runat="server"/>
							    </td>
						    </tr>
					    </table>
					</asp:Panel>
					
									
					<wsp:CollapsiblePanel id="secCompanyInfo" runat="server" IsCollapsed="true"
                        TargetControlID="CompanyInfo" meta:resourcekey="secCompanyInfo" Text="Company Information">
                    </wsp:CollapsiblePanel>

                    <asp:Panel ID="CompanyInfo" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locJobTitle" runat="server" meta:resourcekey="locJobTitle" Text="Job Title:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtJobTitle" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locCompany" runat="server" meta:resourcekey="locCompany" Text="Company:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtCompany" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locDepartment" runat="server" meta:resourcekey="locDepartment" Text="Department:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtDepartment" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locOffice" runat="server" meta:resourcekey="locOffice" Text="Office:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtOffice" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locManager" runat="server" meta:resourcekey="locManager" Text="Manager:"></asp:Localize></td>
							    <td>
                                    <wsp:UserSelector id="manager" IncludeMailboxes="true" runat="server"/>
                                </td>
						    </tr>
					    </table>
					</asp:Panel>
					
					
					<wsp:CollapsiblePanel id="secContactInfo" runat="server" IsCollapsed="true"
                        TargetControlID="ContactInfo" meta:resourcekey="secContactInfo" Text="Contact Information">
                    </wsp:CollapsiblePanel>
                                      
                    <asp:Panel ID="ContactInfo" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locBusinessPhone" runat="server" meta:resourcekey="locBusinessPhone" Text="Business Phone:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtBusinessPhone" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locFax" runat="server" meta:resourcekey="locFax" Text="Fax:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtFax" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locHomePhone" runat="server" meta:resourcekey="locHomePhone" Text="Home Phone:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtHomePhone" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locMobilePhone" runat="server" meta:resourcekey="locMobilePhone" Text="Mobile Phone:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtMobilePhone" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locPager" runat="server" meta:resourcekey="locPager" Text="Pager:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtPager" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locWebPage" runat="server" meta:resourcekey="locWebPage" Text="Web Page:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtWebPage" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
					    </table>
					</asp:Panel>
					
					<wsp:CollapsiblePanel id="secAddressInfo" runat="server" IsCollapsed="true"
                        TargetControlID="AddressInfo" meta:resourcekey="secAddressInfo" Text="Address">
                    </wsp:CollapsiblePanel>

                    <asp:Panel ID="AddressInfo" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locAddress" runat="server" meta:resourcekey="locAddress" Text="Street Address:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtAddress" runat="server" CssClass="TextBox200" Rows="2" TextMode="MultiLine"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locCity" runat="server" meta:resourcekey="locCity" Text="City:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtCity" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locState" runat="server" meta:resourcekey="locState" Text="State/Province:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtState" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locZip" runat="server" meta:resourcekey="locZip" Text="Zip/Postal Code:"></asp:Localize></td>
							    <td>
								    <asp:TextBox ID="txtZip" runat="server" CssClass="TextBox200"></asp:TextBox>
							    </td>
						    </tr>
						    <tr>
							    <td class="FormLabel150"><asp:Localize ID="locCountry" runat="server" meta:resourcekey="locCountry" Text="Country/Region:"></asp:Localize></td>
							    <td>
									<wsp:CountrySelector id="country" runat="server"></wsp:CountrySelector>
								</td>
						    </tr>
					    </table>
					</asp:Panel>
					
					<wsp:CollapsiblePanel id="secAdvanced" runat="server" IsCollapsed="true"
                        TargetControlID="AdvancedInfo" meta:resourcekey="secAdvanced" Text="Advanced">
                    </wsp:CollapsiblePanel>	
                    
                    <asp:Panel ID="AdvancedInfo" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
						    <td class="FormLabel150"> <asp:Localize ID="locUserDomainName" runat="server" meta:resourcekey="locUserDomainName" Text="User Domain Name:"></asp:Localize></td>
						    <td><asp:Label runat="server" ID="lblUserDomainName" /></td>
						</tr>					   
					    </table>
					</asp:Panel>
												
													
					
				    <div class="FormFooterClean">
                        <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="EditMailbox" 
                            OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="EditMailbox" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>