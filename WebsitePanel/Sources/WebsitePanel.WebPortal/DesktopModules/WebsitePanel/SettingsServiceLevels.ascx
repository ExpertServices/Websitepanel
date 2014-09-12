<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SettingsServiceLevels.ascx.cs" Inherits="WebsitePanel.Portal.SettingsServiceLevels" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Import Namespace="WebsitePanel.Portal" %>

    <wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>
    <wsp:SimpleMessageBox id="messageBox" runat="server" />
	<asp:GridView id="gvServiceLevels" runat="server"  EnableViewState="true" AutoGenerateColumns="false"
		Width="100%" EmptyDataText="gvServiceLevels" CssSelectorClass="NormalGridView" OnRowCommand="gvServiceLevels_RowCommand">
		<Columns>
            <asp:TemplateField HeaderText="Edit">
                <ItemTemplate>
                    <asp:ImageButton ID="cmdEdit" runat="server" SkinID="EditSmall" CommandName="EditItem" AlternateText="Edit record" CommandArgument='<%# Eval("LevelId") %>' ></asp:ImageButton>
                </ItemTemplate>
             </asp:TemplateField>
			<asp:TemplateField HeaderText="Service Level">
				<ItemStyle Width="30%"></ItemStyle>
				<ItemTemplate>
					<asp:Label id="lnkServiceLevel" runat="server" EnableViewState="true" ><%# PortalAntiXSS.Encode((string)Eval("LevelName"))%></asp:Label>
                 </ItemTemplate>
			</asp:TemplateField>
            <asp:TemplateField HeaderText="Description">
				<ItemStyle Width="60%"></ItemStyle>
				<ItemTemplate>
					<asp:Label id="lnkServiceLevelDescription" runat="server" EnableViewState="true" ><%# PortalAntiXSS.Encode((string)Eval("LevelDescription"))%></asp:Label>
                 </ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					&nbsp;<asp:ImageButton id="imgDelMailboxPlan" runat="server" Text="Delete" SkinID="ExchangeDelete"
						CommandName="DeleteItem" CommandArgument='<%# Eval("LevelId") %>' 
						meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected service level?')"></asp:ImageButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<br />

	<wsp:CollapsiblePanel id="secServiceLevel" runat="server"
        TargetControlID="ServiceLevel" meta:resourcekey="secServiceLevel" Text="Service Level">
    </wsp:CollapsiblePanel>
    <asp:Panel ID="ServiceLevel" runat="server" Height="0" style="overflow:hidden;">
		<table>
            <tr>
                <td class="FormLabel200" align="right">
                    <asp:Label ID="lblServiceLevelName" runat="server" meta:resourcekey="lblServiceLevelName" Text="Name:"></asp:Label>
                </td>
                <td class="Normal">
                    <asp:TextBox ID="txtServiceLevelName" runat="server" Width="100%" CssClass="NormalTextBox" MaxLength="255"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="valRequireServiceLevelName" runat="server" meta:resourcekey="valRequireServiceLevelName" ControlToValidate="txtServiceLevelName"
					ErrorMessage="Enter service level name" ValidationGroup="CreateServiceLevel" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="FormLabel200" align="right">
                    <asp:Label ID="lblServiceLevelDescr" runat="server" meta:resourcekey="lblServiceLevelDescr" Text="Description:"></asp:Label>
                </td>
                <td class="Normal" valign=top>
                    <asp:TextBox ID="txtServiceLevelDescr" runat="server" Rows="10" TextMode="MultiLine" Width="100%" CssClass="NormalTextBox" Wrap="False" MaxLength="511"></asp:TextBox></td>
            </tr>
		</table>
	</asp:Panel>
    <br />

    <table>
        <tr>
            <td>
                <div class="FormButtonsBarClean">
                    <asp:Button ID="btnAddServiceLevel" runat="server" meta:resourcekey="btnAddServiceLevel"
                        Text="Add New" CssClass="Button1" OnClick="btnAddServiceLevel_Click" />
                </div>
            </td>
            <td>
                <div class="FormButtonsBarClean">
                        <asp:Button ID="btnUpdateServiceLevel" runat="server" meta:resourcekey="btnUpdateServiceLevel"
                            Text="Update" CssClass="Button1" OnClick="btnUpdateServiceLevel_Click" />
            </td>
        </tr>
    </table>
    <br />

    <asp:TextBox ID="txtStatus" runat="server" CssClass="TextBox400" MaxLength="128" ReadOnly="true"></asp:TextBox>
    