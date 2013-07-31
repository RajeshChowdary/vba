Attribute VB_Name = "UsrInfo"
Dim usrName As String
Dim usrLog As String
Dim usrType As String
Dim usrEmail As String
Dim compColl As Collection
Dim typeColl As Collection
Dim shtToWork As Worksheet
Dim cachedSht As Worksheet

Function usr_init() As Collection
    Dim tmpColl As New Collection
    
    Set cachedSht = ActiveSheet
    
    usrLog = Environ("USERNAME")
    Set compColl = New Collection
    Set typeColl = New Collection
        
    Call find_usr
    tmpColl.Add usrLog, "login"
    tmpColl.Add usrName, "name"
    tmpColl.Add typeColl, "type"
    tmpColl.Add compColl, "company"
    tmpColl.Add usrEmail, "mail"
    Set usr_init = tmpColl
    
    cachedSht.Activate
End Function


Private Sub find_usr()

    'examine company's owners
    Sheets("user_table").Select

    Call fillUsrInfoFromSht(ActiveSheet)
    
    'examine msfo users
    Sheets("msfo_table").Select
    Call fillUsrInfoFromSht(ActiveSheet)

End Sub
Private Sub fillUsrInfoFromSht(shtToWork As Worksheet)
    Dim foundCell As Range
    Dim nextFoundCell As Range
    Dim foundCellAddr As String
    Dim tmpArr As Variant
    Dim tmpStr As String
    
    shtToWork.Select
    Columns("C:C").Select
    Set foundCell = Selection.find(what:=usrLog, after:=ActiveCell, LookIn:=xlFormulas _
        , LookAt:=xlWhole, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False)
    If Not foundCell Is Nothing Then
        tmpArr = Split(shtToWork.Name, "_")
        typeColl.Add (tmpArr(0)) 'user could be of two types
        Debug.Assert typeColl.Count <= 2
        usrName = Cells(foundCell.Row, foundCell.Column - 1).Value
        usrEmail = Cells(foundCell.Row, foundCell.Column + 1).Value
        foundCellAddr = foundCell.Address
        Do While Not foundCell Is Nothing
            tmpStr = Cells(foundCell.Row, foundCell.Column - 2).Value
            If Not isExistInCol(tmpStr, compColl) Then
                compColl.Add tmpStr
                tmpStr = ""
            End If
            foundCell.Activate
            Set foundCell = Selection.FindNext(ActiveCell)
            If foundCellAddr = foundCell.Address Then Exit Do
        Loop
    End If
    'cleaning
    Set foundCell = Nothing
    
End Sub


Function isCompanyInUsrCompColl(compName As String) As Boolean
    
    compName = Trim(LCase(compName))
    
    For Each comp In compColl
        If comp = compName Then
            isCompanyInUsrCompColl = True
            Exit Function
        End If
    Next comp
    
End Function

Function isUsrHasApprType(statVal As String) As Boolean

    If (statVal = "������ �������� ������" Or statVal = "�������" Or statVal = "�� ���������") And isExistInCol("msfo", typeColl) Then
        isUsrHasApprType = True
    ElseIf (statVal = "������ �������" Or statVal = "���� �����" Or statVal = "�� ���������") And isExistInCol("user", typeColl) Then
        isUsrHasApprType = True
    End If
End Function


