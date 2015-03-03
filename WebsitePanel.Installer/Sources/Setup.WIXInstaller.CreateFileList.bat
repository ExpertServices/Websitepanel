
"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\EnterpriseServer -o Setup.WIXInstaller\EnterpriseServerFiles.wxs -gg -sreg -srd -var wix.BUILDESPATH -cg EnterpriseServerFiles -dr INSTALLENTERPRISESERVERFOLDER

"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\Server -o Setup.WIXInstaller\ServerFiles.wxs -gg -sreg -srd -var wix.BUILDSPATH -cg ServerFiles -dr INSTALLSERVERFOLDER

"%WIX%\bin\heat.exe" dir ..\..\WebsitePanel\Build\Release\Portal -o Setup.WIXInstaller\PortalFiles.wxs -gg -sreg -srd -var wix.BUILDPPATH -cg PortalFiles -dr INSTALLPORTALFOLDER
