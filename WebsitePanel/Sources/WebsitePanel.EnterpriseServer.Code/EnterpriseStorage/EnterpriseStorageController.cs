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
using System.Linq;

using WebsitePanel.Server;
using WebsitePanel.Providers;
using WebsitePanel.Providers.OS;
using WebsitePanel.Providers.EnterpriseStorage;
using System.Collections;
using WebsitePanel.Providers.Common;
using WebsitePanel.Providers.ResultObjects;
using WebsitePanel.Providers.Web;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.EnterpriseServer.Base.HostedSolution;

namespace WebsitePanel.EnterpriseServer
{
    public class EnterpriseStorageController
    {
        #region Public Methods

        public static bool CheckEnterpriseStorageInitialization(int packageId, int itemId)
        {
            return CheckEnterpriseStorageInitializationInternal(packageId, itemId);
        }

        public static ResultObject CreateEnterpriseStorage(int packageId, int itemId)
        {
            return CreateEnterpriseStorageInternal(packageId, itemId);
        }

        public static ResultObject DeleteEnterpriseStorage(int packageId, int itemId)
        {
            return DeleteEnterpriseStorageInternal(packageId,itemId);
        }

        public static SystemFile[] GetFolders(int itemId)
        {
           return GetFoldersInternal(itemId);
        }

        public static SystemFile GetFolder(int itemId, string folderName)
        {
            return GetFolderInternal(itemId, folderName);
        }

        public static SystemFile GetFolder(int itemId)
        {
            return GetFolder(itemId, string.Empty);
        }

        public static ResultObject CreateFolder(int itemId)
        {
            return CreateFolder(itemId, string.Empty);
        }

        public static ResultObject CreateFolder(int itemId, string folderName)
        {
            return CreateFolderInternal(itemId, folderName);
        }

        public static ResultObject DeleteFolder(int itemId)
        {
            return DeleteFolder(itemId, string.Empty);
        }

        public static ResultObject DeleteFolder(int itemId, string folderName)
        {
            return DeleteFolderInternal(itemId, folderName);
        } 

        public static List<ExchangeAccount> SearchESAccounts(int itemId, string filterColumn, string filterValue, string sortColumn)
        {
            return SearchESAccountsInternal(itemId, filterColumn, filterValue, sortColumn);
        }

        public static SystemFilesPaged GetEnterpriseFoldersPaged(int itemId, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetEnterpriseFoldersPagedInternal(itemId, filterValue, sortColumn, startRow, maximumRows);
        }

        public static ResultObject SetFolderPermission(int itemId, string folder, ESPermission[] permission)
        {
            return SetFolderWebDavRulesInternal(itemId, folder, permission);
        }

        public static ESPermission[] GetFolderPermission(int itemId, string folder)
        {
            return ConvertToESPermission(itemId,GetFolderWebDavRulesInternal(itemId, folder));
        }

        public static bool CheckFileServicesInstallation(int serviceId)
        {
            EnterpriseStorage es = GetEnterpriseStorage(serviceId);
            return es.CheckFileServicesInstallation();
        }

        public static SystemFile RenameFolder(int itemId, string oldFolder, string newFolder)
        {
            return RenameFolderInternal(itemId, oldFolder, newFolder);
        }

        public static bool CheckUsersDomainExists(int itemId)
        {
            return CheckUsersDomainExistsInternal(itemId);
        }

        #endregion

        protected static bool CheckUsersDomainExistsInternal(int itemId)
        {
            Organization org = OrganizationController.GetOrganization(itemId);

            if (org == null)
            {
                return false;
            }

            return CheckUsersDomainExistsInternal(itemId, org.PackageId);
        }

        protected static bool CheckUsersDomainExistsInternal(int itemId, int packageId)
        {
            int webServiceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.Web);
            var esServiceId = GetEnterpriseStorageServiceID(packageId);

            StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

            string usersDomain = esSesstings["UsersDomain"];

            WebServer web = new WebServer();
            ServiceProviderProxy.Init(web, webServiceId);

            if (web.SiteExists(usersDomain))
                return true;

            return false;
        }

        protected static bool CheckEnterpriseStorageInitializationInternal(int packageId, int itemId)
        {
            bool checkResult = true;

            var esServiceId = GetEnterpriseStorageServiceID(packageId);
            int webServiceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.Web);

            Organization org = OrganizationController.GetOrganization(itemId);

            if (org == null)
            {
                return false;
            }

            //root folder not created
            if (GetFolder(itemId) == null)
            {
                checkResult = false;
            }

            //checking if virtual directory is created
            StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

            string usersDomain = esSesstings["UsersDomain"];

            WebServer web = new WebServer();
            ServiceProviderProxy.Init(web, webServiceId);
            
            if (!web.VirtualDirectoryExists(usersDomain, org.OrganizationId))
            {
                checkResult = false;
            }


            return checkResult;
        }

        protected static ResultObject CreateEnterpriseStorageInternal(int packageId, int itemId)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ORGANIZATION", "CREATE_ORGANIZATION_ENTERPRISE_STORAGE", itemId, packageId);

            try
            {
                int esServiceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);

                if (esServiceId != 0)
                {
                    StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

                    Organization org = OrganizationController.GetOrganization(itemId);

                    string usersHome = esSesstings["UsersHome"];
                    string usersDomain = esSesstings["UsersDomain"];
                    string locationDrive = esSesstings["LocationDrive"];

                    string homePath = string.Format("{0}:\\{1}", locationDrive, usersHome);

                    EnterpriseStorageController.CreateFolder(itemId);

                    WebServerController.AddWebDavDirectory(packageId, usersDomain, org.OrganizationId, homePath);

                    int osId = PackageController.GetPackageServiceId(packageId, ResourceGroups.Os);
                    bool enableHardQuota = (esSesstings["enablehardquota"] != null)
                        ? bool.Parse(esSesstings["enablehardquota"])
                        : false;

                    if (enableHardQuota && osId != 0 && OperatingSystemController.CheckFileServicesInstallation(osId))
                    {
                        FilesController.SetFolderQuota(packageId, Path.Combine(usersHome, org.OrganizationId),
                            locationDrive, Quotas.ENTERPRISESTORAGE_DISKSTORAGESPACE);
                    }
                }
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_CREATE_FOLDER", ex);
            }
            finally
            {
                if (!result.IsSuccess)
                {
                    TaskManager.CompleteResultTask(result);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }

        protected static ResultObject DeleteEnterpriseStorageInternal(int packageId, int itemId)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ORGANIZATION", "CLEANUP_ORGANIZATION_ENTERPRISE_STORAGE", itemId, packageId);

            try
            {
                int esId = PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);

                Organization org = OrganizationController.GetOrganization(itemId);

                if (esId != 0)
                {
                    StringDictionary esSesstings = ServerController.GetServiceSettings(esId);

                    string usersDomain = esSesstings["UsersDomain"];

                    WebServerController.DeleteWebDavDirectory(packageId, usersDomain, org.OrganizationId);
                    EnterpriseStorageController.DeleteFolder(itemId);

                }
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_CLEANUP", ex);
            }
            finally
            {
                if (!result.IsSuccess)
                {
                    TaskManager.CompleteResultTask(result);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }

        private static EnterpriseStorage GetEnterpriseStorage(int serviceId)
        {
            EnterpriseStorage es = new EnterpriseStorage();
            ServiceProviderProxy.Init(es, serviceId);
            return es;
        }

        protected static SystemFile[] GetFoldersInternal(int itemId)
        {
            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                return es.GetFolders(org.OrganizationId);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected static SystemFile GetFolderInternal(int itemId, string folderName)
        {
            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                return es.GetFolder(org.OrganizationId, folderName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected static SystemFile RenameFolderInternal(int itemId, string oldFolder, string newFolder)
        {
            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                return es.RenameFolder(org.OrganizationId, oldFolder, newFolder);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected static ResultObject CreateFolderInternal(int itemId, string folderName)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "CREATE_FOLDER");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                es.CreateFolder(org.OrganizationId, folderName);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_CREATE_FOLDER", ex);
            }
            finally
            {
                if (!result.IsSuccess)
                {
                    TaskManager.CompleteResultTask(result);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }

        protected static ResultObject DeleteFolderInternal(int itemId, string folderName)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "DELETE_FOLDER");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                es.DeleteFolder(org.OrganizationId, folderName);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_DELETE_FOLDER", ex);
            }
            finally
            {
                if (!result.IsSuccess)
                {
                    TaskManager.CompleteResultTask(result);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }
    
        protected static List<ExchangeAccount> SearchESAccountsInternal(int itemId, string filterColumn, string filterValue, string sortColumn)
        {
            // load organization
            Organization org = (Organization)PackageController.GetPackageItem(itemId);
            if (org == null)
                return null;

            string accountTypes = string.Format("{0}, {1}, {2}", ((int)ExchangeAccountType.SecurityGroup),
                (int)ExchangeAccountType.DefaultSecurityGroup, ((int)ExchangeAccountType.User));

            if (PackageController.GetPackageServiceId(org.PackageId, ResourceGroups.Exchange) != 0)
            {
                accountTypes = string.Format("{0}, {1}, {2}, {3}", accountTypes, ((int)ExchangeAccountType.Mailbox),
                ((int)ExchangeAccountType.Room), ((int)ExchangeAccountType.Equipment));
            }

            List<ExchangeAccount> tmpAccounts = ObjectUtils.CreateListFromDataReader<ExchangeAccount>(
                                                  DataProvider.SearchExchangeAccountsByTypes(SecurityContext.User.UserId, itemId,
                                                  accountTypes, filterColumn, filterValue, sortColumn));


            List<ExchangeAccount> exAccounts = new List<ExchangeAccount>();

            foreach (ExchangeAccount tmpAccount in tmpAccounts.ToArray())
            {
                if (tmpAccount.AccountType == ExchangeAccountType.SecurityGroup || tmpAccount.AccountType == ExchangeAccountType.SecurityGroup
                        ? OrganizationController.GetSecurityGroupGeneralSettings(itemId, tmpAccount.AccountId) == null
                        : OrganizationController.GetSecurityGroupGeneralSettings(itemId, tmpAccount.AccountId) == null)
                    continue;

                exAccounts.Add(tmpAccount);
            }

            return exAccounts;

        }

        protected static SystemFilesPaged GetEnterpriseFoldersPagedInternal(int itemId, string filterValue, string sortColumn,
            int startRow, int maximumRows)
        {
            SystemFilesPaged result = new SystemFilesPaged();

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                if (CheckUsersDomainExistsInternal(itemId, org.PackageId))
                {
                    EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));
                    List<SystemFile> folders = es.GetFolders(org.OrganizationId).Where(x => x.Name.Contains(filterValue)).ToList();

                    switch (sortColumn)
                    {
                        case "Size":
                            folders = folders.OrderBy(x => x.Size).ToList();
                            break;
                        default:
                            folders = folders.OrderBy(x => x.Name).ToList();
                            break;
                    }

                    result.RecordsCount = folders.Count;
                    result.PageItems = folders.Skip(startRow).Take(maximumRows).ToArray();
                }
            }
            catch { /*skip exception*/}

            return result;
        }

        protected static ResultObject SetFolderWebDavRulesInternal(int itemId, string folder, ESPermission[] permission)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "SET_WEBDAV_FOLDER_RULES");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                var rules = ConvertToWebDavRule(itemId,permission);

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                es.SetFolderWebDavRules(org.OrganizationId, folder, rules);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_SET_WEBDAV_FOLDER_RULES", ex);
            }
            finally
            {
                if (!result.IsSuccess)
                {
                    TaskManager.CompleteResultTask(result);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }

        protected static WebDavFolderRule[] GetFolderWebDavRulesInternal(int itemId, string folder)
        {
            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                return es.GetFolderWebDavRules(org.OrganizationId, folder);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private static int GetEnterpriseStorageServiceID(int packageId)
        {
            return PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);
        }

        private static EnterpriseStorage GetEnterpriseStorageByPackageId(int packageId)
        {
            var serviceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);

            return GetEnterpriseStorage(serviceId);
        }

        private static WebDavFolderRule[] ConvertToWebDavRule(int itemId, ESPermission[] permissions)
        {
            var rules = new List<WebDavFolderRule>();

            foreach (var permission in permissions)
            {
                var rule = new WebDavFolderRule();

                var account = ObjectUtils.FillObjectFromDataReader<ExchangeAccount>(DataProvider.GetExchangeAccountByAccountName(itemId, permission.Account));

                if (account.AccountType == ExchangeAccountType.SecurityGroup)
                {
                    rule.Roles.Add(permission.Account);
                }
                else
                {
                    rule.Users.Add(permission.Account);
                }

                if (permission.Access.ToLower().Contains("read-only"))
                {
                    rule.Read = true;
                }

                if (permission.Access.ToLower().Contains("read-write"))
                {
                    rule.Write = true;
                    rule.Read = true;
                }

                rule.Pathes.Add("*");

                rules.Add(rule);
            }
            
            return rules.ToArray();
        }

        private static ESPermission[] ConvertToESPermission(int itemId, WebDavFolderRule[] rules)
        {
            var permissions = new List<ESPermission>();

            foreach (var rule in rules)
            {
                var permission = new ESPermission();

                permission.Account = rule.Users.Any() ? rule.Users[0] : rule.Roles[0];

                permission.IsGroup = rule.Roles.Any();

                var orgObj = OrganizationController.GetAccountByAccountName(itemId, permission.Account);

                if (orgObj == null)
                    continue;

                if (permission.IsGroup)
                {
                    var secGroupObj = OrganizationController.GetSecurityGroupGeneralSettings(itemId, orgObj.AccountId);

                    if (secGroupObj == null)
                        continue;

                    permission.DisplayName = secGroupObj.DisplayName;

                }
                else
                {
                    var userObj = OrganizationController.GetUserGeneralSettings(itemId, orgObj.AccountId);

                    if (userObj == null)
                        continue;

                    permission.DisplayName = userObj.DisplayName;
                }

                if (rule.Read && !rule.Write)
                {
                    permission.Access = "Read-Only";
                }
                if (rule.Write)
                {
                    permission.Access = "Read-Write";
                }


                permissions.Add(permission);
            }

            return permissions.ToArray();

        }
    }
}
