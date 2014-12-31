<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExchangeDomainNames.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.ExchangeDomainNames" %>
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
				</div>
				<div class="FormBody">
				    <wsp:SimpleMessageBox id="messageBox" runat="server" />
				    
                    <div class="FormButtonsBarClean">
                        <asp:Button ID="btnAddDomain" runat="server" meta:resourcekey="btnAddDomain"
                            Text="Add New Domain" CssClass="Button1" OnClick="btnAddDomain_Click" />
                    </div>

				    <asp:GridView ID="gvDomains" runat="server" AutoGenerateColumns="False" EnableViewState="true"
					    Width="100%" EmptyDataText="gvDomains" CssSelectorClass="NormalGridView" OnRowCommand="gvDomains_RowCommand">
					    <Columns>
						    <asp:TemplateField HeaderText="gvDomainsName">
							    <ItemStyle Width="50%"></ItemStyle>
							    <ItemTemplate>
								    <asp:hyperlink id="lnkEditZone" runat="server" EnableViewState="false"
									    NavigateUrl='<%# GetDomainRecordsEditUrl(Eval("DomainID").ToString()) %>' Enabled="true">
									    <%# Eval("DomainName") %>
								    </asp:hyperlink>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="gvDomainsType">
							    <ItemTemplate>
							        <div style="text-align:center">
								        <asp:Label ID="Label1" Text='<%# Eval("DomainType") %>' runat="server"/>
								    </div>
							    </ItemTemplate>
						    </asp:TemplateField>
                             <asp:TemplateField HeaderText="gvDomainsTypeChange">
							    <ItemTemplate>
							        <div style="text-align:center">
								        <asp:Button ID="btnChangeDomain" text="Change" meta:resourcekey="btnChangeDomain" runat="server" CommandName="Change" CommandArgument='<%# Eval("DomainId") + "|" + Eval("DomainType") %>'/>
								    </div>
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField HeaderText="gvDomainsDefault">
							    <ItemTemplate>
							        <div style="text-align:center">
								        <input type="radio" name="DefaultDomain" value='<%# Eval("DomainId") %>' <%# IsChecked((bool)Eval("IsDefault")) %> />
								    </div>
							    </ItemTemplate>
						    </asp:TemplateField>                            
						    <asp:TemplateField>
							    <ItemTemplate>
									&nbsp;<asp:ImageButton ID="imgDelDomain" runat="server" Text="Delete" SkinID="ExchangeDelete"
									    CommandName="DeleteItem" CommandArgument='<%# Eval("DomainId") %>' Visible='<%# ((!(bool)Eval("IsDefault"))) && (!CheckDomainUsedByHostedOrganization(Eval("DomainID").ToString())) %>'
									    meta:resourcekey="cmdDelete" OnClientClick="return confirm('Are you sure you want to delete selected domain?')"
                                        />
                                    &nbsp;<asp:LinkButton ID="lnkViewUsage" runat="server" Text="View Usage" Visible='<%# CheckDomainUsedByHostedOrganization(Eval("DomainID").ToString()) %>'
                                        CommandName="ViewUsage" CommandArgument='<%# Eval("DomainId") %>'
                                         />
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
				    </asp:GridView>
				    <br />
				    <div style="text-align: center">
				        <asp:Button ID="btnSetDefaultDomain" runat="server" meta:resourcekey="btnSetDefaultDomain"
                            Text="Set Default Domain" CssClass="Button1" OnClick="btnSetDefaultDomain_Click" />
                    </div>
                    
				    <br />
				    <asp:Localize ID="locQuota" runat="server" meta:resourcekey="locQuota" Text="Total Domains Used:"></asp:Localize>
				    &nbsp;&nbsp;&nbsp;
				    <wsp:QuotaViewer ID="domainsQuota" runat="server" QuotaTypeId="2" />
				    
				    
				</div>
			</div>
		</div>
	</div>
</div>