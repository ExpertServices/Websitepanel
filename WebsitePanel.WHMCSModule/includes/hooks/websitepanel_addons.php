<?php if (!defined('WHMCS')) exit('ACCESS DENIED');
/**
 * WebsitePanel Addons Hook
 * 
 * @author Christopher York
 * @package WebsitePanel Addons Hook
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

/**
 * websitepanel_addons_AddonActivation
 *
 * @access public
 * @return array
 */
function websitepanel_addons_AddonActivation($params)
{
    // Sanity check to make sure the associated service is WebsitePanel based product
    // And that the addon purchased has an associated WebsitePanel addon
    $results = full_query("SELECT h.id AS `id` FROM `tblhosting` AS h, `tblwspaddons` AS w, `tblservers` AS s WHERE h.id = {$params['serviceid']} AND h.server = s.id AND s.type = 'websitepanel' AND w.whmcs_id = {$params['addonid']}");
    if (mysql_num_rows($results) > 0)
    {
        // Include the WebsitePanel ES Class
        require_once(ROOTDIR . '/modules/servers/websitepanel/websitepanel.class.php');
        
        // Retrieve the WebsitePanel Addons module settings
        $modSettings = websitepanel_addons_GetSettings();
        
        // Get the associated WebsitePanel username from WHMCS
        $results = select_query('tblhosting', 'username', array('id' => $params['serviceid']));
        $username = mysql_fetch_array($results);
        $username = $username['username'];
        if (empty($username))
        {
            // The username is required - if missing we cannot continue
            return;
        }
        
        // Create the WebsitePanel object instance
        $wsp = new WebsitePanel($modSettings['username'], $modSettings['password'], $modSettings['serverhost'], $modSettings['serverport'], (($modSettings['serversecured']) == 'on' ? TRUE : FALSE));
        
        // Grab the user's details from WebsitePanel in order to get the user's id
        $user = $wsp->get_user_by_username($username);
        if (empty($user))
        {
            return;
        }
        
        // Get the user's current WebsitePanel hosting space Id (Hosting Plan)
        $package = $wsp->get_user_packages($user['UserId']);
        $packageId = $package['PackageId'];
        if (empty($packageId))
        {
            return;
        }
        
        // Get the associated WebsitePanel addon id
        $results = select_query('tblwspaddons', 'wsp_id,is_ipaddress', array('whmcs_id' => $params['addonid']));
        $addon = mysql_fetch_array($results);
        $addonPlanId = $addon['wsp_id'];
        $addonIsIpAddress = $addon['is_ipaddress'];
        
        // Add the Addon Plan to the customer's WebsitePanel package / hosting space
        $results = $wsp->add_package_addon_by_id($packageId, $addonPlanId);
        
        // Check the results to verify that the addon has been successfully allocated
        if ($results['Result'] > 0)
        {           
            // If this addon is an IP address addon - attempt to randomly allocate an IP address to the customer's hosting space
            if ($addonIsIpAddress)
            {
                $wsp->package_allocate_ipaddress($packageId);
            }
        }
    }
}

/* Addon Activation - WebsitePanel */
add_hook('AddonActivation', 1, 'websitepanel_addons_AddonActivation');

/* Addon Activation - WebsitePanel */
add_hook('AddonActivated', 1, 'websitepanel_addons_AddonActivation');

/**
 * websitepanel_addons_GetSettings
 * 
 * @access public
 * @return array
 */
function websitepanel_addons_GetSettings()
{
    $settings = array();
    
    // Retrieve the settings from the modules configuration table
    $results = select_query('tbladdonmodules', 'setting,value', array('module' => 'websitepanel_addons'));
    while (($row = mysql_fetch_array($results)) != false)
    {
        $settings[$row['setting']] = $row['value'];
    }
    return $settings;
}