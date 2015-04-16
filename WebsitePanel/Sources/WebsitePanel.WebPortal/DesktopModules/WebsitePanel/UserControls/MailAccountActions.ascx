<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MailAccountActions.ascx.cs" Inherits="WebsitePanel.Portal.MailAccountActions" %>

<script language="javascript">
    function ShowProgress(btn) {
        var action = $(btn).prev().val();

        if (action === 1) {
            ShowProgressDialog("Enabling mail account...");
        } else if (action === 2) {
            ShowProgressDialog("Disabling mail account...");
        }
    }
</script>
<asp:UpdatePanel ID="tblActions" runat="server" CssClass="NormalBold" UpdateMode="Conditional" ChildrenAsTriggers="true" >
    <ContentTemplate>

        <asp:DropDownList ID="ddlMailAccountActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlWebsiteActions" AutoPostBack="True">
            <asp:ListItem Value="0">Actions</asp:ListItem>
            <asp:ListItem Value="1">Disable</asp:ListItem>
            <asp:ListItem Value="2">Enable</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="btnApply" runat="server" meta:resourcekey="btnApply"
        Text="Apply" CssClass="Button1" OnClick="btnApply_Click" OnClientClick="return ShowProgress(this);" />

    </ContentTemplate>
    
    <Triggers>
        <asp:PostBackTrigger ControlID="btnApply" />
    </Triggers>
</asp:UpdatePanel>
