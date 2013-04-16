Attribute VB_Name = "bbUgol_copyPaste"
Dim relToRange  As Range
Dim addrColl As Collection
Dim srcWB As Workbook, destWB As Workbook


Sub copyProc(shtName As String, relToRngAddr As String, constValColl As Collection)

    'constValColl should contain at least source and destination workbook name
    'prefix that is being added to shtName for ctrlShtName creation
    'upLeftCell for ctrlSht that contains first address for copy
    Dim ctrlSht As Worksheet
    Dim ctrlRng As Range
    Dim addrForCopy As String
    
    Set srcWB = Workbooks(constValColl("srcWBName"))
    Set destWB = Workbooks(constValColl("destWBName"))
    
    'Set srcWSht = srcWB.Sheets(shtName)
    Set ctrlSht = destWB.Sheets(constValColl("sht_control_table_prefix") & shtName)
    'Set destWSht = destWB.Sheets(shtName)
    
    Set ctrlRng = ctrlSht.Range(constValColl("upLeftCell_for_ctrl_sht")) 'upLeftCell for mine range
    Set relToRange = ctrlSht.Range(relToRngAddr)
    
    'important
    ctrlSht.Visible = xlSheetVisible
    ctrlSht.Activate
    
    Call moveThroughRows(ctrlRng)
    
    ctrlSht.Visible = xlSheetVeryHidden
    
    'Copy one range to another
    For Each addr In addrColl
        Call copyRange(shtName, addr)
    Next addr
    
End Sub

Sub unhide_everything(disableAppOperations As Boolean)
    If disableAppOperations Then
        Application.EnableEvents = False
        Application.ScreenUpdating = False
    End If
    ctrlSht.Visible = xlSheetVeryHidden

End Sub

Sub hide_everything()
    ctrlSht.Visible = xlSheetVeryHidden
End Sub

'Open files for copy


'Compute range address for copying
Sub moveThroughRows(inRange As Range)
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

Private Sub copyRange(shtName As String, addrForCopy As Variant)

    destWB.Sheets(shtName).Range(addrForCopy).Value2 = srcWB.Sheets(shtName).Range(addrForCopy).Value2

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


