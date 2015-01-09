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
 * WebsitePanel WHMCS WebsitePanel / WHMCS Client Contact Details Sync
 *
 * @author Christopher York
 * @link http://www.websitepanel.net/
 * @access public
 * @name websitepanel
 * @version 3.0.4
 * @package WHMCS
 */

/**
 * Handles updating WebsitePanel account details when a client or administrator updates a client's details
 * 
 * @access public
 * @param array $params WHMCS parameters
 * @throws Exception
 */
function websitepanel_sync_ClientEdit($params)
{
    // WHMCS server parameters & package parameters
    $userId = $params['userid'];
    $serviceId = 0;
    
    // Query for the users WebsitePanel accounts - If they do not have any, just ignore the request
    $result = full_query("SELECT h.username AS username, s.ipaddress AS serverip, s.hostname AS serverhostname, s.secure AS serversecure, s.username AS serverusername, s.password AS serverpassword, p.configoption6 AS configoption6, h.id AS serviceid FROM `tblhosting` AS h, `tblservers` AS s, `tblproducts` AS p WHERE h.userid = {$userId} AND h.packageid = p.id AND h.server = s.id AND s.type = 'websitepanel' AND h.domainstatus IN ('Active', 'Suspended')");
    while (($row = mysql_fetch_array($result)) != false)
	{
	    // Start updating the users account details
	    $serviceId = $row['serviceid'];
	    $username = $row['username'];
	    $serverUsername = $row['serverusername'];
	    $serverPassword = decrypt($row['serverpassword']);
	    $serverPort = $row['configoption6'];
	    $serverHost = empty($row['serverhostname']) ? $row['serverip'] : $row['serverhostname'];
	    $serverSecure = $row['serversecure'] == 'on' ? TRUE : FALSE;
	    $clientsDetails = $params;
	    
	    try
	    {
	        // Create the WebsitePanel Enterprise Server Client object instance
	        $wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
	        	
	        // Get the user's details from WebsitePanel - We need the username
	        $user = $wsp->getUserByUsername($username);
	        if (empty($user))
	        {
	            throw new Exception("User {$username} does not exist - Cannot update account details for unknown user");
	        }
	        
	        // Update the user's account details using the previous details + WHMCS's details (address, city, state etc.)
	        $userParams = array('RoleId' => $user['RoleId'],
            	                'Role' => $user['Role'],
            	                'StatusId' => $user['StatusId'],
            	                'Status' => $user['Status'],
            	                'LoginStatusId' => $user['LoginStatusId'],
            	                'LoginStatus' => $user['LoginStatus'],
            	                'FailedLogins' => $user['FailedLogins'],
            	                'UserId' => $user['UserId'],
            	                'OwnerId' => $user['OwnerId'],
            	                'IsPeer' => $user['IsPeer'],
            	                'Created' => $user['Created'],
            	                'Changed' => $user['Changed'],
            	                'IsDemo' => $user['IsDemo'],
            	                'Comments' => $user['Comments'],
            	                'LastName' => $clientsDetails['lastname'],
            	                'Username' => $user['Username'],
            	                'Password' => $user['Password'],
            	                'FirstName' => $clientsDetails['firstname'],
            	                'Email' => $clientsDetails['email'],
            	                'PrimaryPhone' => $clientsDetails['phonenumber'],
            	                'Zip' => $clientsDetails['postcode'],
            	                'InstantMessenger' => '',
            	                'Fax' => '',
            	                'SecondaryPhone' => '',
            	                'SecondaryEmail' => '',
            	                'Country' => $clientsDetails['country'],
            	                'Address' => $clientsDetails['address1'],
            	                'City' => $clientsDetails['city'],
            	                'State' => $clientsDetails['state'],
            	                'HtmlMail' => $user['HtmlMail'],
            	                'CompanyName' => $clientsDetails['companyname'],
            	                'EcommerceEnabled' => $user['EcommerceEnabled'],
            	                'SubscriberNumber' => '');
	         
	        // Execute the UpdateUserDetails method
	        $wsp->updateUserDetails($userParams);
	        
	        // Add log entry to client log
	        logactivity("WebsitePanel Sync - Account {$username} contact details updated successfully", $userId);
	    }
	    catch (Exception $e)
	    {
	        // Error message to log / return
	        $errorMessage = "websitepanel_sync_ClientEdit Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
	        	
	        // Log to WHMCS
	        logactivity($errorMessage, $userId);
	    }
	}
}

/* Update Client Contact Details - WebsitePanel */
add_hook('ClientEdit', 1, 'websitepanel_sync_ClientEdit');