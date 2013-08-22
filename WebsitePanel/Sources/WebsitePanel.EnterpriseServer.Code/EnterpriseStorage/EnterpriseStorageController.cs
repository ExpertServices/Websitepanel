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

using System;
using System.IO;
using System.Data;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

using WebsitePanel.Server;
using WebsitePanel.Providers;
using WebsitePanel.Providers.OS;
using WebsitePanel.Providers.EnterpriseStorage;
using System.Collections;
using WebsitePanel.Providers.Common;
using WebsitePanel.Providers.ResultObjects;


namespace WebsitePanel.EnterpriseServer
{
    public class EnterpriseStorageController
    {
        #region Public Methods
        public static SystemFile[] GetFolders(int itemId)
        {
            return GetFoldersInternal(itemId);
        }

        public static SystemFile GetFolder(int itemId, string folderName)
        {
            return GetFolderInternal(itemId, folderName);
        }

        public static ResultObject CreateFolder(int itemId, string folderName, long quota)
        {
            return CreateFolderInternal(itemId, folderName, quota);
        }

        public static ResultObject DeleteFolder(int itemId, string folderName)
        {
            return DeleteFolderInternal(itemId, folderName);
        }

        public static ResultObject SetFolderQuota(int itemId, string folderName, long quota)
        {
            return SetFolderQuotaInternal(itemId, folderName, quota);
        }
        #endregion


        private static EnterpriseStorage GetEnterpriseStorage(int serviceId)
        {
            EnterpriseStorage es = new EnterpriseStorage();
            ServiceProviderProxy.Init(es, serviceId);
            return es;
        }


        private static SystemFile[] GetFoldersInternal(int itemId)
        {
            return new SystemFile[1];
        }

        private static SystemFile GetFolderInternal(int itemId, string folderName)
        {
            return new SystemFile();
        }

        private static ResultObject CreateFolderInternal(int itemId, string folderName, long quota)
        {
            return new ResultObject();
        }

        private static ResultObject DeleteFolderInternal(int itemId, string folderName)
        {
            return new ResultObject();
        }

        private static ResultObject SetFolderQuotaInternal(int itemId, string folderName, long quota)
        {
            return new ResultObject();
        }


        public static bool CheckFileServicesInstallation(int serviceId)
        {
            EnterpriseStorage es = GetEnterpriseStorage(serviceId);
            return es.CheckFileServicesInstallation();
        }
    }
}
