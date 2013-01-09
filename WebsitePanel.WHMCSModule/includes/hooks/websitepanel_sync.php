<?php if (!defined('WHMCS')) exit('ACCESS DENIED');
// Copyright (c) 2012, Outercurve Foundation.
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

/**
 * WebsitePanel Sync Hook
 *
 * @author Christopher York
 * @package WebsitePanel Sync Hook
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

/**
 * websitepanel_sync_ClientEdit
 *
 * @access public
 * @param array $params
 */
function websitepanel_sync_ClientEdit($params)
{
    // Sanity check - Check if client has any active WebsitePanel hosting packages
    $results = full_query("SELECT h.userid AS `userid` FROM `tblhosting` AS h, `tblservers` AS s WHERE h.userid = {$params['userid']} AND h.server = s.id AND s.type = 'websitepanel'");
    if (mysql_num_rows($results) > 0)
    {
        // Include the WebsitePanel ES Class
        require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.class.php');
        
        // Retrieve the WebsitePanel Addons module settings
        $modSettings = websitepanel_sync_GetSettings();
        if (empty($modSettings['username']) || empty($modSettings['password']) || empty($modSettings['serverhost']) || empty($modSettings['serverport']))
        {
            // The module is disabled or has not yet been configured - stop
            return;
        }
        
        // Create the WebsitePanel object instance
        $wsp = new WebsitePanel($modSettings['username'], $modSettings['password'], $modSettings['serverhost'], $modSettings['serverport'], (($modSettings['serversecured']) == 'on' ? TRUE : FALSE));
        
        // Get all WSP users with the old email
        $items = (array)$wsp->get_users_paged_recursive(1, 'Email', $params['olddata']['email'], 0, 0, '');
                
        // Load / parse the XML response
        $xml = simplexml_load_string($items['any']);
        $rootPath = $xml->NewDataSet;
        
        // Total number of elements to update
        $total = $rootPath->Table->Column1;
        
        // Begin updating WebsitePanel accounts
        for ($i = 0; $i < $total; $i++)
        {
            // Set the current root element and get the users details from WebsitePanel
            // We cannot use the details provided by the get_users_paged_recursive method as it does not return all the required elements to fully update the user
            $currentRoot = $rootPath->Table1->$i;
            $userDetails = (array)$wsp->get_user_by_username($currentRoot->Username);
            
            // Update the current user
            $wsp->update_user_details($userDetails['RoleId'], (($userDetails['RoleId'] == 2) ? 'Reseller' : 'User'), $userDetails['StatusId'], $userDetails['Status'], $userDetails['LoginStatusId'], $userDetails['LoginStatus'], $userDetails['FailedLogins'], $userDetails['UserId'], $userDetails['OwnerId'], $userDetails['Created'], $userDetails['Changed'], $userDetails['IsDemo'], $userDetails['IsPeer'], $currentRoot->Comments, $userDetails['Username'], $userDetails['Password'], $params['firstname'], $params['lastname'], $params['email'], $params['phonenumber'], $params['postcode'], '', '', '', '', $params['country'], $params['address1'] . (!empty($params['address2']) ? " {$params['address2']}" : ''), $params['city'], $params['state'], TRUE, $params['companyname'], (($userDetails['RoleId'] == 2) ? TRUE : FALSE));
            
            // Add log entry to client log
            logactivity("WebsitePanel Sync - Account {$currentRoot->Username} contact details updated successfully", $params['userid']);
        }
    }
}

/* Update Client Contact Details - WebsitePanel */
add_hook('ClientEdit', 1, 'websitepanel_sync_ClientEdit');

/**
 * websitepanel_addons_GetSettings
 *
 * @access public
 * @return array
 */
function websitepanel_sync_GetSettings()
{
    $settings = array();

    // Retrieve the settings from the modules configuration table
    $results = select_query('tbladdonmodules', 'setting,value', array('module' => 'websitepanel_sync'));
    while (($row = mysql_fetch_array($results)) != false)
    {
        $settings[$row['setting']] = $row['value'];
    }
    return $settings;
}