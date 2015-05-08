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

/**
 * WebsitePanel WHMCS Server Module Shared Funcitons
 *
 * @author Christopher York
 * @link http://www.websitepanel.net/
 * @access public
 * @name websitepanel
 * @version 3.0.4
 * @package WHMCS
 */

/**
 * Calculate the bandwidth calculation starting date based on when the customer signed up
 * 
 * @access public
 * @param string $startDate Customer registration date (starting date)
 * @return string
 */
function websitepanel_CreateBandwidthDate($startDate)
{
	$dateExploded = explode('-', $startDate);
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
 * Calculates the total usage of the provided WebsitePanel usage tables
 * Each websitepanel provider / service calculates its own disk and bandwidth usage, total all provided tables and return
 * 
 * @access public
 * @param array $usageTables Usage tables (each service provides its own usage breakdown)
 * @param int $usageType WebsitePanel usage type (websitepanel_EnterpriseServer::USAGE_*)
 * @return int
 */
function websitepanel_CalculateUsage($usageTables, $usageType)
{
	$totalUsage = 0;
	foreach ($usageTables['NewDataSet']['Table'] as $table)
	{
		switch ($usageType)
		{
		    case websitepanel_EnterpriseServer::USAGE_BANDWIDTH:
		    	$totalUsage += $table['MegaBytesTotal'];
		    break;
		    
		    case websitepanel_EnterpriseServer::USAGE_DISKSPACE:
		    	$totalUsage += $table['Diskspace'];
		    break;
		}
	}
	return $totalUsage;
}

/**
 * Loads the WebsitePanel language file
 * 
 * @access public
 */
function websitepanel_LoadClientLanguage()
{
    global $CONFIG, $_LANG, $smarty;
    
    // Attempt to load the client's language
    $selectedLanguage = !empty($_SESSION['Language']) ? $_SESSION['Language'] : $CONFIG['Language'];
    
    // For the admin area
    if (defined('ADMINAREA'))
    {
        $result = select_query('tbladmins', 'language', array('id' => (int)$_SESSION['adminid']));
        $results = mysql_fetch_assoc($result);
        $selectedLanguage = !empty($results['language']) ? $results['language'] : 'english';
    }
    
    // Load the language file
    $languageFile = dirname(__FILE__) . "/lang/{$selectedLanguage}.php";
    if (file_exists($languageFile))
    {
        require_once($languageFile);
    }
    else
    {
        // Load the default (English) language file
        require_once(dirname(__FILE__) . '/lang/english.php');
    }
    
    // Process the module language entries
    if (is_array($_MOD_LANG))
    {
        foreach ($_MOD_LANG as $key => $value)
        {
            if (empty($_LANG[$key]))
            {
                $_LANG[$key] = $value;
            }
        }
    }
    
    // Add to the template
    if (isset($smarty))
    {
        $smarty->assign('LANG', $_LANG);
    }
    
    return $_MOD_LANG;
}