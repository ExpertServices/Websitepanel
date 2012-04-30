Option Strict Off
Option Explicit On

Namespace WebsitePanel.Providers.Mail

    Public Class MailEnableDomainBlacklist
        Inherits MarshalByRefObject

        Private TargetDomainNameVal As String
        Private BannedDomainNameVal As String
        Private StatusVal As Integer
        Private AccountVal As String
        Private HostVal As String

        Private Structure ISMTPBLACKLISTTYPE
            <VBFixedString(512), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=512)> Public TargetDomainName As String
            <VBFixedString(512), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=512)> Public BannedDomainName As String
            Public Status As Integer
            <VBFixedString(128), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=128)> Public Account As String
        End Structure

        Private Declare Function SMTPBlacklistAdd Lib "MEAISM.DLL" (ByRef SMTPBlacklist As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SMTPBlacklistGet Lib "MEAISM.DLL" (ByRef SMTPBlacklistCriteria As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SMTPBlacklistEdit Lib "MEAISM.DLL" (ByRef SMTPBlacklistCriteria As ISMTPBLACKLISTTYPE, ByRef SMTPBlacklistData As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SMTPBlacklistRemove Lib "MEAISM.DLL" (ByRef SMTPBlacklist As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SMTPBlacklistFindFirst Lib "MEAISM.DLL" (ByRef SMTPBlacklist As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SMTPBlacklistFindNext Lib "MEAISM.DLL" (ByRef SMTPBlacklist As ISMTPBLACKLISTTYPE) As Integer
        Private Declare Function SetCurrentHost Lib "MEAISM.DLL" (ByVal CurrentHost As String) As Integer

        Public Function SetHost() As Integer
            SetHost = SetCurrentHost(Host)
        End Function

        Public Function AddBlacklist() As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account

            AddBlacklist = SMTPBlacklistAdd(CBlacklist)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function


        Public Function GetBlacklist() As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account

            GetBlacklist = SMTPBlacklistGet(CBlacklist)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function


        Public Function EditBlacklist(ByVal NewTargetDomainName As String, ByVal NewBannedDomainName As String, ByVal NewStatus As Integer, ByVal NewAccount As String) As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE
            Dim CBlacklistData As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account
            CBlacklistData.TargetDomainName = NewTargetDomainName
            CBlacklistData.BannedDomainName = NewBannedDomainName
            CBlacklistData.Status = NewStatus
            CBlacklistData.Account = NewAccount

            EditBlacklist = SMTPBlacklistEdit(CBlacklist, CBlacklistData)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function


        Public Function RemoveBlacklist() As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account

            RemoveBlacklist = SMTPBlacklistRemove(CBlacklist)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function


        Public Function FindFirstBlacklist() As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account

            FindFirstBlacklist = SMTPBlacklistFindFirst(CBlacklist)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function


        Public Function FindNextBlacklist() As Integer

            Dim CBlacklist As ISMTPBLACKLISTTYPE

            CBlacklist.TargetDomainName = TargetDomainName
            CBlacklist.BannedDomainName = BannedDomainName
            CBlacklist.Status = Status
            CBlacklist.Account = Account

            FindNextBlacklist = SMTPBlacklistFindNext(CBlacklist)

            TargetDomainName = CBlacklist.TargetDomainName
            BannedDomainName = CBlacklist.BannedDomainName
            Status = CBlacklist.Status
            Account = CBlacklist.Account

        End Function

        Public Property TargetDomainName() As String
            Get
                Return Me.TargetDomainNameVal
            End Get
            Set(ByVal Value As String)
                Me.TargetDomainNameVal = Value
            End Set
        End Property

        Public Property BannedDomainName() As String
            Get
                Return Me.BannedDomainNameVal
            End Get
            Set(ByVal Value As String)
                Me.BannedDomainNameVal = Value
            End Set
        End Property

        Public Property Status() As Integer
            Get
                Return Me.StatusVal
            End Get
            Set(ByVal Value As Integer)
                Me.StatusVal = Value
            End Set
        End Property

        Public Property Account() As String
            Get
                Return Me.AccountVal
            End Get
            Set(ByVal Value As String)
                Me.AccountVal = Value
            End Set
        End Property

        Public Property Host() As String
            Get
                Return Me.HostVal
            End Get
            Set(ByVal Value As String)
                Me.HostVal = Value
            End Set
        End Property

    End Class

End Namespace
