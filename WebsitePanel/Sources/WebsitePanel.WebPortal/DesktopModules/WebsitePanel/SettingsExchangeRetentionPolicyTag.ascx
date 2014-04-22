<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SettingsExchangeRetentionPolicyTag.ascx.cs" Inherits="WebsitePanel.Portal.SettingsExchangeRetentionPolicyTag" %>
<%@ Register Src="ExchangeServer/UserControls/SizeBox.ascx" TagName="SizeBox" TagPrefix="wsp" %>
<%@ Register Src="ExchangeServer/UserControls/DaysBox.ascx" TagName="DaysBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/QuotaEditor.ascx" TagName="QuotaEditor" TagPrefix="uc1" %>
<%@ Import Namespace="WebsitePanel.Portal" %>

    <wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>
    <wsp:SimpleMessageBox id="messageBox" runat="server" />
	<asp:GridView id="gvPolicy" runat="server"  EnableViewState="true" AutoGenerateColumns="false"
		Width="100%" EmptyDataText="gvPolicy" CssSelectorClass="NormalGridView" OnRowCommand="gvPolicy_RowCommand" >
		<Columns>
            <asp:TemplateField HeaderText="Edit">
                <ItemTemplate>
                    <asp:ImageButton ID="cmdEdit" runat="server" SkinID="EditSmall" CommandName="EditItem" AlternateText="Edit record" CommandArgument='<%# Eval("TagId") %>' ></asp:ImageButton>
                </ItemTemplate>
             </asp:TemplateField>
			<asp:TemplateField HeaderText="Tag">
				<ItemStyle Width="70%"></ItemStyle>
				<ItemTemplate>
					<asp:Label id="lnkDisplayPolicy" runat="server" EnableViewState="true" ><%# PortalAntiXSS.Encode((string)Eval("TagName"))%></asp:Label>
                 </ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					&nbsp;<asp:ImageButton id="imgDelPolicy" runat="server" Text="Delete" SkinID="ExchangeDelete"
						CommandName="DeleteItem" CommandArgument='<%# Eval("TagId") %>' 
						meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected policy tag?')"></asp:ImageButton>
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
						<asp:TextBox ID="txtPolicy" runat="server" CssClass="TextBox200" 
                            ontextchanged="txtPolicy_TextChanged" ></asp:TextBox>
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
                                ParentQuotaValue="-1">
                            </uc1:QuotaEditor>
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
        </tr>
    </table>

    <br />

    <asp:TextBox ID="txtStatus" runat="server" CssClass="TextBox400" MaxLength="128" ReadOnly="true"></asp:TextBox>
    