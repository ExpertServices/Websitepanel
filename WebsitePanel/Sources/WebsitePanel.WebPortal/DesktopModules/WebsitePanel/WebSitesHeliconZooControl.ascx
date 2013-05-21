<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WebSitesHeliconZooControl.ascx.cs" Inherits="WebsitePanel.Portal.WebSitesHeliconZooControl" %>
<%@ Import Namespace="WebsitePanel.Portal" %>

<%--
<p class="NormalBold">Web engines allowed for this site:</p>
<asp:Panel ID="AllowedEnginesPanel" runat="server">
    <asp:DataList ID="AllowedEnginesList" runat="server" RepeatColumns="1">
        <ItemTemplate>
            <div class="Quota">
                <%# Eval("DisplayName") %>
            </div>
        </ItemTemplate>
    </asp:DataList>   
</asp:Panel>
<br/>

<p class="NormalBold">Web engines enabled for this site:</p>
<asp:Panel ID="EnabledEnginesPanel" runat="server">
    <asp:DataList ID="EnabledEnginesList" runat="server" RepeatColumns="1">
        <ItemTemplate>
            <div class="Quota">
                <%# Container.DataItem.ToString() %>
            </div>
        </ItemTemplate>
    </asp:DataList>   
</asp:Panel>
<br
--%>

<p>
<asp:Label  runat="server" meta:resourcekey="SelectWebEngine" CssClass="NormalBold"></asp:Label>
</p>
<br />

<asp:GridView id="gvApplications" runat="server" AutoGenerateColumns="False" AllowPaging="true" 
	ShowHeader="false" CssSelectorClass="LightGridView" EmptyDataText="gvApplications" OnRowCommand="gvApplications_RowCommand" 
	OnPageIndexChanging="gvApplications_PageIndexChanging">
	<Columns>
		<asp:TemplateField HeaderText="gvApplicationsApplication">
		    <ItemStyle HorizontalAlign="Center" />
			<ItemTemplate>
				<div style="text-align:center;">
					<%-- <asp:hyperlink NavigateUrl='<%# GetWebAppInstallUrl(Eval("Id").ToString()) %>'
							runat="server" ID="Hyperlink3" ToolTip='<%# Eval("Title") %>'>
                    --%>
						<asp:Image runat="server" ID="Image1" Width="120" Height="120"
                            ImageUrl='<%# GetIconUrlOrDefault((string)Eval("IconUrl"))  %>'
							AlternateText='<%# Eval("Title") %>'>
						</asp:Image>
					<%-- </asp:hyperlink> --%>
				</div>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<div class="MediumBold" style="padding:4px;">
					<%-- <asp:hyperlink CssClass="MediumBold" NavigateUrl='<%# GetWebAppInstallUrl(Eval("Id").ToString()) %>'
					    runat="server" ID="lnkAppDetails" ToolTip='<%# Eval("Title") %>'>
                     --%>
						<span class="MediumBold"><%# Eval("Title")%></span>
					<%-- </asp:hyperlink> --%>
				</div>
				<div class="Normal" style="padding:4px;">
					<%# Eval("Summary") %>
				</div>				
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="gvApplicationsApplication">
		    <ItemStyle HorizontalAlign="Center" />
			<ItemTemplate>
			    <asp:Button ID="btnInstall" runat="server"
			        Text='<%# GetLocalizedString("btnInstall.Text") %>' CssClass="Button1"
			        CommandArgument='<%# Eval("Id") %>'
			        CommandName="Install" />
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>

