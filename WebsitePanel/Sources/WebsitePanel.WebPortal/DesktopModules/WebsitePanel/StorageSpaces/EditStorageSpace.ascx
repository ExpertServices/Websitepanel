<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditStorageSpace.ascx.cs" Inherits="WebsitePanel.Portal.StorageSpaces.EditStorageSpace" %>



<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<%@ Register TagPrefix="wsp" TagName="CollapsiblePanel" Src="../UserControls/CollapsiblePanel.ascx" %>
<%@ Register Src="../UserControls/ItemButtonPanel.ascx" TagName="ItemButtonPanel" TagPrefix="wsp" %>
<%@ Register Src="UserControls/StorageSpaceLevelResourceGroups.ascx" TagName="ResourceGroups" TagPrefix="wsp" %>


<wsp:EnableAsyncTasksSupport ID="asyncTasks" runat="server" />

<div class="Content">
    <div class="Center">
        <div class="FormBody">
            <wsp:SimpleMessageBox ID="messageBox" runat="server" />

            <wsp:CollapsiblePanel ID="colStorageSpaceGeneralSettings" runat="server"
                TargetControlID="panelStorageSpaceGeneralSettings" meta:ResourceKey="colStorageSpaceGeneralSettings"></wsp:CollapsiblePanel>

            <asp:Panel runat="server" ID="panelStorageSpaceGeneralSettings">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div style="padding: 10px;">
                            <table>
                                <tr>
                                    <td class="Label" style="width: 260px;">
                                        <asp:Localize ID="locName" runat="server" meta:resourcekey="locName"></asp:Localize>
                                    </td>
                                    <td style="width: 250px;">
                                        <asp:TextBox ID="txtName" runat="server" CssClass="HugeTextBox200" />
                                        <asp:RequiredFieldValidator runat="server" ID="valReqTxtName" ControlToValidate="txtName" meta:resourcekey="valReqTxtName" ErrorMessage="*" ValidationGroup="SaveSpaceStorage" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SubHead" style="width: 200px;">
                                        <asp:Localize ID="lblStorageService" runat="server" meta:resourcekey="lblStorageService" />
                                    <td style="width: 200px;">
                                        <asp:DropDownList ID="ddlStorageService" runat="server" CssClass="HugeTextBox200" OnSelectedIndexChanged="ddlStorageService_OnSelectedIndexChanged" AutoPostBack="True" />
                                        <asp:RequiredFieldValidator ID="valReqStorageService" runat="server" meta:resourcekey="valReqStorageService" ControlToValidate="ddlStorageService"
                                            ErrorMessage="Please select storage space service" ValidationGroup="SaveSpaceStorage" Display="Dynamic" Text="*" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Label" style="width: 260px;">
                                        <asp:Localize ID="locPath" runat="server" meta:resourcekey="locPath"></asp:Localize>
                                    </td>
                                    <td style="width: 250px;">
                                        <asp:TreeView ID="FoldersTree" runat="server" OnTreeNodePopulate="FoldersTree_OnTreeNodePopulate" />
                                        <asp:CustomValidator ID="valRequireFolder" runat="server" meta:resourcekey="valRequireFolder"
                                            ErrorMessage="sym" Text="Please select a folder" Display="Dynamic" ValidationGroup="SaveSpaceStorage"
                                            ClientValidationFunction="ClientValidateTreeView" OnServerValidate="valRequireFolder_ServerValidate"></asp:CustomValidator>
                                        <asp:CustomValidator ID="valPathIsInUse" runat="server" meta:resourcekey="valPathIsInUse"
                                            ErrorMessage="sym" Text="Path is already in use" Display="Dynamic" ValidationGroup="SaveSpaceStorage"
                                            OnServerValidate="valPathIsInUseFolder_ServerValidate"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="SubHead" style="width: 200px;">
                                        <asp:Localize ID="lblSsLevel" runat="server" meta:resourcekey="lblSsLevel" />
                                    <td style="width: 200px;">
                                        <asp:DropDownList ID="ddlSsLevel" runat="server" CssClass="HugeTextBox200" />
                                        <asp:RequiredFieldValidator ID="valReqSsLevel" runat="server" meta:resourcekey="valReqSsLevel" ControlToValidate="ddlSsLevel"
                                            ErrorMessage="Please select storage space level" ValidationGroup="SaveSpaceStorage" Display="Dynamic" Text="*" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Label">
                                        <asp:Localize ID="locStorageSize" runat="server" meta:resourcekey="locStorageSize" Text="Storage Limit Size (Gb):"></asp:Localize></td>
                                    <td>
                                        <asp:TextBox ID="txtStorageSize" runat="server" CssClass="HugeTextBox200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="valRequireFolderSize" runat="server" meta:resourcekey="valRequireStorageSize" ControlToValidate="txtStorageSize"
                                            ErrorMessage="Enter Storage Size" ValidationGroup="SaveSpaceStorage" Display="Dynamic" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rangeStorageSize" runat="server" ControlToValidate="txtStorageSize" meta:resourcekey="rangeStorageSize" MaximumValue="99999999" MinimumValue="0.01" Type="Double"
                                            ValidationGroup="SaveSpaceStorage" Display="Dynamic" Text="*" SetFocusOnError="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Label">
                                        <asp:Localize ID="locQuotaType" runat="server" meta:resourcekey="locQuotaType" Text="Quota Type:"></asp:Localize></td>
                                    <td class="FormRBtnL">
                                        <asp:RadioButton ID="rbtnQuotaSoft" runat="server" meta:resourcekey="rbtnQuotaSoft" Text="Soft" GroupName="QuotaType" Checked="true" />
                                        <asp:RadioButton ID="rbtnQuotaHard" runat="server" meta:resourcekey="rbtnQuotaHard" Text="Hard" GroupName="QuotaType" />
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

            </asp:Panel>

            <div class="FormFooterClean">
                <wsp:ItemButtonPanel ID="buttonPanel" runat="server" ValidationGroup="SaveSpaceStorage"
                    OnSaveClick="btnSave_Click" OnSaveExitClick="btnSaveExit_Click" />
            </div>
        </div>
    </div>
</div>


<script type="text/javascript"> 
   // if you use jQuery, you can load them when dom is read.
   $(document).ready(function () {
       var prm = Sys.WebForms.PageRequestManager.getInstance();    
       prm.add_endRequest(EndRequest);
    });        


    function EndRequest(sender, args) {
        CloseProgressDialog();
    }
</script> 