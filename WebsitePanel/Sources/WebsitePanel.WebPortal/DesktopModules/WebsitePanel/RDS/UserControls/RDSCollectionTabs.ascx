<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSCollectionTabs.ascx.cs" Inherits="WebsitePanel.Portal.RDS.UserControls.RdsServerTabs" %>
<table width="100%" cellpadding="0" cellspacing="1">
    <tr>
        <td class="Tabs">                 
            <asp:DataList ID="rdsTabs" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" EnableViewState="false">
                <ItemStyle Wrap="False" />
                <ItemTemplate >
                    <asp:HyperLink ID="lnkTab" runat="server" CssClass="Tab" style="padding:10px 15px;" NavigateUrl='<%# Eval("Url") %>' OnClick="return tabClicked();">
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </ItemTemplate>
                <SelectedItemStyle Wrap="False" />
                <SelectedItemTemplate>
                    <asp:HyperLink ID="lnkSelTab" runat="server" CssClass="ActiveTab" style="padding:10px 15px;" NavigateUrl='<%# Eval("Url") %>' OnClick="return tabClicked;">
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </SelectedItemTemplate>                
            </asp:DataList>
        </td>
    </tr>
</table>
<br />

<script type="text/javascript">
    function tabClicked() {
        ShowProgressDialog('Loading');
        ShowProgressDialogInternal();
        return true;
    }
</script>