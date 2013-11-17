<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorage_Settings.ascx.cs" Inherits="WebsitePanel.Portal.ProviderControls.EnterpriseStorage_Settings" %>
<table cellpadding="1" cellspacing="0" width="100%">
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label ID="lblSpacesFolder" runat="server" meta:resourcekey="lblSpacesFolder" Text="User Packages Path:"></asp:Label>
        </td>
        <td width="100%">
            <asp:TextBox runat="server" ID="txtFolder" Width="300px" CssClass="NormalTextBox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valRequiredFolder" runat="server" ControlToValidate="txtFolder"
                ErrorMessage="*"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="valExpressionFolder"  runat="server"   ValidationExpression="[a-zA-Z]:\\((\w(\s)?)+(\\)?)+"  
                ControlToValidate="txtFolder"  ErrorMessage="*"></asp:RegularExpressionValidator>  
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label ID="lblDomain" runat="server" meta:resourcekey="lblDomain" Text="User domain:"></asp:Label>
        </td>
        <td width="100%">
            <asp:TextBox runat="server" ID="txtDomain" Width="300px" CssClass="NormalTextBox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valRequiredDomain" runat="server" ControlToValidate="txtDomain"
                ErrorMessage="*"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="valExpressionDomain"  runat="server"   ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?"  
                ControlToValidate="txtDomain"  ErrorMessage="*"></asp:RegularExpressionValidator>  
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap></td>
        <td width="100%">
            <table>
                <tr>
                    <td>
                        <asp:CheckBox runat="server" AutoPostBack="false" ID="chkEnableHardQuota" meta:resourcekey="chkEnableHardQuota" Text="Enable Hard Quota:" /></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label runat="server" ID="lblFileServiceInfo" Text="Install File Services role on the file server to enable the check box" Font-Italic="true" Visible="false"></asp:Label></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
