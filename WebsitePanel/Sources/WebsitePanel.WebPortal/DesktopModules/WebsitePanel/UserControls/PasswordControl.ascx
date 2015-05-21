<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordControl.ascx.cs" Inherits="WebsitePanel.Portal.PasswordControl" %>
<script src="<%= GetRandomPasswordUrl() %>" language="javascript" type="text/javascript"></script>
<table cellpadding="0" cellspacing="0">
    <tr>
        <td class="Normal">
            <asp:TextBox ID="txtPassword" runat="server" CssClass="NormalTextBox" Width="150px" TextMode="Password" MaxLength="50"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valRequirePassword" runat="server" meta:resourcekey="valRequirePassword"
                ErrorMessage="*" ControlToValidate="txtPassword" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:HyperLink ID="lnkGenerate" runat="server" NavigateUrl="#" meta:resourcekey="lnkGenerate" Visible="false">Generate random</asp:HyperLink></td>
    </tr>
    <tr>
        <td class="SubHead">
            <asp:Label ID="lblConfirmPassword" runat="server" meta:resourcekey="lblConfirmPassword"></asp:Label></td>
    </tr>
    <tr>
        <td class="Normal">
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="NormalTextBox" Width="150px" TextMode="Password" MaxLength="50"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valRequireConfirmPassword" runat="server"
                meta:resourcekey="valRequireConfirmPassword" ErrorMessage="*" ControlToValidate="txtConfirmPassword" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="valRequireEqualPassword" runat="server" ControlToCompare="txtPassword"
                ControlToValidate="txtConfirmPassword" meta:resourcekey="valRequireEqualPassword" Display="Dynamic" ErrorMessage="*"></asp:CompareValidator>

            <asp:CustomValidator ID="valCorrectLength" runat="server"
                ControlToValidate="txtPassword" ErrorMessage="len" Display="Dynamic" Enabled="false"
                ClientValidationFunction="wspValidatePasswordLength" OnServerValidate="valCorrectLength_ServerValidate"></asp:CustomValidator>
            <asp:CustomValidator ID="valRequireNumbers" runat="server"
                ControlToValidate="txtPassword" ErrorMessage="num" Display="Dynamic" Enabled="false"
                ClientValidationFunction="wspValidatePasswordNumbers" OnServerValidate="valRequireNumbers_ServerValidate"></asp:CustomValidator>
            <asp:CustomValidator ID="valRequireUppercase" runat="server"
                ControlToValidate="txtPassword" ErrorMessage="upp" Display="Dynamic" Enabled="false"
                ClientValidationFunction="wspValidatePasswordUppercase" OnServerValidate="valRequireUppercase_ServerValidate"></asp:CustomValidator>
            <asp:CustomValidator ID="valRequireSymbols" runat="server"
                ControlToValidate="txtPassword" ErrorMessage="sym" Display="Dynamic" Enabled="false"
                ClientValidationFunction="wspValidatePasswordSymbols" OnServerValidate="valRequireSymbols_ServerValidate"></asp:CustomValidator>
        </td>
    </tr>
</table>


<% if (ValidationEnabled)
   {%>
<div style="display: none;" id="password-hint-popup">
    <h3 class="popover-title">
        Password must meet the following requirements:
    </h3>
    <ul class="popover-content">

        <li><%= string.Format("Password should be at least {0} characters", MinimumLength) %>
        </li>
        <li><%= string.Format("Password should be maximum {0} characters", MaximumLength) %>
        </li>

        <% if (MinimumUppercase > 0)
           {%>
        <li><%= string.Format("Password should contain at least {0} UPPERCASE characters", MinimumUppercase) %>
        </li>
        <% }%>
        <% if (MinimumNumbers > 0)
           {%>
        <li><%= string.Format("Password should contain at least {0} numbers", MinimumNumbers) %>
        </li>
        <% }%>
        <% if (MinimumSymbols > 0)
           {%>
        <li><%= string.Format("Password should contain at least {0} non-alphanumeric symbols", MinimumSymbols) %>
        </li>
        <% }%>
    </ul>
</div>
<% }%>


<script>
   
    $(document).ready(function () {
        $('#<%=txtPassword.ClientID%>').poshytip({
            className: 'tip-bluesimple',
            showOn: 'focus',
            alignTo: 'target',
            alignX: 'center',
            alignY: 'bottom',
            offsetX: 2,
            content: function () {
                return $('#password-hint-popup').html();
            }
        });
    });
</script>
