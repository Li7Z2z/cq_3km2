unit U_FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, RzEdit, RzBtnEdt, RzLabel,
  RzListVw, RzButton, RzPanel, Mask, Mudutil, MirDB, Share, IniFiles, ShlObj,
  ImageHlp, RzShellDialogs, RzRadChk;

type
  TFrmMain = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    Label1: TLabel;
    CheckBoxRefId: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button1: TButton;
    Cmd_Start: TButton;
    Cmd_Log: TButton;
    Cmd_Exit: TButton;
    GroupBox1: TGroupBox;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    GroupBox2: TGroupBox;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel8: TRzLabel;
    RzGroupBox1: TRzGroupBox;
    RzLabel9: TRzLabel;
    LMainFileCount: TRzLabel;
    CmdMainFilst: TRzButton;
    ListViewMain: TRzListView;
    RzGroupBox2: TRzGroupBox;
    RzLabel11: TRzLabel;
    LSlaveFileCount: TRzLabel;
    CmdSlaveFile: TRzButton;
    ListViewSlave: TRzListView;
    EdtSavePath: TRzButtonEdit;
    EdtMainGuildBase: TRzButtonEdit;
    EdtSlaveGuildBase: TRzButtonEdit;
    EdtMainID: TRzButtonEdit;
    EdtMainHum: TRzButtonEdit;
    EdtMainMir: TRzButtonEdit;
    EdtSlaveID: TRzButtonEdit;
    EdtSlaveHum: TRzButtonEdit;
    EdtSlaveMir: TRzButtonEdit;
    OPDlg1: TOpenDialog;
    CheckBoxStr: TCheckBox;
    CheckBoxSelloff: TCheckBox;
    RzLabel13: TRzLabel;
    Envir1: TRzButtonEdit;
    RzLabel14: TRzLabel;
    Envir2: TRzButtonEdit;
    RzLabel18: TRzLabel;
    RzLabel20: TRzLabel;
    HeroMir1: TRzButtonEdit;
    HumHero1: TRzButtonEdit;
    RzLabel19: TRzLabel;
    RzLabel21: TRzLabel;
    HumHero2: TRzButtonEdit;
    HeroMir2: TRzButtonEdit;
    RzLabel16: TRzLabel;
    Data1Edit1: TRzButtonEdit;
    RzLabel17: TRzLabel;
    Data2Edit1: TRzButtonEdit;
    Label2: TLabel;
    Memo1: TRzMemo;
    ListBox1: TListBox;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    RzButton1: TRzButton;
    RzButton2: TRzButton;
    LabelCopyright: TRzLabel;
    URLLabel1: TRzURLLabel;
    RzLabel10: TRzLabel;
    EditMainDivisionDir: TRzButtonEdit;
    RzLabel12: TRzLabel;
    EditSlaveDivisionDir: TRzButtonEdit;
    procedure EdtSavePathButtonClick(Sender: TObject);
    procedure EdtMainIDButtonClick(Sender: TObject);
    procedure CmdMainFilstClick(Sender: TObject);
    procedure ListViewMainData(Sender: TObject; Item: TListItem);
    procedure CmdSlaveFileClick(Sender: TObject);
    procedure ListViewSlaveData(Sender: TObject; Item: TListItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Cmd_StartClick(Sender: TObject);
    procedure Cmd_LogClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Cmd_ExitClick(Sender: TObject);
    procedure Data1Edit1ButtonClick(Sender: TObject);
    procedure Data2Edit1ButtonClick(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MainFileList, SlaveFileList, MasterNoList, FenghaoList: TStringList;
    AccountList, AccountChangeList, HumList,
      HumChangeList, GuildList, GuildChangeList, DivisionList, DivisionChangeList: TQuickList;
    nItemidx: Cardinal;
    TxtMainPath, TxtSlavePath, rootdir: string;
    function CheckName(Name: string; Len: Integer; var NewName: string; Sel: Byte): Boolean;
    procedure EnabledTo(botype: Boolean);
    procedure AccountAllOne;
    procedure HumAllone;
    procedure MirAllone;
    procedure HeroMirAllone;
    //procedure HumHeroAllone;
    procedure MasterNoAllone;//�ϲ�ʦͽ�ļ�
    procedure FengHaoListNoAllone;//�ϲ��ƺ��б�
    procedure BigStorageNoAllone;//�ϲ����޲ֿ��ļ�
    procedure UserPlacingAllone;
    procedure GuildAllone;
    procedure DivisionDirAllone;//�������ݺϲ�
    procedure TextAllone;
    procedure SaveChangeLog;
    procedure ClearList;
    function GetSubStr(var aString: string; SepChar: string): string;
    procedure GetFileList(APath, SecrchStr: string; vFileList: TStrings);
    procedure RefItemId(var DBRecord: THumDataInfo);//��Ʒ�������
    procedure RefItemIdToHumMir(var DBRecord: TNewHeroDataInfo);//��Ʒ�������(��������)
    function CopyDirAll(sDirName:String;sToDirName:String):Boolean;//����Ŀ¼�µ������ļ�
    //procedure LoadSellOffItemList(const sRoot: string; SellOffItemList:TList; boUpdateName: Boolean);//��ȡԪ����������
  end;

var
  FrmMain: TFrmMain;

implementation
uses U_FrmChange, U_FrmDataEdit, EDcodeUnit;
{$R *.dfm}
//����ָ���ļ� 20080912
function FindFile2(AList: TStrings; const APath: TFileName;
  const Ext: String; const Recurisive: Boolean): Integer;
var
  FSearchRec: TSearchRec;
  FPath: TFileName;
begin
  Result := -1;
  application.ProcessMessages;
  if Assigned(AList) then
  try
    FPath := IncludeTrailingPathDelimiter(APath);
    if FindFirst(FPath + '*.*', faAnyFile, FSearchRec) = 0 then
      repeat
        if (FSearchRec.Attr and faDirectory) = faDirectory then begin
          if Recurisive and (FSearchRec.Name <> '.') and (FSearchRec.Name <> '..') then
            FindFile2(AList, FPath + FSearchRec.Name, Ext, Recurisive);
          if SameText(Ext, FSearchRec.Name) then begin
            AList.Add(FPath + FSearchRec.Name);
          end;
        end else
        if SameText(LowerCase(Ext), LowerCase(ExtractFileName(FSearchRec.Name))) then begin
          AList.Add(FPath + FSearchRec.Name);
        end;
      until FindNext(FSearchRec) <> 0;
  finally
    SysUtils.FindClose(FSearchRec);
    Result := AList.Count;
  end;
end;

//����Ŀ¼�µ������ļ�
function TFrmMain.CopyDirAll(sDirName:String;sToDirName:String):Boolean;
var
  hFindFile:Cardinal;      //��������Ŀ¼(������Ŀ¼)
  t,tfile:String; 
  sCurDir:String[255];
  FindFileData:WIN32_FIND_DATA;
begin
  //�ȱ��浱ǰĿ¼
  sCurDir:=GetCurrentDir;
  ChDir(sDirName);
  hFindFile:=FindFirstFile('*.*',FindFileData);
  if hFindFile <> INVALID_HANDLE_VALUE then begin
    if not DirectoryExists(sToDirName) then ForceDirectories(sToDirName);
    repeat
      tfile:=FindFileData.cFileName;
      if (tfile='.') or (tfile='..') then Continue;
      if FindFileData.dwFileAttributes= FILE_ATTRIBUTE_DIRECTORY then begin
           t:=sToDirName+'\'+tfile;
           if not DirectoryExists(t) then ForceDirectories(t);
           if sDirName[Length(sDirName)]<>'\' then
              CopyDirAll(sDirName+'\'+tfile,t)
           else CopyDirAll(sDirName+tfile,sToDirName+tfile);
      end else begin
        t:=sToDirName+'\'+tFile;
        CopyFile(PChar(tfile),PChar(t),False);
      end;
    until FindNextFile(hFindFile,FindFileData)=false;

    Windows.FindClose(hFindFile);
  end else begin
    ChDir(sCurDir);
    result:=false;
    exit;
  end;
  //�ص�ԭ����Ŀ¼��
  ChDir(sCurDir);
  result:=true;
end;

//��ȡ�ַ���
//�� ArrestStringEx('[1234]','[',']',str)    str=1234
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
var
 { BufCount, SrcCount,} srclen: Integer;
  GoodData{, fin}: Boolean;
  I, N: Integer;
begin
  ArrestStr := ''; {result string}
  if Source = '' then begin
    Result := '';
    Exit;
  end;

  try
    srclen := Length(Source);
    GoodData := False;
    if srclen >= 2 then
      if Source[1] = SearchAfter then begin
        Source := Copy(Source, 2, srclen - 1);
        srclen := Length(Source);
        GoodData := True;
      end else begin
        N := Pos(SearchAfter, Source);
        if N > 0 then begin
          Source := Copy(Source, N + 1, srclen - (N));
          srclen := Length(Source);
          GoodData := True;
        end;
      end;
   // fin := False;
    if GoodData then begin
      N := Pos(ArrestBefore, Source);
      if N > 0 then begin
        ArrestStr := Copy(Source, 1, N - 1);
        Result := Copy(Source, N + 1, srclen - N);
      end else begin
        Result := SearchAfter + Source;
      end;
    end else begin
      for I := 1 to srclen do begin
        if Source[I] = SearchAfter then begin
          Result := Copy(Source, I, srclen - I + 1);
          Break;
        end;
      end;
    end;
  except
    ArrestStr := '';
    Result := '';
  end;
end;

procedure TFrmMain.Data1Edit1ButtonClick(Sender: TObject);
var
  I:Integer;
begin
  if RzSelectFolderDialog1.Execute then begin
    Data1Edit1.Text:= RzSelectFolderDialog1.SelectedPathName;
    if Data1Edit1.Text <> '' then begin
      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'ID.DB',True);
      if (I > 0) and (I < 2) then EdtMainID.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'Hum.DB',True);
      if (I > 0) and (I < 2) then EdtMainHum.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'Mir.DB',True);
      if (I > 0) and (I < 2) then EdtMainMir.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'HeroMir.DB',True);
      if (I > 0) and (I < 2) then HeroMir1.Text:=Trim(ListBox1.Items.Text);

      {ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'HumHero.DB',True);
      if (I > 0) and (I < 2) then HumHero1.Text:=Trim(ListBox1.Items.Text);    }

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'GuildBase',True);
      if (I > 0) and (I < 2) then EdtMainGuildBase.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'DivisionDir',True);
      if (I > 0) and (I < 2) then EditMainDivisionDir.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data1Edit1.Text,'Envir',True);
      if (I > 0) and (I < 2) then Envir1.Text:=Trim(ListBox1.Items.Text);
    end;
  end;
end;

procedure TFrmMain.Data2Edit1ButtonClick(Sender: TObject);
var
  I:Integer;
begin
  if RzSelectFolderDialog1.Execute then begin
    Data2Edit1.Text:= RzSelectFolderDialog1.SelectedPathName;
    if Data2Edit1.Text <> '' then begin
      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'ID.DB',True);
      if (I > 0) and (I < 2) then EdtSlaveID.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'Hum.DB',True);
      if (I > 0) and (I < 2) then EdtSlaveHum.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'Mir.DB',True);
      if (I > 0) and (I < 2) then EdtSlaveMir.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'HeroMir.DB',True);
      if (I > 0) and (I < 2) then HeroMir2.Text:=Trim(ListBox1.Items.Text);

      {ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'HumHero.DB',True);
      if (I > 0) and (I < 2) then HumHero2.Text:=Trim(ListBox1.Items.Text); }

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'GuildBase',True);
      if (I > 0) and (I < 2) then EdtSlaveGuildBase.Text:=Trim(ListBox1.Items.Text);

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'DivisionDir',True);
      if (I > 0) and (I < 2) then EditSlaveDivisionDir.Text:=Trim(ListBox1.Items.Text);      

      ListBox1.Clear;
      I:=FindFile2(ListBox1.Items, Data2Edit1.Text,'Envir',True);
      if (I > 0) and (I < 2) then Envir2.Text:=Trim(ListBox1.Items.Text);
    end;
  end;
end;

function GetDirectoryName(Dir: string): string;
begin
  if Dir[Length(Dir)] <> '\' then Result := Dir + '\'
  else Result := Dir;
end;

function IsDirNotation(ADirName: string): Boolean;
begin
  Result := (ADirName = '.') or (ADirName = '..');
end;

//����·��  ͨ�����*.*    *.txt  ����stringlist���صõ��ļ��б�
procedure TFrmMain.GetFileList(APath, SecrchStr: string; vFileList: TStrings);
var
  FSearchRec,
    DSearchRec: TSearchRec;
  FindResult: integer;
begin
  APath := GetDirectoryName(APath);
  FindResult := FindFirst(APath + SecrchStr, faAnyFile + faHidden +
    faSysFile + faReadOnly, FSearchRec);
  try
    while FindResult = 0 do begin
      //vFileList.Add(UpperCase(APath + FSearchRec.Name));
      vFileList.Add(APath + FSearchRec.Name);
      FindResult := FindNext(FSearchRec);
    end;
    FindResult := FindFirst(APath + '*.*', faDirectory, DSearchRec);
    while FindResult = 0 do begin
      if ((DSearchRec.Attr and faDirectory) = faDirectory) and not
        IsDirNotation(DSearchRec.Name) then
        GetFileList(APath + DSearchRec.Name, SecrchStr, vFileList);
      FindResult := FindNext(DSearchRec);
    end;
  finally
    FindClose(FSearchRec);
  end;
end;

function BrowseProc(hWin: THandle; uMsg: Cardinal; lParam: LPARAM; lpData: LPARAM): LRESULT; stdcall;
begin
  if uMsg = BFFM_INITIALIZED then SendMessage(hWin, BFFM_SETSELECTION, 1, lpData); // �ô������Ĳ�����Ĭ��·��
  Result := 0;
end;

function SelectPath(const Title: string; DefaultDir: PChar): string;
var
  bi: TBrowseInfo;
  IdList: PItemIDList;
  sBuf: array[0..MAX_PATH] of Char;
begin
  Result := '';
  FillChar(bi, SizeOf(bi), 0);
  bi.hwndOwner := Application.Handle;
  bi.lpszTitle := PChar(Title);
  bi.ulFlags := BIF_RETURNONLYFSDIRS + 64; //����64����ʾ"�½��ļ���"��ť
  bi.lpfn := @BrowseProc;
  bi.lParam := LongInt(DefaultDir);

  IdList := SHBrowseForFolder(bi);
  if IdList <> nil then begin
    SHGetPathFromIDList(IdList, @sBuf);
    Result := sBuf;
  end;
end;

procedure TFrmMain.RefItemId(var DBRecord: THumDataInfo);
var
  ii: integer;
begin
  for II := Low(DBRecord.Data.HumItems) to High(DBRecord.Data.HumItems) do begin
    if DBRecord.Data.HumItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.HumItems[II].MakeIndex := nItemIdx;
    end;
  end;

  for II := Low(DBRecord.Data.HumAddItems) to High(DBRecord.Data.HumAddItems) do begin
    if DBRecord.Data.HumAddItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.HumAddItems[II].MakeIndex := nItemIdx;
    end;
  end;

  for II := Low(DBRecord.Data.BagItems) to High(DBRecord.Data.BagItems) do begin
    if DBRecord.Data.BagItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.BagItems[II].MakeIndex := nItemIdx;
    end;
  end;

  for II := Low(DBRecord.Data.StorageItems) to High(DBRecord.Data.StorageItems) do begin
    if DBRecord.Data.StorageItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.StorageItems[II].MakeIndex := nItemIdx;
    end;
  end;
end;

procedure TFrmMain.RefItemIdToHumMir(var DBRecord: TNewHeroDataInfo);
var
  ii: integer;
begin
  for II := Low(DBRecord.Data.HumItems) to High(DBRecord.Data.HumItems) do begin
    if DBRecord.Data.HumItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.HumItems[II].MakeIndex := nItemIdx;
    end;
  end;

  for II := Low(DBRecord.Data.HumAddItems) to High(DBRecord.Data.HumAddItems) do begin
    if DBRecord.Data.HumAddItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.HumAddItems[II].MakeIndex := nItemIdx;
    end;
  end;

  for II := Low(DBRecord.Data.BagItems) to High(DBRecord.Data.BagItems) do begin
    if DBRecord.Data.BagItems[II].wIndex > 0 then begin
      Inc(nItemidx);
      DBRecord.Data.BagItems[II].MakeIndex := nItemIdx;
    end;
  end;
end;

procedure TFrmMain.RzButton1Click(Sender: TObject);
begin
  TxtMainPath := '';
  ListViewMain.Clear;
  MainFileList.Clear;
  LMainFileCount.Caption := IntToStr(MainFileList.Count);
end;

procedure TFrmMain.RzButton2Click(Sender: TObject);
begin
  TxtSlavePath := '';
  ListViewSlave.Clear;
  SlaveFileList.Clear;
  LSlaveFileCount.Caption := IntToStr(SlaveFileList.Count);
end;

function TFrmMain.GetSubStr(var aString: string; SepChar: string): string;
var
  Mystr: string;
  SepCharPos: Integer;
begin
  SepCharPos := Pos(SepChar, aString); //����ָ�����Ӵ��е�λ��
  MyStr := Copy(aString, 1, SepCharPos - 1); //���ָ��ǰ�����ַ��ŵ�mystr����
  Delete(aString, 1, SepCharPos); //��ȥ�ָ���ͷָ��ǰ���Ӵ�
  GetSubStr := MyStr; //����һ���ֶ�
end;

procedure TFrmMain.AccountAllOne;
var
  FIDInfo: TAccountDBRecord;
  FDBRecord, FNewDBRecord: TMirRecord;
  nIndex, I, nRecordCount: Integer;
  NewName: string;
  IdHeader: TIdHeader;
begin
  if FileExists(EdtMainID.Text) then
    FDBRecord := TMirRecord.Create(EdtMainID.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('����ID���ݿⲻ����!');
    Exit;
  end;
  if FileExists(EdtSavePath.Text+'\LoginSrv\IDDB\ID.DB') then DeleteFile(EdtSavePath.Text+'\LoginSrv\IDDB\ID.DB'); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(EdtSavePath.Text+'\LoginSrv\IDDB\ID.DB', fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(FIDInfo);
    FNewDBRecord.HeaderSize := SizeOf(IdHeader);
    try
      FDBRecord.RecSize := SizeOf(FIDInfo);
      FDBRecord.HeaderSize := SizeOf(IdHeader);
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(IdHeader, SizeOf(IdHeader));
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(IdHeader, SizeOf(IdHeader));
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰ�����IDд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to FDBRecord.NumRecs do begin
        FDBRecord.ReadRec(FIDInfo);
        AccountList.AddRecord(FIDInfo.UserEntry.sAccount, i);
        FNewDBRecord.AppendRec(FIDinfo);
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
    finally
      FDBRecord.Free;
    end;
    if FileExists(EdtSlaveID.Text) then
      FDBRecord := TMirRecord.Create(EdtSlaveID.Text, fmShareDenyNone)
    else begin
      Memo1.Lines.add('�ӿ�ID���ݿⲻ����!');
      Exit;
    end;
    try
      FDBRecord.RecSize := SizeOf(FIDInfo);
      FDBRecord.HeaderSize := SizeOf(IdHeader);
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰѴӿ�IDд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to FDBRecord.NumRecs do begin
        FDBRecord.ReadRec(FIDInfo);
        nIndex := AccountList.GetIndex(FIDInfo.UserEntry.sAccount);
        if nIndex <> -1 then begin
          NewName := '';
          if CheckName(FIDInfo.UserEntry.sAccount, 10, NewName, 0) then begin
            FIDInfo.Header.sAccount := NewName;
            FIDInfo.UserEntry.sAccount := NewName;
          end else begin
            FDBRecord.NextRec;
            StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
            Continue;
          end;
        end;
        AccountList.AddRecord(FIDInfo.UserEntry.sAccount, i);
        FNewDBRecord.AppendRec(FIDinfo);
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(IdHeader, SizeOf(IdHeader));
      IdHeader.nIDCount := FNewDBRecord.NumRecs;
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(IdHeader, SizeOf(IdHeader));
    finally
      FDBRecord.Free;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  if FileExists(EdtSlaveMir.Text) then begin
    if FrmDataEdit = nil then FrmDataEdit := TFrmDataEdit.Create(Self);
    FrmDataEdit.ShowModal;
  end else begin
    Application.MessageBox('�������úôӿ�����·��!', '��ʾ��Ϣ', MB_ICONQUESTION);
    Exit;
  end;
end;
//sel: 0-ID  1-Hum 2-�л�
function TFrmMain.CheckName(Name: string; Len: Integer; var NewName: string; Sel: Byte): Boolean;
  function  _Max10ReName(S: string; DefChar: Char): string;
  begin
    if Length(S) >= Len then begin
      case ByteType(S, Length(S)) of
        mbSingleByte: S := Copy(S, 1, Length(S) - 1);
        mbLeadByte,
        mbTrailByte : S := Copy(S, 1, Length(S) - 2);
      end;
    end;
    Result  := S + DefChar;
  end;
var
  StrLen, i, j, nIndex, rplen: Integer;
  wName: WideString;
  TName: string;
  pQuickName: pTQuickName;
begin
  TName := Name;
  rplen := 1;
  Result := False;
  if Length(TName) = Len then begin//���ȵ�����ĵݼ�
    wName := TName;
    StrLen := Length(wName);
    SetLength(wName, StrLen - 1);
    TName := wName; //�ȼ�ȥһ���ַ�
    (*while Length(wName) >= 0 do begin//�������ѭ��
      for j := 97 to 122 do begin
        for I := 97 to 122 do begin// A..Z
          TName := TName + char(i);
          case Sel of
            0: nIndex := AccountList.GetIndex(TName);
            1: nIndex := HumList.GetIndex(TName);
            2: nIndex := GuildList.GetIndex(TName);
            3: nIndex := DivisionList.GetIndex(TName);
          end;
          if nIndex = -1 then begin
            NewName := TName;
            New(pQuickName);
            pQuickName^.sName := Name;
            pQuickName^.sNewName := TName;
            case Sel of
              0: AccountChangeList.AddItemRecord(Name, TObject(pQuickName));
              1: HumChangeList.AddItemRecord(Name, TObject(pQuickName));
              2: GuildChangeList.AddItemRecord(Name, TObject(pQuickName));
              3: DivisionChangeList.AddItemRecord(Name, TObject(pQuickName));
            end;
            Result := True;
            Exit;
          end; // end if nIndex
          SetLength(TName, Length(Tname) - 1);
        end; // end for i
        SetLength(wName, Length(wName) - rplen);
        TName := wName + char(j);
      end; //end for j
      Inc(rplen);
    end; //end while  *)
    for j := 97 to 122 do begin//20110819 �޸�
      for I := 97 to 122 do begin// A..Z
        TName := _Max10ReName(TName, char(I));
        case Sel of
          0: nIndex := AccountList.GetIndex(TName);
          1: nIndex := HumList.GetIndex(TName);
          2: nIndex := GuildList.GetIndex(TName);
          3: nIndex := DivisionList.GetIndex(TName);
        end;
        if nIndex = -1 then begin
          NewName := TName;
          New(pQuickName);
          pQuickName^.sName := Name;
          pQuickName^.sNewName := TName;
          case Sel of
            0: AccountChangeList.AddItemRecord(Name, TObject(pQuickName));
            1: HumChangeList.AddItemRecord(Name, TObject(pQuickName));
            2: GuildChangeList.AddItemRecord(Name, TObject(pQuickName));
            3: DivisionChangeList.AddItemRecord(Name, TObject(pQuickName));
          end;
          Result := True;
          Exit;
        end; // end if nIndex
      end;
      SetLength(wName, Length(wName) - rplen);
      TName := wName + char(j);
    end;
    while True do begin
      TName := IntToHex(Random(MaxInt), Len);
      case Sel of
        0: nIndex := AccountList.GetIndex(TName);
        1: nIndex := HumList.GetIndex(TName);
        2: nIndex := GuildList.GetIndex(TName);
        3: nIndex := DivisionList.GetIndex(TName);
      end;
      if nIndex = -1 then begin
        NewName := TName;
        New(pQuickName);
        pQuickName^.sName := Name;
        pQuickName^.sNewName := TName;
        case Sel of
          0: AccountChangeList.AddItemRecord(Name, TObject(pQuickName));
          1: HumChangeList.AddItemRecord(Name, TObject(pQuickName));
          2: GuildChangeList.AddItemRecord(Name, TObject(pQuickName));
          3: DivisionChangeList.AddItemRecord(Name, TObject(pQuickName));
        end;
        Result := True;
        Exit;
      end; // end if nIndex
    end;    
  end else begin//if Length(TName) = Len then
    wName := TName;
    while Length(TName) + 1 <= Len do begin
      for j := 97 to 122 do begin
        for I := 97 to 122 do begin// A..Z
          TName := TName + char(i);
          case Sel of
            0: nIndex := AccountList.GetIndex(TName);
            1: nIndex := HumList.GetIndex(TName);
            2: nIndex := GuildList.GetIndex(TName);
            3: nIndex := DivisionList.GetIndex(TName);
          end;
          if nIndex = -1 then begin
            NewName := TName;
            New(pQuickName);
            pQuickName^.sName := Name;
            pQuickName^.sNewName := TName;
            case Sel of
              0: AccountChangeList.AddItemRecord(Name, TObject(pQuickName));
              1: HumChangeList.AddItemRecord(Name, TObject(pQuickName));
              2: GuildChangeList.AddItemRecord(Name, TObject(pQuickName));
              3: DivisionChangeList.AddItemRecord(Name, TObject(pQuickName));
            end;
            Result := True;
            Exit;
          end; // end if nIndex
          SetLength(TName, Length(Tname) - 1);
        end; // end for i
        TName := wName + char(j);
      end; //end for j
      wName := TName;
    end; //end while
  end; //else begin
end;

procedure TFrmMain.ClearList;
var
  i, j, nRecordCount: Integer;
  pQuickName: pTQuickName;
begin
  AccountList.Clear;
  HumList.Clear;
  GuildList.Clear;
  DivisionList.Clear;
  Application.ProcessMessages;
  Memo1.Lines.add('�����ͷ���ʱ����...');
  StatusBar1.Panels[1].Text := '';
  j := 0;
  nRecordCount := AccountChangeList.Count + HumChangeList.Count + GuildChangeList.Count + DivisionChangeList.Count;
  if AccountChangeList.Count > 0 then begin
    for I := 0 to AccountChangeList.Count - 1 do begin
      pQuickName := pTQuickName(AccountChangeList.Objects[i]);
      AccountChangeList.Objects[i] := nil;
      try
        if pQuickName <> nil then Dispose(pQuickName);
      except
      end;
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((j / nRecordCount) * 100)) + '%';
      Inc(j);
      Application.ProcessMessages;
    end;
    AccountChangeList.Clear;
  end;

  if HumChangeList.Count > 0 then begin
    for I := 0 to HumChangeList.Count - 1 do begin
      pQuickName := pTQuickName(HumChangeList.Objects[i]);
      HumChangeList.Objects[i] := nil;
      try
        if pQuickName <> nil then Dispose(pQuickName);
      except
      end;
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((j / nRecordCount) * 100)) + '%';
      Inc(j);
      Application.ProcessMessages;
    end;
    HumChangeList.Clear;
  end;

  if GuildChangeList.Count > 0 then  begin
    for I := 0 to GuildChangeList.Count - 1 do begin
      pQuickName := pTQuickName(GuildChangeList.Objects[i]);
      GuildChangeList.Objects[i] := nil;
      try
        if pQuickName <> nil then Dispose(pQuickName);
      except
      end;
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((j / nRecordCount) * 100)) + '%';
      Inc(j);
      Application.ProcessMessages;
    end;
    GuildChangeList.Clear;
  end;

  if DivisionChangeList.Count > 0 then  begin
    for I := 0 to DivisionChangeList.Count - 1 do begin
      pQuickName := pTQuickName(DivisionChangeList.Objects[i]);
      DivisionChangeList.Objects[i] := nil;
      try
        if pQuickName <> nil then Dispose(pQuickName);
      except
      end;
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((j / nRecordCount) * 100)) + '%';
      Inc(j);
      Application.ProcessMessages;
    end;
    DivisionChangeList.Clear;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
end;

procedure TFrmMain.CmdMainFilstClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := SelectPath('��ѡ���������ı�·��', PChar(rootdir));
  if Dir = '' then Exit;
  TxtMainPath := Dir;
  MainFileList.Clear;
  GetFileList(Dir, '*.txt', MainFileList);
  ListViewMain.Items.BeginUpdate;
  ListViewMain.Items.Count := MainFileList.Count;
  ListViewMain.Items.EndUpdate;
  LMainFileCount.Caption := IntToStr(MainFileList.Count);
end;

procedure TFrmMain.CmdSlaveFileClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := SelectPath('��ѡ��������ı�·��', PChar(rootdir));
  if Dir = '' then Exit;
  TxtSlavePath := Dir;
  SlaveFileList.Clear;
  GetFileList(Dir, '*.txt', SlaveFileList);
  ListViewSlave.Items.BeginUpdate;
  ListViewSlave.Items.Count := SlaveFileList.Count;
  ListViewSlave.Items.EndUpdate;
  LSlaveFileCount.Caption := IntToStr(SlaveFileList.Count);
end;

procedure TFrmMain.Cmd_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.Cmd_LogClick(Sender: TObject);
begin
  if FrmChange = nil then FrmChange := TFrmChange.Create(self);
  FrmChange.ShowModal;
end;

procedure TFrmMain.EnabledTo(botype: Boolean);
begin
  EdtSavePath.Enabled := botype;
  CheckBoxRefId.Enabled := botype;
  CheckBoxStr.Enabled := botype;
  CheckBoxSelloff.Enabled := botype;
  Data1Edit1.Enabled := botype;
  EdtMainID.Enabled := botype;
  EdtMainHum.Enabled := botype;
  EdtMainMir.Enabled := botype;
  HeroMir1.Enabled := botype;
  //HumHero1.Enabled := botype;
  EdtMainGuildBase.Enabled := botype;
  EditMainDivisionDir.Enabled := botype;
  Envir1.Enabled := botype;
  Data2Edit1.Enabled := botype;
  EdtSlaveID.Enabled := botype;
  EdtSlaveHum.Enabled := botype;
  EdtSlaveMir.Enabled := botype;
  HeroMir2.Enabled := botype;
  //HumHero2.Enabled := botype;
  EdtSlaveGuildBase.Enabled := botype;
  EditSlaveDivisionDir.Enabled := botype;
  Envir2.Enabled := botype;
end;

procedure TFrmMain.Cmd_StartClick(Sender: TObject);
begin
  if (EdtSavePath.Text = '') or (EdtMainID.Text = '') or (EdtMainHum.Text = '') or (EdtMainMir.Text = '')
    or (EdtSlaveID.Text = '') or (EdtSlaveHum.Text = '') or (EdtSlaveMir.Text = '') or (trim(Envir1.text)='')
    or (trim(Envir2.text)='') then
  begin
    Application.MessageBox('�������ú�·��!', '��ʾ��Ϣ', MB_ICONQUESTION);
    Exit;
  end else begin
    Memo1.Text:='';
    Cmd_Start.Enabled := False;
    if not DirectoryExists(EdtSavePath.Text+'\LoginSrv\IDDB') then ForceDirectories(EdtSavePath.Text+'\LoginSrv\IDDB\');
    if not DirectoryExists(EdtSavePath.Text+'\DBServer\FDB') then ForceDirectories(EdtSavePath.Text+'\DBServer\FDB');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\GuildBase\Guilds') then ForceDirectories(EdtSavePath.Text+'\Mir200\GuildBase\Guilds');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\DivisionDir\Divisions') then ForceDirectories(EdtSavePath.Text+'\Mir200\DivisionDir\Divisions');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\Envir\UserData') then ForceDirectories(EdtSavePath.Text+'\Mir200\Envir\UserData');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\Envir\MasterNo') then ForceDirectories(EdtSavePath.Text+'\Mir200\Envir\MasterNo');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\Envir\Market_Storage') then ForceDirectories(EdtSavePath.Text+'\Mir200\Envir\Market_Storage');
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\HuHua') then ForceDirectories(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\HuHua'); //Ŀ¼������,�򴴽�
    if not DirectoryExists(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\Comrade') then ForceDirectories(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\Comrade'); //Ŀ¼������,�򴴽�
    EnabledTo(False);
    ClearList;//��ʼ�б�
    nItemidx := 1;
    AccountAllOne;//�ϲ�ID.db--OK
    HumAllone;//�ϲ�Hum.DB--OK
    MirAllone;//�ϲ�Mir.db--OK
    HeroMirAllone;//�ϲ�HeroMir.db--OK
    //HumHeroAllone;//�ϲ�HumHero.db--OK
    if CheckBoxSelloff.Checked then UserPlacingAllone;//�ϲ���������--OK
    if CheckBoxStr.Checked then BigStorageNoAllone;//�ϲ����޲ֿ��ļ�--OK
    GuildAllone;//�л�ϲ�--OK
    DivisionDirAllone;//�������ݺϲ�
    TextAllone;//�ı��ϲ�--OK
    MasterNoAllone;//�ϲ�ʦͽ�ļ�--OK
    FengHaoListNoAllone;//�ϲ��ƺ��б�
    SaveChangeLog;//����Ķ�����Ϣ
    Cmd_Start.Enabled := True;
    EnabledTo(True);
    Memo1.Lines.add('���ݺϲ��Ѿ����!');
  end;
end;

procedure TFrmMain.EdtMainIDButtonClick(Sender: TObject);
begin
  OPDlg1.InitialDir := rootdir;
  if (Sender = EdtMainID) or (Sender = EdtSlaveID) then OPDlg1.FileName := 'ID.DB'
  else if (Sender = EdtMainHum) or (Sender = EdtSlaveHum) then OPDlg1.FileName := 'Hum.DB'
  else if (Sender = EdtMainMir) or (Sender = EdtSlaveMir) then OPDlg1.FileName := 'Mir.DB'
  else if (Sender = HeroMir1) or (Sender = HeroMir2) then OPDlg1.FileName := 'HeroMir.DB'
  {else if (Sender = HumHero1) or (Sender = HumHero2) then OPDlg1.FileName := 'HumHero.DB'};

  if OPDlg1.Execute then begin
    rootdir := PChar(ExtractFilePath(OPDlg1.FileName));
    if Sender = EdtMainID then EdtMainID.Text := OPDlg1.FileName
    else if Sender = EdtMainHum then EdtMainHum.Text := OPDlg1.FileName
    else if Sender = EdtMainMir then EdtMainMir.Text := OPDlg1.FileName
    else if Sender = EdtSlaveID then EdtSlaveID.Text := OPDlg1.FileName
    else if Sender = EdtSlaveHum then EdtSlaveHum.Text := OPDlg1.FileName
    else if Sender = EdtSlaveMir then EdtSlaveMir.Text := OPDlg1.FileName
    else if Sender = HeroMir1 then HeroMir1.Text := OPDlg1.FileName
    else if Sender = HeroMir2 then HeroMir2.Text := OPDlg1.FileName
    {else if Sender = HumHero1 then HumHero1.Text := OPDlg1.FileName
    else if Sender = HumHero2 then HumHero2.Text := OPDlg1.FileName};
  end;
end;

procedure TFrmMain.EdtSavePathButtonClick(Sender: TObject);
var
  sTitle, Dir: string;
begin
  if Sender = EdtSavePath then sTitle := '��ѡ�񱣴�Ŀ¼'
  else if Sender = EdtMainGuildBase then sTitle := '��ѡ�����л�Ŀ¼'
  else if Sender = EdtSlaveGuildBase then sTitle := '��ѡ����л�Ŀ¼'
  else if Sender = EditMainDivisionDir then sTitle := '��ѡ��������Ŀ¼'
  else if Sender = EditSlaveDivisionDir then sTitle := '��ѡ���������Ŀ¼'
  else if Sender = Envir1 then sTitle := '��ѡ����EnvirĿ¼'
  else if Sender = Envir2 then sTitle := '��ѡ���EnvirĿ¼';

  Dir := SelectPath(sTitle, PChar(rootdir));
  if Dir <> '' then begin
    rootdir := dir;
    if Sender = EdtSavePath then EdtSavePath.Text := Dir
    else if Sender = EdtSlaveGuildBase then EdtSlaveGuildBase.Text := Dir
    else if Sender = EdtMainGuildBase then EdtMainGuildBase.Text := Dir
    else if Sender = EditSlaveDivisionDir then EditSlaveDivisionDir.Text := Dir
    else if Sender = EditMainDivisionDir then EditMainDivisionDir.Text := Dir
    else if Sender = Envir1 then Envir1.Text := Dir
    else if Sender = Envir2 then Envir2.Text := Dir;
  end;
end;
//�������ݺϲ�
procedure TFrmMain.DivisionDirAllone;
var
  s, L: TStringList;
  I, j, LStat, Lend, nIndex, nRecordCount, nStr: Integer;
  NewName, sStr, sName: string;
  IniFile: TIniFile;//Ini�ļ�
  function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
  const
    BUF_SIZE = 20480; //$7FFF;
  var
    buf: array[0..BUF_SIZE] of Char;
    BufCount, Count, srclen, I, ArrCount: LongInt;
    Ch: Char;
  label
    CATCH_DIV;
  begin
    Ch := #0; //Jacky
    try
      srclen := Length(Str);
      BufCount := 0;
      Count := 1;

      if srclen >= BUF_SIZE - 1 then begin
        Result := '';
        Dest := '';
        Exit;
      end;

      if Str = '' then begin
        Dest := '';
        Result := Str;
        Exit;
      end;
      ArrCount := SizeOf(Divider) div SizeOf(Char);

      while True do begin
        if Count <= srclen then begin
          Ch := Str[Count];
          for I := 0 to ArrCount - 1 do
            if Ch = Divider[I] then
              goto CATCH_DIV;
        end;
        if (Count > srclen) then begin
          CATCH_DIV:
          if (BufCount > 0) then begin
            if BufCount < BUF_SIZE - 1 then begin
              buf[BufCount] := #0;
              Dest := string(buf);
              Result := Copy(Str, Count + 1, srclen - Count);
            end;
            Break;
          end else begin
            if (Count > srclen) then begin
              Dest := '';
              Result := Copy(Str, Count + 2, srclen - 1);
              Break;
            end;
          end;
        end else begin
          if BufCount < BUF_SIZE - 1 then begin
            buf[BufCount] := Ch;
            Inc(BufCount);
          end; // else
          //ShowMessage ('BUF_SIZE overflow !');
        end;
        Inc(Count);
      end;
    except
      Dest := '';
      Result := '';
    end;
  end;
begin
  if not FileExists(EditMainDivisionDir.Text + '\DivisionList.txt') then begin
    Memo1.Lines.add('����DivisionList.txt������!');
    Exit;
  end;
  CopyFile(PChar(EditMainDivisionDir.Text + '\ApplyDivisionList.txt'), PChar(EdtSavePath.Text + '\Mir200\DivisionDir\' +'\ApplyDivisionList.txt'), False);
  if FileExists(EditSlaveDivisionDir.Text + '\ApplyDivisionList.txt') then DeleteFile(EditSlaveDivisionDir.Text + '\ApplyDivisionList.txt'); //ɾ�������ļ�
  s := TStringList.Create;
  try
    S.LoadFromFile(EditMainDivisionDir.Text + '\DivisionList.txt');

    Memo1.Lines.add('���ڸ���������������');
    StatusBar1.Panels[1].Text := '';
    Application.ProcessMessages;
    nRecordCount := s.Count;
    for I := 0 to nRecordCount - 1 do begin
      DivisionList.AddRecord(s[i], i);
      CopyFile(PChar(EditMainDivisionDir.Text + '\Divisions\' + s[i] + '.txt'), PChar(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + s[i] + '.txt'), False);
      CopyFile(PChar(EditMainDivisionDir.Text + '\Divisions\' + s[i] + '.ini'), PChar(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + s[i] + '.ini'), False);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
    end;

   //��ȡ�ӿ������б��¿��в������ظ��ĸ���
    s.Clear;
    if not FileExists(EditSlaveDivisionDir.Text + '\DivisionList.txt') then begin
      Memo1.Lines.add('�ӿ�DivisionList.txt������!');
      Exit;
    end;
    s.LoadFromFile(EditSlaveDivisionDir.Text + '\DivisionList.txt');
    Memo1.Lines.add('���ڴ���ӿ���������');
    StatusBar1.Panels[1].Text := '';
    nRecordCount := s.Count;
    for I := 0 to nRecordCount - 1 do begin
      if s[i] = '����ʦ��' then Continue;//����
      nIndex := DivisionList.GetIndex(s[i]);
      if nIndex <> -1 then begin//�����������ظ��ı��
        NewName := '';
        if CheckName(s[i], 14, NewName, 3) then begin
          DivisionList.AddRecord(NewName, i);
        end;
      end else DivisionList.AddRecord(s[i], i);
    end;

    try
      L := TStringList.Create;
      for I := 0 to S.Count - 1 do begin
        l.Clear;
        if FileExists(EditSlaveDivisionDir.Text + '\Divisions\' + s[i] + '.txt') then begin //�п����л��ļ�������
          L.LoadFromFile(EditSlaveDivisionDir.Text + '\Divisions\' + s[i] + '.txt');

          lEND := L.IndexOf('ʦ�ų�Ա');
          for j := Lend + 1 to L.Count - 1 do begin//�������ɳ�Ա��������
            NewName := L[J];
            if (NewName <> '') and (NewName[1] = '+') then begin //ȥ����һ���ַ���+   *����ʦ��
              NewName := Copy(L[J], 2, Length(L[J]) - 1);//ȥ��+��
              sStr := GetValidStr3(NewName, sName, ['|']);//����
              if sName = '*����ʦ��' then Continue;//����
              nIndex := HumChangeList.GetIndex(sName);
              if nIndex <> -1 then begin
                L[J] := '+' + pTQuickName(HumChangeList.Objects[nIndex])^.sNewName +'|'+ sStr;
              end;
            end;
          end; //end for j
          //������������
          lEND := L.IndexOf('��������');
          for j := L.Count - 1 downto Lend + 1 do begin//����������ŵ�������
            NewName := L[J];
            if (NewName <> '') and (NewName[1] = '+') then begin //ȥ����һ���ַ���+
              L.Delete(J);
            end;
          end; //end for j

          //�����л�
          nIndex := DivisionChangeList.GetIndex(s[i]);
          if nIndex <> -1 then begin
            L.SaveToFile(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + pTQuickName(DivisionChangeList.Objects[nIndex])^.sNewName + '.txt');
            CopyFile(PChar(EditSlaveDivisionDir.Text + '\Divisions\' + s[i] + '.ini'),
                     PChar(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + pTQuickName(DivisionChangeList.Objects[nIndex])^.sNewName + '.ini'),
                     True);
            IniFile := TIniFile.Create(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + pTQuickName(DivisionChangeList.Objects[nIndex])^.sNewName + '.ini');
            try
              IniFile.Writestring('Division', 'DivisionName', pTQuickName(DivisionChangeList.Objects[nIndex])^.sNewName);
            finally
              IniFile.Free;
            end;
          end else begin
            L.SaveToFile(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + s[i] + '.txt');
            CopyFile(PChar(EditSlaveDivisionDir.Text + '\Divisions\' + '.ini'),
                     PChar(EdtSavePath.Text + '\Mir200\DivisionDir\Divisions\' + s[i] + '.ini'),
                     True);
          end;
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
        end; //if FileExists
      end; //end for i
    finally
      L.Free;
    end;
    DivisionList.SaveToFile(EdtSavePath.Text + '\Mir200\DivisionDir\DivisionList.txt');
  finally
    S.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
end;

procedure TFrmMain.GuildAllone;
var
  s, L: TStringList;
  I, j, LStat, Lend, nIndex, nRecordCount: Integer;
  NewName: string;
  IniFile: TIniFile;//Ini�ļ�
begin
  if not FileExists(EdtMainGuildBase.Text + '\GuildList.txt') then begin
    Memo1.Lines.add('����GuildList.txt������!');
    Exit;
  end;
  s := TStringList.Create;
  try
    S.LoadFromFile(EdtMainGuildBase.Text + '\GuildList.txt');

    Memo1.Lines.add('���ڸ��������л�����');
    StatusBar1.Panels[1].Text := '';
    Application.ProcessMessages;
    nRecordCount := s.Count;
    for I := 0 to nRecordCount - 1 do begin
      GuildList.AddRecord(s[i], i);
      CopyFile(PChar(EdtMainGuildBase.Text + '\Guilds\' + s[i] + '.txt'), PChar(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + s[i] + '.txt'), False);
      CopyFile(PChar(EdtMainGuildBase.Text + '\Guilds\' + s[i] + '.ini'), PChar(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + s[i] + '.ini'), False);
      StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
    end;

   //��ȡ�ӿ��л��б��¿��в������ظ��ĸ���
    s.Clear;
    if not FileExists(EdtSlaveGuildBase.Text + '\GuildList.txt') then begin
      Memo1.Lines.add('�ӿ�GuildList.txt������!');
      Exit;
    end;
    s.LoadFromFile(EdtSlaveGuildBase.Text + '\GuildList.txt');
    Memo1.Lines.add('���ڴ���ӿ��л�����');
    StatusBar1.Panels[1].Text := '';
    nRecordCount := s.Count;
    for I := 0 to nRecordCount - 1 do begin
      nIndex := GuildList.GetIndex(s[i]);
      if nIndex <> -1 then begin//�л��������ظ��ı��
        NewName := '';
        if CheckName(s[i], 14, NewName, 2) then begin
          GuildList.AddRecord(NewName, i);
        end;
      end else GuildList.AddRecord(s[i], i);
    end;

    try
      L := TStringList.Create;
      for I := 0 to S.Count - 1 do begin
        l.Clear;
        if FileExists(EdtSlaveGuildBase.Text + '\Guilds\' + s[i] + '.txt') then begin //�п����л��ļ�������
          L.LoadFromFile(EdtSlaveGuildBase.Text + '\Guilds\' + s[i] + '.txt');
      //���µж��л���л�����
          LStat := L.IndexOf('�ж��л�');
          lEND := L.IndexOf('�����л�');
          for J := LStat + 1 to Lend - 1 do begin
            if (L[J] <> '') and (L[J][1] = '+') then begin
              NewName:='';
              ArrestStringEx(L[J], '+', ' ', NewName);
              nIndex := GuildChangeList.GetIndex(NewName);
              if nIndex <> -1 then begin
                L[J] := '+' + pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName;
              end;
            end;
          end; //end for j

        //���������л���л�����
          LStat := Lend;
          lEND := L.IndexOf('�л��Ա');
          for J := LStat + 1 to lEND - 1 do begin
            if (L[J] <> '') and (L[J][1] = '+') then begin
              nIndex := GuildChangeList.GetIndex(Copy(L[J], 2, Length(L[J]) - 1));
              if nIndex <> -1 then begin
                L[J] := '+' + pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName;
              end;
            end;
          end; //end for j

          lEND := L.IndexOf('�л��Ա');
        //�����л��Ա��������
          for j := Lend + 1 to L.Count - 1 do begin
            NewName := L[J];
            if (NewName <> '') and (NewName[1] = '+') then begin //ȥ����һ���ַ���+
              nIndex := HumChangeList.GetIndex(Copy(L[J], 2, Length(L[J]) - 1));
              if nIndex <> -1 then begin
                L[J] := '+' + pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
              end;
            end;
          end; //end for j

          //�����л�
          nIndex := GuildChangeList.GetIndex(s[i]);
          if nIndex <> -1 then begin
            L.SaveToFile(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName + '.txt');
            CopyFile(PChar(EdtSlaveGuildBase.Text + '\Guilds\' + s[i] + '.ini'),
                     PChar(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName + '.ini'),
                     True);
            IniFile := TIniFile.Create(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName + '.ini');
            try
              IniFile.Writestring('Guild', 'GuildName', pTQuickName(GuildChangeList.Objects[nIndex])^.sNewName);
            finally
              IniFile.Free;
            end;
          end else begin
            L.SaveToFile(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + s[i] + '.txt');
            CopyFile(PChar(EdtSlaveGuildBase.Text + '\Guilds\' + '.ini'),
                     PChar(EdtSavePath.Text + '\Mir200\GuildBase\Guilds\' + s[i] + '.ini'),
                     True);
          end;
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
        end; //if FileExists
      end; //end for i
    finally
      L.Free;
    end;
    GuildList.SaveToFile(EdtSavePath.Text + '\Mir200\GuildBase\GuildList.txt');
  finally
    S.Free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
end;

procedure TFrmMain.ListViewMainData(Sender: TObject; Item: TListItem);
begin
  if (Item.Index > MainFileList.Count) or (MainFileList.Count <= 0) then Exit;
  Item.Caption := IntToStr(Item.Index);
  Item.SubItems.Add(MainFileList[Item.Index]);
end;

procedure TFrmMain.ListViewSlaveData(Sender: TObject; Item: TListItem);
begin
  if (Item.Index > SlaveFileList.Count) or (SlaveFileList.Count <= 0) then Exit;
  Item.Caption := IntToStr(Item.Index);
  Item.SubItems.Add(SlaveFileList[Item.Index]);
end;

procedure TFrmMain.HumAllone;
var
  FHumInfo: THumInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  nIndex, I, nRecordCount: Integer;
  NewName: string;
  DBHeader: TDBHeader;
begin
  if FileExists(EdtMainHum.Text) then
    FDBRecord := TMirRecord.Create(EdtMainHum.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('����Hum���ݿⲻ����!');
    Exit;
  end;

  if FileExists(EdtSavePath.Text+'\DBServer\FDB\Hum.DB') then DeleteFile(EdtSavePath.Text+'\DBServer\FDB\Hum.DB'); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(EdtSavePath.Text+'\DBServer\FDB\Hum.DB', fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(FHumInfo);
    FNewDBRecord.HeaderSize := SizeOf(TDBHeader);
    try
      FDBRecord.RecSize := SizeOf(FHumInfo);
      FDBRecord.HeaderSize := SizeOf(TDBHeader);
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰ�����Humд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(FHumInfo);
        HumList.AddRecord(FHumInfo.sChrName, i);
        FNewDBRecord.AppendRec(FHumInfo);
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
    finally
      FDBRecord.Free;
    end;
    if FileExists(EdtSlaveHum.Text) then
      FDBRecord := TMirRecord.Create(EdtSlaveHum.Text, fmShareDenyNone)
    else begin
      Memo1.Lines.add('�ӿ�Hum���ݿⲻ����!');
      Exit;
    end;
    try
      FDBRecord.RecSize := SizeOf(FHumInfo);
      FDBRecord.HeaderSize := SizeOf(TDBHeader);
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰѴӿ�Humд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(FHumInfo);
        nIndex := HumList.GetIndex(FHumInfo.sChrName);
        if nIndex <> -1 then begin//�����������ظ��ı��
          NewName := '';
          if CheckName(FHumInfo.sChrName, 14, NewName, 1) then begin
            FHumInfo.sChrName := NewName;
            FHumInfo.Header.sName := NewName;
          end else begin
            FDBRecord.NextRec;
            StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
            Continue;
          end;
        end;
        nIndex := AccountChangeList.GetIndex(FHumInfo.sAccount);
        if nIndex <> -1 then begin//�ʺ��б���а��ʺű��
          FHumInfo.sAccount := pTQuickName(AccountChangeList.Objects[nIndex])^.sNewName;
        end;
        HumList.AddRecord(FHumInfo.sChrName, i);
        FNewDBRecord.AppendRec(FHumInfo);
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      DBHeader.nHumCount := FNewDBRecord.NumRecs;
      DBHeader.sDesc := sDBHeaderDesc;
      DBHeader.n70:= nDBVersion;
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    finally
      FDBRecord.Free;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;

{//��ȡԪ����������
procedure TFrmMain.LoadSellOffItemList(const sRoot: string; SellOffItemList:TList; boUpdateName: Boolean);
var
  f_H: THandle;
  DealOffInfo: pTDealOffInfo;
  sDealOffInfo: TDealOffInfo;
  nIndex, I: Integer;
begin
  if not FileExists(sRoot) then  Exit;
  f_H := FileOpen(sRoot, fmOpenRead or fmShareDenyNone);
  if f_H <= 0 then Raise Exception.Create('���ļ�ʧ��! ' + #13 + sRoot);
  if SellOffItemList = nil then Exit;
  if f_H > 0 then begin
    try
      while FileRead(f_H, sDealOffInfo, Sizeof(TDealOffInfo)) = Sizeof(TDealOffInfo) do begin// ѭ��������������
        if (sDealOffInfo.N = 0) or (sDealOffInfo.N = 1) or (sDealOffInfo.N = 3) then begin//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 3-������ȡ�� �Ž��кϲ� 20090331
          New(DealOffInfo);
          if boUpdateName then begin
            nIndex := HumChangeList.GetIndex(sDealOffInfo.sDealCharName);
            if nIndex <> -1 then DealOffInfo.sDealCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��
            nIndex := HumChangeList.GetIndex(sDealOffInfo.sBuyCharName);
            if nIndex <> -1 then DealOffInfo.sBuyCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��
          end else begin
            DealOffInfo.sDealCharName:= sDealOffInfo.sDealCharName;
            DealOffInfo.sBuyCharName:= sDealOffInfo.sBuyCharName;
          end;
          DealOffInfo.dSellDateTime:= sDealOffInfo.dSellDateTime;
          DealOffInfo.nSellGold:= sDealOffInfo.nSellGold;
          DealOffInfo.UseItems:= sDealOffInfo.UseItems;
          if CheckBoxRefId.Checked then begin
            for I := 0 to 9 do begin
              Inc(nItemidx);
              DealOffInfo.UseItems[I].MakeIndex := nItemIdx;
            end;
          end;
          DealOffInfo.N:= sDealOffInfo.N;
          SellOffItemList.Add(DealOffInfo);
          Application.ProcessMessages;
        end;
      end;
    except
    end;
    FileClose(f_H);
  end;
end;

//����Ԫ����������
procedure SaveSellOffItemList(const sRoot: string; SellOffItemList:TList);
var
  FileHandle: Integer;
  DealOffInfo: pTDealOffInfo;
  I: Integer;
begin
  if FileExists(sRoot) then DeleteFile(sRoot);
  FileHandle := FileCreate(sRoot);
  FileClose(FileHandle);
  if FileExists(sRoot) then begin
    FileHandle := FileOpen(sRoot, fmOpenWrite or fmShareDenyNone);
    if FileHandle > 0 then begin
      FileSeek(FileHandle, 0, 0);
      try
        for I:= 0 to SellOffItemList.Count -1 do begin
          DealOffInfo:= pTDealOffInfo(SellOffItemList.Items[I]);
          FileWrite(FileHandle, DealOffInfo^, SizeOf(TDealOffInfo));
          Dispose(DealOffInfo);
          Application.ProcessMessages;
        end;
      except
      end;
      FileClose(FileHandle);
    end;
  end;
end;

procedure TFrmMain.UserPlacingAllone;
var
  nIndex, I, nRecordCount: Integer;
  sSaveConsignation, sMainConsignation, sSlaveConsignation: string;
  SellOffItemList:TList;
begin
  sSaveConsignation := EdtSavePath.Text + '\Mir200\Envir\' + USERDATADIR + SAVEITEMNAME;//����ļ����ļ�
  MakeSureDirectoryPathExists(PChar(sSaveConsignation));
  sMainConsignation := Envir1.text+ USERDATADIR + SAVEITEMNAME;//����ļ����ļ�
  sSlaveConsignation := Envir2.text+ USERDATADIR + SAVEITEMNAME;//�ӿ�ļ����ļ�
  if FileExists(sSaveConsignation) then DeleteFile(sSaveConsignation); //����ļ���������ɾ��
  SellOffItemList:=TList.Create;
  try
    LoadSellOffItemList(sMainConsignation, SellOffItemList, False);//��ȡ�����������
    LoadSellOffItemList(sSlaveConsignation, SellOffItemList, True);//��ȡ�ӿ��������
    Memo1.Lines.add('���ڱ����������');
    SaveSellOffItemList(sSaveConsignation, SellOffItemList);
  finally
    SellOffItemList.Free;
  end;
end;}

procedure TFrmMain.UserPlacingAllone;
var
  sSaveConsignation, sMainConsignation, sSlaveConsignation: string;
  I, K, nIndex, nRecordCount: Integer;
  DealOffInfo: TDealOffInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
begin
  sSaveConsignation := EdtSavePath.Text + '\Mir200\Envir\' + USERDATADIR + SAVEITEMNAME;//����ļ����ļ�
  MakeSureDirectoryPathExists(PChar(sSaveConsignation));
  sMainConsignation := Envir1.text+'\'+ USERDATADIR + SAVEITEMNAME;//����ļ����ļ�
  sSlaveConsignation := Envir2.text+'\'+ USERDATADIR + SAVEITEMNAME;//�ӿ�ļ����ļ�
  if FileExists(sSaveConsignation) then DeleteFile(sSaveConsignation); //����ļ���������ɾ��
//----------------------------------------------------------------------------
  FNewDBRecord := TMirRecord.Create(sSaveConsignation, fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(DealOffInfo);
    FNewDBRecord.HeaderSize := 0;
    if FileExists(sMainConsignation) then begin
      FDBRecord := TMirRecord.Create(sMainConsignation, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(DealOffInfo);
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰ���������ļ�д���¿�...');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(DealOffInfo);
          if (DealOffInfo.N = 0) or (DealOffInfo.N = 1) or (DealOffInfo.N = 3) then begin//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 3-������ȡ�� �Ž��кϲ�
            if CheckBoxRefId.Checked then begin
              for K := 0 to 9 do begin
                Inc(nItemidx);
                DealOffInfo.UseItems[K].MakeIndex := nItemIdx;
              end;
            end;
            FNewDBRecord.AppendRec(DealOffInfo);
          end;
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;

    if FileExists(sSlaveConsignation) then begin
      FDBRecord := TMirRecord.Create(sSlaveConsignation, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(DealOffInfo);
        FDBRecord.HeaderSize := 0;
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰѴӿ�����ļ�д���¿�...');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for I := 1 to nRecordCount do begin
          FDBRecord.ReadRec(DealOffInfo);
          if (DealOffInfo.N = 0) or (DealOffInfo.N = 1) or (DealOffInfo.N = 3) then begin//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 3-������ȡ�� �Ž��кϲ�
            if CheckBoxRefId.Checked then begin
              for K := 0 to 9 do begin
                Inc(nItemidx);
                DealOffInfo.UseItems[K].MakeIndex := nItemIdx;
              end;
            end;
            nIndex := HumChangeList.GetIndex(DealOffInfo.sDealCharName);
            if nIndex <> -1 then DealOffInfo.sDealCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��
            nIndex := HumChangeList.GetIndex(DealOffInfo.sBuyCharName);
            if nIndex <> -1 then DealOffInfo.sBuyCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��
            FNewDBRecord.AppendRec(DealOffInfo);
          end;
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;
//�ϲ����޲ֿ��ļ�
procedure TFrmMain.BigStorageNoAllone;
{  procedure DisPoseAndNil(var Obj);
  var
    temp: Pointer;
  begin
    temp := Pointer(Obj);
    Pointer(Obj) := nil;
    Dispose(temp);
  end;       }
var
  sSaveConsignation, sMainConsignation, sSlaveConsignation: string;
  //f_H: THandle;
  //BigStorage: pTBigStorage;
  I, nIndex, FileHandle, nRecordCount: Integer;
  ItemCount: TItemCount;
  //m_StorageList:TList;

  BigStorage: TBigStorage;
  FDBRecord, FNewDBRecord: TMirRecord;
begin
  sSaveConsignation := EdtSavePath.Text + '\Mir200\Envir\Market_Storage\UserStorage.db';//��������޲ֿ��ļ�
  MakeSureDirectoryPathExists(PChar(sSaveConsignation));
  sMainConsignation := Envir1.text+ '\Market_Storage\UserStorage.db';//��������޲ֿ��ļ�
  sSlaveConsignation := Envir2.text+ '\Market_Storage\UserStorage.db';//�ӿ�����޲ֿ��ļ�
  if FileExists(sSaveConsignation) then DeleteFile(sSaveConsignation); //����ļ���������ɾ��
//----------------------------------------------------------------------------
  FNewDBRecord := TMirRecord.Create(sSaveConsignation, fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(BigStorage);
    FNewDBRecord.HeaderSize := SizeOf(TItemCount);
    if FileExists(sMainConsignation) then begin
      FDBRecord := TMirRecord.Create(sMainConsignation, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(BigStorage);
        FDBRecord.HeaderSize := SizeOf(TItemCount);
        FDBRecord.Seek(0, 0);
        FDBRecord.Read(ItemCount, SizeOf(TItemCount));
        FNewDBRecord.Seek(0, 0);
        FNewDBRecord.Write(ItemCount, SizeOf(TItemCount));
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰ��������޲ֿ��ļ�д���¿�...');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(BigStorage);
          if CheckBoxRefId.Checked then begin
            Inc(nItemidx);
            BigStorage.UseItems.MakeIndex := nItemIdx;
          end;
          FNewDBRecord.AppendRec(BigStorage);
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;

    if FileExists(sSlaveConsignation) then begin
      FDBRecord := TMirRecord.Create(sSlaveConsignation, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(BigStorage);
        FDBRecord.HeaderSize := SizeOf(TItemCount);
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰѴӿ����޲ֿ��ļ�д���¿�...');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(BigStorage);
          if CheckBoxRefId.Checked then begin
            Inc(nItemidx);
            BigStorage.UseItems.MakeIndex := nItemIdx;
          end;
          nIndex := HumChangeList.GetIndex(BigStorage.sCharName);
          if nIndex <> -1 then BigStorage.sCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��

          FNewDBRecord.AppendRec(BigStorage);
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;
    ItemCount := FNewDBRecord.NumRecs;
    FNewDBRecord.Seek(0, 0);
    FNewDBRecord.Write(ItemCount, SizeOf(TItemCount));
  finally
    FNewDBRecord.Free;
  end;
//----------------------------------------------------------------------------
(*  m_StorageList:= TList.Create;
  try
    if FileExists(sMainConsignation) then begin//��ȡ�������޲ֿ�����
      f_H := FileOpen(sMainConsignation, fmOpenRead or fmShareDenyNone);
      if f_H <= 0 then Raise Exception.Create('���ļ�ʧ��! ' + #13 + sMainConsignation);
      if f_H > 0 then begin
        try
          if FileRead(f_H, ItemCount, SizeOf(TItemCount)) = SizeOf(TItemCount) then begin
            Memo1.Lines.add('��ȡ�������޲ֿ�����...');
            for I := 0 to ItemCount - 1 do begin
              New(BigStorage);
              FillChar(BigStorage.UseItems, SizeOf(TUserItem), #0);
              if (FileRead(f_H, BigStorage^, Sizeof(TBigStorage)) = Sizeof(TBigStorage)) and (not BigStorage.boDelete) then begin// ѭ����������
                if CheckBoxRefId.Checked then begin
                  Inc(nItemidx);
                  BigStorage.UseItems.MakeIndex := nItemIdx;
                end;
                m_StorageList.Add(BigStorage);
              end else begin
                DisPoseAndNil(BigStorage);
              end;
              Application.ProcessMessages;
            end;
          end;
        except
        end;
        FileClose(f_H);
      end;
    end;

    if FileExists(sSlaveConsignation) then begin//��ȡ�ӿ����޲ֿ�����
      f_H := FileOpen(sSlaveConsignation, fmOpenRead or fmShareDenyNone);
      if f_H <= 0 then Raise Exception.Create('���ļ�ʧ��! ' + #13 + sSlaveConsignation);
      if f_H > 0 then begin
        try
          if FileRead(f_H, ItemCount, SizeOf(TItemCount)) = SizeOf(TItemCount) then begin
            Memo1.Lines.add('��ȡ�ӿ����޲ֿ�����...');
            for I := 0 to ItemCount - 1 do begin
              New(BigStorage);
              FillChar(BigStorage.UseItems, SizeOf(TUserItem), #0);
              if (FileRead(f_H, BigStorage^, Sizeof(TBigStorage)) = Sizeof(TBigStorage)) and (not BigStorage.boDelete) then begin// ѭ����������
                if CheckBoxRefId.Checked then begin
                  Inc(nItemidx);
                  BigStorage.UseItems.MakeIndex := nItemIdx;
                end;
                nIndex := HumChangeList.GetIndex(BigStorage.sCharName);
                if nIndex <> -1 then BigStorage.sCharName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;//���������б仯��
                m_StorageList.Add(BigStorage);
              end else begin
                DisPoseAndNil(BigStorage);
              end;
              Application.ProcessMessages;
            end;
          end;
        except
        end;
        FileClose(f_H);
      end;
    end;
    if m_StorageList.Count > 0 then begin
      FileHandle := FileCreate(sSaveConsignation);
      FileClose(FileHandle);
      if FileExists(sSaveConsignation) then begin
        FileHandle := FileOpen(sSaveConsignation, fmOpenWrite or fmShareDenyNone);
        if FileHandle > 0 then begin
          Memo1.Lines.add('����д�����޲ֿ�����...');
          FileSeek(FileHandle, 0, 0);
          FileWrite(FileHandle, m_StorageList.Count, SizeOf(TItemCount));//������Ʒ����
          try
            for I:= 0 to m_StorageList.Count -1 do begin
              BigStorage:= pTBigStorage(m_StorageList.Items[I]);
              FileWrite(FileHandle, BigStorage^, SizeOf(TBigStorage));
              Dispose(BigStorage);
              Application.ProcessMessages;
            end;
          except
          end;
          FileClose(FileHandle);
        end;
      end;
    end;
  finally
    m_StorageList.Free;
  end;      *)
end;

//�ϲ�ʦͽ�ļ�
procedure TFrmMain.MasterNoAllone;
  function GetValidStr3(Str: string; var Dest: string; const Divider: array of Char): string;
  const
    BUF_SIZE = 20480; //$7FFF;
  var
    buf: array[0..BUF_SIZE] of Char;
    BufCount, Count, srclen, I, ArrCount: LongInt;
    Ch: Char;
  label
    CATCH_DIV;
  begin
    Ch := #0; //Jacky
    try
      srclen := Length(Str);
      BufCount := 0;
      Count := 1;
      if srclen >= BUF_SIZE - 1 then begin
        Result := '';
        Dest := '';
        Exit;
      end;
      if Str = '' then begin
        Dest := '';
        Result := Str;
        Exit;
      end;
      ArrCount := SizeOf(Divider) div SizeOf(Char);
      while True do begin
        if Count <= srclen then begin
          Ch := Str[Count];
          for I := 0 to ArrCount - 1 do
            if Ch = Divider[I] then goto CATCH_DIV;
        end;
        if (Count > srclen) then begin
          CATCH_DIV:
          if (BufCount > 0) then begin
            if BufCount < BUF_SIZE - 1 then begin
              buf[BufCount] := #0;
              Dest := string(buf);
              Result := Copy(Str, Count + 1, srclen - Count);
            end;
            Break;
          end else begin
            if (Count > srclen) then begin
              Dest := '';
              Result := Copy(Str, Count + 2, srclen - 1);
              Break;
            end;
          end;
        end else begin
          if BufCount < BUF_SIZE - 1 then begin
            buf[BufCount] := Ch;
            Inc(BufCount);
          end; // else
        end;
        Inc(Count);
      end;
    except
      Dest := '';
      Result := '';
    end;
  end;
var
  I, J, nIndex: Integer;
  s: TStringList;
  s001, s002, s003, sName: string;
begin
  if MasterNoList <> nil then begin
    MasterNoList.Clear;
    GetFileList(Envir2.text+'\MasterNo', '*.txt', MasterNoList);//���ӿ��MasterNoĿ¼�µ�����TXT�����б�
    if MasterNoList.Count > 0 then begin
      s := TStringList.Create;
      try
        for I := 0 to MasterNoList.Count - 1 do begin
          s.Clear;
          s.LoadFromFile(MasterNoList[i]);
          sName:='';
          sName:= ExtractFileName(MasterNoList[i]);//��ȡ���ļ���
          sName:= ChangeFileExt(sName,'');//ȥ���ļ�����׺
          if s.Count > 0 then  begin//�������ļ�
            for J := 0 to S.Count - 1 do begin
              s001 := Trim(S.Strings[J]);
              if (s001 <> '') and (s001[1] <> ';') then begin
                s001 := GetValidStr3(s001, s002, [' ', #9]);//ͽ����
                s001 := GetValidStr3(s001, s003, [' ', #9]);//����
                nIndex := HumChangeList.GetIndex(s002);
                if nIndex <> -1 then begin//�����������ظ��ı��
                  s002 := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
                  S.Strings[J]:= s002+' '+s003;
                end;
              end;
            end;
            nIndex := HumChangeList.GetIndex(sName);
            if nIndex <> -1 then begin//�����������ظ��ı��
              sName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
            end;
            s.SaveToFile(EdtSavePath.Text+'\Mir200\Envir\MasterNo\'+sName+'.txt');
          end;
          Application.ProcessMessages;
        end;
      finally
        s.Free;
      end;
    end;
  end;
end;
//�ϲ��ƺ��б�
procedure TFrmMain.FengHaoListNoAllone;
var
  I, J, nIndex: Integer;
  s: TStringList;
  s001, s002, s003, sName: string;
begin
  if FenghaoList <> nil then begin
    FenghaoList.Clear;
    GetFileList(Envir2.text+'\UserData\FengHao\HuHua', '*.txt', FenghaoList);//���ӿ��HuHuaĿ¼�µ�����TXT�����б�
    if FenghaoList.Count > 0 then begin
      s := TStringList.Create;
      try
        for I := 0 to FenghaoList.Count - 1 do begin
          s.Clear;
          s.LoadFromFile(FenghaoList[i]);
          sName:='';
          sName:= ExtractFileName(FenghaoList[i]);//��ȡ���ļ���
          sName:= ChangeFileExt(sName,'');//ȥ���ļ�����׺
          if s.Count > 0 then  begin//�������ļ�
            for J := 0 to S.Count - 1 do begin
              s001 := Trim(S.Strings[J]);
              if (s001 <> '') and (s001[1] <> ';') then begin
                nIndex := HumChangeList.GetIndex(s001);
                if nIndex <> -1 then begin//�����������ظ��ı��
                  s002 := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
                  S.Strings[J]:= s002;
                end;
              end;
            end;
            nIndex := HumChangeList.GetIndex(sName);
            if nIndex <> -1 then begin//�����������ظ��ı��
              sName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
            end;
            s.SaveToFile(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\HuHua\'+sName+'.txt');
          end;
          Application.ProcessMessages;
        end;
      finally
        s.Free;
      end;
    end;

    FenghaoList.Clear;
    GetFileList(Envir2.text+'\UserData\FengHao\Comrade', '*.txt', FenghaoList);//���ӿ��ComradeĿ¼�µ�����TXT�����б�
    if FenghaoList.Count > 0 then begin
      s := TStringList.Create;
      try
        for I := 0 to FenghaoList.Count - 1 do begin
          s.Clear;
          s.LoadFromFile(FenghaoList[i]);
          sName:='';
          sName:= ExtractFileName(FenghaoList[i]);//��ȡ���ļ���
          sName:= ChangeFileExt(sName,'');//ȥ���ļ�����׺
          if s.Count > 0 then  begin//�������ļ�
            for J := 0 to S.Count - 1 do begin
              s001 := Trim(S.Strings[J]);
              if (s001 <> '') and (s001[1] <> ';') then begin
                nIndex := HumChangeList.GetIndex(s001);
                if nIndex <> -1 then begin//�����������ظ��ı��
                  s002 := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
                  S.Strings[J]:= s002;
                end;
              end;
            end;
            nIndex := HumChangeList.GetIndex(sName);
            if nIndex <> -1 then begin//�����������ظ��ı��
              sName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
            end;
            s.SaveToFile(EdtSavePath.Text+'\Mir200\Envir\UserData\FengHao\Comrade\'+sName+'.txt');
          end;
          Application.ProcessMessages;
        end;
      finally
        s.Free;
      end;
    end;
  end;
end;
(*
procedure TFrmMain.HumHeroAllone;
var
  FMirInfo: THeroNameInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  nIndex, I, nRecordCount: Integer;
  DBHeader: TDBHeader;
begin
  if FileExists(HumHero1.Text) then
    FDBRecord := TMirRecord.Create(HumHero1.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('����HumHero���ݿⲻ����!');
    Exit;
  end;
  if FileExists(EdtSavePath.Text+'\DBServer\FDB\HumHero.DB') then DeleteFile(EdtSavePath.Text+'\DBServer\FDB\HumHero.DB'); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(EdtSavePath.Text+'\DBServer\FDB\HumHero.DB', fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize := SizeOf(DBHeader);
    if FileExists(HumHero1.Text) then begin
      FDBRecord := TMirRecord.Create(HumHero1.Text, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(FMirInfo);
        FDBRecord.HeaderSize := SizeOf(DBHeader);
        FDBRecord.Seek(0, 0);
        FDBRecord.Read(DBHeader, SizeOf(DBHeader));
        FNewDBRecord.Seek(0, 0);
        FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰ�����HumHeroд���¿�');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(FMirInfo);
          FNewDBRecord.AppendRec(FMirInfo);
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;

    if FileExists(HumHero2.Text) then begin
      FDBRecord := TMirRecord.Create(HumHero2.Text, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(FMirInfo);
        FDBRecord.HeaderSize := SizeOf(DBHeader);
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰѴӿ�HumHeroд���¿�');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(FMirInfo);
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sChrName);
          if nIndex <> -1 then begin//�������ظ��ı��
            FMirInfo.Data.sChrName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sNewHeroName);
          if nIndex <> -1 then begin//�������ظ��ı��
            FMirInfo.Data.sNewHeroName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
          FNewDBRecord.AppendRec(FMirInfo);
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
        FDBRecord.Seek(0, 0);
        FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      finally
        FDBRecord.Free;
      end;
    end;
    DBHeader.nHumCount := FNewDBRecord.NumRecs;
    DBHeader.sDesc := sDBHeaderDesc;
    DBHeader.n70:= nDBVersion;
    FNewDBRecord.Seek(0, 0);
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
  finally
    FNewDBRecord.Free;
  end;
end;  *)

procedure TFrmMain.HeroMirAllone;
var
  FMirInfo: TNewHeroDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  nIndex, I, nRecordCount: Integer;
  DBHeader: TDBHeader;
begin
  if FileExists(EdtSavePath.Text+'\DBServer\FDB\HeroMir.DB') then DeleteFile(EdtSavePath.Text+'\DBServer\FDB\HeroMir.DB'); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(EdtSavePath.Text+'\DBServer\FDB\HeroMir.DB', fmCreate);
  try
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize := SizeOf(DBHeader);
    if FileExists(HeroMir1.Text) then begin
      FDBRecord := TMirRecord.Create(HeroMir1.Text, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(FMirInfo);
        FDBRecord.HeaderSize := SizeOf(DBHeader);
        FDBRecord.Seek(0, 0);
        FDBRecord.Read(DBHeader, SizeOf(DBHeader));
        FNewDBRecord.Seek(0, 0);
        FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰ�����HeroMirд���¿�');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(FMirInfo);
          FNewDBRecord.AppendRec(FMirInfo);
          if CheckBoxRefId.Checked then RefItemIdToHumMir(FMirInfo); //������Ʒ���
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
      finally
        FDBRecord.Free;
      end;
    end;

    if FileExists(HeroMir2.Text) then begin
      FDBRecord := TMirRecord.Create(HeroMir2.Text, fmShareDenyNone);
      try
        FDBRecord.RecSize := SizeOf(FMirInfo);
        FDBRecord.HeaderSize := SizeOf(DBHeader);
        nRecordCount := FDBRecord.NumRecs;
        FDBRecord.First;
        Memo1.Lines.add('���ڰѴӿ�HeroMirд���¿�');
        StatusBar1.Panels[1].Text := '';
        Application.ProcessMessages;
        for i := 1 to nRecordCount do begin
          FDBRecord.ReadRec(FMirInfo);
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sHeroChrName);
          if nIndex <> -1 then begin//�������ظ��ı��
            FMirInfo.Data.sHeroChrName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
          if CheckBoxRefId.Checked then RefItemIdToHumMir(FMirInfo); //������Ʒ���
          FNewDBRecord.AppendRec(FMirInfo);
          StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
          Application.ProcessMessages;
          FDBRecord.NextRec;
        end;
        FDBRecord.Seek(0, 0);
        FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      finally
        FDBRecord.Free;
      end;
    end;
    DBHeader.nHumCount := FNewDBRecord.NumRecs;
    DBHeader.sDesc := sDBHeaderDesc;
    DBHeader.n70:= nDBVersion;
    FNewDBRecord.Seek(0, 0);
    FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
  finally
    FNewDBRecord.Free;
  end;
end;

procedure TFrmMain.MirAllone;
var
  FMirInfo: THumDataInfo;
  FDBRecord, FNewDBRecord: TMirRecord;
  nIndex, I, nRecordCount, K: Integer;
  DBHeader: TDBHeader;
  sName, sStorageDir, sStoraDir: string;
begin
  if FileExists(EdtMainMir.Text) then
    FDBRecord := TMirRecord.Create(EdtMainMir.Text, fmShareDenyNone)
  else begin
    Memo1.Lines.add('����Mir���ݿⲻ����!');
    Exit;
  end;

  if FileExists(EdtSavePath.Text+'\DBServer\FDB\Mir.DB') then DeleteFile(EdtSavePath.Text+'\DBServer\FDB\Mir.DB'); //����ļ���������ɾ��
  FNewDBRecord := TMirRecord.Create(EdtSavePath.Text+'\DBServer\FDB\Mir.DB', fmCreate);
  try
    nItemidx := 0;
    FNewDBRecord.RecSize := SizeOf(FMirInfo);
    FNewDBRecord.HeaderSize := SizeOf(DBHeader);
    try
      FDBRecord.RecSize := SizeOf(FMirInfo);
      FDBRecord.HeaderSize := SizeOf(DBHeader);
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      FNewDBRecord.Seek(0, 0);
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰ�����Mirд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(FMirInfo);
        FNewDBRecord.AppendRec(FMirInfo);
        if CheckBoxRefId.Checked then RefItemId(FMirInfo); //������Ʒ���
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
    finally
      FDBRecord.Free;
    end;
    Application.ProcessMessages;
    if DirectoryExists(Envir1.text+'\MasterNo') then CopyDirAll(Envir1.text+'\MasterNo',EdtSavePath.Text+'\Mir200\Envir\MasterNo');//��������Ŀ¼�µ�ʦͽ����
    Application.ProcessMessages;
    if FileExists(EdtSlaveMir.Text) then
      FDBRecord := TMirRecord.Create(EdtSlaveMir.Text, fmShareDenyNone)
    else begin
      Memo1.Lines.add('�ӿ�Mir���ݿⲻ����!');
      Exit;
    end;
    try
      FDBRecord.RecSize := SizeOf(FMirInfo);
      FDBRecord.HeaderSize := SizeOf(DBHeader);
      nRecordCount := FDBRecord.NumRecs;
      FDBRecord.First;
      Memo1.Lines.add('���ڰѴӿ�Mirд���¿�');
      StatusBar1.Panels[1].Text := '';
      Application.ProcessMessages;
      for i := 1 to nRecordCount do begin
        FDBRecord.ReadRec(FMirInfo);
        sName := FMirInfo.Data.sChrName;
        nIndex := HumChangeList.GetIndex(FMirInfo.Data.sChrName);
        if nIndex <> -1 then begin//�����������ظ��ı��
          FMirInfo.Header.sName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          FMirInfo.Data.sChrName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
        end;
        if FMirInfo.Data.sHeroChrName <> '' then begin
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sHeroChrName);
          if nIndex <> -1 then begin//�����Ӣ�������б仯�ĸ���Ӣ������
            FMirInfo.Data.sHeroChrName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
        end;
        if FMirInfo.Data.sHeroChrName1 <> '' then begin//����Ӣ���� 20110124
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sHeroChrName1);
          if nIndex <> -1 then begin//�����Ӣ�������б仯�ĸ���Ӣ������
            FMirInfo.Data.sHeroChrName1 := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
        end;
        if FMirInfo.Data.sDearName <> '' then begin
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sDearName);
          if nIndex <> -1 then begin//����İ����б仯�ĸ���
            FMirInfo.Data.sDearName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
        end;
        if FMirInfo.Data.sMasterName <> '' then begin
          nIndex := HumChangeList.GetIndex(FMirInfo.Data.sMasterName);
          if nIndex <> -1 then begin//�����ʦͽ�б仯�ĸ���
            FMirInfo.Data.sMasterName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
          end;
        end;
        for K := 0 to 7 do begin//���ƺŽṹ��������Ƿ��б仯
          if FMirInfo.Data.HumTitles[K].sChrName <> '' then begin
            nIndex := HumChangeList.GetIndex(FMirInfo.Data.HumTitles[K].sChrName);
            if nIndex <> -1 then begin
              FMirInfo.Data.HumTitles[K].sChrName := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
            end;
          end;
        end;
        nIndex := AccountChangeList.GetIndex(FMirInfo.Data.sAccount);
        if nIndex <> -1 then begin//�ʺ��б���а��ʺű��
          FMirInfo.Data.sAccount := pTQuickName(AccountChangeList.Objects[nIndex])^.sNewName;
        end;
       {  //��ӿ⾭��
        if CheckBox2.Checked then FMirInfo.Data.Abil.Exp := 0;
        //��ӿ����Ե�
        if CheckBox3.Checked then begin
          FillChar(FMirInfo.Data.BonusAbil, SizeOf(TNakedAbility), #0);
          FMirInfo.Data.nBonusPoint := 0;
        end;   }
        if CheckBoxRefId.Checked then RefItemId(FMirInfo); //������Ʒ���
        FNewDBRecord.AppendRec(FMirInfo);
        StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
        Application.ProcessMessages;
        FDBRecord.NextRec;
      end;
      FDBRecord.Seek(0, 0);
      FDBRecord.Read(DBHeader, SizeOf(DBHeader));
      FNewDBRecord.Seek(0, 0);
      DBHeader.nHumCount := FNewDBRecord.NumRecs;
      DBHeader.sDesc := sDBHeaderDesc;
      DBHeader.n70:= nDBVersion;
      FNewDBRecord.Write(DBHeader, SizeOf(DBHeader));
    finally
      FDBRecord.Free;
    end;
  finally
    FNewDBRecord.Free;
  end;
end;

procedure TFrmMain.SaveChangeLog;
var
  T: TStringList;
  I: Integer;
begin
  T := TStringList.Create;
  try
    if AccountChangeList.Count > 0 then begin
      t.Clear;
      for I := 0 to AccountChangeList.Count - 1 do
        t.Add(AccountChangeList[i] + '=>' + pTQuickName(AccountChangeList.Objects[I])^.sNewName);
      t.SaveToFile(EdtSavePath.Text + '\ID_Log.txt');
    end;
    if HumChangeList.Count > 0 then begin
      t.Clear;
      for I := 0 to HumChangeList.Count - 1 do
        t.Add(HumChangeList[i] + '=>' + pTQuickName(HumChangeList.Objects[I])^.sNewName);
      t.SaveToFile(EdtSavePath.Text + '\ChrName_Log.txt');
    end;
    if GuildChangeList.Count > 0 then begin
      t.Clear;
      for I := 0 to GuildChangeList.Count - 1 do
        t.Add(GuildChangeList[i] + '=>' + pTQuickName(GuildChangeList.Objects[I])^.sNewName);
      t.SaveToFile(EdtSavePath.Text + '\Guild_Log.txt');
    end;
    if DivisionChangeList.Count > 0 then begin
      t.Clear;
      for I := 0 to DivisionChangeList.Count - 1 do
        t.Add(DivisionChangeList[i] + '=>' + pTQuickName(DivisionChangeList.Objects[I])^.sNewName);
      t.SaveToFile(EdtSavePath.Text + '\Division_Log.txt');
    end;
  finally
    t.Free;
  end;
end;

procedure TFrmMain.TextAllone;
var
  s, L, KeyList, sMain: TStringList;
  I, j, h, nIndex, nRecordCount, nRecordCount1: Integer;
  sPath, sFileName, sTest, ident, identkey: string;
  SlaveIniFile, MainInifle: TIniFile;
begin
  if EdtSavePath.Text = '' then begin
    Memo1.Lines.add('�������úñ���·��!');
    Exit;
  end;
  if (TxtMainPath = '') or (TxtSlavePath = '') then begin
    Memo1.Lines.add('���Ƚ����ļ��ϲ�����!');
    Exit;
  end;
  MakeSureDirectoryPathExists(PChar(EdtSavePath.Text + '\�ı�Ŀ¼\'));
  //���·�������ڵ��½�һ��

  Memo1.Lines.add('���ڸ����������ļ�');
  StatusBar1.Panels[1].Text := '';
  Application.ProcessMessages;
  nRecordCount := MainFileList.Count;
  for I := 0 to nRecordCount - 1 do begin
    sPath := MainFileList[i];
    Delete(sPath, 1, Length(TxtMainPath));
    sFileName := EdtSavePath.Text + '\�ı�Ŀ¼' + sPath;

    MakeSureDirectoryPathExists(PChar(sFileName)); //���·�������ڵ��½�һ��
    CopyFile(PChar(MainFileList[i]), PChar(sFileName), False);
    StatusBar1.Panels[1].Text := '�����' + inttostr(round((i / nRecordCount) * 100)) + '%';
    Application.ProcessMessages;
  end;
  Memo1.Lines.add('���ڴ���ӿ������ļ�');
  StatusBar1.Panels[1].Text := '';
  nRecordCount := SlaveFileList.Count;
  s := TStringList.Create;
  l := TStringList.Create;
  try
    for I := 0 to nRecordCount - 1 do begin
      s.Clear;
      s.LoadFromFile(SlaveFileList[i]);
      if s.Count > 0 then  begin//�������ļ�
        sTest := s[0]; //�����ļ��ǲ��ǽű�����ű��Ͳ�����
        if (Copy(sTest, 1, 2) <> '[@') and (Copy(sTest, 1, 1) <> ';') then begin
          SlaveIniFile := TIniFile.Create(SlaveFileList[i]);
          l.Clear;
          try
            SlaveIniFile.ReadSections(l); //��ini�ļ���ȡһ�´ӿ���ļ�
            if l.Count > 0 then begin//����ֵ����0˵���Ǳ����ı� ������������б��ı�
              sPath := SlaveFileList[i];
              Delete(sPath, 1, Length(TxtSlavePath));
              sFileName := EdtSavePath.Text + '\�ı�Ŀ¼' + sPath;

              MakeSureDirectoryPathExists(PChar(sFileName)); //���·�������ڵ��½�һ��
              //�Ѵӿ���ļ����浽�¿⣬ini����ļ����ھͻ���ں��治���ھͻ��Զ��½�
              MainInifle := TIniFile.Create(sFileName);
              try
                nRecordCount1 := L.Count;
                for j := 0 to L.Count - 1 do begin//��ȡ���еĶ�����Ҳ����������
                  KeyList := TStringList.Create;
                  try
                    SlaveIniFile.ReadSectionValues(l[j], keyList); //��ȡ����Ҳ�����������Ľ��ֵ
                    nIndex := HumChangeList.GetIndex(l[j]); //����һ������������Ҫ���µ�
                    if nIndex <> -1 then  begin
                      for h := 0 to KeyList.Count - 1 do begin
                        identkey := KeyList[h];
                        ident := GetSubStr(identkey, '='); //�Ѹ����˵Ķ���(������)д�����ļ�
                        MainInifle.WriteString(pTQuickName(HumChangeList.Objects[nIndex])^.sNewName, ident, identkey);
                      end;
                    end else begin
                      for h := 0 to KeyList.Count - 1 do begin
                        identkey := KeyList[h];
                        ident := GetSubStr(identkey, '='); //�Ѳ���Ҫ���µĶ���(������)д�����ļ�
                        MainInifle.WriteString(l[j], ident, identkey);
                      end;
                    end;
                  finally
                    KeyList.Free;
                  end;
                  StatusBar1.Panels[0].Text := ExtractFileName(SlaveFileList[i]) + '�������' + inttostr(round((j / nRecordCount1) * 100)) + '%';
                  Application.ProcessMessages;
                end; //end for j
              finally
                MainInifle.Free;
              end;
            end else begin//�û����б��ı�
              for j := 0 to s.Count - 1 do begin//�Ѵӿ���������Ҫ���µĸ���һ��
                nIndex := HumChangeList.GetIndex(S[j]);
                if nIndex <> -1 then s[j] := pTQuickName(HumChangeList.Objects[nIndex])^.sNewName;
              end;
              sPath := SlaveFileList[i];
              Delete(sPath, 1, Length(TxtSlavePath));
              sFileName := EdtSavePath.Text + '\�ı�Ŀ¼' + sPath;
              MakeSureDirectoryPathExists(PChar(sFileName)); //���·�������ڵ��½�һ��
              if FileExists(sFileName) then begin //�ļ���������ڵļӵ��������
                sMain := TStringList.Create;
                sMain.LoadFromFile(sFileName); //�ж�ȡԭ�ļ�
                try
                  for h := 0 to s.Count - 1 do begin
                    nIndex := sMain.IndexOf(S[H]);//�ж������ı����Ƿ����ظ������֣����������� 20110511
                    if nIndex = -1 then sMain.Add(s[h]);
                  end;
                  sMain.SaveToFile(sFileName);
                finally
                  sMain.Free;
                end;
              end else s.SaveToFile(sFileName); //�ļ������ⲻ���ڵľ�ֱ�ӱ���
            end; //if l.Count
          finally
            SlaveIniFile.Free;
          end;
        end; // end if Copy(sTest
      end; //end s.count>0
      StatusBar1.Panels[1].Text := '�ı����������' + inttostr(round((i / nRecordCount) * 100)) + '%';
      Application.ProcessMessages;
    end; //end for i
  finally
    s.free;
    l.free;
  end;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
end;


procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainFileList.Free;
  SlaveFileList.Free;
  MasterNoList.Free;
  FenghaoList.Free;
  AccountList.Free;
  AccountChangeList.Free;
  HumList.Free;
  HumChangeList.Free;
  GuildList.Free;
  GuildChangeList.free;
  DivisionList.Free;
  DivisionChangeList.Free;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  sProductName: string;
  sUrl1: string;
begin
  Decode(g_sProductName, sProductName);
  Decode(g_sUrl1, sUrl1);
  LabelCopyright.Caption := sProductName;
  URLLabel1.Caption := sUrl1;
  URLLabel1.URL := sUrl1;

  rootdir := ExtractFilePath(Application.ExeName);
  MainFileList := TStringList.Create;
  SlaveFileList := TStringList.Create;
  MasterNoList := TStringList.Create;
  FenghaoList := TStringList.Create;
  AccountList := TQuickList.Create;
  AccountChangeList := TQuickList.Create;
  HumList := TQuickList.Create;
  HumChangeList := TQuickList.Create;
  GuildList := TQuickList.Create;
  GuildChangeList := TQuickList.Create;
  DivisionList := TQuickList.Create;
  DivisionChangeList := TQuickList.Create;

  Cmd_Start.Enabled := True;
  Button1.Enabled := True;

  //ShowMessage(IntToStr(SizeOf(THumDataInfo)));
end;



end.

