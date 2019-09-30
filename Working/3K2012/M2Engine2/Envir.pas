unit Envir;
{��ͼ����}
interface

uses
  Windows, SysUtils, Classes, SDK, Grobal2;
type
  {TMapHeader = packed record//20110428 �޸�
    wWidth: Word;
    wHeight: Word;
    sTitle: string[16];
    UpdateDate: TDateTime;
    Reserved: array[0..22] of Char;
  end; }
  //.MAP�ļ�ͷ  52�ֽ�
  TMapHeader = packed record
    wWidth: Word; //���       2
    wHeight: Word; //�߶�       2
    sTitle: array[0..15] of Char; //����      16
    UpdateDate: TDateTime; //��������     8
    Logo: Byte; //��ʶ(�µĸ�ʽΪ02 �ɸ�ʽ��ͼԪ��12�ֽ� �¸�ʽ��ͼԪ��14�ֽ�)           1
    Reserved: array[0..22] of Char; //����      23
  end;

  //��ͼ�ļ�һ��Ԫ�صĶ���(��12�ֽ�)
  TMapUnitInfo = packed record
    wBkImg: Word; //Ϊ��ֹ�ƶ�����(��ʾ��ͼ��ͼƬ)
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
  end;
  TMap = array[0..1000 * 1000 - 1] of TMapUnitInfo;
  pTMap = ^TMap;
  //��ͼ�ļ�һ��Ԫ�صĶ���(��14�ֽ�)
  TNewMapUnitInfo = packed record
    wBkImg: Word; //Ϊ��ֹ�ƶ�����(��ʾ��ͼ��ͼƬ)
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
    btNew: Word; //�¸�ʽ���2�ֽڲ���
  end;
  TNewMap = array[0..1000 * 1000 - 1] of TNewMapUnitInfo;
  pTNewMap = ^TNewMap;

  TMapCellinfo = record
    chFlag: Byte; //��־
    ObjList: TList;
  end;
  pTMapCellinfo = ^TMapCellinfo;
  PTEnvirnoment = ^TEnvirnoment;
  TEnvirnoment = class
    sMapName: string; //��ͼID
    sMapDesc: string; //��ͼ����
    sMainMapName: string; //���ص�ͼID
    m_boMainMap: Boolean; //
    MapCellArray: array of TMapCellinfo; //
    nMinMap: Integer; //С��ͼ����
    nServerIndex: Integer; //0x14
    nRequestLevel: Integer; //���뱾��ͼ����ȼ�
    m_nWidth: Integer; //��ͼ���
    m_nHeight: Integer; //��ͼ�߶�
    m_boDARK: Boolean; //����(T-��ͼȫ��)
    m_boDAY: Boolean; //��ͼȫ��
    m_boDarkness: Boolean;
    m_boDayLight: Boolean;
    m_DoorList: TList; //���б�
    bo2C: Boolean;
    m_boSAFE: Boolean; //��ȫ��
    m_boSafeNoRun: Boolean; //��ȫ�����ﲻ�ܴ�
    m_boSAFEHERONORUN: Boolean; //Ӣ�۰�ȫ�����ܴ�
    m_boFightZone: Boolean; //PK��ͼ
    m_boFight2Zone: Boolean; //PK��װ����ͼ
    m_boFight3Zone: Boolean; //�л�ս����ͼ
    m_boFight4Zone: Boolean; //��ս��ͼ
    m_boNoFight4Zone: Boolean; //��ֹ��ս��ͼ
    m_boFight5Zone: Boolean; //��ͬ�л����ֱ䲻ͬ��ɫ 20090318
    m_boQUIZ: Boolean; //0x30
    m_boNORECONNECT: Boolean; //0x31
    m_boNEEDHOLE: Boolean; //������Ҫ��
    m_boNORECALL: Boolean; //0x33
    m_boNOGUILDRECALL: Boolean;
    m_boNODEARRECALL: Boolean;
    m_boNOMASTERRECALL: Boolean;
    m_boNORANDOMMOVE: Boolean; //0x34
    m_boNODRUG: Boolean; //��ͼ������ʹ���κ�ҩƷ
    m_boMINE: Boolean; //�����ڿ�
    m_boDigJewel: Boolean; //�����ڱ� 20100902
    m_boSHOP: Boolean; //�����̵�
    m_boNOPOSITIONMOVE: Boolean; //0x37
    sNoReconnectMap: string; //0x38
    m_boHitMon: Boolean; //�����ִ��� 20110114
    sHitMonScript: string;
    QuestNPC: TObject; //0x3C
    nNEEDSETONFlag: Integer; //0x40
    nNeedONOFF: Integer; //0x44
    m_QuestList: TList; //�����ͼ����
    m_boNoManNoMon: Boolean; //���˲�ˢ��
    m_boRUNHUMAN: Boolean; //���Դ���
    m_boRUNMON: Boolean; //���Դ���
    m_boINCHP: Boolean; //�Զ���HPֵ
    m_boIncGameGold: Boolean; //�Զ�����Ϸ��
    m_boINCGAMEPOINT: Boolean; //�Զ��ӵ�
    m_boDECGAMEPOINT: Boolean; //�Զ�����Ϸ��
    m_boNEEDLEVELTIME: Boolean; //ѩ���ͼ����,�жϵȼ� 20081228
    m_nNEEDLEVELPOINT: Integer; //��ѩ���ͼ��͵ȼ�
    m_boNOCALLHERO: Boolean; //��ֹ�ٻ�Ӣ�� 20080124
    m_boNOHEROPROTECT: Boolean; //��ֹӢ���ػ� 20080629
    m_boNODROPITEM: Boolean; //��ֹ��������Ʒ 20080503
    m_boKILLFUNC: Boolean; //��ͼɱ�˴��� 20080415
    m_nKILLFUNC: Integer; //��ͼɱ�˴���  20080415
    m_boMISSION: Boolean; //������ʹ���κ���Ʒ�ͼ���
    m_boNOSKILL: Boolean; //������ʹ���κμ���,�ٻ��ı�����ʧ
    m_boDECHP: Boolean; //�Զ���HPֵ
    m_boDecGameGold: Boolean; //�Զ�����Ϸ��
    m_boMUSIC: Boolean; //����
    m_boEXPRATE: Boolean; //ɱ�־��鱶��
    m_boCRIT: Boolean; //�����ȼ�
    m_nCRIT: Integer;
    m_boPeak: Boolean; //�۷�״̬(��߹�������)
    m_nPeakMinRate: Integer; //��͹�������
    m_nPeakMaxRate: Integer; //��߹�������
    m_boPKWINLEVEL: Boolean; //PK�õȼ�
    m_boPKWINEXP: Boolean; //PK�þ���
    m_boPKLOSTLEVEL: Boolean; //PK���ȼ�
    m_boPKLOSTEXP: Boolean; //PK������
    m_nPKWINLEVEL: Integer; //PK�õȼ���
    m_nPKLOSTLEVEL: Integer; //PK���ȼ�
    m_nPKWINEXP: Integer; //PK�þ�����
    m_nPKLOSTEXP: Integer; //PK������
    m_nDECHPTIME: Integer; //��HP���ʱ��
    m_nDECHPPOINT: Integer; //һ�μ�����
    m_nINCHPTIME: Integer; //��HP���ʱ��
    m_nINCHPPOINT: Integer; //һ�μӵ���
    m_nDECGAMEGOLDTIME: Integer; //����Ϸ�Ҽ��ʱ��
    m_nDecGameGold: Integer; //һ�μ�����
    m_nINCGAMEGOLDTIME: Integer; //����Ϸ�Ҽ��ʱ��
    m_nIncGameGold: Integer; //һ�μ�����
    m_nINCGAMEPOINTTIME: Integer; //����Ϸ�Ҽ��ʱ��
    m_nINCGAMEPOINT: Integer; //һ�μ�����
    m_nDECGAMEPOINTTIME: Integer; //����Ϸ�Ҽ��ʱ��
    m_nDECGAMEPOINT: Integer; //һ�μ�����
    m_boDECEXPRATETIME: Boolean; //��˫������ʱ�� 20090206
    m_nDECEXPRATETIME: Integer; //һ�μ�˫������ֵ 20090206
    m_boPULSEXPRATE: Boolean; //��ͼɱ��Ӣ�۾��鱶�� 20091029
    m_nPULSEXPRATE: Integer; //��ͼɱ��Ӣ�۾��鱶�� 20091029
    m_boNGEXPRATE: Boolean; //��ͼɱ���ڹ����鱶�� 20091029
    m_nNGEXPRATE: Integer; //��ͼɱ���ڹ����鱶�� 20091029
    m_nMUSICID: Integer; //����ID
    m_sMUSICName: string; //����ID
    m_nEXPRATE: Integer; //���鱶��
    m_nMonCount: Integer; //��ͼ�Ϲ��������
    m_nHumCount: Integer; //��ͼ�����������
    m_nHumAICount: Integer; //��ͼ�ϼ��˵�����
    m_boUnAllowStdItems: Boolean; //�Ƿ�����ʹ����Ʒ
    m_UnAllowStdItemsList: TGStringList; //������ʹ����Ʒ�б�
    m_boUnAllowMagics: Boolean; //�Ƿ�����ʹ��ħ��
    m_UnAllowMagicList: TGStringList; //������ʹ��ħ���б�
    m_boChangMapDrops: Boolean; //����ͼ��ָ����Ʒ
    m_ChangMapDropsList: TGStringList; //����ͼ��ָ����Ʒ�б�
    m_boFIGHTPK: Boolean; //PK���Ա�װ��������
    nThunder: Integer; //�׵� ��ͼ���� 20080327
    nLava: Integer; //����ð�ҽ� ��ͼ����  20080327
    boLimitLevel: Boolean; //����ɫ����ָ���ȼ�1ʱ�����ȼ�2ֵ����HP MP ��ͼ����
    nLimitLevel1: Integer; //ָ���ȼ�1
    nLimitLevel2: Integer; //ָ���ȼ�2
    nLimitLevelHero: Integer; //ָ��Ӣ�۵ȼ�
    nLimitLevelHero1: Integer; //ָ��Ӣ�۵ȼ�
    m_PointList: TList; //�һ����б�

    m_boMirrorMap: Boolean; //�����ͼ
    m_boMirrorMaping: Boolean; //����ɾ�������ͼ
    m_dwMirrorMapTick: LongWord; //�����ͼ��Чʱ��
    sMirrorHomeMap: string; //ɾ�������ͼ����سǵ�ͼ
  private
    procedure Initialize(nWidth, nHeight: Integer);
  public
    constructor Create();
    destructor Destroy; override;
    function AddToMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Pointer; //���ӵ���ͼ��
    function ClearItem(nX, nY, nRage: Integer): Boolean;
    function CanWalk(nX, nY: Integer; boFlag: Boolean): Boolean;
    function CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean;
    function CanWalkEx(nX, nY: Integer; boFlag: Boolean): Boolean;
    function CanFly(nSX, nSY, nDX, nDY: Integer): Boolean;
    function MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer;
    function GetItem(nX, nY: Integer): PTMapItem; //ȡ��ͼ��Ʒ
    function DeleteFromMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Integer; //�ӵ�ͼ��ɾ��
    function IsCheapStuff(): Boolean; //�Ƿ��������ͼ����
    procedure AddDoorToMap; //�����ŵ���ͼ��
    //function AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject; //20101025 ע��
    function LoadMapData(sMapFile: string): Boolean; //��ȡ��ͼ����
    function CreateQuest(nFlag, nValue: Integer; s24, s28, s2C: string; boGrouped: Boolean): Boolean;
    function GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean;
    function GetXYObjCount(nX, nY: Integer): Integer;
    function GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
    function sub_4B5FC8(nX, nY: Integer): Boolean;
    procedure VerifyMapTime(nX, nY: Integer; BaseObject: TObject);
    function CanSafeWalk(nX, nY: Integer): Boolean;
    function ArroundDoorOpened(nX, nY: Integer): Boolean;
    function GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer; overload;
    function GetMovingObject(nX, nY: Integer; AObject: TObject; boFlag: Boolean): Pointer; overload;
    function GetQuestNPC(BaseObject: TObject; sCharName, sStr: string; boFlag: Boolean): TObject;
    function GetItemEx(nX, nY: Integer; var nCount: Integer): Pointer;
    function GetDoor(nX, nY: Integer): pTDoorInfo;
    function IsValidObject(nX, nY: Integer; nRage: Integer; BaseObject: TObject): Boolean; //��Ч�Ķ���
    function GetRangeBaseObject(nX, nY: Integer; nRage: Integer; boFlag: Boolean; BaseObjectList: TList): Integer; //ȡ��Χ�ڵĶ���
    function GeTBaseObjects(nX, nY: Integer; boFlag: Boolean; BaseObjectList: TList): Integer; //ȡ����
    function GetMapBaseObjects(nX, nY, nRage: Integer; rList: TList; btType: Byte = OS_MOVINGOBJECT): Boolean;
    function GetEvent(nX, nY: Integer): TObject;
    procedure SetMapXYFlag(nX, nY: Integer; boFlag: Boolean);
    function GetXYHuman(nMapX, nMapY: Integer): Boolean;
    function GetEnvirInfo(): string; //ȡ��ͼ��Ϣ
    function AllowStdItems(sItemName: string): Boolean; overload; //�Ƿ�����ʹ����Ʒ
    function AllowStdItems(nItemIdx: Integer): Boolean; overload; //�Ƿ�����ʹ����Ʒ
    function AllowMagics(sMagName: string): Boolean; overload; //�Ƿ�����ʹ��ħ��
    function AllowMagics(nMagIdx: Integer; tyte: Byte): Boolean; overload; //�Ƿ�����ʹ��ħ��
    function ChangMapDropStdItems(sItemName: string): Boolean; //����ͼ�Ƿ��ָ����Ʒ
    procedure AddObject(nType: Integer);
    procedure DelObjectCount(BaseObject: TObject);
    property MonCount: Integer read m_nMonCount; //��������
    property HumCount: Integer read m_nHumCount; //��ǰ��ͼ��������
    property HumAICount: Integer read m_nHumAICount; //��ͼ�ϼ��˵�����
    function GetMainMap(): string;
    property MapName: string read GetMainMap;
    function GetMapItem(nX, nY, nRage: Integer; BaseObjectList: TList): Integer; //20080124 ȡָ����ͼ��Χ�������Ʒ
  end;
  TMapManager = class(TGList)
    m_dwRunTick: LongWord;
    nMirrorMapsIndx: Integer; //ѭ������������
    m_MirrorMaps: TList; //�����ͼ�б�
  private
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadMapDoor();
    function AddMapInfo(sMapName, sMainMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
    function AddMapInfoEx(sMapName, sMapDesc, sMirrorHomeMap: string; nTime: Integer; MapEnvir: TEnvirnoment): TEnvirnoment; //���Ӿ����ͼ
    function GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment;
    function AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
    function GetMapOfServerIndex(sMapName: string): Integer;
    function FindMap(sMapName: string): TEnvirnoment; //���ҵ�ͼ
    function DelMap(sMapName: string): Boolean; //ɾ����ͼ
    function GetMainMap(Envir: TEnvirnoment): string;
    procedure ReSetMinMap();
    procedure Run();
    procedure ProcessMapDoor();
    procedure MakeSafePkZone();
  end;
implementation

uses ObjBase, ObjNpc, M2Share, Event, ObjMon, HUtil32, Castle;

{ TEnvirList }
//��ȫ����Ȧ

procedure TMapManager.MakeSafePkZone();
var
  nX, nY: Integer;
  SafeEvent: TSafeEvent;
  nMinX, nMaxX, nMinY, nMaxY: Integer;
  I: Integer;
  StartPoint: pTStartPoint;
  Envir: TEnvirnoment;
begin
  g_StartPointList.Lock;
  if g_StartPointList.Count > 0 then begin
    for I := 0 to g_StartPointList.Count - 1 do begin
      StartPoint := pTStartPoint(g_StartPointList.Objects[I]);
      if (StartPoint <> nil) then begin
        if (StartPoint.m_nType > 0) then begin
          Envir := FindMap(StartPoint.m_sMapName);
          if Envir <> nil then begin
            nMinX := StartPoint.m_nCurrX - StartPoint.m_nRange;
            nMaxX := StartPoint.m_nCurrX + StartPoint.m_nRange;
            nMinY := StartPoint.m_nCurrY - StartPoint.m_nRange;
            nMaxY := StartPoint.m_nCurrY + StartPoint.m_nRange;
            for nX := nMinX to nMaxX do begin
              for nY := nMinY to nMaxY do begin
                if ((nX < nMaxX) and (nY = nMinY)) or
                  ((nY < nMaxY) and (nX = nMinX)) or
                  (nX = nMaxX) or (nY = nMaxY) then begin
                  SafeEvent := TSafeEvent.Create(Envir, nX, nY, StartPoint.m_nType);
                  g_EventManager.AddEvent(SafeEvent);
                end;
              end;
            end;
          end;
        end;
      end;
    end; //for
  end;
end;
//���ӵ�ͼ

function TMapManager.AddMapInfo(sMapName, sMainMapName, sMapDesc: string; nServerNumber: Integer; MapFlag: pTMapFlag; QuestNPC: TObject): TEnvirnoment;
var
  Envir: TEnvirnoment;
  I: Integer;
  nStd: Integer;
  TempList: TStringList;
  sTemp: string;
begin
  Result := nil;
  Envir := TEnvirnoment.Create;
  Envir.sMapName := sMapName;
  Envir.sMainMapName := sMainMapName;
  //Envir.sSubMapName := sMapName;//δʹ�� 20080723
  Envir.sMapDesc := sMapDesc;
  if sMainMapName <> '' then Envir.m_boMainMap := True;
  Envir.nServerIndex := nServerNumber;
  Envir.m_boSAFE := MapFlag.boSAFE; //��ȫ��
  Envir.m_boSafeNoRun := MapFlag.boSafeNoRun; //��ȫ�����ﲻ�ܴ�
  Envir.m_boSAFEHERONORUN := MapFlag.boSAFEHERONORUN; //Ӣ�۰�ȫ�����ܴ� 20090525
  Envir.m_boFightZone := MapFlag.boFIGHT;
  Envir.m_boFight2Zone := MapFlag.boFIGHT2; //PK��װ����ͼ 20080525
  Envir.m_boFight3Zone := MapFlag.boFIGHT3;
  Envir.m_boFight4Zone := MapFlag.boFIGHT4; //��ս��ͼ 20080706
  Envir.m_boNoFight4Zone := MapFlag.boNoFIGHT4; //��ֹ��ս��ͼ
  Envir.m_boFight5Zone := MapFlag.boFIGHT5; //��ͬ�л����ֱ䲻ͬ��ɫ 20090318
  Envir.m_boDARK := MapFlag.boDARK;
  Envir.m_boDAY := MapFlag.boDAY;
  Envir.m_boQUIZ := MapFlag.boQUIZ;
  Envir.m_boNORECONNECT := MapFlag.boNORECONNECT;
  Envir.m_boNEEDHOLE := MapFlag.boNEEDHOLE;
  Envir.m_boNORECALL := MapFlag.boNORECALL;
  Envir.m_boNOGUILDRECALL := MapFlag.boNOGUILDRECALL;
  Envir.m_boNODEARRECALL := MapFlag.boNODEARRECALL;
  Envir.m_boNOMASTERRECALL := MapFlag.boNOMASTERRECALL;
  Envir.m_boNORANDOMMOVE := MapFlag.boNORANDOMMOVE;
  Envir.m_boNODRUG := MapFlag.boNODRUG;
  Envir.m_boMINE := MapFlag.boMINE;
  Envir.m_boDigJewel := MapFlag.boDigJewel; //�����ڱ� 20100902
  Envir.m_boSHOP := MapFlag.boSHOP;
  Envir.m_boNOPOSITIONMOVE := MapFlag.boNOPOSITIONMOVE;
  Envir.m_boNoManNoMon := MapFlag.boNoManNoMon; //���˲�ˢ��
  Envir.m_boRUNHUMAN := MapFlag.boRUNHUMAN; //���Դ���
  Envir.m_boRUNMON := MapFlag.boRUNMON; //���Դ���
  Envir.m_boNOSKILL := MapFlag.boNOSKILL;
  Envir.m_boDECHP := MapFlag.boDECHP; //�Զ���HPֵ
  Envir.m_boINCHP := MapFlag.boINCHP; //�Զ���HPֵ
  Envir.m_boDecGameGold := MapFlag.boDECGAMEGOLD; //�Զ�����Ϸ��
  Envir.m_boDECGAMEPOINT := MapFlag.boDECGAMEPOINT; //�Զ�����Ϸ��
  Envir.m_boIncGameGold := MapFlag.boINCGAMEGOLD; //�Զ�����Ϸ��
  Envir.m_boINCGAMEPOINT := MapFlag.boINCGAMEPOINT; //�Զ�����Ϸ��
  Envir.m_boNEEDLEVELTIME := MapFlag.boNEEDLEVELTIME; //ѩ���ͼ����,�жϵȼ� 20081228
  Envir.m_nNEEDLEVELPOINT := MapFlag.nNEEDLEVELPOINT; //��ѩ���ͼ��͵ȼ�
  Envir.m_boNOCALLHERO := MapFlag.boNOCALLHERO; //��ֹ�ٻ�Ӣ��  20080124
  Envir.m_boNOHEROPROTECT := MapFlag.boNOHEROPROTECT; //��ֹӢ���ػ�  20080629
  Envir.m_boNODROPITEM := MapFlag.boNODROPITEM; //��ֹ��������Ʒ  20080503
  Envir.m_boKILLFUNC := MapFlag.boKILLFUNC; //��ͼɱ�˴���  20080415
  Envir.m_nKILLFUNC := MapFlag.nKILLFUNC; //��ͼɱ�˴���  20080415
  Envir.m_boMISSION := MapFlag.boMISSION; //������ʹ���κ���Ʒ�ͼ���  20080124
  Envir.m_boMUSIC := MapFlag.boMUSIC; //����
  Envir.m_boEXPRATE := MapFlag.boEXPRATE; //ɱ�־��鱶��
  Envir.m_boCRIT := MapFlag.boCRIT; //�����ȼ�
  Envir.m_nCRIT := MapFlag.nCRIT;
  Envir.m_boPeak := MapFlag.boPeak; //�۷�״̬(��߹�������)
  Envir.m_nPeakMinRate := MapFlag.nPeakMinRate; //��͹�������
  Envir.m_nPeakMaxRate := MapFlag.nPeakMaxRate; //��߹�������
  Envir.m_boDECEXPRATETIME := MapFlag.boDECEXPRATETIME; //��˫������ʱ�� 20090206
  Envir.m_nDECEXPRATETIME := MapFlag.nDECEXPRATETIME; //һ�μ�˫������ֵ 20090206
  Envir.m_boPULSEXPRATE := MapFlag.boPULSEXPRATE; //��ͼɱ��Ӣ�۾��鱶�� 20091029
  Envir.m_nPULSEXPRATE := MapFlag.nPULSEXPRATE; //��ͼɱ��Ӣ�۾��鱶�� 20091029
  Envir.m_boNGEXPRATE := MapFlag.boNGEXPRATE; //��ͼɱ���ڹ����鱶�� 20091029
  Envir.m_nNGEXPRATE := MapFlag.nNGEXPRATE; //��ͼɱ���ڹ����鱶�� 20091029
  Envir.m_boPKWINLEVEL := MapFlag.boPKWINLEVEL; //PK�õȼ�
  Envir.m_boPKWINEXP := MapFlag.boPKWINEXP; //PK�þ���
  Envir.m_boPKLOSTLEVEL := MapFlag.boPKLOSTLEVEL;
  Envir.m_boPKLOSTEXP := MapFlag.boPKLOSTEXP;
  Envir.m_nPKWINLEVEL := MapFlag.nPKWINLEVEL; //PK�õȼ���
  Envir.m_nPKWINEXP := MapFlag.nPKWINEXP; //PK�þ�����
  Envir.m_nPKLOSTLEVEL := MapFlag.nPKLOSTLEVEL;
  Envir.m_nPKLOSTEXP := MapFlag.nPKLOSTEXP;
  Envir.m_nPKWINEXP := MapFlag.nPKWINEXP; //PK�þ�����
  Envir.m_nDECHPTIME := MapFlag.nDECHPTIME; //��HP���ʱ��
  Envir.m_nDECHPPOINT := MapFlag.nDECHPPOINT; //һ�μ�����
  Envir.m_nINCHPTIME := MapFlag.nINCHPTIME; //��HP���ʱ��
  Envir.m_nINCHPPOINT := MapFlag.nINCHPPOINT; //һ�μӵ���
  Envir.m_nDECGAMEGOLDTIME := MapFlag.nDECGAMEGOLDTIME; //����Ϸ�Ҽ��ʱ��
  Envir.m_nDecGameGold := MapFlag.nDECGAMEGOLD; //һ�μ�����
  Envir.m_nINCGAMEGOLDTIME := MapFlag.nINCGAMEGOLDTIME; //����Ϸ�Ҽ��ʱ��
  Envir.m_nIncGameGold := MapFlag.nINCGAMEGOLD; //һ�μ�����
  Envir.m_nINCGAMEPOINTTIME := MapFlag.nINCGAMEPOINTTIME; //����Ϸ����ʱ��
  Envir.m_nINCGAMEPOINT := MapFlag.nINCGAMEPOINT; //һ�μ�����
  Envir.m_nDECGAMEPOINTTIME := MapFlag.nDECGAMEPOINTTIME; //����Ϸ����ʱ��
  Envir.m_nDECGAMEPOINT := MapFlag.nDECGAMEPOINT; //һ�μ�����
  Envir.m_nMUSICID := MapFlag.nMUSICID; //����ID
  Envir.m_sMUSICName := MapFlag.sMUSICName; //��������
  Envir.m_nEXPRATE := MapFlag.nEXPRATE; //���鱶��
  Envir.m_boHitMon := MapFlag.boHitMon; //�����ִ��� 20110114
  Envir.sHitMonScript := MapFlag.sHitMonScript;
  Envir.sNoReconnectMap := MapFlag.sReConnectMap;
  Envir.QuestNPC := QuestNPC;
  Envir.nNEEDSETONFlag := MapFlag.nNEEDSETONFlag;
  Envir.nNeedONOFF := MapFlag.nNeedONOFF;
  Envir.m_boUnAllowStdItems := MapFlag.boUnAllowStdItems;
  Envir.m_boUnAllowMagics := MapFlag.boNOTALLOWUSEMAGIC;
  Envir.m_boChangMapDrops := MapFlag.boChangMapDrops;
  Envir.m_boFIGHTPK := MapFlag.boFIGHTPK; //PK���Ա�װ��������
  Envir.nThunder := MapFlag.nThunder;
  Envir.nLava := MapFlag.nLava;
  Envir.boLimitLevel := MapFlag.boLimitLevel; //����ɫ����ָ���ȼ�1ʱ�����ȼ�2ֵ����HP MP ��ͼ����
  Envir.nLimitLevel1 := MapFlag.nLimitLevel1; //ָ���ȼ�1
  Envir.nLimitLevel2 := MapFlag.nLimitLevel2; //ָ���ȼ�2
  Envir.nLimitLevelHero := MapFlag.nLimitLevelHero; //ָ��Ӣ�۵ȼ�
  Envir.nLimitLevelHero1 := MapFlag.nLimitLevelHero1; //ָ��Ӣ�۵ȼ�

  if (Envir.m_boUnAllowStdItems) and (MapFlag.sUnAllowStdItemsText <> '') then begin
    TempList := TStringList.Create;
    try
      ExtractStrings(['|', '\', '/'], [], PChar(Trim(MapFlag.sUnAllowStdItemsText)), TempList);
      if TempList.Count > 0 then begin
        for I := 0 to TempList.Count - 1 do begin
          nStd := UserEngine.GetStdItemIdx(Trim(TempList.Strings[I]));
          if nStd >= 0 then
            Envir.m_UnAllowStdItemsList.AddObject(Trim(TempList.Strings[I]), TObject(nStd));
        end;
      end;
    finally
      TempList.Free;
    end;
  end;

  if (Envir.m_boChangMapDrops) and (MapFlag.sChangMapDropsText <> '') then begin //20110301
    TempList := TStringList.Create;
    try
      ExtractStrings(['|', '\', '/'], [], PChar(Trim(MapFlag.sChangMapDropsText)), TempList);
      if TempList.Count > 0 then begin
        for I := 0 to TempList.Count - 1 do begin
          nStd := UserEngine.GetStdItemIdx(Trim(TempList.Strings[I]));
          if nStd >= 0 then
            Envir.m_ChangMapDropsList.AddObject(Trim(TempList.Strings[I]), TObject(nStd));
        end;
      end;
    finally
      TempList.Free;
    end;
  end;

  if (Envir.m_boUnAllowMagics) and (MapFlag.sUnAllowMagicText <> '') then begin
    TempList := TStringList.Create;
    try
      ExtractStrings(['|', '\', '/'], [], PChar(Trim(MapFlag.sUnAllowMagicText)), TempList);
      if TempList.Count > 0 then begin
        for I := 0 to TempList.Count - 1 do begin
          sTemp := Trim(TempList.Strings[I]);
          if sTemp <> '' then Envir.m_UnAllowMagicList.Add(sTemp);
        end;
      end;
    finally
      TempList.Free;
    end;
  end;

  if MiniMapList.Count > 0 then begin
    for I := 0 to MiniMapList.Count - 1 do begin
      if CompareText(MiniMapList.Strings[I], Envir.sMapName) = 0 then begin
        Envir.nMinMap := Integer(MiniMapList.Objects[I]);
        Break;
      end;
    end;
  end;
  if sMainMapName <> '' then begin
    if Envir.LoadMapData(g_Config.sMapDir + sMainMapName + '.map') then begin
      Result := Envir;
      Self.Add(Envir);
    end else begin
      MainOutMessage('��ͼ�ļ� ' + g_Config.sMapDir + sMainMapName + '.map' + ' δ�ҵ�������');
    end;
  end else begin
    if Envir.LoadMapData(g_Config.sMapDir + sMapName + '.map') then begin
      Result := Envir;
      Self.Add(Envir);
    end else begin
      MainOutMessage('��ͼ�ļ� ' + g_Config.sMapDir + sMapName + '.map' + ' δ�ҵ�������');
    end;
  end;
end;
//���Ӿ����ͼ

function TMapManager.AddMapInfoEx(sMapName, sMapDesc, sMirrorHomeMap: string; nTime: Integer; MapEnvir: TEnvirnoment): TEnvirnoment;
var
  Envir: TEnvirnoment;
  I: Integer;
  nStd: Integer;
  sTemp: string;
  QuestNPC: TMerchant;
begin
  Result := nil;
  Envir := TEnvirnoment.Create;
  Envir.sMapName := sMapName;
  Envir.sMapDesc := sMapDesc;
  if MapEnvir.sMainMapName <> '' then Envir.sMainMapName := MapEnvir.sMainMapName //20111005 ����
  else Envir.sMainMapName := MapEnvir.sMapName {sMainMapName}; //20110924 �޸�
  if Envir.sMainMapName <> '' then Envir.m_boMainMap := True;
  Envir.nServerIndex := MapEnvir.nServerIndex;
  Envir.m_boSAFE := MapEnvir.m_boSAFE; //��ȫ��
  Envir.m_boSafeNoRun := MapEnvir.m_boSafeNoRun; //��ȫ�����ﲻ�ܴ�
  Envir.m_boSAFEHERONORUN := MapEnvir.m_boSAFEHERONORUN; //Ӣ�۰�ȫ�����ܴ�
  Envir.m_boFightZone := MapEnvir.m_boFightZone;
  Envir.m_boFight2Zone := MapEnvir.m_boFight2Zone; //PK��װ����ͼ 20080525
  Envir.m_boFight3Zone := MapEnvir.m_boFight3Zone;
  Envir.m_boFight4Zone := MapEnvir.m_boFight4Zone; //��ս��ͼ 20080706
  Envir.m_boNoFight4Zone := MapEnvir.m_boNoFight4Zone; //��ֹ��ս��ͼ
  Envir.m_boFight5Zone := MapEnvir.m_boFight5Zone; //��ͬ�л����ֱ䲻ͬ��ɫ 20090318
  Envir.m_boDARK := MapEnvir.m_boDARK;
  Envir.m_boDAY := MapEnvir.m_boDAY;
  Envir.m_boQUIZ := MapEnvir.m_boQUIZ;
  Envir.m_boNORECONNECT := MapEnvir.m_boNORECONNECT;
  Envir.m_boNEEDHOLE := MapEnvir.m_boNEEDHOLE;
  Envir.m_boNORECALL := MapEnvir.m_boNORECALL;
  Envir.m_boNOGUILDRECALL := MapEnvir.m_boNOGUILDRECALL;
  Envir.m_boNODEARRECALL := MapEnvir.m_boNODEARRECALL;
  Envir.m_boNOMASTERRECALL := MapEnvir.m_boNOMASTERRECALL;
  Envir.m_boNORANDOMMOVE := MapEnvir.m_boNORANDOMMOVE;
  Envir.m_boNODRUG := MapEnvir.m_boNODRUG;
  Envir.m_boMINE := MapEnvir.m_boMINE;
  Envir.m_boDigJewel := MapEnvir.m_boDigJewel; //�����ڱ�
  Envir.m_boSHOP := MapEnvir.m_boSHOP;
  Envir.m_boNOPOSITIONMOVE := MapEnvir.m_boNOPOSITIONMOVE;
  Envir.m_boNoManNoMon := MapEnvir.m_boNoManNoMon; //���˲�ˢ��
  Envir.m_boRUNHUMAN := MapEnvir.m_boRUNHUMAN; //���Դ���
  Envir.m_boRUNMON := MapEnvir.m_boRUNMON; //���Դ���
  Envir.m_boNOSKILL := MapEnvir.m_boNOSKILL;
  Envir.m_boDECHP := MapEnvir.m_boDECHP; //�Զ���HPֵ
  Envir.m_boINCHP := MapEnvir.m_boINCHP; //�Զ���HPֵ
  Envir.m_boDecGameGold := MapEnvir.m_boDecGameGold; //�Զ�����Ϸ��
  Envir.m_boDECGAMEPOINT := MapEnvir.m_boDECGAMEPOINT; //�Զ�����Ϸ��
  Envir.m_boIncGameGold := MapEnvir.m_boIncGameGold; //�Զ�����Ϸ��
  Envir.m_boINCGAMEPOINT := MapEnvir.m_boINCGAMEPOINT; //�Զ�����Ϸ��
  Envir.m_boNEEDLEVELTIME := MapEnvir.m_boNEEDLEVELTIME; //ѩ���ͼ����,�жϵȼ� 20081228
  Envir.m_nNEEDLEVELPOINT := MapEnvir.m_nNEEDLEVELPOINT; //��ѩ���ͼ��͵ȼ�
  Envir.m_boNOCALLHERO := MapEnvir.m_boNOCALLHERO; //��ֹ�ٻ�Ӣ��  20080124
  Envir.m_boNOHEROPROTECT := MapEnvir.m_boNOHEROPROTECT; //��ֹӢ���ػ�  20080629
  Envir.m_boNODROPITEM := MapEnvir.m_boNODROPITEM; //��ֹ��������Ʒ  20080503
  Envir.m_boKILLFUNC := MapEnvir.m_boKILLFUNC; //��ͼɱ�˴���  20080415
  Envir.m_nKILLFUNC := MapEnvir.m_nKILLFUNC; //��ͼɱ�˴���  20080415
  Envir.m_boMISSION := MapEnvir.m_boMISSION; //������ʹ���κ���Ʒ�ͼ���  20080124
  Envir.m_boMUSIC := MapEnvir.m_boMUSIC; //����
  Envir.m_boEXPRATE := MapEnvir.m_boEXPRATE; //ɱ�־��鱶��
  Envir.m_boCRIT := MapEnvir.m_boCRIT; //�����ȼ�
  Envir.m_nCRIT := MapEnvir.m_nCRIT;
  Envir.m_boPeak := MapEnvir.m_boPeak; //�۷�״̬(��߹�������)
  Envir.m_nPeakMinRate := MapEnvir.m_nPeakMinRate; //��͹�������
  Envir.m_nPeakMaxRate := MapEnvir.m_nPeakMaxRate; //��߹�������
  Envir.m_boDECEXPRATETIME := MapEnvir.m_boDECEXPRATETIME; //��˫������ʱ�� 20090206
  Envir.m_nDECEXPRATETIME := MapEnvir.m_nDECEXPRATETIME; //һ�μ�˫������ֵ 20090206
  Envir.m_boPULSEXPRATE := MapEnvir.m_boPULSEXPRATE; //��ͼɱ��Ӣ�۾��鱶�� 20091029
  Envir.m_nPULSEXPRATE := MapEnvir.m_nPULSEXPRATE; //��ͼɱ��Ӣ�۾��鱶�� 20091029
  Envir.m_boNGEXPRATE := MapEnvir.m_boNGEXPRATE; //��ͼɱ���ڹ����鱶�� 20091029
  Envir.m_nNGEXPRATE := MapEnvir.m_nNGEXPRATE; //��ͼɱ���ڹ����鱶�� 20091029
  Envir.m_boPKWINLEVEL := MapEnvir.m_boPKWINLEVEL; //PK�õȼ�
  Envir.m_boPKWINEXP := MapEnvir.m_boPKWINEXP; //PK�þ���
  Envir.m_boPKLOSTLEVEL := MapEnvir.m_boPKLOSTLEVEL;
  Envir.m_boPKLOSTEXP := MapEnvir.m_boPKLOSTEXP;
  Envir.m_nPKWINLEVEL := MapEnvir.m_nPKWINLEVEL; //PK�õȼ���
  Envir.m_nPKWINEXP := MapEnvir.m_nPKWINEXP; //PK�þ�����
  Envir.m_nPKLOSTLEVEL := MapEnvir.m_nPKLOSTLEVEL;
  Envir.m_nPKLOSTEXP := MapEnvir.m_nPKLOSTEXP;
  Envir.m_nPKWINEXP := MapEnvir.m_nPKWINEXP; //PK�þ�����
  Envir.m_nDECHPTIME := MapEnvir.m_nDECHPTIME; //��HP���ʱ��
  Envir.m_nDECHPPOINT := MapEnvir.m_nDECHPPOINT; //һ�μ�����
  Envir.m_nINCHPTIME := MapEnvir.m_nINCHPTIME; //��HP���ʱ��
  Envir.m_nINCHPPOINT := MapEnvir.m_nINCHPPOINT; //һ�μӵ���
  Envir.m_nDECGAMEGOLDTIME := MapEnvir.m_nDECGAMEGOLDTIME; //����Ϸ�Ҽ��ʱ��
  Envir.m_nDecGameGold := MapEnvir.m_nDECGAMEGOLD; //һ�μ�����
  Envir.m_nINCGAMEGOLDTIME := MapEnvir.m_nINCGAMEGOLDTIME; //����Ϸ�Ҽ��ʱ��
  Envir.m_nIncGameGold := MapEnvir.m_nINCGAMEGOLD; //һ�μ�����
  Envir.m_nINCGAMEPOINTTIME := MapEnvir.m_nINCGAMEPOINTTIME; //����Ϸ����ʱ��
  Envir.m_nINCGAMEPOINT := MapEnvir.m_nINCGAMEPOINT; //һ�μ�����
  Envir.m_nDECGAMEPOINTTIME := MapEnvir.m_nDECGAMEPOINTTIME; //����Ϸ����ʱ��
  Envir.m_nDECGAMEPOINT := MapEnvir.m_nDECGAMEPOINT; //һ�μ�����
  Envir.m_nMUSICID := MapEnvir.m_nMUSICID; //����ID
  Envir.m_sMUSICName := MapEnvir.m_sMUSICName; //��������
  Envir.m_nEXPRATE := MapEnvir.m_nEXPRATE; //���鱶��
  Envir.m_boHitMon := MapEnvir.m_boHitMon; //�����ִ��� 20110114
  Envir.sHitMonScript := MapEnvir.sHitMonScript;
  Envir.sNoReconnectMap := MapEnvir.sNoReconnectMap;
  Envir.boLimitLevel := MapEnvir.boLimitLevel; //����ɫ����ָ���ȼ�1ʱ�����ȼ�2ֵ����HP MP ��ͼ����
  Envir.nLimitLevel1 := MapEnvir.nLimitLevel1; //ָ���ȼ�1
  Envir.nLimitLevel2 := MapEnvir.nLimitLevel2; //ָ���ȼ�2
  Envir.nLimitLevelHero := MapEnvir.nLimitLevelHero; //ָ��Ӣ�۵ȼ�
  Envir.nLimitLevelHero1 := MapEnvir.nLimitLevelHero1; //ָ��Ӣ�۵ȼ�

  if MapEnvir.QuestNPC <> nil then begin
    QuestNPC := TMerchant.Create;
    QuestNPC.m_sMapName := '0';
    QuestNPC.m_nCurrX := 0;
    QuestNPC.m_nCurrY := 0;
    QuestNPC.m_sCharName := TMerchant(MapEnvir.QuestNPC).m_sCharName;
    QuestNPC.m_nFlag := 0;
    QuestNPC.m_wAppr := 0;
    QuestNPC.m_sFilePath := 'MapQuest_def\';
    QuestNPC.m_boIsHide := True;
    QuestNPC.m_boIsQuest := False;
    UserEngine.QuestNPCList.Add(QuestNPC);
    Envir.QuestNPC := QuestNPC;
  end;

  Envir.nNEEDSETONFlag := MapEnvir.nNEEDSETONFlag;
  Envir.nNeedONOFF := MapEnvir.nNeedONOFF;
  Envir.m_boUnAllowStdItems := MapEnvir.m_boUnAllowStdItems;
  Envir.m_boUnAllowMagics := MapEnvir.m_boUnAllowMagics;
  Envir.m_boChangMapDrops := MapEnvir.m_boChangMapDrops;
  Envir.m_boFIGHTPK := MapEnvir.m_boFIGHTPK; //PK���Ա�װ��������
  Envir.nThunder := MapEnvir.nThunder;
  Envir.nLava := MapEnvir.nLava;

  if (Envir.m_boUnAllowStdItems) then begin
    if MapEnvir.m_UnAllowStdItemsList.Count > 0 then begin
      for I := 0 to MapEnvir.m_UnAllowStdItemsList.Count - 1 do begin
        nStd := UserEngine.GetStdItemIdx(Trim(MapEnvir.m_UnAllowStdItemsList.Strings[I]));
        if nStd >= 0 then
          Envir.m_UnAllowStdItemsList.AddObject(Trim(MapEnvir.m_UnAllowStdItemsList.Strings[I]), TObject(nStd));
      end;
    end;
  end;

  if (Envir.m_boChangMapDrops) then begin
    if MapEnvir.m_ChangMapDropsList.Count > 0 then begin
      for I := 0 to MapEnvir.m_ChangMapDropsList.Count - 1 do begin
        nStd := UserEngine.GetStdItemIdx(Trim(MapEnvir.m_ChangMapDropsList.Strings[I]));
        if nStd >= 0 then
          Envir.m_ChangMapDropsList.AddObject(Trim(MapEnvir.m_ChangMapDropsList.Strings[I]), TObject(nStd));
      end;
    end;
  end;

  if (Envir.m_boUnAllowMagics) then begin
    if MapEnvir.m_UnAllowMagicList.Count > 0 then begin
      for I := 0 to MapEnvir.m_UnAllowMagicList.Count - 1 do begin
        sTemp := Trim(MapEnvir.m_UnAllowMagicList.Strings[I]);
        if sTemp <> '' then Envir.m_UnAllowMagicList.Add(sTemp);
      end;
    end;
  end;

  Envir.nMinMap := MapEnvir.nMinMap; //С��ͼ
  Envir.m_boMirrorMap := True;
  Envir.m_boMirrorMaping := False;
  Envir.m_dwMirrorMapTick := GetTickCount + nTime * 1000;
  Envir.sMirrorHomeMap := sMirrorHomeMap;
  if MapEnvir.sMainMapName <> '' then begin
    if Envir.LoadMapData(g_Config.sMapDir + MapEnvir.sMainMapName + '.map') then begin
      Result := Envir;
      Self.Add(Envir);
      Self.m_MirrorMaps.Add(Envir); //�����ͼ
    end else begin
      MainOutMessage('��ͼ�ļ� ' + g_Config.sMapDir + MapEnvir.sMainMapName + '.map' + ' δ�ҵ�������');
    end;
  end else begin
    if Envir.LoadMapData(g_Config.sMapDir + MapEnvir.sMapName + '.map') then begin
      Result := Envir;
      Self.Add(Envir);
      Self.m_MirrorMaps.Add(Envir); //�����ͼ
    end else begin
      MainOutMessage('��ͼ�ļ� ' + g_Config.sMapDir + MapEnvir.sMapName + '.map' + ' δ�ҵ�������');
    end;
  end;
end;

//���ӵ�ͼ���ӵ�

function TMapManager.AddMapRoute(sSMapNO: string; nSMapX, nSMapY: Integer; sDMapNO: string; nDMapX, nDMapY: Integer): Boolean;
var
  GateObj: pTGateObj;
  SEnvir: TEnvirnoment;
  DEnvir: TEnvirnoment;
begin
  Result := False;
  SEnvir := FindMap(sSMapNO);
  DEnvir := FindMap(sDMapNO);
  if (SEnvir <> nil) and (DEnvir <> nil) then begin
    New(GateObj);
    //GateObj.boFlag := False;//20090503 ע�ͣ�δʹ��
    GateObj.DEnvir := DEnvir;
    GateObj.nDMapX := nDMapX;
    GateObj.nDMapY := nDMapY;
    Result := SEnvir.AddToMap(nSMapX, nSMapY, OS_GATEOBJECT, TObject(GateObj)) = GateObj;
    if not Result then //�޸��ڴ�й¶ By TasNat at: 2012-05-26 19:02:28
      Dispose(GateObj);
  end;
end;

//����������ͼ

function TEnvirnoment.AddToMap(nX, nY: Integer; btType: Byte; pRemoveObject: TObject): Pointer;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  MapItem: PTMapItem;
  I: Integer;
  nGoldCount: Integer;
  bo1E: Boolean;
  btRaceServer: Byte;
  nCode: Byte;
resourcestring
  sExceptionMsg = '{%s} TEnvirnoment::AddToMap Code:%d';
begin
  Result := nil;
  if m_boMirrorMaping then Exit;
  nCode := 0;
  try
    bo1E := False;
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
      if MapCellInfo.ObjList = nil then begin
        MapCellInfo.ObjList := TList.Create;
      end else begin
        if btType = OS_ITEMOBJECT then begin
          if PTMapItem(pRemoveObject).Name = sSTRING_GOLDNAME then begin
            if MapCellInfo.ObjList.Count > 0 then begin
              for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
                OSObject := MapCellInfo.ObjList.Items[I];
                if (OSObject <> nil) then begin
                  if (OSObject.btType = OS_ITEMOBJECT) and (not OSObject.boObjectDispose) then begin //20090510 ����
                    MapItem := PTMapItem(pTOSObject(MapCellInfo.ObjList.Items[I]).CellObj);
                    if MapItem <> nil then begin
                      if MapItem.Name = sSTRING_GOLDNAME then begin
                        nGoldCount := MapItem.Count + PTMapItem(pRemoveObject).Count;
                        if nGoldCount <= 2000 then begin
                          MapItem.Count := nGoldCount;
                          MapItem.Looks := GetGoldShape(nGoldCount);
                          MapItem.AniCount := 0;
                          MapItem.Reserved := 0;
                          OSObject.dwAddTime := GetTickCount();
                          Result := MapItem;
                          bo1E := True;
                        end;
                      end;
                    end;
                  end;
                end;
              end; //for
            end;
          end;
          if not bo1E and (MapCellInfo.ObjList.Count >= 5) then begin
            Result := nil;
            bo1E := True;
          end;
        end;
      end;
      if not bo1E then begin
        New(OSObject);
        OSObject.btType := btType;
        OSObject.CellObj := pRemoveObject;
        OSObject.dwAddTime := GetTickCount();
        OSObject.boObjectDisPose := False; //20090510 ����
        nCode := 1;
        if MapCellInfo.ObjList = nil then begin
          MapCellInfo.ObjList := TList.Create;
        end;
        nCode := 4;
        if MapCellInfo.ObjList <> nil then begin //20090803 ����
          nCode := 5;
          try
            MapCellInfo.ObjList.Add(OSObject);
          except
            nCode := 6;
            Dispose(OSObject);
            Exit;
          end;
          nCode := 2;
          Result := Pointer(pRemoveObject);

          if (btType = OS_MOVINGOBJECT) and (not TBaseObject(pRemoveObject).m_boAddToMaped) then begin
            TBaseObject(pRemoveObject).m_boDelFormMaped := False;
            TBaseObject(pRemoveObject).m_boAddToMaped := True;
            btRaceServer := TBaseObject(pRemoveObject).m_btRaceServer;
            nCode := 3;
            if btRaceServer = RC_PLAYOBJECT then begin
              Inc(m_nHumCount);
              if TBaseObject(pRemoveObject).m_boAI then Inc(m_nHumAICount);
            end;
            if btRaceServer >= RC_ANIMAL then Inc(m_nMonCount);
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format(sExceptionMsg, [g_sExceptionVer, nCode]));
  end;
end;
//��ͼ�Ƿ�����ʹ����Ʒ

function TEnvirnoment.AllowStdItems(sItemName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  try
    if m_boMirrorMaping then Exit;
    if (not m_boUnAllowStdItems) or (m_UnAllowStdItemsList = nil) then Exit; //20080930 ����
    if m_UnAllowStdItemsList.Count > 0 then begin
      I := m_UnAllowStdItemsList.IndexOf(sItemName);
      if I > -1 then Result := False;
    end;
  except
    MainOutMessage(format('{%s} TEnvirnoment.AllowStdItems1', [g_sExceptionVer]));
  end;
end;
//��ͼ�Ƿ�����ʹ����Ʒ

function TEnvirnoment.AllowStdItems(nItemIdx: Integer): Boolean;
var
  I: Integer;
begin
  Result := True;
  try
    if m_boMirrorMaping then Exit;
    if (not m_boUnAllowStdItems) or (m_UnAllowStdItemsList = nil) then Exit; //20080930 ����
    if m_UnAllowStdItemsList.Count > 0 then begin //20080630
      for I := 0 to m_UnAllowStdItemsList.Count - 1 do begin
        if Integer(m_UnAllowStdItemsList.Objects[I]) = nItemIdx then begin
          Result := False;
          Break;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TEnvirnoment.AllowStdItems2', [g_sExceptionVer]));
  end;
end;

function TEnvirnoment.GetMainMap(): string;
begin
  if m_boMainMap then Result := sMainMapName
  else Result := sMapName;
end;
//����ͼ����ָ����Ʒ

function TEnvirnoment.ChangMapDropStdItems(sItemName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  try
    if m_boMirrorMaping then Exit;
    if (not m_boChangMapDrops) or (m_ChangMapDropsList = nil) then Exit;
    if m_ChangMapDropsList.Count > 0 then begin
      I := m_ChangMapDropsList.IndexOf(sItemName);
      if I > -1 then Result := False;
    end;
  except
    MainOutMessage(format('{%s} TEnvirnoment.ChangMapDropStdItems1', [g_sExceptionVer]));
  end;
end;

//��ͼ�Ƿ�����ʹ��ħ��

function TEnvirnoment.AllowMagics(sMagName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if m_boMirrorMaping then Exit;
  if not m_boUnAllowMagics then Exit;
  if m_UnAllowMagicList.Count > 0 then begin
    I := m_UnAllowMagicList.IndexOf(sMagName);
    if I > -1 then Result := False;
  end;
end;
//�Ƿ�����ʹ��ħ��  tyte 0-���� 1-Ӣ��

function TEnvirnoment.AllowMagics(nMagIdx: Integer; tyte: Byte): Boolean;
var
  I: Integer;
  sName: string;
  Magic: pTMagic;
begin
  Result := True;
  if m_boMirrorMaping then Exit;
  if (not m_boUnAllowMagics) or (nMagIdx < 0) then Exit;
  case tyte of
    0: begin
        Magic := UserEngine.FindMagic(nMagIdx);
        if Magic <> nil then sName := Magic.sMagicName;
      end;
    1: begin
        Magic := UserEngine.FindHeroMagic(nMagIdx);
        if Magic <> nil then sName := Magic.sMagicName;
      end;
  end;
  if (m_UnAllowMagicList.Count > 0) and (sName <> '') then begin
    I := m_UnAllowMagicList.IndexOf(sName);
    if I > -1 then Result := False;
  end;
  {if m_UnAllowMagicList.Count > 0 then begin
    for I := 0 to m_UnAllowMagicList.Count - 1 do begin
      if Integer(m_UnAllowMagicList.Objects[I]) = nMagIdx then begin
        Result := False;
        Break;
      end;
    end;
  end; }
end;

procedure TEnvirnoment.AddDoorToMap();
var
  I: Integer;
  Door: pTDoorInfo;
begin
  if m_boMirrorMaping then Exit;
  if m_DoorList.Count > 0 then begin
    for I := 0 to m_DoorList.Count - 1 do begin
      Door := m_DoorList.Items[I];
      AddToMap(Door.nX, Door.nY, OS_DOOR, TObject(Door));
    end;
  end;
end;

function TEnvirnoment.GetMapCellInfo(nX, nY: Integer; var MapCellInfo: pTMapCellinfo): Boolean;
begin
  Result := False;
  MapCellInfo := nil; //�����ǲ��Ǳ��յ��� By TasNat at: 2012-03-13 22:44:05
  try
    if m_boMirrorMaping then Exit;
    if (nX >= 0) and (nX < m_nWidth) and (nY >= 0) and (nY < m_nHeight) then begin
      MapCellInfo := @MapCellArray[nX * m_nHeight + nY]; // liuzhigang �����һ��һά����
      Result := True;
    end;
  except
  end;
end;

//�����ƶ�

function TEnvirnoment.MoveToMovingObject(nCX, nCY: Integer; Cert: TObject; nX, nY: Integer; boFlag: Boolean): Integer;
var
  MapCellInfo: pTMapCellinfo;
  BaseObject: TBaseObject;
  OSObject: pTOSObject;
  I: Integer;
  bo1A: Boolean;
  nCode: Byte; //20080702
//label //20080727 δʹ�õı�ǩ
//  Loop, Over;
begin
  Result := 0;
  nCode := 0;
  try
    bo1A := True;
    if not boFlag and GetMapCellInfo(nX, nY, MapCellInfo) then begin
      nCode := 12;
      if MapCellInfo.chFlag = 0 then begin
        nCode := 13;
        if MapCellInfo.ObjList <> nil then begin
          if MapCellInfo.ObjList.Count > 0 then begin //20080630
            nCode := 14;
            for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
              nCode := 141;
              try //20090716 ����
                OSObject := pTOSObject(MapCellInfo.ObjList.Items[I]);
              except
                OSObject := nil;
              end;
              try //20090817 ����
                {if OSObject <> nil then begin//20090716
                  if (not pTOSObject(MapCellInfo.ObjList.Items[I]).boObjectDisPose) then begin//20090605 ���� not boObjectDisPose
                    if (pTOSObject(MapCellInfo.ObjList.Items[I]).btType = OS_MOVINGOBJECT) then begin
                      BaseObject := TBaseObject(pTOSObject(MapCellInfo.ObjList.Items[I]).CellObj);
                      if BaseObject <> nil then begin //����ƶ��ص��Ƿ�������
                        if not BaseObject.m_boGhost and BaseObject.bo2B9 and not BaseObject.m_boDeath
                          and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                          bo1A := False;
                          Break;
                        end;
                      end;
                    end;
                  end;
                end; }
                //20110908 �޸�
                if OSObject <> nil then begin //20090716
                  if (not OSObject.boObjectDisPose) then begin //20090605 ���� not boObjectDisPose
                    case OSObject.btType of
                      OS_MOVINGOBJECT: begin
                          BaseObject := TBaseObject(OSObject.CellObj);
                          if BaseObject <> nil then begin //����ƶ��ص��Ƿ�������
                            if not BaseObject.m_boGhost and BaseObject.bo2B9 and not BaseObject.m_boDeath
                              and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                              bo1A := False;
                              Break;
                            end;
                          end;
                        end;
                      OS_EVENTOBJECT: begin //�������� ���������ɴ���
                          if TEvent(OSObject.CellObj).m_nEventType = ET_NOTGOTO then begin
                            bo1A := False;
                            Break;
                          end;
                        end;
                    end; //case
                  end;
                end;
              except
              end;
            end; //for
          end;
        end;
      end else begin //if MapCellInfo.chFlag = 0 then begin
        Result := -1;
        bo1A := False;
      end;
    end;
    if bo1A then begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag <> 0) then begin
        Result := -1;
      end else begin
        if GetMapCellInfo(nCX, nCY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          I := 0;
          nCode := 1;
          while (True) do begin
            nCode := 19;
            if MapCellInfo.ObjList.Count <= I then Break;
            nCode := 2;
            try //20090705 ����
              OSObject := MapCellInfo.ObjList.Items[I];
            except
              OSObject := nil; //20090705 ����
            end;
            nCode := 3;
            if (OSObject <> nil) then begin
              if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 �޸�
                if TBaseObject(OSObject.CellObj) = TBaseObject(Cert) then begin
                  //try//20090722  20101126 ע��
                  if MapCellInfo.ObjList <> nil then MapCellInfo.ObjList.Delete(I); //20090713 �޸�
                  if (OSObject <> nil) then begin
                    OSObject.boObjectDisPose := True; //20990510 ����
                    Dispose(OSObject); //20090103 �޸�
                  end;
                  //except
                  //end;
                  if MapCellInfo.ObjList.Count > 0 then Continue;
                  if MapCellInfo.ObjList.Count <= 0 then begin //20090315 �޸�
                    try //20090512 ����
                      if MapCellInfo.ObjList <> nil then FreeAndNil(MapCellInfo.ObjList); //20090115 �޸�
                    except
                    end;
                    break;
                  end;
                end;
              end;
            end;
            Inc(I);
          end; //while
        end;
        if GetMapCellInfo(nX, nY, MapCellInfo) then begin
          try
            New(OSObject);
            OSObject.btType := OS_MOVINGOBJECT;
            OSObject.CellObj := Cert;
            OSObject.dwAddTime := GetTickCount;
            OSObject.boObjectDisPose := False; //20090510 ����
            nCode := 11;
            if (MapCellInfo.ObjList = nil) then begin
              MapCellInfo.ObjList := TList.Create;
            end;
            nCode := 10;
            MapCellInfo.ObjList.Add(OSObject);
            Result := 1; //20090525 ��λ��
          except
            Dispose(OSObject); //20090103 ��ֹ�ڴ�й¶
            Result := -1; //20090525 ����
          end;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TEnvirnoment::MoveToMovingObject Code:%d', [g_sExceptionVer, nCode]));
    end;
  end;
end;

//======================================================================
//����ͼָ�������Ƿ�����ƶ�
//boFlag  ���ΪTRUE ������������Ƿ��н�ɫ
//����ֵ True Ϊ�����ƶ���False Ϊ�������ƶ�
//======================================================================1

function TEnvirnoment.CanWalk(nX, nY: Integer; boFlag: Boolean): Boolean;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  I: Integer;
begin
  Result := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
    Result := True;
    if not boFlag and (MapCellInfo.ObjList <> nil) then begin
      if MapCellInfo.ObjList.Count > 0 then begin //20080630
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[I];
          if (OSObject <> nil) then begin
            if (not OSObject.boObjectDisPose) then begin //20090510 ����
              case OSObject.btType of
                OS_MOVINGOBJECT: begin
                    BaseObject := TBaseObject(OSObject.CellObj);
                    if BaseObject <> nil then begin
                      if not BaseObject.m_boGhost
                        and BaseObject.bo2B9
                        and not BaseObject.m_boDeath
                        and not BaseObject.m_boFixedHideMode
                        and not BaseObject.m_boObMode then begin
                        Result := False;
                        Break;
                      end;
                    end;
                  end;
                OS_EVENTOBJECT: begin //�������� ���������ɴ���
                    if TEvent(OSObject.CellObj).m_nEventType = ET_NOTGOTO then begin
                      Result := False;
                      Break;
                    end;
                  end;
              end;
            end;
          end;
        end; //for
      end;
    end;
  end;
end;

//======================================================================
//����ͼָ�������Ƿ�����ƶ�
//boFlag  ���ΪTRUE ������������Ƿ��н�ɫ
//����ֵ True Ϊ�����ƶ���False Ϊ�������ƶ�
//======================================================================

function TEnvirnoment.CanWalkOfItem(nX, nY: Integer; boFlag, boItem: Boolean): Boolean;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  I: Integer;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
    if (MapCellInfo.ObjList <> nil) then begin
      if MapCellInfo.ObjList.Count > 0 then begin //20080630
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[I];
          if (OSObject <> nil) then begin //20090430 �޸�
            if not boFlag and (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
              BaseObject := TBaseObject(OSObject.CellObj);
              if BaseObject <> nil then begin
                if not BaseObject.m_boGhost and BaseObject.bo2B9
                  and not BaseObject.m_boDeath and not BaseObject.m_boFixedHideMode
                  and not BaseObject.m_boObMode then begin
                  Result := False;
                  Break;
                end;
              end;
            end;
            if not boItem and (OSObject.btType = OS_ITEMOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
              Result := False;
              Break;
            end;
          end;
        end; //for
      end;
    end;
  end;
end;

function TEnvirnoment.CanWalkEx(nX, nY: Integer; boFlag: Boolean): Boolean;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  I: Integer;
  Castle: TUserCastle;
begin
  Result := False;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
      Result := True;
      if not boFlag and (MapCellInfo.ObjList <> nil) then begin
        if MapCellInfo.ObjList.Count > 0 then begin //20080630
          for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
            OSObject := MapCellInfo.ObjList.Items[I];
            if OSObject <> nil then begin
              if (not OSObject.boObjectDisPose) then begin //20090510 ����
                case OSObject.btType of
                  OS_MOVINGOBJECT: begin
                      BaseObject := TBaseObject(OSObject.CellObj);
                      if BaseObject <> nil then begin
                        Castle := g_CastleManager.InCastleWarArea(BaseObject);
                        if g_Config.boWarDisHumRun and (Castle <> nil) and (Castle.m_boUnderWar) then begin
                        end else begin
                          if not m_boSafeNoRun then begin //��ȫ����ֹ��
                            if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                              if g_Config.boRUNHUMAN or m_boRUNHUMAN then Continue;
                            end else begin
                              if BaseObject.m_btRaceServer = RC_NPC then begin
                                if g_Config.boRunNpc then Continue;
                              end else begin
                                if (BaseObject.m_btRaceServer = RC_GUARD) or (BaseObject.m_btRaceServer = RC_ARCHERGUARD) then begin //20090903 �޸�
                                  if g_Config.boRunGuard then Continue;
                                end else begin
                                  if BaseObject.m_btRaceServer <> 55 then begin //������������ʦ
                                    if g_Config.boRUNMON or m_boRUNMON then Continue;
                                  end;
                                end;
                              end;
                            end;
                          end;
                        end;
                        if not BaseObject.m_boGhost and BaseObject.bo2B9 and not BaseObject.m_boDeath
                          and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                          Result := False;
                          Break;
                        end;
                      end;
                    end;
                  OS_EVENTOBJECT: begin //�������� ���������ɴ���
                      if TEvent(OSObject.CellObj).m_nEventType = ET_NOTGOTO then begin
                        Result := False;
                        Break;
                      end;
                    end;
                end; //case
              end;
            end;
          end; //for
        end;
      end;
    end;
  except
  end;
end;

constructor TMapManager.Create;
begin
  nMirrorMapsIndx := 0;
  m_MirrorMaps := TList.Create; //�����ͼ�б�
  inherited Create;
end;

destructor TMapManager.Destroy;
var
  I: Integer;
begin
  m_MirrorMaps.Free;
  if Count > 0 then begin
    for I := 0 to Count - 1 do begin
      try
        TEnvirnoment(Items[I]).Free; //�����쳣
      except
      end;
    end;
  end;
  inherited;
end;

function TMapManager.GetMainMap(Envir: TEnvirnoment): string;
begin
  if Envir.m_boMainMap then Result := Envir.sMainMapName
  else Result := Envir.sMapName;
end;

function TMapManager.FindMap(sMapName: string): TEnvirnoment;
var
  Map: TEnvirnoment;
  I: Integer;
begin
  Result := nil;
  try //20100110 ����
    Lock;
    try
      if Count > 0 then begin //20090430 ����
        for I := 0 to Count - 1 do begin
          Map := TEnvirnoment(Items[I]);
          if Map <> nil then begin //20090128
            if (CompareText(Map.sMapName, sMapName) = 0) and (not Map.m_boMirrorMaping) then begin
              Result := Map;
              Break;
            end;
          end;
        end;
      end;
    finally
      UnLock;
    end;
  except
    Result := nil;
  end;
end;

function TMapManager.GetMapInfo(nServerIdx: Integer; sMapName: string): TEnvirnoment;
var
  I: Integer;
  Envir: TEnvirnoment;
begin
  Result := nil;
  Lock;
  try
    if Count > 0 then begin
      for I := 0 to Count - 1 do begin
        Envir := Items[I];
        if (Envir.nServerIndex = nServerIdx) and (CompareText(Envir.sMapName, sMapName) = 0) then begin
          Result := Envir;
          Break;
        end;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TEnvirnoment.DeleteFromMap(nX, nY: Integer; btType: Byte;
  pRemoveObject: TObject): Integer;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  n18: Integer;
  btRaceServer: Byte;
resourcestring
  //sExceptionMsg1 = '{%s} TEnvirnoment::DeleteFromMap -> Except 1 ** %d';
  sExceptionMsg2 = '{%s} TEnvirnoment::DeleteFromMap -> Except 2 ** %d';
begin
  Result := -1;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) then begin
      if MapCellInfo <> nil then begin
        try
          if MapCellInfo.ObjList <> nil then begin
            n18 := 0;
            while (True) do begin
              if MapCellInfo.ObjList.Count <= n18 then Break;
              OSObject := MapCellInfo.ObjList.Items[n18];
              if OSObject <> nil then begin
                if (OSObject.btType = btType) and (OSObject.CellObj = pRemoveObject) and (not OSObject.boObjectDisPose) then begin //20090510 �޸�
                  MapCellInfo.ObjList.Delete(n18);
                  OSObject.boObjectDisPose := True; //20090510 ����
                  Dispose(OSObject);
                  Result := 1;
                  //����ͼ����������
                  if (btType = OS_MOVINGOBJECT) and (not TBaseObject(pRemoveObject).m_boDelFormMaped) then begin
                    TBaseObject(pRemoveObject).m_boDelFormMaped := True;
                    TBaseObject(pRemoveObject).m_boAddToMaped := False;
                    btRaceServer := TBaseObject(pRemoveObject).m_btRaceServer;
                    if btRaceServer = RC_PLAYOBJECT then begin
                      Dec(m_nHumCount);
                      if TBaseObject(pRemoveObject).m_boAI then Dec(m_nHumAICount);
                    end;
                    if btRaceServer >= RC_ANIMAL then Dec(m_nMonCount);
                  end;
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    FreeAndNil(MapCellInfo.ObjList);
                    Break;
                  end;
                  Continue;
                end
              end else begin
                if MapCellInfo.ObjList <> nil then begin //20090412
                  MapCellInfo.ObjList.Delete(n18);
                  if MapCellInfo.ObjList.Count > 0 then Continue;
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    FreeAndNil(MapCellInfo.ObjList);
                    Break;
                  end;
                end else Break;
              end;
              Inc(n18);
            end;
          end else begin
            Result := -2;
          end;
        except
          OSObject := nil;
          MapCellInfo.ObjList := nil; //20100913 ��JS����
          //MainOutMessage(Format(sExceptionMsg1, [btType]));//20090705 ע��
        end;
      end else Result := -3;
    end else Result := 0;
  except
    MainOutMessage(Format(sExceptionMsg2, [g_sExceptionVer, btType]));
  end;
end;

function TEnvirnoment.GetItem(nX, nY: Integer): PTMapItem;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
    bo2C := True;
    if MapCellInfo.ObjList <> nil then begin
      if MapCellInfo.ObjList.Count > 0 then begin //20080630
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[I];
          if OSObject <> nil then begin
            if (not OSObject.boObjectDisPose) then begin //20090510 ����
              {if OSObject.btType = OS_ITEMOBJECT then begin
                Result := PTMapItem(OSObject.CellObj);
                Exit;
              end;
              if OSObject.btType = OS_GATEOBJECT then bo2C := False;
              if OSObject.btType = OS_MOVINGOBJECT then begin
                BaseObject := TBaseObject(OSObject.CellObj);
                if not BaseObject.m_boDeath then bo2C := False;
              end;}
              case OSObject.btType of //20090811 �޸�
                OS_ITEMOBJECT: begin
                    Result := PTMapItem(OSObject.CellObj);
                    Exit;
                  end;
                OS_GATEOBJECT: bo2C := False;
                OS_MOVINGOBJECT: begin
                    BaseObject := TBaseObject(OSObject.CellObj);
                    if not BaseObject.m_boDeath then bo2C := False;
                  end;
              end; //case
            end;
          end;
        end; //for
      end;
    end;
  end;
end;

function TMapManager.GetMapOfServerIndex(sMapName: string): Integer;
var
  I: Integer;
  Envir: TEnvirnoment;
begin
  Result := 0;
  Lock;
  try
    if Count > 0 then begin //20080630
      for I := 0 to Count - 1 do begin
        Envir := Items[I];
        if (CompareText(Envir.sMapName, sMapName) = 0) then begin
          Result := Envir.nServerIndex;
          Break;
        end;
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TMapManager.LoadMapDoor;
var
  I: Integer;
begin
  if Count > 0 then begin
    for I := 0 to Count - 1 do begin
      TEnvirnoment(Items[I]).AddDoorToMap;
    end;
  end;
end;

procedure TMapManager.ProcessMapDoor;
begin

end;
//��������С��ͼ

procedure TMapManager.ReSetMinMap;
var
  I, II: Integer;
  Envirnoment: TEnvirnoment;
begin
  if Count > 0 then begin
    for I := 0 to Count - 1 do begin
      Envirnoment := TEnvirnoment(Items[I]);
      if MiniMapList.Count > 0 then begin
        for II := 0 to MiniMapList.Count - 1 do begin
          if CompareText(MiniMapList.Strings[II], Envirnoment.sMapName) = 0 then begin
            Envirnoment.nMinMap := Integer(MiniMapList.Objects[II]);
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.IsCheapStuff: Boolean;
begin
  if m_QuestList.Count > 0 then Result := True
  else Result := False;
end;
(*//���ӿ�ʯ����   //20101025 ע��
function TEnvirnoment.AddToMapMineEvent(nX, nY: Integer; nType: Integer; Event: TObject): TObject;
var
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  bo19: Boolean;
resourcestring
  sExceptionMsg = '{%s} TEnvirnoment::AddToMapMineEvent ';
begin
  Result := nil;
  try
    bo19 := GetMapCellInfo(nX, nY, MapCellInfo);
    if bo19 and (MapCellInfo.chFlag <> 0) then begin
      if MapCellInfo.ObjList = nil then MapCellInfo.ObjList := TList.Create;
      New(OSObject);
      OSObject.btType := nType;
      OSObject.CellObj := Event;
      OSObject.dwAddTime := GetTickCount();
      OSObject.boObjectDisPose:= False;//20090510 ����
      MapCellInfo.ObjList.Add(OSObject);
      Result := Event;
    end;
  except
    MainOutMessage(format(sExceptionMsg,[g_sExceptionVer]));
  end;
end;   *)
//��֤��ͼʱ��

procedure TEnvirnoment.VerifyMapTime(nX, nY: Integer; BaseObject: TObject);
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  boVerify: Boolean;
//  nCode: Byte;
//resourcestring
//  sExceptionMsg = '{%s} TEnvirnoment::VerifyMapTime Code:%d';
begin
//  nCode:= 0;
  try
    if m_boMirrorMaping then Exit;
    //nCode:= 7;
    boVerify := False;
    //nCode:= 8;
    if GetMapCellInfo(nX, nY, MapCellInfo) then begin
      //nCode:= 9;
      if (MapCellInfo <> nil) and (MapCellInfo.ObjList <> nil) then begin
        //nCode:= 1;
        if MapCellInfo.ObjList.Count > 0 then begin
          //nCode:= 2;
          for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
            //nCode:= 3;
            try
              OSObject := MapCellInfo.ObjList.Items[I];
            except
              OSObject := nil; //20091102����
            end;
           // nCode:= 32;
            try //20090815 ����
              if (OSObject <> nil) then begin
                //nCode:= 4;
                if (OSObject.btType = OS_MOVINGOBJECT) and (OSObject.CellObj = BaseObject) and (not OSObject.boObjectDisPose) then begin //20090510 ����
                  //nCode:= 5;
                  OSObject.dwAddTime := GetTickCount();
                  boVerify := True;
                  Break;
                end;
              end;
            except
            end;
          end; //for
        end;
      end;
    end;
    //nCode:= 6;
    if not boVerify then AddToMap(nX, nY, OS_MOVINGOBJECT, BaseObject);
  except
    //MainOutMessage(format(sExceptionMsg,[g_sExceptionVer{, nCode}]));
  end;
end;

constructor TEnvirnoment.Create;
begin
  Pointer(MapCellArray) := nil;
  sMapName := '';
  //sSubMapName := '';
  sMainMapName := '';
  m_boMainMap := False;
  nServerIndex := 0;
  nMinMap := 0;
  m_nWidth := 0;
  m_nHeight := 0;
  m_boDARK := False;
  m_boDAY := False;
  m_nMonCount := 0;
  m_nHumCount := 0;
  m_nHumAICount := 0;
  m_DoorList := TList.Create;
  m_QuestList := TList.Create;
  m_UnAllowStdItemsList := TGStringList.Create;
  m_UnAllowMagicList := TGStringList.Create;
  m_ChangMapDropsList := TGStringList.Create;
  m_PointList := TList.Create;
end;

destructor TEnvirnoment.Destroy;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  nX, nY: Integer;
  DoorInfo: pTDoorInfo;
begin
  for nX := 0 to m_nWidth - 1 do begin
    for nY := 0 to m_nHeight - 1 do begin
      if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        if MapCellInfo.ObjList.Count > 0 then begin
          for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
            OSObject := MapCellInfo.ObjList.Items[I];
            if OSObject <> nil then begin
              case OSObject.btType of
                OS_ITEMOBJECT: if PTMapItem(OSObject.CellObj) <> nil then Dispose(PTMapItem(OSObject.CellObj));
                OS_GATEOBJECT: if pTGateObj(OSObject.CellObj) <> nil then
                Dispose(pTGateObj(OSObject.CellObj));
                OS_EVENTOBJECT: TEvent(OSObject.CellObj).Free;
              end;
              Dispose(OSObject);
            end;
          end; //for
        end;
        FreeAndNil(MapCellInfo.ObjList);
      end;
    end;
  end;
  if m_DoorList.Count > 0 then begin
    for I := 0 to m_DoorList.Count - 1 do begin
      DoorInfo := m_DoorList.Items[I];
      if DoorInfo <> nil then begin
        if DoorInfo.Status <> nil then begin
          Dec(DoorInfo.Status.nRefCount);
          if DoorInfo.Status.nRefCount <= 0 then Dispose(DoorInfo.Status);
        end;
        Dispose(DoorInfo);
      end;
    end;
  end;
  m_DoorList.Free;
  if m_QuestList.Count > 0 then begin
    for I := 0 to m_QuestList.Count - 1 do begin
      if pTMapQuestInfo(m_QuestList.Items[I]) <> nil then
        Dispose(pTMapQuestInfo(m_QuestList.Items[I]));
    end;
  end;
  m_QuestList.Free;
  //if MapCellArray <> nil then begin//20080723
  if Pointer(MapCellArray) <> nil then begin
    FreeMem(Pointer(MapCellArray));
    Pointer(MapCellArray) := nil;
  end;
  m_UnAllowStdItemsList.Free;
  m_UnAllowMagicList.Free;
  m_ChangMapDropsList.Free;
  m_PointList.Free;
  inherited;
end;
//��ȡ��ͼMap�ļ�����

function TEnvirnoment.LoadMapData(sMapFile: string): Boolean;
var
  fHandle: Integer;
  Header: TMapHeader;
  nMapSize: Integer;
  n24, nW, nH: Integer;
  MapBuffer: pTMap;
  NewMapBuffer: pTNewMap;
  Point: Integer;
  Door: pTDoorInfo;
  I: Integer;
  MapCellInfo: pTMapCellinfo;

  sFileName: string;
  sLineText, sX, sY: string;
  LoadList: TStringList;
  nX, nY: Integer;
begin
  Result := False;
  if FileExists(sMapFile) then begin
    fHandle := FileOpen(sMapFile, fmOpenRead or fmShareExclusive);
    if fHandle > 0 then begin
      FileRead(fHandle, Header, SizeOf(TMapHeader));
      m_nWidth := Header.wWidth;
      m_nHeight := Header.wHeight;
      Initialize(m_nWidth, m_nHeight);
      if Header.Logo = 2 then begin //�µ�ͼ��ʽ(��ͼԪ��14�ֽ�) 20110428
        nMapSize := m_nWidth * SizeOf(TNewMapUnitInfo) * m_nHeight;
        NewMapBuffer := AllocMem(nMapSize);
        FileRead(fHandle, NewMapBuffer^, nMapSize);

        for nW := 0 to m_nWidth - 1 do begin
          n24 := nW * m_nHeight;
          for nH := 0 to m_nHeight - 1 do begin
            if (NewMapBuffer[n24 + nH].wBkImg) and $8000 <> 0 then begin
              MapCellInfo := @MapCellArray[n24 + nH];
              MapCellInfo.chFlag := 1;
            end;
            if NewMapBuffer[n24 + nH].wFrImg and $8000 <> 0 then begin
              MapCellInfo := @MapCellArray[n24 + nH];
              MapCellInfo.chFlag := 2;
            end;

            if NewMapBuffer[n24 + nH].btDoorIndex and $80 <> 0 then begin
              Point := (NewMapBuffer[n24 + nH].btDoorIndex and $7F);
              if (Point > 0) then begin
                if (sMapName = '3') and (nW = 619) and ((nH = 265) or (nH = 266) or (nH = 267) or (nH = 268)) then Continue; //����,���˵���������ʶ,�Ա���Ӱ�����Ŵ򻵺��޷����뷿�� 20110503
                New(Door);
                Door.nX := nW;
                Door.nY := nH;
                Door.n08 := Point;
                Door.Status := nil;
                if m_DoorList.Count > 0 then begin
                  for I := 0 to m_DoorList.Count - 1 do begin
                    if abs(pTDoorInfo(m_DoorList.Items[I]).nX - Door.nX) <= 10 then begin
                      if abs(pTDoorInfo(m_DoorList.Items[I]).nY - Door.nY) <= 10 then begin
                        if pTDoorInfo(m_DoorList.Items[I]).n08 = Point then begin
                          Door.Status := pTDoorInfo(m_DoorList.Items[I]).Status;
                          Inc(Door.Status.nRefCount);
                          Break;
                        end;
                      end;
                    end;
                  end; //for
                end;
                if Door.Status = nil then begin
                  New(Door.Status);
                  Door.Status.boOpened := False;
                  Door.Status.bo01 := False;
                  Door.Status.n04 := 0;
                  Door.Status.dwOpenTick := 0;
                  Door.Status.nRefCount := 1;
                end;
                m_DoorList.Add(Door);
              end;
            end;
          end;
        end;
        FreeMem(NewMapBuffer);
      end else begin //�ɵ�ͼ��ʽ����ͼԪ��12�ֽ�
        nMapSize := m_nWidth * SizeOf(TMapUnitInfo) * m_nHeight;
        MapBuffer := AllocMem(nMapSize);
        FileRead(fHandle, MapBuffer^, nMapSize);

        for nW := 0 to m_nWidth - 1 do begin
          n24 := nW * m_nHeight;
          for nH := 0 to m_nHeight - 1 do begin
            if (MapBuffer[n24 + nH].wBkImg) and $8000 <> 0 then begin
              MapCellInfo := @MapCellArray[n24 + nH];
              MapCellInfo.chFlag := 1;
            end;
            if MapBuffer[n24 + nH].wFrImg and $8000 <> 0 then begin
              MapCellInfo := @MapCellArray[n24 + nH];
              MapCellInfo.chFlag := 2;
            end;
            if MapBuffer[n24 + nH].btDoorIndex and $80 <> 0 then begin
              Point := (MapBuffer[n24 + nH].btDoorIndex and $7F);
              if Point > 0 then begin
                New(Door);
                Door.nX := nW;
                Door.nY := nH;
                Door.n08 := Point;
                Door.Status := nil;
                if m_DoorList.Count > 0 then begin //20080630
                  for I := 0 to m_DoorList.Count - 1 do begin
                    if abs(pTDoorInfo(m_DoorList.Items[I]).nX - Door.nX) <= 10 then begin
                      if abs(pTDoorInfo(m_DoorList.Items[I]).nY - Door.nY) <= 10 then begin
                        if pTDoorInfo(m_DoorList.Items[I]).n08 = Point then begin
                          Door.Status := pTDoorInfo(m_DoorList.Items[I]).Status;
                          Inc(Door.Status.nRefCount);
                          Break;
                        end;
                      end;
                    end;
                  end; //for
                end;
                if Door.Status = nil then begin
                  New(Door.Status);
                  Door.Status.boOpened := False;
                  Door.Status.bo01 := False;
                  Door.Status.n04 := 0;
                  Door.Status.dwOpenTick := 0;
                  Door.Status.nRefCount := 1;
                end;
                m_DoorList.Add(Door);
              end;
            end;
          end;
        end;
        FreeMem(MapBuffer);
      end;
      FileClose(fHandle);
      Result := True;
    end;
{--------------------------------���عһ���-------------------------------------}
    sFileName := g_Config.sEnvirDir + 'Point\' + MapName + '.txt';
    if FileExists(sFileName) then begin
      LoadList := TStringList.Create;
      try
        try
          LoadList.LoadFromFile(sFileName);
        except
        end;
        for I := 0 to LoadList.Count - 1 do begin
          sLineText := Trim(LoadList.Strings[I]);
          if (sLineText = '') or (sLineText[1] = ';') then Continue;
          sLineText := GetValidStr3(sLineText, sX, [',', #9]);
          sLineText := GetValidStr3(sLineText, sY, [',', #9]);
          nX := Str_ToInt(sX, -1);
          nY := Str_ToInt(sY, -1);
          if (nX >= 0) and (nY >= 0) and (nX < m_nWidth) and (nY < m_nHeight) then begin
            m_PointList.Add(Pointer(MakeLong(nX, nY)));
          end;
        end;
      finally
        LoadList.Free;
      end;
    end;
  end;
end;

procedure TEnvirnoment.Initialize(nWidth, nHeight: Integer);
var
  nW, nH: Integer;
  MapCellInfo: pTMapCellinfo;
begin
  if (nWidth > 1) and (nHeight > 1) then begin
    if MapCellArray <> nil then begin
      for nW := 0 to m_nWidth - 1 do begin
        for nH := 0 to m_nHeight - 1 do begin
          MapCellInfo := @MapCellArray[nW * m_nHeight + nH];
          if MapCellInfo.ObjList <> nil then begin
            FreeAndNil(MapCellInfo.ObjList);
          end;
        end;
      end;
      FreeMem(Pointer(MapCellArray));
      Pointer(MapCellArray) := nil;
    end;
    m_nWidth := nWidth;
    m_nHeight := nHeight;
    Pointer(MapCellArray) := AllocMem((m_nWidth * m_nHeight) * SizeOf(TMapCellinfo));
  end;
  m_PointList.Clear;
end;

//nFlag,boFlag,Monster,Item,Quest,boGrouped

function TEnvirnoment.CreateQuest(nFlag, nValue: Integer; s24, s28, s2C: string;
  boGrouped: Boolean): Boolean;
var
  MapQuest: pTMapQuestInfo;
  MapMerchant: TMerchant;
begin
  Result := False;
  if nFlag < 0 then Exit;
  New(MapQuest);
  MapQuest.nFlag := nFlag;
  if nValue > 1 then nValue := 1;
  MapQuest.nValue := nValue;
  if s24 = '*' then s24 := '';
  MapQuest.s08 := s24;
  if s28 = '*' then s28 := '';
  MapQuest.s0C := s28;
  if s2C = '*' then s2C := '';

  MapQuest.bo10 := boGrouped;
  MapMerchant := TMerchant.Create;
  MapMerchant.m_sMapName := '0';
  MapMerchant.m_nCurrX := 0;
  MapMerchant.m_nCurrY := 0;
  MapMerchant.m_sCharName := s2C;
  MapMerchant.m_nFlag := 0;
  MapMerchant.m_wAppr := 0;
  MapMerchant.m_sFilePath := 'MapQuest_def\';
  MapMerchant.m_boIsHide := True;
  MapMerchant.m_boIsQuest := False;

  UserEngine.QuestNPCList.Add(MapMerchant);
  MapQuest.NPC := MapMerchant;
  m_QuestList.Add(MapQuest);
  Result := True;
end;

function TEnvirnoment.GetXYObjCount(nX, nY: Integer): Integer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  nCode: byte; //20090406
begin
  Result := 0;
  nCode := 0;
  try
    if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
      if MapCellInfo.ObjList.Count > 0 then begin //20080630
        nCode := 1;
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          try
            nCode := 2;
            OSObject := MapCellInfo.ObjList.Items[I];
          except
            OSObject := nil; //20090705 ����
          end;
          nCode := 4;
          try //20090814 ����
            if (OSObject <> nil) then begin
              if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
                nCode := 5;
                BaseObject := TBaseObject(OSObject.CellObj);
                if BaseObject <> nil then begin
                  nCode := 6;
                  if not BaseObject.m_boGhost and
                    BaseObject.bo2B9 and
                    not BaseObject.m_boDeath and
                    not BaseObject.m_boFixedHideMode and
                    not BaseObject.m_boObMode then begin
                    Inc(Result);
                  end;
                end;
              end;
            end;
          except
          end;
        end; //for
      end;
    end;
  except
    MainOutMessage(format('{%s} TEnvirnoment.GetXYObjCount Code:%d', [g_sExceptionVer, nCode]));
  end;
end;

function TEnvirnoment.GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
begin
  snx := sX;
  sny := sY;
  case nDir of
    DR_UP {0}: if sny > nFlag - 1 then Dec(sny, nFlag);
    DR_DOWN {4}: if sny < (m_nHeight - nFlag) then Inc(sny, nFlag);
    DR_LEFT {6}: if snx > nFlag - 1 then Dec(snx, nFlag);
    DR_RIGHT {2}: if snx < (m_nWidth - nFlag) then Inc(snx, nFlag);
    DR_UPLEFT {7}: begin
        if (snx > nFlag - 1) and (sny > nFlag - 1) then begin
          Dec(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_UPRIGHT {1}: begin
        if (snx > nFlag - 1) and (sny < (m_nHeight - nFlag)) then begin
          Inc(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_DOWNLEFT {5}: begin
        if (snx < (m_nWidth - nFlag)) and (sny > nFlag - 1) then begin
          Dec(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
    DR_DOWNRIGHT {3}: begin
        if (snx < (m_nWidth - nFlag)) and (sny < (m_nHeight - nFlag)) then begin
          Inc(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
  end;
  if (snx = sX) and (sny = sY) then Result := False
  else Result := True;
end;
//�ܰ�ȫ����

function TEnvirnoment.CanSafeWalk(nX, nY: Integer): Boolean;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    if MapCellInfo.ObjList.Count > 0 then begin //20080630
      for I := MapCellInfo.ObjList.Count - 1 downto 0 do begin
        OSObject := MapCellInfo.ObjList.Items[I];
        if (OSObject <> nil) then begin
          if (OSObject.btType = OS_EVENTOBJECT) and (not OSObject.boObjectDisPose) then begin
            if (TEvent(OSObject.CellObj).m_nDamage > 0) or
              (TEvent(OSObject.CellObj).m_nEventType = ET_NOTGOTO) then begin
              Result := False;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.ArroundDoorOpened(nX, nY: Integer): Boolean;
var
  I: Integer;
  Door: pTDoorInfo;
resourcestring
  sExceptionMsg = '{%s} TEnvirnoment::ArroundDoorOpened ';
begin
  Result := True;
  try
    if m_DoorList.Count > 0 then begin
      for I := 0 to m_DoorList.Count - 1 do begin
        Door := m_DoorList.Items[I];
        if (abs(Door.nX - nX) <= 1) and ((abs(Door.nY - nY) <= 1)) then begin
          if not Door.Status.boOpened then begin
            Result := False;
            Break;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format(sExceptionMsg, [g_sExceptionVer]));
  end;
end;
//ȡ�ƶ�����

function TEnvirnoment.GetMovingObject(nX, nY: Integer; boFlag: Boolean): Pointer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    if MapCellInfo.ObjList.Count > 0 then begin
      for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
        OSObject := MapCellInfo.ObjList.Items[I];
        if (OSObject <> nil) then begin
          if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
            BaseObject := TBaseObject(OSObject.CellObj);
            if ((BaseObject <> nil) and (not BaseObject.m_boGhost) and (BaseObject.bo2B9)) and ((not boFlag) or (not BaseObject.m_boDeath)) then begin
              Result := BaseObject;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetMovingObject(nX, nY: Integer; AObject: TObject; boFlag: Boolean): Pointer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  ActorObject: TBaseObject;
begin
  Result := nil;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
      OSObject := MapCellInfo.ObjList.Items[I];
      if (OSObject <> nil) then begin
        if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin
          ActorObject := TBaseObject(OSObject.CellObj);
          if ((not ActorObject.m_boGhost) and (ActorObject.bo2B9) and (not ActorObject.m_boFixedHideMode)) and
            ((not boFlag) or (not ActorObject.m_boDeath)) and (ActorObject = AObject) then begin
            Result := ActorObject;
            Break;
          end;
        end;
      end;
    end;
  end;
end;
//ȡ��ͼ����NPC

function TEnvirnoment.GetQuestNPC(BaseObject: TObject; sCharName, sStr: string; boFlag: Boolean): TObject;
var
  I: Integer;
  MapQuestFlag: pTMapQuestInfo;
  nFlagValue: Integer;
  bo1D: Boolean;
begin
  Result := nil;
  try
    if m_QuestList.Count > 0 then begin
      for I := 0 to m_QuestList.Count - 1 do begin
        MapQuestFlag := m_QuestList.Items[I];
        if MapQuestFlag <> nil then begin
          nFlagValue := TBaseObject(BaseObject).GetQuestFalgStatus(MapQuestFlag.nFlag);
          if nFlagValue = MapQuestFlag.nValue then begin
            if (boFlag = MapQuestFlag.bo10) or (not boFlag) then begin
              bo1D := False;
              if (MapQuestFlag.s08 <> '') and (MapQuestFlag.s0C <> '') then begin
                if (MapQuestFlag.s08 = sCharName) and (MapQuestFlag.s0C = sStr) then bo1D := True;
              end;
              if (MapQuestFlag.s08 <> '') and (MapQuestFlag.s0C = '') then begin
                if (MapQuestFlag.s08 = sCharName) and (sStr = '') then bo1D := True;
              end;
              if (MapQuestFlag.s08 = '') and (MapQuestFlag.s0C <> '') then begin
                if (MapQuestFlag.s0C = sStr) then bo1D := True;
              end;
              if bo1D then begin
                Result := MapQuestFlag.NPC;
                Break;
              end;
            end;
          end;
        end;
      end;
    end;
  except
  end;
end;

function TEnvirnoment.GetItemEx(nX, nY: Integer; var nCount: Integer): Pointer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := nil;
  nCount := 0;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 0) then begin
    bo2C := True;
    if MapCellInfo.ObjList <> nil then begin
      if MapCellInfo.ObjList.Count > 0 then begin //20080630
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject := MapCellInfo.ObjList.Items[I];
          if OSObject <> nil then begin
            if (not OSObject.boObjectDisPose) then begin //20090510 ����
              if OSObject.btType = OS_ITEMOBJECT then begin
                Result := Pointer(OSObject.CellObj);
                Inc(nCount);
              end;
              if OSObject.btType = OS_GATEOBJECT then begin
                bo2C := False;
              end;
              if OSObject.btType = OS_MOVINGOBJECT then begin
                BaseObject := TBaseObject(OSObject.CellObj);
                if BaseObject <> nil then begin
                  if not BaseObject.m_boDeath then bo2C := False;
                end;
              end;
            end;
          end;
        end; //for
      end;
    end;
  end;
end;

function TEnvirnoment.GetDoor(nX, nY: Integer): pTDoorInfo;
var
  I: Integer;
  Door: pTDoorInfo;
begin
  Result := nil;
  if m_DoorList.Count > 0 then begin //20080630
    for I := 0 to m_DoorList.Count - 1 do begin
      Door := m_DoorList.Items[I];
      if (Door.nX = nX) and (Door.nY = nY) then begin
        Result := Door;
        Exit;
      end;
    end;
  end;
end;
//�ж�Ŀ���Ƿ���Ч��(������ʬ��ʱ���ж�)

function TEnvirnoment.IsValidObject(nX, nY, nRage: Integer; BaseObject: TObject): Boolean;
var
  nXX, nYY, I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := False;
  for nXX := nX - nRage to nX + nRage do begin
    for nYY := nY - nRage to nY + nRage do begin
      if GetMapCellInfo(nXX {nX}, nYY {nY}, MapCellInfo) then begin //20090103 ��������ͨ�֣��޷��ڵ�
        if (MapCellInfo.ObjList <> nil) then begin //20090103
          if MapCellInfo.ObjList.Count > 0 then begin //20080630
            for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
              OSObject := MapCellInfo.ObjList.Items[I];
              if (OSObject <> nil) then begin
                if (not OSObject.boObjectDisPose) then begin //20090510 ����
                  if (OSObject.CellObj = BaseObject) then begin
                    Result := True;
                    Exit;
                  end;
                end;
              end;
            end; //for
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetRangeBaseObject(nX, nY, nRage: Integer; boFlag: Boolean;
  BaseObjectList: TList): Integer;
var
  nXX, nYY: Integer;
begin
  for nXX := nX - nRage to nX + nRage do begin
    for nYY := nY - nRage to nY + nRage do begin
      GeTBaseObjects(nXX, nYY, boFlag, BaseObjectList);
    end;
  end;
  Result := BaseObjectList.Count;
end;
//boFlag �Ƿ������������
//FALSE ������������
//TRUE  ��������������

function TEnvirnoment.GeTBaseObjects(nX, nY: Integer; boFlag: Boolean;
  BaseObjectList: TList): Integer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    if MapCellInfo.ObjList.Count > 0 then begin //20080630
      for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
        OSObject := MapCellInfo.ObjList.Items[I];
        if (OSObject <> nil) then begin
          if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
            BaseObject := TBaseObject(OSObject.CellObj);
            if BaseObject <> nil then begin
              if not BaseObject.m_boGhost and BaseObject.bo2B9 then begin
                if not boFlag or not BaseObject.m_boDeath then BaseObjectList.Add(BaseObject);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  Result := BaseObjectList.Count;
end;

//����ָ����Χ����Ʒ By TasNat at: 2012-03-17 11:14:18

function TEnvirnoment.ClearItem(nX, nY, nRage: Integer): Boolean;
var
  III, I: Integer;
  x, y: Integer;
  nStartX, nStartY, nEndX, nEndY, nCode: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  MapItem: PTMapItem;
  rList: TList;
resourcestring
  sExceptionMsg = '{%s} TEnvirnoment::ClearItem Code:%d.%p';
begin
  Result := False;
  nCode := 0;
  try
    rList := TList.Create;
    try
      nCode := 1;
      GetMapBaseObjects(nX, nY, nRage + 5, rList);
      nCode := 2;
    except
      nCode := 3;
      rList.Free;
      nCode := 4;
      rList := nil;
    end;

    nCode := 5;
    nStartX := nX - nRage;
    nEndX := nX + nRage;
    nStartY := nY - nRage;
    nEndY := nY + nRage;
    for x := nStartX to nEndX do begin
      for y := nStartY to nEndY do begin
        if GetMapCellInfo(x, y, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          nCode := 51;
          if MapCellInfo.ObjList.Count > 0 then begin
            nCode := 52;
            for III := MapCellInfo.ObjList.Count - 1 downto 0 do begin
              if MapCellInfo.ObjList.Count < 1 then Break;

              nCode := 53;
              OSObject := pTOSObject(MapCellInfo.ObjList.Items[III]);
              nCode := 54;
              if (OSObject <> nil) then begin
                nCode := 56;
                if (OSObject.btType = OS_ITEMOBJECT) and (not OSObject.boObjectDisPose) then begin
                  nCode := 57;
                  //DisPoseAndNil(PTMapItem(OSObject.CellObj));
                  DisPose(PTMapItem(OSObject.CellObj));//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� �õò��û�������þ� ������� By TasNat at: 2012-03-17 17:47:42
                  PTMapItem(OSObject.CellObj):= nil;
                  nCode := 58;
                  MapCellInfo.ObjList.Delete(III);
                  nCode := 59;
                  if (OSObject <> nil) then begin
                    nCode := 510;
                    OSObject.boObjectDisPose := True; //20990510 ����
                    nCode := 511;
                    Dispose(OSObject); //20090103 �޸�
                  end;
                  nCode := 512;
                  if MapCellInfo.ObjList.Count <= 0 then begin
                    nCode := 513;
                    try //20090512 ����
                      nCode := 514;
                      if MapCellInfo.ObjList <> nil then FreeAndNil(MapCellInfo.ObjList); //20090115 �޸�
                    except
                    end;
                    break;
                  end;
                end;
              end;
            end; //for
          end;
        end;
      end;
    end;
    nCode := 25;
   //֪ͨ�����Ʒɾ��
    try
      if rList <> nil then
        for I := 0 to rList.Count - 1 do begin
          nCode := 26;
          BaseObject := TBaseObject(rList[I]);
          nCode := 27;
          BaseObject.SearchViewRange;
        end;
    except
      rList.Free;
    end;

  except
    MainOutMessage(format(sExceptionMsg, [g_sExceptionVer, nCode, ExceptAddr]));
  end;
  Result := True;
end;
//ȡ��ͼ���귶Χ�ڵĹ�

function TEnvirnoment.GetMapBaseObjects(nX, nY, nRage: Integer; rList: TList; btType: Byte = OS_MOVINGOBJECT): Boolean;
var
  III: Integer;
  x, y: Integer;
  nStartX, nStartY, nEndX, nEndY: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
resourcestring
  sExceptionMsg = '{%s} TEnvirnoment::GetMapBaseObjects';
begin
  Result := False;
  if rList = nil then Exit;
  try
    nStartX := nX - nRage;
    nEndX := nX + nRage;
    nStartY := nY - nRage;
    nEndY := nY + nRage;
    for x := nStartX to nEndX do begin
      for y := nStartY to nEndY do begin
        if GetMapCellInfo(x, y, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          if MapCellInfo.ObjList.Count > 0 then begin //20080629
            for III := 0 to MapCellInfo.ObjList.Count - 1 do begin
              OSObject := pTOSObject(MapCellInfo.ObjList.Items[III]);
              if (OSObject <> nil) then begin //20090328
                if (OSObject.btType = btType) and (not OSObject.boObjectDisPose) and (OSObject.CellObj <> nil) then begin //20090510 ����
                  case btType of
                    OS_MOVINGOBJECT: begin
                        BaseObject := TBaseObject(OSObject.CellObj);
                        if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then rList.Add(BaseObject);
                      end;
                    OS_ITEMOBJECT: begin
                        rList.Add(OSObject.CellObj);
                      end;
                  end;
                end;
              end;
            end; //for
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format(sExceptionMsg, [g_sExceptionVer]));
  end;
  Result := True;
end;
//------------------------------------------------------------------------------
//20080124 ȡָ����ͼ��Χ�������Ʒ

function TEnvirnoment.GetMapItem(nX, nY, nRage: Integer; BaseObjectList: TList): Integer;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  MapItem: PTMapItem;
  nXX, nYY: Integer;
begin
  for nXX := nX - nRage to nX + nRage do begin
    for nYY := nY - nRage to nY + nRage do begin
      if GetMapCellInfo(nXX, nYY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        if MapCellInfo.ObjList.Count > 0 then begin //20080630
          for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
            OSObject := MapCellInfo.ObjList.Items[I];
            if (OSObject <> nil) then begin
              if (OSObject.btType = OS_ITEMOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
                MapItem := PTMapItem(pTOSObject(MapCellInfo.ObjList.Items[I]).CellObj);
                if MapItem <> nil then begin
                  if MapItem.Name <> '' then BaseObjectList.Add(MapItem);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  Result := BaseObjectList.Count;
end;
//------------------------------------------------------------------------------

function TEnvirnoment.GetEvent(nX, nY: Integer): TObject;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
begin
  Result := nil;
  bo2C := False;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    if MapCellInfo.ObjList.Count > 0 then begin
      for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
        OSObject := MapCellInfo.ObjList.Items[I];
        if (OSObject <> nil) then begin
          if (OSObject.btType = OS_EVENTOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
            Result := OSObject.CellObj;
          end;
        end;
      end;
    end;
  end;
end;
//���õ�ͼָ��XY����ı�־

procedure TEnvirnoment.SetMapXYFlag(nX, nY: Integer; boFlag: Boolean);
var
  MapCellInfo: pTMapCellinfo;
begin
  if GetMapCellInfo(nX, nY, MapCellInfo) then begin
    if boFlag then MapCellInfo.chFlag := 0
    else MapCellInfo.chFlag := 2;
  end;
end;

function TEnvirnoment.CanFly(nSX, nSY, nDX, nDY: Integer): Boolean;
var
  r28, r30: real;
  n14, n18, n1C: Integer;
begin
  Result := True;
  r28 := (nDX - nSX) / 1.0E1;
  r30 := (nDY - nDX) / 1.0E1;
  n14 := 0;
  while (True) do begin
    try //20101126 ��ֹ��ѭ��
      n18 := Round(nSX + r28);
      n1C := Round(nSY + r30);
      if not CanWalk(n18, n1C, True) then begin
        Result := False;
        Break;
      end;
    except
    end;
    Inc(n14);
    if n14 >= 10 then Break;
  end;
end;

function TEnvirnoment.GetXYHuman(nMapX, nMapY: Integer): Boolean;
var
  I: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
begin
  Result := False;
  if GetMapCellInfo(nMapX, nMapY, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
    if MapCellInfo.ObjList.Count > 0 then begin //20080630
      for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
        OSObject := MapCellInfo.ObjList.Items[I];
        if (OSObject <> nil) then begin
          if (OSObject.btType = OS_MOVINGOBJECT) and (not OSObject.boObjectDisPose) then begin //20090510 ����
            BaseObject := TBaseObject(OSObject.CellObj);
            if BaseObject <> nil then begin
              if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
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

function TEnvirnoment.sub_4B5FC8(nX, nY: Integer): Boolean;
var
  MapCellInfo: pTMapCellinfo;
begin
  Result := True;
  if GetMapCellInfo(nX, nY, MapCellInfo) and (MapCellInfo.chFlag = 2) then Result := False;
end;
//ȡ��ͼ��Ϣ

function TEnvirnoment.GetEnvirInfo: string;
var
  sMsg: string;
begin
  sMsg := '��ͼ��:%s(%s) DAY:%s DARK:%s SAFE:%s FIGHT:%s FIGHT3:%s QUIZ:%s NORECONNECT:%s(%s) MUSIC:%s(%d) EXPRATE:%s(%f) PKWINLEVEL:%s(%d) PKLOSTLEVEL:%s(%d) PKWINEXP:%s(%d) PKLOSTEXP:%s(%d) DECHP:%s(%d/%d) INCHP:%s(%d/%d)';
  sMsg := sMsg + ' DECGAMEGOLD:%s(%d/%d) INCGAMEGOLD:%s(%d/%d) INCGAMEPOINT:%s(%d/%d) DECGAMEPOINT:%s(%d/%d) RUNHUMAN:%s RUNMON:%s NEEDHOLE:%s NORECALL:%s NOGUILDRECALL:%s NODEARRECALL:%s NOMASTERRECALL:%s NODRUG:%s MINE:%s NOPOSITIONMOVE:%s NOCALLHERO:%s MISSION:%s';
  Result := Format(sMsg, [sMapName, sMapDesc,
    BoolToCStr(m_boDAY),
      BoolToCStr(m_boDARK),
      BoolToCStr(m_boSAFE),
      BoolToCStr(m_boFightZone),
      BoolToCStr(m_boFight3Zone),
      BoolToCStr(m_boQUIZ),
      BoolToCStr(m_boNORECONNECT), sNoReconnectMap,
      BoolToCStr(m_boMUSIC), m_nMUSICID,
      BoolToCStr(m_boEXPRATE), m_nEXPRATE / 100,
      BoolToCStr(m_boPKWINLEVEL), m_nPKWINLEVEL,
      BoolToCStr(m_boPKLOSTLEVEL), m_nPKLOSTLEVEL,
      BoolToCStr(m_boPKWINEXP), m_nPKWINEXP,
      BoolToCStr(m_boPKLOSTEXP), m_nPKLOSTEXP,
      BoolToCStr(m_boDECHP), m_nDECHPTIME, m_nDECHPPOINT,
      BoolToCStr(m_boINCHP), m_nINCHPTIME, m_nINCHPPOINT,
      BoolToCStr(m_boDecGameGold), m_nDECGAMEGOLDTIME, m_nDecGameGold,
      BoolToCStr(m_boIncGameGold), m_nINCGAMEGOLDTIME, m_nIncGameGold,
      BoolToCStr(m_boINCGAMEPOINT), m_nINCGAMEPOINTTIME, m_nINCGAMEPOINT,
      BoolToCStr(m_boDECGAMEPOINT), m_nDECGAMEPOINTTIME, m_nDECGAMEPOINT,
      BoolToCStr(m_boRUNHUMAN),
      BoolToCStr(m_boRUNMON),
      BoolToCStr(m_boNEEDHOLE),
      BoolToCStr(m_boNORECALL),
      BoolToCStr(m_boNOGUILDRECALL),
      BoolToCStr(m_boNODEARRECALL),
      BoolToCStr(m_boNOMASTERRECALL),
      BoolToCStr(m_boNODRUG),
      BoolToCStr(m_boMINE),
      BoolToCStr(m_boNOPOSITIONMOVE),
      BoolToCStr(m_boNOCALLHERO), //20080124 ��ֹ�ٻ�Ӣ��
      BoolToCStr(m_boMISSION) //20080124 ������ʹ���κ���Ʒ�ͼ���
      ]);
end;

procedure TEnvirnoment.AddObject(nType: Integer);
begin
  case nType of
    0: Inc(m_nHumCount);
    1: Inc(m_nMonCount);
  end;
end;

procedure TEnvirnoment.DelObjectCount(BaseObject: TObject);
var
  btRaceServer: Byte;
begin
  btRaceServer := TBaseObject(BaseObject).m_btRaceServer;
  if btRaceServer = RC_PLAYOBJECT then begin
    Dec(m_nHumCount);
    if TBaseObject(BaseObject).m_boAI then Dec(m_nHumAICount);
  end;
  if btRaceServer >= RC_ANIMAL then Dec(m_nMonCount);
end;
//ɾ����ͼ

function TMapManager.DelMap(sMapName: string): Boolean;
var
  Map: TEnvirnoment;
  I: Integer;
begin
  Result := False;
  try
    Lock;
    try
      if Count > 0 then begin
        for I := 0 to Count - 1 do begin
          Map := TEnvirnoment(Items[I]);
          if Map <> nil then begin
            if CompareText(Map.sMapName, sMapName) = 0 then begin
              Self.Delete(I);
              Map.Free;
              Result := True;
              Break;
            end;
          end;
        end;
      end;
    finally
      UnLock;
    end;
  except
    Result := False;
  end;
end;

procedure TMapManager.Run;
var
  I, II: Integer;
  Envir: TEnvirnoment;
  BaseObject: TBaseObject;
  BaseObjectList: TList;
  nCode: Byte;
  boProcessLimit: Boolean;
begin
  if GetTickCount - m_dwRunTick > 10000 then begin
    m_dwRunTick := GetTickCount;
    try
      if m_MirrorMaps.Count > 0 then begin
        for I := nMirrorMapsIndx to m_MirrorMaps.Count - 1 do begin
          if I >= m_MirrorMaps.Count then Break;
          Envir := m_MirrorMaps.Items[I];
          nCode := 1;
          if Envir <> nil then begin
            nCode := 2;
            if Envir.m_boMirrorMap and (not Envir.m_boMirrorMaping)
              and (GetTickCount >= Envir.m_dwMirrorMapTick) and (Envir.sMirrorHomeMap <> '') then begin
              BaseObjectList := TList.Create; //�����ͼ������
              nCode := 3;
              try
                Envir.GetRangeBaseObject(Envir.m_nWidth div 2, Envir.m_nHeight div 2, _MAX(Envir.m_nWidth div 2, Envir.m_nHeight div 2), True, BaseObjectList);
                Envir.m_boMirrorMaping := True;
                if BaseObjectList.Count > 0 then begin
                  nCode := 4;
                  for II := 0 to BaseObjectList.Count - 1 do begin
                    BaseObject := TBaseObject(BaseObjectList.Items[II]);
                    if BaseObject <> nil then begin
                      nCode := 5;
                      if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then begin
                        case BaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: begin
                              nCode := 6;
                              BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
                              BaseObject.MapRandomMove(Envir.sMirrorHomeMap, 0); //�ƶ���ָ����ͼ
                            end;
                          RC_HEROOBJECT: begin
                              nCode := 7;
                              BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
                              BaseObject.MapRandomMove(Envir.sMirrorHomeMap, 0); //�ƶ���ָ����ͼ
                            end;
                        else begin
                            if BaseObject.m_Master <> nil then begin
                              nCode := 8;
                              if BaseObject.m_Master.m_btRaceServer in [RC_PLAYOBJECT, RC_HEROOBJECT] then begin
                                nCode := 9;
                                BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
                                BaseObject.MapRandomMove(Envir.sMirrorHomeMap, 0); //�ƶ���ָ����ͼ
                              end else begin
                                nCode := 10;
                                BaseObject.m_boDeath := True;
                                BaseObject.m_boGhost := True;
                                //BaseObject.m_dwGhostTick := GetTickCount();
                              end;
                            end else begin
                              nCode := 11;
                              BaseObject.m_boDeath := True;
                              BaseObject.m_boGhost := True;
                              //BaseObject.m_dwGhostTick := GetTickCount();
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              finally
                BaseObjectList.Free;
              end;
              nCode := 9;
              m_MirrorMaps.Delete(I);
              nCode := 10;
              DelMap(Envir.sMapName);
              Break;
            end;
          end;
          if ((GetTickCount - m_dwRunTick) > 10) and (I < (m_MirrorMaps.Count - 1)) then begin
            nMirrorMapsIndx := I + 1;
            boProcessLimit := True;
            Break;
          end;
        end;
      end;
      if not boProcessLimit then nMirrorMapsIndx := 0;
    except
      MainOutMessage(Format('{%s} TMapManager.Run Code:%d', [g_sExceptionVer, nCode]));
    end;
  end;
end;

end.

