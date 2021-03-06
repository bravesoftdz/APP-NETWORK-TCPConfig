UNIT TCP_ConfigSysAdd;
INTERFACE
USES DOS,SYSUTILS,Classes,Dialogs,TCP_LanguageUnit,MyMessageBox,TCP_IniFiles,TCP_VAR_Unit,TCPUtilityUnit,BSEDOS,OS2Def,TCP_STDIOError,ustring;

CONST MAXLines=700;
TYPE
        TLongStringList=Class
        PRIVATE
       // Items : Array[0..MaxLines] of AnsiString;
        Items2: Array[0..MaxLines] of AnsiString;
        Amount :Longint;
        FSearch:Boolean;
        StartSearch:Longint;
        PUBLIC
        Items : Array[0..MaxLines] of AnsiString;
        CONSTRUCTOR Create;VIRTUAL;
        Procedure Clear;
        Procedure Destroy;VIRTUAL;
        Procedure Add(Item:AnsiString);
        Procedure Delete(Index:Longint);
        Procedure Insert(Index:Longint;aString:AnsiString);
        Procedure Insert2(Index:Longint;aString:TStringList);
        Function Indexof(Item:String):Longint;
        Property count:Longint read Amount;
        Property FragMentSearch:Boolean read FSearch write FSearch;
        CompStr:String;
        ENd;

        TCOnfigSysFile=Class
        Private
        CFG_Text :AnsiString;
        CFG_FileRH :Longint;
        CFG_FileW  :Text;
        Procedure SaveFileLines(FromLine,ToLine:Longint);
        PUBLIC
        IOError  :Longint;
        CompleteStr:String;
        CONSTRUCTOR Create;VIRTUAL;
        CFG_Items:TLongStringList;
        Procedure DESTROY;VIRTUAL;
        Function  FindEntry(S:String):Longint;
        Procedure InsertLine(Position:Longint;Line:TStringList);
        Procedure AddLine(NewValue:String);
        Procedure Backup;
        Function  SaveFile:Boolean;
        Procedure DeleteLines(Line:TStringList);
        Procedure DeleteLine(LineNumber:Longint);
        Procedure ReplaceLine(LineNum:Longint;NewValue:String);
        End;

        TAutoExecFile=Class(TConfigSysFile)
        Constructor Create; VIRTUAL;
        Function  SaveFile:Boolean; VIRTUAL;
        End;

 Function GetEnvFromConfigSys(ENVString:String):String;
 Function GetEnvFromAutoExec(ENVString:String):String;

IMPLEMENTATION


{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 �     This Section Read and Write Function Repleacement                    �
 �     since Sibyl can not write / read AnsiStrings from TextFiles          �
 �     Created 21.08.04                                                     �
 �     Last modified 21.08.04                                               �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}

function MyRead( F: HFile; Buffer: pointer; Length: LongWord ): boolean;
var
  Actual: ULong;
begin
  Result:= DosRead( F, Buffer^, Length, Actual ) = 0;
  if Actual = 0 then
    Result:= false;
end;

function MyReadLn( F: HFile; Var S: AnsiString ): boolean;
var
  C: Char;
  NewFilePtr: ULONG;
begin
  Result:= MyRead( F, Addr( C ), 1 );
  while ( C <> #13 )
        and Result do
  begin
    S:= S + C;
    Result:= MyRead( F, Addr( C ), 1 );
  end;
  Result:= MyRead( F, Addr( C ), 1 );
  if C <> #10 then
  begin
    DosSetFilePtr( F, -1, FILE_CURRENT, NewFilePtr );
  end;
end;

Procedure MyWriteln(VAR F:Text;VAR aAnsiString:AnsiString);
VAR
   L:Longint;
   Hex:Longint;
Begin
      IF Length(aAnsiString)=1 Then
 begin
      Hex:=ORD(aAnsiString[1]);IF Hex=26 Then exit;
 End;
     For L:=1 to Length(aAnsiString) do
     Begin
          Write(F,aAnsiString[l]);
     End;
     Write(F,chr(13));
     Write(F,Chr(10));
End;

{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 �     This Section TLongStringList - created 14.08.04                      �
 �                                                                          �
 �     Last Modified 13.12.05                                               �
 �                                                                          �
 �    13.12.05 Variable StartSearch bei Funktion Indexof hinzugef�gt        �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}



        CONSTRUCTOR TLongStringList.Create;
        Begin
                Amount:=0;
                StartSearch:=0;
                FSearch:=FALSE;

        End;

        Procedure TLongStringList.Destroy;
        Begin
                Amount:=-9999
        End;

  Procedure TLongStringList.Clear;
  VAR Test:Longint;
  Begin
       For Test:=0 to Amount do
       Begin
            Items2[Test]:='';
       End;
  End;

  Procedure TLongSTringList.Insert(INDEX:Longint;aString:AnsiString);
        VAR
                loop:Longint;
                aB:AnsiString;
        Begin
                IF Index>Amount Then Raise Exception.Create('TLongStringList.Insert : value of "Index" ('+ToStr(Index)+') exceeds "item" amount ('+Tostr(Amount)+')');

                For Loop:=0 To Index-1 do
                Begin
                        Items2[Loop]:='';
                        Items2[Loop]:=Items[loop];
                End;
                Items2[Loop]:=aString;
                For Loop:=Index To Amount-1 do
                Begin
                        Items2[Loop+1]:=Items[loop];
                End;
                system.move(items2,items,sizeof(items));
                Inc(Amount);
        End;

        Procedure TLongStringList.Insert2(Index:Longint;aString:TStringList);
        VAR
                Loop:Longint;
                STrCounter:Byte;

        Begin
                IF Index>Amount Then Raise Exception.Create('TLongStringList.Insert2 : value of "Index" ('+ToStr(Index)+') exceeds "item" amount ('+ToStr(Amount)+')');
                For Loop:=0 to Index-1 do
                Begin
                        Items2[Loop]:=Items[loop];
                End;

                For StrCounter:=0 TO aString.count-1 do
                begin
                     IF CompStr='' Then Items2[Index+StrCounter]:=aString.Strings[StrCounter]
                                       else Items2[Index+StrCounter]:=CompStr+aString[StrCounter];
                End;

                For loop:=Index to Amount-1 do
                Begin
                        //ShowMessage(ToStr(loop)+#13+tostr(Amount));
                        Items2[Loop+StrCounter]:=Items[loop];
                ENd;
                system.move(items2,items,sizeof(items));
                Amount:=Amount+StrCounter;
        End;
        Procedure TLongStringList.Delete(Index:Longint);
        VAR
                Loop:Byte;

        Begin
                IF Index>Amount Then Raise Exception.Create('TLongStringList.Delete : value of "Index" ('+ToStr(Index)+') exceeds "item" amount ('+ToStr(Amount)+')');
                For Loop:=0 to Index-1 do
                Begin
                        Items2[Loop]:=Items[loop];
                End;
                For loop:=Index to Amount-1 do
                Begin
                        Items2[Loop]:=Items[loop+1];
                ENd;
                system.move(items2,items,sizeof(items));
                dec(Amount);
        End;

        Function TLongStringList.Indexof(Item:String):Longint;
        VAR
           loop:Longint;
           H:AnsiString;
        Begin
                For Loop:=StartSearch to Amount do
                Begin
                        IF not FSearch Then
                        Begin
                                // Full Search
                                IF uppercase(Items[loop])=uppercase(Item) Then Begin StartSearch:=Loop;result:=Loop;exit;End;
                         End else
                         Begin
                                H:=COpy(Items[loop],1,length(Item));
                                H:=Uppercase(H);
                                IF H=Uppercase(item) Then begin StartSearch:=Loop+1;Result:=loop;Exit;End;
                         End;
                End;
                Result:=-1;
        End;



        Procedure TLongStringList.Add(Item:AnsiString);
        Begin
                IF Amount+1>MaxLines Then Begin ExceptionBox('BUG ! TLongStringList.Add : Maximum amount ('+ToStr(MaxLines)+') of storeable items exceeded !');Halt;ENd;
                Items[Amount]:=Item;Inc(Amount);
        End;



{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 �     This Section TConfigSysFile  - created 14.08.04                      �
 �                                                                          �
 �     Last Modified for My Read/write 21.08.08.04                          �
 �                                                                          �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}



  Procedure TConfigSysFile.SaveFileLines(FromLine,ToLine:Longint);
  VAR Loop:Longint;
      Bug:ANsiString;
  Begin
       Bug:=CFG_items.items[169];
       For Loop:=FromLine To TOLine do
       Begin
            //CFG_Text:=CFG_Items.items[Loop];
            Try
            MyWriteln(CFG_FileW,CFG_items.items[loop]);
            Except Raise Exception.create('BUG in Unit TCP_ConfigSysAdd ! Access Vialotion in CFG_ITEMS.ITEMS'+#13+'Wert von "loop" : '+ToStr(loop));
            End;
            //MyWriteln(CFG_FileWH,CFG_items.items[loop]);
       End;
  End;

  Function TConfigSysFile.SaveFile:Boolean;
  Begin
       Result:=FALSE;
       Assign(CFG_FileW,QueryBootDrive+':\CONFIG.SYS'); // Create a new file
       ReWrite(CFG_FileW);IOError:=IoResult;
       IF IOError<>0 Then
       Begin
            // IO Error appeaert
            MyErrorBox(GetNlsString('ERRORS','CfgSysfailedCreate')+#13+SysErrorMessage(IOError)+'Path :'+QueryBootDrive+':\CONFIG.SYS');
            Exit;
       End;

       SaveFileLines(0,CFG_Items.count-1);

       Close(CFG_FILEW);

       Result:=TRUE;

   End;


        Procedure TConfigSysFile.Backup;
        VAR
           Option,RC:LongWord;
           Source,Destination:CString;

        Begin
              // Copy Config.Sys to Backup folder changed 11.10.2005
                  //ShowMessage('COnfig.sys Backup');
                   Source:=PathRec.BootDrive+':\CONFIG.SYS';
                   Destination:=BackupFolder;
                   Option:=DCPY_Existing or DCPY_FAILEAS;

                   Rc:=DosCopy(SOurce,Destination,Option);
                   IF Rc<>0 Then Begin DosCopyError(RC,'CONFIG.SYS','CPY_CFGSYS_Failed');Exit;End;
        End;

        CONSTRUCTOR TConfigSysFile.Create;
        VAR RC:Boolean;bbb:String;
        Begin
                CFG_FileRH:=FileOpen(QueryBootDrive+':\CONFIG.SYS',FMINPUT);
                IF CFG_FileRH<0 Then
                Begin
                     IOError:=-CFG_FileRH;
                     MyErrorBox('Unable to open CONFIG.SYS file on drive : '+QueryBootDrive+#13+SysErrorMessage(IOERROR));
                     Halt;
                End;
               CFG_ITEMS:=TLongStringList.Create;
               REPEAT
                        CFG_Text:='';
                        RC:=MyReadln(Cfg_FileRH,CFG_Text);CFG_Items.Add(Cfg_Text)

               Until RC=FALSE;
               CFG_Items.Amount:=CFG_Items.Amount-1;
        CompleteStr:='';
        FileClose(CFG_FIleRH);
        End;


        Function TConfigSysFile.FindEntry(S:String):Longint;
        Begin
                CFG_Items.FragMentSearch:=TRUE;
                Result:=CFG_Items.Indexof(s);
        End;

        Procedure TCOnfigSysFile.InsertLine(Position:Longint;Line:TStringList);
        VAr
           AddLoop:Longint;
           CFG_READ_Handle:Longint;
           CFG_Write_Handle:Text;
           LineCounter:Longint;
           CFGSysStr:AnsiString;
           RC:Boolean;
        Begin
                      CFG_Items.CompStr:=CompleteStr;
                      CFG_Items.Insert2(Position,Line);

                // Sibyl always creats a out of Memory Exception , Virtual Pascal works fine with this
                // Sibyl does not like the the isnert routine called again
                // Workaround for Sibyl - use Insert2 procedure instead of insert1
                {LineCounter:=-1;
                CFG_READ_Handle:=FileOpen(getbootdrive+':\CONFIG.SYS',FMINPUT);
                Assign(CFG_WRITE_HANDLE,GetBootDrive+':\CONFIG.NEW');ReWrite(CFG_Write_Handle);
                REPEAT
                      MyReadln(CFG_Read_Handle,CFGSysStr);
                      MyWriteln(CFG_Write_Handle,CFGSysStr);
                      Inc(LineCounter);
                UNTIL LineCounter=Position-1;
                For AddLoop:=0 To Line.Count-1 do
                Begin
                     CfgSysStr:=Line.Strings[AddLoop];
                     MyWriteln(CFG_Write_Handle,CfgSysStr);
                End;
                REPEAT
                      CFGSysStr:='';
                      RC:=MyReadLn(CFG_Read_Handle,CFGSysStr);
                      IF RC Then MyWriteln(CFG_Write_Handle,CFGSysStr);
                UNTIL RC=FALSE;
                FileClose(CFG_Read_Handle);
                Close(CFG_Write_Handle);}
        End;

        Procedure TCOnfigSysFile.DeleteLines(Line:TStringList);
        VAR
                DelLoop:Longint;
                Index:Longint;
        Begin
                For DelLoop:=0 to Line.count-1 do
                Begin
                        Index:=FindEntry(Line.Strings[DelLoop]);
                        IF Index<>-1 Then
                        Begin
                                CFG_Items.Delete(Index);
                        End;
                End;
        End;


        Procedure TConfigSysFile.ReplaceLine(LineNum:Longint;NewValue:String);
        Begin
             cfg_items.Items[LineNum]:=NewValue;
        End;

        Procedure TConfigSysFile.Destroy;
        Begin

                CFG_Items.Destroy;
        End;

        Procedure TConfigSysFile.addLine(NewValue:String);
        Begin
             CFG_Items.add(NewValue);
        End;

        Procedure TConfigSysFile.DeleteLine(LineNumber:Longint);
        Begin
             CFG_Items.Delete(LineNumber);
        End;

 Function GetEnvFromConfigSys(ENVString:String):String;
 // Input : SET HOSTNAME -> OUTPUT = MyHostname
 VAR
    CFGSysFile:TConfigSysFile;
    Index:Longint;
 Begin
      CfgSysFile.Create;
      Index:=CfgSysFile.FindEntry('SET '+ENVString);
      If Index<>-1 Then
      Begin
           TRY
           Result:=GetEnvString(CfgSysFile.CFG_Items.items[Index]);
           EXCEPT ExceptionBox('Fehler bei Zugriff auf CFGSYSFile.CFG_ITEMS'+#13+'Fehler in TCP_ConfigSysAdd , Funktion GetEnvFromConfigSys');Halt;
           End;
       End else
       Result:='';
       CFGSysFile.Destroy;

 End;


Constructor TAutoExecFile.Create;
VAR RC:Boolean;bbb:String;
Begin
                CFG_FileRH:=FileOpen(QueryBootDrive+':\AUTOEXEC.BAT',FMINPUT);
                IF CFG_FileRH<0 Then
                Begin
                     IOError:=-CFG_FileRH;
                     MyErrorBox('Unable to open AUTOEXEC.BAT file on drive : '+QueryBootDrive+#13+SysErrorMessage(IOERROR));
                     Halt;
                End;
               CFG_ITEMS:=TLongStringList.Create;
               REPEAT
                        CFG_Text:='';
                        RC:=MyReadln(Cfg_FileRH,CFG_Text);CFG_Items.Add(Cfg_Text)

               Until RC=FALSE;
               CFG_Items.Amount:=CFG_Items.Amount-1;
        CompleteStr:='';
        FileClose(CFG_FIleRH);
        End;


Function TAutoExecFile.SaveFile:Boolean;
  Begin
       Result:=FALSE;
       Assign(CFG_FileW,PathRec.BootDrive+':\AUTOEXEC.BAT'); // Create a new file
       ReWrite(CFG_FileW);IOError:=IoResult;
       IF IOError<>0 Then
       Begin
            // IO Error appeaert
            MyErrorBox(GetNlsString('ERRORS','CfgSysfailedCreate')+#13+SysErrorMessage(IOError)+'Path :'+PathRec.BootDrive+':\AUTOEXEC.BAT');
            Exit;
       End;

       SaveFileLines(0,CFG_Items.count-1);

       Close(CFG_FILEW);

       Result:=TRUE;
   End;

Function GetEnvFromAutoExec(ENVString:String):String;
 // Input : SET ETC -> OUTPUT = C:\TCPIP\DOS\ETC
 VAR
    AutoExecFile:TAutoexecFile;
    Index:Longint;
 Begin
      AutoExecFile.Create;
      Index:=AutoExecFile.FindEntry('SET '+ENVString);
      If Index<>-1 Then
      Begin
           TRY
           Result:=GetEnvString(AutoExecFIle.CFG_Items.items[Index]);
           EXCEPT ExceptionBox('Fehler bei Zugriff auf Autoexec.CFG_ITEMS'+#13+'Fehler in TCP_ConfigSysAdd , Funktion GetEnvFromConfigSys');Halt;
           End;
       End else
       Result:='';
       AutoExecFile.Destroy;

 End;

End.
