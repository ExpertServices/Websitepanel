USE [${install.database}]
GO

-- update database version
DECLARE @build_version nvarchar(10), @build_date datetime
SET @build_version = N'${release.version}'
SET @build_date = '${release.date}T00:00:00' -- ISO 8601 Format (YYYY-MM-DDTHH:MM:SS)

IF NOT EXISTS (SELECT * FROM [dbo].[Versions] WHERE [DatabaseVersion] = @build_version)
BEGIN
	INSERT [dbo].[Versions] ([DatabaseVersion], [BuildDate]) VALUES (@build_version, @build_date)
	INSERT [dbo].[UserSettings] ([UserID], [SettingsName], [PropertyName], [PropertyValue]) VALUES (1, N'WebPolicy', N'EnableParkingPageTokens', N'False')
END
GO

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
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 7 WHERE [GroupName] = N'ExchangeHostedEdition'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 8 WHERE [GroupName] = N'MsSQL2000'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 9 WHERE [GroupName] = N'MsSQL2005'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 10 WHERE [GroupName] = N'MsSQL2008'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 11 WHERE [GroupName] = N'MsSQL2012'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 12 WHERE [GroupName] = N'MySQL4'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 13 WHERE [GroupName] = N'MySQL5'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 14 WHERE [GroupName] = N'SharePoint'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 15 WHERE [GroupName] = N'Hosted SharePoint'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 16 WHERE [GroupName] = N'Hosted CRM'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 17 WHERE [GroupName] = N'DNS'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 18 WHERE [GroupName] = N'Statistics'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 19 WHERE [GroupName] = N'VPS'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 20 WHERE [GroupName] = N'VPSForPC'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 21 WHERE [GroupName] = N'BlackBerry'
GO
UPDATE [dbo].[ResourceGroups] SET [GroupOrder] = 22 WHERE [GroupName] = N'OCS'
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


UPDATE [dbo].[ScheduleTaskParameters] SET DefaultValue = N'MsSQL2000=SQL Server 2000;MsSQL2005=SQL Server 2005;MsSQL2008=SQL Server 2008;MsSQL2012=SQL Server 2012;MySQL4=MySQL 4.0;MySQL5=MySQL 5.0' WHERE [ParameterID] = N'DATABASE_GROUP'
GO

UPDATE [dbo].[UserSettings] SET [PropertyValue] = N'<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Hosting Space Summary Information</title>
    <style type="text/css">
		.Summary { background-color: ##ffffff; padding: 5px; }
		.Summary .Header { padding: 10px 0px 10px 10px; font-size: 16pt; background-color: ##E5F2FF; color: ##1F4978; border-bottom: solid 2px ##86B9F7; }
        .Summary A { color: ##0153A4; }
        .Summary { font-family: Tahoma; font-size: 9pt; }
        .Summary H1 { font-size: 1.7em; color: ##1F4978; border-bottom: dotted 3px ##efefef; }
        .Summary H2 { font-size: 1.2em; } 
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
	Hosting Space Information
</div>

<ad:if test="#Signup#">
<p>
Hello #user.FirstName#,
</p>

<p>
&quot;#space.Package.PackageName#&quot; hosting space has been created under your user account
and below is the summary information for its resources.
</p>
</ad:if>

<ul>
    <ad:if test="#Signup#">
		<li><a href="##cp">Control Panel URL</a></li>
	</ad:if>
    <li><a href="##overview">Hosting Space Overview</a></li>
    <ad:if test="#space.Groups.ContainsKey("Web")#">
    <li><a href="##web">Web</a></li>
    <ul>
        <li><a href="##weblimits">Limits</a></li>
        <li><a href="##dns">Name Servers</a></li>
        <li><a href="##sites">Web Sites</a></li>
        <li><a href="##tempurl">Temporary URL</a></li>
        <li><a href="##files">Files Location</a></li>
    </ul>
    </ad:if>
    <ad:if test="#space.Groups.ContainsKey("FTP")#">
		<li><a href="##ftp">FTP</a></li>
		<ul>
			<li><a href="##ftplimits">Limits</a></li>
			<li><a href="##ftpserver">FTP Server</a></li>
			<li><a href="##ftpaccounts">FTP Accounts</a></li>
		</ul>
	</ad:if>
    <ad:if test="#space.Groups.ContainsKey("Mail")#">
		<li><a href="##mail">Mail</a></li>
		<ul>
			<li><a href="##maillimits">Limits</a></li>
			<li><a href="##smtp">SMTP/POP3 Server</a></li>
			<li><a href="##mailaccounts">Mail Accounts</a></li>
		</ul>
    </ad:if>
    <li><a href="##db">Databases</a></li>
    <ul>
        <ad:if test="#space.Groups.ContainsKey("MsSQL2000")#"><li><a href="##mssql2000">SQL Server 2000</a></li></ad:if>
        <ad:if test="#space.Groups.ContainsKey("MsSQL2005")#"><li><a href="##mssql2005">SQL Server 2005</a></li></ad:if>
        <ad:if test="#space.Groups.ContainsKey("MsSQL2008")#"><li><a href="##mssql2008">SQL Server 2008</a></li></ad:if>
	<ad:if test="#space.Groups.ContainsKey("MsSQL2012")#"><li><a href="##mssql2012">SQL Server 2012</a></li></ad:if>
        <ad:if test="#space.Groups.ContainsKey("MySQL4")#"><li><a href="##mysql4">My SQL 4.x</a></li></ad:if>
        <ad:if test="#space.Groups.ContainsKey("MySQL5")#"><li><a href="##mysql5">My SQL 5.x</a></li></ad:if>
        <li><a href="##msaccess">Microsoft Access</a></li>
    </ul>
    <ad:if test="#space.Groups.ContainsKey("Statistics")#"><li><a href="##stats">Statistics</a></li></ad:if>
</ul>

<ad:if test="#Signup#">
<a name="cp"></a>
<h1>Control Panel URL</h1>
<table>
    <thead>
        <tr>
            <th>Control Panel URL</th>
            <th>Username</th>
            <th>Password</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><a href="http://panel.HostingCompany.com">http://panel.HostingCompany.com</a></td>
            <td>#user.Username#</td>
            <td>#user.Password#</td>
        </tr>
    </tbody>
</table>
</ad:if>

<a name="overview"></a>
<h1>Hosting Space Overview</h1>

<p>
    General hosting space limits:
</p>
<table>
    <tr>
        <td class="Label">Disk Space, MB:</td>
        <td><ad:NumericQuota quota="OS.Diskspace" /></td>
    </tr>
    <tr>
        <td class="Label">Bandwidth, MB/Month:</td>
        <td><ad:NumericQuota quota="OS.Bandwidth" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Domains:</td>
        <td><ad:NumericQuota quota="OS.Domains" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Sub-Domains:</td>
        <td><ad:NumericQuota quota="OS.SubDomains" /></td>
    </tr>
</table>

<ad:if test="#space.Groups.ContainsKey("Web")#">
<a name="web"></a>
<h1>Web</h1>
<a name="weblimits"></a>
<h2>
    Limits
</h2>
<table>
    <tr>
        <td class="Label">Maximum Number of Web Sites:</td>
        <td><ad:NumericQuota quota="Web.Sites" /></td>
    </tr>
	<tr>
        <td class="Label">Web Application Gallery:</td>
        <td><ad:BooleanQuota quota="Web.WebAppGallery" /></td>
    </tr>
    <tr>
        <td class="Label">Classic ASP:</td>
        <td><ad:BooleanQuota quota="Web.Asp" /></td>
    </tr>
    <tr>
        <td class="Label">ASP.NET 1.1:</td>
        <td><ad:BooleanQuota quota="Web.AspNet11" /></td>
    </tr>
    <tr>
        <td class="Label">ASP.NET 2.0:</td>
        <td><ad:BooleanQuota quota="Web.AspNet20" /></td>
    </tr>
    <tr>
        <td class="Label">ASP.NET 4.0:</td>
        <td><ad:BooleanQuota quota="Web.AspNet40" /></td>
    </tr>
    <tr>
        <td class="Label">PHP 4:</td>
        <td><ad:BooleanQuota quota="Web.Php4" /></td>
    </tr>
    <tr>
        <td class="Label">PHP 5:</td>
        <td><ad:BooleanQuota quota="Web.Php5" /></td>
    </tr>
    <tr>
        <td class="Label">Perl:</td>
        <td><ad:BooleanQuota quota="Web.Perl" /></td>
    </tr>
    <tr>
        <td class="Label">CGI-BIN:</td>
        <td><ad:BooleanQuota quota="Web.CgiBin" /></td>
    </tr>
</table>


<a name="dns"></a>
<h2>Name Servers</h2>
<p>
    In order to point your domain to the web site in this hosting space you should use the following Name Servers:
</p>
<table>
    <ad:foreach collection="#NameServers#" var="NameServer" index="i">
        <tr>
            <td class="Label">#NameServer#</td>
        </tr>
    </ad:foreach>
</table>
<p>
    You should change the name servers in domain registrar (Register.com, GoDaddy.com, etc.) control panel.
    Please, study domain registrar''s user manual for directions how to change name servers or contact your domain
    registrar directly by e-mail or phone.
</p>
<p>
    Please note, the changes in domain registrar database do not reflect immediately and sometimes it requires from
    12 to 48 hours till the end of DNS propagation.
</p>

<a name="sites"></a>
<h2>Web Sites</h2>
<p>
    The following web sites have been created under hosting space:
</p>
<table>
    <ad:foreach collection="#WebSites#" var="WebSite">
        <tr>
            <td><a href="http://#WebSite.Name#" target="_blank">http://#WebSite.Name#</a></td>
        </tr>
    </ad:foreach>
</table>
<p>
    * Please note, your web sites may not be accessible from 12 to 48 hours after you''ve changed name servers for their respective domains.
</p>

<ad:if test="#isnotempty(InstantAlias)#">
<a name="tempurl"></a>
<h2>Temporary URL</h2>
<p>
    You can access your web sites right now using their respective temporary URLs (instant aliases).
    Temporary URL is a sub-domain of the form http://yourdomain.com.providerdomain.com where &quot;yourdomain.com&quot; is your
    domain and &quot;providerdomain.com&quot; is the domain of your hosting provider.
</p>
<p>
    You can use the following Temporary URL for all your web sites:
</p>
<table>
    <tr>
        <td>
            http://YourDomain.com.<b>#InstantAlias#</b>
        </td>
    </tr>
</table>
</ad:if>

<a name="files"></a>
<h2>Files Location</h2>
<p>
    Sometimes it is required to know the physical location of the hosting space folder (absolute path).
    Hosting space folder is the folder where all hosting space files such as web sites content, web logs, data files, etc. are located.
</p>
<p>
    The root of your hosting space on our HDD is here:
</p>
<table>
    <tr>
        <td>
             #PackageRootFolder#
        </td>
    </tr>
</table>
<p>
    By default the root folder of any web site within your hosting space is built as following (you can change it anytime from the control panel):
</p>
<table>
    <tr>
        <td>
             #PackageRootFolder#\YourDomain.com\wwwroot
        </td>
    </tr>
</table>
</ad:if>


<ad:if test="#space.Groups.ContainsKey("FTP")#">
<a name="ftp"></a>
<h1>FTP</h1>

<a name="ftplimits"></a>
<h2>Limits</h2>
<table>
    <tr>
        <td class="Label">Maximum Number of FTP Accounts:</td>
        <td><ad:NumericQuota quota="FTP.Accounts" /></td>
    </tr>
</table>


<a name="ftpserver"></a>
<h2>FTP Server</h2>
<p>
Your hosting space allows working with your files by FTP.
You can use the following FTP server to access your space files remotely:
</p>
<table>
    <tr>
        <td><a href="ftp://#FtpIP#">ftp://#FtpIP#</a></td>
    </tr>
</table>
<p>
    Also, you can use the following domain names to access your FTP server:
</p>
<table>
    <tr>
        <td>ftp://ftp.YourDomain.com</td>
    </tr>
</table>
<ad:if test="#isnotempty(InstantAlias)#">
<p>
    During DNS propagation period (when domain name servers have been changed), similar to web sites, FTP server can be access with Temporary URL too:
</p>
<table>
    <tr>
        <td>ftp://ftp.YourDomain.com.<b>#InstantAlias#</b></td>
    </tr>
</table>
</ad:if>
<a name="ftpaccounts"></a>
<h2>FTP Accounts</h2>
<p>
    The following FTP accounts have been created under your hosting space and can be used to access FTP server:
</p>
<table>
    <thead>
        <tr>
            <th>Username</th>
            <ad:if test="#Signup#">
                <th>Password</th>
            </ad:if>
            <th>Folder</th>
        </tr>
    </thead>
    <tbody>
        <ad:foreach collection="#FtpAccounts#" var="FtpAcocunt" index="i">
            <tr>
                <td>#FtpAcocunt.Name#</td>
                <ad:if test="#Signup#">
                    <td>
                        #FtpAcocunt.Password#
                    </td>
                </ad:if>
                <td>#FtpAcocunt.Folder#</td>
            </tr>
        </ad:foreach>
    </tbody>
</table>
</ad:if>


<ad:if test="#space.Groups.ContainsKey("Mail")#">
<a name="mail"></a>
<h1>Mail</h1>

<a name="maillimits"></a>
<h2>Limits</h2>
<table>
    <tr>
        <td class="Label">Maximum Number of Mail Accounts:</td>
        <td><ad:NumericQuota quota="Mail.Accounts" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Mail Forwardings:</td>
        <td><ad:NumericQuota quota="Mail.Forwardings" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Mail Groups (Aliases):</td>
        <td><ad:NumericQuota quota="Mail.Groups" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Mailing Lists:</td>
        <td><ad:NumericQuota quota="Mail.Lists" /></td>
    </tr>
</table>

<a name="smtp"></a>
<h2>SMTP/POP3 Server</h2>
<p>
Below is the IP address of your POP3/SMTP/IMAP server. You can always access your mailbox(es)
using this IP address instead of actual POP3/SMTP/IMAP servers name:
</p>
<table>
	<tr>
		<td>
			#MailRecords[0].ExternalIP#
		</td>
	</tr>
</table>

<p>
    Also, you can use the following domain names to access SMTP/POP3 server from your favourite e-mail client software:
</p>
<table>
    <tr>
        <td>mail.YourDomain.com</td>
    </tr>
</table>

<ad:if test="#isnotempty(InstantAlias)#">
<p>
    During DNS propagation period (when domain name servers have been changed), similar to web sites, SMTP/POP3 server can be access with temporary domain too:
</p>
<table>
    <tr>
        <td>mail.YourDomain.com.<b>#InstantAlias#</b></td>
    </tr>
</table>
</ad:if>

<a name="mailaccounts"></a>
<h2>Mail Accounts</h2>
<p>
	The following mail accounts have been created under your hosting space:
</p>
<table>
	<thead>
		<tr>
			<th>E-mail</th>
			<th>Username (for POP3/SMTP/IMAP/WebMail)</th>
			<ad:if test="#Signup#">
				<th>Password</th>
			</ad:if>
		</tr>
	</thead>
	<tbody>
		<ad:foreach collection="#MailAccounts#" var="MailAccount">
			<tr>
				<td>#MailAccount.Name#</td>
				<td>#MailAccount.Name#</td>
				<ad:if test="#Signup#">
					<td>
						 #MailAccount.Password#
					</td>
				</ad:if>
			</tr>
		</ad:foreach>
	</tbody>
</table>
</ad:if>

<a name="db"></a>
<h1>Databases</h1>

<p>
	You can create databases and database users on "Space Home -&gt; Databases" screen in the control panel.
</p>

<ad:if test="#space.Groups.ContainsKey("MsSQL2000")#">
<a name="mssql2000"></a>

<h2>SQL Server 2000</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MsSQL2000.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MsSQL2000.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to SQL Server 2000 from Management Studio, Enterprise Manager, Query Analyzer
	or other client software you can use the following SQL Server address:
</p>
<table>
	<tr>
		<td>#MsSQL2000Address#</td>
	</tr>
</table>
<ad:MsSqlConnectionStrings server="#MsSQL2000Address#" />
</ad:if>

<ad:if test="#space.Groups.ContainsKey("MsSQL2005")#">
<a name="mssql2005"></a>

<h2>SQL Server 2005</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MsSQL2005.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MsSQL2005.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to SQL Server 2005 from Management Studio, Enterprise Manager, Query Analyzer
	or other client software you can use the following SQL Server address:
</p>
<table>
	<tr>
		<td>#MsSQL2005Address#</td>
	</tr>
</table>
<ad:MsSqlConnectionStrings server="#MsSQL2005Address#" />
</ad:if>

<ad:if test="#space.Groups.ContainsKey("MsSQL2008")#">
<a name="mssql2008"></a>

<h2>SQL Server 2008</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MsSQL2008.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MsSQL2008.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to SQL Server 2008 from Management Studio, Enterprise Manager, Query Analyzer
	or other client software you can use the following SQL Server address:
</p>
<table>
	<tr>
		<td>#MsSQL2008Address#</td>
	</tr>
</table>
<ad:MsSqlConnectionStrings server="#MsSQL2008Address#" />
</ad:if>

<ad:if test="#space.Groups.ContainsKey("MsSQL2012")#">
<a name="mssql2012"></a>

<h2>SQL Server 2012</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MsSQL2012.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MsSQL2012.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to SQL Server 2012 from Management Studio, Enterprise Manager, Query Analyzer
	or other client software you can use the following SQL Server address:
</p>
<table>
	<tr>
		<td>#MsSQL2012Address#</td>
	</tr>
</table>
<ad:MsSqlConnectionStrings server="#MsSQL2012Address#" />
</ad:if>

<ad:if test="#space.Groups.ContainsKey("MySQL4")#">
<a name="mysql4"></a>
<h2>MySQL 4.x</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MySQL4.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MySQL4.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to MySQL 4.x server you can use the following address:
</p>
<table>
	<tr>
		<td>#MySQL4Address#</td>
	</tr>
</table>
</ad:if>


<ad:if test="#space.Groups.ContainsKey("MySQL5")#">
<a name="mysql5"></a>
<h2>MySQL 5.x</h2>

<table>
    <tr>
        <td class="Label">Maximum Number of Databases:</td>
        <td><ad:NumericQuota quota="MySQL5.Databases" /></td>
    </tr>
    <tr>
        <td class="Label">Maximum Number of Users:</td>
        <td><ad:NumericQuota quota="MySQL5.Users" /></td>
    </tr>
</table>

<p>
	In order to connect to MySQL 5.x server you can use the following address:
</p>
<table>
	<tr>
		<td>#MySQL5Address#</td>
	</tr>
</table>
</ad:if>


<a name="msaccess"></a>
<h2>Microsoft Access</h2>
<p>
	Microsoft Access database are automatically allowed in any hosting plan. You can create/upload any number of Access
	database from File Manager in control panel.
</p>


<ad:if test="#space.Groups.ContainsKey("Statistics")#">
<a name="stats"></a>
<h1>Web Statistics</h1>

<table>
    <tr>
        <td class="Label">Maximum Number of Statistics Sites:</td>
        <td><ad:NumericQuota quota="Stats.Sites" /></td>
    </tr>
</table>

<p>
	You can view advanced statistics from your domain using URL of the following form:
</p>
<table>
	<tr>
		<td>http://stats.YourDomain.com</td>
	</tr>
</table>
<ad:if test="#isnotempty(InstantAlias)#">
<p>
    During DNS propagation period (when domain name servers have been changed), you can access web site statistics with Temporary URL:
</p>
<table>
    <tr>
        <td>http://stats.YourDomain.com.<b>#InstantAlias#</b></td>
    </tr>
</table>
</ad:if>
</ad:if>

<ad:if test="#Signup#">
<p>
If you have any questions regarding your hosting account, feel free to contact our support department at any time.
</p>

<p>
Best regards,<br />
ACME Hosting Inc.<br />
Web Site: <a href="http://www.AcmeHosting.com">www.AcmeHosting.com</a><br />
E-Mail: <a href="mailto:support@AcmeHosting.com">support@AcmeHosting.com</a>
</p>
</ad:if>

<!-- Templates -->
<ad:template name="MsSqlConnectionStrings">
<p>
	You may also use SQL Server address above in your application connection strings, for example:
</p>
<table>
	<tr>
		<td class="Label">Classic ASP (ADO Library)</td>
		<td>Provider=SQLOLEDB;Data source=<b>#server#</b>;Initial catalog=databaseName;User Id=userName;Password=password;</td>
	</tr>
	<tr>
		<td class="Label">ASP.NET (ADO.NET Library)</td>
		<td>Server=<b>#server#</b>;Database=databaseName;Uid=userName;Password=password;</td>
	</tr>
</table>
</ad:template>

<ad:template name="NumericQuota">
	<ad:if test="#space.Quotas.ContainsKey(quota)#">
		<ad:if test="#space.Quotas[quota].QuotaAllocatedValue isnot -1#">#space.Quotas[quota].QuotaAllocatedValue#<ad:else>Unlimited</ad:if>
	<ad:else>
		0
	</ad:if>
</ad:template>

<ad:template name="BooleanQuota">
	<ad:if test="#space.Quotas.ContainsKey(quota)#">
		<ad:if test="#space.Quotas[quota].QuotaAllocatedValue isnot 0#">Enabled<ad:else>Disabled</ad:if>
	<ad:else>
		Disabled
	</ad:if>
</ad:template>

</div>
</body>
</html>' WHERE [PropertyName] = N'HtmlBody'
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









ALTER TABLE [dbo].[GlobalDnsRecords] ADD
	[SrvPriority] [int] NULL,
	[SrvWeight] [int] NULL,
	[SrvPort] [int] NULL

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








USE [WebsitePanel]
GO
/****** Object:  StoredProcedure [dbo].[GetDnsRecordsByServer]    Script Date: 06/01/2011 23:42:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	RecordType nvarchar(10) COLLATE DATABASE_DEFAULT,
	RecordName nvarchar(50) COLLATE DATABASE_DEFAULT
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