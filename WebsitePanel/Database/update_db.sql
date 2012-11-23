USE [${install.database}]
GO

-- update database version
DECLARE @build_version nvarchar(10), @build_date datetime
SET @build_version = N'${release.version}'
SET @build_date = '${release.date}T00:00:00' -- ISO 8601 Format (YYYY-MM-DDTHH:MM:SS)

IF NOT EXISTS (SELECT * FROM [dbo].[Versions] WHERE [DatabaseVersion] = @build_version)
BEGIN
	INSERT [dbo].[Versions] ([DatabaseVersion], [BuildDate]) VALUES (@build_version, @build_date)
END
GO

-- Windows Server 2012

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Windows Server 2012')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (104, 1, N'Windows2012', N'Windows Server 2012', N'WebsitePanel.Providers.OS.Windows2012, WebsitePanel.Providers.OS.Windows2012', N'Windows2008', NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 104 AND [PropertyName] = N'UsersHome')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (104, N'UsersHome', N'%SYSTEMDRIVE%\HostingSpaces')
END
GO

-- IIS 8.0
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Internet Information Services 8.0')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (105, 2, N'IIS80', N'Internet Information Services 8.0', N'WebsitePanel.Providers.Web.IIs80, WebsitePanel.Providers.Web.IIs80', N'IIS70', NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'AspNet11Pool')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'AspNet11Pool', N'ASP.NET 1.1')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'AspNet40Path')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'AspNet40Path', N'%WINDIR%\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'AspNet40x64Path')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'AspNet40x64Path', N'%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\aspnet_isapi.dll')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'AspNetBitnessMode')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'AspNetBitnessMode', N'32')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'CFFlashRemotingDirectory')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'CFFlashRemotingDirectory', N'C:\ColdFusion9\runtime\lib\wsconfig\1')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'CFScriptsDirectory')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'CFScriptsDirectory', N'C:\Inetpub\wwwroot\CFIDE')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'ClassicAspNet20Pool')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'ClassicAspNet20Pool', N'ASP.NET 2.0 (Classic)')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'ClassicAspNet40Pool')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'ClassicAspNet40Pool', N'ASP.NET 4.0 (Classic)')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'ColdFusionPath')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'ColdFusionPath', N'C:\ColdFusion9\runtime\lib\wsconfig\jrun_iis6.dll')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'GalleryXmlFeedUrl')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'GalleryXmlFeedUrl', N'')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'IntegratedAspNet20Pool')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'IntegratedAspNet20Pool', N'ASP.NET 2.0 (Integrated)')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'IntegratedAspNet40Pool')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'IntegratedAspNet40Pool', N'ASP.NET 4.0 (Integrated)')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'PerlPath')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'PerlPath', N'%SYSTEMDRIVE%\Perl\bin\PerlEx30.dll')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'Php4Path')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'Php4Path', N'%PROGRAMFILES%\PHP\php.exe')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'PhpMode')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'PhpMode', N'FastCGI')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'PhpPath')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'PhpPath', N'%PROGRAMFILES%\PHP\php-cgi.exe')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'ProtectedGroupsFile')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'ProtectedGroupsFile', N'.htgroup')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'ProtectedUsersFile')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'ProtectedUsersFile', N'.htpasswd')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'SecureFoldersModuleAssembly')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'SecureFoldersModuleAssembly', N'WebsitePanel.IIsModules.SecureFolders, WebsitePanel.IIsModules, Version=1.0.0.0, Culture=Neutral, PublicKeyToken=37f9c58a0aa32ff0')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'WebGroupName')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'WebGroupName', N'WSP_IUSRS')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'WmSvc.CredentialsMode')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'WmSvc.CredentialsMode', N'WINDOWS')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 105 AND [PropertyName] = N'WmSvc.Port')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (105, N'WmSvc.Port', N'8172')
END
GO

-- MS FTP 8.0
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Microsoft FTP Server 8.0')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (106, 3, N'MSFTP80', N'Microsoft FTP Server 8.0', N'WebsitePanel.Providers.FTP.MsFTP80, WebsitePanel.Providers.FTP.IIs80', N'MSFTP70', NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 106 AND [PropertyName] = N'FtpGroupName')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (106, N'FtpGroupName', N'WSPFtpUsers')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 106 AND [PropertyName] = N'SiteId')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (106, N'SiteId', N'Default FTP Site')
END
GO

-- end of MS FTP 8.0, IIS 8.0 and Windows 2012

-- new user settings
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE ([UserID] = 1) AND  ([SettingsName] = 'WebPolicy') AND ([PropertyName] = 'EnableParkingPageTokens'))
BEGIN
	INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'WebPolicy', N'EnableParkingPageTokens', N'False')
END

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'MsSQL2012')
BEGIN
	INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController]) VALUES (23, N'MsSQL2012', 10, N'WebsitePanel.EnterpriseServer.DatabaseServerController')
END
GO

UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 1 WHERE [GroupName] = N'OS'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 2 WHERE [GroupName] = N'Web'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 3 WHERE [GroupName] = N'FTP'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 4 WHERE [GroupName] = N'Mail'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 5 WHERE [GroupName] = N'Exchange'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 6 WHERE [GroupName] = N'Hosted Organizations'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 7 WHERE [GroupName] = N'MsSQL2000'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 8 WHERE [GroupName] = N'MsSQL2005'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 9 WHERE [GroupName] = N'MsSQL2008'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 10 WHERE [GroupName] = N'MsSQL2012'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 11 WHERE [GroupName] = N'MySQL4'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 12 WHERE [GroupName] = N'MySQL5'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 13 WHERE [GroupName] = N'SharePoint'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 14 WHERE [GroupName] = N'Hosted SharePoint'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 15 WHERE [GroupName] = N'Hosted CRM'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 16 WHERE [GroupName] = N'DNS'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 17 WHERE [GroupName] = N'Statistics'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 18 WHERE [GroupName] = N'VPS'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 19 WHERE [GroupName] = N'VPSForPC'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 20 WHERE [GroupName] = N'BlackBerry'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 21 WHERE [GroupName] = N'OCS'
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'Lync')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController]) VALUES (41, N'Lync',22, NULL)
END
GO



IF NOT EXISTS (SELECT * FROM [dbo].[ServiceItemTypes] WHERE [DisplayName] = 'MsSQL2012Database')
BEGIN
	INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (37, 23, N'MsSQL2012Database', N'WebsitePanel.Providers.Database.SqlDatabase, WebsitePanel.Providers.Base', 1, 1, 0, 0, 1, 1, 1, 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceItemTypes] WHERE [DisplayName] = 'MsSQL2012User')
BEGIN
	INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (38, 23, N'MsSQL2012User', N'WebsitePanel.Providers.Database.SqlUser, WebsitePanel.Providers.Base', 1, 0, 0, 0, 1, 1, 1, 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Microsoft SQL Server 2012')
BEGIN
	-- provider
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (209, 23, N'MsSQL', N'Microsoft SQL Server 2012', N'WebsitePanel.Providers.Database.MsSqlServer2012, WebsitePanel.Providers.Database.SqlServer', N'MSSQL', NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.Databases')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (218, 23, 1, N'MsSQL2012.Databases', N'Databases', 2, 0, 37)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.Users')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (219, 23, 2, N'MsSQL2012.Users', N'Users', 2, 0, 38)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.MaxDatabaseSize')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (221, 23, 3, N'MsSQL2012.MaxDatabaseSize', N'Max Database Size', 3, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.Backup')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (222, 23, 5, N'MsSQL2012.Backup', N'Database Backups', 1, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.Restore')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (223, 23, 6, N'MsSQL2012.Restore', N'Database Restores', 1, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.Truncate')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (224, 23, 7, N'MsSQL2012.Truncate', N'Database Truncate', 1, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'MsSQL2012.MaxLogSize')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (225, 23, 4, N'MsSQL2012.MaxLogSize', N'Max Log Size', 3, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSharePoint.UseSharedSSL')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (400, 20, 3, N'HostedSharePoint.UseSharedSSL', N'Use shared SSL Root', 1, 0, NULL)
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.KeepDeletedItemsDays')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (364, 12, 19, N'Exchange2007.KeepDeletedItemsDays',	N'Keep Deleted Items (days)', 3, 0,	NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaTypeID] = 3 WHERE [QuotaID] = 364
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.MaxRecipients')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (365, 12, 20, N'Exchange2007.MaxRecipients', N'Maximum Recipients',	3,	0,	NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaTypeID] = 3 WHERE [QuotaID] = 365
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.MaxSendMessageSizeKB')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (366, 12, 21, N'Exchange2007.MaxSendMessageSizeKB',	N'Maximum Send Message Size (Kb)', 3, 0, NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaTypeID] = 3 WHERE [QuotaID] = 366
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.MaxReceiveMessageSizeKB')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (367, 12, 22, N'Exchange2007.MaxReceiveMessageSizeKB', N'Maximum Receive Message Size (Kb)', 3,	0, NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaTypeID] = 3 WHERE [QuotaID] = 367
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.IsConsumer')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (368, 12, 1, N'Exchange2007.IsConsumer',N'Is Consumer Organization', 1, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.EnablePlansEditing')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (369, 12, 23,N'Exchange2007.EnablePlansEditing',N'Enable Plans Editing',1, 0 , NULL)
END
GO



IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.Users')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (370, 41, 1, N'Lync.Users', N'Users',2 ,0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.Federation')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (371,	41,	2,	N'Lync.Federation'	, N'Allow Federation',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.Conferencing')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (372,	41,	3,	N'Lync.Conferencing', N'Allow Conferencing',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.MaxParticipants')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (373,	41,	4,	N'Lync.MaxParticipants', N'Maximum Conference Particiapants',	3,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.AllowVideo')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (374,	41,	5,	N'Lync.AllowVideo', N'Allow Video in Conference',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EnterpriseVoice')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (375,	41,	6,	N'Lync.EnterpriseVoice', N'Allow EnterpriseVoice',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EVUsers')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (376,	41,	7,	N'Lync.EVUsers', N'Number of Enterprise Voice Users',	2,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EVNational')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (377,	41,	8,	N'Lync.EVNational', N'Allow National Calls',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EVMobile')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (378,	41,	9,	N'Lync.EVMobile', N'Allow Mobile Calls',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EVInternational')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (379,	41,	10,	N'Lync.EVInternational', N'Allow International Calls',	1,	0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSharePoint.UseSharedSSL')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (400, 20, 3, N'HostedSharePoint.UseSharedSSL', N'Use shared SSL Root', 1, 0, NULL)
END
GO



IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Lync.EnablePlansEditing')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (380, 41, 11, N'Lync.EnablePlansEditing', N'Enable Plans Editing', 1, 0, NULL)
END
GO



IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted Microsoft Exchange Server 2010 SP2')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES(90, 12, N'Exchange2010SP2', N'Hosted Microsoft Exchange Server 2010 SP2', N'WebsitePanel.Providers.HostedSolution.Exchange2010SP2, WebsitePanel.Providers.HostedSolution', N'Exchange',	1)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL WHERE [DisplayName] = 'Hosted Microsoft Exchange Server 2010 SP2'
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Microsoft Lync Server 2010 Multitenant Hosting Pack')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (250, 41, N'Lync2010', N'Microsoft Lync Server 2010 Multitenant Hosting Pack', 'WebsitePanel.Providers.HostedSolution.Lync2010, WebsitePanel.Providers.HostedSolution', 'Lync', NULL)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL WHERE [DisplayName] = 'Microsoft Lync Server 2010 Multitenant Hosting Pack'
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'OS.AllowTenantCreateDomains')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (410, 1, 12, N'OS.AllowTenantCreateDomains', N'Allow Tenants to Create Top Level Domains', 1, 0, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Web.AllowIPAddressModeSwitch')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (333, 2, 22, N'Web.AllowIPAddressModeSwitch', N'Allow IP Address Mode Switch', 1, 0, NULL)
END
GO



DELETE FROM [dbo].[PackageQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.POP3Enabled')
DELETE FROM [dbo].[HostingPlanQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.POP3Enabled')
DELETE FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.POP3Enabled'

DELETE FROM [dbo].[PackageQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.IMAPEnabled')
DELETE FROM [dbo].[HostingPlanQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.IMAPEnabled')
DELETE FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.IMAPEnabled'

DELETE FROM [dbo].[PackageQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.OWAEnabled')
DELETE FROM [dbo].[HostingPlanQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.OWAEnabled')
DELETE FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.OWAEnabled'

DELETE FROM [dbo].[PackageQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.MAPIEnabled')
DELETE FROM [dbo].[HostingPlanQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.MAPIEnabled')
DELETE FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.MAPIEnabled'

DELETE FROM [dbo].[PackageQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.ActiveSyncEnabled')
DELETE FROM [dbo].[HostingPlanQuotas] WHERE [QuotaID] IN (SELECT [QuotaID] FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.ActiveSyncEnabled')
DELETE FROM [dbo].[Quotas] WHERE [QuotaName] = N'Exchange2007.ActiveSyncEnabled'

UPDATE [dbo].[ScheduleTaskParameters] SET DefaultValue = N'MsSQL2000=SQL Server 2000;MsSQL2005=SQL Server 2005;MsSQL2008=SQL Server 2008;MsSQL2012=SQL Server 2012;MySQL4=MySQL 4.0;MySQL5=MySQL 5.0' WHERE [ParameterID] = N'DATABASE_GROUP'
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Microsoft SQL Server 2012')
BEGIN
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (209, 23, N'MsSQL', N'Microsoft SQL Server 2012', N'WebsitePanel.Providers.Database.MsSqlServer2012, WebsitePanel.Providers.Database.SqlServer', N'MSSQL', NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 12 AND [PropertyName] = 'LogsFolder')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (12, N'LogsFolder', N'%PROGRAMFILES%\Gene6 FTP Server\Log')
END
GO
UPDATE [dbo].[Providers] SET [EditorControl] = N'hMailServer5' WHERE [ProviderID] = 63
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 63 AND [PropertyName] = N'AdminUsername')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (63, N'AdminUsername', N'Administrator')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceDefaultProperties] WHERE [ProviderID] = 63 AND [PropertyName] = N'AdminPassword')
BEGIN
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (63, N'AdminPassword', N'')
END
GO


IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Users' AND COLS.name='LoginStatusId')
BEGIN
ALTER TABLE [dbo].[Users] ADD
	[LoginStatusId] [int] NULL,
	[FailedLogins] [int] NULL
END
GO


IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='GlobalDnsRecords' AND COLS.name='SrvPriority')
BEGIN
ALTER TABLE [dbo].[GlobalDnsRecords] ADD
	[SrvPriority] [int] NULL,
	[SrvWeight] [int] NULL,
	[SrvPort] [int] NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ResourceGroups' AND COLS.name='ShowGroup')
BEGIN
ALTER TABLE [dbo].[ResourceGroups] ADD [ShowGroup] [bit] NULL
END
GO


UPDATE [dbo].[ResourceGroups] SET ShowGroup=1 
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Quotas' AND COLS.name='HideQuota')
BEGIN
ALTER TABLE [dbo].[Quotas] ADD [HideQuota] [bit] NULL
END
GO

UPDATE [dbo].[Quotas] SET [HideQuota] = 1 WHERE [QuotaName] = N'OS.DomainPointers'
GO


/****** Object:  Table [dbo].[ExchangeAccounts]    Extend Exchange Accounts with UserPrincipalName ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='UserPrincipalName')
BEGIN
ALTER TABLE [dbo].[ExchangeAccounts] ADD
	[UserPrincipalName] [nvarchar] (300) COLLATE Latin1_General_CI_AS NULL
END
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[ExchangeAccounts] WHERE UserPrincipalName IS NOT NULL)
BEGIN
	UPDATE [dbo].[ExchangeAccounts] SET [UserPrincipalName] = PrimaryEmailAddress WHERE AccountType IN (1,7)
END
GO


/****** Object:  Table [dbo].[ExchangeAccounts]    Extend Exchange Accounts with SubscriberNumber ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Users' AND COLS.name='SubscriberNumber')
BEGIN
ALTER TABLE [dbo].[Users] ADD [SubscriberNumber] [nvarchar] (32) COLLATE Latin1_General_CI_AS NULL
END
GO




ALTER PROCEDURE [dbo].[AddDnsRecord]
(
	@ActorID int,
	@ServiceID int,
	@ServerID int,
	@PackageID int,
	@RecordType nvarchar(10),
	@RecordName nvarchar(50),
	@RecordData nvarchar(500),
	@MXPriority int,
	@SrvPriority int,
	@SrvWeight int, 
	@SrvPort int,
	@IPAddressID int
)
AS

IF (@ServiceID > 0 OR @ServerID > 0) AND dbo.CheckIsUserAdmin(@ActorID) = 0
RAISERROR('You should have administrator role to perform such operation', 16, 1)

IF (@PackageID > 0) AND dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

IF @ServiceID = 0 SET @ServiceID = NULL
IF @ServerID = 0 SET @ServerID = NULL
IF @PackageID = 0 SET @PackageID = NULL
IF @IPAddressID = 0 SET @IPAddressID = NULL

IF EXISTS
(
	SELECT RecordID FROM GlobalDnsRecords WHERE
	ServiceID = @ServiceID AND ServerID = @ServerID AND PackageID = @PackageID
	AND RecordName = @RecordName AND RecordType = @RecordType
)
	
	UPDATE GlobalDnsRecords
	SET
		RecordData = RecordData,
		MXPriority = MXPriority,
		SrvPriority = SrvPriority,
		SrvWeight = SrvWeight,
		SrvPort = SrvPort,
	
		IPAddressID = @IPAddressID
	WHERE
		ServiceID = @ServiceID AND ServerID = @ServerID AND PackageID = @PackageID
ELSE
	INSERT INTO GlobalDnsRecords
	(
		ServiceID,
		ServerID,
		PackageID,
		RecordType,
		RecordName,
		RecordData,
		MXPriority,
		SrvPriority,
		SrvWeight,
		SrvPort,
		IPAddressID
	)
	VALUES
	(
		@ServiceID,
		@ServerID,
		@PackageID,
		@RecordType,
		@RecordName,
		@RecordData,
		@MXPriority,
		@SrvPriority,
		@SrvWeight,
		@SrvPort,
		@IPAddressID
	)

RETURN

GO








ALTER PROCEDURE [dbo].[CheckDomain]
(
	@PackageID int,
	@DomainName nvarchar(100),
	@IsDomainPointer bit,
	@Result int OUTPUT
)
AS

/*
@Result values:
	0 - OK
	-1 - already exists
	-2 - sub-domain of prohibited domain
*/

SET @Result = 0 -- OK

-- check if the domain already exists
IF EXISTS(
SELECT DomainID FROM Domains
WHERE DomainName = @DomainName AND IsDomainPointer = @IsDomainPointer
)
BEGIN
	SET @Result = -1
	RETURN
END

-- check if this is a sub-domain of other domain
-- that is not allowed for 3rd level hosting

DECLARE @UserID int
SELECT @UserID = UserID FROM Packages
WHERE PackageID = @PackageID

-- find sub-domains
DECLARE @DomainUserID int, @HostingAllowed bit
SELECT
	@DomainUserID = P.UserID,
	@HostingAllowed = D.HostingAllowed
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
WHERE CHARINDEX('.' + DomainName, @DomainName) > 0
AND (CHARINDEX('.' + DomainName, @DomainName) + LEN('.' + DomainName)) = LEN(@DomainName) + 1
AND IsDomainPointer = 0

-- this is a domain of other user
IF @UserID <> @DomainUserID AND @HostingAllowed = 0
BEGIN
	SET @Result = -2
	RETURN
END

RETURN

GO








ALTER PROCEDURE [dbo].[GetDnsRecord]
(
	@ActorID int,
	@RecordID int
)
AS

-- check rights
DECLARE @ServiceID int, @ServerID int, @PackageID int
SELECT
	@ServiceID = ServiceID,
	@ServerID = ServerID,
	@PackageID = PackageID
FROM GlobalDnsRecords
WHERE
	RecordID = @RecordID

IF (@ServiceID > 0 OR @ServerID > 0) AND dbo.CheckIsUserAdmin(@ActorID) = 0
RAISERROR('You are not allowed to perform this operation', 16, 1)

IF (@PackageID > 0) AND dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	NR.RecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,	
	NR.IPAddressID
FROM
	GlobalDnsRecords AS NR
WHERE NR.RecordID = @RecordID
RETURN

GO








ALTER PROCEDURE [dbo].[GetDnsRecordsByPackage]
(
	@ActorID int,
	@PackageID int
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	NR.RecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,	
	NR.IPAddressID,
	CASE
		WHEN NR.RecordType = 'A' AND NR.RecordData = '' THEN dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP)
		WHEN NR.RecordType = 'MX' THEN CONVERT(varchar(3), NR.MXPriority) + ', ' + NR.RecordData
		WHEN NR.RecordType = 'SRV' THEN CONVERT(varchar(3), NR.SrvPort) + ', ' + NR.RecordData
		ELSE NR.RecordData
	END AS FullRecordData,
	dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP) AS IPAddress,
	IP.ExternalIP,
	IP.InternalIP
FROM
	GlobalDnsRecords AS NR
LEFT OUTER JOIN IPAddresses AS IP ON NR.IPAddressID = IP.AddressID
WHERE NR.PackageID = @PackageID
RETURN

GO










ALTER PROCEDURE [dbo].[GetDnsRecordsByServer]
(
	@ActorID int,
	@ServerID int
)
AS

SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	NR.RecordData,
	CASE
		WHEN NR.RecordType = 'A' AND NR.RecordData = '' THEN dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP)
		WHEN NR.RecordType = 'MX' THEN CONVERT(varchar(3), NR.MXPriority) + ', ' + NR.RecordData
		WHEN NR.RecordType = 'SRV' THEN CONVERT(varchar(3), NR.SrvPort) + ', ' + NR.RecordData
		ELSE NR.RecordData
	END AS FullRecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,		
	NR.IPAddressID,
	dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP) AS IPAddress,
	IP.ExternalIP,
	IP.InternalIP
FROM
	GlobalDnsRecords AS NR
LEFT OUTER JOIN IPAddresses AS IP ON NR.IPAddressID = IP.AddressID
WHERE
	NR.ServerID = @ServerID
RETURN

GO









ALTER PROCEDURE [dbo].[GetDnsRecordsByService]
(
	@ActorID int,
	@ServiceID int
)
AS

SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	CASE
		WHEN NR.RecordType = 'A' AND NR.RecordData = '' THEN dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP)
		WHEN NR.RecordType = 'MX' THEN CONVERT(varchar(3), NR.MXPriority) + ', ' + NR.RecordData
		WHEN NR.RecordType = 'SRV' THEN CONVERT(varchar(3), NR.SrvPort) + ', ' + NR.RecordData
		ELSE NR.RecordData
	END AS FullRecordData,
	NR.RecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,			
	NR.IPAddressID,
	dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP) AS IPAddress,
	IP.ExternalIP,
	IP.InternalIP
FROM
	GlobalDnsRecords AS NR
LEFT OUTER JOIN IPAddresses AS IP ON NR.IPAddressID = IP.AddressID
WHERE
	NR.ServiceID = @ServiceID
RETURN

GO









ALTER PROCEDURE [dbo].[GetDnsRecordsTotal]
(
	@ActorID int,
	@PackageID int
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- create temp table for DNS records
DECLARE @Records TABLE
(
	RecordID int,
	RecordType nvarchar(10) COLLATE Latin1_General_CI_AS,
	RecordName nvarchar(50) COLLATE Latin1_General_CI_AS
)

-- select PACKAGES DNS records
DECLARE @ParentPackageID int, @TmpPackageID int
SET @TmpPackageID = @PackageID

WHILE 10 = 10
BEGIN

	-- get DNS records for the current package
	INSERT INTO @Records (RecordID, RecordType, RecordName)
	SELECT
		GR.RecordID,
		GR.RecordType,
		GR.RecordName
	FROM GlobalDNSRecords AS GR
	WHERE GR.PackageID = @TmpPackageID
	AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)

	SET @ParentPackageID = NULL

	-- get parent package
	SELECT
		@ParentPackageID = ParentPackageID
	FROM Packages
	WHERE PackageID = @TmpPackageID
	
	IF @ParentPackageID IS NULL -- the last parent
	BREAK
	
	SET @TmpPackageID = @ParentPackageID
END

-- select SERVER DNS records
DECLARE @ServerID int
SELECT @ServerID = ServerID FROM Packages
WHERE PackageID = @PackageID

INSERT INTO @Records (RecordID, RecordType, RecordName)
SELECT
	GR.RecordID,
	GR.RecordType,
	GR.RecordName
FROM GlobalDNSRecords AS GR
WHERE GR.ServerID = @ServerID
AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)


-- select SERVICES DNS records
-- re-distribute package services
EXEC DistributePackageServices @ActorID, @PackageID

INSERT INTO @Records (RecordID, RecordType, RecordName)
SELECT
	GR.RecordID,
	GR.RecordType,
	GR.RecordName
FROM GlobalDNSRecords AS GR
WHERE GR.ServiceID IN (SELECT ServiceID FROM PackageServices WHERE PackageID = @PackageID)
AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)


SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	NR.RecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,	
	NR.IPAddressID,
	ISNULL(IP.ExternalIP, '') AS ExternalIP,
	ISNULL(IP.InternalIP, '') AS InternalIP,
	CASE
		WHEN NR.RecordType = 'A' AND NR.RecordData = '' THEN dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP)
		WHEN NR.RecordType = 'MX' THEN CONVERT(varchar(3), NR.MXPriority) + ', ' + NR.RecordData
		WHEN NR.RecordType = 'SRV' THEN CONVERT(varchar(3), NR.SrvPort) + ', ' + NR.RecordData
		ELSE NR.RecordData
	END AS FullRecordData,
	dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP) AS IPAddress
FROM @Records AS TR
INNER JOIN GlobalDnsRecords AS NR ON TR.RecordID = NR.RecordID
LEFT OUTER JOIN IPAddresses AS IP ON NR.IPAddressID = IP.AddressID

RETURN

GO









ALTER PROCEDURE [dbo].[GetDomainsPaged]
(
	@ActorID int,
	@PackageID int,
	@ServerID int,
	@Recursive bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
SET NOCOUNT ON

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

IF @SortColumn = '' OR @SortColumn IS NULL
SET @SortColumn = 'DomainName'

SET @sql = '
DECLARE @Domains TABLE
(
	ItemPosition int IDENTITY(1,1),
	DomainID int
)
INSERT INTO @Domains (DomainID)
SELECT
	D.DomainID
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE D.IsInstantAlias = 0 AND
		((@Recursive = 0 AND D.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, D.PackageID) = 1))
AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
'

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(DomainID) FROM @Domains;SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(WS.ItemID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(MD.ItemID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer,
	
	-- packages
	P.PackageName,
	
	-- server
	ISNULL(SRV.ServerID, 0) AS ServerID,
	ISNULL(SRV.ServerName, '''') AS ServerName,
	ISNULL(SRV.Comments, '''') AS ServerComments,
	ISNULL(SRV.VirtualServer, 0) AS VirtualServer,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Domains AS SD
INNER JOIN Domains AS D ON SD.DomainID = D.DomainID
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE SD.ItemPosition BETWEEN @StartRow + 1 AND @StartRow + @MaximumRows'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @PackageID int, @FilterValue nvarchar(50), @ServerID int, @Recursive bit',
@StartRow, @MaximumRows, @PackageID, @FilterValue, @ServerID, @Recursive


RETURN

GO










ALTER PROCEDURE [dbo].[UpdateDnsRecord]
(
	@ActorID int,
	@RecordID int,
	@RecordType nvarchar(10),
	@RecordName nvarchar(50),
	@RecordData nvarchar(500),
	@MXPriority int,
	@SrvPriority int,
	@SrvWeight int, 
	@SrvPort int,	
	@IPAddressID int
)
AS

IF @IPAddressID = 0 SET @IPAddressID = NULL

-- check rights
DECLARE @ServiceID int, @ServerID int, @PackageID int
SELECT
	@ServiceID = ServiceID,
	@ServerID = ServerID,
	@PackageID = PackageID
FROM GlobalDnsRecords
WHERE
	RecordID = @RecordID

IF (@ServiceID > 0 OR @ServerID > 0) AND dbo.CheckIsUserAdmin(@ActorID) = 0
RAISERROR('You are not allowed to perform this operation', 16, 1)

IF (@PackageID > 0) AND dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)


-- update record
UPDATE GlobalDnsRecords
SET
	RecordType = @RecordType,
	RecordName = @RecordName,
	RecordData = @RecordData,
	MXPriority = @MXPriority,
	SrvPriority = @SrvPriority,
	SrvWeight = @SrvWeight,
	SrvPort = @SrvPort,
	IPAddressID = @IPAddressID
WHERE
	RecordID = @RecordID
RETURN

GO




UPDATE dbo.Quotas SET QuotaTypeID = 2 WHERE QuotaName = 'HostedSharePoint.Sites'
GO
UPDATE dbo.Quotas SET QuotaTypeID = 2 WHERE QuotaName = 'HostedSolution.Users'
GO
UPDATE dbo.Quotas SET QuotaTypeID = 2 WHERE QuotaName = 'Exchange2007.Mailboxes'
GO
UPDATE dbo.Quotas SET QuotaTypeID = 2 WHERE QuotaName = 'Exchange2007.DiskSpace'
GO






-- Remove ExchangeHostedEdition Quotas
DELETE FROM Quotas WHERE QuotaID = 340
GO
DELETE FROM Quotas WHERE QuotaID = 341
GO
DELETE FROM Quotas WHERE QuotaID = 342
GO
DELETE FROM Quotas WHERE QuotaID = 343
GO


-- Remove ExchangeHostedEdition ServiceItemType
DELETE FROM ServiceItemTypes WHERE ItemTypeID = 40
GO


-- Remove ExchangeHostedEdition ServiceDefaultProperties
DELETE FROM ServiceDefaultProperties WHERE ProviderID = 207
GO



-- Remove ExchangeHostedEdition Provider
DELETE FROM Providers WHERE ProviderID = 207
GO



-- Remove ExchangeHostedEdition VirtualGroups
DELETE FROM VirtualGroups WHERE GroupID = 33
GO



-- Remove ExchangeHostedEdition ResourceGroups
DELETE FROM ResourceGroups WHERE GRoupID = 33
GO


-- Create Exchange Mailbox Plans
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeMailboxPlans]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExchangeMailboxPlans](
	[MailboxPlanId] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[MailboxPlan] [nvarchar](300) COLLATE Latin1_General_CI_AS NOT NULL,
	[MailboxPlanType] [int] NULL,
	[EnableActiveSync] [bit] NOT NULL,
	[EnableIMAP] [bit] NOT NULL,
	[EnableMAPI] [bit] NOT NULL,
	[EnableOWA] [bit] NOT NULL,
	[EnablePOP] [bit] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IssueWarningPct] [int] NOT NULL,
	[KeepDeletedItemsDays] [int] NOT NULL,
	[MailboxSizeMB] [int] NOT NULL,
	[MaxReceiveMessageSizeKB] [int] NOT NULL,
	[MaxRecipients] [int] NOT NULL,
	[MaxSendMessageSizeKB] [int] NOT NULL,
	[ProhibitSendPct] [int] NOT NULL,
	[ProhibitSendReceivePct] [int] NOT NULL,
	[HideFromAddressBook] [bit] NOT NULL,
 CONSTRAINT [PK_ExchangeMailboxPlans] PRIMARY KEY CLUSTERED 
(
	[MailboxPlanId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[ExchangeAccounts]    ******/
ALTER TABLE [dbo].[ExchangeAccounts] ALTER COLUMN	[AccountName] [nvarchar](300) COLLATE Latin1_General_CI_AS NOT NULL

/****** Object:  Table [dbo].[ExchangeAccounts]    ******/
ALTER TABLE [dbo].[ExchangeAccounts] ADD	[MailboxPlanId] int NULL

/****** Object:  Table [dbo].[ExchangeAccounts]    ******/
ALTER TABLE [dbo].[ExchangeAccounts]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeAccounts_ExchangeMailboxPlans] FOREIGN KEY([MailboxPlanId])
REFERENCES [dbo].[ExchangeMailboxPlans] ([MailboxPlanId])

ALTER TABLE [dbo].[ExchangeAccounts] CHECK CONSTRAINT [FK_ExchangeAccounts_ExchangeMailboxPlans]

/****** Object:  Table [dbo].[ExchangeAccounts]    ******/
ALTER TABLE [dbo].[ExchangeMailboxPlans]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeMailboxPlans_ExchangeOrganizations] FOREIGN KEY([ItemID])
REFERENCES [dbo].[ExchangeOrganizations] ([ItemID])
ON DELETE CASCADE

/****** Object:  Table [dbo].[ExchangeAccounts]    ******/
ALTER TABLE dbo.ExchangeMailboxPlans ADD CONSTRAINT
	IX_ExchangeMailboxPlans UNIQUE NONCLUSTERED 
	(
	MailboxPlanId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

END
GO

/****** Object:  Table [dbo].[ExchangeAccounts]    Extend Exchange Accounts with MailboxplanID ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='MailboxPlanId')
BEGIN
ALTER TABLE [dbo].[ExchangeAccounts] ADD [MailboxPlanId] [int] NULL
END
GO

/****** Object:  Table [dbo].[ExchangeAccounts]    Extend Exchange Accounts with SubscriberNumber ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='SubscriberNumber')
BEGIN
ALTER TABLE [dbo].[ExchangeAccounts] ADD [SubscriberNumber] [nvarchar] (32) COLLATE Latin1_General_CI_AS NULL
END
GO


ALTER VIEW [dbo].[UsersDetailed]
AS
SELECT     U.UserID, U.RoleID, U.StatusID, U.LoginStatusId, U.SubscriberNumber, U.FailedLogins, U.OwnerID, U.Created, U.Changed, U.IsDemo, U.Comments, U.IsPeer, U.Username, U.FirstName, U.LastName, U.Email, 
                      U.CompanyName, U.FirstName + ' ' + U.LastName AS FullName, UP.Username AS OwnerUsername, UP.FirstName AS OwnerFirstName, 
                      UP.LastName AS OwnerLastName, UP.RoleID AS OwnerRoleID, UP.FirstName + ' ' + UP.LastName AS OwnerFullName, UP.Email AS OwnerEmail, UP.RoleID AS Expr1,
                          (SELECT     COUNT(PackageID) AS Expr1
                            FROM          dbo.Packages AS P
                            WHERE      (UserID = U.UserID)) AS PackagesNumber, U.EcommerceEnabled
FROM         dbo.Users AS U LEFT OUTER JOIN
                      dbo.Users AS UP ON U.OwnerID = UP.UserID
GO


/****** Object:  Table [dbo].[ExchangeOrganizations]    ******/
ALTER TABLE [dbo].[ExchangeOrganizations] ALTER COLUMN	[OrganizationID] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='MailboxPlanType')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
	[MailboxPlanType] [int] NULL
END
GO

-- LyncUsers
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LyncUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LyncUsers](
	[LyncUserID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[LyncUserPlanID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LyncUsers] PRIMARY KEY CLUSTERED 
(
	[LyncUserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[LyncUsers] ADD  CONSTRAINT [DF_LyncUsers_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]

ALTER TABLE [dbo].[LyncUsers] ADD  CONSTRAINT [DF_LyncUsers_ChangedDate]  DEFAULT (getdate()) FOR [ModifiedDate]

END
GO




-- LyncUserPlans
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LyncUserPlans]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LyncUserPlans](
	[LyncUserPlanId] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[LyncUserPlanName] [nvarchar](300) NOT NULL,
	[LyncUserPlanType] [int] NULL,
	[IM] [bit] NOT NULL,
	[Mobility] [bit] NOT NULL,
	[MobilityEnableOutsideVoice] [bit] NOT NULL,
	[Federation] [bit] NOT NULL,
	[Conferencing] [bit] NOT NULL,
	[EnterpriseVoice] [bit] NOT NULL,
	[VoicePolicy] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_LyncUserPlans] PRIMARY KEY CLUSTERED 
(
	[LyncUserPlanId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE dbo.LyncUserPlans ADD CONSTRAINT
	IX_LyncUserPlans UNIQUE NONCLUSTERED 
	(
	LyncUserPlanId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE dbo.LyncUserPlans ADD CONSTRAINT
	FK_LyncUserPlans_ExchangeOrganizations FOREIGN KEY
	(
	ItemID
	) REFERENCES dbo.ExchangeOrganizations
	(
	ItemID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	 
ALTER TABLE [dbo].[LyncUsers]  WITH CHECK ADD  CONSTRAINT [FK_LyncUsers_LyncUserPlans] FOREIGN KEY([LyncUserPlanId])
REFERENCES [dbo].[LyncUserPlans] ([LyncUserPlanId])

ALTER TABLE [dbo].[LyncUsers] CHECK CONSTRAINT [FK_LyncUsers_LyncUserPlans]
 	 
END
GO



IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='LyncUserPlans' AND COLS.name='LyncUserPlanType')
BEGIN
ALTER TABLE [dbo].[LyncUserPlans] ADD
	[LyncUserPlanType] [int] NULL
END
GO




/****** Object:  Table [dbo].[AddExchangeAccount]    ******/
ALTER PROCEDURE [dbo].[AddExchangeAccount] 
(
	@AccountID int OUTPUT,
	@ItemID int,
	@AccountType int,
	@AccountName nvarchar(300),
	@DisplayName nvarchar(300),
	@PrimaryEmailAddress nvarchar(300),
	@MailEnabledPublicFolder bit,
	@MailboxManagerActions varchar(200),
	@SamAccountName nvarchar(100),
	@AccountPassword nvarchar(200),
	@MailboxPlanId int,
	@SubscriberNumber nvarchar(32)
)
AS

INSERT INTO ExchangeAccounts
(
	ItemID,
	AccountType,
	AccountName,
	DisplayName,
	PrimaryEmailAddress,
	MailEnabledPublicFolder,
	MailboxManagerActions,
	SamAccountName,
	AccountPassword,
	MailboxPlanId,
	SubscriberNumber,
	UserPrincipalName
)
VALUES
(
	@ItemID,
	@AccountType,
	@AccountName,
	@DisplayName,
	@PrimaryEmailAddress,
	@MailEnabledPublicFolder,
	@MailboxManagerActions,
	@SamAccountName,
	@AccountPassword,
	@MailboxPlanId,
	@SubscriberNumber,
	@PrimaryEmailAddress
)

SET @AccountID = SCOPE_IDENTITY()

RETURN
GO







IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'AddExchangeMailboxPlan')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[AddExchangeMailboxPlan] 
(
	@MailboxPlanId int OUTPUT,
	@ItemID int,
	@MailboxPlan	nvarchar(300),
	@EnableActiveSync bit,
	@EnableIMAP bit,
	@EnableMAPI bit,
	@EnableOWA bit,
	@EnablePOP bit,
	@IsDefault bit,
	@IssueWarningPct int,
	@KeepDeletedItemsDays int,
	@MailboxSizeMB int,
	@MaxReceiveMessageSizeKB int,
	@MaxRecipients int,
	@MaxSendMessageSizeKB int,
	@ProhibitSendPct int,
	@ProhibitSendReceivePct int	,
	@HideFromAddressBook bit,
	@MailboxPlanType int
)
AS

IF (((SELECT Count(*) FROM ExchangeMailboxPlans WHERE ItemId = @ItemID) = 0) AND (@MailboxPlanType=0))
BEGIN
	SET @IsDefault = 1
END
ELSE
BEGIN
	IF ((@IsDefault = 1) AND (@MailboxPlanType=0))
	BEGIN
		UPDATE ExchangeMailboxPlans SET IsDefault = 0 WHERE ItemID = @ItemID
	END
END


INSERT INTO ExchangeMailboxPlans
(
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
)
VALUES
(
	@ItemID,
	@MailboxPlan,
	@EnableActiveSync,
	@EnableIMAP,
	@EnableMAPI,
	@EnableOWA,
	@EnablePOP,
	@IsDefault,
	@IssueWarningPct,
	@KeepDeletedItemsDays,
	@MailboxSizeMB,
	@MaxReceiveMessageSizeKB,
	@MaxRecipients,
	@MaxSendMessageSizeKB,
	@ProhibitSendPct,
	@ProhibitSendReceivePct,
	@HideFromAddressBook,
	@MailboxPlanType
)

SET @MailboxPlanId = SCOPE_IDENTITY()

RETURN'
END
GO






ALTER PROCEDURE [dbo].[AddExchangeMailboxPlan] 
(
	@MailboxPlanId int OUTPUT,
	@ItemID int,
	@MailboxPlan	nvarchar(300),
	@EnableActiveSync bit,
	@EnableIMAP bit,
	@EnableMAPI bit,
	@EnableOWA bit,
	@EnablePOP bit,
	@IsDefault bit,
	@IssueWarningPct int,
	@KeepDeletedItemsDays int,
	@MailboxSizeMB int,
	@MaxReceiveMessageSizeKB int,
	@MaxRecipients int,
	@MaxSendMessageSizeKB int,
	@ProhibitSendPct int,
	@ProhibitSendReceivePct int	,
	@HideFromAddressBook bit,
	@MailboxPlanType int
)
AS

IF (((SELECT Count(*) FROM ExchangeMailboxPlans WHERE ItemId = @ItemID) = 0) AND (@MailboxPlanType=0))
BEGIN
	SET @IsDefault = 1
END
ELSE
BEGIN
	IF ((@IsDefault = 1) AND (@MailboxPlanType=0))
	BEGIN
		UPDATE ExchangeMailboxPlans SET IsDefault = 0 WHERE ItemID = @ItemID
	END
END

INSERT INTO ExchangeMailboxPlans
(
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
)
VALUES
(
	@ItemID,
	@MailboxPlan,
	@EnableActiveSync,
	@EnableIMAP,
	@EnableMAPI,
	@EnableOWA,
	@EnablePOP,
	@IsDefault,
	@IssueWarningPct,
	@KeepDeletedItemsDays,
	@MailboxSizeMB,
	@MaxReceiveMessageSizeKB,
	@MaxRecipients,
	@MaxSendMessageSizeKB,
	@ProhibitSendPct,
	@ProhibitSendReceivePct,
	@HideFromAddressBook,
	@MailboxPlanType
)

SET @MailboxPlanId = SCOPE_IDENTITY()

RETURN

GO















ALTER PROCEDURE [dbo].[AddExchangeOrganization]
(
	@ItemID int,
	@OrganizationID nvarchar(128)
)
AS

IF NOT EXISTS(SELECT * FROM ExchangeOrganizations WHERE OrganizationID = @OrganizationID)
BEGIN
	INSERT INTO ExchangeOrganizations
	(ItemID, OrganizationID)
	VALUES
	(@ItemID, @OrganizationID)
END

RETURN
GO













ALTER FUNCTION [dbo].[CalculateQuotaUsage]
(
	@PackageID int,
	@QuotaID int
)
RETURNS int
AS
	BEGIN

		DECLARE @QuotaTypeID int
		SELECT @QuotaTypeID = QuotaTypeID FROM Quotas
		WHERE QuotaID = @QuotaID

		IF @QuotaTypeID <> 2
			RETURN 0

		DECLARE @Result int

		IF @QuotaID = 52 -- diskspace
			SET @Result = dbo.CalculatePackageDiskspace(@PackageID)
		ELSE IF @QuotaID = 51 -- bandwidth
			SET @Result = dbo.CalculatePackageBandwidth(@PackageID)
		ELSE IF @QuotaID = 53 -- domains
			SET @Result = (SELECT COUNT(D.DomainID) FROM PackagesTreeCache AS PT
				INNER JOIN Domains AS D ON D.PackageID = PT.PackageID
				WHERE IsSubDomain = 0 AND IsInstantAlias = 0 AND IsDomainPointer = 0 AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 54 -- sub-domains
			SET @Result = (SELECT COUNT(D.DomainID) FROM PackagesTreeCache AS PT
				INNER JOIN Domains AS D ON D.PackageID = PT.PackageID
				WHERE IsSubDomain = 1 AND IsInstantAlias = 0 AND IsDomainPointer = 0 AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 220 -- domain pointers
			SET @Result = (SELECT COUNT(D.DomainID) FROM PackagesTreeCache AS PT
				INNER JOIN Domains AS D ON D.PackageID = PT.PackageID
				WHERE IsDomainPointer = 1 AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 71 -- scheduled tasks
			SET @Result = (SELECT COUNT(S.ScheduleID) FROM PackagesTreeCache AS PT
				INNER JOIN Schedule AS S ON S.PackageID = PT.PackageID
				WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 305 -- RAM of VPS
			SET @Result = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'RamSize' AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 306 -- HDD of VPS
			SET @Result = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'HddSize' AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 309 -- External IP addresses of VPS
			SET @Result = (SELECT COUNT(PIP.PackageAddressID) FROM PackageIPAddresses AS PIP
							INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
							INNER JOIN PackagesTreeCache AS PT ON PIP.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID AND IP.PoolID = 3)
		ELSE IF @QuotaID = 100 -- Dedicated Web IP addresses
			SET @Result = (SELECT COUNT(PIP.PackageAddressID) FROM PackageIPAddresses AS PIP
							INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
							INNER JOIN PackagesTreeCache AS PT ON PIP.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID AND IP.PoolID = 2)
		ELSE IF @QuotaID = 350 -- RAM of VPSforPc
			SET @Result = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'Memory' AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 351 -- HDD of VPSforPc
			SET @Result = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'HddSize' AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 354 -- External IP addresses of VPSforPc
			SET @Result = (SELECT COUNT(PIP.PackageAddressID) FROM PackageIPAddresses AS PIP
							INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
							INNER JOIN PackagesTreeCache AS PT ON PIP.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID AND IP.PoolID = 3)
		ELSE IF @QuotaID = 319 -- BB Users
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts ea 
							INNER JOIN BlackBerryUsers bu ON ea.AccountID = bu.AccountID
							INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
							INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
							WHERE pt.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 320 -- OCS Users
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts ea 
							INNER JOIN OCSUsers ocs ON ea.AccountID = ocs.AccountID
							INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
							INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
							WHERE pt.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 206 -- HostedSolution.Users
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND ea.AccountType IN (1,5,6,7))
		ELSE IF @QuotaID = 78 -- Exchange2007.Mailboxes
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID 
				AND ea.AccountType IN (1)
				AND ea.MailboxPlanId IS NOT NULL)
		ELSE IF @QuotaID = 77 -- Exchange2007.DiskSpace
			SET @Result = (SELECT SUM(B.MailboxSizeMB) FROM ExchangeAccounts AS ea 
			INNER JOIN ExchangeMailboxPlans AS B ON ea.MailboxPlanId = B.MailboxPlanId 
			INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
			INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
			WHERE pt.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 370 -- Lync.Users
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN LyncUsers lu ON ea.AccountID = lu.AccountID
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 376 -- Lync.EVUsers
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN LyncUsers lu ON ea.AccountID = lu.AccountID
				INNER JOIN LyncUserPlans lp ON lu.LyncUserPlanId = lp.LyncUserPlanId
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND lp.EnterpriseVoice = 1)
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO










IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'DeleteExchangeMailboxPlan')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[DeleteExchangeMailboxPlan]
(
	@MailboxPlanId int
)
AS

-- delete mailboxplan
DELETE FROM ExchangeMailboxPlans
WHERE MailboxPlanId = @MailboxPlanId

RETURN'
END
GO














ALTER PROCEDURE [dbo].[DeleteExchangeOrganization] 
(
	@ItemID int
)
AS
BEGIN TRAN
	DELETE FROM ExchangeMailboxPlans WHERE ItemID = @ItemID
	DELETE FROM ExchangeOrganizations WHERE ItemID = @ItemID
COMMIT TRAN
RETURN
GO





IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'UpdateExchangeMailboxPlan')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[UpdateExchangeMailboxPlan] 
(
	@MailboxPlanId int,
	@MailboxPlan	nvarchar(300),
	@EnableActiveSync bit,
	@EnableIMAP bit,
	@EnableMAPI bit,
	@EnableOWA bit,
	@EnablePOP bit,
	@IsDefault bit,
	@IssueWarningPct int,
	@KeepDeletedItemsDays int,
	@MailboxSizeMB int,
	@MaxReceiveMessageSizeKB int,
	@MaxRecipients int,
	@MaxSendMessageSizeKB int,
	@ProhibitSendPct int,
	@ProhibitSendReceivePct int	,
	@HideFromAddressBook bit,
	@MailboxPlanType int
)
AS

UPDATE ExchangeMailboxPlans SET
	MailboxPlan = @MailboxPlan,
	EnableActiveSync = @EnableActiveSync,
	EnableIMAP = @EnableIMAP,
	EnableMAPI = @EnableMAPI,
	EnableOWA = @EnableOWA,
	EnablePOP = @EnablePOP,
	IsDefault = @IsDefault,
	IssueWarningPct= @IssueWarningPct,
	KeepDeletedItemsDays = @KeepDeletedItemsDays,
	MailboxSizeMB= @MailboxSizeMB,
	MaxReceiveMessageSizeKB= @MaxReceiveMessageSizeKB,
	MaxRecipients= @MaxRecipients,
	MaxSendMessageSizeKB= @MaxSendMessageSizeKB,
	ProhibitSendPct= @ProhibitSendPct,
	ProhibitSendReceivePct = @ProhibitSendReceivePct,
	HideFromAddressBook = @HideFromAddressBook,
	MailboxPlanType = @MailboxPlanType
WHERE MailboxPlanId = @MailboxPlanId

RETURN'
END
GO







IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetUserByExchangeOrganizationIdInternally')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[GetUserByExchangeOrganizationIdInternally]
(
	@ItemID int
)
AS
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		U.Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.UserID IN (SELECT UserID FROM Packages WHERE PackageID IN (
	SELECT PackageID FROM ServiceItems WHERE ItemID = @ItemID))
	
RETURN'
END
GO










ALTER PROCEDURE [dbo].[GetUserByExchangeOrganizationIdInternally]
(
	@ItemID int
)
AS
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		U.Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.UserID IN (SELECT UserID FROM Packages WHERE PackageID IN (
	SELECT PackageID FROM ServiceItems WHERE ItemID = @ItemID))
	
RETURN

GO






ALTER PROCEDURE [dbo].[GetUserByExchangeOrganizationIdInternally]
(
	@ItemID int
)
AS
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		U.Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.UserID IN (SELECT UserID FROM Packages WHERE PackageID IN (
	SELECT PackageID FROM ServiceItems WHERE ItemID = @ItemID))
	
RETURN
GO








ALTER PROCEDURE [dbo].[ExchangeAccountExists] 
(
	@AccountName nvarchar(20),
	@Exists bit OUTPUT
)
AS
SET @Exists = 0
IF EXISTS(SELECT * FROM ExchangeAccounts WHERE sAMAccountName LIKE '%\'+@AccountName)
BEGIN
	SET @Exists = 1
END

RETURN

GO












ALTER PROCEDURE [dbo].[GetExchangeAccounts]
(
	@ItemID int,
	@AccountType int
)
AS
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxPlanId,
	P.MailboxPlan, 
	E.SubscriberNumber,
	E.UserPrincipalName
FROM
	ExchangeAccounts  AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId		
WHERE
	E.ItemID = @ItemID AND
	(E.AccountType = @AccountType OR @AccountType IS NULL) 
ORDER BY DisplayName
RETURN

GO










ALTER PROCEDURE [dbo].[GetExchangeAccountsPaged]
(
	@ActorID int,
	@ItemID int,
	@AccountTypes nvarchar(30),
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS

DECLARE @PackageID int
SELECT @PackageID = PackageID FROM ServiceItems
WHERE ItemID = @ItemID

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
EA.AccountType IN (' + @AccountTypes + ')
AND EA.ItemID = @ItemID
'

IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
AND @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn = 'PrimaryEmailAddress' AND @AccountTypes <> '2'
	BEGIN		
		SET @condition = @condition + ' AND EA.AccountID IN (SELECT EAEA.AccountID FROM ExchangeAccountEmailAddresses EAEA WHERE EAEA.EmailAddress LIKE ''' + @FilterValue + ''')'
	END
	ELSE
	BEGIN		
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	END
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'EA.DisplayName ASC'

DECLARE @joincondition nvarchar(700)
	SET @joincondition = ',P.MailboxPlan FROM ExchangeAccounts AS EA
	LEFT OUTER JOIN ExchangeMailboxPlans AS P ON EA.MailboxPlanId = P.MailboxPlanId'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(EA.AccountID) FROM ExchangeAccounts AS EA
WHERE ' + @condition + ';

WITH Accounts AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		EA.AccountID,
		EA.ItemID,
		EA.AccountType,
		EA.AccountName,
		EA.DisplayName,
		EA.PrimaryEmailAddress,
		EA.MailEnabledPublicFolder,
		EA.MailboxPlanId,
		EA.SubscriberNumber,
		EA.UserPrincipalName ' + @joincondition +
	' WHERE ' + @condition + '
)

SELECT * FROM Accounts
WHERE Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows
'

print @sql

exec sp_executesql @sql, N'@ItemID int, @StartRow int, @MaximumRows int',
@ItemID, @StartRow, @MaximumRows

RETURN 




GO









IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeAccountByAccountName')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeAccountByAccountName] 
(
	@ItemID int,
	@AccountName nvarchar(300)
)
AS
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.AccountName = @AccountName
RETURN'
END
GO



ALTER PROCEDURE [dbo].[GetExchangeAccountByAccountName] 
(
	@ItemID int,
	@AccountName nvarchar(300)
)
AS
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.AccountName = @AccountName
RETURN
GO




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeAccountByMailboxPlanId')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeAccountByMailboxPlanId] 
(
	@ItemID int,
	@MailboxPlanId int
)
AS

IF (@MailboxPlanId < 0)
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.MailboxPlanId IS NULL AND
	E.AccountType IN (1,5) 
RETURN

END
ELSE
IF (@ItemId = 0)
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber, 
	E.UserPrincipalName
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.MailboxPlanId = @MailboxPlanId AND
	E.AccountType IN (1,5) 
END
ELSE
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.MailboxPlanId = @MailboxPlanId AND
	E.AccountType IN (1,5) 
RETURN
END'
END
GO






ALTER PROCEDURE [dbo].[GetExchangeAccountByMailboxPlanId] 
(
	@ItemID int,
	@MailboxPlanId int
)
AS

IF (@MailboxPlanId < 0)
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.MailboxPlanId IS NULL AND
	E.AccountType IN (1,5) 
RETURN

END
ELSE
IF (@ItemId = 0)
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.MailboxPlanId = @MailboxPlanId AND
	E.AccountType IN (1,5) 
END
ELSE
BEGIN
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.MailboxPlanId = @MailboxPlanId AND
	E.AccountType IN (1,5) 
RETURN
END
GO






IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeMailboxPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeMailboxPlan] 
(
	@MailboxPlanId int
)
AS
SELECT
	MailboxPlanId,
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
FROM
	ExchangeMailboxPlans
WHERE
	MailboxPlanId = @MailboxPlanId
RETURN'
END
GO






ALTER PROCEDURE [dbo].[GetExchangeMailboxPlan] 
(
	@MailboxPlanId int
)
AS
SELECT
	MailboxPlanId,
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
FROM
	ExchangeMailboxPlans
WHERE
	MailboxPlanId = @MailboxPlanId
RETURN
GO


















IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeMailboxPlans')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeMailboxPlans]
(
	@ItemID int
)
AS
SELECT
	MailboxPlanId,
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
FROM
	ExchangeMailboxPlans
WHERE
	ItemID = @ItemID 
ORDER BY MailboxPlan
RETURN'
END
GO








ALTER PROCEDURE [dbo].[GetExchangeMailboxPlans]
(
	@ItemID int
)
AS
SELECT
	MailboxPlanId,
	ItemID,
	MailboxPlan,
	EnableActiveSync,
	EnableIMAP,
	EnableMAPI,
	EnableOWA,
	EnablePOP,
	IsDefault,
	IssueWarningPct,
	KeepDeletedItemsDays,
	MailboxSizeMB,
	MaxReceiveMessageSizeKB,
	MaxRecipients,
	MaxSendMessageSizeKB,
	ProhibitSendPct,
	ProhibitSendReceivePct,
	HideFromAddressBook,
	MailboxPlanType
FROM
	ExchangeMailboxPlans
WHERE
	ItemID = @ItemID 
ORDER BY MailboxPlan
RETURN
GO

















ALTER PROCEDURE [dbo].[GetExchangeOrganizationStatistics] 
(
	@ItemID int
)
AS

IF -1 IN (SELECT B.MailboxSizeMB FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1 OR AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT MIN(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace
END
ELSE
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1 OR AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT SUM(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace
END


RETURN
GO




















ALTER PROCEDURE [dbo].[GetPackages]
(
	@ActorID int,
	@UserID int
)
AS

IF dbo.CheckActorUserRights(@ActorID, @UserID) = 0
RAISERROR('You are not allowed to access this account', 16, 1)

SELECT
	P.PackageID,
	P.ParentPackageID,
	P.PackageName,
	P.StatusID,
	P.PurchaseDate,
	
	-- server
	ISNULL(P.ServerID, 0) AS ServerID,
	ISNULL(S.ServerName, 'None') AS ServerName,
	ISNULL(S.Comments, '') AS ServerComments,
	ISNULL(S.VirtualServer, 1) AS VirtualServer,
	
	-- hosting plan
	P.PlanID,
	HP.PlanName,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.RoleID,
	U.Email
FROM Packages AS P
INNER JOIN Users AS U ON P.UserID = U.UserID
INNER JOIN Servers AS S ON P.ServerID = S.ServerID
INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE
	P.UserID = @UserID	
RETURN

GO










IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SetExchangeAccountMailboxplan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[SetExchangeAccountMailboxplan] 
(
	@AccountID int,
	@MailboxPlanId int
)
AS

UPDATE ExchangeAccounts SET
	MailboxPlanId = @MailboxPlanId
WHERE
	AccountID = @AccountID

RETURN'
END
GO













IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SetOrganizationDefaultExchangeMailboxPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[SetOrganizationDefaultExchangeMailboxPlan]
(
	@ItemId int,
	@MailboxPlanId int
)
AS

UPDATE ExchangeMailboxPlans SET IsDefault=0 WHERE ItemId=@ItemId
UPDATE ExchangeMailboxPlans SET IsDefault=1 WHERE MailboxPlanId=@MailboxPlanId

RETURN'
END
GO


















ALTER PROCEDURE [dbo].[UpdateExchangeAccount] 
(
	@AccountID int,
	@AccountName nvarchar(300),
	@DisplayName nvarchar(300),
	@PrimaryEmailAddress nvarchar(300),
	@AccountType int,
	@SamAccountName nvarchar(100),
	@MailEnabledPublicFolder bit,
	@MailboxManagerActions varchar(200),
	@Password varchar(200),
	@MailboxPlanId int,
	@SubscriberNumber varchar(32)
)
AS

BEGIN TRAN	

IF (@MailboxPlanId = -1) 
BEGIN
	SET @MailboxPlanId = NULL
END

UPDATE ExchangeAccounts SET
	AccountName = @AccountName,
	DisplayName = @DisplayName,
	PrimaryEmailAddress = @PrimaryEmailAddress,
	MailEnabledPublicFolder = @MailEnabledPublicFolder,
	MailboxManagerActions = @MailboxManagerActions,	
	AccountType =@AccountType,
	SamAccountName = @SamAccountName,
	MailboxPlanId = @MailboxPlanId,
	SubscriberNumber = @SubscriberNumber

WHERE
	AccountID = @AccountID

IF (@@ERROR <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

UPDATE ExchangeAccounts SET 
	AccountPassword = @Password WHERE AccountID = @AccountID AND @Password IS NOT NULL

IF (@@ERROR <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
COMMIT TRAN
RETURN
GO










ALTER PROCEDURE [dbo].[GetExchangeAccount] 
(
	@ItemID int,
	@AccountID int
)
AS
SELECT
	E.AccountID,
	E.ItemID,
	E.AccountType,
	E.AccountName,
	E.DisplayName,
	E.PrimaryEmailAddress,
	E.MailEnabledPublicFolder,
	E.MailboxManagerActions,
	E.SamAccountName,
	E.AccountPassword,
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName 
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
WHERE
	E.ItemID = @ItemID AND
	E.AccountID = @AccountID
RETURN
GO









ALTER PROCEDURE [dbo].[GetExchangeMailboxes]
	@ItemID int
AS
BEGIN
SELECT
	AccountID,
	ItemID,
	AccountType,
	AccountName,
	DisplayName,
	PrimaryEmailAddress,
	MailEnabledPublicFolder,
	SubscriberNumber,
	UserPrincipalName
FROM
	ExchangeAccounts
WHERE
	ItemID = @ItemID AND
	(AccountType =1  OR AccountType=5 OR AccountType=6) 
ORDER BY 1

END

GO












ALTER PROCEDURE [dbo].[SearchExchangeAccount]
(
      @ActorID int,
      @AccountType int,
      @PrimaryEmailAddress nvarchar(300)
)
AS

DECLARE @PackageID int
DECLARE @ItemID int
DECLARE @AccountID int

SELECT
      @AccountID = AccountID,
      @ItemID = ItemID
FROM ExchangeAccounts
WHERE PrimaryEmailAddress = @PrimaryEmailAddress
AND AccountType = @AccountType


-- check space rights
SELECT @PackageID = PackageID FROM ServiceItems
WHERE ItemID = @ItemID

IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

SELECT
	AccountID,
	ItemID,
	@PackageID AS PackageID,
	AccountType,
	AccountName,
	DisplayName,
	PrimaryEmailAddress,
	MailEnabledPublicFolder,
	MailboxManagerActions,
	SamAccountName,
	AccountPassword, 
	SubscriberNumber,
	UserPrincipalName
FROM ExchangeAccounts
WHERE AccountID = @AccountID

RETURN 

GO











ALTER PROCEDURE [dbo].[SearchExchangeAccounts]
(
	@ActorID int,
	@ItemID int,
	@IncludeMailboxes bit,
	@IncludeContacts bit,
	@IncludeDistributionLists bit,
	@IncludeRooms bit,
	@IncludeEquipment bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50)
)
AS
DECLARE @PackageID int
SELECT @PackageID = PackageID FROM ServiceItems
WHERE ItemID = @ItemID

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
((@IncludeMailboxes = 1 AND EA.AccountType = 1)
OR (@IncludeContacts = 1 AND EA.AccountType = 2)
OR (@IncludeDistributionLists = 1 AND EA.AccountType = 3)
OR (@IncludeRooms = 1 AND EA.AccountType = 5)
OR (@IncludeEquipment = 1 AND EA.AccountType = 6))
AND EA.ItemID = @ItemID
'

IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
AND @FilterValue <> '' AND @FilterValue IS NOT NULL
SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'EA.DisplayName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT
	EA.AccountID,
	EA.ItemID,
	EA.AccountType,
	EA.AccountName,
	EA.DisplayName,
	EA.PrimaryEmailAddress,
	EA.MailEnabledPublicFolder,
	EA.SubscriberNumber,
	EA.UserPrincipalName
FROM ExchangeAccounts AS EA
WHERE ' + @condition

print @sql

exec sp_executesql @sql, N'@ItemID int, @IncludeMailboxes int, @IncludeContacts int,
    @IncludeDistributionLists int, @IncludeRooms bit, @IncludeEquipment bit',
@ItemID, @IncludeMailboxes, @IncludeContacts, @IncludeDistributionLists, @IncludeRooms, @IncludeEquipment

RETURN 

GO


















ALTER PROCEDURE [dbo].[SearchOrganizationAccounts]
(
	@ActorID int,
	@ItemID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@IncludeMailboxes bit
)
AS
DECLARE @PackageID int
SELECT @PackageID = PackageID FROM ServiceItems
WHERE ItemID = @ItemID

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
(EA.AccountType = 7 OR (EA.AccountType = 1 AND @IncludeMailboxes = 1)  )
AND EA.ItemID = @ItemID
'

IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
AND @FilterValue <> '' AND @FilterValue IS NOT NULL
SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'EA.DisplayName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT
	EA.AccountID,
	EA.ItemID,
	EA.AccountType,
	EA.AccountName,
	EA.DisplayName,
	EA.PrimaryEmailAddress,
	EA.SubscriberNumber,
	EA.UserPrincipalName
FROM ExchangeAccounts AS EA
WHERE ' + @condition

print @sql

exec sp_executesql @sql, N'@ItemID int, @IncludeMailboxes bit', 
@ItemID, @IncludeMailboxes

RETURN 

GO










IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'AddLyncUser')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[AddLyncUser]	
	@AccountID int,
	@LyncUserPlanID int
AS
INSERT INTO
	dbo.LyncUsers
	(AccountID,
	 LyncUserPlanID,
	 CreatedDate,
	 ModifiedDate)
VALUES
(		
	@AccountID,
	@LyncUserPlanID,
	getdate(),
	getdate()
)'		
END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUsersByPlanId')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUsersByPlanId]
(
	@ItemID int,
	@PlanId int
)
AS

	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.UserPrincipalName,
		ea.SamAccountName,
		ou.LyncUserPlanId,
		lp.LyncUserPlanName
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		LyncUsers ou
	INNER JOIN
		LyncUserPlans lp 
	ON
		ou.LyncUserPlanId = lp.LyncUserPlanId				
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID AND
		ou.LyncUserPlanId = @PlanId'
END
GO







ALTER PROCEDURE [dbo].[GetLyncUsersByPlanId]
(
	@ItemID int,
	@PlanId int
)
AS

	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.UserPrincipalName,
		ea.SamAccountName,
		ou.LyncUserPlanId,
		lp.LyncUserPlanName
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		LyncUsers ou
	INNER JOIN
		LyncUserPlans lp 
	ON
		ou.LyncUserPlanId = lp.LyncUserPlanId				
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID AND
		ou.LyncUserPlanId = @PlanId
GO







IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'AddLyncUserPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[AddLyncUserPlan] 
(
	@LyncUserPlanId int OUTPUT,
	@ItemID int,
	@LyncUserPlanName	nvarchar(300),
	@LyncUserPlanType int,
	@IM bit,
	@Mobility bit,
	@MobilityEnableOutsideVoice bit,
	@Federation bit,
	@Conferencing bit,
	@EnterpriseVoice bit,
	@VoicePolicy int,
	@IsDefault bit
)
AS



IF (((SELECT Count(*) FROM LyncUserPlans WHERE ItemId = @ItemID) = 0) AND (@LyncUserPlanType=0))
BEGIN
	SET @IsDefault = 1
END
ELSE
BEGIN
	IF ((@IsDefault = 1) AND (@LyncUserPlanType=0))
	BEGIN
		UPDATE LyncUserPlans SET IsDefault = 0 WHERE ItemID = @ItemID
	END
END


INSERT INTO LyncUserPlans
(
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
)
VALUES
(
	@ItemID,
	@LyncUserPlanName,
	@LyncUserPlanType,
	@IM,
	@Mobility,
	@MobilityEnableOutsideVoice,
	@Federation,
	@Conferencing,
	@EnterpriseVoice,
	@VoicePolicy,
	@IsDefault
)

SET @LyncUserPlanId = SCOPE_IDENTITY()

RETURN'		
END
GO









ALTER PROCEDURE [dbo].[AddLyncUserPlan] 
(
	@LyncUserPlanId int OUTPUT,
	@ItemID int,
	@LyncUserPlanName	nvarchar(300),
	@LyncUserPlanType int,
	@IM bit,
	@Mobility bit,
	@MobilityEnableOutsideVoice bit,
	@Federation bit,
	@Conferencing bit,
	@EnterpriseVoice bit,
	@VoicePolicy int,
	@IsDefault bit
)
AS

IF (((SELECT Count(*) FROM LyncUserPlans WHERE ItemId = @ItemID) = 0) AND (@LyncUserPlanType=0))
BEGIN
	SET @IsDefault = 1
END
ELSE
BEGIN
	IF ((@IsDefault = 1) AND (@LyncUserPlanType=0))
	BEGIN
		UPDATE LyncUserPlans SET IsDefault = 0 WHERE ItemID = @ItemID
	END
END


INSERT INTO LyncUserPlans
(
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
)
VALUES
(
	@ItemID,
	@LyncUserPlanName,
	@LyncUserPlanType,
	@IM,
	@Mobility,
	@MobilityEnableOutsideVoice,
	@Federation,
	@Conferencing,
	@EnterpriseVoice,
	@VoicePolicy,
	@IsDefault
)

SET @LyncUserPlanId = SCOPE_IDENTITY()

RETURN
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'CheckLyncUserExists')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[CheckLyncUserExists] 
	@AccountID int
AS
	SELECT 
		COUNT(AccountID)
	FROM 
		dbo.LyncUsers
	WHERE AccountID = @AccountID'
END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'CheckLyncUserExists')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[CheckLyncUserExists] 
	@AccountID int
AS
BEGIN	
	SELECT 
		COUNT(AccountID)
	FROM 
		dbo.LyncUsers
	WHERE AccountID = @AccountID'
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'DeleteLyncUser')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[DeleteLyncUser]
(	
	@AccountId int
)
AS

DELETE FROM 
	LyncUsers
WHERE 
	AccountId = @AccountId

RETURN'
END
GO








IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'DeleteLyncUserPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[DeleteLyncUserPlan]
(
	@LyncUserPlanId int
)
AS

-- delete lyncuserplan
DELETE FROM LyncUserPlans
WHERE LyncUserPlanId = @LyncUserPlanId

RETURN'
END
GO









IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUserPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUserPlan] 
(
	@LyncUserPlanId int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	LyncUserPlanId = @LyncUserPlanId
RETURN'
END
GO





ALTER PROCEDURE [dbo].[GetLyncUserPlan] 
(
	@LyncUserPlanId int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	LyncUserPlanId = @LyncUserPlanId
RETURN
GO





IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUserPlanByAccountId')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUserPlanByAccountId] 
(
	@AccountID int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	LyncUserPlanId IN (SELECT LyncUserPlanId FROM LyncUsers WHERE AccountID = @AccountID)
RETURN'
END
GO







ALTER PROCEDURE [dbo].[GetLyncUserPlanByAccountId] 
(
	@AccountID int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	LyncUserPlanId IN (SELECT LyncUserPlanId FROM LyncUsers WHERE AccountID = @AccountID)
RETURN
GO




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUserPlans')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUserPlans]
(
	@ItemID int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	ItemID = @ItemID 
ORDER BY LyncUserPlanName
RETURN'
END
GO






ALTER PROCEDURE [dbo].[GetLyncUserPlans]
(
	@ItemID int
)
AS
SELECT
	LyncUserPlanId,
	ItemID,
	LyncUserPlanName,
	LyncUserPlanType,
	IM,
	Mobility,
	MobilityEnableOutsideVoice,
	Federation,
	Conferencing,
	EnterpriseVoice,
	VoicePolicy,
	IsDefault
FROM
	LyncUserPlans
WHERE
	ItemID = @ItemID 
ORDER BY LyncUserPlanName
RETURN
GO


IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='LyncUsers' AND COLS.name='SipAddress')
BEGIN
ALTER TABLE [dbo].[LyncUsers] ADD
	[SipAddress] [nvarchar] (300) COLLATE Latin1_General_CI_AS NULL
END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUsers')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@StartRow int,
	@Count int	
)
AS

CREATE TABLE #TempLyncUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300)  NOT NULL,
	[DisplayName] [nvarchar](300)  NOT NULL,
	[UserPrincipalName] [nvarchar](300) NULL,
	[SipAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL,
	[LyncUserPlanId] [int] NOT NULL,		
	[LyncUserPlanName] [nvarchar] (300) NOT NULL,		
)


DECLARE @condition nvarchar(700)
SET @condition = ''''

IF (@SortColumn = ''DisplayName'')
BEGIN
	SET @condition = ''ORDER BY ea.DisplayName''
END

IF (@SortColumn = ''UserPrincipalName'')
BEGIN
	SET @condition = ''ORDER BY ea.UserPrincipalName''
END

IF (@SortColumn = ''SipAddress'')
BEGIN
	SET @condition = ''ORDER BY ou.SipAddress''
END


IF (@SortColumn = ''LyncUserPlanName'')
BEGIN
	SET @condition = ''ORDER BY lp.LyncUserPlanName''
END

DECLARE @sql nvarchar(3500)

set @sql = ''
	INSERT INTO 
		#TempLyncUsers 
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.UserPrincipalName,
		ou.SipAddress,
		ea.SamAccountName,
		ou.LyncUserPlanId,
		lp.LyncUserPlanName				
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		LyncUsers ou
	INNER JOIN
		LyncUserPlans lp 
	ON
		ou.LyncUserPlanId = lp.LyncUserPlanId				
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID '' + @condition

exec sp_executesql @sql, N''@ItemID int'',@ItemID

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempLyncUsers 

IF (@SortDirection = ''ASC'')
BEGIN
	SELECT * FROM #TempLyncUsers 
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF @SortColumn <> '''' AND @SortColumn IS NOT NULL
	BEGIN
		IF (@SortColumn = ''DisplayName'')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
		END
		IF (@SortColumn = ''UserPrincipalName'')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY UserPrincipalName DESC
		END
		IF (@SortColumn = ''SipAddress'')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY SipAddress DESC
		END

		IF (@SortColumn = ''LyncUserPlanName'')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY LyncUserPlanName DESC
		END
	END
	ELSE
	BEGIN
		SELECT * FROM #TempLyncUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY UserPrincipalName DESC
	END

	
END

DROP TABLE #TempLyncUsers'
END
GO




ALTER PROCEDURE [dbo].[GetLyncUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@StartRow int,
	@Count int	
)
AS

CREATE TABLE #TempLyncUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300)  NOT NULL,
	[DisplayName] [nvarchar](300)  NOT NULL,
	[UserPrincipalName] [nvarchar](300) NULL,
	[SipAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL,
	[LyncUserPlanId] [int] NOT NULL,		
	[LyncUserPlanName] [nvarchar] (300) NOT NULL,		
)


DECLARE @condition nvarchar(700)
SET @condition = ''

IF (@SortColumn = 'DisplayName')
BEGIN
	SET @condition = 'ORDER BY ea.DisplayName'
END

IF (@SortColumn = 'UserPrincipalName')
BEGIN
	SET @condition = 'ORDER BY ea.UserPrincipalName'
END

IF (@SortColumn = 'SipAddress')
BEGIN
	SET @condition = 'ORDER BY ou.SipAddress'
END


IF (@SortColumn = 'LyncUserPlanName')
BEGIN
	SET @condition = 'ORDER BY lp.LyncUserPlanName'
END

DECLARE @sql nvarchar(3500)

set @sql = ''
	INSERT INTO 
		#TempLyncUsers 
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.UserPrincipalName,
		ou.SipAddress,
		ea.SamAccountName,
		ou.LyncUserPlanId,
		lp.LyncUserPlanName				
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		LyncUsers ou
	INNER JOIN
		LyncUserPlans lp 
	ON
		ou.LyncUserPlanId = lp.LyncUserPlanId				
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID + @condition

exec sp_executesql @sql, N'@ItemID int',@ItemID

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempLyncUsers 

IF (@SortDirection = 'ASC')
BEGIN
	SELECT * FROM #TempLyncUsers 
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF @SortColumn <> '' AND @SortColumn IS NOT NULL
	BEGIN
		IF (@SortColumn = 'DisplayName')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
		END
		IF (@SortColumn = 'UserPrincipalName')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY UserPrincipalName DESC
		END

		IF (@SortColumn = 'SipAddress')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY SipAddress DESC
		END

		IF (@SortColumn = 'LyncUserPlanName')
		BEGIN
			SELECT * FROM #TempLyncUsers 
				WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY LyncUserPlanName DESC
		END
	END
	ELSE
	BEGIN
		SELECT * FROM #TempLyncUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY UserPrincipalName DESC
	END

	
END

DROP TABLE #TempLyncUsers
GO











IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetLyncUsersCount')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetLyncUsersCount] 
(
	@ItemID int
)
AS

SELECT 
	COUNT(ea.AccountID)		
FROM 
	ExchangeAccounts ea 
INNER JOIN 
	LyncUsers ou 
ON 
	ea.AccountID = ou.AccountID
WHERE 
	ea.ItemID = @ItemID'
END
GO








IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SetLyncUserLyncUserPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[SetLyncUserLyncUserPlan] 
(
	@AccountID int,
	@LyncUserPlanId int
)
AS

UPDATE LyncUsers SET
	LyncUserPlanId = @LyncUserPlanId
WHERE
	AccountID = @AccountID

RETURN'
END
GO












IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SetOrganizationDefaultLyncUserPlan')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[SetOrganizationDefaultLyncUserPlan]
(
	@ItemId int,
	@LyncUserPlanId int
)
AS

UPDATE LyncUserPlans SET IsDefault=0 WHERE ItemId=@ItemId
UPDATE LyncUserPlans SET IsDefault=1 WHERE LyncUserPlanId=@LyncUserPlanId

RETURN'
END
GO















ALTER PROCEDURE [dbo].[GetHostingPlanQuotas]
(
	@ActorID int,
	@PlanID int,
	@PackageID int,
	@ServerID int
)
AS

-- check rights
IF dbo.CheckActorParentPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

DECLARE @IsAddon bit

IF @ServerID = 0
SELECT @ServerID = ServerID FROM Packages
WHERE PackageID = @PackageID

-- get resource groups
SELECT
	RG.GroupID,
	RG.GroupName,
	CASE
		WHEN HPR.CalculateDiskSpace IS NULL THEN CAST(0 as bit)
		ELSE CAST(1 as bit)
	END AS Enabled,
	dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, @ServerID) AS ParentEnabled,
	ISNULL(HPR.CalculateDiskSpace, 1) AS CalculateDiskSpace,
	ISNULL(HPR.CalculateBandwidth, 1) AS CalculateBandwidth
FROM ResourceGroups AS RG 
LEFT OUTER JOIN HostingPlanResources AS HPR ON RG.GroupID = HPR.GroupID AND HPR.PlanID = @PlanID
WHERE (RG.ShowGroup = 1)
ORDER BY RG.GroupOrder

-- get quotas by groups
SELECT
	Q.QuotaID,
	Q.GroupID,
	Q.QuotaName,
	Q.QuotaDescription,
	Q.QuotaTypeID,
	ISNULL(HPQ.QuotaValue, 0) AS QuotaValue,
	dbo.GetPackageAllocatedQuota(@PackageID, Q.QuotaID) AS ParentQuotaValue
FROM Quotas AS Q
LEFT OUTER JOIN HostingPlanQuotas AS HPQ ON Q.QuotaID = HPQ.QuotaID AND HPQ.PlanID = @PlanID
WHERE Q.HideQuota IS NULL OR Q.HideQuota = 0
ORDER BY Q.QuotaOrder
RETURN
GO














ALTER PROCEDURE [dbo].[GetRawServicesByServerID]
(
	@ActorID int,
	@ServerID int
)
AS

-- check rights
DECLARE @IsAdmin bit
SET @IsAdmin = dbo.CheckIsUserAdmin(@ActorID)

-- resource groups
SELECT
	GroupID,
	GroupName
FROM ResourceGroups
WHERE @IsAdmin = 1 AND (ShowGroup = 1)
ORDER BY GroupOrder

-- services
SELECT
	S.ServiceID,
	S.ServerID,
	S.ServiceName,
	S.Comments,
	RG.GroupID,
	PROV.DisplayName AS ProviderName
FROM Services AS S
INNER JOIN Providers AS PROV ON S.ProviderID = PROV.ProviderID
INNER JOIN ResourceGroups AS RG ON PROV.GroupID = RG.GroupID
WHERE
	S.ServerID = @ServerID
	AND @IsAdmin = 1
ORDER BY RG.GroupOrder

RETURN 
GO













ALTER PROCEDURE [dbo].[GetVirtualServices]
(
	@ActorID int,
	@ServerID int
)
AS

-- check rights
DECLARE @IsAdmin bit
SET @IsAdmin = dbo.CheckIsUserAdmin(@ActorID)

-- virtual groups
SELECT
	VRG.VirtualGroupID,
	RG.GroupID,
	RG.GroupName,
	ISNULL(VRG.DistributionType, 1) AS DistributionType,
	ISNULL(VRG.BindDistributionToPrimary, 1) AS BindDistributionToPrimary
FROM ResourceGroups AS RG
LEFT OUTER JOIN VirtualGroups AS VRG ON RG.GroupID = VRG.GroupID AND VRG.ServerID = @ServerID
WHERE
	@IsAdmin = 1 AND (ShowGroup = 1)
ORDER BY RG.GroupOrder

-- services
SELECT
	VS.ServiceID,
	S.ServiceName,
	S.Comments,
	P.GroupID,
	P.DisplayName,
	SRV.ServerName
FROM VirtualServices AS VS
INNER JOIN Services AS S ON VS.ServiceID = S.ServiceID
INNER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
INNER JOIN Providers AS P ON S.ProviderID = P.ProviderID
WHERE
	VS.ServerID = @ServerID
	AND @IsAdmin = 1

RETURN 
GO








ALTER PROCEDURE [dbo].[AddUser]
(
	@ActorID int,
	@UserID int OUTPUT,
	@OwnerID int,
	@RoleID int,
	@StatusID int,
	@SubscriberNumber nvarchar(32),
	@LoginStatusID int,
	@IsDemo bit,
	@IsPeer bit,
	@Comments ntext,
	@Username nvarchar(50),
	@Password nvarchar(200),
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Email nvarchar(255),
	@SecondaryEmail nvarchar(255),
	@Address nvarchar(200),
	@City nvarchar(50),
	@State nvarchar(50),
	@Country nvarchar(50),
	@Zip varchar(20),
	@PrimaryPhone varchar(30),
	@SecondaryPhone varchar(30),
	@Fax varchar(30),
	@InstantMessenger nvarchar(200),
	@HtmlMail bit,
	@CompanyName nvarchar(100),
	@EcommerceEnabled bit
)
AS

-- check if the user already exists
IF EXISTS(SELECT UserID FROM Users WHERE Username = @Username)
BEGIN
	SET @UserID = -1
	RETURN
END

-- check actor rights
IF dbo.CanCreateUser(@ActorID, @OwnerID) = 0
BEGIN
	SET @UserID = -2
	RETURN
END

INSERT INTO Users
(
	OwnerID,
	RoleID,
	StatusID,
	SubscriberNumber,
	LoginStatusID,
	Created,
	Changed,
	IsDemo,
	IsPeer,
	Comments,
	Username,
	Password,
	FirstName,
	LastName,
	Email,
	SecondaryEmail,
	Address,
	City,
	State,
	Country,
	Zip,
	PrimaryPhone,
	SecondaryPhone,
	Fax,
	InstantMessenger,
	HtmlMail,
	CompanyName,
	EcommerceEnabled
)
VALUES
(
	@OwnerID,
	@RoleID,
	@StatusID,
	@SubscriberNumber,
	@LoginStatusID,
	GetDate(),
	GetDate(),
	@IsDemo,
	@IsPeer,
	@Comments,
	@Username,
	@Password,
	@FirstName,
	@LastName,
	@Email,
	@SecondaryEmail,
	@Address,
	@City,
	@State,
	@Country,
	@Zip,
	@PrimaryPhone,
	@SecondaryPhone,
	@Fax,
	@InstantMessenger,
	@HtmlMail,
	@CompanyName,
	@EcommerceEnabled
)

SET @UserID = SCOPE_IDENTITY()

RETURN 
GO






ALTER PROCEDURE [dbo].[GetUserById]
(
	@ActorID int,
	@UserID int
)
AS
	-- user can retrieve his own account, his users accounts
	-- and his reseller account (without pasword)
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		CASE WHEN dbo.CanGetUserPassword(@ActorID, @UserID) = 1 THEN U.Password
		ELSE '' END AS Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.UserID = @UserID
	AND dbo.CanGetUserDetails(@ActorID, @UserID) = 1 -- actor user rights

	RETURN
GO













ALTER PROCEDURE [dbo].[GetUserByIdInternally]
(
	@UserID int
)
AS
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		U.Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.UserID = @UserID

	RETURN

GO










ALTER PROCEDURE [dbo].[GetUserByUsername]
(
	@ActorID int,
	@Username nvarchar(50)
)
AS

	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		CASE WHEN dbo.CanGetUserPassword(@ActorID, UserID) = 1 THEN U.Password
		ELSE '' END AS Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.Username = @Username
	AND dbo.CanGetUserDetails(@ActorID, UserID) = 1 -- actor user rights

	RETURN
GO








ALTER PROCEDURE [dbo].[GetUserByUsernameInternally]
(
	@Username nvarchar(50)
)
AS
	SELECT
		U.UserID,
		U.RoleID,
		U.StatusID,
		U.SubscriberNumber,
		U.LoginStatusId,
		U.FailedLogins,
		U.OwnerID,
		U.Created,
		U.Changed,
		U.IsDemo,
		U.Comments,
		U.IsPeer,
		U.Username,
		U.Password,
		U.FirstName,
		U.LastName,
		U.Email,
		U.SecondaryEmail,
		U.Address,
		U.City,
		U.State,
		U.Country,
		U.Zip,
		U.PrimaryPhone,
		U.SecondaryPhone,
		U.Fax,
		U.InstantMessenger,
		U.HtmlMail,
		U.CompanyName,
		U.EcommerceEnabled,
		U.[AdditionalParams]
	FROM Users AS U
	WHERE U.Username = @Username

	RETURN

GO













ALTER PROCEDURE [dbo].[GetUserDomainsPaged]
(
	@ActorID int,
	@UserID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

SET @sql = '
DECLARE @HasUserRights bit
SET @HasUserRights = dbo.CheckActorUserRights(@ActorID, @UserID)

DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows
DECLARE @Users TABLE
(
	ItemPosition int IDENTITY(1,1),
	UserID int,
	DomainID int
)
INSERT INTO @Users (UserID, DomainID)
SELECT
	U.UserID,
	D.DomainID
FROM Users AS U
INNER JOIN UsersTree(@UserID, 1) AS UT ON U.UserID = UT.UserID
LEFT OUTER JOIN Packages AS P ON U.UserID = P.UserID
LEFT OUTER JOIN Domains AS D ON P.PackageID = D.PackageID
WHERE
	U.UserID <> @UserID AND U.IsPeer = 0
	AND @HasUserRights = 1 '

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(UserID) FROM @Users;
SELECT
	U.UserID,
	U.RoleID,
	U.StatusID,
	U.SubscriberNumber,
	U.LoginStatusId,
	U.FailedLogins,
	U.OwnerID,
	U.Created,
	U.Changed,
	U.IsDemo,
	U.Comments,
	U.IsPeer,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	D.DomainName
FROM @Users AS TU
INNER JOIN Users AS U ON TU.UserID = U.UserID
LEFT OUTER JOIN Domains AS D ON TU.DomainID = D.DomainID
WHERE TU.ItemPosition BETWEEN @StartRow AND @EndRow'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @UserID int, @FilterValue nvarchar(50), @ActorID int',
@StartRow, @MaximumRows, @UserID, @FilterValue, @ActorID


RETURN
GO












ALTER PROCEDURE [dbo].[GetUserParents]
(
	@ActorID int,
	@UserID int
)
AS

-- check rights
IF dbo.CheckActorUserRights(@ActorID, @UserID) = 0
RAISERROR('You are not allowed to access this account', 16, 1)

SELECT
	U.UserID,
	U.RoleID,
	U.StatusID,
	U.SubscriberNumber,
	U.LoginStatusId,
	U.FailedLogins,
	U.OwnerID,
	U.Created,
	U.Changed,
	U.IsDemo,
	U.Comments,
	U.IsPeer,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	U.CompanyName,
	U.EcommerceEnabled
FROM UserParents(@ActorID, @UserID) AS UP
INNER JOIN Users AS U ON UP.UserID = U.UserID
ORDER BY UP.UserOrder DESC
RETURN 
GO













ALTER PROCEDURE [dbo].[GetUserPeers]
(
	@ActorID int,
	@UserID int
)
AS

DECLARE @CanGetDetails bit
SET @CanGetDetails = dbo.CanGetUserDetails(@ActorID, @UserID)

SELECT
	U.UserID,
	U.RoleID,
	U.StatusID,
	U.LoginStatusId,
	U.FailedLogins,
	U.OwnerID,
	U.Created,
	U.Changed,
	U.IsDemo,
	U.Comments,
	U.IsPeer,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	U.FullName,
	(U.FirstName + ' ' + U.LastName) AS FullName,
	U.CompanyName,
	U.EcommerceEnabled
FROM UsersDetailed AS U
WHERE U.OwnerID = @UserID AND IsPeer = 1
AND @CanGetDetails = 1 -- actor rights

RETURN 
GO














ALTER PROCEDURE [dbo].[GetUsers]
(
	@ActorID int,
	@OwnerID int,
	@Recursive bit = 0
)
AS

DECLARE @CanGetDetails bit
SET @CanGetDetails = dbo.CanGetUserDetails(@ActorID, @OwnerID)

SELECT
	U.UserID,
	U.RoleID,
	U.StatusID,
	U.SubscriberNumber,
	U.LoginStatusId,
	U.FailedLogins,
	U.OwnerID,
	U.Created,
	U.Changed,
	U.IsDemo,
	U.Comments,
	U.IsPeer,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	U.FullName,
	U.OwnerUsername,
	U.OwnerFirstName,
	U.OwnerLastName,
	U.OwnerRoleID,
	U.OwnerFullName,
	U.PackagesNumber,
	U.CompanyName,
	U.EcommerceEnabled
FROM UsersDetailed AS U
WHERE U.UserID <> @OwnerID AND
((@Recursive = 1 AND dbo.CheckUserParent(@OwnerID, U.UserID) = 1) OR 
(@Recursive = 0 AND U.OwnerID = @OwnerID))
AND U.IsPeer = 0
AND @CanGetDetails = 1 -- actor user rights

RETURN 
GO










ALTER PROCEDURE [dbo].[GetUsersPaged]
(
	@ActorID int,
	@UserID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@StatusID int,
	@RoleID int,
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int,
	@Recursive bit
)
AS
-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

SET @sql = '

DECLARE @HasUserRights bit
SET @HasUserRights = dbo.CheckActorUserRights(@ActorID, @UserID)

DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows
DECLARE @Users TABLE
(
	ItemPosition int IDENTITY(0,1),
	UserID int
)
INSERT INTO @Users (UserID)
SELECT
	U.UserID
FROM UsersDetailed AS U
WHERE 
	U.UserID <> @UserID AND U.IsPeer = 0 AND
	(
		(@Recursive = 0 AND OwnerID = @UserID) OR
		(@Recursive = 1 AND dbo.CheckUserParent(@UserID, U.UserID) = 1)
	)
	AND ((@StatusID = 0) OR (@StatusID > 0 AND U.StatusID = @StatusID))
	AND ((@RoleID = 0) OR (@RoleID > 0 AND U.RoleID = @RoleID))
	AND @HasUserRights = 1 '

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(UserID) FROM @Users;
SELECT
	U.UserID,
	U.RoleID,
	U.StatusID,
	U.SubscriberNumber,
	U.LoginStatusId,
	U.FailedLogins,
	U.OwnerID,
	U.Created,
	U.Changed,
	U.IsDemo,
	dbo.GetItemComments(U.UserID, ''USER'', @ActorID) AS Comments,
	U.IsPeer,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	U.FullName,
	U.OwnerUsername,
	U.OwnerFirstName,
	U.OwnerLastName,
	U.OwnerRoleID,
	U.OwnerFullName,
	U.OwnerEmail,
	U.PackagesNumber,
	U.CompanyName,
	U.EcommerceEnabled
FROM @Users AS TU
INNER JOIN UsersDetailed AS U ON TU.UserID = U.UserID
WHERE TU.ItemPosition BETWEEN @StartRow AND @EndRow'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @UserID int, @FilterValue nvarchar(50), @ActorID int, @Recursive bit, @StatusID int, @RoleID int',
@StartRow, @MaximumRows, @UserID, @FilterValue, @ActorID, @Recursive, @StatusID, @RoleID


RETURN
GO








ALTER PROCEDURE [dbo].[UpdateUser]
(
	@ActorID int,
	@UserID int,
	@RoleID int,
	@StatusID int,
	@SubscriberNumber nvarchar(32),
	@LoginStatusId int,
	@IsDemo bit,
	@IsPeer bit,
	@Comments ntext,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Email nvarchar(255),
	@SecondaryEmail nvarchar(255),
	@Address nvarchar(200),
	@City nvarchar(50),
	@State nvarchar(50),
	@Country nvarchar(50),
	@Zip varchar(20),
	@PrimaryPhone varchar(30),
	@SecondaryPhone varchar(30),
	@Fax varchar(30),
	@InstantMessenger nvarchar(200),
	@HtmlMail bit,
	@CompanyName nvarchar(100),
	@EcommerceEnabled BIT,
	@AdditionalParams NVARCHAR(max)
)
AS

	-- check actor rights
	IF dbo.CanUpdateUserDetails(@ActorID, @UserID) = 0
	BEGIN
		RETURN
	END

	IF @LoginStatusId = 0
	BEGIN
		UPDATE Users SET 
			FailedLogins = 0
		WHERE UserID = @UserID
	END

	UPDATE Users SET 
		RoleID = @RoleID,
		StatusID = @StatusID,
		SubscriberNumber = @SubscriberNumber,
		LoginStatusId = @LoginStatusId,
		Changed = GetDate(),
		IsDemo = @IsDemo,
		IsPeer = @IsPeer,
		Comments = @Comments,
		FirstName = @FirstName,
		LastName = @LastName,
		Email = @Email,
		SecondaryEmail = @SecondaryEmail,
		Address = @Address,
		City = @City,
		State = @State,
		Country = @Country,
		Zip = @Zip,
		PrimaryPhone = @PrimaryPhone,
		SecondaryPhone = @SecondaryPhone,
		Fax = @Fax,
		InstantMessenger = @InstantMessenger,
		HtmlMail = @HtmlMail,
		CompanyName = @CompanyName,
		EcommerceEnabled = @EcommerceEnabled,
		[AdditionalParams] = @AdditionalParams
	WHERE UserID = @UserID

	RETURN
GO








IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'UpdateUserFailedLoginAttempt')
BEGIN
EXEC sp_executesql N' CREATE PROCEDURE [dbo].[UpdateUserFailedLoginAttempt]
(
	@UserID int,
	@LockOut int,
	@Reset int
)
AS

IF (@Reset = 1)
BEGIN
	UPDATE Users SET FailedLogins = 0 WHERE UserID = @UserID
END
ELSE
BEGIN
	IF (@LockOut <= (SELECT FailedLogins FROM USERS WHERE UserID = @UserID))
	BEGIN
		UPDATE Users SET LoginStatusId = 2 WHERE UserID = @UserID
	END
	ELSE
	BEGIN
		IF ((SELECT FailedLogins FROM Users WHERE UserID = @UserID) IS NULL)
		BEGIN
			UPDATE Users SET FailedLogins = 1 WHERE UserID = @UserID
		END
		ELSE
			UPDATE Users SET FailedLogins = FailedLogins + 1 WHERE UserID = @UserID
	END
END'
END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'UpdateLyncUserPlan')
BEGIN
EXEC sp_executesql N' CREATE PROCEDURE [dbo].[UpdateLyncUserPlan] 
(
	@LyncUserPlanId int,
	@LyncUserPlanName	nvarchar(300),
	@LyncUserPlanType int,
	@IM bit,
	@Mobility bit,
	@MobilityEnableOutsideVoice bit,
	@Federation bit,
	@Conferencing bit,
	@EnterpriseVoice bit,
	@VoicePolicy int,
	@IsDefault bit
)
AS

UPDATE LyncUserPlans SET
	LyncUserPlanName = @LyncUserPlanName,
	LyncUserPlanType = @LyncUserPlanType,
	IM = @IM,
	Mobility = @Mobility,
	MobilityEnableOutsideVoice = @MobilityEnableOutsideVoice,
	Federation = @Federation,
	Conferencing =@Conferencing,
	EnterpriseVoice = @EnterpriseVoice,
	VoicePolicy = @VoicePolicy,
	IsDefault = @IsDefault
WHERE LyncUserPlanId = @LyncUserPlanId


RETURN'
END
GO

UPDATE [dbo].[Providers] SET [DisplayName] = 'MailEnable Server 1.x - 7.x' WHERE [DisplayName] = 'MailEnable Server 1.x - 4.x'
GO

UPDATE [dbo].[Providers] SET [DisplayName] = 'SmarterMail 7.x - 8.x' WHERE [DisplayName] = 'SmarterMail 7.x'
GO
UPDATE [dbo].[Providers] SET [DisplayName] = 'SmarterMail 10.x +' WHERE [DisplayName] = 'SmarterMail 10.x'
GO
UPDATE [dbo].[Providers] SET [DisplayName] = 'SmarterStats 5.x +' WHERE [DisplayName] = 'SmarterStats 5.x-6.x'
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'SmarterMail 10.x +')
BEGIN
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (66, 4, N'SmarterMail', N'SmarterMail 10.x +', N'WebsitePanel.Providers.Mail.SmarterMail10, WebsitePanel.Providers.Mail.SmarterMail10', N'SmarterMail60', NULL)
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (66, N'AdminPassword', N'')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (66, N'AdminUsername', N'admin')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (66, N'DomainsPath', N'%SYSTEMDRIVE%\SmarterMail')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (66, N'ServerIPAddress', N'127.0.0.1;127.0.0.1')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (66, N'ServiceUrl', N'http://localhost:9998/services/')
END
GO


ALTER PROCEDURE [dbo].[AddServiceItem]
(
	@ActorID int,
	@PackageID int,
	@ServiceID int,
	@ItemName nvarchar(500),
	@ItemTypeName nvarchar(200),
	@ItemID int OUTPUT,
	@XmlProperties ntext,
	@CreatedDate datetime
)
AS
BEGIN TRAN

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- get GroupID
DECLARE @GroupID int
SELECT
	@GroupID = PROV.GroupID
FROM Services AS S
INNER JOIN Providers AS PROV ON S.ProviderID = PROV.ProviderID
WHERE S.ServiceID = @ServiceID

DECLARE @ItemTypeID int
SELECT @ItemTypeID = ItemTypeID FROM ServiceItemTypes
WHERE TypeName = @ItemTypeName
AND ((@GroupID IS NULL) OR (@GroupID IS NOT NULL AND GroupID = @GroupID))

-- Fix to allow plans assigned to serveradmin
IF (@ItemTypeName = 'WebsitePanel.Providers.HostedSolution.Organization, WebsitePanel.Providers.Base')
BEGIN
	IF NOT EXISTS (SELECT * FROM ServiceItems WHERE PackageID = 1)
	BEGIN
		INSERT INTO ServiceItems (PackageID, ItemTypeID,ServiceID,ItemName,CreatedDate)
		VALUES(1, @ItemTypeID, @ServiceID, 'System',  @CreatedDate)
		
		DECLARE @TempItemID int
		
		SET @TempItemID = SCOPE_IDENTITY()
		INSERT INTO ExchangeOrganizations (ItemID, OrganizationID)
		VALUES(@TempItemID, 'System')
	END
END


-- add item
INSERT INTO ServiceItems
(
	PackageID,
	ServiceID,
	ItemName,
	ItemTypeID,
	CreatedDate
)
VALUES
(
	@PackageID,
	@ServiceID,
	@ItemName,
	@ItemTypeID,
	@CreatedDate
)

SET @ItemID = SCOPE_IDENTITY()

DECLARE @idoc int
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @idoc OUTPUT, @XmlProperties

-- Execute a SELECT statement that uses the OPENXML rowset provider.
DELETE FROM ServiceItemProperties
WHERE ItemID = @ItemID

INSERT INTO ServiceItemProperties
(
	ItemID,
	PropertyName,
	PropertyValue
)
SELECT
	@ItemID,
	PropertyName,
	PropertyValue
FROM OPENXML(@idoc, '/properties/property',1) WITH 
(
	PropertyName nvarchar(50) '@name',
	PropertyValue nvarchar(3000) '@value'
) as PV

-- remove document
exec sp_xml_removedocument @idoc

COMMIT TRAN
RETURN 

GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetBlackBerryUsers')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[GetBlackBerryUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@Name nvarchar(400),
	@Email nvarchar(400),
	@StartRow int,
	@Count int	
)
AS

IF (@Name IS NULL)
BEGIN
	SET @Name = ''%''
END

IF (@Email IS NULL)
BEGIN
	SET @Email = ''%''
END

CREATE TABLE #TempBlackBerryUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300) NOT NULL,
	[DisplayName] [nvarchar](300) NOT NULL,
	[PrimaryEmailAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL	
)


IF (@SortColumn = ''DisplayName'')
BEGIN
	INSERT INTO 
		#TempBlackBerryUsers 
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		BlackBerryUsers bu 
	ON 
		ea.AccountID = bu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.DisplayName
END
ELSE
BEGIN
	INSERT INTO 
		#TempBlackBerryUsers
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		BlackBerryUsers bu 
	ON 
		ea.AccountID = bu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.PrimaryEmailAddress 
END

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempBlackBerryUsers 

IF (@SortDirection = ''ASC'')
BEGIN
	SELECT * FROM #TempBlackBerryUsers 
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF (@SortColumn = ''DisplayName'')
	BEGIN
		SELECT * FROM #TempBlackBerryUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #TempBlackBerryUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY PrimaryEmailAddress DESC
	END
	
END


DROP TABLE #TempBlackBerryUsers'
END
GO










ALTER PROCEDURE [dbo].[GetBlackBerryUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@Name nvarchar(400),
	@Email nvarchar(400),
	@StartRow int,
	@Count int	
)
AS

IF (@Name IS NULL)
BEGIN
	SET @Name = '%'
END

IF (@Email IS NULL)
BEGIN
	SET @Email = '%'
END

CREATE TABLE #TempBlackBerryUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300) NOT NULL,
	[DisplayName] [nvarchar](300) NOT NULL,
	[PrimaryEmailAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL	
)


IF (@SortColumn = 'DisplayName')
BEGIN
	INSERT INTO 
		#TempBlackBerryUsers 
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		BlackBerryUsers bu 
	ON 
		ea.AccountID = bu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.DisplayName
END
ELSE
BEGIN
	INSERT INTO 
		#TempBlackBerryUsers
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		BlackBerryUsers bu 
	ON 
		ea.AccountID = bu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.PrimaryEmailAddress 
END

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempBlackBerryUsers 

IF (@SortDirection = 'ASC')
BEGIN
	SELECT * FROM #TempBlackBerryUsers 
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF (@SortColumn = 'DisplayName')
	BEGIN
		SELECT * FROM #TempBlackBerryUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #TempBlackBerryUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY PrimaryEmailAddress DESC
	END
	
END


DROP TABLE #TempBlackBerryUsers
GO








IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeOrganizationDomains' AND COLS.name='DomainTypeID')
BEGIN
ALTER TABLE [dbo].[ExchangeOrganizationDomains] ADD
	[DomainTypeID] [int] NOT NULL CONSTRAINT DF_ExchangeOrganizationDomains_DomainTypeID DEFAULT 0
END
GO




ALTER PROCEDURE [dbo].[GetExchangeOrganizationDomains] 
(
	@ItemID int
)
AS
SELECT
	ED.DomainID,
	D.DomainName,
	ED.IsHost,
	ED.DomainTypeID
FROM
	ExchangeOrganizationDomains AS ED
INNER JOIN Domains AS D ON ED.DomainID = D.DomainID
WHERE ED.ItemID = @ItemID
RETURN

GO







IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'ChangeExchangeAcceptedDomainType')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].ChangeExchangeAcceptedDomainType 
(
	@ItemID int,
	@DomainID int,
	@DomainTypeID int
)
AS
UPDATE ExchangeOrganizationDomains
SET DomainTypeID=@DomainTypeID
WHERE ItemID=ItemID AND DomainID=@DomainID
RETURN'
END
GO










ALTER PROCEDURE [dbo].[GetPackages]
(
	@ActorID int,
	@UserID int
)
AS

SELECT
	P.PackageID,
	P.ParentPackageID,
	P.PackageName,
	P.StatusID,
	P.PurchaseDate,
	
	-- server
	ISNULL(P.ServerID, 0) AS ServerID,
	ISNULL(S.ServerName, 'None') AS ServerName,
	ISNULL(S.Comments, '') AS ServerComments,
	ISNULL(S.VirtualServer, 1) AS VirtualServer,
	
	-- hosting plan
	P.PlanID,
	HP.PlanName,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.RoleID,
	U.Email
FROM Packages AS P
INNER JOIN Users AS U ON P.UserID = U.UserID
INNER JOIN Servers AS S ON P.ServerID = S.ServerID
INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE
	P.UserID = @UserID	
RETURN
GO







ALTER PROCEDURE [dbo].[GetDomainsPaged]
(
	@ActorID int,
	@PackageID int,
	@ServerID int,
	@Recursive bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
SET NOCOUNT ON

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

IF @SortColumn = '' OR @SortColumn IS NULL
SET @SortColumn = 'DomainName'

SET @sql = '
DECLARE @Domains TABLE
(
	ItemPosition int IDENTITY(1,1),
	DomainID int
)
INSERT INTO @Domains (DomainID)
SELECT
	D.DomainID
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE (D.IsInstantAlias = 0 AND D.IsDomainPointer = 0) AND
		((@Recursive = 0 AND D.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, D.PackageID) = 1))
AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
'

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(DomainID) FROM @Domains;SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(WS.ItemID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(MD.ItemID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer,
	
	-- packages
	P.PackageName,
	
	-- server
	ISNULL(SRV.ServerID, 0) AS ServerID,
	ISNULL(SRV.ServerName, '''') AS ServerName,
	ISNULL(SRV.Comments, '''') AS ServerComments,
	ISNULL(SRV.VirtualServer, 0) AS VirtualServer,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Domains AS SD
INNER JOIN Domains AS D ON SD.DomainID = D.DomainID
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE SD.ItemPosition BETWEEN @StartRow + 1 AND @StartRow + @MaximumRows'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @PackageID int, @FilterValue nvarchar(50), @ServerID int, @Recursive bit',
@StartRow, @MaximumRows, @PackageID, @FilterValue, @ServerID, @Recursive


RETURN
GO






ALTER PROCEDURE [dbo].[DeleteServiceItem]
(
	@ActorID int,
	@ItemID int
)
AS

-- check rights
DECLARE @PackageID int
SELECT PackageID = @PackageID FROM ServiceItems
WHERE ItemID = @ItemID

IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

BEGIN TRAN

UPDATE Domains
SET ZoneItemID = NULL
WHERE ZoneItemID = @ItemID

DELETE FROM Domains
WHERE WebSiteID = @ItemID AND IsDomainPointer = 1

UPDATE Domains
SET WebSiteID = NULL
WHERE WebSiteID = @ItemID

UPDATE Domains
SET MailDomainID = NULL
WHERE MailDomainID = @ItemID

-- delete item comments
DELETE FROM Comments
WHERE ItemID = @ItemID AND ItemTypeID = 'SERVICE_ITEM'

-- delete item properties
DELETE FROM ServiceItemProperties
WHERE ItemID = @ItemID

-- delete external IP addresses
EXEC dbo.DeleteItemIPAddresses @ActorID, @ItemID

-- delete item
DELETE FROM ServiceItems
WHERE ItemID = @ItemID

COMMIT TRAN

RETURN 

GO










ALTER PROCEDURE [dbo].[GetOCSUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@Name nvarchar(400),
	@Email nvarchar(400),
	@StartRow int,
	@Count int	
)
AS

IF (@Name IS NULL)
BEGIN
	SET @Name = '%'
END

IF (@Email IS NULL)
BEGIN
	SET @Email = '%'
END

CREATE TABLE #TempOCSUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300)  NOT NULL,
	[DisplayName] [nvarchar](300)  NOT NULL,
	[InstanceID] [nvarchar](50)  NOT NULL,
	[PrimaryEmailAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL	
)


IF (@SortColumn = 'DisplayName')
BEGIN
	INSERT INTO 
		#TempOCSUsers 
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ou.InstanceID,
		ea.PrimaryEmailAddress,
		ea.SamAccountName		
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		OCSUsers ou 
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.DisplayName
END
ELSE
BEGIN
	INSERT INTO 
		#TempOCSUsers
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ou.InstanceID,
		ea.PrimaryEmailAddress,
		ea.SamAccountName		
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		OCSUsers ou 
	ON 
		ea.AccountID = ou.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.PrimaryEmailAddress 
END

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempOCSUsers 

IF (@SortDirection = 'ASC')
BEGIN
	SELECT * FROM #TempOCSUsers 
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF (@SortColumn = 'DisplayName')
	BEGIN
		SELECT * FROM #TempOCSUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #TempOCSUsers 
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY PrimaryEmailAddress DESC
	END
	
END


DROP TABLE #TempOCSUsers

GO






ALTER PROCEDURE [dbo].[GetCRMUsers]
(
	@ItemID int,
	@SortColumn nvarchar(40),
	@SortDirection nvarchar(20),
	@Name nvarchar(400),
	@Email nvarchar(400),
	@StartRow int,
	@Count int	
)
AS

IF (@Name IS NULL)
BEGIN
	SET @Name = '%'
END

IF (@Email IS NULL)
BEGIN
	SET @Email = '%'
END

CREATE TABLE #TempCRMUsers 
(	
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int],	
	[ItemID] [int] NOT NULL,
	[AccountName] [nvarchar](300) NOT NULL,
	[DisplayName] [nvarchar](300) NOT NULL,
	[PrimaryEmailAddress] [nvarchar](300) NULL,
	[SamAccountName] [nvarchar](100) NULL	
)


IF (@SortColumn = 'DisplayName')
BEGIN
	INSERT INTO 
		#TempCRMUsers
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		CRMUsers cu 
	ON 
		ea.AccountID = cu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.DisplayName
END
ELSE
BEGIN
	INSERT INTO 
		#TempCRMUsers
	SELECT 
		ea.AccountID,
		ea.ItemID,
		ea.AccountName,
		ea.DisplayName,
		ea.PrimaryEmailAddress,
		ea.SamAccountName 
	FROM 
		ExchangeAccounts ea 
	INNER JOIN 
		CRMUsers cu 
	ON 
		ea.AccountID = cu.AccountID
	WHERE 
		ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email	
	ORDER BY 
		ea.PrimaryEmailAddress 
END

DECLARE @RetCount int
SELECT @RetCount = COUNT(ID) FROM #TempCRMUsers

IF (@SortDirection = 'ASC')
BEGIN
	SELECT * FROM #TempCRMUsers
	WHERE ID > @StartRow AND ID <= (@StartRow + @Count) 
END
ELSE
BEGIN
	IF (@SortColumn = 'DisplayName')
	BEGIN
		SELECT * FROM #TempCRMUsers
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY DisplayName DESC
	END
	ELSE
	BEGIN
		SELECT * FROM #TempCRMUsers
			WHERE ID >@RetCount - @Count - @StartRow AND ID <= @RetCount- @StartRow  ORDER BY PrimaryEmailAddress DESC
	END
	
END



DROP TABLE #TempCRMUsers
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetDomainsByZoneID')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetDomainsByZoneID]
(
	@ActorID int,
	@ZoneID int
)
AS

SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(D.WebSiteID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(D.MailDomainID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	Z.ItemName AS ZoneName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
WHERE
	D.ZoneItemID = @ZoneID
	AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
RETURN'
END
GO
















/****** Object:  Table [dbo].[ExchangeOrganizations]    Extend Exchange Accounts with ExchangeMailboxPlanID ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeOrganizations' AND COLS.name='ExchangeMailboxPlanID')
BEGIN
ALTER TABLE [dbo].[ExchangeOrganizations] ADD [ExchangeMailboxPlanID] [int]
END
GO





/****** Object:  Table [dbo].[ExchangeOrganizations]    Extend Exchange Accounts with LyncUserPlanID ******/
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeOrganizations' AND COLS.name='LyncUserPlanID')
BEGIN
ALTER TABLE [dbo].[ExchangeOrganizations] ADD [LyncUserPlanID] [int]
END
GO








ALTER PROCEDURE [dbo].[SetOrganizationDefaultLyncUserPlan] 
(
	@ItemID int,
	@LyncUserPlanId int
)
AS

UPDATE ExchangeOrganizations SET
	LyncUserPlanID = @LyncUserPlanId
WHERE
	ItemID = @ItemID

RETURN
GO



ALTER PROCEDURE [dbo].[SetOrganizationDefaultExchangeMailboxPlan] 
(
	@ItemID int,
	@MailboxPlanId int
)
AS

UPDATE ExchangeOrganizations SET
	ExchangeMailboxPlanID = @MailboxPlanId
WHERE
	ItemID = @ItemID

RETURN
GO




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeOrganization')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeOrganization]
(
	@ItemID int
)
AS
SELECT
	ItemID,
	ExchangeMailboxPlanID,
	LyncUserPlanID
FROM
	ExchangeOrganizations
WHERE
	ItemID = @ItemID 
RETURN'
END
GO




IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Domains' AND COLS.name='DomainItemId')
BEGIN
ALTER TABLE [dbo].[Domains] ADD	[DomainItemId] [int] NULL

END
GO

IF (SELECT Count(*) FROM Domains WHERE DomainItemId IS NOT NULL) = 0
BEGIN
	CREATE TABLE #TempDomains
	(
		[PackageID] [int] NOT NULL,
		[ZoneItemID] [int] NULL,
		[DomainName] [nvarchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
		[HostingAllowed] [bit] NOT NULL,
		[WebSiteID] [int] NULL,
		[IsSubDomain] [bit] NOT NULL,
		[IsInstantAlias] [bit] NOT NULL,
		[IsDomainPointer] [bit] NOT NULL,
		[DomainItemID] [int] NULL,
	)

	UPDATE Domains SET DomainItemID = DomainID

	INSERT INTO #TempDomains SELECT PackageID,
	ZoneItemID,
	DomainName,
	HostingAllowed,
	WebSiteID,
	IsSubDomain,
	IsInstantAlias,
	IsDomainPointer,
	DomainItemID FROM Domains WHERE WebSiteID IS NOT NULL

	UPDATE Domains SET IsDomainPointer=0,WebSiteID=NULL, DomainItemID=NULL WHERE WebSiteID IS NOT NULL

	INSERT INTO Domains SELECT PackageID,
	ZoneItemID,
	DomainName,
	HostingAllowed,
	WebSiteID,
	NULL,
	0,
	IsInstantAlias,
	1,
	DomainItemID
	 FROM #TempDomains


	DROP TABLE #TempDomains
END
GO



IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Web.EnableHostNameSupport')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (334, 2, 23, N'Web.EnableHostNameSupport', N'Enable Hostname Support', 1, 0, NULL)
END
GO









IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetDomainsByDomainItemID')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetDomainsByDomainItemID]
(
	@ActorID int,
	@DomainID int
)
AS

SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(D.WebSiteID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(D.MailDomainID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	Z.ItemName AS ZoneName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
WHERE
	D.DomainItemID = @DomainID
	AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
RETURN'
END
GO





ALTER PROCEDURE [dbo].[UpdateDomain]
(
	@DomainID int,
	@ActorID int,
	@ZoneItemID int,
	@HostingAllowed bit,
	@WebSiteID int,
	@MailDomainID int,
	@DomainItemID int
)
AS

-- check rights
DECLARE @PackageID int
SELECT @PackageID = PackageID FROM Domains
WHERE DomainID = @DomainID

IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

IF @ZoneItemID = 0 SET @ZoneItemID = NULL
IF @WebSiteID = 0 SET @WebSiteID = NULL
IF @MailDomainID = 0 SET @MailDomainID = NULL

-- update record
UPDATE Domains
SET
	ZoneItemID = @ZoneItemID,
	HostingAllowed = @HostingAllowed,
	WebSiteID = @WebSiteID,
	MailDomainID = @MailDomainID,
	DomainItemID = @DomainItemID
WHERE
	DomainID = @DomainID
	RETURN
GO





ALTER PROCEDURE [dbo].[GetDnsRecordsTotal]
(
	@ActorID int,
	@PackageID int
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- create temp table for DNS records
DECLARE @Records TABLE
(
	RecordID int,
	RecordType nvarchar(10) COLLATE Latin1_General_CI_AS,
	RecordName nvarchar(50) COLLATE Latin1_General_CI_AS
)

-- select PACKAGES DNS records
DECLARE @ParentPackageID int, @TmpPackageID int
SET @TmpPackageID = @PackageID

WHILE 10 = 10
BEGIN

	-- get DNS records for the current package
	INSERT INTO @Records (RecordID, RecordType, RecordName)
	SELECT
		GR.RecordID,
		GR.RecordType,
		GR.RecordName
	FROM GlobalDNSRecords AS GR
	WHERE GR.PackageID = @TmpPackageID
	AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)

	SET @ParentPackageID = NULL

	-- get parent package
	SELECT
		@ParentPackageID = ParentPackageID
	FROM Packages
	WHERE PackageID = @TmpPackageID
	
	IF @ParentPackageID IS NULL -- the last parent
	BREAK
	
	SET @TmpPackageID = @ParentPackageID
END

-- select VIRTUAL SERVER DNS records
DECLARE @ServerID int
SELECT @ServerID = ServerID FROM Packages
WHERE PackageID = @PackageID

INSERT INTO @Records (RecordID, RecordType, RecordName)
SELECT
	GR.RecordID,
	GR.RecordType,
	GR.RecordName
FROM GlobalDNSRecords AS GR
WHERE GR.ServerID = @ServerID
AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)

-- select SERVER DNS records
INSERT INTO @Records (RecordID, RecordType, RecordName)
SELECT
	GR.RecordID,
	GR.RecordType,
	GR.RecordName
FROM GlobalDNSRecords AS GR
WHERE GR.ServerID IN (SELECT
	SRV.ServerID
FROM VirtualServices AS VS
INNER JOIN Services AS S ON VS.ServiceID = S.ServiceID
INNER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE VS.ServerID = @ServerID)
AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)





-- select SERVICES DNS records
-- re-distribute package services
EXEC DistributePackageServices @ActorID, @PackageID

--INSERT INTO @Records (RecordID, RecordType, RecordName)
--SELECT
--	GR.RecordID,
--	GR.RecordType,
	-- GR.RecordName
-- FROM GlobalDNSRecords AS GR
-- WHERE GR.ServiceID IN (SELECT ServiceID FROM PackageServices WHERE PackageID = @PackageID)
-- AND GR.RecordType + GR.RecordName NOT IN (SELECT RecordType + RecordName FROM @Records)


SELECT
	NR.RecordID,
	NR.ServiceID,
	NR.ServerID,
	NR.PackageID,
	NR.RecordType,
	NR.RecordName,
	NR.RecordData,
	NR.MXPriority,
	NR.SrvPriority,
	NR.SrvWeight,
	NR.SrvPort,	
	NR.IPAddressID,
	ISNULL(IP.ExternalIP, '') AS ExternalIP,
	ISNULL(IP.InternalIP, '') AS InternalIP,
	CASE
		WHEN NR.RecordType = 'A' AND NR.RecordData = '' THEN dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP)
		WHEN NR.RecordType = 'MX' THEN CONVERT(varchar(3), NR.MXPriority) + ', ' + NR.RecordData
		WHEN NR.RecordType = 'SRV' THEN CONVERT(varchar(3), NR.SrvPort) + ', ' + NR.RecordData
		ELSE NR.RecordData
	END AS FullRecordData,
	dbo.GetFullIPAddress(IP.ExternalIP, IP.InternalIP) AS IPAddress
FROM @Records AS TR
INNER JOIN GlobalDnsRecords AS NR ON TR.RecordID = NR.RecordID
LEFT OUTER JOIN IPAddresses AS IP ON NR.IPAddressID = IP.AddressID

RETURN
GO




ALTER PROCEDURE [dbo].[GetDomainByName]
(
	@ActorID int,
	@DomainName nvarchar(100),
	@SearchOnDomainPointer bit,
	@IsDomainPointer bit
)
AS

IF (@SearchOnDomainPointer = 1)
BEGIN
	SELECT
		D.DomainID,
		D.PackageID,
		D.ZoneItemID,
		D.DomainItemID,
		D.DomainName,
		D.HostingAllowed,
		ISNULL(D.WebSiteID, 0) AS WebSiteID,
		WS.ItemName AS WebSiteName,
		ISNULL(D.MailDomainID, 0) AS MailDomainID,
		MD.ItemName AS MailDomainName,
		Z.ItemName AS ZoneName,
		D.IsSubDomain,
		D.IsInstantAlias,
		D.IsDomainPointer
	FROM Domains AS D
	INNER JOIN Packages AS P ON D.PackageID = P.PackageID
	LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
	LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
	LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
	WHERE
		D.DomainName = @DomainName
		AND D.IsDomainPointer = @IsDomainPointer
		AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
	RETURN
END
ELSE
BEGIN
	SELECT
		D.DomainID,
		D.PackageID,
		D.ZoneItemID,
		D.DomainItemID,
		D.DomainName,
		D.HostingAllowed,
		ISNULL(D.WebSiteID, 0) AS WebSiteID,
		WS.ItemName AS WebSiteName,
		ISNULL(D.MailDomainID, 0) AS MailDomainID,
		MD.ItemName AS MailDomainName,
		Z.ItemName AS ZoneName,
		D.IsSubDomain,
		D.IsInstantAlias,
		D.IsDomainPointer
	FROM Domains AS D
	INNER JOIN Packages AS P ON D.PackageID = P.PackageID
	LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
	LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
	LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
	WHERE
		D.DomainName = @DomainName
		AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
	RETURN
END
GO



ALTER PROCEDURE [dbo].[GetDomain]
(
	@ActorID int,
	@DomainID int
)
AS

SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(WS.ItemID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(MD.ItemID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	Z.ItemName AS ZoneName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
WHERE
	D.DomainID = @DomainID
	AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
RETURN
GO




ALTER PROCEDURE [dbo].[GetDomains]
(
	@ActorID int,
	@PackageID int,
	@Recursive bit = 1
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(WS.ItemID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(MD.ItemID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	Z.ItemName AS ZoneName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON D.PackageID = PT.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
RETURN
GO




ALTER PROCEDURE [dbo].[GetDomainsByZoneID]
(
	@ActorID int,
	@ZoneID int
)
AS

SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(D.WebSiteID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(D.MailDomainID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	Z.ItemName AS ZoneName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
WHERE
	D.ZoneItemID = @ZoneID
	AND dbo.CheckActorPackageRights(@ActorID, P.PackageID) = 1
RETURN
GO




ALTER PROCEDURE [dbo].[GetDomainsPaged]
(
	@ActorID int,
	@PackageID int,
	@ServerID int,
	@Recursive bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
SET NOCOUNT ON

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

IF @SortColumn = '' OR @SortColumn IS NULL
SET @SortColumn = 'DomainName'

SET @sql = '
DECLARE @Domains TABLE
(
	ItemPosition int IDENTITY(1,1),
	DomainID int
)
INSERT INTO @Domains (DomainID)
SELECT
	D.DomainID
FROM Domains AS D
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE (D.IsInstantAlias = 0 AND D.IsDomainPointer = 0) AND
		((@Recursive = 0 AND D.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, D.PackageID) = 1))
AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
'

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(DomainID) FROM @Domains;SELECT
	D.DomainID,
	D.PackageID,
	D.ZoneItemID,
	D.DomainItemID,
	D.DomainName,
	D.HostingAllowed,
	ISNULL(WS.ItemID, 0) AS WebSiteID,
	WS.ItemName AS WebSiteName,
	ISNULL(MD.ItemID, 0) AS MailDomainID,
	MD.ItemName AS MailDomainName,
	D.IsSubDomain,
	D.IsInstantAlias,
	D.IsDomainPointer,
	
	-- packages
	P.PackageName,
	
	-- server
	ISNULL(SRV.ServerID, 0) AS ServerID,
	ISNULL(SRV.ServerName, '''') AS ServerName,
	ISNULL(SRV.Comments, '''') AS ServerComments,
	ISNULL(SRV.VirtualServer, 0) AS VirtualServer,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Domains AS SD
INNER JOIN Domains AS D ON SD.DomainID = D.DomainID
INNER JOIN Packages AS P ON D.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
WHERE SD.ItemPosition BETWEEN @StartRow + 1 AND @StartRow + @MaximumRows'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @PackageID int, @FilterValue nvarchar(50), @ServerID int, @Recursive bit',
@StartRow, @MaximumRows, @PackageID, @FilterValue, @ServerID, @Recursive


RETURN
GO



IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [ParameterID] = 'LYNC_REPORT')
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_HOSTED_SOLUTION_REPORT', N'LYNC_REPORT', N'Boolean', N'true', 5)
END
GO



ALTER PROCEDURE [dbo].[GetItemIdByOrganizationId] 	
	@OrganizationId nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT 
		ItemID
	FROM 
		dbo.ExchangeOrganizations
	WHERE 
		OrganizationId = @OrganizationId
END
GO






ALTER PROCEDURE [dbo].[SearchServiceItemsPaged]
(
	@ActorID int,
	@UserID int,
	@ItemTypeID int,
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS


-- check rights
IF dbo.CheckActorUserRights(@ActorID, @UserID) = 0
RAISERROR('You are not allowed to access this account', 16, 1)

-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

IF @ItemTypeID <> 13
BEGIN
	SET @sql = '
	DECLARE @EndRow int
	SET @EndRow = @StartRow + @MaximumRows
	DECLARE @Items TABLE
	(
		ItemPosition int IDENTITY(1,1),
		ItemID int
	)
	INSERT INTO @Items (ItemID)
	SELECT
		SI.ItemID
	FROM ServiceItems AS SI
	INNER JOIN Packages AS P ON P.PackageID = SI.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE
		dbo.CheckUserParent(@UserID, P.UserID) = 1
		AND SI.ItemTypeID = @ItemTypeID
	'

	IF @FilterValue <> ''
	SET @sql = @sql + ' AND SI.ItemName LIKE @FilterValue '

	IF @SortColumn = '' OR @SortColumn IS NULL
	SET @SortColumn = 'ItemName'

	SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

	SET @sql = @sql + ' SELECT COUNT(ItemID) FROM @Items;
	SELECT
		
		SI.ItemID,
		SI.ItemName,

		P.PackageID,
		P.PackageName,
		P.StatusID,
		P.PurchaseDate,
		
		-- user
		P.UserID,
		U.Username,
		U.FirstName,
		U.LastName,
		U.FullName,
		U.RoleID,
		U.Email
	FROM @Items AS I
	INNER JOIN ServiceItems AS SI ON I.ItemID = SI.ItemID
	INNER JOIN Packages AS P ON SI.PackageID = P.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE I.ItemPosition BETWEEN @StartRow AND @EndRow'
END
ELSE
BEGIN

	SET @SortColumn = REPLACE(@SortColumn, 'ItemName', 'DomainName')
	
	SET @sql = '
	DECLARE @EndRow int
	SET @EndRow = @StartRow + @MaximumRows
	DECLARE @Items TABLE
	(
		ItemPosition int IDENTITY(1,1),
		ItemID int
	)
	INSERT INTO @Items (ItemID)
	SELECT
		D.DomainID
	FROM Domains AS D
	INNER JOIN Packages AS P ON P.PackageID = D.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE
		dbo.CheckUserParent(@UserID, P.UserID) = 1
	'

	IF @FilterValue <> ''
	SET @sql = @sql + ' AND D.DomainName LIKE @FilterValue '

	IF @SortColumn = '' OR @SortColumn IS NULL
	SET @SortColumn = 'DomainName'

	SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

	SET @sql = @sql + ' SELECT COUNT(ItemID) FROM @Items;
	SELECT
		
		D.DomainID AS ItemID,
		D.DomainName AS ItemName,

		P.PackageID,
		P.PackageName,
		P.StatusID,
		P.PurchaseDate,
		
		-- user
		P.UserID,
		U.Username,
		U.FirstName,
		U.LastName,
		U.FullName,
		U.RoleID,
		U.Email
	FROM @Items AS I
	INNER JOIN Domains AS D ON I.ItemID = D.DomainID
	INNER JOIN Packages AS P ON D.PackageID = P.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE I.ItemPosition BETWEEN @StartRow AND @EndRow AND D.IsDomainPointer=0'
END

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @UserID int, @FilterValue nvarchar(50), @ItemTypeID int, @ActorID int',
@StartRow, @MaximumRows, @UserID, @FilterValue, @ItemTypeID, @ActorID

RETURN
GO




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'LyncUserExists')
BEGIN
EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[LyncUserExists]
(
	@AccountID int,
	@SipAddress nvarchar(300),
	@Exists bit OUTPUT
)
AS

	SET @Exists = 0
	IF EXISTS(SELECT * FROM [dbo].[ExchangeAccountEmailAddresses] WHERE [EmailAddress] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [PrimaryEmailAddress] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [UserPrincipalName] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [AccountName] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[LyncUsers] WHERE [SipAddress] = @SipAddress)
		BEGIN
			SET @Exists = 1
		END
		

	RETURN'
END
GO




ALTER PROCEDURE [dbo].[LyncUserExists]
(
	@AccountID int,
	@SipAddress nvarchar(300),
	@Exists bit OUTPUT
)
AS

	SET @Exists = 0
	IF EXISTS(SELECT * FROM [dbo].[ExchangeAccountEmailAddresses] WHERE [EmailAddress] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [PrimaryEmailAddress] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [UserPrincipalName] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[ExchangeAccounts] WHERE [AccountName] = @SipAddress AND [AccountID] <> @AccountID)
		BEGIN
			SET @Exists = 1
		END
	ELSE IF EXISTS(SELECT * FROM [dbo].[LyncUsers] WHERE [SipAddress] = @SipAddress)
		BEGIN
			SET @Exists = 1
		END
		

	RETURN
GO





ALTER PROCEDURE [dbo].[AddLyncUser]	
	@AccountID int,
	@LyncUserPlanID int,
	@SipAddress nvarchar(300)
AS
INSERT INTO
	dbo.LyncUsers
	(AccountID,
	 LyncUserPlanID,
	 CreatedDate,
	 ModifiedDate,
	 SipAddress)
VALUES
(		
	@AccountID,
	@LyncUserPlanID,
	getdate(),
	getdate(),
	@SipAddress
)
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'UpdateLyncUser')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[UpdateLyncUser] 
(
	@AccountID int,
	@SipAddress nvarchar(300)
)
AS

UPDATE LyncUsers SET
	SipAddress = @SipAddress
WHERE
	AccountID = @AccountID

RETURN'
END
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'CheckDomainUsedByHostedOrganization')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[CheckDomainUsedByHostedOrganization] 
	@DomainName nvarchar(100),
	@Result int OUTPUT
AS
	SET @Result = 0
	IF EXISTS(SELECT 1 FROM ExchangeAccounts WHERE UserPrincipalName LIKE ''%@''+ @DomainName)
	BEGIN
		SET @Result = 1
	END
	ELSE
	IF EXISTS(SELECT 1 FROM ExchangeAccountEmailAddresses WHERE EmailAddress LIKE ''%@''+ @DomainName)
	BEGIN
		SET @Result = 1
	END
	ELSE
	IF EXISTS(SELECT 1 FROM LyncUsers WHERE SipAddress LIKE ''%@''+ @DomainName)
	BEGIN
		SET @Result = 1
	END
		
	RETURN @Result'
END
GO