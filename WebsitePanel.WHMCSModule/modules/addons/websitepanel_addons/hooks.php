<?php if (!defined('WHMCS')) exit('ACCESS DENIED');
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

// WebsitePanel server module core files
require_once(ROOTDIR. '/modules/servers/websitepanel/enterpriseserver.php');

/**
 * WebsitePanel Enterprise Server Client
 * 
 * @author Christopher York
 * @link http://www.websitepanel.net/
 * @access public
 * @name websitepanel_EnterpriseServer
 * @version 3.0.4
 * @package WHMCS
 * @final
 */

/**
 * Handles activating and adding client addons to WebsitePanel
 * 
 * @access public
 * @param array $params WHMCS parameters
 * @throws Exception
 */
function websitepanel_addons_AddonActivation($params)
{    
    // WHMCS server parameters & package parameters
    $userId = $params['userid'];
    $serviceId = $params['serviceid'];
    $addonId = $params['addonid'];
    
    $result = full_query("SELECT h.username AS username, s.ipaddress AS serverip, s.hostname AS serverhostname, s.secure AS serversecure, s.username AS serverusername, s.password AS serverpassword, p.configoption6 AS configoption6, h.id AS serviceid FROM `tblhosting` AS h, `tblservers` AS s, `tblproducts` AS p, `mod_wspaddons` AS w WHERE h.packageid = p.id AND w.whmcs_id = {$addonId} AND h.id = {$serviceId} AND h.server = s.id AND s.type = 'websitepanel'");
    if (mysql_num_rows($result) > 0)
    {
        // Get the results of the query
        $row = mysql_fetch_assoc($result);
        
        // Start processing the users addon
        $username = $row['username'];
        $serverUsername = $row['serverusername'];
        $serverPassword = decrypt($row['serverpassword']);
        $serverPort = $row['configoption6'];
        $serverHost = empty($row['serverhostname']) ? $row['serverip'] : $row['serverhostname'];
        $serverSecure = $row['serversecure'] == 'on' ? TRUE : FALSE;
        
        try
        {
            // Create the WebsitePanel Enterprise Server Client object instance
            $wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
        
            // Get the user's details from WebsitePanel - We need the UserId
            $user = $wsp->getUserByUsername($username);
            if (empty($user))
            {
                throw new Exception("User {$username} does not exist - Cannot allocate addon for unknown user");
            }
            
            // Get the user's package details from WebsitePanel - We need the PackageId
            $package = $wsp->getUserPackages($user['UserId']);
            $packageId = $package['PackageId'];
            
            // Get the associated WebsitePanel addon id
            $results = select_query('mod_wspaddons', 'wsp_id,is_ipaddress', array('whmcs_id' => $addonId));
            $addon = mysql_fetch_array($results);
            $addonPlanId = $addon['wsp_id'];
            $addonIsIpAddress = $addon['is_ipaddress'];
            
            // Add the Addon Plan to the customer's WebsitePanel package / hosting space
            $results = $wsp->addPackageAddonById($packageId, $addonPlanId);
            
            // Check the results to verify that the addon has been successfully allocated
            if ($results['Result'] > 0)
            {
                // If this addon is an IP address addon - attempt to randomly allocate an IP address to the customer's hosting space
                if ($addonIsIpAddress)
                {
                    $wsp->allocatePackageIPAddresses($packageId);
                }
                
                // Add log entry to client log
                logactivity("WebsitePanel Addon - Account {$username} addon successfully completed - Addon ID: {$addonId}", $userId);
            }
            else
            {
                // Add log entry to client log
                throw new Exception("Unknown", $results['Result']);
            }
        }
        catch (Exception $e)
        {
            // Error message to log / return
            $errorMessage = "websitepanel_addons_AddonActivation Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
        
            // Log to WHMCS
            logactivity($errorMessage, $userId);
        }
    }
}

/* Addon Activation - WebsitePanel */
add_hook('AddonActivation', 1, 'websitepanel_addons_AddonActivation');