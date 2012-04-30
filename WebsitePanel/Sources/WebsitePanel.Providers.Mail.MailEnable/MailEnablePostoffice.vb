Namespace WebsitePanel.Providers.Mail

    Public Class MailEnablePostoffice
        Inherits MarshalByRefObject

        Private NameVal As String
        Private StatusVal As Long
        Private AccountVal As String
        Private HostVal As String

        Private Structure IPOSTOFFICETYPE
            <VBFixedString(128), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=128)> Public Name As String
            Public Status As Integer
            <VBFixedString(128), System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValTStr, SizeConst:=128)> Public Account As String
        End Structure


        Private Declare Function PostofficeGet Lib "MEAIPO.DLL" (ByRef lpPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function PostofficeFindFirst Lib "MEAIPO.DLL" (ByRef lpPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function PostofficeFindNext Lib "MEAIPO.DLL" (ByRef lpPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function PostofficeAdd Lib "MEAIPO.DLL" (ByRef lpPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function PostofficeEdit Lib "MEAIPO.DLL" (ByRef TargetPostoffice As IPOSTOFFICETYPE, ByRef NewPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function PostofficeRemove Lib "MEAIPO.DLL" (ByRef lpPostoffice As IPOSTOFFICETYPE) As Integer
        Private Declare Function SetCurrentHost Lib "MEAIPO.DLL" (ByVal CurrentHost As String) As Integer

        Public Function SetHost() As Integer
            SetHost = SetCurrentHost(Host)
        End Function


        Public Function FindFirstPostoffice() As Integer
            Dim CPostoffice As IPOSTOFFICETYPE
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            FindFirstPostoffice = PostofficeFindFirst(CPostoffice)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status
        End Function
        Public Function FindNextPostoffice() As Integer
            Dim CPostoffice As IPOSTOFFICETYPE
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            FindNextPostoffice = PostofficeFindNext(CPostoffice)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status
        End Function

        Public Function AddPostoffice() As Integer
            Dim CPostoffice As IPOSTOFFICETYPE
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            AddPostoffice = PostofficeAdd(CPostoffice)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status
        End Function

        Public Function GetPostoffice() As Integer
            Dim CPostoffice As IPOSTOFFICETYPE
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            GetPostoffice = PostofficeGet(CPostoffice)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status
        End Function
        Public Function RemovePostoffice() As Integer
            Dim CPostoffice As IPOSTOFFICETYPE
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            RemovePostoffice = PostofficeRemove(CPostoffice)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status
        End Function


        Public Function EditPostoffice(ByVal NewName As String, ByVal NewStatus As Long, ByVal NewAccount As String) As Integer

            Dim CPostoffice As IPOSTOFFICETYPE
            Dim CPostofficeData As IPOSTOFFICETYPE

            ' Get the Find Stuff Set up
            CPostoffice.Account = Account
            CPostoffice.Name = Name
            CPostoffice.Status = Status
            ' Get the Data Set up
            CPostofficeData.Account = NewAccount
            CPostofficeData.Name = NewName
            CPostofficeData.Status = NewStatus
            EditPostoffice = PostofficeEdit(CPostoffice, CPostofficeData)
            Account = CPostoffice.Account
            Name = CPostoffice.Name
            Status = CPostoffice.Status

        End Function


        Public Property Name() As String
            Get
                Return Me.NameVal
            End Get
            Set(ByVal value As String)
                Me.NameVal = value
            End Set
        End Property

        Public Property Status() As Long
            Get
                Return Me.StatusVal
            End Get
            Set(ByVal value As Long)
                Me.StatusVal = value
            End Set
        End Property

        Public Property Account() As String
            Get
                Return Me.AccountVal
            End Get
            Set(ByVal value As String)
                Me.AccountVal = value
            End Set
        End Property

        Public Property Host() As String
            Get
                Return Me.HostVal
            End Get
            Set(ByVal value As String)
                Me.HostVal = value
            End Set
        End Property

    End Class

End Namespace
