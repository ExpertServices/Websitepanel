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
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Net.Sockets;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.ComponentModel;
using Microsoft.Web.Services3;

using WebsitePanel.Providers;
using WebsitePanel.Providers.OS;
using WebsitePanel.Providers.RemoteDesktopServices;
using WebsitePanel.Server.Utils;

namespace WebsitePanel.Server
{
    /// <summary>
    /// Summary description for RemoteDesktopServices
    /// </summary>
    [WebService(Namespace = "http://smbsaas/websitepanel/server/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [Policy("ServerPolicy")]
    [ToolboxItem(false)]
    public class RemoteDesktopServices : HostingServiceProviderWebService, IRemoteDesktopServices
    {
        private IRemoteDesktopServices RDSProvider
        {
            get { return (IRemoteDesktopServices)Provider; }
        }

        [WebMethod, SoapHeader("settings")]
        public bool CreateCollection(string organizationId, RdsCollection collection)
        {
            try
            {
                Log.WriteStart("'{0}' CreateCollection", ProviderSettings.ProviderName);
                var result = RDSProvider.CreateCollection(organizationId, collection);
                Log.WriteEnd("'{0}' CreateCollection", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' CreateCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool AddRdsServersToDeployment(RdsServer[] servers)
        {
            try
            {
                Log.WriteStart("'{0}' AddRdsServersToDeployment", ProviderSettings.ProviderName);
                var result = RDSProvider.AddRdsServersToDeployment(servers);
                Log.WriteEnd("'{0}' AddRdsServersToDeployment", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddRdsServersToDeployment", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public RdsCollection GetCollection(string collectionName)
        {
            try
            {
                Log.WriteStart("'{0}' GetCollection", ProviderSettings.ProviderName);
                var result = RDSProvider.GetCollection(collectionName);
                Log.WriteEnd("'{0}' GetCollection", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool RemoveCollection(string organizationId, string collectionName)
        {
            try
            {
                Log.WriteStart("'{0}' RemoveCollection", ProviderSettings.ProviderName);
                var result = RDSProvider.RemoveCollection(organizationId, collectionName);
                Log.WriteEnd("'{0}' RemoveCollection", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' RemoveCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool SetUsersInCollection(string organizationId, string collectionName, List<string> users)
        {
            try
            {
                Log.WriteStart("'{0}' UpdateUsersInCollection", ProviderSettings.ProviderName);
                var result = RDSProvider.SetUsersInCollection(organizationId, collectionName, users);
                Log.WriteEnd("'{0}' UpdateUsersInCollection", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' UpdateUsersInCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void AddSessionHostServerToCollection(string organizationId, string collectionName, RdsServer server)
        {
            try
            {
                Log.WriteStart("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName);
                RDSProvider.AddSessionHostServerToCollection(organizationId, collectionName, server);
                Log.WriteEnd("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void AddSessionHostServersToCollection(string organizationId, string collectionName, List<RdsServer> servers)
        {
            try
            {
                Log.WriteStart("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName);
                RDSProvider.AddSessionHostServersToCollection(organizationId, collectionName, servers);
                Log.WriteEnd("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void RemoveSessionHostServerFromCollection(string organizationId, string collectionName, RdsServer server)
        {
            try
            {
                Log.WriteStart("'{0}' RemoveSessionHostServerFromCollection", ProviderSettings.ProviderName);
                RDSProvider.RemoveSessionHostServerFromCollection(organizationId, collectionName, server);
                Log.WriteEnd("'{0}' RemoveSessionHostServerFromCollection", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' RemoveSessionHostServerFromCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void RemoveSessionHostServersFromCollection(string organizationId, string collectionName, List<RdsServer> servers)
        {
            try
            {
                Log.WriteStart("'{0}' RemoveSessionHostServersFromCollection", ProviderSettings.ProviderName);
                RDSProvider.RemoveSessionHostServersFromCollection(organizationId, collectionName, servers);
                Log.WriteEnd("'{0}' RemoveSessionHostServersFromCollection", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' RemoveSessionHostServersFromCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public void SetRDServerNewConnectionAllowed(bool newConnectionAllowed, RdsServer server)
        {
            try
            {
                Log.WriteStart("'{0}' SetRDServerNewConnectionAllowed", ProviderSettings.ProviderName);
                RDSProvider.SetRDServerNewConnectionAllowed(newConnectionAllowed, server);
                Log.WriteEnd("'{0}' SetRDServerNewConnectionAllowed", ProviderSettings.ProviderName);
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' SetRDServerNewConnectionAllowed", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public List<StartMenuApp> GetAvailableRemoteApplications(string collectionName)
        {
            try
            {
                Log.WriteStart("'{0}' GetAvailableRemoteApplications", ProviderSettings.ProviderName);
                var result = RDSProvider.GetAvailableRemoteApplications(collectionName);
                Log.WriteEnd("'{0}' GetAvailableRemoteApplications", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' UpdateUsersInCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public List<RemoteApplication> GetCollectionRemoteApplications(string collectionName)
        {
            try
            {
                Log.WriteStart("'{0}' GetCollectionRemoteApplications", ProviderSettings.ProviderName);
                var result = RDSProvider.GetCollectionRemoteApplications(collectionName);
                Log.WriteEnd("'{0}' GetCollectionRemoteApplications", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetCollectionRemoteApplications", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool AddRemoteApplication(string collectionName, RemoteApplication remoteApp)
        {
            try
            {
                Log.WriteStart("'{0}' AddRemoteApplication", ProviderSettings.ProviderName);
                var result = RDSProvider.AddRemoteApplication(collectionName, remoteApp);
                Log.WriteEnd("'{0}' AddRemoteApplication", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddRemoteApplication", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool AddRemoteApplications(string collectionName, List<RemoteApplication> remoteApps)
        {
            try
            {
                Log.WriteStart("'{0}' AddRemoteApplications", ProviderSettings.ProviderName);
                var result = RDSProvider.AddRemoteApplications(collectionName, remoteApps);
                Log.WriteEnd("'{0}' AddRemoteApplications", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddRemoteApplications", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool RemoveRemoteApplication(string collectionName, RemoteApplication remoteApp)
        {
            try
            {
                Log.WriteStart("'{0}' RemoveRemoteApplication", ProviderSettings.ProviderName);
                var result = RDSProvider.RemoveRemoteApplication(collectionName, remoteApp);
                Log.WriteEnd("'{0}' RemoveRemoteApplication", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' RemoveRemoteApplication", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool AddSessionHostFeatureToServer(string hostName)
        {
            try
            {
                Log.WriteStart("'{0}' AddSessionHostFeatureToServer", ProviderSettings.ProviderName);
                var result = RDSProvider.AddSessionHostFeatureToServer(hostName);
                Log.WriteEnd("'{0}' AddSessionHostFeatureToServer", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' AddSessionHostServersToCollection", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool CheckSessionHostFeatureInstallation(string hostName)
        {
            try
            {
                Log.WriteStart("'{0}' CheckSessionHostFeatureInstallation", ProviderSettings.ProviderName);
                var result = RDSProvider.CheckSessionHostFeatureInstallation(hostName);
                Log.WriteEnd("'{0}' CheckSessionHostFeatureInstallation", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' CheckSessionHostFeatureInstallation", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool CheckServerAvailability(string hostName)
        {
            try
            {
                Log.WriteStart("'{0}' CheckServerAvailability", ProviderSettings.ProviderName);
                var result = RDSProvider.CheckServerAvailability(hostName);
                Log.WriteEnd("'{0}' CheckServerAvailability", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' CheckServerAvailability", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public string[] GetApplicationUsers(string collectionName, string applicationName)
        {
            try
            {
                Log.WriteStart("'{0}' GetApplicationUsers", ProviderSettings.ProviderName);
                var result = RDSProvider.GetApplicationUsers(collectionName, applicationName);
                Log.WriteEnd("'{0}' GetApplicationUsers", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetApplicationUsers", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool SetApplicationUsers(string collectionName, RemoteApplication remoteApp, string[] users)
        {
            try
            {
                Log.WriteStart("'{0}' SetApplicationUsers", ProviderSettings.ProviderName);
                var result = RDSProvider.SetApplicationUsers(collectionName, remoteApp, users);
                Log.WriteEnd("'{0}' SetApplicationUsers", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' SetApplicationUsers", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public bool CheckRDSServerAvaliable(string hostname)
        {
            try
            {
                Log.WriteStart("'{0}' CheckRDSServerAvaliable", ProviderSettings.ProviderName);
                var result = RDSProvider.CheckRDSServerAvaliable(hostname);
                Log.WriteEnd("'{0}' CheckRDSServerAvaliable", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' CheckRDSServerAvaliable", ProviderSettings.ProviderName), ex);
                throw;
            }
        }

        [WebMethod, SoapHeader("settings")]
        public List<string> GetServersExistingInCollections()
        {
            try
            {
                Log.WriteStart("'{0}' GetServersExistingInCollections", ProviderSettings.ProviderName);
                var result = RDSProvider.GetServersExistingInCollections();
                Log.WriteEnd("'{0}' GetServersExistingInCollections", ProviderSettings.ProviderName);
                return result;
            }
            catch (Exception ex)
            {
                Log.WriteError(String.Format("'{0}' GetServersExistingInCollections", ProviderSettings.ProviderName), ex);
                throw;
            }
        }
    }
}
