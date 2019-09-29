unit LocalDB;

interface

uses
  Windows, SysUtils, Classes, ActiveX,
  M2Share, {$IF DBTYPE = BDE}DBTables{$ELSE}ADODB{$IFEND}, DB, HUtil32, Grobal2, SDK,
  ObjNpc, UsrEngn, ObjMon2;

type
  TDefineInfo = record
    sName: string;
    sText: string;
  end;
  pTDefineInfo = ^TDefineInfo;

  TQDDinfo = record
    n00: Integer;
    s04: string;
    sList: TStringList;
  end;
  pTQDDinfo = ^TQDDinfo;

  TGoodFileHeader = record
    nItemCount: Integer;
    Resv: array[0..251] of Integer;
  end;

  TFrmDB = class {(TForm)}
  private
    function SetStringList(StringList: TStringList): Boolean;//��ҵ��ű���� �ɽ�QF֮��ű�
    { Private declarations }
  public
{$IF DBTYPE = BDE}
    Query: TQuery;
{$ELSE}
    Query: TADOQuery;
{$IFEND}
    constructor Create();
    destructor Destroy; override;
    function LoadMonitems(MonName: string; var ItemList: TList): Integer;
    function LoadItemsDB(): Integer;//��ȡ��Ʒ����
    {$IF M2Version <> 2}
    function LoadHumTitleDB(): Integer;//��ȡ�ƺ�����
    function LoadDominatSendPoint():Integer;//��ȡ������͵�����
    procedure LoadRefineItem();//��ȡ������������ 20080502
    procedure LoadItemSortListToFile();//��ȡ��Ʒ��������
    procedure SaveItemSortListToFile();//������Ʒ��������
    procedure LoadDigJewelItemList;//��ȡ�ڱ���Ʒ�б� 20100905
    {$IFEND}
    procedure LoadRefineDrumItemList;
    function LoadMinMap(): Integer;
    function LoadMapInfo(): Integer;
    function LoadMonsterDB(): Integer;
    function LoadMagicDB(): Integer;
    function LoadMonGen(): Integer;
    function LoadUnbindList(): Integer;
    function LoadMapQuest(): Integer;
    function LoadQuestDiary(): Integer;
    function LoadAdminList(): Boolean;
    function LoadMerchant(): Integer;
    function LoadGuardList(): Integer;
    function LoadNpcs(): Integer;
    procedure LoadQMangeNPC;
    procedure QFunctionNPC;
    {$IF M2Version = 1}
    procedure QBatterNPC;//����NPC 20090623
    {$IFEND}
    procedure QMissionNPC;//���� QMission-0.txt �ű�����(����ť)
    procedure RobotNPC();

    function LoadMakeItem(): Integer;
    function LoadStartPoint(): Integer;
    function LoadAutoFindRout(): Integer;//����Ѱ·������Ŀ�������
    function LoadNpcScript(NPC: TNormNpc; sPatch, sScritpName: string): Integer;
    function LoadScriptFile(NPC: TNormNpc; sPatch, sScritpName: string; boFlag: Boolean): Integer;
    function LoadGoodRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;

    function SaveGoodRecord(NPC: TMerchant; sFile: string): Integer;
    function SaveGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;

    function LoadUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
    function SaveUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
    procedure ReLoadMerchants();
    procedure ReLoadNpc();

    procedure LoadBoxsList;//��ȡ�����б� 20080114
    procedure LoadSuitItemList();//��ȡ��װװ������ 20080225
    procedure LoadSellOffItemList(); //��ȡԪ�������б� 20080316
    procedure SaveSellOffItemList();//����Ԫ�������б� 20080317

    function LoadMapEvent(): Integer;//���ص�ͼ����
    procedure LoadMonFireDragonGuard();//�����ػ��޲�д���б� 20090111
    procedure LoadSortList();//��ȡ���а����� 20100615
    function DeCodeStringList(StringList: TStringList): Boolean;//�ű����ܺ���
    { Public declarations }
  end;

var
  FrmDB: TFrmDB;
implementation

uses ObjBase, Envir, EDcodeUnit, Forms;
//{$R *.dfm}

{ TFrmDB }
function TFrmDB.LoadAdminList(): Boolean;
var
  sFileName: string;
  sLineText: string;
  sIPaddr: string;
  sCharName: string;
  sData: string;
  LoadList: TStringList;
  AdminInfo: pTAdminInfo;
  I: Integer;
  nLv: Integer;
begin
  Result := False; ;
  sFileName := g_Config.sEnvirDir + 'AdminList.txt';
  if not FileExists(sFileName) then Exit;
  UserEngine.m_AdminList.Lock;
  try
    UserEngine.m_AdminList.Clear;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    if LoadList.Count > 0 then begin//20091113 ����
      for I := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[I];
        nLv := -1;
        if (sLineText <> '') and (sLineText[1] <> ';') then begin
          if sLineText[1] = '*' then nLv := 10
          else if sLineText[1] = '1' then nLv := 9
          else if sLineText[1] = '2' then nLv := 8
          else if sLineText[1] = '3' then nLv := 7
          else if sLineText[1] = '4' then nLv := 6
          else if sLineText[1] = '5' then nLv := 5
          else if sLineText[1] = '6' then nLv := 4
          else if sLineText[1] = '7' then nLv := 3
          else if sLineText[1] = '8' then nLv := 2
          else if sLineText[1] = '9' then nLv := 1;
          if nLv > 0 then begin
            sLineText := GetValidStrCap(sLineText, sData, ['/', '\', ' ', #9]);
            sLineText := GetValidStrCap(sLineText, sCharName, ['/', '\', ' ', #9]);
            sLineText := GetValidStrCap(sLineText, sIPaddr, ['/', '\', ' ', #9]);
  {$IF VEROWNER = WL}
            if (sCharName <= '') or (sIPaddr = '') then Continue;
  {$IFEND}
            New(AdminInfo);
            AdminInfo.nLv := nLv;
            AdminInfo.sChrName := sCharName;
            AdminInfo.sIPaddr := sIPaddr;
            UserEngine.m_AdminList.Add(AdminInfo);
          end;
        end;
      end;//for
    end;
    LoadList.Free;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  Result := True;
end;
//00488A68
function TFrmDB.LoadGuardList(): Integer;
var
  sFileName, s14, s1C, s20, s24, s28, s2C: string;
  tGuardList: TStringList;
  I: Integer;
  tGuard: TBaseObject;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'GuardList.txt';
  if FileExists(sFileName) then begin
    tGuardList := TStringList.Create;
    try
      tGuardList.LoadFromFile(sFileName);
      if tGuardList.Count > 0 then begin//20080629
        for I := 0 to tGuardList.Count - 1 do begin
          s14 := tGuardList.Strings[I];
          if (s14 <> '') and (s14[1] <> ';') then begin
            s14 := GetValidStrCap(s14, s1C, [' ']);
            if (s1C <> '') and (s1C[1] = '"') then
              ArrestStringEx(s1C, '"', '"', s1C);
            s14 := GetValidStr3(s14, s20, [' ']);
            s14 := GetValidStr3(s14, s24, [' ', ',']);
            s14 := GetValidStr3(s14, s28, [' ', ',', ':']);
            s14 := GetValidStr3(s14, s2C, [' ', ':']);
            if (s1C <> '') and (s20 <> '') and (s2C <> '') then begin
              if UserEngine.GetMonRace(s1C) >= 0 then begin//������������Ƿ�Ϸ� 20090628
                if g_MapManager.FindMap(s20) <> nil then begin//����ͼ�Ƿ���� 20090628
                  tGuard := UserEngine.RegenMonsterByName(s20, Str_ToInt(s24, 0), Str_ToInt(s28, 0), s1C);
                  //sMapName,nX,nY,sName
                  if tGuard <> nil then tGuard.m_btDirection := Str_ToInt(s2C, 0);
                end;
              end;
            end;
          end;
        end;//for
      end;
    finally
      tGuardList.Free;
    end;
    Result := 1;
  end;
end;
//��ȡ��Ʒ����
function TFrmDB.LoadItemsDB: Integer;
var
  I, Idx: Integer;
  StdItem: pTStdItem;
resourcestring
sSQLString = 'select Idx,Name,StdMode,Shape,Weight,AniCount,Source,Reserved,Looks,DuraMax,Ac,Ac2,Mac,Mac2,Dc,DC2,Mc,Mc2,Sc,Sc2,Need,NeedLevel,Stock,Price,HP,MP,NameAdd from StdItems';
// sSQLString = 'select * from StdItems';
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    try
      if UserEngine.StdItemList.Count > 0 then begin//20080629
        for I := 0 to UserEngine.StdItemList.Count - 1 do begin
          if pTStdItem(UserEngine.StdItemList.Items[I]) <> nil then
            Dispose(pTStdItem(UserEngine.StdItemList.Items[I]));
        end;
        UserEngine.StdItemList.Clear;
      end;
      Result := -1;
      try
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('Alter Table StdItems add NameAdd varchar(14)');
        Query.ExecSQL;
      except

      end;
      try
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('Alter Table StdItems add HP integer');
        Query.ExecSQL;
      except

      end;

      try
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('Alter Table StdItems add MP integer');
        Query.ExecSQL;
      except

      end;
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
      try
        Query.Open;
      finally
        Result := -2;
      end;
      if Query.RecordCount > 0 then begin//20080629
        for I := 0 to Query.RecordCount - 1 do begin
          New(StdItem);
          Idx := Query.FieldByName('Idx').AsInteger;//���
          StdItem.Name := Trim(Query.FieldByName('Name').AsString);//����
          try
            StdItem.Name := StdItem.Name + Trim(Query.FieldByName('NameAdd').AsString);//����
          except

          end;
          StdItem.StdMode := Query.FieldByName('StdMode').AsInteger;//�����
          StdItem.Shape := Query.FieldByName('Shape').AsInteger;//װ�����
          StdItem.Weight := Query.FieldByName('Weight').AsInteger;//����
          StdItem.nHP := Query.FieldByName('HP').AsInteger;//װ�����
          StdItem.nMP := Query.FieldByName('MP').AsInteger;//����
          StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
          StdItem.Source := Query.FieldByName('Source').AsInteger;
          StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;//����
          StdItem.Looks := Query.FieldByName('Looks').AsInteger;//��Ʒ���
          StdItem.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);//�־���
          StdItem.AC := MakeLong(Round(Query.FieldByName('Ac').AsInteger * (g_Config.nItemsACPowerRate / 10)), Round(Query.FieldByName('Ac2').AsInteger * (g_Config.nItemsACPowerRate / 10)));
          StdItem.MAC := MakeLong(Round(Query.FieldByName('Mac').AsInteger * (g_Config.nItemsACPowerRate / 10)), Round(Query.FieldByName('MAc2').AsInteger * (g_Config.nItemsACPowerRate / 10)));
          StdItem.DC := MakeLong(Round(Query.FieldByName('Dc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Dc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
          StdItem.MC := MakeLong(Round(Query.FieldByName('Mc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Mc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
          StdItem.SC := MakeLong(Round(Query.FieldByName('Sc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Sc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
          StdItem.Need := Query.FieldByName('Need').AsInteger;//��������
          StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;//��Ҫ�ȼ�
          StdItem.Price := Query.FieldByName('Price').AsInteger;//�۸�
          StdItem.Stock := Query.FieldByName('Stock').AsInteger;//20090305 װ����������������+�ȼ���������������ʹ��
          StdItem.NeedIdentify := GetGameLogItemNameList(StdItem.Name);
          //if Query.FindField('Desc') <> nil then //20080805 ע��
          //   StdItem.sDesc:= Trim(Query.FieldByName('Desc').AsString);//��Ʒ˵�� 20080702
          if UserEngine.StdItemList.Count = Idx then begin
            UserEngine.StdItemList.Add(StdItem);
            Result := 1;
          end else begin
            Memo.Lines.Add(Format('������Ʒ(Idx:%d Name:%s)����ʧ�ܣ�����', [Idx, StdItem.Name]));
            Result := -100;
            Exit;
          end;
          Query.Next;
        end;//for
      end;
      g_boGameLogGold := GetGameLogItemNameList(sSTRING_GOLDNAME) = 1;
      g_boGameLogHumanDie := GetGameLogItemNameList(g_sHumanDieEvent) = 1;
      g_boGameLogGameGold := GetGameLogItemNameList(g_Config.sGameGoldName) = 1;
      g_boGameLogGameDiaMond := GetGameLogItemNameList(g_Config.sGameDiaMond) = 1;//�Ƿ�д����־(�������ʯ) 20071226
      g_boGameLogGameGird := GetGameLogItemNameList(g_Config.sGameGird) = 1;//�Ƿ�д����־(�������) 20071226
      g_boGameLogGameGlory := GetGameLogItemNameList(g_Config.sGameGlory) = 1;//�Ƿ�д����־(��������ֵ) 20080511
      g_boGameLogGamePoint := GetGameLogItemNameList(g_Config.sGamePointName) = 1;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
{$IF M2Version <> 2}
//��ȡ�ƺ�����
function TFrmDB.LoadHumTitleDB(): Integer;
var
  I, Idx: Integer;
  HumTitleDB: pTHumTitleDB;
resourcestring
  sSQLString = 'select Idx,Name,StdMode,Shape,AniCount,Hours,Looks,DuraMax,Ac,Ac2,Mac,Mac2,Dc,DC2,Mc,Mc2,Sc,Sc2,Need,NeedLevel,Stock from FengHaos';
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    try
      if UserEngine.HumTitleList.Count > 0 then begin
        for I := 0 to UserEngine.HumTitleList.Count - 1 do begin
          if pTHumTitleDB(UserEngine.HumTitleList.Items[I]) <> nil then
            Dispose(pTHumTitleDB(UserEngine.HumTitleList.Items[I]));
        end;
        UserEngine.HumTitleList.Clear;
      end;
      Result := -1;
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
      try
        Query.Open;
      finally
        Result := -2;
      end;
      if Query.RecordCount > 0 then begin
        for I := 0 to Query.RecordCount - 1 do begin
          New(HumTitleDB);
          Idx := Query.FieldByName('Idx').AsInteger;//���
          HumTitleDB.Idx:= Idx;
          HumTitleDB.sTitleName := Trim(Query.FieldByName('Name').AsString);//����
          HumTitleDB.StdMode := Query.FieldByName('StdMode').AsInteger;//�����
          HumTitleDB.Shape := Query.FieldByName('Shape').AsInteger;//�ƺ����
          HumTitleDB.AniCount := Query.FieldByName('AniCount').AsInteger;
          HumTitleDB.nHours := Query.FieldByName('Hours').AsInteger;
          HumTitleDB.Looks := Query.FieldByName('Looks').AsInteger;//�ƺ����
          HumTitleDB.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);//�־���
          HumTitleDB.AC := MakeLong(Query.FieldByName('Ac').AsInteger, Query.FieldByName('Ac2').AsInteger);
          HumTitleDB.MAC := MakeLong(Query.FieldByName('Mac').AsInteger, Query.FieldByName('MAc2').AsInteger);
          HumTitleDB.DC := MakeLong(Query.FieldByName('Dc').AsInteger, Query.FieldByName('Dc2').AsInteger);
          HumTitleDB.MC := MakeLong(Query.FieldByName('Mc').AsInteger, Query.FieldByName('Mc2').AsInteger);
          HumTitleDB.SC := MakeLong(Query.FieldByName('Sc').AsInteger, Query.FieldByName('Sc2').AsInteger);
          HumTitleDB.Need := Query.FieldByName('Need').AsInteger;//��������
          HumTitleDB.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;//��Ҫ�ȼ�
          HumTitleDB.Stock := Query.FieldByName('Stock').AsInteger;
          if UserEngine.HumTitleList.Count = Idx then begin
            UserEngine.HumTitleList.Add(HumTitleDB);
            Result := 1;
          end else begin
            Memo.Lines.Add(Format('���سƺ�(Idx:%d Name:%s)����ʧ�ܣ�����', [Idx, HumTitleDB.sTitleName]));
            Result := -100;
            Exit;
          end;
          Query.Next;
        end;//for
      end;
    finally
      Query.Close;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
//��ȡ������͵�����
function TFrmDB.LoadDominatSendPoint():Integer;
var
  sFileName, tStr, s18, s1C, s20, s21, s22: string;
  LoadList: TStringList;
  I, nCount, nID: Integer;
  DominatSendPoint: pTDominatSendPoint;
begin
  Result := 0;
  nCount:= 0;
  sFileName := g_Config.sEnvirDir + 'DominatSendPoint.txt';

  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.Add(';���ı�Ϊ�����������ͼ�Ĵ��͵�,���֧��18�����͵�,��ͼ�������ظ�');
      LoadList.Add(';ID(1-18) ��ͼ�� ��ͼID X���� Y����');
      LoadList.Add(';IDΪ��ͼ�ϵ�λ��ID(�����ظ�)');
      LoadList.Add('1 ��ͥ 0122 20 33');
      LoadList.Add('2 ���µ� 5 140 338');
      LoadList.Add('3 �ƹ� 0170 13 20');
      LoadList.Add('4 Ӣ��ʥ�� YXSD 46 61');
      LoadList.Add('5 ������ 11 163 332');
      LoadList.Add('6 ���� 3 333 335');
      LoadList.Add('7 ������� 0157 17 18');
      LoadList.Add('8 ��ħ�� 4 241 202');
      LoadList.Add('9 ���¹��� DM002 15 20');
      LoadList.Add('10 ɳ�Ϳ� 3 646 292');
      LoadList.Add('11 �������� D021 27 34');
      LoadList.Add('12 ���� 0 328 270');
      LoadList.Add('13 ����ɽ�� 2 296 58');
      LoadList.Add('14 ħ���� 6 122 158');
      LoadList.Add('15 �߽�� 0 291 618');
      LoadList.Add('16 ׯ԰ GA0 69 72');
      LoadList.Add(';17 �������� D1004 15 20');
      LoadList.Add(';18 �������� D1004 29 34');
      LoadList.SaveToFile(sFileName);
    finally
      LoadList.Free;
    end;
  end;

  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      if g_DominatSendList.Count > 0 then begin
        for I := 0 to g_DominatSendList.Count - 1 do begin
          if pTDominatSendPoint(g_DominatSendList.Objects[I]) <> nil then Dispose(pTDominatSendPoint(g_DominatSendList.Objects[I]));
        end;
      end;
      g_DominatSendList.Clear;
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        if nCount > 17 then Break;
        tStr := Trim(LoadList.Strings[I]);
        if (tStr <> '') and (tStr[1] <> ';') then begin
          if (Pos('/',tStr) = 0) then begin
            tStr := GetValidStr3(tStr, s22, [' ', #9]);
            nID:=  Str_ToInt(s22, 0);
            tStr := GetValidStr3(tStr, s18, [' ', #9]);
            tStr := GetValidStr3(tStr, s21, [' ', #9]);
            tStr := GetValidStr3(tStr, s1C, [' ', #9]);
            tStr := GetValidStr3(tStr, s20, [' ', #9]);
            if (s18 <> '') and (s21 <> '') and (s1C <> '') and (s20 <> '') and (nID < 19) and (nID > 0) then begin
              if Length(s18) <= MAPNAMELEN then begin
                if g_DominatSendList.IndexOf(s18) > -1 then begin//��ͼ,����Ƿ��ظ�
                  MainOutMessage(Format('�����������(DominatSendPoint.txt):��ͼ���ظ�->%s',[s18]));
                end else begin
                  if g_MapManager.FindMap(s21) <> nil then begin//����ͼ�Ƿ����
                    New(DominatSendPoint);
                    DominatSendPoint.nIdx:= nID;//λ��ID
                    DominatSendPoint.m_sMapDesc := s18;//��ͼ��
                    DominatSendPoint.m_sMapName := s21;//��ͼID
                    DominatSendPoint.m_nCurrX := Str_ToInt(s1C, 0);//X
                    DominatSendPoint.m_nCurrY := Str_ToInt(s20, 0);//Y
                    g_DominatSendList.AddObject(s18, TObject(DominatSendPoint));
                    Result := 1;
                    Inc(nCount);
                  end else MainOutMessage(Format('�����������(DominatSendPoint.txt):��ͼID��Ч->%s(%s)',[s18, s21]));
                end;
              end else MainOutMessage(Format('�����������(DominatSendPoint.txt):��ͼ�����ȳ���%d->%s',[MAPNAMELEN, s18]));
            end;
          end else MainOutMessage(Format('�����������(DominatSendPoint.txt):���ܰ�����/������->%s',[tStr]));
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;
end;
{$IFEND}
function TFrmDB.LoadMagicDB(): Integer;
var
  I, nId: Integer;
  Magic{, OldMagic}: pTMagic;
  //OldMagicList: TList;
resourcestring
sSQLString = 'select MagId,MagName,EffectType,Effect,Spell,Power,MaxPower,Job,'+
             'NeedL1,NeedL2,NeedL3,L1Train,L2Train,L3Train,Delay,DefSpell,DefPower,DefMaxPower,Descr from Magic';
begin
  Result := -1;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.SwitchMagicList();// m_MagicList.Create
    //����Ĵ����Ƕ���� By TasNat at: 2012-03-11 11:02:53
    {if UserEngine.m_MagicList.Count > 0 then begin//20080629
      for I := 0 to UserEngine.m_MagicList.Count - 1 do begin
        if pTMagic(UserEngine.m_MagicList.Items[I]) <> nil then
           Dispose(pTMagic(UserEngine.m_MagicList.Items[I]));
      end;
      UserEngine.m_MagicList.Clear;
    end;  }
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -2;
    end;
    if Query.RecordCount > 0 then begin//20080629
      for I := 0 to Query.RecordCount - 1 do begin
        nId := Query.FieldByName('MagId').AsInteger;
        if nId > 0 then begin

        New(Magic);
        Magic.wMagicId := nId;
        Magic.sMagicName := Query.FieldByName('MagName').AsString;
        Magic.btEffectType := Query.FieldByName('EffectType').AsInteger;
        Magic.btEffect := Query.FieldByName('Effect').AsInteger;
        Magic.wSpell := Query.FieldByName('Spell').AsInteger;
        Magic.wPower := Query.FieldByName('Power').AsInteger;
        Magic.wMaxPower := Query.FieldByName('MaxPower').AsInteger;
        Magic.btJob := Query.FieldByName('Job').AsInteger;
        Magic.TrainLevel[0] := Query.FieldByName('NeedL1').AsInteger;
        Magic.TrainLevel[1] := Query.FieldByName('NeedL2').AsInteger;
        Magic.TrainLevel[2] := Query.FieldByName('NeedL3').AsInteger;
        Magic.TrainLevel[3] := Query.FieldByName('NeedL3').AsInteger;
        Magic.MaxTrain[0] := Query.FieldByName('L1Train').AsInteger;
        Magic.MaxTrain[1] := Query.FieldByName('L2Train').AsInteger;
        Magic.MaxTrain[2] := Query.FieldByName('L3Train').AsInteger;
        Magic.MaxTrain[3] := Magic.MaxTrain[2];
        case Magic.wMagicId of
          SKILL_68: Magic.btTrainLv := 100;//����Ϊ100�� 20090330
          SKILL_76..SKILL_87: Magic.btTrainLv := 5;
          SKILL_95, SKILL_99: Magic.btTrainLv := 99;
          SKILL_100: Magic.btTrainLv := 15;//20110210
          SKILL_104: Magic.btTrainLv := 100;
          SKILL_105: Magic.btTrainLv := 100;//�����ķ�
          SKILL_106, SKILL_107, SKILL_108, SKILL_109, SKILL_110, SKILL_111,
            SKILL_112, SKILL_113, SKILL_114: Magic.btTrainLv := 9;//�����ķ�,������������
          else Magic.btTrainLv := 3;
        end;
        Magic.dwDelayTime := Query.FieldByName('Delay').AsInteger;
        Magic.btDefSpell := Query.FieldByName('DefSpell').AsInteger;
        Magic.btDefPower := Query.FieldByName('DefPower').AsInteger;
        Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
        Magic.sDescr := Query.FieldByName('Descr').AsString;

        UserEngine.m_MagicList.Add(Magic);
        end;
        Result := 1;
        Query.Next;
      end;//for
    end;
    Query.Close;      
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
    UserEngine.m_boStartLoadMagic := False;
  end;
end;

function TFrmDB.LoadMakeItem(): Integer;
var
  I, n14: Integer;
  s18, s20, s24: string;
  LoadList: TStringList;
  sFileName: string;
  List28: TStringList;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'MakeItem.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      List28 := nil;
      s24 := '';
      if LoadList.Count > 0 then begin//20091113 ����
        for I := 0 to LoadList.Count - 1 do begin
          s18 := Trim(LoadList.Strings[I]);
          if (s18 <> '') and (s18[1] <> ';') then begin
            if s18[1] = '[' then begin
              if List28 <> nil then g_MakeItemList.AddObject(s24, List28);
              List28 := TStringList.Create;
              ArrestStringEx(s18, '[', ']', s24);
            end else begin
              if List28 <> nil then begin
                s18 := GetValidStr3(s18, s20, [' ', #9]);
                n14 := Str_ToInt(Trim(s18), 1);
                List28.AddObject(s20, TObject(n14));
              end;
            end;
          end;
        end; // for
      end;
      if List28 <> nil then g_MakeItemList.AddObject(s24, List28);
    finally
      LoadList.Free;
    end;
    Result := 1;
  end;
end;

function TFrmDB.LoadMapInfo: Integer;
  function LoadMapQuest(sName: string): TMerchant;
  var
    QuestNPC: TMerchant;
  begin
    QuestNPC := TMerchant.Create;
    QuestNPC.m_sMapName := '0';
    QuestNPC.m_nCurrX := 0;
    QuestNPC.m_nCurrY := 0;
    QuestNPC.m_sCharName := sName;
    QuestNPC.m_nFlag := 0;
    QuestNPC.m_wAppr := 0;
    QuestNPC.m_sFilePath := 'MapQuest_def\';
    QuestNPC.m_boIsHide := True;
    QuestNPC.m_boIsQuest := False;
    UserEngine.QuestNPCList.Add(QuestNPC);
    Result := QuestNPC;
  end;
  procedure LoadSubMapInfo(LoadList: TStringList; sFileName: string);
  var
    I: Integer;
    sFilePatchName, sFileDir: string;
    LoadMapList: TStringList;
  begin
    sFileDir := g_Config.sEnvirDir + 'MapInfo\';
    if not DirectoryExists(sFileDir) then CreateDir(sFileDir);
    sFilePatchName := sFileDir + sFileName;
    if FileExists(sFilePatchName) then begin
      LoadMapList := TStringList.Create;
      try
        LoadMapList.LoadFromFile(sFilePatchName);
        if LoadMapList.Count > 0 then begin
          for I := 0 to LoadMapList.Count - 1 do LoadList.Add(LoadMapList.Strings[I]);
        end;
      finally
        LoadMapList.Free;
      end;
    end;
  end;
  function IsStrCount(str:string):Integer;//�ж��м���')'�� 20080727
  var
    i:integer;
  begin
    Result:=0;
    if length(str) <= 0 then Exit;
    for i:= 1 to length(str) do
      if  (str[i] in [')']) then Inc(Result);
  end;
var
  sFileName: string;
  LoadList: TStringList;
  I: Integer;
  s30, s34, s38, sMapName, sMainMapName, s44, sMapDesc, s4C, sReConnectMap: string;
  n14, n18, n1C, n20 : Integer;
  nServerIndex: Integer;

  MapFlag: TMapFlag;
  QuestNPC: TMerchant;
  sMapInfoFile: string;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'MapInfo.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    SetStringList(LoadList);//�ű����� 20100815
    if LoadList.Count < 0 then begin
      LoadList.Free;
      Exit;
    end;
    I := 0;
    while (True) do begin
      if I >= LoadList.Count then Break;
      s34 := LoadList.Strings[I];
      if (s34 <> '') and (s34[1] <> '[') and (s34[1] <> ';') then begin
        if CompareLStr('loadmapinfo', s34, 11) then begin
          sMapInfoFile := GetValidStr3(s34, s30, [' ', #9]);
          LoadList.Delete(I);
          if sMapInfoFile <> '' then LoadSubMapInfo(LoadList, sMapInfoFile);
        end;
      end;
      Inc(I);
    end;
    Result := 1;
    //���ص�ͼ����
    for I := 0 to LoadList.Count - 1 do begin
      s30 := LoadList.Strings[I];
      if (s30 <> '') and (s30[1] = '[') then begin
        sMapName := '';
        MapFlag.boSAFE := False;
        s30 := ArrestStringEx(s30, '[', ']', sMapName);
        sMapDesc := GetValidStrCap(sMapName, sMapName, [' ', ',', #9]);
        sMainMapName := Trim(GetValidStr3(sMapName, sMapName, ['|', '/', '\', #9])); //��ȡ�ظ����õ�ͼ
        if (sMapDesc <> '') and (sMapDesc[1] = '"') then ArrestStringEx(sMapDesc, '"', '"', sMapDesc);
        s4C := Trim(GetValidStr3(sMapDesc, sMapDesc, [' ', ',', #9]));
        nServerIndex := Str_ToInt(s4C, 0);
        if sMapName = '' then Continue;
        FillChar(MapFlag, SizeOf(TMapFlag), #0);
        //MapFlag.nL := 1;//20080815 ע��
        QuestNPC := nil;
        MapFlag.nNEEDSETONFlag := -1;
        MapFlag.nNeedONOFF := -1;
        MapFlag.sUnAllowStdItemsText := '';
        MapFlag.sUnAllowMagicText := '';
        MapFlag.boAutoMakeMonster := False;
        MapFlag.boNOTALLOWUSEMAGIC := False;
        MapFlag.boFIGHTPK := False;
        while (True) do begin
          if s30 = '' then Break;
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          if s34 = '' then Break;
          MapFlag.nMUSICID := -1;
          MapFlag.sMUSICName := '';
          if CompareText(s34, 'SAFE') = 0 then begin//��ȫ��
            MapFlag.boSAFE := True;
            Continue;
          end;
          if CompareText(s34, 'SAFENORUN') = 0 then begin//��ȫ�����ﲻ�ܴ�
            MapFlag.boSAFENORUN := True;
            Continue;
          end;
          if CompareText(s34, 'SAFEHERONORUN') = 0 then begin//Ӣ�۰�ȫ�����ܴ� 20090525
            MapFlag.boSAFEHERONORUN := True;
            Continue;
          end;
          if CompareText(s34, 'DARK') = 0 then begin
            MapFlag.boDARK := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT') = 0 then begin
            MapFlag.boFIGHT := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT2') = 0 then begin//PK��װ����ͼ
            MapFlag.boFIGHT2 := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT3') = 0 then begin
            MapFlag.boFIGHT3 := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT4') = 0 then begin//��ս��ͼ
            MapFlag.boFIGHT4 := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT5') = 0 then begin//��ͬ�л����ֱ䲻ͬ��ɫ
            MapFlag.boFIGHT5 := True;
            Continue;
          end;
          if CompareText(s34, 'DAY') = 0 then begin
            MapFlag.boDAY := True;
            Continue;
          end;
          if CompareText(s34, 'NOFIGHT4') = 0 then begin//��ֹ��ս��ͼ
            MapFlag.boNoFIGHT4 := True;
            Continue;
          end;
          if CompareText(s34, 'QUIZ') = 0 then begin
            MapFlag.boQUIZ := True;
            Continue;
          end;
          if CompareText(s34, 'NOSKILL') = 0 then begin
            MapFlag.boNOSKILL := True;
            Continue;
          end;
          if CompareLStr(s34, 'NORECONNECT', 11) then begin
            MapFlag.boNORECONNECT := True;
            ArrestStringEx(s34, '(', ')', sReConnectMap);
            MapFlag.sReConnectMap := sReConnectMap;
            if MapFlag.sReConnectMap = '' then Result := -11;
            Continue;
          end;
          if CompareLStr(s34, 'HITMON', 6) then begin//�����ִ��� 20110114
            ArrestStringEx(s34, '(', ')', sReConnectMap);
            MapFlag.sHitMonScript := sReConnectMap;
            if Pos('@',MapFlag.sHitMonScript) = 1 then begin
              MapFlag.boHitMon := True;
            end else Result := -11;
            Continue;
          end;
          if CompareLStr(s34, 'CHECKQUEST', 10) then begin
            ArrestStringEx(s34, '(', ')', s38);
            QuestNPC := LoadMapQuest(s38);
            Continue;
          end;
          if CompareLStr(s34, 'NEEDSET_ON', 10) then begin
            MapFlag.nNeedONOFF := 1;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNEEDSETONFlag := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'NEEDSET_OFF', 11) then begin
            MapFlag.nNeedONOFF := 0;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNEEDSETONFlag := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'MUSIC', 5) then begin
            MapFlag.boMUSIC := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nMUSICID := Str_ToInt(s38, -1);
            MapFlag.sMUSICName := s38;
            Continue;
          end;
          if CompareLStr(s34, 'EXPRATE', 7) then begin//��ͼɱ�־��鱶��
            MapFlag.boEXPRATE := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nEXPRATE := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'CRIT', 4) then begin//��ͼ�����ȼ� 20110114
            MapFlag.boCRIT := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nCRIT := Str_ToInt(s38, 0);
            Continue;
          end;
          if CompareLStr(s34, 'PEAK', 4) then begin//�۷�״̬
            MapFlag.boPeak := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPeakMaxRate := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nPeakMinRate := Str_ToInt(s38, -1);
            if MapFlag.nPeakMinRate > MapFlag.nPeakMaxRate then MapFlag.nPeakMaxRate:= MapFlag.nPeakMinRate;
            Continue;
          end;
          if CompareLStr(s34, 'PULSEXPRATE', 11) then begin//��ͼɱ��Ӣ�۾��鱶�� 20091029
            MapFlag.boPULSEXPRATE := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPULSEXPRATE := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'NGEXPRATE', 9) then begin//��ͼɱ���ڹ����鱶�� 20091029
            MapFlag.boNGEXPRATE := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNGEXPRATE := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECEXPRATETIME', 14) then begin//��˫������ʱ�� 20090206
            MapFlag.boDECEXPRATETIME := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nDECEXPRATETIME := Str_ToInt(s38, 1);
            Continue;
          end;
          if CompareLStr(s34, 'PKWINLEVEL', 10) then begin
            MapFlag.boPKWINLEVEL := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKWINLEVEL := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKWINEXP', 8) then begin
            MapFlag.boPKWINEXP := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKWINEXP := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKLOSTLEVEL', 11) then begin
            MapFlag.boPKLOSTLEVEL := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKLOSTLEVEL := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKLOSTEXP', 9) then begin
            MapFlag.boPKLOSTEXP := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKLOSTEXP := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECHP', 5) then begin
            MapFlag.boDECHP := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nDECHPPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECHPTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCHP', 5) then begin
            MapFlag.boINCHP := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nINCHPPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCHPTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECGAMEGOLD', 11) then begin
            MapFlag.boDECGAMEGOLD := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nDECGAMEGOLD := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECGAMEGOLDTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECGAMEPOINT', 12) then begin
            MapFlag.boDECGAMEPOINT := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nDECGAMEPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECGAMEPOINTTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'LIMITLEVEL', 10) then begin
            MapFlag.boLimitLevel := True;
            ArrestStringEx(s34, '(', ')', s38);
            s34:= GetValidStr3(s38, s38, ['/']);
            MapFlag.nLimitLevel1 := Str_ToInt(s38, 1);//�Ƿ񳬹��ȼ�
            s34:= GetValidStr3(s34, s38, ['/']);
            MapFlag.nLimitLevel2 := Str_ToInt(s38, 1);//�����õȼ�����
            s34:= GetValidStr3(s34, s38, ['/']);
            MapFlag.nLimitLevelHero := Str_ToInt(s38, 1);//�����õȼ�����
            MapFlag.nLimitLevelHero1 := Str_ToInt(s34, 1);//�����õȼ�����
            Continue;
          end;
          if CompareLStr(s34, 'KILLFUNC', 8) then begin//20080415 ��ͼɱ�˴���
            MapFlag.boKILLFUNC := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nKILLFUNC := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCGAMEGOLD', 11) then begin
            MapFlag.boINCGAMEGOLD := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nINCGAMEGOLD := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCGAMEGOLDTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCGAMEPOINT', 12) then begin
            MapFlag.boINCGAMEPOINT := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nINCGAMEPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCGAMEPOINTTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'NEEDLEVELTIME', 13) then begin//ѩ���ͼ����,�жϵȼ� 20081228
            MapFlag.boNEEDLEVELTIME := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNEEDLEVELPOINT := Str_ToInt(s38, 0);//����ͼ��͵ȼ�
            Continue;
          end;
          if CompareText(s34, 'NOCALLHERO') = 0 then begin//��ͼ���� NOCALLHERO (��ֹ�ٻ�Ӣ�ۣ����ٻ�Ӣ�۽��Զ���ʧ)  20080124
            MapFlag.boNoCALLHERO := True;
            Continue;
          end;
          if CompareText(s34, 'NOHEROPROTECT') = 0 then begin//��ֹӢ���ػ� 20080629
            MapFlag.boNoHeroPROTECT := True;
            Continue;
          end;
          if CompareText(s34, 'NODROPITEM') = 0 then begin//��ͼ���� NODROPITEM ��ֹ��������Ʒ(�������)
            MapFlag.boNODROPITEM := True;
            Continue;
          end;
          if CompareText(s34, 'MISSION') = 0 then begin//��ͼ���� MISSION (������ʹ���κ���Ʒ�ͼ��ܣ����ұ����ڸõ�ͼ���Զ���ʧ�����ܹ���)  20080124
            MapFlag.boMISSION := True;
            Continue;
          end;
          if CompareText(s34, 'RUNHUMAN') = 0 then begin
            MapFlag.boRUNHUMAN := True;
            Continue;
          end;
          if CompareText(s34, 'RUNMON') = 0 then begin
            MapFlag.boRUNMON := True;
            Continue;
          end;
          if CompareText(s34, 'NEEDHOLE') = 0 then begin
            MapFlag.boNEEDHOLE := True;
            Continue;
          end;
          if CompareText(s34, 'NORECALL') = 0 then begin
            MapFlag.boNORECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NOGUILDRECALL') = 0 then begin
            MapFlag.boNOGUILDRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NODEARRECALL') = 0 then begin
            MapFlag.boNODEARRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NOMASTERRECALL') = 0 then begin
            MapFlag.boNOMASTERRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NORANDOMMOVE') = 0 then begin
            MapFlag.boNORANDOMMOVE := True;
            Continue;
          end;
          if CompareText(s34, 'NODRUG') = 0 then begin
            MapFlag.boNODRUG := True;
            Continue;
          end;
          if CompareText(s34, 'NOMANNOMON') = 0 then begin
            MapFlag.boNoManNoMon := True;
            Continue;
          end;
          if CompareText(s34, 'MINE') = 0 then begin
            MapFlag.boMINE := True;
            Continue;
          end;
          if CompareText(s34, 'JEWEL') = 0 then begin//�ڱ�
            MapFlag.boDigJewel := True;
            Continue;
          end;
          if CompareText(s34, 'SHOP') = 0 then begin//�����̵��ͼ
            MapFlag.boSHOP := True;
            Continue;
          end;
          if CompareText(s34, 'NOPOSITIONMOVE') = 0 then begin
            MapFlag.boNOPOSITIONMOVE := True;
            Continue;
          end;
          if CompareText(s34, 'AUTOMAKEMONSTER') = 0 then begin
            MapFlag.boAutoMakeMonster := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHTPK') = 0 then begin//PK���Ա�װ��������
            MapFlag.boFIGHTPK := True;
            Continue;
          end;
          if CompareLStr(s34,'THUNDER',7) then begin//20080327 ����
            ArrestStringEx(s34,'(',')',s38);
            MapFlag.nThunder := Str_ToInt(s38,-1);
            Continue;
          end;
          if CompareLStr(s34,'LAVA',4) then begin//20080327 ����ð�ҽ�
            ArrestStringEx(s34,'(',')',s38);
            MapFlag.nLava := Str_ToInt(s38,-1);
            Continue;
          end;
          if CompareLStr(s34, 'NOTALLOWUSEMAGIC', 16) then begin //���Ӳ�����ʹ��ħ��
            MapFlag.boNOTALLOWUSEMAGIC := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.sUnAllowMagicText := Trim(s38);
            Continue;
          end;
          if CompareLStr(s34, 'NOTALLOWUSEITEMS', 16) then begin //���Ӳ�����ʹ����Ʒ
            MapFlag.boUnAllowStdItems := True;
            if IsStrCount(s34) > 1 then begin//�ж��м���')' 20080727
              s38:=Copy(s34, pos('(',s34)+ 1, Length(s34)-(pos('(',s34)+ 1));
            end else ArrestStringEx(s34, '(', ')', s38);
            MapFlag.sUnAllowStdItemsText := Trim(s38);
            Continue;
          end;
          if CompareLStr(s34, 'CHANGEMAPDROPS', 14) then begin //����ͼ����ָ����Ʒ 20110301
            MapFlag.boChangMapDrops := True;
            if IsStrCount(s34) > 1 then begin//�ж��м���')'
              s38:=Copy(s34, pos('(',s34)+ 1, Length(s34)-(pos('(',s34)+ 1));
            end else ArrestStringEx(s34, '(', ')', s38);
            MapFlag.sChangMapDropsText := Trim(s38);
            Continue;
          end;
        end;
        if g_MapManager.FindMap(sMapName) <> nil then begin//���ҵ�ͼ,����Ƿ��ظ� 20090722
          MainOutMessage(Format('��ͼ����(MapInfo.txt):��ͼID�ظ�->%s(%s)',[ sMapName, sMapDesc]));
        end else
        if g_MapManager.AddMapInfo(sMapName, sMainMapName, sMapDesc, nServerIndex, @MapFlag, QuestNPC) = nil then Result := -10;
      end else begin
        //���ص�ͼ���ӵ�
        if (s30 <> '') and (s30[1] <> '[') and (s30[1] <> ';') then begin
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          sMapName := s34;
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          n14 := Str_ToInt(s34, 0);
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          n18 := Str_ToInt(s34, 0);
          s30 := GetValidStr3(s30, s34, [' ', ',', '-', '>', #9]);
          s44 := s34;
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          n1C := Str_ToInt(s34, 0);
          s30 := GetValidStr3(s30, s34, [' ', ',', ';', #9]);
          n20 := Str_ToInt(s34, 0);
          g_MapManager.AddMapRoute(sMapName, n14, n18, s44, n1C, n20);
          sMapName := '';
          s44 := '';
          //sSMapNO,nSMapX,nSMapY,sDMapNO,nDMapX,nDMapY
        end;
      end;
    end;//for
{    //���ص�ͼ���ӵ�
    for I := 0 to LoadList.Count - 1 do begin
      s30 := LoadList.Strings[I];
      if (s30 <> '') and (s30[1] <> '[') and (s30[1] <> ';') then begin
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        sMapName := s34;
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n14 := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n18 := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', '-', '>', #9]);
        s44 := s34;
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n1C := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', ';', #9]);
        n20 := Str_ToInt(s34, 0);
        g_MapManager.AddMapRoute(sMapName, n14, n18, s44, n1C, n20);
        //sSMapNO,nSMapX,nSMapY,sDMapNO,nDMapX,nDMapY
      end;
    end; }
    LoadList.Free;
  end;
end;
//���� QMission-0.txt �ű�����(����ť)
procedure TFrmDB.QMissionNPC;
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  {$IF M2Version <> 2}
  try
    sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QMission-0.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + sMarket_Def;
    if not DirectoryExists(sScritpDir) then MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then begin
      SaveList := TStringList.Create;
      SaveList.Add(';�˽�Ϊ���ܽű�������ʵ�ֳɳ�������');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then begin
      g_MissionNPC := TMerchant.Create;
      g_MissionNPC.m_sMapName := '0';
      g_MissionNPC.m_nCurrX := 0;
      g_MissionNPC.m_nCurrY := 0;
      g_MissionNPC.m_sCharName := 'QMission';
      g_MissionNPC.m_nFlag := 0;
      g_MissionNPC.m_wAppr := 0;
      g_MissionNPC.m_sFilePath := sMarket_Def;
      g_MissionNPC.m_sScript := 'QMission';
      g_MissionNPC.m_boIsHide := True;
      g_MissionNPC.m_boIsQuest := False;
      UserEngine.AddMerchant(g_MissionNPC);
    end else begin
      g_MissionNPC := nil;
    end;
  except
    g_MissionNPC := nil;
  end;
  {$IFEND}
end;
//���� QFunction-0.txt �ű�����
procedure TFrmDB.QFunctionNPC;
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QFunction-0.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + sMarket_Def;
    if not DirectoryExists(sScritpDir) then MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then begin
      SaveList := TStringList.Create;
      SaveList.Add(';�˽ű�Ϊ���ܽű�������ʵ�ָ�����ű��йصĹ���');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then begin
      g_FunctionNPC := TMerchant.Create;
      g_FunctionNPC.m_sMapName := '0';
      g_FunctionNPC.m_nCurrX := 0;
      g_FunctionNPC.m_nCurrY := 0;
      g_FunctionNPC.m_sCharName := 'QFunction';
      g_FunctionNPC.m_nFlag := 0;
      g_FunctionNPC.m_wAppr := 0;
      g_FunctionNPC.m_sFilePath := sMarket_Def;
      g_FunctionNPC.m_sScript := 'QFunction';
      g_FunctionNPC.m_boIsHide := True;
      g_FunctionNPC.m_boIsQuest := False;
      UserEngine.AddMerchant(g_FunctionNPC);
    end else begin
      g_FunctionNPC := nil;
    end;
  except
    g_FunctionNPC := nil;
  end;
end;
{$IF M2Version = 1}
//����NPC 20090623
procedure TFrmDB.QBatterNPC;
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QBatter-0.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + sMarket_Def;
    if not DirectoryExists(sScritpDir) then MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then begin
      SaveList := TStringList.Create;
      SaveList.Add(';�˽ű�Ϊ�������ܽű�');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then begin
      g_BatterNPC := TMerchant.Create;
      g_BatterNPC.m_sMapName := '0';
      g_BatterNPC.m_nCurrX := 0;
      g_BatterNPC.m_nCurrY := 0;
      g_BatterNPC.m_sCharName := 'QBatter';
      g_BatterNPC.m_nFlag := 0;
      g_BatterNPC.m_wAppr := 0;
      g_BatterNPC.m_sFilePath := sMarket_Def;
      g_BatterNPC.m_sScript := 'QBatter';
      g_BatterNPC.m_boIsHide := True;
      g_BatterNPC.m_boIsQuest := False;
      UserEngine.AddMerchant(g_BatterNPC);
    end else begin
      g_BatterNPC := nil;
    end;
  except
    g_BatterNPC := nil;
  end;
end;
{$IFEND}

procedure TFrmDB.LoadQMangeNPC();
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + 'MapQuest_def\' + 'QManage.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + 'MapQuest_def\';
    if not DirectoryExists(sScritpDir) then MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then begin
      SaveList := TStringList.Create;
      try
        SaveList.Add(';�˽�Ϊ��¼�ű�������ÿ�ε�¼ʱ����ִ�д˽ű������������ʼ���ö����Է��ڴ˽ű��С�');
        SaveList.Add(';�޸Ľű����ݣ�����@ReloadManage�������¼��ظýű���������������');
        SaveList.Add('[@Login]');
        SaveList.Add('#if');
        SaveList.Add('#act');
        SaveList.Add('#say');
        SaveList.Add('3K�Ƽ���¼�ű����гɹ�����ӭ���뱾��Ϸ������\ \');
        SaveList.Add('<�ر�/@exit> \ \');
        SaveList.Add('��¼�ű��ļ�λ��: \');
        SaveList.Add(sShowFile + '\');
        SaveList.Add('�ű����������а��Լ���Ҫ���޸ġ�');
        SaveList.SaveToFile(sScriptFile);
      finally
        SaveList.Free;
      end;
    end;
    if FileExists(sScriptFile) then begin
      g_ManageNPC := TMerchant.Create;
      g_ManageNPC.m_sMapName := '0';
      g_ManageNPC.m_nCurrX := 0;
      g_ManageNPC.m_nCurrY := 0;
      g_ManageNPC.m_sCharName := 'QManage';
      g_ManageNPC.m_nFlag := 0;
      g_ManageNPC.m_wAppr := 0;
      g_ManageNPC.m_sFilePath := 'MapQuest_def\';
      g_ManageNPC.m_boIsHide := True;
      g_ManageNPC.m_boIsQuest := False;
      UserEngine.QuestNPCList.Add(g_ManageNPC);
    end else begin
      g_ManageNPC := nil;
    end;
  except
    g_ManageNPC := nil;
  end;
end;

procedure TFrmDB.RobotNPC();
var
  sScriptFile: string;
  sScritpDir: string;
  tSaveList: TStringList;
begin
  try
    sScriptFile := g_Config.sEnvirDir + 'Robot_def\' + 'RobotManage.txt';
    sScritpDir := g_Config.sEnvirDir + 'Robot_def\';
    if not DirectoryExists(sScritpDir) then MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then begin
      tSaveList := TStringList.Create;
      tSaveList.Add(';�˽�Ϊ������ר�ýű������ڻ����˴������õĽű���');
      tSaveList.SaveToFile(sScriptFile);
      tSaveList.Free;
    end;
    if FileExists(sScriptFile) then begin
      g_RobotNPC := TMerchant.Create;
      g_RobotNPC.m_sMapName := '0';
      g_RobotNPC.m_nCurrX := 0;
      g_RobotNPC.m_nCurrY := 0;
      g_RobotNPC.m_sCharName := 'RobotManage';
      g_RobotNPC.m_nFlag := 0;
      g_RobotNPC.m_wAppr := 0;
      g_RobotNPC.m_sFilePath := 'Robot_def\';
      g_RobotNPC.m_boIsHide := True;
      g_RobotNPC.m_boIsQuest := False;
      UserEngine.QuestNPCList.Add(g_RobotNPC);
    end else begin
      g_RobotNPC := nil;
    end;
  except
    g_RobotNPC := nil;
  end;
end;

function TFrmDB.LoadMapEvent(): Integer;
var
  sFileName, tStr: string;
  tMapEventList: TStringList;
  I: Integer;
  s18, s1C, s20, s24, s28, s2C, s30, s34, s36, s38, s40, s42, s44, s46, sRange: string;
  MapEvent: pTMapEvent;
  Map: TEnvirnoment;
begin
  Result := 1;
  sFileName := g_Config.sEnvirDir + 'MapEvent.txt';
  if FileExists(sFileName) then begin
    tMapEventList := TStringList.Create;
    try
      tMapEventList.LoadFromFile(sFileName);
      if tMapEventList.Count > 0 then begin//20080629
        for I := 0 to tMapEventList.Count - 1 do begin
          tStr := tMapEventList.Strings[I];
          if (tStr <> '') and (tStr[1] <> ';') then begin
            tStr := GetValidStr3(tStr, s18, [' ', #9]);
            tStr := GetValidStr3(tStr, s1C, [' ', #9]);
            tStr := GetValidStr3(tStr, s20, [' ', #9]);
            tStr := GetValidStr3(tStr, sRange, [' ', #9]);
            tStr := GetValidStr3(tStr, s24, [' ', #9]);
            tStr := GetValidStr3(tStr, s28, [' ', #9]);
            tStr := GetValidStr3(tStr, s2C, [' ', #9]);
            tStr := GetValidStr3(tStr, s30, [' ', #9]);
            if (s18 <> '') and (s1C <> '') and (s20 <> '') and (s30 <> '') then begin
              Map := g_MapManager.FindMap(s18);
              if Map <> nil then begin
                New(MapEvent);
                FillChar(MapEvent.m_MapFlag, SizeOf(TQuestUnitStatus), 0);
                FillChar(MapEvent.m_Condition, SizeOf(TMapCondition), #0);
                FillChar(MapEvent.m_StartScript, SizeOf(TStartScript), #0);
                MapEvent.m_sMapName := Trim(s18);
                MapEvent.m_nCurrX := Str_ToInt(s1C, 0);
                MapEvent.m_nCurrY := Str_ToInt(s20, 0);
                MapEvent.m_nRange := Str_ToInt(sRange, 0);
                s24 := GetValidStr3(s24, s34, [':', #9]);
                s24 := GetValidStr3(s24, s36, [':', #9]);
                MapEvent.m_MapFlag.nQuestUnit := Str_ToInt(s34, 0);
                if Str_ToInt(s36, 0) <> 0 then MapEvent.m_MapFlag.boOpen := True
                else MapEvent.m_MapFlag.boOpen := False;
                s28 := GetValidStr3(s28, s38, [':', #9]);
                s28 := GetValidStr3(s28, s40, [':', #9]);
                s28 := GetValidStr3(s28, s42, [':', #9]);
                MapEvent.m_Condition.nHumStatus := Str_ToInt(s38, 0);
                MapEvent.m_Condition.sItemName := Trim(s40);
                if Str_ToInt(s42, 0) <> 0 then MapEvent.m_Condition.boNeedGroup := True
                else MapEvent.m_Condition.boNeedGroup := False;
                MapEvent.m_nRandomCount := Str_ToInt(s2C, 999999);
                s30 := GetValidStr3(s30, s44, [':', #9]);
                s30 := GetValidStr3(s30, s46, [':', #9]);
                MapEvent.m_StartScript.nLable := Str_ToInt(s44, 0);
                MapEvent.m_StartScript.sLable := Trim(s46);
                case MapEvent.m_Condition.nHumStatus of
                  1: g_MapEventListOfDropItem.Add(MapEvent);
                  2: g_MapEventListOfPickUpItem.Add(MapEvent);
                  3: g_MapEventListOfMine.Add(MapEvent);
                  4: g_MapEventListOfWalk.Add(MapEvent);
                  5: g_MapEventListOfRun.Add(MapEvent);
                else begin
                    Dispose(MapEvent);
                  end;
                end;
              end else Result := -I;
            end;
          end;
        end;//for
      end;
    finally
      tMapEventList.Free;//20080117
    end;
  end;
end;

function TFrmDB.LoadMapQuest(): Integer;
var
  sFileName, tStr: string;
  tMapQuestList: TStringList;
  I: Integer;
  s18, s1C, s20, s24, s28, s2C, s30, s34: string;
  n38, n3C: Integer;
  boGrouped: Boolean;
  Map: TEnvirnoment;
begin
  Result := 1;
  sFileName := g_Config.sEnvirDir + 'MapQuest.txt';
  if FileExists(sFileName) then begin
    tMapQuestList := TStringList.Create;
    try
      tMapQuestList.LoadFromFile(sFileName);
      if tMapQuestList.Count > 0 then begin //20080629
        for I := 0 to tMapQuestList.Count - 1 do begin
          tStr := tMapQuestList.Strings[I];
          if (tStr <> '') and (tStr[1] <> ';') then begin
            tStr := GetValidStr3(tStr, s18, [' ', #9]);
            tStr := GetValidStr3(tStr, s1C, [' ', #9]);
            tStr := GetValidStr3(tStr, s20, [' ', #9]);
            tStr := GetValidStr3(tStr, s24, [' ', #9]);
            if (s24 <> '') and (s24[1] = '"') then ArrestStringEx(s24, '"', '"', s24);
            tStr := GetValidStr3(tStr, s28, [' ', #9]);
            if (s28 <> '') and (s28[1] = '"') then ArrestStringEx(s28, '"', '"', s28);
            tStr := GetValidStr3(tStr, s2C, [' ', #9]);
            tStr := GetValidStr3(tStr, s30, [' ', #9]);
            if (s18 <> '') and (s24 <> '') and (s2C <> '') then begin
              Map := g_MapManager.FindMap(s18);
              if Map <> nil then begin
                ArrestStringEx(s1C, '[', ']', s34);
                n38 := Str_ToInt(s34, 0);
                n3C := Str_ToInt(s20, 0);
                if CompareLStr(s30, 'GROUP', 5) then boGrouped := True
                else boGrouped := False;
                if not Map.CreateQuest(n38, n3C, s24, s28, s2C, boGrouped) then Result := -I;
                //nFlag,boFlag,Monster,Item,Quest,boGrouped
              end else Result := -I;
            end else Result := -I;
          end;
        end;//for
      end;
    finally
      tMapQuestList.Free;
    end;
  end;
  LoadQMangeNPC();
  QFunctionNPC();
  {$IF M2Version = 1}
  QBatterNPC();//����NPC 20090623
  {$IFEND}
  RobotNPC();
  QMissionNPC();//���� QMission-0.txt �ű�����(����ť) 20100801
end;
//�ű�   ��ͼ     ����X   ����Y   NPC��ʾ��   ��ʶ   ����  �Ƿ�Ǳ�  �ܷ��ƶ� �Ƿ��ɫ ��ɫʱ��
function TFrmDB.LoadMerchant(): Integer;
var
  sFileName, sLineText, sScript, sMapName, sX, sY, sName, sFlag, sAppr:string;
  sIsCalste, sCanMove, sMoveTime, sAutoChangeColor, sAutoChangeColorTime: string;
  tMerchantList: TStringList;
  tMerchantNPC: TMerchant;
  I, J: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'Merchant.txt';
  if FileExists(sFileName) then begin
    tMerchantList := TStringList.Create;
    try
      tMerchantList.LoadFromFile(sFileName);
      SetStringList(tMerchantList);//�ű����� 20100815
      if tMerchantList.Count > 0 then begin//20080629
        for I := 0 to tMerchantList.Count - 1 do begin
          sLineText := Trim(tMerchantList.Strings[I]);
          if (sLineText <> '') and (sLineText[1] <> ';') then begin
            sLineText := GetValidStr3(sLineText, sScript, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sMapName, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sX, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sY, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sName, [' ', #9]);
            if (sName <> '') and (sName[1] = '"') then
              ArrestStringEx(sName, '"', '"', sName);
            sLineText := GetValidStr3(sLineText, sFlag, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sAppr, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sIsCalste, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sCanMove, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sMoveTime, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sAutoChangeColor, [' ', #9]);
            sLineText := GetValidStr3(sLineText, sAutoChangeColorTime, [' ', #9]);

            if (sScript <> '') and (sMapName <> '') and (sAppr <> '') then begin
              tMerchantNPC := TMerchant.Create;
              tMerchantNPC.m_sScript := sScript;
              tMerchantNPC.m_sMapName := sMapName;
              tMerchantNPC.m_nCurrX := Str_ToInt(sX, 0);
              tMerchantNPC.m_nCurrY := Str_ToInt(sY, 0);
              tMerchantNPC.m_sCharName := sName;//NPC����
              tMerchantNPC.m_nFlag := Str_ToInt(sFlag, 0);
              J:= GetValNameNo(sAppr);
              case J of
                100..199: begin//G����
                  tMerchantNPC.m_sRefresAppr:= sAppr;
                  tMerchantNPC.m_wAppr := g_Config.GlobalVal[J - 100];
                end;
                800..1199: begin
                  tMerchantNPC.m_sRefresAppr:= sAppr;
                  tMerchantNPC.m_wAppr := g_Config.GlobalVal[J - 700];
                end;
                2100..2599: begin
                  tMerchantNPC.m_sRefresAppr:= sAppr;
                  tMerchantNPC.m_wAppr := g_Config.GlobalVal[J - 1600];
                end
                else tMerchantNPC.m_wAppr := Str_ToInt(sAppr, 0);//���
              end;
              tMerchantNPC.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
              tMerchantNPC.m_dwNpcAutoChangeColorTime := Str_ToInt(sAutoChangeColorTime, 0) * 1000;
              if Str_ToInt(sIsCalste, 0) <> 0 then tMerchantNPC.m_boCastle := True;
              if (Str_ToInt(sCanMove, 0) <> 0) and (tMerchantNPC.m_dwMoveTime > 0) then
                tMerchantNPC.m_boCanMove := True;
              if Str_ToInt(sAutoChangeColor, 0) <> 0 then tMerchantNPC.m_boNpcAutoChangeColor := True;
              UserEngine.AddMerchant(tMerchantNPC);
            end;
          end;
        end;//for
      end;
    finally
      tMerchantList.Free;
    end;
  end;
  Result := 1;
end;

function TFrmDB.LoadMinMap: Integer;
var
  sFileName, tStr, sMapNO, sMapIdx: string;
  tMapList: TStringList;
  I, nIdx: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'MiniMap.txt';
  if FileExists(sFileName) then begin
    if MiniMapList.Count > 0 then MiniMapList.Clear;//20080831 �޸�
    tMapList := TStringList.Create;
    try
      tMapList.LoadFromFile(sFileName);
      for I := 0 to tMapList.Count - 1 do begin
        tStr := tMapList.Strings[I];
        if (tStr <> '') and (tStr[1] <> ';') then begin
          tStr := GetValidStr3(tStr, sMapNO, [' ', #9]);
          tStr := GetValidStr3(tStr, sMapIdx, [' ', #9]);
          nIdx := Str_ToInt(sMapIdx, 0);
          if nIdx > 0 then MiniMapList.AddObject(sMapNO, TObject(nIdx));
        end;
      end;//for
    finally
      tMapList.Free;
    end;
  end;
end;

function TFrmDB.LoadMonGen(): Integer;
  procedure LoadMapGen(MonGenList: TStringList; sFileName: string);
  var
    I: Integer;
    sFilePatchName: string;
    sFileDir: string;
    LoadList: TStringList;
  begin
    sFileDir := g_Config.sEnvirDir + 'MonGen\';
    if not DirectoryExists(sFileDir) then begin
      CreateDir(sFileDir);
    end;

    sFilePatchName := sFileDir + sFileName;
    if FileExists(sFilePatchName) then begin
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(sFilePatchName);
      for I := 0 to LoadList.Count - 1 do  MonGenList.Add(LoadList.Strings[I]);
      LoadList.Free;
    end;
  end;
var
  sFileName, sLineText, sData: string;
  MonGenInfo: pTMonGenInfo;
  LoadList: TStringList;
  sMapGenFile: string;
  I: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'MonGen.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      I := 0;
      while (True) do begin
        if I >= LoadList.Count then Break;
        if CompareLStr('loadgen', LoadList.Strings[I], 7{Length('loadgen')}) then begin
          sMapGenFile := GetValidStr3(LoadList.Strings[I], sLineText, [' ', #9]);
          LoadList.Delete(I);
          if sMapGenFile <> '' then LoadMapGen(LoadList, sMapGenFile);
        end;
        Inc(I);
      end;

      for I := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[I];
        if (sLineText <> '') and (sLineText[1] <> ';') then begin
          New(MonGenInfo);
          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//��ͼ����
          MonGenInfo.sMapName := sData;

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//X
          MonGenInfo.nX := Str_ToInt(sData, 0);

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//Y
          MonGenInfo.nY := Str_ToInt(sData, 0);

          sLineText := GetValidStrCap(sLineText, sData, [' ', #9]);//������
          if (sData <> '') and (sData[1] = '"') then ArrestStringEx(sData, '"', '"', sData);

          MonGenInfo.sMonName := sData;

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//��Χ
          MonGenInfo.nRange := Str_ToInt(sData, 0);

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//����
          MonGenInfo.nCount := Str_ToInt(sData, 0);

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//ʱ��(��)
          MonGenInfo.dwZenTime := Str_ToInt(sData, -1) * 60000{60 * 1000};
          
          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//��������
          case Str_ToInt(sData, 0) of
            1: begin
              MonGenInfo.boIsNGMon := True;//�ڹ���
              MonGenInfo.boIsHeroPulsMon := False;
            end;
            2: begin
              MonGenInfo.boIsNGMon := False;
              MonGenInfo.boIsHeroPulsMon := True;//Ӣ�۾��羭���
            end;
            3: begin//�ڹ��֣�Ӣ�۾���� 20091127
              MonGenInfo.boIsNGMon := True;//�ڹ���
              MonGenInfo.boIsHeroPulsMon := True;//Ӣ�۾��羭���
            end;
            else begin
              MonGenInfo.boIsNGMon := False;//�ڹ���
              MonGenInfo.boIsHeroPulsMon := False;//Ӣ�۾��羭���
            end;
          end;

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);//�Զ������ֵ���ɫ 20080810
          MonGenInfo.nNameColor := Str_ToInt(sData, 255);

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
          MonGenInfo.nMissionGenRate := Str_ToInt(sData, 0); //��������ˢ�»��� 1 -100

          sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
          MonGenInfo.nChangeColorType := Str_ToInt(sData, -1); //��ɫ2007-02-01����

          if (MonGenInfo.sMapName <> '') and (MonGenInfo.sMonName <> '') and (MonGenInfo.dwZenTime > 0) and
            (g_MapManager.GetMapInfo(nServerIndex, MonGenInfo.sMapName) <> nil) then begin
            if UserEngine.GetMonRace(MonGenInfo.sMonName) >= 0 then begin//������������Ƿ�Ϸ� 20090427
              MonGenInfo.CertList := TList.Create;
              MonGenInfo.Envir := g_MapManager.FindMap(MonGenInfo.sMapName);
              if MonGenInfo.Envir <> nil then begin
                MonGenInfo.dwStartTick:= 0;//20110526 ����
                UserEngine.m_MonGenList.Add(MonGenInfo);
                UserEngine.AddMapMonGenCount(MonGenInfo.sMapName, MonGenInfo.nCount);
              end else begin
                MonGenInfo.CertList.Free;//20110526 ����
                Dispose(MonGenInfo);
              end;
            end else begin
              MainOutMessage(Format('MonGen.txt ����:%s Monster.DB�в����ڣ�',[MonGenInfo.sMonName]));
              Dispose(MonGenInfo);//20090430 ����
            end;
          end else Dispose(MonGenInfo);//20090430 ����
          //tMonGenInfo.nRace:=UserEngine.GetMonRace(tMonGenInfo.sMonName);
        end;
      end;//for

      New(MonGenInfo);//����Ӣ�ۣ�����֮��Ĵ�ȡ 
      MonGenInfo.sMapName := '';
      MonGenInfo.sMonName := 'DefObj';
      MonGenInfo.CertList := TList.Create;
      MonGenInfo.Envir := nil;
      UserEngine.m_MonGenList.Add(MonGenInfo);
    finally
      LoadList.Free;
    end;  
    Result := 1;
  end;
end;

function TFrmDB.LoadMonsterDB(): Integer;
var
  I: Integer;
  Monster: pTMonInfo;
resourcestring
  //sSQLString = 'select * from Monster';
  sSQLString = 'select NAME,Race,RaceImg,Appr,Lvl,Undead,CoolEye,Exp,HP,MP,AC,MAC,'+
               'DC,DCMAX,MC,SC,SPEED,HIT,WALK_SPD,WalkStep,WalkWait,ATTACK_SPD from Monster';
begin
  Result := 0;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if UserEngine.MonsterList.Count > 0 then begin//20080629
      for I := 0 to UserEngine.MonsterList.Count - 1 do begin
        if pTMonInfo(UserEngine.MonsterList.Items[I]) <> nil then
           Dispose(pTMonInfo(UserEngine.MonsterList.Items[I]));
      end;
      UserEngine.MonsterList.Clear;
    end;
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -1;
    end;
    if Query.RecordCount > 0 then begin//20080629
      for I := 0 to Query.RecordCount - 1 do begin
        New(Monster);

        Monster.ItemList := TList.Create;
        Monster.sName := Trim(Query.FieldByName('NAME').AsString);
        Monster.btRace := Query.FieldByName('Race').AsInteger;
        Monster.btRaceImg := Query.FieldByName('RaceImg').AsInteger;
        Monster.wAppr := Query.FieldByName('Appr').AsInteger;
        Monster.wLevel := Query.FieldByName('Lvl').AsInteger;
        Monster.btLifeAttrib := Query.FieldByName('Undead').AsInteger;//����ϵ 1-����ϵ
        Monster.wCoolEye := Query.FieldByName('CoolEye').AsInteger;
        Monster.dwExp := Query.FieldByName('Exp').AsInteger;
        //���Ż��ǽ��״̬��HPֵ�йأ����HP�쳣�������³�ǽ��ʾ����
        if (Monster.btRace=110) or (Monster.btRace=111) then begin //���Ϊ��ǽ�������HP���ӱ� 20080829
          Monster.wHP := Query.FieldByName('HP').AsInteger;
        end else begin
          Monster.wHP := Round(Query.FieldByName('HP').AsInteger * (g_Config.nMonsterPowerRate / 10));
        end;
        if (Monster.btRace = 158) then begin
          Monster.wMP := Query.FieldByName('MP').AsInteger;
        end else begin
          Monster.wMP := Round(Query.FieldByName('MP').AsInteger * (g_Config.nMonsterPowerRate / 10));
        end;
        Monster.wAC := Round(Query.FieldByName('AC').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wMAC := Round(Query.FieldByName('MAC').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wDC := Round(Query.FieldByName('DC').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wMaxDC := Round(Query.FieldByName('DCMAX').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wMC := Round(Query.FieldByName('MC').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wSC := Round(Query.FieldByName('SC').AsInteger * (g_Config.nMonsterPowerRate / 10));
        Monster.wSpeed := Query.FieldByName('SPEED').AsInteger;
        Monster.wHitPoint := Query.FieldByName('HIT').AsInteger;
        Monster.wWalkSpeed := _MAX(200, Query.FieldByName('WALK_SPD').AsInteger);
        Monster.wWalkStep := _MAX(1, Query.FieldByName('WalkStep').AsInteger);
        Monster.wWalkWait := Query.FieldByName('WalkWait').AsInteger;
        Monster.wAttackSpeed := Query.FieldByName('ATTACK_SPD').AsInteger;

        if Monster.wAttackSpeed < 200 then Monster.wAttackSpeed := 200;
        //�¾��ڴ�й¶ By TasNat at: 2012-05-21 17:41:26
        //Monster.ItemList := nil;
        LoadMonitems(Monster.sName, Monster.ItemList);//��ȡ���ﱬ���ļ�
        UserEngine.MonsterList.Add(Monster);
        Result := 1;
        Query.Next;
      end;
    end;
    Query.Close;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
//��ȡ���ﱬ���ļ�
function TFrmDB.LoadMonitems(MonName: string; var ItemList: TList): Integer;
var
  I, K: Integer;
  s24: string;
  LoadList, TempList: TStringList;
  MonItem, MonItem1: pTMonItem;
  s28, s2C, s30, s38, s39, s40, s41: string;
  n18, n1C, n20, n21, n22: Integer;
begin
  Result := 0;
  s24 := g_Config.sEnvirDir + 'MonItems\' + MonName + '.txt';
  if FileExists(s24) then begin
    if ItemList <> nil then begin
      if ItemList.Count > 0 then begin
        for I := 0 to ItemList.Count - 1 do begin
          if pTMonItem(ItemList.Items[I]) <> nil then begin
            if pTMonItem(ItemList.Items[I]).NewMonList <> nil then begin
              if pTMonItem(ItemList.Items[I]).NewMonList.Count > 0 then begin
                for K:= 0 to pTMonItem(ItemList.Items[I]).NewMonList.Count - 1 do begin
                  if pTMonItem(pTMonItem(ItemList.Items[I]).NewMonList.Items[K]) <> nil then
                    Dispose(pTMonItem(pTMonItem(ItemList.Items[I]).NewMonList.Items[K]));
                end;
              end;
              pTMonItem(ItemList.Items[I]).NewMonList.Free;
            end;
            Dispose(pTMonItem(ItemList.Items[I]));
          end;
        end;
      end;
      ItemList.Clear;
    end;
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(s24);
      DeCodeStringList(LoadList);//20090305 �����ļ�֧�ּ���
      for I := 0 to LoadList.Count - 1 do begin
        s28 := LoadList.Strings[I];
        if (s28 <> '') and (s28[1] <> ';') then begin
          s28 := GetValidStr3(s28, s30, [' ', '/', #9]);
          n18 := Str_ToInt(s30, -1);
          s28 := GetValidStr3(s28, s30, [' ', '/', #9]);
          n1C := Str_ToInt(s30, -1);
          s28 := GetValidStr3(s28, s30, [' ', #9]);
          if s30 <> '' then begin
            if s30[1] = '"' then
              ArrestStringEx(s30, '"', '"', s30);
          end;
          s2C := s30;
          s28 := GetValidStr3(s28, s30, [' ', #9]);
          n20 := Str_ToInt(s30, 1);
          if (n18 > 0) and (n1C > 0) and (s2C <> '') then begin
            if ItemList = nil then ItemList := TList.Create;
            if CompareLStr(s2C, 'RANDOM', 6) then begin//��ģʽ 20110225
              ArrestStringEx(s2C, '"', '"', s38);
              if s38 <> '' then begin
                TempList := TStringList.Create;
                try
                  ExtractStrings(['|'], [], PChar(s38), TempList);
                  if TempList.Count > 0 then begin
                    New(MonItem);
                    MonItem.NewMonList:= TList.Create;
                    MonItem.n00 := n18 - 1;
                    MonItem.n04 := n1C;
                    MonItem.sMonName := 'RANDOM';
                    MonItem.n18 := n20;
                    for K := 0 to TempList.Count - 1 do begin
                      s39 := TempList.Strings[K];
                      if (s39 <> '') and (s39[1] = '[') then begin
                        s41:= ArrestStringEx(s39, '[', ']', s40);
                        s40 := GetValidStr3(s40, s39, ['/']);
                        n21 := Str_ToInt(s39, -1);
                        n22 := Str_ToInt(s40, -1);
                        if (n21 > 0) and (n22 > 0) and (s41 <> '') then begin
                          if CompareText(s41, sSTRING_GOLDNAME) <> 0 then begin//���ǽ��
                            New(MonItem1);
                            MonItem1.NewMonList:= nil;
                            MonItem1.n00 := n21 - 1;
                            MonItem1.n04 := n22;
                            MonItem1.sMonName := s41;
                            MonItem.NewMonList.Add(MonItem1);
                          end;
                        end;
                      end;
                    end;
                    ItemList.Add(MonItem);
                    Inc(Result);
                  end;
                finally
                  TempList.Free;
                end;
              end;
            end else begin
              New(MonItem);
              MonItem.NewMonList:= nil;
              MonItem.n00 := n18 - 1;
              MonItem.n04 := n1C;
              MonItem.sMonName := s2C;
              MonItem.n18 := n20;
              ItemList.Add(MonItem);
              Inc(Result);
            end;
          end;
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;
end;
//;����  ����  ��ͼ   x   y  ��Χ  ͼ�� �Ƿ��ɫ ��ɫʱ�� 
function TFrmDB.LoadNpcs(): Integer;
var
  sFileName, s18, s20, s24, s28, s2C, s30, s34, s38, s40, s42: string;
  LoadList: TStringList;
  NPC: TNormNpc;
  I: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'Npcs.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      SetStringList(LoadList);//�ű����� 20100815
      for I := 0 to LoadList.Count - 1 do begin
        s18 := Trim(LoadList.Strings[I]);
        if (s18 <> '') and (s18[1] <> ';') then begin
          s18 := GetValidStrCap(s18, s20, [' ', #9]);//����
          if (s20 <> '') and (s20[1] = '"') then ArrestStringEx(s20, '"', '"', s20);
          s18 := GetValidStr3(s18, s24, [' ', #9]);//NPC����
          s18 := GetValidStr3(s18, s28, [' ', #9]);//��ͼ
          s18 := GetValidStr3(s18, s2C, [' ', #9]);//X
          s18 := GetValidStr3(s18, s30, [' ', #9]);//Y
          s18 := GetValidStr3(s18, s34, [' ', #9]);//��Χ
          s18 := GetValidStr3(s18, s38, [' ', #9]);//ͼ��
          s18 := GetValidStr3(s18, s40, [' ', #9]);//�Ƿ��ɫ
          s18 := GetValidStr3(s18, s42, [' ', #9]);//��ɫʱ��
          if (s20 <> '') and (s28 <> '') and (s38 <> '') then begin
            NPC := nil;
            case Str_ToInt(s24, 0) of
              0: NPC := TMerchant.Create;//��ͨNPC
              1: NPC := TGuildOfficial.Create;//�л�NPC
              2: NPC := TCastleOfficial.Create;//�Ǳ�NPC
            end;
            if NPC <> nil then begin
              NPC.m_sMapName := s28;
              NPC.m_nCurrX := Str_ToInt(s2C, 0);
              NPC.m_nCurrY := Str_ToInt(s30, 0);
              NPC.m_sCharName := s20;
              NPC.m_nFlag := Str_ToInt(s34, 0);
              NPC.m_wAppr := Str_ToInt(s38, 0);
              if Str_ToInt(s40, 0) <> 0 then NPC.m_boNpcAutoChangeColor := True;
              NPC.m_dwNpcAutoChangeColorTime := Str_ToInt(s42, 0) * 1000;
              UserEngine.QuestNPCList.Add(NPC);
            end;
          end;
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;
  Result := 1;
end;

function TFrmDB.LoadQuestDiary(): Integer;
  function sub_48978C(nIndex: Integer): string;
  begin
    if nIndex >= 1000 then begin
      Result := IntToStr(nIndex);
      Exit;
    end;
    if nIndex >= 100 then begin
      Result := IntToStr(nIndex) + '0';
      Exit;
    end;
    Result := IntToStr(nIndex) + '00';
  end;
var
  I, II: Integer;
  QDDinfoList: TList;
  QDDinfo: pTQDDinfo;
  s14, s18, s1C, s20: string;
  bo2D: Boolean;
  nC: Integer;
  LoadList: TStringList;
begin
  Result := 1;
  if g_QuestDiaryList = nil then Exit;
  
  if g_QuestDiaryList.Count > 0 then begin//20080629
    for I := 0 to g_QuestDiaryList.Count - 1 do begin
      QDDinfoList := g_QuestDiaryList.Items[I];
      if QDDinfoList.Count > 0 then begin//20080629
        for II := 0 to QDDinfoList.Count - 1 do begin
          QDDinfo := QDDinfoList.Items[II];
          QDDinfo.sList.Free;
          Dispose(QDDinfo);
        end;
      end;
      QDDinfoList.Free;
    end;
    g_QuestDiaryList.Clear;
  end;
  bo2D := False;
  nC := 1;
  while (True) do begin
    QDDinfoList := nil;
    s14 := 'QuestDiary\' + sub_48978C(nC) + '.txt';
    if FileExists(s14) then begin
      s18 := '';
      QDDinfo := nil;
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(s14);
      for I := 0 to LoadList.Count - 1 do begin
        s1C := LoadList.Strings[I];
        if (s1C <> '') and (s1C[1] <> ';') then begin
          if (s1C[1] = '[') and (Length(s1C) > 2) then begin
            if s18 = '' then begin
              ArrestStringEx(s1C, '[', ']', s18);
              QDDinfoList := TList.Create;
              New(QDDinfo);
              QDDinfo.n00 := nC;
              QDDinfo.s04 := s18;
              QDDinfo.sList := TStringList.Create;
              QDDinfoList.Add(QDDinfo);
              bo2D := True;
            end else begin
              if s1C[1] <> '@' then begin
                s1C := GetValidStr3(s1C, s20, [' ', #9]);
                ArrestStringEx(s20, '[', ']', s20);
                New(QDDinfo);
                QDDinfo.n00 := Str_ToInt(s20, 0);
                QDDinfo.s04 := s1C;
                QDDinfo.sList := TStringList.Create;
                QDDinfoList.Add(QDDinfo);
                bo2D := True;
              end else bo2D := False;
            end;
          end else begin
            if bo2D then QDDinfo.sList.Add(s1C);
          end;
        end;
      end;//for
      LoadList.Free;
    end;
    if QDDinfoList <> nil then g_QuestDiaryList.Add(QDDinfoList)
    else g_QuestDiaryList.Add(nil);
    Inc(nC);
    if nC >= 105 then Break;
  end;
end;
//���ػسǵ�����
function TFrmDB.LoadStartPoint(): Integer;
var
  sFileName, tStr, s18, s1C, s20, s22, s24, s26: string;
  LoadList: TStringList;
  I: Integer;
  StartPoint: pTStartPoint;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'StartPoint.txt';
  if FileExists(sFileName) then begin
    try
      g_StartPointList.Lock;
      if g_StartPointList.Count > 0 then begin//20101025 ����
        for I := 0 to g_StartPointList.Count - 1 do begin
          Dispose(pTStartPoint(g_StartPointList.Objects[I]));
        end;
        g_StartPointList.Clear;
      end;
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        tStr := Trim(LoadList.Strings[I]);
        if (tStr <> '') and (tStr[1] <> ';') then begin
          tStr := GetValidStr3(tStr, s18, [' ', #9]);
          tStr := GetValidStr3(tStr, s1C, [' ', #9]);
          tStr := GetValidStr3(tStr, s20, [' ', #9]);
          tStr := GetValidStr3(tStr, s22, [' ', #9]);
          tStr := GetValidStr3(tStr, s24, [' ', #9]);
          tStr := GetValidStr3(tStr, s26, [' ', #9]);
          if (s18 <> '') and (s1C <> '') and (s20 <> '') then begin
            New(StartPoint);
            StartPoint.m_sMapName := s18;//��ͼ
            StartPoint.m_nCurrX := Str_ToInt(s1C, 0);//X
            StartPoint.m_nCurrY := Str_ToInt(s20, 0);//Y
            StartPoint.m_boNotAllowSay := Boolean(Str_ToInt(s22, 0));
            StartPoint.m_nRange := Str_ToInt(s24, 0);//��Χ
            StartPoint.m_nType := Str_ToInt(s26, 0);//����
            g_StartPointList.AddObject(s18, TObject(StartPoint));
            Result := 1;
          end;
        end;
      end;//for
    finally
      LoadList.Free;
      g_StartPointList.UnLock;
    end;
  end;
end;
//����Ѱ·������Ŀ�������
function TFrmDB.LoadAutoFindRout(): Integer;
var
  sFileName, tStr, s18, s1C, s20: string;
  LoadList: TStringList;
  I: Integer;
  FindRout: pTFindRout;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'AutoFindRout.txt';

  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.Add(';���ı�Ϊ109���Զ�Ѱ·Ŀ�����������(XY�����ӦMapInfo.txt�еĵ�ͼ�Ĵ��͵�)');
      LoadList.Add(';��ͼ X���� Y����');
      LoadList.Add(';·��:ɳ�Ϳ˻ʹ���->����ʡ��->����ͨ����->����ɽ��(�򹤼���Ӫ)��->����ʡ��->����ʹ�');
      LoadList.Add(';ɳ�Ϳ˻ʹ�');
      LoadList.Add('0150 15 20');
      LoadList.Add(';����ɽ��ͨ��');
      LoadList.Add('3 511 776');
      LoadList.Add(';����ɽ��ͨ��(�򹤼���Ӫ)');
      LoadList.Add(' 2 413 565');
      LoadList.Add(';����ʡ');
      LoadList.Add('0 347 186');
      LoadList.Add(';����ʹ�');
      LoadList.Add('0122 29 34');
      LoadList.SaveToFile(sFileName);
    finally
      LoadList.Free;
    end;
  end;

  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      g_AutoFindRout.Lock;
      if g_AutoFindRout.Count > 0 then begin
        for I := 0 to g_AutoFindRout.Count - 1 do begin
          if pTFindRout(g_AutoFindRout.Objects[I]) <> nil then Dispose(pTFindRout(g_AutoFindRout.Objects[I]));
        end;
      end;
      g_AutoFindRout.Clear;
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        tStr := Trim(LoadList.Strings[I]);
        if (tStr <> '') and (tStr[1] <> ';') then begin
          tStr := GetValidStr3(tStr, s18, [' ', #9]);
          tStr := GetValidStr3(tStr, s1C, [' ', #9]);
          tStr := GetValidStr3(tStr, s20, [' ', #9]);
          if (s18 <> '') and (s1C <> '') and (s20 <> '') then begin
            New(FindRout);
            FindRout.m_sMapName := s18;//��ͼ
            FindRout.m_nCurrX := Str_ToInt(s1C, 0);//X
            FindRout.m_nCurrY := Str_ToInt(s20, 0);//Y
            g_AutoFindRout.AddObject(s18, TObject(FindRout));
            Result := 1;
          end;
        end;
      end;//for
    finally
      g_AutoFindRout.UnLock;
      LoadList.Free;
    end;
  end;
end;
//��ȡ�����Ʒ�ļ�
function TFrmDB.LoadUnbindList(): Integer;
var
  sFileName, tStr, sData, s20: string;
  LoadList: TStringList;
  I: Integer;
  n10: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'UnbindList.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        tStr := LoadList.Strings[I];
        if (tStr <> '') and (tStr[1] <> ';') then begin
          tStr := GetValidStr3(tStr, sData, [' ', #9]);
          tStr := GetValidStrCap(tStr, s20, [' ', #9]);
          if (s20 <> '') and (s20[1] = '"') then ArrestStringEx(s20, '"', '"', s20);

          n10 := Str_ToInt(sData, 0);
          if n10 > 0 then g_UnbindList.AddObject(s20, TObject(n10))
          else begin
            Result := -I; //��Ҫȡ����
            Break;
          end;
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;
end;

function TFrmDB.LoadNpcScript(NPC: TNormNpc; sPatch,
  sScritpName: string): Integer;
begin
  if sPatch = '' then sPatch := sNpc_def;
  Result := LoadScriptFile(NPC, sPatch, sScritpName, False);
end;
//��ȡ�ű��ļ�
function TFrmDB.LoadScriptFile(NPC: TNormNpc; sPatch, sScritpName: string;
  boFlag: Boolean): Integer;
var
  nQuestIdx, I, n1C, n20, n24, nItemType, nPriceRate: Integer;
  n6C, n70: Integer;
  sScritpFileName, s30, s34, s38, s3C, s40, s44, s48, s4C, s50: string;
  LoadList: TStringList;
  DefineList: TList;
  s54, s58, s5C, s74: string;
  DefineInfo: pTDefineInfo;
  bo8D: Boolean;
  Script: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
  QuestConditionInfo: pTQuestConditionInfo;
  QuestActionInfo: pTQuestActionInfo;
  Goods: pTGoods;
  boDeCodeFile: Boolean;//�Ƿ��Ǽ��ܽű� 20090605
  nCode: byte;
  function LoadCallScript(sFileName, sLabel: string; var List: TStringList): Boolean;
  var
    I: Integer;
    LoadStrList: TStringList;
    bo1D: Boolean;
    s18: string;
  begin
    Result := False;
    try
      if FileExists(sFileName) then begin
        LoadStrList := TStringList.Create;
        try
          LoadStrList.LoadFromFile(sFileName);
          DeCodeStringList(LoadStrList);
          sLabel := '[' + sLabel + ']';
          bo1D := False;
          if LoadStrList.Count > 0 then begin
            for I := 0 to LoadStrList.Count - 1 do begin
              s18 := Trim(LoadStrList.Strings[I]);
              if s18 <> '' then begin
                if not bo1D then begin
                  if (s18[1] = '[') and (CompareText(s18, sLabel) = 0) then begin
                    bo1D := True;
                    List.Add(s18);
                  end;
                end else begin
                  if s18[1] <> '{' then begin
                    if s18[1] = '}' then begin
                      //bo1D := False;//δʹ�� 20080723
                      Result := True;
                      Break;
                    end else begin
                      List.Add(s18);
                    end;
                  end;
                end;
              end; //00489CE4 if s18 <> '' then begin
            end; // for I := 0 to LoadStrList.Count - 1 do begin
          end;
        finally
          LoadStrList.Free;
        end;
      end;
    except
      MainOutMessage(format('{%s} LoadCallScript sFileName:%s sLabel:%s',[g_sExceptionVer, sFileName, sLabel]));
    end;
  end;
(*  //��ȡԶ�̽ű� 20080706
  function LoadUrlCallScript(sFileName, sLabel: string; var List: TStringList): Boolean;
  var
    I: Integer;
    LoadStrList: TStringList;
    bo1D: Boolean;
    s18: string;
  begin
    Result := False;
    if pos('http://', sFileName) > 0 then begin
      try
        LoadStrList := TStringList.Create;
        try
          LoadStrList.Text := FrmMain.IdHTTP1.Get(sFileName);
          DeCodeStringList(LoadStrList);
          sLabel := '[' + sLabel + ']';
          bo1D := False;
          if LoadStrList.Count > 0 then begin
            for I := 0 to LoadStrList.Count - 1 do begin
              s18 := Trim(LoadStrList.Strings[I]);
              if s18 <> '' then begin
                if not bo1D then begin
                  if (s18[1] = '[') and (CompareText(s18, sLabel) = 0) then begin
                    bo1D := True;
                    List.Add(s18);
                  end;
                end else begin
                  if s18[1] <> '{' then begin
                    if s18[1] = '}' then begin
                      bo1D := False;
                      Result := True;
                      Break;
                    end else begin
                      List.Add(s18);
                    end;
                  end;
                end;
              end; //if s18 <> '' then begin
            end; // for I := 0 to LoadStrList.Count - 1 do begin
          end;
        finally
          LoadStrList.Free;
        end;
      except
      end;
    end;
  end;        *)

  procedure LoadScriptcall(var LoadList: TStringList);
  var
    I: Integer;
    s14, s18, s1C, s20, s34: string;
    nCode: Byte;
  begin
    try
      nCode:= 0;
      if LoadList <> nil then begin
        if LoadList.Count > 0 then begin
          for I := 0 to LoadList.Count - 1 do begin
            nCode:= 1;
            s14 := Trim(LoadList.Strings[I]);
            if (s14 <> '') and (s14[1] = '#') then begin
              nCode:= 2;
              if CompareLStr(s14, '#CALL', 5) then begin
                nCode:= 3;
                s14 := ArrestStringEx(s14, '[', ']', s1C);
                s20 := Trim(s1C);
                s18 := Trim(s14);
                nCode:= 4;
                if s20 <> '' then begin
                  if s20[1] = '\' then s20 := Copy(s20, 2, Length(s20) - 1);
                  if s20[2] = '\' then s20 := Copy(s20, 3, Length(s20) - 2);
                end;
                nCode:= 5;
                s34 := g_Config.sEnvirDir + 'QuestDiary\' + s20;
                if LoadCallScript(s34, s18, LoadList) then begin
                  nCode:= 6;
                  LoadList.Strings[I] := '#ACT';
                  LoadList.Insert(I + 1, 'goto ' + s18);
                end else begin
                  MainOutMessage('�ű�����, ����ʧ��: ' + s20 +'  '+ s18);
                end;
              end;
             (* if CompareLStr(s14, '#URLCALL', 8) then begin//20080706 ��ȡԶ�̽ű�
                s14 := ArrestStringEx(s14, '[', ']', s1C);
                s20 := Trim(s1C);//ȡ��Զ�̽ű�HTTP
                s18 := Trim(s14);
                if LoadUrlCallScript(s20, s18, LoadList) then begin
                  LoadList.Strings[I] := '#ACT';
                  LoadList.Insert(I + 1, 'goto ' + s18);
                end else begin
                  MainOutMessage('�ű�����, ����ʧ��: ' + s20 +'  '+ s18);
                end;
              end;   *)
            end;//if (s14 <> '') and (s14[1] = '#')
          end;//for
        end;
      end;
    except
      MainOutMessage(format('{%s} LoadScriptcall Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
  function LoadDefineInfo(var LoadList: TStringList; var List: TList): string;//��ȡ������Ϣ
  var
    I: Integer;
    s14, s28, s1C, s20, s24: string;
    DefineInfo: pTDefineInfo;
    LoadStrList: TStringList;
  begin
    for I := 0 to LoadList.Count - 1 do begin
      s14 := Trim(LoadList.Strings[I]);
      if (s14 <> '') and (s14[1] = '#') then begin
        if CompareLStr(s14, '#SETHOME', 8{Length('#SETHOME')}) then begin
          Result := Trim(GetValidStr3(s14, s1C, [' ', #9]));
          LoadList.Strings[I] := '';
        end;
        if CompareLStr(s14, '#DEFINE', 7{Length('#DEFINE')}) then begin
          s14 := (GetValidStr3(s14, s1C, [' ', #9]));
          s14 := (GetValidStr3(s14, s20, [' ', #9]));
          s14 := (GetValidStr3(s14, s24, [' ', #9]));
          New(DefineInfo);
          DefineInfo.sName := UpperCase(s20);
          DefineInfo.sText := s24;
          List.Add(DefineInfo);
          LoadList.Strings[I] := '';
        end;
        if CompareLStr(s14, '#INCLUDE', 8{Length('#INCLUDE')}) then begin
          s28 := Trim(GetValidStr3(s14, s1C, [' ', #9]));
          s28 := g_Config.sEnvirDir + 'Defines\' + s28;
          if FileExists(s28) then begin
            LoadStrList := TStringList.Create;
            try
              LoadStrList.LoadFromFile(s28);
              Result := LoadDefineInfo(LoadStrList, List);
            finally
              LoadStrList.Free;
            end;
          end else begin
            MainOutMessage('�ű�����, ����ʧ��: ' + s28);
          end;
          LoadList.Strings[I] := '';
        end;
      end;
    end;//for
  end;
  function MakeNewScript(): pTScript;
  var
    ScriptInfo: pTScript;
  begin
    New(ScriptInfo);
    ScriptInfo.boQuest := False;
    FillChar(ScriptInfo.QuestInfo, SizeOf(TQuestInfo) * 10, #0);
    nQuestIdx := 0;
    ScriptInfo.RecordList := TList.Create;
    NPC.m_ScriptList.Add(ScriptInfo);
    Result := ScriptInfo;
  end;
  function QuestCondition(sText: string; var QuestConditionInfo: pTQuestConditionInfo): Boolean; //00489DDC
  var
    sCmd, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7, sParam8: string;
    nCMDCode: Integer;
  label L001;
  begin
    Result := False;
    sText := GetValidStrCap(sText, sCmd, [' ', #9]);
    sText := GetValidStrCap(sText, sParam1, [' ', #9]);
    sText := GetValidStrCap(sText, sParam2, [' ', #9]);
    sText := GetValidStrCap(sText, sParam3, [' ', #9]);
    sText := GetValidStrCap(sText, sParam4, [' ', #9]);
    sText := GetValidStrCap(sText, sParam5, [' ', #9]);
    sText := GetValidStrCap(sText, sParam6, [' ', #9]);
    sText := GetValidStrCap(sText, sParam7, [' ', #9]);
    sText := GetValidStrCap(sText, sParam8, [' ', #9]);
    sCmd := UpperCase(sCmd);
    sCmd := QuestConditionInfo.Script.Cmd(sCmd);//NPC������չ 20090926
    nCMDCode := 0;
    if sCmd = sCHECK then begin
      nCMDCode := nCHECK;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
      goto L001;
    end;
    {ע������ By TasNat at: 2012-04-24 10:51:32
    if sCmd = sCHECKOPEN then begin
      nCMDCode := nCHECKOPEN;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sCHECKUNIT then begin
      nCMDCode := nCHECKUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
      goto L001;
    end;} 
    if sCmd = sCHECKPKPOINT then begin
      nCMDCode := nCHECKPKPOINT;
      goto L001;
    end;
    if sCmd = sCHECKGOLD then begin
      nCMDCode := nCHECKGOLD;
      goto L001;
    end;
    if sCmd = sCHECKLEVEL then begin
      nCMDCode := nCHECKLEVEL;
      goto L001;
    end;
    if sCmd = sCHECKJOB then begin
      nCMDCode := nCHECKJOB;
      goto L001;
    end;
    if sCmd = sRANDOM then begin
      nCMDCode := nRANDOM;
      goto L001;
    end;
    if sCmd = sCHECKITEM then begin
      nCMDCode := nCHECKITEM;
      goto L001;
    end;
    if sCmd = sCHECKHUMINRANGE then begin//��������Ƿ���ָ����ͼ��Χ֮�� 20090808
      nCMDCode := nCHECKHUMINRANGE;
      goto L001;
    end;
    if sCmd = sCHECKKIMNEEDLE then begin//�������Ƿ���ָ��������Ʒ 20090615
      nCMDCode := nCHECKKIMNEEDLE;
      goto L001;
    end;
    if sCmd = sCHECKSKILL75 then begin//����Ƿ�ѧ��������� 20091126
      nCMDCode := nCHECKSKILL75;
      goto L001;
    end;
    {$IF M2Version = 1}
    if sCmd = sCHECKHEROOPENOPULS then begin//���Ӣ���Ƿ�ͨ����ϵͳ(Ӣ�۲����ߣ�ûѧ�ڹ�����ΪF)
      nCMDCode := nCHECKHEROOPENOPULS;
      goto L001;
    end;
    if sCmd = sCHECKHEROPULSEXP then begin//���Ӣ�۾���������
      nCMDCode := nCHECKHEROPULSEXP;
      goto L001;
    end;
    if sCmd = sCHECKHUMANPULSE then begin//����Ƿ��Ѩ��� 20090623
      nCMDCode := nCHECKHUMANPULSE;
      goto L001;
    end;
    if sCmd = sCHECKOPENPULSELEVEL then begin//����ͨѨλ�����ڹ��ȼ� 20090623
      nCMDCode := nCHECKOPENPULSELEVEL;
      goto L001;
    end;
    if sCmd = sCHECKPULSELEVEL then begin//��������ȼ� 20090816
      nCMDCode := nCHECKPULSELEVEL;
      goto L001;
    end;
    {$IFEND}
    if sCmd = sCHECKAUTOADDEXPPLAY then begin//���������һ����� 20090719
      nCMDCode := nCHECKAUTOADDEXPPLAY;
      goto L001;
    end;
    if sCmd = sCHECKAIPLAY then begin//��������������
      nCMDCode := nCHECKAIPLAY;
      goto L001;
    end;
    if sCmd = sCHECKMAP then begin//����ͼ�Ƿ����
      nCMDCode := nCHECKMAP;
      goto L001;
    end;
    if sCmd = sGENDER then begin
      nCMDCode := nGENDER;
      goto L001;
    end;
    if sCmd = sCHECKBAGGAGE then begin
      nCMDCode := nCHECKBAGGAGE;
      goto L001;
    end;
    if sCmd = sCHECKNAMELIST then begin
      nCMDCode := nCHECKNAMELIST;
      goto L001;
    end;
    if sCmd = sSC_HASGUILD then begin
      nCMDCode := nSC_HASGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISGUILDMASTER then begin
      nCMDCode := nSC_ISGUILDMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEMASTER then begin
      nCMDCode := nSC_CHECKCASTLEMASTER;
      goto L001;
    end;
    if sCmd = sSC_ISNEWHUMAN then begin
      nCMDCode := nSC_ISNEWHUMAN;
      goto L001;
    end;
    if sCmd = sSC_CHECKMEMBERTYPE then begin
      nCMDCode := nSC_CHECKMEMBERTYPE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMEMBERLEVEL then begin
      nCMDCode := nSC_CHECKMEMBERLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGOLD then begin
      nCMDCode := nSC_CHECKGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_CHECKSTRINGLENGTH then begin //����ַ������� 20090105
      nCMDCode := nSC_CHECKSTRINGLENGTH;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEDIAMOND then begin //�����ʯ���� 20071227
      nCMDCode := nSC_CHECKGAMEDIAMOND;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGIRD then begin //���������� 20071227
      nCMDCode := nSC_CHECKGAMEGIRD;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGLORY then begin //�������ֵ 20080511
      nCMDCode := nSC_CHECKGAMEGLORY;
      goto L001;
    end;
    if sCmd = sSC_CHECKSKILLLEVEL then begin //��鼼�ܵȼ� 20080512
      nCMDCode := nSC_CHECKSKILLLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPMOBCOUNT then begin //����ͼָ������ָ�����ƹ������� 20080123
      nCMDCode := nSC_CHECKMAPMOBCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKSIDESLAVENAME then begin //���������Χ�Լ��������� 20080425
      nCMDCode := nSC_CHECKSIDESLAVENAME;
      goto L001;
    end;
    if sCmd = sSC_CHECKLISTTEXT then begin //����ļ��Ƿ����ָ���ı� 20080427
      nCMDCode := nSC_CHECKLISTTEXT;
      goto L001;
    end;
    if sCmd = sSC_CHECKCURRENTDATE then begin //��⵱ǰ�����Ƿ�С�ڴ��ڵ���ָ�������� 20080416
      nCMDCode := nSC_CHECKCURRENTDATE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMASTERONLINE then begin //���ʦ������ͽ�ܣ��Ƿ����� 20080416
      nCMDCode := nSC_CHECKMASTERONLINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKDEARONLINE then begin //������һ���Ƿ����� 20080416
      nCMDCode := nSC_CHECKDEARONLINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMASTERONMAP then begin //���ʦ��(��ͽ��)�Ƿ���ָ���ĵ�ͼ�� 20080416
      nCMDCode := nSC_CHECKMASTERONMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKDEARONMAP then begin //������һ���Ƿ���ָ���ĵ�ͼ�� 20080416
      nCMDCode := nSC_CHECKDEARONMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEISPRENTICE then begin //�������Ƿ�Ϊ�Լ���ͽ�� 20080416
      nCMDCode := nSC_CHECKPOSEISPRENTICE;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEWAR then begin //����Ƿ��ڹ����ڼ� 20080422
      nCMDCode := nSC_CHECKCASTLEWAR;
      goto L001;
    end;
    if sCmd = sSC_FINDMAPPATH then begin //���õ�ͼ������XYֵ 20080124
      nCMDCode := nSC_FINDMAPPATH;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROLOYAL then begin //���Ӣ�۵��ҳ϶� 20080109
      nCMDCode := nSC_CHECKHEROLOYAL;
      goto L001;
    end;
    if sCmd = sISONMAKEWINE then begin//�ж��Ƿ��������־� 20080620
      nCMDCode := nISONMAKEWINE;
      goto L001;
    end;
    if sCmd = sCHECKGUILDFOUNTAIN  then begin//�ж��Ƿ����л�Ȫˮ�ֿ� 20080624
      nCMDCode := nCHECKGUILDFOUNTAIN;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEPOINT then begin
      nCMDCode := nSC_CHECKGAMEPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMELISTPOSITION then begin
      nCMDCode := nSC_CHECKNAMELISTPOSITION;
      goto L001;
    end;
    if sCmd = sSC_CHECKGUILDLIST then begin
      nCMDCode := nSC_CHECKGUILDLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKRENEWLEVEL then begin
      nCMDCode := nSC_CHECKRENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVELEVEL then begin
      nCMDCode := nSC_CHECKSLAVELEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVENAME then begin
      nCMDCode := nSC_CHECKSLAVENAME;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVETOPEST then begin
      nCMDCode := nSC_CHECKSLAVETOPEST;
      goto L001;
    end;
    if sCmd = sSC_CHECKCREDITPOINT then begin
      nCMDCode := nSC_CHECKCREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKOFGUILD then begin
      nCMDCode := nSC_CHECKOFGUILD;
      goto L001;
    end;
{$IF M2Version = 1}
    if sCmd = sSC_CHECK4BATTERSKILL then begin//����Ƿ����˵�������
      nCMDCode := nSC_CHECK4BATTERSKILL;
      goto L001;
    end;
{$IFEND}
    if sCmd = sSC_CHECKPAYMENT then begin
      nCMDCode := nSC_CHECKPAYMENT;
      goto L001;
    end;
    if sCmd = sSC_CHECKUSEITEM then begin
      nCMDCode := nSC_CHECKUSEITEM;
      goto L001;
    end;
    if sCmd = sSC_CHECKBAGSIZE then begin
      nCMDCode := nSC_CHECKBAGSIZE;
      goto L001;
    end;
    if sCmd = sSC_CHECKDC then begin
      nCMDCode := nSC_CHECKDC;
      goto L001;
    end;
    if sCmd = sSC_CHECKMC then begin
      nCMDCode := nSC_CHECKMC;
      goto L001;
    end;
    if sCmd = sSC_CHECKSC then begin
      nCMDCode := nSC_CHECKSC;
      goto L001;
    end;
    if sCmd = sSC_CHECKHP then begin
      nCMDCode := nSC_CHECKHP;
      goto L001;
    end;
    if sCmd = sSC_CHECKMP then begin
      nCMDCode := nSC_CHECKMP;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMTYPE then begin
      nCMDCode := nSC_CHECKITEMTYPE;
      goto L001;
    end;
    if sCmd = sSC_CHECKEXP then begin
      nCMDCode := nSC_CHECKEXP;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEGOLD then begin
      nCMDCode := nSC_CHECKCASTLEGOLD;
      goto L001;
    end;
    if sCmd = sSC_PASSWORDERRORCOUNT then begin
      nCMDCode := nSC_PASSWORDERRORCOUNT;
      goto L001;
    end;
    if sCmd = sSC_ISLOCKPASSWORD then begin
      nCMDCode := nSC_ISLOCKPASSWORD;
      goto L001;
    end;
    if sCmd = sSC_ISLOCKSTORAGE then begin
      nCMDCode := nSC_ISLOCKSTORAGE;
      goto L001;
    end;
    if sCmd = sSC_CHECKBUILDPOINT then begin
      nCMDCode := nSC_CHECKBUILDPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKAURAEPOINT then begin
      nCMDCode := nSC_CHECKAURAEPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKSTABILITYPOINT then begin
      nCMDCode := nSC_CHECKSTABILITYPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKFLOURISHPOINT then begin
      nCMDCode := nSC_CHECKFLOURISHPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKCONTRIBUTION then begin
      nCMDCode := nSC_CHECKCONTRIBUTION;
      goto L001;
    end;
    if sCmd = sSC_CHECKRANGEMONCOUNT then begin
      nCMDCode := nSC_CHECKRANGEMONCOUNT;
      goto L001;
    end;
    if sCmd = sSC_ISONMAP then begin//����ͼ����  20080426
      nCMDCode := nSC_ISONMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMADDVALUE then begin
      nCMDCode := nSC_CHECKITEMADDVALUE;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMADDVALUEEX then begin
      nCMDCode := nSC_CHECKITEMADDVALUEEX;
      goto L001;
    end;
    if sCmd = sSC_CHECKINMAPRANGE then begin
      nCMDCode := nSC_CHECKINMAPRANGE;
      goto L001;
    end;
    if sCmd = sSC_CASTLECHANGEDAY then begin
      nCMDCode := nSC_CASTLECHANGEDAY;
      goto L001;
    end;
    if sCmd = sSC_CASTLEWARDAY then begin
      nCMDCode := nSC_CASTLEWARDAY;
      goto L001;
    end;
    if sCmd = sSC_ONLINELONGMIN then begin
      nCMDCode := nSC_ONLINELONGMIN;
      goto L001;
    end;
    if sCmd = sSC_CHECKGUILDCHIEFITEMCOUNT then begin
      nCMDCode := nSC_CHECKGUILDCHIEFITEMCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMEDATELIST then begin
      nCMDCode := nSC_CHECKNAMEDATELIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPHUMANCOUNT then begin
      nCMDCode := nSC_CHECKMAPHUMANCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPHUMAICOUNT then begin
      nCMDCode := nSC_CHECKMAPHUMAICOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPMONCOUNT then begin
      nCMDCode := nSC_CHECKMAPMONCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKVAR then begin
      nCMDCode := nSC_CHECKVAR;
      goto L001;
    end;
    if sCmd = sSC_CHECKSERVERNAME then begin
      nCMDCode := nSC_CHECKSERVERNAME;
      goto L001;
    end;
    if sCmd = sSC_ISATTACKGUILD then begin
      nCMDCode := nSC_ISATTACKGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISDEFENSEGUILD then begin
      nCMDCode := nSC_ISDEFENSEGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISATTACKALLYGUILD then begin
      nCMDCode := nSC_ISATTACKALLYGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISDEFENSEALLYGUILD then begin
      nCMDCode := nSC_ISDEFENSEALLYGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISCASTLEGUILD then begin
      nCMDCode := nSC_ISCASTLEGUILD;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEDOOR then begin
      nCMDCode := nSC_CHECKCASTLEDOOR;
      goto L001;
    end;
    if sCmd = sSC_ISSYSOP then begin
      nCMDCode := nSC_ISSYSOP;
      goto L001;
    end;
    if sCmd = sSC_ISADMIN then begin
      nCMDCode := nSC_ISADMIN;
      goto L001;
    end;
    if sCmd = sSC_CHECKGROUPCOUNT then begin//����������
      nCMDCode := nSC_CHECKGROUPCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKGROUPJOB then begin//�������Ƿ����ָ��ְҵ 20100915
      nCMDCode := nSC_CHECKGROUPJOB;
      goto L001;
    end;
    if sCmd = sSC_CHECKGROUPMAP then begin//�������Ƿ���ͬ����ͼ
      nCMDCode := nSC_CHECKGROUPMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKGROUPFLAG then begin//���������г�Ա�������� 20100915
      nCMDCode := nSC_CHECKGROUPFLAG;
      goto L001;
    end;
    if sCmd = sSC_CHECKSELFSORT then begin//���������ָ�����а��е����� 20110113
      nCMDCode := nSC_CHECKSELFSORT;
      goto L001;
    end;
    if sCmd = sSC_CHECKHITMONNAME then begin//������﹥��Ŀ������� 20110114
      nCMDCode := nSC_CHECKHITMONNAME;
      goto L001;
    end;
    if sCmd = sCHECKACCOUNTLIST then begin
      nCMDCode := nCHECKACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sCHECKIPLIST then begin
      nCMDCode := nCHECKIPLIST;
      goto L001;
    end;
    if sCmd = sCHECKBBCOUNT then begin
      nCMDCode := nCHECKBBCOUNT;
      goto L001;
    end;
    if sCmd = sDAYTIME then begin
      nCMDCode := nDAYTIME;
      goto L001;
    end;
    if sCmd = sCHECKITEMW then begin
      nCMDCode := nCHECKITEMW;
      goto L001;
    end;
    if sCmd = sISTAKEITEM then begin
      nCMDCode := nISTAKEITEM;
      goto L001;
    end;
    if sCmd = sCHECKDURA then begin
      nCMDCode := nCHECKDURA;
      goto L001;
    end;
    if sCmd = sCHECKDURAEVA then begin
      nCMDCode := nCHECKDURAEVA;
      goto L001;
    end;
    if sCmd = sDAYOFWEEK then begin
      nCMDCode := nDAYOFWEEK;
      goto L001;
    end;
    if sCmd = sHOUR then begin
      nCMDCode := nHOUR;
      goto L001;
    end;
    if sCmd = sMIN then begin
      nCMDCode := nMIN;
      goto L001;
    end;
    if sCmd = sCHECKLUCKYPOINT then begin
      nCMDCode := nCHECKLUCKYPOINT;
      goto L001;
    end;
    if sCmd = sCHECKMONMAP then begin
      nCMDCode := nCHECKMONMAP;
      goto L001;
    end;
    if sCmd = sCHECKHUM then begin
      nCMDCode := nCHECKHUM;
      goto L001;
    end;
    if sCmd = sEQUAL then begin
      nCMDCode := nEQUAL;
      goto L001;
    end;
    if sCmd = sLARGE then begin
      nCMDCode := nLARGE;
      goto L001;
    end;
    if sCmd = sSMALL then begin
      nCMDCode := nSMALL;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEDIR then begin
      nCMDCode := nSC_CHECKPOSEDIR;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSELEVEL then begin
      nCMDCode := nSC_CHECKPOSELEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEGENDER then begin
      nCMDCode := nSC_CHECKPOSEGENDER;
      goto L001;
    end;
    if sCmd = sSC_ISAI then begin
      nCMDCode := nSC_ISAI;
      goto L001;
    end;    
    {$IF M2Version <> 2}
    if sCmd = sSC_ISDIVISIONMASTER then begin//�������Ƿ�Ϊ��������
      nCMDCode := nSC_ISDIVISIONMASTER;
      goto L001;
    end;
    if sCmd = sSC_ISDIVISIONHEART then begin//�������Ƿ�Ϊ���ɵ���
      nCMDCode := nSC_ISDIVISIONHEART;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEARTEXP then begin//����ۻ������Ƿ�ﵽ�ķ�����ֵ
      nCMDCode := nSC_CHECKHEARTEXP;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEHEARTSKILL then begin//����Ƿ�ѧ���ķ�
      nCMDCode := nSC_CHECKHEHEARTSKILL;
      goto L001;
    end;
    if sCmd = sSC_CHECKDIVISIONPOINT then begin//�����������ֵ
      nCMDCode := nSC_CHECKDIVISIONPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKFENGHAO then begin//�ж�����Ƿ���ָ���ĳƺ�
      nCMDCode := nSC_CHECKFENGHAO;
      goto L001;
    end;
    if sCmd = sSC_CHECKFENGHAOCOUNT then begin//���������гƺŵ�����
      nCMDCode := nSC_CHECKFENGHAOCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKFENGHAOLISTCOUNT then begin//�����һ���ʹ�߻���������������
      nCMDCode := nSC_CHECKFENGHAOLISTCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKGUILDSTARDAY then begin
      nCMDCode := nSC_CHECKGUILDSTARDAY;
      goto L001;
    end;    
    {$IFEND}
    if sCmd = sSC_CHECKLEVELEX then begin
      nCMDCode := nSC_CHECKLEVELEX;
      goto L001;
    end;
    if sCmd = sSC_CHECKBONUSPOINT then begin
      nCMDCode := nSC_CHECKBONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMARRY then begin
      nCMDCode := nSC_CHECKMARRY;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEMARRY then begin
      nCMDCode := nSC_CHECKPOSEMARRY;
      goto L001;
    end;
    if sCmd = sSC_CHECKMARRYCOUNT then begin
      nCMDCode := nSC_CHECKMARRYCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMASTER then begin
      nCMDCode := nSC_CHECKMASTER;
      goto L001;
    end;
    if sCmd = sSC_HAVEMASTER then begin
      nCMDCode := nSC_HAVEMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEMASTER then begin
      nCMDCode := nSC_CHECKPOSEMASTER;
      goto L001;
    end;
    if sCmd = sSC_POSEHAVEMASTER then begin
      nCMDCode := nSC_POSEHAVEMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKISMASTER then begin
      nCMDCode := nSC_CHECKISMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEISMASTER then begin
      nCMDCode := nSC_CHECKPOSEISMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMEIPLIST then begin
      nCMDCode := nSC_CHECKNAMEIPLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKACCOUNTIPLIST then begin
      nCMDCode := nSC_CHECKACCOUNTIPLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVECOUNT then begin
      nCMDCode := nSC_CHECKSLAVECOUNT;
      goto L001;
    end;
    if sCmd = sCHECKMAPNAME then begin
      nCMDCode := nCHECKMAPNAME;
      goto L001;
    end;
    if sCmd = sINSAFEZONE then begin
      nCMDCode := nINSAFEZONE;
      goto L001;
    end;
    if sCmd = sCHECKSKILL then begin
      nCMDCode := nCHECKSKILL;
      goto L001;
    end;
    if sCmd = sHEROCHECKSKILL then begin //���Ӣ�ۼ��� 20080423
      nCMDCode := nHEROCHECKSKILL;
      goto L001;
    end;
    if sCmd = sSC_CHECKUSERDATE then begin
      nCMDCode := nSC_CHECKUSERDATE;
      goto L001;
    end;
    if sCmd = sSC_CHECKCONTAINSTEXT then begin
      nCMDCode := nSC_CHECKCONTAINSTEXT;
      goto L001;
    end;
    if sCmd = sSC_COMPARETEXT then begin
      nCMDCode := nSC_COMPARETEXT;
      goto L001;
    end;
    if sCmd = sSC_CHECKTEXTLIST then begin
      nCMDCode := nSC_CHECKTEXTLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKCONTAINSTEXTLIST then begin
      nCMDCode := nSC_CHECKCONTAINSTEXTLIST;
      goto L001;
    end;
    if sCmd = sSC_ISGROUPMASTER then begin
      nCMDCode := nSC_ISGROUPMASTER;
      goto L001;
    end;
    if sCmd = sSC_ISOPENBOX then begin
      nCMDCode := nSC_ISOPENBOX;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEARMSGCOLOR then begin
      nCMDCode := nSC_CHECKHEARMSGCOLOR;
      goto L001;
    end;
    if sCmd = sSC_MAPHUMISSAMEGUILD then begin//��⵱ǰ��ͼ�е������Ƿ�����ͬһ���л� 20090307
      nCMDCode := nSC_MAPHUMISSAMEGUILD;
      goto L001;
    end;    
    if sCmd = sSC_CHECKONLINE then begin
      nCMDCode := nSC_CHECKONLINE;
      goto L001;
    end;
    if sCmd = sSC_ISDUPMODE then begin
      nCMDCode := nSC_ISDUPMODE;
      goto L001;
    end;
    if sCmd = sSC_ISOFFLINEMODE then begin
      nCMDCode := nSC_ISOFFLINEMODE;
      goto L001;
    end;
    if sCmd = sSC_CHECKSTATIONTIME then begin
      nCMDCode := nSC_CHECKSTATIONTIME;
      goto L001;
    end;
    if sCmd = sSC_CHECKSIGNMAP then begin
      nCMDCode := nSC_CHECKSIGNMAP;
      goto L001;
    end;
    if sCmd = sSC_HAVEHERO then begin
      nCMDCode := nSC_HAVEHERO;
      goto L001;
    end;
    if sCmd = sSC_CHECKDEPUTYHERO then begin
      nCMDCode := nSC_CHECKDEPUTYHERO;
      goto L001;
    end;
    if sCmd = sSC_CHECKASSESSMENTHERO then begin
      nCMDCode := nSC_CHECKASSESSMENTHERO;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROAUTOPRACTICE then begin
      nCMDCode := nSC_CHECKHEROAUTOPRACTICE;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROONLINE then begin
      nCMDCode := nSC_CHECKHEROONLINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROLEVEL then begin
      nCMDCode := nSC_CHECKHEROLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKITMECOUNTDURA then begin //�����Ʒ�����Լ��־�ֵ 20090913
      nCMDCode := nSC_CHECKITMECOUNTDURA;
      goto L001;
    end;
    if sCmd = sSC_CHECKMINE then begin //���󴿶�  20080324
      nCMDCode := nSC_CHECKMINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAKEWINE then begin //���Ƶ����� 20080806
      nCMDCode := nSC_CHECKMAKEWINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMLEVEL then begin //���װ���������� 20080816
      nCMDCode := nSC_CHECKITEMLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKBAGITEMLEVEL then begin //��������װ����������
      nCMDCode := nSC_CHECKBAGITEMLEVEL;
      goto L001;
    end;
//------------------------�������-----------------------------------
    if sCmd = sSC_CHECKONLINEPLAYCOUNT then begin //20080807
      nCMDCode := nSC_CHECKONLINEPLAYCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKPLAYDIELVL then begin //20080807
      nCMDCode := nSC_CHECKPLAYDIELVL;
      goto L001;
    end;
    if sCmd = sSC_CHECKPLAYDIEJOB then begin //20080807
      nCMDCode := nSC_CHECKPLAYDIEJOB;
      goto L001;
    end;
    if sCmd = sSC_CHECKPLAYDIESEX then begin //20080807
      nCMDCode := nSC_CHECKPLAYDIESEX;
      goto L001;
    end;
    if sCmd = sSC_CHECKKILLPLAYLVL then begin //20080807
      nCMDCode := nSC_CHECKKILLPLAYLVL;
      goto L001;
    end;
    if sCmd = sSC_CHECKKILLPLAYJOB then begin //20080807
      nCMDCode := nSC_CHECKKILLPLAYJOB;
      goto L001;
    end;
    if sCmd = sSC_CHECKKILLPLAYSEX then begin //20080807
      nCMDCode := nSC_CHECKKILLPLAYSEX;
      goto L001;
    end;
//------------------------------------------------------------------
    if sCmd = sSC_CHECKHEROPKPOINT then begin //���Ӣ��PKֵ  20080304
      nCMDCode := nSC_CHECKHEROPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKCODELIST then begin //����ļ���ı���  20080410
      nCMDCode := nSC_CHECKCODELIST;
      goto L001;
    end;
    if sCmd = sCHECKITEMSTATE then begin //���װ����״̬ 20080312
      nCMDCode := nCHECKITEMSTATE;
      goto L001;
    end;
    if sCmd = sCHECKITEMSNAME then begin //���ָ��װ��λ����Ʒ���� 20080825
      nCMDCode := nCHECKITEMSNAME;
      goto L001;
    end;
    if sCmd = sCHECKGUILDMEMBERCOUNT then begin//����л��Ա���� 20090115
      nCMDCode := nCHECKGUILDMEMBERCOUNT;
      goto L001;
    end;
    if sCmd = sCHECKGUILDCOUNT then begin//����л��Ա���� 20090607
      nCMDCode := nCHECKGUILDCOUNT;
      goto L001;
    end;
    if sCmd = sCHECKGUILDFOUNTAINVALUE then begin//����л��Ȫ�� 20081017
      nCMDCode := nCHECKGUILDFOUNTAINVALUE;
      goto L001;
    end;
    if sCmd = sCHECKNGLEVEL then begin//����ɫ�ڹ��ȼ� 20081223
      nCMDCode := nCHECKNGLEVEL;
      goto L001;
    end;
    if sCmd = sKILLBYHUM then begin //����Ƿ�������ɱ 20080826
      nCMDCode := nKILLBYHUM;
      goto L001;
    end;
    if sCmd = sISHIGH then begin //����������������������� 20080313
      nCMDCode := nISHIGH;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROJOB then begin
      nCMDCode := nSC_CHECKHEROJOB;
      goto L001;
    end;
    if sCmd = sSC_CHANGREADNG then begin//����ɫ�Ƿ�ѧ���ڹ� 20081002
      nCMDCode := nSC_CHANGREADNG;
      goto L001;
    end;
    //Add By TasNat at: 2012-04-23 17:27:07
    if sCmd = sSC_CHECKRANGEMONEX then begin//��ⷶΧ��ָ������
      nCMDCode := nSC_CHECKRANGEMONEX;
      goto L001;
    end;
    if sCmd = sSC_ISINGROUP then begin//���������Ƿ��д˳�Ա
      nCMDCode := nSC_ISINGROUP;
      goto L001;
    end;
    if sCmd = sSC_CHECKBAGITEMS then begin//��ⱳ���Ƿ���ĳЩ��Ʒ
      nCMDCode := nSC_CHECKBAGITEMS;
      goto L001;
    end;
    //AddEnd
   { if nCMDCode <= 0 then begin //20080813 ע��
      if Assigned(zPlugOfEngine.QuestConditionScriptCmd) then begin
        nCMDCode := zPlugOfEngine.QuestConditionScriptCmd(PChar(sCmd));
        goto L001;
      end;
    end; }

    L001:
    if nCMDCode > 0 then begin
      QuestConditionInfo.nCMDCode := nCMDCode;
      if (sParam1 <> '') and (sParam1[1] = '"') then ArrestStringEx(sParam1, '"', '"', sParam1);
      if (sParam2 <> '') and (sParam2[1] = '"') then ArrestStringEx(sParam2, '"', '"', sParam2);
      if (sParam3 <> '') and (sParam3[1] = '"') then ArrestStringEx(sParam3, '"', '"', sParam3);
      if (sParam4 <> '') and (sParam4[1] = '"') then ArrestStringEx(sParam4, '"', '"', sParam4);
      if (sParam5 <> '') and (sParam5[1] = '"') then ArrestStringEx(sParam5, '"', '"', sParam5);
      if (sParam6 <> '') and (sParam6[1] = '"') then ArrestStringEx(sParam6, '"', '"', sParam6);
      if (sParam7 <> '') and (sParam7[1] = '"') then ArrestStringEx(sParam7, '"', '"', sParam7);
      if (sParam8 <> '') and (sParam8[1] = '"') then ArrestStringEx(sParam8, '"', '"', sParam8);
      QuestConditionInfo.sParam1 := sParam1;
      QuestConditionInfo.sParam2 := sParam2;
      QuestConditionInfo.sParam3 := sParam3;
      QuestConditionInfo.sParam4 := sParam4;
      QuestConditionInfo.sParam5 := sParam5;
      QuestConditionInfo.sParam6 := sParam6;
      QuestConditionInfo.sParam7 := sParam7;
      QuestConditionInfo.sParam8 := sParam8;
      if IsStringNumber(sParam1) then QuestConditionInfo.nParam1 := Str_ToInt(sParam1, 0);
      if IsStringNumber(sParam2) then QuestConditionInfo.nParam2 := Str_ToInt(sParam2, 0);
      if IsStringNumber(sParam3) then QuestConditionInfo.nParam3 := Str_ToInt(sParam3, 0);
      if IsStringNumber(sParam4) then QuestConditionInfo.nParam4 := Str_ToInt(sParam4, 0);
      if IsStringNumber(sParam5) then QuestConditionInfo.nParam5 := Str_ToInt(sParam5, 0);
      if IsStringNumber(sParam6) then QuestConditionInfo.nParam6 := Str_ToInt(sParam6, 0);
      if IsStringNumber(sParam7) then QuestConditionInfo.nParam7 := Str_ToInt(sParam7, 0);
      if IsStringNumber(sParam8) then QuestConditionInfo.nParam8 := Str_ToInt(sParam8, 0);
      Result := True;
    end;
  end;

  function QuestAction(sText: string; var QuestActionInfo: pTQuestActionInfo): Boolean;
  var
    sCmd, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6 ,sParam7 ,sParam8: string;
    nCMDCode: Integer;
  label L001;
  begin
    Result := False;
    sText := GetValidStrCap(sText, sCmd, [' ', #9]);
    sText := GetValidStrCap(sText, sParam1, [' ', #9]);
    sText := GetValidStrCap(sText, sParam2, [' ', #9]);
    sText := GetValidStrCap(sText, sParam3, [' ', #9]);
    sText := GetValidStrCap(sText, sParam4, [' ', #9]);
    sText := GetValidStrCap(sText, sParam5, [' ', #9]);
    sText := GetValidStrCap(sText, sParam6, [' ', #9]);
    sText := GetValidStrCap(sText, sParam7, [' ', #9]);
    sText := GetValidStrCap(sText, sParam8, [' ', #9]);
    sCmd := UpperCase(sCmd);
    sCmd := QuestActionInfo.Script.Cmd(sCmd);//��չNPC���� 20090926
    nCMDCode := 0;
    if sCmd = sSET then begin
      nCMDCode := nSET;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
    end;

    if sCmd = sRESET then begin
      nCMDCode := nRESET;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
    end;
    if sCmd = sSETOPEN then begin
      nCMDCode := nSETOPEN;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
    end;
    if sCmd = sSETUNIT then begin
      nCMDCode := nSETUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
    end;
    if sCmd = sRESETUNIT then begin
      nCMDCode := nRESETUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then nCMDCode := 0;
      if not IsStringNumber(sParam2) then nCMDCode := 0;
    end; 
    if sCmd = sTAKE then begin
      nCMDCode := nTAKE;
      goto L001;
    end;
    if sCmd = sSC_GIVE then begin
      nCMDCode := nSC_GIVE;
      goto L001;
    end;
    if sCmd = sCLOSE then begin
      nCMDCode := nCLOSE;
      goto L001;
    end;
    if sCmd = sBREAK then begin
      nCMDCode := nBREAK;
      goto L001;
    end;
    if sCmd = sGOTO then begin
      nCMDCode := nGOTO;
      goto L001;
    end;
    if sCmd = sADDNAMELIST then begin
      nCMDCode := nADDNAMELIST;
      goto L001;
    end;
    if sCmd = sDELNAMELIST then begin
      nCMDCode := nDELNAMELIST;
      goto L001;
    end;
    if sCmd = sADDGUILDLIST then begin
      nCMDCode := nADDGUILDLIST;
      goto L001;
    end;
    if sCmd = sDELGUILDLIST then begin
      nCMDCode := nDELGUILDLIST;
      goto L001;
    end;
    if sCmd = sADDACCOUNTLIST then begin
      nCMDCode := nADDACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sDELACCOUNTLIST then begin
      nCMDCode := nDELACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sADDIPLIST then begin
      nCMDCode := nADDIPLIST;
      goto L001;
    end;
    if sCmd = sDELIPLIST then begin
      nCMDCode := nDELIPLIST;
      goto L001;
    end;
    if sCmd = sSENDMSG then begin
      nCMDCode := nSENDMSG;
      goto L001;
    end;
    if sCmd = sCREATEFILE then begin//�����ı��ļ� 20081226
      nCMDCode := nCREATEFILE;
      goto L001;
    end;
    if sCmd = sDELETEFILE then begin//ɾ��ָ���ļ�
      nCMDCode := nDELETEFILE;
      goto L001;
    end;
    if sCmd = sSENDTOPMSG then begin //���˹�������
      nCMDCode := nSENDTOPMSG;
      goto L001;
    end;
    if sCmd = sSENDCENTERMSG then begin //��Ļ������ʾ����
      nCMDCode := nSENDCENTERMSG;
      goto L001;
    end;
    if sCmd = sSENDEDITTOPMSG then begin //����򶥶˹���
      nCMDCode := nSENDEDITTOPMSG;
      goto L001;
    end;
    if sCmd = sOPENBOOKS then begin //�������� 20080119
      nCMDCode := nOPENBOOKS;
      goto L001;
    end;
    if sCmd = sOPENYBDEAL then begin //��ͨԪ������ 20080316
      nCMDCode := nOPENYBDEAL;
      goto L001;
    end;
    if sCmd = sQUERYYBSELL then begin //��ѯ����Ԫ�����۳��۵���Ʒ20080317
      nCMDCode := nQUERYYBSELL;
      goto L001;
    end;
    if sCmd = sQUERYYBDEAL then begin //��ѯ���ԵĹ�����Ʒ 20080317
      nCMDCode := nQUERYYBDEAL;
      goto L001;
    end;
    if sCmd = sTHROUGHHUM then begin //�ı䴩��ģʽ 20080221
      nCMDCode := nTHROUGHHUM;
      goto L001;
    end;
    if sCmd = sSetOnTimer then begin//���˶�ʱ��(����) 20080510
      nCMDCode := nSetOnTimer;
      goto L001;
    end;
    if sCmd = sSetOffTimer then begin//ֹͣ��ʱ�� 20080510
      nCMDCode := nSetOffTimer;
      goto L001;
    end;
    if sCmd = sGETSORTNAME then begin//ȡָ�����а�ָ��������������� 20080531
      nCMDCode := nGETSORTNAME;
      goto L001;
    end;
    if sCmd = sWEBBROWSER then begin//����ָ����վ��ַ 20080602
      nCMDCode := nWEBBROWSER;
      goto L001;
    end;
    if sCmd = sPALYVIDEO then begin//����ָ������Ƶ�ļ� 20100929
      nCMDCode := nPALYVIDEO;
      goto L001;
    end;
    if sCmd = sADDATTACKSABUKALL then begin//���������лṥ�� 20080609
      nCMDCode := nADDATTACKSABUKALL;
      goto L001;
    end;
    if sCmd = sKICKALLPLAY then begin//�߳��������������� 20080609
      nCMDCode := nKICKALLPLAY;
      goto L001;
    end;
    if sCmd = sREPAIRALL then begin//����ȫ��װ�� 20080613
      nCMDCode := nREPAIRALL;
      goto L001;
    end;
    if sCmd = sAUTOGOTOXY then begin//�Զ�Ѱ· 20080617
      nCMDCode := nAUTOGOTOXY;
      goto L001;
    end;
    if sCmd = sCHANGESKILL then begin//�޸�ħ��ID
      nCMDCode := nCHANGESKILL;
      goto L001;
    end;
    if sCmd = sCHANGESKILLEX then begin//ת��ħ��ID
      nCMDCode := nCHANGESKILLEX;
      goto L001;
    end;
    if sCmd = sCHANGEPETSMONHAPP then begin//�����������Ŀ��ֶ�
      nCMDCode := nCHANGEPETSMONHAPP;
      goto L001;
    end;
    if sCmd = sPETSMONHAPPLOG then begin//�򿪳���ι����־
      nCMDCode := nPETSMONHAPPLOG;
      goto L001;
    end;
    if sCmd = sOPENMAKEWINE then begin//����ƴ��� 20080619
      nCMDCode := nOPENMAKEWINE;
      goto L001;
    end;
    if sCmd = sGETGOODMAKEWINE then begin//ȡ����õľ� 20080620
      nCMDCode := nGETGOODMAKEWINE;
      goto L001;
    end;
    if sCmd = sDECMAKEWINETIME then begin//������Ƶ�ʱ�� 20080620
      nCMDCode := nDECMAKEWINETIME;
      goto L001;
    end;
    if sCmd = sSORTHUMVARTOFILE then begin//�����Զ����������      
      nCMDCode := nSORTHUMVARTOFILE;
      goto L001;
    end;
    {$IF M2Version <> 2}
    if sCmd = sGIVEFENGHAO then begin//����ƺ�
      nCMDCode := nGIVEFENGHAO;
      goto L001;
    end;
    if sCmd = sRECYCFENGHAO then begin//���ճƺ�
      nCMDCode := nRECYCFENGHAO;
      goto L001;
    end;
    if sCmd = sCHANGEFENGHAOTIME then begin//�����ƺ�ʱ��
      nCMDCode := nCHANGEFENGHAOTIME;
      goto L001;
    end;
    if sCmd = sGIVEFENGHAOAGREE then begin//���óƺŷ���ȷ����Ϣ 20110313
      nCMDCode := nGIVEFENGHAOAGREE;
      goto L001;
    end;
    if sCmd = sREADSKILLNG then begin//ѧϰ�ڹ� 20081002
      nCMDCode := nREADSKILLNG;
      goto L001;
    end;
    if sCmd = sSC_CLEARNGSKILL then begin//�������������ڹ����� 20090428
      nCMDCode := nSC_CLEARNGSKILL;
      goto L001;
    end;
    if sCmd = sSC_CHANGENGEXP then begin//������ɫ�ڹ����� 20081002
      nCMDCode := nSC_CHANGENGEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGENGLEVEL then begin//������ɫ�ڹ��ȼ� 20081004
      nCMDCode := nSC_CHANGENGLEVEL;
      goto L001;
    end;
    if sCmd = sSC_OPENEXPCRYSTAL then begin//�ͻ�����ʾ��ؽᾧ 20090131
      nCMDCode := nSC_OPENEXPCRYSTAL;
      goto L001;
    end;
    if sCmd = sSC_CLOSEEXPCRYSTAL then begin//�ͻ��˹ر���ؽᾧͼ�� 20090131
      nCMDCode := nSC_CLOSEEXPCRYSTAL;
      goto L001;
    end;
    if sCmd = sSC_GETEXPTOCRYSTAL then begin//ȡ����ؽᾧ�еľ���(ֻ��ȡ����ȡ�ľ���) 20090202
      nCMDCode := nSC_GETEXPTOCRYSTAL;
      goto L001;
    end;         
{$IFEND}
    if sCmd = sMAKEWINENPCMOVE then begin//���NPC���߶� 20080621
      nCMDCode := nMAKEWINENPCMOVE;
      goto L001;
    end;
    if sCmd = sFOUNTAIN then begin//����Ȫˮ�緢 20080624
      nCMDCode := nFOUNTAIN;
      goto L001;
    end;
    if sCmd = sSETGUILDFOUNTAIN then begin//����/�ر��л�Ȫˮ�ֿ� 20080625
      nCMDCode := nSETGUILDFOUNTAIN;
      goto L001;
    end;
    if sCmd = sGIVEGUILDFOUNTAIN then begin//��ȡ�л��ˮ 20080625
      nCMDCode := nGIVEGUILDFOUNTAIN;
      goto L001;
    end;
    if sCmd = sCHALLENGMAPMOVE then begin//��ս��ͼ�ƶ� 20080705
      nCMDCode := nCHALLENGMAPMOVE;
      goto L001;
    end;
    if sCmd = sGETCHALLENGEBAKITEM then begin//û����ս��ͼ���ƶ�,���˻ص�Ѻ����Ʒ 20080705
      nCMDCode := nGETCHALLENGEBAKITEM;
      goto L001;
    end;
    if sCmd = sHEROLOGOUT then begin//Ӣ������ 20080716
      nCMDCode := nHEROLOGOUT;
      goto L001;
    end;
    if sCmd = sSC_RECALLHERO then begin//�ٻ�Ӣ��
      nCMDCode := nSC_RECALLHERO;
      goto L001;
    end;
    if sCmd = sSETITEMSLIGHT then begin //װ���������� 20080223
      nCMDCode := nSETITEMSLIGHT;
      goto L001;
    end;
    {$IF M2Version <> 2}
    if sCmd = sQUERYREFINEITEM then begin //�򿪴������� 20080503
      nCMDCode := nQUERYREFINEITEM;
      goto L001;
    end;
    {$IFEND}
    if sCmd = sOpenRefineArmyDrum then begin //�򿪴������ĵĴ���
      nCMDCode := nOpenRefineArmyDrum;
      goto L001;
    end;
    if sCmd = sOpenDragonBox then begin //���������� 20080502
      nCMDCode := nOpenDragonBox;
      goto L001;
    end;
    if sCmd = sGOHOME then begin //�ƶ����سǵ� 20080503
      nCMDCode := nGOHOME;
      goto L001;
    end;
    if sCmd = sTHROWITEM then begin //��ָ����Ʒˢ�µ�ָ����ͼ���귶Χ�� 20080508
      nCMDCode := nTHROWITEM;
      goto L001;
    end;
    if sCmd = sNPCGIVEITEM then begin //��NPC��Χ�ڱ�����Ʒ 20090425
      nCMDCode := nNPCGIVEITEM;
      goto L001;
    end;
    if sCmd = sOPENHEROAUTOPRACTICE then begin //��Ӣ��������������
      nCMDCode := nOPENHEROAUTOPRACTICE;
      goto L001;
    end;
    if sCmd = sSTOPHEROAUTOPRACTICE then begin //ֹͣӢ����������
      nCMDCode := nSTOPHEROAUTOPRACTICE;
      goto L001;
    end;
    if sCmd = sCLEARCODELIST then begin //ɾ��ָ���ı���ı��� 20080410
      nCMDCode := nCLEARCODELIST;
      goto L001;
    end;
    if sCmd = sGetRandomName then begin //���ȡ�ļ����� 20080126
      nCMDCode := nGetRandomName;
      goto L001;
    end;
    if sCmd = sHCall then begin //ͨ���ű������ñ���ִ��QManage.txt�еĽű� 20080422
      nCMDCode := nHCall;
      goto L001;
    end;
    if sCmd = sINCASTLEWARAY then begin //��������Ƿ��ڹ����ڼ�ķ�Χ�ڣ�����BB�ѱ� 20080422
      nCMDCode := nINCASTLEWARAY;
      goto L001;
    end;
    if sCmd = sGIVESTATEITEM then begin //�������״̬װ�� 20080312
      nCMDCode := nGIVESTATEITEM;
      goto L001;
    end;
    if sCmd = sSETITEMSTATE then begin //����װ����״̬ 20080312
      nCMDCode := nSETITEMSTATE;
      goto L001;
    end;
    if sCmd = sPKPOINT then begin
      nCMDCode := nPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_RECALLMOB then begin
      nCMDCode := nSC_RECALLMOB;
      goto L001;
    end;
    if sCmd = sSC_RECALLMOBEX then begin //�����ٳ��ı������� 20080122
      nCMDCode := nSC_RECALLMOBEX;
      goto L001;
    end;
    if sCmd = sSC_MOVEMOBTO then begin //��ָ������Ĺ����ƶ��������� 20080123
      nCMDCode := nSC_MOVEMOBTO;
      goto L001;
    end;
    if sCmd = sSC_CLEARITEMMAP then begin //�����ͼ��Ʒ 20080124
      nCMDCode := nSC_CLEARITEMMAP;
      goto L001;
    end;
    if sCmd = sKICK then begin
      nCMDCode := nKICK;
      goto L001;
    end;
    if sCmd = sTAKEW then begin
      nCMDCode := nTAKEW;
      goto L001;
    end;
    if sCmd = sTIMERECALL then begin
      nCMDCode := nTIMERECALL;
      goto L001;
    end;
    if sCmd = sSC_PARAM1 then begin
      nCMDCode := nSC_PARAM1;
      goto L001;
    end;
    if sCmd = sSC_PARAM2 then begin
      nCMDCode := nSC_PARAM2;
      goto L001;
    end;
    if sCmd = sSC_PARAM3 then begin
      nCMDCode := nSC_PARAM3;
      goto L001;
    end;
    if sCmd = sSC_PARAM4 then begin
      nCMDCode := nSC_PARAM4;
      goto L001;
    end;
    if sCmd = sSC_EXEACTION then begin
      nCMDCode := nSC_EXEACTION;
      goto L001;
    end;
    if sCmd = sMAPMOVE then begin
      nCMDCode := nMAPMOVE;
      goto L001;
    end;
    if sCmd = sMAP then begin
      nCMDCode := nMAP;
      goto L001;
    end;
    if sCmd = sTAKECHECKITEM then begin
      nCMDCode := nTAKECHECKITEM;
      goto L001;
    end;
    if sCmd = sMONGEN then begin
      nCMDCode := nMONGEN;
      goto L001;
    end;
    if sCmd = sMONCLEAR then begin
      nCMDCode := nMONCLEAR;
      goto L001;
    end;
    if sCmd = sMOV then begin
      nCMDCode := nMOV;
      goto L001;
    end;
    if sCmd = sINC then begin
      nCMDCode := nINC;
      goto L001;
    end;
    if sCmd = sDEC then begin
      nCMDCode := nDEC;
      goto L001;
    end;
    if sCmd = sSUM then begin
      nCMDCode := nSUM;
      goto L001;
    end;
//---------------------��������-----------------------
    if sCmd = sSC_DIV then begin //����
      nCMDCode := nSC_DIV;
      goto L001;
    end;
    if sCmd = sSC_MUL then begin //�˷�
      nCMDCode := nSC_MUL;
      goto L001;
    end;
    if sCmd = sSC_PERCENT then begin //�ٷֱ�
      nCMDCode := nSC_PERCENT;
      goto L001;
    end;
//--------------------------------------------------------    
    if sCmd = sBREAKTIMERECALL then begin
      nCMDCode := nBREAKTIMERECALL;
      goto L001;
    end;
    if sCmd = sMOVR then begin
      nCMDCode := nMOVR;
      goto L001;
    end;
    if sCmd = sEXCHANGEMAP then begin
      nCMDCode := nEXCHANGEMAP;
      goto L001;
    end;
    if sCmd = sRECALLMAP then begin
      nCMDCode := nRECALLMAP;
      goto L001;
    end;
    if sCmd = sADDBATCH then begin
      nCMDCode := nADDBATCH;
      goto L001;
    end;
    if sCmd = sBATCHDELAY then begin
      nCMDCode := nBATCHDELAY;
      goto L001;
    end;
    if sCmd = sBATCHMOVE then begin
      nCMDCode := nBATCHMOVE;
      goto L001;
    end;
    if sCmd = sPLAYDICE then begin
      nCMDCode := nPLAYDICE;
      goto L001;
    end;
    if sCmd = sGOQUEST then begin
      nCMDCode := nGOQUEST;
      goto L001;
    end;
    if sCmd = sENDQUEST then begin
      nCMDCode := nENDQUEST;
      goto L001;
    end;
    if sCmd = sSC_HAIRSTYLE then begin
      nCMDCode := nSC_HAIRSTYLE;
      goto L001;
    end;
    if sCmd = sSC_CHANGELEVEL then begin
      nCMDCode := nSC_CHANGELEVEL;
      goto L001;
    end;
    if sCmd = sSC_MARRY then begin
      nCMDCode := nSC_MARRY;
      goto L001;
    end;
    if sCmd = sSC_UNMARRY then begin
      nCMDCode := nSC_UNMARRY;
      goto L001;
    end;
    if sCmd = sSC_GETMARRY then begin
      nCMDCode := nSC_GETMARRY;
      goto L001;
    end;
    if sCmd = sSC_GETMASTER then begin
      nCMDCode := nSC_GETMASTER;
      goto L001;
    end;
    if sCmd = sSC_CLEARSKILL then begin
      nCMDCode := nSC_CLEARSKILL;
      goto L001;
    end;
    if sCmd = sSC_ADDRANDOMMAPGATE then begin//���ӵ�ͼ���� 20090503
      nCMDCode := nSC_ADDRANDOMMAPGATE;
      goto L001;
    end;
    if sCmd = sSC_DELRANDOMMAPGATE then begin//ɾ����ͼ���� 20090503
      nCMDCode := nSC_DELRANDOMMAPGATE;
      goto L001;
    end;
    if sCmd = sSC_MIRRORMAP then begin//���Ӿ����ͼ 20110327
      nCMDCode := nSC_MIRRORMAP;
      goto L001;
    end;
    //Add By TasNat at: 2012
    if sCmd = sSC_UNMIRRORMAP then begin//ɾ�������ͼ
      nCMDCode := nSC_UNMIRRORMAP;
      goto L001;
    end;
    if sCmd = sSC_CLEARMAPITEM then begin//�����ͼ��Ʒ
      nCMDCode := nSC_CLEARMAPITEM;
      goto L001;
    end;
    if sCmd = sSC_BIGMAIN then begin//�ű���̬���ô�Ի���
      nCMDCode := nSC_BIGMAIN;
      goto L001;
    end;
    if sCmd = sSC_IncreaseSkillLevel then begin//����ǿ���ȼ�
      nCMDCode := nSC_IncreaseSkillLevel;
      goto L001;
    end;
    if sCmd = sSC_CLEARBAGITEMS then begin//��������Ʒ
      nCMDCode := nSC_CLEARBAGITEMS;
      goto L001;
    end;
    if sCmd = sSC_Status then begin//��������״̬
      nCMDCode := nSC_Status;
      goto L001;
    end;
    //Add End

    if sCmd = sSC_RELOADCASTLE then begin//��ʼ��ɳ������ 20110411
      nCMDCode := nSC_RELOADCASTLE;
      goto L001;
    end;
    if sCmd = sSC_DELNOJOBSKILL then begin
      nCMDCode := nSC_DELNOJOBSKILL;
      goto L001;
    end;
    if sCmd = sSC_DELSKILL then begin
      nCMDCode := nSC_DELSKILL;
      goto L001;
    end;
    if sCmd = sSC_ADDSKILL then begin
      nCMDCode := nSC_ADDSKILL;
      goto L001;
    end;
    if sCmd = sSC_ADDGUILDMEMBER then begin//����л��Ա//20080427
      nCMDCode := nSC_ADDGUILDMEMBER;
      goto L001;
    end;
    if sCmd = sSC_DELGUILDMEMBER then begin//ɾ���л��Ա��ɾ��������Ч��//20080427
      nCMDCode := nSC_DELGUILDMEMBER;
      goto L001;
    end;
    if sCmd = sSC_SKILLLEVEL then begin
      nCMDCode := nSC_SKILLLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGESKILLLEVELEX then begin//��������ǿ���ȼ�
      nCMDCode := nSC_CHANGESKILLLEVELEX;
      goto L001;
    end;
    if sCmd = sSC_HEROSKILLLEVEL then begin//����Ӣ�ۼ��ܵȼ� 20080415
      nCMDCode := nSC_HEROSKILLLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEPKPOINT then begin
      nCMDCode := nSC_CHANGEPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEEXP then begin//������ɫ����
      nCMDCode := nSC_CHANGEEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGECATTLEGASEXP then begin//��������ţ��ֵ 20090519
      nCMDCode := nSC_CHANGECATTLEGASEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGEITEMDURA then begin//����װ���־� 20110219
      nCMDCode := nSC_CHANGEITEMDURA;
      goto L001;
    end;
    if sCmd = sSC_SENDSHINYMSG then begin//֪ͨ�ͻ���ʹ"�ɳ�����"�������� 20100801
      nCMDCode := nSC_SENDSHINYMSG;
      goto L001;
    end;
    if sCmd = sSC_SENDTIMEMSG then begin//ʱ�䵽����QF��(�ͻ�����ʾ��Ϣ) 20090124
      nCMDCode := nSC_SENDTIMEMSG;
      goto L001;
    end;
    if sCmd = sSC_SENDMSGWINDOWS then begin//ʱ�䵽����QF�� 20090124
      nCMDCode := nSC_SENDMSGWINDOWS;
      goto L001;
    end;
    if sCmd = sSC_CLOSEMSGWINDOWS then begin//�رտͻ���'!'ͼ�����ʾ 20090126
      nCMDCode := nSC_CLOSEMSGWINDOWS;
      goto L001;
    end;
    if sCmd = sSC_GETGROUPCOUNT then begin//ȡ��ӳ�Ա�� 20090125
      nCMDCode := nSC_GETGROUPCOUNT;
      goto L001;
    end;
    if sCmd = sSC_GETMONTHSDAY then begin//ȡ��ǰ�·����� 20110304
      nCMDCode := nSC_GETMONTHSDAY;
      goto L001;
    end;
{$IF M2Version = 1}
    if sCmd = sOPENLIANQI then begin //����������
      nCMDCode := nOPENLIANQI;
      goto L001;
    end;
    if sCmd = sCHANGEJINGYUAN then begin //�������ﾫԪֵ
      nCMDCode := nCHANGEJINGYUAN;
      goto L001;
    end;
    if sCmd = sSC_OPENHEROPULS then begin//��ͨӢ�۾���
      nCMDCode := nSC_OPENHEROPULS;
      goto L001;
    end;
    if sCmd = sSC_OPENPULSE then begin//��ָͨ����Ѩ 20090623
      nCMDCode := nSC_OPENPULSE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEPULSELEVEL then begin//�ı��羭�ȼ� 20090624
      nCMDCode := nSC_CHANGEPULSELEVEL;
      goto L001;
    end;
    if sCmd = sOPEN4BATTERSKILL then begin//�������ĸ��������� 20100720
      nCMDCode := nOPEN4BATTERSKILL;
      goto L001;
    end;
{$IFEND}
    if sCmd = sSC_OPENMAKEKIMNEEDLE then begin//�ͻ�����ʾ�������봰�� 20090615
      nCMDCode := nSC_OPENMAKEKIMNEEDLE;
      goto L001;
    end;
    if sCmd = sSC_TAKEKIMNEEDLE then begin//�ջذ���ָ��������Ʒ 20090615
      nCMDCode := nSC_TAKEKIMNEEDLE;
      goto L001;
    end;
    if sCmd = sSC_GIVEKIMNEEDLE then begin//��ָ���ĵ�����Ʒ 20090615
      nCMDCode := nSC_GIVEKIMNEEDLE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEATTATCKMODE then begin//�ı�����Ĺ���ģʽ
      nCMDCode := nSC_CHANGEATTATCKMODE;
      goto L001;
    end;    
    if sCmd = sSC_OPENCATTLEGAS then begin//�ͻ�����ʾţ����ͼ�� 20090518
      nCMDCode := nSC_OPENCATTLEGAS;
      goto L001;
    end;
    if sCmd = sSC_CLOSECATTLEGAS then begin//�ͻ��˹ر�ţ����ͼ�� 20090518
      nCMDCode := nSC_CLOSECATTLEGAS;
      goto L001;
    end;
    if sCmd = sSC_CHANGEJOB then begin
      nCMDCode := nSC_CHANGEJOB;
      goto L001;
    end;
    if sCmd = sSC_MISSION then begin
      nCMDCode := nSC_MISSION;
      goto L001;
    end;
    if sCmd = sSC_MOBPLACE then begin
      nCMDCode := nSC_MOBPLACE;
      goto L001;
    end;
    if sCmd = sSC_SETMEMBERTYPE then begin
      nCMDCode := nSC_SETMEMBERTYPE;
      goto L001;
    end;
    if sCmd = sSC_SETMEMBERLEVEL then begin
      nCMDCode := nSC_SETMEMBERLEVEL;
      goto L001;
    end;
    if sCmd = sSC_GAMEGOLD then begin //������Ϸ�ҵ�����
      nCMDCode := nSC_GAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_GAMEDIAMOND then begin //�������ʯ���� 20071226
      nCMDCode := nSC_GAMEDIAMOND;
      goto L001;
    end;
    if sCmd = sSC_GAMEGIRD then begin //����������� 20071226
      nCMDCode := nSC_GAMEGIRD;
      goto L001;
    end;
    if sCmd = sSC_GAMEGLORY then begin //��������ֵ 20080511
      nCMDCode := nSC_GAMEGLORY;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROLOYAL then begin //����Ӣ�۵��ҳ϶� 20080109
      nCMDCode := nSC_CHANGEHEROLOYAL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHUMABILITY then begin //������������ 20080609
      nCMDCode := nSC_CHANGEHUMABILITY;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROTRANPOINT then begin //����Ӣ�ۼ����������� 20080512
      nCMDCode := nSC_CHANGEHEROTRANPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGETRANPOINT then begin //����������������
      nCMDCode := nSC_CHANGETRANPOINT;
      goto L001;
    end;
//--------------------�ƹ�ϵͳ------------------------------------------------
    if sCmd = sSC_SAVEHERO then begin //�ķ�Ӣ�� 20080513
      nCMDCode := nSC_SAVEHERO;
      goto L001;
    end;
    if sCmd = sSC_GETHERO then begin //ȡ��Ӣ�� 20080513
      nCMDCode := nSC_GETHERO;
      goto L001;
    end;
    if sCmd = sSC_ASSESSMENTHERO then begin //����Ӣ��
      nCMDCode := nSC_ASSESSMENTHERO;
      goto L001;
    end;
    if sCmd = sSC_CLOSEDRINK then begin //�رն��ƴ��� 20080514
      nCMDCode := nSC_CLOSEDRINK;
      goto L001;
    end;
    if sCmd = sSC_PLAYDRINKMSG then begin //���ƴ���˵����Ϣ 20080514
      nCMDCode := nSC_PLAYDRINKMSG;
      goto L001;
    end;
    if sCmd = sSC_OPENPLAYDRINK then begin //ָ������Ⱦ� 20080514
      nCMDCode := nSC_OPENPLAYDRINK;
      goto L001;
    end;
//----------------------------------------------------------------------------
    if sCmd = sSC_GAMEPOINT then begin
      nCMDCode := nSC_GAMEPOINT;
      goto L001;
    end;
    if sCmd = sSC_PKZONE then begin
      nCMDCode := nSC_PKZONE;
      goto L001;
    end;
    if sCmd = sSC_RESTBONUSPOINT then begin
      nCMDCode := nSC_RESTBONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_TAKECASTLEGOLD then begin
      nCMDCode := nSC_TAKECASTLEGOLD;
      goto L001;
    end;
    if sCmd = sSC_HUMANHP then begin
      nCMDCode := nSC_HUMANHP;
      goto L001;
    end;
    if sCmd = sSC_HUMANMP then begin
      nCMDCode := nSC_HUMANMP;
      goto L001;
    end;
    if sCmd = sSC_BUILDPOINT then begin
      nCMDCode := nSC_BUILDPOINT;
      goto L001;
    end;
    if sCmd = sSC_AURAEPOINT then begin
      nCMDCode := nSC_AURAEPOINT;
      goto L001;
    end;
    if sCmd = sSC_STABILITYPOINT then begin
      nCMDCode := nSC_STABILITYPOINT;
      goto L001;
    end;
    if sCmd = sSC_FLOURISHPOINT then begin
      nCMDCode := nSC_FLOURISHPOINT;
      goto L001;
    end;
    if sCmd = sSC_OPENMAGICBOX then begin
      nCMDCode := nSC_OPENMAGICBOX;
      goto L001;
    end;
    if sCmd = sSC_SETRANKLEVELNAME then begin
      nCMDCode := nSC_SETRANKLEVELNAME;
      goto L001;
    end;
    if sCmd = sSC_GMEXECUTE then begin
      nCMDCode := nSC_GMEXECUTE;
      goto L001;
    end;
    if sCmd = sSC_GUILDCHIEFITEMCOUNT then begin
      nCMDCode := nSC_GUILDCHIEFITEMCOUNT;
      goto L001;
    end;
    if sCmd = sSC_MOBFIREBURN then begin
      nCMDCode := nSC_MOBFIREBURN;
      goto L001;
    end;
    if sCmd = sSC_MESSAGEBOX then begin
      nCMDCode := nSC_MESSAGEBOX;
      goto L001;
    end;
    if sCmd = sSC_SETSCRIPTFLAG then begin
      nCMDCode := nSC_SETSCRIPTFLAG;
      goto L001;
    end;
    if sCmd = sSC_SETAUTOGETEXP then begin
      nCMDCode := nSC_SETAUTOGETEXP;
      goto L001;
    end;
    if sCmd = sSC_VAR then begin
      nCMDCode := nSC_VAR;
      goto L001;
    end;
    if sCmd = sSC_LOADVAR then begin
      nCMDCode := nSC_LOADVAR;
      goto L001;
    end;
    if sCmd = sSC_SAVEVAR then begin
      nCMDCode := nSC_SAVEVAR;
      goto L001;
    end;
    if sCmd = sSC_CALCVAR then begin
      nCMDCode := nSC_CALCVAR;
      goto L001;
    end;
    if sCmd = sSC_AUTOADDGAMEGOLD then begin
      nCMDCode := nSC_AUTOADDGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_AUTOSUBGAMEGOLD then begin
      nCMDCode := nSC_AUTOSUBGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_CLEARNAMELIST then begin
      nCMDCode := nSC_CLEARNAMELIST;
      goto L001;
    end;
    if sCmd = sSC_CHANGENAMECOLOR then begin
      nCMDCode := nSC_CHANGENAMECOLOR;
      goto L001;
    end;
    if sCmd = sSC_CLEARPASSWORD then begin
      nCMDCode := nSC_CLEARPASSWORD;
      goto L001;
    end;
    if sCmd = sSC_RENEWLEVEL then begin
      nCMDCode := nSC_RENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_KILLMONEXPRATE then begin
      nCMDCode := nSC_KILLMONEXPRATE;
      goto L001;
    end;
    if sCmd = sSC_POWERRATE then begin
      nCMDCode := nSC_POWERRATE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEMODE then begin
      nCMDCode := nSC_CHANGEMODE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEMODEEX then begin
      nCMDCode := nSC_CHANGEMODEEX;
      goto L001;
    end;
    if sCmd = sSC_CHANGEPERMISSION then begin
      nCMDCode := nSC_CHANGEPERMISSION;
      goto L001;
    end;
    if sCmd = sSC_KILL then begin
      nCMDCode := nSC_KILL;
      goto L001;
    end;
    if sCmd = sSC_KICK then begin
      nCMDCode := nSC_KICK;
      goto L001;
    end;
    if sCmd = sSC_BONUSPOINT then begin
      nCMDCode := nSC_BONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_RESTRENEWLEVEL then begin
      nCMDCode := nSC_RESTRENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_DELMARRY then begin
      nCMDCode := nSC_DELMARRY;
      goto L001;
    end;
    if sCmd = sSC_DELMASTER then begin
      nCMDCode := nSC_DELMASTER;
      goto L001;
    end;
    if sCmd = sSC_MASTER then begin
      nCMDCode := nSC_MASTER;
      goto L001;
    end;
    if sCmd = sSC_UNMASTER then begin//��ʦ
      nCMDCode := nSC_UNMASTER;
      goto L001;
    end;
    if sCmd = sSC_DELAPPRENTICE then begin//ɾ��ͽ�� 20090208
      nCMDCode := nSC_DELAPPRENTICE;
      goto L001;
    end;
    if sCmd = sSC_HIGHLEVELKILLMONFIXEXP then begin//һ��ʱ���ڸߵȼ�ɱ�־��鲻�� 20090213
      nCMDCode := nSC_HIGHLEVELKILLMONFIXEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGHEARMSGCOLOR then begin//�ı䷢��ʱ������ɫ 20090221
      nCMDCode := nSC_CHANGHEARMSGCOLOR;
      goto L001;
    end;
    if sCmd = sSC_TAKEITMECOUNTDURA then begin//�ջ�ָ��������Ʒ(���������־�) 20090912
      nCMDCode := nSC_TAKEITMECOUNTDURA;
      goto L001;
    end;
    if sCmd = sSC_TAKEMINE then begin//�ջ�ָ�����ƵĿ���(������������) 20090330
      nCMDCode := nSC_TAKEMINE;
      goto L001;
    end;
    if sCmd = sSC_GIVEBAGITEM then begin//��ָ�����Ƶ���Ʒ(�����������������������Ӷ�Ӧ���Ե�)
      nCMDCode := nSC_GIVEBAGITEM;
      goto L001;
    end;
    if sCmd = sSC_TAKEBAGITEM then begin//�ջ�ָ�����Ƶ���Ʒ(����������������)
      nCMDCode := nSC_TAKEBAGITEM;
      goto L001;
    end;
    if sCmd = sSC_TAKEMAKEWINE then begin//�ջ�ָ�����Եľ�(��Ʒ�ʡ��ƾ��ȡ��Ƶȼ�) 20091117
      nCMDCode := nSC_TAKEMAKEWINE;
      goto L001;
    end;
    {$IF M2Version <> 2}
    if sCmd = sSC_QMISSIONGOTO then begin//����QMission-0.txt�ű��� 20100801
      nCMDCode := nSC_QMISSIONGOTO;
      goto L001;
    end;
    if sCmd = sSC_OPENJUDGE then begin//��Ʒ������ 20100830
      nCMDCode := nSC_OPENJUDGE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEPROFICIENCY then begin//���������� 20100914
      nCMDCode := nSC_CHANGEPROFICIENCY;
      goto L001;
    end;
    if sCmd = sSC_ADDDIVISIONMEMBER then begin//���ʦ�ų�Ա
      nCMDCode := nSC_ADDDIVISIONMEMBER;
      goto L001;
    end;
    if sCmd = sSC_DELDIVISIONMEMBER then begin//ɾ��ʦ�ų�Ա��ɾ��������Ч��
      nCMDCode := nSC_DELDIVISIONMEMBER;
      goto L001;
    end;
    if sCmd = sSC_OPENSAVVYHEART then begin//�������ķ�����(ѧϰ�����ķ�-999��)
      nCMDCode := nSC_OPENSAVVYHEART;
      goto L001;
    end;
    if sCmd = sSC_OPENAPPLYDIVISION then begin//������������ɴ���
      nCMDCode := nSC_OPENAPPLYDIVISION;
      goto L001;
    end;
    if sCmd = sSC_SAVVYHEART then begin//��������ʦ���ķ�
      nCMDCode := nSC_SAVVYHEART;
      goto L001;
    end;
    if sCmd = sSC_CHANGEDIVISIONPOINT then begin//������������ֵ
      nCMDCode := nSC_CHANGEDIVISIONPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEARTPOINT then begin//�������Ӵ����ķ�����,'+'ʱͬʱ�ۻ���������ֵ
      nCMDCode := nSC_CHANGEHEARTPOINT;
      goto L001;
    end;
    if sCmd = sSC_INCHEARTPOINT then begin//�����ķ������ķ����飬�������ۻ�����(�����ķ���Ч)
      nCMDCode := nSC_INCHEARTPOINT;
      goto L001;
    end;
    {$IFEND}
    if sCmd = sSC_CREDITPOINT then begin
      nCMDCode := nSC_CREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEGUILDMEMBERCOUNT then begin//�����л��Ա���� 20090115
      nCMDCode := nSC_CHANGEGUILDMEMBERCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEGUILDFOUNTAIN then begin//�����л��Ȫ 20081007
      nCMDCode := nSC_CHANGEGUILDFOUNTAIN;
      goto L001;
    end;
    if sCmd = sSC_TAGMAPINFO then begin//��·��ʯ 20081019
      nCMDCode := nSC_TAGMAPINFO;
      goto L001;
    end;
    if sCmd = sSC_CREATEDIR then begin//����·�� 20090616
      nCMDCode := nSC_CREATEDIR;
      goto L001;
    end;
    if sCmd = sSC_COPYFILETXT then begin//�����ı��ļ� 20090823
      nCMDCode := nSC_COPYFILETXT;
      goto L001;
    end;
    if sCmd = sSC_TAGMAPMOVE then begin//�ƶ�����·��ʯ��¼��XY 20081019
      nCMDCode := nSC_TAGMAPMOVE;
      goto L001;
    end;
    if sCmd = sSC_CLEARNEEDITEMS then begin
      nCMDCode := nSC_CLEARNEEDITEMS;
      goto L001;
    end;
    if sCmd = sSC_CLEARMAKEITEMS then begin
      nCMDCode := nSC_CLEARMAEKITEMS;
      goto L001;
    end;
    if sCmd = sSC_SETSENDMSGFLAG then begin
      nCMDCode := nSC_SETSENDMSGFLAG;
      goto L001;
    end;
    if sCmd = sSC_UPGRADEITEMS then begin
      nCMDCode := nSC_UPGRADEITEMS;
      goto L001;
    end;
    if sCmd = sSC_UPGRADEITEMSEX then begin
      nCMDCode := nSC_UPGRADEITEMSEX;
      goto L001;
    end;
    if sCmd = sSC_GIVEMINE then begin //����ʯ  20080330
      nCMDCode := nSC_GIVEMINE;
      goto L001;
    end;
    if sCmd = sSC_MONGENEX then begin
      nCMDCode := nSC_MONGENEX;
      goto L001;
    end;
    if sCmd = sSC_CLEARMAPMON then begin
      nCMDCode := nSC_CLEARMAPMON;
      goto L001;
    end;
    if sCmd = sSC_MAPMOVESLAVENAME then begin
      nCMDCode := nSC_MAPMOVESLAVENAME;
      goto L001;
    end;
    if sCmd = sSC_LOADPETSMONSET then begin
      nCMDCode := nSC_LOADPETSMONSET;
      goto L001;
    end;
    if sCmd = sSC_SETMAPMODE then begin
      nCMDCode := nSC_SETMAPMODE;
      goto L001;
    end;
    if sCmd = sSC_KILLSLAVE then begin
      nCMDCode := nSC_KILLSLAVE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEGENDER then begin
      nCMDCode := nSC_CHANGEGENDER;
      goto L001;
    end;
    if sCmd = sOFFLINEPLAY then begin
      nCMDCode := nOFFLINEPLAY;
      goto L001;
    end;
    if sCmd = sKICKOFFLINE then begin
      nCMDCode := nKICKOFFLINE;
      goto L001;
    end;
    if sCmd = sSTARTTAKEGOLD then begin
      nCMDCode := nSTARTTAKEGOLD;
      goto L001;
    end;
    if sCmd = sSC_AISTART then begin
      nCMDCode := nSC_AISTART;
      goto L001;
    end;
    if sCmd = sSC_AISTOP then begin
      nCMDCode := nSC_AISTOP;
      goto L001;
    end;
    if sCmd = sSC_AILOGON then begin
      nCMDCode := nSC_AILOGON;
      goto L001;
    end;
    if sCmd = sSC_AILOGONEX then begin
      nCMDCode := nSC_AILOGONEX;
      goto L001;
    end;
    {if sCmd = sSC_LOADROBOTCONFIG then begin
      nCMDCode := nSC_LOADROBOTCONFIG;
      goto L001;
    end;}
    if sCmd = sDELAYGOTO then begin
      nCMDCode := nDELAYGOTO;
      goto L001;
    end;
    if sCmd = sCLEARDELAYGOTO then begin
      nCMDCode := nCLEARDELAYGOTO;
      goto L001;
    end;
    if sCmd = sSC_ADDUSERDATE then begin
      nCMDCode := nSC_ADDUSERDATE;
      goto L001;
    end;
    if sCmd = sSC_DELUSERDATE then begin
      nCMDCode := nSC_DELUSERDATE;
      goto L001;
    end;
    if sCmd = sSC_ANSIREPLACETEXT then begin
      nCMDCode := nSC_ANSIREPLACETEXT;
      goto L001;
    end;
    if sCmd = sSC_ENCODETEXT then begin
      nCMDCode := nSC_ENCODETEXT;
      goto L001;
    end;
    if sCmd = sSC_ADDTEXTLIST then begin
      nCMDCode := nSC_ADDTEXTLIST;
      goto L001;
    end;
    if sCmd = sSC_DELTEXTLIST then begin
      nCMDCode := nSC_DELTEXTLIST;
      goto L001;
    end;
    if sCmd = sSC_GROUPMOVE then begin//20080516
      nCMDCode := nSC_GROUPMOVE;
      goto L001;
    end;
    if sCmd = sSC_GROUPMAPMOVE then begin
      nCMDCode := nSC_GROUPMAPMOVE;
      goto L001;
    end;
    if sCmd = sSC_RECALLHUMAN then begin
      nCMDCode := nSC_RECALLHUMAN;
      goto L001;
    end;
    if sCmd = sSC_REGOTO then begin
      nCMDCode := nSC_REGOTO;
      goto L001;
    end;
    if sCmd = sSC_INTTOSTR then begin
      nCMDCode := nSC_INTTOSTR;
      goto L001;
    end;
    if sCmd = sSC_STRTOINT then begin
      nCMDCode := nSC_STRTOINT;
      goto L001;
    end;
    if sCmd = sSC_GUILDMOVE then begin
      nCMDCode := nSC_GUILDMOVE;
      goto L001;
    end;
    if sCmd = sSC_GUILDMAPMOVE then begin
      nCMDCode := nSC_GUILDMAPMOVE;
      goto L001;
    end;
    if sCmd = sSC_RANDOMMOVE then begin
      nCMDCode := nSC_RANDOMMOVE;
      goto L001;
    end;
    if sCmd = sSC_USEBONUSPOINT then begin
      nCMDCode := nSC_USEBONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_REPAIRITEM then begin
      nCMDCode := nSC_REPAIRITEM;
      goto L001;
    end;
    if sCmd = sSC_TAKEONITEM then begin
      nCMDCode := nSC_TAKEONITEM;
      goto L001;
    end;
    if sCmd = sSC_TAKEOFFITEM then begin
      nCMDCode := nSC_TAKEOFFITEM;
      goto L001;
    end;
    if sCmd = sSC_CREATEHERO then begin
      nCMDCode := nSC_CREATEHERO;
      goto L001;
    end;
    if sCmd = sSC_DELETEHERO then begin
      nCMDCode := nSC_DELETEHERO;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROLEVEL then begin
      nCMDCode := nSC_CHANGEHEROLEVEL;
      goto L001;
    end;
    {$IF M2Version = 1}
    if sCmd = sSC_CHANGEHEROPULSEXP then begin//�ı�Ӣ�۾���������
      nCMDCode := nSC_CHANGEHEROPULSEXP;
      goto L001;
    end;
    {$IFEND}
    if sCmd = sSC_CHANGEHEROJOB then begin
      nCMDCode := nSC_CHANGEHEROJOB;
      goto L001;
    end;
    if sCmd = sSC_CLEARHEROSKILL then begin
      nCMDCode := nSC_CLEARHEROSKILL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROPKPOINT then begin
      nCMDCode := nSC_CHANGEHEROPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROEXP then begin
      nCMDCode := nSC_CHANGEHEROEXP;
      goto L001;
    end;

   { if nCMDCode <= 0 then begin //20080813 ע��
      if Assigned(zPlugOfEngine.QuestActionScriptCmd) then begin
        nCMDCode := zPlugOfEngine.QuestActionScriptCmd(PChar(sCmd));
        goto L001;
      end;
    end; }
    L001:
    if nCMDCode > 0 then begin
      QuestActionInfo.nCMDCode := nCMDCode;
      if (sParam1 <> '') and (sParam1[1] = '"') then ArrestStringEx(sParam1, '"', '"', sParam1);
      if (sParam2 <> '') and (sParam2[1] = '"') then ArrestStringEx(sParam2, '"', '"', sParam2);
      if (sParam3 <> '') and (sParam3[1] = '"') then ArrestStringEx(sParam3, '"', '"', sParam3);
      if (sParam4 <> '') and (sParam4[1] = '"') then ArrestStringEx(sParam4, '"', '"', sParam4);
      if (sParam5 <> '') and (sParam5[1] = '"') then ArrestStringEx(sParam5, '"', '"', sParam5);
      if (sParam6 <> '') and (sParam6[1] = '"') then ArrestStringEx(sParam6, '"', '"', sParam6);
      if (sParam7 <> '') and (sParam7[1] = '"') then ArrestStringEx(sParam7, '"', '"', sParam7);
      if (sParam8 <> '') and (sParam8[1] = '"') then ArrestStringEx(sParam8, '"', '"', sParam8);
      QuestActionInfo.sParam1 := sParam1;
      QuestActionInfo.sParam2 := sParam2;
      QuestActionInfo.sParam3 := sParam3;
      QuestActionInfo.sParam4 := sParam4;
      QuestActionInfo.sParam5 := sParam5;
      QuestActionInfo.sParam6 := sParam6;
      QuestActionInfo.sParam7 := sParam7;
      QuestActionInfo.sParam8 := sParam8;
      if IsStringNumber(sParam1) then QuestActionInfo.nParam1 := Str_ToInt(sParam1, 0);
      if IsStringNumber(sParam2) then QuestActionInfo.nParam2 := Str_ToInt(sParam2, 1);
      if IsStringNumber(sParam3) then QuestActionInfo.nParam3 := Str_ToInt(sParam3, 1);
      if IsStringNumber(sParam4) then QuestActionInfo.nParam4 := Str_ToInt(sParam4, 0);
      if IsStringNumber(sParam5) then QuestActionInfo.nParam5 := Str_ToInt(sParam5, 0);
      if IsStringNumber(sParam6) then QuestActionInfo.nParam6 := Str_ToInt(sParam6, 0);
      if IsStringNumber(sParam7) then QuestActionInfo.nParam7 := Str_ToInt(sParam7, 0);
      if IsStringNumber(sParam8) then QuestActionInfo.nParam8 := Str_ToInt(sParam8, 0);
      Result := True;
    end;
  end;

begin
  Result := -1;
  nCode:= 0;
  try
    n6C := 0;
    n70 := 0;
    bo8D := False;//20080521
    boDeCodeFile:= False;//�Ƿ��Ǽ��ܽű� 20090605
    sScritpFileName := g_Config.sEnvirDir + sPatch + sScritpName + '.txt';
    if FileExists(sScritpFileName) then begin
      nCode:= 1;
      LoadList := TStringList.Create;
      try
        LoadList.LoadFromFile(sScritpFileName);
        {$IF M2Version = 1}
        if (NPC = g_ManageNPC) or (NPC = g_FunctionNPC) or (NPC = g_BatterNPC) or (NPC = g_MissionNPC) or (NPC = g_RobotNPC) then begin
        {$ELSE}
        if (NPC = g_ManageNPC) or (NPC = g_FunctionNPC) {$IF M2Version <> 2}or (NPC = g_MissionNPC){$IFEND} or (NPC = g_RobotNPC) then begin
        {$IFEND}
          boDeCodeFile:= SetStringList(LoadList);//�ű����� 20100918
        end else begin
          boDeCodeFile:= DeCodeStringList(LoadList);//�ű�����
        end;
      except
        LoadList.Free;
        Exit;
      end;
      nCode:= 2;
      I := 0;
      while (True) do begin
        LoadScriptcall(LoadList);
        Inc(I);
        if I >= 10 then Break;
      end;
      nCode:= 3;
      DefineList := TList.Create;
      try
        nCode:= 4;
        s54 := LoadDefineInfo(LoadList, DefineList);
        New(DefineInfo);
        DefineInfo.sName := '@HOME';
        if s54 = '' then s54 := '@main';
        DefineInfo.sText := s54;
        DefineList.Add(DefineInfo);
        // ��������
        for I := 0 to LoadList.Count - 1 do begin
          s34 := Trim(LoadList.Strings[I]);
          if (s34 <> '') then begin
            if (s34[1] = '[') then begin
              bo8D := False;
            end else begin //0048B83F
              if (s34[1] = '#') and
                (CompareLStr(s34, '#IF', 3{Length('#IF')}) or
                CompareLStr(s34, '#ACT', 4{Length('#ACT')}) or
                CompareLStr(s34, '#ELSEACT', 8{Length('#ELSEACT')})) then begin
                bo8D := True;
              end else begin //0048B895
                if bo8D then begin
                  // ��Define �õĳ�������ָ��ֵ
                  for n20 := 0 to DefineList.Count - 1 do begin
                    DefineInfo := DefineList.Items[n20];
                    n1C := 0;
                    while (True) do begin
                      n24 := Pos(DefineInfo.sName, UpperCase(s34));
                      if n24 <= 0 then Break;
                      s58 := Copy(s34, 1, n24 - 1);
                      s5C := Copy(s34, Length(DefineInfo.sName) + n24, 256);
                      s34 := s58 + DefineInfo.sText + s5C;
                      LoadList.Strings[I] := s34;
                      Inc(n1C);
                      if n1C >= 10 then Break;
                    end;
                  end; // ��Define �õĳ�������ָ��ֵ
                end;
              end;
            end;
          end;
        end;//for
        // ��������
        nCode:= 5;
        //�ͷų�����������
        if DefineList.Count > 0 then begin//20080629
          for I := 0 to DefineList.Count - 1 do begin
            if pTDefineInfo(DefineList.Items[I]) <> nil then Dispose(pTDefineInfo(DefineList.Items[I]));
          end;
        end;
      finally
        DefineList.Free;//�ͷų�����������
      end;
      nCode:= 6;
      Script := nil;
      SayingRecord := nil;
      nQuestIdx := 0;
      for I := 0 to LoadList.Count - 1 do begin //0048B9FC
        s34 := Trim(LoadList.Strings[I]);
        if (s34 = '') or (s34[1] = ';') or (s34[1] = '/') then Continue;
        if (n6C = 0) and (boFlag) then begin
          //��Ʒ�۸���
          if s34[1] = '%' then begin //0048BA57
            s34 := Copy(s34, 2, Length(s34) - 1);
            nPriceRate := Str_ToInt(s34, -1);
            if nPriceRate >= 55 then begin
              TMerchant(NPC).m_nPriceRate := nPriceRate;
            end;
            Continue;
          end;
          //��Ʒ��������
          if s34[1] = '+' then begin
            s34 := Copy(s34, 2, Length(s34) - 1);
            nItemType := Str_ToInt(s34, -1);
            if nItemType >= 0 then begin
              TMerchant(NPC).m_ItemTypeList.Add(Pointer(nItemType));
            end;
            Continue;
          end;
          //���Ӵ���NPC��ִ����������
          if s34[1] = '(' then begin
            ArrestStringEx(s34, '(', ')', s34);
            if s34 <> '' then begin
              while (s34 <> '') do begin
                s34 := GetValidStr3(s34, s30, [' ', ',', #9]);
                if CompareText(s30, sBUY) = 0 then begin
                  TMerchant(NPC).m_boBuy := True;
                  Continue;
                end;
                if CompareText(s30, sSELL) = 0 then begin
                  TMerchant(NPC).m_boSell := True;
                  Continue;
                end;
                if CompareText(s30, sMAKEDURG) = 0 then begin
                  TMerchant(NPC).m_boMakeDrug := True;
                  Continue;
                end;
                if CompareText(s30, sPRICES) = 0 then begin
                  TMerchant(NPC).m_boPrices := True;
                  Continue;
                end;
                if CompareText(s30, sSTORAGE) = 0 then begin
                  TMerchant(NPC).m_boStorage := True;
                  Continue;
                end;
                if CompareText(s30, sGETBACK) = 0 then begin
                  TMerchant(NPC).m_boGetback := True;
                  Continue;
                end;
                if CompareText(s30, sUPGRADENOW) = 0 then begin
                  TMerchant(NPC).m_boUpgradenow := True;
                  Continue;
                end;
                if CompareText(s30, sGETBACKUPGNOW) = 0 then begin
                  TMerchant(NPC).m_boGetBackupgnow := True;
                  Continue;
                end;
                if CompareText(s30, sREPAIR) = 0 then begin
                  TMerchant(NPC).m_boRepair := True;
                  Continue;
                end;
                {$IF M2Version <> 2}
                if CompareText(s30, sArmsTear) = 0 then begin//������ж����ʯ 20100708
                  TMerchant(NPC).m_boArmsTear := True;
                  Continue;
                end;
                if CompareText(s30, sArmsExchange) = 0 then begin//�����һ�������Ƭ 20100809
                  TMerchant(NPC).m_boArmsExchange := True;
                  Continue;
                end;
                {$IFEND}
                if CompareText(s30, sSUPERREPAIR) = 0 then begin
                  TMerchant(NPC).m_boS_repair := True;
                  Continue;
                end;
                if CompareText(s30, sSL_SENDMSG) = 0 then begin
                  TMerchant(NPC).m_boSendmsg := True;
                  Continue;
                end;
                if CompareText(s30, sUSEITEMNAME) = 0 then begin
                  TMerchant(NPC).m_boUseItemName := True;
                  Continue;
                end;
               { if CompareText(s30, sGETSELLGOLD) = 0 then begin  //20080416 ȥ����������
                  TMerchant(NPC).m_boGetSellGold := True;
                  Continue;
                end; 
                if CompareText(s30, sSELLOFF) = 0 then begin
                  TMerchant(NPC).m_boSellOff := True;
                  Continue;
                end;
                if CompareText(s30, sBUYOFF) = 0 then begin
                  TMerchant(NPC).m_boBuyOff := True;
                  Continue;
                end; }
                if CompareText(s30, sofflinemsg) = 0 then begin
                  TMerchant(NPC).m_boofflinemsg := True;
                  Continue;
                end;
                if CompareText(s30, sdealgold) = 0 then begin
                  TMerchant(NPC).m_boDealGold := True;
                  Continue;
                end;
                if CompareText(s30, sBIGSTORAGE) = 0 then begin
                  TMerchant(NPC).m_boBigStorage := True;
                  Continue;
                end;
                if CompareText(s30, sBIGGETBACK) = 0 then begin
                  TMerchant(NPC).m_boBigGetBack := True;
                  Continue;
                end;
                if CompareText(s30, sGETPREVIOUSPAGE) = 0 then begin
                  TMerchant(NPC).m_boGetPreviousPage := True;
                  Continue;
                end;
                if CompareText(s30, sGETNEXTPAGE) = 0 then begin
                  TMerchant(NPC).m_boGetNextPage := True;
                  Continue;
                end;
                if CompareText(s30, sUserLevelOrder) = 0 then begin
                  TMerchant(NPC).m_boUserLevelOrder := True;
                  Continue;
                end;
                if CompareText(s30, sWarrorLevelOrder) = 0 then begin
                  TMerchant(NPC).m_boWarrorLevelOrder := True;
                  Continue;
                end;
                if CompareText(s30, sWizardLevelOrder) = 0 then begin
                  TMerchant(NPC).m_boWizardLevelOrder := True;
                  Continue;
                end;
                if CompareText(s30, sTaoistLevelOrder) = 0 then begin
                  TMerchant(NPC).m_boTaoistLevelOrder := True;
                  Continue;
                end;
                if CompareText(s30, sMasterCountOrder) = 0 then begin
                  TMerchant(NPC).m_boMasterCountOrder := True;
                  Continue;
                end;
                if CompareText(s30, sLyCreateHero) = 0 then begin
                  TMerchant(NPC).m_boCqFirHero := True;
                  Continue;
                end;
                if CompareText(s30, sBuHero) = 0 then begin//�ƹ�Ӣ��NPC 20080514
                  TMerchant(NPC).m_boBuHero := True;
                  Continue;
                end;
                if CompareText(s30, sPlayMakeWine) = 0 then begin//���NPC 20080619
                  TMerchant(NPC).m_boPlayMakeWine := True;
                  Continue;
                end;
                if CompareText(s30, sPlayDrink) = 0 then begin//���,����NPC 20080515
                  TMerchant(NPC).m_boPlayDrink := True;
                  Continue;
                end;
                if CompareText(s30, sybdeal) = 0 then begin //Ԫ������NPC���� 20080316
                  TMerchant(NPC).m_boYBDeal := True;
                  Continue;
                end;
                if CompareText(s30, sKAMPODLGNEW) = 0 then begin //Ԫ������NPC���� 20080316
                  TMerchant(NPC).m_boNewSignedItem := True;
                  Continue;
                end;
              end;
            end;
            Continue;
          end
        end;
        nCode:= 7;
        if s34[1] = '{' then begin
          if CompareLStr(s34, '{Quest', 6) then begin
            s38 := GetValidStr3(s34, s3C, [' ', '}', #9]);
            GetValidStr3(s38, s3C, [' ', '}', #9]);
            n70 := Str_ToInt(s3C, 0);
            Script := MakeNewScript();
            Script.nQuest := n70;
            Inc(n70);
          end;
          if CompareLStr(s34, '{~Quest', 7) then Continue;
        end; 
        nCode:= 8;
        if (n6C = 1) and (Script <> nil) and (s34[1] = '#') then begin
          s38 := GetValidStr3(s34, s3C, ['=', ' ', #9]);
          Script.boQuest := True;
          if CompareLStr(s34, '#IF', 3) then begin
            ArrestStringEx(s34, '[', ']', s40);
            Script.QuestInfo[nQuestIdx].wFlag := Str_ToInt(s40, 0);
            GetValidStr3(s38, s44, ['=', ' ', #9]);
            n24 := Str_ToInt(s44, 0);
            if n24 <> 0 then n24 := 1;
            Script.QuestInfo[nQuestIdx].btValue := n24;
          end;

          if CompareLStr(s34, '#RAND', 5) then begin
            Script.QuestInfo[nQuestIdx].nRandRage := Str_ToInt(s44, 0);
          end;
          Continue;
        end;
        nCode:= 9;
        if s34[1] = '[' then begin
          n6C := 10;
          if Script = nil then begin
            Script := MakeNewScript();
            Script.nQuest := n70;
          end;
          if CompareText(s34, '[goods]') = 0 then begin
            n6C := 20;
            Continue;
          end;
          s34 := ArrestStringEx(s34, '[', ']', s74);
          New(SayingRecord);
          SayingRecord.ProcedureList := TList.Create;
          SayingRecord.sLabel := s74;
          s34 := GetValidStrCap(s34, s74, [' ', #9]);
          if CompareText(s74, 'TRUE') = 0 then begin
            SayingRecord.boExtJmp := True;
          end else begin
            SayingRecord.boExtJmp := False;
          end;
          New(SayingProcedure);
          SayingRecord.ProcedureList.Add(SayingProcedure);
          SayingProcedure.ConditionList := TList.Create;
          SayingProcedure.ActionList := TList.Create;
          SayingProcedure.sSayMsg := '';
          SayingProcedure.ElseActionList := TList.Create;
          SayingProcedure.sElseSayMsg := '';
          Script.RecordList.Add(SayingRecord);
          Continue;
        end;
        nCode:= 10;
        if (Script <> nil) and (SayingRecord <> nil) then begin
          if (n6C >= 10) and (n6C < 20) and (s34[1] = '#') then begin
            if CompareText(s34, '#IF') = 0 then begin
              if (SayingProcedure.ConditionList.Count > 0) or (SayingProcedure.sSayMsg <> '') then begin //0048BE53
                New(SayingProcedure);
                nCode:= 101;
                SayingRecord.ProcedureList.Add(SayingProcedure);
                SayingProcedure.ConditionList := TList.Create;
                SayingProcedure.ActionList := TList.Create;
                SayingProcedure.sSayMsg := '';
                SayingProcedure.ElseActionList := TList.Create;
                SayingProcedure.sElseSayMsg := '';
              end;
              n6C := 11;
            end;
            if CompareText(s34, '#ACT') = 0 then n6C := 12;
            if CompareText(s34, '#SAY') = 0 then n6C := 10;
            if CompareText(s34, '#ELSEACT') = 0 then n6C := 13;
            if CompareText(s34, '#ELSESAY') = 0 then n6C := 14;
            Continue;
          end;
          nCode:= 102;
          if (n6C = 10) and (SayingProcedure <> nil) then 
            SayingProcedure.sSayMsg := SayingProcedure.sSayMsg + s34;
          nCode:= 103;
          if (n6C = 11) then begin
            New(QuestConditionInfo);
            FillChar(QuestConditionInfo^, SizeOf(TQuestConditionInfo), #0);
            QuestConditionInfo.Script := TScriptObject.Create;//NPC������չ 20090926
            nCode:= 104;
            if QuestCondition(Trim(s34), QuestConditionInfo) then begin
              nCode:= 105;
              SayingProcedure.ConditionList.Add(QuestConditionInfo);
            end else begin
              nCode:= 106;
              QuestConditionInfo.Script.Free;//NPC������չ 20090926
              Dispose(QuestConditionInfo);
              if not boDeCodeFile then MainOutMessage('�ű�����1: ' + s34 + ' ��:' + IntToStr(I) + ' ��: ' + sScritpFileName)
              else MainOutMessage('�ű�����1(����): ��:' + IntToStr(I) + ' ��: ' + sScritpFileName);
            end;
          end; //0048C004
          nCode:= 107;
          if (n6C = 12) then begin
            New(QuestActionInfo);
            nCode:= 109;
            FillChar(QuestActionInfo^, SizeOf(TQuestActionInfo), #0);
            nCode:= 110;
            QuestActionInfo.Script := TScriptObject.Create;//NPC������չ 20090926
            nCode:= 111;
            if QuestAction(Trim(s34), QuestActionInfo) then begin
              nCode:= 112;
              SayingProcedure.ActionList.Add(QuestActionInfo);
            end else begin
              nCode:= 113;
              QuestActionInfo.Script.Free;//NPC������չ 20090926
              Dispose(QuestActionInfo);
              if not boDeCodeFile then MainOutMessage('�ű�����2: ' + s34 + ' ��:' + IntToStr(I) + ' ��: ' + sScritpFileName)
              else MainOutMessage('�ű�����2(����): ��:' + IntToStr(I) + ' ��: ' + sScritpFileName);
            end;
          end;
          nCode:= 108;
          if (n6C = 13) then begin
            New(QuestActionInfo);
            nCode:= 114;
            FillChar(QuestActionInfo^, SizeOf(TQuestActionInfo), #0);
            nCode:= 115;
            QuestActionInfo.Script := TScriptObject.Create;//NPC������չ 20090926
            nCode:= 116;
            if QuestAction(Trim(s34), QuestActionInfo) then begin
              nCode:= 117;
              SayingProcedure.ElseActionList.Add(QuestActionInfo);
            end else begin
              nCode:= 118;
              QuestActionInfo.Script.Free;//NPC������չ 20090926
              nCode:= 119;
              Dispose(QuestActionInfo);
              if not boDeCodeFile then MainOutMessage('�ű�����3: ' + s34 + ' ��:' + IntToStr(I) + ' ��: ' + sScritpFileName)
              else MainOutMessage('�ű�����3(����): ��:' + IntToStr(I) + ' ��: ' + sScritpFileName);
            end;
          end;
          if (n6C = 14) then SayingProcedure.sElseSayMsg := SayingProcedure.sElseSayMsg + s34;
        end;
        nCode:= 11;
        if (n6C = 20) and boFlag then begin
          s34 := GetValidStrCap(s34, s48, [' ', #9]);
          s34 := GetValidStrCap(s34, s4C, [' ', #9]);
          s34 := GetValidStrCap(s34, s50, [' ', #9]);
          if (s48 <> '') and (s50 <> '') then begin
            New(Goods);
            if (s48 <> '') and (s48[1] = '"') then ArrestStringEx(s48, '"', '"', s48);
            Goods.sItemName := s48;
            //Goods.nCount := Str_ToInt(s4C, 0);
            Goods.nCount:=_MIN(Str_ToInt(s4C,0),1000);//20110529 �����������Ϊ1000
            Goods.dwRefillTime := Str_ToInt(s50, 10) * 60000;//20101027 ���ת��ʧ��,Ĭ��Ϊ10����
            Goods.dwRefillTick := 0;
            if (Goods.nCount > 0) and (Goods.dwRefillTime > 0) and
              (UserEngine.GetStdItemIdx(Goods.sItemName) >= 0) then//20110529 ��������0,��Ʒ������DB��ʱ�ż����б�
              TMerchant(NPC).m_RefillGoodsList.Add(Goods)
            else Dispose(Goods);
          end;
        end;
      end; // for
      LoadList.Free;
    end else begin //0048C2EB
      MainOutMessage('�ű��ļ�δ�ҵ�: ' + sScritpFileName);
    end;
    Result := 1;
  except
    MainOutMessage(format('{%s} TFrmDB.LoadScriptFile Code:%d ScritpName:%s I:%d Cmd:%s',[g_sExceptionVer, nCode, sScritpName, I, s34]));
  end;
end;

function TFrmDB.SaveGoodRecord(NPC: TMerchant; sFile: string): Integer;
var
  I, II: Integer;
  sFileName: string;
  FileHandle: Integer;
  UserItem: pTUserItem;
  List: TList;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Saved\' + sFile + '.sav';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
  end else begin
    FileHandle := FileCreate(sFileName);
  end;
  if FileHandle > 0 then begin
    FillChar(Header420, SizeOf(TGoodFileHeader), #0);
    if NPC.m_GoodsList.Count > 0 then begin//20080629
      for I := 0 to NPC.m_GoodsList.Count - 1 do begin
        List := TList(NPC.m_GoodsList.Items[I]);
        Inc(Header420.nItemCount, List.Count);
      end;
    end;
    FileWrite(FileHandle, Header420, SizeOf(TGoodFileHeader));
    if NPC.m_GoodsList.Count > 0 then begin//20080629
      for I := 0 to NPC.m_GoodsList.Count - 1 do begin
        List := TList(NPC.m_GoodsList.Items[I]);
        if List.Count > 0 then begin//20080629
          for II := 0 to List.Count - 1 do begin
            UserItem := List.Items[II];
            FileWrite(FileHandle, UserItem^, SizeOf(TUserItem));
          end;
        end;
      end;
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

function TFrmDB.SaveGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
var
  I: Integer;
  sFileName: string;
  FileHandle: Integer;
  ItemPrice: pTItemPrice;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Prices\' + sFile + '.prc';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
  end else begin
    FileHandle := FileCreate(sFileName);
  end;
  if FileHandle > 0 then begin
    FillChar(Header420, SizeOf(TGoodFileHeader), #0);
    Header420.nItemCount := NPC.m_ItemPriceList.Count;
    FileWrite(FileHandle, Header420, SizeOf(TGoodFileHeader));
    if NPC.m_ItemPriceList.Count > 0 then begin//20080629
      for I := 0 to NPC.m_ItemPriceList.Count - 1 do begin
        ItemPrice := NPC.m_ItemPriceList.Items[I];
        FileWrite(FileHandle, ItemPrice^, SizeOf(TItemPrice));
      end;
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

//���¶�ȡ����NPC
procedure TFrmDB.ReLoadNpc;
var
  sFileName, s18, s20, s24, s28, s2C, s30, s34, s38, s40, s42: string;
  LoadList: TStringList;
  NPC: TNormNpc;
  I,II, nX, nY: Integer;
  boNewNpc: Boolean;
begin
  Try
    sFileName := g_Config.sEnvirDir + 'Npcs.txt';
    if not FileExists(sFileName) then Exit;
    if UserEngine.QuestNPCList.Count > 0 then begin//20080629
      for I := 0 to UserEngine.QuestNPCList.Count - 1 do begin
        NPC := TNormNpc(UserEngine.QuestNPCList.Items[I]);
        {$IF M2Version = 1}
        if (NPC <> g_ManageNPC) and (NPC <> g_RobotNPC) and (NPC <> g_FunctionNPC){$IF M2Version <> 2} and (NPC <> g_MissionNPC){$IFEND} and (NPC <> g_BatterNPC) and ({not} NPC.m_boIsQuest) then NPC.m_nFlag := -1;
        {$ELSE}
        if (NPC <> g_ManageNPC) and (NPC <> g_RobotNPC) and (NPC <> g_FunctionNPC){$IF M2Version <> 2} and (NPC <> g_MissionNPC){$IFEND} and ({not} NPC.m_boIsQuest) then NPC.m_nFlag := -1;
        {$IFEND}
      end;
    end;
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      SetStringList(LoadList);//�ű����� 20100815
      for I := 0 to LoadList.Count - 1 do begin
        s18 := Trim(LoadList.Strings[I]);
        if (s18 <> '') and (s18[1] <> ';') then begin
          s18 := GetValidStrCap(s18, s20, [' ', #9]);
          if (s20 <> '') and (s20[1] = '"') then ArrestStringEx(s20, '"', '"', s20);
          s18 := GetValidStr3(s18, s24, [' ', #9]);
          s18 := GetValidStr3(s18, s28, [' ', #9]);
          s18 := GetValidStr3(s18, s2C, [' ', #9]);
          s18 := GetValidStr3(s18, s30, [' ', #9]);
          s18 := GetValidStr3(s18, s34, [' ', #9]);
          s18 := GetValidStr3(s18, s38, [' ', #9]);
          s18 := GetValidStr3(s18, s40, [' ', #9]);
          s18 := GetValidStr3(s18, s42, [' ', #9]);
          if (s20 <> '') and (s28 <> '') and (s38 <> '') then begin
           nX := Str_ToInt(s2C, 0);
           nY := Str_ToInt(s30, 0);
            boNewNpc := True;
            if UserEngine.QuestNPCList.Count > 0 then begin
              for II := 0 to UserEngine.QuestNPCList.Count - 1 do begin
                NPC := TNormNpc(UserEngine.QuestNPCList.Items[II]);
                if (NPC.m_sMapName = s28) and (NPC.m_nCurrX = nX) and (NPC.m_nCurrY = nY) then begin
                  boNewNpc := False;
                  NPC.m_sCharName := s20;
                  NPC.m_nFlag := Str_ToInt(s34, 0);
                  NPC.m_wAppr := Str_ToInt(s38, 0);
                  if Str_ToInt(s40, 0) <> 0 then NPC.m_boNpcAutoChangeColor := True;
                  NPC.m_dwNpcAutoChangeColorTime := Str_ToInt(s42, 0) * 1000;
                  Break;
                end;
              end;//for
            end;
            if boNewNpc then begin
              NPC := nil;
              case Str_ToInt(s24, 0) of
                0: NPC := TMerchant.Create;
                1: NPC := TGuildOfficial.Create;
                2: NPC := TCastleOfficial.Create;
              end;
              if NPC <> nil then begin
                NPC.m_sMapName := s28;
                NPC.m_nCurrX := {Str_ToInt(s2C, 0)}nX;
                NPC.m_nCurrY := {Str_ToInt(s30, 0)}nY;
                NPC.m_sCharName := s20;
                NPC.m_nFlag := Str_ToInt(s34, 0);
                NPC.m_wAppr := Str_ToInt(s38, 0);
                if Str_ToInt(s40, 0) <> 0 then NPC.m_boNpcAutoChangeColor := True;
                NPC.m_dwNpcAutoChangeColorTime := Str_ToInt(s42, 0) * 1000;
                UserEngine.QuestNPCList.Add(NPC);
              end;
            end;
          end;
        end;
      end;//for
    finally
      LoadList.Free;
    end;
    if UserEngine.QuestNPCList.Count > 0 then begin
      for I := UserEngine.QuestNPCList.Count - 1 downto 0 do begin
        NPC := TNormNpc(UserEngine.QuestNPCList.Items[I]);
        if NPC.m_nFlag = -1 then begin
          NPC.m_boGhost := True;
          NPC.m_dwGhostTick := GetTickCount();
        end else begin
          if not NPC.m_boGhost then begin//20100408 ����
            NPC.ClearScript;
            NPC.LoadNpcScript;
          end;
        end;
      end;
    end;
  except
  end;
end;







//���¶�ȡ����NPC
procedure TFrmDB.ReLoadMerchants();
var
  I, II, nX, nY, J: Integer;
  sLineText, sFileName, sScript, sMapName, sX, sY, sCharName, sFlag, sAppr, sCastle, sCanMove, sMoveTime: string;
  Merchant: TMerchant;
  LoadList: TStringList;
  boNewNpc: Boolean;
begin
  sFileName := g_Config.sEnvirDir + 'Merchant.txt';
  if not FileExists(sFileName) then Exit;
  UserEngine.m_MerchantList.Lock;
  try
    if UserEngine.m_MerchantList.Count > 0 then begin//20080629
      for I := 0 to UserEngine.m_MerchantList.Count - 1 do begin
        Merchant := TMerchant(UserEngine.m_MerchantList.Items[I]);
        if Merchant <> nil then begin
          {$IF M2Version = 1}
          if (Merchant <> g_FunctionNPC) and (Merchant <> g_MissionNPC) and (Merchant <> g_BatterNPC) and (Merchant <> g_RobotNPC) and (Merchant.m_boIsQuest) then//20090107 ���� m_boIsQuest ����
          Merchant.m_nFlag := -1;
          {$ELSE}
          if (Merchant <> g_FunctionNPC) {$IF M2Version <> 2}and (Merchant <> g_MissionNPC){$IFEND} and (Merchant <> g_RobotNPC) and (Merchant.m_boIsQuest) then//20090107 ���� m_boIsQuest ����
          Merchant.m_nFlag := -1;
          {$IFEND}
        end;
      end;
    end;
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      SetStringList(LoadList);//�ű����� 20100815
      for I := 0 to LoadList.Count - 1 do begin
        sLineText := Trim(LoadList.Strings[I]);
        if (sLineText <> '') and (sLineText[1] <> ';') then begin
          sLineText := GetValidStr3(sLineText, sScript, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sMapName, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sX, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sY, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sCharName, [' ', #9]);
          if (sCharName <> '') and (sCharName[1] = '"') then ArrestStringEx(sCharName, '"', '"', sCharName);
          sLineText := GetValidStr3(sLineText, sFlag, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sAppr, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sCastle, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sCanMove, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sMoveTime, [' ', #9]);
          nX := Str_ToInt(sX, 0);
          nY := Str_ToInt(sY, 0);
          boNewNpc := True;
          if UserEngine.m_MerchantList.Count > 0 then begin//20080629
            for II := 0 to UserEngine.m_MerchantList.Count - 1 do begin
              Merchant := TMerchant(UserEngine.m_MerchantList.Items[II]);
              if Merchant <> nil then begin//20090306 ����
                if (Merchant.m_sMapName = sMapName) and (Merchant.m_nCurrX = nX) and (Merchant.m_nCurrY = nY) then begin
                  boNewNpc := False;
                  Merchant.m_sScript := sScript;
                  Merchant.m_sCharName := sCharName;
                  Merchant.m_nFlag := Str_ToInt(sFlag, 0);
                  Merchant.m_wAppr := Str_ToInt(sAppr, 0);
                  Merchant.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
                  if Str_ToInt(sCastle, 0) <> {1}0 then Merchant.m_boCastle := True//20080820 �޸�
                  else Merchant.m_boCastle := False;
                  if (Str_ToInt(sCanMove, 0) <> 0) and (Merchant.m_dwMoveTime > 0) then
                    Merchant.m_boCanMove := True;
                  Break;
                end;
              end;
            end;
          end;
          if boNewNpc then begin
            Merchant := TMerchant.Create;
            Merchant.m_sMapName := sMapName;
            Merchant.m_PEnvir := g_MapManager.FindMap(Merchant.m_sMapName);
            if Merchant.m_PEnvir <> nil then begin
              Merchant.m_sScript := sScript;
              Merchant.m_nCurrX := nX;
              Merchant.m_nCurrY := nY;
              Merchant.m_sCharName := sCharName;
              Merchant.m_nFlag := Str_ToInt(sFlag, 0);

              J:= GetValNameNo(sAppr);
              case J of
                100..199: begin//G����
                  Merchant.m_sRefresAppr:= sAppr;
                  Merchant.m_wAppr := g_Config.GlobalVal[J - 100];
                end;
                800..1199: begin
                  Merchant.m_sRefresAppr:= sAppr;
                  Merchant.m_wAppr := g_Config.GlobalVal[J - 700];
                end;
                2100..2599: begin
                  Merchant.m_sRefresAppr:= sAppr;
                  Merchant.m_wAppr := g_Config.GlobalVal[J - 1600];
                end
                else Merchant.m_wAppr := Str_ToInt(sAppr, 0);//���
              end;
              Merchant.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
              if Str_ToInt(sCastle, 0) <> {1}0 then Merchant.m_boCastle := True//20080820 �޸�
              else Merchant.m_boCastle := False;
              if (Str_ToInt(sCanMove, 0) <> 0) and (Merchant.m_dwMoveTime > 0) then
                Merchant.m_boCanMove := True;
              UserEngine.m_MerchantList.Add(Merchant);
              Merchant.Initialize;
            end else Merchant.Free;
          end;
        end;
      end; // for
    finally
      LoadList.Free;
    end;
    if UserEngine.m_MerchantList.Count > 0 then begin//20080629
      for I := UserEngine.m_MerchantList.Count - 1 downto 0 do begin
        Merchant := TMerchant(UserEngine.m_MerchantList.Items[I]);
        if Merchant <> nil then begin//20090306
          if Merchant.m_nFlag = -1 then begin
            Merchant.m_boGhost := True;
            Merchant.m_dwGhostTick := GetTickCount();
            //UserEngine.MerchantList.Delete(I);
          end else begin//���ؽű� 20100408 ����
            if not Merchant.m_boGhost then begin
              Merchant.ClearScript;
              Merchant.LoadNpcScript;
            end; 
          end;
        end;
      end;
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

function TFrmDB.LoadUpgradeWeaponRecord(sNPCName: string;
  DataList: TList): Integer;
var
  I: Integer;
  FileHandle: Integer;
  sFileName,Str: string;
  UpgradeInfo: pTUpgradeInfo;
  UpgradeRecord: TUpgradeInfo;
  nRecordCount: Integer;
begin
  Result := -1;
  if Pos('/',sNPCName) > 0 then begin;//20081223 ����ļ����Ƿ����'/',�����滻Ϊ'_'
    sNPCName := GetValidStr3(sNPCName, str, ['/']);
    sNPCName := str +'_'+ sNPCName;
  end;
  sFileName := '.\Envir\Market_Upg\' + sNPCName + '.upg';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then begin
      FileRead(FileHandle, nRecordCount, SizeOf(Integer));
      if nRecordCount > 0 then begin//20080629
        for I := 0 to nRecordCount - 1 do begin
          if FileRead(FileHandle, UpgradeRecord, SizeOf(TUpgradeInfo)) = SizeOf(TUpgradeInfo) then begin
            New(UpgradeInfo);
            try
              UpgradeInfo^ := UpgradeRecord;
              UpgradeInfo.dwGetBackTick := 0;
              DataList.Add(UpgradeInfo);
            except
              DisPose(UpgradeInfo);//20090304
            end;
          end;
        end;
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;

function TFrmDB.SaveUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
var
  I: Integer;
  FileHandle: Integer;
  sFileName, Str: string;
  UpgradeInfo: pTUpgradeInfo;
begin
  Result := -1;
  if Pos('/',sNPCName) > 0 then begin;//20081223 ����ļ����Ƿ����'/',�����滻Ϊ'_'
    sNPCName := GetValidStr3(sNPCName, str, ['/']);
    sNPCName := str +'_'+ sNPCName;
  end;
  sFileName := '.\Envir\Market_Upg\' + sNPCName + '.upg';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
  end else begin
    FileHandle := FileCreate(sFileName);
  end;

  if FileHandle > 0 then begin
    FileWrite(FileHandle, DataList.Count, SizeOf(Integer));
    if DataList.Count > 0 then begin//20080629
      for I := 0 to DataList.Count - 1 do begin
        UpgradeInfo := DataList.Items[I];
        FileWrite(FileHandle, UpgradeInfo^, SizeOf(TUpgradeInfo));
      end;
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

function TFrmDB.LoadGoodRecord(NPC: TMerchant; sFile: string): Integer;
var
  I: Integer;
  sFileName: string;
  FileHandle: Integer;
  UserItem: pTUserItem;
  List: TList;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Saved\' + sFile + '.sav';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    List := nil;
    if FileHandle > 0 then begin
      if FileRead(FileHandle, Header420, SizeOf(TGoodFileHeader)) = SizeOf(TGoodFileHeader) then begin
        if Header420.nItemCount > 0 then begin//20080629
          for I := 0 to Header420.nItemCount - 1 do begin
            New(UserItem);
            FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
            if FileRead(FileHandle, UserItem^, SizeOf(TUserItem)) = SizeOf(TUserItem) then begin
              if List = nil then begin
                List := TList.Create;
                List.Add(UserItem)
              end else begin
                if pTUserItem(List.Items[0]).wIndex = UserItem.wIndex then begin
                  List.Add(UserItem);
                end else begin
                  NPC.m_GoodsList.Add(List);
                  List := TList.Create;
                  List.Add(UserItem);
                end;
              end;
            end else begin
              //DisPoseAndNil(UserItem); SB �ֲ�����NIL ��ë�� By TasNat at: 2012-03-17 17:21:56
              DisPose(UserItem)
            end;
          end;//for
        end;
        if List <> nil then NPC.m_GoodsList.Add(List);
        FileClose(FileHandle);
        Result := 1;
      end;
    end;
  end;
end;

function TFrmDB.LoadGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
var
  I: Integer;
  sFileName: string;
  FileHandle: Integer;
  ItemPrice: pTItemPrice;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Prices\' + sFile + '.prc';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then begin
      if FileRead(FileHandle, Header420, SizeOf(TGoodFileHeader)) = SizeOf(TGoodFileHeader) then begin
        if Header420.nItemCount > 0 then begin//20080629
          for I := 0 to Header420.nItemCount - 1 do begin
            New(ItemPrice);
            if FileRead(FileHandle, ItemPrice^, SizeOf(TItemPrice)) = SizeOf(TItemPrice) then begin
              NPC.m_ItemPriceList.Add(ItemPrice);
            end else begin
              Dispose(ItemPrice);
              Break;
            end;
          end;//for
        end;
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;
//------------------------------------------------------------------------------
//��ȡ���� //20100511 �޸�
procedure TFrmDB.LoadBoxsList;
var
  LoadList,tSaveList: TStringList;
  sBoxsDir,BoxsFile: string;
  I, K, J, II, nCount: Integer;
  sBoxsID,sItemName,nItemNum,nItemType,nItemRace:string;

  BoxsInfo: pTBoxsInfo;
  StdItem: PTStdItem;
  List28: TList;
begin
  if not DirectoryExists(g_Config.sBoxsDir) then CreateDir(g_Config.sBoxsDir); //Ŀ¼������,�򴴽�
  if not FileExists(g_Config.sBoxsFile) then begin //BoxsList.txt�ļ�������,�򴴽��ļ�
    tSaveList := TStringList.Create;
    tSaveList.Add(';��Ϊ�������к��ļ�');
    tSaveList.Add(';���������鿴�����ĵ�');
    tSaveList.Add(';�������ǿ����������޸����䣬���پ�����ֻ������������������');
    tSaveList.SaveToFile(g_Config.sBoxsFile);
    tSaveList.Free;
  end;

  if FileExists(g_Config.sBoxsFile) then begin
    if BoxsList.Count > 0 then begin
      for I := 0 to BoxsList.Count - 1 do begin
        try
          if TList(BoxsList.Objects[I]).Count > 0 then begin
            for K:=0 to TList(BoxsList.Objects[I]).Count -1 do begin
              if pTBoxsInfo(TList(BoxsList.Objects[I]).Items[K]) <> nil then
                Dispose(pTBoxsInfo(TList(BoxsList.Objects[I]).Items[K]));
            end;
          end;
          TList(BoxsList.Objects[I]).Free;
        except
        end;
      end;
      BoxsList.Clear;
    end;
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(g_Config.sBoxsFile);
      for I := 0 to LoadList.Count - 1 do begin
        sBoxsDir := Trim(LoadList.Strings[I]);
        if (sBoxsDir <> '') and (sBoxsDir[1] <> ';') then begin
          if FileExists(g_Config.sBoxsDir+sBoxsDir+'.txt') then begin
            tSaveList := TStringList.Create;
            try
              tSaveList.LoadFromFile(g_Config.sBoxsDir+sBoxsDir+'.txt');//������Ʒ�����ļ� ��ʽ����Ʒ�� ����(0-��ͨ��Ʒ 1-������Ʒ) ���� ����
              sBoxsID:= sBoxsDir;
              List28 := TList.Create;
              for K := 0 to tSaveList.Count - 1 do begin
                BoxsFile:= Trim(tSaveList.Strings[K]);
                if (BoxsFile <> '') and (BoxsFile[1] <> ';') then begin
                  BoxsFile := GetValidStr3(BoxsFile, sItemName, [' ',#9]);//��Ʒ��
                  BoxsFile := GetValidStr3(BoxsFile, nItemType, [' ',#9]);//��Ʒ����
                  BoxsFile := GetValidStr3(BoxsFile, nItemNum, [' ',#9]);//��Ʒ����
                  BoxsFile := GetValidStr3(BoxsFile, nItemRace, [' ',#9]);//����

                  if (sItemName = '') or (nItemType='') or (nItemNum='') or (nItemRace='') then Continue;//20090312
                  if (sItemName <> '') and (nItemType <> '') then begin
                    J:= Str_ToInt(nItemType, 0);//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ 3-��ͼ�Ʒ��Ʒ)
                    if J < 4 then begin
                      II:= Str_ToInt(nItemRace, 65535);//����
                      if (II < 65536) and (II > 0) then begin//���Ƽ������ù���
                        StdItem := UserEngine.GetStdItem(sItemName);
                        if StdItem <> nil then begin//�ж��Ƿ������ݿ������Ʒ
                          nCount:= Str_ToInt(nItemNum, 1);
                          if nCount > MAXBAGITEM then begin
                            MainOutMessage(Format('�������ã�%s.txt[%s]Ϊ���ݿ�����Ʒ,�������ܴ���%d',[ g_Config.sBoxsDir+sBoxsDir, sItemName, MAXBAGITEM]));
                            nCount:= MAXBAGITEM;
                          end;
                          New(BoxsInfo);
                          try
                            BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID, 0);//�����ļ�ID
                            BoxsInfo.nItemNum:= nCount;//��Ʒ����
                            BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                            BoxsInfo.nItemRace:= II;//����
                            BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);//����ID
                            BoxsInfo.StdItem.Dura := Round((StdItem.DuraMax / 100) * (20 + Random(80)));//��ǰ�־�
                            BoxsInfo.StdItem.DuraMax := StdItem.DuraMax;//���־� 20080324
                            BoxsInfo.StdItem.S:= StdItem^;
                            BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                            BoxsInfo.StdItem.S.NeedIdentify:= 0;//20100901 ��������������ʾ�����ȼ�
                            List28.Add(BoxsInfo);
                          except
                            Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                          end;
                        end else begin //����Ǿ��� ���� ���ʯ ��� �ڹ�
                          if (Trim(sItemName)='����') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1186;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)='����(����)') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1688;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)='����(����)') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1689;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)='����') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1185;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)= g_Config.sGameDiaMond{'���ʯ'}) then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1187;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          {$IF M2Version <> 2}
                          end else
                          if (Trim(sItemName)='�ڹ�') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 2171;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)='�ڹ�(����)') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 2172;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)='�ڹ�(����)') then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 2173;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          {$IFEND}
                          end else
                          if (Trim(sItemName)= g_Config.sGameGird{'���'}) then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1564;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)= Format('%s(����)',[g_Config.sGameGird{'���'}])) then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1690;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else
                          if (Trim(sItemName)= Format('%s(����)',[g_Config.sGameGird{'���'}])) then begin
                            New(BoxsInfo);
                            Try
                              BoxsInfo.SBoxsID:= Str_ToInt(sBoxsID,0);
                              BoxsInfo.StdItem.S.Name:= sItemName;//��Ʒ��
                              BoxsInfo.StdItem.S.StdMode:=0;//20080116
                              BoxsInfo.StdItem.S.Shape:=0;//20080116
                              BoxsInfo.StdItem.S.Reserved1:= 0;//20090705 ����
                              BoxsInfo.StdItem.S.Looks:= 1691;
                              BoxsInfo.StdItem.MakeIndex:= Integer(BoxsInfo);
                              BoxsInfo.nItemNum:= Str_ToInt(nItemNum,1);//��Ʒ����
                              BoxsInfo.nItemType:= J;//��Ʒ����(0-��ͨ��Ʒ 1-������Ʒ 2-�м����Ʒ)
                              BoxsInfo.nItemRace:= II;//����
                              List28.Add(BoxsInfo);
                            except
                              Dispose(BoxsInfo);//��ֹ�쳣���ͷ��ڴ�
                            end;
                          end else MainOutMessage(Format('�������ã�%s.txt �ļ� ��Ʒ[%s]���ݿ��в�����',[ g_Config.sBoxsDir+sBoxsDir, sItemName]));
                        end;
                      end else MainOutMessage(Format('�������ã�%s.txt �ļ� ��Ʒ[%s]�������ô���[��Χ:1-65535]',[ g_Config.sBoxsDir+sBoxsDir, sItemName]));
                    end else MainOutMessage(Format('�������ã�%s.txt �ļ� ��Ʒ[%s]�������ô���[����(0-��ͨ��Ʒ 1-�����Ʒ 2-�м����Ʒ)]',[ g_Config.sBoxsDir+sBoxsDir, sItemName]));
                  end;
                end;//if (BoxsFile <> '') and (BoxsFile[1] <> ';') then begin
              end;// for K := 1 to tSaveList.Count - 1 do begin
              BoxsList.AddObject(sBoxsID, List28);
            finally
              tSaveList.free;
            end;
          end else MainOutMessage(Format('���������ļ�:%s.txt �ļ�������...',[ g_Config.sBoxsDir+sBoxsDir]));
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;
end;
//------------------------------------------------------------------------------
//��ȡԪ�������б� 20080316
procedure TFrmDB.LoadSellOffItemList();
var
  sFileName: string;
  FileHandle: Integer;
  DealOffInfo: pTDealOffInfo;
  sDealOffInfo: TDealOffInfo;
begin
  sFileName :=  g_Config.sEnvirDir + 'UserData';
  if not DirectoryExists(sFileName) then CreateDir(sFileName); //Ŀ¼������,�򴴽�
  sFileName := sFileName+'\UserData.dat';
  if FileExists(sFileName) then begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then begin
      try
        while FileRead(FileHandle, sDealOffInfo, Sizeof(TDealOffInfo)) = Sizeof(TDealOffInfo) do begin// ѭ��������������
          if (sDealOffInfo.sDealCharName <>'') and (sDealOffInfo.sBuyCharName <> '') and ((sDealOffInfo.N = 0) or (sDealOffInfo.N = 1) or (sDealOffInfo.N = 3)) then begin//�ж����ݵ���Ч�� 20081021  ��ʶΪ0 1 3ʱ�Ŷ�ȡ 20090331
            New(DealOffInfo);
            DealOffInfo.sDealCharName:= sDealOffInfo.sDealCharName;
            DealOffInfo.sBuyCharName:= sDealOffInfo.sBuyCharName;
            DealOffInfo.dSellDateTime:= sDealOffInfo.dSellDateTime;
            DealOffInfo.nSellGold:= sDealOffInfo.nSellGold;
            DealOffInfo.UseItems:= sDealOffInfo.UseItems;
            DealOffInfo.N:= sDealOffInfo.N;
            sSellOffItemList.Add(DealOffInfo);
          end;
        end;
      except
      end;
      FileClose(FileHandle);
    end;
  end else begin
    FileHandle := FileCreate(sFileName);
    FileClose(FileHandle);
  end;
end;
//����Ԫ�������б� 20080317
procedure TFrmDB.SaveSellOffItemList();
var
  sFileName: string;
  FileHandle: Integer;
  DealOffInfo: pTDealOffInfo;
  I: Integer;
begin
  sFileName :=  g_Config.sEnvirDir + 'UserData\UserData.dat';
  if FileExists(sFileName) then DeleteFile(sFileName);
  FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then begin
    FileSeek(FileHandle, 0, 0);
    try
      if sSellOffItemList.Count > 0 then begin//20080629
        for I:= 0 to sSellOffItemList.Count -1 do begin
          DealOffInfo:= pTDealOffInfo(sSellOffItemList.Items[I]);
          if DealOffInfo <> nil then begin
            if (DealOffInfo.N = 0) or (DealOffInfo.N = 1) or (DealOffInfo.N = 3) then//20090331
              FileWrite(FileHandle, DealOffInfo^, SizeOf(TDealOffInfo));//20090129 �޸�
          end;
        end;
      end;
    except
    end;
    FileClose(FileHandle);
  end;
end;
//------------------------------------------------------------------------------
//��ȡ��װװ������ 20080225
procedure TFrmDB.LoadSuitItemList();
var
  sFileName, sLineText, nJob: string;
  ItemCount,Note,Name,MaxHP,MaxMP,DC,MaxDC: string;
  MC,MaxMC,SC,MaxSC,AC,MaxAC,MAC,MaxMAC,HitPoint,SpeedPoint: string;
  HealthRecover,SpellRecover,RiskRate,btReserved,btReserved1: string;
  btReserved2,btReserved3,nEXPRATE,nPowerRate,nMagicRate: string;
  nSCRate,nACRate,nMACRate,nAntiMagic,nAntiPoison,nPoisonRecover, nUnBurstRate, nVampirePoint, nCallTrollLevel: string;
  sboTeleport, sboParalysis, sboRevival, sboMagicShield, sboUnParalysis, sboUnRevival, sboUnMagicShield: String;
  sIncDragonRate, sIncNHRate, sIncDragon, sMasterAbility, sboParalysis1, sboParalysis2, sboParalysis3,sboNewHPMPAdd: string;
  LoadList: TStringList;
  SuitItem: pTSuitItem;
  I: Integer;
begin
  sFileName :=  g_Config.sEnvirDir + 'SuitItemList.txt';
  LoadList := TStringList.Create;
  try
    if FileExists(sFileName) then begin
      if g_SuitItemList.Count > 0 then begin//20090301
        for I := 0 to g_SuitItemList.Count - 1 do begin
          if pTSuitItem(g_SuitItemList.Items[I])<> nil then Dispose(pTSuitItem(g_SuitItemList.Items[I]));
        end;
        g_SuitItemList.Clear;
      end;
      
      LoadList.LoadFromFile(sFileName);
      if LoadList.Count > 0 then begin//20080704
        for I := 0 to LoadList.Count - 1 do begin
          sLineText := LoadList.Strings[I];
          sIncDragonRate:='';//��ձ��� 20090516
          sIncNHRate:='';//��ձ��� 20090516
          if (sLineText <> '') and (sLineText[1] <> ';') then begin
            sLineText := GetValidStr3(sLineText, ItemCount, [' ']);
            sLineText := GetValidStr3(sLineText, Note, [' ']);
            sLineText := GetValidStr3(sLineText, Name, [' ']);
            sLineText := GetValidStr3(sLineText, MaxHP, [' ']);
            sLineText := GetValidStr3(sLineText, MaxMP, [' ']);
            sLineText := GetValidStr3(sLineText, DC, [' ']);
            sLineText := GetValidStr3(sLineText, MaxDC, [' ']);
            sLineText := GetValidStr3(sLineText, MC, [' ']);
            sLineText := GetValidStr3(sLineText, MaxMC, [' ']);
            sLineText := GetValidStr3(sLineText, SC, [' ']);
            sLineText := GetValidStr3(sLineText, MaxSC, [' ']);
            sLineText := GetValidStr3(sLineText, AC, [' ']);
            sLineText := GetValidStr3(sLineText, MaxAC, [' ']);
            sLineText := GetValidStr3(sLineText, MAC, [' ']);
            sLineText := GetValidStr3(sLineText, MaxMAC, [' ']);
            sLineText := GetValidStr3(sLineText, HitPoint, [' ']);
            sLineText := GetValidStr3(sLineText, SpeedPoint, [' ']);
            sLineText := GetValidStr3(sLineText, HealthRecover, [' ']);
            sLineText := GetValidStr3(sLineText, SpellRecover, [' ']);
            sLineText := GetValidStr3(sLineText, RiskRate, [' ']);
            sLineText := GetValidStr3(sLineText, btReserved, [' ']);
            sLineText := GetValidStr3(sLineText, btReserved1, [' ']);
            sLineText := GetValidStr3(sLineText, btReserved2, [' ']);
            sLineText := GetValidStr3(sLineText, btReserved3, [' ']);
            sLineText := GetValidStr3(sLineText, nEXPRATE, [' ']);
            sLineText := GetValidStr3(sLineText, nPowerRate, [' ']);
            sLineText := GetValidStr3(sLineText, nMagicRate, [' ']);
            sLineText := GetValidStr3(sLineText, nSCRate, [' ']);
            sLineText := GetValidStr3(sLineText, nACRate, [' ']);
            sLineText := GetValidStr3(sLineText, nMACRate, [' ']);
            sLineText := GetValidStr3(sLineText, nAntiMagic, [' ']);
            sLineText := GetValidStr3(sLineText, nAntiPoison, [' ']);
            sLineText := GetValidStr3(sLineText, nPoisonRecover, [' ']);

            sLineText := GetValidStr3(sLineText, sboTeleport, [' ']);
            sLineText := GetValidStr3(sLineText, sboParalysis, [' ']);
            sLineText := GetValidStr3(sLineText, sboRevival, [' ']);
            sLineText := GetValidStr3(sLineText, sboMagicShield, [' ']);
            sLineText := GetValidStr3(sLineText, sboUnParalysis, [' ']);
            sLineText := GetValidStr3(sLineText, sIncDragonRate, [' ']);
            sLineText := GetValidStr3(sLineText, sIncNHRate, [' ']);
            sLineText := GetValidStr3(sLineText, sboUnRevival, [' ']);
            sLineText := GetValidStr3(sLineText, sboUnMagicShield, [' ']);
            sLineText := GetValidStr3(sLineText, nUnBurstRate, [' ']);
            sLineText := GetValidStr3(sLineText, nVampirePoint, [' ']);
            sLineText := GetValidStr3(sLineText, nCallTrollLevel, [' ']);
            sLineText := GetValidStr3(sLineText, nJob, [' ']);
            sLineText := GetValidStr3(sLineText, sIncDragon, [' ']);
            sLineText := GetValidStr3(sLineText, sMasterAbility, [' ']);
            sLineText := GetValidStr3(sLineText, sboParalysis1, [' ']);
            sLineText := GetValidStr3(sLineText, sboParalysis2, [' ']);
            sLineText := GetValidStr3(sLineText, sboParalysis3, [' ']);
            sLineText := GetValidStr3(sLineText, sboNewHPMPAdd, [' ']);
            if sboParalysis1 = '' then sboParalysis1:= '0';
            if sboParalysis2 = '' then sboParalysis2:= '0';
            if sboParalysis3 = '' then sboParalysis3:= '0';
            if sboUnRevival = '' then sboUnRevival:= '0';
            if sboUnMagicShield = '' then sboUnMagicShield:= '0';
            if (ItemCount <= '') or (Name = '') then Continue;

            New(SuitItem);
            SuitItem.ItemCount := StrToInt(ItemCount);
            SuitItem.Note := Note;
            SuitItem.Name := Name;
            SuitItem.MaxHP:= _MIN(100, Str_ToInt(MaxHP,0));//20080908
            SuitItem.MaxMP:= _MIN(100, Str_ToInt(MaxMP,0));//20080908
            SuitItem.DC:= Str_ToInt(DC,0);//������
            SuitItem.MaxDC:= Str_ToInt(MaxDC,0);
            SuitItem.MC:= Str_ToInt(MC,0);//ħ��
            SuitItem.MaxMC:= Str_ToInt(MaxMC,0);
            SuitItem.SC:= Str_ToInt(SC,0);//����
            SuitItem.MaxSC:= Str_ToInt(MaxSC,0);
            SuitItem.AC:= Str_ToInt(AC,0);//����
            SuitItem.MaxAC:= Str_ToInt(MaxAC,0);
            SuitItem.MAC:= Str_ToInt(MAC,0);//ħ��
            SuitItem.MaxMAC:= Str_ToInt(MaxMAC,0);
            SuitItem.HitPoint:= Str_ToInt(HitPoint,0);//��ȷ��
            SuitItem.SpeedPoint:= Str_ToInt(SpeedPoint,0);//���ݶ�
            SuitItem.HealthRecover:= Str_ToInt(HealthRecover,0); //�����ָ�
            SuitItem.SpellRecover:= Str_ToInt(SpellRecover,0); //ħ���ָ�
            SuitItem.RiskRate:= Str_ToInt(RiskRate,0); //����ֵ
            SuitItem.btReserved:= Str_ToInt(btReserved,0);//��Ѫ(����)
            SuitItem.btReserved1:= Str_ToInt(btReserved1, 0);//������ֵ
            SuitItem.btReserved2:= Str_ToInt(btReserved2, 0);//����
            SuitItem.btReserved3:= Str_ToInt(btReserved3, 0);//����
            SuitItem.nEXPRATE:= Str_ToInt(nEXPRATE,1);//���鱶��

            SuitItem.nPowerRate:= _MAX(10, Str_ToInt(nPowerRate,10));//��������
            SuitItem.nMagicRate:= _MAX(10, Str_ToInt(nMagicRate,10));//ħ������
            SuitItem.nSCRate:= _MAX(10, Str_ToInt(nSCRate,10));//��������
            SuitItem.nACRate:= _MAX(10, Str_ToInt(nACRate,10));//��������
            SuitItem.nMACRate:= _MAX(10,Str_ToInt(nMACRate,10));//ħ������

            SuitItem.nAntiMagic:= Str_ToInt(nAntiMagic,0); //ħ�����
            SuitItem.nAntiPoison:= Str_ToInt(nAntiPoison,0); //������
            SuitItem.nPoisonRecover:= Str_ToInt(nPoisonRecover,0);//�ж��ָ�

            SuitItem.boTeleport := sboTeleport <> '0';//����  20080824
            SuitItem.boParalysis := sboParalysis <> '0';//���
            SuitItem.boRevival := sboRevival <> '0';//����
            SuitItem.boMagicShield := sboMagicShield <> '0';//����
            SuitItem.boUnParalysis := sboUnParalysis <> '0';//�����

            SuitItem.nIncDragonRate:= Str_ToInt(sIncDragonRate, 0);//�ϻ��˺�(����) 20090516
            SuitItem.nIncNHRate:= _MIN(100, Str_ToInt(sIncNHRate, 0));//�����ָ�(����) 20090516
            SuitItem.boUnRevival := sboUnRevival <> '0';//������ 20090909
            SuitItem.boUnMagicShield := sboUnMagicShield <> '0';//������ 20091009
            SuitItem.nUnBurstRate:= Str_ToInt(nUnBurstRate,0);//������
            SuitItem.nVampirePoint:= Str_ToInt(nVampirePoint,0);//��Ѫ����(����װ��)
            SuitItem.nCallTrollLevel:= Str_ToInt(nCallTrollLevel,0);//�ٻ���ħ�ȼ�(������װ)
            SuitItem.nJob:= Str_ToInt(nJob, 3);//ʹ��ְҵ
            SuitItem.nIncDragon:= Str_ToInt(sIncDragon, 0);//�ϻ��˺�����
            SuitItem.nMasterAbility:= Str_ToInt(sMasterAbility, 0);//������
            SuitItem.boParalysis1 := sboParalysis1 <> '0';//ս�����
            SuitItem.boParalysis2 := sboParalysis2 <> '0';//ħ�����
            SuitItem.boParalysis3 := sboParalysis3 <> '0';//ħ�����
            SuitItem.boNewHPMPAdd := (sboNewHPMPAdd = '1') or (sboNewHPMPAdd = '');//��Ѫ��ʽ
            g_SuitItemList.Add(SuitItem);
          end;
        end;//for
      end;
    end else begin
      LoadList.SaveToFile(sFileName);
    end;
  finally
    LoadList.Free;
  end;
end;
//------------------------------------------------------------------------------
{$IF M2Version <> 2}
//��ȡ�ڱ���Ʒ�б� 20100905
procedure TFrmDB.LoadDigJewelItemList;
var
  LoadList,tSaveList: TStringList;
  I, J, II, nCount: Integer;
  sFileName, sStr,sItemName,nItemNum,nItemType,nItemRace:string;
  DigJewelItemInfo: pTDigJewelItemInfo;
  StdItem: pTStdItem;
begin
  sFileName:= g_Config.sEnvirDir + 'DigJewelItem.txt';
  if not FileExists(sFileName) then begin //��������,�򴴽��ļ�
    tSaveList := TStringList.Create;
    tSaveList.Add(';��Ϊ�ڱ���Ʒ�����ļ�(ÿ����Ʒ������������һ����Ʒ)');
    tSaveList.Add(';��Ʒ�� ����(0-��ýƷ��(1-50) 1-��ýƷ��(51-100) 2-��ýƷ��(101-150) 3-��ýƷ��(151-228)) ���� ����(1-65525)');
    tSaveList.Add('����    	0    	50    	3');
    tSaveList.Add('����    	1    	50    	4');
    tSaveList.Add('���ʯ   	2    	50    	5');
    tSaveList.Add('�ڹ�    	3    	50    	6');
    tSaveList.SaveToFile(sFileName);
    tSaveList.Free;
  end;
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        sStr:= Trim(LoadList.Strings[I]);
        if (sStr <> '') and (sStr[1] <> ';') then begin
          sStr := GetValidStr3(sStr, sItemName, [' ',#9]);//��Ʒ��
          sStr := GetValidStr3(sStr, nItemType, [' ',#9]);//��Ʒ����
          sStr := GetValidStr3(sStr, nItemNum, [' ',#9]);//��Ʒ����
          sStr := GetValidStr3(sStr, nItemRace, [' ',#9]);//����
          if (sItemName = '') or (nItemType='') or (nItemNum='') or (nItemRace='') then Continue;
          J:= Str_ToInt(nItemType, 0);//����(0-��ýƷ��(1-50) 1-��ýƷ��(51-100) 2-��ýƷ��(101-150) 3-��ýƷ��(151-228)
          if J < 4 then begin
            II:= Str_ToInt(nItemRace, 65535);//����
            if (II < 65536) and (II > 0) then begin//���Ƽ������ù���
              StdItem := UserEngine.GetStdItem(sItemName);
              if StdItem <> nil then begin//�ж��Ƿ������ݿ������Ʒ
                nCount:= Str_ToInt(nItemNum, 1);
                if nCount > MAXBAGITEM then begin
                  MainOutMessage(Format('�ڱ����ã�[%s]Ϊ���ݿ�����Ʒ,�������ܴ���%d',[sItemName, MAXBAGITEM]));
                  nCount:= MAXBAGITEM;
                end;
                New(DigJewelItemInfo);
                try
                  DigJewelItemInfo.Name:= sItemName;//��Ʒ����
                  DigJewelItemInfo.nItemNum:= nCount;//��Ʒ����
                  DigJewelItemInfo.nItemRace:= II;//����
                  case J of
                    0: g_DigJewelItemList1.Add(DigJewelItemInfo);
                    1: g_DigJewelItemList2.Add(DigJewelItemInfo);
                    2: g_DigJewelItemList3.Add(DigJewelItemInfo);
                    3: g_DigJewelItemList4.Add(DigJewelItemInfo);
                  end;
                except
                  Dispose(DigJewelItemInfo);//��ֹ�쳣���ͷ��ڴ�
                end;
              end else begin//����Ǿ��� ���� ���ʯ ��� �ڹ�
                if (Trim(sItemName)='����') or (Trim(sItemName)='����') or (Trim(sItemName)= g_Config.sGameDiaMond{'���ʯ'}) or
                   (Trim(sItemName)='�ڹ�') or (Trim(sItemName)= g_Config.sGameGird{'���'}) then begin
                  New(DigJewelItemInfo);
                  try
                    nCount:= Str_ToInt(nItemNum, 1);
                    DigJewelItemInfo.Name:= sItemName;//��Ʒ����
                    DigJewelItemInfo.nItemNum:= nCount;//��Ʒ����
                    DigJewelItemInfo.nItemRace:= II;//����
                    case J of
                      0: g_DigJewelItemList1.Add(DigJewelItemInfo);
                      1: g_DigJewelItemList2.Add(DigJewelItemInfo);
                      2: g_DigJewelItemList3.Add(DigJewelItemInfo);
                      3: g_DigJewelItemList4.Add(DigJewelItemInfo);
                    end;
                  except
                    Dispose(DigJewelItemInfo);//��ֹ�쳣���ͷ��ڴ�
                  end;
                end else MainOutMessage(Format('�ڱ����ã���Ʒ[%s]���ݿ��в�����',[sItemName]));
              end;
            end else MainOutMessage(Format('�ڱ����ã���Ʒ[%s]�������ô���[��Χ:1-65535]',[ sItemName]));
          end else MainOutMessage(Format('�ڱ����ã���Ʒ[%s]�������ô���[��Χ:0-3]',[ sItemName]));
        end;
      end;//for
    finally
      LoadList.Free;
    end;
  end;      
end;

//��ȡ������������ 20080502
procedure TFrmDB.LoadRefineItem();
var
  I, K: Integer;
  n1,n11,n2,n22,n3,n33,n4,n44,n5,n55,n6,n66,n7,n77,n8,n88,n9,n99,nA,nAA,nB,nBB,nC,nCC,nD,nDD,nE,nEE: string;
  s18, s20, s24, s25, s26, s27, s28: string;
  LoadList: TStringList;
  sFileName: string;
  List28: TList;
  TRefineItemInfo:pTRefineItemInfo;
begin
  sFileName :=g_Config.sEnvirDir +'RefineItem.txt';
  LoadList := TStringList.Create;
  try
    if FileExists(sFileName) then begin
      if g_RefineItemList.Count > 0 then begin//20090228 ����
        for I := 0 to g_RefineItemList.Count - 1 do begin
          try
            if TList(g_RefineItemList.Objects[I]).Count > 0 then begin
              for K:=0 to TList(g_RefineItemList.Objects[I]).Count -1 do begin
                if pTRefineItemInfo(TList(g_RefineItemList.Objects[I]).Items[K]) <> nil then
                  Dispose(pTRefineItemInfo(TList(g_RefineItemList.Objects[I]).Items[K]));
              end;
            end;
            TList(g_RefineItemList.Objects[I]).Free;
          except
          end;
        end;
        g_RefineItemList.Clear;
      end;

      LoadList.LoadFromFile(sFileName);
      List28 := nil;
      s24 := '';
      for I := 0 to LoadList.Count - 1 do begin
        s18 := Trim(LoadList.Strings[I]);
        if (s18 <> '') and (s18[1] <> ';') then begin
          if s18[1] = '[' then begin
            if List28 <> nil then g_RefineItemList.AddObject(s24, List28);
            List28 := TList.Create;
            ArrestStringEx(s18, '[', ']', s24);//S24-[]�������
          end else begin
            if List28 <> nil then begin
              s18 := GetValidStr3(s18, s20, [' ', #9]);//S20-��Ʒ���� N14-����
              s18 := GetValidStr3(s18, s25, [' ', #9]);//�����ɹ���
              s18 := GetValidStr3(s18, s26, [' ', #9]);//ʧ�ܻ�ԭ��
              s18 := GetValidStr3(s18, s27, [' ', #9]);//����ʯ�Ƿ���ʧ 0-����1�־�,1-��ʧ
              s18 := GetValidStr3(s18, s28, [' ', #9]);//��Ʒ����

              s18 := GetValidStr3(s18, n1,  ['-',',', #9]);//������ֵ���Ѷ�
              s18 := GetValidStr3(s18, n11, ['-',',', #9]);
              s18 := GetValidStr3(s18, n2,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n22, ['-',',', #9]);
              s18 := GetValidStr3(s18, n3,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n33, ['-',',', #9]);
              s18 := GetValidStr3(s18, n4,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n44, ['-',',', #9]);
              s18 := GetValidStr3(s18, n5,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n55, ['-',',', #9]);
              s18 := GetValidStr3(s18, n6,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n66, ['-',',', #9]);
              s18 := GetValidStr3(s18, n7,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n77, ['-',',', #9]);
              s18 := GetValidStr3(s18, n8,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n88, ['-',',', #9]);
              s18 := GetValidStr3(s18, n9,  ['-',',', #9]);
              s18 := GetValidStr3(s18, n99, ['-',',', #9]);
              s18 := GetValidStr3(s18, nA,  ['-',',', #9]);
              s18 := GetValidStr3(s18, nAA, ['-',',', #9]);
              s18 := GetValidStr3(s18, nB,  ['-',',', #9]);
              s18 := GetValidStr3(s18, nBB, ['-',',', #9]);
              s18 := GetValidStr3(s18, nC,  ['-',',', #9]);
              s18 := GetValidStr3(s18, nCC, ['-',',', #9]);
              s18 := GetValidStr3(s18, nD,  ['-',',', #9]);
              s18 := GetValidStr3(s18, nDD, ['-',',', #9]);
              s18 := GetValidStr3(s18, nE,  ['-',',', #9]);
              s18 := GetValidStr3(s18, nEE, ['-',',', #9]);

              if s20 <> '' then begin
                New(TRefineItemInfo);
                TRefineItemInfo.sItemName:= s20;
                TRefineItemInfo.nRefineRate:= Str_ToInt(Trim(s25), 0);
                TRefineItemInfo.nReductionRate:= Str_ToInt(Trim(s26), 0);
                TRefineItemInfo.boDisappear:= Str_ToInt(Trim(s27), 0) = 0;//(T)0-���־� (F)1-��ʧ
                TRefineItemInfo.nNeedRate:= Str_ToInt(Trim(s28), 0);
                TRefineItemInfo.nAttribute[0].nPoints:=Str_ToInt(Trim(n1), 0);
                TRefineItemInfo.nAttribute[0].nDifficult:=Str_ToInt(Trim(n11), 0);
                TRefineItemInfo.nAttribute[1].nPoints:=Str_ToInt(Trim(n2), 0);
                TRefineItemInfo.nAttribute[1].nDifficult:=Str_ToInt(Trim(n22), 0);
                TRefineItemInfo.nAttribute[2].nPoints:=Str_ToInt(Trim(n3), 0);
                TRefineItemInfo.nAttribute[2].nDifficult:=Str_ToInt(Trim(n33), 0);
                TRefineItemInfo.nAttribute[3].nPoints:=Str_ToInt(Trim(n4), 0);
                TRefineItemInfo.nAttribute[3].nDifficult:=Str_ToInt(Trim(n44), 0);
                TRefineItemInfo.nAttribute[4].nPoints:=Str_ToInt(Trim(n5), 0);
                TRefineItemInfo.nAttribute[4].nDifficult:=Str_ToInt(Trim(n55), 0);
                TRefineItemInfo.nAttribute[5].nPoints:=Str_ToInt(Trim(n6), 0);
                TRefineItemInfo.nAttribute[5].nDifficult:=Str_ToInt(Trim(n66), 0);
                TRefineItemInfo.nAttribute[6].nPoints:=Str_ToInt(Trim(n7), 0);
                TRefineItemInfo.nAttribute[6].nDifficult:=Str_ToInt(Trim(n77), 0);
                TRefineItemInfo.nAttribute[7].nPoints:=Str_ToInt(Trim(n8), 0);
                TRefineItemInfo.nAttribute[7].nDifficult:=Str_ToInt(Trim(n88), 0);
                TRefineItemInfo.nAttribute[8].nPoints:=Str_ToInt(Trim(n9), 0);
                TRefineItemInfo.nAttribute[8].nDifficult:=Str_ToInt(Trim(n99), 0);
                TRefineItemInfo.nAttribute[9].nPoints:=Str_ToInt(Trim(nA), 0);
                TRefineItemInfo.nAttribute[9].nDifficult:=Str_ToInt(Trim(nAA), 0);
                TRefineItemInfo.nAttribute[10].nPoints:=Str_ToInt(Trim(nB), 0);
                TRefineItemInfo.nAttribute[10].nDifficult:=Str_ToInt(Trim(nBB), 0);
                TRefineItemInfo.nAttribute[11].nPoints:=Str_ToInt(Trim(nC), 0);
                TRefineItemInfo.nAttribute[11].nDifficult:=Str_ToInt(Trim(nCC), 0);
                TRefineItemInfo.nAttribute[12].nPoints:=Str_ToInt(Trim(nD), 0);
                TRefineItemInfo.nAttribute[12].nDifficult:=Str_ToInt(Trim(nDD), 0);
                TRefineItemInfo.nAttribute[13].nPoints:=Str_ToInt(Trim(nE), 0);
                TRefineItemInfo.nAttribute[13].nDifficult:=Str_ToInt(Trim(nEE), 0);
                List28.Add(TRefineItemInfo);
              end;
            end;
          end;
        end;
      end; // for
      if List28 <> nil then g_RefineItemList.AddObject(s24, List28);
    end else begin
      LoadList.Add(';��Ϊ���������ļ�');
      LoadList.Add(';���������鿴�����ĵ�');
      LoadList.Add(';���������Ʒ �����ɹ����� ʧ�ܻ�ԭ���� ����ʯ�Ƿ���ʧ ������Ʒ���Լ��� ������Ʒ��������');
      LoadList.Add(';[����ʯ+����ͷ��+����ս��]');
      LoadList.Add(';����ħ�� 30 30 0 1 0-5,0-5,0-5,4-5,0-5,0-5,0-5,0-5,0-5,0-5,0-5,0-5,0-5,0-5,');
      LoadList.SaveToFile(sFileName);
    end;
  finally
    LoadList.Free;
  end;
end;

//��ȡ��Ʒ��������
procedure TFrmDB.LoadItemSortListToFile();
  procedure LoadListToFile(sFileName: String; var sList: TList);
  var
    f_H: THandle;
    sItemLevelSort: TItemLevelSort;
    ItemLevelSort: pTItemLevelSort;
  begin
    if FileExists(sFileName) then begin
      f_H := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
      if f_H > 0 then begin
        try
          while FileRead(f_H, sItemLevelSort, Sizeof(TItemLevelSort)) = Sizeof(TItemLevelSort) do begin// ѭ��������������
            if sList.Count >= MAXITEMORDERSCOUNT then Break;
            if (sItemLevelSort.sChrName <> '') and (sItemLevelSort.Item.MakeIndex > 0) then begin
              New(ItemLevelSort);
              Move(sItemLevelSort, ItemLevelSort^, SizeOf(TItemLevelSort));
              sList.Add(ItemLevelSort);
            end;
          end;
        finally
          FileClose(f_H);
        end;
      end;
    end;
  end;
begin
  EnterCriticalSection(HumanSortCriticalSection);
  if not DirectoryExists(g_Config.sSortDir) then CreateDir(g_Config.sSortDir); //Ŀ¼������,�򴴽�
  try
    LoadListToFile(g_Config.sSortDir + 'ArmsSort.DB', g_ArmsSortList);//������
    LoadListToFile(g_Config.sSortDir + 'RingSort.DB', g_RingSortList);//��ָ��
    LoadListToFile(g_Config.sSortDir + 'DreSort.DB', g_DreSortList);//�¼װ�
    LoadListToFile(g_Config.sSortDir + 'ShoesSort.DB', g_ShoesSortList);//ѥ�Ӱ�
    LoadListToFile(g_Config.sSortDir + 'HelmeSort.DB', g_HelmeSortList);//ͷ����
    LoadListToFile(g_Config.sSortDir + 'BootsSort.DB', g_BootsSortList);//������
    LoadListToFile(g_Config.sSortDir + 'NecklaceSort.DB', g_NecklaceSortList);//������
    LoadListToFile(g_Config.sSortDir + 'MedalSort.DB', g_MedalSortList);//ѫ�°�
    LoadListToFile(g_Config.sSortDir + 'BraceletSort.DB', g_BraceletSortList);//�����
    LoadListToFile(g_Config.sSortDir + 'ZhuLiSort.DB', g_ZhuLiSortList);//��������
  finally
    LeaveCriticalSection(HumanSortCriticalSection);
  end;
end;
//������Ʒ��������
procedure TFrmDB.SaveItemSortListToFile();
  procedure SaveListToFile(sFileName: String; var sList: TList);
  var
    FileHandle, I: Integer;
    sItemLevelSort: TItemLevelSort;
    ItemLevelSort: pTItemLevelSort;
  begin
    if FileExists(sFileName) then begin
      FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone);
    end else begin
      FileHandle := FileCreate(sFileName);
    end;
    if FileHandle > 0 then begin
      FileSeek(FileHandle, 0, 0);
      try
        for I:= 0 to sList.Count -1 do begin
          if (I >= MAXITEMORDERSCOUNT) or (sList.Count <= 0) then Break;
          ItemLevelSort:= pTItemLevelSort(sList.Items[I]);
          if ItemLevelSort <> nil then begin
            sItemLevelSort:= ItemLevelSort^;
            FileWrite(FileHandle, sItemLevelSort, SizeOf(TItemLevelSort));
          end;
        end;
      except
        {$IF TESTMODE = 1}
         MainOutMessage('{�쳣} ��Ʒ���б���:'+ sFileName);
        {$IFEND}
      end;
      FileClose(FileHandle);
    end;
  end;
begin
  if g_Config.boUseCanKamPo then begin
    EnterCriticalSection(HumanSortCriticalSection);
    try
      if g_boArmsSortChange then begin
        if (g_mSortIndx = 0) or g_boExitServer then begin
          g_boArmsSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'ArmsSort.DB', g_ArmsSortList);//������
        end;
      end;
      if g_boRingSortChange then begin
        if (g_mSortIndx = 1) or g_boExitServer then begin
          g_boRingSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'RingSort.DB', g_RingSortList);//��ָ��
        end;
      end;
      if g_boDreSortChange then begin
        if (g_mSortIndx = 2) or g_boExitServer then begin
          g_boDreSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'DreSort.DB', g_DreSortList);//�¼װ�
        end;
      end;
      if g_boShoesSortChange then begin
        if (g_mSortIndx = 3) or g_boExitServer then begin
          g_boShoesSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'ShoesSort.DB', g_ShoesSortList);//ѥ�Ӱ�
        end;
      end;
      if g_boHelmeSortChange then begin
        if (g_mSortIndx = 4) or g_boExitServer then begin
          g_boHelmeSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'HelmeSort.DB', g_HelmeSortList);//ͷ����
        end;
      end;
      if g_boBootsSortChange then begin
        if (g_mSortIndx = 5) or g_boExitServer then begin
          g_boBootsSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'BootsSort.DB', g_BootsSortList);//������
        end;
      end;
      if g_boNecklaceSortChange then begin
        if (g_mSortIndx = 6) or g_boExitServer then begin
          g_boNecklaceSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'NecklaceSort.DB', g_NecklaceSortList);//������
        end;
      end;
      if g_boMedalSortChange then begin
        if (g_mSortIndx = 7) or g_boExitServer then begin
          g_boMedalSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'MedalSort.DB', g_MedalSortList);//ѫ�°�
        end;
      end;
      if g_boBraceletSortChange then begin
        if (g_mSortIndx = 8) or g_boExitServer then begin
          g_boBraceletSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'BraceletSort.DB', g_BraceletSortList);//�����
        end;
      end;
      if g_boZhuLiSortChange then begin
        if (g_mSortIndx = 9) or g_boExitServer then begin
          g_boZhuLiSortChange:= False;
          SaveListToFile(g_Config.sSortDir + 'ZhuLiSort.DB', g_ZhuLiSortList);//��������
        end;
      end;
      Inc(g_mSortIndx);
      if g_mSortIndx > 9 then g_mSortIndx:= 0;
    finally
      LeaveCriticalSection(HumanSortCriticalSection);
    end;
  end;
end;
{$IFEND}


procedure TFrmDB.LoadRefineDrumItemList;
var
  I, J, K: Integer;
  sFileName,Str,S1,S2: string;
  sCheckName : string;
  tmpStringList:TStringList;
  pItemInfo:pTRefineDrumItemInfo;
begin
  sFileName :=g_Config.sEnvirDir +'RefineOtherItem.txt';
  if g_RefineDrumItemList=nil then g_RefineDrumItemList:=TStringList.Create;
  tmpStringList:=TStringList.Create;
  if not FileExists(sFileName) then
  begin
    tmpStringList.Add(';��Ϊ�������������ļ�');
    tmpStringList.Add(';���������鿴�����ĵ�');
    tmpStringList.Add(';[���ش���ʯ+ħѪʯ(��)+ħѪʯ(��)=��ҫ��ָ]');
    tmpStringList.Add(';Ԫ�� 20,50 0');
    tmpStringList.Add(';[���ش���ʯ+ħѪʯ(��)+ħѪʯ(��)+ħѪʯ(��)=��ҫͷ��]');
    tmpStringList.Add(';��� 20,50 0');
    tmpStringList.SaveToFile(sFileName);
    Exit;
  end;
   //TasNat ȥ��  2012-03-04 11:46:12
  //if FileExists(not sFileName) then Begin //KK 2012.01.07

  
  //if g_RefineDrumItemList.Count > 0 then
  //  ClearList(g_RefineDrumItemList,False,False);
  //TasNat �޸� By TasNat at: 2012-03-27 12:29:35
  for I := 0 to g_RefineDrumItemList.Count - 1 do
    Dispose(pTRefineDrumItemInfo((g_RefineDrumItemList.Objects[I])));
  g_RefineDrumItemList.Clear;


  try
    tmpStringList.LoadFromFile(sFileName);
    I := 0;
    while I < tmpStringList.Count do
    begin
      Str:=trim(tmpStringList[I]);
      if (Str <> '')  and (Str[1] <> ';') and (Str[1] = '[')then begin
       // ��һ��
        K := Pos(']', Str);//�������ֶ��䷽һ����Ʒ By TasNat at: 2012-04-23 17:58:29
        if K > 0 then
          sCheckName := Copy(Str, K + 1, Length(Str))
        else
          sCheckName := '';
        sCheckName := Trim(sCheckName);
        delete(Str, K + 1, Length(Str));
        ArrestStringEx(Str, '[', ']', Str);
        if Str = '' then begin
          Inc(I);
          Continue;
        end;
        Str := GetValidStr3(Str, S1, ['=']);
        Str := GetValidStr3(Str, S2, ['=']);

        if S1 = '' then begin
          Inc(I);
          Continue;
        end;
        New(pItemInfo);
        FillChar(pItemInfo^, SizeOf(pItemInfo^), 0);
        pItemInfo^.GiveName:=Trim(S2); // ��Ҫ�ϳɵĲ���
        S1 := GetValidStr3(S1, S2, ['+']);
        if S2 <> '' then begin
          pItemInfo^.MainItemName := Trim(S2); //1:������
          S1 := GetValidStr3(S1, S2, ['+']);
          while (S2 <> '') and (pItemInfo.ItemNamesCount < 5) do begin
            pItemInfo^.ItemNames[pItemInfo^.ItemNamesCount] := Trim(S2);
            S1 := GetValidStr3(S1, S2, ['+']);
            Inc(pItemInfo^.ItemNamesCount);
          end;
        end;


        //�ڶ���
        Str := '';
        Inc(I);
        while I < tmpStringList.Count do begin
          Str:=trim(tmpStringList[I]);
          if (Str = '') or (Str[1] = ';') or (Str[1] = '[') then
            Str := ''
          else Break;
          Inc(I);
        end;
        if Str <> '' then begin
          Str := GetValidStr3(Str, S2, [',']);

          Str := GetValidStr3(Str, S1, [' ']);
          pItemInfo^.SuccessRate := 100 - Str_ToInt(Trim(S1), 0); // �ɹ��ı���
          Str := GetValidStr3(Str, S1, [' ']);
          pItemInfo^.FailRate:=Str_ToInt(Trim(S1), 0); // ʧ�ܵ���ʧ��ʽ
          Str := GetValidStr3(Str, S1, [' ']);
          pItemInfo^.boInherit:=Str_ToInt(Trim(S1), 0) = 1; // �Ƿ�̳������ϵļ�������
            while (S2 <> '') and (pItemInfo.sPriceCount < 5) do begin
              S2 := GetValidStr3(S2, S1, [' ']);
              if CompareText(S1, g_Config.sGameGoldName) = 0 then //Ԫ��
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'Y'
              else if CompareText(S1, g_Config.sGameGird) = 0 then //���
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'L'
              else if CompareText(S1, g_Config.sGameGlory) = 0 then //����ֵ
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'R'
              else if CompareText(S1, g_Config.sGamePointName) = 0 then //��Ϸ��
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'P'
              else if CompareText(S1, sSTRING_GOLDNAME) = 0 then //���
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'G'
              else if CompareText(S1, '����') = 0 then //���
                pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := 'S'
              else if Length(S1) = 1 then pItemInfo^.sPriceType[pItemInfo^.sPriceCount] := S1[1];

              S2 := GetValidStr3(S2, S1, [' ']);
              pItemInfo^.nPriceCounts[pItemInfo^.sPriceCount] := Str_ToInt(Trim(S1), 0);
              Inc(pItemInfo^.sPriceCount);
            end;
          if sCheckName = '' then
            sCheckName := pItemInfo^.GiveName;
          if UserEngine.GetStdItem(pItemInfo^.GiveName) = nil then begin
            Memo.Lines.Add('�����������ö�ȡʧ��: ' + pItemInfo^.GiveName + ' ���ݿ��޴���Ʒ.');
            DisPose(pItemInfo);
          end else
          g_RefineDrumItemList.AddObject(sCheckName, TObject(pItemInfo));
        end else DisPose(pItemInfo);//DisPoseAndNil(pItemInfo); SB �ֲ�����NIL ��ë�� By TasNat at: 2012-03-17 17:21:56
      end;
      Inc(I);
    end;
  finally
    tmpStringList.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TFrmDB.LoadMonFireDragonGuard();//�����ػ��޲�д���б� 20090111
var
  sFileName, s18, s20, s24, s28, s2C, s30, s34, s38: string;
  LoadList: TStringList;
  Monster: TBaseObject;
  I: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'FireDragonGuard.txt';
  if not FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.Add(';����        ��ͼ    x    y  dir(0-1)  ��������x  ��������Y(����Ϊ�����|�ָ�) ');
      LoadList.Add('�����ػ���  D2083    51,67  1  77,50|74,50|83,50|80,53|86,53|74,41|71,41|71,44|71,47');
      LoadList.Add('�����ػ���  D2083    48,70  1  81,44|81,47|78,44|75,44|84,47|78,41|75,41|81,50|84,50');
      LoadList.Add('�����ػ���  D2083    45,73  1  81,44|84,47|78,41|85,50|75,41|76,51|79,54|73,48');
      LoadList.Add('�����ػ���  D2083    61,78  0  79,48|79,51|76,48|78,53|75,50|76,45|82,51|81,44|84,47|78,41');
      LoadList.Add('�����ػ���  D2083    58,81  0  79,48|82,51|85,54|76,45|71,40|82,48|79,45|76,42|85,51|73,42');
      LoadList.Add('�����ػ���  D2083    55,84  0  80,48|77,48|80,45|77,51|74,51|74,54|71,54|71,57');
      LoadList.SaveToFile(sFileName);
    finally
      LoadList.Free;
    end;
  end;
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sFileName);
      for I := 0 to LoadList.Count - 1 do begin
        s18 := Trim(LoadList.Strings[I]);
        if (s18 <> '') and (s18[1] <> ';') then begin
          s18 := GetValidStrCap(s18, s20, [' ', #9]);//����
          s18 := GetValidStr3(s18, s28, [' ', #9]);//��ͼ
          s18 := GetValidStr3(s18, s24, [' ', #9]);//����
          s30 := GetValidStr3(s24, s2C, [',', #9]);//X,Y
          s18 := GetValidStr3(s18, s34, [' ', #9]);//����
          s18 := GetValidStr3(s18, s38, [' ', #9]);//��������
          if (s20 <> '') and (s28 <> '') then begin
            Monster:= UserEngine.RegenMonsterByName(s28, Str_ToInt(s2C, 0), Str_ToInt(s30, 0), s20);
            if Monster <> nil then begin
              if Monster.m_btRaceServer = 129 then begin//�ػ��޲ż����б�
                Monster.m_btDirection:= Str_ToInt(s34, 0);
                TFireDragonGuard(Monster).s_AttickXY:= s38;
                //UserEngine.m_MonObjectList.Add(Monster);
              end else Monster.Free;
            end;
          end;
        end;
      end;
    finally
      LoadList.Free;
    end;
  end;
end;
//��ȡ���а����� 20100615
procedure TFrmDB.LoadSortList();
  procedure LoadHumToFile(sFile:String;var Taxis:THumSort);
  var
    nFileHandle:integer;
  begin
    FillChar(Taxis,SizeOf(THumSort),#0);
    if FileExists(sFile) then begin
      nFileHandle:=FileOpen(sFile,fmOpenRead or fmShareDenyNone);
      if nFileHandle > 0 then begin
        Try
          FileSeek(nFileHandle,0,0);
          FileRead(nFileHandle,Taxis,SizeOf(THumSort));
        Finally
          FileClose(nFileHandle);
        end;
      end;
    end;
  end;
  procedure LoadHeroToFile(sFile:String;var Taxis:THeroSort);
  var
    nFileHandle:integer;
  begin
    FillChar(Taxis,SizeOf(THeroSort),#0);
    if FileExists(sFile) then begin
      nFileHandle:=FileOpen(sFile,fmOpenRead or fmShareDenyNone);
      if nFileHandle > 0 then begin
        Try
          FileSeek(nFileHandle,0,0);
          FileRead(nFileHandle,Taxis,SizeOf(THeroSort));
        Finally
          FileClose(nFileHandle);
        end;
      end;
    end;
  end;
begin
  EnterCriticalSection(HumanSortCriticalSection);
  try
    Try
      LoadHumToFile(g_Config.sSortDir + 'AllHum.DB',g_TaxisAllList);
      LoadHumToFile(g_Config.sSortDir + 'WarrHum.DB',g_TaxisWarrList);
      LoadHumToFile(g_Config.sSortDir + 'WizardHum.DB',g_TaxisWaidList);
      LoadHumToFile(g_Config.sSortDir + 'TaosHum.DB',g_TaxisTaosList);
      {$IF HEROVERSION = 1}
      LoadHeroToFile(g_Config.sSortDir + 'AllHero.DB',g_HeroAllList);
      LoadHeroToFile(g_Config.sSortDir + 'WarrHero.DB',g_HeroWarrList);
      LoadHeroToFile(g_Config.sSortDir + 'WizardHero.DB',g_HeroWaidList);
      LoadHeroToFile(g_Config.sSortDir + 'TaosHero.DB',g_HeroTaosList);
      {$IFEND}
      LoadHumToFile(g_Config.sSortDir + 'Master.DB',g_MasterList);
    except
      MainOutMessage(Format('{%s} TFrmDB.LoadTaxisList',[g_sExceptionVer]));
    end;
  finally
    LeaveCriticalSection(HumanSortCriticalSection);
  end;
end;

//------------------------------------------------------------------------------

//���ַ����ӽ��ܺ���,ʵ��û��ʹ������㷨 20071225
Function EncryptText(Text: String): String;
  function EncryptKey(key: string): string;//���ܺ���
  var i: Integer;
  begin
    for i:=1 to length(key) do
      result := result + chr(ord(key[i]) xor length(key)*i*i)
  end;
Var str: string;
Begin
  Str:=EncryptKey(Text);
  Result := Text;
End;

function DeCodeString(sSrc: string): string;
var
  Dest: array[0..1024 * 2] of Char;
begin
  if (sSrc = '') or (Length(sSrc) > 2048) then Exit;//20081203 ��ֹ����Խ��
  if (nDeCryptString >= 0) and Assigned(PlugProcArray[nDeCryptString].nProcAddr) then begin
    FillChar(Dest, SizeOf(Dest), 0);
    TDeCryptString(PlugProcArray[nDeCryptString].nProcAddr)(@sSrc[1], @Dest, Length(sSrc));
    Result := StrPas(PChar(@Dest));
    Exit;
  end;
  Result := sSrc;
end;
//�ű�����
function TFrmDB.DeCodeStringList(StringList: TStringList): Boolean;
var
  I: Integer;
  sLine: string;
begin
  Result := False;
  if StringList.Count > 0 then begin
    sLine := StringList.Strings[0];
    if not CompareLStr(sLine, sENCYPTSCRIPTFLAG, 18) then Exit;
  end;

  for I := 0 to StringList.Count - 1 do begin
    sLine := StringList.Strings[I];
    sLine := DeCodeString(sLine);
    sLine := EncryptText(sLine);
    sLine := addStringList(sLine);//20080217 �ű����ܺ���,SystemModule.dll���
    StringList.Strings[I] := sLine;
  end;
  Result := True;
end;

//��ҵ��ű���� �ɽ�QF֮��ű� 20100918
function TFrmDB.SetStringList(StringList: TStringList): Boolean;
var
  I: Integer;
  sLine: string;
begin
  Result := False;
  if StringList.Count > 0 then begin
    sLine := StringList.Strings[0];
    if not CompareLStr(sLine, sENCYPTSCRIPTFLAG, 18) then begin
      Exit;
    end;
  end;
  if (nGetIPString >= 0) and Assigned(PlugProcArray[nGetIPString].nProcAddr) then begin
    if TGetIPString(PlugProcArray[nGetIPString].nProcAddr) then begin//��ҵ����
      for I := 0 to StringList.Count - 1 do begin
        sLine := StringList.Strings[I];
        sLine := DeCodeString(sLine);
        sLine := EncryptText(sLine);
        sLine := addStringList(sLine);//�ű����ܺ���,SystemModule.dll���
        StringList.Strings[I] := sLine;
      end;
    end;
  end;
  Result := True;
end;

constructor TFrmDB.Create();
begin
  CoInitialize(nil);

{$IF DBTYPE = BDE}
  Query := TQuery.Create(nil);
{$ELSE}
  Query := TADOQuery.Create(nil);
{$IFEND}
end;

destructor TFrmDB.Destroy;
begin
  Query.Free;
  CoUnInitialize;
  inherited;
end;

initialization
  begin
    nDeCryptString := AddToPulgProcTable(Base64DecodeStr('RGVDcnlwdFN0cmluZw=='),0);//DeCryptString  20080303
    nGetIPString := AddToPulgProcTable(Base64DecodeStr('R2V0SVBIYW5kbGU='),7);//GetIPHandle ��ҵ��ű���� �ɽ�QF֮��ű�
  end;

finalization
  begin

  end;

end.
