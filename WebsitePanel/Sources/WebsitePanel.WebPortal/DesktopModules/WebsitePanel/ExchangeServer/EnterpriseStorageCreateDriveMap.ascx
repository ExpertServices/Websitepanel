<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageCreateDriveMap.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.EnterpriseStorageCreateDriveMap" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EmailAddress.ascx" TagName="EmailAddress" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="imgESDM" SkinID="EnterpriseStorageDriveMaps48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Create New Drive Map"></asp:Localize>
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
                  
					<table>
					    <tr>
						    <td class="FormLabel150"><asp:Localize ID="locDriveLetter" runat="server" meta:resourcekey="locDriveLetter" Text="Select Drive Letter:"></asp:Localize></td>
						    <td>
							    <asp:DropDownList ID="ddlLetters" runat="server" CssClass="NormalTextBox" Width="150px" style="vertical-align: middle;" />
						    </td>
					    </tr>
                        <tr>
							<td class="FormLabel150"><asp:Localize ID="locFolder" runat="server" meta:resourcekey="locFolder" Text="Storage Folder:"></asp:Localize></td>
							<td> 
                                <div class="Folders" style="display:inline;">
                                    <asp:DropDownList ID="ddlFolders" runat="server" CssClass="NormalTextBox" Width="150px" style="vertical-align: middle;" />                    
                                </div>
                                <div class="Url" style="display:inline;">
                                    <asp:Literal ID="lbFolderUrl" runat="server"></asp:Literal>
                                </div>
							</td>
						</tr>
                        <tr>
                            <td class="FormLabel150"><asp:Localize ID="locDriveLabel" runat="server" meta:resourcekey="locDriveLabel" Text="Label As:"></asp:Localize></td>
						    <td>
                                <div class="LabelAs">
							        <asp:TextBox ID="txtLabelAs" runat="server" CssClass="NormalTextBox" Width="145px"></asp:TextBox>
                                </div>
						    </td>
					    </tr>
					</table> 
                      
				    <div class="FormFooterClean">
					    <asp:Button id="btnCreate" runat="server" Text="Create Drive Map" CssClass="Button1" meta:resourcekey="btnCreate" ValidationGroup="CreateDriveMap" OnClick="btnCreate_Click"></asp:Button>
					    <asp:ValidationSummary ID="valSummary" runat="server" ShowMessageBox="True" ShowSummary="False" ValidationGroup="CreateDriveMap" />
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" >
    $('document').ready(function () {
        $('.LabelAs input').bind('click', function () { $('.LabelAs input').val(""); });

        $('.LabelAs input').bind('focusout', function () {
            if ($('.LabelAs input').val() == "") {
                $('.LabelAs input').val($('.Folders select option:selected').text());
            }
        });

        $('.Folders select').bind('change', function () {
            $('.LabelAs input').val($('.Folders select option:selected').text());
            $('.Url').text($('.Folders select option:selected').val());
        });
    });
</script>