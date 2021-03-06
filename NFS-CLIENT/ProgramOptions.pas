Unit ProgramOptions;

Interface

Uses
  Classes, Forms, Graphics, TabCtrls, Buttons, StdCtrls, ExtCtrls,NFS_NLS_IniFileUnit,MYMessageBox,NFS_IniFiles,NFS_VAR_Unit,NFS_NLS_IniFileUnit,NFS_LanguageUnit,MyPMHelp,Dialogs;

Type
  TProgramSettings = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    OKButton: TButton;
    CancelButton: TButton;
    cbWarningStatus: TCheckBox;
    cbWarningNLOCK: TCheckBox;
    ListBox1: TListBox;
    ButtonHelp: TButton;
    cbConditionPortmap: TCheckBox;
    RadioGroupLanguage: TRadioGroup;
    Procedure ButtonHelpOnClick (Sender: TObject);
    Procedure RadioGroupLanguageOnClick (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure ProgramSettingsOnSetupShow (Sender: TObject);
    Procedure LanguageSettings;
  Private
    {Private Deklarationen hier einf�gen}
  Function GetIniLanguage:String;
  Public
    {�ffentliche Deklarationen hier einf�gen}
  End;

Var
  ProgramSettings: TProgramSettings;

Implementation

USES Sysutils,DOS;

//VAR NLSIni:TNewAscIIIniFile;

Procedure TProgramSettings.ButtonHelpOnClick (Sender: TObject);
Begin
     ViewHelp(TabbedNotebook1.PageIndex);
End;

Procedure TProgramSettings.LanguageSettings;
Begin
    Caption:=GetNLSString(Self.Name,'Caption');
    RadioGroupLanguage.Caption:=GetNLSString(Self.Name,'RadioGroupLanguage');
    OKButton.Caption:=GetNlsString(Self.Name,'OKButton');
    CancelButton.Caption:=GetNLSString(Self.Name,'CancelButton');
    ButtonHelp.Caption:=GetNLSString(Name,'HelpButton');
    TabbedNotebook1.Pages[0]:=GetNlsString(Name,'Tab0');
    TabbedNotebook1.Pages[1]:=GetNlsString(Name,'Tab1');
    TabbedNotebook1.Pages[2]:=GetNlsString(Name,'Tab2');
    cbWarningStatus.Caption:=GetNlsString(Name,'cbwarningStatus');
    cbWarningNLOCK.Caption:=GetNLSString(Name,'cbwarningNLOCK');
    cbConditionPortmap.Caption:=GetNlsString(Name,'cbConditionPortmap');
End;

Procedure TProgramSettings.RadioGroupLanguageOnClick (Sender: TObject);
Begin
    NLSIni.Create(Listbox1.Items[RadioGroupLanguage.ItemIndex]);
    LanguageSettings;
End;

Procedure TProgramSettings.OKButtonOnClick (Sender: TObject);
Begin
     OS2UserIniFile.WriteBool(UserSection,'cbWarningStatus',cbWarningStatus.checked);
     OS2UserIniFIle.WriteBool(UserSection,'cbWarningNLOCK',cbWarningNLOCK.checked);
     OS2UserIniFile.WriteString(UserSectionLang,'NFS_NLSFile',Listbox1.items[RadioGroupLanguage.ItemIndex]);
     OS2UserIniFile.WriteBool(UserSection,'cbConditionPortmap',cbConditionPortmap.checked);
End;

Function TProgramSettings.GetINILanguage:String;
VAR
   TMPIni:TNewAscIIIniFile;Return:String;
   l:Byte;

Begin
     For L:=0 to Listbox1.items.count-1 do
     Begin
          TMPIni.Create(Listbox1.Items[l]);
          IF TMPIni.ReadString('MAINFORM','Language',Return) Then
          Begin
               RadioGroupLanguage.Items.add(Return);
          End Else MyErrorBox('NLS Ini Error'+#13+Return);
     End;
     TMPIni.Destroy;
     RadioGroupLanguage.ItemIndex:=0;

End;

Procedure TProgramSettings.ProgramSettingsOnSetupShow (Sender: TObject);
VAR
   DirInfo:TSearchRec;
   RC:Longint;

Begin
     ListBox1.clear;
     RadioGroupLanguage.Items.clear;
     RC:=SysUtils.FIndfirst('NFS*.NLS',anyfile,DirInfo);
     While rc=0 do
     begin
          ListBox1.Items.add(DirInfo.Name);
          rc:=sysutils.FindNext(DIrInfo);
     ENd;
     GetINILanguage;
    cbWarningStatus.checked:=OS2UserIniFile.ReadBool(UserSection,'cbWarningStatus',FALSE);
     cbWarningNLOCK.checked:=OS2UserIniFIle.ReadBool(UserSection,'cbWarningNLOCK',FALSE);
     cbConditionPortmap.checked:=OS2UserIniFile.ReadBool(UserSection,'cbConditionPortmap',FALSE);
     RC:=ListBox1.Items.Indexof(OS2UserIniFile.ReadString(UserSectionLang,'NFS_NLSFile','ERR'));
     IF RC=-1 Then begin MyErrorBox('Unable to locate languagefilename in listbox !');halt;end;
     RadioGroupLanguage.ItemIndex:=rc;
     LanguageSettings;
End;

Procedure FirstTime;
VAR PMCode:String;
Begin
     // Ermittle PM National Code
     PMcode:=OS2UserIniFile.ReadString('PM_National','iCountry','-99');
     IF (PMCode='49') or (PMCode='43') Then
     Begin
         OS2UserIniFile.WriteString(UserSectionLang,'NFS_NLSFile','NFS_GER.NLS');
     End else OS2UserIniFile.WriteString(UserSectionLang,'NFS_NLSFile','NFS_ENG.NLS');
     IF Paramstr(1)='\DEBUG' Then ShowMessage('DEBUG: INI Eintr�ge geschrieben');
End;

Initialization
  OS2UserIniFile.Create;
  IF OS2UserIniFile.ReadString(UserSectionLang,'NFS_NLSFile','ERR')='ERR' Then begin FirstTime;End;

  RegisterClasses ([TProgramSettings, TTabbedNotebook, TButton, TCheckBox, TListBox,
    TRadioGroup]);
End.
