<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeRetentionPolicyTag.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeRetentionPolicyTag" %>
<%@ Register Src="UserControls/SizeBox.ascx" TagName="SizeBox" TagPrefix="wsp" %><%@ Register Src="UserControls/DaysBox.ascx" TagName="DaysBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaEditor.ascx" TagName="QuotaEditor" TagPrefix="uc1" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>

<%@ Import Namespace="WebsitePanel.Portal" %>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainName48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" Text="Retention policy tag"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />


	                <asp:GridView id="gvPolicy" runat="server"  EnableViewState="true" AutoGenerateColumns="false"
		                Width="100%" EmptyDataText="gvPolicy" CssSelectorClass="NormalGridView" OnRowCommand="gvPolicy_RowCommand" >
		                <Columns>
                            <asp:TemplateField>
							    <ItemTemplate>							        
								    <asp:Image ID="imgType" runat="server" Width="16px" Height="16px" ImageUrl='<%# GetTagType((int)Eval("ItemID")) %>' ImageAlign="AbsMiddle" />
							    </ItemTemplate>
						    </asp:TemplateField>
			                <asp:TemplateField HeaderText="Tag">
				                <ItemStyle Width="70%"></ItemStyle>
				                <ItemTemplate>
                                    <asp:LinkButton ID="linkcmdEdit" runat="server" CommandName="EditItem" AlternateText="Edit record" CommandArgument='<%# Eval("TagId") %>' Enabled='<%# ((int)Eval("ItemID") == PanelRequest.ItemID) %>' >
					                    <asp:Label id="lnkDisplayPolicy" runat="server" EnableViewState="true" ><%# PortalAntiXSS.Encode((string)Eval("TagName"))%></asp:Label>
                                    </asp:LinkButton>
                                 </ItemTemplate>
			                </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="cmdEdit" runat="server" SkinID="EditSmall" CommandName="EditItem" CommandArgument='<%# Eval("TagId") %>' Visible='<%# ((int)Eval("ItemID") == PanelRequest.ItemID) %>' ></asp:ImageButton>
                                </ItemTemplate>
                             </asp:TemplateField>
			                <asp:TemplateField>
				                <ItemTemplate>
					                &nbsp;<asp:ImageButton id="imgDelPolicy" runat="server" Text="Delete" SkinID="ExchangeDelete"
						                CommandName="DeleteItem" CommandArgument='<%# Eval("TagId") %>' 
						                meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected policy tag?')"
                                        Visible='<%# ((int)Eval("ItemID") == PanelRequest.ItemID) %>' >
					                      </asp:ImageButton>
				                </ItemTemplate>
			                </asp:TemplateField>
		                </Columns>
	                </asp:GridView>
	                <br />
    	            <wsp:CollapsiblePanel id="secPolicy" runat="server"
                        TargetControlID="Policy" meta:resourcekey="secPolicy" Text="Policy">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="Policy" runat="server" Height="0" style="overflow:hidden;">
			            <table>
				            <tr>
					            <td class="FormLabel200" align="right">
									
					            </td>
					            <td>
						            <asp:TextBox ID="txtPolicy" runat="server" CssClass="TextBox200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="valRequirePolicy" runat="server" meta:resourcekey="valRequirePolicy" ControlToValidate="txtPolicy"
						            ErrorMessage="Enter policy tag name" ValidationGroup="CreatePolicy" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
					            </td>
				            </tr>
			            </table>
			            <br />
		            </asp:Panel>

		            <wsp:CollapsiblePanel id="secPolicyFeatures" runat="server"
                        TargetControlID="PolicyFeatures" meta:resourcekey="secPolicyFeatures" Text="Policy Tag Features">
                    </wsp:CollapsiblePanel>
                    <asp:Panel ID="PolicyFeatures" runat="server" Height="0" style="overflow:hidden;">
			            <table>
				            <tr>
					            <td class="FormLabel200" align="right"><asp:Localize ID="locType" runat="server" meta:resourcekey="locType" Text="Type :"></asp:Localize></td>
					            <td>
                                    <asp:DropDownList ID="ddTagType" runat="server"></asp:DropDownList>
					            </td>
				            </tr>
				            <tr>
					            <td class="FormLabel200" align="right"><asp:Localize ID="locAgeLimitForRetention" runat="server" meta:resourcekey="locAgeLimitForRetention" Text="Age limit for retention :"></asp:Localize></td>
					            <td>
                                    <div class="Right">
                                        <uc1:QuotaEditor id="ageLimitForRetention" runat="server"
                                            QuotaTypeID="2"
                                            QuotaValue="0"
                                            ParentQuotaValue="-1"></uc1:QuotaEditor>
                                    </div>
					            </td>
				            </tr>
				            <tr>
					            <td class="FormLabel200" align="right"><asp:Localize ID="locRetentionAction" runat="server" meta:resourcekey="locRetentionAction" Text="Retention action :"></asp:Localize></td>
					            <td>
                                    <asp:DropDownList ID="ddRetentionAction" runat="server"></asp:DropDownList>
					            </td>
				            </tr>
			            </table>
			            <br />
		            </asp:Panel>


                    <table>
                        <tr>
                            <td>
                                <div class="FormButtonsBarClean">
                                    <asp:Button ID="btnAddPolicy" runat="server" meta:resourcekey="btnAddPolicy"
                                        Text="Add New" CssClass="Button1" OnClick="btnAddPolicy_Click" />
                                </div>
                            </td>
                            <td>
                                <div class="FormButtonsBarClean">
                                    <asp:Button ID="btnUpdatePolicy" runat="server" meta:resourcekey="btnUpdatePolicy"
                                        Text="Update" CssClass="Button1" OnClick="btnUpdatePolicy_Click" />
                            </td>
                            <td>
                                <div class="FormButtonsBarClean">
                                    <asp:Button ID="btnCancelPolicy" runat="server" meta:resourcekey="btnCancelPolicy"
                                        Text="Cancel" CssClass="Button1" OnClick="btnCancelPolicy_Click"/>
                            </td>
                        </tr>
                    </table>

                    <br />

                    <asp:TextBox ID="txtStatus" runat="server" CssClass="TextBox400" MaxLength="128" ReadOnly="true"></asp:TextBox>
   
                    
				</div>
			</div>
		</div>
	</div>
</div>                     