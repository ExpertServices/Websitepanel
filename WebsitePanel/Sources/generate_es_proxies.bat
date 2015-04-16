SET WSDL="C:\Program Files (x86)\Microsoft WSE\v3.0\Tools\WseWsdl3.exe"
SET WSE_CLEAN=..\Tools\WseClean.exe
SET SERVER_URL=http://localhost:9002

REM %WSDL% %SERVER_URL%/esApplicationsInstaller.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ApplicationsInstallerProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ApplicationsInstallerProxy.cs

REM %WSDL% %SERVER_URL%/esAuditLog.asmx /out:.\WebsitePanel.EnterpriseServer.Client\AuditLogProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\AuditLogProxy.cs

REM %WSDL% %SERVER_URL%/esAuthentication.asmx /out:.\WebsitePanel.EnterpriseServer.Client\AuthenticationProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\AuthenticationProxy.cs

REM %WSDL% %SERVER_URL%/esBackup.asmx /out:.\WebsitePanel.EnterpriseServer.Client\BackupProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\BackupProxy.cs

REM %WSDL% %SERVER_URL%/esBlackBerry.asmx /out:.\WebsitePanel.EnterpriseServer.Client\BlackBerryProxy.cs /namespace:WebsitePanel.EnterpriseServer.HostedSolution /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\BlackBerryProxy.cs

REM %WSDL% %SERVER_URL%/esComments.asmx /out:.\WebsitePanel.EnterpriseServer.Client\CommentsProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\CommentsProxy.cs

REM %WSDL% %SERVER_URL%/esCRM.asmx /out:.\WebsitePanel.EnterpriseServer.Client\CRMProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\CRMProxy.cs

REM %WSDL% %SERVER_URL%/esDatabaseServers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\DatabaseServersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\DatabaseServersProxy.cs

REM %WSDL% %SERVER_URL%/ecServiceHandler.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ecServiceHandlerProxy.cs /namespace:WebsitePanel.Ecommerce.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ecServiceHandlerProxy.cs

REM %WSDL% %SERVER_URL%/ecStorefront.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ecStorefrontProxy.cs /namespace:WebsitePanel.Ecommerce.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ecStorefrontProxy.cs

REM %WSDL% %SERVER_URL%/ecStorehouse.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ecStorehouseProxy.cs /namespace:WebsitePanel.Ecommerce.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ecStorehouseProxy.cs

REM %WSDL% %SERVER_URL%/esExchangeServer.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ExchangeServerProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ExchangeServerProxy.cs

REM %WSDL% %SERVER_URL%/esExchangeHostedEdition.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ExchangeHostedEditionProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ExchangeHostedEditionProxy.cs

REM %WSDL% %SERVER_URL%/esFiles.asmx /out:.\WebsitePanel.EnterpriseServer.Client\FilesProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\FilesProxy.cs

REM %WSDL% %SERVER_URL%/esHostedSharePointServers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\HostedSharePointServersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\HostedSharePointServersProxy.cs

REM %WSDL% %SERVER_URL%/esHostedSharePointServersEnt.asmx /out:.\WebsitePanel.EnterpriseServer.Client\HostedSharePointServersEntProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\HostedSharePointServersEntProxy.cs

REM %WSDL% %SERVER_URL%/esImport.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ImportProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ImportProxy.cs

REM %WSDL% %SERVER_URL%/esOCS.asmx /out:.\WebsitePanel.EnterpriseServer.Client\OCSProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\OCSProxy.cs

REM %WSDL% %SERVER_URL%/esOperatingSystems.asmx /out:.\WebsitePanel.EnterpriseServer.Client\OperatingSystemsProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\OperatingSystemsProxy.cs

REM %WSDL% %SERVER_URL%/esOrganizations.asmx /out:.\WebsitePanel.EnterpriseServer.Client\OrganizationProxy.cs /namespace:WebsitePanel.EnterpriseServer.HostedSolution /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\OrganizationProxy.cs

REM %WSDL% %SERVER_URL%/esPackages.asmx /out:.\WebsitePanel.EnterpriseServer.Client\PackagesProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\PackagesProxy.cs

REM %WSDL% %SERVER_URL%/esScheduler.asmx /out:.\WebsitePanel.EnterpriseServer.Client\SchedulerProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\SchedulerProxy.cs

REM %WSDL% %SERVER_URL%/esServers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\ServersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\ServersProxy.cs

REM %WSDL% %SERVER_URL%/esSharePointServers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\SharePointServersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\SharePointServersProxy.cs

REM %WSDL% %SERVER_URL%/esSystem.asmx /out:.\WebsitePanel.EnterpriseServer.Client\SystemProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\SystemProxy.cs

REM %WSDL% %SERVER_URL%/esTasks.asmx /out:.\WebsitePanel.EnterpriseServer.Client\TasksProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\TasksProxy.cs

REM %WSDL% %SERVER_URL%/esUsers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\UsersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\UsersProxy.cs

REM %WSDL% %SERVER_URL%/esVirtualizationServer.asmx /out:.\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxy.cs

REM %WSDL% %SERVER_URL%/esVirtualizationServer2012.asmx /out:.\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxy2012.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxy2012.cs

REM %WSDL% %SERVER_URL%/esWebApplicationGallery.asmx /out:.\WebsitePanel.EnterpriseServer.Client\WebApplicationGalleryProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\WebApplicationGalleryProxy.cs

REM %WSDL% %SERVER_URL%/esWebServers.asmx /out:.\WebsitePanel.EnterpriseServer.Client\WebServersProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\WebServersProxy.cs

REM %WSDL% %SERVER_URL%/esVirtualizationServerForPrivateCloud.asmx /out:.\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxyForPrivateCloud.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\VirtualizationServerProxyForPrivateCloud.cs

REM %WSDL% %SERVER_URL%/esLync.asmx /out:.\WebsitePanel.EnterpriseServer.Client\LyncProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\LyncProxy.cs

REM %WSDL% %SERVER_URL%/esHeliconZoo.asmx /out:.\WebsitePanel.EnterpriseServer.Client\HeliconZooProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\HeliconZooProxy.cs

REM %WSDL% %SERVER_URL%/esRemoteDesktopServices.asmx /out:.\WebsitePanel.EnterpriseServer.Client\RemoteDesktopServicesProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\RemoteDesktopServicesProxy.cs

REM %WSDL% %SERVER_URL%/esEnterpriseStorage.asmx /out:.\WebsitePanel.EnterpriseServer.Client\EnterpriseStorageProxy.cs /namespace:WebsitePanel.EnterpriseServer /type:webClient
REM %WSE_CLEAN% .\WebsitePanel.EnterpriseServer.Client\EnterpriseStorageProxy.cs




