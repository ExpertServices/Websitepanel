SET WSDL="C:\Program Files (x86)\Microsoft WSE\v3.0\Tools\WseWsdl3.exe"
SET WSE_CLEAN=..\Tools\WseClean.exe
SET SERVER_URL=http://localhost:9003

REM %WSDL% %SERVER_URL%/AutoDiscovery.asmx /out:.\WebsitePanel.Server.Client\AutoDiscoveryProxy.cs /namespace:WebsitePanel.AutoDiscovery /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\AutoDiscoveryProxy.cs

REM %WSDL% %SERVER_URL%/BlackBerry.asmx /out:.\WebsitePanel.Server.Client\BlackBerryProxy.cs /namespace:WebsitePanel.Providers.HostedSolution /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\BlackBerryProxy.cs

REM %WSDL% %SERVER_URL%/CRM.asmx /out:.\WebsitePanel.Server.Client\CRMProxy.cs /namespace:WebsitePanel.Providers.CRM /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\CRMProxy.cs

REM %WSDL% %SERVER_URL%/DatabaseServer.asmx /out:.\WebsitePanel.Server.Client\DatabaseServerProxy.cs /namespace:WebsitePanel.Providers.Database /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\DatabaseServerProxy.cs

REM %WSDL% %SERVER_URL%/DNSServer.asmx /out:.\WebsitePanel.Server.Client\DnsServerProxy.cs /namespace:WebsitePanel.Providers.DNS /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\DnsServerProxy.cs

REM %WSDL% %SERVER_URL%/ExchangeServer.asmx /out:.\WebsitePanel.Server.Client\ExchangeServerProxy.cs /namespace:WebsitePanel.Providers.Exchange /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\ExchangeServerProxy.cs

REM %WSDL% %SERVER_URL%/ExchangeServerHostedEdition.asmx /out:.\WebsitePanel.Server.Client\ExchangeServerHostedEditionProxy.cs /namespace:WebsitePanel.Providers.ExchangeHostedEdition /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\ExchangeServerHostedEditionProxy.cs

REM %WSDL% %SERVER_URL%/HostedSharePointServer.asmx /out:.\WebsitePanel.Server.Client\HostedSharePointServerProxy.cs /namespace:WebsitePanel.Providers.HostedSolution /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\HostedSharePointServerProxy.cs

%WSDL% %SERVER_URL%/HostedSharePointServerEnt.asmx /out:.\WebsitePanel.Server.Client\HostedSharePointServerEntProxy.cs /namespace:WebsitePanel.Providers.HostedSolution /type:webClient /fields
%WSE_CLEAN% .\WebsitePanel.Server.Client\HostedSharePointServerEntProxy.cs

REM %WSDL% %SERVER_URL%/OCSEdgeServer.asmx /out:.\WebsitePanel.Server.Client\OCSEdgeServerProxy.cs /namespace:WebsitePanel.Providers.OCS /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\OCSEdgeServerProxy.cs

REM %WSDL% %SERVER_URL%/OCSServer.asmx /out:.\WebsitePanel.Server.Client\OCSServerProxy.cs /namespace:WebsitePanel.Providers.OCS /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\OCSServerProxy.cs

REM %WSDL% %SERVER_URL%/OperatingSystem.asmx /out:.\WebsitePanel.Server.Client\OperatingSystemProxy.cs /namespace:WebsitePanel.Providers.OS /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\OperatingSystemProxy.cs

REM %WSDL% %SERVER_URL%/Organizations.asmx /out:.\WebsitePanel.Server.Client\OrganizationProxy.cs /namespace:WebsitePanel.Providers.HostedSolution /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\OrganizationProxy.cs

REM %WSDL% %SERVER_URL%/ServiceProvider.asmx /out:.\WebsitePanel.Server.Client\ServiceProviderProxy.cs /namespace:WebsitePanel.Providers /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\ServiceProviderProxy.cs

REM %WSDL% %SERVER_URL%/SharePointServer.asmx /out:.\WebsitePanel.Server.Client\SharePointServerProxy.cs /namespace:WebsitePanel.Providers.SharePoint /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\SharePointServerProxy.cs

REM %WSDL% %SERVER_URL%/VirtualizationServer.asmx /out:.\WebsitePanel.Server.Client\VirtualizationServerProxy.cs /namespace:WebsitePanel.Providers.Virtualization /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\VirtualizationServerProxy.cs

REM %WSDL% %SERVER_URL%/VirtualizationServerForPrivateCloud.asmx /out:.\WebsitePanel.Server.Client\VirtualizationServerForPrivateCloudProxy.cs /namespace:WebsitePanel.Providers.VirtualizationForPC /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\VirtualizationServerForPrivateCloudProxy.cs

REM %WSDL% %SERVER_URL%/WebServer.asmx /out:.\WebsitePanel.Server.Client\WebServerProxy.cs /namespace:WebsitePanel.Providers.Web /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\WebServerProxy.cs

REM %WSDL% %SERVER_URL%/WindowsServer.asmx /out:.\WebsitePanel.Server.Client\WindowsServerProxy.cs /namespace:WebsitePanel.Server /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\WindowsServerProxy.cs

REM %WSDL% %SERVER_URL%/LyncServer.asmx /out:.\WebsitePanel.Server.Client\LyncServerProxy.cs /namespace:WebsitePanel.Providers.Lync /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\LyncServerProxy.cs

REM %WSDL% %SERVER_URL%/HeliconZoo.asmx /out:.\WebsitePanel.Server.Client\HeliconZooProxy.cs /namespace:WebsitePanel.Providers.HeliconZoo /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\HeliconZooProxy.cs

REM %WSDL% %SERVER_URL%/RemoteDesktopServices.asmx /out:.\WebsitePanel.Server.Client\RemoteDesktopServicesProxy.cs /namespace:WebsitePanel.Providers.RemoteDesktopServices /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\RemoteDesktopServicesProxy.cs

REM %WSDL% %SERVER_URL%/EnterpriseStorage.asmx /out:.\WebsitePanel.Server.Client\EnterpriseStorageProxy.cs /namespace:WebsitePanel.Providers.EnterpriseStorage /type:webClient /fields
REM %WSE_CLEAN% .\WebsitePanel.Server.Client\EnterpriseStorageProxy.cs
