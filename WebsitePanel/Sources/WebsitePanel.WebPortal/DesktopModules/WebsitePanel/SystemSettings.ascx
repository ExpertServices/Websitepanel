<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SystemSettings.ascx.cs" Inherits="WebsitePanel.Portal.SystemSettings" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>
<%@ Register src="UserControls/EditFeedsList.ascx" tagname="EditFeedsList" tagprefix="uc1" %>
<div class="FormBody">
	<wsp:CollapsiblePanel id="lclSmtpSettings" runat="server"
		TargetControlID="SmtpPanel" meta:resourcekey="lclSmtpSettings" Text="SMTP Server"/>
	<asp:Panel ID="SmtpPanel" runat="server" Height="0" style="overflow:hidden;">
		<table>
			<tr>
				<td class="SubHead" style="width:200px;"><asp:Localize runat="server" meta:resourcekey="lclSmtpServer" /></td>
				<td><asp:TextBox runat="server" ID="txtSmtpServer" Width="250px" /></td>
			</tr>
			<tr>
				<td class="SubHead"><asp:Localize runat="server" meta:resourcekey="lclSmtpPort" /></td>
				<td><asp:TextBox runat="server" ID="txtSmtpPort" Width="80px" /></td>
			</tr>
			<tr>
				<td class="SubHead"><asp:Localize runat="server" meta:resourcekey="lclSmtpUser" /></td>
				<td><asp:TextBox runat="server" ID="txtSmtpUser" Width="250px" /></td>
			</tr>
			<tr>
				<td class="SubHead"><asp:Localize runat="server" meta:resourcekey="lclSmtpPassword" /></td>
				<td><asp:TextBox runat="server" ID="txtSmtpPassword" TextMode="Password" Width="250px" /></td>
			</tr>
			<tr>
				<td class="SubHead"><asp:Localize ID="locEnableSsl" runat="server" meta:resourcekey="locEnableSsl" /></td>
				<td class="Normal">
					<asp:CheckBox ID="chkEnableSsl" runat="server" Text="Yes" meta:resourcekey="chkEnableSsl" />
				</td>
			</tr>
		</table>
	</asp:Panel>
	<wsp:CollapsiblePanel id="lclBackupSettings" runat="server"
		TargetControlID="BackupPanel" meta:resourcekey="lclBackupSettings" Text="Backup Settings"/>
	<asp:Panel ID="BackupPanel" runat="server" Height="0" style="overflow:hidden;">
		<table>
			<tr>
				<td class="SubHead" style="width:200px;"><asp:Localize ID="Localize1" runat="server" meta:resourcekey="lclBackupFolderPath" /></td>
				<td><asp:TextBox runat="server" ID="txtBackupsPath" Width="300px" /></td>
			</tr>
		</table>
	</asp:Panel>

    <wsp:CollapsiblePanel id="lclWpiSettings" runat="server"
		TargetControlID="WpiPanel" meta:resourcekey="lclWpiSettings" Text="WebPlatformInstaller Settings"/>
	<asp:Panel ID="WpiPanel" runat="server" Height="0" style="overflow:hidden;">
       <asp:CheckBox ID="wpiMicrosoftFeed" runat="server" Text="Yes" Visible="false"/>
       <asp:CheckBox ID="wpiHeliconTechFeed" runat="server" Text="Yes" Visible="false" />
<%--     <table> 
			<tr>
				<td class="SubHead" style="width:200px;">Enable Microsoft feed</td>
				<td class="Normal">
                    <asp:CheckBox ID="wpiMicrosoftFeed" runat="server" Text="Yes" Visible="false"/>
                </td>
			</tr>
			
            <tr>
		        <td class="SubHead" style="width:200px;">Enable HeliconTech feed</td>
                <td class="Normal">
                    <asp:CheckBox ID="wpiHeliconTechFeed" runat="server" Text="Yes" Visible="false" />
                </td>
            </tr>
	  </table>
--%>
        <uc1:EditFeedsList ID="wpiEditFeedsList" runat="server" DisplayNames="false" />
	</asp:Panel>
</div>
<div class="FormFooter">
	<asp:Button runat="server" ID="btnSaveSettings" meta:resourcekey="btnSaveSettings" 
		CssClass="Button1" OnClick="btnSaveSettings_Click" />
</div>