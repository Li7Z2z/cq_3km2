unit UnitMainWork;

interface

uses Windows, SysUtils, Classes, UniTypes, RzRadChk, RzListVw,IniFiles, Mudutil;

const
  THREADWORK    = TRUE;

type
  TMainWorkThread = class{$IF THREADWORK}(TThread){$IFEND}
    //m_MainHumLists    : TListArray;
    m_MainIDLists     : TListArray;//����ID����
    m_SubIDLists      : TListArray;//�ӿ�ID����
    m_IDChangeByHero  : TStrings;

    m_sWorkingFor     : string;
    m_nTotalMax       : Integer;//�������
    m_nTotalPostion   : Integer;
    m_nCurMax         : Integer;
    m_nCurPostion     : Integer;
    m_nFailed         : Integer;
    m_sMainRoot       : string;//�ļ�·��
    m_sMainGuildList  : TStrings;
    m_sGuildChangedList:TStrings;
    NameList          : TStrings;
  private
    m_sCurMessage: string;
    m_WorkRoots: TStrings;
    m_nNewItemIndex: Integer;
    IDChangedLists: TListArray;//��ID��¼��
    IDOldLists: TListArray;//TStrings; ��ID��¼
    NameChangeList: TStringList;
    NewHeroDataList: TStringList;//Ӣ�������б�
    OldSellOffItemList: TList;//Ԫ�������б�
    m_StorageList:TList;//���޲ֿ��б�
    g_MainTxtList:TList;//�����ı��б� 20080703
    g_DeputyTxtList:TList;//�ӿ��ı��б� 20080703
    f_MainIDH: THandle;
    f_MainHumH: THandle;
    f_MainMirH: THandle;
    procedure OutMessage;//�����Ϣ
    function IsFilterStr(const sStr: string): string;//�滻�����ַ� 20090315
    procedure LoadHumDB(const sRoot: string; ListArray: TStrings{TListArray});//��ȡ��������
    procedure LoadIDDB(const sRoot: string; ListArray: TListArray);//��ȡID����
    procedure LoadSellOffItemList(const sRoot: string; SellOffItemList:TList);//��ȡԪ����������
    procedure UpdateHeroMirDBName(oleHeroName,NewHeroName: String);//�޸Ĵӿ⸱��Ӣ����������
    procedure ToMainHeroMirDB;//���ӿ⸱��Ӣ������д�����⸱��Ӣ��������

    procedure UPdataHeroUserData(sFindName, sNewHeroName: String; nTpye: Byte);//�޸����帱������
    procedure SaveHeroUserData;//���ӿ����帱����������д��������

    procedure UpdateSellOffItemList;//�޸�Ԫ��������������
    procedure SaveSellOffItemList(const sRoot: string; SellOffItemList:TList);//����Ԫ����������
    procedure LoadBigStorageList(const sRoot: string; m_StorageList:TList);//��ȡ���޲ֿ�����
    procedure UpdateBigStorageList;//�޸����޲ֿ���������
    procedure SaveBigStorageList(const sRoot: string; m_StorageList:TList);  //�������޲ֿ�����
    function  GetMaxWorkCount : Integer;//ȡ���Ĺ�������
    function  GetFileSize(const sFile: string; const OffSet: Integer; const DefSize: Integer): Integer;//ȡ�ļ���С
    procedure SaveIDChangeList;//����ID�ı���б�
    procedure SaveNameChangeList;//�������ָı���б�
    procedure MakeInOne(sRoot: string);//�ϲ�����
    procedure ReSetItemsIndex;//���±�д��Ʒ����ID

    procedure LoadTxtDataToList(ListView: TRzListView ; m_Txt:TList);//��ȡ�ı��ڴ浽�б� 20080703
    procedure UpdateTxtDataToList(m_Txt:TList);//�޸����ֵ��ı������б� 
    procedure SaveListToTxt(sRoot: string; m_MainTxt, DeputyTxt:TList);//�����ı����� 20080703
  protected
    procedure Execute; {$IF THREADWORK}override;{$IFEND}
  public
    constructor Create(CreateSupsbended: Boolean = True);reintroduce;
    destructor  Destroy;override;
    procedure   SetWorkRoots(SL:String);
    {$IF NOT THREADWORK}
    procedure   Run;
    {$IFEND}
  end;

  TMainOutProcList    = procedure (const smsg: string) of Object;

  var
    MainOutInforProc  : TMainOutProcList;
    MainWorkThread    : TMainWorkThread;
{$IF not THREADWORK}
    g_Terminated      : Boolean = False;
{$IFEND}

implementation

uses Forms, Main, HumDB, StrUtils, IDDB;

{ TMainWorkThread }
//��ȡ�ַ���
//�� ArrestStringEx('[1234]','[',']',str)    str=1234
function ArrestStringEx(Source, SearchAfter, ArrestBefore: string; var ArrestStr: string): string;
var
  srclen: Integer;
  GoodData : Boolean;
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
      end;
      Inc(Count);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;

constructor TMainWorkThread.Create(CreateSupsbended: Boolean);
var
  I: Integer;
begin
  Inherited Create{$IF THREADWORK}(CreateSupsbended){$IFEND};
  //for I := Low(m_MainHumLists) to High(m_MainHumLists) do
  //  m_MainHumLists[I] := TStringList.Create;
  for I := Low(m_MainIDLists) to High(m_MainIDLists) do
    m_MainIDLists[I]  := TStringList.Create;
  for I := Low(m_SubIDLists) to High(m_SubIDLists) do
    m_SubIDLists[I] := TStringList.Create;

  m_nTotalMax     := 0;
  m_nTotalPostion := 0;
  m_nCurMax       := 0;
  m_nCurPostion   := 0;
  m_nFailed       := 0;
  m_nNewItemIndex := 0;
  f_MainIDH       := 0;
  f_MainHumH      := 0;
  f_MainMirH      := 0;

  for I := Low(IDChangedLists) to High(IDChangedLists) do
    IDChangedLists[I]   := TStringList.Create;
  for I := Low(IDOldLists) to High(IDOldLists) do
    IDOldLists[I]       := TStringList.Create;

  NewHeroDataList:= TStringList.Create;//Ӣ�������б�
  OldSellOffItemList:= TList.Create;//�ɵ�Ԫ���������� 20080601
  m_StorageList:= TList.Create;//���޲ֿ��б� 20080601
  g_MainTxtList:= TList.Create;//�����ı��б� 20080703
  g_DeputyTxtList:= TList.Create;//�ӿ��ı��б� 20080703
  NameChangeList := TStringList.Create;
  //NameChangedList := TStringList.Create;
  //NameOldList     := TStringList.Create;
  m_sMainGuildList:= TStringList.Create;
  m_sGuildChangedList := TStringList.Create;
  NameList:= TStringList.Create;
  m_IDChangeByHero:= TStringList.Create;
end;

destructor TMainWorkThread.Destroy;
var
  I,II: Integer;
begin
  if HeroDataDB <> nil then HeroDataDB.Free;
  if HumHeroDB <> nil then HumHeroDB.Free;
  //for I := Low(m_MainHumLists) to High(m_MainHumLists) do FreeAndNil(m_MainHumLists[I]);
  for I := Low(m_MainIDLists) to High(m_MainIDLists) do FreeAndNil(m_MainIDLists[I]);
  for I := Low(m_SubIDLists) to High(m_SubIDLists) do FreeAndNil(m_SubIDLists[I]);

  for I := Low(IDChangedLists) to High(IDChangedLists) do FreeAndNil(IDChangedLists[I]);
  for I := Low(IDOldLists) to High(IDOldLists) do FreeAndNil(IDOldLists[I]);

  if NewHeroDataList.Count > 0 then begin
    for I:=0 to NewHeroDataList.count -1 do begin
      if pTNewHeroName(NewHeroDataList.Objects[I]) <> nil then
         Dispose(pTNewHeroName(NewHeroDataList.Objects[I]));
    end;
  end;
  FreeAndNil(NewHeroDataList);//Ӣ�������б�

  for I:=0 to OldSellOffItemList.count -1 do begin//�ɵ�Ԫ���������� 20080601
    Dispose(pTDealOffInfo(OldSellOffItemList.Items[I]));
  end;
  FreeAndNil(OldSellOffItemList);

  for I:=0 to m_StorageList.count -1 do begin//���޲ֿ��б� 20080601
    Dispose(pTBigStorage(m_StorageList.Items[I]));
  end;
  FreeAndNil(m_StorageList);

  for I:=0 to g_MainTxtList.Count -1 do begin
    if pTTxtData(g_MainTxtList.Items[I]) <> nil then begin
       if pTTxtData(g_MainTxtList.Items[I]).sData.Count > 0 then begin
         for II:= 0 to pTTxtData(g_MainTxtList.Items[I]).sData.Count - 1 do begin
           Dispose(pTTxtInfo(pTTxtData(g_MainTxtList.Items[I]).sData.Items[II]));
         end;
       end;
       pTTxtData(g_MainTxtList.Items[I]).sData.Free;
       Dispose(pTTxtData(g_MainTxtList.Items[I]));
    end;//pTTxtData
  end;
  FreeAndNil(g_MainTxtList);//�����ı��б� 20080703

  for I:=0 to g_DeputyTxtList.Count -1 do begin
    if pTTxtData(g_DeputyTxtList.Items[I]) <> nil then begin
       if pTTxtData(g_DeputyTxtList.Items[I]).sData.Count > 0 then begin
         for II:= 0 to pTTxtData(g_DeputyTxtList.Items[I]).sData.Count - 1 do begin
           Dispose(pTTxtInfo(pTTxtData(g_DeputyTxtList.Items[I]).sData.Items[II]));
         end;
       end;
       pTTxtData(g_DeputyTxtList.Items[I]).sData.Free;
       Dispose(pTTxtData(g_DeputyTxtList.Items[I]));
    end;//pTTxtData
  end;
  FreeAndNil(g_DeputyTxtList);//�ӿ��ı��б� 20080703

  if NameChangeList.Count > 0 then begin
    for I:=0 to NameChangeList.Count -1 do begin
      if pTDearData(NameChangeList.Objects[I]) <> nil then Dispose(pTDearData(NameChangeList.Objects[I]));
    end;
  end;
  FreeAndNil(NameChangeList);
  //FreeAndNil(NameChangedList);
  //FreeAndNil(NameOldList);
  FreeAndNil(m_sMainGuildList);
  FreeAndNil(m_sGuildChangedList);
  FreeAndNil(NameList);
  FreeAndNil(m_IDChangeByHero);
  inherited Destroy;
end;

procedure TMainWorkThread.Execute;
var
  I: Integer;
begin
  inherited;
  m_sWorkingFor:= '���ڶ�ȡ����...';
//  m_nTotalMax:= GetMaxWorkCount {* 2};//ͳ����������
  m_nTotalPostion := 0;

  m_sCurMessage := '���ڶ�ȡ��������...';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  LoadIDDB(m_sMainRoot + '\LoginSrv\IDDB\ID.DB', m_MainIDLists);//��ȡ����ID��Ϣ
  LoadHumDB(m_sMainRoot + '\DBServer\FDB\Hum.DB', NameList);

  if boSellOffItem then LoadSellOffItemList(FrmMain.Envir2.text+'\UserData\UserData.dat' ,OldSellOffItemList);//��ȡ�ӿ�Ԫ���������� 20080601
  if boBigStorage then LoadBigStorageList(FrmMain.Envir2.text+'\Market_Storage\UserStorage.db', m_StorageList);//��ȡ�ӿ����޲ֿ����� 20080601

  if FileExists(m_sMainRoot + '\Mir200\GuildBase\GuildList.txt') then begin
     m_sMainGuildList.LoadFromFile(m_sMainRoot + '\Mir200\GuildBase\GuildList.txt');
    (m_sMainGuildList as TStringList).Sort;
  end;

  LoadTxtDataToList(FrmMain.ListViewTxt1,g_MainTxtList);//��ȡ�����ı��ݴ浽�б� 20080703
  LoadTxtDataToList(FrmMain.ListViewTxt2,g_DeputyTxtList);//��ȡ�ӿ������ڴ浽�б� 20080703
  Sleep(1);

  m_sWorkingFor := '���ںϲ�����...';
  m_sCurMessage := '���ڶ�ȡ����';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  LoadIDDB(FrmMain.ID_DB2.text, m_SubIDLists);//��ȡ�ӿ�ID����

  m_sCurMessage := '���ںϲ�����......';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  //�ϲ�
  MakeInOne(FrmMain.GuildBase2.text);

  m_sWorkingFor := '������Ʒ���...';
  ReSetItemsIndex;//���±�д��Ʒ���
  for I := Low(IDChangedLists) to High(IDChangedLists) do
    if IDChangedLists[I].Count  > 0 then begin
      SaveIDChangeList;//����ID�����¼
      Break;
    end;
      
  //if NameChangedList.Count > 0 then SaveNameChangeList;//�������ֱ����¼
  if NameChangeList.Count > 0 then SaveNameChangeList;//�������ֱ����¼
  if m_sMainGuildList.Count > 0 then m_sMainGuildList.SaveToFile(m_sMainRoot + '\Mir200\GuildBase\GuildList.txt');//�����л�����
  if m_sGuildChangedList.Count > 0 then m_sGuildChangedList.SaveToFile(ExtRactFilePath(Application.ExeName) + '�л���.txt');
  if f_MainMirH > 0 then FileClose(f_MainMirH);
  if HumDataDB1 <> nil then HumDataDB1.Free;
  if HumChrDB1 <> nil then HumChrDB1.Free;
  if HeroDataDB1 <> nil then HeroDataDB1.Free;
  if HumHeroDB1 <> nil then HumHeroDB1.Free;
  m_sWorkingFor := '�������!';

  m_sCurMessage := '�������';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  FrmMain.Button3.Enabled := True;
  FrmMain.Edit1.Enabled := True;
  FrmMain.ID_DB1.Enabled := True;
  FrmMain.ID_DB2.Enabled := True;
  FrmMain.Hum_db1.Enabled := True;
  FrmMain.Hum_db2.Enabled := True;
  FrmMain.Mir_db1.Enabled := True;
  FrmMain.Mir_db2.Enabled := True;
  FrmMain.HeroMir1.Enabled := True;
  FrmMain.HeroMir2.Enabled := True;
  FrmMain.GuildBase1.Enabled := True;
  FrmMain.GuildBase2.Enabled := True;
  FrmMain.Envir1.Enabled := True;
  FrmMain.Envir2.Enabled := True;
  FrmMain.Data1Edit1.Enabled := True;
  FrmMain.Data2Edit1.Enabled := True;
  FrmMain.HumHero1.Enabled := True;
  FrmMain.HumHero2.Enabled := True;
  FrmMain.CheckBoxSellOffItem.Enabled := True;
  FrmMain.CheckBoxBigStorage.Enabled := True;
  FrmMain.BtnLoadTxt1.Enabled := True;
  FrmMain.BtnClearTxt1.Enabled := True;
  FrmMain.BtnLoadTxt2.Enabled := True;
  FrmMain.BtnClearTxt2.Enabled := True;
  if FileExists(PChar(ExtractFilePath(FrmMain.Hum_db2.text)+'Hum1.DB')) then DeleteFile(PChar(ExtractFilePath(FrmMain.Hum_db2.text)+'Hum1.DB'));
  if FileExists(PChar(ExtractFilePath(FrmMain.HeroMir2.text)+'HeroMir1.DB')) then DeleteFile(PChar(ExtractFilePath(FrmMain.HeroMir2.text)+'HeroMir1.DB'));
  if FileExists(PChar(ExtractFilePath(FrmMain.HumHero2.text)+'HumHero1.DB')) then DeleteFile(PChar(ExtractFilePath(FrmMain.HumHero2.text)+'HumHero1.DB'));
  if FileExists(PChar(ExtractFilePath(FrmMain.Mir_db2.text)+'Mir1.DB')) then DeleteFile(PChar(ExtractFilePath(FrmMain.Mir_db2.text)+'Mir1.DB'));
end;

function TMainWorkThread.GetFileSize(const sFile: string; const OffSet,
  DefSize: Integer): Integer;
var
  Sc: TSearchRec;
begin
  if FindFirst(sFile, faAnyFile, Sc) = 0 then
    Result  := (Sc.Size - OffSet) div DefSize
  else Result  := 0;
  if Result < 0 then Result  := 0;
end;

function TMainWorkThread.GetMaxWorkCount: Integer;
var
  nC: Integer;
begin
  m_sCurMessage := '����ͳ������...';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  nC  := 0;
  Inc(nC, GetFileSize(FrmMain.Hum_db2.text+ '\DBServer\FDB\HUM.db', Sizeof(TDBHeader), Sizeof(TDBHum)));
  Sleep(1);
  Result  := nC;
end;
//�滻�����ַ� 20090315
function TMainWorkThread.IsFilterStr(const sStr: string): string;
begin
  Result := sStr;
  if AnsiContainsText(Result, '��'{V4-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
   if AnsiContainsText(Result, '��'{V4-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V4-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//-------------------------------------------------------------------------------
  if AnsiContainsText(Result, '��'{V5-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V5-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//------------------------------------------------------------------------------
  if AnsiContainsText(Result, '��'{V6-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V6-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//------------------------------------------------------------------------------
  if AnsiContainsText(Result, '��'{V7-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V7-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//------------------------------------------------------------------------------
  if AnsiContainsText(Result, '��'{V8-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V8-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//------------------------------------------------------------------------------
  if AnsiContainsText(Result, '��'{V9-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-5}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-6}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-7}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-8}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-9}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-1}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-2}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-3}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
  if AnsiContainsText(Result, '��'{V9-4}) then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '��', '��'{V1});//�滻�ַ�
  end;
//--------------------------------------------------------------------
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '-');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', 'ı');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', 'ǳ');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
  if AnsiContainsText(Result, '�\') then begin//����ַ����Ƿ���ָ�����ַ�
    Result:= AnsiReplaceText(Result, '�\', '��');//�滻�ַ�
  end;
end;
//��ȡ�������� hum.db 20071122
procedure TMainWorkThread.LoadHumDB(const sRoot: string; ListArray: TStrings{TListArray});
var
  f_H: THandle;
  DBHum: TDBHum;
  nCIDX, nC: Integer;
begin
  if not FileExists(sRoot) then begin
    m_sCurMessage := '�Ҳ����ļ�:' + sRoot ;
   {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;
  f_H := FileOpen(sRoot, 0);
  if f_H <= 0 then begin
    m_sCurMessage := '���ļ�ʧ��!' + sRoot ;
   {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;
  m_sCurMessage := '���ڶ�ȡ: ' + sRoot ;
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  FileSeek(f_H, Sizeof(TDBHeader1), 0);
  nC  := 0;
  m_nCurMax := GetFileSize(sRoot, Sizeof(TDBHeader1), Sizeof(TDBHum));
  while FileRead(f_H, DBHum, Sizeof(DBHum)) = Sizeof(DBHum) do begin
    if (DBHum.sChrName <>'') and (DBHum.sAccount <>'') then begin//20090110
      DBHum.sChrName:= IsFilterStr(DBHum.sChrName);//�����ַ��滻 20090315
      ListArray.Add(DBHum.sChrName);
      {nCIDX :=  GetWWIndex(DBHum.sChrName);
      ListArray[nCIDX].AddObject(DBHum.sChrName, TObject(nC)); }
      Inc(nC); 
    end;
    //m_sCurMessage := '�Ѷ�ȡ ��ɫ��('+IntToStr(nC)+'): ' + DBHum.sChrName;
    //{$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
    //Inc(m_nCurPostion);
    //Inc(m_nTotalPostion);
    {$IF THREADWORK}if Self.Terminated then Break;
    {$ELSE}
      if g_Terminated then Break;
      Application.ProcessMessages;
    {$IFEND}
  end;
  m_sCurMessage := '�Ѷ�ȡ ' + IntToStr(nC) + ' ������';
  //for nC := Low(ListArray) to High(ListArray) do (ListArray[nC] as TStringList).Sort;
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  FileClose(f_H);
end;

//��ȡID.db����  20071122
procedure TMainWorkThread.LoadIDDB(const sRoot: string; ListArray: TListArray);
var
  f_H: THandle;
  ID: TAccountDBRecord;
  nCIDX, nC: Integer;
begin
  if not FileExists(sRoot) then begin
    m_sCurMessage := '�Ҳ����ļ�: ' + sRoot;
   {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;
  f_H := FileOpen(sRoot, 0);
  if f_H <= 0 then begin
    m_sCurMessage := '���ļ�ʧ��! ' + sRoot;
   {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;

  m_sCurMessage := '���ڶ�ȡ: ' + sRoot;
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};

  FileSeek(f_H,Sizeof(TDBHeader), 0);
  nC  := 0;
  m_nCurMax := GetFileSize(sRoot, Sizeof(TDBHeader), Sizeof(TAccountDBRecord));
  m_nCurPostion := 0;

  while FileRead(f_H, ID, Sizeof(ID)) = Sizeof(ID) do begin
    nCIDX :=  GetWWIndex(ID.UserEntry.sAccount);
    ListArray[nCIDX].AddObject(ID.UserEntry.sAccount, TObject(nC));
    Inc(nC);

    //m_sCurMessage := '���ڶ�ȡ�˺�('+IntToStr(nC)+'): ' +ID.UserEntry.sAccount;
    //{$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};

    {$IF THREADWORK}if Self.Terminated then Break;
    {$ELSE}
      if g_Terminated then Break;
      Application.ProcessMessages;
    {$IFEND}
  end;
  m_sCurMessage := '�Ѷ�ȡ ' + IntToStr(nC) + ' ��ID';
  for nC := Low(ListArray) to High(ListArray) do (ListArray[nC] as TStringList).Sort;
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  FileClose(f_H);
end;


//��ȡԪ����������
procedure TMainWorkThread.LoadSellOffItemList(const sRoot: string; SellOffItemList:TList);
var
  f_H: THandle;
  DealOffInfo: pTDealOffInfo;
  sDealOffInfo: TDealOffInfo;
begin
  if not FileExists(sRoot) then  Exit{Raise Exception.Create('�Ҳ����ļ�:'+sRoot )};
  f_H := FileOpen(sRoot, fmOpenRead or fmShareDenyNone);
  if f_H <= 0 then Raise Exception.Create('���ļ�ʧ��! ' + #13 + sRoot);
  if SellOffItemList = nil then Exit;
  if f_H > 0 then begin
    try
      while FileRead(f_H, sDealOffInfo, Sizeof(TDealOffInfo)) = Sizeof(TDealOffInfo) do begin// ѭ��������������
        if (sDealOffInfo.N = 0) or (sDealOffInfo.N = 1) or (sDealOffInfo.N = 3) then begin//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 3-������ȡ�� �Ž��кϲ� 20090331
          New(DealOffInfo);
          DealOffInfo.sDealCharName:= sDealOffInfo.sDealCharName;
          DealOffInfo.sBuyCharName:= sDealOffInfo.sBuyCharName;
          DealOffInfo.dSellDateTime:= sDealOffInfo.dSellDateTime;
          DealOffInfo.nSellGold:= sDealOffInfo.nSellGold;
          DealOffInfo.UseItems:= sDealOffInfo.UseItems;
          DealOffInfo.N:= sDealOffInfo.N;
          SellOffItemList.Add(DealOffInfo);
        end;
      end;
    except
    end;
    FileClose(f_H);
  end;
end;

//����Ԫ����������
procedure TMainWorkThread.SaveSellOffItemList(const sRoot: string; SellOffItemList:TList);
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
        end;
      except
      end;
      FileClose(FileHandle);
    end;
  end;
end;
//�޸Ĵӿ⸱��Ӣ����������
procedure TMainWorkThread.UpdateHeroMirDBName(oleHeroName, NewHeroName: String);
var
  ChrList: TStringList;
  nIndex, I: Integer;
  HumanRCD: TNewHeroDataInfo;
begin
  try
    if HeroDataDB1.Open then begin
      ChrList := TStringList.Create;
      try
        if HeroDataDB1.Find(oleHeroName, ChrList) >= 0 then begin
          for I := 0 to ChrList.Count - 1 do begin
            nIndex := Integer(ChrList.Objects[i]);
            if (HeroDataDB1.Get(nIndex, HumanRCD) <> -1) and (oleHeroName = HumanRCD.Data.sHeroChrName) then begin
              HumanRCD.Data.sHeroChrName:= NewHeroName;
              HeroDataDB1.Update(nIndex, HumanRCD);
            end;
          end;
        end;
      finally
        ChrList.Free;
      end;
    end;
  finally
    HeroDataDB1.Close;
  end;
end;
//���ӿ⸱��Ӣ������д�����⸱��Ӣ��������
procedure TMainWorkThread.ToMainHeroMirDB;
var
  I: Integer;
  HumanRCD: TNewHeroDataInfo;
begin
  try
    if HeroDataDB.Open and HeroDataDB1.Open then begin
      for I := 0 to HeroDataDB1.m_QuickList.Count - 1 do begin
        if HeroDataDB1.Get(I, HumanRCD) <> -1 then begin
          HeroDataDB.Add(HumanRCD);
        end;
        Application.ProcessMessages;
      end;
    end;
  finally
    HeroDataDB.Close;
    HeroDataDB1.Close;
  end;
end;

//�޸ĸ���Ӣ�������б��ļ� nTpye-0 ͨ�����������ң�NewnameΪӢ������ 1-����������NewnameΪ��������
procedure TMainWorkThread.UPdataHeroUserData(sFindName, sNewHeroName: String; nTpye: Byte);
var
  nIndex: Integer;
  HeroNameInfo: THeroNameInfo;
begin
  try
    if HumHeroDB1.Open then begin
      nIndex := HumHeroDB1.Index(sFindName);
      if nIndex >= 0 then begin
        HumHeroDB1.Get(nIndex, HeroNameInfo);
        if HeroNameInfo.Data.sChrName = sFindName then begin
          case nTpye of
            0: HeroNameInfo.Data.sNewHeroName:= sNewHeroName;
            1: HeroNameInfo.Data.sChrName:= sNewHeroName;
          end;
          HumHeroDB1.Update(nIndex, HeroNameInfo);
        end;
      end;
    end;
  finally
    HumHeroDB1.Close;
  end;
end;
//���渱��Ӣ�������б��ļ�
procedure TMainWorkThread.SaveHeroUserData;
var
  I: Integer;
  HeroNameInfo: THeroNameInfo;
begin
  try
    if HumHeroDB.Open and HumHeroDB1.Open then begin
      for I := 0 to HumHeroDB1.m_QuickList.Count - 1 do begin
        if HumHeroDB1.Get(I, HeroNameInfo) <> -1 then begin
          HumHeroDB.Add(HeroNameInfo);
        end;
        Application.ProcessMessages;
      end;
    end;
  finally
    HumHeroDB.Close;
    HumHeroDB1.Close;
  end;
end;

//�޸�Ԫ��������������
procedure TMainWorkThread.UpdateSellOffItemList;
var
  I, J: Integer;
  DealOffInfo: pTDealOffInfo;
  TDearData: pTDearData;
begin
  if OldSellOffItemList.count > 0 then begin
    for I:=0 to OldSellOffItemList.Count - 1 do begin
      DealOffInfo:= pTDealOffInfo(OldSellOffItemList.Items[I]);
      if DealOffInfo <> nil then begin
        J:= NameChangeList.IndexOf(DealOffInfo.sDealCharName);
        if J >= 0 then begin
          TDearData:= pTDearData(NameChangeList.Objects[J]);
          if TDearData <> nil then begin
            DealOffInfo.sDealCharName:= TDearData.sNewHumName;
          end;
        end;
        J:= NameChangeList.IndexOf(DealOffInfo.sBuyCharName);
        if J >= 0 then begin
          TDearData:= pTDearData(NameChangeList.Objects[J]);
          if TDearData <> nil then begin
            DealOffInfo.sBuyCharName:= TDearData.sNewHumName;
          end;
        end;
      end;
    end;
  end;
end;

//��ȡ���޲ֿ�����
procedure TMainWorkThread.LoadBigStorageList(const sRoot: string; m_StorageList:TList);
  procedure DisPoseAndNil(var Obj);
  var
    temp: Pointer;
  begin
    temp := Pointer(Obj);
    Pointer(Obj) := nil;
    Dispose(temp);
  end;
var
  f_H: THandle;
  BigStorage: pTBigStorage;
  sTBigStorage: TBigStorage;
  ItemCount: TItemCount;
  I: Integer;
begin
  if not FileExists(sRoot) then  Exit;{Raise Exception.Create('�Ҳ����ļ�:'+sRoot )};
  f_H := FileOpen(sRoot, fmOpenRead or fmShareDenyNone);
  if f_H <= 0 then Raise Exception.Create('���ļ�ʧ��! ' + #13 + sRoot);
  if m_StorageList = nil then Exit;
  if f_H > 0 then begin
    try
      if FileRead(f_H, ItemCount, SizeOf(TItemCount)) = SizeOf(TItemCount) then begin
        for I := 0 to ItemCount - 1 do begin
          New(BigStorage);
          FillChar(BigStorage.UseItems, SizeOf(TUserItem), #0);
          if (FileRead(f_H, BigStorage^, Sizeof(TBigStorage)) = Sizeof(TBigStorage)) and (not BigStorage.boDelete) then begin// ѭ����������
            m_StorageList.Add(BigStorage);
          end else begin
            DisPoseAndNil(BigStorage);
          end;
        end;
      end;
    except
    end;
    FileClose(f_H);
  end;
end;

//�������޲ֿ�����
procedure TMainWorkThread.SaveBigStorageList(const sRoot: string; m_StorageList:TList);
var
  FileHandle: Integer;
  BigStorage: pTBigStorage;
  I: Integer;
begin
  if FileExists(sRoot) then DeleteFile(sRoot);
  FileHandle := FileCreate(sRoot);
  FileClose(FileHandle);
  if FileExists(sRoot) then begin
    FileHandle := FileOpen(sRoot, fmOpenWrite or fmShareDenyNone);
    if FileHandle > 0 then begin
      FileSeek(FileHandle, 0, 0);
      FileWrite(FileHandle, m_StorageList.Count, SizeOf(TItemCount));//������Ʒ����
      try
        for I:= 0 to m_StorageList.Count -1 do begin
          BigStorage:= pTBigStorage(m_StorageList.Items[I]);
          FileWrite(FileHandle, BigStorage^, SizeOf(TBigStorage));
        end;
      except
      end;
      FileClose(FileHandle);
    end;
  end;
end;

//�޸����޲ֿ���������
procedure TMainWorkThread.UpdateBigStorageList;
var
  I, J: Integer;
  BigStorage: pTBigStorage;
  TDearData: pTDearData;
begin
  if m_StorageList.count > 0 then begin
    for I:=0 to m_StorageList.Count - 1 do begin
      BigStorage:= pTBigStorage(m_StorageList.Items[I]);
      if BigStorage <> nil then begin
        J:= NameChangeList.IndexOf(BigStorage.sCharName);
        if J >= 0 then begin
          TDearData:= pTDearData(NameChangeList.Objects[J]);
          if TDearData <> nil then begin
            BigStorage.sCharName:= TDearData.sNewHumName;
          end;
        end;
      end;
    end;
  end;
end;

//��ȡ�ı��ڴ浽�б� 20080703
procedure TMainWorkThread.LoadTxtDataToList(ListView: TRzListView ; m_Txt:TList);
var
  I,K: Integer;
  TxtData:pTTxtData;
  TxtInfo:pTTxtInfo;
  LoadList: TStringList;
  sFileName, s18: string;
  nTxtTpye: Byte;//�ı�����
  s11,s12,s13:string;
begin
  try
    if ListView.Items.Count > 0 then begin
      LoadList := TStringList.Create;
      try
        for I:=0 to ListView.Items.Count - 1 do begin
          sFileName := ListView.Items.Item[I].Caption;
          LoadList.LoadFromFile(sFileName);
            if (LoadList.Text <> '') then begin //�����ı�����
              s18 := LoadList.Strings[0];
              nTxtTpye:= 0;
              if s18[1] = '[' then nTxtTpye:= 1;
              new(TxtData);
              TxtData.nTxtTpye:= nTxtTpye;//�ı�����
              TxtData.sFileName:=ExtractFileName(sFileName);//�ļ���
              TxtData.sData:= TList.Create ;
              TxtData.boMakeOne := False;

              for K:= 0 to LoadList.Count - 1 do begin
                s18 := LoadList.Strings[K];
                if (Trim(s18) <> '') and (s18[1] <> ';') then begin
                  Case TxtData.nTxtTpye of
                    0:begin
                        New(TxtInfo);
                        TxtInfo.sHumName := s18;
                        TxtInfo.sKeyword:='';
                        TxtInfo.sIniValue:='';
                        if (TxtData.sData <> nil) and (TxtInfo <> nil) then TxtData.sData.Add(TxtInfo);
                     end;
                    1:begin
                        if s18[1]= '[' then begin//�ڵ�
                           ArrestStringEx(s18, '[', ']', s11);//S11-[]�������
                           Continue;
                        end;
                       if pos('=',s18)> 0 then begin
                           s13:=GetValidStr3(s18, s12, ['=']);
                           New(TxtInfo);
                           TxtInfo.sHumName:= S11;//�ڵ���
                           TxtInfo.sKeyword:=Trim(s12);
                           TxtInfo.sIniValue:=Trim(s13);
                           if (TxtData.sData <> nil) and (TxtInfo <> nil) then TxtData.sData.Add(TxtInfo);  //
                        end;
                    end;//1
                  end;//case
                end;
              end;//for K
              if TxtData <> nil then  m_Txt.Add(TxtData);
            end else copyfile(pchar(sFileName), pchar(FrmMain.Edit1.text+'\NEW�ı�����\'+ExtractFileName(sFileName)), false);
        end;//for I
      finally
        LoadList.Free;
      end;
    end;
  except
  end;
end;

//�޸����ֵ��ı������б� 20080703
procedure TMainWorkThread.UpdateTxtDataToList(m_Txt:TList);
var
  I, K, J: Integer;
  TxtData:pTTxtData;
  TxtInfo:pTTxtInfo;
  TDearData: pTDearData;
begin
  if m_Txt.Count <= 0 then Exit;
  Try
     for I:= 0 to m_Txt.Count -1 do begin
       TxtData := pTTxtData(m_Txt.Items[I]);
       if TxtData <> nil then begin
          if TxtData.sData.Count > 0 then begin
            for K:= 0 to TxtData.sData.Count -1 do begin
              TxtInfo:=pTTxtInfo(TxtData.sData.Items[K]);
              if TxtInfo <> nil then begin
                J:= NameChangeList.IndexOf(TxtInfo.sHumName);
                if J >= 0 then begin
                  TDearData:= pTDearData(NameChangeList.Objects[J]);
                  if TDearData <> nil then begin
                    TxtInfo.sHumName:= TDearData.sNewHumName;
                  end;
                end;
              end;
            end;
          end;
       end;//if TxtData <> nil
     end;
  except
  end;
end;

//�����ı����� 20080703
procedure TMainWorkThread.SaveListToTxt(sRoot: string; m_MainTxt, DeputyTxt:TList);
var
  I,K,J: Integer;
  TxtData,TxtData1:pTTxtData;
  TxtInfo1:pTTxtInfo;
  SaveList: TStringList;//��ͨ�ļ�����
  IniFile: TIniFile;//Ini�ļ�
  nCode:Byte;
begin
  SaveList:= TStringList.Create ;
  nCode:=0;
  try
    if DeputyTxt.Count > 0 then begin
      if m_MainTxt.Count > 0 then begin
        for I:= 0 to m_MainTxt.Count -1 do begin
          if pTTxtData(m_MainTxt.Items[I]) <> nil then begin
            TxtData:=pTTxtData(m_MainTxt.Items[I]);
            if TxtData.nTxtTpye <> 0 then Continue;
            for K:= 0 to DeputyTxt.Count -1 do begin
              TxtData1:=pTTxtData(DeputyTxt.Items[K]);
              if TxtData1 <> nil then begin
                if (CompareText(Trim(TxtData.sFileName), Trim(TxtData1.sFileName))= 0) then begin
                   if TxtData1.sData.Count > 0 then begin
                      for J:=0 to TxtData1.sData.Count - 1 do begin
                         TxtInfo1:= pTTxtInfo(TxtData1.sData.Items[J]);
                         if TxtInfo1 <> nil then TxtData.sData.Add(TxtInfo1);
                      end;//for J
                   end;
                   TxtData1.boMakeOne := True;
                end;
              end;//TxtData1 <> nil
            end;//for K
          end;
        end;//for I   
      end;//if m_MainTxt.Count > 0
     nCode:=10;
      for I:=0 to DeputyTxt.Count -1 do begin
        nCode:=11;
        if pTTxtData(DeputyTxt.Items[I])<> nil then begin
           TxtData1:=pTTxtData(DeputyTxt.Items[I]);
           nCode:=12;
           if TxtData1.boMakeOne then Continue;
           case TxtData1.nTxtTpye of
             0:begin//��ͨ�ļ�
                SaveList.Clear;
                nCode:=13;
                if TxtData1.sData.Count > 0 then begin
                  nCode:=14;
                  for K:= 0 to TxtData1.sData.Count -1 do begin
                    nCode:=15;
                    TxtInfo1:=pTTxtInfo(TxtData1.sData.Items[K]);
                    SaveList.Add(TxtInfo1.sHumName);
                  end;
                end;
                nCode:=16;
                SaveList.SaveToFile(sRoot+'\'+TxtData1.sFileName);
             end;
             1:begin
                nCode:=17;
                IniFile := TIniFile.Create(sRoot+'\'+TxtData1.sFileName);
                nCode:=18;
                if TxtData1.sData.Count > 0 then begin
                  nCode:=19;
                  for K:= 0 to TxtData1.sData.Count -1 do begin
                    nCode:=20;
                    TxtInfo1:=pTTxtInfo(TxtData1.sData.Items[K]);
                    IniFile.Writestring(TxtInfo1.sHumName, TxtInfo1.sKeyword, TxtInfo1.sIniValue);
                  end;
                end;
                IniFile.free;
             end;//1
           end;//case
        end;
      end;//for I
    end;

    if m_MainTxt.Count > 0 then begin
     nCode:=21;
      for I:=0 to m_MainTxt.Count -1 do begin
        nCode:=22;
        TxtData1:=pTTxtData(m_MainTxt.Items[I]);
        if TxtData1 <> nil then begin
          nCode:=23;
          if (TxtData1<> nil) then begin
             case TxtData1.nTxtTpye of
               0:begin//��ͨ�ļ�
                  SaveList.Clear;
                  nCode:=24;
                  if TxtData1.sData.Count > 0 then begin
                    nCode:=25;
                    for K:= 0 to TxtData1.sData.Count -1 do begin
                      nCode:=26;
                      TxtInfo1:=pTTxtInfo(TxtData1.sData.Items[K]);
                      nCode:=27;
                      SaveList.Add(TxtInfo1.sHumName);
                    end;
                  end;
                  SaveList.SaveToFile(sRoot+'\'+TxtData1.sFileName);
               end;
               1:begin
                 nCode:=28;
                  IniFile := TIniFile.Create(sRoot+'\'+TxtData1.sFileName);
                  nCode:=34;
                  if TxtData1.sData.Count > 0 then begin
                    nCode:=30;
                    for K:= 0 to TxtData1.sData.Count -1 do begin
                      nCode:=31;
                      TxtInfo1:=pTTxtInfo(TxtData1.sData.Items[K]);
                      nCode:=32;
                      IniFile.Writestring(TxtInfo1.sHumName, TxtInfo1.sKeyword, TxtInfo1.sIniValue);
                    end;
                  end;
                  IniFile.Free;
               end;//1
             end;//case
          end;
        end;
      end;//for I
    end;//if m_MainTxt.Count > 0    }
  except
    m_sCurMessage := '[�쳣] �ı��ϲ�'+ inttostr(nCode);
    {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;
  SaveList.Free;
end;

//�ϲ�����
procedure TMainWorkThread.MakeInOne(sRoot: string);
var
  nIdx, nIdx1: Integer;

  IDCount1,IDCount2,IDCount3:integer;//ID����
  m_Header: TDBHeader; //ID���ݿ�ͷ
  m_Header1,m_Header2: TDBHeader1; //�������ݿ�ͷ
  
  f_IDH, f_HumH, f_MirH: THandle;
  ID: TAccountDBRecord;
  DBHum: TDBHum;
  HumData:THumDataInfo;
  nCIDX, I, J, nStep, nC_01 ,K: Integer;
  sName, sAccount, sOleName: string;
  boReNameOK,boMirOK: Boolean;
  GuildList, HeroTempNameList: TStrings;
  TempIDLists: TListArray;

  DearDataList, MasterDataList, HeroDataList: TList;
  TDearData: pTDearData;
  TMasterData: PTMasterData;
  THeroData: pTHeroData;
  sFileName1, s001, s002, s003: string;
  LoadList: TStringList;
  sTempName: string;
  sOleName20090620: string;
  IniFile: TIniFile;//Ini�ļ�
  procedure ReThisHumInName(const sHumName: string; sNewHumName: string; nCode: Byte);//����ԭ������ż��ʦ���� 20080601
  var
    HumData:THumDataInfo;
    I, J: Integer;
    SearchRec: TSearchRec;
    sFileName, s01, s02: string;
    //DealOffInfo: pTDealOffInfo;
    TMasterData: PTMasterData;
    //BigStorage:pTBigStorage;
  begin
    //�޸�Ԫ����������
    {if boSellOffItem then begin
      if OldSellOffItemList.count > 0 then begin
        for I:=0 to OldSellOffItemList.Count - 1 do begin
          DealOffInfo:= pTDealOffInfo(OldSellOffItemList.Items[I]);
          if DealOffInfo <> nil then begin
            if CompareText(DealOffInfo.sDealCharName , sHumName)= 0 then begin
              DealOffInfo.sDealCharName:= sNewHumName;
              Break;
            end else
            if CompareText(DealOffInfo.sBuyCharName , sHumName)= 0 then begin
              DealOffInfo.sBuyCharName:= sNewHumName;
              Break;
            end;
          end;
        end;
      end;
    end;}
    //�޸����޲ֿ�
    {if boBigStorage then begin
      if m_StorageList.count > 0 then begin
        for I:=0 to m_StorageList.Count - 1 do begin
          BigStorage:= pTBigStorage(m_StorageList.Items[I]);
          if BigStorage <> nil then begin
            if CompareText(BigStorage.sCharName , sHumName)= 0 then begin
              BigStorage.sCharName:= sNewHumName;
              Break;
            end;
          end;
        end;
      end;
    end; }
    sFileName:= FrmMain.Envir2.text+'\MasterNo\';
    if DirectoryExists(sFileName) then begin//�ж�Ŀ¼�Ƿ���� 20080703
      if FindFirst(sFileName+ sHumName+'.txt', 1, SearchRec)= 0 then begin //ʦͽ�ļ�����,�����
        Renamefile(sFileName+ sHumName+'.txt',sFileName+ sNewHumName+'.txt');//�ļ�����
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(sFileName+ sNewHumName +'.txt');
          for J := 0 to LoadList.Count - 1 do begin
            s01 := Trim(LoadList.Strings[J]);
            if (s01 <> '') and (s01[1] <> ';') then begin
              s01 := GetValidStr3(s01, s02, [' ', #9]);//ͽ����
              try
                if HumDataDB1.OpenEx then begin
                  I := HumDataDB1.Index(s02);
                  if I >= 0 then begin
                    if HumDataDB1.Get(I, HumData) >= 0 then begin
                      if HumData.Data.sMasterName <> '' then begin
                        New(TMasterData);
                        TMasterData.sName:= HumData.Data.sChrName;
                        TMasterData.sMasterName:= sNewHumName;
                        TMasterData.sNewHumName:= HumData.Data.sChrName;
                        MasterDataList.Add(TMasterData);
                      end;
                    end;
                  end;
                end;
              finally
                HumDataDB1.Close;
              end;
            end;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
  procedure ReDearList(const sHumName: string; sNewHumName: string);//�޸���ż�б�
  var
    I: Integer;
    TDearData: pTDearData;
    boIsDear: Boolean;
    HumData:THumDataInfo;
  begin
    boIsDear:= False;
    if DearDataList.Count > 0 then begin
      for I:=0 to DearDataList.Count - 1 do begin
        TDearData:= pTDearData(DearDataList.Items[I]);
        if (CompareText(TDearData.sDearName, sHumName)= 0) then begin
          TDearData.sDearName:= sNewHumName;
          boIsDear:= True;
          Break;
        end;
      end;
    end;
    if not boIsDear then begin
      try
        if HumDataDB1.OpenEx then begin
          I := HumDataDB1.Index(sHumName);
          if I >= 0 then begin
            HumDataDB1.Get(I, HumData);
            if HumData.Data.sDearName <> '' then begin//����ż
              New(TDearData);
              TDearData.sDearName:= HumData.Data.sDearName;
              TDearData.sNewHumName:= sNewHumName;
              DearDataList.Add(TDearData);
            end;
          end;
        end;
      finally
        //HumDataDB1.Close;
      end;
    end;
  end;
  procedure ReHeroList(const sHumName: string; sNewHumName, sAccount: string; nCode, nHeroType:Byte; sOleHeroName:string);//�޸�Ӣ���б�
  var
    //HumData:THumDataInfo;
    I, K: Integer;
    THeroData: pTHeroData;
    boIsHero: Boolean;
  begin
    boIsHero:= False;
    Case nCode of
      0:begin
        if HeroDataList.Count > 0 then begin
          for I:=0 to HeroDataList.Count - 1 do begin
            THeroData:= pTHeroData(HeroDataList.Items[I]);
            if (CompareText(THeroData.sHeroName , sHumName)= 0) and (CompareText(THeroData.sAccount , sAccount)= 0) then begin
              THeroData.sNewHumName:= sNewHumName;
              boIsHero:= True;
              Break;
            end;
          end;
        end;
        if not boIsHero then begin
           New(THeroData);
           THeroData.sHeroName:= sHumName;
           THeroData.sNewHumName:= sNewHumName;
           THeroData.sMasterName:= sOleHeroName;
           THeroData.sAccount:= sAccount;
           THeroData.nHeroType:= nHeroType;
           HeroDataList.Add(THeroData);
          {try
            if HumDataDB1.OpenEx then begin
              I := HumDataDB1.Index(sHumName);
              if I >= 0 then begin
                HumDataDB1.Get(I, HumData);
                if CompareText(HumData.Data.sChrName, sHumName)= 0 then begin//Ӣ������ͬ
                   New(THeroData);
                   THeroData.sHeroName:= sHumName;
                   THeroData.sNewHumName:= sNewHumName;
                   THeroData.sMasterName:= HumData.Data.sMasterName;
                   THeroData.sAccount:= sAccount;
                   HeroDataList.Add(THeroData);
                end;
              end;
            end;
          finally
            //HumDataDB1.Close;
          end; }
        end; 
      end;//0
      1: begin
        K:= 0;
        if HeroDataList.Count > 0 then begin
          for I:=0 to HeroDataList.Count - 1 do begin
            THeroData:= pTHeroData(HeroDataList.Items[I]);
            if (CompareText(THeroData.sMasterName , sHumName)= 0) and (CompareText(THeroData.sAccount , sAccount)= 0) then begin
              if CompareText(THeroData.sHeroName , sOleHeroName) = 0 then boIsHero:= True;
              THeroData.sMasterName:= sNewHumName;
              Inc(K);
              if K >= 2 then Break;
            end;
          end;
        end;
        if not boIsHero then begin//20090620 ���ӣ���Ӣ�۲����������˸���ʱ���������
          New(THeroData);
          THeroData.sHeroName:= sOleHeroName;//Ӣ����
          THeroData.sNewHumName:= sOleHeroName;
          THeroData.sMasterName:= sNewHumName;//������
          THeroData.sAccount:= sAccount;//�˺�
          THeroData.nHeroType:= 0;
          HeroDataList.Add(THeroData);
        end;
      end;//1
    end;//case
  end;
  procedure ReThisHumInMasterNo(const sHumName: string; sNewHumName: string);
  var
    HumData:THumDataInfo;
    I: Integer;
    boIsMasterNo: Boolean;
  begin
    boIsMasterNo:= False;
    if MasterDataList.Count > 0 then begin
      for I:= 0 to MasterDataList.Count - 1 do begin
        TMasterData:= PTMasterData(MasterDataList.Items[I]);
        if CompareText(Trim(TMasterData.sMasterName), sHumName)= 0 then begin//ʦ������
          TMasterData.sMasterName:= sNewHumName;
          boIsMasterNo:= True;
          Break;
        end;
        if CompareText(Trim(TMasterData.sName), sHumName)= 0 then begin//ͽ�ܸ���
          TMasterData.sNewHumName:= sNewHumName;
          boIsMasterNo:= True;
          Break;
        end;
      end;
    end;
    if not boIsMasterNo then begin
      try
        if HumDataDB1.OpenEx then begin
          I := HumDataDB1.Index(sHumName);
          if I >= 0 then begin
            HumDataDB1.Get(I, HumData);
            if (HumData.Data.sMasterName <> '') and (not HumData.Data.boIsHero) then begin//��ͽ��
              New(TMasterData);
              TMasterData.sName:= sHumName;
              TMasterData.sMasterName:= HumData.Data.sMasterName;
              TMasterData.sNewHumName:= sNewHumName;
              MasterDataList.Add(TMasterData);
            end;
          end;
        end;
      finally
        //HumDataDB1.Close;
      end;
    end;
  end;
  procedure ReThisHumInGuild(const sHumName: string; sNewHumName: string);
  var
    SL: TStrings;
    Sc: TSearchRec;
    n_0023C : Integer;
  begin
    SL  := TStringList.Create;
    if FindFirst(sRoot + '\Guilds\*.txt', faAnyFile, Sc) = 0 then begin
      SL.LoadFromFile(sRoot + '\Guilds\' + Sc.Name);
      n_0023C := SL.IndexOf('+' + sHumName);
      if n_0023C > -1 then begin
        SL.Strings[n_0023C] := '+' + sNewHumName;
        SL.SaveToFile(sRoot + '\Guilds\' + Sc.Name);
        SL.Free;
        Exit;
      end;
    end;
    while FindNext(Sc) = 0 do begin
      SL.LoadFromFile(sRoot + '\Guilds\' + Sc.Name);
      n_0023C := SL.IndexOf('+' + sHumName);
      if n_0023C > -1 then begin
        SL.Strings[n_0023C] := sNewHumName;
        SL.SaveToFile(sRoot + '\Guilds\' + Sc.Name);
        SL.Free;
        Exit;
      end;
      Application.ProcessMessages;
    end;
    SL.Free;
  end;
begin
  DearDataList:= TList.Create;
  MasterDataList:= TList.Create;
  HeroDataList:= TList.Create;

  IDCount1:=0;

  if f_MainIDH = 0 then f_MainIDH := FileOpen(m_sMainRoot + '\LoginSrv\IDDB\Id.db', fmOpenReadWrite);

//�򿪴ӿ������ļ�  20071122
  f_IDH := FileOpen(FrmMain.ID_DB2.text, 0);

  FileSeek(f_MainIDH, 0, 0);
  if FileRead(f_MainIDH, m_Header, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then IDCount1 := m_Header.nIDCount;

  m_nCurMax  := GetFileSize(FrmMain.Hum_db2.text, Sizeof(TDBHeader1), Sizeof(TDBHum));
  
  m_nCurPostion := 0;
  for I := Low(TempIDLists) to HIgh(TempIDLists) do TempIDLists[I]:= TStringList.Create;
  HeroTempNameList := TStringList.Create;//20081129
//----------------------------Ӣ���Ⱥ�------------------------------------------
  try
    if HumChrDB1.OpenEx and HumDataDB1.OpenEx then begin
      for K:= 0 to HumChrDB1.m_QuickList.Count - 1 do begin
        FillChar(DBHum, SizeOf(TDBHum), #0);
        sOleName:='';
        if HumChrDB1.GetBy(K, DBHum) then begin
          nIdx := HumDataDB1.Index(DBHum.sChrName);
          if nIdx >= 0 then begin
            if not DBHum.Header.boIsHero then Continue;//����Ӣ������
            FillChar(HumData, SizeOf(HumData), #0);
            if HumDataDB1.Get(nIdx, HumData) >= 0 then begin
              if HeroTempNameList.IndexOf(DBHum.sChrName) >= 0 then Continue;
              try
                if HumChrDB.OpenEx and HumDataDB.OpenEx then begin
                  sName:= IsFilterStr(DBHum.sChrName);//�����ַ��滻 20090315 20090404
                  if NameList.IndexOf(sName) >= 0 then begin//���Ӣ�����Ƿ��ظ� 20090404
                    nStep := 2;
                    boReNameOK  := False;
                    for I := Ord('a') to Ord('z') do begin
                      sTempName := _Max14ReName(sName, Chr(I));
                      if not (NameList.IndexOf(sTempName) > -1) then begin
                        boReNameOK := True;
                        sName:= sTempName;
                        Break;
                      end;
                    end;
                    if not boReNameOK then begin
                      while True do begin
                        sName := IntToHex(Random(MaxInt), 14);
                        if not (NameList.IndexOf(sName) > -1) then begin
                          boReNameOK := True;
                          Break;
                        end;
                      end;
                    end;
                    nStep := 3;
                    if boReNameOK then begin//�����ɹ�
                      sOleName20090620:= DBHum.sChrName;
                      New(TDearData);
                      TDearData.sDearName:= DBHum.sChrName;//������
                      TDearData.sNewHumName:= sName;//������
                      NameChangeList.AddObject(DBHum.sChrName, @TDearData^);

                      sOleName:= DBHum.sChrName;
                      NameList.Add(sName);
                      HeroTempNameList.Add(DBHum.sChrName);//��Ӣ��ԭ��д����ʱ�б��У��Լ�������ϲ�ʱ���ٶ�
                      DBHum.Header.sName  := sName;
                      HumData.Data.sChrName:= sName;
                      HumData.Header.sName:= sName;
                      DBHum.sChrName      := sName;
                      nStep := 5;
                      nCIDX := GetWWIndex(DBHum.sAccount);
                      J := m_SubIDLists[nCIDX].IndexOf(DBHum.sAccount);
                      if J < 0 then begin //T
                        m_sCurMessage := '����(����Ӣ��ʧ��):' + DBHum.sChrName + ' �ӿ�ID.DB�޴��˺�:'+DBHum.sAccount;
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      nStep := 6;
                      FileSeek(f_IDH, Sizeof(TDBHeader) + Sizeof(TAccountDBRecord) * Integer(m_SubIDLists[nCIDX].Objects[J]), 0);
                      FileRead(f_IDH, ID, Sizeof(ID));
                      sAccount  := ID.UserEntry.sAccount;
                      //1
                      if CompareText(sAccount, DBHum.sAccount) <> 0 then  begin //T
                        m_sCurMessage := '����(����Ӣ��ʧ��):' + DBHum.sChrName + ' �ʺŲ�ƥ��!';
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      nStep := 7;
                      //2
                      nC_01 := IDOldLists[nCIDX].IndexOf(sAccount);
                      if (nC_01 > -1) then begin
                        sAccount := IDChangedLists[nCIDX].Strings[nC_01];
                      end else begin
                        if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                          TempIDLists[nCIDX].Add(sAccount);
                          if (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1) or (m_IDChangeByHero.IndexOf(sAccount) > -1) then begin
                            boReNameOK  := False;
                            nStep := 8;
                            for I := Ord('a') to Ord('z') do begin
                              sTempName := _Max10ReName(sAccount, Chr(I));
                              if (not (m_MainIDLists[nCIDX].IndexOf(sTempName) > -1)) and (not (m_IDChangeByHero.IndexOf(sTempName) > -1)) then begin
                                boReNameOK := True;
                                sAccount := sTempName;
                                Break;
                              end;
                            end;
                            if not boReNameOK then
                              while True do begin
                                sAccount := IntToHex(Random(MaxInt), 10);
                                nCIDX    := GetWWIndex(sAccount);
                                if (not (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1)) and (not (m_IDChangeByHero.IndexOf(sAccount) > -1)) then Break;
                              end;
                            nStep:= 9;
                            IDChangedLists[nCIDX].Add(sAccount);
                            IDOldLists[nCIDX].Add(ID.UserEntry.sAccount);
                            m_IDChangeByHero.Add(sAccount);
                          end;
                        end;//if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                      end;
                      ID.Header.sAccount    := sAccount;
                      ID.UserEntry.sAccount := sAccount;
                      DBHum.sAccount := sAccount;
                      HumData.Data.sAccount := sAccount;
                      ReHeroList(sOleName20090620, DBHum.sChrName, DBHum.sAccount, 0, HumData.Data.btEF, HumData.Data.sMasterName);//�޸�Ӣ���б�
                      if HumData.Data.btEF = 3 then begin//�Ƿ񽫲Ž����޸�HumHero.db,Heromir.db
                        UpdateHeroMirDBName(sOleName ,sName);//�޸Ĵӿ⸱��Ӣ������ 20100117
                        UPdataHeroUserData(HumData.Data.sMasterName, sName, 0);//�޸ĸ���Ӣ�������б��ļ�
                      end;
                      HumChrDB.Add(DBHum);
                      HumDataDB.Add(HumData);
                      nStep := 12;
                    end;
                  end else begin//���ظ���ֱ����ӽ�����������
                    nCIDX := GetWWIndex(DBHum.sAccount);
                    J := m_SubIDLists[nCIDX].IndexOf(DBHum.sAccount);
                    if J < 0 then begin //T
                      m_sCurMessage := '����(����Ӣ��ʧ��):' + DBHum.sChrName + ' �ӿ�ID.DB�޴��˺�:'+DBHum.sAccount;
                      {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                      Inc(m_nFailed);
                      Inc(m_nTotalPostion);
                      Inc(m_nCurPostion);
                      Continue;
                    end;
                    nStep := 6;
                    FileSeek(f_IDH, Sizeof(TDBHeader) + Sizeof(TAccountDBRecord) * Integer(m_SubIDLists[nCIDX].Objects[J]), 0);
                    FileRead(f_IDH, ID, Sizeof(ID));
                    sAccount  := ID.UserEntry.sAccount;
                    //1
                    if CompareText(sAccount, DBHum.sAccount) <> 0 then  begin //T
                      m_sCurMessage := '����(����Ӣ��ʧ��):' + DBHum.sChrName + ' �ʺŲ�ƥ��!';
                      {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                      Inc(m_nFailed);
                      Inc(m_nTotalPostion);
                      Inc(m_nCurPostion);
                      Continue;
                    end;
                    nStep := 7;
                    //2
                    nC_01 := IDOldLists[nCIDX].IndexOf(sAccount);
                    if (nC_01 > -1) then begin
                      sAccount := IDChangedLists[nCIDX].Strings[nC_01];
                    end else begin
                      if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                        TempIDLists[nCIDX].Add(sAccount);
                        if (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1) or (m_IDChangeByHero.IndexOf(sAccount) > -1) then begin
                          boReNameOK  := False;
                          nStep := 8;
                          for I := Ord('a') to Ord('z') do begin
                            sTempName := _Max10ReName(sAccount, Chr(I));
                            if (not (m_MainIDLists[nCIDX].IndexOf(sTempName) > -1)) and (not (m_IDChangeByHero.IndexOf(sTempName) > -1)) then begin
                              boReNameOK := True;
                              sAccount := sTempName;
                              Break;
                            end;
                          end;
                          if not boReNameOK then
                            while True do begin
                              sAccount := IntToHex(Random(MaxInt), 10);
                              nCIDX    := GetWWIndex(sAccount);
                              if (not (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1)) and (not (m_IDChangeByHero.IndexOf(sAccount) > -1)) then Break;
                            end;
                          nStep:= 9;
                          IDChangedLists[nCIDX].Add(sAccount);
                          IDOldLists[nCIDX].Add(ID.UserEntry.sAccount);
                          m_IDChangeByHero.Add(sAccount);
                        end;
                      end;//if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                    end;
                    ID.Header.sAccount    := sAccount;
                    ID.UserEntry.sAccount := sAccount;
                    DBHum.sAccount := sAccount;
                    HumData.Data.sAccount := sAccount;
                    //if HumData.Data.btEF = 3 then begin//20100206 ע��
                      ReHeroList(HumData.Data.sChrName, HumData.Data.sChrName, DBHum.sAccount, 0, 3{HumData.Data.btEF}, HumData.Data.sMasterName);//�޸�Ӣ���б�
                    //end;
                    NameList.Add(DBHum.sChrName);
                    HumChrDB.Add(DBHum);
                    HumDataDB.Add(HumData);
                  end;
                end
              finally
                HumChrDB.Close;
                HumDataDB.Close;
              end;
              Inc(m_nTotalPostion);
              Inc(m_nCurPostion);
              {$IF THREADWORK}if Self.Terminated then Break;
              {$ELSE}
                if g_Terminated then Break;
                Application.ProcessMessages;
              {$IFEND}
            end;
          end;
        end;
      end;
    end;
  finally
    HumChrDB1.Close;
    HumDataDB1.Close;
  end;
//-------------------------�ϲ�����--------------------------------------------
  try
    if HumChrDB1.OpenEx and HumDataDB1.OpenEx then begin
      for K:= 0 to HumChrDB1.m_QuickList.Count - 1 do begin
        FillChar(DBHum, SizeOf(TDBHum), #0);
        sOleName:='';
        if HumChrDB1.GetBy(K, DBHum) then begin
          nIdx := HumDataDB1.Index(DBHum.sChrName);
          if nIdx >= 0 then begin
            if DBHum.Header.boIsHero then Continue;//��Ӣ������
            if HeroTempNameList.IndexOf(DBHum.sChrName) >= 0 then Continue;//������Ӣ������ʱ�б��д�������Ϊ��Ӣ�ۣ����� 20081129
            FillChar(HumData, SizeOf(HumData), #0);
            if HumDataDB1.Get(nIdx, HumData) >= 0 then begin
              try
                if HumChrDB.OpenEx and HumDataDB.OpenEx then begin
                  sName:= IsFilterStr(DBHum.sChrName);//�����ַ��滻 20090315  20090404
                  if NameList.IndexOf(sName) >= 0 then begin//����������Ƿ��ظ�  20090404
                    boReNameOK  := False;
                    for I := Ord('a') to Ord('z') do begin
                      sTempName := _Max14ReName(sName, Chr(I));
                      if not (NameList.IndexOf(sTempName) > -1) then begin
                        boReNameOK := True;
                        sName:= sTempName;
                        Break;
                      end;
                    end;
                    if not boReNameOK then begin
                      while True do begin
                        sName := IntToHex(Random(MaxInt), 14);
                        if not (NameList.IndexOf(sName) > -1) then begin
                          boReNameOK := True;
                          Break;
                        end;
                      end;
                    end;
                    if boReNameOK then begin//ȡ�ò��ظ�������
                      sOleName20090620:= DBHum.sChrName;
                      ReThisHumInName(DBHum.sChrName, sName, 0);//�޸ļ���,ʦͽ�ļ�

                      ReDearList(DBHum.sChrName, sName);//�޸���ż�б�
                      ReThisHumInGuild(DBHum.sChrName, sName);//���¸�������л���Ϣ
                      ReThisHumInMasterNo(DBHum.sChrName, sName);//����ʦͽ�ļ� 20080601

                      New(TDearData);
                      TDearData.sDearName:= DBHum.sChrName;//������
                      TDearData.sNewHumName:= sName;//������
                      NameChangeList.AddObject(DBHum.sChrName, @TDearData^);

                      NameList.Add(sName);
                      DBHum.Header.sName  := sName;
                      HumData.Data.sChrName:= sName;
                      HumData.Header.sName:=sName;
                      //----------------���ID�Ƿ��ظ�---------------------------------
                      nStep := 5;
                      nCIDX := GetWWIndex(DBHum.sAccount);
                      J := m_SubIDLists[nCIDX].IndexOf(DBHum.sAccount);
                      if J < 0 then begin //T
                        m_sCurMessage := '����(��������ʧ��):' + DBHum.sChrName + '  �ӿ�ID.DB�޴��˺�:'+DBHum.sAccount;
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      sOleName := DBHum.sChrName;
                      DBHum.sChrName      := sName;
                      nStep := 6;
                      FileSeek(f_IDH, Sizeof(TDBHeader) + Sizeof(TAccountDBRecord) * Integer(m_SubIDLists[nCIDX].Objects[J]), 0);
                      FileRead(f_IDH, ID, Sizeof(ID));
                      sAccount  := ID.UserEntry.sAccount;
                      //1
                      if (CompareText(sAccount, DBHum.sAccount) <> 0) then  begin //T
                        m_sCurMessage := '����(��������ʧ��):' + DBHum.sChrName + ' �ʺŲ�ƥ��!';
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      nStep := 7;
                      //2
                      nC_01 := IDOldLists[nCIDX].IndexOf(sAccount);
                      if (nC_01 > -1) then begin
                        sAccount := IDChangedLists[nCIDX].Strings[nC_01];
                      end else begin
                        if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                          TempIDLists[nCIDX].Add(sAccount);
                          if m_MainIDLists[nCIDX].IndexOf(sAccount) > -1 then begin
                            boReNameOK  := False;
                            nStep := 8;
                            for I := Ord('a') to Ord('z') do begin
                              sTempName := _Max10ReName(sAccount, Chr(I));
                              if not (m_MainIDLists[nCIDX].IndexOf(sTempName) > -1) then begin
                                boReNameOK := True;
                                sAccount := sTempName;
                                Break;
                              end;
                            end;
                            if not boReNameOK then begin
                              while True do begin
                                sAccount := IntToHex(Random(MaxInt), 10);
                                nCIDX    := GetWWIndex(sAccount);
                                if not (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1) then Break;
                              end;
                            end;  
                            nStep:= 9;
                            IDChangedLists[nCIDX].Add(sAccount);
                            IDOldLists[nCIDX].Add(ID.UserEntry.sAccount);
                          end;
                        end;//if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                      end;
                      nStep := 10;
                      DBHum.sAccount := sAccount;
                      HumChrDB.Add(DBHum);
                      if HumData.Data.sHeroChrName <> '' then begin
                        if HeroDataList.Count > 0 then begin
                          for I:= 0 to HeroDataList.Count - 1 do begin
                            THeroData:= PTHeroData(HeroDataList.Items[I]);
                            if (CompareText(Trim(THeroData.sHeroName), Trim(HumData.Data.sHeroChrName))= 0)
                            and (not HumData.Header.boIsHero) and (CompareText(Trim(THeroData.sAccount), Trim(HumData.Data.sAccount))= 0) then begin
                              HumData.Data.sHeroChrName:= THeroData.sNewHumName;
                              THeroData.sMasterName:= HumData.Data.sChrName;
                              Break;
                            end;
                          end;
                        end;
                      end;
                      if HumData.Data.sDearName <> '' then begin
                        if DearDataList.Count > 0 then begin
                          for I:= 0 to DearDataList.Count - 1 do begin
                            TDearData:= PTDearData(DearDataList.Items[I]);
                            if (CompareText(Trim(TDearData.sDearName), Trim(HumData.Data.sDearName))= 0) and (not HumData.Header.boIsHero) then begin//��ż����ͬ
                              HumData.Data.sDearName:= TDearData.sNewHumName;
                              //DearDataList.Delete(I);
                              Break;
                            end;
                          end;
                        end;
                      end;
                      HumData.Data.sAccount := sAccount;
                      HumDataDB.Add(HumData);
                      ReHeroList(sOleName20090620, DBHum.sChrName, DBHum.sAccount, 1, 0, HumData.Data.sHeroChrName);//�޸�Ӣ���б�
                      UPdataHeroUserData(sOleName, HumData.Data.sChrName, 1);//�޸ĸ���Ӣ�������б��ļ�
                      ID.Header.sAccount    := sAccount;
                      ID.UserEntry.sAccount := sAccount;
                      if (not HumData.Header.boIsHero) and (not (m_MainIDLists[nCIDX].IndexOf(ID.Header.sAccount) > -1)) then begin //д��ID.DB,��ID��Ϣ(Ӣ�۽�ɫ,��д��ID.DB)
                        m_MainIDLists[nCIDX].Add(sAccount);//20081224 �����ڣ���д���ļ���
                        Inc(IDCount1);
                        FileSeek(f_MainIDH, 0, 0);
                        nStep := 19;
                        m_Header.sDesc:=DBFileDesc;
                        m_Header.nDeletedIdx:=-1;
                        m_Header.dLastDate := Now();
                        m_Header.dUpdateDate := Now();
                        nStep := 20;
                        m_Header.nLastIndex := IDCount1;//20080615 �޸�
                        m_Header.nIDCount:=IDCount1;
                        FileWrite(f_MainIDH, m_Header, SizeOf(TDBHeader));
                        FileSeek(f_MainIDH, 0, 2);//2---���ļ�β����λ
                        nStep := 13;
                        FileWrite(f_MainIDH, ID, Sizeof(ID));//д��ID.DB�ļ�
                      end;
                    end;
                  end else begin//���ظ���ֱ����ӽ�����������
                      //----------------���ID�Ƿ��ظ�---------------------------------
                      nStep := 5;
                      nCIDX := GetWWIndex(DBHum.sAccount);
                      J := m_SubIDLists[nCIDX].IndexOf(DBHum.sAccount);
                      if J < 0 then begin //T
                        m_sCurMessage := '����(��������ʧ��):' + DBHum.sChrName + '  �ӿ�ID.DB�޴��˺�:'+DBHum.sAccount;
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      nStep := 6;
                      FileSeek(f_IDH, Sizeof(TDBHeader) + Sizeof(TAccountDBRecord) * Integer(m_SubIDLists[nCIDX].Objects[J]), 0);
                      FileRead(f_IDH, ID, Sizeof(ID));
                      sAccount  := ID.UserEntry.sAccount;
                      //1
                      if (CompareText(sAccount, DBHum.sAccount) <> 0) then  begin //T
                        m_sCurMessage := '����(��������ʧ��):' + DBHum.sChrName + ' �ʺŲ�ƥ��!';
                        {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
                        Inc(m_nFailed);
                        Inc(m_nTotalPostion);
                        Inc(m_nCurPostion);
                        Continue;
                      end;
                      nStep := 7;
                      //2
                      nC_01 := IDOldLists[nCIDX].IndexOf(sAccount);
                      if (nC_01 > -1) then begin
                        sAccount := IDChangedLists[nCIDX].Strings[nC_01];
                      end else begin
                        if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                          TempIDLists[nCIDX].Add(sAccount);
                          if m_MainIDLists[nCIDX].IndexOf(sAccount) > -1 then begin
                            boReNameOK  := False;
                            nStep := 8;
                            for I := Ord('a') to Ord('z') do begin
                              sTempName := _Max10ReName(sAccount, Chr(I));
                              if not (m_MainIDLists[nCIDX].IndexOf(sTempName) > -1) then begin
                                boReNameOK := True;
                                sAccount := sTempName;
                                Break;
                              end;
                            end;
                            if not boReNameOK then begin
                              while True do begin
                                sAccount := IntToHex(Random(MaxInt), 10);
                                nCIDX    := GetWWIndex(sAccount);
                                if not (m_MainIDLists[nCIDX].IndexOf(sAccount) > -1) then Break;
                              end;
                            end;  
                            nStep:= 9;
                            IDChangedLists[nCIDX].Add(sAccount);
                            IDOldLists[nCIDX].Add(ID.UserEntry.sAccount);
                          end;
                        end;//if not (TempIDLists[nCIDX].IndexOf(sAccount) > - 1) then begin
                      end;
                      nStep := 10;
                      DBHum.sAccount        := sAccount;
                      //-------------------------------------------------------------
                      NameList.Add(DBHum.sChrName);
                      HumChrDB.Add(DBHum);
                      if HumData.Data.sHeroChrName <> '' then begin
                        if HeroDataList.Count > 0 then begin
                          for I:= 0 to HeroDataList.Count - 1 do begin
                            THeroData:= PTHeroData(HeroDataList.Items[I]);
                            if (CompareText(Trim(THeroData.sHeroName), Trim(HumData.Data.sHeroChrName))= 0)
                            and (not HumData.Header.boIsHero) and (CompareText(Trim(THeroData.sAccount), Trim(HumData.Data.sAccount))= 0)  then begin
                              HumData.Data.sHeroChrName:= THeroData.sNewHumName;
                              THeroData.sMasterName:= HumData.Data.sChrName;
                              Break;
                            end;
                          end;
                        end;
                      end;
                      if HumData.Data.sDearName <> '' then begin
                        if DearDataList.Count > 0 then begin
                          for I:= 0 to DearDataList.Count - 1 do begin
                            TDearData:= PTDearData(DearDataList.Items[I]);
                            if (CompareText(Trim(TDearData.sDearName), Trim(HumData.Data.sDearName))= 0)                    //20090806 ע��
                              and (not HumData.Header.boIsHero) {and (CompareText(Trim(THeroData.sAccount), Trim(HumData.Data.sAccount))= 0)} then begin//��ż����ͬ
                              HumData.Data.sDearName:= TDearData.sNewHumName;
                              //DearDataList.Delete(I);
                              Break;
                            end;
                          end;
                        end;
                      end;                      
                      HumData.Data.sAccount := sAccount;
                      HumDataDB.Add(HumData);
                      ID.Header.sAccount    := sAccount;
                      ID.UserEntry.sAccount := sAccount;
                      if (not HumData.Header.boIsHero) and (not (m_MainIDLists[nCIDX].IndexOf(ID.Header.sAccount) > -1)) then begin //д��ID.DB,��ID��Ϣ(Ӣ�۽�ɫ,��д��ID.DB)
                        m_MainIDLists[nCIDX].Add(sAccount);//20081224 �����ڣ���д���ļ���
                        Inc(IDCount1);
                        FileSeek(f_MainIDH, 0, 0);
                        nStep := 19;
                        m_Header.sDesc:=DBFileDesc;
                        m_Header.nDeletedIdx:=-1;
                        m_Header.dLastDate := Now();
                        m_Header.dUpdateDate := Now();
                        nStep := 20;
                        m_Header.nLastIndex := IDCount1;//20080615 �޸�
                        m_Header.nIDCount:=IDCount1;
                        FileWrite(f_MainIDH, m_Header, SizeOf(TDBHeader));
                        FileSeek(f_MainIDH, 0, 2);//2---���ļ�β����λ
                        nStep := 13;
                        FileWrite(f_MainIDH, ID, Sizeof(ID));//д��ID.DB�ļ�
                      end;
                  end;
                end;
              finally
                HumChrDB.Close;
                HumDataDB.Close;
              end;
              Inc(m_nTotalPostion);
              Inc(m_nCurPostion);
              {$IF THREADWORK}if Self.Terminated then Break;
              {$ELSE}
                if g_Terminated then Break;
                Application.ProcessMessages;
              {$IFEND}
            end;
          end;
        end;
      end;
    end;
  finally
    HumChrDB1.Close;
    HumDataDB1.Close;
  end;
  ToMainHeroMirDB;//���ӿ⸱��Ӣ������д�����⸱��Ӣ��������
  SaveHeroUserData;//���ӿ����帱����������д��������

  GuildList := TStringList.Create;
  if FileExists(FrmMain.GuildBase2.text+'\GuildList.txt') then begin//20081230
    GuildList.LoadFromFile(FrmMain.GuildBase2.text+'\GuildList.txt');//20071122
    (GuildList as TStringList).Sort;
    while GuildList.Count > 0 do begin
      try
        sName := GuildList.Strings[0];
        if Self.m_sMainGuildList.IndexOf(sName) > -1 then begin
          boReNameOK  := False;
          for I := Ord('a') to Ord('z') do begin
            sTempName :=  sName + Chr(I);
            if not (Self.m_sMainGuildList.IndexOf(sTempName) > -1) then begin
              boReNameOK  := True;
              sName:= sTempName;
              Break;
            end;
          end;
          if not boReNameOK then
            while True do begin
              sName := IntToHex(Random(MaxInt), 32);
              if not (m_sMainGuildList.IndexOf(sName) > -1) then Break;
            end;
        end;
        if sName <> GuildList.Strings[0] then begin
          Self.m_sGuildChangedList.Add('"' + GuildList.Strings[0] + '"' + #9#9#9#9 + '"' + sName + '"');
        end;
        Windows.CopyFile(PChar(sRoot + '\Guilds\' + GuildList.Strings[0] + '.txt'),
                         PChar(m_sMainRoot + '\Mir200\GuildBase\Guilds\' + sName + '.txt'),
                         True);
        Windows.CopyFile(PChar(sRoot + '\Guilds\' + GuildList.Strings[0] + '.ini'),
                         PChar(m_sMainRoot + '\Mir200\GuildBase\Guilds\' + sName + '.ini'),
                         True);
        if sName <> GuildList.Strings[0] then begin
          IniFile := TIniFile.Create(m_sMainRoot + '\Mir200\GuildBase\Guilds\' + sName + '.ini');
          try
            IniFile.Writestring('Guild', 'GuildName', sName);
          finally
            IniFile.Free;
          end;
        end;
        m_sMainGuildList.Add(sName);
        GuildList.Delete(0);
      Except
        On E: Exception do begin
          m_sCurMessage := E.Message;
          {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
        end;
      end;
     Application.ProcessMessages;
    end;
  end;
  try
    if boSellOffItem then begin
      UpdateSellOffItemList;//�޸�Ԫ��������������
      LoadSellOffItemList(FrmMain.Envir1.text+'\UserData\UserData.dat' ,OldSellOffItemList);//��ȡ����Ԫ���������� 20080601
      SaveSellOffItemList(FrmMain.Edit1.Text+'\Mir200\Envir\UserData\UserData.dat',OldSellOffItemList);//�����ļ�
    end;
    if boBigStorage then begin
      UpdateBigStorageList;//�޸����޲ֿ���������
      LoadBigStorageList(FrmMain.Envir1.text+'\Market_Storage\UserStorage.db' ,m_StorageList);//��ȡ�������޲ֿ����� 20080601
      SaveBigStorageList(FrmMain.Edit1.text+'\Mir200\Envir\Market_Storage\UserStorage.db',m_StorageList);//�������޲ֿ�����
    end;
    if DirectoryExists(FrmMain.Envir2.text+'\MasterNo\') then
      FrmMain.CopyDirAll(FrmMain.Envir2.text+'\MasterNo\',FrmMain.Edit1.Text+'\Mir200\Envir\MasterNo');//��������Ŀ¼

    UpdateTxtDataToList(g_DeputyTxtList);//���´ӿ��ı����ݵ�������Ϣ
    SaveListToTxt(FrmMain.Edit1.text+'\NEW�ı�����', g_MainTxtList, g_DeputyTxtList);//�����ı��б� 20080703
  Except
    On E: Exception do begin
      m_sCurMessage := '������������쳣��';
      {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
      m_sCurMessage := E.Message;
      {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
    end;
  end;

  FileClose(f_IDH);
  if f_MainIDH > 0 then FileClose(f_MainIDH);

  m_sCurMessage := '���ڱ����ļ�...';
  {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};

  if MasterDataList.Count > 0 then begin
    for I:= 0 to MasterDataList.Count - 1 do begin
      TMasterData:= PTMasterData(MasterDataList.Items[I]);
      sFileName1 := Self.m_sMainRoot + '\Mir200\Envir\MasterNo\'+TMasterData.sMasterName+'.txt';
      if FileExists(sFileName1) then begin
        LoadList := TStringList.Create;
        LoadList.LoadFromFile(sFileName1);
        for J := 0 to LoadList.Count - 1 do begin
          s001 := Trim(LoadList.Strings[J]);
          if (s001 <> '') and (s001[1] <> ';') then begin
             s001 := GetValidStr3(s001, s002, [' ', #9]);//ͽ����
             s001 := GetValidStr3(s001, s003, [' ', #9]);//����
             if CompareText(s002, TMasterData.sName)= 0 then begin
               LoadList.Strings[J]:= TMasterData.sNewHumName+' '+s003;
               LoadList.SaveToFile(sFileName1);
               Break;
             end;
          end;
        end;
        LoadList.Free;
      end;
    end;
  end;

  Try
    try
      if HumDataDB.Open then begin
        if HeroDataList.Count > 0 then begin
          for I:= 0 to HeroDataList.Count - 1 do begin
            THeroData:= pTHeroData(HeroDataList.Items[I]);
            if THeroData.sMasterName <> '' then begin
              J := HumDataDB.Index(THeroData.sNewHumName);//Ӣ�����ݣ��޸Ķ�Ӧ��������
              if (J >= 0) then begin
                if HumDataDB.Get(J, HumData) >= 0 then begin
                  if (CompareText(Trim(THeroData.sAccount), Trim(HumData.Data.sAccount))= 0) then begin//20090408
                    HumData.Data.sMasterName:= THeroData.sMasterName;
                    HumDataDB.Update(J, HumData);
                  end;
                end;
              end;
              if THeroData.nHeroType <> 3 then begin//���Ϊ�������ݣ����޸���������
                J:= -1;
                J := HumDataDB.Index(THeroData.sMasterName);//�������ݣ��޸Ķ�Ӧ��Ӣ���� 20090705
                if (J >= 0) then begin
                  if HumDataDB.Get(J, HumData) >= 0 then begin
                    if (CompareText(Trim(THeroData.sAccount), Trim(HumData.Data.sAccount))= 0) and (HumData.Data.sHeroChrName <>'') then begin
                      HumData.Data.sHeroChrName:= THeroData.sNewHumName;
                      HumDataDB.Update(J, HumData);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
        if DearDataList.Count > 0 then begin
          for I:= 0 to DearDataList.Count - 1 do begin
            TDearData:= PTDearData(DearDataList.Items[I]);
            if TDearData.sNewHumName <> '' then begin
              J := HumDataDB.Index(TDearData.sNewHumName);
              if (J >= 0) then begin
                if HumDataDB.Get(J, HumData) >= 0 then begin
                  HumData.Data.sDearName:= TDearData.sDearName;
                  HumDataDB.Update(J, HumData);
                end;
              end;
            end;
            if TDearData.sDearName <> '' then begin
              J := HumDataDB.Index(TDearData.sDearName);
              if (J >= 0) then begin
                if HumDataDB.Get(J, HumData) >= 0 then begin
                  HumData.Data.sDearName:= TDearData.sNewHumName;
                  HumDataDB.Update(J, HumData);
                end;
              end;
            end;
          end;
        end;
        if MasterDataList.Count > 0 then begin
          for I:= 0 to MasterDataList.Count - 1 do begin
            TMasterData:= PTMasterData(MasterDataList.Items[I]);
            J := HumDataDB.Index(TMasterData.sNewHumName);
            if (J >= 0) then begin
              if HumDataDB.Get(J, HumData) >= 0 then begin
                HumData.Data.sMasterName:= TMasterData.sMasterName;
                HumDataDB.Update(J, HumData);
              end;
            end;
          end;
        end;

        //���mir.db��¼�˺��Ƿ���hum.dbһ��,��һ�����޸�һ�� 20081220
        try
          if HumChrDB.Open then begin
            for I := 0 to HumChrDB.m_QuickList.Count - 1 do begin
              if HumChrDB.GetBy(I, DBHum) then begin
                J := HumDataDB.Index(DBHum.sChrName);
                if J >= 0 then begin
                  if HumDataDB.Get(J, HumData) >= 0 then begin
                    if (HumData.Data.sChrName = '') then Continue;
                    if CompareText(DBHum.sAccount , HumData.Data.sAccount) <> 0 then begin
                      HumData.Data.sAccount:= DBHum.sAccount;
                      HumDataDB.Update(J, HumData);
                    end;
                  end;
                end;
              end;
            end;
          end;
        finally
          HumChrDB.Close;
        end;
      end;//if HumDataDB.Open then begin
    finally
      HumDataDB.Close;
    end;
  finally
    HumDataDB.Free;
    HumChrDB.Free;//20081220
  end;

  for I := Low(TempIDLists) to High(TempIDLists) do TempIDLists[I].Free;

  for I:=0 to DearDataList.Count - 1 do Dispose(pTDearData(DearDataList.Items[I]));
  FreeAndNil(DearDataList);
  for I:=0 to MasterDataList.Count - 1 do Dispose(pTMasterData(MasterDataList.Items[I]));
  FreeAndNil(MasterDataList);
  for I:=0 to HeroDataList.Count - 1 do Dispose(pTHeroData(HeroDataList.Items[I]));
  FreeAndNil(HeroDataList);

  if HeroTempNameList <> nil then HeroTempNameList.Free;//20081129
  if GuildList <> nil then GuildList.Free;//20081129
end;

procedure TMainWorkThread.OutMessage;
begin
  if Assigned(MainOutInforProc) then MainOutInforProc(m_sCurMessage);
end;
//���±�д��Ʒ���
procedure TMainWorkThread.ReSetItemsIndex;
var
 HumData:THumDatainfo;
 I: Integer;
 f_MainHeroMirH: THandle;
 ChrRecord: TNewHeroDataInfo;
begin
  if f_MainMirH = 0 then f_MainMirH  := FileOpen(m_sMainRoot + '\DBServer\FDB\Mir.db', fmOpenReadWrite);
  if f_MainMirH > 0 then begin//20081225
    m_nCurMax := (FileSeek(f_MainMirH, 0, 2) - Sizeof(TDBHeader)) div Sizeof(THumDataInfo);
    FileSeek(f_MainMirH, Sizeof(TDBHeader), 0);
    m_nCurPostion := 0;
    while FileRead(f_MainMirH, HumData, Sizeof(THumDataInfo)) = Sizeof(THumDataInfo) do begin
      for I := Low(HumData.data.HumItems) to High(HumData.data.HumItems) do
        if HumData.data.HumItems[I].wIndex > 0 then begin
          HumData.data.HumItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;

      for I := Low(HumData.data.BagItems) to High(HumData.data.BagItems) do
        if HumData.data.BagItems[I].wIndex > 0 then begin
          HumData.data.BagItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;

      for I := Low(HumData.data.StorageItems) to High(HumData.data.StorageItems) do
        if HumData.data.StorageItems[I].wIndex > 0 then begin
          HumData.data.StorageItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;

      for I := Low(HumData.data.HumAddItems) to High(HumData.data.HumAddItems) do
        if HumData.data.HumAddItems[I].wIndex > 0 then begin
          HumData.data.HumAddItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;
      FileSeek(f_MainMirH, Sizeof(TDBHeader) + Sizeof(THumDataInfo) * m_nCurPostion, 0);
      FileWrite(f_MainMirH, HumData, Sizeof(THumDataInfo));
      Inc(m_nTotalPostion);
      Inc(m_nCurPostion);
      {$IF THREADWORK}if Self.Terminated then Break;
      {$ELSE}
        if g_Terminated then Break;
        Application.ProcessMessages;
      {$IFEND}
    end;
  end;
  f_MainHeroMirH := FileOpen(m_sMainRoot + '\DBServer\FDB\HeroMir.db', fmOpenReadWrite);
  if f_MainHeroMirH > 0 then begin
    m_nCurMax := (FileSeek(f_MainHeroMirH, 0, 2) - Sizeof(TDBHeader1)) div Sizeof(TNewHeroDataInfo);
    FileSeek(f_MainHeroMirH, Sizeof(TDBHeader1), 0);
    m_nCurPostion := 0;
    while FileRead(f_MainHeroMirH, ChrRecord, Sizeof(TNewHeroDataInfo)) = Sizeof(TNewHeroDataInfo) do begin
      for I := Low(ChrRecord.data.HumItems) to High(ChrRecord.data.HumItems) do
        if ChrRecord.data.HumItems[I].wIndex > 0 then begin
          ChrRecord.data.HumItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;

      for I := Low(ChrRecord.data.BagItems) to High(ChrRecord.data.BagItems) do
        if ChrRecord.data.BagItems[I].wIndex > 0 then begin
          ChrRecord.data.BagItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;

      for I := Low(ChrRecord.data.HumAddItems) to High(ChrRecord.data.HumAddItems) do
        if ChrRecord.data.HumAddItems[I].wIndex > 0 then begin
          ChrRecord.data.HumAddItems[I].MakeIndex := m_nNewItemIndex;
          Inc(m_nNewItemIndex);
        end;
      FileSeek(f_MainHeroMirH, Sizeof(TDBHeader1) + Sizeof(TNewHeroDataInfo) * m_nCurPostion, 0);
      FileWrite(f_MainHeroMirH, ChrRecord, Sizeof(TNewHeroDataInfo));
      Inc(m_nTotalPostion);
      Inc(m_nCurPostion);
      {$IF THREADWORK}if Self.Terminated then Break;
      {$ELSE}
        if g_Terminated then Break;
        Application.ProcessMessages;
      {$IFEND}
    end;
  end;
  if f_MainHeroMirH > 0 then FileClose(f_MainHeroMirH);
  if m_nNewItemIndex > 0 then begin
    m_sCurMessage := '�µ���Ʒ��Ŵ� 0 ��ʼ �� ' + IntToStr(m_nNewItemIndex);
   {$IF THREADWORK}Synchronize({$IFEND}OutMessage{$IF THREADWORK}){$IFEND};
  end;
end;

{$IF not THREADWORK}
procedure TMainWorkThread.Run;
begin
  g_Terminated  := False;
  Execute;
end;
{$IFEND}

procedure TMainWorkThread.SaveIDChangeList;
var
  I, J: Integer;
  SL  : TStrings;
begin
  SL  := TStringList.Create;
  try
    for J := Low(IDChangedLists) to High(IDChangedLists) do
      for I := 0 to IDChangedLists[J].Count - 1 do
        begin
          SL.Add('"' + IDOldLists[J].Strings[I] + '"' + #9#9#9 + '"' + IDChangedLists[J].Strings[I] + '"');
        end;
    (SL as TStringList).Sort;
    SL.SaveToFile(ExtRactFilePath(Application.ExeName) + 'ID���.txt');
  finally
    SL.Free;
  end;
end;

procedure TMainWorkThread.SaveNameChangeList;
var
  I: Integer;
  SL  : TStrings;
  TDearData: pTDearData;
begin
  SL  := TStringList.Create;
  //for I := 0 to NameChangedList.Count - 1 do begin
  //  SL.Add('"' + NameOldList.Strings[I] + '"' + #9#9#9 + '"' + NameChangedList.Strings[I] + '"');
  //end;
  for I:= 0 to NameChangeList.Count - 1 do begin
    TDearData:= pTDearData(NameChangeList.Objects[I]);
    if TDearData <> nil then begin
      SL.Add('"' + TDearData.sDearName + '"' + #9#9#9 + '"' + TDearData.sNewHumName + '"');
    end;
  end;
  (SL as TStringList).Sort;
  SL.SaveToFile(ExtRactFilePath(Application.ExeName) + '���ֱ��.txt');
  SL.Free;
end;

//20071122
procedure TMainWorkThread.SetWorkRoots(SL:String);
begin
  m_WorkRoots.Add(sl);
end;

end.
