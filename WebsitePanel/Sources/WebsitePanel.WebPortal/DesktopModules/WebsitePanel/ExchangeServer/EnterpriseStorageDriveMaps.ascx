<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageDriveMaps.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageDriveMaps" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgESDM" SkinID="EnterpriseStorageDriveMaps48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Drive Maps"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnAddDriveMap" runat="server" meta:resourcekey="btnAddDriveMap"
                                Text="Create New Drive Map" CssClass="Button1" OnClick="btnAddDriveMap_Click" />
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

                    <asp:GridView ID="gvDriveMaps" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvDriveMaps" CssSelectorClass="NormalGridView"
					     OnRowCommand="gvDriveMaps_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsEnterpriseDriveMapsPaged" PageSize="20">
                        <Columns>
						    <asp:TemplateField HeaderText="gvDrive">
							    <ItemStyle Width="25%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Image ID="img1" runat="server" ImageUrl='<%# GetDriveImage() %>' ImageAlign="AbsMiddle" />
                                    <asp:Literal id="litDrive" runat="server" Text='<%# string.Format("{0}:", Eval("DriveLetter")) %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvLabelAs">
							    <ItemStyle Width="25%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litLabelAs" runat="server" Text='<%# Eval("LabelAs") %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderUrl">
							    <ItemStyle Width="50%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderUrl" runat="server" Text='<%# Eval("Folder.Url") %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField>
							    <ItemTemplate>
									<asp:ImageButton ID="imgDelDriveMap" runat="server" Text="Delete" SkinID="ExchangeDelete"
                                        CommandName="DeleteItem" CommandArgument='<%# Eval("Folder.Name") %>'
                                        meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected map drive?')"></asp:ImageButton>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
                    <asp:ObjectDataSource ID="odsEnterpriseDriveMapsPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetEnterpriseDriveMapsPagedCount"
							SelectMethod="GetEnterpriseDriveMapsPaged"
							SortParameterName="sortColumn"
							TypeName="WebsitePanel.Portal.EnterpriseStorageHelper">
						<SelectParameters>
							<asp:QueryStringParameter Name="itemId" QueryStringField="ItemID" DefaultValue="0" />
							<asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />
						</SelectParameters>
					</asp:ObjectDataSource>
				    <br />
				</div>
			</div>
		</div>
	</div>
</div>