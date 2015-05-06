<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WebsiteActions.ascx.cs" Inherits="WebsitePanel.Portal.WebsiteActions" %>

<script language="javascript">
    function ShowProgress(btn) {
        var action = $(btn).prev().val();

        if (action === 1) {
            ShowProgressDialog("Stopping websites...");
        } else if (action == 2) {
            ShowProgressDialog("Starting websites...");
        } else if (action == 3) {
            ShowProgressDialog("Restarting App Pools...");
        }
    }
</script>
<asp:UpdatePanel ID="tblActions" runat="server" CssClass="NormalBold" UpdateMode="Conditional" ChildrenAsTriggers="true" >
    <ContentTemplate>

        <asp:DropDownList ID="ddlWebsiteActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlWebsiteActions" AutoPostBack="True">
            <asp:ListItem Value="0">Actions</asp:ListItem>
            <asp:ListItem Value="1">Stop</asp:ListItem>
            <asp:ListItem Value="2">Start</asp:ListItem>
            <asp:ListItem Value="3">RestartAppPool</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="btnApply" runat="server" meta:resourcekey="btnApply"
        Text="Apply" CssClass="Button1" OnClick="btnApply_Click" OnClientClick="return ShowProgress(this);" />

    </ContentTemplate>
    
    <Triggers>
        <asp:PostBackTrigger ControlID="btnApply" />
    </Triggers>
</asp:UpdatePanel>
