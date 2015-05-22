<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrganizationCreateUser.ascx.cs" Inherits="WebsitePanel.Portal.HostedSolution.OrganizationCreateUser" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/PasswordControl.ascx" TagName="PasswordControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EmailControl.ascx" TagName="EmailControl" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SendToControl.ascx" TagName="SendToControl" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div runat="server" id="divWrapper">
    <script language="javascript" type="text/javascript">
        function buildDisplayName() {
            document.getElementById("<%= txtDisplayName.ClientID %>").value = '';

            if (document.getElementById("<%= txtFirstName.ClientID %>").value != '')
                document.getElementById("<%= txtDisplayName.ClientID %>").value = document.getElementById("<%= txtFirstName.ClientID %>").value + ' ';

            if (document.getElementById("<%= txtInitials.ClientID %>").value != '')
                document.getElementById("<%= txtDisplayName.ClientID %>").value = document.getElementById("<%= txtDisplayName.ClientID %>").value + document.getElementById("<%= txtInitials.ClientID %>").value + ' ';

            if (document.getElementById("<%= txtLastName.ClientID %>").value != '')
                document.getElementById("<%= txtDisplayName.ClientID %>").value = document.getElementById("<%= txtDisplayName.ClientID %>").value + document.getElementById("<%= txtLastName.ClientID %>").value;
        }
    </script>
</div>

<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="OrganizationUserAdd48" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Create User"></asp:Localize>
                </div>
                <asp:UpdatePanel ID="CreateUserUpdatePanel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="FormBody">
                            <wsp:SimpleMessageBox id="messageBox" runat="server" />
                            <table>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locFirstName" runat="server" meta:resourcekey="locFirstName" Text="First Name: "></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBox100" onKeyUp="buildDisplayName();"></asp:TextBox>
                                        &nbsp;
								<asp:Localize ID="locInitials" runat="server" meta:resourcekey="locInitials" Text="Middle Initial:" />
                                        <asp:TextBox ID="txtInitials" runat="server" MaxLength="6" CssClass="TextBox100" onKeyUp="buildDisplayName();"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locLastName" runat="server" meta:resourcekey="locLastName" Text="Last Name: "></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtLastName" runat="server" CssClass="TextBox200" onKeyUp="buildDisplayName();"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locDisplayName" runat="server" meta:resourcekey="locDisplayName" Text="Display Name: *"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtDisplayName" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="valRequireDisplayName" runat="server" meta:resourcekey="valRequireDisplayName" ControlToValidate="txtDisplayName"
                                            ErrorMessage="Enter Display Name" ValidationGroup="CreateMailbox" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locSubscriberNumber" runat="server" meta:resourcekey="locSubscriberNumber" Text="Account Number: *"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtSubscriberNumber" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="valRequireSubscriberNumber" runat="server" meta:resourcekey="valRequireSubscriberNumber" ControlToValidate="txtSubscriberNumber"
                                            ErrorMessage="Enter Account Number" ValidationGroup="CreateMailbox" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:Localize ID="locAccount" runat="server" meta:resourcekey="locAccount" Text="E-mail Address: *"></asp:Localize></td>
                                    <td>
                                        <wsp:EmailAddress id="email" runat="server" ValidationGroup="CreateMailbox">
                                        </wsp:EmailAddress>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <wsp:SendToControl id="sendToControl" runat="server" ValidationGroup="CreateMailbox" ControlToHide="PasswordBlock"></wsp:SendToControl>
                                    </td>
                                </tr>
                                <tr id="PasswordBlock" runat="server" Visible="false">
                                    <td class="FormLabel150" valign="top">
                                        <asp:Localize ID="locPassword" runat="server" meta:resourcekey="locPassword" Text="Password: *"></asp:Localize></td>
                                    <td>
                                        <wsp:PasswordControl id="password" runat="server" ValidationGroup="CreateMailbox" AllowGeneratePassword="false">
                                        </wsp:PasswordControl>
                                        <asp:CheckBox ID="chkUserMustChangePassword" runat="server" meta:resourcekey="chkUserMustChangePassword" Text="User must change password at next login" Visible="False"/>
                                    </td>
                                </tr>
                            </table>


                            <table>
                                <tr>
                                    <td class="FormLabel150">
                                        <asp:CheckBox ID="chkSendInstructions" runat="server" meta:resourcekey="chkSendInstructions" Text="Send Setup Instructions" Checked="true" />
                                    </td>
                                    <td>
                                        <wsp:EmailControl id="sendInstructionEmail" runat="server" RequiredEnabled="true" ValidationGroup="CreateMailbox"></wsp:EmailControl></td>
                                </tr>
                            </table>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div class="FormFooterClean">
                    <asp:Button ID="btnCreate" runat="server" Text="Create Mailbox"
                        CssClass="Button1" meta:resourcekey="btnCreate" ValidationGroup="CreateMailbox"
                        OnClick="btnCreate_Click"
                        OnClientClick="ShowProgressDialog('Creating user...');"></asp:Button>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreateMailbox" />
                </div>
            </div>
        </div>
    </div>
</div>
