
unit ObjMon;
{ virtual ��ʾ�����ⷽ������ dynamic������麯��������Ϊ������override�õ�,ֻ�������ǵ�ʵ�ֲ�һ����vitrual ռ�õĿռ��㣬���ٶȿ�Щ��
  override ��ʾ�Ǹ��Ƿ�����Ҫ���������б����и÷����Ķ��壬���Ҳ�����˳������ͼ���ֵ�����ͱ���ƥ�䣻������չ�������еĸ÷���
������ȡ����(�粻�����������еĸ÷������ͬ��ȡ��)��}
interface
uses
  Windows, Classes, Grobal2, ObjBase, SysUtils, IniFiles, Controls;
type
  TMonster = class(TAnimalObject)
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean; //�����ص���
  private
    function Think: Boolean;
    function MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override; //FFFC
    function AttackTarget(): Boolean; virtual; //FFEB
    procedure Run; override;
  end;
  TChickenDeer = class(TMonster)
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TATMonster = class(TMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSlowATMonster = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TScorpion = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TSpitSpider = class(TATMonster)
    m_boUsePoison: Boolean;
  private
    procedure SpitAttack(btDir: Byte);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; {virtual;//} override; //FFEB
  end;
  THighRiskSpider = class(TSpitSpider)
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TBigPoisionSpider = class(TSpitSpider)
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TGasAttackMonster = class(TATMonster)
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget: Boolean; override;
    function sub_4A9C78(bt05: Byte): TBaseObject; virtual; //FFEA
  end;
  TCowMonster = class(TATMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TMagCowMonster = class(TATMonster)  //��������
  private
    procedure sub_4A9F6C(btDir: Byte);
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget: Boolean; override;
  end;

  TCowKingMonster = class(TATMonster) //  ���Ӧ����ţħ����
    dw558: LongWord;
    bo55C: Boolean;
    bo55D: Boolean;
    n560: Integer;
    dw564: LongWord;
    dw568: LongWord;
    dw56C: LongWord;
    dw570: LongWord;
  private

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
    procedure Initialize(); override;
  end;
  TElectronicScolpionMon = class(TMonster)
  private
    m_boUseMagic: Boolean;
    procedure LightingAttack(nDir: Integer);

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TLightingZombi = class(TMonster)
  private
    procedure LightingAttack(nDir: Integer);

  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;

 TFairyMonster = class(TMonster) //����
    m_dwAutoAvoidTick: LongWord;  //�Զ���ܼ��
    m_btLastDirection: Byte;//���ķ���
    m_boIsUseAttackMagic: Boolean;//�Ƿ���Թ��� 20080618
    m_dwActionTick: LongWord;//�������
    nWalkSpeed: Integer;//DB���õ���·�ٶ� 20090105
    nHitCount: Word;//������� 20090105
  private
    function FlyAxeAttack(Target: TBaseObject): Boolean;
    procedure ResetElfMon; //2007.12.4
    //function RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;//20080214
    function WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;//20080214
    function WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;//20080214
    function GotoTargetXY(nTargetX, nTargetY: Integer): Boolean;//20080214

    function CheckActionStatus(): Boolean;//���Ӽ���������ļ��
    function AutoAvoid(): Boolean; //�Զ���� //20080214
    function IsNeedAvoid(): Boolean; //�Ƿ���Ҫ���
    function CheckTargetXYCount(nX, nY, nRange: Integer): Integer; //������һ����Χ�Ĺ�����  20080214
    function CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;{���ָ������ͷ�Χ������Ĺ�������}//20080214
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function IsNeedGotoXY(): Boolean;virtual; //�Ƿ�����Ŀ��  20090113
    procedure RecalcAbilitys; override;
    function AttackTarget(): Boolean; override;
  end;

(*   TFireFairyMonster= class(TFairyMonster)//����
  private
    function FlyAxeAttack(Target: TBaseObject): Boolean;
  public
   { constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function IsNeedGotoXY(): Boolean;virtual; }
    procedure RecalcAbilitys; override;
    function AttackTarget(): Boolean; override;
  end;   *)

  TDigOutZombi = class(TMonster)
  private
    procedure sub_4AA8DC;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TZilKinZombi = class(TATMonster)
    dw558: LongWord;
    nZilKillCount: Integer;//�������
    dw560: LongWord;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    procedure Run; override;
  end;
  TWhiteSkeleton = class(TATMonster)
    m_boIsFirst: Boolean;
  private
    procedure sub_4AAD54;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure RecalcAbilitys(); override;
    procedure Run; override;
  end;

  TWhiteSkeletonEx = class(TWhiteSkeleton)//ǿ���ٻ�����
    m_boIsFirst: Boolean;
  private
  public
    constructor Create(); override;
  end;

  TScultureMonster = class(TMonster)
  private
    procedure MeltStone; //
    procedure MeltStoneAll;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
  end;
  TScultureKingMonster = class(TMonster)
    m_nDangerLevel: Integer;
    m_SlaveObjectList: TList; //0x55C
  private
    procedure MeltStone;
    procedure CallSlave;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override; //0FFED
    procedure Run; override;
  end;
  TGasMothMonster = class(TGasAttackMonster) //Ш��
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function sub_4A9C78(bt05: Byte): TBaseObject; override; //FFEA
  end;
  TGasDungMonster = class(TGasAttackMonster)
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
  end;
  TElfMonster = class(TMonster)
    boIsFirst: Boolean; //0x558
  private
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure RecalcAbilitys(); override;
    procedure Run; override;
  end;
  TElfWarriorMonster = class(TSpitSpider)
    boIsFirst: Boolean; //0x560
    dwDigDownTick: LongWord; //0x564
  private
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure RecalcAbilitys(); override;
    procedure Run; override;
  end;

  TGiantSickleSpiderATMonster = class(TATMonster)//����֩�� 20080809
    m_boExploration: Boolean;//�Ƿ��̽�� 20080810
    //m_nButchRate: Integer;//��ȡ��Ʒ����
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б� 20080810
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
  end;

  TSalamanderATMonster = class(TATMonster)//���Ȼ�����:4��4��ǽ����,ʩ����
    m_boExploration: Boolean;//�Ƿ��̽�� 20080810
    //m_nButchRate: Integer;//��ȡ��Ʒ����
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б� 20080810
  private
    function MagMakeFireCross(PlayObject: TBaseObject; nDamage, nHTime, nX, nY: Integer): Integer;    
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Die; override;
    function AttackTarget():Boolean; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
  end;

  TTempleGuardian = class(TScultureMonster)//ʥ����ʿ 20080809
    m_boExploration: Boolean;//�Ƿ��̽�� 20080810
    //m_nButchRate: Integer;//��ȡ��Ʒ����
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б� 20080810
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); override;
  end;

  TheCrutchesSpider = class(TMonster)//����֩��:��������(Ⱥ��),������
    m_boExploration: Boolean;//�Ƿ��̽�� 20080810
    //m_nButchRate: Integer;//��ȡ��Ʒ����
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б� 20080810
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; override;
    procedure Run; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
  end;

  TYanLeiWangSpider = class(TATMonster)//�������� 20080811
    m_boExploration: Boolean;//�Ƿ��̽��
    //m_nButchRate: Integer;//��ȡ��Ʒ����
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б�
    boIsSpiderMagic: Boolean;//�Ƿ����֩����
    m_dwSpiderMagicTick: LongWord;//���֩������ʱ,������ʱ����Ŀ�����ϵ�С����ʾ
  private
    procedure SpiderMagicAttack(nPower, nX, nY: Integer; nRage: Integer);//���֩����
  public
    constructor Create(); override;
    destructor Destroy; override;
    function AttackTarget(): Boolean; virtual;//override; 20080914 �޸�
    procedure Run; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
  end;

  TSwordsmanMon = class(TATMonster) //����ո���,��Ӱ���� 2���ڿ��Թ����Ĺ�
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function AttackTarget(): Boolean; override;
  end;

  TWealthAnimalMon = class(TATMonster) //������ 20090517
    m_nGameGird: Integer;//����ͽ�ֵ
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure StruckDamage(nDamage: Integer);override;//�ܹ���,������װ���ĳ־�
    procedure StruckDamage1(nDamage: Integer);//��ָ����Ʒ��������Ѫ�����ۼ�����ͽ�ֵ����������ʾ
    procedure Run; override;
    procedure Die; override;
    function AttackTarget(): Boolean; override;
  end;

  TNoAttackMon =  class(TATMonster)//���ṥ������Ĺ֣���������������Ʒ 20090524
    m_boExploration: Boolean;//�Ƿ��̽��
    m_nButchChargeClass: Byte;//̽���շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
    m_nButchChargeCount: Integer;//̽��ÿ���շѵ���
    boIntoTrigger: Boolean;//�Ƿ���봥��
    m_ButchItemList: TList;//��̽����Ʒ�б�
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure AddItemsFromConfig();//��ȡ��̽����Ʒ
  end;

  TShengSuMonster = class(TMonster)//ʥ��(��ʱ��)
    boIsFirst: Boolean;
    boEx: Boolean;//ǿ��
  private
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    procedure RecalcAbilitys(); override;
    procedure Run; override;
  end;
  TShengSuWarriorMonster = class(TSpitSpider)//����ʥ��(����ʱ��)
    boIsFirst: Boolean;
    dwDigDownTick: LongWord;
    boEx: Boolean;//ǿ��
  private
    procedure AppearNow;
    procedure ResetElfMon;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Die; override;
    procedure RecalcAbilitys(); override;
    procedure Run; override;
  end;
  TPetsMon = class(TAnimalObject)//�����:������,�ܹ�������Ѫ,���������ƶ���ͼ,��ͼ�ػ�,���ܶ�
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean; //�����ص���
    m_sMasterName: string[ACTORNAMELEN]; //����������
    m_nHappiness: LongWord;//���ֶ�
    m_dwPetsMonDecMaxHapp: Word;//�����տɼ����ֶ�����
    m_dwPetsMonIncMaxHapp: Word;//�����տɼӿ��ֶ�����
    m_TodayDate: TDate;//��������
    m_nProtectTargetX, m_nProtectTargetY: Integer;//�ػ�����
    m_boProtectOK: Boolean;//�����ػ�����
    m_nGotoProtectXYCount: Integer;//�����ػ�������ۼ���
  private
    function Think: Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure StruckDamage(nDamage: Integer);override;//�ܹ���,������װ���ĳ־�
    //function AttackTarget(): Boolean;override;//�������̲�����
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Die; override;
    procedure Run; override;
    procedure SaveMasterList(sStr: string);//����ι����־
    //procedure DamageHealth(nDamage: Integer); override;
  end;

  TPsycheMonster = class(TAnimalObject)//����(JS)
    m_nAttackRange: Integer;
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean;
    nHitCount: Word;//������� 20090105
    nWalkSpeed: Integer;//DB���õ���·�ٶ� 20090105
  private
    procedure FlyAttack(Target: TBaseObject);
    function Think(): Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Run; override;
    function AttackTarget: Boolean; virtual;
    procedure RecalcAbilitys(); override;
  end;

  TFireFairyMonster= class(TPsycheMonster)//����
  private
    function FlyAxeAttack(Target: TBaseObject): Boolean;
  public
    procedure RecalcAbilitys; override;
    function AttackTarget(): Boolean; override;
  end;

implementation

uses UsrEngn, M2Share, Event, HUtil32, ObjHero;

{ TMonster }
constructor TMonster.Create;
begin
  inherited;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 6; //6
  m_nRunTime := 250;
  m_dwSearchTime := Random(2000) + 3000;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 80;
  m_boAddToMaped := False;//��ͼ�Ƿ���� 20080830
end;

destructor TMonster.Destroy;
begin
  inherited;
end;
function TMonster.MakeClone(sMonName: string; OldMon: TBaseObject): TBaseObject;
var
  ElfMon: TBaseObject;
begin
  Result := nil;
  try
    ElfMon := UserEngine.RegenMonsterByName(m_PEnvir.sMapName, m_nCurrX, m_nCurrY, sMonName);
    if (ElfMon <> nil) and (OldMon <> nil) then begin//20080901 �޸�
      ElfMon.m_Master := OldMon.m_Master;
      ElfMon.m_dwMasterRoyaltyTick := OldMon.m_dwMasterRoyaltyTick;
      ElfMon.m_dwMasterRoyaltyTime:= OldMon.m_dwMasterRoyaltyTime;//�����ѱ��ʱ 20080813
      ElfMon.m_btSlaveMakeLevel := OldMon.m_btSlaveMakeLevel;
      ElfMon.m_btSlaveExpLevel := OldMon.m_btSlaveExpLevel;
      ElfMon.RecalcAbilitys;
      ElfMon.RefNameColor;
      if OldMon.m_Master <> nil then OldMon.m_Master.m_SlaveList.Add(ElfMon);
      ElfMon.m_WAbil := OldMon.m_WAbil;
      ElfMon.m_wStatusTimeArr := OldMon.m_wStatusTimeArr;
      ElfMon.m_TargetCret := OldMon.m_TargetCret;
      ElfMon.m_dwTargetFocusTick := OldMon.m_dwTargetFocusTick;
      ElfMon.m_LastHiter := OldMon.m_LastHiter;
      ElfMon.m_LastHiterTick := OldMon.m_LastHiterTick;
      ElfMon.m_btDirection := OldMon.m_btDirection;
      Result := ElfMon;
    end;
  except
  end;
end;

function TMonster.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

function TMonster.Think(): Boolean; //004A8E54
var
  nOldX, nOldY: Integer;
  nCode: Byte;//20090206
begin
  Result := False;
  nCode:= 0;
  try
    if (GetTickCount - m_dwThinkTick) > 3000{3 * 1000} then begin
      m_dwThinkTick := GetTickCount();
      nCode:= 1;
      if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
      nCode:= 2;
      if (m_TargetCret <> nil) then begin//20090206 ����
        if not IsProperTarget(m_TargetCret) then m_TargetCret := nil;
      end;
    end;
    nCode:= 3;
    if m_boDupMode then begin
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      nCode:= 4;
      WalkTo(Random(8), False);
      if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
        m_boDupMode := False;
        Result := True;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TMonster.Think Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TMonster.AttackTarget(): Boolean; //004A8F34
var
  bt06, nCode: Byte;//20081020
begin
  Result := False;
  nCode := 0;
  Try
    if m_TargetCret <> nil then begin
      nCode := 13;
      if (not m_TargetCret.m_boGhost) then begin//20090415 ����
        nCode := 14;
        if (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) and (m_TargetCret.m_Abil.Level <= 22) then begin
          nCode := 12;
          if (THEROOBJECT(m_TargetCret).m_btStatus = 1) then  begin//20080510 Ӣ��22��ǰ,����ʱ����
            nCode := 2;
            DelTargetCreat();
            Exit;
          end;
        end;
        nCode := 3;
        if GetAttackDir(m_TargetCret, bt06) then begin
          nCode := 4;
          if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
            m_dwHitTick := GetTickCount();
            m_dwTargetFocusTick := GetTickCount();
            nCode := 5;
            Attack(m_TargetCret, bt06); //FFED
            nCode := 6;
            m_TargetCret.SetLastHiter(self);//20080629
            nCode := 7;
            BreakHolySeizeMode();
          end;
          Result := True;
        end else begin
          nCode := 8;
          if m_TargetCret.m_PEnvir = m_PEnvir then begin
            nCode := 9;
            if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin //20080605 ����
              nCode := 10;
              SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
            end;
          end else begin
            nCode := 11;
            DelTargetCreat();
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TMonster.AttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

procedure TMonster.Run;
var
  nX, nY: Integer;
  nCode: Byte;//20080907 
begin
  nCode:= 0;
  try
    if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and
      (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
      and (m_wStatusArrValue[23] = 0) then begin
      nCode:= 1;
      if Think then begin
        inherited;
        Exit;
      end;
      nCode:= 2;
      if m_boWalkWaitLocked then begin
        if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then begin
          m_boWalkWaitLocked := False;
        end;
      end;
      nCode:= 3;
      if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin
        m_dwWalkTick := GetTickCount();
        Inc(m_nWalkCount);
        if m_nWalkCount > m_nWalkStep then begin
          m_nWalkCount := 0;
          m_boWalkWaitLocked := True;
          m_dwWalkWaitTick := GetTickCount();
        end;
        nCode:= 4;
        if not m_boRunAwayMode then begin
          if not m_boNoAttackMode then begin
            if m_TargetCret <> nil then begin
              nCode:= 5;
              if AttackTarget then begin
                nCode:= 51;
                inherited;
                Exit;
              end;
            end else begin
              m_nTargetX := -1;
              if m_boMission then begin
                m_nTargetX := m_nMissionX;
                m_nTargetY := m_nMissionY;
              end;
            end;
          end; //if not bo2C0 then begin
          nCode:= 6;
          if m_Master <> nil then begin
            if m_TargetCret = nil then begin
              nCode:= 70;
              if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin//20090705
                nCode:= 71;
                m_Master.GetBackPosition(nX, nY);
                nCode:= 72;
                if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY ) > 1) then begin
                  m_nTargetX := nX;
                  m_nTargetY := nY;
                  if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then begin
                    nCode:= 8;
                    if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then begin
                      m_nTargetX := m_nCurrX;
                      m_nTargetY := m_nCurrY;
                    end
                  end;
                end;
              end;
            end; //if m_TargetCret = nil then begin
            nCode:= 9;
            if m_Master <> nil then begin//20081216
              if not m_Master.m_boGhost then begin//20081216
                if (not m_Master.m_boSlaveRelax) and
                  ((m_PEnvir <> m_Master.m_PEnvir) or
                  (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
                  (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
                  nCode:= 10;
                  SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
                end;
              end;
            end;
          end; //if m_Master <> nil then begin
        end else begin
          nCode:= 11;
          if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then begin
            m_boRunAwayMode := False;
            m_dwRunAwayTime := 0;
          end;
        end; //004A937E
        nCode:= 12;
        if (m_Master <> nil) then begin
          if m_Master.m_boSlaveRelax then begin
            inherited;
            Exit;
          end;  
        end; //004A93A6
        if m_nTargetX <> -1 then begin
          nCode:= 13;
          GotoTargetXY();
        end else begin
          nCode:= 14;
          if m_TargetCret = nil then Wondering(); // FFEE   //Jacky
        end;
      end; //if not bo510 and ((GetTickCount - m_dwWalkTick) > n4FC) then begin
    end; //
    inherited;
  except
    MainOutMessage(Format('{%s} TMonster.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

{ TChickenDeer }

constructor TChickenDeer.Create; //004A93E8
begin
  inherited;
  m_nViewRange := 5;
end;

destructor TChickenDeer.Destroy;
begin
  inherited;
end;

procedure TChickenDeer.Run; //004A9438
var
  I: Integer;
  nC, n10, n14: Integer;
  BaseObject1C, BaseObject: TBaseObject;
begin
  n10 := 9999;
  BaseObject := nil;
  BaseObject1C := nil;
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and
    (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then begin
      if m_VisibleActors.Count > 0 then begin //20080629
        for I := 0 to m_VisibleActors.Count - 1 do begin
          BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
          if BaseObject = nil then Continue;
          if BaseObject.m_boDeath then Continue;
          if IsProperTarget(BaseObject) then begin
            if not BaseObject.m_boHideMode or m_boCoolEye then begin
              nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
              if nC < n10 then begin
                n10 := nC;
                BaseObject1C := BaseObject;
              end;
            end;
          end;
        end; // for
      end;
      if BaseObject1C <> nil then begin
        m_boRunAwayMode := True;
        m_TargetCret := BaseObject1C;
      end else begin
        m_boRunAwayMode := False;
        m_TargetCret := nil;
      end;
    end; //
    if m_boRunAwayMode and (m_TargetCret <> nil) and
      (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then begin
      if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 6) and (abs(m_nCurrX - BaseObject.m_nCurrX) <= 6) then begin
        n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
      end;
    end;
  end;
  inherited;
end;

{ TATMonster }

constructor TATMonster.Create; //004A9690
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TATMonster.Destroy;
begin

  inherited;
end;

procedure TATMonster.Run;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE] = 0) and
    (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and m_boIsVisibleActive then begin//20090503 �޸�
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then begin
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget(); //����Ŀ��
    end;
  end;
  inherited;
end;

{ TSlowATMonster }

constructor TSlowATMonster.Create; //004A97AC
begin
  inherited;
end;

destructor TSlowATMonster.Destroy;
begin
  inherited;
end;
{ TScorpion }

constructor TScorpion.Create; //004A97F0
begin
  inherited;
  m_boAnimal := True;
end;

destructor TScorpion.Destroy;
begin

  inherited;
end;

{ TSpitSpider }
constructor TSpitSpider.Create; //004A983C
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boAnimal := True;
  m_boUsePoison := True;
end;

destructor TSpitSpider.Destroy;
begin
  inherited;
end;

procedure TSpitSpider.SpitAttack(btDir: Byte); //004A98AC
var
  WAbil: pTAbility;
  nC, n10, n14, n18, n1C: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n1C := (Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
  if n1C <= 0 then Exit;
  SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  nC := 0;

  while (nC < 5) do begin
    n10 := 0;
    while (n10 < 5) do begin
      if g_Config.SpitMap[btDir, nC, n10] = 1 then begin
        n14 := m_nCurrX - 2 + n10;
        n18 := m_nCurrY - 2 + nC;
        BaseObject := m_PEnvir.GetMovingObject(n14, n18, True);
        if (BaseObject <> nil) then begin
          if (BaseObject <> Self) and
            (IsProperTarget(BaseObject)) and
            (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then begin
            n1C := BaseObject.GetMagStruckDamage(Self, n1C, 0, 0);
            if n1C > 0 then begin
              BaseObject.StruckDamage(n1C);
              BaseObject.SetLastHiter(self);//20080629
              //BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, n1C, m_WAbil.HP, m_WAbil.MaxHP, Integer(Self), '', 300);
              BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, n1C, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '', 300);//20090424 �޸�
              if m_boUsePoison then begin
                if (Random(m_btAntiPoison + 20) = 0) then
                  BaseObject.MakePosion(POISON_DECHEALTH, 30, 1);
              end;
            end;
          end;
        end;
      end;
      Inc(n10);
      {
      if n10 >= 5 then break;
      }
    end;
    Inc(nC);
    //if nC >= 5 then break;
  end; // while
end;
function TSpitSpider.AttackTarget: Boolean;
var
  btDir: Byte;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if TargetInSpitRange(m_TargetCret, btDir) then begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      SpitAttack(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
    Exit;
  end;
  if m_TargetCret.m_PEnvir = m_PEnvir then begin
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin //20080605 ����
      SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
    end;
  end else begin
    DelTargetCreat();
  end;
end;

{ THighRiskSpider }

constructor THighRiskSpider.Create; //004A9B64
begin
  inherited;
  m_boAnimal := False;
  m_boUsePoison := False;
end;

destructor THighRiskSpider.Destroy;
begin

  inherited;
end;

{ TBigPoisionSpider }

constructor TBigPoisionSpider.Create; //004A9BBC
begin
  inherited;
  m_boAnimal := False;
  m_boUsePoison := True;
end;

destructor TBigPoisionSpider.Destroy;
begin

  inherited;
end;

{ TGasAttackMonster }

constructor TGasAttackMonster.Create; //004A9C14
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boAnimal := True;
end;

destructor TGasAttackMonster.Destroy;
begin
  inherited;
end;

function TGasAttackMonster.sub_4A9C78(bt05: Byte): TBaseObject;
var
  WAbil: pTAbility;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  Result := nil;
  m_btDirection := bt05;
  WAbil := @m_WAbil;
  n10 := Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC);
  if n10 > 0 then begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    BaseObject := GetPoseCreate();
    if (BaseObject <> nil) and
      IsProperTarget(BaseObject) and
      (Random(BaseObject.m_btSpeedPoint) < m_btHitPoint) then begin
      n10 := BaseObject.GetMagStruckDamage(Self, n10, 0, 0);
      if n10 > 0 then begin
        BaseObject.StruckDamage(n10);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, n10, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '', 300);
        if (Random(BaseObject.m_btAntiPoison + 20) = 0) and (not BaseObject.m_boUnParalysis) {$IF M2Version <> 2}and (not BaseObject.m_boCanUerSkill102){$IFEND} and (Random(100) >= BaseObject.m_nUnParalysisRate) then begin//20100513 �޸�
          BaseObject.MakePosion(POISON_STONE, 5, 0)
        end;
        Result := BaseObject;
      end;
    end;
  end;
end;

function TGasAttackMonster.AttackTarget(): Boolean; //004A9DD4
var
  btDir: Byte;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if GetAttackDir(m_TargetCret, btDir) then begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      sub_4A9C78(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
  end else begin
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin //20080605 ����
         SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end;
end;

{ TCowMonster }

constructor TCowMonster.Create; //004A9EB4
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TCowMonster.Destroy;
begin

  inherited;
end;

{ TMagCowMonster }

constructor TMagCowMonster.Create; //004A9F10
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TMagCowMonster.Destroy;
begin

  inherited;
end;
procedure TMagCowMonster.sub_4A9F6C(btDir: Byte);
var
  WAbil: pTAbility;
  n10: Integer;
  BaseObject: TBaseObject;
begin
  m_btDirection := btDir;
  WAbil := @m_WAbil;
  n10 := Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC);
  if n10 > 0 then begin
    SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    BaseObject := GetPoseCreate();
    if (BaseObject <> nil) and
      IsProperTarget(BaseObject) and
      (m_nAntiMagic >= 0) then begin
      n10 := BaseObject.GetMagStruckDamage(Self, n10, 0, 0);
      if n10 > 0 then begin
        BaseObject.StruckDamage(n10);
        BaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, n10, BaseObject.m_WAbil.HP, BaseObject.m_WAbil.MaxHP, Integer(Self), '', 300);
      end;
    end;
  end;
end;

function TMagCowMonster.AttackTarget: Boolean;
var
  btDir: Byte;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if GetAttackDir(m_TargetCret, btDir) then begin
    if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
      m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      sub_4A9F6C(btDir);
      BreakHolySeizeMode();
    end;
    Result := True;
  end else begin
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin //20080605 ����
         SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end;
end;

{ TCowKingMonster //�������}



constructor TCowKingMonster.Create; //004AA160
begin
  inherited;
  m_dwSearchTime := Random(1500) + {500}800;//20090421 ����
  dw558 := GetTickCount();
  bo2BF := True;
  n560 := 0;
  bo55C := False;
  bo55D := False;
end;

destructor TCowKingMonster.Destroy;
begin

  inherited;
end;
procedure TCowKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer); //004AA1F0
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, nPower div 2, nPower div 2, True);
  //  inherited;
end;

procedure TCowKingMonster.Initialize;
begin
  dw56C := m_nNextHitTime;
  dw570 := m_nWalkSpeed;
  inherited;

end;
procedure TCowKingMonster.Run; //004AA294
var
  n8, nC, n10: Integer;
  nCode: Byte;//20091207
begin
  nCode:= 0;
  Try
    if (not m_boDeath) and (not m_boGhost) and ((GetTickCount - dw558) > 30000) then begin
      dw558 := GetTickCount();
      nCode:= 1;
      if (m_TargetCret <> nil) and (sub_4C3538 >= 5) then begin
        nCode:= 2;
        m_TargetCret.GetBackPosition(n8, nC);
        nCode:= 3;
        if m_PEnvir.CanWalk(n8, nC, False) then begin
          nCode:= 4;
          SpaceMove(m_PEnvir.sMapName, n8, nC, 0);
          Exit;
        end;
        nCode:= 5;
        MapRandomMove(m_PEnvir.sMapName, 0);
        Exit;
      end;
      nCode:= 6;
      n10 := n560;
      n560 := 7 - m_WAbil.HP div (m_WAbil.MaxHP div 7);
      if (n560 >= 2) and (n560 <> n10) then begin
        bo55C := True;
        dw564 := GetTickCount();
      end;
      if bo55C then begin
        if (GetTickCount - dw564) < 8000 then begin
          m_nNextHitTime := 10000;
        end else begin
          bo55C := False;
          bo55D := True;
          dw568 := GetTickCount();
        end;
      end; //004AA43D
      nCode:= 7;
      if bo55D then begin
        if (GetTickCount - dw568) < 8000 then begin
          m_nNextHitTime := 500;
          m_nWalkSpeed := 400;
        end else begin
          bo55D := False;
          m_nNextHitTime := dw56C;
          m_nWalkSpeed := dw570;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TCowKingMonster.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
  inherited;
end;

{ TLightingZombi }

constructor TLightingZombi.Create; //004AA4B4
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
end;

destructor TLightingZombi.Destroy;
begin

  inherited;
end;
procedure TLightingZombi.LightingAttack(nDir: Integer);
var
  nSX, nSY, nTX, nTY, nPwr: Integer;
  WAbil: pTAbility;
begin
  m_btDirection := nDir;
  SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 1, nSX, nSY) then begin
    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, nDir, 9, nTX, nTY);
    WAbil := @m_WAbil;
    nPwr := (Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    MagPassThroughMagic(nSX, nSY, nTX, nTY, nDir, nPwr, nPwr, True, 0);
  end;
  BreakHolySeizeMode();
end;
procedure TLightingZombi.Run; //004AA604
var
  nAttackDir: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE ] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and
    ((GetTickCount - m_dwSearchEnemyTick) > 8000) then begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) and m_boIsVisibleActive then begin//20090503 �޸�
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();//�����ɹ���Ŀ��
    end;
    if (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) and (m_TargetCret <> nil) and
      (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 4) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 4) then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and
        (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) and (Random(3) <> 0) then begin
        inherited;
        Exit;
      end;
      GetBackPosition(m_nTargetX, m_nTargetY);
    end;
    if (m_TargetCret <> nil) then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) < 6) and
         (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 6) and (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then begin
         m_dwHitTick := GetTickCount();
         nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
         LightingAttack(nAttackDir);
      end;
    end;
  end;
  inherited;
end;

{ TDigOutZombi }

constructor TDigOutZombi.Create; //004AA848
begin
  inherited;
  m_nViewRange := 7;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 95;
  m_boFixedHideMode := True;
end;

destructor TDigOutZombi.Destroy;
begin

  inherited;
end;

procedure TDigOutZombi.sub_4AA8DC;
var
  Event: TEvent;
begin
  Event := TEvent.Create(m_PEnvir, m_nCurrX, m_nCurrY, 1, 300000{5 * 60 * 1000}, True);
  g_EventManager.AddEvent(Event);
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, Integer(Event), '');
end;

procedure TDigOutZombi.Run; //004AA95C
var
  I: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE {5}] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin
    if m_boFixedHideMode then begin
      if m_VisibleActors.Count > 0 then begin//20080629
        for I := 0 to m_VisibleActors.Count - 1 do begin
          BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
          if BaseObject = nil then Continue;
          if BaseObject.m_boDeath then Continue;
          if IsProperTarget(BaseObject) then begin
            if not BaseObject.m_boHideMode or m_boCoolEye then begin
              if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 3) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 3) then begin
                sub_4AA8DC();
                m_dwWalkTick := GetTickCount + 1000;
                Break;
              end;
            end;
          end;
        end; // for
      end;
    end else begin //004AB0C7
      if (((GetTickCount - m_dwSearchEnemyTick) > 8000) or
        (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil))) and m_boIsVisibleActive then begin//20090503 �޸�
        m_dwSearchEnemyTick := GetTickCount();
        SearchTarget();//�����ɹ���Ŀ��
      end;
    end;
  end;
  inherited;
end;


{ TZilKinZombi }

constructor TZilKinZombi.Create;
begin
  inherited;
  m_nViewRange := 6;
  m_dwSearchTime := Random(1500) + 2500;
  m_dwSearchTick := GetTickCount();
  m_btRaceServer := 96;
  nZilKillCount := 0;
  if Random(3) = 0 then begin
    nZilKillCount := Random(3) + 1;
  end;
end;

destructor TZilKinZombi.Destroy;
begin
  inherited;
end;

procedure TZilKinZombi.Die;
begin
  inherited;
  m_boNoItem := True;//20090208 ����������󻹻ᱬ��Ʒ
  if nZilKillCount > 0 then begin
    dw558 := GetTickCount();
    dw560 := (Random(20) + 4) * 1000;
  end;
  Dec(nZilKillCount);
end;

procedure TZilKinZombi.Run; //004AABE4
begin
  if m_boDeath and (not m_boGhost) and (nZilKillCount >= 0) and
    (m_wStatusTimeArr[POISON_STONE {5}] = 0) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
    and (m_wStatusArrValue[23] = 0) and (m_VisibleActors.Count > 0) and
    ((GetTickCount - dw558) >= dw560) then begin
    m_Abil.MaxHP := m_Abil.MaxHP shr 1;
    m_dwFightExp := m_dwFightExp div 2;
    m_Abil.HP := m_Abil.MaxHP;
    m_WAbil.HP := m_Abil.MaxHP;
    ReAlive();//����
    m_dwWalkTick := GetTickCount + 1000
  end;
  inherited;
end;

{ TWhiteSkeleton }

constructor TWhiteSkeleton.Create; //00004AACCC
begin
  inherited;
  m_boIsFirst := True;
  m_boFixedHideMode := True;
  m_btRaceServer := 100;
  m_nViewRange := 6;
end;

destructor TWhiteSkeleton.Destroy;
begin
  inherited;
end;

procedure TWhiteSkeleton.RecalcAbilitys; //004AAD38
begin
  inherited;
  sub_4AAD54();
end;
procedure TWhiteSkeleton.Run;
begin
  if m_boIsFirst then begin
    m_boIsFirst := False;
    m_btDirection := 5;
    m_boFixedHideMode := False;
    SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited;
end;

procedure TWhiteSkeleton.sub_4AAD54; 
begin
  m_nNextHitTime := _MAx(200, 3000 - m_btSlaveMakeLevel * 600);
  m_nWalkSpeed := _MAx(200, 1200 - m_btSlaveMakeLevel * 250);
  m_dwWalkTick := GetTickCount + m_nNextHitTime;
end;

{TWhiteSkeletonEx ǿ���ٻ�����}
constructor TWhiteSkeletonEx.Create;
begin
  inherited;
  m_boIsFirst := False;
  m_boFixedHideMode := True;
  m_btRaceServer := 100;
  m_nViewRange := 6;
end;

{ TScultureMonster }

constructor TScultureMonster.Create; //004AAE20
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRange := 7;
  m_boStoneMode := True;
  m_nCharStatusEx := STATE_STONE_MODE;
end;

destructor TScultureMonster.Destroy;
begin
  inherited;
end;

procedure TScultureMonster.MeltStone;
begin
  m_nCharStatusEx := 0;
  m_nCharStatus := GetCharStatus();
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boStoneMode := False;
end;
procedure TScultureMonster.MeltStoneAll;
var
  I: Integer;
  List10: TList;
  BaseObject: TBaseObject;
begin
  MeltStone();
  List10 := TList.Create;
  try
    m_PEnvir.GetMapBaseObjects(m_nCurrX, m_nCurrY, 7, List10);
    if List10.Count > 0 then begin//20080629
      for I := 0 to List10.Count - 1 do begin
        BaseObject := TBaseObject(List10.Items[I]);
        if BaseObject <> nil then begin
          if BaseObject.m_boStoneMode then begin
            if BaseObject is TScultureMonster then begin
              TScultureMonster(BaseObject).MeltStone
            end;
          end;
        end;
      end; // for
    end;
  finally
   List10.Free;
  end; 
end;

procedure TScultureMonster.Run; //004AAF98
var
  I: Integer;
  BaseObject: TBaseObject;
  nCode: Byte;//20080812 ����
begin
  nCode:= 0;
  try
    if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE] = 0)
      and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and
      (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then begin
      if m_boStoneMode then begin
        nCode:= 1;
        if m_VisibleActors.Count > 0 then begin//20080629
          nCode:= 2;
          for I := 0 to m_VisibleActors.Count - 1 do begin
            nCode:= 3;
            BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
            nCode:= 4;
            if BaseObject = nil then Continue;
            nCode:= 5;
            if BaseObject.m_boDeath then Continue;
            nCode:= 6;
            if IsProperTarget(BaseObject) then begin
              nCode:= 7;
              if not BaseObject.m_boHideMode or m_boCoolEye then begin
                nCode:= 8;
                if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2) then begin
                  nCode:= 9;
                  MeltStoneAll();
                  Break;
                end;
              end;
            end;
          end; // for
        end;
      end else begin //004AB0C7
        if (((GetTickCount - m_dwSearchEnemyTick) > 8000) or
          (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil))) and m_boIsVisibleActive then begin//20090503 �޸�
          nCode:= 10;
          m_dwSearchEnemyTick := GetTickCount();
          SearchTarget();//�����ɹ���Ŀ��
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TScultureMonster.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
  inherited;
end;

{ TScultureKingMonster }

constructor TScultureKingMonster.Create; //004AB120
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_nViewRange := 8;
  m_boStoneMode := True;
  m_nCharStatusEx := STATE_STONE_MODE;
  m_btDirection := 5;
  m_nDangerLevel := 5;
  m_SlaveObjectList := TList.Create;
end;

destructor TScultureKingMonster.Destroy; //004AB1C8
begin
  m_SlaveObjectList.Free;
  inherited;
end;
procedure TScultureKingMonster.MeltStone; //004AB208
var
  Event: TEvent;
begin
  m_nCharStatusEx := 0;
  m_nCharStatus := GetCharStatus();
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  m_boStoneMode := False;
  Event := TEvent.Create(m_PEnvir, m_nCurrX, m_nCurrY, ET_SCULPEICE{6}, 300000{5 * 60 * 1000}, True);
  g_EventManager.AddEvent(Event);
end;
//�ٻ�����
procedure TScultureKingMonster.CallSlave;
var
  I: Integer;
  nC: Integer;
  n10, n14: Integer;
  BaseObject: TBaseObject;
begin
  nC := Random(6) + 6;
  GetFrontPosition(n10, n14);
  for I := 1 to nC do begin
    if m_SlaveObjectList.Count >= 30 then Break;
    BaseObject := UserEngine.RegenMonsterByName(m_sMapName, n10, n14, g_Config.sZuma[Random(4)]);
    if BaseObject <> nil then begin
      m_SlaveObjectList.Add(BaseObject);
    end;
  end; // for
end;
procedure TScultureKingMonster.Attack(TargeTBaseObject: TBaseObject; nDir: Integer); //004AB3E8
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  if TargeTBaseObject <> nil then begin
    WAbil := @m_WAbil;
    nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
    HitMagAttackTarget(TargeTBaseObject, 0, nPower, True);
  end;
end;
procedure TScultureKingMonster.Run; //004AB444
var
  I: Integer;
  BaseObject: TBaseObject;
begin
  if (not m_boGhost) and (not m_boDeath) and (m_wStatusTimeArr[POISON_STONE] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then begin
    if m_boStoneMode then begin
      //MeltStone();//������
      if m_VisibleActors.Count > 0 then begin//20080629
        for I := 0 to m_VisibleActors.Count - 1 do begin
          BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
          if BaseObject = nil then Continue;
          if BaseObject.m_boDeath then Continue;
          if IsProperTarget(BaseObject) then begin
            if not BaseObject.m_boHideMode or m_boCoolEye then begin
              if (abs(m_nCurrX - BaseObject.m_nCurrX) <= 2) and (abs(m_nCurrY - BaseObject.m_nCurrY) <= 2) then begin
                MeltStone();
                Break;
              end;
            end;
          end;
        end; // for
      end;
    end else begin
      if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
        (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then begin
        m_dwSearchEnemyTick := GetTickCount();
        if m_boIsVisibleActive then SearchTarget();//�����ɹ���Ŀ�� 20090503 �޸�
        //CallSlave(); //������
        if (m_nDangerLevel > m_WAbil.HP / m_WAbil.MaxHP * 5) and (m_nDangerLevel > 0) then begin
          Dec(m_nDangerLevel);
          CallSlave();
        end;
        if m_WAbil.HP = m_WAbil.MaxHP then m_nDangerLevel := 5;
      end;
    end;
    for I := m_SlaveObjectList.Count - 1 downto 0 do begin
      if m_SlaveObjectList.Count <= 0 then Break;
      BaseObject := TBaseObject(m_SlaveObjectList.Items[I]);
      if BaseObject <> nil then begin
        if BaseObject.m_boDeath or BaseObject.m_boGhost then
          m_SlaveObjectList.Delete(I);
      end;
    end; // for
  end;
  inherited;
end;
{ TGasMothMonster }

constructor TGasMothMonster.Create; //004AB6B8
begin
  inherited;
  m_nViewRange := 7;
end;

destructor TGasMothMonster.Destroy;
begin
  inherited;
end;

function TGasMothMonster.sub_4A9C78(bt05: Byte): TBaseObject; //004AB708
var
  BaseObject: TBaseObject;
begin
  BaseObject := inherited sub_4A9C78(bt05);
  if (BaseObject <> nil) and (Random(3) = 0) and (BaseObject.m_boHideMode) then begin
    BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {8}] := 1;
  end;
  Result := BaseObject;
end;
procedure TGasMothMonster.Run; //004AB758
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5}] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) and
    (Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed) then begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 8000) or
      (((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil)) then begin
      m_dwSearchEnemyTick := GetTickCount();
      sub_4C959C();
    end;
  end;
  inherited;
end;
{ TGasDungMonster }

constructor TGasDungMonster.Create; //004AB7F4
begin
  inherited;
  m_nViewRange := 7;
end;

destructor TGasDungMonster.Destroy;
begin

  inherited;
end;

{ TElfMonster }

procedure TElfMonster.AppearNow; //����
begin
  boIsFirst := False;
  m_boFixedHideMode := False;
  //SendRefMsg (RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
//   Appear;
//   ResetElfMon;
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800; //
end;

constructor TElfMonster.Create;
begin
  inherited;
  m_nViewRange := 6;
  m_boFixedHideMode := True;
  m_boNoAttackMode := True;
  boIsFirst := True;
end;

destructor TElfMonster.Destroy;
begin

  inherited;
end;

procedure TElfMonster.RecalcAbilitys; //004AB8B0
begin
  inherited;
  ResetElfMon();
end;

procedure TElfMonster.ResetElfMon(); //004AB8CC
begin
  m_nWalkSpeed := 500 - m_btSlaveMakeLevel * 50;
  m_dwWalkTick := GetTickCount + 2000;
end;

procedure TElfMonster.Run;
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
  nCode: Byte;
begin
  nCode:= 0;
  Try
    if boIsFirst then begin
      nCode:= 1;
      boIsFirst := False;
      m_boFixedHideMode := False;
      nCode:= 2;
      SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      nCode:= 3;
      ResetElfMon();
    end;
    nCode:= 4;
    if m_boDeath then begin
      if (GetTickCount - m_dwDeathTick > 2000{2 * 1000}) then begin
        MakeGhost();
      end;
    end else begin
      nCode:= 6;
      boChangeFace := False;
      if m_TargetCret <> nil then boChangeFace := True;
      if (m_Master <> nil) then begin
        if ((m_Master.m_TargetCret <> nil) or (m_Master.m_LastHiter <> nil)) then boChangeFace := True;
      end;  
      nCode:= 7;
      if boChangeFace then begin
        nCode:= 8;
        ElfMon := MakeClone(m_sCharName + '1', Self);
        nCode:= 9;
        if ElfMon <> nil then begin
          nCode:= 10;
          ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
          nCode:= 11;
          if ElfMon is TElfWarriorMonster then TElfWarriorMonster(ElfMon).AppearNow;
          nCode:= 12;
          m_Master := nil;
          KickException();
        end;
      end;
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TElfMonster.Run Code:%d',[g_sExceptionVer, nCode]));
    KickException();
  end;
end;
{ TElfWarriorMonster }
procedure TElfWarriorMonster.AppearNow; //004ABB60
begin
  boIsFirst := False;
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800; 
  dwDigDownTick := GetTickCount();
end;

constructor TElfWarriorMonster.Create;
begin
  inherited;
  m_nViewRange := 6;
  m_boFixedHideMode := True;
  boIsFirst := True;
  m_boUsePoison := False;
end;

destructor TElfWarriorMonster.Destroy;
begin
  inherited;
end;

procedure TElfWarriorMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;

procedure TElfWarriorMonster.ResetElfMon();
begin
  m_nNextHitTime := _MAX(200 ,1500 - m_btSlaveMakeLevel * {100}80);//20090318
  m_nWalkSpeed := _MAX(200 ,500 - m_btSlaveMakeLevel * {50}40);//20090318
  m_dwWalkTick := GetTickCount + 2000;
end;

procedure TElfWarriorMonster.Run; //004ABBD0
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
  ElfName: string;
  nCode: Byte;
begin
  nCode:= 0;
  try
    ElfMon := nil;
    if boIsFirst then begin
      nCode:= 2;
      boIsFirst := False;
      m_boFixedHideMode := False;
      nCode:= 3;
      SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      ResetElfMon();
    end; //004ABC27
    if m_boDeath then begin
      if (GetTickCount - m_dwDeathTick > 2000{2 * 1000}) then begin
        nCode:= 5;
        MakeGhost();
      end;
    end else begin
      nCode:= 6;
      boChangeFace := True;
      if m_TargetCret <> nil then boChangeFace := False;
      nCode:= 7;
      if (m_Master <> nil) then begin
        if ((m_Master.m_TargetCret <> nil) or (m_Master.m_LastHiter <> nil)) then boChangeFace := False;
      end;  
      nCode:= 8;
      if boChangeFace then begin
        if (GetTickCount - dwDigDownTick) > 60000{6 * 10 * 1000} then begin
          nCode:= 9;
          ElfName := m_sCharName;
          if ElfName[Length(ElfName)] = '1' then begin
            ElfName := Copy(ElfName, 1, Length(ElfName) - 1);
            nCode:= 10;
            ElfMon := MakeClone(ElfName, Self);
          end;
          if ElfMon <> nil then begin
            nCode:= 11;
            SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
            SendRefMsg(RM_CHANGEFACE, 0, Integer(Self), Integer(ElfMon), 0, '');
            nCode:= 12;
            ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
            if ElfMon is TElfMonster then TElfMonster(ElfMon).AppearNow;
            nCode:= 13;
            m_Master := nil;
            KickException();
          end;
        end;
      end else begin
        dwDigDownTick := GetTickCount();
      end;
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TElfWarriorMonster.Run Code:%d',[g_sExceptionVer, nCode]));
    KickException();
  end;
end;

{ TElectronicScolpionMon }
//�����
constructor TElectronicScolpionMon.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boUseMagic := False;
end;

destructor TElectronicScolpionMon.Destroy;
begin

  inherited;
end;

procedure TElectronicScolpionMon.LightingAttack(nDir: Integer);
var
  WAbil: pTAbility;
  nPower, nDamage: Integer;
  btGetBackHP: Integer;
begin
  if m_TargetCret <> nil then begin
    m_btDirection := nDir;
    WAbil := @m_WAbil;
    nPower := GetAttackPower(LoWord(WAbil.MC), SmallInt(HiWord(WAbil.MC) - LoWord(WAbil.MC)));
    nDamage := m_TargetCret.GetMagStruckDamage(Self, nPower, 0, 0);
    if nDamage > 0 then begin
      btGetBackHP := LoByte(m_WAbil.MP);
      if btGetBackHP <> 0 then Inc(m_WAbil.HP, nDamage div btGetBackHP);
      m_TargetCret.StruckDamage(nDamage);
      m_TargetCret.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, m_TargetCret.m_WAbil.HP, m_TargetCret.m_WAbil.MaxHP, Integer(Self), '', 200);
    end;
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
  end;
end;

procedure TElectronicScolpionMon.Run;
var
  nAttackDir: Integer;
  nX, nY: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE {5}] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    //Ѫ������һ��ʱ��ʼ��ħ������
    if m_WAbil.HP < m_WAbil.MaxHP div 2 then m_boUseMagic := True
    else m_boUseMagic := False;

    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) and m_boIsVisibleActive then begin// 20090503 �޸�
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();//�����ɹ���Ŀ��
    end;
    if m_TargetCret = nil then Exit;

    nX := abs(m_nCurrX - m_TargetCret.m_nCurrX);
    nY := abs(m_nCurrY - m_TargetCret.m_nCurrY);

    if (nX <= 2) and (nY <= 2) then begin
      if m_boUseMagic or ((nX = 2) or (nY = 2)) then begin
        if (Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime) then begin
          m_dwHitTick := GetTickCount();
          nAttackDir := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          LightingAttack(nAttackDir);
        end;
      end;
    end;
  end;
  inherited Run;
end;


{TFairyMonster}
//20080214
function TFairyMonster.CheckTargetXYCount(nX, nY, nRange: Integer): Integer; //������һ����Χ�Ĺ�����  20080214 ����
var
  BaseObject: TBaseObject;
  I, nC, n10: Integer;
begin
  Result := 0;
  n10 := nRange;
  if m_VisibleActors.Count > 0 then begin//20080629
    for I := 0 to m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
      if BaseObject <> nil then begin
        if not BaseObject.m_boDeath then begin
          if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
            nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
            if nC <= n10 then begin
              Inc(Result);
              if Result > 1 then break;//20090113 ������ֻ�ж������һ��Ŀ��ӽ������
            end;
          end;
        end;
      end;
    end;//for
  end;
end;
//20080327 
function TFairyMonster.IsNeedGotoXY(): Boolean; //�Ƿ�����Ŀ��
begin
  Result := False;
  if (m_TargetCret <> nil) and (*(GetTickCount - m_dwAutoAvoidTick > {1100}500) and*) (not m_boIsUseAttackMagic) and //20090105
    ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7)) then begin
    m_dwAutoAvoidTick := GetTickCount();//20081108 ����
    Result := True;
  end;
end;
//20080214
function TFairyMonster.IsNeedAvoid(): Boolean; //�Ƿ���Ҫ���  20080214 ����
begin
  Result := False;
  if (*(GetTickCount - m_dwAutoAvoidTick > {1000}450) and*) (m_TargetCret <> nil) and (not m_boIsUseAttackMagic) then begin //���ڽ��������
    //m_dwAutoAvoidTick := GetTickCount();
    if CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 0 then begin
      m_dwAutoAvoidTick := GetTickCount();
      Result := True;
    end;
  end;
end;
//���ָ������ͷ�Χ������Ĺ�������
function TFairyMonster.CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;
var
  BaseObject: TBaseObject;
  I: Integer;
begin
  Result := 0;
  if m_VisibleActors.Count > 0 then begin
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
            //if Result > 2 then break;
          end;
        end;
      end;
    end;//for
  end;
end;
(*//20080214
function TFairyMonster.RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;
var
  nDir: Integer;
  n10: Integer;
  n14: Integer;
begin
  Result := False;
  n10 := nTargetX;
  n14 := nTargetY;
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
  if not RunTo(nDir, False, nTargetX, nTargetY) then begin
    Result := WalkToTargetXY(nTargetX, nTargetY);
  end else begin
    if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
      Result := True;
    end;
  end;
end;  *)
//20080214
function TFairyMonster.WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;
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
    WalkTo(nDir, False);
    if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then Result := True;
    if not Result then begin
      n20 := Random(3);
      for I := DR_UP to DR_UPLEFT do begin
        if (nOldX = m_nCurrX) and (nOldY = m_nCurrY) then begin
         { if n20 <> 0 then Inc(nDir)
          else if nDir > 0 then Dec(nDir)
          else nDir := DR_UPLEFT;
          if (nDir > DR_UPLEFT) then nDir := DR_UP;}

          if n20 <> 0 then Inc(nDir);//20080304 �޸�
          if (nDir > DR_UPLEFT) then nDir := DR_UP;//20080304 �޸�

          WalkTo(nDir, False);
          if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
            Result := True;
            Break;
          end;
        end;
      end;
    end;
  end;
end;
//20080214
function TFairyMonster.WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;
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
  if (nTargetX <> m_nCurrX) or (nTargetY <> m_nCurrY) then begin
    n10 := nTargetX;
    n14 := nTargetY;
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
    WalkTo(nDir, False);
    if (nTargetX = m_nCurrX) and (nTargetY = m_nCurrY) then Result := True;
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
            Break;
          end;
        end;
      end;
    end;
  end;
end;
//20080214
function TFairyMonster.GotoTargetXY(nTargetX, nTargetY: Integer): Boolean;
begin
{  if (abs(m_nCurrX - nTargetX) > 3) or (abs(m_nCurrY - nTargetY) > 3) then begin 
    Result := RunToTargetXY(nTargetX, nTargetY)
  end else begin
    Result := WalkToTargetXY2(nTargetX, nTargetY);
  end;}
  //Result := WalkToTargetXY2(nTargetX, nTargetY);//20080722 �޸�
  Result := WalkToTargetXY(nTargetX, nTargetY);//20090114
end;

//20080214
function TFairyMonster.AutoAvoid(): Boolean; //�Զ����
  function GetDirXY(nTargetX, nTargetY: Integer): Byte;
  var
    n10: Integer;
    n14: Integer;
  begin
    n10 := nTargetX;
    n14 := nTargetY;
    Result := DR_DOWN;
    if n10 > m_nCurrX then begin
      Result := DR_RIGHT;
      if n14 > m_nCurrY then Result := DR_DOWNRIGHT;
      if n14 < m_nCurrY then Result := DR_UPRIGHT;
    end else begin
      if n10 < m_nCurrX then begin
        Result := DR_LEFT;
        if n14 > m_nCurrY then Result := DR_DOWNLEFT;
        if n14 < m_nCurrY then Result := DR_UPLEFT;
      end else begin
        if n14 > m_nCurrY then Result := DR_DOWN
        else if n14 < m_nCurrY then Result := DR_UP;
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
        DR_UP: begin
            Dec(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_UPRIGHT: begin
            Inc(nTargetX, 1);
            Dec(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end; 
        DR_RIGHT: begin
            Inc(nTargetX, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWNRIGHT: begin
            Inc(nTargetX, 1);
            Inc(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWN: begin
            Inc(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWNLEFT: begin
            Dec(nTargetX, 1);
            Inc(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_LEFT: begin
            Dec(nTargetX, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
        DR_UPLEFT: begin
            Dec(nTargetX, 1);
            Dec(nTargetY, 1);
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and
              (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(n01);
              Continue;
            end;
          end;
      else begin
          Break;
        end;
      end;
    end;
  end;
  function GotoMasterXY(var nTargetX, nTargetY: Integer): Boolean;
  var
    nDir, nX, nY: Integer;
  begin
    Result := False;
    if (m_Master <> nil) and ((abs(m_Master.m_nCurrX - m_nCurrX) > 6) or (abs(m_Master.m_nCurrY - m_nCurrY) > 6)) then begin
      nX:= m_nCurrX;
      nY:= m_nCurrY;
      nDir := GetDirXY(m_Master.m_nCurrX, m_Master.m_nCurrY);
      case nDir of
        DR_UP: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UPRIGHT, nX, nY);
              m_btLastDirection := DR_UPRIGHT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UPLEFT, nX, nY);
              m_btLastDirection := DR_UPLEFT;
            end;
          end;
        DR_UPRIGHT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UP, nX, nY);
              m_btLastDirection := DR_UP;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_RIGHT, nX, nY);
              m_btLastDirection := DR_RIGHT;
            end;
          end;
        DR_RIGHT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UPRIGHT, nX, nY);
              m_btLastDirection := DR_UPRIGHT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNRIGHT, nX, nY);
              m_btLastDirection := DR_DOWNRIGHT;
            end;
          end;
        DR_DOWNRIGHT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_RIGHT, nX, nY);
              m_btLastDirection := DR_RIGHT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWN, nX, nY);
              m_btLastDirection := DR_DOWN;
            end;
          end;
        DR_DOWN: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNRIGHT, nX, nY);
              m_btLastDirection := DR_DOWNRIGHT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNLEFT, nX, nY);
              m_btLastDirection := DR_DOWNLEFT;
            end;
          end;
        DR_DOWNLEFT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWN, nX, nY);
              m_btLastDirection := DR_DOWN;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_LEFT, nX, nY);
              m_btLastDirection := DR_LEFT;
            end;
          end;
        DR_LEFT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNLEFT, nX, nY);
              m_btLastDirection := DR_DOWNLEFT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UPLEFT, nX, nY);
              m_btLastDirection := DR_UPLEFT;
            end;
          end;
        DR_UPLEFT: begin
            Result := GetGotoXY(nDir, nX, nY);
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_LEFT, nX, nY);
              m_btLastDirection := DR_LEFT;
            end;
            if not Result then begin
              nX := m_nCurrX;
              nY := m_nCurrY;
              Result := GetGotoXY(DR_UP, nX, nY);
              m_btLastDirection := DR_UP;
            end;
          end;
      end;
      nTargetX := nX;
      nTargetY := nY;
    end;
  end;
var
  nTargetX: Integer;
  nTargetY: Integer;
  nDir: Integer;
begin
  Result := True;
  if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) then begin
    if GotoMasterXY(nTargetX, nTargetY) then begin
      {m_nTargetX:= nTargetX;
      m_nTargetY:= nTargetY;
      Result := GotoTargetXY(m_nTargetX, m_nTargetY);  }
      nDir:= GetNextDirection(m_nCurrX, m_nCurrY, nTargetX, nTargetY);
      if m_PEnvir.GetNextPosition(nTargetX, nTargetY, nDir, 1,m_nTargetX, m_nTargetY) then begin
        Result := GotoTargetXY(m_nTargetX, m_nTargetY);
      end;
    end else begin
      nTargetX := m_TargetCret.m_nCurrX;
      nTargetY := m_TargetCret.m_nCurrY;
      nDir:= GetNextDirection(m_nCurrX,m_nCurrY,nTargetX, nTargetY);
      nDir:= GetBackDir(nDir);
      if m_PEnvir.GetNextPosition(nTargetX, nTargetY,nDir,3,m_nTargetX, m_nTargetY) then begin
        Result := GotoTargetXY(m_nTargetX, m_nTargetY);
      end;
    end;
  end;
end;

function TFairyMonster.FlyAxeAttack(Target: TBaseObject): Boolean;
{$IF M2Version = 1}
  function GetNGPow(BaseObject: TBaseObject; UserMagic: pTUserMagic; Power: Integer): Integer;
    function MPow1(UserMagic: pTUserMagic): Integer;//���㼼������
    var nPower:Integer;
    begin
      if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
        nPower := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
      else nPower := UserMagic.MagicInfo.wPower;
      if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
        Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
      else Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower);
    end;
  var nNHPoint:Integer;
  begin
    Result := 0;
    try
      if (UserMagic <> nil) and (BaseObject <> nil) then begin
        if UserMagic.btKey = 0 then begin//�ڹ����ܿ��� 20110426
          if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            nNHPoint := TPlayObject(BaseObject).GetSpellPoint(UserMagic);
            if TPlayObject(BaseObject).m_Skill69NH >= nNHPoint then begin
              TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - nNHPoint);
              TPlayObject(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
              if g_Config.nNGSkillRate = 0 then begin
                Result := MPow1(UserMagic);
              end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
              TPlayObject(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
            end;
          end else
          if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
            nNHPoint := THEROOBJECT(BaseObject).GetSpellPoint(UserMagic);
            if THEROOBJECT(BaseObject).m_Skill69NH >= nNHPoint then begin
              THEROOBJECT(BaseObject).m_Skill69NH := _MAX(0, THEROOBJECT(BaseObject).m_Skill69NH - nNHPoint);
              THEROOBJECT(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, THEROOBJECT(BaseObject).m_Skill69NH, THEROOBJECT(BaseObject).m_Skill69MaxNH, 0, '');
              if g_Config.nNGSkillRate = 0 then begin
                Result := MPow1(UserMagic);
              end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
              THEROOBJECT(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
            end;
          end;
        end;
      end;
    except
      Result := 0;
    end;
  end;
{$IFEND}
var
  WAbil: pTAbility;
  nDamage, nSpellPoint{$IF M2Version = 1}, NGSecPwr, nDamageBak{$IFEND}: Integer;
begin
  Result := True;
  if ((Random(g_Config.nFairyDuntRate) = 0) and (Target.m_Abil.Level <= m_Abil.Level)) or //�ػ�����,Ŀ��ȼ��������Լ�,��ʹ���ػ� 20080826
     (nHitCount >= _MIN(( 3 + g_Config.nFairyDuntRateBelow) ,(m_btSlaveExpLevel + g_Config.nFairyDuntRateBelow))) then begin//�����ػ�����,�ﵽ����ʱ���ȼ����ػ� 20090105
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Round((Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * g_Config.nFairyAttackRate / 100{�ػ�����}));//20090105
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFairyShareMasterMP then begin//���鹥��ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.35));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            Result := False;
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      {$IF M2Version = 1}
      nDamageBak:= nDamage;
      if (m_Master<> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          case m_Master.m_btRaceServer of
            RC_PLAYOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, TPlayObject(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
            RC_HEROOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, THEROOBJECT(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
          end;//case
        end;
      end;
      NGSecPwr:= 0;
      if Target <> nil then begin
        case Target.m_btRaceServer of
          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(Target, TPlayObject(Target).m_MagicSkill_242,nDamageBak);//��֮����
          RC_HEROOBJECT: NGSecPwr:= GetNGPow(Target, THEROOBJECT(Target).m_MagicSkill_242,nDamageBak);//��֮����
        end;
        nDamage := _MAX(0, nDamage - NGSecPwr);
      end;
      {$IFEND}
      nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then Target.StruckDamage(nDamage);
    Target.SetLastHiter(self);//20080628
    Target.StruckDamage(nDamage);//20090304 ����
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    if Target.m_btRaceServer <> 55 then begin//20090304 �������������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_FAIRYATTACKRATE, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    m_dwActionTick := GetTickCount();
    nHitCount:= 0;//20090105 ��������
  end else begin
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFairyShareMasterMP then begin//���鹥��ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.1));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            Result := False;
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      {$IF M2Version = 1}
      nDamageBak:= nDamage;
      if (m_Master<> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          case m_Master.m_btRaceServer of
            RC_PLAYOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, TPlayObject(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
            RC_HEROOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, THEROOBJECT(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
          end;//case
        end;
      end;
      NGSecPwr:= 0;
      if Target <> nil then begin
        case Target.m_btRaceServer of
          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(Target, TPlayObject(Target).m_MagicSkill_242,nDamageBak);//��֮����
          RC_HEROOBJECT: NGSecPwr:= GetNGPow(Target, THEROOBJECT(Target).m_MagicSkill_242,nDamageBak);//��֮����
        end;
        nDamage := _MAX(0, nDamage - NGSecPwr);
      end;
      {$IFEND}
      nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then begin
      Target.StruckDamage(nDamage);
    end;
    Target.SetLastHiter(self);//20080628
    Target.StruckDamage(nDamage);//20090304 ����
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    if Target.m_btRaceServer <> 55 then begin//20090304 �������������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    m_dwActionTick := GetTickCount();
    Inc(nHitCount);//20090105 ��������
  end;
end;

//���Ӽ���������ļ��
function TFairyMonster.CheckActionStatus(): Boolean;
begin
  Result := False;
  if GetTickCount - m_dwActionTick > {900}1100 then begin//20090107 �޸�
    m_dwActionTick := GetTickCount();
    Result := True;
  end;
end;

function TFairyMonster.AttackTarget: Boolean;
begin
  Result := False;
  if (m_TargetCret = nil) or (m_TargetCret = m_Master) then  Exit;
  if not CheckActionStatus then begin
    m_boIsUseAttackMagic:= False;//20080717
    Exit;
  end;
  m_boIsUseAttackMagic:= True;//20080717
  if {Integer}(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin//20080716 �޸�
    m_dwHitTick := GetTickCount();
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) then begin
      m_dwTargetFocusTick := GetTickCount();
      Result := FlyAxeAttack(m_TargetCret);
      m_dwHitTick := GetTickCount();//20090107
      //m_boIsUseAttackMagic:= False;//20080717  20090107ע��
      Exit;
    end else m_boIsUseAttackMagic:= False;//20080722
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end else m_boIsUseAttackMagic:= False;//20080717
end;

constructor TFairyMonster.Create;
begin
  inherited;
  m_dwSearchTime := Random(1500) + 1500;
  m_boIsUseAttackMagic:= False;//20080618
  //nHitCount:= (3+g_Config.nFairyDuntRateBelow);//������� 20100417ע��
  m_nViewRange:= 8;//20090113
  m_boUnParalysis := True;//����� 20100926
end;

destructor TFairyMonster.Destroy;
begin
  inherited;
end;

procedure TFairyMonster.Run;
var
  nX, nY, n14: Integer;
  nCode: byte;//20090116
begin
  nCode:= 0;
  Try
    if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE] = 0)
      and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
      nCode:= 1;
      if ((GetTickCount - m_dwSearchEnemyTick) > 1000) {and (m_TargetCret = nil)} and (not m_boNoAttackMode) and m_boIsVisibleActive then begin//20090503
        m_dwSearchEnemyTick := GetTickCount();
        nCode:= 2;
        if (m_Master<> nil) then begin//20090503 �����˴�ͬһĿ��
          if (not m_Master.m_boGhost) then begin
            nCode:= 20;
            if (m_Master.m_TargetCret <> nil) then begin
              nCode:= 21;
              if not m_Master.m_TargetCret.m_boDeath then begin
                nCode:= 22;
                if m_Master.m_TargetCret <> m_TargetCret then begin
                  nCode:= 23;
                  if IsProperTarget(m_Master.m_TargetCret) and (not m_Master.m_TargetCret.m_boHideMode or m_boCoolEye) then begin
                    nCode:= 24;
                    SetTargetCreat(m_Master.m_TargetCret);
                  end;
                end;
              end;
            end;
          end;
        end;
        nCode:= 3;
        if m_TargetCret = nil then SearchTarget(); //�����ɹ���Ŀ��
      end;
      nCode:= 4;
      if ({Integer}(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin//��·���
        //m_dwWalkTick := GetTickCount;//��·��� 20080715
        {Inc(m_nWalkCount);
        if m_nWalkCount > m_nWalkStep then begin
          m_nWalkCount := 0;
          m_boWalkWaitLocked := True;
          m_dwWalkWaitTick := GetTickCount();
        end;}
        if (m_Master<> nil) then begin//20101015 ע��,���鲻��CTRL+A����
          //if (not m_Master.m_boSlaveRelax) then begin
          m_boNoAttackMode:= False;
          //end else m_boNoAttackMode:= True;
          if (m_Master.m_btRaceServer = RC_HEROOBJECT) then begin////���ػ�״̬�£���Ϊ����״̬ʱ������Ŀ�� 20101019 ����
            if (THEROOBJECT(m_Master).m_btStatus <> 0) and (not THEROOBJECT(m_Master).m_boProtectStatus) then begin
              if m_TargetCret <> nil then m_TargetCret:= nil;
            end;
          end;
        end else m_boNoAttackMode:= False;
        if not m_boNoAttackMode then begin
          nCode:= 5;
          if (m_TargetCret <> nil) then begin
            if (not m_TargetCret.m_boDeath) then begin//Ŀ�겻Ϊ��
              nCode:= 6;
              if IsNeedGotoXY then begin //Ŀ����Զ��,����Ŀ��
                nCode:= 7;
                GotoTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                inherited;
                Exit;
              end;
              nCode:= 8;
              if AttackTarget then begin
                inherited;
                Exit;
              end;
              nCode:= 9;
              if IsNeedAvoid then begin //20080214 ������
                nCode:= 10;
                AutoAvoid(); //�Զ����
                inherited;
                Exit;
              end;
            end;
          end else m_nTargetX:= -1;//20090818 ����
        end;
        nCode:= 11; //20101016 ע��
        if (m_Master <> nil) then begin
          nCode:= 12;
          if m_Master.m_boSlaveRelax then begin//20110627 ���ӣ������������Ϣ
            inherited;
            Exit;
          end;            
          //if (not m_Master.m_boSlaveRelax) then begin//20090810 ����,������Զ��,�����߽�����
            if m_TargetCret = nil then begin
              nCode:= 13;
              m_Master.GetBackPosition(nX, nY);
              if (abs(m_nTargetX - nX) > {3}1) or (abs(m_nTargetY - nY ) > {3}1) then begin
                m_nTargetX := nX;
                m_nTargetY := nY;
                if (abs(m_nCurrX - nX) <= {4}2) and (abs(m_nCurrY - nY) <= {4}2) then begin
                  nCode:= 14;
                  if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then begin
                    m_nTargetX := m_nCurrX;
                    m_nTargetY := m_nCurrY;
                  end;
                end;
              end;
              nCode:= 15;
              if m_nTargetX <> -1 then begin
                if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then begin
                  GotoTargetXY(m_nTargetX, m_nTargetY);
                end;
              end;
            end;
          //end;
          nCode:= 16;
          if (m_Master<> nil) then begin
            if {(not m_Master.m_boSlaveRelax) and//������Զ��,ֱ�ӷɵ�������� 20080409 }
              ((m_PEnvir <> m_Master.m_PEnvir) or
              (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or
              (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
              nCode:= 17;
              SpaceMove(m_Master.m_PEnvir.sMapName, m_Master.m_nCurrX, m_Master.m_nCurrY, 1);
            end;
          end;
        end;
      end;
    end else begin
      if m_boDeath then begin
        nCode:= 18;
        if (GetTickCount - m_dwDeathTick > 2000) then MakeGhost();//ʬ����ʧ
      end;
    end;
  except
    MainOutMessage(Format('{%s} TFairyMonster.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
  inherited;
end;

//��USR��Ԫ��ʼ��
procedure TFairyMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;
//������
procedure TFairyMonster.ResetElfMon();
begin
  //m_nNextHitTime := 1400 - m_btSlaveMakeLevel * 100;//�´ι���ʱ�� ֱ��ʹ��DB�������ֵ20090106
  //m_dwWalkTick := GetTickCount;//��·���
  if m_Master <> nil then m_nWalkSpeed := _MAX(200 , nWalkSpeed{400} - m_btSlaveMakeLevel * 50);//��·�ٶ� 20090106 ��DB���õ���·�ٶȿ���
end;

{TFireFairyMonster ����}
procedure TFireFairyMonster.RecalcAbilitys;
begin
  inherited;
  if m_Master <> nil then m_nWalkSpeed := _MAX(400 , nWalkSpeed{400} - m_btSlaveMakeLevel * 5);//��·�ٶ�
end;

function TFireFairyMonster.FlyAxeAttack(Target: TBaseObject): Boolean;
var
  WAbil: pTAbility;
  nDamage, nSpellPoint: Integer;
begin
  Result := True;
  if ((Random(g_Config.nFireFairyDuntRate) = 0) and (Target.m_Abil.Level <= m_Abil.Level)) or //�ػ�����,Ŀ��ȼ��������Լ�,��ʹ���ػ�
     (nHitCount >= _MIN(( 3 + g_Config.nFireFairyDuntRateBelow) ,(m_btSlaveExpLevel + g_Config.nFireFairyDuntRateBelow))) then begin//�ػ�����,�ﵽ����ʱ���ȼ����ػ�
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Round((Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * g_Config.nFireFairyAttackRate / 100{�ػ�����}));
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFireFairyShareMasterMP then begin//����ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.35));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            Result := False;
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      if not g_Config.boFireFairyNeglectACMAC then nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then Target.StruckDamage(nDamage);
    Target.SetLastHiter(self);
    Target.StruckDamage(nDamage);
    Target.DamageSpell(Round(nDamage * 0.07) + 1);//����
    if Target.m_btRaceServer <> 55 then begin//����������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_FAIRYATTACKRATE, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    //m_dwActionTick := GetTickCount();
    nHitCount:= 0;//��������
  end else begin
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFireFairyShareMasterMP then begin//����ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.1));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            Result := False;
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      if not g_Config.boFireFairyNeglectACMAC then nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then Target.StruckDamage(nDamage);
    Target.SetLastHiter(self);
    Target.StruckDamage(nDamage);
    Target.DamageSpell(Round(nDamage * 0.07) + 1);//����
    if Target.m_btRaceServer <> 55 then begin//����������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    //m_dwActionTick := GetTickCount();
    Inc(nHitCount);//��������
  end;
end;

function TFireFairyMonster.AttackTarget: Boolean;
begin
(*  Result := False;
  if (m_TargetCret = nil) or (m_TargetCret = m_Master) then  Exit;
  if not CheckActionStatus then begin
    m_boIsUseAttackMagic:= False;
    Exit;
  end;
  m_boIsUseAttackMagic:= True;
  if (GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
    m_dwHitTick := GetTickCount();
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 7) then begin
      m_dwTargetFocusTick := GetTickCount();
      Result := FlyAxeAttack(m_TargetCret);
      m_dwHitTick := GetTickCount();
      Exit;
    end else m_boIsUseAttackMagic:= False;
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end else m_boIsUseAttackMagic:= False; *)

  try
    Result := False;
    if m_TargetCret <> nil then begin
      if (m_TargetCret.m_PEnvir = m_PEnvir) and
        (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= m_nAttackRange) and
        (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= m_nAttackRange) then begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          FlyAxeAttack(m_TargetCret);
          BreakHolySeizeMode();
        end;
        Result := True;
      end else begin
        if m_TargetCret.m_PEnvir = m_PEnvir then begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and
             (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end else begin
          DelTargetCreat();
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TFireFairyMonster.AttackTarget',[g_sExceptionVer]));
  end;
end;

{ TGiantSickleSpiderATMonster ����֩��}
constructor TGiantSickleSpiderATMonster.Create;
begin
  inherited;
  m_boExploration:= False;//�Ƿ��̽�� 20080810
  m_ButchItemList := TList.Create;//��̽����Ʒ�б� 20080810
end;

destructor TGiantSickleSpiderATMonster.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б� 20080810
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TGiantSickleSpiderATMonster.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����,���ش˷���,ʹ��������ͼ��,���Կ������˹�������"��̽��"����
function TGiantSickleSpiderATMonster.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TGiantSickleSpiderATMonster.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      //m_nButchRate:= ItemIni.ReadInteger('Info','ButchRate',10);//��ȡ����װ������
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//�����Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(s24);
          if LoadList.Count > 0 then begin
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
                  New(MonItem);
                  MonItem.SelPoint := n18 - 1;
                  MonItem.MaxPoint := n1C;
                  MonItem.ItemName := s2C;
                  MonItem.Count := n20;
                  Randomize;//�����������
                  if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                    m_ButchItemList.Add(MonItem);
                  end;
                end;
              end;
            end;
          end;
          if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        finally
          LoadList.Free;
        end;
      end;
      ItemIni.Free;
    end;
  end;
end;

{TSalamanderATMonster ���Ȼ����� 20080809}
constructor TSalamanderATMonster.Create;
begin
  inherited;
  m_boExploration:= False;//�Ƿ��̽�� 20080810
  m_ButchItemList := TList.Create;//��̽����Ʒ�б� 20080810
end;

destructor TSalamanderATMonster.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б� 20080810
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TSalamanderATMonster.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����
function TSalamanderATMonster.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TSalamanderATMonster.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      //m_nButchRate:= ItemIni.ReadInteger('Info','ButchRate',10);//��ȡ����װ������
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//�����Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        LoadList.LoadFromFile(s24);
        if LoadList.Count > 0 then begin
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
                New(MonItem);
                MonItem.SelPoint := n18 - 1;
                MonItem.MaxPoint := n1C;
                MonItem.ItemName := s2C;
                MonItem.Count := n20;
                Randomize;//�����������
                if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                  m_ButchItemList.Add(MonItem);
                end;
              end;
            end;
          end;
        end;
        if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        LoadList.Free;
      end;
      ItemIni.Free;
    end;
  end;
end;

procedure TSalamanderATMonster.Run;
var
  nPower: Integer;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if (m_TargetCret <> nil) and (GetTickCount - m_dwHitTick > m_nNextHitTime) and
       (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then begin
       m_dwHitTick:= GetTickCount();

      if (Random(4) = 0) then begin//��״̬
        if (g_EventManager.GetEvent(m_PEnvir, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, ET_FIRE) = nil) {and (Random(2) = 0)} then begin
           MagMakeFireCross(Self, GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))), 4, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);//��ǽ
        end else
        if (Random(4) = 0) then begin
          if IsProperTarget(m_TargetCret) then begin
            if (m_TargetCret.m_btRaceServer in [79, 109, 128, 143, 145, 147, 151, 153, 156..158]) then Exit;//20090206 ����ħ��,������,��������ܶ�
            if Random(m_TargetCret.m_btAntiPoison + 7) <= 6 then begin//ʩ��
               //nPower:={(m_TargetCret.m_WAbil.MaxHP * LoWord(m_WAbil.MC)) div 100};
               nPower:=GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));
               m_TargetCret.SendDelayMsg(self, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(self), 4, '', 150);
            end;
          end;
        end else AttackTarget();//������
      end else begin
        if (Random(4) = 0) then begin
          if IsProperTarget(m_TargetCret) then begin
            if (m_TargetCret.m_btRaceServer in [79, 109, 128, 143, 145, 147, 151, 153, 156..158]) then Exit;//20090206 ����ħ��,������,��������ܶ�
            if Random(m_TargetCret.m_btAntiPoison + 7) <= 6 then begin//ʩ��
               //nPower:={(m_TargetCret.m_WAbil.MaxHP * LoWord(m_WAbil.MC)) div 100};
               nPower:=GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));
               m_TargetCret.SendDelayMsg(self, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(self), 4, '', 150);
            end;
          end;
        end else
         if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 2) then begin
           AttackTarget();//������
         end;
      end;
    end;
  end;//if (not m_boDeath)
  inherited;
end;

function TSalamanderATMonster.AttackTarget():Boolean;
var
  btDir:Byte;
begin
  Result:=False;
  if m_TargetCret <> nil then begin
    if TargetInSpitRange(m_TargetCret, btDir) then begin
      m_dwHitTick:= GetTickCount();
      m_dwTargetFocusTick:=GetTickCount();
      Attack(m_TargetCret,btDir);
      Result:=True;
    end;
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin //20080605 ����
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end;
end;
//��ǽ 4*4
function TSalamanderATMonster.MagMakeFireCross(PlayObject: TBaseObject; nDamage, nHTime, nX, nY: Integer): Integer;
var
  FireBurnEvent: TFireBurnEvent;
begin
  Result := 0;
  if PlayObject.m_PEnvir.GetEvent(nX, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY - 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY + 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX -1, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY - 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY - 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY + 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY + 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 2, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 2, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 2, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 2, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 2, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 2, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY - 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY - 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY + 2) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY + 2, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 2, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 2, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 2, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 2, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 2, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 2, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  Result := 1;
end;

{TTempleGuardian ʥ����ʿ 20080809}
constructor TTempleGuardian.Create;
begin
  inherited;
  m_boExploration:= False;//�Ƿ��̽�� 20080810
  m_ButchItemList := TList.Create;//��̽����Ʒ�б� 20080810
end;

destructor TTempleGuardian.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б� 20080810
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TTempleGuardian.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����
function TTempleGuardian.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TTempleGuardian.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      //m_nButchRate:= ItemIni.ReadInteger('Info','ButchRate',10);//��ȡ����װ������
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//�����Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(s24);
          if LoadList.Count > 0 then begin
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
                  New(MonItem);
                  MonItem.SelPoint := n18 - 1;
                  MonItem.MaxPoint := n1C;
                  MonItem.ItemName := s2C;
                  MonItem.Count := n20;
                  Randomize;//�����������
                  if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                    m_ButchItemList.Add(MonItem);
                  end;
                end;
              end;
            end;
          end;
          if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        finally
          LoadList.Free;
        end;
      end;
      ItemIni.Free;
    end;
  end;
end;

procedure TTempleGuardian.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
var
  WAbil: pTAbility;
  nPower: Integer;
begin
  WAbil := @m_WAbil;
  nPower := GetAttackPower(LoWord(WAbil.DC), SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)));
  HitMagAttackTarget(TargeTBaseObject, nPower div 2, nPower div 2, True);
end;

{ TheCrutchesSpider  ����֩�� 20080809}

constructor TheCrutchesSpider.Create;
begin
  inherited;
  m_boExploration:= False;//�Ƿ��̽�� 20080810
  m_ButchItemList := TList.Create;//��̽����Ʒ�б� 20080810
end;

destructor TheCrutchesSpider.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б� 20080810
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TheCrutchesSpider.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����
function TheCrutchesSpider.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TheCrutchesSpider.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      //m_nButchRate:= ItemIni.ReadInteger('Info','ButchRate',10);//��ȡ����װ������
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//�����Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        LoadList.LoadFromFile(s24);
        if LoadList.Count > 0 then begin
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
                New(MonItem);
                MonItem.SelPoint := n18 - 1;
                MonItem.MaxPoint := n1C;
                MonItem.ItemName := s2C;
                MonItem.Count := n20;
                Randomize;//�����������
                if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                  m_ButchItemList.Add(MonItem);
                end;
              end;
            end;
          end;
        end;
        if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        LoadList.Free;
      end;
      ItemIni.Free;
    end;
  end;
end;

procedure TheCrutchesSpider.Run;
begin
  if not m_boDeath and not m_boGhost and(m_wStatusTimeArr[POISON_STONE ] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) and m_boIsVisibleActive then begin//20090503 �޸�
      m_dwSearchEnemyTick := GetTickCount();
      SearchTarget();//�����ɹ���Ŀ��
    end;

    if  (m_TargetCret <> nil) then begin     //��·���
      if (GetTickCount - m_dwWalkTick > m_nWalkSpeed) and (not m_TargetCret.m_boDeath) then begin//Ŀ�겻Ϊ��
         if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) then begin
            if (m_WAbil.HP < Round(m_WAbil.MaxHP)) and (Random(4) = 0) then begin//ʹ��Ⱥ��������
              if GetTickCount - m_dwHitTick > m_nNextHitTime then begin
                m_dwHitTick := GetTickCount();
                MagicManager.MagBigHealing(Self, 50 ,m_nCurrX,m_nCurrY, nil);//Ⱥ��������
                SendRefMsg(RM_FAIRYATTACKRATE, 1, m_nCurrX, m_nCurrY, Integer(self), '');
              end;
            end;
            AttackTarget;
         end else begin
            GotoTargetXY;
         end;
      end;
    end;
  end;
  inherited;
end;

//Զ����ʹ�ñ����� 5*5��Χ
function TheCrutchesSpider.AttackTarget: Boolean;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if GetTickCount - m_dwHitTick > m_nNextHitTime then begin
    m_dwHitTick := GetTickCount();
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 5) then begin
      m_dwTargetFocusTick := GetTickCount();
      m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      MagicManager.MagBigExplosion(self, GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC))), m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, g_Config.nSnowWindRange, SKILL_SNOWWIND);
      SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
      Result := True;
      Exit;
    end;
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end;
end;

{TYanLeiWangSpider ��������}

constructor TYanLeiWangSpider.Create;
begin
  inherited;
  m_boExploration:= False;//�Ƿ��̽��
  m_ButchItemList := TList.Create;//��̽����Ʒ�б�
  boIsSpiderMagic:= False;//�Ƿ����֩����
end;

destructor TYanLeiWangSpider.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б�
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TYanLeiWangSpider.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����
function TYanLeiWangSpider.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TYanLeiWangSpider.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      //m_nButchRate:= ItemIni.ReadInteger('Info','ButchRate',10);//��ȡ����װ������
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//���Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        LoadList.LoadFromFile(s24);
        if LoadList.Count > 0 then begin
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
                New(MonItem);
                MonItem.SelPoint := n18 - 1;
                MonItem.MaxPoint := n1C;
                MonItem.ItemName := s2C;
                MonItem.Count := n20;
                Randomize;//�����������
                if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                  m_ButchItemList.Add(MonItem);
                end;
              end;
            end;
          end;
        end;
        if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        LoadList.Free;
      end;
      ItemIni.Free;
    end;
  end;
end;

procedure TYanLeiWangSpider.Run;
var
  nPower: Integer;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE ] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if (GetTickCount - m_dwWalkTick > m_nWalkSpeed) and//��·���
        (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) then begin//Ŀ�겻Ϊ��
       if boIsSpiderMagic then begin//�������,��ʱ1100������ʾĿ���Ч��
         if GetTickCount - m_dwSpiderMagicTick > 1100 then begin
           boIsSpiderMagic:= False;//�Ƿ����֩����
           nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));//20090406
           SpiderMagicAttack(nPower div 2, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3);
           inherited;
           Exit;
         end;
       end;
       if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) then begin
          if (Random(4) = 0) and (m_TargetCret.m_wStatusTimeArr[STATE_LOCKRUN] = 0) then begin//���֩����
            if GetTickCount - m_dwHitTick > m_nNextHitTime then begin
              m_dwHitTick := GetTickCount();
              SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(m_TargetCret), '');
              m_dwSpiderMagicTick:= GetTickCount();//���֩������ʱ,������ʱ����Ŀ�����ϵ�С����ʾ
              boIsSpiderMagic:= True;//�Ƿ����֩����
            end;
          end else AttackTarget;
       end else begin
         GotoTargetXY;
       end;
    end;
  end;
  inherited;
end;
//������
function TYanLeiWangSpider.AttackTarget: Boolean;
var
  nPower: Integer;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if GetTickCount - m_dwHitTick > m_nNextHitTime then begin
    m_dwHitTick := GetTickCount();
    if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) then begin
      m_dwTargetFocusTick := GetTickCount();
      nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));
      HitMagAttackTarget(m_TargetCret, nPower div 2, nPower div 2, True);
      Result := True;
      Exit;
    end;
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end; 
end;
//���֩����   ��֩������Χ,ֻ���߶�,�����ܶ�
procedure TYanLeiWangSpider.SpiderMagicAttack(nPower, nX, nY: Integer; nRage: Integer);
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  BaseObjectList := TList.Create;
  try
    m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    if BaseObjectList.Count > 0 then begin
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin//20090406 ����
          if IsProperTarget(TargeTBaseObject) then begin
            if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin //Ӣ��������,���������� 20081214 �޸�
              if not THeroObject(TargeTBaseObject).m_boTarget then TargeTBaseObject.SetTargetCreat(self);
            end else TargeTBaseObject.SetTargetCreat(self);

            TargeTBaseObject.SendMsg(self, RM_MAGSTRUCK, 0, nPower, 0, 0, '');
            TargeTBaseObject.MakeSpiderMag(7);//�������������ܶ�   //�ı��ɫ״̬
          end;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
end;

{TSwordsmanMon ����ո���,��Ӱ���� 2���ڿ��Թ����Ĺ�}
constructor TSwordsmanMon.Create;
begin
  inherited;
  m_nViewRange:= 8;//20090123
end;

destructor TSwordsmanMon.Destroy;
begin
  inherited;
end;

function TSwordsmanMon.AttackTarget: Boolean;
var
  nPower: Integer;
//  nDir: Integer;
//  push: Integer;
begin
  Result := False;
  if m_TargetCret = nil then Exit;
  if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) and (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 2) then begin//2����������
    if GetTickCount - m_dwHitTick > m_nNextHitTime then begin
     m_dwHitTick := GetTickCount();
      m_dwTargetFocusTick := GetTickCount();
      nPower := GetAttackPower(LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));
      HitMagAttackTarget(m_TargetCret, nPower div 2, nPower div 2, True);
      Result := True;
      Exit;
    end;
  end else begin
    if m_TargetCret.m_PEnvir = m_PEnvir then begin
      if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
        SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
      end;
    end else begin
      DelTargetCreat();
    end;
  end;
end;

procedure TSwordsmanMon.Run;
var
  nCode: Byte;//20090131
begin
  nCode:= 0;
  Try
    if not m_boDeath and not m_boGhost and(m_wStatusTimeArr[POISON_STONE ] = 0)
      and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
      nCode:= 1;
      if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) and m_boIsVisibleActive then begin//20090503 �޸�
        nCode:= 2;
        m_dwSearchEnemyTick := GetTickCount();
        SearchTarget();//�����ɹ���Ŀ��
      end;
      nCode:= 3;
      if Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then begin
        m_dwWalkTick := GetTickCount();
        if not m_boNoAttackMode then begin
          nCode:= 4;
          if m_TargetCret <> nil then begin
            nCode:= 5;
            if AttackTarget then begin
              inherited;
              Exit;
            end;
            nCode:= 6;
            if m_TargetCret <> nil then begin//20090201
              nCode:= 61;
              if (abs(m_nCurrX - m_TargetCret.m_nCurrX) > 2) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 2) then begin //Ŀ����Զ��,����Ŀ��
                nCode:= 62;
                m_nTargetX := m_TargetCret.m_nCurrX;
                m_nTargetY := m_TargetCret.m_nCurrY;
                GotoTargetXY();
                inherited;
                Exit;
              end;
            end;
          end else begin
            m_nTargetX := -1;
            if m_boMission then begin
              m_nTargetX := m_nMissionX;
              m_nTargetY := m_nMissionY;
            end;
          end;
        end;
        nCode:= 7;
        if m_nTargetX <> -1 then begin
          if (m_TargetCret <> nil) then begin
            if (abs(m_nCurrX - m_nTargetX) > 2) or (abs(m_nCurrY - m_nTargetY) > 2) then begin
              nCode:= 8;
              GotoTargetXY();
            end;
          end else GotoTargetXY();
        end else begin
          nCode:= 9;
          if (m_TargetCret = nil) then Wondering();
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TSwordsmanMon.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
  inherited;
end;

{TWealthAnimalMon ������ 20090517}
constructor TWealthAnimalMon.Create;
begin
  inherited;
  m_boAnimal := False;//���Ƕ���,��������
  m_boStickMode := True;//���ܳ�ײģʽ(�����˲���ʹ��Ұ����ײ���ܹ���)
  m_btAntiPoison := 200;//�ж����
  m_boUnParalysis := True;//�����
  m_nViewRange:= 0;
  m_nGameGird:= g_Config.nMonGameGird;//����ͽ�ֵ
end;

destructor TWealthAnimalMon.Destroy;
begin
  inherited;
end;
//����ͨ����,������
procedure TWealthAnimalMon.StruckDamage(nDamage: Integer);
begin
end;
//�������̲����� 20090603
function TWealthAnimalMon.AttackTarget(): Boolean;
begin
end;

//��ָ����Ʒ��������Ѫ�����ۼ�����ͽ�ֵ����������ʾ
procedure TWealthAnimalMon.StruckDamage1(nDamage: Integer);
begin
  if (nDamage > 0) and (not m_boDeath) then begin
    DamageHealth(nDamage);//��Ѫ
    if m_boCrazyMode then begin//��ģʽ���ۼ�����ͽ�ֵ  20090603
      Inc(m_nGameGird, abs(g_Config.nIncMonGameGird -(g_Config.nIncMonGameGird div 3))+ Random(g_Config.nIncMonGameGird div 3)+ 1);
      if (Random(3) = 0) and g_Config.boShowMonSysHint then UserEngine.SendBroadCastMsgExt(Format_ToStr('���Ͳ�ɱ�����ޣ�Ŀǰ�ͽ����Ѿ���ߵ�%d��%s������ʿ������ǰ����ɱ��', [ m_nGameGird, g_Config.sGameGird]), t_Say);
    end else begin
      if (Random(g_Config.nMon79CrazyRate) = 0) {or (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.5))} then begin
        OpenCrazyMode({Random(30) + 10}g_Config.nMon79CrazyTime);//��ģʽ 20090904
        UserEngine.SendBroadCastMsgExt('ϵͳ���棺��Χ���ĸ����ޣ��Ѿ����겻�����������������ߡ�����ʿ�����ټ��ᣬɱ�ֶᱦ��', t_Say);
      end;
    end;
  end;
end;

procedure TWealthAnimalMon.Die;
begin
  try
    if (m_nGameGird > 0) then begin
      if (m_LastHiter <> nil) then begin
        if (m_LastHiter.m_btRaceServer = RC_PLAYOBJECT) then begin
          TPlayObject(m_LastHiter).IncGameGird(m_nGameGird);
          TPlayObject(m_LastHiter).GameGoldChanged;
          UserEngine.SendBroadCastMsgExt(Format_ToStr('��ϲ%s�ڸ����޿񱩵�ʱ��Ѹ����������ˣ������%d��%s', [m_LastHiter.m_sCharName, m_nGameGird, g_Config.sGameGird]), t_Say);
          if g_boGameLogGameGird then begin//��¼�����־ 20090528
            AddGameDataLog(Format(g_sGameLogMsg1, [LOG_GameGird, m_LastHiter.m_sMapName,
                m_LastHiter.m_nCurrX, m_LastHiter.m_nCurrY, m_LastHiter.m_sCharName, g_Config.sGameGird,
                TPlayObject(m_LastHiter).m_nGameGird, '+('+inttostr(m_nGameGird)+')', m_sCharName]));
          end;
          m_nGameGird:= 0;
        end;
      end else
      if (m_ExpHitter <> nil) then begin//20090904 ����
        if (m_ExpHitter.m_btRaceServer = RC_PLAYOBJECT) then begin
          TPlayObject(m_ExpHitter).IncGameGird(m_nGameGird);
          TPlayObject(m_ExpHitter).GameGoldChanged;
          UserEngine.SendBroadCastMsgExt(Format_ToStr('��ϲ%s�ڸ����޿񱩵�ʱ��Ѹ����������ˣ������%d��%s', [m_ExpHitter.m_sCharName, m_nGameGird, g_Config.sGameGird]), t_Say);
          if g_boGameLogGameGird then begin//��¼�����־ 20090528
            AddGameDataLog(Format(g_sGameLogMsg1, [LOG_GameGird, m_ExpHitter.m_sMapName,
                m_ExpHitter.m_nCurrX, m_ExpHitter.m_nCurrY, m_ExpHitter.m_sCharName, g_Config.sGameGird,
                TPlayObject(m_ExpHitter).m_nGameGird, '+('+inttostr(m_nGameGird)+')', m_sCharName]));
          end;
          m_nGameGird:= 0;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TWealthAnimalMon.Die',[g_sExceptionVer]));
  end;
  inherited;
end;

procedure TWealthAnimalMon.Run;
begin
  if (not m_boDeath) and (not m_boGhost) and (m_wStatusTimeArr[POISON_STONE ] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then begin
      m_dwWalkTick := GetTickCount();
      //if m_boIsVisibleActive then begin
        if (Random(20) = 0) then begin
          if (Random(4) = 1) then TurnTo(Random(8));//ת��
        end else
        if (Random(6) = 0) then begin
          if (Random(6) = 1) then SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '')//���Ķ���
          else if (Random(3) = 1) then SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');//��������
        end;
      //end;
    end;
  end;
  inherited;
end;

{TNoAttackMon  ���ṥ������Ĺ֣���������������Ʒ 20090524}
constructor TNoAttackMon.Create;
begin
  inherited;
  m_boAnimal := True;//���Ƕ���,��������
  m_nViewRange:= 3;
  m_boNoAttackMode:= True;//������ģʽ
  m_boExploration:= False;//�Ƿ��̽��
  m_ButchItemList := TList.Create;//��̽����Ʒ�б�
end;

destructor TNoAttackMon.Destroy;
var
  I: Integer;
begin
  if m_ButchItemList.Count > 0 then begin//��̽����Ʒ�б�
    for I := 0 to m_ButchItemList.Count - 1 do begin
      if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
         Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
    end;
  end;
  FreeAndNil(m_ButchItemList);
  inherited;
end;

procedure TNoAttackMon.Die;
begin
  if m_boExploration then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
  inherited;
end;

//��ʾ����
function TNoAttackMon.GetShowName(): string;
begin
  Result := FilterShowName(m_sCharName);//���������ֵ�����
  if (m_Master <> nil) then begin//20090525 ����
    if (not m_Master.m_boObMode) and (not m_Master.m_boGhost) then begin
      if m_nCopyHumanLevel in [0, 1] then begin
        if g_Config.boUnKnowHum and (m_Master.IsUsesZhuLi) then begin//����Ϊ������ʱ������ҲҪ��ʾ������
           Result := Result + '(������)';
        end else Result := Result + '(' + m_Master.m_sCharName + ')';
      end;
    end;
  end;
  if m_boExploration and m_boDeath and (not m_boGhost) then begin//��̽��,����Ϣ�ÿͻ�����ʾ
    SendRefMsg(RM_CANEXPLORATION, 0, 0, 0, 0, '');
  end;
end;

procedure TNoAttackMon.AddItemsFromConfig();
var
  I: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
  ItemIni: TIniFile;
begin
//---------------------------��ȡ��������----------------------------------
  s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '.txt';
  if FileExists(s24) then begin
    ItemIni := TIniFile.Create(s24);
    if ItemIni <> nil then begin
      m_nButchChargeClass:= ItemIni.ReadInteger('Info','ButchChargeClass',3);//�շ�ģʽ(0��ң�1Ԫ����2���ʯ��3���)
      m_nButchChargeCount:= ItemIni.ReadInteger('Info','ButchChargeCount',1);//��ÿ���շѵ���
      boIntoTrigger:= ItemIni.ReadBool('Info','ButchCloneItem',False);//���Ƿ���봥��
  //---------------------------��ȡ̽����Ʒ----------------------------------
      s24 := g_Config.sEnvirDir + 'MonUseItems\' + m_sCharName + '-Item.txt';
      if FileExists(s24) then begin
        if m_ButchItemList <> nil then begin
          if m_ButchItemList.Count > 0 then begin
            for I := 0 to m_ButchItemList.Count - 1 do begin
              if pTMonItemInfo(m_ButchItemList.Items[I]) <> nil then
                 Dispose(pTMonItemInfo(m_ButchItemList.Items[I]));
            end;
          end;
          m_ButchItemList.Clear;
        end;
        LoadList := TStringList.Create;
        try
          LoadList.LoadFromFile(s24);
          if LoadList.Count > 0 then begin
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
                  New(MonItem);
                  MonItem.SelPoint := n18 - 1;
                  MonItem.MaxPoint := n1C;
                  MonItem.ItemName := s2C;
                  MonItem.Count := n20;
                  Randomize;//�����������
                  if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin//������� 1/10 ���10<=1 ��Ϊ���õ���Ʒ
                    m_ButchItemList.Add(MonItem);
                  end;
                end;
              end;
            end;
          end;
          if m_ButchItemList.Count > 0 then m_boExploration:= True;//�Ƿ��̽�� 20080810
        finally
          LoadList.Free;
        end;
      end;
      ItemIni.Free;
    end;
  end;
end;

procedure TNoAttackMon.Run;
var
  nPower: Integer;
begin
  if not m_boDeath and not m_boGhost and (m_wStatusTimeArr[POISON_STONE ] = 0)
    and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0) then begin
    if Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed then begin
      m_dwWalkTick := GetTickCount();
      m_nTargetX := -1;
      if m_boMission then begin
        m_nTargetX := m_nMissionX;
        m_nTargetY := m_nMissionY;
      end;
      if m_nTargetX <> -1 then begin
        GotoTargetXY();
      end else begin
        Wondering();
      end;
    end;
  end;
  inherited;
end;

//------------------------------------------------------------------------------
{ TShengSuMonster }
procedure TShengSuMonster.AppearNow; //ʥ��(����ʱ)
begin
  boIsFirst := False;
  m_boFixedHideMode := False;
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800;
end;

constructor TShengSuMonster.Create;
begin
  inherited;
  m_nViewRange := 6;
  m_boFixedHideMode := True;
  m_boNoAttackMode := True;
  boIsFirst := True;
  m_boUnParalysis := True;//����� 20100926
  boEx:= True;//ǿ��
end;

destructor TShengSuMonster.Destroy;
begin
  inherited;
end;

procedure TShengSuMonster.Die;
begin
  if (m_Master <> nil) then begin
    if not m_Master.m_boDeath then m_Master.m_dwDoSuSlaveTick:= GetTickCount();
  end;
  inherited;
end;

procedure TShengSuMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;

procedure TShengSuMonster.ResetElfMon();
begin
  m_nWalkSpeed := _MAX(250 ,500 - {m_btSlaveMakeLevel}m_btSlaveExpLevel * 4);
  m_dwWalkTick := GetTickCount + 2000;
end;

procedure TShengSuMonster.Run;
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
  nCode: Byte;
begin
  nCode:= 0;
  Try
    if boIsFirst then begin
      boIsFirst := False;
      m_boFixedHideMode := False;
      nCode:= 2;
      SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      nCode:= 3;
      ResetElfMon();
    end;
    nCode:= 4;
    if m_boDeath then begin
      if (GetTickCount - m_dwDeathTick > 2000) then MakeGhost();
    end else begin
      nCode:= 6;
      boChangeFace := False;
      if m_TargetCret <> nil then boChangeFace := True;
      if (m_Master <> nil) then begin
        if ((m_Master.m_TargetCret <> nil) or (m_Master.m_LastHiter <> nil)) then boChangeFace := True;
      end;  
      nCode:= 7;
      if boChangeFace then begin
        nCode:= 8;
        ElfMon := MakeClone(m_sCharName + '1', Self);
        nCode:= 9;
        if ElfMon <> nil then begin
          nCode:= 10;
          ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
          ElfMon.n294:= n294;
          nCode:= 11;
          if ElfMon is TShengSuWarriorMonster then begin
            TShengSuWarriorMonster(ElfMon).boEx:= boEx;//ǿ��
            TShengSuWarriorMonster(ElfMon).AppearNow;
          end;
          nCode:= 12;
          m_Master := nil;
          KickException();
        end;
      end;
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TShengSuMonster.Run Code:%d',[g_sExceptionVer, nCode]));
    KickException();
  end;
end;
{ TShengSuWarriorMonster ����ʱ��ʥ��-����ʥ��}
procedure TShengSuWarriorMonster.AppearNow;
begin
  if boEx then begin//ǿ��ʥ��
    case m_btSlaveMakeLevel of
      4..6: m_wAppr:= 9014;
      7..9: m_wAppr:= 9015;
    end;
  end;
  boIsFirst := False;
  m_boFixedHideMode := False;
  SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  RecalcAbilitys;
  m_dwWalkTick := m_dwWalkTick + 800; 
  dwDigDownTick := GetTickCount();
end;

constructor TShengSuWarriorMonster.Create;
begin
  inherited;
  m_nViewRange := 6;
  m_boFixedHideMode := True;
  boIsFirst := True;
  m_boUsePoison := False;
  m_boUnParalysis := True;//����� 20100926
  boEx:= False;//ǿ��
end;

destructor TShengSuWarriorMonster.Destroy;
begin
  inherited;
end;

procedure TShengSuWarriorMonster.Die;
begin
  if (m_Master <> nil) then begin
    if not m_Master.m_boDeath then m_Master.m_dwDoSuSlaveTick:= GetTickCount();
  end;
  inherited;
end;

procedure TShengSuWarriorMonster.RecalcAbilitys;
begin
  inherited;
  ResetElfMon();
end;

procedure TShengSuWarriorMonster.ResetElfMon();
begin
  m_nNextHitTime := _MAX(730 ,1500 - {m_btSlaveMakeLevel}m_btSlaveExpLevel * 10);
  m_nWalkSpeed := _MAX(250 ,500 - {m_btSlaveMakeLevel}m_btSlaveExpLevel * 4);
  m_dwWalkTick := GetTickCount + 2000;
end;

procedure TShengSuWarriorMonster.Run;
var
  boChangeFace: Boolean;
  ElfMon: TBaseObject;
  ElfName: string;
  nCode: Byte;
begin
  nCode:= 0;
  try
    ElfMon := nil;
    if boIsFirst then begin
      boIsFirst := False;
      m_boFixedHideMode := False;
      nCode:= 3;
      SendRefMsg(RM_DIGUP, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      ResetElfMon();
    end;
    if m_boDeath then begin
      if (GetTickCount - m_dwDeathTick > 2000) then MakeGhost();
    end else begin
      nCode:= 6;
      boChangeFace := True;
      if m_TargetCret <> nil then boChangeFace := False;
      nCode:= 7;
      if (m_Master <> nil) then begin
        if ((m_Master.m_TargetCret <> nil) or (m_Master.m_LastHiter <> nil)) then boChangeFace := False;
      end;
      if boChangeFace then begin
        if (GetTickCount - dwDigDownTick) > 60000 then begin
          nCode:= 9;
          ElfName := m_sCharName;
          if ElfName[Length(ElfName)] = '1' then begin
            ElfName := Copy(ElfName, 1, Length(ElfName) - 1);
            nCode:= 10;
            ElfMon := MakeClone(ElfName, Self);
            ElfMon.n294:= n294;
          end;
          if ElfMon <> nil then begin
            nCode:= 11;
            SendRefMsg(RM_DIGDOWN, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
            SendRefMsg(RM_CHANGEFACE, 0, Integer(Self), Integer(ElfMon), 0, '');
            nCode:= 12;
            ElfMon.m_boAutoChangeColor := m_boAutoChangeColor;
            if ElfMon is TShengSuMonster then begin
              TShengSuMonster(ElfMon).boEx:= boEx;
              TShengSuMonster(ElfMon).AppearNow;
            end;
            nCode:= 13;
            m_Master := nil;
            KickException();
          end;
        end;
      end else begin
        dwDigDownTick := GetTickCount();
      end;
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TShengSuWarriorMonster.Run Code:',[g_sExceptionVer, nCode]));
    KickException();
  end;
end;
//----------------------------------------------------------------------------
{TPetsMon �����:������,�ܹ�������Ѫ,���������ƶ���ͼ,��ͼ�ػ�,���ܶ�,���ܳ�ײ}
constructor TPetsMon.Create;
begin
  inherited;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();  
  m_sMasterName:= '';
  m_nHappiness:= 0;
  m_dwPetsMonDecMaxHapp:= 0;//�����տɼ����ֶ�����
  m_dwPetsMonIncMaxHapp:= 0;//�����տɼӿ��ֶ�����
  m_TodayDate := Date;
  m_nViewRange := 3;
  m_boNoAttackMode := False;//������ģʽ
  m_btAntiPoison := 200;//�ж����
  m_boAnimal := False;//���Ƕ���,��������
  m_boStickMode := True;//���ܳ�ײģʽ(�����˲���ʹ��Ұ����ײ���ܹ���)
  m_boUnParalysis := True;//�����
  m_boFixedHideMode:= False;//������
  m_boProtectOK:= True;//�����ػ�����
end;

destructor TPetsMon.Destroy;
begin
  inherited;
end;

//����ι����־
procedure TPetsMon.SaveMasterList(sStr: string);
var
  SaveList: TStringList;
  sFileName, sTime: string;
  IniFile: TIniFile;
begin
  try
    if m_sMasterName <> '' then begin//�����������ܱ����б�
      sFileName:= Format('%sPetsMon\%d\Log',[g_Config.sEnvirDir, g_Config.GlobalVal[High(g_Config.GlobalVal)]]);
      if not DirectoryExists(sFileName) then ForceDirectories(sFileName); //Ŀ¼������,�򴴽�
      sFileName := sFileName+'\'+m_sMasterName+'.txt';
      SaveList := TStringList.Create();
      try
        if FileExists(sFileName) then SaveList.LoadFromFile(sFileName);
        if SaveList.Count > 100 then SaveList.Delete(SaveList.Count - 1);
        SaveList.Insert(0, FormatdateTime('mm-dd t,',Now()) + sStr);
        SaveList.SaveToFile(sFileName);

        sFileName:= Format('%sPetsMon\%d\PetsMon.txt',[g_Config.sEnvirDir, g_Config.GlobalVal[High(g_Config.GlobalVal)]]);
        IniFile := TIniFile.Create(sFileName);
        try
          IniFile.WriteString(m_sMasterName, '����', m_sCharName);
          IniFile.WriteInteger(m_sMasterName,'���ֶ�', m_nHappiness);
          IniFile.WriteString(m_sMasterName, '����', Format('%s %d %d %d',[m_PEnvir.sMapName, m_nCurrX, m_nCurrY, m_btNameColor]));
        finally
          IniFile.Free;
        end;
      finally
        SaveList.Free;
      end;
    end;
  except
    MainOutMessage(format('{%s} TPetsMon.SaveMasterList',[g_sExceptionVer]));
  end;
end;


function TPetsMon.Think(): Boolean;
var
  nOldX, nOldY: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if (GetTickCount - m_dwThinkTick) > 5000 then begin
      m_dwThinkTick := GetTickCount();
      nCode:= 1;
      if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
      nCode:= 2;
      if (m_TargetCret <> nil) then begin
        if not IsProperTarget(m_TargetCret) then m_TargetCret := nil;
      end;
    end;
    nCode:= 3;
    if m_boDupMode then begin
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      nCode:= 4;
      WalkTo(Random(8), False);
      if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
        m_boDupMode := False;
        Result := True;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TPetsMon.Think Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TPetsMon.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  BaseObject: TBaseObject;
  n14: Integer;
begin
  try
    case ProcessMsg.wIdent of
      RM_FLYAXE: begin
        Result := True;
        BaseObject:= TBaseObject(ProcessMsg.nParam3);
        if BaseObject <> nil then begin
          m_btDirection:= GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
          SendRefMsg(RM_FLYAXE,
            m_btDirection,
            ProcessMsg.nParam1 {x},
            ProcessMsg.nParam2 {Y},
            ProcessMsg.nParam3 {AttackSrc},
            ProcessMsg.sMsg);
          if ((abs(m_nCurrX - BaseObject.m_nCurrX) > 3) or (abs(m_nCurrY - BaseObject.m_nCurrY) > 3)) then begin
            m_PEnvir.GetNextPosition(BaseObject.m_nCurrX, BaseObject.m_nCurrY, m_btDirection, 3, m_nTargetX, m_nTargetY);
            GotoTargetXY();
          end;
        end;
      end;
      else begin
        Result := inherited Operate(ProcessMsg);
      end;
    end;
  except
    MainOutMessage(Format('{%s} TPetsMon.Operate',[g_sExceptionVer]));
  end;
end;

//����ͨ����,����Ѫ�����ܲ������������Լ��߶�����
procedure TPetsMon.StruckDamage(nDamage: Integer);
begin

end;
{ȥ��override ��ʡCPU By TasNat at: 2012-03-13 20:49:23
procedure TPetsMon.DamageHealth(nDamage: Integer);
begin
end;
}
{//�������̲�����
function TPetsMon.AttackTarget(): Boolean;
begin
end; }

procedure TPetsMon.Die;
begin
{  if m_sMasterName <> '' then begin
    if m_Master <> nil then begin
      TPlayObject(m_Master).m_nPetsMonHappiness:= 0;
      TPlayObject(m_Master).m_sPetsMonName:= '';
    end;
  end; }
  inherited;
end;

procedure TPetsMon.Run;
var
  nCode: Byte;
begin
  try
    nCode:= 0;
    if (not m_boGhost) and (not m_boDeath) and (not m_boFixedHideMode) and
      (not m_boStoneMode) and (m_wStatusTimeArr[POISON_STONE] = 0) and m_boIsVisibleActive then begin
      {if Think then begin
        inherited;
        Exit;
      end;}
      //ȥ�� override DamageHealth ����HP By TasNat at: 2012-03-13 20:50:24
      m_WAbil.HP := m_WAbil.MaxHP;
      if Integer(GetTickCount - m_dwWalkTick) >= m_nWalkSpeed then begin
        m_dwWalkTick := GetTickCount();
        if (m_TodayDate <> Date) then begin
          m_TodayDate := Date;
          m_dwPetsMonDecMaxHapp:= 0;//�����տɼ����ֶ�����
          m_dwPetsMonIncMaxHapp:= 0;//�����տɼӿ��ֶ�����
        end;
        nCode:= 1;
        if (abs(m_nCurrX - m_nProtectTargetX) > 10) or (abs(m_nCurrY - m_nProtectTargetY) > 10) then begin
          m_boProtectOK:= False;
        end;
        m_nTargetX:= -1;
        nCode:= 2;
        if (not m_boProtectOK) and (m_PEnvir <> nil) then begin//û�ߵ��ػ�����
          m_nTargetX := m_nProtectTargetX;
          m_nTargetY := m_nProtectTargetY;
          Inc(m_nGotoProtectXYCount);
          nCode:= 3;
          if (abs(m_nCurrX - m_nProtectTargetX) <= 3) and (abs(m_nCurrY - m_nProtectTargetY) <= 3) then begin
            m_btDirection:= Random(8);
            m_boProtectOK:= True;
            m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ���
            m_nTargetX:= -1;
          end;
          nCode:= 4;
          if (m_nGotoProtectXYCount > 20) and (not m_boProtectOK) then begin//20�λ�û���ߵ��ػ����꣬��ɻ�������
            if (abs(m_nCurrX - m_nProtectTargetX) > 10) or (abs(m_nCurrY - m_nProtectTargetY) > 10) then begin
              SpaceMove(m_PEnvir.sMapName, m_nProtectTargetX, m_nProtectTargetY, 1);//��ͼ�ƶ�
              m_btDirection:= Random(8);
              m_boProtectOK:= True;
              m_nGotoProtectXYCount:= 0;//�����ػ�������ۼ���
              m_nTargetX:= -1;
            end;
          end;
        end;
        if m_TargetCret <> nil then begin
          if m_TargetCret.m_PEnvir <> m_PEnvir then DelTargetCreat();
        end;
        nCode:= 5;
        if m_nTargetX <> -1 then begin
          nCode:= 6;
          GotoTargetXY();
        end else begin
          nCode:= 7;
          if (m_TargetCret = nil) and (Random(8) = 0) then begin
            nCode:= 8;
            if (Random(4) = 1) then TurnTo(Random(8))
            else WalkTo(m_btDirection, False);
          end;
        end;
      end;
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TPetsMon.Run Code:%d',[g_sExceptionVer, nCode]));
  end;
end;


//TPsycheMonster(JS����)-----------------

constructor TPsycheMonster.Create();
begin
  try
    inherited;
    m_dwSearchTime := Random(1500) + 1500;
    m_nViewRange := 8;
    m_nAttackRange := 8;
    m_boDupMode := False;
    m_boUnParalysis := True;//�����
    m_dwThinkTick := GetTickCount();
  except
    MainOutMessage(Format('{%s} TPsycheMonster.Create',[g_sExceptionVer]));
  end;
end;

destructor TPsycheMonster.Destroy;
begin
  try
    inherited;
  except
    MainOutMessage(Format('{%s} TPsycheMonster.Destroy ',[g_sExceptionVer]));
  end;
end;

function TPsycheMonster.Think(): Boolean;
var
  nOldX, nOldY: integer;
begin
  try
    Result := False;
    if (GetTickCount - m_dwThinkTick) > 3000 then begin
      m_dwThinkTick := GetTickCount();
      if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
      if not IsProperTarget(m_TargetCret) then m_TargetCret := nil;
    end;
    if m_boDupMode then begin
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(Random(8), False);
      if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
        m_boDupMode := False;
        Result := True;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TPsycheMonster.Think',[g_sExceptionVer]));
  end;
end;

procedure TPsycheMonster.Run;
var
  nX, nY, n14: Integer;
begin
  try
    try
      if not m_boGhost and not m_boDeath and not m_boFixedHideMode and not m_boStoneMode and
        (m_wStatusTimeArr[POISON_STONE {5}] = 0) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
        and (m_wStatusArrValue[23] = 0) then begin
        if Think then begin //����Ƿ��ص����ص�������ƶ�һ��
          inherited;
          Exit;
        end;
        if (not m_boNoAttackMode) and m_boIsVisibleActive then begin
          if (m_Master<> nil) then begin//�����˴�ͬһĿ��
            if (not m_Master.m_boGhost) and ((m_Master.m_TargetCret <> nil)) then begin
              if not m_Master.m_TargetCret.m_boDeath then begin
                if m_Master.m_TargetCret <> m_TargetCret then begin
                  if IsProperTarget(m_Master.m_TargetCret) and
                    (not m_Master.m_TargetCret.m_boHideMode or m_boCoolEye) then begin
                    m_dwSearchEnemyTick := GetTickCount();
                    SetTargetCreat(m_Master.m_TargetCret);
                  end;
                end;
              end;
            end;
          end;
          if ((GetTickCount - m_dwSearchEnemyTick) > 1000) and (m_TargetCret = nil) then begin
            m_dwSearchEnemyTick := GetTickCount();
            SearchTarget(); //�����ɹ���Ŀ��
          end;
        end;
        if m_boWalkWaitLocked then begin
          if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then m_boWalkWaitLocked := False;
        end;
        if not m_boRunAwayMode then begin
          if not m_boNoAttackMode then begin
            if m_TargetCret <> nil then begin
              if AttackTarget then begin
                //inherited;
                //exit;
              end;
            end;
          end;
        end;
        if not m_boWalkWaitLocked and (Integer(GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin
          m_dwWalkTick := GetTickCount();
          Inc(m_nWalkCount);
          if m_nWalkCount > m_nWalkStep then begin
            m_nWalkCount := 0;
            m_boWalkWaitLocked := True;
            m_dwWalkWaitTick := GetTickCount();
          end;
          if not m_boRunAwayMode then begin
            if not m_boNoAttackMode then begin
              if m_TargetCret <> nil then begin
                if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
                  ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
                  if (m_Master <> nil) and (m_PEnvir = m_Master.m_PEnvir) and
                    ((abs(m_nCurrX - m_Master.m_nCurrX) > 6) or
                    (abs(m_nCurrY - m_Master.m_nCurrY) > 6)) then begin
                    n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
                    m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
                  end else begin
                    n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
                    m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
                  end;
                  {if m_nTargetX > 0 then GotoTargetXY();
                  inherited;
                  Exit;}
                end;
              end else begin
                m_nTargetX := -1;
                if m_boMission then begin
                  m_nTargetX := m_nMissionX;
                  m_nTargetY := m_nMissionY;
                end; 
              end;
            end;
            if m_Master <> nil then begin
              if m_TargetCret = nil then begin
                m_Master.GetBackPosition(nX, nY);
                if (abs(m_nTargetX - nX) > 1) or (abs(m_nTargetY - nY {nX}) > 1) then begin
                  m_nTargetX := nX;
                  m_nTargetY := nY;
                  if (abs(m_nCurrX - nX) <= 2) and (abs(m_nCurrY - nY) <= 2) then begin
                    if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then begin
                      m_nTargetX := m_nCurrX;
                      m_nTargetY := m_nCurrY;
                    end;
                  end;
                end;
              end;
              if (not m_Master.m_boSlaveRelax) and ((m_PEnvir <> m_Master.m_PEnvir) or
                (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
                SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
              end;
            end;
          end else begin
            if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then begin
              m_boRunAwayMode := False;
              m_dwRunAwayTime := 0;
            end;
          end;
          if (m_Master <> nil) and m_Master.m_boSlaveRelax then begin
            inherited;
            Exit;
          end;
          if m_nTargetX <> -1 then begin
            GotoTargetXY();
          end else begin
            if m_TargetCret = nil then Wondering();
          end;
        end;
      end else begin
        if m_boDeath then begin
          if (GetTickCount - m_dwDeathTick > 2000) then MakeGhost();//ʬ����ʧ
        end;
      end;
    except
      MainOutMessage(Format('{%s} TPsycheMonster.Run 1',[g_sExceptionVer]));
    end;
    inherited;
  except
    MainOutMessage(Format('{%s} TPsycheMonster.Run',[g_sExceptionVer]));
  end;
end;

procedure TPsycheMonster.FlyAttack(Target: TBaseObject);
{$IF M2Version = 1}
  function GetNGPow(BaseObject: TBaseObject; UserMagic: pTUserMagic; Power: Integer): Integer;
    function MPow1(UserMagic: pTUserMagic): Integer;//���㼼������
    var nPower:Integer;
    begin
      if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
        nPower := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
      else nPower := UserMagic.MagicInfo.wPower;
      if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
        Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
      else Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower);
    end;
  var nNHPoint:Integer;
  begin
    Result := 0;
    try
      if (UserMagic <> nil) and (BaseObject <> nil) then begin
        if UserMagic.btKey = 0 then begin//�ڹ����ܿ��� 20110426
          if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            nNHPoint := TPlayObject(BaseObject).GetSpellPoint(UserMagic);
            if TPlayObject(BaseObject).m_Skill69NH >= nNHPoint then begin
              TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - nNHPoint);
              TPlayObject(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
              if g_Config.nNGSkillRate = 0 then begin
                Result := MPow1(UserMagic);
              end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
              TPlayObject(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
            end;
          end else
          if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
            nNHPoint := THEROOBJECT(BaseObject).GetSpellPoint(UserMagic);
            if THEROOBJECT(BaseObject).m_Skill69NH >= nNHPoint then begin
              THEROOBJECT(BaseObject).m_Skill69NH := _MAX(0, THEROOBJECT(BaseObject).m_Skill69NH - nNHPoint);
              THEROOBJECT(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, THEROOBJECT(BaseObject).m_Skill69NH, THEROOBJECT(BaseObject).m_Skill69MaxNH, 0, '');
              if g_Config.nNGSkillRate = 0 then begin
                Result := MPow1(UserMagic);
              end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
              THEROOBJECT(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
            end;
          end;
        end;
      end;
    except
      Result := 0;
    end;
  end;
{$IFEND}
var
  WAbil: pTAbility;
  nDamage, nSpellPoint{$IF M2Version = 1}, NGSecPwr, nDamageBak{$IFEND}: Integer;
begin
  if ((Random(g_Config.nFairyDuntRate) = 0) and (Target.m_Abil.Level <= m_Abil.Level)) or //�ػ�����,Ŀ��ȼ��������Լ�,��ʹ���ػ� 20080826
     (nHitCount >= _MIN(( 3 + g_Config.nFairyDuntRateBelow) ,(m_btSlaveExpLevel + g_Config.nFairyDuntRateBelow))) then begin//�����ػ�����,�ﵽ����ʱ���ȼ����ػ� 20090105
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Round((Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC)) * g_Config.nFairyAttackRate / 100{�ػ�����}));//20090105
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFairyShareMasterMP then begin//���鹥��ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.35));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      {$IF M2Version = 1}
      nDamageBak:= nDamage;
      if (m_Master<> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          case m_Master.m_btRaceServer of
            RC_PLAYOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, TPlayObject(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
            RC_HEROOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, THEROOBJECT(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
          end;//case
        end;
      end;
      NGSecPwr:= 0;
      if Target <> nil then begin
        case Target.m_btRaceServer of
          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(Target, TPlayObject(Target).m_MagicSkill_242,nDamageBak);//��֮����
          RC_HEROOBJECT: NGSecPwr:= GetNGPow(Target, THEROOBJECT(Target).m_MagicSkill_242,nDamageBak);//��֮����
        end;
        nDamage := _MAX(0, nDamage - NGSecPwr);
      end;
      {$IFEND}
      nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then Target.StruckDamage(nDamage);
    Target.SetLastHiter(self);//20080628
    Target.StruckDamage(nDamage);//20090304 ����
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    if Target.m_btRaceServer <> 55 then begin//20090304 �������������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_FAIRYATTACKRATE, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    nHitCount:= 0;//20090105 ��������
  end else begin
    WAbil := @m_WAbil;
    nDamage := _MAX(0, Random(SmallInt(HiWord(WAbil.DC) - LoWord(WAbil.DC)) + 1) + LoWord(WAbil.DC));
    if nDamage > 0 then begin
      if (m_Master<> nil) and g_Config.boFairyShareMasterMP then begin//���鹥��ʱ�����˼���
        if (not m_Master.m_boGhost) and (not m_Master.m_boDeath) then begin
          nSpellPoint:= Abs(Round(nDamage * 0.1));
          if m_Master.m_WAbil.MP < nSpellPoint then begin
            DelTargetCreat();
            m_dwSearchEnemyTick := GetTickCount();
            Exit;
          end;
          if nSpellPoint > 0 then begin
            m_Master.DamageSpell(nSpellPoint);
            m_Master.HealthSpellChanged();
          end;
        end;
      end;
      {$IF M2Version = 1}
      nDamageBak:= nDamage;
      if (m_Master<> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          case m_Master.m_btRaceServer of
            RC_PLAYOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, TPlayObject(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
            RC_HEROOBJECT: begin
              NGSecPwr := GetNGPow(m_Master, THEROOBJECT(m_Master).m_MagicSkill_241,nDamage);//ŭ֮����
              nDamage := nDamage + NGSecPwr;
            end;
          end;//case
        end;
      end;
      NGSecPwr:= 0;
      if Target <> nil then begin
        case Target.m_btRaceServer of
          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(Target, TPlayObject(Target).m_MagicSkill_242,nDamageBak);//��֮����
          RC_HEROOBJECT: NGSecPwr:= GetNGPow(Target, THEROOBJECT(Target).m_MagicSkill_242,nDamageBak);//��֮����
        end;
        nDamage := _MAX(0, nDamage - NGSecPwr);
      end;
      {$IFEND}
      nDamage := Target.GetHitStruckDamage(Self, nDamage);
    end;
    if nDamage > 0 then begin
      Target.StruckDamage(nDamage);
    end;
    Target.SetLastHiter(self);//20080628
    Target.StruckDamage(nDamage);//20090304 ����
    m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, Target.m_nCurrX, Target.m_nCurrY);
    if Target.m_btRaceServer <> 55 then begin//20090304 �������������ʦ����ʾ��Ϣ
      Target.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end else begin
      Target.SendDelayMsg(Target, RM_STRUCK, nDamage, Target.m_WAbil.HP, Target.m_WAbil.MaxHP, Integer(Self), '',
        _MAX(abs(m_nCurrX - Target.m_nCurrX), abs(m_nCurrY - Target.m_nCurrY)) * 50 + 600);
    end;
    SendRefMsg(RM_LIGHTING, 1, m_nCurrX, m_nCurrY, Integer(Target), '');
    Inc(nHitCount);//20090105 ��������
  end;
end;

function TPsycheMonster.AttackTarget: Boolean;
begin
  try
    Result := False;
    if m_TargetCret <> nil then begin
      if (m_TargetCret.m_PEnvir = m_PEnvir) and
        (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= m_nAttackRange) and
        (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= m_nAttackRange) then begin
        if Integer(GetTickCount - m_dwHitTick) > m_nNextHitTime then begin
          m_dwHitTick := GetTickCount();
          m_dwTargetFocusTick := GetTickCount();
          FlyAttack(m_TargetCret);
          BreakHolySeizeMode();
        end;
        Result := True;
      end else begin
        if m_TargetCret.m_PEnvir = m_PEnvir then begin
          if (abs(m_nCurrX - m_TargetCret.m_nCurrX) <= 11) and
             (abs(m_nCurrY - m_TargetCret.m_nCurrY) <= 11) then begin
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end else begin
          DelTargetCreat();
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} TPsycheMonster.AttackTarget',[g_sExceptionVer]));
  end;
end;

procedure TPsycheMonster.RecalcAbilitys();
begin
  try
    inherited;
    if not g_Config.boFairyUseDBHitTime then//�����ȼ����㹥���ٶ� 20110729
      m_nNextHitTime := _MAX(1000, 1700 - m_btSlaveMakeLevel * 100);
    if m_Master <> nil then m_nWalkSpeed := _MAX(200 , nWalkSpeed{400} - m_btSlaveMakeLevel * 50);//��·�ٶ� 20090106 ��DB���õ���·�ٶȿ���
    m_dwWalkTick := GetTickCount + 2000;
  except
    MainOutMessage(Format('{%s} TPsycheMonster.RecalcAbilitys',[g_sExceptionVer]));
  end;
end;

end.
