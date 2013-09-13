<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncAddLyncUserPlan.ascx.cs" Inherits="WebsitePanel.Portal.Lync.LyncAddLyncUserPlan" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/SizeBox.ascx" TagName="SizeBox" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/DaysBox.ascx" TagName="DaysBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Header">
			<wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" />
		</div>
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="mailboxplans" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="LyncUserPlanAdd48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Add Mailboxplan"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />

					<wsp:CollapsiblePanel id="secPlan" runat="server"
                        TargetControlID="Plan" meta:resourcekey="secPlan" Text="Plan">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="Plan" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td class="FormLabel200" align="right">
									
								</td>
							    <td>
									<asp:TextBox ID="txtPlan" runat="server" CssClass="TextBox200" ></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="valRequirePlan" runat="server" meta:resourcekey="valRequirePlan" ControlToValidate="txtPlan"
									ErrorMessage="Enter plan name" ValidationGroup="CreatePlan" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
								</td>
						    </tr>
					    </table>
					    <br />
					</asp:Panel>

					<wsp:CollapsiblePanel id="secPlanFeatures" runat="server"
                        TargetControlID="PlanFeatures" meta:resourcekey="secPlanFeatures" Text="Plan Features">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PlanFeatures" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkIM" runat="server" meta:resourcekey="chkIM" Text="Instant Messaging"></asp:CheckBox>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkMobility" runat="server" meta:resourcekey="chkMobility" Text="Mobility"></asp:CheckBox>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkConferencing" runat="server" meta:resourcekey="chkConferencing" Text="Conferencing"></asp:CheckBox>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkEnterpriseVoice" runat="server" meta:resourcekey="chkEnterpriseVoice" Text="Enterprise Voice"></asp:CheckBox>
							    </td>
						    </tr>
						</table>
						<br />
					</asp:Panel>


					<wsp:CollapsiblePanel id="secPlanFeaturesFederation" runat="server"
                        TargetControlID="PlanFeaturesFederation" meta:resourcekey="secPlanFeaturesFederation" Text="Federation">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PlanFeaturesFederation" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkFederation" runat="server" meta:resourcekey="chkFederation" Text="Federation"></asp:CheckBox>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkRemoteUserAccess" runat="server" meta:resourcekey="chkRemoteUserAccess" Text="Remote User access"></asp:CheckBox>
							    </td>
						    </tr>
						</table>
						<br />
					</asp:Panel>

					<wsp:CollapsiblePanel id="secPlanFeaturesArchiving" runat="server"
                        TargetControlID="PlanFeaturesArchiving" meta:resourcekey="secPlanFeaturesArchiving" Text="Archiving">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PlanFeaturesArchiving" runat="server" Height="0" style="overflow:hidden;">
					    <table>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locArchivingPolicy" meta:resourcekey="locArchivingPolicy" Text="Archiving Policy:" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddArchivingPolicy" runat="server"></asp:DropDownList>
                                </td>
                            </tr>
						</table>
						<br />
					</asp:Panel>

					<wsp:CollapsiblePanel id="secPlanFeaturesMeeting" runat="server"
                        TargetControlID="PlanFeaturesMeeting" meta:resourcekey="secPlanFeaturesMeeting" Text="Meeting">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PlanFeaturesMeeting" runat="server" Height="0" style="overflow:hidden;">
					    <table>
						    <tr>
							    <td>
								    <asp:CheckBox ID="chkAllowOrganizeMeetingsWithExternalAnonymous" runat="server" meta:resourcekey="chkAllowOrganizeMeetingsWithExternalAnonymous" Text="Allow organize meetings with external anonymous participants"></asp:CheckBox>
							    </td>
						    </tr>
						</table>
						<br />
					</asp:Panel>

					<wsp:CollapsiblePanel id="secPlanFeaturesTelephony" runat="server"
                        TargetControlID="PlanFeaturesTelephony" meta:resourcekey="secPlanFeaturesTelephony" Text="Telephony">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PlanFeaturesTelephony" runat="server" Height="0" style="overflow:hidden;">
					    <table>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locTelephony" meta:resourcekey="locTelephony" Text="Telephony :" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddTelephony" runat="server" AutoPostBack="True">
                                        <asp:ListItem Value="0" Text="Audio/Video disabled" meta:resourcekey="ddlTelephonyDisabled" />
                                        <asp:ListItem Value="1" Text="PC-to-PC only" meta:resourcekey="ddlTelephonyPCtoPCOnly" />
                                        <asp:ListItem Value="2" Text="Enterprise voice" meta:resourcekey="ddlTelephonyEnterpriseVoice" />
                                        <asp:ListItem Value="3" Text="Remote call control" meta:resourcekey="ddlTelephonyRemoteCallControl" />
                                        <asp:ListItem Value="4" Text="Remote call control only" meta:resourcekey="ddlTelephonyRemoteCallControlOnly" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>

                        <asp:Panel runat="server" ID="pnEnterpriseVoice">
                        <table>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locTelephonyProvider" meta:resourcekey="locTelephonyProvider" Text="Telephony Provider :" />
                                </td>
                                <td>
                                    <asp:TextBox ID="tbTelephoneProvider" runat="server"></asp:TextBox>
                                    <asp:Button runat="server" ID="btnAccept" Text="Accept" OnClick="btnAccept_Click" OnClientClick="ShowProgressDialog('Loading...');" ValidationGroup="Accept"/>

                                    <asp:RequiredFieldValidator id="AcceptRequiredValidator" runat="server" ErrorMessage="Please enter provider name"
                                    ControlToValidate="tbTelephoneProvider" Display="Dynamic" ValidationGroup="Accept" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locDialPlan" meta:resourcekey="locDialPlan" Text="Dial Plan :" />
                                </td>
                                <td>        
                                    <asp:DropDownList ID="ddTelephonyDialPlanPolicy" runat="server"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locVoicePolicy" meta:resourcekey="locVoicePolicy" Text="Voice Policy :" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddTelephonyVoicePolicy" runat="server"></asp:DropDownList>
                                </td>
                            </tr>

                        </table>
                    </asp:Panel>

                    <asp:Panel runat="server" ID="pnServerURI">
                        <table>
                            <tr>
                                <td class="FormLabel150">
                                    <asp:Localize runat="server" ID="locServerURI" meta:resourcekey="locServerURI" Text="Server URI :" />
                                </td>
                                <td>
                                    <asp:TextBox ID="tbServerURI" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

					<br />
					</asp:Panel>


			        <%-- Disable because not used
					<wsp:CollapsiblePanel id="secEnterpriseVoice" runat="server"
                        TargetControlID="EnterpriseVoice" meta:resourcekey="secEnterpriseVoice" Text="Enterprise Voice Policy">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="EnterpriseVoice" runat="server" Height="0" style="overflow:hidden;">
						<table>
						    <tr>
							    <td>
								    <asp:RadioButton ID="chkNone" groupName="VoicePolicy" runat="server" meta:resourcekey="chkNone" Text="None"></asp:RadioButton>
							    </td>
						    </tr>

						    <tr>
							    <td>
								    <asp:RadioButton ID="chkEmergency" groupName="VoicePolicy" runat="server" meta:resourcekey="chkEmergency" Text="Emergency Calls"></asp:RadioButton>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:RadioButton ID="chkNational" groupName="VoicePolicy" runat="server" meta:resourcekey="chkNational" Text="National Calls"></asp:RadioButton>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:RadioButton ID="chkMobile" groupName="VoicePolicy" runat="server" meta:resourcekey="chkMobile" Text="Mobile Calls"></asp:RadioButton>
							    </td>
						    </tr>
						    <tr>
							    <td>
								    <asp:RadioButton ID="chkInternational" groupName="VoicePolicy" runat="server" meta:resourcekey="chkInternational" Text="International Calls"></asp:RadioButton>
							    </td>
						    </tr>


						</table>
						<br />
					</asp:Panel>
					--%>
					
					<br />
				    <div class="FormFooterClean">
					    <asp:Button id="btnAdd" runat="server" Text="Add Plan" CssClass="Button1" meta:resourcekey="btnAdd" ValidationGroup="CreatePlan" OnClick="btnAdd_Click" OnClientClick="ShowProgressDialog('Creating Plan...');"></asp:Button>
					    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreatePlan" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>