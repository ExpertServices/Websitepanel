Option Strict Off
Option Explicit On

Namespace WebsitePanel.Providers.Mail
    Public Class MailEnableAddressMap
        Inherits MarshalByRefObject

        Private AccountVal As String = ""
        Private SourceAddressVal As String = ""
        Private DestinationAddressVal As String = ""
        Private ScopeVal As String = ""
        Private HostVal As String = ""
        Private StatusVal As Integer

        Private Structure IADDRESSMAPENTRYTYPE
            <VBFixedString(1024), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=1024)> Public Account As String
            <VBFixedString(1024), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=1024)> Public SourceAddress As String
            <VBFixedString(1024), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=1024)> Public DestinationAddress As String
            <VBFixedString(1024), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=1024)> Public Scope As String
            Public Status As Integer
        End Structure

        Private Declare Function AddressMapGet Lib "MEAIAM.DLL" (ByRef lpAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function AddressMapFindFirst Lib "MEAIAM.DLL" (ByRef lpAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function AddressMapFindNext Lib "MEAIAM.DLL" (ByRef lpAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function AddressMapAdd Lib "MEAIAM.DLL" (ByRef lpAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function AddressMapEdit Lib "MEAIAM.DLL" (ByRef TargetAddressMap As IADDRESSMAPENTRYTYPE, ByRef NewAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function AddressMapRemove Lib "MEAIAM.DLL" (ByRef lpAddressMap As IADDRESSMAPENTRYTYPE) As Integer
        Private Declare Function SetCurrentHost Lib "MEAIAM.DLL" (ByVal CurrentHost As String) As Integer

        Public Function SetHost() As Integer
            SetHost = SetCurrentHost(Host)
        End Function

        Public Function GetAddressMap() As Integer

            Dim CAddressMap As IADDRESSMAPENTRYTYPE

            CAddressMap.Account = Account
            CAddressMap.SourceAddress = SourceAddress
            CAddressMap.DestinationAddress = DestinationAddress
            CAddressMap.Scope = Scope
            CAddressMap.Status = Status
            GetAddressMap = AddressMapGet(CAddressMap)
            Account = CAddressMap.Account
            SourceAddress = CAddressMap.SourceAddress
            DestinationAddress = CAddressMap.DestinationAddress
            Scope = CAddressMap.Scope
            Status = CAddressMap.Status
        End Function

        Public Function FindFirstAddressMap() As Integer
            Dim CAddressMap As IADDRESSMAPENTRYTYPE
            CAddressMap.Account = Account
            CAddressMap.SourceAddress = SourceAddress
            CAddressMap.DestinationAddress = DestinationAddress
            CAddressMap.Scope = Scope
            CAddressMap.Status = Status
            FindFirstAddressMap = AddressMapFindFirst(CAddressMap)
            Account = CAddressMap.Account
            SourceAddress = CAddressMap.SourceAddress
            DestinationAddress = CAddressMap.DestinationAddress
            Scope = CAddressMap.Scope
            Status = CAddressMap.Status
        End Function

        Public Function FindNextAddressMap() As Integer
            Dim CAddressMap As IADDRESSMAPENTRYTYPE
            CAddressMap.Account = Account
            CAddressMap.SourceAddress = SourceAddress
            CAddressMap.DestinationAddress = DestinationAddress
            CAddressMap.Scope = Scope
            CAddressMap.Status = Status
            FindNextAddressMap = AddressMapFindNext(CAddressMap)
            Account = CAddressMap.Account
            SourceAddress = CAddressMap.SourceAddress
            DestinationAddress = CAddressMap.DestinationAddress
            Scope = CAddressMap.Scope
            Status = CAddressMap.Status
        End Function

        Public Function AddAddressMap() As Integer
            Dim CAddressMap As IADDRESSMAPENTRYTYPE
            CAddressMap.Account = Account
            CAddressMap.SourceAddress = SourceAddress
            CAddressMap.DestinationAddress = DestinationAddress
            CAddressMap.Scope = Scope
            CAddressMap.Status = Status
            AddAddressMap = AddressMapAdd(CAddressMap)
            Account = CAddressMap.Account
            SourceAddress = CAddressMap.SourceAddress
            DestinationAddress = CAddressMap.DestinationAddress
            Scope = CAddressMap.Scope
            Status = CAddressMap.Status
        End Function

        Private Function CString(ByVal InString As String) As String
            CString = InString & Chr(0)
        End Function

        Private Function NonCString(ByVal InString As String) As String
            Dim NTPos As Integer
            NTPos = InStr(1, InString, Chr(0), CompareMethod.Binary)
            If NTPos > 0 Then
                NonCString = Left(InString, NTPos - 1)
            Else
                NonCString = InString
            End If

        End Function
        Public Function RemoveAddressMap(Optional ByVal DeleteAll As Boolean = False) As Integer
            Dim CAddressMap As IADDRESSMAPENTRYTYPE
            Dim lResult As Long

            'if the one to remove is a catchall we need to rename first
            If Not DeleteAll And InStr(1, SourceAddress, "[SMTP:*@", vbTextCompare) = 1 Then

                Dim oAddressMap As New MailEnableAddressMap

                With oAddressMap
                    .Account = Account
                    .DestinationAddress = DestinationAddress
                    .Scope = ""
                    .SourceAddress = SourceAddress
                End With

                lResult = oAddressMap.EditAddressMap(Account, "[SMTP:___~@deleteme]", "[SF:___~" & Account & "/toremove]", "", -1)

                oAddressMap = Nothing

                CAddressMap.Account = CString(Account)
                CAddressMap.SourceAddress = CString("[SMTP:___~@deleteme]")
                CAddressMap.DestinationAddress = CString("[SF:___~" & Account & "/toremove]")
                CAddressMap.Scope = CString("")
                CAddressMap.Status = Status
                RemoveAddressMap = AddressMapRemove(CAddressMap)
                Account = NonCString(CAddressMap.Account)
                SourceAddress = NonCString(CAddressMap.SourceAddress)
                DestinationAddress = NonCString(CAddressMap.DestinationAddress)
                Scope = NonCString(CAddressMap.Scope)
                Status = CAddressMap.Status

                Exit Function
            End If

            CAddressMap.Account = CString(Account)
            CAddressMap.SourceAddress = CString(SourceAddress)
            CAddressMap.DestinationAddress = CString(DestinationAddress)
            CAddressMap.Scope = CString(Scope)
            CAddressMap.Status = Status
            RemoveAddressMap = AddressMapRemove(CAddressMap)
            Account = NonCString(CAddressMap.Account)
            SourceAddress = NonCString(CAddressMap.SourceAddress)
            DestinationAddress = NonCString(CAddressMap.DestinationAddress)
            Scope = NonCString(CAddressMap.Scope)
            Status = CAddressMap.Status
        End Function

        Public Function EditAddressMap(ByVal NewAccount As String, ByVal NewSourceAddress As String, ByVal NewDestinationAddress As String, ByVal NewScope As String, ByVal NewStatus As Integer) As Integer
            Dim CAddressMap As IADDRESSMAPENTRYTYPE
            Dim CAddressMapData As IADDRESSMAPENTRYTYPE
            CAddressMap.Account = Account
            CAddressMap.SourceAddress = SourceAddress
            CAddressMap.DestinationAddress = DestinationAddress
            CAddressMap.Scope = Scope
            CAddressMap.Status = Status

            CAddressMapData.Account = NewAccount
            CAddressMapData.SourceAddress = NewSourceAddress
            CAddressMapData.DestinationAddress = NewDestinationAddress
            CAddressMapData.Scope = NewScope
            CAddressMapData.Status = NewStatus
            EditAddressMap = AddressMapEdit(CAddressMap, CAddressMapData)
        End Function

        Public Property Account() As String
            Get
                Return Me.AccountVal
            End Get
            Set(ByVal Value As String)
                Me.AccountVal = Value
            End Set
        End Property

        Public Property SourceAddress() As String
            Get
                Return Me.SourceAddressVal
            End Get
            Set(ByVal Value As String)
                Me.SourceAddressVal = Value
            End Set
        End Property

        Public Property DestinationAddress() As String
            Get
                Return Me.DestinationAddressVal
            End Get
            Set(ByVal Value As String)
                Me.DestinationAddressVal = Value
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


        Public Property Scope() As String
            Get
                Return Me.ScopeVal
            End Get
            Set(ByVal Value As String)
                Me.ScopeVal = Value
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
