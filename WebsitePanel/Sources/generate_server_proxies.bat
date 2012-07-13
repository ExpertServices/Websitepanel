SET WSDL="C:\Program Files (x86)\Microsoft WSE\v3.0\Tools\WseWsdl3.exe"
SET WSE_CLEAN=..\Tools\WseClean.exe
SET SERVER_URL=http://localhost:9006

%WSDL% %SERVER_URL%/Organizations.asmx /out:.\WebsitePanel.Server.Client\OrganizationProxy.cs /namespace:WebsitePanel.Providers.HostedSolution /type:webClient /fields
%WSE_CLEAN% .\WebsitePanel.Server.Client\OrganizationProxy.cs

pause