<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSCollections.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSCollections" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgRDSCollections" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="RDS Collections"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnAddCollection" runat="server" meta:resourcekey="btnAddCollection"
                                Text="Create New RDS Collection" CssClass="Button1" OnClick="btnAddCollection_Click" />
                        </div>
                        <div class="FormButtonsBarCleanRight">
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

				    <asp:GridView ID="gvRDSCollections" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvRDSCollections" CssSelectorClass="NormalGridView"
					    OnRowCommand="gvRDSCollections_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsRDSCollectionsPaged" PageSize="20">
                        <Columns>
                            <asp:TemplateField HeaderText="gvCollectionName" SortExpression="DisplayName">
							    <ItemStyle Width="40%"></ItemStyle>
							    <ItemTemplate>  
                                    <asp:LinkButton id="lnkCollectionName" meta:resourcekey="lnkCollectionName" runat="server" CommandName="EditCollection" CommandArgument='<%# Eval("Id") %>' OnClientClick="ShowProgressDialog('Loading ...');return true;"><%# Eval("DisplayName").ToString() %></asp:LinkButton>                                                                 
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvServer">
							    <ItemStyle Width="40%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litServer" runat="server" Text='<%#GetServerName(Eval("Id").ToString())%>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField>
			                    <ItemTemplate>				                    
                                    <asp:LinkButton ID="lnkRemove" runat="server" Text="Remove"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' 
                                        meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to remove selected rds collection?')"></asp:LinkButton>
			                    </ItemTemplate>
		                    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
                    <div>
				        <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Collections Created:"></asp:Localize>
				        &nbsp;&nbsp;&nbsp;
				        <wsp:QuotaViewer ID="collectionsQuota" runat="server" QuotaTypeId="2" DisplayGauge="true" />
                    </div>
                    <asp:ObjectDataSource ID="odsRDSCollectionsPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetRDSCollectonsPagedCount"
							SelectMethod="GetRDSCollectonsPaged"
							SortParameterName="sortColumn"
							TypeName="WebsitePanel.Portal.RDSHelper">
						<SelectParameters>
							<asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
							<asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
						</SelectParameters>
					</asp:ObjectDataSource>
				</div>
			</div>
		</div>
	</div>
</div>