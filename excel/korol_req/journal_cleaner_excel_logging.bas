Attribute VB_Name = "journal_cleaner_excel_logging"
    Dim devJour As Workbook, chanJour As Workbook
    Dim devWSht As Worksheet, chanWSht As Worksheet
    Dim resWBook As Workbook
    Dim tmpWSht As Worksheet


Sub journalCleaning()
    
    Dim tmpRow As Integer, tmpCol As Integer, tmpCell As Range, tmpStr As String, foundCell As Range 'helper variables
    Dim clw As New CellWorker, flw As New FileWorker
    Dim devCode As String, chanCode As String, modName As String, developerName As String
    Dim devJournName As String, chanJournName As String, shPPath As String
    Dim devCodeCol As Integer, chanCodeCol As Integer
    Dim chkModNameToo As Boolean
    Dim tmpArray As Variant
    Dim xmlName As String, desktopPath As String, rootTagName As String
    Dim cachedCell As Range
    Dim cachedSht As Worksheet
    Dim prevVal As String
    Dim firstFoundCell As String
    Dim stopCheck As Boolean
    
    Application.EnableEvents = False
    
    desktopPath = Environ("USERPROFILE")
    
    desktopPath = desktopPath & "\Desktop\"
    
    
    shPPath = "https://workspaces.dtek.com/it/oisup/ProjectSAP/ChangeManagement/"
    devJournName = "test_dev.xlsm"
    chanJournName = "test.xlsm"
    
    'check if change journal can be checked out
    If Workbooks.CanCheckOut(shPPath & chanJournName) = False Then
        MsgBox "You are unable to check out this document at this time. Please try again later."
    End If
    
    'need to test
    If Workbooks.CanCheckOut(shPPath & devJournName) = True Then
        Workbooks.CheckOut shPPath & devJournName
    End If
    'logging
    Set resWBook = Workbooks.Add
    resWBook.SaveAs desktopPath & "���������_���������_��������.xlsx", 51
    
    
    Workbooks.CheckOut shPPath & chanJournName
    
    
    
    Set chanJour = Workbooks.Open(shPPath & chanJournName, , False)
    Set devJour = Workbooks(shPPath & devJournName)
    Set devWSht = devJour.Sheets(1)
    Set chanWSht = chanJour.Sheets("������ �������� �� �������")
    chanCodeCol = 2
    devCodeCol = 4
    devNameCol = 41
    
    
    Call replRusByEng
    
'$$$
    
    'dev codes cleaning
    
    'logging
    Set tmpWSht = resWBook.Sheets(2)
    tmpWSht.Name = "������ ������� ����������"
    tmpWSht.Activate
    Set tmpCell = ActiveCell
    tmpCell.value = "���"
    clw.move_right(tmpCell).value = "������������ ������/���������"
    clw.move_right(tmpCell, 2).value = "��� ����������"
    clw.move_right(tmpCell, 3).value = "��� ���������"
    clw.move_right(tmpCell, 4).value = "����� ������ ���� ���������/����������"
    clw.move_right(tmpCell, 5).value = "���������� �������� ���� ���������� � ������� ���������"
    clw.move_down(tmpCell).Activate
    
    
    devWSht.Activate
    tmpRow = 3
    chkModNameToo = False
    
    'work
    Set tmpCell = Cells(tmpRow, devCodeCol)
    tmpCell.Select
    Do While devWSht.UsedRange.Rows.CountLarge + 5 > tmpCell.Row
    
        chanCode = Cells(tmpCell.Row, chanCodeCol).value
        modName = Cells(tmpCell.Row, chanCodeCol + 1).value
        devCode = tmpCell.value
        
        If devCode = "" And modName <> "" Then
            'error in dev journal dev code is omitted
            'logging
            Set cachedSht = ActiveSheet
            
            tmpWSht.Activate
            Set cachedCell = ActiveCell
            cachedCell.value = "������"
            clw.move_right(cachedCell).value = "�������� ��� ���������� � ������� ����������"
            clw.move_right(cachedCell, 4).value = tmpCell.Address(False, False)
            clw.move_down(cachedCell).Activate
            
            cachedSht.Activate
            'work
            Set tmpCell = clw.move_down(tmpCell)
        Else
            
            If chanCode <> "" Then
                chanCode = Trim(chanCode)
                
                'change code cleaning
                If InStr(1, chanCode, modName) <> 0 Then
                    'if change code contains name of module try to find the dot
                    If InStr(1, chanCode, ".") <> 0 Then
                        tmpArray = Split(chanCode, ".")
                        chanCode = tmpArray(1)
                    Else
                        '"Change code contains wrong code"
                        Set cachedSht = ActiveSheet
                        tmpWSht.Activate
                        Set cachedCell = ActiveCell
                        cachedCell.value = "������"
                        clw.move_right(cachedCell).value = "���-�� �� ��� � ������� ��������� � ������� ���������� �� ������ "
                        clw.move_right(cachedCell, 4).value = Cells(tmpCell.Row, chanCodeCol).Address(False, False)
                        clw.move_down(cachedCell).Activate
                        
                        cachedSht.Activate
                        stopCheck = True
                    End If
                End If
                If Not stopCheck Then
                    chanWSht.Activate
                    Columns("B:B").Select
                    Set foundCell = Selection.Find(What:=chanCode, After:=ActiveCell, LookIn:=xlFormulas, _
                    LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
                    MatchCase:=False, SearchFormat:=False)
                    
                    
                    If Not foundCell Is Nothing Then
                        firstFoundCell = foundCell.Address
                        
                        Do While LCase(Trim(modName)) <> LCase(Trim(Cells(foundCell.Row, (devCodeCol - 1)).value))
                            
                            Set foundCell = Selection.FindNext
                            If firstFoundCell = foundCell.Address Then
                                Set foundCell = Nothing
                                firstFoundCell = ""
                                Exit Do
                            End If
                        
                        Loop
                    End If
                    
                    
                    'maybe add here do while foundcell is nothing
                    If foundCell Is Nothing Then
                    
                            Set cachedSht = ActiveSheet
                
                            tmpWSht.Activate
                            Set cachedCell = ActiveCell
                            cachedCell.value = "������"
                            clw.move_right(cachedCell).value = "������ ������ ��������� (��� ���������� ������ � ������) ��� � ������� ���������, �� ���� � ������� ����������"
                            clw.move_right(cachedCell, 2).value = devCode
                            clw.move_right(cachedCell, 3).value = chanCode
                            clw.move_right(cachedCell, 4).value = tmpCell.Address(False, False)
                            clw.move_down(cachedCell).Activate
                            
                            cachedSht.Activate
                    
                    Else
                        foundCell.Select
                    
                        If Cells(foundCell.Row, devCodeCol).value = "" Then
                            'logging
                        
                            Set cachedSht = ActiveSheet
                        
                            tmpWSht.Activate
                            Set cachedCell = ActiveCell
                            cachedCell.value = "���������"
                            clw.move_right(cachedCell).value = "��� �������� ����� ���������� � ������ ���������"
                            clw.move_right(cachedCell, 2).value = devCode
                            clw.move_right(cachedCell, 4).value = Cells(foundCell.Row, devCodeCol).Address(False, False)
                            clw.move_down(cachedCell).Activate
                            cachedSht.Activate
                            
                            Cells(foundCell.Row, devCodeCol).value = devCode
                            
                        Else
                            
                                                                                    'logging
                                prevVal = Cells(foundCell.Row, devCodeCol).value
                                'if previous and new values of dev codes match do nothing
                                If prevVal <> devCode Then
                                    Set cachedSht = ActiveSheet
                                    
                                    tmpWSht.Activate
                                    Set cachedCell = ActiveCell
                                    cachedCell.value = "���������"
                                    clw.move_right(cachedCell).value = "����� ���������� � ������� ��������� ��� ������� ��"
                                    clw.move_right(cachedCell, 2).value = devCode
                                    clw.move_right(cachedCell, 4).value = Cells(foundCell.Row, devCodeCol).Address(False, False)
                                    clw.move_right(cachedCell, 5).value = prevVal
                                    clw.move_down(cachedCell).Activate
                                    cachedSht.Activate
                                    'cache
                                    
                                    Cells(foundCell.Row, devCodeCol).value = devCode
                                End If
                                prevVal = ""
                        
                        End If 'If Cells(foundCell.Row, devCodeCol).value = "" Then
                        
                    End If 'If foundCell Is Nothing Then
                
                End If 'if not stopCheck then
                
            End If
            
        End If
                
        stopCheck = False
        Set foundCell = Nothing
        devWSht.Activate
        Set tmpCell = clw.move_down(tmpCell)

    Loop
    
    
'$$$
    
    
    
    'change codes cleaning
    'logging
    Set tmpWSht = resWBook.Sheets(3)
    tmpWSht.Name = "������ ������� ���������"
    tmpWSht.Activate
    Set tmpCell = ActiveCell
    tmpCell.value = "���"
    clw.move_right(tmpCell).value = "������������ ������/���������"
    clw.move_right(tmpCell, 3).value = "��� ����������"
    clw.move_right(tmpCell, 2).value = "��� ���������"
    clw.move_right(tmpCell, 4).value = "����� ������ ���� ���������/���������� � ������� ����������"
    clw.move_right(tmpCell, 5).value = "���������� �������� ���� ��������� � ������� ����������"
    clw.move_down(tmpCell).Activate
    
    'work
    chanWSht.Activate
    tmpRow = 4
    
    Set tmpCell = Cells(tmpRow, chanCodeCol)
    tmpCell.Select
    Do While chanWSht.UsedRange.Rows.CountLarge + 5 > tmpCell.Row
    
        chanCode = tmpCell.value
        devCode = Cells(tmpCell.Row, devCodeCol)
        modName = Cells(tmpCell.Row, chanCodeCol + 1).value
        developerName = Cells(tmpCell.Row, devNameCol).value

        
            If devCode <> "" Then
                devCode = Trim(devCode)
                
                devWSht.Activate
                Columns("D:D").Select
                Set foundCell = Selection.Find(What:=devCode, After:=ActiveCell, LookIn:=xlFormulas, _
                LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
                MatchCase:=False, SearchFormat:=False)
                
                If foundCell Is Nothing Then
                
                    'logging
                    tmpWSht.Activate
                    
                    Set cachedCell = ActiveCell
                    cachedCell.value = "������"
                    clw.move_right(cachedCell).value = "��� ���������� ����������� � ������� ����������, �� ���� � ������� ���������"
                    clw.move_right(cachedCell, 3).value = devCode
                    clw.move_right(cachedCell, 2).value = chanCode
                    clw.move_right(cachedCell, 4).value = Cells(tmpCell.Row, devCodeCol).Address(False, False)
                    clw.move_down(cachedCell).Activate
                Else
                
                    prevVal = Cells(foundCell.Row, chanCodeCol).value
                    'if previous and new values of dev codes match do nothing
                    If prevVal <> chanCode Then
                        Set cachedSht = ActiveSheet
                        
                        tmpWSht.Activate
                        Set cachedCell = ActiveCell
                        cachedCell.value = "���������"
                        clw.move_right(cachedCell).value = "����� ��������� � ������� ���������� ��� ������� ��"
                        clw.move_right(cachedCell, 3).value = devCode
                        clw.move_right(cachedCell, 2).value = chanCode
                        'cachedCell.Select
                        clw.move_right(cachedCell, 4).value = Cells(foundCell.Row, devCodeCol).Address(False, False)
                        clw.move_right(cachedCell, 5).value = prevVal
                        clw.move_down(cachedCell).Activate
                        cachedSht.Activate
                        'cache
                        
                        Cells(foundCell.Row, chanCodeCol).value = chanCode
                    End If
                    prevVal = ""
                    
                End If
                
                Set foundCell = Nothing
            Else
                    
                If developerName <> "" Then
                        'logging
                        'cache
                        Set cachedSht = ActiveSheet
            
                        tmpWSht.Activate
                        Set cachedCell = ActiveCell
                        cachedCell.value = "������"
                        clw.move_right(cachedCell).value = "����������� ����� ���������� � ������� ���������"
                        clw.move_right(cachedCell, 2).value = chanCode
                        clw.move_right(cachedCell, 4).value = tmpCell.Address(False, False)
                        clw.move_down(cachedCell).Activate
                        
                        cachedSht.Activate
                        
                End If
            End If
                
            chanWSht.Activate
            Set tmpCell = clw.move_down(tmpCell)
    Loop
    
    Application.EnableEvents = True
    
End Sub

Private Sub replRusByEng()

    'replace russian letters by english
     Dim tmpRow As Integer, tmpCol As Integer, tmpCell As Range, tmpStr As String, foundCell As Range 'helper variables
    Dim rangeForClean As Range
    Dim clw As New CellWorker, flw As New FileWorker

    
    'logging
    Set tmpWSht = resWBook.Sheets(1)
    tmpWSht.Name = "������_�������_����"
    tmpWSht.Activate
    Range("A1").value = "������ �������������� � ������� ���������"
    Set tmpCell = Range("A2")
    tmpCell.value = "������� ����� ���� ��������"
    Set tmpCell = clw.move_right(tmpCell)
    tmpCell.value = "� ������"
    Cells(tmpCell.Row + 1, tmpCell.Column - 1).Activate
    
    'work
    chanWSht.Activate
    Set rangeForClean = Range("B4", Cells(chanWSht.UsedRange.Rows.CountLarge, 4))
    rangeForClean.Select
    Call txtCleaning(rangeForClean)
    
    'logging
    tmpWSht.Activate
    Set tmpCell = ActiveCell
    tmpCell.value = "������ �������������� � ������� ����������"
    Set tmpCell = clw.move_down(tmpCell)
    tmpCell.value = "������� ����� ���� ��������"
    Set tmpCell = clw.move_right(tmpCell)
    tmpCell.value = "� ������"
    Cells(tmpCell.Row + 1, tmpCell.Column - 1).Activate
    
    'work
    devWSht.Activate
    Set rangeForClean = Range("B3", Cells(devWSht.UsedRange.Rows.CountLarge, 4))
    rangeForClean.Select
    Call txtCleaning(rangeForClean)
    
End Sub

Private Sub txtCleaning(rangeForClean As Range)
    'find and replace Russian letters by English in a given range
    Dim i As Integer, rusLetters As Variant, engLetters As Variant
    Dim foundCell As Range
    Dim foundCellAddr As Variant
    Dim tmpCell As Range
    Dim cachedSht As Worksheet
    Dim clw As New CellWorker

    
    rusLetters = Array("�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�")
    engLetters = Array("A", "B", "C", "E", "H", "K", "M", "O", "P", "T", "X", "Y")
    'i = 0
    rangeForClean.Select
    For i = 0 To UBound(rusLetters)
        Set foundCell = Selection.Find(What:=rusLetters(i), After:=ActiveCell, LookIn:=xlFormulas, LookAt _
            :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
            False, SearchFormat:=False)
        Do While Not foundCell Is Nothing
            'logging
            foundCellAddr = foundCell.Address(False, False)
            Set cachedSht = ActiveSheet
            tmpWSht.Activate
            Set tmpCell = ActiveCell
            tmpCell.value = engLetters(i)
            clw.move_right(tmpCell).value = foundCellAddr
            clw.move_down(tmpCell).Activate
            cachedSht.Activate
            Set cachedSht = Nothing
            Set tmpCell = Nothing
            
            'work
            foundCell.Replace What:=rusLetters(i), Replacement:=engLetters(i), LookAt:=xlPart, _
            SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
            ReplaceFormat:=False
            
            foundCell.Activate
            Set foundCell = Nothing
            Set foundCell = Selection.FindNext(After:=ActiveCell)
        Loop
    Next i

End Sub

