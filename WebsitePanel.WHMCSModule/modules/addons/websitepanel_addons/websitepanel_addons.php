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
 * WebsitePanel Enterprise Server Client
 * For the ASPnix WebsitePanel system only - Only tested against the ASPnix WebsitePanel system
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
 * websitepanel_addons_config
 *
 * @access public
 * @return array
 */
function websitepanel_addons_config()
{
    return array('name' => 'WebsitePanel Addons Automation',
                 'description' => 'Automates WHMCS product addons with WebsitePanel Addons',
                 'version' => '3.0.4',
                 'author' => 'Christopher York');
}

/**
 * websitepanel_addons_activate
 *
 * @access public
 * @return array
 */
function websitepanel_addons_activate()
{
    // Create the WebsitePanel Addons table
    $query = "CREATE TABLE IF NOT EXISTS `mod_wspaddons` (
              `whmcs_id` int(11) NOT NULL,
              `wsp_id` int(11) NOT NULL,
              `is_ipaddress` bit(1) NOT NULL DEFAULT b'0',
              PRIMARY KEY (`whmcs_id`)
              ) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
    $result = full_query($query);

    // Check the results to verify that the table has been created properly
    if (!$result)
    {
        return array('status' => 'error', 'description' => 'There was an error while activating the module');
    }
    else
    {
        return array('status' => 'success', 'description' => 'The module has been activated successfully');
    }
}

/**
 * websitepanel_addons_deactivate
 *
 * @access public
 * @return array
 */
function websitepanel_addons_deactivate()
{
    // Drop the WebsitePanel Addons table
    $result = full_query('DROP TABLE `mod_wspaddons`');

    // Check the results to verify that the table has been created properly
    if (!$result)
    {
        return array('status' => 'error', 'description' => 'There was an error while deactiviting the module');
    }
    else
    {
        return array('status' => 'success', 'description' => 'The module has been deactivated successfully');
    }
}

/**
 * websitepanel_addons_upgrade
 *
 * @param $vars array
 * @access public
 * @return array
 */
function websitepanel_addons_upgrade($vars)
{
    // Module versions
    $version = $vars['version'];

    // Adjust the table name and remove the WebsitePanel credentials
    if ($version < 1.2)
    {
        full_query('RENAME TABLE `tblwspaddons` TO `mod_wspaddons`');
        full_query("DELETE FROM `tbladdonmodules` WHERE `module` = 'websitepanel_addons' AND `setting` = 'username'");
        full_query("DELETE FROM `tbladdonmodules` WHERE `module` = 'websitepanel_addons' AND `setting` = 'password'");
    }
}

/**
 * Displays the WebsitePanel Addons module output
 *
 * @access public
 * @return mixed
 */
function websitepanel_addons_output($params)
{
    // Delete the requested WebsitePanel addon
    if (isset($_GET['action']) && $_GET['action'] == 'delete')
    {
        delete_query('mod_wspaddons', array('whmcs_id' => $_GET['id']));
    }

    // Add the requested WebsitePanel addon
    if ($_POST && isset($_POST['action']) && $_POST['action'] == 'add')
    {
        // Sanity check to make sure the WHMCS addon ID exists
        $results = select_query('tbladdons', 'id', array('id' => $_POST['whmcs_id']));
        if (mysql_num_rows($results) > 0)
        {
            $results = select_query('mod_wspaddons', 'whmcs_id', array('whmcs_id' => $_POST['whmcs_id']));
            if (mysql_num_rows($results) > 0)
            {
                echo '<p><div style="margin:0 0 -5px 0;padding: 10px;background-color: #FBEEEB;border: 1px dashed #cc0000;font-weight: bold;color: #cc0000;font-size:14px;text-align: center;-moz-border-radius: 10px;-webkit-border-radius: 10px;-o-border-radius: 10px;border-radius: 10px;">Duplicate WHMCS Addon ID. The WHMCS Addon ID Is Assigned To Another WebsitePanel Addon.</div></p>';
            }
            else
            {
                insert_query('mod_wspaddons', array('whmcs_id' => $_POST['whmcs_id'], 'wsp_id' => $_POST['wsp_id'], 'is_ipaddress' => $_POST['is_ipaddress']));
            }
        }
        else
        {
            echo '<p><div style="margin:0 0 -5px 0;padding: 10px;background-color: #FBEEEB;border: 1px dashed #cc0000;font-weight: bold;color: #cc0000;font-size:14px;text-align: center;-moz-border-radius: 10px;-webkit-border-radius: 10px;-o-border-radius: 10px;border-radius: 10px;">WHMCS Addon Not Found! Check The ID And Try Again.</div></p>';
        }
    }

    // Get all the assigned addons and display them to the user
    $results = full_query('SELECT a.name AS `name`, a.id AS `whmcs_id`, w.wsp_id AS `wsp_id` FROM `tbladdons` AS a, `mod_wspaddons` AS w WHERE w.whmcs_id = a.id');

    // Build the table / data grid
    echo '<div class="tablebg">';
    echo '<table class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">';
    echo '<tr><th>Addon Name</th><th>WHMCS ID</th><th>WebsitePanel ID</th><th></th></tr>';
    if (mysql_num_rows($results) > 0)
    {
        while (($row = mysql_fetch_array($results)) != false)
        {
            echo "<tr><td>{$row['name']}</td><td>{$row['whmcs_id']}</td><td>{$row['wsp_id']}</td><td><a href=\"{$params['modulelink']}&action=delete&id={$row['whmcs_id']}\" onclick=\"return confirm('Are you sure you want to delete this addon?');\">Delete</td></td></tr>";
        }
    }
    else
    {
        echo '<tr><td colspan="4">No Addon Data Found</td></tr>';
    }
    echo '</table></div>';

    // Build the add addon form
    echo '<p><strong>Add WebsitePanel Addon</strong></p>';
    echo "<form action=\"{$params['modulelink']}\" method=\"POST\">";
    echo '<input type="hidden" name="action" id="action" value="add">';
    echo '<table class="form" "width="100%" border="0" cellspacing="2" cellpadding="3">';
    echo '<tr><td class="fieldlabel">WHMCS Addon ID</td><td class="fieldarea"><input type="text" name="whmcs_id" id="whmcs_id"></td></tr>';
    echo '<tr><td class="fieldlabel">WebsitePanel Addon ID</td><td class="fieldarea"><input type="text" name="wsp_id" id="wsp_id"></td></tr>';
    echo '<tr><td class="fieldlabel">Dedicated IP Addon</td><td class="fieldarea"><input type="checkbox" name="is_ipaddress" id="is_ipaddress" value="1"></td></tr>';
    echo '<tr><td colspan="2" class="fieldarea"><input type="submit" name="submit" id="submit" value="Submit"></td></tr>';
    echo '</form></table>';
}