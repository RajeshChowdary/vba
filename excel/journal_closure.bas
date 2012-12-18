Attribute VB_Name = "journal_closure"
Sub UseCanCheckOut(targetVal As String, modName As String)


    Dim xlApp As Excel.Application
    Dim wb As Workbook
    Dim xlFile As String
    Dim foundCell As Range
    Dim wSht As Worksheet
    
    'xlFile = "https://workspaces.dtek.com/it/oisup/ProjectSAP/ChangeManagement/������%20�����������%20���������%20�%20��������%20SAP.xlsm"
    xlFile = "https://workspaces.dtek.com/it/oisup/ProjectSAP/ChangeManagement/test.xlsm"
    
    'Determine if workbook can be checked out.
    If Workbooks.CanCheckOut(xlFile) = True Then
        Workbooks.CheckOut xlFile
        
        'Set xlApp = New Excel.Application
        'xlApp.Visible = True
        'xlApp.EnableEvents = False
        
        Set wb = Workbooks.Open(xlFile, , False)
        Set wSht = wb.Sheets("������ �������� �� �������")
        wSht.Select
        Application.EnableEvents = False
        
        wSht.UsedRange.AutoFilter Field:=3, Criteria1:=Array(modName), Operator:=xlFilterValues
        
        wSht.Columns("B:B").Select
    
        Set foundCell = Selection.Find(What:=targetVal, After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlWhole, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False)
        
        If foundCell Is Nothing Then
            MsgBox "Change number that you have entered doesn't exist"
            '@todo clear value that have been entered in developers journal
            
        Else
        
            Cells(foundCell.Row, foundCell.Column + 2).Value = changeToVal
        
        End If
        
        'MsgBox wb.Name & " is checked out to you."
        'xlApp.EnableEvents = True
        Application.EnableEvents = True
        wb.CheckIn (True)
    Else
    '
        MsgBox "You are unable to check out this document at this time. Please try again later."
    End If


End Sub

Function isValidVal(inVal As String, modName As String) As Boolean
    Dim tmpArr As Variant
    
    If inVal <> "" Then
    
        If InStr(1, inVal, ".") <> 0 Then
            tmpArr = Split(inVal, ".")
            If IsNumeric(tmpArr(1)) And (LCase(Trim(tmpArr(0))) = LCase(Trim(modName)) Or InStr(1, LCase(Trim(modName)), LCase(Trim(tmpArr(0)))) <> 0) Then
                isValidVal = True
                'checks if module name includes value before the dot
                If InStr(1, LCase(Trim(modName)), LCase(Trim(tmpArr(0)))) <> 0 Then
                    'reassign modName variable with new string because exist situations when module name in 3 column is compaund value
                    modName = Trim(tmpArr(0))
                End If
            End If
        Else
            isValidVal = IsNumeric(inVal)
        End If
    
    End If

End Function

