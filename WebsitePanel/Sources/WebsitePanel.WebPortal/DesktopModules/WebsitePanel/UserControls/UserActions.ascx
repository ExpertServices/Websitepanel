<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserActions.ascx.cs" Inherits="WebsitePanel.Portal.UserActions" %>
<script language="javascript">
    $(function () {
        $("#<%= ddlUserActions.ClientID %>").change(function () {
            if (!confirm("Are you sure you wish to perform the action for the all selected users?")) {
                $(this).val(0);
                return;
            } else {
                setTimeout('__doPostBack(\'\',\'\')', 0);
            }
        });
    });
</script>
<asp:Panel ID="tblActions" runat="server" CssClass="NormalBold">
    <asp:DropDownList ID="ddlUserActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlUserActions" style="vertical-align: middle;">
         <asp:ListItem Value="0">Actions</asp:ListItem>
         <asp:ListItem Value="1">Disable</asp:ListItem>
         <asp:ListItem Value="2">Enable</asp:ListItem>
    </asp:DropDownList>
</asp:Panel>