// Copyright (c) 2015, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.Web.UI.WebControls;

using WebsitePanel.EnterpriseServer;
using WebsitePanel.WebPortal;
using WebsitePanel.Portal.UserControls;


namespace WebsitePanel.Portal
{
    public partial class OrganizationMenu : OrganizationMenuControl
    {
        private const string PID_SPACE_EXCHANGE_SERVER = "SpaceExchangeServer";

        protected void Page_Load(object sender, EventArgs e)
        {
            ShortMenu = false;
            ShowImg = false;

            // organization
            bool orgVisible = (PanelRequest.ItemID > 0 && Request[DefaultPage.PAGE_ID_PARAM].Equals(PID_SPACE_EXCHANGE_SERVER, StringComparison.InvariantCultureIgnoreCase));

            orgMenu.Visible = orgVisible;

            if (orgVisible)
            {
                MenuItem rootItem = new MenuItem(locMenuTitle.Text);
                rootItem.Selectable = false;

                menu.Items.Add(rootItem);

                //Add "Organization Home" menu item
                MenuItem item = new MenuItem(
                    GetLocalizedString("Text.OrganizationHome"),
                    "",
                    "",
                    PortalUtils.EditUrl("ItemID", PanelRequest.ItemID.ToString(), "organization_home", "SpaceID=" + PanelSecurity.PackageId));

                rootItem.ChildItems.Add(item);

                BindMenu(rootItem.ChildItems);
            }
        }

    }
}
