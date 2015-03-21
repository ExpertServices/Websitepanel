<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSServers.ascx.cs" Inherits="WebsitePanel.Portal.RDSServers" %>
<%@ Import Namespace="WebsitePanel.Portal" %>
<%@ Register Src="UserControls/Comments.ascx" TagName="Comments" TagPrefix="uc4" %>
<%@ Register Src="UserControls/SearchBox.ascx" TagName="SearchBox" TagPrefix="uc1" %>
<%@ Register Src="UserControls/UserDetails.ascx" TagName="UserDetails" TagPrefix="uc2" %>
<%@ Register Src="UserControls/CollapsiblePanel.ascx" TagName="CollapsiblePanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/PopupHeader.ascx" TagName="PopupHeader" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<asp:UpdatePanel runat="server" ID="messageBoxPanel" UpdateMode="Conditional">
    <ContentTemplate>
        <wsp:SimpleMessageBox id="messageBox" runat="server" />
    </ContentTemplate>    
</asp:UpdatePanel>

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

                    <asp:TextBox ID="txtSearchValue" runat="server" CssClass="NormalTextBox" Width="100"/>
                    <asp:ImageButton ID="cmdSearch" Runat="server" meta:resourcekey="cmdSearch" SkinID="SearchButton" CausesValidation="false"/>                    
                </asp:Panel>
            </div>
        </div>
<asp:ObjectDataSource ID="odsRDSServersPaged" runat="server" EnablePaging="True" SelectCountMethod="GetRDSServersPagedCount"
            SelectMethod="GetRDSServersPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.RDSHelper" OnSelected="odsRDSServersPaged_Selected">
            <SelectParameters>
                <asp:ControlParameter Name="filterValue" ControlID="txtSearchValue" PropertyName="Text" />                                
            </SelectParameters>
        </asp:ObjectDataSource>

<asp:UpdatePanel runat="server" ID="updatePanelUsers" UpdateMode="Conditional">
    <ContentTemplate>                 

        <asp:GridView id="gvRDSServers" runat="server" AutoGenerateColumns="False"
	        AllowPaging="True" AllowSorting="True"
	        CssSelectorClass="NormalGridView"
            OnRowCommand="gvRDSServers_RowCommand"
	        DataSourceID="odsRDSServersPaged" EnableViewState="False"
	        EmptyDataText="gvRDSServers">
	        <Columns>
		        <asp:TemplateField SortExpression="Name" HeaderText="Server name">
		            <HeaderStyle Wrap="false" />
                    <ItemStyle Wrap="False" Width="15%"/>
                    <ItemTemplate>
                        <asp:LinkButton OnClientClick="ShowProgressDialog('Loading ...');return true;" CommandName="EditServer" CommandArgument='<%# Eval("Id")%>' ID="lbEditServer" runat="server" Text='<%#Eval("Name") %>'/>                    
                    </ItemTemplate>                    
                </asp:TemplateField>
		        <asp:BoundField DataField="Address" HeaderText="IP Address"><ItemStyle  Width="10%"/></asp:BoundField>
                <asp:BoundField DataField="ItemName" HeaderText="Organization"><ItemStyle  Width="10%"/></asp:BoundField>
                <asp:BoundField DataField="Description" HeaderText="Comments"><ItemStyle  Width="20%"/></asp:BoundField>
                <asp:TemplateField meta:resourcekey="gvPopupStatus">
                    <ItemStyle Width="20%" HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Literal ID="litStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Literal>
                        <asp:HiddenField ID="hdnRdsCollectionId" runat="server" Value='<%# Eval("RdsCollectionId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField meta:resourcekey="gvViewInfo">
                    <ItemStyle Width="8%" HorizontalAlign="Right"/>
                    <ItemTemplate>
                        <asp:LinkButton OnClientClick="ShowProgressDialog('Getting Server Info ...');return true;" Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>' CommandName="ViewInfo" CommandArgument='<%# Eval("Id")%>' ID="lbViewInfo" runat="server" Text="View Info"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField meta:resourcekey="gvRestart">
                    <ItemStyle HorizontalAlign="Right"/>
                    <ItemTemplate>
                        <asp:LinkButton ID="lbRestart" CommandName="Restart" CommandArgument='<%# Eval("Id")%>' Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>'
                            runat="server" Text="Restart" OnClientClick="if(confirm('Are you sure you want to restart selected server?')) ShowProgressDialog('Loading...'); else return false;"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField meta:resourcekey="gvShutdown">
                    <ItemStyle Width="9%" HorizontalAlign="Right"/>
                    <ItemTemplate>
                        <asp:LinkButton ID="lbShutdown" CommandName="ShutDown" CommandArgument='<%# Eval("Id")%>' Visible='<%# Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>'
                            runat="server" Text="Shut Down" OnClientClick="if(confirm('Are you sure you want to shut down selected server?')) ShowProgressDialog('Loading...'); else return false;"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
			        <ItemTemplate>
				        <asp:LinkButton ID="lnkInstallCertificate" runat="server" Text="Certificate" Visible='<%# Convert.ToBoolean(Eval("SslAvailable")) && Eval("Status") != null && Eval("Status").ToString().StartsWith("Online") %>'
					        CommandName="InstallCertificate" CommandArgument='<%# Eval("Id") %>' ToolTip="Repair Certificate"
                            OnClientClick="if(confirm('Are you sure you want to install certificate?')) ShowProgressDialog('Installing certificate...'); else return false;"></asp:LinkButton>                        
			        </ItemTemplate>
		        </asp:TemplateField>
                <asp:TemplateField>
			        <ItemTemplate>
				        <asp:LinkButton ID="lnkRemove" runat="server" Text="Remove" Visible='<%# Eval("ItemId") == null %>'
					        CommandName="DeleteItem" CommandArgument='<%# Eval("Id") %>' 
                            meta:resourcekey="cmdDelete" OnClientClick="if(confirm('Are you sure you want to delete selected rds server??')) ShowProgressDialog('Removeing RDS Server...'); else return false;"></asp:LinkButton>                        
			        </ItemTemplate>
		        </asp:TemplateField>
	        </Columns>
        </asp:GridView>        

        <asp:Panel ID="ServerInfoPanel" runat="server" CssClass="Popup" style="display:none">
            <table class="Popup-Header" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="Popup-HeaderLeft"/>
                    <td class="Popup-HeaderTitle">
                        <asp:Localize ID="Localize1" runat="server" meta:resourcekey="headerServerInfo"/>
                    </td>
                    <td class="Popup-HeaderRight"/>
                </tr>
            </table>
            <div class="Popup-Content">
                <div class="Popup-Body">
                    <br />
                    <asp:UpdatePanel ID="serverInfoUpdatePanel" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            <div class="Popup-Scroll" style="height:auto;">
                                <wsp:CollapsiblePanel id="secServerInfo" runat="server" TargetControlID="panelHardwareInfo" meta:resourcekey="secRdsApplicationEdit" Text=""/>                            
                                <asp:Panel runat="server" ID="panelHardwareInfo">
                                    <table>
                                        <tr>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="locProcessor" runat="server" Text="Processor:"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="litProcessor" runat="server"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="locLoadPercentage" Text="Load Percentage:" runat="server"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="litLoadPercentage" runat="server"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="locMemoryAllocated" runat="server" Text="Allocated Memory:"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="litMemoryAllocated" runat="server"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="locFreeMemory" Text="Free Memory:" runat="server"/>
                                            </td>
                                            <td class="FormLabel150" style="width: 150px;">
                                                <asp:Literal ID="litFreeMemory" runat="server"/>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <wsp:CollapsiblePanel id="secRdsApplicationEdit" runat="server" TargetControlID="panelDiskDrives" meta:resourcekey="secRdsApplicationEdit" Text="Disk Drives"/>
                                <asp:Panel runat="server" ID="panelDiskDrives">
                                    <table>
                                        <asp:Repeater ID="rpServerDrives" runat="server" EnableViewState="false">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="litDeviceId" runat="server" Text='<%# Eval("DeviceId") %>'/>
                                                    </td>
                                                    <td class="FormLabel150" style="width: 150px;"/>                                                                                                                                    
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="locVolumeName" Text="Volume Name:" runat="server"/>
                                                    </td>
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="litVolumeName" Text='<%# Eval("VolumeName") %>' runat="server"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="locSize" Text="Size:" runat="server"/>
                                                    </td>
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="litSize" Text='<%# Eval("SizeMb") + " MB" %>' runat="server"/>
                                                    </td>                                                                                                                                    
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="locFreeSpace" Text="Free Space:" runat="server"/>
                                                    </td>
                                                    <td class="FormLabel150" style="width: 150px;">
                                                        <asp:Literal ID="litFreeSpace" Text='<%# Eval("FreeSpaceMb") + " MB" %>' runat="server"/>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </table>
                                </asp:Panel>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <br />
                </div>
                <div class="FormFooter">                
                    <asp:Button ID="btnCancelServerInfo" runat="server" CssClass="Button1" meta:resourcekey="btnServerInfoCancel" Text="Cancel" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Button ID="btnViewInfoFake" runat="server" style="display:none;" />
        <ajaxToolkit:ModalPopupExtender ID="ViewInfoModal" runat="server" TargetControlID="btnViewInfoFake" PopupControlID="ServerInfoPanel" 
            BackgroundCssClass="modalBackground" DropShadow="false" CancelControlID="btnCancelServerInfo"/>
    </ContentTemplate>    
</asp:UpdatePanel>
