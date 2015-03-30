<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HyperV2012R2_Create.ascx.cs" Inherits="WebsitePanel.Portal.ProviderControls.HyperV2012R2_Create" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../../UserControls/CollapsiblePanel.ascx" %>

<wsp:CollapsiblePanel id="secGeneration" runat="server" TargetControlID="GenerationPanel" meta:resourcekey="secGeneration" Text="Generation">
</wsp:CollapsiblePanel>
<asp:Panel ID="GenerationPanel" runat="server" Height="0" Style="overflow: hidden; padding: 5px;">
    <table>
        <tr>
            <td class="FormLabel150">
                <asp:Localize ID="locGeneration" runat="server"
                    meta:resourcekey="locGeneration" Text="Generation:"></asp:Localize></td>
            <td>
                <asp:DropDownList ID="ddlGeneration" runat="server" CssClass="NormalTextBox" resourcekey="ddlGeneration">
                    <asp:ListItem Value="1">1</asp:ListItem>
                    <asp:ListItem Value="2">2</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
    </table>
</asp:Panel>
