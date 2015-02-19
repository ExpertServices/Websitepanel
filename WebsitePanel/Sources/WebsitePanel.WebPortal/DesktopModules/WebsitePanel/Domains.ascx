<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Domains.ascx.cs" Inherits="WebsitePanel.Portal.Domains" %>
<%@ Register Src="UserControls/Quota.ascx" TagName="Quota" TagPrefix="wsp" %>
<%@ Register Src="UserControls/ServerDetails.ascx" TagName="ServerDetails" TagPrefix="wsp" %>
<%@ Register Src="UserControls/UserDetails.ascx" TagName="UserDetails" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SearchBox.ascx" TagName="SearchBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/DomainActions.ascx" TagName="DomainActions" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<script src="JavaScript/jquery-1.4.4.min.js" type="text/javascript"></script>

<script language="javascript">
    function SelectAllCheckboxes(box) {
        $(".NormalGridView tbody :checkbox").attr("checked", $(box).attr("checked"));
    }
</script>

<div class="FormButtonsBar">
    <div class="Left">
        <asp:Button ID="btnAddDomain" runat="server" meta:resourcekey="btnAddDomain" Text="Add Domain" CssClass="Button2" OnClick="btnAddDomain_Click" />
        &nbsp;<asp:CheckBox ID="chkRecursive" runat="server" Text="Show Nested Spaces Items" meta:resourcekey="chkRecursive"
			AutoPostBack="true" Checked="True" CssClass="Normal" />

    </div>
    <div class="Right">
        <table>
            <tr>
                <td>
                    <wsp:DomainActions ID="websiteActions" runat="server" GridViewID="gvDomains" CheckboxesName="chkSelectedIds" />
                </td>
                <td class="FormButtonsBarCleanSeparator"></td>
                <td>
                    <wsp:SearchBox ID="searchBox" runat="server" />
                </td>
            </tr>
        </table>
    </div>
</div>

<asp:GridView ID="gvDomains" runat="server" AutoGenerateColumns="False" Width="100%" AllowSorting="True" DataSourceID="odsDomainsPaged"
    EmptyDataText="gvDomains" DataKeyNames="DomainID"
    CssSelectorClass="NormalGridView" AllowPaging="True" OnRowCommand="gvDomains_RowCommand">
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
                <asp:CheckBox ID="selectAll" Runat="server" onclick="javascript:SelectAllCheckboxes(this);" CssClass="HeaderCheckbox"></asp:CheckBox>
            </HeaderTemplate>
			<ItemTemplate>							        
				<asp:CheckBox runat="server" ID="chkSelectedIds" CssClass="GridCheckbox"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
        <asp:TemplateField SortExpression="DomainName" HeaderText="gvDomainsName">
            <ItemStyle Width="45%" Wrap="False"></ItemStyle>
            <ItemTemplate>
	            <b><asp:hyperlink id=lnkEdit1 runat="server" CssClass="Medium"
	                NavigateUrl='<%# GetItemEditUrl(Eval("PackageID"), Eval("DomainID")) %>'>
		            <%# Eval("DomainName")%></asp:hyperlink>
	            </b>
	            <div runat="server" class="Small" style="margin-top:2px;" visible=' <%# Eval("MailDomainName") != DBNull.Value %>'>
                    <asp:Label ID="lblMailDomain" runat="server" meta:resourcekey="lblMailDomain" Text="Mail:"></asp:Label>
                    <b><%# Eval("MailDomainName")%></b>
	            </div>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="gvDomainsExpirationDate">
            <ItemStyle Width="11%"></ItemStyle>
            <ItemTemplate>
	            <%# GetDomainExpirationDate(Eval("ExpirationDate"), Eval("LastUpdateDate"))%>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="">
            <ItemStyle Width="5%"></ItemStyle>
            <ItemTemplate>
	            <div style="display:inline-block" runat="server" Visible='<%# ShowDomainDnsInfo(Eval("ExpirationDate"), Eval("LastUpdateDate"), !(bool)Eval("IsSubDomain") && !(bool)Eval("IsInstantAlias") && !(bool)Eval("IsDomainPointer")) && !string.IsNullOrEmpty(GetDomainDnsRecords((int)Eval("DomainId"))) %>'>
                  <img style="border-width: 0px;" src="App_Themes/Default/Images/information_icon_small.gif" title="<%# GetDomainTooltip((int)Eval("DomainId"), Eval("RegistrarName") != DBNull.Value ? (string)Eval("RegistrarName"):string.Empty)  %>">
                </div>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="gvDomainsType">
            <ItemStyle Width="30%"></ItemStyle>
            <ItemTemplate>
	            <%# GetDomainTypeName((bool)Eval("IsSubDomain"), (bool)Eval("IsInstantAlias"), (bool)Eval("IsDomainPointer"))%>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField SortExpression="PackageName" HeaderText="gvDomainsSpace">
            <ItemStyle Width="30%"></ItemStyle>
            <ItemTemplate>
	            <asp:hyperlink id="lnkEdit2" runat="server" EnableViewState="false"
	                NavigateUrl='<%# GetSpaceHomePageUrl((int)Eval("PackageID")) %>'>
		            <%# Eval("PackageName") %>
	            </asp:hyperlink>
            </ItemTemplate>
        </asp:TemplateField>
		<asp:TemplateField SortExpression="Username" HeaderText="gvDomainsUser">
			<ItemStyle Wrap="False" />
			<ItemTemplate>
				<asp:hyperlink id=lnkEdit3 runat="server" EnableViewState="false"
				    NavigateUrl='<%# GetUserHomePageUrl((int)Eval("UserID")) %>'>
					<%# Eval("Username") %>
				</asp:hyperlink>
			</ItemTemplate>
            <HeaderStyle Wrap="False" />
		</asp:TemplateField>
        <asp:TemplateField SortExpression="ServerName" HeaderText="gvDomainsServer">
			<ItemStyle Wrap="False" />
			<ItemTemplate>
				<asp:hyperlink id=lnkEdit4 runat="server" EnableViewState="false"
				    NavigateUrl='<%# GetItemsPageUrl("ServerID", Eval("ServerID").ToString()) %>'>
					<%# Eval("ServerName") %>
				</asp:hyperlink>
			</ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="cmdDetach" runat="server" Text="Detach"
					CommandName="Detach" CommandArgument='<%# Eval("DomainID") %>'
					meta:resourcekey="cmdDetach" OnClientClick="return confirm('Remove this item?');"></asp:LinkButton>
			</ItemTemplate>
        </asp:TemplateField>
    </Columns>
	<PagerSettings Mode="NumericFirstLast" />
</asp:GridView>
<asp:ObjectDataSource ID="odsDomainsPaged" runat="server" EnablePaging="True" SelectCountMethod="GetDomainsPagedCount"
    SelectMethod="GetDomainsPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.ServersHelper" OnSelected="odsDomainsPaged_Selected">
    <SelectParameters>
        <asp:QueryStringParameter Name="packageId" QueryStringField="SpaceID" DefaultValue="-1" />
        <asp:QueryStringParameter Name="serverId" QueryStringField="ServerID" DefaultValue="0" Type="Int32" />
        <asp:ControlParameter Name="recursive" ControlID="chkRecursive" PropertyName="Checked" DefaultValue="False" />
        <asp:ControlParameter Name="filterColumn" ControlID="searchBox" PropertyName="FilterColumn" />
        <asp:ControlParameter Name="filterValue" ControlID="searchBox" PropertyName="FilterValue" />
    </SelectParameters>
</asp:ObjectDataSource>

	
<div class="GridFooter">
    <table>
        <tr>
            <td><asp:Label ID="lblDomains" runat="server" meta:resourcekey="lblDomains" Text="Domains:" CssClass="NormalBold"></asp:Label></td>
            <td><wsp:Quota ID="quotaDomains" runat="server" QuotaName="OS.Domains" /></td>
        </tr>
        <tr>
            <td><asp:Label ID="lblSubDomains" runat="server" meta:resourcekey="lblSubDomains" Text="Sub-Domains:" CssClass="NormalBold"></asp:Label></td>
            <td><wsp:Quota ID="quotaSubDomains" runat="server" QuotaName="OS.SubDomains" /></td>
        </tr>
<!--
        <tr>
            <td><asp:Label ID="lblDomainPointers" runat="server" meta:resourcekey="lblDomainPointers" Text="Domain Aliases:" CssClass="NormalBold"></asp:Label></td>
            <td><wsp:Quota ID="quotaDomainPointers" runat="server" QuotaName="OS.DomainPointers" /></td>
        </tr>
-->
    </table>
</div>

