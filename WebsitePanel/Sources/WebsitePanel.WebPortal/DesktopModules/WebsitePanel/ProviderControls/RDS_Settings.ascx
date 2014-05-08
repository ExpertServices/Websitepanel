<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDS_Settings.ascx.cs" Inherits="WebsitePanel.Portal.ProviderControls.RDS_Settings" %>
<table>
    <tr>
        <td class="SubHead" width="150" nowrap>
            <asp:Label runat="server" ID="lblUsersHome" meta:resourcekey="lblUsersHome" Text="Users Home:"/>
        </td>
        <td>                        
            <asp:TextBox runat="server" ID="txtUsersHome" MaxLength="256" Width="200px"  />            
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUsersHome" Display="Dynamic" ErrorMessage="*" />
        </td>
    </tr>
</table>