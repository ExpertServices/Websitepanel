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
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Providers.RemoteDesktopServices
{
    /// <summary>
    /// Summary description for IRemoteDesktopServices.
    /// </summary>
    public interface IRemoteDesktopServices
    {
        bool CreateCollection(string organizationId, RdsCollection collection);
        bool AddRdsServersToDeployment(RdsServer[] servers);
        RdsCollection GetCollection(string collectionName);
        bool RemoveCollection(string organizationId, string collectionName, List<RdsServer> servers);
        bool SetUsersInCollection(string organizationId, string collectionName, List<string> users);
        void AddSessionHostServerToCollection(string organizationId, string collectionName, RdsServer server);
        void AddSessionHostServersToCollection(string organizationId, string collectionName, List<RdsServer> servers);
        void RemoveSessionHostServerFromCollection(string organizationId, string collectionName, RdsServer server);
        void RemoveSessionHostServersFromCollection(string organizationId, string collectionName, List<RdsServer> servers);

        void SetRDServerNewConnectionAllowed(bool newConnectionAllowed, RdsServer server);

        List<StartMenuApp> GetAvailableRemoteApplications(string collectionName);
        List<RemoteApplication> GetCollectionRemoteApplications(string collectionName);
        bool AddRemoteApplication(string collectionName, RemoteApplication remoteApp);
        bool AddRemoteApplications(string collectionName, List<RemoteApplication> remoteApps);
        bool RemoveRemoteApplication(string collectionName, RemoteApplication remoteApp);

        bool AddSessionHostFeatureToServer(string hostName);
        bool CheckSessionHostFeatureInstallation(string hostName);

        bool CheckServerAvailability(string hostName);
        string[] GetApplicationUsers(string collectionName, string applicationName);
        bool SetApplicationUsers(string collectionName, RemoteApplication remoteApp, string[] users);
        bool CheckRDSServerAvaliable(string hostname);
        List<string> GetServersExistingInCollections();
        void EditRdsCollectionSettings(RdsCollection collection);
        List<RdsUserSession> GetRdsUserSessions(string collectionName);
        void LogOffRdsUser(string unifiedSessionId, string hostServer);
        List<string> GetRdsCollectionSessionHosts(string collectionName);
        RdsServerInfo GetRdsServerInfo(string serverName);
        string GetRdsServerStatus(string serverName);
        void ShutDownRdsServer(string serverName);
        void RestartRdsServer(string serverName);
        void SaveRdsCollectionLocalAdmins(List<OrganizationUser> users, List<string> hosts);
        List<string> GetRdsCollectionLocalAdmins(string hostName);
        void MoveRdsServerToTenantOU(string hostName, string organizationId);
        void RemoveRdsServerFromTenantOU(string hostName, string organizationId);
        void InstallCertificate(byte[] certificate, string password, List<string> hostNames);
    }
}
