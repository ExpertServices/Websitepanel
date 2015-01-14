
"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\EnterpriseServer -o Setup.WIXInstaller\EnterpriseServerFiles.wxs -gg  -sreg -var wix.BUILDESPATH -cg EnterpriseServerFiles

"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\Server -o Setup.WIXInstaller\ServerFiles.wxs -gg -sreg -var wix.BUILDSPATH -cg ServerFiles

"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\Portal -o Setup.WIXInstaller\PortalFiles.wxs -gg -sreg -var wix.BUILDPPATH -cg PortalFiles
