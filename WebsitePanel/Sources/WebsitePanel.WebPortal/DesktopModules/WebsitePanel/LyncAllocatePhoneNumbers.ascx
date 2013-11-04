<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncAllocatePhoneNumbers.ascx.cs" Inherits="WebsitePanel.Portal.LyncAllocatePhoneNumbers" %>
<%@ Register Src="UserControls/AllocatePackagePhoneNumbers.ascx" TagName="AllocatePackagePhoneNumbers" TagPrefix="wsp" %>

<div class="FormBody">

    <wsp:AllocatePackagePhoneNumbers id="allocatePhoneNumbers" runat="server"
            Pool="PhoneNumbers"
            ResourceGroup="Web"
            ListAddressesControl="" />
            
</div>