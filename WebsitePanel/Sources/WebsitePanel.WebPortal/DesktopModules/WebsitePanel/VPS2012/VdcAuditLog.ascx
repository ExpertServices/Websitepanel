<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VdcAuditLog.ascx.cs" Inherits="WebsitePanel.Portal.VPS2012.VdcAuditLog" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/AuditLogControl.ascx" TagName="AuditLogControl" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>

	    <div class="Content">
		    <div class="Center">
			    <div class="FormBody">

                    <wsp:AuditLogControl id="auditLog" runat="server" LogSource="VPS2012" />

			    </div>
		    </div>
	    </div>
