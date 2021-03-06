Unit TCP_Unit_QueryEntrys;

Interface
         //Procedure GetIfConfigParam;
         //Procedure QueryDHCP;
         //Procedure QueryIPgate;
         Procedure QueryHOSTIP;
         Procedure QueryHOSTName;
         Procedure QueryHOSTAlias;
         Procedure QueryHOSTComment;
         Procedure QueryDomains;
         Procedure QuerySockDomains;
         Procedure QuerySocksDNS;
         Procedure QuerySocksDirect;
         Procedure QuerySocksServer;
         Procedure QueryNetworkPrinter;
         Procedure RemoveOS2SYSEntry(LastValue:Byte);
         Procedure AddOS2SYSEntry(NumbersToAdd:Byte);
         Procedure QueryNFS;
         Procedure QueryServerUsers;
         Procedure QueryServerComments;
         Procedure QueryServerPassword;
         Procedure QueryServerHomeDir;
         Procedure QueryServerNFSGroupID;
         Procedure QueryServerNFSUserID;
         Procedure ReadHostFile;
         Procedure QueryServerTelnetShell;
         Procedure QueryServerServices;
         Function ActiveInterface(InterfaceNum:byte):Boolean;
         Function QueryAmountInterfaces:Byte;
         Procedure QueryInterfaceSettings;
         Procedure QueryInterfaceFlags(IFCounter:Byte);
         Procedure QueryInterfaceFlags2(IFCounter:Byte);
Imports
procedure QueryAddionalInfos(InterfaceNumber:String); 'TCPLIB' NAME 'QueryAddionalInfos';

End;

Implementation

USES Classes,DOS,TCPUtilityUnit,TCP_VAR_Unit,DEBUGUnit,MyMessageBox,Dialogs,TCP_ExceptionUnit,TCP_LanguageUnit,TCP_IniFIles,TCP_NewIniFile,ustring,FOrms;

VAR HELP:String;
    MyIni  :TOS2SystemINIFile;
    UserIni:TOs2UserIniFile;
    Counter:Byte;
    D1,D2,D3,D4,D5:String;

Procedure QuerySockDomains;
VAR S1,S2,S3:String;Loop:Byte;

Begin
     Loop:=15;
     SocksString(Loop,S1);
     Loop:=Loop+2;
     SocksString(Loop,S2);
     Loop:=loop+2;
     SocksString(Loop,S3);
     IF S1<>'' then DebugForm.ListBoxSocksDomains.items.add(S1);
     IF S2<>'' then DebugForm.ListBoxSocksDomains.items.add(S2);
     IF S3<>'' then DebugForm.ListBoxSocksDomains.items.add(S3);

End;

Procedure QuerySocksDNS;
VAR S1,S2,S3:String;Loop:Byte;
Begin
     Loop:=11;
     SocksString(Loop,S1);
     Loop:=Loop+2;
     SocksString(Loop,S2);
     Loop:=loop+2;
     SocksString(Loop,S3);
     IF S1<>'' then DebugForm.ListBoxSocksDNS.items.add(S1);
     IF S2<>'' then DebugForm.ListBoxSocksDNS.items.add(S2);
     IF S3<>'' then DebugForm.ListBoxSocksDNS.items.add(S3);
     //IF  ( (S1='') and (S2='') and (S3='') ) then DebugForm.ListBoxSocksDNS.items.add(' ');
ENd;

Procedure QuerySocksDirect;
VAR loop:Byte;S1,S2:String;
Begin
      IF Copy(ConfigStr,1,6)='direct' then
      Begin
           Loop:=8;S1:='';
           SocksString2(loop,S1);
           inc(loop);
           SocksString2(Loop,S2);
           {DebugForm.ListBoxDirectIP.items.add(S1);
           DebugForm.ListBoxDirectSubnet.items.add(S2);}
           DebugForm.lbSocksDirectTargetIP.items.add(S1);
           DebugForm.lbSocksDirectSubnet.items.add(s2);
     End;
End;

Procedure QuerySocksServer;
VAR S1,S2,S3,S4,S5:String;Loop:Byte;
Begin
     IF Copy (ConfigStr,1,8)='sockd @=' Then
     Begin
          Loop:=9;
          SocksString2(Loop,S1);
          inc(loop);
          SocksString2(Loop,S2);
          inc(loop);
          SocksString2(Loop,S3);
          inc(loop);
          inc(LOOP);
          SocksString2(Loop,S4);
          inc(loop);
          inc(loop);
          SocksString2(Loop,S5);
          IF S1<>'' then DebugForm.lbSOCKSServerIP.items.add(s1);
          IF S2<>'' Then DebugForm.lbSOCKSServerTargetIP.items.add(S2);
          IF S3<>'' then DebugForm.lbSOCKSServerSubnet.items.Add(s3);
          IF S4<>'' Then DebugFOrm.lbSOCSKSServerUserID.items.Add(Copy(S4,3,length(S4)));
          IF S5<>'' Then DebugForm.lbSOCKSServerpassword.items.Add(Copy(S5,3,length(S5)));
    End;
End;

Procedure QueryDomains;
Var aStringList:TStringlist;
    Counter:Byte;
Begin
             IF copy(MyUpcaseStr(ConfigStr),1,6)<>'SEARCH' Then exit;
             aStringlist:=TStringlist.Create;
             IF MultiValueString(ConfigStr,aStringlist,' ') then
             Begin
                  aStringlist.delete(0);
                  For counter:=0 to astringlist.count-1 do DebugForm.lbDomainsSetup.items.add(aStringlist[counter]);
             End;
             aStringlist.destroy;
End;

{Procedure QueryHosts;
VAr loopCounter:Byte;LocalStr:String;Start:byte;
Begin
     start:=1;
     For loopCounter:=start to length(ConfigStr) do
     begin
          IF ConfigStr='' then exit;
          Case ConfigStr[LoopCounter] of
          '0'..'9':If Filter=FlNumeric Then LocalStr:=LocalStr+StringToFilter[LoopCounter];
          '.'     :If Filter=FlNumeric Then LocalStr:=LocalStr+'.';
          ' '     :Begin DebugForm.LBHostIP.items.add(LocalStr);End;
     End;

End;}

Procedure QueryHOSTIP;
Begin
     IF configStr[1]='#' Then exit;
     DebugForm.LBHostIP.items.add(GetHostNameString(ConfigStr,1));
End;

Procedure QueryHOSTName;
Begin
     IF configStr[1]='#' Then exit;

     DebugForm.LBHostName.items.add(GetHostNameString(ConfigStr,23));

     Help:=GetHostNameString(ConfigStr,23);
End;


Procedure QueryHostAlias;
VAr Loop:Byte;AStr:String;
    index:longint;

Begin
     IF configStr[1]='#' Then exit;
     //IF length(help)+23+7>=length(ConfigStr) Then Begin Beep(100,100);DebugForm.LBHostAlias.items.add('Nil');exit;End;
     //showMessage(ToStr(Length(ConfigStr)));
     Index:=49;
     If ConfigStr[48]<>' ' Then
     Begin
          REPEAT
                Inc(Index);
                ProcessQueMessage;
          UNTIL ConfigStr[Index]=' ';
          Inc(Index);
     End;

     AStr:='';
     For Loop:=Index To length(ConfigStr) do
     begin
          IF ConfigStr[LOOP]<>'#' then
          Begin
               AStr:=AStr+ConfigStr[Loop]
          End else break;
     End;
     DebugForm.LBHostAlias.items.add(AStr);
End;

Procedure QueryHostComment;
VAr Loop:Byte;AStr:String;Debuglength:Byte;Posi:Byte;
Begin
     IF configStr[1]='#' Then exit;
     AStr:='';
     Posi:=Pos('#',ConfigStr);IF Posi<>0 then
     Begin
          AStr:=Copy(ConfigStr,posi+2,length(ConfigStr));
     End;
     DebugLength:=Length(AStr);
     DebugForm.LBHostComment.items.add(AStr);

End;







Function MakeDeleteString(Number:byte):String;
          VAR DebugStr:String;
          Begin
               DebugStr:='PM_\PIPE\LPD'+ToStr(Number);
               Result:=DebugStr;
          End;

          Procedure MakeNewOS2SysEntry(EntryNum:byte);
          Begin
               DebugForm.Memo1.lines.add('Executing Procedure MakeNewOS2SysEntrys');

               MyIni.WriteString('PM_\PIPE\LPD'+ToSTr(EntryNum),'DESCRIPTION',';');
               DebugForm.Memo1.lines.add('Procedure MakeNewOS2SysEntry , write new KEY : Section : PM_\PIPE\LPD'+ToSTr(EntryNum)+'Key : DESCRIPTION'+'Value : ;');
               MyIni.WriteString('PM_\PIPE\LPD'+ToSTr(EntryNum),'INITIALIZATION',';');
               DebugForm.Memo1.lines.add('Procedure MakeNewOS2SysEntry , write new KEY : Section : PM_\PIPE\LPD'+ToSTr(EntryNum)+'Key : INITIALIZATION'+'Value : ;');
               MyIni.WriteString('PM_\PIPE\LPD'+ToSTr(EntryNum),'PORTDRIVER','LPRPDRVR;');
               DebugForm.Memo1.lines.add('Procedure MakeNewOS2SysEntry , write new KEY : Section : PM_\PIPE\LPD'+ToSTr(EntryNum)+'Key : PORTDRIVER'+'Value : LPRPDRVR;');
               MyIni.WriteString('PM_\PIPE\LPD'+ToSTr(EntryNum),'TERMINATION',';');
               DebugForm.Memo1.lines.add('Procedure MakeNewOS2SysEntry , write new KEY : Section : PM_\PIPE\LPD'+ToSTr(EntryNum)+'Key : TERMINATION'+'Value : ;');
               MyIni.WriteString('PM_\PIPE\LPD'+ToSTr(EntryNum),'TIMEOUT','45;');
               DebugForm.Memo1.lines.add('Procedure MakeNewOS2SysEntry , write new KEY : Section : PM_\PIPE\LPD'+ToSTr(EntryNum)+'Key : TIMEOUT'+'Value : 45;');

               DebugForm.Memo1.lines.add('Successfully done Proceure MakeNewOS2SysEntrys');


          End;

 Procedure RemoveOS2SYSEntry(LastValue:Byte);
          VAR Loop:Byte;
          Begin
               DebugForm.Memo1.lines.add('Executing Procedure RemoveOS2SysEntry, variable "LastValue" is : '+ToStr(LastValue));
               For Loop:=Counter downto LastValue do
                   begin
                        DebugForm.Memo1.lines.add('delete section from OSSYS.INI, Section has value : '+MakeDeleteString(loop));
                        MyIni.EraseSection(MakeDeleteString(loop));
                   End;
          DebugForm.Memo1.lines.add('writing OS2SYS.INI section "LPRDRVR" in KEY "MAXPORTS" the value : '+ToStr(LastValue));
          MyIni.WriteString('LPRPDRVR','MAXPORTS',ToStr(LastValue));
           //Halt; // importment ! if program does not stop here, a SYS3175 will appear later in DOSCALL when leaving this unit - i dont know why
          DebugForm.Memo1.lines.add('Successfully done Procedure RemoveOS2SYSEntry');
          End;

 Procedure AddOS2SYSEntry(NumbersToAdd:Byte);
          VAr Loop:Byte;
          Begin
               DebugForm.Memo1.lines.add('Executing Procedure AddOS2SysEntry, variable "NumbersToAdd" has value : '+ToStr(NumbersToAdd));
               For loop:=0 to NumbersToAdd-1 do
               Begin
                    MakeNewOS2SYSEntry(loop);
               End;
               DebugForm.Memo1.lines.add('WriteString to OS2SYS.INI, Section : LPRDRVR , KEY : MAXPORTS, Value : '+ToStr(NumbersToAdd));
               MyIni.WriteString('LPRPDRVR','MAXPORTS',ToStr(NumbersToAdd));
               //Halt; // importment ! if program does not stop here, a SYS3175 will appear later in DOSCALL when leaving this unit - i dont know why
               DebugForm.Memo1.lines.add('Successfully done Procedure AddOS2SysEntry');
          End;



Procedure QueryNetworkPrinter;

          Procedure CountEntrys;
          VAR Loop:Byte;
          Begin
               Counter:=0;
               for loop:=0 to DebugFOrm.ListBoxNetPrinterOS2SYS.items.count-1 do
               Begin
                    IF Copy(DebugForm.ListBoxNetPrinterOS2SYS.items[loop],1,12)='PM_\PIPE\LPD' Then Inc(Counter);
               End;
               DebugFOrm.SpinEditNetPrintFoundedEntrys.Value:=Counter;
          End;


VAR S:String;
Begin
  MyIni.Create;
  MyIni.ReadSections(DebugForm.ListBoxNetPrinterOS2SYS.items);
  CountEntrys;
  {DebugForm.SpinEditNetPrintMaxAmountLPD.Value:=Counter;

  FindConfigSysEntry('SET LPR_SERVER',S);
  OldConfigSys.LPR_SERVER:=Copy(S,16,length(S));
  DebugForm.EditLPR_SERVER.Text:=COPY(S,16,length(S));

  IF (getEnv('LPR_SERVER')='') and (S<>'') then DebugForm.LabelEnvPrintServer.visible:=TRUE else DebugForm.LabelEnvPrintServer.Visible:=FALSE;

  FindConfigSysEntry('SET LPR_PRINTER',S);
  OldConfigSys.LPR_PRINTER:=COpy(S,17,length(S));
  IF (getEnv('LPR_PRINTER')='') and (S<>'') then DebugForm.LabelEnvRemotePrintServer.visible:=TRUE else DebugForm.LabelEnvRemotePrintServer.Visible:=FALSE;
  DebugForm.EditLPR_PRINTER.Text:=Copy(S,17,length(S));}

End;


{Function NFSEntryExists(S:String):Boolean;
VAR Value:longint;
// True if entry exists - false if not
Begin
     Value:=DebugForm.lbNFSDirectory.items.Indexof(S);
     IF Value=-1 Then Result:=FALSE else Result:=TRUE;
End;}



{Procedure QueryNFSComment;
VAR Posi:Byte;
    DebugStr:String;
// Version 2
Begin
     IF Pos('#',ConfigStr)<>0 Then
     Begin
          Posi:=Pos('#',ConfigStr);Posi:=Posi+2;
          DebugForm.lbNFSComment.items.add( Copy (ConfigStr,Posi,length(ConfigStr) ) );
     End else
     Begin
          DebugForm.lbNFSComment.items.add(' ');
     End;
End;}

{Procedure QueryNFSComment;
VAR posi:Byte;
// Version 1
begin
     IF findWordinStri('#',ConfigStr)<>-1 Then
     Begin
          Posi:=Pos('#',ConfigStr);Inc(Posi);
          DebugForm.lbNFSComment.items.add( Copy (ConfigStr,Posi,length(ConfigStr) ) );
     End else
     Begin
          DebugForm.lbNFSComment.items.add('nil');
     End;

End;}


    {Procedure QueryNFSRights;
    Begin
         IF FindWordinStri('-rw',ConfigStr)<>-1 Then DebugForm.lbNFSRights.items.add('-rw');
         IF FindWordinStri('-ro',ConfigStr)<>-1 Then DebugForm.lbNFSRights.items.add('-ro');
         IF  ( (FindWordinStri('-ro',ConfigStr) =-1)  and  (FindWordinStri('-rw',ConfigStr)=-1) )  then DebugForm.lbNFSRights.items.add(' ');

    End;

    Procedure QueryNFSPuplicDirs;
    Begin
    End;

    Procedure QueryNFSReadOnlyHost(DirName:String);
    VAr loop,Loop1:Byte;
        DebugStr:String;
        EndPos:Byte;
        NameIndex:longint;
        test:Byte;
    Begin
         Loop:=FindWordinStri('-ro',ConfigStr);
          IF Loop=-1 then exit;
            loop:=loop+4; {Loop:=loop + length from "-ro " //last sign is a space

         For Loop1:=loop to length(ConfigStr) do
         Begin
             SocksString2(loop,DebugStr);IF DebugStr='#' then break;IF DebugStr='' then break;
             // Pr�fen, ob der Verzeichniss Name bereits in der ListBox vorghanden ist
             NameIndex:=DebugForm.lbNFSDirectory.items.Indexof(DirName);
             // Name vorhanden ?
             IF NameIndex=-1 Then
             Begin
                  Test:=DebugForm.lbnfsDirectory.items.count;
                  // Name nicht gefunden, dann Zeilen Z�hler der Datei EXPORTS verwenden
                  NFSReadListArray [DebugForm.lbNFsDirectory.items.count].Add(DebugStr);
             End else
             Begin
                  // Name bereits vorhanden, hinzuf�gen bei jeweiliger Position
                  NFSReadListArray [NameIndex].Add(DebugStr);
             End;
             inc(loop); //space sign
         End;
    End;

    Procedure QueryNFSReadWriteHost(DirName:String);
    VAr loop,Loop1:Byte;
        DebugStr:String;
        EndPos:Byte;
        NameIndex:longint;
    Begin
         Loop:=FindWordinStri('-rw',ConfigStr);
          IF Loop=-1 then exit;
            loop:=loop+4; {Loop:=loop + length from "-ro " //last sign is a space

         For Loop1:=loop to length(ConfigStr) do
         Begin
             SocksString2(loop,DebugStr);IF DebugStr='#' then break;IF DebugStr='' then break;
             // Pr�fen, ob der Verzeichniss Name bereits in der ListBox vorghanden ist
             NameIndex:=DebugForm.lbNFSDirectory.items.Indexof(DirName);
             // Name vorhanden ?
             IF NameIndex=-1 Then
             Begin
                  // Name nicht gefunden, dann Zeilen Z�hler der Datei EXPORTS verwenden
                  NFSReadWriteListArray [NfsCounter].Add(DebugStr);
             End else
             Begin
                  // Name bereits vorhanden, hinzuf�gen bei jeweiliger Position
                  NFSReadWriteListArray [NameIndex].Add(DebugStr);
             End;
             inc(loop); //space sign
         End;
     End;}

  {
    OLD Routine Version for 0.85.8 , no longer valid for 0.85.9 and higher

    Procedure QueryNFS;
    VAR loop:Byte;
        DebugStr1,DebugStr2,DebugStr3,DebugStr4,DebugStr5:String;
        AddIndex:integer;
        Found:Boolean;
    Begin
            Found:=FALSE;
            NFSReadListArray [NFSCounter]:=TStringList.Create;
            NFSReadWriteListArray[NFSCounter]:=TStringList.Create;
            NFSReadListArray [NFSCounter].Clear;
            NFSReadWriteListArray[NFSCOunter].Clear;

            // Parameter 1
            Loop:=1;SocksString2(Loop,DebugStr1);Inc(loop);
            // Parameter 2
            SocksString2(Loop,DebugStr2);Inc(Loop);
            // parameter 3
            SocksString2(Loop,DebugStr3);Inc(Loop);
            // parameter 4
            SocksString2(Loop,DebugStr4);Inc(Loop);
            // parameter 5
            SocksString2(loop,DebugStr5);Inc(Loop);
            // parameter Auswerten

               IF not nfsEntryExists(DebugStr1) Then
               Begin
                    AddIndex:=DebugForm.lbNFSDirectory.items.add(DebugStr1);
                    IF DebugStr2='-alias' Then DebugForm.lbnfsAlias.items.add(DebugStr3) else DebugForm.lbNFSAlias.items.add(' ');
                    QueryNfsComment;
               End;

               IF DebugStr4='-ro' Then
                  Begin
                       Found:=True;
                       IF ( (DebugStr5<>'') and (DebugStr5<>'#') ) then Begin DebugForm.lbNFSrights.items.insert(AddIndex,'H');QuerynfsReadOnlyHost(debugstr1);End
                                        else
                                            begin
                                                 TRY
                                                 DebugForm.lbnfsRights.items.insert(AddIndex,'R');
                                                 Except DisplayException(34);
                                                 End;
                                             End;
                  ENd;
               IF debugStr4='-rw' Then
               Begin
                    Found:=True;
                    // ???
                    // IF (DebugStr5<>'')  Then Begin DebugForm.lbNfsRights.items.insert(AddIndex,'H');QueryNFSReadWriteHost(DebugStr1);End else
                    DebugForm.lbnfsRights.items.insert(AddIndex,'W');
                ENd;

                IF DebugStr2='-ro' Then
                  Begin
                  //No Alias, no Comment
                       Found:=True;
                       IF ( (DebugStr3<>'') and (DebugStr3<>'#') ) then
                       Begin
                            DebugForm.lbNFSrights.items.insert(AddIndex,'H');
                            QuerynfsReadOnlyHost(debugstr1);
                       End
                       else DebugForm.lbnfsRights.items.insert(AddIndex,'R');
                  ENd;

                  IF debugStr2='-rw' Then
               Begin
                    Found:=True;
                    IF (DebugStr3<>'')  Then Begin DebugForm.lbNfsRights.items.insert(AddIndex,'H');QueryNFSReadWriteHost(DebugStr1);End
                                     else DebugForm.lbnfsRights.items.insert(AddIndex,'W');
                ENd;
                IF DebugStr2='public' then DebugFOrm.lbNFSPublicDir.items.add(DebugStr1);

                IF not Found Then DebugForm.lbnfsRights.items.insert(AddIndex,'H');
    End;

}




Procedure ReadHostFile;
   VAR F:Text;
       HostStri:String;
       STR_IP:String;
       STR_Alias:String;
       STR_Comment:String;
       STR_Hostname:String;

       Procedure ClearStrings;
       Begin
            STR_IP:='';
            STR_Hostname:='';
            Str_Alias:='';
            STR_COmment:='';
       End;

       Procedure IPAdresse(var LoopPos:Byte);
       VAR Loop:Byte;
       Begin
            For loop:=1 to length(HostStri) do
                Begin
                     IF HostStri[loop] in ['0'..'9'] then Str_IP:=Str_IP+HostStri[loop];
                     IF HostStri[Loop] ='.' then Str_IP:=Str_IP+'.';
                     IF HostStri[Loop]=' ' then break;
                End;
       LoopPos:=Loop;{Position speichern}
       ENd;

       Procedure HostName(Var loopPos:Byte);
       VAr loop:Byte;found:Boolean;
       Begin
            Found:=FALSE;
            For Loop:=LoopPos to length(HostStri) do
            begin
                 IF HOSTStri[Loop]=' ' Then
                 Begin
                      IF Found then break;
                 End;
                 IF HostStri[loop] in ['A'..'Z'] then Begin Found:=True;Str_HostName:=Str_Hostname+HostStri[loop];End;
                 IF HostStri[Loop] in ['a'..'z'] then Begin FOund:=True;Str_HostName:=Str_Hostname+HostStri[loop];End;
                 IF HostStri[loop] in ['0'..'9'] then Begin FOund:=TRUE;Str_HostName:=Str_Hostname+HostStri[loop];End;
                 IF HostStri[loop]='.' then Begin Found:=TRUE;STr_HostName:=Str_Hostname+'.';End;
                 IF HostStri[Loop]='-' then Begin Str_HostName:=Str_Hostname+'-';Found:=True;End;
                 IF HostStri[Loop]='_' then Begin Found:=TRUE;Str_HostName:=Str_Hostname+'_';End;
            End;
            LoopPos:=Loop;
       End;

   Procedure AliasName(var loopPos:Byte);
   var loop:Byte;Found:Boolean;

   Begin
        found:=false;
        For Loop:=LoopPos to length(HostStri) do
        Begin
             For Loop:=LoopPos to length(HostStri) do
            begin

                 IF HostStri[loop] in ['A'..'Z'] then Begin Str_Alias:=Str_Alias+HostStri[loop];found:=true;ENd;
                 IF HostStri[Loop] in ['a'..'z'] then Begin Str_Alias:=Str_Alias+HostStri[loop];found:=true;End;
                 IF HostStri[Loop] in ['0'..'9'] then Begin Str_Alias:=Str_Alias+HostStri[loop];found:=true;End;
                 IF HostStri[loop]='.' then Begin STr_Alias:=Str_Alias+'.';found:=true;End;
                 IF HostStri[Loop]='-' then Begin Str_Alias:=Str_Alias+'-';found:=true;End;
                 IF HostStri[Loop]='_' then Begin Str_Alias:=Str_Alias+'_';Found:=true;End;
                 IF HOSTStri[Loop]='@' Then Begin Str_ALias:=Str_Alias+'@';found:=true;End;
                 IF HOSTStri[Loop]='#' Then begin Str_Alias:=Str_Alias+'#';found:=true;end;
                 IF HOSTStri[Loop]='*' Then begin Str_Alias:=Str_Alias+'*';found:=true;end;
                 IF HostStri[Loop]=' ' then
                 Begin
                      {IF loop+1>length(HostStri) Then
                      Begin}
                           IF HostStri[loop+1]='#' then
                           Begin
                                IF HostStri[loop+1]=' ' Then break;
                           End;
                      {End;}
                      if found then Str_Alias:=Str_Alias+' ';
                 End;
            End;
            LoopPos:=Loop;
        End;
   ENd;

     Procedure Comment(Var LoopByte:Byte);
   var loop:Byte;
   Begin
             For Loop:=length(Str_Alias) downto 1 do
            begin
                 IF Str_Alias[Loop]=' ' then
                 begin
                      IF Str_Alias[loop-1]='#' then
                      begin
                           IF Str_ALias[loop-2]=' ' Then
                           Begin
                                LoopByte:=loop;
                                Str_Comment:=COpy(Str_Alias,loop+1,length(Str_alias));
                                break;
                            End;
                      End;
                 End;
            End;
   End;


  VAR LoopByte:byte;
      Cut:Byte;
      IOError:Integer;
   Begin
        ClearStrings;
       // Assign(F,'D:\MPTN\ETC\HOSTS');Reset(F);
        Repeat
              {$I-}
              Readln(ConfigFile,HOSTStri);IOError:=IOResult;
              IF IOError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_HOST'));Close(ConfigFile);Exit;End;

              IPAdresse(LoopByte);
              HostName(LoopByte);
              AliasName(loopByte);

              Comment(loopByte);
              IF  (Str_Alias<>'#') then
              begin
                   IF Str_Comment<>'' then
                      Begin
                      loopByte:=LoopByte-2;
                      Cut:=length(str_alias)-loopByte;
                      Delete(Str_Alias,loopByte,cut+1);
                      End;
                   if copy(str_alias,1,2)='# ' then
                   begin
                        Str_Comment:=COpy(Str_Alias,3,length(Str_Alias));Str_Alias:='';
                   End;
              End;
              IF SignsInString('#',Str_Alias)>0 Then
              Begin
                   DELETE(STR_ALIAS,LENGTH(STR_ALIAS)-1,1);
              End;
              //IF (Str_Comment='') and (pos('#',Str_Alias)>1)  Then DELETE(STR_ALIAS,LENGTH(STR_ALIAS)-1,1);
              {Writeln('IP Adresse : ',STR_IP);
              Writeln('Hostname   : ',STR_Hostname);
              Writeln('Alias      : ',Str_Alias);
              Writeln('Comment    : ',Str_Comment);}
              DebugForm.LBHostIP.items.add(Str_IP);
              DebugForm.LBHostName.items.add(Str_Hostname);
              DebugForm.LBHostAlias.items.add(Str_Alias);
              DebugForm.LBHostComment.items.add(Str_Comment);
              ClearStrings;
        Until eof(ConfigFile);
        Close(ConfigFile);
   End;

Procedure QueryServerUsers;
Begin
     IF ConfigStr[1]='#' Then exit;
     IF FindWordInStri('USERID',ConfigStr)<>-1 Then
     Begin
          DebugForm.lbServicesUserName.items.add(Copy(COnfigStr,FindWordInStri('USERID',ConfigStr)+7,length(ConfigStr)));
     End;

End;

Procedure QueryServerComments;
Begin
IF ConfigStr[1]='#' Then exit;
IF FindWordInStri('comment',ConfigStr)<>-1 Then
   Begin
        DebugForm.lbServicesComments.items.add(Copy(COnfigStr,FindWordInStri('comment',ConfigStr)+8,length(ConfigStr)));
   End;
End;

Procedure QueryServerPassword;
Begin
    IF ConfigStr[1]='#' Then exit;
    IF FindWordInStri('password',ConfigStr)<>-1 Then
     Begin
     // Add Dummy password - real password will be wirtten decrypted first, later the dll will crypt it.
     DebugForm.lbServicesPassword.items.add(Copy(COnfigStr,FindWordInStri('password',ConfigStr)+9,length(ConfigStr)));
     DebugForm.lbServicesPasswordCrypted.items.add(Copy(COnfigStr,FindWordInStri('password',ConfigStr)+9,length(ConfigStr)));
     End;
End;

Procedure QueryServerHomeDir;
Begin
     IF ConfigStr[1]='#' Then exit;
     IF FindWordInStri('homedir',ConfigStr)<>-1 Then
     Begin
          DebugForm.lbServicesHomeDir.items.add(Copy(COnfigStr,FindWordInStri('homedir',ConfigStr)+8,length(ConfigStr)));
     End;

End;

Procedure QueryServerNFSUserID;
Begin
  IF ConfigStr[1]='#' Then exit;
  IF FindWordInStri('uid',ConfigStr)<>-1 Then
     Begin
          DebugForm.lbServicesNFSUSerID.items.add(Copy(COnfigStr,FindWordInStri('uid',ConfigStr)+4,length(ConfigStr)));
     End;// DebugForm.lbServicesNFSUSerID.items.add('NIL');

End;

Procedure QueryServerNFSGroupID;
Begin
      IF ConfigStr[1]='#' Then exit;
      IF FindWordInStri('gid',ConfigStr)<>-1 Then
     Begin
          DebugForm.lbServicesNFSGroupID.items.add(Copy(COnfigStr,FindWordInStri('gid',ConfigStr)+4,length(ConfigStr)));
     End; //else DebugForm.lbServicesNFSGroupID.items.add('NIL');
End;

Procedure QueryServerTelnetShell;
VAr Debug:Byte;
    Param1,Param2:String;
Begin
    IF ConfigStr[1]='#' Then exit;
    Debug:=FindWordInStri('shell=',ConfigStr);
    IF FindWordInStri('shell=',ConfigStr)<>-1 Then
    Begin
        IF COpy(COnfigStr,FindWordInStri('shell=',ConfigStr)+6,2) ='/C' Then
        Begin
             Delete(COnfigStr,debug+6,2);
             DebugFOrm.lbTelnetDisconnect.items.add('true')
        End
        else
        DebugForm.lbTelnetDisconnect.items.add('false');
        Param1:='';Debug:=Debug+7;
        SocksString2(debug,Param1);Debug:=debug+2;
        SocksString2(debug,Param2);
        DebugFOrm.lbServicesTelnetShell.items.add(Param1);
        DebugForm.lbServicesTelnetParamter.items.add(Param2);
    End;
End;

Procedure QueryServerServices;
VAR Debug,IOError:Integer;HelpStr:String;Index:Longint;

Begin
     IF ConfigStr[1]='#' Then exit;
     Debug:=FindWordInStri('FTPD=',ConfigStr);
     IF FindWordInStri('FTPD=',ConfigStr)<>-1 Then
     begin
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
         {$I-}
         Readln(ConfigFile,COnfigStr);IOError:=IoResult;
         IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Should the return value be higher -1 then , service is activated}
          IF FindWordinStri('active=0',ConfigStr)<>-1 then DebugForm.lbServicesFTP.items.add('false') else DebugForm.lbServicesFTP.items.add('true');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          IF FindWordinStri('read=',ConfigStr)<>-1 then
          Begin
               DebugForm.lbServicesFTPDreadDirectory.items.add(  Copy (ConfigStr,FindWordinStri('read=',ConfigStr)+5,length(ConfigStr) ) );
               HelpStr:=Copy (ConfigStr,FindWordinStri('read=',ConfigStr)+5,length(ConfigStr));
               Index:=DebugForm.lbServicesFTPDreadDirectory.items.count-1;
               MultiValueString(HelpStr,FTPServerRec[Index].ReadDir,' ');

          End else MyInfoBox('DEBUG Warning :unable to find "read=" in ConfigStr');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {0 means unchecked - do not deney (false) 1 means deny read (true) }
          IF FindWordinStri('canread=0',ConfigStr)<>-1 then DebugForm.lbServicesFTPDcanRead.items.add('true') else DebugForm.lbServicesFTPDcanRead.items.add('false');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          IF FindWordinStri('write=',ConfigStr)<>-1 then
          Begin
               DebugForm.lbServicesFTPDwriteDirectory.items.add(Copy (ConfigStr,FindWordinStri('write=',ConfigStr)+6,length(ConfigStr) ) );
               HelpStr:=Copy (ConfigStr,FindWordinStri('write=',ConfigStr)+6,length(ConfigStr) );
               Index:=DebugForm.lbServicesFTPDwriteDirectory.items.count-1;
               MultiValueString(HelpStr,FTPServerRec[Index].WriteDir,' ');
          End else MyInfoBox('DEBUG Warning :unable to find "write=" in ConfigStr');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          IF FindWordinStri('canwrite=0',ConfigStr)<>-1 then DebugForm.lbServicesFTPDcanWrite.items.add('true') else DebugForm.lbServicesFTPDcanWrite.items.add('false');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          IF FindWordinStri('log=',ConfigStr)<>-1 then DebugForm.lbServicesFTPDLog.items.add( Copy (ConfigStr,FindWordinStri('log=',ConfigStr)+4,length(ConfigStr) ) ) else MyInfoBox('DEBUG Warning :unable to find "log=" in ConfigStr');

          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          IF FindWordinStri('idletimeout=',ConfigStr)<>-1 then DebugForm.lbServicesFTPDidletimeout.items.add( Copy (ConfigStr,FindWordinStri('idletimeout=',ConfigStr)+12,length(ConfigStr) ) )
          else MyInfoBox('DEBUG Warning :unable to find "idletimeout=" in ConfigStr');

          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Read again to get the next service entry - this entry is the " ) " sign }
          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
     End;

  IF FindWordInStri('TELNETD=',ConfigStr)<>-1 Then
     Begin
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          {$I-}
          Readln(ConfigFile,COnfigStr);IOError:=IoResult;
          IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Should the return value be higher -1 then , service is activated}
          IF FindWordinStri('active=0',ConfigStr)<>-1 then DebugForm.lbServicesTELNET.items.add('false') else DebugForm.lbServicesTelnet.items.add('true');
          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Read again to get the next service entry - this entry is the " ) " sign }
          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
     End;

      IF FindWordInStri('rexecd=',ConfigStr)<>-1 Then
      Begin
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          {$I-}
          Readln(ConfigFile,COnfigStr);IOError:=IoResult;
          IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Should the return value be higher -1 then , service is activated}
          IF FindWordinStri('active=0',ConfigStr)<>-1 then DebugForm.lbServicesREX.items.add('false') else DebugForm.lbServicesREX.items.add('true');
          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Read again to get the next service entry - this entry is the " ) " sign }
          {Read next section from file}
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          Readln(COnfigFile,ConfigStr);IoError:=IoResult;IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
      End;
      IF FindWordInStri('nfsd=',ConfigStr)<>-1 Then
      begin
          IF Eof(COnfigFile) then Begin MyErrorBox(GetNlsString('ERRORS','EOF_TCPNBK'));Close(ConfigFile);Exit;End;
          {$I-}
          Readln(ConfigFile,COnfigStr);IOError:=IoResult;
          IF IoError<>0 Then Begin MyErrorBox(GetNlsString('ERRORS','ReadErr_TCPNBK'));Close(ConfigFile);Exit;End;
          {Should the return value be higher -1 then , service is activated}
          IF FindWordinStri('active=0',ConfigStr)<>-1 then DebugForm.lbServicesNFS.items.add('false') else DebugForm.lbServicesNFS.items.add('true');
      End;
End;

{��������������������������������������������������������������������������ͻ
 �                                                                          �
 �     Network Filesystem implementation                                    �
 �                                                                          �
 �     Version 3 17.08.2005 - last changed 18.08.2005                       �
 �                                                                          �
 ��������������������������������������������������������������������������ͼ}
 VAR
        {ConfigFile:Text;
        COnfigStr:String;}
        Right_FoundFlag:Boolean; {True entweder ein -ro oder ein -rw wurde gefunden / FALSE keiner von beiden wurde gefunden}
        LastPos:Byte;

    Function FindInString(StringToSearch:String;VAR Pos:Byte):Boolean;
    Var Counter:Byte;
        Test:String;
        Begin
              Counter:=1;Result:=False;
              Repeat
                   IF copy(ConfigStr,counter,length(StringToSearch))=StringToSearch Then
                   Begin
                        Result:=True;Pos:=Counter;Exit;
                   ENd;
                   Test:=COpy(ConfigStr,counter,length(StringToSearch));
                   Inc(Counter);
              Until (Counter=255) or (ConfigStr[Counter]='#');
        End;

  Function ReadString(VAR StartPos:Byte):String;
  // Liest einen String ab POS X bis zum vorkommen eines "Leerzeichens" und liefert danch den korrekten String zur�ck
        VAR
            Output:String;

        Begin
                IF StartPos>length(ConfigStr) Then Begin Result:='#';STartPos:=255;exit;End;
                Output:='';
           REPEAT
                IF COnfigStr[StartPos]=#0 Then Begin Result:=Output;StartPos:=254;Exit;End; // Zeilenende Erreicht
                IF ConfigStr[StartPos]<>' ' Then

                Begin
                        OutPut:=Output+ConfigStr[StartPos];
                End else
                Begin
                        Result:=Output;exit;
                End;
                Inc(StartPos);
          UNTIL StartPos>Length(ConfigStr);
          Result:=Output;
        End;


  Procedure CreateStringLists;
  VAr loop:Byte;
  Begin
       // Create the stringlist
       For Loop:=0 to MaxNFSStringListCount do
       Begin
            {NFSReadWriteListArray[Loop]:=TStringList.Create;
            NFSReadListArray[Loop]:=TStringlist.Create;}
            NFSHostListArray[Loop]:=TStringList.Create;
       End;
  End;

                Function QueryComments(Posi:Byte):String;
                VAR
                   Loop:Byte;
                   s:String;
                Begin
                        IF Posi=0 Then Begin Result:='';Exit;End;
                        S:=COpy(ConfigStr,Posi,length(COnfigStr));
                        Result:=S;
                End;



                Procedure QueryHosts(StartPos:Byte);
                VAR
                        Loop:Byte;
                        S:String;
                        LastPos:Byte;
                        //NFS_Array_Counter:Byte;
                Begin
                        S:='';LastPos:=StartPos;
                        Repeat
                                S:=ReadString(LastPos);
                                Inc(LastPos);
                                IF S<>'#' Then
                                Begin
                                        {IF DebugForm.lbNFSRights.items[Config_Line_Counter]='W' Then
                                        Begin
                                                NFSReadWriteListArray[Config_Line_Counter].Add(S);
                                        End;

                                        IF DebugForm.lbNFSRights.items[Config_Line_Counter]='R' Then
                                        Begin
                                                NFSReadListArray[Config_Line_Counter].Add(S);
                                        End;}
                                        NFSHostListArray[Config_Line_Counter].Add(S);

                                End;

                         Until S='#'; // Ausgang wenn keine weiteren Zeilen oder Kommentar Kennung gefunden wurde

                         DebugForm.lbNFSComment.items.add(QueryComments(LastPos));
                End;

                Procedure PublicEntry;
                // �ffentliches Verzeichniss - ohne ALIAS ohne HOSTNAMEN und ohne Kommentare
                Begin
                             DebugForm.lbNFSRights.items.add('P');
                             DebugFOrm.lbNFSAlias.items.add(''); // Kein Alias
                             DebugForm.lbNFSComment.items.add(''); // Kein Kommentar
                             DebugFOrm.lbNFSPublicDir.items.add('');
                End;


                Procedure Check_Entry_String;
                Begin
                        //IF FindInString('public',lastpos) Then Begin PublicEntry;Exit;End;
                        // Hole Verzeichnis Info (muss immer vorhanden sein)
                        LastPos:=1;Right_FoundFlag:=FALSE;

                        DebugFOrm.lbNFSDirectory.items.add(ReadString(LastPos));
                        IF FindInString('public',lastpos) Then Begin PublicEntry;Exit;End;

                        // Hole Alias Info (optional) Nach dem Wort "-alias" kommt der alias eintrag
                        IF FIndInString('-alias',LastPos) Then
                        Begin
                                LastPos:=LastPos+7; // Um 7 Zeichen erweitern um aus das alias zu kommen
                                DebugForm.lbNFSAlias.items.add( readString(LastPos) );
                        End else
                        Begin
                                // Sollte keiner vorhanden sein, listbox trotzdem f�llen
                                DebugForm.lbNFSAlias.items.add('');
                        End;

                        // Hole Rechte
                        IF FindInString('-ro',LastPos) Then
                        Begin

                             LastPos:=LastPos+4;QueryHosts(LastPos);
                             RIGHT_FOUNDFlag:=True;
                             DebugFOrm.lbNFSPublicDir.Items.add(''); // Dummy Eintrag

                             IF NFSHostListArray[Config_Line_Counter].Count<>0 Then DebugFOrm.lbNFSRights.items.add('HR')
                                                                               else DebugForm.lbNFSRights.items.add('PR')
                        End;

                        IF FindInString('-rw',LastPos) Then
                        Begin
                             LastPos:=LastPos+4;QueryHosts(LastPos);
                             Right_FoundFlag:=TRUE;
                             DebugForm.lbNFSPublicDir.Items.Add(''); // Dummy Eintrag
                             IF NFSHostListArray[Config_Line_Counter].Count<>0 Then DebugForm.lbNFSRights.items.add('HW')
                                                                               else DebugForm.lbNFSRights.Items.add('PW');

                        End;

                      IF not Right_FoundFlag Then
                      Begin
                         IF DebugForm.lbNFSDirectory.items[Config_line_Counter]='#' Then
                        Begin ; // Wenn die ganze Zeile nur aus einem Kommenar besteht, irgnorieren
                                DebugForm.lbNFSDirectory.items.Delete(config_Line_Counter);
                                DebugFOrm.lbNFSAlias.Items.delete(Config_Line_Counter);
                                Dec(Config_Line_Counter);
                                Exit;
                        End;     

                        DebugForm.lbNFSRights.items.add('H');  // Wenn keine Rechte angegeben wurden , k�nnen auch keine HOSTS Vorhanden sein
                        LastPos:=LastPos+3;
                        DebugForm.lbNFSComment.items.add(QueryComments(LastPos));
                        DebugForm.lbNFSPublicDir.items.add(DebugForm.lbNFSDirectory.items[COnfig_line_Counter]);
                      End;
                End;

  Procedure QueryNFS;
  Begin
        CreateStringLists;
        Config_Line_Counter:=0; // Zeilen Z�hler der Datei;
        Repeat

                Readln(ConfigFile,ConfigStr);

                IF ConfigStr<>'' Then
                Begin
                        Check_Entry_String;
                        Inc(Config_Line_Counter);
                End;

        Until eof(ConfigFile);
        Close(ConfigFile);
  ENd;

Function ActiveInterface(InterfaceNum:byte):Boolean;
VAR
   S:String;
   RC:String;
Begin
        UserIni.Create;
        S:=MyUpCaseStr(DebugForm.LBIPSetupLanNum.items[InterfaceNum]);
        RC:=USerIni.ReadString('TCPConfig',S,'-1');
        IF RC<>'-1' Then
        Begin
             IF RC='1' Then Result:=TRUE else Result:=FALSE;
        End;

End;




        Function FindInString2(StringToSearch:String;VAR Pos:Byte):Boolean;
        Var Counter:Byte;
             Test:String;
        Begin
              Counter:=1;Result:=False;
              Repeat
                   //IF System.POS('#',TEST)>1 Then exit; // Pr�fen, ob wir nicht auf ein kommentar sto�en welches das wort "puplic" enth�lt.
                   Test:=COpy(ConfigStr,counter,length(StringToSearch));
                   IF copy(ConfigStr,counter,length(StringToSearch))=StringToSearch Then
                   Begin
                        Result:=True;Pos:=Counter;Exit;
                   ENd;


                   Inc(Counter);
              Until (Counter=255) or (ConfigStr[Counter]='#');

        End;

        Function ReadString2(VAR StartPos:Byte):String;
        // Liest einen String ab POS X bis zum vorkommen eines "Leerzeichens" und liefert danch den korrekten String zur�ck
        VAR
            Output:String;

        Begin
                IF StartPos>length(ConfigStr) Then Begin Result:='#';STartPos:=255;exit;End;
                Output:='';
           REPEAT
                IF COnfigStr[StartPos]=#0 Then Begin Result:=Output;StartPos:=254;Exit;End; // Zeilenende Erreicht
                IF ConfigStr[StartPos]<>' ' Then

                Begin
                        OutPut:=Output+ConfigStr[StartPos];
                End else
                Begin
                        Result:=Output;exit;
                End;
                Inc(StartPos);
          UNTIL StartPos>Length(ConfigStr);
          Result:=Output;
        End;







Function QueryAmountInterfaces:Byte;
{ 
                Ermittelt, wieoft ein Protokoll im String installiert wurde
                Z.B. ',VFET2A_nif' = 'EL93X_NIF,VFET2A_nif' = 2X usw...

Ge�ndert 06.10.2006 - aStrings.count lieferte immer 2 eintr�ge zur�ck, obwohl nur 1 Eintrag vorhanden war
Ger�ndert 01.11.2006 - Umabu auf OS/2 INi File
}
VAR
        AStringList:TStringList;
        ProtIni:TNewAscIIIniFile;
        InputString:String;

Begin
                ProtIni.Create(Application.ProgramIniFile.ReadString('Settings','IBMCOM_PATH','')+'\PROTOCOL.INI');

                //InputStr:=ProtIni.ReadString('tcpip_nif','Bindings','-1');IF INputStr<>'-1' Then
                IF ProtIni.ReadString('tcpip_nif','Bindings',InputString) Then
                Begin
                
                        AStringList:=TStringList.Create;        // Create the list for storing prot.names
                        Result:=NewProtValueString(InputString,aStringList);        // Split the values readed from ini and store them into the list
                        //Result:=aStringList.Count;              // Result is amount stored protocols
                End else
                Begin
                        MyErrorBox('Unable to find Section or Ident in Protocol.INI'+#13+'IDENT=tcpip_nif'+#13+'Section=Bindings'+#13);

                        Halt;
                End;
                ProtIni.Destroy;
                AStringList.Destroy;
End;



Procedure QueryInterfaceFlags(IFCounter:Byte);
CONST Section='Interface#';
VAR S:String;
INIFile:TOs2UserIniFile;
Begin
          IniFile.Create;
          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'CANONICAL','-1');
          IF S='1' Then DebugFOrm.lbSpSettingsCANONICAL.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsCANONICAL.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'802.3','-1');
          IF S='1' Then DebugForm.lbSpSettings802.items.add('true');
          IF S='0' Then DebugForm.lbSpSettings802.items.add('false');

          S:=IniFile.ReadString(Section+ToStr(IFCounter),'BRIDGE','-1');
          IF S='1' Then DebugForm.lbSpSettingsBRIDGE.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsBRIDGE.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'ARP','-1');
          IF S='1' Then DebugForm.lbSpSettingsARP.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsARP.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'SNAP','-1');
          IF S='1' Then DebugForm.lbSpSettingsSNAP.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsSNAP.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'TRAILERS','-1');
          IF S='1' Then DebugForm.lbSpSettingsTrailers.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsTrailers.items.add('false');
          IniFile.Destroy;
End;


Procedure QueryInterfaceSettings;
CONST Section='Interface#';
VAR
   IfCounter:Byte;
   AdressCounter:Byte;
   RouteCounter:Integer;
   IniFile  :TOS2UserIniFile;
   AliasCOunt:Integer;  {Anzahl ALIAS IP Adressen beginnend von 1 (1=Keine Alias IP, erst ab 2 IP-Adressen ist eine Alias IP vorhanden}
   AliasLoopCounter:Byte; {Schleifenz�hler f�r Alias IP Schleife}
   S         :String;

Begin
     IniFile.Create;
     For IFCounter:=0 to 7 do
     Begin
          S:=IniFile.ReadString(Section+ToStr(IFCounter),'NAME','-1');
          IF S<>'-1' Then DebugForm.LBIPSetupLanNum.items.add(S) else
          Begin
               IniFile.EraseSection(Section+ToStr(IFCOunter));
               break;
          End;
          // CHECK if Interface is controlled via DHCP
          S:=IniFile.ReadString(Section+ToStr(IFCounter),'DHCP','-1');
          IF S='-1' Then
          Begin
               // NO DHCP
               DebugFOrm.lbIPSetupDHCP.Items.add('FALSE'); // SET DHCP FLAG TO FALSE
               DebugForm.LBIpSetupDHCPTime.items.add('0'); // SET DHCP TIME FLAG TO ZERO
               ChangeRec.Dhcp:=False;
          End
             else
          Begin
               // Interface uses DHCP
               DebugForm.lbIPSetupDHCP.Items.add('TRUE'); // SET DHCP FLAG TO TRUE
               S:=IniFIle.ReadString(Section+ToStr(IFCounter),'DHCP-TIME','-1'); // CHECK IF THERE IS A DHCP TIME
               IF S<>'-1' Then
               Begin
                    // DHCP TIME PRESENT
                    DebugForm.LBIpSetupDHCPTime.items.add(S);
               End else // NO DHCP TIME PRESENT
               DebugForm.LBIpSetupDHCPTime.items.add('0');
               ChangeRec.Dhcp:=True;
          End;

          S:=IniFile.ReadString(Section+ToStr(IFCounter),'ADDRESS#0','-1');
          IF S<>'-1' Then DebugForm.LBIpSetupIPAdress.items.add(S);
          S:=IniFIle.ReadString(Section+TOStr(IFCounter),'NETMASK#0','-1');

          // Check if there are ALIAS IP's
          AliasCount:=IniFile.ReadInteger(Section+ToStr(IFCounter),'ADDRESS_COUNT',-1);
          IF AliasCount>1 Then
          Begin
               For AliasLoopCounter:=0 TO AliasCount-2 do
               begin
                    //ShowMessage(IniFile.ReadString(Section+ToStr(IFCounter),'ADDRESS#'+ToStr(AliasLoopCounter+1),'-1'));
                    AliasRec.AliasIP[AliasLoopCounter].Add(IniFile.ReadString(Section+ToStr(IFCounter),'ADDRESS#'+ToStr(AliasLoopCounter+1),'-1'));
                    AliasRec.AliasSubnet[AliasLoopCounter].Add(IniFIle.ReadString(Section+TOStr(IFCounter),'NETMASK#'+ToStr(AliasLoopCounter+1),'-1'));
               End;
          End;

          IF S<>'-1' Then DebugForm.LBIpSetupSubnetmask.items.add(S);
          S:=IniFile.ReadString(Section+ToStr(IFCounter),'BROADCAST#0','-1');
          IF S<>'-1' Then DebugForm.LBIpSetupBroadcast.items.add(S);
          S:=IniFile.ReadString(Section+ToStr(IFCOunter),'MTU','-1');
          IF S<>'-1' Then DebugForm.LBIPSetupMTU.items.add(S);
          S:=IniFile.ReadString(Section+ToSTr(IFCounter),'METRIC','-1');
          IF S<>'-1' Then DebugFOrm.LBIPSetupMetric.items.Add(S);
          DebugForm.LBIPSetupTargetAdress.items.add('');

          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'CANONICAL','-1');
          IF S='1' Then DebugFOrm.lbSpSettingsCANONICAL.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsCANONICAL.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'802.3','-1');
          IF S='1' Then DebugForm.lbSpSettings802.items.add('true');
          IF S='0' Then DebugForm.lbSpSettings802.items.add('false');

          S:=IniFile.ReadString(Section+ToStr(IFCounter),'BRIDGE','-1');
          IF S='1' Then DebugForm.lbSpSettingsBRIDGE.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsBRIDGE.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'ARP','-1');
          IF S='1' Then DebugForm.lbSpSettingsARP.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsARP.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'SNAP','-1');
          IF S='1' Then DebugForm.lbSpSettingsSNAP.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsSNAP.items.add('false');

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'TRAILERS','-1');
          IF S='1' Then DebugForm.lbSpSettingsTrailers.items.add('true');
          IF S='0' Then DebugForm.lbSpSettingsTrailers.items.add('false');

          {DebugForm.LBSpSettingsALLRS.Items.add('true');
          DebugForm.LBSpSettingsICMPRED.Items.add('true');}
          s:=IniFile.ReadString(Section+ToStr(IFCounter),'ICMPRED','-1');
          IF S='1' Then DebugForm.LBSpSettingsICMPRED.Items.add('true');
          IF S='0' Then DebugForm.LBSpSettingsICMPRED.Items.add('false');

          s:=IniFile.ReadString(Section+ToStr(IFCounter),'ALLRS','-1');
          IF S='1' Then DebugForm.LBSpSettingsALLRS.Items.add('true');
          IF S='0' Then DebugForm.LBSpSettingsALLRS.Items.add('false');
          {IF S='-1' Then
          Begin
                ShowMessage('Kein ALLRS gefunden !');
                DebugForm.LBSpSettingsALLRS.Items.add('false');
          End;}



          S:=IniFIle.ReadString('Routing'+ToStr(IFCounter),'TYPE','-1');
          IF S<>'-1' Then DebugForm.LBRouteNetType.items.add(S);

          S:=IniFIle.ReadString('Routing'+ToStr(IFCounter),'DESTINATION','-1');
          IF S<>'-1' Then DebugForm.LBRouteTargetAdress.items.add(S);

          S:=IniFile.ReadString('Routing'+ToStr(IFCounter),'NETMASK','-1');
          IF S<>'-1' Then DebugForm.LBRouteSubnetmask.items.add(S);

          S:=IniFIle.ReadString('Routing'+ToStr(IFCounter),'ROUTER','-1');
          IF S<>'-1' Then DebugForm.LBRouteGateway.items.add(S);

          S:=IniFIle.ReadString('Routing'+ToStr(IFCounter),'HOPCOUNT','-1');
          IF S<>'-1' Then DebugForm.LBRouteHopCount.items.add(S);

     End;
     //DebugForm.ShowModal;
     IniFile.Destroy;
End;

Procedure QueryInterfaceFlags2(IFCounter:Byte);
{Querys ONLY the interface attributes stored in os2user.ini, and OVERWRITES the attributes in the debug form}
CONST Section='Interface#';
VAR
   IniFile  :TOS2UserIniFile;
   S        :String;
Begin

          INIFile.Create;
          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'CANONICAL','-1');
          IF S='1' Then DebugFOrm.lbSpSettingsCANONICAL.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettingsCANONICAL.items[IfCounter]:='false';

          S:=IniFIle.ReadString(Section+ToStr(IFCounter),'802.3','-1');
          IF S='1' Then DebugForm.lbSpSettings802.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettings802.items[IfCounter]:='false';

          S:=IniFile.ReadString(Section+ToStr(IFCounter),'BRIDGE','-1');
          IF S='1' Then DebugForm.lbSpSettingsBRIDGE.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettingsBRIDGE.items[IfCounter]:='false';

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'ARP','-1');
          IF S='1' Then DebugForm.lbSpSettingsARP.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettingsARP.items[IfCounter]:='false';

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'SNAP','-1');
          IF S='1' Then DebugForm.lbSpSettingsSNAP.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettingsSNAP.items[IfCounter]:='false';

          S:=IniFIle.ReadString(Section+ToStr(IFCOunter),'TRAILERS','-1');
          IF S='1' Then DebugForm.lbSpSettingsTrailers.items[IfCounter]:='true';
          IF S='0' Then DebugForm.lbSpSettingsTrailers.items[IfCounter]:='false';

          {DebugForm.LBSpSettingsALLRS.Items[IfCounter]:=''true');
          DebugForm.LBSpSettingsICMPRED.Items[IfCounter]:=''true');}
          s:=IniFile.ReadString(Section+ToStr(IFCounter),'ICMPRED','-1');
          IF S='1' Then DebugForm.LBSpSettingsICMPRED.Items[IfCounter]:='true';
          IF S='0' Then DebugForm.LBSpSettingsICMPRED.Items[IFCounter]:='false';

          s:=IniFile.ReadString(Section+ToStr(IFCounter),'ALLRS','-1');
          IF S='1' Then DebugForm.LBSpSettingsALLRS.Items[IFCounter]:='true';
          IF S='0' Then DebugForm.LBSpSettingsALLRS.Items[IFCounter]:='false';
IniFile.Destroy;
End;

{06.10.2006  QueryAmountInterfaces lieferte 2 aktive Interfaces zur�ck obwphl nur 1 installiert war.
 01.11.2006  QueryAmountInterfaces - Umbau auf OS/2 Ini File format
 10.12.2006  Neue Procedure QueryInterfaceFlags
 10.12.2006  Neue Procedure QueryInterfaceSettings
 17.12.2006  Neue Procedure QueryInterfaceFlags2
 20.01.2007  Neue Abfrage in QueryInterfaceSettings auf DHCP Server
}

End.


