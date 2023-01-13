Imports System.IO
Imports System.Net

' FTP connection details
Dim ftp_host As String = "ftp.example.com"
Dim ftp_user As String = "username"
Dim ftp_passwd As String = "password"

' Remote and local directories
Dim remote_dir As String = "/path/to/remote/directory/"
Dim local_dir As String = "C:\path\to\local\directory\"

' Create new sub-directory with current date and time
Dim current_time As String = DateTime.Now.ToString("yyyy-MM-dd HH-mm-ss")
Dim local_subdir As String = local_dir & current_time & "\"
Directory.CreateDirectory(local_subdir)

' Connect to FTP server
Dim ftp As FtpWebRequest = DirectCast(WebRequest.Create(ftp_host), FtpWebRequest)
ftp.Credentials = New NetworkCredential(ftp_user, ftp_passwd)
ftp.Method = WebRequestMethods.Ftp.ListDirectory
ftp.KeepAlive = False
ftp.UseBinary = True

' Get list of files in remote directory
Dim response As FtpWebResponse = ftp.GetResponse
Dim stream As Stream = response.GetResponseStream
Dim reader As New StreamReader(stream)
Dim files As String() = reader.ReadToEnd().Split(ControlChars.Lf)

' Loop through files and download to local sub-directory
For Each file As String In files
    If Not String.IsNullOrEmpty(file) Then
        ' Get file timestamp
        ftp = DirectCast(WebRequest.Create(ftp_host & remote_dir & file), FtpWebRequest)
        ftp.Credentials = New NetworkCredential(ftp_user, ftp_passwd)
        ftp.Method = WebRequestMethods.Ftp.GetDateTimestamp
        ftp.KeepAlive = False
        ftp.UseBinary = True
        Dim timestamp As DateTime = ftp.GetResponse().LastModified

        ' Check if file is no older than 20 hours
        If (DateTime.Now - timestamp).TotalHours < 20 Then
            ' download the file
            ftp = DirectCast(WebRequest.Create(ftp_host & remote_dir & file), FtpWebRequest)
            ftp.Credentials = New NetworkCredential(ftp_user, ftp_passwd)
            ftp.Method = WebRequestMethods.Ftp.DownloadFile
            ftp.KeepAlive = False
            ftp.UseBinary = True
            Dim ftpResponse As FtpWebResponse = ftp.GetResponse()
            Dim ftpStream As Stream = ftpResponse.GetResponseStream
            Dim localFile As New FileStream(local_subdir & file, FileMode.Create)
            ftpStream.CopyTo(localFile)
            ftpResponse.Close()
            localFile.Close()
        End If
    End If
Next

response.Close()
