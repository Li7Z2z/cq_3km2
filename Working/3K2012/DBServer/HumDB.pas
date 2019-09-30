unit HumDB;

interface
uses
  Windows, Classes, SysUtils, Forms, MudUtil, Grobal2, DBShare{$IF DBSMode = 1}, DB, ADODB, ActiveX, Variants{$IFEND};
resourcestring
  sDBHeaderDesc = '3K�������ݿ��ļ� 2011/03/11';
  sDBIdxHeaderDesc = '3K�������ݿ������ļ� 2011/03/11';
const
  nDBVersion = 20110311;//DB�汾��
  MAX_STATUS_ATTRIBUTE = 12;
  //MAXPATHLEN = 255;
  //DIRPATHLEN = 80;
  //MapNameLen = 16;
  //ActorNameLen = 14;
  //�������еİ�ȫ�� By TasNat at: 2012-03-09 12:57:50
type
  TDBHeader = packed record //Size 124
    sDesc: string[$23]; //0x00    36
    n24: Integer; //0x24
    n28: Integer; //0x28
    n2C: Integer; //0x2C
    n30: Integer; //0x30
    n34: Integer; //0x34
    n38: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40
    n44: Integer; //0x44
    n48: Integer; //0x48
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    nLastIndex: Integer; //��������
    dLastDate: TDateTime; //����˵�����
    nHumCount: Integer; //��ɫ����
    n6C: Integer; //0x6C
    n70: Integer; //DB�汾��
    dUpdateDate: TDateTime; //��������
  end;
  pTDBHeader = ^TDBHeader;

  TIdxHeader = packed record //Size 124
    sDesc: string[39]; //0x00
    n2C: Integer; //0x2C
    n30: Integer; //0x30
    n34: Integer; //0x34
    n38: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40
    n44: Integer; //0x44
    n48: Integer; //0x48
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    n5C: Integer; //0x5C
    n60: Integer; //0x60  95
    n70: Integer; //DB�汾��
    nQuickCount: Integer; //0x74  100
    nHumCount: Integer; //0x78
    nDeleteCount: Integer; //0x7C
    nLastIndex: Integer; //0x80
    dUpdateDate: TDateTime; //��������
  end;
  pTIdxHeader = ^TIdxHeader;

  THumInfo = packed record //Size 72  ��ɫ����
    Header: TRecordHeader;
    sChrName: string[14]; //0x14  //��ɫ����   44
    sAccount: string[10]; //�˺�
    boDeleted: Boolean; //�Ƿ�ɾ��
    bt1: Byte; //δʹ��
    dModDate: TDateTime;//��������
    btCount: Byte; //�����ƴ�
    boSelected: Boolean; //�Ƿ���ѡ�������
    n6: array[0..5] of Byte;//δʹ��
  end;
  pTHumInfo = ^THumInfo;

  TIdxRecord = record
    sChrName: string[15];
    nIndex: Integer;
  end;
  pTIdxRecord = ^TIdxRecord;
  
  TFileHumDB = class
    m_QuickList: TQuickList;
    m_OnChange: TNotifyEvent;
    m_boChanged: Boolean;
    m_QuickIDList: TQuickIDList;
    {$IF DBSMode = 1}
    m_nRecordCount: Integer;
    ADOConnection: TADOConnection;
    DBQry: TADOQuery;
    {$ELSE}
    m_sDBFileName: string; //���ݿ��ļ���
    n4: Integer;
    m_nFileHandle: Integer; //�ļ����
    m_Header: TDBHeader;
    m_DeletedList: TList; //�ѱ�ɾ���ļ�¼��
    {$IFEND}
  private
    procedure LoadQuickList;
    procedure Lock;
    procedure UnLock;
    function GetRecord(n08: Integer; var HumDBRecord: THumInfo): Boolean;//ȡ�ü�¼
    {$IF DBSMode = 1}
    function UpdateRecord(nIndex: Integer; HumRecord: THumInfo; btFlag: Byte): boolean;//���¼�¼
    {$ELSE}
    function UpdateRecord(nIndex: Integer; HumRecord: THumInfo; boNew: Boolean): Boolean;//���¼�¼
    function DeleteRecord(nIndex: Integer): Boolean;//ɾ����¼
    {$IFEND}
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    function Open(boRead : Boolean = False): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function FindByName(sChrName: string; ChrList: TStringList): Integer;
    function FindByAccount(sAccount: string; var ChrList: TStringList): Integer;
    function ChrCountOfAccount(sAccount: string): Integer;//����ָ���˺ŵĽ�ɫ����
    function HeroChrCountOfAccount(sAccount: string): Integer;//�����˺Ž�ɫ��Ӣ������
    function Add(HumRecord: THumInfo): Boolean;
    function Delete(sName: string): Boolean;

    function Get(sChrName: string; var HumDBRecord: THumInfo): Integer; overload;
    function Get(n08: Integer; var HumDBRecord: THumInfo): Integer; overload;

    function GetBy(sChrName: string; var HumDBRecord: THumInfo): Boolean; overload;
    function GetBy(n08: Integer; var HumDBRecord: THumInfo): Boolean; overload;
    
    function Update(sChrName: string; var HumDBRecord: THumInfo): Boolean; overload;
    function Update(nIndex: Integer; var HumDBRecord: THumInfo): Boolean; overload;
    {$IF DBSMode = 1}
    function Query(SQL: string): Boolean;
    function Edit(SQL: string): Boolean;
    {$ELSE}
    function OpenEx(boRead : Boolean = False): Boolean;
    function UpdateBy(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
    {$IFEND}
  end;
  TFileDB = class
    n4: Integer; //0x4
    m_nFileHandle: Integer; //0x08
    nC: Integer;
    m_OnChange: TNotifyEvent; //0x10
    m_boChanged: Boolean; //0x18
    m_nLastIndex: Integer; //0x1C
    m_dUpdateTime: TDateTime; //0x20
    m_QuickList: TQuickList; //0xA4
    m_sDBFileName: string; //0xAC
    m_sIdxFileName: string; //0xB0
    {$IF DBSMode = 1}
    m_nRecordCount: Integer;
    ADOConnection: TADOConnection;
    DBQry: TADOQuery;
    DBQry1: TADOQuery;
    {$ELSE}
    m_Header: TDBHeader; //0x28
    m_DeletedList: TList; //0xA8 �ѱ�ɾ���ļ�¼��
    {$IFEND}
  private
    {$IF DBSMode = 1}
    function GetRecord(nIndex: Integer; HumanRCD: pTHumDataInfo): boolean;
    function GetRecordToOrders(nIndex: Integer; HumanRCD: pTHumDataInfo): boolean;
    function UpdateRecord(nIndex: Integer; HumanRCD: pTHumDataInfo; btFlag: Byte): boolean;
    {$ELSE}
    function LoadDBIndex(): Boolean;
    procedure SaveIndex();//��������
    function GetRecord(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;//��ü�¼
    function UpdateRecord(nIndex: Integer; var HumanRCD: THumDataInfo; boNew: Boolean): Boolean;//�޸ļ�¼
    {$IFEND}
    procedure LoadQuickList;
    function DeleteRecord(nIndex: Integer): Boolean;//ɾ����¼
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open(boRead : Boolean = False): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function Find(sChrName: string; List: TStrings): Integer;
    procedure Rebuild();//�ؽ�
    function Count(): Integer;//����
    function Delete(sChrName: string): Boolean; overload;
    function Delete(nIndex: Integer): Boolean; overload;
    {$IF DBSMode = 1}
    function Query(SQL: string): Boolean;
    function Edit(SQL: string): Boolean;
    function Get(nIndex: Integer; HumanRCD: pTHumDataInfo): Integer;
    function GetToOrders(nIndex: Integer; HumanRCD: pTHumDataInfo): Integer;
    function Update(nIndex: Integer; HumanRCD: pTHumDataInfo; btFlag: Byte): Boolean;
    function Add(HumanRCD: pTHumDataInfo): Boolean;
    procedure GetHumRanking(nMinLevel, nMaxLevel, nJob: Integer; var RankingList: TQuickPointList);
    procedure GetHeroRanking(nMinLevel, nMaxLevel, nJob: Integer; var RankingList: TQuickPointList);
    procedure GetMasterRanking(nMinLevel, nMaxLevel: Integer; var RankingList: TQuickPointList);
    procedure GetAutoAddExpPlay(nPlayCount, nMaxLevel: Integer; var LoadList: TStringList);//ȡ�һ�����
    {$ELSE}
    function OpenEx(boRead : Boolean = False): Boolean;
    function Get(nIndex: Integer; var HumanRCD: THumDataInfo): Integer;
    function Update(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;
    function Add(var HumanRCD: THumDataInfo): Boolean;
    {$IFEND}
  end;

  TFileHeroDB = class//�������ݲ�����
    n4: Integer; //0x4
    m_nFileHandle: Integer; //0x08
    nC: Integer;
    m_OnChange: TNotifyEvent; //0x10
    m_boChanged: Boolean; //0x18
    m_nLastIndex: Integer; //0x1C
    m_dUpdateTime: TDateTime; //0x20
    m_QuickList: TQuickList; //0xA4
    m_sDBFileName: string; //0xAC
    {$IF DBSMode = 1}
    m_nRecordCount: Integer;
    ADOConnection: TADOConnection;
    DBQry: TADOQuery;    
    {$ELSE}
    m_Header: TDBHeader; //0x28
    m_DeletedList: TList; //�ѱ�ɾ���ļ�¼��
    m_sIdxFileName: string; //0xB0
    {$IFEND}
  private
    {$IF DBSMode = 1}
    function GetRecord(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Boolean;//��ü�¼
    function UpdateRecord(nIndex: Integer; HumanRCD: pTNewHeroDataInfo; boNew: Boolean): Boolean;//�޸ļ�¼
    {$ELSE}
     function LoadDBIndex(): Boolean;
     function GetRecord(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Boolean;//��ü�¼
     function UpdateRecord(nIndex: Integer; var HumanRCD: TNewHeroDataInfo; boNew: Boolean): Boolean;//�޸ļ�¼
    {$IFEND}
    procedure LoadQuickList;
    function DeleteRecord(nIndex: Integer): Boolean;//ɾ����¼
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open(boRead : Boolean = False): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function Find(sChrName: string; List: TStrings): Integer;
    procedure Rebuild();//�ؽ�
    function Count(): Integer;//����
    function Delete(sChrName: string): Boolean; overload;
    function Delete(nIndex: Integer): Boolean; overload;
    {$IF DBSMode = 1}
    function Get(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Integer;
    function Update(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Boolean;
    function Add(HumanRCD: pTNewHeroDataInfo): Boolean;
    {$ELSE}
    function OpenEx(boRead : Boolean = False): Boolean;
    function Get(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Integer;
    function Update(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Boolean;
    function Add(var HumanRCD: TNewHeroDataInfo): Boolean;
    {$IFEND}
  end;

(*  TFileHumHeroDB = class//�����븱���������ݲ�����
    n4: Integer; //0x4
    m_nFileHandle: Integer; //0x08
    nC: Integer;
    m_OnChange: TNotifyEvent; //0x10
    m_boChanged: Boolean; //0x18
    m_nLastIndex: Integer; //0x1C
    m_dUpdateTime: TDateTime; //0x20
    m_QuickList: TQuickList; //0xA4
    m_sDBFileName: string; //0xAC
    m_Header: TDBHeader; //0x28
    m_DeletedList: TList; //�ѱ�ɾ���ļ�¼��
    m_sIdxFileName: string; //0xB0
  private
    function LoadDBIndex(): Boolean;
    function GetRecord(nIndex: Integer; var HumanRCD: THeroNameInfo): Boolean;//��ü�¼
    function UpdateRecord(nIndex: Integer; var HumanRCD: THeroNameInfo; boNew: Boolean): Boolean;//�޸ļ�¼
    procedure LoadQuickList;
    function DeleteRecord(nIndex: Integer): Boolean;//ɾ����¼
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open(): Boolean;
    procedure Close();
    function Index(sName: string): Integer;
    function Find(sChrName: string; List: TStrings): Integer;
    procedure Rebuild();//�ؽ�
    function Count(): Integer;//����
    function Delete(sChrName: string): Boolean; overload;
    function Delete(nIndex: Integer): Boolean; overload;
    function OpenEx(): Boolean;
    function Get(nIndex: Integer; var HumanRCD: THeroNameInfo): Integer;
    function Update(nIndex: Integer; var HumanRCD: THeroNameInfo): Boolean;
    function Add(var HumanRCD: THeroNameInfo): Boolean;
  end;     *)

var
  HumChrDB: TFileHumDB;//'Hum.DB'
  HumDataDB: TFileDB;//'Mir.DB'
  HeroDataDB: TFileHeroDB;//'HeroMir.DB' ��������
(*  {$IF DBSMode = 0}
  HumHeroDB: TFileHumHeroDB;//'HumHero.DB' �����Ӧ������������
  {$IFEND} *)
implementation

uses HUtil32;
{$IF DBSMode = 1}
const
  SQLDTFORMAT = {'mm"/"dd"/"yyyy hh":"nn":"ss'}'yyyy"-"mm"-"dd hh":"nn":"ss';
{$IFEND}
{ TFileHumDB }

constructor TFileHumDB.Create(sFileName: string);
begin
{$IF DBSMode = 1}
  inherited Create;
  CoInitialize(nil);

  m_QuickList := TQuickList.Create;
  m_QuickIDList := TQuickIDList.Create;
  m_QuickList.boCaseSensitive := False;
  m_boChanged := False;
  m_nRecordCount := -1;
  boHumDBReady := False;
  n4ADAFC := 0;
  n4ADB04 := 0;
  ADOConnection := TADOConnection.Create(nil);
  DBQry := TADOQuery.Create(nil);

  ADOConnection.ConnectionString := sFileName;
  ADOConnection.LoginPrompt := False;
  ADOConnection.KeepConnection := True;
  ADOConnection.CommandTimeout := 20;
  ADOConnection.ConnectionTimeout := 10;

  DBQry.Connection := ADOConnection;
  DBQry.Prepared := True;

  try
    ADOConnection.Connected := True;
    LoadQuickList;
  except
    MainOutMessage('[����] SQL ����ʧ�ܣ�����SQL����...');
  end;
{$ELSE}
  m_sDBFileName := sFileName;
  m_QuickList := TQuickList.Create;
  m_QuickIDList := TQuickIDList.Create;
  m_DeletedList := TList.Create;
  n4ADAFC := 0;
  n4ADB04 := 0;
  boHumDBReady := False;
  LoadQuickList();
{$IFEND}
end;
destructor TFileHumDB.Destroy;
begin
  m_QuickList.Free;
  m_QuickIDList.Free;
{$IF DBSMode = 1}
  DBQry.Free;
  ADOConnection.Free;
  CoUnInitialize;
{$IFEND}
  inherited;
end;

procedure TFileHumDB.Lock();
begin
  EnterCriticalSection(HumDB_CS);
end;

procedure TFileHumDB.UnLock();
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileHumDB.Open(boRead : Boolean = False): Boolean;
begin
{$IF DBSMode = 1}
  Result := False;
  Lock();
  m_boChanged := False;
  Result := True;
{$ELSE}
  Lock();
  n4 := 0;
  m_boChanged := False;
  if FileExists(m_sDBFileName) then begin
    if boRead then
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then  //����ļ����ڣ����ȡ����
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  end else begin //0x0048B999
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.n70 := nDBVersion;
      m_Header.nHumCount := 0;
      m_Header.n6C := 0;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
{$IFEND}
end;

procedure TFileHumDB.Close;
begin
{$IF DBSMode = 0}
  FileClose(m_nFileHandle);
{$IFEND}
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;
{$IF DBSMode = 1}
procedure TFileHumDB.LoadQuickList;
var
  nRecordIndex, nIndex, nSelectID: Integer;
  boDeleted, boIsHero: Boolean;
  sAccount, sChrName: string;
resourcestring
  sSQL = 'SELECT * FROM TBL_CHARACTER where FLD_DELETED = 0';
begin
  m_QuickList.Clear;
  m_QuickIDList.Clear;
  nRecordIndex := 0;
  n4ADAFC := 0;
  n4ADB00 := 0;
  n4ADB04 := 0;
  Lock;
  try
    try
      DBQry.SQL.Clear;
      DBQry.SQL.Add(sSQL);
      try
        DBQry.Open;
      except
        MainOutMessage('[�쳣] TFileHumDB.LoadQuickList');
      end;

      m_nRecordCount := DBQry.RecordCount;
      n4ADB04 := m_nRecordCount;

      for nIndex := 0 to m_nRecordCount - 1 do begin
        Inc(n4ADAFC);
        boDeleted := DBQry.FieldByName('FLD_DELETED').AsBoolean;
        if not boDeleted then begin
          sAccount := Trim(DBQry.FieldByName('FLD_LOGINID').AsString);
          sChrName := Trim(DBQry.FieldByName('FLD_CHARNAME').AsString);
          nSelectID := DBQry.FieldByName('FLD_SELECTID').AsInteger;
          boIsHero := DBQry.FieldByName('FLD_ISHERO').AsBoolean;
          m_QuickList.AddObject(sChrName, TObject(nRecordIndex));
          m_QuickIDList.AddRecord(sAccount, sChrName, nRecordIndex, nSelectID, boIsHero);
          if (nIndex mod 100) = 0 then Application.ProcessMessages;
          Inc(n4ADB00);
        end;
        Inc(nRecordIndex);
        DBQry.Next;
      end;
    finally
      DBQry.Close;
    end;
  finally
    UnLock;
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  boHumDBReady := True;
end;

function TFileHumDB.GetRecord(n08: Integer; var HumDBRecord: THumInfo): boolean;
var
  sChrName: string;
resourcestring
  sSQL = 'SELECT * FROM TBL_CHARACTER WHERE FLD_CHARNAME=''%s''';
begin
  Result := False;
  sChrName := m_QuickList[n08];
  try
    DBQry.SQL.Clear;
    DBQry.SQL.Add(Format(sSQL, [sChrName]));
    try
      DBQry.Open;
    except
      MainOutMessage('[�쳣] TFileHumDB.GetRecord');
      Exit;
    end;
    if DBQry.RecordCount > 0 then begin
      HumDBRecord.sChrName := sChrName;
      HumDBRecord.sAccount := Trim(DBQry.FieldByName('FLD_LOGINID').AsString);
      HumDBRecord.Header.nSelectID := DBQry.FieldByName('FLD_SELECTID').AsInteger;
      HumDBRecord.boSelected := DBQry.FieldByName('FLD_SELECTED').AsBoolean;
      HumDBRecord.Header.boIsHero := DBQry.FieldByName('FLD_ISHERO').AsBoolean;
      HumDBRecord.btCount := DBQry.FieldByName('FLD_COUNT').AsInteger;
      HumDBRecord.Header.dCreateDate := DBQry.FieldByName('FLD_CREATEDATE').AsDateTime;
      HumDBRecord.dModDate := DBQry.FieldByName('FLD_MODDATE').AsDateTime;
      HumDBRecord.boDeleted := DBQry.FieldByName('FLD_DELETED').AsBoolean;
      Result := True;
    end;
  finally
    DBQry.Close;
  end;
end;

function TFileHumDB.Query(SQL: string): Boolean;
begin
  Result := False;
  try
    DBQry.Close;
    DBQry.SQL.Clear;
    DBQry.SQL.Add(SQL);
    try
      DBQry.Open;
      Result := True;
    except
      on E: Exception do begin
        Result := False;
        MainOutMessage('[�쳣] TFileHumDB.Query');
      end;
    end;
  finally
    //DBQry.Close;
  end;
end;

function TFileHumDB.Edit(SQL: string): Boolean;
begin
  Result := False;
  try
    DBQry.SQL.Clear;
    DBQry.SQL.Add(SQL);
    try
      DBQry.ExecSQL;
      Result := True;
    except
      on E: Exception do begin
        Result := False;
        MainOutMessage('[�쳣] TFileHumDB.Edit');
      end;
    end;
  finally
    DBQry.Close;
  end;
end;

function TFileHumDB.UpdateRecord(nIndex: Integer; HumRecord: THumInfo; btFlag: Byte): boolean;
var
  sdt: string;
begin
  Result := True;
  sdt := FormatDateTime(SQLDTFORMAT, Now);
  try
    DBQry.SQL.Clear;

    case btFlag of
      1: begin // New
          DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER(FLD_CHARNAME, FLD_LOGINID, FLD_SELECTID, FLD_SELECTED, FLD_ISHERO, FLD_COUNT, FLD_CREATEDATE, FLD_LASTUPDATE, FLD_MODDATE, FLD_DELETED) ' +
            'VALUES( ''%s'', ''%s'', %d, %d, %d, %d, ''%s'', ''%s'', ''%s'', 0)',
            [HumRecord.sChrName,
            HumRecord.sAccount,
              HumRecord.Header.nSelectID,
              BoolToInt(HumRecord.boSelected),
              BoolToInt(HumRecord.Header.boIsHero),
              HumRecord.btCount,
              sdt,
              sdt,
              sdt]));
          try
            DBQry.ExecSQL;
          except
            Result := False;
            MainOutMessage('[�쳣] TFileHumDB.UpdateRecord (1)');
            Exit;
          end;
        end;

      2: begin // Delete
          DBQry.SQL.Add(Format('UPDATE TBL_CHARACTER SET FLD_DELETED=1, FLD_MODDATE=''%s'' WHERE FLD_CHARNAME=''%s''', [sdt, HumRecord.sChrName]));
          try
            DBQry.ExecSQL;
          except
            Result := False;
            MainOutMessage('[�쳣] TFileHumDB.UpdateRecord (3)');
          end;
        end;

      3: begin // Delete
          DBQry.SQL.Add(Format('Delete From TBL_CHARACTER WHERE FLD_CHARNAME=''%s''', [HumRecord.sChrName]));
          try
            DBQry.ExecSQL;
          except
            Result := False;
            MainOutMessage('[�쳣] TFileHumDB.UpdateRecord (4)');
          end;
        end;

    else begin //General Update
        DBQry.SQL.Add(Format('UPDATE TBL_CHARACTER SET FLD_SELECTID=%d, FLD_SELECTED=%d, ' +
          'FLD_COUNT=%d, FLD_LASTUPDATE=''%s'', FLD_DELETED=%d,FLD_MODDATE=''%s'' WHERE FLD_CHARNAME=''%s''',
          [HumRecord.Header.nSelectID,
          BoolToInt(HumRecord.boSelected),
            HumRecord.btCount,
            sdt,
            BoolToInt(HumRecord.boDeleted),
            sdt,
            HumRecord.sChrName]));
        try
          DBQry.ExecSQL;
        except
          Result := False;
          MainOutMessage('[�쳣] TFileHumDB.UpdateRecord (5)');
          Exit;
        end;
      end;
    end;

    m_boChanged := True;
  finally
    DBQry.Close;
  end;
end;

{$ELSE}
procedure TFileHumDB.LoadQuickList();
var
  nRecordIndex: Integer;
  nIndex: Integer;
  AccountList: TStringList;
  ChrNameList: TStringList;
  DBHeader: TDBHeader;
  DBRecord: THumInfo;
begin
  n4 := 0;
  m_QuickList.Clear;
  m_QuickIDList.Clear;
  m_DeletedList.Clear;
  nRecordIndex := 0;
  n4ADAFC := 0;
  n4ADB00 := 0;
  n4ADB04 := 0;
  AccountList := TStringList.Create;
  ChrNameList := TStringList.Create;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADB04 := DBHeader.nHumCount;
        if DBHeader.nHumCount > 0 then begin//20090101
          for nIndex := 0 to DBHeader.nHumCount - 1 do begin
            Inc(n4ADAFC);
            if FileRead(m_nFileHandle, DBRecord, SizeOf(THumInfo)) <> SizeOf(THumInfo) then break;
            if not DBRecord.Header.boDeleted then begin
              if m_QuickList.GetIndex(DBRecord.Header.sName) >= 0 then begin//�����ظ�����ʾ 20090305
                MainOutMessage(Format('��ɫ���ظ���%s(%s)',[DBRecord.Header.sName, DBRecord.sAccount]));
                Continue;//���� 20090305
              end;
              m_QuickList.AddObject(DBRecord.Header.sName, TObject(nRecordIndex));
              AccountList.AddObject(DBRecord.sAccount, TObject(DBRecord.Header.nSelectID));
              ChrNameList.AddObject(DBRecord.sChrName, TObject(nRecordIndex));
              Inc(n4ADB00);
            end else begin //0x0048BC04
              m_DeletedList.Add(TObject(nIndex));
            end;
            Inc(nRecordIndex);
            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
          end;
        end;
      end; //0x0048BC52
    end;
  finally
    Close();
  end;
  for nIndex := 0 to AccountList.Count - 1 do begin
    m_QuickIDList.AddRecord(AccountList.Strings[nIndex],
      ChrNameList.Strings[nIndex],
      Integer(ChrNameList.Objects[nIndex]) ,
      Integer(AccountList.Objects[nIndex]), False);
    if (nIndex mod 100) = 0 then Application.ProcessMessages;
  end;
  AccountList.Free;
  ChrNameList.Free;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  boHumDBReady := True;
end;

function TFileHumDB.UpdateRecord(nIndex: Integer; HumRecord: THumInfo; boNew: Boolean): Boolean;
var
  HumRcd: THumInfo;
  nPosion, n10: Integer;
begin
  nPosion := nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    n10 := FileSeek(m_nFileHandle, 0, 1);
    if boNew and
      (FileRead(m_nFileHandle, HumRcd, SizeOf(THumInfo)) = SizeOf(THumInfo)) and
      (not HumRcd.Header.boDeleted) and (HumRcd.Header.sName <> '') then Result := True
    else begin
      //HumRecord.Header.boDeleted := False;//20080515 ע��
      HumRecord.Header.dCreateDate := Now();
      m_Header.n70:= nDBVersion;//20100902
      m_Header.dUpdateDate := Now();
      FileSeek(m_nFileHandle, 0, 0);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      FileSeek(m_nFileHandle, n10, 0);
      FileWrite(m_nFileHandle, HumRecord, SizeOf(THumInfo));
      FileSeek(m_nFileHandle, -SizeOf(THumInfo), 1);
      n4 := nIndex;
      m_boChanged := True;
      Result := True;
    end;
  end else Result := False;
end;

function TFileHumDB.DeleteRecord(nIndex: Integer): Boolean; //0x0048BD58
var
  HumRcdHeader: TRecordHeader;
begin
  Result := False;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THumInfo) + SizeOf(TDBHeader), 0) = -1 then Exit;
  HumRcdHeader.boDeleted := True;
  HumRcdHeader.dCreateDate := Now();
  FileWrite(m_nFileHandle, HumRcdHeader, SizeOf(TRecordHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_boChanged := True;
  Result := True;
end;

function TFileHumDB.OpenEx(boRead : Boolean = False): Boolean;
var
  DBHeader: TDBHeader;
begin
  Lock();
  m_boChanged := False;
  if boRead then
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result := True;
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header := DBHeader;
    n4 := 0;
  end else Result := False;
end;

function TFileHumDB.UpdateBy(nIndex: Integer; var HumDBRecord: THumInfo): Boolean; //00048C1B4
begin
  Result := False;
  if UpdateRecord(nIndex, HumDBRecord, False) then Result := True;
end;

function TFileHumDB.GetRecord(n08: Integer; var HumDBRecord: THumInfo): Boolean;
{FileSeek(�ļ����,ƫ����,��ʼλ��)�����ļ�ָ�뵽�µ�λ��,��������ɹ�,
�򷵻��µ��ļ�λ��,�������ʧ��,����-1;����0��ʾ���ļ���ͷ��ʼ��1��ʾ�ӵ�ǰλ�ÿ�ʼ}
begin
  if FileSeek(m_nFileHandle, SizeOf(THumInfo) * n08 + SizeOf(TDBHeader), 0) <> -1 then begin
    FileRead(m_nFileHandle, HumDBRecord, SizeOf(THumInfo)); //FileRead()��ָ���ļ��ж�ȡ����
    FileSeek(m_nFileHandle, -SizeOf(THumInfo) * n08 + SizeOf(TDBHeader), 1);
    n4 := n08;
    Result := True;
  end else Result := False;
end;
{$IFEND}

function TFileHumDB.Index(sName: string): Integer; //0x0048C384
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileHumDB.Get(sChrName: string; var HumDBRecord: THumInfo): Integer;
var
  nIndex: Integer;
begin
  nIndex := m_QuickList.GetIndex(sChrName);
  if GetRecord(nIndex, HumDBRecord) then Result := nIndex
  else Result := -1;
end;

function TFileHumDB.Get(n08: Integer; var HumDBRecord: THumInfo): Integer;
var
  nIndex: Integer;
begin
  nIndex := Integer(m_QuickList.Objects[n08]);
  if GetRecord(nIndex, HumDBRecord) then Result := nIndex
  else Result := -1;
end;

//�������ֲ�����������
function TFileHumDB.FindByName(sChrName: string; ChrList: TStringList): Integer;
var
  i: Integer;
begin
  if m_QuickList.Count > 0 then begin//20090101
    for i := 0 to m_QuickList.Count - 1 do begin
      if CompareLStr(m_QuickList.Strings[i], sChrName, Length(sChrName)) then begin
        ChrList.AddObject(m_QuickList.Strings[i], m_QuickList.Objects[i]);
      end;
    end;
  end;
  Result := ChrList.Count;
end;

function TFileHumDB.GetBy(sChrName: string; var HumDBRecord: THumInfo): Boolean;
var
  nIndex: Integer;
begin
  nIndex := Index(sChrName);
  if nIndex >= 0 then
    Result := GetRecord(nIndex, HumDBRecord)
  else Result := False;
end;

function TFileHumDB.GetBy(n08: Integer; var HumDBRecord: THumInfo): Boolean;
begin
  if (n08 >= 0) then
    Result := GetRecord(n08, HumDBRecord)
  else Result := False;
end;

function TFileHumDB.FindByAccount(sAccount: string; var ChrList: TStringList): Integer;
var
  ChrNameList: TList;
  QuickID: pTQuickID;
  i: Integer;
begin
  ChrNameList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrNameList);
  if ChrNameList <> nil then begin
    if ChrNameList.Count > 0 then begin
      for i := 0 to ChrNameList.Count - 1 do begin
        QuickID := ChrNameList.Items[i];
        ChrList.AddObject(QuickID.sAccount, TObject(QuickID));
      end;
    end;
  end;
  Result := ChrList.Count;
end;
//�����˺ŵ���������
function TFileHumDB.ChrCountOfAccount(sAccount: string): Integer; //0x0048C5B0
var
  ChrList: TList;
  i, n18: Integer;
  HumDBRecord: THumInfo;
begin
  n18 := 0;
  ChrList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrList);
  if ChrList <> nil then begin
    if ChrList.Count > 0 then begin//20090101
      for i := 0 to ChrList.Count - 1 do begin
        if {$IF DBSMode = 1}GetBy(pTQuickID(ChrList.Items[i]).sChrName, HumDBRecord){$ELSE}GetBy(pTQuickID(ChrList.Items[i]).nIndex, HumDBRecord){$IFEND} and
          (not HumDBRecord.boDeleted) and (not HumDBRecord.Header.boIsHero) then Inc(n18);
      end;
    end;
  end;
  Result := n18;
end;
//�����˺Ž�ɫ��Ӣ������ 20080515
function TFileHumDB.HeroChrCountOfAccount(sAccount: string): Integer;
var
  ChrList: TList;
  i, n18: Integer;
  HumDBRecord: THumInfo;
begin
  n18 := 0;
  ChrList := nil;
  m_QuickIDList.GetChrList(sAccount, ChrList);
  if ChrList <> nil then begin
    if ChrList.Count > 0 then begin//20090101
      for i := 0 to ChrList.Count - 1 do begin
        if {$IF DBSMode = 1}GetBy(pTQuickID(ChrList.Items[i]).sChrName, HumDBRecord){$ELSE}GetBy(pTQuickID(ChrList.Items[i]).nIndex, HumDBRecord){$IFEND} then begin
          if (not HumDBRecord.boDeleted) and (HumDBRecord.Header.boIsHero) then Inc(n18);
        end;
      end;
    end;
  end;
  Result := n18;
end;

function TFileHumDB.Add(HumRecord: THumInfo): Boolean;
var
  nIndex: Integer;
  sChrName: string;
  {$IF DBSMode = 0}
  Header: TDBHeader;
  {$IFEND}
begin
  sChrName := HumRecord.sChrName;
  if m_QuickList.GetIndex(sChrName) >= 0 then Result := False
  else begin
    {$IF DBSMode = 1}
    nIndex := m_nRecordCount;
    Inc(m_nRecordCount);
    if UpdateRecord(nIndex, HumRecord, 1) then begin
      m_QuickList.AddRecord(sChrName, 0);
      m_QuickIDList.AddRecord(HumRecord.sAccount, HumRecord.sChrName, nIndex, HumRecord.Header.nSelectID, False);
      Result := True;
    end else Result := False;
    {$ELSE}
    Header := m_Header;
    if m_DeletedList.Count > 0 then begin
      nIndex := Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIndex := m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;
    if UpdateRecord(nIndex, HumRecord, True) then begin
      m_QuickList.AddRecord(HumRecord.Header.sName, nIndex);
      m_QuickIDList.AddRecord(HumRecord.sAccount, HumRecord.sChrName, nIndex ,HumRecord.Header.nSelectID, False);
      Result := True;
    end else begin
      m_Header := Header;
      Result := False;
    end;
    {$IFEND}
  end;
end;

function TFileHumDB.Delete(sName: string): Boolean;
var
  n10: Integer;
  HumRecord: THumInfo;
  ChrNameList: TList;
  n14: Integer;
begin
  Result := False;
  n10 := m_QuickList.GetIndex(sName);
  if n10 < 0 then Exit;
  Get(n10, HumRecord);
  {$IF DBSMode = 1}
  if UpdateRecord(n10, HumRecord, 3) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
  {$ELSE}
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
  {$IFEND}
  n14 := m_QuickIDList.GetChrList(HumRecord.sAccount, ChrNameList);
  if n14 >= 0 then begin
    m_QuickIDList.DelRecord(n14, HumRecord.sChrName);
  end;
end;

function TFileHumDB.Update(nIndex: Integer; var HumDBRecord: THumInfo): Boolean;
begin
  Result := False;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  {$IF DBSMode = 1}
  Result := UpdateRecord(nIndex, HumDBRecord, 0);
  {$ELSE}
  if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumDBRecord, False) then Result := True;
  {$IFEND}
end;

function TFileHumDB.Update(sChrName: string; var HumDBRecord: THumInfo): boolean;
var
  nIndex: Integer;
begin
  Result := False;
  {$IF DBSMode = 1}
  nIndex := Index(sChrName);
  if nIndex < 0 then Exit;
  Result := UpdateRecord(nIndex, HumDBRecord, 0);
  {$IFEND}
end;

{ TFileDB }
constructor TFileDB.Create(sFileName: string);
begin
  {$IF DBSMode = 1}
  inherited Create;
  CoInitialize(nil);

  m_sDBFileName := sFileName;
  m_QuickList := TQuickList.Create;
  m_QuickList.boCaseSensitive := False;
  m_boChanged := False;
  m_nRecordCount := -1;

  boDataDBReady := False;
  n4ADAE4 := 0;
  n4ADAF0 := 0;
  ADOConnection := TADOConnection.Create(nil);
  DBQry := TADOQuery.Create(nil);
  ADOConnection.ConnectionString := sFileName;
  ADOConnection.LoginPrompt := False;
  ADOConnection.KeepConnection := True;
  DBQry.Connection := ADOConnection;
  DBQry.Prepared := True;

  DBQry1 := TADOQuery.Create(nil);
  DBQry1.Connection := ADOConnection;
  DBQry1.Prepared := True;
  try
    ADOConnection.Connected := True;
  except
    MainOutMessage('[����] SQL ����ʧ�ܣ�����SQL����');
  end;
  LoadQuickList;
  {$ELSE}
  n4 := 0;
  boDataDBReady := False;
  m_sDBFileName := sFileName;
  m_sIdxFileName := sFileName + '.idx';
  m_QuickList := TQuickList.Create;
  m_DeletedList := TList.Create;
  n4ADAE4 := 0;
  n4ADAF0 := 0;
  m_nLastIndex := -1;
  if LoadDBIndex then boDataDBReady := True
  else LoadQuickList();
  {$IFEND}
end;
destructor TFileDB.Destroy;
begin
{$IF DBSMode = 1}
  DBQry.Free;
  DBQry1.Free;
  ADOConnection.Free;
  CoUnInitialize;
{$ELSE}
  if boDataDBReady then SaveIndex();
  m_DeletedList.Free;
{$IFEND}
  m_QuickList.Free;
  inherited;
end;

{$IF DBSMode = 1}
procedure TFileDB.GetHeroRanking(nMinLevel, nMaxLevel, nJob: Integer; var RankingList: TQuickPointList);
var
  I: Integer;
  sDenyName: string;
  Ranking: pTOrders;
resourcestring
  sSQL = 'SELECT top 2000 FLD_CHARNAME,FLD_MasterName,FLD_LEVEL,FLD_EXP FROM TBL_CHARACTERMIR WHERE (FLD_ISHERO=1) AND (FLD_LEVEL>%d) AND (FLD_LEVEL<%d)';
  sSQL1 = 'SELECT top 2000 FLD_CHARNAME,FLD_MasterName,FLD_LEVEL,FLD_EXP FROM TBL_CHARACTERMIR WHERE (FLD_ISHERO=1) AND (FLD_JOB=%d) AND (FLD_LEVEL>%d) AND (FLD_LEVEL<%d)';
begin
  sDenyName := GetDenyRankingChrSQL('FLD_CHARNAME') + GetDenyRankingChrSQL('FLD_MasterName') + ' ORDER BY FLD_LEVEL DESC';
  try
    dbQry.SQL.Clear;
    if nJob in [0..2] then begin
      dbQry.SQL.Add(Format(sSQL1, [nJob, nMinLevel, nMaxLevel]) + sDenyName);
    end else begin
      dbQry.SQL.Add(Format(sSQL, [nMinLevel, nMaxLevel]) + sDenyName);
    end;
    try
      dbQry.Open;
    except
      on E: Exception do begin
        MainOutMessage('[�쳣] TFileDB.GetHeroRanking');
        MainOutMessage(E.Message);
        Exit;
      end;
    end;

    for I := 0 to dbQry.RecordCount - 1 do begin
      New(Ranking);
      Ranking.nLevel:= dbQry.FieldByName('FLD_LEVEL').AsInteger;
      Ranking.nExp:= dbQry.FieldByName('FLD_EXP').AsInteger;
      Ranking.sName := Trim(dbQry.FieldByName('FLD_MasterName').AsString);
      Ranking.sHeroName:=Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      RankingList.AddPointer((Ranking.nLevel * 60000) + Ranking.nExp div 100000,Ranking,True);
      dbQry.Next;
    end;
  finally
    dbQry.Close;
  end;
end;

procedure TFileDB.GetMasterRanking(nMinLevel, nMaxLevel: Integer; var RankingList: TQuickPointList);
var
  I: Integer;
  sDenyName: string;
  Ranking: pTOrders;
resourcestring
  sSQL = 'SELECT top 2000 FLD_CHARNAME,FLD_MASTERCOUNT FROM TBL_CHARACTERMIR WHERE (FLD_ISHERO=0) AND (FLD_MASTERCOUNT>0) AND (FLD_LEVEL>%d) AND (FLD_LEVEL<%d)';
begin
  sDenyName := GetDenyRankingChrSQL('FLD_CHARNAME') + ' ORDER BY FLD_MASTERCOUNT DESC';
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [nMinLevel, nMaxLevel]) + sDenyName);
    try
      dbQry.Open;
    except
      on E: Exception do begin
        MainOutMessage('[�쳣] TFileDB.GetMasterRanking');
        MainOutMessage(E.Message);
        Exit;
      end;
    end;
    for I := 0 to dbQry.RecordCount - 1 do begin
      New(Ranking);
      Ranking.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      Ranking.nMaster:= dbQry.FieldByName('FLD_MASTERCOUNT').AsInteger;
      RankingList.AddPointer(Ranking.nMaster,Ranking,True);
      dbQry.Next;
    end;
  finally
    dbQry.Close;
  end;
end;

procedure TFileDB.GetHumRanking(nMinLevel, nMaxLevel, nJob: Integer; var RankingList: TQuickPointList);
var
  I: Integer;                    
  sDenyName: string;
  Ranking: pTOrders;
resourcestring
  sSQL = 'SELECT TOP 2000 FLD_CHARNAME,FLD_LEVEL,FLD_EXP FROM TBL_CHARACTERMIR WHERE (FLD_LEVEL>%d) AND (FLD_LEVEL<%d) AND (FLD_ISHERO=0)'; //
  sSQL1 = 'SELECT TOP 2000 FLD_CHARNAME,FLD_LEVEL,FLD_EXP FROM TBL_CHARACTERMIR WHERE (FLD_JOB=%d) AND (FLD_LEVEL>%d) AND (FLD_LEVEL<%d) AND (FLD_ISHERO=0)'; // DESC
begin
  sDenyName := GetDenyRankingChrSQL('FLD_CHARNAME') + ' ORDER BY FLD_LEVEL DESC';
  try
    dbQry.SQL.Clear;
    if nJob in [0..2] then begin
      dbQry.SQL.Add(Format(sSQL1, [nJob, nMinLevel, nMaxLevel]) + sDenyName);
    end else begin
      dbQry.SQL.Add(Format(sSQL, [nMinLevel, nMaxLevel]) + sDenyName);
    end;
    try
      dbQry.Open;
    except
      on E: Exception do begin
        MainOutMessage('[�쳣] TFileDB.GetHumRanking');
        MainOutMessage(E.Message);
        Exit;
      end;
    end;

    for I := 0 to dbQry.RecordCount - 1 do begin
      New(Ranking);
      Ranking.nLevel:= dbQry.FieldByName('FLD_LEVEL').AsInteger;
      Ranking.nExp:= dbQry.FieldByName('FLD_EXP').AsInteger;
      Ranking.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
      RankingList.AddPointer((Ranking.nLevel * 60000) + Ranking.nExp div 100000,Ranking,True);
      dbQry.Next;
    end;
  finally
    dbQry.Close;
  end;
end;
//ȡ�һ�����
procedure TFileDB.GetAutoAddExpPlay(nPlayCount, nMaxLevel: Integer; var LoadList: TStringList);
var
  I: Integer;
  sDenyName: string;
resourcestring
  sSQL = 'SELECT FLD_CHARNAME,FLD_Account FROM TBL_CHARACTERMIR WHERE (FLD_ISHERO=0) AND (FLD_LEVEL<%d) order by FLD_Account';
begin
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [nMaxLevel]));
    try
      dbQry.Open;
    except
      on E: Exception do begin
        MainOutMessage('[�쳣] TFileDB.GetAutoAddExpPlay');
        MainOutMessage(E.Message);
        Exit;
      end;
    end;
    for I := 0 to dbQry.RecordCount - 1 do begin
      if I > nPlayCount then Break;
      LoadList.Add(Trim(dbQry.FieldByName('FLD_CHARNAME').AsString)+' '+Trim(dbQry.FieldByName('FLD_Account').AsString));
      dbQry.Next;
    end;
  finally
    dbQry.Close;
  end;
end;

procedure TFileDB.LoadQuickList;
var
  nIndex: Integer;
  sChrName: string;
resourcestring
  sSQL = 'SELECT * FROM TBL_CHARACTERMIR';
begin
  m_nRecordCount := -1;
  m_QuickList.Clear;
  n4ADAE4 := 0;
  n4ADAE8 := 0;
  n4ADAF0 := 0;
  Lock;
  try
    try
      dbQry.SQL.Clear;
      dbQry.SQL.Add(sSQL);
      try
        dbQry.Open;
      except
        MainOutMessage('[�쳣] TFileDB.LoadQuickList');
      end;

      m_nRecordCount := dbQry.RecordCount;
      n4ADAF0 := m_nRecordCount;
      for nIndex := 0 to m_nRecordCount - 1 do begin
        Inc(n4ADAE4);
        //boDeleted := dbQry.FieldByName('FLD_DELETED').AsBoolean;
        sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);
       // if (not boDeleted) and (sChrName <> '') then begin
        m_QuickList.AddObject(sChrName, TObject(nIndex));
        Inc(n4ADAE8);
        //end else begin
        //  Inc(n4ADAEC);
       // end;
        dbQry.Next;
      end;
    finally
      dbQry.Close;
    end;
  finally
    UnLock;
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  boDataDBReady := True;
end;

function TFileDB.GetRecordToOrders(nIndex: Integer; HumanRCD: pTHumDataInfo): boolean;
var
  sChrName: string;
resourcestring
  sSQL = 'SELECT FLD_DELETED,FLD_CHARNAME,FLD_LEVEL,FLD_JOB,FLD_EXP,FLD_MasterCount,FLD_IsHero,FLD_MASTERNAME,FLD_HeroChrName FROM TBL_CHARACTERMIR WHERE FLD_CHARNAME=''%s''';
begin
  Result := False;
  sChrName := Trim(m_QuickList[nIndex]);
  FillChar(HumanRCD^, SizeOf(THumDataInfo), #0);
  try
    dbQry1.SQL.Clear;
    dbQry1.SQL.Add(Format(sSQL, [sChrName]));
    try
      dbQry1.Open;
    except
      MainOutMessage('[�쳣] TFileDB.GetRecordToOrders (1)');
      Exit;
    end;

    if dbQry1.RecordCount > 0 then begin
      Result := True;                           
      HumanRCD.Header.boDeleted:= dbQry1.FieldByName('FLD_DELETED').AsBoolean;
      HumanRCD.Header.sName := Trim(dbQry1.FieldByName('FLD_CHARNAME').AsString);//����
      HumanRCD.Data.sChrName := Trim(dbQry1.FieldByName('FLD_CHARNAME').AsString);//����
      HumanRCD.Data.Abil.Level := dbQry1.FieldByName('FLD_LEVEL').AsInteger;//�ȼ�
      HumanRCD.Data.btJob := dbQry1.FieldByName('FLD_JOB').AsInteger;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
      HumanRCD.Data.Abil.nExp := dbQry1.FieldByName('FLD_EXP').AsInteger;//��ǰ����
      HumanRCD.Data.wMasterCount := dbQry1.FieldByName('FLD_MasterCount').AsInteger;//��ʦͽ����
      HumanRCD.Data.boIsHero := dbQry1.FieldByName('FLD_IsHero').AsBoolean; //�Ƿ���Ӣ��
      HumanRCD.Data.sMasterName := Trim(dbQry1.FieldByName('FLD_MASTERNAME').AsString);//����-ʦ������ Ӣ��-��������
      HumanRCD.Data.sHeroChrName := Trim(dbQry1.FieldByName('FLD_HeroChrName').AsString);//Ӣ������, size=15

      (*HumanRCD.Header.dCreateDate := dbQry.FieldByName('FLD_CREATEDATE').AsDateTime;
      HumanRCD.Header.boIsHero:= dbQry.FieldByName('FLD_IsHero').AsBoolean; //�Ƿ���Ӣ��

      HumanRCD.Data.sCurMap:= Trim(dbQry.FieldByName('FLD_CURMAP').AsString);//��ͼ
      HumanRCD.Data.wCurX := dbQry.FieldByName('FLD_CX').AsInteger;//����X
      HumanRCD.Data.wCurY := dbQry.FieldByName('FLD_CY').AsInteger;//����Y
      HumanRCD.Data.btDir := dbQry.FieldByName('FLD_DIR').AsInteger;//����
      HumanRCD.Data.btHair := dbQry.FieldByName('FLD_HAIR').AsInteger;//ͷ��
      HumanRCD.Data.btSex := dbQry.FieldByName('FLD_SEX').AsInteger;//�Ա�(0-�� 1-Ů)

      HumanRCD.Data.nGold := dbQry.FieldByName('FLD_GOLD').AsInteger;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)
      //+40 ������������

      HumanRCD.Data.Abil.AC := dbQry.FieldByName('FLD_AC').AsInteger;//HP ���� 20091026
      HumanRCD.Data.Abil.MAC := dbQry.FieldByName('FLD_MAC').AsInteger;//MP ���� 20091026
      HumanRCD.Data.Abil.DC := dbQry.FieldByName('FLD_DC').AsInteger;//MaxHP ���� 20091026
      HumanRCD.Data.Abil.MC := dbQry.FieldByName('FLD_MC').AsInteger;//MaxMP ���� 20091026
      HumanRCD.Data.Abil.SC := dbQry.FieldByName('FLD_SC').AsInteger;//LoByte()-�Զ������������� HiByte()-�Զ���������ǿ��(����)
      HumanRCD.Data.Abil.HP := dbQry.FieldByName('FLD_HP').AsInteger;//-AC,HP����
      HumanRCD.Data.Abil.MP := dbQry.FieldByName('FLD_MP').AsInteger;//-MAC,Mp����
      HumanRCD.Data.Abil.MaxHP := dbQry.FieldByName('FLD_MaxHP').AsInteger;//-DC,MaxHP����
      HumanRCD.Data.Abil.MaxMP := dbQry.FieldByName('FLD_MaxMP').AsInteger;//-MC,MaxMP����
      HumanRCD.Data.Abil.NG := dbQry.FieldByName('FLD_NG').AsInteger;//��ǰ����ֵ
      HumanRCD.Data.Abil.MaxNG := dbQry.FieldByName('FLD_MaxNG').AsInteger;//����ֵ����

      HumanRCD.Data.Abil.MaxExp := dbQry.FieldByName('FLD_MaxExp').AsInteger;//��������
      HumanRCD.Data.Abil.Weight := dbQry.FieldByName('FLD_Weight').AsInteger;
      HumanRCD.Data.Abil.MaxWeight := dbQry.FieldByName('FLD_MaxWeight').AsInteger;//�������
      HumanRCD.Data.Abil.WearWeight := dbQry.FieldByName('FLD_WearWeight').AsInteger;
      HumanRCD.Data.Abil.MaxWearWeight := dbQry.FieldByName('FLD_MaxWearWeight').AsInteger;//�����
      HumanRCD.Data.Abil.HandWeight := dbQry.FieldByName('FLD_HandWeight').AsInteger;
      HumanRCD.Data.Abil.MaxHandWeight := dbQry.FieldByName('FLD_MaxHandWeight').AsInteger;//����
      //wStatusTimeArr: TStatusTime; //+24 ����״̬����ֵ��һ���ǳ���������
      HumanRCD.Data.sHomeMap := Trim(dbQry.FieldByName('FLD_HOMEMAP').AsString);//Home ��(����),�����Ƿ��һ���ٻ�(Ӣ��)
      HumanRCD.Data.wHomeX := dbQry.FieldByName('FLD_HOMEX').AsInteger;//Home X
      HumanRCD.Data.wHomeY := dbQry.FieldByName('FLD_HOMEY').AsInteger;//Home Y
      HumanRCD.Data.sDearName := Trim(dbQry.FieldByName('FLD_DEARNAME').AsString);//����(��ż)

      HumanRCD.Data.boMaster := dbQry.FieldByName('FLD_MASTER').AsBoolean;//�Ƿ���ͽ��
      HumanRCD.Data.btCreditPoint := dbQry.FieldByName('FLD_CreditPoint').AsInteger;//������
      HumanRCD.Data.btDivorce := dbQry.FieldByName('FLD_btDivorce').AsInteger;//(����)�Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(btDivorce��UnKnow[25]��ϳ�word)
      HumanRCD.Data.btMarryCount := dbQry.FieldByName('FLD_MarryCount').AsInteger;//������
      HumanRCD.Data.sStoragePwd := Trim(dbQry.FieldByName('FLD_StoragePwd').AsString);//�ֿ�����
      HumanRCD.Data.btReLevel := dbQry.FieldByName('FLD_ReLevel').AsInteger;//ת���ȼ�
      //btUnKnow2: array[0..2] of Byte;//0-�Ƿ�ͨԪ������(1-��ͨ) 1-�Ƿ�Ĵ�Ӣ��(1-����Ӣ��) 2-����ʱ�Ƶ�Ʒ��
      //BonusAbil: TNakedAbility; //+20 ���������ֵ
      HumanRCD.Data.nBonusPoint := dbQry.FieldByName('FLD_BONUSPOINT').AsInteger;//������
      HumanRCD.Data.nGameGold := dbQry.FieldByName('FLD_GAMEGOLD').AsInteger;//��Ϸ��
      HumanRCD.Data.nGameDiamond := dbQry.FieldByName('FLD_GameDiaMond').AsInteger;//���ʯ
      HumanRCD.Data.nGameGird := dbQry.FieldByName('FLD_GameGird').AsInteger;//���
      HumanRCD.Data.nGamePoint := dbQry.FieldByName('FLD_GAMEPOINT').AsInteger;//����
      HumanRCD.Data.btGameGlory := dbQry.FieldByName('FLD_GAMEGLORY').AsInteger;//����
      HumanRCD.Data.nPayMentPoint := dbQry.FieldByName('FLD_PayMentPoint').AsInteger;//��ֵ��
      HumanRCD.Data.nLoyal := dbQry.FieldByName('FLD_Loyal').AsInteger;//�ҳ϶�(Ӣ��) �����ۼƾ���(����)
      HumanRCD.Data.nPKPoint := dbQry.FieldByName('FLD_PKPOINT').AsInteger;//PK����
      HumanRCD.Data.btAllowGroup := Byte(dbQry.FieldByName('FLD_ALLOWGROUP').AsBoolean);//�������
      HumanRCD.Data.btF9 := dbQry.FieldByName('FLD_btF9').AsInteger;
      HumanRCD.Data.btAttatckMode := dbQry.FieldByName('FLD_AttatckMode').AsInteger;//����ģʽ
      HumanRCD.Data.btIncHealth := dbQry.FieldByName('FLD_IncHealth').AsInteger;//���ӽ�����
      HumanRCD.Data.btIncSpell := dbQry.FieldByName('FLD_IncSpell').AsInteger;//���ӹ�����
      HumanRCD.Data.btIncHealing := dbQry.FieldByName('FLD_IncHealing').AsInteger;//����������
      HumanRCD.Data.btFightZoneDieCount := dbQry.FieldByName('FLD_FightZoneDieCount').AsInteger;//���л�ռ����ͼ����������
      HumanRCD.Data.sAccount := Trim(dbQry.FieldByName('FLD_Account').AsString);//��¼�ʺ�
      HumanRCD.Data.btEF := dbQry.FieldByName('FLD_EF').AsInteger;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
      HumanRCD.Data.boLockLogon := dbQry.FieldByName('FLD_LockLogon').AsBoolean;//�Ƿ�������½
      HumanRCD.Data.wContribution := dbQry.FieldByName('FLD_Contribution').AsInteger;//����ֵ(����) �Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(Ӣ��)
      HumanRCD.Data.nHungerStatus := dbQry.FieldByName('FLD_HungerStatus').AsInteger;//����״̬(����)
      HumanRCD.Data.boAllowGuildRecall := dbQry.FieldByName('FLD_AllowGuildReCall').AsBoolean;//�Ƿ������л��һ
      HumanRCD.Data.wGroupRcallTime := dbQry.FieldByName('FLD_GroupRcallTime').AsInteger;//�Ӵ���ʱ��
      HumanRCD.Data.dBodyLuck := dbQry.FieldByName('FLD_BodyLuck').AsFloat;//���˶�  8
      HumanRCD.Data.boAllowGroupRecall := dbQry.FieldByName('FLD_AllowGroupReCall').AsBoolean;//�Ƿ�������غ�һ
      HumanRCD.Data.nEXPRATE := dbQry.FieldByName('FLD_EXPRATE').AsInteger;//���鱶��
      HumanRCD.Data.nEXPTime := dbQry.FieldByName('FLD_ExpTime').AsInteger;//���鱶��ʱ��
      HumanRCD.Data.btLastOutStatus := dbQry.FieldByName('FLD_LastOutStatus').AsInteger;//�˳�״̬ 1Ϊ�����˳�

      HumanRCD.Data.boHasHero := dbQry.FieldByName('FLD_HasHero').AsBoolean;//�Ƿ��а�����Ӣ��(����ʹ��)

      HumanRCD.Data.btStatus := dbQry.FieldByName('FLD_Status').AsInteger; //Ӣ��״̬(Ӣ��) ��ѡ����ְҵ(����)

      //UnKnow: TUnKnow;//array[0..29] of Byte; 0-3���ʹ�� 4-����ʱ�Ķ��� 5-ħ���ܵȼ� 6-�Ƿ�ѧ���ڹ� 7-�ڹ��ȼ� 8-ʹ����Ʒ�ı�˵������ɫ  9..16�������� 17..20�������ӵ��������� 21�Ƿ�ѧ���������� 22..24����������(0-������ 1-��ʾ"?") 25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ�� 26-�Ƿ�ѧ��������� 27-����Ӣ���Ƿ��Զ�����(����)
      //QuestFlag: TQuestFlag; //�ű�����
      //HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
      //BagItems: TBagItems; //����װ��
      //HumMagics: THumMagics;//��ͨħ��
      //StorageItems: TStorageItems;//�ֿ���Ʒ
      //HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
      HumanRCD.Data.n_WinExp := dbQry.FieldByName('FLD_WinExp').AsInteger;//�ۼƾ���
      HumanRCD.Data.n_UsesItemTick:= dbQry.FieldByName('FLD_UsesItemTick').AsInteger;//������ۼ�ʱ��
      HumanRCD.Data.nReserved:= dbQry.FieldByName('FLD_nReserved').AsInteger;//(����)��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� (Ӣ��)������������
      HumanRCD.Data.nReserved1:= dbQry.FieldByName('FLD_nReserved1').AsInteger;//��ǰҩ��ֵ
      HumanRCD.Data.nReserved2:= dbQry.FieldByName('FLD_nReserved2').AsInteger;//ҩ��ֵ����
      HumanRCD.Data.nReserved3:= dbQry.FieldByName('FLD_nReserved3').AsInteger;//ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ��
      HumanRCD.Data.n_Reserved:= dbQry.FieldByName('FLD_n_Reserved').AsInteger;//��ǰ����ֵ
      HumanRCD.Data.n_Reserved1:= dbQry.FieldByName('FLD_n_Reserved1').AsInteger;//��������
      HumanRCD.Data.n_Reserved2:= dbQry.FieldByName('FLD_n_Reserved2').AsInteger;//��ǰ��ƶ�
      HumanRCD.Data.n_Reserved3:= dbQry.FieldByName('FLD_n_Reserved3').AsInteger;//ҩ��ֵ�ȼ�
      HumanRCD.Data.boReserved := dbQry.FieldByName('FLD_boReserved').AsBoolean;//�Ƿ������ T-�����(����)
      HumanRCD.Data.boReserved1:= dbQry.FieldByName('FLD_boReserved1').AsBoolean;//�Ƿ�������Ӣ��(����)
      HumanRCD.Data.boReserved2:= dbQry.FieldByName('FLD_boReserved2').AsBoolean;//�Ƿ���� T-������� (����)
      HumanRCD.Data.boReserved3:= dbQry.FieldByName('FLD_boReserved3').AsBoolean;//���Ƿ�Ⱦ�����(����)
      HumanRCD.Data.m_GiveDate:= dbQry.FieldByName('FLD_GiveDate').AsInteger;//������ȡ�л��Ȫ����(����)
      HumanRCD.Data.MaxExp68:= dbQry.FieldByName('FLD_MaxExp68').AsInteger;//�Զ������ۼ�ʱ��(����)
      HumanRCD.Data.nExpSkill69:= dbQry.FieldByName('FLD_ExpSkill69').AsInteger;//�ڹ���ǰ����
      //HumNGMagics: THumNGMagics;//�ڹ�����
      HumanRCD.Data.m_nReserved1:= dbQry.FieldByName('FLD_m_nReserved1').AsInteger;//��������
      HumanRCD.Data.m_nReserved2:= dbQry.FieldByName('FLD_m_nReserved2').AsInteger;//����Ӣ�۵ȼ�(����)
      HumanRCD.Data.m_nReserved3:= dbQry.FieldByName('FLD_m_nReserved3').AsInteger;;//����Ӣ�۵ȼ�(����)
      HumanRCD.Data.m_nReserved4:= dbQry.FieldByName('FLD_m_nReserved4').AsInteger;//�����ؼ�ʹ��ʱ��
      HumanRCD.Data.m_nReserved5:= dbQry.FieldByName('FLD_m_nReserved5').AsInteger;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����)
      HumanRCD.Data.m_nReserved6:= dbQry.FieldByName('FLD_m_nReserved6').AsInteger;//�����ۼ��ڹ�����(����)
      HumanRCD.Data.m_nReserved7:= dbQry.FieldByName('FLD_m_nReserved7').AsInteger;//����Ӣ���ڹ��ȼ�(����)
      HumanRCD.Data.m_nReserved8:= dbQry.FieldByName('FLD_m_nReserved8').AsInteger;//����Ӣ���ڹ��ȼ�(����)
      HumanRCD.Data.Proficiency:= dbQry.FieldByName('FLD_Proficiency').AsInteger;//������(�������ؾ���)

      HumanRCD.Data.Reserved2:= dbQry.FieldByName('FLD_Reserved2').AsInteger;//Ԥ������2
      HumanRCD.Data.Reserved3:= dbQry.FieldByName('FLD_Reserved3').AsInteger;//Ԥ������3
      HumanRCD.Data.Reserved4:= dbQry.FieldByName('FLD_Reserved4').AsInteger;//Ԥ������4
      HumanRCD.Data.Exp68:= dbQry.FieldByName('FLD_Exp68').AsInteger;//����ʹ�ô˱���
      HumanRCD.Data.Reserved5:= dbQry.FieldByName('FLD_Reserved5').AsInteger;//Ԥ������5
      HumanRCD.Data.Reserved6:= dbQry.FieldByName('FLD_Reserved6').AsInteger;//Ԥ������6
      HumanRCD.Data.Reserved7:= dbQry.FieldByName('FLD_Reserved7').AsInteger;//Ԥ������7
      HumanRCD.Data.Reserved8:= dbQry.FieldByName('FLD_Reserved8').AsInteger;//Ԥ������8   *)
    end;
  finally
    dbQry1.Close;
  end;
end;

function TFileDB.GetToOrders(nIndex: Integer; HumanRCD: pTHumDataInfo): Integer;
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if GetRecordToOrders(nIndex, HumanRCD) then Result := nIndex;
end;

function TFileDB.GetRecord(nIndex: Integer; HumanRCD: pTHumDataInfo): boolean;
var
  sChrName: string;
  I, nCount, nPosition, K, H: Integer;
  V: Variant;
  PData: Pointer;
resourcestring
  sSQL = 'SELECT * FROM TBL_CHARACTERMIR WHERE FLD_CHARNAME=''%s''';
  sSQL3 = 'SELECT * FROM TBL_CHARBINRAY WHERE FLD_CHARNAME=''%s''';
  sSQL4 = 'SELECT * FROM TBL_CHARACTER_MAGIC WHERE FLD_CHARNAME=''%s''';
  sSQL5 = 'SELECT * FROM TBL_CHARACTER_ITEM WHERE FLD_CHARNAME=''%s''';
  sSQL6 = 'SELECT * FROM TBL_CHARACTER_STORAGE WHERE FLD_CHARNAME=''%s''';
begin
  Result := False;
  sChrName := Trim(m_QuickList[nIndex]);
  FillChar(HumanRCD^, SizeOf(THumDataInfo), #0);
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [sChrName]));
    try
      dbQry.Open;
    except
      MainOutMessage('[�쳣] TFileDB.GetRecord (1)');
      Exit;
    end;

    if dbQry.RecordCount > 0 then begin
      Result := True;
      HumanRCD.Header.dCreateDate := dbQry.FieldByName('FLD_CREATEDATE').AsDateTime;
      HumanRCD.Header.boIsHero:= dbQry.FieldByName('FLD_IsHero').AsBoolean; //�Ƿ���Ӣ��
      HumanRCD.Header.boDeleted:= dbQry.FieldByName('FLD_DELETED').AsBoolean;
      if not HumanRCD.Header.boIsHero then
        HumanRCD.Header.sName := Trim(dbQry.FieldByName('FLD_DeputyHeroName').AsString)//����
      else HumanRCD.Header.sName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);//����

      HumanRCD.Data.sChrName := Trim(dbQry.FieldByName('FLD_CHARNAME').AsString);//����
      HumanRCD.Data.sCurMap:= Trim(dbQry.FieldByName('FLD_CURMAP').AsString);//��ͼ
      HumanRCD.Data.wCurX := dbQry.FieldByName('FLD_CX').AsInteger;//����X
      HumanRCD.Data.wCurY := dbQry.FieldByName('FLD_CY').AsInteger;//����Y
      HumanRCD.Data.btDir := dbQry.FieldByName('FLD_DIR').AsInteger;//����
      HumanRCD.Data.btHair := dbQry.FieldByName('FLD_HAIR').AsInteger;//ͷ��
      HumanRCD.Data.btSex := dbQry.FieldByName('FLD_SEX').AsInteger;//�Ա�(0-�� 1-Ů)
      HumanRCD.Data.btJob := dbQry.FieldByName('FLD_JOB').AsInteger;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
      HumanRCD.Data.nGold := dbQry.FieldByName('FLD_GOLD').AsInteger;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)
      //+40 ������������
      HumanRCD.Data.Abil.Level := dbQry.FieldByName('FLD_LEVEL').AsInteger;//�ȼ�
      HumanRCD.Data.Abil.AC := dbQry.FieldByName('FLD_AC').AsInteger;//HP ���� 20091026
      HumanRCD.Data.Abil.MAC := dbQry.FieldByName('FLD_MAC').AsInteger;//MP ���� 20091026
      HumanRCD.Data.Abil.DC := dbQry.FieldByName('FLD_DC').AsInteger;//MaxHP ���� 20091026
      HumanRCD.Data.Abil.MC := dbQry.FieldByName('FLD_MC').AsInteger;//MaxMP ���� 20091026
      HumanRCD.Data.Abil.SC := dbQry.FieldByName('FLD_SC').AsInteger;//LoByte()-�Զ������������� HiByte()-�Զ���������ǿ��(����)
      HumanRCD.Data.Abil.HP := dbQry.FieldByName('FLD_HP').AsInteger;//-AC,HP����
      HumanRCD.Data.Abil.MP := dbQry.FieldByName('FLD_MP').AsInteger;//-MAC,Mp����
      HumanRCD.Data.Abil.MaxHP := dbQry.FieldByName('FLD_MaxHP').AsInteger;//-DC,MaxHP����
      HumanRCD.Data.Abil.MaxMP := dbQry.FieldByName('FLD_MaxMP').AsInteger;//-MC,MaxMP����
      HumanRCD.Data.Abil.NG := dbQry.FieldByName('FLD_NG').AsInteger;//��ǰ����ֵ
      HumanRCD.Data.Abil.MaxNG := dbQry.FieldByName('FLD_MaxNG').AsInteger;//����ֵ����
      HumanRCD.Data.Abil.nExp := dbQry.FieldByName('FLD_EXP').AsInteger;//��ǰ����
      HumanRCD.Data.Abil.nMaxExp := dbQry.FieldByName('FLD_MaxExp').AsInteger;//��������
      HumanRCD.Data.Abil.Weight := dbQry.FieldByName('FLD_Weight').AsInteger;
      HumanRCD.Data.Abil.MaxWeight := dbQry.FieldByName('FLD_MaxWeight').AsInteger;//�������
      HumanRCD.Data.Abil.WearWeight := dbQry.FieldByName('FLD_WearWeight').AsInteger;
      HumanRCD.Data.Abil.MaxWearWeight := dbQry.FieldByName('FLD_MaxWearWeight').AsInteger;//�����
      HumanRCD.Data.Abil.HandWeight := dbQry.FieldByName('FLD_HandWeight').AsInteger;
      HumanRCD.Data.Abil.MaxHandWeight := dbQry.FieldByName('FLD_MaxHandWeight').AsInteger;//����
      //wStatusTimeArr: TStatusTime; //+24 ����״̬����ֵ��һ���ǳ���������
      HumanRCD.Data.sHomeMap := Trim(dbQry.FieldByName('FLD_HOMEMAP').AsString);//Home ��(����),�����Ƿ��һ���ٻ�(Ӣ��)
      HumanRCD.Data.wHomeX := dbQry.FieldByName('FLD_HOMEX').AsInteger;//Home X
      HumanRCD.Data.wHomeY := dbQry.FieldByName('FLD_HOMEY').AsInteger;//Home Y
      HumanRCD.Data.sDearName := Trim(dbQry.FieldByName('FLD_DEARNAME').AsString);//����(��ż)
      HumanRCD.Data.sMasterName := Trim(dbQry.FieldByName('FLD_MASTERNAME').AsString);//����-ʦ������ Ӣ��-��������
      HumanRCD.Data.boMaster := dbQry.FieldByName('FLD_MASTER').AsBoolean;//�Ƿ���ͽ��
      HumanRCD.Data.btCreditPoint := dbQry.FieldByName('FLD_CreditPoint').AsInteger;//������
      HumanRCD.Data.btDivorce := dbQry.FieldByName('FLD_btDivorce').AsInteger;//(����)�Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(btDivorce��UnKnow[25]��ϳ�word)
      HumanRCD.Data.btMarryCount := dbQry.FieldByName('FLD_MarryCount').AsInteger;//������
      HumanRCD.Data.sStoragePwd := Trim(dbQry.FieldByName('FLD_StoragePwd').AsString);//�ֿ�����
      HumanRCD.Data.btReLevel := dbQry.FieldByName('FLD_ReLevel').AsInteger;//ת���ȼ�
      //btUnKnow2: array[0..2] of Byte;//0-�Ƿ�ͨԪ������(1-��ͨ) 1-�Ƿ�Ĵ�Ӣ��(1-����Ӣ��) 2-����ʱ�Ƶ�Ʒ��
//BonusAbil: TNakedAbility; //+20 ���������ֵ
      HumanRCD.Data.BonusAbil.DC := dbQry.FieldByName('FLD_BONUSDC').AsInteger;
      HumanRCD.Data.BonusAbil.MC := dbQry.FieldByName('FLD_BONUSMC').AsInteger;
      HumanRCD.Data.BonusAbil.SC := dbQry.FieldByName('FLD_BONUSSC').AsInteger;
      HumanRCD.Data.BonusAbil.AC := dbQry.FieldByName('FLD_BONUSAC').AsInteger;
      HumanRCD.Data.BonusAbil.MAC := dbQry.FieldByName('FLD_BONUSMAC').AsInteger;
      HumanRCD.Data.BonusAbil.HP := dbQry.FieldByName('FLD_BONUSHP').AsInteger;
      HumanRCD.Data.BonusAbil.MP := dbQry.FieldByName('FLD_BONUSMP').AsInteger;
      HumanRCD.Data.BonusAbil.Hit := dbQry.FieldByName('FLD_BONUSHIT').AsInteger;
      HumanRCD.Data.BonusAbil.Speed := dbQry.FieldByName('FLD_BONUSSPEED').AsInteger;
      HumanRCD.Data.BonusAbil.X2 := dbQry.FieldByName('FLD_BONUX2').AsInteger;

      HumanRCD.Data.nBonusPoint := dbQry.FieldByName('FLD_BONUSPOINT').AsInteger;//������
      HumanRCD.Data.nGameGold := dbQry.FieldByName('FLD_GAMEGOLD').AsInteger;//��Ϸ��
      HumanRCD.Data.nGameDiamond := dbQry.FieldByName('FLD_GameDiaMond').AsInteger;//���ʯ
      HumanRCD.Data.nGameGird := dbQry.FieldByName('FLD_GameGird').AsInteger;//���
      HumanRCD.Data.nGamePoint := dbQry.FieldByName('FLD_GAMEPOINT').AsInteger;//����
      HumanRCD.Data.btGameGlory := dbQry.FieldByName('FLD_GAMEGLORY').AsInteger;//����
      HumanRCD.Data.nPayMentPoint := dbQry.FieldByName('FLD_PayMentPoint').AsInteger;//��ֵ��
      HumanRCD.Data.nLoyal := dbQry.FieldByName('FLD_Loyal').AsInteger;//�ҳ϶�(Ӣ��) �����ۼƾ���(����)
      HumanRCD.Data.nPKPoint := dbQry.FieldByName('FLD_PKPOINT').AsInteger;//PK����
      HumanRCD.Data.btAllowGroup := Byte(dbQry.FieldByName('FLD_ALLOWGROUP').AsBoolean);//�������
      HumanRCD.Data.btF9 := dbQry.FieldByName('FLD_btF9').AsInteger;
      HumanRCD.Data.btAttatckMode := dbQry.FieldByName('FLD_AttatckMode').AsInteger;//����ģʽ
      HumanRCD.Data.btIncHealth := dbQry.FieldByName('FLD_IncHealth').AsInteger;//���ӽ�����
      HumanRCD.Data.btIncSpell := dbQry.FieldByName('FLD_IncSpell').AsInteger;//���ӹ�����
      HumanRCD.Data.btIncHealing := dbQry.FieldByName('FLD_IncHealing').AsInteger;//����������
      HumanRCD.Data.btFightZoneDieCount := dbQry.FieldByName('FLD_FightZoneDieCount').AsInteger;//���л�ռ����ͼ����������
      HumanRCD.Data.sAccount := Trim(dbQry.FieldByName('FLD_Account').AsString);//��¼�ʺ�
      HumanRCD.Data.btHeroType := dbQry.FieldByName('FLD_EF').AsInteger;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
      HumanRCD.Data.boLockLogon := dbQry.FieldByName('FLD_LockLogon').AsBoolean;//�Ƿ�������½
      HumanRCD.Data.wContribution := dbQry.FieldByName('FLD_Contribution').AsInteger;//����ֵ(����) �Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(Ӣ��)
      HumanRCD.Data.nHungerStatus := dbQry.FieldByName('FLD_HungerStatus').AsInteger;//����״̬(����)
      HumanRCD.Data.boAllowGuildRecall := dbQry.FieldByName('FLD_AllowGuildReCall').AsBoolean;//�Ƿ������л��һ
      HumanRCD.Data.wGroupRcallTime := dbQry.FieldByName('FLD_GroupRcallTime').AsInteger;//�Ӵ���ʱ��
      HumanRCD.Data.dBodyLuck := dbQry.FieldByName('FLD_BodyLuck').AsFloat;//���˶�  8
      HumanRCD.Data.boAllowGroupRecall := dbQry.FieldByName('FLD_AllowGroupReCall').AsBoolean;//�Ƿ�������غ�һ
      HumanRCD.Data.nEXPRATE := dbQry.FieldByName('FLD_EXPRATE').AsInteger;//���鱶��
      HumanRCD.Data.nEXPTime := dbQry.FieldByName('FLD_ExpTime').AsInteger;//���鱶��ʱ��
      HumanRCD.Data.btLastOutStatus := dbQry.FieldByName('FLD_LastOutStatus').AsInteger;//�˳�״̬ 1Ϊ�����˳�
      HumanRCD.Data.wMasterCount := dbQry.FieldByName('FLD_MasterCount').AsInteger;//��ʦͽ����
      HumanRCD.Data.boHasHero := dbQry.FieldByName('FLD_HasHero').AsBoolean;//�Ƿ��а�����Ӣ��(����ʹ��)
      HumanRCD.Data.boIsHero := dbQry.FieldByName('FLD_IsHero').AsBoolean; //�Ƿ���Ӣ��
      HumanRCD.Data.btStatus := dbQry.FieldByName('FLD_Status').AsInteger; //Ӣ��״̬(Ӣ��) ��ѡ����ְҵ(����)
      HumanRCD.Data.sHeroChrName := Trim(dbQry.FieldByName('FLD_HeroChrName').AsString);//Ӣ������, size=15
      //UnKnow: TUnKnow;//array[0..29] of Byte; 0-3���ʹ�� 4-����ʱ�Ķ��� 5-ħ���ܵȼ� 6-�Ƿ�ѧ���ڹ� 7-�ڹ��ȼ� 8-ʹ����Ʒ�ı�˵������ɫ  9..16�������� 17..20�������ӵ��������� 21�Ƿ�ѧ���������� 22..24����������(0-������ 1-��ʾ"?") 25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ�� 26-�Ƿ�ѧ��������� 27-����Ӣ���Ƿ��Զ�����(����)
      //QuestFlag: TQuestFlag; //�ű�����
      //HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
      //BagItems: TBagItems; //����װ��
      //HumMagics: THumMagics;//��ͨħ��
      //StorageItems: TStorageItems;//�ֿ���Ʒ
      //HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
      HumanRCD.Data.n_WinExp := dbQry.FieldByName('FLD_WinExp').AsInteger;//�ۼƾ���
      HumanRCD.Data.n_UsesItemTick:= dbQry.FieldByName('FLD_UsesItemTick').AsInteger;//������ۼ�ʱ��
      HumanRCD.Data.nReserved:= dbQry.FieldByName('FLD_nReserved').AsInteger;//(����)��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� (Ӣ��)������������
      HumanRCD.Data.nReserved1:= dbQry.FieldByName('FLD_nReserved1').AsInteger;//��ǰҩ��ֵ
      HumanRCD.Data.nReserved2:= dbQry.FieldByName('FLD_nReserved2').AsInteger;//ҩ��ֵ����
      HumanRCD.Data.nReserved3:= dbQry.FieldByName('FLD_nReserved3').AsInteger;//ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ��
      HumanRCD.Data.n_Reserved:= dbQry.FieldByName('FLD_n_Reserved').AsInteger;//��ǰ����ֵ
      HumanRCD.Data.n_Reserved1:= dbQry.FieldByName('FLD_n_Reserved1').AsInteger;//��������
      HumanRCD.Data.n_Reserved2:= dbQry.FieldByName('FLD_n_Reserved2').AsInteger;//��ǰ��ƶ�
      HumanRCD.Data.n_Reserved3:= dbQry.FieldByName('FLD_n_Reserved3').AsInteger;//ҩ��ֵ�ȼ�
      HumanRCD.Data.boReserved := dbQry.FieldByName('FLD_boReserved').AsBoolean;//�Ƿ������ T-�����(����)
      HumanRCD.Data.boReserved1:= dbQry.FieldByName('FLD_boReserved1').AsBoolean;//�Ƿ�������Ӣ��(����)
      HumanRCD.Data.boReserved2:= dbQry.FieldByName('FLD_boReserved2').AsBoolean;//�Ƿ���� T-������� (����)
      HumanRCD.Data.boReserved3:= dbQry.FieldByName('FLD_boReserved3').AsBoolean;//���Ƿ�Ⱦ�����(����)
      HumanRCD.Data.m_GiveDate:= dbQry.FieldByName('FLD_GiveDate').AsInteger;//������ȡ�л��Ȫ����(����)
      HumanRCD.Data.MaxExp68:= dbQry.FieldByName('FLD_MaxExp68').AsInteger;//�Զ������ۼ�ʱ��(����)
      HumanRCD.Data.nExpSkill69:= dbQry.FieldByName('FLD_ExpSkill69').AsInteger;//�ڹ���ǰ����
      //HumNGMagics: THumNGMagics;//�ڹ�����
      HumanRCD.Data.m_nReserved1:= dbQry.FieldByName('FLD_m_nReserved1').AsInteger;//��������
      HumanRCD.Data.m_nReserved2:= dbQry.FieldByName('FLD_m_nReserved2').AsInteger;//����Ӣ�۵ȼ�(����)
      HumanRCD.Data.m_nReserved3:= dbQry.FieldByName('FLD_m_nReserved3').AsInteger;;//����Ӣ�۵ȼ�(����)
      HumanRCD.Data.m_nReserved4:= dbQry.FieldByName('FLD_m_nReserved4').AsInteger;//�����ؼ�ʹ��ʱ��
      HumanRCD.Data.m_nReserved5:= dbQry.FieldByName('FLD_m_nReserved5').AsInteger;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����)
      HumanRCD.Data.m_nReserved6:= dbQry.FieldByName('FLD_m_nReserved6').AsInteger;//�����ۼ��ڹ�����(����)
      HumanRCD.Data.m_nReserved7:= dbQry.FieldByName('FLD_m_nReserved7').AsInteger;//����Ӣ���ڹ��ȼ�(����)
      HumanRCD.Data.m_nReserved8:= dbQry.FieldByName('FLD_m_nReserved8').AsInteger;//����Ӣ���ڹ��ȼ�(����)
      HumanRCD.Data.Proficiency:= dbQry.FieldByName('FLD_Proficiency').AsInteger;//������(�������ؾ���)

      HumanRCD.Data.Reserved2:= dbQry.FieldByName('FLD_Reserved2').AsInteger;//Ԥ������2
      HumanRCD.Data.Reserved3:= dbQry.FieldByName('FLD_Reserved3').AsInteger;//Ԥ������3
      HumanRCD.Data.Reserved4:= dbQry.FieldByName('FLD_Reserved4').AsInteger;//Ԥ������4
      HumanRCD.Data.Exp68:= dbQry.FieldByName('FLD_Exp68').AsInteger;//����ʹ�ô˱���
      HumanRCD.Data.Reserved5:= dbQry.FieldByName('FLD_Reserved5').AsInteger;//Ԥ������5
      HumanRCD.Data.Reserved6:= dbQry.FieldByName('FLD_Reserved6').AsInteger;//Ԥ������6
      HumanRCD.Data.Reserved7:= dbQry.FieldByName('FLD_Reserved7').AsInteger;//Ԥ������7
      //HumanRCD.Data.Reserved8:= dbQry.FieldByName('FLD_Reserved8').AsInteger;//Ԥ������8
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL3, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.GetRecord (3)');
      Exit;
    end;
    if dbQry.RecordCount > 0 then begin
      V := TBinaryField(DBQry.FieldByName('FLD_UnKnow2')).AsVariant;
      if not VarIsNull(V) then begin
        PData := VarArrayLock(V);
        try
          Move(PData^, HumanRCD.Data.btUnKnow2, SizeOf(HumanRCD.Data.btUnKnow2));
        finally
          VarArrayUnlock(V);
        end;
      end;
      V := TBinaryField(DBQry.FieldByName('FLD_UnKnow')).AsVariant;
      if not VarIsNull(V) then begin
        PData := VarArrayLock(V);
        try
          Move(PData^, HumanRCD.Data.UnKnow, SizeOf(TUnKnow));
        finally
          VarArrayUnlock(V);
        end;
      end;
      V := TBinaryField(DBQry.FieldByName('FLD_STATUSTIMEARR')).AsVariant;
      if not VarIsNull(V) then begin
        PData := VarArrayLock(V);
        try
          Move(PData^, HumanRCD.Data.wStatusTimeArr, SizeOf(TStatusTime));
        finally
          VarArrayUnlock(V);
        end;
      end;
      V := TBinaryField(DBQry.FieldByName('FLD_QUESTFLAG')).AsVariant;
      if not VarIsNull(V) then begin
        PData := VarArrayLock(V);
        try
          Move(PData^, HumanRCD.Data.QuestFlag, SizeOf(TQuestFlag));
        finally
          VarArrayUnlock(V);
        end;
      end;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL4, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.GetRecord (4)');
      Exit;
    end;

    K:= 0; H:= 0;
    for I := 0 to dbQry.RecordCount - 1 do begin
      if dbQry.FieldByName('FLD_ZT').AsBoolean then begin//�ڹ�����
        if H >= MAXMAGIC then Continue;
        HumanRCD.Data.HumNGMagics[H].wMagIdx := dbQry.FieldByName('FLD_MAGID').AsInteger;
        HumanRCD.Data.HumNGMagics[H].btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
        HumanRCD.Data.HumNGMagics[H].btKey := dbQry.FieldByName('FLD_USEKEY').AsInteger;
        HumanRCD.Data.HumNGMagics[H].nTranPoint := dbQry.FieldByName('FLD_CURRTRAIN').AsInteger;
        Inc(H);
      end else begin//��ͨ����+��������
        if K >= MAXMAGIC then Continue;
        HumanRCD.Data.HumMagics[K].wMagIdx := dbQry.FieldByName('FLD_MAGID').AsInteger;
        HumanRCD.Data.HumMagics[K].btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
        HumanRCD.Data.HumMagics[K].btKey := dbQry.FieldByName('FLD_USEKEY').AsInteger;
        HumanRCD.Data.HumMagics[K].nTranPoint := dbQry.FieldByName('FLD_CURRTRAIN').AsInteger;
        Inc(K);
      end;
      dbQry.Next;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL5, [sChrName]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.GetRecord (5)');
      Exit;
    end;

    nCount := dbQry.RecordCount - 1;
    //if nCount > MAXBAGITEM + MAXUSEITEM - 1 then nCount := MAXBAGITEM + MAXUSEITEM - 1;
    if nCount > MAXBAGITEM + MAXUSEITEM then nCount := MAXBAGITEM + MAXUSEITEM;
    for I := 0 to nCount do begin
      nPosition := dbQry.FieldByName('FLD_POSITION').AsInteger - 1;//��Ʒ����

      if (nPosition >= 0) and (nPosition <= MAXUSEITEM) then begin
        if (nPosition <= 8) then begin
          HumanRCD.Data.HumItems[nPosition].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
          HumanRCD.Data.HumItems[nPosition].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
          HumanRCD.Data.HumItems[nPosition].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
          HumanRCD.Data.HumItems[nPosition].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
          V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
          V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btUnKnowValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btUnKnowValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
        end else begin
          HumanRCD.Data.HumAddItems[nPosition].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
          V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
          V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btUnKnowValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btUnKnowValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
        end;
      end else begin
        if (nPosition > MAXUSEITEM) then begin
          if nPosition = 14 then begin//��ýλ
            HumanRCD.Data.SpiritMedia.MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
            HumanRCD.Data.SpiritMedia.wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
            HumanRCD.Data.SpiritMedia.Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
            HumanRCD.Data.SpiritMedia.DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
            V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.SpiritMedia.btValue, SizeOf(HumanRCD.Data.SpiritMedia.btValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
            V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.SpiritMedia.btUnKnowValue, SizeOf(HumanRCD.Data.SpiritMedia.btUnKnowValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
          end else begin
            HumanRCD.Data.BagItems[nPosition - 15].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
            V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.BagItems[nPosition - 15].btValue, SizeOf(HumanRCD.Data.BagItems[nPosition - 15].btValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
            V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.BagItems[nPosition - 15].btUnKnowValue, SizeOf(HumanRCD.Data.BagItems[nPosition - 15].btUnKnowValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
          end;
        end;
      end;
      dbQry.Next;
    end;

    if not HumanRCD.Data.boIsHero then begin
      dbQry.SQL.Clear;
      dbQry.SQL.Add(Format(sSQL6, [sChrName]));
      try
        dbQry.Open;
      except
        Result := False;
        MainOutMessage('[�쳣] TFileDB.GetRecord (6)');
        Exit;
      end;

      nCount := dbQry.RecordCount - 1;
      if nCount > MAXBAGITEM - 1 then nCount := MAXBAGITEM - 1;
      for I := 0 to nCount do begin
        HumanRCD.Data.StorageItems[I].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
        HumanRCD.Data.StorageItems[I].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
        HumanRCD.Data.StorageItems[I].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
        HumanRCD.Data.StorageItems[I].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
        V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
        if not VarIsNull(V) then begin
          PData := VarArrayLock(V);
          try
            Move(PData^, HumanRCD.Data.HumItems[nPosition].btValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btValue));
          finally
            VarArrayUnlock(V);
          end;
        end;
        V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
        if not VarIsNull(V) then begin
          PData := VarArrayLock(V);
          try
            Move(PData^, HumanRCD.Data.HumItems[nPosition].btUnKnowValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btUnKnowValue));
          finally
            VarArrayUnlock(V);
          end;
        end;
        dbQry.Next;
      end;
    end;        
  finally
    dbQry.Close;
  end;
end;

function TFileDB.Get(nIndex: Integer; HumanRCD: pTHumDataInfo): Integer;
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if GetRecord(nIndex, HumanRCD) then Result := nIndex;
end;

function TFileDB.Update(nIndex: Integer; HumanRCD: pTHumDataInfo; btFlag: Byte): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(nIndex, HumanRCD, btFlag) then Result := True;
end;

function TFileDB.Add(HumanRCD: pTHumDataInfo): boolean;
var
  sChrName: string;
  nIndex: Integer;
begin
  sChrName := Trim(HumanRCD.Data.sChrName);
  if m_QuickList.GetIndex(sChrName) >= 0 then begin
    Result := False;
  end else begin
    nIndex := m_nRecordCount;
    Inc(m_nRecordCount);
    if UpdateRecord(nIndex, HumanRCD, 1) then begin
      m_QuickList.AddRecord(sChrName, nIndex);
      Result := True;
    end else begin
      Result := False;
    end;
  end;
end;

function TFileDB.UpdateRecord(nIndex: Integer; HumanRCD: pTHumDataInfo; btFlag: Byte): boolean;
var
  sdt, sName: string;
  I: Integer;
  HumData: pTHumData;
  MemoryStream: TMemoryStream;
  nCode: Byte;
begin
  Result := True;
  sdt := FormatDateTime(SQLDTFORMAT, Now);
  try
    DBQry.SQL.Clear;
    case btFlag of
      1:begin//New
        HumData := @HumanRCD.Data;
        DBQry.SQL.Clear;
        DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTERMIR(FLD_Account, FLD_CHARNAME, FLD_SEX, FLD_JOB, FLD_HAIR, FLD_HASHERO, FLD_ISHERO, FLD_EF, FLD_EXPRATE, FLD_MASTERNAME, FLD_CREATEDATE, FLD_DELETED) VALUES (' +
          '''%s'', ''%s'', %d, %d, %d, %d, %d , %d, %d,''%s'',''%s'', 0)',
          [Trim(HumData.sAccount), Trim(HumData.sChrName), HumData.btSex, HumData.btJob, HumData.btHair, BoolToInt(HumData.boHasHero), BoolToInt(HumData.boIsHero), HumData.btHeroType, HumData.nEXPRATE, HumData.sMasterName, sdt]));
        try
          DBQry.ExecSQL;
        except
          Result := False;
          MainOutMessage('[�쳣] TFileDB.UpdateRecord (1)');
          Exit;
        end;

        try
          with DBQry do begin
            SQL.Clear;
            SQL.Text := Format('INSERT INTO TBL_CHARBINRAY (FLD_LOGINID, FLD_CHARNAME, FLD_UnKnow2, FLD_UnKnow, FLD_QUESTFLAG, FLD_STATUSTIMEARR) ' +
                              'VALUES(''%s'',  ''%s'', :FLD_UnKnow2, :FLD_UnKnow, :FLD_QUESTFLAG, :FLD_STATUSTIMEARR)', [Trim(HumanRCD.Data.sAccount), Trim(HumanRCD.Data.sChrName)]);

            MemoryStream := TMemoryStream.Create;
            try
              MemoryStream.Write(HumanRCD.Data.btUnKnow2, SizeOf(HumanRCD.Data.btUnKnow2));
              Parameters.ParamByName('FLD_UnKnow2').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumanRCD.Data.UnKnow, SizeOf(TUnKnow));
              Parameters.ParamByName('FLD_UnKnow').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumanRCD.Data.QuestFlag, SizeOf(TQuestFlag));
              Parameters.ParamByName('FLD_QUESTFLAG').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumanRCD.Data.wStatusTimeArr, SizeOf(TStatusTime));
              Parameters.ParamByName('FLD_STATUSTIMEARR').LoadFromStream(MemoryStream, ftBytes);
            finally
              MemoryStream.Free;
            end;
            ExecSQL;
          end;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage('[�쳣] TFileDB.UpdateRecord (3)');
          end;
        end;
      end;//1
      2:begin//��������
        HumData := @HumanRCD.Data;
        DBQry.SQL.Clear;
        DBQry.SQL.Add(Format('UPDATE TBL_CHARACTERMIR SET FLD_DELETED=%d WHERE FLD_CHARNAME=''%s''',
          [BoolToInt(HumanRCD.Header.boDeleted), Trim(HumData.sChrName)]));
        try
          DBQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage(Format('[�쳣] TFileDB.UpdateRecord (4-9) %s',[E.Message]));
            Exit;
          end;
        end;
      end;
      else begin
        HumData := @HumanRCD.Data;
        sName:= '';
        if not HumanRCD.Header.boIsHero then sName:= Trim(HumanRCD.Header.sName);
        DBQry.SQL.Clear;
        DBQry.SQL.Add(Format('UPDATE TBL_CHARACTERMIR SET ' +
          'FLD_CREATEDATE=''%s'', ' +
          'FLD_CURMAP=''%s'', ' +
          'FLD_CX=%d, FLD_CY=%d, ' +
          'FLD_DIR=%d, ' +
          'FLD_HAIR=%d, ' +
          'FLD_SEX=%d, ' +
          'FLD_JOB=%d, ' +
          'FLD_GOLD=%d, ' +

          'FLD_LEVEL=%d, ' +
          'FLD_AC=%d, ' +
          'FLD_MAC=%d, ' +
          'FLD_DC=%d, ' +
          'FLD_MC=%d, ' +
          'FLD_SC=%d, ' +
          'FLD_HP=%d, ' +
          'FLD_MP=%d, ' +
          'FLD_MaxHP=%d, ' +
          'FLD_MaxMP=%d, ' +
          'FLD_NG=%d, ' +
          'FLD_MaxNG=%d, ' +
          'FLD_EXP=%d, ' +
          'FLD_MaxExp=%d, ' +
          'FLD_Weight=%d, ' +
          'FLD_MaxWeight=%d, ' +
          'FLD_WearWeight=%d, ' +
          'FLD_MaxWearWeight=%d, ' +
          'FLD_HandWeight=%d, ' +
          'FLD_MaxHandWeight=%d, ' +

          'FLD_HOMEMAP=''%s'', ' +

          'FLD_HOMEX=%d, FLD_HOMEY=%d, ' +
          'FLD_DEARNAME=''%s'', ' +
          'FLD_MASTERNAME=''%s'', ' +
          'FLD_MASTER=%d, ' +
          'FLD_CREDITPOINT=%d, ' +
          'FLD_btDivorce=%d, ' +
          'FLD_MARRYCOUNT=%d, ' +
          'FLD_StoragePwd=''%s'', ' +
          'FLD_ReLevel=%d, ' +

          'FLD_BONUSAC=%d, FLD_BONUSMAC=%d, FLD_BONUSDC=%d, FLD_BONUSMC=%d,'+
          'FLD_BONUSSC=%d,FLD_BONUSHP=%d, FLD_BONUSMP=%d, FLD_BONUSHIT=%d,'+
          'FLD_BONUSSPEED=%d, FLD_BONUX2=%d,' +

          'FLD_BONUSPOINT=%d, ' +
          'FLD_GAMEGOLD=%d, ' +
          'FLD_GAMEDIAMOND=%d, ' +
          'FLD_GAMEGIRD=%d, ' +
          'FLD_GAMEPOINT=%d, ' +
          'FLD_GAMEGLORY=%d, ' +
          'FLD_PayMentPoint=%d, ' +
          'FLD_Loyal=%d, ' +
          'FLD_PKPOINT=%d, ' +
          'FLD_ALLOWGROUP=%d, ' +

          'FLD_btF9=%d, ' +
          'FLD_AttatckMode=%d, ' +
          'FLD_INCHEALTH=%d, ' +
          'FLD_INCSPELL=%d, ' +
          'FLD_INCHEALING=%d, ' +
          'FLD_FIGHTZONEDIECOUNT=%d, ' +
          'FLD_Account=''%s'', ' +
          'FLD_EF=%d, ' +
          'FLD_LockLogon=%d, ' +
          'FLD_Contribution=%d, ' +

          'FLD_HungerStatus=%d, ' +
          'FLD_AllowGuildReCall=%d, ' +
          'FLD_GroupRcallTime=%d, ' +
          'FLD_BODYLUCK=%F, ' +
          'FLD_AllowGroupReCall=%d, ' +
          'FLD_EXPRATE=%d, ' +
          'FLD_ExpTime=%d, ' +
          'FLD_LastOutStatus=%d, ' +
          'FLD_MasterCount=%d, ' +
          'FLD_HasHero=%d, ' +

          'FLD_IsHero=%d, ' +
          'FLD_Status=%d, ' +
          'FLD_HeroChrName=''%s'', ' +
          'FLD_WinExp=%d, ' +
          'FLD_UsesItemTick=%d, ' +
          'FLD_nReserved=%d, ' +
          'FLD_nReserved1=%d, ' +
          'FLD_nReserved2=%d, ' +
          'FLD_nReserved3=%d, ' +
          'FLD_n_Reserved=%d, ' +

          'FLD_n_Reserved1=%d, ' +
          'FLD_n_Reserved2=%d, ' +
          'FLD_n_Reserved3=%d, ' +
          'FLD_boReserved=%d, ' +
          'FLD_boReserved1=%d, ' +
          'FLD_boReserved2=%d, ' +
          'FLD_boReserved3=%d, ' +
          'FLD_GiveDate=%d, ' +
          'FLD_MaxExp68=%d, ' +
          'FLD_ExpSkill69=%d, ' +

          'FLD_m_nReserved1=%d, ' +
          'FLD_m_nReserved2=%d, ' +
          'FLD_m_nReserved3=%d, ' +
          'FLD_m_nReserved4=%d, ' +
          'FLD_m_nReserved5=%d, ' +
          'FLD_m_nReserved6=%d, ' +
          'FLD_m_nReserved7=%d, ' +
          'FLD_m_nReserved8=%d, ' +
          'FLD_Proficiency=%d, ' +
          'FLD_Reserved2=%d, ' +
          'FLD_Reserved3=%d, ' +
          'FLD_Reserved4=%d, ' +
          'FLD_Exp68=%d, ' +
          'FLD_Reserved5=%d, ' +
          'FLD_Reserved6=%d, ' +
          'FLD_Reserved7=%d, ' +
          //'FLD_Reserved8=%d, ' +
          'FLD_DeputyHeroName=''%s'', ' +

          'FLD_DELETED=%d WHERE FLD_CHARNAME=''%s''',
          [FormatDateTime(SQLDTFORMAT, Now),
          Trim(HumData.sCurMap),
            HumData.wCurX, HumData.wCurY,
            HumData.btDir,
            HumData.btHair,
            HumData.btSex,
            HumData.btJob,
            HumData.nGold,
            HumData.Abil.Level, HumData.Abil.AC, HumData.Abil.MAC, HumData.Abil.DC,
            HumData.Abil.MC, HumData.Abil.SC, HumData.Abil.HP, HumData.Abil.MP,
            HumData.Abil.MaxHP, HumData.Abil.MaxMP, HumData.Abil.NG, HumData.Abil.MaxNG,
            HumData.Abil.nExp, HumData.Abil.nMaxExp, HumData.Abil.Weight, HumData.Abil.MaxWeight,
            HumData.Abil.WearWeight, HumData.Abil.MaxWearWeight, HumData.Abil.HandWeight, HumData.Abil.MaxHandWeight,
            Trim(HumData.sHomeMap),

            HumData.wHomeX, HumData.wHomeY,
            Trim(HumData.sDearName),
            Trim(HumData.sMasterName),
            BoolToInt(HumData.boMaster),
            HumData.btCreditPoint,
            HumData.btDivorce,
            HumData.btMarryCount,
            Trim(HumData.sStoragePwd),
            HumData.btReLevel,

            HumData.BonusAbil.AC, HumData.BonusAbil.MAC, HumData.BonusAbil.DC, HumData.BonusAbil.MC,
            HumData.BonusAbil.SC, HumData.BonusAbil.HP, HumData.BonusAbil.MP, HumData.BonusAbil.Hit,
            HumData.BonusAbil.Speed, HumData.BonusAbil.X2,

            HumData.nBonusPoint,
            HumData.nGameGold,
            HumData.nGameDiamond,
            HumData.nGameGird,
            HumData.nGamePoint,
            HumData.btGameGlory,
            HumData.nPayMentPoint,
            HumData.nLoyal,
            HumData.nPKPOINT,
            HumData.btAllowGroup,

            HumData.btF9,
            HumData.btAttatckMode,
            HumData.btIncHealth,
            HumData.btIncSpell,
            HumData.btIncHealing,
            HumData.btFightZoneDieCount,
            Trim(HumData.sAccount),
            HumData.btHeroType,
          BoolToInt(HumData.boLockLogon),
            HumData.wContribution,

            HumData.nHungerStatus,
            BoolToInt(HumData.boAllowGuildReCall),
            HumData.wGroupRcallTime,
            HumData.dBodyLuck,
            BoolToInt(HumData.boAllowGroupReCall),
            HumData.nEXPRATE,
            HumData.nExpTime,
            HumData.btLastOutStatus,
            HumData.wMasterCount,
            BoolToInt(HumData.boHasHero),

            BoolToInt(HumData.boIsHero),
            HumData.btStatus,
            Trim(HumData.sHeroChrName),
            HumData.n_WinExp,
            HumData.n_UsesItemTick,
            HumData.nReserved,
            HumData.nReserved1,
            HumData.nReserved2,
            HumData.nReserved3,
            HumData.n_Reserved,

            HumData.n_Reserved1,
            HumData.n_Reserved2,
            HumData.n_Reserved3,
            BoolToInt(HumData.boReserved),
            BoolToInt(HumData.boReserved1),
            BoolToInt(HumData.boReserved2),
            BoolToInt(HumData.boReserved3),
            HumData.m_GiveDate,
            HumData.MaxExp68,
            HumData.nExpSkill69,
          
            HumData.m_nReserved1,
            HumData.m_nReserved2,
            HumData.m_nReserved3,
            HumData.m_nReserved4,
            HumData.m_nReserved5,
            HumData.m_nReserved6,
            HumData.m_nReserved7,
            HumData.m_nReserved8,
            HumData.Proficiency,
            HumData.Reserved2,//Ԥ������2
            HumData.Reserved3,//Ԥ������3
            HumData.Reserved4,//Ԥ������4
            HumData.Exp68,//����ʹ�ô˱���
            HumData.Reserved5,//Ԥ������5
            HumData.Reserved6,//Ԥ������6
            HumData.Reserved7,//Ԥ������7
            //HumData.Reserved8,//Ԥ������8
            Trim(sName),
            BoolToInt(HumanRCD.Header.boDeleted), Trim(HumData.sChrName)]));
        try
          DBQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage(Format('[�쳣] TFileDB.UpdateRecord (4) %s',[E.Message]));
            Exit;
          end;
        end;
  //==============================================================================
        try
          DBQry.SQL.Clear;
          DBQry.SQL.Text := Format('UPDATE TBL_CHARBINRAY SET FLD_UnKnow2=:FLD_UnKnow2, FLD_UnKnow=:FLD_UnKnow, FLD_QUESTFLAG=:FLD_QUESTFLAG, FLD_STATUSTIMEARR=:FLD_STATUSTIMEARR ' +
            'WHERE FLD_CHARNAME=''%s''', [Trim(HumData.sChrName)]);

          MemoryStream := TMemoryStream.Create;
          try
            MemoryStream.Write(HumData.btUnKnow2, SizeOf(HumData.btUnKnow2));
            DBQry.Parameters.ParamByName('FLD_UnKnow2').LoadFromStream(MemoryStream, ftBytes);
            MemoryStream.Clear;

            MemoryStream.Write(HumData.UnKnow, SizeOf(TUnKnow));
            DBQry.Parameters.ParamByName('FLD_UnKnow').LoadFromStream(MemoryStream, ftBytes);
            MemoryStream.Clear;

            MemoryStream.Write(HumanRCD.Data.QuestFlag, SizeOf(TQuestFlag));
            DBQry.Parameters.ParamByName('FLD_QUESTFLAG').LoadFromStream(MemoryStream, ftBytes);
            MemoryStream.Clear;
          
            MemoryStream.Write(HumanRCD.Data.wStatusTimeArr, SizeOf(TStatusTime));
            DBQry.Parameters.ParamByName('FLD_STATUSTIMEARR').LoadFromStream(MemoryStream, ftBytes);
          finally
            MemoryStream.Free;
          end;
          DBQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage('[�쳣] TFileDB.UpdateRecord (5)');
          end;
        end;
  //==============================================================================
        DBQry.SQL.Clear;
        DBQry.SQL.Add(Format('DELETE FROM TBL_CHARACTER_MAGIC WHERE FLD_CHARNAME=''%s''', [Trim(HumData.sChrName)]));
        try
          DBQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage('[�쳣] TFileDB.UpdateRecord (6)');
          end;
        end;
        for I := 0 to High(HumData.HumMagics) do begin
          if HumData.HumMagics[I].wMagIdx > 0 then begin
            DBQry.SQL.Clear;
            DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_MAGIC(FLD_LOGINID, FLD_CHARNAME, FLD_MAGID, FLD_LEVEL, FLD_USEKEY, FLD_CURRTRAIN, FLD_ZT) VALUES ' +
              '( ''%s'', ''%s'', %d, %d, %d, %d, 0)',
              [Trim(HumData.sAccount), Trim(HumData.sChrName),
              HumData.HumMagics[I].wMagIdx, HumData.HumMagics[I].btLevel,
                HumData.HumMagics[I].btKey, HumData.HumMagics[I].nTranPoint]));

            try
              DBQry.ExecSQL;
            except
              on E: Exception do begin
                Result := False;
                MainOutMessage('[�쳣] TFileDB.UpdateRecord (7-1)');
              end;
            end;
          end;
        end;
        for I := 0 to High(HumData.HumNGMagics) do begin
          if HumData.HumNGMagics[I].wMagIdx > 0 then begin
            DBQry.SQL.Clear;
            DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_MAGIC(FLD_LOGINID, FLD_CHARNAME, FLD_MAGID, FLD_LEVEL, FLD_USEKEY, FLD_CURRTRAIN, FLD_ZT) VALUES ' +
              '( ''%s'', ''%s'', %d, %d, %d, %d, 1)',
              [Trim(HumData.sAccount), Trim(HumData.sChrName),
              HumData.HumNGMagics[I].wMagIdx, HumData.HumNGMagics[I].btLevel,
                HumData.HumNGMagics[I].btKey, HumData.HumNGMagics[I].nTranPoint]));
            try
              DBQry.ExecSQL;
            except
              on E: Exception do begin
                Result := False;
                MainOutMessage('[�쳣] TFileDB.UpdateRecord (7-2)');
              end;
            end;
          end;
        end;
  //==============================================================================
        DBQry.SQL.Clear;
        DBQry.SQL.Add(Format('DELETE FROM TBL_CHARACTER_ITEM WHERE FLD_CHARNAME=''%s''', [Trim(HumData.sChrName)]));
        try
          DBQry.ExecSQL;
        except
          on E: Exception do begin
            Result := False;
            MainOutMessage('[�쳣] TFileDB.UpdateRecord (8)');
          end;
        end;

        if (HumData.SpiritMedia.wIndex > 0) and (HumData.SpiritMedia.MakeIndex > 0) then begin//������ý����
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_ITEM(FLD_LOGINID, FLD_CHARNAME, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE, FLD_UnKnowValue) VALUES ' +
            '( ''%s'', ''%s'', %d, %d, %d, %d, %d, :a1, :a2)',
            [Trim(HumData.sAccount), Trim(HumData.sChrName), 15,
            HumData.SpiritMedia.MakeIndex, HumData.SpiritMedia.wIndex, HumData.SpiritMedia.Dura, HumData.SpiritMedia.DuraMax]));
            MemoryStream := TMemoryStream.Create;
            try
              MemoryStream.Write(HumData.SpiritMedia.btValue, SizeOf(HumData.SpiritMedia.btValue));
              DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumData.SpiritMedia.btUnKnowValue, SizeOf(HumData.SpiritMedia.btUnKnowValue));
              DBQry.Parameters.ParamByName('a2').LoadFromStream(MemoryStream, ftBytes);
            finally
              MemoryStream.Free;
            end;
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage(Format('[�쳣] TFileDB.UpdateRecord (9-1) %s',[E.Message]));
            end;
          end;
        end;

        for I := 0 to High(HumData.BagItems) do begin
          if (HumData.BagItems[I].wIndex > 0) and (HumData.BagItems[I].MakeIndex > 0) then begin
            DBQry.SQL.Clear;
            DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_ITEM(FLD_LOGINID, FLD_CHARNAME, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
              'FLD_VALUE, FLD_UnKnowValue) VALUES ' +
              '( ''%s'', ''%s'', %d, %d, %d, %d, %d, :a1, :a2)',
              [Trim(HumData.sAccount), Trim(HumData.sChrName), I + 16,
              HumData.BagItems[I].MakeIndex, HumData.BagItems[I].wIndex, HumData.BagItems[I].Dura, HumData.BagItems[I].DuraMax]));
              nCode:= 1;
              MemoryStream := TMemoryStream.Create;
              try
                MemoryStream.Write(HumData.BagItems[I].btValue, SizeOf(HumData.BagItems[I].btValue));
                DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
                MemoryStream.Clear;
                nCode:= 2;
                MemoryStream.Write(HumData.BagItems[I].btUnKnowValue, SizeOf(HumData.BagItems[I].btUnKnowValue));
                nCode:= 3;
                DBQry.Parameters.ParamByName('a2').LoadFromStream(MemoryStream, ftBytes);
              finally
                MemoryStream.Free;
              end;
            try
              DBQry.ExecSQL;
            except
              on E: Exception do begin
                Result := False;
                MainOutMessage(Format('[�쳣] TFileDB.UpdateRecord (9) %d %s',[nCode, E.Message]));
              end;
            end;
          end;
        end;
  //==============================================================================
        for I := 0 to High(HumData.HumItems) do begin
          if (HumData.HumItems[I].wIndex > 0) and (HumData.HumItems[I].MakeIndex > 0) then begin
            DBQry.SQL.Clear;
            DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_ITEM(FLD_LOGINID, FLD_CHARNAME, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
              'FLD_VALUE, FLD_UnKnowValue) VALUES ( ''%s'', ''%s'', %d, %d, %d, %d, %d, :FLD_VALUE, :a2)',
              [Trim(HumData.sAccount), Trim(HumData.sChrName), I + 1,
              HumData.HumItems[I].MakeIndex, HumData.HumItems[I].wIndex, HumData.HumItems[I].Dura, HumData.HumItems[I].DuraMax]));
              MemoryStream := TMemoryStream.Create;
              try
                MemoryStream.Write(HumData.HumItems[I].btValue, SizeOf(HumData.HumItems[I].btValue));
                DBQry.Parameters.ParamByName('FLD_VALUE').LoadFromStream(MemoryStream, ftBytes);
                MemoryStream.Clear;

                MemoryStream.Write(HumData.HumItems[I].btUnKnowValue, SizeOf(HumData.HumItems[I].btUnKnowValue));
                DBQry.Parameters.ParamByName('a2').LoadFromStream(MemoryStream, ftBytes);
              finally
                MemoryStream.Free;
              end;
            try
              DBQry.ExecSQL;
            except
              on E: Exception do begin
                Result := False;
                MainOutMessage(Format('[�쳣] TFileDB.UpdateRecord (10-1) %s',[E.Message]));
              end;
            end;
          end;
        end;
        for I := 9 to High(HumData.HumAddItems) do begin
          if (HumData.HumAddItems[I].wIndex > 0) and (HumData.HumAddItems[I].MakeIndex > 0) then begin
            DBQry.SQL.Clear;
            DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_ITEM(FLD_LOGINID, FLD_CHARNAME, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
              'FLD_VALUE, FLD_UnKnowValue) VALUES ( ''%s'', ''%s'', %d, %d, %d, %d, %d, :FLD_VALUE, :a1)',
              [Trim(HumData.sAccount), Trim(HumData.sChrName), I + 1,
              HumData.HumAddItems[I].MakeIndex, HumData.HumAddItems[I].wIndex, HumData.HumAddItems[I].Dura,
                HumData.HumAddItems[I].DuraMax]));
              MemoryStream := TMemoryStream.Create;
              try
                MemoryStream.Write(HumData.HumAddItems[I].btValue, SizeOf(HumData.HumAddItems[I].btValue));
                DBQry.Parameters.ParamByName('FLD_VALUE').LoadFromStream(MemoryStream, ftBytes);
                MemoryStream.Clear;

                MemoryStream.Write(HumData.HumAddItems[I].btUnKnowValue, SizeOf(HumData.HumAddItems[I].btUnKnowValue));
                DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
              finally
                MemoryStream.Free;
              end;
            try
              DBQry.ExecSQL;
            except
              on E: Exception do begin
                Result := False;
                MainOutMessage('[�쳣] TFileDB.UpdateRecord (10-2)');
              end;
            end;
          end;
        end;
  //==============================================================================
        if not HumanRCD.Data.boIsHero then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('DELETE FROM TBL_CHARACTER_STORAGE WHERE FLD_CHARNAME=''%s''', [Trim(HumData.sChrName)]));
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage('[�쳣] TFileDB.UpdateRecord (11)');
            end;
          end;

          for I := 0 to High(HumData.StorageItems) do begin
            if (HumData.StorageItems[I].wIndex > 0) and (HumData.StorageItems[I].MakeIndex > 0) then begin
              DBQry.SQL.Clear;
              DBQry.SQL.Add(Format('INSERT INTO TBL_CHARACTER_STORAGE(FLD_LOGINID, FLD_CHARNAME, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
                'FLD_VALUE, FLD_UnKnowValue) VALUES (''%s'',''%s'', %d, %d, %d, %d, :FLD_VALUE, :a1)',
                [Trim(HumData.sAccount), Trim(HumData.sChrName),
                HumData.StorageItems[I].MakeIndex, HumData.StorageItems[I].wIndex, HumData.StorageItems[I].Dura, HumData.StorageItems[I].DuraMax]));
              MemoryStream := TMemoryStream.Create;
              try
                MemoryStream.Write(HumData.StorageItems[I].btValue, SizeOf(HumData.StorageItems[I].btValue));
                DBQry.Parameters.ParamByName('FLD_VALUE').LoadFromStream(MemoryStream, ftBytes);
                MemoryStream.Clear;

                MemoryStream.Write(HumData.StorageItems[I].btUnKnowValue, SizeOf(HumData.StorageItems[I].btUnKnowValue));
                DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
              finally
                MemoryStream.Free;
              end;
              try
                DBQry.ExecSQL;
              except
                on E: Exception do begin
                  Result := False;
                  MainOutMessage('[�쳣] TFileDB.UpdateRecord (12)');
                end;
              end;
            end;
          end;
        end;
      end;
    end;//case
    m_boChanged := True;
  finally
    DBQry.Close;
  end;
end;

function TFileDB.DeleteRecord(nIndex: Integer): boolean;
var
  sChrName: string;
resourcestring
  sSQL  = 'DELETE FROM TBL_CHARACTERMIR WHERE FLD_CHARNAME=''%s''';
  sSQL3 = 'DELETE FROM TBL_CHARBINRAY WHERE FLD_CHARNAME=''%s''';
  sSQL4 = 'DELETE FROM TBL_CHARACTER_MAGIC WHERE FLD_CHARNAME=''%s''';
  sSQL5 = 'DELETE FROM TBL_CHARACTER_ITEM WHERE FLD_CHARNAME=''%s''';
  sSQL6 = 'DELETE FROM TBL_CHARACTER_STORAGE WHERE FLD_CHARNAME=''%s''';
begin
  Result := True;
  sChrName := m_QuickList[nIndex];
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [sChrName]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.DeleteRecord (1)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL3, [sChrName]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.DeleteRecord (3)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL4, [sChrName]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.DeleteRecord (4)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL5, [sChrName]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.DeleteRecord (5)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL6, [sChrName]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileDB.DeleteRecord (6)');
    end;

    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

function TFileDB.Query(SQL: string): boolean;
begin
  Result := False;
  try
    DBQry.Close;
    DBQry.SQL.Clear;
    DBQry.SQL.Add(SQL);
    try
      DBQry.Open;
      Result := True;
    except
      on E: Exception do begin
        Result := False;
        MainOutMessage('[�쳣] TFileDB.Query');
      end;
    end;
  finally
    //DBQry.Close;
  end;
end;

function TFileDB.Edit(SQL: string): boolean;
begin
  Result := False;
  try
    DBQry.SQL.Clear;
    DBQry.SQL.Add(SQL);
    try
      DBQry.ExecSQL;
      Result := True;
    except
      on E: Exception do begin
        Result := False;
        MainOutMessage('[�쳣] TFileDB.Edit');
      end;
    end;
  finally
    DBQry.Close;
  end;
end;
{$ELSE}  
function TFileDB.LoadDBIndex: Boolean; //0x0048AA6C
var
  nIdxFileHandle: Integer;
  IdxHeader: TIdxHeader;
  DBHeader: TDBHeader;
  IdxRecord: TIdxRecord;
  HumRecord: THumDataInfo;
  i: Integer;
  n14: Integer;
begin
  Result := False;
  nIdxFileHandle := 0;
  FillChar(IdxHeader, SizeOf(TIdxHeader), #0);
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone);
  if nIdxFileHandle > 0 then begin
    Result := True;
    FileRead(nIdxFileHandle, IdxHeader, SizeOf(TIdxHeader));

    try
      if Open then begin
        FileSeek(m_nFileHandle, 0, 0);
        if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
          if IdxHeader.nHumCount <> DBHeader.nHumCount then
            Result := False;
          if IdxHeader.sDesc <> sDBIdxHeaderDesc then
            Result := False;
        end; //0x0048AB65
        if IdxHeader.nLastIndex <> DBHeader.nLastIndex then begin
          Result := False;
        end;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle, IdxHeader.nLastIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0);
          if FileRead(m_nFileHandle, HumRecord, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then
            if IdxHeader.dUpdateDate <> HumRecord.Header.dCreateDate then
              Result := False;
        end;
      end; //0x0048ABD7
    finally
      Close();
    end;
    if Result then begin
      m_nLastIndex := IdxHeader.nLastIndex;
      m_dUpdateTime := IdxHeader.dUpdateDate;
      if IdxHeader.nQuickCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nQuickCount - 1 do begin
          if FileRead(nIdxFileHandle, IdxRecord, SizeOf(TIdxRecord)) = SizeOf(TIdxRecord) then begin
            m_QuickList.AddObject(IdxRecord.sChrName, TObject(IdxRecord.nIndex));
          end else begin
            Result := False;
            break;
          end;
        end; //0048AC7A
      end;
      if IdxHeader.nDeleteCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nDeleteCount - 1 do begin
          if FileRead(nIdxFileHandle, n14, SizeOf(Integer)) = SizeOf(Integer) then
            m_DeletedList.Add(Pointer(n14))
          else begin
            Result := False;
            break;
          end;
        end;
      end;
    end; //0048ACC5
    FileClose(nIdxFileHandle);
  end; //0048ACCD
  if Result then begin
    n4ADAE4 := m_QuickList.Count;
    n4ADAE8 := m_QuickList.Count;
    n4ADAF0 := DBHeader.nHumCount;
    m_QuickList.SortString(0, m_QuickList.Count - 1);
  end else m_QuickList.Clear;
end;

procedure TFileDB.LoadQuickList; //0x0048A440
var
  nIndex,KK: Integer;
  DBHeader: TDBHeader;
  RecordHeader: TRecordHeader;
  ChrRecord: THumDataInfo;
begin
  n4 := 0;
  m_QuickList.Clear;
  m_DeletedList.Clear;
  n4ADAE4 := 0;
  n4ADAE8 := 0;
  n4ADAF0 := 0;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADAF0 := DBHeader.nHumCount;
        if DBHeader.nHumCount > 0 then begin//20090101
          for nIndex := 0 to DBHeader.nHumCount - 1 do begin
            Inc(n4ADAE4);
            if FileSeek(m_nFileHandle, nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0) = -1 then break;
            if FileRead(m_nFileHandle, RecordHeader, SizeOf(TRecordHeader)) <> SizeOf(TRecordHeader) then break;
            if not RecordHeader.boDeleted then begin
              if RecordHeader.sName <> '' then begin
                m_QuickList.AddObject(RecordHeader.sName, TObject(nIndex));
                Inc(n4ADAE8);
              end else m_DeletedList.Add(TObject(nIndex));
            end else begin
              {if RecordHeader.sName <> '' then begin//20110930 �޸�;��������󣬹ص����򣬿ɻ�ԭ��������
                m_QuickList.AddObject(RecordHeader.sName, TObject(nIndex));
              end else}m_DeletedList.Add(TObject(nIndex));
              Inc(n4ADAEC);
            end;
            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
          end;
        end else begin//20090913 ���ӣ��������ļ�����ʱ��ͷ�ṹ����ʱʹ��

          while (True) do begin
            if FileRead(m_nFileHandle, ChrRecord, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then begin
              if not ChrRecord.Header.boDeleted then begin
                if ChrRecord.Header.sName <> '' then begin
                  m_QuickList.AddObject(ChrRecord.Header.sName, TObject(nIndex));
                  Inc(n4ADAE8);
                end else m_DeletedList.Add(TObject(nIndex));
              end else begin
                m_DeletedList.Add(TObject(nIndex));
                Inc(n4ADAEC);
              end;
            end else break;

            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
            Inc(nIndex);
          end;
          if DBHeader.nHumCount <> m_QuickList.Count + m_DeletedList.Count then begin
            DBHeader.nHumCount := m_QuickList.Count + m_DeletedList.Count;
            FileSeek(m_nFileHandle, 0, 0);
            FileWrite(m_nFileHandle, DBHeader, SizeOf(TDBHeader));
          end;
        end;
      end;
    end;
  finally
    Close();
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  m_nLastIndex := m_Header.nLastIndex;
  m_dUpdateTime := m_Header.dLastDate;
  boDataDBReady := True;
end;

function TFileDB.OpenEx(boRead : Boolean = False): Boolean; //�������еİ�ȫ�� By TasNat at: 2012-03-09 12:57:50//0x0048A27C
var
  DBHeader: TDBHeader;
begin
  Lock();
  m_boChanged := False;
    if boRead then
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result := True;
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header := DBHeader;
    n4 := 0;
  end else Result := False;
end;

function TFileDB.GetRecord(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;
begin
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0) <> -1 then begin
    FileRead(m_nFileHandle, HumanRCD, SizeOf(THumDataInfo));
    FileSeek(m_nFileHandle, -SizeOf(THumDataInfo), 1);
    n4 := nIndex;
    Result := True;
  end else Result := False;
end;

function TFileDB.Get(nIndex: Integer; var HumanRCD: THumDataInfo): Integer; //0x0048B320
var
  nIdx: Integer;
begin
  nIdx := Integer(m_QuickList.Objects[nIndex]);
  if GetRecord(nIdx, HumanRCD) then Result := nIdx
  else Result := -1;
end;

function TFileDB.Update(nIndex: Integer; var HumanRCD: THumDataInfo): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumanRCD, False) then Result := True;
end;

function TFileDB.Add(var HumanRCD: THumDataInfo): Boolean;
var
  sHumanName: string;
  DBHeader: TDBHeader;
  nIdx: Integer;
begin
  sHumanName := HumanRCD.Header.sName;
  if m_QuickList.GetIndex(sHumanName) >= 0 then begin
    Result := False;
  end else begin
    DBHeader := m_Header;
    if m_DeletedList.Count > 0 then begin
      nIdx := Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIdx := m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;

    if UpdateRecord(nIdx, HumanRCD, True) then begin
      m_QuickList.AddRecord(HumanRCD.Header.sName, nIdx);
      Result := True;
    end else begin
      m_Header := DBHeader;
      Result := False;
    end;
  end;
end;

function TFileDB.UpdateRecord(nIndex: Integer; var HumanRCD: THumDataInfo; boNew: Boolean): Boolean;
var
  nPosion, n10: Integer;
  dt20: TDateTime;
  ReadRCD: THumDataInfo;
begin
  nPosion := nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    dt20 := Now();
    m_nLastIndex := nIndex;
    m_dUpdateTime := dt20;
    n10 := FileSeek(m_nFileHandle, 0, 1);
    if boNew
      and (FileRead(m_nFileHandle, ReadRCD, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo))
      and not ReadRCD.Header.boDeleted and (ReadRCD.Header.sName <> '') then begin
      Result := False;
    end else begin
      //HumanRCD.Header.boDeleted := False;//20080515 ע��
      HumanRCD.Header.dCreateDate := Now();
      m_Header.n70:= nDBVersion;//20100902
      m_Header.nLastIndex := m_nLastIndex;
      m_Header.dLastDate := m_dUpdateTime;
      m_Header.dUpdateDate := Now();
      FileSeek(m_nFileHandle, 0, 0);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      FileSeek(m_nFileHandle, n10, 0);
      FileWrite(m_nFileHandle, HumanRCD, SizeOf(THumDataInfo));
      FileSeek(m_nFileHandle, -SizeOf(THumDataInfo), 1);
      n4 := nIndex;
      m_boChanged := True;
      Result := True;
    end;
  end else Result := False;
end;

function TFileDB.DeleteRecord(nIndex: Integer): Boolean;
var
  ChrRecordHeader: TRecordHeader;
begin
  Result := False;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THumDataInfo) + SizeOf(TDBHeader), 0) = -1 then Exit;
  m_nLastIndex := nIndex;
  m_dUpdateTime := Now();
  ChrRecordHeader.boDeleted := True;
  ChrRecordHeader.dCreateDate := Now();
  FileWrite(m_nFileHandle, ChrRecordHeader, SizeOf(TRecordHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_Header.nLastIndex := m_nLastIndex;
  m_Header.dLastDate := m_dUpdateTime;
  m_Header.dUpdateDate := Now();
  FileSeek(m_nFileHandle, 0, 0);
  FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  m_boChanged := True;
  Result := True;
end;

procedure TFileDB.SaveIndex; //0x0048A83C
var
  IdxHeader: TIdxHeader;
  nIdxFileHandle: Integer;
  i: Integer;
  nDeletedIdx: Integer;
  IdxRecord: TIdxRecord;
begin
  FillChar(IdxHeader, SizeOf(TIdxHeader), #0);
  IdxHeader.sDesc := sDBIdxHeaderDesc;
  IdxHeader.nQuickCount := m_QuickList.Count;
  IdxHeader.nHumCount := m_Header.nHumCount;
  IdxHeader.nDeleteCount := m_DeletedList.Count;
  IdxHeader.nLastIndex := m_nLastIndex;
  IdxHeader.dUpdateDate := m_dUpdateTime;
  IdxHeader.n70:= nDBVersion;
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone)
  else nIdxFileHandle := FileCreate(m_sIdxFileName);

  if nIdxFileHandle > 0 then begin
    FileWrite(nIdxFileHandle, IdxHeader, SizeOf(TIdxHeader));
    if m_QuickList.Count > 0 then begin//20090101
      for i := 0 to m_QuickList.Count - 1 do begin
        IdxRecord.sChrName := m_QuickList.Strings[i];
        IdxRecord.nIndex := Integer(m_QuickList.Objects[i]);
        FileWrite(nIdxFileHandle, IdxRecord, SizeOf(TIdxRecord));
      end;
    end;
    if m_DeletedList.Count > 0 then begin//20090101
      for i := 0 to m_DeletedList.Count - 1 do begin
        nDeletedIdx := Integer(m_DeletedList.Items[i]);
        FileWrite(nIdxFileHandle, nDeletedIdx, SizeOf(Integer));
      end;
    end;
    FileClose(nIdxFileHandle);
  end;
end;
{$IFEND}

procedure TFileDB.Lock; //00048A254
begin
  EnterCriticalSection(HumDB_CS);
end;
procedure TFileDB.UnLock; //0048A268
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileDB.Open(boRead : Boolean = False): Boolean; //�������еİ�ȫ�� By TasNat at: 2012-03-09 12:57:50//0048A304
begin
  Result := False;
  Lock();
{$IF DBSMode = 1}
  m_boChanged := False;
  Result := True;
{$ELSE}
  n4 := 0;
  m_boChanged := False;
  if FileExists(m_sDBFileName) then begin
    if boRead then
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then begin
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end else begin
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.n70 := nDBVersion;
      m_Header.nHumCount := 0;
      m_Header.n6C := 0;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
{$IFEND}
end;

procedure TFileDB.Close; //0x0048A400
begin
{$IF DBSMode = 0}
  FileClose(m_nFileHandle);
{$IFEND}
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;

function TFileDB.Index(sName: string): Integer; //0x0048B534
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileDB.Find(sChrName: string; List: TStrings): Integer;
var
  i: Integer;
begin
  if m_QuickList.Count > 0 then begin//20090101
    for i := 0 to m_QuickList.Count - 1 do begin
      if CompareLStr(m_QuickList.Strings[i], sChrName, Length(sChrName)) then begin
        List.AddObject(m_QuickList.Strings[i], m_QuickList.Objects[i]);
      end;
    end;
  end;
  Result := List.Count;
end;

function TFileDB.Delete(nIndex: Integer): Boolean;
{$IF DBSMode = 0}
var
  i: Integer;
{$IFEND}
begin
  Result := False;
  {$IF DBSMode = 1}
  if (nIndex >= 0) and (nIndex < m_QuickList.Count) then begin
    if DeleteRecord(nIndex) then begin
      m_QuickList.Delete(nIndex);
      Result := True;
    end;
  end;
  {$ELSE}
  if m_QuickList.Count > 0 then begin//20090101
    for i := 0 to m_QuickList.Count - 1 do begin
      if Integer(m_QuickList.Objects[i]) = nIndex then begin
        if DeleteRecord(nIndex) then begin
          m_QuickList.Delete(i);
          Result := True;
          break;
        end;
      end;
    end;
  end;
  {$IFEND}
end;

procedure TFileDB.Rebuild; //0x0048A688
{$IF DBSMode = 0}
var
  sTempFileName: string;
  nHandle, n10: Integer;
  DBHeader: TDBHeader;
  ChrRecord: THumDataInfo;
{$IFEND}  
begin
{$IF DBSMode = 0}
  sTempFileName := 'Mir#$00.DB';
  if FileExists(sTempFileName) then DeleteFile(sTempFileName);
  nHandle := FileCreate(sTempFileName);
  n10 := 0;
  if nHandle < 0 then Exit;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
        while FileRead(m_nFileHandle, ChrRecord, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) do begin
          if ChrRecord.Header.boDeleted then Continue;
          FileWrite(nHandle, ChrRecord, SizeOf(THumDataInfo));
          Inc(n10);
        end;
        DBHeader.nHumCount := n10;
        DBHeader.dUpdateDate := Now();
        FileSeek(nHandle, 0, 0);
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
      end;
    end;
  finally
    Close;
  end;
  FileClose(nHandle);
  FileCopy(sTempFileName, m_sDBFileName);
  DeleteFile(sTempFileName);
{$IFEND}
end;

function TFileDB.Count: Integer;
begin
  Result := m_QuickList.Count;
end;

function TFileDB.Delete(sChrName: string): Boolean;
var
  n10: Integer;
begin
  Result := False;
  n10 := m_QuickList.GetIndex(sChrName);
  if n10 < 0 then Exit;
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
{ TFileHeroDB �������ݲ����� 20100112}
constructor TFileHeroDB.Create(sFileName: string);
begin
  {$IF DBSMode = 1}
  inherited Create;
  CoInitialize(nil);

  m_sDBFileName := sFileName;
  m_QuickList := TQuickList.Create;
  m_QuickList.boCaseSensitive := False;
  m_boChanged := False;
  m_nRecordCount := -1;

  boDataDBReady := False;
  ADOConnection := TADOConnection.Create(nil);
  DBQry := TADOQuery.Create(nil);
  ADOConnection.ConnectionString := sFileName;
  ADOConnection.LoginPrompt := False;
  ADOConnection.KeepConnection := True;
  DBQry.Connection := ADOConnection;
  DBQry.Prepared := True;
  try
    ADOConnection.Connected := True;
  except
    MainOutMessage('[����] SQL ����ʧ�ܣ�����SQL����');
  end;
  LoadQuickList;
  {$ELSE}
  n4 := 0;
  boDataDBReady := False;
  m_sDBFileName := sFileName;
  m_sIdxFileName := sFileName + '.idx';
  m_QuickList := TQuickList.Create;
  m_DeletedList := TList.Create;
  n4ADAE4 := 0;
  n4ADAF0 := 0;
  m_nLastIndex := -1;
  if LoadDBIndex then boDataDBReady := True
  else LoadQuickList();
  {$IFEND}
end;
destructor TFileHeroDB.Destroy;
begin
{$IF DBSMode = 1}
  DBQry.Free;
  ADOConnection.Free;
  CoUnInitialize;
{$ELSE}
  if FileExists(m_sIdxFileName) then DeleteFile(m_sIdxFileName);//ɾ������
  m_DeletedList.Free;
{$IFEND}
  m_QuickList.Free;
  inherited;
end;

procedure TFileHeroDB.Lock;
begin
  EnterCriticalSection(HumDB_CS);
end;
procedure TFileHeroDB.UnLock;
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileHeroDB.Open(boRead : Boolean = False): Boolean;
begin
  Result := False;
  Lock();
{$IF DBSMode = 1}
  m_boChanged := False;
  Result := True;
{$ELSE}
  n4 := 0;
  m_boChanged := False;
  if FileExists(m_sDBFileName) then begin
    if boRead then//ֻ��ģʽ�� By TasNat at: 2012-03-22 15:53:50 
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then begin
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end else begin //0048B999
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.n70 := nDBVersion;
      m_Header.nHumCount := 0;
      m_Header.n6C := 0;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
{$IFEND}  
end;

procedure TFileHeroDB.Close;
begin
{$IF DBSMode = 0}
  FileClose(m_nFileHandle);
{$IFEND}
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;

function TFileHeroDB.Index(sName: string): Integer;
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileHeroDB.Find(sChrName: string; List: TStrings): Integer;
var
  i: Integer;
begin
  if m_QuickList.Count > 0 then begin//20090101
    for I := 0 to m_QuickList.Count - 1 do begin
      if CompareLStr(m_QuickList.Strings[i], sChrName, Length(sChrName)) and (Length(m_QuickList.Strings[I]) = (Length(sChrName)+1)) then begin//20100204 ���Ӽ������λ���Ƿ�һ��
        List.AddObject(m_QuickList.Strings[i], TObject(I));
        if List.Count >= 2 then Break;
      end;
    end;
  end;
  Result := List.Count;
end;

function TFileHeroDB.Delete(nIndex: Integer): Boolean;
{$IF DBSMode = 0}
var
  i: Integer;
{$IFEND}  
begin
  Result := False;
  {$IF DBSMode = 1}
  if (nIndex >= 0) and (nIndex < m_QuickList.Count) then begin
    if DeleteRecord(nIndex) then begin
      m_QuickList.Delete(nIndex);
      Result := True;
    end;
  end;
  {$ELSE}
  if m_QuickList.Count > 0 then begin//20090101
    for i := 0 to m_QuickList.Count - 1 do begin
      if Integer(m_QuickList.Objects[i]) = nIndex then begin
        if DeleteRecord(nIndex) then begin
          m_QuickList.Delete(i);
          Result := True;
          break;
        end;
      end;
    end;
  end;
  {$IFEND}
end;

procedure TFileHeroDB.Rebuild;
{$IF DBSMode = 0}
var
  sTempFileName: string;
  nHandle, n10: Integer;
  DBHeader: TDBHeader;
  ChrRecord: TNewHeroDataInfo;
{$IFEND}
begin
{$IF DBSMode = 0}
  sTempFileName := 'HeroMir#$00.DB';
  if FileExists(sTempFileName) then DeleteFile(sTempFileName);
  nHandle := FileCreate(sTempFileName);
  n10 := 0;
  if nHandle < 0 then Exit;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
        while FileRead(m_nFileHandle, ChrRecord, SizeOf(TNewHeroDataInfo)) = SizeOf(TNewHeroDataInfo) do begin
          if ChrRecord.Header.boDeleted then Continue;
          FileWrite(nHandle, ChrRecord, SizeOf(TNewHeroDataInfo));
          Inc(n10);
        end;
        DBHeader.nHumCount := n10;
        DBHeader.dUpdateDate := Now();
        FileSeek(nHandle, 0, 0);
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
      end;
    end;
  finally
    Close;
  end;
  FileClose(nHandle);
  FileCopy(sTempFileName, m_sDBFileName);
  DeleteFile(sTempFileName);
{$IFEND}  
end;

function TFileHeroDB.Count: Integer;
begin
  Result := m_QuickList.Count;
end;

function TFileHeroDB.Delete(sChrName: string): Boolean;
var
  n10: Integer;
begin
  Result := False;
  n10 := m_QuickList.GetIndex(sChrName);
  if n10 < 0 then Exit;
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
end;

{$IF DBSMode = 1}
procedure TFileHeroDB.LoadQuickList;
var
  nIndex: Integer;
  sChrName: string;
  nJob: Byte;
resourcestring
  sSQL = 'SELECT * FROM TBL_DeputyHero';
begin
  m_nRecordCount := -1;
  m_QuickList.Clear;
  Lock;
  try
    try
      dbQry.SQL.Clear;
      dbQry.SQL.Add(sSQL);
      try
        dbQry.Open;
      except
        MainOutMessage('[�쳣] TFileHeroDB.LoadQuickList');
      end;

      m_nRecordCount := dbQry.RecordCount;
      n4ADAF0 := m_nRecordCount;
      for nIndex := 0 to m_nRecordCount - 1 do begin
        sChrName := Trim(dbQry.FieldByName('FLD_sHeroChrName').AsString);
        nJob:= dbQry.FieldByName('FLD_btJob').AsInteger;
        m_QuickList.AddObject(sChrName + inttostr(nJob), TObject(nIndex));
        dbQry.Next;
      end;
    finally
      dbQry.Close;
    end;
  finally
    UnLock;
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  boDataDBReady := True;
end;

function TFileHeroDB.DeleteRecord(nIndex: Integer): Boolean;
var
  sChrName, sJob: string;
resourcestring
  sSQL  = 'DELETE FROM TBL_DeputyHero WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
  sSQL4 = 'DELETE FROM TBL_DeputyHero_MAGIC WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
  sSQL5 = 'DELETE FROM TBL_DeputyHero_ITEM WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
begin
  Result := True;
  sChrName := m_QuickList[nIndex];
  sJob:= Copy(sChrName, Length(sChrName), Length(sChrName));
  sChrName := Copy(sChrName, 0, Length(sChrName)-1);
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [sChrName, sJob]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileHeroDB.DeleteRecord (1)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL4, [sChrName, sJob]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileHeroDB.DeleteRecord (4)');
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL5, [sChrName, sJob]));
    try
      dbQry.ExecSQL;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileHeroDB.DeleteRecord (5)');
    end;

    m_boChanged := True;
  finally
    dbQry.Close;
  end;
end;

function TFileHeroDB.Get(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Integer;
begin
  Result := -1;
  if nIndex < 0 then Exit;
  if m_QuickList.Count <= nIndex then Exit;
  if GetRecord(nIndex, HumanRCD) then Result := nIndex
  else Result := -1;
end;

function TFileHeroDB.Update(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumanRCD, False) then Result := True;
end;

function TFileHeroDB.Add(HumanRCD: pTNewHeroDataInfo): Boolean;
var
  sChrName: string;
  nIndex: Integer;
begin
  sChrName := Trim(HumanRCD.Data.sHeroChrName)+inttostr(HumanRCD.Data.btJob);
  if m_QuickList.GetIndex(sChrName) >= 0 then begin
    Result := False;
  end else begin
    nIndex := m_nRecordCount;
    Inc(m_nRecordCount);
    if UpdateRecord(nIndex, HumanRCD, True) then begin
      m_QuickList.AddRecord(sChrName, nIndex);
      Result := True;
    end else begin
      Result := False;
    end;
  end;
end;

function TFileHeroDB.GetRecord(nIndex: Integer; HumanRCD: pTNewHeroDataInfo): Boolean;
var
  sChrName, sJob: string;
  I, nCount, nPosition, K, H: Integer;
  V: Variant;
  PData: Pointer;
resourcestring
  sSQL = 'SELECT * FROM TBL_DeputyHero WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
  sSQL4 = 'SELECT * FROM TBL_DeputyHero_MAGIC WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
  sSQL5 = 'SELECT * FROM TBL_DeputyHero_ITEM WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%s''';
begin
  Result := False;
  sChrName := Trim(m_QuickList[nIndex]);
  sJob:= Copy(sChrName, Length(sChrName), Length(sChrName));
  sChrName := Copy(sChrName, 0, Length(sChrName)-1);
  FillChar(HumanRCD^, SizeOf(TNewHeroDataInfo), #0);
  try
    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL, [sChrName, sJob]));
    try
      dbQry.Open;
    except
      MainOutMessage('[�쳣] TFileHeroDB.GetRecord (1)');
      Exit;
    end;

    if dbQry.RecordCount > 0 then begin
      Result := True;
      HumanRCD.Header.dCreateDate := dbQry.FieldByName('FLD_dCreateDate').AsDateTime;
      HumanRCD.Header.boDeleted := dbQry.FieldByName('FLD_boDeleted').AsBoolean;

      HumanRCD.Data.sHeroChrName := Trim(dbQry.FieldByName('FLD_sHeroChrName').AsString);//����
      HumanRCD.Data.btJob := dbQry.FieldByName('FLD_btJob').AsInteger;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
      HumanRCD.Data.nHP := dbQry.FieldByName('FLD_nHP').AsInteger;
      HumanRCD.Data.nMP := dbQry.FieldByName('FLD_nMP').AsInteger;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL4, [sChrName, sJob]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileHeroDB.GetRecord (4)');
      Exit;
    end;

    K:= 0; H:= 0;
    for I := 0 to dbQry.RecordCount - 1 do begin
      if dbQry.FieldByName('FLD_ZT').AsBoolean then begin//�ڹ�����
        if H >= MAXMAGIC then Continue;
        HumanRCD.Data.HumNGMagics[H].wMagIdx := dbQry.FieldByName('FLD_MAGID').AsInteger;
        HumanRCD.Data.HumNGMagics[H].btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
        HumanRCD.Data.HumNGMagics[H].btKey := dbQry.FieldByName('FLD_USEKEY').AsInteger;
        HumanRCD.Data.HumNGMagics[H].nTranPoint := dbQry.FieldByName('FLD_CURRTRAIN').AsInteger;
        Inc(H);
      end else begin//��ͨ����+��������
        if K >= MAXMAGIC then Continue;
        HumanRCD.Data.HumMagics[K].wMagIdx := dbQry.FieldByName('FLD_MAGID').AsInteger;
        HumanRCD.Data.HumMagics[K].btLevel := dbQry.FieldByName('FLD_LEVEL').AsInteger;
        HumanRCD.Data.HumMagics[K].btKey := dbQry.FieldByName('FLD_USEKEY').AsInteger;
        HumanRCD.Data.HumMagics[K].nTranPoint := dbQry.FieldByName('FLD_CURRTRAIN').AsInteger;
        Inc(K);
      end;
      dbQry.Next;
    end;

    dbQry.SQL.Clear;
    dbQry.SQL.Add(Format(sSQL5, [sChrName, sJob]));
    try
      dbQry.Open;
    except
      Result := False;
      MainOutMessage('[�쳣] TFileHeroDB.GetRecord (5)');
      Exit;
    end;

    nCount := dbQry.RecordCount - 1;
    //if nCount > MAXBAGITEM + MAXUSEITEM - 1 then nCount := MAXBAGITEM + MAXUSEITEM - 1;
    if nCount > MAXBAGITEM + MAXUSEITEM then nCount := MAXBAGITEM + MAXUSEITEM ;
    for I := 0 to nCount do begin
      nPosition := dbQry.FieldByName('FLD_POSITION').AsInteger - 1;

      if (nPosition >= 0) and (nPosition <= MAXUSEITEM) then begin
        if (nPosition <= 8) then begin
          HumanRCD.Data.HumItems[nPosition].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
          HumanRCD.Data.HumItems[nPosition].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
          HumanRCD.Data.HumItems[nPosition].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
          HumanRCD.Data.HumItems[nPosition].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
          V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
          V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btUnKnowValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btUnKnowValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
        end else begin
          HumanRCD.Data.HumAddItems[nPosition].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
          HumanRCD.Data.HumAddItems[nPosition].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
          V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
          V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
          if not VarIsNull(V) then begin
            PData := VarArrayLock(V);
            try
              Move(PData^, HumanRCD.Data.HumItems[nPosition].btUnKnowValue, SizeOf(HumanRCD.Data.HumItems[nPosition].btUnKnowValue));
            finally
              VarArrayUnlock(V);
            end;
          end;
        end;
      end else begin
        if (nPosition > MAXUSEITEM) then begin
          if nPosition = 14 then begin//��ýλ

          end else begin
            HumanRCD.Data.BagItems[nPosition - 15].MakeIndex := dbQry.FieldByName('FLD_MAKEINDEX').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].wIndex := dbQry.FieldByName('FLD_STDINDEX').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].Dura := dbQry.FieldByName('FLD_DURA').AsInteger;
            HumanRCD.Data.BagItems[nPosition - 15].DuraMax := dbQry.FieldByName('FLD_DURAMAX').AsInteger;
            V := TBinaryField(DBQry.FieldByName('FLD_VALUE')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.BagItems[nPosition - 15].btValue, SizeOf(HumanRCD.Data.BagItems[nPosition - 15].btValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
            V := TBinaryField(DBQry.FieldByName('FLD_UnKnowValue')).AsVariant;
            if not VarIsNull(V) then begin
              PData := VarArrayLock(V);
              try
                Move(PData^, HumanRCD.Data.BagItems[nPosition - 15].btUnKnowValue, SizeOf(HumanRCD.Data.BagItems[nPosition - 15].btUnKnowValue));
              finally
                VarArrayUnlock(V);
              end;
            end;
          end;
        end;
      end;
      dbQry.Next;
    end;
  finally
    dbQry.Close;
  end;
end;

function TFileHeroDB.UpdateRecord(nIndex: Integer; HumanRCD: pTNewHeroDataInfo; boNew: Boolean): Boolean;
var
  sdt: string;
  I: Integer;
  HumData: pTNewHeroData;
  MemoryStream: TMemoryStream;
begin
  Result := True;
  sdt := FormatDateTime(SQLDTFORMAT, Now);
  try
    DBQry.SQL.Clear;
    if boNew then begin //New
      HumData := @HumanRCD.Data;
      DBQry.SQL.Clear;
      DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero(FLD_sHeroChrName, FLD_btJob, FLD_nHP, FLD_nMP, FLD_boDeleted, FLD_dCreateDate) VALUES (' +
        '''%s'', %d, %d, %d, 0, ''%s'')',
        [Trim(HumData.sHeroChrName) , HumData.btJob, HumData.nHP, HumData.nMP, sdt]));
      try
        DBQry.ExecSQL;
      except
        Result := False;
        MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (1)');
        Exit;
      end;
    end else begin
      HumData := @HumanRCD.Data;
      DBQry.SQL.Clear;
      DBQry.SQL.Add(Format('UPDATE TBL_DeputyHero SET ' +
        'FLD_dCreateDate=''%s'', ' +
        'FLD_nHP=%d, ' +
        'FLD_nMP=%d WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%d''',
        [FormatDateTime(SQLDTFORMAT, Now),
          HumData.nHP,
          HumData.nMP,
          Trim(HumData.sHeroChrName),HumData.btJob]));
      try
        DBQry.ExecSQL;
      except
        on E: Exception do begin
          Result := False;
          MainOutMessage(Format('[�쳣] TFileHeroDB.UpdateRecord (4) %s',[E.Message]));
          Exit;
        end;
      end;
//==============================================================================
      DBQry.SQL.Clear;
      DBQry.SQL.Add(Format('DELETE FROM TBL_DeputyHero_MAGIC WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%d''', [Trim(HumData.sHeroChrName), HumData.btJob]));
      try
        DBQry.ExecSQL;
      except
        on E: Exception do begin
          Result := False;
          MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (6)');
        end;
      end;
      for I := 0 to High(HumData.HumMagics) do begin
        if HumData.HumMagics[I].wMagIdx > 0 then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero_MAGIC(FLD_sHeroChrName, FLD_btJob, FLD_MAGID, FLD_LEVEL, FLD_USEKEY, FLD_CURRTRAIN, FLD_ZT) VALUES ' +
            '(''%s'', %d, %d, %d, %d, %d, 0)',
            [Trim(HumData.sHeroChrName), HumData.btJob, HumData.HumMagics[I].wMagIdx, HumData.HumMagics[I].btLevel,
              HumData.HumMagics[I].btKey, HumData.HumMagics[I].nTranPoint]));
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (7-1)');
            end;
          end;
        end;
      end;
      for I := 0 to High(HumData.HumNGMagics) do begin
        if HumData.HumNGMagics[I].wMagIdx > 0 then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero_MAGIC(FLD_sHeroChrName, FLD_btJob, FLD_MAGID, FLD_LEVEL, FLD_USEKEY, FLD_CURRTRAIN, FLD_ZT) VALUES ' +
            '(''%s'', %d, %d, %d, %d, %d, 1)',
            [Trim(HumData.sHeroChrName), HumData.btJob, HumData.HumNGMagics[I].wMagIdx, HumData.HumNGMagics[I].btLevel,
              HumData.HumNGMagics[I].btKey, HumData.HumNGMagics[I].nTranPoint]));
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (7-2)');
            end;
          end;
        end;
      end;
//==============================================================================
      DBQry.SQL.Clear;
      DBQry.SQL.Add(Format('DELETE FROM TBL_DeputyHero_ITEM WHERE FLD_sHeroChrName=''%s'' and FLD_btJob=''%d''', [Trim(HumData.sHeroChrName), HumData.btJob]));
      try
        DBQry.ExecSQL;
      except
        on E: Exception do begin
          Result := False;
          MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (8)');
        end;
      end;

      for I := 0 to High(HumData.BagItems) do begin
        if (HumData.BagItems[I].wIndex > 0) and (HumData.BagItems[I].MakeIndex > 0) then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero_ITEM(FLD_sHeroChrName, FLD_btJob,FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE, FLD_UnKnowValue) VALUES ' +
            '(''%s'', %d, %d, %d, %d, %d, %d, :a1, :a2)',
            [Trim(HumData.sHeroChrName), HumData.btJob, I + 16,
            HumData.BagItems[I].MakeIndex, HumData.BagItems[I].wIndex, HumData.BagItems[I].Dura, HumData.BagItems[I].DuraMax]));
            MemoryStream := TMemoryStream.Create;
            try
              MemoryStream.Write(HumData.BagItems[I].btValue, SizeOf(HumData.BagItems[I].btValue));
              DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumData.BagItems[I].btUnKnowValue, SizeOf(HumData.BagItems[I].btUnKnowValue));
              DBQry.Parameters.ParamByName('a2').LoadFromStream(MemoryStream, ftBytes);
            finally
              MemoryStream.Free;
            end;
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage(Format('[�쳣] TFileHeroDB.UpdateRecord (9) %s',[E.Message]));
            end;
          end;
        end;
      end;
//==============================================================================
      for I := 0 to High(HumData.HumItems) do begin
        if (HumData.HumItems[I].wIndex > 0) and (HumData.HumItems[I].MakeIndex > 0) then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero_ITEM(FLD_sHeroChrName, FLD_btJob, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE, FLD_UnKnowValue) VALUES (''%s'', %d, %d, %d, %d, %d, %d, :FLD_VALUE, :a1)',
            [Trim(HumData.sHeroChrName), HumData.btJob, I + 1,
            HumData.HumItems[I].MakeIndex, HumData.HumItems[I].wIndex, HumData.HumItems[I].Dura, HumData.HumItems[I].DuraMax]));
            MemoryStream := TMemoryStream.Create;
            try
              MemoryStream.Write(HumData.HumItems[I].btValue, SizeOf(HumData.HumItems[I].btValue));
              DBQry.Parameters.ParamByName('FLD_VALUE').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumData.HumItems[I].btUnKnowValue, SizeOf(HumData.HumItems[I].btUnKnowValue));
              DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
            finally
              MemoryStream.Free;
            end;
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage(Format('[�쳣] TFileHeroDB.UpdateRecord (10-1) %s',[E.Message]));
            end;
          end;
        end;
      end;
      for I := 9 to High(HumData.HumAddItems) do begin
        if (HumData.HumAddItems[I].wIndex > 0) and (HumData.HumAddItems[I].MakeIndex > 0) then begin
          DBQry.SQL.Clear;
          DBQry.SQL.Add(Format('INSERT INTO TBL_DeputyHero_ITEM(FLD_sHeroChrName, FLD_btJob, FLD_POSITION, FLD_MAKEINDEX, FLD_STDINDEX, FLD_DURA, FLD_DURAMAX, ' +
            'FLD_VALUE, FLD_UnKnowValue) VALUES (''%s'', %d, %d, %d, %d, %d, %d, :FLD_VALUE, :a1)',
            [Trim(HumData.sHeroChrName), HumData.btJob, I + 1,
            HumData.HumAddItems[I].MakeIndex, HumData.HumAddItems[I].wIndex, HumData.HumAddItems[I].Dura,
              HumData.HumAddItems[I].DuraMax]));
            MemoryStream := TMemoryStream.Create;
            try
              MemoryStream.Write(HumData.HumAddItems[I].btValue, SizeOf(HumData.HumAddItems[I].btValue));
              DBQry.Parameters.ParamByName('FLD_VALUE').LoadFromStream(MemoryStream, ftBytes);
              MemoryStream.Clear;

              MemoryStream.Write(HumData.HumAddItems[I].btUnKnowValue, SizeOf(HumData.HumAddItems[I].btUnKnowValue));
              DBQry.Parameters.ParamByName('a1').LoadFromStream(MemoryStream, ftBytes);
            finally
              MemoryStream.Free;
            end;
          try
            DBQry.ExecSQL;
          except
            on E: Exception do begin
              Result := False;
              MainOutMessage('[�쳣] TFileHeroDB.UpdateRecord (10-2)');
            end;
          end;
        end;
      end;
    end;
    m_boChanged := True;
  finally
    DBQry.Close;
  end;
end;
{$ELSE}
function TFileHeroDB.UpdateRecord(nIndex: Integer; var HumanRCD: TNewHeroDataInfo; boNew: Boolean): Boolean;
var
  nPosion, n10: Integer;
  dt20: TDateTime;
  ReadRCD: TNewHeroDataInfo;
begin
  nPosion := nIndex * SizeOf(TNewHeroDataInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    dt20 := Now();
    m_nLastIndex := nIndex;
    m_dUpdateTime := dt20;
    n10 := FileSeek(m_nFileHandle, 0, 1);
    if boNew
      and (FileRead(m_nFileHandle, ReadRCD, SizeOf(TNewHeroDataInfo)) = SizeOf(TNewHeroDataInfo))
      and not ReadRCD.Header.boDeleted and (ReadRCD.Data.sHeroChrName <> '') then begin
      Result := False;
    end else begin
      HumanRCD.Header.dCreateDate := Now();
      m_Header.nLastIndex := m_nLastIndex;
      m_Header.dLastDate := m_dUpdateTime;
      m_Header.dUpdateDate := Now();
      FileSeek(m_nFileHandle, 0, 0);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      FileSeek(m_nFileHandle, n10, 0);
      FileWrite(m_nFileHandle, HumanRCD, SizeOf(TNewHeroDataInfo));
      FileSeek(m_nFileHandle, -SizeOf(TNewHeroDataInfo), 1);
      n4 := nIndex;
      m_boChanged := True;
      Result := True;
    end;
  end else Result := False;
end;

function TFileHeroDB.GetRecord(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Boolean;
begin
  if FileSeek(m_nFileHandle, nIndex * SizeOf(TNewHeroDataInfo) + SizeOf(TDBHeader), 0) <> -1 then begin
    FileRead(m_nFileHandle, HumanRCD, SizeOf(TNewHeroDataInfo));
    FileSeek(m_nFileHandle, -SizeOf(TNewHeroDataInfo), 1);
    n4 := nIndex;
    Result := True;
  end else Result := False;
end;

function TFileHeroDB.Add(var HumanRCD: TNewHeroDataInfo): Boolean;
var
  sHumanName: string;
  DBHeader: TDBHeader;
  nIdx: Integer;
begin
  sHumanName := HumanRCD.Data.sHeroChrName + inttostr(HumanRCD.Data.btJob);//20100227 �޸�
  if m_QuickList.GetIndex(sHumanName) >= 0 then begin
    Result := False;
  end else begin
    DBHeader := m_Header;
    if m_DeletedList.Count > 0 then begin
      nIdx := Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIdx := m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;

    if UpdateRecord(nIdx, HumanRCD, True) then begin
      m_QuickList.AddRecord(sHumanName, nIdx);//20100227 �޸�
      Result := True;
    end else begin
      m_Header := DBHeader;
      Result := False;
    end;
  end;
end;

function TFileHeroDB.Update(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumanRCD, False) then Result := True;
end;

function TFileHeroDB.Get(nIndex: Integer; var HumanRCD: TNewHeroDataInfo): Integer;
var
  nIdx: Integer;
begin
  nIdx := Integer(m_QuickList.Objects[nIndex]);
  if GetRecord(nIdx, HumanRCD) then Result := nIdx
  else Result := -1;
end;

function TFileHeroDB.DeleteRecord(nIndex: Integer): Boolean;
var
  ChrRecordHeader: TNewHeroDataHeader;
begin
  Result := False;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(TNewHeroDataInfo) + SizeOf(TDBHeader), 0) = -1 then Exit;
  m_nLastIndex := nIndex;
  m_dUpdateTime := Now();
  ChrRecordHeader.boDeleted := True;
  ChrRecordHeader.dCreateDate := Now();
  FileWrite(m_nFileHandle, ChrRecordHeader, SizeOf(TNewHeroDataHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_Header.nLastIndex := m_nLastIndex;
  m_Header.dLastDate := m_dUpdateTime;
  m_Header.dUpdateDate := Now();
  FileSeek(m_nFileHandle, 0, 0);
  FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  m_boChanged := True;
  Result := True;
end;

//��ȡ����
function TFileHeroDB.LoadDBIndex: Boolean;
var
  nIdxFileHandle: Integer;
  IdxHeader: TIdxHeader;
  DBHeader: TDBHeader;
  IdxRecord: TIdxRecord;
  HumRecord: TNewHeroDataInfo;
  i: Integer;
  n14: Integer;
begin
  Result := False;
  nIdxFileHandle := 0;
  FillChar(IdxHeader, SizeOf(TIdxHeader), #0);
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone);
  if nIdxFileHandle > 0 then begin
    Result := True;
    FileRead(nIdxFileHandle, IdxHeader, SizeOf(TIdxHeader));

    try
      if Open then begin
        FileSeek(m_nFileHandle, 0, 0);
        if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
          if IdxHeader.nHumCount <> DBHeader.nHumCount then Result := False;
          if IdxHeader.sDesc <> sDBIdxHeaderDesc then Result := False;
        end;
        if IdxHeader.nLastIndex <> DBHeader.nLastIndex then Result := False;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle, IdxHeader.nLastIndex * SizeOf(TNewHeroDataInfo) + SizeOf(TDBHeader), 0);
          if FileRead(m_nFileHandle, HumRecord, SizeOf(TNewHeroDataInfo)) = SizeOf(TNewHeroDataInfo) then
            if IdxHeader.dUpdateDate <> HumRecord.Header.dCreateDate then Result := False;
        end;
      end;
    finally
      Close();
    end;
    if Result then begin
      m_nLastIndex := IdxHeader.nLastIndex;
      m_dUpdateTime := IdxHeader.dUpdateDate;
      if IdxHeader.nQuickCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nQuickCount - 1 do begin
          if FileRead(nIdxFileHandle, IdxRecord, SizeOf(TIdxRecord)) = SizeOf(TIdxRecord) then begin
            m_QuickList.AddObject(IdxRecord.sChrName, TObject(IdxRecord.nIndex));
          end else begin
            Result := False;
            break;
          end;
        end; //0048AC7A
      end;
      if IdxHeader.nDeleteCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nDeleteCount - 1 do begin
          if FileRead(nIdxFileHandle, n14, SizeOf(Integer)) = SizeOf(Integer) then
            m_DeletedList.Add(Pointer(n14))
          else begin
            Result := False;
            break;
          end;
        end;
      end;
    end; //0048ACC5
    FileClose(nIdxFileHandle);
  end; //0048ACCD
  if Result then begin
    n4ADAE4 := m_QuickList.Count;
    n4ADAE8 := m_QuickList.Count;
    n4ADAF0 := DBHeader.nHumCount;
    m_QuickList.SortString(0, m_QuickList.Count - 1);
  end else m_QuickList.Clear;
end;

function TFileHeroDB.OpenEx(boRead : Boolean = False): Boolean;
var
  DBHeader: TDBHeader;
begin
  Lock();
  m_boChanged := False;
    if boRead then
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenRead or fmShareDenyNone)
    else
      m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result := True;
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header := DBHeader;
    n4 := 0;
  end else Result := False;
end;

procedure TFileHeroDB.LoadQuickList;
var
  nIndex: Integer;
  DBHeader: TDBHeader;
  ChrRecord: TNewHeroDataInfo;
begin
  n4 := 0;
  m_QuickList.Clear;
  m_DeletedList.Clear;
  n4ADAE4 := 0;
  n4ADAE8 := 0;
  n4ADAF0 := 0;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADAF0 := DBHeader.nHumCount;
        if DBHeader.nHumCount > 0 then begin//20090101
          for nIndex := 0 to DBHeader.nHumCount - 1 do begin
            Inc(n4ADAE4);
            if FileSeek(m_nFileHandle, nIndex * SizeOf(TNewHeroDataInfo) + SizeOf(TDBHeader), 0) = -1 then break;
            if FileRead(m_nFileHandle, ChrRecord, SizeOf(TNewHeroDataInfo)) <> SizeOf(TNewHeroDataInfo) then break;
            if not ChrRecord.Header.boDeleted then begin
              if ChrRecord.Data.sHeroChrName <> '' then begin
                m_QuickList.AddObject(ChrRecord.Data.sHeroChrName+inttostr(ChrRecord.Data.btJob), TObject(nIndex));
                //MainOutMessage('AA:'+datetimetostr(ChrRecord.Header.dCreateDate)+' '+ booltostr(ChrRecord.Header.boDeleted)+' nIndex:'+inttostr(nIndex)+' ���֣�'+ChrRecord.Data.sHeroChrName);
                Inc(n4ADAE8);
              end else m_DeletedList.Add(TObject(nIndex));
            end else begin
              m_DeletedList.Add(TObject(nIndex));
              Inc(n4ADAEC);
            end;
            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
          end;
        end else begin//�������ļ�����ʱ��ͷ�ṹ����ʱʹ��

          while (True) do begin
            if FileRead(m_nFileHandle, ChrRecord, SizeOf(TNewHeroDataInfo)) = SizeOf(TNewHeroDataInfo) then begin
              if not ChrRecord.Header.boDeleted then begin
                if ChrRecord.Data.sHeroChrName <> '' then begin
                  m_QuickList.AddObject(ChrRecord.Data.sHeroChrName+inttostr(ChrRecord.Data.btJob), TObject(nIndex));
                  //MainOutMessage('BB nIndex:'+inttostr(nIndex)+'  ְҵ��'+inttostr(ChrRecord.Data.btJob)+' ���֣�'+ChrRecord.Data.sHeroChrName);
                  Inc(n4ADAE8);
                end else m_DeletedList.Add(TObject(nIndex));
              end else begin
                m_DeletedList.Add(TObject(nIndex));
                Inc(n4ADAEC);
              end;
            end else break;

            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
            Inc(nIndex);
          end;

          if DBHeader.nHumCount <> m_QuickList.Count + m_DeletedList.Count then begin
            DBHeader.nHumCount := m_QuickList.Count + m_DeletedList.Count;
            FileSeek(m_nFileHandle, 0, 0);
            FileWrite(m_nFileHandle, DBHeader, SizeOf(TDBHeader));
          end;
        end;
      end;
    end;
  finally
    Close();
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  m_nLastIndex := m_Header.nLastIndex;
  m_dUpdateTime := m_Header.dLastDate;
  boDataDBReady := True;
end;
{$IFEND}

//------------------------------------------------------------------------------
(*{ TFileHumHeroDB �����븱���������ݲ����� 20100119}
constructor TFileHumHeroDB.Create(sFileName: string);
begin
  n4 := 0;
  boDataDBReady := False;
  m_sDBFileName := sFileName;
  m_sIdxFileName := sFileName + '.idx';
  m_QuickList := TQuickList.Create;
  m_DeletedList := TList.Create;
  n4ADAE4 := 0;
  n4ADAF0 := 0;
  m_nLastIndex := -1;
  if LoadDBIndex then boDataDBReady := True
  else LoadQuickList();
end;
destructor TFileHumHeroDB.Destroy;
begin
  if FileExists(m_sIdxFileName) then DeleteFile(m_sIdxFileName);//ɾ������
  m_DeletedList.Free;
  m_QuickList.Free;
  inherited;
end;

procedure TFileHumHeroDB.Lock;
begin
  EnterCriticalSection(HumDB_CS);
end;
procedure TFileHumHeroDB.UnLock;
begin
  LeaveCriticalSection(HumDB_CS);
end;

function TFileHumHeroDB.Open: Boolean;
begin
  Result := False;
  Lock();
  n4 := 0;
  m_boChanged := False;
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then begin
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end else begin //0048B999
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.n70 := nDBVersion;
      m_Header.nHumCount := 0;
      m_Header.n6C := 0;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
end;

procedure TFileHumHeroDB.Close;
begin
  FileClose(m_nFileHandle);
  if m_boChanged and Assigned(m_OnChange) then begin
    m_OnChange(Self);
  end;
  UnLock();
end;

function TFileHumHeroDB.Index(sName: string): Integer;
begin
  Result := m_QuickList.GetIndex(sName);
end;

function TFileHumHeroDB.Find(sChrName: string; List: TStrings): Integer;
var
  i: Integer;
begin
  if m_QuickList.Count > 0 then begin
    for i := 0 to m_QuickList.Count - 1 do begin
      if CompareLStr(m_QuickList.Strings[i], sChrName, Length(sChrName)) then begin
        List.AddObject(m_QuickList.Strings[i], m_QuickList.Objects[i]);
      end;
    end;
  end;
  Result := List.Count;
end;

function TFileHumHeroDB.Delete(nIndex: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if m_QuickList.Count > 0 then begin//20090101
    for i := 0 to m_QuickList.Count - 1 do begin
      if Integer(m_QuickList.Objects[i]) = nIndex then begin
        if DeleteRecord(nIndex) then begin
          m_QuickList.Delete(i);
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

procedure TFileHumHeroDB.Rebuild;
var
  sTempFileName: string;
  nHandle, n10: Integer;
  DBHeader: TDBHeader;
  ChrRecord: THeroNameInfo;
begin
  sTempFileName := 'HumHero#$00.DB';
  if FileExists(sTempFileName) then DeleteFile(sTempFileName);
  nHandle := FileCreate(sTempFileName);
  n10 := 0;
  if nHandle < 0 then Exit;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
        while (True) do begin
          if FileRead(m_nFileHandle, ChrRecord, SizeOf(THeroNameInfo)) = SizeOf(THeroNameInfo) then begin
            if ChrRecord.Header.boDeleted then Continue;
            FileWrite(nHandle, ChrRecord, SizeOf(THeroNameInfo));
            Inc(n10);
          end else break;
        end;
        DBHeader.nHumCount := n10;
        DBHeader.dUpdateDate := Now();
        FileSeek(nHandle, 0, 0);
        FileWrite(nHandle, DBHeader, SizeOf(TDBHeader));
      end;
    end;
  finally
    Close;
  end;
  FileClose(nHandle);
  FileCopy(sTempFileName, m_sDBFileName);
  DeleteFile(sTempFileName);
end;

function TFileHumHeroDB.Count: Integer;
begin
  Result := m_QuickList.Count;
end;

function TFileHumHeroDB.Delete(sChrName: string): Boolean;
var
  n10: Integer;
begin
  Result := False;
  n10 := m_QuickList.GetIndex(sChrName);
  if n10 < 0 then Exit;
  if DeleteRecord(Integer(m_QuickList.Objects[n10])) then begin
    m_QuickList.Delete(n10);
    Result := True;
  end;
end;

function TFileHumHeroDB.GetRecord(nIndex: Integer; var HumanRCD: THeroNameInfo): Boolean;
begin
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THeroNameInfo) + SizeOf(TDBHeader), 0) <> -1 then begin
    FileRead(m_nFileHandle, HumanRCD, SizeOf(THeroNameInfo));
    FileSeek(m_nFileHandle, -SizeOf(THeroNameInfo), 1);
    n4 := nIndex;
    Result := True;
  end else Result := False;
end;

function TFileHumHeroDB.UpdateRecord(nIndex: Integer; var HumanRCD: THeroNameInfo; boNew: Boolean): Boolean;
var
  nPosion, n10: Integer;
  dt20: TDateTime;
  ReadRCD: THeroNameInfo;
begin
  nPosion := nIndex * SizeOf(THeroNameInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    dt20 := Now();
    m_nLastIndex := nIndex;
    m_dUpdateTime := dt20;
    n10 := FileSeek(m_nFileHandle, 0, 1);
    if boNew and (FileRead(m_nFileHandle, ReadRCD, SizeOf(THeroNameInfo)) = SizeOf(THeroNameInfo))
      and not ReadRCD.Header.boDeleted and (ReadRCD.Data.sChrName <> '') then begin
      Result := False;
    end else begin
      HumanRCD.Header.dCreateDate := Now();
      m_Header.nLastIndex := m_nLastIndex;
      m_Header.dLastDate := m_dUpdateTime;
      m_Header.dUpdateDate := Now();
      FileSeek(m_nFileHandle, 0, 0);
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
      FileSeek(m_nFileHandle, n10, 0);
      FileWrite(m_nFileHandle, HumanRCD, SizeOf(THeroNameInfo));
      FileSeek(m_nFileHandle, -SizeOf(THeroNameInfo), 1);
      n4 := nIndex;
      m_boChanged := True;
      Result := True;
    end;
  end else Result := False;
end;

function TFileHumHeroDB.Get(nIndex: Integer; var HumanRCD: THeroNameInfo): Integer;
var
  nIdx: Integer;
begin
  nIdx := Integer(m_QuickList.Objects[nIndex]);
  if GetRecord(nIdx, HumanRCD) then Result := nIdx
  else Result := -1;
end;

function TFileHumHeroDB.Update(nIndex: Integer; var HumanRCD: THeroNameInfo): Boolean;
begin
  Result := False;
  if (nIndex >= 0) and (m_QuickList.Count > nIndex) then
    if UpdateRecord(Integer(m_QuickList.Objects[nIndex]), HumanRCD, False) then Result := True;
end;

function TFileHumHeroDB.Add(var HumanRCD: THeroNameInfo): Boolean;
var
  sHumanName: string;
  DBHeader: TDBHeader;
  nIdx: Integer;
begin
  sHumanName := HumanRCD.Data.sChrName;
  if m_QuickList.GetIndex(sHumanName) >= 0 then begin
    Result := False;
  end else begin
    DBHeader := m_Header;
    if m_DeletedList.Count > 0 then begin
      nIdx := Integer(m_DeletedList.Items[0]);
      m_DeletedList.Delete(0);
    end else begin
      nIdx := m_Header.nHumCount;
      Inc(m_Header.nHumCount);
    end;

    if UpdateRecord(nIdx, HumanRCD, True) then begin
      m_QuickList.AddRecord(HumanRCD.Data.sChrName, nIdx);
      Result := True;
    end else begin
      m_Header := DBHeader;
      Result := False;
    end;
  end;
end;

procedure TFileHumHeroDB.LoadQuickList;
var
  nIndex: Integer;
  DBHeader: TDBHeader;
  ChrRecord: THeroNameInfo;
begin
  n4 := 0;
  m_QuickList.Clear;
  m_DeletedList.Clear;
  n4ADAE4 := 0;
  n4ADAE8 := 0;
  n4ADAF0 := 0;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        n4ADAF0 := DBHeader.nHumCount;
        if DBHeader.nHumCount > 0 then begin//20090101
          for nIndex := 0 to DBHeader.nHumCount - 1 do begin
            Inc(n4ADAE4);
            if FileSeek(m_nFileHandle, nIndex * SizeOf(THeroNameInfo) + SizeOf(TDBHeader), 0) = -1 then break;
            if FileRead(m_nFileHandle, ChrRecord, SizeOf(THeroNameInfo)) <> SizeOf(THeroNameInfo) then break;
            if not ChrRecord.Header.boDeleted then begin
              if ChrRecord.Data.sChrName <> '' then begin
                //MainOutMessage('BB:'+datetimetostr(ChrRecord.Header.dCreateDate)+' '+ booltostr(ChrRecord.Header.boDeleted)+' nIndex:'+inttostr(nIndex)+' ���֣�'+ChrRecord.Data.sChrName);
                m_QuickList.AddObject(ChrRecord.Data.sChrName, TObject(nIndex));
                Inc(n4ADAE8);
              end else m_DeletedList.Add(TObject(nIndex));
            end else begin
              m_DeletedList.Add(TObject(nIndex));
              Inc(n4ADAEC);
            end;
            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
          end;
        end else begin//�������ļ�����ʱ��ͷ�ṹ����ʱʹ��
          while (True) do begin
            if FileRead(m_nFileHandle, ChrRecord, SizeOf(THeroNameInfo)) = SizeOf(THeroNameInfo) then begin
              if not ChrRecord.Header.boDeleted then begin
                if ChrRecord.Data.sChrName <> '' then begin
                  m_QuickList.AddObject(ChrRecord.Data.sChrName, TObject(nIndex));
                  Inc(n4ADAE8);
                end else m_DeletedList.Add(TObject(nIndex));
              end else begin
                m_DeletedList.Add(TObject(nIndex));
                Inc(n4ADAEC);
              end;
            end else break;

            Application.ProcessMessages;
            if Application.Terminated then begin
              Close;
              Exit;
            end;
            Inc(nIndex);
          end;
          if DBHeader.nHumCount <> m_QuickList.Count + m_DeletedList.Count then begin
            DBHeader.nHumCount := m_QuickList.Count + m_DeletedList.Count;
            FileSeek(m_nFileHandle, 0, 0);
            FileWrite(m_nFileHandle, DBHeader, SizeOf(TDBHeader));
          end;
        end;
      end;
    end;
  finally
    Close();
  end;
  m_QuickList.SortString(0, m_QuickList.Count - 1);
  m_nLastIndex := m_Header.nLastIndex;
  m_dUpdateTime := m_Header.dLastDate;
  boDataDBReady := True;
end;

//��ȡ����
function TFileHumHeroDB.LoadDBIndex: Boolean;
var
  nIdxFileHandle: Integer;
  IdxHeader: TIdxHeader;
  DBHeader: TDBHeader;
  IdxRecord: TIdxRecord;
  HumRecord: THeroNameInfo;
  i: Integer;
  n14: Integer;
begin
  Result := False;
  nIdxFileHandle := 0;
  FillChar(IdxHeader, SizeOf(TIdxHeader), #0);
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone);
  if nIdxFileHandle > 0 then begin
    Result := True;
    FileRead(nIdxFileHandle, IdxHeader, SizeOf(TIdxHeader));

    try
      if Open then begin
        FileSeek(m_nFileHandle, 0, 0);
        if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
          if IdxHeader.nHumCount <> DBHeader.nHumCount then Result := False;
          if IdxHeader.sDesc <> sDBIdxHeaderDesc then Result := False;
        end;
        if IdxHeader.nLastIndex <> DBHeader.nLastIndex then Result := False;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle, IdxHeader.nLastIndex * SizeOf(THeroNameInfo) + SizeOf(TDBHeader), 0);
          if FileRead(m_nFileHandle, HumRecord, SizeOf(THeroNameInfo)) = SizeOf(THeroNameInfo) then
            if IdxHeader.dUpdateDate <> HumRecord.Header.dCreateDate then Result := False;
        end;
      end;
    finally
      Close();
    end;
    if Result then begin
      m_nLastIndex := IdxHeader.nLastIndex;
      m_dUpdateTime := IdxHeader.dUpdateDate;
      if IdxHeader.nQuickCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nQuickCount - 1 do begin
          if FileRead(nIdxFileHandle, IdxRecord, SizeOf(TIdxRecord)) = SizeOf(TIdxRecord) then begin
            m_QuickList.AddObject(IdxRecord.sChrName, TObject(IdxRecord.nIndex));
          end else begin
            Result := False;
            break;
          end;
        end; //0048AC7A
      end;
      if IdxHeader.nDeleteCount > 0 then begin//20090101
        for i := 0 to IdxHeader.nDeleteCount - 1 do begin
          if FileRead(nIdxFileHandle, n14, SizeOf(Integer)) = SizeOf(Integer) then
            m_DeletedList.Add(Pointer(n14))
          else begin
            Result := False;
            break;
          end;
        end;
      end;
    end; //0048ACC5
    FileClose(nIdxFileHandle);
  end; //0048ACCD
  if Result then begin
    n4ADAE4 := m_QuickList.Count;
    n4ADAE8 := m_QuickList.Count;
    n4ADAF0 := DBHeader.nHumCount;
    m_QuickList.SortString(0, m_QuickList.Count - 1);
  end else m_QuickList.Clear;
end;

function TFileHumHeroDB.OpenEx: Boolean;
var
  DBHeader: TDBHeader;
begin
  Lock();
  m_boChanged := False;
  m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
  if m_nFileHandle > 0 then begin
    Result := True;
    if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then
      m_Header := DBHeader;
    n4 := 0;
  end else Result := False;
end;

function TFileHumHeroDB.DeleteRecord(nIndex: Integer): Boolean;
var
  ChrRecordHeader: TNewHeroDataHeader;
begin
  Result := False;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(THeroNameInfo) + SizeOf(TDBHeader), 0) = -1 then Exit;
  m_nLastIndex := nIndex;
  m_dUpdateTime := Now();
  ChrRecordHeader.boDeleted := True;
  ChrRecordHeader.dCreateDate := Now();
  FileWrite(m_nFileHandle, ChrRecordHeader, SizeOf(TNewHeroDataHeader));
  m_DeletedList.Add(Pointer(nIndex));
  m_Header.nLastIndex := m_nLastIndex;
  m_Header.dLastDate := m_dUpdateTime;
  m_Header.dUpdateDate := Now();
  FileSeek(m_nFileHandle, 0, 0);
  FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  m_boChanged := True;
  Result := True;
end;     *)

end.
