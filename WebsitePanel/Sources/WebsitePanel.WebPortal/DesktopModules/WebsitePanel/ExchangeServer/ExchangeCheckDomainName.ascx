<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeCheckDomainName.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeCheckDomainName" %>
<%@ Register Src="../UserControls/SimpleMessageBox.ascx" TagName="SimpleMessageBox" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/QuotaViewer.ascx" TagName="QuotaViewer" TagPrefix="wsp" %>
<%@ Register Src="../UserControls/EnableAsyncTasksSupport.ascx" TagName="EnableAsyncTasksSupport" TagPrefix="wsp" %>

<wsp:EnableAsyncTasksSupport id="asyncTasks" runat="server"/>

<div id="ExchangeContainer">
	<div class="Module">
		<div class="Left">
		</div>
		<div class="Content">
			<div class="Center">
				<div class="Title">
					<asp:Image ID="Image1" SkinID="ExchangeDomainName48" runat="server" />
					<asp:Localize ID="locTitle" runat="server" meta:resourcekey="locTitle" Text="Domain Names"></asp:Localize>
					-
					<asp:Literal ID="litDomainName" runat="server"></asp:Literal>
				</div>

				<asp:Literal ID="TopComments" runat="server" meta:resourcekey="TopComments"></asp:Literal>

				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    <br />

				    <asp:GridView ID="gvObjects" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" CssSelectorClass="NormalGridView" OnRowCommand="gvObjects_RowCommand">
					    <Columns>
						    <asp:TemplateField HeaderText="gvObjectsDisplayName">
							    <ItemStyle Width="40%"></ItemStyle>
							    <ItemTemplate>
							        <asp:Image ID="img1" runat="server" ImageUrl='<%# GetObjectImage(Eval("ObjectName").ToString(),(int)Eval("ObjectType")) %>' ImageAlign="AbsMiddle" />
								    <asp:hyperlink id="lnk1" runat="server"
									    NavigateUrl='<%# GetEditUrl(Eval("ObjectName").ToString(),(int)Eval("ObjectType"),Eval("ObjectID").ToString()) %>'>
									    <%# Eval("DisplayName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvObjectsObjectType">
							    <ItemStyle Width="40%"></ItemStyle>
							    <ItemTemplate>							        
									<%# GetObjectType(Eval("ObjectName").ToString(),(int)Eval("ObjectType")) %>
							    </ItemTemplate>
						    </asp:TemplateField>

						    <asp:TemplateField HeaderText="gvObjectsView">
							    <ItemStyle Width="10%"></ItemStyle>
							    <ItemTemplate>	
								    <asp:hyperlink id="lnk2" runat="server"
									    NavigateUrl='<%# GetEditUrl(Eval("ObjectName").ToString(),(int)Eval("ObjectType"),Eval("ObjectID").ToString()) %>'>
									    <asp:Literal id="lnkView" runat="server" Text="View" meta:resourcekey="lnkView" />
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>

						    <asp:TemplateField HeaderText="gvObjectsDelete">
							    <ItemStyle Width="10%"></ItemStyle>
							    <ItemTemplate>							        
                                    <asp:LinkButton id="lnkDelete" runat="server" Text="Delete" meta:resourcekey="lnkDelete" 
                                        OnClientClick="return confirm('Are you sure you want to delete ?')"
                                        CommandName="DeleteItem" CommandArgument='<%# Eval("ObjectType").ToString() + "," + Eval("DisplayName") %>'
                                        Visible='<%# AllowDelete(Eval("ObjectName").ToString(), (int)Eval("ObjectType")) %>' />
							    </ItemTemplate>
						    </asp:TemplateField>


					    </Columns>
				    </asp:GridView>


				    <br />
                    <asp:Button id="btnBack" runat="server" Text="Back" CssClass="Button1" meta:resourcekey="btnBack" 
                        OnClick="btnBack_Click" ></asp:Button>

				    
				</div>
			</div>
		</div>
	</div>
</div>