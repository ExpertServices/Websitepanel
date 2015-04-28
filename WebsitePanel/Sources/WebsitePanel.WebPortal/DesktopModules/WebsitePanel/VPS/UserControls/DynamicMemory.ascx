<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DynamicMemory.ascx.cs" Inherits="WebsitePanel.Portal.VPS.UserControls.DynamicMemory" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../../UserControls/CollapsiblePanel.ascx" %>

<wsp:CollapsiblePanel id="secDymanicMemory" runat="server" TargetControlID="DymanicMemoryPanel" meta:resourcekey="secDymanicMemory" Text="Dymanic memory">
</wsp:CollapsiblePanel>
<asp:Panel ID="DymanicMemoryPanel" runat="server" Height="0" Style="overflow: hidden; padding: 5px;">
    <table>
        <tr>
            <td class="FormLabel150">
                <asp:Localize ID="locDymanicMemory" runat="server"
                    meta:resourcekey="locDymanicMemory" Text="Dymanic Memory:"></asp:Localize></td>
            <td>
                
            </td>
        </tr>
    </table>
</asp:Panel>
