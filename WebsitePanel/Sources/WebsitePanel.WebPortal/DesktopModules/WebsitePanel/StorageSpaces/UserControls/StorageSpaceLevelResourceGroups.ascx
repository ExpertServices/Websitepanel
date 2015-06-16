<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StorageSpaceLevelResourceGroups.ascx.cs" Inherits="WebsitePanel.Portal.StorageSpaces.UserControls.StorageSpaceLevelResourceGroups" %>

<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../../UserControls/CollapsiblePanel.ascx" %>

<asp:UpdatePanel ID="ResourceGroupsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
        <div class="FormButtonsBarClean">
            <asp:Button ID="btnAdd" runat="server" Text="Add..." CssClass="Button1" OnClick="btnAdd_Click" meta:resourcekey="btnAdd" />
            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="Button1" OnClick="btnDelete_Click" meta:resourcekey="btnDelete" />
        </div>
        <asp:GridView ID="gvResourceGroups" runat="server" meta:resourcekey="gvResourceGroups" AutoGenerateColumns="False"
            Width="600px" CssSelectorClass="NormalGridView" 
            DataKeyNames="GroupId">
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:CheckBox ID="chkSelectAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:CheckBox ID="chkSelect" runat="server" />
                    </ItemTemplate>
                    <ItemStyle Width="10px" />
                </asp:TemplateField>
                <asp:TemplateField meta:resourcekey="gvResourceGroupsName" >
                    <ItemStyle Width="96%" Wrap="false" HorizontalAlign="Left"></ItemStyle>
                    <ItemTemplate>
                        <asp:Literal ID="litGroupName" runat="server" Text='<%# Eval("GroupName") %>'></asp:Literal>
                        <asp:HiddenField ID="hdnGroupId" runat="server" Value='<%# Eval("GroupId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />


        <asp:Panel ID="AddAccountsPanel" runat="server" CssClass="Popup" Style="display: none">
            <table class="Popup-Header" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="Popup-HeaderLeft"></td>
                    <td class="Popup-HeaderTitle">
                        <asp:Localize ID="headerAddResourceGroups" runat="server" meta:resourcekey="headerAddResourceGroups"></asp:Localize>
                    </td>
                    <td class="Popup-HeaderRight"></td>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br />
                    <asp:UpdatePanel ID="AddAccountsUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>

                            <div class="FormButtonsBarClean">
                                <div class="FormButtonsBarCleanRight">
                                    <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                                        <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"></asp:TextBox>
                                        <asp:ImageButton ID="cmdSearch" runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton"
                                            CausesValidation="false" OnClick="cmdSearch_Click" />
                                    </asp:Panel>
                                </div>
                            </div>
                            <div class="Popup-Scroll">
                                <asp:GridView ID="gvPopupResourceGroups" runat="server" meta:resourcekey="gvPopupResourceGroups" AutoGenerateColumns="False"
                                    Width="100%" CssSelectorClass="NormalGridView"
                                    DataKeyNames="GroupId">
                                    <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" onclick="javascript:SelectAllCheckboxes(this);" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                            </ItemTemplate>
                                            <ItemStyle Width="10px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField meta:resourcekey="gvResourceGroupsName">
                                            <ItemStyle Width="50%" HorizontalAlign="Left"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Literal ID="litGroupName" runat="server" Text='<%# Eval("GroupName") %>'></asp:Literal>
                                                <asp:HiddenField ID="hdnGroupId" runat="server" Value='<%# Eval("GroupId") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                </div>

                <div class="FormFooter">
                    <asp:Button ID="btnAddSelected" runat="server" CssClass="Button1" meta:resourcekey="btnAddSelected" Text="Add Accounts" OnClick="btnAddSelected_Click" />
                    <asp:Button ID="btnCancelAdd" runat="server" CssClass="Button1" meta:resourcekey="btnCancel" Text="Cancel" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Button ID="btnAddAccountsFake" runat="server" Style="display: none;" />
        <ajaxToolkit:ModalPopupExtender ID="AddAccountsModal" runat="server"
            TargetControlID="btnAddAccountsFake" PopupControlID="AddAccountsPanel"
            BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelAdd" />

    </ContentTemplate>
</asp:UpdatePanel>


