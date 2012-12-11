<?php if (!defined('WHMCS')) exit('ACCESS DENIED');
/**
 * WebsitePanel Server Module - WebsitePanel Business Error Codes
 * 
 * @author Christopher York
 * @package WebsitePanel Server Module - WebsitePanel Business Error Codes
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

/**
 * Common error codes encountered while using the WebsitePanel Server Module
 * These are not all the Enterprise Server error codes, only the ones I have encountered using the API
 */
$esErrorCodes = array(-100 => 'User already exists',
                      -101 => 'User not found',
                      -102 => 'User has child user accounts',
                      -300 => 'Hosting package could not be found',
                      -301 => 'Hosting package has child hosting spaces',
                      -501 => 'The sub-domain belongs to an existing hosting space that does not allow sub-domains to be created',
                      -502 => 'The domain or sub-domain exists within another hosting space',
                      -511 => 'Instant alias is enabled, but not configured',
                      -601 => 'The website already exists on the target hosting space',
                      -700 => 'The email domain already exists on the target hosting space',
                      -1100 => 'User already exists');