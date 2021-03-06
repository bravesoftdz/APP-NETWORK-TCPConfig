{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 �     Utility Unit f�r NFS Projekt                                         �
 �                                                                          �
 �     Version 1 am 19.06.2006 - zul�st ge�nderd  17.07.2006                �
 �                                                                          �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}

Unit NFS_UtiltyUnit;
Interface
USES UString;
         Procedure MyKillProcess(Pid:String);
         Function SpaceCut(aString:String):String;
         Function ToInt(S:String):LongInt; {Convert a String into a integer value}
         Function Prozent(CONST Current:Longint;CONST Maximum:Longint):Integer;
         Function FindWordinStri(StringToFind:String;StringToSearch:String):integer;
         Procedure GetFreeDrives;
         Function DriveExists(Drive:Char):Boolean;
         Function QueryBootDrive: char;
         Function FileExistinPath(VAR aFilename:String):Boolean;
         Function AdvancedOptionString:String;
         Function MCStri2String(MCString:String):String;
         Procedure RenameNFSIni;
         Function FileCopy(Source,Destination:CString):Boolean;
         Function FileSplit(S:String;Mode:Byte):String;
         Function FindInStringList(SearchStri:String;Items:TStrings):Longint;
         Procedure Log2StriList(VAR aStringlist:TStringlist;FileName:String);
         Function MultiColumStringToString(MCStr:String;Col:Byte):String;

Implementation
USES BSEDOS,CLASSES,Sysutils,NFS_Var_Unit,dialogs,NFS_IniFiles,MyMessageBox,DOS,NFS_Toolbox,NFS_STDIOError,Sysutils,NFS_LanguageUnit;
Imports
Function GetFSInfo(aDrive:String;VAR FSName:String;VAR USerInfo:String):Boolean; 'TCPLIB' NAME 'GetFSInfo';
Function DLLResultStr:String; 'TCPLIB' NAME 'DllReturnString';
End;

VAR
   NFSFile:DataFile;


              Function DriveExists(Drive:Char):Boolean;
              VAR DUmmy:String;
              Begin
                   Result:=GetFSInfo(Drive+':',Dummy,Dummy);
                   Dummy:=DLLResultStr;
                   {M�gliche Fehlercode :
                   0         No_Error
                   15        Error_Invalid_Drive
                   111       Error_Buffer_Overflow
                   124       Error_Invalid_Level
                   259       Error_No_More_Items
                   }
              End;

              Function SpaceCut(aString:String):String;
              // Schneided den �bergebenen String ab dem 1.lerrzeichen ab, und liefert ihn zur�ck;
              VAR Posi:Byte;
              Begin
                   Posi:=POS(' ',aString);
                   IF Posi=0 Then
                                 Begin
                                      Result:=aString;exit; // Kein Leerzeichen im String
                                 End
                                    else
                                 Begin
                                      Result:=Copy(aString,1,POSI);
                                 End;
              End;


Function ToInt(S:String):LongInt; {Convert a String into a integer value}
 VAR E1:Integer;L:Longint;
   Begin
        VAL(S,L,E1);IF E1<>0 Then
        Begin
             //ErrorBox('Umwandlungs Fehler "ToLongint" bei String '+S+' bei Pos : '+ToStr(E1));
             L:=-32767
             End;
        Result:=L;
   End;

Function Prozent(CONST Current:Longint;CONST Maximum:Longint):Integer;
VAR Proz_Summe:Integer;
begin
     Proz_Summe:=Current*100 div Maximum;
     IF Proz_Summe<0 then Proz_Summe:=0;
     Prozent:=Proz_Summe;
End;


Procedure GetFreeDrives;
VAR
   Drives:Longint;
   DriveChar:Char;
   T:Byte;
   RC:Longint; {zwecks Debug}

Begin

      Drives:=GetPhysicalDrives;
      Try
         FreeDriveList.Clear;
         Except ErrorBox('Exception bei Versuch "FreeDriveList.Clear" aufzurufen !');Halt;
      End;

      Try
         NFSDriveList.Clear;
         Except ErrorBox('Exception bei Versuch "NFSDriveList.Clear" aufzurufen !');Halt;
      End;

      // 1. Schleife : feststellen welche Laufwerke vorhanden sind
        For t:=0 To 25 Do
        Begin 
                If Drives And (1 Shl t)<>0 Then 
                                                Begin 
                                                      DriveCHar:=chr(t+65);
                                                      TRY
                                                      NFSDriveList.add(drivechar+':');
                                                      Except ErrorBox('Exception bei Versuch "NFSDriveList.add" aufzurufen');Halt;
                                                      End;
                                                End;
        End;

        // 2.Schleife : Neue Laufwerke erstellen, vorhandene nicht �bernehmen
        For T:=0 to 25 do
        Begin
                DriveCHar:=Chr(65+t);
                rc:=NFSDriveList.Indexof(DriveCHar+':');
                IF RC=-1 Then Begin
                                   TRY
                                   FreeDriveList.add(DriveChar+':');
                                   Except ErrorBox('Exception bei Versuch "FreeDriveList.add" aufzurufen !');Halt;
                                   End;
                             End;
        End;



End;

Function FindWordinStri(StringToFind:String;StringToSearch:String):integer;
{Version 1 15.10.2005 - Update damit "TFTPD" und "FTPD" nicht gleich sind am 24.11.2005

 Sucht nach dem vorkommen eines Strings innerhalb eines andern strings
 Gross und Kleinschreibung wird ignoriert (Kein unterscheid)
 R�ckgabe  Wert ist die Position an der das Wort im String "StringToFInd" (Suchstring) gefunden wurde.
 Wurde der Wert/String nicht gefunden, wird -1 Zur�ckgeliefert.
 }

VAR Found:Boolean;
          DebugStr:String;
          Loop:Byte;
      Begin
           Found:=FALSE;DebugStr:='';

          For Loop:=1 to length(StringToSearch) do
              Begin
                   DebugStr:=Copy(StringToSearch,loop,length(StringToFind));
                 IF UpperCase(DebugStr)=Uppercase(StringToFind) Then
                        Begin
                                //IF Upcase(StringToSearch[loop-1])='T' Then Begin result:=-1;exit;END;
                                Found:=TRUE;Break;
                        End;
              End;
              IF Found Then Result:=Loop else Result:=-1;
      End;

Function QueryBootDrive: char;
var
  buffer: longword;
begin
  DosQuerySysInfo( QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,buffer,sizeof( buffer ) );
  Result := chr( ord( 'A' ) + buffer - 1 );
end;

Function FileExistinPath(VAR aFilename:String):Boolean;
VAR
   RC:LongInt;
   S:String;
   ResultBuffer:CString;
   ENVVarName:Cstring;
   Filename:CString;

Begin
          ENVVarName:='PATH';
          FileName:=aFilename;
          rc:=DosSearchPath(SEARCH_CUR_DIRECTORY OR   /* Search control
                                                        vector */
                           SEARCH_ENVIRONMENT,
                           ENVVARNAME,              /* Search path reference
                                                       string */
                           FILENAME,                /* File name string */
                           ResultBuffer,            /* Search result
                                                            (returned) */
                           sizeof(ResultBuffer));    /* Length of search
                                                       result */

         IF rc=0 THEN
         BEGIN
              s:=ResultBuffer;aFilename:=S;

              //ShowMessage('Found desired file -- '+#13+S);Result:=True;
              Result:=True;
         END else
         Begin
              //ShowMessage('Nicht gefunden');Result:=FALSE;
               Result:=FALSE;
         End;
End;

Function AdvancedOptionString:String;
VAR Output:String;Value:Integer;TmpStr:String;
Begin
     IF Paramstr(1)<>'\ADVANCED' then exit; // Wenn kein Erweitertet Modus angeben wurde, paramter unwirksam machen
     {Es gelten die standart paramater aus der mount.ini (sofern vorhanden). Ist die mount.ini nicht vorhande, weren die paramter von mount.exe selbst gesetzt}
     Output:='';
     // Attribute Cache
    // IF OS2UserIniFIle.ReadBool(UserSection,'cbAttributeCache',FALSE) Then
     Begin
          IF OS2UserIniFIle.ReadBool(UserSection,'rbAttributeCacheS',FALSE) Then Output:=Output+' -acS';
          IF OS2UserIniFIle.ReadBool(UserSection,'rbAttributeCacheM',FALSE) Then Output:=Output+' -acM';
          IF OS2UserIniFIle.ReadBool(UserSection,'rbAttributeCacheL',FALSE) Then Output:=Output+' -acL';
     End;

     // Data Cache
     //IF OS2UserIniFIle.ReadBool(UserSection,'cbFileCache',FALSE) Then
     Begin
          IF OS2UserIniFIle.ReadBool(UserSection,'rbFileCacheS',FALSE) Then Output:=Output+' -dcS';
          IF OS2UserIniFIle.ReadBool(UserSection,'rbFileCacheM',FALSE) Then Output:=Output+' -dcM';
          IF OS2UserIniFIle.ReadBool(UserSection,'rbFileCacheL',FALSE) Then Output:=Output+' -dcL';
     End;

     //IF OS2UserIniFIle.ReadBool(UserSection,'cbDataBuffer',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'SpinTransmitBuffer',-99);
          IF Value<>-99 Then Output:=output+' -b'+ToStr(Value);
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbAttributeTimeout',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'spinAttributeTimeout',-99);
          IF Value<>-99 Then Output:=output+' -acto'+ToStr(Value);
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbFileCacheTimeout',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'SpinFileCacheTimeout',-99);
          IF Value<>-99 Then Output:=output+' -dcto'+ToStr(Value);
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbRPCTimeLimit',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'SpinRPCTimeout',-99);
          IF Value<>-99 Then Output:=output+' -t'+ToStr(Value);
     End;

     IF OS2UserIniFile.ReadBool(UserSection,'cbLockManager',FALSE) Then
     Begin
          Output:=output+' -son';
     End else Output:=output+' -soff';


     IF OS2UserIniFile.ReadBool(UserSection,'cbArchive',FALSE) Then
     Begin
          Output:=output+' -a';
     End;

     IF OS2UserIniFile.ReadBool(UserSection,'cbCRLF1',FALSE) Then
     Begin
          Output:=output+' -c';
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbUpperLowercase',FALSE) Then
     IF AdressBookData.cbCaseSensetiv Then
     Begin
          Output:=output+' -cs';
     End;

     IF OS2UserIniFile.ReadBool(UserSection,'cbtrace',FALSE) Then
     Begin
          Output:=output+' -tr';
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbRPCretry',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'spinRPCretry',-99);
          IF Value<>-99 Then Output:=output+' -rt'+ToStr(Value);
     End;

     //IF OS2UserIniFile.ReadBool(UserSection,'cbBIODSread',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'SPINBIODSRead',-99);
          IF Value<>-99 Then Output:=output+' -r'+ToStr(Value);
     End;

    // IF OS2UserIniFile.ReadBool(UserSection,'cbBIODSwrite',FALSE) Then
     Begin
          Value:=OS2UserIniFile.ReadInteger(UserSection,'SPINBIODSWrite',-99);
          IF Value<>-99 Then Output:=output+' -w'+ToStr(Value);
     End;
     IF output<>'' Then Result:=output+' ' else Result:=output;
End;

Function MCStri2String(MCString:String):String;
// Konvertiert einen Mehrfach Zeilen String in einen String
VAR Posi:Byte;
Begin
     Posi:=POS('|',MCString);
     IF Posi>0 Then
     Begin
          Result:=Copy(MCString,1,posi-1);
     End;
End;

Function SpaceCutV2(S:STring):String;
VAR 
        l:String;
        i:Byte;
Begin
        L:='';
        For i:=1 to length(S) do
        Begin
                IF S[i]<>' ' Then L:=L+S[i];        
        End;
        Result:=L;
End;


FUNCTION Power(X,Y:Word):LongInt;

VAR Temp,Teller : LongInt;

BEGIN
  TEMP:=1;
  FOR Teller:=1 TO Y DO TEMP:=TEMP*X;
  Power:=Temp;
END; { Power }

FUNCTION Hex2Dec(Hex:STRING):LongInt;

VAR   T1,T2,Dec   :       LongInt;
      Error       :       Boolean;

BEGIN
  Error:=False;
  T1:=0;T2:=0;DEC:=0;
  FOR T1:=1 TO LENGTH(Hex) DO
  BEGIN
   T2:=Length(Hex)-T1;
   CASE Hex[T1] OF
   '0'  : DEC:=DEC+0;
   '1'  : DEC:=DEC+Power(16,T2);
   '2'  : DEC:=DEC+2*Power(16,T2);
   '3'  : DEC:=DEC+3*Power(16,T2);
   '4'  : DEC:=DEC+4*Power(16,T2);
   '5'  : DEC:=DEC+5*Power(16,T2);
   '6'  : DEC:=DEC+6*Power(16,T2);
   '7'  : DEC:=DEC+7*Power(16,T2);
   '8'  : DEC:=DEC+8*Power(16,T2);
   '9'  : DEC:=DEC+9*Power(16,T2);
   'A','a' : DEC:=DEC+10*Power(16,T2);
   'B','b' : DEC:=DEC+11*Power(16,T2);
   'C','c' : DEC:=DEC+12*Power(16,T2);
   'D','d' : DEC:=DEC+13*Power(16,T2);
   'E','e' : DEC:=DEC+14*Power(16,T2);
   'F','f' : DEC:=DEC+15*Power(16,T2);
   ELSE Error:=True;
   END;
  END;
  Hex2Dec:=Dec;
  IF Error THEN Hex2Dec:=0;
END; { Hex2Dec }

Procedure MyKillProcess(Pid:String);
VAR DOSError:Longint;PID2:Longint;
Begin
PID2:=Hex2Dec(SPaceCutV2(PID));
DosError:=DosKillProcess(1,PID2);
IF DOsError<>0 Then MYErrorBox('failed to kill PID '+ToStr(PID2)+#13+ToStr(DosError));
End;

Procedure RenameNFSINI;
Begin
     {
     INI (sofern vorhanden) nur im Advanced Mode umbenennen, da eine vorhandene INI sonnst bei mount.exe einen
     MIX aus vom Programm angegebenen paramtern sowie denen aus der INI erzeugt
     Z.B. Trace ist im Programm auf aus, in der INI aber auf An, Trace w�rde trotzdem durchgef�hrt werden
     }
     IF Paramstr(1)<>'\ADVANCED' Then exit;

     IF FileExists(GetEnv('ETC')+'\MOUNT.INI') Then
     Begin
          IF RenameFile( GETEnv('ETC')+'\MOUNT.INI',GetEnv('ETC')+'\MOUNT.OLD' ) then exit else MyErrorBox('Rename Error : MOUNT.INI -> MOUNT.OLD');

     End;

     IF FileExists(GetEnv('ETC')+'\MOUNT.OLD') Then
     Begin
          IF RenameFile( GETEnv('ETC')+'\MOUNT.OLD',GetEnv('ETC')+'\MOUNT.INI' ) then exit else MyErrorBox('Rename Error : MOUNT.OLD -> MOUNT.INI');
     End;
End;

Function FileSplit(S:String;Mode:Byte):String;
var dirstr,namestr,extstr:String;
{
MODE Schalter : 1=Nur Verzeichniss Name wird zur�cggeliefert
                2=Nur Name+Extension des Dateinamens wird zur�ckgelifert
                3=Nur die Extension
                4=Nur den Dateinamen
}

begin
     Fsplit(S,dirstr,namestr,extstr);
     IF length(dirstr)=3 Then DirStr:=DirStr+'\';
     setlength(dirstr,length(dirstr)-1);
     Case mode of
     1:Result:=dirStr;
     2:Result:=NameStr+ExtStr;
     3:Begin Result:=UpperCase(ExtStr);End;
     4:Result:=NameStr;
     End;
End;

Function FileCopy(Source,Destination:CString):Boolean;
VAR
   OptMode,RC:Longint;
Begin
     OptMode:=dcpy_Existing;
     RC:=DOSCopy(Source,Destination,OptMode);
     IF RC<>0 Then
     Begin
          DosCopyError(RC,Source,'CPY_FAILED');Result:=FALSE;Exit;
     End;
     Result:=TRUE;
End;

Function FindInStringList(SearchStri:String;Items:TStrings):Longint;
// Sucht nach dem ersten eines Strings in einer Stringlist, R�ckgabe =-1 wenn nicht gefunden, ansonnsten die Position
// Gro� und Kleinschreibung wird Ignoriert
VAR 
        TT:Longint;
        rc:Longint;
Begin
        For TT:=0 to Items.Count-1 do
        Begin
                TRY
                rc:=FindWordInStri(SearchStri,Items[TT]);IF rc<>-1 Then Begin Result:=TT;Exit;End;
                EXCEPT
                ExceptionBox('Fehler in Procedure  "FindInStringList" bei Zugriff auf "Item" Array');HAlt;
                End;
        End;
        Result:=-1;
End;

Procedure Log2StriList(VAR aStringlist:TStringlist;FileName:String);
Begin
    TRY
    aStringlist.loadFromFile(FileName);
    EXCEPT Begin MyErrorBox(GetNlsString('ERRORS','RPCInfo_Failed'));Exit;End;
    End;
    IF not DeleteFile(FileName) Then MyErrorBox('LOG Datei nicht l�schbar !');
End;

Function MultiColumStringToString(MCStr:String;Col:Byte):String;
VAR 
        Counter:Byte;
        WorkStr:String;
        ColumCount:ShortInt;
        OutputStr:String;
Begin
        WorkStr:='|'+MCStr+'|';ColumCount:=-1;OutputStr:='';
        For Counter:=1 to length(WorkStr) do
        Begin
                IF WorkStr[Counter]='|' Then inc(columCount);
                IF ColumCount=Col Then 
                Begin 
                        REPEAT
                                Inc(Counter);
                                OutPutStr:=OutPutStr+WorkStr[Counter];
                        Until WorkStr[Counter]='|';
                        Delete(OutputStr,length(outputStr),1);
                        Result:=OutputStr;
                        exit;
                End;
        End;
        ErrorBox('** Fehler in Funktion MultiColumStringToString (Unit NFS_Utilits) !!  Angeforderte Zeile ( '+ToStr(COL)+' ) wurde nicht gefunden bzw ist nicht vorhanden !');
ENd;



Begin
     PathRec.BootDrive:=QueryBootDrive;
End.
