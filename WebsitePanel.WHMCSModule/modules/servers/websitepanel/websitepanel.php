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
require_once(ROOTDIR. '/modules/servers/websitepanel/functions.php');

/**
 * WebsitePanel WHMCS Server Module
 *
 * @author Christopher York
 * @link http://www.websitepanel.net/
 * @access public
 * @name websitepanel
 * @version 3.0.4
 * @package WHMCS
 */

/**
 * Returns the WebsitePanel package / server configuration options
 *
 * @access public
 * @return array
 */
function websitepanel_ConfigOptions()
{
	return array('Package Name' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'Package Name'),
				 'Web Space Quota' => array( 'Type' => 'text', 'Size' => 5, 'Description' => 'MB'),
				 'Bandwidth Limit' => array( 'Type' => 'text', 'Size' => 5, 'Description' => 'MB'),
				 'WebsitePanel Plan ID' => array( 'Type' => 'text', 'Size' => 4, 'Description' => 'WebsitePanel hosting plan id'),
				 'Parent Space ID' => array( 'Type' => 'text', 'Size' => 3, 'Description' => '* SpaceID that all accounts are created under', 'Default' => 1),
				 'Enterprise Server Port' => array( 'Type' => 'text', 'Size' => 5, 'Description' => '* Required', 'Default' => 9002),
				 'Different Potal URL' => array( 'Type' => 'yesno', 'Description' => 'Tick if portal address is different to server address'),
				 'Portal URL' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'Portal URL, with http(s)://, no trailing slash'  ),
				 'Send Account Summary Email' => array( 'Type' => 'yesno', 'Description' => 'Tick to send the "Account Summary" letter' ),
				 'Send Hosting Space Summary Email' => array( 'Type' => 'yesno', 'Description' => 'Tick to send the "Hosting Space Summary" letter'),
				 'Create Mail Account' => array( 'Type' => 'yesno', 'Description' => 'Tick to create mail account' ),
				 'Create FTP Account' => array( 'Type' => 'yesno', 'Description' => 'Tick to create FTP account' ),
				 'Create Temporary Domain' => array( 'Type' => 'yesno', 'Description' => 'Tick to create a temporary domain' ),
				 'Send HTML Email' => array( 'Type' => 'yesno', 'Description' => 'Tick enable HTML email from WebsitePanel' ),
				 'Create Website' => array( 'Type' => 'yesno', 'Description' => 'Tick to create Website' ),
				 'Count Bandwidth / Diskspace' => array( 'Type' => 'yesno', 'Description' => 'Tick to update diskpace / bandwidth in WHMCS'),
				 'Default Pointer' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'The default pointer (hostname) to use when creating a Website' ),
				 'Create DNS Zone' => array( 'Type' => 'yesno', 'Description' => 'Tick to create domain DNS zone'));
}

/**
 * Creates the WebsitePanel user account and package
 * 
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_CreateAccount($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$password = $params['password'];
	$domain = $params['domain'];
	$packageType = $params['type'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
		
	// WebsitePanel API parameters
	$planId = $params['configoption4'];
	$parentPackageId = $params['configoption5'];
	$roleId = (($packageType == 'reselleraccount') ? 2 : 3);
	$htmlMail = ($params['configoption14'] == 'on');
	$sendAccountLetter = ($params['configoption9'] == 'on');
	$sendPackageLetter = ($params['configoption10'] == 'on');
	$createMailAccount = ($params['configoption11'] == 'on');
	$createTempDomain = ($params['configoption13'] == 'on');
	$createFtpAccount = ($params['configoption12'] == 'on');
	$createWebsite = ($params['configoption15'] == 'on');
	$websitePointerName = $params['configoption17'];
	$createZoneRecord = ($params['configoption18'] == 'on');
	
	try
	{
	    // Create the WebsitePanel Enterprise Server Client object instance
	    $wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
	    
	    // Create the user's new account using the CreateUserWizard method
	    $userParams = array('parentPackageId' => $parentPackageId,
	    					'username' => $username,
	    					'password' => $password,
	    					'roleId' => $roleId,
	    					'firstName' => $clientsDetails['firstname'],
	    					'lastname' => $clientsDetails['lastname'],
	    					'email' => $clientsDetails['email'],
	    					'secondaryEmail' => '',
	    					'htmlMail' => $htmlMail,
	    					'sendAccountLetter' => $sendAccountLetter,
	    					'createPackage' => TRUE,
	    					'planId' => $planId,
	    					'sendPackageLetter' => $sendPackageLetter,
	    					'domainName' => $domain,
	    					'tempDomain' => $createTempDomain,
	    					'createWebSite' => $createWebsite,
	    					'createFtpAccount' => $createFtpAccount,
	    					'ftpAccountName' => $username,
	    					'createMailAccount' => $createMailAccount,
	    					'hostName' => $websitePointerName,
	    					'createZoneRecord' => $createZoneRecord);
	    
	    // Execute the CreateUserWizard method
	    $result = $wsp->createUserWizard($userParams);
	    if ($result < 0)
	    {
	    	// Something went wrong
	    	throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
	    }
	    
	    // Log the module call
	    websitepanel_logModuleCall(__FUNCTION__, $params, $result);
	    
	    // Get the newly created user's details from WebsitePanel so we can update the account details completely
	    $user = $wsp->getUserByUsername($username);
	    
	    // Update the user's account details using the previous details + WHMCS's details (address, city, state etc.)
	    $userParams = array('RoleId' => $roleId,
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
				    		'Username' => $username,
				    		'Password' => $password,
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
				    		'HtmlMail' => $htmlMail,
				    		'CompanyName' => $clientsDetails['companyname'],
				    		'EcommerceEnabled' => ($roleId == 2),
				    		'SubscriberNumber' => '');
	    
	    // Execute the UpdateUserDetails method
	    $wsp->updateUserDetails($userParams);
	    
	    // Notify success
	    return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "CreateAccount Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
		
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
		
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Terminates the WebsitePanel user account and package
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_TerminateAccount($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
	
	try
	{
		// Create the WebsitePanel Enterprise Server Client object instance
		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
		
		// Get the user's details from WebsitePanel - We need the userid
		$user = $wsp->getUserByUsername($username);
		if (empty($user))
		{
			throw new Exception("User {$username} does not exist - Cannot terminate account for unknown user");
		}
		
		// Attempt the delete the users account
		$result = $wsp->deleteUser($user['UserId']);
		if ($result < 0)
		{
			// Something went wrong
			throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
		}
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $result);
		
		// Notify success
		return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "TerminateAccount Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
		
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
		
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Suspends the WebsitePanel user account and package
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_SuspendAccount($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
	
	try
	{
		// Create the WebsitePanel Enterprise Server Client object instance
		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
		
		// Get the user's details from WebsitePanel - We need the userid
		$user = $wsp->getUserByUsername($username);
		if (empty($user))
		{
			throw new Exception("User {$username} does not exist - Cannot suspend account for unknown user");
		}
		
		// Change the user's account and package account status
		$result = $wsp->changeUserStatus($user['UserId'], websitepanel_EnterpriseServer::USERSTATUS_SUSPENDED);
		if ($result < 0)
		{
			// Something went wrong
			throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
		}
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $result);
		
		// Notify success
		return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "SuspendAccount Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
		
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
		
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Unsuspends the WebsitePanel user account and package
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_UnsuspendAccount($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
	
	try
	{
		// Create the WebsitePanel Enterprise Server Client object instance
		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
	
		// Get the user's details from WebsitePanel - We need the userid
		$user = $wsp->getUserByUsername($username);
		if (empty($user))
		{
			throw new Exception("User {$username} does not exist - Cannot unsuspend account for unknown user");
		}
	
		// Change the user's account and package account status
		$result = $wsp->changeUserStatus($user['UserId'], websitepanel_EnterpriseServer::USERSTATUS_ACTIVE);
		if ($result < 0)
		{
			// Something went wrong
			throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
		}
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $result);
	
		// Notify success
		return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "UnsuspendAccount Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
	
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
	
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Changes the WebsitePanel user account password
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_ChangePassword($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$password = $params['password'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
	
	try
	{
		// Create the WebsitePanel Enterprise Server Client object instance
		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
	
		// Get the user's details from WebsitePanel - We need the userid
		$user = $wsp->getUserByUsername($username);
		if (empty($user))
		{
			throw new Exception("User {$username} does not exist - Cannot change account password for unknown user");
		}
	
		// Change the user's account password
		$result = $wsp->changeUserPassword($user['UserId'], $password);
		if ($result < 0)
		{
			// Something went wrong
			throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
		}
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $result);
	
		// Notify success
		return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "ChangePassword Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
	
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
	
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Changes the WebsitePanel user hosting package
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_ChangePackage($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverPort = $params['configoption6'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$username = $params['username'];
	$clientsDetails = $params['clientsdetails'];
	$userId = $clientsDetails['userid'];
	$serviceId = $params['serviceid'];
	
	// WebsitePanel API parameters
	$planId = $params['configoption4'];
	$packageName = $params['configoption1'];
	
	try
	{
		// Create the WebsitePanel Enterprise Server Client object instance
		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
	
		// Get the user's details from WebsitePanel - We need the userid
		$user = $wsp->getUserByUsername($username);
		if (empty($user))
		{
			throw new Exception("User {$username} does not exist - Cannot change package for unknown user");
		}

		// Get the user's package details from WebsitePanel - We need the PackageId
		$package = $wsp->getUserPackages($user['UserId']);
		
		// Update the user's WebsitePanel package
		$result = $wsp->updatePackageLiteral($package['PackageId'], $package['StatusId'], $planId, $package['PurchaseDate'], $packageName, $package['PackageComments']);
		if ($result < 0)
		{
			// Something went wrong
			throw new Exception('Fault: ' . websitepanel_EnterpriseServer::getFriendlyError($result), $result);
		}
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $result);
		
		// Notify success
		return 'success';
	}
	catch (Exception $e)
	{
		// Error message to log / return
		$errorMessage = "ChangePackage Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
	
		// Log to WHMCS
		logactivity($errorMessage, $userId);
		
		// Log the module call
		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
	
		// Notify failure - Houston we have a problem!
		return $errorMessage;
	}
}

/**
 * Updates the WHMCS service's usage details from WebsitePanel
 * 
 * @param aray $params WHMCS parameters
 * @throws Exception
 */
function websitepanel_UsageUpdate($params)
{
	// WHMCS server parameters & package parameters
	$serverUsername = $params['serverusername'];
	$serverPassword = $params['serverpassword'];
	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
	$serverSecure = $params['serversecure'];
	$serverId = $params['serverid'];
	$userId = 0;
	$serviceId = 0;
	
	// Query for WebsitePanel user accounts assigned to this server
	// Only services that have packages that have "Tick to update diskpace / bandwidth in WHMCS" enabled
	$result = full_query("SELECT h.id AS serviceid, h.userid AS userid, h.username AS username, h.regdate AS regdate, p.configoption2 AS configoption2, p.configoption3 AS configoption3, p.configoption6 AS configoption6 FROM `tblhosting` AS h, `tblproducts` AS p WHERE h.server = {$serverId} AND h.packageid = p.id AND p.configoption16 = 'on' AND h.domainstatus IN ('Active', 'Suspended')");
	while (($row = mysql_fetch_array($result)) != false)
	{
		// Start processing the users usage
		$username = $row['username'];
		$userId = $row['userid'];
		$serviceId = $row['serviceid'];
		$serverPort = $row['configoption6'];
		
		// Diskspace and Bandwidth limits for this package
		$diskLimit = $row['configoption2'];
		$bwidthLimit = $row['configoption3'];
		
		try
		{
			// Create the WebsitePanel Enterprise Server Client object instance
			$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
			
			// Get the user's details from WebsitePanel - We need the userid
			$user = $wsp->getUserByUsername($username);
			if (empty($user))
			{
				throw new Exception("User {$username} does not exist - Cannot calculate usage for unknown user");
			}
			
			// Get the user's package details from WebsitePanel - We need the PackageId
			$package = $wsp->getUserPackages($user['UserId']);
						
			// Gather the bandwidth / diskspace usage stats
			$bwidthUsage = websitepanel_CalculateUsage($wsp->getPackageBandwidthUsage($package['PackageId'], websitepanel_CreateBandwidthDate($row['regdate']), date('Y-m-d', time())), websitepanel_EnterpriseServer::USAGE_BANDWIDTH);
			$diskUsage = websitepanel_CalculateUsage($wsp->getPackageDiskspaceUsage($package['PackageId']), websitepanel_EnterpriseServer::USAGE_DISKSPACE);
			
			// Update WHMCS's service details
			update_query('tblhosting', array('diskusage' => $diskUsage, 'disklimit' => $diskLimit, 'bwusage' => $bwidthUsage, 'bwlimit' => $bwidthLimit, 'lastupdate' => 'now()'), array('id' => $serviceId));
			
			// Log the module call
			websitepanel_logModuleCall(__FUNCTION__, $params, $package);
		}
		catch (Exception $e)
		{
			// Error message to log / return
			$errorMessage = "UsageUpdate Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
			
			// Log the module call
			websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
			
			// Log to WHMCS
			logactivity($errorMessage, $userId);
		}
	}
}

/**
 * Returns the WebsitePanel one-click login link
 *
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return string
 */
function websitepanel_LoginLink($params)
{
    // WHMCS does not return the full hosting account details, we will query for what we need
    $result = select_query('tblhosting', 'domainstatus', array('id' => $params['serviceid']));
    $results = mysql_fetch_array($result);
    $params['domainstatus'] = $results['domainstatus'];
        
    // Display the link only if the account is Active or Suspended
    if (in_array($params['domainstatus'], array('Active', 'Suspended')))
    {
        // WHMCS server parameters & package parameters
    	$serverUsername = $params['serverusername'];
    	$serverPassword = $params['serverpassword'];
    	$serverPort = $params['configoption6'];
    	$serverHost = (empty($params['serverhostname']) ? $params['serverip'] : $params['serverhostname']);
    	$serverSecure = $params['serversecure'];
    	$username = $params['username'];
    	$serviceId = $params['serviceid'];
    	$clientsDetails = $params['clientsdetails'];
    	$userId = $clientsDetails['userid'];
    	
    	try
    	{
    		// Create the WebsitePanel Enterprise Server Client object instance
    		$wsp = new websitepanel_EnterpriseServer($serverUsername, $serverPassword, $serverHost, $serverPort, $serverSecure);
    	
    		// Get the user's details from WebsitePanel - We need the userid
    		$user = $wsp->getUserByUsername($username);
    		if (empty($user))
    		{
    			throw new Exception("User {$username} does not exist - Cannot display account link for unknown user");
    		}
    		
    		// Load the client area language file
    		$LANG = websitepanel_LoadClientLanguage();
    		
    		// Print the link
    		echo "<a href=\"{$params['configoption8']}/Default.aspx?pid=Home&UserID={$user['UserId']}\" target=\"_blank\" title=\"{$LANG['websitepanel_adminarea_gotowebsitepanelaccount']}\">{$LANG['websitepanel_adminarea_gotowebsitepanelaccount']}</a><br />";
    		
    		// Log the module call
    		websitepanel_logModuleCall(__FUNCTION__, $params, $user);
    	}
    	catch (Exception $e)
    	{
    		// Error message to log / return
    		$errorMessage = "LoginLink Fault: (Code: {$e->getCode()}, Message: {$e->getMessage()}, Service ID: {$serviceId})";
    	
    		// Log to WHMCS
    		logactivity($errorMessage, $userId);
    		
    		// Log the module call
    		websitepanel_logModuleCall(__FUNCTION__, $params, $e->getMessage());
    	}
    }
}

/**
 * Client Area module output for the customer's "My Services" service output
 * 
 * @access public
 * @param array $params WHMCS parameters
 * @throws Exception
 * @return array
 */
function websitepanel_ClientArea($params)
{
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    $password = $params['password'];
    
    // Load the client area language file
    websitepanel_LoadClientLanguage();
    
    // Return template information
    return array('templatefile' => 'clientarea', 'vars' => array('websitepanel_url' => $params['configoption8'], 'username' => $username, 'password' => $password));
}

/**
 * Logs all module calls to the WHMCS module debug logger
 *
 * @access public
 * @param string $function
 * @param mixed $params
 * @param mixed $response
 */
function websitepanel_logModuleCall($function, $params, $response)
{
    // Get the module name
    $callerData = explode('_', $function);
    $module = $callerData[0];
    $action = $callerData[1];

    // Replacement variables
    $replacementVars = array('');

    // Log the call with WHMCS
    logModuleCall($module, $action, $params, $response, '', $replacementVars);
}