<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssignedRDSServers.ascx.cs" Inherits="WebsitePanel.Portal.RDS.AssignedRDSServers" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
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
					<asp:Image ID="imgRDSServers" SkinID="AssignedRDSServers48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Assigned RDS Servers"></asp:Localize>
				</div>
				<div class="FormContentRDS">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <div class="FormButtonsBarCleanLeft">
                            <asp:Button ID="btnAddServerToOrg" runat="server" meta:resourcekey="btnAddServerToOrg"
                                Text="Add..." CssClass="Button2" OnClick="btnAddServerToOrg_Click" />
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

				    <asp:GridView ID="gvRDSAssignedServers" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvRDSAssignedServers" CssSelectorClass="NormalGridView"
					    OnRowCommand="gvRDSAssignedServers_RowCommand" AllowPaging="True" AllowSorting="True"
					    DataSourceID="odsRDSAssignedServersPaged" PageSize="20">
                        <Columns>
						    <asp:TemplateField HeaderText="gvRDSServerName" SortExpression="Name">
                                <ItemStyle Width="80%"></ItemStyle>
							    <ItemTemplate>
								    <asp:Label id="litRDSServerName" runat="server">
                                        <%# Eval("Name") %>
								    </asp:Label>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemStyle Width="10%"></ItemStyle>
							    <ItemTemplate>
								    <asp:ImageButton ID="EnableLinkButton" ImageUrl='<%# PortalUtils.GetThemedImage("Exchange/bullet.gif")%>' runat="server" Visible='<%# Eval("RdsCollectionId") != null && !Convert.ToBoolean(Eval("ConnectionEnabled")) %>'
									    CommandName="EnableItem" CommandArgument='<%# Eval("Id") %>' meta:resourcekey="cmdEnable"></asp:ImageButton>
                                    <asp:ImageButton ID="DisableLinkButton" ImageUrl='<%# PortalUtils.GetThemedImage("Exchange/bullet_hover.gif")%>' runat="server" Visible='<%# Eval("RdsCollectionId") != null && Convert.ToBoolean(Eval("ConnectionEnabled")) %>'
									    CommandName="DisableItem" CommandArgument='<%# Eval("Id") %>' meta:resourcekey="cmdDisable"></asp:ImageButton>                                    
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField>
							    <ItemTemplate>                                                                        
									<asp:LinkButton ID="imgRemove1" runat="server" Text="Remove" Visible='<%# Eval("RdsCollectionId") == null %>'
									    CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' 
                                        meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to remove selected server?')"></asp:LinkButton>                                    
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
                    <div>
				        <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="RDS Servers:"></asp:Localize>
				        &nbsp;&nbsp;&nbsp;
				        <wsp:QuotaViewer ID="rdsServersQuota" runat="server" QuotaTypeId="2" DisplayGauge="true"/>
                    </div>
                    <asp:ObjectDataSource ID="odsRDSAssignedServersPaged" runat="server" EnablePaging="True"
							SelectCountMethod="GetOrganizationRdsServersPagedCount"
							SelectMethod="GetOrganizationRdsServersPaged"
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