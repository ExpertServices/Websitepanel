<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CRMUserRoles.ascx.cs"
    Inherits="WebsitePanel.Portal.CRM.CRMUserRoles" %>
<%@ Register Src="../ExchangeServer/UserControls/UserSelector.ascx" TagName="UserSelector"
    TagPrefix="wsp" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox"
    TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport"
    TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server" />
<div id="ExchangeContainer">
    <div class="Module">
        <div class="Left">
        </div>
        <div class="Content">
            <div class="Center">
                <div class="Title">
                    <asp:Image ID="Image1" SkinID="CRMLogo" runat="server" />
                    <asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle"></asp:Localize>
                </div>
                <div class="FormBody">
                    <wsp:SimpleMessageBox id="messageBox" runat="server" />

                    <div>

                        <div>
                            <table>
                                <tr height="23">
                                    <td class="FormLabel150"><asp:Localize runat="server" ID="locDisplayName" meta:resourcekey="locDisplayName" /></td>
                                    <td class="FormLabel150"><asp:Label runat="server" ID="lblDisplayName" /></td>
                                </tr>
                                <tr height="23">
                                    <td class="FormLabel150"><asp:Localize runat="server" ID="locEmailAddress" meta:resourcekey="locEmailAddress"/></td>
                                    <td class="FormLabel150"><asp:Label runat="server" ID="lblEmailAddress" /></td>
                                </tr>
                                <tr height="23">
                                    <td class="FormLabel150"><asp:Localize runat="server" ID="locDomainName" meta:resourcekey="locDomainName"/></td>
                                    <td class="FormLabel150"><asp:Label runat="server" ID="lblDomainName" /></td>
                                </tr>
                                <tr>
                                    <td><asp:Localize runat="server" ID="locState" meta:resourcekey="locState" /></td>
                                    <td><asp:Localize runat="server" ID="locEnabled" meta:resourcekey="locEnabled" /><asp:Localize runat="server" ID="locDisabled" meta:resourcekey="locDisabled" />&nbsp;
                                        <asp:Button runat="server" Text="Activate" CssClass="Button1" ID="btnActive" 
                                            onclick="btnActive_Click" meta:resourcekey="btnActivate" /><asp:Button  CssClass="Button1" runat="server" 
                                            Text="Deactivate" ID="btnDeactivate" onclick="btnDeactivate_Click"  meta:resourcekey="btnDeactivate"/></td>
                                </tr>

                                <tr>
                                    <td class="FormLabel150"><asp:Localize runat="server" meta:resourcekey="locLicenseType" Text="License Type:" /></td>
                                    <td>
                                        <asp:DropDownList ID="ddlLicenseType" runat="server" CssClass="NormalTextBox" AutoPostBack="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>

                            </table>
                            <br />
                        </div>
                        
                        <div>
                            <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="False" EnableViewState="true"
                                Width="100%"  CssSelectorClass="NormalGridView" 
                                AllowPaging="False" AllowSorting="False" DataKeyNames="RoleID" >
                                <Columns>
                                    <asp:TemplateField >
                                        <ItemStyle  HorizontalAlign="Center" ></ItemStyle>
                                        <ItemTemplate >
                                            <asp:CheckBox runat="server" ID="cbSelected" Checked=<%# Eval("IsCurrentUserRole") %> />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="gvRole" DataField="RoleName" 
                                        ItemStyle-Width="100%" />
                                    
                                </Columns>
                            </asp:GridView>
                        </div>
                        <br />

                        <asp:Button runat="server" ID="btnUpdate" Text="Save Changes" meta:resourcekey="btnUpdate"   CssClass="Button1"  onclick="btnUpdate_Click" />
                        <asp:Button runat="server" ID="btnSaveExit" Text="Save Changes and Exit" CssClass="Button1"
		                    meta:resourcekey="btnSaveExit" OnClick="btnSaveExit_Click"></asp:Button>

                    </div>
                    <br />
                </div>
            </div>
        </div>
    </div>
</div>
