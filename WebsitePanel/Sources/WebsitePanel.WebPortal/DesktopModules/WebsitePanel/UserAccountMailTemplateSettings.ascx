<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserAccountMailTemplateSettings.ascx.cs" Inherits="WebsitePanel.Portal.UserAccountMailTemplateSettings" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
<div class="FormBody">
    <ul class="LinksList">
        <li>
            <asp:HyperLink ID="lnkAccountLetter" runat="server" meta:resourcekey="lnkAccountLetter"
                Text="Account Summary Letter" NavigateUrl='<%# GetSettingsLink("AccountSummaryLetter", "SettingsAccountSummaryLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkPackageLetter" runat="server" meta:resourcekey="lnkPackageLetter"
                Text="Hosting Space Summary Letter" NavigateUrl='<%# GetSettingsLink("PackageSummaryLetter", "SettingsPackageSummaryLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkPasswordReminder" runat="server" meta:resourcekey="lnkPasswordReminder"
                Text="Password Reminder Letter" NavigateUrl='<%# GetSettingsLink("PasswordReminderLetter", "SettingsPasswordReminderLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkExchangeMailboxSetup" runat="server" meta:resourcekey="lnkExchangeMailboxSetup"
                Text="Exchange Mailbox Setup Letter" NavigateUrl='<%# GetSettingsLink("ExchangeMailboxSetupLetter", "SettingsExchangeMailboxSetupLetter") %>'></asp:HyperLink>
        </li>
         <li>
            <asp:HyperLink ID="HyperLink1" runat="server" meta:resourcekey="lnkOrganizationUserSummaryLetter"
                Text="Exchange Mailbox Setup Letter" NavigateUrl='<%# GetSettingsLink("OrganizationUserSummaryLetter", "SettingsOrganizationUserSummaryLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="HyperLink2" runat="server" meta:resourcekey="lnkHostedSolutionReport"
                Text="Exchange Mailbox Setup Letter" NavigateUrl='<%# GetSettingsLink("HostedSoluitonReportSummaryLetter", "HostedSoluitonReportSummaryLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkVpsSummaryLetter" runat="server" meta:resourcekey="lnkVpsSummaryLetter"
                Text="VPS Summary Letter" NavigateUrl='<%# GetSettingsLink("VpsSummaryLetter", "SettingsVpsSummaryLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkDomainExpirationLetter" runat="server" meta:resourcekey="lnkDomainExpirationLetter"
                Text="Domain Expiration Letter" NavigateUrl='<%# GetSettingsLink("DomainExpirationLetter", "SettingsDomainExpirationLetter") %>'></asp:HyperLink>
        </li>  
        <li>
            <asp:HyperLink ID="lnkDomainLookupLetter" runat="server" meta:resourcekey="lnkDomainLookupLetter"
                Text="Domain MX and NS Letter" NavigateUrl='<%# GetSettingsLink("DomainLookupLetter", "SettingsDomainLookupLetter") %>'></asp:HyperLink>
        </li>  
        <li>
            <asp:HyperLink ID="lnkRdsSetupLetter" runat="server" meta:resourcekey="lnkRdsSetupLetter"
                Text="RDS Setup Letter" NavigateUrl='<%# GetSettingsLink("RdsSetupLetter", "SettingsRdsSetupLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkUserPasswordExpirationLetter" runat="server" meta:resourcekey="lnkUserPasswordExpirationLetter"
                Text="User Password Expiration Letter" NavigateUrl='<%# GetSettingsLink("UserPasswordExpirationLetter", "SettingsUserPasswordExpirationLetter") %>'></asp:HyperLink>
        </li>
        <li>
            <asp:HyperLink ID="lnkOrganizationUserPasswordResetLetter" runat="server" meta:resourcekey="lnkOrganizationUserPasswordResetLetter"
                Text="User Password Expiration Letter" NavigateUrl='<%# GetSettingsLink("UserPasswordResetLetter", "SettingsUserPasswordExpirationLetter") %>'></asp:HyperLink>
        </li>
    </ul>
</div>
<div class="FormFooter">
    <asp:Button id="btnCancel" CssClass="Button1" runat="server" meta:resourcekey="btnCancel" CausesValidation="False" Text="Cancel" OnClick="btnCancel_Click"></asp:Button>
</div>