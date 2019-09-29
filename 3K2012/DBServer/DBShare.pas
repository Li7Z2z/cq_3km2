unit DBShare;

interface
uses
  Windows, Messages, Classes, SysUtils, JSocket, WinSock, IniFiles, Grobal2, MudUtil, Common;

const
  DBSMode = 0;//DBServer����ģʽ 0-�ļ�����ģʽ 1-SQL���ݿ�ģʽ
  {$IF DBSMode = 1}
  g_sProductName = '84E109FD42D09E2BA048E57CC173B4974B2DB32C58104A6F14D293CE5F761879'; //3K�Ƽ����ݿ������[SQL��]
  {$ELSE}
  g_sProductName = 'FA69DD9E3373EA964B2DB32C58104A6F8BC9ED2FECE443BB'; //3K�Ƽ����ݿ������
  {$IFEND}
  g_sVersion = '4D8B003419EF61192F344FC7EADF5DF9C5C3C9374D92394E';  //2.00 Build 20121212
  g_sUpDateTime = '0A19BD8D3E7F9844CF3ABB7DBC68FB4D'; //2012/12/12
  g_sProgram = 'BF329B13CBE9010C601B4C1E88011620'; //3K�Ƽ�
  g_sWebSite = '92A51ADA62A0738AC5DB86D6E7E9CDE140574B5A981AB1753188062D144466D7'; // http://www.3KM2.com(����վ)
  g_sBbsSite = '6136601E4431B32C60BFBF8207DB95FA40574B5A981AB1753188062D144466D7'; //http://www.3KM2.net(����վ)

  SeedString = 'jdjwicjchahpnmstardhxksjhha'; //�����ַ��������Լ��趨
type
  TGList = class(TList)
  private
    GLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TSockaddr = record
    nIPaddr: Integer;
    dwStartAttackTick: LongWord;
    nAttackCount: Integer;
  end;
  pTSockaddr = ^TSockaddr;

  TCheckCode = record
    dwThread0: LongWord;
  end;
  TSelGateInfo = record
    Socket: TCustomWinSocket;
    sGateaddr: string; //0x04
    sText: string; //0x08
    UserList: TList; //0x0C
    dwTick10: LongWord; //0x10
    nGateID: Integer; //����ID
  end;
  pTSelGateInfo = ^TSelGateInfo;
  TUserInfo = record
    sAccount: string; //0x00
    sUserIPaddr: string; //0x0B
    sGateIPaddr: string;
    sConnID: string; //0x20
    nSessionID: Integer; //0x24
    Socket: TCustomWinSocket;
    s2C: string; //0x2C
    boChrSelected: Boolean; //0x30
    boChrQueryed: Boolean; //��ɫ��Ϣ�Ƿ���Բ�ѯ
    dwTick34: LongWord; //0x34
    dwChrTick: LongWord; //0x38
    nSelGateID: ShortInt; //��ɫ����ID
    nDataCount: Integer;
    sRandomCode: String;//��֤�� 20080612
    boRandomCode: Boolean; //�Ƿ���֤����֤��
  end;
  pTUserInfo = ^TUserInfo;
  TRouteInfo = record
    nGateCount: Integer;//RUN��������
    sSelGateIP: string[25];//��ɫ����IP
    sGameGateIP: array[0..7] of string[25];//������IP
    nGameGatePort: array[0..7] of Integer;//�˿�
  end;
  pTRouteInfo = ^TRouteInfo;

procedure LoadConfig();
procedure LoadIPTable();
procedure LoadGateID();
function GetGateID(sIPaddr: string): Integer;
function GetCodeMsgSize(X: Double): Integer;
function CheckChrName(sChrName: string): Boolean;
function InClearMakeIndexList(nIndex: Integer): Boolean;
function CheckServerIP(sIP: string): Boolean;
procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
procedure MainOutMessage(sMsg: string);
function GetMagicName(wMagicId: Word; nType: Byte): string;
function GetStdItemName(nPosition: Integer): string;
function AddAttackIP(sIPaddr: string): Boolean;
function LoadFiltrateUserNameList(): Boolean;//��ȡ���ֹ����б� 20080220
function LoadFiltrateSortNameList(): Boolean;//��ȡ�ַ������б� 20080220
{$IF DBSMode = 1}
function GetDenyRankingChrSQL(sFieldName: string): string;
{$ELSE}
function GetDisableUserNameList(sHumanName: string): Boolean;//�Ƿ��ǹ��˵����� 20080220
{$IFEND}
procedure SaveHumToFile(sFile:String;Taxis:THumSort);
procedure SaveHeroToFile(sFile:String;Taxis:THeroSort);
procedure LoadHumToFile(sFile:String;var Taxis:THumSort);
procedure LoadHeroToFile(sFile:String;var Taxis:THeroSort);

function Decrypt(const s:string; skey:string):string;
function CertKey(key: string): string;
function GetAdoSouse(S: String): String;
function CheckIsIpAddr(Name: string): Boolean;//���IP��ַ��ʽ�Ƿ�Ϸ� 20100411
function HostToIP(Name: string): String;//����תIP 20100411
procedure LoadDBSetup;

var
  boHumanOrder:Boolean= False;//20080315
  sHumDBFilePath: string = '.\FDB\';
  sDataDBFilePath: string = '.\FDB\';
  sFeedPath: string = '.\FDB\';
  sBackupPath: string = '.\FDB\';
  sConnectPath: string = '.\Connects\';
  sLogPath: string = '.\Log\';

  g_nServerPort: Integer = 6000;
  g_sServerAddr: string = '0.0.0.0';
  g_nGatePort: Integer = 5100;
  g_sGateAddr: string = '0.0.0.0';
  g_nGatePort1: Integer = 5101;
  g_sGateAddr1: string = '';//��·��Ĭ�ϲ���

  nIDServerPort: Integer = 5600;
  sIDServerAddr: string = '127.0.0.1';

  nDataManagePort: Integer = 6600;
  sDataManageAddrPort: string = '0.0.0.0';
  g_boEnglishNames   :Boolean = False;

  boViewHackMsg: Boolean = False;

  HumDB_CS: TRTLCriticalSection; //0x004ADACC

  n4ADAE4: Integer;
  n4ADAE8: Integer;
  n4ADAEC: Integer;
  n4ADAF0: Integer;
  boDataDBReady: Boolean; //0x004ADAF4
  n4ADAFC: Integer;
  n4ADB00: Integer;
  n4ADB04: Integer;
  boHumDBReady: Boolean; //0x4ADB08
  n4ADBF4: Integer;
  n4ADBF8: Integer;
  n4ADBFC: Integer;
  n4ADC00: Integer;
  n4ADC04: Integer;
  boAutoClearDB: Boolean; //�Զ���������
  g_nQueryChrCount: Integer; //��ѯ��ɫ��Ϣ�Ĵ���
  g_nSelChrPassCount: Integer; //ѡ���ɫ��Ϣ�Ĵ���
  g_nSelChrFailCount: Integer; //ѡ���ɫ��Ϣ�Ĵ���
  nHackerNewChrCount: Integer; //0x004ADC10
  nHackerDelChrCount: Integer; //0x004ADC14
  nHackerSelChrCount: Integer; //0x004ADC18
  n4ADC1C: Integer;
  n4ADC20: Integer;
  n4ADC24: Integer;
  n4ADC28: Integer;
  //n4ADC2C: Integer;
  n4ADB10: Integer;
  n4ADB14: Integer;
  n4ADB18: Integer;
  bo4ADB1C: Boolean;

  sServerName: string = '��������';//20080307
  sConfFileName: string = '.\Dbsrc.ini';
  sGateConfFileName: string = '.\!ServerInfo.txt';
  sServerIPConfFileNmae: string = '.\!AddrTable.txt';
  sGateIDConfFileName: string = '.\SelectID.txt';
  {$IF DBSMode = 1}
  g_sSQLString :String;//SQL���Ӵ�
  g_sSQLDatabase:String = 'mir2';
  g_sSQLHost:String = '.';
  g_sSQLUserName:String = 'mir2';
  g_sSQLPassword:String = '';
  {$ELSE}
  {$IFEND}
  sHeroDB: string = 'HeroDB';
//---------------------------------------------------------------------------
// 20080219
  sSort: string ='..\Mir200\Sort\';
  sEnvir: string ='..\Mir200\Envir\'; //20090402
  m_boAutoSort: Boolean =True;//�Զ���������
  nSortClass: Integer =0;//���� 0-ÿ�� 1-ÿ��
  nSortHour: Integer =0; //Сʱ
  nSortMinute: Integer =30; //��
  nSortLevel: Integer = 30;//�������а���͵ȼ�
  nSortMaxLevel:Integer = 65535;//�������а���ߵȼ�
  m_dwBakTick : LongWord;
  g_GlobaSessionList: TList; //ȫ�ֻỰ Move By TasNat at: 2012-03-13 17:14:11
  g_TaxisAllList     :THumSort;
  g_TaxisWarrList    :THumSort;
  g_TaxisWaidList    :THumSort;
  g_TaxisTaosList    :THumSort;
  g_MasterList       :THumSort;

  g_HeroAllList      :THeroSort;
  g_HeroWarrList     :THeroSort;
  g_HeroWaidList     :THeroSort;
  g_HeroTaosList     :THeroSort;

  g_FiltrateSortName: TStringList;//�ַ������б�
  g_FiltrateUserName: TStringList;//���ֹ����б�

  g_CheckCodePassList: TList;//�����½�󱣴�nSessionID�б� 20081205
  //�޸�Ϊ TList ����Ч�� By TasNat at: 2012-03-13 17:29:11
//------------------------------------------------------------------------------
  sMapFile: string;
  DenyChrNameList: TStringList;
  ServerIPList: TStringList;
  GateIDList: TStringList;
  StdItemList: TList;
  MagicList: TList;
  {
  nClearIndex        :Integer;   //��ǰ����λ�ã���¼��ID��
  nClearCount        :Integer;   //��ǰ�Ѿ���������
  nRecordCount       :Integer;   //��ǰ�ܼ�¼��
    }
  {  boClearLevel1      :Boolean = True;
  boClearLevel2      :Boolean = True;
  boClearLevel3      :Boolean = True;  }

  dwInterval: LongWord = 30000; //����ʱ��������

  nLevel1: Integer = 1; //����ȼ� 1
  nLevel2: Integer = 7; //����ȼ� 2
  nLevel3: Integer = 14; //����ȼ� 3

  nDay1: Integer = 14; //����δ��¼���� 1
  nDay2: Integer = 62; //����δ��¼���� 2
  nDay3: Integer = 124; //����δ��¼���� 3

  nMonth1: Integer = 0; //����δ��¼���� 1
  nMonth2: Integer = 0; //����δ��¼���� 2
  nMonth3: Integer = 0; //����δ��¼���� 3

  g_nClearRecordCount: Integer;
  g_nClearIndex: Integer; //0x324
  g_nClearCount: Integer; //0x328
  g_nClearItemIndexCount: Integer;

  boOpenDBBusy: Boolean;
  g_dwGameCenterHandle: THandle;
  g_boDynamicIPMode: Boolean = False;
  g_CheckCode: TCheckCode;
  g_ClearMakeIndex: TStringList;

  g_RouteInfo: array[0..19] of TRouteInfo;
  g_MainMsgList: TStringList;
  g_OutMessageCS: TRTLCriticalSection;
  //ProcessHumanCriticalSection: TRTLCriticalSection;//20080915 ע��,δʹ��
  HumanSortCriticalSection: TRTLCriticalSection;//�����ٽ��� 20080915
  IDSocketConnected: Boolean;
  UserSocketClientConnected: Boolean;
  UserSocketClientConnected1: Boolean;
  ServerSocketClientConnected: Boolean;
  DataManageSocketClientConnected: Boolean;

  ID_sRemoteAddress: string;
  User_sRemoteAddress: string;
  User_sRemoteAddress1: string;
  Server_sRemoteAddress: string;
  DataManage_sRemoteAddress: string;

  ID_nRemotePort: Integer;
  User_nRemotePort: Integer;
  User_nRemotePort1: Integer;
  Server_nRemotePort: Integer;
  DataManage_nRemotePort: Integer;

  dwKeepAliveTick: LongWord;
  dwKeepIDAliveTick: LongWord;
  dwKeepServerAliveTick: LongWord;

  AttackIPaddrList: TGList; //����IP��ʱ�б�
  boAttack: Boolean = False;
  boDenyChrName: Boolean = True;
  boMinimize: Boolean = True;
  g_boRandomCode: Boolean = True;
  g_boNoCanResDelChr: Boolean = False;//20080706 ��ֹ�ָ�ɾ���Ľ�ɫ
  PBoolean : ^AnsiString;//�洢ע���IP��ַ 20090708

  g_boNoCanDelChr: Boolean = False;//20090826 ��ֹɾ����С�ȼ���ɫ
  dwCanDelChrLevel: Word = 0;//20090826 ��ֹɾ���Ľ�ɫ�ȼ�
  boRefSord: Boolean = False;//�Ƿ�����ˢ�����а�
const
  tDBServer = 0;
implementation

uses DBSMain, HUtil32, StrUtils, HumDB{$IF DBSMode = 1}, EDcodeUnit{$IFEND};

procedure LoadGateID();
var
  i: Integer;
  LoadList: TStringList;
  sLineText: string;
  sID: string;
  sIPaddr: string;
  nID: Integer;
begin
  GateIDList.Clear;
  if FileExists(sGateIDConfFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sGateIDConfFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText = '') or (sLineText[1] = ';') then Continue;
      sLineText := GetValidStr3(sLineText, sID, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sIPaddr, [' ', #9]);
      nID := Str_ToInt(sID, -1);
      if nID < 0 then Continue;
      GateIDList.AddObject(sIPaddr, TObject(nID))
    end;
    LoadList.Free;
  end;
end;
function GetGateID(sIPaddr: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to GateIDList.Count - 1 do begin
    if GateIDList.Strings[i] = sIPaddr then begin
      Result := Integer(GateIDList.Objects[i]);
      break;
    end;
  end;
end;

procedure LoadIPTable();
var
  LoadList: TStringList;
begin
  ServerIPList.Clear;
  try
    if not FileExists(sServerIPConfFileNmae) then begin
      LoadList := TStringList.Create;
      LoadList.Add(';IP�б��ļ�');
      LoadList.SaveToFile(sServerIPConfFileNmae);
      LoadList.Free;
    end;
    ServerIPList.LoadFromFile(sServerIPConfFileNmae);
  except
    MainOutMessage('����IP�б��ļ� ' + sServerIPConfFileNmae + ' ��������');
  end;
end;
procedure LoadConfig();
var
  Conf: TIniFile;
  LoadInteger: Integer;
  LoadString: string;
begin
  Conf := TIniFile.Create(sConfFileName);
  if Conf <> nil then begin
    LoadString := Conf.ReadString('DB', 'Dir', '');
    if LoadString = '' then Conf.WriteString('DB', 'Dir', sDataDBFilePath)
    else sDataDBFilePath:= LoadString;

    LoadString := Conf.ReadString('DB', 'HumDir', '');
    if LoadString = '' then Conf.WriteString('DB', 'HumDir', sHumDBFilePath)
    else sHumDBFilePath:= LoadString;
{$IF DBSMode = 1}
    LoadString := Conf.ReadString('SQL', 'SQLHost', '');
    if LoadString = '' then Conf.WriteString('SQL', 'SQLHost', g_sSQLHost)
    else g_sSQLHost:= LoadString;

    LoadString := Conf.ReadString('SQL', 'SQLDatabase', '');
    if LoadString = '' then Conf.WriteString('SQL', 'SQLDatabase', g_sSQLDatabase)
    else g_sSQLDatabase:= LoadString;

    LoadString := Conf.ReadString('SQL', 'SQLUsername', '');
    if LoadString = '' then Conf.WriteString('SQL', 'SQLUsername', g_sSQLUserName)
    else g_sSQLUserName:= LoadString;

    LoadString := Conf.ReadString('SQL', 'SQLPassword', '');
    if LoadString = '' then Conf.WriteString('SQL', 'SQLPassword', g_sSQLPassword)
    else g_sSQLPassword:= LoadString;
{$IFEND}
    LoadString := Conf.ReadString('DB', 'FeeDir', '');
    if LoadString = '' then Conf.WriteString('DB', 'FeeDir', sFeedPath)
    else sFeedPath:= LoadString;

    LoadString := Conf.ReadString('DB', 'Backup', '');
    if LoadString = '' then Conf.WriteString('DB', 'Backup', sBackupPath)
    else sBackupPath:= LoadString;

    LoadString := Conf.ReadString('DB', 'ConnectDir', '');
    if LoadString = '' then Conf.WriteString('DB', 'ConnectDir', sConnectPath)
    else sConnectPath:= LoadString;
    
    LoadString := Conf.ReadString('DB', 'LogDir', '');
    if LoadString = '' then Conf.WriteString('DB', 'LogDir', sLogPath)
    else sLogPath:= LoadString;

    LoadInteger := Conf.ReadInteger('Setup', 'ServerPort', -1);
    if LoadInteger < 0 then Conf.WriteInteger('Setup', 'ServerPort', g_nServerPort)
    else g_nServerPort:= LoadInteger;

    LoadString := Conf.ReadString('Setup', 'ServerAddr', '');
    if LoadString = '' then Conf.WriteString('Setup', 'ServerAddr', g_sServerAddr)
    else g_sServerAddr:= LoadString;
    //nServerPort := Conf.ReadInteger('Setup', 'ServerPort', nServerPort);
    //sServerAddr := Conf.ReadString('Setup', 'ServerAddr', sServerAddr);

    LoadInteger := Conf.ReadInteger('Setup', 'GatePort', -1);//��ɫ���ض˿�
    if LoadInteger < 0 then Conf.WriteInteger('Setup', 'GatePort', g_nGatePort)
    else g_nGatePort:= LoadInteger;

    LoadString := Conf.ReadString('Setup', 'GateAddr', '');//��ɫ����IP
    if LoadString = '' then Conf.WriteString('Setup', 'GateAddr', g_sGateAddr)
    else g_sGateAddr:= LoadString;

    LoadInteger := Conf.ReadInteger('Setup', 'GatePort1', -1);//��ɫ���ض˿�
    if LoadInteger < 0 then Conf.WriteInteger('Setup', 'GatePort1', g_nGatePort1)
    else g_nGatePort1:= LoadInteger;

    LoadString := Conf.ReadString('Setup', 'GateAddr1', '');//��ɫ����IP
    if LoadString = '' then Conf.WriteString('Setup', 'GateAddr1', g_sGateAddr1)
    else g_sGateAddr1:= LoadString;

    LoadInteger := Conf.ReadInteger('Server', 'IDSPort', -1);
    if LoadInteger < 0 then Conf.WriteInteger('Server', 'IDSPort', nIDServerPort)
    else nIDServerPort:= LoadInteger;

    LoadString := Conf.ReadString('Server', 'IDSAddr', '');
    if LoadString = '' then Conf.WriteString('Server', 'IDSAddr', sIDServerAddr)
    else sIDServerAddr:= LoadString;
    //sIDServerAddr := Conf.ReadString('Server', 'IDSAddr', sIDServerAddr);
    //nIDServerPort := Conf.ReadInteger('Server', 'IDSPort', nIDServerPort);

    LoadString := Conf.ReadString('Setup', 'ServerName', '');
    if LoadString = '' then Conf.WriteString('Setup', 'ServerName', sServerName)
    else sServerName:= LoadString;

    LoadInteger := Conf.ReadInteger('Setup', 'ViewHackMsg', -1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup', 'ViewHackMsg', boViewHackMsg);
    end else boViewHackMsg := LoadInteger = 1;
    //boViewHackMsg := Conf.ReadBool('Setup', 'ViewHackMsg', boViewHackMsg);
    //sServerName := Conf.ReadString('Setup', 'ServerName', sServerName);

    LoadInteger := Conf.ReadInteger('Setup', 'Attack', -1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup', 'Attack', boAttack);
    end else boAttack := LoadInteger = 1;

    LoadInteger := Conf.ReadInteger('Setup', 'DenyChrName', -1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup', 'DenyChrName', boDenyChrName);
    end else boDenyChrName := LoadInteger = 1;
    //boAttack := Conf.ReadBool('Setup', 'Attack', boAttack);
    //boDenyChrName := Conf.ReadBool('Setup', 'DenyChrName', boDenyChrName);

    LoadInteger := Conf.ReadInteger('Setup', 'Minimize', -1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup', 'Minimize', boMinimize);
    end else boMinimize := LoadInteger = 1;

    {
    boClearLevel1:=Conf.ReadBool('DBClear','ClearLevel1',boClearLevel1);
    boClearLevel2:=Conf.ReadBool('DBClear','ClearLevel2',boClearLevel2);
    boClearLevel3:=Conf.ReadBool('DBClear','ClearLevel3',boClearLevel3);
    }
    {$IF DBSMode = 0}
    dwInterval := Conf.ReadInteger('DBClear', 'Interval', dwInterval);
    {$IFEND}
    nLevel1 := Conf.ReadInteger('DBClear', 'Level1', nLevel1);
    nLevel2 := Conf.ReadInteger('DBClear', 'Level2', nLevel2);
    nLevel3 := Conf.ReadInteger('DBClear', 'Level3', nLevel3);
    nDay1 := Conf.ReadInteger('DBClear', 'Day1', nDay1);
    nDay2 := Conf.ReadInteger('DBClear', 'Day2', nDay2);
    nDay3 := Conf.ReadInteger('DBClear', 'Day3', nDay3);
    nMonth1 := Conf.ReadInteger('DBClear', 'Month1', nMonth1);
    nMonth2 := Conf.ReadInteger('DBClear', 'Month2', nMonth2);
    nMonth3 := Conf.ReadInteger('DBClear', 'Month3', nMonth3);

    LoadInteger := Conf.ReadInteger('Setup', 'DynamicIPMode', -1);
    if LoadInteger < 0 then begin
      Conf.WriteBool('Setup', 'DynamicIPMode', g_boDynamicIPMode);
    end else g_boDynamicIPMode := LoadInteger = 1;
    
    sHeroDB := Conf.ReadString('Setup', 'DBName', '');
    if sHeroDB = '' then begin
      Conf.WriteString('Setup', 'DBName', 'HeroDB');
    end;

    if Conf.ReadInteger('Setup', 'AutoSort', -1) < 0 then
      Conf.WriteBool('Setup', 'AutoSort', m_boAutoSort);
    m_boAutoSort := Conf.ReadBool('Setup', 'AutoSort', m_boAutoSort);//�Զ��������� 20080219

    LoadInteger :=Conf.ReadInteger('Setup', 'SortClass', -1);//���� 0-ÿ�� 1-ÿ�� 20080219
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'SortClass', nSortClass)
    else nSortClass:= LoadInteger;
    LoadInteger :=Conf.ReadInteger('Setup', 'SortHour', -1);//Сʱ  20080219
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'SortHour', nSortHour)
    else nSortHour:= LoadInteger;
    LoadInteger :=Conf.ReadInteger('Setup', 'SortMinute', -1);//��   20080219
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'SortMinute', nSortMinute)
    else nSortMinute:= LoadInteger;

    LoadInteger :=Conf.ReadInteger('Setup', 'SortLevel', -1);//���˵ȼ� 20080219
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'SortLevel', nSortLevel)
    else nSortLevel:= LoadInteger;

    LoadInteger :=Conf.ReadInteger('Setup', 'SortMaxLevel', -1);//�������а���ߵȼ�
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'SortMaxLevel', nSortMaxLevel)
    else nSortMaxLevel:= LoadInteger;

    LoadString := Conf.ReadString('DB', 'Sort', '');//20080617
    if LoadString = '' then  Conf.WriteString('DB', 'Sort', sSort)
    else sSort:= LoadString;

    LoadString := Conf.ReadString('DB', 'Envir', '');//20090402  //�Զ��һ��ļ�����·��
    if LoadString = '' then  Conf.WriteString('DB', 'Envir', sEnvir)
    else sEnvir:= LoadString;

    if Conf.ReadInteger('Setup', 'RandomCode', -1) < 0 then
      Conf.WriteBool('Setup', 'RandomCode', g_boRandomCode);
    g_boRandomCode := Conf.ReadBool('Setup', 'RandomCode', g_boRandomCode);

    if Conf.ReadInteger('Setup', 'NoCanResDelChr', -1) < 0 then//20080706 ��ֹ�ָ�ɾ���Ľ�ɫ
      Conf.WriteBool('Setup', 'NoCanResDelChr', g_boNoCanResDelChr);
    g_boNoCanResDelChr := Conf.ReadBool('Setup', 'NoCanResDelChr', g_boNoCanResDelChr);

    if Conf.ReadInteger('Setup', 'NoCanDelChr', -1) < 0 then//20090826 ��ֹɾ����С�ȼ���ɫ
      Conf.WriteBool('Setup', 'NoCanDelChr', g_boNoCanDelChr);
    g_boNoCanDelChr := Conf.ReadBool('Setup', 'NoCanDelChr', g_boNoCanDelChr);

    LoadInteger :=Conf.ReadInteger('Setup', 'CanDelChrLevel', -1);//20090826 ��ֹɾ���Ľ�ɫ�ȼ�
    if LoadInteger < 0 then
      Conf.WriteInteger('Setup', 'CanDelChrLevel', dwCanDelChrLevel)
    else dwCanDelChrLevel:= LoadInteger;

    Conf.Free;
  end;
  LoadIPTable();
  LoadGateID();
end;

function GetStdItemName(nPosition: Integer): string;
var
  StdItem: pTStdItem;
begin
  if (nPosition - 1 >= 0) and (nPosition < StdItemList.Count) then begin
    StdItem := StdItemList.Items[nPosition - 1];
    if StdItem <> nil then begin
      Result := StdItem.Name;
    end;
  end;
end;

function GetMagicName(wMagicId: Word; nType: Byte): string;
var
  i: Integer;
  Magic: pTMagic;
  sMagicDescr: string;
begin
  case nType of
    1:sMagicDescr:='Ӣ��';
    2:sMagicDescr:='�ڹ�';
    else sMagicDescr:='';
  end;
  for i := 0 to MagicList.Count - 1 do begin
    Magic := MagicList.Items[i];
    if Magic <> nil then begin
      if (Magic.wMagicId = wMagicId) and ((Magic.sDescr = sMagicDescr) or (Magic.sDescr='����') or (Magic.sDescr='ͨ�� ')or (Magic.sDescr='��')) then begin
        if (nType = 2) and (Magic.sDescr='����') then Continue;//����
        Result := Magic.sMagicName;
        break;
      end;
    end;
  end;
end;

function GetCodeMsgSize(X: Double): Integer;
begin
  if INT(X) < X then Result := TRUNC(X) + 1
  else Result := TRUNC(X)
end;

function CheckChrName(sChrName: string): Boolean;//0x0045BE60
var
  i: Integer;
  Chr: Char;
  boIsTwoByte: Boolean;
  FirstChr: Char;
  sgr: String;
begin
  Result := True;
  boIsTwoByte := False;
  FirstChr := #0;
  for i := 1 to Length(sChrName) do begin
    Chr := (sChrName[i]);
    if boIsTwoByte then begin
      if not ((FirstChr <= #$F7) and (Chr >= #$40) and (Chr <= #$FE)) then
        if not ((FirstChr > #$F7) and (Chr >= #$40) and (Chr <= #$A0)) then Result := False;
      boIsTwoByte := False;
    end else begin
      if (Chr >= #$81) and (Chr <= #$FE) then begin
        boIsTwoByte := True;
        FirstChr := Chr;
      end else begin //0x0045BED2
        if not ((Chr >= '0' {#30}) and (Chr <= '9' {#39})) and
          not ((Chr >= 'a' {#61}) and (Chr <= 'z') {#7A}) and
          not ((Chr >= 'A' {#41}) and (Chr <= 'Z' {#5A})) then
          Result := False;
      end;
    end;
    if not Result then break;
  end;
  if Result then begin//20100925 ����ʹ�ͻ��˽�ȡ������ַ�
    if AnsiContainsText(sChrName, '��') or AnsiContainsText(sChrName, '��') or
       AnsiContainsText(sChrName, '�') or AnsiContainsText(sChrName, '�Z') or
       AnsiContainsText(sChrName, '�[') {or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\') or
       AnsiContainsText(sChrName, '�\') or AnsiContainsText(sChrName, '�\')} then Result := False;
    if Result then begin//�ж��Ƿ���������GetValidStr3����ת���󣬳���'\'����ת�������'\',����Ϊ�ǷǷ��ַ� 20100925
      GetValidStr3(sChrName,sgr,['\']);
      if Length(sChrName) <> Length(sgr) then Result := False;
    end;
  end;
end;

function InClearMakeIndexList(nIndex: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if g_ClearMakeIndex.Count > 0 then begin
    for i := 0 to g_ClearMakeIndex.Count - 1 do begin
      if nIndex = Integer(g_ClearMakeIndex.Objects[i]) then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

procedure MainOutMessage(sMsg: string);
begin
  EnterCriticalSection(g_OutMessageCS);
  try
    g_MainMsgList.Add(sMsg);
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;
end;

//��������IP
function CheckServerIP(sIP: string): Boolean;
var
  i: Integer;
  sServerIP: String;
begin
  Result := False;
  if not CheckIsIpAddr(sIP) then sIP:= HostToIP(sIP);
  for i := 0 to ServerIPList.Count - 1 do begin
    sServerIP:= ServerIPList.Strings[i];
    if not CheckIsIpAddr(sServerIP) then sServerIP:= HostToIP(sServerIP);
    if CompareText(sIP, {ServerIPList.Strings[i]}sServerIP) = 0 then begin
      Result := True;
      break;
    end;
  end;
end;

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tDBServer), wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

constructor TGList.Create;
begin
  inherited Create;
  InitializeCriticalSection(GLock);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(GLock);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(GLock);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(GLock);
end;

function AddAttackIP(sIPaddr: string): Boolean;
var
  I: Integer;
  IPaddr, AddIPaddr: pTSockaddr;
  nIPaddr: Integer;
  bo01: Boolean;
begin
  Result := False;
  AttackIPaddrList.Lock;
  try
    bo01 := False;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to AttackIPaddrList.Count - 1 do begin
      IPaddr := pTSockaddr(AttackIPaddrList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        if IPaddr.nAttackCount >= 3 then Result := True;
        Inc(IPaddr.nAttackCount);
        bo01 := True;
        break;
      end;
    end;
    if not bo01 then begin
      New(AddIPaddr);
      FillChar(AddIPaddr^, SizeOf(TSockaddr), 0);
      AddIPaddr^.nIPaddr := nIPaddr;
      AddIPaddr^.dwStartAttackTick := GetTickCount;
      AddIPaddr^.nAttackCount := 0;
      AttackIPaddrList.Add(AddIPaddr);
    end;
  finally
    AttackIPaddrList.UnLock;
  end;
end;
//------------------------------------------------------------------------------
//��ȡ���ֹ����б�
function LoadFiltrateUserNameList(): Boolean;
var
  I: Integer;
  LoadList: TStringList;
  sFileName, sLineText: string;
begin
  Result := False;
  sFileName := 'FiltrateUserName.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_FiltrateUserName.Clear;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
     sLineText := LoadList.Strings[I];
     if (sLineText <> '') and (sLineText[1] <> ';') then
      g_FiltrateUserName.Add(Trim(LoadList.Strings[I]));
    end;
    Result := True;
  end else begin
    LoadList.Add(';���а������������');
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
//��ȡ�ַ������б�
function LoadFiltrateSortNameList(): Boolean;
var
  I: Integer;
  LoadList: TStringList;
  sFileName, sLineText: string;
begin
  Result := False;
  sFileName := 'FiltrateSortName.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    g_FiltrateSortName.Clear;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
     sLineText := LoadList.Strings[I];
     if (sLineText <> '') and (sLineText[1] <> ';') then
        g_FiltrateSortName.Add(Trim(LoadList.Strings[I]));
    end;
    Result := True;
  end else begin
    LoadList.Add(';������������ַ�');
    LoadList.SaveToFile(sFileName);
  end;
  LoadList.Free;
end;
(*
procedure QuickSort(sList: TStringList; Order: Boolean); //�ٶȸ��������
  procedure QuickSortStrListCase(List: TStringList; l, r: Integer);
  var
    I, j: Integer;
    p: string;
  begin
    if List.Count <= 0 then Exit;
    repeat
      I := l;
      j := r;
      p := List[(l + r) shr 1];
      repeat
        if Order then begin //����
          while CompareStr(List[I], p) < 0 do Inc(I);
          while CompareStr(List[j], p) > 0 do Dec(j);
        end else begin //����
          while CompareStr(p, List[I]) < 0 do Inc(I);
          while CompareStr(p, List[j]) > 0 do Dec(j);
        end;
        if I <= j then begin
          List.Exchange(I, j);
          Inc(I);
          Dec(j);
        end;
      until I > j;
      if l < j then QuickSortStrListCase(List, l, j);
      l := I;
    until I >= r;
  end;
  procedure AddList(TempList: TStringList; slen: string; s: string; AObject: TObject);
  var
    I: Integer;
    List: TStringList;
    boFound: Boolean;
  begin
    boFound := False;
    for I := 0 to TempList.Count - 1 do begin
      if CompareText(TempList.Strings[I], slen) = 0 then begin
        List := TStringList(TempList.Objects[I]);
        List.AddObject(s, AObject);
        boFound := True;
        Break;
      end;
    end;
    if not boFound then begin
      List := TStringList.Create;
      List.AddObject(s, AObject);
      TempList.AddObject(slen, List);
    end;
  end;
var
  TempList: TStringList;
  List: TStringList;
  I: Integer;
  nLen: Integer;
begin
  TempList := TStringList.Create;
  for I := 0 to sList.Count - 1 do begin
    nLen := Length(sList.Strings[I]);
    AddList(TempList, IntToStr(nLen), sList.Strings[I], sList.Objects[I]);
  end;
  QuickSortStrListCase(TempList, 0, TempList.Count - 1);
  sList.Clear;
  for I := 0 to TempList.Count - 1 do begin
    List := TStringList(TempList.Objects[I]);
    QuickSortStrListCase(List, 0, List.Count - 1);
    sList.AddStrings(List);
    List.Free;
  end;
  TempList.Free;
end;  *)

//�Ƿ��ǹ��˵�����
function GetDisableUserNameList(sHumanName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    if g_FiltrateSortName.Count > 0 then begin//20090101
      for I := 0 to g_FiltrateSortName.Count - 1 do begin//�ַ�����
        if pos(g_FiltrateSortName.Strings[I],sHumanName) <> 0 then begin
          Result := True;
          Exit;
        end;
      end;
    end;
    if g_FiltrateUserName.Count > 0 then begin//20090101
      for I := 0 to g_FiltrateUserName.Count - 1 do begin//���ֹ���
        if CompareText(sHumanName, g_FiltrateUserName.Strings[I]) = 0 then begin
          Result := True;
          Break;
        end;
      end;
    end;
  except
    MainOutMessage('[�쳣] GetDisableUserNameList Name:'+sHumanName);
  end;
end;
{$IF DBSMode = 1}
function GetDenyRankingChrSQL(sFieldName: string): string;
var
  I: Integer;
begin
  Result := ' ';
  if g_FiltrateSortName.Count > 0 then begin
    for I := 0 to g_FiltrateSortName.Count - 1 do begin//�ַ�����
      Result := Result + ' AND (' + sFieldName + ' NOT LIKE ''%' + g_FiltrateSortName.Strings[I] + '%'') ';
    end;
  end;
  if g_FiltrateUserName.Count > 0 then begin
    for I := 0 to g_FiltrateUserName.Count - 1 do begin//���ֹ���
      Result := Result + ' AND (' + sFieldName + ' <> '+''''+g_FiltrateUserName.Strings[I]+''''+') ';
    end;
  end;
end;
{$IFEND}

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

procedure SaveHumToFile(sFile:String;Taxis:THumSort);
var
  nFileHandle:integer;
begin
  if FileExists(sFile) then begin
    nFileHandle:=FileOpen(sFile,fmOpenReadWrite or fmShareDenyNone);
  end else begin
    nFileHandle:=FileCreate(sFile);
  end;
  if nFileHandle > 0 then begin
    Try
      FileSeek(nFileHandle,0,0);
      FileWrite(nFileHandle,Taxis,SizeOf(THumSort));
    Finally
      FileClose(nFileHandle);
    end;
  end;
end;

procedure SaveHeroToFile(sFile:String;Taxis:THeroSort);
var
  nFileHandle:integer;
begin
  if FileExists(sFile) then begin
    nFileHandle:=FileOpen(sFile,fmOpenReadWrite or fmShareDenyNone);
  end else begin
    nFileHandle:=FileCreate(sFile);
  end;
  if nFileHandle > 0 then begin
    Try
      FileSeek(nFileHandle,0,0);
      FileWrite(nFileHandle,Taxis,SizeOf(THeroSort));
    Finally
      FileClose(nFileHandle);
    end;
  end;
end;

function Decrypt(const s:string; skey:string):string;
  function myHextoStr(S: string): string;
  var hexS,tmpstr:string;
      i:integer;
      a:byte;
  begin
      hexS  :=s;//Ӧ���Ǹ��ַ���
      if length(hexS) mod 2=1 then hexS:=hexS+'0';
      tmpstr:='';
      for i:=1 to (length(hexS) div 2) do begin
          a:=strtoint('$'+hexS[2*i-1]+hexS[2*i]);
          tmpstr := tmpstr+chr(a);
      end;
      result :=tmpstr;
  end;
  function myStrtoHex(s: string): string;
  var tmpstr:string;
      i:integer;
  begin
      tmpstr := '';
      for i:=1 to length(s) do
      begin
          tmpstr := tmpstr + inttoHex(ord(s[i]),2);
      end;
      result := tmpstr;
  end;
var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;
begin
    hexS  :=s;//Ӧ���Ǹ��ַ���
    if length(hexS) mod 2=1 then Exit;
    hexskey:=myStrtoHex(skey);
    tmpstr :=hexS;
    midS   :=hexS;
    for i:=(length(hexskey) div 2) downto 1 do begin
        if i<>(length(hexskey) div 2) then midS:= tmpstr;
        tmpstr:='';
        for j:=1 to (length(midS) div 2) do begin
            a:=strtoint('$'+midS[2*j-1]+midS[2*j]);
            b:=strtoint('$'+hexskey[2*i-1]+hexskey[2*i]);
            c:=a xor b;
            tmpstr := tmpstr+myStrtoHex(chr(c));
        end;
    end;
    result := myHextoStr(tmpstr);
end;
//������Կ
function CertKey(key: string): string;
var i: Integer;
begin
  for i:=1 to length(key) do
    result := result + chr(ord(key[i]) xor length(key)*i*i)
end;
//�¼�����Կ����
function GetAdoSouse(S: String): String;
var
  i,j:Integer;
  Asc:Byte;
begin
  Result:='';
  for i:=1 to Length(S) do begin
     if (i mod Length(SeedString)) = 0 then
       j:=Length(SeedString)
     else j:=(i mod Length(SeedString));
     Asc:=Byte(S[i]) xor Byte(SeedString[j]);
     Result:=Result+IntToHex(Asc,3);
  end;
end;

//���IP��ַ��ʽ�Ƿ�Ϸ� 20100405
function CheckIsIpAddr(Name: string): Boolean;
var
  PStr: char;
  Temp: PChar;
  I: integer;
begin
  Result := True;
  if Length(Name) <= 15 then begin
    for I := 0 to Length(Name) do begin
      Temp := PChar(copy(Name, I, 1));
      PStr := Temp^;
      if not (PStr in ['0'..'9', '.']) then begin
        Result := False;
        break
      end;
    end;
  end else Result := False;
end;
//����תIP 20100405
function HostToIP(Name: string): String;
var
  wsdata : TWSAData;
  hostName : array [0..255] of char;
  hostEnt : PHostEnt;
  addr : PChar;
begin
  Result := '';
  WSAStartup ($0101, wsdata);
  try
    gethostname (hostName, sizeof (hostName));
    StrPCopy(hostName, Name);
    hostEnt := gethostbyname (hostName);
    if Assigned (hostEnt) then
      if Assigned (hostEnt^.h_addr_list) then begin
        addr := hostEnt^.h_addr_list^;
        if Assigned (addr) then begin
          Result := Format ('%d.%d.%d.%d', [byte(addr [0]),byte(addr [1]), byte(addr [2]),byte(addr [3])]);
        end;
    end;
  finally
    WSACleanup;
  end
end;

procedure LoadDBSetup;
begin
  {$IF DBSMode = 1}
  g_sSQLString := format('Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;'
                        +'User ID=%s;Initial Catalog=%s;Data Source=%s',[Base64DecodeStr(g_sSQLPassword), g_sSQLUserName, g_sSQLDatabase, g_sSQLHost]);
  {$IFEND}
end;
//------------------------------------------------------------------------------
initialization
  begin
    New(PBoolean);
    InitializeCriticalSection(g_OutMessageCS);
    InitializeCriticalSection(HumDB_CS);
    InitializeCriticalSection(HumanSortCriticalSection);//�����ٽ��� 20080915
    g_MainMsgList := TStringList.Create;
    DenyChrNameList := TStringList.Create;
    ServerIPList := TStringList.Create;
    GateIDList := TStringList.Create;
    g_ClearMakeIndex := TStringList.Create;
    StdItemList := TList.Create;
    MagicList := TList.Create;
//------------------------------------------------------------------------------
    g_FiltrateSortName:= TStringList.Create;//�ַ������б�
    g_FiltrateUserName:= TStringList.Create;//���ֹ����б�

    g_CheckCodePassList:= TList.Create;
//------------------------------------------------------------------------------
  end;

finalization
  begin
    Dispose(PBoolean);
    DeleteCriticalSection(HumDB_CS);
    DeleteCriticalSection(g_OutMessageCS);
    DeleteCriticalSection(HumanSortCriticalSection);//�����ٽ��� 20080915
    DenyChrNameList.Free;
    ServerIPList.Free;
    GateIDList.Free;
    g_ClearMakeIndex.Free;
    g_MainMsgList.Free;
    StdItemList.Free;
    MagicList.Free;
//------------------------------------------------------------------------------
    g_FiltrateSortName.Free;//�ַ������б�
    g_FiltrateUserName.Free;//���ֹ����б�

    g_CheckCodePassList.Free;
//------------------------------------------------------------------------------
  end;

end.
