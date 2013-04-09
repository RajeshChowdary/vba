Attribute VB_Name = "bbUgol_copyPaste"
Dim srcWB As Workbook, destWB As Workbook
Dim srcWSht As Worksheet, destWSht As Worksheet ', ctrlSht As Worksheet
Dim relToRange  As Range
Dim addrColl As Collection

Sub startPoint()

    '
    Dim ctrlSht As Worksheet
    Dim ctrlRng As Range
    Dim addrForCopy As String, relToAddr As String
    
    Set srcWB = Workbooks("model_in.xlsm")
    Set destWB = Workbooks("model_out.xlsm")
    
    Set srcWSht = srcWB.Sheets("����_�")
    Set ctrlSht = destWB.Sheets("control_table_����_�")
    Set destWSht = destWB.Sheets("����_�")
    
    Set ctrlRng = ctrlSht.Range("E3") 'upLeftCell for mine range
    Set relToRange = ctrlSht.Range(ctrlSht.Range("B3").value)
    
    'important
    ctrlSht.Visible = xlSheetVisible
    ctrlSht.Activate
    
    Call moveThroughRows(ctrlRng)
    
    ctrlSht.Visible = xlSheetVeryHidden
    
    'Copy one range to another
    For Each addr In addrColl
        Call copyRange(addr)
    Next addr
    
End Sub

'Open files for copy

'Find needed mine or it's range


'Compute range address for copying
Private Sub moveThroughRows(inRange As Range)
    'Procedure moves through all most left non-empty cells in rows
    Dim nextRowRange As Range
    Dim clw As New CellWorker
     
    
    Call processRowOfRanges(inRange)
    
    Set nextRowRange = clw.move_down(inRange, 2)
    
    If nextRowRange.value <> "" Then
        Call moveThroughRows(nextRowRange)
    End If

End Sub

Private Sub processRowOfRanges(inRange As Range)

    Dim addrForProc As String
    Dim clw As New CellWorker
    Dim nextRange As Range
    
    'range address converted to A1 notation
    addrForProc = convertToA1(inRange.value)
    
    If addrColl Is Nothing Then
        Set addrColl = New Collection
    End If
    
    addrColl.Add (addrForProc)
    
    'moves to next range
    Set nextRange = clw.move_right(inRange, 2)
        
    If nextRange.value <> "" Then
        Call processRowOfRanges(nextRange)  ' - recursive call
    End If
End Sub

Private Sub copyRange(addrForCopy As String)

    destWSht.Range(addrForCopy).Value2 = srcWSht.Range(addrForCopy).Value2

End Sub


Private Function convertToA1(inRange As String) As String
    '
    '(str)->str
    
    'Returns converted inRange address to xlA1 style
    
    'relToRange="E149"
    '>>>convertToA1(R[6]C[2]:R[7]C[3])
    '"G155:H156"
    convertToA1 = Application.ConvertFormula(inRange, xlR1C1, xlA1, , relToRange)
    
End Function



'check computed addresses
Private Sub processMineRange(upLeftCell As Range)

    'Returns collection of addresses that should be copied
    Dim selRange As Range
    Dim i As Integer
    Dim rangeAddr As String
 
    
    
    Call moveThroughRows(upLeftCell)
    
    Debug.Assert addrColl.Count > 1
    
    Call activateApprSht(ActiveSheet.Name)
    
    For Each addr In addrColl
        If selRange Is Nothing Then
            Set selRange = Range(addr)
        Else
            Set selRange = Application.Union(selRange, Range(addr))
        End If
    Next addr
    
    
    selRange.Select
    
End Sub

Private Sub activateApprSht(curShtName As String)

    'activates sheet appropriate to active control sheet
    
    Dim tmpStr As String
    
    tmpStr = Right(curShtName, Len(curShtName) - Len("control_table_"))
    
    ActiveWorkbook.Sheets(tmpStr).Activate
    

End Sub


''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''
''''''''''''Helpers'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''


'Function returnRangeAddr(tmpRange As Range) As String
'
'    returnRangeAddr = tmpRange.Address(False, False)
'
'End Function
''
'Function convertToR1C1(tmpRange As Range, relativeTo As Range) As String
'
'    Dim tmpString As String
'    '>>>convertToR1C1(Range("G17:H18"),Range("E9"))
'    'R[8]C[2]:R[9]C[3]
'    'Debug.Print ""
'    tmpString = tmpRange.Address(RowAbsolute:=False, ColumnAbsolute:=False, ReferenceStyle:=xlR1C1, relativeTo:=relativeTo)
'    convertToR1C1 = tmpString
'End Function

Sub checkMineRange()

    Set relToRange = Range("E149")
    
    Call processMineRange(Range("E3"))

End Sub
