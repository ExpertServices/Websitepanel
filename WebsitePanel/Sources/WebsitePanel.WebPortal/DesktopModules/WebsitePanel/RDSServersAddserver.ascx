<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RDSServersAddserver.ascx.cs" Inherits="WebsitePanel.Portal.RDSServersAddserver" %>
<%@ Register Src="UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>
<script type="text/javascript" src="/JavaScript/jquery.min.js?v=1.4.4"></script>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div class="FormBody">
	<wsp:SimpleMessageBox id="messageBox" runat="server" />
       
    <div class="FormContentRDSConf">           
	    <table>
            <tr>
                <td class="FormLabel260"><asp:Localize ID="locServerName" runat="server" meta:resourcekey="locServerName" Text="Server  Fully Qualified Domain Name:"></asp:Localize></td>
			    <td>
				    <asp:TextBox ID="txtServerName" runat="server" CssClass="NormalTextBox" Width="300px"></asp:TextBox>    
                    <asp:RequiredFieldValidator ID="valServerName" runat="server" ErrorMessage="*" ControlToValidate="txtServerName"></asp:RequiredFieldValidator>                          
			    </td>
		    </tr>
            <tr>
                <td class="FormLabel260"><asp:Localize ID="locServerComments" runat="server" meta:resourcekey="locServerComments" Text="Server Comments:"></asp:Localize></td>
			    <td>
				    <asp:TextBox ID="txtServerComments" runat="server" CssClass="NormalTextBox" Width="300px"></asp:TextBox>                     
			    </td>
		    </tr>
	    </table>
    </div> 
                      
	<div class="FormFooterRDSConf">
		<asp:Button ID="btnAdd" runat="server" meta:resourcekey="btnAdd" Text="Add Server" CssClass="Button2"
            OnClick="btnAdd_Click" OnClientClick="ShowProgressDialog('Adding server...');" />
        <asp:Button ID="btnCancel" runat="server" meta:resourcekey="btnCancel" Text="Cancel"
            CssClass="Button1" OnClick="btnCancel_Click" CausesValidation="False" />
	</div>
</div>

</style>