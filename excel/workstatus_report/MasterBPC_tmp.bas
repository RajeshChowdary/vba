Attribute VB_Name = "MasterBPC_tmp"
''*************************
'' ����� �������� ��� ���
''*************************
'' �����: ��������� ������
'' �����: ������� �������
'' �����: �������� ��������
''*************************
'' ������� ��������� ��������� 14.08.2012
'' ����:  11.07.2012
''*************************
'
'Public sh           As Worksheet
'Public ActCell      As Range
'Public EVDRE()      As Variant
'Public Event_Name   As String
'Dim InProcess       As Boolean
'Dim IsRegistered    As Boolean
'Dim myConnection    As Object
'Dim sap, fm, tabl
'Const UsingLocks    As Boolean = False
'
'    'Application.Run "MNU_eTOOLS_REFRESH" '������ ����� �����������
'    'Application.Run "MNU_eSUBMIT_REFRESH" '�������� ������ � �������� � ����������
'
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_SHEET_REFRESH" '�������� ������ ��� ������� � ����������
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_SHEET_NOACTION" '�������� ������ ��� �������� � ��� ����������
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_SHEET_CLEARANDREFRESH" '�������� ������ ��� ������� � ����������
'
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_BOOK_REFRESH"
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_BOOK_NOACTION"
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_BOOK_CLEARANDREFRESH"
'    'Application.Run "MNU_eSUBMIT_REFSCHEDULE_BOOK_NOACTION_SHOWRESULT"
'
''************************************************************************************
''************************************************************************************
''************************************************************************************
'
'Dim cvNotMatch As Boolean
'
'Public Sub onWorkBookActivate()
'    'This sub will be called on workbook activate
'    Dim tmpStr As String
'
'    'check for connection
'    On Error Resume Next
'    tmpStr = Evaluate("EVAST()")
'    If Err.Number <> 0 Then
'        Exit Sub
'    End If
'    On Error GoTo 0
'    'additional check
'    If tmpStr = "DTEK" Then
'        Call generateCaution
'    End If
'
'End Sub
'
''checks if cvw is changed
'Private Sub generateCaution()
'
'    Dim tmpCell As Range, tmpRow As Integer, CVWCells As Collection
'    Dim wBook As Workbook, wSheet As Worksheet, wRange As Range
'    Dim cellFormula As String
'    Dim formResult As String
'
'
'
'    cvNotMatch = False
'    Set wBook = ActiveWorkbook
'    Set wSheet = ActiveSheet
'    Set wRange = wSheet.UsedRange
'    'unprotect sheet before do smth. Sub doesn't work without this.
'    'wSheet.Unprotect Pass(wSheet)
'    Set CVWCells = findCVWCells(wRange)
'    'exit if cells not found
'    If CVWCells Is Nothing Then
'        Exit Sub
'    End If
'    'Compares each cell value with actual value of cv
'    For Each tmpCell In CVWCells
'        cellFormula = tmpCell.Formula
'        cellFormula = Right(tmpCell.Formula, Len(tmpCell.Formula) - 1)
'
'        'On Error Resume Next
'        formResult = Evaluate(cellFormula)
'
'        If tmpCell.Value <> formResult Then
'            'generates caution if cv showed in workbook mismatch with actual cv
'            cvNotMatch = True
'            Call showCaution
'            Exit Sub
'        End If
'    Next
'    'protects workbook back
'    'wSheet.Protect Pass(wSheet)
'
'End Sub
'
''finds all cells that contain evcvw function
'Private Function findCVWCells(wRange As Range) As Collection
'
'    Dim tmpCell As Range, tmpRow As Integer, tmpColl As New Collection
'    Dim firstFoundCell As Range
'
'    'look for cell with EvCvw formula in it
'    Set firstFoundCell = wRange.Find(What:="*evcvw*", LookIn:=xlFormulas, LookAt:=xlWhole)
'    'if any cell hasn't found exits
'    If firstFoundCell Is Nothing Then
'        Set findCVWCells = Nothing
'        Exit Function
'    End If
'    tmpColl.Add firstFoundCell
'    'searches for next occurence of evcvw
'    Set tmpCell = wRange.FindNext(firstFoundCell)
'
'    'loops until search wraps to first found cell
'    Do While firstFoundCell.Address <> tmpCell.Address
'        tmpColl.Add tmpCell
'
'        Set tmpCell = wRange.FindNext(tmpCell)
'    Loop
'
'    Set findCVWCells = tmpColl
'End Function
'
'Public Sub showCaution()
'    MsgBox "������� ������ ���������� �� �������� � ������� �����. ������ ����������", vbCritical, "������"
'End Sub
''************************************************************************************
''************************************************************************************
''************************************************************************************
'' ���������� ���
'Private Sub Expand()
'    Application.Run "MNU_eTOOLS_EXPAND"
'End Sub
'
'' �������� �����
'Private Sub refresh()
'    Application.Run "MNU_eTOOLS_REFRESH" '������ ����� �����������
'End Sub
'
''��������� ������ ��� ������������� � �������� ���������
'Private Sub Submit_NoAction_ShowResult()
'    Application.Run "MNU_ESUBMIT_REFSCHEDULE_BOOK_NOACTION_SHOWRESULT"
'End Sub
'
'Function BEFORE_EXPAND(argument As String)
'    Event_Name = "BEFORE_EXPAND"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'
'    ' ���� �� ������� ��� ���������
'    Set f = sh.Rows(1).Find(Event_Name, LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ����� ����������� �����
'        UnMergeCells sh, f.Column
'    End If
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'    BEFORE_EXPAND = True
'End Function
'
'Function AFTER_EXPAND(argument As String)
'    Event_Name = "AFTER_EXPAND"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'
'    ' ���� �� ������� ��� ���������
'    Set f = sh.Rows(1).Find(Event_Name, LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' �������� �����
'        Set f2 = sh.Columns(f.Column).Find("Refresh", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        If Not f2 Is Nothing Then
'            Application.Run "MNU_eTOOLS_REFRESH"
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'        End If
'        ' ����������� ����������
'        CopyPaste sh, f.Column
'        ' ��������� �������
'        ApplyFormulas sh, f.Column
'        ' ������ �������
'        HideColumns sh, f.Column
'        ' ���������� ������
'        MergeCells sh, f.Column
'    End If
'    ' ������� ������
'    DeleteRows sh
'    ' ����������� ������
'    Sort sh
'    ' ������ ������
'    HideRows sh
'    ' ���������������� ������������ �� ���� ����
'    Locks_OffBook
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'
'    'call for workstatus report
'    'Call prepareWorkspace
'
'    AFTER_EXPAND = True
'End Function
'
'Function BEFORE_REFRESH(argument As String)
'    Event_Name = "BEFORE_REFRESH"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    'SetOptimizeMode sh, ActCell
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    'SetNormalMode sh, ActCell
'    BEFORE_REFRESH = True
'End Function
'
'Function AFTER_REFRESH(argument As String)
'    Event_Name = "AFTER_REFRESH"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'
'    ' ���� �� ������� ��� ���������
'    Set f = sh.Rows(1).Find(Event_Name, LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ��������� �������
'        ApplyFormulas sh, f.Column
'        ' ���������� ���
'        Set f2 = sh.Columns(f.Column).Find("Expand", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        If Not f2 Is Nothing Then
'            Application.Run "MNU_eTOOLS_EXPAND"
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'        End If
'    End If
'    ' ���������������� ������������ �� ���� ����
'    'Locks_OffBook
'    'Call prepareWorkspace
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'    AFTER_REFRESH = True
'End Function
'
'Function BEFORE_SEND(argument As String)
'    Event_Name = "BEFORE_SEND"
'    If cvNotMatch Then
'        Call showCaution
'        Exit Function
'    End If
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'
'    ' ���� �� ������� ��� ���������
'    Set f = sh.Rows(1).Find(Event_Name, LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ����������� ����������
'        CopyPaste sh, f.Column
'        ' ��������� �������
'        ApplyFormulas sh, f.Column
'        ' �������� �����
'        Set f2 = sh.Columns(f.Column).Find("Refresh", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        If Not f2 Is Nothing Then
'            Application.Run "MNU_eTOOLS_REFRESH"
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'        End If
'    End If
'    ' ���������� ������� �������
'    'SetWorkStatus
'
'    ' ���� �� ������ �� ����� (��������)
'    If Check(sh) > 0 Then
'        BEFORE_SEND = False
'    Else
'        BEFORE_SEND = True
'    End If
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'End Function
'
'Function AFTER_SEND(argument As String)
'    Event_Name = "AFTER_SEND"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'
'    ' ���� �� ������� ��� ���������
'    Set f = sh.Rows(1).Find(Event_Name, LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ���������� ���
'        Set f2 = sh.Columns(f.Column).Find("Expand", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        If Not f2 Is Nothing Then
'            Application.Run "MNU_eTOOLS_EXPAND"
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'        End If
'        ' �������� �����
'        Set f2 = sh.Columns(f.Column).Find("Refresh", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        If Not f2 Is Nothing Then
'            Application.Run "MNU_eTOOLS_REFRESH"
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'        End If
'    End If
'    ' ���������������� ������������ �� ����� �����
'    Locks_OffSheet sh
'    'Locks_Off sh
'
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'    AFTER_SEND = True
'End Function
'
'Private Function Check(sh)
''
'' ��������� ������� ������ �� �����
''
'    Check = 0
'    ' ����� �������-�������
'    Set f = sh.Rows(1).Find("Check", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        Msg = "�� ����� ���� ������. �� ������� ��� ������ ��������� ������?"
'        Style = vbYesNo + vbQuestion + vbDefaultButton2
'        Title = "���������� ������"
'        ' ���� ���� ������, �� ������� ���������
'        If f.Offset(0, 1).Value > 0 Then
'            mb = MsgBox(Msg, Style, Title)
'        End If
'        If mb = vbNo Then Check = 1
'    End If
'End Function
'
'Public Function Pass(sh)
''
'' ��������� ������ �� �����
''
'    ' ����� ������-�������
'    Set f = sh.Cells.Find("PasswordBPC", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        Set f = sh.Cells(f.Row + 1, f.Column)
'        Pass = f.Value
'        If sh.ProtectContents = False Then
'            f.NumberFormat = ";;;"
'            f.Locked = True
'            f.FormulaHidden = True
'            Set r = Range(sh.Cells(f.Row - 1, f.Column), f)
'            r.Interior.ThemeColor = xlThemeColorAccent1
'            r.Interior.TintAndShade = 0.4
'        End If
'    End If
'End Function
'
'Private Sub SetOptimizeMode(sh, ActCell)
''
'' ���������� �������� ��������� ��� ����������� ���������� ��������
''
'    Application.ReferenceStyle = xlA1
'    Application.EnableEvents = False
'    Application.Calculation = xlCalculationManual
'    Application.ScreenUpdating = False
'    ' ��������� ������� �������
'    Set sh = ActiveWorkbook.ActiveSheet
'    Set ActCell = sh.Application.ActiveCell
'    ' ����� ������ �����
'    If sh.ProtectContents = True Then
'        sh.Unprotect Pass(sh)
'    End If
'    ' �������� ��������� ������� EvDRE
'    GetRanges sh, EVDRE()
'    ' �������� �������
'    sh.Calculate
'    InProcess = True
'End Sub
'
'Private Sub SetNormalMode(sh, ActCell)
''
'' ����� �������� ��������� ��� ����������� ���������� ��������
''
'    Application.EnableEvents = True
'    Application.Calculation = xlCalculationAutomatic
'    Application.CutCopyMode = False
'    '���������� ������ �����
'    If sh.ProtectContents = False And sh.Columns("A:A").Hidden = True And Not Event_Name Like "BEFORE*" Then
'        sh.Protect Pass(sh), DrawingObjects:=True, Contents:=True, Scenarios:=True _
'            , AllowFormattingCells:=True, AllowFormattingColumns:=True, AllowFormattingRows:=True, AllowFiltering:=True
'    End If
'    ' �������� �������
'    sh.Calculate
'    ' ������� ������� �������
'    sh.Activate
'    On Error Resume Next
'    sh.Cells(ActCell.Row, ActCell.Column).Select
'    On Error GoTo 0
'    ' ���� ������� AFTER
'    If Not Event_Name Like "BEFORE*" Then
'        Application.ScreenUpdating = True
'        InProcess = False
'    End If
'    ' �������� ��������� ������� EVDRE � StatusBar
'    Do
'        i = i + 1
'    Loop Until i = UBound(EVDRE, 2) Or sh.Range(EVDRE(0, i)).Value <> "EVDRE:OK"
'    Application.StatusBar = Range(EVDRE(0, i)).Value
'End Sub
'
'Private Sub GetRanges(sh, EVDRE())
''
'' �������� ��������� ������� EvDRE
''
'    Dim cnt As Integer
'    cnt = 0
'    ReDim Preserve EVDRE(0 To 8, 0 To cnt)
'    EVDRE(0, cnt) = "EVDRE_Address"
'    EVDRE(1, cnt) = "AppName"
'    EVDRE(2, cnt) = "KeyRange"
'    EVDRE(3, cnt) = "ExpandRange"
'    EVDRE(4, cnt) = "PageKeyRange"
'    EVDRE(5, cnt) = "ColKeyRange"
'    EVDRE(6, cnt) = "RowKeyRange"
'    EVDRE(7, cnt) = "CellKeyRange"
'    'EVDRE(8, cnt) = "Data"
'
'    ' ����� ������� EvDRE �� �����
'    Set e = Cells.Find("=EvDRE", Cells(sh.Rows.Count, sh.Columns.Count), LookIn:=xlFormulas, LookAt:=xlPart, SearchOrder:=xlByColumns, MatchCase:=False)
'    If Not e Is Nothing And e.Formula <> "=EVDRE()" Then
'        firstAddress = e.Address
'        Do
'            If e.Text <> e.Formula Then
'                cnt = cnt + 1
'                ReDim Preserve EVDRE(0 To 8, 0 To cnt)
'                ' ��������� ������� EVDRE �� �����
'                If IsEmpty(Cells(e.Row, e.Column + 1).Value) Or IsNumeric(Cells(e.Row, e.Column + 1).Value) Then
'                    Cells(e.Row, e.Column + 1).Value = cnt
'                End If
'
'                ' �������� ��������� EVDRE
'                EVDRE(0, cnt) = e.Address       'EVDRE_Address
'                s = e.Formula
'                s = Replace(s, ")", "", 8)
'                a = Split(s, ",")
'                EVDRE(1, cnt) = a(0)            'AppName
'                EVDRE(2, cnt) = a(1)            'KeyRange
'                If UBound(a) = 2 Then
'                    EVDRE(3, cnt) = a(2)        'ExpandRange
'                End If
'
'                ' �������� ��������� ��������� ����������
'                For i = 4 To UBound(EVDRE, 1)
'                    Set f = sh.Range(a(1)).Find(EVDRE(i, 0), LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'                    s = sh.Cells(f.Row, f.Column + 1).Formula
'                    s = Replace(s, ")", "", 8)
'                    EVDRE(i, cnt) = Split(s, ",")
'                Next i
'            End If
'            Set e = Cells.Find("=EvDRE", e, LookIn:=xlFormulas, LookAt:=xlPart, SearchOrder:=xlByColumns, MatchCase:=False)
'        Loop While firstAddress <> e.Address
'    End If
'End Sub
'
'Private Sub GetRangeBounds(RangeName As String, Nums As Variant, TopRow As Variant, LeftCol As Variant, BottomRow As Variant, RightCol As Variant)
''
'' �������� ������� ���������� ����������
''
'    ' ������������ (���������) �������������
'    TopRow = 99999
'    LeftCol = 99999
'    BottomRow = 0
'    RightCol = 0
'
'    ' ����� ������ ��������� � ������� EVDRE
'    For i = 5 To UBound(EVDRE, 1)
'        If RangeName = EVDRE(i, 0) Then RangeNum = i
'    Next i
'
'    ' ���� �� ���������� Nums
'    For i = 0 To UBound(Nums)
'        ' ����������� ������ EVDRE � ������ ������������
'        n = Split(Nums(i), ".")
'        If UBound(n) = 0 Then
'            EvdreNum = n(0)
'            MultiRangeNum = 0
'        ElseIf UBound(n) = 1 Then
'            EvdreNum = 1
'            If RangeName = "RowKeyRange" Then MultiRangeNum = n(0)
'            If RangeName = "ColKeyRange" Then MultiRangeNum = n(1)
'        Else
'            EvdreNum = n(0)
'            If RangeName = "RowKeyRange" Then MultiRangeNum = n(1)
'            If RangeName = "ColKeyRange" Then MultiRangeNum = n(2)
'        End If
'
'        ' ����� ����������� ���������
'        o = EVDRE(RangeNum, EvdreNum)
'        ' ����� ����������� ������������, ���� ������
'        If MultiRangeNum > 0 Then o = Array(o(MultiRangeNum - 1))
'
'        ' ���� �� �������������
'        For j = 0 To UBound(o)
'            ' �������� ������� ������ ������������
'            a = Split(Replace(o(j), "$", ""), ":")
'            ' ���� �������� �� ����� ������
'            If UBound(a) = 0 Then a = Array(a(0), a(0))
'            ' �������� ����� ������� ������
'            TopRow = WorksheetFunction.Min(TopRow, Range(a(0)).Row)
'            ' �������� ����� ����� �������
'            LeftCol = WorksheetFunction.Min(LeftCol, Range(a(0)).Column)
'            ' �������� ����� ������ ������
'            BottomRow = WorksheetFunction.Max(BottomRow, Range(a(1)).Row)
'            ' �������� ����� ������ �������
'            RightCol = WorksheetFunction.Max(RightCol, Range(a(1)).Column)
'        Next j
'    Next i
'    ' ���� �������� ����
'    If TopRow = 99999 Then TopRow = 0
'    If LeftCol = 99999 Then LeftCol = 0
'End Sub
'
'Sub DeleteRows(sh)
''
'' ������� ������
''
'    ' ����� �������-�������
'    Set f = sh.Rows(1).Find("Delete", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ���������� ������ EVDRE ��� ������� ��������� �������
'        Nums = Split(Replace(f.Value, " ", "", 7), ",")
'        If UBound(Nums) = -1 Then Nums = Array(1)
'        ' �������� ������� �������� ColKeyRange
'        GetRangeBounds "ColKeyRange", Nums, ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'        ' �������� ������� �������� RowKeyRange
'        GetRangeBounds "RowKeyRange", Nums, rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'        ' �������� ������� �������� CellKeyRange
'        GetRangeBounds "CellKeyRange", Nums, clkr_TopRow, clkr_LeftCol, clkr_BottomRow, clkr_RightCol
'        ' ������ ��������� ������� � ������ CellKeyRange
'        If clkr_RightCol > 0 Then ckr_RightCol = ckr_RightCol + clkr_RightCol - clkr_LeftCol + 1
'
'        ' �������� �������
'        sh.Calculate
'        ' �������� ������� ����������
'        sh.Cells.EntireRow.Hidden = False
'        ' �������� ������� �������
'        Set r = sh.Columns(f.Column)
'        r.Hidden = False
'        With r
'            Set f = .Find(1, LookIn:=xlValues, LookAt:=xlWhole)
'            If Not f Is Nothing Then
'                firstAddress = f.Address
'                's = rkr_LeftCol & f.Row & ":" & ckr_RightCol & f.Row
'                Set ur = Range(sh.Cells(f.Row, rkr_LeftCol), sh.Cells(f.Row, ckr_RightCol))
'                Do
'                    Set f = .FindNext(f)
'                    's = rkr_LeftCol & f.Row & ":" & ckr_RightCol & f.Row
'                    'Set dr = Range(s)
'                    Set dr = Range(sh.Cells(f.Row, rkr_LeftCol), sh.Cells(f.Row, ckr_RightCol))
'                    Set ur = Union(ur, dr)
'                Loop Until f.Address = firstAddress
'                ur.Select
'                ' ������� ������
'                ur.Delete Shift:=xlUp
'            End If
'        End With
'        r.Hidden = True
'    End If
'End Sub
'
'Private Sub HideRows(sh)
''
'' ������ ������
''
'    Dim r As Range
'    ' ����� �������-�������
'    Set f = sh.Rows(1).Find("Hide", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' �������� �������
'        sh.Calculate
'        ' �������� ������� ����������
'        sh.Cells.EntireRow.Hidden = False
'        ' �������� ������� ������
'        Set r = sh.Columns(f.Column)
'        r.Hidden = False
'        With r
'            Set f = .Find(1, LookIn:=xlValues, LookAt:=xlWhole)
'            If Not f Is Nothing Then
'                firstAddress = f.Address
'                Set ur = Rows(f.Row)
'                Do
'                    Set f = .FindNext(f)
'                    Set ur = Union(ur, Rows(f.Row))
'                Loop Until f.Address = firstAddress
'                ' ������ ������
'                ur.EntireRow.Hidden = True
'            End If
'        End With
'        r.Hidden = True
'    End If
'End Sub
'
'Private Sub HideColumns(sh, ColNum As Variant)
''
'' ������ �������
''
'    Dim r As Range
'    ' ����� ������-�������
'    Set f = sh.Columns(ColNum).Find("HideColumns", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' �������� �������
'        sh.Calculate
'        ' �������� ������� ����������
'        'sh.Cells.EntireColumn.Hidden = False
'        Set uh = Columns(ColNum)
'        Set uh = uh.Resize(sh.Rows.Count, sh.Columns.Count - ColNum)
'        uh.EntireColumn.Hidden = False
'
'        ' �������� ������� ������
'        Set ur = Columns(ColNum)
'        Set r = sh.Rows(f.Row)
'        r.Hidden = False
'        With r
'            Set f = .Find(1, LookIn:=xlValues, LookAt:=xlWhole)
'            If Not f Is Nothing Then
'                firstAddress = f.Address
'                Set ur = Union(ur, Columns(f.Column))
'                Do
'                    Set f = .FindNext(f)
'                    Set ur = Union(ur, Columns(f.Column))
'                Loop Until f.Address = firstAddress
'                ' ������ �������
'                ur.EntireColumn.Hidden = True
'            End If
'        End With
'        r.Hidden = True
'    End If
'End Sub
'
'Private Sub MergeCells(sh, ColNum As Variant)
''
'' ���������� ������
''
'    ' ����� ������-���������
'    Set f = sh.Columns(ColNum).Find("Merge", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        Application.DisplayAlerts = False
'        fAddress = f.Address
'        ' ��������� ����� ������
'        Do
'            Set f2 = sh.Rows(f.Row).Find("*", f, LookIn:=xlValues)
'            If Not f2 Is Nothing Then
'                Set prev = f2
'                firstAddress = f2.Address
'                ' ����������� ����� � ����� ������
'                Do
'                    If f2.Text = prev.Text Then
'                        Range(f2, prev).MergeCells = True
'                    Else
'                        Set prev = f2
'                    End If
'                    Set f2 = sh.Rows(f2.Row).Find("*", f2, LookIn:=xlValues)
'                Loop While firstAddress <> f2.Address
'                ' ����������� ����� � ������� �������
'                'If prevM = f.Row - 1 Then
'                '    Set f2 = sh.Rows(f.Row - 1).Find("*", f2, LookIn:=xlValues)
'                '    Do
'                '        Set foll = Cells(f2.Row + 1, f2.Column)
'                '        If f2.Text = foll.Text Or Len(foll.Text) = 0 Then
'                '            Range(f2, foll).MergeCells = True
'                '        End If
'                '        Set f2 = sh.Rows(f2.Row).Find("*", f2, LookIn:=xlValues)
'                '    Loop While firstAddress <> f2.Address
'                'End If
'            End If
'            'prevM = f.Row
'            ' ����� ��������� ������ ��� �����������
'            Set f = sh.Columns(ColNum).Find("Merge", Cells(f.Row, ColNum), LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        Loop While fAddress <> f.Address
'        Application.DisplayAlerts = True
'    End If
'End Sub
'
'Private Sub UnMergeCells(sh, ColNum As Variant)
''
'' ����� ����������� �����
''
'    ' ����� ������-���������
'    Set f = sh.Columns(ColNum).Find("UnMerge", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        fAddress = f.Address
'        ' ��������� ����� ������
'        Do
'            Rows(f.Row).MergeCells = False
'            ' ����� ��������� ������ ��� �����������
'            Set f = sh.Columns(ColNum).Find("UnMerge", Cells(f.Row, ColNum), LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'        Loop While fAddress <> f.Address
'    End If
'End Sub
'
'Private Sub CopyPaste(sh, ColNum As Variant)
''
'' ����������� ���������� � ������ �������
''
'    ' ����� ������ � CopyPaste
'    Set f = sh.Columns(ColNum).Find("CopyPaste", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If Not f Is Nothing Then
'        fAddress = f.Address
'        ' ��������� ����� ������
'        Do
'            ' ���������� ����� EVDRE ��� �������� ����������� �������
'            a = Split(f.Value, " ")
'            Nums = Split(Replace(Replace(f.Value, a(0), ""), " ", ""), ",")
'            If UBound(Nums) = -1 Then Nums = Array("1")
'
'            ' ��������� ������� ��� ��������� �������������
'            For i = 0 To UBound(Nums)
'                ' �������� ������� �������� ColKeyRange
'                GetRangeBounds "ColKeyRange", Array(Nums(i)), ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'                ' �������� ������� �������� RowKeyRange
'                GetRangeBounds "RowKeyRange", Array(Nums(i)), rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'
'                ' �����������
'                Set fc = sh.Rows(f.Row).Find("Copy", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'                If Not fc Is Nothing Then
'                    Range(sh.Cells(rkr_TopRow, fc.Column), sh.Cells(rkr_BottomRow, fc.Column)).Copy
'                End If
'
'                ' ��������
'                Set fp = sh.Rows(f.Row).Find("Paste", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'                If Not fp Is Nothing Then
'                    Set dr = Range(sh.Cells(rkr_TopRow, fp.Column), sh.Cells(rkr_BottomRow, fp.Column))
'                    dr.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
'                End If
'            Next i
'
'            ' ������ ������ � CopyPaste
'            Rows(f.Row).EntireRow.Hidden = True
'            ' ����� ��������� ������ � ���������
'            Set f = sh.Columns(ColNum).Find("CopyPaste", f, LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'        Loop While fAddress <> f.Address
'    End If
'End Sub
'
'Private Sub ApplyFormulas(sh, ColNum As Variant)
''
'' �������������� ������� � ��������
''
'    ' ����� ������ � ���������
'    Set f = sh.Columns(ColNum).Find("Formula", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If Not f Is Nothing Then
'        fAddress = f.Address
'        ' ��������� ����� ������
'        Do
'            ' ���������� ����� EVDRE ��� �������� ����������� �������
'            a = Split(f.Value, " ")
'            Nums = Split(Replace(Replace(f.Value, a(0), ""), " ", ""), ",")
'            If UBound(Nums) = -1 Then Nums = Array("1")
'
'            ' ��������� ������� ��� ��������� ������������
'            For i = 0 To UBound(Nums)
'                ' �������� ������� �������� ColKeyRange
'                GetRangeBounds "ColKeyRange", Array(Nums(i)), ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'                ' �������� ������� �������� RowKeyRange
'                GetRangeBounds "RowKeyRange", Array(Nums(i)), rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'                ' �������� ������� �������� RowKeyRange
'                GetRangeBounds "CellKeyRange", Array(Nums(i)), clkr_TopRow, clkr_LeftCol, clkr_BottomRow, clkr_RightCol
'                ' ���� �� ������� ��������� ��������� ������� � � ���������� �����
'                If Len(Nums(i)) = Len(Replace(Nums(i), ".", "")) Then ckr_LeftCol = rkr_LeftCol
'                ' ���� �� ������� ��������� ��������� ������� � � CellKeyRange
'                If Len(Nums(i)) = Len(Replace(Nums(i), ".", "")) And clkr_RightCol > 0 Then:
'                    ckr_RightCol = ckr_RightCol + clkr_RightCol - clkr_LeftCol + 1
'                    'ckr_RightCol = ckr_RightCol + ckr_RightCol - ckr_LeftCol + 1
'                ' ����������� �������
'                sh.Range(sh.Cells(f.Row, ckr_LeftCol), sh.Cells(f.Row, ckr_RightCol)).Copy
'                '�������� �������
'                Set dr = Range(sh.Cells(rkr_TopRow, ckr_LeftCol), sh.Cells(rkr_BottomRow, ckr_RightCol))
'                dr.PasteSpecial Paste:=xlPasteFormulas, SkipBlanks:=True, Transpose:=False
'            Next i
'
'            ' �������� �������
'            sh.Calculate
'            ' ������ ������ � ��������
'            Rows(f.Row).EntireRow.Hidden = True
'            ' ����� ��������� ������ � ���������
'            Set f = sh.Columns(ColNum).Find("Formula", f, LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'        Loop While fAddress <> f.Address
'    End If
'End Sub
'
'Sub Sort(sh)
''
'' ����������� ������
''
'    ' ����� �������-�������
'    Set f = sh.Rows(1).Find("Sort", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ���������� ������ EVDRE ��� ������� ��������� �������
'        Nums = Split(Replace(f.Value, " ", "", 5), ",")
'        If UBound(Nums) = -1 Then Nums = Array(1)
'        ' �������� ������� �������� ColKeyRange
'        GetRangeBounds "ColKeyRange", Nums, ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'        ' �������� ������� �������� RowKeyRange
'        GetRangeBounds "RowKeyRange", Nums, rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'        ' �������� ������� �������� CellKeyRange
'        GetRangeBounds "CellKeyRange", Nums, clkr_TopRow, clkr_LeftCol, clkr_BottomRow, clkr_RightCol
'        ' ������ ��������� ������� � ������ CellKeyRange
'        If clkr_RightCol > 0 Then ckr_RightCol = ckr_RightCol + clkr_RightCol - clkr_LeftCol + 1
'
'        ' �������� ������� ����������
'        sh.Cells.EntireRow.Hidden = False
'        ' �������� ������������ �������
'        sh.Sort.SortFields.clear
'        ' �������/���� ����������
'        Set akr = Range(sh.Cells(rkr_TopRow, f.Column), sh.Cells(rkr_BottomRow, f.Column))
'        sh.Sort.SortFields.Add Key:=akr, SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
'        ' �������� ����������
'        Set sr = Range(sh.Cells(rkr_TopRow, rkr_LeftCol), sh.Cells(rkr_BottomRow, ckr_RightCol))
'        With sh.Sort
'            .SetRange sr
'            .Header = xlGuess
'            .MatchCase = False
'            .Orientation = xlTopToBottom
'            .SortMethod = xlPinYin
'            .Apply
'        End With
'    End If
'End Sub
'
'Private Sub Freeze_Unfreeze()
''
'' ��������� ��� ��������� �������
''
'    ' ����� ������ �����
'    If ActiveSheet.ProtectContents = True Then
'        ActiveSheet.Unprotect Pass(ActiveSheet)
'    End If
'    ' ��������� ��� ��������� �������
'    If ActiveWindow.FreezePanes Then
'        ActiveWindow.FreezePanes = False
'    Else
'        ActiveWindow.FreezePanes = True
'    End If
'    '���������� ������ �����
'    If ActiveSheet.ProtectContents = False And ActiveSheet.Columns("A:A").Hidden = True Then
'        ActiveSheet.Protect Pass(ActiveSheet), DrawingObjects:=True, Contents:=True, Scenarios:=True _
'            , AllowFormattingCells:=True, AllowFormattingColumns:=True, AllowFormattingRows:=True, AllowFiltering:=True
'    End If
'End Sub
'
'Private Sub AutoFilter()
''
'' �������� ��� ��������� ����������
''
'    ' ����� ������ �����
'    If ActiveSheet.ProtectContents = True Then
'        ActiveSheet.Unprotect Pass(ActiveSheet)
'    End If
'    ' �������� ��� ��������� ����������
'    On Error Resume Next
'    Selection.AutoFilter
'    If Err.Number Then MsgBox "�������� �������� ��������� �������", vbCritical, "����������"
'    On Error GoTo 0
'    '���������� ������ �����
'    If ActiveSheet.ProtectContents = False And ActiveSheet.Columns("A:A").Hidden = True Then
'        ActiveSheet.Protect Pass(ActiveSheet), DrawingObjects:=True, Contents:=True, Scenarios:=True _
'            , AllowFormattingCells:=True, AllowFormattingColumns:=True, AllowFormattingRows:=True, AllowFiltering:=True
'    End If
'End Sub
'
'Private Sub ShowAll()
''
'' ���������� ������ � �������
''
'    Application.Calculation = xlCalculationManual
'    Set sh = ActiveWorkbook.ActiveSheet
'    If sh.ProtectContents = True Then
'        sh.Unprotect
'    End If
'    sh.Rows.Hidden = False
'    sh.Columns.Hidden = False
'    Application.Calculation = xlCalculationAutomatic
'End Sub
'
'Private Sub ProtectBook()
''
'' ���������� ������ �� ��� ����� ������� �����
''
'    Dim argument As String
'    ' ���� �� ���� ������ �����
'    For i = 1 To ActiveWorkbook.Sheets.Count
'        If Sheets(i).Visible = xlSheetVisible Then
'            Sheets(i).Activate
'            t = AFTER_EXPAND(argument)
'        End If
'    Next i
'End Sub
'
'Private Sub UnProtectBook()
''
'' ����� ������ �� ���� ������ ������� �����
''
'    Event_Name = "BEFORE_"
'    ' ���������� �������� ��������� ��� ����������� ���������� ��������
'    SetOptimizeMode sh, ActCell
'    ' ���� �� ���� ������ �����
'    For i = 1 To ActiveWorkbook.Sheets.Count
'        If Sheets(i).Visible = True And Sheets(i).ProtectContents = True Then
'            Sheets(i).Unprotect ActCell.Value
'        End If
'    Next i
'    sh.Activate
'    ' ����� �������� ��������� ��� ����������� ���������� ��������
'    SetNormalMode sh, ActCell
'End Sub
'
'Private Sub NewRows(nt As Variant)
''
'' �������� ����� ������
''
'    Set sh = ActiveWorkbook.ActiveSheet
'
'    ' ����� �������� ������� NewRow
'    Set f = sh.Rows(1).Find("NewRows", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If f Is Nothing Then
'        MsgBox "�� ������� ������� NewRows", vbCritical, "���������� ������"
'    Else
'        ' ���������� ���������� ����������� �����
'        q = Replace(f.Value, " ", "", 8)
'        If IsNumeric(q) = False Then q = 5
'        ' ����� ������-�������
'        Set t = sh.Columns(f.Column).Find(nt & "Template", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'        If t Is Nothing Then
'            MsgBox "�� ������� ������-�������", vbCritical, "���������� ������"
'        Else
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'
'            ' ���������� ������ EVDRE ��� ������� ��������� �������
'            Nums = Split(Replace(t.Value, " ", "", Len(nt) + 9), ",")
'            If UBound(Nums) = -1 Then Nums = Array(nt)
'            ' �������� ������� �������� ColKeyRange
'            GetRangeBounds "ColKeyRange", Nums, ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'            ' �������� ������� �������� RowKeyRange
'            GetRangeBounds "RowKeyRange", Nums, rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'            ' �������� ������� �������� CellKeyRange
'            GetRangeBounds "CellKeyRange", Nums, clkr_TopRow, clkr_LeftCol, clkr_BottomRow, clkr_RightCol
'            ' ������ ��������� ������� � ������ CellKeyRange
'            If clkr_RightCol > 0 Then ckr_RightCol = ckr_RightCol + clkr_RightCol - clkr_LeftCol + 1
'
'            '����� ��������� ������ ��� AfterRange
'            Do
'                Set lr = Range(sh.Cells(rkr_BottomRow, rkr_LeftCol), sh.Cells(rkr_BottomRow, rkr_RightCol))
'                Set l = lr.Find("EV_AFTER", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'                If Not l Is Nothing Then
'                    rkr_BottomRow = rkr_BottomRow - 1
'                End If
'            Loop While Not l Is Nothing And rkr_BottomRow >= rkr_TopRow
'
'            ' ������������ ����� ��������� ������
'            Set lr = Range(sh.Cells(rkr_BottomRow, rkr_LeftCol), sh.Cells(rkr_BottomRow, ckr_RightCol))
'            ' �������� ����������� ���������� �����
'            For i = 1 To q
'                lr.Insert Shift:=xlDown
'            Next
'            ' ����������� ��������� ������
'            lr.Copy
'            ' ������������ ����� ��������� ������
'            Set lr = Range(sh.Cells(rkr_BottomRow, rkr_LeftCol), sh.Cells(rkr_BottomRow, ckr_RightCol))
'            ' �������� ��� �� ��������� ������
'            lr.PasteSpecial Paste:=xlPasteAll, SkipBlanks:=False, Transpose:=False
'
'            ' ������������ ����� ����������� �����
'            Set tr = Range(sh.Cells(rkr_BottomRow + 1, rkr_LeftCol), sh.Cells(rkr_BottomRow + q, ckr_RightCol))
'            ' ����������� ������-�������
'            Range(sh.Cells(t.Row, rkr_LeftCol), sh.Cells(t.Row, ckr_RightCol)).Copy
'            ' �������� ��� �� ������-�������
'            tr.PasteSpecial Paste:=xlPasteAll, SkipBlanks:=False, Transpose:=False
'
'            ' ����� �������� ��������� ��� ����������� ���������� ��������
'            SetNormalMode sh, ActCell
'        End If
'    End If
'End Sub
'
'Private Sub AddNewRows1()
'    NewRows 1
'End Sub
'
'Private Sub AddNewRows2()
'    NewRows 2
'End Sub
'
'Private Sub AddNewRows3()
'    NewRows 3
'End Sub
'
'Private Sub AddNewRows4()
'    NewRows 4
'End Sub
'
'Private Sub AddNewRows5()
'    NewRows 5
'End Sub
'
'Private Sub AddNewRows6()
'    NewRows 6
'End Sub
'
'Private Sub AddNewRows7()
'    NewRows 7
'End Sub
'
'Private Sub AddNewRows8()
'    NewRows 8
'End Sub
'
'Private Sub AddNewRows9()
'    NewRows 9
'End Sub
'
'Private Sub ChangeRow(nt As Variant)
''
'' �������� ������������ ������
''
'    Set sh = ActiveWorkbook.ActiveSheet
'
'    ' ����� �������� ������� NewRow
'    Set f = sh.Rows(1).Find("NewRows", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'    If f Is Nothing Then
'        MsgBox "�� ������� ������� NewRows", vbCritical, "���������� ������"
'    Else
'        ' ����� ������-�������
'        Set t = sh.Columns(f.Column).Find(nt & "Change", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'        If t Is Nothing Then
'            MsgBox "�� ������� ������-�������", vbCritical, "���������� ������"
'        Else
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'
'            ' ���������� ������ EVDRE ��� ������� ��������� �������
'            Nums = Split(Replace(t.Value, " ", "", Len(nt) + 7), ",")
'            If UBound(Nums) = -1 Then Nums = Array(nt)
'            ' �������� ������� �������� ColKeyRange
'            GetRangeBounds "ColKeyRange", Nums, ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'            ' �������� ������� �������� RowKeyRange
'            GetRangeBounds "RowKeyRange", Nums, rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'            ' �������� ������� �������� CellKeyRange
'            GetRangeBounds "CellKeyRange", Nums, clkr_TopRow, clkr_LeftCol, clkr_BottomRow, clkr_RightCol
'            ' ������ ��������� ������� � ������ CellKeyRange
'            If clkr_RightCol > 0 Then ckr_RightCol = ckr_RightCol + clkr_RightCol - clkr_LeftCol + 1
'
'            ' ������������ ����� ����������� ������
'            If rkr_BottomRow = ActCell.Row Then r = ActCell.Row Else r = ActCell.Row + 1
'            Set ir = Range(sh.Cells(r, rkr_LeftCol), sh.Cells(r, ckr_RightCol))
'            ' �������� ����� ������
'            ir.Insert Shift:=xlDown
'            ' ������������ ����� ���������� ������
'            Set cr = Range(sh.Cells(ActCell.Row, rkr_LeftCol), sh.Cells(ActCell.Row, ckr_RightCol))
'            ' ����������� ���������� ������
'            cr.Copy
'            ' ������������ ����� ����������� ������
'            Set ir = Range(sh.Cells(r, rkr_LeftCol), sh.Cells(r, ckr_RightCol))
'            ' �������� ��� �� ���������� ������
'            ir.PasteSpecial Paste:=xlPasteAll, SkipBlanks:=False, Transpose:=False
'
'            ' ����������� ������-�������
'            Range(sh.Cells(t.Row, rkr_LeftCol), sh.Cells(t.Row, ckr_RightCol)).Copy
'            ' ������������ ����� ����� ������
'            'Set tr = Range(sh.Cells(ActCell.Row, rkr_LeftCol), sh.Cells(ActCell.Row, ckr_RightCol))
'            If rkr_BottomRow = ActCell.Row - 1 Then r = ActCell.Row
'            Set ir = Range(sh.Cells(r, rkr_LeftCol), sh.Cells(r, ckr_RightCol))
'            ' �������� ��� �� ������-�������
'            ir.PasteSpecial Paste:=xlPasteAll, SkipBlanks:=True, Transpose:=False
'
'            ' ������ ������
'            HideRows sh
'            Application.EnableEvents = True
'
'            ' ����� �������� �������
'            Set ckr = Range(sh.Cells(ckr_BottomRow, ckr_LeftCol), sh.Cells(ckr_BottomRow, ckr_RightCol))
'            Set v = ckr.Find("*", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'            If Not v Is Nothing Then
'                firstAddress = v.Address
'                Set cc = Cells(r - 1, v.Column)
'                Set ur = cc
'                Do
'                    'v.Select
'                    Set cc = Cells(r - 1, v.Column)
'                    ' �������� ���������� ������
'                    If Not cc.Formula Like "=*" Then Set ur = Union(ur, cc) 'cc.ClearContents
'                    Set v = ckr.Find("*", v, LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'                Loop While firstAddress <> v.Address
'                ur.ClearContents
'            End If
'
'            ' ����� �������� ��������� ��� ����������� ���������� ��������
'            SetNormalMode sh, ActCell
'        End If
'    End If
'End Sub
'
'Private Sub ChangeRow1()
'    ChangeRow 1
'End Sub
'
'Private Sub ChangeRow2()
'    ChangeRow 2
'End Sub
'
'Private Sub ChangeRow3()
'    ChangeRow 3
'End Sub
'
'Private Sub ChangeRow4()
'    ChangeRow 4
'End Sub
'
'Private Sub ChangeRow5()
'    ChangeRow 5
'End Sub
'
'Private Sub ChangeRow6()
'    ChangeRow 6
'End Sub
'
'Private Sub ChangeRow7()
'    ChangeRow 7
'End Sub
'
'Private Sub ChangeRow8()
'    ChangeRow 8
'End Sub
'
'Private Sub ChangeRow9()
'    ChangeRow 9
'End Sub
'
'Private Function SAPlogon()
''
'' ���� � ������� SAP
''
'    Application.StatusBar = "���������� � ��������..."
'    SAPlogon = False
'    On Error Resume Next
'    Workbooks.Open "C:\PROGRAM FILES\COMMON FILES\SAP SHARED\BW\sapbex.xla"
'    If Err.Number Then MsgBox "�� ������ ���� sapbex.xla", vbCritical, "����������� � ������� SAP": Exit Function
'    On Error GoTo 0
'    Set myConnection = Run("SAPBEX.XLA!SAPBEXgetConnection")
'    With myConnection
'        Select Case Application.Run("EVSVR")
'            Case "HTTP://172.16.34.1"
'                SapServer = "172.16.10.4"
'                .Client = "100"
'            Case "HTTP://172.16.10.12"
'                SapServer = "172.16.10.12"
'                .Client = "200"
'            Case "HTTP://172.16.30.6"
'                SapServer = "172.16.30.6"
'                .Client = "300"
'            Case "HTTP://V-SAP-DBI"
'                SapServer = "172.16.10.4"
'                .Client = "100"
'            Case "HTTP://V-SAP-QBI"
'                SapServer = "172.16.10.12"
'                .Client = "200"
'            Case "HTTP://V-SAP-PBI"
'                SapServer = "172.16.30.6"
'                .Client = "300"
'        End Select
'        .ApplicationServer = SapServer
'        .SystemNumber = "00"
'        .User = "WF-COMM"
'        .Password = "P@ssw0rd"
'        .Language = "en"
'        .logon 0, True
'        If .IsConnected <> 1 Then
'            .logon 0, False
'            If .IsConnected <> 1 Then MsgBox "���������� � �������� ���������� �� �������", vbCritical, "����������� � ������� SAP": Exit Function
'        End If
'    End With
'    SAPlogon = True
'    Application.StatusBar = "���������� � �������� ������� �����������"
'End Function
'
'Private Function SAPconnect(fm_name)
''
'' ����������� � ������� SAP, �������� ������� �������������� ������
''
'    'SAPconnect = False
'    If SAPlogon Then
'        Set sap = CreateObject("SAP.Functions")
'        sap.Connection = myConnection
'        On Error Resume Next '?
'        Set fm = sap.Add(fm_name)
'        If Err.Number Then MsgBox "�������������� ������ " & fm_name & " �� ������", vbCritical, "����������� � ������� SAP": Exit Function
'        On Error GoTo 0 '?
'        SAPconnect = True
'    End If
'End Function
'
'Private Sub Locks(ds, mode)
''
'' �������� Sub: ���������������� (+), ���������������� (-/--/---), �������� ������ (?)
''
'    Const fm_name = "ZUJW_LOCK"
'    On Error Resume Next
'        If sap Is Empty Then SAPconnect (fm_name)
'        fm.exports("DATASRC") = ds
'        fm.exports("USER_ID") = UCase(Application.Run("EVUSR"))
'        fm.exports("ACTION") = mode
'        Set tabl = fm.Tables("TAB")
'        fm.call
'    On Error GoTo 0
'End Sub
'
'Public Sub Locks_On(sh, Target)
''
'' ���������������� ������������ �� ����� �����
''
'    If Not InProcess And Not IsRegistered And UsingLocks Then
'        Set sh = ActiveWorkbook.ActiveSheet
'        Set ds = Locks_DS(sh)
'        If Not ds Is Nothing Then
'            ' ���������� �������� ��������� ��� ����������� ���������� ��������
'            SetOptimizeMode sh, ActCell
'            Locks ds, "+"
'            Locks_ListInCell sh
'            Locks_IsRegistered sh, "Y"
'            ' ����� �������� ��������� ��� ����������� ���������� ��������
'            SetNormalMode sh, ActCell
'        End If
'    End If
'End Sub
'
'Public Sub Locks_Off(sh As Worksheet, Target)
''
'' ���������������� ������������ �� ��� ���� ����� � �����
''
'    If UsingLocks Then
'
'        ' ���������� �������� ��������� ��� ����������� ���������� ��������
'        SetOptimizeMode sh, ActCell
'
'        Set sht = sh
'        For Each sh In Sheets
'            If UsingLocks And sh.Visible = xlSheetVisible And Locks_IsRegistered(sh, "?") Then
'                Locks sh, "-"
'            End If
'        Next
'        Set sh = sht
'
'        ' ����� �������� ��������� ��� ����������� ���������� ��������
'        SetNormalMode sh, ActCell
'
'    End If
'
'End Sub
'
'Private Sub Locks_OffBook()
''
'' ���������������� ������������ �� ��� ���� ����� � �����
''
'    'Set sh = ActiveWorkbook.ActiveSheet
'
'    Set sht = sh
'    For Each sh In Sheets
'         If sh.Visible = xlSheetVisible And UsingLocks Then
'            Locks_OffSheet sh
'         End If
'    Next
'    Set sh = sht
'End Sub
'
'Private Sub Locks_OffSheet(sh)
''
'' ���������������� ������������ �� ����� �����
''
'If UsingLocks Then
'    ' ����� ������ �����
'    If sh.ProtectContents = True Then
'        sh.Unprotect Pass(sh)
'    End If
'    ' ���� ������������ ���������������
'    If Locks_IsRegistered(sh, "?") Then
'        Locks Locks_DS(sh), "-"
'        Locks_IsRegistered sh, "N"
'    End If
'    ' ������� ������ ������������������ ������������� � ������
'    Locks_ListInCell sh
'    ' ���������� ������ �����
'    If sh.ProtectContents = False And sh.Columns("A:A").Hidden = True And Not Event_Name Like "BEFORE*" Then
'        sh.Protect Pass(sh), DrawingObjects:=True, Contents:=True, Scenarios:=True _
'            , AllowFormattingCells:=True, AllowFormattingColumns:=True, AllowFormattingRows:=True
'    End If
'End If
'
'End Sub
'
'Private Sub Locks_OffAll()
''
'' ���������������� ������������ ��������� �� ���� ���� �����
''
'    Locks sh, "--"
'End Sub
'
'Public Function Locks_ListInWindow(sh, Target)
''
'' ������� ������ ������������������ ������������� � ����
''
'    If UsingLocks Then
'        InProcess = True
'        If Target = Locks_Result(sh) Then
'            Locks sh, "?"
'            '������� ������ ������������� ��� ������
'            s = ""
'            For i = 1 To tabl.RowCount
'              s = s & vbCrLf & i & ". " & tabl(i, 2) & " - " & tabl(i, 3) & " " & tabl(i, 4)
'            Next i
'            ' ������� ������ ������������� � ����
'            If i = 1 Then
'                MsgBox "������ � ������ ����� �� ��������", vbInformation, "������������� ������"
'            Else
'                MsgBox "������ � ������ " & tabl(1, 1) & " �������� ������������:" & vbCrLf & s, vbExclamation, "������������� ������"
'            End If
'            Locks_ListInWindow = True
'        Else
'            Locks_ListInWindow = False
'        End If
'        InProcess = False
'    End If
'End Function
'
'Private Sub Locks_ListInCell(sh)
''
'' ������� ������ ������������������ ������������� � ������
''
'    Set ds = Locks_DS(sh)
'    If Not ds Is Nothing Then
'        Locks ds, "?"
'        '������� ������ ������������� � ������
'        s = ""
'        For i = 1 To tabl.RowCount
'            s = s & ", " & tabl(i, 2)
'        Next i
'        ' ������� ������ ������������� � ������
'        Set lr = Locks_Result(sh)
'        If i = 1 Then
'            lr.Value = "������ � ������ ����� �� ��������"
'            With lr.Font
'                .Name = "Calibri"
'                .Size = 12
'                .Color = -16751616
'            End With
'        Else
'            lr.Value = "������ � ������ ��������: " & Mid(s, 3)
'            With lr.Font
'                .Name = "Calibri"
'                .Size = 12
'                .Color = -16233056
'            End With
'        End If
'    End If
'End Sub
'
'Private Function Locks_Result(sh) As Object
''
'' ���������� ������ ��� ������ �������������
''
'    Set f = sh.Rows(1).Find("������ � ������", LookIn:=xlValues, LookAt:=xlPart, MatchCase:=False)
'    If f Is Nothing Then
'        Set f = sh.Rows(1).Find("", LookIn:=xlValues, LookAt:=xlWhole, MatchCase:=False)
'    End If
'    Set Locks_Result = f
'End Function
'
'Public Function Locks_IsRegistered(sh, NewValue As String)
''
'' ������������� ������������� ����������� ������������ � ������ � ����������
''
'    Set ds = Locks_DS(sh)
'    If Not ds Is Nothing Then
'        If NewValue = "Y" Then
'            Cells(ds.Row + 1, ds.Column).Value = "Y"
'            IsRegistered = True
'        ElseIf NewValue = "N" Then
'            sh.Cells(ds.Row + 1, ds.Column).Value = "N"
'            IsRegistered = False
'        ElseIf NewValue = "?" Then
'            If sh.Cells(ds.Row + 1, ds.Column).Value = "Y" Then
'                IsRegistered = True
'            Else
'                IsRegistered = False
'            End If
'            'Set sh = ActiveWorkbook.ActiveSheet '??
'        End If
'        Locks_IsRegistered = IsRegistered
'    Else
'        IsRegistered = True
'        Locks_IsRegistered = False
'    End If
'End Function
'
'Private Function Locks_DS(sh) As Object
''
'' ���������� ������ ��� ��� ����� ����� (�������� ������)
''
'    Set Locks_DS = sh.Rows(1).Find("DS_", LookIn:=xlFormulas, LookAt:=xlPart, MatchCase:=False)
'End Function
'
'Private Sub SetWorkStatus()
''
'' ���������� ������� �������
''
'    Const fm_name = "ZUJW_STATUS"
'    Dim WorkStatus() As String
'    ReDim Preserve WorkStatus(0 To 9, -1 To 0)
'
'    ' ����� ������� �� ���������
'    Set f = Rows(1).Find("WorkStatus", LookIn:=xlFormulas, LookAt:=xlWhole, MatchCase:=False)
'    If Not f Is Nothing Then
'        ' ���������� �������� ��������� ��� ����������� ���������� ��������
'        SetOptimizeMode sh, ActCell
'
'        ' ���������� ������ EVDRE
'        a = Split(f.Value, " ")
'        Nums = Split(Replace(Replace(f.Value, a(0), ""), " ", ""), ",")
'        If UBound(Nums) = -1 Then Nums = Array("1")
'
'        ' ������� ������� � EVDRE
'        For i = 0 To UBound(Nums)
'            ' �������� ������� �������� ColKeyRange
'            GetRangeBounds "ColKeyRange", Nums, ckr_TopRow, ckr_LeftCol, ckr_BottomRow, ckr_RightCol
'            ' �������� ������� �������� RowKeyRange
'            GetRangeBounds "RowKeyRange", Array(Nums(i)), rkr_TopRow, rkr_LeftCol, rkr_BottomRow, rkr_RightCol
'            ' ������������� ������� ��������
'            For j = rkr_LeftCol To ckr_LeftCol - 1
'                v = Cells(rkr_TopRow - 1, j).Value
'                If Len(v) > 0 And v <> "1" And v <> "IncludeChildren" Then
'                    K = K + 1
'                    WorkStatus(K, -1) = j
'                    WorkStatus(K, 0) = Cells(rkr_TopRow - 1, j).Value
'                ElseIf v = "IncludeChildren" Then
'                    WorkStatus(6, -1) = j
'                    WorkStatus(6, 0) = "IncludeChildren"
'                End If
'            Next j
'            WorkStatus(7, 0) = "NewStatus"
'            WorkStatus(8, 0) = "ResultID"
'            WorkStatus(9, 0) = "ResultText"
'
'            ' ����� �������� ������� ��� ���������
'            Set r = Range(sh.Cells(rkr_TopRow, f.Column), sh.Cells(rkr_BottomRow, f.Column))
'            Set ws = r.Find("*", LookIn:=xlValues)
'            If Not ws Is Nothing Then
'                firstAddress = ws.Address
'                Do
'                    cnt = cnt + 1
'                    ' ���������� ������ � ������ ��������
'                    ReDim Preserve WorkStatus(0 To 9, -1 To cnt)
'                    ' ����� ������
'                    WorkStatus(0, cnt) = ws.Row
'                    ' �������� ���������������� �������
'                    WorkStatus(7, cnt) = CStr(sh.Cells(ws.Row, f.Column).Value)
'                    ' ���������� ������
'                    For j = 1 To 6
'                        If Len(WorkStatus(j, -1)) <> 0 Then
'                            WorkStatus(j, cnt) = sh.Cells(ws.Row, CInt(WorkStatus(j, -1))).Value
'                        End If
'                    Next j
'                    Set ws = r.Find("*", ws, LookIn:=xlValues)
'                Loop Until ws.Address = firstAddress
'            End If
'
'            ' ����� ��, ������� ��������� ������� �� ������� WorkStatus
'            ' ����������� � ������� SAP, �������� ������� �������������� ������
'            If SAPconnect(fm_name) Then
'                ' ������������� ����������
'                Domain = Environ("UserDomain")
'                Select Case Domain
'                  Case "DTEK", "DTEKGROUP", "PAVLOGRADYGOL", "PES", "PRMZ", "SICHEV"
'                  Case Else: Domain = "DTEKGROUP"
'                End Select
'                fm.exports("USER_ID") = Domain & "\" & UCase(Application.Run("EVUSR"))
'                fm.exports("APPSET_ID") = Application.Run("EVAST")
'                fm.exports("APPLICATION_ID") = Range(EVDRE(1, Nums(i))).Value
'
'                ' ���������������� ������� ��������
'                Set st = fm.Tables("TAB")
'                For ii = 0 To cnt
'                  st.AppendRow
'                  For jj = 1 To 9
'                    st(ii + 1, jj) = WorkStatus(jj, ii)
'                  Next jj
'                Next ii
'
'                ' ����� ������ � ������� SAP
'                fm.call
'
'                ' ����� �����������
'                jj = ckr_RightCol + 1
'                Range(sh.Cells(rkr_TopRow, jj), sh.Cells(rkr_BottomRow, jj + 1)).ClearContents
'                For ii = 1 To cnt
'                  temp = st(ii + 1, 8)
'                  sh.Cells(WorkStatus(0, ii), jj + 0) = st(ii + 1, 8)
'                  sh.Cells(WorkStatus(0, ii), jj + 1) = st(ii + 1, 9)
'                Next ii
'                Application.StatusBar = "SetWorkStatus - Ok:" & fm.imports("NUMOK") & ", Error:" & fm.imports("NUMERR")
'
'                ' ��������� (�����������) ����� �����������
'                Application.Run "MNU_eSUBMIT_REFSCHEDULE_SHEET_NOACTION"
'                ' �������� ����� ����� ��������� ��������
'                Application.Run "MNU_eTOOLS_EXPAND"
'                ' ���������� �������� ��������� ��� ����������� ���������� ��������
'                SetOptimizeMode sh, ActCell
'            End If
'        Next i
'
'        ' ����� �������� ��������� ��� ����������� ���������� ��������
'        SetNormalMode sh, ActCell
'    End If
'End Sub
'
'Public Function MAXIF(SearchRange As Range, Criteria, MaxRange As Range)
''
'' ������������ �������� � ������� ��������������� �������
''
'' SearchRange - ��� ������ ����
'' Criteria - ��� ������ � ������
'' MaxRange - ��� ������ ��������
'
'    Application.Calculation = xlCalculationManual
'        Application.Volatile True '������ ������� ������� �������� �����
'    MAXIF = 0
'
'    ' �������� � ������� ������ ����
'    Set c1 = ActiveWorkbook.ActiveSheet.Cells(SearchRange.Row, SearchRange.Column)
'    Set c2 = ActiveWorkbook.ActiveSheet.Cells(SearchRange.Row + SearchRange.Count - 1, SearchRange.Column)
'    Set r = ActiveWorkbook.ActiveSheet.Range(c1, c2)
'    With r
'        Set f = .Find(Criteria, LookIn:=xlValues, LookAt:=xlWhole)
'        If Not f Is Nothing Then
'            firstAddress = f.Address
'            Do
'                v = Cells(f.Row, MaxRange.Column).Value2
'                If MAXIF < v Then MAXIF = v
'                Set f = .Find(Criteria, f, LookIn:=xlValues, LookAt:=xlWhole)
'                'Set f = .FindNext(f)
'            Loop Until f.Address = firstAddress
'        End If
'    End With
'
'    Application.Calculation = xlCalculationAutomatic
'End Function
'
