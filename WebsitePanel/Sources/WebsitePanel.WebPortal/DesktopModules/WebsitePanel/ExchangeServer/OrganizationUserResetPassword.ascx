<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationUserResetPassword.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.OrganizationUserResetPassword" %>

<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>


<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="OrganizationUser48" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Reset Password"></asp:Localize>
                    -
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>

                <div class="FormBody">
                    <asp:UpdatePanel ID="PasswrodResetUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            
                            <table>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locSendTo" runat="server" meta:resourcekey="locSendTo" Text="Send to:"></asp:Localize></td>
                                    <td class="FormRBtnL">
                                        <asp:RadioButton ID="rbtnEmail" runat="server" meta:resourcekey="rbtnEmail" Text="Email" GroupName="SendToGroup" AutoPostBack="true"  Checked="true" OnCheckedChanged="SendToGroupCheckedChanged" />
                                        <asp:RadioButton ID="rbtnMobile" runat="server" meta:resourcekey="rbtnMobile" Text="Mobile" GroupName="SendToGroup" AutoPostBack="true" OnCheckedChanged="SendToGroupCheckedChanged" />
                                        <br />
                                        <br />
                                    </td>
                                </tr>
                                <tr id="EmailRow" runat="server">
                                    <td class="FormLabel150" valign="top">
                                        <asp:Localize ID="locEmailAddress" runat="server" meta:resourcekey="locEmailAddress"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtEmailAddress" CssClass="TextBox200" />
                                        <asp:RequiredFieldValidator ID="valEmailAddress" runat="server" ErrorMessage="*" ControlToValidate="txtEmailAddress" ValidationGroup="ResetUserPassword"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="ResetUserPassword" ControlToValidate="txtEmailAddress" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr id="MobileRow" runat="server" visible="False">
                                    <td class="FormLabel150" valign="top">
                                        <asp:Localize ID="locMobile" runat="server" meta:resourcekey="locMobile"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtMobile" CssClass="TextBox200" />
                                        <asp:RequiredFieldValidator ID="valMobile" runat="server" ErrorMessage="*" ControlToValidate="txtMobile" ValidationGroup="ResetUserPassword"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="regexMobileValid" runat="server" ValidationExpression="^\+?\d+$" ValidationGroup="ResetUserPassword" ControlToValidate="txtMobile" ErrorMessage="Invalid Mobile Format"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locReason" runat="server" meta:resourcekey="locReason" Text="Reason:"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtReason" runat="server" CssClass="TextBox200" Rows="4" TextMode="MultiLine"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="valReason" runat="server" ErrorMessage="*" ControlToValidate="txtReason" ValidationGroup="ResetUserPassword"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="FormFooterClean">
                        <asp:Button ID="btnResetPassoword" runat="server" Text="Send Password Reset Email" CssClass="Button1" meta:resourcekey="btnResetPassoword" ValidationGroup="ResetUserPassword" OnClick="btnResetPassoword_Click"></asp:Button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
