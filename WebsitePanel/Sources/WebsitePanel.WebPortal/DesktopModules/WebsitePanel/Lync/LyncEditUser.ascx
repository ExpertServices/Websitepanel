<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LyncEditUser.ascx.cs" Inherits="WebsitePanel.Portal.Lync.EditLyncUser" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="../ExchangeServer/UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register src="../ExchangeServer/UserControls/MailboxSelector.ascx" tagname="MailboxSelector" tagprefix="uc1" %>
<%@ Register Src="UserControls/LyncUserPlanSelector.ascx" TagName="LyncUserPlanSelector" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />
<div id="ExchangeContainer">
    <div class="Module">
        <div class="Header">
            <wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName"  meta:resourcekey="breadcrumb" />
        </div>
        <div class="Left">
            <wsp:Menu id="menu" runat="server" />
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="LyncLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                    -
					<asp:Literal ID="litDisplayName" runat="server" Text="John Smith" />
                </div>
                <div class="FormBody">
                    
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                    
                    <table>
                        <tr>
                            <td class="FormLabel150">
                                <asp:Localize ID="locPlanName" runat="server" meta:resourcekey="locPlanName" Text="Plan Name: *"></asp:Localize>
                            </td>
                            <td>                                
                                <wsp:LyncUserPlanSelector ID="planSelector" runat="server" />
                            </td>
                        </tr>
                    </table>
                        
					<div class="FormFooterClean">
					 <asp:Button runat="server" ID="btnSave" meta:resourcekey="btnSave"  
                        CssClass="Button1" onclick="btnSave_Click"  />					 					                                                
				    </div>			
                </div>
            </div>
        </div>
    </div>
</div>
