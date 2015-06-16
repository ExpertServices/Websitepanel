<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StorageSpacesList.ascx.cs" Inherits="WebsitePanel.Portal.StorageSpaces.StorageSpacesList" %>

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
        <asp:Button ID="btnAddStoragSpace" runat="server"
            meta:resourcekey="btnAddStoragSpace" Text="Add Storage Space" CssClass="Button3"
            OnClick="btnAddStoragSpace_Click" />
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

<asp:ObjectDataSource ID="odsStorageSpacesPaged" runat="server" EnablePaging="True" SelectCountMethod="GetStorageSpacePagedCount"
    SelectMethod="GetStorageSpacePaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.SsHelper" OnSelected="odsStorageSpacesPaged_Selected">
    <SelectParameters>
        <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:GridView ID="gvStorageSpaces" runat="server" AutoGenerateColumns="False"
    AllowPaging="True" AllowSorting="False"
    CssSelectorClass="NormalGridView"
    OnRowCommand="gvStorageSpaces_RowCommand"
    DataSourceID="odsStorageSpacesPaged" EnableViewState="False"
    EmptyDataText="gvStorageSpaces">
    <Columns>
        <asp:TemplateField SortExpression="Name" HeaderText="Space name">
            <HeaderStyle Wrap="false" />
            <ItemStyle Wrap="False" Width="30%" />
            <ItemTemplate>
                <asp:LinkButton OnClientClick="ShowProgressDialog('Loading ...');return true;" CommandName="EditStorageSpace" CommandArgument='<%# Eval("Id")%>' ID="lbEditStorageSpace" runat="server" Text='<%#Eval("Name") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField SortExpression="ServiceId" HeaderText="Service name">
            <HeaderStyle Wrap="false" />
            <ItemStyle Wrap="False" Width="30%" />
            <ItemTemplate>
                <asp:Label runat="server"><%# GetServiceName(Utils.ParseInt(Eval("ServiceId"), 0))%></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField SortExpression="UsedSizeBytes" HeaderText="Used Space">
            <HeaderStyle Wrap="false" />
            <ItemStyle Wrap="False" Width="20%" />
            <ItemTemplate>
                <asp:Label runat="server"><%# (ConvertBytesToGB(Eval("UsedSizeBytes"))) + " Gb"%></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

       <asp:TemplateField SortExpression="FsrmQuotaSizeBytes" HeaderText="Allocated Space">
            <HeaderStyle Wrap="false" />
            <ItemStyle Wrap="False" Width="20%" />
            <ItemTemplate>
                <asp:Label runat="server"><%# (ConvertBytesToGB(Eval("FsrmQuotaSizeBytes"))) + " Gb"%></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="lnkRemove" runat="server" Text="Remove" Visible='<%# CheckStorageIsInUse(Utils.ParseInt(Eval("Id"), -1)) == false %>'
                    CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>'
                    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected storage space?');"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


