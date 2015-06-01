<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SendToControl.ascx.cs" Inherits="WebsitePanel.Portal.UserControls.SendToControl" %>


<table id="send-to-table">
    <tr>
        <td class="FormLabel150"></td>
        <td>
            <asp:CheckBox ID="chkSendPasswordResetEmail" runat="server" meta:resourcekey="chkSendPasswordResetEmail" Text="Send Password Request" AutoPostBack="true" OnCheckedChanged="chkSendPasswordResetEmail_StateChanged" />
        </td>
    </tr>
    <tbody id="SendToBody" runat="server" visible="False">
        <tr>
            <td class="FormLabel150">
                <asp:Localize ID="locSendTo" runat="server" meta:resourcekey="locSendTo" Text="Send to:"></asp:Localize></td>
            <td class="FormRBtnL">
                <asp:RadioButton ID="rbtnEmail" runat="server" meta:resourcekey="rbtnEmail" Text="Email" GroupName="SendToGroup" AutoPostBack="true" Checked="true" OnCheckedChanged="SendToGroupCheckedChanged" />
                <asp:RadioButton ID="rbtnMobile" runat="server" meta:resourcekey="rbtnMobile" Text="Mobile" GroupName="SendToGroup" AutoPostBack="true" OnCheckedChanged="SendToGroupCheckedChanged" />
                <br />
                <br />
            </td>
        </tr>
        <tr id="EmailRow" runat="server">
            <td class="FormLabel150" valign="top">
                <asp:Localize ID="locEmailAddress" runat="server" meta:resourcekey="locEmailAddress"></asp:Localize></td>
            <td>
                <asp:TextBox runat="server" ID="txtEmailAddress" CssClass="HugeTextBox200" />
                <asp:RequiredFieldValidator ID="valEmailAddress" runat="server" ErrorMessage="*" ControlToValidate="txtEmailAddress" ValidationGroup="ResetUserPassword"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="ResetUserPassword" ControlToValidate="txtEmailAddress" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr id="MobileRow" runat="server" visible="False">
            <td class="FormLabel150" valign="top">
                <asp:Localize ID="locMobile" runat="server" meta:resourcekey="locMobile"></asp:Localize></td>
            <td>
                <asp:TextBox runat="server" ID="txtMobile" CssClass="HugeTextBox200" />
                <asp:RequiredFieldValidator ID="valMobile" runat="server" ErrorMessage="*" ControlToValidate="txtMobile" ValidationGroup="ResetUserPassword"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="regexMobileValid" runat="server" ValidationExpression="^\+?\d+$" ValidationGroup="ResetUserPassword" ControlToValidate="txtMobile" ErrorMessage="Invalid Mobile Format"></asp:RegularExpressionValidator>
            </td>
        </tr>
    </tbody>
</table>


<div runat="server" id="divWrapper">
    <script language="javascript" type="text/javascript">
        $(document).ready(function() {
            $("#send-to-table input").live("click", function (e) {
                DisableProgressDialog();
            });
        });
    </script>
</div>