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
 * websitepanel Server Module - websitepanel Helper Functions
 * 
 * @author Christopher York
 * @package websitepanel Server Module - websitepanel Helper Functions
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

/**
 * websitepanel_GetErrorMessage()
 *
 * @access public
 * @param int $code
 * @return mixed
 */
function websitepanel_GetErrorMessage($code)
{
    // Error codes
    $esErrorCodes = array();
    
    // Include the common / known error codes
    require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.errorcodes.php');
    $esErrorCodes = websitepanel_GetEnterpriseServerErrors();
    
    // Check if the error code exists, if not return the code
    if (array_key_exists($code, $esErrorCodes))
    {
        return $esErrorCodes[$code];
    }
    else
    {
        return $code;
    }
            
}

/**
 * websitepanel_CreateBandwidthDate()
 *
 * @access public
 * @param mixed $date
 * @return date
 */
function websitepanel_CreateBandwidthDate($date)
{
    $dateExploded = explode('-', $date);
    $currentYear = date('Y');
    $currentMonth = date('m');
    $newDate = "{$currentYear}-{$currentMonth}-{$dateExploded[2]}";

    $dateDiff = time() - strtotime('+1 hour', strtotime($newDate));
    $fullDays = floor($dateDiff / (60 * 60 * 24));
    if ($fullDays < 0)
    {
        return date('Y-m-d', strtotime('-1 month', strtotime($newDate)));
    }
    else
    {
        return $newDate;
    }
}

/**
 * websitepanel_CalculateBandwidthUsage()
 *
 * @access public
 * @param mixed $params
 * @param mixed $packageId
 * @param mixed $startDate
 * @return int
 */
function websitepanel_CalculateBandwidthUsage($params, $packageId, $startDate)
{
    // Create the ASPnix websitepanel_EnterpriseServer class object
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);

    try
    {
        $result = $wsp->getSpaceBandwidthUsage($packageId, $startDate, date('Y-m-d', time()));
        return websitepanel_CalculateUsage($result, WebsitePanel::USAGE_BANDWIDTH);
    }
    catch (Exception $e)
    {
        // Do nothing, just catch the Exception to keep PHP from exploding :)
    }
}

/**
 * websitepanel_CalculateDiskspaceUsage()
 *
 * @access public
 * @param mixed $params
 * @param mixed $packageId
 * @return int
 */
function websitepanel_CalculateDiskspaceUsage($params, $packageId)
{
    // Create the ASPnix websitepanel_EnterpriseServer class object
    $wsp = new WebsitePanel($params['serverusername'], $params['serverpassword'], $params['serverip'], $params['configoption6'], $params['serversecure']);

    try
    {
        $result = $wsp->getSpaceDiskspaceUsage($packageId);
        return websitepanel_CalculateUsage($result, WebsitePanel::USAGE_DISKSPACE);
    }
    catch (Exception $e)
    {
        // Do nothing, just catch the Exception to keep PHP from exploding :)
    }
}

/**
 * websitepanel_CalculateUsage()
 *
 * @access public
 * @param mixed $result
 * @param int $usageType
 * @return int
 */
function websitepanel_CalculateUsage($result, $usageType)
{
    // Process results
    $xml = simplexml_load_string($result->any);
    $total = 0;
    if (count($xml->NewDataSet->Table) > 0)
    {
        foreach ($xml->NewDataSet->Table as $table)
        {
            switch ($usageType)
            {
                case WebsitePanel::USAGE_BANDWIDTH:
                    $total = $total + $table[0]->MegaBytesTotal;
                    break;

                case WebsitePanel::USAGE_DISKSPACE:
                    $total = $total + $table[0]->Diskspace;
                    break;

                default:
                    $total = $total + $table[0]->MegaBytesTotal;
                    break;
            }
        }
    }
    return $total;
}

/**
 * websitepanel_GetServerSettings
 *
 * @access public
 * @return array
 */
function websitepanel_GetServerSettings()
{
    $settings = array('username' => '', 'password' => '');

    // Retrieve the settings from the modules configuration table
    $results = select_query('tblservers', 'username,password', array('type' => 'websitepanel'));
    if (mysql_num_rows($results) != 0)
    {
        $row = mysql_fetch_array($results, MYSQL_ASSOC);
        $settings['username'] = $row['username'];
        $settings['password'] = decrypt($row['password']);
    }
    return $settings;
}