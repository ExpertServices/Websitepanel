<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncPhoneNumbers.ascx.cs" Inherits="WebsitePanel.Portal.Lync.LyncPhoneNumbers" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="UserControls/LyncUserPlanSelector.ascx" TagName="LyncUserPlanSelector" TagPrefix="wsp" %>

<%@ Register Src="../UserControls/PackagePhoneNumbers.ascx" TagName="PackagePhoneNumbers" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/Quota.ascx" TagName="Quota" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />
<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
            <wsp:Menu id="menu" runat="server" />
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                </div>
                <div class="FormBody">
                    <wsp:PackagePhoneNumbers id="phoneNumbers" runat="server"
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
                            <td><wsp:Quota ID="phoneQuota" runat="server" QuotaName="Lync.PhoneNumbers" /></td>
                        </tr>
                    </table>
    
    
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>

