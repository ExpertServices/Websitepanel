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
 * WebsitePanel Server Module - Enterprise Server Wrapper
 * 
 * @author Christopher York
 * @package WebsitePanel Server Module - WebsitePanel Enterprise Server Wrapper
 * @version v1.0
 * @link http://www.websitepanel.net/
 */

class WebsitePanel
{
    /**
     * WebsitePanel Enteprise Server service file names
     * 
     * @access private
     * @var string
     */
    const SERVICEFILE_PACKAGES = 'esPackages.asmx';
    const SERVICEFILE_USERS = 'esUsers.asmx';
    const SERVICEFILE_SERVERS = 'esServers.asmx';

    /**
     * WebsitePanel account states
     *
     * @access public
     * @var string
     */
    const USERSTATUS_ACTIVE = 'Active';
    const USERSTATUS_SUSPENDED = 'Suspended';
    const USERSTATUS_CANCELLED = 'Cancelled';
    const USERSTATUS_PENDING = 'Pending';
    
    /**
     * WebsitePanel usage calculation
     *
     * @access public
     * @var int
     */
    const USAGE_DISKSPACE = 0;
    const USAGE_BANDWIDTH = 1;
    
    /**
     * WebsitePanel IP address pools
     * 
     * @access public
     * @var string
     */
    const IPADDRESS_POOL_WEB = 'Web';
    
    /**
     * WebsitePanel IP address groups
     *
     * @access public
     * @var string
     */
    const IPADDRESS_GROUP_WEBSITES = 'WebSites';
    
    /**
     * Enterprise Server username
     * 
     * @access private
     * @var string
     */
    private $_esUsername = 'serveradmin';
    
    /**
     * Enterprise Server password
     * 
     * @access private
     * @var string
     */
    private $_esPassword;
    
    /**
     * Enterprise Server URL / address (without the port)
     * 
     * @access private
     * @var string
     */
    private $_esServerUrl;
    
    /**
     * Enterprise Server TCP port
     * 
     * @access private
     * @var int
     */
    private $_esServerPort = 9002;
    
    /**
     * Use SSL (HTTPS) for Enterprise Server communications
     * 
     * @access private
     * @var boolean
     */
    private $_esUseSsl = false;
    
    /**
     * WebsitePanel class constructor
     * 
     * @access public
     * @param string $esUsername Enterprise Server username
     * @param string $esPassword Enterprise Server password
     * @param string $esServerUrl Enterprise Server URL / address (without the port)
     * @param int $esServerPort Enterprise Server TCP port
     * @param boolean $useSsl Use SSL (HTTPS) for Enterprise Server communications
     */
    public function __construct($esUsername, $esPassword, $esServerUrl, $esServerPort = 9002, $useSsl = FALSE)
    {
        $this->_esUsername = $esUsername;
        $this->_esPassword = $esPassword;
        $this->_esServerUrl = $esServerUrl;
        $this->_esServerPort = $esServerPort;
        $this->_esUseSsl = $useSsl;
    }
    
    /**
     * WebsitePanel::CreateAccount()
     *
     * @param string $username Account username
     * @param string $password Account password
     * @param string $roleId Account role id
     * @param string $firstName Account holders firstname
     * @param string $lastName Account holders lastname
     * @param string $email Account holders email address
     * @param string $planId WebsitePanel plan id
     * @param integer $parentPackageId Parent space / package id
     * @param string $domainName Account domain name
     * @param string $hostName Website hostname (if createWebsite is TRUE)
     * @param bool $htmlMail Send HTML email
     * @param bool $sendAccountLetter Send WebsitePanel "Account Summary" letter
     * @param bool $sendPackageLetter Send WebsitePanel "Hosting Space Summary" letter
     * @param bool $createPackage Create hostingspace / package on user creation
     * @param bool $tempDomain Create temporary domain on hostingspace / package creation
     * @param bool $createWebSite Create Website on hostingspace / package creation
     * @param bool $createFtpAccount Create FTP account on hostingspace / package creation
     * @param string $ftpAcountName FTP account name to create (if createFtpAccount is TRUE)
     * @param bool $createMailAccount Create default mail account on hostingspace / package creation
     * @param bool $createZoneRecord Create domain DNS zone record (if createMailAccount OR createWebSite are TRUE)
     * @return int
     */
    public function create_user_wizard($username, $password, $roleId, $firstName, $lastName, $email, $planId, $parentPackageId, $domainName, $hostName, $htmlMail = TRUE, $sendAccountLetter = TRUE, $sendPackageLetter = TRUE, $createPackage = TRUE, $tempDomain = FALSE, $createWebSite = FALSE, $createFtpAccount = FALSE, $ftpAcountName = '', $createMailAccount = FALSE, $createZoneRecord = FALSE)
    {
        $params = array();
        foreach (get_defined_vars() as $key => $value)
        {
            if ($key == 'params')
                continue;
            
            $params[$key] = $value;
        }
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'CreateUserWizard', $params)->CreateUserWizardResult;
    }
    
    /**
     * WebsitePanel::UpdateUserDetails()
     *
     * @access public
     * @param int $RoleId Account role id
     * @param string $Role Account role
     * @param int $StatusId Account status id
     * @param string $Status Account status
     * @param int $UserId Account user id
     * @param int $OwnerId Account owner id
     * @param string $Created Account creation date
     * @param string $Changed Account changed date
     * @param bool $IsDemo Demo account
     * @param bool $IsPeer Peer account
     * @param string $Comments Account comments
     * @param string $Username Account username
     * @param string $Password Account password
     * @param string $FirstName Account holders firstname
     * @param string $LastName Account holders lastname
     * @param string $Email Account holders email address
     * @param string $PrimaryPhone Account holders phone number
     * @param string $Zip Account holders postal code
     * @param string $InstantMessenger Account holders IM
     * @param string $Fax Account holders fax number
     * @param string $SecondaryPhone Account holders secondary phone number
     * @param string $SecondaryEmail Account holders secondary email
     * @param string $Country Account holders country
     * @param string $Address Account holders physical address
     * @param string $City Account holders city
     * @param string $State Account holders state
     * @param bool $HtmlMail Send HTML email
     * @param string $CompanyName Account holders Company name
     * @param bool $EcommerceEnabled Ecommerce enabled
     * @return void
     */
    public function update_user_details($RoleId, $Role, $StatusId, $Status, $LoginStatusId, $LoginStatus, $FailedLogins, $UserId, $OwnerId, $Created, $Changed, $IsDemo, $IsPeer, $Comments, $Username, $Password, $FirstName, $LastName, $Email, $PrimaryPhone, $Zip, $InstantMessenger, $Fax, $SecondaryPhone, $SecondaryEmail, $Country, $Address, $City, $State, $HtmlMail, $CompanyName, $EcommerceEnabled)
    {
        $params = array();
        foreach (get_defined_vars() as $key => $value)
        {
            if ($key == 'params')
                continue;
            
            $params[$key] = $value;
        }
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_USERS, 'UpdateUser', array('user' => $params))->UpdateUserResult;
    }
        
    /**
     * WebsitePanel::DeleteUser()
     *
     * @access public
     * @param int $userid User id
     * @return int
     */
    public function delete_user($userId)
    {
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_USERS, 'DeleteUser', array('userId' => $userId))->DeleteUserResult;
    }
    
    /**
     * WebsitePanel::GetUserByUsername()
     *
     * @access public
     * @param string $username Username
     * @return array
     */
    public function get_user_by_username($username)
    {
        return (array)$this->execute_server_method(WebsitePanel::SERVICEFILE_USERS, 'GetUserByUsername', array('username' => $username))->GetUserByUsernameResult;
    }
    
    /**
     * WebsitePanel::ChangeUserStatus()
     *
     * @param int $userId User id
     * @param string $status Account status (Active, Suspended, Cancelled, Pending)
     * @return int
     */
    public function change_user_status($userId, $status)
    {
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_USERS, 'ChangeUserStatus', array('userId' => $userId, 'status' => $status))->ChangeUserStatusResult;
    }
    
    /**
     * WebsitePanel::ChangeUserPassword()
     *
     * @access public
     * @param int $userId User id
     * @param string $password New password
     * @return int
     */
    public function change_user_password($userId, $password)
    {
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_USERS, 'ChangeUserPassword', array('userId' => $userId, 'password' => $password))->ChangeUserPasswordResult;
    }
    
    /**
     * WebsitePanel::GetUserPackages()
     *
     * @access public
     * @param int $userid User id
     * @return array
     */
    public function get_user_packages($userid)
    {
        return (array)$this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'GetMyPackages', array('userId' => $userid))->GetMyPackagesResult->PackageInfo;
    }
    
    /**
     * WebsitePanel::UpdatePackageLiteral()
     *
     * @access public
     * @param int $packageId Package id
     * @param int $statusId Status id
     * @param int $planId Plan id
     * @param string $purchaseDate Purchase date
     * @param string $packageName Package name
     * @param string $packageComments Package comments
     * @return array
     */
    public function update_package_literal($packageId, $statusId, $planId, $purchaseDate, $packageName, $packageComments)
    {
        $params = array();
        foreach (get_defined_vars() as $key => $value)
        {
            if ($key == 'params')
                continue;
            
            $params[$key] = $value;
        }
        return (array)$this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'UpdatePackageLiteral', $params)->UpdatePackageLiteralResult;
    }
    
    /**
     * WebsitePanel::add_package_addon_by_id()
     *
     * @access public
     * @param mixed $packageId Package id
     * @param mixed $addonPlanId Addon plan od
     * @param integer $quantity Quantity
     * @return array
     */
    public function add_package_addon_by_id($packageId, $addonPlanId, $quantity = 1)
    {
        return (array)$this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'AddPackageAddonById', array('packageId' => $packageId, 'addonPlanId' => $addonPlanId, 'quantity' => $quantity))->AddPackageAddonByIdResult;
    }
    
    /**
     * WebsitePanel::GetSpaceBandwidthUsage()
     *
     * @access public
     * @param int $packageId Package id
     * @param string $startDate Start date
     * @param string $endDate Ending date
     * @return object
     */
    public function get_space_bandwidth_usage($packageId, $startDate, $endDate)
    {
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'GetPackageBandwidth', array('packageId' => $packageId, 'startDate' => $startDate, 'endDate' => $endDate))->GetPackageBandwidthResult;
    }
    
    /**
     * WebsitePanel::GetSpaceDiskspaceUsage()
     *
     * @access private
     * @param int $packageId Package Id
     * @return object
     */
    public function get_space_diskspace_usage($packageId)
    {
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_PACKAGES, 'GetPackageDiskspace', array('packageId' => $packageId))->GetPackageDiskspaceResult;
    }
    
    /**
     * WebsitePanel::package_allocate_ipaddress()
     *
     * @param mixed $packageId Package id
     * @param mixed $groupName Group name
     * @param mixed $pool Address pool
     * @param integer $addressesNumber Number of IP addresses
     * @param bool $allocateRandom Allocate IP addresses randomly
     * @return object
     */
    public function package_allocate_ipaddress($packageId, $groupName = WebsitePanel::IPADDRESS_POOL_WEB, $pool = WebsitePanel::IPADDRESS_GROUP_WEBSITES, $addressesNumber = 1, $allocateRandom = TRUE)
    {
        $params = array();
        foreach (get_defined_vars() as $key => $value)
        {
            if ($key == 'params')
                continue;
            
            $params[$key] = $value;
        }
        return $this->execute_server_method(WebsitePanel::SERVICEFILE_SERVERS, 'AllocatePackageIPAddresses', $params)->AllocatePackageIPAddressesResult;
    }
    
    /**
     * Executes the request Enterprise Server method / parameters and returns the results
     *
     * @access private
     * @param string $serviceFile Enterprise Server service filename
     * @param string $serviceMethod Enterprise Server service method name
     * @param array $methodParameters Method parameters
     * @throws Exception
     * @return object
     */
    private function execute_server_method($serviceFile, $serviceMethod, $methodParameters = array())
    {
        $esUrl = (($this->_esUseSsl ? "https" : "http") . "://{$this->_esServerUrl}:{$this->_esServerPort}/{$serviceFile}?WSDL");
        $soapParams = array('login' => $this->_esUsername,
                            'password' => $this->_esPassword,
                            'cache_wsdl' => WSDL_CACHE_NONE, // WSDL caching is an annoying nightmare - we will disable it
                            'compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_GZIP
                            );
        try
        {
            $client = new SoapClient($esUrl, $soapParams);
            $result = $client->$serviceMethod($methodParameters);
            if (is_soap_fault($result))
            {
                throw new Exception($result->faultstring);
            }
            return $result;
        }
        catch (Exception $e)
        {
            throw new Exception($e->getMessage());
        }
    }
}