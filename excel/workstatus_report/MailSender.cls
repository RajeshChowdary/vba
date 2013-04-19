VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MailSender"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim tmpaddresList As String
Dim tmpText As String
Dim tmpSubject As String
Dim compName As String, formName As String, perName As String
Dim workStatSht As Worksheet
Dim f As UserFormMessage




Sub SendStatusMail(addresList, text, subject)
    '
    Dim objOutlook As Object
    Dim objOutlookMsg As Object
    Dim objOutlookRecip As Object
    Dim objOutlookAttach As Object
    '
    Set objOutlook = CreateObject("Outlook.Application")
    Set objOutlookMsg = objOutlook.CreateItem(olMailItem)
    '
    With objOutlookMsg
        '
        .To = addresList
        .subject = subject
        .Body = text
        .Send
    End With
    '
    Set objOutlookMsg = Nothing
    Set objOutlook = Nothing
    Set objOutlookRecip = Nothing
    Set objOutlookAttach = Nothing
    '
End Sub
Sub ShowSendMessage()
    '
    Set f = New UserFormMessage
    '
    f.TextBoxSubject = tmpSubject
    f.TextBoxText = tmpText
    f.TextBoxTo = tmpaddresList
    '
    f.Show
    '
End Sub


Public Function sendMsg(targAddr As String, oldVal As String) As Boolean
    Dim tmpRng As Range
    
    Set workStatSht = ActiveWorkbook.Sheets("Workstatus")
    Set tmpRng = workStatSht.Range(targAddr)
    Call initVars(tmpRng)
    tmpText = collectMsg(tmpRng.Value, oldVal)
    tmpaddresList = getAprAddr()
    tmpSubject = "�������� �� ������ ��������� �������"
    Call ShowSendMessage
    If f.msgWasSent Then
        sendMsg = True
    End If
End Function

Public Function completeSendMsg() As Boolean
    Debug.Assert False
    SendStatusMail f.TextBoxTo.Value, f.TextBoxText.Value, f.TextBoxSubject.Value
    Unload f
    Set workStatSht = Nothing
End Function

Private Function collectMsg(newVal As String, oldVal As String) As String
    collectMsg = "������ ��� ��������: " & compName & " �����: " & formName & " �������: " & perName & " ��� ������� �� ������� " & oldVal & " �� " & newVal
End Function

Private Function getAprAddr() As String
    getAprAddr = "Chernokalskayaea@dtek.com" '"galkinva@dtek.com"
    Debug.Assert False
End Function

Private Sub initVars(changedRng As Range)
    
    compName = workStatSht.Cells(10, changedRng.Column).Value
    formName = workStatSht.Cells(changedRng.Row, 12).Value
    perName = workStatSht.Range("N3").Value
End Sub