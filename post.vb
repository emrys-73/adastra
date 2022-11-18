Public Sub DoSomePostMagic(URL)
    Try
        Dim myReq As HttpWebRequest
        Dim myResp As HttpWebResponse
        Dim myReader As StreamReader
        myReq = HttpWebRequest.Create(URL)
        myReq.Method = "POST"
        myReq.ContentType = "application/json"
        myReq.Accept = "application/json"
        myReq.Headers.Add("Authorization", "Bearer MyUltraSecretToken")
        Dim myData As String = "{""Nombre"":""Adrian"",""userId"":""10000004030"",""RUC"":""agsvfhjklasgj""}"
        myReq.GetRequestStream.Write(System.Text.Encoding.UTF8.GetBytes(myData), 0, System.Text.Encoding.UTF8.GetBytes(myData).Count)
        myResp = myReq.GetResponse
        myReader = New System.IO.StreamReader(myResp.GetResponseStream)
        TextBox1.Text = myReader.ReadToEnd
    Catch ex As Exception
        TextBox1.Text = TextBox1.Text & "Error: " & ex.Message
    End Try
End Sub