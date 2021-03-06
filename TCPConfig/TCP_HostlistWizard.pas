Unit TCP_HostlistWizard;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, StdCtrls, Buttons, ExtCtrls,Messages;

Type
  THostListWizard = Class (TForm)
    NoteBook1: TNoteBook;
    GroupBox1: TGroupBox;
    Info: TLabel;
    Label1: TLabel;
    LabelStep1: TLabel;
    GroupBoxIP: TGroupBox;
    EditHostIP: TEdit;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    Label2: TLabel;
    LabelStep2: TLabel;
    GroupBoxHostname: TGroupBox;
    EditHostname: TEdit;
    Label3: TLabel;
    LabelStep3: TLabel;
    GroupBoxAliasName: TGroupBox;
    EditHostAlias: TEdit;
    GroupBoxCOmment: TGroupBox;
    EditHostComment: TEdit;
    LabelStep4: TLabel;
    Image1: TImage;
    LabelFin1: TLabel;
    LabelFin2: TLabel;
    Label4: TLabel;
    Procedure HostListWizardOnSetupShow (Sender: TObject);
    Procedure NoteBook1OnPageChanged (Sender: TObject);
    Procedure ButtonBackOnClick (Sender: TObject);
    Procedure ButtonNextOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einf�gen}
  Public
    {�ffentliche Deklarationen hier einf�gen}
  HostListEntryFlag:Boolean;
  EntryIndex       :Longint;
  PageIndex        :byte;
  End;

Var
  HostListWizard: THostListWizard;

Implementation
USES DEBUGUnit,TCP_LanguageUnit,Dialogs,TCP_Check_IP_Unit;

Procedure THostListWizard.HostListWizardOnSetupShow (Sender: TObject);
VAR S1:String;
Begin
     IF HostListEntryFlag Then
     Begin
          EditHostIp.Clear;
          EditHostName.Clear;
          EditHostAlias.Clear;
          EditHostComment.Clear;
     End else
     begin
          EditHostIp.Text:=DebugForm.LBHostIP.items[EntryIndex];
          EditHostName.text:=DebugForm.lbHostname.items[EntryIndex];
          EditHostAlias.text:=DebugForm.lbhostAlias.items[EntryIndex];
          EditHostComment.text:=DebugForm.lbHostComment.Items[EntryIndex];
     End;
     EditHostIP.Focus;
     S1:='Hostlist-Wizard';
     Caption:=GetNLSString(S1,'Caption');
     Info.Caption:=GetNlsString(S1,'Info');
     Label1.Caption:=GetNlsString(S1,'Label#1');
     Label2.Caption:=GetNlsString(S1,'Label#2');
     Label3.Caption:=GetNlsString(S1,'Label#3');
     Label4.Caption:=GetNlsString(S1,'Label#4');
     LabelFin1.Caption:=GetNlsString(S1,'LabelFin1');
     LabelFin2.Caption:=GetNlsString(S1,'LabelFin2');
     LabelStep1.Caption:=GetNlsString(S1,'LabelStep1');
     LabelStep2.Caption:=GetNlsString(S1,'LabelStep2');
     LabelStep3.Caption:=GetNlsString(S1,'LabelStep3');
     LabelStep4.Caption:=GetNlsString(S1,'LabelStep4');
     GroupBoxHostName.Caption:=GetNlsString(S1,'GroupBoxHostname');
     GroupBoxIP.Caption:=GetNlsString(S1,'GroupBoxIP');
     GroupBoxAliasName.Caption:=GetNlsString(S1,'GroupBoxAliasName');
     GroupBoxComment.Caption:=GetNlsString(S1,'GroupBoxComment');
     ButtonBack.Caption:=GetNlsString(S1,'ButtonBack');
     ButtonNext.Caption:=GetNlsString(S1,'ButtonNext');
     ButtonCancel.Caption:=GetNlsString(S1,'ButtonCancel');
     //ButtonHelp.Caption:=GetNlsString(S1,'ButtonHelp');
End;

Procedure THostListWizard.NoteBook1OnPageChanged (Sender: TObject);
Begin
    Case Notebook1.PageIndex of
    0:ButtonBack.Enabled:=FALSE;
    1:begin ButtonBack.Enabled:=True;EditHostname.Focus;End;
    2:Begin ButtonBack.Enabled:=TRUE;EditHostAlias.Focus;End;
    3:EditHostComment.focus;
    4:ButtonNext.Caption:=GetNlsString('Hostlist-Wizard','ButtonFinish');
    5:Begin
          IF HostListEntryFlag Then
          begin
               DebugForm.LBHostIP.items.add(EditHostIP.Text);
               DebugForm.lbHostname.items.add(EditHostName.text);
               DebugForm.lbhostAlias.items.add(EditHostAlias.text);
               DebugForm.lbHostComment.Items.add(EditHostComment.text);
          End else
          Begin
               DebugForm.LBHostIP.items[EntryIndex]:=EditHostIP.Text;
               DebugForm.lbHostname.items[EntryIndex]:=EditHostName.text;
               DebugForm.lbhostAlias.items[EntryIndex]:=EditHostAlias.text;
               DebugForm.lbHostComment.Items[EntryIndex]:=EditHostComment.text;
          End;

          DisMissDlg(CmOK);
      End;
    End;
End;

Procedure THostListWizard.ButtonBackOnClick (Sender: TObject);
Begin
  Notebook1.PageIndex:=Notebook1.PageIndex+-1;
End;

Procedure THostListWizard.ButtonNextOnClick (Sender: TObject);
Begin
  Case Notebook1.PageIndex of
  0:IF not ValidIPAdress(EditHostIP.text,ChkOpt_ZeroNotAllowed,'INVALID_IP_Address') Then Begin EditHostIP.Focus;Exit;End;
  1:IF Not ValidHostName(EditHostname.Text,'Invalid_Hostname') Then Begin EditHostname.Focus;Exit;End;
  End;
  Notebook1.PageIndex:=Notebook1.PageIndex+1;

End;

Initialization
  RegisterClasses ([THostListWizard, TNoteBook, TGroupBox, TLabel, TEdit, TButton,
    TImage]);
End.
