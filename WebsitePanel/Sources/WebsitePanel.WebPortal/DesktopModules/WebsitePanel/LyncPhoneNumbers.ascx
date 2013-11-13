<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncPhoneNumbers.ascx.cs" Inherits="WebsitePanel.Portal.LyncPhoneNumbers" %>
<%@ Register Src="UserControls/PackagePhoneNumbers.ascx" TagName="PackagePhoneNumbers" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Quota.ascx" TagName="Quota" TagPrefix="wsp" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>

<div class="FormBody">
    <wsp:PackagePhoneNumbers id="webAddresses" runat="server"
            Pool="PhoneNumbers"
            EditItemControl=""
            SpaceHomeControl=""
            AllocateAddressesControl="allocate_phonenumbers"
            ManageAllowed="true" />
    
    <br />
    <wsp:CollapsiblePanel id="secQuotas" runat="server"
        TargetControlID="QuotasPanel" meta:resourcekey="secQuotas" Text="Quotas">
    </wsp:CollapsiblePanel>
    <asp:Panel ID="QuotasPanel" runat="server" Height="0" style="overflow:hidden;">
    
    <table cellspacing="6">
        <tr>
            <td><asp:Localize ID="locIPQuota" runat="server" meta:resourcekey="locIPQuota" Text="Number of Phone Numbes:"></asp:Localize></td>
            <td><wsp:Quota ID="addressesQuota" runat="server" QuotaName="Lync.PhoneNumbers" /></td>
        </tr>
    </table>
    
    
    </asp:Panel>
</div>

