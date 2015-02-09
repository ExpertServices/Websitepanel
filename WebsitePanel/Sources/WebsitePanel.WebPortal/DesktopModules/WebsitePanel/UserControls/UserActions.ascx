<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserActions.ascx.cs" Inherits="WebsitePanel.Portal.UserActions" %>
<script language="javascript">
    function CloseAndShowProgressDialog(text) {
        $(".Popup").hide();
        return ShowProgressDialog(text);
    }
</script>
<asp:UpdatePanel ID="tblActions" runat="server" CssClass="NormalBold" UpdateMode="Conditional" ChildrenAsTriggers="true" >
    <ContentTemplate>

        <asp:DropDownList ID="ddlUserActions" runat="server" CssClass="NormalTextBox" resourcekey="ddlUserActions" style="margin-right: 0px" >
            <%--<asp:ListItem Value="0">Actions</asp:ListItem>--%>
            <asp:ListItem Value="1">Disable</asp:ListItem>
            <asp:ListItem Value="2">Enable</asp:ListItem>
            <asp:ListItem Value="3">SetServiceLevel</asp:ListItem>
            <asp:ListItem Value="4">SetVIP</asp:ListItem>
        </asp:DropDownList>
        
        <asp:ImageButton ID="cmdApply" Runat="server" meta:resourcekey="cmdApply" SkinID="ApplySmall" CausesValidation="false" OnClick="cmdApply_OnClick"/>

        <ajaxToolkit:ModalPopupExtender ID="Modal" runat="server" EnableViewState="true" TargetControlID="FakeModalPopupTarget"
             PopupControlID="EnablePanel" BackgroundCssClass="modalBackground" DropShadow="false" />

        <%-- Enable --%>
        <asp:Panel ID="EnablePanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle"><asp:Localize ID="headerEnable" runat="server" meta:resourcekey="headerEnable"></asp:Localize></td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br/>
                    <asp:Literal ID="litEnable" runat="server" meta:resourcekey="litEnable"></asp:Literal>
                    <br/>
                </div>
                <div class="FormFooterMiddle">
                    <asp:Button ID="btnEnableOk" runat="server" CssClass="Button1" meta:resourcekey="btnEnableOk" Text="Ok" 
                        OnClientClick="return CloseAndShowProgressDialog('Enabling users...')" OnClick="btnModalOk_Click" />
                    <asp:Button ID="btnEnableCancel" runat="server" CssClass="Button1" meta:resourcekey="btnEnableCancel" Text="Cancel"
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <%-- Disable --%>
        <asp:Panel ID="DisablePanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle"><asp:Localize ID="headerDisable" runat="server" meta:resourcekey="headerDisable"></asp:Localize></td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br/>
                    <asp:Literal ID="litDisable" runat="server" meta:resourcekey="litDisable"></asp:Literal>
                    <br/>
                </div>
                <div class="FormFooterMiddle">
                    <asp:Button ID="btnDisableOk" runat="server" CssClass="Button1" meta:resourcekey="btnDisableOk" Text="Ok" 
                        OnClientClick="return CloseAndShowProgressDialog('Disabling users...')" OnClick="btnModalOk_Click" />
                    <asp:Button ID="btnDisableCancel" runat="server" CssClass="Button1" meta:resourcekey="btnDisableCancel" Text="Cancel"
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>
        
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
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>
        
        <%-- VIP --%>
        <asp:Panel ID="VIPPanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle"><asp:Localize ID="headerVIP" runat="server" meta:resourcekey="headerVIP"></asp:Localize></td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br/>
                    <asp:Literal ID="litVIP" runat="server" meta:resourcekey="litVIP"></asp:Literal>
                    <br/>
                    <asp:DropDownList ID="ddlVIP" runat="server" CssClass="NormalTextBox" resourcekey="ddlVIP">
                        <asp:ListItem Value="0">SetVIP</asp:ListItem>
                        <asp:ListItem Value="1">UnsetVIP</asp:ListItem>
                    </asp:DropDownList>
                    <br/>
                </div>
                <div class="FormFooterMiddle">
                    <asp:Button ID="btnVIPOk" runat="server" CssClass="Button1" meta:resourcekey="btnVIPOk" Text="Ok" 
                        OnClientClick="return CloseAndShowProgressDialog('Setting VIP...')" OnClick="btnModalOk_Click" />
                    <asp:Button ID="btnVIPCancel" runat="server" CssClass="Button1" meta:resourcekey="btnVIPCancel" Text="Cancel"
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Button ID="FakeModalPopupTarget" runat="server" Style="display: none;" />
    </ContentTemplate>
    
    <Triggers>
        <asp:PostBackTrigger ControlID="btnDisableOk" />
        <asp:PostBackTrigger ControlID="btnEnableOk" />
        <asp:PostBackTrigger ControlID="btnServiceLevelOk" />
        <asp:PostBackTrigger ControlID="btnVIPOk" />
    </Triggers>
</asp:UpdatePanel>
