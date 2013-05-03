<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditFeedsList.ascx.cs" Inherits="WebsitePanel.Portal.UserControls.EditFeedsList" %>
<div style="width:100%;">
	<div class="FormButtonsBar">
		<asp:Button id="btnAddFeed" runat="server" meta:resourcekey="btnAddFeed" Text="Add"
			CssClass="Button2" CausesValidation="false" OnClick="BtnAddClick"/>
	</div>

	<asp:GridView id="gvFeeds" Runat="server" AutoGenerateColumns="False"
		CssSelectorClass="NormalGridView"
		OnRowCommand="ListRowCommand" OnRowDataBound="ListRowDataBound"
		EmptyDataText="gvFeeds" ShowHeader="False">
		<columns>
			<asp:TemplateField HeaderText="gvFeedsLabel" ItemStyle-Wrap="false">
				<itemtemplate>
					<asp:Label id="lblFeedName" Runat="server"></asp:Label>
				</itemtemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="gvFeedsName" ItemStyle-Width="100%">
				<itemtemplate>
					<asp:TextBox id="txtFeedName" Runat="server" Width="95%" CssClass="NormalTextBox">
					</asp:TextBox>
					<asp:RegularExpressionValidator id="valCorrectFeedName" runat="server" CssClass="NormalBold"
						ValidationExpression="^(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?$"
						ErrorMessage="&nbsp;*" ControlToValidate="txtFeedName" Display="Dynamic"></asp:RegularExpressionValidator>
				</itemtemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<itemtemplate>
					<asp:ImageButton ID="cmdDeleteFeed" runat="server" SkinID="DeleteSmall"
						CommandName="delete_item" CausesValidation="false"
						meta:resourcekey="cmdDeleteFeed"></asp:ImageButton>
				</itemtemplate>
				<ItemStyle HorizontalAlign="Center" />
			</asp:TemplateField>
		</columns>
	</asp:GridView>

</div>