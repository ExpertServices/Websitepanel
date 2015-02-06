<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSEditCollectionSettings.ascx.cs" Inherits="WebsitePanel.Portal.RDS.RDSEditCollectionSettings" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSCollectionApps.ascx" TagName="CollectionApps" TagPrefix="wsp"%>
<%@ Register Src="UserControls/RDSCollectionTabs.ascx" TagName="CollectionTabs" TagPrefix="wsp" %>
<%@ Register Src="UserControls/RDSSessionLimit.ascx" TagName="SessionLimit" TagPrefix="wsp" %>
<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgEditRDSCollection" SkinID="EnterpriseStorageSpace48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Edit RDS Collection Settings"></asp:Localize>
                    -
					<asp:Literal ID="litCollectionName" runat="server" Text="" />
				</div>
				<div class="FormBody">
                    <wsp:CollectionTabs id="tabs" runat="server" SelectedTab="rds_edit_collection_settings" />
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />                    

                    <wsp:CollapsiblePanel id="secRdsSessionSettings" runat="server"
                        TargetControlID="panelRdsSessionSettings" meta:resourcekey="secRdsSessionSettings" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsSessionSettings">                                                
                        <div style="padding: 10px;">
                            <table>
                                <tr>
                                    <td class="FormLabel260" colspan="3" style="width:auto;"><asp:Localize ID="locSessionLimitHeader" runat="server" meta:resourcekey="locSessionLimitHeader" Text=""></asp:Localize></td>
                                </tr>
                                <tr>
                                    <td class="Label" style="width:260px;" colspan="2"><asp:Localize ID="locDisconnectedSessionLimit" runat="server" meta:resourcekey="locDisconnectedSessionLimit" Text=""></asp:Localize></td>
                                    <td style="width:250px;">
                                        <wsp:SessionLimit ID="slDisconnectedSessionLimit" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Label" style="width:260px;" colspan="2"><asp:Localize ID="locActiveSessionLimit" runat="server" meta:resourcekey="locActiveSessionLimit" Text=""></asp:Localize></td>
                                    <td>
                                        <wsp:SessionLimit ID="slActiveSessionLimit" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Label" style="width:260px;" colspan="2"><asp:Localize ID="locIdleSessionLimit" runat="server" meta:resourcekey="locIdleSessionLimit" Text=""></asp:Localize></td>
                                    <td>
                                        <wsp:SessionLimit ID="slIdleSessionLimit" runat="server"/>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table>                                
                                <tr>
                                    <td class="FormLabel260" colspan="2" style="width:auto;"><asp:Localize ID="locCollectionBroken" runat="server" meta:resourcekey="locCollectionBroken" Text=""></asp:Localize></td>
                                </tr> 
                                <tr>
                                    <td colspan="2">
                                        <asp:RadioButton ID="chDisconnect" GroupName="collectionBroken" runat="server" Text="Disconnect from the session"/>                                        
                                    </td>
                                </tr>    
                                <tr>
                                    <td style="width:20px;"></td>
                                    <td>
                                        <asp:CheckBox ID="chAutomaticReconnection" Text="Enable automatic reconnection" runat="server"/>
                                    </td>
                                </tr> 
                                <tr>
                                    <td colspan="2">
                                        <asp:RadioButton ID="chEndSession" GroupName="collectionBroken" runat="server" Text="End the session"/>                                        
                                    </td>
                                </tr>                   
                            </table> 
                            <br />
                            <table>                                
                                <tr>
                                    <td class="FormLabel260" colspan="2" style="width:auto;"><asp:Localize ID="locTempFolder" runat="server" meta:resourcekey="locTempFolder" Text=""></asp:Localize></td>
                                </tr> 
                                <tr>
                                    <td>
                                        <asp:CheckBox id="chDeleteOnExit" runat="server" Text="Delete temporary folders on exit"/>
                                    </td>
                                </tr>    
                                <tr>                                   
                                    <td>
                                        <asp:CheckBox ID="chUseFolders" Text="Use temporary folders per session" runat="server"/>
                                    </td>
                                </tr>                   
                            </table>
                        </div>                            
                    </asp:Panel>

                    <wsp:CollapsiblePanel id="secRdsClientSettings" runat="server"
                        TargetControlID="panelRdsClientSettings" meta:resourcekey="secRdsClientSettings" Text="">
                    </wsp:CollapsiblePanel>		
                    
                    <asp:Panel runat="server" ID="panelRdsClientSettings">                                                
                        <div style="padding: 10px;">
                            <table>
                                <tr>
                                    <td class="FormLabel260" colspan="2" style="width:auto;"><asp:Localize ID="locEnableRedirection" runat="server" meta:resourcekey="locEnableRedirection" Text=""></asp:Localize></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chAudioVideo" Text="Audio and video playback" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chAudioRecording" Text="Audio recording" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chSmartCards" Text="Smart cards" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chPlugPlay" Text="Plug and play devices" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chDrives" Text="Drives" runat="server"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chClipboard" Text="Clipboard" runat="server"/>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table>                                
                                <tr>
                                    <td class="FormLabel260" colspan="2" style="width:auto;"><asp:Localize ID="locPrinters" runat="server" meta:resourcekey="locPrinters" Text=""></asp:Localize></td>
                                </tr> 
                                <tr>
                                    <td colspan="2">
                                        <asp:CheckBox ID="chPrinterRedirection" Text="Allow client printer redirection" runat="server"/>
                                    </td>
                                </tr>    
                                <tr>
                                    <td style="width:20px;"></td>
                                    <td>
                                        <asp:CheckBox ID="chDefaultDevice" Text="Use the client default printing device" runat="server"/>
                                    </td>
                                </tr>                   
                                <tr>
                                    <td style="width:20px;"></td>
                                    <td>
                                        <asp:CheckBox ID="chEasyPrint" Text="Use the Remote Desktop Easy Print print driver first " runat="server"/>
                                    </td>
                                </tr>                   
                            </table>                         
                            <br />
                            <table>
                                <tr>
                                    <td class="FormLabel260" colspan="2" style="width:auto;"><asp:Localize ID="locMonitors" runat="server" meta:resourcekey="locMonitors" Text=""></asp:Localize></td>
                                </tr>
                                <tr>
                                    <td class="Label" style="width:260px;"><asp:Localize ID="locMonitorsNumber" runat="server" meta:resourcekey="locMonitorsNumber" Text=""></asp:Localize></td>
                                    <td style="width:250px;">
                                        <asp:TextBox ID="tbMonitorsNumber" runat="server" CssClass="NormalTextBox" />
                                    </td>
                                </tr>                                
                            </table>
                        </div>                            
                    </asp:Panel>

                    <div class="FormFooterClean">
                        <wsp:ItemButtonPanel id="buttonPanel" runat="server" ValidationGroup="SaveRDSCollection" 
                            OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
			        </div>   
				</div>
			</div>
		</div>
	</div>
</div>
