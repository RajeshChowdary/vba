VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} UserForm1 
   Caption         =   "�������� ����� ��� �������� ������"
   ClientHeight    =   4740
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7530
   OleObjectBlob   =   "UserForm1.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "UserForm1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Dim FileName As Variant 'stores filenames chosen by user

Sub CommandButton1_Click()
    'Set tempWB = Workbooks("����� ���_2.xlsx") 'switch to workbook on that we are working now
    
    
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
                MultiSelect:=True)
    ' Exit if dialog box canceled
    If Not IsArray(FileName) Then
        MsgBox "����������, �������� ����"
        Exit Sub
    End If
    ' Display full path and name of the files
    For i = LBound(FileName) To UBound(FileName)
        Msg = Msg & flw.extractNameWithExt(CStr(FileName(i))) & ";"
    Next i
    UserForm1.TextBox1.Text = Msg
    UserForm1.Label1.ForeColor = vbBlack
    CommandButton3.Enabled = True
    UserForm1.Caption = "��� ������ ��� ������������"
End Sub

Private Sub CommandButton3_Click()
    Dim flw As New FileWorker
    Dim srcWBook As New Workbook
    Dim destWBook As New Workbook
    
    Set destWBook = ActiveWorkbook
    
    For i = LBound(FileName) To UBound(FileName)
        Set srcWBook = Workbooks.Open(CStr(FileName(i)))
        Call myLoader(srcWBook, destWBook)
        If UserForm1.closeChkBox.value Then
            srcWBook.Close savechanges:=False
        End If
    Next i
    Unload UserForm1
End Sub

Private Sub helpBtn_Click()
    Dim helpMsg As String
    helpMsg = "1. ����� ������� ����� ��� ������������ ������� ������ � ""�"". �� ������ �������� ��������� ������ (� ������� ������ ""Ctrl"" ��� ""Shift""). ����� ������ ������ �� ����� ������ ��������� � ��������� ���� ����� � �������, ����� ������ ""���������"" ������ ��������. ����� ������, � ��������� ����, ����������� "";""." & vbCrLf & vbCrLf & _
            "2. ����� ��������� ��������� ���������� ����. �� ��������� ������� ""������� ����"" > ""����"" > (��� ���������� ��������) ""�����2_�"", ��� ����� ���������� ��������� ���������� ��������� �������: ����������� ��������� �����, ���������� ���� ""���"", ��� ������� ������ ��������� ������� ""������� ����"", � ���� ������� ��������� ������� ""����"" � ���������� � ������� ���. ���������� �������� ���������� ��������, ������ ������ ������� � ����� ""�����2_�""." & vbCrLf & vbCrLf & _
            "3. �����, ���� ������ ������� ��� ����� �����������, ������� ��������������� �������."
    MsgBox helpMsg, Title:="������� ����������"
End Sub



Private Sub yearBPChkBox_Change()

    If yearBPChkBox Then
        tpOBtn.Enabled = False
        opOBtn.Enabled = False
        bpOptBtn.Enabled = False
    Else
        tpOBtn.Enabled = True
        opOBtn.Enabled = True
        bpOptBtn.Enabled = True
    End If

End Sub

