<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GlobalSearch.ascx.cs" Inherits="WebsitePanel.Portal.SkinControls.GlobalSearch" %>

<style>
    .ui-menu-item a {white-space: nowrap; }
</style>

<script type="text/javascript">
    //<![CDATA[
    $("#<%= tbSearch.ClientID %>").keypress(function (e) {
        if (e.keyCode != 13) { // VK_RETURN
            $("#<%= tbSearchText.ClientID %>").val('');
            $("#<%= tbObjectId.ClientID %>").val('');
            $("#<%= tbPackageId.ClientID %>").val('');
            $("#<%= tbAccountId.ClientID %>").val('');
        }
    });

    $(document).ready(function () {
        $("#<%= tbSearch.ClientID %>").autocomplete({
            zIndex: 100,
            source: function(request, response) {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    data: {
                        term: request.term
                    },
                    url: "AjaxHandler.ashx",
                    success: function(data)
                    {
                        response($.map(data, function (item) {
                            return {
                                label: item.TextSearch + " [" + item.FullType + "]",
                                code: item
                            };
                        }));
                    }
                })
            },
            select: function (event, ui) {
                var item = ui.item;
                $("#<%= tbSearchColumnType.ClientID %>").val(item.code.ColumnType);
                $("#<%= tbSearchFullType.ClientID %>").val(item.code.FullType);
                $("#<%= tbSearchText.ClientID %>").val(item.code.TextSearch);
                $("#<%= tbObjectId.ClientID %>").val(item.code.ItemID);
                $("#<%= tbPackageId.ClientID %>").val(item.code.PackageID);
                $("#<%= tbAccountId.ClientID %>").val(item.code.AccountID);
                var $ImgBtn = $("#<%= ImageButton1.ClientID %>");
                $ImgBtn.trigger("click");
                $ImgBtn.attr('disabled', 'disabled');
            }
        });
    });//]]>
</script>

<asp:Panel runat="server" ID="updatePanelUsers" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
        <table cellpadding="0" cellspacing="0" align="right">
            <tr>
                <td align="left" class="SearchQuery">
                    <div class="ui-widget">
                        <asp:TextBox
                            ID="tbSearch"
                            runat="server"
                            CssClass="NormalTextBox"
                            Width="120px"
                            style="vertical-align: middle; z-index: 100;"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbSearchColumnType"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbSearchFullType"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbSearchText"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbObjectId"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbPackageId"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>
                        <asp:TextBox
                            ID="tbAccountId"
                            runat="server"
                            type="hidden"
                        >
                        </asp:TextBox>

                        <asp:ImageButton
                            ID="ImageButton1"
                            runat="server"
                            SkinID="SearchButton"
                            OnClick="btnSearchObject_Click"
                            CausesValidation="false"
                            style="vertical-align: middle;"
                        />                 
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:Panel>
