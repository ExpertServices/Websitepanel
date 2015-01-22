<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSCollectionTabs.ascx.cs" Inherits="WebsitePanel.Portal.RDS.UserControls.RdsServerTabs" %>
<table width="100%" cellpadding="0" cellspacing="1">
    <tr>
        <td class="Tabs">                 
            <asp:DataList ID="rdsTabs" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" EnableViewState="false">
                <ItemStyle Wrap="False" />
                <ItemTemplate >
                    <asp:HyperLink ID="lnkTab" runat="server" CssClass="Tab" NavigateUrl='<%# Eval("Url") %>'>
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </ItemTemplate>
                <SelectedItemStyle Wrap="False" />
                <SelectedItemTemplate>
                    <asp:HyperLink ID="lnkSelTab" runat="server" CssClass="ActiveTab" NavigateUrl='<%# Eval("Url") %>'>
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </SelectedItemTemplate>                
            </asp:DataList>
        </td>
    </tr>
</table>
<br />