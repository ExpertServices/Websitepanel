// Copyright (c) 2014, Outercurve Foundation.
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
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Net.NetworkInformation;
using System.Runtime.CompilerServices;
using System.Xml;
using System.Data;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Text;
using WebsitePanel.Providers.Common;
using WebsitePanel.Providers.EnterpriseStorage;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.Providers.OS;
using WebsitePanel.Providers.RemoteDesktopServices;
using WebsitePanel.Providers.Web;

namespace WebsitePanel.EnterpriseServer
{
    public class RemoteDesktopServicesController
    {
        private RemoteDesktopServicesController()
        {

        }

        public static RdsCollection GetRdsCollection(int collectionId)
        {
            return GetRdsCollectionInternal(collectionId);
        }

        public static List<RdsCollection> GetOrganizationRdsCollections(int itemId)
        {
            return GetOrganizationRdsCollectionsInternal(itemId);
        }

        public static ResultObject AddRdsCollection(int itemId, RdsCollection collection)
        {
            return AddRdsCollectionInternal(itemId, collection);
        }

        public static ResultObject EditRdsCollection(int itemId, RdsCollection collection)
        {
            return EditRdsCollectionInternal(itemId, collection);
        }

        public static RdsCollectionPaged GetRdsCollectionsPaged(int itemId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetRdsCollectionsPagedInternal(itemId, filterColumn, filterValue, sortColumn, startRow, maximumRows);
        }

        public static ResultObject RemoveRdsCollection(int itemId, RdsCollection collection)
        {
            return RemoveRdsCollectionInternal(itemId, collection);
        }

        public static List<StartMenuApp> GetAvailableRemoteApplications(int itemId, string collectionName)
        {
            return GetAvailableRemoteApplicationsInternal(itemId, collectionName);
        }

        public static RdsServersPaged GetRdsServersPaged(string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetRdsServersPagedInternal(filterColumn, filterValue, sortColumn, startRow, maximumRows);
        }

        public static RdsServersPaged GetFreeRdsServersPaged(int packageId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetFreeRdsServersPagedInternal(packageId, filterColumn, filterValue, sortColumn, startRow, maximumRows);
        }

        public static RdsServersPaged GetOrganizationRdsServersPaged(int itemId, int? collectionId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetOrganizationRdsServersPagedInternal(itemId, collectionId, filterColumn, filterValue, sortColumn, startRow, maximumRows);
        }

        public static RdsServersPaged GetOrganizationFreeRdsServersPaged(int itemId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            return GetOrganizationFreeRdsServersPagedInternal(itemId, filterColumn, filterValue, sortColumn, startRow, maximumRows);
        }

        public static RdsServer GetRdsServer(int rdsSeverId)
        {
            return GetRdsServerInternal(rdsSeverId);
        }

        public static ResultObject SetRDServerNewConnectionAllowed(int itemId, bool newConnectionAllowed, int rdsSeverId)
        {
            return SetRDServerNewConnectionAllowedInternal(itemId, newConnectionAllowed, rdsSeverId);
        }

        public static List<RdsServer> GetCollectionRdsServers(int collectionId)
        {
            return GetCollectionRdsServersInternal(collectionId);
        }

        public static List<RdsServer> GetOrganizationRdsServers(int itemId)
        {
            return GetOrganizationRdsServersInternal(itemId);
        }

        public static ResultObject AddRdsServer(RdsServer rdsServer)
        {
            return AddRdsServerInternal(rdsServer);
        }

        public static ResultObject AddRdsServerToCollection(int itemId, RdsServer rdsServer, RdsCollection rdsCollection)
        {
            return AddRdsServerToCollectionInternal(itemId, rdsServer, rdsCollection);
        }

        public static ResultObject AddRdsServerToOrganization(int itemId, int serverId)
        {
            return AddRdsServerToOrganizationInternal(itemId, serverId);
        }

        public static ResultObject RemoveRdsServer(int rdsServerId)
        {
            return RemoveRdsServerInternal(rdsServerId);
        }

        public static ResultObject RemoveRdsServerFromCollection(int itemId, RdsServer rdsServer, RdsCollection rdsCollection)
        {
            return RemoveRdsServerFromCollectionInternal(itemId, rdsServer, rdsCollection);
        }

        public static ResultObject RemoveRdsServerFromOrganization(int rdsServerId)
        {
            return RemoveRdsServerFromOrganizationInternal(rdsServerId);
        }

        public static ResultObject UpdateRdsServer(RdsServer rdsServer)
        {
            return UpdateRdsServerInternal(rdsServer);
        }

        public static List<OrganizationUser> GetRdsCollectionUsers(int collectionId)
        {
            return GetRdsCollectionUsersInternal(collectionId);
        }

        public static ResultObject SetUsersToRdsCollection(int itemId, int collectionId, List<OrganizationUser> users)
        {
            return SetUsersToRdsCollectionInternal(itemId, collectionId, users);
        }

        public static ResultObject AddRemoteApplicationToCollection(int itemId, RdsCollection collection, RemoteApplication application)
        {
            return AddRemoteApplicationToCollectionInternal(itemId, collection, application);
        }

        public static List<RemoteApplication> GetCollectionRemoteApplications(int itemId, string collectionName)
        {
            return GetCollectionRemoteApplicationsInternal(itemId, collectionName);
        }

        public static ResultObject RemoveRemoteApplicationFromCollection(int itemId, RdsCollection collection, RemoteApplication application)
        {
            return RemoveRemoteApplicationFromCollectionInternal(itemId, collection, application);
        }

        public static ResultObject SetRemoteApplicationsToRdsCollection(int itemId, int collectionId, List<RemoteApplication> remoteApps)
        {
            return SetRemoteApplicationsToRdsCollectionInternal(itemId, collectionId, remoteApps);
        }

        public static ResultObject DeleteRemoteDesktopService(int itemId)
        {
            return DeleteRemoteDesktopServiceInternal(itemId);
        }

        public static int GetOrganizationRdsUsersCount(int itemId)
        {
            return GetOrganizationRdsUsersCountInternal(itemId);
        }

        public static List<string> GetApplicationUsers(int itemId, int collectionId, RemoteApplication remoteApp)
        {
            return GetApplicationUsersInternal(itemId, collectionId, remoteApp);
        }

        public static ResultObject SetApplicationUsers(int itemId, int collectionId, RemoteApplication remoteApp, List<string> users)
        {
            return SetApplicationUsersInternal(itemId, collectionId, remoteApp, users);
        }

        private static RdsCollection GetRdsCollectionInternal(int collectionId)
        {
            var collection = ObjectUtils.FillObjectFromDataReader<RdsCollection>(DataProvider.GetRDSCollectionById(collectionId));

            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_RDS_COLLECTION");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(4115);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                }

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                rds.GetCollection(collection.Name);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_COLLECTION", ex);
            }

            FillRdsCollection(collection);

            return collection;
        }

        private static List<RdsCollection> GetOrganizationRdsCollectionsInternal(int itemId)
        {
            var collections = ObjectUtils.CreateListFromDataReader<RdsCollection>(DataProvider.GetRDSCollectionsByItemId(itemId));

            foreach (var rdsCollection in collections)
            {
                FillRdsCollection(rdsCollection);
            }

            return collections;
        }

        private static ResultObject AddRdsCollectionInternal(int itemId, RdsCollection collection)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_RDS_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));
                collection.Name = GetFormattedCollectionName(collection.DisplayName, org.OrganizationId);
                rds.CreateCollection(org.OrganizationId, collection);                
                collection.Id = DataProvider.AddRDSCollection(itemId, collection.Name, collection.Description, collection.DisplayName);

                foreach (var server in collection.Servers)
                {
                    DataProvider.AddRDSServerToCollection(server.Id, collection.Id);
                }
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_COLLECTION", ex);
                throw TaskManager.WriteError(ex);
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

        private static ResultObject EditRdsCollectionInternal(int itemId, RdsCollection collection)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "EDIT_RDS_COLLECTION");

            try
            {                
                Organization org = OrganizationController.GetOrganization(itemId);

                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                    return result;
                }

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));
                var existingServers =
                    ObjectUtils.CreateListFromDataReader<RdsServer>(DataProvider.GetRDSServersByCollectionId(collection.Id)).ToList();
                var removedServers = existingServers.Where(x => !collection.Servers.Select(y => y.Id).Contains(x.Id));
                var newServers = collection.Servers.Where(x => !existingServers.Select(y => y.Id).Contains(x.Id));

                foreach(var server in removedServers)
                {
                    DataProvider.RemoveRDSServerFromCollection(server.Id);
                }

                rds.AddRdsServersToDeployment(newServers.ToArray());

                foreach (var server in newServers)
                {                    
                    DataProvider.AddRDSServerToCollection(server.Id, collection.Id);
                }
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_COLLECTION", ex);
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

        private static RdsCollectionPaged GetRdsCollectionsPagedInternal(int itemId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            DataSet ds = DataProvider.GetRDSCollectionsPaged(itemId, filterColumn, filterValue, sortColumn, startRow, maximumRows);

            var result = new RdsCollectionPaged
            {
                RecordsCount = (int)ds.Tables[0].Rows[0][0]
            };

            List<RdsCollection> tmpCollections = new List<RdsCollection>();

            ObjectUtils.FillCollectionFromDataView(tmpCollections, ds.Tables[1].DefaultView);

            foreach (var collection in tmpCollections)
            {
                collection.Servers = GetCollectionRdsServersInternal(collection.Id);
            }

            result.Collections = tmpCollections.ToArray();

            return result;
        }

        private static ResultObject RemoveRdsCollectionInternal(int itemId, RdsCollection collection)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "REMOVE_RDS_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                rds.RemoveCollection(org.OrganizationId, collection.Name);

                DataProvider.DeleteRDSCollection(collection.Id);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_REMOVE_RDS_COLLECTION", ex);
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

        private static List<StartMenuApp> GetAvailableRemoteApplicationsInternal(int itemId, string collectionName)
        {
            var result = new List<StartMenuApp>();

            var taskResult = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES",
                "GET_AVAILABLE_REMOTE_APPLICATIOBNS");

            try
            {
                // load organization
                Organization org = OrganizationController.GetOrganization(itemId);

                if (org == null)
                {
                    return result;
                }

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                result.AddRange(rds.GetAvailableRemoteApplications(collectionName));
            }
            catch (Exception ex)
            {
                taskResult.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_COLLECTION", ex);
            }
            finally
            {
                if (!taskResult.IsSuccess)
                {
                    TaskManager.CompleteResultTask(taskResult);
                }
                else
                {
                    TaskManager.CompleteResultTask();
                }
            }

            return result;
        }

        private static RdsServersPaged GetRdsServersPagedInternal(string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            DataSet ds = DataProvider.GetRDSServersPaged(null, null, filterColumn, filterValue, sortColumn, startRow, maximumRows, true, true);

            RdsServersPaged result = new RdsServersPaged();
            result.RecordsCount = (int)ds.Tables[0].Rows[0][0];

            List<RdsServer> tmpServers = new List<RdsServer>();

            ObjectUtils.FillCollectionFromDataView(tmpServers, ds.Tables[1].DefaultView);

            foreach (var tmpServer in tmpServers)
            {
                FillRdsServerData(tmpServer);
            }

            result.Servers = tmpServers.ToArray();

            return result;
        }

        private static RdsServersPaged GetFreeRdsServersPagedInternal(int itemId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            RdsServersPaged result = new RdsServersPaged();
            Organization org = OrganizationController.GetOrganization(itemId);

            if (org == null)
            {
                return result;
            }

            var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));
            var existingServers = rds.GetServersExistingInCollections();

            DataSet ds = DataProvider.GetRDSServersPaged(null, null, filterColumn, filterValue, sortColumn, startRow, maximumRows);            
            result.RecordsCount = (int)ds.Tables[0].Rows[0][0];

            List<RdsServer> tmpServers = new List<RdsServer>();

            ObjectUtils.FillCollectionFromDataView(tmpServers, ds.Tables[1].DefaultView);
            tmpServers = tmpServers.Where(x => !existingServers.Select(y => y.ToUpper()).Contains(x.FqdName.ToUpper())).ToList();
            result.Servers = tmpServers.ToArray();

            return result;
        }

        private static RdsServersPaged GetOrganizationRdsServersPagedInternal(int itemId, int? collectionId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            DataSet ds = DataProvider.GetRDSServersPaged(itemId, collectionId, filterColumn, filterValue, sortColumn, startRow, maximumRows, ignoreRdsCollectionId: !collectionId.HasValue);

            RdsServersPaged result = new RdsServersPaged();
            result.RecordsCount = (int)ds.Tables[0].Rows[0][0];

            List<RdsServer> tmpServers = new List<RdsServer>();

            ObjectUtils.FillCollectionFromDataView(tmpServers, ds.Tables[1].DefaultView);

            result.Servers = tmpServers.ToArray();

            return result;
        }

        private static RdsServersPaged GetOrganizationFreeRdsServersPagedInternal(int itemId, string filterColumn, string filterValue, string sortColumn, int startRow, int maximumRows)
        {
            DataSet ds = DataProvider.GetRDSServersPaged(itemId, null, filterColumn, filterValue, sortColumn, startRow, maximumRows);

            RdsServersPaged result = new RdsServersPaged();
            result.RecordsCount = (int)ds.Tables[0].Rows[0][0];

            List<RdsServer> tmpServers = new List<RdsServer>();

            ObjectUtils.FillCollectionFromDataView(tmpServers, ds.Tables[1].DefaultView);

            result.Servers = tmpServers.ToArray();

            return result;
        }

        private static RdsServer GetRdsServerInternal(int rdsSeverId)
        {
            return ObjectUtils.FillObjectFromDataReader<RdsServer>(DataProvider.GetRDSServerById(rdsSeverId));
        }

        private static ResultObject SetRDServerNewConnectionAllowedInternal(int itemId, bool newConnectionAllowed, int rdsSeverId)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "SET_RDS_SERVER_NEW_CONNECTIONS_ALLOWED"); ;
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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                var rdsServer = GetRdsServer(rdsSeverId);                

                if (rdsServer == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("RDS Server not found"));
                    return result;
                }

                rds.SetRDServerNewConnectionAllowed(newConnectionAllowed, rdsServer);
                rdsServer.ConnectionEnabled = newConnectionAllowed;
                DataProvider.UpdateRDSServer(rdsServer);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_SET_RDS_SERVER_NEW_CONNECTIONS_ALLOWED", ex);
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

        private static int GetOrganizationRdsUsersCountInternal(int itemId)
        {
            return DataProvider.GetOrganizationRdsUsersCount(itemId);
        }


        private static List<RdsServer> GetCollectionRdsServersInternal(int collectionId)
        {
            return ObjectUtils.CreateListFromDataReader<RdsServer>(DataProvider.GetRDSServersByCollectionId(collectionId)).ToList();
        }

        private static List<RdsServer> GetOrganizationRdsServersInternal(int itemId)
        {
            return ObjectUtils.CreateListFromDataReader<RdsServer>(DataProvider.GetRDSServersByItemId(itemId)).ToList();
        }

        private static ResultObject AddRdsServerInternal(RdsServer rdsServer)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_RDS_SERVER");

            try
            {
                if (CheckRDSServerAvaliable(rdsServer.FqdName))
                {
                    rdsServer.Id = DataProvider.AddRDSServer(rdsServer.Name, rdsServer.FqdName, rdsServer.Description);
                }
                else
                {
                    result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_SERVER", new Exception("The server that you are adding, is not available"));
                    return result;
                }
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                {
                    result.AddError("Unable to add RDS Server", ex.InnerException);
                }
                else
                {
                    result.AddError("Unable to add RDS Server", ex);
                }
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

        private static ResultObject AddRdsServerToCollectionInternal(int itemId, RdsServer rdsServer, RdsCollection rdsCollection)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_RDS_SERVER_TO_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                if (!rds.CheckSessionHostFeatureInstallation(rdsServer.FqdName))
                {
                    rds.AddSessionHostFeatureToServer(rdsServer.FqdName);
                }

                rds.AddSessionHostServerToCollection(org.OrganizationId, rdsCollection.Name, rdsServer);

                DataProvider.AddRDSServerToCollection(rdsServer.Id, rdsCollection.Id);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_SERVER_TO_COLLECTION", ex);
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

        private static ResultObject RemoveRdsServerFromCollectionInternal(int itemId, RdsServer rdsServer, RdsCollection rdsCollection)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "REMOVE_RDS_SERVER_FROM_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                rds.RemoveSessionHostServerFromCollection(org.OrganizationId, rdsCollection.Name, rdsServer);

                DataProvider.RemoveRDSServerFromCollection(rdsServer.Id);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_REMOVE_RDS_SERVER_FROM_COLLECTION", ex);
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

        private static ResultObject UpdateRdsServerInternal(RdsServer rdsServer)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "UPDATE_RDS_SERVER");

            try
            {
                DataProvider.UpdateRDSServer(rdsServer);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_UPDATE_RDS_SERVER", ex);
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

        private static ResultObject AddRdsServerToOrganizationInternal(int itemId, int serverId)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_RDS_SERVER_TO_ORGANIZATION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                RdsServer rdsServer = GetRdsServer(serverId);

                //if (!rds.CheckSessionHostFeatureInstallation(rdsServer.FqdName))
                {
                    rds.AddSessionHostFeatureToServer(rdsServer.FqdName);
                }

                DataProvider.AddRDSServerToOrganization(itemId, serverId);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_RDS_SERVER_TO_ORGANIZATION", ex);
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

        private static ResultObject RemoveRdsServerFromOrganizationInternal(int rdsServerId)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "REMOVE_RDS_SERVER_FROM_ORGANIZATION");

            try
            {
                DataProvider.RemoveRDSServerFromOrganization(rdsServerId);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_REMOVE_RDS_SERVER_FROM_ORGANIZATION", ex);
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

        private static ResultObject RemoveRdsServerInternal(int rdsServerId)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "REMOVE_RDS_SERVER");

            try
            {
                DataProvider.DeleteRDSServer(rdsServerId);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_REMOVE_RDS_SERVER", ex);
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

        private static List<OrganizationUser> GetRdsCollectionUsersInternal(int collectionId)
        {
            return ObjectUtils.CreateListFromDataReader<OrganizationUser>(DataProvider.GetRDSCollectionUsersByRDSCollectionId(collectionId));
        }        

        private static ResultObject SetUsersToRdsCollectionInternal(int itemId, int collectionId, List<OrganizationUser> users)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_USER_TO_RDS_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                var collection = GetRdsCollection(collectionId);

                if (collection == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Collection not found"));
                    return result;
                }

                foreach(var user in users)
                {
                    var account = OrganizationController.GetAccountByAccountName(itemId, user.AccountName);

                    user.AccountId = account.AccountId;
                }

                var usersInDb = GetRdsCollectionUsers(collectionId);

                var usersAccountNames = users.Select(x => x.AccountName).ToList();

                //Set on server
                rds.SetUsersInCollection(org.OrganizationId, collection.Name, users.Select(x => x.AccountName).ToArray());

                //Remove from db
                foreach (var userInDb in usersInDb)
                {
                    if (!usersAccountNames.Contains(userInDb.AccountName))
                    {
                        DataProvider.RemoveRDSUserFromRDSCollection(collectionId, userInDb.AccountId);
                    }
                }

                //Add to db
                foreach (var user in users)
                {
                    if (!usersInDb.Select(x => x.AccountName).Contains(user.AccountName))
                    {
                        DataProvider.AddRDSUserToRDSCollection(collectionId, user.AccountId);
                    }
                }

            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_USER_TO_RDS_COLLECTION", ex);
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

        private static List<string> GetApplicationUsersInternal(int itemId, int collectionId, RemoteApplication remoteApp)
        {
            var result = new List<string>();
            Organization org = OrganizationController.GetOrganization(itemId);

            if (org == null)
            {
                return result;
            }

            var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));
            var collection = GetRdsCollection(collectionId);

            result.AddRange(rds.GetApplicationUsers(collection.Name, remoteApp.DisplayName));

            return result;
        }

        private static ResultObject SetApplicationUsersInternal(int itemId, int collectionId, RemoteApplication remoteApp, List<string> users)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "SET_REMOTE_APP_USERS");

            try
            {                
                Organization org = OrganizationController.GetOrganization(itemId);
                if (org == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Organization not found"));
                    return result;
                }

                var collection = GetRdsCollection(collectionId);
                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));
                rds.SetApplicationUsers(collection.Name, remoteApp, users.ToArray());
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_SET_REMOTE_APP_USERS", ex);
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

        private static ResultObject AddRemoteApplicationToCollectionInternal(int itemId, RdsCollection collection, RemoteApplication remoteApp)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "ADD_REMOTE_APP_TO_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                if (!string.IsNullOrEmpty(remoteApp.Alias))
                {
                    remoteApp.Alias = remoteApp.DisplayName;
                }

                remoteApp.ShowInWebAccess = true;

                rds.AddRemoteApplication(collection.Name, remoteApp);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_ADD_REMOTE_APP_TO_COLLECTION", ex);
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

        private static List<RemoteApplication> GetCollectionRemoteApplicationsInternal(int itemId, string collectionName)
        {
            var result = new List<RemoteApplication>();

            // load organization
            Organization org = OrganizationController.GetOrganization(itemId);

            if (org == null)
            {
                return result;
            }

            var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

            result.AddRange(rds.GetCollectionRemoteApplications(collectionName));

            return result;
        }

        private static ResultObject RemoveRemoteApplicationFromCollectionInternal(int itemId, RdsCollection collection, RemoteApplication application)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "REMOVE_REMOTE_APP_FROM_COLLECTION");

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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                rds.RemoveRemoteApplication(collection.Name, application);
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_REMOVE_REMOTE_APP_FROM_COLLECTION", ex);
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

        private static ResultObject SetRemoteApplicationsToRdsCollectionInternal(int itemId, int collectionId, List<RemoteApplication> remoteApps)
        {
            ResultObject result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "SET_APPS_TO_RDS_COLLECTION"); ;
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

                var rds = GetRemoteDesktopServices(GetRemoteDesktopServiceID(org.PackageId));

                var collection = GetRdsCollection(collectionId);

                if (collection == null)
                {
                    result.IsSuccess = false;
                    result.AddError("", new NullReferenceException("Collection not found"));
                    return result;
                }

                List<RemoteApplication> existingCollectionApps = GetCollectionRemoteApplications(itemId, collection.Name);
                List<RemoteApplication> remoteAppsToAdd = remoteApps.Where(x => !existingCollectionApps.Select(p => p.DisplayName).Contains(x.DisplayName)).ToList();
                foreach (var app in remoteAppsToAdd)
                {
                    AddRemoteApplicationToCollection(itemId, collection, app);
                }

                List<RemoteApplication> remoteAppsToRemove = existingCollectionApps.Where(x => !remoteApps.Select(p => p.DisplayName).Contains(x.DisplayName)).ToList();
                foreach (var app in remoteAppsToRemove)
                {
                    RemoveRemoteApplicationFromCollection(itemId, collection, app);
                }
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_SET_APPS_TO_RDS_COLLECTION", ex);
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

        private static RdsCollection FillRdsCollection(RdsCollection collection)
        {
            collection.Servers = GetCollectionRdsServers(collection.Id) ?? new List<RdsServer>();

            return collection;
        }

        private static RdsServer FillRdsServerData(RdsServer server)
        {
            server.Address = GetServerIp(server.FqdName).ToString();

            return server;
        }

        private static System.Net.IPAddress GetServerIp(string hostname, AddressFamily addressFamily = AddressFamily.InterNetwork)
        {
            var address = GetServerIps(hostname);

            return address.FirstOrDefault(x => x.AddressFamily == addressFamily);
        }

        private static IEnumerable<System.Net.IPAddress> GetServerIps(string hostname)
        {
            var address = Dns.GetHostAddresses(hostname);

            return address;
        }

        private static bool CheckRDSServerAvaliable(string hostname)
        {
            bool result = false;
            var ping = new Ping();
            var reply = ping.Send(hostname, 1000);

            if (reply.Status == IPStatus.Success)
            {
                result = true;
            }

            return result;
        }


        private static ResultObject DeleteRemoteDesktopServiceInternal(int itemId)
        {
            var result = TaskManager.StartResultTask<ResultObject>("REMOTE_DESKTOP_SERVICES", "CLEANUP");

            try
            {
                var collections = GetOrganizationRdsCollections(itemId);

                foreach (var collection in collections)
                {
                    RemoveRdsCollection(itemId, collection);
                }

                var servers = GetOrganizationRdsServers(itemId);

                foreach (var server in servers)
                {
                    RemoveRdsServerFromOrganization(server.Id);
                }
            }
            catch (Exception ex)
            {
                result.AddError("REMOTE_DESKTOP_SERVICES_CLEANUP", ex);
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

        private static int GetRemoteDesktopServiceID(int packageId)
        {
            return PackageController.GetPackageServiceId(packageId, ResourceGroups.RDS);
        }

        private static RemoteDesktopServices GetRemoteDesktopServices(int serviceId)
        {
            var rds = new RemoteDesktopServices();
            ServiceProviderProxy.Init(rds, serviceId);

            return rds;
        }

        private static string GetFormattedCollectionName(string displayName, string organizationId)
        {
            return string.Format("{0}-{1}", organizationId, displayName.Replace(" ", "_"));
        }
    }
}