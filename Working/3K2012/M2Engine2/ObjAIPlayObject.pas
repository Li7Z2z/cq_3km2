unit ObjAIPlayObject;

interface
uses
  Windows, Classes, ObjBase, SysUtils, Envir, MapPoint, PathFind, Grobal2;
type
  TAIPlayObject = class(TPlayObject)//����
    m_dwSearchTargetTick: LongWord;
    m_boAIStart: Boolean;//��������
    m_ManagedEnvir: TEnvirnoment; //�һ���ͼ
    m_PointManager: TPointManager;
    m_Path: TPath;
    m_nPostion: Integer;
    m_nMoveFailCount: Integer;
    m_sConfigListFileName: string;
    m_sHeroConfigListFileName: string;
    m_sFilePath: string;
    m_sConfigFileName: string;
    m_sHeroConfigFileName: string;
    m_BagItemNames: TStringList;
    m_UseItemNames: TUseItemNames;
    m_RunPos: TRunPos;
    m_SkillUseTick: array[0..{79}58] of LongWord; //ħ��ʹ�ü��
    m_nSelItemType: Integer;
    m_nIncSelfHealthCount: Integer;
    m_nIncMasterHealthCount: Integer;
    m_wHitMode: Word;//������ʽ
    m_boSelSelf: Boolean;
    m_btTaoistUseItemType: Byte;
    m_dwAutoRepairItemTick: LongWord;
    m_dwAutoAddHealthTick: LongWord;
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean;
    m_dwSearchMagic: LongWord;
    m_dwHPToMapHomeTick: LongWord;//��Ѫ�سǼ��
    m_boProtectStatus: Boolean;//�ػ�ģʽ
    m_nProtectTargetX, m_nProtectTargetY: Integer;//�ػ�����
    m_boProtectOK: Boolean;//�����ػ�����
    m_nGotoProtectXYCount: Integer;//�����ػ�������ۼ���
    m_dwPickUpItemTick: LongWord;
    m_SelMapItem: PTMapItem;
    m_dwHeroUseSpellTick: LongWord;//ʹ�úϻ����
    dwTick5F4: LongWord;//�ܲ���ʱ
    {$IF M2Version = 1}
    m_BatterMagicList: TList;//���������б�
    {$IFEND}
    m_AISayMsgList: TStringList;//�ܹ���˵���б�
    m_boAutoRecallHero: Boolean;//�Զ��ٻ�Ӣ��
    n_AmuletIndx: Byte;//�̺춾��ʶ
    m_boCanPickIng: Boolean;
    m_nSelectMagic: Integer;//��ѯħ��
    m_boIsUseMagic: Boolean;//�Ƿ����ʹ�õ�ħ��(True�ſ��ܶ��)
    m_boIsUseAttackMagic: Boolean;//�Ƿ����ʹ�õĹ���ħ��
    m_btLastDirection: Byte;//���ķ���
    m_dwAutoAvoidTick: LongWord;//�Զ���ܼ��
    m_boIsNeedAvoid: Boolean;//�Ƿ���Ҫ���
  private
    function RunToNext(nX, nY: Integer): Boolean;
    function WalkToNext(nX, nY: Integer): Boolean;
    function WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;

    function AllowUseMagic(wMagIdx: Word): Boolean;
    function CanLineAttack(nStep: Integer): Boolean; overload;
    function CanLineAttack(nCurrX, nCurrY: Integer): Boolean; overload;
    function GetUserItemList(nItemType, nCount: Integer): Integer;
    function UseItem(nItemType, nIndex: Integer): Boolean;//�Զ�������
    function CheckUserItemType(nItemType, nCount: Integer): Boolean;
    function CheckUserItem(nItemType, nCount: Integer): Boolean;
    function CheckItemType(nItemType: Integer; StdItem: pTStdItem): Boolean;
    function GetNearTargetCount(): Integer; overload;
    function GetNearTargetCount(nCurrX, nCurrY: Integer): Integer; overload;
    function GetRangeTargetCountByDir(nDir, nX, nY, nRange: Integer): Integer;
    function GetRangeTargetCount(nX, nY, nRange: Integer): Integer;
    function FindVisibleActors(ActorObject: TBaseObject): Boolean;
    function FollowMaster: Boolean;
    function GetMasterRange(nTargetX, nTargetY: Integer): Integer;
    function CanWalk(nCurrX, nCurrY, nTargetX, nTargetY: Integer; nDir: Integer; var nStep: Integer; boFlag: Boolean): Boolean;
    function IsGotoXY(X1, Y1, X2, Y2: Integer): Boolean;
    function GotoNext(nX, nY: Integer; boRun: Boolean): Boolean;
    function IsUseAttackMagic(): Boolean; //����Ƿ����ʹ�ù���ħ��

    (*function SelectMagic(): Integer;
    function WarrAttackTarget(wMagIdx, wHitMode: Word): Boolean;{������}
    function WarrorAttackTarget(wMagIdx: Word): Boolean;{սʿ����}
    function WizardAttackTarget(wMagIdx: Word): Boolean;{��ʦ����}
    function TaoistAttackTarget(wMagIdx: Word): Boolean;{��ʿ����}*)

    function UseSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function AutoSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; BaseObject: TBaseObject): Boolean;
    //function StartAttack(wMagIdx: Word): Boolean;
    function DoThink(wMagicID: Word): Integer;
    function ActThink(wMagicID: Word): Boolean;
    function CanAttack(BaseObject: TBaseObject; nRange: Integer; var btDir: Byte): Boolean; overload;
    function CanAttack(nCurrX, nCurrY: Integer; BaseObject: TBaseObject; nRange: Integer; var btDir: Byte): Boolean; overload;
    procedure GotoProtect();
    function SearchPickUpItem(nPickUpTime: Integer): Boolean;
    {$IF M2Version = 1}
    function GetBatterMagic(): Boolean;//ȡ��������ID
    function HeroBatterAttackTarget(): Boolean;//�����������
    procedure HeroBatterStop();//����ֹͣ
    procedure UseBatterSpell(nMagicID{����ID},StormsHit{������}: Byte);//������
    procedure BatterAttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word; StormsHit{������}: Byte);//ս��������
    {$IFEND}
    {procedure NewGotoTargetXY;
    procedure HeroTail();}    
    function WarrAttackTarget1(wHitMode: Word): Boolean; {������}
    function WarrorAttackTarget1(): Boolean; {սʿ����}
    function WizardAttackTarget1(): Boolean; {��ʦ����}
    function TaoistAttackTarget1(): Boolean; {��ʿ����}
    function AttackTarget(): Boolean;
    function IsNeedAvoid(): Boolean;//�Ƿ���Ҫ���
    function AutoAvoid(): Boolean; //�Զ����
    function IsNeedGotoXY(): Boolean; //�Ƿ�����Ŀ��
    function GetGotoXY(BaseObject: TBaseObject; nCode:Byte): Boolean;//ȡ��ɱλ 20080604
    function GotoTargetXY(nTargetX, nTargetY, nCode: Integer): Boolean;
    procedure SearchMagic();
    function SelectMagic1(): Integer;
    function CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
    function CheckTargetXYCount1(nX, nY, nRange: Integer): Integer;//սʿ�ж�ʹ��
    function CheckTargetXYCount2(nMode: Word): Integer;//�����䵶�ж�Ŀ�꺯��
    function CheckTargetXYCount3(nX, nY, nRange, nCount: Integer): Integer;//�����������ܻ�ʹ��
    function CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;{���ָ������ͷ�Χ������Ĺ�������}
    function RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;//�ܵ�Ŀ������
    function WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;//����Ŀ��
    Function CheckHeroAmulet(nType: Integer; nCount: Integer):Boolean;
  protected
    function GotoNextOne(nX, nY: Integer; boRun: Boolean): Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Run; override;
    procedure SearchViewRange(); override;
    function Thinking: Boolean;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Wondering(); override;
    procedure SearchTarget(); override;
    procedure Start(PathType: TPathType);
    procedure Stop;
    procedure MakeGhost; override;
    procedure ProcessSayMsg(sData: string); override;
    procedure Whisper(whostr, saystr: string); override;
    procedure Hear(nIndex: Integer; sMsg: string); override;
    procedure Die; override;
    procedure Struck(hiter: TBaseObject); override;
    function IsProtectTarget(BaseObject: TBaseObject): Boolean; override;
    function IsAttackTarget(BaseObject: TBaseObject): Boolean; override;
    function IsProperTarget(BaseObject: TBaseObject): Boolean; override;
    function IsProperFriend(BaseObject: TBaseObject): Boolean; override;
    function FindMagic(wMagIdx: Word): pTUserMagic; overload;
    function FindMagic(sMagicName: string): pTUserMagic; overload;
    function GetRandomConfigFileName(sName: String; nType: Byte): string;
  end;

implementation
uses M2Share, HUtil32, Guild, IniFiles, ObjHero, Event;
{TAIPlayObject}

constructor TAIPlayObject.Create();
begin
  inherited;
  m_nSoftVersionDate := CLIENT_VERSION_NUMBER;
  m_nSoftVersionDateEx := GetExVersionNO(CLIENT_VERSION_NUMBER, m_nSoftVersionDate);

  AbilCopyToWAbil();
  m_btAttatckMode:= 0;
  m_boAI := True;
  m_boLoginNoticeOK := True;
  m_boAIStart := False; //��ʼ�һ�
  m_ManagedEnvir := nil; //�һ���ͼ
  m_Path := nil;
  m_nPostion := -1;
  m_sFilePath := '';
  m_sConfigFileName := '';
  m_sHeroConfigFileName := '';
  m_sConfigListFileName := '';
  m_sHeroConfigListFileName:='';
  FillChar(m_UseItemNames, SizeOf(TUseItemNames), #0);
  FillChar(m_RunPos, SizeOf(TRunPos), #0);
  m_BagItemNames := TStringList.Create;
  m_PointManager := TPointManager.Create(Self);
  FillChar(m_SkillUseTick, SizeOf(m_SkillUseTick), 0); //ħ��ʹ�ü��
  m_nSelItemType := 1;
  m_nIncSelfHealthCount := 0;
  m_nIncMasterHealthCount:= 0;
  m_boSelSelf:= False;
  m_btTaoistUseItemType:= 0;
  m_dwAutoAddHealthTick:= GetTickCount;
  m_dwAutoRepairItemTick:= GetTickCount;
  m_dwThinkTick:= GetTickCount;
  m_boDupMode:= False;
  m_boProtectStatus:= False;//�ػ�ģʽ
  m_boProtectOK:= True;//�����ػ�����
  m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ���
  m_SelMapItem := nil;
  m_dwPickUpItemTick:= GetTickCount;
  m_dwHeroUseSpellTick:= GetTickCount;//ʹ�úϻ����
  {$IF M2Version = 1}
  m_BatterMagicList:= TList.Create;//���������б�
  {$IFEND}
  m_AISayMsgList:= TStringList.Create;//�ܹ���˵���б�
  m_boAutoRecallHero:= False;//�Զ��ٻ�Ӣ��
  n_AmuletIndx:= 0;
  m_boCanPickIng:= False;
  m_nSelectMagic:= 0;
  m_boIsUseMagic := False;//�Ƿ��ܶ��
  m_boIsUseAttackMagic := False;
  m_btLastDirection := m_btDirection;
  m_dwAutoAvoidTick:= GetTickCount;//�Զ���ܼ��
  m_boIsNeedAvoid := False;//�Ƿ���Ҫ���
  m_dwWalkTick:= GetTickCount;
  m_nWalkSpeed := 300;
end;

destructor TAIPlayObject.Destroy;
begin
{$IF M2Version = 1}
  try
    if m_BatterMagicList <> nil then begin
      FreeAndNil(m_BatterMagicList);
    end;
  except
  end;
{$IFEND}
  m_AISayMsgList.Free;
  m_Path := nil;
  m_BagItemNames.Free;
  m_PointManager.Free;
  inherited;
end;
{$IF M2Version = 1}
//ȡ��������ID
function TAIPlayObject.GetBatterMagic(): Boolean;
var
  LoadList: TStringList;
  I, K: Integer;
  nCode: Byte;
begin
  Result:= False;
  nCode:= 0;
  try
    if m_boDeath or m_boGhost or ((m_wStatusTimeArr[POISON_STONE {5}] <> 0) and
      not g_ClientConf.boParalyCanHit) or (m_Skill69NH < 11) or
      (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0) or (m_wStatusArrValue[23] <> 0) then begin //����
      Exit;
    end;
    nCode:= 1;
    if m_boTrainingNG and m_boTrainBatterSkill and (not m_boUseBatter) and (m_TargetCret <> nil) and
      (GetTickCount()- m_nUseBatterTick > g_Config.dwUseBatterTick) and (m_BatterMagicList.Count > 0) then begin//ѧ������������ʱ��ﵽ
      m_nUseBatterTick:= GetTickCount();
      m_nBatterMagIdx1:= 0;//��������ID1
      m_nBatterMagIdx2:= 0;//��������ID2
      m_nBatterMagIdx3:= 0;//��������ID3
      m_nBatterMagIdx4:= 0;//��������ID4
      LoadList:= TStringList.Create;
      try
        nCode:= 3;
        for I:= 0 to m_BatterMagicList.Count -1  do begin
          nCode:= 4;
          if pTUserMagic(m_BatterMagicList[i]) <> nil then begin//20091124 ����
            nCode:= 52;
            case pTUserMagic(m_BatterMagicList[i]).btKey of
              0: begin
                nCode:= 53;
                if pTUserMagic(m_BatterMagicList[i]).MagicInfo <> nil then begin//20100428 ����
                  nCode:= 57;
                  try
                    LoadList.Add(IntToStr(pTUserMagic(m_BatterMagicList[i]).MagicInfo.wMagicId));//ȡ��û�����ÿ�ݼ��ļ���ID
                  except
                  end;
                end;
              end;
              1: begin
                if pTUserMagic(m_BatterMagicList[i]).MagicInfo <> nil then begin//20100914 ����
                  nCode:= 54;
                  m_nBatterMagIdx1:= pTUserMagic(m_BatterMagicList[i]).MagicInfo.wMagicId;
                end;
              end;
              2: begin
                if pTUserMagic(m_BatterMagicList[i]).MagicInfo <> nil then begin//20100914 ����
                  nCode:= 55;
                  m_nBatterMagIdx2:= pTUserMagic(m_BatterMagicList[i]).MagicInfo.wMagicId;
                end;
              end;
              3: begin
                if pTUserMagic(m_BatterMagicList[i]).MagicInfo <> nil then begin//20100914 ����
                  nCode:= 56;
                  m_nBatterMagIdx3:= pTUserMagic(m_BatterMagicList[i]).MagicInfo.wMagicId;
                end;
              end;
              4: begin
                nCode:= 56;
                if m_boUser4BatterSkill and (pTUserMagic(m_BatterMagicList[i]).MagicInfo <> nil) then//�������ĸ����� 20100720
                  m_nBatterMagIdx4:= pTUserMagic(m_BatterMagicList[i]).MagicInfo.wMagicId;
              end;
            end;
          end;
        end;
        nCode:= 51;
        if (m_SetBatterKey = 1) and (LoadList.Count > 0) then begin//��һ�����ѡ����ID
          K := Random(LoadList.Count);
          m_nBatterMagIdx1 := Str_ToInt(LoadList.Strings[K], 0);
          LoadList.Delete(K);
        end;
        nCode:= 6;
        if m_nBatterMagIdx1 > 0 then begin
          if (m_SetBatterKey1 = 1) and (LoadList.Count > 0) then begin//�ڶ������ѡ����ID
            nCode:= 7;
            K := Random(LoadList.Count);
            m_nBatterMagIdx2 := Str_ToInt(LoadList.Strings[K], 0);
            LoadList.Delete(K);
          end;
          nCode:= 8;
          if m_nBatterMagIdx2 > 0 then begin
            if (m_SetBatterKey2 = 1) and (LoadList.Count > 0) then begin//���������ѡ����ID
              nCode:= 9;
              K := Random(LoadList.Count);
              m_nBatterMagIdx3 := Str_ToInt(LoadList.Strings[K], 0);
              LoadList.Delete(K);
            end;
          end;
          if m_nBatterMagIdx3 > 0 then begin
            if (m_SetBatterKey3 = 1) and (LoadList.Count > 0) and m_boUser4BatterSkill then begin//���ĸ����ѡ����ID
              nCode:= 9;
              K := Random(LoadList.Count);
              m_nBatterMagIdx4 := Str_ToInt(LoadList.Strings[K], 0);
              LoadList.Delete(K);
            end;
          end;
          m_boUseBatter:= True;//ʹ������
          Result:= True;
          nCode:= 11;
          if m_btJob = 0 then begin//ս
            m_boWarUseBatter:= False;
            m_dwLatestWarUseBatterTick:= GetTickCount();
          end else begin//����
            m_nDecDamageRate:= Random(g_Config.dwBatterRandDecDamageRate) + g_Config.dwBatterDecDamageRate;//���˱���
          end;
        end else begin
          m_nBatterMagIdx2 := 0;
          m_nBatterMagIdx3 := 0;
          m_nBatterMagIdx4 := 0;
        end;
        nCode:= 10;
        if (m_nBatterMagIdx4 = m_nBatterMagIdx1) or (m_nBatterMagIdx4 = m_nBatterMagIdx2) or (m_nBatterMagIdx4 = m_nBatterMagIdx3) or (m_nBatterMagIdx2 = 0) or (m_nBatterMagIdx3 = 0) or (m_nBatterMagIdx2 = m_nBatterMagIdx3) then begin
          m_nBatterMagIdx4 := 0;
        end;
        if (m_nBatterMagIdx3 = m_nBatterMagIdx1) or (m_nBatterMagIdx3 = m_nBatterMagIdx2) or (m_nBatterMagIdx2 = 0) or (m_nBatterMagIdx3 = 0) then begin
          m_nBatterMagIdx3 := 0;
          m_nBatterMagIdx4 := 0;
        end;
        if (m_nBatterMagIdx2 = m_nBatterMagIdx1) or (m_nBatterMagIdx2 = m_nBatterMagIdx3) or (m_nBatterMagIdx2 = 0) then begin
          m_nBatterMagIdx2 := 0;
          m_nBatterMagIdx3 := 0;
          m_nBatterMagIdx4 := 0;
        end;
      finally
        LoadList.Free;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.GetBatterMagic Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//�����������
function TAIPlayObject.HeroBatterAttackTarget(): Boolean;
var
  BoWarrorAttack: Boolean;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if m_boDeath or m_boGhost then Exit;//20091124 ����
    nCode:= 1;
    if (not m_boUseBatter) and (m_TargetCret <> nil) then GetBatterMagic;//ȡ��������ID
    if m_boUseBatter then begin
      nCode:= 2;
      if m_btJob > 0 then begin//����ְҵ
        if GetTickCount - m_nUseBatterTime > 850 then begin//��������
          m_nUseBatterTime := GetTickCount();
          nCode:= 3;
          if (m_wStatusTimeArr[POISON_STONE] = 0) then m_boCanWalk:= False;//������
          if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then m_boCanRun:= False;//������
          m_boCanHit:= False;//���ܴ��
          m_boCanSpell:= False;//����ħ��
          nCode:= 4;
          if (m_nBatterMagIdx1 <= 0) and (m_nBatterMagIdx2 <= 0) and (m_nBatterMagIdx3 <= 0) and (m_nBatterMagIdx4 <= 0) then begin
            m_boUseBatter:= False;
            m_nDecDamageRate:= 0;//���˱���
            m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
            if (m_wStatusTimeArr[POISON_STONE] = 0) then m_boCanWalk:= True;//������
            if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then m_boCanRun:= True;//������
            m_boCanHit:= True;//���ܴ��
            m_boCanSpell:= True;//����ħ��
          end;
          nCode:= 5;
          if m_nBatterMagIdx1 <> 0 then begin
            UseBatterSpell(m_nBatterMagIdx1, 10);//����һ������������Ϣ
            m_nBatterMagIdx1:= 0;
          end else if m_nBatterMagIdx2 <> 0 then begin
            UseBatterSpell(m_nBatterMagIdx2, 15);//���ڶ�������������Ϣ
            m_nBatterMagIdx2:= 0;
          end else if m_nBatterMagIdx3 <> 0 then begin
            UseBatterSpell(m_nBatterMagIdx3, 25);//������������������Ϣ
            m_nBatterMagIdx3:= 0;
          end else if m_nBatterMagIdx4 <> 0 then begin
            UseBatterSpell(m_nBatterMagIdx4, 30);//������������������Ϣ
            m_nBatterMagIdx4:= 0;
          end;
        end;
      end else begin//ս
        nCode:= 6;
        BoWarrorAttack:= False;
        if m_TargetCret <> nil then begin
          nCode:= 7;
          if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
             ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
             ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
             ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
             ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
             ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) then BoWarrorAttack:= True
          else GotoNextOne(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, True);{GotoTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0)};
        end;
        nCode:= 8;
        if (GetTickCount - m_nUseBatterTime > 100) and BoWarrorAttack then begin//��������
          m_nUseBatterTime := GetTickCount();
          if (not m_boWarUseBatter) then begin
            nCode:= 9;
            if (m_nBatterMagIdx1 > 0) then begin
              m_boWarUseBatter:= True;
              UseBatterSpell(m_nBatterMagIdx1, 10);
              m_dwLatestWarUseBatterTick:= GetTickCount();
              m_boWarUseBatter:= False;
              m_nBatterMagIdx1:= 0;
            end else
            if (m_nBatterMagIdx2 > 0) then begin
              m_boWarUseBatter:= True;
              UseBatterSpell(m_nBatterMagIdx2, 15);
              m_dwLatestWarUseBatterTick:= GetTickCount();
              m_boWarUseBatter:= False;
              m_nBatterMagIdx2:= 0;
            end else
            if (m_nBatterMagIdx3 > 0) then begin
              m_boWarUseBatter:= True;
              UseBatterSpell(m_nBatterMagIdx3, 25);
              m_dwLatestWarUseBatterTick:= GetTickCount();
              m_boWarUseBatter:= False;
              m_nBatterMagIdx3:= 0;
            end else
            if (m_nBatterMagIdx4 > 0) then begin
              m_boWarUseBatter:= True;
              UseBatterSpell(m_nBatterMagIdx4, 30);
              m_dwLatestWarUseBatterTick:= GetTickCount();
              m_boWarUseBatter:= False;
              m_nBatterMagIdx4:= 0;
            end;
          end;
        end;
        nCode:= 10;
        if (m_nBatterMagIdx1 <= 0) and (m_nBatterMagIdx2 <= 0) and (m_nBatterMagIdx3 <= 0) and (m_nBatterMagIdx4 <= 0) then begin
          m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
          m_dwLatestWarUseBatterTick:= GetTickCount();
          m_boUseBatter:= False;
          m_boWarUseBatter:= False;
          Result := True;
        end;
        if m_boUseBatter then begin//սʹ��������10��δʹ�ã����Զ��ر� 20100628
          if m_boWarUseBatter and ((GetTickCount - m_dwLatestWarUseBatterTick) > 10000) then begin
            m_boWarUseBatter:= False;
            m_boUseBatter:= False;
            m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
            m_dwLatestWarUseBatterTick:= GetTickCount();
            m_nBatterMagIdx1:= 0;//��������ID1
            m_nBatterMagIdx2:= 0;//��������ID2
            m_nBatterMagIdx3:= 0;//��������ID3
            m_nBatterMagIdx4:= 0;//��������ID4
          end;
        end;
      end;//ս
      if m_boUseBatter then begin
        Result := True;
        m_dwHitTick := GetTickCount();
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.BatterAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//����ֹͣ
procedure TAIPlayObject.HeroBatterStop();
begin
  if m_boDeath or m_boGhost then Exit;
  m_nBatterMagIdx1:= 0;//��������ID1
  m_nBatterMagIdx2:= 0;//��������ID2
  m_nBatterMagIdx3:= 0;//��������ID3
  m_nBatterMagIdx4:= 0;//��������ID4
  if (m_btJob = 0) then begin
    m_boUseBatter:= False;
    m_boWarUseBatter:= False;
    m_dwLatestWarUseBatterTick:= GetTickCount();
  end else begin
    m_boUseBatter:= False;
    m_nDecDamageRate:= 0;//���˱���
    if (m_wStatusTimeArr[POISON_STONE] = 0) then m_boCanWalk:= True;//������
    if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then m_boCanRun:= True;//������
    m_boCanHit:= True;//���ܴ��
    m_boCanSpell:= True;//����ħ��
  end;
end;
//������
procedure TAIPlayObject.UseBatterSpell(nMagicID{����ID},StormsHit{������}: Byte);
var
  UserMagic: pTUserMagic;
  nSpellPoint: Integer;
  nCode: Byte;
begin
  nCode:= 0;
  try
    if m_boDeath or m_boGhost then Exit;//20091124 ����
    m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
    UserMagic := FindMagic(nMagicID);
    nCode:= 1;
    if (m_PEnvir <> nil) then begin//��ͼ�Ƿ��ֹʹ��ħ��
      nCode:= 2;
      if (UserMagic <> nil) then begin//20091018
        nCode:= 21;
        if not m_PEnvir.AllowMagics(UserMagic.MagicInfo.sMagicName) then begin
          nCode:= 3;
          m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
          m_nBatterMagIdx1:= 0;//��������ID1 20090701
          m_nBatterMagIdx2:= 0;//��������ID2 20090701
          m_nBatterMagIdx3:= 0;//��������ID3 20090701
          m_nBatterMagIdx4:= 0;//��������ID4 20090701
          if (m_btJob = 0) then begin
            m_boUseBatter:= False;
            m_boWarUseBatter:= False;
            m_dwLatestWarUseBatterTick:= GetTickCount();
          end;
          Exit;
        end;
      end;
      nCode:= 4;
      if m_PEnvir.m_boMISSION then begin
        m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
        m_nBatterMagIdx1:= 0;//��������ID1 20090701
        m_nBatterMagIdx2:= 0;//��������ID2 20090701
        m_nBatterMagIdx3:= 0;//��������ID3 20090701
        m_nBatterMagIdx4:= 0;//��������ID4
        if (m_btJob = 0) then begin
          m_boUseBatter:= False;
          m_boWarUseBatter:= False;
          m_dwLatestWarUseBatterTick:= GetTickCount();
        end;
        Exit;
      end;
    end;
    nCode:= 5;
    if (UserMagic = nil) or m_boDeath or ((m_wStatusTimeArr[POISON_STONE{5}] <> 0) and not g_ClientConf.boParalyCanHit)
      or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0) or (m_wStatusArrValue[23] <> 0) then begin
      m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
      m_nBatterMagIdx1:= 0;//��������ID1 20090701
      m_nBatterMagIdx2:= 0;//��������ID2 20090701
      m_nBatterMagIdx3:= 0;//��������ID3 20090701
      m_nBatterMagIdx4:= 0;//��������ID4
      if (m_btJob = 0) then begin
        m_boUseBatter:= False;
        m_boWarUseBatter:= False;
        m_dwLatestWarUseBatterTick:= GetTickCount();
      end;
      Exit;
    end;
    nCode:= 6;
    nSpellPoint := GetSpellPoint(UserMagic);//ȡ�ż�������Ҫ������ֵ
    if (nSpellPoint > 0) and m_boTrainingNG then begin
      nCode:= 7;
      if (m_Skill69NH < nSpellPoint) then begin
        m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
        m_nBatterMagIdx1:= 0;//��������ID1 20090701
        m_nBatterMagIdx2:= 0;//��������ID2 20090701
        m_nBatterMagIdx3:= 0;//��������ID3 20090701
        m_nBatterMagIdx4:= 0;//��������ID4
        if (m_btJob = 0) then begin
          m_boUseBatter:= False;
          m_boWarUseBatter:= False;
          m_dwLatestWarUseBatterTick:= GetTickCount();
        end;
        Exit;
      end;
      m_Skill69NH := _MAX(0, m_Skill69NH - nSpellPoint);
      nCode:= 8;
      SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
      {$IF M2Version <> 2}
      m_dwIncNHTick := GetTickCount();
      {$IFEND}
      if m_btJob > 0 then begin//����ְҵ
        SendRefMsg(RM_10205, 15, 0, 0, 0, '');////��������Ч 20090628
        nCode:= 9;
        if m_TargetCret <> nil then begin
          m_nTargetX:= m_TargetCret.m_nCurrX;
          m_nTargetY:= m_TargetCret.m_nCurrY;
        end;
        nCode:= 10;
        m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY);
        nCode:= 11;
        SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, m_nTargetX, m_nTargetY, UserMagic.MagicInfo.wMagicId, '');
        case UserMagic.MagicInfo.wMagicId of
          SKILL_77: begin //˫����{��}
              MagicManager.MagMakeSkillFire_77(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_80: begin //�����{��}
              MagicManager.MagMakeSkillFire_80(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_83: begin //���ױ�{��}
              MagicManager.MagMakeSkillFire_83(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_86: begin //����ѩ��{��}
              MagicManager.MagMakeSkillFire_86(self, UserMagic, m_nTargetX, m_nTargetY,StormsHit);
            end;
          SKILL_78: begin //��Х��{��}
              MagicManager.MagMakeSkillFire_78(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_81: begin //������{��}
              MagicManager.MagMakeSkillFire_81(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_84: begin //������{��}
              MagicManager.MagMakeSkillFire_84(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit);
            end;
          SKILL_87: begin //�򽣹���{��}
              MagicManager.MagMakeSkillFire_87(self, UserMagic, m_nTargetX, m_nTargetY,StormsHit);
            end;
        end;//Case
        nCode:= 12;
        SendRefMsg(RM_MAGICFIRE, 0,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                                MakeLong(m_nTargetX, m_nTargetY),Integer(m_TargetCret),'');
      end else begin//ս
        nCode:= 18;
        case UserMagic.MagicInfo.wMagicId of
          SKILL_79: BatterAttackDir(m_TargetCret{nil}, 14, StormsHit);//׷�Ĵ� 20091029
          SKILL_76: BatterAttackDir(m_TargetCret{nil}, 15, StormsHit);//����ɱ 20091029
          SKILL_82: BatterAttackDir(m_TargetCret{nil}, 17, StormsHit);//����ն 20091029
          SKILL_85: BatterAttackDir(m_TargetCret{nil}, 16, StormsHit);//��ɨǧ�� 20091029
        end;
      end;
    end else begin
      nCode:= 19;
      m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
      m_nBatterMagIdx1:= 0;//��������ID1 20090701
      m_nBatterMagIdx2:= 0;//��������ID2 20090701
      m_nBatterMagIdx3:= 0;//��������ID3 20090701
      m_nBatterMagIdx4:= 0;//��������ID4
      if (m_btJob = 0) then begin
        m_boUseBatter:= False;
        m_boWarUseBatter:= False;
        m_dwLatestWarUseBatterTick:= GetTickCount();
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.UseBatterSpell Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//ս��������
procedure TAIPlayObject.BatterAttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word; StormsHit{������}: Byte);
  function MPow(UserMagic: pTUserMagic): Integer;//���㼼������
  var nPower:Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
      nPower := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else nPower := UserMagic.MagicInfo.wPower;
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
      Result :=Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result :=Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
  function DirectAttack(BaseObject: TBaseObject; nSecPwr: Integer; boStorm: Boolean): Boolean;//������ɫ
  begin
    Result := False;
    if BaseObject <> nil then begin
      if (Random(BaseObject.m_btSpeedPoint) <= (m_btHitPoint + 10)) or boStorm then begin
        BaseObject.StruckDamage(nSecPwr);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10102, nSecPwr, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '', 500);
        if (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) and (BaseObject.m_btRaceServer <> RC_HEROOBJECT) then begin
          BaseObject.SendMsg(BaseObject, RM_STRUCK, nSecPwr, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '');
        end;
        Result := True;
      end;
    end;
  end;
  function Attack_79(nSecPwr, nMagicLevel: Integer; nDir: Byte): Boolean;//׷�Ĵ�
    function CanMotaebo1(BaseObject: TBaseObject; nMagicLevel: Integer): Boolean;
    var
      nC: Integer;
    begin
      Result := False;
      if (m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
        nC := m_Abil.Level - BaseObject.m_Abil.Level;
        if Random(20) < ((nMagicLevel * 4) + 6 + nC) then begin
          Result := True;
        end;
      end;
    end;
    function CharPushed_79(Target: TBaseObject; nDir, nPushCount: Integer): Integer;
    var
      I, nX, nY, olddir, nBackDir: Integer;
    begin
      Result := 0;
      olddir := Target.m_btDirection;
      Target.m_btDirection := nDir;
      nBackDir := GetBackDir(nDir);
      if nPushCount > 0 then begin
        for I := 0 to nPushCount - 1 do begin
          Target.GetFrontPosition(nX, nY);
          if Target.m_PEnvir.CanWalk(nX, nY, False) then begin
            if Target.m_PEnvir.MoveToMovingObject(Target.m_nCurrX, Target.m_nCurrY, Target, nX, nY, False) > 0 then begin
              Target.m_nCurrX := nX;
              Target.m_nCurrY := nY;
              Inc(Result);
            end else Break;
          end else Break;
        end;//for
        if Result > 0 then begin
          Target.SendRefMsg(RM_PUSH, nBackDir, Target.m_nCurrX, Target.m_nCurrY, 0, '');
          if Target.m_btRaceServer >= RC_ANIMAL then Target.m_dwWalkTick := Target.m_dwWalkTick + 800;
        end;
      end;
      Target.m_btDirection := nBackDir;
      if Result = 0 then Target.m_btDirection := olddir;
    end;
  var
    bo34: Boolean;
    I, n20, n24, K, nX, nY: Integer;
    PoseCreate, BaseObject_30, BaseObject_34: TBaseObject;
  begin
    Result := False;
    try
      SendRefMsg(RM_BATTERHIT1,  m_btDirection, m_nCurrX, m_nCurrY, 0, ''); //׷�Ĵ�
      bo34 := True;
      m_btDirection := nDir;
      BaseObject_34 := nil;
      n24 := 0;
      PoseCreate := GetPoseCreate();//ȡ����Ľ�ɫ
      if PoseCreate = nil then begin//����û�ж�����ȡ����λ�õĶ���
        if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
          PoseCreate := m_PEnvir.GetMovingObject(nX, nY, True);
        end;
      end;
      if PoseCreate <> nil then begin
        if IsProperTarget(PoseCreate) then begin
          BaseObject_34 := PoseCreate;
          if CanMotaebo1(PoseCreate, nMagicLevel) then begin
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
              BaseObject_30 := m_PEnvir.GetMovingObject(nX, nY, True);
              if (BaseObject_30 <> nil) then bo34:= False;//������������ײ
            end;
            if bo34 then begin
              K:= CharPushed_79(PoseCreate, m_btDirection, _MAX(3, nMagicLevel + 2));
              for I := 0 to K - 1 do begin
                if PoseCreate <> nil then begin
                  GetFrontPosition(nX, nY);
                  if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
                    m_nCurrX := nX;
                    m_nCurrY := nY;
                    SendRefMsg(RM_RUSH79, nDir, m_nCurrX, m_nCurrY, 0, '');
                  end else Break;
                  Inc(n24);
                end else Break; //if PoseCreate <> nil  then begin
              end; //for i:=0 to K do begin
            end;
          end;
        end;
      end;
      if (BaseObject_34 <> nil) then begin//Ŀ���Ѫ
        if n24 < 0 then n24 := 0;
        if n24 > 3 then n24 := 3;
        n20 := Random((n24 + 1) * 5) + nSecPwr;
        n20 := BaseObject_34.GetHitStruckDamage(Self, n20);
        BaseObject_34.StruckDamage(n20);
        BaseObject_34.SendRefMsg(RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
        if BaseObject_34.m_btRaceServer <> RC_PLAYOBJECT then begin
          BaseObject_34.SendMsg(BaseObject_34, RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
        end;
        BaseObject_34.m_wStatusTimeArr[POISON_DONTMOVE] := 1;//������,�����ƶ�
        BaseObject_34.m_dwStatusArrTick[POISON_DONTMOVE] := GetTickCount();
        Result := True;
      end;
    except
    end;
  end;
  function Attack_85(nSecPwr: Integer; boStorm: Boolean): Boolean;//��ɨǧ��
  var
    BaseObjectList: TList;
    TargeTBaseObject: TBaseObject;
    I,nPower: Integer;
  begin
    Result := False;
    BaseObjectList := TList.Create;
    try
      m_PEnvir.GetMapBaseObjects(m_nCurrX, m_nCurrY, g_Config.nBatterSkillFireRange_85, BaseObjectList);
      if BaseObjectList.Count > 0 then begin
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin
            if IsProperTarget(TargeTBaseObject) and (TargeTBaseObject.m_btRaceServer <> 79) then begin //�Ƿ����ʵ���Ŀ��
              nPower := TargeTBaseObject.GetHitStruckDamage(Self, nSecPwr);
              Result := DirectAttack(TargeTBaseObject, nPower, boStorm);
              if (TargeTBaseObject <> nil) and Result then begin
                TargeTBaseObject.m_wStatusTimeArr[POISON_DONTMOVE] := 1;//������,�����ƶ�
                TargeTBaseObject.m_dwStatusArrTick[POISON_DONTMOVE] := GetTickCount();
              end;
            end;
          end;
        end;//for
      end;
    finally
      BaseObjectList.Free;
    end;
  end;
  function Attack_82(nSecPwr: Integer; boStorm: Boolean): Boolean;//����ն
  var
    I, nPower: Integer;
    BaseObjectList: TList;
    TargeTBaseObject: TBaseObject;
  begin
    Result := False;
    BaseObjectList := TList.Create;
    try
      GetDirectionBaseObjects(m_btDirection, g_Config.nBatterSkillFireRange_82{3}, BaseObjectList);//ͬ������Ĺ� 3��
      if BaseObjectList.Count > 0 then begin
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin
            if IsProperTarget(TargeTBaseObject) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
              nPower := TargeTBaseObject.GetHitStruckDamage(Self, nSecPwr);
              Result := DirectAttack(TargeTBaseObject, nPower, boStorm);
              if (TargeTBaseObject <> nil) and Result then begin
                TargeTBaseObject.m_wStatusTimeArr[POISON_DONTMOVE] := 1;//������,�����ƶ�
                TargeTBaseObject.m_dwStatusArrTick[POISON_DONTMOVE] := GetTickCount();
              end;
            end;
          end;
        end;
      end;
    finally
      BaseObjectList.Free;
    end;
  end;  
  function _BatterAttack(var wHitMode: Word; AttackTarget: TBaseObject; StormsHitRate: Byte): Boolean;
  var
    nPower, nWeaponDamage, n20: Integer;
    nCode: Byte;
    boBatterStorm: Boolean;//�Ƿ񱩻� 20090903
  begin
    Result := False;
    boBatterStorm := False;//�Ƿ񱩻� 20090903
    nWeaponDamage := 0;
    nPower :=0;
    nCode :=0;
    try
      Case wHitMode of //���㼼������
        14: begin//׷�Ĵ�
          if m_Magic79Skill <> nil then nPower := GetAttackPower(MPow(m_Magic79Skill) + LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));//׷�Ĵ�
          if (m_Magic79Skill <> nil) and (m_Magic79Skill.btLevel > 0) and (m_Magic79Skill.btLevel < 6) then begin
            Randomize(); //�������
            if Random(100) <= (m_wHumanPulseArr[1].nStormsHit + StormsHitRate) then begin
              nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[m_Magic79Skill.btLevel] / 100));
              SendRefMsg(RM_10205, 14, 0, 0, 0, '');//������Ч
              boBatterStorm := True;//�Ƿ񱩻�
            end;
          end;
          nPower:= nPower + m_wStatusArrValue[15];//�����˺�����
          nCode :=2;
          if IsProperTarget(AttackTarget) and (AttackTarget.m_btRaceServer <> 79) then begin
            if (Random(AttackTarget.m_btSpeedPoint) >= m_btHitPoint) and (not boBatterStorm) then nPower := 0;
          end else nPower := 0;
          nCode :=3;
          if nPower > 0 then begin
            nCode :=4;
            nPower := AttackTarget.GetHitStruckDamage(Self, nPower);
            if m_nHongMoSuite > 0 then begin//��ħ����Ѫ
              m_db3B0 := nPower / 1.E2 * m_nHongMoSuite;
              if m_db3B0 >= 2.0 then begin
                n20 := Trunc(m_db3B0);
                m_db3B0 := n20;
                DamageHealth(-n20);
              end;
            end;
            {$IF M2Version = 1}
            if (nPower > 0) then begin//����װ����Ѫ
              if (m_nVampirePoint > 0) and ((m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_HEROOBJECT)) then begin
                if Random(100) <= m_nVampireRate then begin
                  n20:= 0;
                  n20 := Random(m_nVampirePoint);
                  if n20 > 0 then DamageHealth(-n20);
                end;
              end;
            end;
            {$IFEND}
          end;
          if (m_Magic79Skill <> nil) then begin //׷�Ĵ�
            Attack_79(nPower, m_Magic79Skill.btLevel, m_btDirection);
          end;
          Result := True;
        end;//14
        15: begin//����ɱ
          if m_Magic76Skill <> nil then nPower := GetAttackPower(MPow(m_Magic76Skill) + LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));//����ɱ
          if (m_Magic76Skill <> nil) and (m_Magic76Skill.btLevel > 0) and (m_Magic76Skill.btLevel < 6) then begin
            Randomize(); //�������
            if Random(100) <= (m_wHumanPulseArr[0].nStormsHit + StormsHitRate) then begin
              nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[m_Magic76Skill.btLevel] / 100));
              SendRefMsg(RM_10205, 14, 0, 0, 0, '');////������Ч
              boBatterStorm := True;//�Ƿ񱩻�
            end;
          end;
          nPower:= nPower + m_wStatusArrValue[15];//�����˺�����
          nCode :=8;
          if IsProperTarget(AttackTarget) and (AttackTarget.m_btRaceServer <> 79) then begin
            if (Random(AttackTarget.m_btSpeedPoint) >= m_btHitPoint) and (not boBatterStorm) then nPower := 0;
          end else nPower := 0;
          nCode :=9;
          if (nPower > 0) and (AttackTarget <> nil) then begin
            nPower := AttackTarget.GetHitStruckDamage(Self, nPower);
            if m_nHongMoSuite > 0 then begin//��ħ����Ѫ
              m_db3B0 := nPower / 1.E2 * m_nHongMoSuite;
              if m_db3B0 >= 2.0 then begin
                n20 := Trunc(m_db3B0);
                m_db3B0 := n20;
                DamageHealth(-n20);
              end;
            end;
            {$IF M2Version = 1}
            if (nPower > 0) then begin//����װ����Ѫ
              if (m_nVampirePoint > 0) and ((m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_HEROOBJECT)) then begin
                if Random(100) <= m_nVampireRate then begin
                  n20:= 0;
                  n20 := Random(m_nVampirePoint);
                  if n20 > 0 then DamageHealth(-n20);
                end;
              end;
            end;
            {$IFEND}
            nCode :=10;
            DirectAttack(AttackTarget, nPower, boBatterStorm);
            if AttackTarget <> nil then begin
              AttackTarget.m_wStatusTimeArr[POISON_DONTMOVE] := 1;//������,�����ƶ�
              AttackTarget.m_dwStatusArrTick[POISON_DONTMOVE] := GetTickCount();
            end;
          end;
          Result := True;
        end;//15
        16: begin//��ɨǧ��
          if m_Magic85Skill <> nil then nPower := GetAttackPower(MPow(m_Magic85Skill) + LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));//��ɨǧ��
          if (m_Magic85Skill <> nil) and (m_Magic85Skill.btLevel > 0) and (m_Magic85Skill.btLevel < 6) then begin
            Randomize(); //�������
            if Random(100) <= (m_wHumanPulseArr[3].nStormsHit + StormsHitRate) then begin
              nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[m_Magic85Skill.btLevel] / 100));
              SendRefMsg(RM_10205, 14, 0, 0, 0, '');////������Ч
              boBatterStorm := True;//�Ƿ񱩻�
            end;
          end;
          nPower:= nPower + m_wStatusArrValue[15];//�����˺�����
          nCode :=13;
          if Attack_85(nPower, boBatterStorm) then begin
            if m_nHongMoSuite > 0 then begin//��ħ����Ѫ
              m_db3B0 := nPower / 1.E2 * m_nHongMoSuite;
              if m_db3B0 >= 2.0 then begin
                n20 := Trunc(m_db3B0);
                m_db3B0 := n20;
                DamageHealth(-n20);
              end;
            end;
            {$IF M2Version = 1}
            if (nPower > 0) then begin//����װ����Ѫ
              if (m_nVampirePoint > 0) and ((m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_HEROOBJECT)) then begin
                if Random(100) <= m_nVampireRate then begin
                  n20:= 0;
                  n20 := Random(m_nVampirePoint);
                  if n20 > 0 then DamageHealth(-n20);
                end;
              end;
            end;
            {$IFEND}
          end;
          Result := True;
        end;//16
        17: begin//����ն
          if m_Magic82Skill <> nil then nPower := GetAttackPower(MPow(m_Magic82Skill) + LoWord(m_WAbil.DC), SmallInt((HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))));//����ն
          if (m_Magic82Skill <> nil) and (m_Magic82Skill.btLevel > 0) and (m_Magic82Skill.btLevel < 6) then begin
            Randomize(); //�������
            if Random(100) <= (m_wHumanPulseArr[2].nStormsHit + StormsHitRate) then begin
              nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[m_Magic82Skill.btLevel] / 100));
              SendRefMsg(RM_10205, 14, 0, 0, 0, '');////������Ч
              boBatterStorm := True;//�Ƿ񱩻�
            end;
          end;
          nPower:= nPower + m_wStatusArrValue[15];//�����˺�����
          nCode :=16;
          if Attack_82(nPower, boBatterStorm) then begin
            if m_nHongMoSuite > 0 then begin//��ħ����Ѫ
              m_db3B0 := nPower / 1.E2 * m_nHongMoSuite;
              if m_db3B0 >= 2.0 then begin
                n20 := Trunc(m_db3B0);
                m_db3B0 := n20;
                DamageHealth(-n20);
              end;
            end;
            {$IF M2Version = 1}
            if (nPower > 0) then begin//����װ����Ѫ
              if (m_nVampirePoint > 0) and ((m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_HEROOBJECT)) then begin
                if Random(100) <= m_nVampireRate then begin
                  n20:= 0;
                  n20 := Random(m_nVampirePoint);
                  if n20 > 0 then DamageHealth(-n20);
                end;
              end;
            end;
            {$IFEND}
          end;
          Result := True;
        end;//17
      end;
    except
      on E: Exception do begin
        MainOutMessage(Format('{%s} TAIPlayObject._BatterAttack Code:%d',[g_sExceptionVer, nCode]));
      end;  
    end;
  end;
var
  AttackTarget: TBaseObject;
  nX, nY: integer;
  nCode: Byte;
begin
  nCode:= 0;
  if m_boDeath or m_boGhost then Exit;
  try
    if TargeTBaseObject = nil then begin
      nCode:= 1;
      AttackTarget := GetPoseCreate();
      nCode:= 2;
      if (AttackTarget = nil) and ((wHitMode = 15) or (wHitMode =16) or (wHitMode =17)) then begin//ȡ����λ�õ�Ŀ��
        nCode:= 3;
        if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
          nCode:= 4;
          AttackTarget := m_PEnvir.GetMovingObject(nX, nY, True);
        end;
      end;
    end else AttackTarget := TargeTBaseObject;
    nCode:= 5;
    if AttackTarget <> nil then GetAttackDir(AttackTarget, m_btDirection);//ȡ�����ķ��� 20091029
    nCode:= 6;
    if _BatterAttack(wHitMode, AttackTarget, StormsHit) then begin//����Ŀ���Ѫ�Լ�������������
      nCode:= 7;
      if AttackTarget <> nil then SetTargetCreat(AttackTarget);
    end;
    nCode:= 8;
    case wHitMode of                               
      15: SendAttackMsg(RM_BATTERHIT2, m_btDirection, 0, m_nCurrX, m_nCurrY);//����ɱ
      16: SendAttackMsg(RM_BATTERHIT3, m_btDirection, 0, m_nCurrX, m_nCurrY);//��ɨǧ��
      17: SendAttackMsg(RM_BATTERHIT4, m_btDirection, 0, m_nCurrX, m_nCurrY);//����ն
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TAIPlayObject.BatterAttackDir Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
end;
{$IFEND}
procedure TAIPlayObject.Start(PathType: TPathType);
begin
  if (not m_boGhost) and (not m_boDeath) and (not m_boAIStart) then begin
    m_ManagedEnvir := m_PEnvir;
    m_nProtectTargetX:= m_nCurrX;//�ػ�����
    m_nProtectTargetY:= m_nCurrY;//�ػ�����
    m_boProtectOK:= False;
    m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ���
    m_PointManager.PathType := PathType;
    m_PointManager.Initialize(m_PEnvir);
    m_boAIStart := True;
    m_nMoveFailCount := 0;
    if g_FunctionNPC <> nil then begin
      m_nScriptGotoCount := 0;
      g_FunctionNPC.GotoLable(Self, '@AIStart', False, False);
    end;
  end;
end;

procedure TAIPlayObject.Stop;
begin
  if m_boAIStart then begin
    m_boAIStart := False;
    m_nMoveFailCount := 0;
    m_Path := nil;
    m_nPostion := -1;
    if g_FunctionNPC <> nil then begin
      m_nScriptGotoCount := 0;
      g_FunctionNPC.GotoLable(Self, '@AIStop', False, False);
    end;
  end;
end;

procedure TAIPlayObject.MakeGhost;
begin
  if m_boAIStart then begin
    m_boAIStart := False;
  end;
  inherited;
end;

procedure TAIPlayObject.Whisper(whostr, saystr: string);
var
  PlayObject: TPlayObject;
begin
  PlayObject := UserEngine.GetPlayObject(whostr);
  if PlayObject <> nil then begin
    if not PlayObject.m_boReadyRun then Exit;
    if not PlayObject.m_boHearWhisper or PlayObject.IsBlockWhisper(m_sCharName) then Exit;
    if m_btPermission > 0 then begin
      PlayObject.SendMsg(PlayObject, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, Format('%s[%d��]=> %s', [m_sCharName, m_Abil.Level ,saystr]));
      //ȡ��˽����Ϣ
      //m_GetWhisperHuman ����˽�Ķ���
      if (m_GetWhisperHuman <> nil) and (not m_GetWhisperHuman.m_boGhost) then
        m_GetWhisperHuman.SendMsg(m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, Format('%s[%d��]=> %s %s', [m_sCharName, m_Abil.Level, PlayObject.m_sCharName, saystr]));
      if (PlayObject.m_GetWhisperHuman <> nil) and (not PlayObject.m_GetWhisperHuman.m_boGhost) then
        PlayObject.m_GetWhisperHuman.SendMsg(PlayObject.m_GetWhisperHuman, RM_WHISPER, 0, g_Config.btGMWhisperMsgFColor, g_Config.btGMWhisperMsgBColor, 0, Format('%s[%d��]=> %s %s', [m_sCharName, m_Abil.Level, PlayObject.m_sCharName, saystr]));
    end else begin
      PlayObject.SendMsg(PlayObject, RM_WHISPER, 0, {g_Config.btWhisperMsgFColor} m_btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, Format('%s[%d��]=> %s', [m_sCharName, m_Abil.Level, saystr]));
      if (m_GetWhisperHuman <> nil) and (not m_GetWhisperHuman.m_boGhost) then
        m_GetWhisperHuman.SendMsg(m_GetWhisperHuman, RM_WHISPER, 0, {g_Config.btWhisperMsgFColor} m_btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, Format('%s[%d��]=> %s %s', [m_sCharName, m_Abil.Level, PlayObject.m_sCharName, saystr]));

      if (PlayObject.m_GetWhisperHuman <> nil) and (not PlayObject.m_GetWhisperHuman.m_boGhost) then
        PlayObject.m_GetWhisperHuman.SendMsg(PlayObject.m_GetWhisperHuman, RM_WHISPER, 0, {g_Config.btWhisperMsgFColor} m_btWhisperMsgFColor, g_Config.btWhisperMsgBColor, 0, Format('%s[%d��]=> %s %s', [m_sCharName, m_Abil.Level, PlayObject.m_sCharName, saystr]));
    end;
  end;
end;

procedure TAIPlayObject.ProcessSayMsg(sData: string);
var
  boDisableSayMsg: Boolean;
  SC, sCryCryMsg, sParam1: string;
const
  s01 = '%d %d';
  s02 = '%s %d/%d';
resourcestring
  sExceptionMsg = '{%s} TAIPlayObject.ProcessSayMsg Msg:%s';
begin
  if sData = '' then Exit;
  try
    if Length(sData) > g_Config.nSayMsgMaxLen then begin
      sData := Copy(sData, 1, g_Config.nSayMsgMaxLen);
    end;

    if GetTickCount >= m_dwDisableSayMsgTick then m_boDisableSayMsg := False;
    boDisableSayMsg := m_boDisableSayMsg;
    g_DenySayMsgList.Lock;
    try
      if g_DenySayMsgList.GetIndex(m_sCharName) >= 0 then boDisableSayMsg := True;
    finally
      g_DenySayMsgList.UnLock;
    end;

    if not boDisableSayMsg then begin
      if sData[1] = '/' then begin
        SC := Copy(sData, 2, Length(sData) - 1);
        SC := GetValidStr3(SC, sParam1, [' ']);
        if not m_boFilterSendMsg then Whisper(sParam1, SC);
        Exit;
      end;

      if sData[1] = '!' then begin
        if Length(sData) >= 2 then begin
          if sData[2] = '!' then begin
            SC := Copy(sData, 3, Length(sData) - 2);
            SendGroupText(m_sCharName + ': ' + SC);
            Exit;
          end;
          if sData[2] = '~' then begin
            if m_MyGuild <> nil then begin
              SC := Copy(sData, 3, Length(sData) - 2);
              TGUild(m_MyGuild).SendGuildMsg(m_sCharName + ': ' + SC);
            end;
            Exit;
          end;
        end;

        if not m_PEnvir.m_boQUIZ then begin
          if (GetTickCount - m_dwShoutMsgTick) > 10 * 1000 then begin
            if m_Abil.Level <= g_Config.nCanShoutMsgLevel then begin
              SysMsg(Format(g_sYouNeedLevelMsg, [g_Config.nCanShoutMsgLevel + 1]), c_Red, t_Hint);
              Exit;
            end;
            m_dwShoutMsgTick := GetTickCount();
            SC := Copy(sData, 2, Length(sData) - 1);
            sCryCryMsg := '(!)' + m_sCharName + ': ' + SC;
            if m_boFilterSendMsg then begin
              SendMsg(nil, RM_CRY, 0, 0, $FFFF, 0, sCryCryMsg);
            end else begin
              UserEngine.CryCry(RM_CRY, m_PEnvir, m_nCurrX, m_nCurrY, 50, g_Config.btCryMsgFColor, g_Config.btCryMsgBColor, sCryCryMsg);
            end;
            Exit;
          end;
          SysMsg(Format(g_sYouCanSendCyCyLaterMsg, [10 - (GetTickCount - m_dwShoutMsgTick) div 1000]), c_Red, t_Hint);
          Exit;
        end;
        SysMsg(g_sThisMapDisableSendCyCyMsg {'����ͼ��������������'}, c_Red, t_Hint);
        Exit;
      end;

      if not m_boFilterSendMsg then begin //�����ֹ����Ϣ����ֻ���Լ�����Ϣ
        SendRefMsg(RM_HEAR, 0, m_btHearMsgFColor, g_Config.btHearMsgBColor, 0, m_sCharName + ':' + sData);
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, sData]));
    end;
  end;
end;

function TAIPlayObject.FindMagic(wMagIdx: Word): pTUserMagic;
var
  UserMagic: pTUserMagic;
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[I];
    if UserMagic.MagicInfo.wMagicId = wMagIdx then begin
      Result := UserMagic;
      Break;
    end;
  end;
end;

function TAIPlayObject.FindMagic(sMagicName: string): pTUserMagic;
var
  UserMagic: pTUserMagic;
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_MagicList.Count - 1 do begin
    UserMagic := m_MagicList.Items[I];
    if CompareText(UserMagic.MagicInfo.sMagicName, sMagicName) = 0 then begin
      Result := UserMagic;
      Break;
    end;
  end;
end;

function TAIPlayObject.RunToNext(nX, nY: Integer): Boolean;
begin
  if GetTickCount()- dwTick5F4 > g_Config.nAIRunIntervalTime then begin
    Result := RunTo1(GetNextDirection(m_nCurrX, m_nCurrY, nX, nY), False, nX, nY);
    {if Result then }dwTick5F4 := GetTickCount();//20110625 ע��
    m_dwStationTick := GetTickCount; //���Ӽ������վ��ʱ��
  end;
end;

function TAIPlayObject.WalkToNext(nX, nY: Integer): Boolean;
begin
  if GetTickCount()- dwTick3F4 > g_Config.nAIWalkIntervalTime then begin
    Result := WalkTo(GetNextDirection(m_nCurrX, m_nCurrY, nX, nY), False);
    if Result then dwTick3F4 := GetTickCount();
    m_dwStationTick := GetTickCount; //���Ӽ������վ��ʱ��
  end;
end;

function TAIPlayObject.GotoNextOne(nX, nY: Integer; boRun: Boolean): Boolean;
var
  I: Integer;
  //Path: TPath;
begin
  Result := False;
  if (abs(nX - m_nCurrX) <= 2) and (abs(nY - m_nCurrY) <= 2) then begin
    if (abs(nX - m_nCurrX) <= 1) and (abs(nY - m_nCurrY) <= 1) then begin
      Result := WalkToNext(nX, nY);
    end else begin
      Result := RunToNext(nX, nY);
    end;
  end;
  {if not Result then begin//20110529 ע�ͣ�ռ����CPU
    Path := g_FindPath.FindPath(m_PEnvir, m_nCurrX, m_nCurrY, nX, nY, boRun);
    if Length(Path) > 0 then begin
      for I := 0 to Length(Path) - 1 do begin
        if (Path[I].X <> m_nCurrX) or (Path[I].Y <> m_nCurrY) then begin
          if (abs(Path[I].X - m_nCurrX) >= 2) or (abs(Path[I].Y - m_nCurrY) >= 2) then begin
            Result := RunToNext(Path[I].X, Path[I].Y);
          end else begin
            Result := WalkToNext(Path[I].X, Path[I].Y);
          end;
          break;
        end;
      end;
      Path := nil;
    end;
  end;   }
  m_RunPos.nAttackCount := 0;
end;

procedure TAIPlayObject.Hear(nIndex: Integer; sMsg: string);
var
  nPos: Integer;
  boDisableSayMsg: Boolean;
  sChrName, sSendMsg: string;
begin
  case nIndex of
    RM_HEAR:;
    RM_WHISPER: begin
        if GetTickCount >= m_dwDisableSayMsgTick then m_boDisableSayMsg := False;
        boDisableSayMsg := m_boDisableSayMsg;
        g_DenySayMsgList.Lock;
        try
          if g_DenySayMsgList.GetIndex(m_sCharName) >= 0 then boDisableSayMsg := True;
        finally
          g_DenySayMsgList.UnLock;
        end;
        if not boDisableSayMsg then begin
          nPos := Pos('=>', sMsg);
          if (nPos > 0) and (m_AISayMsgList.Count > 0) then begin
            sChrName := Copy(sMsg, 1, nPos - 1);
            sSendMsg := Copy(sMsg, nPos + 3, Length(sMsg) - nPos - 2);
            Whisper(sChrName, m_AISayMsgList.Strings[Random(m_AISayMsgList.Count)]);
          end;
        end;
      end;
    RM_CRY: ;
    RM_SYSMESSAGE: ;
    RM_MOVEMESSAGE: ;
    RM_GROUPMESSAGE: ;
    RM_GUILDMESSAGE: ;
    RM_DIVISIONMESSAGE:;
    RM_MERCHANTSAY: ;
    RM_PLAYDRINKSAY: ;
    RM_MOVEMESSAGE1: ;
  end;
end;
//ȡ�������
function TAIPlayObject.GetRandomConfigFileName(sName: String;nType: Byte): string;
var
  nIndex: Integer;
  sFileName, Str: string;
  LoadList: TStringList;
begin
  Result := '';
  if not DirectoryExists(m_sFilePath+'RobotIni') then CreateDir(m_sFilePath+'RobotIni');
  sFileName:= m_sFilePath+'RobotIni\'+sName+'.txt';
  if FileExists(sFileName) then begin
    Result := sFileName;
    Exit;
  end;
  case nType of
    0: begin
      if (m_sConfigListFileName <> '') and FileExists(m_sConfigListFileName) then begin
        LoadList := TStringList.Create;
        try
          try
            LoadList.LoadFromFile(m_sConfigListFileName);
          except
          end;
          nIndex := Random(LoadList.Count);
          if (nIndex >= 0) and (nIndex < LoadList.Count) then begin
            Str:= LoadList.Strings[nIndex];
            if Str <> '' then begin
              if Str[1] = '\' then Str := Copy(Str, 2, Length(Str) - 1);
              if Str[2] = '\' then Str := Copy(Str, 3, Length(Str) - 2);
              if Str[3] = '\' then Str := Copy(Str, 4, Length(Str) - 3);
            end;
            Result := m_sFilePath + Str;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
    1: begin
      if (m_sHeroConfigListFileName <> '') and FileExists(m_sHeroConfigListFileName) then begin
        LoadList := TStringList.Create;
        try
          try
            LoadList.LoadFromFile(m_sHeroConfigListFileName);
          except
          end;
          nIndex := Random(LoadList.Count);
          if (nIndex >= 0) and (nIndex < LoadList.Count) then begin
            Str:= LoadList.Strings[nIndex];
            if Str <> '' then begin
              if Str[1] = '\' then Str := Copy(Str, 2, Length(Str) - 1);
              if Str[2] = '\' then Str := Copy(Str, 3, Length(Str) - 2);
              if Str[3] = '\' then Str := Copy(Str, 4, Length(Str) - 3);
            end;
            Result := m_sFilePath + Str;
          end;
        finally
          LoadList.Free;
        end;
      end;
    end;
  end;
end;

procedure TAIPlayObject.Initialize;
var
  I, nAttatckMode: Integer;
  sFileName, sLineText, sMagicName, sItemName, sSayMsg: string;
  ItemIni: TIniFile;
  TempList: TStringList;
  UserItem: pTUserItem;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  StdItem: pTStdItem;
begin
  m_sHeroCharName := GetAIHeroName(m_sCharName);
  m_boHasHero := m_sHeroCharName <> '';

  sFileName := GetRandomConfigFileName(m_sCharName, 0);
  if (sFileName = '') or (not FileExists(sFileName)) then begin
    if (m_sConfigFileName <> '') and FileExists(m_sConfigFileName) then begin
      sFileName := m_sConfigFileName;
    end;
  end;

  if (sFileName <> '') and FileExists(sFileName) then begin
    ItemIni := TIniFile.Create(sFileName);
    if ItemIni <> nil then begin
      m_boNoDropItem := ItemIni.ReadBool('Info', 'NoDropItem', True);//�Ƿ��������Ʒ
      m_boNoDropUseItem := ItemIni.ReadBool('Info', 'DropUseItem', True);//�Ƿ��װ��
      m_nDropUseItemRate := ItemIni.ReadInteger('Info', 'DropUseItemRate', 100);//��װ������
      m_btJob := ItemIni.ReadInteger('Info', 'Job', 0);
      m_btGender := ItemIni.ReadInteger('Info', 'Gender', 0);
      m_btHair := ItemIni.ReadInteger('Info', 'Hair', 0);
      m_Abil.Level := ItemIni.ReadInteger('Info', 'Level', 1);
      m_Abil.nMaxExp := GetLevelExp(m_Abil.Level);
      m_boTrainingNG:= ItemIni.ReadBool('Info', 'NG', False);//�Ƿ�ѧϰ���ڹ�
      if m_boTrainingNG then begin
        m_NGLevel:= ItemIni.ReadInteger('Info', 'NGLevel', 1);//�ڹ��ȼ�
        GetSkill69Exp(m_NGLevel, m_Skill69MaxNH);//��������ֵ����
        m_Skill69NH:= m_Skill69MaxNH;
      end;
      m_boProtectStatus:= ItemIni.ReadBool('Info','ProtectStatus',False);//�Ƿ��ػ�ģʽ
      nAttatckMode:= ItemIni.ReadInteger('Info','AttatckMode', 6);//����ģʽ
      if nAttatckMode in [0..6] then m_btAttatckMode:= nAttatckMode;

      sLineText := ItemIni.ReadString('Info', 'UseSkill', '');
      if sLineText <> '' then begin
        TempList := TStringList.Create;
        try
          ExtractStrings(['|', '\', '/', ','], [], PChar(sLineText), TempList);
          for I := 0 to TempList.Count - 1 do begin
            sMagicName := Trim(TempList.Strings[I]);
            if FindMagic(sMagicName) = nil then begin
              Magic := UserEngine.FindMagic(sMagicName);
              if Magic <> nil then begin
                if (Magic.btJob = 99) or (Magic.btJob = m_btJob) then begin
                  if Magic.wMagicId = SKILL_75 then begin//�������
                    m_boProtectionDefence:= True;
                    Continue;//����
                  end;
                  New(UserMagic);
                  UserMagic.MagicInfo := Magic;
                  UserMagic.wMagIdx := Magic.wMagicId;
                  UserMagic.btLevel := 3;
                  UserMagic.btKey := 0;
                  UserMagic.nTranPoint := Magic.MaxTrain[3];
                  m_MagicList.Add(UserMagic);
                  {$IF M2Version = 1}
                  if m_boTrainingNG then begin
                    if (UserMagic.MagicInfo.wMagicId > SKILL_75) and (UserMagic.MagicInfo.wMagicId < SKILL_88) then begin//�������ܲŴ���
                      m_BatterMagicList.Add(UserMagic);
                    end;
                  end;
                  {$IFEND}
                end;
              end;
            end;
          end;
        finally
          TempList.Free;
        end;
        {$IF M2Version = 1}
        if m_BatterMagicList.Count > 0 then begin
          m_boTrainBatterSkill:= True;
          m_SetBatterKey:= 1;
          m_SetBatterKey1:= 1;
          m_SetBatterKey2:= 1;
        end;
        {$IFEND}
      end;
      sLineText := ItemIni.ReadString('Info', 'InitItems', '');
      if sLineText <> '' then begin
        TempList := TStringList.Create;
        try
          ExtractStrings(['|', '\', '/', ','], [], PChar(sLineText), TempList);
          for I := 0 to TempList.Count - 1 do begin
            sItemName := Trim(TempList.Strings[I]);
            StdItem := UserEngine.GetStdItem(sItemName);
            if StdItem <> nil then begin
              New(UserItem);
              if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
                if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
                  if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                    UserEngine.GetUnknowItemValue(UserItem);
                  end;
                end;
                if not AddItemToBag(UserItem) then begin
                  Dispose(UserItem);
                  break;
                end;
                m_BagItemNames.Add(StdItem.Name);
              end else Dispose(UserItem);
            end;
          end;
        finally
          TempList.Free;
        end;
      end;
      for I := 0 to 9 do begin
        sSayMsg:= ItemIni.ReadString('MonSay', IntToStr(I), '');
        if sSayMsg <> '' then m_AISayMsgList.Add(sSayMsg)
        else Break;
      end;
      m_UseItemNames[U_DRESS] := ItemIni.ReadString('UseItems', 'UseItems0'{'DRESSNAME'}, ''); // '�·�';
      m_UseItemNames[U_WEAPON] := ItemIni.ReadString('UseItems', 'UseItems1'{'WEAPONNAME'}, ''); // '����';
      m_UseItemNames[U_RIGHTHAND] := ItemIni.ReadString('UseItems', 'UseItems2'{'RIGHTHANDNAME'}, ''); // '������';
      m_UseItemNames[U_NECKLACE] := ItemIni.ReadString('UseItems', 'UseItems3'{'NECKLACENAME'}, ''); // '����';
      m_UseItemNames[U_HELMET] := ItemIni.ReadString('UseItems', 'UseItems4'{'HELMETNAME'}, ''); // 'ͷ��';
      m_UseItemNames[U_ARMRINGL] := ItemIni.ReadString('UseItems', 'UseItems5'{'ARMRINGLNAME'}, ''); // '������';
      m_UseItemNames[U_ARMRINGR] := ItemIni.ReadString('UseItems', 'UseItems6'{'ARMRINGRNAME'}, ''); // '������';
      m_UseItemNames[U_RINGL] := ItemIni.ReadString('UseItems', 'UseItems7'{'RINGLNAME'}, ''); // '���ָ';
      m_UseItemNames[U_RINGR] := ItemIni.ReadString('UseItems', 'UseItems8'{'RINGRNAME'}, ''); // '�ҽ�ָ';
      {$IF M2Version <> 2}
      m_UseItemNames[U_BUJUK] := ItemIni.ReadString('UseItems', 'UseItems9'{'BUJUKNAME'}, ''); // '��Ʒ';
      m_UseItemNames[U_BELT] := ItemIni.ReadString('UseItems', 'UseItems10'{'BELTNAME'}, ''); // '����';
      m_UseItemNames[U_BOOTS] := ItemIni.ReadString('UseItems', 'UseItems11'{'BOOTSNAME'}, ''); // 'Ь��';
      m_UseItemNames[U_CHARM] := ItemIni.ReadString('UseItems', 'UseItems12'{'CHARMNAME'}, ''); // '��ʯ';
      m_UseItemNames[U_ZHULI] := ItemIni.ReadString('UseItems','UseItems13'{'CHARMNAME'}, ''); // '����';
      m_UseItemNames[U_DRUM] := ItemIni.ReadString('UseItems','UseItems14'{'CHARMNAME'}, ''); // '����';
      {$IFEND}
      for I := {$IF M2Version <> 2}U_DRESS to U_ZHULI{$ELSE}U_DRESS to U_RINGR{$IFEND} do begin
        if m_UseItemNames[I] <> '' then begin
          StdItem := UserEngine.GetStdItem(m_UseItemNames[I]);
          if StdItem <> nil then begin
            New(UserItem);
            if UserEngine.CopyToUserItemFromName(m_UseItemNames[I], UserItem) then begin
              if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
                if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                  UserEngine.GetUnknowItemValue(UserItem);
                end;
              end;
            end;
            m_UseItems[I] := UserItem^;
            Dispose(UserItem);
          end;
        end;
      end;
      ItemIni.Free;
    end;
  end;
  inherited;
end;

function TAIPlayObject.SearchPickUpItem(nPickUpTime: Integer): Boolean;
  procedure SetHideItem(MapItem: PTMapItem);
  var
    VisibleMapItem: pTVisibleMapItem;
    I: Integer;
  begin
    for I := 0 to m_VisibleItems.Count - 1 do begin
      VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[I]);
      if (VisibleMapItem <> nil) and (VisibleMapItem.nVisibleFlag > 0) then begin
        if VisibleMapItem.MapItem = MapItem then begin
          VisibleMapItem.nVisibleFlag := 0;
          Break;
        end;
      end;
    end;
  end;
  function PickUpItem(nX, nY: Integer): Boolean;
  var
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    MapItem: PTMapItem;
  begin
    Result := False;
    MapItem := m_PEnvir.GetItem(nX, nY);
    if MapItem = nil then Exit;
    if CompareText(MapItem.Name, sSTRING_GOLDNAME) = 0 then begin
      if m_PEnvir.DeleteFromMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
        if TPlayObject(self).IncGold(MapItem.Count) then begin
          SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), nX, nY, '');
          Result := True;
          GoldChanged;
          SetHideItem(MapItem);
          Dispose(MapItem);
        end else begin
          m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
        end;
      end else begin
        m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
      end;
    end else begin //����Ʒ
      if MapItem.UserItem.AddValue[0] in [2,3] then Exit;//����Ʒ���ܼ� 20110528
      StdItem := UserEngine.GetStdItem(MapItem.UserItem.wIndex);
      if StdItem <> nil then begin
        if m_PEnvir.DeleteFromMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
          New(UserItem);
          FillChar(UserItem^, SizeOf(TUserItem), #0);
          UserItem^ := MapItem.UserItem;
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if (StdItem <> nil) and IsAddWeightAvailable(UserEngine.GetStdItemWeight(UserItem.wIndex)) then begin
            if GetCheckItemList(18, StdItem.Name) then begin//�ж��Ƿ�Ϊ��48ʱ��Ʒ
              UserItem.AddValue[0]:= 2;
              UserItem.MaxDate:= IncDayHour(Now(), 48);//���ʱ��
            end;
            if AddItemToBag(UserItem) then begin
              SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), nX, nY, '');
              SendAddItem(UserItem);
              m_WAbil.Weight := RecalcBagWeight();
              Result := True;
              SetHideItem(MapItem);
              Dispose(MapItem);
            end else begin
              Dispose(UserItem);
              m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
            end;
          end else begin
            Dispose(UserItem);
            m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
          end;
        end else begin
          Dispose(UserItem);
          m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
        end;
      end;
    end;
  end;
var
  MapItem: PTMapItem;
  VisibleMapItem: pTVisibleMapItem;
  SelVisibleMapItem: pTVisibleMapItem;
  I: Integer;
  boFound: Boolean;
  n01, n02: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if GetTickCount() - m_dwPickUpItemTick < nPickUpTime then Exit;
    m_dwPickUpItemTick := GetTickCount();
    if IsEnoughBag and (m_TargetCret = nil) then begin
      boFound := False;
      nCode:= 1;
      if m_SelMapItem <> nil then begin
        m_boCanPickIng:= True;
        nCode:= 2;
        for I := 0 to m_VisibleItems.Count - 1 do begin
          nCode:= 3;
          VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[I]);
          nCode:= 4;
          if (VisibleMapItem <> nil) and (VisibleMapItem.nVisibleFlag > 0) then begin
            if VisibleMapItem.MapItem = m_SelMapItem then begin
              nCode:= 5;
              boFound := True;
              Break;
            end;
          end;
        end;
      end;
      if not boFound then m_SelMapItem := nil;
      nCode:= 6;
      if m_SelMapItem <> nil then begin
        if PickUpItem(m_nCurrX, m_nCurrY) then begin
          m_boCanPickIng:= False;
          Result := True;
          Exit;
        end;
      end;
      n01 := 999;
      nCode:= 7;
      SelVisibleMapItem := nil;
      boFound := False;
      if m_SelMapItem <> nil then begin
       nCode:= 8;
        for I := 0 to m_VisibleItems.Count - 1 do begin
         nCode:= 9;
          VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[I]);
          nCode:= 10;
          if (VisibleMapItem <> nil) and (VisibleMapItem.nVisibleFlag > 0) then begin
            nCode:= 11;
            if VisibleMapItem.MapItem = m_SelMapItem then begin
              SelVisibleMapItem := VisibleMapItem;
              boFound := True;
              Break;
            end;
          end;
        end;
      end;
      if not boFound then begin
        nCode:= 12;
        for I := 0 to m_VisibleItems.Count - 1 do begin
          nCode:= 13;
          VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[I]);
          nCode:= 14;
          try
            if (VisibleMapItem <> nil) then begin
              if (VisibleMapItem.nVisibleFlag > 0) then begin
                MapItem := VisibleMapItem.MapItem;
                if MapItem <> nil then begin
                  //nCode:= 15;
                  if IsAllowAIPickUpItem(VisibleMapItem.sName) and
                    IsAddWeightAvailable(UserEngine.GetStdItemWeight(MapItem.UserItem.wIndex)) and
                    (MapItem.UserItem.AddValue[0]<>2) and (MapItem.UserItem.AddValue[0]<>3) then begin
                    //nCode:= 16;
                    if (MapItem.OfBaseObject = nil) or (MapItem.OfBaseObject = m_MyHero)
                      or (MapItem.OfBaseObject = Self) or (TBaseObject(MapItem.OfBaseObject).m_Master = Self) then begin
                      //nCode:= 17;
                      if (abs(VisibleMapItem.nX - m_nCurrX) <= 5) and (abs(VisibleMapItem.nY - m_nCurrY) <= 5) then begin
                        n02 := abs(VisibleMapItem.nX - m_nCurrX) + abs(VisibleMapItem.nY - m_nCurrY);
                        //nCode:= 18;
                        if n02 < n01 then begin
                          n01 := n02;
                          SelVisibleMapItem := VisibleMapItem;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          except
          end;
        end;//for
      end;
      nCode:= 20;
      if SelVisibleMapItem <> nil then begin
        nCode:= 21;
        m_SelMapItem := SelVisibleMapItem.MapItem;
        if m_SelMapItem <> nil then m_boCanPickIng:= True else m_boCanPickIng:= False;
        if (m_nCurrX <> SelVisibleMapItem.nX) or (m_nCurrY <> SelVisibleMapItem.nY) then begin
          nCode:= 22;
          WalkToTargetXY2(SelVisibleMapItem.nX, VisibleMapItem.nY);
          Result := True;
        end;
      end else m_boCanPickIng:= False;
    end else begin
      m_SelMapItem:= nil;
      m_boCanPickIng:= False;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.SearchPickUpItem Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TAIPlayObject.WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;
var
  I: Integer;
  nDir: Integer;
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
begin
  Result := False;
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] <> 0) and (not g_ClientConf.boParalyCanSpell))
    or (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
    or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20080915
  if (nTargetX <> m_nCurrX) or (nTargetY <> m_nCurrY) then begin
    if GetTickCount()- dwTick3F4 > m_dwTurnIntervalTime then begin //ת����
      n10 := nTargetX;
      n14 := nTargetY;
      nDir := DR_DOWN;
      if n10 > m_nCurrX then begin
        nDir := DR_RIGHT;
        if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
        if n14 < m_nCurrY then nDir := DR_UPRIGHT;
      end else begin
        if n10 < m_nCurrX then begin
          nDir := DR_LEFT;
          if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
          if n14 < m_nCurrY then nDir := DR_UPLEFT;
        end else begin
          if n14 > m_nCurrY then nDir := DR_DOWN
          else if n14 < m_nCurrY then nDir := DR_UP;
        end;
      end;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(nDir, False);
      if (nTargetX = m_nCurrX) and (nTargetY = m_nCurrY) then begin
        Result := True;
        dwTick3F4 := GetTickCount();
      end;
      if not Result then begin
        n20 := Random(3);
        for I := DR_UP to DR_UPLEFT do begin
          if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
            if n20 <> 0 then Inc(nDir)
            else if nDir > 0 then Dec(nDir)
            else nDir := DR_UPLEFT;
            if (nDir > DR_UPLEFT) then nDir := DR_UP;
            WalkTo(nDir, False);
            if (nTargetX = m_nCurrX) and (nTargetY = m_nCurrY) then begin
              Result := True;
              dwTick3F4 := GetTickCount();
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TAIPlayObject.GotoProtect();
var
  I, nDir, n10, n14, n20, nOldX, nOldY: Integer;
begin
  if ((m_nCurrX <> m_nProtectTargetX) or (m_nCurrY <> m_nProtectTargetY)) then begin
    n10 := m_nProtectTargetX;
    n14 := m_nProtectTargetY;
    dwTick3F4 := GetTickCount();
    nDir := DR_DOWN;
    if n10 > m_nCurrX then begin
      nDir := DR_RIGHT;
      if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
      if n14 < m_nCurrY then nDir := DR_UPRIGHT;
    end else begin
      if n10 < m_nCurrX then begin
        nDir := DR_LEFT;
        if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
        if n14 < m_nCurrY then nDir := DR_UPLEFT;
      end else begin
        if n14 > m_nCurrY then nDir := DR_DOWN
        else if n14 < m_nCurrY then nDir := DR_UP;
      end;
    end;
    nOldX := m_nCurrX;
    nOldY := m_nCurrY;
    if (abs(m_nCurrX - m_nProtectTargetX) >= 3) or (abs(m_nCurrY - m_nProtectTargetY) >= 3) then begin
      m_dwStationTick := GetTickCount; //���Ӽ������վ��ʱ��
      if not RunTo1(nDir, False, m_nProtectTargetX, m_nProtectTargetY) then begin
        WalkTo(nDir, False);
        n20 := Random(3);
        for I := DR_UP to DR_UPLEFT do begin
          if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
            if n20 <> 0 then Inc(nDir)
            else if nDir > 0 then Dec(nDir)
            else nDir := DR_UPLEFT;
            if (nDir > DR_UPLEFT) then nDir := DR_UP;
            WalkTo(nDir, False);
          end;
        end;
      end;
    end else begin
      WalkTo(nDir, False);
      m_dwStationTick := GetTickCount; //���Ӽ������վ��ʱ��
      n20 := Random(3);
      for I := DR_UP to DR_UPLEFT do begin
        if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
          if n20 <> 0 then Inc(nDir)
          else if nDir > 0 then Dec(nDir)
          else nDir := DR_UPLEFT;
          if (nDir > DR_UPLEFT) then nDir := DR_UP;
          WalkTo(nDir, False);
        end;
      end;
    end;
  end;
end;

procedure TAIPlayObject.Wondering();
var
  nX, nY: Integer;
begin
  if m_boAIStart and (m_TargetCret = nil) and (not m_boCanPickIng) and
    (not m_boGhost) and (not m_boDeath) and (not m_boFixedHideMode) and
    (not m_boStoneMode) and (m_wStatusTimeArr[POISON_STONE] = 0) then begin
    nX := m_nCurrX;
    nY := m_nCurrY;
    if (Length(m_Path) > 0) and (m_nPostion < Length(m_Path)) then begin
      if not GotoNextOne(m_Path[m_nPostion].X, m_Path[m_nPostion].Y, True) then begin
        m_Path := nil;
        m_nPostion := -1;
        Inc(m_nMoveFailCount);
        Inc(m_nPostion);
      end else begin
        m_nMoveFailCount := 0;
        Exit;
      end;
    end else begin
      m_Path := nil;
      m_nPostion := -1;
    end;

    if m_PointManager.GetPoint(nX, nY) then begin
      if (abs(nX - m_nCurrX) > 2) or (abs(nY - m_nCurrY) > 2) then begin
        m_Path := g_FindPath.FindPath(m_PEnvir, m_nCurrX, m_nCurrY, nX, nY, True);
        m_nPostion := 0;
        if (Length(m_Path) > 0) and (m_nPostion < Length(m_Path)) then begin
          if not GotoNextOne(m_Path[m_nPostion].X, m_Path[m_nPostion].Y, True) then begin
            m_Path := nil;
            m_nPostion := -1;
            Inc(m_nMoveFailCount);
          end else begin
            m_nMoveFailCount := 0;
            Inc(m_nPostion);
            Exit;
          end;
        end else begin
          m_Path := nil;
          m_nPostion := -1;
          Inc(m_nMoveFailCount);
        end;
      end else begin
        if GotoNextOne(nX, nY, True) then begin
          m_nMoveFailCount := 0;
        end else begin
          Inc(m_nMoveFailCount);
        end;
      end;
    end else begin
      if (Random(2) = 1) then TurnTo(Random(8))
      else WalkTo(m_btDirection, False);
      m_Path := nil;
      m_nPostion := -1;
      Inc(m_nMoveFailCount);
     { else Stop};//20110319 ע�ͣ������Զ�ֹͣ
    end;        
  end;
  if m_nMoveFailCount >= 3 then begin
    if (Random(2) = 1) then TurnTo(Random(8))
    else WalkTo(m_btDirection, False);
    m_Path := nil;
    m_nPostion := -1;
    m_nMoveFailCount := 0;
    //Stop;//20110319 ע�ͣ������Զ�ֹͣ
  end;
end;

procedure TAIPlayObject.Struck(hiter: TBaseObject);
  function MINXY(AObject, BObject: TBaseObject): TBaseObject;
  var
    nA, nB: Integer;
  begin
    nA := abs(m_nCurrX - AObject.m_nCurrX) + abs(m_nCurrY - AObject.m_nCurrY);
    nB := abs(m_nCurrX - BObject.m_nCurrX) + abs(m_nCurrY - BObject.m_nCurrY);
    if nA > nB then Result := BObject else Result := AObject;
  end;
var
  boDisableSayMsg: Boolean;
begin
  m_dwStruckTick := GetTickCount;
  if hiter <> nil then begin
    if (m_TargetCret = nil) and IsProperTarget(hiter) then begin
      SetTargetCreat(hiter);
    end else begin
      if (hiter.m_btRaceServer = RC_PLAYOBJECT) or ((hiter.m_Master <> nil) and (hiter.Master.m_btRaceServer = RC_PLAYOBJECT)) then begin
        if (m_TargetCret <> nil) and ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or ((m_TargetCret.m_Master <> nil) and (m_TargetCret.Master.m_btRaceServer = RC_PLAYOBJECT))) then begin
          if (MINXY(m_TargetCret, hiter) = hiter) or (Random(6) = 0) then begin
            SetTargetCreat(hiter);
          end;
        end else begin
          SetTargetCreat(hiter);
        end;
      end else begin
        if ((m_TargetCret <> nil) and (MINXY(m_TargetCret, hiter) = hiter)) or (Random(6) = 0) then begin
          if (m_btJob > 0) or ((m_TargetCret <> nil) and (GetTickCount() - m_dwTargetFocusTick > 1000 * 3)) then
            if IsProperTarget(hiter) then SetTargetCreat(hiter);
        end;
      end;
    end;

    if (hiter.m_btRaceServer = RC_PLAYOBJECT) and (not hiter.m_boAI) and (m_TargetCret = hiter) then begin
      if (Random(8) = 0) and (m_AISayMsgList.Count > 0) then begin
        if GetTickCount >= m_dwDisableSayMsgTick then m_boDisableSayMsg := False;
        boDisableSayMsg := m_boDisableSayMsg;
        g_DenySayMsgList.Lock;
        try
          if g_DenySayMsgList.GetIndex(m_sCharName) >= 0 then boDisableSayMsg := True;
        finally
          g_DenySayMsgList.UnLock;
        end;
        if not boDisableSayMsg then begin
          SendRefMsg(RM_HEAR, 0, m_btHearMsgFColor, g_Config.btHearMsgBColor, 0, m_sCharName + ':' + m_AISayMsgList.Strings[Random(m_AISayMsgList.Count)]);
        end;
      end;
    end;
  end;

  if m_boAnimal then begin
    m_nMeatQuality := m_nMeatQuality - Random(300);
    if m_nMeatQuality < 0 then m_nMeatQuality := 0;
  end;
  m_dwHitTick := m_dwHitTick + LongWord(150 - _MIN(130, m_Abil.Level * 4));
end;

procedure TAIPlayObject.SearchTarget();
begin
  if ((m_TargetCret = nil) or (GetTickCount - m_dwSearchTargetTick > 1000)) and (m_boAIStart) then begin
    m_dwSearchTargetTick := GetTickCount();
    if (m_TargetCret = nil) or
      (not ((m_TargetCret <> nil) and (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT)) or ((m_TargetCret.m_Master <> nil) and (m_TargetCret.Master.m_btRaceServer = RC_PLAYOBJECT)) or (GetTickCount - m_dwStruckTick > 15000)) then begin
      inherited;
    end;
  end;
end;

procedure TAIPlayObject.Die;
begin
  if m_boAIStart then begin
    m_boAIStart := False;
  end;
  inherited;
end;

function TAIPlayObject.CanWalk(nCurrX, nCurrY, nTargetX, nTargetY: Integer; nDir: Integer; var nStep: Integer; boFlag: Boolean): Boolean;
var
  btDir: Byte;
  nX, nY, nCount: Integer;
begin
  Result := False;
  nStep := 0;
  nCount := 0;
  if (nDir >= 0) and (nDir <= 7) then btDir := nDir
  else btDir := GetNextDirection(nCurrX, nCurrY, nTargetX, nTargetY);
  if boFlag then begin
    if (abs(nCurrX - nTargetX) <= 1) and (abs(nCurrY - nTargetY) <= 1) then begin
      if m_PEnvir.GetNextPosition(nCurrX, nCurrY, btDir, 1, nX, nY) and (nX = nTargetX) and (nY = nTargetY) then begin
        nStep := 1;
        Result := True;
      end;
    end else begin
      if m_PEnvir.GetNextPosition(nCurrX, nCurrY, btDir, 2, nX, nY) and (nX = nTargetX) and (nY = nTargetY) then begin
        nStep := 1;
        Result := True;
      end;
    end;
  end else begin
    if m_PEnvir.GetNextPosition(nCurrX, nCurrY, btDir, 1, nX, nY) and (nX = nTargetX) and (nY = nTargetY) then begin
      nStep := nStep + 1;
      Result := True;
      Exit;
    end else Exit;
    if m_PEnvir.GetNextPosition(nX, nY, btDir, 1, nX, nY) and (nX = nTargetX) and (nY = nTargetY) then begin
      nStep := nStep + 1;
      Result := True;
      Exit;
    end;
  end;
end;

function TAIPlayObject.IsGotoXY(X1, Y1, X2, Y2: Integer): Boolean;
var
  nStep: Integer;
  Path: TPath;
begin
  Result := False;
  if (not CanWalk(X1, Y1, X2, Y2, -1, nStep, m_btRaceServer <> 108)) then begin
    Path := g_FindPath.FindPath(m_PEnvir, X1, Y1, X2, Y2, False);
    if Length(Path) <= 0 then Exit;
    Path := nil;
    Result := True;
  end else Result := True;
end;

function TAIPlayObject.GotoNext(nX, nY: Integer; boRun: Boolean): Boolean;
var
  I, nStep: Integer;
  Path: TPath;
begin
  Result := False;
  nStep := 0;
  if (abs(nX - m_nCurrX) <= 2) and (abs(nY - m_nCurrY) <= 2) then begin
    if (abs(nX - m_nCurrX) <= 1) and (abs(nY - m_nCurrY) <= 1) then begin
      Result := WalkToNext(nX, nY);
    end else begin
      Result := RunToNext(nX, nY);
    end;
    nStep := 1;
  end;

  if not Result then begin
    Path := g_FindPath.FindPath(m_PEnvir, m_nCurrX, m_nCurrY, nX, nY, boRun);
    if Length(Path) > 0 then begin
      for I := 0 to Length(Path) - 1 do begin
        if (Path[I].X <> m_nCurrX) or (Path[I].Y <> m_nCurrY) then begin
          if (abs(Path[I].X - m_nCurrX) >= 2) or (abs(Path[I].Y - m_nCurrY) >= 2) then begin
            Result := RunToNext(Path[I].X, Path[I].Y);
          end else begin
            Result := WalkToNext(Path[I].X, Path[I].Y);
          end;
          if Result then Inc(nStep) else break;
          if nStep >= 3 then break;
        end;
      end;
      Path := nil;
    end;
  end;
  m_RunPos.nAttackCount := 0;
end;

function TAIPlayObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  nError: Integer;
  AttackBaseObject: TBaseObject;
const
  sExceptionMsg0 = '{%s} TAIPlayObject::Operate %s Ident:%d Sender:%d wP:%d nP1:%d nP2:%d np3:%d Msg:%s Code:%s';
begin
  try
    if ProcessMsg.wIdent = RM_STRUCK then begin
      nError := 0;
      if TBaseObject(ProcessMsg.BaseObject) = Self then begin
        nError := 1;
        AttackBaseObject := TBaseObject(ProcessMsg.nParam3);
        if AttackBaseObject <> nil then begin
          nError := 2;
          if AttackBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
            nError := 3;
            SetPKFlag(AttackBaseObject);
            nError := 4;
          end;
          nError := 5;
          SetLastHiter(AttackBaseObject);
          nError := 6;

          Struck(AttackBaseObject);
          nError := 7;
          BreakHolySeizeMode();
          nError := 8;
        end;
        nError := 9;
        if (g_CastleManager.IsCastleMember(Self) <> nil) and (AttackBaseObject <> nil) then begin
          nError := 10;
          AttackBaseObject.bo2B0 := True;
          nError := 11;
          AttackBaseObject.m_dw2B4Tick := GetTickCount();
          nError := 12;
        end;
        nError := 13;
        m_nHealthTick := 0;
        m_nSpellTick := 0;
        Dec(m_nPerHealth);
        Dec(m_nPerSpell);
        m_dwStruckTick := GetTickCount();
        nError := 14;
      end; 
      Result := True;
    end else begin
      Result := inherited Operate(ProcessMsg);
    end;
  except
    MainOutMessage(Format(sExceptionMsg0, [g_sExceptionVer, m_sCharName,
      ProcessMsg.wIdent,Integer(ProcessMsg.BaseObject), ProcessMsg.wParam, ProcessMsg.nParam1,
      ProcessMsg.nParam2, ProcessMsg.nParam3, ProcessMsg.sMsg, nError]));
  end;
end;

function TAIPlayObject.GetRangeTargetCountByDir(nDir, nX, nY, nRange: Integer): Integer;
var
  I: Integer;
  BaseObject: TBaseObject;
  nCurrX, nCurrY: Integer;
begin
  Result := 0;
  nCurrX := nX;
  nCurrY := nY;
  for I := 1 to nRange do begin
    if m_PEnvir.GetNextPosition(nCurrX, nCurrY, nDir, 1, nCurrX, nCurrY) then begin
      BaseObject := TBaseObject(m_PEnvir.GetMovingObject(nCurrX, nCurrY, True));
      if (BaseObject <> nil) and (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and (not BaseObject.m_boHideMode or m_boCoolEye) and IsProperTarget(BaseObject) then begin
        Inc(Result);
      end;
    end;
  end;
end;

function TAIPlayObject.GetNearTargetCount(): Integer;
var
  n10: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  for n10 := 0 to 7 do begin
    if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n10, 1, nX, nY) then begin
      BaseObject := TBaseObject(m_PEnvir.GetMovingObject(nX, nY, True));
      if (BaseObject <> nil) and (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and IsProperTarget(BaseObject) then begin
        Inc(Result);
      end;
    end;
  end;
end;
function TAIPlayObject.GetNearTargetCount(nCurrX, nCurrY: Integer): Integer;
var
  n10: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  BaseObject := TBaseObject(m_PEnvir.GetMovingObject(nCurrX, nCurrY, True));
  if (BaseObject <> nil) and (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and IsProperTarget(BaseObject) then
    Inc(Result);

  for n10 := 0 to 7 do begin
    if m_PEnvir.GetNextPosition(nCurrX, nCurrY, n10, 1, nX, nY) then begin
      BaseObject := TBaseObject(m_PEnvir.GetMovingObject(nX, nY, True));
      if (BaseObject <> nil) and (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and IsProperTarget(BaseObject) then
        Inc(Result);
    end;
  end;
end;

function TAIPlayObject.GetMasterRange(nTargetX, nTargetY: Integer): Integer;
var
  nCurrX, nCurrY: Integer;
begin
  Result := 0;
  if (m_Master <> nil) then begin
    if (m_btRaceServer = RC_HEROOBJECT) and (THeroObject(Self).m_boProtectStatus) then begin
      nCurrX := THeroObject(Self).m_nProtectTargetX;
      nCurrY := THeroObject(Self).m_nProtectTargetY;
    end else begin
      nCurrX := m_Master.m_nCurrX;
      nCurrY := m_Master.m_nCurrY;
    end;
    Result := abs(nCurrX - nTargetX) + abs(nCurrY - nTargetY);
  end;
end;

function TAIPlayObject.FollowMaster: Boolean;
var
  I, II, III, nX, nY, nCurrX, nCurrY, nStep: Integer;
  boNeed: Boolean;
begin
  Result := False;
  boNeed := False;
  if (not m_Master.m_boSlaveRelax) then begin
    if (m_PEnvir <> m_Master.m_PEnvir) or (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20) then begin
      boNeed := True;
    end;
  end;

  if boNeed then begin
    {if m_boProtectStatus then begin
      nX := m_nProtectTargetX;
      nY := m_nProtectTargetY;
    end else begin }
      m_Master.GetBackPosition(nX, nY);
      if not m_Master.m_PEnvir.CanWalk(nX, nY, True) then begin
        for I := 0 to 7 do begin
          if m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, I, 1, nX, nY) then begin
            if m_Master.m_PEnvir.CanWalk(nX, nY, True) then begin
              break;
            end;
          end;
        end;
      end;
    //end;

    DelTargetCreat;
    m_nTargetX := nX;
    m_nTargetY := nY;

    //if not m_boProtectStatus then begin
      SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
    {end else begin
      SpaceMove(m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
    end;}
    Result := True;
    Exit;
  end;

  {if m_boProtectStatus then begin
    nCurrX := m_nProtectTargetX;
    nCurrY := m_nProtectTargetY;
  end else begin}
    m_Master.GetBackPosition(nCurrX, nCurrY);
  //end;

  if (m_TargetCret = nil) and (not m_Master.m_boSlaveRelax) then begin
    //if not m_boProtectStatus then begin
      for I := 1 to 2 do begin //�ж������Ƿ���Ӣ�۶���
        if m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_btDirection, I, nX, nY) then begin
          if (m_nCurrX = nX) and (m_nCurrY = nY) then begin
            if m_Master.GetBackPosition(nX, nY) and
              GotoNext(nX, nY, True) then begin
              Result := True;
              Exit;
            end;

            for III := 1 to 2 do begin
              for II := 0 to 7 do begin
                if II <> m_Master.m_btDirection then begin
                  if m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, II, III, nX, nY) and
                  GotoNext(nX, nY, True) then begin
                    Result := True;
                    Exit;
                  end;
                end;
              end;
            end;
            Break;
          end;
        end;
      end;

      if m_btRaceServer = 108 then nStep := 0 else nStep := 1;//�Ƿ�Ϊ����
      if (abs(m_nCurrX - nCurrX) > nStep) or (abs(m_nCurrY - nCurrY) > nStep) then begin
        if GotoNextOne(nCurrX, nCurrY, True) then Exit;
        if GotoNextOne(nX, nY, True) then Exit;
        for III := 1 to 2 do begin
          for II := 0 to 7 do begin
            if II <> m_Master.m_btDirection then begin
              if m_Master.m_PEnvir.GetNextPosition(m_Master.m_nCurrX, m_Master.m_nCurrY, II, III, nX, nY) and
              GotoNextOne(nX, nY, True) then begin
                Result := True;
                Exit;
              end;
            end;
          end;
        end;
      end;
   {end else begin
      if GotoNextOne(nCurrX, nCurrY, True) then Exit;
      for III := 1 to 2 do begin
        for II := 0 to 7 do begin
          if m_Master.m_PEnvir.GetNextPosition(nCurrX, nCurrY, II, III, nX, nY) and
          GotoNextOne(nX, nY, True) then begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end; }
  end;
end;

function TAIPlayObject.FindVisibleActors(ActorObject: TBaseObject): Boolean;
var
  I: Integer;
begin
  for I := 0 to m_VisibleActors.Count - 1 do begin
    if (pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject = ActorObject) then begin
      Result := True;
      Break;
    end;
  end;
end;
function TAIPlayObject.AllowUseMagic(wMagIdx: Word): Boolean;
var
  UserMagic: pTUserMagic;
begin
  Result := False;
  UserMagic := FindMagic(wMagIdx);
  if UserMagic <> nil then begin
    if not MagicManager.IsWarrSkill(UserMagic.wMagIdx) then begin
      Result := (UserMagic.btKey = 0) or m_boAI;
    end else begin
      Result := (UserMagic.btKey = 0) or m_boAI or (m_btRaceServer = RC_PLAYMOSTER);
    end;
  end;
end;

function TAIPlayObject.CheckUserItem(nItemType, nCount: Integer): Boolean;
begin
  Result := CheckUserItemType(nItemType, nCount) or (GetUserItemList(nItemType, nCount) >= 0);
end;

function TAIPlayObject.CheckItemType(nItemType: Integer; StdItem: pTStdItem): Boolean;
begin
  Result := False;
  case nItemType of
    1: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 1) then Result := True;
      end;
    2: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 2) then Result := True;
      end;
    3: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 3) then Result := True;
      end;
    5: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 5) then Result := True;
      end;
  end;
end;

function TAIPlayObject.CheckUserItemType(nItemType, nCount: Integer): Boolean;
var
  StdItem: pTStdItem;
begin
  Result := False;
  if (m_UseItems[U_ARMRINGL].wIndex > 0) and (Round(m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_ARMRINGL].wIndex);
    if StdItem <> nil then begin
      Result := CheckItemType(nItemType, StdItem);
    end;
  end;
end;
//���������Ƿ��з��Ͷ�
//nType Ϊָ������ 5 Ϊ����� 1,2 Ϊ��ҩ   3,������ר��
function TAIPlayObject.GetUserItemList(nItemType, nCount: Integer): Integer;
var
  I: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := -1;
  for I := 0 to m_ItemList.Count - 1 do begin
    UserItem := m_ItemList.Items[I];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      if CheckItemType(nItemType, StdItem) and (Round(UserItem.Dura / 100) >= nCount) then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;
//�Զ�������
function TAIPlayObject.UseItem(nItemType, nIndex: Integer): Boolean;
var
  UserItem: pTUserItem;
  AddUserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  if (nIndex >= 0) and (nIndex < m_ItemList.Count) then begin
    UserItem := m_ItemList.Items[nIndex];
    if m_UseItems[U_ARMRINGL {U_BUJUK}].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[U_ARMRINGL {U_BUJUK}].wIndex);
      if StdItem <> nil then begin
        if CheckItemType(nItemType, StdItem) then begin
          Result := True;
        end else begin
          m_ItemList.Delete(nIndex);
          New(AddUserItem);
          AddUserItem^ := m_UseItems[U_ARMRINGL {U_BUJUK}];
          if AddItemToBag(AddUserItem) then begin
            m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
            Dispose(UserItem);
            Result := True;
          end else begin
            m_ItemList.Add(UserItem);
            Dispose(AddUserItem);
          end;
        end;
      end else begin
        m_ItemList.Delete(nIndex);
        m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
        Dispose(UserItem);
        Result := True;
      end;
    end else begin
      m_ItemList.Delete(nIndex);
      m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
      Dispose(UserItem);
      Result := True;
    end;
  end;
end;

function TAIPlayObject.GetRangeTargetCount(nX, nY, nRange: Integer): Integer;
var
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  I: Integer;
begin
  Result := 0;
  BaseObjectList := TList.Create;
  try
    if m_PEnvir.GetMapBaseObjects(nX, nY, nRange, BaseObjectList) then begin
      for I := BaseObjectList.Count - 1 downto 0 do begin
        BaseObject := TBaseObject(BaseObjectList.Items[I]);
        if (BaseObject.m_boHideMode and not m_boCoolEye) or (not IsProperTarget(BaseObject)) then begin
          BaseObjectList.Delete(I);
        end;
      end;
      Result := BaseObjectList.Count;
    end;
  finally
    BaseObjectList.Free;
  end;
end;
//Ŀ���Ƿ���Լ���һ�����ϣ��������ֱ�߹�����ħ���Ƿ���Թ�����Ŀ��
function TAIPlayObject.CanLineAttack(nCurrX, nCurrY: Integer): Boolean;
var
  btDir: Byte;
  nX, nY: Integer;
begin
  Result := False;
  nX := nCurrX;
  nY := nCurrY;
  btDir := GetNextDirection(nCurrX, nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  while True do begin
    if (m_TargetCret.m_nCurrX = nX) and (m_TargetCret.m_nCurrY = nY) then begin
      Result := True;
      Break;
    end;
    btDir := GetNextDirection(nX, nY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    if not m_PEnvir.GetNextPosition(nX, nY, btDir, 1, nX, nY) then Break;
    if not m_PEnvir.CanWalkEx(nX, nY, True) then Break;
  end;
end;
//�Ƿ�����ֱ�߹���
function TAIPlayObject.CanLineAttack(nStep: Integer): Boolean;
var
  I: Integer;
  btDir: Byte;
  nX, nY: Integer;
begin
  Result := False;
  nX := m_nCurrX;
  nY := m_nCurrY;
  btDir := GetNextDirection(nX, nY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
  for I := 1 to nStep do begin
    if (m_TargetCret.m_nCurrX = nX) and (m_TargetCret.m_nCurrY = nY) then begin
      Result := True;
      Break;
    end;
    btDir := GetNextDirection(nX, nY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    if not m_PEnvir.GetNextPosition(nX, nY, btDir, 1, nX, nY) then Break;
    if not m_PEnvir.CanWalkEx(nX, nY, True) then Break;
  end;
end;
(*
function TAIPlayObject.SelectMagic(): Integer;
  function SelKTZandCID(var nSelectMagic: Integer): Boolean;
  var
    boKTZHitSkill, boCIDHitSkill: Boolean;
  begin
    nSelectMagic:= 0;
    Result := False;
    boKTZHitSkill := False;
    boCIDHitSkill := False;
    if m_bo43kill then begin
      nSelectMagic := 42;
      Result := True;
      Exit;
    end;
    if m_bo42kill then begin
      nSelectMagic := 43;
      if (Random(g_Config.n43KillHitRate) = 0) then begin
        m_n42kill := 2;//�ػ�
      end else begin
        m_n42kill := 1;//���
      end;
      m_n42kill := 1;//���
      Result := True;
      Exit;
    end;
    if AllowUseMagic(42) and (not m_bo43kill) and ((GetTickCount - m_dwLatest42Tick) > g_Config.nKill43UseTime * 1000) then begin
      boCIDHitSkill := True;
    end;
    if AllowUseMagic(43) and (not m_bo42kill) and ((GetTickCount - m_dwLatest43Tick) > g_Config.nKill42UseTime * 1000) then begin
      boKTZHitSkill := True;
    end;

    if boKTZHitSkill and boCIDHitSkill then begin
      case Random(2) of
        1: begin
            Skill43OnOff;
            nSelectMagic := 42;
            Result := True;
          end;
        2: begin
            Skill42OnOff;
            if (Random(g_Config.n43KillHitRate) = 0) then begin
              m_n42kill := 2;//�ػ�
            end else begin
              m_n42kill := 1;//���
            end;
            nSelectMagic := 43;
            Result := True;
          end;
      else begin
          Skill43OnOff;
          nSelectMagic := 42;
          Result := True;
        end;
      end;
      Exit;
    end;
    if boCIDHitSkill then begin
      Skill43OnOff;
      nSelectMagic := 42;
      Result := True;
    end;
    if boKTZHitSkill then begin
      Skill42OnOff;
      if (Random(g_Config.n43KillHitRate) = 0) then begin
        m_n42kill := 2;//�ػ�
      end else begin
        m_n42kill := 1;//���
      end;
      nSelectMagic := 43;
      Result := True;
    end;
  end;
  function GetMoonSlaveCount: Integer;//�����������
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := 0;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and (BaseObject.m_btRaceServer = 108) then Inc(Result);
    end;
  end;
  function GetMoonSlaveDeath: Boolean;//����ٻ��������Ƿ�����
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (BaseObject.m_btRaceServer = 108) and ((BaseObject.m_boDeath) or (BaseObject.m_boGhost)) then begin
        Result := True;
        Break;
      end;
    end;
  end;
  function GetCopySlaveCount: Integer;//ȡ��������
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := 0;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) and (BaseObject.m_nCopyHumanLevel = 2) then Inc(Result);
    end;
  end;
  function GetCopySlaveDeath: Boolean;//�жϷ����Ƿ�����
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (BaseObject.m_nCopyHumanLevel = 2) and ((BaseObject.m_boDeath) or (BaseObject.m_boGhost)) then begin
        Result := True;
        Break;
      end;
    end;
  end;
  function GetSlaveCount: Integer;
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := 0;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then Inc(Result);
    end;
  end;
  function GetSlaveDeath: Boolean;
  var
    I: Integer;
    BaseObject: TBaseObject;
  begin
    Result := False;
    if m_SlaveList.Count <= 0 then Exit;
    for I := 0 to m_SlaveList.Count - 1 do begin
      BaseObject := m_SlaveList.Items[I];
      if (BaseObject.m_nCopyHumanLevel = 0) and ((BaseObject.m_boDeath) or (BaseObject.m_boGhost)) then begin
        Result := True;
        Break;
      end;
    end;
  end;
  function IsUseCopySelf: Boolean;//������
  begin
    Result := False;
    if m_Master = nil then begin
      if AllowUseMagic(46) and ((GetCopySlaveCount <= 0) or GetCopySlaveDeath) then begin
        Result := True;
      end;
    end;
  end;
  function IsUseSkill8(): Boolean; //���ܻ�
  var
    BaseObjectList: TList;
    BaseObject: TBaseObject;
    btNewDir: Byte;
    nTargetX, nTargetY: Integer;
    I: Integer;
  begin
    Result := False;
    if AllowUseMagic(8) and (GetTickCount - m_SkillUseTick[8] > 5000) then begin
      if (m_TargetCret <> nil) and (m_Abil.Level > m_TargetCret.m_Abil.Level) and
        (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1) then begin
        btNewDir := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
        if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
          Result := m_PEnvir.CanWalk(nTargetX, nTargetY, True);
        end;
        if Result then Exit;
      end;
      BaseObjectList := TList.Create;
      try
        if m_PEnvir.GetMapBaseObjects(m_nCurrX, m_nCurrY, 1, BaseObjectList) then begin
          for I := 0 to BaseObjectList.Count - 1 do begin
            BaseObject := TBaseObject(BaseObjectList.Items[I]);
            if (m_TargetCret = BaseObject) and (BaseObject.m_boHideMode and not m_boCoolEye) or BaseObject.m_boDeath or BaseObject.m_boGhost or (not IsProperTarget(BaseObject)) then Continue;
            if BaseObject.m_Abil.Level < m_Abil.Level then begin
              btNewDir := GetNextDirection(BaseObject.m_nCurrX, BaseObject.m_nCurrY, m_nCurrX, m_nCurrY);
              if m_PEnvir.GetNextPosition(BaseObject.m_nCurrX, BaseObject.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
                if m_PEnvir.CanWalk(nTargetX, nTargetY, True) then begin
                  Result := True;
                  Break;
                end;
              end;
            end;
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
    end;
  end;
  function IsUseSkill48: Boolean; //������
  var
    BaseObjectList: TList;
    BaseObject: TBaseObject;
    btNewDir: Byte;
    nTargetX, nTargetY: Integer;
    I: Integer;
  begin
    Result := False;
    if AllowUseMagic(48) and (GetTickCount - m_SkillUseTick[48] > 1000 * 5) then begin
      if (m_TargetCret <> nil) and (m_Abil.Level > m_TargetCret.m_Abil.Level) and
        (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1) then begin
        btNewDir := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
        if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
          Result := m_PEnvir.CanWalk(nTargetX, nTargetY, True);
        end;
        if Result then Exit;
      end;
      BaseObjectList := TList.Create;
      try
        if m_PEnvir.GetMapBaseObjects(m_nCurrX, m_nCurrY, 1, BaseObjectList) then begin
          for I := 0 to BaseObjectList.Count - 1 do begin
            BaseObject := TBaseObject(BaseObjectList.Items[I]);
            if (m_TargetCret = BaseObject) and (BaseObject.m_boHideMode and not m_boCoolEye) or BaseObject.m_boDeath or BaseObject.m_boGhost or (not IsProperTarget(BaseObject)) then Continue;
            if BaseObject.m_Abil.Level < m_Abil.Level then begin
              btNewDir := GetNextDirection(BaseObject.m_nCurrX, BaseObject.m_nCurrY, m_nCurrX, m_nCurrY);
              if m_PEnvir.GetNextPosition(BaseObject.m_nCurrX, BaseObject.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
                if m_PEnvir.CanWalk(nTargetX, nTargetY, True) then begin
                  Result := True;
                  Break;
                end;
              end;

            end;
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
    end;
  end;
  function IsUseSkill27: Boolean; //Ұ����ײ
    function CanMotaebo(BaseObject: TBaseObject; nMagicLevel: Integer): Boolean;
    var
      nC: Integer;
    begin
      Result := False;
      if (m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
        nC := m_Abil.Level - BaseObject.m_Abil.Level;
        if Random(20) < ((nMagicLevel * 4) + 6 + nC) then Result := True;
      end;
    end;
  var
    nX, nY: Integer;
    nDir: Integer;
    UserMagic: pTUserMagic;
  begin
    Result := False;
    if AllowUseMagic(27) and (m_TargetCret.m_Abil.Level < m_Abil.Level) and ((GetPoseCreate = m_TargetCret) or (m_TargetCret.GetPoseCreate = Self)) and (GetTickCount - m_SkillUseTick[27] > 1000 * 10) then begin
      UserMagic := FindMagic(27);
      if CanMotaebo(m_TargetCret, UserMagic.btLevel) then begin
        nDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, nDir, 1, nX, nY) then begin
          Result := m_TargetCret.m_PEnvir.CanWalk(nX, nY, False);
        end;
      end;
    end;
  end;
  function UseFireCross: Boolean;//��ǽ
  begin
    if (m_TargetCret <> nil) and AllowUseMagic(22) and (GetTickCount - m_SkillUseTick[22] > 1000 * 5) then begin
      Result := True;
      if (not m_PEnvir.CanWalk(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY - 1, False)) or (m_PEnvir.GetEvent(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY - 1) <> nil) then
        if (not m_PEnvir.CanWalk(m_TargetCret.m_nCurrX - 1, m_TargetCret.m_nCurrY, False)) or (m_PEnvir.GetEvent(m_TargetCret.m_nCurrX - 1, m_TargetCret.m_nCurrY) <> nil) then
          if (not m_PEnvir.CanWalk(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, False)) or (m_PEnvir.GetEvent(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY) <> nil) then
            if (not m_PEnvir.CanWalk(m_TargetCret.m_nCurrX + 1, m_TargetCret.m_nCurrY, False)) or (m_PEnvir.GetEvent(m_TargetCret.m_nCurrX + 1, m_TargetCret.m_nCurrY) <> nil) then
              if (not m_PEnvir.CanWalk(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY + 1, False)) or (m_PEnvir.GetEvent(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY + 1) <> nil) then
                Result := False;
    end else Result := False;
  end;
  function QuickLighting: Boolean;//�����Ӱ
  begin
    Result := False;
    if AllowUseMagic(10) and CanLineAttack(6) then begin
      if (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
        Result := True;
      end;
    end;
  end;
  function IsUseSkill41: Boolean; //ʨ�Ӻ�
  var
    BaseObjectList: TList;
    BaseObject: TBaseObject;
    I, nCount: Integer;
  begin
    Result := False;
    if (m_TargetCret <> nil) and (not (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HEROOBJECT, RC_PLAYMOSTER])) and AllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] > 1000 * 10) then begin
      nCount := 0;
      BaseObjectList := TList.Create;
      try
        if m_PEnvir.GetMapBaseObjects(m_nCurrX, m_nCurrY, 3, BaseObjectList) then begin
          for I := 0 to BaseObjectList.Count - 1 do begin
            BaseObject := TBaseObject(BaseObjectList.Items[I]);
            if (BaseObject.m_boHideMode and not m_boCoolEye) or BaseObject.m_boDeath
               or BaseObject.m_boGhost or (not IsProperTarget(BaseObject)) then Continue;
            if BaseObject.m_Abil.Level < m_Abil.Level then Inc(nCount);
            if nCount >= 3 then begin
              Result := True;
              Break;
            end;
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
    end;
  end;
  function IsUseSkill38: Boolean; //Ⱥ����
  var
    BaseObjectList: TList;
    BaseObject: TBaseObject;
    I, n01, n02: Integer;
  begin
    Result := False;
    if AllowUseMagic(38) then begin
      n01 := 0;
      n02 := 0;
      BaseObjectList := TList.Create;
      try
        if m_PEnvir.GetMapBaseObjects(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3, BaseObjectList) then begin
          for I := 0 to BaseObjectList.Count - 1 do begin
            BaseObject := TBaseObject(BaseObjectList.Items[I]);
            if (BaseObject.m_boHideMode and not m_boCoolEye) or BaseObject.m_boDeath
              or BaseObject.m_boGhost or (not IsProperTarget(BaseObject)) then Continue;
            if (BaseObject.m_wStatusTimeArr[POISON_DECHEALTH] = 0) then Inc(n01);
            if (BaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) then Inc(n02);
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
      if (n01 > 1) and (n02 = 0) then begin
        if CheckUserItem(1, 2) then begin
          m_nSelItemType := 1;
          Result := True;
        end;
      end else
        if (n01 = 0) and (n02 > 1) then begin
        if CheckUserItem(2, 2) then begin
          m_nSelItemType := 2;
          Result := True;
        end;
      end else
        if (n01 > 1) and (n02 > 1) then begin
        if n01 > n02 then begin
          if CheckUserItem(1, 2) then begin
            m_nSelItemType := 1;
            Result := True;
          end else
            if CheckUserItem(2, 2) then begin
            m_nSelItemType := 2;
            Result := True;
          end;
        end else begin
          if CheckUserItem(2, 2) then begin
            m_nSelItemType := 2;
            Result := True;
          end else
            if CheckUserItem(1, 2) then begin
            m_nSelItemType := 1;
            Result := True;
          end;
        end;
      end;
    end;
  end;
var
  btDir: Byte;
  nSelectMagic, nRangeTargetCount, nSelfRangeTargetCount, nRangeTargetCountByDir, nCode: Integer;
  boVisibleActors: Boolean;
begin
  Result := 0;
  if m_boAI and (m_TargetCret <> nil) and (m_MyHero <> nil) and
    (GetTickCount - m_dwHeroUseSpellTick > 12000) and
    (THeroObject(m_MyHero).m_nFirDragonPoint >= g_Config.nMaxFirDragonPoint) then begin//������,�Զ�ʹ�úϻ�
    {$IF M2Version = 1}
    if not THeroObject(m_MyHero).m_boUseBatter then begin//Ӣ������ֹͣ���ʹ�úϻ�
      m_dwHeroUseSpellTick:= GetTickCount();//�Զ�ʹ�úϻ����
      ClientHeroUseSpell;
      Exit;
    end;
    {$IFEND}
  end;
  case m_btJob of
    0: begin //սʿ
        if IsUseSkill27 then begin//Ұ����ײ
          Result := 27;
          Exit;
        end;
        if m_boFireHitSkill then begin//�һ�
          Result := 26;
          Exit;
        end;
        if m_boDailySkill then begin//����
          Result := SKILL_74;
          Exit;
        end;
        if AllowUseMagic(26) and (not m_boFireHitSkill) and ((GetTickCount - m_dwLatestFireHitTick) > 10000) then begin//�һ�
          AllowFireHitSkill;
          Result := 26;
          Exit;
        end;
        if SelKTZandCID(nSelectMagic) then begin
          Result := nSelectMagic;
          Exit;
        end;
        if AllowUseMagic(SKILL_74) and (not m_boDailySkill) and ((GetTickCount - m_dwLatestDailyTick) > 12000) then begin//����
          AllowDailySkill;
          Result := SKILL_74;
          Exit;
        end;
        if GetAttackDir(m_TargetCret, 2, btDir) then begin //��λ��ɱ����
          if AllowUseMagic(12) then begin
            if not m_boUseThrusting then begin
              ThrustingOnOff(True);
            end;
            Result := 12;
            Exit;
          end;
        end;
        if (Random(20) = 0) and AllowUseMagic(7) then begin //��ɱ����
          m_boPowerHit := True;
          Result := 7;
          Exit;
        end;
        if IsUseSkill41 then begin//ʨ�Ӻ�
          Result := 41;
          Exit;
        end;

        nRangeTargetCount := GetNearTargetCount;

        nRangeTargetCountByDir := GetRangeTargetCountByDir(GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), m_nCurrX, m_nCurrY, 4);
        if (nRangeTargetCountByDir > 1) and (nRangeTargetCount < 3) then begin //�������
          if AllowUseMagic(12) then begin
            if not m_boUseThrusting then begin
              ThrustingOnOff(True);
            end;
            Result := 12;
            Exit;
          end;

          if SelKTZandCID(nSelectMagic) then begin
            Result := nSelectMagic;
            Exit;
          end;
          if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000) then begin
            m_SkillUseTick[39] := GetTickCount; //���ض�
            Result := 39;
            Exit;
          end;
        end;

        if (nRangeTargetCount >= 5) then begin //�������Χ >=5
          if AllowUseMagic(40) then begin //���µ���
            if not m_boCrsHitkill then begin
              SkillCrsOnOff(True);
            end;
            Result := 40;
            Exit;
          end;
          if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000) then begin
            m_SkillUseTick[39] := GetTickCount; //���ض�
            Result := 39;
            Exit;
          end;
        end;
        if (nRangeTargetCount >= 2) then begin //�������Χ >=2
          if AllowUseMagic(25) then begin //����
            if not m_boUseHalfMoon then begin
              HalfMoonOnOff(True, 0);
            end;
            Result := 25;
            Exit;
          end;
          if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000) then begin
            m_SkillUseTick[39] := GetTickCount; //���ض�
            Result := 39;
            Exit;
          end;
        end;
        if (Random(10) = 0) and AllowUseMagic(7) then begin //��ɱ����
          m_boPowerHit := True;
          Result := 7;
          Exit;
        end;
        if AllowUseMagic(12) then begin //��ɱ����
          if not m_boUseThrusting then begin
            ThrustingOnOff(True);
          end;
          Result := 12;
          Exit;
        end;
        if AllowUseMagic(25) then begin //����
          if not m_boUseHalfMoon then begin
            HalfMoonOnOff(True, 0);
          end;
          Result := 25;
          Exit;
        end;
        if AllowUseMagic(40) then begin //���µ���
          if not m_boCrsHitkill then begin
            SkillCrsOnOff(True);
          end;
          Result := 40;
          Exit;
        end;
        if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000) then begin //���ض�
          Result := 39;
          Exit;
        end;
        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(7) then begin //��ɱ����
          Result := 7;
          Exit;
        end;
        if SelKTZandCID(nSelectMagic) then begin
          Result := nSelectMagic;
          Exit;
        end;
      end;
    1: begin //��ʦ
        if (AllowUseMagic(31)) and (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) then begin {ʹ�� ħ����}
          Result := 31;
          Exit;
        end;
        nRangeTargetCount := GetRangeTargetCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3);
        nSelfRangeTargetCount := GetNearTargetCount;
        nRangeTargetCountByDir := GetRangeTargetCountByDir(GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY), m_nCurrX, m_nCurrY, 6);
        if IsUseCopySelf { and ((nSelfRangeTargetCount > 1) or (nRangeTargetCount > 1))} then begin
          //m_TargetCret := nil;
          Result := 46; //������
          Exit;
        end;

        if nRangeTargetCountByDir > 5 then begin
          if (AllowUseMagic(58)) and (GetTickCount - m_SkillUseTick[58] > 5000) then begin//���ǻ���
            Result := 58;
            Exit;
          end;
        end;
        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
          if UseFireCross then begin
            Result := 22; //��ǽ
            Exit;
          end;
        end else begin
          if nRangeTargetCountByDir > 1 then begin
            if UseFireCross then begin
              Result := 22; //��ǽ
              Exit;
            end;
          end;
        end;

        if (nSelfRangeTargetCount > 0) then begin
          if IsUseSkill8 then begin
            Result := 8; //���ܻ�
            Exit;
          end;
        end;
        if (nSelfRangeTargetCount < 10) then begin
          if (nRangeTargetCountByDir >= 4) then begin
            if QuickLighting then begin
              Result := 10; //�����Ӱ
              Exit;
            end;
          end;
        end else begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
            if UseFireCross then begin
              Result := 22; //��ǽ
              Exit;
            end;
          end else begin
            if nRangeTargetCountByDir > 1 then begin
              if UseFireCross then begin
                Result := 22; //��ǽ
                Exit;
              end;
            end;
          end;

          case Random(7) of
            0, 1: begin
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 4) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if QuickLighting and (nRangeTargetCountByDir >= 3) then begin
                  Result := 10; //�����Ӱ
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            2, 3: begin
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            4, 5: begin
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            6, 7: begin
                if QuickLighting and (nRangeTargetCountByDir >= 3) then begin
                  Result := 10; //�����Ӱ
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
          end;
        end;

        if (nSelfRangeTargetCount >= 1) then begin //�������Χ
          if AllowUseMagic(24) and ((m_TargetCret.m_btRaceServer = 101) or (m_TargetCret.m_btRaceServer = 102) or (m_TargetCret.m_btRaceServer = 104)) then begin //����ϵ����
            Result := 24; //�����׹�
            Exit;
          end;

          if QuickLighting and (nRangeTargetCountByDir >= 3) then begin
            Result := 10; //�����Ӱ
            Exit;
          end;

          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
            if AllowUseMagic(33) and (nSelfRangeTargetCount >= 2) then begin
              Result := 33; //������
              Exit;
            end;
          end else begin
            if AllowUseMagic(33) and (nSelfRangeTargetCount >= 5) then begin
              Result := 33; //������
              Exit;
            end;
          end;

          if AllowUseMagic(37) then begin
            Result := 37; //Ⱥ���׵���
            Exit;
          end;

          if AllowUseMagic(45) then begin
            Result := 45; //�����
            Exit;
          end;

          if AllowUseMagic(23) then begin
            Result := 23; //���ѻ���
            Exit;
          end;

          if AllowUseMagic(47) then begin
            Result := 47; //������
            Exit;
          end;

          if AllowUseMagic(24) then begin
            Result := 24; //�����׹�
            Exit;
          end;
        end;

        if nRangeTargetCount > 1 then begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
            if UseFireCross then begin
              Result := 22; //��ǽ
              Exit;
            end;
          end else begin
            if nRangeTargetCountByDir > 1 then begin
              if UseFireCross then begin
                Result := 22; //��ǽ
                Exit;
              end;
            end;
          end;
          case Random(7) of
            0, 1: begin
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if QuickLighting and (nRangeTargetCountByDir >= 3) then begin
                  Result := 10; //�����Ӱ
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            2, 3: begin
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            4, 5: begin
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
            6, 7: begin
                if QuickLighting and (nRangeTargetCountByDir >= 3) then begin
                  Result := 10; //�����Ӱ
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37; //Ⱥ���׵���
                  Exit;
                end;
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end;
                if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                  if AllowUseMagic(33) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end else begin
                  if AllowUseMagic(33) and (nRangeTargetCount >= 5) then begin
                    Result := 33; //������
                    Exit;
                  end;
                end;
                if AllowUseMagic(45) then begin
                  Result := 45; //�����
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47; //������
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                  Result := 11; //�׵���
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                  Result := 5; //�����
                  Exit;
                end;
                if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                  Result := 1; //������
                  Exit;
                end;
              end;
          end;
        end;

        case Random(7) of
          0, 1: begin
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                Result := 11; //�׵���
                Exit;
              end;
              if QuickLighting then begin
                Result := 10; //�����Ӱ
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                Result := 5; //�����
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                Result := 1; //������
                Exit;
              end;
              if AllowUseMagic(37) then begin
                Result := 37; //Ⱥ���׵���
                Exit;
              end;
              if AllowUseMagic(23) then begin
                Result := 23; //���ѻ���
                Exit;
              end;
              if AllowUseMagic(33) then begin
                Result := 33; //������
                Exit;
              end;
              if AllowUseMagic(45) then begin
                Result := 45; //�����
                Exit;
              end;
              if AllowUseMagic(47) then begin
                Result := 47; //������
                Exit;
              end;
              if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                if UseFireCross then begin
                  Result := 22; //��ǽ
                  Exit;
                end;
              end else begin
                if nRangeTargetCountByDir > 1 then begin
                  if UseFireCross then begin
                    Result := 22; //��ǽ
                    Exit;
                  end;
                end;
              end;
            end;
          2, 3: begin
              if AllowUseMagic(45) then begin
                Result := 45; //�����
                Exit;
              end;
              if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                if UseFireCross then begin
                  Result := 22; //��ǽ
                  Exit;
                end;
              end else begin
                if nRangeTargetCountByDir > 1 then begin
                  if UseFireCross then begin
                    Result := 22; //��ǽ
                    Exit;
                  end;
                end;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                Result := 5; //�����
                Exit;
              end;

              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                Result := 11; //�׵���
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                Result := 1; //������
                Exit;
              end;
              if AllowUseMagic(37) then begin
                Result := 37; //Ⱥ���׵���
                Exit;
              end;
              if AllowUseMagic(23) then begin
                Result := 23; //���ѻ���
                Exit;
              end;
              if AllowUseMagic(33) then begin
                Result := 33; //������
                Exit;
              end;

              if AllowUseMagic(47) then begin
                Result := 47; //������
                Exit;
              end;
            end;

          4, 5: begin
              if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                if UseFireCross then begin
                  Result := 22; //��ǽ
                  Exit;
                end;
              end else begin
                if nRangeTargetCountByDir > 1 then begin
                  if UseFireCross then begin
                    Result := 22; //��ǽ
                    Exit;
                  end;
                end;
              end;

              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                Result := 11; //�׵���
                Exit;
              end;

              if AllowUseMagic(45) then begin
                Result := 45; //�����
                Exit;
              end;

              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                Result := 5; //�����
                Exit;
              end;

              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                Result := 1; //������
                Exit;
              end;

              if AllowUseMagic(37) then begin
                Result := 37; //Ⱥ���׵���
                Exit;
              end;

              if AllowUseMagic(23) then begin
                Result := 23; //���ѻ���
                Exit;
              end;

              if AllowUseMagic(33) then begin
                Result := 33; //������
                Exit;
              end;

              if AllowUseMagic(47) then begin
                Result := 47; //������
                Exit;
              end;
            end;
          6, 7: begin
              if QuickLighting then begin
                Result := 10; //�����Ӱ
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
                Result := 11; //�׵���
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
                Result := 5; //�����
                Exit;
              end;
              if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
                Result := 1; //������
                Exit;
              end;
              if AllowUseMagic(37) then begin
                Result := 37; //Ⱥ���׵���
                Exit;
              end;
              if AllowUseMagic(23) then begin
                Result := 23; //���ѻ���
                Exit;
              end;
              if AllowUseMagic(33) then begin
                Result := 33; //������
                Exit;
              end;
              if AllowUseMagic(45) then begin
                Result := 45; //�����
                Exit;
              end;
              if AllowUseMagic(47) then begin
                Result := 47; //������
                Exit;
              end;
              if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) then begin
                if UseFireCross then begin
                  Result := 22; //��ǽ
                  Exit;
                end;
              end else begin
                if nRangeTargetCountByDir > 1 then begin
                  if UseFireCross then begin
                    Result := 22; //��ǽ
                    Exit;
                  end;
                end;
              end;
            end;
        end;

        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(11) then begin
          Result := 11; //�׵���
          Exit;
        end;
        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(5) then begin
          Result := 5; //�����
          Exit;
        end;
        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and AllowUseMagic(1) then begin
          Result := 1; //������
          Exit;
        end;
        if QuickLighting then begin
          Result := 10; //�����Ӱ
          Exit;
        end;
        if AllowUseMagic(37) then begin
          Result := 37; //Ⱥ���׵���
          Exit;
        end;
        if AllowUseMagic(23) then begin
          Result := 23; //���ѻ���
          Exit;
        end;
        if AllowUseMagic(33) then begin
          Result := 33; //������
          Exit;
        end;
        if AllowUseMagic(45) then begin
          Result := 45; //�����
          Exit;
        end;
        if AllowUseMagic(47) then begin
          Result := 47; //������
          Exit;
        end;
        if UseFireCross then begin
          Result := 22; //��ǽ
          Exit;
        end;
      end;
    2: begin //��ʿ
        nCode := 0;
        if m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.8) then begin
          if GetTickCount - m_SkillUseTick[29] > 5000 then begin
            if m_nIncSelfHealthCount <= 3 then begin
              if AllowUseMagic(2) and AllowUseMagic(29) then begin
                nCode := 9;
                if GetRangeTargetCount(m_nCurrX, m_nCurrY, 3) > 1 then begin//Ⱥ��������
                  m_boSelSelf := True;
                  Inc(m_nIncSelfHealthCount);
                  Result := 29;
                  m_SkillUseTick[29]:= GetTickCount();
                end else begin
                  m_boSelSelf := True;
                  Inc(m_nIncSelfHealthCount);
                  Result := 2;
                  m_SkillUseTick[29]:= GetTickCount();
                end;
                Exit;
              end;
              nCode := 10;
              if AllowUseMagic(29) then begin //ʹ��Ⱥ��������
                m_boSelSelf := True;
                Inc(m_nIncSelfHealthCount);
                Result := 29;
                m_SkillUseTick[29]:= GetTickCount();
                Exit;
              end;
              nCode := 11;
              if AllowUseMagic(2) then begin //ʹ��������
                m_boSelSelf := True;
                Inc(m_nIncSelfHealthCount);
                Result := 2;
                m_SkillUseTick[29]:= GetTickCount();
                Exit;
              end;
            end else begin
              m_SkillUseTick[29] := GetTickCount;
              m_nIncSelfHealthCount := 0;
            end;
          end;
        end;
        nCode := 12;
        if m_Master <> nil then
          boVisibleActors := FindVisibleActors(m_Master);
        nCode := 13;
        if (m_Master <> nil) and boVisibleActors then begin
          if m_Master.m_WAbil.HP <= Round(m_Master.m_WAbil.MaxHP * 0.8) then begin //ʹ��������
            if GetTickCount - m_SkillUseTick[2] > 5000 then begin
              if m_nIncMasterHealthCount <= 3 then begin
                if AllowUseMagic(2) and AllowUseMagic(29) then begin
                  nCode := 14;
                  if GetRangeTargetCount(m_Master.m_nCurrX, m_Master.m_nCurrY, 3) > 1 then begin
                    m_boSelSelf := False;
                    Inc(m_nIncMasterHealthCount);
                    Result := 29;
                    m_SkillUseTick[2]:= GetTickCount();
                  end else begin
                    m_boSelSelf := False;
                    Inc(m_nIncMasterHealthCount);
                    Result := 2;
                    m_SkillUseTick[2]:= GetTickCount();
                  end;
                  Exit;
                end;
                nCode := 15;
                if AllowUseMagic(29) then begin {ʹ��Ⱥ��������}
                  m_boSelSelf := False;
                  Inc(m_nIncMasterHealthCount);
                  Result := 29;
                  m_SkillUseTick[2]:= GetTickCount();
                  Exit;
                end;
                nCode := 16;
                if AllowUseMagic(2) then begin {ʹ��������}
                  m_boSelSelf := False;
                  Inc(m_nIncMasterHealthCount);
                  Result := 2;
                  m_SkillUseTick[2]:= GetTickCount();
                  Exit;
                end;
              end else begin
                m_nIncMasterHealthCount := 0;
                m_SkillUseTick[2] := GetTickCount;
              end;
            end;
          end;
        end;

        nCode := 1;
        //IF m_TargetCret <> nil then
        nRangeTargetCount := GetRangeTargetCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3);
        nCode := 2;
        nSelfRangeTargetCount := GetNearTargetCount;
        nCode := 3;

        if (FindMagic(30) = nil) and AllowUseMagic(72) and ((GetMoonSlaveCount <= 0) or GetMoonSlaveDeath) then begin
          m_boSelSelf := True;
          Result := 72; //�ٻ�����
          Exit;
        end;
        if (FindMagic(72) = nil) and AllowUseMagic(30) and CheckUserItem(5, 5) and ((GetSlaveCount <= 0) or GetSlaveDeath) and (GetTickCount - m_SkillUseTick[30] > 5000) then begin
          m_boSelSelf := True;
          Result := 30; //�ٻ�����
          Exit;
        end;
        nCode := 7;

        if AllowUseMagic(15) and (m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and CheckUserItem(5, 1) then begin // {ʹ����ʥս����}
          m_boSelSelf := True;
          Result := 15;
          Exit;
        end;
        nCode := 18;
        if AllowUseMagic(14) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and CheckUserItem(5, 1) then begin // {�����}
          m_boSelSelf := True;
          Result := 14;
          Exit;
        end;

        nCode := 19;
        if (m_Master <> nil) and boVisibleActors then begin
          if AllowUseMagic(15) and (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and CheckUserItem(5, 1) then begin // {ʹ����ʥս����}
            m_boSelSelf := False;
            Result := 15;
            Exit;
          end;
          if AllowUseMagic(14) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and CheckUserItem(5, 1) then begin // {�����}
            m_boSelSelf := False;
            Result := 14;
            Exit;
          end;
        end;

        if (m_dwStatusArrTimeOutTick[2] <= 0) and AllowUseMagic(50) and (GetTickCount - m_SkillUseTick[50] >= g_Config.nAbilityUpTick * 1000) then begin {�޼�����}
          m_boSelSelf := True;
          m_SkillUseTick[50] := GetTickCount;
          Result := 50;
          Exit;
        end;

        nCode := 8;
        if (nSelfRangeTargetCount >= 1) and IsUseSkill48 then begin
          Result := 48; //������
          Exit;
        end;

        if (GetTickCount - m_SkillUseTick[34] > 5000) and AllowUseMagic(34) and ((m_wStatusTimeArr[POISON_DECHEALTH] > 0) or (m_wStatusTimeArr[POISON_DAMAGEARMOR] > 0)) then begin // {ʹ�ýⶾ��}
          m_boSelSelf := True;
          Result := 34; // ʹ�ýⶾ��
          Exit;
        end;

        if (GetTickCount - m_SkillUseTick[34] > 5000) and (m_Master <> nil) and boVisibleActors then begin
          if AllowUseMagic(34) and ((m_Master.m_wStatusTimeArr[POISON_DECHEALTH] > 0) or (m_Master.m_wStatusTimeArr[POISON_DAMAGEARMOR] > 0)) then begin // {ʹ�ýⶾ��}
            m_boSelSelf := False;
            Result := 34; //ʹ�ýⶾ��
            Exit;
          end;
        end;

        nCode := 20;
        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and
          (m_TargetCret.m_btRaceServer in [RC_PLAYOBJECT, RC_HEROOBJECT, RC_PLAYMOSTER])
          and AllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0)
          and CheckUserItem(3, 3) then begin {������}
          Result := 52;
          Exit;
        end;
        nCode := 21;

        if IsUseSkill38 then begin
          Result := 38;
          Exit;
        end;

        if AllowUseMagic(6) and CheckUserItem(1, 1) and (m_TargetCret <> nil) and
          (not m_TargetCret.m_boDeath) and (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and
          (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153])) then begin
          m_nSelItemType := 1;
          Result := 6;//ʩ����
          Exit;
        end;
        if AllowUseMagic(6) and CheckUserItem(2, 1) and (m_TargetCret <> nil) and
          (not m_TargetCret.m_boDeath) and (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) and
          (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153])) then begin
          m_nSelItemType := 2;
          Result := 6;//ʩ����
          Exit;
        end;

        if (GetTickCount - m_SkillUseTick[59] > 5000) and (m_TargetCret <> nil) and
          (not m_TargetCret.m_boDeath) then begin
          if AllowUseMagic(59) and CheckUserItem(5, 1) then begin //��Ѫ��
            m_boSelSelf := False;
            Result := 59;
            Exit;
          end;
        end;
        if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) then begin
          if AllowUseMagic(13) and CheckUserItem(5, 1) then begin //�����
            m_boSelSelf := False;
            Result := 13;
            Exit;
          end;
        end;
      end;
  end;
end;    *)

function TAIPlayObject.CanAttack(nCurrX, nCurrY: Integer; BaseObject: TBaseObject; nRange: Integer; var btDir: Byte): Boolean;
var
  I: Integer;
  nX, nY: Integer;
begin
  Result := False;
  btDir := GetNextDirection(nCurrX, nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
  for I := 1 to nRange do begin
    if not m_PEnvir.GetNextPosition(nCurrX, nCurrY, btDir, I, nX, nY) then Break;
    if (BaseObject.m_nCurrX = nX) and (BaseObject.m_nCurrY = nY) then begin
      Result := True;
      Break;
    end;
  end;
end;

function TAIPlayObject.CanAttack(BaseObject: TBaseObject; nRange: Integer; var btDir: Byte): Boolean;
var
  I: Integer;
  nX, nY: Integer;
begin
  Result := False;
  btDir := GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
  for I := 1 to nRange do begin
    if not m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, btDir, I, nX, nY) then Break;
    if (BaseObject.m_nCurrX = nX) and (BaseObject.m_nCurrY = nY) then begin
      Result := True;
      Break;
    end;
  end;
end;
//1 Ϊ����� 2 Ϊ��ҩ
function TAIPlayObject.IsUseAttackMagic(): Boolean; //����Ƿ����ʹ�ù���ħ��
var
  UserMagic: pTUserMagic;
  I: Integer;
begin
  Result := False;
  case m_btJob of
    0: Result := True;
    1: begin
        for I := 0 to m_MagicList.Count - 1 do begin
          UserMagic := m_MagicList.Items[I];
          case UserMagic.wMagIdx of
            SKILL_FIREBALL {1},
              SKILL_FIREBALL2,
              SKILL_FIRE,
              SKILL_SHOOTLIGHTEN,
              SKILL_LIGHTENING,
              SKILL_EARTHFIRE,
              SKILL_FIREBOOM,
              SKILL_LIGHTFLOWER,
              SKILL_SNOWWIND,
              SKILL_GROUPLIGHTENING,
              SKILL_47,
              SKILL_58: begin
                if GetSpellPoint(UserMagic) <= m_WAbil.MP then begin
                  Result := True;
                  Break;
                end;
              end;
          end;
        end;
      end;
    2: begin
        for I := 0 to m_MagicList.Count - 1 do begin
          UserMagic := m_MagicList.Items[I];
          if UserMagic.MagicInfo.btJob in [2, 99] then begin
            case UserMagic.wMagIdx of
              SKILL_AMYOUNSUL {6 ʩ����}, SKILL_GROUPAMYOUNSUL {38 Ⱥ��ʩ����}: begin //��Ҫ��ҩ
                  Result := CheckUserItem(1, 2) or CheckUserItem(2, 2);
                  if Result then begin
                    Result := AllowUseMagic(SKILL_AMYOUNSUL) or AllowUseMagic(SKILL_GROUPAMYOUNSUL);
                  end;
                  if Result then Break;
                end;
              SKILL_FIRECHARM: begin //��Ҫ��
                  Result := CheckUserItem(5, 1);
                  if Result then begin
                    Result := AllowUseMagic(SKILL_FIRECHARM);
                  end;
                  if Result then Break;
                end;
              SKILL_59: begin //��Ҫ��
                  Result := CheckUserItem(5, 5);
                  if Result then begin
                    Result := AllowUseMagic(SKILL_59);
                  end;
                  if Result then Break;
                end;
            end;
          end;
        end;
      end;
  end;
end;

function TAIPlayObject.UseSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  nSpellPoint: Integer;
  n14: Integer;
  BaseObject: TBaseObject;
  boIsWarrSkill: Boolean;
begin
  Result := False;
  if not m_boCanSpell then Exit;

  if m_boDeath or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0) or (m_wStatusArrValue[23] <> 0) then Exit;//����
  if UserMagic.wMagIdx <> SKILL_102 then
     if (m_wStatusTimeArr[POISON_STONE] <> 0) and not g_ClientConf.boParalyCanSpell then Exit;//����
  if m_PEnvir <> nil then begin
    if m_PEnvir.m_boNOSKILL then Exit;
    if not m_PEnvir.AllowMagics(UserMagic.MagicInfo.sMagicName) then Exit;
  end;
  boIsWarrSkill := MagicManager.IsWarrSkill(UserMagic.wMagIdx); //�Ƿ���սʿ����

  Dec(m_nSpellTick, 450);
  m_nSpellTick := _MAX(0, m_nSpellTick);

  case UserMagic.wMagIdx of //
    SKILL_ERGUM{12}: begin //��ɱ����
        if m_MagicErgumSkill <> nil then begin
          if not m_boUseThrusting then begin
            ThrustingOnOff(True);
          end else begin
            ThrustingOnOff(False);
          end;
        end;
        Result := True;
      end;
    SKILL_89{89}: begin //�ļ���ɱ
        if m_Magic89Skill <> nil then begin
          if not m_boUseThrusting then begin
            ThrustingOnOff(True);
          end else begin
            ThrustingOnOff(False);
          end;
        end;
        Result := True;
      end;
    SKILL_BANWOL{25}: begin //�����䵶
        if m_MagicBanwolSkill <> nil then begin
          if not m_boUseHalfMoon then begin
            HalfMoonOnOff(True, 0);
          end else begin
            HalfMoonOnOff(False, 0);
          end;
        end;
        Result := True;
      end;
    SKILL_90{90}: begin//Բ���䵶(�ļ������䵶)
      if m_Magic90Skill <> nil then begin
        if not m_boUseHalfMoon then begin
          HalfMoonOnOff(True, 1);
        end else begin
          HalfMoonOnOff(False, 1);
        end;
      end;
      Result := True;
    end;
    SKILL_FIRESWORD {26}: begin //�һ𽣷�
        if m_MagicFireSwordSkill <> nil then begin
          if AllowFireHitSkill then begin
            {nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end; }
          end;
          Result := True;
        end;
      end;
    SKILL_74 :begin////���ս��� 20080511
        if m_Magic74Skill <> nil then begin
          if AllowDailySkill then begin
            {nSpellPoint := GetSpellPoint(m_Magic74Skill);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
              end;
            end;}
          end;
          Result := True;
        end;
      end;
    SKILL_MOOTEBO {27}: begin //Ұ����ײ
        Result := True;
        if (GetTickCount - m_dwDoMotaeboTick) > 3000 then begin
          m_dwDoMotaeboTick := GetTickCount();
          if GetAttackDir(TargeTBaseObject,m_btDirection) then begin//�޸�Ұ����ײ�ķ���
            {nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
              DoMotaebo(m_btDirection, UserMagic.btLevel);
            end;}
            DoMotaebo(m_btDirection, UserMagic.btLevel);
          end;
        end;
      end;
    SKILL_40: begin //˫��ն ���µ���
        if m_MagicCrsSkill <> nil then begin
          if not m_boCrsHitkill then begin
            SkillCrsOnOff(True);
          end else begin
            SkillCrsOnOff(False);
          end;
        end;
        Result := True;
      end;
    SKILL_42: begin //����ն
        if m_Magic42Skill <> nil then begin
          if Skill42OnOff then begin
            {nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;}
          end;
        end;
        Result := True;
      end;
    SKILL_43: begin //��Ӱ����
        if m_Magic43Skill <> nil then begin
          if Skill43OnOff then begin//20080619
            {nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;}
          end;
        end;
        Result := True;
     end;
  else begin
      n14 := GetNextDirection(m_nCurrX, m_nCurrY, nTargetX, nTargetY);
      m_btDirection := n14;
      BaseObject := nil;
      //���Ŀ���ɫ����Ŀ��������Χ���������Χ��������Ŀ������
      if UserMagic.wMagIdx in [60..65] then begin //����Ǻϻ�����Ŀ��
        if CretInNearXY(TargeTBaseObject, nTargetX, nTargetY, 6) then begin
          BaseObject := TargeTBaseObject;
          nTargetX := BaseObject.m_nCurrX;
          nTargetY := BaseObject.m_nCurrY;
        end;
      end else begin
        case UserMagic.wMagIdx of
          SKILL_HEALLING {2}, SKILL_HANGMAJINBUB {14}, SKILL_DEJIWONHO {15},
          SKILL_BIGHEALLING {29}, SKILL_SINSU, {30} SKILL_UNAMYOUNSUL,
          SKILL_46: begin
              if m_boSelSelf then begin
                BaseObject := Self;
                nTargetX := m_nCurrX;
                nTargetY := m_nCurrY;
              end else begin
                if m_Master <> nil then begin
                  BaseObject := m_Master;
                  nTargetX := m_Master.m_nCurrX;
                  nTargetY := m_Master.m_nCurrY;
                end else begin
                  BaseObject := Self;
                  nTargetX := m_nCurrX;
                  nTargetY := m_nCurrY;
                end;
              end;
            end;
        else begin
            if CretInNearXY(TargeTBaseObject, nTargetX, nTargetY) then begin
              BaseObject := TargeTBaseObject;
              nTargetX := BaseObject.m_nCurrX;
              nTargetY := BaseObject.m_nCurrY;
            end;
          end;
        end;
      end;

      if not AutoSpell(UserMagic, nTargetX, nTargetY, BaseObject) then begin
        SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
      end;
      Result := True;
    end;
  end;
end;

function TAIPlayObject.AutoSpell(UserMagic: pTUserMagic; nTargetX,
  nTargetY: Integer; BaseObject: TBaseObject): Boolean;
var
  nSpellPoint: Integer;
begin
  Result := False;
  try
    if BaseObject <> nil then
      if (BaseObject.m_boGhost) or (BaseObject.m_boDeath) or (BaseObject.m_WAbil.HP <=0) then Exit;
    if not MagicManager.IsWarrSkill(UserMagic.wMagIdx) then begin
      Result := MagicManager.DoSpell(Self, UserMagic, nTargetX, nTargetY, BaseObject);
      m_dwHitTick := GetTickCount();
    end;
  except
    on E: Exception do begin             
      MainOutMessage(Format('{%s} TAIPlayObject.AutoSpell MagID:%d X:%d Y:%d', [g_sExceptionVer, UserMagic.wMagIdx, nTargetX, nTargetY]));
    end;
  end;
end;

(*
function TAIPlayObject.WarrAttackTarget(wMagIdx, wHitMode: Word): Boolean; {������}
var
  bt06: Byte;
  nRange: Integer;
  UserMagic: pTUserMagic;
begin
  Result := False;
  if m_TargetCret <> nil then begin
    nRange := 1;
    if (wMagIdx = 43) or (wMagIdx = SKILL_74) then nRange := 4;
    if (wMagIdx = 12) then nRange := 2;
    if (wMagIdx in [60, 61, 62]) then nRange := 12;

    if CanAttack(m_TargetCret, nRange, bt06) then begin
      m_dwTargetFocusTick := GetTickCount();
      if m_btRaceServer = RC_HEROOBJECT then begin //�ϻ�
        case wMagIdx of
          60: begin
              m_Master.m_btDirection := GetNextDirection(m_Master.m_nCurrX, m_Master.m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
              m_Master.AttackDir(m_TargetCret, wHitMode, m_Master.m_btDirection);
            end;
          61: begin
              if m_btJob = 0 then begin
                UserMagic := THeroObject(Self).FindGroupMagic;
                if UserMagic = nil then Exit;
                MagicManager.DoSpell(m_Master, UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
              end;
            end;
          62: begin
              if m_btJob = 0 then begin
                UserMagic := THeroObject(Self).FindGroupMagic;
                if UserMagic = nil then Exit;
                MagicManager.DoSpell(m_Master, UserMagic, m_nCurrX, m_nCurrY, m_TargetCret);
              end;
            end;
        end;
      end; 
      AttackDir(m_TargetCret, wHitMode, bt06);
      BreakHolySeizeMode();
      Result := True;
    end else begin
      if m_TargetCret.m_PEnvir = m_PEnvir then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end else begin
        DelTargetCreat();
      end;
    end;
  end;
end;

function TAIPlayObject.WarrorAttackTarget(wMagIdx: Word): Boolean; {սʿ����}
var
  UserMagic: pTUserMagic;
begin
  Result := False;
  m_wHitMode := 0;
  if wMagIdx > 0 then begin
    UserMagic := FindMagic(wMagIdx);
    if UserMagic <> nil then begin
      case wMagIdx of
        27, 39, 41: begin
            Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //սʿħ��
            Exit;
          end;
        61..65: begin //�ϻ�
            if m_btJob <> 0 then begin
              Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret);
              Exit;
            end;
          end;
      end;
      case wMagIdx of
         7: m_wHitMode := 3; //��ɱ
        12: m_wHitMode := 4; //ʹ�ô�ɱ
        SKILL_89: m_wHitMode := 15;//�ļ���ɱ
        25: m_wHitMode := 5; //ʹ�ð���
        SKILL_90: m_wHitMode := 16;//Բ���䵶(�ļ������䵶)
        26: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 7; //ʹ���һ�
        40: m_wHitMode := 8; //���µ���
        43: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 9; //����ն  20100910 �޸�
        42: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 12;//��Ӱ���� 20100910 �޸�
        SKILL_74: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 13;//���ս��� 20100910 �޸�
        SKILL_96: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 17;//Ѫ��һ��(ս)
      end;
    end;
  end;
  Result := WarrAttackTarget(wMagIdx, m_wHitMode);
end;

function TAIPlayObject.WizardAttackTarget(wMagIdx: Word): Boolean; {��ʦ����}
var
  UserMagic: pTUserMagic;
begin
  Result := False;
  m_wHitMode := 0;
  if wMagIdx > 0 then begin
    UserMagic := FindMagic(wMagIdx);
    if UserMagic <> nil then begin
      Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
      m_dwHitTick := GetTickCount();
      Exit;
    end;
  end else Result := WarrAttackTarget(wMagIdx, m_wHitMode);
end;

function TAIPlayObject.TaoistAttackTarget(wMagIdx: Word): Boolean; {��ʿ����}
var
  UserMagic: pTUserMagic;
  nIndex, nCount: Integer;
begin
  Result := False;
  m_wHitMode := 0;
  if wMagIdx > 0 then begin
    case wMagIdx of
      SKILL_AMYOUNSUL{6},SKILL_93, SKILL_GROUPAMYOUNSUL{38}: begin //����
          if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and (GetUserItemList(1,1)>= 0) then begin//�̶�
            n_AmuletIndx:= 1;//�̶���ʶ
          end else
          if (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) and (GetUserItemList(2,1)>= 0)  then  begin//�춾
            n_AmuletIndx:= 2;//�춾��ʶ
          end else n_AmuletIndx:= 0;
        end;
    end;
    UserMagic := FindMagic(wMagIdx);
    if UserMagic <> nil then begin
      Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
      Exit;
    end;
  end else Result := WarrAttackTarget(wMagIdx, m_wHitMode);
end;          *)
(*
function TAIPlayObject.StartAttack(wMagIdx: Word): Boolean;
resourcestring
  sExceptionMsg = '{%s} TAIPlayObject::StartAttack Race=%d MagIdx=%d';
begin
  Result := False;
  try
    m_dwTargetFocusTick := GetTickCount();
    if (m_TargetCret <> nil) then begin
      if InSafeZone then begin//���밲ȫ���ھͲ���PKĿ��
        if (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) then begin
          m_TargetCret:= nil;
          {$IF M2Version = 1}
          HeroBatterStop;//Ӣ������ֹͣ
          {$IFEND}
          Exit;
        end;
      end;
      if (m_TargetCret = self) or (m_TargetCret = m_MyHero) or (m_TargetCret.m_boDeath)
        or (m_TargetCret.m_boGhost) then begin
        m_TargetCret:= nil;
        Exit;
      end;
    end;
    {$IF M2Version = 1}
    if HeroBatterAttackTarget then begin
      m_dwHitTick := GetTickCount();
      Result := True;
      Exit;
    end;
    {$IFEND}
    case m_btJob of
      0: begin
          Result := WarrorAttackTarget(wMagIdx);
        end;
      1: begin
          Result := WizardAttackTarget(wMagIdx);
        end;
      2: begin
          Result := TaoistAttackTarget(wMagIdx);
        end;
    end;
    if Result then Inc(m_RunPos.nAttackCount);
  except
    MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, m_btRaceServer, wMagIdx]));
  end;
end;     *)

function TAIPlayObject.DoThink(wMagicID: Word): Integer;
  function CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
  var
    BaseObject: TBaseObject;
    I, nC, n10: Integer;
  begin
    Result := 0;
    try
      n10 := nRange;
      if m_VisibleActors.Count > 0 then begin
        for I := 0 to m_VisibleActors.Count - 1 do begin
          BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
          if BaseObject <> nil then begin
            if not BaseObject.m_boDeath then begin
              if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
                nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
                if nC <= n10 then begin
                  Inc(Result);
                end;
              end;
            end;
          end;
        end;
      end;
    except
    end;
  end;
  function TargetNeedRunPos(): Boolean;
  begin
    Result := (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = 108)
      or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER);
  end;
  function CanRunPos(nAttackCount: Integer): Boolean;
  begin
    Result := (m_RunPos.nAttackCount >= nAttackCount);
  end;
  function MotaeboPos(): Boolean; //��ȡҰ����ײ
  var
    nTargetX, nTargetY: Integer;
    btNewDir: Byte;
  begin
    Result := False;
    if (wMagicID = 27) and (m_Master <> nil) and (m_TargetCret <> nil) and AllowUseMagic(27) and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (GetTickCount - m_SkillUseTick[27] > 1000 * 10) then begin
      btNewDir := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
      if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
        Result := m_PEnvir.CanWalk(nTargetX, nTargetY, True);
      end;
    end;
  end;
  function MagPushArround(MagicID: Integer): Boolean;
  var
    I: Integer;
    ActorObject: TBaseObject;
    btNewDir: Byte;
    nTargetX, nTargetY: Integer;
  begin
    Result := False;
    if (m_TargetCret <> nil) and (m_Abil.Level > m_TargetCret.m_Abil.Level) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 1) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 1) then begin
      btNewDir := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
      if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
        Result := m_PEnvir.CanWalk(nTargetX, nTargetY, True);
      end;
      if Result then Exit;
    end;
    if wMagicID = MagicID then begin
      for I := 0 to m_VisibleActors.Count - 1 do begin
        ActorObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
        if (abs(m_nCurrX - ActorObject.m_nCurrX) <= 1) and (abs(m_nCurrY - ActorObject.m_nCurrY) <= 1) then begin
          if (not ActorObject.m_boDeath) and (ActorObject <> Self) and IsProperTarget(ActorObject) then begin
            if (m_Abil.Level > ActorObject.m_Abil.Level) and (not ActorObject.m_boStickMode) then begin
              btNewDir := GetNextDirection(ActorObject.m_nCurrX, ActorObject.m_nCurrY, m_nCurrX, m_nCurrY);
              if m_PEnvir.GetNextPosition(ActorObject.m_nCurrX, ActorObject.m_nCurrY, GetBackDir(btNewDir), 1, nTargetX, nTargetY) then begin
                if m_PEnvir.CanWalk(nTargetX, nTargetY, True) then begin
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
var
  btDir: Byte;
  nRange: Integer;
begin
  Result := -1;
  case m_btJob of
    0: begin
         //1=Ұ����ײ 2=�޷�������Ŀ����Ҫ�ƶ� 3=��λ
        if MotaeboPos then begin
          Result := 1;
        end else begin
          nRange := 1;
          if ((wMagicID = 43) and (m_n42kill= 2)) or (wMagicID = SKILL_74) then nRange := 4;
          if (wMagicID = 12) {$IF M2Version = 1}or m_boUseBatter{$IFEND} then nRange := 2;//��������
          if (wMagicID in [60]) then nRange := 6;
          Result := 2;
          if (wMagicID in [61, 62]) or CanAttack(m_TargetCret, nRange, btDir) then begin
            Result := 0;
          end;
          if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 2)) then begin
            if (Result = 0) and (not (wMagicID in [60, 61, 62])) then begin
              if TargetNeedRunPos then begin
                if CanRunPos(5) then Result := 5;
              end else begin
                if CanRunPos(20) then Result := 5;
              end;
            end;
            if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 6) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 6)) then begin
              Result := 2;
            end;
          end;
        end;
      end;
    1: begin
        if (wMagicID = 8) and MagPushArround(wMagicID) then Exit;
        //1=��� 2=׷�� 3=ħ��ֱ�߹�������Ŀ�� 4=�޷�������Ŀ����Ҫ�ƶ� 5=��λ
        if IsUseAttackMagic then begin
          if {GetNearTargetCount}CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 0 then begin
            Result := 1;
          end else
            if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 6) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 6)) then begin
            Result := 2;
          end else
            if (wMagicID in [SKILL_FIREBALL, SKILL_FIREBALL2]) and (not CanAttack(m_TargetCret, 10, btDir)) then begin
            Result := 3;
          end else
            if TargetNeedRunPos and CanRunPos(5) and ({GetNearTargetCount}CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 0) then begin
            Result := 5;
          end;
        end else begin
          if (not GetAttackDir(m_TargetCret, 1, btDir)) then begin
            Result := 4;
          end;
        end;
      end;
    2: begin
        if (wMagicID = 48) and MagPushArround(wMagicID) then Exit;
        //1=��� 2=׷�� 3=ħ��ֱ�߹�������Ŀ�� 4=�޷�������Ŀ����Ҫ�ƶ� 5=��λ
        if IsUseAttackMagic then begin
          if {GetNearTargetCount}CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 0 then begin
            Result := 1;
          end else
            if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 6) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 6)) then begin
            Result := 2;
          end else
            if (wMagicID = SKILL_FIRECHARM) and (not CanAttack(m_TargetCret, 10, btDir)) then begin
            Result := 3;
          end else
            if TargetNeedRunPos and CanRunPos(5) and ({GetNearTargetCount}CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 0) then begin
            Result := 5;
          end;
        end else begin
          if (not GetAttackDir(m_TargetCret, 1, btDir)) then begin
            Result := 4;
          end;
        end;
      end;
  end;
end;

function TAIPlayObject.ActThink(wMagicID: Word): Boolean;
  function FindGoodPathA(WalkStep: TWalkStep; nRange, nType: Integer): TMapWalkXY;
  var
    I: Integer;
    n10: Integer;
    nMastrRange: Integer;
    nMonCount: Integer;
    MapWalkXY, MapWalkXYA: pTMapWalkXY;
  begin
    n10 := High(Integer);
    MapWalkXY := nil;
    FillChar(Result, SizeOf(TMapWalkXY), 0);

    for I := DR_UP to DR_UPLEFT do begin
      if (WalkStep[I].nWalkStep > 0) and
        (abs(WalkStep[I].nX - m_TargetCret.m_nCurrX) >= nRange) and (abs(WalkStep[I].nY - m_TargetCret.m_nCurrY) >= nRange) then begin
        if (WalkStep[I].nMonCount < n10) then begin
          n10 := WalkStep[I].nMonCount;
          MapWalkXY := @WalkStep[I];
        end;
      end;
    end;

    if (MapWalkXY <> nil) and (m_Master <> nil) then begin
      nMonCount := MapWalkXY.nMonCount;
      nMastrRange := MapWalkXY.nMastrRange;
      n10 := High(Integer);
      MapWalkXYA := MapWalkXY;
      MapWalkXY := nil;
      for I := DR_UP to DR_UPLEFT do begin
        if (WalkStep[I].nWalkStep > 0) and (WalkStep[I].nMonCount <= nMonCount) and (abs(WalkStep[I].nX - m_TargetCret.m_nCurrX) >= nRange) and (abs(WalkStep[I].nY - m_TargetCret.m_nCurrY) >= nRange) then begin
          if (WalkStep[I].nMastrRange < n10) and (WalkStep[I].nMastrRange < nMastrRange) then begin
            n10 := WalkStep[I].nMastrRange;
            MapWalkXY := @WalkStep[I];
          end;
        end;
      end;
      if MapWalkXY = nil then MapWalkXY := MapWalkXYA;
    end;
    if MapWalkXY <> nil then Result := MapWalkXY^;
  end;
  function FindGoodPathB(WalkStep: TWalkStep; nType: Integer): TMapWalkXY;
  var
    I: Integer;
    n10: Integer;
    nMastrRange: Integer;
    nMonCount: Integer;
    MapWalkXY, MapWalkXYA: pTMapWalkXY;
  begin
    n10 := High(Integer);
    MapWalkXY := nil;
    FillChar(Result, SizeOf(TMapWalkXY), 0);

    for I := DR_UP to DR_UPLEFT do begin
      if (WalkStep[I].nWalkStep > 0) then begin
        if (WalkStep[I].nMonCount < n10) then begin
          n10 := WalkStep[I].nMonCount;
          MapWalkXY := @WalkStep[I];
        end;
      end;
    end;

    if (MapWalkXY <> nil) and (m_Master <> nil) then begin
      nMonCount := MapWalkXY.nMonCount;
      nMastrRange := MapWalkXY.nMastrRange;
      n10 := High(Integer);
      MapWalkXYA := MapWalkXY;
      MapWalkXY := nil;
      for I := DR_UP to DR_UPLEFT do begin
        if (WalkStep[I].nWalkStep > 0) and (WalkStep[I].nMonCount <= nMonCount) then begin
          if (WalkStep[I].nMastrRange < n10) and (WalkStep[I].nMastrRange < nMastrRange) then begin
            n10 := WalkStep[I].nMastrRange;
            MapWalkXY := @WalkStep[I];
          end;
        end;
      end;
      if MapWalkXY = nil then MapWalkXY := MapWalkXYA;
    end;
    if MapWalkXY <> nil then Result := MapWalkXY^;
  end;
  function FindMinRange(WalkStep: TWalkStep): TMapWalkXY;
  var
    I: Integer;
    n10: Integer;
    n1C: Integer;
    nMonCount: Integer;
    MapWalkXY, MapWalkXYA: pTMapWalkXY;
  begin
    n10 := High(Integer);
    n1C := 0;
    MapWalkXY := nil;
    FillChar(Result, SizeOf(TMapWalkXY), 0);

    for I := DR_UP to DR_UPLEFT do begin
      if (WalkStep[I].nWalkStep > 0) then begin
        n1C := abs(WalkStep[I].nX - m_TargetCret.m_nCurrX) + abs(WalkStep[I].nY - m_TargetCret.m_nCurrY);
        if (n1C < n10) then begin
          n10 := n1C;
          MapWalkXY := @WalkStep[I];
        end;
      end;
    end;

    if MapWalkXY <> nil then begin
      nMonCount := MapWalkXY.nMonCount;
      MapWalkXYA := MapWalkXY;
      MapWalkXY := nil;
      for I := DR_UP to DR_UPLEFT do begin
        if (WalkStep[I].nWalkStep > 0) and (WalkStep[I].nMonCount <= nMonCount) then begin
          n1C := abs(WalkStep[I].nX - m_TargetCret.m_nCurrX) + abs(WalkStep[I].nY - m_TargetCret.m_nCurrY);
          if (n1C <= n10) then begin
            n10 := n1C;
            MapWalkXY := @WalkStep[I];
          end;
        end;
      end;
      if MapWalkXY = nil then MapWalkXY := MapWalkXYA;
    end;

    if MapWalkXY <> nil then Result := MapWalkXY^;
  end;
  function CanWalkNextPosition(nX, nY, nRange: Integer; btDir: Byte; boFlag: Boolean): Boolean; //�����һ���ڲ��ڹ���λ
  var
    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;
    if m_PEnvir.GetNextPosition(nX, nY, btDir, 1, nCurrX, nCurrY) and
      CanMove(nX, nY, nCurrX, nCurrY, False) and
      (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) then begin
      Result := True;
      Exit;
    end;

    if m_PEnvir.GetNextPosition(nX, nY, btDir, 2, nCurrX, nCurrY) and
      CanMove(nX, nY, nCurrX, nCurrY, False) and
      (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) then begin
      Result := True;
      Exit;
    end;
  end;
  function FindPosOfSelf(WalkStep: pTWalkStep; nRange: Integer; boFlag: Boolean): Boolean;
  var
    I: Integer;
    btDir: Byte;

    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, nRange, nCurrX, nCurrY) and CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
  end;
  function _FindPosOfSelf(WalkStep: pTWalkStep; nRange: Integer; boFlag: Boolean): Boolean;
  var
    I: Integer;
    btDir: Byte;

    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, nRange, nCurrX, nCurrY) and CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) or CanWalkNextPosition(nCurrX, nCurrY, nRange, I, boFlag) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
  end;
  function FindPosOfTarget(WalkStep: pTWalkStep; nTargetX, nTargetY, nRange: Integer; boFlag: Boolean): Boolean;
  var
    I: Integer;
    btDir: Byte;
    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;
    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(nTargetX, nTargetY, I, nRange, nCurrX, nCurrY) and
        m_PEnvir.CanWalkEx(nCurrX, nCurrY, False) then begin
        if ((not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir)) and IsGotoXY(m_nCurrX, m_nCurrY, nCurrX, nCurrY) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - nTargetX) + abs(nCurrY - nTargetY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          WalkStep[I].nMonCount := GetRangeTargetCount(nCurrX, nCurrY, 2);
          Result := True;
        end;
      end;
    end;
  end;
  function FindPos(WalkStep: pTWalkStep; nRange: Integer; boFlag: Boolean): Boolean;
  var
    I: Integer;
    btDir: Byte;

    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, 2, nCurrX, nCurrY) and CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
    if Result then Exit;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, 1, nCurrX, nCurrY) and CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
  end;
  function _FindPos(WalkStep: pTWalkStep; nRange: Integer; boFlag: Boolean): Boolean;
  var
    I: Integer;
    btDir: Byte;

    nCurrX: Integer;
    nCurrY: Integer;
  begin
    Result := False;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, 1, nCurrX, nCurrY) and CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) or CanWalkNextPosition(nCurrX, nCurrY, nRange, I, boFlag) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
    if Result then Exit;

    FillChar(WalkStep^, SizeOf(TMapWalkXY) * 8, 0);
    for I := DR_UP to DR_UPLEFT do begin
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, I, 2, nCurrX, nCurrY) and
        CanMove(nCurrX, nCurrY, False) then begin
        if (not boFlag) or CanAttack(nCurrX, nCurrY, m_TargetCret, nRange, btDir) or CanWalkNextPosition(nCurrX, nCurrY, nRange, I, boFlag) then begin
          WalkStep[I].nWalkStep := nRange;
          WalkStep[I].nX := nCurrX;
          WalkStep[I].nY := nCurrY;
          WalkStep[I].nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
          WalkStep[I].nMonCount := GetNearTargetCount(nCurrX, nCurrY);
          WalkStep[I].nMastrRange := GetMasterRange(nCurrX, nCurrY);
          Result := True;
        end;
      end;
    end;
  end;
 (* function WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;//����Ŀ��
  var
    I: Integer;
    nDir: Integer;
    n10: Integer;
    n14: Integer;
    n20: Integer;
    nOldX: Integer;
    nOldY: Integer;
  begin
    Result := False;
    if (abs(nTargetX - m_nCurrX) > 1) or (abs(nTargetY - m_nCurrY) > 1) then begin
      n10 := nTargetX;
      n14 := nTargetY;
      nDir := DR_DOWN;
      if n10 > m_nCurrX then begin
        nDir := DR_RIGHT;
        if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
        if n14 < m_nCurrY then nDir := DR_UPRIGHT;
      end else begin
        if n10 < m_nCurrX then begin
          nDir := DR_LEFT;
          if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
          if n14 < m_nCurrY then nDir := DR_UPLEFT;
        end else begin
          if n14 > m_nCurrY then nDir := DR_DOWN
          else if n14 < m_nCurrY then nDir := DR_UP;
        end;
      end;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(nDir, False);
      if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
        Result := True;
        dwTick3F4 := GetTickCount();
      end;
      if not Result then begin
        n20 := Random(3);
        for I := DR_UP to DR_UPLEFT do begin
          if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
            if n20 <> 0 then Inc(nDir)
            else if nDir > 0 then Dec(nDir)
            else nDir := DR_UPLEFT;
            if (nDir > DR_UPLEFT) then nDir := DR_UP;
            WalkTo(nDir, False);
            if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
              Result := True;
              dwTick3F4 := GetTickCount();
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
  function RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;//�ܵ�Ŀ������
  var
    nDir, n10, n14: Integer;
  begin
    Result := False;
    if not m_boCanRun then Exit;//��ֹ��,���˳�
      n10 := nTargetX;
      n14 := nTargetY;
      nDir:= GetNextDirection(m_nCurrX , m_nCurrY, n10, n14);
      if not RunTo1(nDir, False, nTargetX, nTargetY) then begin
        Result := WalkToTargetXY(nTargetX, nTargetY);
      end else begin
        if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
          Result := True;
        end;
      end;
  end;     *)
  function WalkToRightPos(): Boolean;
  var
    I: Integer;
    boFlag: Boolean;
    nRange: Integer;
    WalkStep: TWalkStep;
    MapWalkXY: TMapWalkXY;
    nError: Integer;
  begin
    Result := False;
    try
      nError := 0;
      boFlag := (m_btRaceServer = 108) or (wMagicID in [SKILL_FIREBALL, SKILL_FIREBALL2, SKILL_FIRECHARM]) or (m_btJob = 0);
      if (m_btJob = 0) or (wMagicID <= 0) then begin
        nRange := 1;
        if ((wMagicID = 43) and (m_n42kill= 2)) or (wMagicID = SKILL_74) then nRange := 4;
        if (wMagicID = 12) then nRange := 2;
        if (wMagicID in [60, 61, 62]) then nRange := 6;
        nError := 1;
        for I := nRange downto 1 do begin
          nError := 25;
          if FindPosOfTarget(@WalkStep, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, I, boFlag) then begin
            nError := 26;
            MapWalkXY := FindGoodPathB(WalkStep, 0);
            nError := 27;
            if (MapWalkXY.nWalkStep > 0) then begin
              nError := 28;
              //if RunToTargetXY(MapWalkXY.nX, MapWalkXY.nY) then begin
              if GotoNext(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
                nError := 29;
                m_RunPos.btDirection := 0;
                Result := True;
                Exit;
              end;
            end;
          end;
        end;

        nError := 12;
        for I := 2 downto 1 do begin
          nError := 13;
          if FindPosOfSelf(@WalkStep, I, boFlag) then begin
            nError := 14;
            if m_Master <> nil then begin
              MapWalkXY := FindGoodPathB(WalkStep, 1);
            end else begin
              MapWalkXY := FindGoodPathB(WalkStep, 0);
            end;
            nError := 15;
            if (MapWalkXY.nWalkStep > 0) then begin
              nError := 16;
              //if RunToTargetXY(MapWalkXY.nX, MapWalkXY.nY) then begin
              if GotoNext(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
                nError := 17;
                m_RunPos.btDirection := 0;
                Result := True;
                Exit;
              end;
            end;
          end;
        end;
      end else begin
        if wMagicID > 0 then
          nRange := _MAX(Random(3), 2)
        else nRange := 1;
        boFlag := (m_btRaceServer = 108) or (wMagicID in [SKILL_FIREBALL, SKILL_FIREBALL2, SKILL_FIRECHARM]) or (nRange = 1);

        for I := 2 downto 1 do begin
          if FindPosOfSelf(@WalkStep, I, boFlag) then begin
            MapWalkXY := FindGoodPathA(WalkStep, nRange, 0);
            if (MapWalkXY.nWalkStep > 0) then begin
              if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
                m_RunPos.btDirection := 0;
                Result := True;
                Exit;
              end;
            end;
          end;
        end;

        for I := 2 downto 1 do begin
          if _FindPosOfSelf(@WalkStep, I, boFlag) then begin
            MapWalkXY := FindMinRange(WalkStep);
            if (MapWalkXY.nWalkStep > 0) then begin
              if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
                m_RunPos.btDirection := 0;
                Result := True;
                Exit;
              end;
            end;
          end;
        end;

        for I := nRange downto 1 do begin
          if FindPosOfTarget(@WalkStep, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, I, boFlag) then begin
            MapWalkXY := FindGoodPathB(WalkStep, 0);
            if (MapWalkXY.nWalkStep > 0) then begin
              if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
                m_RunPos.btDirection := 0;
                Result := True;
                Exit;
              end;
            end;
          end;
        end;
      end;
    except
      MainOutMessage('WalkToRightPos:' + m_sCharName + ' ' + IntToStr(nError));
    end;
  end;
  function AvoidTarget: Boolean;
  var
    I, II: Integer;
    nRange: Integer;
    btDir: Byte;
    nX, nY: Integer;
    boFlag: Boolean;
    WalkStep: TWalkStep;
    MapWalkXY: TMapWalkXY;
  begin
    Result := False;
    nRange := _MAX(Random(3), 2);

    boFlag := (m_btRaceServer = 108) or (wMagicID in [SKILL_FIREBALL, SKILL_FIREBALL2, SKILL_FIRECHARM]);
    for I := nRange downto 1 do begin
      if FindPosOfSelf(@WalkStep, I, boFlag) then begin
        MapWalkXY := FindGoodPathB(WalkStep, 0);
        if (MapWalkXY.nWalkStep > 0) then begin
          btDir := GetNextDirection(m_nCurrX, m_nCurrY, MapWalkXY.nX, MapWalkXY.nY);
          if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
            if (m_btRaceServer <> 108) then begin
              for II := nRange downto 1 do begin //����1��
                if m_PEnvir.GetNextPosition(MapWalkXY.nX, MapWalkXY.nY, btDir, II, nX, nY) and m_PEnvir.CanWalkEx(nX, nY, True) and
                  (GetNearTargetCount(nX, nY) <= MapWalkXY.nMonCount) then begin
                  GotoNextOne(nX, nY, m_btRaceServer <> 108);
                  break;
                end;
              end;
            end;
            m_RunPos.btDirection := 0;
            Result := True;
            Exit;
          end;
        end;
      end;
    end;

    for I := nRange downto 1 do begin
      if _FindPosOfSelf(@WalkStep, I, boFlag) then begin
        MapWalkXY := FindGoodPathB(WalkStep, 0);
        if (MapWalkXY.nWalkStep > 0) then begin
          btDir := GetNextDirection(m_nCurrX, m_nCurrY, MapWalkXY.nX, MapWalkXY.nY);
          if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
            for II := nRange downto 1 do begin //����1��
              if m_PEnvir.GetNextPosition(MapWalkXY.nX, MapWalkXY.nY, btDir, II, nX, nY) and m_PEnvir.CanWalkEx(nX, nY, True) and
                (GetNearTargetCount(nX, nY) <= MapWalkXY.nMonCount) then begin
                MapWalkXY.nX := nX;
                MapWalkXY.nY := nY;
                GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108);
                break;
              end;
            end;
            m_RunPos.btDirection := 0;
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;
  function FollowTarget: Boolean;
  var
    I: Integer;
    nRange: Integer;
    boFlag: Boolean;
    WalkStep: TWalkStep;
    MapWalkXY: TMapWalkXY;
  begin
    Result := False;
    nRange := 2;
    boFlag := (m_btRaceServer = 108) or (wMagicID in [SKILL_FIREBALL, SKILL_FIREBALL2, SKILL_FIRECHARM]);
    for I := nRange downto 1 do begin
      if FindPosOfSelf(@WalkStep, I, boFlag) then begin
        MapWalkXY := FindMinRange(WalkStep);
        if (MapWalkXY.nWalkStep > 0) then begin
          if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
            m_RunPos.btDirection := 0;
            Result := True;
            Exit;
          end;
        end;
      end;
    end;

    for I := nRange downto 1 do begin
      if _FindPosOfSelf(@WalkStep, I, boFlag) then begin
        MapWalkXY := FindMinRange(WalkStep);
        if (MapWalkXY.nWalkStep > 0) then begin
          if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
            m_RunPos.btDirection := 0;
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;
  function MotaeboPos(): Boolean; //��ȡҰ����ײ
  var
    nTargetX, nTargetY: Integer;
    btNewDir: Byte;
  begin
    Result := False;
    if (m_TargetCret = nil) or (m_Master = nil) then Exit;

    if (GetPoseCreate = m_TargetCret) or (m_TargetCret.GetPoseCreate = Self) then begin
      btNewDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, btNewDir, 1, nTargetX, nTargetY) then begin
        if m_PEnvir.CanWalk(nTargetX, nTargetY, True) then begin
          Result := True;
          Exit;
        end;
      end;
    end;
    Result := WalkToRightPos;
  end;
  function FindPosOfDir(nDir, nRange: Integer; boFlag: Boolean): TMapWalkXY;
  var
    nCurrX: Integer;
    nCurrY: Integer;
  begin
    FillChar(Result, SizeOf(TMapWalkXY), 0);
    if m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, nDir, nRange, nCurrX, nCurrY) and
      CanMove(nCurrX, nCurrY, False) and ((boFlag and CanLineAttack(nCurrX, nCurrY)) or (not boFlag)) and IsGotoXY(m_nCurrX, m_nCurrY, nCurrX, nCurrY) then begin
      Result.nWalkStep := nRange;
      Result.nX := nCurrX;
      Result.nY := nCurrY;
      Result.nMonRange := abs(nCurrX - m_TargetCret.m_nCurrX) + abs(nCurrY - m_TargetCret.m_nCurrY);
      Result.nMonCount := GetNearTargetCount(nCurrX, nCurrY);
      Result.nMastrRange := GetMasterRange(nCurrX, nCurrY);
    end;
  end;
  function RunPosAttack(): Boolean;
    function GetNextRunPos(btDir: Byte; boTurn: Boolean): Byte;
    begin
      if boTurn then begin
        case btDir of
          DR_UP: Result := DR_RIGHT;
          DR_UPRIGHT: Result := DR_DOWNRIGHT;
          DR_RIGHT: Result := DR_DOWN;
          DR_DOWNRIGHT: Result := DR_DOWNLEFT;
          DR_DOWN: Result := DR_LEFT;
          DR_DOWNLEFT: Result := DR_UPLEFT;
          DR_LEFT: Result := DR_UP;
          DR_UPLEFT: Result := DR_UPRIGHT;
        end;
      end else begin
        case btDir of
          DR_UP: Result := DR_LEFT;
          DR_UPRIGHT: Result := DR_UPLEFT;
          DR_RIGHT: Result := DR_UP;
          DR_DOWNRIGHT: Result := DR_UPRIGHT;
          DR_DOWN: Result := DR_RIGHT;
          DR_DOWNLEFT: Result := DR_DOWNRIGHT;
          DR_LEFT: Result := DR_DOWN;
          DR_UPLEFT: Result := DR_DOWNLEFT;
        end;
      end;
    end;
  var
    WalkStep: array[0..1] of TMapWalkXY;
    MapWalkXY: pTMapWalkXY;
    btNewDir1: Byte;
    btNewDir2: Byte;
    nRange: Integer;
    boFlag: Boolean;
    btDir: Byte;
    nNearTargetCount: Integer;
  begin
    Result := False;

    btDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);

    btNewDir1 := GetNextRunPos(btDir, True);
    btNewDir2 := GetNextRunPos(btDir, False);
    FillChar(WalkStep, SizeOf(TMapWalkXY) * 2, 0);

    if m_btJob = 0 then begin
      nRange := 1;
      if (wMagicID = 43) or (wMagicID = SKILL_74) then nRange := 2;
      if (wMagicID = 12) then nRange := 2;
      if (wMagicID in [60, 61, 62]) then nRange := 6;
      WalkStep[0] := FindPosOfDir(btNewDir1, nRange, True);
      WalkStep[1] := FindPosOfDir(btNewDir2, nRange, True);
    end else begin
      nRange := 2;
      boFlag := False;
      WalkStep[0] := FindPosOfDir(btNewDir1, nRange, boFlag);
      WalkStep[1] := FindPosOfDir(btNewDir2, nRange, boFlag);
    end;

    nNearTargetCount := GetNearTargetCount(m_nCurrX, m_nCurrY);
    MapWalkXY := nil;
    if (WalkStep[0].nWalkStep > 0) and (WalkStep[1].nWalkStep > 0) then begin
      if m_RunPos.btDirection > 0 then begin
        MapWalkXY := @WalkStep[1];
      end else begin
        MapWalkXY := @WalkStep[0];
      end;
      if (nNearTargetCount < WalkStep[0].nMonCount) and (nNearTargetCount < WalkStep[1].nMonCount) then
        MapWalkXY := nil
      else
        if (m_RunPos.btDirection > 0) and (nNearTargetCount < WalkStep[1].nMonCount) then
        MapWalkXY := nil
      else
        if (m_RunPos.btDirection <= 0) and (nNearTargetCount < WalkStep[0].nMonCount) then
        MapWalkXY := nil;

      if (nNearTargetCount > 0) and (MapWalkXY <> nil) and (MapWalkXY.nMonCount > nNearTargetCount) then
        MapWalkXY := nil;
    end else
      if (WalkStep[0].nWalkStep > 0) then begin
      MapWalkXY := @WalkStep[0];
      if (nNearTargetCount < WalkStep[0].nMonCount) then
        MapWalkXY := nil;
      m_RunPos.btDirection := 0;
    end else
      if (WalkStep[1].nWalkStep > 0) then begin
      MapWalkXY := @WalkStep[1];
      if (nNearTargetCount < WalkStep[1].nMonCount) then
        MapWalkXY := nil;
      m_RunPos.btDirection := 1;
    end;
    if (MapWalkXY <> nil) then begin
      if GotoNextOne(MapWalkXY.nX, MapWalkXY.nY, m_btRaceServer <> 108) then begin
        Result := True;
      end;
    end;
    if not Result then begin
      m_RunPos.nAttackCount := 0;
    end;
  end;
var
  nCode, nError, nThinkCount: Integer;
begin
  Result := False;
  nError := 0;
  nThinkCount := 0;
  {$IF M2Version = 1}
  if (m_TargetCret = nil) and m_boUseBatter then HeroBatterStop();//������;��Ŀ�괦��
  if m_boUseBatter and (m_btJob <> 0) then Exit;//�����򲻴������¶���
  {$IFEND}
  try
    while True do begin
      if (m_TargetCret = nil) or (wMagicID > 255) then break;
      nThinkCount := nThinkCount + 1;
      nCode := DoThink(wMagicID);
      nError := 1;
      case m_btJob of
        0: begin
            case nCode of
              2: begin
                  nError := 2;
                  if WalkToRightPos then begin
                    Result := True;
                  end else begin //�޷��ߵ���ȷ�Ĺ�������
                    nError := 3;
                    DelTargetCreat;
                    if nThinkCount < 2 then begin
                      nError := 4;
                      SearchTarget;
                      nError := 5;
                      Continue;
                    end;
                  end;
                end;
              5: begin
                  nError := 6;
                  if RunPosAttack then begin
                    Result := True;
                  end;
                  nError := 7;
                end;
            end;
          end;
        1, 2: begin
            case nCode of
              1: begin
                  nError := 8;
                  Result := AvoidTarget;
                  nError := 9;
                end;
              2: begin
                  nError := 10;
                  if FollowTarget then begin
                    nError := 11;
                    Result := True;
                  end else begin //�޷��ߵ���ȷ�Ĺ�������
                    nError := 12;
                    DelTargetCreat;
                    nError := 13;
                    if nThinkCount < 2 then begin
                      nError := 14;
                      SearchTarget;
                      nError := 15;
                      Continue;
                    end;
                  end;
                end;
              3, 4: begin
                  nError := 16;
                  if WalkToRightPos then begin
                    Result := True;
                  end else begin //�޷��ߵ���ȷ�Ĺ�������
                    nError := 3;
                    DelTargetCreat;
                    if nThinkCount < 2 then begin
                      nError := 4;
                      SearchTarget;
                      nError := 5;
                      Continue;
                    end;
                  end;
                  nError := 17;
                end;
              5: begin
                  nError := 24;
                  Result := RunPosAttack;
                  nError := 25;
                end;
            end;
          end;
      end;
      break;
    end;
  except
    MainOutMessage(format('{%s} TAIPlayObject::ActThink Name:%s Code:%d Error:%d',[g_sExceptionVer, m_sCharName, nCode, nError]));
  end;
end;

function TAIPlayObject.Thinking: Boolean;
var
  nOldX, nOldY: Integer;
  nCode: Byte;
begin
  Result := False;
  try
    if g_Config.boAutoPickUpItem and (g_AllowAIPickUpItemList.Count > 0) then begin
      if SearchPickUpItem(500) then Result := True;
    end;  
    nCode:= 1;
    if (m_Master <> nil) and (m_Master.m_boGhost) then Exit;
    nCode:= 2;
    if (m_btRaceServer = RC_HEROOBJECT) and m_Master.InSafeZone and InSafeZone then begin
      if (abs(m_nCurrX - m_Master.m_nCurrX) <= 3) and (abs(m_nCurrY - m_Master.m_nCurrY) <= 3) then begin
        Result := True;
        Exit;
      end;
    end;
    nCode:= 3;
    if (GetTickCount - m_dwThinkTick) > 3000 then begin
      m_dwThinkTick := GetTickCount();
      if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
      if (m_TargetCret <> nil) then begin
        if not IsProperTarget(m_TargetCret) then DelTargetCreat();
      end;
    end;
    nCode:= 4;
    {$IF M2Version = 1}
    if (not m_boUseBatter) and (m_TargetCret <> nil) then GetBatterMagic;//ȡ��������ID 20091103
    if (m_TargetCret = nil) and m_boUseBatter then HeroBatterStop();//������;��Ŀ�괦��
    if m_boUseBatter then Exit;//�����򲻴������¶���
    {$IFEND}
    nCode:= 5;
    if m_boDupMode then begin
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(Random(8), False);
      m_dwStationTick := GetTickCount; //���Ӽ������վ��ʱ��
      if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
        m_boDupMode := False;
        Result := True;
      end;
    end;
    {$IF HEROVERSION = 1}
    if m_boAutoRecallHero and ((GetTickCount() - m_nRecallHeroTime) >= g_Config.nRecallHeroTime) then begin
      m_boAutoRecallHero:= False;
      ClientRecallHero();//�ٻ�Ӣ��
    end;
    {$IFEND}
  except
    MainOutMessage(Format('{%s} TAIPlayObject.Thinking Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

procedure TAIPlayObject.Run;
var
  nSelectMagic, I, II, nWhere, nPercent, nValue: Integer;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
  boRecalcAbilitys, boFind: Boolean;
  nCode: Byte;
begin
  try
    if (not m_boGhost) and (not m_boDeath) and (not m_boFixedHideMode) and
      (not m_boStoneMode) and (m_wStatusTimeArr[POISON_STONE] = 0) then begin
      if GetTickCount - m_dwWalkTick > m_nWalkSpeed then begin
        m_dwWalkTick := GetTickCount;
        nCode:= 1;
        if (m_TargetCret <> nil) then begin
          if (m_TargetCret.m_boDeath or m_TargetCret.m_boGhost) or m_TargetCret.InSafeZone or
            (m_TargetCret.m_PEnvir <> m_PEnvir) or (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 11) or
            (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 11) then
            DelTargetCreat;
        end;
        if (not m_boAIStart) then begin
          DelTargetCreat();
        end;
        nCode:= 2;
        SearchTarget();
        nCode:= 3;
        if m_ManagedEnvir <> m_PEnvir then begin//���ڵ�ͼ���ǹһ���ͼ�����Ŀ��
          DelTargetCreat();
        end;
        nCode:= 4;
        if Thinking then begin
          inherited;
          Exit;
        end;
        nCode:= 5;
        if m_boProtectStatus then begin//�ػ�״̬
          if (m_nProtectTargetX = 0) or (m_nProtectTargetY = 0) then begin//ȡ�ػ�����
            m_nProtectTargetX:= m_nCurrX;//�ػ�����
            m_nProtectTargetY:= m_nCurrY;//�ػ�����
          end;
          nCode:= 51;
          if (not m_boProtectOK) and (m_ManagedEnvir <> nil) and (m_TargetCret = nil) then begin//û�ߵ��ػ�����
            nCode:= 52;
            GotoProtect();
            Inc(m_nGotoProtectXYCount);
            if (abs(m_nCurrX - m_nProtectTargetX) <= 3) and (abs(m_nCurrY - m_nProtectTargetY) <= 3) then begin
              m_btDirection:= Random(8);
              m_boProtectOK:= True;
              m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ���
            end;
            nCode:= 53;
            if (m_nGotoProtectXYCount > 20) and (not m_boProtectOK) then begin//20�λ�û���ߵ��ػ����꣬��ɻ�������
              if (abs(m_nCurrX - m_nProtectTargetX) > 13) or (abs(m_nCurrY - m_nProtectTargetY) > 13) and (not InMag113LockRect(m_nCurrX, m_nCurrY)) then  begin
                nCode:= 54;
                SpaceMove(m_ManagedEnvir.sMapName, m_nProtectTargetX, m_nProtectTargetY, 1);//��ͼ�ƶ�
                nCode:= 55;
                m_btDirection:= Random(8);
                m_boProtectOK:= True;
                m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ��� 20090203
              end;
            end;
            inherited;
            Exit;
          end;
        end;
        nCode:= 6;
        if (m_TargetCret <> nil) then begin
          if AttackTarget then begin//����
            inherited;
            Exit;
          end else
          if IsNeedAvoid then begin //�Զ����
            m_dwActionTick := GetTickCount()- 10;
            AutoAvoid();
            inherited;
            Exit;
          end else begin
            if IsNeedGotoXY then begin//�Ƿ�����Ŀ��
              m_dwActionTick := GetTickCount();
              m_nTargetX:= m_TargetCret.m_nCurrX;
              m_nTargetY:= m_TargetCret.m_nCurrY;
              if (AllowUseMagic(12) or AllowUseMagic(SKILL_89)) and (m_btJob = 0) then GetGotoXY(m_TargetCret, 2);//20080617 �޸�
              if (m_btJob > 0) then begin
                if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or
                 (g_Config.boHeroAttackTao and (m_TargetCret.m_WAbil.MaxHP < 700) and (m_btJob = 2) and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) then begin//20081218 ����22ǰ�Ƿ�������
                  if m_Master <> nil then begin
                    if (abs(m_Master.m_nCurrX - m_nCurrX) > 6) or (abs(m_Master.m_nCurrY - m_nCurrY) > 6) then begin
                      inherited;
                      Exit;
                    end;
                  end;
                end else GetGotoXY(m_TargetCret, 3);//����ֻ����Ŀ��3��Χ
              end;
              GotoTargetXY( m_nTargetX, m_nTargetY, 0);
              inherited;
              Exit;
            end;
          end;
          (*case m_btJob of
            0: begin
                if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > g_Config.dwHeroWarrorAttackTime) then begin
                  m_dwHitTick := GetTickCount();
                  if (GetTickCount()- m_dwSearchMagic > 1200) and (not m_boUseBatter) then begin
                    m_dwSearchMagic:= GetTickCount();
                    nSelectMagic := SelectMagic;
                  end;
                  m_dwHitTick := GetTickCount();
                  if ActThink(nSelectMagic) then begin
                    //inherited;
                    //Exit;
                  end;
                  m_dwHitTick := GetTickCount();
                  if (m_TargetCret <> nil) and StartAttack(nSelectMagic) then begin
                    if (nSelectMagic > 0) and (nSelectMagic <= High(m_SkillUseTick)) then begin
                      m_SkillUseTick[nSelectMagic] := GetTickCount;
                    end;
                  end;
                end;
              end;
            1: begin
                if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > g_Config.dwHeroWizardAttackTime) then begin
                  m_dwHitTick := GetTickCount();
                  if (not m_boUseBatter) then begin
                    if (GetTickCount()- m_dwSearchMagic > 1200) then begin
                      m_dwSearchMagic:= GetTickCount();
                      nSelectMagic := SelectMagic;
                    end;
                    m_dwHitTick := GetTickCount();
                    if ActThink(nSelectMagic) then begin
                      //inherited;
                      //Exit;
                    end;
                    m_dwHitTick := GetTickCount();
                  end;
                  if (m_TargetCret <> nil) and StartAttack(nSelectMagic) then begin
                    if (nSelectMagic >= 0) and (nSelectMagic <= High(m_SkillUseTick)) then begin
                      m_SkillUseTick[nSelectMagic] := GetTickCount;
                    end;
                  end;
                end;
              end;
            2: begin
                if (m_TargetCret <> nil) and (Integer(GetTickCount - m_dwHitTick) > g_Config.dwHeroTaoistAttackTime) then begin
                  m_dwHitTick := GetTickCount();
                  if (not m_boUseBatter) then begin
                    if (GetTickCount()- m_dwSearchMagic > 1200) then begin
                      m_dwSearchMagic:= GetTickCount();
                      nSelectMagic := SelectMagic;
                    end;
                    m_dwHitTick := GetTickCount();
                    if ActThink(nSelectMagic) then begin
                      //inherited;
                      //Exit;
                    end;
                    m_dwHitTick := GetTickCount();
                  end;
                  if (m_TargetCret <> nil) and StartAttack(nSelectMagic) then begin
                    if (nSelectMagic >= 0) and (nSelectMagic <= High(m_SkillUseTick)) then begin
                      m_boSelSelf:= False;
                      m_SkillUseTick[nSelectMagic] := GetTickCount;
                    end;
                  end;
                end;
              end;
          end;   *)
        end;
        nCode:= 7;
        if m_boAI and (not m_boGhost) and (not m_boDeath) then begin
          if g_Config.boHPAutoMoveMap then begin
            if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.3)) and (GetTickCount - m_dwHPToMapHomeTick > 15000) then begin //��Ѫʱ�سǻ���ػ��� 20110512
              m_dwHPToMapHomeTick:= GetTickCount;
              DelTargetCreat();
              if m_boProtectStatus and (not InMag113LockRect(m_nCurrX, m_nCurrY)) then begin//�ػ�״̬
                SpaceMove(m_ManagedEnvir.sMapName, m_nProtectTargetX, m_nProtectTargetY, 1);//��ͼ�ƶ�
                m_btDirection:= Random(8);
                m_boProtectOK:= True;
                m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ��� 20090203
              end else begin//�����ػ�״̬��ֱ�ӻس�
                MoveToHome();//�ƶ����سǵ�
              end;
            end;
          end;
          if g_Config.boAutoRepairItem then begin//�Ƿ������Զ�����
            nCode:= 71;
            if GetTickCount - m_dwAutoRepairItemTick > 15000 then begin
              m_dwAutoRepairItemTick := GetTickCount;
              boRecalcAbilitys := False;
              nCode:= 72;
              for nWhere := Low(THumanUseItems) to High(THumanUseItems) do begin
                if (m_UseItemNames[nWhere] <> '') and (m_UseItems[nWhere].wIndex <= 0) then begin
                  nCode:= 73;
                  StdItem := UserEngine.GetStdItem(m_UseItemNames[nWhere]);
                  if StdItem <> nil then begin
                    nCode:= 74;
                    New(UserItem);
                    if UserEngine.CopyToUserItemFromName(m_UseItemNames[nWhere], UserItem) then begin
                      boRecalcAbilitys := True;
                      if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
                        if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                          UserEngine.GetUnknowItemValue(UserItem);
                        end;
                      end;
                    end;
                    nCode:= 75;
                    m_UseItems[nWhere] := UserItem^;
                    Dispose(UserItem);
                  end;
                end;
              end;
              nCode:= 76;
              if m_BagItemNames.Count > 0 then begin
                for I:= 0 to m_BagItemNames.Count -1 do begin
                  for II := 0 to m_ItemList.Count - 1 do begin
                    UserItem := m_ItemList.Items[II];
                    if UserItem <> nil then begin
                      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
                      if StdItem <> nil then begin
                        boFind := False;
                        if CompareText(StdItem.Name, m_BagItemNames.Strings[I]) = 0 then begin
                          boFind := True;
                          break;
                        end;
                      end;
                    end;
                  end;
                  nCode:= 77;
                  if not boFind then begin
                    New(UserItem);
                    if UserEngine.CopyToUserItemFromName(m_BagItemNames.Strings[I], UserItem) then begin
                      nCode:= 82;
                      if not AddItemToBag(UserItem) then begin
                        Dispose(UserItem);
                        break;
                      end;
                    end else Dispose(UserItem);
                  end;
                end;
              end;
              nCode:= 78;
              for nWhere := Low(THumanUseItems) to High(THumanUseItems) do begin
                if m_UseItems[nWhere].wIndex > 0 then begin
                  StdItem := UserEngine.GetStdItem(m_UseItems[nWhere].wIndex);
                  if StdItem <> nil then begin
                    if (m_UseItems[nWhere].DuraMax > m_UseItems[nWhere].Dura) and (StdItem.StdMode <> 43) then begin
                      if PlugOfCheckCanItem(3, StdItem.Name, False, 0, 0) then Continue;
                      m_UseItems[nWhere].Dura := m_UseItems[nWhere].DuraMax;
                    end;
                  end;
                end;
              end;
              nCode:= 79;
              if boRecalcAbilitys then RecalcAbilitys;
            end;
          end;
          nCode:= 80;
          if g_Config.boRenewHealth then begin//�Զ�����HP MP
            if GetTickCount - m_dwAutoAddHealthTick > 5000 then begin
              m_dwAutoAddHealthTick := GetTickCount;
              nPercent := m_WAbil.HP * 100 div m_WAbil.MaxHP;
              nValue := m_WAbil.MaxHP div 10;
              if nPercent < g_Config.nRenewPercent then begin
                if m_WAbil.HP + nValue >= m_WAbil.MaxHP then begin
                  m_WAbil.HP := m_WAbil.MaxHP;
                end else begin
                  Inc(m_WAbil.HP, nValue);
                end;
              end;
              nCode:= 81;
              nValue := m_WAbil.MaxMP div 10;
              nPercent := m_WAbil.MP * 100 div m_WAbil.MaxMP;
              if nPercent < g_Config.nRenewPercent then begin
                if m_WAbil.MP + nValue >= m_WAbil.MaxMP then begin
                  m_WAbil.MP := m_WAbil.MaxMP;
                end else begin
                  Inc(m_WAbil.MP, nValue);
                end;
              end;
            end;
          end;
        end;
      end;
      nCode:= 8;
      if (not m_boGhost) and (not m_boDeath) and (not m_boFixedHideMode) and
        (not m_boStoneMode) and (m_wStatusTimeArr[POISON_STONE] = 0) then begin
        if m_boProtectStatus and (m_TargetCret = nil) then begin //�ػ�״̬
          if (abs(m_nCurrX - m_nProtectTargetX) > 50) or (abs(m_nCurrY - m_nProtectTargetY) > 50) then begin
            m_boProtectOK:= False;
          end;
        end;
        nCode:= 9;
        if (m_TargetCret = nil) then begin
          if (m_Master <> nil) then FollowMaster
          else Wondering();
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
  inherited;
end;

function TAIPlayObject.IsProtectTarget(BaseObject: TBaseObject): Boolean;
begin
  Result := inherited IsProtectTarget(BaseObject);
end;

function TAIPlayObject.IsAttackTarget(BaseObject: TBaseObject): Boolean;
begin
  Result := inherited IsAttackTarget(BaseObject);
end;

function TAIPlayObject.IsProperTarget(BaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if BaseObject <> nil then begin
    if inherited IsProperTarget(BaseObject) then begin
      Result := True;
      if m_MyHero <> nil then begin
        if (BaseObject = m_MyHero) or (BaseObject.m_Master = m_MyHero) then Result := False;//����������Ӣ�ۺ�Ӣ�۵ı���
      end;
      if BaseObject.m_Master <> nil then begin
        if (BaseObject.m_Master = self) or ((BaseObject.m_Master.m_boAI)and (not m_boInFreePKArea)) then Result := False;
      end;
      if BaseObject.m_boAI and (not m_boInFreePKArea) then Result := False;//���˲���������,�л�ս����
      case BaseObject.m_btRaceServer of
        RC_ARCHERGUARD, 55: begin//��������������ʦ ������
          if BaseObject.m_TargetCret <> Self then Result := False;
        end;
        10, 11, 12: Result := False;//����������ʿ
        110, 111, 158: Result := False;//ɳ�Ϳ˳���,ɳ�Ϳ����ǽ,������
      end;
    end else begin
      if m_btAttatckMode = HAM_PKATTACK then begin//����ģʽ��������Ŀ���⣬���˹���ʱ�Ż���
        if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
          if PKLevel >= 2 then begin
            if BaseObject.PKLevel < 2 then
              Result := True
            else Result := False;
          end else begin
            if BaseObject.PKLevel >= 2 then
              Result := True
            else Result := False;
          end;
        end;
        if m_boAI and (not Result) then begin
          if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or
             (BaseObject.m_btRaceServer = RC_HEROOBJECT) or (BaseObject.m_Master <> nil) then begin
            if BaseObject.m_TargetCret <> nil then begin
              if (BaseObject.m_TargetCret = self) or (BaseObject.m_TargetCret = m_MyHero) then Result := True;
            end;
            if BaseObject.m_LastHiter <> nil then begin
              if (BaseObject.m_LastHiter = self) or (BaseObject.m_LastHiter = m_MyHero) then Result := True;
            end;
            if BaseObject.m_ExpHitter <> nil then begin
              if (BaseObject.m_LastHiter = self) or (BaseObject.m_ExpHitter = m_MyHero) then Result := True;
            end;
          end;
        end;
        if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)
          or (BaseObject.m_Master <> nil) then begin//��ȫ�����ܴ������Ӣ��
          if BaseObject.InSafeZone or InSafeZone then Result := False;
        end;
        if m_MyHero <> nil then begin
          if (BaseObject = m_MyHero) or (BaseObject.m_Master = m_MyHero) then Result := False;//����������Ӣ�ۺ�Ӣ�۵ı���
        end;
        if (BaseObject.m_Master = self) then Result := False;
        if BaseObject.m_boAI and ((not m_boInFreePKArea) or (BaseObject.PKLevel < 2)) then Result := False;//���˲���������,�л�ս����
        case BaseObject.m_btRaceServer of
          RC_ARCHERGUARD,55: begin//��������������ʦ ������
            if BaseObject.m_TargetCret <> Self then Result := False;
          end;
          10, 11, 12: Result := False;//����������ʿ
          110, 111, 158: Result := False;//ɳ�Ϳ˳���,ɳ�Ϳ����ǽ,������
        end;
      end;
    end;
  end;
end;

function TAIPlayObject.IsProperFriend(BaseObject: TBaseObject): Boolean;
begin
  Result := inherited IsProperFriend(BaseObject);
end;

procedure TAIPlayObject.SearchViewRange;
var
  I, nStartX, nEndX, nStartY, nEndY, n18, n1C, nIdx, n24, n25: Integer;
  MapCellInfo: pTMapCellinfo;
  OSObject: pTOSObject;
  BaseObject: TBaseObject;
  MapItem: PTMapItem;
  MapEvent: TEvent;
  VisibleBaseObject: pTVisibleBaseObject;
  VisibleMapItem: pTVisibleMapItem;
  nCheckCode: Byte;
  //btType: Byte;//20090510 ע��
  nVisibleFlag: {Integer}Byte;//20090823 �޸�Ϊ Byte
  dwRunTick: LongWord;//20091103 ������
resourcestring
  sExceptionMsg1 = '{%s} TAIPlayObject::SearchViewRange Code:%d';
  sExceptionMsg2 = '{%s} TAIPlayObject::SearchViewRange 1-%d %s %s %d %d %d';
begin
  nCheckCode := 1;
  n24 := 0;
  try
    if m_boNotOnlineAddExp or m_boGhost then Exit; //2006-10-22 Ҷ���Ʈ �޸� ���߹һ�������
    nCheckCode := 2;
    if m_VisibleItems.Count > 0 then begin
      for I := 0 to m_VisibleItems.Count - 1 do begin
        pTVisibleMapItem(m_VisibleItems.Items[I]).nVisibleFlag := 0;
      end;
    end;
    {nCheckCode := 3;
    if m_VisibleEvents.Count > 0 then begin//20080629 20090823 ע�ͣ��������������ֱ�ӳ�ʼΪ0
      for I := 0 to m_VisibleEvents.Count - 1 do begin
        if TEvent(m_VisibleEvents.Items[I]) <> nil then begin
          TEvent(m_VisibleEvents.Items[I]).nVisibleFlag := 0;
        end;
      end;
    end;
    nCheckCode := 4;
    if m_VisibleActors.Count > 0 then begin//20080629  20090822 ע�ͣ��������������ֱ�ӳ�ʼΪ0
      for I := 0 to m_VisibleActors.Count - 1 do begin
        pTVisibleBaseObject(m_VisibleActors.Items[I]).nVisibleFlag := 0;
      end;
    end;}
  except                      
    MainOutMessage(Format(sExceptionMsg1, [g_sExceptionVer, nCheckCode]));
    KickException();
  end;
  nCheckCode := 6;

  try
    nStartX := m_nCurrX - m_nViewRange;
    nEndX := m_nCurrX + m_nViewRange;
    nStartY := m_nCurrY - m_nViewRange;
    nEndY := m_nCurrY + m_nViewRange;

    dwRunTick:= GetTickCount();//20091103 ����
    nCheckCode := 7;
    for n18 := nStartX to nEndX do begin
      for n1C := nStartY to nEndY do begin
        nCheckCode := 8;
        if m_PEnvir.GetMapCellInfo(n18, n1C, MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
          nCheckCode := 9;
          n24 := 1;
          nIdx := 0;
          while (True) do begin
            if ((GetTickCount - dwRunTick) > 500) then Break;//��ʱ���˳�ѭ��(����) 20091103
            if MapCellInfo <> nil then begin//20080910 ����  20090316 ע��  20100614 ��ԭ
              if (MapCellInfo.ObjList <> nil) and (MapCellInfo.ObjList.Count <= 0) then begin //200-11-1 ����
                nCheckCode := 10;
                FreeAndNil(MapCellInfo.ObjList);
                nCheckCode := 101;
                Break;
              end;
            end;
            nCheckCode := 11;
            try//20091102 ����
              if MapCellInfo.ObjList.Count <= nIdx then Break;
            except
              Break;
            end;
            nCheckCode := 121;
            try //20091101 ����
              OSObject := MapCellInfo.ObjList.Items[nIdx];
            except
              //OSObject:= nil;
              MapCellInfo.ObjList.Delete(nIdx);//20101103 �޸�
              Continue;
            end;
            nCheckCode := 131;
            if OSObject <> nil then begin
              if (not OSObject.boObjectDisPose) then begin
                case OSObject.btType of
                  OS_MOVINGOBJECT: begin
                      if (GetTickCount - OSObject.dwAddTime) >= 60000 then begin
                        OSObject.boObjectDisPose:= True;//20090510 ����
                        Dispose(OSObject);
                        MapCellInfo.ObjList.Delete(nIdx);
                        if MapCellInfo.ObjList.Count <= 0 then begin
                          FreeAndNil(MapCellInfo.ObjList);
                          Break;
                        end;
                        Continue;
                      end;
                      BaseObject := TBaseObject(OSObject.CellObj);
                      if BaseObject <> nil then begin
                        if not BaseObject.m_boGhost and not BaseObject.m_boFixedHideMode and not BaseObject.m_boObMode then begin
                          if (m_btRaceServer < RC_ANIMAL) or (m_Master <> nil) or m_boCrazyMode or m_boWantRefMsg or
                            ((BaseObject.m_Master <> nil) and (abs(BaseObject.m_nCurrX - m_nCurrX) <= 3) and (abs(BaseObject.m_nCurrY - m_nCurrY) <= 3)) or
                            (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                            UpdateVisibleGay(BaseObject, 0);
                          end;
                        end;
                      end; //if BaseObject <> nil then begin
                    end;//OS_MOVINGOBJECT
                  OS_ITEMOBJECT: begin
                      if m_btRaceServer = RC_PLAYOBJECT then begin
                        if ((GetTickCount - OSObject.dwAddTime) > g_Config.dwClearDropOnFloorItemTime) or
                          ((PTMapItem(OSObject.CellObj).UserItem.AddValue[0] = 1) and
                          (GetHoursCount(PTMapItem(OSObject.CellObj).UserItem.MaxDate, Now) <= 0)) then begin
                          if PTMapItem(OSObject.CellObj) <> nil then
                            Dispose(PTMapItem(OSObject.CellObj)); //��ֹռ���ڴ治�ͷ����� 20080702
                          try//20090504 ����
                            if OSObject <> nil then begin
                              OSObject.boObjectDisPose:= True;//20090510 ����
                              Dispose(OSObject);//20090107 ����<>nil
                            end;
                          except
                          end;
                          MapCellInfo.ObjList.Delete(nIdx);
                          if MapCellInfo.ObjList.Count <= 0 then begin
                            FreeAndNil(MapCellInfo.ObjList);
                            Break;
                          end;
                          Continue;
                        end;
                        MapItem := PTMapItem(OSObject.CellObj);
                        UpdateVisibleItem(n18, n1C, MapItem);
                        if (MapItem.OfBaseObject <> nil) or (MapItem.DropBaseObject <> nil) then begin
                          if (GetTickCount - MapItem.dwCanPickUpTick) > g_Config.dwFloorItemCanPickUpTime {2 * 60 * 1000} then begin
                            MapItem.OfBaseObject := nil;
                            MapItem.DropBaseObject := nil;
                          end else begin
                            if TBaseObject(MapItem.OfBaseObject) <> nil then begin
                              if TBaseObject(MapItem.OfBaseObject).m_boGhost then MapItem.OfBaseObject := nil;
                            end;
                            if TBaseObject(MapItem.DropBaseObject) <> nil then begin
                              if TBaseObject(MapItem.DropBaseObject).m_boGhost then MapItem.DropBaseObject := nil;
                            end;
                          end;
                        end;                        
                      end;
                    end;//OS_ITEMOBJECT
                  OS_EVENTOBJECT: begin
                      if m_btRaceServer = RC_PLAYOBJECT then begin
                        if OSObject.CellObj <> nil then begin//20080913
                          MapEvent := TEvent(OSObject.CellObj);
                          //if MapEvent.m_boVisible then
                          begin
                            UpdateVisibleEvent(n18, n1C, MapEvent);
                          end;
                        end;                        
                      end;                    
                    end;//OS_EVENTOBJECT
                end;//Case
              end;
            end; //if OSObject <> nil then begin
            Inc(nIdx);
          end; //while
        end;
      end; //for n1C:= n10 to n14  do begin
    end; //for n18:= n8 to nC do begin
  except
    on E: Exception do begin
      MainOutMessage(Format(sExceptionMsg2, [g_sExceptionVer, n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));//20100125 ע��
      KickException();
    end;
  end;
  nCheckCode := 26;
  n24 := 2;
  try
    n18 := 0;
    while (True) do begin
      try//20101126 ��ֹ��ѭ��
        if m_VisibleActors.Count <= n18 then Break;
        nCheckCode := 27;
        try//20081017 ȥע��
          VisibleBaseObject := m_VisibleActors.Items[n18];
          nCheckCode := 28;
          nVisibleFlag := VisibleBaseObject.nVisibleFlag; //2006-10-14 ��ֹ�ڴ����
        except
          m_VisibleActors.Delete(n18);
          if m_VisibleActors.Count > 0 then Continue;//20090430 �޸�
          Break;//20090430 ����
        end;
        case VisibleBaseObject.nVisibleFlag of//20090822 �޸�
          0: begin
             if m_btRaceServer = RC_PLAYOBJECT then begin
               nCheckCode := 29;
               BaseObject := TBaseObject(VisibleBaseObject.BaseObject);
               nCheckCode := 30;
               if BaseObject <> nil then begin
                 nCheckCode := 51;
                 if (not BaseObject.m_boFixedHideMode) and (not BaseObject.m_boGhost) then begin //01/21 �޸ķ�ֹ�����˳�ʱ�����ظ�����Ϣռ�ô��������������ģʽʱ���ﲻ��ʧ����
                   nCheckCode := 31;
                   SendMsg(BaseObject, RM_DISAPPEAR, 0, 0, 0, 0, '');
                 end;
               end;
             end;
             nCheckCode := 52;
             m_VisibleActors.Delete(n18);
             nCheckCode := 32;
             try
               if VisibleBaseObject <> nil then Dispose(VisibleBaseObject);//20091017 �޸�
             except
             end;
             Continue;
           end;//0
          2: begin
              if (m_btRaceServer = RC_PLAYOBJECT) then begin
                nCheckCode := 34;
                BaseObject := TBaseObject(VisibleBaseObject.BaseObject);
                if (BaseObject <> nil) then begin
                  if (BaseObject <> Self) and (not BaseObject.m_boGhost) and (not m_boGhost) then begin
                    if BaseObject.m_boDeath then begin
                      if BaseObject.m_boSkeleton then begin
                        nCheckCode := 35;
                        SendMsg(BaseObject, RM_SKELETON, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
                      end else begin
                        nCheckCode := 36;
                        SendMsg(BaseObject, RM_DEATH, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
                      end;
                    end else begin
                      try//20090721 ����
                        if (BaseObject <> nil) then begin//20090721 ����
                          {$IF M2Version <> 2}
                          n25:= 0;
                          case BaseObject.m_btRaceServer of//20090818 �޸�
                            RC_PLAYOBJECT: begin
                               if (not TPlayObject(BaseObject).m_boShowFengHao) and (TPlayObject(BaseObject).m_boUseTitle) then n25:= TPlayObject(BaseObject).m_boUseIitleIdx;
                               SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, n25, BaseObject.GetShowName);
                               if TPlayObject(BaseObject).m_boTrainingNG then
                                 SendMsg(BaseObject, RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
                             end;
                            RC_HEROOBJECT: begin
                               SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, BaseObject.GetShowName);
                               if THeroObject(BaseObject).m_boTrainingNG then
                                 SendMsg(BaseObject, RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject).m_Skill69NH, THeroObject(BaseObject).m_Skill69MaxNH, 0, '');
                             end;
                            RC_PLAYMOSTER: begin
                               if (BaseObject.m_Master <> nil) and (BaseObject.m_Master.m_btRaceServer = RC_PLAYOBJECT) then begin
                                 if (not TPlayObject(BaseObject.m_Master).m_boShowFengHao) and (TPlayObject(BaseObject.m_Master).m_boUseTitle) then n25:= TPlayObject(BaseObject.m_Master).m_boUseIitleIdx;
                               end;
                               SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, n25, BaseObject.GetShowName);
                               if (BaseObject.m_Master <> nil) then begin//ѧ���ڹ�����ķ���Ҳ��ʾ����ֵ
                                 if (BaseObject.m_Master.m_btRaceServer = RC_PLAYOBJECT) then begin
                                   if TPlayObject(BaseObject.m_Master).m_boTrainingNG then begin
                                     SendMsg(BaseObject, RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject.m_Master).m_Skill69NH, TPlayObject(BaseObject.m_Master).m_Skill69MaxNH, 0, '');
                                   end;
                                 end else
                                 if (BaseObject.m_Master.m_btRaceServer = RC_HEROOBJECT) then begin
                                   if THeroObject(BaseObject.m_Master).m_boTrainingNG then begin
                                     SendMsg(BaseObject, RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject.m_Master).m_Skill69NH, THeroObject(BaseObject.m_Master).m_Skill69MaxNH, 0, '');
                                   end;
                                 end;
                               end;
                             end;
                             else SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, BaseObject.GetShowName);
                          end;//case
                          {$ELSE}
                          SendMsg(BaseObject, RM_TURN, BaseObject.m_btDirection, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, BaseObject.GetShowName);
                          {$IFEND}
                        end;
                      except
                      end;
                    end;
                  end;
                end;
              end;
              VisibleBaseObject.nVisibleFlag:= 0;//�������ʼ���� 20090822
           end;//2
           1: VisibleBaseObject.nVisibleFlag:= 0;//�������ʼ���� 20090822
        end;//case
      except
        Break;
      end;
      Inc(n18);
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format(sExceptionMsg2, [g_sExceptionVer, n24, m_sCharName, m_sMapName, m_nCurrX, m_nCurrY, nCheckCode]));
      KickException();
    end;
  end;
  try
    I := 0;
    while (True) do begin
      try//20101126 ��ֹ��ѭ��
        if m_VisibleItems.Count <= I then Break;
        nCheckCode := 49;
        try //20081017 ȥע��
          VisibleMapItem := m_VisibleItems.Items[I];
          nCheckCode := 50;
          nVisibleFlag := VisibleMapItem.nVisibleFlag; //2006-10-14 ��ֹ�ڴ����
        except
          m_VisibleItems.Delete(I);
          if m_VisibleItems.Count > 0 then Continue;//20090430 �޸�
          Break;//20090430 ����
        end;
        nCheckCode := 38;
        if VisibleMapItem.nVisibleFlag = 0 then begin
          m_VisibleItems.Delete(I);
          try
            //DisPoseAndNil(VisibleMapItem);
            DisPose(VisibleMapItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17
            VisibleMapItem := nil;
          except
            VisibleMapItem := nil;
          end;
          if m_VisibleItems.Count > 0 then Continue;//20090511 �޸�
          Break;//20090511 ����
        end;
      except
        Break;
      end;
      Inc(I);
    end;
    I := 0;
    while (True) do begin //2006-01-20 �޸�
      try//20101126 ��ֹ��ѭ��
        if m_VisibleEvents.Count <= I then Break;
        nCheckCode := 43;
        try //20081017 ȥע��
          MapEvent := m_VisibleEvents.Items[I];
          nVisibleFlag := MapEvent.nVisibleFlag;//20090322 �޸�
        except
          m_VisibleEvents.Delete(I);
          if m_VisibleEvents.Count > 0 then Continue;//20090511 �޸�
          Break;//20090511 ����
        end;
        if MapEvent <> nil then begin
          nCheckCode := 44;
          Case MapEvent.nVisibleFlag of//20090822 �޸�
            0: begin
                nCheckCode := 45;
                SendMsg(Self, RM_HIDEEVENT, 0, Integer(MapEvent), MapEvent.m_nX, MapEvent.m_nY, '');
                nCheckCode := 46;
                m_VisibleEvents.Delete(I);
                nCheckCode := 47;
                if m_VisibleEvents.Count > 0 then Continue;//20090511 �޸�
                Break;//20090511 ����
             end;//0
            1: MapEvent.nVisibleFlag:= 0;//�������ʼ���� 20090823
            2: begin
               SendMsg(Self, RM_SHOWEVENT, MapEvent.m_nEventType, Integer(MapEvent), MakeLong(MapEvent.m_nX, MapEvent.m_nEventParam), MapEvent.m_nY, '');
               MapEvent.nVisibleFlag:= 0;//�������ʼ���� 20090823
             end;
          end;//case
        end;
      except
        Break;
      end;
      Inc(I);
    end;
  except
    MainOutMessage(m_sCharName + ',' + m_sMapName + ',' +IntToStr(m_nCurrX) + ',' +
      IntToStr(m_nCurrY) + ',' +' SearchViewRange 3 CheckCode:' + IntToStr(nCheckCode));
    KickException();
  end;
end;

//-------------------------------------------------------------------------------
(*procedure TAIPlayObject.NewGotoTargetXY;
var
  I, nDir, n10, n14, n20, nOldX, nOldY: Integer;
begin
  try
    if ((m_nCurrX <> m_nTargetX) or (m_nCurrY <> m_nTargetY)) then begin
      n10 := m_nTargetX;
      n14 := m_nTargetY;
      nDir := DR_DOWN;
      if n10 > m_nCurrX then begin
        nDir := DR_RIGHT;
        if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
        if n14 < m_nCurrY then nDir := DR_UPRIGHT;
      end else begin
        if n10 < m_nCurrX then begin
          nDir := DR_LEFT;
          if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
          if n14 < m_nCurrY then nDir := DR_UPLEFT;
        end else begin
          if n14 > m_nCurrY then nDir := DR_DOWN
          else if n14 < m_nCurrY then nDir := DR_UP;
        end;
      end;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(nDir, False);
      n20 := Random(3);
      for I := DR_UP to DR_UPLEFT do begin
        if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
          if n20 <> 0 then Inc(nDir)
          else if nDir > 0 then Dec(nDir)
          else nDir := DR_UPLEFT;
          if (nDir > DR_UPLEFT) then nDir := DR_UP;
          WalkTo(nDir, False);
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.NewGotoTargetXY', [g_sExceptionVer]));
  end;
end;

procedure TAIPlayObject.HeroTail();
var
  nX, nY, nDir: Integer;
begin
  try
    if (GetTickCount - dwTick5F4) > m_dwRunIntervalTime then begin
      dwTick5F4 := GetTickCount;
      if m_nTargetX <> -1 then begin
        if (abs(m_nCurrX - m_nTargetX) > 2) or (abs(m_nCurrY - m_nTargetY) > 2) then begin
          if abs(m_nTargetX - m_nCurrX) > 1 then begin
            if (m_nTargetX > m_nCurrX) then nX := m_nCurrX + 2
            else nX := m_nCurrX - 2;
          end else nX := m_nTargetX;
          if abs(m_nTargetY - m_nCurrY) > 1 then begin
            if (m_nTargetY > m_nCurrY) then nY := m_nCurrY + 2
            else nY := m_nCurrY - 2;
          end else nY := m_nTargetY;
          nDir := GetNextDirection(m_nCurrX, m_nCurrY, nX, nY);
          if RunTo(nDir, False, nX, nY) then begin
            if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT] := 1;
            Dec(m_nHealthTick, 60);
            Dec(m_nSpellTick, 10);
            m_nSpellTick := _MAX(0, m_nSpellTick);
            Dec(m_nPerHealth);
            Dec(m_nPerSpell);
          end else NewGotoTargetXY();
        end else NewGotoTargetXY();
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.HeroTail', [g_sExceptionVer]));
  end;
end; *)

function TAIPlayObject.WarrAttackTarget1(wHitMode: Word): Boolean; {������}
var
  bt06, nCode: Byte;
  boHit: Boolean;
begin
  Result := False;
  try
    if m_TargetCret <> nil then begin
      boHit:= GetAttackDir(m_TargetCret, bt06);
      if (not boHit) and ((wHitMode = 4) or (wHitMode = 15)) then
        boHit:= GetAttackDir(m_TargetCret, 2, bt06);//��ֹ��λ��ɱ��Ч�� 20110521
      if boHit then begin
        m_dwTargetFocusTick := GetTickCount();
        AttackDir(m_TargetCret, wHitMode, bt06, 0);
        m_dwActionTick := GetTickCount();
        BreakHolySeizeMode();
        Result := True;
      end else begin
        if m_TargetCret.m_PEnvir = m_PEnvir then begin
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        end else begin
          DelTargetCreat();
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TAIPlayObject.WarrAttackTarget',[g_sExceptionVer]));
    end;
  end;
end;

function TAIPlayObject.WarrorAttackTarget1(): Boolean; {սʿ����}
var
  UserMagic: pTUserMagic;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    m_wHitMode := 0;
    if m_WAbil.MP > 0 then begin
      if m_TargetCret <> nil then begin
        nCode:= 2;
        if ((m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.25)) or m_TargetCret.m_boCrazyMode) then begin //20080718 ע��,ս�����
          if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin//Ѫ��ʱ��Ŀ����ģʽʱ������λ��ɱ 20080827
            if not (((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
              ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
              ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
              ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
              ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
              ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2))) then begin//20090213 ��������
              nCode:= 3;
              GetGotoXY(m_TargetCret, 2);
              GotoTargetXY( m_nTargetX, m_nTargetY, 0);
            end;
          end;
        end;
      end;
      nCode:= 4;
      SearchMagic();//��ѯħ��
      nCode:= 5;
      if m_nSelectMagic > 0 then begin
        nCode:= 7;
        UserMagic := FindMagic(m_nSelectMagic);
        if (UserMagic <> nil) then begin
          if (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
            case m_nSelectMagic of
              27, 39, 41, 60..65, 68, 75, SKILL_101, SKILL_102: begin
                  if m_TargetCret <> nil then begin
                    nCode:= 8;
                    Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //սʿħ��
                    m_dwHitTick := GetTickCount();
                    Exit;
                  end;
                end;
               7: m_wHitMode := 3; //��ɱ
              12: m_wHitMode := 4; //ʹ�ô�ɱ
              SKILL_89: m_wHitMode := 15;//�ļ���ɱ
              25: m_wHitMode := 5; //ʹ�ð���
              SKILL_90: m_wHitMode := 16;//Բ���䵶(�ļ������䵶)
              26: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 7; //ʹ���һ�
              40: m_wHitMode := 8; //���µ���
              43: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 9; //����ն  20100910 �޸�
              42: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 12;//��Ӱ���� 20100910 �޸�
              SKILL_74: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 13;//���ս��� 20100910 �޸�
              SKILL_96: if UseSpell(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 17;//Ѫ��һ��(ս)
            end;
          end;
        end;
      end;
    end;
    nCode:= 9;
    Result := WarrAttackTarget1(m_wHitMode);
    nCode:= 10;
    if Result then m_dwHitTick := GetTickCount();
  except
    MainOutMessage(Format('{%s} TAIPlayObject.WarrorAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TAIPlayObject.WizardAttackTarget1(): Boolean; {��ʦ����}
var
  UserMagic: pTUserMagic;
  n14: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    m_wHitMode := 0;
    SearchMagic(); //��ѯħ��
    if m_nSelectMagic = 0 then m_boIsUseMagic := True;//�Ƿ��ܶ��
    if m_nSelectMagic > 0 then begin
      if (m_TargetCret <> nil) then begin
        nCode:= 4;
        if not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) or
          ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7) or
          (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7)) then begin//ħ�����ܴ򵽹�
          if (m_nSelectMagic <> 10) then begin//�������Ӱ��
            GetGotoXY(m_TargetCret,3);//��ֻ����Ŀ��3��Χ
            GotoTargetXY( m_nTargetX, m_nTargetY, 0);
          end;
        end;
        {//�ο�JS�����޸� 20110703
        if ((GetTickCount - m_dwRunMagicIntervalTime) > g_Config.dwRunMagicIntervalTime) then begin
          m_dwRunMagicIntervalTime := GetTickCount;
          if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
             ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
            n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
            m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
            if (m_nTargetX > 0) and (m_nTargetY > 0) then HeroTail;
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end;}
      end;
      nCode:= 5;
      UserMagic := FindMagic(m_nSelectMagic);
      if (UserMagic <> nil) then begin
        if (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
          m_dwHitTick := GetTickCount();
          Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
          Exit;
        end;
      end;
    end;
    nCode:= 6;
    m_dwHitTick := GetTickCount();
    if g_Config.boHeroAttackTarget and (m_Abil.Level < 22) then begin//��ʦ22��ǰ�Ƿ�������
      m_boIsUseMagic := False;//�Ƿ��ܶ��
      nCode:= 7;
      Result := WarrAttackTarget1(m_wHitMode);
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.WizardAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TAIPlayObject.TaoistAttackTarget1(): Boolean; {��ʿ���� 20071218}
var
  UserMagic: pTUserMagic;
  n14: integer;
begin
  Result := False;
  try
    m_wHitMode := 0;
     if m_TargetCret <> nil then begin//20090507 ����
       if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT)
         and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
         if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin
           SearchMagic(); //��ѯħ��
         end else begin
           if (GetTickCount()- m_dwSearchMagic > 1300) then begin//20090108 ���Ӳ�ѯħ���ļ��
             SearchMagic(); //��ѯħ��
             m_dwSearchMagic := GetTickCount();
           end else m_boIsUseAttackMagic := False;//��������Ŀ��
         end;
       end else SearchMagic(); //��ѯħ��
     end;
    if m_nSelectMagic = 0 then m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080715
    if m_nSelectMagic > 0 then begin
      if (m_TargetCret <> nil) then begin
        if (not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret)) or ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7)) then begin//ħ�����ܴ򵽹� 20080420                //20090112
          if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT)
            and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
            if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
              GetGotoXY(m_TargetCret, 3);//20080712 ��ֻ����Ŀ��3��Χ
              GotoTargetXY( m_nTargetX, m_nTargetY,0);
            end;
          end else begin
            GetGotoXY(m_TargetCret, 3);//��ֻ����Ŀ��3��Χ
            GotoTargetXY( m_nTargetX, m_nTargetY,0);
          end;
        end;
        {//�ο�JS�����޸� 20110703
        if ((GetTickCount - m_dwRunMagicIntervalTime) > g_Config.dwRunMagicIntervalTime) then begin
          m_dwRunMagicIntervalTime := GetTickCount;
          if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
             ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
            n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
            m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
            if (m_nTargetX > 0) and (m_nTargetY > 0) then HeroTail;
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end;}
      end;

      case m_nSelectMagic of
         SKILL_HEALLING: begin //������ 20080426
            if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) then begin
               UserMagic := FindMagic(m_nSelectMagic);
               if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
                 {Result :=}UseSpell(UserMagic, m_nCurrX, m_nCurrY, nil);
                 m_dwHitTick := GetTickCount();
                 if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                   if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                     m_boIsUseMagic := True;//�ܶ�� 20080916
                     Exit;
                   end else m_nSelectMagic:= 0;
                 end else begin
                   m_boIsUseMagic := True;//�ܶ�� 20080916
                   Exit;
                 end;
               end;
            end;
          end;
        SKILL_BIGHEALLING: begin //Ⱥ��������  20080713
            if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) then begin
               UserMagic := FindMagic(m_nSelectMagic);
               if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
                 {Result :=}UseSpell(UserMagic, m_nCurrX, m_nCurrY, self);
                 m_dwHitTick := GetTickCount();
                 if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                   if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                     m_boIsUseMagic := True;//�ܶ�� 20080916
                     Exit;
                   end else m_nSelectMagic:= 0;
                 end else begin
                   m_boIsUseMagic := True;//�ܶ�� 20080916
                   Exit;
                 end;
               end;
            end;
          end;
        SKILL_FIRECHARM: begin//������,�򲻵�Ŀ��ʱ,�ƶ� 20080711
           if not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) then begin
              GetGotoXY(m_TargetCret,3);
              GotoTargetXY(m_nTargetX, m_nTargetY,1);
           end;
         end;
        SKILL_AMYOUNSUL{6},SKILL_93, SKILL_GROUPAMYOUNSUL{38}: begin //����
            if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and (GetUserItemList(2,1)>= 0) then begin//�̶�
              n_AmuletIndx:= 1;//20080412  �̶���ʶ
            end else
            if (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) and (GetUserItemList(2,2)>= 0)  then  begin//�춾
              n_AmuletIndx:= 2;//20080412 �춾��ʶ
            end;
          end;
        SKILL_CLOAK{18}, SKILL_BIGCLOAK {19}: begin //����������  ������
             UserMagic := FindMagic(m_nSelectMagic);
             if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
               UseSpell(UserMagic, m_nCurrX, m_nCurrY, self);
               m_dwHitTick := GetTickCount();
               if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                 if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                   m_boIsUseMagic := False;//�ܶ�� 20080916
                   Exit;
                 end else m_nSelectMagic:= 0;
               end else begin
                 m_boIsUseMagic := False;//�ܶ�� 20080916
                 Exit;
               end;
             end;
          end;
        SKILL_48,//������ʱ�������ж�� 20080828
        SKILL_SKELLETON,
        SKILL_SINSU,
        SKILL_50,
        SKILL_71,//�ٻ�ʥ��
        SKILL_72, SKILL_104,
        SKILL_73,
        SKILL_101,
        SKILL_102: begin
            UserMagic := FindMagic(m_nSelectMagic);
            if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin
              {Result := }UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
              m_dwHitTick := GetTickCount();
              if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                  m_boIsUseMagic := True;//�ܶ��
                  Exit;
                end else m_nSelectMagic:= 0;
              end else begin
                m_boIsUseMagic := True;//�ܶ��
                Exit;
              end;
            end;
          end;
      end;
      UserMagic := FindMagic(m_nSelectMagic);
      if (UserMagic <> nil) then begin
        if (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ�� 20080606
          m_dwHitTick := GetTickCount();//20080530
          Result := UseSpell(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
          if (m_TargetCret.m_WAbil.MaxHP >= 700) or (not g_Config.boHeroAttackTao) then begin//20090106
            Exit;
          end;
        end;
      end;
    end;
    m_dwHitTick := GetTickCount();

    if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.15)) then m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080715
    if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or                                                                                                                   //20090529 ������������
      ((m_TargetCret.m_WAbil.MaxHP < 700) and g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) and (m_TargetCret.m_btRaceServer <> RC_PLAYMOSTER)) then begin//20090106 ��ʿ22��ǰ�Ƿ�������  �ֵȼ�С��Ӣ��ʱ
      if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin//���߽�Ŀ�꿳 20090212
        GotoTargetXY( m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0);
      end;
      m_boIsUseMagic := False;//�Ƿ��ܶ��
      Result := WarrAttackTarget1(m_wHitMode);
    end;
  except
    //MainOutMessage('{�쳣} TAIPlayObject.TaoistAttackTarget');
  end;
end;

function TAIPlayObject.AttackTarget(): Boolean;
var
  dwAttackTime: LongWord;
  nCode: byte;
begin
  Result := False;
  nCode:= 0;
  try
    if (m_TargetCret <> nil) then begin
      if InSafeZone then begin//Ӣ�۽��밲ȫ���ھͲ���PKĿ��
        if (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) then begin
          m_TargetCret:= nil;
          {$IF M2Version = 1}
          HeroBatterStop;//Ӣ������ֹͣ
          {$IFEND}
          Exit;
        end;
      end;
      if m_TargetCret = self then begin//��ֹӢ���Լ����Լ�
        m_TargetCret:= nil;
        Exit;
      end;
    end;
    nCode:= 2;
    m_dwTargetFocusTick := GetTickCount();
    if m_boDeath or m_boGhost then Exit;
    {$IF HEROVERSION = 1}
    if m_boAI and (m_TargetCret <> nil) and (m_MyHero <> nil) and
      (GetTickCount - m_dwHeroUseSpellTick > 12000) and
      (THeroObject(m_MyHero).m_nFirDragonPoint >= g_Config.nMaxFirDragonPoint) then begin//������,�Զ�ʹ�úϻ�
      {$IF M2Version = 1}if not THeroObject(m_MyHero).m_boUseBatter then begin{$IFEND}//Ӣ������ֹͣ���ʹ�úϻ�
        m_dwHeroUseSpellTick:= GetTickCount();//�Զ�ʹ�úϻ����
        ClientHeroUseSpell;
        m_boIsUseMagic := False;//�Ƿ��ܶ��
        Result := True;
        Exit;
      {$IF M2Version = 1}end;{$IFEND}
    end;
    {$IFEND}
    case m_btJob of
      0: begin
          if (GetTickCount - m_dwHitTick > g_Config.nAIWarrorAttackTime)then begin//20110418
            {$IF M2Version = 1}
            nCode:= 9;
            if HeroBatterAttackTarget then begin
              m_dwHitTick := GetTickCount();
              m_boIsUseMagic := False;//�Ƿ��ܶ��
              Result := True;
              Exit;
            end;
            {$IFEND}
            m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080714
            nCode:= 8;
            Result := WarrorAttackTarget1;
          end;
        end;
      1: begin
          nCode:= 4;
          if (GetTickCount - m_dwHitTick > g_Config.nAIWizardAttackTime){$IF M2Version = 1}or m_boUseBatter{$IFEND} then begin//����Ҳ���ܼ������ 20100408
            nCode:= 41;
            m_dwHitTick := GetTickCount();
            m_boIsUseMagic := False;//�Ƿ��ܶ��
            {$IF M2Version = 1}
            nCode:= 10;
            if HeroBatterAttackTarget then begin
              Result := True;
              Exit;
            end;
            {$IFEND}
            nCode:= 7;
            Result := WizardAttackTarget1;
            m_nSelectMagic := 0;
            Exit;
          end;
          m_nSelectMagic := 0;
        end;
      2: begin
          if (GetTickCount - m_dwHitTick > g_Config.nAITaoistAttackTime){$IF M2Version = 1}or m_boUseBatter{$IFEND} then begin//����Ҳ���ܼ������ 20100408
            m_dwHitTick := GetTickCount();
            m_boIsUseMagic := False;//�Ƿ��ܶ��
            {$IF M2Version = 1}
            nCode:= 11;
            if HeroBatterAttackTarget then begin
              Result := True;
              Exit;
            end;
            {$IFEND}
            nCode:= 6;
            Result := TaoistAttackTarget1;
            m_nSelectMagic := 0;
            Exit;
          end;
          m_nSelectMagic := 0;
        end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.AttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TAIPlayObject.CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  I, nC, n10: Integer;
begin
  Result := 0;
  try
    n10 := nRange;
    if m_VisibleActors.Count > 0 then begin//20080630
      for I := 0 to m_VisibleActors.Count - 1 do begin
        BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
        if BaseObject <> nil then begin
          if not BaseObject.m_boDeath then begin
            if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
              nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
              if nC <= n10 then begin
                Inc(Result);
                //if Result > 2 then break;
              end;
            end;
          end;
        end;
      end;
    end;
  except
  end;
end;

//�Ƿ���Ҫ���
function TAIPlayObject.IsNeedAvoid(): Boolean;
var
  nCode: byte;
begin
  Result := False;
  nCode:= 0;
  try
    if ((GetTickCount - m_dwAutoAvoidTick) > 1100) and m_boIsUseMagic and (not m_boDeath) then begin   //Ѫ����15%ʱ,�ض�Ҫ�� 20080711
      if (m_btJob > 0) and ((m_nSelectMagic = 0) or (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.15))) then begin
        m_dwAutoAvoidTick := GetTickCount();
        nCode:= 1;
        if g_Config.boHeroAttackTarget and (m_Abil.Level < 22) then begin//22��ǰ���������
          if (m_btJob = 1) then begin//����ħ����Ҫ��
            nCode:= 2;
            if CheckTargetXYCount(m_nCurrX, m_nCurrY, 4) > 0 then begin
              Result := True;
              Exit;
            end;
          end;
        end else begin
          nCode:= 3;
          case m_btJob of
            1:begin
               nCode:= 4;
               if CheckTargetXYCount(m_nCurrX, m_nCurrY, 4) > 0 then begin
                Result := True;
                Exit;
               end;
            end;
            2: begin
              nCode:= 5;
              if m_TargetCret <> nil then begin
                nCode:= 6;
                if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                  if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin
                    if (CheckTargetXYCount(m_nCurrX, m_nCurrY, 4{3}) > 0) then begin
                      Result := True;
                      Exit;
                    end;
                  end;
                end else begin
                  nCode:= 7;
                  if (CheckTargetXYCount(m_nCurrX, m_nCurrY, 4{3}) > 0) then begin
                    Result := True;
                    Exit;
                  end;
                end;
              end else begin
                nCode:= 8;
                if (CheckTargetXYCount(m_nCurrX, m_nCurrY, 4{3}) > 0) then begin
                  Result := True;
                  Exit;
                end;
              end;
            end;
          end;//case
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.IsNeedAvoid Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
{���ָ������ͷ�Χ������Ĺ�������}
function TAIPlayObject.CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  I: Integer;
begin
  Result := 0;
  if m_VisibleActors.Count > 0 then begin//20080630
    for I := 0 to m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath then begin
          if IsProperTarget(BaseObject) and
            (not BaseObject.m_boHideMode or m_boCoolEye) then begin
            case nDir of
              DR_UP: begin
                  if (abs(nX - BaseObject.m_nCurrX) <= nRange) and ((BaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
                end;
              DR_UPRIGHT: begin
                  if ((BaseObject.m_nCurrX - nX) in [0..nRange]) and ((BaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
                end;
              DR_RIGHT: begin
                  if ((BaseObject.m_nCurrX - nX) in [0..nRange]) and (abs(nY - BaseObject.m_nCurrY) <= nRange) then Inc(Result);
                end;
              DR_DOWNRIGHT: begin
                  if ((BaseObject.m_nCurrX - nX) in [0..nRange]) and ((nY - BaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
                end;
              DR_DOWN: begin
                  if (abs(nX - BaseObject.m_nCurrX) <= nRange) and ((nY - BaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
                end;
              DR_DOWNLEFT: begin
                  if ((nX - BaseObject.m_nCurrX) in [0..nRange]) and ((nY - BaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
                end;
              DR_LEFT: begin
                  if ((nX - BaseObject.m_nCurrX) in [0..nRange]) and (abs(nY - BaseObject.m_nCurrY) <= nRange) then Inc(Result);
                end;
              DR_UPLEFT: begin
                  if ((nX - BaseObject.m_nCurrX) in [0..nRange]) and ((BaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
                end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TAIPlayObject.AutoAvoid(): Boolean;
 //�Զ����
  function GetAvoidDir(): Integer;
  var
    n10: Integer;
    n14: Integer;
  begin
    n10 := m_TargetCret.m_nCurrX;
    n14 := m_TargetCret.m_nCurrY;
    Result := DR_DOWN;
    if n10 > m_nCurrX then begin
      Result := DR_LEFT;
      if n14 > m_nCurrY then Result := DR_DOWNLEFT;
      if n14 < m_nCurrY then Result := DR_UPLEFT;
    end else begin
      if n10 < m_nCurrX then begin
        Result := DR_RIGHT;
        if n14 > m_nCurrY then Result := DR_DOWNRIGHT;
        if n14 < m_nCurrY then Result := DR_UPRIGHT;
      end else begin
        if n14 > m_nCurrY then Result := DR_UP
        else if n14 < m_nCurrY then Result := DR_DOWN;
      end;
    end;
  end;

  function GetDirXY(nTargetX, nTargetY: Integer): Byte;
  var
    n10: Integer;
    n14: Integer;
  begin
    n10 := nTargetX;
    n14 := nTargetY;
    Result := DR_DOWN;//��
    if n10 > m_nCurrX then begin
      Result := DR_RIGHT;//��
      if n14 > m_nCurrY then Result := DR_DOWNRIGHT;//������
      if n14 < m_nCurrY then Result := DR_UPRIGHT;//������
    end else begin
      if n10 < m_nCurrX then begin
        Result := DR_LEFT;//��
        if n14 > m_nCurrY then Result := DR_DOWNLEFT;//������
        if n14 < m_nCurrY then Result := DR_UPLEFT;//������
      end else begin
        if n14 > m_nCurrY then Result := DR_DOWN//��
        else if n14 < m_nCurrY then Result := DR_UP;//����
      end;
    end;
  end;

  function GetGotoXY(nDir: Integer; var nTargetX, nTargetY: Integer): Boolean;
  var
    n01: Integer;
  begin
    Result := False;
    n01 := 0;
    while True do begin
      case nDir of
        DR_UP: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Dec(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Dec(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_UPRIGHT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Inc(nTargetX, 2);
              Dec(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Inc(nTargetX, 2);
              Dec(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end; 
        DR_RIGHT: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Inc(nTargetX, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Inc(nTargetX, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_DOWNRIGHT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Inc(nTargetX, 2);
              Inc(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Inc(nTargetX, 2);
              Inc(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_DOWN: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Inc(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Inc(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_DOWNLEFT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY,False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Dec(nTargetX, 2);
              Inc(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Dec(nTargetX, 2);
              Inc(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_LEFT: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Dec(nTargetX, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Dec(nTargetX, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
        DR_UPLEFT: begin//������
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 3) = 0) then begin
              Dec(nTargetX, 2);
              Dec(nTargetY, 2);
              Result := True;
              Break;
            end else begin
              if n01 >= 8 then Break;
              Dec(nTargetX, 2);
              Dec(nTargetY, 2);
              Inc(n01, 2);
              Continue;
            end;
          end;
      else begin
          Break;
        end;
      end;
    end;

  end;
  function GetAvoidXY(var nTargetX, nTargetY: Integer): Boolean;
  var
    n10, nDir: Integer;
    nX, nY: Integer;
  begin
    nX := nTargetX;
    nY := nTargetY;
    Result := GetGotoXY(m_btLastDirection, nTargetX, nTargetY);
    n10 := 0;
    while True do begin
      if n10 >= 7 then Break;
      if Result then Break;
      nTargetX := nX;
      nTargetY := nY;
      nDir := Random(7);
      Result := GetGotoXY(nDir, nTargetX, nTargetY);
      Inc(n10);
    end;
    m_btLastDirection := nDir; //m_btDirection;
  end;
var
  nTargetX: Integer;
  nTargetY: Integer;
  nDir: Integer;
begin
  Result := True;
  if (m_TargetCret <> nil) and not m_TargetCret.m_boDeath then begin
    nTargetX := m_nCurrX ;
    nTargetY := m_nCurrY ;
    nDir:= GetNextDirection(m_nCurrX,m_nCurrY,m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
    nDir:= GetBackDir(nDir);
    m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY,nDir,5,m_nTargetX,m_nTargetY);
    Result :=GotoTargetXY(m_nTargetX, m_nTargetY, 1);
  end;
end;
function TAIPlayObject.IsNeedGotoXY(): Boolean; //�Ƿ�����Ŀ��
var
  dwAttackTime: LongWord;
begin
  Result := False;
  if (m_TargetCret <> nil) and (GetTickCount - m_dwAutoAvoidTick > 1100) and
    ((not m_boIsUseAttackMagic) or (m_btJob = 0)) then begin
    if m_btJob > 0 then begin
        if (not m_boIsUseMagic) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > {2}3)
          or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 3{2})) then begin//20081214�޸�
          Result := True;
          Exit;
        end;
        if ((g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or 
           (g_Config.boHeroAttackTao and (m_TargetCret.m_WAbil.MaxHP < 700) and
           (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) and //20090112
           (m_btJob = 2))) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) then begin//20081218 ����22ǰ�Ƿ������� 20090210 ����1��ʱ������Ŀ��
          Result := True;
          Exit;
        end;
    end else begin
      case m_nSelectMagic of //20080501  ����
        SKILL_ERGUM, SKILL_89:begin//��ɱ, �ļ���ɱ����
            if (AllowUseMagic(12) or AllowUseMagic(SKILL_89)) and (m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, m_nTargetX, m_nTargetY)) then begin
              if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) then begin
                dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
                if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                  m_wHitMode:= 4;//��ɱ
                  if AllowUseMagic(SKILL_89) then m_wHitMode:= 15;//�ļ���ɱ
                  m_dwTargetFocusTick := GetTickCount();
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
                  Attack(m_TargetCret, m_btDirection);
                  BreakHolySeizeMode();
                  m_dwHitTick := GetTickCount();
                  Exit;
                end;
              end else begin//new
                if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) then begin
                  Result := True;
                  Exit;
                end;
              end;
            end;
            m_nSelectMagic:= 0;
            if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
              if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 2) then begin
                Result := True;
                Exit;
              end;
            end else
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
              Result := True;
              Exit;
            end;
          end;
        Skill_96: begin//Ѫ��һ��(ս)
            if AllowUseMagic(Skill_96) and (m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, m_nTargetX, m_nTargetY)) then begin
              if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) then begin
                dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
                if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                  m_wHitMode:= 17;//��ɱ
                  m_dwTargetFocusTick := GetTickCount();
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
                  Attack(m_TargetCret, m_btDirection);
                  BreakHolySeizeMode();
                  m_dwHitTick := GetTickCount();
                  Exit;
                end;
              end else begin//new
                if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) then begin
                  Result := True;
                  Exit;
                end;
              end;
            end;
            m_nSelectMagic:= 0;
            if AllowUseMagic(12) or AllowUseMagic(Skill_96) then begin
              if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 2) then begin
                Result := True;
                Exit;
              end;
            end else
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
              Result := True;
              Exit;
            end;
          end;
        SKILL_74:begin//���ս���
            if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) then begin
              if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
                 (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
                 ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4))) then begin
                dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
                if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                  m_wHitMode:= 13;
                  m_dwTargetFocusTick := GetTickCount();
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
                  Attack(m_TargetCret, m_btDirection);
                  BreakHolySeizeMode();
                  m_dwHitTick := GetTickCount();
                  Exit;
                end;
              end else begin
                if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
                  if not (((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                      ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                      ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                      ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
                      ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                      ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2))) then begin
                    Result := True;
                    Exit;
                  end;
                  if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or//20090303
                     ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) then begin
                    Result := True;
                    Exit;
                  end;
                end else
                if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
                  Result := True;
                  Exit;
                end;
              end;
            end;
            m_nSelectMagic:= 0;
            if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
              if not (((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                  ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                  ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                  ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
                  ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                  ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2))) then begin
                Result := True;
                Exit;
              end;
              if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or//20090303
                 ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) then begin
                Result := True;
                Exit;
              end;
            end else
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
              Result := True;
              Exit;
            end;
          end;
        43:begin//20080604 ʵ�ָ�λ�ſ���
          if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) and (m_n42kill = 2) then begin
             if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
                ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
                (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
                ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
                ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4))) then begin
                dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
                if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                  m_wHitMode:= 9;
                  m_dwTargetFocusTick := GetTickCount();
                  m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
                  Attack(m_TargetCret, m_btDirection);
                  BreakHolySeizeMode();
                  m_dwHitTick := GetTickCount();
                  Exit;
                end;
             end else begin
               if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
                 if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<>2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)<>0)) or
                    ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<>0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)<>2)) or
                    ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<>2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)<>2)) then begin
                    Result := True;
                    Exit;
                 end;
               end else
               if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
                 Result := True;
                 Exit;
               end;
             end;
          end;
           m_nSelectMagic:= 0;
          if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, m_nTargetX, m_nTargetY) and (m_n42kill in [1,2]) then begin
            if (Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0) or
               (Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2) or
               (Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2) then begin
              dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
              if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                m_wHitMode:= 9;
                m_dwTargetFocusTick := GetTickCount();
                m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
                Attack(m_TargetCret, m_btDirection);
                BreakHolySeizeMode();
                m_dwHitTick := GetTickCount();
                Exit;
              end
            end else begin
              if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) then begin
                Result := True;
                Exit;
              end;
            end;
          end;
          m_nSelectMagic:= 0;
          if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 2) then begin
              Result := True;
              Exit;
            end;
          end else
          if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
            Result := True;
            Exit;
          end;
        end;
        7, 25, 26, SKILL_90:begin
          if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
            Result := True;
            m_nSelectMagic:= 0;
            Exit;
          end;        
        end;
        else begin
          if AllowUseMagic(12) or AllowUseMagic(SKILL_89) then begin
            if not (((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2))) then begin 
              Result := True;
              Exit;
            end;
            if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or//20090303 ����
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) then begin
              Result := True;
              Exit;
            end;
          end else
          if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin
            Result := True;
            Exit;
          end;
        end;
      end;//case m_nSelectMagic of
    end;
  end;
end;
//ȡ��ɱλ
function TAIPlayObject.GetGotoXY(BaseObject: TBaseObject; nCode:Byte): Boolean;
begin
  Result := False;
  Case nCode of
    2:begin//��ɱλ
      if (m_nCurrX - 2 <= BaseObject.m_nCurrX) and
        (m_nCurrX + 2 >= BaseObject.m_nCurrX) and
        (m_nCurrY - 2 <= BaseObject.m_nCurrY) and
        (m_nCurrY + 2 >= BaseObject.m_nCurrY) and
        ((m_nCurrX <> BaseObject.m_nCurrX) or
        (m_nCurrY <> BaseObject.m_nCurrY)) then begin
        Result := True;
        if ((m_nCurrX - 2) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 2;
          m_nTargetY:= m_nCurrY;
          Exit;
        end;
        if ((m_nCurrX + 2) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 2;
          m_nTargetY:= m_nCurrY;
          Exit;
        end;
        if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY - 2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX ;
          m_nTargetY:= m_nCurrY - 2;
          Exit;
        end;
        if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY + 2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX ;
          m_nTargetY:= m_nCurrY + 2;
          Exit;
        end;
        if ((m_nCurrX - 2) = BaseObject.m_nCurrX) and ((m_nCurrY -2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 2;
          m_nTargetY:= m_nCurrY - 2;
          Exit;
        end;
        if ((m_nCurrX + 2) = BaseObject.m_nCurrX) and ((m_nCurrY - 2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 2;
          m_nTargetY:= m_nCurrY - 2;
          Exit;
        end;
        if ((m_nCurrX - 2) = BaseObject.m_nCurrX) and ((m_nCurrY + 2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 2;
          m_nTargetY:= m_nCurrY + 2;
          Exit;
        end;
        if ((m_nCurrX + 2) = BaseObject.m_nCurrX) and ((m_nCurrY + 2) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 2;
          m_nTargetY:= m_nCurrY + 2;
          Exit;
        end;
      end;
    end;//2
    3:begin//3��
      if (m_nCurrX - 3 <= BaseObject.m_nCurrX) and
        (m_nCurrX + 3 >= BaseObject.m_nCurrX) and
        (m_nCurrY - 3 <= BaseObject.m_nCurrY) and
        (m_nCurrY + 3 >= BaseObject.m_nCurrY) and
        ((m_nCurrX <> BaseObject.m_nCurrX) or
        (m_nCurrY <> BaseObject.m_nCurrY)) then begin
        Result := True;
        if ((m_nCurrX - 3) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 3;
          m_nTargetY:= m_nCurrY;
          Exit;
        end;
        if ((m_nCurrX + 3) = BaseObject.m_nCurrX) and (m_nCurrY = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 3;
          m_nTargetY:= m_nCurrY;
          Exit;
        end;
        if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY - 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX ;
          m_nTargetY:= m_nCurrY - 3;
          Exit;
        end;
        if (m_nCurrX = BaseObject.m_nCurrX) and ((m_nCurrY + 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX ;
          m_nTargetY:= m_nCurrY + 3;
          Exit;
        end;
        if ((m_nCurrX - 3) = BaseObject.m_nCurrX) and ((m_nCurrY - 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 3;
          m_nTargetY:= m_nCurrY - 3;
          Exit;
        end;
        if ((m_nCurrX + 3) = BaseObject.m_nCurrX) and ((m_nCurrY - 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 3;
          m_nTargetY:= m_nCurrY - 3;
          Exit;
        end;
        if ((m_nCurrX - 3) = BaseObject.m_nCurrX) and ((m_nCurrY + 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX - 3;
          m_nTargetY:= m_nCurrY + 3;
          Exit;
        end;
        if ((m_nCurrX + 3) = BaseObject.m_nCurrX) and ((m_nCurrY + 3) = BaseObject.m_nCurrY) then begin
          m_nTargetX:= m_nCurrX + 3;
          m_nTargetY:= m_nCurrY + 3;
          Exit;
        end;
      end;
    end;//3
  end;//Case
end;
//�ܵ�Ŀ������
function TAIPlayObject.RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;
var
  nDir, n10, n14: Integer;
begin
  Result := False;
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] > 0) and (not g_ClientConf.boParalyCanSpell)) or
    (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
    or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20090526
  if not m_boCanRun then Exit;//��ֹ��,���˳�
  if GetTickCount()- dwTick5F4 > m_dwRunIntervalTime then begin //�ܲ�ʹ�õ����ı�������
    n10 := nTargetX;
    n14 := nTargetY;
    nDir:= GetNextDirection(m_nCurrX , m_nCurrY, n10, n14);
    if not RunTo1(nDir, False, nTargetX, nTargetY) then begin
      Result := WalkToTargetXY(nTargetX, nTargetY);
      if Result then dwTick5F4 := GetTickCount();
    end else begin
      if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
        Result := True;
        dwTick5F4 := GetTickCount();
      end;
    end;
  end;
end;
//����Ŀ��
function TAIPlayObject.WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;
var
  I: Integer;
  nDir: Integer;
  n10: Integer;
  n14: Integer;
  n20: Integer;
  nOldX: Integer;
  nOldY: Integer;
begin
  Result := False;
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] <> 0) and (not g_ClientConf.boParalyCanSpell))
    or (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
    or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20080915
  if (abs(nTargetX - m_nCurrX) > 1) or (abs(nTargetY - m_nCurrY) > 1) then begin
    if GetTickCount()- dwTick3F4 > m_dwWalkIntervalTime then begin //�����߼��
      n10 := nTargetX;
      n14 := nTargetY;
      nDir := DR_DOWN;
      if n10 > m_nCurrX then begin
        nDir := DR_RIGHT;
        if n14 > m_nCurrY then nDir := DR_DOWNRIGHT;
        if n14 < m_nCurrY then nDir := DR_UPRIGHT;
      end else begin
        if n10 < m_nCurrX then begin
          nDir := DR_LEFT;
          if n14 > m_nCurrY then nDir := DR_DOWNLEFT;
          if n14 < m_nCurrY then nDir := DR_UPLEFT;
        end else begin
          if n14 > m_nCurrY then nDir := DR_DOWN
          else if n14 < m_nCurrY then nDir := DR_UP;
        end;
      end;
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(nDir, False);
      if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
        Result := True;
        dwTick3F4 := GetTickCount();
      end;
      if not Result then begin
        n20 := Random(3);
        for I := DR_UP to DR_UPLEFT do begin
          if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
            if n20 <> 0 then Inc(nDir)
            else if nDir > 0 then Dec(nDir)
            else nDir := DR_UPLEFT;
            if (nDir > DR_UPLEFT) then nDir := DR_UP;
            WalkTo(nDir, False);
            if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
              Result := True;
              dwTick3F4 := GetTickCount();
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;
function TAIPlayObject.GotoTargetXY(nTargetX, nTargetY, nCode: Integer): Boolean;
begin
  case nCode of
    0:begin//����ģʽ
      if (abs(m_nCurrX - nTargetX) > 2{1}) or (abs(m_nCurrY - nTargetY) > 2{1}) then begin
        if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then begin
          Result := RunToTargetXY(nTargetX, nTargetY);
        end else begin
          Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
        end;
      end else begin
        Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
      end;
    end;//0
    1:begin//���ģʽ
      if (abs(m_nCurrX - nTargetX) > 1) or (abs(m_nCurrY - nTargetY) > 1) then begin
        if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then begin
          Result := RunToTargetXY(nTargetX, nTargetY);
        end else begin
          Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
        end;
      end else begin
        Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
      end;
    end;//1
  end;
end;
procedure TAIPlayObject.SearchMagic();
var
  UserMagic: pTUserMagic;
  nCode: Byte;
begin
  m_nSelectMagic:= 0;
  nCode:= 0;
  try
    m_nSelectMagic := SelectMagic1;
    nCode:= 1;
    if m_nSelectMagic > 0 then begin
      nCode:= 2;
      UserMagic := FindMagic(m_nSelectMagic);
      if UserMagic <> nil then begin
        nCode:= 3;
        m_boIsUseAttackMagic := IsUseAttackMagic{��Ҫ������ħ��};
      end else begin
        nCode:= 5;
        m_boIsUseAttackMagic := False;
      end;
    end else begin
      nCode:= 4;
      m_boIsUseAttackMagic := False;
    end;
  except
    MainOutMessage(Format('{%s} TAIPlayObject.SearchMagic Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TAIPlayObject.SelectMagic1(): Integer;
begin
  Result := 0;
  case m_btJob of
    0: begin //սʿ
        if AllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;
        {$IF M2Version <> 2}
        if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
          if AllowUseMagic(SKILL_101) then begin
            m_dwLatest101Tick := GetTickCount();
            Result := SKILL_101;
            Exit;
          end;
        end;
        {if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
          and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
          if AllowUseMagic(SKILL_102) then begin
            m_dwLatest102Tick := GetTickCount();
            Result := SKILL_102;
            Exit;
          end;
        end; }
        {$IFEND}
        if (abs(m_TargetCret.m_nCurrX - m_nCurrX) < 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 3) and //20100927 ��������ŷ�Ѫ��һ��(ս)
           ((GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick) then begin//Ѫ��һ��(ս)
          if AllowUseMagic(SKILL_96) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
            m_SkillUseTick[0] := GetTickCount;
            Result := SKILL_96;
            Exit;
          end
        end;
        //Զ�������ÿ����ػ��������ս��� 20080603   20090115 ����
        if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) >= 2) and (abs(m_TargetCret.m_nCurrX - m_nCurrX) < 5)) or
          ((abs(m_TargetCret.m_nCurrY - m_nCurrY) >= 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 5)) then begin
          if AllowUseMagic(SKILL_74) and ((GetTickCount - m_dwLatestDailyTick) > 12000{12 * 1000}) then begin //���ս���
            m_boDailySkill := True;
            Result := SKILL_74;
            Exit;
          end;
        end;

        if AllowUseMagic(43) and ((GetTickCount - m_dwLatest42Tick) > g_Config.nKill43UseTime * 1000) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill43HPRate /100))) then begin //����ն  20090213
          m_bo42kill := True;
          Result := 43;
          if (Random(g_Config.n43KillHitRate) = 0) and (g_Config.btHeroSkillMode43 or (m_TargetCret.m_Abil.Level <= m_Abil.Level)) then begin//Ŀ��ȼ��������Լ�,��ʹ���ػ� 20080826
            m_n42kill := 2;//�ػ�
          end else begin
            m_n42kill := 1;//���
          end;
          Exit;
        end;

        //��ɱλ 20080603
        if (abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2) then begin
          if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            Result := SKILL_89;
            exit;
          end;
          if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            Result := 12;
            exit;
          end;
        end;
        if AllowUseMagic(SKILL_74) and ((GetTickCount - m_dwLatestDailyTick) > 12000{12 * 1000}) then begin //���ս��� 20080528
          m_boDailySkill := True;
          Result := SKILL_74;
          Exit;
        end;
        if AllowUseMagic(26) and ((GetTickCount - m_dwLatestFireHitTick) > 9000{9 * 1000}) then begin //�һ�  20080112 ����
          m_boFireHitSkill := True;
          Result := 26;
          Exit;
        end;
        if AllowUseMagic(42) and (GetTickCount - m_dwLatest43Tick > g_Config.nKill42UseTime * 1000) then begin //��Ӱ���� 20080619
          m_bo43kill := True;
          Result := 42;
          Exit;
        end;

        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
         and (m_TargetCret.m_Abil.Level < m_Abil.Level) then begin //PKʱ,ʹ��Ұ����ײ  20080826 Ѫ����800ʱʹ��
          if AllowUseMagic(27) and ((GetTickCount - m_SkillUseTick[27]) >  10000{10 * 1000}) then begin //pkʱ����Է��ȼ����Լ��;�ÿ��һ��ʱ����һ��Ұ��  20080203
            m_SkillUseTick[27] := GetTickCount;
            Result := 27;
            Exit;
          end
        end else begin //���ʹ�� 20080323
          if AllowUseMagic(27) and ((GetTickCount - m_SkillUseTick[27]) > 10000{10 * 1000})
           and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.85)) then begin
             m_SkillUseTick[27] := GetTickCount;
             Result := 27;
             Exit;
          end;
        end;

        if (m_TargetCret.m_Master <> nil) then m_ExpHitter := m_TargetCret.m_Master;//20080924

        if CheckTargetXYCount1(m_nCurrX, m_nCurrY, 1) > 1 then begin //�������Χ   //20080924
          case Random(3) of
            0:begin                                                                                                                                         //20080710 PKʱ����ʨ�Ӻ�
                if AllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if AllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7]:= GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] >  10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if AllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if AllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if AllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
            1:begin
                if AllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if AllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7]:= GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] >  10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if AllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if AllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if AllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
            2:begin
                if AllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if AllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) > 10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7] := GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if AllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then  SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if AllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if AllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
          end;
        end else begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil)) and
           (CheckTargetXYCount1(m_nCurrX, m_nCurrY, 1) > 1) then begin//PK 20080915 ��߳���2��Ŀ���ʹ��
            if AllowUseMagic(40) and (GetTickCount - m_SkillUseTick[40] > 3000) then begin //Ӣ�۱��µ���
              m_SkillUseTick[40] := GetTickCount;
              if not m_boCrsHitkill then  SkillCrsOnOff(True);
              Result := 40;
              exit;
            end;
            if (GetTickCount - m_SkillUseTick[25] > 1500) then begin //Ӣ�۰����䵶
              if AllowUseMagic(SKILL_90) then begin //Բ���䵶(�ļ������䵶)
                if CheckTargetXYCount2(SKILL_90) > 0 then begin
                  if not m_boUseHalfMoon then HalfMoonOnOff(True, 1);
                  m_SkillUseTick[25]:= GetTickCount;
                  Result := SKILL_90;
                  exit;
                end;
              end;
              if AllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                  m_SkillUseTick[25] := GetTickCount;
                  if not m_boUseHalfMoon then HalfMoonOnOff(True, 0);
                  Result := SKILL_BANWOL;
                  exit;
                end;
              end;
            end;
          end;
         //20071213���� ������������ ��ɱ����
          if AllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ����
            m_SkillUseTick[7]:= GetTickCount;
            m_boPowerHit := True;//20080401 ������ɱ
            Result := 7;
            Exit;
          end;
          if (GetTickCount - m_SkillUseTick[12] > 1000) then begin
            if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
              if not m_boUseThrusting then ThrustingOnOff(True);
              m_SkillUseTick[12]:= GetTickCount;
              Result := SKILL_89;
              exit;
            end;
            if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
              if not m_boUseThrusting then ThrustingOnOff(True);
              m_SkillUseTick[12]:= GetTickCount;
              Result := 12;
              Exit;
            end;
          end;
        end;
         //�Ӹߵ���ʹ��ħ��,20080710
        if AllowUseMagic(43) and (GetTickCount - m_dwLatest42Tick > g_Config.nKill43UseTime * 1000) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill43HPRate /100))) then begin //����ն 20090213
          m_bo42kill := True;
          Result := 43;
          if (Random(g_Config.n43KillHitRate) = 0) and (g_Config.btHeroSkillMode43 or (m_TargetCret.m_Abil.Level <= m_Abil.Level)) then begin
           m_n42kill := 2;//�ػ�
          end else begin
           m_n42kill := 1;//���
          end;
          Exit;
        end else
        if AllowUseMagic(42) and (GetTickCount - m_dwLatest43Tick > g_Config.nKill42UseTime * 1000) then begin //��Ӱ����
          m_bo43kill := True;
          Result := 42;
          Exit;
        end else
        if AllowUseMagic(74) and (GetTickCount - m_dwLatestDailyTick > 12000) then begin //���ս���
          m_boDailySkill := True;
          Result := 74;
          Exit;
        end else
        if AllowUseMagic(26) and (GetTickCount - m_dwLatestFireHitTick > 9000) then begin //�һ�
          m_boFireHitSkill := True;
          Result := 26;
          Exit;
        end;
        if AllowUseMagic(40) and (GetTickCount - m_SkillUseTick[40] > 3000) and (CheckTargetXYCount1(m_nCurrX, m_nCurrY, 1) > 1) then begin //Ӣ�۱��µ���
          if not m_boCrsHitkill then SkillCrsOnOff(True);
          m_SkillUseTick[40]:= GetTickCount();
          Result := 40;
          exit;
        end;
        if AllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 3000) then begin//Ӣ�۳��ض�
           m_SkillUseTick[39]:= GetTickCount;
           Result := 39;
           Exit;
        end;
        if (GetTickCount - m_SkillUseTick[25] > 3000) then begin
          if AllowUseMagic(SKILL_90) then begin //Բ���䵶(�ļ������䵶)
            if not m_boUseHalfMoon then HalfMoonOnOff(True, 1);
            m_SkillUseTick[25]:= GetTickCount;
            Result := SKILL_90;
            exit;
          end;
          if AllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
            if not m_boUseHalfMoon then HalfMoonOnOff(True, 0);
            m_SkillUseTick[25]:= GetTickCount;
            Result := SKILL_BANWOL;
            exit;
          end;
        end;
        if (GetTickCount - m_SkillUseTick[12] > 3000) then begin
          if AllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            m_SkillUseTick[12]:= GetTickCount;
            Result := SKILL_89;
            exit;
          end;
          if AllowUseMagic(12) then begin //Ӣ�۴�ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            m_SkillUseTick[12]:= GetTickCount;
            Result := 12;
            exit;
          end;
        end;
        if AllowUseMagic(7) and (GetTickCount - m_SkillUseTick[7] > 3000) then begin //��ɱ����
          m_boPowerHit := True;
          m_SkillUseTick[7]:= GetTickCount;
          Result := 7;
          Exit;
        end;
        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
         and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.6)) then begin //PKʱ,ʹ��Ұ����ײ
          if AllowUseMagic(27) and (GetTickCount - m_SkillUseTick[27] > 3000) then begin
            m_SkillUseTick[27]:= GetTickCount;
            Result := 27;
            Exit;
          end
        end else begin //���ʹ�� 20080323
          if AllowUseMagic(27) and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.6))
           and (GetTickCount - m_SkillUseTick[27] > 3000) then begin
             m_SkillUseTick[27]:= GetTickCount;
             Result := 27;
             Exit;
          end;
        end;
        if AllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
          and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
          (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
          (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
          m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
          Result := 41;
          Exit;
        end;
      end;
    1: begin //��ʦ
        //ʹ�� ħ����
        if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) and (not m_boAbilMagBubbleDefence) then begin
          if AllowUseMagic(66) then begin//4��ħ����
            Result := 66;
            Exit;
          end;
          if AllowUseMagic(31) then begin
            Result := 31;
            Exit;
          end;
        end;
        //�������� 20080925
        if AllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;
        //��������,��ʹ�÷����� 20080206
        if (m_SlaveList.Count = 0) and AllowUseMagic(46) and ((GetTickCount - m_dwLatest46Tick) > g_Config.nCopyHumanTick * 1000)//�ٻ�������
         and ((g_Config.btHeroSkillMode46) or (m_LastHiter<> nil) or (m_ExpHitter<> nil)) then begin
          if (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill46MaxHP_3 /100))) then begin
            Result := 46;
            Exit;
          end;
        end;
        {$IF M2Version <> 2}
        if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
          if AllowUseMagic(SKILL_101) then begin
            m_dwLatest101Tick := GetTickCount();
            Result := SKILL_101;
            Exit;
          end;
        end;
        {if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
          and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
          if AllowUseMagic(SKILL_102) then begin
            m_dwLatest102Tick := GetTickCount();
            Result := SKILL_102;
            Exit;
          end;
        end;}
        {$IFEND}
        if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ��(��)
          if AllowUseMagic(SKILL_97) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
            m_SkillUseTick[0] := GetTickCount;
            Result := SKILL_97;
            Exit;
          end
        end;
        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
          and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin //PKʱ,�Ա���������,ʹ�ÿ��ܻ�
          if AllowUseMagic(8) and ((GetTickCount - m_SkillUseTick[8]) > 3000{3 * 1000}) then begin
            m_SkillUseTick[8] := GetTickCount;
            Result := 8;
            Exit;
          end
        end else begin //���,�ּ������Լ�,�����йְ�Χ�Լ����� ���ܻ�
          if AllowUseMagic(8) and ((GetTickCount - m_SkillUseTick[8]) > 3000)
            and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0)
            and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin
             m_SkillUseTick[8] := GetTickCount;
             Result := 8;
             Exit;
          end;
        end;

        if AllowUseMagic(45) and (GetTickCount - m_SkillUseTick[45] > 3000) then begin
          m_SkillUseTick[45] := GetTickCount;
          Result := 45;//Ӣ�������
          Exit;
        end;

        if (GetTickCount - m_SkillUseTick[10] > 5000) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) then begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
           and (GetDirBaseObjectsCount(m_btDirection,5)> 0) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
            if AllowUseMagic(10) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 10;//Ӣ�ۼ����Ӱ  20080421
              Exit;
            end else
            if AllowUseMagic(9) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 9;//������
              Exit;
            end;
          end else
          if (GetDirBaseObjectsCount(m_btDirection,5)> 1) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
            if AllowUseMagic(10) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 10;//Ӣ�ۼ����Ӱ  20080421
              Exit;
            end else
            if AllowUseMagic(9) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 9;//������
              Exit;
            end;
          end;
        end;

        if AllowUseMagic(32) and (GetTickCount - m_SkillUseTick[32] > 10000) and
          (m_TargetCret.m_Abil.Level < g_Config.nMagTurnUndeadLevel) and
          (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level -1) then begin //Ŀ��Ϊ����ϵ
          m_SkillUseTick[32] := GetTickCount;
          Result := 32; //ʥ����
          Exit;
        end;

        if CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 1 then begin //�������Χ    
          if AllowUseMagic(22) and (GetTickCount - m_SkillUseTick[22] > 10000) then begin
            if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102)
              and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ 20081217
              m_SkillUseTick[22] := GetTickCount;
              Result := 22; //��ǽ
              Exit;
            end;
          end;
          //�����׹�,ֻ������(101,102,104)������(91,92,97)��Ұ��(81)ϵ�е���   20080217
          //��������Ĺ�Ӧ�ö��õ����׹⣬�����׵��������ñ����� 20080228
          if m_TargetCret.m_btRaceServer in [91,92,97,101,102,104] then begin
            if AllowUseMagic(24) and (GetTickCount - m_SkillUseTick[24] > 4000{1000 * 4}) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
              m_SkillUseTick[24] := GetTickCount;
              Result := 24; //�����׹�
              Exit;
            end else
            if AllowUseMagic(91) then begin
              Result := 91; //�ļ��׵���
              Exit;
            end else
            if AllowUseMagic(11) then begin
              Result := 11; //Ӣ���׵���
              Exit;
            end else
            if AllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2) > 2) then begin
              Result := 33; //Ӣ�۱�����
              Exit;
            end else
            if (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
              if AllowUseMagic(92) then begin
                m_SkillUseTick[58] := GetTickCount;
                Result := 92; //�ļ����ǻ���
                Exit;
              end;
              if AllowUseMagic(58) then begin
                m_SkillUseTick[58] := GetTickCount;
                Result := 58; //���ǻ��� 20080528
                Exit;
              end;
            end;
          end;

          case Random(4) of //���ѡ��ħ��
            0: begin
                //������,�����,�׵���,���ѻ���,Ӣ�۱�����,���ǻ��� �Ӹߵ���ѡ��
                if AllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if AllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if AllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 33; //Ӣ�۱�����
                  Exit;
                end else
                if AllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;

                if AllowUseMagic(37) then begin
                  Result := 37; //Ӣ��Ⱥ���׵�
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;//������
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;
              end;
            1: begin
                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if AllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if AllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if AllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin//������,�����,������,���ѻ���,������  �Ӹߵ���ѡ��
                  Result := 33;//������ 
                  Exit;
                end else
                if AllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1)  then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;
              end;
            2:begin
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if AllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if AllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if AllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin  //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;

                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
              end;
            3: begin
                if AllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if AllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if AllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if AllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin  //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;

                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
              end;
          end;
        end else begin
         //ֻ��һ����ʱ���õ�ħ��
           if AllowUseMagic(22) and (GetTickCount - m_SkillUseTick[22] > 10000) then begin
             if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102)
               and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ
               m_SkillUseTick[22] := GetTickCount;
               Result := 22;
               Exit;
             end;
           end;
           case Random(4) of //���ѡ��ħ��
             0:begin
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if AllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) then begin //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
             end;
             1:begin
                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if AllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;
             end;
             2:begin
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if AllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if AllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;
                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
             end;
             3: begin
                if AllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if AllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if AllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if AllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if AllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if AllowUseMagic(5) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if AllowUseMagic(1) then begin
                  Result := 1;//������
                  Exit;
                end;

                if AllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if AllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
             end;
           end;
        end;
      //�Ӹߵ���ʹ��ħ�� 20080710
        if (GetTickCount - m_SkillUseTick[58] > 1500) then begin
          if AllowUseMagic(92) then begin //�ļ����ǻ���
            m_SkillUseTick[58]:= GetTickCount;
            Result := 92;
            Exit;
          end;
          if AllowUseMagic(58) then begin //���ǻ���
            m_SkillUseTick[58]:= GetTickCount;
            Result := 58;
            Exit;
          end;
        end;
        if AllowUseMagic(47) then begin//������
          Result := 47;
          Exit;
        end;
        if AllowUseMagic(45) then begin//Ӣ�������
          Result := 45;
          Exit;
        end;
        if AllowUseMagic(44) then begin
          Result := 44;
          Exit;
        end;
        if AllowUseMagic(37) then begin//Ӣ��Ⱥ���׵�
          Result := 37;
          Exit;
        end;
        if AllowUseMagic(33) then begin//Ӣ�۱�����
          Result := 33;
          Exit;
        end;
        if AllowUseMagic(32) and (m_TargetCret.m_Abil.Level < g_Config.nMagTurnUndeadLevel) and
          (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level -1) then begin //Ŀ��Ϊ����ϵ
          Result := 32; //ʥ����
          Exit;
        end;
        if AllowUseMagic(24) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin//�����׹�
          Result := 24;
          Exit;
        end;
        if AllowUseMagic(23) then begin//���ѻ���
          Result := 23;
          Exit;
        end;
        if AllowUseMagic(91) then begin
          Result := 91; //�ļ��׵���
          Exit;
        end;
        if AllowUseMagic(11) then begin//Ӣ���׵���
          Result := 11;
          Exit;
        end;
        if AllowUseMagic(10) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
          Result := 10;//Ӣ�ۼ����Ӱ
          Exit;
        end;
        if AllowUseMagic(9) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
          Result := 9;//������
          Exit;
        end;
        if AllowUseMagic(5) then begin
          Result := 5;//�����
          Exit;
        end;
        if AllowUseMagic(1) then begin
          Result := 1;//������
          Exit;
        end;
        if AllowUseMagic(22) then begin
          if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102) and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ 20081217
            Result := 22; //��ǽ
            Exit;
          end;
        end;
      end;
    2: begin //��ʿ
        if (m_SlaveList.Count = 0) and CheckHeroAmulet(1,5) and (GetTickCount - m_SkillUseTick[17] > 3000) and
        (AllowUseMagic(72) or AllowUseMagic(30) or AllowUseMagic(17)) and (m_WAbil.MP > 20) then begin
          m_SkillUseTick[17]:= GetTickCount;
          //Ĭ��,�Ӹߵ���
          if AllowUseMagic(104) then Result := 104//�ٻ�����
          else if AllowUseMagic(72) then Result := 72//�ٻ�����
          else if AllowUseMagic(30) then Result := 30//�ٻ�����
          else if AllowUseMagic(17) then Result := 17;//�ٻ�����
          Exit;
        end;

        if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) and (not m_boAbilMagBubbleDefence) then begin
          if AllowUseMagic(73) then begin//������ 20080909
            Result := 73;
            Exit;
          end;
        end;

        //�������� 20080925
        if AllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;
     {$IF M2Version <> 2}
      if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
        if AllowUseMagic(SKILL_101) then begin
          m_dwLatest101Tick := GetTickCount();
          Result := SKILL_101;
          Exit;
        end;
      end;
      {if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
        and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
        if AllowUseMagic(SKILL_102) then begin
          m_dwLatest102Tick := GetTickCount();
          Result := SKILL_102;
          Exit;
        end;
      end; }
      {$IFEND}
      if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ��(��)
        if AllowUseMagic(SKILL_98) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
          m_SkillUseTick[0] := GetTickCount;
          Result := SKILL_98;
          Exit;
        end
      end;

      if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
       and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level <= m_WAbil.Level) then begin //PKʱ,�Ա���������,ʹ��������
        if AllowUseMagic(48) and ((GetTickCount - m_SkillUseTick[48]) > 3000{3 * 1000}) then begin
          m_SkillUseTick[48] := GetTickCount;
          Result := 48;
          Exit;
        end;
      end else begin //���,�ּ������Լ�,�����йְ�Χ�Լ����� ������
        if AllowUseMagic(48) and ((GetTickCount - m_SkillUseTick[48]) > 5000)//20090108 ��3��ĵ�5��
          and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0)
          and (m_TargetCret.m_WAbil.Level <= m_WAbil.Level)  then begin
           m_SkillUseTick[48] := GetTickCount;
           Result := 48;
           Exit;
        end;
      end;
      //�޼����� 20091204 �ƶ�λ��
      if AllowUseMagic(50) and (GetTickCount - m_SkillUseTick[50] > g_Config.nAbilityUpTick * 1000) and (m_wStatusArrValue[2]=0)
        and ((g_Config.btHeroSkillMode50) or (not g_Config.btHeroSkillMode50 and (m_TargetCret.m_Abil.HP >=700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER))) then begin//20080827
        m_SkillUseTick[50] := GetTickCount;
        Result := 50;
        Exit;
      end;

      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and (not m_TargetCret.m_boUnPosion) and (GetUserItemList(2,1)>= 0) //�̶�
        and ((g_Config.btHeroSkillMode) or (not g_Config.btHeroSkillMode and (m_TargetCret.m_Abil.HP >=700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)))
        and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) < 7{4}) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 7{4}))
        and (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153, 156..158])) then begin //����Ѫ������800�Ĺ���  �޸ľ��� 20080704 ������ǽ
        n_AmuletIndx:= 0;//20080413
        case Random(2) of
         0: begin
              if AllowUseMagic(38) and (GetTickCount - m_SkillUseTick[38] > 1000) then  begin
                if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                  if m_PEnvir.AllowMagics(SKILL_GROUPAMYOUNSUL, 1) then begin
                    m_SkillUseTick[38] := GetTickCount;
                    Result := SKILL_GROUPAMYOUNSUL;//Ӣ��Ⱥ��ʩ��
                    exit;
                  end;
                end;
              end else
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if AllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if AllowUseMagic(SKILL_AMYOUNSUL) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_AMYOUNSUL, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_AMYOUNSUL;//Ӣ��ʩ����
                      Exit;
                    end;
                  end;
                end;
              end;
            end;
         1: begin
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if AllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if AllowUseMagic(SKILL_AMYOUNSUL) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_AMYOUNSUL, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_AMYOUNSUL;//Ӣ��ʩ����
                      Exit;
                    end;
                  end;
                end;
              end;
            end;
        end;
      end;
      if (m_TargetCret.m_wStatusTimeArr[POISON_DAMAGEARMOR] = 0) and (not m_TargetCret.m_boUnPosion) and (GetUserItemList(2,2)>= 0) //�춾
        and ((g_Config.btHeroSkillMode) or (not g_Config.btHeroSkillMode and (m_TargetCret.m_Abil.HP >= 700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)))
        and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) < 7{4}) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 7{4}))
        and (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153, 156..158])) then begin //����Ѫ������100�Ĺ��� ������ǽ
        n_AmuletIndx:= 0;//20080413
        case Random(2) of
         0: begin
              if AllowUseMagic(38) and (GetTickCount - m_SkillUseTick[38] > 1000) then  begin
                if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                  if m_PEnvir.AllowMagics(SKILL_GROUPAMYOUNSUL, 1) then begin
                    m_SkillUseTick[38] := GetTickCount;
                    Result := SKILL_GROUPAMYOUNSUL;//Ӣ��Ⱥ��ʩ��
                    exit;
                  end;
                end;
              end else
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if AllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if AllowUseMagic(SKILL_AMYOUNSUL) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_AMYOUNSUL, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_AMYOUNSUL;//Ӣ��ʩ����
                      Exit;
                    end;
                  end;
                end;
              end;
            end;
         1: begin
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if AllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if AllowUseMagic(SKILL_AMYOUNSUL) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_AMYOUNSUL, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_AMYOUNSUL;//Ӣ��ʩ����
                      Exit;
                    end;
                  end;
                end;
              end;
            end;
        end;
      end;
    //end;
      if AllowUseMagic(51) and (GetTickCount - m_SkillUseTick[51] > 5000) then begin//Ӣ��쫷��� 20080917
        m_SkillUseTick[51] := GetTickCount;
        Result := 51;
        exit;
      end;
      if CheckHeroAmulet(1,1) then begin//ʹ�÷���ħ��
        case Random(3) of
          0:begin
            if AllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;
            if AllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if AllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin//20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
            if AllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������ 20090403 +6
              Result := 52; //Ӣ��������
              Exit;
            end;
          end;
          1:begin
            if AllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin//������ 20090403 +6
              Result := 52;
              Exit;
            end;
            if AllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;            
            if AllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if AllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin //20080401�޸��жϷ��ķ��� //20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
          end;//1
          2:begin
            if AllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin//20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
            if AllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;
            if AllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if AllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������  20090403 +6
              Result := 52;
              Exit;
            end;
          end;//2
        end;//case Random(3) of ��
        //���ܴӸߵ���ѡ�� 20080710
        if AllowUseMagic(94) then begin
          Result := 94; //Ӣ���ļ���Ѫ��
          exit;
        end;
        if AllowUseMagic(59) then begin//Ӣ����Ѫ��
          Result := 59;
          exit;
        end;
        if AllowUseMagic(54) then begin//Ӣ�������� 20080917
          Result := 54;
          exit;
        end;
        if AllowUseMagic(53) then begin//Ӣ��Ѫ�� 20080917
          Result := 53;
          exit;
        end;
        if AllowUseMagic(51) then begin//Ӣ��쫷��� 20080917
          Result := 51;
          exit;
        end;
        if AllowUseMagic(13) then begin//Ӣ�������
          Result := 13;
          exit;
        end;
        if AllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������ 20090403 +6
          Result := 52;
          Exit;
        end;
      end;
    end;//��ʿ
  end;//case ְҵ
end;
//սʿ�ж�ʹ��
function TAIPlayObject.CheckTargetXYCount1(nX, nY, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  I, n10: Integer;
begin
  Result := 0;
  n10 := nRange;
  if m_VisibleActors.Count > 0 then begin
    for I := 0 to m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath then begin
          if IsProperTarget(BaseObject) and
            (not BaseObject.m_boHideMode or m_boCoolEye) then begin
            if (abs(nX - BaseObject.m_nCurrX) <= n10) and (abs(nY - BaseObject.m_nCurrY) <= n10) then begin
              Inc(Result);
            end;
          end;
        end;
      end;
    end;
  end;
end;
//�����䵶�ж�Ŀ�꺯��
function TAIPlayObject.CheckTargetXYCount2(nMode: Word): Integer;
var
  nC, n10, I: Integer;
  nX, nY: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  nC := 0;
  if m_VisibleActors.Count > 0 then begin
    for I := 0 to m_VisibleActors.Count - 1 do begin
      case nMode of
        SKILL_BANWOL: n10 := (m_btDirection + g_Config.WideAttack[nC]) mod 8;
        SKILL_90: n10 := (m_btDirection + g_Config.CrsAttack[nC]) mod 8;
      end;
      if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n10, 1, nX, nY) then begin
        BaseObject := m_PEnvir.GetMovingObject(nX, nY, True);
        if BaseObject <> nil then begin
          if not BaseObject.m_boDeath then begin
            if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
              Inc(Result);
            end;
          end;
        end;
      end;
      Inc(nC);
      case nMode of
        SKILL_BANWOL: if nC >= 3 then Break;
        SKILL_90: if nC >= 7 then Break;
      end;
    end;
  end;
end;
//�����������ܻ�ʹ��
function TAIPlayObject.CheckTargetXYCount3(nX, nY, nRange, nCount: Integer): Integer;
var
  BaseObject: TBaseObject;
  I, n10: Integer;
begin
  Result := 0;
  n10 := nRange;
  if m_VisibleActors.Count > 0 then begin
    for I := 0 to m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath then begin
          if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
            if (abs(nX - BaseObject.m_nCurrX) <= n10) and (abs(nY - BaseObject.m_nCurrY) <= n10) then begin
              Inc(Result);
              if Result > nCount then Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;
//���� nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ    nCount Ϊ�־�,������
Function TAIPlayObject.CheckHeroAmulet(nType: Integer; nCount: Integer):Boolean;
var
  I: Integer;
  UserItem: pTUserItem;
  AmuletStdItem: pTStdItem;
begin
  try
    Result:= False;
    if m_UseItems[U_ARMRINGL].wIndex > 0 then begin
      AmuletStdItem := UserEngine.GetStdItem(m_UseItems[U_ARMRINGL].wIndex);
      if (AmuletStdItem <> nil) then begin
        if (AmuletStdItem.StdMode = 25) then begin
          case nType of
            1: begin
                if (AmuletStdItem.Shape = 5) and (Round(m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                  Result:= True;
                  Exit;
                end;
              end;
            2: begin
                if (AmuletStdItem.Shape <= 2) and (Round(m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                  Result:= True;
                  Exit;
                end;
              end;
          end;
        end;
      end;
    end;

    if m_UseItems[U_BUJUK].wIndex > 0 then begin
      AmuletStdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
      if (AmuletStdItem <> nil) then begin
        if (AmuletStdItem.StdMode = 25) then begin
          case nType of //
            1: begin//��
                if (AmuletStdItem.Shape = 5) and (Round(m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                  Result:= True;
                  Exit;
                end;
              end;
            2: begin//��
                if (AmuletStdItem.Shape <= 2) and (Round(m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                  Result:= True;
                  Exit;
                end;
              end;
          end;
        end;
      end;
    end;

    //�����������Ƿ���ڶ�,�����
    if m_ItemList.Count > 0 then begin//20080628
      for I := 0 to m_ItemList.Count - 1 do begin //���������Ϊ��
        UserItem := m_ItemList.Items[I];
        if UserItem <> nil then begin
          AmuletStdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if (AmuletStdItem <> nil) then begin
            if (AmuletStdItem.StdMode = 25) then begin
              case nType of
                1: begin
                    if (AmuletStdItem.Shape = 5) and (Round(UserItem.Dura / 100) >= nCount) then begin  //20071227
                      Result:= True;
                      Exit;
                    end;
                  end;
                2: begin
                    if (AmuletStdItem.Shape <= 2) and (Round(UserItem.Dura / 100) >= nCount) then begin
                      Result:= True;
                      Exit;
                    end;
                  end;
              end;//case
            end;
          end;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TAIPlayObject.CheckHeroAmulet',[g_sExceptionVer]));
    end;
  end;
end;
end.
