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

-- registering MySQL 5.5 provider
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'MySQL Server 5.5')
BEGIN
	-- provider
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (301, 11, N'MySQL', N'MySQL Server 5.5', N'WebsitePanel.Providers.Database.MySqlServer55, WebsitePanel.Providers.Database.MySQL', N'MySQL', NULL)
	-- properties
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (301, N'ExternalAddress', N'localhost')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (301, N'InstallFolder', N'%PROGRAMFILES%\MySQL\MySQL Server 5.5')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (301, N'InternalAddress', N'localhost,3306')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (301, N'RootLogin', N'root')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (301, N'RootPassword', N'')
END
GO

-- registering SmarterMail 9.x provider
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'SmarterMail 9.x')
BEGIN
	-- provider
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (65, 4, N'SmarterMail', N'SmarterMail 9.x', N'WebsitePanel.Providers.Mail.SmarterMail9, WebsitePanel.Providers.Mail.SmarterMail9', N'SmarterMail60', NULL)
	-- properties
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (65, N'AdminPassword', N'')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (65, N'AdminUsername', N'admin')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (65, N'DomainsPath', N'%SYSTEMDRIVE%\SmarterMail')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (65, N'ServerIPAddress', N'127.0.0.1;127.0.0.1')
	INSERT [dbo].[ServiceDefaultProperties] ([ProviderID], [PropertyName], [PropertyValue]) VALUES (65, N'ServiceUrl', N'http://localhost:9998/services/')
END
GO