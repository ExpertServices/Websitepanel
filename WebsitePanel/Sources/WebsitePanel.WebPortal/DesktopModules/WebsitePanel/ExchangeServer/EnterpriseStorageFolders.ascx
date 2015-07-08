<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageFolders.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageFolders" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<script type="text/javascript">
    //<![CDATA[
    $(document).ready(function () {        
        setTimeout(getFolderData, 3000);        
    });    
    //]]>
</script>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgESS" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Shared Folders"></asp:Localize>
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

                    <asp:HiddenField runat="server" ID="hdnGridState" Value="false" />
                    <asp:HiddenField runat="server" ID="hdnItemId"  />
				    <asp:GridView ID="gvFolders" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvFolders" CssSelectorClass="NormalGridView"
					    OnRowCommand="gvFolders_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsEnterpriseFoldersPaged" PageSize="20">
                        <Columns>
                            <asp:TemplateField>
                                <ItemStyle Width="0%" />
                                <ItemTemplate>                        
                                    <asp:HiddenField ID="hdnFolderName" runat="server" Value='<%# Eval("Name") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvFolderName" SortExpression="Name">
                                <ItemStyle Width="20%"></ItemStyle>
							    <ItemTemplate>
								    <asp:hyperlink id="lnkFolderName" runat="server"
									    NavigateUrl='<%# GetFolderEditUrl(Eval("Name").ToString()) %>'>
                                        <%# Eval("Name") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderQuota" SortExpression="FRSMQuotaGB">
							    <ItemStyle Width="15%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderQuota" runat="server" Text='<%# ConvertMBytesToGB(Eval("FRSMQuotaMB")).ToString() + " Gb" %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderSize" SortExpression="Size">
							    <ItemStyle Width="15%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderSize" runat="server" Text='...'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvFolderUrl">
							    <ItemStyle Width="40%"></ItemStyle>
							    <ItemTemplate>
                                    <asp:Literal id="litFolderUrl" runat="server" Text='<%# (Eval("UncPath") ?? Eval("Url")).ToString() %>'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvMappedDrive">
							    <ItemStyle Width="10%"></ItemStyle>
							    <ItemTemplate>
                                     <asp:Image ID="img1" runat="server" ImageUrl='<%# GetDriveImage() %>' ImageAlign="AbsMiddle"  style="display:none"/>
                                    <asp:Literal id="litMappedDrive" runat="server" Text='...'></asp:Literal>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField>
							    <ItemTemplate>
									<asp:ImageButton ID="imgDelFolder" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("Name") %>' 
                                        meta:resourcekey="cmdDelete" OnClientClick="return confirm('Confirming Deletion will result in the deletion of all files on this share.')"></asp:ImageButton>
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
				
                    <asp:Localize ID="locQuotaFolders" runat="server" meta:resourcekey="locQuotaFolders" Text="Total Folders Allocated:"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <wsp:QuotaViewer ID="foldersQuota" runat="server" QuotaTypeId="2" />
                    <br />
                    <br />

                    <asp:Localize ID="locQuotaSpace" runat="server" meta:resourcekey="locQuotaSpace" Text="Total Space Allocated (Gb):"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <wsp:QuotaViewer ID="spaceQuota" runat="server" QuotaTypeId="3" />
                    <br />
                    <br />

                    <asp:Localize ID="locQuotaAvailableSpace" runat="server" meta:resourcekey="locQuotaAvailableSpace" Text="Used Diskspace (Mb):"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <wsp:QuotaViewer ID="spaceAvailableQuota" runat="server" QuotaTypeId="2" />
				</div>
			</div>
		</div>
	</div>
</div>