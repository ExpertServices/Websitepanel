<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDS_Settings.ascx.cs" Inherits="WebsitePanel.Portal.ProviderControls.RDS_Settings" %>
<table>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblConnectionBroker" meta:resourcekey="lblConnectionBroker" Text="Connection Broker:"/>
        </td>
        <td>                        
            <asp:TextBox runat="server" ID="txtConnectionBroker" MaxLength="1000" Width="200px"  />            
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtConnectionBroker" Display="Dynamic" ErrorMessage="*" />
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblGateway" meta:resourcekey="lblGateway" Text="Gateway Servers:"/>
        </td>
        <td>                        
            <asp:TextBox runat="server" ID="txtGateway" MaxLength="1000" Width="200px"  />            
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtGateway" Display="Dynamic" ErrorMessage="*" />
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblRootOU" meta:resourcekey="lblRootOU" Text="Root OU:"/>
        </td>
        <td class="Normal">
            <asp:TextBox runat="server" ID="txtRootOU" MaxLength="1000" Width="200px" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtRootOU" ErrorMessage="*" Display="Dynamic" />
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblPrimaryDomainController" meta:resourcekey="lblPrimaryDomainController" Text="Primary Domain Controller:"/>
        </td>
        <td class="Normal">
            <asp:TextBox runat="server" ID="txtPrimaryDomainController" MaxLength="1000" Width="200px"/>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtPrimaryDomainController" ErrorMessage="*" Display="Dynamic" />
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblUseCentralNPS" meta:resourcekey="lblUseCentralNPS" Text="Use Central NPS:"/>
        </td>
        <td class="Normal">
            <asp:CheckBox runat="server" ID="chkUseCentralNPS" meta:resourcekey="chkUseCentralNPS" OnCheckedChanged="chkUseCentralNPS_CheckedChanged" AutoPostBack="True" />
        </td>
    </tr>
    <tr>
        <td class="SubHead" width="200" nowrap>
            <asp:Label runat="server" ID="lblCentralNPS" meta:resourcekey="lblCentralNPS" MaxLength="1000" Text="Central NPS:"/>
        </td>
        <td class="Normal">
            <asp:TextBox runat="server" ID="txtCentralNPS" Width="200px"/>
        </td>
    </tr>
</table>