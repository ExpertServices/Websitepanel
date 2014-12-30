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
    <tr>
        <td class="SubHead" width="200" nowrap valign="top">
            <asp:Localize ID="locGWServers" runat="server" meta:resourcekey="locGWServers"
                Text="Gateway Servers:"></asp:Localize>
        </td>
        <td>
            <asp:TextBox runat="server" ID="txtAddGWServer" MaxLength="1000" Width="200px"  />  
            <asp:Button runat="server" ID="btnAddGWServer" OnClick="btnAddGWServer_Click" meta:resourcekey="btnAdd"
                CssClass="Button1" /><br />
            <asp:GridView ID="gvGWServers" runat="server" AutoGenerateColumns="False" EmptyDataText="gvRecords"
                CssSelectorClass="NormalGridView" OnRowCommand="gvGWServers_RowCommand" meta:resourcekey="gvGWServers">
                <Columns>
                    <asp:TemplateField meta:resourcekey="ServerNameColumn" ItemStyle-Width="100%" >
                        <ItemTemplate>
                            <asp:Label runat="server" ID="lblServerName" Text='<%#Eval("ServerName")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="cmdDelete" runat="server" SkinID="DeleteSmall" CommandName="RemoveServer"
                                CommandArgument='<%#Eval("ServerName") %>' meta:resourcekey="cmdDelete" AlternateText="Delete"
                                OnClientClick="return confirm('Delete?');"></asp:ImageButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
</table>