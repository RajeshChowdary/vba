VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
''Private Sub Workbook_Activate()
''    Call onWorkBookActivate
'
''End Sub
'
''
'' ��� ���������� ������� � ��������� � �������� ���������
''
'Private Sub Workbook_Open()
'
'' ��������� ������� - ����� ����� �������� �����
'' ��������� � ������� ����� ��������
'  'Dim c As Object
'  'For Each c In VBProject.VBComponents
'  '  If Left(c.Name, 9) = "MasterBPC" Then VBProject.VBComponents.Remove c
'  'Next c
'  'VBProject.VBComponents.Import "\\v-sap-pcts\Communic\Macros\MasterBPC.bas"
'End Sub
'
''
'' ��� ������������ ������������� ������ ������������� � ������ �������
''
'Private Sub Workbook_SheetChange(ByVal sh As Object, ByVal Target As Range)
'' ��������� ������� - ����� ��������� ������ �� �����
'' ���������������� ������������ �� ����� �����
'    Locks_On sh, Target
'End Sub
'
Private Sub Workbook_BeforeClose(Cancel As Boolean)
'' ��������� ������� - ����� ��������� �����
'' ���������������� ������������ �� ���� ���� � �����
'    Locks_Off sh, Target

    Call sendComments
End Sub
'
'Private Sub Workbook_SheetBeforeDoubleClick(ByVal sh As Object, ByVal Target As Range, Cancel As Boolean)
'' ��������� ������� - ����� ������� �������� ����
'' ������� ������ ������������������ ������������� � ����
'    Cancel = Locks_ListInWindow(sh, Target)
'End Sub
'
'Private Sub Workbook_SheetActivate(ByVal sh As Object)
'' ��������� ������� - ����� ��������� (�������) �����
'' �������� ���������� �������� ���������� IsRegistered
'    Locks_IsRegistered sh, "?"
'End Sub
'
''
'' ����� ������� ���������������� �������� ����������� ��� ���������� �����
''
'Public Sub UserSub_Before(sh, ActCell, Event_Name, EVDRE())
'' ������������ ����� �������� ������� ��������
'
'End Sub
'
'Public Sub UserSub_After(sh, ActCell, Event_Name, EVDRE())
'' ������������ ����� ��������� ������ ��������
'End Sub
'