<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchBox.ascx.cs" Inherits="WebsitePanel.Portal.SearchBox" %>

<script type="text/javascript">
    //<![CDATA[
    $(document).ready(function () {
        $("#tbSearch").keypress(function (e) {
            if (e.keyCode != 13) { // VK_RETURN
                $("#tbSearchText").val('');
                $("#tbObjectId").val('');
                $("#tbPackageId").val('');
            }
        });

        $("#tbSearch").autocomplete({
            zIndex: 100,
            source: function (request, response) {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    data: {
                        term: request.term,
                        fullType: 'Users'
//                        columnType: "'" + $("#ddlFilterColumn").val() + "'"
                    },
                    url: "AjaxHandler.ashx",
                    success: function (data) {
                        response($.map(data, function (item) {
                            return {
                                label: item.TextSearch + " [" + item.ColumnType + "]",
                                code: item
                            };
                        }));
                    }
                })
            },
            select: function (event, ui) {
                var item = ui.item;
                $("#ddlFilterColumn").val(item.code.ColumnType);
                $("#tbSearchFullType").val(item.code.FullType);
                $("#tbSearchText").val(item.code.TextSearch);
                $("#tbObjectId").val(item.code.ItemID);
                $("#tbPackageId").val(item.code.PackageID);
                $("#<%= cmdSearch.ClientID %>").trigger("click");
            }
        });
    });//]]>
</script>

<asp:Panel ID="tblSearch" runat="server" DefaultButton="cmdSearch" CssClass="NormalBold">
<asp:Label ID="lblSearch" runat="server" meta:resourcekey="lblSearch" Visible="false"></asp:Label>

   <table>
        <tr>
            <td>
                <asp:DropDownList ClientIDMode="Static" ID="ddlFilterColumn" runat="server" CssClass="NormalTextBox" resourcekey="ddlFilterColumn" style="display:none">
                </asp:DropDownList>
            </td>
            <td>
                <table cellpadding="0" cellspacing="0" align="right">
                    <tr>
                        <td align="left" class="SearchQuery">
                            <div class="ui-widget">
                                <asp:TextBox
                                    ID="tbSearch"
                                    ClientIDMode="Static"
                                    runat="server"
                                    CssClass="NormalTextBox"
                                    Width="120px"
                                    style="vertical-align: middle; z-index: 100;"
                                >
                                </asp:TextBox>
                                <asp:TextBox
                                    ID="tbSearchFullType"
                                    ClientIDMode="Static"
                                    runat="server"
                                    type="hidden"
                                >
                                </asp:TextBox>
                                <asp:TextBox
                                    ID="tbSearchText"
                                    ClientIDMode="Static"
                                    runat="server"
                                    type="hidden"
                                >
                                </asp:TextBox>
                                <asp:TextBox
                                    ID="tbObjectId"
                                    ClientIDMode="Static"
                                    runat="server"
                                    type="hidden"
                                >
                                </asp:TextBox>
                                <asp:TextBox
                                    ID="tbPackageId"
                                    ClientIDMode="Static"
                                    runat="server"
                                    type="hidden"
                                >
                                </asp:TextBox>
                                <asp:ImageButton
                                    ID="cmdSearch"
                                    runat="server"
                                    SkinID="SearchButton"
                                    CausesValidation="false"
                                    OnClick="cmdSearch_Click"
                                    style="vertical-align: middle;"
                                />                 
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Panel>
