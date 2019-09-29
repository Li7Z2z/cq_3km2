unit UsrEngn;  // ��������Ĵ���

interface
uses
  Windows, Classes, SysUtils, StrUtils, Controls, ObjBase, ObjNpc, Envir,
  Grobal2, SDK, ObjHero, ObjAIPlayObject;
  
type

  TMonGenInfo = record
    CertList: TList;
    sMapName: string[14];//��ͼ��
    nRace: Integer;//��������
    nRange: Integer;//��Χ
    nMissionGenRate: Integer;//��������ˢ�»��� 1 -100
    dwStartTick: LongWord;//ˢ�ּ��
    nX: Integer;//X����                           
    nY: Integer;//Y����
    sMonName: string[14];//������
    nCount: Integer;//��������
    dwZenTime: LongWord;//ˢ��ʱ��
    //dwStartTime: LongWord;//����ʱ��
    boIsNGMon: Boolean;//�ڹ���,����������������ֵ 20081001
    boIsHeroPulsMon: Boolean;//Ӣ�۾��羭���
    nNameColor: Byte; //�Զ������ֵ���ɫ 20080810
    nChangeColorType: Integer; //2007-02- 01 ����  0�Զ���ɫ >0�ı���ɫ -1���ı�
    Envir: TEnvirnoment;//����
  end;
  pTMonGenInfo = ^TMonGenInfo;

  TMapMonGenCount = record
    sMapName: string[14];//��ͼ����
    nMonGenCount: Integer;//ˢ������
    dwNotHumTimeTick: LongWord;//û��ҵļ��
    nClearCount: Integer;//�������
    boNotHum: Boolean;//�Ƿ������
    dwMakeMonGenTimeTick: LongWord;//ˢ�ֵļ��
    nMonGenRate: Integer; //ˢ�ֱ���  10
    dwRegenMonstersTime: LongWord; //ˢ���ٶ�    200
  end;
  pTMapMonGenCount = ^TMapMonGenCount;

  TAILogon = record//���˵�½�ṹ
    sCharName: string[14];//����
    sMapName: string[14];//��ͼ
    sConfigFileName: string;//��������·��
    sHeroConfigFileName: string;//Ӣ������·��
    sFilePath: string;
    sConfigListFileName: string;//���������б�Ŀ¼
    sHeroConfigListFileName: string;//Ӣ�������б�Ŀ¼
    nX: Integer;//X����
    nY: Integer;//Y����
  end;
  pTAILogon = ^TAILogon;

  TUserEngine = class
    m_LoadPlaySection: TRTLCriticalSection;
    m_M2AutoAddPlay: TStringList;//M2�Զ��һ��������� 20090725
    m_LoadPlayList: TStringList; //��DB��ȡ��������
    m_PlayObjectList: TStringList; //���߽�ɫ�б�
    m_PlayObjectFreeList: TList; //��Ҫ�ͷŵĽ�ɫ�б�
    m_MonObjectList: TList;//�������е��ػ��� 20090111
    m_ChangeHumanDBGoldList: TList; //���ת���б�(��Ҳ����ߣ���������ʱ�Զ��ӽ��)
    dwShowOnlineTick: LongWord; //��ʾ�����������
    dwSendOnlineHumTime: LongWord; //���������������
    dwProcessMapDoorTick: LongWord; //0x20
    dwProcessMissionsTime: LongWord; //0x24
    dwRegenMonstersTick: LongWord; //ˢ�ּ����ʱ
    m_dwProcessLoadPlayTick: LongWord; //0x30
    m_dwM2AutoAddPlayTick: LongWord;//�һ����
    m_nCurrMonGen: Integer; //ˢ������
    m_nMonGenListPosition: Integer; //0x3C

    m_nProcHumIDx: Integer; //�������￪ʼ������ÿ�δ������������ƣ�
    nMerchantPosition: Integer; //0x4C
    nNpcPosition: Integer; //0x50
    StdItemList: TList; //��Ʒ�б�(�����ݿ��е�����)
    {$IF M2Version <> 2}
    HumTitleList: TList;//�ƺ��б�(�����ݿ��е�����)
    {$IFEND}
    MonsterList: TList; //�����б�
    m_MonGenList: TList; //�����б�(MonGen.txt�ļ��������)
    m_MagicList: TList; //ħ���б�
    m_MapMonGenCountList: TList;
    m_AdminList: TGList; //����Ա�б�
    m_MerchantList: TGList; //NPC�б�(Merchant.txt)
    QuestNPCList: TList; //0x6C
    m_ChangeServerList: TList;//δ�����б�Add 20091109
    m_MagicEventList: TList;//ħ��Ч�������б�

    nMonsterCount: Integer; //��������
    nMonsterProcessPostion: Integer; //0x80�����������λ�ã����ڼ����������
    nMonsterProcessCount: Integer; //0x88���������������ͳ�ƴ���������
    boItemEvent: Boolean; //ItemEvent
    dwProcessMerchantTimeMin: Integer;
    dwProcessMerchantTimeMax: Integer;
    dwProcessNpcTimeMin: LongWord;
    dwProcessNpcTimeMax: LongWord;
    m_NewHumanList: TList;
    m_ListOfGateIdx: TList;
    m_ListOfSocket: TList;
    m_OldMagicList: TList;//��ħ���б�
    m_nLimitUserCount: Integer; //�����û���
    m_nLimitNumber: Integer; //����ʹ�����������
    m_boStartLoadMagic: Boolean;//���ڶ�ħ��
    m_dwSearchTick: LongWord;//����ȡ��Ȩ��ʱ����
    m_dwGetTodyDayDateTick: LongWord;
    m_TodayDate: TDate;//��������
    m_nCurrX_136: Integer; //��ʼ����X 20080124
    m_nCurrY_136: Integer; //��ʼ����Y 20080124
    m_NewCurrX_136: Integer;//��ֹ����X 20080124
    m_NewCurrY_136: Integer;//��ֹ����Y 20080124
    dwProcessMonstersTick: LongWord;
    m_dwAILogonTick: LongWord;//������˼��
    m_UserLogonList: TGStringList;//�����б�

    m_M2AutoAddPetsMon: TStringList;//M2�Զ����س�������(��NPC�����ȡ���ݵ��б�)
    m_dwM2AutoAddPetsMonTick: LongWord;//���س�����
  private
    m_nMonGenCertListPosition: Integer; //0x40
    procedure ProcessHumans();
    procedure ProcessMonsters();
    procedure ProcessMerchants();
    procedure ProcessNpcs();
    procedure ProcessEvents();
    procedure ProcessMapDoor();

    procedure NPCinitialize;
    procedure MerchantInitialize;
    function MonGetRandomItems(mon: TBaseObject): Integer;
    function RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;//�����������
    //procedure WriteShiftUserData;//δʹ�� 20080522

    function AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject;
    function AddPlayObject(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject; //��������
    function AddAIPlayObject(AI: pTAILogon): TAIPlayObject;//���Ӽ���
    //procedure GenShiftUserData();//20080522 ע��
    procedure KickOnlineUser(sChrName: string);
    function SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
    procedure SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
    procedure AddToHumanFreeList(PlayObject: TPlayObject);
    procedure GetHumData(PlayObject: TPlayObject; var HumanRcd: THumDataInfo);//ȡ��ɫ������
    procedure GetHeroData(BaseObject: TBaseObject; var HumanRcd: THumDataInfo;var NewHeroDataInfo: TNewHeroDataInfo; boDeputyHero: Boolean; nJob: Byte); //ȡӢ�۵�����

    function GetHomeInfo(var nX: Integer; var nY: Integer): string;
    function GetRandHomeX(PlayObject: TPlayObject): Integer;
    function GetRandHomeY(PlayObject: TPlayObject): Integer;
    //function GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;//20080522 ע��
    procedure LoadSwitchData(SwitchData: pTSwitchDataInfo; var PlayObject: TPlayObject);
    procedure DelSwitchData(SwitchData: pTSwitchDataInfo);
    procedure MonInitialize(BaseObject: TBaseObject; sMonName: string);
    //function MapRageHuman(sMapName: string; nMapX, nMapY, nRage: Integer): Boolean;//20090820 ע��
    function GetOnlineHumCount(): Integer;
    function GetUserCount(): Integer;
    function GetLoadPlayCount(): Integer;
    function GetAutoAddExpPlayCount: Integer;
    function GetAIPlayCount: Integer;//ȡ��������
  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize();
    //procedure ClearItemList(); virtual;//20091109 ע��
    procedure SwitchMagicList();

    procedure Run();
    procedure PrcocessData();
    procedure Execute;
    function RegenMonsterByName(sMAP: string; nX, nY: Integer; sMonName: string): TBaseObject;
    function RegenPlayByName(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject;
    {$IF HEROVERSION = 1}
    function RegenMyHero(PlayObject: TPlayObject; nX, nY: Integer; HumanRcd: THumDataInfo; NewHeroDataInfo: TNewHeroDataInfo; nType: Byte): TBaseObject;
    function AddHeroObject(PlayObject: TPlayObject; nX, nY: Integer; HumanRcd: THumDataInfo; NewHeroDataInfo: TNewHeroDataInfo; nType: Byte): TBaseObject; //����Ӣ��
    procedure SaveHeroRcd(PlayObject: TPlayObject);
    {$IFEND}
    procedure SaveHumanRcd(PlayObject: TPlayObject);

    function FindAILogon(sCharName: string): Boolean;
    procedure AddAILogon(aAI: pTAILogon); overload;
    function RegenAIObject(AI: pTAILogon): Boolean;

    function GetGenMonCount(MonGen: pTMonGenInfo): Integer;
    //procedure AddObjectToMonList(BaseObject: TBaseObject);
    {$IF M2Version <> 2}
    function GetHumTitle(nHumTitleIdx: Integer): pTHumTitleDB; overload;
    function GetHumTitle(sTitleName: string): pTHumTitleDB; overload;
    function GetHumTitleName(Anicount: Integer): String;//ȡ��ӦAnicount�ĳƺ���
    function GetHumTitleHours(nHumTitleIdx: Integer): Integer;//ȡ�ƺſ���ʱ��
    function CopyToFengHaoFromName(sFengHaoName: string; HumTitle: pTHumTitle): Boolean;
    {$IFEND}
    function GetPlayOnline(sName: string): Boolean;//�ж�����Ƿ�����
    function GetStdItem(nItemIdx: Integer): pTStdItem; overload;
    function GetStdItem(sItemName: string): pTStdItem; overload;
    function GetMakeWineStdItem(nStdMode: Byte; Anicount: Integer): pTStdItem;//(���)ͨ������Anicount�õ���Ӧ�Ƶĺ���  20080620
    function GetMakeWineStdItem1(Shape: Integer): pTStdItem;//(���)ͨ����Shape�õ���Ӧ�����ĺ���  20080621
    function GetBoxKeyItem(Anicount: Byte): pTStdItem;//ͨ�����ӵ�Anicount�õ���Ӧ��Կ�� 20090225
    function GetArmsTearStdItem(Anicount: Integer): pTStdItem;//ͨ�����������ȼ����õ���Ӧ����ʯ��Ʒ 20100708
    function GetStdItemWeight(nItemIdx: Integer): Integer;
    function GetStdItemName(nItemIdx: Integer): string;
    function GetStdItemIdx(sItemName: string): Integer;
    //function FindOtherServerUser(sName: string; var nServerIndex): Boolean;//20101022 ע��
    procedure CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY, nWide: Integer; btFColor, btBColor: Byte; sMsg: string);
    procedure ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
    //procedure SendServerGroupMsg(nCode, nServerIdx: Integer; sMsg: string);//20101022 ע��
    function GetMonRace(sMonName: string): Integer;
    //function GetMonRaceImg(sMonName: string): Integer;//20080313 ȡ�ֵ�ͼ
    //function InsMonstersList(MonGen: pTMonGenInfo; Monster: TAnimalObject): Boolean;//δʹ�ú��� 20090813
{$IF HEROVERSION = 1}
    function GetHeroObject(HeroObject: TBaseObject): TPlayObject;overload;
    function GetHeroObject(sName: string): TBaseObject;overload; //20071227 �������ֲ���Ӣ����
{$IFEND}
    function GetMasterObject(sName: string): TPlayObject;//ȡʦ���� 20080512

    function GetPlayObject(sName: string): TPlayObject; overload;
    function GetPlayObject(PlayObject: TBaseObject): TPlayObject; overload;
    function GetPlayObjectEx(sAccount, sName: string): TPlayObject;
    function GetPlayObjectExOfAutoGetExp(sAccount: string): TPlayObject;
    procedure KickPlayObjectEx(sAccount, sName: string);
    function FindMerchant(Merchant: TObject): TMerchant;
    function FindNPC(GuildOfficial: TObject): TGuildOfficial;
    //function InMerchantList(Merchant: TMerchant): Boolean;//�Ƿ��ǽ���NPC,δʹ�� 20080406
    //function InQuestNPCList(NPC: TNormNpc): Boolean;//δʹ�õĺ���  20080422
    function CopyToUserItemFromName(sItemName: string; Item: pTUserItem): Boolean;
    function GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY, nRange: Integer): Integer;
    function GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: Byte): Boolean;
    procedure AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
    procedure RandomUpgradeItem(Item: pTUserItem);//���������Ʒ
    procedure GetUnknowItemValue(Item: pTUserItem);
    function OpenDoor(Envir: TEnvirnoment; nX, nY: Integer): Boolean;
    function CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean;
    procedure SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer; wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string);
    function FindMagic(sMagicName: string): pTMagic; overload;
    function FindMagic(nMagIdx: Integer): pTMagic; overload;
    function FindHeroMagic(sMagicName: string): pTMagic; overload;
    function FindHeroMagic(nMagIdx: Integer): pTMagic; overload;
    function AddMagic(Magic: pTMagic): Boolean;
    procedure AddMerchant(Merchant: TMerchant);
    function GetMerchantList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    function GetNpcList(Envir: TEnvirnoment; nX, nY, nRange: Integer; TmpList: TList): Integer;
    //procedure ReloadMerchantList();
    procedure ReloadNpcList();
    procedure HumanExpire(sAccount: string);
    function GetMapMonster(Envir: TEnvirnoment; List: TList): Integer;
   // function IsMapRageHuman(sMapName: string; nRageX, nRageY, nRage: Integer): Boolean;//�жϹ������귶Χ���Ƿ������ 20080520
    function GetMapMonsterCount(Envir: TEnvirnoment; nX, nY, nRange:Integer; Name:string): Integer;//20081217 ����ͼָ������ָ�����ƹ�������
    function GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
    function GetMapHuman(sMapName: string): Integer;
    function GetMapRageHuman(Envir: TEnvirnoment; nRageX, nRageY, nRage: Integer; List: TList): Integer;
    procedure SendBroadCastMsg(sMsg: string; MsgType: TMsgType);
    procedure SendBroadCastMsg1(sMsg: string; MsgType: TMsgType; FColor, BColor: Byte);//��ǿ���ļ���Ϣ���ͺ���(��NPC����-SendMsgʹ��) 20081214
    procedure SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType);
    procedure SendBroadCastMsgExt1(sMsg: string; MsgType: TMsgType; FColor, BColor: Byte);
    procedure sub_4AE514(GoldChangeInfo: pTGoldChangeInfo);
    procedure ClearMonSayMsg();
    procedure SendQuestMsg(sQuestName: string);
    //procedure ClearMerchantData();//20101126 ע��
    function GetMapMonGenCount(sMapName: string): pTMapMonGenCount;
    function AddMapMonGenCount(sMapName: string; nMonGenCount: Integer): Integer;
    function ClearMonsters(sMapName: string): Boolean;

    property MonsterCount: Integer read nMonsterCount;//��������
    property OnlinePlayObject: Integer read GetOnlineHumCount;//��������
    property PlayObjectCount: Integer read GetUserCount;//������
    property AutoAddExpPlayCount: Integer read GetAutoAddExpPlayCount;//�Զ��һ�����
    property AIPlayCount: Integer read GetAIPlayCount;//ȡ��������
    property LoadPlayCount: Integer read GetLoadPlayCount;
    function GetShopStdItem(sItemName: string): pTStdItem;//20080801 ȡ������Ʒ
    function GetPetsMonObject(sName: string): TBaseObject;//20110612 �������ֲ����Ƿ���ڷ����ĳ���
    procedure MakePetsMonObject(LoadList: TStringList);//���������б����ݶ���
    function GetPlayObjectEx1(sName: string): TPlayObject;//������������

    function QueryNameInFreeList(ChrName: string): Boolean;//��ѯ���������Ƿ����ͷ��б��У�������Ƿ�����
    function sAccountIsLogined(sAccount: string): Boolean;//�Ƿ��ǵ�¼�����˺�  20090319
    function GetItemPoint(UserItem1: TUserItem; StdItem1: TStdItem; boCheckValue: Boolean): Integer;//ȡװ���ķ�ֵ 20110117
  end;
var
  g_dwEngineTick: LongWord;
  g_dwEngineRunTime: LongWord;
implementation

//{$R+}//�������Խ�� 20090811

uses IdSrvClient, Guild, ObjMon, EDcode, ObjGuard, ObjAxeMon, M2Share,
  ObjMon2, ObjPlayMon, Event, {InterMsgClient, InterServerMsg,} ObjRobot, HUtil32, svMain,//20101022 ȥ������Ԫ
  Castle, PlugIn, EDcodeUnit, Common, PlugOfEngine, IniFiles{$IF UserMode1 = 2},WinlicenseSDK{$IFEND},
  Division;
{ TUserEngine }


constructor TUserEngine.Create();
{$IF UserMode1 = 2}
var n18: Integer;
{$IFEND}
begin
  InitializeCriticalSection(m_LoadPlaySection);
  m_M2AutoAddPlay:= TStringList.Create;//M2�Զ��һ��������� 20090725
  m_M2AutoAddPetsMon:= TStringList.Create;//M2�Զ����س�������(��NPC�����ȡ���ݵ��б�)
  m_LoadPlayList := TStringList.Create;
  m_PlayObjectList := TStringList.Create;
  m_PlayObjectFreeList := TList.Create;
  m_MonObjectList := TList.Create;//�������е��ػ��� 20090111
  m_ChangeHumanDBGoldList := TList.Create;
  dwShowOnlineTick := GetTickCount;
  dwSendOnlineHumTime := GetTickCount;
  dwProcessMapDoorTick := GetTickCount;
  dwProcessMissionsTime := GetTickCount;
  dwRegenMonstersTick := GetTickCount;
  m_dwProcessLoadPlayTick := GetTickCount;
  m_nCurrMonGen := 0;
  m_nMonGenListPosition := 0;
  m_nMonGenCertListPosition := 0;
  m_nProcHumIDx := 0;
  nMerchantPosition := 0;
  nNpcPosition := 0;

{$IF UserMode1 = 1}
  m_nLimitNumber := 0;
  m_nLimitUserCount := 0;
{$ELSEIF UserMode1 = 2}
  {$I CodeReplace_Start.inc}
  case WLRegGetStatus(n18) of
    wlIsRegistered: begin//ע���
      m_nLimitNumber := 1000000;
      m_nLimitUserCount := 1000000;
    end;
    else begin
      m_nLimitNumber := 10;
      m_nLimitUserCount := 10;
    end;
  end;
  {$I CodeReplace_End.inc}
{$ELSEIF UserMode1 = 0}
  m_nLimitNumber := 1000000;//(ע��)
  m_nLimitUserCount := 1000000;//(ע��)
{$IFEND}

  StdItemList := TList.Create; //List_54
  {$IF M2Version <> 2}
  HumTitleList:= TList.Create;//�ƺ��б�(�����ݿ��е�����)
  {$IFEND}
  MonsterList := TList.Create;
  m_MonGenList := TList.Create;
  m_MagicList := TList.Create;
  m_AdminList := TGList.Create;
  m_MerchantList := TGList.Create;
  QuestNPCList := TList.Create;
  m_ChangeServerList := TList.Create;
  m_MagicEventList := TList.Create;
  m_MapMonGenCountList := TList.Create;
  boItemEvent := False;
  dwProcessMerchantTimeMin := 0;
  dwProcessMerchantTimeMax := 0;
  dwProcessNpcTimeMin := 0;
  dwProcessNpcTimeMax := 0;
  m_NewHumanList := TList.Create;
  m_ListOfGateIdx := TList.Create;
  m_ListOfSocket := TList.Create;
  m_OldMagicList := TList.Create;
  m_boStartLoadMagic := False;
  m_dwSearchTick := GetTickCount;
  m_dwGetTodyDayDateTick := GetTickCount;
  m_TodayDate := 0;
  dwProcessMonstersTick := GetTickCount;
  m_dwAILogonTick := GetTickCount;
  m_UserLogonList := TGStringList.Create;
end;

destructor TUserEngine.Destroy;
var
  I, II, III: Integer;
  MonInfo: pTMonInfo;
  MonItem: pTMonItem;
  MonGenInfo: pTMonGenInfo;
  MagicEvent: pTMagicEvent;
  TmpList: TList;
begin
  m_M2AutoAddPlay.Free;//M2�Զ��һ��������� 20090725
  m_M2AutoAddPetsMon.Free;//M2�Զ����س�������(��NPC�����ȡ���ݵ��б�)
  if m_LoadPlayList.Count > 0 then begin//20080629
    for I := 0 to m_LoadPlayList.Count - 1 do begin
      if pTUserOpenInfo(m_LoadPlayList.Objects[I]) <> nil then
        Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[I]));
    end;
  end;
  m_LoadPlayList.Free;

  for I := 0 to m_UserLogonList.Count - 1 do begin
    Dispose(pTAILogon(m_UserLogonList.Objects[I]));
  end;
  m_UserLogonList.Free;  

  if m_PlayObjectList.Count > 0 then begin//20080629
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      TPlayObject(m_PlayObjectList.Objects[I]).Free;
    end;
  end;
  m_PlayObjectList.Free;
  m_PlayObjectList := nil;

  if m_PlayObjectFreeList.Count > 0 then begin//20080629
    for I := 0 to m_PlayObjectFreeList.Count - 1 do begin
      TPlayObject(m_PlayObjectFreeList.Items[I]).Free;
    end;
  end;
  m_PlayObjectFreeList.Free;

  if m_ChangeHumanDBGoldList.Count > 0 then begin//20080629
    for I := 0 to m_ChangeHumanDBGoldList.Count - 1 do begin
      if pTGoldChangeInfo(m_ChangeHumanDBGoldList.Items[I]) <> nil then
         Dispose(pTGoldChangeInfo(m_ChangeHumanDBGoldList.Items[I]));
    end;
  end;
  m_ChangeHumanDBGoldList.Free;

  if StdItemList.Count > 0 then begin//20080629
    for I := 0 to StdItemList.Count - 1 do begin
      if pTStdItem(StdItemList.Items[I]) <> nil then
         Dispose(pTStdItem(StdItemList.Items[I]));
    end;
  end;
  StdItemList.Free;
  {$IF M2Version <> 2}
  if HumTitleList.Count > 0 then begin//�ƺ��б�(�����ݿ��е�����)
    for I := 0 to HumTitleList.Count - 1 do begin
      if pTHumTitleDB(HumTitleList.Items[I]) <> nil then
         Dispose(pTHumTitleDB(HumTitleList.Items[I]));
    end;
  end;
  HumTitleList.Free;
  {$IFEND}
  if MonsterList.Count > 0 then begin//20080629
    for I := 0 to MonsterList.Count - 1 do begin
      MonInfo := MonsterList.Items[I];
      if MonInfo.ItemList <> nil then begin
        if MonInfo.ItemList.Count > 0 then begin
          for II := 0 to MonInfo.ItemList.Count - 1 do begin
            if pTMonItem(MonInfo.ItemList.Items[II]) <> nil then begin
              if pTMonItem(MonInfo.ItemList.Items[II]).NewMonList <> nil then begin//20110225
                if pTMonItem(MonInfo.ItemList.Items[II]).NewMonList.Count > 0 then begin
                  for III := 0 to pTMonItem(MonInfo.ItemList.Items[II]).NewMonList.Count - 1 do begin
                    MonItem:= pTMonItem(pTMonItem(MonInfo.ItemList.Items[II]).NewMonList.Items[III]);
                    if MonItem <> nil then Dispose(MonItem);
                  end;
                end;
                pTMonItem(MonInfo.ItemList.Items[II]).NewMonList.Free;
              end;
              Dispose(pTMonItem(MonInfo.ItemList.Items[II]));
            end;
          end;
        end;
        MonInfo.ItemList.Free;
      end;
      Dispose(MonInfo);
    end;
  end;
  MonsterList.Free;

  if m_MonGenList.Count > 0 then begin//20080629
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGenInfo := m_MonGenList.Items[I];
      if MonGenInfo <> nil then begin
        if MonGenInfo.CertList.Count > 0 then begin//20080629
          for II := 0 to MonGenInfo.CertList.Count - 1 do begin
            if TBaseObject(MonGenInfo.CertList.Items[II]) <> nil then
              TBaseObject(MonGenInfo.CertList.Items[II]).Free;
          end;
        end;
        MonGenInfo.CertList.Free;
        Dispose(pTMonGenInfo(m_MonGenList.Items[I]));
      end;
    end;
  end;
  m_MonGenList.Free;

  if m_MagicList.Count > 0 then begin//20080629
    for I := 0 to m_MagicList.Count - 1 do begin
      if pTMagic(m_MagicList.Items[I]) <> nil then
        Dispose(pTMagic(m_MagicList.Items[I]));
    end;
  end;
  m_MagicList.Free;

  if m_AdminList.Count > 0 then begin//20080814
    for I := 0 to m_AdminList.Count - 1 do begin
      if pTAdminInfo(m_AdminList.Items[I]) <> nil then
        Dispose(pTAdminInfo(m_AdminList.Items[I]));
    end;
  end;
  m_AdminList.Free;

  if m_MerchantList.Count > 0 then begin//20080629
    for I := 0 to m_MerchantList.Count - 1 do TMerchant(m_MerchantList.Items[I]).Free;
  end;
  m_MerchantList.Free;
  if QuestNPCList.Count > 0 then begin//20080629
    for I := 0 to QuestNPCList.Count - 1 do begin
      TNormNpc(QuestNPCList.Items[I]).Free;
    end;
  end;
  QuestNPCList.Free;

  if m_ChangeServerList.Count > 0 then begin//20080629
    for I := 0 to m_ChangeServerList.Count - 1 do begin
      if pTSwitchDataInfo(m_ChangeServerList.Items[I]) <> nil then
         Dispose(pTSwitchDataInfo(m_ChangeServerList.Items[I]));
    end;
  end;
  m_ChangeServerList.Free;
  if m_MagicEventList.Count > 0 then begin//20080629
    for I := 0 to m_MagicEventList.Count - 1 do begin
      MagicEvent := m_MagicEventList.Items[I];
      if MagicEvent.BaseObjectList <> nil then MagicEvent.BaseObjectList.Free;
      Dispose(MagicEvent);
    end;
  end;
  m_MagicEventList.Free;
  m_NewHumanList.Free;
  m_ListOfGateIdx.Free;
  m_ListOfSocket.Free;
  if m_OldMagicList.Count > 0 then begin//20080629
    for I := 0 to m_OldMagicList.Count - 1 do begin
      TmpList := TList(m_OldMagicList.Items[I]);
      if TmpList.Count > 0 then begin
        for II := 0 to TmpList.Count - 1 do begin
          if pTMagic(TmpList.Items[II]) <> nil then Dispose(pTMagic(TmpList.Items[II]));
        end;
      end;
      TmpList.Free;
    end;
  end;
  m_OldMagicList.Free;

  if m_MapMonGenCountList.Count > 0 then begin//20080629
    for I := 0 to m_MapMonGenCountList.Count - 1 do begin
      if pTMapMonGenCount(m_MapMonGenCountList.Items[I]) <> nil then
         Dispose(pTMapMonGenCount(m_MapMonGenCountList.Items[I]));
    end;
  end;
  m_MapMonGenCountList.Free;

  {�� m_MonGenList �����ͷ� By TasNat at: 2012-03-07 20:38:47
  if m_MonObjectList.Count > 0 then begin//�������е��ػ��� 20090111
    for I := 0 to m_MonObjectList.Count - 1 do begin
      if TBaseObject(m_MonObjectList.Items[I]) <> nil then begin
        try
          TBaseObject(m_MonObjectList.Items[I]).Free;
        except
        end;
      end;
    end;
  end;   }
  m_MonObjectList.Free;
  DeleteCriticalSection(m_LoadPlaySection);
  inherited;
end;
//------------------------------------------------------------------------------
procedure TUserEngine.Initialize;
var
  I: Integer;
  MonGen: pTMonGenInfo;
  AutoPlay : TPlayObject;
begin
  MerchantInitialize();
  NPCinitialize();
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[I];
      if MonGen <> nil then begin
        MonGen.nRace := GetMonRace(MonGen.sMonName);
      end;
    end;
  end;
  //����������ɺ�ִ�� Startup
  AutoPlay := TPlayObject.Create;
  try
    AutoPlay.m_sCharName := 'TasNat';
    g_ManageNPC.GotoLable(AutoPlay, '@Startup', False, False);
  finally
    AutoPlay.Free;
  end;
end;

function TUserEngine.AddMapMonGenCount(sMapName: string; nMonGenCount: Integer): Integer;
var
  I: Integer;
  MapMonGenCount: pTMapMonGenCount;
  boFound: Boolean;
begin
  Result := -1;
  boFound := False;
  if m_MapMonGenCountList.Count > 0 then begin//20081008
    for I := 0 to m_MapMonGenCountList.Count - 1 do begin
      MapMonGenCount := m_MapMonGenCountList.Items[I];
      if MapMonGenCount <> nil then begin
        if CompareText(MapMonGenCount.sMapName, sMapName) = 0 then begin
          Inc(MapMonGenCount.nMonGenCount, nMonGenCount);
          Result := MapMonGenCount.nMonGenCount;
          boFound := True;
        end;
      end;
    end;//for
  end;
  if not boFound then begin
    New(MapMonGenCount);
    MapMonGenCount.sMapName := sMapName;
    MapMonGenCount.nMonGenCount := nMonGenCount;
    MapMonGenCount.dwNotHumTimeTick := GetTickCount;
    MapMonGenCount.dwMakeMonGenTimeTick := GetTickCount;
    MapMonGenCount.nClearCount := 0;
    MapMonGenCount.boNotHum := True;
    m_MapMonGenCountList.Add(MapMonGenCount);
    Result := MapMonGenCount.nMonGenCount;
  end;
end;

function TUserEngine.GetMapMonGenCount(sMapName: string): pTMapMonGenCount;
var
  I: Integer;
  MapMonGenCount: pTMapMonGenCount;
begin
  Result := nil;
  if m_MapMonGenCountList.Count > 0 then begin//20081008
    for I := 0 to m_MapMonGenCountList.Count - 1 do begin
      MapMonGenCount := m_MapMonGenCountList.Items[I];
      if MapMonGenCount <> nil then begin
        if CompareText(MapMonGenCount.sMapName, sMapName) = 0 then begin
          Result := MapMonGenCount;
          Break;
        end;
      end;
    end;
  end;
end;
//ȡ���������
function TUserEngine.GetMonRace(sMonName: string): Integer;
var
  I: Integer;
  MonInfo: pTMonInfo;
begin
  Result := -1;
  if MonsterList.Count > 0 then begin//20081008
    for I := 0 to MonsterList.Count - 1 do begin
      MonInfo := MonsterList.Items[I];
      if MonInfo <> nil then begin
        if CompareText(MonInfo.sName, sMonName) = 0 then begin
          Result := MonInfo.btRace;
          Break;
        end;
      end;
    end;
  end;
end;
{//20080313 ȡ�ֵ�����ͼ��
function TUserEngine.GetMonRaceImg(sMonName: string): Integer;
var
  I: Integer;
  MonInfo: pTMonInfo;
begin
  Result := -1;
  for I := 0 to MonsterList.Count - 1 do begin
    MonInfo := MonsterList.Items[I];
    if MonInfo <> nil then begin
      if CompareText(MonInfo.sName, sMonName) = 0 then begin
        Result := MonInfo.btRaceImg;
        Break;
      end;
    end;
  end;
end;
    if m_TargetCret <> nil then begin //20080313
      case UserEngine.GetMonRaceImg(m_sCharName) of
        70,71:begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) >= 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) >= 3) then
           SendRefMsg(RM_LIGHTING, 1 , m_nCurrX, m_nCurrY, Integer(m_TargetCret),'');
         end;
      end;
    end;
 }
//����NPC��ʼ��
procedure TUserEngine.MerchantInitialize;
var
  I, n10: Integer;
  Merchant: TMerchant;
  sCaption, sMapName: string;
begin
  sCaption := FrmMain.Caption;
  m_MerchantList.Lock;
  try
    for I := m_MerchantList.Count - 1 downto 0 do begin
      if m_MerchantList.Count <= 0 then Break;//20081008
      Merchant := TMerchant(m_MerchantList.Items[I]);
      if Merchant <> nil then begin
        n10 := GetValNameNo(Merchant.m_sMapName); //֧��NPC��ͼ֧��A���� 20110924
        if (n10 > 699) then begin
          case n10 of
            700..799: sMapName := g_Config.GlobalAVal[n10 - 700];//A����1..99
            1200..2099:sMapName := g_Config.GlobalAVal[n10 - 1100];//A����(100-999)
            else sMapName:= Merchant.m_sMapName;
          end;
          if sMapName = '' then sMapName:= Merchant.m_sMapName;
        end else sMapName:= Merchant.m_sMapName;

        Merchant.m_PEnvir := g_MapManager.FindMap({Merchant.m_sMapName}sMapName);
        if Merchant.m_PEnvir <> nil then begin
          Merchant.Initialize;
          if Merchant.m_boAddtoMapSuccess and (not Merchant.m_boIsHide) then begin
            MainOutMessage(Format('����NPC ��ʼ��ʧ��...%s %s(%d:%d)', [Merchant.m_sCharName, Merchant.m_sMapName, Merchant.m_nCurrX, Merchant.m_nCurrY]));
            m_MerchantList.Delete(I);
            Merchant.Free;
          end else begin
            Merchant.LoadNpcScript();
            Merchant.LoadNPCData();
          end;
        end else begin
          MainOutMessage(Merchant.m_sCharName + '����NPC ��ʼ��ʧ��... (���ڵ�ͼ������)');
          m_MerchantList.Delete(I);
          Merchant.Free;
        end;
        FrmMain.Caption := sCaption + '[���ڳ�ʼ����NPC(' + IntToStr(m_MerchantList.Count) + '/' + IntToStr(m_MerchantList.Count - I) + ')]';
        //Application.ProcessMessages;
        Sleep(1);//20091103 ����
      end;
    end;//for
  finally
    m_MerchantList.UnLock;
  end;
end;

procedure TUserEngine.NPCinitialize;
var
  I: Integer;
  NormNpc: TNormNpc;
begin
  for I := QuestNPCList.Count - 1 downto 0 do begin
    if QuestNPCList.Count <= 0 then Break;
    NormNpc := TNormNpc(QuestNPCList.Items[I]);
    if NormNpc <> nil then begin
      NormNpc.m_PEnvir := g_MapManager.FindMap(NormNpc.m_sMapName);
      if NormNpc.m_PEnvir <> nil then begin
        NormNpc.Initialize;
        if NormNpc.m_boAddtoMapSuccess and (not NormNpc.m_boIsHide) then begin
          MainOutMessage(NormNpc.m_sCharName + ' Npc ��ʼ��ʧ��... ');
          QuestNPCList.Delete(I);
          NormNpc.Free;
        end else begin
          NormNpc.LoadNpcScript();
        end;
      end else begin
        MainOutMessage(NormNpc.m_sCharName + ' Npc ��ʼ��ʧ��... (npc.PEnvir=nil) ');
        QuestNPCList.Delete(I);
        NormNpc.Free;
      end;
    end;
  end;
end;

function TUserEngine.GetLoadPlayCount: Integer;
begin
  Result := m_LoadPlayList.Count;
end;

function TUserEngine.GetOnlineHumCount: Integer;
begin
  Result := m_PlayObjectList.Count;
end;
//ȡ�������
function TUserEngine.GetUserCount: Integer;
begin
  try
  Result := m_PlayObjectList.Count;
  except
    Result := MaxInt;
  end;
end;
//ȡ�Զ��һ���������
function TUserEngine.GetAutoAddExpPlayCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if m_PlayObjectList.Count > 0 then begin
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        if TPlayObject(m_PlayObjectList.Objects[I]).m_boNotOnlineAddExp then Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
//ȡ��������
function TUserEngine.GetAIPlayCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if m_PlayObjectList.Count > 0 then begin
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        if TPlayObject(m_PlayObjectList.Objects[I]).m_boAI then Inc(Result);
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

//���ﴦ�����
procedure TUserEngine.ProcessHumans;

  function M2AutoAddExpPlay(LoadList: TStringList): Boolean;//M2�Զ�����һ�
  var
    I: Integer;
    s10, sHumName, sAcount: string;
  begin
    Result := False;
    if LoadList.Count > 0 then begin
      for I := LoadList.Count - 1 downto 0 do begin
        if (m_PlayObjectList.Count < m_nLimitUserCount) then begin
          s10 := LoadList.Strings[I];
          if (s10 <> '') then begin
            s10 := GetValidStr3(s10, sHumName, [' ', #9]);
            s10 := GetValidStr3(s10, sAcount, [' ', #9]);
            if (sHumName <> '') and (sAcount <> '') then begin
              try
                if not sAccountIsLogined(sAcount) then begin
                  FrontEngine.AddToLoadRcdList(sAcount{�˺�}, sHumName{��ɫ��}, '127.0.0.1'{IP��ַ},
                    True, 0{nSessionID �ỰID}, $110, 3{2}{nPayMent}, 5{2}{nPayMode},
                    990080512{CLIENT_VERSION_NUMBER�ͻ��˰汾��},
                    1{nSocket}, 0{GateUser.nGSocketIdx}, 0{GateIdx},True,0);
                end;
              except
              end;
              LoadList.Delete(I);
              Break;
            end;
          end;
        end else begin
          LoadList.Clear;
          Break;
        end;
      end;
      Result := True;
    end;
  end;

  function IsLogined(sAccount, sChrName: string): Boolean;//�Ƿ��ǵ�¼�����˺�
  var
    I: Integer;
  begin
    Result := False;
    if FrontEngine.InSaveRcdList(sAccount, sChrName) then begin
      Result := True;
    end else begin
      if m_PlayObjectList.Count > 0 then begin//20081008
        for I := 0 to m_PlayObjectList.Count - 1 do begin                                    //20091221 �˺�һ��������һ�����ܵ�¼
          if (CompareText(TPlayObject(m_PlayObjectList.Objects[I]).m_sUserID, sAccount) = 0) or{and  //20090827 ע�ͣ��˺�һ�����ܵ�½}
            (CompareText(m_PlayObjectList.Strings[I], sChrName) = 0) then begin
            Result := True;
            Break;
          end;
        end;//for
      end;
    end;
  end;

  function MakeNewHuman(UserOpenInfo: pTUserOpenInfo): TPlayObject; //�����µ�����
  var
    PlayObject: TPlayObject;
    Abil: pTAbility;
    Envir: TEnvirnoment;
    nC: Integer;
    SwitchDataInfo: pTSwitchDataInfo;
    Castle, Castle1: TUserCastle;
  label
    ReGetMap;
  begin
    Result := nil;
    try
      PlayObject := TPlayObject.Create;
     { if not g_Config.boVentureServer then begin //δʹ�� 20080408
        UserOpenInfo.sChrName := '';
        UserOpenInfo.LoadUser.nSessionID := 0;
        SwitchDataInfo := GetSwitchData(UserOpenInfo.sChrName, UserOpenInfo.LoadUser.nSessionID);
      end else SwitchDataInfo := nil;  }

      SwitchDataInfo := nil;

      if SwitchDataInfo = nil then begin
        GetHumData(PlayObject, UserOpenInfo.HumanRcd);
        PlayObject.m_btRaceServer := RC_PLAYOBJECT;
        if PlayObject.m_sHomeMap = '' then begin
          ReGetMap:
          PlayObject.m_sHomeMap := GetHomeInfo(PlayObject.m_nHomeX, PlayObject.m_nHomeY);
          PlayObject.m_sMapName := PlayObject.m_sHomeMap;
          PlayObject.m_nCurrX := GetRandHomeX(PlayObject);
          PlayObject.m_nCurrY := GetRandHomeY(PlayObject);
          if PlayObject.m_Abil.Level >= 0 then begin
            Abil := @PlayObject.m_Abil;
            Abil.Level := 1;
            Abil.AC := 0;
            Abil.MAC := 0;
            Abil.DC := MakeLong(1, 2);
            Abil.MC := MakeLong(1, 2);
            Abil.SC := MakeLong(1, 2);
            Abil.MP := 15;
            Abil.HP := 15;
            Abil.MaxHP := 15;
            Abil.MaxMP := 15;
            Abil.nExp := 0;
            Abil.nMaxExp := 100;
            Abil.Weight := 100;
            Abil.MaxWeight := 100;
            PlayObject.m_boNewHuman := True;
          end;
        end;
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir <> nil then begin
          if Envir.m_boFight3Zone then begin //�Ƿ����л�ս����ͼ����
            if (PlayObject.m_Abil.HP <= 0) and (PlayObject.m_nFightZoneDieCount < 3) then begin
              PlayObject.m_Abil.HP := PlayObject.m_Abil.MaxHP;
              PlayObject.m_Abil.MP := PlayObject.m_Abil.MaxMP;
              PlayObject.m_boDieInFight3Zone := True;
            end else PlayObject.m_nFightZoneDieCount := 0;
          end;
        end;

        PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);//ȡ����������л�
        Castle := g_CastleManager.InCastleWarArea(Envir, PlayObject.m_nCurrX, PlayObject.m_nCurrY);
        {$IF M2Version <> 2}
        PlayObject.m_MyDivision := g_DivisionManager.MemberOfDivision(PlayObject.m_sCharName);//ȡ���������ʦ��
        if PlayObject.m_MyDivision <> nil then begin
          {if CompareText(TDivision(PlayObject.m_MyDivision).GetChiefName, PlayObject.m_sCharName) = 0 then
            PlayObject.m_sHeartName:= TDivision(PlayObject.m_MyDivision).sHeartName//�ķ�����
          else PlayObject.m_sHeartName:= '����'+TDivision(PlayObject.m_MyDivision).sHeartName;}
          PlayObject.m_nHeartType:= TDivision(PlayObject.m_MyDivision).nHeartTpye;//�ķ�����
          PlayObject.m_Contribution:= TDivision(PlayObject.m_MyDivision).GetMemberContribution(PlayObject.m_sCharName);//����ֵ
        end;
        {$IFEND}
        if (Envir <> nil) and (Castle <> nil) and ((Castle.m_MapPalace = Envir) or Castle.m_boUnderWar) then begin
          Castle1 := g_CastleManager.IsCastleMember(PlayObject);

          //if not UserCastle.IsMember(PlayObject) then begin
          if Castle1 = nil then begin//�����ڼ䣬���� 20090527 �޸�
            if Castle.m_boUnderWar then begin
              PlayObject.m_sMapName := Castle.GetWarAreaHomeName;
              PlayObject.m_nCurrX := Castle.GetWarAreaHomeX;
              PlayObject.m_nCurrY := Castle.GetWarAreaHomeY;
            end else begin
              PlayObject.m_sMapName := PlayObject.m_sHomeMap;
              PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
              PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
            end;
          end else begin//�����ڼ䣬�ط�
            if Castle1.m_MapPalace = Envir then begin
              PlayObject.m_sMapName := Castle1.GetMapName();
              PlayObject.m_nCurrX := Castle1.GetHomeX;
              PlayObject.m_nCurrY := Castle1.GetHomeY;
            end;
          end;
        end;

        if g_MapManager.FindMap(PlayObject.m_sMapName) = nil then PlayObject.m_Abil.HP := 0;//���ҵ�ͼ�������ڣ�������HPΪ0
        if PlayObject.m_Abil.HP <= 0 then begin
          PlayObject.ClearStatusTime();
          if PlayObject.PKLevel < 2 then begin//û�к���
            Castle := g_CastleManager.IsCastleMember(PlayObject);
            // if UserCastle.m_boUnderWar and (UserCastle.IsMember(PlayObject)) then begin
            if (Castle <> nil) and Castle.m_boUnderWar then begin//�Ƿ����ڹ���,�ط�
              PlayObject.m_sMapName := Castle.m_sHomeMap;
              PlayObject.m_nCurrX := Castle.GetHomeX;
              PlayObject.m_nCurrY := Castle.GetHomeY;
            end else begin//���������س�
              PlayObject.m_sMapName := PlayObject.m_sHomeMap;
              PlayObject.m_nCurrX := PlayObject.m_nHomeX - 2 + Random(5);
              PlayObject.m_nCurrY := PlayObject.m_nHomeY - 2 + Random(5);
            end;
          end else begin
            PlayObject.m_sMapName := g_Config.sRedDieHomeMap {'3'};
            PlayObject.m_nCurrX := Random(13) + g_Config.nRedDieHomeX {839};
            PlayObject.m_nCurrY := Random(13) + g_Config.nRedDieHomeY {668};
          end;
          PlayObject.m_Abil.HP := 14;
        end;

        PlayObject.AbilCopyToWAbil();
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir = nil then begin
          PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
          PlayObject.m_nRandomKey:= UserOpenInfo.LoadUser.wRandomKey;//��̬��Կ 20091026
          PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
          PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
          PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
          PlayObject.m_WAbil := PlayObject.m_Abil;
          PlayObject.m_nServerIndex := g_MapManager.GetMapOfServerIndex(PlayObject.m_sMapName);
          SendSwitchData(PlayObject, PlayObject.m_nServerIndex);
          SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
          //PlayObject.Free;
          FreeAndNil(PlayObject);
          Exit;
        end;
        nC := 0;
        while (True) do begin
          try//20101126 ����,��ֹ�쳣��,��ѭ��
            if Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then Break;
            PlayObject.m_nCurrX := PlayObject.m_nCurrX - 3 + Random(6);
            PlayObject.m_nCurrY := PlayObject.m_nCurrY - 3 + Random(6);
          except
          end;
          Inc(nC);
          if nC >= 5 then Break;
        end;

        if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then begin
          PlayObject.m_sMapName := g_Config.sHomeMap;
          Envir := g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX := g_Config.nHomeX;
          PlayObject.m_nCurrY := g_Config.nHomeY;
        end;

        PlayObject.m_PEnvir := Envir;
        if PlayObject.m_PEnvir = nil then begin
          MainOutMessage('[����] PlayObject.PEnvir = nil');
          goto ReGetMap;
        end else begin
          PlayObject.m_boReadyRun := False;
        end;
      end else begin
        GetHumData(PlayObject, UserOpenInfo.HumanRcd);
        PlayObject.m_sMapName := SwitchDataInfo.sMAP;
        PlayObject.m_nCurrX := SwitchDataInfo.wX;
        PlayObject.m_nCurrY := SwitchDataInfo.wY;
        PlayObject.m_Abil := SwitchDataInfo.Abil;
        PlayObject.m_WAbil := SwitchDataInfo.Abil;
        LoadSwitchData(SwitchDataInfo, PlayObject);
        DelSwitchData(SwitchDataInfo);
        Envir := g_MapManager.GetMapInfo(nServerIndex, PlayObject.m_sMapName);
        if Envir <> nil then begin
          PlayObject.m_sMapName := g_Config.sHomeMap;
          //Envir := g_MapManager.FindMap(g_Config.sHomeMap); //20080408 û��ʹ��
          PlayObject.m_nCurrX := g_Config.nHomeX;
          PlayObject.m_nCurrY := g_Config.nHomeY;
        end else begin
          if not Envir.CanWalk(PlayObject.m_nCurrX, PlayObject.m_nCurrY, True) then begin
            PlayObject.m_sMapName := g_Config.sHomeMap;
            Envir := g_MapManager.FindMap(g_Config.sHomeMap);
            PlayObject.m_nCurrX := g_Config.nHomeX;
            PlayObject.m_nCurrY := g_Config.nHomeY;
          end;
          PlayObject.AbilCopyToWAbil();
          PlayObject.m_PEnvir := Envir;
          if PlayObject.m_PEnvir = nil then begin
            MainOutMessage('[����] PlayObject.PEnvir = nil');
            goto ReGetMap;
          end else begin
            PlayObject.m_boReadyRun := False;
            PlayObject.m_boLoginNoticeOK := True;
            PlayObject.bo6AB := True;
          end;
        end;
      end;
      PlayObject.m_sUserID := UserOpenInfo.LoadUser.sAccount;
      PlayObject.m_sIPaddr := UserOpenInfo.LoadUser.sIPaddr;
      PlayObject.m_dwHCode := UserOpenInfo.LoadUser.dwHCode;
      PlayObject.m_sIPLocal := GetIPLocal(PlayObject.m_sIPaddr);
      PlayObject.m_nSocket := UserOpenInfo.LoadUser.nSocket;
      PlayObject.m_nGSocketIdx := UserOpenInfo.LoadUser.nGSocketIdx;
      PlayObject.m_nGateIdx := UserOpenInfo.LoadUser.nGateIdx;
      PlayObject.m_nSessionID := UserOpenInfo.LoadUser.nSessionID;
      PlayObject.m_nPayMent := UserOpenInfo.LoadUser.nPayMent;//
      PlayObject.m_nPayMode := UserOpenInfo.LoadUser.nPayMode;
      if UserOpenInfo.LoadUser.M2isCreate then begin//20090318 �Ƿ�M2ֱ�Ӵ���
        PlayObject.m_boLoginNoticeOK:=True;
        PlayObject.m_M2AutoCreate := True;
      end;
      PlayObject.m_nRandomKey:= UserOpenInfo.LoadUser.wRandomKey;//��̬��Կ 20091026

      //PlayObject.m_dwLoadTick := UserOpenInfo.LoadUser.dwNewUserTick; //δʹ�� 20080329
      PlayObject.m_nSoftVersionDateEx := GetExVersionNO(UserOpenInfo.LoadUser.nSoftVersionDate, PlayObject.m_nSoftVersionDate);
      Result := PlayObject;
    except
      MainOutMessage(Format('{%s} TUserEngine::MakeNewHuman',[g_sExceptionVer]));
    end;
  end;
//type //20080815 ע��
//  TGetLicense = function(var nProVersion: Integer; var UserLicense: Integer; var ErrorCode: Integer): Integer; stdcall;
var
  dwUsrRotTime: LongWord;
  dwCheckTime: LongWord;
  dwCurTick: LongWord;
  nCheck30: Byte;
  boCheckTimeLimit: Boolean;
  nIdx: Integer;
  PlayObject: TPlayObject;
  I, K: Integer;
  UserOpenInfo: pTUserOpenInfo;
  GoldChangeInfo: pTGoldChangeInfo;
  LineNoticeMsg: string;
  AI: pTAILogon;
  //THeroDataInfo:pTHeroDataInfo;
(*nM2Crc: Integer;
  m_nUserLicense: Integer;//ʹ�������
  m_nCheckServerCode: Integer;//������������
  m_nErrorCode: Integer;
  m_nProVersion: Integer;
  sUserKey: string;
  sCheckCode: string;*)
begin
  nCheck30 := 0;
  dwCheckTime := GetTickCount();
  if (GetTickCount - m_dwProcessLoadPlayTick) > 200 then begin
    nCheck30 := 21;
    m_dwProcessLoadPlayTick := GetTickCount();
    try
      EnterCriticalSection(m_LoadPlaySection);
      try
        if m_M2AutoAddPlay.Count > 0 then begin
          if (GetTickCount - m_dwM2AutoAddPlayTick > 3000{500}) and (not FrontEngine.IsFull) then begin//20110612 �޸�
            m_dwM2AutoAddPlayTick:= GetTickCount();
            M2AutoAddExpPlay(m_M2AutoAddPlay);//M2�Զ��һ������б� 20090725
          end;
        end;
        if m_LoadPlayList.Count > 0 then begin//20081008
          for I := 0 to m_LoadPlayList.Count - 1 do begin
            nCheck30 := 22;
            UserOpenInfo := pTUserOpenInfo(m_LoadPlayList.Objects[I]);
            if not UserOpenInfo.LoadUser.boIsHero then begin
              nCheck30 := 23;
              if not FrontEngine.IsFull and not IsLogined(UserOpenInfo.sAccount, m_LoadPlayList.Strings[I]) then begin
                nCheck30 := 24;
                PlayObject := MakeNewHuman(UserOpenInfo);//�����µ�����
                if PlayObject <> nil then begin
                  if PlayObject.m_btJob < 3 then begin//���ְҵ�Ƿ�Ϸ� 20100126
                    nCheck30 := 25;
                    PlayObject.m_boClientFlag := UserOpenInfo.LoadUser.boClinetFlag; //���ͻ��˱�־��������������
                    m_PlayObjectList.AddObject(m_LoadPlayList.Strings[I], PlayObject);
                    //SendServerGroupMsg(SS_201, nServerIndex, PlayObject.m_sCharName); //20101022 ע��
                    nCheck30 := 26;
                    m_NewHumanList.Add(PlayObject);
                  end else begin
                    AddToHumanFreeList(PlayObject);
                    //��ֹ��д���� By TasNat at: 2012-05-19 23:05:01
                    if (g_HighLevelHuman = PlayObject) then g_HighLevelHuman := nil;
                    if (g_HighPKPointHuman = PlayObject) then g_HighPKPointHuman := nil;
                    if (g_HighDCHuman = PlayObject) then g_HighDCHuman := nil;
                    if (g_HighMCHuman = PlayObject) then g_HighMCHuman := nil;
                    if (g_HighSCHuman = PlayObject) then g_HighSCHuman := nil;
                    if (g_HighOnlineHuman = PlayObject) then g_HighOnlineHuman := nil;
                  end;
                end;
              end else begin
                nCheck30 := 27;
                KickOnlineUser(m_LoadPlayList.Strings[I]);///�߳���������
                m_ListOfGateIdx.Add(Pointer(UserOpenInfo.LoadUser.nGateIdx));
                m_ListOfSocket.Add(Pointer(UserOpenInfo.LoadUser.nSocket));
              end;
            end else begin
  {$IF HEROVERSION = 1}
              nCheck30 := 28;
              if UserOpenInfo.LoadUser.PlayObject <> nil then begin //��ʼ�ٻ�Ӣ��
                if g_Config.boUseCanHero then begin//����Ӣ��ϵͳ 20100529
                  PlayObject := GetPlayObject(TBaseObject(UserOpenInfo.LoadUser.PlayObject));
                  nCheck30 := 29;
                  if PlayObject <> nil then begin
                    case UserOpenInfo.LoadUser.btLoadDBType of
                      5: begin//�����ٻ�Ӣ��
                          PlayObject.m_MyHero := PlayObject.MakeHero(PlayObject, UserOpenInfo.HumanRcd, UserOpenInfo.NewHeroDataInfo, UserOpenInfo.LoadUser.nJob);
                          if PlayObject.m_MyHero <> nil then begin
                            THeroObject(PlayObject.m_MyHero).Login;//Ӣ�۵�¼
                            PlayObject.m_MyHero.m_btAttatckMode:= PlayObject.m_btAttatckMode;//�����˵Ĺ���ģʽһ�£�����������������������Ŀ�� 20090113
                            THeroObject(PlayObject.m_MyHero).m_nKillMonExpRate:= PlayObject.m_nKillMonExpRate;//���鱶��������һ�� 20100520
                            THeroObject(PlayObject.m_MyHero).m_nOldKillMonExpRate:= THeroObject(PlayObject.m_MyHero).m_nKillMonExpRate;//20100520
                            PlayObject.m_MyHero.SendRefMsg(RM_CREATEHERO, PlayObject.m_MyHero.m_btDirection, PlayObject.m_MyHero.m_nCurrX, PlayObject.m_MyHero.m_nCurrY, 0, ''); //ˢ�¿ͻ��ˣ�����Ӣ����Ϣ
                          end;
                        end;
                      0: begin //�ٻ�
                          nCheck30 := 30;
                          if UserOpenInfo.nOpenStatus = 1 then begin
                            PlayObject.m_MyHero := PlayObject.MakeHero(PlayObject, UserOpenInfo.HumanRcd, UserOpenInfo.NewHeroDataInfo, UserOpenInfo.LoadUser.nJob);
                            if PlayObject.m_MyHero <> nil then begin
                              if PlayObject.m_MyHero.m_btJob < 3 then begin//���ְҵ�Ƿ�Ϸ� 20100126
                                nCheck30 := 31;
                                THeroObject(PlayObject.m_MyHero).Login;//Ӣ�۵�¼
                                PlayObject.m_MyHero.m_btAttatckMode:= PlayObject.m_btAttatckMode;//�����˵Ĺ���ģʽһ�£�����������������������Ŀ�� 20090113
                                THeroObject(PlayObject.m_MyHero).m_nKillMonExpRate:= PlayObject.m_nKillMonExpRate;//���鱶��������һ�� 20100520
                                THeroObject(PlayObject.m_MyHero).m_nOldKillMonExpRate:= THeroObject(PlayObject.m_MyHero).m_nKillMonExpRate;//20100520
                                PlayObject.m_MyHero.SendRefMsg(RM_CREATEHERO, PlayObject.m_MyHero.m_btDirection, PlayObject.m_MyHero.m_nCurrX, PlayObject.m_MyHero.m_nCurrY, 0, ''); //ˢ�¿ͻ��ˣ�����Ӣ����Ϣ
                                if PlayObject.m_sDeputyHeroName <> '' then begin//������������Ӣ�����¼��ӦӢ�۵ȼ����ڹ��ȼ�
                                  if PlayObject.m_boCallDeputyHero then begin//����
                                    if PlayObject.m_MyHero.m_btJob <> 1 then PlayObject.m_MyHero.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//�Ƿ�ʦ���������ħ����ֹͣ
                                    THeroObject(PlayObject.m_MyHero).n_HeroTpye:= 3;
                                    PlayObject.m_nHeroLevel2:= PlayObject.m_MyHero.m_Abil.Level;//����Ӣ�۵ȼ�
                                    PlayObject.m_nHeroNGLevel2:= THeroObject(PlayObject.m_MyHero).m_NGLevel;//����Ӣ���ڹ��ȼ�
                                    PlayObject.m_boHeroAutoPractice:= False;
                                    if (PlayObject.m_HeroAutoPracticeTime > 0) then begin//����Ӣ���Զ�����ֹͣ
                                      PlayObject.m_boHeroAutoPractice:= False;
                                      case PlayObject.m_nHeroAutoPracticePlace of//��������
                                        0: begin
                                          case PlayObject.m_nHeroAutoPracticeStrength of//ǿ��
                                            0: begin
                                              Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength1Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                              Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength1Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            end;
                                            1: begin
                                              Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength2Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                              Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength2Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            end;
                                            2: begin
                                              Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength3Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                              Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength3Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            end;
                                          end;
                                        end;
                                        1: begin
                                          case PlayObject.m_nHeroAutoPracticeStrength of//ǿ��
                                            0: Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength1Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            1: Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength2Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            2: Inc(PlayObject.m_nMainExp, (PlayObject.m_nHeroLevel2 div 7 + g_Config.nStrength3Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                          end;
                                        end;
                                        2: begin
                                          case PlayObject.m_nHeroAutoPracticeStrength of//ǿ��
                                            0: Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength1Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            1: Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength2Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                            2: Inc(PlayObject.m_nMainNGExp, (PlayObject.m_nHeroNGLevel2 div 7 + g_Config.nStrength3Exp) * PlayObject.m_HeroAutoPracticeTime);//ʱ��*(����ֵ+�ȼ�)
                                          end;
                                        end;
                                      end;
                                      PlayObject.m_HeroAutoPracticeTime:= 0;
                                      PlayObject.m_nHeroAutoPracticePlace:= 0;
                                      PlayObject.m_nHeroAutoPracticeStrength:= 0;
                                      PlayObject.SysMsg('���ĸ���Ӣ�۷����ѽ�����', c_Blue, t_Hint);
                                    end;
                                    if PlayObject.m_boMainHeroDie and (GetTickCount()- PlayObject.m_boMainHeroDieTick < 60000) then begin//��������,��ָ��ʱ�����ٻ�������������븴��ģʽ
                                      PlayObject.SendMsg(PlayObject, RM_MOVEMESSAGE1, 2{����ʱ��Ϣ}, 251, 0, 1, '');//�رտͻ�����ʾ����ʱ
                                      THeroObject(PlayObject.m_MyHero).m_boRevengeMode:= True;//��������ģʽ
                                      for K := 0 to 6 do begin//������ģʽ����״̬
                                        case K of
                                          0: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(PlayObject.m_MyHero.m_WAbil.MaxHP * 0.5);//HP
                                          1: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(PlayObject.m_MyHero.m_WAbil.MaxMP * 0.5);//MP
                                          2: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(HiWord(PlayObject.m_MyHero.m_WAbil.AC) * 0.5);//AC
                                          3: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(HiWord(PlayObject.m_MyHero.m_WAbil.MAC) * 0.5);//MAC
                                          4: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(HiWord(PlayObject.m_MyHero.m_WAbil.DC) * 0.2);//DC
                                          5: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(HiWord(PlayObject.m_MyHero.m_WAbil.MC) * 0.2);//MC
                                          6: THeroObject(PlayObject.m_MyHero).m_wSnapArrValue[K]:= Round(HiWord(PlayObject.m_MyHero.m_WAbil.SC) * 0.2);//SC
                                        end;
                                        THeroObject(PlayObject.m_MyHero).m_dwSnapArrTimeOutTick[K]:= GetTickCount() + 180000;//3����
                                      end;
                                      THeroObject(PlayObject.m_MyHero).RecalcAbilitys();
                                      THeroObject(PlayObject.m_MyHero).CompareSuitItem(False);
                                      THeroObject(PlayObject.m_MyHero).SendMsg(PlayObject.m_MyHero, RM_HEROABILITY, 0, 0, 0, 0, '');
                                    end;
                                    PlayObject.m_boMainHeroDie:= False;
                                  end else begin
                                    PlayObject.m_boMainHeroDie:= False;
                                    THeroObject(PlayObject.m_MyHero).n_HeroTpye:= 2;
                                    PlayObject.m_nHeroLevel1:= PlayObject.m_MyHero.m_Abil.Level;//����Ӣ�۵ȼ�
                                    PlayObject.m_nHeroNGLevel1:= THeroObject(PlayObject.m_MyHero).m_NGLevel;//����Ӣ���ڹ��ȼ�
                                  end;
                                end;
                                case THeroObject(PlayObject.m_MyHero).n_HeroTpye of //20091102
                                  0: PlayObject.SendMsg(PlayObject, RM_RECALLHERO, 0, Integer(PlayObject.m_MyHero), 0, 0, '��');
                                  1: PlayObject.SendMsg(PlayObject, RM_RECALLHERO, 0, Integer(PlayObject.m_MyHero), 0, 0, '��');
                                  2: PlayObject.SendMsg(PlayObject, RM_RECALLHERO, 0, Integer(PlayObject.m_MyHero), 0, 0, '��');
                                  3: PlayObject.SendMsg(PlayObject, RM_RECALLHERO, 0, Integer(PlayObject.m_MyHero), 0, 0, '��');
                                end;
                                with THeroObject(PlayObject.m_MyHero) do begin//20090925 �޸�
                                  PlayObject.n_myHeroTpye:= n_HeroTpye;//20080515 Ӣ�۵�����
                                  case m_btStatus of
                                    1: SysMsg( g_sHeroFollow, c_Green, t_Hint);
                                    0: SysMsg( g_sHeroAttack, c_Green, t_Hint);
                                    2: SysMsg( g_sHeroRest, c_Green, t_Hint);
                                  end;
                                  SysMsg(g_sHeroLoginMsg, c_Green, t_Hint);
                                  if PlayObject.m_boCallDeputyHero then begin
                                    if (m_Abil.Level < g_Config.nLimitExpLevelHero) then GetExp(PlayObject.m_nMainExp, 0);
                                    PlayObject.m_nMainExp:= 0;
                                  end;
                                  {$IF M2Version <> 2}
                                  if m_boTrainingNG then begin//ѧ���ڹ�
                                    m_MaxExpSkill69:= GetSkill69Exp(m_NGLevel, m_Skill69MaxNH);//��¼����ȡ�ڹ��ķ��������� 20081002
                                    SendMsg(PlayObject.m_MyHero, RM_HEROMAGIC69SKILLEXP, 0, 0, 0, m_NGLevel, EncodeString(Inttostr(m_ExpSkill69)+'/'+Inttostr(m_MaxExpSkill69)));
                                    SendMsg(PlayObject.m_MyHero, RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, ''); //����ֵ�ñ��˿��� 20081002
                                    SendNGResume();//�����ڹ����⣬�˺����ָ��ٶ����� 20090812
                                    {$IF M2Version = 1}
                                    SendUserPulseArr;//��½ʱ������Ѩ����
                                    if m_boUser4BatterSkill then SendMsg(PlayObject.m_MyHero, RM_OPEN4BATTERSKILL, 0, 1, 0, 0, '');//���������������� 20100720
                                    {$IFEND}
                                    if PlayObject.m_boCallDeputyHero then begin
                                      GetNGExp(PlayObject.m_nMainNGExp, 1);
                                      PlayObject.m_nMainNGExp:= 0;
                                    end;
                                  end;
                                  {$IFEND}
                                end;
                              end else begin//�Ƿ�ְҵ��ֱ��HPΪ0
                                PlayObject.m_MyHero.m_WAbil.HP:= 0;
                              end;
                            end;
                          end;
                        end;
                      1: begin //�½�
                          nCheck30 := 32;
                          case UserOpenInfo.nOpenStatus of
                            1: begin
                                case PlayObject.n_tempHeroTpye of//20080519
                                  0:PlayObject.m_boHasHero := True;
                                  1:PlayObject.m_boHasHeroTwo:= True;
                                end;
                                if g_FunctionNPC <> nil then begin
                                  g_FunctionNPC.GotoLable(PlayObject, '@CreateHeroOK', False, False);
                                end;
                              end;
                            2: begin
                                case PlayObject.n_tempHeroTpye of//20080519
                                  0:PlayObject.m_boHasHero := False;
                                  1:PlayObject.m_boHasHeroTwo:= False;
                                end;
                                PlayObject.m_sHeroCharName := '';
                                if g_FunctionNPC <> nil then begin
                                  g_FunctionNPC.GotoLable(PlayObject, '@HeroNameExists', False, False);
                                end;
                              end;
                            3: begin
                                case PlayObject.n_tempHeroTpye of//20080519
                                  0:PlayObject.m_boHasHero := False;
                                  1:PlayObject.m_boHasHeroTwo:= False;
                                end;
                                PlayObject.m_sHeroCharName := '';
                                if g_FunctionNPC <> nil then begin
                                  g_FunctionNPC.GotoLable(PlayObject, '@HeroOverChrCount', False, False);
                                end;
                              end;
                          else begin
                              nCheck30 := 33;
                              case PlayObject.n_tempHeroTpye of//20080519
                                0:PlayObject.m_boHasHero := False;
                                1:PlayObject.m_boHasHeroTwo:= False;
                              end;
                              PlayObject.m_sHeroCharName := '';
                              if g_FunctionNPC <> nil then begin
                                g_FunctionNPC.GotoLable(PlayObject, '@CreateHeroFail', False, False);
                              end;
                            end;
                          end;
                        end;
                      2: begin //ɾ��Ӣ��
                          nCheck30 := 34;
                          if UserOpenInfo.nOpenStatus = 1 then begin
                            case PlayObject.n_myHeroTpye of//20080519
                              0: begin
                                PlayObject.m_boHasHero := False;
                              end;
                              1: begin
                                PlayObject.m_boHasHeroTwo:= False;
                              end;
                            end;
                            PlayObject.m_sHeroCharName := '';
                            PlayObject.n_myHeroTpye:= 3;//Ӣ�۵����� 20080515
                            if g_FunctionNPC <> nil then begin
                              g_FunctionNPC.GotoLable(PlayObject, '@DeleteHeroOK', False, False);
                            end;
                          end else begin
                            if g_FunctionNPC <> nil then begin
                              g_FunctionNPC.GotoLable(PlayObject, '@DeleteHeroFail', False, False);
                            end;
                          end;
                        end;
                      3: begin//��ѯӢ���������
                         nCheck30 := 35;
                         if UserOpenInfo.LoadUser.sMsg <> '' then begin
                           PlayObject.SendMsg(PlayObject, RM_GETHEROINFO, 0, 0, 0, 0, UserOpenInfo.LoadUser.sMsg);
                         end;
                       end;
                      4: begin//����������Ӣ��
                         nCheck30 := 49;
                         if UserOpenInfo.LoadUser.sMsg <> '' then begin
                           PlayObject.SendMsg(PlayObject, RM_ASSESSMENTHEROINFO, 0, 0, 0, 0, UserOpenInfo.LoadUser.sMsg);
                         end;
                       end;
                    end;
                    PlayObject.m_boWaitHeroDate := False;
                  end;
                end;
              end;
  {$IFEND}
            end;
            nCheck30 := 36;
            Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[I]));
          end;
          nCheck30 := 37;
          m_LoadPlayList.Clear;
        end;
        if m_ChangeHumanDBGoldList.Count > 0 then begin//20081008
          for I := 0 to m_ChangeHumanDBGoldList.Count - 1 do begin
            nCheck30 := 38;
            GoldChangeInfo := m_ChangeHumanDBGoldList.Items[I];
            PlayObject := GetPlayObject(GoldChangeInfo.sGameMasterName);
            if PlayObject <> nil then
              PlayObject.GoldChange(GoldChangeInfo.sGetGoldUser, GoldChangeInfo.nGold);
            nCheck30 := 39;
            Dispose(GoldChangeInfo);
          end;
          nCheck30 := 40;
          m_ChangeHumanDBGoldList.Clear;
        end;
      finally
        LeaveCriticalSection(m_LoadPlaySection);
      end;
      nCheck30 := 41;
      if m_NewHumanList.Count > 0 then begin//20081008
        for I := 0 to m_NewHumanList.Count - 1 do begin
          nCheck30 := 42;
          if PlayObject <> nil then begin//20090806 ����
            RunSocket.SetGateUserList(PlayObject.m_nGateIdx, PlayObject.m_nSocket, PlayObject);
          end;
        end;
        nCheck30 := 44;
        m_NewHumanList.Clear;
      end;
      nCheck30 := 45;
      if m_ListOfGateIdx.Count > 0 then begin//20081008
        for I := 0 to m_ListOfGateIdx.Count - 1 do begin
          nCheck30 := 46;
          RunSocket.CloseUser(Integer(m_ListOfGateIdx.Items[I]), Integer(m_ListOfSocket.Items[I])); //GateIdx,nSocket
        end;
        nCheck30 := 47;
        m_ListOfGateIdx.Clear;
      end;
      nCheck30 := 48;
      m_ListOfSocket.Clear;
      if (not g_boExitServer) and (m_UserLogonList.Count > 0) then begin//���˵�½
        if (m_PlayObjectList.Count < m_nLimitUserCount) then begin
          if GetTickCount - m_dwAILogonTick > 3000 then begin
            m_dwAILogonTick := GetTickCount;
            m_UserLogonList.Lock;
            try
              if m_UserLogonList.Count > 0 then begin
                AI := pTAILogon(m_UserLogonList.Objects[0]);
                RegenAIObject(AI);
                m_UserLogonList.Delete(0);
                Dispose(AI);
              end;
            finally
              m_UserLogonList.UnLock;
            end;
          end;
        end else begin
          AI := pTAILogon(m_UserLogonList.Objects[0]);
          m_UserLogonList.Delete(0);
          Dispose(AI);
        end;
      end;
    except
      on E: Exception do begin
        MainOutMessage(Format('{%s} TUserEngine::ProcessHumans -> Ready, Save, Load... Code:%d',[g_sExceptionVer, nCheck30]));
      end;
    end;
  end;
  try
    if m_PlayObjectFreeList.Count > 0 then begin//20081008
      for I := 0 to m_PlayObjectFreeList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectFreeList.Items[I]);
        if (GetTickCount - PlayObject.m_dwGhostTick) > g_Config.dwHumanFreeDelayTime {5 * 60 * 1000} then begin
          try
            //TPlayObject(m_PlayObjectFreeList.Items[I]).Free;
            if PlayObject <> nil then begin//20080821 �޸�
              //��ֹ��д���� By TasNat at: 2012-05-19 23:05:01
              if (g_HighLevelHuman = PlayObject) then g_HighLevelHuman := nil;
              if (g_HighPKPointHuman = PlayObject) then g_HighPKPointHuman := nil;
              if (g_HighDCHuman = PlayObject) then g_HighDCHuman := nil;
              if (g_HighMCHuman = PlayObject) then g_HighMCHuman := nil;
              if (g_HighSCHuman = PlayObject) then g_HighSCHuman := nil;
              if (g_HighOnlineHuman = PlayObject) then g_HighOnlineHuman := nil;
              PlayObject.Free;
              //PlayObject:= nil;//������ע�͵�By TasNat at: 2012-05-19 23:02:47
            end;
          except
            //MainOutMessage('{�쳣} TUserEngine::ProcessHumans ClosePlayer.Delete - Free');//20091124 ע��
          end;
          m_PlayObjectFreeList.Delete(I);
          Break;
        end else begin
          if PlayObject.m_boSwitchData and (PlayObject.m_boRcdSaved) then begin
            if SendSwitchData(PlayObject, PlayObject.m_nServerIndex) or (PlayObject.m_nWriteChgDataErrCount > 20) then begin
              PlayObject.m_boSwitchData := False;
              PlayObject.m_boSwitchDataSended := True;
              PlayObject.m_dwChgDataWritedTick := GetTickCount();
            end else Inc(PlayObject.m_nWriteChgDataErrCount);
          end;
          if PlayObject.m_boSwitchDataSended and ((GetTickCount - PlayObject.m_dwChgDataWritedTick) > 100) then begin
            PlayObject.m_boSwitchDataSended := False;
            SendChangeServer(PlayObject, PlayObject.m_nServerIndex);
          end;
        end;
      end;//for
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine::ProcessHumans ClosePlayer.Delete',[g_sExceptionVer]));
  end;

  {===================================���»�ȡ��Ȩ===============================}
  try
    if ((GetTickCount - m_dwSearchTick) > 3600000) or (m_TodayDate <> Date) then begin
      m_TodayDate := Date;
      m_dwSearchTick := GetTickCount;//GetTickCount()���ڻ�ȡ��windows��������������ʱ�䳤�ȣ����룩
      RegGetStatusFailExitApp(FrmMain.Caption, 1);//20080603 //�ж�M2�����Ƿ��ƽ��޸�
(*      m_nCheckServerCode := 1000;
      m_nUserLicense := 0;
      nM2Crc := 0;          //20080210 ʵ����Ѱ�
      Inc(nCrackedLevel, 5);
      if (g_nGetLicenseInfo >= 0) and Assigned(PlugProcArray[g_nGetLicenseInfo].nProcAddr) then begin
{$IF TESTMODE = 1}
        MainOutMessage('nCrackedLevel_1 ' + IntToStr(nCrackedLevel));
{$IFEND}
        Dec(nCrackedLevel);
        m_nCheckServerCode := 1001;
        nM2Crc := TGetLicense(PlugProcArray[g_nGetLicenseInfo].nProcAddr)(m_nProVersion, m_nUserLicense, m_nErrorCode);//��ȡ�����Ϣ,������������,��ʹ�ô���������
        //Inc(nErrorLevel, m_nErrorCode); 20071229 ȥ��
        m_nCheckServerCode := 1002;
        m_nLimitNumber := LoWord(m_nUserLicense); //�������ʹ�����������
        m_nLimitUserCount := LoWord(m_nErrorCode); //20071110 ����û���
        if (m_nProVersion = nProductVersion) and (nProductVersion <> 0) then Dec(nCrackedLevel);
        m_nCheckServerCode := 1003;
        if Decode(sUserQQKey, sUserKey) then Dec(nCrackedLevel);
        m_nCheckServerCode := 1004;
        if Str_ToInt(sUserKey, 0) = nUserLicense then Dec(nCrackedLevel);
        m_nCheckServerCode := 1005;
        if m_nCheckServerCode = 1005 then Dec(nCrackedLevel);
{$IF TESTMODE = 1}
        MainOutMessage('nM2Crc ' + IntToStr(nM2Crc));
        MainOutMessage('sUserKey ' + sUserKey);
        MainOutMessage('nCrackedLevel_2 ' + IntToStr(nCrackedLevel));
        MainOutMessage('m_nLimitNumber  ' + IntToStr(m_nLimitNumber));
        MainOutMessage('m_nLimitUserCount  ' + IntToStr(m_nLimitUserCount));
        MainOutMessage('m_nProVersion  ' + IntToStr(m_nProVersion));
        MainOutMessage('nErrorLevel  ' + IntToStr(nErrorLevel));
{$IFEND}
      end else begin
{$IF TESTMODE = 1}
        MainOutMessage('g_nGetLicenseInfo < 0');
{$IFEND}
      end;
{$IF TESTMODE = 1}
      MainOutMessage('nCrackedLevel ' + IntToStr(nCrackedLevel));
      MainOutMessage('nErrorLevel ' + IntToStr(nErrorLevel));
{$IFEND}
          *)
{$IF UserMode1 <> 2}
      m_nLimitNumber := 1000000; //20080210 ʵ����Ѱ�
      m_nLimitUserCount := 1000000; //20080210 ʵ����Ѱ�
{$IFEND}
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine::GetLicense',[g_sExceptionVer]));
  end;
{--------------------------------------------------------------------------------}
  boCheckTimeLimit := False;
  try
    dwCurTick := GetTickCount();
    nIdx := m_nProcHumIDx;
    nCheck30 := 20;
    while True do begin
      if (GetTickCount - dwCheckTime) > 250 then begin
        Break;//20091113 ���ԣ�ѭ��500������˳�ѭ��
      end;
      if m_PlayObjectList.Count <= nIdx then Break;
      nCheck30 := 21;
      PlayObject := TPlayObject(m_PlayObjectList.Objects[nIdx]);
      nCheck30 := 22;
      if PlayObject <> nil then begin
        nCheck30 := 23;
        if Integer(dwCurTick - PlayObject.m_dwRunTick) > PlayObject.m_nRunTime then begin
          PlayObject.m_dwRunTick := dwCurTick;
          nCheck30 := 24;
          if not PlayObject.m_boGhost then begin
            nCheck30 := 25;
            if not PlayObject.m_boLoginNoticeOK then begin
              try
                PlayObject.RunNotice();//������Ϸ�Ҹ�,����������Ϸʱ����ʾ��
              except
                MainOutMessage(Format('{%s} TUserEngine::ProcessHumans RunNotice',[g_sExceptionVer]));
              end;
            end else begin
              try
                if not PlayObject.m_boReadyRun then begin//�Ƿ������Ϸ���
                  PlayObject.m_boReadyRun := True;
                  PlayObject.UserLogon;//�����¼��Ϸ
                  if PlayObject.m_boNotOnlineAddExp then begin//�����ڹһ�״̬ 20080523
                    PlayObject.m_boNotOnlineAddExp := False;
                    PlayObject.m_boPlayOffLine := False;//�����ߴ��� 20080716
                    if g_ManageNPC <> nil then g_ManageNPC.GotoLable(PlayObject, '@RESUME', False, False); //�����ڹһ�״̬,������С��
                  end;
                  if PlayObject.m_M2AutoCreate then begin//20090318 M2ֱ�ӹ���,�������ﰲȫ�˳������봥���Σ�����Ƿ�һ�
                    PlayObject.m_M2AutoCreate:= False;
                    if PlayObject.m_PEnvir.GetXYObjCount(PlayObject.m_nCurrX, PlayObject.m_nCurrY) > 1 then begin//��������Ƿ��ص� 20090410
                      if not PlayObject.WalkTo(Random(8), False) then PlayObject.m_boPlayOffLine := False;//20100126 �ƶ��󣬻��ص�����������һ�
                    end;
                    if PlayObject.PKLevel >= 2 then PlayObject.m_boPlayOffLine := False;//20090506 ������ɫ���һ�
                    PlayObject.m_boSoftClose := True;
                  end;
                end else begin
                  if (GetTickCount() - PlayObject.m_dwSearchTick) > PlayObject.m_dwSearchTime then begin
                    PlayObject.m_dwSearchTick := GetTickCount();
                    nCheck30 := 10;
                    PlayObject.SearchViewRange;//��������
                    PlayObject.m_dwSearchTick := GetTickCount();//20090421 ����
                    nCheck30 := 11;
                    PlayObject.GameTimeChanged;//��Ϸʱ��ı�
                  end;
                end;
                if ((GetTickCount() - PlayObject.m_dwShowLineNoticeTick) > g_Config.dwShowLineNoticeTime)
                  and (not PlayObject.m_boNotOnlineAddExp) and (not PlayObject.m_boAI) then begin//20090512 ���ӣ�����һ�ʱ��������
                  PlayObject.m_dwShowLineNoticeTick := GetTickCount();
                  if LineNoticeList.Count > PlayObject.m_nShowLineNoticeIdx then begin
                    LineNoticeMsg := g_ManageNPC.GetLineVariableText(PlayObject, LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx]);//ͨ��QM��ʹ�ù���֧�ֱ���
                    nCheck30 := 13;
                    case LineNoticeMsg[1] of
                      'R': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Red, t_Notice);
                      'G': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Green, t_Notice);
                      'B': PlayObject.SysMsg(Copy(LineNoticeMsg, 2, Length(LineNoticeMsg) - 1), c_Blue, t_Notice);
                      else PlayObject.SysMsg(LineNoticeMsg, TMsgColor(g_Config.nLineNoticeColor), t_Notice);
                    end;
                  end;
                  Inc(PlayObject.m_nShowLineNoticeIdx);
                  if (LineNoticeList.Count <= PlayObject.m_nShowLineNoticeIdx) then PlayObject.m_nShowLineNoticeIdx := 0;
                end;
                nCheck30 := 14;
                PlayObject.Run();
                nCheck30 := 15;
                if not FrontEngine.IsFull and ((GetTickCount() - PlayObject.m_dwSaveRcdTick) > g_Config.dwSaveHumanRcdTime) then begin
                  PlayObject.m_dwSaveRcdTick := GetTickCount();
                  nCheck30 := 17;
                  PlayObject.DealCancelA();
                  nCheck30 := 18;
                  SaveHumanRcd(PlayObject);
                  {$IF HEROVERSION = 1}
                  nCheck30 := 19;
                  SaveHeroRcd(PlayObject);//����Ӣ������
                  {$IFEND}
                end;
              except
                on E: Exception do begin
                  MainOutMessage(Format('{%s} TUserEngine::ProcessHumans Human.Operate Code:%d',[g_sExceptionVer, nCheck30]));
                  PlayObject.m_boGhost:= True;//20110322 �޸�
                end;
              end;
            end;
          end else begin //if not PlayObject.m_boGhost then begin
            try
              m_PlayObjectList.Delete(nIdx);
              nCheck30 := 2;
              PlayObject.Disappear();
              nCheck30 := 3;
            except
              on E: Exception do begin
                MainOutMessage(Format('{%s} TUserEngine::ProcessHumans Human.Finalize Code:%d',[g_sExceptionVer, nCheck30]));
              end;
            end;
            try
              nCheck30 := 4;
              PlayObject.DealCancelA();
              nCheck30 := 5;
              SaveHumanRcd(PlayObject);
{$IF HEROVERSION = 1}
              nCheck30 := 6;
              SaveHeroRcd(PlayObject);//����Ӣ������
{$IFEND}
              AddToHumanFreeList(PlayObject);//20090106 ��λ�� �����ͷ��б�
              //��ֹ��д���� By TasNat at: 2012-05-19 23:05:01
              if (g_HighLevelHuman = PlayObject) then g_HighLevelHuman := nil;
              if (g_HighPKPointHuman = PlayObject) then g_HighPKPointHuman := nil;
              if (g_HighDCHuman = PlayObject) then g_HighDCHuman := nil;
              if (g_HighMCHuman = PlayObject) then g_HighMCHuman := nil;
              if (g_HighSCHuman = PlayObject) then g_HighSCHuman := nil;
              if (g_HighOnlineHuman = PlayObject) then g_HighOnlineHuman := nil;
              nCheck30 := 7;
              if PlayObject.m_boAI then begin
                PlayObject.m_boSoftClose := True;
              end else begin
                if (not PlayObject.m_boReconnection) then begin//20090102 ���������ӲŹر�
                  RunSocket.CloseUser(PlayObject.m_nGateIdx, PlayObject.m_nSocket);
                end;
              end;
            except
              MainOutMessage(Format('{%s} TUserEngine::ProcessHumans RunSocket.CloseUser Code:%d',[g_sExceptionVer, nCheck30]));
            end;
            //SendServerGroupMsg(SS_202, nServerIndex, PlayObject.m_sCharName);//20101022 ע��
            Continue;
          end;
        end; //if (dwTime14 - PlayObject.dw368) > PlayObject.dw36C then begin
        Inc(nIdx);
        if (GetTickCount - dwCheckTime) > g_dwHumLimit then begin
          boCheckTimeLimit := True;
          m_nProcHumIDx := nIdx;
          Break;
        end;
      end;
    end;//while True do begin
    if not boCheckTimeLimit then m_nProcHumIDx := 0;
  except
    MainOutMessage(Format('{%s} TUserEngine::ProcessHumans Code:%d',[g_sExceptionVer, nCheck30]));
  end;
  //g_nProcessHumanLoopTime := nProcessHumanLoopTime;//20080815 ע��
  Inc(g_nProcessHumanLoopTime);//20080815
  if m_nProcHumIDx = 0 then begin
    //nProcessHumanLoopTime := 0;//20080815 ע��
    //g_nProcessHumanLoopTime := nProcessHumanLoopTime; //20080815 ע��
    g_nProcessHumanLoopTime := 0;//20080815
    dwUsrRotTime := GetTickCount - g_dwUsrRotCountTick;
    dwUsrRotCountMin := dwUsrRotTime;
    g_dwUsrRotCountTick := GetTickCount();
    if dwUsrRotCountMax < dwUsrRotTime then dwUsrRotCountMax := dwUsrRotTime;
  end;
  g_nHumCountMin := GetTickCount - dwCheckTime;
  if g_nHumCountMax < g_nHumCountMin then g_nHumCountMax := g_nHumCountMin;
end;

{//�Ƿ��ǽ���NPC(δʹ��)
function TUserEngine.InMerchantList(Merchant: TMerchant): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to m_MerchantList.Count - 1 do begin
    if (Merchant <> nil) and (TMerchant(m_MerchantList.Items[I]) = Merchant) then begin
      Result := True;
      Break;
    end;
  end;
end;}

procedure TUserEngine.ProcessMerchants;
var
  dwRunTick, dwCurrTick: LongWord;
  I: Integer;
  MerchantNPC: TMerchant;
  boProcessLimit: Boolean;
  nCode:Byte;//20090705
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  nCode:= 0;
  try
    dwCurrTick := GetTickCount();
    m_MerchantList.Lock;
    try
      //I := nMerchantPosition;//20091103
      for I := nMerchantPosition to m_MerchantList.Count - 1 do begin//while True do begin 20091103 �޸�
        if m_MerchantList.Count <= I then Break;//20101027
        if (GetTickCount - dwRunTick) > 250 then Break;//20091113 ���ԣ�ѭ��500������˳�ѭ��
        nCode:= 1;
        MerchantNPC := m_MerchantList.Items[I];
        if MerchantNPC <> nil then begin
          nCode:= 2;
          if not MerchantNPC.m_boGhost then begin
            if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin
              {if (GetTickCount - MerchantNPC.m_dwSearchTick) > MerchantNPC.m_dwSearchTime then begin//20090421 ע�ͣ�NPC������Ŀ��
                MerchantNPC.m_dwSearchTick := GetTickCount();
                MerchantNPC.SearchViewRange();
              end; 
              nCode:= 3; 
              if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin }
                MerchantNPC.m_dwRunTick := dwCurrTick;
                nCode:= 4;
                MerchantNPC.Run;
              //end;
            end;
          end else begin
            if (GetTickCount - MerchantNPC.m_dwGhostTick) > 60000{60 * 1000} then begin
              nCode:= 5;
              m_MerchantList.Delete(I);
              nCode:= 6;
              MerchantNPC.Free;
              Break;
            end;
          end;
        end;
        nCode:= 7;
        if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
          nMerchantPosition := I;
          boProcessLimit := True;
          Break;
        end;
        //Inc(I);//20091103
      end;
    finally
      m_MerchantList.UnLock;
    end;
    if not boProcessLimit then  nMerchantPosition := 0;
  except
    MainOutMessage(Format('{%s} TUserEngine::ProcessMerchants Code:%d',[g_sExceptionVer, nCode]));
  end;
  dwProcessMerchantTimeMin := GetTickCount - dwRunTick;
  if dwProcessMerchantTimeMin > dwProcessMerchantTimeMax then dwProcessMerchantTimeMax := dwProcessMerchantTimeMin;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;
{δʹ�ú��� 20090813
function TUserEngine.InsMonstersList(MonGen: pTMonGenInfo; Monster: TAnimalObject): Boolean;
var
  I, II: Integer;
  MonGenInfo: pTMonGenInfo;
begin
  Result := False;
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGenInfo := m_MonGenList.Items[I];
      if (MonGenInfo <> nil) and (MonGen <> nil) then begin//20090213
        if (MonGenInfo.CertList <> nil) and (MonGen = MonGenInfo) then begin
          if MonGenInfo.CertList.Count > 0 then begin
            for II := 0 to MonGenInfo.CertList.Count - 1 do begin
              if (Monster <> nil) then begin
                if (TBaseObject(MonGenInfo.CertList.Items[II]) = Monster) then begin
                  Result := True;
                  Break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end; }
//�������
function TUserEngine.ClearMonsters(sMapName: string): Boolean;
var
  I, II: Integer;
  {MonGenInfo: pTMonGenInfo;
  Monster: TAnimalObject; }
  MonList: TList;
  Envir: TEnvirnoment;
  BaseObject: TBaseObject;
begin
  Result := False;
  MonList := TList.Create;
  try
    if g_MapManager.Count > 0 then begin//20081008
      for I := 0 to g_MapManager.Count - 1 do begin
        Envir := TEnvirnoment(g_MapManager.Items[I]);
        if (Envir <> nil) and ((CompareText(Envir.sMapName, sMapName) = 0)) then begin
          GetMapMonster(Envir, MonList);
          if MonList.Count > 0 then begin//20081008
            for II := 0 to MonList.Count - 1 do begin
              BaseObject := TBaseObject(MonList.Items[II]);
              if BaseObject <> nil then begin
                if (BaseObject.m_btRaceServer <> 110) and (BaseObject.m_btRaceServer <> 111) and
                   (BaseObject.m_btRaceServer <> RC_GUARD) and (BaseObject.m_btRaceServer <> RC_ARCHERGUARD) and
                   (BaseObject.m_btRaceServer <> 55) then begin
                  BaseObject.m_boNoItem := True;
                  BaseObject.m_WAbil.HP := 0;
                end;
              end;
            end;
          end;
        end;
      end;//for
    end;
  finally
    MonList.Free;
  end;

  {for i := 0 to m_MonGenList.Count - 1 do begin
    MonGenInfo := m_MonGenList.Items[i];
    if MonGenInfo = nil then Continue;
    if CompareText(MonGenInfo.sMapName, sMapName) = 0 then begin
      if (MonGenInfo.CertList <> nil) and (MonGenInfo.CertList.Count > 0) then begin
        for ii := 0 to MonGenInfo.CertList.Count - 1 do begin
          Monster := TAnimalObject(MonGenInfo.CertList.Items[ii]);
          if Monster <> nil then begin
            if (Monster.m_btRaceServer <> 110) and (Monster.m_btRaceServer <> 111) and
              (Monster.m_btRaceServer <> 111) and (Monster.m_btRaceServer <> RC_GUARD) and
              (Monster.m_btRaceServer <> RC_ARCHERGUARD) and (Monster.m_btRaceServer <> 55) then begin
              Monster.Free;
              if nMonsterCount > 0 then Dec(nMonsterCount);
              //DisPose();
            end;
          end;
          if MonGenInfo.CertList.Count <= 0 then begin
            MonGenInfo.CertList.Clear;
          end;
        end;
      end;
    end;
  end;}
  Result := True;
end;
//�������
procedure TUserEngine.ProcessMonsters;
  function GetZenTime(dwTime: LongWord): LongWord;
  var
    d10: Double;
  begin     
    if dwTime < 1800000{30 * 60 * 1000} then begin
      d10 := (GetUserCount - g_Config.nUserFull {1000}) / g_Config.nZenFastStep {300};
      if d10 > 0 then begin
        if d10 > 6 then d10 := 6;
        Result := dwTime - Round((dwTime / 10) * d10)
      end else Result := dwTime;
    end else Result := dwTime;
  end;
var
  dwCurrentTick, dwRunTick, dwMonProcTick: LongWord;
  MonGen: pTMonGenInfo;
  nGenCount, nGenModCount, I, nProcessPosition: Integer;
  boProcessLimit, boRegened, boCanCreate: Boolean;
  Monster: TAnimalObject;
  tCode: Byte;
begin
  tCode := 0;
  Monster := nil;//By TasNat at: 2012-11-11 08:57:27
  MonGen := nil;  
  dwRunTick := GetTickCount();
  try
    tCode := 1;
    boProcessLimit := False;
    dwCurrentTick := GetTickCount();

    //ˢ�¹��￪ʼ,�ж��Ƿ񳬹�ˢ�ֵļ��
    if ((GetTickCount - dwRegenMonstersTick) > g_Config.dwRegenMonstersTime) then begin
      tCode := 2;
      dwRegenMonstersTick := GetTickCount();
      if m_nCurrMonGen < m_MonGenList.Count then begin
        tCode := 25;
        MonGen := m_MonGenList.Items[m_nCurrMonGen];//ȡ�õ�ǰˢ�ֵ�����
      end;
      tCode := 3;
      if m_nCurrMonGen < m_MonGenList.Count - 1 then begin
        Inc(m_nCurrMonGen);
      end else begin
        m_nCurrMonGen := 0;
      end;
      tCode := 4;
      if (MonGen <> nil) and (not g_Config.boVentureServer) then begin
        if (MonGen.sMonName <> '') and (MonGen.Envir <> nil) then begin//20100614 ����(MonGen.Envir <> nil)
          if (MonGen.dwStartTick = 0) or ((GetTickCount - MonGen.dwStartTick) > GetZenTime(MonGen.dwZenTime)) then begin
            nGenCount := GetGenMonCount(MonGen);//ȡ��ˢ�����Ĺ�����
            boRegened := True;
            if g_Config.nMonGenRate <= 0 then g_Config.nMonGenRate := 10; //��ֹ��������
            nGenModCount := _MAX(1, Round(_MAX(1, MonGen.nCount) / (g_Config.nMonGenRate / 10)));//����ˢ�Ĺ�����
            boCanCreate := True;
            if (MonGen.Envir.m_boNoManNoMon) and (MonGen.Envir.HumCount = 0) then boCanCreate := False;//���˲�ˢ�� 20110527
            if (nGenModCount > nGenCount) and boCanCreate then begin //����ˢ����������
              if (nErrorLevel = 0) and (nCrackedLevel = 0) then begin
                boRegened := RegenMonsters(MonGen, nGenModCount - nGenCount);//�����������
              end else
              if dwStartTime < 36000{60 * 60 * 10} then begin //�ƽ����10Сʱ��������ˢ��
                boRegened := RegenMonsters(MonGen, nGenModCount - nGenCount);
              end;
            end;
            if boRegened then MonGen.dwStartTick := GetTickCount();
          end;
          g_sMonGenInfo1 := MonGen.sMonName + ',' + IntToStr(m_nCurrMonGen) + '/' + IntToStr(m_MonGenList.Count);
        end;
      end;
      if m_M2AutoAddPetsMon.Count > 0 then begin//�����б�
        if (GetTickCount - m_dwM2AutoAddPetsMonTick > 2000) then begin
          m_dwM2AutoAddPetsMonTick:= GetTickCount();
          MakePetsMonObject(m_M2AutoAddPetsMon);//M2�Զ����س����б�
        end;
      end;
    end;
    tCode := 9;
    g_nMonGenTime := GetTickCount - dwCurrentTick;
    if g_nMonGenTime > g_nMonGenTimeMin then g_nMonGenTimeMin := g_nMonGenTime;
    if g_nMonGenTime > g_nMonGenTimeMax then g_nMonGenTimeMax := g_nMonGenTime;
    //ˢ�¹������
    dwMonProcTick := GetTickCount();
    nMonsterProcessCount := 0;
    tCode := 10;
    if m_MonGenList.Count > 0 then begin//20080629
      for I := m_nMonGenListPosition to m_MonGenList.Count - 1 do begin
        tCode := 11;
        MonGen := m_MonGenList.Items[I];
        if MonGen <> nil then begin//20090213
          if m_nMonGenCertListPosition < MonGen.CertList.Count then begin
            nProcessPosition := m_nMonGenCertListPosition;
          end else begin
            nProcessPosition := 0;
          end;
          m_nMonGenCertListPosition := 0;
          while (True) do begin
            if (GetTickCount - dwMonProcTick) > 250 then Break;//20091113 ���ԣ�ѭ��500������˳�ѭ��
            if nProcessPosition >= MonGen.CertList.Count then Break;
            tCode := 13;
            Monster := MonGen.CertList.Items[nProcessPosition];
            if Monster <> nil then begin
              tCode := 14;
              if not Monster.m_boGhost then begin
                tCode := 15;
                if {Integer}(dwCurrentTick - Monster.m_dwRunTick) > Monster.m_nRunTime then begin//20100614 �޸�
                  tCode := 27;
                  try//20091123 ����
                    Monster.m_dwRunTick := dwRunTick;
                    if (dwCurrentTick - Monster.m_dwSearchTick) > Monster.m_dwSearchTime then begin
                      tCode := 17;
                      if Monster <> nil then begin//20090307 ����
                        Monster.m_dwSearchTick := GetTickCount();
                        tCode := 29;
                        try//20100614
                          Monster.SearchViewRange();//�ֶ�,ռCPU Ӣ��Ҳ���⴦��
                        except
                        end;
                        tCode := 30;
                        Monster.m_dwSearchTick := GetTickCount();
                      end;
                    end;
                    if (not Monster.m_boIsVisibleActive) and (Monster.m_nProcessRunCount < g_Config.nProcessMonsterInterval) and
                      (Monster.m_TargetCret = nil) and (Monster.m_Castle = nil) and (Monster.m_MsgList.Count <= 0) then begin//20100629 ��������
                      Inc(Monster.m_nProcessRunCount);
                    end else begin
                      if Monster <> nil then begin //20080526 ����
                        Monster.m_nProcessRunCount := 0;
                        tCode := 18;
                        try//20100614
                          Monster.Run;
                        except
                        end;
                      end;
                    end;
                  except
                    {tCode := 31; //20100109 ע��
                    if Monster <> nil then Monster.m_boGhost:= True;//20090705 ����
                    tCode := 32; }
                  end;
                  Inc(nMonsterProcessCount);
                end;
                Inc(nMonsterProcessPostion);
              end else begin
                tCode := 34;
                if (GetTickCount - Monster.m_dwGhostTick) > 120000{2 * 60 * 1000} then begin
                  try//20100203 ����
                    tCode := 19;
                    MonGen.CertList.Delete(nProcessPosition);
                    tCode := 20;
                    FreeAndNil(Monster);//09��Ĵ���������Ŷ By TasNat at: 2012-03-08 16:46:06
                    //if Monster <> nil then Monster.Free;//20090401 �޸�
                    //if Monster <> nil then FreeAndNil(Monster);//20081130
                  except
                  end;
                  Continue;
                end;
              end;
            end;
            tCode := 33;
            Inc(nProcessPosition);
            if (GetTickCount - dwMonProcTick) > g_dwMonLimit then begin
              tCode := 21;
              if (Monster <> nil) and (not Monster.m_boGhost) then begin//20091125 ����
                g_sMonGenInfo2 := Monster.m_sCharName + '/' + IntToStr(I) + '/' + IntToStr(nProcessPosition);
              end;
              tCode := 22;
              boProcessLimit := True;
              m_nMonGenCertListPosition := nProcessPosition;
              Break;
            end;
          end;//while
        end;
        if boProcessLimit then Break;
      end; //for I:= m_nMonGenListPosition to MonGenList.Count -1 do begin
    end;
    tCode := 23;
    if m_MonGenList.Count <= I then begin
      m_nMonGenListPosition := 0;
      nMonsterCount := nMonsterProcessPostion;
      nMonsterProcessPostion := 0;
      I:= 0;//20091113 ����
    end;
    if not boProcessLimit then begin
      m_nMonGenListPosition := 0;
    end else begin
      m_nMonGenListPosition := I;
    end;
    g_nMonProcTime := GetTickCount - dwMonProcTick;
    if g_nMonProcTime > g_nMonProcTimeMin then g_nMonProcTimeMin := g_nMonProcTime;
    if g_nMonProcTime > g_nMonProcTimeMax then g_nMonProcTimeMax := g_nMonProcTime;
  except
    on E: Exception do begin
      if Monster <> nil then begin
        Monster.m_boGhost:= True;//20090610����
        MainOutMessage(Format('{%s}ProcessMonsters1 %d %s::%s',[g_sExceptionVer, tCode, Monster.m_sCharName, E.Message]));
        Exit;
      end else if MonGen <> nil then
        MainOutMessage(Format('{%s}ProcessMonsters2. %s %d:%d:%s',[g_sExceptionVer, MonGen.sMonName, tCode, nProcessPosition, E.Message]))
      else
        MainOutMessage(Format('{%s}ProcessMonsters3. %d %d::%s',[g_sExceptionVer, tCode, m_nCurrMonGen, E.Message]));
    end;
  end;
  g_nMonTimeMin := GetTickCount - dwRunTick;
  if g_nMonTimeMax < g_nMonTimeMin then g_nMonTimeMax := g_nMonTimeMin;
end;
//ȡˢ����Ĺ�����
function TUserEngine.GetGenMonCount(MonGen: pTMonGenInfo): Integer;
var
  I: Integer;
  nCount: Integer;
  BaseObject: TBaseObject;
begin
  nCount := 0;
  if MonGen <> nil then begin
    if MonGen.CertList.Count > 0 then begin
      for I := 0 to MonGen.CertList.Count - 1 do begin
        BaseObject := TBaseObject(MonGen.CertList.Items[I]);
        if BaseObject <> nil then begin
          if not BaseObject.m_boDeath and not BaseObject.m_boGhost then Inc(nCount);
        end;
      end;
    end;
  end;
  Result := nCount;
end;
{//δʹ�õĺ���  20080422
function TUserEngine.InQuestNPCList(NPC: TNormNpc): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to QuestNPCList.Count - 1 do begin
    if (NPC <> nil) and (TNormNpc(QuestNPCList.Items[I]) = NPC) then begin
      Result := True;
      Break;
    end;
  end;
end;  }

procedure TUserEngine.ProcessNpcs;
var
  dwRunTick, dwCurrTick: LongWord;
  I: Integer;
  NPC: TNormNpc;
  boProcessLimit: Boolean;
begin
  dwRunTick := GetTickCount();
  boProcessLimit := False;
  try
    dwCurrTick := GetTickCount();
    for I := nNpcPosition to QuestNPCList.Count - 1 do begin
      if (GetTickCount - dwRunTick) > 250 then begin
        Break;//20091113 ���ԣ�ѭ��500������˳�ѭ��
      end;
      NPC := QuestNPCList.Items[I];
      if NPC <> nil then begin
        if not NPC.m_boGhost then begin
          if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin
            {if (GetTickCount - NPC.m_dwSearchTick) > NPC.m_dwSearchTime then begin//20090421 ע�ͣ�NPC������Ŀ��
              NPC.m_dwSearchTick := GetTickCount();
              NPC.SearchViewRange();
            end;
            if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin }
              NPC.m_dwRunTick := dwCurrTick;
              NPC.Run;
            //end;
          end;
        end else begin
          if (GetTickCount - NPC.m_dwGhostTick) > 60000{60 * 1000} then begin
            NPC.Free;
            QuestNPCList.Delete(I);
            Break;
          end;
        end;
      end;
      if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
        nNpcPosition := I;
        boProcessLimit := True;
        Break;
      end;
    end;//for
    if not boProcessLimit then  nNpcPosition := 0;
  except
    MainOutMessage(Format('{%s} TUserEngine.ProcessNpcs',[g_sExceptionVer]));
  end;
  dwProcessNpcTimeMin := GetTickCount - dwRunTick;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax := dwProcessNpcTimeMin;
end;

function TUserEngine.RegenMonsterByName(sMAP: string; nX, nY: Integer; sMonName: string): TBaseObject;
var
  nRace: Integer;
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  Result := nil;//20090707 ����
  nRace := GetMonRace(sMonName);
  if nRace > -1 then begin//20090707 ����
    BaseObject := AddBaseObject(sMAP, nX, nY, nRace, sMonName);
    if BaseObject <> nil then begin
      n18 := m_MonGenList.Count - 1;
      if n18 < 0 then n18 := 0;
      MonGen := m_MonGenList.Items[n18];
      if MonGen <> nil then begin
        MonGen.CertList.Add(BaseObject);
        //BaseObject.m_PEnvir.AddObject(1);//�����ӵ�ͼ�ּ��� 20091008ע��
        BaseObject.m_boAddToMaped := True;
      end;
      Result := BaseObject;//20090628 ��λ��
    end;
    //Result := BaseObject;
  end;
end;

function TUserEngine.RegenPlayByName(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject;
var
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  Result := nil;//20090707 ����
  BaseObject := AddPlayObject(PlayObject, nX, nY, sMonName);
  if BaseObject <> nil then begin
    n18 := m_MonGenList.Count - 1;
    if n18 < 0 then n18 := 0;
    MonGen := m_MonGenList.Items[n18];
    if MonGen <> nil then begin//20090213
      MonGen.CertList.Add(BaseObject);
      BaseObject.m_PEnvir.AddObject(1);
      BaseObject.m_boAddToMaped := True;
    end;
    Result := BaseObject;
  end;
  //Result := BaseObject;
end;
{//δʹ�ù��� 20090515
procedure TUserEngine.AddObjectToMonList(BaseObject: TBaseObject);
var
  n18: Integer;
  MonGen: pTMonGenInfo;
begin
  n18 := m_MonGenList.Count - 1;
  if n18 < 0 then n18 := 0;
  MonGen := m_MonGenList.Items[n18];
  if MonGen <> nil then begin//20090213
    MonGen.CertList.Add(BaseObject);
    BaseObject.m_PEnvir.AddObject(1);
    BaseObject.m_boAddToMaped := True;
  end;
end;}

procedure TUserEngine.Run;
  procedure ShowOnlineCount();//ȡ��������
  var
    nOnlineCount, nOnlineCount2, nAutoAddExpPlayCount: Integer;
  begin
    nOnlineCount := GetUserCount;
    nAutoAddExpPlayCount := GetAutoAddExpPlayCount;//�һ�����
    nOnlineCount2 := nOnlineCount - nAutoAddExpPlayCount - GetAIPlayCount;//������������(20110512 ���Ӽ���������)
    MainOutMessage(Format('������: %d (%d/%d)', [ nOnlineCount, nOnlineCount2, nAutoAddExpPlayCount]));
  end;
begin
  try
    if (GetTickCount() - dwShowOnlineTick) > g_Config.dwConsoleShowUserCountTime then begin
      dwShowOnlineTick := GetTickCount();
      ShowOnlineCount();//ȡ��������
      g_CastleManager.Save;//����Ǳ��������
    end;
    if (GetTickCount() - dwSendOnlineHumTime) > 10000 then begin//������������������Logsrv.exe
      dwSendOnlineHumTime := GetTickCount();
      FrmIDSoc.SendOnlineHumCountMsg(GetOnlineHumCount);
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TUserEngine::Run',[g_sExceptionVer]));
    end;
  end;
end;
{$IF M2Version <> 2}
function TUserEngine.GetHumTitle(nHumTitleIdx: Integer): pTHumTitleDB;
begin
  Result := nil;
  try
    Dec(nHumTitleIdx);
    if (nHumTitleIdx >= 0) then begin
      if (HumTitleList.Count > nHumTitleIdx) then begin
        if HumTitleList.Items[nHumTitleIdx] <> nil then begin
          Result := HumTitleList.Items[nHumTitleIdx];
          if Result.sTitleName = '' then Result := nil;
        end;
      end;
    end;
  except
    Result := nil;
  end;
end;

function TUserEngine.GetHumTitle(sTitleName: string): pTHumTitleDB;
var
  I: Integer;
  HumTitleDB: pTHumTitleDB;
begin
  Result := nil;
  try
    if sTitleName = '' then Exit;
    if HumTitleList.Count > 0 then begin
      for I := 0 to HumTitleList.Count - 1 do begin
        HumTitleDB := HumTitleList.Items[I];
        if HumTitleDB <> nil then begin
          if CompareText(HumTitleDB.sTitleName, sTitleName) = 0 then begin
            Result := HumTitleDB;
            Break;
          end;
        end;
      end;
    end;
  except
    Result := nil;
  end;
end;
//ȡ��ӦAnicount�ĳƺ���
function TUserEngine.GetHumTitleName(Anicount: Integer): String;
var
  I: Integer;
  HumTitleDB: pTHumTitleDB;
begin
  Result := '';
  if Anicount < 0 then Exit;
  if HumTitleList.Count > 0 then begin
    for I := 0 to HumTitleList.Count - 1 do begin
      HumTitleDB := HumTitleList.Items[I];
      if HumTitleDB <> nil then begin
        if (HumTitleDB.AniCount = Anicount) then begin
          Result := HumTitleDB.sTitleName;
          Break;
        end;
      end;
    end;
  end;
end;

//ȡ�ƺſ���ʱ��
function TUserEngine.GetHumTitleHours(nHumTitleIdx: Integer): Integer;
var
  HumTitleDB: pTHumTitleDB;
begin
  Dec(nHumTitleIdx);
  if (nHumTitleIdx >= 0) and (HumTitleList.Count > nHumTitleIdx) then begin
    HumTitleDB := HumTitleList.Items[nHumTitleIdx];
    if HumTitleDB <> nil then begin
      Result := HumTitleDB.nHours;
    end;
  end else begin
    Result := 0;
  end;
end;

function TUserEngine.CopyToFengHaoFromName(sFengHaoName: string; HumTitle: pTHumTitle): Boolean;
var
  I, K: Integer;
  HumTitleDB: pTHumTitleDB;
  Year, Month, Day: Word;
begin
  Result := False;
  try
    if sFengHaoName <> '' then begin
      if HumTitleList.Count > 0 then begin
        for I := 0 to HumTitleList.Count - 1 do begin
          HumTitleDB := pTHumTitleDB(HumTitleList.Items[I]);
          if HumTitleDB <> nil then begin
            if CompareText(HumTitleDB.sTitleName, sFengHaoName) = 0 then begin
              FillChar(HumTitle^, SizeOf(THumTitle), #0);
              HumTitle.wIndex := I + 1;
              HumTitle.MakeIndex := GetFengHaoNumber();
              HumTitle.boUseTitle:= False;//ʹ�ô˳ƺ�

              HumTitle.wDura := HumTitleDB.DuraMax;
              HumTitle.wMaxDura := HumTitleDB.DuraMax;
              case HumTitleDB.StdMode of
                0: begin//��ʱ�ƺ�
                  case HumTitleDB.AniCount of
                    5, 11: begin//��ʿ��ƺ�24ʱ����,0����ʧ�ƺ�
                      DecodeDate(Now() + 1, Year, Month, Day);
                      HumTitle.ApplyDate:= EncodeDate(Year, Month, Day);//����ʱ��
                    end;
                    else begin
                      if (HumTitleDB.nHours > 0) and (HumTitleDB.nHours < 65535) then begin
                        HumTitle.ApplyDate:= IncDayHour(Now(), HumTitleDB.nHours);//����ʱ��
                      end;
                    end;
                  end;
                end;
                1: begin//���óƺ�
                end;
              end;
              Result := True;
              Break;
            end;
          end;
        end;//for
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.CopyToFengHaoFromName',[g_sExceptionVer]));
  end;
end;
{$IFEND}
//�ж�����Ƿ�����(�ƺ�)
function TUserEngine.GetPlayOnline(sName: string): Boolean;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := False;
  if (m_PlayObjectList.Count > 0) and (sName <> '') then begin
    I:= m_PlayObjectList.IndexOf(sName);
    if I > -1 then begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boGhost) then begin
          if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then
            Result := True;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetStdItem(nItemIdx: Integer): pTStdItem;
begin
  Result := nil;
  try
    Dec(nItemIdx);
    if (nItemIdx >= 0) then begin
      if (StdItemList.Count > nItemIdx) then begin
        if StdItemList.Items[nItemIdx] <> nil then begin//20090306 ����
          Result := StdItemList.Items[nItemIdx];
          if Result.Name = '' then Result := nil;
        end;
      end;
    end;
  except
    Result := nil;//20090502 ����
  end;
end;

function TUserEngine.GetStdItem(sItemName: string): pTStdItem;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  try
    if sItemName = '' then Exit;
    if StdItemList.Count > 0 then begin//20081008
      for I := 0 to StdItemList.Count - 1 do begin
        StdItem := StdItemList.Items[I];
        if StdItem <> nil then begin//20090128
          if CompareText(StdItem.Name, sItemName) = 0 then begin
            Result := StdItem;
            Break;
          end;
        end;
      end;
    end;
  except
    Result := nil;//20090524 ����
  end;
end;

//(���,����)ͨ������Anicount,StdMode�õ���Ӧ�Ƶĺ��� 20090616�޸�
function TUserEngine.GetMakeWineStdItem(nStdMode: Byte; Anicount: Integer): pTStdItem;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if Anicount < 0 then Exit;
  if StdItemList.Count > 0 then begin
    for I := 0 to StdItemList.Count - 1 do begin
      StdItem := StdItemList.Items[I];
      if StdItem <> nil then begin//20090128
        if (StdItem.Shape = Anicount) and (StdItem.StdMode = nStdMode) then begin
          Result := StdItem;
          Break;
        end;
      end;
    end;
  end;
end;

//ͨ����Shape�õ���Ӧ�����ĺ���
function TUserEngine.GetMakeWineStdItem1(Shape: Integer): pTStdItem;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if Shape < 0 then Exit;
  if StdItemList.Count > 0 then begin
    for I := 0 to StdItemList.Count - 1 do begin
      StdItem := StdItemList.Items[I];
      if StdItem <> nil then begin//20090128
        if (StdItem.Shape = Shape) and (StdItem.StdMode = 13) then begin
          Result := StdItem;
          Break;
        end;
      end;
    end;
  end;
end;
//ͨ�����ӵ�Anicount�õ���Ӧ��Կ�� 20090225
function TUserEngine.GetBoxKeyItem(Anicount: Byte): pTStdItem;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if Anicount < 0 then Exit;
  if StdItemList.Count > 0 then begin
    for I := 0 to StdItemList.Count - 1 do begin
      StdItem := StdItemList.Items[I];
      if StdItem <> nil then begin
        if (StdItem.Shape = Anicount) and (StdItem.StdMode = 49) then begin
          Result := StdItem;
          Break;
        end;
      end;
    end;
  end;
end;

//ͨ�����������ȼ����õ���Ӧ����ʯ��Ʒ
function TUserEngine.GetArmsTearStdItem(Anicount: Integer): pTStdItem;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
  if Anicount < 0 then Exit;
  if StdItemList.Count > 0 then begin
    for I := 0 to StdItemList.Count - 1 do begin
      StdItem := StdItemList.Items[I];
      if StdItem <> nil then begin
        if (StdItem.Shape in [242..252]) and (StdItem.StdMode = 17) and (StdItem.AniCount = Anicount) then begin
          Result := StdItem;
          Break;
        end;
      end;
    end;
  end;
end;

//ͨ������ȡ��Ʒ����
function TUserEngine.GetStdItemWeight(nItemIdx: Integer): Integer;
var
  StdItem: pTStdItem;
begin
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
    StdItem := StdItemList.Items[nItemIdx];
    if StdItem <> nil then begin//20090128
      Result := StdItem.Weight;
    end;
  end else begin
    Result := 0;
  end;
end;

//ͨ������ȡ��Ʒ����
function TUserEngine.GetStdItemName(nItemIdx: Integer): string;
begin
  Result := '';
  Dec(nItemIdx);
  if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
    Result := pTStdItem(StdItemList.Items[nItemIdx]).Name;
  end else Result := '';
end;

{//���������������ϵĽ�ɫ ��ʱ��Ч 20101022 ע��
function TUserEngine.FindOtherServerUser(sName: string;
  var nServerIndex): Boolean;
begin
  Result := False;
end;}
//���ֺ���
procedure TUserEngine.CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY,
  nWide: Integer; btFColor, btBColor: Byte; sMsg: string);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin//20090204
        if not PlayObject.m_boGhost and
          (PlayObject.m_PEnvir = pMap) and
          (PlayObject.m_boBanShout) and //����Ⱥ������
          (PlayObject.m_boBanGmMsg)and //20080211  �ܾ����պ�����Ϣ
          (abs(PlayObject.m_nCurrX - nX) < nWide) and
          (abs(PlayObject.m_nCurrY - nY) < nWide) then begin
          PlayObject.SendMsg(PlayObject, wIdent, 0, btFColor, btBColor, 0, sMsg);
        end;
      end;
    end;
  end;
end;

//��ȡ���ﱬ����Ʒ  20080523
function TUserEngine.MonGetRandomItems(mon: TBaseObject): Integer;
var
  I, K: Integer;
  ItemList: TList;
  iname: string;
  MonItem, MonItem1: pTMonItemInfo;
  UserItem: pTUserItem;
  Monster: pTMonInfo;
  StdItem: pTStdItem;
  nCode: Byte;//20090113
begin
  nCode:=0;
  try
    ItemList := nil;
    if mon = nil then Exit;//20090113
    nCode:=1;
    if MonsterList.Count > 0 then begin//20081008
      for I := 0 to MonsterList.Count - 1 do begin
        Monster := MonsterList.Items[I];
        nCode:= 2;
        if Monster <> nil then begin//20090113
          nCode:= 20;
          if CompareText(Monster.sName, mon.m_sCharName) = 0 then begin
            nCode:= 21;
            ItemList := Monster.ItemList;
            Break;
          end;
        end;
      end;
    end;
    nCode:=3;
    if ItemList <> nil then begin
      if ItemList.Count > 0 then begin//20080627
        for I := 0 to ItemList.Count - 1 do begin
          MonItem := pTMonItemInfo(ItemList[I]);
          nCode:=4;
          if MonItem <> nil then begin//20090113
            if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
              if CompareText(MonItem.ItemName, 'RANDOM') = 0 then begin//��ģʽ(ֻȡһ����Ʒ) 20110225
                if MonItem.NewMonList <> nil then begin
                  if MonItem.NewMonList.Count > 0 then begin
                    for K := 0 to MonItem.NewMonList.Count - 1 do begin
                      MonItem1 := pTMonItemInfo(MonItem.NewMonList.Items[K]);
                      if MonItem1 <> nil then begin
                        if Random(MonItem1.MaxPoint) <= MonItem1.SelPoint then begin//�������
                          iname := '';
                          if iname = '' then iname := MonItem1.ItemName;
                          nCode:=61;
                          New(UserItem);
                          if CopyToUserItemFromName(iname, UserItem) then begin
                            StdItem:= GetStdItem(UserItem.wIndex);
                            if StdItem <> nil then begin
                              if not (StdItem.StdMode in [17, 18]) then
                                UserItem.Dura := Round((UserItem.DuraMax / 100) * (20 + Random(80)));
                              if Random(g_Config.nMonRandomAddValue) = 0 then RandomUpgradeItem(UserItem);
                              nCode:=71;
                              if UserItem.AddValue[0] = 2 then UserItem.AddValue[0]:= 0;//����48Сʱ����Ʒ������ 20110707
                              mon.m_ItemList.Add(UserItem);
                            end  else Dispose(UserItem);
                            Break;
                          end else Dispose(UserItem);
                        end;
                      end;
                    end;//K
                  end;
                end;
              end else begin
                nCode:=50;
                if CompareText(MonItem.ItemName, sSTRING_GOLDNAME) = 0 then begin  //����ǽ��
                  nCode:=51;
                  mon.m_nGold := mon.m_nGold + (MonItem.Count div 2) + Random(MonItem.Count);
                end else begin
                  iname := '';
                  if iname = '' then iname := MonItem.ItemName;
                  nCode:=6;
                  New(UserItem);
                  if CopyToUserItemFromName(iname, UserItem) then begin
                    StdItem:= GetStdItem(UserItem.wIndex);
                    if StdItem <> nil then begin
                      if UserItem.AddValue[0] = 2 then UserItem.AddValue[0]:= 0;//����48Сʱ����Ʒ������ 20110707
                      if not (StdItem.StdMode in [17, 18]) then
                        UserItem.Dura := Round((UserItem.DuraMax / 100) * (20 + Random(80)));
                      if Random(g_Config.nMonRandomAddValue) = 0 then RandomUpgradeItem(UserItem);
                      nCode:=7;
                      mon.m_ItemList.Add(UserItem);
                    end else Dispose(UserItem);
                  end else Dispose(UserItem);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    Result := 1;
  except
    MainOutMessage(Format('{%s} TUserEngine.MonGetRandomItems Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//���������Ʒ(��Ʒ����)
procedure TUserEngine.RandomUpgradeItem(Item: pTUserItem);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  case StdItem.StdMode of
    5, 6: if (StdItem.Shape <> 75) and (StdItem.Shape <> 76) and (StdItem.Shape <> 77) then ItemUnit.RandomUpgradeWeapon(Item);//����(�ڱ�������) 20100904
    10, 11: ItemUnit.RandomUpgradeDress(Item);//�·�
    19: ItemUnit.RandomUpgrade19(Item);//����(������)
    20, 21, 24, 27, 28, 29: ItemUnit.RandomUpgrade202124(Item);//����(׼ȷ�����͡�����ħ���ָ��͡�׼ȷ�����͡�����������)������(�ر���)����ָ(׼ȷ������) 20100513  20100628 ����29����(��������������)
    26: ItemUnit.RandomUpgrade26(Item);//��������
    22: ItemUnit.RandomUpgrade22(Item);//��ָ
    23: ItemUnit.RandomUpgrade23(Item);//��ָ(�ر���)
    15,16: ItemUnit.RandomUpgradeHelMet(Item);//ͷ��,����
    52,54,62,64: ItemUnit.RandomUpgradeBoots(Item);//20080503 Ь�ӣ�����
  end;
end;

//����װ��
procedure TUserEngine.GetUnknowItemValue(Item: pTUserItem);
var
  StdItem: pTStdItem;
begin
  StdItem := GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  case StdItem.StdMode of          
    15, 16: ItemUnit.UnknowHelmet(Item); //����ͷ��,����
    22, 23: ItemUnit.UnknowRing(Item);//���ؽ�ָ
    24, 26: ItemUnit.UnknowNecklace(Item);//������������
  end;
end;

function TUserEngine.CopyToUserItemFromName(sItemName: string; Item: pTUserItem): Boolean;
var
  I, K, II: Integer;
  StdItem: pTStdItem;
  Year, Month, Day: Word;
begin
  Result := False;
  try
    if sItemName <> '' then begin
      if StdItemList.Count > 0 then begin//20081008
        for I := 0 to StdItemList.Count - 1 do begin
          StdItem := pTStdItem(StdItemList.Items[I]);
          if StdItem <> nil then begin//20080725
            if CompareText(StdItem.Name, sItemName) = 0 then begin
              FillChar(Item^, SizeOf(TUserItem), #0);
              Item.wIndex := I + 1;
              Item.MakeIndex := GetItemNumber();
              Item.Dura := StdItem.DuraMax;
              Item.DuraMax := StdItem.DuraMax;
              Item.AddValue[0]:= 0;
              {$IF M2var = 1}
              Item.AddValue[2]:= 255;//��ʱ����14-19����ֵ����N���ȥ�� 20110528
              {$IFEND}
              if GetCheckItemList(16, StdItem.Name) then begin//�ж��Ƿ�Ϊ24ʱ��ʧ 20110520
                Item.AddValue[0]:= 1;
                DecodeDate(Now() + 1, Year, Month, Day);
                Item.MaxDate:= EncodeDate(Year, Month, Day);//����ʱ��
              end else if GetCheckItemList(17, StdItem.Name) then begin//�ж��Ƿ�Ϊ���ð���Ʒ 20110528
                Item.AddValue[0]:= 3;
              end else if GetCheckItemList(18, StdItem.Name) then begin//�ж��Ƿ�Ϊ��ʱ����Ʒ 20110528
                Item.AddValue[0]:= 2;
                Item.MaxDate:= IncDayHour(Now(), g_Config.nLimitItemTime);//���ʱ��
              end else begin//�ж��Ƿ�Ϊ��ʱ��Ʒ
                II:= GetLimitItemTimeCount(StdItem.Name);
                if II > 0 then begin
                  Item.AddValue[0]:= 1;
                  Item.MaxDate:= IncDayHour(Now(), II);//����ʱ��
                end;
              end;
              case StdItem.StdMode of
                {$IF M2Version <> 2}
                5: begin//����-����
                  Item.btValue[11]:= 0;
                  Item.btValue[20] := 0;
                  if g_Config.boUseCanKamPo then begin
                    if (StdItem.Shape <> 75) and (StdItem.Shape <> 76) and (StdItem.Shape <> 77) then begin
                      Item.btAppraisalLevel:= 1;
                      K:= GetItemPoint(Item^, StdItem^, False);
                      case K of
                             0:;
                         1..49: Item.btAppraisalLevel:= 11;//һ��
                        50..99: Item.btAppraisalLevel:= 21;//����
                        100..149: Item.btAppraisalLevel:= 31;//����
                        150..249: Item.btAppraisalLevel:= 41;//����
                        250..65535: Item.btAppraisalLevel:= 51;//����
                      end;
                    end;
                  end;
                  if ((StdItem.Need = 49) or (StdItem.Need = 50) or (StdItem.Need = 51) or (StdItem.Need = 52)) and (StdItem.Stock > 0) then begin//need-49 �����������ȼ� 20100916
                    Item.btValue[20] := _MIN(High(Byte),StdItem.Stock);//20101007 �޸�
                  end;
                end;
                6: begin//����-˫��(�������)
                  Item.btValue[11]:= 0;
                  Item.btValue[20] := 0;
                  if g_Config.boUseCanKamPo then begin
                    Item.btAppraisalLevel:= 1;
                    K:= GetItemPoint(Item^, StdItem^, False);
                    case K of
                           0:;
                       1..49: Item.btAppraisalLevel:= 11;//һ��
                      50..99: Item.btAppraisalLevel:= 21;//����
                      100..149: Item.btAppraisalLevel:= 31;//����
                      150..249: Item.btAppraisalLevel:= 41;//����
                      250..65535: Item.btAppraisalLevel:= 51;//����
                    end;
                  end;
                  if ((StdItem.Need = 49) or (StdItem.Need = 50) or (StdItem.Need = 51) or (StdItem.Need = 52)) and (StdItem.Stock > 0) then begin//need-49 �����������ȼ� 20100916
                    Item.btValue[20] := _MIN(High(Byte),StdItem.Stock);//20101007 �޸�
                  end;                  
                end;
                10,11: begin//�·�
                  if g_Config.boUseCanKamPo then begin
                    Item.btAppraisalLevel:= 1;
                    K:= GetItemPoint(Item^, StdItem^, False);
                    case K of
                           0:;
                       1..49: Item.btAppraisalLevel:= 11;//һ��
                      50..99: Item.btAppraisalLevel:= 21;//����
                      100..149: Item.btAppraisalLevel:= 31;//����
                      150..249: Item.btAppraisalLevel:= 41;//����
                      250..65535: Item.btAppraisalLevel:= 51;//����
                    end;
                  end;
                end;
                52,54,55,62,64:begin//Ь��,����
                  if g_Config.boUseCanKamPo then begin
                    Item.btAppraisalLevel:= 1;
                    K:= GetItemPoint(Item^, StdItem^, False);
                    case K of
                           0:;
                       1..49: Item.btAppraisalLevel:= 11;//һ��
                      50..99: Item.btAppraisalLevel:= 21;//����
                      100..149: Item.btAppraisalLevel:= 31;//����
                      150..249: Item.btAppraisalLevel:= 41;//����
                      250..65535: Item.btAppraisalLevel:= 51;//����
                    end;
                  end;
                end;
                27,28,29: begin
                  if g_Config.boUseCanKamPo then begin
                    Item.btAppraisalLevel:= 1;
                    K:= GetItemPoint(Item^, StdItem^, False);
                    case K of
                           0:;
                       1..49: Item.btAppraisalLevel:= 11;//һ��
                      50..99: Item.btAppraisalLevel:= 21;//����
                      100..149: Item.btAppraisalLevel:= 31;//����
                      150..249: Item.btAppraisalLevel:= 41;//����
                      250..65535: Item.btAppraisalLevel:= 51;//����
                    end;
                  end;
                end;
                30: begin//ѫ��
                  if g_Config.boUseCanKamPo then begin
                    Item.btAppraisalLevel:= 1;
                    K:= GetItemPoint(Item^, StdItem^, False);
                    case K of
                           0:;
                       1..49: Item.btAppraisalLevel:= 11;//һ��
                      50..99: Item.btAppraisalLevel:= 21;//����
                      100..149: Item.btAppraisalLevel:= 31;//����
                      150..249: Item.btAppraisalLevel:= 41;//����
                      250..65535: Item.btAppraisalLevel:= 51;//����
                    end;
                  end;
                end;
                44: begin
                  if g_Config.boUseCanKamPo then begin
                    if StdItem.Shape = 255 then begin
                      Item.btValue[0]:= Random(4)+ 1;//���ؾ���
                      Item.DuraMax:= Random(1500) + 1;//������ 20110512
                    end else
                    if StdItem.Shape = 253 then begin//��ħ��ý
                      Item.btValue[11]:= g_Config.nMaxAuraValue;
                      Item.Dura:= g_Config.nMaxAuraValue;
                      Item.DuraMax:= g_Config.nMaxAuraValue;
                    end;
                  end;
                end;
                {$IFEND}
                15,16, 19..24, 26:begin//ͷ��,����,����,����,��ָ
                   if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then
                     GetUnknowItemValue(Item);//����װ��
                   {$IF M2Version <> 2}
                   if g_Config.boUseCanKamPo then begin
                     Item.btAppraisalLevel:= 1;
                      K:= GetItemPoint(Item^, StdItem^, False);
                      case K of
                             0:;
                         1..49: Item.btAppraisalLevel:= 11;//һ��
                        50..99: Item.btAppraisalLevel:= 21;//����
                        100..149: Item.btAppraisalLevel:= 31;//����
                        150..249: Item.btAppraisalLevel:= 41;//����
                        250..65535: Item.btAppraisalLevel:= 51;//����
                      end;
                   end;
                   {$IFEND}
                 end;
                17, 18:begin//������Ʒ,�����˷�ȫΪ�־�1 20090615
                   Item.Dura:=1;
                 end;
                2:begin
                   if (StdItem.AniCount = 21) and ((StdItem.Reserved = 0) or (StdItem.Reserved = 56)) then Item.Dura:=0;//��ħ�����ף����,��ѵ�ǰ�־�����Ϊ0
                 end;
                51:begin//�ۼ���Ʒ
                   if (StdItem.Shape = 0) or (StdItem.Shape = 1) or (StdItem.Shape = 2) then Item.Dura:=0;//�����顢�ڹ���,��ѵ�ǰ�־�����Ϊ0
                 end;
                8:begin//����Ʋ��� 20110225
                  case StdItem.Source of
                    0: Item.btValue[0]:= Random(3)+ 1;//��������ϵ�Ʒ��
                    1: Item.btValue[0]:= Random(3)+ 5;
                  end;
                end;
                60: begin//����,���վ��� 20080806
                  if StdItem.shape <> 0 then begin
                    Item.btValue[1]:= Round(LoWord(StdItem.DC) + Random(HiWord(StdItem.DC) + 1 - LoWord(StdItem.DC)));
                    if Item.btValue[1] = 0 then Item.btValue[1]:= Random(40) + 10;//�Ƶľƾ���
                    Item.btValue[0]:= Random(8);//�Ƶ�Ʒ��
                    if StdItem.Anicount = 2 then Item.btValue[2]:= Random(4) + 1;//ҩ��ֵ 20081210
                  end;
                end;//60
              end;
              Result := True;
              Break;
            end;
          end;
        end;//for
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.CopyToUserItemFromName',[g_sExceptionVer]));
  end;
end;

procedure TUserEngine.ProcessUserMessage(PlayObject: TPlayObject; DefMsg: pTDefaultMessage; Buff: PChar);
var
  sMsg: string;
  nCode: Byte;//20091006
begin
  nCode:= 0;
  if (DefMsg = nil) or (PlayObject = nil) then Exit;
  if PlayObject.m_boGhost then Exit;//20091006 ����
  nCode:= 1;
  try
    if Buff = nil then sMsg := ''
    else sMsg := StrPas(Buff);
    nCode:= 2;
    if DefMsg.nSessionID <> PlayObject.m_nSendMsgCount then begin//��M2������Ϣ�Ĵ�����һ�£��򲻴���˴η��,ͬʱ����������ͻ��˵�ֵ 20100109
      nCode:= 30;
      {$IF TESTMODE = 1}
      MainOutMessage('��Կ���� ID:'+inttostr(DefMsg.nSessionID)+'/Count:'+inttostr(PlayObject.m_nSendMsgCount));
      {$IFEND}
      PlayObject.UpdateSendMsgCount();//���½�ɫ�Ķ�̬��Կ(��WPE)
      Exit;
    end;
    //if {$IF M2Version <> 2}(DefMsg.Ident < 10000) or (DefMsg.Ident > 42000){$ELSE}(DefMsg.Ident > 70000){$IFEND} then Exit;//���ID�Ƿ�Ϸ�
    nCode:= 31;
    DefMsg.Ident:= bb(DefMsg.Ident, PlayObject.m_nRandomKey);//��Ϣ���� 20091026
    nCode:= 3;
    case DefMsg.Ident of
      CM_SPELL: begin //3017
          //if PlayObject.GetSpellMsgCount <=2 then  //����������г�������ħ���������򲻼������
          if g_Config.boSpellSendUpdateMsg then begin //ʹ��UpdateMsg ���Է�ֹ��Ϣ�������ж������
            nCode:= 4;
            PlayObject.SendUpdateMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param,
              DefMsg.Series),
              sMsg{''});//20090518 �޸�
          end else begin
            nCode:= 5;
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog),
              HiWord(DefMsg.Recog),
              MakeLong(DefMsg.Param,
              DefMsg.Series),
              sMsg{''});//20090518 �޸�
          end;
        end;
      CM_QUERYUSERNAME, CM_HEROATTACKTARGET, CM_HEROPROTECT: begin //80
          nCode:= 6;
          PlayObject.SendMsg(PlayObject, DefMsg.Ident, 0, DefMsg.Recog, DefMsg.Param {x}, DefMsg.Tag {y}, '');
        end;
      CM_DROPITEM,
        CM_HERODROPITEM,
        CM_TAKEONITEM,
        CM_TAKEOFFITEM,


      CM_PlAYDRINKDLGSELECT,
        CM_MERCHANTQUERYSELLPRICE,
        CM_USERSELLITEM,
        CM_USERBUYITEM,
        CM_USERGETDETAILITEM,

      CM_SENDSELLOFFITEM,
        CM_SENDSELLOFFITEMLIST, //����
        CM_SENDQUERYSELLOFFITEM, //����
        CM_SENDBUYSELLOFFITEM, //����

      CM_HEROTAKEONITEM,
        CM_HEROTAKEOFFITEM,

      //CM_TAKEOFFITEMHEROBAG, //װ�����µ�Ӣ�۰���
      //  CM_TAKEOFFITEMTOMASTERBAG, //װ�����µ����˰���

      CM_SENDITEMTOMASTERBAG, //Ӣ�۰��������˰���
        CM_SENDITEMTOHEROBAG, //���˰�����Ӣ�۰���
      CM_ASSESSMENTHERO,//����Ӣ��
      CM_CHOOSEHEROJOB,//������ѡ����ְҵ(�����ѡ���ĸ�ְҵӢ�۳�ս)
      CM_SHOWHEROLEVEL,//����Ӣ�۵ȼ�������ʾ����
      CM_HEROAUTOPRACTICE,//Ӣ����������
      CM_HEROTAKEONITEMFORMMASTERBAG, //�����˰�����װ����Ӣ�۰���
      CM_TAKEONITEMFORMHEROBAG, //��Ӣ�۰�����װ�������˰���
      CM_REPAIRFIRDRAGON,//���տͻ�������:�޲�����֮��
      CM_REPAIRDRAGONINDIA,//�޲�����ӡ

      CM_REPAIRDRAGON,//�޲�ף����.ħ��� 20080102
      CM_DBLREPAIRDRAGON,
      
      CM_CREATEGROUP,
      CM_ADDGROUPMEMBER,
      CM_DELGROUPMEMBER,
      CM_USERREPAIRITEM,
      CM_MERCHANTQUERYREPAIRCOST,
      CM_DEALTRY,
      CM_DEALADDITEM,
      CM_DEALDELITEM,
      CM_CHALLENGETRY,//�ͻ��˵���ս 20080705
      CM_CHALLENGEADDITEM,//��Ұ���Ʒ�ŵ���ս����
      CM_CHALLENGEDELITEM,//��Ҵ���ս����ȡ����Ʒ
      CM_CHALLENGECANCEL,//���ȡ����ս
      CM_CHALLENGECHGGOLD,//�ͻ��˰ѽ�ҷŵ���ս����
      CM_CHALLENGECHGDIAMOND,//�ͻ��˰ѽ��ʯ�ŵ���ս����
      CM_CHALLENGEEND,//��ս��Ѻ��Ʒ����
      CM_SELLOFFADDITEM,//Ԫ������ϵͳ �ͻ�����������Ʒ���������Ʒ  20080316
      CM_SELLOFFDELITEM,//�ͻ���ɾ��������Ʒ�������Ʒ  20080316
      CM_SELLOFFCANCEL,//�ͻ���ȡ��Ԫ������  20080316
      CM_SELLOFFEND, //�ͻ���Ԫ�����۽���  20080316
      CM_CANCELSELLOFFITEMING, //ȡ�����ڼ��۵���Ʒ 20080318(������)
      CM_SELLOFFBUYCANCEL,//ȡ������ ��Ʒ���� 20080318(������)
      CM_SELLOFFBUY,//ȷ�����������Ʒ 20080318
      {$IF M2Version <> 2}
      CM_REPAIRFINEITEM,//�޲�����ʯ
      CM_REFINEITEM, //�ͻ��˷��ʹ�����Ʒ 20080507
      CM_CLICKMMISSION,//�򿪳ɳ����񴰿� 20100801
      CM_MERCHANTQUERYARMSEXCHANGEPRICE,//��װ���ŵ����׿�ȡװ�����õľ�����Ƭ�� 20100812
      CM_USERARMSEXCHANGE,//�ͻ��˶һ�������Ƭ
      CM_AUTOGAMEGIRDUPSKILL99,//�Զ���������(ǿ����)
      CM_CLOSEGAMEGIRDUPSKILL99,//ȡ���Զ�����(ǿ����)
      CM_QUERYGAMEGIRDUPSKILL99,//��ѯʣ����������(ǿ����)
      CM_USERKAMPO,//�ͻ��˼�����Ʒ
      CM_NewUSERKAMPO,
      CM_USERCHANGEKAMPO,//�ͻ��˸�����Ʒ
      CM_OPENQUERYPROFICIENCY,//��ѯ���ؽ����������
      CM_OPENSCROLLFRM,//�򿪾��ᴰ�ڣ�ȡ����ֵ������ֵ
      CM_USERMAKESCROLL,//�ͻ���ʹ����Ƥ���������ؾ���
      CM_USERSCROLLCHANGEITME,//�ͻ���ʹ�����ؾ�������������
      CM_TAKEONSPIRITITEM,//����ý�ŵ���ýλ��
      CM_TAKEOFFSPIRITITEM,//����ýλ������Ʒ
      CM_USERJUDGE,//�ͻ���Ʒ��
      CM_USERFINDJEWEL,//ʹ����ý��������
      CM_SETUSERTITLES,//�ͻ������óƺ�
      CM_SETSHOWFENGHAO,//�ڹ��������سƺ�
      CM_CALLFENGHAO,//�ٻ����ͳƺ���Ա
      CM_RECYCFENGHAO,//���ճƺ�
      CM_AGREECALLFENGHAO,//ͬ���ٻ�����(����ʹ�߻�����)
      CM_CANCELCALLFENGHAO,//ȡ���ٻ�����
      CM_WORLDFLY,//��������ͼ����(������)
      CM_CLOSEDOMINATETOKEN,//�ر�������
      CM_FENGHAOAGREE,//�����ƺ�ȷ�� 20110313
      CM_NGMAGICLVEXP,//�ͻ��˵���ڹ���������ϵġ�������
      {$IFEND}
      CM_USERSTORAGEITEM,
      CM_USERARMSTEARITEM,//�ͻ��˷�����Ҫ��ֵ���Ʒ��Ϣ 20100708
      CM_USERPLAYDRINKITEM, //��ƿ� 20080515
      CM_USERTAKEBACKSTORAGEITEM,
      CM_USERMAKEDRUGITEM,
      CM_GUILDADDMEMBER,
      CM_GUILDDELMEMBER,
      CM_GUILDUPDATENOTICE,
      CM_OPENBOXS,
      CM_OPENNEWBOXS,//�±���ģʽ 20090225
      CM_OPEN9YEARSBOXS,//��9���걦��
      CM_OPENNEW9YEARSBOXS,//���������
      CM_BUYNEWBOXSKEY,//�����±����Կ�� 20090225
      CM_MOVEBOXS, //ת������ ��ģʽ
      CM_ROTATIONBOX,//ת������ ��ģʽ
      CM_UPDADEBOXSITMES,//��䱦����Ʒ
      CM_GET9YEARSBOXSITEM,//ȡ9���걦����Ʒ
      CM_OPENFREE9YEARSBOXS,//����ѽ�������
      CM_BUY9YEARSBOXSKEY,//����9���걦���Կ��
      CM_UPDATA9YEARSBOXSITEM,//����9����������Ʒ
      CM_CHECK9YEARSBOXSKEY,//�������ʼѡ�񡱣����ж��Ƿ���Կ�ף�ûԿ�ף�����ʾ����      
      CM_GETFREE9YEARSBOXSITEM,//ȡ20����ѽ���������Ʒ
      CM_GETBOXS, //ȡ�ñ�����Ʒ
      {$IF HEROVERSION = 1}
      CM_SELGETHERO, //ȡ��Ӣ�� 20080514
      {$IFEND}
      CM_PlAYDRINKGAME, //��ȭ����
      CM_BEGINMAKEWINE,//��ʼ���(���Ѳ���ȫ���ϴ���) 20080620
      CM_REQUESTGUILDWAR,//�лᴰ�������л�ս 20090510
      CM_CLICKSIGHICON, //�����̾��
      {$IF M2Version = 1}
      CM_CLICKBATTERNPC,//����NPCִ�д����ű��� 20090623
      CM_SKILLTOJINGQING,//�����澭
      CM_AUTOGAMEGIRDUPSKILL95,//�Զ�������ת����
      CM_CLOSEGAMEGIRDUPSKILL95,
      CM_QUERYGAMEGIRDUPSKILL95,
      CM_LIANQIPRACTICE,//��������,�������
      CM_CLENTGETLIANQIPRACTICE,//��ȡ������Ʒ
      CM_OPENUPSKILL95,//��ͨ��ת99��
      {$IFEND}
      CM_CLICKCRYSTALEXPTOP, //�����ؽᾧ��þ��� 20090202
      CM_DrinkUpdateValue,
      CM_USERPLAYDRINK,
      CM_GUILDALLY,
      CM_GUILDBREAKALLY,
      CM_ITEMMERGER,//�ͻ��˺ϲ���Ʒ 20090615
      CM_EXERCISEKIMNEEDLE,//�ͻ��˿�ʼ���� 20090620
      CM_GUILDUPDATERANKINFO: begin
          nCode:= 7;
          PlayObject.SendMsg(PlayObject,   //����Ϣ���ݴ���ObjBase��Ԫ
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      {$IF M2Version = 1}
      CM_USEBATTERSPELL,//ʹ������ 20090624
      {$IFEND}
      {$IF M2Version <> 2}
      CM_DIVISIONUPDATENOTICE,//�޸����ɹ���
      CM_DIVISIONDDELMEMBER,//ɾ�����ɳ�Ա
      CM_AGREEAPPLYDIVISION,//�����ϴ�ͬ����������
      CM_CANCELAPPLYDIVISION,//�����ϴ�ȡ����������
      CM_APPLYDIVISION,//����(ȡ��)������
      CM_NAMEQUERYDIVISIONLIST,//���������ɴ��ڰ���ʦ����ѯ
      CM_SAVVYHEARTSKILL,//���������ķ�
      {$IFEND}
      CM_SELFSHOPBUY,//�����̯��Ʒ 20100701
      CM_RefineArmyDrum, // ������Ʒ�����ģ�
      CM_PASSWORD : begin
          nCode:= 8;
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Param,
            DefMsg.Recog,
            DefMsg.Series,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      CM_MERCHANTDLGSELECT,
      CM_SELFSHOPITEMS,//���������̵� 20100701
      CM_PETSMONHAPPLOG,//ι����־��ҳ
      CM_MOVETOPETSMON,//���͵���������
      CM_SELFCLOSESHOP,//��̯ 20100701
      CM_CLICKSHOP,//���˲鿴�����̵���Ʒ
      CM_ITEMSPLIT,//�ͻ��˲����Ʒ 20090615
      {$IF M2Version = 1}
      CM_OPENPULSEPOINT,//�ͻ��˵��Ѩλ 20090621
      CM_PRACTICEPULSE,//�ͻ����������� 20090623
      {$IFEND}
      {$IF M2Version <> 2}
      CM_QUERYDIVISIONLIST,//���������ɴ��ڷ�ҳ
      CM_DIVISIONMEMBERLIST,//ȡ���ɳ�Ա����
      CM_DIVISIONAPPLYLIST,//ȡ���������б�
      CM_DIVISIONHOME,//��������ҳ
      CM_OPENDIVISIONDLG,//�����ɶԻ���
      CM_DIVISIONGETFENGHAO,//�����ϴ���"�ƺ���ȡ"
      CM_INCHEATRPOINT,//���Exp������ִ��QF�ű���(999�ķ����չ���)
      CM_CHANGESAVVYHEARTSKILL,//�ı������ķ�����
      {$IFEND}
      CM_ADJUST_BONUS: begin //1043
          nCode:= 9;
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            sMsg);
        end;
      CM_BATTERHIT1,//׷�Ĵ� 20090625
      CM_BATTERHIT2,//����ɱ 20090703
      CM_BATTERHIT3,//��ɨǧ�� 20090703
      CM_BATTERHIT4:{����ն} begin
          nCode:= 10;
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Tag,
            LoWord(DefMsg.Recog), {x}
            HiWord(DefMsg.Recog), {y}
            0,
            '');
        end;
      CM_HORSERUN,
        CM_TURN,
        CM_WALK,
        CM_SITDOWN,
        CM_RUN,
        CM_HIT,
        CM_HEAVYHIT,
        CM_BIGHIT,

      {$IF M2Version <> 2}
      CM_USERDIGJEWELITME,//�ͻ����ڱ�
      CM_LONGHITFORFENGHAO,//�ۺ��ɱ
      CM_DAILYFORFENGHAO,//���շۺ�Ч��
      CM_FIREHITFORFENGHAO,//�һ�ۺ�Ч��
      {$IFEND}
      CM_POWERHIT,
        CM_LONGHIT,
        CM_LONGHIT4,//�ļ���ɱ
        CM_CRSHIT,//����
        CM_TWNHIT,//����ն�ػ�
        CM_QTWINHIT,//����ն��� 20080212
        CM_CIDHIT,//��Ӱ����
        CM_WIDEHIT,
        CM_WIDEHIT4,//Բ���䵶
        CM_PHHIT,
        CM_DAILY,//���ս���
        CM_BLOODSOUL,//Ѫ��һ��(ս)
        CM_HIT_107,//�ݺὣ��
        CM_FIREHIT,{�һ�}
        CM_4FIREHIT{4���һ� 20080112}: begin
          if g_Config.boActionSendActionMsg then begin //ʹ��UpdateMsg ���Է�ֹ��Ϣ�������ж������
            nCode:= 11;
            PlayObject.SendUpdateMsgA(PlayObject,//20100203 �滻SendActionMsg����
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end else begin
            nCode:= 12;
            PlayObject.SendMsg(PlayObject,
              DefMsg.Ident,
              DefMsg.Tag,
              LoWord(DefMsg.Recog), {x}
              HiWord(DefMsg.Recog), {y}
              0,
              '');
          end;
        end;
      CM_SAY: begin
          nCode:= 13;
          if DefMsg.Recog > 0 then begin
            PlayObject.m_btHearMsgFColor := LoByte(DefMsg.Param);
            PlayObject.m_btWhisperMsgFColor := HiByte(DefMsg.Param);
          end else begin
            PlayObject.m_btHearMsgFColor := g_Config.btHearMsgFColor;
            PlayObject.m_btWhisperMsgFColor := g_Config.btWhisperMsgFColor;
          end;
          PlayObject.SendMsg(PlayObject, CM_SAY, 0, 0, 0, 0, DeCodeString(sMsg));
        end;
      CM_QUERYUSERLEVELSORT: begin
          nCode:= 14;
          PlayObject.SendUpdateMsg(PlayObject, DefMsg.Ident, 0, DefMsg.Param, DefMsg.Tag, DefMsg.Recog, '');
        end;
      CM_HEROGOTETHERUSESPELL: begin//ʹ�úϻ�
          nCode:= 15;
          PlayObject.SendUpdateMsg(PlayObject, DefMsg.Ident, 0, 0, 0, 0, '');
        end;
      CM_OPENSHOP: begin
          nCode:= 16;
          PlayObject.SendMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            '');
        end;
      CM_BUYSHOPITEMGIVE,CM_EXCHANGEGAMEGIRD: begin  //����,����һ� 20080302
         nCode:= 17;
         PlayObject.SendUpdateMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,sMsg);
      end;
      CM_BUYSHOPITEM: begin
          nCode:= 18;
          PlayObject.SendUpdateMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;
      CM_LOGINNOTICEOK,
      CM_QUERYBAGITEMS,
      CM_QUERYUSERSTATE,
      CM_EAT,
      CM_WANTMINIMAP,
      CM_OPENGUILDDLG,
      CM_GROUPMODE,
      CM_MAGICKEYCHANGE,
      CM_RECALLHERO,
      CM_HEROLOGOUT,
      CM_QUERYHEROBAGITEMS,
      CM_PICKUP,//1001
      CM_HEROCHGSTATUS,//5006
      CM_SOFTCLOSE,//1009
      CM_BUTCH,//1007
      CM_HEROEAT,//5043
      CM_DEALEND,//1030
      CM_HEROMAGICKEYCHANGE,//1046
      CM_HEROAUTOOPENDEFENCE,//20151
      CM_OPENDOOR,//1002
      CM_GUILDMEMBERLIST,//1037
      CM_DEALCANCEL,//1028
      CM_DEALCHGGOLD,//1029
      CM_DROPGOLD,//1016
      CM_GUILDHOME,//1036
      CM_CLIENTPUNISHMENT,//20220
      CM_QUERYHEROBAGCOUNT,//5029
      {$IF M2Version = 1}
      CM_OPENHEROPULSEPOINT,//20225
      CM_HEROPRACTICEPULSE,//20227
      CM_HEROUSEBATTERTOMON,//20231
      {$IFEND}
      CM_PLAYDICELabel,
      CM_CLICKNPC: begin
        PlayObject.SendMsg(PlayObject, DefMsg.Ident, DefMsg.Series, DefMsg.Recog, DefMsg.Param, DefMsg.Tag, sMsg);
      end;
    else begin
        //nCode:= 19;
        //MainOutMessage('δ������Ϣ:'+inttostr(DefMsg.Ident)+' Code:'+inttostr(aa(DefMsg.Ident,PlayObject.m_nRandomKey)));
        //PlayObject.SendMsg(PlayObject, DefMsg.Ident, DefMsg.Series, DefMsg.Recog, DefMsg.Param, DefMsg.Tag, sMsg);//20091026 ��̬��Ϣ��ע��
      end;
    end;
    nCode:= 20;
    if PlayObject.m_boReadyRun then begin
      case DefMsg.Ident of
        CM_TURN, CM_WALK, CM_SITDOWN, CM_RUN, CM_HIT, CM_HEAVYHIT, CM_BIGHIT, CM_POWERHIT, CM_LONGHIT,CM_LONGHIT4{�ļ���ɱ},
        {$IF M2Version <> 2}CM_LONGHITFORFENGHAO{�ۺ��ɱ},CM_FIREHITFORFENGHAO{�һ�ۺ�},CM_DAILYFORFENGHAO{���շۺ�Ч��},{$IFEND}
        {$IF M2Version = 1}CM_BATTERHIT1{׷�Ĵ�},CM_BATTERHIT2{����ɱ},CM_BATTERHIT3{��ɨǧ��},CM_BATTERHIT4{����ն},{$IFEND}
        CM_WIDEHIT{����}, CM_WIDEHIT4{Բ���䵶}, CM_FIREHIT{�һ�}, CM_4FIREHIT{4���һ�}, CM_CRSHIT{���µ�},CM_DAILY{���ս��� 20080511},
        CM_BLOODSOUL{Ѫ��һ��(ս)}, CM_HIT_107{�ݺὣ��},
        CM_PHHIT{�ƻ�ն},CM_TWNHIT{����ն�ػ�}, CM_QTWINHIT{����ն��� 20080212},CM_CIDHIT{��Ӱ����}: begin
            Dec(PlayObject.m_dwRunTick, 100);
          end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine::ProcessUserMessage Code:%d Ident:%d',[g_sExceptionVer, nCode, DefMsg.Ident]));
  end;
end;

{procedure TUserEngine.SendServerGroupMsg(nCode, nServerIdx: Integer;//20101022 ע��
  sMsg: string);
begin
  if nServerIndex = 0 then begin
    FrmSrvMsg.SendSocketMsg(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end else begin
    FrmMsgClient.SendSocket(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end;
end;}

//��������
function TUserEngine.AddPlayObject(PlayObject: TPlayObject; nX, nY: Integer; sMonName: string): TBaseObject;
var
  Map: TEnvirnoment;
  Cert: TBaseObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
  UserItem: pTUserItem;
  UserMagic: pTUserMagic;
  MonsterMagic: pTUserMagic;
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := nil;
 // Cert := nil;//δʹ�� 20080408
  Map := g_MapManager.FindMap(PlayObject.m_sMapName);
  if Map = nil then Exit;
  Cert := TPlayMonster.Create;
  if Cert <> nil then begin
    Cert.m_PEnvir := Map;
    Cert.m_sMapName := PlayObject.m_sMapName;
    Cert.m_nCurrX := nX;
    Cert.m_nCurrY := nY;
    Cert.m_btDirection := Random(8);
    Cert.m_sCharName := sMonName;
    Cert.m_Abil := PlayObject.m_Abil;
    Cert.m_Abil.HP := Cert.m_Abil.MaxHP;
    Cert.m_Abil.MP := Cert.m_Abil.MaxMP;
    //TPlayMonster(Cert).GetAbility(PlayObject.m_Abil);
    //Cert.m_WAbil := Cert.m_Abil;// 20080418 ע��
    Cert.m_WAbil := PlayObject.m_WAbil;//20080418
    Cert.m_btJob := PlayObject.m_btJob;
    Cert.m_btGender := PlayObject.m_btGender;
    Cert.m_btHair := PlayObject.m_btHair;
    Cert.m_btRaceImg := PlayObject.m_btRaceImg;
    Cert.m_boProtectionDefence := PlayObject.m_boProtectionDefence; //�Ƿ�ѧ��������� 20091126
    for I := Low(THumanUseItems) to High(THumanUseItems) do begin//9��װ��+4��װ��
      if PlayObject.m_UseItems[I].wIndex > 0 then begin
        StdItem := GetStdItem(PlayObject.m_UseItems[I].wIndex);
        if StdItem <> nil then begin
          New(UserItem);
          if CopyToUserItemFromName(StdItem.Name, UserItem) then begin
            UserItem^.btValue:= PlayObject.m_UseItems[I].btValue;//20080418  �÷������֧�ּ�Ʒװ��
            UserItem^.Dura:= PlayObject.m_UseItems[I].Dura;//20090203 �����װ���־��������һ��
            UserItem^.DuraMax:= PlayObject.m_UseItems[I].DuraMax;//20090207 �����װ���־��������һ��
            UserItem.btAppraisalLevel := PlayObject.m_UseItems[I].btAppraisalLevel;
            UserItem.btUnKnowValueCount := PlayObject.m_UseItems[I].btUnKnowValueCount;
            UserItem.btAppraisalValue := PlayObject.m_UseItems[I].btAppraisalValue;
            Move(PlayObject.m_UseItems[I].btUnKnowValue   , UserItem^.btUnKnowValue, SizeOf(UserItem^.btUnKnowValue));//20101107
            TPlayMonster(Cert).AddItems(UserItem, I);
          end else Dispose(UserItem);//20080820 �޸�
        end;
      end;
    end;

    if PlayObject.m_MagicList.Count > 0 then begin//20080629
      for I := 0 to PlayObject.m_MagicList.Count - 1 do begin //���ħ��
        UserMagic := PlayObject.m_MagicList.Items[I];
        if UserMagic <> nil then begin
          if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin//Ӣ�۷���������弼�ܿ������Ӽ��� 20100903
            if UserMagic.btKey = 0 then begin
              if UserMagic.wMagIdx in [SKILL_46,SKILL_60,SKILL_61,SKILL_62,SKILL_63,SKILL_64,SKILL_65,SKILL_95,SKILL_97,SKILL_101,SKILL_103] then Continue;//����
              New(MonsterMagic);
              MonsterMagic.MagicInfo := UserMagic.MagicInfo;
              MonsterMagic.wMagIdx := UserMagic.wMagIdx;
              MonsterMagic.btLevel := UserMagic.btLevel;
              MonsterMagic.btKey := UserMagic.btKey;
              MonsterMagic.nTranPoint := UserMagic.nTranPoint;
              Cert.m_MagicList.Add(MonsterMagic);
              {$IF M2Version <> 2}
              if UserMagic.MagicInfo.wMagicId = SKILL_99 then TPlayMonster(Cert).m_Magic99Skill:= UserMagic; //ǿ���� 20100817
              {$IFEND}
            end;
          end else begin
            if UserMagic.wMagIdx in [SKILL_46,SKILL_60,SKILL_61,SKILL_62,SKILL_63,SKILL_64,SKILL_65,SKILL_95,SKILL_97,SKILL_101,SKILL_103] then Continue;//����
            New(MonsterMagic);
            MonsterMagic.MagicInfo := UserMagic.MagicInfo;
            MonsterMagic.wMagIdx := UserMagic.wMagIdx;
            MonsterMagic.btLevel := UserMagic.btLevel;
            MonsterMagic.btKey := UserMagic.btKey;
            MonsterMagic.nTranPoint := UserMagic.nTranPoint;
            Cert.m_MagicList.Add(MonsterMagic);
            {$IF M2Version <> 2}
            if UserMagic.MagicInfo.wMagicId = SKILL_100 then TPlayMonster(Cert).m_Magic100Skill:= UserMagic; //���ؽ��
            {$IFEND}
          end;
        end;
      end;
    end;

    TPlayMonster(Cert).InitializeMonster; {��ʼ��}

    Cert.RecalcAbilitys;

    if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;
    Cert.Initialize();
    if Cert.m_boAddtoMapSuccess then begin
      p28 := nil;
      if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
      else n20 := 3;
      if (Cert.m_PEnvir.m_nHeight < 250) then begin
        if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
        else n24 := 20;
      end else n24 := 50;
      n1C := 0;
      while (True) do begin
        try//20101126 ����,��ֹ�쳣��,��ѭ��  SB �쳣���˳���
          if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
            if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
              Inc(Cert.m_nCurrX, n20);
            end else begin
              Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
              if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
                Inc(Cert.m_nCurrY, n20);
              end else begin
                Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
              end;
            end;
          end else begin
            p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
            Break;
          end;
        except
        end;
        Inc(n1C);
        if n1C >= 31 then Break;
      end;
      if p28 = nil then begin
        //Cert.Free;
        //Cert := nil;
        FreeAndNil(Cert);//����һ��By TasNat at: 2012-11-10 11:43:31
      end;
    end;
  end;
  Result := Cert;
end;

function TUserEngine.AddBaseObject(sMapName: string; nX, nY: Integer; nMonRace: Integer; sMonName: string): TBaseObject; //004AD56C
var
  Map: TEnvirnoment;
  Cert: TBaseObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
  nCode:byte;
begin
  Result := nil;
  Cert := nil;
  nCode:= 0;
  try
    Map := g_MapManager.FindMap(sMapName);
    nCode:= 1;
    if Map = nil then Exit;
    nCode:= 11;
    case nMonRace of
      11: Cert := TSuperGuard.Create; //����ʿ(���������������ı���)
      20: Cert := TArcherPolice.Create; //û��   2007.11.26
      51: begin                       //������ӥ   2007.11.26
          Cert := TMonster.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(3500) + 3000;
          Cert.m_nBodyLeathery := 50;
        end;
      52: begin                      //¹��������    2007.11.26
          if Random(30) = 0 then begin
            Cert := TChickenDeer.Create;
            Cert.m_boAnimal := True;
            Cert.m_nMeatQuality := Random(20000) + 10000;
            Cert.m_nBodyLeathery := 150;
          end else begin
            Cert := TMonster.Create;
            Cert.m_boAnimal := True;
            Cert.m_nMeatQuality := Random(8000) + 8000;
            Cert.m_nBodyLeathery := 150;
          end;
        end;
      53: begin                   //��   2007.11.26
          Cert := TATMonster.Create;
          Cert.m_boAnimal := True;
          Cert.m_nMeatQuality := Random(8000) + 8000;
          Cert.m_nBodyLeathery := 150;
        end;
      55: begin                  //����ʦ
          Cert := TTrainer.Create;
          Cert.m_btRaceServer := 55;
        end;
      78: Cert := TNoAttackMon.Create;//�������Ĺ֣��������� 20090524
      79: Cert := TWealthAnimalMon.Create;//������ 20090517
      80: Cert := TMonster.Create;      //������  Tmonster���� ��ʼ��   2007.11.26
      81: Cert := TATMonster.Create;    //��������Ĺ���,���뷶Χ�Զ�����
      82: Cert := TSpitSpider.Create;   //������ʱ���¶��Ĺ���  2x2��Χ�ڶ�Һ����-��
      83: Cert := TSlowATMonster.Create; //Ҳ����������  ������  ��� ������
      84: Cert := TScorpion.Create;      //Ы��
      85: Cert := TStickMonster.Create;  //ʳ�˻�
      86: Cert := TATMonster.Create;     //����
      87: Cert := TDualAxeMonster.Create;//Ͷ��ͷ���ֹ��� (Զ�̹���)
      88: Cert := TATMonster.Create;     //����սʿ
      89: Cert := TATMonster.Create;     //����ս��   ���þ���   �������һ����
      90: Cert := TGasAttackMonster.Create;//����
      91: Cert := TMagCowMonster.Create;   //��������
      92: Cert := TCowKingMonster.Create;  //�������  ���й�������ħ��(�������������ڷ�Χ��ʱ��˲��)
      93: Cert := TThornDarkMonster.Create;//����սʿ  ��Ͷ�����  Ҳ��Զ�̹���(3�񹥻�)
      94: Cert := TLightingZombi.Create;   //�罩ʬ
      95: begin                            //ʯĹʬ��   �ӵ���ð�����Ĺ�
          Cert := TDigOutZombi.Create;
          if Random(2) = 0 then Cert.bo2BA := True;
        end;
      96: begin                           //��ʬ,һ�����ʣ���������Ը���
          Cert := TZilKinZombi.Create;
          if Random(4) = 0 then Cert.bo2BA := True;//�������ǽ
        end;
      97: begin
          Cert := TCowMonster.Create;    //����սʿ   ������ʿ  �����  ������
          if Random(2) = 0 then Cert.bo2BA := True;
        end;
      98: Cert := TSwordsmanMon.Create; //����ո���,��Ӱ���� 2���ڿ��Թ����Ĺ� 20090123
      99: Cert := TIceEyesTroll.Create;//���۾�ħ(�ٻ���ħ����)
      100: Cert := TWhiteSkeleton.Create;  //��������, ��ʿ�ٻ��ı���
      101: begin//�������  ������ʿ ����տ�ʼ�Ǻڵ�(���뷶Χ���ʯ��״̬����)
          Cert := TScultureMonster.Create;
          Cert.bo2BA := True;
        end;
      102: Cert := TScultureKingMonster.Create;//�������
      103: Cert := TBeeQueen.Create;//�д�����
      104: Cert := TArcherMonster.Create;//���깭����  ħ�������� �����(6�����)
      105: Cert := TGasMothMonster.Create;//Ш��
      106: Cert := TGasDungMonster.Create;//���
      107: Cert := TCentipedeKingMonster.Create; //������  ���ܶ��Ĺ��
      108: begin
          Cert := {TFairyMonster}TPsycheMonster.Create;   //����
          Cert.bo2BA := True;//�������ǽ 20080327
        end;
      109: Cert := TAutoPathFindMon.Create;//Ѱ·��,�ڳ���
      110: Cert := TCastleDoor.Create;  //ɳ�Ϳ˵� ����
      111: Cert := TWallStructure.Create; //ɳ�Ϳ˵� ��ǽ,�У���
      112: Cert := TArcherGuard.Create;  //����������� NPC
      113: Cert := TElfMonster.Create;   //����
      114: Cert := TElfWarriorMonster.Create; //����1
      115: Cert := TBigHeartMonster.Create;   //���¶�ħ  ǧ������  �ӵ���ð�̵�  ���ܶ��Ĺ�
      116: Cert := TSpiderHouseMonster.Create; //���ڿ��� �����ֵ� ��
      117: Cert := TExplosionSpider.Create;   //��Ӱ֩��
      118: Cert := THighRiskSpider.Create;   //����֩��
      119: Cert := TBigPoisionSpider.Create; //����֩��
      120: Cert := TSoccerBall.Create;       //�ɻ�����   ��ʵ��������
      121: Cert := TGiantSickleSpiderATMonster.Create;//����֩�� 20080809
      122: Cert := TSalamanderATMonster.Create;//���Ȼ����� 20080809
      123: Cert := TTempleGuardian.Create;//ʥ����ʿ 20080809
      124: Cert := TheCrutchesSpider.Create;//����֩�� 20080809
      125: Cert := TYanLeiWangSpider.Create;//�������� 20080811
      126: Cert := TSnowyFireDay.Create;//ѩ������ħ �������,��ʩ�ź춾 20090113
      127: Cert := TDevilBat.Create;//��ħ����ʩ����,������,����,Ұ��������Ч,ֻ�е�ʿ��ħ�������ס,ֻ��սʿ��ɱ�ĵ�2���ܹ�����,������ʽ���������Ա�����
      128: Cert := TFireDragon.Create;//����ħ��(���ɶ���Ⱥ�׹��������Ȧ�����������ػ��޹���)
      129: Cert := TFireDragonGuard.Create;//�����ػ��� 20090111
      130: Cert := TSnowyHanbing.Create;//ѩ�򺮱�ħ:����������ʩ���̶� 20090113
      131: Cert := TSnowyWuDu.Create;//ѩ���嶾ħ:������,������ 20090113
      132: Cert := TShengSuMonster.Create;//ʥ��(����ʱ��)
      133: Cert := TShengSuWarriorMonster.Create;//ʥ��1(վʱ��)
      134: Cert := TIceEyesTrollAvatar.Create;//���۾�ħ(Ѫ������һ��ʱ,�����BOSS��) 20101118
      135: Cert := TArcherGuardMon.Create; //���ƹ����ֵĹ�,ֻ����� 20080121
      136: Cert := TArcherGuardMon1.Create; //�����ƶ�,���ṥ���Ĺ�(ħ����Ĺ�)
      137: Cert := TSnowBodyguards.Create;//ѩ�����
      138: Cert := TSnowWarWill.Create;//ѩ��ս��
      139: Cert := TSnowBeelzebub.Create;//ѩ��ħ��
      140: Cert := TSnowDaysWillBe.Create;//ѩ���콫
      141: Cert := TSnowGuardian.Create;//ѩ����ʿ
      142: Cert := TRedFox.Create;//��ͨ���(�׵�����������)
      143: Cert := TRedFoxWang.Create;//�����(�׵���������������������Ч)
      144: Cert := TSuFox.Create;//��ͨ�غ�(����������Ч������)
      145: Cert := TSuFoxWang.Create;//�غ���(����������Ч����������������Ч)
      146: Cert := TBlackFox.Create;//�ں�(���ɱ����)
      147: Cert := TBlackFoxWang.Create;//�ں���(���ɱ��������������Ч)
      148: Cert := TMagicEye.Create;//����֮��:���Ա�����,��ʱ��ų�һ��2*2��ǽ
      149: Cert := TMagicEye1.Create;//����ħ��:���Ա�����,��ʱ��ų�һ�ѻ�ǽ
      150: Cert := TPlayMonster.Create;//���ι�
      151: Cert := TSoulStone.Create;//��β��ʯ(�����ƶ�,ȫ������,����Ч,������,���ǻ��꼼��,�����ܷų��ĸ���ǿ����)
      152: Cert := TWormMonster.Create;//���»���,���½ǳ�
      153: Cert := TFoxBeads.Create;//��������(HP����66.5%ʱ,�ٻ��ĸ���β��ʯ,�ܷ��䶳��,���̶�)
      154: begin//���飬����Ŀ�����
          Cert := TFireFairyMonster.Create;
          Cert.bo2BA := True;//�������ǽ
        end;
      155: Cert := TNewFireDragon.Create;//����2(�ҽ����������Ȧ�����������ػ��޹���)
      156: Cert := TMagicEye2.Create;//���:�����ƶ�, �ܵ�����������3�룬Ȼ��ը������ʮ�ֻ�ǽ Ŀ���ܵ���ǽ�˺���������
      157: Cert := TZhuFireMon.Create;//��ħ:�����������ͷ����,���ܻ�ǽ�˺�;�ܵ�������,�᳢������2��Χ�����,������������
      158: Cert := TPetsMon.Create;//�����:������,�ܹ�������Ѫ,���������ƶ���ͼ,��ͼ�ػ�,���ܶ�
      159: Cert := TWhiteSkeletonEx.Create;//ǿ����������, ��ʿ�ٻ��ı���
      160: Cert := TWhiteTigerMonster.Create;//�׻���,����1��Ⱥ���Ѫ,������ͬ����3���Ѫ
      200: Cert := TElectronicScolpionMon.Create; //�д��о�
    end;
    nCode:= 2;
    if Cert <> nil then begin
      nCode:= 3;
      MonInitialize(Cert, sMonName);//�����ʼ����HP֮�����Ը�ֵ
      nCode:= 4;
      Cert.m_PEnvir := Map;
      Cert.m_sMapName := sMapName;
      Cert.m_nCurrX := nX;
      Cert.m_nCurrY := nY;
      Cert.m_btDirection := Random(8);
      Cert.m_sCharName := sMonName;
      Cert.m_WAbil := Cert.m_Abil;
      nCode:= 5;
      if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;
      nCode:= 6;
      MonGetRandomItems(Cert);//ȡ�ù�����Ա���Ʒ
      nCode:= 7;
      Cert.Initialize();
      nCode:= 8;
      case nMonRace of
         78: TNoAttackMon(Cert).AddItemsFromConfig;//�������Ĺ֣���������(��ȡ��̽����Ʒ) 20090524
        108: {TFairyMonster}TPsycheMonster(Cert).nWalkSpeed:= Cert.m_nWalkSpeed;//��������DB���õ���·�ٶ� 20090105
        121: TGiantSickleSpiderATMonster(Cert).AddItemsFromConfig;//����֩��(��ȡ��̽����Ʒ) 20080810
        122: TSalamanderATMonster(Cert).AddItemsFromConfig;//���Ȼ�����(��ȡ��̽����Ʒ) 20080810
        123: TTempleGuardian(Cert).AddItemsFromConfig;//ʥ����ʿ(��ȡ��̽����Ʒ) 20080810
        124: TheCrutchesSpider(Cert).AddItemsFromConfig;//����֩��(��ȡ��̽����Ʒ) 20080810
        125: TYanLeiWangSpider(Cert).AddItemsFromConfig;//��������(��ȡ��̽����Ʒ) 20080815
        136:begin//20080124 136���Զ��߶� ħ�����
           if {(CompareText(Cert.m_sMapName, m_sMapName_136) = 0) and }//20090204
              (m_nCurrX_136 <> 0) and (m_nCurrY_136 <> 0) then begin
              Cert.m_nCurrX := m_nCurrX_136;
              Cert.m_nCurrY := m_nCurrY_136;
              TArcherGuardMon1(Cert).m_NewCurrX:= m_NewCurrX_136;
              TArcherGuardMon1(Cert).m_NewCurrY:= m_NewCurrY_136;
              TArcherGuardMon1(Cert).m_boWalk:= True;
            end;
         end;
        150:begin//���͹�
           Cert.m_nCopyHumanLevel := 0;
           Cert.m_Abil.MP := Cert.m_Abil.MaxMP;
           Cert.m_Abil.HP := Cert.m_Abil.MaxHP; //���ݿ�HPΪ0,ʹ��һ�������� 20080120
           Cert.m_WAbil := Cert.m_Abil;
           TPlayMonster(Cert).InitializeMonster; //��ʼ�����ι���,���ļ�����(����,װ��)
           Cert.RecalcAbilitys;
         end;
         154: TFireFairyMonster(Cert).nWalkSpeed:= Cert.m_nWalkSpeed;//�������DB���õ���·�ٶ�
      end;//case
      nCode:= 9;
      if Cert.m_boAddtoMapSuccess then begin
        p28 := nil;
        nCode:= 91;
        if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
        else n20 := 3;
        if (Cert.m_PEnvir.m_nHeight < 250) then begin
          if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
          else n24 := 20;
        end else n24 := 50;
        n1C := 0;
        nCode:= 92;
        while (True) do begin
          try//20101126 ����,��ֹ�쳣��,��ѭ��
            if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
              if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
                Inc(Cert.m_nCurrX, n20);
              end else begin
                Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
                if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
                  Inc(Cert.m_nCurrY, n20);
                end else begin
                  Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
                end;
              end;
            end else begin
              p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
              Break;
            end;
          except
          end;
          Inc(n1C);
          if n1C >= 31 then Break;
        end;//while
        nCode:= 93;
        if p28 = nil then begin
          //Cert.Free;
          //Cert := nil;
          FreeAndNil(Cert);//����һ��By TasNat at: 2012-11-10 11:43:31
          Exit;//20090813 ����
        end;
        {nCode:= 94;
        if Cert <> nil then Inc(Cert.m_nViewRange, 2); //2006-12-30 �����Ӿ�+2 20100614 ע��}
        nCode:= 12;
      end;

      nCode:= 12;
      case Cert.m_btRaceServer of//20090203 ȡ�ػ�����
        150: begin
          nCode:= 13;
          TPlayMonster(Cert).m_nProtectTargetX:= Cert.m_nCurrX;//�ػ�����
          TPlayMonster(Cert).m_nProtectTargetY:= Cert.m_nCurrY;//�ػ�����
        end;
        158: begin
          TPetsMon(Cert).m_nProtectTargetX:= Cert.m_nCurrX;//�ػ�����
          TPetsMon(Cert).m_nProtectTargetY:= Cert.m_nCurrY;//�ػ�����
          TPetsMon(Cert).m_nHappiness:= Cert.m_dwFightExp;//���ֶ�
        end;
      end;
      nCode:= 14;
      Result := Cert;
    end;
  except
    Result := nil;//20090705 ����
    //MainOutMessage('{�쳣} TUserEngine.AddBaseObject MonRace:'+ inttostr(nMonRace)+' Code:'+inttostr(nCode));
  end;
end;
//====================================================
//����:�����������
//����ֵ����ָ��ʱ���ڴ���������򷵼�TRUE���������ָ��ʱ���򷵻�FALSE
//====================================================
function TUserEngine.RegenMonsters(MonGen: pTMonGenInfo; nCount: Integer): Boolean;
var
  dwStartTick: LongWord;
  I, nX, nY, J: Integer;
  Cert: TBaseObject;
begin
  Result := True;
  dwStartTick := GetTickCount();
  try
    if MonGen <> nil then begin
      if (MonGen.nRace > 0) and (nCount > 0) then begin
        J:= 0;
        if Random(100) < MonGen.nMissionGenRate then begin//�Ƿ���ˢ��
          nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          for I := 0 to nCount - 1 do begin
            Cert := AddBaseObject(MonGen.sMapName, ((nX - 10) + Random(20)), ((nY - 10) + Random(20)), MonGen.nRace, MonGen.sMonName);
            if Cert <> nil then begin
              Cert.m_nChangeColorType := MonGen.nChangeColorType; //�Ƿ��ɫ
              Cert.m_btNameColor:= MonGen.nNameColor;//�Զ������ֵ���ɫ 20080810
              if MonGen.nNameColor <> 255 then Cert.m_boSetNameColor:= True;//20081001 �Զ���������ɫ
              Cert.m_boIsNGMonster:= MonGen.boIsNGMon;//�ڹ���,����������������ֵ 20081001
              Cert.m_boIsHeroPulsExpMon:= MonGen.boIsHeroPulsMon;//Ӣ�۾��羭���
              MonGen.CertList.Add(Cert);
              Inc(J);
            end;
            if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
              if nCount > J then Result := False;//20110527�޸�
              Break;
            end;
          end;//for
        end else begin
          for I := 0 to nCount - 1 do begin
            nX := (MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
            nY := (MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
            Cert := AddBaseObject(MonGen.sMapName, nX, nY, MonGen.nRace, MonGen.sMonName);
            if Cert <> nil then begin
              Cert.m_nChangeColorType := MonGen.nChangeColorType; //�Ƿ��ɫ
              Cert.m_btNameColor:= MonGen.nNameColor;//�Զ������������ɫ 20080810
              if MonGen.nNameColor <> 255 then Cert.m_boSetNameColor:= True;//20081001 �Զ���������ɫ
              Cert.m_boIsNGMonster:= MonGen.boIsNGMon;//�ڹ���,����������������ֵ 20081001
              Cert.m_boIsHeroPulsExpMon:= MonGen.boIsHeroPulsMon;//Ӣ�۾��羭���
              MonGen.CertList.Add(Cert);
              Inc(J);
            end;
            if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
              if nCount > J then Result := False;//20110527�޸�
              Break;
            end;
          end;//for
        end;
      end;
    end;  
  except
    MainOutMessage(Format('{%s} TUserEngine::RegenMonsters',[g_sExceptionVer]));
  end;
end;

//ȡʦ���� 20080512
function TUserEngine.GetMasterObject(sName: string): TPlayObject;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boGhost) then begin
          if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then begin
            if CompareText(PlayObject.m_sMasterName, sName) = 0 then begin
              Result := PlayObject;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetPlayObject(sName: string): TPlayObject;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  if (m_PlayObjectList.Count > 0) and (sName <> '') then begin//20090926 (sName <> '')
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      if CompareText(m_PlayObjectList.Strings[I], sName) = 0 then begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (not PlayObject.m_boGhost) then begin
            if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then
              Result := PlayObject;
          end;
          Break;
        end;
      end;
    end;
  end;
end;
//20110612 �������ֲ����Ƿ���ڷ����ĳ���
function TUserEngine.GetPetsMonObject(sName: string): TBaseObject;
var
  I, n18, nX, nY, nNameColor: Integer;
  mon: TBaseObject;
  MonGen: pTMonGenInfo;
  LoadList: TStringList;
  sFileName, sTime, sMonName, sHapp, sMap, sX, sY, sNameColor: string;
  boCanMon: Boolean;
  IniFile: TIniFile;
begin
  Result := nil;
  sFileName:= Format('%sPetsMon\%d\PetsMon.txt',[g_Config.sEnvirDir, g_Config.GlobalVal[High(g_Config.GlobalVal)]]);
  if (sName <> '') then begin
    boCanMon:= False;
    if FileExists(sFileName) then begin//���������ļ����Ƿ����������Ϣ
      IniFile := TIniFile.Create(sFileName);
      try
        sMonName := IniFile.ReadString(sName, '����', '');
        if sMonName <> '' then boCanMon:= True;
      finally
        IniFile.Free;
      end;
    end;
    try
      n18 := m_MonGenList.Count - 1;
      if n18 < 0 then n18 := 0;
      MonGen := m_MonGenList.Items[n18];
      if MonGen <> nil then begin
        for I := 0 to MonGen.CertList.Count - 1 do begin
          mon := TBaseObject(MonGen.CertList.Items[I]);
          if mon <> nil then begin
            if (not mon.m_boDeath) and (not mon.m_boGhost) and (mon.m_btRaceServer = 158) then begin
              if CompareText(TPetsMon(mon).m_sMasterName, sName) = 0 then begin
                if boCanMon then begin
                  Result := mon;
                  Break;
                end else begin
                  mon.m_boNoItem := True;
                  mon.m_WAbil.HP := 0;
                  mon.MakeGhost;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    except
      Result := nil;
    end;
  end;
end;
//���������б����ݶ���
procedure TUserEngine.MakePetsMonObject(LoadList: TStringList);
var
  I, n18, nX, nY, nNameColor: Integer;
  mon: TBaseObject;
  PlayObject: TPlayObject;
  sName, sTime, sMonName, sHapp, sMap, sX, sY, sNameColor: string;
begin
  if LoadList.Count > 0 then begin
    sTime:= LoadList.Strings[0];
    LoadList.Delete(0);
    if sTime <> '' then begin
      sTime := GetValidStr3(sTime, sName, [' ']);//��ɫ��
      sTime := GetValidStr3(sTime, sMonName, [' ']);//������
      sTime := GetValidStr3(sTime, sHapp, [' ']);//���ֶ�
      sTime := GetValidStr3(sTime, sMap, [' ']);//��ͼ
      sTime := GetValidStr3(sTime, sX, [' ']);//X
      sTime := GetValidStr3(sTime, sY, [' ']);//Y
      sTime := GetValidStr3(sTime, sNameColor, [' ']);//������ɫ

      nX := Str_ToInt(sX, 0);
      nY := Str_ToInt(sY, 0);
      nNameColor := Str_ToInt(sNameColor, 0);
      if nNameColor > 255 then nNameColor:=255;
      if GetPetsMonObject(sName)= nil then begin//��Ϸ��û��һ���������ֵĳ���ʱ�Ŵ���
        mon := RegenMonsterByName(sMap, nX, nY, sMonName);
        if (mon <> nil) then begin
          if mon.m_btRaceServer = 158 then begin
            if g_Config.boMasterTimeRoyalty then
              mon.m_dwMasterRoyaltyTick := g_Config.dwMasterTimeRoyaltyTime* (60 * 1000)
            else
            mon.m_dwMasterRoyaltyTick := 86400000;//�ѱ�ʱ��
            Mon.m_dwMasterRoyaltyTime := GetTickCount;
            mon.m_btSlaveMakeLevel := 3;
            mon.m_btSlaveExpLevel := 1;
            mon.m_btNameColor:= nNameColor;
            mon.m_boSetNameColor:= True;
            TPetsMon(mon).m_nHappiness:= Str_ToInt(sHapp, 0);
            TPetsMon(mon).m_sMasterName:= sName;
            PlayObject:= GetPlayObjectEx1(sName);
            if PlayObject <> nil then begin//��������
              mon.m_Master := PlayObject;
              PlayObject.m_SlaveList.Add(mon);
              PlayObject.m_nPetsMonHappiness:= TPetsMon(mon).m_nHappiness;
              PlayObject.m_sPetsMonName:= mon.m_sCharName;
            end;
          end else mon.m_boDeath:= True;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetPlayObjectEx1(sName: string): TPlayObject;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  if (m_PlayObjectList.Count > 0) and (sName <> '') then begin
    I:= m_PlayObjectList.IndexOf(sName);
    if I > -1 then begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boAI) and (not PlayObject.m_boDeath) and (not PlayObject.m_boGhost) then begin
          if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then
            Result := PlayObject;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetPlayObject(PlayObject: TBaseObject): TPlayObject;
var
  I: Integer;
begin
  Result := nil;
  if m_PlayObjectList.Count > 0 then begin
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      if (PlayObject <> nil) then begin
        if (PlayObject = TPlayObject(m_PlayObjectList.Objects[I])) then begin
          Result := TPlayObject(m_PlayObjectList.Objects[I]);
          Break;
        end;
      end;
    end;
  end;
end;
{$IF HEROVERSION = 1}
//20071227 ��Ӣ�����ֲ���Ӣ��
function TUserEngine.GetHeroObject(sName: string): TBaseObject;
var
  I: Integer;
  PlayObject: TBaseObject;
begin
  Result := nil;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]).m_MyHero;
      if PlayObject <> nil then begin
        if CompareText(PlayObject.m_sCharName, sName) = 0 then begin
          Result := PlayObject;
          Break;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetHeroObject(HeroObject: TBaseObject): TPlayObject;
var
  I: Integer;
begin
  Result := nil;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      if (HeroObject <> nil) then begin
        if (HeroObject = TPlayObject(m_PlayObjectList.Objects[I]).m_MyHero) then begin
          Result := TPlayObject(m_PlayObjectList.Objects[I]);
          Break;
        end;
      end;
    end;
  end;
end;
{$IFEND}
//�߳�����
procedure TUserEngine.KickPlayObjectEx(sAccount, sName: string);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if m_PlayObjectList.Count > 0 then begin
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and
            (CompareText(m_PlayObjectList.Strings[I], sName) = 0) then begin
            PlayObject.m_boEmergencyClose := True;
            PlayObject.m_boPlayOffLine := False;
            Break;
          end;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.GetPlayObjectEx(sAccount, sName: string): TPlayObject;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if m_PlayObjectList.Count > 0 then begin//20081008
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and
            (CompareText(m_PlayObjectList.Strings[I], sName) = 0) then begin
            {if PlayObject.m_boNotOnlineAddExp then begin
              PlayObject.m_boNotOnlineAddExp := False;
            end else begin
              Result := PlayObject;
            end;}
            Result := PlayObject; //20080716 �滻
            Break;
          end;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
//��ȡ���߹�����
function TUserEngine.GetPlayObjectExOfAutoGetExp(sAccount: string): TPlayObject;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    if m_PlayObjectList.Count > 0 then begin//20081008
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (CompareText(PlayObject.m_sUserID, sAccount) = 0) and PlayObject.m_boNotOnlineAddExp then begin
            Result := PlayObject;
            Break;
          end;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;
//���ҽ���NPC
function TUserEngine.FindMerchant(Merchant: TObject): TMerchant;
var
  I: Integer;
begin
  Result := nil;
  m_MerchantList.Lock;
  try
    if m_MerchantList.Count > 0 then begin//20081008
      for I := 0 to m_MerchantList.Count - 1 do begin
        if (TObject(m_MerchantList.Items[I]) <> nil) then begin
          if (TObject(m_MerchantList.Items[I]) = Merchant) then begin
            Result := TMerchant(m_MerchantList.Items[I]);
            Break;
          end;
        end;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

function TUserEngine.FindNPC(GuildOfficial: TObject): TGuildOfficial;
var
  I: Integer;
begin
  Result := nil;
  if QuestNPCList.Count > 0 then begin//20081008
    for I := 0 to QuestNPCList.Count - 1 do begin
      if (TObject(QuestNPCList.Items[I]) <> nil) then begin
        if (TObject(QuestNPCList.Items[I]) = GuildOfficial) then begin
          Result := TGuildOfficial(QuestNPCList.Items[I]);
          Break;
        end;
      end;
    end;
  end;
end;

function TUserEngine.GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY,
  nRange: Integer): Integer;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then begin
          if (abs(PlayObject.m_nCurrX - nX) < nRange) and (abs(PlayObject.m_nCurrY - nY) < nRange) then Inc(Result);
        end;
      end;
    end;
  end;
end;
//ȡ����Ȩ��
function TUserEngine.GetHumPermission(sUserName: string; var sIPaddr: string; var btPermission: Byte): Boolean; //4AE590
var
  I: Integer;
  AdminInfo: pTAdminInfo;
begin
  Result := False;
  btPermission := g_Config.nStartPermission;
  m_AdminList.Lock;
  try
    if m_AdminList.Count > 0 then begin//20081008
      for I := 0 to m_AdminList.Count - 1 do begin
        AdminInfo := m_AdminList.Items[I];
        if AdminInfo <> nil then begin
          if CompareText(AdminInfo.sChrName, sUserName) = 0 then begin
            btPermission := AdminInfo.nLv;
            sIPaddr := AdminInfo.sIPaddr;
            Result := True;
            Break;
          end;
        end;
      end;
    end;
  finally
    m_AdminList.UnLock;
  end;
end;
{//20080522 ע��
procedure TUserEngine.GenShiftUserData;
begin

end;}

procedure TUserEngine.AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
begin
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_LoadPlayList.AddObject(UserOpenInfo.sChrName, TObject(UserOpenInfo));
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;
//�߳���������
procedure TUserEngine.KickOnlineUser(sChrName: string);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if CompareText(PlayObject.m_sCharName, sChrName) = 0 then begin
          PlayObject.m_boKickFlag := True;
          Break;
        end;
      end;
    end;
  end;
end;

function TUserEngine.SendSwitchData(PlayObject: TPlayObject; nServerIndex: Integer): Boolean;
begin
  Result := True;
end;

procedure TUserEngine.SendChangeServer(PlayObject: TPlayObject; nServerIndex: Integer);
var
  sIPaddr: string;
  nPort: Integer;
resourcestring
  sMsg = '%s/%d';
begin
  if GetMultiServerAddrPort(nServerIndex, sIPaddr, nPort) then begin
    PlayObject.SendDefMessage(SM_RECONNECT, 0, 0, 0, 0, Format(sMsg, [sIPaddr, nPort]));
  end;
end;
//������������
procedure TUserEngine.SaveHumanRcd(PlayObject: TPlayObject);
var
  SaveRcd: pTSaveRcd;
  nCode: Byte;
begin
  nCode:= 0;
  try
    if PlayObject <> nil then begin//20090104
      nCode:= 4;
      if PlayObject.m_boOperationItemList or PlayObject.m_boAI then Exit;//20080928 ��ֹͬʱ���������б�ʱ����
      nCode:= 5;
      if PlayObject.m_boRcdSaveding then Exit;//�Ƿ����ڱ������� 20090106 ��ֹͬ�������
      PlayObject.m_boRcdSaveding:= True;
      nCode:= 6;
      try
        New(SaveRcd);
        FillChar(SaveRcd^, SizeOf(TSaveRcd), #0);
        nCode:= 1;
        SaveRcd.sAccount := PlayObject.m_sUserID;
        SaveRcd.sChrName := PlayObject.m_sCharName;
        SaveRcd.nSessionID := PlayObject.m_nSessionID;
        SaveRcd.PlayObject := PlayObject;
        SaveRcd.nReTryCount := 0;
        SaveRcd.dwSaveTick := GetTickCount;
        SaveRcd.boIsHero := False;
        SaveRcd.boSaveing := False;//20090509
        nCode:= 2;
        PlayObject.MakeSaveRcd(SaveRcd.HumanRcd);
        nCode:= 3;
        if FrontEngine.UpDataSaveRcdList(SaveRcd) then Dispose(SaveRcd);
      finally
        PlayObject.m_boRcdSaveding:= False;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.SaveHumanRcd Code:%d.%p',[g_sExceptionVer, nCode, ExceptAddr]));
  end;
end;
{$IF HEROVERSION = 1}
function TUserEngine.RegenMyHero(PlayObject: TPlayObject; nX, nY: Integer;
  HumanRcd: THumDataInfo; NewHeroDataInfo: TNewHeroDataInfo; nType: Byte): TBaseObject;
var
  BaseObject: TBaseObject;
  n18: Integer;
  MonGen: pTMonGenInfo;
  nCode: byte;
begin
  Result := nil;//20090707
  nCode:= 0;
  try
    BaseObject := AddHeroObject(PlayObject, nX, nY, HumanRcd, NewHeroDataInfo, nType);
    nCode:= 1;
    if BaseObject <> nil then begin
      nCode:= 2;
      n18 := m_MonGenList.Count - 1;
      if n18 < 0 then n18 := 0;
      nCode:= 3;
      MonGen := m_MonGenList.Items[n18];
      if MonGen <> nil then begin//20090213
        nCode:= 4;
        MonGen.CertList.Add(BaseObject);
        nCode:= 5;
        BaseObject.m_PEnvir.AddObject(1);
        BaseObject.m_boAddToMaped := True;
      end;
      Result := BaseObject;//20090707
    end;
    //Result := BaseObject;
  except
    MainOutMessage(Format('{%s} TUserEngine.RegenMyHero Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TUserEngine.AddHeroObject(PlayObject: TPlayObject; nX, nY: Integer; HumanRcd: THumDataInfo; NewHeroDataInfo: TNewHeroDataInfo; nType{����ְҵ}: Byte): TBaseObject;
var
  Map: TEnvirnoment;
  Cert: THeroObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
  nCode: Byte;
begin
  Result := nil;
  nCode:= 0;
  try
    //Cert := nil;//20080408 δʹ��
    Map := g_MapManager.FindMap(PlayObject.m_sMapName);
    nCode:= 1;
    if Map = nil then Exit;
    nCode:= 2;
    Cert := THeroObject.Create;
    if Cert <> nil then begin
      Cert.m_boAI := PlayObject.m_boAI;
      nCode:= 3;
      if not Cert.m_boAI then begin
        GetHeroData(Cert, HumanRcd, NewHeroDataInfo, PlayObject.m_boCallDeputyHero, nType); //ȡӢ�۵�����
      end else begin
        Cert.m_sCharName := PlayObject.m_sHeroCharName;
        Cert.m_Master:= PlayObject;
      end;

      nCode:= 4;
      if Cert.m_sHomeMap = '' then begin //��һ���ٻ�
        Cert.m_sHomeMap := PlayObject.m_sHomeMap;
        Cert.m_nHomeX := PlayObject.m_nHomeX;
        Cert.m_nHomeY := PlayObject.m_nHomeY;
        case Cert.n_HeroTpye of
          0,2:Cert.m_Abil.Level := g_Config.nHeroStartLevel;//����Ӣ��
          1,3:Cert.m_Abil.Level := g_Config.nDrinkHeroStartLevel;//����Ӣ��
        end;
        Cert.m_boNewHuman := not Cert.m_boAI;
      end else begin
        Cert.m_sHomeMap := PlayObject.m_sHomeMap;
        Cert.m_nHomeX := PlayObject.m_nHomeX;
        Cert.m_nHomeY := PlayObject.m_nHomeY;
        Cert.m_boNewHuman := False;
      end;
      nCode:= 5;
      Cert.m_PEnvir := Map;
      Cert.m_sMapName := PlayObject.m_sMapName;
      Cert.m_nCurrX := nX;
      Cert.m_nCurrY := nY;
      Cert.m_btDirection := Random(8);
      nCode:= 6;
      if Cert.m_Abil.nExp <= 0 then Cert.m_Abil.nExp := 1;
      if Cert.m_Abil.nMaxExp <= 0 then begin
        Cert.m_Abil.nMaxExp := Cert.GetLevelExp(Cert.m_Abil.Level);
      end;
      nCode:= 7;
      Cert.m_btRaceImg := PlayObject.m_btRaceImg;
      nCode:= 8;
      if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;
      nCode:= 9;
      Cert.Initialize();
      Cert.GetBagItemCount;
      Cert.RecalcLevelAbilitys;
      Cert.RecalcAbilitys;
      if Cert.m_boAI then begin
        Cert.m_WAbil.HP := Cert.m_WAbil.MaxHP;
        Cert.m_WAbil.MP := Cert.m_WAbil.MaxMP;
      end;
      if Cert.m_boAddtoMapSuccess then begin
        p28 := nil;
        if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
        else n20 := 3;
        if (Cert.m_PEnvir.m_nHeight < 250) then begin
          if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
          else n24 := 20;
        end else n24 := 50;
        n1C := 0;
        nCode:= 10;
        while (True) do begin
          try//20101126 ����,��ֹ�쳣��,��ѭ��
            if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
              if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
                Inc(Cert.m_nCurrX, n20);
              end else begin
                Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
                if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
                  Inc(Cert.m_nCurrY, n20);
                end else begin
                  Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
                end;
              end;
            end else begin
              p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
              Break;
            end;
          except
          end;
          Inc(n1C);
          if n1C >= 31 then Break;
        end;
        nCode:= 11;
        if p28 = nil then begin
          //Cert.Free;
          //Cert := nil;
          FreeAndNil(Cert);//����һ��By TasNat at: 2012-11-10 11:43:31
        end;
      end;
    end;
    nCode:= 12;
    Result := Cert;
  except
    MainOutMessage(Format('{%s} TUserEngine.AddHeroObject Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

procedure TUserEngine.SaveHeroRcd(PlayObject: TPlayObject);
var
  SaveRcd: pTSaveRcd;
  nCode: Byte;
begin
  nCode:= 0;
  try
    if PlayObject <> nil then begin//20090106
      nCode:= 1;
      if PlayObject.m_MyHero <> nil then begin
        if PlayObject.m_MyHero.m_boOperationItemList and (not PlayObject.m_boHeroLogOut) then begin
          Exit;//20080210 ��ֹͬʱ���������б�ʱ����(û�ջ�Ӣ�۵������)
        end;
        if not THeroObject(PlayObject.m_MyHero).m_boAI then begin
          nCode:= 2;
          New(SaveRcd);
          FillChar(SaveRcd^, SizeOf(TSaveRcd), #0);
          SaveRcd.sAccount := PlayObject.m_sUserID;
          nCode:= 3;
          SaveRcd.sChrName := PlayObject.m_MyHero.m_sCharName;
          SaveRcd.nSessionID := PlayObject.m_nSessionID;
          SaveRcd.PlayObject := PlayObject;
          SaveRcd.nReTryCount := 0;
          SaveRcd.dwSaveTick := GetTickCount;
          SaveRcd.boIsHero := True;
          SaveRcd.boSaveing := False;//20090509 ����
          SaveRcd.boIsNewHero:= THeroObject(PlayObject.m_MyHero).m_boIsBakData;//�Ƿ��ٻ�Ӣ��Ϊ����
          nCode:= 4;
          THeroObject(PlayObject.m_MyHero).MakeSaveRcd(SaveRcd.HumanRcd, SaveRcd.NewHeroDataInfo);
          nCode:= 5;
          if FrontEngine.UpDataSaveRcdList(SaveRcd) then Dispose(SaveRcd);
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.SaveHeroRcd Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
{$IFEND}
//���������б�
procedure TUserEngine.AddToHumanFreeList(PlayObject: TPlayObject);
begin
  PlayObject.m_dwGhostTick := GetTickCount();
  m_PlayObjectFreeList.Add(PlayObject);
end;
{//20080522 ע��
function TUserEngine.GetSwitchData(sChrName: string; nCode: Integer): pTSwitchDataInfo;
var
  I: Integer;
  SwitchData: pTSwitchDataInfo;
begin
  Result := nil;
  for I := 0 to m_ChangeServerList.Count - 1 do begin
    SwitchData := m_ChangeServerList.Items[I];
    if SwitchData <> nil then begin
      if (CompareText(SwitchData.sChrName, sChrName) = 0) and (SwitchData.nCode = nCode) then begin
        Result := SwitchData;
        Break;
      end;
    end;
  end;
end;  }
//ȡ���ݿ����������
procedure TUserEngine.GetHumData(PlayObject: TPlayObject; var HumanRcd: THumDataInfo);
var
  HumData: pTHumData;
  HumItems: pTHumItems;
  HumAddItems: pTHumAddItems;
  BagItems: pTBagItems;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  HumMagics: pTHumMagics;
  HumNGMagics: pTHumNGMagics;//20081001
  UserMagic: pTUserMagic;
  MagicInfo: pTMagic;
  StorageItems: pTStorageItems;
  I: Integer;
  IniFile: TIniFile;
  sFileName, sMap, sX, sY: String;
begin
  HumData := @HumanRcd.Data;
  PlayObject.m_sCharName := HumData.sChrName;
  PlayObject.m_sMapName := HumData.sCurMap;
  PlayObject.m_nCurrX := HumData.wCurX;
  PlayObject.m_nCurrY := HumData.wCurY;
  PlayObject.m_btDirection := HumData.btDir;
  PlayObject.m_btHair := HumData.btHair;
  PlayObject.m_btGender := HumData.btSex;
  PlayObject.m_btJob := HumData.btJob;
  PlayObject.m_nGold := HumData.nGold;

  PlayObject.m_sLastMapName := PlayObject.m_sMapName; //2006-01-12���������ϴ��˳���ͼ
  PlayObject.m_nLastCurrX := PlayObject.m_nCurrX; //2006-01-12���������ϴ��˳���������X
  PlayObject.m_nLastCurrY := PlayObject.m_nCurrY; //2006-01-12���������ϴ��˳���������Y

  PlayObject.m_Abil.Level := HumData.Abil.Level;

  PlayObject.m_Abil.HP := MakeLong(HumData.Abil.HP, HumData.Abil.AC);//20091027 �޸�
  PlayObject.m_Abil.MP := MakeLong(HumData.Abil.MP, HumData.Abil.MAC);//20091027 �޸�
  PlayObject.m_Abil.MaxHP := MakeLong(HumData.Abil.MaxHP, HumData.Abil.DC);//20091027 �޸�
  PlayObject.m_Abil.MaxMP := MakeLong(HumData.Abil.MaxMP, HumData.Abil.MC);//20091027 �޸�

  PlayObject.m_Abil.nExp := HumData.Abil.nExp;
  PlayObject.m_Abil.nMaxExp := HumData.Abil.nMaxExp;
  PlayObject.m_Abil.Weight := HumData.Abil.Weight;
  PlayObject.m_Abil.MaxWeight := HumData.Abil.MaxWeight;
  PlayObject.m_Abil.WearWeight := HumData.Abil.WearWeight;
  PlayObject.m_Abil.MaxWearWeight := HumData.Abil.MaxWearWeight;
  PlayObject.m_Abil.HandWeight := HumData.Abil.HandWeight;
  PlayObject.m_Abil.MaxHandWeight := HumData.Abil.MaxHandWeight;
  PlayObject.m_Abil.Alcohol:= HumData.n_Reserved;//���� 20080622
  PlayObject.m_Abil.MaxAlcohol:=  HumData.n_Reserved1;//�������� 20080622
  if PlayObject.m_Abil.MaxAlcohol < g_Config.nMaxAlcoholValue then PlayObject.m_Abil.MaxAlcohol:= g_Config.nMaxAlcoholValue;//��������С�޳�ʼֵʱ,���޸� 20080623
  PlayObject.m_Abil.WineDrinkValue := HumData.n_Reserved2;//��ƶ� 2008623
  PlayObject.n_DrinkWineQuality := HumData.btUnKnow2[2];//����ʱ�Ƶ�Ʒ��
  PlayObject.n_DrinkWineAlcohol := HumData.UnKnow[4];//����ʱ�ƵĶ��� 20080624
  PlayObject.m_btUnParalysis := HumData.UnKnow[37];//�������ʣ��ʱ��By TasNat at: 2012-04-23 18:51:32
  PlayObject.m_btMagBubbleDefenceLevel := HumData.UnKnow[5];//ħ���ܵȼ� 20080811
  PlayObject.m_Abil.MedicineValue:= HumData.nReserved1; //��ǰҩ��ֵ 20080623
  PlayObject.m_Abil.MaxMedicineValue:= HumData.nReserved2; //ҩ��ֵ���� 20080623
  PlayObject.n_DrinkWineDrunk:=  HumData.boReserved3;//���Ƿ�Ⱦ����� 20080627

  PlayObject.dw_UseMedicineTime:= HumData.nReserved3; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ�� 20080623
  {$IF M2Version = 1}
  PlayObject.dw_UseMedicineTime1:= MakeLong(HumData.btDivorce, HumData.UnKnow[25]);//��������ʱ��
  if PlayObject.dw_UseMedicineTime1 <= 0 then PlayObject.dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;//���㳤ʱ��û�Ⱦ�
  {$IFEND}
  PlayObject.n_MedicineLevel:= HumData.n_Reserved3;  //ҩ��ֵ�ȼ� 20080623
  if PlayObject.n_MedicineLevel <= 0 then PlayObject.n_MedicineLevel:=1;//���ҩ��ֵ�ȼ�Ϊ0,������Ϊ1 20080624
  if PlayObject.m_Abil.MaxMedicineValue <= 0 then
    PlayObject.m_Abil.MaxMedicineValue:= PlayObject.GetMedicineExp(PlayObject.n_MedicineLevel);

  PlayObject.m_dwHighLevelKillMonFixExpTime := HumData.m_nReserved4;//�����ؼ�ʹ��ʱ�� 20090213
  if PlayObject.m_dwHighLevelKillMonFixExpTime > 0 then begin//�����ؼ�ʹ��ʱ�� ��Ϊ0ʱ����ʹ�øߵȼ����鲻��
    PlayObject.m_boHighLevelKillMonFixExp:= True;
  end else PlayObject.m_boHighLevelKillMonFixExp:= False;

  PlayObject.m_dwUseItmeChangMsgFColorTime := HumData.m_nReserved5;//ʹ����Ʒ�ı�˵����ɫ��ʹ��ʱ��(��) ����,����,���� 20090221
  if PlayObject.m_dwUseItmeChangMsgFColorTime > 0 then begin
    PlayObject.m_dwUseItmeChangMsgFColorType:= HumData.UnKnow[8];//��ɫ����
  end;
  PlayObject.m_boTrainingNG := HumData.UnKnow[6] <> 0;//�Ƿ�ѧϰ���ڹ� 20081002
  if PlayObject.m_boTrainingNG then begin
    PlayObject.m_NGLevel := MakeWord(HumData.UnKnow[7],HumData.UnKnow[33]);//�ڹ��ȼ� 20081204
  end else PlayObject.m_NGLevel := 0;
  PlayObject.m_ExpSkill69 := HumData.nExpSkill69;//�ڹ���ǰ���� 20080930
  PlayObject.m_Skill69NH := MakeLong(HumData.Abil.NG, HumData.Abil.MaxNG);//�ڹ���ǰ����ֵ 20110226
  PlayObject.GetSkill69Exp(PlayObject.m_NGLevel, PlayObject.m_Skill69MaxNH);//��������ֵ���� 20110226
  if PlayObject.m_Skill69NH < 0 then PlayObject.m_Skill69NH:= 0;
  if PlayObject.m_Skill69NH > PlayObject.m_Skill69MaxNH then PlayObject.m_Skill69NH:= PlayObject.m_Skill69MaxNH;
  PlayObject.m_nDecDamage:= HumData.m_nReserved1;//�������� 20090618

  PlayObject.m_PulseAddAC:= HumData.UnKnow[17];
  PlayObject.m_PulseAddAC1:= HumData.UnKnow[18];
  PlayObject.m_PulseAddMAC:= HumData.UnKnow[19];
  PlayObject.m_PulseAddMAC1:= HumData.UnKnow[20];
  PlayObject.m_boProtectionDefence:= HumData.UnKnow[26] = 1;//�Ƿ�ѧ��������� 20091126
  if g_Config.boClearGamePoint then
    PlayObject.m_ClearGamePointDate:= HumData.Reserved5;//��ʼ��Ϸ�������
{$IF M2Version = 1}
  PlayObject.m_boOpenupSkill95:= HumData.UnKnow[35] <> 0;//��ͨ��ת99��
  PlayObject.m_JingYuanValue:= HumData.Reserved3;//��ǰ��Ԫֵ
  PlayObject.m_Abil.TransferValue:= HumData.Reserved4;//��ǰ��תֵ
  PlayObject.m_InitialJingYuanDate:=HumData.Exp68;//��ʼ��Ԫֵ������

  PlayObject.m_boUser4BatterSkill:= HumData.UnKnow[29] <> 0;//ʹ�õ��ĸ����� 20100720
  PlayObject.m_boTrainBatterSkill:= HumData.UnKnow[21] <> 0;//�Ƿ�ѧϰ���������� 20090702
  PlayObject.m_SetBatterKey:= HumData.UnKnow[22];//��һ���������ܸ� 20090702
  PlayObject.m_SetBatterKey1:= HumData.UnKnow[23];//�ڶ����������ܸ� 20090702
  PlayObject.m_SetBatterKey2:= HumData.UnKnow[24];//�������������ܸ� 20090702
  PlayObject.m_SetBatterKey3:= HumData.UnKnow[28];//���ĸ��������ܸ� 20100719
//��������
  PlayObject.m_wHumanPulseArr[0].nPulsePoint:= HumData.UnKnow[9];
  if PlayObject.m_wHumanPulseArr[0].nPulsePoint >= 5 then PlayObject.m_wHumanPulseArr[0].boOpenPulse:= True;
  PlayObject.m_wHumanPulseArr[0].nPulseLevel:= HumData.UnKnow[10];

  PlayObject.m_wHumanPulseArr[1].nPulsePoint:= HumData.UnKnow[11];
  if PlayObject.m_wHumanPulseArr[1].nPulsePoint >= 5 then PlayObject.m_wHumanPulseArr[1].boOpenPulse:= True;
  PlayObject.m_wHumanPulseArr[1].nPulseLevel:= HumData.UnKnow[12];

  PlayObject.m_wHumanPulseArr[2].nPulsePoint:= HumData.UnKnow[13];
  if PlayObject.m_wHumanPulseArr[2].nPulsePoint >= 5 then PlayObject.m_wHumanPulseArr[2].boOpenPulse:= True;
  PlayObject.m_wHumanPulseArr[2].nPulseLevel:= HumData.UnKnow[14];

  PlayObject.m_wHumanPulseArr[3].nPulsePoint:= HumData.UnKnow[15];
  if PlayObject.m_wHumanPulseArr[3].nPulsePoint >= 5 then PlayObject.m_wHumanPulseArr[3].boOpenPulse:= True;
  PlayObject.m_wHumanPulseArr[3].nPulseLevel:= HumData.UnKnow[16];

  PlayObject.m_wHumanPulseArr[4].nPulsePoint:= HumData.UnKnow[32];//�澭
  if PlayObject.m_wHumanPulseArr[4].nPulsePoint >= 5 then PlayObject.m_wHumanPulseArr[4].boOpenPulse:= True;
{$IFEND}
  if PlayObject.m_Abil.nExp <= 0 then PlayObject.m_Abil.nExp := 1;
  if PlayObject.m_Abil.nMaxExp <= 0 then begin
    PlayObject.m_Abil.nMaxExp := PlayObject.GetLevelExp(PlayObject.m_Abil.Level);
  end;

  PlayObject.m_wStatusTimeArr := HumData.wStatusTimeArr;
  PlayObject.m_wStatusTimeArr[POISON_DONTMOVE] := 0;//�����������ƶ� 20090903
  if PlayObject.m_wStatusTimeArr[POISON_SKILLDECHEALTH] > 100 then PlayObject.m_wStatusTimeArr[POISON_SKILLDECHEALTH]:= 1;//���ж�����100���ʼ 20091107
  if PlayObject.m_wStatusTimeArr[POISON_STONE] > 100 then PlayObject.m_wStatusTimeArr[POISON_STONE]:= 1;//���ʱ�䳬��100�����ʼ 20091107
  if PlayObject.m_wStatusTimeArr[POISON_LOCKSPELL] > 100 then PlayObject.m_wStatusTimeArr[POISON_LOCKSPELL]:= 1;
  if PlayObject.m_wStatusTimeArr[STATE_TRANSPARENT] > 1000 then PlayObject.m_wStatusTimeArr[STATE_TRANSPARENT]:= 1;//����1000,���ʼ 20091107
  if PlayObject.m_wStatusTimeArr[STATE_DEFENCEUP] > 1000 then PlayObject.m_wStatusTimeArr[STATE_DEFENCEUP]:= 1;//��ʥս����  ��������1000,���ʼ 20091107
  if PlayObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP] > 1000 then PlayObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP]:= 1;//�����  ħ������1000,���ʼ 20091107
  if PlayObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 1000 then PlayObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//ħ���ܳ�1000,���ʼ 20091107

  PlayObject.m_sHomeMap := HumData.sHomeMap;
  PlayObject.m_nHomeX := HumData.wHomeX;
  PlayObject.m_nHomeY := HumData.wHomeY;
  PlayObject.m_BonusAbil := HumData.BonusAbil; // 08/09
  PlayObject.m_nBonusPoint := HumData.nBonusPoint; // 08/09
  PlayObject.m_btCreditPoint := HumData.btCreditPoint;
  PlayObject.m_btReLevel := HumData.btReLevel;

  PlayObject.m_sMasterName := HumData.sMasterName;
  PlayObject.m_boMaster := HumData.boMaster;
  if PlayObject.m_boMaster or (PlayObject.m_sMasterName <> '') then PlayObject.GetMasterNoList();//ȡʦͽ����
  PlayObject.m_sDearName := HumData.sDearName;

  PlayObject.m_sDeputyHeroName:= HumData.sHeroChrName1;//����Ӣ������ 20110130
  PlayObject.m_btDeputyHeroJob:= HumData.btStatus;//��ѡ����ְҵ 0-ս 1-�� 2-�� 3-�̿�
  PlayObject.m_nHeroLevel1:= HumData.m_nReserved2;//����Ӣ�۵ȼ�
  PlayObject.m_nHeroLevel2:= HumData.m_nReserved3;//����Ӣ�۵ȼ�
  PlayObject.m_nHeroNGLevel1:= HumData.m_nReserved7;//����Ӣ���ڹ��ȼ�
  PlayObject.m_nHeroNGLevel2:= HumData.m_nReserved8;//����Ӣ���ڹ��ȼ�
  PlayObject.m_nMainExp:= HumData.nLoyal;//�����ۼƾ���(�������ȼ���������3��ʱʹ��)
  PlayObject.m_nMainNGExp:= HumData.m_nReserved6;//�����ۼ��ڹ�����(�������ȼ���������3��ʱʹ��)
  PlayObject.m_boHeroAutoPractice:= HumData.UnKnow[27] = 1;//����Ӣ���Ƿ��Զ�����
  PlayObject.m_nHeroAutoPracticePlace:= LoByte(HumData.Abil.Sc);//�Զ�������������
  PlayObject.m_nHeroAutoPracticeStrength:= HiByte(HumData.Abil.Sc);//�Զ���������ǿ��
  PlayObject.m_HeroAutoPracticeTime:= HumData.MaxExp68;//�Զ������ۼ�ʱ��

  PlayObject.m_sStoragePwd := HumData.sStoragePwd;
  if PlayObject.m_sStoragePwd <> '' then PlayObject.m_boPasswordLocked := True;

  if HumData.nGameGold > 0 then PlayObject.m_nGameGold := HumData.nGameGold
  else PlayObject.m_nGameGold := 0;
  if HumData.nGameDiaMond > 0 then PlayObject.m_nGameDiaMond:= HumData.nGameDiaMond//20071226 ���ʯ
  else PlayObject.m_nGameDiaMond:= 0;
  if HumData.nGameGird > 0 then PlayObject.m_nGameGird:= HumData.nGameGird//20071226 ���
  else PlayObject.m_nGameGird:= 0;

  PlayObject.m_nKillMonExpRate:= HumData.nEXPRATE; //20071230 ���鱶��
  PlayObject.m_dwKillMonExpRateTime:= HumData.nExpTime; //20071230 ���鱶��ʱ��
  if PlayObject.m_dwKillMonExpRateTime < 0 then PlayObject.m_dwKillMonExpRateTime:= 1;//20090330 ����

  PlayObject.m_nOldKillMonExpRate := PlayObject.m_nKillMonExpRate;//20080607
  if (PlayObject.m_nKillMonExpRate <= 0) or (PlayObject.m_nKillMonExpRate > 10000) then PlayObject.m_nKillMonExpRate:= 100;//20090813 ��ֹ�����򸺱�������

  PlayObject.m_nGamePoint := HumData.nGamePoint;
  PlayObject.m_nPayMentPoint := HumData.nPayMentPoint;

  PlayObject.m_btGameGlory := HumData.btGameGlory; //���� 20080511

  PlayObject.m_nPkPoint := HumData.nPKPOINT;
  if HumData.btAllowGroup > 0 then PlayObject.m_boAllowGroup := True
  else PlayObject.m_boAllowGroup := False;
  PlayObject.btB2 := HumData.btF9;
  PlayObject.m_btAttatckMode := HumData.btAttatckMode;
  PlayObject.m_nIncHealth := HumData.btIncHealth;
  PlayObject.m_nIncSpell := HumData.btIncSpell;
  PlayObject.m_nIncHealing := HumData.btIncHealing;
  PlayObject.m_nFightZoneDieCount := HumData.btFightZoneDieCount;
  PlayObject.m_sUserID := HumData.sAccount;
  PlayObject.m_boLockLogon := HumData.boLockLogon;

  PlayObject.m_wContribution := HumData.wContribution;
  PlayObject.m_nHungerStatus := HumData.nHungerStatus;
  PlayObject.m_boAllowGuildReCall := HumData.boAllowGuildReCall;
  PlayObject.m_wGroupRcallTime := HumData.wGroupRcallTime;
  PlayObject.m_dBodyLuck := HumData.dBodyLuck;
  PlayObject.m_boAllowGroupReCall := HumData.boAllowGroupReCall;
  {PlayObject.m_QuestUnitOpen := HumData.QuestUnitOpen;
  PlayObject.m_QuestUnit := HumData.QuestUnit; }
  PlayObject.m_btLastOutStatus := HumData.btLastOutStatus; //�˳�״̬ 1Ϊ����
  PlayObject.m_wMasterCount := HumData.wMasterCount; //��ʦͽ����
  PlayObject.bo_YBDEAL:= HumData.btUnKnow2[0]= 1;//�Ƿ�ͨԪ������ 20080316
  PlayObject.m_nWinExp := HumData.n_WinExp;//20080221 ������  �ۼƾ���
  PlayObject.n_UsesItemTick:= HumData.n_UsesItemTick ;//������ۼ�ʱ�� 20080221
  PlayObject.m_QuestFlag := HumData.QuestFlag;
  PlayObject.m_boHasHero := HumData.boHasHero;
  PlayObject.m_boHasHeroTwo := HumData.boReserved1;//20080519 �Ƿ�������Ӣ��
  PlayObject.m_sHeroCharName := HumData.sHeroChrName;
  PlayObject.n_HeroSave := HumData.btUnKnow2[1];//�Ƿ񱣴�Ӣ�� 20080513
  PlayObject.n_myHeroTpye := HumData.btHeroType;//��ɫ���ϴ���Ӣ������������  20080515
  PlayObject.m_boPlayDrink:= HumData.boReserved;//�Ƿ������ T-����� 20080515

  PlayObject.m_GiveGuildFountationDate:=HumData.m_GiveDate;//������ȡ�л��Ȫ���� 20080625
  PlayObject.m_boMakeWine:= HumData.boReserved2;//�Ƿ���� 20080620
  PlayObject.m_MakeWineTime:= HumData.nReserved;//��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� 20080620
  PlayObject.n_MakeWineItmeType:=HumData.UnKnow[0];//��ƺ�,Ӧ�ÿ��Եõ��Ƶ����� 2008020
  PlayObject.n_MakeWineType:= HumData.UnKnow[1];//��Ƶ����� 1-��ͨ�� 2-ҩ��  20080620
  PlayObject.n_MakeWineQuality:= HumData.UnKnow[2];//��ƺ�,Ӧ�ÿ��Եõ��Ƶ�Ʒ�� 20080620
  PlayObject.n_MakeWineAlcohol:= HumData.UnKnow[3];//��ƺ�,Ӧ�ÿ��Եõ��Ƶľƾ��� 20080620

  HumItems := @HumanRcd.Data.HumItems;

  PlayObject.m_UseItems[U_DRESS] := HumItems[U_DRESS];
  PlayObject.m_UseItems[U_WEAPON] := HumItems[U_WEAPON];
  PlayObject.m_UseItems[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
  PlayObject.m_UseItems[U_NECKLACE] := HumItems[U_HELMET];
  PlayObject.m_UseItems[U_HELMET] := HumItems[U_NECKLACE];
  PlayObject.m_UseItems[U_ARMRINGL] := HumItems[U_ARMRINGL];
  PlayObject.m_UseItems[U_ARMRINGR] := HumItems[U_ARMRINGR];
  PlayObject.m_UseItems[U_RINGL] := HumItems[U_RINGL];
  PlayObject.m_UseItems[U_RINGR] := HumItems[U_RINGR];
  //�޸�1.76֧���ĸ�By TasNat at: 2012-10-20 11:34:20
  HumAddItems := @HumanRcd.Data.HumAddItems;
  PlayObject.m_UseItems[U_BUJUK] := HumAddItems[U_BUJUK];
  PlayObject.m_UseItems[U_BELT] := HumAddItems[U_BELT];
  PlayObject.m_UseItems[U_BOOTS] := HumAddItems[U_BOOTS];
  PlayObject.m_UseItems[U_CHARM] := HumAddItems[U_CHARM];
  PlayObject.m_UseItems[U_ZHULI] := HumAddItems[U_ZHULI];//20080416 ����
  PlayObject.m_UseItems[U_DRUM] := HumAddItems[U_DRUM];//20080416 ����
{$IF M2Version <> 2}

  PlayObject.m_nHeartType:= HumData.UnKnow[36];//�ķ�����
  PlayObject.m_sHeartName:= HumData.sHeartName;//�ķ�����
  PlayObject.m_wHumTitles:= HumData.HumTitles;//����ƺ�
  PlayObject.m_nDieCount:= HumData.UnKnow[34];//������������



  PlayObject.m_SpiritMedia := HumData.SpiritMedia;//��ýװ��λ 20100827
  PlayObject.m_nEnergyValue:= HumData.UnKnow[31];//����ֵ(�������ؾ���)
  PlayObject.m_nLuckyValue:= HumData.UnKnow[30];//����ֵ(�������ؾ���)
  PlayObject.m_nProficiency:= HumData.Proficiency;//������(�������ؾ���)
{$IFEND}
  PlayObject.n_LevelOrder:= HumData.Reserved2;//��������
  BagItems := @HumanRcd.Data.BagItems;
  for I := Low(TBagItems) to High(TBagItems) do begin
    if BagItems[I].wIndex > 0 then begin
      New(UserItem);
      FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
      UserItem^ := BagItems[I];
      {$IF M2Version <> 2}//��ʱ�����������ȥ�� 20100901
      if (UserItem.btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
        StdItem := GetStdItem(UserItem.wIndex);
        if StdItem <> nil then begin
          if StdItem.StdMode in [5,6,10,11,15,16,19..24,26..30,52,54,55,62,64] then UserItem.btAppraisalLevel:= 1;
        end;
      end;
      {$IFEND}
      {$IF M2var = 1}
      if UserItem.AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
        UserItem.AddValue[2]:= UserItem.btValue[14];
        UserItem.btValue[14]:= 0;
        PlayObject.SetItemState(UserItem, 0, UserItem.AddValue[2]);
        PlayObject.SetItemState(UserItem, 1, UserItem.btValue[15]);
        PlayObject.SetItemState(UserItem, 2, UserItem.btValue[16]);
        PlayObject.SetItemState(UserItem, 3, UserItem.btValue[17]);
        PlayObject.SetItemState(UserItem, 4, UserItem.btValue[18]);
        PlayObject.SetItemState(UserItem, 5, UserItem.btValue[19]);
        UserItem.btValue[15]:= 0;
        UserItem.btValue[16]:= 0;
        UserItem.btValue[17]:= 0;
        UserItem.btValue[18]:= 0;
        UserItem.btValue[19]:= 0;
        UserItem.AddValue[2]:= 255;
      end;
      {$IFEND}
      PlayObject.m_ItemList.Add(UserItem);
    end;
  end;
  HumMagics := @HumanRcd.Data.HumMagics;
  for I := Low(THumMagics) to High(THumMagics) do begin
    MagicInfo := FindMagic(HumMagics[I].wMagIdx);
    if MagicInfo <> nil then begin
      if MagicInfo.wMagicId <> SKILL_75 then begin
        New(UserMagic);
        UserMagic.MagicInfo := MagicInfo;
        UserMagic.wMagIdx := HumMagics[I].wMagIdx;
        UserMagic.btLevel := HumMagics[I].btLevel;
        UserMagic.btKey := HumMagics[I].btKey;
        UserMagic.nTranPoint := HumMagics[I].nTranPoint;
        if MagicInfo.wMagicId in [SKILL_YEDO,SKILL_SHOOTLIGHTEN,SKILL_74,SKILL_89,
          SKILL_EARTHFIRE,SKILL_FIRESWORD,SKILL_45,SKILL_FIRECHARM,SKILL_SKELLETON,
          SKILL_71,SKILL_FIREBOOM,SKILL_SNOWWIND,SKILL_HANGMAJINBUB,SKILL_DEJIWONHO,
          SKILL_90,SKILL_91,SKILL_92,SKILL_93,SKILL_94] then begin//ǿ������
          UserMagic.btLevelEx := HumMagics[I].btLevelEx;//ǿ���ȼ�
          if UserMagic.btLevelEx > 9 then UserMagic.btLevelEx:= 9;
        end else UserMagic.btLevelEx := 0;
        PlayObject.m_MagicList.Add(UserMagic);
      end else PlayObject.m_boProtectionDefence:= True;//�Ƿ�ѧ��������� 20091126
    end;
  end;
  {$IF M2Version <> 2}
  HumNGMagics:= @HumanRcd.Data.HumNGMagics;//20081001 �ڹ�����
  for I := Low(THumNGMagics) to High(THumNGMagics) do begin//�ڹ����� 20081001
    MagicInfo := FindMagic(HumNGMagics[I].wMagIdx);
    if MagicInfo <> nil then begin
      New(UserMagic);
      UserMagic.MagicInfo := MagicInfo;
      UserMagic.wMagIdx := HumNGMagics[I].wMagIdx;
      UserMagic.btLevel := HumNGMagics[I].btLevel;
      UserMagic.btKey := HumNGMagics[I].btKey;
      UserMagic.nTranPoint := HumNGMagics[I].nTranPoint;
      UserMagic.btLevelEx := 0;
      PlayObject.m_MagicList.Add(UserMagic);
    end;
  end;
  {$IFEND}
  StorageItems := @HumanRcd.Data.StorageItems;
  for I := Low(TStorageItems) to High(TStorageItems) do begin//�ֿ���Ʒ
    if StorageItems[I].wIndex > 0 then begin
      if (StorageItems[I].AddValue[0] = 1) and (GetHoursCount(StorageItems[I].MaxDate, Now) <= 0) then Continue;
      if (StorageItems[I].AddValue[0] = 2) and (GetHoursCount(StorageItems[I].MaxDate, Now) <= 0) then StorageItems[I].AddValue[0]:= 0;
      New(UserItem);
      FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
      UserItem^ := StorageItems[I];
      {$IF M2Version <> 2}//��ʱ�����������ȥ�� 20100901
      if (UserItem.btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
        StdItem := GetStdItem(UserItem.wIndex);
        if StdItem <> nil then
          if StdItem.StdMode in [5,6,10,11,15,16,19..24,26..30,52,54,55,62,64] then UserItem.btAppraisalLevel:= 1;
      end;
      {$IFEND}
      {$IF M2var = 1}
      if UserItem.AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
        UserItem.AddValue[2]:= UserItem.btValue[14];
        UserItem.btValue[14]:= 0;
        PlayObject.SetItemState(UserItem, 0, UserItem.AddValue[2]);
        PlayObject.SetItemState(UserItem, 1, UserItem.btValue[15]);
        PlayObject.SetItemState(UserItem, 2, UserItem.btValue[16]);
        PlayObject.SetItemState(UserItem, 3, UserItem.btValue[17]);
        PlayObject.SetItemState(UserItem, 4, UserItem.btValue[18]);
        PlayObject.SetItemState(UserItem, 5, UserItem.btValue[19]);
        UserItem.btValue[15]:= 0;
        UserItem.btValue[16]:= 0;
        UserItem.btValue[17]:= 0;
        UserItem.btValue[18]:= 0;
        UserItem.btValue[19]:= 0;
        UserItem.AddValue[2]:= 255;
      end;
      {$IFEND}
      PlayObject.m_StorageItemList.Add(UserItem);
    end;
  end;
  PlayObject.m_BigStorageItemList := g_Storage.GetUserBigStorageList(PlayObject.m_sCharName);//��ȡ���޲ֿ�����

  //��ȡ��·��ʯ��¼�ĵ�ͼ��XYֵ 20081019
  sFileName := g_Config.sEnvirDir + 'UserData\HumRecallPoint.txt';
  if FileExists(sFileName) then begin
    IniFile := TIniFile.Create(sFileName);
    Try
      for I:= 1 to 6 do begin
        sY:= IniFile.ReadString( PlayObject.m_sCharName , '��¼'+inttostr(I), '');
        sY := GetValidStr3(sY, sMap, [',']);
        if sMap <> '' then begin
          sY := GetValidStr3(sY, sX, [',']);
          PlayObject.m_TagMapInfos[I].TagMapName:= sMap;
          PlayObject.m_TagMapInfos[I].TagX:= Str_ToInt(sX, 0);
          PlayObject.m_TagMapInfos[I].TagY:= Str_ToInt(sY, 0);
        end;
      end;
    finally
      IniFile.Free;
    end;
  end;
end;
//ȡӢ������
procedure TUserEngine.GetHeroData(BaseObject: TBaseObject; var HumanRcd: THumDataInfo;var NewHeroDataInfo: TNewHeroDataInfo; boDeputyHero: Boolean; nJob: Byte);
var
  HumData: pTHumData;
  HumItems: pTHumItems;
  HumAddItems: pTHumAddItems;
  BagItems: pTBagItems;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  HumMagics: pTHumMagics;
  HumNGMagics: pTHumNGMagics;//20081001
  UserMagic: pTUserMagic;
  MagicInfo: pTMagic;
  I: Integer;
  HeroObject: THeroObject;
begin
  HeroObject := THeroObject(BaseObject);
  HumData := @HumanRcd.Data;
  HeroObject.m_sUserID := HumData.sAccount;
  HeroObject.m_sCharName := HumData.sChrName;
  HeroObject.m_sMapName := HumData.sCurMap;
  HeroObject.m_nCurrX := HumData.wCurX;
  HeroObject.m_nCurrY := HumData.wCurY;
  HeroObject.m_btDirection := HumData.btDir;
  HeroObject.m_btHair := HumData.btHair;
  HeroObject.m_btGender := HumData.btSex;
  HeroObject.m_btJob := HumData.btJob;
  HeroObject.m_nFirDragonPoint := HumData.nGold;//�����������������ŭ��ֵ 20080419

  HeroObject.m_Abil.Level := HumData.Abil.Level;

  HeroObject.m_Abil.HP := MakeLong(HumData.Abil.HP, HumData.Abil.AC);//20091026 �޸�
  HeroObject.m_Abil.MP := MakeLong(HumData.Abil.MP, HumData.Abil.MAC);//20091026 �޸�
  HeroObject.m_Abil.MaxHP := MakeLong(HumData.Abil.MaxHP, HumData.Abil.DC);//20091026 �޸�
  HeroObject.m_Abil.MaxMP := MakeLong(HumData.Abil.MaxMP, HumData.Abil.MC);//20091026 �޸�

  HeroObject.m_Abil.nExp := HumData.Abil.nExp;
  HeroObject.m_Abil.nMaxExp := HumData.Abil.nMaxExp;
  HeroObject.m_Abil.Weight := HumData.Abil.Weight;
  HeroObject.m_Abil.MaxWeight := HumData.Abil.MaxWeight;
  HeroObject.m_Abil.WearWeight := HumData.Abil.WearWeight;
  HeroObject.m_Abil.MaxWearWeight := HumData.Abil.MaxWearWeight;
  HeroObject.m_Abil.HandWeight := HumData.Abil.HandWeight;
  HeroObject.m_Abil.MaxHandWeight := HumData.Abil.MaxHandWeight;
  HeroObject.m_Abil.Alcohol:= HumData.n_Reserved;//���� 20080622
  HeroObject.m_Abil.MaxAlcohol:=  HumData.n_Reserved1;//�������� 20080622
  if HeroObject.m_Abil.MaxAlcohol < g_Config.nMaxAlcoholValue then HeroObject.m_Abil.MaxAlcohol:= g_Config.nMaxAlcoholValue;//��������С�޳�ʼֵʱ,���޸� 20080623
  HeroObject.m_Abil.WineDrinkValue := HumData.n_Reserved2;//��ƶ� 2008623

  HeroObject.n_DrinkWineQuality := HumData.btUnKnow2[2];//����ʱ�Ƶ�Ʒ��
  HeroObject.n_DrinkWineAlcohol:= HumData.UnKnow[4];//����ʱ�ƵĶ��� 20080624
  HeroObject.m_btMagBubbleDefenceLevel := HumData.UnKnow[5];//ħ���ܵȼ� 20080811

  HeroObject.m_boTrainingNG := HumData.UnKnow[6] <> 0;//�Ƿ�ѧϰ���ڹ� 20081002
  if HeroObject.m_boTrainingNG then HeroObject.m_NGLevel := MakeWord(HumData.UnKnow[7],HumData.UnKnow[33])//�ڹ��ȼ� 20081002
  else HeroObject.m_NGLevel := 0;
  HeroObject.m_ExpSkill69 := HumData.nExpSkill69;//�ڹ���ǰ���� 20080930

  HeroObject.m_Skill69NH := MakeLong(HumData.Abil.NG, HumData.Abil.MaxNG);//�ڹ���ǰ����ֵ 20110226
  HeroObject.GetSkill69Exp(HeroObject.m_NGLevel, HeroObject.m_Skill69MaxNH);//��������ֵ���� 20110226
  if HeroObject.m_Skill69NH < 0 then HeroObject.m_Skill69NH:= 0;
  if HeroObject.m_Skill69NH > HeroObject.m_Skill69MaxNH then HeroObject.m_Skill69NH:= HeroObject.m_Skill69MaxNH;

  HeroObject.m_PulseAddAC:= HumData.UnKnow[17];
  HeroObject.m_PulseAddAC1:= HumData.UnKnow[18];
  HeroObject.m_PulseAddMAC:= HumData.UnKnow[19];
  HeroObject.m_PulseAddMAC1:= HumData.UnKnow[20];
  HeroObject.m_nDecDamage:= HumData.m_nReserved1;//�������� 20090618
{$IF M2Version = 1}
  HeroObject.m_boOpenupSkill95 := HumData.UnKnow[35] <> 0;//��ͨ��ת99��
  HeroObject.m_Abil.TransferValue:= HumData.Reserved4;//��ǰ��תֵ

  HeroObject.m_ExpPuls:= HumData.nReserved;//Ӣ�۾��羭�� 20090911
//��������
  HeroObject.m_wHumanPulseArr[0].nPulsePoint:= HumData.UnKnow[9];
  if HeroObject.m_wHumanPulseArr[0].nPulsePoint >= 5 then HeroObject.m_wHumanPulseArr[0].boOpenPulse:= True;
  HeroObject.m_wHumanPulseArr[0].nPulseLevel:= HumData.UnKnow[10];

  HeroObject.m_wHumanPulseArr[1].nPulsePoint:= HumData.UnKnow[11];
  if HeroObject.m_wHumanPulseArr[1].nPulsePoint >= 5 then HeroObject.m_wHumanPulseArr[1].boOpenPulse:= True;
  HeroObject.m_wHumanPulseArr[1].nPulseLevel:= HumData.UnKnow[12];

  HeroObject.m_wHumanPulseArr[2].nPulsePoint:= HumData.UnKnow[13];
  if HeroObject.m_wHumanPulseArr[2].nPulsePoint >= 5 then HeroObject.m_wHumanPulseArr[2].boOpenPulse:= True;
  HeroObject.m_wHumanPulseArr[2].nPulseLevel:= HumData.UnKnow[14];

  HeroObject.m_wHumanPulseArr[3].nPulsePoint:= HumData.UnKnow[15];
  if HeroObject.m_wHumanPulseArr[3].nPulsePoint >= 5 then HeroObject.m_wHumanPulseArr[3].boOpenPulse:= True;
  HeroObject.m_wHumanPulseArr[3].nPulseLevel:= HumData.UnKnow[16];

  HeroObject.m_wHumanPulseArr[4].nPulsePoint:= HumData.UnKnow[32];//�澭
  if HeroObject.m_wHumanPulseArr[4].nPulsePoint >= 5 then HeroObject.m_wHumanPulseArr[4].boOpenPulse:= True;

  HeroObject.m_boUser4BatterSkill:= HumData.UnKnow[29] <> 0;//ʹ�õ��ĸ����� 20100720
  HeroObject.m_boTrainBatterSkill := HumData.UnKnow[21] <> 0;//�Ƿ�ѧϰ���������� 20090702
  HeroObject.m_SetBatterKey:= HumData.UnKnow[22];//��һ���������ܸ�
  HeroObject.m_SetBatterKey1:= HumData.UnKnow[23];//�ڶ����������ܸ�
  HeroObject.m_SetBatterKey2:= HumData.UnKnow[24];//�������������ܸ�
  HeroObject.m_SetBatterKey3:= HumData.UnKnow[28];//���ĸ��������ܸ� 20100719
  HeroObject.m_boOpenHumanPulseArr:= HumData.UnKnow[25] = 1;//Ӣ���Ƿ�ͨ����
  HeroObject.dw_UseMedicineTime1:= HumData.wContribution;//������ʱ��
  if HeroObject.dw_UseMedicineTime1 <= 0 then HeroObject.dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;//���㳤ʱ��û�Ⱦ�
{$IFEND}
  HeroObject.m_boProtectionDefence:= HumData.UnKnow[26] = 1;//�Ƿ�ѧ��������� 20091126
  HeroObject.m_Abil.MedicineValue:= HumData.nReserved1; //��ǰҩ��ֵ 20080623
  HeroObject.m_Abil.MaxMedicineValue:= HumData.nReserved2; //ҩ��ֵ���� 20080623
  HeroObject.n_DrinkWineDrunk:=  HumData.boReserved3;//���Ƿ�Ⱦ����� 20080627
  HeroObject.dw_UseMedicineTime:= HumData.nReserved3; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ�� 20080623
  HeroObject.n_MedicineLevel:= HumData.n_Reserved3;  //ҩ��ֵ�ȼ� 20080623
  if HeroObject.n_MedicineLevel <= 0 then HeroObject.n_MedicineLevel:=1;//���ҩ��ֵ�ȼ�Ϊ0,������Ϊ1 20080624
  if HeroObject.m_Abil.MaxMedicineValue <= 0 then//ҩ��ֵ����Ϊ0ʱ,ȡ���õľ��� 20080624
      HeroObject.m_Abil.MaxMedicineValue:= HeroObject.GetMedicineExp(HeroObject.n_MedicineLevel);

  HeroObject.m_wStatusTimeArr := HumData.wStatusTimeArr;
  HeroObject.m_wStatusTimeArr[POISON_DONTMOVE] := 0;//�����������ƶ� 20090903
  if HeroObject.m_wStatusTimeArr[POISON_SKILLDECHEALTH] > 100 then HeroObject.m_wStatusTimeArr[POISON_SKILLDECHEALTH]:= 1;//���ж�����100���ʼ 20091107
  if HeroObject.m_wStatusTimeArr[POISON_STONE] > 100 then HeroObject.m_wStatusTimeArr[POISON_STONE]:= 1;//���ʱ�䳬��100�����ʼ 20091107
  if HeroObject.m_wStatusTimeArr[POISON_LOCKSPELL] > 100 then HeroObject.m_wStatusTimeArr[POISON_STONE]:= 1;
  if HeroObject.m_wStatusTimeArr[STATE_TRANSPARENT] > 1000 then HeroObject.m_wStatusTimeArr[STATE_TRANSPARENT]:= 1;//����1000,���ʼ 20091107
  if HeroObject.m_wStatusTimeArr[STATE_DEFENCEUP] > 1000 then HeroObject.m_wStatusTimeArr[STATE_DEFENCEUP]:= 1;//��ʥս����  ��������1000,���ʼ 20091107
  if HeroObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP] > 1000 then HeroObject.m_wStatusTimeArr[STATE_MAGDEFENCEUP]:= 1;//�����  ħ������1000,���ʼ 20091107
  if HeroObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 1000 then HeroObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//ħ���ܳ�1000,���ʼ 20091107
  HeroObject.m_sHomeMap := HumData.sHomeMap;
  HeroObject.m_nHomeX := HumData.wHomeX;
  HeroObject.m_nHomeY := HumData.wHomeY;
  HeroObject.m_BonusAbil := HumData.BonusAbil;//20081126 Ӣ����������
  HeroObject.m_nBonusPoint := HumData.nBonusPoint; // 08/09
  HeroObject.m_btCreditPoint := HumData.btCreditPoint;
  HeroObject.m_btReLevel := HumData.btReLevel;

  HeroObject.m_nWinExp :=HumData.n_WinExp;//Ӣ���ۼƾ���ֵ 20080110
  HeroObject.m_nLoyal :=HumData.nLoyal;
  if HeroObject.m_nLoyal >10000 then HeroObject.m_nLoyal :=10000;
  
  HeroObject.m_btLastOutStatus := HumData.btLastOutStatus; //�˳�״̬ 1Ϊ����
  HeroObject.m_sMasterName := HumData.sMasterName;//20090529 ��������

  HeroObject.m_nPkPoint := HumData.nPKPOINT;

  HeroObject.btB2 := HumData.btF9;
  HeroObject.m_btAttatckMode := HumData.btAttatckMode;
  HeroObject.m_nIncHealth := HumData.btIncHealth;
  HeroObject.m_nIncSpell := HumData.btIncSpell;
  HeroObject.m_nIncHealing := HumData.btIncHealing;
  HeroObject.m_nFightZoneDieCount := HumData.btFightZoneDieCount;
  HeroObject.n_HeroTpye:= HumData.btHeroType;//Ӣ������ 0-������Ӣ�� 1-����Ӣ��

  HeroObject.m_dBodyLuck := HumData.dBodyLuck;

  HeroObject.m_QuestFlag := HumData.QuestFlag;
  HeroObject.m_btStatus := HumData.btStatus; //Ӣ�۵�״̬ 20080717
  if HeroObject.m_Abil.Level < 22 then HeroObject.m_btStatus := 1;//20080710 22��֮ǰ,Ĭ�ϸ���

  HeroObject.m_btHeroTwoJob:= HumData.btJob;//����Ӣ��ְҵ

  if boDeputyHero and (nJob <> HumData.btJob) and (nJob in [0,1,2]) then begin//����Ӣ��,��ְҵ��һ��
    HeroObject.m_boIsBakData:= True;//�Ƿ��б�������
    HeroObject.m_btJob := nJob;
    HeroObject.m_nHP_Bak:= HeroObject.m_Abil.HP;//���ݵ�ǰHPֵ
    HeroObject.m_nMP_Bak:= HeroObject.m_Abil.MP;//���ݵ�ǰMPֵ
    HumItems := @HumanRcd.Data.HumItems;
    HeroObject.m_UseItems_bak[U_DRESS] := HumItems[U_DRESS];
    HeroObject.m_UseItems_bak[U_WEAPON] := HumItems[U_WEAPON];
    HeroObject.m_UseItems_bak[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
    HeroObject.m_UseItems_bak[U_NECKLACE] := HumItems[U_HELMET];
    HeroObject.m_UseItems_bak[U_HELMET] := HumItems[U_NECKLACE];
    HeroObject.m_UseItems_bak[U_ARMRINGL] := HumItems[U_ARMRINGL];
    HeroObject.m_UseItems_bak[U_ARMRINGR] := HumItems[U_ARMRINGR];
    HeroObject.m_UseItems_bak[U_RINGL] := HumItems[U_RINGL];
    HeroObject.m_UseItems_bak[U_RINGR] := HumItems[U_RINGR];
    {$IF M2Version <> 2}
    HumAddItems := @HumanRcd.Data.HumAddItems;
    HeroObject.m_UseItems_bak[U_BUJUK] := HumAddItems[U_BUJUK];
    HeroObject.m_UseItems_bak[U_BELT] := HumAddItems[U_BELT];
    HeroObject.m_UseItems_bak[U_BOOTS] := HumAddItems[U_BOOTS];
    HeroObject.m_UseItems_bak[U_CHARM] := HumAddItems[U_CHARM];
    HeroObject.m_UseItems_bak[U_ZHULI] := HumAddItems[U_ZHULI];
    HeroObject.m_UseItems_bak[U_DRUM] := HumAddItems[U_DRUM];//20080416 ����
    {$IFEND}
    BagItems := @HumanRcd.Data.BagItems;
    for I := Low(TBagItems) to High(TBagItems) do begin
      if BagItems[I].wIndex > 0 then begin
        New(UserItem);
        FillChar(UserItem^, SizeOf(TUserItem), #0);
        UserItem^ := BagItems[I];
        {$IF M2Version <> 2}//��ʱ�����������ȥ�� 20100901
        if (UserItem.btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
          StdItem := GetStdItem(UserItem.wIndex);
          if StdItem <> nil then
            if StdItem.StdMode in [5,6,10,11,15,16,19..24,26..30,52,54,55,62,64] then UserItem.btAppraisalLevel:= 1;
        end;
        {$IFEND}
        {$IF M2var = 1}
        if UserItem.AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
          UserItem.AddValue[2]:= UserItem.btValue[14];
          UserItem.btValue[14]:= 0;
          HeroObject.SetItemState(UserItem, 0, UserItem.AddValue[2]);
          HeroObject.SetItemState(UserItem, 1, UserItem.btValue[15]);
          HeroObject.SetItemState(UserItem, 2, UserItem.btValue[16]);
          HeroObject.SetItemState(UserItem, 3, UserItem.btValue[17]);
          HeroObject.SetItemState(UserItem, 4, UserItem.btValue[18]);
          HeroObject.SetItemState(UserItem, 5, UserItem.btValue[19]);
          UserItem.btValue[15]:= 0;
          UserItem.btValue[16]:= 0;
          UserItem.btValue[17]:= 0;
          UserItem.btValue[18]:= 0;
          UserItem.btValue[19]:= 0;
          UserItem.AddValue[2]:= 255;
        end;
        {$IFEND}
        HeroObject.m_ItemList_bak.Add(UserItem);
      end;
    end;
    HumMagics := @HumanRcd.Data.HumMagics;
    for I := Low(THumMagics) to High(THumMagics) do begin
      MagicInfo := FindHeroMagic(HumMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        if MagicInfo.wMagicId <> SKILL_75 then begin
          New(UserMagic);
          UserMagic.MagicInfo := MagicInfo;
          UserMagic.wMagIdx := HumMagics[I].wMagIdx;
          UserMagic.btLevel := HumMagics[I].btLevel;
          UserMagic.btKey := HumMagics[I].btKey;//ħ����ݼ�(��ħ������)
          UserMagic.nTranPoint := HumMagics[I].nTranPoint;
          UserMagic.btLevelEx := HumMagics[I].btLevelEx;//ǿ���ȼ�
          if UserMagic.btLevelEx > 9 then UserMagic.btLevelEx:= 9;
          HeroObject.m_MagicList_bak.Add(UserMagic);
          case UserMagic.MagicInfo.wMagicId of
            SKILL_67: HeroObject.m_MagicList.Add(UserMagic);//ͬ������Ԫ������
            SKILL_68: HeroObject.m_MagicList.Add(UserMagic);//ͬ�þ������弼��
            {$IF M2Version <> 2}
            SKILL_99: HeroObject.m_MagicList.Add(UserMagic);//ͬ��ǿ��������
            SKILL_102: HeroObject.m_MagicList.Add(UserMagic);//ͬ��Ψ�Ҷ�����
            {$IFEND}
            {$IF M2Version = 1}
            SKILL_95: HeroObject.m_MagicList.Add(UserMagic);//ͬ�ö�ת���Ƽ���
            SKILL_76, SKILL_77, SKILL_78: begin//����ɱ,�����ٻ�ְҵ�任��Ӧ�ļ���
              case nJob of
                0: begin//ս-����ɱ
                  MagicInfo := FindHeroMagic(SKILL_76);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_76;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                1: begin//��-˫����
                  MagicInfo := FindHeroMagic(SKILL_77);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_77;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                2: begin//��-��Х��
                  MagicInfo := FindHeroMagic(SKILL_78);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_78;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
              end;
            end;
            SKILL_79,SKILL_80,SKILL_81: begin//׷�Ĵ�,�����,������
              case nJob of
                0: begin//ս-׷�Ĵ�
                  MagicInfo := FindHeroMagic(SKILL_79);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_79;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                1: begin//��-�����
                  MagicInfo := FindHeroMagic(SKILL_80);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_80;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                2: begin//��-������
                  MagicInfo := FindHeroMagic(SKILL_81);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_81;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
              end;//case
            end;
            SKILL_82,SKILL_83,SKILL_84: begin//����ն,���ױ�,������
              case nJob of
                0: begin//ս-����ն
                  MagicInfo := FindHeroMagic(SKILL_82);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_82;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                1: begin//��-���ױ�
                  MagicInfo := FindHeroMagic(SKILL_83);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_83;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                2: begin//��-������
                  MagicInfo := FindHeroMagic(SKILL_84);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_84;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
              end;//case
            end;
            SKILL_85,SKILL_86,SKILL_87: begin//��ɨǧ��,����ѩ��,�򽣹���
              case nJob of
                0: begin//ս-��ɨǧ��
                  MagicInfo := FindHeroMagic(SKILL_85);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_85;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                1: begin//��-����ѩ��
                  MagicInfo := FindHeroMagic(SKILL_86);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_86;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
                2: begin//��-�򽣹���
                  MagicInfo := FindHeroMagic(SKILL_87);
                  UserMagic.MagicInfo := MagicInfo;
                  UserMagic.wMagIdx := SKILL_87;
                  HeroObject.m_MagicList.Add(UserMagic);
                  HeroObject.m_BatterMagicList.Add(UserMagic);
                end;
              end;//case
            end;
            {$IFEND}
          end;//case
        end;
      end;
    end;
    HumNGMagics:= @HumanRcd.Data.HumNGMagics;//�ڹ�����
    for I := Low(THumNGMagics) to High(THumNGMagics) do begin//�ڹ�����
      MagicInfo := FindMagic(HumNGMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        New(UserMagic);
        UserMagic.MagicInfo := MagicInfo;
        UserMagic.wMagIdx := HumNGMagics[I].wMagIdx;
        UserMagic.btLevel := HumNGMagics[I].btLevel;
        UserMagic.btKey := HumNGMagics[I].btKey;
        UserMagic.nTranPoint := HumNGMagics[I].nTranPoint;
        HeroObject.m_MagicList_bak.Add(UserMagic);
      end;
    end;
    //------------------------��������----------------------------------------------
    HeroObject.m_Abil.HP := NewHeroDataInfo.Data.nHP;
    HeroObject.m_Abil.MP := NewHeroDataInfo.Data.nMP;
    HumItems := @NewHeroDataInfo.Data.HumItems;
    HeroObject.m_UseItems[U_DRESS] := HumItems[U_DRESS];
    HeroObject.m_UseItems[U_WEAPON] := HumItems[U_WEAPON];
    HeroObject.m_UseItems[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
    HeroObject.m_UseItems[U_NECKLACE] := HumItems[U_HELMET];
    HeroObject.m_UseItems[U_HELMET] := HumItems[U_NECKLACE];
    HeroObject.m_UseItems[U_ARMRINGL] := HumItems[U_ARMRINGL];
    HeroObject.m_UseItems[U_ARMRINGR] := HumItems[U_ARMRINGR];
    HeroObject.m_UseItems[U_RINGL] := HumItems[U_RINGL];
    HeroObject.m_UseItems[U_RINGR] := HumItems[U_RINGR];

    HumAddItems := @NewHeroDataInfo.Data.HumAddItems;
    HeroObject.m_UseItems[U_BUJUK] := HumAddItems[U_BUJUK];
    HeroObject.m_UseItems[U_BELT] := HumAddItems[U_BELT];
    HeroObject.m_UseItems[U_BOOTS] := HumAddItems[U_BOOTS];
    HeroObject.m_UseItems[U_CHARM] := HumAddItems[U_CHARM];
    HeroObject.m_UseItems[U_ZHULI] := HumAddItems[U_ZHULI];//20080416 ����
    HeroObject.m_UseItems[U_DRUM] := HumAddItems[U_DRUM];//��

    BagItems := @NewHeroDataInfo.Data.BagItems;
    for I := Low(TBagItems) to High(TBagItems) do begin
      if BagItems[I].wIndex > 0 then begin
        New(UserItem);
        FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
        UserItem^ := BagItems[I];
        {$IF M2Version <> 2}//��ʱ�����������ȥ�� 20100901
        if (UserItem.btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
          StdItem := GetStdItem(UserItem.wIndex);
          if StdItem <> nil then
            if StdItem.StdMode in [5,6,10,11,15,16,19..24,26..30,52,54,55,62,64] then UserItem.btAppraisalLevel:= 1;
        end;
        {$IFEND}
        {$IF M2var = 1}
        if UserItem.AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
          UserItem.AddValue[2]:= UserItem.btValue[14];
          UserItem.btValue[14]:= 0;
          HeroObject.SetItemState(UserItem, 0, UserItem.AddValue[2]);
          HeroObject.SetItemState(UserItem, 1, UserItem.btValue[15]);
          HeroObject.SetItemState(UserItem, 2, UserItem.btValue[16]);
          HeroObject.SetItemState(UserItem, 3, UserItem.btValue[17]);
          HeroObject.SetItemState(UserItem, 4, UserItem.btValue[18]);
          HeroObject.SetItemState(UserItem, 5, UserItem.btValue[19]);
          UserItem.btValue[15]:= 0;
          UserItem.btValue[16]:= 0;
          UserItem.btValue[17]:= 0;
          UserItem.btValue[18]:= 0;
          UserItem.btValue[19]:= 0;
          UserItem.AddValue[2]:= 255;
        end;
        {$IFEND}
        HeroObject.m_ItemList.Add(UserItem);
      end;
    end;
    HumMagics := @NewHeroDataInfo.Data.HumMagics;
    for I := Low(THumMagics) to High(THumMagics) do begin
      MagicInfo := FindHeroMagic(HumMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        if MagicInfo.wMagicId <> SKILL_75 then begin
          {$IF M2Version = 1}
          if (MagicInfo.wMagicId > SKILL_75) and (MagicInfo.wMagicId < SKILL_88) then Continue;//�������ܲ�����
          {$IFEND}
          if (MagicInfo.wMagicId <> SKILL_67) and (MagicInfo.wMagicId <> SKILL_68)
            {$IF M2Version <> 2}and (MagicInfo.wMagicId <> SKILL_99) and
            (MagicInfo.wMagicId <> SKILL_102){$IFEND} then begin//��������,����Ԫ��,ǿ����,Ψ�Ҷ������
            New(UserMagic);
            UserMagic.MagicInfo := MagicInfo;
            UserMagic.wMagIdx := HumMagics[I].wMagIdx;
            UserMagic.btLevel := HumMagics[I].btLevel;
            UserMagic.btKey := HumMagics[I].btKey;//ħ����ݼ�(��ħ������)
            UserMagic.nTranPoint := HumMagics[I].nTranPoint;
            UserMagic.btLevelEx := HumMagics[I].btLevelEx;//ǿ���ȼ�
            if UserMagic.btLevelEx > 9 then UserMagic.btLevelEx:= 9;
            HeroObject.m_MagicList.Add(UserMagic);
          end;
        end else HeroObject.m_boProtectionDefence:= True;//�Ƿ�ѧ���������
      end;
    end;
    HumNGMagics:= @NewHeroDataInfo.Data.HumNGMagics;//�ڹ�����
    for I := Low(THumNGMagics) to High(THumNGMagics) do begin//�ڹ�����
      MagicInfo := FindMagic(HumNGMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        New(UserMagic);
        UserMagic.MagicInfo := MagicInfo;
        UserMagic.wMagIdx := HumNGMagics[I].wMagIdx;
        UserMagic.btLevel := HumNGMagics[I].btLevel;
        UserMagic.btKey := HumNGMagics[I].btKey;
        UserMagic.nTranPoint := HumNGMagics[I].nTranPoint;
        UserMagic.btLevelEx := 0;//ǿ���ȼ�
        HeroObject.m_MagicList.Add(UserMagic);
      end;
    end;
  end else begin
    HumItems := @HumanRcd.Data.HumItems;
    HeroObject.m_UseItems[U_DRESS] := HumItems[U_DRESS];
    HeroObject.m_UseItems[U_WEAPON] := HumItems[U_WEAPON];
    HeroObject.m_UseItems[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
    HeroObject.m_UseItems[U_NECKLACE] := HumItems[U_HELMET];
    HeroObject.m_UseItems[U_HELMET] := HumItems[U_NECKLACE];
    HeroObject.m_UseItems[U_ARMRINGL] := HumItems[U_ARMRINGL];
    HeroObject.m_UseItems[U_ARMRINGR] := HumItems[U_ARMRINGR];
    HeroObject.m_UseItems[U_RINGL] := HumItems[U_RINGL];
    HeroObject.m_UseItems[U_RINGR] := HumItems[U_RINGR];

    HumAddItems := @HumanRcd.Data.HumAddItems;
    HeroObject.m_UseItems[U_BUJUK] := HumAddItems[U_BUJUK];
    HeroObject.m_UseItems[U_BELT] := HumAddItems[U_BELT];
    HeroObject.m_UseItems[U_BOOTS] := HumAddItems[U_BOOTS];
    HeroObject.m_UseItems[U_CHARM] := HumAddItems[U_CHARM];
    HeroObject.m_UseItems[U_ZHULI] := HumAddItems[U_ZHULI];//20080416 ����
    HeroObject.m_UseItems[U_DRUM] := HumAddItems[U_DRUM];//��
    
    BagItems := @HumanRcd.Data.BagItems;
    for I := Low(TBagItems) to High(TBagItems) do begin
      if BagItems[I].wIndex > 0 then begin
        New(UserItem);
        FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
        UserItem^ := BagItems[I];
        {$IF M2Version <> 2}//��ʱ�����������ȥ�� 20100901
        if (UserItem.btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
          StdItem := GetStdItem(UserItem.wIndex);
          if StdItem <> nil then
            if StdItem.StdMode in [5,6,10,11,15,16,19..24,26..30,52,54,55,62,64] then UserItem.btAppraisalLevel:= 1;
        end;
        {$IFEND}
        {$IF M2var = 1}
        if UserItem.AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
          UserItem.AddValue[2]:= UserItem.btValue[14];
          UserItem.btValue[14]:= 0;
          HeroObject.SetItemState(UserItem, 0, UserItem.AddValue[2]);
          HeroObject.SetItemState(UserItem, 1, UserItem.btValue[15]);
          HeroObject.SetItemState(UserItem, 2, UserItem.btValue[16]);
          HeroObject.SetItemState(UserItem, 3, UserItem.btValue[17]);
          HeroObject.SetItemState(UserItem, 4, UserItem.btValue[18]);
          HeroObject.SetItemState(UserItem, 5, UserItem.btValue[19]);
          UserItem.btValue[15]:= 0;
          UserItem.btValue[16]:= 0;
          UserItem.btValue[17]:= 0;
          UserItem.btValue[18]:= 0;
          UserItem.btValue[19]:= 0;
          UserItem.AddValue[2]:= 255;
        end;
        {$IFEND}
        HeroObject.m_ItemList.Add(UserItem);
      end;
    end;
    HumMagics := @HumanRcd.Data.HumMagics;
    for I := Low(THumMagics) to High(THumMagics) do begin
      MagicInfo := FindHeroMagic(HumMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        if MagicInfo.wMagicId <> SKILL_75 then begin
          New(UserMagic);
          UserMagic.MagicInfo := MagicInfo;
          UserMagic.wMagIdx := HumMagics[I].wMagIdx;
          UserMagic.btLevel := HumMagics[I].btLevel;
          UserMagic.btKey := HumMagics[I].btKey;//ħ����ݼ�(��ħ������)
          UserMagic.nTranPoint := HumMagics[I].nTranPoint;
          UserMagic.btLevelEx := HumMagics[I].btLevelEx;//ǿ���ȼ�
          if UserMagic.btLevelEx > 9 then UserMagic.btLevelEx:= 9;
          HeroObject.m_MagicList.Add(UserMagic);
          {$IF M2Version = 1}
          if (UserMagic.MagicInfo.wMagicId > SKILL_75) and (UserMagic.MagicInfo.wMagicId < SKILL_88) then begin//�������ܲŴ���
            HeroObject.m_BatterMagicList.Add(UserMagic);
          end;
          {$IFEND}
        end else HeroObject.m_boProtectionDefence:= True;//�Ƿ�ѧ��������� 20091126
      end;
    end;

    HumNGMagics:= @HumanRcd.Data.HumNGMagics;//20081001 �ڹ�����
    for I := Low(THumNGMagics) to High(THumNGMagics) do begin//�ڹ����� 20081001
      MagicInfo := FindMagic(HumNGMagics[I].wMagIdx);
      if MagicInfo <> nil then begin
        New(UserMagic);
        UserMagic.MagicInfo := MagicInfo;
        UserMagic.wMagIdx := HumNGMagics[I].wMagIdx;
        UserMagic.btLevel := HumNGMagics[I].btLevel;
        UserMagic.btKey := HumNGMagics[I].btKey;
        UserMagic.nTranPoint := HumNGMagics[I].nTranPoint;
        UserMagic.btLevelEx := 0;//ǿ���ȼ�
        HeroObject.m_MagicList.Add(UserMagic);
      end;
    end;
  end;
end;
//ȡ�س�����
function TUserEngine.GetHomeInfo(var nX, nY: Integer): string;
var
  I: Integer;
begin
  g_StartPointList.Lock;
  try
    if g_StartPointList.Count > 0 then begin
      if g_StartPointList.Count > g_Config.nStartPointSize {1} then I := Random(g_Config.nStartPointSize {2})
      else I := 0;
      Result := GetStartPointInfo(I, nX, nY); //g_StartPointList.Strings[i];
    end else begin
      Result := g_Config.sHomeMap;
      nX := g_Config.nHomeX;
      nX := g_Config.nHomeY;
    end;
  finally
    g_StartPointList.UnLock;
  end;
end;

function TUserEngine.GetRandHomeX(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeX - 2);
end;

function TUserEngine.GetRandHomeY(PlayObject: TPlayObject): Integer;
begin
  Result := Random(3) + (PlayObject.m_nHomeY - 2);
end;

procedure TUserEngine.LoadSwitchData(SwitchData: pTSwitchDataInfo; var
  PlayObject: TPlayObject);
var
  nCount: Integer;
  SlaveInfo: pTSlaveInfo;
begin
  PlayObject.m_boBanShout := SwitchData.boBanShout;
  PlayObject.m_boHearWhisper := SwitchData.boHearWhisper;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boAdminMode := SwitchData.boAdminMode;
  PlayObject.m_boObMode := SwitchData.boObMode;
  nCount := 0;
  while (True) do begin
    if SwitchData.BlockWhisperArr[nCount] = '' then Break;
    PlayObject.m_BlockWhisperList.Add(SwitchData.BlockWhisperArr[nCount]);
    Inc(nCount);
    if nCount >= High(SwitchData.BlockWhisperArr) then Break;
  end;
  nCount := 0;
  while (True) do begin
    if SwitchData.SlaveArr[nCount].sSalveName = '' then Break;
    New(SlaveInfo);
    SlaveInfo^ := SwitchData.SlaveArr[nCount];
    PlayObject.SendDelayMsg(PlayObject, RM_10401, 0, Integer(SlaveInfo), 0, 0, '', 500);
    Inc(nCount);
    if nCount >= 5 then Break;
  end;
  nCount := 0;
  while (True) do begin
    PlayObject.m_wStatusArrValue[nCount] := SwitchData.StatusValue[nCount];
    PlayObject.m_dwStatusArrTimeOutTick[nCount] := SwitchData.StatusTimeOut[nCount];
    Inc(nCount);
    if nCount >= 6 then Break;
  end;
end;

procedure TUserEngine.DelSwitchData(SwitchData: pTSwitchDataInfo);
var
  I: Integer;
  SwitchDataInfo: pTSwitchDataInfo;
begin
  I := 0;
  while True do begin //for i := 0 to m_ChangeServerList.Count - 1 do begin
    if I >= m_ChangeServerList.Count then Break;
    if m_ChangeServerList.Count <= 0 then Break;
    SwitchDataInfo := m_ChangeServerList.Items[I];
    if (SwitchDataInfo <> nil) then begin
      if (SwitchDataInfo = SwitchData) then begin
        Dispose(SwitchDataInfo);
        m_ChangeServerList.Delete(I);
        Break;
      end;
    end;
    Inc(I);
  end; // for
end;
//����ħ��
function TUserEngine.FindMagic(nMagIdx: Integer): pTMagic;
var
  I: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (m_OldMagicList.Count > 0) then begin
    MagicList := TList(m_OldMagicList.Items[m_OldMagicList.Count - 1]);
    if MagicList <> nil then begin
      if MagicList.Count > 0 then begin//20081008
        for I := 0 to MagicList.Count - 1 do begin
          Magic := MagicList.Items[I];
          if (Magic <> nil) then begin
            if (Magic.sDescr = '') {$IF M2Version <> 2}or (Magic.sDescr = '�ڹ�')
              or (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��') or (Magic.sDescr = '��'){$IFEND} then begin
              if Magic.wMagicId = nMagIdx then begin
                Result := Magic;
                Break;
              end;
            end;
          end;
        end;//for
      end;
    end;
  end else begin
    if m_MagicList.Count > 0 then begin//20081008
      for I := 0 to m_MagicList.Count - 1 do begin
        Magic := m_MagicList.Items[I];
        if (Magic <> nil) then begin
          if (Magic.sDescr = '') {$IF M2Version <> 2}or (Magic.sDescr = '�ڹ�')
            or (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��') or (Magic.sDescr = '��'){$IFEND} then begin
            if Magic.wMagicId = nMagIdx then begin
              Result := Magic;
              Break;
            end;
          end;
        end;
      end;//for
    end;
  end;
end;

function TUserEngine.FindHeroMagic(nMagIdx: Integer): pTMagic;
var
  I: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (m_OldMagicList.Count > 0) then begin
    MagicList := TList(m_OldMagicList.Items[m_OldMagicList.Count - 1]);
    if MagicList <> nil then begin
      if MagicList.Count > 0 then begin//20081008
        for I := 0 to MagicList.Count - 1 do begin
          Magic := MagicList.Items[I];
          if (Magic <> nil) then begin
            if (Magic.sDescr = 'Ӣ��'){$IF M2Version <> 2}or (Magic.sDescr = '�ڹ�')
              or (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��'){$IFEND} then begin
              if Magic.wMagicId = nMagIdx then begin
                Result := Magic;
                Break;
              end;
            end;
          end;
        end;//for
      end;
    end;
  end else begin
    if m_MagicList.Count > 0 then begin//20081008
      for I := 0 to m_MagicList.Count - 1 do begin
        Magic := m_MagicList.Items[I];
        if (Magic <> nil) then begin
          if (Magic.sDescr = 'Ӣ��') {$IF M2Version <> 2}or (Magic.sDescr = '�ڹ�')
            or (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��'){$IFEND} then begin
            if Magic.wMagicId = nMagIdx then begin
              Result := Magic;
              Break;
            end;
          end;
        end;
      end;//for
    end;
  end;
end;
//�����ʼ��
procedure TUserEngine.MonInitialize(BaseObject: TBaseObject; sMonName: string);
var
  I: Integer;
  Monster: pTMonInfo;
  nCode: Byte;
begin
  nCode:= 0;
  try
    if MonsterList.Count > 0 then begin
      for I := 0 to MonsterList.Count - 1 do begin
        Monster := MonsterList.Items[I];
        nCode:= 2;
        if Monster <> nil then begin
          nCode:= 3;
          if (CompareText(Monster.sName, sMonName) = 0) and (BaseObject <> nil) then begin
            nCode:= 4;
            BaseObject.m_btRaceServer := Monster.btRace;
            BaseObject.m_btRaceImg := Monster.btRaceImg;
            BaseObject.m_wAppr := Monster.wAppr;
            BaseObject.m_Abil.Level := Monster.wLevel;
            BaseObject.m_btLifeAttrib := Monster.btLifeAttrib;//����ϵ
            BaseObject.m_btCoolEye := Monster.wCoolEye;//���ӷ�Χ
            BaseObject.m_dwFightExp := Monster.dwExp;
            BaseObject.m_Abil.HP := Monster.wHP;
            BaseObject.m_Abil.MaxHP := Monster.wHP;
            nCode:= 5;
            BaseObject.m_btMonsterWeapon := LoByte(Monster.wMP);
            BaseObject.m_Abil.MP := 0;
            BaseObject.m_Abil.MaxMP := Monster.wMP;
            nCode:= 6;
            BaseObject.m_Abil.AC := MakeLong(Monster.wAC, Monster.wAC);
            BaseObject.m_Abil.MAC := MakeLong(Monster.wMAC, Monster.wMAC);
            BaseObject.m_Abil.DC := MakeLong(Monster.wDC, Monster.wMaxDC);
            BaseObject.m_Abil.MC := MakeLong(Monster.wMC, Monster.wMC);
            BaseObject.m_Abil.SC := MakeLong(Monster.wSC, Monster.wSC);
            nCode:= 7;
            BaseObject.m_btSpeedPoint := _MIN(High(Byte),Monster.wSpeed);//20081204 ���� m_btSpeedPointΪByte���������ж�
            nCode:= 8;
            BaseObject.m_btHitPoint := _MIN(High(BaseObject.m_btHitPoint),Monster.wHitPoint);//20101006 �޸�
            nCode:= 9;
            BaseObject.m_nWalkSpeed := Monster.wWalkSpeed;//�����ٶ�
            BaseObject.m_nWalkStep := Monster.wWalkStep;
            BaseObject.m_dwWalkWait := Monster.wWalkWait;
            BaseObject.m_nNextHitTime := Monster.wAttackSpeed;//�����ٶ�
            Break;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.MonInitialize Name:%s Code:%d',[g_sExceptionVer, sMonName, nCode]));
  end;
end;
//����
function TUserEngine.OpenDoor(Envir: TEnvirnoment; nX,
  nY: Integer): Boolean;
var
  Door: pTDoorInfo;
begin
  Result := False;
  Door := Envir.GetDoor(nX, nY);
  if (Door <> nil) then begin
    if not Door.Status.boOpened and not Door.Status.bo01 then begin
      Door.Status.boOpened := True;
      Door.Status.dwOpenTick := GetTickCount();
      SendDoorStatus(Envir, nX, nY, RM_DOOROPEN, 0, nX, nY, 0, '');
      Result := True;
    end;
  end;
end;
//�ر���
function TUserEngine.CloseDoor(Envir: TEnvirnoment; Door: pTDoorInfo): Boolean;
begin
  Result := False;
  if (Door <> nil) then begin
    if (Door.Status.boOpened) then begin
      Door.Status.boOpened := False;
      SendDoorStatus(Envir, Door.nX, Door.nY, RM_DOORCLOSE, 0, Door.nX, Door.nY, 0, '');
      Result := True;
    end;
  end;
end;
//�����ŵ�״̬
procedure TUserEngine.SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer;
  wIdent, wX: Word; nDoorX, nDoorY, nA: Integer; sStr: string);
var
  I: Integer;
  n10, n14: Integer;
  n1C, n20, n24, n28: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  n1C := nX - 12;
  n24 := nX + 12;
  n20 := nY - 12;
  n28 := nY + 12;
  if n1C < 0 then n1C:= 0;//20080629
  if n20 < 0 then n20:= 0;//20080629
  if Envir <> nil then begin
    for n10 := n1C to n24 do begin
      for n14 := n20 to n28 do begin
        if Envir.GetMapCellInfo(n10, n14, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          if MapCellInfo.ObjList.Count > 0 then begin//20080629
            for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
              OSObject := pTOSObject(MapCellInfo.ObjList.Items[I]);
              if (OSObject <> nil) then begin
                if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin//20090510 ����
                  BaseObject := TBaseObject(OSObject.CellObj);
                  if (BaseObject <> nil) then begin
                    if (not BaseObject.m_boGhost) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                      BaseObject.SendMsg(BaseObject, wIdent, wX, nDoorX, nDoorY, nA, sStr);
                    end;
                  end;
                end;
              end;
            end;//for
          end;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessMapDoor;
var
  I, II: Integer;
  Envir: TEnvirnoment;
  Door: pTDoorInfo;
begin
  if g_MapManager.Count > 0 then begin//20081008
    for I := 0 to g_MapManager.Count - 1 do begin
      Envir := TEnvirnoment(g_MapManager.Items[I]);
      if Envir <> nil then begin
        if Envir.m_DoorList.Count > 0 then begin//20081008
          for II := 0 to Envir.m_DoorList.Count - 1 do begin
            Door := Envir.m_DoorList.Items[II];
            if Door <> nil then begin
              if Door.Status.boOpened then begin
                if (GetTickCount - Door.Status.dwOpenTick) > 5000 then CloseDoor(Envir, Door);
              end;
            end;
          end;//for
        end;
      end;
    end;
  end;
end;
//-----------------------------------------------------------------------------
procedure TUserEngine.ProcessEvents;
var
  I, II, III: Integer;
  MagicEvent: pTMagicEvent;
  BaseObject: TBaseObject;
begin
  for I := m_MagicEventList.Count - 1 downto 0 do begin
    if m_MagicEventList.Count <= 0 then Break;
    MagicEvent := m_MagicEventList.Items[I];
    if (MagicEvent <> nil) then begin
      if (MagicEvent.BaseObjectList <> nil) then begin
        for II := MagicEvent.BaseObjectList.Count - 1 downto 0 do begin
          if MagicEvent.BaseObjectList.Count <= 0 then Break;//20081008
          BaseObject := TBaseObject(MagicEvent.BaseObjectList.Items[II]);
          if BaseObject <> nil then begin
            if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (not BaseObject.m_boHolySeize) then begin
              MagicEvent.BaseObjectList.Delete(II);
            end;
          end;
        end;//for
        if (MagicEvent.BaseObjectList.Count <= 0) or
          ((GetTickCount - MagicEvent.dwStartTick) > MagicEvent.dwTime) or
          ((GetTickCount - MagicEvent.dwStartTick) > 180000) then begin
          MagicEvent.BaseObjectList.Free;
          III := 0;
          while (True) do begin
            try//20101126 ��ֹ��ѭ��
              if MagicEvent.Events[III] <> nil then begin
                TEvent(MagicEvent.Events[III]).Close();
              end;
            except
            end;
            Inc(III);
            if III >= 8 then Break;
          end;
          m_MagicEventList.Delete(I);//20091109 ��λ��
          Dispose(MagicEvent);
        end;
      end;
    end;
  end;
end;

function TUserEngine.AddMagic(Magic: pTMagic): Boolean;
var
  UserMagic: pTMagic;
begin
  Result := False;
  New(UserMagic);
  try
    UserMagic.wMagicId := Magic.wMagicId;
    UserMagic.sMagicName := Magic.sMagicName;
    UserMagic.btEffectType := Magic.btEffectType;
    UserMagic.btEffect := Magic.btEffect;
    //UserMagic.bt11 := Magic.bt11;
    UserMagic.wSpell := Magic.wSpell;
    UserMagic.wPower := Magic.wPower;
    UserMagic.TrainLevel := Magic.TrainLevel;
    //UserMagic.w02 := Magic.w02;
    UserMagic.MaxTrain := Magic.MaxTrain;
    UserMagic.btTrainLv := Magic.btTrainLv;
    UserMagic.btJob := Magic.btJob;
    //UserMagic.wMagicIdx := Magic.wMagicIdx;
    UserMagic.dwDelayTime := Magic.dwDelayTime;
    UserMagic.btDefSpell := Magic.btDefSpell;
    UserMagic.btDefPower := Magic.btDefPower;
    UserMagic.wMaxPower := Magic.wMaxPower;
    UserMagic.btDefMaxPower := Magic.btDefMaxPower;
    UserMagic.sDescr := Magic.sDescr;
    m_MagicList.Add(UserMagic);
    Result := True;
  except
    Dispose(UserMagic);//20090213 ��ֹ�쳣���ͷ��ڴ�
  end;
end;


function TUserEngine.FindHeroMagic(sMagicName: string): pTMagic;
var
  I: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (m_OldMagicList.Count > 0) then
    MagicList := TList(m_OldMagicList.Items[m_OldMagicList.Count - 1])
  else
    MagicList := m_MagicList;
    if (MagicList <> nil) and (MagicList.Count > 0) then begin//20081008
      for I := 0 to MagicList.Count - 1 do begin
        Magic := MagicList.Items[I];
        if (Magic <> nil) then begin
          if (Magic.sDescr = 'Ӣ��'){$IF M2Version <> 2} or (Magic.sDescr = '�ڹ�') or
            (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��') or (Magic.sDescr = '��'){$IFEND} then begin
            if CompareText(Magic.sMagicName, sMagicName) = 0 then begin
              Result := Magic;
              Break;
            end;
          end;
        end;
      end;//for
    end;
end;

function TUserEngine.FindMagic(sMagicName: string): pTMagic;
var
  I: Integer;
  Magic: pTMagic;
  MagicList: TList;
begin
  Result := nil;
  if (m_boStartLoadMagic) and (m_OldMagicList.Count > 0) then
    MagicList := TList(m_OldMagicList.Items[m_OldMagicList.Count - 1])
  else
    MagicList := m_MagicList;
    if (MagicList <> nil) and (MagicList.Count > 0) then begin//20081008
      for I := 0 to MagicList.Count - 1 do begin
        Magic := MagicList.Items[I];
        if (Magic <> nil) then begin
          if (Magic.sDescr = ''){$IF M2Version <> 2} or (Magic.sDescr = '�ڹ�') or
            (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��') or (Magic.sDescr = '��'){$IFEND} then begin
            if CompareText(Magic.sMagicName, sMagicName) = 0 then begin
              Result := Magic;
              Break;
            end;
          end;
        end;
      end;//for
    end;
end;
//ȡ��ͼ��Χ���й�
function TUserEngine.GetMapRangeMonster(Envir: TEnvirnoment; nX, nY, nRange: Integer; List: TList): Integer;
var
  I, II: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then Exit;
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[I];
      if MonGen <> nil then begin//20090213
        if (MonGen.Envir <> nil) and (MonGen.Envir <> Envir) then Continue;
        if MonGen.CertList.Count > 0 then begin//20081008
          for II := 0 to MonGen.CertList.Count - 1 do begin
            BaseObject := TBaseObject(MonGen.CertList.Items[II]);
            if BaseObject <> nil then begin
              if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir)
                and (abs(BaseObject.m_nCurrX - nX) <= nRange) and (abs(BaseObject.m_nCurrY - nY) <= nRange) then begin
                if List <> nil then List.Add(BaseObject);
                Inc(Result);
              end;
            end;
          end;//for
        end;
      end;
    end;
  end;
end;
//���ӽ���NPC
procedure TUserEngine.AddMerchant(Merchant: TMerchant);
begin
  m_MerchantList.Lock;
  try
    m_MerchantList.Add(Merchant);
  finally
    m_MerchantList.UnLock;
  end;
end;
//ȡ����NPC�б�
function TUserEngine.GetMerchantList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer;
var
  I: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    if m_MerchantList.Count > 0 then begin//20081008
      for I := 0 to m_MerchantList.Count - 1 do begin
        Merchant := TMerchant(m_MerchantList.Items[I]);
        if Merchant <> nil then begin
          if (Merchant.m_PEnvir = Envir) and
            (abs(Merchant.m_nCurrX - nX) <= nRange) and
            (abs(Merchant.m_nCurrY - nY) <= nRange) then begin
            TmpList.Add(Merchant);
          end;
        end;
      end; // for
    end;
  finally
    m_MerchantList.UnLock;
  end;
  Result := TmpList.Count;
end;
//ȡNPC�б�
function TUserEngine.GetNpcList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer;
var
  I: Integer;
  NPC: TNormNpc;
begin
  if QuestNPCList.Count > 0 then begin//20081008
    for I := 0 to QuestNPCList.Count - 1 do begin
      NPC := TNormNpc(QuestNPCList.Items[I]);
      if NPC <> nil then begin
        if (NPC.m_PEnvir = Envir) and
          (abs(NPC.m_nCurrX - nX) <= nRange) and
          (abs(NPC.m_nCurrY - nY) <= nRange) then begin
          TmpList.Add(NPC);
        end;
      end;
    end; // for
  end;
  Result := TmpList.Count;
end;
{//���¼���NPC�б�
procedure TUserEngine.ReloadMerchantList();
var
  I: Integer;
  Merchant: TMerchant;
begin
  m_MerchantList.Lock;
  try
    if m_MerchantList.Count > 0 then begin//20081008
      for I := 0 to m_MerchantList.Count - 1 do begin
        Merchant := TMerchant(m_MerchantList.Items[I]);
        if Merchant <> nil then begin
          if not Merchant.m_boGhost then begin
            Merchant.ClearScript;
            Merchant.LoadNpcScript;
          end;
        end;
      end; // for
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;}
//�ض�NPC�ű�
procedure TUserEngine.ReloadNpcList();
var
  I: Integer;
  NPC: TNormNpc;
begin
  if QuestNPCList.Count > 0 then begin//20081008
    for I := 0 to QuestNPCList.Count - 1 do begin
      NPC := TNormNpc(QuestNPCList.Items[I]);
      if NPC <> nil then begin
        if not NPC.m_boGhost then begin//20090422 ����
          NPC.ClearScript;
          NPC.LoadNpcScript;
        end;
      end;
    end;
  end;
end;
//ȡ��ͼ��������
function TUserEngine.GetMapMonster(Envir: TEnvirnoment; List: TList): Integer;
var
  I, II: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if Envir = nil then Exit;
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[I];
      if MonGen = nil then Continue;
      if MonGen.CertList.Count > 0 then begin//20081008
        for II := 0 to MonGen.CertList.Count - 1 do begin
          BaseObject := TBaseObject(MonGen.CertList.Items[II]);
          if BaseObject <> nil then begin
            if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and (BaseObject.m_PEnvir = Envir) then begin
              if List <> nil then List.Add(BaseObject);
              Inc(Result);
            end;
          end;
        end;
      end;
    end;//for
  end;
end;

//20080123 ����ͼָ������ָ�����ƹ�������
function TUserEngine.GetMapMonsterCount(Envir: TEnvirnoment; nX, nY, nRange:Integer; Name:string): Integer;
var
  I, II,nC: Integer;
  MonGen: pTMonGenInfo;
  BaseObject: TBaseObject;
begin
  Result := 0;
  nC := nRange;
  if Envir = nil then Exit;
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[I];
      if MonGen = nil then Continue;
      if MonGen.CertList.Count > 0 then begin//20081008
        for II := 0 to MonGen.CertList.Count - 1 do begin
          BaseObject := TBaseObject(MonGen.CertList.Items[II]);
          if BaseObject <> nil then begin
            if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir)
             and (CompareText(BaseObject.m_sCharName, Name) = 0)  then begin
              //nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
              //if nC <= 5  then Inc(Result); //20080323 �޸� <=5
              if (abs(nX - BaseObject.m_nCurrX) <= nC) and (abs(nY - BaseObject.m_nCurrY) <= nC) then begin//20081217 �޸�
                Inc(Result);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//�ʺŹ���
procedure TUserEngine.HumanExpire(sAccount: string);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if not g_Config.boKickExpireHuman then Exit;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if CompareText(PlayObject.m_sUserID, sAccount) = 0 then begin
          PlayObject.m_boExpire := True;
          Break;
        end;
      end;
    end;
  end;
end;
//ȡ��ͼ����
function TUserEngine.GetMapHuman(sMapName: string): Integer;
var
  I: Integer;
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := 0;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir = nil then Exit;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if not PlayObject.m_boDeath and not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then
          Inc(Result);
      end;
    end;
  end;
end;
//ȡ��ͼ��Χ�ڵ�����
function TUserEngine.GetMapRageHuman(Envir: TEnvirnoment; nRageX,
  nRageY, nRage: Integer; List: TList): Integer;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := 0;
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if not PlayObject.m_boDeath and not PlayObject.m_boGhost and
          (PlayObject.m_PEnvir = Envir) and
          (abs(PlayObject.m_nCurrX - nRageX) <= nRage) and
          (abs(PlayObject.m_nCurrY - nRageY) <= nRage) then begin
          List.Add(PlayObject);
          Inc(Result);
        end;
      end;
    end;
  end;
end;
{//�жϹ������귶Χ���Ƿ������ 20080520
function TUserEngine.IsMapRageHuman(sMapName: string; nRageX, nRageY, nRage: Integer): Boolean;
var
  I: Integer;
  PlayObject: TPlayObject;
  Envir: TEnvirnoment;
begin
  Result := False;
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (m_PlayObjectList.Count = 0) then Exit;
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
    if PlayObject <> nil then begin
      if not PlayObject.m_boDeath and
        not PlayObject.m_boGhost and
        (PlayObject.m_PEnvir = Envir) and
        (abs(PlayObject.m_nCurrX - nRageX) <= nRage) and
        (abs(PlayObject.m_nCurrY - nRageY) <= nRage) then begin
        Result := True;
        Break;
      end;
    end;
  end;
end;  }

function TUserEngine.GetStdItemIdx(sItemName: string): Integer;
var
  I: Integer;
  StdItem: pTStdItem;
begin
  Result := -1;
  if sItemName = '' then Exit;
  try//20100125 ����
    if StdItemList.Count > 0 then begin
      for I := 0 to StdItemList.Count - 1 do begin
        StdItem := StdItemList.Items[I];
        if StdItem <> nil then begin
          if CompareText(StdItem.Name, sItemName) = 0 then begin
            Result := I + 1;
            Break;
          end;
        end;
      end;
    end;
  except
    Result := -1;
  end;
end;

//==========================================
//��ÿ�����﷢����Ϣ
//�̰߳�ȫ
//==========================================
procedure TUserEngine.SendBroadCastMsgExt(sMsg: string; MsgType: TMsgType);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    if m_PlayObjectList.Count > 0 then begin
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (not PlayObject.m_boGhost) and (not PlayObject.m_boNotOnlineAddExp)
            and (not PlayObject.m_boAI) then PlayObject.SysMsg(sMsg, c_Red, MsgType);
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsgExt1(sMsg: string; MsgType: TMsgType; FColor, BColor: Byte);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    if m_PlayObjectList.Count > 0 then begin
      for I := 0 to m_PlayObjectList.Count - 1 do begin
        PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
        if PlayObject <> nil then begin
          if (not PlayObject.m_boGhost) and (not PlayObject.m_boNotOnlineAddExp)
            and (not PlayObject.m_boAI) then PlayObject.SysMsg1(sMsg, c_Red, MsgType, FColor, BColor);
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsg(sMsg: string; MsgType: TMsgType);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boGhost) and (not PlayObject.m_boNotOnlineAddExp)
            and (not PlayObject.m_boAI) then PlayObject.SysMsg(sMsg, c_Red, MsgType);
      end;
    end;
  end;
end;
//��ǿ���ļ���Ϣ���ͺ���(��NPC����-SendMsgʹ��) 20081214
procedure TUserEngine.SendBroadCastMsg1(sMsg: string; MsgType: TMsgType; FColor, BColor: Byte);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if m_PlayObjectList.Count > 0 then begin
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boGhost) and (not PlayObject.m_boNotOnlineAddExp)
          and (not PlayObject.m_boAI) then PlayObject.SysMsg1(sMsg, c_Red, MsgType, FColor, BColor);
      end;
    end;
  end;
end;
//��ѯ���������Ƿ����ͷ��б��У�������Ƿ�����
function TUserEngine.QueryNameInFreeList(ChrName: string): Boolean;
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  Result := False;              
  try
    if (m_PlayObjectFreeList.Count > 0) and g_Config.boPasswordLockSystem then begin
      for I := m_PlayObjectFreeList.Count - 1 downto 0 do begin
        PlayObject := TPlayObject(m_PlayObjectFreeList.Items[I]);
        if PlayObject <> nil then begin
          if CompareText(PlayObject.m_sCharName, ChrName)= 0 then begin
            if PlayObject.m_boLockLogoned then begin//�������
              Result := True;
            end;
            Break;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.QueryNameInFreeList',[g_sExceptionVer]));
  end;
end;

procedure TUserEngine.Execute;
begin
  Run;
end;

procedure TUserEngine.sub_4AE514(GoldChangeInfo: pTGoldChangeInfo);
var
  GoldChange: pTGoldChangeInfo;
begin
  if GoldChangeInfo <> nil then begin//20090202
    New(GoldChange);
    GoldChange^ := GoldChangeInfo^;
    EnterCriticalSection(m_LoadPlaySection);
    try
      m_ChangeHumanDBGoldList.Add(GoldChange);
    finally
      LeaveCriticalSection(m_LoadPlaySection);
    end;
  end;
end;
//��չ���˵�б�
procedure TUserEngine.ClearMonSayMsg;
var
  I, II: Integer;
  MonGen: pTMonGenInfo;
  MonBaseObject: TBaseObject;
begin
  if m_MonGenList.Count > 0 then begin//20081008
    for I := 0 to m_MonGenList.Count - 1 do begin
      MonGen := m_MonGenList.Items[I];
      if (MonGen <> nil) then begin
        if (MonGen.CertList <> nil) then begin
          if MonGen.CertList.Count > 0 then begin//20081008
            for II := 0 to MonGen.CertList.Count - 1 do begin
              MonBaseObject := TBaseObject(MonGen.CertList.Items[II]);
              if MonBaseObject <> nil then MonBaseObject.m_SayMsgList := nil;
            end;
          end;
        end;
      end;
    end;
  end;
end;
//M2������Ҫ����,CPU �ڴ��ռ�ô󲿷������
procedure TUserEngine.PrcocessData;
var
  dwUsrTimeTick: LongWord;
  sMsg: string;
  nCode: Byte;
begin
  //sleep(1);
  nCode:= 0;
  try
    dwUsrTimeTick := GetTickCount();
    ProcessHumans();
    nCode:= 1;
    if g_Config.boSendOnlineCount and (GetTickCount - g_dwSendOnlineTick > g_Config.dwSendOnlineTime) then begin
      g_dwSendOnlineTick := GetTickCount();
      nCode:= 4;
      sMsg := AnsiReplaceText(g_sSendOnlineCountMsg, '%c', IntToStr(Round(GetOnlineHumCount * (g_Config.nSendOnlineCountRate / 10))));
      SendBroadCastMsg(sMsg, t_System)
    end;
    if (GetTickCount() - dwProcessMonstersTick) > g_Config.dwProcessMonstersTime then begin//20100614 �޸�
      nCode:= 13;
      dwProcessMonstersTick := GetTickCount();//20100614
      ProcessMonsters();
    end;
    nCode:= 6;
    ProcessMerchants();
    nCode:= 7;
    ProcessNpcs();

    if (GetTickCount() - dwProcessMissionsTime) > {1000}2000 then begin//20100614 �޸�
      dwProcessMissionsTime := GetTickCount();
      nCode:= 8;
      ProcessEvents();
    end;
    nCode:= 10;
    if (GetTickCount() - dwProcessMapDoorTick) > 500 then begin
      dwProcessMapDoorTick := GetTickCount();
      nCode:= 11;
      ProcessMapDoor();
    end;                
    g_nUsrTimeMin := GetTickCount() - dwUsrTimeTick;
    if g_nUsrTimeMax < g_nUsrTimeMin then g_nUsrTimeMax := g_nUsrTimeMin;
  except
    MainOutMessage(Format('{%s} TUserEngine::ProcessData Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
{//20090820 ע��
function TUserEngine.MapRageHuman(sMapName: string; nMapX, nMapY, nRage: Integer): Boolean;
var
  nX, nY: Integer;
  Envir: TEnvirnoment;
begin
  Result := False;
  Envir := g_MapManager.FindMap(sMapName);
  if Envir <> nil then begin
    for nX := nMapX - nRage to nMapX + nRage do begin
      for nY := nMapY - nRage to nMapY + nRage do begin
        if Envir.GetXYHuman(nMapX, nMapY) then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
end;}    
//ȫ�����ﴥ��
procedure TUserEngine.SendQuestMsg(sQuestName: string);
var
  I: Integer;
  PlayObject: TPlayObject;
begin
  if m_PlayObjectList.Count > 0 then begin//20081008
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject := TPlayObject(m_PlayObjectList.Objects[I]);
      if PlayObject <> nil then begin
        if (not PlayObject.m_boDeath) and (not PlayObject.m_boGhost) and (g_ManageNPC <> nil) then//20090213
          g_ManageNPC.GotoLable(PlayObject, sQuestName, False, False);
      end;
    end;
  end;
end;


procedure TUserEngine.SwitchMagicList();
begin
  if m_MagicList.Count > 0 then begin
    m_OldMagicList.Add(m_MagicList);
    m_MagicList := TList.Create;
  end;
  m_boStartLoadMagic := True;
end;

//ȡ������Ʒ
function TUserEngine.GetShopStdItem(sItemName: string): pTStdItem;
var
  I: Integer;
  ShopInfo: pTShopInfo;
begin
  Result := nil;
  Try
    if sItemName = '' then Exit;
    if g_ShopItemList.Count > 0 then begin//20080629
      for I := 0 to g_ShopItemList.Count - 1 do begin
        ShopInfo := g_ShopItemList.Items[I];
        if ShopInfo <> nil then begin//20090213
          if CompareText(ShopInfo.StdItem.Name, sItemName) = 0 then begin
            Result := @ShopInfo.StdItem;
            break;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TUserEngine.GetShopStdItem',[g_sExceptionVer]));
  end;
end;

//�Ƿ��ǵ�¼�����˺�
function TUserEngine.sAccountIsLogined(sAccount: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if m_PlayObjectList.Count > 0 then begin
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      if (CompareText(TPlayObject(m_PlayObjectList.Objects[I]).m_sUserID, sAccount) = 0) then begin
        Result := True;
        Break;
      end;
    end;//for
  end;
end;

//ȡװ���ķ�ֵ 20110117
Function TUserEngine.GetItemPoint(UserItem1: TUserItem; StdItem1: TStdItem; boCheckValue: Boolean): Integer;
var
  I:integer;
  nInt64: LongWord;
begin
  Result := 0;
  nInt64:= 0;
  case StdItem1.StdMode of
    5,6: begin
      for I := 0 to 7 do begin
        if (UserItem1.btValue[I] = 0) or (I = 4) then Continue;//����
        if I = 3 then Inc(nInt64, UserItem1.btValue[I]* 3)//����*3��
        else Inc(nInt64, UserItem1.btValue[I]* 2);
      end;
      Inc(nInt64, (UserItem1.btValue[11] * 2));//�����ȼ�
      Inc(nInt64, HiWord(StdItem1.AC) * 2 + HiWord(StdItem1.Mac) + HiWord(StdItem1.DC) * 2 + HiWord(StdItem1.MC) * 2 + HiWord(StdItem1.SC) * 2);
      case StdItem1.AniCount of//�ж���������
        112: Inc(nInt64, 50);
        113,114,117,118,139,143,144,150..170,189..192,197..202: Inc(nInt64, 100);
      end;
    end;
    10,11,30: begin
      for I := 0 to 4 do begin
        if UserItem1.btValue[I] = 0 then Continue;//����
        Inc(nInt64, UserItem1.btValue[I]* 2);
      end;
      Inc(nInt64, HiWord(StdItem1.AC) * 2 + HiWord(StdItem1.Mac) + HiWord(StdItem1.DC) * 2 + HiWord(StdItem1.MC) * 2 + HiWord(StdItem1.SC) * 2);
      case StdItem1.AniCount of//�ж���������
        112: Inc(nInt64, 50);
        113,114,117,118,139,143,144,150..170,189..192,197..202: Inc(nInt64, 100);
      end;
    end;
    15,16,19..24,26..29,52,54,55,62,64: begin
      for I := 0 to 4 do begin
        if UserItem1.btValue[I] = 0 then Continue;//����
        Inc(nInt64, UserItem1.btValue[I]* 2);
      end;
      Inc(nInt64, HiWord(StdItem1.AC) * 2 + HiWord(StdItem1.Mac) + HiWord(StdItem1.DC) * 2 + HiWord(StdItem1.MC) * 2 + HiWord(StdItem1.SC) * 2);
      case StdItem1.shape of//�ж���������
        112: Inc(nInt64, 50);
        113,114,117,118,139,143,144,150..170,189..192,197..202: Inc(nInt64, 250);
      end;
    end;
  end;
  case StdItem1.Need of
    18..21: Inc(nInt64, StdItem1.Stock * 3);//�����ָ��ٶ�%(��ţװ��)
    22..25: Inc(nInt64, StdItem1.Stock);//�����ָ�����
    26..29: Inc(nInt64, StdItem1.Stock * 5);//��������(����װ��)
    30..33: Inc(nInt64, StdItem1.Stock * 3);//��Ѫ����(����װ��)
    34..37: begin//��ɱ����
      if (StdItem1.Source > 0) and (StdItem1.StdMode <> 16) and (StdItem1.StdMode <> 19) then Inc(nInt64,StdItem1.Source * 3);//����
      Inc(nInt64,StdItem1.Stock);//Ŀ������ֵ���ٵ���(����װ��)
    end;
    45..48: Inc(nInt64,StdItem1.Stock * 6);//�������(�Ի��·�)
  end;
  if boCheckValue then begin
    for I := 2 to 5 do begin
      if UserItem1.btAppraisalValue[I] = 0 then Continue;//����
      case UserItem1.btAppraisalValue[I] of
        1..7: Inc(nInt64, 250{30});//���⼼��,��ֱ��Ϊ����װ�� 20110514 �޸�
        11..20: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 10) * 4);//��������
        21..30: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 20) * 4);//ħ������
        31..40: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 30) * 4);//��������
        41..50: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 40));//ħ������(ħ����������)
        51..60: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 50));//�������(�����������)
        61..70: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 60) * 6);//������
        71..80: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 70) * 2);//�����ָ�(ͬ���飬��ţ)
        81..90: Inc(nInt64, (UserItem1.btAppraisalValue[I] - 80) * 2);//��ħ�ȼ�(������ְҵ��ͬ�ӵ�ħ������Ӧ���ǲ�ͬ)
        91..100:Inc(nInt64, (UserItem1.btAppraisalValue[I] - 90) * 3);//ǿ��ȼ�(��Ѫ��ְҵ��ͬ�ӵ�Ѫ����ͬ ս+50 ��+20 ��+35)
        101..110:Inc(nInt64, (UserItem1.btAppraisalValue[I] -100) * 2);//��Ѫ����(�뻢��װ������ͬ)
        111..120:Inc(nInt64, (UserItem1.btAppraisalValue[I] -110) * 2);//���˵ȼ�
        121..130:Inc(nInt64, (UserItem1.btAppraisalValue[I] -120) * 6);//�����ȼ�(�������ʯ�ı�������)
        131..140:Inc(nInt64, (UserItem1.btAppraisalValue[I] -130) * 2);//����
        141..150:Inc(nInt64, (UserItem1.btAppraisalValue[I] -140));//׼ȷ
        151..160:Inc(nInt64, (UserItem1.btAppraisalValue[I] -150));//����
        161..180:Inc(nInt64, (UserItem1.btAppraisalValue[I] -160));//��Կ���(1..20)
        181..230:Inc(nInt64, (UserItem1.btAppraisalValue[I] -180));//�ϻ�����(1..50) (ͬ��ţ�ĺϻ��˺�)
        231..250:Inc(nInt64, (UserItem1.btAppraisalValue[I] -230));//��ý
        255: Inc(nInt64);//��������δ���
      end;//case
    end;
    for I := 6 to 9 do begin
      if UserItem1.btUnKnowValue[I] = 0 then Continue;//����
      case UserItem1.btUnKnowValue[I] of
        1..7: Inc(nInt64, 250{30});//���⼼��,��ֱ��Ϊ����װ�� 20110514 �޸�
        11..20: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 10) * 4);//��������
        21..30: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 20) * 4);//ħ������
        31..40: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 30) * 4);//��������
        41..50: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 40));//ħ������(ħ����������)
        51..60: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 50));//�������(�����������)
        61..70: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 60) * 6);//������
        71..80: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 70) * 2);//�����ָ�(ͬ���飬��ţ)
        81..90: Inc(nInt64, (UserItem1.btUnKnowValue[I] - 80) * 2);//��ħ�ȼ�(������ְҵ��ͬ�ӵ�ħ������Ӧ���ǲ�ͬ)
        91..100:Inc(nInt64, (UserItem1.btUnKnowValue[I] - 90) * 3);//ǿ��ȼ�(��Ѫ��ְҵ��ͬ�ӵ�Ѫ����ͬ ս+50 ��+20 ��+35)
        101..110:Inc(nInt64, (UserItem1.btUnKnowValue[I] -100) * 2);//��Ѫ����(�뻢��װ������ͬ)
        111..120:Inc(nInt64, (UserItem1.btUnKnowValue[I] -110) * 2);//���˵ȼ�
        121..130:Inc(nInt64, (UserItem1.btUnKnowValue[I] -120) * 6);//�����ȼ�(�������ʯ�ı�������)
        131..140:Inc(nInt64, (UserItem1.btUnKnowValue[I] -130) * 2);//����
        141..150:Inc(nInt64, (UserItem1.btUnKnowValue[I] -140));//׼ȷ
        151..160:Inc(nInt64, (UserItem1.btUnKnowValue[I] -150));//����
        161..180:Inc(nInt64, (UserItem1.btUnKnowValue[I] -160));//��Կ���(1..20)
        181..230:Inc(nInt64, (UserItem1.btUnKnowValue[I] -180));//�ϻ�����(1..50) (ͬ��ţ�ĺϻ��˺�)
        231..250:Inc(nInt64, (UserItem1.btUnKnowValue[I] -230));//��ý
        255: Inc(nInt64);//��������δ���
      end;//case
    end;
  end;
  if nInt64 > High(Word) then Result := High(Word) else Result := nInt64;
end;

function TUserEngine.AddAIPlayObject(AI: pTAILogon): TAIPlayObject;
var
  Map: TEnvirnoment;
  Cert: TAIPlayObject;
  n1C, n20, n24: Integer;
  p28: Pointer;
begin
  Result := nil;
  Cert := nil;

  Map := g_MapManager.FindMap(AI.sMapName);

  if Map = nil then Exit;

  Cert := TAIPlayObject.Create;
  if Cert <> nil then begin
    Cert.m_PEnvir := Map;
    Cert.m_sMapName := AI.sMapName;
    Cert.m_nCurrX := AI.nX;
    Cert.m_nCurrY := AI.nY;
    Cert.m_btDirection := Random(8);
    Cert.m_sCharName := AI.sCharName;
    Cert.m_WAbil := Cert.m_Abil;
    if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye := True;

    Cert.m_sIPaddr := GetIPAddr; // Mac����
    Cert.m_dwHCode := Cert.m_dwHCode;
    Cert.m_sIPLocal := GetIPLocal(Cert.m_sIPaddr);

    Cert.m_sConfigFileName := AI.sConfigFileName;
    Cert.m_sHeroConfigFileName := AI.sHeroConfigFileName;
    Cert.m_sFilePath := AI.sFilePath;
    Cert.m_sConfigListFileName := AI.sConfigListFileName;
    Cert.m_sHeroConfigListFileName:= AI.sHeroConfigListFileName;//Ӣ�������б�Ŀ¼
    Cert.Initialize;
    Cert.RecalcLevelAbilitys;
    Cert.RecalcAbilitys;
    Cert.m_WAbil.HP := Cert.m_WAbil.MaxHP;
    Cert.m_WAbil.MP := Cert.m_WAbil.MaxMP;

    if Cert.m_boAddtoMapSuccess then begin
      p28 := nil;
      if Cert.m_PEnvir.m_nWidth < 50 then n20 := 2
      else n20 := 3;
      if (Cert.m_PEnvir.m_nHeight < 250) then begin
        if (Cert.m_PEnvir.m_nHeight < 30) then n24 := 2
        else n24 := 20;
      end else n24 := 50;
      n1C := 0;
      while (True) do begin
        if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX, Cert.m_nCurrY, False) then begin
          if (Cert.m_PEnvir.m_nWidth - n24 - 1) > Cert.m_nCurrX then begin
            Inc(Cert.m_nCurrX, n20);
          end else begin
            Cert.m_nCurrX := Random(Cert.m_PEnvir.m_nWidth div 2) + n24;
            if Cert.m_PEnvir.m_nHeight - n24 - 1 > Cert.m_nCurrY then begin
              Inc(Cert.m_nCurrY, n20);
            end else begin
              Cert.m_nCurrY := Random(Cert.m_PEnvir.m_nHeight div 2) + n24;
            end;
          end;
        end else begin
          p28 := Cert.m_PEnvir.AddToMap(Cert.m_nCurrX, Cert.m_nCurrY, OS_MOVINGOBJECT, Cert);
          Break;
        end;
        Inc(n1C);
        if n1C >= 31 then Break;
      end;
      if p28 = nil then begin
        FreeAndNil(Cert);
      {end else begin
        Inc(Cert.m_nViewRange, 2); //2006-12-30 �����Ӿ�+2    }
      end;
    end;
  end;
  Result := Cert;
end;

function TUserEngine.FindAILogon(sCharName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  m_UserLogonList.Lock;
  try
    for I := 0 to m_UserLogonList.Count - 1 do begin
      if CompareText(m_UserLogonList.Strings[I], sCharName) = 0 then begin
        Result := True;
        break;
      end;
    end;
  finally
    m_UserLogonList.UnLock;
  end;
end;

procedure TUserEngine.AddAILogon(aAI: pTAILogon);
var
  AI: pTAILogon;
begin
  m_UserLogonList.Lock;
  try
    New(AI);
    AI^ := aAI^;
    m_UserLogonList.AddObject(AI.sCharName, TObject(AI));
  finally
    m_UserLogonList.UnLock;
  end;
end;

function TUserEngine.RegenAIObject(AI: pTAILogon): Boolean;
var
  PlayObject: TPlayObject;
begin
  Result := False;
  //if GetPlayObject(AI.sCharName) = nil then begin
  if not GetPlayOnline(AI.sCharName) then begin//20110528 �޸�
    PlayObject := AddAIPlayObject(AI);
    if PlayObject <> nil then begin
      PlayObject.m_sHomeMap := GetHomeInfo(PlayObject.m_nHomeX, PlayObject.m_nHomeY);
      PlayObject.m_sUserID:= '����';
      m_PlayObjectList.AddObject(PlayObject.m_sCharName, PlayObject);
      Result := True;
    end;
  end;
end;

end.


