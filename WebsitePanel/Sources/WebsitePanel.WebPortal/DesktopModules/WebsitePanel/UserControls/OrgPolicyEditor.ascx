<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrgPolicyEditor.ascx.cs" Inherits="WebsitePanel.Portal.UserControls.OrgPolicyEditor" %>
<asp:UpdatePanel runat="server" ID="OrgPolicyPanel" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
        <asp:CheckBox id="enablePolicyCheckBox" runat="server" meta:resourcekey="enablePolicyCheckBox" Text="Enable Policy" CssClass="NormalBold" AutoPostBack="true" OnCheckedChanged="EnablePolicy_CheckedChanged"/>
        <table id="PolicyTable" runat="server" cellpadding="2">
            <tr>
                <td class="Normal" style="width:150px;">
                    <asp:Label ID="lblEnableDefaultGroups" runat="server" meta:resourcekey="lblEnableDefaultGroups" Text="Enable Default Groups:"/>
                </td>
                <td class="Normal">
                    <asp:CheckBox ID="chkEnableDefaultGroups" runat="server" CssClass="NormalTextBox" />
                </td>
            </tr>
        </table>
	</ContentTemplate>
</asp:UpdatePanel>