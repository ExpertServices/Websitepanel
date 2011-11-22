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