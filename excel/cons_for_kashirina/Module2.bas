Attribute VB_Name = "Module2"
Dim destWBook As Workbook, srcWBook As Workbook
Dim srcColumn As Integer, compName As String
Sub runCons()

    UserForm1.Show

End Sub


Sub myLoader(srcWBookInput As Workbook, destWBookInput As Workbook)

    
    Dim destSht As Worksheet, srcSht As Worksheet
    Dim monName As String, compCellAddr As String
    Dim curPageNum As Integer, tableFirstRow As Integer, tableEndCol As Integer, colForMonthSearch As Integer
    Dim tmpCell As Range, tmpCol As Integer, monthCol As New Collection, tmpRow As Integer, wRange As Range
    Dim prevMonthCell As Range, valForFind As String
    
    UserForm1.Hide
    compCellAddr = "E4" 'cell where company name is stored through all workbooks
    For i = 1 To 12
        monthCol.Add (monthName(i))
    Next i
    'set workbooks
    Set destWBook = destWBookInput '@todo change this appropriately
    '@todo move this fork to upper level to allow mulptiple file choosing
    Set srcWBook = srcWBookInput
    
    'company name for searching through the sheets of pivot report
    On Error Resume Next
    compName = srcWBook.Worksheets("���").Range(compCellAddr).value
    If Err.Number <> 0 Then
        MsgBox "��������� ������ ���������. �������� ���� " _
        & srcWBook.Name & " �� �������� ��� ������������", vbExclamation, "������"
        Exit Sub
    End If
    On Error GoTo 0
    curPageNum = 1
    Do While (compName <> destWBook.Sheets(curPageNum).Range(compCellAddr).value) And (curPageNum < destWBook.Sheets.Count)
        curPageNum = curPageNum + 1
    Loop
    
    'fork that halt sub if company name wasn't found
    If destWBook.Sheets(curPageNum).Range(compCellAddr).value = compName Then
        Set destSht = destWBook.Sheets(curPageNum)
        Set srcSht = srcWBook.Sheets("���")
        tableFirstRow = 10
        tmpCol = 1
        srcSht.Activate
        Set tmpCell = Cells(tableFirstRow, tmpCol)
        tmpCell.Select 'test line
        'find "������� �������" cell
        Do While Trim(tmpCell.value) <> "������� �������"
            tmpCol = tmpCol + 1
            Set tmpCell = Cells(tableFirstRow, tmpCol)
            tmpCell.Select ' test line
            
            If Trim(tmpCell.value) = "������� �������" Then
                colForMonthSearch = tmpCell.Column
                Exit Do
            End If
        Loop
        tmpRow = tableFirstRow + 2 'add 2 because beetween current quater cell and month exists little row
        Set tmpCell = Cells(tmpRow, colForMonthSearch)
        lookForFirtsMonth = True
        'loop while value from cell is a month
        Do While isExistInCol(tmpCell.value, monthCol)
            '@todo go to fork current plan or operative
            srcSht.Activate
            monName = tmpCell.value
            Set prevMonthCell = tmpCell
            Set wRange = srcSht.UsedRange
            'here we check for what radiobutton is chosen
            If UserForm1.opOBtn.value Then
                valForFind = "��"
                Set tmpCell = findApprCol(tmpCell, valForFind)
                copyCol monName, tmpCell.Column, destSht, srcSht, wRange
            ElseIf UserForm1.tpOBtn.value Then
                valForFind = "��"
                Set tmpCell = findApprCol(tmpCell, valForFind)
                copyCol monName, tmpCell.Column, destSht, srcSht, wRange
            ElseIf UserForm1.bpOptBtn.value Then
                valForFind = "��"
                Set tmpCell = findApprCol(tmpCell, valForFind)
                copyCol monName, tmpCell.Column, destSht, srcSht, wRange
            End If
            srcSht.Activate
            Call createChessStat(monName)  'need to test, move to chess table creation
            Set srcSht = srcWBook.Sheets("���")
            srcSht.Activate
            Set tmpCell = findNextMonth(prevMonthCell)
        Loop
        
        Application.StatusBar = False
        If UserForm1.CheckBox1.value = True Then
            destSht.Activate
        End If

    Else
        MsgBox ("�������� � ����������� ������������ �� �������!")
    End If

End Sub
Private Function findApprCol(tmpCell As Range, valForFind As String) As Range
    'choose appropriate column for insertion
    Dim tmpCol As Integer, tmpRow As Integer
    
    tmpRow = tmpCell.Row
    tmpCol = tmpCell.Column
    'move to line with names of plans
    tmpRow = tmpRow + 1
    Set tmpCell = Cells(tmpRow, tmpCol)
    Do While Trim(tmpCell.value) <> valForFind
        tmpCol = tmpCol + 1
        Set tmpCell = Cells(tmpRow, tmpCol)
        tmpCell.Select 'test line
        If tmpCell.value = valForFind Then
            Exit Do
        End If
    Loop
    
    Set findApprCol = tmpCell

End Function

Private Function findNextMonth(prevMonthCell As Range) As Range
    
    'go to cell where previous month was found and loop through columns until cellValue doesn't change
    ', return first cell with new value
    Dim tmpCol As Integer, tmpRow As Integer
    Dim tmpCell As Range
    
    Set tmpCell = prevMonthCell
    tmpCol = tmpCell.Column
    tmpRow = tmpCell.Row
    Do While tmpCell.value = prevMonthCell.value Or tmpCell.value = ""
        tmpCol = tmpCol + 1
        Set tmpCell = Cells(tmpRow, tmpCol)
        tmpCell.Select 'test line
    Loop
    Set findNextMonth = tmpCell
End Function

Private Function isExistInCol(itemVal As String, colForSearch As Collection) As Boolean
    'loop through given collection and if meet given value return true
    Dim resBool As Boolean
    resBool = False
    For Each Item In colForSearch
        If itemVal = Item Then
            resBool = True
            Exit For
        End If
    Next Item
    isExistInCol = resBool
End Function

Private Sub copyCol(monName As String, colVal As Integer, destSht As Worksheet, srcSht As Worksheet, wRange As Range)
    'copy column from specified cell value
    Dim destCol As Integer
    Dim tmpRow As Integer, tmpCol As Integer, tmpCell As Range
    
    If UserForm1.uOptBtn.value Then
        colVal = colVal + 2
    End If
    
    tmpRow = 10
    tmpCol = 1
    srcColumn = colVal 'this line is used between two procedures need to test it
    destSht.Activate
    Set tmpCell = Cells(tmpRow, tmpCol)
    tmpCell.Select
    Do While tmpCell.value <> monName
        tmpCol = tmpCol + 1
        Set tmpCell = Cells(tmpRow, tmpCol)
        tmpCell.Select 'test line
        If tmpCell.value = monName Then
            destCol = tmpCell.Column
        End If
    Loop
    
    
    tmpRow = 15
    
    Cells(tmpRow, destCol).Select
    Do While tmpRow <= wRange.Rows.CountLarge
        tmpRow = tmpRow + 1
        If (destSht.Cells(tmpRow, destCol).HasFormula = False) Then
            destSht.Cells(tmpRow, destCol).value = srcSht.Cells(tmpRow, colVal).value
            Cells(tmpRow, destCol).Select 'test line
        End If
    Loop

End Sub

Sub createChessStat(monName As String)
'procedure creates chess statement
    Dim pivotShtCol As New Collection, revenueCol As New Collection, costCol As New Collection
    Dim tmpCell As Range, tmpRow As Integer, tmpColumn As Integer, tmpArr As Variant, tmpCol As New Collection 'helper variables
    Dim srcSht As Worksheet, destSht As Worksheet
    Dim startCellForIns As Range, rowForIns As Integer, colForIns As Integer
    Dim revenueCell As Range, costCell As Range, checkCell As Range 'cells with titles of tables within destination sheet
    Dim compColumn As Integer, codeColumn As Integer ', srcColumn As Integer
    Dim valRow As Integer 'first row with values
    
    If UserForm1.groutOptBtn.value Then
        Set srcSht = srcWBook.Sheets("�����2_�")
    Else
        Set srcSht = srcWBook.Sheets("�����2_�")
    End If
    srcSht.Activate
    
    'persistent values, cannot be changed
    compColumn = 5
    codeColumn = 6
    valRow = 15
    
    Set tmpCell = Cells(valRow, compColumn)
    tmpCell.Select ' test line
    tmpRow = valRow
    
    
    Do While tmpRow < srcSht.UsedRange.Rows.CountLarge
        'loop through the whole used range of source sheet
        If tmpCell.value = Empty And tmpCell.Offset(0, 1).value = Empty Then
            'change valRow variable to next table value
            valRow = tmpCell.Row + 1
            'tmpRow = valRow
        End If
        Do While tmpCell.value <> Empty
            'loop through table and add values from specified column to intended collection
            tmpColumn = codeColumn
            Set tmpCell = Cells(tmpRow, tmpColumn)
            tmpCell.Select 'test line
            tmpArr = Split(tmpCell.value, "-")
            Set tmpCell = Cells(tmpRow, srcColumn)
            'decide to which collection pass values
            If tmpArr(1) = "035" Or tmpArr(1) = "060" Or tmpArr(1) = "130" Or tmpArr(1) = "120" Then
                'check is the first added values if
                Set revenueCol = addToCollection(tmpCell, valRow, revenueCol)
            Else
                Set costCol = addToCollection(tmpCell, valRow, costCol)
            End If
            
            tmpRow = tmpRow + 1
            Set tmpCell = Cells(tmpRow, compColumn)
        Loop
        
        tmpRow = tmpRow + 1
        Set tmpCell = Cells(tmpRow, compColumn)
        'If tmpRow = 864 Then
        '    Debug.Print "some text"
        'End If
    Loop
    
    'initialize appropriate destination sheet
    Select Case LCase(monName)
        
    Case "������", "�������", "����"
        Set destSht = destWBook.Worksheets("� 1 ��.")
    Case "������", "���", "����"
        Set destSht = destWBook.Worksheets("� 2 ��.")
    Case "����", "������", "��������"
        Set destSht = destWBook.Worksheets("� 3 ��.")
    Case "�������", "������", "�������"
        Set destSht = destWBook.Worksheets("� 4 ��.")
    Case Else
        MsgBox ("�� ���������� �������� ������!")
        Exit Sub
    End Select
    'finds appropriate cells to start looping
    Set revenueCell = destSht.Range("C:C").Find("������ ""+"" (�� �����������)", LookIn:=xlValues, LookAt:=xlWhole)
    Set costCell = destSht.Range("C:C").Find("������� ""-"" (�� ���������)", LookIn:=xlValues, LookAt:=xlWhole)
    Set checkCell = destSht.Range("C:C").Find("��������", LookIn:=xlValues, LookAt:=xlWhole)
    
    destSht.Activate
    tmpColumn = 0
    tmpRow = 0
    i = 0
    
    'find row within revenue's table where to insert data from collection
    Do While tmpRow < costCell.Row
        i = i + 1
        Set tmpCell = revenueCell.Offset(i)
        If tmpCell.value = compName Then
            rowForIns = tmpCell.Row
            Exit Do
        End If
        tmpRow = revenueCell.Row + i
        tmpCell.Select 'test line
    Loop
    i = 0
    'find column like previous loop
    Do While tmpColumn < destSht.UsedRange.Rows.CountLarge
        i = i + 1
        Set tmpCell = revenueCell.Offset(0, i)
        If tmpCell.value = monName Then
            colForIns = tmpCell.Column
            Exit Do
        End If
        tmpColumn = revenueCell.Column + i
        tmpCell.Select
    Loop
    
    Set tmpCell = destSht.Cells(rowForIns, colForIns)
    
    tmpCell.Select 'test line
    
    Set startCellForIns = tmpCell
    i = 0
    For Each valFromCol In revenueCol
        startCellForIns.Offset(0, i).value = valFromCol
        i = i + 1
    Next valFromCol
    tmpColumn = 0
    tmpRow = 0
    i = 0
    'find column within cost's table where to insert data from collection
    Do While tmpColumn < destSht.UsedRange.Rows.CountLarge
        i = i + 1
        Set tmpCell = costCell.Offset(1, colForIns - costCell.Column + i - 1) 'use already found month column value from previous loops
        If tmpCell.value = compName Then
            colForIns = tmpCell.Column
            Exit Do
        End If
        tmpColumn = tmpCell.Column
        tmpCell.Select 'test line
    Loop
    
    Set tmpCell = destSht.Cells(costCell.Row + 2, colForIns)
    
    tmpCell.Select 'test line
    
    Set startCellForIns = tmpCell
    
    i = 0
    For Each valFromCol In costCol
        startCellForIns.Offset(i).value = valFromCol
        i = i + 1
    Next valFromCol

    
        
End Sub
Private Function addToCollection(tmpCell As Range, valRow As Integer, destCollection As Collection) As Collection
    'create collection from given cell value
        
    Dim tmpVal As Variant, i As Integer
        
    i = tmpCell.Row - valRow + 1 'stores item number
    On Error Resume Next
    tmpVal = WorksheetFunction.Sum(destCollection(i), tmpCell.value)
    If Error <> "" Then
        destCollection.Add tmpCell.value
    Else
        destCollection.Add Item:=tmpVal, Before:=i
        destCollection.Remove (i + 1)
    End If
    On Error GoTo 0

    Set addToCollection = destCollection
End Function
