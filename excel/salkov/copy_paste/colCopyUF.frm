VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} colCopyUF 
   Caption         =   "����� ������� ��� �����������"
   ClientHeight    =   4875
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   5955
   OleObjectBlob   =   "colCopyUF.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "colCopyUF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cancelBtn_Click()
    Unload Me
End Sub

Private Sub copyFromChsBtn_Click()
    'test
    Dim Filt As String
    Dim FilterIndex As Integer
    'Dim FileName As Variant
    Dim Title As String
    Dim i As Integer
    Dim Msg As String
    Dim flw As New FileWorker
    
    ' Set up list of file filters
    Filt = "Excel files (*.xlsx;*.xltx;*.xlsm;*.xltm),*.xlsx;*.xltx;*.xlsm;*.xltm"
    FilterIndex = 1
    ' Set the dialog box caption
    Title = "�������� ����� ��� ������������"
    ' Get the file name
    
    FileName = Application.GetOpenFilename _
                (FileFilter:=Filt, _
                FilterIndex:=FilterIndex, _
                Title:=Title, _
                MultiSelect:=False)
    ' Exit if dialog box canceled
    If FileName = "" Then
        MsgBox "����������, �������� ����"
        Exit Sub
    End If
    ' Display full path and name of the files
    Msg = Msg & flw.extractNameWithExt(CStr(FileName))
    
    colCopyUF.Label7.Caption = Msg
    colCopyUF.Label7.ForeColor = vbBlack
    colCopyUF.Label7.ControlTipText = "��� ����� �� �������� ����� ���������� �����������"
    colCopyUF.Label8.ForeColor = vbRed
    colCopyUF.copyToChsBtn.Enabled = True
    
End Sub

Private Sub copyToChsBtn_Click()

        'test
    Dim Filt As String
    Dim FilterIndex As Integer
    'Dim FileName As Variant
    Dim Title As String
    Dim i As Integer
    Dim Msg As String
    Dim flw As New FileWorker
    
    ' Set up list of file filters
    Filt = "Excel files (*.xlsx;*.xltx;*.xlsm;*.xltm),*.xlsx;*.xltx;*.xlsm;*.xltm"
    FilterIndex = 1
    ' Set the dialog box caption
    Title = "�������� ����� ��� ������������"
    ' Get the file name
    
    FileName = Application.GetOpenFilename _
                (FileFilter:=Filt, _
                FilterIndex:=FilterIndex, _
                Title:=Title, _
                MultiSelect:=False)
    ' Exit if dialog box canceled
    If FileName = "" Then
        MsgBox "����������, �������� ����"
        Exit Sub
    End If
    ' Display full path and name of the files
    Msg = Msg & flw.extractNameWithExt(CStr(FileName))
    
    colCopyUF.Label8.Caption = Msg
    colCopyUF.Label8.ForeColor = vbBlack
    colCopyUF.Label8.ControlTipText = "��� ����� � ������� ����� ���������� �����������"
    
    colCopyUF.execBtn.Enabled = True

End Sub

Private Sub execBtn_Click()
    Dim flw As New FileWorker
    Dim wbFrom As Workbook, wbTo As Workbook
    Dim checkedVal As Integer
    
    If perOpenOptBtn.value Then
        checkedVal = 1
    ElseIf firQuatOptBtn.value Then
        checkedVal = 2
    ElseIf secQuatOptBtn.value Then
        checkedVal = 3
    ElseIf thiQuatOptBtn.value Then
        checkedVal = 4
    Else
        checkedVal = 5
    End If
    
    Set wbFrom = Workbooks(flw.extractNameWithExt(Label7.Caption))
    Set wbTo = Workbooks(flw.extractNameWithExt(Label8.Caption))
    
    Call centralExecUnit(checkedVal, wbFrom, wbTo)
    
End Sub
