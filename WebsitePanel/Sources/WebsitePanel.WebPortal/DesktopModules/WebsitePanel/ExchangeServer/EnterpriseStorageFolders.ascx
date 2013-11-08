<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageFolders.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageFolders" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Menu.ascx" TagName="Menu" TagPrefix="wsp" %>
<%@ Register Src="UserControls/Breadcrumb.ascx" TagName="Breadcrumb" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Header">
			<wsp:Breadcrumb id="breadcrumb" runat="server" PageName="Text.PageName" />
		</div>
		<div class="Left">
			<wsp:Menu id="menu" runat="server" SelectedItem="esfolders" />
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgESS" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Folders"></asp:Localize>

                    <asp:Literal ID="litRootFolder" runat="server" Text="Root" />
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnAddFolder" runat="server" meta:resourcekey="btnAddFolder"
                                Text="Create New Folder" CssClass="Button1" OnClick="btnAddFolder_Click" />
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

				    <asp:GridView ID="gvFolders" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvFolders" CssSelectorClass="NormalGridView"
					    OnRowCommand="gvFolders_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsEnterpriseFoldersPaged" PageSize="20">
                        <Columns>
						    <asp:TemplateField HeaderText="gvFolderName" SortExpression="Name">
							    <ItemStyle Width="30%"></ItemStyle>
							    <ItemTemplate>
								    <asp:hyperlink id="lnkFolderName" runat="server"
									    NavigateUrl='<%# GetFolderEditUrl(Eval("Name").ToString()) %>'>
                                        <%# Eval("Name") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderSize" SortExpression="Size">
							    <ItemStyle Width="20%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderSize" runat="server" Text='<%# Eval("Size").ToString() + " Mb" %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderUrl">
							    <ItemStyle Width="50%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderUrl" runat="server" Text='<%# Eval("Url").ToString() %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField>
							    <ItemTemplate>
									<asp:ImageButton ID="imgDelFolder" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("Name") %>' 
                                        meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected folder?')"></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
                    <asp:ObjectDataSource ID="odsEnterpriseFoldersPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetEnterpriseFoldersPagedCount"
							SelectMethod="GetEnterpriseFoldersPaged"
							SortParameterName="sortColumn"
							TypeName="WebsitePanel.Portal.EnterpriseStorageHelper">
						<SelectParameters>
							<asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
							<asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
						</SelectParameters>
					</asp:ObjectDataSource>
				    <br />
				
                    <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Folders Used:"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <wsp:QuotaViewer ID="foldersQuota" runat="server" QuotaTypeId="2" />
				</div>
			</div>
		</div>
	</div>
</div>