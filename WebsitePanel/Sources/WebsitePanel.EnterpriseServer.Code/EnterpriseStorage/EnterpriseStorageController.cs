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
using WebsitePanel.Server.Client;
using System.Text.RegularExpressions;
using System.Threading;

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
            return DeleteEnterpriseStorageInternal(packageId, itemId);
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
            return CreateFolder(itemId, string.Empty, 0, QuotaType.Soft, false);
        }

        public static ResultObject CreateFolder(int itemId, string folderName, int quota, QuotaType quotaType, bool addDefaultGroup)
        {
            return CreateFolderInternal(itemId, folderName, quota, quotaType, addDefaultGroup);
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
            return ConvertToESPermission(itemId, GetFolderWebDavRulesInternal(itemId, folder));
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

        public static void SetFRSMQuotaOnFolder(int itemId, string folderName, int quota, QuotaType quotaType)
        {
            SetFRSMQuotaOnFolderInternal(itemId, folderName, quota, quotaType);
        }

        public static void StartSetEnterpriseFolderSettingsBackgroundTask(int itemId, SystemFile folder, ESPermission[] permissions, bool directoyBrowsingEnabled, int quota, QuotaType quotaType)
        {
            StartESBackgroundTaskInternal("SET_ENTERPRISE_FOLDER_SETTINGS", itemId, folder, permissions, directoyBrowsingEnabled, quota, quotaType);
        }

        public static void SetESGeneralSettings(int itemId, SystemFile folder, bool directoyBrowsingEnabled, int quota, QuotaType quotaType)
        {
            SetESGeneralSettingsInternal("SET_ENTERPRISE_FOLDER_GENERAL_SETTINGS", itemId, folder, directoyBrowsingEnabled, quota, quotaType);
        }

        public static void SetESFolderPermissionSettings(int itemId, SystemFile folder, ESPermission[] permissions)
        {
            SetESFolderPermissionSettingsInternal("SET_ENTERPRISE_FOLDER_GENERAL_SETTINGS", itemId, folder, permissions);
        }

        public static int AddWebDavAccessToken(WebDavAccessToken accessToken)
        {
           return DataProvider.AddWebDavAccessToken(accessToken);
        }

        public static void DeleteExpiredWebDavAccessTokens()
        {
            DataProvider.DeleteExpiredWebDavAccessTokens();
        }

        public static WebDavAccessToken GetWebDavAccessTokenById(int id)
        {
            return ObjectUtils.FillObjectFromDataReader<WebDavAccessToken>(DataProvider.GetWebDavAccessTokenById(id));
        }

        public static WebDavAccessToken GetWebDavAccessTokenByAccessToken(Guid accessToken)
        {
            return ObjectUtils.FillObjectFromDataReader<WebDavAccessToken>(DataProvider.GetWebDavAccessTokenByAccessToken(accessToken));
        }

        public static SystemFile[] SearchFiles(int itemId, string[] searchPaths, string searchText, string userPrincipalName, bool recursive)
        {
            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return new SystemFile[0];
                }

                int serviceId = GetEnterpriseStorageServiceID(org.PackageId);

                if (serviceId == 0)
                {
                    return new SystemFile[0];
                }

                EnterpriseStorage es = GetEnterpriseStorage(serviceId);

                return es.Search(org.OrganizationId, searchPaths, searchText, userPrincipalName, recursive);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region Directory Browsing

        public static bool GetDirectoryBrowseEnabled(int itemId, string siteId)
        {
            return GetDirectoryBrowseEnabledInternal(itemId, siteId);
        }

        public static void SetDirectoryBrowseEnabled(int itemId, string siteId, bool enabled)
        {
            SetDirectoryBrowseEnabledInternal(itemId, siteId, enabled);
        }

        #endregion

        #region WebDav

        public static int AddWebDavDirectory(int packageId, string site, string vdirName, string contentpath)
        {
            return AddWebDavDirectoryInternal(packageId, site, vdirName, contentpath);
        }

        public static int DeleteWebDavDirectory(int packageId, string site, string vdirName)
        {
            return DeleteWebDavDirectoryInternal(packageId, site, vdirName);
        }

        #endregion

        #endregion

        private static IEnumerable<SystemFile> GetRootFolders(string userPrincipalName)
        {
            var rootFolders = new List<SystemFile>();

            var account = ExchangeServerController.GetAccountByAccountName(userPrincipalName);

            var userGroups = OrganizationController.GetSecurityGroupsByMember(account.ItemId, account.AccountId);

            foreach (var folder in GetFolders(account.ItemId))
            {
                var permissions = GetFolderPermission(account.ItemId, folder.Name);

                foreach (var permission in permissions)
                {
                    if ((!permission.IsGroup
                            && (permission.DisplayName == account.UserPrincipalName || permission.DisplayName == account.DisplayName))
                        || (permission.IsGroup && userGroups.Any(x => x.DisplayName == permission.DisplayName)))
                    {
                        rootFolders.Add(folder);
                        break;
                    }
                }
            }

            return rootFolders;
        }

        protected static void SetESGeneralSettingsInternal(string taskName, int itemId, SystemFile folder, bool directoyBrowsingEnabled, int quota, QuotaType quotaType)
        {
            // load organization
            var org = OrganizationController.GetOrganization(itemId);

            try
            {
                TaskManager.StartTask("ENTERPRISE_STORAGE", taskName, org.PackageId);

                EnterpriseStorageController.SetFRSMQuotaOnFolder(itemId, folder.Name, quota, quotaType);
                EnterpriseStorageController.SetDirectoryBrowseEnabled(itemId, folder.Url, directoyBrowsingEnabled);
            }
            catch (Exception ex)
            {
                // log error
                TaskManager.WriteError(ex, "Error executing enterprise storage background task");
            }
            finally
            {
                // complete task
                try
                {
                    TaskManager.CompleteTask();
                }
                catch (Exception)
                {
                }
            }
        }

        protected static void SetESFolderPermissionSettingsInternal(string taskName, int itemId, SystemFile folder, ESPermission[] permissions)
        {
            // load organization
            var org = OrganizationController.GetOrganization(itemId);

            new Thread(() =>
            {
                try
                {
                    TaskManager.StartTask("ENTERPRISE_STORAGE", taskName, org.PackageId);

                    EnterpriseStorageController.SetFolderPermission(itemId, folder.Name, permissions);
                }
                catch (Exception ex)
                {
                    // log error
                    TaskManager.WriteError(ex, "Error executing enterprise storage background task");
                }
                finally
                {
                    // complete task
                    try
                    {
                        TaskManager.CompleteTask();
                    }
                    catch (Exception)
                    {
                    }
                }

            }).Start();
        }

        protected static void StartESBackgroundTaskInternal(string taskName, int itemId, SystemFile folder, ESPermission[] permissions, bool directoyBrowsingEnabled, int quota, QuotaType quotaType)
        {
            // load organization
            var org = OrganizationController.GetOrganization(itemId);

            new Thread(() =>
            {
                try
                {
                    TaskManager.StartTask("ENTERPRISE_STORAGE", taskName, org.PackageId);

                    EnterpriseStorageController.SetFRSMQuotaOnFolder(itemId, folder.Name, quota, quotaType);
                    EnterpriseStorageController.SetDirectoryBrowseEnabled(itemId, folder.Url, directoyBrowsingEnabled);
                    EnterpriseStorageController.SetFolderPermission(itemId, folder.Name, permissions);
                }
                catch (Exception ex)
                {
                    // log error
                    TaskManager.WriteError(ex, "Error executing enterprise storage background task");
                }
                finally
                {
                    // complete task
                    try
                    {
                        TaskManager.CompleteTask();
                    }
                    catch (Exception)
                    {
                    }
                }

            }).Start();
        }

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
            var web = GetWebServer(packageId);

            if (web != null)
            {
                var esServiceId = GetEnterpriseStorageServiceID(packageId);

                StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

                string usersDomain = esSesstings["UsersDomain"];

                if (web.SiteExists(usersDomain))
                    return true;
            }

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

            WebServer web = GetWebServer(packageId);

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

                    EnterpriseStorageController.AddWebDavDirectory(packageId, usersDomain, org.OrganizationId, homePath);
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

                    EnterpriseStorageController.DeleteWebDavDirectory(packageId, usersDomain, org.OrganizationId);
                    EnterpriseStorageController.DeleteFolder(itemId);
                    EnterpriseStorageController.DeleteMappedDrivesGPO(itemId);
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
                    return new SystemFile[0];
                }

                int serviceId = GetEnterpriseStorageServiceID(org.PackageId);

                if (serviceId == 0)
                {
                    return new SystemFile[0];
                }

                EnterpriseStorage es = GetEnterpriseStorage(serviceId);

                var webDavSettings = ObjectUtils.CreateListFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolders(itemId)).ToArray();

                return es.GetFolders(org.OrganizationId, webDavSettings);
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

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, folderName));

                return es.GetFolder(org.OrganizationId, folderName, webDavSetting);
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

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, oldFolder));

                bool folderExists = es.GetFolder(org.OrganizationId, newFolder, webDavSetting) != null;

                if (!folderExists)
                {
                    SystemFile folder = es.RenameFolder(org.OrganizationId, oldFolder, newFolder, webDavSetting);

                    DataProvider.UpdateEnterpriseFolder(itemId, oldFolder, newFolder, folder.FRSMQuotaGB);

                    Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                    orgProxy.ChangeDriveMapFolderPath(org.OrganizationId, oldFolder, newFolder);

                    return folder;
                }

                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected static ResultObject CreateFolderInternal(int itemId, string folderName, int quota, QuotaType quotaType, bool addDefaultGroup)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "CREATE_FOLDER");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("",new NullReferenceException("Organization not found"));
                    return result;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, folderName));

                if (webDavSetting == null)
                {
                    int esId = PackageController.GetPackageServiceId(org.PackageId, ResourceGroups.EnterpriseStorage);

                    StringDictionary esSesstings = ServerController.GetServiceSettings(esId);

                    var setting = ObjectUtils.CreateListFromDataReader<WebDavSetting>(
                                      DataProvider.GetEnterpriseFolders(itemId)).LastOrDefault(x => !x.IsEmpty())
                                  ?? new WebDavSetting(esSesstings["LocationDrive"], esSesstings["UsersHome"], esSesstings["UsersDomain"]);


                    es.CreateFolder(org.OrganizationId, folderName, setting);

                    DataProvider.AddEntepriseFolder(itemId, folderName, quota,
                        setting.LocationDrive, setting.HomeFolder, setting.Domain);

                    SetFolderQuota(org.PackageId, org.OrganizationId, folderName, quota, quotaType, setting);

                    DataProvider.UpdateEnterpriseFolder(itemId, folderName, folderName, quota);

                    if (addDefaultGroup)
                    {
                        var groupName = string.Format("{0} Folder Users", folderName);

                        var account = ObjectUtils.CreateListFromDataReader<ExchangeAccount>(
                            DataProvider.GetOrganizationGroupsByDisplayName(itemId, groupName)).FirstOrDefault();

                        var accountId = account == null
                            ? OrganizationController.CreateSecurityGroup(itemId, groupName)
                            : account.AccountId;


                        var securityGroup = OrganizationController.GetSecurityGroupGeneralSettings(itemId, accountId);

                        var rules = new List<WebDavFolderRule>() {
                            new WebDavFolderRule
                            {
                                Roles = new List<string>() { securityGroup.AccountName },
                                Read = true,
                                Write = true,
                                Source = true,
                                Pathes = new List<string>() { "*" }
                           }
                        };

                        es.SetFolderWebDavRules(org.OrganizationId, folderName, webDavSetting, rules.ToArray());
                    }
                }
                else
                {
                    result.IsSuccess = false;
                    result.AddError("Enterprise Storage", new Exception("Folder already exist"));
                    return result;
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

        protected static void SetFRSMQuotaOnFolderInternal(int itemId, string folderName, int quota, QuotaType quotaType)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "SET_FRSM_QUOTA");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    return;
                }

                // check if it's not root folder
                if (!string.IsNullOrEmpty(folderName))
                {
                    var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                        DataProvider.GetEnterpriseFolder(itemId, folderName));

                    SetFolderQuota(org.PackageId, org.OrganizationId, folderName, quota, quotaType, webDavSetting);

                    DataProvider.UpdateEnterpriseFolder(itemId, folderName, folderName, quota);
                }
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_SET_FRSM_QUOTA", ex);
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

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, folderName));

                es.DeleteFolder(org.OrganizationId, folderName, webDavSetting);

                string path = string.Format(@"\\{0}@SSL\{1}\{2}", webDavSetting.Domain.Split('.')[0], org.OrganizationId, folderName);

                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                orgProxy.DeleteMappedDriveByPath(org.OrganizationId, path);

                DataProvider.DeleteEnterpriseFolder(itemId, folderName);
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

            return tmpAccounts;

            // on large lists is very slow

            //List<ExchangeAccount> exAccounts = new List<ExchangeAccount>();

            //foreach (ExchangeAccount tmpAccount in tmpAccounts.ToArray())
            //{
            //    if (tmpAccount.AccountType == ExchangeAccountType.SecurityGroup || tmpAccount.AccountType == ExchangeAccountType.DefaultSecurityGroup
            //            ? OrganizationController.GetSecurityGroupGeneralSettings(itemId, tmpAccount.AccountId) == null
            //            : OrganizationController.GetUserGeneralSettings(itemId, tmpAccount.AccountId) == null)
            //        continue;

            //    exAccounts.Add(tmpAccount);
            //}

            //return exAccounts;
        }

        protected static SystemFilesPaged GetEnterpriseFoldersPagedInternal(int itemId, string filterValue, string sortColumn, int startRow, int maximumRows)
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

                    var webDavSettings = ObjectUtils.CreateListFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolders(itemId)).ToArray();

                    List<SystemFile> folders = es.GetFolders(org.OrganizationId, webDavSettings).Where(x => x.Name.Contains(filterValue)).ToList();

                    Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                    List<MappedDrive> mappedDrives = orgProxy.GetDriveMaps(org.OrganizationId).ToList();

                    foreach (MappedDrive drive in mappedDrives)
                    {
                        foreach (SystemFile folder in folders)
                        {
                            if (drive.Path.Split('\\').Last() == folder.Name)
                            {
                                folder.DriveLetter = drive.DriveLetter;        
                            }
                        }
                    }

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

        #region WebDav

        protected static int AddWebDavDirectoryInternal(int packageId, string site, string vdirName, string contentpath)
        {
            // check account
            int accountCheck = SecurityContext.CheckAccount(DemandAccount.NotDemo | DemandAccount.IsActive);
            if (accountCheck < 0) return accountCheck;

            // place log record
            TaskManager.StartTask("ENTERPRISE_STORAGE", "ADD_VDIR", vdirName);

            TaskManager.WriteParameter("enterprise storage", site);

            try
            {
                // create virtual directory
                WebVirtualDirectory dir = new WebVirtualDirectory();
                dir.Name = vdirName;
                dir.ContentPath = Path.Combine(contentpath, vdirName);

                dir.EnableAnonymousAccess = false;
                dir.EnableWindowsAuthentication = false;
                dir.EnableBasicAuthentication = false;

                //dir.InstalledDotNetFramework = aspNet;

                dir.DefaultDocs = null; // inherit from service
                dir.HttpRedirect = "";
                dir.HttpErrors = null;
                dir.MimeMaps = null;

                // create directory

                WebServer web = GetWebServer(packageId);
                if (web.VirtualDirectoryExists(site, vdirName))
                    return BusinessErrorCodes.ERROR_VDIR_ALREADY_EXISTS;

                web.CreateEnterpriseStorageVirtualDirectory(site, dir);

                return 0;

            }
            catch (Exception ex)
            {
                throw TaskManager.WriteError(ex);
            }
            finally
            {
                TaskManager.CompleteTask();
            }
        }

        protected static int DeleteWebDavDirectoryInternal(int packageId, string site, string vdirName)
        {
            // check account
            int accountCheck = SecurityContext.CheckAccount(DemandAccount.NotDemo | DemandAccount.IsActive);
            if (accountCheck < 0) return accountCheck;

            // place log record
            TaskManager.StartTask("ENTERPRISE_STORAGE", "DELETE_VDIR", vdirName);

            TaskManager.WriteParameter("enterprise storage", site);

            try
            {
                int serviceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.Web);

                if (serviceId == -1)
                    return serviceId;

                // create directory
                WebServer web = GetWebServer(packageId);
                if (web.VirtualDirectoryExists(site, vdirName))
                    web.DeleteVirtualDirectory(site, vdirName);

                return 0;
            }
            catch (Exception ex)
            {
                throw TaskManager.WriteError(ex);
            }
            finally
            {
                TaskManager.CompleteTask();
            }
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

                var rules = ConvertToWebDavRule(itemId, permission);

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, folder));

                es.SetFolderWebDavRules(org.OrganizationId, folder, webDavSetting, rules);

                EnterpriseStorageController.SetDriveMapsTargetingFilter(org, permission, folder);
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

                var webDavSetting = ObjectUtils.FillObjectFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolder(itemId, folder));

                return es.GetFolderWebDavRules(org.OrganizationId, folder, webDavSetting);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        #endregion

        #region Directory Browsing

        private static bool GetDirectoryBrowseEnabledInternal(int itemId, string siteId)
        {
            // load organization
            var org = OrganizationController.GetOrganization(itemId);

            if (org == null)
                return false;

            var webServer = GetWebServer(org.PackageId);

            return webServer.GetDirectoryBrowseEnabled(siteId);
        }

        private static void SetDirectoryBrowseEnabledInternal(int itemId, string siteId, bool enabled)
        {
            // load organization
            var org = OrganizationController.GetOrganization(itemId);

            if (org == null)
                return;


            var webServer = GetWebServer(org.PackageId);

            webServer.SetDirectoryBrowseEnabled(siteId, enabled);
        }

        #endregion

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

                if (account.AccountType == ExchangeAccountType.SecurityGroup
                    || account.AccountType == ExchangeAccountType.DefaultSecurityGroup)
                {
                    rule.Roles.Add(permission.Account);
                    permission.IsGroup = true;
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
                    rule.Source = true;
                }

                rule.Source = true;

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

        private static void SetFolderQuota(int packageId, string orgId, string folderName, int quotaSize, QuotaType quotaType, WebDavSetting setting)
        {
            if (quotaSize == 0)
                return;

            int accountCheck = SecurityContext.CheckAccount(DemandAccount.NotDemo | DemandAccount.IsActive);
            if (accountCheck < 0)
                return;

            int packageCheck = SecurityContext.CheckPackage(packageId, DemandPackage.IsActive);
            if (packageCheck < 0)
                return;

            int esServiceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);

            if (esServiceId != 0)
            {
                var curSetting = setting;

                if (curSetting == null || curSetting.IsEmpty())
                {
                    StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

                    curSetting = new WebDavSetting(esSesstings["LocationDrive"], esSesstings["UsersHome"], esSesstings["UsersDomain"]);
                }

                var orgFolder = Path.Combine(curSetting.HomeFolder, orgId, folderName);
                
                var os = GetOS(packageId);

                if (os != null && os.CheckFileServicesInstallation())
                {
                    TaskManager.StartTask("FILES", "SET_QUOTA_ON_FOLDER", orgFolder, packageId);

                    try
                    {
                        QuotaValueInfo diskSpaceQuota = PackageController.GetPackageQuota(packageId, Quotas.ENTERPRISESTORAGE_DISKSTORAGESPACE);

                        #region figure Quota Unit

                        // Quota Unit
                        string unit = string.Empty;
                        if (diskSpaceQuota.QuotaDescription.ToLower().Contains("gb"))
                            unit = "GB";
                        else if (diskSpaceQuota.QuotaDescription.ToLower().Contains("mb"))
                            unit = "MB";
                        else
                            unit = "KB";

                        #endregion

                        os.SetQuotaLimitOnFolder(orgFolder, curSetting.LocationDrive, quotaType, quotaSize.ToString() + unit, 0, String.Empty, String.Empty);
                    }
                    catch (Exception ex)
                    {
                        TaskManager.WriteError(ex);
                    }
                    finally
                    {
                        TaskManager.CompleteTask();
                    }
                }
            }
        }

        /// <summary>
        /// Get webserver (IIS) installed on server connected with packageId
        /// </summary>
        /// <param name="packageId">packageId parametr</param>
        /// <returns>Configurated webserver or null</returns>
        private static WebServer GetWebServer(int packageId)
        {
            try
            {
                var webGroup = ServerController.GetResourceGroupByName(ResourceGroups.Web);
                var webProviders = ServerController.GetProvidersByGroupID(webGroup.GroupId);
                var esServiceInfo = ServerController.GetServiceInfo(GetEnterpriseStorageServiceID(packageId));

                var serverId = esServiceInfo.ServerId;

                foreach (var webProvider in webProviders)
                {
                    BoolResult result = ServerController.IsInstalled(serverId, webProvider.ProviderId);

                    if (result.IsSuccess && result.Value)
                    {
                        WebServer web = new WebServer();
                        ServerProxyConfigurator cnfg = new ServerProxyConfigurator();

                        cnfg.ProviderSettings.ProviderGroupID = webProvider.GroupId;
                        cnfg.ProviderSettings.ProviderCode = webProvider.ProviderName;
                        cnfg.ProviderSettings.ProviderName = webProvider.DisplayName;
                        cnfg.ProviderSettings.ProviderType = webProvider.ProviderType;

                        //// set service settings
                        //StringDictionary serviceSettings = ServerController.GetServiceSettings(serviceId);
                        //foreach (string key in serviceSettings.Keys)
                        //    cnfg.ProviderSettings.Settings[key] = serviceSettings[key];
                        cnfg.ProviderSettings.Settings["aspnet40path"] = @"%WINDIR%\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll";
                        cnfg.ProviderSettings.Settings["aspnet40x64path"] = @"%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\aspnet_isapi.dll";

                        ServiceProviderProxy.ServerInit(web, cnfg, serverId);

                        return web;
                    }
                }
            }
            catch { /*something wrong*/ }

            return null;
        }

        private static WebsitePanel.Providers.OS.OperatingSystem GetOS(int packageId)
        {
            var esServiceInfo = ServerController.GetServiceInfo(GetEnterpriseStorageServiceID(packageId));
            var esProviderInfo = ServerController.GetProvider(esServiceInfo.ProviderId);

            var osGroups = ServerController.GetResourceGroupByName(ResourceGroups.Os);
            var osProviders = ServerController.GetProvidersByGroupID(osGroups.GroupId);

            var regexResult = Regex.Match(esProviderInfo.ProviderType, "Windows([0-9]+)");

            if(regexResult.Success)
            {
                foreach(var osProvider in osProviders)
                {
                    BoolResult result = ServerController.IsInstalled(esServiceInfo.ServerId, osProvider.ProviderId);

                    if (result.IsSuccess && result.Value)
                    {
                        var os = new WebsitePanel.Providers.OS.OperatingSystem();
                        ServerProxyConfigurator cnfg = new ServerProxyConfigurator();

                        cnfg.ProviderSettings.ProviderGroupID = osProvider.GroupId;
                        cnfg.ProviderSettings.ProviderCode = osProvider.ProviderName;
                        cnfg.ProviderSettings.ProviderName = osProvider.DisplayName;
                        cnfg.ProviderSettings.ProviderType = osProvider.ProviderType;
                        
                        ServiceProviderProxy.ServerInit(os, cnfg, esServiceInfo.ServerId);

                        return os;
                    }
                }
            }

            return null;
        }

        public static OrganizationUser[] GetFolderOwaAccounts(int itemId, string folderName)
        {
            try
            {
                var folderId = GetFolderId(itemId, folderName);

                var users = ObjectUtils.CreateListFromDataReader<OrganizationUser>(DataProvider.GetEnterpriseFolderOwaUsers(itemId, folderId));

                return users.ToArray();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void SetFolderOwaAccounts(int itemId, string folderName, OrganizationUser[] users)
        {
            try
            {
                var folderId = GetFolderId(itemId, folderName);

                DataProvider.DeleteAllEnterpriseFolderOwaUsers(itemId, folderId);

                foreach (var user in users)
                {
                    DataProvider.AddEnterpriseFolderOwaUser(itemId, folderId, user.AccountId);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected static int GetFolderId(int itemId, string folderName)
        {
            try
            {
                GetFolder(itemId, folderName);

                var dataReader = DataProvider.GetEnterpriseFolderId(itemId, folderName);

                while (dataReader.Read())
                {
                    return (int)dataReader[0];
                }

                return -1;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static List<string> GetUserEnterpriseFolderWithOwaEditPermission(int itemId, List<int> accountIds)
        {
            try
            {
                var result = new List<string>();


                foreach (var accountId in accountIds)
                {
                    var reader =  DataProvider.GetUserEnterpriseFolderWithOwaEditPermission(itemId, accountId);

                    while (reader.Read())
                    {
                        result.Add(Convert.ToString(reader["FolderName"]));
                    }
                }

                return result.Distinct().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region WebDav portal

        public static string GetWebDavPortalUserSettingsByAccountId(int accountId)
        {
            var dataReader = DataProvider.GetWebDavPortalUserSettingsByAccountId(accountId);

            while (dataReader.Read())
            {
                return (string)dataReader["Settings"];
            }

            return null;
        }

        public static void UpdateUserSettings(int accountId, string settings)
        {
            var oldSettings = GetWebDavPortalUserSettingsByAccountId(accountId);

            if (string.IsNullOrEmpty(oldSettings))
            {
                DataProvider.AddWebDavPortalUsersSettings(accountId, settings);
            }
            else
            {
                DataProvider.UpdateWebDavPortalUsersSettings(accountId, settings);
            }
        }

        #endregion


        #region Statistics

        public static OrganizationStatistics GetStatistics(int itemId)
        {
            return GetStatisticsInternal(itemId, false);
        }

        public static OrganizationStatistics GetStatisticsByOrganization(int itemId)
        {
            return GetStatisticsInternal(itemId, true);
        }

        private static OrganizationStatistics GetStatisticsInternal(int itemId, bool byOrganization)
        {
            // place log record
            TaskManager.StartTask("ENTERPRISE_STORAGE", "GET_ORG_STATS", itemId);

            try
            {
                Organization org = (Organization)PackageController.GetPackageItem(itemId);
                if (org == null)
                    return null;

                OrganizationStatistics stats = new OrganizationStatistics();

                if (byOrganization)
                {
                    SystemFile[] folders = GetFolders(itemId);

                    stats.CreatedEnterpriseStorageFolders = folders.Count();

                    stats.UsedEnterpriseStorageSpace = folders.Where(x => x.FRSMQuotaMB != -1).Sum(x => x.FRSMQuotaMB);
                }
                else
                {
                    UserInfo user = ObjectUtils.FillObjectFromDataReader<UserInfo>(DataProvider.GetUserByExchangeOrganizationIdInternally(org.Id));
                    List<PackageInfo> Packages = PackageController.GetPackages(user.UserId);

                    if ((Packages != null) & (Packages.Count > 0))
                    {
                        foreach (PackageInfo Package in Packages)
                        {
                            List<Organization> orgs = null;

                            orgs = ExchangeServerController.GetExchangeOrganizations(Package.PackageId, false);

                            if ((orgs != null) & (orgs.Count > 0))
                            {
                                foreach (Organization o in orgs)
                                {
                                    SystemFile[] folders = GetFolders(o.Id);

                                    stats.CreatedEnterpriseStorageFolders += folders.Count();

                                    stats.UsedEnterpriseStorageSpace += folders.Where(x => x.FRSMQuotaMB != -1).Sum(x => x.FRSMQuotaMB);
                                }
                            }
                        }
                    }
                }

                // allocated quotas
                PackageContext cntx = PackageController.GetPackageContext(org.PackageId);
                stats.AllocatedEnterpriseStorageSpace = cntx.Quotas[Quotas.ENTERPRISESTORAGE_DISKSTORAGESPACE].QuotaAllocatedValue;
                stats.AllocatedEnterpriseStorageFolders = cntx.Quotas[Quotas.ENTERPRISESTORAGE_FOLDERS].QuotaAllocatedValue;

                return stats;
            }
            catch (Exception ex)
            {
                throw TaskManager.WriteError(ex);
            }
            finally
            {
                TaskManager.CompleteTask();
            }
        }

        #endregion

        #region Drive Mapping

        public static ResultObject CreateMappedDrive(int packageId, int itemId, string driveLetter, string labelAs, string folderName)
        {
            return CreateMappedDriveInternal(packageId, itemId, driveLetter, labelAs, folderName);
        }

        protected static ResultObject CreateMappedDriveInternal(int packageId, int itemId, string driveLetter, string labelAs, string folderName)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "CREATE_MAPPED_DRIVE", itemId);

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                    return result;
                }

                int esServiceId = PackageController.GetPackageServiceId(packageId, ResourceGroups.EnterpriseStorage);

                if (esServiceId != 0)
                {
                    StringDictionary esSesstings = ServerController.GetServiceSettings(esServiceId);

                    string path = string.Format(@"\\{0}@SSL\{1}\{2}", esSesstings["UsersDomain"].Split('.')[0], org.OrganizationId, folderName);

                    Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                    if (orgProxy.CreateMappedDrive(org.OrganizationId, driveLetter, labelAs, path) == 0)
                    {
                        var folder = GetFolder(itemId, folderName);

                        EnterpriseStorageController.SetDriveMapsTargetingFilter(org, ConvertToESPermission(itemId, folder.Rules), folderName);
                    }
                    else
                    {
                        result.AddError("", new Exception("Organization already has mapped drive for this folder"));
                        return result;
                    }
                }
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_CREATE_MAPPED_DRIVE", ex);
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

        public static ResultObject DeleteMappedDrive(int itemId, string driveLetter)
        {
            return DeleteMappedDriveInternal(itemId, driveLetter);
        }

        protected static ResultObject DeleteMappedDriveInternal(int itemId, string driveLetter)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "DELETE_MAPPED_DRIVE", itemId);

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                    return result;
                }

                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                orgProxy.DeleteMappedDrive(org.OrganizationId, driveLetter);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_DELETE_MAPPED_DRIVE", ex);
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

        public static MappedDrivesPaged GetDriveMapsPaged(int itemId, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetDriveMapsPagedInternal(itemId, filterValue, sortColumn, startRow, maximumRows);
        }

        protected static MappedDrivesPaged GetDriveMapsPagedInternal(int itemId, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            MappedDrivesPaged result = new MappedDrivesPaged();

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);

                if (org == null)
                {
                    return null;
                }

                EnterpriseStorage es = GetEnterpriseStorage(GetEnterpriseStorageServiceID(org.PackageId));

                var webDavSettings = ObjectUtils.CreateListFromDataReader<WebDavSetting>(
                DataProvider.GetEnterpriseFolders(itemId)).ToArray();

                List<SystemFile> folders = es.GetFolders(org.OrganizationId, webDavSettings).ToList();

                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                List<MappedDrive> mappedDrives = orgProxy.GetDriveMaps(org.OrganizationId).Where(x => x.LabelAs.Contains(filterValue)).ToList();
                List<MappedDrive> resultItems = new List<MappedDrive>();

                foreach (MappedDrive drive in mappedDrives)
                {
                    foreach (SystemFile folder in folders)
                    {
                        if (drive.Path.Split('\\').Last() == folder.Name)
                        {
                            drive.Folder = folder;
                            resultItems.Add(drive);
                        }
                    }
                }

                mappedDrives = resultItems;

                switch (sortColumn)
                {
                    case "Label":
                        mappedDrives = mappedDrives.OrderBy(x => x.LabelAs).ToList();
                        break;
                    default:
                        mappedDrives = mappedDrives.OrderBy(x => x.DriveLetter).ToList();
                        break;
                }

                result.RecordsCount = mappedDrives.Count;
                result.PageItems = mappedDrives.Skip(startRow).Take(maximumRows).ToArray();

            }
            catch (Exception ex) { throw ex; }

            return result;
        }

        public static string[] GetUsedDriveLetters(int itemId)
        {
            return GetUsedDriveLettersInternal(itemId);
        }

        protected static string[] GetUsedDriveLettersInternal(int itemId)
        {
            List<string> driveLetters = new List<string>();

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);

                if (org == null)
                {
                    return null;
                }

                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                driveLetters = orgProxy.GetDriveMaps(org.OrganizationId).Select(x => x.DriveLetter).ToList();
            }
            catch (Exception ex) { throw ex; }

            return driveLetters.ToArray();
            
        }

        public static SystemFile[] GetNotMappedEnterpriseFolders(int itemId)
        {
            return GetNotMappedEnterpriseFoldersInternal(itemId);
        }

        protected static SystemFile[] GetNotMappedEnterpriseFoldersInternal(int itemId)
        {
            List<SystemFile> folders = new List<SystemFile>();
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

                    var webDavSettings = ObjectUtils.CreateListFromDataReader<WebDavSetting>(
                    DataProvider.GetEnterpriseFolders(itemId)).ToArray();

                    folders = es.GetFolders(org.OrganizationId, webDavSettings).ToList();

                    Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                    List<MappedDrive> drives = orgProxy.GetDriveMaps(org.OrganizationId).ToList();

                    foreach (MappedDrive drive in drives)
                    {
                        foreach (SystemFile folder in folders)
                        {
                            if (drive.Path.Split('\\').Last() == folder.Name)
                            {
                                folders.Remove(folder);
                                break;
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { throw ex; }

            return folders.ToArray();
        }

        private static ResultObject SetDriveMapsTargetingFilter(Organization org, ESPermission[] permissions, string folderName)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "SET_MAPPED_DRIVE_TARGETING_FILTER");

            try
            {
                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                List<ExchangeAccount> accounts = new List<ExchangeAccount>();

                foreach (var permission in permissions)
                {
                    accounts.Add(ObjectUtils.FillObjectFromDataReader<ExchangeAccount>(DataProvider.GetExchangeAccountByAccountName(org.Id, permission.Account)));
                }

                orgProxy.SetDriveMapsTargetingFilter(org.OrganizationId, accounts.ToArray(), folderName);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_SET_MAPPED_DRIVE_TARGETING_FILTER", ex);
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

        private static ResultObject DeleteMappedDrivesGPO(int itemId)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("ENTERPRISE_STORAGE", "DELETE_MAPPED_DRIVES_GPO", itemId);

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                    return result;
                }

                Organizations orgProxy = OrganizationController.GetOrganizationProxy(org.ServiceId);

                orgProxy.DeleteMappedDrivesGPO(org.OrganizationId);
            }
            catch (Exception ex)
            {
                result.AddError("ENTERPRISE_STORAGE_DELETE_MAPPED_DRIVES_GPO", ex);
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

        #endregion
    }
}
