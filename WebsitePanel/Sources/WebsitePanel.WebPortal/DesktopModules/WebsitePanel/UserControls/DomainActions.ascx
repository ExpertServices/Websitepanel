<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DomainActions.ascx.cs" Inherits="WebsitePanel.Portal.DomainActions" %>

<script language="javascript">
    function ShowProgress(btn) {
        var action = $(btn).prev().val();

        if (action === 1) {
            ShowProgressDialog("Enabling Dns...");
        } else if (action == 2) {
            ShowProgressDialog("Disabling Dns...");
        } else if (action == 3) {
            ShowProgressDialog("Creating Instant Alias...");
        } else if (action == 4) {
            ShowProgressDialog("Removing Instant Alias...");
        }
    }
</script>
<asp:UpdatePanel ID="tblActions" runat="server" CssClass="NormalBold" UpdateMode="Conditional" ChildrenAsTriggers="true" >
    <ContentTemplate>

        <asp:DropDownList ID="ddlDomainActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlDomainActions" AutoPostBack="True">
            <asp:ListItem Value="0">Actions</asp:ListItem>
            <asp:ListItem Value="1">EnableDns</asp:ListItem>
            <asp:ListItem Value="2">DisableDns</asp:ListItem>
            <asp:ListItem Value="3">CreateInstantAlias</asp:ListItem>
            <asp:ListItem Value="4">DeleteInstantAlias</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="btnApply" runat="server" meta:resourcekey="btnApply"
            Text="Apply" CssClass="Button1" OnClick="btnApply_Click" OnClientClick="return ShowProgress(this);" />

    </ContentTemplate>
    
    <Triggers>
        <asp:PostBackTrigger ControlID="btnApply" />
    </Triggers>
</asp:UpdatePanel>
