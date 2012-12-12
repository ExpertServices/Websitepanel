<?php if (!defined('WHMCS')) exit('ACCESS DENIED');
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
    global $esErrorCodes;
    
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
        $result = $wsp->get_space_bandwidth_usage($packageId, $startDate, date('Y-m-d', time()));
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
        $result = $wsp->get_space_diskspace_usage($packageId);
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