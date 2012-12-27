' Copyright (c) 2012, Outercurve Foundation.
' All rights reserved.
'
' Redistribution and use in source and binary forms, with or without modification,
' are permitted provided that the following conditions are met:
'
' - Redistributions of source code must  retain  the  above copyright notice, this
'   list of conditions and the following disclaimer.
'
' - Redistributions in binary form  must  reproduce the  above  copyright  notice,
'   this list of conditions  and  the  following  disclaimer in  the documentation
'   and/or other materials provided with the distribution.
'
' - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
'   contributors may be used to endorse or  promote  products  derived  from  this
'   software without specific prior written permission.
'
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
' ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
' WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
' ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
' (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
' ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.IO
Imports System.Text
Imports System.Diagnostics
Imports Microsoft.Win32
Imports WebsitePanel.Providers.Utils
Imports WebsitePanel.Providers.Utils.LogParser
Imports WebsitePanel.Server.Utils

Public Class MELogReader
	Inherits LogReader


	Protected Overrides Sub ParseFieldValues()

        ErrorLine = False
        SystemLine = False
        record.Clear()
        If line.EndsWith(" ") Then
			line = line.Remove(line.Length - 1)
        End If
        fieldsValues = line.Split(FIELDS_SPLITTER, StringSplitOptions.None)
		If (fieldsValues.Length <> fieldsLength) Then
			ErrorLine = True
		End If
	End Sub

End Class
