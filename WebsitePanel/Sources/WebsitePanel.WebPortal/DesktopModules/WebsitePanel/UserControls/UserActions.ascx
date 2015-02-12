<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserActions.ascx.cs" Inherits="WebsitePanel.Portal.UserActions" %>
<%@ Register Src="../ExchangeServer/UserControls/MailboxPlanSelector.ascx" TagName="MailboxPlanSelector" TagPrefix="wsp" %>

<script language="javascript">
    function CloseAndShowProgressDialog(text) {
        $(".Popup").hide();
        return ShowProgressDialog(text);
    }

    function ShowProrgess(btn) {
        var action = $(btn).prev().val();

        if (action == 1) {
            ShowProgressDialog('Disabling users...');
        } else if (action == 2) {
            ShowProgressDialog('Enabling users...');
        } else if (action == 4) {
            ShowProgressDialog('Setting VIP...');
        } else if (action == 5) {
            ShowProgressDialog('Unsetting VIP...');
        }
    }
</script>
<asp:UpdatePanel ID="tblActions" runat="server" CssClass="NormalBold" UpdateMode="Conditional" ChildrenAsTriggers="true" >
    <ContentTemplate>

        <asp:DropDownList ID="ddlUserActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlUserActions" 
            AutoPostBack="True">
            <asp:ListItem Value="0">Actions</asp:ListItem>
            <asp:ListItem Value="1">Disable</asp:ListItem>
            <asp:ListItem Value="2">Enable</asp:ListItem>
            <asp:ListItem Value="3">SetServiceLevel</asp:ListItem>
            <asp:ListItem Value="4">SetVIP</asp:ListItem>
            <asp:ListItem Value="5">UnsetVIP</asp:ListItem>
            <asp:ListItem Value="6">SetMailboxPlan</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="btnApply" runat="server" meta:resourcekey="btnApply"
        Text="Apply" CssClass="Button1" OnClick="btnApply_Click" OnClientClick="return ShowProrgess(this);" />

        
        <ajaxToolkit:ModalPopupExtender ID="Modal" runat="server" EnableViewState="true" TargetControlID="FakeModalPopupTarget"
             PopupControlID="FakeModalPopupTarget" BackgroundCssClass="modalBackground" DropShadow="false" />
        
        <%--Set Service Level--%>
        <asp:Panel ID="ServiceLevelPanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle"><asp:Localize ID="headerServiceLevel" runat="server" meta:resourcekey="headerServiceLevel"></asp:Localize></td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br/>
                    <asp:Literal ID="litServiceLevel" runat="server" meta:resourcekey="litServiceLevel"></asp:Literal>
                    <br/>
                    <asp:DropDownList ID="ddlServiceLevels" runat="server" CssClass="NormalTextBox" />
                    <br/>
                </div>
                <div class="FormFooterMiddle">
                    <asp:Button ID="btnServiceLevelOk" runat="server" CssClass="Button1" meta:resourcekey="btnServiceLevelOk" Text="Ok" 
                        OnClientClick="return CloseAndShowProgressDialog('Setting Service Level...')" OnClick="btnModalOk_Click" />
                    <asp:Button ID="btnServiceLevelCancel" runat="server" CssClass="Button1" meta:resourcekey="btnServiceLevelCancel" Text="Cancel"
                        OnClick="btnModalCancel_OnClick" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <%--Set MailboxPlan--%>
        <asp:Panel ID="MailboxPlanPanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle"><asp:Localize ID="headerMailboxPlanLabel" runat="server" meta:resourcekey="headerMailboxPlanLabel"></asp:Localize></td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br/>
                    <asp:Literal ID="litMailboxPlan" runat="server" meta:resourcekey="litMailboxPlan"></asp:Literal>
                    <br/>
                    <wsp:MailboxPlanSelector ID="mailboxPlanSelector" runat="server" />
                    <br/>
                </div>
                <div class="FormFooterMiddle">
                    <asp:Button ID="btnMailboxPlanOk" runat="server" CssClass="Button1" meta:resourcekey="btnMailboxPlanOk" Text="Ok" 
                        OnClientClick="return CloseAndShowProgressDialog('Setting Mailbox Plan ...')" OnClick="btnModalOk_Click" />
                    <asp:Button ID="btnMailboxPlanCancel" runat="server" CssClass="Button1" meta:resourcekey="btnMailboxPlanCancel" Text="Cancel"
                        OnClick="btnModalCancel_OnClick" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        
        <asp:Button ID="FakeModalPopupTarget" runat="server" Style="display: none;" />
    </ContentTemplate>
    
    <Triggers>
        <asp:PostBackTrigger ControlID="btnServiceLevelOk" />
        <asp:PostBackTrigger ControlID="btnMailboxPlanOk" />
        <asp:PostBackTrigger ControlID="btnApply" />
    </Triggers>
</asp:UpdatePanel>
