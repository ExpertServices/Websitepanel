<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserOrganization.ascx.cs" Inherits="WebsitePanel.Portal.UserOrganization" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
<%@ Register Src="UserControls/ServerDetails.ascx" TagName="ServerDetails" TagPrefix="uc3" %>
<%@ Register Src="UserControls/Comments.ascx" TagName="Comments" TagPrefix="uc4" %>
<%@ Import Namespace="WebsitePanel.Portal" %>


<asp:Panel ID="UserOrgPanel" runat="server" Visible="false">
    <div class="IconsBlock">
        <asp:DataList ID="OrgIcons" runat="server" 
            CellSpacing="1" RepeatColumns="5" RepeatDirection="Horizontal">
            <ItemTemplate>
                <asp:Panel ID="IconPanel" runat="server" CssClass="Icon">
                    <asp:HyperLink ID="imgLink" runat="server" NavigateUrl='<%# Eval("NavigateURL") %>'><asp:Image ID="imgIcon" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' /></asp:HyperLink>
                    <br />
                    <asp:HyperLink ID="lnkIcon" runat="server" NavigateUrl='<%# Eval("NavigateURL") %>'><%# Eval("Text") %></asp:HyperLink>
                </asp:Panel>
            </ItemTemplate>
        </asp:DataList>
    </div>
</asp:Panel>

