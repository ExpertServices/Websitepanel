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


--- Fix on version 2.0
DELETE FROM HostingPlanQuotas WHERE QuotaID = 340
GO
DELETE FROM HostingPlanQuotas WHERE QuotaID = 341
GO
DELETE FROM HostingPlanQuotas WHERE QuotaID = 342
GO
DELETE FROM HostingPlanQuotas WHERE QuotaID = 343
GO
DELETE FROM HostingPlanResources WHERE GroupID = 33
GO


-- Version 2.1 section
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted Microsoft Exchange Server 2013')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES(91, 12, N'Exchange2013', N'Hosted Microsoft Exchange Server 2013', N'WebsitePanel.Providers.HostedSolution.Exchange2013, WebsitePanel.Providers.HostedSolution.Exchange2013', N'Exchange',	1)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL WHERE [DisplayName] = 'Hosted Microsoft Exchange Server 2013'
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.AllowLitigationHold')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (420, 12, 24,N'Exchange2007.AllowLitigationHold',N'Allow Litigation Hold',1, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2007.RecoverableItemsSpace')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (421, 12, 25,N'Exchange2007.RecoverableItemsSpace',N'Recoverable Items Space',2, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'HeliconZoo')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (42, N'HeliconZoo', 2, N'WebsitePanel.EnterpriseServer.HeliconZooController', 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [ProviderName] = 'HeliconZoo')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (135, 42, N'HeliconZoo', N'Web Application Engines', N'WebsitePanel.Providers.Web.HeliconZoo.HeliconZoo, WebsitePanel.Providers.Web.HeliconZoo', N'HeliconZoo', NULL)
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='AllowLitigationHold')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
	[AllowLitigationHold] [bit] NULL,
	[RecoverableItemsWarningPct] [int] NULL,
	[RecoverableItemsSpace] [int] NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='LitigationHoldUrl')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
	[LitigationHoldUrl] [nvarchar] (256) COLLATE Latin1_General_CI_AS NULL,
	[LitigationHoldMsg] [nvarchar] (512) COLLATE Latin1_General_CI_AS NULL
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
	@MailboxPlanType int,
	@AllowLitigationHold bit,
	@RecoverableItemsWarningPct int,
	@RecoverableItemsSpace int,
	@LitigationHoldUrl nvarchar(256),
	@LitigationHoldMsg nvarchar(512)
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
	MailboxPlanType,
	AllowLitigationHold,
	RecoverableItemsWarningPct,
	RecoverableItemsSpace,
	LitigationHoldUrl,
	LitigationHoldMsg

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
	@MailboxPlanType,
	@AllowLitigationHold,
	@RecoverableItemsWarningPct,
	@RecoverableItemsSpace,
	@LitigationHoldUrl,
	@LitigationHoldMsg
)

SET @MailboxPlanId = SCOPE_IDENTITY()

RETURN

GO








ALTER PROCEDURE [dbo].[UpdateExchangeMailboxPlan] 
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
	@MailboxPlanType int,
	@AllowLitigationHold bit,
	@RecoverableItemsWarningPct int,
	@RecoverableItemsSpace int,
	@LitigationHoldUrl nvarchar(256),
	@LitigationHoldMsg nvarchar(512)
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
	MailboxPlanType = @MailboxPlanType,
	AllowLitigationHold = @AllowLitigationHold,
	RecoverableItemsWarningPct = @RecoverableItemsWarningPct,
	RecoverableItemsSpace = @RecoverableItemsSpace, 
	LitigationHoldUrl = @LitigationHoldUrl,
	LitigationHoldMsg = @LitigationHoldMsg

WHERE MailboxPlanId = @MailboxPlanId

RETURN
	
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
	MailboxPlanType,
	AllowLitigationHold,
	RecoverableItemsWarningPct,
	RecoverableItemsSpace,
	LitigationHoldUrl,
	LitigationHoldMsg
FROM
	ExchangeMailboxPlans
WHERE
	MailboxPlanId = @MailboxPlanId
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
	(SELECT MIN(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace,
	(SELECT MIN(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace	
END
ELSE
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1 OR AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT SUM(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace,
	(SELECT SUM(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace	
END


RETURN
GO


-- 	UPDATE Domains SET IsDomainPointer=0, DomainItemID=NULL WHERE MailDomainID IS NOT NULL AND isDomainPointer=1


ALTER PROCEDURE [dbo].[GetPackageQuotas]
(
	@ActorID int,
	@PackageID int
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

DECLARE @PlanID int, @ParentPackageID int
SELECT @PlanID = PlanID, @ParentPackageID = ParentPackageID FROM Packages
WHERE PackageID = @PackageID

-- get resource groups
SELECT
	RG.GroupID,
	RG.GroupName,
	ISNULL(HPR.CalculateDiskSpace, 0) AS CalculateDiskSpace,
	ISNULL(HPR.CalculateBandwidth, 0) AS CalculateBandwidth,
	dbo.GetPackageAllocatedResource(@ParentPackageID, RG.GroupID, 0) AS ParentEnabled
FROM ResourceGroups AS RG
LEFT OUTER JOIN HostingPlanResources AS HPR ON RG.GroupID = HPR.GroupID AND HPR.PlanID = @PlanID
WHERE dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, 0) = 1
ORDER BY RG.GroupOrder


-- return quotas
SELECT
	Q.QuotaID,
	Q.GroupID,
	Q.QuotaName,
	Q.QuotaDescription,
	Q.QuotaTypeID,
	dbo.GetPackageAllocatedQuota(@PackageID, Q.QuotaID) AS QuotaValue,
	dbo.GetPackageAllocatedQuota(@ParentPackageID, Q.QuotaID) AS ParentQuotaValue,
	ISNULL(dbo.CalculateQuotaUsage(@PackageID, Q.QuotaID), 0) AS QuotaUsedValue
FROM Quotas AS Q
WHERE Q.HideQuota IS NULL OR Q.HideQuota = 0
ORDER BY Q.QuotaOrder
RETURN

GO







ALTER PROCEDURE [dbo].[UpdateServiceProperties]
(
	@ServiceID int,
	@Xml ntext
)
AS

-- delete old properties
BEGIN TRAN
DECLARE @idoc int
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @idoc OUTPUT, @xml

-- Execute a SELECT statement that uses the OPENXML rowset provider.
DELETE FROM ServiceProperties
WHERE ServiceID = @ServiceID 
AND PropertyName COLLATE Latin1_General_CI_AS IN
(
	SELECT PropertyName
	FROM OPENXML(@idoc, '/properties/property', 1)
	WITH (PropertyName nvarchar(50) '@name')
)

INSERT INTO ServiceProperties
(
	ServiceID,
	PropertyName,
	PropertyValue
)
SELECT
	@ServiceID,
	PropertyName,
	PropertyValue
FROM OPENXML(@idoc, '/properties/property',1) WITH 
(
	PropertyName nvarchar(50) '@name',
	PropertyValue nvarchar(1000) '@value'
) as PV

-- remove document
exec sp_xml_removedocument @idoc

COMMIT TRAN
RETURN 
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted MS CRM 2011')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (1201, 21, N'CRM', N'Hosted MS CRM 2011', N'WebsitePanel.Providers.HostedSolution.CRMProvider2011, WebsitePanel.Providers.HostedSolution.CRM2011', N'CRM', NULL)
END
GO


UPDATE Providers SET ProviderType = N'WebsitePanel.Providers.HostedSolution.CRMProvider2011, WebsitePanel.Providers.HostedSolution.CRM2011' WHERE ProviderID = 1201
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted SharePoint Foundation 2013')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery])
VALUES (1301, 20, N'HostedSharePoint2013', N'Hosted SharePoint Foundation 2013', N'WebsitePanel.Providers.HostedSolution.HostedSharePointServer2013, WebsitePanel.Providers.HostedSolution.SharePoint2013', N'HostedSharePoint30', NULL)
END
GO

UPDATE Providers SET ProviderType = N'WebsitePanel.Providers.HostedSolution.HostedSharePointServer2013, WebsitePanel.Providers.HostedSolution.SharePoint2013' WHERE ProviderID = 1301
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [ProviderName] = 'Lync2013')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery])
VALUES (1401, 41, N'Lync2013', N'Microsoft Lync Server 2013 Multitenant Hosting Pack', N'WebsitePanel.Providers.HostedSolution.Lync2013, WebsitePanel.Providers.HostedSolution.Lync2013', N'Lync', NULL)
END
GO

UPDATE Providers SET DisplayName = N'Microsoft Lync Server 2013 Enterprise Edition' WHERE ProviderID = 1401
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [ProviderName] = 'Lync2013HP')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery])
VALUES (1402, 41, N'Lync2013HP', N'Microsoft Lync Server 2013 Multitenant Hosting Pack', N'WebsitePanel.Providers.HostedSolution.Lync2013HP, WebsitePanel.Providers.HostedSolution.Lync2013HP', N'Lync', NULL)
END
GO


-- add Application Pools Restart Quota

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE ([QuotaName] = N'Web.AppPoolsRestart'))
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (411, 2, 13, N'Web.AppPoolsRestart', N'Application Pools Restart', 1, 0, NULL, NULL)
END
GO
-------------------------------- Scheduler Service------------------------------------------------------

IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'Schedule' 
           AND  COLUMN_NAME = 'LastFinish')
ALTER TABLE Schedule
DROP COLUMN LastFinish
GO

ALTER PROCEDURE [dbo].[GetSchedule]
(
	@ActorID int,
	@ScheduleID int
)
AS

-- select schedule
SELECT TOP 1
	S.ScheduleID,
	S.TaskID,
	S.PackageID,
	S.ScheduleName,
	S.ScheduleTypeID,
	S.Interval,
	S.FromTime,
	S.ToTime,
	S.StartTime,
	S.LastRun,
	S.NextRun,
	S.Enabled,
	S.HistoriesNumber,
	S.PriorityID,
	S.MaxExecutionTime,
	S.WeekMonthDay,
	1 AS StatusID
FROM Schedule AS S
WHERE
	S.ScheduleID = @ScheduleID
	AND dbo.CheckActorPackageRights(@ActorID, S.PackageID) = 1

-- select task
SELECT
	ST.TaskID,
	ST.TaskType,
	ST.RoleID
FROM Schedule AS S
INNER JOIN ScheduleTasks AS ST ON S.TaskID = ST.TaskID
WHERE
	S.ScheduleID = @ScheduleID
	AND dbo.CheckActorPackageRights(@ActorID, S.PackageID) = 1

-- select schedule parameters
SELECT
	S.ScheduleID,
	STP.ParameterID,
	STP.DataTypeID,
	ISNULL(SP.ParameterValue, STP.DefaultValue) AS ParameterValue
FROM Schedule AS S
INNER JOIN ScheduleTaskParameters AS STP ON S.TaskID = STP.TaskID
LEFT OUTER JOIN ScheduleParameters AS SP ON STP.ParameterID = SP.ParameterID AND SP.ScheduleID = S.ScheduleID
WHERE
	S.ScheduleID = @ScheduleID
	AND dbo.CheckActorPackageRights(@ActorID, S.PackageID) = 1

RETURN
GO

ALTER PROCEDURE [dbo].[GetScheduleInternal]
(
	@ScheduleID int
)
AS

-- select schedule
SELECT
	S.ScheduleID,
	S.TaskID,
	ST.TaskType,
	ST.RoleID,
	S.PackageID,
	S.ScheduleName,
	S.ScheduleTypeID,
	S.Interval,
	S.FromTime,
	S.ToTime,
	S.StartTime,
	S.LastRun,
	S.NextRun,
	S.Enabled,
	1 AS StatusID,
	S.PriorityID,
	S.HistoriesNumber,
	S.MaxExecutionTime,
	S.WeekMonthDay
FROM Schedule AS S
INNER JOIN ScheduleTasks AS ST ON S.TaskID = ST.TaskID
WHERE ScheduleID = @ScheduleID
RETURN
GO

ALTER PROCEDURE [dbo].[GetSchedules]
(
	@ActorID int,
	@PackageID int,
	@Recursive bit
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

DECLARE @Schedules TABLE
(
	ScheduleID int
)

INSERT INTO @Schedules (ScheduleID)
SELECT
	S.ScheduleID
FROM Schedule AS S
INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON S.PackageID = PT.PackageID
ORDER BY S.Enabled DESC, S.NextRun
	

-- select schedules
SELECT
	S.ScheduleID,
	S.TaskID,
	ST.TaskType,
	ST.RoleID,
	S.PackageID,
	S.ScheduleName,
	S.ScheduleTypeID,
	S.Interval,
	S.FromTime,
	S.ToTime,
	S.StartTime,
	S.LastRun,
	S.NextRun,
	S.Enabled,
	1 AS StatusID,
	S.PriorityID,
	S.MaxExecutionTime,
	S.WeekMonthDay,
	ISNULL(0, (SELECT TOP 1 SeverityID FROM AuditLog WHERE ItemID = S.ScheduleID AND SourceName = 'SCHEDULER' ORDER BY StartDate DESC)) AS LastResult,

	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Schedules AS STEMP
INNER JOIN Schedule AS S ON STEMP.ScheduleID = S.ScheduleID
INNER JOIN Packages AS P ON S.PackageID = P.PackageID
INNER JOIN ScheduleTasks AS ST ON S.TaskID = ST.TaskID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID

-- select schedule parameters
SELECT
	S.ScheduleID,
	STP.ParameterID,
	STP.DataTypeID,
	ISNULL(SP.ParameterValue, STP.DefaultValue) AS ParameterValue
FROM @Schedules AS STEMP
INNER JOIN Schedule AS S ON STEMP.ScheduleID = S.ScheduleID
INNER JOIN ScheduleTaskParameters AS STP ON S.TaskID = STP.TaskID
LEFT OUTER JOIN ScheduleParameters AS SP ON STP.ParameterID = SP.ParameterID AND SP.ScheduleID = S.ScheduleID
RETURN
GO

ALTER PROCEDURE [dbo].[GetSchedulesPaged]
(
	@ActorID int,
	@PackageID int,
	@Recursive bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
BEGIN

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

DECLARE @condition nvarchar(400)
SET @condition = ' 1 = 1 '

IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
AND @FilterValue <> '' AND @FilterValue IS NOT NULL
SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'S.ScheduleName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(S.ScheduleID) FROM Schedule AS S
INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON S.PackageID = PT.PackageID
INNER JOIN Packages AS P ON S.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
WHERE ' + @condition + '

DECLARE @Schedules AS TABLE
(
	ScheduleID int
);

WITH TempSchedules AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		S.ScheduleID
	FROM Schedule AS S
	INNER JOIN Packages AS P ON S.PackageID = P.PackageID
	INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON S.PackageID = PT.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE ' + @condition + '
)

INSERT INTO @Schedules
SELECT ScheduleID FROM TempSchedules
WHERE TempSchedules.Row BETWEEN @StartRow and @StartRow + @MaximumRows - 1

SELECT
	S.ScheduleID,
	S.TaskID,
	ST.TaskType,
	ST.RoleID,
	S.ScheduleName,
	S.ScheduleTypeID,
	S.Interval,
	S.FromTime,
	S.ToTime,
	S.StartTime,
	S.LastRun,
	S.NextRun,
	S.Enabled,
	1 AS StatusID,
	S.PriorityID,
	S.MaxExecutionTime,
	S.WeekMonthDay,
	ISNULL(0, (SELECT TOP 1 SeverityID FROM AuditLog WHERE ItemID = S.ScheduleID AND SourceName = ''SCHEDULER'' ORDER BY StartDate DESC)) AS LastResult,

	-- packages
	P.PackageID,
	P.PackageName,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Schedules AS STEMP
INNER JOIN Schedule AS S ON STEMP.ScheduleID = S.ScheduleID
INNER JOIN ScheduleTasks AS ST ON S.TaskID = ST.TaskID
INNER JOIN Packages AS P ON S.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID'

exec sp_executesql @sql, N'@PackageID int, @StartRow int, @MaximumRows int, @Recursive bit',
@PackageID, @StartRow, @MaximumRows, @Recursive

END
RETURN
GO

ALTER PROCEDURE [dbo].[UpdateSchedule]
(
	@ActorID int,
	@ScheduleID int,
	@TaskID nvarchar(100),
	@ScheduleName nvarchar(100),
	@ScheduleTypeID nvarchar(50),
	@Interval int,
	@FromTime datetime,
	@ToTime datetime,
	@StartTime datetime,
	@LastRun datetime,
	@NextRun datetime,
	@Enabled bit,
	@PriorityID nvarchar(50),
	@HistoriesNumber int,
	@MaxExecutionTime int,
	@WeekMonthDay int,
	@XmlParameters ntext
)
AS

-- check rights
DECLARE @PackageID int
SELECT @PackageID = PackageID FROM Schedule
WHERE ScheduleID = @ScheduleID

IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

BEGIN TRAN

UPDATE Schedule
SET
	TaskID = @TaskID,
	ScheduleName = @ScheduleName,
	ScheduleTypeID = @ScheduleTypeID,
	Interval = @Interval,
	FromTime = @FromTime,
	ToTime = @ToTime,
	StartTime = @StartTime,
	LastRun = @LastRun,
	NextRun = @NextRun,
	Enabled = @Enabled,
	PriorityID = @PriorityID,
	HistoriesNumber = @HistoriesNumber,
	MaxExecutionTime = @MaxExecutionTime,
	WeekMonthDay = @WeekMonthDay
WHERE
	ScheduleID = @ScheduleID
	
DECLARE @idoc int
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @idoc OUTPUT, @XmlParameters

-- Execute a SELECT statement that uses the OPENXML rowset provider.
DELETE FROM ScheduleParameters
WHERE ScheduleID = @ScheduleID

INSERT INTO ScheduleParameters
(
	ScheduleID,
	ParameterID,
	ParameterValue
)
SELECT
	@ScheduleID,
	ParameterID,
	ParameterValue
FROM OPENXML(@idoc, '/parameters/parameter',1) WITH 
(
	ParameterID nvarchar(50) '@id',
	ParameterValue nvarchar(3000) '@value'
) as PV

-- remove document
exec sp_xml_removedocument @idoc

COMMIT TRAN
RETURN
GO

UPDATE ScheduleTasks SET TaskType = RTRIM(TaskType) + '.Code'
WHERE SUBSTRING(RTRIM(TaskType), LEN(RTRIM(TaskType)) - 3, 4) <> 'Code'
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRunningSchedules')
DROP PROCEDURE GetRunningSchedules
GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'BackgroundTaskStack')
DROP TABLE BackgroundTaskStack
GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'BackgroundTaskLogs')
DROP TABLE BackgroundTaskLogs
GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'BackgroundTaskParameters')
DROP TABLE BackgroundTaskParameters
GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'BackgroundTasks')
DROP TABLE BackgroundTasks
GO

CREATE TABLE BackgroundTasks
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Guid UNIQUEIDENTIFIER NOT NULL,
	TaskID NVARCHAR(255),
	ScheduleID INT NOT NULL,
	PackageID INT NOT NULL,
	UserID INT NOT NULL,
	EffectiveUserID INT NOT NULL,
	TaskName NVARCHAR(255),
	ItemID INT,
	ItemName NVARCHAR(255),
	StartDate DATETIME NOT NULL,
	FinishDate DATETIME,
	IndicatorCurrent INT NOT NULL,
	IndicatorMaximum INT NOT NULL,
	MaximumExecutionTime INT NOT NULL,
	Source NVARCHAR(MAX),
	Severity INT NOT NULL,
	Completed BIT,
	NotifyOnComplete BIT,
	Status INT NOT NULL
)
GO

CREATE TABLE BackgroundTaskParameters
(
	ParameterID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TaskID INT NOT NULL,
	Name NVARCHAR(255),
	SerializerValue NTEXT,
	TypeName NVARCHAR(255),
	FOREIGN KEY (TaskID) REFERENCES BackgroundTasks (ID)
)
GO

CREATE TABLE BackgroundTaskLogs
(
	LogID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TaskID INT NOT NULL,
	Date DATETIME,
	ExceptionStackTrace NTEXT,
	InnerTaskStart INT,
	Severity INT,
	Text NTEXT,
	TextIdent INT,
	XmlParameters NTEXT,
	FOREIGN KEY (TaskID) REFERENCES BackgroundTasks (ID)
)
GO

CREATE TABLE BackgroundTaskStack
(
	TaskStackID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TaskID INT NOT NULL,
	FOREIGN KEY (TaskID) REFERENCES BackgroundTasks (ID)
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddBackgroundTask')
DROP PROCEDURE AddBackgroundTask
GO

CREATE PROCEDURE [dbo].[AddBackgroundTask]
(
	@BackgroundTaskID INT OUTPUT,
	@Guid UNIQUEIDENTIFIER,
	@TaskID NVARCHAR(255),
	@ScheduleID INT,
	@PackageID INT,
	@UserID INT,
	@EffectiveUserID INT,
	@TaskName NVARCHAR(255),
	@ItemID INT,
	@ItemName NVARCHAR(255),
	@StartDate DATETIME,
	@IndicatorCurrent INT,
	@IndicatorMaximum INT,
	@MaximumExecutionTime INT,
	@Source NVARCHAR(MAX),
	@Severity INT,
	@Completed BIT,
	@NotifyOnComplete BIT,
	@Status INT
)
AS

INSERT INTO BackgroundTasks
(
	Guid,
	TaskID,
	ScheduleID,
	PackageID,
	UserID,
	EffectiveUserID,
	TaskName,
	ItemID,
	ItemName,
	StartDate,
	IndicatorCurrent,
	IndicatorMaximum,
	MaximumExecutionTime,
	Source,
	Severity,
	Completed,
	NotifyOnComplete,
	Status
)
VALUES
(
	@Guid,
	@TaskID,
	@ScheduleID,
	@PackageID,
	@UserID,
	@EffectiveUserID,
	@TaskName,
	@ItemID,
	@ItemName,
	@StartDate,
	@IndicatorCurrent,
	@IndicatorMaximum,
	@MaximumExecutionTime,
	@Source,
	@Severity,
	@Completed,
	@NotifyOnComplete,
	@Status
)

SET @BackgroundTaskID = SCOPE_IDENTITY()

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetBackgroundTask')
DROP PROCEDURE GetBackgroundTask
GO

CREATE PROCEDURE [dbo].[GetBackgroundTask]
(
	@TaskID NVARCHAR(255)
)
AS

SELECT TOP 1
	T.ID,
	T.Guid,
	T.TaskID,
	T.ScheduleID,
	T.PackageID,
	T.UserID,
	T.EffectiveUserID,
	T.TaskName,
	T.ItemID,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
INNER JOIN BackgroundTaskStack AS TS
	ON TS.TaskId = T.ID
WHERE T.TaskID = @TaskID 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetBackgroundTasks')
DROP PROCEDURE GetBackgroundTasks
GO

CREATE PROCEDURE [dbo].[GetBackgroundTasks]
(
	@ActorID INT
)
AS

 with GetChildUsersId(id) as (
    select UserID
    from Users
    where UserID = @ActorID
    union all
    select C.UserId
    from GetChildUsersId P
    inner join Users C on P.id = C.OwnerID
)

SELECT 
	T.ID,
	T.Guid,
	T.TaskID,
	T.ScheduleId,
	T.PackageId,
	T.UserId,
	T.EffectiveUserId,
	T.TaskName,
	T.ItemId,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
INNER JOIN (SELECT T.Guid, MIN(T.StartDate) AS Date
			FROM BackgroundTasks AS T
			INNER JOIN BackgroundTaskStack AS TS
				ON TS.TaskId = T.ID
			WHERE T.UserID in (select id from GetChildUsersId)
			GROUP BY T.Guid) AS TT ON TT.Guid = T.Guid AND TT.Date = T.StartDate
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetThreadBackgroundTasks')
DROP PROCEDURE GetThreadBackgroundTasks
GO

CREATE PROCEDURE [dbo].GetThreadBackgroundTasks
(
	@Guid UNIQUEIDENTIFIER
)
AS

SELECT
	T.ID,
	T.Guid,
	T.TaskID,
	T.ScheduleId,
	T.PackageId,
	T.UserId,
	T.EffectiveUserId,
	T.TaskName,
	T.ItemId,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
INNER JOIN BackgroundTaskStack AS TS
	ON TS.TaskId = T.ID
WHERE T.Guid = @Guid
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetBackgroundTopTask')
DROP PROCEDURE GetBackgroundTopTask
GO

CREATE PROCEDURE [dbo].[GetBackgroundTopTask]
(
	@Guid UNIQUEIDENTIFIER
)
AS

SELECT TOP 1
	T.ID,
	T.Guid,
	T.TaskID,
	T.ScheduleId,
	T.PackageId,
	T.UserId,
	T.EffectiveUserId,
	T.TaskName,
	T.ItemId,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
INNER JOIN BackgroundTaskStack AS TS
	ON TS.TaskId = T.ID
WHERE T.Guid = @Guid
ORDER BY T.StartDate ASC
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddBackgroundTaskLog')
DROP PROCEDURE AddBackgroundTaskLog
GO

CREATE PROCEDURE [dbo].[AddBackgroundTaskLog]
(
	@TaskID INT,
	@Date DATETIME,
	@ExceptionStackTrace NTEXT,
	@InnerTaskStart INT,
	@Severity INT,
	@Text NTEXT,
	@TextIdent INT,
	@XmlParameters NTEXT
)
AS

INSERT INTO BackgroundTaskLogs
(
	TaskID,
	Date,
	ExceptionStackTrace,
	InnerTaskStart,
	Severity,
	Text,
	TextIdent,
	XmlParameters
)
VALUES
(
	@TaskID,
	@Date,
	@ExceptionStackTrace,
	@InnerTaskStart,
	@Severity,
	@Text,
	@TextIdent,
	@XmlParameters
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetBackgroundTaskLogs')
DROP PROCEDURE GetBackgroundTaskLogs
GO

CREATE PROCEDURE [dbo].[GetBackgroundTaskLogs]
(
	@TaskID INT,
	@StartLogTime DATETIME
)
AS

SELECT
	L.LogID,
	L.TaskID,
	L.Date,
	L.ExceptionStackTrace,
	L.InnerTaskStart,
	L.Severity,
	L.Text,
	L.XmlParameters
FROM BackgroundTaskLogs AS L
WHERE L.TaskID = @TaskID AND L.Date >= @StartLogTime
ORDER BY L.Date
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateBackgroundTask')
DROP PROCEDURE UpdateBackgroundTask
GO

CREATE PROCEDURE [dbo].[UpdateBackgroundTask]
(
	@Guid UNIQUEIDENTIFIER,
	@TaskID INT,
	@ScheduleID INT,
	@PackageID INT,
	@TaskName NVARCHAR(255),
	@ItemID INT,
	@ItemName NVARCHAR(255),
	@FinishDate DATETIME,
	@IndicatorCurrent INT,
	@IndicatorMaximum INT,
	@MaximumExecutionTime INT,
	@Source NVARCHAR(MAX),
	@Severity INT,
	@Completed BIT,
	@NotifyOnComplete BIT,
	@Status INT
)
AS

UPDATE BackgroundTasks
SET
	Guid = @Guid,
	ScheduleID = @ScheduleID,
	PackageID = @PackageID,
	TaskName = @TaskName,
	ItemID = @ItemID,
	ItemName = @ItemName,
	FinishDate = @FinishDate,
	IndicatorCurrent = @IndicatorCurrent,
	IndicatorMaximum = @IndicatorMaximum,
	MaximumExecutionTime = @MaximumExecutionTime,
	Source = @Source,
	Severity = @Severity,
	Completed = @Completed,
	NotifyOnComplete = @NotifyOnComplete,
	Status = @Status
WHERE ID = @TaskID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetBackgroundTaskParams')
DROP PROCEDURE GetBackgroundTaskParams
GO

CREATE PROCEDURE [dbo].[GetBackgroundTaskParams]
(
	@TaskID INT
)
AS

SELECT
	P.ParameterID,
	P.TaskID,
	P.Name,
	P.SerializerValue,
	P.TypeName
FROM BackgroundTaskParameters AS P
WHERE P.TaskID = @TaskID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddBackgroundTaskParam')
DROP PROCEDURE AddBackgroundTaskParam
GO

CREATE PROCEDURE [dbo].[AddBackgroundTaskParam]
(
	@TaskID INT,
	@Name NVARCHAR(255),
	@Value NTEXT,
	@TypeName NVARCHAR(255)
)
AS

INSERT INTO BackgroundTaskParameters
(
	TaskID,
	Name,
	SerializerValue,
	TypeName
)
VALUES
(
	@TaskID,
	@Name,
	@Value,
	@TypeName
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteBackgroundTaskParams')
DROP PROCEDURE DeleteBackgroundTaskParams
GO

CREATE PROCEDURE [dbo].[DeleteBackgroundTaskParams]
(
	@TaskID INT
)
AS

DELETE FROM BackgroundTaskParameters
WHERE TaskID = @TaskID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddBackgroundTaskStack')
DROP PROCEDURE AddBackgroundTaskStack
GO

CREATE PROCEDURE [dbo].[AddBackgroundTaskStack]
(
	@TaskID INT
)
AS

INSERT INTO BackgroundTaskStack
(
	TaskID
)
VALUES
(
	@TaskID
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteBackgroundTasks')
DROP PROCEDURE DeleteBackgroundTasks
GO

CREATE PROCEDURE [dbo].[DeleteBackgroundTasks]
(
	@Guid UNIQUEIDENTIFIER
)
AS

DELETE FROM BackgroundTaskStack
WHERE TaskID IN (SELECT ID FROM BackgroundTasks WHERE Guid = @Guid)

DELETE FROM BackgroundTaskLogs
WHERE TaskID IN (SELECT ID FROM BackgroundTasks WHERE Guid = @Guid)

DELETE FROM BackgroundTaskParameters
WHERE TaskID IN (SELECT ID FROM BackgroundTasks WHERE Guid = @Guid)

DELETE FROM BackgroundTasks
WHERE ID IN (SELECT ID FROM BackgroundTasks WHERE Guid = @Guid)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteBackgroundTask')
DROP PROCEDURE DeleteBackgroundTask
GO

CREATE PROCEDURE [dbo].[DeleteBackgroundTask]
(
	@ID INT
)
AS

DELETE FROM BackgroundTaskStack
WHERE TaskID = @ID

DELETE FROM BackgroundTaskLogs
WHERE TaskID = @ID

DELETE FROM BackgroundTaskParameters
WHERE TaskID = @ID

DELETE FROM BackgroundTasks
WHERE ID = @ID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetProcessBackgroundTasks')
DROP PROCEDURE GetProcessBackgroundTasks
GO

CREATE PROCEDURE [dbo].[GetProcessBackgroundTasks]
(	
	@Status INT
)
AS

SELECT
	T.ID,
	T.TaskID,
	T.ScheduleId,
	T.PackageId,
	T.UserId,
	T.EffectiveUserId,
	T.TaskName,
	T.ItemId,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
WHERE T.Completed = 0 AND T.Status = @Status
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetScheduleBackgroundTasks')
DROP PROCEDURE GetScheduleBackgroundTasks
GO

CREATE PROCEDURE [dbo].[GetScheduleBackgroundTasks]
(
	@ScheduleID INT
)
AS

SELECT
	T.ID,
	T.Guid,
	T.TaskID,
	T.ScheduleId,
	T.PackageId,
	T.UserId,
	T.EffectiveUserId,
	T.TaskName,
	T.ItemId,
	T.ItemName,
	T.StartDate,
	T.FinishDate,
	T.IndicatorCurrent,
	T.IndicatorMaximum,
	T.MaximumExecutionTime,
	T.Source,
	T.Severity,
	T.Completed,
	T.NotifyOnComplete,
	T.Status
FROM BackgroundTasks AS T
WHERE T.Guid = (
	SELECT Guid FROM BackgroundTasks
	WHERE ScheduleID = @ScheduleID
		AND Completed = 0 AND Status IN (1, 3))
GO

-- Disclaimers


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ExchangeDisclaimers')

CREATE TABLE [dbo].[ExchangeDisclaimers](
        [ExchangeDisclaimerId] [int] IDENTITY(1,1) NOT NULL,
        [ItemID] [int] NOT NULL,
        [DisclaimerName] [nvarchar](300) NOT NULL,
        [DisclaimerText] [nvarchar](1024),
 CONSTRAINT [PK_ExchangeDisclaimers] PRIMARY KEY CLUSTERED
(
        [ExchangeDisclaimerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetResourceGroupByName')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetResourceGroupByName]
(
	@GroupName nvarchar(100)
)
AS
SELECT
	RG.GroupID,
	RG.GroupOrder,
	RG.GroupName,
	RG.GroupController
FROM ResourceGroups AS RG
WHERE RG.GroupName = @GroupName

RETURN'
END

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeDisclaimers')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeDisclaimers]
(
	@ItemID int
)
AS
SELECT
	ExchangeDisclaimerId,
	ItemID,
	DisclaimerName,
	DisclaimerText
FROM
	ExchangeDisclaimers
WHERE
	ItemID = @ItemID 
ORDER BY DisclaimerName
RETURN'
END
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'DeleteExchangeDisclaimer')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[DeleteExchangeDisclaimer]
(
	@ExchangeDisclaimerId int
)
AS

DELETE FROM ExchangeDisclaimers
WHERE ExchangeDisclaimerId = @ExchangeDisclaimerId

RETURN'
END
GO

--

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'UpdateExchangeDisclaimer')
BEGIN
EXEC sp_executesql N' CREATE PROCEDURE [dbo].[UpdateExchangeDisclaimer] 
(
	@ExchangeDisclaimerId int,
	@DisclaimerName nvarchar(300),
	@DisclaimerText nvarchar(1024)
)
AS

UPDATE ExchangeDisclaimers SET
	DisclaimerName = @DisclaimerName,
	DisclaimerText = @DisclaimerText

WHERE ExchangeDisclaimerId = @ExchangeDisclaimerId

RETURN'
END
GO

--

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'AddExchangeDisclaimer')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[AddExchangeDisclaimer] 
(
	@ExchangeDisclaimerId int OUTPUT,
	@ItemID int,
	@DisclaimerName	nvarchar(300),
	@DisclaimerText	nvarchar(1024)
)
AS

INSERT INTO ExchangeDisclaimers
(
	ItemID,
	DisclaimerName,
	DisclaimerText
)
VALUES
(
	@ItemID,
	@DisclaimerName,
	@DisclaimerText
)

SET @ExchangeDisclaimerId = SCOPE_IDENTITY()

RETURN'
END
GO

--


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeDisclaimer')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeDisclaimer] 
(
	@ExchangeDisclaimerId int
)
AS
SELECT
	ExchangeDisclaimerId,
	ItemID,
	DisclaimerName,
	DisclaimerText
FROM
	ExchangeDisclaimers
WHERE
	ExchangeDisclaimerId = @ExchangeDisclaimerId
RETURN'
END
GO



IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='ExchangeDisclaimerId')
BEGIN

ALTER TABLE [dbo].[ExchangeAccounts] ADD

[ExchangeDisclaimerId] [int] NULL

END
Go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SetExchangeAccountDisclaimerId')
BEGIN
EXEC sp_executesql N' CREATE PROCEDURE [dbo].[SetExchangeAccountDisclaimerId] 
(
	@AccountID int,
	@ExchangeDisclaimerId int
)
AS
UPDATE ExchangeAccounts SET
	ExchangeDisclaimerId = @ExchangeDisclaimerId
WHERE AccountID = @AccountID

RETURN'
END
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'GetExchangeAccountDisclaimerId')
BEGIN
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[GetExchangeAccountDisclaimerId] 
(
	@AccountID int
)
AS
SELECT
	ExchangeDisclaimerId
FROM
	ExchangeAccounts
WHERE
	AccountID= @AccountID
RETURN'
END
GO


-- add Disclaimers Quota   
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE ([QuotaName] = N'Exchange2007.DisclaimersAllowed'))
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (422, 12, 26, N'Exchange2007.DisclaimersAllowed', N'Disclaimers Allowed', 1, 0, NULL, NULL)   
END
GO

--add SecurityGroupManagement Quota
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.SecurityGroupManagement')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (423, 13, 5, N'HostedSolution.SecurityGroupManagement', N'Allow Security Group Management', 1, 0, NULL, NULL)
END
GO  

-- Lync Enterprise Voice

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='LyncUserPlans' AND COLS.name='TelephonyVoicePolicy')
BEGIN
ALTER TABLE [dbo].[LyncUserPlans] ADD 

[RemoteUserAccess] [bit] NOT NULL DEFAULT 0,
[PublicIMConnectivity] [bit] NOT NULL  DEFAULT 0,

[AllowOrganizeMeetingsWithExternalAnonymous] [bit] NOT NULL DEFAULT 0,

[Telephony] [int] NULL,

[ServerURI] [nvarchar](300) NULL,

[ArchivePolicy] [nvarchar](300) NULL,
[TelephonyDialPlanPolicy] [nvarchar](300) NULL,
[TelephonyVoicePolicy] [nvarchar](300) NULL


END
Go

-- 

DROP PROCEDURE GetLyncUserPlan;

DROP PROCEDURE AddLyncUserPlan;

DROP PROCEDURE UpdateLyncUserPlan;

DROP PROCEDURE DeleteLyncUserPlan;

--

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

--

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
	@IsDefault bit,

	@RemoteUserAccess bit,
	@PublicIMConnectivity bit,

	@AllowOrganizeMeetingsWithExternalAnonymous bit,

	@Telephony int,

	@ServerURI nvarchar(300),
	
	@ArchivePolicy nvarchar(300),
	
	@TelephonyDialPlanPolicy nvarchar(300),
	@TelephonyVoicePolicy nvarchar(300)
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
	IsDefault = @IsDefault,

	RemoteUserAccess = @RemoteUserAccess,
	PublicIMConnectivity = @PublicIMConnectivity,

	AllowOrganizeMeetingsWithExternalAnonymous = @AllowOrganizeMeetingsWithExternalAnonymous,

	Telephony = @Telephony,

	ServerURI = @ServerURI,
	
	ArchivePolicy = @ArchivePolicy,
	TelephonyDialPlanPolicy = @TelephonyDialPlanPolicy,
	TelephonyVoicePolicy = @TelephonyVoicePolicy

WHERE LyncUserPlanId = @LyncUserPlanId


RETURN'
END
GO

--

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
	@IsDefault bit,

	@RemoteUserAccess bit,
	@PublicIMConnectivity bit,

	@AllowOrganizeMeetingsWithExternalAnonymous bit,

	@Telephony int,

	@ServerURI nvarchar(300),
	
	@ArchivePolicy  nvarchar(300),
	@TelephonyDialPlanPolicy nvarchar(300),
	@TelephonyVoicePolicy nvarchar(300)

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
	IsDefault,

	RemoteUserAccess,
	PublicIMConnectivity,

	AllowOrganizeMeetingsWithExternalAnonymous,

	Telephony,

	ServerURI,
	
	ArchivePolicy,
	TelephonyDialPlanPolicy,
	TelephonyVoicePolicy

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
	@IsDefault,

	@RemoteUserAccess,
	@PublicIMConnectivity,

	@AllowOrganizeMeetingsWithExternalAnonymous,

	@Telephony,

	@ServerURI,
	
	@ArchivePolicy,
	@TelephonyDialPlanPolicy,
	@TelephonyVoicePolicy

)

SET @LyncUserPlanId = SCOPE_IDENTITY()

RETURN'		
END
GO

--


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
	IsDefault,

	RemoteUserAccess,
	PublicIMConnectivity,

	AllowOrganizeMeetingsWithExternalAnonymous,

	Telephony,

	ServerURI,
	
	ArchivePolicy,
	TelephonyDialPlanPolicy,
	TelephonyVoicePolicy

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
	IsDefault,

	RemoteUserAccess,
	PublicIMConnectivity,

	AllowOrganizeMeetingsWithExternalAnonymous,

	Telephony,

	ServerURI,
	
	ArchivePolicy,
	TelephonyDialPlanPolicy,
	TelephonyVoicePolicy

FROM
	LyncUserPlans
WHERE
	LyncUserPlanId = @LyncUserPlanId
RETURN
GO

-- Lync Phone Numbers Quota

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE ([QuotaName] = N'Lync.PhoneNumbers'))
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (381, 41, 12, N'Lync.PhoneNumbers', N'Phone Numbers', 2, 0, NULL, NULL)
END
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
		ELSE IF @QuotaID = 381 -- Dedicated Lync Phone Numbers
			SET @Result = (SELECT COUNT(PIP.PackageAddressID) FROM PackageIPAddresses AS PIP
							INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
							INNER JOIN PackagesTreeCache AS PT ON PIP.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID AND IP.PoolID = 5)
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO

-- Enterprise Storage Provider
IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'EnterpriseStorage')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (44, N'EnterpriseStorage', 25, N'WebsitePanel.EnterpriseServer.EnterpriseStorageController', 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Enterprise Storage Windows 2012')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES(600, 44, N'EnterpriseStorage2012', N'Enterprise Storage Windows 2012', N'WebsitePanel.Providers.EnterpriseStorage.Windows2012, WebsitePanel.Providers.EnterpriseStorage.Windows2012', N'EnterpriseStorage',	1)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL WHERE [DisplayName] = 'Enterprise Storage Windows 2012'
END
GO

-- Enterprise Storage Quotas
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'EnterpriseStorage.DiskStorageSpace')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (430, 44, 1,N'EnterpriseStorage.DiskStorageSpace',N'Disk Storage Space (Mb)',2, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'EnterpriseStorage.Folders')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (431, 44, 1,N'EnterpriseStorage.Folders',N'Number of Root Folders',2, 0 , NULL)
END
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
	@IncludeSecurityGroups bit,
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
OR (@IncludeEquipment = 1 AND EA.AccountType = 6)
OR (@IncludeSecurityGroups = 1 AND EA.AccountType = 8))
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
    @IncludeDistributionLists int, @IncludeRooms bit, @IncludeEquipment bit, @IncludeSecurityGroups bit',
@ItemID, @IncludeMailboxes, @IncludeContacts, @IncludeDistributionLists, @IncludeRooms, @IncludeEquipment, @IncludeSecurityGroups

RETURN
GO


IF EXISTS (SELECT * FROM sys.objects WHERE type_desc = N'SQL_STORED_PROCEDURE' AND name = N'SearchExchangeAccountsByTypes')
DROP PROCEDURE [dbo].[SearchExchangeAccountsByTypes]
GO


CREATE PROCEDURE [dbo].[SearchExchangeAccountsByTypes]
(
	@ActorID int,
	@ItemID int,
	@AccountTypes nvarchar(30),
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

DECLARE @condition nvarchar(700)
SET @condition = 'EA.ItemID = @ItemID AND EA.AccountType IN (' + @AccountTypes + ')'

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

DECLARE @sql nvarchar(3500)
SET @sql = '
SELECT
	EA.AccountID,
	EA.ItemID,
	EA.AccountType,
	EA.AccountName,
	EA.DisplayName,
	EA.PrimaryEmailAddress,
	EA.MailEnabledPublicFolder,
	EA.MailboxPlanId,
	P.MailboxPlan, 
	EA.SubscriberNumber,
	EA.UserPrincipalName
FROM
	ExchangeAccounts  AS EA
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON EA.MailboxPlanId = P.MailboxPlanId
	WHERE ' + @condition
	+ ' ORDER BY ' + @SortColumn

EXEC sp_executesql @sql, N'@ItemID int', @ItemID

RETURN
GO

---- Additional Default Groups-------------

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'AdditionalGroups')
DROP TABLE AdditionalGroups
GO

CREATE TABLE AdditionalGroups
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID INT NOT NULL,
	GroupName NVARCHAR(255)
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetAdditionalGroups')
DROP PROCEDURE GetAdditionalGroups
GO

CREATE PROCEDURE [dbo].[GetAdditionalGroups]
(
	@UserID INT
)
AS

SELECT
	AG.ID,
	AG.UserID,
	AG.GroupName
FROM AdditionalGroups AS AG
WHERE AG.UserID = @UserID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddAdditionalGroup')
DROP PROCEDURE AddAdditionalGroup
GO

CREATE PROCEDURE [dbo].[AddAdditionalGroup]
(
	@GroupID INT OUTPUT,
	@UserID INT,
	@GroupName NVARCHAR(255)
)
AS

INSERT INTO AdditionalGroups
(
	UserID,
	GroupName
)
VALUES
(
	@UserID,
	@GroupName
)

SET @GroupID = SCOPE_IDENTITY()

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteAdditionalGroup')
DROP PROCEDURE DeleteAdditionalGroup
GO

CREATE PROCEDURE [dbo].[DeleteAdditionalGroup]
(
	@GroupID INT
)
AS

DELETE FROM AdditionalGroups
WHERE ID = @GroupID
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateAdditionalGroup')
DROP PROCEDURE UpdateAdditionalGroup
GO

CREATE PROCEDURE [dbo].[UpdateAdditionalGroup]
(
	@GroupID INT,
	@GroupName NVARCHAR(255)
)
AS

UPDATE AdditionalGroups SET
	GroupName = @GroupName
WHERE ID = @GroupID
GO



-- Remote Desktop Services

-- RDS ResourceGroup

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'RDS')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (45, N'RDS', 26, NULL, 1)
END
GO

-- RDS Quota

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'RDS.Users')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (450, 45, 1, N'RDS.Users',N'Remote Desktop Users',2, 0 , NULL)
END
GO

-- RDS Provider

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Remote Desktop Services Windows 2012')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) 
VALUES(1501, 45, N'RemoteDesktopServices2012', N'Remote Desktop Services Windows 2012', N'WebsitePanel.Providers.RemoteDesktopServices.Windows2012,WebsitePanel.Providers.RemoteDesktopServices.Windows2012', N'RDS',	1)
END
GO

-- Added phone numbers in the hosted organization.

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='PackageIPAddresses' AND COLS.name='OrgID')
BEGIN
ALTER TABLE [dbo].[PackageIPAddresses] ADD
	[OrgID] [int] NULL
END
GO

ALTER PROCEDURE [dbo].[AllocatePackageIPAddresses]
(
	@PackageID int,
	@OrgID int,
	@xml ntext
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @idoc int
	--Create an internal representation of the XML document.
	EXEC sp_xml_preparedocument @idoc OUTPUT, @xml

	-- delete
	DELETE FROM PackageIPAddresses
	FROM PackageIPAddresses AS PIP
	INNER JOIN OPENXML(@idoc, '/items/item', 1) WITH 
	(
		AddressID int '@id'
	) as PV ON PIP.AddressID = PV.AddressID


	-- insert
	INSERT INTO dbo.PackageIPAddresses
	(		
		PackageID,
		OrgID,
		AddressID	
	)
	SELECT		
		@PackageID,
		@OrgID,
		AddressID

	FROM OPENXML(@idoc, '/items/item', 1) WITH 
	(
		AddressID int '@id'
	) as PV

	-- remove document
	exec sp_xml_removedocument @idoc

END
GO

ALTER PROCEDURE [dbo].[GetPackageIPAddresses]
(
	@PackageID int,
	@OrgID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int,
	@PoolID int = 0,
	@Recursive bit = 0
)
AS
BEGIN


-- start
DECLARE @condition nvarchar(700)
SET @condition = '
((@Recursive = 0 AND PA.PackageID = @PackageID)
OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, PA.PackageID) = 1))
AND (@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
AND (@OrgID = 0 OR @OrgID <> 0 AND PA.OrgID = @OrgID)
'

IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
AND @FilterValue <> '' AND @FilterValue IS NOT NULL
SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'IP.ExternalIP ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(PA.PackageAddressID)
FROM dbo.PackageIPAddresses PA
INNER JOIN dbo.IPAddresses AS IP ON PA.AddressID = IP.AddressID
INNER JOIN dbo.Packages P ON PA.PackageID = P.PackageID
INNER JOIN dbo.Users U ON U.UserID = P.UserID
LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
WHERE ' + @condition + '

DECLARE @Addresses AS TABLE
(
	PackageAddressID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		PA.PackageAddressID
	FROM dbo.PackageIPAddresses PA
	INNER JOIN dbo.IPAddresses AS IP ON PA.AddressID = IP.AddressID
	INNER JOIN dbo.Packages P ON PA.PackageID = P.PackageID
	INNER JOIN dbo.Users U ON U.UserID = P.UserID
	LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
	WHERE ' + @condition + '
)

INSERT INTO @Addresses
SELECT PackageAddressID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	PA.PackageAddressID,
	PA.AddressID,
	IP.ExternalIP,
	IP.InternalIP,
	IP.SubnetMask,
	IP.DefaultGateway,
	PA.ItemID,
	SI.ItemName,
	PA.PackageID,
	P.PackageName,
	P.UserID,
	U.UserName,
	PA.IsPrimary
FROM @Addresses AS TA
INNER JOIN dbo.PackageIPAddresses AS PA ON TA.PackageAddressID = PA.PackageAddressID
INNER JOIN dbo.IPAddresses AS IP ON PA.AddressID = IP.AddressID
INNER JOIN dbo.Packages P ON PA.PackageID = P.PackageID
INNER JOIN dbo.Users U ON U.UserID = P.UserID
LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
'

print @sql

exec sp_executesql @sql, N'@PackageID int, @OrgID int, @StartRow int, @MaximumRows int, @Recursive bit, @PoolID int',
@PackageID, @OrgID, @StartRow, @MaximumRows, @Recursive, @PoolID

END
GO





ALTER PROCEDURE [dbo].[GetPackageUnassignedIPAddresses]
(
	@ActorID int,
	@PackageID int,
	@OrgID int,
	@PoolID int = 0
)
AS
BEGIN
	SELECT
		PIP.PackageAddressID,
		IP.AddressID,
		IP.ExternalIP,
		IP.InternalIP,
		IP.ServerID,
		IP.PoolID,
		PIP.IsPrimary,
		IP.SubnetMask,
		IP.DefaultGateway
	FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE
		PIP.ItemID IS NULL
		AND PIP.PackageID = @PackageID
		AND (@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
		AND (@OrgID = 0 OR @OrgID <> 0 AND PIP.OrgID = @OrgID)
		AND dbo.CheckActorPackageRights(@ActorID, PIP.PackageID) = 1
	ORDER BY IP.DefaultGateway, IP.ExternalIP
END
GO

-- CRM

UPDATE Providers SET EditorControl = 'CRM2011' Where ProviderID = 1201;
