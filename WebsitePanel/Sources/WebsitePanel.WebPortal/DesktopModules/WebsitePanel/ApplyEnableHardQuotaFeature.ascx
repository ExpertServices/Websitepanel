<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ApplyEnableHardQuotaFeature.ascx.cs" Inherits="WebsitePanel.Portal.ApplyEnableHardQuotaFeature" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="messageBox" TagPrefix="uc4" %>

<div class="FormBody">
    <table cellspacing="0" cellpadding="4" width="100%">
        <tr>

            <td class="Normal">
                <uc4:messageBox id="messageBox" runat="server" >                   
                </uc4:messageBox>
            </td>
        </tr>
    </table>
    
</div>
<div class="FormFooter">
    <asp:Button ID="btnUpdate" runat="server" meta:resourcekey="btnUpdate" CssClass="Button1" Text="Apply" OnClick="btnUpdate_Click"></asp:Button>
    
</div>
