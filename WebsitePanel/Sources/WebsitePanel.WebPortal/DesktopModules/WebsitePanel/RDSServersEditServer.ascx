<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSServersEditServer.ascx.cs" Inherits="WebsitePanel.Portal.RDSServersEditServer" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="UserControls/CollapsiblePanel.ascx" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div class="FormBody">
	<wsp:SimpleMessageBox id="messageBox" runat="server" />
       
    <div class="FormContentRDSConf">           
	    <table>
            <tr>
                <td class="FormLabel260"><asp:Localize ID="locServerName" runat="server" meta:resourcekey="locServerName" Text="Server Fully Qualified Domain Name:"></asp:Localize></td>
			    <td class="FormLabel260">
				    <asp:Label runat="server" ID="lblServerName"/>
			    </td>
		    </tr>
            <tr>
                <td class="FormLabel260"><asp:Localize ID="locServerComments" runat="server" meta:resourcekey="locServerComments" Text="Server Comments:"></asp:Localize></td>
			    <td>
				    <asp:TextBox ID="txtServerComments" runat="server" CssClass="NormalTextBox" Width="300px"></asp:TextBox>                     
			    </td>
		    </tr>
	    </table>

        <wsp:CollapsiblePanel id="secServerInfo" runat="server" TargetControlID="panelHardwareInfo" meta:resourcekey="secServerInfo" IsCollapsed="true" Text=""/>
        <asp:Panel runat="server" ID="panelHardwareInfo">
            <table>
                <tr>
                    <td class="FormLabel150" style="width: 150px;">
                        <asp:Literal ID="locStatus" runat="server" Text="Status:"/>
                    </td>
                    <td class="FormLabel150" style="width: 150px;">
                        <asp:Literal ID="litStatus" runat="server"/>
                    </td>
                    <td/>                        
                    <td/>
                </tr>
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
                      
	<div class="FormFooterRDSConf">
		<asp:Button ID="btnUpdate" runat="server" meta:resourcekey="btnUpdate" Text="Update" CssClass="Button2"
            OnClick="btnUpdate_Click" OnClientClick="ShowProgressDialog('Updating server...');" />
        <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" Text="Cancel"
            CssClass="Button1" OnClick="btnCancel_Click" CausesValidation="False" />
	</div>
</div>
