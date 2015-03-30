<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SettingsRdsPolicy.ascx.cs" Inherits="WebsitePanel.Portal.SettingsRdsPolicy" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>

<wsp:CollapsiblePanel id="secTimeout" runat="server" TargetControlID="timeoutPanel" meta:resourcekey="secTimeout" Text="Lock Screen Timeout"/>
<asp:Panel ID="timeoutPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>            
            <td colspan="2">
                <asp:TextBox ID="txtTimeout" runat="server" CssClass="TextBox200" ></asp:TextBox>                
            </td>            
        </tr>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbTimeoutUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbTimeoutAdministrators" Checked="false" />
            </td>
        </tr>
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secRunCommand" runat="server" TargetControlID="runCommandPanel" meta:resourcekey="secRunCommand" Text="Remove Run Command"/>
<asp:Panel ID="runCommandPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbRunCommandUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbRunCommandAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secPowershellCommand" runat="server" TargetControlID="powershellCommandPanel" meta:resourcekey="secPowershellCommand" Text="Remove Powershell Command"/>
<asp:Panel ID="powershellCommandPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbPowershellUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbPowershellAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secHideCDrive" runat="server" TargetControlID="hideCDrivePanel" meta:resourcekey="secHideCDrive" Text="Hide C: Drive"/>
<asp:Panel ID="hideCDrivePanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbHideCDriveUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbHideCDriveAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secShutdown" runat="server" TargetControlID="shutdownPanel" meta:resourcekey="secShutdown" Text="Remove Shutdown and Restart"/>
<asp:Panel ID="shutdownPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbShutdownUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbShutdownAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secTaskManager" runat="server" TargetControlID="taskManagerPanel" meta:resourcekey="secTaskManager" Text="Disable Task Manager"/>
<asp:Panel ID="taskManagerPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbTaskManagerUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbTaskManagerAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secChangeDesktop" runat="server" TargetControlID="desktopPanel" meta:resourcekey="secChangeDesktop" Text="Changing Desktop Disabled"/>
<asp:Panel ID="desktopPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbDesktopUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbDesktopAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secScreenSaver" runat="server" TargetControlID="screenSaverPanel" meta:resourcekey="secScreenSaver" Text="Disable Screen Saver"/>
<asp:Panel ID="screenSaverPanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>
            <td>
                <asp:CheckBox runat="server" Text="Users" ID="cbScreenSaverUsers" meta:resourcekey="cbUsers" Checked="false" />
            </td>
            <td>
                <asp:CheckBox runat="server" Text="Administrators" meta:resourcekey="cbAdministrators" ID="cbScreenSaverAdministrators" Checked="false" />
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>
<wsp:CollapsiblePanel id="secDriveSpace" runat="server" TargetControlID="driveSpacePanel" meta:resourcekey="secDriveSpace" Text="Drive Space Threshold"/>
<asp:Panel ID="driveSpacePanel" runat="server" Height="0" style="overflow:hidden;">
    <table>
        <tr>            
            <td colspan="2">
                <asp:TextBox ID="txtThreshold" runat="server" CssClass="TextBox200" ></asp:TextBox>                
            </td>           
        </tr>        
    </table>
    <br />
</asp:Panel>