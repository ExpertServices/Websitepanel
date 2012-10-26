If WScript.Arguments.Count <> 2 Then
	WScript.Echo "Usage: cscript zip.vbs <zipPath> <dirToZip>"
Else
	CreateZip WScript.Arguments(0), WScript.Arguments(1)
End If

Sub NewZip(pathToZipFile)
 
   'WScript.Echo "Newing up a zip file (" & pathToZipFile & ") "
 
   Dim fso
   Set fso = CreateObject("Scripting.FileSystemObject")
   Dim file
   Set file = fso.CreateTextFile(pathToZipFile)
 
   file.Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
 
   file.Close
   Set fso = Nothing
   Set file = Nothing
 
   WScript.Sleep 500
 
End Sub
 
Sub CreateZip(pathToZipFile, dirToZip)
 
   'WScript.Echo "Creating zip  (" & pathToZipFile & ") from (" & dirToZip & ")"
 
   Dim fso
   Set fso= Wscript.CreateObject("Scripting.FileSystemObject")
 
   pathToZipFile = fso.GetAbsolutePathName(pathToZipFile)
   dirToZip = fso.GetAbsolutePathName(dirToZip)
 
   If fso.FileExists(pathToZipFile) Then
       'WScript.Echo "That zip file already exists - deleting it."
       fso.DeleteFile pathToZipFile
   End If
 
   If Not fso.FolderExists(dirToZip) Then
       'WScript.Echo "The directory to zip does not exist."
       Exit Sub
   End If
 
   NewZip pathToZipFile
 
   dim sa
   set sa = CreateObject("Shell.Application")
 
   Dim zip
   Set zip = sa.NameSpace(pathToZipFile)
 
   'WScript.Echo "opening dir  (" & dirToZip & ")"
 
   Dim d
   Set d = sa.NameSpace(dirToZip)
 
   ' Look at http://msdn.microsoft.com/en-us/library/bb787866(VS.85).aspx
   ' for more information about the CopyHere function.
   zip.CopyHere d.items, 4
 
   Do Until d.Items.Count <= zip.Items.Count
       Wscript.Sleep(200)
   Loop
 
End Sub

Sub ExtractFilesFromZip(pathToZipFile, dirToExtractFiles)
 
    Dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")
 
    pathToZipFile = fso.GetAbsolutePathName(pathToZipFile)
    dirToExtractFiles = fso.GetAbsolutePathName(dirToExtractFiles)
 
    If (Not fso.FileExists(pathToZipFile)) Then
        WScript.Echo "Zip file does not exist: " & pathToZipFile
        Exit Sub
    End If
 
    If Not fso.FolderExists(dirToExtractFiles) Then
        WScript.Echo "Directory does not exist: " & dirToExtractFiles
        Exit Sub
    End If
 
    dim sa
    set sa = CreateObject("Shell.Application")
 
    Dim zip
    Set zip = sa.NameSpace(pathToZipFile)
 
    Dim d
    Set d = sa.NameSpace(dirToExtractFiles)
 
    ' Look at http://msdn.microsoft.com/en-us/library/bb787866(VS.85).aspx
    ' for more information about the CopyHere function.
    d.CopyHere zip.items, 4
 
    Do Until zip.Items.Count <= d.Items.Count
        Wscript.Sleep(200)
    Loop
 
End Sub