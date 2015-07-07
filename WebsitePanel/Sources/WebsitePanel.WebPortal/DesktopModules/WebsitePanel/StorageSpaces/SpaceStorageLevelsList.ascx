<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpaceStorageLevelsList.ascx.cs" Inherits="WebsitePanel.Portal.StorageSpaces.SpaceStorageLevelsList" %>

<%@ Import Namespace="WebsitePanel.Portal" %>
<%@ Register Src="../UserControls/Comments.ascx" TagName="Comments" TagPrefix="uc4" %>
<%@ Register Src="../UserControls/SearchBox.ascx" TagName="SearchBox" TagPrefix="uc1" %>
<%@ Register Src="../UserControls/UserDetails.ascx" TagName="UserDetails" TagPrefix="uc2" %>
<%@ Register Src="../UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport ID="asyncTasks" runat="server" />

<asp:UpdatePanel runat="server" ID="messageBoxPanel" UpdateMode="Conditional">
    <ContentTemplate>
        <wsp:SimpleMessageBox ID="messageBox" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>

<div class="FormButtonsBar">
    <div class="Left">
        <asp:Button ID="btnAddSsLevel" runat="server"
            meta:resourcekey="btnAddSsLevel" Text="Add Storage Space Level" CssClass="Button3"
            OnClick="btnAddSsLevel_Click" />
    </div>
    <div class="Right">
        <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
            <asp:Localize ID="locSearch" runat="server" meta:resourcekey="locSearch" Visible="false"></asp:Localize>
            <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True"
                OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                <asp:ListItem>10</asp:ListItem>
                <asp:ListItem Selected="True">20</asp:ListItem>
                <asp:ListItem>50</asp:ListItem>
                <asp:ListItem>100</asp:ListItem>
            </asp:DropDownList>

            <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100" />
            <asp:ImageButton ID="cmdSearch" runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton" CausesValidation="false" />
        </asp:Panel>
    </div>
</div>

<asp:ObjectDataSource ID="odsSsLevelsPaged" runat="server" EnablePaging="True" SelectCountMethod="GetStorageSpaceLevelsPagedCount"
    SelectMethod="GetStorageSpaceLevelsPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.SsHelper" OnSelected="odsRDSServersPaged_Selected">
    <SelectParameters>
        <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:GridView ID="gvSsLevels" runat="server" AutoGenerateColumns="False"
    AllowPaging="True" AllowSorting="True"
    CssSelectorClass="NormalGridView"
    OnRowCommand="gvSsLevels_RowCommand"
    DataSourceID="odsSsLevelsPaged" EnableViewState="False"
    EmptyDataText="gvRDSServers">
    <Columns>
        <asp:TemplateField SortExpression="Name" HeaderText="Level name">
            <HeaderStyle Wrap="false" />
            <ItemStyle Wrap="False" Width="50%" />
            <ItemTemplate>
                <asp:LinkButton OnClientClick="ShowProgressDialog('Loading ...');return true;" CommandName="EditSsLevel" CommandArgument='<%# Eval("Id")%>' ID="lbEditSsLevel" runat="server" Text='<%#Eval("Name") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="Description" HeaderText="Description">
            <ItemStyle Width="35%" />
        </asp:BoundField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="lnkRemove" runat="server" Text="Remove" Visible='<%# CheckLevelIsInUse(Utils.ParseInt(Eval("Id"), -1)) == false %>'
                    CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>'
                    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected storage space level?');"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


