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
 * WHMCS WebsitePanel Server Module
 * 
 * Tested with WHMCS v5.1.3 - however this should work for all v5 releases.
 * DO NOT contact WHMCS for support with this module, they will not provide
 * you any support for this. This should replace the default WHMCS WebsitePanel
 * server module, however I HIGHLY RECOMMEND that you backup the stock WebsitePanel
 * server module.
 * 
 * THIS IS PROVIDED AS IS AND WITHOUT WARRANTY! I TAKE NO RESPOSIBILITY FOR
 * ERRORS, MISUSE, EXCEPTIONS, LOSS OF DATA, LOSS OF LIFE, PLANETS NOT ALIGNING
 * PROPERLY, ALIEN ABDUCTIONS AND ANYTHING ELSE THAT CAN OR MAY HAPPEN FROM
 * USING THIS! BY INSTALLING AND USING THIS YOU AGREE TO TAKE FULL RESPOSNBILITY
 * FOR ANY AND ALL THINGS!
 * 
 * @author Christopher York
 * @package WHMCS Server Module
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

/****************************************************************************/
// WebsitePanel WHMCS Server Module Configuration / Commands
/****************************************************************************/
require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.class.php');
require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.errorcodes.php');
require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.functions.php');

/**
 * websitepanel_ConfigOptions()
 *
 * @access public
 * @return array
 */
function websitepanel_ConfigOptions()
{
    $configarray = array('Package Name' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'Package Name'),
                         'Web Space Quota' => array( 'Type' => 'text', 'Size' => 5, 'Description' => 'MB'),
                         'Bandwidth Limit' => array( 'Type' => 'text', 'Size' => 5, 'Description' => 'MB'),
                         'Plan ID' => array( 'Type' => 'text', 'Size' => 4, 'Description' => 'WebsitePanel hosting plan id'),
                         'Parent Space ID' => array( 'Type' => 'text', 'Size' => 3, 'Description' => '* SpaceID that all accounts are created under', 'Default' => 1),
                         'Enterprise Server Port' => array( 'Type' => 'text', 'Size' => 5, 'Description' => '* Required', 'Default' => 9002),
                         'Different Potal URL' => array( 'Type' => 'yesno', 'Description' => 'Tick if portal address is different to server address'),
                         'Portal URL' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'Portal URL, with http://, no trailing slash'  ),
                         'Send Account Summary Email' => array( 'Type' => 'yesno', 'Description' => 'Tick to send the "Account Summary" letter' ),
                         'Send Hosting Space Summary Email' => array( 'Type' => 'yesno', 'Description' => 'Tick to send the "Hosting Space Summary" letter'),
                         'Create Mail Account' => array( 'Type' => 'yesno', 'Description' => 'Tick to create mail account' ),
                         'Create FTP Account' => array( 'Type' => 'yesno', 'Description' => 'Tick to create FTP account' ),
                         'Create Temporary Domain' => array( 'Type' => 'yesno', 'Description' => 'Tick to create a temporary domain' ),
                         'Send HTML Email' => array( 'Type' => 'yesno', 'Description' => 'Tick enable HTML email from WebsitePanel' ),
                         'Create Website' => array( 'Type' => 'yesno', 'Description' => 'Tick to create Website' ),
                         'Count Bandwidth / Diskspace' => array( 'Type' => 'yesno', 'Description' => 'Tick to update diskpace / bandwidth in WHMCS'),
                         'Default Pointer' => array( 'Type' => 'text', 'Size' => 25, 'Description' => 'The default pointer (hostname) to use when creating a Website' ),
                         'Create DNS Zone' => array( 'Type' => 'yesno', 'Description' => 'Tick to create domain DNS zone' )
    );
    return $configarray;
}

/**
 * websitepanel_CreateAccount()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_CreateAccount($params)
{    
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);
    
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    $password = $params['password'];
    $accountid = $params['accountid'];
    $packageid = $params['packageid'];
    $domain = $params['domain'];
    $packagetype = $params['type'];
    $clientsdetails = $params['clientsdetails'];
    
    // WebsitePanel API parameters
    $planId = $params['configoption4'];
    $parentPackageId = $params['configoption5'];
    $roleId = ($packagetype == 'reselleraccount') ? 2 : 3;
    $htmlMail = ($params['configoption14'] == 'on') ? TRUE : FALSE;
    $sendAccountLetter = ($params['configoption9'] == 'on') ? TRUE : FALSE;
    $sendPackageLetter = ($params['configoption10'] == 'on') ? TRUE : FALSE;
    $createMailAccount = ($params['configoption11'] == 'on') ? TRUE : FALSE;
    $createTempDomain = ($params['configoption13'] == 'on') ? TRUE : FALSE;
    $createFtpAccount = ($params['configoption12'] == 'on') ? TRUE : FALSE;
    $createWebsite = ($params['configoption15'] == 'on') ? TRUE : FALSE;
    $websitePointerName = $params['configoption17'];
    $createZoneRecord = ($params['configoption18'] == 'on') ? TRUE : FALSE;
    
    try
    {
        // Attempt to create the WSP user account and his / her package / hosting space
        $result = $wsp->create_user_wizard($username, $password, $roleId, $clientsdetails['firstname'], $clientsdetails['lastname'], $clientsdetails['email'], $planId, $parentPackageId, $domain, $websitePointerName, $htmlMail, $sendAccountLetter, $sendPackageLetter, TRUE, $createTempDomain, $createWebsite, $createFtpAccount, $username, $createMailAccount, $createZoneRecord);
        if ($result >= 0)
        {
            // Grab the user's details from WebsitePanel
            $user = $wsp->get_user_by_username($username);
            
            // Update the user's account with his / her WHMCS contact details
            $wsp->update_user_details($user['RoleId'], $user['Role'], $user['StatusId'], $user['Status'], $user['LoginStatusId'], $user['LoginStatus'], $user['FailedLogins'], $user['UserId'], $user['OwnerId'], $user['Created'], $user['Changed'], $user['IsDemo'], $user['IsPeer'], $user['Comments'], $username, $password, $clientsdetails['firstname'], $clientsdetails['lastname'], $clientsdetails['email'], $clientsdetails['phonenumber'], $clientsdetails['postcode'], '', '', '', '', $clientsdetails['country'], $clientsdetails['address1'], $clientsdetails['city'], $clientsdetails['state'], $htmlMail, $clientsdetails['companyname'], (($roleId == 2) ? TRUE : FALSE));
            
            // Success - Alert WHMCS
            return 'success';
        }
        else
        {
            // Failed - Alert WHMCS of the returned Enterprise Server error code
            return websitepanel_GetErrorMessage($result);
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_TerminateAccount()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_TerminateAccount($params)
{
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);
    
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    
    try
    {
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return "The specified user {$username} does not exist";
        }
        else
        {
            // Attempt to delete the users account and package / hosting space
            $result = $wsp->delete_user($user['UserId']);
            if ($result >= 0)
            {            
                // Success - Alert WHMCS
                return 'success';
            }
            else
            {
                // Failed - Alert WHMCS of the returned Enterprise Server error code
                return websitepanel_GetErrorMessage($result);
            }
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_SuspendAccount()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_SuspendAccount($params)
{
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);
    
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    
    try
    {
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return "The specified user {$username} does not exist";
        }
        else
        {
            // Attempt to suspend the users account and package / hosting space
            $result = $wsp->change_user_status($user['UserId'], WebsitePanel::USERSTATUS_SUSPENDED);
            if ($result >= 0)
            {            
                // Success - Alert WHMCS
                return 'success';
            }
            else
            {
                // Failed - Alert WHMCS of the returned Enterprise Server error code
                return websitepanel_GetErrorMessage($result);
            }
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_UnsuspendAccount()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_UnsuspendAccount($params)
{
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);

    // WHMCS server parameters & package parameters
    $username = $params['username'];

    try
    {
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return "The specified user {$username} does not exist";
        }
        else
        {
            // Attempt to activate the users account and package / hosting space
            $result = $wsp->change_user_status($user['UserId'], WebsitePanel::USERSTATUS_ACTIVE);
            if ($result >= 0)
            {
                // Success - Alert WHMCS
                return 'success';
            }
            else
            {
                // Failed - Alert WHMCS of the returned Enterprise Server error code
                return websitepanel_GetErrorMessage($result);
            }
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_ChangePassword()
 *
 * @access public
 * @param array $params
 * @return int
 */
function websitepanel_ChangePassword($params)
{
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);
    
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    $password = $params['password'];
    
    try
    {
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return "The specified user {$username} does not exist";
        }
        else
        {
            // Attempt to change the user's account password
            $result = $wsp->change_user_password($user['UserId'], $password);
            if ($result >= 0)
            {
                // Success - Alert WHMCS
                return 'success';
            }
            else
            {
                // Failed - Alert WHMCS of the returned Enterprise Server error code
                return websitepanel_GetErrorMessage($result);
            }
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_ChangePackage()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_ChangePackage($params)
{
    // Create the WebsitePanel object instance
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);
    
    // WHMCS server parameters & package parameters
    $username = $params['username'];
    
    // WebsitePanel API parameters
    $planId = $params['configoption4'];
    $packageName = $params['configoption1'];
    
    try
    {
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return "The specified user {$username} does not exist";
        }
        else
        {
            // Get the user's current WebsitePanel hosting space Id (Hosting Plan)
            $package = $wsp->get_user_packages($user['UserId']);
            $packageId = $package['PackageId'];
            
            // Update the user's package
            $result = $wsp->update_package_literal($packageId, $package['StatusId'], $planId, $package['PurchaseDate'], $packageName, '');
            $result = $result['Result'];
            if ($result >= 0)
            {
                // Success - Alert WHMCS
                return 'success';
            }
            else
            {
                // Failed - Alert WHMCS of the returned Enterprise Server error code
                return websitepanel_GetErrorMessage($result);
            }
        }
    }
    catch (Exception $e)
    {
        return $e->getMessage();
    }
}

/**
 * websitepanel_LoginLink()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_LoginLink($params)
{
    echo "<a href='{$params['configoption8']}/default.aspx?pid=Login&user={$params['username']}&password={$params['password']}' title='Control Panel Login' style='color:#cc0000;' target='_blank'>Login to Control Panel (One-Click Login)</a>";
}

/**
 * websitepanel_ClientArea()
 *
 * @access public
 * @param array $params
 * @return string
 */
function websitepanel_ClientArea($params)
{
    return "<a href='{$params['configoption8']}/default.aspx?pid=Login&user={$params['username']}&password={$params['password']}' title='Control Panel Login' style='color:#cc0000;' target='_blank'>Login to Control Panel (One-Click Login)</a>";
}

/**
 * websitepanel_UsageUpdate()
 *
 * @access public
 * @param array $params
 * @return void
 */
function websitepanel_UsageUpdate($params)
{
    // WHMCS server parameters & package parameters
    $serverid = $params['serverid'];
    $serverip = $params['serverip'];

    // Query for all active or suspended users under the specified server
    $query = full_query("SELECT `username`, `packageid`, `regdate` FROM `tblhosting` WHERE `server` = {$serverid} AND `domainstatus` IN ('Active', 'Suspended') AND `username` <> ''");
    while (($row = mysql_fetch_array($query)) != false)
    {
        try
        {
            // Start processing the specified users usage
            $username = $row['username'];
            $packageId = $row['packageid'];

            // Get the packages ConfigOptions
            $packageQuery = select_query('tblproducts', 'configoption2,configoption3,configoption6,configoption16', array('id' => $packageId, 'configoption16' => 'on'));
            $cfgOptions = mysql_fetch_array($packageQuery);
            $params['configoption6'] = $cfgOptions['configoption6'];

            // Diskspace and Bandwidth limits for this package
            $diskLimit = $cfgOptions['configoption2'];
            $bwidthLimit = $cfgOptions['configoption3'];

            // Create the WebsitePanel object instance
            $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $serverip, $params['configoption6'], $params['serversecure']);

            // Get the specified user details
            // Get the Package id of the user's package
            $user = $wsp->get_user_by_username($username);
            $package = $wsp->get_user_packages($user['UserId']);
            
            // Gather the bandwidth / diskspace usage stats
            $bandwidthUsage = websitepanel_CalculateBandwidthUsage($params, $package['PackageId'], websitepanel_CreateBandwidthDate($row['regdate']));
            $diskSpaceUsage = websitepanel_CalculateDiskspaceUsage($params, $package['PackageId']);

            // Update the package details
            update_query('tblhosting', array('diskusage' => $diskSpaceUsage, 'disklimit' => $diskLimit, 'bwusage' => $bandwidthUsage, 'bwlimit' => $bwidthLimit, 'lastupdate' => date('Y-m-d H:i:s')), array('username' => $username, 'server' => $serverid));
        }
        catch (Exception $e)
        {
            // Nothing
        }
    }
}