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
IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE GroupID = 33 AND [GroupName] = 'VPS2012')
BEGIN
DELETE FROM HostingPlanResources WHERE GroupID = 33
END
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

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ScheduleName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + '''
			OR FullName LIKE ''' + @FilterValue + '''
			OR Email LIKE ''' + @FilterValue + ''')'
END

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
--IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.SecurityGroupManagement')
--BEGIN
--INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (423, 13, 5, N'HostedSolution.SecurityGroupManagement', N'Allow Security Group Management', 1, 0, NULL, NULL)
--END
--GO  

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

-- RDS Quotas

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'RDS.Users')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (450, 45, 1, N'RDS.Users',N'Remote Desktop Users',2, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'RDS.Servers')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (451, 45, 2, N'RDS.Servers',N'Remote Desktop Servers',2, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'RDS.Collections')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (491, 45, 2, N'RDS.Collections',N'Remote Desktop Servers',2, 0 , NULL)
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

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ExternalIP LIKE ''' + @FilterValue + '''
			OR InternalIP LIKE ''' + @FilterValue + '''
			OR DefaultGateway LIKE ''' + @FilterValue + '''
			OR ItemName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + ''')'
END

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

-- DNS.2013

IF NOT EXISTS ( SELECT * FROM [dbo].[Providers] WHERE [ProviderID] = 410 )
BEGIN
	INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES
	(410, 7, N'MSDNS.2012', N'Microsoft DNS Server 2012+', N'WebsitePanel.Providers.DNS.MsDNS2012, WebsitePanel.Providers.DNS.MsDNS2012', N'MSDNS', NULL)
END
GO

-- CRM Provider fix

UPDATE Providers SET EditorControl = 'CRM2011' Where ProviderID = 1201;

-- CRM Quota

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM.MaxDatabaseSize')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (460, 21, 4, N'HostedCRM.MaxDatabaseSize', N'Max Database Size, MB',3, 0 , NULL)
END
GO

BEGIN
UPDATE [dbo].[Quotas] SET QuotaDescription = 'Full licenses per organization'  WHERE [QuotaName] = 'HostedCRM.Users'
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM.LimitedUsers')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (461, 21, 3, N'HostedCRM.LimitedUsers', N'Limited licenses per organization',3, 0 , NULL)
END
GO

-- CRM Users

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='CRMUsers' AND COLS.name='CALType')
BEGIN
ALTER TABLE [dbo].[CRMUsers] ADD
	[CALType] [int] NULL
END
GO

BEGIN
UPDATE [dbo].[CRMUsers]
   SET 
      CALType = 0 WHERE CALType IS NULL 
END
GO


ALTER PROCEDURE [dbo].[InsertCRMUser] 
(
	@ItemID int,
	@CrmUserID uniqueidentifier,
	@BusinessUnitID uniqueidentifier,
	@CALType int
)
AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO
	CRMUsers
(
	AccountID,
	CRMUserGuid,
	BusinessUnitID,
	CALType
)
VALUES 
(
	@ItemID, 
	@CrmUserID,
	@BusinessUnitID,
	@CALType
)
    
END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateCRMUser')
DROP PROCEDURE UpdateCRMUser
GO

CREATE PROCEDURE [dbo].[UpdateCRMUser]
(
	@ItemID int,
	@CALType int
)
AS
BEGIN
	SET NOCOUNT ON;


UPDATE [dbo].[CRMUsers]
   SET 
      CALType = @CALType
 WHERE AccountID = @ItemID

    
END
GO

ALTER PROCEDURE [dbo].[GetCRMUsersCount] 
(
	@ItemID int,
	@Name nvarchar(400),
	@Email nvarchar(400),
	@CALType int
)
AS
BEGIN

IF (@Name IS NULL)
BEGIN
	SET @Name = '%'
END

IF (@Email IS NULL)
BEGIN
	SET @Email = '%'
END

SELECT 
	COUNT(ea.AccountID)		
FROM 
	ExchangeAccounts ea 
INNER JOIN 
	CRMUsers cu 
ON 
	ea.AccountID = cu.AccountID
WHERE 
	ea.ItemID = @ItemID AND ea.DisplayName LIKE @Name AND ea.PrimaryEmailAddress LIKE @Email
	AND ((cu.CALType = @CALType) OR (@CALType = -1))
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'MySQL Server 5.6')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES(302, 11, N'MySQL', N'MySQL Server 5.6', N'WebsitePanel.Providers.Database.MySqlServer56, WebsitePanel.Providers.Database.MySQL', N'MySQL', NULL)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL WHERE [DisplayName] = 'MySQL Server 5.6'
END
GO


-- CRM Quota

BEGIN
UPDATE [dbo].[Quotas] SET QuotaOrder = 5  WHERE [QuotaName] = 'HostedCRM.MaxDatabaseSize'
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM.ESSUsers')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (462, 21, 4, N'HostedCRM.ESSUsers', N'ESS licenses per organization',3, 0 , NULL)
END
GO


-- Lync

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetPackageIPAddressesCount')
DROP PROCEDURE GetPackageIPAddressesCount
GO

CREATE PROCEDURE [dbo].[GetPackageIPAddressesCount]
(
	@PackageID int,
	@OrgID int,
	@PoolID int = 0
)
AS
BEGIN

SELECT 
	COUNT(PA.PackageAddressID)
FROM 
	dbo.PackageIPAddresses PA
INNER JOIN 
	dbo.IPAddresses AS IP ON PA.AddressID = IP.AddressID
INNER JOIN 
	dbo.Packages P ON PA.PackageID = P.PackageID
INNER JOIN 
	dbo.Users U ON U.UserID = P.UserID
LEFT JOIN 
	ServiceItems SI ON PA.ItemId = SI.ItemID
WHERE
	(@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
AND (@OrgID = 0 OR @OrgID <> 0 AND PA.OrgID = @OrgID)

END
GO

-- Enterprise Storage Quotas
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'EnterpriseStorage.DiskStorageSpace')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (430, 44, 1,N'EnterpriseStorage.DiskStorageSpace',N'Disk Storage Space (Gb)',2, 0 , NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaDescription] = N'Disk Storage Space (Gb)' WHERE [QuotaName] = 'EnterpriseStorage.DiskStorageSpace'
GO

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'EnterpriseFolders')

CREATE TABLE [dbo].[EnterpriseFolders](
        [EnterpriseFolderID] [int] IDENTITY(1,1) NOT NULL,
        [ItemID] [int] NOT NULL,
        [FolderName] [nvarchar](255) NOT NULL,
        [FolderQuota] [int] NOT NULL DEFAULT 0,
 CONSTRAINT [PK_EnterpriseFolders] PRIMARY KEY CLUSTERED
(
        [EnterpriseFolderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

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
		ELSE IF @QuotaID = 430 -- Enterprise Storage
			SET @Result = (SELECT SUM(ESF.FolderQuota) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 431 -- Enterprise Storage Folders
			SET @Result = (SELECT COUNT(ESF.EnterpriseFolderID) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddEnterpriseFolder')
DROP PROCEDURE [dbo].[AddEnterpriseFolder]
GO

CREATE PROCEDURE [dbo].[AddEnterpriseFolder]
(
	@FolderID INT OUTPUT,
	@ItemID INT,
	@FolderName NVARCHAR(255)
)
AS

INSERT INTO EnterpriseFolders
(
	ItemID,
	FolderName
)
VALUES
(
	@ItemID,
	@FolderName
)

SET @FolderID = SCOPE_IDENTITY()

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteEnterpriseFolder')
DROP PROCEDURE DeleteEnterpriseFolder
GO

CREATE PROCEDURE [dbo].[DeleteEnterpriseFolder]
(
	@ItemID INT,
	@FolderName NVARCHAR(255)
)
AS

DELETE FROM EnterpriseFolders
WHERE ItemID = @ItemID AND FolderName = @FolderName
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateEnterpriseFolder')
DROP PROCEDURE UpdateEnterpriseFolder
GO

CREATE PROCEDURE [dbo].[UpdateEnterpriseFolder]
(
	@ItemID INT,
	@FolderID NVARCHAR(255),
	@FolderName NVARCHAR(255),
	@FolderQuota INT
)
AS

UPDATE EnterpriseFolders SET
	FolderName = @FolderName,
	FolderQuota = @FolderQuota
WHERE ItemID = @ItemID AND FolderName = @FolderID
GO

-- Enterprise Storage Quotas
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'EnterpriseStorage.DiskStorageSpace')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (430, 44, 1,N'EnterpriseStorage.DiskStorageSpace',N'Disk Storage Space (Mb)',2, 0 , NULL)
END
GO

UPDATE [dbo].[Quotas] SET [QuotaDescription] = N'Disk Storage Space (Mb)' WHERE [QuotaName] = 'EnterpriseStorage.DiskStorageSpace'
GO

--Enterprise Storage
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='EnterpriseFolders' AND COLS.name='LocationDrive')
BEGIN
ALTER TABLE [dbo].[EnterpriseFolders] ADD
	[LocationDrive] NVARCHAR(255) NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='EnterpriseFolders' AND COLS.name='HomeFolder')
BEGIN
ALTER TABLE [dbo].[EnterpriseFolders] ADD
	[HomeFolder] NVARCHAR(255) NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='EnterpriseFolders' AND COLS.name='Domain')
BEGIN
ALTER TABLE [dbo].[EnterpriseFolders] ADD
	[Domain] NVARCHAR(255) NULL
END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetEnterpriseFolders')
DROP PROCEDURE GetEnterpriseFolders
GO

CREATE PROCEDURE [dbo].[GetEnterpriseFolders]
(
	@ItemID INT
)
AS

SELECT DISTINCT LocationDrive, HomeFolder, Domain FROM EnterpriseFolders
WHERE ItemID = @ItemID
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetEnterpriseFolder')
DROP PROCEDURE GetEnterpriseFolder
GO

CREATE PROCEDURE [dbo].[GetEnterpriseFolder]
(
	@ItemID INT,
	@FolderName NVARCHAR(255)
)
AS

SELECT LocationDrive, HomeFolder, Domain FROM EnterpriseFolders
WHERE ItemID = @ItemID AND FolderName = @FolderName
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddEnterpriseFolder')
DROP PROCEDURE [dbo].[AddEnterpriseFolder]
GO

CREATE PROCEDURE [dbo].[AddEnterpriseFolder]
(
	@FolderID INT OUTPUT,
	@ItemID INT,
	@FolderName NVARCHAR(255),
	@LocationDrive NVARCHAR(255),
	@HomeFolder NVARCHAR(255),
	@Domain NVARCHAR(255)
)
AS

INSERT INTO EnterpriseFolders
(
	ItemID,
	FolderName,
	LocationDrive,
	HomeFolder,
	Domain
)
VALUES
(
	@ItemID,
	@FolderName,
	@LocationDrive,
	@HomeFolder,
	@Domain
)

SET @FolderID = SCOPE_IDENTITY()

RETURN
GO

DECLARE @serviceId int
SET @serviceId = (SELECT TOP(1) ServiceId FROM Services WHERE ProviderID = 600)

DECLARE @locationDrive nvarchar(255)
SET @locationDrive = (SELECT TOP(1) PropertyValue FROM ServiceProperties WHERE PropertyName = 'locationdrive' AND ServiceID = @serviceId)
DECLARE @homeFolder nvarchar(255)
SET @homeFolder = (SELECT TOP(1) PropertyValue FROM ServiceProperties WHERE PropertyName = 'usershome' AND ServiceID = @serviceId)
DECLARE @domain nvarchar(255)
SET @domain = (SELECT TOP(1) PropertyValue FROM ServiceProperties WHERE PropertyName = 'usersdomain' AND ServiceID = @serviceId)

UPDATE EnterpriseFolders SET
	LocationDrive = @locationDrive,
	HomeFolder = @homeFolder,
	Domain = @domain
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationGroupsByDisplayName')
DROP PROCEDURE [dbo].[GetOrganizationGroupsByDisplayName]
GO

CREATE PROCEDURE [dbo].[GetOrganizationGroupsByDisplayName]
(
	@ItemID int,
	@DisplayName NVARCHAR(255)
)
AS
SELECT
	AccountID,
	ItemID,
	AccountType,
	AccountName,
	DisplayName,
	UserPrincipalName
FROM
	ExchangeAccounts
WHERE
	ItemID = @ItemID AND DisplayName = @DisplayName AND (AccountType IN (8, 9))
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddEnterpriseFolder')
DROP PROCEDURE [dbo].[AddEnterpriseFolder]
GO

CREATE PROCEDURE [dbo].[AddEnterpriseFolder]
(
	@FolderID INT OUTPUT,
	@ItemID INT,
	@FolderName NVARCHAR(255),
	@FolderQuota INT,
	@LocationDrive NVARCHAR(255),
	@HomeFolder NVARCHAR(255),
	@Domain NVARCHAR(255)
)
AS

INSERT INTO EnterpriseFolders
(
	ItemID,
	FolderName,
	FolderQuota,
	LocationDrive,
	HomeFolder,
	Domain
)
VALUES
(
	@ItemID,
	@FolderName,
	@FolderQuota,
	@LocationDrive,
	@HomeFolder,
	@Domain
)

SET @FolderID = SCOPE_IDENTITY()

RETURN
GO

-- Security Groups Quota update

IF EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.SecurityGroupManagement' AND [QuotaID] = 423)
BEGIN
	UPDATE [dbo].[Quotas] 
	SET [QuotaDescription] = N'Security Groups', 
		[QuotaName] = N'HostedSolution.SecurityGroups',
		[QuotaTypeID] = 2
	WHERE [QuotaID] = 423

	UPDATE [dbo].[HostingPlanQuotas] 
	SET [QuotaValue] = -1
	WHERE [QuotaID] = 423

	UPDATE [dbo].[PackageQuotas] 
	SET [QuotaValue] = -1
	WHERE [QuotaID] = 423
END
ELSE
	BEGIN
	--add Security Groups Quota
	IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.SecurityGroups')
		INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (423, 13, 5, N'HostedSolution.SecurityGroups', N'Security Groups', 2, 0, NULL, NULL) 
	END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationStatistics')
DROP PROCEDURE [dbo].[GetOrganizationStatistics]
GO

CREATE PROCEDURE [dbo].[GetOrganizationStatistics]
(
	@ItemID int
)
AS
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 7 OR AccountType = 1 OR AccountType = 6 OR AccountType = 5)  AND ItemID = @ItemID) AS CreatedUsers,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 8 OR AccountType = 9)  AND ItemID = @ItemID) AS CreatedGroups
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
		ELSE IF @QuotaID = 381 -- Dedicated Lync Phone Numbers
			SET @Result = (SELECT COUNT(PIP.PackageAddressID) FROM PackageIPAddresses AS PIP
							INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
							INNER JOIN PackagesTreeCache AS PT ON PIP.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID AND IP.PoolID = 5)
		ELSE IF @QuotaID = 430 -- Enterprise Storage
			SET @Result = (SELECT SUM(ESF.FolderQuota) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 431 -- Enterprise Storage Folders
			SET @Result = (SELECT COUNT(ESF.EnterpriseFolderID) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 423 -- HostedSolution.SecurityGroups
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND ea.AccountType IN (8,9))
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO



-- CRM2013

-- CRM2013 ResourceGroup

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'Hosted CRM2013')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (24, N'Hosted CRM2013', 15, NULL, 1)
END
GO

-- CRM2013 Provider

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted MS CRM 2013')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) 
VALUES(1202, 24, N'CRM', N'Hosted MS CRM 2013', N'WebsitePanel.Providers.HostedSolution.CRMProvider2013, WebsitePanel.Providers.HostedSolution.Crm2013', N'CRM2011', NULL)
END
GO

-- CRM2013 Quotas

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM2013.Organization')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (463, 24, 1, N'HostedCRM2013.Organization', N'CRM Organization', 1, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM2013.MaxDatabaseSize')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) 
VALUES (464, 24, 5, N'HostedCRM2013.MaxDatabaseSize', N'Max Database Size, MB',3, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM2013.EssentialUsers')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (465, 24, 2, N'HostedCRM2013.EssentialUsers', N'Essential licenses per organization', 3, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM2013.BasicUsers')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) 
VALUES (466, 24, 3, N'HostedCRM2013.BasicUsers', N'Basic licenses per organization',3, 0 , NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedCRM2013.ProfessionalUsers')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) 
VALUES (467, 24, 4, N'HostedCRM2013.ProfessionalUsers', N'Professional licenses per organization',3, 0 , NULL)
END
GO




-- Exchange2013 Archiving

-- Exchange2013 Archiving Quotas

IF EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaID] = 424)
BEGIN
UPDATE [dbo].[Quotas] SET [QuotaName]=N'Exchange2013.AllowRetentionPolicy', [QuotaDescription]=N'Allow Retention Policy'
WHERE [QuotaID] = 424
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.AllowRetentionPolicy')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota])
VALUES (424, 12, 27,N'Exchange2013.AllowRetentionPolicy',N'Allow Retention Policy',1, 0 , NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.ArchivingStorage')
BEGIN
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (425, 12, 29, N'Exchange2013.ArchivingStorage', N'Archiving storage, MB', 2, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.ArchivingMailboxes')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (426, 12, 28, N'Exchange2013.ArchivingMailboxes', N'Archiving Mailboxes per Organization', 2, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.AllowArchiving')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota])
VALUES (427, 12, 27,N'Exchange2013.AllowArchiving',N'Allow Archiving',1, 0 , NULL, NULL)
END
GO


-- Exchange2013 Archiving Plans
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='Archiving')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
[Archiving] [bit] NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='EnableArchiving')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
[EnableArchiving] [bit] NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='ArchiveSizeMB')
BEGIN
ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD
[ArchiveSizeMB] [int] NULL,
[ArchiveWarningPct] [int] NULL
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
	@LitigationHoldMsg nvarchar(512),
	@Archiving bit,
	@EnableArchiving bit,
	@ArchiveSizeMB int,
	@ArchiveWarningPct int
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
	LitigationHoldMsg,
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct
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
	@LitigationHoldMsg,
	@Archiving,
	@EnableArchiving,
	@ArchiveSizeMB,
	@ArchiveWarningPct
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
	@LitigationHoldMsg nvarchar(512),
	@Archiving bit,
	@EnableArchiving bit,
	@ArchiveSizeMB int,
	@ArchiveWarningPct int
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
	LitigationHoldMsg = @LitigationHoldMsg,
	Archiving = @Archiving,
	EnableArchiving = @EnableArchiving,
	ArchiveSizeMB = @ArchiveSizeMB,
	ArchiveWarningPct = @ArchiveWarningPct
WHERE MailboxPlanId = @MailboxPlanId

RETURN
	
GO



ALTER PROCEDURE [dbo].[GetExchangeMailboxPlans]
(
	@ItemID int,
	@Archiving bit
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
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct
FROM
	ExchangeMailboxPlans
WHERE
	ItemID = @ItemID 
AND ((Archiving=@Archiving) OR ((@Archiving=0) AND (Archiving IS NULL)))
ORDER BY MailboxPlan
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
	LitigationHoldMsg,
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct
FROM
	ExchangeMailboxPlans
WHERE
	MailboxPlanId = @MailboxPlanId
RETURN

GO

-- Exchange2013 ExchangeAccount

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='ArchivingMailboxPlanId')
BEGIN
ALTER TABLE [dbo].[ExchangeAccounts] ADD
[ArchivingMailboxPlanId] [int] NULL
END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='EnableArchiving')
BEGIN
ALTER TABLE [dbo].[ExchangeAccounts] ADD
[EnableArchiving] [bit] NULL
END
GO

-- Password column removed
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
WHERE
	E.ItemID = @ItemID AND
	E.AccountID = @AccountID
RETURN
GO


-- Password column removed
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
WHERE
	E.ItemID = @ItemID AND
	E.AccountName = @AccountName
RETURN
GO





-- Password column removed
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
WHERE
	E.ItemID = @ItemID AND
	E.MailboxPlanId = @MailboxPlanId AND
	E.AccountType IN (1,5) 
RETURN
END
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
	@MaximumRows int,
	@Archiving bit
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

if @Archiving = 1
BEGIN
	SET @condition = @condition + ' AND (EA.ArchivingMailboxPlanId > 0) ' 
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


ALTER PROCEDURE [dbo].[SetExchangeAccountMailboxplan] 
(
	@AccountID int,
	@MailboxPlanId int,
	@ArchivingMailboxPlanId int,
	@EnableArchiving bit
)
AS

UPDATE ExchangeAccounts SET
	MailboxPlanId = @MailboxPlanId,
	ArchivingMailboxPlanId = @ArchivingMailboxPlanId,
	EnableArchiving = @EnableArchiving
WHERE
	AccountID = @AccountID

RETURN

GO

-- Password column removed
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
	@MailboxPlanId int,
	@ArchivingMailboxPlanId int,
	@SubscriberNumber varchar(32),
	@EnableArchiving bit
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
	SubscriberNumber = @SubscriberNumber,
	ArchivingMailboxPlanId = @ArchivingMailboxPlanId,
	EnableArchiving = @EnableArchiving

WHERE
	AccountID = @AccountID

IF (@@ERROR <> 0 )
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRAN
RETURN

GO

-- Exchange2013 Archiving ExchangeRetentionPolicyTags

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ExchangeRetentionPolicyTags')
CREATE TABLE ExchangeRetentionPolicyTags
(
[TagID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
[ItemID] [int] NOT NULL,
[TagName] NVARCHAR(255),
[TagType] [int] NOT NULL,
[AgeLimitForRetention] [int] NOT NULL,
[RetentionAction] [int] NOT NULL
)
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddExchangeRetentionPolicyTag')
DROP PROCEDURE [dbo].[AddExchangeRetentionPolicyTag]
GO

CREATE PROCEDURE [dbo].[AddExchangeRetentionPolicyTag] 
(
	@TagID int OUTPUT,
	@ItemID int,
	@TagName nvarchar(255),
	@TagType int,
	@AgeLimitForRetention int,
	@RetentionAction int
)
AS
BEGIN

INSERT INTO ExchangeRetentionPolicyTags
(
	ItemID,
	TagName,
	TagType,
	AgeLimitForRetention,
	RetentionAction
)
VALUES
(
	@ItemID,
	@TagName,
	@TagType,
	@AgeLimitForRetention,
	@RetentionAction
)

SET @TagID = SCOPE_IDENTITY()

RETURN

END
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateExchangeRetentionPolicyTag')
DROP PROCEDURE [dbo].[UpdateExchangeRetentionPolicyTag]
GO

CREATE PROCEDURE [dbo].[UpdateExchangeRetentionPolicyTag] 
(
	@TagID int,
	@ItemID int,
	@TagName nvarchar(255),
	@TagType int,
	@AgeLimitForRetention int,
	@RetentionAction int
)
AS

UPDATE ExchangeRetentionPolicyTags SET
	ItemID = @ItemID,
	TagName = @TagName,
	TagType = @TagType,
	AgeLimitForRetention = @AgeLimitForRetention,
	RetentionAction = @RetentionAction
WHERE TagID = @TagID

RETURN
	
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetExchangeRetentionPolicyTags')
DROP PROCEDURE [dbo].[GetExchangeRetentionPolicyTags]
GO

CREATE PROCEDURE [dbo].[GetExchangeRetentionPolicyTags]
(
	@ItemID int
)
AS
SELECT
	TagID,
	ItemID,
	TagName,
	TagType,
	AgeLimitForRetention,
	RetentionAction
FROM
	ExchangeRetentionPolicyTags
WHERE
	ItemID = @ItemID 
ORDER BY TagName
RETURN

GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetExchangeRetentionPolicyTag')
DROP PROCEDURE [dbo].[GetExchangeRetentionPolicyTag]
GO

CREATE PROCEDURE [dbo].[GetExchangeRetentionPolicyTag] 
(
	@TagID int
)
AS
SELECT
	TagID,
	ItemID,
	TagName,
	TagType,
	AgeLimitForRetention,
	RetentionAction
FROM
	ExchangeRetentionPolicyTags
WHERE
	TagID = @TagID
RETURN

GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteExchangeRetentionPolicyTag')
DROP PROCEDURE [dbo].[DeleteExchangeRetentionPolicyTag]
GO


CREATE PROCEDURE [dbo].[DeleteExchangeRetentionPolicyTag]
(
        @TagID int
)
AS
DELETE FROM ExchangeRetentionPolicyTags
WHERE
	TagID = @TagID
RETURN

GO


-- Exchange2013 Archiving ExchangeMailboxPlanRetentionPolicyTags

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ExchangeMailboxPlanRetentionPolicyTags')
CREATE TABLE ExchangeMailboxPlanRetentionPolicyTags
(
[PlanTagID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
[TagID] [int] NOT NULL,
[MailboxPlanId] [int] NOT NULL
)
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetExchangeMailboxPlanRetentionPolicyTags')
DROP PROCEDURE [dbo].[GetExchangeMailboxPlanRetentionPolicyTags]
GO

CREATE PROCEDURE [dbo].[GetExchangeMailboxPlanRetentionPolicyTags]
(
	@MailboxPlanId int
)
AS
SELECT
D.PlanTagID,
D.TagID,
D.MailboxPlanId,
P.MailboxPlan,
T.TagName
FROM
	ExchangeMailboxPlanRetentionPolicyTags AS D
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON P.MailboxPlanId = D.MailboxPlanId	
LEFT OUTER JOIN ExchangeRetentionPolicyTags AS T ON T.TagID = D.TagID	
WHERE
	D.MailboxPlanId = @MailboxPlanId 
RETURN

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddExchangeMailboxPlanRetentionPolicyTag')
DROP PROCEDURE [dbo].[AddExchangeMailboxPlanRetentionPolicyTag]
GO

CREATE PROCEDURE [dbo].[AddExchangeMailboxPlanRetentionPolicyTag] 
(
	@PlanTagID int OUTPUT,
	@TagID int,
	@MailboxPlanId int
)
AS
BEGIN

INSERT INTO ExchangeMailboxPlanRetentionPolicyTags
(
	TagID,
	MailboxPlanId
)
VALUES
(
	@TagID,
	@MailboxPlanId
)

SET @PlanTagID = SCOPE_IDENTITY()

RETURN

END
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteExchangeMailboxPlanRetentionPolicyTag')
DROP PROCEDURE [dbo].[DeleteExchangeMailboxPlanRetentionPolicyTag]
GO

CREATE PROCEDURE [dbo].[DeleteExchangeMailboxPlanRetentionPolicyTag]
(
        @PlanTagID int
)
AS
DELETE FROM ExchangeMailboxPlanRetentionPolicyTags
WHERE
	PlanTagID = @PlanTagID
RETURN

GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'EnterpriseStorage.DriveMaps')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID]) VALUES (468, 44, 2, N'EnterpriseStorage.DriveMaps', N'Use Drive Maps', 1, 0, NULL)
END
GO

-- Exchange2013 Archiving

ALTER PROCEDURE [dbo].[GetExchangeOrganizationStatistics] 
(
	@ItemID int
)
AS

DECLARE @ARCHIVESIZE INT
IF -1 in (SELECT B.ArchiveSizeMB FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
BEGIN
	SET @ARCHIVESIZE = -1
END
ELSE
BEGIN
	SET @ARCHIVESIZE = (SELECT SUM(B.ArchiveSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
END

IF -1 IN (SELECT B.MailboxSizeMB FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1 OR AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT MIN(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace,
	(SELECT MIN(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace,
	@ARCHIVESIZE AS UsedArchingStorage
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
	(SELECT SUM(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace,
	@ARCHIVESIZE AS UsedArchingStorage
END


RETURN
GO


BEGIN
DELETE FROM [dbo].[HostingPlanQuotas] WHERE QuotaID = 427
END
GO

BEGIN
DELETE FROM [dbo].[PackageQuotas] WHERE QuotaID = 427
END
GO


BEGIN
DELETE FROM [dbo].[Quotas] WHERE QuotaID = 427
END
GO

-- Set SQL 2008 and SQL 2012 Users on suspendable
BEGIN
UPDATE [dbo].[ServiceItemTypes] SET [Suspendable] = 1 WHERE [ItemTypeID] = 32 AND [GroupID] = 22
END
GO

BEGIN
UPDATE [dbo].[ServiceItemTypes] SET [Suspendable] = 1 WHERE [ItemTypeID] = 38 AND [GroupID] = 23
END
GO

/* ICE Warp */ 
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [ProviderName] = 'IceWarp')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (160, 4, N'IceWarp', N'IceWarp Mail Server', N'WebsitePanel.Providers.Mail.IceWarp, WebsitePanel.Providers.Mail.IceWarp', N'IceWarp', NULL)
END
GO

/* SQL 2014 Provider */
IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'MsSQL2014')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (46, N'MsSQL2014', 11, N'WebsitePanel.EnterpriseServer.DatabaseServerController', 1)
END
ELSE
BEGIN
UPDATE [dbo].[ResourceGroups] SET [ShowGroup] = 1 WHERE [GroupName] = 'MsSQL2014'
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Microsoft SQL Server 2014')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (1203, 46, N'MsSQL', N'Microsoft SQL Server 2014', N'WebsitePanel.Providers.Database.MsSqlServer2014, WebsitePanel.Providers.Database.SqlServer', N'MSSQL', NULL)
INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (39, 46, N'MsSQL2014Database', N'WebsitePanel.Providers.Database.SqlDatabase, WebsitePanel.Providers.Base', 1, 1, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (40, 46, N'MsSQL2014User', N'WebsitePanel.Providers.Database.SqlUser, WebsitePanel.Providers.Base', 1, 0, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (470, 46, 1, N'MsSQL2014.Databases', N'Databases', 2, 0, 39, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (471, 46, 2, N'MsSQL2014.Users', N'Users', 2, 0, 40, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (472, 46, 3, N'MsSQL2014.MaxDatabaseSize', N'Max Database Size', 3, 0, NULL, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (473, 46, 5, N'MsSQL2014.Backup', N'Database Backups', 1, 0, NULL, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (474, 46, 6, N'MsSQL2014.Restore', N'Database Restores', 1, 0, NULL, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (475, 46, 7, N'MsSQL2014.Truncate', N'Database Truncate', 1, 0, NULL, NULL)
INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (476, 46, 4, N'MsSQL2014.MaxLogSize', N'Max Log Size', 3, 0, NULL, NULL)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [DisableAutoDiscovery] = NULL, GroupID = 46 WHERE [DisplayName] = 'Microsoft SQL Server 2014'
END
GO



/*This should be [DefaultValue]= N'MsSQL2000=SQL Server 2000;MsSQL2005=SQL Server 2005;MsSQL2008=SQL Server 2008;MsSQL2012=SQL Server 2012;MsSQL2014=SQL Server 2014;MySQL4=MySQL 4.0;MySQL5=MySQL 5.0' but the field is not large enough!! */
UPDATE [dbo].[ScheduleTaskParameters] SET [DefaultValue]= N'MsSQL2005=SQL Server 2005;MsSQL2008=SQL Server 2008;MsSQL2012=SQL Server 2012;MsSQL2014=SQL Server 2014;MySQL4=MySQL 4.0;MySQL5=MySQL 5.0' WHERE [TaskID]= 'SCHEDULE_TASK_BACKUP_DATABASE' AND [ParameterID]='DATABASE_GROUP'
GO

/*SUPPORT SERVICE LEVELS*/

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'Service Levels')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (47, N'Service Levels', 2, NULL, 1)
END
GO

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'SupportServiceLevels')
CREATE TABLE SupportServiceLevels
(
[LevelID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
[LevelName] NVARCHAR(100) NOT NULL,
[LevelDescription] NVARCHAR(1000) NULL
)
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeAccounts' AND COLS.name='LevelID')
ALTER TABLE [dbo].[ExchangeAccounts] ADD
	[LevelID] [int] NULL,
	[IsVIP] [bit] NOT NULL DEFAULT 0
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetSupportServiceLevels')
DROP PROCEDURE GetSupportServiceLevels
GO

CREATE PROCEDURE [dbo].[GetSupportServiceLevels]
AS
SELECT *
FROM SupportServiceLevels
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetSupportServiceLevel')
DROP PROCEDURE GetSupportServiceLevel
GO

CREATE PROCEDURE [dbo].[GetSupportServiceLevel]
(
	@LevelID int
)
AS
SELECT *
FROM SupportServiceLevels
WHERE LevelID = @LevelID
RETURN 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddSupportServiceLevel')
DROP PROCEDURE AddSupportServiceLevel
GO

CREATE PROCEDURE [dbo].[AddSupportServiceLevel]
(
	@LevelID int OUTPUT,
	@LevelName nvarchar(100),
	@LevelDescription nvarchar(1000)
)
AS
BEGIN

	IF EXISTS (SELECT * FROM SupportServiceLevels WHERE LevelName = @LevelName)
	BEGIN
		SET @LevelID = -1

		RETURN
	END

	INSERT INTO SupportServiceLevels
	(
		LevelName,
		LevelDescription
	)
	VALUES
	(
		@LevelName,
		@LevelDescription
	)

	SET @LevelID = SCOPE_IDENTITY()

	DECLARE @ResourseGroupID int

	IF EXISTS (SELECT * FROM ResourceGroups WHERE GroupName = 'Service Levels')
	BEGIN
		DECLARE @QuotaLastID int, @CurQuotaName nvarchar(100), 
			@CurQuotaDescription nvarchar(1000), @QuotaOrderInGroup int

		SET @CurQuotaName = N'ServiceLevel.' + @LevelName
		SET @CurQuotaDescription = @LevelName + N', users'

		SELECT @ResourseGroupID = GroupID FROM ResourceGroups WHERE GroupName = 'Service Levels'

		SELECT @QuotaLastID = MAX(QuotaID) FROM Quotas

		SELECT @QuotaOrderInGroup = MAX(QuotaOrder) FROM Quotas WHERE GroupID = @ResourseGroupID

		IF @QuotaOrderInGroup IS NULL SET @QuotaOrderInGroup = 0

		IF NOT EXISTS (SELECT * FROM Quotas WHERE QuotaName = @CurQuotaName)
		BEGIN
			INSERT Quotas 
				(QuotaID, 
				GroupID, 
				QuotaOrder, 
				QuotaName, 
				QuotaDescription, 
				QuotaTypeID, 
				ServiceQuota, 
				ItemTypeID) 
			VALUES 
				(@QuotaLastID + 1, 
				@ResourseGroupID, 
				@QuotaOrderInGroup + 1, 
				@CurQuotaName, 
				@CurQuotaDescription,
				2, 
				0, 
				NULL)
		END
	END

END

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteSupportServiceLevel')
DROP PROCEDURE DeleteSupportServiceLevel
GO

CREATE PROCEDURE [dbo].[DeleteSupportServiceLevel]
(
	@LevelID int
)
AS
BEGIN

	DECLARE @LevelName nvarchar(100), @QuotaName nvarchar(100), @QuotaID int

	SELECT @LevelName = LevelName FROM SupportServiceLevels WHERE LevelID = @LevelID

	SET @QuotaName = N'ServiceLevel.' + @LevelName

	SELECT @QuotaID = QuotaID FROM Quotas WHERE QuotaName = @QuotaName

	IF @QuotaID IS NOT NULL
	BEGIN
		DELETE FROM HostingPlanQuotas WHERE QuotaID = @QuotaID
		DELETE FROM PackageQuotas WHERE QuotaID = @QuotaID
		DELETE FROM Quotas WHERE QuotaID = @QuotaID
	END

	IF EXISTS (SELECT * FROM ExchangeAccounts WHERE LevelID = @LevelID)
	UPDATE ExchangeAccounts
	   SET LevelID = NULL
	 WHERE LevelID = @LevelID

	DELETE FROM SupportServiceLevels WHERE LevelID = @LevelID

END

RETURN 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateSupportServiceLevel')
DROP PROCEDURE UpdateSupportServiceLevel
GO

CREATE PROCEDURE [dbo].[UpdateSupportServiceLevel]
(
	@LevelID int,
	@LevelName nvarchar(100),
	@LevelDescription nvarchar(1000)
)
AS
BEGIN

	DECLARE @PrevQuotaName nvarchar(100), @PrevLevelName nvarchar(100)

	SELECT @PrevLevelName = LevelName FROM SupportServiceLevels WHERE LevelID = @LevelID

	SET @PrevQuotaName = N'ServiceLevel.' + @PrevLevelName

	UPDATE SupportServiceLevels
	SET LevelName = @LevelName,
		LevelDescription = @LevelDescription
	WHERE LevelID = @LevelID

	IF EXISTS (SELECT * FROM Quotas WHERE QuotaName = @PrevQuotaName)
	BEGIN
		DECLARE @QuotaID INT

		SELECT @QuotaID = QuotaID FROM Quotas WHERE QuotaName = @PrevQuotaName
		 
		UPDATE Quotas
		SET QuotaName = N'ServiceLevel.' + @LevelName,
			QuotaDescription = @LevelName + ', users'
		WHERE QuotaID = @QuotaID
	END

END

RETURN 
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type IN ('FN', 'IF', 'TF') AND name = 'GetPackageServiceLevelResource') 
DROP FUNCTION GetPackageServiceLevelResource
GO

CREATE FUNCTION dbo.GetPackageServiceLevelResource
(
	@PackageID int,
	@GroupID int,
	@ServerID int
)
RETURNS bit
AS
BEGIN

IF NOT EXISTS (SELECT * FROM dbo.ResourceGroups WHERE GroupID = @GroupID AND GroupName = 'Service Levels')
RETURN 0

IF @PackageID IS NULL
RETURN 1

DECLARE @Result bit
SET @Result = 1 -- enabled

DECLARE @PID int, @ParentPackageID int
SET @PID = @PackageID

DECLARE @OverrideQuotas bit

IF @ServerID IS NULL OR @ServerID = 0
SELECT @ServerID = ServerID FROM Packages
WHERE PackageID = @PackageID

WHILE 1 = 1
BEGIN

	DECLARE @GroupEnabled int

	-- get package info
	SELECT
		@ParentPackageID = ParentPackageID,
		@OverrideQuotas = OverrideQuotas
	FROM Packages WHERE PackageID = @PID

	-- check if this is a root 'System' package
	SET @GroupEnabled = 1 -- enabled
	IF @ParentPackageID IS NULL
	BEGIN

		IF @ServerID = 0
		RETURN 0
		ELSE IF @PID = -1
		RETURN 1
		ELSE IF @ServerID IS NULL
		RETURN 1
		ELSE IF @ServerID > 0
		RETURN 1
		ELSE RETURN 0
	END
	ELSE -- parentpackage is not null
	BEGIN
		-- check the current package
		IF @OverrideQuotas = 1
		BEGIN
			IF NOT EXISTS(
				SELECT GroupID FROM PackageResources WHERE GroupID = @GroupID AND PackageID = @PID
			)
			SET @GroupEnabled = 0
		END
		ELSE
		BEGIN
			IF NOT EXISTS(
				SELECT HPR.GroupID FROM Packages AS P
				INNER JOIN HostingPlanResources AS HPR ON P.PlanID = HPR.PlanID
				WHERE HPR.GroupID = @GroupID AND P.PackageID = @PID
			)
			SET @GroupEnabled = 0
		END
		
		-- check addons
		IF EXISTS(
			SELECT HPR.GroupID FROM PackageAddons AS PA
			INNER JOIN HostingPlanResources AS HPR ON PA.PlanID = HPR.PlanID
			WHERE HPR.GroupID = @GroupID AND PA.PackageID = @PID
			AND PA.StatusID = 1 -- active add-on
		)
		SET @GroupEnabled = 1
	END
	
	IF @GroupEnabled = 0
		RETURN 0
	
	SET @PID = @ParentPackageID

END -- end while

RETURN @Result
END
GO

ALTER PROCEDURE [dbo].[GetPackageQuotasForEdit]
(
	@ActorID int,
	@PackageID int
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

DECLARE @ServerID int, @ParentPackageID int, @PlanID int
SELECT @ServerID = ServerID, @ParentPackageID = ParentPackageID, @PlanID = PlanID FROM Packages
WHERE PackageID = @PackageID

-- get resource groups
SELECT
	RG.GroupID,
	RG.GroupName,
	ISNULL(PR.CalculateDiskSpace, ISNULL(HPR.CalculateDiskSpace, 0)) AS CalculateDiskSpace,
	ISNULL(PR.CalculateBandwidth, ISNULL(HPR.CalculateBandwidth, 0)) AS CalculateBandwidth,
		--dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, @ServerID) AS Enabled,
	CASE
		WHEN RG.GroupName = 'Service Levels' THEN dbo.GetPackageServiceLevelResource(PackageID, RG.GroupID, @ServerID)
		ELSE dbo.GetPackageAllocatedResource(PackageID, RG.GroupID, @ServerID)
	END AS Enabled,
	--dbo.GetPackageAllocatedResource(@ParentPackageID, RG.GroupID, @ServerID) AS ParentEnabled
	CASE
		WHEN RG.GroupName = 'Service Levels' THEN dbo.GetPackageServiceLevelResource(@ParentPackageID, RG.GroupID, @ServerID)
		ELSE dbo.GetPackageAllocatedResource(@ParentPackageID, RG.GroupID, @ServerID)
	END AS ParentEnabled
FROM ResourceGroups AS RG
LEFT OUTER JOIN PackageResources AS PR ON RG.GroupID = PR.GroupID AND PR.PackageID = @PackageID
LEFT OUTER JOIN HostingPlanResources AS HPR ON RG.GroupID = HPR.GroupID AND HPR.PlanID = @PlanID
ORDER BY RG.GroupOrder


-- return quotas
SELECT
	Q.QuotaID,
	Q.GroupID,
	Q.QuotaName,
	Q.QuotaDescription,
	Q.QuotaTypeID,
	CASE
		WHEN PQ.QuotaValue IS NULL THEN dbo.GetPackageAllocatedQuota(@PackageID, Q.QuotaID)
		ELSE PQ.QuotaValue
	END QuotaValue,
	dbo.GetPackageAllocatedQuota(@ParentPackageID, Q.QuotaID) AS ParentQuotaValue
FROM Quotas AS Q
LEFT OUTER JOIN PackageQuotas AS PQ ON PQ.QuotaID = Q.QuotaID AND PQ.PackageID = @PackageID
ORDER BY Q.QuotaOrder

RETURN
GO

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
	--dbo.GetPackageAllocatedResource(@ParentPackageID, RG.GroupID, 0) AS ParentEnabled
	CASE
		WHEN RG.GroupName = 'Service Levels' THEN dbo.GetPackageServiceLevelResource(@ParentPackageID, RG.GroupID, 0)
		ELSE dbo.GetPackageAllocatedResource(@ParentPackageID, RG.GroupID, 0)
	END AS ParentEnabled
FROM ResourceGroups AS RG
LEFT OUTER JOIN HostingPlanResources AS HPR ON RG.GroupID = HPR.GroupID AND HPR.PlanID = @PlanID
--WHERE dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, 0) = 1
WHERE (dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, 0) = 1 AND RG.GroupName <> 'Service Levels') OR
	  (dbo.GetPackageServiceLevelResource(@PackageID, RG.GroupID, 0) = 1 AND RG.GroupName = 'Service Levels')
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
	--dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, @ServerID) AS ParentEnabled,
	CASE
		WHEN RG.GroupName = 'Service Levels' THEN dbo.GetPackageServiceLevelResource(@PackageID, RG.GroupID, @ServerID)
		ELSE dbo.GetPackageAllocatedResource(@PackageID, RG.GroupID, @ServerID)
	END AS ParentEnabled,
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
	EA.UserPrincipalName,
	EA.LevelID,
	EA.IsVIP
FROM ExchangeAccounts AS EA
WHERE ' + @condition

print @sql

exec sp_executesql @sql, N'@ItemID int, @IncludeMailboxes bit', 
@ItemID, @IncludeMailboxes

RETURN
GO

-- Password column removed
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving,
	E.LevelID,
	E.IsVIP
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
WHERE
	E.ItemID = @ItemID AND
	E.AccountID = @AccountID
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
	@MaximumRows int,
	@Archiving bit
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

if @Archiving = 1
BEGIN
	SET @condition = @condition + ' AND (EA.ArchivingMailboxPlanId > 0) ' 
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
		EA.UserPrincipalName,
		EA.LevelID,
		EA.IsVIP ' + @joincondition +
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

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateExchangeAccountSLSettings')
DROP PROCEDURE UpdateExchangeAccountSLSettings
GO

CREATE PROCEDURE [dbo].[UpdateExchangeAccountSLSettings]
(
	@AccountID int,
	@LevelID int,
	@IsVIP bit
)
AS

BEGIN TRAN	

	IF (@LevelID = -1) 
	BEGIN
		SET @LevelID = NULL
	END

	UPDATE ExchangeAccounts SET
		LevelID = @LevelID,
		IsVIP = @IsVIP
	WHERE
		AccountID = @AccountID

	IF (@@ERROR <> 0 )
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRAN
RETURN 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'CheckServiceLevelUsage')
DROP PROCEDURE CheckServiceLevelUsage
GO

CREATE PROCEDURE [dbo].[CheckServiceLevelUsage]
(
	@LevelID int
)
AS
SELECT COUNT(EA.AccountID)
FROM SupportServiceLevels AS SL
INNER JOIN ExchangeAccounts AS EA ON SL.LevelID = EA.LevelID
WHERE EA.LevelID = @LevelID
RETURN 
GO

-- Service Level Quotas, change type 
UPDATE Quotas
SET QuotaTypeID = 2 
WHERE QuotaName like 'ServiceLevel.%'
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
		DECLARE @QuotaName nvarchar(50)
		SELECT @QuotaTypeID = QuotaTypeID, @QuotaName = QuotaName FROM Quotas
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
		ELSE IF @QuotaID = 430 -- Enterprise Storage
			SET @Result = (SELECT SUM(ESF.FolderQuota) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 431 -- Enterprise Storage Folders
			SET @Result = (SELECT COUNT(ESF.EnterpriseFolderID) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 423 -- HostedSolution.SecurityGroups
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND ea.AccountType IN (8,9))
		ELSE IF @QuotaName like 'ServiceLevel.%' -- Support Service Level Quota
		BEGIN
			DECLARE @LevelID int

			SELECT @LevelID = LevelID FROM SupportServiceLevels
			WHERE LevelName = REPLACE(@QuotaName,'ServiceLevel.','')

			IF (@LevelID IS NOT NULL)
			SET @Result = (SELECT COUNT(EA.AccountID)
				FROM SupportServiceLevels AS SL
				INNER JOIN ExchangeAccounts AS EA ON SL.LevelID = EA.LevelID
				INNER JOIN ServiceItems  SI ON EA.ItemID = SI.ItemID
				INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
				WHERE EA.LevelID = @LevelID AND PT.ParentPackageID = @PackageID)
			ELSE SET @Result = 0
		END
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO



-- IIS80 Provider update for SNI and CCS support
-- Add default serviceproperties for all existing IIS80 Services (if any). These properties are used as markers in the IIS70 Controls in WebPortal to know the version of the IIS Provider
declare c cursor read_only for 
select ServiceID from Services where ProviderID in(select ProviderID from Providers where ProviderName='IIS80')

declare @ServiceID int

open c

fetch next from c 
into @ServiceID

while @@FETCH_STATUS = 0
begin
	if not exists(select null from ServiceProperties where ServiceID = @ServiceID and PropertyName = 'sslccscommonpassword')
		insert into ServiceProperties(ServiceID, PropertyName, PropertyValue)
		values(@ServiceID, 'sslccscommonpassword', '')

	if not exists(select null from ServiceProperties where ServiceID = @ServiceID and PropertyName = 'sslccsuncpath')
		insert into ServiceProperties(ServiceID, PropertyName, PropertyValue)
		values(@ServiceID, 'sslccsuncpath', '')

	if not exists(select null from ServiceProperties where ServiceID = @ServiceID and PropertyName = 'ssluseccs')
		insert into ServiceProperties(ServiceID, PropertyName, PropertyValue)
		values(@ServiceID, 'ssluseccs', 'False')

	if not exists(select null from ServiceProperties where ServiceID = @ServiceID and PropertyName = 'ssluseccs')
		insert into ServiceProperties(ServiceID, PropertyName, PropertyValue)
		values(@ServiceID, 'sslusesni', 'False')

	fetch next from c 
	into @ServiceID
end

close c

deallocate c

GO



/*Remote Desktop Services*/

/*Remote Desktop Services Tables*/
IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'RDSCollectionUsers')
CREATE TABLE RDSCollectionUsers
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	RDSCollectionId INT NOT NULL, 
	AccountID INT NOT NULL 
)
GO


IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'RDSServers')
CREATE TABLE RDSServers
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ItemID INT,
	Name NVARCHAR(255),
	FqdName NVARCHAR(255),
	Description NVARCHAR(255),
	RDSCollectionId INT,
	ConnectionEnabled BIT NOT NULL DEFAULT(1)
)
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RDSServers' AND COLUMN_NAME = 'ConnectionEnabled')
BEGIN
	ALTER TABLE [dbo].[RDSServers]
		ADD ConnectionEnabled BIT NOT NULL DEFAULT(1)
END
GO


IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'RDSCollections')
CREATE TABLE RDSCollections
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ItemID INT NOT NULL,
	Name NVARCHAR(255),
	Description NVARCHAR(255)
)
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RDSCollections' AND COLUMN_NAME = 'DisplayName')
BEGIN
	ALTER TABLE [dbo].[RDSCollections]
		ADD DisplayName NVARCHAR(255)
END
GO

UPDATE [dbo].[RDSCollections] SET DisplayName = [Name]	 WHERE DisplayName IS NULL

IF NOT EXISTS(SELECT * FROM SYS.TABLES WHERE name = 'RDSCollectionSettings')
CREATE TABLE [dbo].[RDSCollectionSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RDSCollectionId] [int] NOT NULL,
	[DisconnectedSessionLimitMin] [int] NULL,
	[ActiveSessionLimitMin] [int] NULL,
	[IdleSessionLimitMin] [int] NULL,
	[BrokenConnectionAction] [nvarchar](20) NULL,
	[AutomaticReconnectionEnabled] [bit] NULL,
	[TemporaryFoldersDeletedOnExit] [bit] NULL,
	[TemporaryFoldersPerSession] [bit] NULL,
	[ClientDeviceRedirectionOptions] [nvarchar](250) NULL,
	[ClientPrinterRedirected] [bit] NULL,
	[ClientPrinterAsDefault] [bit] NULL,
	[RDEasyPrintDriverEnabled] [bit] NULL,
	[MaxRedirectedMonitors] [int] NULL,
 CONSTRAINT [PK_RDSCollectionSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'SecurityLayer' AND [object_id] = OBJECT_ID(N'RDSCollectionSettings'))
BEGIN
	ALTER TABLE [dbo].[RDSCollectionSettings] ADD SecurityLayer NVARCHAR(20) null;
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'EncryptionLevel' AND [object_id] = OBJECT_ID(N'RDSCollectionSettings'))
BEGIN
	ALTER TABLE [dbo].[RDSCollectionSettings] ADD EncryptionLevel NVARCHAR(20) null;
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'AuthenticateUsingNLA' AND [object_id] = OBJECT_ID(N'RDSCollectionSettings'))
BEGIN
	ALTER TABLE [dbo].[RDSCollectionSettings] ADD AuthenticateUsingNLA BIT null;
END
GO



IF NOT EXISTS(SELECT * FROM SYS.TABLES WHERE name = 'RDSCertificates')
CREATE TABLE [dbo].[RDSCertificates](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Content] [ntext] NOT NULL,
	[Hash] [nvarchar](255) NOT NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[ValidFrom] [datetime] NULL,
	[ExpiryDate] [datetime] NULL
 CONSTRAINT [PK_RDSCertificates] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'F' AND name = 'FK_RDSCollectionUsers_RDSCollectionId')
BEGIN
	ALTER TABLE [dbo].[RDSCollectionUsers]
	DROP CONSTRAINT [FK_RDSCollectionUsers_RDSCollectionId]
END
ELSE
	PRINT 'FK_RDSCollectionUsers_RDSCollectionId not EXISTS'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'F' AND name = 'FK_RDSCollectionUsers_UserId')
BEGIN
	ALTER TABLE [dbo].[RDSCollectionUsers]
	DROP CONSTRAINT [FK_RDSCollectionUsers_UserId]
END	
ELSE
	PRINT 'FK_RDSCollectionUsers_UserId not EXISTS'
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'F' AND name = 'FK_RDSServers_RDSCollectionId')
BEGIN
	ALTER TABLE [dbo].[RDSServers]
	DROP CONSTRAINT [FK_RDSServers_RDSCollectionId]
END	
ELSE
	PRINT 'FK_RDSServers_RDSCollectionId not EXISTS'	
GO

ALTER TABLE [dbo].[RDSCollectionUsers]  WITH CHECK ADD  CONSTRAINT [FK_RDSCollectionUsers_RDSCollectionId] FOREIGN KEY([RDSCollectionId])
REFERENCES [dbo].[RDSCollections] ([ID])
ON DELETE CASCADE
GO


ALTER TABLE [dbo].[RDSCollectionUsers]  WITH CHECK ADD  CONSTRAINT [FK_RDSCollectionUsers_UserId] FOREIGN KEY([AccountID])
REFERENCES [dbo].[ExchangeAccounts] ([AccountID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RDSServers]  WITH CHECK ADD  CONSTRAINT [FK_RDSServers_RDSCollectionId] FOREIGN KEY([RDSCollectionId])
REFERENCES [dbo].[RDSCollections] ([ID])
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_RDSCollectionSettings_RDSCollections')
ALTER TABLE [dbo].[RDSCollectionSettings]  WITH CHECK ADD  CONSTRAINT [FK_RDSCollectionSettings_RDSCollections] FOREIGN KEY([RDSCollectionId])
REFERENCES [dbo].[RDSCollections] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RDSCollectionSettings] CHECK CONSTRAINT [FK_RDSCollectionSettings_RDSCollections]
GO

/*Remote Desktop Services Procedures*/

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSCertificate')
DROP PROCEDURE AddRDSCertificate
GO
CREATE PROCEDURE [dbo].[AddRDSCertificate]
(
	@RDSCertificateId INT OUTPUT,
	@ServiceId INT,
	@Content NTEXT,
	@Hash NVARCHAR(255),
	@FileName NVARCHAR(255),
	@ValidFrom DATETIME,
	@ExpiryDate DATETIME
)
AS
INSERT INTO RDSCertificates
(
	ServiceId,
	Content,
	Hash,
	FileName,
	ValidFrom,
	ExpiryDate	
)
VALUES
(
	@ServiceId,
	@Content,
	@Hash,
	@FileName,
	@ValidFrom,
	@ExpiryDate
)

SET @RDSCertificateId = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCertificateByServiceId')
DROP PROCEDURE GetRDSCertificateByServiceId
GO
CREATE PROCEDURE [dbo].[GetRDSCertificateByServiceId]
(
	@ServiceId INT
)
AS
SELECT TOP 1
	Id,
	ServiceId,
	Content, 
	Hash,
	FileName,
	ValidFrom,
	ExpiryDate
	FROM RDSCertificates
	WHERE ServiceId = @ServiceId
	ORDER BY Id DESC
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSServer')
DROP PROCEDURE AddRDSServer
GO
CREATE PROCEDURE [dbo].[AddRDSServer]
(
	@RDSServerID INT OUTPUT,
	@Name NVARCHAR(255),
	@FqdName NVARCHAR(255),
	@Description NVARCHAR(255)
)
AS
INSERT INTO RDSServers
(
	Name,
	FqdName,
	Description
)
VALUES
(
	@Name,
	@FqdName,
	@Description
)

SET @RDSServerID = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteRDSServer')
DROP PROCEDURE DeleteRDSServer
GO
CREATE PROCEDURE [dbo].[DeleteRDSServer]
(
	@Id  int
)
AS
DELETE FROM RDSServers
WHERE Id = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSServerToOrganization')
DROP PROCEDURE AddRDSServerToOrganization
GO
CREATE PROCEDURE [dbo].[AddRDSServerToOrganization]
(
	@Id  INT,
	@ItemID INT
)
AS

UPDATE RDSServers
SET
	ItemID = @ItemID
WHERE ID = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'RemoveRDSServerFromOrganization')
DROP PROCEDURE RemoveRDSServerFromOrganization
GO
CREATE PROCEDURE [dbo].[RemoveRDSServerFromOrganization]
(
	@Id  INT
)
AS

UPDATE RDSServers
SET
	ItemID = NULL
WHERE ID = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSServerToCollection')
DROP PROCEDURE AddRDSServerToCollection
GO
CREATE PROCEDURE [dbo].[AddRDSServerToCollection]
(
	@Id  INT,
	@RDSCollectionId INT
)
AS

UPDATE RDSServers
SET
	RDSCollectionId = @RDSCollectionId
WHERE ID = @Id
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'RemoveRDSServerFromCollection')
DROP PROCEDURE RemoveRDSServerFromCollection
GO
CREATE PROCEDURE [dbo].[RemoveRDSServerFromCollection]
(
	@Id  INT
)
AS

UPDATE RDSServers
SET
	RDSCollectionId = NULL
WHERE ID = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServersByItemId')
DROP PROCEDURE GetRDSServersByItemId
GO
CREATE PROCEDURE [dbo].[GetRDSServersByItemId]
(
	@ItemID INT
)
AS
SELECT 
	RS.Id,
	RS.ItemID,
	RS.Name, 
	RS.FqdName,
	RS.Description,
	RS.RdsCollectionId,
	SI.ItemName
	FROM RDSServers AS RS
	LEFT OUTER JOIN  ServiceItems AS SI ON SI.ItemId = RS.ItemId
	WHERE RS.ItemID = @ItemID
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServers')
DROP PROCEDURE GetRDSServers
GO
CREATE PROCEDURE [dbo].[GetRDSServers]
AS
SELECT 
	RS.Id,
	RS.ItemID,
	RS.Name, 
	RS.FqdName,
	RS.Description,
	RS.RdsCollectionId,
	SI.ItemName
	FROM RDSServers AS RS
	LEFT OUTER JOIN  ServiceItems AS SI ON SI.ItemId = RS.ItemId
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServerById')
DROP PROCEDURE GetRDSServerById
GO
CREATE PROCEDURE [dbo].[GetRDSServerById]
(
	@ID INT
)
AS
SELECT TOP 1
	RS.Id,
	RS.ItemID,
	RS.Name, 
	RS.FqdName,
	RS.Description,
	RS.RdsCollectionId,
	SI.ItemName
	FROM RDSServers AS RS
	LEFT OUTER JOIN  ServiceItems AS SI ON SI.ItemId = RS.ItemId
	WHERE Id = @Id
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServersByCollectionId')
DROP PROCEDURE GetRDSServersByCollectionId
GO
CREATE PROCEDURE [dbo].[GetRDSServersByCollectionId]
(
	@RdsCollectionId INT
)
AS
SELECT 
	RS.Id,
	RS.ItemID,
	RS.Name, 
	RS.FqdName,
	RS.Description,
	RS.RdsCollectionId,
	SI.ItemName
	FROM RDSServers AS RS
	LEFT OUTER JOIN  ServiceItems AS SI ON SI.ItemId = RS.ItemId
	WHERE RdsCollectionId = @RdsCollectionId
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionsPaged')
DROP PROCEDURE GetRDSCollectionsPaged
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionsPaged]
(
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@ItemID int,
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

SET @sql = '

DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows
DECLARE @RDSCollections TABLE
(
	ItemPosition int IDENTITY(0,1),
	RDSCollectionId int
)
INSERT INTO @RDSCollections (RDSCollectionId)
SELECT
	S.ID
FROM RDSCollections AS S
WHERE 
	((@ItemID is Null AND S.ItemID is null)
		or (@ItemID is not Null AND S.ItemID = @ItemID))'

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(RDSCollectionId) FROM @RDSCollections;
SELECT
	CR.ID,
	CR.ItemID,
	CR.Name,
	CR.Description,
	CR.DisplayName
FROM @RDSCollections AS C
INNER JOIN RDSCollections AS CR ON C.RDSCollectionId = CR.ID
WHERE C.ItemPosition BETWEEN @StartRow AND @EndRow'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int,  @FilterValue nvarchar(50),  @ItemID int',
@StartRow, @MaximumRows,  @FilterValue,  @ItemID


RETURN

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionsByItemId')
DROP PROCEDURE GetRDSCollectionsByItemId
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionsByItemId]
(
	@ItemID INT
)
AS
SELECT 
	Id,
	ItemId,
	Name, 
	Description,
	DisplayName
	FROM RDSCollections
	WHERE ItemID = @ItemID
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionByName')
DROP PROCEDURE GetRDSCollectionByName
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionByName]
(
	@Name NVARCHAR(255)
)
AS

SELECT TOP 1
	Id,
	Name, 
	ItemId,
	Description,
	DisplayName
	FROM RDSCollections
	WHERE DisplayName = @Name
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionById')
DROP PROCEDURE GetRDSCollectionById
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionById]
(
	@ID INT
)
AS

SELECT TOP 1
	Id,
	ItemId,
	Name, 
	Description,
	DisplayName 
	FROM RDSCollections
	WHERE ID = @ID
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSCollection')
DROP PROCEDURE AddRDSCollection
GO
CREATE PROCEDURE [dbo].[AddRDSCollection]
(
	@RDSCollectionID INT OUTPUT,
	@ItemID INT,
	@Name NVARCHAR(255),
	@Description NVARCHAR(255),
	@DisplayName NVARCHAR(255)
)
AS

INSERT INTO RDSCollections
(
	ItemID,
	Name,
	Description,
	DisplayName
)
VALUES
(
	@ItemID,
	@Name,
	@Description,
	@DisplayName
)

SET @RDSCollectionID = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateRDSCollection')
DROP PROCEDURE UpdateRDSCollection
GO
CREATE PROCEDURE [dbo].[UpdateRDSCollection]
(
	@ID INT,
	@ItemID INT,
	@Name NVARCHAR(255),
	@Description NVARCHAR(255),
	@DisplayName NVARCHAR(255)
)
AS

UPDATE RDSCollections
SET
	ItemID = @ItemID,
	Name = @Name,
	Description = @Description,
	DisplayName = @DisplayName
WHERE ID = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteRDSCollection')
DROP PROCEDURE DeleteRDSCollection
GO
CREATE PROCEDURE [dbo].[DeleteRDSCollection]
(
	@Id  int
)
AS

UPDATE RDSServers
SET
	RDSCollectionId = Null
WHERE RDSCollectionId = @Id

DELETE FROM RDSCollections
WHERE Id = @Id
GO


-- Password column removed
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionUsersByRDSCollectionId')
DROP PROCEDURE GetRDSCollectionUsersByRDSCollectionId
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionUsersByRDSCollectionId]
(
	@ID INT
)
AS
SELECT 
	  [AccountID],
	  [ItemID],
	  [AccountType],
	  [AccountName],
	  [DisplayName],
	  [PrimaryEmailAddress],
	  [MailEnabledPublicFolder],
	  [MailboxManagerActions],
	  [SamAccountName],
	  [CreatedDate],
	  [MailboxPlanId],
	  [SubscriberNumber],
	  [UserPrincipalName],
	  [ExchangeDisclaimerId],
	  [ArchivingMailboxPlanId],
	  [EnableArchiving],
	  [LevelID],
	  [IsVIP]
	FROM ExchangeAccounts
	WHERE AccountID IN (Select AccountId from RDSCollectionUsers where RDSCollectionId = @Id)
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddUserToRDSCollection')
DROP PROCEDURE AddUserToRDSCollection
GO
CREATE PROCEDURE [dbo].[AddUserToRDSCollection]
(
	@RDSCollectionID INT,
	@AccountId INT
)
AS

INSERT INTO RDSCollectionUsers
(
	RDSCollectionId, 
	AccountID
)
VALUES
(
	@RDSCollectionID,
	@AccountId
)
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'RemoveRDSUserFromRDSCollection')
DROP PROCEDURE RemoveRDSUserFromRDSCollection
GO
CREATE PROCEDURE [dbo].[RemoveRDSUserFromRDSCollection]
(
	@AccountId  INT,
	@RDSCollectionId INT
)
AS


DELETE FROM RDSCollectionUsers
WHERE AccountId = @AccountId AND RDSCollectionId = @RDSCollectionId
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationRdsUsersCount')
DROP PROCEDURE GetOrganizationRdsUsersCount
GO
CREATE PROCEDURE [dbo].GetOrganizationRdsUsersCount
(
	@ItemID INT,
	@TotalNumber int OUTPUT
)
AS
SELECT
  @TotalNumber = Count(DISTINCT([AccountId]))
  FROM [dbo].[RDSCollectionUsers]
  WHERE [RDSCollectionId] in (SELECT [ID] FROM [RDSCollections] where [ItemId]  = @ItemId )
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationRdsCollectionsCount')
DROP PROCEDURE GetOrganizationRdsCollectionsCount
GO
CREATE PROCEDURE [dbo].GetOrganizationRdsCollectionsCount
(
	@ItemID INT,
	@TotalNumber int OUTPUT
)
AS
SELECT
  @TotalNumber = Count([Id])
  FROM [dbo].[RDSCollections] WHERE [ItemId]  = @ItemId
RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationRdsServersCount')
DROP PROCEDURE GetOrganizationRdsServersCount
GO
CREATE PROCEDURE [dbo].GetOrganizationRdsServersCount
(
	@ItemID INT,
	@TotalNumber int OUTPUT
)
AS
SELECT
  @TotalNumber = Count([Id])
  FROM [dbo].[RDSServers] WHERE [ItemId]  = @ItemId
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSCollectionSettingsByCollectionId')
DROP PROCEDURE GetRDSCollectionSettingsByCollectionId
GO
CREATE PROCEDURE [dbo].[GetRDSCollectionSettingsByCollectionId]
(
	@RDSCollectionID INT
)
AS

SELECT TOP 1
	Id,
	RDSCollectionId,
	DisconnectedSessionLimitMin, 
	ActiveSessionLimitMin,
	IdleSessionLimitMin,
	BrokenConnectionAction,
	AutomaticReconnectionEnabled,
	TemporaryFoldersDeletedOnExit,
	TemporaryFoldersPerSession,
	ClientDeviceRedirectionOptions,
	ClientPrinterRedirected,
	ClientPrinterAsDefault,
	RDEasyPrintDriverEnabled,
	MaxRedirectedMonitors
	FROM RDSCollectionSettings
	WHERE RDSCollectionID = @RDSCollectionID
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddRDSCollectionSettings')
DROP PROCEDURE AddRDSCollectionSettings
GO
CREATE PROCEDURE [dbo].[AddRDSCollectionSettings]
(
	@RDSCollectionSettingsID INT OUTPUT,
	@RDSCollectionId INT,
	@DisconnectedSessionLimitMin INT, 
	@ActiveSessionLimitMin INT,
	@IdleSessionLimitMin INT,
	@BrokenConnectionAction NVARCHAR(20),
	@AutomaticReconnectionEnabled BIT,
	@TemporaryFoldersDeletedOnExit BIT,
	@TemporaryFoldersPerSession BIT,
	@ClientDeviceRedirectionOptions NVARCHAR(250),
	@ClientPrinterRedirected BIT,
	@ClientPrinterAsDefault BIT,
	@RDEasyPrintDriverEnabled BIT,
	@MaxRedirectedMonitors INT
)
AS

INSERT INTO RDSCollectionSettings
(
	RDSCollectionId,
	DisconnectedSessionLimitMin, 
	ActiveSessionLimitMin,
	IdleSessionLimitMin,
	BrokenConnectionAction,
	AutomaticReconnectionEnabled,
	TemporaryFoldersDeletedOnExit,
	TemporaryFoldersPerSession,
	ClientDeviceRedirectionOptions,
	ClientPrinterRedirected,
	ClientPrinterAsDefault,
	RDEasyPrintDriverEnabled,
	MaxRedirectedMonitors
)
VALUES
(
	@RDSCollectionId,
	@DisconnectedSessionLimitMin, 
	@ActiveSessionLimitMin,
	@IdleSessionLimitMin,
	@BrokenConnectionAction,
	@AutomaticReconnectionEnabled,
	@TemporaryFoldersDeletedOnExit,
	@TemporaryFoldersPerSession,
	@ClientDeviceRedirectionOptions,
	@ClientPrinterRedirected,
	@ClientPrinterAsDefault,
	@RDEasyPrintDriverEnabled,
	@MaxRedirectedMonitors
)

SET @RDSCollectionSettingsID = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateRDSCollectionSettings')
DROP PROCEDURE UpdateRDSCollectionSettings
GO
CREATE PROCEDURE [dbo].[UpdateRDSCollectionSettings]
(
	@ID INT,
	@RDSCollectionId INT,
	@DisconnectedSessionLimitMin INT, 
	@ActiveSessionLimitMin INT,
	@IdleSessionLimitMin INT,
	@BrokenConnectionAction NVARCHAR(20),
	@AutomaticReconnectionEnabled BIT,
	@TemporaryFoldersDeletedOnExit BIT,
	@TemporaryFoldersPerSession BIT,
	@ClientDeviceRedirectionOptions NVARCHAR(250),
	@ClientPrinterRedirected BIT,
	@ClientPrinterAsDefault BIT,
	@RDEasyPrintDriverEnabled BIT,
	@MaxRedirectedMonitors INT
)
AS

UPDATE RDSCollectionSettings
SET
	RDSCollectionId = @RDSCollectionId,
	DisconnectedSessionLimitMin = @DisconnectedSessionLimitMin,
	ActiveSessionLimitMin = @ActiveSessionLimitMin,
	IdleSessionLimitMin = @IdleSessionLimitMin,
	BrokenConnectionAction = @BrokenConnectionAction,
	AutomaticReconnectionEnabled = @AutomaticReconnectionEnabled,
	TemporaryFoldersDeletedOnExit = @TemporaryFoldersDeletedOnExit,
	TemporaryFoldersPerSession = @TemporaryFoldersPerSession,
	ClientDeviceRedirectionOptions = @ClientDeviceRedirectionOptions,
	ClientPrinterRedirected = @ClientPrinterRedirected,
	ClientPrinterAsDefault = @ClientPrinterAsDefault,
	RDEasyPrintDriverEnabled = @RDEasyPrintDriverEnabled,
	MaxRedirectedMonitors = @MaxRedirectedMonitors
WHERE ID = @Id
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteRDSCollectionSettings')
DROP PROCEDURE DeleteRDSCollectionSettings
GO
CREATE PROCEDURE [dbo].[DeleteRDSCollectionSettings]
(
	@Id  int
)
AS

DELETE FROM DeleteRDSCollectionSettings
WHERE Id = @Id
GO

-- wsp-10269: Changed php extension path in default properties for IIS70 and IIS80 provider
update ServiceDefaultProperties
set PropertyValue='%PROGRAMFILES(x86)%\PHP\php-cgi.exe'
where PropertyName='PhpPath' and ProviderId in(101, 105)

update ServiceDefaultProperties
set PropertyValue='%PROGRAMFILES(x86)%\PHP\php.exe'
where PropertyName='Php4Path' and ProviderId in(101, 105)

GO

-- Exchange2013 Shared and resource mailboxes

-- Exchange2013 Shared and resource mailboxes Quotas
 
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.SharedMailboxes')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (429, 12, 30, N'Exchange2013.SharedMailboxes', N'Shared Mailboxes per Organization', 2, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'Exchange2013.ResourceMailboxes')
BEGIN
INSERT [dbo].[Quotas]  ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) 
VALUES (428, 12, 31, N'Exchange2013.ResourceMailboxes', N'Resource Mailboxes per Organization', 2, 0, NULL, NULL)
END
GO

-- Exchange2013 Shared and resource mailboxes Organization statistics

ALTER PROCEDURE [dbo].[GetExchangeOrganizationStatistics] 
(
	@ItemID int
)
AS

DECLARE @ARCHIVESIZE INT
IF -1 in (SELECT B.ArchiveSizeMB FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
BEGIN
	SET @ARCHIVESIZE = -1
END
ELSE
BEGIN
	SET @ARCHIVESIZE = (SELECT SUM(B.ArchiveSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
END

IF -1 IN (SELECT B.MailboxSizeMB FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID)
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 10) AND ItemID = @ItemID) AS CreatedSharedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedResourceMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT MIN(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace,
	(SELECT MIN(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace,
	@ARCHIVESIZE AS UsedArchingStorage
END
ELSE
BEGIN
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 1) AND ItemID = @ItemID) AS CreatedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 10) AND ItemID = @ItemID) AS CreatedSharedMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 5 OR AccountType = 6) AND ItemID = @ItemID) AS CreatedResourceMailboxes,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 2 AND ItemID = @ItemID) AS CreatedContacts,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 3 AND ItemID = @ItemID) AS CreatedDistributionLists,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 4 AND ItemID = @ItemID) AS CreatedPublicFolders,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT SUM(B.MailboxSizeMB) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedDiskSpace,
	(SELECT SUM(B.RecoverableItemsSpace) FROM ExchangeAccounts AS A INNER JOIN ExchangeMailboxPlans AS B ON A.MailboxPlanId = B.MailboxPlanId WHERE A.ItemID=@ItemID) AS UsedLitigationHoldSpace,
	@ARCHIVESIZE AS UsedArchingStorage
END


RETURN
GO

-- wsp-10053: IDN, return ZoneName also from GetDomainsPaged (already exists in other GetDomain-sps)
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
DECLARE @sql nvarchar(4000)

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

IF @FilterValue <> ''
BEGIN
	IF @FilterColumn <> ''
	BEGIN
		SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '
	END
	ELSE
		SET @sql = @sql + '
		AND (DomainName LIKE @FilterValue 
		OR Username LIKE @FilterValue
		OR ServerName LIKE @FilterValue
		OR PackageName LIKE @FilterValue) '
END

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
	Z.ItemName AS ZoneName,
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


-- Domain lookup tasks

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTasks] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP')
BEGIN
INSERT [dbo].[ScheduleTasks] ([TaskID], [TaskType], [RoleID]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'WebsitePanel.EnterpriseServer.DomainLookupViewTask, WebsitePanel.EnterpriseServer.Code', 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskViewConfiguration] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP')
BEGIN
INSERT [dbo].[ScheduleTaskViewConfiguration] ([TaskID], [ConfigurationID], [Environment], [Description]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'ASP_NET', N'ASP.NET', N'~/DesktopModules/WebsitePanel/ScheduleTaskControls/DomainLookupView.ascx')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'DNS_SERVERS' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'DNS_SERVERS', N'String', NULL, 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'MAIL_TO' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'MAIL_TO', N'String', NULL, 2)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'SERVER_NAME' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'SERVER_NAME', N'String', N'', 3)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'PAUSE_BETWEEN_QUERIES' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_LOOKUP', N'PAUSE_BETWEEN_QUERIES', N'String', N'100', 4)
END
GO

IF EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'SERVER_NAME' )
BEGIN
UPDATE [dbo].[ScheduleTaskParameters] SET [DefaultValue] = N'' WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_LOOKUP' AND [ParameterID]= N'SERVER_NAME'
END
GO

-- Domain Expiration Task


IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTasks] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION')
BEGIN
INSERT [dbo].[ScheduleTasks] ([TaskID], [TaskType], [RoleID]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'WebsitePanel.EnterpriseServer.DomainExpirationTask, WebsitePanel.EnterpriseServer.Code', 3)
END
GO

IF EXISTS (SELECT * FROM [dbo].[ScheduleTasks] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION' AND [RoleID] = 1)
BEGIN
UPDATE [dbo].[ScheduleTasks] SET [RoleID] = 3 WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION'
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskViewConfiguration] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION')
BEGIN
INSERT [dbo].[ScheduleTaskViewConfiguration] ([TaskID], [ConfigurationID], [Environment], [Description]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'ASP_NET', N'ASP.NET', N'~/DesktopModules/WebsitePanel/ScheduleTaskControls/DomainExpirationView.ascx')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION' AND [ParameterID]= N'DAYS_BEFORE' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'DAYS_BEFORE', N'String', NULL, 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION' AND [ParameterID]= N'MAIL_TO' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'MAIL_TO', N'String', NULL, 2)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION' AND [ParameterID]= N'ENABLE_NOTIFICATION' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'ENABLE_NOTIFICATION', N'Boolean', N'false', 3)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_DOMAIN_EXPIRATION' AND [ParameterID]= N'INCLUDE_NONEXISTEN_DOMAINS' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_DOMAIN_EXPIRATION', N'INCLUDE_NONEXISTEN_DOMAINS', N'Boolean', N'false', 4)
END
GO


-- Domain lookup tables

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'DomainDnsRecords')
DROP TABLE DomainDnsRecords
GO
CREATE TABLE DomainDnsRecords
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DomainId INT NOT NULL,
	RecordType INT NOT NULL,
	DnsServer NVARCHAR(255),
	Value NVARCHAR(255),
	Date DATETIME
)
GO

ALTER TABLE [dbo].[DomainDnsRecords]  WITH CHECK ADD  CONSTRAINT [FK_DomainDnsRecords_DomainId] FOREIGN KEY([DomainId])
REFERENCES [dbo].[Domains] ([DomainID])
ON DELETE CASCADE
GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'CreationDate' AND [object_id] = OBJECT_ID(N'Domains'))
BEGIN
	ALTER TABLE [dbo].[Domains] ADD CreationDate DateTime null;
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'ExpirationDate' AND [object_id] = OBJECT_ID(N'Domains'))
BEGIN
	ALTER TABLE [dbo].[Domains] ADD ExpirationDate DateTime null;
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'LastUpdateDate' AND [object_id] = OBJECT_ID(N'Domains'))
BEGIN
	ALTER TABLE [dbo].[Domains] ADD LastUpdateDate DateTime null;
END
GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ScheduleTasksEmailTemplates')
DROP TABLE ScheduleTasksEmailTemplates
GO

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'CC' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'CC', N'support@HostingCompany.com')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @DomainExpirationLetterHtmlBody nvarchar(2500)

Set @DomainExpirationLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Domain Expiration Information</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">

<a name="top"></a>
<div class="Header">
	Domain Expiration Information
</div>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
Please, find below details of your domain expiration information.
</p>

<table>
    <thead>
        <tr>
            <th>Domain</th>
			<th>Registrar</th>
			<th>Customer</th>
            <th>Expiration Date</th>
        </tr>
    </thead>
    <tbody>
            <ad:foreach collection="#Domains#" var="Domain" index="i">
        <tr>
            <td>#Domain.DomainName#</td>
			<td>#iif(isnull(Domain.Registrar), "", Domain.Registrar)#</td>
			<td>#Domain.Customer#</td>
            <td>#iif(isnull(Domain.ExpirationDate), "", Domain.ExpirationDate)#</td>
        </tr>
    </ad:foreach>
    </tbody>
</table>

<ad:if test="#IncludeNonExistenDomains#">
	<p>
	Please, find below details of your non-existen domains.
	</p>

	<table>
		<thead>
			<tr>
				<th>Domain</th>
				<th>Customer</th>
			</tr>
		</thead>
		<tbody>
				<ad:foreach collection="#NonExistenDomains#" var="Domain" index="i">
			<tr>
				<td>#Domain.DomainName#</td>
				<td>#Domain.Customer#</td>
			</tr>
		</ad:foreach>
		</tbody>
	</table>
</ad:if>


<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'HtmlBody', @DomainExpirationLetterHtmlBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @DomainExpirationLetterHtmlBody WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'HtmlBody'
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'Subject', N'Domain expiration notification')
END
GO

DECLARE @DomainExpirationLetterTextBody nvarchar(2500)

Set @DomainExpirationLetterTextBody = N'=================================
   Domain Expiration Information
=================================
<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

Please, find below details of your domain expiration information.


<ad:foreach collection="#Domains#" var="Domain" index="i">
	Domain: #Domain.DomainName#
	Registrar: #iif(isnull(Domain.Registrar), "", Domain.Registrar)#
	Customer: #Domain.Customer#
	Expiration Date: #iif(isnull(Domain.ExpirationDate), "", Domain.ExpirationDate)#

</ad:foreach>

<ad:if test="#IncludeNonExistenDomains#">
Please, find below details of your non-existen domains.

<ad:foreach collection="#NonExistenDomains#" var="Domain" index="i">
	Domain: #Domain.DomainName#
	Customer: #Domain.Customer#

</ad:foreach>
</ad:if>

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainExpirationLetter', N'TextBody', @DomainExpirationLetterTextBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @DomainExpirationLetterTextBody WHERE [UserID] = 1 AND [SettingsName]= N'DomainExpirationLetter' AND [PropertyName]= N'TextBody'
GO




IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'CC' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'CC', N'support@HostingCompany.com')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @DomainLookupLetterHtmlBody nvarchar(2500)

Set @DomainLookupLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>MX and NS Changes Information</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
		.Summary H3 { font-size: 1em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">

<a name="top"></a>
<div class="Header">
	MX and NS Changes Information
</div>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
Please, find below details of MX and NS changes.
</p>

    <ad:foreach collection="#Domains#" var="Domain" index="i">
	<h2>#Domain.DomainName# - #DomainUsers[Domain.PackageId].FirstName# #DomainUsers[Domain.PackageId].LastName#</h2>
	<h3>#iif(isnull(Domain.Registrar), "", Domain.Registrar)# #iif(isnull(Domain.ExpirationDate), "", Domain.ExpirationDate)#</h3>

	<table>
	    <thead>
	        <tr>
	            <th>DNS</th>
				<th>Type</th>
				<th>Status</th>
	            <th>Old Value</th>
                <th>New Value</th>
	        </tr>
	    </thead>
	    <tbody>
	        <ad:foreach collection="#Domain.DnsChanges#" var="DnsChange" index="j">
	        <tr>
	            <td>#DnsChange.DnsServer#</td>
	            <td>#DnsChange.Type#</td>
				<td>#DnsChange.Status#</td>
                <td>#DnsChange.OldRecord.Value#</td>
	            <td>#DnsChange.NewRecord.Value#</td>
	        </tr>
	    	</ad:foreach>
	    </tbody>
	</table>
	
    </ad:foreach>

<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'HtmlBody', @DomainLookupLetterHtmlBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @DomainLookupLetterHtmlBody WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'HtmlBody'
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'Subject', N'MX and NS changes notification')
END
GO

DECLARE @DomainLookupLetterTextBody nvarchar(2500)

Set @DomainLookupLetterTextBody = N'=================================
   MX and NS Changes Information
=================================
<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

Please, find below details of MX and NS changes.


<ad:foreach collection="#Domains#" var="Domain" index="i">

 #Domain.DomainName# - #DomainUsers[Domain.PackageId].FirstName# #DomainUsers[Domain.PackageId].LastName#
 Registrar:      #iif(isnull(Domain.Registrar), "", Domain.Registrar)#
 ExpirationDate: #iif(isnull(Domain.ExpirationDate), "", Domain.ExpirationDate)#

        <ad:foreach collection="#Domain.DnsChanges#" var="DnsChange" index="j">
            DNS:       #DnsChange.DnsServer#
            Type:      #DnsChange.Type#
	    Status:    #DnsChange.Status#
            Old Value: #DnsChange.OldRecord.Value#
            New Value: #DnsChange.NewRecord.Value#

    	</ad:foreach>
</ad:foreach>



If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards
'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'TextBody',@DomainLookupLetterTextBody )
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @DomainLookupLetterTextBody WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'TextBody'
GO



IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'NoChangesHtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'NoChangesHtmlBody', N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>MX and NS Changes Information</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">

<a name="top"></a>
<div class="Header">
	MX and NS Changes Information
</div>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
No MX and NS changes have been found.
</p>

<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'DomainLookupLetter' AND [PropertyName]= N'NoChangesTextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'DomainLookupLetter', N'NoChangesTextBody', N'=================================
   MX and NS Changes Information
=================================
<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

No MX and NS changes have been founded.

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards
')
END
GO


-- Procedures for Domain lookup service

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetAllPackages')
DROP PROCEDURE GetAllPackages
GO
CREATE PROCEDURE [dbo].[GetAllPackages]
AS
SELECT
	   [PackageID]
      ,[ParentPackageID]
      ,[UserID]
      ,[PackageName]
      ,[PackageComments]
      ,[ServerID]
      ,[StatusID]
      ,[PlanID]
      ,[PurchaseDate]
      ,[OverrideQuotas]
      ,[BandwidthUpdated]
  FROM [dbo].[Packages]
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetScheduleTaskEmailTemplate')
DROP PROCEDURE GetScheduleTaskEmailTemplate
GO
CREATE PROCEDURE [dbo].GetScheduleTaskEmailTemplate
(
	@TaskID [nvarchar](100) 
)
AS
SELECT
	[TaskID],
	[From] ,
	[Subject] ,
	[Template]
  FROM [dbo].[ScheduleTasksEmailTemplates] where [TaskID] = @TaskID 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomainDnsRecords')
DROP PROCEDURE GetDomainDnsRecords
GO
CREATE PROCEDURE [dbo].GetDomainDnsRecords
(
	@DomainId INT,
	@RecordType INT
)
AS
SELECT
	ID,
	DomainId,
	DnsServer,
	RecordType,
	Value,
	Date
  FROM [dbo].[DomainDnsRecords]
  WHERE [DomainId]  = @DomainId AND [RecordType] = @RecordType
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomainAllDnsRecords')
DROP PROCEDURE GetDomainAllDnsRecords
GO
CREATE PROCEDURE [dbo].GetDomainAllDnsRecords
(
	@DomainId INT
)
AS
SELECT
	ID,
	DomainId,
	DnsServer,
	RecordType,
	Value,
	Date
  FROM [dbo].[DomainDnsRecords]
  WHERE [DomainId]  = @DomainId 
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddDomainDnsRecord')
DROP PROCEDURE AddDomainDnsRecord
GO
CREATE PROCEDURE [dbo].[AddDomainDnsRecord]
(
	@DomainId INT,
	@RecordType INT,
	@DnsServer NVARCHAR(255),
	@Value NVARCHAR(255),
	@Date DATETIME
)
AS

INSERT INTO DomainDnsRecords
(
	DomainId,
	DnsServer,
	RecordType,
	Value,
	Date
)
VALUES
(
	@DomainId,
	@DnsServer,
	@RecordType,
	@Value,
	@Date
)
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteDomainDnsRecord')
DROP PROCEDURE DeleteDomainDnsRecord
GO
CREATE PROCEDURE [dbo].[DeleteDomainDnsRecord]
(
	@Id  INT
)
AS
DELETE FROM DomainDnsRecords
WHERE Id = @Id
GO

--Domain Expiration Stored Procedures

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateDomainCreationDate')
DROP PROCEDURE UpdateDomainCreationDate
GO
CREATE PROCEDURE [dbo].UpdateDomainCreationDate
(
	@DomainId INT,
	@Date DateTime
)
AS
UPDATE [dbo].[Domains] SET [CreationDate] = @Date WHERE [DomainID] = @DomainId
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateDomainExpirationDate')
DROP PROCEDURE UpdateDomainExpirationDate
GO
CREATE PROCEDURE [dbo].UpdateDomainExpirationDate
(
	@DomainId INT,
	@Date DateTime
)
AS
UPDATE [dbo].[Domains] SET [ExpirationDate] = @Date WHERE [DomainID] = @DomainId
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateDomainLastUpdateDate')
DROP PROCEDURE UpdateDomainLastUpdateDate
GO
CREATE PROCEDURE [dbo].UpdateDomainLastUpdateDate
(
	@DomainId INT,
	@Date DateTime
)
AS
UPDATE [dbo].[Domains] SET [LastUpdateDate] = @Date WHERE [DomainID] = @DomainId
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateDomainDates')
DROP PROCEDURE UpdateDomainDates
GO
CREATE PROCEDURE [dbo].UpdateDomainDates
(
	@DomainId INT,
	@DomainCreationDate DateTime,
	@DomainExpirationDate DateTime,
	@DomainLastUpdateDate DateTime 
)
AS
UPDATE [dbo].[Domains] SET [CreationDate] = @DomainCreationDate, [ExpirationDate] = @DomainExpirationDate, [LastUpdateDate] = @DomainLastUpdateDate WHERE [DomainID] = @DomainId
GO


--Updating Domain procedures

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomains')
DROP PROCEDURE GetDomains
GO
CREATE PROCEDURE [dbo].[GetDomains]
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
	D.CreationDate,
	D.ExpirationDate,
	D.LastUpdateDate,
	D.IsDomainPointer
FROM Domains AS D
INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON D.PackageID = PT.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
RETURN

GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomainsPaged')
DROP PROCEDURE GetDomainsPaged
GO
CREATE PROCEDURE [dbo].[GetDomainsPaged]
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
	D.ExpirationDate,
	D.LastUpdateDate,
	P.PackageName,
	ISNULL(SRV.ServerID, 0) AS ServerID,
	ISNULL(SRV.ServerName, '''') AS ServerName,
	ISNULL(SRV.Comments, '''') AS ServerComments,
	ISNULL(SRV.VirtualServer, 0) AS VirtualServer,
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


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServersPaged')
DROP PROCEDURE GetRDSServersPaged
GO
CREATE PROCEDURE [dbo].[GetRDSServersPaged]
(
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@ItemID int,
	@IgnoreItemId bit,
	@RdsCollectionId int,
	@IgnoreRdsCollectionId bit,
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

SET @sql = '

DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows

DECLARE @RDSServer TABLE
(
	ItemPosition int IDENTITY(0,1),
	RDSServerId int
)
INSERT INTO @RDSServer (RDSServerId)
SELECT
	S.ID
FROM RDSServers AS S
WHERE 
	((((@ItemID is Null AND S.ItemID is null) or @IgnoreItemId = 1)
		or (@ItemID is not Null AND S.ItemID = @ItemID))
	and
	(((@RdsCollectionId is Null AND S.RDSCollectionId is null) or @IgnoreRdsCollectionId = 1)
		or (@RdsCollectionId is not Null AND S.RDSCollectionId = @RdsCollectionId)))'

IF @FilterColumn <> '' AND @FilterValue <> ''
SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(RDSServerId) FROM @RDSServer;
SELECT
	ST.ID,
	ST.ItemID,
	ST.Name, 
	ST.FqdName,
	ST.Description,
	ST.RdsCollectionId,
	SI.ItemName,
	ST.ConnectionEnabled
FROM @RDSServer AS S
INNER JOIN RDSServers AS ST ON S.RDSServerId = ST.ID
LEFT OUTER JOIN  ServiceItems AS SI ON SI.ItemId = ST.ItemId
WHERE S.ItemPosition BETWEEN @StartRow AND @EndRow'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int,  @FilterValue nvarchar(50),  @ItemID int, @RdsCollectionId int, @IgnoreItemId bit, @IgnoreRdsCollectionId bit',
@StartRow, @MaximumRows,  @FilterValue,  @ItemID, @RdsCollectionId, @IgnoreItemId , @IgnoreRdsCollectionId 


RETURN

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateRDSServer')
DROP PROCEDURE UpdateRDSServer
GO
CREATE PROCEDURE [dbo].[UpdateRDSServer]
(
	@Id  INT,
	@ItemID INT,
	@Name NVARCHAR(255),
	@FqdName NVARCHAR(255),
	@Description NVARCHAR(255),
	@RDSCollectionId INT,
	@ConnectionEnabled BIT
)
AS

UPDATE RDSServers
SET
	ItemID = @ItemID,
	Name = @Name,
	FqdName = @FqdName,
	Description = @Description,
	RDSCollectionId = @RDSCollectionId,
	ConnectionEnabled = @ConnectionEnabled
WHERE ID = @Id
GO


-- fix Windows 2012 Provider
BEGIN
UPDATE [dbo].[Providers] SET [EditorControl] = 'Windows2012' WHERE [ProviderName] = 'Windows2012'
END
GO

-- fix check domain used by HostedOrganization

ALTER PROCEDURE [dbo].[CheckDomainUsedByHostedOrganization] 
	@DomainName nvarchar(100),
	@Result int OUTPUT
AS
	SET @Result = 0
	IF EXISTS(SELECT 1 FROM ExchangeAccounts WHERE UserPrincipalName LIKE '%@'+ @DomainName AND AccountType!=2)
	BEGIN
		SET @Result = 1
	END
	ELSE
	IF EXISTS(SELECT 1 FROM ExchangeAccountEmailAddresses WHERE EmailAddress LIKE '%@'+ @DomainName)
	BEGIN
		SET @Result = 1
	END
	ELSE
	IF EXISTS(SELECT 1 FROM LyncUsers WHERE SipAddress LIKE '%@'+ @DomainName)
	BEGIN
		SET @Result = 1
	END
		
	RETURN @Result
GO


-- check domain used by hosted organization

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationObjectsByDomain')
DROP PROCEDURE GetOrganizationObjectsByDomain
GO

CREATE PROCEDURE [dbo].[GetOrganizationObjectsByDomain]
(
        @ItemID int,
        @DomainName nvarchar(100)
)
AS
SELECT
	'ExchangeAccounts' as ObjectName,
        AccountID as ObjectID,
	AccountType as ObjectType,
        DisplayName as DisplayName,
	0 as OwnerID
FROM
        ExchangeAccounts
WHERE
	UserPrincipalName LIKE '%@'+ @DomainName AND AccountType!=2
UNION
SELECT
	'ExchangeAccountEmailAddresses' as ObjectName,
	eam.AddressID as ObjectID,
	ea.AccountType as ObjectType,
	eam.EmailAddress as DisplayName,
	eam.AccountID as OwnerID
FROM
	ExchangeAccountEmailAddresses as eam
INNER JOIN 
	ExchangeAccounts ea
ON 
	ea.AccountID = eam.AccountID
WHERE
	(ea.PrimaryEmailAddress != eam.EmailAddress)
	AND (ea.UserPrincipalName != eam.EmailAddress)
	AND (eam.EmailAddress LIKE '%@'+ @DomainName)
UNION
SELECT 
	'LyncUsers' as ObjectName,
	ea.AccountID as ObjectID,
	ea.AccountType as ObjectType,
	ea.DisplayName as DisplayName,
	0 as OwnerID
FROM 
	ExchangeAccounts ea 
INNER JOIN 
	LyncUsers ou
ON 
	ea.AccountID = ou.AccountID
WHERE 
	ou.SipAddress LIKE '%@'+ @DomainName
ORDER BY 
	DisplayName
RETURN
GO
IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'RegistrarName' AND [object_id] = OBJECT_ID(N'Domains'))
BEGIN
	ALTER TABLE [dbo].[Domains] ADD RegistrarName nvarchar(max);
END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateWhoisDomainInfo')
DROP PROCEDURE UpdateWhoisDomainInfo
GO
CREATE PROCEDURE [dbo].UpdateWhoisDomainInfo
(
	@DomainId INT,
	@DomainCreationDate DateTime,
	@DomainExpirationDate DateTime,
	@DomainLastUpdateDate DateTime,
	@DomainRegistrarName nvarchar(max)
)
AS
UPDATE [dbo].[Domains] SET [CreationDate] = @DomainCreationDate, [ExpirationDate] = @DomainExpirationDate, [LastUpdateDate] = @DomainLastUpdateDate, [RegistrarName] = @DomainRegistrarName WHERE [DomainID] = @DomainId
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomainsPaged')
DROP PROCEDURE GetDomainsPaged
GO
CREATE PROCEDURE [dbo].[GetDomainsPaged]
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
DECLARE @sql nvarchar(2500)

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

IF @FilterValue <> ''
BEGIN
	IF @FilterColumn <> ''
	BEGIN
		SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '
	END
	ELSE
		SET @sql = @sql + '
		AND (DomainName LIKE @FilterValue 
		OR Username LIKE @FilterValue
		OR ServerName LIKE @FilterValue
		OR PackageName LIKE @FilterValue) '
END

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
	D.ExpirationDate,
	D.LastUpdateDate,
	D.RegistrarName,
	P.PackageName,
	ISNULL(SRV.ServerID, 0) AS ServerID,
	ISNULL(SRV.ServerName, '''') AS ServerName,
	ISNULL(SRV.Comments, '''') AS ServerComments,
	ISNULL(SRV.VirtualServer, 0) AS VirtualServer,
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




IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetDomains')
DROP PROCEDURE GetDomains
GO
CREATE PROCEDURE [dbo].[GetDomains]
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
	D.CreationDate,
	D.ExpirationDate,
	D.LastUpdateDate,
	D.IsDomainPointer,
	D.RegistrarName
FROM Domains AS D
INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON D.PackageID = PT.PackageID
LEFT OUTER JOIN ServiceItems AS WS ON D.WebSiteID = WS.ItemID
LEFT OUTER JOIN ServiceItems AS MD ON D.MailDomainID = MD.ItemID
LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
RETURN

GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Packages' AND COLS.name='DefaultTopPackage')
BEGIN
ALTER TABLE [dbo].[Packages] ADD
	[DefaultTopPackage] [bit] DEFAULT 0 NOT NULL
END
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetMyPackages')
DROP PROCEDURE GetMyPackages
GO
CREATE PROCEDURE [dbo].[GetMyPackages]
(
	@ActorID int,
	@UserID int
)
AS

-- check rights
IF dbo.CheckActorUserRights(@ActorID, @UserID) = 0
RAISERROR('You are not allowed to access this account', 16, 1)

SELECT
	P.PackageID,
	P.ParentPackageID,
	P.PackageName,
	P.StatusID,
	P.PlanID,
	P.PurchaseDate,
	
	dbo.GetItemComments(P.PackageID, 'PACKAGE', @ActorID) AS Comments,
	
	-- server
	ISNULL(P.ServerID, 0) AS ServerID,
	ISNULL(S.ServerName, 'None') AS ServerName,
	ISNULL(S.Comments, '') AS ServerComments,
	ISNULL(S.VirtualServer, 1) AS VirtualServer,
	
	-- hosting plan
	HP.PlanName,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email,

	P.DefaultTopPackage
FROM Packages AS P
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
LEFT OUTER JOIN Servers AS S ON P.ServerID = S.ServerID
LEFT OUTER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE P.UserID = @UserID
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetPackages')
DROP PROCEDURE GetPackages
GO
CREATE PROCEDURE [dbo].[GetPackages]
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
	U.Email,

	P.DefaultTopPackage
FROM Packages AS P
INNER JOIN Users AS U ON P.UserID = U.UserID
INNER JOIN Servers AS S ON P.ServerID = S.ServerID
INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE
	P.UserID = @UserID	
RETURN

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetPackage')
DROP PROCEDURE GetPackage
GO
CREATE PROCEDURE [dbo].[GetPackage]
(
	@PackageID int,
	@ActorID int
)
AS

-- Note: ActorID is not verified
-- check both requested and parent package

SELECT
	P.PackageID,
	P.ParentPackageID,
	P.UserID,
	P.PackageName,
	P.PackageComments,
	P.ServerID,
	P.StatusID,
	P.PlanID,
	P.PurchaseDate,
	P.OverrideQuotas,
	P.DefaultTopPackage
FROM Packages AS P
WHERE P.PackageID = @PackageID
RETURN

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdatePackage')
DROP PROCEDURE UpdatePackage
GO
CREATE PROCEDURE [dbo].[UpdatePackage]
(
	@ActorID int,
	@PackageID int,
	@PackageName nvarchar(300),
	@PackageComments ntext,
	@StatusID int,
	@PlanID int,
	@PurchaseDate datetime,
	@OverrideQuotas bit,
	@QuotasXml ntext,
	@DefaultTopPackage bit
)
AS

-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

BEGIN TRAN

DECLARE @ParentPackageID int
DECLARE @OldPlanID int

SELECT @ParentPackageID = ParentPackageID, @OldPlanID = PlanID FROM Packages
WHERE PackageID = @PackageID

-- update package
UPDATE Packages SET
	PackageName = @PackageName,
	PackageComments = @PackageComments,
	StatusID = @StatusID,
	PlanID = @PlanID,
	PurchaseDate = @PurchaseDate,
	OverrideQuotas = @OverrideQuotas,
	DefaultTopPackage = @DefaultTopPackage
WHERE
	PackageID = @PackageID

-- update quotas (if required)
EXEC UpdatePackageQuotas @ActorID, @PackageID, @QuotasXml

-- check resulting quotas
DECLARE @ExceedingQuotas AS TABLE (QuotaID int, QuotaName nvarchar(50), QuotaValue int)

-- check exceeding quotas if plan has been changed
IF (@OldPlanID <> @PlanID) OR (@OverrideQuotas = 1)
BEGIN
	INSERT INTO @ExceedingQuotas
	SELECT * FROM dbo.GetPackageExceedingQuotas(@ParentPackageID) WHERE QuotaValue > 0
END

SELECT * FROM @ExceedingQuotas

IF EXISTS(SELECT * FROM @ExceedingQuotas)
BEGIN
	ROLLBACK TRAN
	RETURN
END


COMMIT TRAN
RETURN

GO


-- WebDAv portal

IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'WebDavAccessTokens')
DROP TABLE WebDavAccessTokens
GO
CREATE TABLE WebDavAccessTokens
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	FilePath NVARCHAR(MAX) NOT NULL,
	AuthData NVARCHAR(MAX) NOT NULL,
	AccessToken UNIQUEIDENTIFIER NOT NULL,
	ExpirationDate DATETIME NOT NULL,
	AccountID INT NOT NULL ,
	ItemId INT NOT NULL
)
GO

ALTER TABLE [dbo].[WebDavAccessTokens]  WITH CHECK ADD  CONSTRAINT [FK_WebDavAccessTokens_UserId] FOREIGN KEY([AccountID])
REFERENCES [dbo].[ExchangeAccounts] ([AccountID])
ON DELETE CASCADE
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddWebDavAccessToken')
DROP PROCEDURE AddWebDavAccessToken
GO
CREATE PROCEDURE [dbo].[AddWebDavAccessToken]
(
	@TokenID INT OUTPUT,
	@FilePath NVARCHAR(MAX),
	@AccessToken UNIQUEIDENTIFIER,
	@AuthData NVARCHAR(MAX),
	@ExpirationDate DATETIME,
	@AccountID INT,
	@ItemId INT
)
AS
INSERT INTO WebDavAccessTokens
(
	FilePath,
	AccessToken,
	AuthData,
	ExpirationDate,
	AccountID  ,
	ItemId
)
VALUES
(
	@FilePath ,
	@AccessToken  ,
	@AuthData,
	@ExpirationDate ,
	@AccountID,
	@ItemId
)

SET @TokenID = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteExpiredWebDavAccessTokens')
DROP PROCEDURE DeleteExpiredWebDavAccessTokens
GO
CREATE PROCEDURE [dbo].[DeleteExpiredWebDavAccessTokens]
AS
DELETE FROM WebDavAccessTokens
WHERE ExpirationDate < getdate()
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetWebDavAccessTokenById')
DROP PROCEDURE GetWebDavAccessTokenById
GO
CREATE PROCEDURE [dbo].[GetWebDavAccessTokenById]
(
	@Id int
)
AS
SELECT 
	ID ,
	FilePath ,
	AuthData ,
	AccessToken,
	ExpirationDate,
	AccountID,
	ItemId
	FROM WebDavAccessTokens 
	Where ID = @Id AND ExpirationDate > getdate()
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetWebDavAccessTokenByAccessToken')
DROP PROCEDURE GetWebDavAccessTokenByAccessToken
GO
CREATE PROCEDURE [dbo].[GetWebDavAccessTokenByAccessToken]
(
	@AccessToken UNIQUEIDENTIFIER
)
AS
SELECT 
	ID ,
	FilePath ,
	AuthData ,
	AccessToken,
	ExpirationDate,
	AccountID,
	ItemId
	FROM WebDavAccessTokens 
	Where AccessToken = @AccessToken AND ExpirationDate > getdate()
GO

--add Deleted Users Quota
IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.DeletedUsers')
BEGIN
	INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (495, 13, 6, N'HostedSolution.DeletedUsers', N'Deleted Users', 2, 0, NULL, NULL)
END

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaName] = 'HostedSolution.DeletedUsersBackupStorageSpace')
BEGIN
	INSERT [dbo].[Quotas]  ([QuotaID], [GroupID],[QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (496, 13, 6, N'HostedSolution.DeletedUsersBackupStorageSpace', N'Deleted Users Backup Storage Space, Mb', 2, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ExchangeDeletedAccounts')
CREATE TABLE ExchangeDeletedAccounts 
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AccountID INT NOT NULL,
	OriginAT INT NOT NULL,
	StoragePath NVARCHAR(255) NULL,
	FolderName NVARCHAR(128) NULL,
	FileName NVARCHAR(128) NULL,
	ExpirationDate DATETIME NOT NULL
)
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationStatistics')
DROP PROCEDURE [dbo].[GetOrganizationStatistics]
GO

CREATE PROCEDURE [dbo].[GetOrganizationStatistics]
(
	@ItemID int
)
AS
SELECT
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 7 OR AccountType = 1 OR AccountType = 6 OR AccountType = 5)  AND ItemID = @ItemID) AS CreatedUsers,
	(SELECT COUNT(*) FROM ExchangeOrganizationDomains WHERE ItemID = @ItemID) AS CreatedDomains,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE (AccountType = 8 OR AccountType = 9)  AND ItemID = @ItemID) AS CreatedGroups,
	(SELECT COUNT(*) FROM ExchangeAccounts WHERE AccountType = 11  AND ItemID = @ItemID) AS DeletedUsers
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteOrganizationDeletedUser')
DROP PROCEDURE [dbo].[DeleteOrganizationDeletedUser]
GO

CREATE PROCEDURE [dbo].[DeleteOrganizationDeletedUser]
(
	@ID int
)
AS
DELETE FROM	ExchangeDeletedAccounts WHERE AccountID = @ID
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetOrganizationDeletedUser')
DROP PROCEDURE [dbo].[GetOrganizationDeletedUser]
GO

CREATE PROCEDURE [dbo].[GetOrganizationDeletedUser]
(
	@AccountID int
)
AS
SELECT
	EDA.AccountID,
	EDA.OriginAT,
	EDA.StoragePath,
	EDA.FolderName,
	EDA.FileName,
	EDA.ExpirationDate
FROM
	ExchangeDeletedAccounts AS EDA
WHERE
	EDA.AccountID = @AccountID
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddOrganizationDeletedUser')
DROP PROCEDURE [dbo].[AddOrganizationDeletedUser]
GO

CREATE PROCEDURE [dbo].[AddOrganizationDeletedUser] 
(
	@ID int OUTPUT,
	@AccountID int,
	@OriginAT int,
	@StoragePath nvarchar(255),
	@FolderName nvarchar(128),
	@FileName nvarchar(128),
	@ExpirationDate datetime
)
AS

INSERT INTO ExchangeDeletedAccounts
(
	AccountID,
	OriginAT,
	StoragePath,
	FolderName,
	FileName,
	ExpirationDate
)
VALUES
(
	@AccountID,
	@OriginAT,
	@StoragePath,
	@FolderName,
	@FileName,
	@ExpirationDate
)

SET @ID = SCOPE_IDENTITY()

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
		DECLARE @QuotaName nvarchar(50)
		SELECT @QuotaTypeID = QuotaTypeID, @QuotaName = QuotaName FROM Quotas
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
		ELSE IF @QuotaID = 558 BEGIN -- RAM of VPS2012
			DECLARE @Result1 int
			SET @Result1 = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'RamSize' AND PT.ParentPackageID = @PackageID)
			DECLARE @Result2 int
			SET @Result2 = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN ServiceItemProperties AS SIP2 ON 
								SIP2.ItemID = SI.ItemID AND SIP2.PropertyName = 'DynamicMemory.Enabled' AND SIP2.PropertyValue = 'True'
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'DynamicMemory.Maximum' AND PT.ParentPackageID = @PackageID)
			SET @Result = CASE WHEN isnull(@Result1,0) > isnull(@Result2,0) THEN @Result1 ELSE @Result2 END
		END
		ELSE IF @QuotaID = 559 -- HDD of VPS2012
			SET @Result = (SELECT SUM(CAST(SIP.PropertyValue AS int)) FROM ServiceItemProperties AS SIP
							INNER JOIN ServiceItems AS SI ON SIP.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID
							WHERE SIP.PropertyName = 'HddSize' AND PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 562 -- External IP addresses of VPS2012
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
		ELSE IF @QuotaID = 430 -- Enterprise Storage
			SET @Result = (SELECT SUM(ESF.FolderQuota) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 431 -- Enterprise Storage Folders
			SET @Result = (SELECT COUNT(ESF.EnterpriseFolderID) FROM EnterpriseFolders AS ESF
							INNER JOIN ServiceItems  SI ON ESF.ItemID = SI.ItemID
							INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
							WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 423 -- HostedSolution.SecurityGroups
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND ea.AccountType IN (8,9))
		ELSE IF @QuotaID = 495 -- HostedSolution.DeletedUsers
			SET @Result = (SELECT COUNT(ea.AccountID) FROM ExchangeAccounts AS ea
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE pt.ParentPackageID = @PackageID AND ea.AccountType = 11)
		ELSE IF @QuotaID = 450
			SET @Result = (SELECT COUNT(DISTINCT(RCU.[AccountId])) FROM [dbo].[RDSCollectionUsers] RCU
				INNER JOIN ExchangeAccounts EA ON EA.AccountId = RCU.AccountId
				INNER JOIN ServiceItems  si ON ea.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 451
			SET @Result = (SELECT COUNT(RS.[ID]) FROM [dbo].[RDSServers] RS				
				INNER JOIN ServiceItems  si ON RS.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaID = 491
			SET @Result = (SELECT COUNT(RC.[ID]) FROM [dbo].[RDSCollections] RC
				INNER JOIN ServiceItems  si ON RC.ItemID = si.ItemID
				INNER JOIN PackagesTreeCache pt ON si.PackageID = pt.PackageID
				WHERE PT.ParentPackageID = @PackageID)
		ELSE IF @QuotaName like 'ServiceLevel.%' -- Support Service Level Quota
		BEGIN
			DECLARE @LevelID int

			SELECT @LevelID = LevelID FROM SupportServiceLevels
			WHERE LevelName = REPLACE(@QuotaName,'ServiceLevel.','')

			IF (@LevelID IS NOT NULL)
			SET @Result = (SELECT COUNT(EA.AccountID)
				FROM SupportServiceLevels AS SL
				INNER JOIN ExchangeAccounts AS EA ON SL.LevelID = EA.LevelID
				INNER JOIN ServiceItems  SI ON EA.ItemID = SI.ItemID
				INNER JOIN PackagesTreeCache PT ON SI.PackageID = PT.PackageID
				WHERE EA.LevelID = @LevelID AND PT.ParentPackageID = @PackageID)
			ELSE SET @Result = 0
		END
		ELSE
			SET @Result = (SELECT COUNT(SI.ItemID) FROM Quotas AS Q
			INNER JOIN ServiceItems AS SI ON SI.ItemTypeID = Q.ItemTypeID
			INNER JOIN PackagesTreeCache AS PT ON SI.PackageID = PT.PackageID AND PT.ParentPackageID = @PackageID
			WHERE Q.QuotaID = @QuotaID)

		RETURN @Result
	END
GO

IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='ExchangeMailboxPlans' AND COLS.name='EnableForceArchiveDeletion')
BEGIN
	ALTER TABLE [dbo].[ExchangeMailboxPlans] ADD [EnableForceArchiveDeletion] [bit] NULL
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
	@LitigationHoldMsg nvarchar(512),
	@Archiving bit,
	@EnableArchiving bit,
	@ArchiveSizeMB int,
	@ArchiveWarningPct int,
	@EnableForceArchiveDeletion bit
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
	LitigationHoldMsg,
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct,
	EnableForceArchiveDeletion
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
	@LitigationHoldMsg,
	@Archiving,
	@EnableArchiving,
	@ArchiveSizeMB,
	@ArchiveWarningPct,
	@EnableForceArchiveDeletion
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
	@LitigationHoldMsg nvarchar(512),
	@Archiving bit,
	@EnableArchiving bit,
	@ArchiveSizeMB int,
	@ArchiveWarningPct int,
	@EnableForceArchiveDeletion bit
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
	LitigationHoldMsg = @LitigationHoldMsg,
	Archiving = @Archiving,
	EnableArchiving = @EnableArchiving,
	ArchiveSizeMB = @ArchiveSizeMB,
	ArchiveWarningPct = @ArchiveWarningPct,
	EnableForceArchiveDeletion = @EnableForceArchiveDeletion
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
	LitigationHoldMsg,
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct,
	EnableForceArchiveDeletion
FROM
	ExchangeMailboxPlans
WHERE
	MailboxPlanId = @MailboxPlanId
RETURN
GO

ALTER PROCEDURE [dbo].[GetExchangeMailboxPlans]
(
	@ItemID int,
	@Archiving bit
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
	Archiving,
	EnableArchiving,
	ArchiveSizeMB,
	ArchiveWarningPct,
	EnableForceArchiveDeletion
FROM
	ExchangeMailboxPlans
WHERE
	ItemID = @ItemID 
AND ((Archiving=@Archiving) OR ((@Archiving=0) AND (Archiving IS NULL)))
ORDER BY MailboxPlan
RETURN
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTasks] WHERE [TaskID] = 'SCHEDULE_TASK_DELETE_EXCHANGE_ACCOUNTS')
BEGIN
INSERT INTO [dbo].[ScheduleTasks] ([TaskID], [TaskType], [RoleID]) VALUES (N'SCHEDULE_TASK_DELETE_EXCHANGE_ACCOUNTS', N'WebsitePanel.EnterpriseServer.DeleteExchangeAccountsTask, WebsitePanel.EnterpriseServer.Code', 3)
END
GO





ALTER PROCEDURE [dbo].[UpdateServiceItem]
(
	@ActorID int,
	@ItemID int,
	@ItemName nvarchar(500),
	@XmlProperties ntext
)
AS
BEGIN TRAN

-- check rights
DECLARE @PackageID int
SELECT PackageID = @PackageID FROM ServiceItems
WHERE ItemID = @ItemID

IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- update item
UPDATE ServiceItems SET ItemName = @ItemName
WHERE ItemID=@ItemID

DECLARE @idoc int
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @idoc OUTPUT, @XmlProperties

-- Execute a SELECT statement that uses the OPENXML rowset provider.
DELETE FROM ServiceItemProperties
WHERE ItemID = @ItemID

-- Add the xml data into a temp table for the capability and robust
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL DROP TABLE #TempTable

CREATE TABLE #TempTable(
	ItemID int,
	PropertyName nvarchar(50),
	PropertyValue  nvarchar(3000))

INSERT INTO #TempTable (ItemID, PropertyName, PropertyValue)
SELECT
	@ItemID,
	PropertyName,
	PropertyValue
FROM OPENXML(@idoc, '/properties/property',1) WITH 
(
	PropertyName nvarchar(50) '@name',
	PropertyValue nvarchar(3000) '@value'
) as PV

-- Move data from temp table to real table
INSERT INTO ServiceItemProperties
(
	ItemID,
	PropertyName,
	PropertyValue
)
SELECT 
	ItemID, 
	PropertyName, 
	PropertyValue
FROM #TempTable

DROP TABLE #TempTable

-- remove document
exec sp_xml_removedocument @idoc

COMMIT TRAN

RETURN 
GO


-- Password column removed
IF OBJECTPROPERTY(object_id('dbo.GetExchangeAccountByAccountNameWithoutItemId'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[GetExchangeAccountByAccountNameWithoutItemId]
GO
CREATE PROCEDURE [dbo].[GetExchangeAccountByAccountNameWithoutItemId] 
(
	@UserPrincipalName nvarchar(300)
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
	E.MailboxPlanId,
	P.MailboxPlan,
	E.SubscriberNumber,
	E.UserPrincipalName,
	E.ArchivingMailboxPlanId, 
	AP.MailboxPlan as 'ArchivingMailboxPlan',
	E.EnableArchiving
FROM
	ExchangeAccounts AS E
LEFT OUTER JOIN ExchangeMailboxPlans AS P ON E.MailboxPlanId = P.MailboxPlanId	
LEFT OUTER JOIN ExchangeMailboxPlans AS AP ON E.ArchivingMailboxPlanId = AP.MailboxPlanId
WHERE
	E.UserPrincipalName = @UserPrincipalName
RETURN
GO



--Webdav portal users settings

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'WebDavPortalUsersSettings')
CREATE TABLE WebDavPortalUsersSettings
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AccountId INT NOT NULL,
	Settings NVARCHAR(max)
)
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_WebDavPortalUsersSettings_UserId')
ALTER TABLE [dbo].[WebDavPortalUsersSettings]
DROP CONSTRAINT [FK_WebDavPortalUsersSettings_UserId]
GO

ALTER TABLE [dbo].[WebDavPortalUsersSettings]  WITH CHECK ADD  CONSTRAINT [FK_WebDavPortalUsersSettings_UserId] FOREIGN KEY([AccountID])
REFERENCES [dbo].[ExchangeAccounts] ([AccountID])
ON DELETE CASCADE
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetWebDavPortalUsersSettingsByAccountId')
DROP PROCEDURE GetWebDavPortalUsersSettingsByAccountId
GO
CREATE PROCEDURE [dbo].[GetWebDavPortalUsersSettingsByAccountId]
(
	@AccountId INT
)
AS
SELECT TOP 1
	US.Id,
	US.AccountId,
	US.Settings
	FROM WebDavPortalUsersSettings AS US
	WHERE AccountId = @AccountId
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddWebDavPortalUsersSettings')
DROP PROCEDURE AddWebDavPortalUsersSettings
GO
CREATE PROCEDURE [dbo].[AddWebDavPortalUsersSettings]
(
	@WebDavPortalUsersSettingsId INT OUTPUT,
	@AccountId INT,
	@Settings NVARCHAR(max)
)
AS

INSERT INTO WebDavPortalUsersSettings
(
	AccountId,
	Settings
)
VALUES
(
	@AccountId,
	@Settings
)

SET @WebDavPortalUsersSettingsId = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateWebDavPortalUsersSettings')
DROP PROCEDURE UpdateWebDavPortalUsersSettings
GO
CREATE PROCEDURE [dbo].[UpdateWebDavPortalUsersSettings]
(
	@AccountId INT,
	@Settings NVARCHAR(max)
)
AS

UPDATE WebDavPortalUsersSettings
SET
	Settings = @Settings
WHERE AccountId = @AccountId
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'SmarterMail 10.x +')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES(66, 4, N'SmarterMail', N'SmarterMail 10.x +', N'WebsitePanel.Providers.Mail.SmarterMail10, WebsitePanel.Providers.Mail.SmarterMail10', N'SmarterMail100', NULL)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [EditorControl] = 'SmarterMail100' WHERE [DisplayName] = 'SmarterMail 10.x +'
END
GO


-- Service items count by name and serviceid

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetServiceItemsCountByNameAndServiceId')
DROP PROCEDURE GetServiceItemsCountByNameAndServiceId
GO

CREATE PROCEDURE [dbo].[GetServiceItemsCountByNameAndServiceId]
(
	@ActorID int,
	@ServiceId int,
	@ItemName nvarchar(500),
	@GroupName nvarchar(100) = NULL,
	@ItemTypeName nvarchar(200)
)
AS
SELECT Count(*)
FROM ServiceItems AS SI
INNER JOIN ServiceItemTypes AS SIT ON SI.ItemTypeID = SIT.ItemTypeID
INNER JOIN ResourceGroups AS RG ON SIT.GroupID = RG.GroupID
INNER JOIN Services AS S ON SI.ServiceID = S.ServiceID
WHERE S.ServiceID = @ServiceId 
AND SIT.TypeName = @ItemTypeName
AND SI.ItemName = @ItemName
AND ((@GroupName IS NULL) OR (@GroupName IS NOT NULL AND RG.GroupName = @GroupName))
RETURN 
GO

-- Hyper-V 2012 R2 Provider
IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE [GroupName] = 'VPS2012')
BEGIN
INSERT [dbo].[ResourceGroups] ([GroupID], [GroupName], [GroupOrder], [GroupController], [ShowGroup]) VALUES (33, N'VPS2012', 19, NULL, 1)

INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (41, 33, N'VirtualMachine', N'WebsitePanel.Providers.Virtualization.VirtualMachine, WebsitePanel.Providers.Base', 1, 0, 0, 1, 1, 1, 0, 0)

INSERT [dbo].[ServiceItemTypes] ([ItemTypeID], [GroupID], [DisplayName], [TypeName], [TypeOrder], [CalculateDiskspace], [CalculateBandwidth], [Suspendable], [Disposable], [Searchable], [Importable], [Backupable]) VALUES (42, 33, N'VirtualSwitch', N'WebsitePanel.Providers.Virtualization.VirtualSwitch, WebsitePanel.Providers.Base', 2, 0, 0, 1, 1, 1, 0, 0)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (553, 33, 1, N'VPS2012.ServersNumber', N'Number of VPS', 2, 0, 41, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (554, 33, 2, N'VPS2012.ManagingAllowed', N'Allow user to create VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (555, 33, 3, N'VPS2012.CpuNumber', N'Number of CPU cores', 3, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (556, 33, 7, N'VPS2012.BootCdAllowed', N'Boot from CD allowed', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (557, 33, 8, N'VPS2012.BootCdEnabled', N'Boot from CD', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (558, 33, 4, N'VPS2012.Ram', N'RAM size, MB', 2, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (559, 33, 5, N'VPS2012.Hdd', N'Hard Drive size, GB', 2, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (560, 33, 6, N'VPS2012.DvdEnabled', N'DVD drive', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (561, 33, 10, N'VPS2012.ExternalNetworkEnabled', N'External Network', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (562, 33, 11, N'VPS2012.ExternalIPAddressesNumber', N'Number of External IP addresses', 2, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (563, 33, 13, N'VPS2012.PrivateNetworkEnabled', N'Private Network', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (564, 33, 14, N'VPS2012.PrivateIPAddressesNumber', N'Number of Private IP addresses per VPS', 3, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (565, 33, 9, N'VPS2012.SnapshotsNumber', N'Number of Snaphots', 3, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (566, 33, 15, N'VPS2012.StartShutdownAllowed', N'Allow user to Start, Turn off and Shutdown VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (567, 33, 16, N'VPS2012.PauseResumeAllowed', N'Allow user to Pause, Resume VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (568, 33, 17, N'VPS2012.RebootAllowed', N'Allow user to Reboot VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (569, 33, 18, N'VPS2012.ResetAlowed', N'Allow user to Reset VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (570, 33, 19, N'VPS2012.ReinstallAllowed', N'Allow user to Re-install VPS', 1, 0, NULL, NULL)

INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (571, 33, 12, N'VPS2012.Bandwidth', N'Monthly bandwidth, GB', 2, 0, NULL, NULL)

END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Quotas] WHERE [QuotaID] = '572')
BEGIN
	INSERT [dbo].[Quotas] ([QuotaID], [GroupID], [QuotaOrder], [QuotaName], [QuotaDescription], [QuotaTypeID], [ServiceQuota], [ItemTypeID], [HideQuota]) VALUES (572, 33, 20, N'VPS2012.ReplicationEnabled', N'Allow user to Replication', 1, 0, NULL, NULL)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [ProviderName] = 'HyperV2012R2')
BEGIN
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) VALUES (350, 33, N'HyperV2012R2', N'Microsoft Hyper-V 2012 R2', N'WebsitePanel.Providers.Virtualization.HyperV2012R2, WebsitePanel.Providers.Virtualization.HyperV2012R2', N'HyperV2012R2', 1)
END
ELSE
BEGIN
UPDATE [dbo].[Providers] SET [EditorControl] = N'HyperV2012R2', [GroupID] = 33 WHERE [ProviderName] = 'HyperV2012R2'
END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetVirtualMachinesPagedForPC')
DROP PROCEDURE GetVirtualMachinesPagedForPC
GO
CREATE PROCEDURE [dbo].[GetVirtualMachinesPagedForPC]
(
	@ActorID int,
	@PackageID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int,
	@Recursive bit
)
AS


-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
BEGIN
	RAISERROR('You are not allowed to access this package', 16, 1)
	RETURN
END

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
SI.ItemTypeID = 35 -- VPS
AND ((@Recursive = 0 AND P.PackageID = @PackageID)
OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ItemName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + '''
			OR ExternalIP LIKE ''' + @FilterValue + '''
			OR IPAddress LIKE ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'SI.ItemName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(SI.ItemID) FROM Packages AS P
INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
WHERE ' + @condition + '

DECLARE @Items AS TABLE
(
	ItemID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		SI.ItemID
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN Users AS U ON P.UserID = U.UserID
	LEFT OUTER JOIN (
		SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
		INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
		WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
	) AS EIP ON SI.ItemID = EIP.ItemID
	LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
	WHERE ' + @condition + '
)

INSERT INTO @Items
SELECT ItemID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	SI.ItemID,
	SI.ItemName,
	SI.PackageID,
	P.PackageName,
	P.UserID,
	U.Username,

	EIP.ExternalIP,
	PIP.IPAddress
FROM @Items AS TSI
INNER JOIN ServiceItems AS SI ON TSI.ItemID = SI.ItemID
INNER JOIN Packages AS P ON SI.PackageID = P.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
'

--print @sql

exec sp_executesql @sql, N'@PackageID int, @StartRow int, @MaximumRows int, @Recursive bit',
@PackageID, @StartRow, @MaximumRows, @Recursive

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetVirtualMachinesPaged2012')
DROP PROCEDURE GetVirtualMachinesPaged2012
GO
CREATE PROCEDURE [dbo].[GetVirtualMachinesPaged2012]
(
	@ActorID int,
	@PackageID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int,
	@Recursive bit
)
AS
-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
SI.ItemTypeID = 41 -- VPS2012
AND ((@Recursive = 0 AND P.PackageID = @PackageID)
OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ItemName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + '''
			OR ExternalIP LIKE ''' + @FilterValue + '''
			OR IPAddress LIKE ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'SI.ItemName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(SI.ItemID) FROM Packages AS P
INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
WHERE ' + @condition + '

DECLARE @Items AS TABLE
(
	ItemID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		SI.ItemID
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN Users AS U ON P.UserID = U.UserID
	LEFT OUTER JOIN (
		SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
		INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
		WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
	) AS EIP ON SI.ItemID = EIP.ItemID
	LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
	WHERE ' + @condition + '
)

INSERT INTO @Items
SELECT ItemID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	SI.ItemID,
	SI.ItemName,
	SI.PackageID,
	P.PackageName,
	P.UserID,
	U.Username,

	EIP.ExternalIP,
	PIP.IPAddress
FROM @Items AS TSI
INNER JOIN ServiceItems AS SI ON TSI.ItemID = SI.ItemID
INNER JOIN Packages AS P ON SI.PackageID = P.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
'

--print @sql

exec sp_executesql @sql, N'@PackageID int, @StartRow int, @MaximumRows int, @Recursive bit',
@PackageID, @StartRow, @MaximumRows, @Recursive

RETURN 
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetVirtualMachinesPaged')
DROP PROCEDURE GetVirtualMachinesPaged
GO
CREATE PROCEDURE [dbo].[GetVirtualMachinesPaged]
(
	@ActorID int,
	@PackageID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int,
	@Recursive bit
)
AS


-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
SI.ItemTypeID = 33 -- VPS
AND ((@Recursive = 0 AND P.PackageID = @PackageID)
OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ItemName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + '''
			OR ExternalIP LIKE ''' + @FilterValue + '''
			OR IPAddress LIKE ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'SI.ItemName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(SI.ItemID) FROM Packages AS P
INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
WHERE ' + @condition + '

DECLARE @Items AS TABLE
(
	ItemID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		SI.ItemID
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN Users AS U ON P.UserID = U.UserID
	LEFT OUTER JOIN (
		SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
		INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
		WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
	) AS EIP ON SI.ItemID = EIP.ItemID
	LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
	WHERE ' + @condition + '
)

INSERT INTO @Items
SELECT ItemID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	SI.ItemID,
	SI.ItemName,
	SI.PackageID,
	P.PackageName,
	P.UserID,
	U.Username,

	EIP.ExternalIP,
	PIP.IPAddress
FROM @Items AS TSI
INNER JOIN ServiceItems AS SI ON TSI.ItemID = SI.ItemID
INNER JOIN Packages AS P ON SI.PackageID = P.PackageID
INNER JOIN Users AS U ON P.UserID = U.UserID
LEFT OUTER JOIN (
	SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
	INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
	WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
) AS EIP ON SI.ItemID = EIP.ItemID
LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
'

--print @sql

exec sp_executesql @sql, N'@PackageID int, @StartRow int, @MaximumRows int, @Recursive bit',
@PackageID, @StartRow, @MaximumRows, @Recursive

RETURN
GO

--ES OWA Editing
IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'EnterpriseFoldersOwaPermissions')
CREATE TABLE EnterpriseFoldersOwaPermissions
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ItemID INT NOT NULL,
	FolderID INT NOT NULL, 
	AccountID INT NOT NULL 
)
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_EnterpriseFoldersOwaPermissions_AccountId')
ALTER TABLE [dbo].[EnterpriseFoldersOwaPermissions]
DROP CONSTRAINT [FK_EnterpriseFoldersOwaPermissions_AccountId]
GO

ALTER TABLE [dbo].[EnterpriseFoldersOwaPermissions]  WITH CHECK ADD  CONSTRAINT [FK_EnterpriseFoldersOwaPermissions_AccountId] FOREIGN KEY([AccountID])
REFERENCES [dbo].[ExchangeAccounts] ([AccountID])
ON DELETE CASCADE
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_EnterpriseFoldersOwaPermissions_FolderId')
ALTER TABLE [dbo].[EnterpriseFoldersOwaPermissions]
DROP CONSTRAINT [FK_EnterpriseFoldersOwaPermissions_FolderId]
GO

ALTER TABLE [dbo].[EnterpriseFoldersOwaPermissions]  WITH CHECK ADD  CONSTRAINT [FK_EnterpriseFoldersOwaPermissions_FolderId] FOREIGN KEY([FolderID])
REFERENCES [dbo].[EnterpriseFolders] ([EnterpriseFolderID])
ON DELETE CASCADE
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteAllEnterpriseFolderOwaUsers')
DROP PROCEDURE DeleteAllEnterpriseFolderOwaUsers
GO
CREATE PROCEDURE [dbo].[DeleteAllEnterpriseFolderOwaUsers]
(
	@ItemID  int,
	@FolderID int
)
AS
DELETE FROM EnterpriseFoldersOwaPermissions
WHERE ItemId = @ItemID AND FolderID = @FolderID
GO





IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddEnterpriseFolderOwaUser')
DROP PROCEDURE AddEnterpriseFolderOwaUser
GO
CREATE PROCEDURE [dbo].[AddEnterpriseFolderOwaUser]
(
	@ESOwsaUserId INT OUTPUT,
	@ItemID INT,
	@FolderID INT, 
	@AccountID INT 
)
AS
INSERT INTO EnterpriseFoldersOwaPermissions
(
	ItemID ,
	FolderID, 
	AccountID
)
VALUES
(
	@ItemID,
	@FolderID, 
	@AccountID 
)

SET @ESOwsaUserId = SCOPE_IDENTITY()

RETURN
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetEnterpriseFolderOwaUsers')
DROP PROCEDURE GetEnterpriseFolderOwaUsers
GO
CREATE PROCEDURE [dbo].[GetEnterpriseFolderOwaUsers]
(
	@ItemID INT,
	@FolderID INT
)
AS
SELECT 
	EA.AccountID,
	EA.ItemID,
	EA.AccountType,
	EA.AccountName,
	EA.DisplayName,
	EA.PrimaryEmailAddress,
	EA.MailEnabledPublicFolder,
	EA.MailboxPlanId,
	EA.SubscriberNumber,
	EA.UserPrincipalName 
	FROM EnterpriseFoldersOwaPermissions AS EFOP
	LEFT JOIN  ExchangeAccounts AS EA ON EA.AccountID = EFOP.AccountID
	WHERE EFOP.ItemID = @ItemID AND EFOP.FolderID = @FolderID
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetEnterpriseFolderId')
DROP PROCEDURE GetEnterpriseFolderId
GO
CREATE PROCEDURE [dbo].[GetEnterpriseFolderId]
(
	@ItemID INT,
	@FolderName varchar(max)
)
AS
SELECT TOP 1
	EnterpriseFolderID
	FROM EnterpriseFolders
	WHERE ItemId = @ItemID AND FolderName = @FolderName
GO





IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetUserEnterpriseFolderWithOwaEditPermission')
DROP PROCEDURE GetUserEnterpriseFolderWithOwaEditPermission
GO
CREATE PROCEDURE [dbo].[GetUserEnterpriseFolderWithOwaEditPermission]
(
	@ItemID INT,
	@AccountID INT
)
AS
SELECT 
	EF.FolderName
	FROM EnterpriseFoldersOwaPermissions AS EFOP
	LEFT JOIN  [dbo].[EnterpriseFolders] AS EF ON EF.EnterpriseFolderID = EFOP.FolderID
	WHERE EFOP.ItemID = @ItemID AND EFOP.AccountID = @AccountID
GO


-- CRM2015 Provider

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted MS CRM 2015')
BEGIN
INSERT [dbo].[Providers] ([ProviderId], [GroupId], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery]) 
VALUES(1205, 24, N'CRM', N'Hosted MS CRM 2015', N'WebsitePanel.Providers.HostedSolution.CRMProvider2015, WebsitePanel.Providers.HostedSolution.Crm2015', N'CRM2011', NULL)
END
GO

-- RDS Setup Instructions

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'CC' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'CC', N'support@HostingCompany.com')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @RDSSetupLetterHtmlBody nvarchar(2500)

Set @RDSSetupLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>RDS Setup Information</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">

<a name="top"></a>
<div class="Header">
	RDS Setup Information
</div>
</div>
</body>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'HtmlBody', @RDSSetupLetterHtmlBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @RDSSetupLetterHtmlBody WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'HtmlBody'
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'Subject', N'RDS setup')
END
GO

DECLARE @RDSSetupLetterTextBody nvarchar(2500)

Set @RDSSetupLetterTextBody = N'=================================
   RDS Setup Information
=================================
<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

Please, find below RDS setup instructions.

If you have any questions, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'RDSSetupLetter', N'TextBody', @RDSSetupLetterTextBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @RDSSetupLetterTextBody WHERE [UserID] = 1 AND [SettingsName]= N'RDSSetupLetter' AND [PropertyName]= N'TextBody'
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ResourceGroups] WHERE GroupName = 'Sharepoint Foundation Server')
BEGIN	
	DECLARE @group_order AS INT
	DECLARE @group_controller AS NVARCHAR(1000)
	DECLARE @group_id AS INT
	DECLARE @provider_id AS INT

	UPDATE [dbo].[ResourceGroups] SET GroupName = 'Sharepoint Foundation Server' WHERE GroupName = 'Hosted Sharepoint'
	SELECT @group_order = GroupOrder, @group_controller = GroupController FROM [dbo].[ResourceGroups] WHERE GroupName = 'Sharepoint Foundation Server'	
	SELECT TOP 1 @group_id = GroupId + 1 From [dbo].[ResourceGroups] ORDER BY GroupID DESC
	SELECT TOP 1 @provider_id = ProviderId + 1 From [dbo].[Providers] ORDER BY ProviderID DESC
	UPDATE [dbo].[ResourceGroups] SET GroupOrder = GroupOrder + 1 WHERE GroupOrder > @group_order
	INSERT INTO [dbo].[ResourceGroups] (GroupID, GroupName, GroupOrder, GroupController, ShowGroup) VALUES (@group_id, 'Sharepoint Server', @group_order + 1, @group_controller, 1)
	INSERT INTO [dbo].[Providers] (ProviderID, GroupID, ProviderName, DisplayName, ProviderType, EditorControl, DisableAutoDiscovery)
		(SELECT @provider_id, @group_id, ProviderName, DisplayName, ProviderType, EditorControl, DisableAutoDiscovery FROM [dbo].[Providers] WHERE ProviderName = 'HostedSharePoint2013')

	INSERT INTO [dbo].[Quotas] (QuotaID, GroupID, QuotaOrder, QuotaName, QuotaDescription, QuotaTypeID, ServiceQuota)
		VALUES (550, @group_id, 1, 'HostedSharePointServer.Sites', 'SharePoint Site Collections', 2, 0)
	INSERT INTO [dbo].[Quotas] (QuotaID, GroupID, QuotaOrder, QuotaName, QuotaDescription, QuotaTypeID, ServiceQuota)
		VALUES (551, @group_id, 2, 'HostedSharePointServer.MaxStorage', 'Max site storage, MB', 3, 0)
	INSERT INTO [dbo].[Quotas] (QuotaID, GroupID, QuotaOrder, QuotaName, QuotaDescription, QuotaTypeID, ServiceQuota)
		VALUES (552, @group_id, 3, 'HostedSharePointServer.UseSharedSSL', 'Use shared SSL Root', 1, 0)
END

GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetLyncUsers')
DROP PROCEDURE GetLyncUsers
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetLyncUsers]
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

set @sql = '
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
		ea.ItemID = @ItemID ' + @condition

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

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'SearchOrganizationAccounts')
DROP PROCEDURE SearchOrganizationAccounts
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SearchOrganizationAccounts]
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
	EA.UserPrincipalName,
	(CASE WHEN LU.AccountID IS NULL THEN ''false'' ELSE ''true'' END) as IsLyncUser
FROM ExchangeAccounts AS EA
LEFT JOIN LyncUsers AS LU
ON LU.AccountID = EA.AccountID
WHERE ' + @condition

print @sql

exec sp_executesql @sql, N'@ItemID int, @IncludeMailboxes bit', 
@ItemID, @IncludeMailboxes

RETURN 

GO


-- RDS GPO

IF NOT EXISTS(SELECT * FROM SYS.TABLES WHERE name = 'RDSServerSettings')
CREATE TABLE [dbo].[RDSServerSettings](
	[RdsServerId] [int] NOT NULL,
	[SettingsName] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[PropertyName] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[PropertyValue] [ntext] COLLATE Latin1_General_CI_AS NULL,
	[ApplyUsers] [BIT] NOT NULL,
	[ApplyAdministrators] [BIT] NOT NULL
 CONSTRAINT [PK_RDSServerSettings] PRIMARY KEY CLUSTERED 
(
	[RdsServerId] ASC,
	[SettingsName] ASC,
	[PropertyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetRDSServerSettings')
DROP PROCEDURE GetRDSServerSettings
GO
CREATE PROCEDURE GetRDSServerSettings
(
	@ServerId int,
	@SettingsName nvarchar(50)
)
AS
	SELECT RDSServerId, PropertyName, PropertyValue, ApplyUsers, ApplyAdministrators
	FROM RDSServerSettings
	WHERE RDSServerId = @ServerId AND SettingsName = @SettingsName			
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteRDSServerSettings')
DROP PROCEDURE DeleteRDSServerSettings
GO
CREATE PROCEDURE DeleteRDSServerSettings
(
	@ServerId int
)
AS
	DELETE FROM RDSServerSettings WHERE RDSServerId = @ServerId
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateRDSServerSettings')
DROP PROCEDURE UpdateRDSServerSettings
GO
CREATE PROCEDURE UpdateRDSServerSettings
(
	@ServerId int,
	@SettingsName nvarchar(50),
	@Xml ntext
)
AS

BEGIN TRAN
DECLARE @idoc int
EXEC sp_xml_preparedocument @idoc OUTPUT, @xml

DELETE FROM RDSServerSettings
WHERE RDSServerId = @ServerId AND SettingsName = @SettingsName

INSERT INTO RDSServerSettings
(
	RDSServerId,
	SettingsName,
	ApplyUsers,
	ApplyAdministrators,
	PropertyName,
	PropertyValue	
)
SELECT
	@ServerId,
	@SettingsName,
	ApplyUsers,
	ApplyAdministrators,
	PropertyName,
	PropertyValue
FROM OPENXML(@idoc, '/properties/property',1) WITH 
(
	PropertyName nvarchar(50) '@name',
	PropertyValue ntext '@value',
	ApplyUsers BIT '@applyUsers',
	ApplyAdministrators BIT '@applyAdministrators'
) as PV

exec sp_xml_removedocument @idoc

COMMIT TRAN

RETURN 

GO


IF EXISTS (SELECT * FROM ResourceGroups WHERE GroupName = 'SharePoint')
BEGIN
	DECLARE @group_id INT
	SELECT @group_id = GroupId FROM ResourceGroups WHERE GroupName = 'SharePoint'
	DELETE FROM PackageQuotas WHERE QuotaID IN (SELECT QuotaID FROM Quotas WHERE GroupID = @group_id)
	DELETE FROM HostingPlanQuotas WHERE QuotaID IN (SELECT QuotaID FROM Quotas WHERE GroupID = @group_id)
	DELETE FROM HostingPlanResources WHERE GroupId = @group_id
	DELETE FROM PackagesBandwidth WHERE GroupId = @group_id
	DELETE FROM PackagesDiskspace WHERE GroupId = @group_id
	DELETE FROM PackageResources WHERE GroupId = @group_id
	DELETE FROM ResourceGroupDnsRecords WHERE GroupId = @group_id
	DELETE FROM Providers WHERE GroupID = @group_id
	DELETE FROM Quotas WHERE GroupID = @group_id
	DELETE FROM VirtualGroups WHERE GroupID = @group_id
	DELETE FROM ServiceItemTypes WHERE GroupID = @group_id	
	DELETE FROM ResourceGroups WHERE GroupID = @group_id
END

GO

IF NOT EXISTS (SELECT * FROM [dbo].[ServiceItemTypes] WHERE DisplayName = 'SharePointFoundationSiteCollection')
BEGIN	
	DECLARE @group_id AS INT
	DECLARE @item_type_id INT
	SELECT TOP 1 @item_type_id = ItemTypeId + 1 FROM [dbo].[ServiceItemTypes] ORDER BY ItemTypeId DESC
	UPDATE [dbo].[ServiceItemTypes] SET DisplayName = 'SharePointFoundationSiteCollection' WHERE DisplayName = 'SharePointSiteCollection'
	SELECT @group_id = GroupId FROM [dbo].[ResourceGroups] WHERE GroupName = 'Sharepoint Server'	

	INSERT INTO [dbo].[ServiceItemTypes] (ItemTypeId, GroupId, DisplayName, TypeName, TypeOrder, CalculateDiskSpace, CalculateBandwidth, Suspendable, Disposable, Searchable, Importable, Backupable) 
		(SELECT TOP 1 @item_type_id, @group_id, 'SharePointSiteCollection', TypeName, 100, CalculateDiskSpace, CalculateBandwidth, Suspendable, Disposable, Searchable, Importable, Backupable FROM [dbo].[ServiceItemTypes] WHERE DisplayName = 'SharePointFoundationSiteCollection')
END




GO

UPDATE [dbo].[Quotas] SET GroupID = 45 WHERE QuotaName = 'EnterpriseStorage.DriveMaps'
GO


UPDATE [dbo].[ResourceGroups] SET GroupName = 'Sharepoint Enterprise Server' WHERE GroupName = 'Sharepoint Server'
GO

UPDATE [dbo].[ResourceGroups] SET GroupController = 'WebsitePanel.EnterpriseServer.HostedSharePointServerEntController' WHERE GroupName = 'Sharepoint Enterprise Server'
GO

IF NOT EXISTS (SELECT * FROM [dbo].[Providers] WHERE [DisplayName] = 'Hosted SharePoint Enterprise 2013')
BEGIN
DECLARE @provider_id AS INT
DECLARE @group_id AS INT
SELECT @group_id = GroupId FROM [dbo].[ResourceGroups] WHERE GroupName = 'Sharepoint Enterprise Server'
SELECT TOP 1 @provider_id = ProviderId + 1 From [dbo].[Providers] ORDER BY ProviderID DESC
INSERT [dbo].[Providers] ([ProviderID], [GroupID], [ProviderName], [DisplayName], [ProviderType], [EditorControl], [DisableAutoDiscovery])
VALUES (@provider_id, @group_id, N'HostedSharePoint2013Ent', N'Hosted SharePoint Enterprise 2013', N'WebsitePanel.Providers.HostedSolution.HostedSharePointServer2013Ent, WebsitePanel.Providers.HostedSolution.SharePoint2013Ent', N'HostedSharePoint30', NULL)
END
GO

UPDATE [dbo].[Quotas] SET QuotaName = 'HostedSharePointEnterprise.Sites' WHERE QuotaId = 550
GO

UPDATE [dbo].[Quotas] SET QuotaName = 'HostedSharePointEnterprise.MaxStorage' WHERE QuotaId = 551
GO

UPDATE [dbo].[Quotas] SET QuotaName = 'HostedSharePointEnterprise.UseSharedSSL' WHERE QuotaId = 552
GO

UPDATE [dbo].[ServiceItemTypes] SET DisplayName = 'SharePointEnterpriseSiteCollection' WHERE DisplayName = 'SharePointSiteCollection'
GO


IF EXISTS (SELECT * FROM Providers WHERE ProviderName = 'HostedSharePoint2013' AND GroupID IN (Select GroupID FROM ResourceGroups WHERE GroupName = 'Sharepoint Enterprise Server'))
BEGIN
	DECLARE @group_id INT
	SELECT @group_id = GroupId FROM ResourceGroups WHERE GroupName = 'Sharepoint Enterprise Server'
	DELETE FROM Providers WHERE ProviderName = 'HostedSharePoint2013' AND GroupID = @group_id
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

CREATE TABLE #TempTable(
	ItemID int,
	PropertyName nvarchar(50),
	PropertyValue  nvarchar(3000))

INSERT INTO #TempTable (ItemID, PropertyName, PropertyValue)
SELECT
	@ItemID,
	PropertyName,
	PropertyValue
FROM OPENXML(@idoc, '/properties/property',1) WITH 
(
	PropertyName nvarchar(50) '@name',
	PropertyValue nvarchar(3000) '@value'
) as PV

-- Move data from temp table to real table
INSERT INTO ServiceItemProperties
(
	ItemID,
	PropertyName,
	PropertyValue
)
SELECT 
	ItemID, 
	PropertyName, 
	PropertyValue
FROM #TempTable

DROP TABLE #TempTable

-- remove document
exec sp_xml_removedocument @idoc

COMMIT TRAN
RETURN 
GO

UPDATE [dbo].[ServiceItemTypes] SET TypeName ='WebsitePanel.Providers.SharePoint.SharePointEnterpriseSiteCollection, WebsitePanel.Providers.Base' WHERE DisplayName = 'SharePointEnterpriseSiteCollection'
GO

-- USER PASSWORD EXPIRATION NOTIFICATION tasks

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTasks] WHERE [TaskID] = N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION')
BEGIN
INSERT [dbo].[ScheduleTasks] ([TaskID], [TaskType], [RoleID]) VALUES (N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION', N'WebsitePanel.EnterpriseServer.UserPasswordExpirationNotificationTask, WebsitePanel.EnterpriseServer.Code', 1)
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskViewConfiguration] WHERE [TaskID] = N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION')
BEGIN
INSERT [dbo].[ScheduleTaskViewConfiguration] ([TaskID], [ConfigurationID], [Environment], [Description]) VALUES (N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION', N'ASP_NET', N'ASP.NET', N'~/DesktopModules/WebsitePanel/ScheduleTaskControls/UserPasswordExpirationNotificationView.ascx')
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[ScheduleTaskParameters] WHERE [TaskID] = N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION' AND [ParameterID]= N'DAYS_BEFORE_EXPIRATION' )
BEGIN
INSERT [dbo].[ScheduleTaskParameters] ([TaskID], [ParameterID], [DataTypeID], [DefaultValue], [ParameterOrder]) VALUES (N'SCHEDULE_TASK_USER_PASSWORD_EXPIRATION_NOTIFICATION', N'DAYS_BEFORE_EXPIRATION', N'String', NULL, 1)
END
GO


-- USER PASSWORD EXPIRATION EMAIL TEMPLATE

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @UserPasswordExpirationLetterHtmlBody nvarchar(2500)

Set @UserPasswordExpirationLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Password expiration notification</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">
<div class="Header">
<img src="#logoUrl#">
</div>
<h1>Password expiration notification</h1>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
Your password expiration date is #user.PasswordExpirationDateTime#. You can reset your own password by visiting the following page:
</p>

<a href="#passwordResetLink#" target="_blank">#passwordResetLink#</a>


<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>
</div>
</body>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'HtmlBody', @UserPasswordExpirationLetterHtmlBody)
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'Subject', N'Password expiration notification')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'LogoUrl' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'LogoUrl', N'')
END
GO


DECLARE @UserPasswordExpirationLetterTextBody nvarchar(2500)

Set @UserPasswordExpirationLetterTextBody = N'=========================================
   Password expiration notification
=========================================

<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

Your password expiration date is #user.PasswordExpirationDateTime#. You can reset your own password by visiting the following page:

#passwordResetLink#

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordExpirationLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordExpirationLetter', N'TextBody', @UserPasswordExpirationLetterTextBody)
END
GO


-- USER PASSWORD RESET EMAIL TEMPLATE



IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @UserPasswordResetLetterHtmlBody nvarchar(2500)

Set @UserPasswordResetLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Password reset notification</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">
<div class="Header">
<img src="#logoUrl#">
</div>
<h1>Password reset notification</h1>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
We received a request to reset the password for your account. If you made this request, click the link below. If you did not make this request, you can ignore this email.
</p>

<a href="#passwordResetLink#" target="_blank">#passwordResetLink#</a>


<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>
</div>
</body>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'HtmlBody', @UserPasswordResetLetterHtmlBody)
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'Subject', N'Password reset notification')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'LogoUrl' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'LogoUrl', N'')
END
GO


DECLARE @UserPasswordResetLetterTextBody nvarchar(2500)

Set @UserPasswordResetLetterTextBody = N'=========================================
   Password reset notification
=========================================

<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

We received a request to reset the password for your account. If you made this request, click the link below. If you did not make this request, you can ignore this email.

#passwordResetLink#

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'TextBody', @UserPasswordResetLetterTextBody)
END
GO




DECLARE @UserPasswordResetSMSBody nvarchar(2500)

Set @UserPasswordResetSMSBody = N'Password reset link:
#passwordResetLink#
'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetLetter' AND [PropertyName]= N'PasswordResetLinkSmsBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetLetter', N'PasswordResetLinkSmsBody', @UserPasswordResetSMSBody)
END
GO

-- USER PASSWORD RESET EMAIL PINCODE TEMPLATE

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @UserPasswordResetPincodeLetterHtmlBody nvarchar(2500)

Set @UserPasswordResetPincodeLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Password reset notification</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">
<div class="Header">
<img src="#logoUrl#">
</div>
<h1>Password reset notification</h1>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
We received a request to reset the password for your account. Your password reset pincode:
</p>

#passwordResetPincode#

<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>
</div>
</body>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'HtmlBody', @UserPasswordResetPincodeLetterHtmlBody)
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'Subject', N'Password reset notification')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'LogoUrl' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'LogoUrl', N'')
END
GO


DECLARE @UserPasswordResetPincodeLetterTextBody nvarchar(2500)

Set @UserPasswordResetPincodeLetterTextBody = N'=========================================
   Password reset notification
=========================================

<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

We received a request to reset the password for your account. Your password reset pincode:

#passwordResetPincode#

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'TextBody', @UserPasswordResetPincodeLetterTextBody)
END
GO

DECLARE @UserPasswordPincodeSMSBody nvarchar(2500)

Set @UserPasswordPincodeSMSBody = N'
Your password reset pincode:
#passwordResetPincode#'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'UserPasswordResetPincodeLetter' AND [PropertyName]= N'PasswordResetPincodeSmsBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'UserPasswordResetPincodeLetter', N'PasswordResetPincodeSmsBody', @UserPasswordPincodeSMSBody)
END
GO


-- USER PASSWORD REQUEST EMAIL TEMPLATE

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'From', N'support@HostingCompany.com')
END
GO

DECLARE @OrganizationUserPasswordRequestLetterHtmlBody nvarchar(2500)

Set @OrganizationUserPasswordRequestLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Password request notification</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.3em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; }
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
    </style>
</head>
<body>
<div class="Summary">
<div class="Header">
<img src="#logoUrl#">
</div>
<h1>Password request notification</h1>

<ad:if test="#user#">
<p>
Hello #user.FirstName#,
</p>
</ad:if>

<p>
Your account have been created. In order to create a password for your account, please follow next link:
</p>

<a href="#passwordResetLink#" target="_blank">#passwordResetLink#</a>

<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards
</p>
</div>
</body>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'HtmlBody', @OrganizationUserPasswordRequestLetterHtmlBody)
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'Subject', N'Password request notification')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'LogoUrl' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'LogoUrl', N'')
END
GO


DECLARE @OrganizationUserPasswordRequestLetterTextBody nvarchar(2500)

Set @OrganizationUserPasswordRequestLetterTextBody = N'=========================================
   Password request notification
=========================================

<ad:if test="#user#">
Hello #user.FirstName#,
</ad:if>

Your account have been created. In order to create a password for your account, please follow next link:

#passwordResetLink#

If you have any questions regarding your hosting account, feel free to contact our support department at any time.

Best regards'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'TextBody', @OrganizationUserPasswordRequestLetterTextBody)
END
GO

DECLARE @OrganizationUserPasswordRequestLetterSMSBody nvarchar(2500)

Set @OrganizationUserPasswordRequestLetterSMSBody = N'
User have been created. Password request url:
#passwordResetLink#'

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'OrganizationUserPasswordRequestLetter' AND [PropertyName]= N'SMSBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'OrganizationUserPasswordRequestLetter', N'SMSBody', @OrganizationUserPasswordRequestLetterSMSBody)
END
GO



-- Exchange setup EMAIL TEMPLATE



IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'From' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'ExchangeMailboxSetupLetter', N'From', N'')
END
GO

DECLARE @ExchangeMailboxSetupLetterHtmlBody nvarchar(max)

Set @ExchangeMailboxSetupLetterHtmlBody = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Account Summary Information</title>
    <style type="text/css">
        body {font-family: ''Segoe UI Light'',''Open Sans'',Arial!important;color:black;}
        p {color:black;}
		.Summary { background-color: ##ffffff; padding: 5px; }
		.SummaryHeader { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.5em; color: ##1F4978; border-bottom: dotted 3px ##efefef; font-weight:normal; }
        .Summary H2 { font-size: 1.2em; color: ##1F4978; } 
        .Summary TABLE { border: solid 1px ##e5e5e5; }
        .Summary TH,
        .Summary TD.Label { padding: 5px; font-size: 8pt; font-weight: bold; background-color: ##f5f5f5; }
        .Summary TD { padding: 8px; font-size: 9pt; color:black;}
        .Summary UL LI { font-size: 1.1em; font-weight: bold; }
        .Summary UL UL LI { font-size: 0.9em; font-weight: normal; }
        .Label { color:##1F4978; }
        .menu-bar a {padding: 15px 0;display: inline-block;}
    </style>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width="100%"><!-- was 800 -->
<tbody>
<tr>
<td style="padding: 10px 20px 10px 20px; background-color: ##e1e1e1;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="text-align: left; padding: 0px 0px 2px 0px;"><a href=""><img src="" border="0" alt="" /></a></td>
</tr>
</tbody>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="padding-bottom: 10px;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="background-color: ##2e8bcc; padding: 3px;">
<table class="menu-bar" border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="text-align: center;" width="20%"><a style="color: ##ffffff; text-transform: uppercase; font-size: 9px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-decoration: none;" href=""</a></td>
<td style="text-align: center;" width="20%"><a style="color: ##ffffff; text-transform: uppercase; font-size: 9px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-decoration: none;" href=""></a></td>
<td style="text-align: center;" width="20%"><a style="color: ##ffffff; text-transform: uppercase; font-size: 9px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-decoration: none;" href=""></a></td>
<td style="text-align: center;" width="20%"><a style="color: ##ffffff; text-transform: uppercase; font-size: 9px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-decoration: none;" href=""></a></td>
<td style="text-align: center;" width="20%"><a style="color: ##ffffff; text-transform: uppercase; font-size: 9px; font-weight: bold; font-family: Arial, Helvetica, sans-serif; text-decoration: none;" href=""></a></td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="background-color: ##ffffff;">
<table border="0" cellspacing="0" cellpadding="0" width="100%"><!-- was 759 -->
<tbody>
<tr>
<td style="vertical-align: top; padding: 10px 10px 0px 10px;" width="100%">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="font-family: ''Segoe UI Light'',''Open Sans'',Arial; padding: 0px 10px 0px 0px;">
<!-- Begin Content -->

<div class="Summary">
    <ad:if test="#Email#">
    <p>
    Hello #Account.DisplayName#,
    </p>
    <p>
    Thanks for choosing as your Exchange hosting provider.
    </p>
    </ad:if>
    <ad:if test="#not(PMM)#">
    <h1>User Accounts</h1>
    <p>
    The following user accounts have been created for you.
    </p>
    <table>
        <tr>
            <td class="Label">Username:</td>
            <td>#Account.UserPrincipalName#</td>
        </tr>
        <tr>
            <td class="Label">E-mail:</td>
            <td>#Account.PrimaryEmailAddress#</td>
        </tr>
		<ad:if test="#PswResetUrl#">
        <tr>
            <td class="Label">Password Reset Url:</td>
            <td><a href="#PswResetUrl#" target="_blank">Click here</a></td>
        </tr>
		</ad:if>
    </table>
    </ad:if>
    <h1>DNS</h1>
    <p>
    In order for us to accept mail for your domain, you will need to point your MX records to:
    </p>
    <table>
        <ad:foreach collection="#SmtpServers#" var="SmtpServer" index="i">
            <tr>
                <td class="Label">#SmtpServer#</td>
            </tr>
        </ad:foreach>
    </table>
   <h1>
    Webmail (OWA, Outlook Web Access)</h1>
    <p>
    <a href="" target="_blank"></a>
    </p>
    <h1>
    Outlook (Windows Clients)</h1>
    <p>
    To configure Outlook 2013 to work with the servers, please reference:
    </p>
    <p>
    <a href="" target="_blank"></a>
    </p>
    <p>
    If you need to download and install the Outlook client:</p>

        
        <table>
            <tr><td colspan="2" class="Label"><font size="3">Outlook 2013 Client</font></td></tr>
            <tr>
                <td class="Label">
                    Download URL:</td>
                <td><a href=""></a></td>
            </tr>
<tr>
                <td class="Label"></td>
                <td><a href=""></a></td>
            </tr>
            <tr>
                <td class="Label">
                    KEY:</td>
                <td></td>
            </tr>
        </table>
 
       <h1>
    ActiveSync, iPhone, iPad</h1>
    <table>
        <tr>
            <td class="Label">Server:</td>
            <td>#ActiveSyncServer#</td>
        </tr>
        <tr>
            <td class="Label">Domain:</td>
            <td>#SamDomain#</td>
        </tr>
        <tr>
            <td class="Label">SSL:</td>
            <td>must be checked</td>
        </tr>
        <tr>
            <td class="Label">Your username:</td>
            <td>#SamUsername#</td>
        </tr>
    </table>
 
    <h1>Password Changes</h1>
    <p>
    Passwords can be changed at any time using Webmail or the <a href="" target="_blank">Control Panel</a>.</p>
    <h1>Control Panel</h1>
    <p>
    If you need to change the details of your account, you can easily do this using <a href="" target="_blank">Control Panel</a>.</p>
    <h1>Support</h1>
    <p>
    You have 2 options, email <a href="mailto:"></a> or use the web interface at <a href=""></a></p>
    
</div>
<!-- End Content -->
<br></td>
</tr>
</tbody>
</table>
</td>

</tr>
</tbody>
</table>
</td>
</tr>
<tr>
<td style="background-color: ##ffffff; border-top: 1px solid ##999999;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="vertical-align: top; padding: 0px 20px 15px 20px;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="font-family: Arial, Helvetica, sans-serif; text-align: left; font-size: 9px; color: ##717073; padding: 20px 0px 0px 0px;">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tbody>
<tr>
<td style="font-family: Arial, Helvetica, sans-serif; font-size: 9px; text-align: left; color: ##1666af; vertical-align: top;" width="33%"><a style="font-weight: bold; text-transform: uppercase; text-decoration: underline; color: ##1666af;" href=""></a><br />Learn more about the services can provide to improve your business.</td>
<td style="font-family: Arial, Helvetica, sans-serif; font-size: 9px; text-align: left; color: ##1666af; padding: 0px 10px 0px 10px; vertical-align: top;" width="34%"><a style="font-weight: bold; text-transform: uppercase; text-decoration: underline; color: ##1666af;" href="">Privacy Policy</a><br /> follows strict guidelines in protecting your privacy. Learn about our <a style="font-weight: bold; text-decoration: underline; color: ##1666af;" href="">Privacy Policy</a>.</td>
<td style="font-family: Arial, Helvetica, sans-serif; font-size: 9px; text-align: left; color: ##1666af; vertical-align: top;" width="33%"><a style="font-weight: bold; text-transform: uppercase; text-decoration: underline; color: ##1666af;" href="">Contact Us</a><br />Questions? For more information, <a style="font-weight: bold; text-decoration: underline; color: ##1666af;" href="">contact us</a>.</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</body>
</html>';

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'HtmlBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'ExchangeMailboxSetupLetter', N'HtmlBody', @ExchangeMailboxSetupLetterHtmlBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @ExchangeMailboxSetupLetterHtmlBody WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'HtmlBody'
GO


IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'Priority' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'ExchangeMailboxSetupLetter', N'Priority', N'Normal')
END
GO
IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'Subject' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'ExchangeMailboxSetupLetter', N'Subject', N' Hosted Exchange Mailbox Setup')
END
GO


DECLARE @ExchangeMailboxSetupLetterTextBody nvarchar(2500)

Set @ExchangeMailboxSetupLetterTextBody = N'<ad:if test="#Email#">
Hello #Account.DisplayName#,

Thanks for choosing as your Exchange hosting provider.
</ad:if>
<ad:if test="#not(PMM)#">
User Accounts

The following user accounts have been created for you.

Username: #Account.UserPrincipalName#
E-mail: #Account.PrimaryEmailAddress#
<ad:if test="#PswResetUrl#">
Password Reset Url: #PswResetUrl#
</ad:if>
</ad:if>

=================================
DNS
=================================

In order for us to accept mail for your domain, you will need to point your MX records to:

<ad:foreach collection="#SmtpServers#" var="SmtpServer" index="i">#SmtpServer#</ad:foreach>

=================================
Webmail (OWA, Outlook Web Access)
=================================



=================================
Outlook (Windows Clients)
=================================

To configure Outlook 2010 to work with servers, please reference:



If you need to download and install the Outlook 2010 client:

Outlook 2010 Download URL:

KEY: 

=================================
ActiveSync, iPhone, iPad
=================================

Server: #ActiveSyncServer#
Domain: #SamDomain#
SSL: must be checked
Your username: #SamUsername#

=================================
Password Changes
=================================

Passwords can be changed at any time using Webmail or the Control Panel


=================================
Control Panel
=================================

If you need to change the details of your account, you can easily do this using the Control Panel 


=================================
Support
=================================

You have 2 options, email or use the web interface at '

IF NOT EXISTS (SELECT * FROM [dbo].[UserSettings] WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'TextBody' )
BEGIN
INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'ExchangeMailboxSetupLetter', N'TextBody', @ExchangeMailboxSetupLetterTextBody)
END
ELSE
UPDATE [dbo].[UserSettings] SET [PropertyValue] = @ExchangeMailboxSetupLetterTextBody WHERE [UserID] = 1 AND [SettingsName]= N'ExchangeMailboxSetupLetter' AND [PropertyName]= N'TextBody'
GO



-- ORGANIZATION USER PASSWORD RESET TOKENS


IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'AccessTokens')
DROP TABLE AccessTokens
GO
CREATE TABLE AccessTokens
(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AccessTokenGuid UNIQUEIDENTIFIER NOT NULL,
	ExpirationDate DATETIME NOT NULL,
	AccountID INT NOT NULL ,
	ItemId INT NOT NULL,
	TokenType INT NOT NULL,
	SmsResponse varchar(100)
)
GO

ALTER TABLE [dbo].[AccessTokens]  WITH CHECK ADD  CONSTRAINT [FK_AccessTokens_UserId] FOREIGN KEY([AccountID])
REFERENCES [dbo].[ExchangeAccounts] ([AccountID])
ON DELETE CASCADE
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddAccessToken')
DROP PROCEDURE AddAccessToken
GO
CREATE PROCEDURE [dbo].[AddAccessToken]
(
	@TokenID INT OUTPUT,
	@AccessToken UNIQUEIDENTIFIER,
	@ExpirationDate DATETIME,
	@AccountID INT,
	@ItemId INT,
	@TokenType INT
)
AS
INSERT INTO AccessTokens
(
	AccessTokenGuid,
	ExpirationDate,
	AccountID  ,
	ItemId,
	TokenType
)
VALUES
(
	@AccessToken  ,
	@ExpirationDate ,
	@AccountID,
	@ItemId,
	@TokenType
)

SET @TokenID = SCOPE_IDENTITY()

RETURN
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'SetAccessTokenSmsResponse')
DROP PROCEDURE SetAccessTokenSmsResponse
GO
CREATE PROCEDURE [dbo].[SetAccessTokenSmsResponse]
(
	@AccessToken UNIQUEIDENTIFIER,
	@SmsResponse varchar(100)
)
AS
UPDATE [dbo].[AccessTokens] SET [SmsResponse] = @SmsResponse WHERE [AccessTokenGuid] = @AccessToken
RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteAccessToken')
DROP PROCEDURE DeleteAccessToken
GO
CREATE PROCEDURE [dbo].[DeleteAccessToken]
(
	@AccessToken UNIQUEIDENTIFIER,
	@TokenType INT
)
AS
DELETE FROM AccessTokens
WHERE AccessTokenGuid = @AccessToken AND TokenType = @TokenType
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'DeleteExpiredAccessTokenTokens')
DROP PROCEDURE DeleteExpiredAccessTokenTokens
GO
CREATE PROCEDURE [dbo].[DeleteExpiredAccessTokenTokens]
AS
DELETE FROM AccessTokens
WHERE ExpirationDate < getdate()
GO


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetAccessTokenByAccessToken')
DROP PROCEDURE GetAccessTokenByAccessToken
GO
CREATE PROCEDURE [dbo].[GetAccessTokenByAccessToken]
(
	@AccessToken UNIQUEIDENTIFIER,
	@TokenType INT
)
AS
SELECT 
	ID ,
	AccessTokenGuid,
	ExpirationDate,
	AccountID,
	ItemId,
	TokenType,
	SmsResponse
	FROM AccessTokens 
	Where AccessTokenGuid = @AccessToken AND ExpirationDate > getdate() AND TokenType = @TokenType
GO


-- ORGANIZATION SETTINGS


IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'ExchangeOrganizationSettings')
BEGIN
	CREATE TABLE ExchangeOrganizationSettings
	(
		ItemId INT NOT NULL,
		SettingsName nvarchar(100)  NOT NULL,
		Xml nvarchar(max) NOT NULL
	);

	ALTER TABLE [dbo].[ExchangeOrganizationSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeOrganizationSettings_ExchangeOrganizations_ItemId] FOREIGN KEY([ItemId])
	REFERENCES [dbo].[ExchangeOrganizations] ([ItemId])
	ON DELETE CASCADE;
END




IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'UpdateExchangeOrganizationSettings')
DROP PROCEDURE UpdateExchangeOrganizationSettings
GO
CREATE PROCEDURE [dbo].[UpdateExchangeOrganizationSettings]
(
	@ItemId INT ,
	@SettingsName nvarchar(100) ,
	@Xml nvarchar(max)
)
AS
IF NOT EXISTS (SELECT * FROM [dbo].[ExchangeOrganizationSettings] WHERE [ItemId] = @ItemId AND [SettingsName]= @SettingsName )
BEGIN
INSERT [dbo].[ExchangeOrganizationSettings] ([ItemId], [SettingsName], [Xml]) VALUES (@ItemId, @SettingsName, @Xml)
END
ELSE
UPDATE [dbo].[ExchangeOrganizationSettings] SET [Xml] = @Xml WHERE [ItemId] = @ItemId AND [SettingsName]= @SettingsName
GO




IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetExchangeOrganizationSettings')
DROP PROCEDURE GetExchangeOrganizationSettings
GO
CREATE PROCEDURE [dbo].[GetExchangeOrganizationSettings]
(
	@ItemId INT ,
	@SettingsName nvarchar(100)
)
AS
SELECT 
	ItemId,
	SettingsName,
	Xml

FROM ExchangeOrganizationSettings 
Where ItemId = @ItemId AND SettingsName = @SettingsName
GO


-- Exchange Account password column removed

if exists(select * from sys.columns 
            where Name = N'AccountPassword' and Object_ID = Object_ID(N'ExchangeAccounts'))
begin
  ALTER TABLE [ExchangeAccounts] DROP COLUMN [AccountPassword]
end

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'AddExchangeAccount')
DROP PROCEDURE AddExchangeAccount
GO
CREATE PROCEDURE [dbo].[AddExchangeAccount] 
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
	@MailboxPlanId,
	@SubscriberNumber,
	@PrimaryEmailAddress
)

SET @AccountID = SCOPE_IDENTITY()

RETURN

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'SearchExchangeAccount')
DROP PROCEDURE SearchExchangeAccount
GO
CREATE PROCEDURE [dbo].[SearchExchangeAccount]
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
	SubscriberNumber,
	UserPrincipalName
FROM ExchangeAccounts
WHERE AccountID = @AccountID

RETURN 


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetSearchTableByColumns')
DROP PROCEDURE GetSearchTableByColumns
GO
CREATE PROCEDURE [dbo].[GetSearchTableByColumns]
(
	@PagedStored nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@MaximumRows int,
	
	@Recursive bit,
	@PoolID int,
	@ServerID int,
	@ActorID int,
	@StatusID int,
	@PlanID int,
	@OrgID int,
	@ItemTypeName nvarchar(200),
	@GroupName nvarchar(100) = NULL,
	@PackageID int,
	@VPSType nvarchar(100) = NULL,
	@UserID int,
	@RoleID int,
	@FilterColumns nvarchar(200)
)
AS

DECLARE @VPSTypeID int
IF @VPSType <> '' AND @VPSType IS NOT NULL
BEGIN
	SET @VPSTypeID = CASE @VPSType
		WHEN 'VPS' THEN 33
		WHEN 'VPS2012' THEN 41
		WHEN 'VPSForPC' THEN 35
		ELSE 33
		END
END

DECLARE @sql nvarchar(3000)
SET @sql = CASE @PagedStored
WHEN 'Domains' THEN '
	DECLARE @Domains TABLE
	(
		DomainID int,
		DomainName nvarchar(100),
		Username nvarchar(100),
		FullName nvarchar(100),
		Email nvarchar(100)
	)
	INSERT INTO @Domains (DomainID, DomainName, Username, FullName, Email)
	SELECT
		D.DomainID,
		D.DomainName,
		U.Username,
		U.FullName,
		U.Email
	FROM Domains AS D
	INNER JOIN Packages AS P ON D.PackageID = P.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	LEFT OUTER JOIN ServiceItems AS Z ON D.ZoneItemID = Z.ItemID
	LEFT OUTER JOIN Services AS S ON Z.ServiceID = S.ServiceID
	LEFT OUTER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
	WHERE
		(D.IsInstantAlias = 0 AND D.IsDomainPointer = 0)
		AND ((@Recursive = 0 AND D.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, D.PackageID) = 1))
		AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
	'
WHEN 'IPAddresses' THEN '
	DECLARE @IPAddresses TABLE
	(
		AddressesID int,
		ExternalIP nvarchar(100),
		InternalIP nvarchar(100),
		DefaultGateway nvarchar(100),
		ServerName nvarchar(100),
		UserName nvarchar(100),
		ItemName nvarchar(100)
	)
	DECLARE @IsAdmin bit
	SET @IsAdmin = dbo.CheckIsUserAdmin(@ActorID)
	INSERT INTO @IPAddresses (AddressesID, ExternalIP, InternalIP, DefaultGateway, ServerName, UserName, ItemName)
	SELECT
		IP.AddressID,
		IP.ExternalIP,
		IP.InternalIP,
		IP.DefaultGateway,
		S.ServerName,
		U.UserName,
		SI.ItemName
	FROM dbo.IPAddresses AS IP
	LEFT JOIN Servers AS S ON IP.ServerID = S.ServerID
	LEFT JOIN PackageIPAddresses AS PA ON IP.AddressID = PA.AddressID
	LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
	LEFT JOIN dbo.Packages P ON PA.PackageID = P.PackageID
	LEFT JOIN dbo.Users U ON P.UserID = U.UserID
	WHERE
		@IsAdmin = 1
		AND (@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
		AND (@ServerID = 0 OR @ServerID <> 0 AND IP.ServerID = @ServerID)
	'
WHEN 'Schedules' THEN '
	DECLARE @Schedules TABLE
	(
		ScheduleID int,
		ScheduleName nvarchar(100),
		Username nvarchar(100),
		FullName nvarchar(100),
		Email nvarchar(100)
	)
	INSERT INTO @Schedules (ScheduleID, ScheduleName, Username, FullName, Email)
	SELECT
		S.ScheduleID,
		S.ScheduleName,
		U.Username,
		U.FullName,
		U.Email
	FROM Schedule AS S
	INNER JOIN Packages AS P ON S.PackageID = P.PackageID
	INNER JOIN PackagesTree(@PackageID, @Recursive) AS PT ON S.PackageID = PT.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	'
WHEN 'NestedPackages' THEN '
	DECLARE @NestedPackages TABLE
	(
		PackageID int,
		PackageName nvarchar(100),
		Username nvarchar(100),
		FullName nvarchar(100),
		Email nvarchar(100)
	)
	INSERT INTO @NestedPackages (PackageID, PackageName, Username, FullName, Email)
	SELECT
		P.PackageID,
		P.PackageName,
		U.Username,
		U.FullName,
		U.Email
	FROM Packages AS P
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	INNER JOIN Servers AS S ON P.ServerID = S.ServerID
	INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
	WHERE
		P.ParentPackageID = @PackageID
		AND ((@StatusID = 0) OR (@StatusID > 0 AND P.StatusID = @StatusID))
		AND ((@PlanID = 0) OR (@PlanID > 0 AND P.PlanID = @PlanID))
		AND ((@ServerID = 0) OR (@ServerID > 0 AND P.ServerID = @ServerID))
	'
WHEN 'PackageIPAddresses' THEN '
	DECLARE @PackageIPAddresses TABLE
	(
		PackageAddressID int,
		ExternalIP nvarchar(100),
		InternalIP nvarchar(100),
		DefaultGateway nvarchar(100),
		ItemName nvarchar(100),
		UserName nvarchar(100)
	)
	INSERT INTO @PackageIPAddresses (PackageAddressID, ExternalIP, InternalIP, DefaultGateway, ItemName, UserName)
	SELECT
		PA.PackageAddressID,
		IP.ExternalIP,
		IP.InternalIP,
		IP.DefaultGateway,
		SI.ItemName,
		U.UserName
	FROM dbo.PackageIPAddresses PA
	INNER JOIN dbo.IPAddresses AS IP ON PA.AddressID = IP.AddressID
	INNER JOIN dbo.Packages P ON PA.PackageID = P.PackageID
	INNER JOIN dbo.Users U ON U.UserID = P.UserID
	LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
	WHERE
		((@Recursive = 0 AND PA.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, PA.PackageID) = 1))
		AND (@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
		AND (@OrgID = 0 OR @OrgID <> 0 AND PA.OrgID = @OrgID)
	'
WHEN 'ServiceItems' THEN '
	IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
	RAISERROR(''You are not allowed to access this package'', 16, 1)
	DECLARE @ServiceItems TABLE
	(
		ItemID int,
		ItemName nvarchar(100),
		Username nvarchar(100),
		FullName nvarchar(100),
		Email nvarchar(100)
	)
	DECLARE @GroupID int
	SELECT @GroupID = GroupID FROM ResourceGroups
	WHERE GroupName = @GroupName
	DECLARE @ItemTypeID int
	SELECT @ItemTypeID = ItemTypeID FROM ServiceItemTypes
	WHERE TypeName = @ItemTypeName
	AND ((@GroupID IS NULL) OR (@GroupID IS NOT NULL AND GroupID = @GroupID))
	INSERT INTO @ServiceItems (ItemID, ItemName, Username, FullName, Email)
	SELECT
		SI.ItemID,
		SI.ItemName,
		U.Username,
		U.FirstName,
		U.Email
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	INNER JOIN ServiceItemTypes AS IT ON SI.ItemTypeID = IT.ItemTypeID
	INNER JOIN Services AS S ON SI.ServiceID = S.ServiceID
	INNER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
	WHERE
		SI.ItemTypeID = @ItemTypeID
		AND ((@Recursive = 0 AND P.PackageID = @PackageID)
			OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
		AND ((@GroupID IS NULL) OR (@GroupID IS NOT NULL AND IT.GroupID = @GroupID))
		AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
	'
WHEN 'Users' THEN '
	DECLARE @Users TABLE
	(
		UserID int,
		Username nvarchar(100),
		FullName nvarchar(100),
		Email nvarchar(100),
		CompanyName nvarchar(100)
	)
	DECLARE @HasUserRights bit
	SET @HasUserRights = dbo.CheckActorUserRights(@ActorID, @UserID)
	INSERT INTO @Users (UserID, Username, FullName, Email, CompanyName)
	SELECT
		U.UserID,
		U.Username,
		U.FullName,
		U.Email,
		U.CompanyName
	FROM UsersDetailed AS U
	WHERE 
		U.UserID <> @UserID AND U.IsPeer = 0 AND
		(
			(@Recursive = 0 AND OwnerID = @UserID) OR
			(@Recursive = 1 AND dbo.CheckUserParent(@UserID, U.UserID) = 1)
		)
		AND ((@StatusID = 0) OR (@StatusID > 0 AND U.StatusID = @StatusID))
		AND ((@RoleID = 0) OR (@RoleID > 0 AND U.RoleID = @RoleID))
		AND @HasUserRights = 1 
	'
WHEN 'VirtualMachines' THEN '
	IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
	RAISERROR(''You are not allowed to access this package'', 16, 1)
	DECLARE @VirtualMachines TABLE
	(
		ItemID int,
		ItemName nvarchar(100),
		Username nvarchar(100),
		ExternalIP nvarchar(100),
		IPAddress nvarchar(100)
	)
	INSERT INTO @VirtualMachines (ItemID, ItemName, Username, ExternalIP, IPAddress)
	SELECT
		SI.ItemID,
		SI.ItemName,
		U.Username,
		EIP.ExternalIP,
		PIP.IPAddress
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN Users AS U ON P.UserID = U.UserID
	LEFT OUTER JOIN (
		SELECT PIP.ItemID, IP.ExternalIP FROM PackageIPAddresses AS PIP
		INNER JOIN IPAddresses AS IP ON PIP.AddressID = IP.AddressID
		WHERE PIP.IsPrimary = 1 AND IP.PoolID = 3 -- external IP addresses
	) AS EIP ON SI.ItemID = EIP.ItemID
	LEFT OUTER JOIN PrivateIPAddresses AS PIP ON PIP.ItemID = SI.ItemID AND PIP.IsPrimary = 1
	WHERE
		SI.ItemTypeID = ' + CAST(@VPSTypeID AS nvarchar(12)) + '
		AND ((@Recursive = 0 AND P.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
	'
WHEN 'PackagePrivateIPAddresses' THEN '
	DECLARE @PackagePrivateIPAddresses TABLE
	(
		PrivateAddressID int,
		IPAddress nvarchar(100),
		ItemName nvarchar(100)
	)
	INSERT INTO @PackagePrivateIPAddresses (PrivateAddressID, IPAddress, ItemName)
	SELECT
		PA.PrivateAddressID,
		PA.IPAddress,
		SI.ItemName
	FROM dbo.PrivateIPAddresses AS PA
	INNER JOIN dbo.ServiceItems AS SI ON PA.ItemID = SI.ItemID
	WHERE SI.PackageID = @PackageID
	'
ELSE ''
END + 'SELECT TOP ' + CAST(@MaximumRows AS nvarchar(12)) + ' MIN(ItemID) as [ItemID], TextSearch, ColumnType, COUNT(*) AS [Count]' + CASE @PagedStored
WHEN 'Domains' THEN '
	FROM(
	SELECT D0.DomainID AS ItemID, D0.DomainName AS TextSearch, ''DomainName'' AS ColumnType
	FROM @Domains AS D0
	UNION
	SELECT D1.DomainID AS ItemID, D1.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @Domains AS D1
	UNION
	SELECT D2.DomainID as ItemID, D2.FullName AS TextSearch, ''FullName'' AS ColumnType
	FROM @Domains AS D2
	UNION
	SELECT D3.DomainID as ItemID, D3.Email AS TextSearch, ''Email'' AS ColumnType
	FROM @Domains AS D3) AS D'
WHEN 'IPAddresses' THEN '
	FROM(
	SELECT D0.AddressesID AS ItemID, D0.ExternalIP AS TextSearch, ''ExternalIP'' AS ColumnType
	FROM @IPAddresses AS D0
	UNION
	SELECT D1.AddressesID AS ItemID, D1.InternalIP AS TextSearch, ''InternalIP'' AS ColumnType
	FROM @IPAddresses AS D1
	UNION
	SELECT D2.AddressesID AS ItemID, D2.DefaultGateway AS TextSearch, ''DefaultGateway'' AS ColumnType
	FROM @IPAddresses AS D2
	UNION
	SELECT D3.AddressesID AS ItemID, D3.ServerName AS TextSearch, ''ServerName'' AS ColumnType
	FROM @IPAddresses AS D3
	UNION
	SELECT D4.AddressesID AS ItemID, D4.UserName AS TextSearch, ''UserName'' AS ColumnType
	FROM @IPAddresses AS D4
	UNION
	SELECT D6.AddressesID AS ItemID, D6.ItemName AS TextSearch, ''ItemName'' AS ColumnType
	FROM @IPAddresses AS D6) AS D'
WHEN 'Schedules' THEN '
	FROM(
	SELECT D0.ScheduleID AS ItemID, D0.ScheduleName AS TextSearch, ''ScheduleName'' AS ColumnType
	FROM @Schedules AS D0
	UNION
	SELECT D1.ScheduleID AS ItemID, D1.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @Schedules AS D1
	UNION
	SELECT D2.ScheduleID AS ItemID, D2.FullName AS TextSearch, ''FullName'' AS ColumnType
	FROM @Schedules AS D2
	UNION
	SELECT D3.ScheduleID AS ItemID, D3.Email AS TextSearch, ''Email'' AS ColumnType
	FROM @Schedules AS D3) AS D'
WHEN 'NestedPackages' THEN '
	FROM(
	SELECT D0.PackageID AS ItemID, D0.PackageName AS TextSearch, ''PackageName'' AS ColumnType
	FROM @NestedPackages AS D0
	UNION
	SELECT D1.PackageID AS ItemID, D1.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @NestedPackages AS D1
	UNION
	SELECT D2.PackageID as ItemID, D2.FullName AS TextSearch, ''FullName'' AS ColumnType
	FROM @NestedPackages AS D2
	UNION
	SELECT D3.PackageID as ItemID, D3.Email AS TextSearch, ''Email'' AS ColumnType
	FROM @NestedPackages AS D3) AS D'
WHEN 'PackageIPAddresses' THEN '
	FROM(
	SELECT D0.PackageAddressID AS ItemID, D0.ExternalIP AS TextSearch, ''ExternalIP'' AS ColumnType
	FROM @PackageIPAddresses AS D0
	UNION
	SELECT D1.PackageAddressID AS ItemID, D1.InternalIP AS TextSearch, ''InternalIP'' AS ColumnType
	FROM @PackageIPAddresses AS D1
	UNION
	SELECT D2.PackageAddressID as ItemID, D2.DefaultGateway AS TextSearch, ''DefaultGateway'' AS ColumnType
	FROM @PackageIPAddresses AS D2
	UNION
	SELECT D3.PackageAddressID as ItemID, D3.ItemName AS TextSearch, ''ItemName'' AS ColumnType
	FROM @PackageIPAddresses AS D3
	UNION
	SELECT D5.PackageAddressID as ItemID, D5.UserName AS TextSearch, ''UserName'' AS ColumnType
	FROM @PackageIPAddresses AS D5) AS D'
WHEN 'ServiceItems' THEN '
	FROM(
	SELECT D0.ItemID AS ItemID, D0.ItemName AS TextSearch, ''ItemName'' AS ColumnType
	FROM @ServiceItems AS D0
	UNION
	SELECT D1.ItemID AS ItemID, D1.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @ServiceItems AS D1
	UNION
	SELECT D2.ItemID as ItemID, D2.FullName AS TextSearch, ''FullName'' AS ColumnType
	FROM @ServiceItems AS D2
	UNION
	SELECT D3.ItemID as ItemID, D3.Email AS TextSearch, ''Email'' AS ColumnType
	FROM @ServiceItems AS D3) AS D'
WHEN 'Users' THEN '
	FROM(
	SELECT D0.UserID AS ItemID, D0.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @Users AS D0
	UNION
	SELECT D1.UserID AS ItemID, D1.FullName AS TextSearch, ''FullName'' AS ColumnType
	FROM @Users AS D1
	UNION
	SELECT D2.UserID as ItemID, D2.Email AS TextSearch, ''Email'' AS ColumnType
	FROM @Users AS D2
	UNION
	SELECT D3.UserID as ItemID, D3.CompanyName AS TextSearch, ''CompanyName'' AS ColumnType
	FROM @Users AS D3) AS D'
WHEN 'VirtualMachines' THEN '
	FROM(
	SELECT D0.ItemID AS ItemID, D0.ItemName AS TextSearch, ''ItemName'' AS ColumnType
	FROM @VirtualMachines AS D0
	UNION
	SELECT D1.ItemID AS ItemID, D1.ExternalIP AS TextSearch, ''ExternalIP'' AS ColumnType
	FROM @VirtualMachines AS D1
	UNION
	SELECT D2.ItemID as ItemID, D2.Username AS TextSearch, ''Username'' AS ColumnType
	FROM @VirtualMachines AS D2
	UNION
	SELECT D3.ItemID as ItemID, D3.IPAddress AS TextSearch, ''IPAddress'' AS ColumnType
	FROM @VirtualMachines AS D3) AS D'
WHEN 'PackagePrivateIPAddresses' THEN '
	FROM(
	SELECT D0.PrivateAddressID AS ItemID, D0.IPAddress AS TextSearch, ''IPAddress'' AS ColumnType
	FROM @PackagePrivateIPAddresses AS D0
	UNION
	SELECT D1.PrivateAddressID AS ItemID, D1.ItemName AS TextSearch, ''ItemName'' AS ColumnType
	FROM @PackagePrivateIPAddresses AS D1) AS D'
END + '
	WHERE (TextSearch LIKE @FilterValue)'
IF @FilterColumns <> '' AND @FilterColumns IS NOT NULL
	SET @sql = @sql + '
		AND (ColumnType IN (' + @FilterColumns + '))'
SET @sql = @sql + '
	GROUP BY TextSearch, ColumnType
	ORDER BY TextSearch'

exec sp_executesql @sql, N'@FilterValue nvarchar(50), @Recursive bit, @PoolID int, @ServerID int, @ActorID int, @StatusID int, @PlanID int, @OrgID int, @ItemTypeName nvarchar(200), @GroupName nvarchar(100), @PackageID int, @VPSTypeID int, @UserID int, @RoleID int', 
@FilterValue, @Recursive, @PoolID, @ServerID, @ActorID, @StatusID, @PlanID, @OrgID, @ItemTypeName, @GroupName, @PackageID, @VPSTypeID, @UserID, @RoleID

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetPackagePrivateIPAddressesPaged')
DROP PROCEDURE GetPackagePrivateIPAddressesPaged
GO
CREATE PROCEDURE [dbo].[GetPackagePrivateIPAddressesPaged]
	@PackageID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
AS
BEGIN


-- start
DECLARE @condition nvarchar(700)
SET @condition = '
SI.PackageID = @PackageID
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (IPAddress LIKE ''' + @FilterValue + '''
			OR ItemName LIKE ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'PA.IPAddress ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(PA.PrivateAddressID)
FROM dbo.PrivateIPAddresses AS PA
INNER JOIN dbo.ServiceItems AS SI ON PA.ItemID = SI.ItemID
WHERE ' + @condition + '

DECLARE @Addresses AS TABLE
(
	PrivateAddressID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		PA.PrivateAddressID
	FROM dbo.PrivateIPAddresses AS PA
	INNER JOIN dbo.ServiceItems AS SI ON PA.ItemID = SI.ItemID
	WHERE ' + @condition + '
)

INSERT INTO @Addresses
SELECT PrivateAddressID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	PA.PrivateAddressID,
	PA.IPAddress,
	PA.ItemID,
	SI.ItemName,
	PA.IsPrimary
FROM @Addresses AS TA
INNER JOIN dbo.PrivateIPAddresses AS PA ON TA.PrivateAddressID = PA.PrivateAddressID
INNER JOIN dbo.ServiceItems AS SI ON PA.ItemID = SI.ItemID
'

print @sql

exec sp_executesql @sql, N'@PackageID int, @StartRow int, @MaximumRows int',
@PackageID, @StartRow, @MaximumRows

END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetNestedPackagesPaged')
DROP PROCEDURE GetNestedPackagesPaged
GO
CREATE PROCEDURE [dbo].[GetNestedPackagesPaged]
(
	@ActorID int,
	@PackageID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@StatusID int,
	@PlanID int,
	@ServerID int,
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS

-- build query and run it to the temporary table
DECLARE @sql nvarchar(2000)

SET @sql = '
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR(''You are not allowed to access this package'', 16, 1)

DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows
DECLARE @Packages TABLE
(
	ItemPosition int IDENTITY(1,1),
	PackageID int
)
INSERT INTO @Packages (PackageID)
SELECT
	P.PackageID
FROM Packages AS P
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
INNER JOIN Servers AS S ON P.ServerID = S.ServerID
INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE
	P.ParentPackageID = @PackageID
	AND ((@StatusID = 0) OR (@StatusID > 0 AND P.StatusID = @StatusID))
	AND ((@PlanID = 0) OR (@PlanID > 0 AND P.PlanID = @PlanID))
	AND ((@ServerID = 0) OR (@ServerID > 0 AND P.ServerID = @ServerID)) '

IF @FilterValue <> ''
BEGIN
	IF @FilterColumn <> ''
		SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '
	ELSE
		SET @sql = @sql + '
			AND (Username LIKE @FilterValue
			OR FullName LIKE @FilterValue
			OR Email LIKE @FilterValue) '
END

IF @SortColumn <> '' AND @SortColumn IS NOT NULL
SET @sql = @sql + ' ORDER BY ' + @SortColumn + ' '

SET @sql = @sql + ' SELECT COUNT(PackageID) FROM @Packages;
SELECT
	P.PackageID,
	P.PackageName,
	P.StatusID,
	P.PurchaseDate,
	
	dbo.GetItemComments(P.PackageID, ''PACKAGE'', @ActorID) AS Comments,
	
	-- server
	P.ServerID,
	ISNULL(S.ServerName, ''None'') AS ServerName,
	ISNULL(S.Comments, '''') AS ServerComments,
	ISNULL(S.VirtualServer, 1) AS VirtualServer,
	
	-- hosting plan
	P.PlanID,
	HP.PlanName,
	
	-- user
	P.UserID,
	U.Username,
	U.FirstName,
	U.LastName,
	U.FullName,
	U.RoleID,
	U.Email
FROM @Packages AS TP
INNER JOIN Packages AS P ON TP.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
INNER JOIN Servers AS S ON P.ServerID = S.ServerID
INNER JOIN HostingPlans AS HP ON P.PlanID = HP.PlanID
WHERE TP.ItemPosition BETWEEN @StartRow AND @EndRow'

exec sp_executesql @sql, N'@StartRow int, @MaximumRows int, @PackageID int, @FilterValue nvarchar(50), @ActorID int, @StatusID int, @PlanID int, @ServerID int',
@StartRow, @MaximumRows, @PackageID, @FilterValue, @ActorID, @StatusID, @PlanID, @ServerID


RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetUsersPaged')
DROP PROCEDURE GetUsersPaged
GO
CREATE PROCEDURE [dbo].[GetUsersPaged]
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

IF @FilterValue <> ''
BEGIN
	IF @FilterColumn <> ''
		SET @sql = @sql + ' AND ' + @FilterColumn + ' LIKE @FilterValue '
	ELSE
		SET @sql = @sql + '
			AND (Username LIKE @FilterValue
			OR FullName LIKE @FilterValue
			OR Email LIKE @FilterValue) '
END

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

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetServiceItemsPaged')
DROP PROCEDURE GetServiceItemsPaged
GO
CREATE PROCEDURE [dbo].[GetServiceItemsPaged]
(
	@ActorID int,
	@PackageID int,
	@ItemTypeName nvarchar(200),
	@GroupName nvarchar(100) = NULL,
	@ServerID int,
	@Recursive bit,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS


-- check rights
IF dbo.CheckActorPackageRights(@ActorID, @PackageID) = 0
RAISERROR('You are not allowed to access this package', 16, 1)

-- start
DECLARE @GroupID int
SELECT @GroupID = GroupID FROM ResourceGroups
WHERE GroupName = @GroupName

DECLARE @ItemTypeID int
SELECT @ItemTypeID = ItemTypeID FROM ServiceItemTypes
WHERE TypeName = @ItemTypeName
AND ((@GroupID IS NULL) OR (@GroupID IS NOT NULL AND GroupID = @GroupID))

DECLARE @condition nvarchar(700)
SET @condition = 'SI.ItemTypeID = @ItemTypeID
AND ((@Recursive = 0 AND P.PackageID = @PackageID)
		OR (@Recursive = 1 AND dbo.CheckPackageParent(@PackageID, P.PackageID) = 1))
AND ((@GroupID IS NULL) OR (@GroupID IS NOT NULL AND IT.GroupID = @GroupID))
AND (@ServerID = 0 OR (@ServerID > 0 AND S.ServerID = @ServerID))
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ItemName LIKE ''' + @FilterValue + '''
			OR Username ''' + @FilterValue + '''
			OR FullName ''' + @FilterValue + '''
			OR Email ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'SI.ItemName ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(SI.ItemID) FROM Packages AS P
INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
INNER JOIN ServiceItemTypes AS IT ON SI.ItemTypeID = IT.ItemTypeID
INNER JOIN Services AS S ON SI.ServiceID = S.ServiceID
WHERE ' + @condition + '

DECLARE @Items AS TABLE
(
	ItemID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		SI.ItemID
	FROM Packages AS P
	INNER JOIN ServiceItems AS SI ON P.PackageID = SI.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	INNER JOIN ServiceItemTypes AS IT ON SI.ItemTypeID = IT.ItemTypeID
	INNER JOIN Services AS S ON SI.ServiceID = S.ServiceID
	INNER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
	WHERE ' + @condition + '
)

INSERT INTO @Items
SELECT ItemID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	SI.ItemID,
	SI.ItemName,
	SI.ItemTypeID,
	IT.TypeName,
	SI.ServiceID,
	SI.PackageID,
	SI.CreatedDate,
	RG.GroupName,

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
FROM @Items AS TSI
INNER JOIN ServiceItems AS SI ON TSI.ItemID = SI.ItemID
INNER JOIN ServiceItemTypes AS IT ON SI.ItemTypeID = IT.ItemTypeID
INNER JOIN Packages AS P ON SI.PackageID = P.PackageID
INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
INNER JOIN Services AS S ON SI.ServiceID = S.ServiceID
INNER JOIN Servers AS SRV ON S.ServerID = SRV.ServerID
INNER JOIN ResourceGroups AS RG ON IT.GroupID = RG.GroupID


SELECT
	IP.ItemID,
	IP.PropertyName,
	IP.PropertyValue
FROM ServiceItemProperties AS IP
INNER JOIN @Items AS TSI ON IP.ItemID = TSI.ItemID'

--print @sql

exec sp_executesql @sql, N'@ItemTypeID int, @PackageID int, @GroupID int, @StartRow int, @MaximumRows int, @Recursive bit, @ServerID int',
@ItemTypeID, @PackageID, @GroupID, @StartRow, @MaximumRows, @Recursive, @ServerID

RETURN
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetIPAddressesPaged')
DROP PROCEDURE GetIPAddressesPaged
GO
CREATE PROCEDURE [dbo].[GetIPAddressesPaged]	
(
	@ActorID int,
	@PoolID int,
	@ServerID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int
)
AS
BEGIN

-- check rights
DECLARE @IsAdmin bit
SET @IsAdmin = dbo.CheckIsUserAdmin(@ActorID)

-- start
DECLARE @condition nvarchar(700)
SET @condition = '
@IsAdmin = 1
AND (@PoolID = 0 OR @PoolID <> 0 AND IP.PoolID = @PoolID)
AND (@ServerID = 0 OR @ServerID <> 0 AND IP.ServerID = @ServerID)
'

IF @FilterValue <> '' AND @FilterValue IS NOT NULL
BEGIN
	IF @FilterColumn <> '' AND @FilterColumn IS NOT NULL
		SET @condition = @condition + ' AND ' + @FilterColumn + ' LIKE ''' + @FilterValue + ''''
	ELSE
		SET @condition = @condition + '
			AND (ExternalIP LIKE ''' + @FilterValue + '''
			OR InternalIP LIKE ''' + @FilterValue + '''
			OR DefaultGateway LIKE ''' + @FilterValue + '''
			OR ServerName LIKE ''' + @FilterValue + '''
			OR ItemName LIKE ''' + @FilterValue + '''
			OR Username LIKE ''' + @FilterValue + ''')'
END

IF @SortColumn IS NULL OR @SortColumn = ''
SET @SortColumn = 'IP.ExternalIP ASC'

DECLARE @sql nvarchar(3500)

set @sql = '
SELECT COUNT(IP.AddressID)
FROM dbo.IPAddresses AS IP
LEFT JOIN Servers AS S ON IP.ServerID = S.ServerID
LEFT JOIN PackageIPAddresses AS PA ON IP.AddressID = PA.AddressID
LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
LEFT JOIN dbo.Packages P ON PA.PackageID = P.PackageID
LEFT JOIN dbo.Users U ON P.UserID = U.UserID
WHERE ' + @condition + '

DECLARE @Addresses AS TABLE
(
	AddressID int
);

WITH TempItems AS (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @SortColumn + ') as Row,
		IP.AddressID
	FROM dbo.IPAddresses AS IP
	LEFT JOIN Servers AS S ON IP.ServerID = S.ServerID
	LEFT JOIN PackageIPAddresses AS PA ON IP.AddressID = PA.AddressID
	LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
	LEFT JOIN dbo.Packages P ON PA.PackageID = P.PackageID
	LEFT JOIN dbo.Users U ON U.UserID = P.UserID
	WHERE ' + @condition + '
)

INSERT INTO @Addresses
SELECT AddressID FROM TempItems
WHERE TempItems.Row BETWEEN @StartRow + 1 and @StartRow + @MaximumRows

SELECT
	IP.AddressID,
	IP.PoolID,
	IP.ExternalIP,
	IP.InternalIP,
	IP.SubnetMask,
	IP.DefaultGateway,
	IP.Comments,

	IP.ServerID,
	S.ServerName,

	PA.ItemID,
	SI.ItemName,

	PA.PackageID,
	P.PackageName,

	P.UserID,
	U.UserName
FROM @Addresses AS TA
INNER JOIN dbo.IPAddresses AS IP ON TA.AddressID = IP.AddressID
LEFT JOIN Servers AS S ON IP.ServerID = S.ServerID
LEFT JOIN PackageIPAddresses AS PA ON IP.AddressID = PA.AddressID
LEFT JOIN ServiceItems SI ON PA.ItemId = SI.ItemID
LEFT JOIN dbo.Packages P ON PA.PackageID = P.PackageID
LEFT JOIN dbo.Users U ON U.UserID = P.UserID
'

exec sp_executesql @sql, N'@IsAdmin bit, @PoolID int, @ServerID int, @StartRow int, @MaximumRows int',
@IsAdmin, @PoolID, @ServerID, @StartRow, @MaximumRows

END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'GetSearchObject')
DROP PROCEDURE GetSearchObject
GO
CREATE PROCEDURE [dbo].[GetSearchObject]
(
	@ActorID int,
	@UserID int,
	@FilterColumn nvarchar(50) = '',
	@FilterValue nvarchar(50) = '',
	@StatusID int,
	@RoleID int,
	@SortColumn nvarchar(50),
	@StartRow int,
	@MaximumRows int = 0,
	@Recursive bit,
	@ColType nvarchar(50) = '',
	@FullType nvarchar(50) = '',
	@OnlyFind bit
)
AS

IF dbo.CheckActorUserRights(@ActorID, @UserID) = 0
RAISERROR('You are not allowed to access this account', 16, 1)

DECLARE @columnUsername nvarchar(20)  
SET @columnUsername = 'Username'

DECLARE @columnEmail nvarchar(20)  
SET @columnEmail = 'Email'

DECLARE @columnCompanyName nvarchar(20)  
SET @columnCompanyName = 'CompanyName'

DECLARE @columnFullName nvarchar(20)  
SET @columnFullName = 'FullName'

DECLARE @curUsers cursor
DECLARE @curSpace cursor

DECLARE @sqlSpace nvarchar(3000)
DECLARE @sqlUsers nvarchar(2000)
DECLARE @sqlReturn nvarchar(4000)

IF @FilterColumn = '' AND @FilterValue <> ''
SET @FilterColumn = 'TextSearch'

SET @sqlUsers = '
DECLARE @HasUserRights bit
SET @HasUserRights = dbo.CheckActorUserRights(@ActorID, @UserID)
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
	AND @HasUserRights = 1  
SET @curValue = cursor local for
SELECT '

IF @OnlyFind = 1
SET @sqlUsers = @sqlUsers + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlUsers = @sqlUsers + 'U.ItemID,
	U.TextSearch,
	U.ColumnType,
	''Users'' as FullType,
	0 as PackageID,
	0 as AccountID
FROM @Users AS TU
INNER JOIN 
(
SELECT ItemID, TextSearch, ColumnType
FROM(
SELECT U0.UserID as ItemID, U0.Username as TextSearch, @columnUsername as ColumnType
FROM dbo.Users AS U0
UNION
SELECT U1.UserID as ItemID, U1.Email as TextSearch, @columnEmail as ColumnType                      
FROM dbo.Users AS U1
UNION
SELECT U2.UserID as ItemID, U2.CompanyName as TextSearch, @columnCompanyName as ColumnType 
FROM dbo.Users AS U2
UNION
SELECT U3.UserID as ItemID, U3.FirstName + '' '' + U3.LastName as TextSearch, @columnFullName as ColumnType 
FROM dbo.Users AS U3) as U
WHERE TextSearch<>'' '' OR ISNULL(TextSearch, 0) > 0
)
 AS U ON TU.UserID = U.ItemID'
IF @FilterValue <> ''
	SET @sqlUsers = @sqlUsers + ' WHERE TextSearch LIKE ''' + @FilterValue + ''''
SET @sqlUsers = @sqlUsers + ' ORDER BY TextSearch'

SET @sqlUsers = @sqlUsers + ' open @curValue'

exec sp_executesql @sqlUsers, N'@UserID int, @FilterValue nvarchar(50), @ActorID int, @Recursive bit, @StatusID int, @RoleID int, @columnUsername nvarchar(20), @columnEmail nvarchar(20), @columnCompanyName nvarchar(20), @columnFullName nvarchar(20), @curValue cursor output',
@UserID, @FilterValue, @ActorID, @Recursive, @StatusID, @RoleID, @columnUsername, @columnEmail, @columnCompanyName, @columnFullName, @curValue=@curUsers output

SET @sqlSpace = '
	DECLARE @ItemsService TABLE
	(
		ItemID int
	)
	INSERT INTO @ItemsService (ItemID)
	SELECT
		SI.ItemID
	FROM ServiceItems AS SI
	INNER JOIN Packages AS P ON P.PackageID = SI.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE
		dbo.CheckUserParent(@UserID, P.UserID) = 1
	DECLARE @ItemsDomain TABLE
	(
		ItemID int
	)
	INSERT INTO @ItemsDomain (ItemID)
	SELECT
		D.DomainID
	FROM Domains AS D
	INNER JOIN Packages AS P ON P.PackageID = D.PackageID
	INNER JOIN UsersDetailed AS U ON P.UserID = U.UserID
	WHERE
		dbo.CheckUserParent(@UserID, P.UserID) = 1
		
	SET @curValue = cursor local for
	SELECT '

IF @OnlyFind = 1
SET @sqlSpace = @sqlSpace + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlSpace = @sqlSpace +	'
		SI.ItemID as ItemID,
		SI.ItemName as TextSearch,
		STYPE.DisplayName as ColumnType,
		STYPE.DisplayName as FullType,
		SI.PackageID as PackageID,
		0 as AccountID
	FROM @ItemsService AS I
	INNER JOIN ServiceItems AS SI ON I.ItemID = SI.ItemID
	INNER JOIN ServiceItemTypes AS STYPE ON SI.ItemTypeID = STYPE.ItemTypeID
	WHERE (STYPE.Searchable = 1)'
IF @FilterValue <> ''
	SET @sqlSpace = @sqlSpace + ' AND (SI.ItemName LIKE ''' + @FilterValue + ''')'
SET @sqlSpace = @sqlSpace + '
	UNION (
	SELECT '

IF @OnlyFind = 1
SET @sqlSpace = @sqlSpace + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlSpace = @sqlSpace +	'
		D.DomainID AS ItemID,
		D.DomainName as TextSearch,
		''Domain'' as ColumnType,
		''Domain'' as FullType,
		D.PackageID as PackageID,
		0 as AccountID
	FROM @ItemsDomain AS I
	INNER JOIN Domains AS D ON I.ItemID = D.DomainID
	WHERE (D.IsDomainPointer=0)'
IF @FilterValue <> ''
	SET @sqlSpace = @sqlSpace + ' AND (D.DomainName LIKE ''' + @FilterValue + ''')'
SET @sqlSpace = @sqlSpace + '
	UNION
	SELECT '

IF @OnlyFind = 1
SET @sqlSpace = @sqlSpace + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlSpace = @sqlSpace +	'
		EA.ItemID AS ItemID,
		EA.DisplayName as TextSearch,
		''ExchangeAccount'' as ColumnType,
		''ExchangeAccount'' as FullType,
		SI2.PackageID as PackageID,
		EA.AccountID as AccountID
	FROM @ItemsService AS I2
	INNER JOIN ServiceItems AS SI2 ON I2.ItemID = SI2.ItemID
	INNER JOIN ExchangeAccounts AS EA ON I2.ItemID = EA.ItemID'
IF @FilterValue <> ''
	SET @sqlSpace = @sqlSpace + ' WHERE (EA.DisplayName LIKE ''' + @FilterValue + ''')'
SET @sqlSpace = @sqlSpace + '
	UNION
	SELECT '

IF @OnlyFind = 1
SET @sqlSpace = @sqlSpace + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlSpace = @sqlSpace +	'
		EA4.ItemID AS ItemID,
		EA4.PrimaryEmailAddress as TextSearch,
		''ExchangeAccount'' as ColumnType,
		''ExchangeAccount'' as FullType,
		SI4.PackageID as PackageID,
		EA4.AccountID as AccountID
	FROM @ItemsService AS I4
	INNER JOIN ServiceItems AS SI4 ON I4.ItemID = SI4.ItemID
	INNER JOIN ExchangeAccounts AS EA4 ON I4.ItemID = EA4.ItemID'
IF @FilterValue <> ''
	SET @sqlSpace = @sqlSpace + ' WHERE (EA4.PrimaryEmailAddress LIKE ''' + @FilterValue + ''')'
SET @sqlSpace = @sqlSpace + '
	UNION
	SELECT '

IF @OnlyFind = 1
SET @sqlSpace = @sqlSpace + 'TOP ' + CAST(@MaximumRows AS varchar(12)) + ' '

SET @sqlSpace = @sqlSpace +	'
		I3.ItemID AS ItemID,
		EAEA.EmailAddress as TextSearch,
		''ExchangeAccount'' as ColumnType,
		''ExchangeAccount'' as FullType,
		SI3.PackageID as PackageID,
		0 as AccountID
	FROM @ItemsService AS I3
	INNER JOIN ServiceItems AS SI3 ON I3.ItemID = SI3.ItemID
	INNER JOIN ExchangeAccountEmailAddresses AS EAEA ON I3.ItemID = EAEA.AccountID'
IF @FilterValue <> ''
	SET @sqlSpace = @sqlSpace + ' WHERE (EAEA.EmailAddress LIKE ''' + @FilterValue + ''')'
SET @sqlSpace = @sqlSpace + ') ORDER BY TextSearch';
	
SET @sqlSpace = @sqlSpace + ' open @curValue'

exec sp_executesql @sqlSpace, N'@UserID int, @FilterValue nvarchar(50),  @ActorID int, @curValue cursor output',
@UserID, @FilterValue, @ActorID, @curValue=@curSpace output

SET @sqlReturn = '
DECLARE @ItemID int
DECLARE	@TextSearch nvarchar(500)
DECLARE	@ColumnType nvarchar(50)
DECLARE	@FullType nvarchar(50)
DECLARE @PackageID int
DECLARE @AccountID int
DECLARE @EndRow int
SET @EndRow = @StartRow + @MaximumRows
DECLARE @ItemsAll TABLE
	(
		ItemPosition int IDENTITY(1,1),
		ItemID int,
		TextSearch nvarchar(500),
		ColumnType nvarchar(50),
		FullType nvarchar(50),
		PackageID int,
		AccountID int
	)

FETCH NEXT FROM @curUsersValue INTO @ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @ItemsAll(ItemID, TextSearch, ColumnType, FullType, PackageID, AccountID)
VALUES(@ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID)
FETCH NEXT FROM @curUsersValue INTO @ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID
END

FETCH NEXT FROM @curSpaceValue INTO @ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO @ItemsAll(ItemID, TextSearch, ColumnType, FullType, PackageID, AccountID)
VALUES(@ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID)
FETCH NEXT FROM @curSpaceValue INTO @ItemID, @TextSearch, @ColumnType, @FullType, @PackageID, @AccountID
END

DECLARE @ItemsReturn TABLE
	(
		ItemPosition int IDENTITY(1,1),
		ItemID int,
		TextSearch nvarchar(500),
		ColumnType nvarchar(50),
		FullType nvarchar(50),
		PackageID int,
		AccountID int
	)
INSERT INTO @ItemsReturn(ItemID, TextSearch, ColumnType, FullType, PackageID, AccountID)	
SELECT ItemID, TextSearch, ColumnType, FullType, PackageID, AccountID
FROM @ItemsAll AS IA WHERE (1 = 1) '


IF @ColType <> ''
SET @sqlReturn = @sqlReturn + ' AND IA.ColumnType in ( ' + @ColType + ' ) ';

IF @FullType <> ''
SET @sqlReturn = @sqlReturn + ' AND IA.FullType = ''' + @FullType + '''';

SET @sqlReturn = @sqlReturn + '
SELECT COUNT(ItemID) FROM @ItemsReturn;
SELECT DISTINCT(ColumnType) FROM @ItemsReturn WHERE (1 = 1) ';
IF @FullType <> ''
SET @sqlReturn = @sqlReturn + ' AND FullType = ''' + @FullType + '''';
SET @sqlReturn = @sqlReturn + '; ';
SET @sqlReturn = @sqlReturn + '
SELECT ItemPosition, ItemID, TextSearch, ColumnType, FullType, PackageID, AccountID
FROM @ItemsReturn AS IR WHERE (1 = 1)
'

IF  @MaximumRows > 0
SET @sqlReturn = @sqlReturn + ' AND IR.ItemPosition BETWEEN @StartRow AND @EndRow';

exec sp_executesql @sqlReturn, N'@StartRow int, @MaximumRows int, @FilterValue nvarchar(50), @curSpaceValue cursor, @curUsersValue cursor',
@StartRow, @MaximumRows, @FilterValue, @curSpace, @curUsers

CLOSE @curSpace
DEALLOCATE @curSpace
CLOSE @curUsers
DEALLOCATE @curUsers
RETURN


IF EXISTS (SELECT TOP 1 * FROM ServiceItemTypes WHERE DisplayName = 'SharePointEnterpriseSiteCollection')
BEGIN
	DECLARE @item_type_id AS INT
	SELECT @item_type_id = ItemTypeId FROM ServiceItemTypes WHERE DisplayName = 'SharePointEnterpriseSiteCollection'
	UPDATE [dbo].[Quotas] SET ItemTypeID = @item_type_id WHERE QuotaId = 550
END
GO

-- OneTimePassword
IF NOT EXISTS(select 1 from sys.columns COLS INNER JOIN sys.objects OBJS ON OBJS.object_id=COLS.object_id and OBJS.type='U' AND OBJS.name='Users' AND COLS.name='OneTimePasswordState')
BEGIN
ALTER TABLE [dbo].[Users] ADD
	[OneTimePasswordState] int NULL
END
GO

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE type = 'P' AND name = 'SetUserOneTimePassword')
DROP PROCEDURE SetUserOneTimePassword
GO
CREATE PROCEDURE [dbo].[SetUserOneTimePassword]
(
	@UserID int,
	@Password nvarchar(200),
	@OneTimePasswordState int
)
AS
UPDATE Users
SET Password = @Password, OneTimePasswordState = @OneTimePasswordState
WHERE UserID = @UserID
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
		U.[AdditionalParams],
		U.OneTimePasswordState
	FROM Users AS U
	WHERE U.Username = @Username

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
		U.[AdditionalParams],
		U.OneTimePasswordState
	FROM Users AS U
	WHERE U.UserID = @UserID

	RETURN
GO

ALTER PROCEDURE [dbo].[ChangeUserPassword]
(
	@ActorID int,
	@UserID int,
	@Password nvarchar(200)
)
AS

-- check actor rights
IF dbo.CanUpdateUserDetails(@ActorID, @UserID) = 0
RETURN

UPDATE Users
SET Password = @Password, OneTimePasswordState = 0
WHERE UserID = @UserID

RETURN 
GO