<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WebSitesEditHeliconApeFolder.ascx.cs"
	Inherits="WebsitePanel.Portal.WebSitesEditHeliconApeFolder" %>
<%@ Register Src="UserControls/FileLookup.ascx" TagName="FileLookup" TagPrefix="uc1" %>
<%@ Register Src="UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>
<link rel="stylesheet" href="/JavaScript/codemirror/codemirror.css" />
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>
<script type="text/javascript" src="/JavaScript/codemirror/codemirror.js"></script>
<script type="text/javascript" src="/JavaScript/codemirror/htaccess.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('.LinkDebuggingPage').click(function () {
            //$find('').hide();
            return true;
        });
    });
</script>
<style type="text/css">
.CodeMirror {
    border: 1px solid #444;
    padding: 2px;
    font-family: Consolas, monospace;
    font-size: 14px;
}
</style>
<div class="FormBody">
<table cellspacing="0" cellpadding="5" width="100%">
	<tr>
		<td class="SubHead" style="white-space: nowrap;">
			<asp:Label ID="lblFolderName" runat="server" meta:resourcekey="lblFolderName"></asp:Label>
		</td>
		<td class="NormalBold" style="white-space: nowrap;">
		    <asp:Label runat="server" ID="LabelWebSiteName"></asp:Label>

			<uc1:FileLookup id="folderPath" runat="server" Width="400">
			</uc1:FileLookup>
			<asp:HiddenField ID="contentPath" runat="server" />
			<asp:HiddenField ID="DebuggerUrlField" runat="server" />
		</td>
        <td style="width: 40%">
            <asp:Button ID="ButtonDebuggerStart" runat="server" Text="Start Debugging" meta:resourcekey="btnApeDebuggerStart"
				CssClass="Button1" OnClick="DebugStartClick"  />
            <asp:Button ID="ButtonDebuggerStop" runat="server" Text="Stop Debugging" meta:resourcekey="btnApeDebuggerStop"
				CssClass="Button1" OnClick="DebugStopClick"  />
            <asp:Button ID="BUttonShowDebuggingPageLinkModal" runat="server" Text="Show debugging page link" meta:resourcekey="btnShowDebuggingPageLinkModal"
				CssClass="Button1 Hidden"  />
        </td>
	</tr>
</table>

<asp:Panel runat="server" ID="DebuggerFramePanel" Visible="False">
    <iframe runat="server" ID="DebuggerFrame" width="100%" height="400px"></iframe>
</asp:Panel>

<asp:TextBox ID="htaccessContent" runat="server" TextMode="MultiLine" class="CodeEditor"></asp:TextBox>

</div>

<div class="FormFooter">
	<asp:Button ID="btnUpdate" runat="server" Text="Update" meta:resourcekey="btnUpdate"
		CssClass="Button1" OnClick="btnUpdate_Click" />
	<asp:Button ID="btnSave" runat="server" Text="Save and continue editing" meta:resourcekey="btnSave"
		CssClass="Button1" OnClick="btnSave_Click" />
	<asp:Button ID="btnCancel" runat="server" Text="Cancel" meta:resourcekey="btnCancel"
		CssClass="Button1" CausesValidation="false" OnClick="BtnCancelClick" />
</div>

<asp:Panel ID="DebuggingPageLinkPanel" runat="server" CssClass="PopupContainer" style="display:none" DefaultButton="btnCancelDebuggingPageLinkPanel">
	<wsp:PopupHeader runat="server" meta:resourcekey="lblDebuggingPageLink" Text="Debugging Page Link" />
	<div class="Content">
		<div class="Body">
			<br />
			<div class="FormRow">
				<asp:Label ID="LabelClickLink" runat="server" meta:resourcekey="lblCLickLink" Text="Click this link to open debugging page"></asp:Label>:
                <br/>
                <br/>
				<asp:HyperLink runat="server" ID="LinkDebuggingPage" Target="ape-debugging-page" CssClass="LinkDebuggingPage"></asp:HyperLink>
			</div>
			<br />
		</div>
		<div class="FormFooter">
            <asp:Button ID="btnCancelDebuggingPageLinkPanel" runat="server" CssClass="Button1" meta:resourcekey="btnClose" Text="Close" CausesValidation="false" />
		</div>
	</div>
</asp:Panel>

<ajaxToolkit:ModalPopupExtender ID="DebuggingPageLinkModal" runat="server"
    PopupControlID="DebuggingPageLinkPanel" TargetControlID="BUttonShowDebuggingPageLinkModal"
    BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelDebuggingPageLinkPanel" />


<script>
    $(document).ready(function() {
        CodeMirror.fromTextArea(($('.CodeEditor')[0]),
            {
                lineNumbers: true,
                autofocus: true
            });
    });
</script>
