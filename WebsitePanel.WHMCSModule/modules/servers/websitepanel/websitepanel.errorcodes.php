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