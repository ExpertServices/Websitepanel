<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSServers.ascx.cs" Inherits="WebsitePanel.Portal.RDSServers" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
<%@ Register Src="UserControls/Comments.ascx" TagName="Comments" TagPrefix="uc4" %>
<%@ Register Src="UserControls/SearchBox.ascx" TagName="SearchBox" TagPrefix="uc1" %>
<%@ Register Src="UserControls/UserDetails.ascx" TagName="UserDetails" TagPrefix="uc2" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>

<asp:UpdatePanel runat="server" ID="updatePanelUsers">
    <ContentTemplate> 

        <wsp:SimpleMessageBox id="messageBox" runat="server" />

        <div class="FormButtonsBar">
            <div class="Left">
                <asp:Button ID="btnAddRDSServer" runat="server"
                    meta:resourcekey="btnAddRDSServer" Text="Add RDS Server" CssClass="Button3"
                        OnClick="btnAddRDSServer_Click" />
            </div>
            <div class="Right">
                <asp:Panel ID="SearchPanel" runat="server" DefaultButton="cmdSearch">
                    <asp:Localize ID="locSearch" runat="server" meta:resourcekey="locSearch" Visible="false"></asp:Localize>
                    <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True"    
                            onselectedindexchanged="ddlPageSize_SelectedIndexChanged">   
                            <asp:ListItem>10</asp:ListItem>   
                            <asp:ListItem Selected="True">20</asp:ListItem>   
                            <asp:ListItem>50</asp:ListItem>   
                            <asp:ListItem>100</asp:ListItem>   
                    </asp:DropDownList>  

                    <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100">
                    </asp:TextBox><asp:ImageButton ID="cmdSearch" Runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton" CausesValidation="false"/>
                </asp:Panel>
            </div>
        </div>

        <asp:GridView id="gvRDSServers" runat="server" AutoGenerateColumns="False"
	        AllowPaging="True" AllowSorting="True"
	        CssSelectorClass="NormalGridView"
            OnRowCommand="gvRDSServers_RowCommand"
	        DataSourceID="odsRDSServersPaged" EnableViewState="False"
	        EmptyDataText="gvRDSServers">
	        <Columns>
		        <asp:BoundField DataField="Name" HtmlEncode="true" SortExpression="Name" HeaderText="Server name">
		            <HeaderStyle Wrap="false" />
                    <ItemStyle Wrap="False" Width="25%"/>
                </asp:BoundField>
		        <asp:BoundField DataField="Address" HeaderText="IP Address"><ItemStyle  Width="15%"/></asp:BoundField>
                <asp:BoundField DataField="ItemName" HeaderText="Organization"><ItemStyle  Width="20%"/></asp:BoundField>
                <asp:BoundField DataField="Description" HeaderText="Comments"><ItemStyle  Width="30%"/></asp:BoundField>
                <asp:TemplateField>
			        <ItemTemplate>
				        <asp:LinkButton ID="lnkRemove" runat="server" Text="Remove" Visible='<%# Eval("ItemId") == null %>'
					        CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' 
                            meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected rds server?')"></asp:LinkButton>                        
			        </ItemTemplate>
		        </asp:TemplateField>
	        </Columns>
        </asp:GridView>
        <asp:ObjectDataSource ID="odsRDSServersPaged" runat="server" EnablePaging="True" SelectCountMethod="GetRDSServersPagedCount"
            SelectMethod="GetRDSServersPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.RDSHelper" OnSelected="odsRDSServersPaged_Selected">
            <SelectParameters>
                <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </ContentTemplate>
</asp:UpdatePanel>
