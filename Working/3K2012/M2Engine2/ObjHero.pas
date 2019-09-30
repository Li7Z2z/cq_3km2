{------------------------------------------------------------------------------}
{ ��Ԫ����: ObjHero.pas                                                        }
{ ��Ԫ����: Mars                                                               }
{ ��������: 2007-02-12 20:30:00                                                }
{ ���ܽ���: ʵ��Ӣ�۹��ܵ�Ԫ                                                   }
{------------------------------------------------------------------------------}
unit ObjHero;

interface
uses
  Windows, SysUtils, Classes, Grobal2, ObjBase, Castle, IniFiles;

type

  THeroObject = class(TBaseObject)
    m_sMasterName: string[ACTORNAMELEN];//�������� 20090529
    m_sUserID: string[11]; //��¼�ʺ���
    m_dwDoMotaeboTick: LongWord; //Ұ����ײ���  20080529
    m_dwThinkTick: LongWord;
    m_boDupMode: Boolean;  //�����ص���
    m_nTargetX: Integer;//Ŀ������X
    m_nTargetY: Integer;//Ŀ������Y
    m_boRunAwayMode: Boolean;  //����Զ��ģʽ
    m_dwRunAwayStart: LongWord;
    m_dwRunAwayTime: LongWord;
    //m_boCanPickUpItem: Boolean;//�ܼ�����Ʒ //20080428 ע��
    //m_boSlavePickUpItem: Boolean;
    m_dwPickUpItemTick: LongWord;//������Ʒ���
    //m_boIsPickUpItem: Boolean;//20080428 ע��
    //m_nPickUpItemMakeIndex: Integer;//20080428 ע��
    m_SelMapItem: PTMapItem;

    m_wHitMode: Word;//������ʽ

    m_btOldDir: Byte;
    m_dwActionTick: LongWord;//�������
    m_wOldIdent: Word;

    dwTick5F41: LongWord;
    dwTick5F4: LongWord;//�ܲ���ʱ 20090526
    m_dwTurnIntervalTime: LongWord;//ת�����ʱ��
    m_dwMagicHitIntervalTime: LongWord;//ħ��������ʱ��
    //m_dwHitIntervalTime: LongWord;//������ʱ��(δʹ�� 20080510)
    m_dwRunIntervalTime: LongWord;//�ܼ��ʱ��
    m_dwWalkIntervalTime: LongWord;//�߼��ʱ��

    m_dwActionIntervalTime: LongWord;//�������ʱ��
    m_dwRunLongHitIntervalTime: LongWord;//���г������ʱ��
    m_dwWalkHitIntervalTime: LongWord;//�߶��������ʱ��
    m_dwRunHitIntervalTime: LongWord;//�ܹ������ʱ��
    m_dwRunMagicIntervalTime: LongWord;//��ħ�����ʱ��

    m_nDieDropUseItemRate: Integer; //������װ������
    m_SkillUseTick: array[0..80 - 1] of LongWord; //ħ��ʹ�ü��
    m_nItemBagCount: Integer;//��������
    m_btStatus: Byte; //״̬ 0-���� 1-���� 2-��Ϣ
    m_boProtectStatus: Boolean;//�Ƿ����ػ�״̬
    m_boProtectOK: Boolean;//�����ػ����� 20080603
    m_boTarget: Boolean; //�Ƿ�����Ŀ��
    m_nProtectTargetX, m_nProtectTargetY: Integer; //�ػ�����
    m_dwAutoAvoidTick: LongWord;//�Զ���ܼ��
    m_boIsNeedAvoid: Boolean;//�Ƿ���Ҫ���

    m_dwEatItemNoHintTick: LongWord;//Ӣ��ûҩ��ʾʱ����  20080129
    m_dwEatItemTick: LongWord;//����ͨҩ���
    m_dwEatItemTick1: LongWord;//������ҩ��� 20080910
    m_dwSearchIsPickUpItemTick: LongWord;//�����ɼ������Ʒ���
    m_dwSearchIsPickUpItemTime: LongWord;//�����ɼ������Ʒʱ��
    m_boCanDrop: Boolean;//�Ƿ���������
    m_boCanUseItem: Boolean; //�Ƿ�����ʹ����Ʒ
    m_boCanWalk: Boolean;//�Ƿ�������
    m_boCanRun: Boolean;//�Ƿ�������
    m_boCanHit: Boolean;//�Ƿ�������
    m_boCanSpell: Boolean;//�Ƿ�����ħ��
    m_boCanSendMsg: Boolean;//�Ƿ���������Ϣ
    m_btReLevel: Byte; //ת���ȼ�
    m_btCreditPoint: Integer;//������ 20080118
    m_nMemberType: Integer; //��Ա����
    m_nMemberLevel: Integer;//��Ա�ȼ�
    m_nKillMonExpRate: Integer; //ɱ�־���ٷ���(�������� 100 Ϊ��������)
    m_nOldKillMonExpRate: Integer;//ûʹ����װǰɱ�־��鱶�� 20080522

    m_dwMagicAttackInterval: LongWord;//ħ���������ʱ��(Dword)
    m_dwMagicAttackTick: LongWord;//ħ������ʱ��(Dword)
    m_dwMagicAttackCount: LongWord; //ħ����������(Dword) 20080510 
    m_dwSearchMagic: LongWord; //����ħ�����  û��ʹ��

    m_nSelectMagic: Integer;//��ѯħ��
    m_boIsUseMagic: Boolean;//�Ƿ����ʹ�õ�ħ��(True�ſ��ܶ��) 20080714

    m_boIsUseAttackMagic: Boolean;//�Ƿ����ʹ�õĹ���ħ��
    m_btLastDirection: Byte;//���ķ���
    m_wLastHP: Word;//����HPֵ
    m_nPickUpItemPosition: Integer;//�ɼ�����Ʒ��λ��
    m_nFirDragonPoint: Integer;//Ӣ��ŭ��ֵ
    m_dwAddFirDragonTick: LongWord;//����Ӣ��ŭ��ֵ�ļ��
    m_boStartUseSpell: Boolean;//�Ƿ�ʼʹ�úϻ�
    m_boDecDragonPoint:Boolean;//��ʼ��ŭ�� 20080418
   // m_nStartUseSpell: Integer;
    m_dwStartUseSpellTick: LongWord;//ʹ�úϻ��ļ��
    m_boNewHuman: Boolean;//�Ƿ�Ϊ������
    m_nLoyal:Integer;//Ӣ�۵��ҳ϶�(20080110)
    m_dwCheckNoHintTick: LongWord;//Ӣ��û������ʾʱ����  20080328
    n_AmuletIndx: Byte;//�̺춾��ʶ 20080412
    n_HeroTpye: Byte;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-���� 3-����
    m_dwDedingUseTick: LongWord;//�ض�ʹ�ü�� 20080524
    boCallLogOut: Boolean;//�Ƿ��ٻ���ȥ 20080605

    m_dwAddAlcoholTick: LongWord;//���Ӿ������ȵļ��  20080623
    m_dwDecWineDrinkValueTick: LongWord;//������ƶȵļ��  20080623
    n_DrinkWineQuality: Byte;//����ʱ�Ƶ�Ʒ�� 20080623
    n_DrinkWineAlcohol: Byte;//����ʱ�ƵĶ��� 20080624
    n_DrinkWineDrunk: Boolean;//�Ⱦ����� 20080623
    dw_UseMedicineTime: Integer; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ�� 20080623
{$IF M2Version = 1}
    dw_UseMedicineTime1: Integer;//���㳤ʱ��û�Ⱦ�
    n_UsesMedicineTime: Integer;//���Ⱦ�ʱ��һ���Ӽ�ʱ

    m_boOpenupSkill95: Boolean;//��ͨ��ת99��
    m_Magic95Skill: pTUserMagic; //��ת����
    m_MagicSkill_239: pTUserMagic;//ŭ֮ʩ����
    m_MagicSkill_240: pTUserMagic;//��֮ʩ����
    m_MagicSkill_241: pTUserMagic;//ŭ֮����
    m_MagicSkill_242: pTUserMagic;//��֮����

    m_boOpenHumanPulseArr: Boolean;//�Ƿ�ͨ���� 20090910
    m_wHumanPulseArr: THeroPulseInfo1;//��Ѩ����
    m_SetBatterKey: Byte;//��һ���������ܸ� 0-Ϊ�� 1-���
    m_SetBatterKey1: Byte;//�ڶ����������ܸ� 0-Ϊ�� 1-���
    m_SetBatterKey2: Byte;//�������������ܸ� 0-Ϊ�� 1-���
    m_SetBatterKey3: Byte;//���ĸ��������ܸ� 0-Ϊ�� 1-���
    m_boTrainBatterSkill: Boolean;//�Ƿ�ѧϰ����������
    m_nUseBatterTick: LongWord;//ʹ�������ļ�ʱ
    m_BatterMagicList: TList;//���������б�

    m_boUser4BatterSkill: Boolean;//ʹ�õ��ĸ����� 20100720
    m_nBatterMagIdx1: Byte;//��������ID1
    m_nBatterMagIdx2: Byte;//��������ID2
    m_nBatterMagIdx3: Byte;//��������ID3
    m_nBatterMagIdx4: Byte;//��������ID4
    m_boUseBatter: Boolean;//ʹ������
    m_nUseBatterTime: LongWord;//��������Ϣ���
    m_Magic76Skill: pTUserMagic; //����ɱ
    m_Magic79Skill: pTUserMagic; //׷�Ĵ�
    m_Magic82Skill: pTUserMagic; //����ն
    m_Magic85Skill: pTUserMagic; //��ɨǧ��
    m_boWarUseBatter: Boolean;//սʿ�����Ƿ����
    m_dwLatestWarUseBatterTick: LongWord; //սʿ�����ļ��
    m_ExpPuls: LongWord;//Ӣ�۾���������ǰ���� 20090911
    boUseBatterToMon: Boolean;//����Ƿ�ʹ������
    m_dwIncTransferTick: LongWord;//��תֵ�ָ����
{$IFEND}
    n_MedicineLevel: Word;  //ҩ��ֵ�ȼ� 20080623

    dwRockAddHPTick: LongWord;//ħѪʯ��HP ʹ�ü�� 20080728
    dwRockAddMPTick: LongWord;//ħѪʯ��MP ʹ�ü�� 20080728
    boAutoOpenDefence: Boolean;//�Զ�����ħ���� 20080930

    m_boTrainingNG: Boolean;//�Ƿ�ѧϰ���ڹ� 20081002
    m_NGLevel: Word;//�ڹ��ȼ� 20081002
    m_ExpSkill69: LongWord;//�ڹ��ķ���ǰ���� 20080930
    m_MaxExpSkill69: LongWord;//�ڹ��ķ��������� 20080930
    m_Skill69NH: Integer;//��ǰ����ֵ 20110226
    m_Skill69MaxNH: Integer;//�������ֵ 20110226
    m_Magic60Skill: pTUserMagic; //�ƻ�ն
{$IF M2Version <> 2}
    m_dwLatest101Tick: LongWord; //����������
    m_boCanUerSkill101: Boolean;//�����������
    m_dwUseSkillTime: LongWord;//�����������ʱ��
    m_dwLatest102Tick: LongWord; //Ψ�Ҷ�����
    m_dwLatest69Tick: LongWord; //����ٵؼ��
    m_dwUseSkill102Time: LongWord;//Ψ�Ҷ������ʱ��
    m_dwIncNHTick: LongWord;//��������ֵ��� 20081002
    m_nIncNHRecover: Byte;//�����ָ�%(����) 20090330
    m_nIncNHPoint: Word;//�����ָ��ٶ�(����) 20090712
    m_Magic102Skill: pTUserMagic; //Ψ�Ҷ���
    m_Magic99Skill: pTUserMagic; //ǿ���� 20100817
    m_MagicSkill_200: pTUserMagic;//ŭ֮��ɱ
    m_MagicSkill_201: pTUserMagic;//��֮��ɱ
    m_MagicSkill_202: pTUserMagic;//ŭ֮����
    m_MagicSkill_203: pTUserMagic;//��֮����
    m_MagicSkill_204: pTUserMagic;//ŭ֮�һ�
    m_MagicSkill_205: pTUserMagic;//��֮�һ�
    m_MagicSkill_206: pTUserMagic;//ŭ֮����
    m_MagicSkill_207: pTUserMagic;//��֮����
    
    m_MagicSkill_208: pTUserMagic;//ŭ֮����
    m_MagicSkill_209: pTUserMagic;//��֮����
    m_MagicSkill_210: pTUserMagic;//ŭ֮�����
    m_MagicSkill_211: pTUserMagic;//��֮�����
    m_MagicSkill_212: pTUserMagic;//ŭ֮��ǽ
    m_MagicSkill_213: pTUserMagic;//��֮��ǽ
    m_MagicSkill_214: pTUserMagic;//ŭ֮������
    m_MagicSkill_215: pTUserMagic;//��֮������
    m_MagicSkill_216: pTUserMagic;//ŭ֮�����Ӱ
    m_MagicSkill_217: pTUserMagic;//��֮�����Ӱ
    m_MagicSkill_218: pTUserMagic;//ŭ֮���ѻ���
    m_MagicSkill_219: pTUserMagic;//��֮���ѻ���
    m_MagicSkill_220: pTUserMagic;//ŭ֮������
    m_MagicSkill_221: pTUserMagic;//��֮������
    m_MagicSkill_222: pTUserMagic;//ŭ֮�׵�
    m_MagicSkill_223: pTUserMagic;//��֮�׵�
    m_MagicSkill_224: pTUserMagic;//ŭ֮�����׹�
    m_MagicSkill_225: pTUserMagic;//��֮�����׹�
    m_MagicSkill_226: pTUserMagic;//ŭ֮������
    m_MagicSkill_227: pTUserMagic;//��֮������
    m_MagicSkill_228: pTUserMagic;//ŭ֮�����
    m_MagicSkill_229: pTUserMagic;//��֮�����
    m_MagicSkill_230: pTUserMagic;//ŭ֮���
    m_MagicSkill_231: pTUserMagic;//��֮���
    m_MagicSkill_232: pTUserMagic;//ŭ֮��Ѫ
    m_MagicSkill_233: pTUserMagic;//��֮��Ѫ
    m_MagicSkill_234: pTUserMagic;//ŭ֮���ǻ���
    m_MagicSkill_235: pTUserMagic;//��֮���ǻ���
    m_MagicSkill_236: pTUserMagic;//ŭ֮�ڹ�����
    m_MagicSkill_237: pTUserMagic;//��֮�ڹ�����
    m_MagicSkill_238: pTUserMagic;//��֮����ն
{$IFEND}
    m_Magic46Skill: pTUserMagic; //������ 20081217

    m_GetExp: LongWord;//Ӣ��ȡ�õľ���,<$HeroGetExp>����ʹ��  20081228
    //m_AvoidHp: Word;//����Ѫ�� 20081225
    //m_boCrazyProtection: Boolean;//����񻯱��� 20081225

    m_nIncDragonRate: Byte;//�ϻ��˺�(����) 20090330
    m_nIncDragon: Word;//���Ӻϻ���������
    m_boArmsCritPoint: Byte;//���������ȼ� 20100709
    m_nHeapStruckDamage : Integer;//�������������ȼ��������ۻ������� 20100709

    m_boMergerIteming: Boolean;//�Ƿ����ںϲ���Ʒ 20090616
    m_PulseAddAC: Byte;//�������� ��������
    m_PulseAddAC1: Byte;//�������� ��������
    m_PulseAddMAC: Byte;//�������� ħ������
    m_PulseAddMAC1: Byte;//�������� ħ������
    m_dwRateTick: LongWord;//ÿ���ʱ 20091111

    m_UseItems_Bak: THumanUseItems;//���ݵ�װ������Ʒ
    m_ItemList_Bak: TList; //���ݵı����б�
    m_MagicList_Bak: TList;//���ݵļ��ܱ�
    m_nHP_Bak: Integer;//���ݵ�ǰHPֵ
    m_nMP_Bak: Integer;//���ݵ�ǰMPֵ
    m_boRevengeMode: Boolean;//����ģʽ
    m_wSnapArrValue: array[0..6] of Word;//(����ģʽ��������)0-HP���� 1-MP����  2-���� 3-ħ�� 4-���� 5-ħ�� 6-����
    m_dwSnapArrTimeOutTick: array[0..6] of LongWord;//(����ģʽ��������)0-HP���� 1-MP����  2-���� 3-ħ�� 4-���� 5-ħ�� 6-����
    m_btHeroTwoJob: Byte;//����Ӣ��ְҵ
    m_boIsBakData: Boolean;//�Ƿ��б�������
    m_BagItemNames: TStringList;
    m_UseItemNames: TUseItemNames;
    m_dwAutoRepairItemTick: LongWord;
    m_dwAutoAddHealthTick: LongWord;
    ClientSuitAbility: TClientSuitAbility;//��װ�������
  private
    function Think: Boolean;
    function SearchPickUpItem(nPickUpTime: Integer): Boolean; //����Ʒ
    procedure EatMedicine();//��ҩ
    function AutoEatUseItems(btItemType: Byte): Boolean; //�Զ���ҩ
    function WarrAttackTarget(wHitMode: Word): Boolean; {������}
    function WarrorAttackTarget(): Boolean; {սʿ����}
    function WizardAttackTarget(): Boolean; {��ʦ����}
    function TaoistAttackTarget(): Boolean; {��ʿ����}
   // function CompareHP(BaseObject1, BaseObject2: TBaseObject): Boolean;//�Ƚ�HPֵ  20080117
   // function CompareLevel(BaseObject1, BaseObject2: TBaseObject): Boolean;//�Ƚϵȼ� 20080117
   // function CompareXY(BaseObject1, BaseObject2: TBaseObject): Boolean;//�Ƚ�XYֵ 20080117
    function EatUseItems(nShape: Integer): Boolean;//ʹ�õ���Ʒ
    function AutoAvoid(): Boolean; //�Զ����

    function SearchIsPickUpItem(): Boolean;//�Ƿ���Լ����Ʒ
   // function IsPickUpItem(StdItem: pTStdItem): Boolean; 20080117

    function IsNeedAvoid(): Boolean; //�Ƿ���Ҫ���

    function CheckUserMagic(wMagIdx: Word): pTUserMagic;//���ʹ��ħ��
    function CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
    function CheckTargetXYCount1(nX, nY, nRange: Integer): Integer;//սʿ�ж�Ŀ��ʹ�� 20080924
    function CheckTargetXYCount2(nMode: Word): Integer;//�����䵶�ж�Ŀ�꺯�� 20081207
    function CheckTargetXYCount3(nX, nY, nRange, nCount: Integer): Integer;//�����������ܻ�ʹ�� 20090302

    function GotoTargetXYRange(): Boolean;
    function GetUserItemList(nItemType: Integer; nItemShape: Integer): Integer;
    //function UseItem(nItemType, nIndex: Integer; nItemShape: Integer): Boolean;
    function CheckUserItemType(nItemType: Integer; nItemShape: Integer): Boolean;
    function CheckItemType(nItemType: Integer; StdItem: pTStdItem; nItemShape: Integer): Boolean;
    function CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;{���ָ������ͷ�Χ������Ĺ�������}
    function CheckMasterXYOfDirection(TargeTBaseObject: TBaseObject;nX, nY, nDir, nRange: Integer): Integer;{���ָ������ͷ�Χ��,������Ӣ�۵ľ��� 20080204}
    procedure SearchMagic(); //����ħ��
    function SelectMagic(): Integer; //ѡ��ħ��
    //function IsUseMagic(): Boolean; //����Ƿ����ʹ�ñ���ħ�� δʹ�� 20080412
    function IsUseAttackMagic(): Boolean;
    function IsSearchTarget: Boolean;
    function CheckActionStatus(wIdent: Word; var dwDelayTime: LongWord): Boolean; //��鶯����״̬
    //function GetSpellMsgCount: Integer;//ȡ������Ϣ����
    function DoMotaebo(nDir: Byte; nMagicLevel: Integer): Boolean;
    function CallMobeItem(): Boolean;//�ٻ�ǿ����,���г��ı������7��  20080329
    procedure RepairAllItem(DureCount: Integer; boDec: Boolean);//ȫ���޸�
    Function RepairAllItemDura:Integer;//ȫ���޸�,��Ҫ�ĳ־�ֵ 20080325
    function GetTogetherUseSpell: Integer;
    Function CheckHeroAmulet(nType: Integer; nCount: Integer):Boolean; //�жϵ�Ӣ�۶����Ƿ�����,��ʾ�û� 20080401
    function UseStdmodeFunItem(StdItem: pTStdItem): Boolean;//Ӣ��ʹ����Ʒ����  20080728
    {$IF M2Version <> 2}
    procedure CheckItmeAutoItme(btWhere, btStdMode, btShape: Byte);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
    procedure PlaySuperRock;//��Ѫʯ���� 20080729
    function CheckItemSpiritMedia(UserItem: pTUserItem): Boolean; overload;//�����Ʒ�Ƿ�Ϊ��ý��Ʒ
    function CheckItemSpiritMedia(UserItem: TUserItem): Boolean; overload;//�����Ʒ�Ƿ�Ϊ��ý��Ʒ
    procedure Skill102MagicAttack(nX, nY: Integer; nRage: Integer);//3��Ψ�Ҷ�����(Ŀ��ķ�����ħ������0������Ч������10��)
    {$IFEND}
    function MagMakeHPUp(UserMagic: pTUserMagic): Boolean;//�������� 20080925
    procedure RecalcAdjusBonus();//ˢ��Ӣ������������20081126
    {$IF M2Version = 1}
    function HeroBatterAttackTarget(): Boolean;//Ӣ������������� 20091028
    {$IFEND}
    procedure NewGotoTargetXY;
    procedure HeroTail();
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;//������Ϣ
    function AttackTarget(): Boolean;//����Ŀ��
    function FindGroupMagic: pTUserMagic;
    function CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean;
    function IsEnoughBag(): Boolean;
    procedure RecalcAbilitys; override;
    procedure Run; override;
    procedure Initialize; override;
    procedure Die; override;
    function GetShowName(): string; override;
    procedure ItemDamageRevivalRing();
    procedure RebirthItemDecDura();//������ָ��Ч������Ʒ�־� 20100720
    procedure DoDamageWeapon(nWeaponDamage: Integer);
    procedure StruckDamage(nDamage: Integer);override;//����override;���ع��� 20080607
    function IsAllowUseMagic(wMagIdx: Word): Boolean;
    function UseMagicToSkill102Level3: Boolean;//�ж�Ψ�Ҷ����Ƿ��3�������ж���Χ3���Ƿ��й�
    procedure SearchTarget();
    procedure DelTargetCreat(); override;
    procedure SetTargetXY(nX, nY: Integer); virtual;
    function WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;
    function WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;
    function RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;
    function GetGotoXY(BaseObject: TBaseObject; nCode:Byte): Boolean;
    function GotoTargetXY(nTargetX, nTargetY, nCode: Integer): Boolean;

    procedure Wondering(); virtual;
    procedure Attack(TargeTBaseObject: TBaseObject; nDir: Integer); virtual; //����
    procedure Struck(hiter: TBaseObject); virtual;

    procedure ClientQueryBagItems();
    function FindMagic(wMagIdx: Word): pTUserMagic;//����ħ��
    function FindMagic1(sMagicName: string): pTUserMagic;
    procedure RefMyStatus();
    function AddItemToBag(UserItem: pTUserItem): Boolean;
    procedure WeightChanged;
    function ReadBook(StdItem: pTStdItem): Boolean;
    function EatItems(StdItem: pTStdItem; boType: Boolean{�Ƿ�����}; nType: Byte): Boolean;
    procedure SysMsg(sMsg: string; MsgColor: TMsgColor; MsgType: TMsgType);
    procedure SendSocket(DefMsg: pTDefaultMessage; sMsg: string);
    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    procedure SendDefMessage1(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; wSessionID: Integer; sMsg: string);//������integer���Ͳ���
    procedure SendMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string);
    procedure SendUpdateMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string);
    procedure SendDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
    procedure SendUpdateDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
    //procedure SendChangeItems(nWhere1, nWhere2: Integer; UserItem1, UserItem2: pTUserItem);
    procedure SendUseitems();
    procedure SendUseMagic();
    procedure SendDelMagic(UserMagic: pTUserMagic);
    procedure SendAddMagic(UserMagic: pTUserMagic);
    procedure SendAddItem(UserItem: pTUserItem);
    procedure SendDelItemList(ItemList: TStringList);
    procedure SendDelItems(UserItem: pTUserItem);
    procedure SendUpdateItem(UserItem: pTUserItem);
    procedure ClientHeroUseItems(nItemIdx: Integer; sItemName: string; boType: Boolean{�Ƿ�����};nType: Byte); //Ӣ��ʹ����Ʒ
    procedure GetBagItemCount;
    procedure MakeWeaponUnlock;
    function WeaptonMakeLuck: Boolean;
    function RepairWeapon: Boolean;
    function SuperRepairWeapon: Boolean;
    {$IF M2Version <> 2}
    procedure GetNGExp(dwExp1: LongWord; Code: Byte);//ȡ���������� 20081001
    procedure NGMAGIC_LVEXP(UserMagic: pTUserMagic);//�ڹ��������� 20081003
    procedure SendNGData;//�����ڹ����� 20081005
    procedure SendNGResume();//�����ڹ����⣬�˺����ָ��ٶ����� 20090813
    procedure ClientHeroUpNGStrongSkill(wMagIdx{����ID}: Integer);//�ͻ���ǿ��ŭ֮�ڹ� 20110605
    {$IFEND}
    procedure GetExp(dwExp: uInt64; nType: Byte);//ȡ�þ���
    procedure WinExp(dwExp: LongWord);
    procedure GainExp(dwExp: LongWord);
    function AbilityUp(UserMagic: pTUserMagic): Boolean;
    function ClientSpellXY(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
      TargeTBaseObject: TBaseObject): Boolean;
    function ClientDropItem(sItemName: string; nItemIdx: Integer): Boolean;
    function DoSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; BaseObject: TBaseObject): Boolean;
    function FindTogetherMagic: pTUserMagic;
    function WearFirDragon: Boolean;
    procedure RepairFirDragon(btType: Byte; nItemIdx: Integer; sItemName: string);//�޲�����֮��
    procedure RepairDragonIndia(nItemIdx: Integer; sItemName: string);//ʹ��ħѪʯ�������ӡ 20110116

    procedure MakeSaveRcd(var HumanRcd: THumDataInfo; var NewHeroDataInfo: TNewHeroDataInfo);
    procedure Login();
    function LevelUpFunc: Boolean;//Ӣ���������� 20080423
    function NGLevelUpFunc: Boolean;//Ӣ���ڹ���������  20090509
    function IsNeedGotoXY(): Boolean; //�Ƿ�����Ŀ��
    procedure ChangeHeroMagicKey(nSkillIdx, nKey: Integer; sMsg: string);//����Ӣ��ħ������ 20080606
    procedure ClearCopyItem(wIndex, MakeIndex: Integer);//����Ӣ�۰�������Ʒ 20080901
    function GetSpellPoint(UserMagic: pTUserMagic): Integer;//ȡʹ��ħ�������MPֵ
    function CheckItemBindDieNoDrop(UserItem: pTUserItem): Boolean;//�������װ��������Ʒ�Ƿ� 20081127

    procedure ClientHeroItemSplit(nItemMakeIdx{����ID}: Integer; nDura{�������}: Integer);//�ͻ���Ӣ�۰��������Ʒ 20090616
    procedure ClientHeroItemMerger(nItemMakeIdx{��Ҫ�ϲ�����Ʒ����ID}: Integer; sMakeIdx{�ϲ�������Ʒ}: String);//�ͻ���(Ӣ�۰���)�ϲ���Ʒ 20090616
    function QuestCheckItem(sItemName{��Ʒ��}: string; var nCount{����}, nParam: Integer; var nDura: Integer): pTUserItem;
{$IF M2Version = 1}
    function GetSkill95Exp(nLevel: Byte): LongWord;//��ת���� ȡ�ȼ��������辭��
    function GetSkill_95Value(nAC, nAMC: Integer; nLevel:Byte):Word;//���㶷תֵ����
    procedure SendUserPulseArr;//��½ʱ������Ѩ����
    procedure SendUserPulsePulsePoint(nPulse{����ҳ}: byte; boOK: Boolean);//������Ѩ��ӦѨλ�����Լ�������ڹ��ȼ�
    procedure ClientOpenHeroPulsePoint(nPulse{����ҳ}, nPoint{Ѩλ}: byte);//�ͻ��˵��Ѩλ,ִ�нű�����ͨѨλ
    procedure SendUpdataPulseArr(nPulse{����ҳ}: byte);//���͸�����Ѩ����
    procedure ClientHeroSkillToJingQing(nPage: Byte; nMakeIndex: Integer);//�ͻ��������澭����
    procedure GetPulsExp(dwExp: LongWord; nType: byte);//ȡ�þ��羭��
    procedure SendGetPulsExp(dwExp: LongWord);
    function HeroGetBatterMagic(): Boolean;//Ӣ��ȡ��������ID
    procedure UseBatterSpell(nMagicID{����ID},StormsHit{������}: Byte);//������
    procedure BatterAttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word; StormsHit{������}: Byte);//ս��������
    procedure HeroBatterStop();//Ӣ������ֹͣ
{$IFEND}
  end;

implementation
uses UsrEngn, M2Share, Event, Envir, Magic, HUtil32, EDcode, PlugOfEngine, ObjAIPlayObject;

{ THeroObject }

constructor THeroObject.Create;
begin
  inherited;
  m_sMasterName:= '';//�������� 20090529
  boCallLogOut:= False;
  m_btRaceServer := RC_HEROOBJECT;
  m_boDupMode := False;
  m_dwThinkTick := GetTickCount();
  m_nViewRange := 10;
  m_nRunTime := 250;
  m_dwSearchTick := GetTickCount();
  m_nCopyHumanLevel := 3;
  m_nTargetX := -1;
  dwTick3F4 := GetTickCount();
  m_btNameColor := g_Config.nHeroNameColor{6};//���ֵ���ɫ  20080315
  m_boFixedHideMode := True;
  //m_dwHitIntervalTime := g_Config.dwHitIntervalTime; //�������
  m_dwMagicHitIntervalTime := g_Config.dwMagicHitIntervalTime; //Ӣ��ħ���������{û��ʹ�� 20080217}
  m_dwRunIntervalTime := g_Config.dwHeroRunIntervalTime;//Ӣ���ܲ���� 20090207
  m_dwWalkIntervalTime := g_Config.dwHeroWalkIntervalTime; //Ӣ����·���  20080213
  m_dwTurnIntervalTime := g_Config.dwHeroTurnIntervalTime; //Ӣ�ۻ������� 20080213
  m_dwActionIntervalTime := g_Config.dwActionIntervalTime; //��ϲ������
  m_dwRunLongHitIntervalTime := g_Config.dwRunLongHitIntervalTime; //��ϲ������
  m_dwRunHitIntervalTime := g_Config.dwRunHitIntervalTime; //��ϲ������
  m_dwWalkHitIntervalTime := g_Config.dwWalkHitIntervalTime; //��ϲ������
  m_dwRunMagicIntervalTime := g_Config.dwRunMagicIntervalTime; //��λħ�����

  m_dwHitTick := GetTickCount - LongWord(Random(3000));
  m_dwWalkTick := GetTickCount - LongWord(Random(3000));
  m_nWalkSpeed := 350;//20081005 ԭΪ300
  m_nWalkStep := 10;
  m_dwWalkWait := 0;
  m_dwSearchEnemyTick := GetTickCount();
  m_boRunAwayMode := False;
  m_dwRunAwayStart := GetTickCount();
  m_dwRunAwayTime := 0;
  //m_boCanPickUpItem := True;//20080428 ע��
  //m_boSlavePickUpItem := False;//20080428 ע��
  m_dwPickUpItemTick := GetTickCount();
  m_dwAutoAvoidTick := GetTickCount();
  m_dwEatItemTick := GetTickCount();
  m_dwEatItemTick1 := GetTickCount();//20080910
  m_dwEatItemNoHintTick := GetTickCount(); //20080129
  m_boIsNeedAvoid := False;
  m_SelMapItem := nil;
  //m_boIsPickUpItem := False;//20080428 ע��
  m_nNextHitTime := 300;//�´ι���ʱ��
  m_nDieDropUseItemRate := 100;
  m_nItemBagCount := 10;
  m_btStatus := 0; //״̬ Ĭ��Ϊ���� 20080323
  m_boProtectStatus := False; //�Ƿ����ػ�״̬
  m_boProtectOK := False;//�����ػ����� 20080603
  m_boTarget := False; //�Ƿ�����Ŀ��

  m_nProtectTargetX := -1; //�ػ�����
  m_nProtectTargetY := -1; //�ػ�����

  m_boCanDrop := True; //�Ƿ���������Ʒ
  m_boCanUseItem := True; //�Ƿ�����ʹ����Ʒ
  m_boCanWalk := True;
  m_boCanRun := True;
  m_boCanHit := True;
  m_boCanSpell := True;
  m_boCanSendMsg := True;
  m_btReLevel := 0;
  m_btCreditPoint := 0;
  m_nMemberType := 0;
  m_nMemberLevel := 0;
  m_nKillMonExpRate := 100;
  m_nOldKillMonExpRate := m_nKillMonExpRate;//20080522
  m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080714
  m_boIsUseAttackMagic := False;
  m_nSelectMagic := 0;
  m_nPickUpItemPosition := 0;
  m_nFirDragonPoint := 0;//20080419 ŭ�����ó�ʼ��,
  m_dwAddFirDragonTick := GetTickCount();
  m_btLastDirection := m_btDirection;
  m_wLastHP := 0;
 // m_nStartUseSpell := 0;
  m_boStartUseSpell := False;
  m_boDecDragonPoint := False;//20080418 ��ʼ��ŭ��
  m_dwSearchMagic := GetTickCount();
  FillChar(m_SkillUseTick, SizeOf(m_SkillUseTick), 0);
  m_boNewHuman := False;
  m_nLoyal:=0;//Ӣ�۵��ҳ϶�(20080109)
  n_AmuletIndx:= 0;//20080412
  m_dwDedingUseTick := 0;//20080524 �ض�ʹ�ü��

  m_dwAddAlcoholTick:= GetTickCount;//���Ӿ������ȵļ��  20080623
  m_dwDecWineDrinkValueTick:= GetTickCount;//������ƶȵļ��  20080623
  n_DrinkWineQuality:= 0;//����ʱ�Ƶ�Ʒ�� 20080623
  n_DrinkWineAlcohol:= 0;//����ʱ�ƵĶ��� 20080624
  n_DrinkWineDrunk:= False;//�Ⱦ����� 20080623

  dw_UseMedicineTime:= 0; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ�� 20080623
{$IF M2Version = 1}
  dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;//���㳤ʱ��û�Ⱦ�
  m_dwIncTransferTick:= GetTickCount;//��תֵ�ָ����
{$IFEND}
  n_MedicineLevel:= 0;  //ҩ��ֵ�ȼ� 20080623

  boAutoOpenDefence:= False;//�Զ�����ħ���� 20080930
{$IF M2Version <> 2}
  m_dwLatest101Tick:= GetTickCount;//����������
  m_boCanUerSkill101:= False;//�����������
  m_dwUseSkillTime:= GetTickCount;//�����������ʱ��
  m_dwLatest102Tick:= GetTickCount;//Ψ�Ҷ�����
  m_dwLatest69Tick := GetTickCount();//����ٵؼ��
  m_dwUseSkill102Time:= GetTickCount;//Ψ�Ҷ������ʱ��
  m_boTrainingNG := False;//�Ƿ�ѧϰ���ڹ� 20081002
  m_NGLevel := 1;//�ڹ��ȼ� 20081002
  m_ExpSkill69:= 0;//�ڹ��ķ���ǰ���� 20080930
  m_MaxExpSkill69:= 0;//�ڹ��ķ��������� 20080930
  m_Skill69NH:= 0;//��ǰ����ֵ 20080930
  m_Skill69MaxNH:= 0;//�������ֵ 20080930
  m_dwIncNHTick:= GetTickCount;//��������ֵ��ʱ 20081002
  m_nIncNHRecover:= 0;//�����ָ�%(����) 20090330
  m_nIncNHPoint:= 0;//�����ָ��ٶ�(����) 20090712
  m_Magic102Skill:= nil; //Ψ�Ҷ���
  m_Magic99Skill:= nil; //ǿ���� 20100817
  m_Magic60Skill:= nil;//�ƻ�ն
  m_MagicSkill_200:= nil;//ŭ֮��ɱ
  m_MagicSkill_201:= nil;//��֮��ɱ
  m_MagicSkill_202:= nil;//ŭ֮����
  m_MagicSkill_203:= nil;//��֮����
  m_MagicSkill_204:= nil;//ŭ֮�һ�
  m_MagicSkill_205:= nil;//��֮�һ�
  m_MagicSkill_206:= nil;//ŭ֮����
  m_MagicSkill_207:= nil;//��֮����
  m_MagicSkill_208:= nil;//ŭ֮����
  m_MagicSkill_209:= nil;//��֮����
  m_MagicSkill_210:= nil;//ŭ֮�����
  m_MagicSkill_211:= nil;//��֮�����
  m_MagicSkill_212:= nil;//ŭ֮��ǽ
  m_MagicSkill_213:= nil;//��֮��ǽ
  m_MagicSkill_214:= nil;//ŭ֮������
  m_MagicSkill_215:= nil;//��֮������
  m_MagicSkill_216:= nil;//ŭ֮�����Ӱ
  m_MagicSkill_217:= nil;//��֮�����Ӱ
  m_MagicSkill_218:= nil;//ŭ֮���ѻ���
  m_MagicSkill_219:= nil;//��֮���ѻ���
  m_MagicSkill_220:= nil;//ŭ֮������
  m_MagicSkill_221:= nil;//��֮������
  m_MagicSkill_222:= nil;//ŭ֮�׵�
  m_MagicSkill_223:= nil;//��֮�׵�
  m_MagicSkill_224:= nil;//ŭ֮�����׹�
  m_MagicSkill_225:= nil;//��֮�����׹�
  m_MagicSkill_226:= nil;//ŭ֮������
  m_MagicSkill_227:= nil;//��֮������
  m_MagicSkill_228:= nil;//ŭ֮�����
  m_MagicSkill_229:= nil;//��֮�����
  m_MagicSkill_230:= nil;//ŭ֮���
  m_MagicSkill_231:= nil;//��֮���
  m_MagicSkill_232:= nil;//ŭ֮��Ѫ
  m_MagicSkill_233:= nil;//��֮��Ѫ
  m_MagicSkill_234:= nil;//ŭ֮���ǻ���
  m_MagicSkill_235:= nil;//��֮���ǻ���
  m_MagicSkill_236:= nil;//ŭ֮�ڹ�����
  m_MagicSkill_237:= nil;//��֮�ڹ�����
  m_MagicSkill_238 := nil;//��֮����ն
{$IFEND}
  m_Magic46Skill:= nil; //������ 20081217
{$IF M2Version = 1}
  m_boOpenupSkill95:= False;//��ͨ��ת99��
  m_Magic95Skill:= nil; //��ת����
  m_MagicSkill_239:= nil;//ŭ֮ʩ����
  m_MagicSkill_240:= nil;//��֮ʩ����
  m_MagicSkill_241:= nil;//ŭ֮����
  m_MagicSkill_242:= nil;//��֮����
  m_Magic76Skill:= nil;//����ɱ
  m_Magic79Skill:= nil;//׷�Ĵ�
  m_Magic82Skill:= nil;//����ն
  m_Magic85Skill:= nil;//��ɨǧ��
  m_ExpPuls:= 0;//Ӣ�۾���������ǰ���� 20090911
  m_boOpenHumanPulseArr:= False;//�Ƿ�ͨ����ҳ
  FillChar(m_wHumanPulseArr, SizeOf(THeroPulseInfo1), #0);//��Ѩ����
  m_SetBatterKey:= 0;//��һ���������ܸ�
  m_SetBatterKey1:= 0;//�ڶ����������ܸ�
  m_SetBatterKey2:= 0;//�������������ܸ�
  m_SetBatterKey3:= 0;//���ĸ��������ܸ�
  m_boTrainBatterSkill:= False;
  m_BatterMagicList:= TList.Create;//���������б�
  m_boUser4BatterSkill:= False;//ʹ�õ��ĸ����� 20100720
  m_nBatterMagIdx1:= 0;//��������ID1
  m_nBatterMagIdx2:= 0;//��������ID2
  m_nBatterMagIdx3:= 0;//��������ID3
  m_nBatterMagIdx4:= 0;//��������ID4
  m_boUseBatter:= False;
  m_boWarUseBatter:= False;//սʿ�����Ƿ����
  m_dwLatestWarUseBatterTick:= GetTickCount();//սʿ�����ļ��
  m_nUseBatterTick:= GetTickCount();//ʹ�������ļ�ʱ
  boUseBatterToMon:= True;//����Ƿ�ʹ������
{$IFEND}
  m_GetExp:= 0;//����ȡ�õľ���,$GetExp����ʹ��  20081228
  //m_AvoidHp:= 0;//����Ѫ�� 20081225
  //m_boCrazyProtection:= False;//����񻯱��� 20081225
  m_boCoolEye:= True;//Ӣ�ۿ��Կ��������� 20090326
  m_nIncDragonRate:= 0;//�ϻ��˺�(����) 20090330
  m_nIncDragon:= 0;//���Ӻϻ���������
  m_boArmsCritPoint:= 0;//���������ȼ� 20100709
  m_nHeapStruckDamage:= 0;//�������������ȼ��������ۻ������� 20100709

  dwTick5F4 := GetTickCount();//20090526
  m_boMergerIteming:= False;//�Ƿ����ںϲ���Ʒ 20090616
  m_PulseAddAC:= 0;//�������� ��������
  m_PulseAddAC1:= 0;//�������� ��������
  m_PulseAddMAC:= 0;//�������� ħ������
  m_PulseAddMAC1:= 0;//�������� ħ������
  m_dwRateTick := GetTickCount();

  m_ItemList_Bak := TList.Create;
  m_MagicList_Bak := TList.Create;
  FillChar(m_UseItems_Bak, SizeOf(THumanUseItems), 0);
  m_nHP_Bak:= 0;//���ݵ�ǰHPֵ
  m_nMP_Bak:= 0;//���ݵ�ǰMPֵ
  m_boRevengeMode:= False;//����ģʽ
  FillChar(m_wSnapArrValue, SizeOf(m_wSnapArrValue), 0);
  FillChar(m_dwSnapArrTimeOutTick, SizeOf(m_dwSnapArrTimeOutTick), #0);
  m_btHeroTwoJob:= 0;//����Ӣ��ְҵ
  m_boIsBakData:= False;//�Ƿ��б�������
  m_BagItemNames := TStringList.Create;
  FillChar(m_UseItemNames, SizeOf(TUseItemNames), #0);
  m_dwAutoRepairItemTick:= GetTickCount();
  m_dwAutoAddHealthTick:= GetTickCount();
  FillChar(ClientSuitAbility, SizeOf(ClientSuitAbility), #0);//��װ���������
end;

destructor THeroObject.Destroy;
var
  I: Integer;
begin
{$IF M2Version = 1}
  try
    if m_BatterMagicList <> nil then begin
      FreeAndNil(m_BatterMagicList);
    end;
  except
  end;
{$IFEND}
  try
    if m_ItemList_Bak <> nil then begin
      for I := m_ItemList_Bak.Count - 1 downto 0 do begin
        if m_ItemList_Bak.Count <= 0 then Break;
        Try
          if pTUserItem(m_ItemList_Bak.Items[I]) <> nil then Dispose(pTUserItem(m_ItemList_Bak.Items[I]));
        except
        end;
      end;
      FreeAndNil(m_ItemList_Bak);
    end;
  except
  end;
  try
    if m_MagicList_Bak <> nil then begin
      if m_MagicList_Bak.Count > 0 then begin
        for I := 0 to m_MagicList_Bak.Count - 1 do begin
          try
            if pTUserMagic(m_MagicList_Bak.Items[I]) <> nil then
              Dispose(pTUserMagic(m_MagicList_Bak.Items[I]));
          except
          end;
        end;
      end;
      FreeAndNil(m_MagicList_Bak);
    end;
  except
  end;
  inherited;
end;

procedure THeroObject.SysMsg(sMsg: string; MsgColor: TMsgColor; MsgType: TMsgType);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) then begin
    if TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
    m_Master.SysMsg(sMsg, MsgColor, MsgType);
  end;
end;

procedure THeroObject.SendSocket(DefMsg: pTDefaultMessage; sMsg: string);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  TPlayObject(m_Master).SendSocket(DefMsg, sMsg);
end;

procedure THeroObject.SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  TPlayObject(m_Master).SendDefMessage(wIdent, nRecog, nParam, nTag, nSeries, sMsg);
end;
//������integer���Ͳ���
procedure THeroObject.SendDefMessage1(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; wSessionID: Integer; sMsg: string);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  TPlayObject(m_Master).SendDefMessage1(wIdent, nRecog, nParam, nTag, nSeries,wSessionID, sMsg);
end;

procedure THeroObject.SendMsg(BaseObject: TBaseObject; wIdent, wParam: Word; nParam1, nParam2, nParam3: Integer; sMsg: string);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  m_Master.SendMsg(BaseObject, wIdent, wParam, nParam1, nParam2, nParam3, sMsg);
end;

procedure THeroObject.SendUpdateMsg(BaseObject: TBaseObject; wIdent, wParam: Word;
  lParam1, lParam2, lParam3: Integer; sMsg: string);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  m_Master.SendUpdateMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg);
end;

procedure THeroObject.SendDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  m_Master.SendDelayMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg, dwDelay);
end;

procedure THeroObject.SendUpdateDelayMsg(BaseObject: TBaseObject; wIdent, wParam: Word; lParam1, lParam2, lParam3: Integer; sMsg: string; dwDelay: LongWord);
begin
  if (m_Master = nil) or m_boAI then Exit;
  if (m_Master <> nil) and TPlayObject(m_Master).m_boNotOnlineAddExp then Exit;
  m_Master.SendUpdateDelayMsg(BaseObject, wIdent, wParam, lParam1, lParam2, lParam3, sMsg, dwDelay);
end;

function THeroObject.FindTogetherMagic: pTUserMagic;
begin
  Result := FindMagic(GetTogetherUseSpell);
end;

function THeroObject.FindGroupMagic: pTUserMagic;
begin
  Result := FindMagic(GetTogetherUseSpell);
end;
//����ְҵ,�ж�Ӣ�ۿ���ѧϰ���ּ���
function THeroObject.GetTogetherUseSpell: Integer;
begin
  Result := 0;
  if m_Master = nil then Exit;
  case m_Master.m_btJob of
    0: begin
        case m_btJob of
          0: Result := 60;
          1: Result := 62;
          2: Result := 61;
        end;
      end;
    1: begin
        case m_btJob of
          0: Result := 62;
          1: Result := 65;
          2: Result := 64;
        end;
      end;
    2: begin
        case m_btJob of
          0: Result := 61;
          1: Result := 64;
          2: Result := 63;
        end;
      end;
  end;
end;
//ˢ��Ӣ�۵İ���
procedure THeroObject.ClientQueryBagItems();
var
  I: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  EffecItem: pTEffecItem;
  StdItem: TStdItem;
  UserItem: pTUserItem;
  sUserItemName: string;
begin
  if m_Master <> nil then begin//20081220
    if TPlayObject(m_Master).m_boCanQueryBag or m_boDeath then Exit;//�Ƿ����ˢ�°��� 20080917  ��������ˢ�°���
    TPlayObject(m_Master).m_boCanQueryBag:= True;
    try
      sSENDMSG := '';
      if m_ItemList.Count > 0 then begin//20080628
        for I := 0 to m_ItemList.Count - 1 do begin
          UserItem := m_ItemList.Items[I];
          if UserItem <> nil then begin//20081220
            if CheckIsOKItem(UserItem) then begin//����̬��Ʒ 20090704
              UserItem.wIndex:= 0;
              UserItem.MakeIndex:= 0;
              Continue;
            end;
            if (UserItem.AddValue[0] = 1) and (GetHoursCount(UserItem.MaxDate, Now) <= 0) then begin//ɾ������װ�� 20110911
              UserItem.wIndex:= 0;
              UserItem.MakeIndex:= 0;
              Continue;
            end;
            if (UserItem.AddValue[0] = 2) and (GetHoursCount(UserItem.MaxDate, Now) <= 0) then begin//�󶨵��ڣ���ƷΪ����״̬ 20110911
              UserItem.AddValue[0]:= 0;
            end;            
            Item := UserEngine.GetStdItem(UserItem.wIndex);
            if Item <> nil then begin
              FillChar(ClientItem, SizeOf(ClientItem), #0);
              StdItem := Item^;
              ItemUnit.GetItemAddValue(UserItem, StdItem);
              Move(StdItem, ClientItem.s, SizeOf(TStdItem));
              {By TasNat at: 2012-11-22 11:01:35
              //ȡ��Ч����
              EffecItem:= GetEffecItemList(StdItem.Name);//ȡ��Ʒ��Ч
              if EffecItem <> nil then begin
                Move(EffecItem^, ClientItem.ClientEffec, SizeOf(TEffecItem));
              end;   }
              //ȡ�Զ�����Ʒ����
              sUserItemName := '';
              if UserItem.btValue[13] = 1 then
                sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
              if sUserItemName <> '' then ClientItem.s.Name := sUserItemName;
              if (UserItem.btValue[12] = 1) and (StdItem.StdMode <> 5) and (StdItem.StdMode <> 6) then ClientItem.s.Reserved1:=1//��Ʒ���� 20080223
              else  ClientItem.s.Reserved1:= 0;

              case StdItem.StdMode of //20090816
                {$IF M2Version <> 2}
                5, 6: begin
                  ClientItem.s.NeedIdentify:= _MIN(High(Byte),UserItem.btValue[11] + UserItem.btValue[20]);//���������ȼ� 20100708
                  if CheckItemSpiritMedia(UserItem) then begin
                    ClientItem.Aura:= UserItem.btValue[12];
                    ClientItem.MaxAura:= g_Config.nMaxAuraValue;
                  end;
                end;
                10,11,15,16,19..24,26..30,52,54,55,62,64: begin
                  if CheckItemSpiritMedia(UserItem) then begin
                    ClientItem.Aura:= UserItem.btValue[11];
                    ClientItem.MaxAura:= g_Config.nMaxAuraValue;
                  end;
                end;                  
                44: begin
                  if StdItem.Shape = 255 then ClientItem.s.NeedIdentify:= UserItem.btValue[0];
                  if StdItem.Shape = 253 then begin//��ħ��ý
                    ClientItem.Aura:= UserItem.btValue[11];
                    ClientItem.MaxAura:= g_Config.nMaxAuraValue;
                  end;
                end;
                {$IFEND}
                8:if UserItem.btValue[0] <> 0 then ClientItem.s.AC:= UserItem.btValue[0];//���ϵ�Ʒ��
                17: if StdItem.Weight > 0 then ClientItem.s.Weight:= UserItem.Dura;//�����Ʒ������ 20090816
                60: begin
                  if (StdItem.shape <> 0) then begin//����,���վ��� 20080717
                    if UserItem.btValue[0] <> 0 then ClientItem.s.AC:=UserItem.btValue[0];//�Ƶ�Ʒ��
                    if UserItem.btValue[1] <> 0 then ClientItem.s.MAC:=UserItem.btValue[1];//�Ƶľƾ���
                    if UserItem.btValue[3] > 0 then ClientItem.s.NeedLevel:=UserItem.btValue[3]//�Ƶĵȼ� 20091117
                    else ClientItem.s.NeedLevel:= 0;
                  end;
                end;
              end;

              ClientItem.Dura := UserItem.Dura;
              ClientItem.DuraMax := UserItem.DuraMax;
              ClientItem.MakeIndex := UserItem.MakeIndex;
              Move(UserItem.btValue, ClientItem.btValue, SizeOf(ClientItem.btValue));// liuzhigang
              //Modified By TasNat at: 2012-04-12 09:28:18
              ClientItem.btAppraisalLevel := UserItem.btAppraisalLevel;
              ClientItem.btUnKnowValueCount := UserItem.btUnKnowValueCount;
              Move(UserItem.btAppraisalValue, ClientItem.btAppraisalValue, SizeOf(UserItem.btAppraisalValue));

              Move(UserItem.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
              ClientItem.BindValue:= UserItem.AddValue[0];//20110622
              ClientItem.MaxDate:= UserItem.MaxDate;//20110622
              if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
                if (CheckItemValue(UserItem ,1) and CheckItemValue(UserItem ,0)) or
                   (GetCheckItemList(0, StdItem.Name) and GetCheckItemList(1, StdItem.Name)) then
                  ClientItem.BindValue := 3;
              end;
              sSENDMSG := sSENDMSG + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
            end;
          end;
        end;
      end;
      if sSENDMSG <> '' then begin
        m_DefMsg := MakeDefaultMsg(SM_HEROBAGITEMS, Integer(m_Master), 0, 0, m_ItemList.Count, 0);
        SendSocket(@m_DefMsg, sSENDMSG);
      end else begin//20090101���ӣ��������Զ���װ��ʱ�������ﻹ�м�����Ʒ
        m_DefMsg := MakeDefaultMsg(SM_HEROBAGITEMS, Integer(m_Master), 0, 0, m_ItemList.Count, 0);
        SendSocket(@m_DefMsg, '');      
      end;
      if m_Master <> nil then TPlayObject(m_Master).IsItem_51(1);//���;�����ľ��� 20080427 20090109
    finally
      TPlayObject(m_Master).m_boCanQueryBag:= False;
    end;
  end;
end;

procedure THeroObject.GetBagItemCount;
var
  I: Integer;
  nOldBagCount: Integer;
begin
  nOldBagCount := m_nItemBagCount;
  for I := High(g_Config.nHeroBagItemCount) downto Low(g_Config.nHeroBagItemCount) do begin
    if m_Abil.Level >= g_Config.nHeroBagItemCount[I] then begin
      case I of
        0: m_nItemBagCount := 10;
        1: m_nItemBagCount := 20;
        2: m_nItemBagCount := 30;
        3: m_nItemBagCount := 35;
        4: m_nItemBagCount := 40;
      end;
      Break;
    end;
  end;
  if nOldBagCount <> m_nItemBagCount then begin
    SendMsg(m_Master, RM_QUERYHEROBAGCOUNT, 0, m_nItemBagCount, 0, 0, '');
  end;
end;

function THeroObject.AddItemToBag(UserItem: pTUserItem): Boolean;
begin
  Result := False;
  if m_Master = nil then Exit;
  if m_ItemList.Count < m_nItemBagCount then begin
    m_ItemList.Add(UserItem);
    WeightChanged();
    Result := True;
  end;
end;
//����ʹ�õ�ħ��
procedure THeroObject.SendUseMagic();
var
  I: Integer;
  sSENDMSG: string;
  UserMagic: pTUserMagic;
  ClientMagic: TClientMagic;
  nCode: byte;//20090212
begin
  nCode:= 0;
  try
    sSENDMSG := '';
    nCode:= 1;
    if m_MagicList.Count > 0 then begin//20080630
      nCode:= 2;
      for I := 0 to m_MagicList.Count - 1 do begin
        nCode:= 3;
        UserMagic := m_MagicList.Items[I];
        nCode:= 4;
        if UserMagic <> nil then begin
          nCode:= 5;
          ClientMagic.Key := Chr(UserMagic.btKey);
          nCode:= 6;
          ClientMagic.Level := UserMagic.btLevel;
          ClientMagic.CurTrain := UserMagic.nTranPoint;
          ClientMagic.Def := UserMagic.MagicInfo^;
          ClientMagic.btLevelEx := UserMagic.btLevelEx;
          case ClientMagic.Def.wMagicId of
            SKILL_68: ClientMagic.Def.MaxTrain[0] := GetSkill68Exp(UserMagic.btLevel);//��������
            {$IF M2Version <> 2}
            {$IF M2Version = 1}
            SKILL_95: ClientMagic.Def.MaxTrain[0] := GetSkill95Exp(UserMagic.btLevel);//��ת����
            {$IFEND}
            SKILL_200: begin//ŭ֮��ɱǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_200NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_200NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_202: begin//ŭ֮����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_202NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_202NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_236: begin//ŭ֮�ڹ�����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_236NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_236NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_204: begin//ŭ֮�һ�ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_204NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_204NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_206: begin//ŭ֮����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_206NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_206NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_239: begin//ŭ֮ʩ����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_239NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_239NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_230: begin//ŭ֮���ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_230NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_230NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_232: begin//ŭ֮��Ѫǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_232NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_232NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_241: begin//ŭ֮����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_241NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_241NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_228: begin//ŭ֮�����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_228NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_228NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_234: begin//ŭ֮���ǻ���ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_234NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_234NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_208: begin//ŭ֮����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_208NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_208NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_214: begin//ŭ֮������ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_214NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_214NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_218: begin//ŭ֮���ѻ���ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_218NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_218NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_222: begin//ŭ֮�׵�ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_222NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_222NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_210: begin//ŭ֮�����ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_210NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_210NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_212: begin//ŭ֮��ǽǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_212NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_212NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_216: begin//ŭ֮�����Ӱǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_216NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_216NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_224: begin//ŭ֮�����׹�ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_224NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_224NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_226: begin//ŭ֮������ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_226NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_226NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
                Skill_220: begin//ŭ֮������ǿ��
                  if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
                    ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_220NGStrong[1]);
                    ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_220NGStrong[3]);
                  end else begin
                    ClientMagic.Def.wPower:= 0;
                    ClientMagic.Def.wMaxPower:= 0;
                  end;
                end;
            {$IFEND}
            SKILL_99: ClientMagic.Def.MaxTrain[0] := 300 + (UserMagic.btLevel * 200);//ǿ��������������ͨ���㷨ȡ��
            SKILL_100: ClientMagic.Def.MaxTrain[0] := 500 + (UserMagic.btLevel * 700);//���ؽ��
            SKILL_71,SKILL_104: ClientMagic.Def.MaxTrain[0] := GetUpKill71Count(UserMagic.btLevel);//�ٻ�ʥ��,�ٻ�����
          end;
          nCode:= 7;
          sSENDMSG := sSENDMSG + EncodeBuffer(@ClientMagic, SizeOf(TClientMagic)) + '/';
        end;
      end;
    end;
    nCode:= 8;
    //if sSENDMSG <> '' then begin//20090407 ע�ͣ������Ĵ�Ӣ�ۣ��ڹ����ܼ���
      {$IF M2Version = 1}
        m_DefMsg := MakeDefaultMsg(SM_HEROSENDMYMAGIC, m_SetBatterKey, m_SetBatterKey1, m_SetBatterKey2, m_MagicList.Count, m_SetBatterKey3);//���ĸ��������ܸ� 20100719
      {$ELSE}
        m_DefMsg := MakeDefaultMsg(SM_HEROSENDMYMAGIC, 0, 0, 0, m_MagicList.Count, 0);
      {$IFEND}
      SendSocket(@m_DefMsg, sSENDMSG);
    //end;
  except
    MainOutMessage(Format('{%s} THeroObject.SendUseMagic Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//����ʹ�õ���Ʒ,�����ϵ�װ��
procedure THeroObject.SendUseitems();
var
  I: Integer;
  Item: pTStdItem;
  sSENDMSG: string;
  ClientItem: TClientItem;
  EffecItem: pTEffecItem;
  StdItem: TStdItem;
  sUserItemName: string;
  nCode: byte;//20090212
begin
  nCode:= 0;
  try
    sSENDMSG := '';
    nCode:= 1;
    for I := Low(THumanUseItems) to High(THumanUseItems) do begin
      nCode:= 2;
      if m_UseItems[I].wIndex > 0 then begin
        if (m_UseItems[I].AddValue[0] = 1) and (GetHoursCount(m_UseItems[I].MaxDate, Now) <= 0) then begin //ɾ������װ��
          SendDelItems(@m_UseItems[I]);
          m_UseItems[I].wIndex := 0;
          Continue;
        end;
        nCode:= 3;
        Item := UserEngine.GetStdItem(m_UseItems[I].wIndex);
        if Item <> nil then begin
          FillChar(ClientItem, SizeOf(ClientItem), #0);
          StdItem := Item^;
          nCode:= 4;
          ItemUnit.GetItemAddValue(@m_UseItems[I], StdItem);
          nCode:= 5;
          Move(StdItem, ClientItem.s, SizeOf(TStdItem));
          //ȡ��Ч����
          {By TasNat at: 2012-11-22 11:02:19
          EffecItem:= GetEffecItemList(StdItem.Name);//ȡ��Ʒ��Ч
          if EffecItem <> nil then begin
            Move(EffecItem^, ClientItem.ClientEffec, SizeOf(TEffecItem));
          end; }
          //ȡ�Զ�����Ʒ����
          nCode:= 6;
          sUserItemName := '';
          if m_UseItems[I].btValue[13] = 1 then
            sUserItemName := ItemUnit.GetCustomItemName(m_UseItems[I].MakeIndex, m_UseItems[I].wIndex);
          if (m_UseItems[I].btValue[12] = 1) and (StdItem.StdMode <> 5) and (StdItem.StdMode <> 6) then ClientItem.s.Reserved1:=1//��Ʒ���� 20080229
          else ClientItem.s.Reserved1:= 0;
          if sUserItemName <> '' then ClientItem.s.Name := sUserItemName;
          nCode:= 7;
          {$IF M2Version <> 2}
          if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then begin//���������ȼ� 20100708
            ClientItem.s.NeedIdentify:= _MIN(High(Byte),m_UseItems[I].btValue[11] + m_UseItems[I].btValue[20]);
            if CheckItemSpiritMedia(m_UseItems[I]) then begin
              ClientItem.Aura:= m_UseItems[I].btValue[12];
              ClientItem.MaxAura:= g_Config.nMaxAuraValue;
            end;
          end else begin
            if CheckItemSpiritMedia(m_UseItems[I]) then begin
              ClientItem.Aura:= m_UseItems[I].btValue[11];
              ClientItem.MaxAura:= g_Config.nMaxAuraValue;
            end;
          end;
          {$IFEND}
          ClientItem.Dura := m_UseItems[I].Dura;
          ClientItem.DuraMax := m_UseItems[I].DuraMax;
          ClientItem.MakeIndex := m_UseItems[I].MakeIndex;
          Move(m_UseItems[I].btValue, ClientItem.btValue, SizeOf(ClientItem.btValue));// liuzhigang
          //Modified By TasNat at: 2012-04-12 09:28:18
          ClientItem.btAppraisalLevel :=   m_UseItems[I].btAppraisalLevel;
          ClientItem.btUnKnowValueCount := m_UseItems[I].btUnKnowValueCount;
          Move(m_UseItems[I].btAppraisalValue, ClientItem.btAppraisalValue, SizeOf(m_UseItems[I].btAppraisalValue));
          Move(m_UseItems[I].btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
          ClientItem.BindValue:= m_UseItems[I].AddValue[0];//20110622
          ClientItem.MaxDate:= m_UseItems[I].MaxDate;//20110622
          if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
            if (CheckItemValue(@m_UseItems[I] ,1) and CheckItemValue(@m_UseItems[I] ,0)) or
               (GetCheckItemList(0, StdItem.Name) and GetCheckItemList(1, StdItem.Name)) then
              ClientItem.BindValue := 3;
          end;
          nCode:= 8;
          sSENDMSG := sSENDMSG + IntToStr(I) + '/' + EncodeBuffer(@ClientItem, SizeOf(ClientItem)) + '/';
        end;
      end;
    end;
    nCode:= 9;
    if sSENDMSG <> '' then begin
      m_DefMsg := MakeDefaultMsg(SM_SENDHEROUSEITEMS, 0, 0, 0, 0, 0);
      SendSocket(@m_DefMsg, sSENDMSG);
    end;
    nCode:= 11;
    if WearFirDragon and (m_nFirDragonPoint > 0) then begin//�л���֮��,��ŭ������0ʱ����  20080419
      if m_nFirDragonPoint > g_Config.nMaxFirDragonPoint then m_nFirDragonPoint:= g_Config.nMaxFirDragonPoint;//20080528 ��ֹŭ�������󳬹�
      SendMsg({m_Master}self, RM_FIRDRAGONPOINT, g_Config.nMaxFirDragonPoint, m_nFirDragonPoint, 0, 0, '');//����Ӣ��ŭ��ֵ 20090109 �޸�
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.SendUseitems Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
(*
procedure THeroObject.SendChangeItems(nWhere1, nWhere2: Integer; UserItem1, UserItem2: pTUserItem);
var
  StdItem1, StdItem2: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;
  sUserItemName: string;
  sSendText: string;
begin
  sSendText := '';
  if UserItem1 <> nil then begin
    StdItem1 := UserEngine.GetStdItem(UserItem1.wIndex);
    if StdItem1 <> nil then begin
      StdItem80 := StdItem1^;
      ItemUnit.GetItemAddValue(@UserItem1, StdItem80);
      Move(StdItem80, ClientItem.s, SizeOf(TStdItem));
      //ȡ�Զ�����Ʒ����
      sUserItemName := '';
      if UserItem1.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem1.MakeIndex, UserItem1.wIndex);
      if sUserItemName <> '' then
        ClientItem.s.Name := sUserItemName;
      ClientItem.MakeIndex := UserItem1.MakeIndex;
      ClientItem.Dura := UserItem1.Dura;
      ClientItem.DuraMax := UserItem1.DuraMax;
      Move(UserItem1.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
      ClientItem.BindValue:= UserItem1.AddValue[0];//20110622
      ClientItem.MaxDate:= UserItem1.MaxDate;//20110622
      if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
        if (CheckItemValue(UserItem1 ,1) and CheckItemValue(UserItem1 ,0)) or
           (GetCheckItemList(0, StdItem80.Name) and GetCheckItemList(1, StdItem80.Name)) then
          ClientItem.BindValue := 3;
      end;
      sSendText := '0/' + IntToStr(nWhere1) + '/' + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
    end;
  end;

  if UserItem2 <> nil then begin
    StdItem2 := UserEngine.GetStdItem(UserItem2.wIndex);
    if StdItem2 <> nil then begin
      StdItem80 := StdItem2^;
      ItemUnit.GetItemAddValue(@UserItem2, StdItem80);
      Move(StdItem80, ClientItem.s, SizeOf(TStdItem));
      //ȡ�Զ�����Ʒ����
      sUserItemName := '';
      if UserItem2.btValue[13] = 1 then
        sUserItemName := ItemUnit.GetCustomItemName(UserItem2.MakeIndex, UserItem2.wIndex);
      if sUserItemName <> '' then
        ClientItem.s.Name := sUserItemName;
      ClientItem.MakeIndex := UserItem2.MakeIndex;
      ClientItem.Dura := UserItem2.Dura;
      ClientItem.DuraMax := UserItem2.DuraMax;
      Move(UserItem2.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
      ClientItem.BindValue:= UserItem2.AddValue[0];//20110622
      ClientItem.MaxDate:= UserItem2.MaxDate;//20110622
      if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
        if (CheckItemValue(UserItem2 ,1) and CheckItemValue(UserItem2 ,0)) or
           (GetCheckItemList(0, StdItem80.Name) and GetCheckItemList(1, StdItem80.Name)) then
          ClientItem.BindValue := 3;
      end;
      if sSendText = '' then begin
        sSendText := '1/' + IntToStr(nWhere2) + '/' + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
      end else begin
        sSendText := sSendText + '1/' + IntToStr(nWhere2) + '/' + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
      end;
    end;
  end;
  if sSendText <> '' then begin
    m_DefMsg := MakeDefaultMsg(SM_HEROCHANGEITEM, Integer(m_Master), 0, 0, 0, 0);
    SendSocket(@m_DefMsg, sSendText);
  end;
end;  *)

procedure THeroObject.SendDelItemList(ItemList: TStringList);
var
  I: Integer;
  s10: string;
begin
  s10 := '';
  if ItemList.Count > 0 then begin//20080630
    for I := 0 to ItemList.Count - 1 do begin
      s10 := s10 + ItemList.Strings[I] + '/' + IntToStr(Integer(ItemList.Objects[I])) + '/';
    end;
  end;
  m_DefMsg := MakeDefaultMsg(SM_HERODELITEMS, 0, 0, 0, ItemList.Count, 0);
  SendSocket(@m_DefMsg, EncodeString(s10));
end;

procedure THeroObject.SendDelItems(UserItem: pTUserItem);
var
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;

  sUserItemName: string;
begin
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then begin
    StdItem80 := StdItem^;
    ItemUnit.GetItemAddValue(@UserItem, StdItem80);
    Move(StdItem80, ClientItem.s, SizeOf(TStdItem));
    //ȡ�Զ�����Ʒ����
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName <> '' then ClientItem.s.Name := sUserItemName;
    if (UserItem.btValue[12] = 1) and (StdItem.StdMode <> 5) and (StdItem.StdMode <> 6) then ClientItem.s.Reserved1:=1//��Ʒ���� 20080223
    else ClientItem.s.Reserved1:= 0 ;
    {$IF M2Version <> 2}
    if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then begin//���������ȼ� 20100708
      ClientItem.s.NeedIdentify:= _MIN(High(Byte),UserItem.btValue[11] + UserItem.btValue[20]);
      if CheckItemSpiritMedia(UserItem) then begin
        ClientItem.Aura:= UserItem.btValue[12];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end else begin
      if CheckItemSpiritMedia(UserItem) or ((StdItem.StdMode = 44) and (StdItem.shape = 253)) then begin
        ClientItem.Aura:= UserItem.btValue[11];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end;
    if (StdItem.StdMode = 44) and (StdItem.shape = 255) then begin//���ؾ���
      ClientItem.s.NeedIdentify:= UserItem.btValue[0];
    end;
    {$IFEND}
    ClientItem.MakeIndex := UserItem.MakeIndex;
    ClientItem.Dura := UserItem.Dura;
    ClientItem.DuraMax := UserItem.DuraMax;
    //Modified By TasNat at: 2012-04-12 09:28:18
    ClientItem.btAppraisalLevel :=   UserItem.btAppraisalLevel;
    ClientItem.btUnKnowValueCount := UserItem.btUnKnowValueCount;
    Move(UserItem.btAppraisalValue, ClientItem.btAppraisalValue, SizeOf(UserItem.btAppraisalValue));
    Move(UserItem.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
    {if StdItem.StdMode = 50 then begin//20080808 ע��
      ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);
    end;}
    m_DefMsg := MakeDefaultMsg(SM_HERODELITEM, Integer(m_Master), 0, 0, 1, 0);
    SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(ClientItem)));
  end;
end;

procedure THeroObject.SendAddItem(UserItem: pTUserItem);
var
  pStdItem: pTStdItem;
  StdItem: TStdItem;
  ClientItem: TClientItem;
  EffecItem: pTEffecItem;
  sUserItemName: string;
begin
  pStdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if pStdItem = nil then Exit;
  FillChar(ClientItem, SizeOf(ClientItem), #0);
  StdItem := pStdItem^;
  ItemUnit.GetItemAddValue(UserItem, StdItem);
  Move(StdItem, ClientItem.s, SizeOf(TStdItem));
  //ȡ��Ч����
  {By TasNat at: 2012-11-22 11:03:49
  EffecItem:= GetEffecItemList(StdItem.Name);//ȡ��Ʒ��Ч
  if EffecItem <> nil then begin
    Move(EffecItem^, ClientItem.ClientEffec, SizeOf(TEffecItem));
  end;   }
  //ȡ�Զ�����Ʒ����
  sUserItemName := '';
  if UserItem.btValue[13] = 1 then
    sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
  if sUserItemName <> '' then ClientItem.s.Name := sUserItemName;
  if (UserItem.btValue[12] = 1) and (StdItem.StdMode <> 5) and (StdItem.StdMode <> 6) then ClientItem.s.Reserved1:=1//��Ʒ���� 20080223
  else ClientItem.s.Reserved1:= 0;

  ClientItem.MakeIndex := UserItem.MakeIndex;
  ClientItem.Dura := UserItem.Dura;
  ClientItem.DuraMax := UserItem.DuraMax;
  Move(UserItem.btValue, ClientItem.btValue, SizeOf(ClientItem.btValue));//20100822
  //Modified By TasNat at: 2012-04-12 09:28:18
  ClientItem.btAppraisalLevel :=   UserItem.btAppraisalLevel;
  ClientItem.btUnKnowValueCount := UserItem.btUnKnowValueCount;
  Move(UserItem.btAppraisalValue, ClientItem.btAppraisalValue, SizeOf(UserItem.btAppraisalValue));
  Move(UserItem.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
  ClientItem.BindValue:= UserItem.AddValue[0];//20110622
  ClientItem.MaxDate:= UserItem.MaxDate;//20110622
  if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
    if (CheckItemValue(UserItem ,1) and CheckItemValue(UserItem ,0)) or
       (GetCheckItemList(0, StdItem.Name) and GetCheckItemList(1, StdItem.Name)) then
      ClientItem.BindValue := 3;
  end;
  case StdItem.StdMode of//20090816
    {$IF M2Version <> 2}
    5,6: begin
      ClientItem.s.NeedIdentify:= _MIN(High(Byte),UserItem.btValue[11] + UserItem.btValue[20]);//���������ȼ� 20100708
      if CheckItemSpiritMedia(UserItem) then begin
        ClientItem.Aura:= UserItem.btValue[12];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end;
    44: begin
      if StdItem.Shape = 255 then ClientItem.s.NeedIdentify:= UserItem.btValue[0];
      if StdItem.Shape = 253 then begin//��ħ��ý
        ClientItem.Aura:= UserItem.btValue[11];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end;
    10,11,16,30,52,54,55,62,64: begin
      if CheckItemSpiritMedia(UserItem) then begin
        ClientItem.Aura:= UserItem.btValue[11];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end;
    {$IFEND}
    8: if UserItem.btValue[0] <> 0 then ClientItem.s.AC:=UserItem.btValue[0];//���ϵ�Ʒ��
    15, 19..24, 26..29: begin
      if UserItem.btValue[8] <> 0 then ClientItem.s.Shape := 130;//20100513 20100628 ����29����(��������������)
      {$IF M2Version <> 2}
      if CheckItemSpiritMedia(UserItem) then begin
        ClientItem.Aura:= UserItem.btValue[11];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
      {$IFEND}
    end;
    17: if StdItem.Weight > 0 then ClientItem.s.Weight:= UserItem.Dura;//�����Ʒ������ 20090816
    //50: ClientItem.s.Name := ClientItem.s.Name + ' #' + IntToStr(UserItem.Dura);//20080808 ע��
    60: begin
      if (StdItem.shape <> 0) then begin//����,���վ��� 20080702
        if UserItem.btValue[0] <> 0 then ClientItem.s.AC:=UserItem.btValue[0];//�Ƶ�Ʒ��
        if UserItem.btValue[1] <> 0 then ClientItem.s.MAC:=UserItem.btValue[1];//�Ƶľƾ���
        if UserItem.btValue[3] > 0 then ClientItem.s.NeedLevel:=UserItem.btValue[3]//�Ƶĵȼ� 2009111
        else ClientItem.s.NeedLevel:= 0;
      end;
    end;
  end;
  m_DefMsg := MakeDefaultMsg(SM_HEROADDITEM, Integer(m_Master), 0, 0, 1, 0);
  SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(ClientItem)));
end;

procedure THeroObject.SendUpdateItem(UserItem: pTUserItem);
var
  StdItem: pTStdItem;
  StdItem80: TStdItem;
  ClientItem: TClientItem;
  EffecItem: pTEffecItem;
  sUserItemName: string;
begin
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then begin
    FillChar(ClientItem, SizeOf(ClientItem), #0);
    StdItem80 := StdItem^;
    ItemUnit.GetItemAddValue(UserItem, StdItem80);
    ClientItem.s := StdItem80;
    //ȡ��Ч����
    {By TasNat at: 2012-11-22 11:06:44
    EffecItem:= GetEffecItemList(StdItem.Name);//ȡ��Ʒ��Ч
    if EffecItem <> nil then begin
      Move(EffecItem^, ClientItem.ClientEffec, SizeOf(TEffecItem));
    end;}
    //ȡ�Զ�����Ʒ����
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName <> '' then ClientItem.s.Name := sUserItemName;
    if (UserItem.btValue[12] = 1) and (StdItem.StdMode <> 5) and (StdItem.StdMode <> 6) then ClientItem.s.Reserved1:=1//��Ʒ���� 20080223
    else ClientItem.s.Reserved1:= 0;

    if (StdItem.StdMode = 60) and (StdItem.shape <> 0) then begin//����,���վ��� 20080703
      if UserItem.btValue[0] <> 0 then ClientItem.s.AC:=UserItem.btValue[0];//�Ƶ�Ʒ��
      if UserItem.btValue[1] <> 0 then ClientItem.s.MAC:=UserItem.btValue[1];//�Ƶľƾ���
      if UserItem.btValue[3] > 0 then ClientItem.s.NeedLevel:=UserItem.btValue[3]//�Ƶĵȼ� 20091117
      else ClientItem.s.NeedLevel:= 0;
    end;
    if (StdItem.StdMode = 17) and (StdItem.Weight > 0) then ClientItem.s.Weight:= UserItem.Dura;//�����Ʒ������ 20090816
    {$IF M2Version <> 2}
    if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then begin//���������ȼ� 20100708
      ClientItem.s.NeedIdentify:= _MIN(High(Byte),UserItem.btValue[11] + UserItem.btValue[20]);
      if CheckItemSpiritMedia(UserItem) then begin
        ClientItem.Aura:= UserItem.btValue[12];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end else begin
      if CheckItemSpiritMedia(UserItem) or ((StdItem.StdMode = 44) and (StdItem.shape = 253)) then begin
        ClientItem.Aura:= UserItem.btValue[11];
        ClientItem.MaxAura:= g_Config.nMaxAuraValue;
      end;
    end;
    if (StdItem.StdMode = 44) and (StdItem.shape = 255) then begin//���ؾ���
      ClientItem.s.NeedIdentify:= UserItem.btValue[0];
    end;
    {$IFEND}
    ClientItem.MakeIndex := UserItem.MakeIndex;
    ClientItem.Dura := UserItem.Dura;
    ClientItem.DuraMax := UserItem.DuraMax;
    //Modified By TasNat at: 2012-04-12 09:28:18
    ClientItem.btAppraisalLevel :=   UserItem.btAppraisalLevel;
    ClientItem.btUnKnowValueCount := UserItem.btUnKnowValueCount;
    Move(UserItem.btAppraisalValue, ClientItem.btAppraisalValue, SizeOf(UserItem.btAppraisalValue));

    Move(UserItem.btUnKnowValue, ClientItem.btUnKnowValue, SizeOf(ClientItem.btUnKnowValue));//20100822
    ClientItem.BindValue:= UserItem.AddValue[0];//20110622
    ClientItem.MaxDate:= UserItem.MaxDate;//20110622
    if ClientItem.BindValue = 0 then begin//��ֹ����,����Ʒ,��ʾ�� 20110626
      if (CheckItemValue(UserItem ,1) and CheckItemValue(UserItem ,0)) or
         (GetCheckItemList(0, StdItem.Name) and GetCheckItemList(1, StdItem.Name)) then
        ClientItem.BindValue := 3;
    end;
    m_DefMsg := MakeDefaultMsg(SM_HEROUPDATEITEM, Integer(Self), 0, 0, 1, 0);
    SendSocket(@m_DefMsg, EncodeBuffer(@ClientItem, SizeOf(ClientItem)));
  end;
end;

function THeroObject.GetShowName(): string;
begin
  //Result := m_sCharName;
  if g_Config.boNameSuffix then //�Ƿ���ʾ��׺  20080315
    Result :=m_sCharName +'\('+ m_Master.m_sCharName + g_Config.sHeroNameSuffix +')'
  else Result := m_sCharName + g_Config.sHeroName;
  if g_Config.boUnKnowHum and IsUsesZhuLi then Result :='������';//���϶��Ҽ���ʾ������ 20080424
end;
//�����ָ��Ч�������ָ�
procedure THeroObject.ItemDamageRevivalRing();
var
  I: Integer;
  pSItem: pTStdItem;
  nDura, tDura: Integer;
  HeroObject: THeroObject;
begin
  for I := High(THumanUseItems) downto Low(THumanUseItems) do begin//9��װ��+4��װ��(��ѭ���������ȼ���ָ���ٵ��� 20110118)
    if (m_UseItems[I].wIndex > 0) and ((m_UseItems[I].Dura > 0) or g_Config.boItmeAutoOver) then begin
      pSItem := UserEngine.GetStdItem(m_UseItems[I].wIndex);
      if pSItem <> nil then begin
        if (pSItem.Shape in [114, 160, 161, 162]) or (((I = U_WEAPON) or (I = U_RIGHTHAND)) and (pSItem.AniCount in [114, 160, 161, 162])) then begin
          nDura := m_UseItems[I].Dura;
          tDura := Round(nDura / 1000 {1.03});
          Dec(nDura, 1000);
          if nDura <= 0 then begin
            nDura := 0;
            m_UseItems[I].Dura := nDura;
            if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
              if m_btRaceServer = RC_HEROOBJECT then begin
                HeroObject := THeroObject(Self);
                HeroObject.SendDelItems(@m_UseItems[I]);
              end;
              m_UseItems[I].wIndex := 0;
            end;
            RecalcAbilitys();
            CompareSuitItem(False);//��װ������װ���Ա� 20080729
          end else begin //004C0331                                                         
            m_UseItems[I].Dura := nDura;
          end;
          if tDura <> Round(nDura / 1000 {1.03}) then begin
            SendMsg(Self, RM_HERODURACHANGE, I, nDura, m_UseItems[I].DuraMax, 0, '');
          end;
          break;//20110118 �ָ�ע��(��������ͬ�����ԵĲ�ͬλ����Ʒʱ��ȫ���־�)
        end; 
      end; //004C0397 if pSItem <> nil then begin
    end; //if UseItems[i].wIndex > 0 then begin
  end; // for i:=Low(UseItems) to High(UseItems) do begin
end;

//������ָ��Ч������Ʒ�־� 20100720
procedure THeroObject.RebirthItemDecDura();
var
  I, K: Integer;
  pSItem: pTStdItem;
  nDura, tDura: Integer;
  HeroObject: THeroObject;
begin
  for I := Low(THumanUseItems) to High(THumanUseItems) do begin//9��װ��+4��װ��
    if (m_UseItems[I].wIndex > 0) and ((m_UseItems[I].Dura > 0) or g_Config.boItmeAutoOver) then begin
      pSItem := UserEngine.GetStdItem(m_UseItems[I].wIndex);
      if pSItem <> nil then begin
        if ((pSItem.Shape = 197) and (pSItem.StdMode in [19..24,26..29])) or//������ָ 20110922�޸�
           ((pSItem.AniCount = 202) and ((I = U_WEAPON) or (I = U_RIGHTHAND))) then begin//����ѫ��
          nDura := m_UseItems[I].Dura;
          tDura := Round(nDura / 1000 {1.03});
          Dec(nDura, 1000);
          if nDura <= 0 then begin
            nDura := 0;
            m_UseItems[I].Dura := nDura;
            if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
              if m_btRaceServer = RC_HEROOBJECT then begin
                HeroObject := THeroObject(Self);
                HeroObject.SendDelItems(@m_UseItems[I]);
              end;
              if pSItem.NeedIdentify = 1 then//��Ʒ��ʧ��¼��־
                AddGameDataLog('6' + #9 +m_sMapName + #9 +
                  IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                  m_sCharName + #9 + pSItem.Name + #9 +
                  IntToStr(m_UseItems[I].MakeIndex) + #9 +
                  '('+IntToStr(LoWord(pSItem.DC))+'/'+IntToStr(HiWord(pSItem.DC))+')'+
                  '('+IntToStr(LoWord(pSItem.MC))+'/'+IntToStr(HiWord(pSItem.MC))+')'+
                  '('+IntToStr(LoWord(pSItem.SC))+'/'+IntToStr(HiWord(pSItem.SC))+')'+
                  '('+IntToStr(LoWord(pSItem.AC))+'/'+IntToStr(HiWord(pSItem.AC))+')'+
                  '('+IntToStr(LoWord(pSItem.MAC))+'/'+IntToStr(HiWord(pSItem.MAC))+')'+
                  IntToStr(m_UseItems[I].btValue[0])+'/'+IntToStr(m_UseItems[I].btValue[1])+'/'+IntToStr(m_UseItems[I].btValue[2])+'/'+
                  IntToStr(m_UseItems[I].btValue[3])+'/'+IntToStr(m_UseItems[I].btValue[4])+'/'+IntToStr(m_UseItems[I].btValue[5])+'/'+
                  IntToStr(m_UseItems[I].btValue[6])+'/'+IntToStr(m_UseItems[I].btValue[7])+'/'+IntToStr(m_UseItems[I].btValue[8])+'/'+
                  IntToStr(m_UseItems[I].btValue[14])+ #9 + '�־úľ�');
              m_UseItems[I].wIndex := 0;
            end;
            RecalcAbilitys();
            CompareSuitItem(False);//200080729 ��װ
          end else m_UseItems[I].Dura := nDura;
          if tDura <> Round(nDura / 1000 {1.03}) then begin
            SendMsg(Self, RM_HERODURACHANGE, I, nDura, m_UseItems[I].DuraMax, 0, '');
          end;
          break;
        end;

        {$IF M2Version <> 2}
        if (m_btRaceServer = RC_PLAYOBJECT) or (m_btRaceServer = RC_HEROOBJECT) then begin//�����Ӣ�۲�ִ��
          if (m_UseItems[I].btAppraisalLevel in [2..4,12..14,22..24,32..34,42..44,52..54]) or
             ((m_UseItems[I].btUnKnowValueCount > 0) and (m_UseItems[I].btUnKnowValueCount < 5)) then begin//��������,�����������Ե�
            if ((m_UseItems[I].Dura > 0) or g_Config.boItmeAutoOver) then begin
              for K := 6 to 9 do begin
                if m_UseItems[I].btUnKnowValue[K] = 1 then begin//��������
                  nDura := m_UseItems[I].Dura;
                  tDura := Round(nDura / 1000 {1.03});
                  Dec(nDura, 1000);
                  if nDura <= 0 then begin
                    nDura := 0;
                    m_UseItems[I].Dura := nDura;
                    if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
                      if m_btRaceServer = RC_HEROOBJECT then begin
                        HeroObject := THeroObject(Self);
                        HeroObject.SendDelItems(@m_UseItems[I]);
                      end;
                      if pSItem.NeedIdentify = 1 then//��Ʒ��ʧ��¼��־
                        AddGameDataLog('6' + #9 +m_sMapName + #9 +
                          IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                          m_sCharName + #9 + pSItem.Name + #9 +
                          IntToStr(m_UseItems[I].MakeIndex) + #9 +
                          '('+IntToStr(LoWord(pSItem.DC))+'/'+IntToStr(HiWord(pSItem.DC))+')'+
                          '('+IntToStr(LoWord(pSItem.MC))+'/'+IntToStr(HiWord(pSItem.MC))+')'+
                          '('+IntToStr(LoWord(pSItem.SC))+'/'+IntToStr(HiWord(pSItem.SC))+')'+
                          '('+IntToStr(LoWord(pSItem.AC))+'/'+IntToStr(HiWord(pSItem.AC))+')'+
                          '('+IntToStr(LoWord(pSItem.MAC))+'/'+IntToStr(HiWord(pSItem.MAC))+')'+
                          IntToStr(m_UseItems[I].btValue[0])+'/'+IntToStr(m_UseItems[I].btValue[1])+'/'+IntToStr(m_UseItems[I].btValue[2])+'/'+
                          IntToStr(m_UseItems[I].btValue[3])+'/'+IntToStr(m_UseItems[I].btValue[4])+'/'+IntToStr(m_UseItems[I].btValue[5])+'/'+
                          IntToStr(m_UseItems[I].btValue[6])+'/'+IntToStr(m_UseItems[I].btValue[7])+'/'+IntToStr(m_UseItems[I].btValue[8])+'/'+
                          IntToStr(m_UseItems[I].btValue[14])+ #9 + '�־úľ�');
                      m_UseItems[I].wIndex := 0;
                    end;
                    RecalcAbilitys();
                    CompareSuitItem(False);//��װ
                  end else m_UseItems[I].Dura := nDura;
                  if tDura <> Round(nDura / 1000 ) then SendMsg(Self, RM_HERODURACHANGE, I, nDura, m_UseItems[I].DuraMax, 0, '');
                  Exit;
                end;
              end;//for K:=
            end;
          end;
        end;
        {$IFEND}          
      end; //if pSItem <> nil then begin
    end; //if UseItems[i].wIndex > 0 then begin
  end; // for i:=Low(UseItems) to High(UseItems) do begin
end;

procedure THeroObject.DoDamageWeapon(nWeaponDamage: Integer);
var
  nDura, nDuraPoint: Integer;
  HeroObject: THeroObject;
begin
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  if (m_UseItems[U_WEAPON].Dura > 0) or g_Config.boItmeAutoOver then begin
    nDura := m_UseItems[U_WEAPON].Dura;
    nDuraPoint := Round(nDura / 1.03);
    Dec(nDura, nWeaponDamage);
    if nDura <= 0 then begin
      nDura := 0;
      m_UseItems[U_WEAPON].Dura := nDura;
      if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
        if m_btRaceServer = RC_HEROOBJECT then begin
          HeroObject := THeroObject(Self);
          HeroObject.SendDelItems(@m_UseItems[U_WEAPON]);
        end;
        m_UseItems[U_WEAPON].wIndex := 0;
      end;
      SendMsg(Self, RM_HERODURACHANGE, U_WEAPON, nDura, m_UseItems[U_WEAPON].DuraMax, 0, '');
    end else begin
      m_UseItems[U_WEAPON].Dura := nDura;
    end;
    if (nDura / 1.03) <> nDuraPoint then begin
      SendMsg(Self, RM_HERODURACHANGE, U_WEAPON, m_UseItems[U_WEAPON].Dura, m_UseItems[U_WEAPON].DuraMax, 0, '');
    end;
  end;
end;
//�ܹ���,����װ�����־�
procedure THeroObject.StruckDamage(nDamage: Integer);
var
  I: Integer;
  nDam: Integer;
  nDura, nOldDura: Integer;
  HeroObject: THeroObject;
  StdItem: pTStdItem;
  bo19: Boolean;
begin
  if nDamage <= 0 then Exit;
  nDam := Random(10) + 5;
  if m_wStatusTimeArr[POISON_DAMAGEARMOR ] > 0 then begin//�ж�
    nDam := Round(nDam * (g_Config.nPosionDamagarmor / 10));
    nDamage := Round(nDamage * (g_Config.nPosionDamagarmor / 10));
  end;
  bo19 := False;
  if (m_UseItems[U_DRESS].wIndex > 0) and ((m_UseItems[U_DRESS].Dura > 0) or g_Config.boItmeAutoOver) then begin//�·�
    nDura := m_UseItems[U_DRESS].Dura;
    nOldDura := Round(nDura / 1000);
    Dec(nDura, nDam);
    if nDura <= 0 then begin
      if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
        if m_btRaceServer = RC_HEROOBJECT then begin
          HeroObject := THeroObject(Self);
          HeroObject.SendDelItems(@m_UseItems[U_DRESS]);
          m_UseItems[U_DRESS].wIndex := 0;
          FeatureChanged();
        end;
        m_UseItems[U_DRESS].wIndex := 0;
      end;
      m_UseItems[U_DRESS].Dura := 0;
      if not g_Config.boItmeAutoOver then SendMsg(Self, RM_HERODURACHANGE, U_DRESS, m_UseItems[U_DRESS].Dura, m_UseItems[U_DRESS].DuraMax, 0, '');
      bo19 := True;
    end else begin
      m_UseItems[U_DRESS].Dura := nDura;
    end;
    if nOldDura <> Round(nDura / 1000) then begin
      SendMsg(Self, RM_HERODURACHANGE, U_DRESS, nDura, m_UseItems[U_DRESS].DuraMax, 0, '');
    end;
  end;
  for I := Low(THumanUseItems) to High(THumanUseItems) do begin
    if (m_UseItems[I].wIndex > 0) and ((m_UseItems[I].Dura > 0) or g_Config.boItmeAutoOver) and (Random(8) = 0) then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[I].wIndex);//20080607
      if (StdItem <> nil) and (((StdItem.StdMode = 2) and (StdItem.AniCount = 21)) or (StdItem.StdMode = 25) or (StdItem.StdMode = 7)) then Continue;//��ף����,����֮����Ʒ������ 20080607
      nDura := m_UseItems[I].Dura;
      nOldDura := Round(nDura / 1000);
      Dec(nDura, nDam);
      if nDura <= 0 then begin
        if g_Config.boItmeAutoOver then begin//20110117 �־�0��Ʒ����ʧ
          if m_btRaceServer = RC_HEROOBJECT then begin
            HeroObject := THeroObject(Self);
            HeroObject.SendDelItems(@m_UseItems[I]);
            m_UseItems[I].wIndex := 0;
            FeatureChanged();
          end;
          m_UseItems[I].wIndex := 0;
        end;
        m_UseItems[I].Dura := 0;
        if not g_Config.boItmeAutoOver then SendMsg(Self, RM_HERODURACHANGE, I, m_UseItems[I].Dura, m_UseItems[I].DuraMax, 0, '');
        bo19 := True;
      end else begin
        m_UseItems[I].Dura := nDura;
      end;
      if nOldDura <> Round(nDura / 1000) then begin
        SendMsg(Self, RM_HERODURACHANGE, I, nDura, m_UseItems[I].DuraMax, 0, '');
      end;
    end;
  end;
  if bo19 then begin
    RecalcAbilitys();
    CompareSuitItem(False);//��װ������װ���Ա� 20080729
  end;
  DamageHealth(nDamage);
end;
//Ӣ������Ʒ
function THeroObject.ClientDropItem(sItemName: string;
  nItemIdx: Integer): Boolean;
var
  I, wIndex, MakeIndex: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sUserItemName: string;
  //sCheckItemName: string;
  nCode: byte;
begin
  Result := False;
  nCode:= 0;
  if m_Master <> nil then begin//20090723
    TPlayObject(m_Master).m_boCanQueryBag:= True;//����Ʒʱ,����ˢ�°��� 20080917
    Try
      try
        {if not TPlayObject(m_Master).m_boClientFlag then begin
          if TPlayObject(m_Master).m_nStep = 8 then Inc(TPlayObject(m_Master).m_nStep)
          else TPlayObject(m_Master).m_nStep := 0;
        end; }
        if g_Config.boInSafeDisableDrop and InSafeZone then begin
          SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropInSafeZoneMsg);
          Exit;
        end;
        nCode:= 1;
        if not m_boCanDrop then begin
          SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, g_sCanotDropItemMsg);
          Exit;
        end;
        nCode:= 2;
        if Pos(' ', sItemName) > 0 then begin //�۷���Ʒ����(�ż���Ʒ�����ƺ������ʹ�ô���)
          GetValidStr3(sItemName, sItemName, [' ']);
        end;
        nCode:= 3;
        for I := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then Break;
          nCode:= 4;
          UserItem := m_ItemList.Items[I];
          if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
            if (UserItem.AddValue[0] = 1) and (GetHoursCount(UserItem.MaxDate, Now) <= 0) then begin //ɾ������װ��
              m_ItemList.Delete(I);
              Dispose(UserItem);
              Result := True;
              Break;
            end;
            if UserItem.AddValue[0] in [2..3] then Break;//����Ʒ������
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            nCode:= 5;
            if StdItem = nil then Continue;
              //sItem:=UserEngine.GetStdItemName(UserItem.wIndex);
              //ȡ�Զ�����Ʒ����
            sUserItemName := '';
            if UserItem.btValue[13] = 1 then
              sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
            if sUserItemName = '' then
              sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

            if CompareText(sUserItemName, sItemName) = 0 then begin
              nCode:= 6;
              if CheckItemValue(UserItem ,0) then Break;//�����Ʒ�Ƿ��ֹ�� 20080314
              nCode:= 7;
             { if Assigned(zPlugOfEngine.CheckCanDropItem) then begin
                nCode:= 8;
                sCheckItemName := StdItem.Name;
                if not zPlugOfEngine.CheckCanDropItem(Self, PChar(sCheckItemName)) then Break;
              end; }
              if PlugOfCheckCanItem(0, StdItem.Name, False, 0, 0) then Break;//��ֹ��Ʒ����(����������) 20080729
              nCode:= 9;
              wIndex:= UserItem.wIndex;//20080901
              MakeIndex:= UserItem.MakeIndex;//20080901
              if g_Config.boControlDropItem and (StdItem.Price < g_Config.nCanDropPrice) then begin
                nCode:= 10;
                m_ItemList.Delete(I);
                ClearCopyItem(wIndex, MakeIndex);//20080901 ������Ʒ
                Dispose(UserItem);
                Result := True;
                Break;
              end;
              nCode:= 11;
              if TPlayObject(m_Master).m_boHeroLogOut then Exit;//Ӣ���˳�,��ʧ��(��ֹˢ��Ʒ) 20080923
              if DropItemDown(UserItem, 3, False, False, nil, m_Master) then begin
                nCode:= 12;
                m_ItemList.Delete(I);
                ClearCopyItem(wIndex, MakeIndex);//20080901 ������Ʒ
                Dispose(UserItem);
                Result := True;
                Break;
              end;
            end;
          end;
        end;//for
        if Result then WeightChanged();
      except
        MainOutMessage(Format('{%s} THeroObject.ClientDropItem Code:%d',[g_sExceptionVer, nCode]));
      end;
    finally
      TPlayObject(m_Master).m_boCanQueryBag:= False;//����Ʒʱ,����ˢ�°��� 20080917
    end;
  end;
end;
//ȫ���޸�,��Ҫ�ĳ־�ֵ 20080325
Function THeroObject.RepairAllItemDura:Integer;
var
  nWhere: Integer;
//sCheckItemName: string;
  StdItem: pTStdItem;
begin
  Result:= 0;
  for nWhere := Low(THumanUseItems) to High(THumanUseItems) do begin
    if m_UseItems[nWhere].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[nWhere].wIndex);
      if StdItem <> nil then begin
        if ((m_UseItems[nWhere].DuraMax div 1000)> (m_UseItems[nWhere].Dura div 1000)) and (StdItem.StdMode<>7) and (StdItem.StdMode<>25) and (StdItem.StdMode<>43) and (StdItem.AniCount<>21) then begin
          if CheckItemValue(@m_UseItems[nWhere], 3) then Continue //20080314 ��ֹ��
          else
         { if Assigned(zPlugOfEngine.CheckCanRepairItem) then begin
            sCheckItemName := StdItem.Name;
            if not zPlugOfEngine.CheckCanRepairItem(m_Master, PChar(sCheckItemName)) then Continue;//����Ƿ��ǲ����޸�����Ʒ
          end;}
          if PlugOfCheckCanItem(3, StdItem.Name, False, 0, 0) then Continue;//��ֹ��Ʒ����(����������) 20080729

          Inc(Result,(m_UseItems[nWhere].DuraMax - m_UseItems[nWhere].Dura));
        end;
      end;
    end;
  end;
end;
//�ٻ�ǿ����,���г��ı������7��  20080329
function THeroObject.CallMobeItem(): Boolean;
var
  I: Integer;
  Slave: TBaseObject;
begin
  Result:= False;
  if m_SlaveList.Count= 0 then begin
    SysMsg('��û���ٻ�����,����ʹ�ô���Ʒ!',  c_Red, t_Hint);
    Exit;
  end;
  
  if m_SlaveList.Count > 0 then begin//20080630
    for I := 0 to m_SlaveList.Count - 1 do begin
      Slave := TBaseObject(m_SlaveList.Items[I]);
      if (Slave.m_btRaceServer = RC_PLAYMOSTER) or (Slave.m_btRaceServer in [99, 132,133,154,158]) then Continue;//�ٻ���ħ,ʥ��,����,����,�����ܵ���
      if Slave.m_btSlaveExpLevel < 7 then begin //20080323
        Slave.m_btSlaveExpLevel:= 7;
        Slave.RecalcAbilitys;//20080328 �ı�ȼ�,ˢ������
        Slave.RefNameColor;//20080408
        Slave.SendRefMsg(RM_MYSHOW, ET_OBJECTLEVELUP,0, 0, 0, ''); //������������  20080328
        Result:= True;
        SysMsg('�����ص�����Ӱ���£����ĳ���:'+FilterShowName(Slave.m_sCharName)+' �ɳ�Ϊ7��', BB_Fuchsia, t_Hint);//20090402 ����FilterShowName()
        Break;
      end;
    end;
  end;
end;
//ȫ���޸�
procedure THeroObject.RepairAllItem(DureCount: Integer; boDec: Boolean);
var
  nWhere,RepCount: Integer;
//  sCheckItemName: string;
  StdItem: pTStdItem;
begin
  for nWhere := Low(THumanUseItems) to High(THumanUseItems) do begin
    if m_UseItems[nWhere].wIndex > 0 then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[nWhere].wIndex);
      if StdItem <> nil then begin
        if ((m_UseItems[nWhere].DuraMax div 1000) > (m_UseItems[nWhere].Dura div 1000)) and (StdItem.StdMode<>7) and (StdItem.StdMode<>25) and (StdItem.StdMode<>43) and (StdItem.AniCount<>21) then begin
          if CheckItemValue(@m_UseItems[nWhere], 3) then Continue //20080314 ��ֹ��
          else
          {if Assigned(zPlugOfEngine.CheckCanRepairItem) then begin
            sCheckItemName := StdItem.Name;
            if not zPlugOfEngine.CheckCanRepairItem(m_Master, PChar(sCheckItemName)) then Continue;
          end;}
          if PlugOfCheckCanItem(3, StdItem.Name, False, 0, 0) then Continue;//��ֹ��Ʒ����(����������) 20080729

          if not boDec then begin//�޸��㹻,��ֱ���޸�������
            if (m_UseItems[nWhere].DuraMax div 1000) - (m_UseItems[nWhere].Dura div 1000) > 0 then
               SysMsg(StdItem.Name+'�޲��ɹ���', BB_Fuchsia, t_Hint); //20071229
            m_UseItems[nWhere].Dura := m_UseItems[nWhere].DuraMax;
            SendMsg(Self, RM_HERODURACHANGE, nWhere, m_UseItems[nWhere].Dura, m_UseItems[nWhere].DuraMax, 0, '');
          end else begin
            RepCount:= (m_UseItems[nWhere].DuraMax div 1000) - (m_UseItems[nWhere].Dura div 1000);
            if DureCount >= RepCount then begin
              Dec(DureCount,RepCount);
              if (m_UseItems[nWhere].DuraMax div 1000) - (m_UseItems[nWhere].Dura div 1000) > 0 then
                 SysMsg(StdItem.Name+'�޲��ɹ���', c_Green, t_Hint); //20071229
              m_UseItems[nWhere].Dura := m_UseItems[nWhere].DuraMax;
              SendMsg(Self, RM_HERODURACHANGE, nWhere, m_UseItems[nWhere].Dura, m_UseItems[nWhere].DuraMax, 0, '');//20071229
            end else
            if DureCount > 0 then begin
               DureCount:= 0;
               m_UseItems[nWhere].Dura :=m_UseItems[nWhere].Dura + DureCount * 1000;
               SendMsg(Self, RM_HERODURACHANGE, nWhere, m_UseItems[nWhere].Dura, m_UseItems[nWhere].DuraMax, 0, '');//20071229
               Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;
//�ͻ���Ӣ�۰�����ʹ����Ʒ
procedure THeroObject.ClientHeroUseItems(nItemIdx: Integer; sItemName: string; boType: Boolean{�Ƿ�����};nType: Byte);
  function GetUnbindItemName(nShape: Integer): string;
  var
    I: Integer;
  begin
    Result := '';
    if g_UnbindList.Count > 0 then begin//20080630
      for I := 0 to g_UnbindList.Count - 1 do begin
        if Integer(g_UnbindList.Objects[I]) = nShape then begin
          Result := g_UnbindList.Strings[I];
          Break;
        end;
      end;
    end;
  end;
  function GetUnBindItems(sItemName: string; nCount: Integer): Boolean;
  var
    I: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    if nCount <=0 then nCount:=1;//20080630
    for I := 0 to nCount - 1 do begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
        m_ItemList.Add(UserItem);
        //if m_btRaceServer = RC_PLAYOBJECT then
        SendAddItem(UserItem);
        Result := True;
      end else begin
        Dispose(UserItem);
        Break;
      end;
    end;
  end;
  function FoundUserItem(Item: pTUserItem): Boolean;
  var
    I: Integer;
    UserItem: pTUserItem;
  begin
    Result := False;
    if m_ItemList.Count > 0 then begin//20080628
      for I := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[I];
        if UserItem = Item then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
var
  I, ItemCount: Integer;
  boEatOK: Boolean;
  boSendUpDate: Boolean;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  UserItem34: TUserItem;
  nCode: Byte;//20090205
  dwExp: LongWord;
begin
  if m_Master = nil then Exit;//20090221 ����
  if m_Master.m_boGhost then Exit;//20090325 ����
  TPlayObject(m_Master).m_boCanQueryBag:= True;//ʹ����Ʒʱ,����ˢ�°��� 20080917
  nCode:= 0;
  Try
    try
      boEatOK := False;
      boSendUpDate := False;
      StdItem := nil;
      if m_boCanUseItem then begin
        if not m_boDeath then begin
          for I := m_ItemList.Count - 1 downto 0 do begin
            if m_ItemList.Count <= 0 then Break;
            UserItem := m_ItemList.Items[I];
            nCode:= 1;
            if UserItem = nil then Continue;//20090205
            if (UserItem <> nil) and (UserItem.MakeIndex = nItemIdx) then begin
              UserItem34 := UserItem^;
              nCode:= 2;
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem <> nil then begin
                if not m_PEnvir.AllowStdItems(UserItem.wIndex) then begin
                  SysMsg(Format_ToStr(g_sCanotMapUseItemMsg, [StdItem.Name]), BB_Fuchsia, t_Hint);
                  Break;
                end;
                nCode:= 4;
                if PlugOfCheckCanItem(8, StdItem.Name, False, 0, 0) then Break;//��ֹ��Ʒ����(����������) 20080729
                nCode:= 5;
                case StdItem.StdMode of
                  {0: begin
                      if EatItems(StdItem, boType, nType) then begin
                        nCode:= 1;
                        if UserItem <> nil then begin
                          if StdItem.Reserved = 255 then begin//ҩƷ�ƴ� 20100927
                            if UserItem.Dura > 0 then begin
                              Dec(UserItem.Dura);
                              boEatOK := True;
                            end;
                            if UserItem.Dura > 0 then begin
                              boSendUpDate := True;
                              boEatOK := False;
                            end else begin
                              m_ItemList.Delete(I);
                              DisPoseAndNil(UserItem);
                              boEatOK := True;
                            end;
                          end else begin
                            m_ItemList.Delete(I);
                            DisPoseAndNil(UserItem);
                            boEatOK := True;
                          end;
                        end;
                      end;
                   end;}
                  0, 1, 3: begin //ҩ
                      nCode:= 6;
                      if EatItems(StdItem, boType, nType) then begin
                        if UserItem <> nil then begin
                          m_ItemList.Delete(I);
                          //DisPoseAndNil(UserItem);
                          DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:21:56
                          UserItem := nil;
                        end;
                        boEatOK := True;
                      end;
                      Break;
                    end;
                  2: begin
                      nCode:= 7;
                      if StdItem.AniCount= 21 then begin //ף���� ���͵���Ʒ  20080315
                        if StdItem.Reserved <> 56 then begin
                          if UserItem.Dura > 0 then begin
                            if (m_ItemList.Count {-}+ 1) <= {MAXBAGITEM}MAXHEROBAGITEM then begin//20090313 �޸�
                              if UserItem.Dura >= 1000 then begin //�޸�Ϊ1000,20071229
                                Dec(UserItem.Dura, 1000);
                                Dec(UserItem.DuraMax, 1000);//20080324 ���ٴ���Ʒ����
                              end else begin
                                UserItem.Dura := 0;
                                UserItem.DuraMax:= 0;//20080324 ���ٴ���Ʒ����
                              end;
                              //��Ҫ�޸�UnbindList.txt,���� 3 ף����  20071229  3---Ϊ ף���޵����ֵ
                              GetUnBindItems(GetUnbindItemName(StdItem.Shape), 1); //��һ��ף����  20080310
                              if UserItem.DuraMax = 0 then begin //20080324 ���ܴ�ȡ��Ʒ,��ɾ����Ʒ
                                if UserItem <> nil then begin
                                  m_ItemList.Delete(I);
                                  //DisPoseAndNil(UserItem);
                                  DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:21:56
                                  UserItem := nil;
                                end;
                                boEatOK := True;
                              end;
                            end;
                          end;
                        end else begin//Ȫˮ��
                          if (UserItem.Dura >= 1000) and (StdItem.Reserved = 56) then begin//20090313 �޸�
                            if (m_ItemList.Count {-}+ 1) <= {MAXBAGITEM}MAXHEROBAGITEM then begin//20090313 �޸�
                              if UserItem.Dura >= 1000 then begin
                                Dec(UserItem.Dura, 1000);
                                //Dec(UserItem.DuraMax, 1000);//20080324 ���ٴ���Ʒ����
                              end else begin
                                UserItem.Dura := 0;
                                //UserItem.DuraMax:= 0;//20080324 ���ٴ���Ʒ����
                              end;
                              //��Ҫ�޸�UnbindList.txt,���� 1 Ȫˮ    1---Ϊ Ȫˮ�����ֵ
                              GetUnBindItems(GetUnbindItemName(StdItem.Shape), 1); //��һ��Ȫˮ  20080310
                             { if UserItem.DuraMax = 0 then begin //20080324 ���ܴ�ȡ��Ʒ,��ɾ����Ʒ
                                 m_ItemList.Delete(I);
                                 DisPoseAndNil(UserItem);
                                 boEatOK := True;
                              end;}
                            end;
                          end;
                        end;
                         boSendUpDate := True;
                      end else
                  
                      case StdItem.Shape of
                        1: begin //�ٻ�ǿ���� 20080329
                            nCode:= 13;
                            if UserItem.Dura > 0 then begin
                              if UserItem.Dura >= 1000 then begin
                                 if CallMobeItem() then begin //�ٻ�ǿ����,���г��ı������7��  20080221
                                   Dec(UserItem.Dura, 1000);
                                   boEatOK := True;
                                 end;
                              end else begin
                               UserItem.Dura := 0;
                              end;
                            end;
                            if UserItem.Dura > 0 then begin
                              boSendUpDate := True;
                              boEatOK := False;
                            end else begin
                              if UserItem <> nil then begin
                                UserItem.wIndex:= 0;//20081014
                                m_ItemList.Delete(I);
                                //DisPoseAndNil(UserItem);
                                DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                UserItem := nil;
                              end;
                            end;
                         end;
                        9: begin //ԭֵΪ1,20071229 //�޸���ˮ
                            nCode:= 14;
                            ItemCount:= RepairAllItemDura;
                            if (UserItem.Dura > 0) and (ItemCount > 0) then begin
                              if UserItem.Dura >= (ItemCount div 10){100} then begin//20080325
                                Dec(UserItem.Dura, (ItemCount div 10){100});
                                RepairAllItem(ItemCount div 1000, False);
                                if UserItem.Dura < 100 then UserItem.Dura:= 0;
                              end else begin
                                UserItem.Dura:= 0;
                                RepairAllItem(ItemCount div 1000, True);
                              end;
                            end;
                            boEatOK := False;
                            if UserItem.Dura > 0 then begin
                              boSendUpDate := True;
                            end else begin
                              if UserItem <> nil then begin
                                m_ItemList.Delete(I);
                                //DisPoseAndNil(UserItem);
                                DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                UserItem := nil;
                              end;
                              boEatOK := True;
                            end;
                          end;
                       end;//Case
                    end;
                  4: begin //��
                      nCode:= 8;
                      if ReadBook(StdItem) then begin
                        if UserItem <> nil then begin
                          m_ItemList.Delete(I);
                          //DisPoseAndNil(UserItem);
                          DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                          UserItem := nil;
                        end;
                        boEatOK := True;
                      end;
                    end;
                  17: begin//������Ʒ 20100121
                      if (UserItem.Dura > 0) then begin
                        case StdItem.Shape of
                          237: begin//������ҩƷ 20110526
                            if EatItems(StdItem, boType, nType) then begin
                              Dec(UserItem.Dura);
                              if UserItem.Dura > 0 then begin
                                boSendUpDate := True;
                                boEatOK := False;
                              end else begin
                                if UserItem <> nil then begin
                                  m_ItemList.Delete(I);
                                  //DisPoseAndNil(UserItem);
                                  DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                  UserItem := nil;
                                end;
                                boEatOK := True;
                              end;
                            end;
                          end;
                          {$IF M2Version = 1}
                          253..255: begin
                            if (StdItem.AniCount > 0) and m_boTrainingNG and m_boOpenHumanPulseArr
                              and m_wHumanPulseArr[0].boOpenPulse then begin//Ӣ�۾�����
                              GetPulsExp(StdItem.AniCount * 1000, 1);//ȡ��Ӣ�۾��羭��
                              Dec(UserItem.Dura);
                              if UserItem.Dura > 0 then begin
                                boSendUpDate := True;
                              end else begin
                                if UserItem <> nil then begin
                                  m_ItemList.Delete(I);
                                  //DisPoseAndNil(UserItem);
                                  DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                  UserItem := nil;
                                end;
                                boEatOK := True;
                              end;
                            end;
                          end;
                          {$IFEND}
                        end;//case
                      end;
                    end;
                  31: begin //�����Ʒ
                      nCode:= 9;
                      case StdItem.AniCount of
                        0..3:begin
                          nCode:= 11;
                          if (m_ItemList.Count + 6 - 1) <= m_nItemBagCount then begin
                            if UserItem <> nil then begin
                              m_ItemList.Delete(I);
                              //DisPoseAndNil(UserItem);
                              DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                              UserItem := nil;
                            end;
                            GetUnBindItems(GetUnbindItemName(StdItem.Shape), 6);
                            boEatOK := True;
                          end;
                        end;//0..3
                        4..255:begin//20080728 ����
                          nCode:= 12;
                          case StdItem.Shape of
                            0: begin
                                if FoundUserItem(UserItem) then begin//20080819 �Ȳ�����Ʒ��ɾ����Ʒ���ٴ���
                                  if UserItem <> nil then begin
                                    m_ItemList.Delete(I);
                                    //DisPoseAndNil(UserItem);
                                    DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                    UserItem := nil;
                                    UseStdmodeFunItem(StdItem);//ʹ����Ʒ�����ű���
                                  end;
                                  boEatOK := True;
                                end;                            
                              end;
                           { 1: begin
                                if ItemDblClick(StdItem.Name, UserItem.MakeIndex, sMapName, nCurrX, nCurrY) then begin
                                  m_ItemList.Delete(I);
                                  DisPoseAndNil(UserItem);
                                  SpaceMove(sMapName, nCurrX, nCurrY, 0);
                                  boEatOK := True;
                                end else begin
                                  SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(Self), 0, 0, '��ǰ��ͼ���걣��ɹ�������\�ٴ�˫���������͵�\��ͼ��' + m_sMapName + ' ���꣺' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY));
                                end;
                              end; }
                          end; //case StdItem.Shape of
                        end;//4..255
                      end;//Case
                     { 20071231 �޸ĳ��������
                     if StdItem.AniCount = 0 then begin
                        if (m_ItemList.Count + 6 - 1) <= m_nItemBagCount then begin
                          m_ItemList.Delete(I);
                          DisPoseAndNil(UserItem);
                          GetUnBindItems(GetUnbindItemName(StdItem.Shape), 6);
                          boEatOK := True;
                        end;
                      end;   }
                    end;//31
                  51: begin
                      case StdItem.Shape of
                        2: begin//Ӣ�۾�����
                          if (UserItem.btValue[12] = 2) then begin //Ӣ�۾�����,�ۼ����˾���,�ſ�ʹ��
                            if m_Abil.Level < g_Config.nLimitExpLevelHero then begin//20110116 ����
                              if ((m_Abil.Level >= StdItem.NeedLevel) and (StdItem.Need = 0)) or ((m_Abil.Level <= StdItem.NeedLevel) and (StdItem.Need = 1)) then begin//���Ƶȼ�ʹ��
                                dwExp:= UserItem.Dura * 10000;
                                GetExp(dwExp, 0);
                                if UserItem <> nil then begin
                                  m_ItemList.Delete(I);
                                  //DisPoseAndNil(UserItem);
                                  DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                  UserItem := nil;
                                end;
                                boEatOK := True;
                              end else begin
                                if (StdItem.Need = 0) then SysMsg('(Ӣ��)�ȼ���ﵽ��'+IntToStr(StdItem.NeedLevel)+'����ſ���ʹ�ã�',c_Red,t_Hint);
                                if (StdItem.Need = 1) then SysMsg('(Ӣ��)�ȼ�������'+IntToStr(StdItem.NeedLevel)+'��������ʹ�ã�',c_Red,t_Hint);
                              end;
                            end else SysMsg('(Ӣ��)�ȼ��Ѵﵽ���ޣ�'+IntToStr(g_Config.nLimitExpLevelHero)+'��������ʹ�ã�',c_Red,t_Hint);
                          end;
                        end;//2
                        3: begin//����������
                          if ((m_Abil.Level >= StdItem.NeedLevel) and (StdItem.Need = 0))
                            or ((m_Abil.Level <= StdItem.NeedLevel) and (StdItem.Need = 1)) then begin//���Ƶȼ�ʹ��
                            if StdItem.AniCount > 0 then begin//��ҪԪ������ʹ��
                              if (m_Master <> nil) then begin
                                if TPlayObject(m_Master).m_nGameGold >= StdItem.AniCount then begin
                                  TPlayObject(m_Master).DecGameGold(StdItem.AniCount);//�ȼ�Ԫ��ֵ
                                  TPlayObject(m_Master).GameGoldChanged;
                                  if g_boGameLogGameGold then
                                    AddGameDataLog(Format(g_sGameLogMsg1, [LOG_GAMEGOLD, m_Master.m_sMapName,
                                        m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master.m_sCharName, g_Config.sGameGoldName,
                                        TPlayObject(m_Master).m_nGameGold, '-('+inttostr(StdItem.AniCount)+')', 'ʹ������']));
                                  dwExp:= UserItem.Dura * 10000;
                                  if StdItem.Reserved = 255 then begin//���õȼ����Ʒ��� 20110515
                                    if m_Abil.Level >= 1000 then begin
                                      dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[1000] / 100));
                                      if dwExp <= 0 then dwExp:= 1;
                                    end else begin
                                      dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[m_Abil.Level] / 100));
                                      if dwExp <= 0 then dwExp:= 1;
                                    end;
                                  end;
                                  GetExp(dwExp, 1);
                                  if UserItem <> nil then begin
                                    m_ItemList.Delete(I);
                                    //DisPoseAndNil(UserItem);
                                    DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                    UserItem := nil;
                                  end;
                                  boEatOK := True;
                                end else SysMsg(Format('��%s���㣺%d������ʹ�ã�',[g_Config.sGameGoldName,StdItem.AniCount ]),c_Red,t_Hint);
                              end;
                            end else begin
                              dwExp:= UserItem.Dura * 10000;
                              if StdItem.Reserved = 255 then begin//���õȼ����Ʒ��� 20110515
                                if m_Abil.Level >= 1000 then begin
                                  dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[1000] / 100));
                                  if dwExp <= 0 then dwExp:= 1;
                                end else begin
                                  dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[m_Abil.Level] / 100));
                                  if dwExp <= 0 then dwExp:= 1;
                                end;
                              end;
                              GetExp(dwExp, 1);
                              if UserItem <> nil then begin
                                m_ItemList.Delete(I);
                                //DisPoseAndNil(UserItem);
                                DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                UserItem := nil;
                              end;
                              boEatOK := True;
                            end;
                          end else begin
                            if (StdItem.Need = 0) then SysMsg('(Ӣ��)�ȼ���ﵽ��'+IntToStr(StdItem.NeedLevel)+'����ſ���ʹ�ã�',c_Red,t_Hint);
                            if (StdItem.Need = 1) then SysMsg('(Ӣ��)�ȼ�������'+IntToStr(StdItem.NeedLevel)+'��������ʹ�ã�',c_Red,t_Hint);
                          end;
                        end;
                      end;
                    end;//51  
                  60:begin//���� 20080622
                      nCode:= 10;
                      if StdItem.Shape <> 0 then begin//���վ���,����ֵ�ﵽҪ��
                         if not n_DrinkWineDrunk then begin
                          if m_Abil.MaxAlcohol >= StdItem.Need then begin//����ֵ�ﵽҪ��
                            if UserItem.Dura > 0 then begin
                              case StdItem.Anicount of//��ͨ����ҩ��������
                                1: begin//��ͨ��
                                  if UserItem.Dura >= 1000 then begin
                                    Dec(UserItem.Dura, 1000);
                                  end else begin
                                    UserItem.Dura := 0;
                                  end;
                                  {$IF M2Version = 1}
                                  dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;
                                  {$IFEND}
                                  SendRefMsg(RM_MYSHOW, 7, 0, 0, 0, ''); //�Ⱦ�������  20080623
                                  if m_Abil.WineDrinkValue = 0 then begin//�����ƶ�Ϊ0,���ʼʱ����
                                    m_dwDecWineDrinkValueTick:= GetTickCount();
                                    m_dwAddAlcoholTick := GetTickCount();
                                  end;
                                  Inc(m_Abil.WineDrinkValue, (UserItem.btValue[1] * m_Abil.MaxAlcohol div 200));//������ƶ� 20080623
                                  n_DrinkWineAlcohol:= UserItem.btValue[1];//����ʱ�ƵĶ��� 20080624
                                  n_DrinkWineQuality:= UserItem.btValue[0];//����ʱ�Ƶ�Ʒ�� 20080623
                                  if m_Abil.WineDrinkValue >= m_Abil.MaxAlcohol then begin//��ƶȳ�������,��������
                                     m_Abil.WineDrinkValue:=  m_Abil.MaxAlcohol;
                                     n_DrinkWineDrunk:= True;//�Ⱦ����� 20080623
                                     SysMsg('(Ӣ��)�Ծ�ͷ�β���,����Ϊ����ϵ,�κ���ȥ����,������������!',c_Red,t_Hint);
                                     SendRefMsg(RM_MYSHOW, 9 ,0, 0, 0, ''); //����������  20080623
                                  end;
                                  //��ͨ��,Ʒ��2����,25%���ʼ���ʱ���� 20080713
                                  if (n_DrinkWineQuality > 2) and (Random(4)=0) and (not n_DrinkWineDrunk) then begin
                                    Case Random(2) of
                                      0: DefenceUp(300);//���ӷ�����300��
                                      1: MagDefenceUp(300);//����ħ��300��
                                    end;
                                    if m_Abil.WineDrinkValue > Round(m_Abil.MaxAlcohol * 0.5) then
                                      SysMsg('(Ӣ��)������ħ���������������ǿ��', c_Blue, t_Hint)
                                    else SysMsg('(Ӣ��)������ħ������������ǿ��', c_Blue, t_Hint);
                                  end;
                                  RecalcAbilitys();
                                  CompareSuitItem(False);//��װ������װ���Ա� 20080729
                                  SendMsg(Self, RM_HEROABILITY, 0, 0, 0, 0, '');
                                  boEatOK := True;
                                end;
                                2: begin//ҩ��
                                  if not m_boDrinkDrugHotels then begin//ҩ�Ʋ���ͬʱʹ��
                                    if UserItem.Dura >= 1000 then begin
                                      Dec(UserItem.Dura, 1000);
                                    end else begin
                                      UserItem.Dura := 0;
                                    end;
                                    {$IF M2Version = 1}
                                    dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;
                                    {$IFEND}
                                    SendRefMsg(RM_MYSHOW, 7, 0, 0, 0, ''); //�Ⱦ�������  20080623
                                    if m_Abil.WineDrinkValue = 0 then begin//�����ƶ�Ϊ0,���ʼʱ����
                                      m_dwDecWineDrinkValueTick:= GetTickCount();
                                      m_dwAddAlcoholTick := GetTickCount();
                                    end;
                                    Inc(m_Abil.WineDrinkValue, (UserItem.btValue[1] * m_Abil.MaxAlcohol div 200));//������ƶ� 20080623
                                    n_DrinkWineAlcohol:= UserItem.btValue[1];//����ʱ�ƵĶ��� 20080624
                                    n_DrinkWineQuality:= UserItem.btValue[0];//����ʱ�Ƶ�Ʒ�� 20080623
                                    if m_Abil.WineDrinkValue >= m_Abil.MaxAlcohol then begin//��ƶȳ�������,��������
                                       m_Abil.WineDrinkValue:=  m_Abil.MaxAlcohol;
                                       n_DrinkWineDrunk:= True;//�Ⱦ����� 20080623
                                       SysMsg('(Ӣ��)�Ծ�ͷ�β���,����Ϊ����ϵ,�κ���ȥ����,������������!',c_Red,t_Hint);
                                       SendRefMsg(RM_MYSHOW, 9 ,0, 0, 0, ''); //����������  20080623
                                    end;
                                    if (not n_DrinkWineDrunk) then begin//ҩ�ƿ�����ҩ��ֵ
                                      if n_DrinkWineQuality > 4 then begin//Ʒ��Ϊ4����,ҩ��������ʱ���� 20080626
                                        m_boDrinkDrugHotels:= True;
                                        case StdItem.Shape of
                                          8:begin//���Ǿ� ���ӹ�������,ħ�����޻��������4��,Ч������600��
                                              Case m_btJob of
                                                0:begin
                                                   m_wStatusArrValue[0]:= 4;
                                                   m_dwStatusArrTimeOutTick[0]:= GetTickCount + 600000{600 * 1000};
                                                   SysMsg('(Ӣ��)���Ǿ�ʹ������������600��', c_Green, t_Hint);
                                                   SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                                end;
                                                1:begin
                                                   m_wStatusArrValue[1]:= 4;
                                                   m_dwStatusArrTimeOutTick[1]:= GetTickCount + 600000{600 * 1000};
                                                   SysMsg('(Ӣ��)���Ǿ�ʹħ����������600��', c_Green, t_Hint);
                                                   SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                                end;
                                                2:begin
                                                   m_wStatusArrValue[14]:= 4;
                                                   m_dwStatusArrTimeOutTick[14]:= GetTickCount + 600000{600 * 1000};
                                                   SysMsg('(Ӣ��)���Ǿ�ʹ������������600��', c_Green, t_Hint);
                                                   SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                                end;
                                              end;
                                           end;
                                          9:begin//�𲭾�  ��������ֵ����150��,Ч������600��
                                             m_wStatusArrValue[4]:= 150;
                                             m_dwStatusArrTimeOutTick[4]:= GetTickCount + 600000{600 * 1000};
                                             SysMsg('(Ӣ��)�𲭾�ʹ������������600��', c_Green, t_Hint);
                                             SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          10:begin//������  ��������4��,Ч������600��
                                             m_wStatusArrValue[11]:= 4;
                                             m_dwStatusArrTimeOutTick[11]:= GetTickCount + 600000{600 * 1000};
                                             SysMsg('(Ӣ��)������ʹ��������600��', c_Green, t_Hint);
                                             SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          11:begin//���ξ�  ���ӷ�������,ħ����������,Ч������600�� 20091209
                                             m_wStatusArrValue[12]:= 5;
                                             m_dwStatusArrTimeOutTick[12]:= GetTickCount + 600000;
                                             m_wStatusArrValue[13]:= 5;
                                             m_dwStatusArrTimeOutTick[13]:= GetTickCount + 600000;
                                             SysMsg('(Ӣ��)���ξ�ʹ������ħ����������600��', c_Green, t_Hint);
                                             SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          12:begin//�ߵ���  ����ħ��ֵ����400��,Ч������600��
                                             m_wStatusArrValue[5]:= 400;
                                             m_dwStatusArrTimeOutTick[5]:= GetTickCount + 600000{600 * 1000};
                                             SysMsg('(Ӣ��)�ߵ���ʹħ����������600��', c_Green, t_Hint);
                                             SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          13:begin//��˴�,�����˺�����20��,����600��
                                            m_wStatusArrValue[15]:= 20;
                                            m_dwStatusArrTimeOutTick[15]:= GetTickCount + 600000;
                                            SysMsg('(Ӣ��)��˴�ʹ�����˺�����600��', c_Green, t_Hint);
                                            SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          14:begin//����������,�����ָ��ٶ�����10��,����600��
                                            m_wStatusArrValue[16]:= 10;
                                            m_dwStatusArrTimeOutTick[16]:= GetTickCount + 600000;
                                            SysMsg('(Ӣ��)����������ʹ�����ָ��ٶ�����600��', c_Green, t_Hint);
                                            SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          {$IF M2Version <> 2}
                                          15:begin//���������,����˲��ָ�1000��,ÿ10����ֻ������1ƿ
                                            m_wStatusArrValue[17]:= 1000;
                                            m_dwStatusArrTimeOutTick[17]:= GetTickCount + 600000;
                                            m_Skill69NH:= _MIN(m_Skill69MaxNH, m_Skill69NH + 1000);//
                                            SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
                                            SysMsg('(Ӣ��)���������ʹ����˲��ָ�1000��', c_Green, t_Hint);
                                            SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          {$IF M2Version = 1}
                                          16:begin//��Ԫ�� 10�����ڣ���ת����ֵ����200��
                                            m_wStatusArrValue[18]:= 200;
                                            m_dwStatusArrTimeOutTick[18]:= GetTickCount + 600000;
                                            SysMsg('(Ӣ��)��Ԫ��ʹ��ת��������ֵ����600��', c_Green, t_Hint);
                                            SysMsg('(Ӣ��)ҩ�Ƶ�ҩ���������ڳ�������', c_Green, t_Hint);
                                          end;
                                          {$IFEND}
                                          {$IFEND}
                                        end;
                                      end;
                                      dw_UseMedicineTime:= g_Config.nDesMedicineTick;//ʼ��ʹ��ҩ��ʱ��(12Сʱ)
                                      Inc(m_Abil.MedicineValue,UserItem.btValue[2]);//����ҩ��ֵ
                                      if m_Abil.MedicineValue >= m_Abil.MaxMedicineValue then begin//��ǰҩ��ֵ�ﵽ��ǰ�ȼ�����ʱ
                                         Dec(m_Abil.MedicineValue, m_Abil.MaxMedicineValue);
                                         Case (n_MedicineLevel mod 6) of//������������
                                           0:begin//����/ħ��/��������(��ְҵ)
                                              Case m_btJob of
                                                0: m_Abil.DC := MakeLong(m_Abil.DC, m_Abil.DC+1);
                                                1: m_Abil.MC := MakeLong(m_Abil.MC, m_Abil.MC+1);
                                                2: m_Abil.SC := MakeLong(m_Abil.SC, m_Abil.SC+1);
                                              end;
                                           end;
                                           1: m_Abil.MAC := MakeLong(m_Abil.MAC+1, m_Abil.MAC);//��ħ������
                                           2: m_Abil.AC := MakeLong(m_Abil.AC+1, m_Abil.AC);//�ӷ�������
                                           3:begin//����/ħ��/��������(��ְҵ)
                                              Case m_btJob of
                                                0: m_Abil.DC := MakeLong(m_Abil.DC+1, m_Abil.DC);
                                                1: m_Abil.MC := MakeLong(m_Abil.MC+1, m_Abil.MC);
                                                2: m_Abil.SC := MakeLong(m_Abil.SC+1, m_Abil.SC);
                                              end;
                                           end;
                                           4: m_Abil.MAC := MakeLong(m_Abil.MAC, m_Abil.MAC+1);//ħ������
                                           5: m_Abil.AC := MakeLong(m_Abil.AC, m_Abil.AC+1);//��������
                                         end;//Case (n_MedicineLevel mod 6) of
                                         if n_MedicineLevel < MAXUPLEVEL then Inc(n_MedicineLevel);//���ӵȼ�
                                         m_Abil.MaxMedicineValue := GetMedicineExp(n_MedicineLevel);//ȡ������ĵȼ���Ӧ��ҩ��ֵ
                                         SysMsg('(Ӣ��)�ƾ�����������,�о�����״̬�����ı�', c_Green,t_Hint);//��ʾ�û�
                                      end;
                                    end;//if StdItem.Anicount = 2 then begin//ҩ�ƿ�����ҩ��ֵ
                                    RecalcAbilitys();
                                    CompareSuitItem(False);//��װ������װ���Ա� 20080729
                                    SendMsg(Self, RM_HEROABILITY, 0, 0, 0, 0, '');
                                    boEatOK := True;
                                    {$IF M2Version <> 2}
                                    if m_wStatusArrValue[16] = 10 then SendNGResume();//�����ڹ����⣬�˺����ָ��ٶ�����
                                    {$IFEND}
                                  end else SysMsg('(Ӣ��)�ոպ��µ�ҩ�ƾ��Ի�û�����������ܺ�������ҩ�ơ�', c_Red, t_Hint);//��ʾ�û�
                                end;
                              end;//case
                            end;
                            if UserItem.Dura > 0 then begin
                              boSendUpDate := True;
                              boEatOK := False;
                            end else begin
                              if UserItem <> nil then begin
                                UserItem.wIndex:= 0;//20081014
                                m_ItemList.Delete(I);
                                //DisPoseAndNil(UserItem);
                                DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                                UserItem := nil;
                              end;
                            end;
                          end else begin
                             SysMsg('(Ӣ��)������ﵽ'+inttostr(StdItem.Need)+'��������!',c_Red,t_Hint);//��ʾ�û�
                          end;
                        end else begin
                           SysMsg('(Ӣ��)�Ծ�ͷ�β���,����Ϊ����ϵ,�κ���ȥ����,������������!',c_Red,t_Hint);
                        end;
                      end;//if (StdItem.Shape <> 0)
                    end;//60
                end;
                Break;
              end;
            end;
          end;
        end;
      end else begin
        if m_Master <> nil then begin//20090109 ����
          m_Master.SendMsg(g_ManageNPC, RM_MENU_OK, 0, Integer(m_Master), 0, 0, g_sCanotUseItemMsg);
        end;
      end;
      if boEatOK then begin
        WeightChanged();
        SendDefMessage(SM_HEROEAT_OK, 0, 0, 0, 0, '');
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('11' + #9 +
            m_sMapName + #9 +
            IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
            m_sCharName + #9 + StdItem.Name + #9 +
            IntToStr(UserItem34.MakeIndex) + #9 +
            '('+IntToStr(LoWord(StdItem.DC))+'/'+IntToStr(HiWord(StdItem.DC))+')'+
            '('+IntToStr(LoWord(StdItem.MC))+'/'+IntToStr(HiWord(StdItem.MC))+')'+
            '('+IntToStr(LoWord(StdItem.SC))+'/'+IntToStr(HiWord(StdItem.SC))+')'+
            '('+IntToStr(LoWord(StdItem.AC))+'/'+IntToStr(HiWord(StdItem.AC))+')'+
            '('+IntToStr(LoWord(StdItem.MAC))+'/'+IntToStr(HiWord(StdItem.MAC))+')'+
            IntToStr(UserItem34.btValue[0])+'/'+IntToStr(UserItem34.btValue[1])+'/'+IntToStr(UserItem34.btValue[2])+'/'+
            IntToStr(UserItem34.btValue[3])+'/'+IntToStr(UserItem34.btValue[4])+'/'+IntToStr(UserItem34.btValue[5])+'/'+
            IntToStr(UserItem34.btValue[6])+'/'+IntToStr(UserItem34.btValue[7])+'/'+IntToStr(UserItem34.btValue[8])+'/'+
            IntToStr(UserItem34.btValue[14])+ #9 + IntToStr(m_btRaceServer));
      end else begin
        SendDefMessage(SM_HEROEAT_FAIL, 0, 0, 0, 0, '');
      end;
      if (UserItem <> nil) and boSendUpDate then begin
        SendUpdateItem(UserItem);
      end;
    except
      MainOutMessage(Format('{%s} THeroObject.ClientHeroUseItems Code:%d',[g_sExceptionVer, nCode]));
    end;  
  finally
    if m_Master <> nil then begin//20090221 ����
      TPlayObject(m_Master).m_boCanQueryBag:= False;
    end;
  end;
end;

procedure THeroObject.WeightChanged;
begin
  if m_Master = nil then Exit;
  m_WAbil.Weight := RecalcBagWeight();
  if m_btRaceServer = RC_HEROOBJECT then begin
    SendUpdateMsg(m_Master, RM_HEROWEIGHTCHANGED, 0, 0, 0, 0, '');
  end;
end;
//δʹ�ù���
procedure THeroObject.RefMyStatus();
begin
  RecalcAbilitys();
  CompareSuitItem(False);//��װ������װ���Ա� 20080729
  m_Master.SendMsg(m_Master, RM_MYSTATUS, 0, 1, 0, 0, '');
end;

function THeroObject.EatItems(StdItem: pTStdItem; boType: Boolean{�Ƿ�����}; nType: Byte): Boolean;
var
  bo06: Boolean;
 // nOldStatus: Integer;
begin
  Result := False;
  if m_PEnvir.m_boNODRUG then begin
    SysMsg(sCanotUseDrugOnThisMap, BB_Fuchsia, t_Hint);
    Exit;
  end;
  case StdItem.StdMode of
    0: begin
        if nType <> 1 then Exit;//20090810 ����
        case StdItem.Shape of
          1: begin//����HP��MP��ҩƷ(����)
              if boType then begin
                if m_Master <> nil then begin
                  if not m_Master.m_boGhost then begin
                    if GetTickCount() - TPlayObject(m_Master).m_dwUserTick[4] > g_Config.dwEatHPItemsIntervalTime then begin//20090325 ʹ��ҩƷ���
                      TPlayObject(m_Master).m_dwUserTick[4]:= GetTickCount();
                      IncHealthSpell(StdItem.AC, StdItem.MAC);
                      Result := True;
                    end;
                  end;
                end;
              end else begin
                IncHealthSpell(StdItem.AC, StdItem.MAC);
                Result := True;
              end;
            end;
          2: begin
              m_boUserUnLockDurg := True;
              Result := True;
            end;
          {$IF M2Version <> 2}
          3: begin//�����ڹ�������Ʒ 20081002 Ӣ�۲���ʹ���ڹ���Ʒ  20081227
              {if m_boTrainingNG then begin
                GetNGExp(StdItem.AC * 1000, 1);
                Result := True;
              end;}
            end;
          4: begin//��������ֵ��Ʒ 20090809
              if m_boTrainingNG then begin
                m_Skill69NH:= _MIN(m_Skill69MaxNH, m_Skill69NH + StdItem.AC);
                SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
                Result := True;
              end else SysMsg('�������㣬�޷�ʹ��', c_Green, t_Hint);          
            end;
          {$IFEND}              
        else begin//��ͨҩƷ������HP
            if boType then begin
              if m_Master <> nil then begin
                if not m_Master.m_boGhost then begin
                  if GetTickCount() - TPlayObject(m_Master).m_dwUserTick[4] > g_Config.dwEatHPItemsIntervalTime then begin//20090325 ʹ��ҩƷ���
                    TPlayObject(m_Master).m_dwUserTick[4]:= GetTickCount();
                    if (StdItem.AC > 0) then begin
                      Inc(m_nIncHealth, StdItem.AC);
                    end;
                    if (StdItem.MAC > 0) then begin
                      Inc(m_nIncSpell, StdItem.MAC);
                    end;
                    Result := True;
                  end;
                end;
              end;
            end else begin
              if (StdItem.AC > 0) then begin
                Inc(m_nIncHealth, StdItem.AC);
              end;
              if (StdItem.MAC > 0) then begin
                Inc(m_nIncSpell, StdItem.MAC);
              end;
              Result := True;
            end;
          end;
        end;
      end;
    1: Result := False;
    {1: begin
        nOldStatus := GetMyStatus();
        Inc(m_nHungerStatus, StdItem.DuraMax div 10);
        m_nHungerStatus := _MIN(5000, m_nHungerStatus);
        if nOldStatus <> GetMyStatus() then
          RefMyStatus();
        Result := True;
      end;}
    3: begin
        case StdItem.Shape of
          12: begin
            bo06 := False;
            if LoWord(StdItem.DC) > 0 then begin
              m_wStatusArrValue[0] := LoWord(StdItem.DC);
              m_dwStatusArrTimeOutTick[0] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('����������' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if LoWord(StdItem.MC) > 0 then begin
              m_wStatusArrValue[1] := LoWord(StdItem.MC);
              m_dwStatusArrTimeOutTick[1 ] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('ħ��������' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if LoByte(StdItem.SC) > 0 then begin
              m_wStatusArrValue[20] := LoWord(StdItem.SC);
              m_dwStatusArrTimeOutTick[20] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('��������' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if HiWord(StdItem.AC) > 0 then begin
              m_wStatusArrValue[3] := HiWord(StdItem.AC);
              m_dwStatusArrTimeOutTick[3] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('�����ٶ�����' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if LoWord(StdItem.AC) > 0 then begin
              m_wStatusArrValue[4] := LoWord(StdItem.AC);
              m_dwStatusArrTimeOutTick[4] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('����ֵ����' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if LoWord(StdItem.MAC) > 0 then begin
              m_wStatusArrValue[5] := LoWord(StdItem.MAC);
              m_dwStatusArrTimeOutTick[5] := GetTickCount + HiWord(StdItem.MAC) * 1000;
              SysMsg('ħ��ֵ����' + IntToStr(HiWord(StdItem.MAC)) + '��', BB_Fuchsia, t_Hint);
              bo06 := True;
            end;
            if bo06 then begin
              RecalcAbilitys();
              CompareSuitItem(False);//��װ������װ���Ա� 20080729
              SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//20090107 �޸�
              SendMsg(self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');//20090107 �޸�
              Result := True;
            end;
          end;//12
          13: begin//��ħ����ҩ��(������ӵ���)
            bo06 := False;
            if (StdItem.AC > 0) then begin
              case m_btJob of//ְҵ
                0:begin
                   m_wStatusArrValue[0]:= 1 + Random(StdItem.AC);
                   m_dwStatusArrTimeOutTick[0]:= GetTickCount + HiWord(StdItem.MAC) * 1000;
                   SysMsg('������������˲�����' + IntToStr(HiWord(StdItem.MAC)) + '��', c_Green, t_Hint);
                   bo06 := True;
                end;
                1:begin
                   m_wStatusArrValue[1]:= 1 + Random(StdItem.AC);
                   m_dwStatusArrTimeOutTick[1]:= GetTickCount + HiWord(StdItem.MAC) * 1000;
                   SysMsg('ħ��������˲�����' + IntToStr(HiWord(StdItem.MAC)) + '��', c_Green, t_Hint);
                   bo06 := True;
                end;
                2:begin
                   m_wStatusArrValue[20]:= 1 + Random(StdItem.AC);
                   m_dwStatusArrTimeOutTick[20]:= GetTickCount + HiWord(StdItem.MAC) * 1000;
                   SysMsg('����������˲�����' + IntToStr(HiWord(StdItem.MAC)) + '��', c_Green, t_Hint);
                   bo06 := True;
                end;
              end;
            end;
            if bo06 then begin
              RecalcAbilitys();
              CompareSuitItem(False);//��װ������װ���Ա� 20080729
              SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');
              SendMsg(self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');
              Result := True;
            end;
          end;//13
          14: begin//��ħ����ҩ��
            bo06 := False;
            if (StdItem.AC > 0) then begin
              case Random(2) of
                0:begin//����
                  m_wStatusArrValue[12]:= StdItem.AC + Random(3);
                  m_dwStatusArrTimeOutTick[12]:= GetTickCount + HiWord(StdItem.MAC) * 1000;
                  SysMsg('����������˲�����' + IntToStr(HiWord(StdItem.MAC)) + '��', c_Green, t_Hint);
                  bo06 := True;
                end;//0
                1:begin//ħ��
                  m_wStatusArrValue[13]:= StdItem.AC + Random(3);
                  m_dwStatusArrTimeOutTick[13]:= GetTickCount + HiWord(StdItem.MAC) * 1000;
                  SysMsg('ħ��������˲�����' + IntToStr(HiWord(StdItem.MAC)) + '��', c_Green, t_Hint);
                  bo06 := True;
                end;//1
              end;
            end;
            if bo06 then begin
              RecalcAbilitys();
              CompareSuitItem(False);//��װ������װ���Ա� 20080729
              SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');
              SendMsg(self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');
              Result := True;
            end;         
          end;//14
          else begin
            Result := EatUseItems(StdItem.Shape);
          end;
        end;//case
      end;
    17: begin
        if StdItem.Shape = 237 then begin
          if (StdItem.DC = 0) then begin//Ӣ�۲���ʹ�û���������Ʒ 20110821
            if boType then begin
              if m_Master <> nil then begin
                if not m_Master.m_boGhost then begin
                  if GetTickCount() - TPlayObject(m_Master).m_dwUserTick[4] > g_Config.dwEatHPItemsIntervalTime then begin//20090325 ʹ��ҩƷ���
                    TPlayObject(m_Master).m_dwUserTick[4]:= GetTickCount();
                    if StdItem.AniCount = 0 then begin//������
                      if (StdItem.AC > 0) then begin
                        Inc(m_nIncHealth, StdItem.AC);
                      end;
                      if (StdItem.MAC > 0) then begin
                        Inc(m_nIncSpell, StdItem.MAC);
                      end;
                    end else begin//������
                      IncHealthSpell(StdItem.AC, StdItem.MAC);//����HP,MP
                    end;
                    Result := True;
                  end;
                end;
              end;
            end else begin
              if StdItem.AniCount = 0 then begin//������
                if (StdItem.AC > 0) then begin
                  Inc(m_nIncHealth, StdItem.AC);
                end;
                if (StdItem.MAC > 0) then begin
                  Inc(m_nIncSpell, StdItem.MAC);
                end;
              end else begin//������
                IncHealthSpell(StdItem.AC, StdItem.MAC);//����HP,MP
              end;
              Result := True;
            end;
          end;
        end;
      end;
  end;
end;

function THeroObject.ReadBook(StdItem: pTStdItem): Boolean;
var
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  str:string;
begin
  Result := False;
  if (StdItem.Need > 0) and (StdItem.NeedLevel > 0) and (StdItem.AC = 1) then begin//�ļ�������
    Magic := UserEngine.FindHeroMagic(StdItem.NeedLevel);
    if Magic <> nil then begin
      if (not IsTrainingSkill(Magic.wMagicId)) or ((Magic.wMagicId = StdItem.Need) and (Magic.wMagicId = GetTogetherUseSpell) and ((StdItem.NeedLevel = SKILL_60) or (StdItem.NeedLevel = SKILL_61) or (StdItem.NeedLevel = SKILL_62) or (StdItem.NeedLevel = SKILL_63) or (StdItem.NeedLevel = SKILL_64) or (StdItem.NeedLevel = SKILL_65))) then begin//�ļ��ϻ����� 20100719
        if (Magic.sDescr = 'Ӣ��') and ((Magic.btJob = 99) or (Magic.btJob = m_btJob)) then begin
          if TrainingSkillToLevel(StdItem.Need, Magic, 3, 4, str) then begin
            Result := True;
          end else SysMsg('(Ӣ��) ����ѧϰ�˼��ܣ�', c_Red, t_Hint);
        end else SysMsg('(Ӣ��) ְҵ����ѧϰ�˼��ܣ�', c_Red, t_Hint);
      end else SysMsg('(Ӣ��) �Ѿ�ѧ���˼���,������ѧϰ��', c_Red, t_Hint);
    end;  
  end else begin
    Magic := UserEngine.FindHeroMagic(StdItem.Name);
    if Magic <> nil then begin
      if not IsTrainingSkill(Magic.wMagicId) then begin
        if ((Magic.sDescr = 'Ӣ��'){$IF M2Version <> 2} or (Magic.sDescr = '�ڹ�') or (Magic.sDescr = '����') or (Magic.sDescr = 'ͨ��'){$IFEND}) and ((Magic.btJob = 99) or (Magic.btJob = m_btJob)) then begin
          {$IF M2Version <> 2}
          if (Magic.sDescr = '�ڹ�') or (Magic.sDescr = '����') then begin//�ڹ�����
            if m_boTrainingNG then begin//ѧ���ڹ��ķ�����ѧϰ����
               if m_NGLevel >= Magic.TrainLevel[0] then begin//�ȼ��ﵽ���Ҫ��
                 {$IF M2Version = 1}
                 if Magic.sDescr = '����' then begin
                   if not m_boOpenHumanPulseArr then begin
                     SysMsg('(Ӣ��) δ��ͨ����,����ѧϰ���������ܣ�', c_Red, t_Hint);
                     Exit;
                   end;
                   m_boTrainBatterSkill:= True;//�Ƿ�ѧϰ���������� 20090915
                 end;
                 {$IFEND}
                 New(UserMagic);
                 UserMagic.MagicInfo := Magic;
                 UserMagic.wMagIdx := Magic.wMagicId;
                 UserMagic.btKey := 0;
                 UserMagic.btLevel := 0;
                 UserMagic.nTranPoint := 0;
                 UserMagic.btLevelEx:= 0;
                 if Magic.wMagicId = SKILL_102 then UserMagic.btLevel := 1;//Ψ�Ҷ���,ѧϰ�ȼ�Ϊ1��
                 m_MagicList.Add(UserMagic);
                 {$IF M2Version = 1}
                 if (UserMagic.MagicInfo.wMagicId > 75) and (UserMagic.MagicInfo.wMagicId < 88) then begin//�������ܲŴ���
                   m_BatterMagicList.Add(UserMagic);
                 end;
                 {$IFEND}
                 RecalcAbilitys();
                 CompareSuitItem(False);//��װ������װ���Ա� 20080729
                 SendAddMagic(UserMagic);
                 TPlayObject(m_Master).HeroAddSkillFunc(Magic.wMagicId);//Ӣ��ѧ���ܴ��� 20080324
                 Result := True;
               end else SysMsg(Format('(Ӣ��) �ڹ��ķ��ȼ�û�дﵽ %d,����ѧϰ���ڹ����ܣ�',[Magic.TrainLevel[0]]), c_Red, t_Hint);
            end else SysMsg('(Ӣ��) ûѧ���ڹ��ķ�,����ѧϰ���ڹ����ܣ�', c_Red, t_Hint);
          end else begin//��ͨ����
          {$IFEND}
            if (Magic.wMagicId in [60..65]) and (Magic.wMagicId <> GetTogetherUseSpell) then begin
              SysMsg('(Ӣ��) ����ѧϰ�˺ϻ����ܣ�', BB_Fuchsia, t_Hint);
              Exit;
            end;
            if m_Abil.Level >= Magic.TrainLevel[0] then begin
              if Magic.wMagicId = 75 then begin
                if m_boProtectionDefence then begin
                  SysMsg('(Ӣ��) �Ѿ�ѧ���˼���,������ѧϰ��', BB_Fuchsia, t_Hint);
                  Exit;
                end;
                m_boProtectionDefence:= True; //�Ƿ�ѧ���������
                TPlayObject(m_Master).HeroAddSkillFunc(Magic.wMagicId);//Ӣ��ѧ���ܴ���
                Result := True;
                Exit;
              end;
              New(UserMagic);
              UserMagic.MagicInfo := Magic;
              UserMagic.wMagIdx := Magic.wMagicId;
              UserMagic.btKey := 0;
              UserMagic.btLevel := 0;
              UserMagic.nTranPoint := 0;
              UserMagic.btLevelEx:= 0;
              m_MagicList.Add(UserMagic);
              RecalcAbilitys();
              CompareSuitItem(False);//��װ������װ���Ա� 20080729
              SendAddMagic(UserMagic);
              TPlayObject(m_Master).HeroAddSkillFunc(Magic.wMagicId);//Ӣ��ѧ���ܴ��� 20080324
              Result := True;
            end;
          {$IF M2Version <> 2}
          end;
          {$IFEND}
        end else SysMsg('(Ӣ��) ����ѧϰ�˼��ܣ�', BB_Fuchsia, t_Hint);
      end else SysMsg('(Ӣ��) �Ѿ�ѧ���˼���,������ѧϰ��', BB_Fuchsia, t_Hint);
    end else SysMsg('(Ӣ��) ����ѧϰ����ļ��ܣ�', BB_Fuchsia, t_Hint);
  end;
end;
//�������ӵ�ħ��
procedure THeroObject.SendAddMagic(UserMagic: pTUserMagic);
var
  ClientMagic: TClientMagic;
begin
  ClientMagic.Key := Char(UserMagic.btKey);
  ClientMagic.Level := UserMagic.btLevel;
  ClientMagic.CurTrain := UserMagic.nTranPoint;
  ClientMagic.Def := UserMagic.MagicInfo^;
  ClientMagic.btLevelEx := UserMagic.btLevelEx;
  case ClientMagic.Def.wMagicId of
    SKILL_68: ClientMagic.Def.MaxTrain[0] := GetSkill68Exp(UserMagic.btLevel);//��������
    {$IF M2Version <> 2}
    {$IF M2Version = 1}
    SKILL_95: ClientMagic.Def.MaxTrain[0] := GetSkill95Exp(UserMagic.btLevel);//��ת����
    {$IFEND}
    SKILL_200: begin//ŭ֮��ɱǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_200NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_200NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_202: begin//ŭ֮����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_202NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_202NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_236: begin//ŭ֮�ڹ�����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_236NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_236NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_204: begin//ŭ֮�һ�ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_204NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_204NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_206: begin//ŭ֮����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_206NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_206NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_239: begin//ŭ֮ʩ����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_239NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_239NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_230: begin//ŭ֮���ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_230NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_230NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_232: begin//ŭ֮��Ѫǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_232NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_232NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_241: begin//ŭ֮����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_241NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_241NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_228: begin//ŭ֮�����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_228NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_228NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_234: begin//ŭ֮���ǻ���ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_234NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_234NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_208: begin//ŭ֮����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_208NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_208NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_214: begin//ŭ֮������ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_214NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_214NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_218: begin//ŭ֮���ѻ���ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_218NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_218NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_222: begin//ŭ֮�׵�ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_222NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_222NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_210: begin//ŭ֮�����ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_210NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_210NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_212: begin//ŭ֮��ǽǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_212NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_212NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_216: begin//ŭ֮�����Ӱǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_216NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_216NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_224: begin//ŭ֮�����׹�ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_224NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_224NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_226: begin//ŭ֮������ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_226NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_226NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    Skill_220: begin//ŭ֮������ǿ��
      if (ClientMagic.Level > 2) and (ClientMagic.Level < g_Config.nNGSkillMaxLevel) then begin//���ڴﵽ3��ʱ����
        ClientMagic.Def.wPower:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[0]+ (ClientMagic.Level - 3) * g_Config.nSKILL_220NGStrong[1]);
        ClientMagic.Def.wMaxPower:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[2]+ (ClientMagic.Level - 3) * g_Config.nSKILL_220NGStrong[3]);
      end else begin
        ClientMagic.Def.wPower:= 0;
        ClientMagic.Def.wMaxPower:= 0;
      end;
    end;
    {$IFEND}
    SKILL_99: ClientMagic.Def.MaxTrain[0] := 300 + (UserMagic.btLevel * 200);//ǿ��������������ͨ���㷨ȡ��
    SKILL_100: ClientMagic.Def.MaxTrain[0] := 500 + (UserMagic.btLevel * 700);//���ؽ��
    SKILL_71, SKILL_104: ClientMagic.Def.MaxTrain[0] := GetUpKill71Count(UserMagic.btLevel);//�ٻ�ʥ��,�ٻ�����
  end;
  m_DefMsg := MakeDefaultMsg(SM_HEROADDMAGIC, 0, 0, 0, 1, 0);
  SendSocket(@m_DefMsg, EncodeBuffer(@ClientMagic, SizeOf(TClientMagic)));
end;

procedure THeroObject.SendDelMagic(UserMagic: pTUserMagic);
begin
  m_DefMsg := MakeDefaultMsg(SM_HERODELMAGIC, UserMagic.wMagIdx, 0, 0, 1, 0);
  SendSocket(@m_DefMsg, '');
end;

function THeroObject.IsEnoughBag(): Boolean;
begin
  Result := False;
  if m_ItemList.Count < m_nItemBagCount then
    Result := True;
end;

procedure THeroObject.MakeWeaponUnlock;
begin
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  if m_UseItems[U_WEAPON].btValue[3] > 0 then begin
    Dec(m_UseItems[U_WEAPON].btValue[3]);
    SysMsg(g_sTheWeaponIsCursed, BB_Fuchsia, t_Hint);
  end else begin
    if m_UseItems[U_WEAPON].btValue[4] < 10 then begin
      Inc(m_UseItems[U_WEAPON].btValue[4]);
      SysMsg(g_sTheWeaponIsCursed, BB_Fuchsia, t_Hint);
    end;
  end;
  if m_btRaceServer = RC_HEROOBJECT then begin
    RecalcAbilitys();
    CompareSuitItem(False);//��װ������װ���Ա� 20080729
    SendMsg({m_Master}self, RM_HEROABILITY, 0, 0, 0, 0, '');//20090107 �޸�
    SendMsg({m_Master}self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');//20090107 �޸�
  end;
end;

//ʹ��ף����,������������
function THeroObject.WeaptonMakeLuck: Boolean;
var
  StdItem: pTStdItem;
  nRand: Integer;
  boMakeLuck: Boolean;
begin
  Result := False;
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  nRand := 0;
  StdItem := UserEngine.GetStdItem(m_UseItems[U_WEAPON].wIndex);
  if StdItem <> nil then begin
    nRand := abs((HiWord(StdItem.DC) - LoWord(StdItem.DC))) div 5;
  end;
  if Random(g_Config.nWeaponMakeUnLuckRate {20}) = 1 then begin
    MakeWeaponUnlock();
  end else begin
    boMakeLuck := False;
    if m_UseItems[U_WEAPON].btValue[4] > 0 then begin
      Dec(m_UseItems[U_WEAPON].btValue[4]);
      SysMsg(g_sWeaptonMakeLuck {'��������������...'}, BB_Fuchsia, t_Hint);
      boMakeLuck := True;
    end else if m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint1 {1} then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'��������������...'}, BB_Fuchsia, t_Hint);
      boMakeLuck := True;
    end else if (m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint2 {3}) and (Random(nRand + g_Config.nWeaponMakeLuckPoint2Rate {6}) = 1) then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'��������������...'}, BB_Fuchsia, t_Hint);
      boMakeLuck := True;
    end else if (m_UseItems[U_WEAPON].btValue[3] < g_Config.nWeaponMakeLuckPoint3 {7}) and (Random(nRand * g_Config.nWeaponMakeLuckPoint3Rate {10 + 30}) = 1) then begin
      Inc(m_UseItems[U_WEAPON].btValue[3]);
      SysMsg(g_sWeaptonMakeLuck {'��������������...'}, BB_Fuchsia, t_Hint);
      boMakeLuck := True;
    end;
    if m_btRaceServer = RC_HEROOBJECT then begin
      RecalcAbilitys();
      CompareSuitItem(False);//��װ������װ���Ա� 20080729
      SendMsg({m_Master}self, RM_HEROABILITY, 0, 0, 0, 0, '');//20090107 �޸�
      SendMsg({m_Master}self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');//20090107 �޸�
    end;
    if not boMakeLuck then SysMsg(g_sWeaptonNotMakeLuck {'��Ч'}, BB_Fuchsia, t_Hint);
  end;
  Result := True;
end;
//�޸�����
function THeroObject.RepairWeapon: Boolean;
var
  nDura: Integer;
  UserItem: pTUserItem;
begin
  Result := False;
  UserItem := @m_UseItems[U_WEAPON];
  if (UserItem.wIndex <= 0) or (UserItem.DuraMax <= UserItem.Dura) then Exit;
  Dec(UserItem.DuraMax, (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura {30});
  nDura := _MIN(5000, UserItem.DuraMax - UserItem.Dura);
  if nDura > 0 then begin
    Inc(UserItem.Dura, nDura);
    if m_btRaceServer = RC_HEROOBJECT then begin
      SendMsg(m_Master, RM_HERODURACHANGE, 1, UserItem.Dura, UserItem.DuraMax, 0, '');
      SysMsg(g_sWeaponRepairSuccess {'�����޸��ɹ�...'}, BB_Fuchsia, t_Hint);
    end;
    Result := True;
  end;
end;
//�ص�Ʒ�����޸�
function THeroObject.SuperRepairWeapon: Boolean;
begin
  Result := False;
  if m_UseItems[U_WEAPON].wIndex <= 0 then Exit;
  m_UseItems[U_WEAPON].Dura := m_UseItems[U_WEAPON].DuraMax;
  if m_btRaceServer = RC_HEROOBJECT then begin
    SendMsg(m_Master, RM_HERODURACHANGE, 1, m_UseItems[U_WEAPON].Dura, m_UseItems[U_WEAPON].DuraMax, 0, '');
    SysMsg(g_sWeaponRepairSuccess {'�����޸��ɹ�...'}, BB_Fuchsia, t_Hint);
  end;
  Result := True;
end;
//Ӣ���޼�����  20080323 �޸�
//0����������40%   1������60%   2������80%  3������100%  ʱ�䶼��6��
function THeroObject.AbilityUp(UserMagic: pTUserMagic): Boolean;
var
  nSpellPoint, n14: Integer;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  if nSpellPoint > 0 then begin
    if (m_WAbil.MP < nSpellPoint) or (m_wStatusArrValue[2] <> 0) then Exit;//20091018 ����
    if UserMagic.btLevel > 3 then UserMagic.btLevel:= 3;//20100405 ����
    if g_Config.boAbilityUpFixMode then begin//�޼�����ʹ�ù̶�ʱ��ģʽ 20081109
      n14:= g_Config.nAbilityUpFixUseTime;//�޼�����ʹ�ù̶�ʱ�� 20081109
    end else n14:=(UserMagic.btLevel * 2)+ 2 + g_Config.nAbilityUpUseTime;//20080603
    m_dwStatusArrTimeOutTick[2] := GetTickCount + n14 * 1000;
    m_wStatusArrValue[2] := _MIN(HiWord(m_TrueSC), Round(HiWord(m_TrueSC)*(UserMagic.btLevel * 0.2 + 0.4)));

    SysMsg(Format('(Ӣ��) ����˲ʱ����%d������ %d ��',[m_wStatusArrValue[2], n14]), c_Green, t_Hint);//20091104 �޸�
    RecalcAbilitys();
    CompareSuitItem(False);//��װ������װ���Ա� 20080729
    SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//20090107 �޸�
    SendMsg(self, RM_HEROSUBABILITY, 0, 0, 0, 0, '');//20090107 �޸�
    Result := True;
  end;
end;

procedure THeroObject.GainExp(dwExp: LongWord);
begin
  WinExp(dwExp);
end;

procedure THeroObject.WinExp(dwExp: LongWord);
begin
  if (not m_boGhost) then begin//20090524 ����
    if m_Abil.Level > g_Config.nLimitExpLevelHero then begin
      //dwExp := g_Config.nLimitExpValue;//20110116 �ﵽ�ȼ����޺󣬲��ٳ�����
      //GetExp(dwExp);
    end else
    if dwExp > 0 then begin
      dwExp := g_Config.dwKillMonExpMultiple * dwExp; //ϵͳָ��ɱ�־��鱶��
      dwExp := Round((m_nKillMonExpRate / 100) * dwExp); //����ָ����ɱ�־���ٷ���
      if m_PEnvir.m_boEXPRATE then
        dwExp := Round((m_PEnvir.m_nEXPRATE / 100) * dwExp); //��ͼ��ָ��ɱ�־��鱶��
      if m_boExpItem then begin //��Ʒ���鱶��
        dwExp := Round(m_rExpItem * dwExp);
      end;
      if m_Abil.Level >= 1000 then begin//20090323 �ȼ����侭��
        dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[1000] / 100));
        if dwExp <= 0 then dwExp:= 1;
      end else begin
        dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[m_Abil.Level] / 100));
        if dwExp <= 0 then dwExp:= 1;
      end;
      GetExp(dwExp, 0);
    end;
  end;
end;
{$IF M2Version <> 2}
//ȡ���������� 20081001 Code:0-ɱ�ַ��� 1-��ɱ�ַ��� 2-����,˭������˭ 3-���˷���ɱ�־���
procedure THeroObject.GetNGExp(dwExp1: LongWord; Code: Byte);
var
  dwExp: LongWord;
begin
  try
    dwExp:= dwExp1;//20090914 ����
    if m_boTrainingNG and (not m_boGhost) and (not m_boDeath) and (dwExp1 > 0) then begin//20090914 �޸�
      if (m_Master <> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
            if (TPlayObject(m_Master).m_nHeroNGLevel1 - TPlayObject(m_Master).m_nHeroNGLevel2 <= 3) then begin//�����븱��Ӣ���ڹ��ȼ����3������
              if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ���ڹ��ȼ������������ȼ��������ڹ��ȼ��������ܼ���������', c_Blue, t_Hint);
              Exit;
            end;
          end;
        end else Exit;
      end else Exit;
      if m_Abil.Level > g_Config.nLimitExpLevel then begin
        dwExp := g_Config.nLimitExpValue;
      end else
      if (dwExp > 0) and (Code = 0) then begin
        dwExp := g_Config.dwKillMonExpMultiple * dwExp; //ϵͳָ��ɱ�־��鱶��
        dwExp := Round((m_nKillMonExpRate / 100) * dwExp); //����ָ����ɱ�־���ٷ���
        if m_PEnvir <> nil then begin
          if m_PEnvir.m_boEXPRATE then dwExp := Round((m_PEnvir.m_nEXPRATE / 100) * dwExp); //��ͼ��ָ��ɱ�־��鱶��
          if m_PEnvir.m_boNGEXPRATE then dwExp := Round((m_PEnvir.m_nNGEXPRATE / 100) * dwExp);//��ͼɱ���ڹ����鱶�� 20091029
        end;
        if m_boExpItem then dwExp := Round(m_rExpItem * dwExp);//��Ʒ���鱶��
        if m_Abil.Level >= 1000 then begin//20090323 �ȼ����侭��
          dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[1000] / 100));
          if dwExp <= 0 then dwExp:= 1;
        end else begin
          dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[m_Abil.Level] / 100));
          if dwExp <= 0 then dwExp:= 1;
        end;      
      end else
      if (dwExp > 0) and (Code = 3) then begin
         dwExp := abs(Round(dwExp * g_Config.dwKillMonNGExpMultiple / 100));//ɱ���ڹ����鱶�� 20090104
      end;
      if (dwExp > 0) and (n_HeroTpye = 3) then begin
        dwExp:= Round((g_Config.nDeputyHeroExpRate / 100) * dwExp);
      end;

      if (dwExp > 0) then begin
        if m_ExpSkill69 >= LongWord(dwExp) then begin//20090101
          if (High(LongWord) - m_ExpSkill69) < LongWord(dwExp) then begin
            dwExp := High(LongWord) - m_ExpSkill69;
          end;
        end else begin
          if (High(LongWord) - LongWord(dwExp)) < m_ExpSkill69 then begin
            dwExp := High(LongWord) - LongWord(dwExp);
          end;
        end;

        Inc(m_ExpSkill69, dwExp);//�ڹ��ķ���ǰ����
        if m_Master <> nil then begin//20090109
          if (TPlayObject(m_Master).m_sDeputyHeroName <> '') and (not TPlayObject(m_Master).m_boCallDeputyHero)
            and (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
            if TPlayObject(m_Master).m_nMainNGExp + dwExp <= High(LongWord) then begin//20110609 �޸�
              Inc(TPlayObject(m_Master).m_nMainNGExp, dwExp);
            end else begin
              TPlayObject(m_Master).m_nMainNGExp := High(LongWord);
            end;
          end;
          if not TPlayObject(m_Master).m_boNotOnlineAddExp then SendMsg(m_Master, RM_HEROWINNHEXP, 0, dwExp, 0, 0, ''); //ֻ���͸������߹һ�����
        end;
        if (m_ExpSkill69 >= m_MaxExpSkill69) and (m_NGLevel < g_Config.nLimitExpNGLevel) then begin//20090504 ��ֹ255���������ڹ��ȼ����0��
          Dec(m_ExpSkill69, m_MaxExpSkill69);
          Inc(m_NGLevel);
          m_MaxExpSkill69:= GetSkill69Exp(m_NGLevel, m_Skill69MaxNH);//ȡ�ڹ��ķ���������
          m_Skill69NH:= m_Skill69MaxNH;
          SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, ''); //����ֵ�ñ��˿��� 20081002
          SendRefMsg(RM_MYSHOW, ET_OBJECTLEVELUP,0, 0, 0, ''); //������������  20081216
          if m_Master <> nil then begin
            if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
              if TPlayObject(m_Master).m_sDeputyHeroName <> '' then begin//������������Ӣ�����¼��ӦӢ���ڹ��ȼ�
                if TPlayObject(m_Master).m_boCallDeputyHero then TPlayObject(m_Master).m_nHeroNGLevel2:= m_NGLevel//����Ӣ���ڹ��ȼ�
                else TPlayObject(m_Master).m_nHeroNGLevel1:= m_NGLevel;//����Ӣ���ڹ��ȼ�
              end;
            end;
          end;
          SendNGResume();//�����ڹ����⣬�˺����ָ��ٶ����� 20090812
          NGLevelUpFunc;//Ӣ���ڹ���������  20090509
        end;
        SendMsg(Self, RM_HEROMAGIC69SKILLEXP, 0, 0, 0, m_NGLevel, EncodeString(Inttostr(m_ExpSkill69)+'/'+Inttostr(m_MaxExpSkill69)));
      end;
    end;
  except
    //MainOutMessage(Format('{%s} THeroObject.GetNGExp',[g_sExceptionVer]));
  end;
end;

//�ڹ��������� 20081003
procedure THeroObject.NGMAGIC_LVEXP(UserMagic: pTUserMagic);
begin
  if (UserMagic <> nil) then begin
    if (m_btRaceServer = RC_HEROOBJECT) and (UserMagic.btLevel < 3) and
       (UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= m_NGLevel) then begin
       TrainSkill(UserMagic, Random(3) + 1);
       if not CheckMagicLevelup(UserMagic) then begin
         SendDelayMsg(Self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 3000);//20081219
       end;
    end;
  end;
end;

//�����ڹ����� 20081005
procedure THeroObject.SendNGData;
begin
  try
    if (not m_boGhost) and (m_NGLevel > 0) and m_boTrainingNG then begin
      m_MaxExpSkill69:= GetSkill69Exp(m_NGLevel, m_Skill69MaxNH);//ȡ�ڹ��ķ��������� 20081002
      m_Skill69NH:= m_Skill69MaxNH;
      SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, ''); //����ֵ�ñ��˿��� 20081002
      SendMsg(self, RM_HEROMAGIC69SKILLEXP, 0, 0, 0, m_NGLevel, EncodeString(IntToStr(m_ExpSkill69)+'/'+IntToStr(m_MaxExpSkill69)));
      SendNGResume;//�����ڹ����⣬�˺����ָ��ٶ����� 20090812
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.SendNGData',[g_sExceptionVer]));
  end;
end;

//�����ڹ����⣬�˺����ָ��ٶ����� 20090813
procedure THeroObject.SendNGResume();
var
  nIncDC,nIncAC,nIncNGPoint,n18: Integer;
begin
  if (not m_boGhost) and (m_NGLevel > 0) and m_boTrainingNG then begin
    nIncDC:= 0;
    nIncAC:= 0;
    nIncNGPoint:= 0;
    n18:= 0;
    case m_btJob of//��ְҵ�������ڹ�������,������
      0: begin
        nIncDC:= (m_NGLevel div g_Config.nWarrNGLevelIncDC) + 5;
        nIncAC:= (m_NGLevel div g_Config.nWarrNGLevelIncAC) + 12;
      end;
      1: begin
        nIncDC:= (m_NGLevel div g_Config.nWizardNGLevelIncDC) + 3;
        nIncAC:= (m_NGLevel div g_Config.nWizardNGLevelIncAC) + 15;
      end;
      2: begin
        nIncDC:= (m_NGLevel div g_Config.nTaosNGLevelIncDC) + 3;
        nIncAC:= (m_NGLevel div g_Config.nTaosNGLevelIncAC) + 13;
      end;
    end;
    n18 := (m_Skill69MaxNH div 75) + 1 + m_nIncNHPoint;
    nIncNGPoint := Round(n18 * ( 1 + m_nIncNHRecover / 100));
    SendDefMessage1(SM_SENDHERONGRESUME, nIncDC{�˺�ֵ}, LoWord(nIncAC), HiWord(nIncAC), 0, nIncNGPoint{�ָ��ٶ�}, '');
  end;
end;

//�ͻ���ǿ��ŭ֮�ڹ� 20110605
procedure THeroObject.ClientHeroUpNGStrongSkill(wMagIdx{����ID}: Integer);
  function CheckItemCount(nItemCount: Word): Boolean;//�����Ʒ������ɾ����Ʒ
  var
    I, nCount: Integer;
    StdItem: pTStdItem;
    UserItem: pTUserItem;
    boItem: Boolean;
  begin
    Result := False;
    if nItemCount > 0 then begin
      if m_ItemList.Count > 0 then begin
        nCount:= 0;
        boItem:= False;
        for I := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then Break;
          UserItem := m_ItemList.Items[I];
          if UserItem <> nil then begin
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            if StdItem <> nil then begin
              if (CompareText(StdItem.Name, g_Config.sNGStrongItem)= 0) then begin
                if (StdItem.StdMode = 17) then begin
                  Inc(nCount, UserItem.Dura);
                  if nCount >= nItemCount then begin
                    boItem:= True;
                    Break;
                  end;
                end else begin
                  Inc(nCount);
                  if nCount >= nItemCount then begin
                    boItem:= True;
                    Break;
                  end;
                end;
              end;
            end;
          end;
        end;
        if boItem then begin//����������ɾ����Ʒ�����ӵȼ�
          for I := m_ItemList.Count - 1 downto 0 do begin
            if m_ItemList.Count <= 0 then Break;
            UserItem := m_ItemList.Items[I];
            if UserItem <> nil then begin
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem <> nil then begin
                if (CompareText(StdItem.Name, g_Config.sNGStrongItem)= 0) then begin
                  if (StdItem.StdMode = 17) then begin
                    if UserItem.Dura >= nItemCount then begin
                      UserItem.Dura:= UserItem.Dura - nItemCount;
                      Result:= True;
                      if UserItem.Dura <= 0 then begin//ɾ����Ʒ
                        m_ItemList.Delete(I);
                        SendDelItems(UserItem);
                        UserItem.MakeIndex:= 0;
                        UserItem.wIndex:= 0;
                        //DisPoseAndNil(UserItem);
                        DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                        UserItem := nil;
                      end else begin
                        SendUpdateItem(UserItem);//������Ʒ
                      end;
                      Break;
                    end else begin
                      Dec(nItemCount,UserItem.Dura);
                      UserItem.Dura:= 0;
                      m_ItemList.Delete(I);
                      SendDelItems(UserItem);
                      UserItem.MakeIndex:= 0;
                      UserItem.wIndex:= 0;
                      //DisPoseAndNil(UserItem);
                      DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                      UserItem := nil;
                    end;
                  end else begin
                    Dec(nItemCount);
                    m_ItemList.Delete(I);
                    SendDelItems(UserItem);
                    UserItem.MakeIndex:= 0;
                    UserItem.wIndex:= 0;
                    //DisPoseAndNil(UserItem);
                    DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                    UserItem := nil;
                    if nItemCount <= 0 then begin
                      Result:= True;
                      Break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end else begin
          SysMsg('(Ӣ��)�ܱ�Ǹ����û���㹻��'+ g_Config.sNGStrongItem, c_Red, t_Hint);
        end;
      end;
    end;
  end;
var
  nNeedNGLevel, nNeedItemCount: Word;
begin
  try
    if (g_Config.sNGStrongItem <> '') and (m_Master <> nil) then begin
      if (not m_boTrainingNG) or m_boDeath or m_boGhost then Exit;
      if m_Master.m_boDeath or m_Master.m_boGhost then Exit;
      TPlayObject(m_Master).m_boCanQueryBag:= True;//����ˢ�°���
      try
        case wMagIdx of
          SKILL_200: begin//ŭ֮��ɱǿ��
            if m_MagicSkill_200 <> nil then begin
              if (m_MagicSkill_200.btLevel > 2) and (m_MagicSkill_200.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[0]+ (m_MagicSkill_200.btLevel - 3) * g_Config.nSKILL_200NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[2]+ (m_MagicSkill_200.btLevel - 3) * g_Config.nSKILL_200NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_200.btLevel);
                    if (m_MagicSkill_200.btLevel > 2) and (m_MagicSkill_200.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[0]+ (m_MagicSkill_200.btLevel - 3) * g_Config.nSKILL_200NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_200NGStrong[2]+ (m_MagicSkill_200.btLevel - 3) * g_Config.nSKILL_200NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_200.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_200.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_202: begin//ŭ֮����ǿ��
            if m_MagicSkill_202 <> nil then begin
              if (m_MagicSkill_202.btLevel > 2) and (m_MagicSkill_202.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[0]+ (m_MagicSkill_202.btLevel - 3) * g_Config.nSKILL_202NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[2]+ (m_MagicSkill_202.btLevel - 3) * g_Config.nSKILL_202NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_202.btLevel);
                    if (m_MagicSkill_202.btLevel > 2) and (m_MagicSkill_202.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[0]+ (m_MagicSkill_202.btLevel - 3) * g_Config.nSKILL_202NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_202NGStrong[2]+ (m_MagicSkill_202.btLevel - 3) * g_Config.nSKILL_202NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_202.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_202.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_236: begin//ŭ֮�ڹ�����ǿ��
            if m_MagicSkill_236 <> nil then begin
              if (m_MagicSkill_236.btLevel > 2) and (m_MagicSkill_236.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[0]+ (m_MagicSkill_236.btLevel - 3) * g_Config.nSKILL_236NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[2]+ (m_MagicSkill_236.btLevel - 3) * g_Config.nSKILL_236NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_236.btLevel);
                    if (m_MagicSkill_236.btLevel > 2) and (m_MagicSkill_236.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[0]+ (m_MagicSkill_236.btLevel - 3) * g_Config.nSKILL_236NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_236NGStrong[2]+ (m_MagicSkill_236.btLevel - 3) * g_Config.nSKILL_236NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_236.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_236.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_204: begin//ŭ֮�һ�ǿ��
            if m_MagicSkill_204 <> nil then begin
              if (m_MagicSkill_204.btLevel > 2) and (m_MagicSkill_204.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[0]+ (m_MagicSkill_204.btLevel - 3) * g_Config.nSKILL_204NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[2]+ (m_MagicSkill_204.btLevel - 3) * g_Config.nSKILL_204NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_204.btLevel);
                    if (m_MagicSkill_204.btLevel > 2) and (m_MagicSkill_204.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[0]+ (m_MagicSkill_204.btLevel - 3) * g_Config.nSKILL_204NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_204NGStrong[2]+ (m_MagicSkill_204.btLevel - 3) * g_Config.nSKILL_204NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_204.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_204.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_206: begin//ŭ֮����ǿ��
            if m_MagicSkill_206 <> nil then begin
              if (m_MagicSkill_206.btLevel > 2) and (m_MagicSkill_206.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[0]+ (m_MagicSkill_206.btLevel - 3) * g_Config.nSKILL_206NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[2]+ (m_MagicSkill_206.btLevel - 3) * g_Config.nSKILL_206NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_206.btLevel);
                    if (m_MagicSkill_206.btLevel > 2) and (m_MagicSkill_206.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[0]+ (m_MagicSkill_206.btLevel - 3) * g_Config.nSKILL_206NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_206NGStrong[2]+ (m_MagicSkill_206.btLevel - 3) * g_Config.nSKILL_206NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_206.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_206.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_239: begin//ŭ֮ʩ����ǿ��
            {$IF M2Version = 1}
            if m_MagicSkill_239 <> nil then begin
              if (m_MagicSkill_239.btLevel > 2) and (m_MagicSkill_239.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[0]+ (m_MagicSkill_239.btLevel - 3) * g_Config.nSKILL_239NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[2]+ (m_MagicSkill_239.btLevel - 3) * g_Config.nSKILL_239NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_239.btLevel);
                    if (m_MagicSkill_239.btLevel > 2) and (m_MagicSkill_239.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[0]+ (m_MagicSkill_239.btLevel - 3) * g_Config.nSKILL_239NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_239NGStrong[2]+ (m_MagicSkill_239.btLevel - 3) * g_Config.nSKILL_239NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_239.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_239.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
            {$IFEND}
          end;
          Skill_230: begin//ŭ֮���ǿ��
            if m_MagicSkill_230 <> nil then begin
              if (m_MagicSkill_230.btLevel > 2) and (m_MagicSkill_230.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[0]+ (m_MagicSkill_230.btLevel - 3) * g_Config.nSKILL_230NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[2]+ (m_MagicSkill_230.btLevel - 3) * g_Config.nSKILL_230NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_230.btLevel);
                    if (m_MagicSkill_230.btLevel > 2) and (m_MagicSkill_230.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_230NGStrong[0]+ (m_MagicSkill_230.btLevel - 3) * g_Config.nSKILL_230NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSkill_230NGStrong[2]+ (m_MagicSkill_230.btLevel - 3) * g_Config.nSKILL_230NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_230.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_230.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_232: begin//ŭ֮��Ѫǿ��
            if m_MagicSkill_232 <> nil then begin
              if (m_MagicSkill_232.btLevel > 2) and (m_MagicSkill_232.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[0]+ (m_MagicSkill_232.btLevel - 3) * g_Config.nSKILL_232NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[2]+ (m_MagicSkill_232.btLevel - 3) * g_Config.nSKILL_232NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_232.btLevel);
                    if (m_MagicSkill_232.btLevel > 2) and (m_MagicSkill_232.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[0]+ (m_MagicSkill_232.btLevel - 3) * g_Config.nSKILL_232NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_232NGStrong[2]+ (m_MagicSkill_232.btLevel - 3) * g_Config.nSKILL_232NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_232.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_232.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_241: begin//ŭ֮����ǿ��
            {$IF M2Version = 1}
            if m_MagicSkill_241 <> nil then begin
              if (m_MagicSkill_241.btLevel > 2) and (m_MagicSkill_241.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[0]+ (m_MagicSkill_241.btLevel - 3) * g_Config.nSKILL_241NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[2]+ (m_MagicSkill_241.btLevel - 3) * g_Config.nSKILL_241NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_241.btLevel);
                    if (m_MagicSkill_241.btLevel > 2) and (m_MagicSkill_241.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[0]+ (m_MagicSkill_241.btLevel - 3) * g_Config.nSKILL_241NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_241NGStrong[2]+ (m_MagicSkill_241.btLevel - 3) * g_Config.nSKILL_241NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_241.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_241.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
            {$IFEND}
          end;
          Skill_228: begin//ŭ֮�����ǿ��
            if m_MagicSkill_228 <> nil then begin
              if (m_MagicSkill_228.btLevel > 2) and (m_MagicSkill_228.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[0]+ (m_MagicSkill_228.btLevel - 3) * g_Config.nSKILL_228NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[2]+ (m_MagicSkill_228.btLevel - 3) * g_Config.nSKILL_228NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_228.btLevel);
                    if (m_MagicSkill_228.btLevel > 2) and (m_MagicSkill_228.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[0]+ (m_MagicSkill_228.btLevel - 3) * g_Config.nSKILL_228NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_228NGStrong[2]+ (m_MagicSkill_228.btLevel - 3) * g_Config.nSKILL_228NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_228.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_228.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_234: begin//ŭ֮���ǻ���ǿ��
            if m_MagicSkill_234 <> nil then begin
              if (m_MagicSkill_234.btLevel > 2) and (m_MagicSkill_234.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[0]+ (m_MagicSkill_234.btLevel - 3) * g_Config.nSKILL_234NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[2]+ (m_MagicSkill_234.btLevel - 3) * g_Config.nSKILL_234NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_234.btLevel);
                    if (m_MagicSkill_234.btLevel > 2) and (m_MagicSkill_234.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[0]+ (m_MagicSkill_234.btLevel - 3) * g_Config.nSKILL_234NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_234NGStrong[2]+ (m_MagicSkill_234.btLevel - 3) * g_Config.nSKILL_234NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_234.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_234.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_208: begin//ŭ֮����ǿ��
            if m_MagicSkill_208 <> nil then begin
              if (m_MagicSkill_208.btLevel > 2) and (m_MagicSkill_208.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[0]+ (m_MagicSkill_208.btLevel - 3) * g_Config.nSKILL_208NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[2]+ (m_MagicSkill_208.btLevel - 3) * g_Config.nSKILL_208NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_208.btLevel);
                    if (m_MagicSkill_208.btLevel > 2) and (m_MagicSkill_208.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[0]+ (m_MagicSkill_208.btLevel - 3) * g_Config.nSKILL_208NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_208NGStrong[2]+ (m_MagicSkill_208.btLevel - 3) * g_Config.nSKILL_208NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_208.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_208.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;         
          Skill_214: begin//ŭ֮������ǿ��
            if m_MagicSkill_214 <> nil then begin
              if (m_MagicSkill_214.btLevel > 2) and (m_MagicSkill_214.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[0]+ (m_MagicSkill_214.btLevel - 3) * g_Config.nSKILL_214NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[2]+ (m_MagicSkill_214.btLevel - 3) * g_Config.nSKILL_214NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_214.btLevel);
                    if (m_MagicSkill_214.btLevel > 2) and (m_MagicSkill_214.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[0]+ (m_MagicSkill_214.btLevel - 3) * g_Config.nSKILL_214NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_214NGStrong[2]+ (m_MagicSkill_214.btLevel - 3) * g_Config.nSKILL_214NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_214.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_214.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_218: begin//ŭ֮���ѻ���ǿ��
            if m_MagicSkill_218 <> nil then begin
              if (m_MagicSkill_218.btLevel > 2) and (m_MagicSkill_218.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[0]+ (m_MagicSkill_218.btLevel - 3) * g_Config.nSKILL_218NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[2]+ (m_MagicSkill_218.btLevel - 3) * g_Config.nSKILL_218NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_218.btLevel);
                    if (m_MagicSkill_218.btLevel > 2) and (m_MagicSkill_218.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[0]+ (m_MagicSkill_218.btLevel - 3) * g_Config.nSKILL_218NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_218NGStrong[2]+ (m_MagicSkill_218.btLevel - 3) * g_Config.nSKILL_218NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_218.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_218.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_222: begin//ŭ֮�׵�ǿ��
            if m_MagicSkill_222 <> nil then begin
              if (m_MagicSkill_222.btLevel > 2) and (m_MagicSkill_222.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[0]+ (m_MagicSkill_222.btLevel - 3) * g_Config.nSKILL_222NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[2]+ (m_MagicSkill_222.btLevel - 3) * g_Config.nSKILL_222NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_222.btLevel);
                    if (m_MagicSkill_222.btLevel > 2) and (m_MagicSkill_222.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[0]+ (m_MagicSkill_222.btLevel - 3) * g_Config.nSKILL_222NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_222NGStrong[2]+ (m_MagicSkill_222.btLevel - 3) * g_Config.nSKILL_222NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_222.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_222.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_210: begin//ŭ֮�����ǿ��
            if m_MagicSkill_210 <> nil then begin
              if (m_MagicSkill_210.btLevel > 2) and (m_MagicSkill_210.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[0]+ (m_MagicSkill_210.btLevel - 3) * g_Config.nSKILL_210NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[2]+ (m_MagicSkill_210.btLevel - 3) * g_Config.nSKILL_210NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_210.btLevel);
                    if (m_MagicSkill_210.btLevel > 2) and (m_MagicSkill_210.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[0]+ (m_MagicSkill_210.btLevel - 3) * g_Config.nSKILL_210NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_210NGStrong[2]+ (m_MagicSkill_210.btLevel - 3) * g_Config.nSKILL_210NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_210.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_210.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_212: begin//ŭ֮��ǽǿ��
            if m_MagicSkill_212 <> nil then begin
              if (m_MagicSkill_212.btLevel > 2) and (m_MagicSkill_212.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[0]+ (m_MagicSkill_212.btLevel - 3) * g_Config.nSKILL_212NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[2]+ (m_MagicSkill_212.btLevel - 3) * g_Config.nSKILL_212NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_212.btLevel);
                    if (m_MagicSkill_212.btLevel > 2) and (m_MagicSkill_212.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[0]+ (m_MagicSkill_212.btLevel - 3) * g_Config.nSKILL_212NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_212NGStrong[2]+ (m_MagicSkill_212.btLevel - 3) * g_Config.nSKILL_212NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_212.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_212.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;          
          Skill_216: begin//ŭ֮�����Ӱǿ��
            if m_MagicSkill_216 <> nil then begin
              if (m_MagicSkill_216.btLevel > 2) and (m_MagicSkill_216.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[0]+ (m_MagicSkill_216.btLevel - 3) * g_Config.nSKILL_216NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[2]+ (m_MagicSkill_216.btLevel - 3) * g_Config.nSKILL_216NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_216.btLevel);
                    if (m_MagicSkill_216.btLevel > 2) and (m_MagicSkill_216.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[0]+ (m_MagicSkill_216.btLevel - 3) * g_Config.nSKILL_216NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_216NGStrong[2]+ (m_MagicSkill_216.btLevel - 3) * g_Config.nSKILL_216NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_216.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_216.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_224: begin//ŭ֮�����׹�ǿ��
            if m_MagicSkill_224 <> nil then begin
              if (m_MagicSkill_224.btLevel > 2) and (m_MagicSkill_224.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[0]+ (m_MagicSkill_224.btLevel - 3) * g_Config.nSKILL_224NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[2]+ (m_MagicSkill_224.btLevel - 3) * g_Config.nSKILL_224NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_224.btLevel);
                    if (m_MagicSkill_224.btLevel > 2) and (m_MagicSkill_224.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[0]+ (m_MagicSkill_224.btLevel - 3) * g_Config.nSKILL_224NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_224NGStrong[2]+ (m_MagicSkill_224.btLevel - 3) * g_Config.nSKILL_224NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_224.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_224.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_226: begin//ŭ֮������ǿ��
            if m_MagicSkill_226 <> nil then begin
              if (m_MagicSkill_226.btLevel > 2) and (m_MagicSkill_226.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[0]+ (m_MagicSkill_226.btLevel - 3) * g_Config.nSKILL_226NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[2]+ (m_MagicSkill_226.btLevel - 3) * g_Config.nSKILL_226NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_226.btLevel);
                    if (m_MagicSkill_226.btLevel > 2) and (m_MagicSkill_226.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[0]+ (m_MagicSkill_226.btLevel - 3) * g_Config.nSKILL_226NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_226NGStrong[2]+ (m_MagicSkill_226.btLevel - 3) * g_Config.nSKILL_226NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_226.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_226.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
          Skill_220: begin//ŭ֮������ǿ��
            if m_MagicSkill_220 <> nil then begin
              if (m_MagicSkill_220.btLevel > 2) and (m_MagicSkill_220.btLevel < g_Config.nNGSkillMaxLevel) then begin
                nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[0]+ (m_MagicSkill_220.btLevel - 3) * g_Config.nSKILL_220NGStrong[1]);
                nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[2]+ (m_MagicSkill_220.btLevel - 3) * g_Config.nSKILL_220NGStrong[3]);
                if (m_NGLevel >= nNeedNGLevel) and (nNeedItemCount > 0) then begin//�ж��ڹ��ȼ��Ƿ�ﵽ
                  if CheckItemCount(nNeedItemCount) then begin//��������
                    Inc(m_MagicSkill_220.btLevel);
                    if (m_MagicSkill_220.btLevel > 2) and (m_MagicSkill_220.btLevel < g_Config.nNGSkillMaxLevel) then begin
                      nNeedNGLevel:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[0]+ (m_MagicSkill_220.btLevel - 3) * g_Config.nSKILL_220NGStrong[1]);
                      nNeedItemCount:= _MIN(High(Word),g_Config.nSKILL_220NGStrong[2]+ (m_MagicSkill_220.btLevel - 3) * g_Config.nSKILL_220NGStrong[3]);
                    end else begin
                      nNeedNGLevel:= 0;
                      nNeedItemCount:= 0;
                    end;
                    SendMsg(Self, RM_HERONGMAGIC_LVEXP, m_MagicSkill_220.MagicInfo.wMagicId, nNeedNGLevel, m_MagicSkill_220.btLevel, nNeedItemCount, '');
                  end;
                end;
              end;
            end;
          end;
        end;//case wMagIdx
      finally
        TPlayObject(m_Master).m_boCanQueryBag:= False;//����ˢ�°���
      end;
    end;
  except
    MainOutMessage(format('{%s} THeroObject.ClientUpNGStrongSkill MagIdx:%d',[g_sExceptionVer, wMagIdx]));
  end;
end;
{$IFEND}
//�����Ӣ�۾���  20080110  nType 0-��ͨģʽ 1-�����ǵȼ�����
procedure THeroObject.GetExp(dwExp: uInt64; nType: Byte);
var
  nCode, K: Byte;
  dwTempExp, nMaxExp: uInt64;
begin
  nCode:= 0;
  try
    if (not m_boGhost) and (not m_boDeath) and (dwExp > 0) then begin//20090914 ����
      if (m_Master <> nil) then begin
        if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
          if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
            if (TPlayObject(m_Master).m_nHeroLevel1 - TPlayObject(m_Master).m_nHeroLevel2 <= 3) then begin//�����븱��Ӣ�۵ȼ����3������
              if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ�۵ȼ������������ȼ��������ȼ��������ܼ���������', c_Blue, t_Hint);
              Exit;
            end;
            dwExp:= Round((g_Config.nDeputyHeroExpRate / 100) * dwExp);
          end;
        end else Exit;
      end else Exit;
      m_GetExp:= dwExp;//Ӣ��ȡ�õľ���,<$HeroGetExp>����ʹ��  20081228
      if (g_FunctionNPC <> nil) and (m_Master <> nil) then begin//ȡ���鴥�� 20090101
        g_FunctionNPC.GotoLable( TPlayObject(m_Master), '@HeroGetExp', False, False);
      end;
      Inc(m_nWinExp, dwExp);
      nCode:= 4;
      if (m_Master <> nil) then begin//ֻ���͸������߹һ�����
        if (not m_Master.m_boGhost) then begin
          if (TPlayObject(m_Master).m_sDeputyHeroName <> '') and (not TPlayObject(m_Master).m_boCallDeputyHero)
            and (not m_Master.m_boDeath) then begin
            if TPlayObject(m_Master).m_nMainExp + dwExp <= High(LongWord) then begin//20110609 �޸�
              Inc(TPlayObject(m_Master).m_nMainExp, dwExp);
            end else begin
              TPlayObject(m_Master).m_nMainExp := High(LongWord);
            end;
          end;
          nCode:= 15;
          if not TPlayObject(m_Master).m_boNotOnlineAddExp then SendMsg({m_Master}Self, RM_HEROWINEXP, 0, dwExp, 0, 0, EncodeExp(m_Abil.nExp, dwExp));//20091114 �޸�
        end;
      end;
      nCode:= 1;
      if m_nWinExp >= g_Config.nWinExp then begin  //�ۼƾ���,�ﵽһ��ֵ,����Ӣ�۵��ҳ϶�(20080110)
        nCode:= 2;
        m_nWinExp:=0;
        m_nLoyal:=m_nLoyal + g_Config.nExpAddLoyal;
        if m_nLoyal > 10000 then m_nLoyal:= 10000;
        nCode:= 3;
        m_WAbil.nExp:= m_Abil.nExp;//20100121 ���ӣ�������Ӣ�۸����ҳ϶�ʱ��Ӣ����徭���䶯
        m_DefMsg := MakeDefaultMsg(SM_HEROABILITY, m_btGender, 0, m_btJob, m_nLoyal, 0);//����Ӣ�۵��ҳ϶� 20080306
        SendSocket(@m_DefMsg, EncodeBuffer(@m_WAbil, SizeOf(TAbility)));
      end;
      nCode:= 9;
      if m_Magic68Skill <> nil then begin//ѧ���������� 20080925
        nCode:= 10;
        if m_Magic68Skill.btLevel < 100 then Inc(m_Magic68Skill.nTranPoint, dwExp);
        nCode:= 11;
        nMaxExp:= GetSkill68Exp(m_Magic68Skill.btLevel);
        if m_Magic68Skill.nTranPoint >= nMaxExp then begin//������������,����������
          Dec(m_Magic68Skill.nTranPoint, nMaxExp);
          if m_Magic68Skill.btLevel < 100 then Inc(m_Magic68Skill.btLevel);
        end;
        nCode:= 13;
        if (Self <> nil) and (m_Magic68Skill.btLevel < 101) then begin
          nMaxExp:= GetSkill68Exp(m_Magic68Skill.btLevel);
          SendMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic68Skill.MagicInfo.wMagicId, nMaxExp, m_Magic68Skill.btLevel, m_Magic68Skill.nTranPoint, '');
        end;
      end;
      if (m_Abil.Level < g_Config.nLimitExpLevelHero) or (nType = 1) then begin//20110116 ����
        dwTempExp:= dwExp;
        if m_Abil.nExp >= uInt64(dwExp) then begin//20090101
          if (High(uInt64) - m_Abil.nExp) < uInt64(dwExp) then begin
            dwTempExp := High(uInt64) - m_Abil.nExp;
            dwExp:= dwExp - dwTempExp;
          end else dwExp:= 0;
        end else begin
          if (High(uInt64) - uInt64(dwExp)) < m_Abil.nExp then begin
            dwTempExp := High(uInt64) - uInt64(dwExp);
            dwExp:= dwExp - dwTempExp;
          end else dwExp:= 0;
        end;
        Inc(m_Abil.nExp, dwTempExp);
        dwTempExp:=0;
        if m_Abil.nMaxExp > m_Abil.nExp then begin
          if dwExp > 0 then begin
            dwTempExp:= (m_Abil.nMaxExp - m_Abil.nExp);
            if dwTempExp > 0 then begin
              if dwTempExp > dwExp then begin
                Inc(m_Abil.nExp, dwExp);
                dwExp:= 0;
              end else begin
                Inc(m_Abil.nExp, dwTempExp);
                dwExp:= dwExp - dwTempExp;
              end;
            end;
          end;
        end;
        nCode:= 14;
        if g_Config.boContinuousUpLevel then begin//20100605
          K:= 0;
          while (m_Abil.nExp >= m_Abil.nMaxExp) do begin//20100408 ѭ����������
            if (K >= 8) or m_boGhost or m_boDeath then Break;
            Inc(K);
            try
              if m_Abil.nExp <= 0 then begin
                m_Abil.nExp:= 0;
                Break;
              end;
              if (m_Master <> nil) then begin
                if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
                  if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
                    if (TPlayObject(m_Master).m_nHeroLevel1 - TPlayObject(m_Master).m_nHeroLevel2 <= 3) then begin//�����븱��Ӣ�۵ȼ����3������
                      if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ�۵ȼ������������ȼ��������ȼ��������ܼ���������', c_Blue, t_Hint);
                      Break;
                    end;
                  end;
                end;
              end;
              //if m_Abil.Exp >= m_Abil.MaxExp then begin
              nCode:= 6;
              Dec(m_Abil.nExp, m_Abil.nMaxExp);
              if dwExp > 0 then begin
                Inc(m_Abil.nExp, dwExp);
                dwExp:= 0;
              end;
              if (m_Abil.Level < MAXUPLEVEL) and ((m_Abil.Level < g_Config.nLimitExpLevelHero) or (nType = 1)) then Inc(m_Abil.Level);//20080715 �������Ƶȼ�
              nCode:= 16;
              if (m_Abil.Level < g_Config.nLimitExpLevelHero) or (nType = 1) then HasLevelUp(m_Abil.Level - 1);//20080715 �������Ƶȼ�
              nCode:= 7;
              if not m_boAI then begin
                AddGameDataLog('12' + #9 + m_sMapName + #9 + IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +//Ӣ��������¼��־ 20080911
                   m_sCharName + #9 +IntToStr(m_Abil.nExp)+'/'+IntToStr(m_Abil.nMaxExp) + #9 + IntToStr(m_Abil.Level) + #9 + '1' + #9 + '(Ӣ��)');
              end;
              nCode:= 8;
              IncHealthSpell(2000, 2000);
            except
              Break;
            end;
          end;
        end else begin
          if m_Abil.nExp >= m_Abil.nMaxExp then begin
            if (m_Master <> nil) then begin
              if (not m_Master.m_boDeath) and (not m_Master.m_boGhost) then begin
                if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
                  if (TPlayObject(m_Master).m_nHeroLevel1 - TPlayObject(m_Master).m_nHeroLevel2 <= 3) then begin//�����븱��Ӣ�۵ȼ����3������
                    if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ�۵ȼ������������ȼ��������ȼ��������ܼ���������', c_Blue, t_Hint);
                    Exit;
                  end;
                end;
              end;
            end;
            nCode:= 6;
            Dec(m_Abil.nExp, m_Abil.nMaxExp);
            if dwExp > 0 then begin
              Inc(m_Abil.nExp, dwExp);
              dwExp:= 0;
            end;
            if (m_Abil.Level < MAXUPLEVEL) and ((m_Abil.Level < g_Config.nLimitExpLevelHero) or (nType = 1)) then Inc(m_Abil.Level);//20080715 �������Ƶȼ�
            nCode:= 16;
            if (m_Abil.Level < g_Config.nLimitExpLevelHero) or (nType = 1) then HasLevelUp(m_Abil.Level - 1);//20080715 �������Ƶȼ�
            nCode:= 7;
            if not m_boAI then begin
              AddGameDataLog('12' + #9 + m_sMapName + #9 + IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +//Ӣ��������¼��־ 20080911
                 m_sCharName + #9 +IntToStr(m_Abil.nExp)+'/'+IntToStr(m_Abil.nMaxExp) + #9 + IntToStr(m_Abil.Level) + #9 + '1' + #9 + '(Ӣ��)');
            end;
            nCode:= 8;
            IncHealthSpell(2000, 2000);
          end;
        end;
      end;
    end;
  except
    //MainOutMessage(Format('{%s} THeroObject.GetExp Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
(*procedure THeroObject.GetExp(dwExp: LongWord);
var
  nCode, K:byte;
begin
  nCode:= 0;
  try
    if (not m_boGhost) and (not m_boDeath) and (dwExp > 0) then begin//20090914 ����
      if (m_Master <> nil) then begin
        if (not TPlayObject(m_Master).m_boDeath) and (not TPlayObject(m_Master).m_boGhost) then begin
          if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
            if (TPlayObject(m_Master).m_nHeroLevel1 - TPlayObject(m_Master).m_nHeroLevel2 <= 3) then begin//�����븱��Ӣ�۵ȼ����3������
              if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ�۵ȼ������������ȼ��������ȼ��������ܼ���������', c_Blue, t_Hint);
              Exit;
            end;
            dwExp:= Round((g_Config.nDeputyHeroExpRate / 100) * dwExp);
          end;
        end else Exit;
      end else Exit;
      if m_Abil.Exp >= LongWord(dwExp) then begin//20090101
        if (High(LongWord) - m_Abil.Exp) < LongWord(dwExp) then begin
          dwExp := High(LongWord) - m_Abil.Exp;
        end;
      end else begin
        if (High(LongWord) - LongWord(dwExp)) < m_Abil.Exp then begin
          dwExp := High(LongWord) - LongWord(dwExp);
        end;
      end;
      m_GetExp:= dwExp;//Ӣ��ȡ�õľ���,<$HeroGetExp>����ʹ��  20081228
      if (g_FunctionNPC <> nil) and (m_Master <> nil) then begin//ȡ���鴥�� 20090101
        g_FunctionNPC.GotoLable( TPlayObject(m_Master), '@HeroGetExp', False);
      end;
      Inc(m_nWinExp, dwExp);
      nCode:= 4;
      Inc(m_Abil.Exp, dwExp);
      nCode:= 14;
      if (m_Master <> nil) then begin//20090102 ֻ���͸������߹һ�����
        if (not TPlayObject(m_Master).m_boGhost) then begin
          if (TPlayObject(m_Master).m_sDeputyHeroName <> '') and (not TPlayObject(m_Master).m_boCallDeputyHero)
            and (not TPlayObject(m_Master).m_boDeath) then Inc(TPlayObject(m_Master).m_nMainExp, dwExp);
          nCode:= 15;
          if not TPlayObject(m_Master).m_boNotOnlineAddExp then SendMsg({m_Master}Self, RM_HEROWINEXP, 0, dwExp, 0, 0, '');//20091114 �޸�
        end;
      end;
      nCode:= 1;
      if m_nWinExp >= g_Config.nWinExp then begin  //�ۼƾ���,�ﵽһ��ֵ,����Ӣ�۵��ҳ϶�(20080110)
        nCode:= 2;
        m_nWinExp:=0;
        m_nLoyal:=m_nLoyal + g_Config.nExpAddLoyal;
        if m_nLoyal > 10000 then m_nLoyal:= 10000;
        nCode:= 3;
        m_WAbil.Exp:= m_Abil.Exp;//20100121 ���ӣ�������Ӣ�۸����ҳ϶�ʱ��Ӣ����徭���䶯
        m_DefMsg := MakeDefaultMsg(SM_HEROABILITY, m_btGender, 0, m_btJob, m_nLoyal, 0);//����Ӣ�۵��ҳ϶� 20080306
        SendSocket(@m_DefMsg, EncodeBuffer(@m_WAbil, SizeOf(TAbility)));
      end;
      K:= 0;
      while (m_Abil.Exp >= m_Abil.MaxExp) do begin//20100408 ѭ����������
        if K >= 8 then Break;
        Inc(K);
        if m_Abil.Exp <= 0 then begin
          m_Abil.Exp:= 0;
          Break;
        end;
        if (m_Master <> nil) then begin
          if (not TPlayObject(m_Master).m_boDeath) and (not TPlayObject(m_Master).m_boGhost) then begin
            if TPlayObject(m_Master).m_boCallDeputyHero and (n_HeroTpye = 3) then begin
              if (TPlayObject(m_Master).m_nHeroLevel1 - TPlayObject(m_Master).m_nHeroLevel2 <= 3) then begin//�����븱��Ӣ�۵ȼ����3������
                if TPlayObject(m_Master).m_boShowHeroLevel then SysMsg('���ĸ���Ӣ�۵ȼ������������ȼ��������ȼ��������ܼ���������', c_Blue, t_Hint);
                Break;
              end;
            end;
          end;
        end;
      //if m_Abil.Exp >= m_Abil.MaxExp then begin
        nCode:= 6;
        Dec(m_Abil.Exp, m_Abil.MaxExp);
        if (m_Abil.Level < MAXUPLEVEL) and (m_Abil.Level < g_Config.nLimitExpLevel) then Inc(m_Abil.Level);//20080715 �������Ƶȼ�
        nCode:= 16;
        if m_Abil.Level < g_Config.nLimitExpLevel then HasLevelUp(m_Abil.Level - 1);//20080715 �������Ƶȼ�
        //AddBodyLuck(100);
        nCode:= 7;
        AddGameDataLog('12' + #9 + m_sMapName + #9 + IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +//Ӣ��������¼��־ 20080911
             m_sCharName + #9 +IntToStr(m_Abil.Exp)+'/'+IntToStr(m_Abil.MaxExp) + #9 + IntToStr(m_Abil.Level) + #9 + '1' + #9 + '(Ӣ��)');
        nCode:= 8;
        IncHealthSpell(2000, 2000);
      end;
      nCode:= 9;
      if m_Magic68Skill <> nil then begin//ѧ���������� 20080925
        nCode:= 10;
        if m_Magic68Skill.btLevel < 100 then Inc(m_Magic68Skill.nTranPoint, dwExp);
        nCode:= 11;
        nMaxExp:= GetSkill68Exp(m_Magic68Skill.btLevel);
        if m_Magic68Skill.nTranPoint >= nMaxExp then begin//������������,����������
          Dec(m_Magic68Skill.nTranPoint, nMaxExp);
          if m_Magic68Skill.btLevel < 100 then Inc(m_Magic68Skill.btLevel);
        end;
        nCode:= 13;
        if (Self <> nil) and (m_Magic68Skill.btLevel < 101) then begin
          nMaxExp:= GetSkill68Exp(m_Magic68Skill.btLevel);
          SendMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic68Skill.MagicInfo.wMagicId, nMaxExp, m_Magic68Skill.btLevel, m_Magic68Skill.nTranPoint, '');
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.GetExp Code:%d',[g_sExceptionVer, nCode]));
  end;
end;*)
//�ܵ�Ŀ������
function THeroObject.RunToTargetXY(nTargetX, nTargetY: Integer): Boolean;
var
  nDir, n10, n14: Integer;
begin
  Result := False;
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//20080902 ����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] > 0) and (not g_ClientConf.boParalyCanSpell)) or
   (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
   or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20090526
  if not m_boCanRun then Exit;//��ֹ��,���˳� 20080810
  if GetTickCount()- {dwTick3F4}dwTick5F4 > m_dwRunIntervalTime then begin //20090526 �ܲ�ʹ�õ����ı�������
    n10 := nTargetX;
    n14 := nTargetY;
    nDir:= GetNextDirection(m_nCurrX , m_nCurrY, n10, n14);//20081005
    if not RunTo1(nDir, False, nTargetX, nTargetY) then begin//20090525 �޸ģ�RunTo1
      Result := WalkToTargetXY(nTargetX, nTargetY);
      if Result then {dwTick3F4}dwTick5F4 := GetTickCount();//20090526 �޸�
    end else begin
      if (abs(nTargetX - m_nCurrX) <= 1) and (abs(nTargetY - m_nCurrY) <= 1) then begin
        Result := True;
        {dwTick3F4}dwTick5F4 := GetTickCount();//20090526 �޸�
      end;
    end;
  end;
end;
//����Ŀ��
function THeroObject.WalkToTargetXY(nTargetX, nTargetY: Integer): Boolean;
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
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//20080902 ����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] <> 0) and (not g_ClientConf.boParalyCanSpell)) or
    (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
    or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20080915
  if (abs(nTargetX - m_nCurrX) > 1) or (abs(nTargetY - m_nCurrY) > 1) then begin
    if GetTickCount()- dwTick3F4 > m_dwWalkIntervalTime then begin //20080217 �����߼��
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
    end;//20080217
  end;
end;
//ת��
function THeroObject.WalkToTargetXY2(nTargetX, nTargetY: Integer): Boolean;
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
  if m_boTransparent and (m_boHideMode) then m_wStatusTimeArr[STATE_TRANSPARENT ] := 1;//20080902 ����,һ��������
  if ((m_wStatusTimeArr[POISON_STONE] <> 0) and (not g_ClientConf.boParalyCanSpell)) or
   (m_wStatusTimeArr[POISON_DONTMOVE] <> 0) or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0)
   or (m_wStatusArrValue[23] <> 0) then Exit;//��Բ����ܶ� 20080915
  if (nTargetX <> m_nCurrX) or (nTargetY <> m_nCurrY) then begin
    if GetTickCount()- dwTick3F4 > m_dwTurnIntervalTime then begin //20080217 ����ת����
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
    end;//20080217
  end;
end;

//20080828�޸�
function THeroObject.GotoTargetXY(nTargetX, nTargetY, nCode: Integer): Boolean;
begin
  case nCode of
    0:begin//����ģʽ
      if (abs(m_nCurrX - nTargetX) > 2{1}) or (abs(m_nCurrY - nTargetY) > 2{1}) then begin
        if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then begin//20080812 ����,������������
          Result := RunToTargetXY(nTargetX, nTargetY);
          //if (m_btJob = 0) and (not Result) then m_dwHitTick := GetTickCount();//20091123 ���ӣ�����սӢ������Ŀ�꣬ǰ�������� 20091127
        end else begin
          Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
        end;
      end else begin
        Result := WalkToTargetXY2(nTargetX, nTargetY); //ת��
      end;
    end;//0
    1:begin//���ģʽ
      if (abs(m_nCurrX - nTargetX) > 1) or (abs(m_nCurrY - nTargetY) > 1) then begin
        if m_wStatusTimeArr[STATE_LOCKRUN] = 0 then begin//20080812 ����,������������
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

function THeroObject.Operate(ProcessMsg: pTProcessMessage): Boolean;
var
  nCode: byte;//20090217
begin
  nCode:= 0;
  try
    //  Result:=False;
    case ProcessMsg.wIdent of
      RM_STRUCK: begin//��������
          nCode:= 1;
          if (ProcessMsg.BaseObject = Self) and (TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}) <> nil) then begin
            nCode:= 2;
            if not TBaseObject(ProcessMsg.nParam3).m_boDeath then begin//20090502 �޸�
              nCode:= 21;
              if (TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_PLAYOBJECT) then begin//20080531 ����
                nCode:= 3;
                if (not TBaseObject(ProcessMsg.nParam3).InSafeZone) and (not InSafeZone) then begin
                   nCode:= 4;
                   SetLastHiter(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}));//����������Լ�����
                   nCode:= 5;
                   Struck(TBaseObject(ProcessMsg.nParam3{AttackBaseObject}));
                   nCode:= 6;
                   BreakHolySeizeMode();
                end;
              end else begin
                nCode:= 7;
                SetLastHiter(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}));//����������Լ�����
                nCode:= 8;
                Struck(TBaseObject(ProcessMsg.nParam3 {AttackBaseObject}));
                nCode:= 9;
                BreakHolySeizeMode();
              end;
              nCode:= 10;
              if (m_Master <> nil) then begin//20090217 �޸�
                nCode:= 11;
                if (TBaseObject(ProcessMsg.nParam3) <> m_Master) and
                   ((TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_PLAYOBJECT) or
                   (TBaseObject(ProcessMsg.nParam3).m_btRaceServer = RC_HEROOBJECT)) then begin//Ӣ�ۻ�ɫ 20080721
                   nCode:= 12;
                   m_Master.SetPKFlag(TBaseObject(ProcessMsg.nParam3));
                end;
              end;
              nCode:= 13;
              if g_Config.boMonSayMsg then MonsterSayMsg(TBaseObject(ProcessMsg.nParam3), s_UnderFire);
            end;
          end;
          Result := True;
        end;
      else begin
        Result := inherited Operate(ProcessMsg);
      end;
    end;//case
  except
    MainOutMessage(Format('{%s} THeroObject.Operate Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
{ 20080117
function THeroObject.CompareHP(BaseObject1, BaseObject2: TBaseObject): Boolean;
var
  HP1, HP2: Integer;
begin
  HP1 := BaseObject1.m_WAbil.HP * 100 div BaseObject1.m_WAbil.MaxHP;
  HP2 := BaseObject2.m_WAbil.HP * 100 div BaseObject2.m_WAbil.MaxHP;
  Result := HP1 > HP2;
end;  

function THeroObject.CompareLevel(BaseObject1, BaseObject2: TBaseObject): Boolean;
begin
  Result := BaseObject1.m_WAbil.Level < BaseObject2.m_WAbil.Level;
end;  

function THeroObject.CompareXY(BaseObject1, BaseObject2: TBaseObject): Boolean;
var
  nXY1, nXY2: Integer;
begin
  nXY1 := abs(BaseObject1.m_nCurrX - m_nCurrX) + abs(BaseObject1.m_nCurrY - m_nCurrY);
  nXY2 := abs(BaseObject2.m_nCurrX - m_nCurrX) + abs(BaseObject2.m_nCurrY - m_nCurrY);
  Result := nXY1 > nXY2;
end;  }
//������
procedure THeroObject.Struck(hiter: TBaseObject);
begin
  if not m_boTarget then begin
    m_dwStruckTick := GetTickCount;
    if hiter <> nil then begin     {20080710ע��}                           {20080222 ע��}
      if (m_TargetCret = nil) {and (m_btStatus = 0)} and (not m_boTarget){  or GetAttackDir(m_TargetCret, btDir)or (Random(6) = 0)} then begin
        if IsProperTarget(hiter) then SetTargetCreat(hiter);//����ΪĿ��
      end;
    end;
    if m_boAnimal then begin
      m_nMeatQuality := m_nMeatQuality - Random(300);
      if m_nMeatQuality < 0 then m_nMeatQuality := 0;
    end;
  end;
  m_dwHitTick := m_dwHitTick + LongWord(150 - _MIN(130, m_Abil.Level * 4));
end;

procedure THeroObject.Attack(TargeTBaseObject: TBaseObject; nDir: Integer);
begin
  inherited AttackDir(TargeTBaseObject, m_wHitMode, nDir, 0);
  {$IF M2Version <> 2}
  m_dwIncNHTick := GetTickCount();
  {$IFEND}
end;

procedure THeroObject.DelTargetCreat;
begin
  inherited;
  m_nTargetX := -1;
  m_nTargetY := -1;
end;
//����Ŀ��
procedure THeroObject.SearchTarget;
var
  BaseObject, BaseObject18: TBaseObject;
  I, nC, n10: Integer;
  nCode: Byte;//20090510 ����
begin
  nCode:= 0;
  try
    if (m_TargetCret = nil) and m_boTarget then m_boTarget := False;
    if (m_TargetCret <> nil) and m_boTarget then begin
      if m_TargetCret.m_boDeath or m_TargetCret.m_boGhost then m_boTarget := False;//20090507 �޸�
    end;
    nCode:= 1;              //20090608 �����ػ�״̬һ������Ŀ�꣬�������Ƿ�Ϊ����״̬
    if ((m_btStatus = 0) or (m_boProtectStatus)) and (not m_boTarget) then begin//�ػ�״̬һ������Ŀ�� 20080402
      //����ͼֹͣ�ػ� By TasNat at: 2012-06-24 15:57:30
      if m_boProtectStatus and g_Config.boStopProtectOnChangMap and (m_Master <> nil) and (m_PEnvir <> m_Master.m_PEnvir) then begin
        m_boProtectStatus := False;  
        Exit;
      end;

      BaseObject18 := nil;
      n10 := 15;
      nCode:= 2;
      if m_VisibleActors.Count > 0 then begin
        nCode:= 3;
        for I := 0 to m_VisibleActors.Count - 1 do begin
          nCode:= 4;
          try
            BaseObject := TBaseObject(pTVisibleBaseObject(m_VisibleActors.Items[I]).BaseObject);
            nCode:= 5;
            if BaseObject <> nil then begin
              nCode:= 51;
              if not BaseObject.m_boDeath then begin
                nCode:= 6;
                if IsProperTarget(BaseObject) and (not BaseObject.m_boHideMode or m_boCoolEye) then begin
                  nCode:= 7;
                  nC := abs(m_nCurrX - BaseObject.m_nCurrX) + abs(m_nCurrY - BaseObject.m_nCurrY);
                  if nC < n10 then begin
                    n10 := nC;
                    BaseObject18 := BaseObject;
                  end;
                end;
              end;
            end;
          except
          end;
        end;
      end;
      nCode:= 8;
      if BaseObject18 <> nil then begin
        SetTargetCreat(BaseObject18);
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.SearchTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

procedure THeroObject.SetTargetXY(nX, nY: Integer);
begin
  m_nTargetX := nX;
  m_nTargetY := nY;
end;

procedure THeroObject.Wondering;
begin
  if (Random(10) = 0) then
    if (Random(4) = 1) then TurnTo(Random(8))
    else WalkTo(m_btDirection, False);
end;
//ħ���Ƿ���� 20080606
//UserMagic.btKey 0-���ܿ�,1--���ܹ�
function THeroObject.IsAllowUseMagic(wMagIdx: Word): Boolean;
var
  UserMagic: pTUserMagic;
begin
  Result := False;
  UserMagic := CheckUserMagic(wMagIdx);
  if UserMagic <> nil then begin
    {$IF M2Version <> 2}
    if wMagIdx in [SKILL_69, SKILL_101, SKILL_102] then begin//��������,Ψ�Ҷ����ж�����ֵ�Ƿ�ﵽ
      if (GetSpellPoint(UserMagic) < m_Skill69NH) and (UserMagic.btKey = 0) then Result := True;
    end else
    if wMagIdx in [SKILL_96, SKILL_97, SKILL_98] then begin//Ѫ��һ��,������ʱ����HP 20100930
      if (UserMagic.btKey = 0) then Result := True;
    end else
    {$IFEND}
    if (GetSpellPoint(UserMagic) < m_WAbil.MP) and (UserMagic.btKey = 0) then Result := True;
  end;
end;
//�ж�Ψ�Ҷ����Ƿ��3�������ж���Χ3���Ƿ��й�
function THeroObject.UseMagicToSkill102Level3: Boolean;
begin
  Result := False;
{$IF M2Version <> 2}
  if m_Magic102Skill <> nil then begin
    if (m_Magic102Skill.btLevel = 3) and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 3, 0) > 0) then Result := True;
  end;
{$IFEND}
end;

function THeroObject.SelectMagic(): Integer;
//var
//  I:integer;
//  Slave:TBaseObject ;
begin
  Result := 0;
  case m_btJob of
    0: begin //սʿ
        if IsAllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;
        {$IF M2Version <> 2}
        if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
          if IsAllowUseMagic(SKILL_101) then begin
            m_dwLatest101Tick := GetTickCount();
            Result := SKILL_101;
            Exit;
          end;
        end;
        if IsAllowUseMagic(SKILL_69) and ((GetTickCount -  m_dwLatest69Tick) > g_Config.nKill69UseTime * 1000)
          and ((GetTickCount - m_SkillUseTick[69]) > 3000) then begin//����ٵ�
          m_SkillUseTick[69] := GetTickCount();
          Result := SKILL_69;
          Exit;
        end;
        if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
          and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
          if IsAllowUseMagic(SKILL_102) then begin
            m_dwLatest102Tick := GetTickCount();
            Result := SKILL_102;
            Exit;
          end;
        end;
        {$IFEND}
        if (abs(m_TargetCret.m_nCurrX - m_nCurrX) < 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 3) and //20100927 ��������ŷ�Ѫ��һ��(ս)
           ((GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick) then begin//Ѫ��һ��(ս)
          if IsAllowUseMagic(SKILL_96) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
            m_SkillUseTick[0] := GetTickCount;
            Result := SKILL_96;
            Exit;
          end
        end;
        //Զ�������ÿ����ػ��������ս��� 20080603   20090115 ����
        if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) >= 2) and (abs(m_TargetCret.m_nCurrX - m_nCurrX) < 5)) or
          ((abs(m_TargetCret.m_nCurrY - m_nCurrY) >= 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 5)) then begin
          if IsAllowUseMagic(SKILL_74) and ((GetTickCount - m_dwLatestDailyTick) > 12000{12 * 1000}) then begin //���ս���
            m_boDailySkill := True;
            Result := SKILL_74;
            Exit;
          end;
        end;

        if IsAllowUseMagic(43) and ((GetTickCount - m_dwLatest42Tick) > g_Config.nKill43UseTime * 1000) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill43HPRate /100))) then begin //����ն  20090213
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
          if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            Result := SKILL_89;
            exit;
          end;
          if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            Result := 12;
            exit;
          end;
        end;
        if IsAllowUseMagic(SKILL_74) and ((GetTickCount - m_dwLatestDailyTick) > 12000{12 * 1000}) then begin //���ս��� 20080528
          m_boDailySkill := True;
          Result := SKILL_74;
          Exit;
        end;
        if IsAllowUseMagic(26) and ((GetTickCount - m_dwLatestFireHitTick) > 9000{9 * 1000}) then begin //�һ�  20080112 ����
          m_boFireHitSkill := True;
          Result := 26;
          Exit;
        end;
        if IsAllowUseMagic(42) and (GetTickCount - m_dwLatest43Tick > g_Config.nKill42UseTime * 1000) then begin //��Ӱ���� 20080619
          m_bo43kill := True;
          Result := 42;
          Exit;
        end;

        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
         and (m_TargetCret.m_Abil.Level < m_Abil.Level){ and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.8))} then begin //PKʱ,ʹ��Ұ����ײ  20080826 Ѫ����800ʱʹ��
          if IsAllowUseMagic(27) and ((GetTickCount - m_SkillUseTick[27]) >  10000{10 * 1000}) then begin //pkʱ����Է��ȼ����Լ��;�ÿ��һ��ʱ����һ��Ұ��  20080203
            m_SkillUseTick[27] := GetTickCount;
            Result := 27;
            Exit;
          end
        end else begin //���ʹ�� 20080323
          if IsAllowUseMagic(27) and ((GetTickCount - m_SkillUseTick[27]) > 10000{10 * 1000})
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
                if IsAllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if IsAllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7]:= GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if IsAllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] >  10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if IsAllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
            1:begin
                if IsAllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if IsAllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7]:= GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if IsAllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] >  10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if IsAllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if IsAllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
            2:begin
                if IsAllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
                  and (m_TargetCret.m_Abil.Level < m_Abil.Level) and
                  (((m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) or g_Config.boGroupMbAttackPlayObject) and
                  (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then begin
                  m_SkillUseTick[41] := GetTickCount; //ʨ�Ӻ�
                  Result := 41;
                  Exit;
                end;
                if IsAllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 10000{10 * 1000}) then begin
                   m_SkillUseTick[39] := GetTickCount; //Ӣ�۳��ض�
                   Result := 39;
                   Exit;
                end;
                if IsAllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) > 10000{10 * 1000}) then begin //��ɱ���� 20071213
                  m_SkillUseTick[7] := GetTickCount;
                  m_boPowerHit := True;//20080401 ������ɱ
                  Result := 7;
                  Exit;
                end;
                if IsAllowUseMagic(40) then begin //Ӣ�۱��µ���
                  if not m_boCrsHitkill then  SkillCrsOnOff(True);
                  Result := 40;
                  exit;
                end;
                if IsAllowUseMagic(SKILL_90) then begin//Բ���䵶(�ļ������䵶)
                  if CheckTargetXYCount2(SKILL_90) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 1);
                    Result := SKILL_90;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
                  if CheckTargetXYCount2(SKILL_BANWOL) > 0 then begin
                    if not m_boUseHalfMoon then  HalfMoonOnOff(True, 0);
                    Result := SKILL_BANWOL;
                    exit;
                  end;
                end;
                if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := SKILL_89;
                  exit;
                end;
                if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
                  if not m_boUseThrusting then ThrustingOnOff(True);
                  Result := 12;
                  exit;
                end;
              end;
          end;
        end else begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil)) and
           (CheckTargetXYCount1(m_nCurrX, m_nCurrY, 1) > 1) then begin//PK 20080915 ��߳���2��Ŀ���ʹ��
            if IsAllowUseMagic(40) and (GetTickCount - m_SkillUseTick[40] > 3000) then begin //Ӣ�۱��µ���
              m_SkillUseTick[40] := GetTickCount;
              if not m_boCrsHitkill then  SkillCrsOnOff(True);
              Result := 40;
              exit;
            end;
            if (GetTickCount - m_SkillUseTick[25] > 1500) then begin //Ӣ�۰����䵶
              if IsAllowUseMagic(SKILL_90) then begin //Բ���䵶(�ļ������䵶)
                if CheckTargetXYCount2(SKILL_90) > 0 then begin
                  if not m_boUseHalfMoon then HalfMoonOnOff(True, 1);
                  m_SkillUseTick[25]:= GetTickCount;
                  Result := SKILL_90;
                  exit;
                end;
              end;
              if IsAllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
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
          if IsAllowUseMagic(7)  and ((GetTickCount - m_SkillUseTick[7]) >  10000{10 * 1000}) then begin //��ɱ����
            m_SkillUseTick[7]:= GetTickCount;
            m_boPowerHit := True;//20080401 ������ɱ
            Result := 7;
            Exit;
          end;
          if (GetTickCount - m_SkillUseTick[12] > 1000) then begin
            if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
              if not m_boUseThrusting then ThrustingOnOff(True);
              m_SkillUseTick[12]:= GetTickCount;
              Result := SKILL_89;
              exit;
            end;
            if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
              if not m_boUseThrusting then ThrustingOnOff(True);
              m_SkillUseTick[12]:= GetTickCount;
              Result := 12;
              Exit;
            end;
          end;
        end;
         //�Ӹߵ���ʹ��ħ��,20080710
        if IsAllowUseMagic(43) and (GetTickCount - m_dwLatest42Tick > g_Config.nKill43UseTime * 1000) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill43HPRate /100))) then begin //����ն 20090213
          m_bo42kill := True;
          Result := 43;
          if (Random(g_Config.n43KillHitRate) = 0) and (g_Config.btHeroSkillMode43 or (m_TargetCret.m_Abil.Level <= m_Abil.Level)) then begin
           m_n42kill := 2;//�ػ�
          end else begin
           m_n42kill := 1;//���
          end;
          Exit;
        end else
        if IsAllowUseMagic(42) and (GetTickCount - m_dwLatest43Tick > g_Config.nKill42UseTime * 1000) then begin //��Ӱ����
          m_bo43kill := True;
          Result := 42;
          Exit;
        end else
        if IsAllowUseMagic(74) and (GetTickCount - m_dwLatestDailyTick > 12000) then begin //���ս���
          m_boDailySkill := True;
          Result := 74;
          Exit;
        end else
        if IsAllowUseMagic(26) and (GetTickCount - m_dwLatestFireHitTick > 9000) then begin //�һ�
          m_boFireHitSkill := True;
          Result := 26;
          Exit;
        end;
        if IsAllowUseMagic(40) and (GetTickCount - m_SkillUseTick[40] > 3000) and (CheckTargetXYCount1(m_nCurrX, m_nCurrY, 1) > 1) then begin //Ӣ�۱��µ���
          if not m_boCrsHitkill then SkillCrsOnOff(True);
          m_SkillUseTick[40]:= GetTickCount();
          Result := 40;
          exit;
        end;
        if IsAllowUseMagic(39) and (GetTickCount - m_SkillUseTick[39] > 3000) then begin//Ӣ�۳��ض�
           m_SkillUseTick[39]:= GetTickCount;
           Result := 39;
           Exit;
        end;
        if (GetTickCount - m_SkillUseTick[25] > 3000) then begin
          if IsAllowUseMagic(SKILL_90) then begin //Բ���䵶(�ļ������䵶)
            if not m_boUseHalfMoon then HalfMoonOnOff(True, 1);
            m_SkillUseTick[25]:= GetTickCount;
            Result := SKILL_90;
            exit;
          end;
          if IsAllowUseMagic(SKILL_BANWOL) then begin //Ӣ�۰����䵶
            if not m_boUseHalfMoon then HalfMoonOnOff(True, 0);
            m_SkillUseTick[25]:= GetTickCount;
            Result := SKILL_BANWOL;
            exit;
          end;
        end;
        if (GetTickCount - m_SkillUseTick[12] > 3000) then begin
          if IsAllowUseMagic(SKILL_89) then begin //�ļ���ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            m_SkillUseTick[12]:= GetTickCount;
            Result := SKILL_89;
            exit;
          end;
          if IsAllowUseMagic(12) then begin //Ӣ�۴�ɱ����
            if not m_boUseThrusting then ThrustingOnOff(True);
            m_SkillUseTick[12]:= GetTickCount;
            Result := 12;
            exit;
          end;
        end;
        if IsAllowUseMagic(7) and (GetTickCount - m_SkillUseTick[7] > 3000) then begin //��ɱ����
          m_boPowerHit := True;
          m_SkillUseTick[7]:= GetTickCount;
          Result := 7;
          Exit;
        end;
        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
         and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.6)) then begin //PKʱ,ʹ��Ұ����ײ
          if IsAllowUseMagic(27) and (GetTickCount - m_SkillUseTick[27] > 3000) then begin
            m_SkillUseTick[27]:= GetTickCount;
            Result := 27;
            Exit;
          end
        end else begin //���ʹ�� 20080323
          if IsAllowUseMagic(27) and (m_TargetCret.m_Abil.Level < m_Abil.Level) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.6))
           and (GetTickCount - m_SkillUseTick[27] > 3000) then begin
             m_SkillUseTick[27]:= GetTickCount;
             Result := 27;
             Exit;
          end;
        end;
        if IsAllowUseMagic(41) and (GetTickCount - m_SkillUseTick[41] >  10000{10 * 1000})
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
          if IsAllowUseMagic(66) then begin//4��ħ����
            Result := 66;
            Exit;
          end;
          if IsAllowUseMagic(31) then begin
            Result := 31;
            Exit;
          end;
        end;
        //�������� 20080925
        if IsAllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;

        //��������,��ʹ�÷����� 20080206
        if (m_SlaveList.Count = 0) and IsAllowUseMagic(46) and ((GetTickCount - m_dwLatest46Tick) > g_Config.nCopyHumanTick * 1000)//�ٻ�������
         and ((g_Config.btHeroSkillMode46) or (m_LastHiter<> nil) or (m_ExpHitter<> nil)) then begin
          if m_Magic46Skill <> nil then begin
            case m_Magic46Skill.btLevel of//�����ܵȼ����ȼ�����������ж��Ƿ��ʹ�÷�����
              0: begin
                if (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill46MaxHP_0 /100))) then begin//20080826 �ܵ�������,HP����80%��ʹ�÷���
                  Result := 46;
                  Exit;
                end;
              end;
              1: begin
                if (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill46MaxHP_1 /100))) then begin//1�� Ӣ���ٻ�����HP�ı��� 20081217
                  Result := 46;
                  Exit;
                end;
              end;
              2: begin
                if (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill46MaxHP_2 /100))) then begin//1�� Ӣ���ٻ�����HP�ı��� 20081217
                  Result := 46;
                  Exit;
                end;
              end;
              3: begin
                if (m_WAbil.HP <= Round(m_WAbil.MaxHP * (g_Config.nHeroSkill46MaxHP_3 /100))) then begin//1�� Ӣ���ٻ�����HP�ı��� 20081217
                  Result := 46;
                  Exit;
                end;
              end;
            end;//case
          end;
        end;
        {$IF M2Version <> 2}
        if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
          if IsAllowUseMagic(SKILL_101) then begin
            m_dwLatest101Tick := GetTickCount();
            Result := SKILL_101;
            Exit;
          end;
        end;
        if IsAllowUseMagic(SKILL_69) and ((GetTickCount -  m_dwLatest69Tick) > g_Config.nKill69UseTime * 1000)
          and ((GetTickCount - m_SkillUseTick[69]) > 3000) then begin//����ٵ�
          m_SkillUseTick[69] := GetTickCount();
          Result := SKILL_69;
          Exit;
        end;
        if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
          and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
          if IsAllowUseMagic(SKILL_102) then begin
            m_dwLatest102Tick := GetTickCount();
            Result := SKILL_102;
            Exit;
          end;
        end;
        {$IFEND}
        if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ��(��)
          if IsAllowUseMagic(SKILL_97) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
            m_SkillUseTick[0] := GetTickCount;
            Result := SKILL_97;
            Exit;
          end
        end;
        if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
         and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin //PKʱ,�Ա���������,ʹ�ÿ��ܻ�
          if IsAllowUseMagic(8) and ((GetTickCount - m_SkillUseTick[8]) > 3000{3 * 1000}) then begin
            m_SkillUseTick[8] := GetTickCount;
            Result := 8;
            Exit;
          end
        end else begin //���,�ּ������Լ�,�����йְ�Χ�Լ����� ���ܻ�
          if IsAllowUseMagic(8) and ((GetTickCount - m_SkillUseTick[8]) > 3000{3 * 1000})
            and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0)
            and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin
             m_SkillUseTick[8] := GetTickCount;
             Result := 8;
             Exit;
          end;
        end;

        if (m_nLoyal >= 500) and ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or
          (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil)) then begin
          if IsAllowUseMagic(45) and (GetTickCount - m_SkillUseTick[45] > 1300) then begin//�ҳ϶�5%ʱ��PKʱʹ������������ 20080828
            m_SkillUseTick[45] := GetTickCount;
            Result := 45;//Ӣ�������
            Exit;
          end;
        end else begin
          if IsAllowUseMagic(45) and (GetTickCount - m_SkillUseTick[45] > 3000{1000 * 3}) then begin
            m_SkillUseTick[45] := GetTickCount;
            Result := 45;//Ӣ�������
            Exit;
          end;
        end;

        if (GetTickCount - m_SkillUseTick[10] > 5000{1000 * 5}) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) then begin
          if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
           and (GetDirBaseObjectsCount(m_btDirection,5)> 0) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
            if IsAllowUseMagic(10) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 10;//Ӣ�ۼ����Ӱ  20080421
              Exit;
            end else
            if IsAllowUseMagic(9) then begin
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
            if IsAllowUseMagic(10) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 10;//Ӣ�ۼ����Ӱ  20080421
              Exit;
            end else
            if IsAllowUseMagic(9) then begin
              m_SkillUseTick[10] := GetTickCount;
              Result := 9;//������
              Exit;
            end;
          end;
        end;

        if IsAllowUseMagic(32) and (GetTickCount - m_SkillUseTick[32] > 10000{1000 * 10}) and (m_TargetCret.m_Abil.Level < g_Config.nMagTurnUndeadLevel) and
        (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level -1) then begin //Ŀ��Ϊ����ϵ
          m_SkillUseTick[32] := GetTickCount;
          Result := 32; //ʥ���� 20080710
          Exit;
        end;

        if CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 1 then begin //�������Χ    
          if IsAllowUseMagic(22) and (GetTickCount - m_SkillUseTick[22] > 10000{10 * 1000}) then begin
            if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102) and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ 20081217
              m_SkillUseTick[22] := GetTickCount;
              Result := 22; //��ǽ
              Exit;
            end;
          end;
          //�����׹�,ֻ������(101,102,104)������(91,92,97)��Ұ��(81)ϵ�е���   20080217
          //��������Ĺ�Ӧ�ö��õ����׹⣬�����׵��������ñ����� 20080228
          if m_TargetCret.m_btRaceServer in [91,92,97,101,102,104] then begin
            if IsAllowUseMagic(24) and (GetTickCount - m_SkillUseTick[24] > 4000{1000 * 4}) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
              m_SkillUseTick[24] := GetTickCount;
              Result := 24; //�����׹�
              Exit;
            end else
            if IsAllowUseMagic(91) then begin
              Result := 91; //�ļ��׵���
              Exit;
            end else
            if IsAllowUseMagic(11) then begin
              Result := 11; //Ӣ���׵���
              Exit;
            end else
            if IsAllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 2) > 2) then begin
              Result := 33; //Ӣ�۱�����
              Exit;
            end else
            if (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
              if IsAllowUseMagic(92) then begin
                m_SkillUseTick[58] := GetTickCount;
                Result := 92; //�ļ����ǻ���
                Exit;
              end;
              if IsAllowUseMagic(58) then begin
                m_SkillUseTick[58] := GetTickCount;
                Result := 58; //���ǻ��� 20080528
                Exit;
              end;
            end;
          end;

          case Random(4) of //���ѡ��ħ��
            0: begin
                //������,�����,�׵���,���ѻ���,Ӣ�۱�����,���ǻ��� �Ӹߵ���ѡ��
                if IsAllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 33; //Ӣ�۱�����
                  Exit;
                end else
                if IsAllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;

                if IsAllowUseMagic(37) then begin
                  Result := 37; //Ӣ��Ⱥ���׵�
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;//������
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;
              end;
            1: begin
                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if IsAllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58] := GetTickCount;
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin//������,�����,������,���ѻ���,������  �Ӹߵ���ѡ��
                  Result := 33;//������ 
                  Exit;
                end else
                if IsAllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1)  then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;
              end;
            2:begin
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if IsAllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin  //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;

                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
              end;
            3: begin
                if IsAllowUseMagic(44) then begin
                  Result := 44;//������
                  Exit;
                end;

                if IsAllowUseMagic(92) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 92; //�ļ����ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(58) and (GetTickCount - m_SkillUseTick[58] > 1500) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin
                  m_SkillUseTick[58]:= GetTickCount();
                  Result := 58; //���ǻ���
                  Exit;
                end else
                if IsAllowUseMagic(33) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin  //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 1) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11; //Ӣ���׵���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;

                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
              end;
          end;
        end else begin
         //ֻ��һ����ʱ���õ�ħ��
         // if CheckTargetXYCountOfDirection(m_nTargetX, m_nTargetY, m_btDirection, 3) = 1 then begin
            if IsAllowUseMagic(22) and (GetTickCount - m_SkillUseTick[22] > 10000{10 * 1000}) then begin
              if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102) and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ 20081217
                m_SkillUseTick[22] := GetTickCount;
                Result := 22;
                Exit;
              end;  
            end;
           case Random(4) of //���ѡ��ħ��
             0:begin
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if IsAllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) then begin //������,�����,������,���ѻ��� �Ӹߵ���ѡ��
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;
                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
             end;
             1:begin
                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if IsAllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;
             end;
             2:begin
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
                if IsAllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if IsAllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;

                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
             end;
             3: begin
                if IsAllowUseMagic(44) then begin
                  Result := 44;
                  Exit;
                end;
                if IsAllowUseMagic(91) then begin
                  Result := 91; //�ļ��׵���
                  Exit;
                end else
                if IsAllowUseMagic(11) then begin
                  Result := 11;//�׵���
                  Exit;
                end else
                if IsAllowUseMagic(33) then begin
                  Result := 33;
                  Exit;
                end else
                if IsAllowUseMagic(23) then begin
                  Result := 23; //���ѻ���
                  Exit;
                end else
                if IsAllowUseMagic(5) and (m_nLoyal < 500) then begin
                  Result := 5;//�����
                  Exit;
                end else
                if IsAllowUseMagic(1) and (m_nLoyal < 500) then begin
                  Result := 1;//������
                  Exit;
                end;

                if IsAllowUseMagic(37) then begin
                  Result := 37;
                  Exit;
                end;
                if IsAllowUseMagic(47) then begin
                  Result := 47;
                  Exit;
                end;
             end;
           //end;
           end;
        end;
      //�Ӹߵ���ʹ��ħ�� 20080710
        if (GetTickCount - m_SkillUseTick[58] > 1500) then begin
          if IsAllowUseMagic(92) then begin //�ļ����ǻ���
            m_SkillUseTick[58]:= GetTickCount;
            Result := 92;
            Exit;
          end;
          if IsAllowUseMagic(58) then begin //���ǻ���
            m_SkillUseTick[58]:= GetTickCount;
            Result := 58;
            Exit;
          end;
        end;
        if IsAllowUseMagic(47) then begin//������
          Result := 47;
          Exit;
        end;
        if IsAllowUseMagic(45) then begin//Ӣ�������
          Result := 45;
          Exit;
        end;
        if IsAllowUseMagic(44) then begin
          Result := 44;
          Exit;
        end;
        if IsAllowUseMagic(37) then begin//Ӣ��Ⱥ���׵�
          Result := 37;
          Exit;
        end;
        if IsAllowUseMagic(33) then begin//Ӣ�۱�����
          Result := 33;
          Exit;
        end;
        if IsAllowUseMagic(32) and (m_TargetCret.m_Abil.Level < g_Config.nMagTurnUndeadLevel) and
        (m_TargetCret.m_btLifeAttrib = LA_UNDEAD) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level -1) then begin //Ŀ��Ϊ����ϵ
          Result := 32; //ʥ���� 20080710
          Exit;
        end;
        if IsAllowUseMagic(24) and (CheckTargetXYCount(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 3) > 2) then begin//�����׹�
          Result := 24;
          Exit;
        end;
        if IsAllowUseMagic(23) then begin//���ѻ���
          Result := 23;
          Exit;
        end;
        if IsAllowUseMagic(91) then begin
          Result := 91; //�ļ��׵���
          Exit;
        end;
        if IsAllowUseMagic(11) then begin//Ӣ���׵���
          Result := 11;
          Exit;
        end;
        if IsAllowUseMagic(10) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
          Result := 10;//Ӣ�ۼ����Ӱ
          Exit;
        end;
        if IsAllowUseMagic(9) and m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 5, m_nTargetX, m_nTargetY) and
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)<=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)<=4)) or
          (((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=3) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=3))  or
          ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=4) and (Abs(m_nCurrY-m_TargetCret.m_nCurrY)=4)))) then begin
          Result := 9;//������
          Exit;
        end;
        if IsAllowUseMagic(5) then begin
          Result := 5;//�����
          Exit;
        end;
        if IsAllowUseMagic(1) then begin
          Result := 1;//������
          Exit;
        end;
        if IsAllowUseMagic(22) then begin
          if (m_TargetCret.m_btRaceServer <> 101) and (m_TargetCret.m_btRaceServer <> 102) and (m_TargetCret.m_btRaceServer <> 104) then begin//�������,�ŷŻ�ǽ 20081217
            Result := 22; //��ǽ
            Exit;
          end;
        end;
      end;
    2: begin //��ʿ
        (*//Ӣ��HPֵ���ڻ�����60%ʱ,ʹ�������� 20080204 �޸�
        if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) then begin //ʹ��������
          if IsAllowUseMagic(2) and (GetTickCount - m_SkillUseTick[2] > 3000{1000 * 3}) then begin {ʹ��������}
            m_SkillUseTick[2] := GetTickCount;  //20071226
            Result := 2;
            Exit;
          end;
        end;
        //����HPֵ���ڻ�����60%ʱ,ʹ��Ⱥ�������� 20080204 �޸�
        if (m_Master.m_WAbil.HP <= Round(m_Master.m_WAbil.MaxHP * 0.7)) then begin
          if CheckMasterXYOfDirection(m_Master,m_nTargetX, m_nTargetY, m_btDirection, 3)>=1 then begin //�ж�������Ӣ�۵ľ���
            if IsAllowUseMagic(29) and (GetTickCount - m_SkillUseTick[29] > 3000{1000 * 3}) then begin {ʹ��Ⱥ��������}
              m_SkillUseTick[29] := GetTickCount; //20071226
              Result := 29;
            end else
            if IsAllowUseMagic(2) and (GetTickCount - m_SkillUseTick[2] > 3000{1000 * 3}) then begin {ʹ��������}
              m_SkillUseTick[2] := GetTickCount;
              Result := 2;
            end;
          end else begin
            if IsAllowUseMagic(2) and (GetTickCount - m_SkillUseTick[2] > 3000{1000 * 3}) then begin {ʹ��������}
              m_SkillUseTick[2] := GetTickCount;  //20071226
              Result := 2;
            end;
          end;
          if Result > 0 then  Exit;
        end; *)
        if (m_SlaveList.Count = 0) and CheckHeroAmulet(1,5) and (GetTickCount - m_SkillUseTick[17] > 3000) and
        (IsAllowUseMagic(104) or IsAllowUseMagic(72) or IsAllowUseMagic(30) or IsAllowUseMagic(17)) and (m_WAbil.MP > 20) then begin
          m_SkillUseTick[17]:= GetTickCount;
          //Ĭ��,�Ӹߵ���
          if IsAllowUseMagic(104) then Result := 104//�ٻ�����
          else if IsAllowUseMagic(72) then Result := 72//�ٻ�����
          else if IsAllowUseMagic(30) then Result := 30//�ٻ�����
          else if IsAllowUseMagic(17) then Result := 17;//�ٻ�����
          Exit;
        end;

        if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) and (not m_boAbilMagBubbleDefence) then begin
          if IsAllowUseMagic(73) then begin//������ 20080909
            Result := 73;
            Exit;
          end;
        end;
        
        //�������� 20080925
        if IsAllowUseMagic(68) and (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin//�������� 20080925
          if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
            Result := 68;
            Exit;
          end;
        end;
        (*if CheckHeroAmulet(1,1) and (m_wStatusTimeArr[STATE_TRANSPARENT]= 0) then begin//�������Χʱ,����������,PKʱ���� 20110219 ע��
          if (CheckTargetXYCount(m_nCurrX, m_nCurrY, 2) > 1{2}) and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) //20090106
            and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin
            if IsAllowUseMagic(19) and (GetTickCount - m_SkillUseTick[19] > 8000) then begin//Ӣ��Ⱥ�������� 20081214
              m_SkillUseTick[19]:= GetTickCount;
              Result := 19;
              Exit;
            end else
            if IsAllowUseMagic(18) and (GetTickCount - m_SkillUseTick[18] > 8000) then begin//Ӣ�������� 20081214
              m_SkillUseTick[18]:= GetTickCount;
              Result := 18;
              Exit;
            end;
          end;
        end; *)
     {$IF M2Version <> 2}
      if (not m_boCanUerSkill101) and ((GetTickCount -  m_dwLatest101Tick) >= g_Config.nKill101UseTime * 1000) then begin//��������
        if IsAllowUseMagic(SKILL_101) then begin
          m_dwLatest101Tick := GetTickCount();
          Result := SKILL_101;
          Exit;
        end;
      end;
      if IsAllowUseMagic(SKILL_69) and ((GetTickCount -  m_dwLatest69Tick) > g_Config.nKill69UseTime * 1000)
        and ((GetTickCount - m_SkillUseTick[69]) > 3000) then begin//����ٵ�
        m_SkillUseTick[69] := GetTickCount();
        Result := SKILL_69;
        Exit;
      end;
      if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000)
        and ((m_wStatusTimeArr[POISON_STONE] > 0) or UseMagicToSkill102Level3) then begin//Ψ�Ҷ���
        if IsAllowUseMagic(SKILL_102) then begin
          m_dwLatest102Tick := GetTickCount();
          Result := SKILL_102;
          Exit;
        end;
      end;
      {$IFEND}
      if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ��(��)
        if IsAllowUseMagic(SKILL_98) and ((GetTickCount - m_SkillUseTick[0]) > 3000) then begin
          m_SkillUseTick[0] := GetTickCount;
          Result := SKILL_98;
          Exit;
        end
      end;

      if ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_Master <> nil))
       and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level <= m_WAbil.Level) then begin //PKʱ,�Ա���������,ʹ��������
        if IsAllowUseMagic(48) and ((GetTickCount - m_SkillUseTick[48]) > 3000{3 * 1000}) then begin
          m_SkillUseTick[48] := GetTickCount;
          Result := 48;
          Exit;
        end;
      end else begin //���,�ּ������Լ�,�����йְ�Χ�Լ����� ������
        if IsAllowUseMagic(48) and ((GetTickCount - m_SkillUseTick[48]) > 5000)//20090108 ��3��ĵ�5��
          and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0)
          and (m_TargetCret.m_WAbil.Level <= m_WAbil.Level)  then begin
           m_SkillUseTick[48] := GetTickCount;
           Result := 48;
           Exit;
        end;
      end;
      //�޼����� 20091204 �ƶ�λ��
      if IsAllowUseMagic(50) and (GetTickCount - m_SkillUseTick[50] > g_Config.nAbilityUpTick * 1000) and (m_wStatusArrValue[2]=0)
        and ((g_Config.btHeroSkillMode50) or (not g_Config.btHeroSkillMode50 and (m_TargetCret.m_Abil.HP >=700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER))) then begin//20080827
        m_SkillUseTick[50] := GetTickCount;
        Result := 50;
        Exit;
      end;

      if (m_TargetCret.m_wStatusTimeArr[POISON_DECHEALTH] = 0) and (not m_TargetCret.m_boUnPosion) and (GetUserItemList(2,1)>= 0) //�̶�
        and ((g_Config.btHeroSkillMode) or (not g_Config.btHeroSkillMode and (m_TargetCret.m_Abil.HP >=700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) or m_boTarget)
        and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) < 7{4}) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 7{4}))
        and (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153, 156..158])) then begin //����Ѫ������800�Ĺ���  �޸ľ��� 20080704 ������ǽ
        n_AmuletIndx:= 0;//20080413
        case Random(2) of
         0: begin
              if IsAllowUseMagic(38) and (GetTickCount - m_SkillUseTick[38] > 1000) then  begin
                if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                  if m_PEnvir.AllowMagics(SKILL_GROUPAMYOUNSUL, 1) then begin
                    m_SkillUseTick[38] := GetTickCount;
                    Result := SKILL_GROUPAMYOUNSUL;//Ӣ��Ⱥ��ʩ��
                    exit;
                  end;
                end;
              end else
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if IsAllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if IsAllowUseMagic(SKILL_AMYOUNSUL) then begin
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
                if IsAllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if IsAllowUseMagic(SKILL_AMYOUNSUL) then begin
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
        and ((g_Config.btHeroSkillMode) or (not g_Config.btHeroSkillMode and (m_TargetCret.m_Abil.HP >= 700)) or ((m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) or (m_TargetCret.m_btRaceServer = RC_PLAYMOSTER)) or m_boTarget)
        and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) < 7{4}) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 7{4}))
        and (not (m_TargetCret.m_btRaceServer in [55,79,109,110,111,128,143, 145, 147, 151, 153, 156..158])) then begin //����Ѫ������100�Ĺ��� ������ǽ
        n_AmuletIndx:= 0;//20080413
        case Random(2) of
         0: begin
              if IsAllowUseMagic(38) and (GetTickCount - m_SkillUseTick[38] > 1000) then  begin
                if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                  if m_PEnvir.AllowMagics(SKILL_GROUPAMYOUNSUL, 1) then begin
                    m_SkillUseTick[38] := GetTickCount;
                    Result := SKILL_GROUPAMYOUNSUL;//Ӣ��Ⱥ��ʩ��
                    exit;
                  end;
                end;
              end else
              if (GetTickCount - m_SkillUseTick[6] > 1000) then begin
                if IsAllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if IsAllowUseMagic(SKILL_AMYOUNSUL) then begin
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
                if IsAllowUseMagic(SKILL_93) then begin
                  if m_PEnvir <> nil then begin//�жϵ�ͼ�Ƿ����
                    if m_PEnvir.AllowMagics(SKILL_93, 1) then begin
                      m_SkillUseTick[6] := GetTickCount;
                      Result := SKILL_93;//Ӣ���ļ�ʩ����
                      Exit;
                    end;
                  end;
                end else
                if IsAllowUseMagic(SKILL_AMYOUNSUL) then begin
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
      if IsAllowUseMagic(51) and (GetTickCount - m_SkillUseTick[51] > 5000) then begin//Ӣ��쫷��� 20080917
        m_SkillUseTick[51] := GetTickCount;
        Result := 51;
        exit;
      end;
      if CheckHeroAmulet(1,1) then begin//ʹ�÷���ħ��
        case Random(3) of
          0:begin
            if IsAllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;
            if IsAllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if IsAllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin//20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
            if IsAllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������ 20090403 +6
              Result := 52; //Ӣ��������
              Exit;
            end;
          end;
          1:begin
            if IsAllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin//������ 20090403 +6
              Result := 52;
              Exit;
            end;
            if IsAllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;            
            if IsAllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if IsAllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin //20080401�޸��жϷ��ķ��� //20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
          end;//1
          2:begin
            if IsAllowUseMagic(13) and (GetTickCount - m_SkillUseTick[13] > 3000{1000}) then begin//20090106
              Result := 13; //Ӣ�������
              m_SkillUseTick[13]:= GetTickCount;//20080714
              exit;
            end;
            if IsAllowUseMagic(94) then begin
              Result := 94; //Ӣ���ļ���Ѫ��
              exit;
            end;
            if IsAllowUseMagic(59) then begin
              Result := 59; //Ӣ����Ѫ��
              exit;
            end;
            if IsAllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������  20090403 +6
              Result := 52;
              Exit;
            end;
          end;//2
        end;//case Random(3) of ��
        //���ܴӸߵ���ѡ�� 20080710
        if IsAllowUseMagic(94) then begin
          Result := 94; //Ӣ���ļ���Ѫ��
          exit;
        end;
        if IsAllowUseMagic(59) then begin//Ӣ����Ѫ��
          Result := 59;
          exit;
        end;
        if IsAllowUseMagic(54) then begin//Ӣ�������� 20080917
          Result := 54;
          exit;
        end;
        if IsAllowUseMagic(53) then begin//Ӣ��Ѫ�� 20080917
          Result := 53;
          exit;
        end;
        if IsAllowUseMagic(51) then begin//Ӣ��쫷��� 20080917
          Result := 51;
          exit;
        end;
        if IsAllowUseMagic(13) then begin//Ӣ�������
          Result := 13;
          exit;
        end;
        if IsAllowUseMagic(52) and (m_TargetCret.m_wStatusArrValue[m_TargetCret.m_btJob + 6] = 0) then begin //������ 20090403 +6
          Result := 52;
          Exit;
        end;
      end;//if CheckHeroAmulet(1,1) then begin//ʹ�÷���ħ��
    end;//��ʿ
  end;//case ְҵ
end;

//20080530 ���Ӽ���������ļ��
function THeroObject.CheckActionStatus(wIdent: Word; var dwDelayTime: LongWord): Boolean;
var
  dwCheckTime: LongWord;
  dwActionIntervalTime: LongWord;
begin
  Result := False;
  dwDelayTime := 0;
  //��������ͬ����֮��������ʱ��
  dwCheckTime := GetTickCount - m_dwActionTick;
  case wIdent of//20080923 �ϻ�������
    60..65: begin
        m_dwActionTick := GetTickCount();
        Result := True;
        Exit;
      end;
  end;
  dwActionIntervalTime := {m_dwActionIntervalTime}530;
  
  if dwCheckTime >= dwActionIntervalTime then begin
    m_dwActionTick := GetTickCount();
    Result := True;
  end else begin
    dwDelayTime := dwActionIntervalTime - dwCheckTime;
  end;
  m_wOldIdent := wIdent;
  m_btOldDir := m_btDirection;
end;
{//ȡ������Ϣ����  20080720 ����
function THeroObject.GetSpellMsgCount: Integer;
var
  I: Integer;
  SendMessage: pTSendMessage;
begin
  Result := 0;
  try
    EnterCriticalSection(ProcessMsgCriticalSection);
    if m_MsgList.Count > 0 then begin
      for I := 0 to m_MsgList.Count - 1 do begin
        SendMessage := m_MsgList.Items[I];
        if (SendMessage.wIdent = RM_SPELL) then begin
          Inc(Result);
        end;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
end;  }

//1 Ϊ����� 2 Ϊ��ҩ
function THeroObject.IsUseAttackMagic(): Boolean; //����Ƿ����ʹ�ù���ħ��
begin
  Result := False;
  if m_nSelectMagic <= 0 then Exit;
  case m_btJob of
    0, 1: Result := True;
    2: begin
        case m_nSelectMagic of
           SKILL_AMYOUNSUL {6 ʩ����},
           SKILL_93,//�ļ�ʩ����
           SKILL_GROUPAMYOUNSUL {38 Ⱥ��ʩ����}: begin
              Result := CheckHeroAmulet(2,1);
           end;
           SKILL_FIRECHARM {13},
           SKILL_HOLYSHIELD {16},
           SKILL_SKELLETON {17},
           SKILL_52,
           SKILL_59: begin //��Ҫ��
              Result := CheckHeroAmulet(1,1);
           end;
        end;//case
      end;//2
  end;
end;

function THeroObject.Think(): Boolean;
var
  nOldX, nOldY: Integer;
  UserMagicID: Integer;
  UserMagic: pTUserMagic;//20071224
  nCheckCode: Byte;
  I:integer;
  Slave:TBaseObject ;
resourcestring
  sExceptionMsg = '{%s} THeroObject.Think Code:%d';
begin
  Result := False;
  nCheckCode:= 0;
  Try
    if (m_Master = nil) then Exit;
    nCheckCode:= 66;
    if (m_Master.m_nCurrX = m_nCurrX) and (m_Master.m_nCurrY = m_nCurrY) then begin
      m_boDupMode := True;
    end else begin
      if (GetTickCount - m_dwThinkTick) > 1000 then begin
        nCheckCode:= 67;
        m_dwThinkTick := GetTickCount();
        nCheckCode:= 132;
        if m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) >= 2 then m_boDupMode := True;
        nCheckCode:= 13;
        if (m_TargetCret <> nil) then begin
          nCheckCode:= 131;
          if (not IsProperTarget(m_TargetCret)) then m_TargetCret := nil;
        end;
      end;
    end;
    {$IF M2Version = 1}
    nCheckCode:= 14;
    if (not m_boUseBatter) and (m_TargetCret <> nil) and (m_btStatus = 0) then HeroGetBatterMagic;//ȡ��������ID 20091103
    nCheckCode:= 15;
    if (m_TargetCret = nil) and m_boUseBatter then HeroBatterStop();//20091102 ������;��Ŀ�괦��
    if m_boUseBatter then Exit;//�����򲻴������¶��� 20090916
    {$IFEND}
    nCheckCode:= 1;
    if m_boDupMode and (m_btStatus <> 2) and (GetTickCount()- dwTick3F4 > m_dwWalkIntervalTime) then begin //20080603 �����߼��
      dwTick3F4 := GetTickCount();//20080603 ����
      nOldX := m_nCurrX;
      nOldY := m_nCurrY;
      WalkTo(Random(8), False);
      if (nOldX <> m_nCurrX) or (nOldY <> m_nCurrY) then begin
        m_boDupMode := False;
        Result := True;
      end;
    end;
    nCheckCode:= 253;
     case m_btJob of
       0: begin//սʿ
         nCheckCode:= 20;
         if (m_btStatus = 1) and (m_TargetCret <> nil) then begin//20080710 ����״̬����
           if CheckTargetXYCount(m_nCurrX, m_nCurrY, 3) > 1 then begin //�������Χʱʹ��ʨ�Ӻ�
             if IsAllowUseMagic(41) and (m_TargetCret.m_Abil.Level < m_Abil.Level) then begin
               UserMagic := FindMagic(41);
               if UserMagic <> nil then ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
             end;
           end else begin//Ұ��
             if IsAllowUseMagic(27) and (m_TargetCret.m_Abil.Level < m_Abil.Level) then begin
               UserMagic := FindMagic(27);
               if UserMagic <> nil then ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
             end;
           end;
           if (not m_boProtectStatus) then m_TargetCret:= nil;//20090608 ���ػ�״̬ʱ������Ŀ��
         end;
       end;
      1: begin //��ʦ
          nCheckCode:= 21;
          if (m_btStatus = 1) or (m_btStatus = 2) then begin//20090608 ����״̬����
            if (m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) and (not m_boAbilMagBubbleDefence) and boAutoOpenDefence then begin//20080930
              if IsAllowUseMagic(66) then begin//4��ħ����
                UserMagic := FindMagic(66);
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //ʹ��ħ����
              end else
              if IsAllowUseMagic(31) then begin
                UserMagic := FindMagic(31);
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //ʹ��ħ����
              end;
            end;
            if (m_TargetCret <> nil) then begin//20090606 �޸�
              if IsAllowUseMagic(8) and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin
                UserMagic := FindMagic(8);
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ�ÿ��ܻ�
              end;
              if (not m_boProtectStatus) then m_TargetCret:= nil;//20090608 ���ػ�״̬ʱ������Ŀ��
            end;
          end;
          //����ģʽ,һֱ����ħ���� 20080711
          if (m_btStatus =0) and(m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] = 0) and (not m_boAbilMagBubbleDefence) and boAutoOpenDefence then begin//20090608
            if IsAllowUseMagic(66) then begin
              UserMagic := FindMagic(66);
              m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
              m_dwHitTick := GetTickCount();//20080719
              if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
            end else
            if IsAllowUseMagic(31) then begin
              UserMagic := FindMagic(31);
              m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
              m_dwHitTick := GetTickCount();//20080719
              if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
            end;
          end;
        end;
      2: begin //��ʿ
          nCheckCode:= 254;
          if m_Master <> nil then begin//���˹һ�ʱ����ʹ�ü��� 20090427
            nCheckCode:= 253; 
            if (not TPlayObject(m_Master).m_boNotOnlineAddExp) and (m_TargetCret <> nil) then begin
              nCheckCode:= 28;
              if (m_nLoyal > 500) then begin//�ҳ϶ȳ���5%ʱ��PKʱ����ʹ����ʥս���� ����� 20080826
                if (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin
                  if IsAllowUseMagic(15) and (m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and CheckHeroAmulet(1,1) then begin //��ħ��
                    UserMagic := FindMagic(15);
                    m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                    if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //��ʥս����
                  end;
                  nCheckCode:= 29;
                  if IsAllowUseMagic(14) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and CheckHeroAmulet(1,1) then begin //����ħ��
                    UserMagic := FindMagic(14);
                    m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                    if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //�����
                  end;
                  nCheckCode:= 29;
                  if m_Master <> nil then begin//20090128
                    if MagCanHitTarget(m_nCurrX, m_nCurrY, m_Master) then begin//20090217 ħ���Ƿ���Դ�Ŀ��
                      if IsAllowUseMagic(15) and (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and (GetTickCount - m_SkillUseTick[15] > 1000 * 3) and CheckHeroAmulet(1,1) then begin //�����˴�ħ��
                        m_SkillUseTick[15] := GetTickCount;
                        UserMagic := FindMagic(15);
                        m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                        if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
                      end;
                      nCheckCode:= 26;
                      if IsAllowUseMagic(14) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and (GetTickCount - m_SkillUseTick[14] > 3000{1000 * 3}) and CheckHeroAmulet(1,1) then begin //�����˴�ħ��
                        m_SkillUseTick[14] := GetTickCount;
                        UserMagic := FindMagic(14);
                        m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                        if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
                      end;
                    end;
                  end;
                end;
              end else begin
                if IsAllowUseMagic(15) and (m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and CheckHeroAmulet(1,1) then begin //��ħ��
                  UserMagic := FindMagic(15);
                  m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                  if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //��ʥս����
                end;
                nCheckCode:= 29;
                if IsAllowUseMagic(14) and (m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and CheckHeroAmulet(1,1) then begin //����ħ��
                  UserMagic := FindMagic(14);
                  m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                  if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //�����
                end;
                if m_Master <> nil then begin//20090128
                  if MagCanHitTarget(m_nCurrX, m_nCurrY, m_Master) then begin//20090217 ħ���Ƿ���Դ�Ŀ��
                    if IsAllowUseMagic(15) and (m_Master.m_wStatusTimeArr[STATE_DEFENCEUP] = 0) and (GetTickCount - m_SkillUseTick[15] > 1000 * 3) and CheckHeroAmulet(1,1) then begin //�����˴�ħ��
                      m_SkillUseTick[15] := GetTickCount;
                      UserMagic := FindMagic(15);
                      m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                      if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
                    end;
                    nCheckCode:= 26;
                    if IsAllowUseMagic(14) and (m_Master.m_wStatusTimeArr[STATE_MAGDEFENCEUP] = 0) and (GetTickCount - m_SkillUseTick[14] > 3000{1000 * 3}) and CheckHeroAmulet(1,1) then begin //�����˴�ħ��
                      m_SkillUseTick[14] := GetTickCount;
                      UserMagic := FindMagic(14);
                      m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                      if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
                    end;
                  end;
                end;
              end;
            end;
          end;
          nCheckCode:= 27;
          if ((m_btStatus =1) or (m_btStatus = 2)) and (m_TargetCret <> nil) then begin//20090608 ����״̬����
            if IsAllowUseMagic(48) and (CheckTargetXYCount3(m_nCurrX, m_nCurrY, 1, 0) > 0) and (m_TargetCret.m_WAbil.Level < m_WAbil.Level) then begin
              UserMagic := FindMagic(48);
              m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
              if UserMagic <> nil then ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��������
            end;
            if (not m_boProtectStatus) then m_TargetCret:= nil;//20090608 ���ػ�״̬ʱ������Ŀ��
          end;
          if (m_btStatus <> 0) {and (m_ExpHitter <> nil)} then begin//20110219 �޸�
            if CheckHeroAmulet(1,1) and (m_wStatusTimeArr[STATE_TRANSPARENT]= 0) then begin//������ 20081223
              if IsAllowUseMagic(19) and (GetTickCount - m_SkillUseTick[19] > 8000) then begin
                m_SkillUseTick[19]:= GetTickCount;
                UserMagic := FindMagic(19);
                m_boIsUseMagic := False;//�Ƿ��ܶ��
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
              end else
              if IsAllowUseMagic(18) and (GetTickCount - m_SkillUseTick[18] > 8000) then begin
                m_SkillUseTick[18]:= GetTickCount;
                UserMagic := FindMagic(18);
                m_boIsUseMagic := False;//�Ƿ��ܶ��
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
              end;
            end;
            //m_ExpHitter:= nil;
          end;
          nCheckCode:= 22;
          if (m_TargetCret= nil) then begin
            //����HPֵ���ڻ�����60%ʱ,ʹ��������,�ȼ������ټ��Լ���Ѫ 20071201
            if (m_Master.m_WAbil.HP <= Round(m_Master.m_WAbil.MaxHP * 0.7)) and (m_WAbil.MP >10)
             and (GetTickCount - m_SkillUseTick[2] > 3000) then begin
              if IsAllowUseMagic(29) then begin
                m_SkillUseTick[2] := GetTickCount;
                UserMagic := FindMagic(29);
                m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
              end else
              if IsAllowUseMagic(2) then begin
                m_SkillUseTick[2] := GetTickCount;
                UserMagic := FindMagic(2);
                m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master); //ʹ��ħ��
              end;
            end;
            nCheckCode:= 23;
            if ((m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) or (m_wStatusTimeArr[POISON_DECHEALTH] > 0)) and//���̶�ʱʹ�������� 20110426
              (m_WAbil.MP > 10) and (GetTickCount - m_SkillUseTick[2] > 3000) then begin
              if IsAllowUseMagic(29) then begin
                m_SkillUseTick[2] := GetTickCount;
                UserMagic := FindMagic(29);
                m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, nil); //ʹ��ħ��
              end else
              if IsAllowUseMagic(2) then begin
                m_SkillUseTick[2] := GetTickCount;
                UserMagic := FindMagic(2);
                m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
                if UserMagic <> nil then ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, nil); //ʹ��ħ��
              end;
            end;
            //��Ŀ��ʱ����Ӣ��BB��Ѫ 20100831
            if (m_SlaveList.Count > 0) and (m_WAbil.MP > 10) and (GetTickCount - m_SkillUseTick[2] > 5000) then begin
              if IsAllowUseMagic(29) then begin
                for I := m_SlaveList.Count - 1 downto 0 do begin
                  Slave := TBaseObject(m_SlaveList.Items[I]);
                  if (Slave <> nil) then begin
                    if (not Slave.m_boDeath) and (not Slave.m_boGhost) and (Slave.m_WAbil.HP <= Round(Slave.m_WAbil.MaxHP * 0.7)) then begin
                      m_SkillUseTick[2] := GetTickCount;
                      UserMagic := FindMagic(29);
                      m_boIsUseMagic := False;//�Ƿ��ܶ��
                      if UserMagic <> nil then ClientSpellXY(UserMagic, Slave.m_nCurrX, Slave.m_nCurrY, Slave); //ʹ��ħ��
                      Break;
                    end;
                  end;
                end;
              end else
              if IsAllowUseMagic(2) then begin
                for I := m_SlaveList.Count - 1 downto 0 do begin
                  Slave := TBaseObject(m_SlaveList.Items[I]);
                  if (Slave <> nil) then begin
                    if (not Slave.m_boDeath) and (not Slave.m_boGhost) and (Slave.m_WAbil.HP <= Round(Slave.m_WAbil.MaxHP * 0.7)) then begin
                      m_SkillUseTick[2] := GetTickCount;
                      UserMagic := FindMagic(2);
                      m_boIsUseMagic := False;//�Ƿ��ܶ��
                      if UserMagic <> nil then ClientSpellXY(UserMagic, Slave.m_nCurrX, Slave.m_nCurrY, Slave); //ʹ��ħ��
                      Break;
                    end;
                  end;
                end;
              end;
            end;
          end;
          nCheckCode:= 24;                                                        //20090704 ����
          if (m_SlaveList.Count = 0) and (g_Config.boHeroNoTargetCall or (m_TargetCret <> nil))
            and CheckHeroAmulet(1,5) and (GetTickCount - m_SkillUseTick[17] > 3000) then begin// 20080615
            //Ĭ��,�Ӹߵ���
            if IsAllowUseMagic(104) then UserMagicID:= 104//�ٻ�����
            else if IsAllowUseMagic(72) then UserMagicID:= 72//�ٻ�����
            else if IsAllowUseMagic(30) then UserMagicID:= 30//�ٻ�����
            else if IsAllowUseMagic(17) then UserMagicID:= 17;//�ٻ�����

            if UserMagicID > 0 then begin //20080401 �޸�Ӣ���ٻ�����
              m_SkillUseTick[17]:=GetTickCount;
              UserMagic := FindMagic(UserMagicID);
              m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080719
              if UserMagic <> nil then begin
                m_dwMagicAttackTick:= 0;//�ñ���������ֱ���ٻ�����
                ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self); //ʹ��ħ��
              end;
            end; //if UserMagicID > 0 then
          end;//if (m_SlaveList.Count=0)  then begin
          nCheckCode:= 25;
          if ((GetTickCount - m_dwCheckNoHintTick) > 30000{30 * 1000}) and (not m_boIsUseAttackMagic) and (m_btStatus = 0) then begin//20080401 û������ʾ
            m_dwCheckNoHintTick:= GetTickCount;
            if IsAllowUseMagic(13) or IsAllowUseMagic(59) or IsAllowUseMagic(94) then begin
              if not CheckHeroAmulet(1,1) then SysMsg('(Ӣ��) ����������꣡', c_Green, t_Hint);
            end;
            if IsAllowUseMagic(6) or IsAllowUseMagic(38) then begin
              if not CheckHeroAmulet(2,1) then SysMsg('(Ӣ��) ��ɫ��ҩ�Ѿ��꣡', c_Green, t_Hint);
              if not CheckHeroAmulet(2,2) then SysMsg('(Ӣ��) ��ɫ��ҩ�Ѿ��꣡', c_Green, t_Hint);
            end;
          end;
       end;
     end;//case
     nCheckCode:= 3;
    //Ӣ���ҳ϶ȴﵽָ��ֵ������ؼ���(��������һ𽣷��������)��3�����Զ��л����ļ�״̬  20080111
    if m_nLoyal >=g_Config.nGotoLV4 then begin
      case m_btJob of
        0:begin
          UserMagic := FindMagic(26);
          if UserMagic <> nil then begin
            if UserMagic.btLevel=3 then begin
              UserMagic.btLevel:=4;//����Ϊ4������
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
              SysMsg('�����������ܵĹ�ϵ,����Ӣ���Ѿ�������4���һ𽣷�!' , BB_Fuchsia, t_Hint);
            end;
          end;
        end;
        1:begin
          UserMagic := FindMagic(45);
           if UserMagic <> nil then begin
            if UserMagic.btLevel=3 then begin
              UserMagic.btLevel:=4;//����Ϊ4������
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
              SysMsg('�����������ܵĹ�ϵ,����Ӣ���Ѿ�������4�������!' , BB_Fuchsia, t_Hint);
            end;
          end;
        end;
        2:begin
          UserMagic := FindMagic(13);
          if UserMagic <> nil then begin
            if UserMagic.btLevel=3 then begin
              UserMagic.btLevel:=4;//����Ϊ4������
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
              SysMsg('�����������ܵĹ�ϵ,����Ӣ���Ѿ�������4�������!' , BB_Fuchsia, t_Hint);
            end;
          end;
        end;
      end;
    end else begin //�ҳ϶ȵ��ڴ���ֵʱ,4����Ϊ3�� 20080609
      case m_btJob of
        0:begin
          UserMagic := FindMagic(26);
          if UserMagic <> nil then begin
            if UserMagic.btLevel=4 then begin
              UserMagic.btLevel:=3;//4����Ϊ3��
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
            end;
          end;
        end;
        1:begin
          UserMagic := FindMagic(45);
           if UserMagic <> nil then begin
            if UserMagic.btLevel=4 then begin
              UserMagic.btLevel:=3;//4����Ϊ3��
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
            end;
          end;
        end;
        2:begin
          UserMagic := FindMagic(13);
          if UserMagic <> nil then begin
            if UserMagic.btLevel=4 then begin
              UserMagic.btLevel:=3;//4����Ϊ3��
              SendUpdateDelayMsg(m_Master, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 800);
            end;
          end;
        end;
      end;
    end;

    nCheckCode:= 4;
    if SearchIsPickUpItem then SearchPickUpItem(1000);//����Ʒ 20071224

    nCheckCode:= 6;
    if m_Master <> nil then begin//20090128 ����
      if not m_Master.m_boGhost then begin//20090426 ���� 20090722 �޸�
        if ((m_btStatus = 1) or ((m_btStatus = 0) and ((m_TargetCret = nil) or (not g_Config.boHeroAttackNoFollow))) or ((m_btStatus = 2) and (not g_Config.boRestNoFollow))) and
          (not m_boProtectStatus) and //20080222 ����,���˻���ͼ,Ӣ������һ����
          (m_PEnvir <> m_Master.m_PEnvir) and //����ͬ����ͼʱ�ŷ� 20080409
          ((abs(m_nCurrX - m_Master.m_nCurrX) > 20) or //20090723 12��Ϊ20
          (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
          nCheckCode:= 61;
          //20090426 ���ӣ������˵����������㴫�ͺ������,��ֹ���ͺ��������ص�����
          m_Master.GetBackPosition(nOldX, nOldY);
          nCheckCode:= 62;
          if (abs(m_nTargetX - nOldX) > 2{1}) or (abs(m_nTargetY - nOldY ) > 2{1}) then begin
            m_nTargetX := nOldX;
            m_nTargetY := nOldY;
            nCheckCode:= 63;
            if (abs(m_nCurrX - nOldX) <= 3{2}) and (abs(m_nCurrY - nOldY) <= 3{2}) then begin
              nCheckCode:= 64;
              if m_PEnvir.GetMovingObject(nOldX, nOldY, True) <> nil then begin
                m_nTargetX := m_nCurrX;
                m_nTargetY := m_nCurrY;
              end;
            end;
          end;
          nCheckCode:= 65;
          SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
        end;
      end;
    end;
  except
    MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
  end;
end;

function THeroObject.SearchIsPickUpItem(): Boolean;
var
  VisibleMapItem: pTVisibleMapItem;
  MapItem: PTMapItem;
  I: Integer;
  nCurrX, nCurrY: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if m_boAI then Exit;
    if (m_Master = nil) or (g_AllowPickUpItemList.Count = 0) then Exit;
    if (m_Master <> nil) and (m_Master.m_boDeath) then Exit;
    if (m_btStatus = 2) or (m_TargetCret <> nil) then Exit;
    if m_boProtectStatus and (not g_Config.boProtectPickUpItem) then Exit;//20090723 �ػ�ʱ�ɼ���Ʒ����
    nCode:= 3;
    if m_VisibleItems.Count = 0 then Exit;
    nCode:= 4;
    if GetTickCount < m_dwSearchIsPickUpItemTime then Exit;
    if (not IsEnoughBag) {or (not m_boCanPickUpItem) }then Exit; //20080428 ע��
    if m_Master <> nil then begin
      nCurrX := m_Master.m_nCurrX;
      nCurrY := m_Master.m_nCurrY;
      if m_boProtectStatus then begin
        nCurrX := m_nProtectTargetX;
        nCurrY := m_nProtectTargetY;
      end;
      if (abs(nCurrX - m_nCurrX) > 15) or (abs(nCurrY - m_nCurrY) > 15) then begin
        //m_dwSearchIsPickUpItemTick := GetTickCount;
        m_dwSearchIsPickUpItemTime := GetTickCount + 5000{1000 * 5};
        Exit;
      end;
    end;
    {m_dwSearchIsPickUpItemTick := GetTickCount;
    m_dwSearchIsPickUpItemTime := 1000;}
    nCode:= 10;
    if m_VisibleItems.Count > 0 then begin
      for I := 0 to m_VisibleItems.Count - 1 do begin
        nCode:= 11;
        VisibleMapItem := pTVisibleMapItem(m_VisibleItems.Items[I]);
        nCode:= 12;
        if (VisibleMapItem <> nil) then begin
          if (VisibleMapItem.nVisibleFlag > 0) then begin
            MapItem := VisibleMapItem.MapItem;
            nCode:= 13;
            if (MapItem <> nil) then begin
              if (m_Master <> nil) then begin//20080825 �޸�
                nCode:= 14;
                if MapItem.DropBaseObject <> nil then begin//20080803 ����
                  nCode:= 15;
                  if (MapItem.DropBaseObject <> m_Master) then begin
                    nCode:= 16;
                    if IsAllowPickUpItem(VisibleMapItem.sName) and IsAddWeightAvailable(UserEngine.GetStdItemWeight(MapItem.UserItem.wIndex)) then begin
                        //if (MapItem.DropBaseObject <> nil) and (TBaseObject(MapItem.DropBaseObject).m_btRaceServer = RC_PLAYOBJECT) then Continue;
                      nCode:= 17;
                      if (MapItem.OfBaseObject = nil) or (MapItem.OfBaseObject = m_Master) or (MapItem.OfBaseObject = Self)  then begin
                        nCode:= 18;
                        if (abs(VisibleMapItem.nX - m_nCurrX) <= 5) and (abs(VisibleMapItem.nY - m_nCurrY) <= 5) then begin
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
        end;
      end;
    end;
  except
    //MainOutMessage('{�쳣} THeroObject.SearchIsPickUpItem Code:'+inttostr(nCode));
  end;
end;
//δʹ�õĺ���
function THeroObject.GotoTargetXYRange(): Boolean;
var
  n10: Integer;
  n14: Integer;
  nTargetX: Integer;
  nTargetY: Integer;
begin
  Result := True;
  nTargetX := 0;//20080529
  nTargetY := 0;//20080529
  n10 := abs(m_TargetCret.m_nCurrX - m_nCurrX);
  n14 := abs(m_TargetCret.m_nCurrY - m_nCurrY);
  if n10 > 4 then Dec(n10, 5) else n10 := 0;
  if n14 > 4 then Dec(n14, 5) else n14 := 0;
  if m_TargetCret.m_nCurrX > m_nCurrX then nTargetX := m_nCurrX + n10;
  if m_TargetCret.m_nCurrX < m_nCurrX then nTargetX := m_nCurrX - n10;
  if m_TargetCret.m_nCurrY > m_nCurrY then nTargetY := m_nCurrY + n14;
  if m_TargetCret.m_nCurrY < m_nCurrY then nTargetY := m_nCurrY - n14;
  Result := GotoTargetXY(nTargetX, nTargetY ,0);
end;

function THeroObject.AutoAvoid(): Boolean; //�Զ����
 { function GetAvoidDir(): Integer;
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
  end;}
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
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Dec(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Dec(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_UPRIGHT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Inc(nTargetX, 1);
              Dec(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(nTargetX, 1);
              Dec(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end; 
        DR_RIGHT: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Inc(nTargetX, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(nTargetX, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWNRIGHT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Inc(nTargetX, 1);
              Inc(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(nTargetX, 1);
              Inc(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWN: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Inc(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Inc(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_DOWNLEFT: begin//����
            if m_PEnvir.CanWalk(nTargetX, nTargetY,False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Dec(nTargetX, 1);
              Inc(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Dec(nTargetX, 1);
              Inc(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_LEFT: begin//��
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Dec(nTargetX, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Dec(nTargetX, 1);
              Inc(n01);
              Continue;
            end;
          end;
        DR_UPLEFT: begin//������
            if m_PEnvir.CanWalk(nTargetX, nTargetY, False) and (CheckTargetXYCountOfDirection(nTargetX, nTargetY, nDir, 1) = 0) then begin
              Dec(nTargetX, 1);
              Dec(nTargetY, 1);
              Result := True;
              Break;
            end else begin
              if n01 >= 2 then Break;
              Dec(nTargetX, 1);
              Dec(nTargetY, 1);
              Inc(n01);
              Continue;
            end;
          end;
        else Break;
      end;
    end;
  end;
  {function GetAvoidXY(var nTargetX, nTargetY: Integer): Boolean;
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
  end;}
  function GotoMasterXY(var nTargetX, nTargetY: Integer): Boolean;
  var
    nDir: Integer;
  begin
    Result := False;
    if (m_Master <> nil) and ((abs(m_Master.m_nCurrX - m_nCurrX) > 5) or (abs(m_Master.m_nCurrY - m_nCurrY) > 5)) and (not m_boProtectStatus) then begin
      nTargetX := m_nCurrX;
      nTargetY := m_nCurrY;
      nDir := GetDirXY(m_Master.m_nCurrX, m_Master.m_nCurrY);
      case nDir of
        DR_UP: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UPRIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_UPRIGHT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UPLEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_UPLEFT;
            end;
          end;
        DR_UPRIGHT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UP, nTargetX, nTargetY);
              m_btLastDirection := DR_UP;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_RIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_RIGHT;
            end;
          end;
        DR_RIGHT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UPRIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_UPRIGHT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNRIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWNRIGHT;
            end;
          end;
        DR_DOWNRIGHT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_RIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_RIGHT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWN, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWN;
            end;
          end;
        DR_DOWN: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNRIGHT, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWNRIGHT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNLEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWNLEFT;
            end;
          end;
        DR_DOWNLEFT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWN, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWN;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_LEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_LEFT;
            end;
          end;
        DR_LEFT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_DOWNLEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_DOWNLEFT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UPLEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_UPLEFT;
            end;
          end;
        DR_UPLEFT: begin
            Result := GetGotoXY(nDir, nTargetX, nTargetY);
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_LEFT, nTargetX, nTargetY);
              m_btLastDirection := DR_LEFT;
            end;
            if not Result then begin
              nTargetX := m_nCurrX;
              nTargetY := m_nCurrY;
              Result := GetGotoXY(DR_UP, nTargetX, nTargetY);
              m_btLastDirection := DR_UP;
            end;
          end;
      end;
    end;
  end;
var
  nTargetX: Integer;
  nTargetY: Integer;
  nDir: Integer;
begin
  Result := True;
  if (m_TargetCret <> nil) and not m_TargetCret.m_boDeath then begin
    if GotoMasterXY(nTargetX, nTargetY) then begin
      Result := GotoTargetXY(nTargetX, nTargetY, 1);
    end else begin
      nTargetX := m_nCurrX ;
      nTargetY := m_nCurrY ;
      nDir:= GetNextDirection(m_nCurrX,m_nCurrY,m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY);
      nDir:= GetBackDir(nDir);
      m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX,m_TargetCret.m_nCurrY,nDir,{5}4,m_nTargetX,m_nTargetY);
      Result :=GotoTargetXY(m_nTargetX, m_nTargetY, 1);
    end;
  end;
end;
//Ӣ���Զ�����Ʒ
function THeroObject.SearchPickUpItem(nPickUpTime: Integer): Boolean;
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
        if (m_Master <> nil) and (not m_Master.m_boDeath) then begin //�񵽵�Ǯ�Ӹ�����
          if TPlayObject(m_Master).IncGold(MapItem.Count) then begin
            SendRefMsg(RM_ITEMHIDE, 0, Integer(MapItem), nX, nY, '');
            if g_boGameLogGold then
              AddGameDataLog('4' + #9 +
                m_sMapName + #9 +
                IntToStr(nX) + #9 +
                IntToStr(nY) + #9 +
                m_sCharName + #9 +
                sSTRING_GOLDNAME + #9 +
                IntToStr(MapItem.Count) + #9 +
                '1' + #9 +'0');
            Result := True;
            m_Master.GoldChanged;
            SetHideItem(MapItem);
            Dispose(MapItem);
          end else begin
            m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
          end;
        end else begin
          m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
        end;
      end else begin
        m_PEnvir.AddToMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem));
      end;
    end else begin //����Ʒ
      if (MapItem.UserItem.wIndex > 0) and (MapItem.UserItem.AddValue[0] = 1) and
        (GetHoursCount(MapItem.UserItem.MaxDate, Now) <= 0) then begin //ɾ������װ��
        Dispose(MapItem);
        Exit;
      end;
      if (MapItem.UserItem.wIndex > 0) and (MapItem.UserItem.AddValue[0] in [2..3]) then Exit;
      StdItem := UserEngine.GetStdItem(MapItem.UserItem.wIndex);
      if StdItem <> nil then begin
        if m_PEnvir.DeleteFromMap(nX, nY, OS_ITEMOBJECT, TObject(MapItem)) = 1 then begin
          New(UserItem);
          FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
          //FillChar(UserItem^.btValue, SizeOf(UserItem^.btValue), 0);//20080820 ����
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
              if StdItem.NeedIdentify = 1 then
                AddGameDataLog('4' + #9 + m_sMapName + #9 +
                  IntToStr(nX) + #9 + IntToStr(nY) + #9 +
                  m_sCharName + #9 + StdItem.Name + #9 +
                  IntToStr(UserItem.MakeIndex) + #9 +
                  '('+IntToStr(LoWord(StdItem.DC))+'/'+IntToStr(HiWord(StdItem.DC))+')'+
                  '('+IntToStr(LoWord(StdItem.MC))+'/'+IntToStr(HiWord(StdItem.MC))+')'+
                  '('+IntToStr(LoWord(StdItem.SC))+'/'+IntToStr(HiWord(StdItem.SC))+')'+
                  '('+IntToStr(LoWord(StdItem.AC))+'/'+IntToStr(HiWord(StdItem.AC))+')'+
                  '('+IntToStr(LoWord(StdItem.MAC))+'/'+IntToStr(HiWord(StdItem.MAC))+')'+
                  IntToStr(UserItem.btValue[0])+'/'+IntToStr(UserItem.btValue[1])+'/'+IntToStr(UserItem.btValue[2])+'/'+
                  IntToStr(UserItem.btValue[3])+'/'+IntToStr(UserItem.btValue[4])+'/'+IntToStr(UserItem.btValue[5])+'/'+
                  IntToStr(UserItem.btValue[6])+'/'+IntToStr(UserItem.btValue[7])+'/'+IntToStr(UserItem.btValue[8])+'/'+
                  IntToStr(UserItem.btValue[14])+ #9 +IntToStr(UserItem.Dura)+'/'+IntToStr(UserItem.DuraMax));
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
 { function IsOfGroup(BaseObject: TBaseObject): Boolean;
 // var
    //I: Integer;
    //GroupMember: TBaseObject;
  begin
    Result := False;
    if m_Master.m_GroupOwner = nil then Exit;
    for I := 0 to m_Master.m_GroupOwner.m_GroupMembers.Count - 1 do begin
      GroupMember := TBaseObject(m_Master.m_GroupOwner.m_GroupMembers.Objects[I]);
      if GroupMember = BaseObject then begin
        Result := True;
        Break;
      end;
    end;
  end; }
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
    boFound := False;
    nCode:= 1;
    if m_SelMapItem <> nil then begin
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
        if (VisibleMapItem <> nil) then begin
          if (VisibleMapItem.nVisibleFlag > 0) then begin
            MapItem := VisibleMapItem.MapItem;
            nCode:= 15;
            if (MapItem <> nil) then begin
              if (MapItem.DropBaseObject <> m_Master) then begin
                nCode:= 16;
                if IsAllowPickUpItem(VisibleMapItem.sName) and
                  IsAddWeightAvailable(UserEngine.GetStdItemWeight(MapItem.UserItem.wIndex)) and
                  (MapItem.UserItem.AddValue[0]<>2) and (MapItem.UserItem.AddValue[0]<>3) then begin
                  //if (MapItem.DropBaseObject <> nil) and (TBaseObject(MapItem.DropBaseObject).m_btRaceServer = RC_PLAYOBJECT) then Continue;
                  nCode:= 17;
                  if (MapItem.OfBaseObject = nil) or (MapItem.OfBaseObject = m_Master) or (MapItem.OfBaseObject = Self) {or IsOfGroup(TBaseObject(MapItem.OfBaseObject))} then begin
                    nCode:= 18;
                    if (abs(VisibleMapItem.nX - m_nCurrX) <= 5) and (abs(VisibleMapItem.nY - m_nCurrY) <= 5) then begin
                      n02 := abs(VisibleMapItem.nX - m_nCurrX) + abs(VisibleMapItem.nY - m_nCurrY);
                      if n02 < n01 then begin
                        n01 := n02;
                        nCode:= 19;
                        SelVisibleMapItem := VisibleMapItem;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;//for
    end;
    nCode:= 20;
    if SelVisibleMapItem <> nil then begin
      nCode:= 21;
      m_SelMapItem := SelVisibleMapItem.MapItem;
      if (m_nCurrX <> SelVisibleMapItem.nX) or (m_nCurrY <> SelVisibleMapItem.nY) then begin
        nCode:= 22;
        WalkToTargetXY2(SelVisibleMapItem.nX, VisibleMapItem.nY);
        Result := True;
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.SearchPickUpItem Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
(* 20080117
function THeroObject.IsPickUpItem(StdItem: pTStdItem): Boolean;
begin
  Result := True;
  {if StdItem.StdMode = 0 then begin
    if (StdItem.Shape in [0, 1, 2]) then Result := True;
  end else
    if StdItem.StdMode = 31 then begin
    if GetBindItemType(StdItem.Shape) >= 0 then Result := True;
  end else begin
    Result := False;
  end;}
end;    *)

function THeroObject.EatUseItems(nShape: Integer): Boolean;
begin
  Result := False;
  case nShape of
    4: begin
        if WeaptonMakeLuck() then Result := True;
      end;
    9: begin
        if RepairWeapon() then Result := True;
      end;
    10: begin
        if SuperRepairWeapon() then Result := True;
      end;
  end;
end;

function THeroObject.AutoEatUseItems(btItemType: Byte): Boolean; //�Զ���ҩ
  function FoundAddHealthItem(ItemType: Byte; var boDel: Boolean): Integer;
  var
    I: Integer;
    UserItem: pTUserItem;
    StdItem: pTStdItem;

    UserItem1: pTUserItem;
    StdItem1, StdItem2, StdItem3: pTStdItem;
    II, MinHP, j, nHP:Integer;
  begin
    Result := -1;
    if m_ItemList.Count > 0 then begin//20080628
      for I := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[I];
        if UserItem <> nil then begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then begin
            case ItemType of
              0: begin //��ҩ
                  if ((StdItem.StdMode = 0) and (StdItem.Shape = 0) and (StdItem.AC > 0)) or
                    ((StdItem.StdMode = 17) and (StdItem.Shape = 237) and (StdItem.AC > 0)) then begin//����ҩƷ 20110709
                    boDel:= (StdItem.StdMode = 17) and (StdItem.Shape = 237) and (UserItem.Dura > 1);
                    Result := I;
                    Break;
                  end;
                end;
              1: begin //��ҩ
                  if ((StdItem.StdMode = 0) and (StdItem.Shape = 0) and (StdItem.MAC > 0)) or
                    ((StdItem.StdMode = 17) and (StdItem.Shape = 237) and (StdItem.MAC > 0)) then begin//����ҩƷ 20110709
                    boDel:= (StdItem.StdMode = 17) and (StdItem.Shape = 237) and (UserItem.Dura > 1);
                    Result := I;
                    Break;
                  end;
                end;
              2: begin //̫��ˮ(��������ҩƷ,�Ա�HP,ѡ���ʺϵ�ҩƷ)
                   if (StdItem.StdMode = 0) and (StdItem.Shape = 1)
                     and (StdItem.AC > 0) and (StdItem.MAC > 0) then begin
                     MinHP:= StdItem.AC;
                     nHP:= m_WAbil.MaxHP - m_WAbil.HP;//ȡ��ǰѪ�Ĳ�ֵ
                     J:= I;
                     for II := 0 to m_ItemList.Count - 1 do begin//ѭ���ҳ�+HP���ʺϵ�������Ʒ
                       UserItem1 := m_ItemList.Items[II];
                       if UserItem1 <> nil then begin
                         StdItem1 := UserEngine.GetStdItem(UserItem1.wIndex);
                         if StdItem1 <> nil then begin
                            if (StdItem1.StdMode = 0) and (StdItem1.Shape = 1) and (StdItem1.AC > 0) and (StdItem1.MAC > 0) then begin
                              if abs(StdItem1.AC - nHP) < abs(MinHP - nHP) then begin//20080926
                                MinHP:= StdItem1.AC;
                                J:= II;
                              end;
                            end;
                         end;
                       end;
                     end;
                     for II := 0 to m_ItemList.Count - 1 do begin
                       UserItem1 := m_ItemList.Items[II];
                       if UserItem1 <> nil then begin
                         StdItem1 := UserEngine.GetStdItem(UserItem1.wIndex);
                         if StdItem1 <> nil then begin
                           if (StdItem1.StdMode = 31) and (GetBindItemType(StdItem1.Shape) = 2) and (m_ItemList.Count + 6 < m_nItemBagCount) then begin
                             StdItem3 := UserEngine.GetStdItem(GetBindItemName(StdItem1.Shape));//���Խ��������Ʒ��
                             if StdItem3 <> nil then begin
                               if (StdItem3.StdMode = 0) and (StdItem3.Shape = 1) and (StdItem3.AC > 0) and (StdItem3.MAC > 0) then begin
                                 if abs(StdItem3.AC - nHP) < abs(MinHP - nHP) then begin//20080926
                                   MinHP:= StdItem3.AC;
                                   J:= II;
                                 end;
                               end;
                             end;//if StdItem3 <> nil then begin 
                           end;
                         end;
                       end;
                     end;
                     Result := J;
                     Break;
                   end;
                end;
              3: begin //��ҩ��
                  if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 0) and (m_ItemList.Count + 6 < m_nItemBagCount) then begin
                    Result := I;
                    Break;
                  end;
                end;
              4: begin //��ҩ��
                  if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 1) and (m_ItemList.Count + 6 < m_nItemBagCount) then begin
                    Result := I;
                    Break;
                  end;
                end;
              5: begin//��ҩ�� 20080506
                  {if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 2) and (m_ItemList.Count + 6 < m_nItemBagCount) then begin
                    Result := I;
                    Break;
                  end;}
                  //20080927 ���ܽ��
                  if (StdItem.StdMode = 31) and (GetBindItemType(StdItem.Shape) = 2) and (m_ItemList.Count + 6 < m_nItemBagCount) then begin
                    StdItem1 := UserEngine.GetStdItem(GetBindItemName(StdItem.Shape));//���Խ��������Ʒ��
                    if StdItem1 <> nil then begin
                       MinHP:= StdItem1.AC;
                       nHP:= m_WAbil.MaxHP - m_WAbil.HP;//ȡ��ǰѪ�Ĳ�ֵ
                       J:= I;
                       for II := 0 to m_ItemList.Count - 1 do begin//ѭ���ҳ�+HP���ʺϵ�������Ʒ
                         UserItem1 := m_ItemList.Items[II];
                         if UserItem1 <> nil then begin
                           StdItem2 := UserEngine.GetStdItem(UserItem1.wIndex);
                           if StdItem2 <> nil then begin
                              if (StdItem2.StdMode = 31) and (GetBindItemType(StdItem2.Shape) = 2) then begin
                                 StdItem3 := UserEngine.GetStdItem(GetBindItemName(StdItem2.Shape));//���Խ��������Ʒ��
                                 if StdItem3 <> nil then begin
                                   if (StdItem3.StdMode = 0) and (StdItem3.Shape = 1) and (StdItem3.AC > 0) and (StdItem3.MAC > 0) then begin
                                       if abs(StdItem3.AC - nHP) < abs(MinHP - nHP) then begin//20080926
                                         MinHP:= StdItem3.AC;
                                         J:= II;
                                       end;
                                   end;
                                 end;//if StdItem3 <> nil then begin
                              end;
                           end;
                         end;
                       end;
                    end;
                    Result := J;
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
  nItemIdx: Integer;
  UserItem: pTUserItem;
  boDeltoItem: Boolean;
begin
  Result := False;
  if not m_boDeath then begin
    nItemIdx := FoundAddHealthItem(btItemType, boDeltoItem);
    if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
      UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
      if not boDeltoItem then SendDelItems(UserItem);
      ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
      Result := True;
    end else begin
      case btItemType of //���ҽ����Ʒ
        0: begin
            nItemIdx := FoundAddHealthItem(0, boDeltoItem);//���Һ�ҩ
            if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
              Result := True;
              UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
              if not boDeltoItem then SendDelItems(UserItem);
              ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
            end else begin
              nItemIdx := FoundAddHealthItem(3, boDeltoItem);//���Һ�ҩ��
              if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
                Result := True;
                UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
                SendDelItems(UserItem);
                ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
              end;
            end;
          end;
        1: begin
            nItemIdx := FoundAddHealthItem(1, boDeltoItem);//������ҩ
            if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
              Result := True;
              UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
              if not boDeltoItem then SendDelItems(UserItem);
              ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
            end else begin
              nItemIdx := FoundAddHealthItem(4, boDeltoItem);//��ҩ��
              if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
                Result := True;
                UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
                SendDelItems(UserItem);
                ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
              end;  
            end;
         end;
         2:begin
            nItemIdx := FoundAddHealthItem(2, boDeltoItem);//��������ҩƷ,�Ա�HP,ѡ���ʺϵ�ҩƷ
            if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
              Result := True;
              UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
              SendDelItems(UserItem);
              ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
            end else begin
              nItemIdx := FoundAddHealthItem(5, boDeltoItem);//��ҩ��
              if (nItemIdx >= 0) and (nItemIdx < m_ItemList.Count) then begin
                Result := True;
                UserItem := pTUserItem(m_ItemList.Items[nItemIdx]);
                SendDelItems(UserItem);
                ClientHeroUseItems(UserItem.MakeIndex, UserEngine.GetStdItem(UserItem.wIndex).Name, False, 1);
              end;
            end;
         end;//2
      end;//case btItemType of //���ҽ����Ʒ
    end;
  end;
end;

function THeroObject.IsNeedGotoXY(): Boolean; //�Ƿ�����Ŀ��
var
  dwAttackTime: LongWord;
begin
  Result := False;
  if (m_TargetCret <> nil) and (GetTickCount - m_dwAutoAvoidTick > 1100) and ((not m_boIsUseAttackMagic) or (m_btJob = 0)) then begin
    case m_btJob of
      1,2: begin
        if (m_btStatus <> 2) then begin
          if (not m_boIsUseMagic) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 3) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 3)) then begin
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
        end;
      end;
      0: begin
        if (m_btStatus <> 2) then begin
          case m_nSelectMagic of //20080501  ����
            SKILL_ERGUM, SKILL_89:begin//��ɱ, �ļ���ɱ����
                if (IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89)) and (m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, m_nTargetX, m_nTargetY)) then begin
                  if ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=0)) or
                     ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=0)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) or
                     ((Abs(m_nCurrX-m_TargetCret.m_nCurrX)=2)and(Abs(m_nCurrY-m_TargetCret.m_nCurrY)=2)) then begin
                    dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������
                    if (GetTickCount - m_dwHitTick > dwAttackTime) then begin
                      m_wHitMode:= 4;//��ɱ
                      if IsAllowUseMagic(SKILL_89) then m_wHitMode:= 15;//�ļ���ɱ
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
                if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
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
                if IsAllowUseMagic(Skill_96) and (m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, m_nTargetX, m_nTargetY)) then begin
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
                if IsAllowUseMagic(12) or IsAllowUseMagic(Skill_96) then begin
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
                    if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
                      //20090303 �޸�
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
                if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
                  //20090303 �޸�
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
                   if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
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
              if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
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
              if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin
                //20090212 �޸�,��ֹ�ϻ�����ʱ�������ض�λ�ã�Ӣ�۲�����
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
      end;//0
    end;//case
  end;
end;
//�Ƿ���Ҫ���
function THeroObject.IsNeedAvoid(): Boolean;
var
  nCode: byte;//20090303
begin
  Result := False;
  nCode:= 0;
  try                                                                     //20090318 ����
    if ((GetTickCount - m_dwAutoAvoidTick) > 1100) and m_boIsUseMagic and (not m_boDeath) then begin   //Ѫ����15%ʱ,�ض�Ҫ�� 20080711
      if (m_btJob > 0) and (m_btStatus <> 2) and ((m_nSelectMagic = 0) or (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.15))) then begin
        m_dwAutoAvoidTick := GetTickCount();
        nCode:= 1;
        if g_Config.boHeroAttackTarget and (m_Abil.Level < 22) then begin//20090211 22��ǰ���������
          if {(m_nSelectMagic <> 0) and} (m_btJob = 1) then begin//20090211 ����ħ����Ҫ��
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
              if m_TargetCret <> nil then begin//20090319
                nCode:= 6;                                   //20090112
                if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                  if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090108
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
       { if CheckTargetXYCount(m_nCurrX, m_nCurrY, 3) > 0 then begin
          Result := True;
        end; }
      end;
      //if (not Result) and (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.15)) then Result := True;//20080711 20090202ע��
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.IsNeedAvoid Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//��ҩ
procedure THeroObject.EatMedicine();
  function FoundItem(ItemType: Byte): Boolean;
  var
    I: Integer;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
  begin
    Result := False;
    if m_ItemList.Count > 0 then begin
      for I := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[I];
        if UserItem <> nil then begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then begin
            case ItemType of
              0: begin //��ҩ
                  if (StdItem.StdMode = 0) and ((StdItem.Shape = 0) or (StdItem.Shape = 1)) and (StdItem.AC > 0) then begin
                    Result := True;
                    Break;
                  end;
                  if (StdItem.StdMode = 31) and ((GetBindItemType(StdItem.Shape) = 0) or (GetBindItemType(StdItem.Shape) = 2)) then begin
                    Result := True;
                    Break;
                  end;
                end;
              1: begin //��ҩ
                  if (StdItem.StdMode = 0) and ((StdItem.Shape = 0) or (StdItem.Shape = 1)) and (StdItem.MAC > 0) then begin
                    Result := True;
                    Break;
                  end;
                  if (StdItem.StdMode = 31) and ((GetBindItemType(StdItem.Shape) = 1) or (GetBindItemType(StdItem.Shape) = 2)) then begin
                    Result := True;
                    Break;
                  end;
                end;
            end;//case
          end;
        end;
      end;//for
    end;
  end;
var
  n01: Integer;
  boFound: Boolean;
  btItemType:Byte;
begin
  boFound := False;
  btItemType:= 0;
  if not m_PEnvir.m_boMISSION then begin //20080509 ��ͼû������ʹ����Ʒʱ,�����Զ���ҩ
    case m_btJob of//��ְͬҵ��ҩ�����ͬ 20100408
      0: begin//ս
        if (GetTickCount - m_dwEatItemTick) > g_Config.nHeroAddHPMPTick then begin//ս����ͨҩ���
          m_dwEatItemTick := GetTickCount();
          if (m_nCopyHumanLevel > 0) then begin
            if m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate) div 100 then begin
              n01 := 0;
              while m_WAbil.HP < m_WAbil.MaxHP do begin {������������ƿ}
              if (n01 >= 1) then Break;//20080401 �ĳ�һ��һƿ
                btItemType:= 0;
                if AutoEatUseItems(btItemType) then boFound:= True;
                if m_ItemList.Count = 0 then Break;
                Inc(n01);
              end;
            end;

            if m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate) div 100 then begin
              n01 := 0;
              while m_WAbil.MP < m_WAbil.MaxMP do begin {������������ƿ}
                if (n01 >= 1) then Break;//20080401 �ĳ�һ��һƿ
                btItemType:= 1;
                if AutoEatUseItems(btItemType) then boFound:= True;
                if m_ItemList.Count = 0 then Break;
                Inc(n01);
              end;
            end;
          end;
        end;
        if (GetTickCount - m_dwEatItemTick1) > g_Config.nHeroAddHPMPTick1 then begin//ս������ҩ���
          m_dwEatItemTick1 := GetTickCount();
          if (m_nCopyHumanLevel > 0) and (m_ItemList.Count > 0) then begin
            if (m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate1) div 100) or
               (m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate1) div 100) then begin
               btItemType:= 2;
               if AutoEatUseItems(btItemType) then boFound:= True;
            end;
          end;
        end;
      end;
      1,2: begin//����
        if (GetTickCount - m_dwEatItemTick) > g_Config.nHeroAddHPMPTickA then begin//��������ͨҩ���
          m_dwEatItemTick := GetTickCount();
          if (m_nCopyHumanLevel > 0) then begin
            if m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate) div 100 then begin
              n01 := 0;
              while m_WAbil.HP < m_WAbil.MaxHP do begin {������������ƿ}
              if (n01 >= 1) then Break;//20080401 �ĳ�һ��һƿ
                btItemType:= 0;
                if AutoEatUseItems(btItemType) then boFound:= True;
                if m_ItemList.Count = 0 then Break;
                Inc(n01);
              end;
            end;

            if m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate) div 100 then begin
              n01 := 0;
              while m_WAbil.MP < m_WAbil.MaxMP do begin {������������ƿ}
                if (n01 >= 1) then Break;//20080401 �ĳ�һ��һƿ
                btItemType:= 1;
                if AutoEatUseItems(btItemType) then boFound:= True;
                if m_ItemList.Count = 0 then Break;
                Inc(n01);
              end;
            end;
          end;
        end;
        if (GetTickCount - m_dwEatItemTick1) > g_Config.nHeroAddHPMPTickB then begin//����Ӣ�۳�����ҩ���
          m_dwEatItemTick1 := GetTickCount();
          if (m_nCopyHumanLevel > 0) and (m_ItemList.Count > 0) then begin
            if (m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate1) div 100) or
               (m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate1) div 100) then begin
               btItemType:= 2;
               if AutoEatUseItems(btItemType) then boFound:= True;
            end;
          end;
        end;
      end;
    end;
  end;
  if not boFound then begin
    if (GetTickCount - m_dwEatItemNoHintTick) > 30000{30 * 1000} then begin  //20080129
      m_dwEatItemNoHintTick := GetTickCount();
      case btItemType of
        0: begin
           if (m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate) div 100) or
              (m_WAbil.HP < (m_WAbil.MaxHP * g_Config.nHeroAddHPRate1) div 100) then begin
               if not FoundItem(btItemType) then SysMsg('(Ӣ��) ��ҩ�Ѿ����꣡����', BB_Fuchsia, t_Hint);
           end;
         end;
        1: begin
           if (m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate) div 100) or
              (m_WAbil.MP < (m_WAbil.MaxMP * g_Config.nHeroAddMPRate1) div 100) then begin
               if not FoundItem(btItemType) then SysMsg('(Ӣ��) ħ��ҩ�Ѿ����꣡����', BB_Fuchsia, t_Hint);
           end;
         end;
      end;
    end;
  end;
end;

{���ָ������ͷ�Χ������Ĺ�������}
function THeroObject.CheckTargetXYCountOfDirection(nX, nY, nDir, nRange: Integer): Integer;
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
            //if Result > 2 then break;
          end;
        end;
      end;
    end;
  end;
end;

//���ָ������ͷ�Χ��,Ŀ����Ӣ�۵ľ��� 20080426
function THeroObject.CheckMasterXYOfDirection(TargeTBaseObject: TBaseObject; nX, nY, nDir, nRange: Integer): Integer;
begin
  Result := 0;
  if TargeTBaseObject <> nil then begin
    if not TargeTBaseObject.m_boDeath then begin
        case nDir of
          DR_UP: begin
              if (abs(nX - TargeTBaseObject.m_nCurrX) <= nRange) and ((TargeTBaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
            end;
          DR_UPRIGHT: begin
              if ((TargeTBaseObject.m_nCurrX - nX) in [0..nRange]) and ((TargeTBaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
            end;
          DR_RIGHT: begin
              if ((TargeTBaseObject.m_nCurrX - nX) in [0..nRange]) and (abs(nY - TargeTBaseObject.m_nCurrY) <= nRange) then Inc(Result);
            end;
          DR_DOWNRIGHT: begin
              if ((TargeTBaseObject.m_nCurrX - nX) in [0..nRange]) and ((nY - TargeTBaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
            end;
          DR_DOWN: begin
              if (abs(nX - TargeTBaseObject.m_nCurrX) <= nRange) and ((nY - TargeTBaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
            end;
          DR_DOWNLEFT: begin
              if ((nX - TargeTBaseObject.m_nCurrX) in [0..nRange]) and ((nY - TargeTBaseObject.m_nCurrY) in [0..nRange]) then Inc(Result);
            end;
          DR_LEFT: begin
              if ((nX - TargeTBaseObject.m_nCurrX) in [0..nRange]) and (abs(nY - TargeTBaseObject.m_nCurrY) <= nRange) then Inc(Result);
            end;
          DR_UPLEFT: begin
              if ((nX - TargeTBaseObject.m_nCurrX) in [0..nRange]) and ((TargeTBaseObject.m_nCurrY - nY) in [0..nRange]) then Inc(Result);
            end;
        end;
    end;
  end;
end;

function THeroObject.WarrAttackTarget(wHitMode: Word): Boolean; {������}
var
  bt06, nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if m_TargetCret <> nil then begin
       nCode:= 2;
      if GetAttackDir(m_TargetCret, bt06) then begin
        nCode:= 3;
        m_dwTargetFocusTick := GetTickCount();
        nCode:= 4;
        Attack(m_TargetCret, bt06);
        m_dwActionTick := GetTickCount();//20080720 ��,����
        nCode:= 5;
        BreakHolySeizeMode();
        Result := True;
      end else begin
        nCode:= 6;
        if m_TargetCret.m_PEnvir = m_PEnvir then begin
          nCode:= 7;
          SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
        end else begin
          nCode:= 8;
         if not m_boTarget then DelTargetCreat();//20080424 ����������Ŀ��,����ɾ��Ŀ��
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} THeroObject.WarrAttackTarget Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
end;

function THeroObject.WarrorAttackTarget(): Boolean; {սʿ����}
var
  UserMagic: pTUserMagic;
  nCode: Byte;//20090502
begin
  Result := False;
  nCode:= 0;//20090502
  try
    if (m_btStatus <> 0) and (not m_boProtectStatus) then begin//20090608 ���ػ�״̬�£���Ϊ����״̬ʱ������Ŀ��
      if m_TargetCret <> nil then m_TargetCret:= nil;
      Exit;
    end;
    nCode:= 1;
    m_wHitMode := 0;
    if m_WAbil.MP > 0 then begin
      if m_TargetCret <> nil then begin//20090502 ����
        nCode:= 2;
        if (not m_boStartUseSpell) and ((m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.25)) or m_TargetCret.m_boCrazyMode) then begin
          if IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89) then begin//Ѫ��ʱ��Ŀ����ģʽʱ������λ��ɱ 20080827
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
      if not m_boStartUseSpell then SearchMagic(); //��ѯħ�� 20080328����
      nCode:= 5;
      if m_nSelectMagic > 0 then begin
        if (m_TargetCret <> nil) and (m_Master <> nil) then begin//20090502 ���� //20090721
          nCode:= 6;
          if not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) or ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7{5}) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7{5})) then begin//ħ�����ܴ򵽹� 20080420 20090212 �޸�
            if not m_Master.m_boGhost then begin//20090721 ����
              if ((abs(m_Master.m_nCurrX - m_nCurrX) >= 7) or (abs(m_Master.m_nCurrY - m_nCurrY) >= 7)) and (not m_boProtectStatus) and (not m_boTarget) then begin//20090608 ���ػ�״̬ʱ������Ŀ��,������״̬��
                m_TargetCret:= nil;
                Exit;
              end;
            end;
          end;
        end;
        nCode:= 7;
        UserMagic := FindMagic(m_nSelectMagic);
        if (UserMagic <> nil) then begin
          if (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ�� 20080606
            case m_nSelectMagic of
              27, 39, 41, 60..65, 68, SKILL_69, 75, SKILL_101, SKILL_102: begin
                  if m_TargetCret <> nil then begin//20090502 ����
                    nCode:= 8;
                    Result := ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //սʿħ��
                    m_dwHitTick := m_dwTargetFocusTick;//20080530
                    Exit;
                  end;
                end;
               7: m_wHitMode := 3; //��ɱ
              12: m_wHitMode := 4; //ʹ�ô�ɱ
              SKILL_89: m_wHitMode := 15;//�ļ���ɱ
              25: m_wHitMode := 5; //ʹ�ð���
              SKILL_90: m_wHitMode := 16;//Բ���䵶(�ļ������䵶)
              26: if ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 7; //ʹ���һ�
              40: m_wHitMode := 8; //���µ���
              43: if ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 9; //����ն  20100910 �޸�
              42: if ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 12;//��Ӱ���� 20100910 �޸�
              SKILL_74: if ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 13;//���ս��� 20100910 �޸�
              SKILL_96: if ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, m_TargetCret) then m_wHitMode := 17;//Ѫ��һ��(ս)
            end;
          end;
        end;
      end;
    end;
    nCode:= 9;
    if not m_boStartUseSpell then Result := WarrAttackTarget(m_wHitMode);//20081214
    nCode:= 10;
    if Result then m_dwHitTick := m_dwTargetFocusTick;//20080604 ��ʵ�ָ�λ��ʹ�ü���
  except
    MainOutMessage(Format('{%s} THeroObject.WarrorAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function THeroObject.WizardAttackTarget(): Boolean;//��ʦ����
var
  UserMagic: pTUserMagic;
  n14: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if (m_btStatus <> 0) and (not m_boProtectStatus) then begin//20090608 ���ػ�״̬�£���Ϊ����״̬ʱ������Ŀ��
      if m_TargetCret <> nil then m_TargetCret:= nil;
      Exit;
    end;
    nCode:= 1;
    m_wHitMode := 0;
    if not m_boStartUseSpell then begin
       nCode:= 2;
       SearchMagic(); //��ѯħ�� 20080328����
       if m_nSelectMagic = 0 then m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080715
    end;
    nCode:= 3;
    if m_nSelectMagic > 0 then begin
      if (m_TargetCret <> nil) and (m_Master <> nil) then begin//20090507 ����
        {nCode:= 4;
        if not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret) or ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7)) then begin//ħ�����ܴ򵽹� 20080420
          if ((abs(m_Master.m_nCurrX - m_nCurrX) >= 7) or (abs(m_Master.m_nCurrY - m_nCurrY) >= 7)) and (not m_boProtectStatus) and (not m_boTarget) then begin//20090608 ���ػ�״̬ʱ������Ŀ��,������״̬��
            m_nSelectMagic := 0;
            m_TargetCret:= nil;
            Exit;
          end else begin
            if not (m_nSelectMagic in [SKILL_FIREWIND, SKILL_SHOOTLIGHTEN, SKILL_SHIELD, SKILL_66, SKILL_46]) then begin//�����ܻ�,�����Ӱ,ħ����,��������
              GetGotoXY(m_TargetCret,3);//����ֻ����Ŀ��3��Χ
              GotoTargetXY( m_nTargetX, m_nTargetY, 0);
            end;
          end;
        end;  }
        //����JSӢ���޸� 20110701
        if ((GetTickCount - m_dwRunMagicIntervalTime) > g_Config.dwRunMagicIntervalTime) then begin
          m_dwRunMagicIntervalTime := GetTickCount;
          if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
             ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
            if (m_PEnvir = m_Master.m_PEnvir) and ((abs(m_nCurrX - m_Master.m_nCurrX) > 6) or
              (abs(m_nCurrY - m_Master.m_nCurrY) > 6)) then begin
              n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
              m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
            end else begin
              n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
              m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
            end;
            if (m_nTargetX > 0) and (m_nTargetY > 0) then HeroTail;
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end;         
      end;
      nCode:= 5;
      UserMagic := FindMagic(m_nSelectMagic);
      if (UserMagic <> nil) then begin
        if (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
          m_dwHitTick := GetTickCount();//20080530
          Result := ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
          Exit;
        end;
      end;
    end;
    nCode:= 6;
    m_dwHitTick := GetTickCount();//20080530
    if g_Config.boHeroAttackTarget and (m_Abil.Level < 22) then begin//20081218 ��ʦ22��ǰ�Ƿ�������
      m_boIsUseMagic := False;//�Ƿ��ܶ��
      nCode:= 7;
      Result := WarrAttackTarget(m_wHitMode);
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.WizardAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function THeroObject.TaoistAttackTarget(): Boolean; //��ʿ����
var
  UserMagic: pTUserMagic;
  n14: Integer;
begin
  Result := False;
  try
    if (m_btStatus <> 0) and (not m_boProtectStatus) then begin//20090608 ���ػ�״̬�£���Ϊ����״̬ʱ������Ŀ��
      if m_TargetCret <> nil then m_TargetCret:= nil;
      Exit;
    end;
    m_wHitMode := 0;
    if not m_boStartUseSpell then begin //20090112
       if m_TargetCret <> nil then begin//20090507 ����
         if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT)
           and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
           if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin
             SearchMagic(); //��ѯħ��
           end else begin
             if (GetTickCount()- m_dwSearchMagic > 1300) then begin//20090108 ���Ӳ�ѯħ���ļ��
               SearchMagic(); //��ѯħ��
               m_dwSearchMagic := GetTickCount();
             end else m_boIsUseAttackMagic := False;//20090211 ��������Ŀ��
           end;
         end else SearchMagic(); //��ѯħ��
       end;
       if m_nSelectMagic = 0 then m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080715
    end;
    if m_nSelectMagic > 0 then begin
      if (m_TargetCret <> nil) and (m_Master <> nil) then begin//20090507 ����
        {if (not MagCanHitTarget(m_nCurrX, m_nCurrY, m_TargetCret)) or ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 7) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 7)) then begin//ħ�����ܴ򵽹� 20080420
          if ((abs(m_Master.m_nCurrX - m_nCurrX) >= 7) or (abs(m_Master.m_nCurrY - m_nCurrY) >= 7)) and (not m_boProtectStatus) and (not m_boTarget) then begin//���ػ�״̬ʱ������Ŀ��,������״̬��
            m_nSelectMagic := 0;
            m_TargetCret:= nil;
            Exit;
          end else begin
            if not (m_nSelectMagic in [SKILL_48, SKILL_SKELLETON, SKILL_SINSU, SKILL_69, SKILL_72, SKILL_104, SKILL_50, SKILL_73]) then begin//20110425 ���ӣ����ּ��ܲ���Ҫ����Ŀ��3��
              if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT)
                and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ�
                if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                  GetGotoXY(m_TargetCret, 3);//��ֻ����Ŀ��3��Χ
                  GotoTargetXY( m_nTargetX, m_nTargetY,0);
                end;
              end else begin
                GetGotoXY(m_TargetCret, 3);//��ֻ����Ŀ��3��Χ
                GotoTargetXY( m_nTargetX, m_nTargetY,0);
              end;
            end;
          end;
        end;  }
        //����JSӢ���޸� 20110701
        if ((GetTickCount - m_dwRunMagicIntervalTime) > g_Config.dwRunMagicIntervalTime)
          and (m_wStatusTimeArr[STATE_TRANSPARENT ] = 0) then begin
          m_dwRunMagicIntervalTime := GetTickCount;
          if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
            ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
            if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or
              ((m_TargetCret.m_WAbil.MaxHP < 700) and g_Config.boHeroAttackTao and
              (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)
              and (m_TargetCret.m_btRaceServer <> RC_PLAYMOSTER)) then begin//��ʿ22��ǰ�Ƿ�������  �ֵȼ�С��Ӣ��ʱ
            end else begin
              if (m_PEnvir = m_Master.m_PEnvir) and ((abs(m_nCurrX - m_Master.m_nCurrX) > 6) or
                (abs(m_nCurrY - m_Master.m_nCurrY) > 6)) then begin
                n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
                m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
              end else begin
                n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
                m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
              end;
              if (m_nTargetX > 0) and (m_nTargetY > 0) then HeroTail;
            end;
            SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
          end;
        end;
      end;
      case m_nSelectMagic of
         SKILL_HEALLING: begin //������ 20080426
            if m_Master <> nil then begin//20090507 ����
              if (m_Master.m_WAbil.HP <= Round(m_Master.m_WAbil.MaxHP * 0.7)) then begin
                 UserMagic := FindMagic(m_nSelectMagic);
                 if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ�� 20080606
                   ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master);
                   m_dwHitTick := GetTickCount();
                   if g_Config.boHeroAttackTao and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) then begin//22����Ѫ���Ĺ� 20090108
                     if (m_TargetCret.m_WAbil.MaxHP >= 700) then begin//20090106
                       m_boIsUseMagic := True;//�ܶ�� 20080916
                       Exit;
                     end;
                   end else begin
                     m_boIsUseMagic := True;//�ܶ�� 20080916
                     Exit;
                   end;
                 end;
              end;
            end;
            if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) then begin
               UserMagic := FindMagic(m_nSelectMagic);
               if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
                 {Result :=}ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, nil);
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
            if m_Master <> nil then begin//20090507 ����
              if (m_Master.m_WAbil.HP <= Round(m_Master.m_WAbil.MaxHP * 0.7)) then begin
                 UserMagic := FindMagic(m_nSelectMagic);
                 if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ�� 20080715
                   {Result :=}ClientSpellXY(UserMagic, m_Master.m_nCurrX, m_Master.m_nCurrY, m_Master);
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
            if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.7)) then begin
               UserMagic := FindMagic(m_nSelectMagic);
               if (UserMagic <> nil) and (UserMagic.btKey = 0) then begin//���ܴ�״̬����ʹ��
                 {Result :=}ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
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
            { GetGotoXY(m_TargetCret,3);
             GotoTargetXY(m_nTargetX, m_nTargetY,1);  }
             //����JSӢ���޸� 20110701
              if ((GetTickCount - m_dwRunMagicIntervalTime) > g_Config.dwRunMagicIntervalTime)
                and (m_wStatusTimeArr[STATE_TRANSPARENT ] = 0) then begin
                m_dwRunMagicIntervalTime := GetTickCount;
                if ((abs(m_nCurrX - m_TargetCret.m_nCurrX) < 3) and (abs(m_nCurrY - m_TargetCret.m_nCurrY) < 3)) or//Ŀ�����
                   ((abs(m_nCurrX - m_TargetCret.m_nCurrX) > 7) or (abs(m_nCurrY - m_TargetCret.m_nCurrY) > 7)) then begin
                  if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or                                                                                                                   //20090529 ������������
                    ((m_TargetCret.m_WAbil.MaxHP < 700) and g_Config.boHeroAttackTao and
                    (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)
                    and (m_TargetCret.m_btRaceServer <> RC_PLAYMOSTER)) then begin//��ʿ22��ǰ�Ƿ�������  �ֵȼ�С��Ӣ��ʱ
                  end else begin
                    if (m_PEnvir = m_Master.m_PEnvir) and ((abs(m_nCurrX - m_Master.m_nCurrX) > 6) or
                      (abs(m_nCurrY - m_Master.m_nCurrY) > 6)) then begin
                      n14 := GetNextDirection(m_nCurrX, m_nCurrY, m_Master.m_nCurrX, m_Master.m_nCurrY);
                      m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
                    end else begin
                      n14 := GetNextDirection(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_nCurrX, m_nCurrY);
                      m_PEnvir.GetNextPosition(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, n14, 5, m_nTargetX, m_nTargetY);
                    end;
                    if (m_nTargetX > 0) and (m_nTargetY > 0) then HeroTail;
                  end;
                  SetTargetXY(m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY);
                end;
              end;
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
               ClientSpellXY(UserMagic, m_nCurrX, m_nCurrY, self);
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
              {Result := }ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
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
          Result := ClientSpellXY(UserMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, m_TargetCret); //ʹ��ħ��
          if (m_TargetCret.m_WAbil.MaxHP >= 700) or (not g_Config.boHeroAttackTao) then begin//20090106
            Exit;
          end;
        end;
      end;
    end;
    m_dwHitTick := GetTickCount();

    if (m_WAbil.HP <= Round(m_WAbil.MaxHP * 0.15)) then m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080715
    if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or                                                                                                                   //20090529 ������������
      ((m_TargetCret.m_WAbil.MaxHP < 700) and g_Config.boHeroAttackTao and
      (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)
      and (m_TargetCret.m_btRaceServer <> RC_PLAYMOSTER)) then begin//20090106 ��ʿ22��ǰ�Ƿ�������  �ֵȼ�С��Ӣ��ʱ
      if (abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1) then begin//���߽�Ŀ�꿳 20090212
        GotoTargetXY( m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0);
      end;
      m_boIsUseMagic := False;//�Ƿ��ܶ��
      Result := WarrAttackTarget(m_wHitMode);
    end;
  except
    //MainOutMessage('{�쳣} THeroObject.TaoistAttackTarget');
  end;
end;

function THeroObject.CheckUserMagic(wMagIdx: Word): pTUserMagic;
var
  I: Integer;
begin
  Result := nil;
  try
    if m_MagicList.Count > 0 then begin//20080630
      for I := 0 to m_MagicList.Count - 1 do begin
        if pTUserMagic(m_MagicList.Items[I]).MagicInfo.wMagicId = wMagIdx then begin
          Result := pTUserMagic(m_MagicList.Items[I]);
          Break;
        end;
      end;
    end;
  except
    Result := nil;//20090502 ����
  end;
end;
//�����������ܻ�ʹ�� 20090302
function THeroObject.CheckTargetXYCount3(nX, nY, nRange, nCount: Integer): Integer;
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

function THeroObject.CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
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
  except//20090507
  end;
end;
//սʿ�ж�ʹ�� 20080924
function THeroObject.CheckTargetXYCount1(nX, nY, nRange: Integer): Integer;
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
//�����䵶�ж�Ŀ�꺯�� 20081207
function THeroObject.CheckTargetXYCount2(nMode: Word): Integer;
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

{��ʿ} //�����Ʒ����
function THeroObject.CheckItemType(nItemType: Integer; StdItem: pTStdItem ; nItemShape: Integer): Boolean;
begin
  Result := False;
  case nItemType of
    1: begin
        if (StdItem.StdMode = 25) and (StdItem.Shape = 5) then Result := True;
      end;
    2: begin
        case nItemShape of
          1:if (StdItem.StdMode = 25) and (StdItem.Shape = 1) then Result := True;
          2:if (StdItem.StdMode = 25) and (StdItem.Shape = 2) then Result := True;
        end;
      end;
  end;
end;
//�ж�װ�������Ƿ���ָ�����͵���Ʒ
function THeroObject.CheckUserItemType(nItemType: Integer; nItemShape: Integer): Boolean;
var
  StdItem: pTStdItem;
begin
  Result := False;
 if m_UseItems[U_ARMRINGL].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_ARMRINGL].wIndex);
    if (StdItem <> nil) then begin
      case nItemType of
        1:if m_UseItems[U_ARMRINGL].Dura >= nItemShape * 100 then Result := CheckItemType(nItemType, StdItem, nItemShape);
        2:Result := CheckItemType(nItemType, StdItem, nItemShape);
      end;
    end;
  end (* else {20080212 ����,�ж�װ����Ʒһ���Ƿ���ָ�����͵���Ʒ}
  if m_UseItems[U_BUJUK].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
    if StdItem <> nil then begin
      Result := CheckItemType(nItemType, StdItem);
    end;
  end; *)
end;
(*
function THeroObject.UseItem(nItemType, nIndex: Integer; nItemShape: Integer): Boolean; //�Զ�������
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
        case nItemType of
          1:begin
              if CheckItemType(nItemType, StdItem ,nItemShape) and (m_UseItems[U_ARMRINGL {U_BUJUK}].Dura >= nItemShape * 100) then begin
                Result := True;
              end else begin
                m_ItemList.Delete(nIndex);
                New(AddUserItem);
                AddUserItem^ := m_UseItems[U_ARMRINGL {U_BUJUK}];
                if AddItemToBag(AddUserItem) then begin
                  m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
                  SendChangeItems(U_ARMRINGL, U_ARMRINGL, UserItem, AddUserItem);
                  Dispose(UserItem);
                  Result := True;
                end else m_ItemList.Add(UserItem);
              end;
           end;
          2:begin
              if CheckItemType(nItemType, StdItem ,nItemShape) then begin
                Result := True;
              end else begin
                m_ItemList.Delete(nIndex);
                New(AddUserItem);
                AddUserItem^ := m_UseItems[U_ARMRINGL {U_BUJUK}];
                if AddItemToBag(AddUserItem) then begin
                  m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
                  SendChangeItems(U_ARMRINGL, U_ARMRINGL, UserItem, AddUserItem);
                  Dispose(UserItem);
                  Result := True;
                end else m_ItemList.Add(UserItem);
              end;
           end;
        end;
      end else begin
        m_ItemList.Delete(nIndex);
        m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
        SendChangeItems(U_ARMRINGL, U_ARMRINGL, UserItem, nil);
        Dispose(UserItem);
        Result := True;
      end;
    end else begin
      m_ItemList.Delete(nIndex);
      m_UseItems[U_ARMRINGL {U_BUJUK}] := UserItem^;
      SendChangeItems(U_ARMRINGL, U_ARMRINGL, UserItem, nil);
      Dispose(UserItem);
      Result := True;
    end;
  end;
end;  *)

//���������Ƿ��з��Ͷ�
//nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ  ��Ϊ��,�� nItemShape ��ʾ���ĳ־�,��ʱ,1-�̶�,2-�춾
function THeroObject.GetUserItemList(nItemType: Integer; nItemShape: Integer): Integer;
var
  I: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := -1;
  if m_UseItems[U_ARMRINGL].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_ARMRINGL].wIndex);
    if (StdItem <> nil) and (StdItem.StdMode = 25) then begin
      case nItemType of
        1: begin
            if (StdItem.Shape = 5) and (Round(m_UseItems[U_ARMRINGL].Dura / 100) >= nItemShape) then begin
              Result:= 1;
              Exit;
            end;
          end;
        2: begin
            Case nItemShape of
              1: begin
                 if StdItem.Shape = 1 then begin
                   Result:= 1;
                   Exit;
                 end;
               end;
              2:begin
                 if StdItem.Shape = 2 then begin
                   Result:= 1;
                   Exit;
                 end;
              end;
            end;
          end;
      end;
    end;
  end;

  if m_UseItems[U_BUJUK].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
    if (StdItem <> nil) and (StdItem.StdMode = 25) then begin
      case nItemType of //
        1: begin//��
            if (StdItem.Shape = 5) and (Round(m_UseItems[U_BUJUK].Dura / 100) >= nItemShape) then begin
              Result:= 1;
              Exit;
            end;
          end;
        2: begin//��
            Case nItemShape of
              1: begin
                 if StdItem.Shape = 1 then begin
                   Result:= 1;
                   Exit;
                 end;
               end;
              2:begin
                 if StdItem.Shape = 2 then begin
                   Result:= 1;
                   Exit;
                 end;
              end;
            end;
          end;
      end;
    end;
  end;

  for I := m_ItemList.Count - 1 downto 0 do begin//20080916 �޸�
    if m_ItemList.Count <= 0 then Break;//20080916
    UserItem := m_ItemList.Items[I];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      if CheckItemType(nItemType, StdItem, nItemShape) then begin
        if UserItem.Dura < 100 then begin
          m_ItemList.Delete(I);
          Continue;
        end;
        case nItemType of
          1:begin
              if UserItem.Dura >= nItemShape * 100 then begin
                Result := I;
                Break;
              end
            end;
          2:begin
              Case nItemShape of
                1: begin
                   if StdItem.Shape = 1 then begin
                     Result := I;
                     Break;
                   end;
                 end;
                2:begin
                   if StdItem.Shape = 2 then begin
                     Result := I;
                     Break;
                   end;
                end;
              end;
            end;
        end;
      end;
    end;
  end;
end;
{$IF M2Version = 1}
//Ӣ������������� 20091028
function THeroObject.HeroBatterAttackTarget(): Boolean;
var
  BoWarrorAttack: Boolean;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    if m_boDeath or m_boGhost then Exit;//20091124 ����
    nCode:= 1;
    if (not m_boUseBatter) and (m_TargetCret <> nil) then HeroGetBatterMagic;//ȡ��������ID
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
          {if (m_nBatterMagIdx1 = SKILL_82) then begin//����ն3��ɷų� 20100805
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
          end else
          if (m_nBatterMagIdx1 = 0) and (m_nBatterMagIdx2 = SKILL_82) then begin
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
          end else
          if (m_nBatterMagIdx1 = 0) and (m_nBatterMagIdx2 = 0) and (m_nBatterMagIdx3 = SKILL_82) then begin
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
          end else
          if (m_nBatterMagIdx1 = 0) and (m_nBatterMagIdx2 = 0) and (m_nBatterMagIdx3 = 0) and (m_nBatterMagIdx4 = SKILL_82) then begin
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 3) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
          end else begin 
            if (abs(m_TargetCret.m_nCurrX - m_nCurrX) < 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) < 2) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
          end; } //20100831 �޸�
            if ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
               ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) then BoWarrorAttack:= True
            else GotoTargetXY(m_nTargetX, m_nTargetY, 0);
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
        if m_boUseBatter then begin//սʹ��������14��δʹ�ã����Զ��ر� 20100628
          if m_boWarUseBatter and ((GetTickCount - m_dwLatestWarUseBatterTick) > 14000) then begin
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
    MainOutMessage(Format('{%s} THeroObject.HeroBatterAttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//Ӣ������ֹͣ
procedure THeroObject.HeroBatterStop();
begin
  if m_boDeath or m_boGhost then Exit;//20091124 ����
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
{$IFEND}
//�ϻ�������ʱ��,ֱ�ӽ���ϻ� 20080406
function THeroObject.AttackTarget(): Boolean;
var
  dwAttackTime: LongWord;
  nCode: byte;//20090303
begin
  Result := False;
  nCode:= 0;
  try
    if (m_btStatus <> 0) and (not m_boProtectStatus) then begin//���ػ�״̬�£���Ϊ����״̬ʱ������Ŀ��
      if m_TargetCret <> nil then m_TargetCret:= nil;
      {$IF M2Version = 1}
      HeroBatterStop;//Ӣ������ֹͣ
      {$IFEND}
      Exit;//20080404 ���治���
    end;
    nCode:= 1;
    if (m_TargetCret <> nil) then begin
      if InSafeZone then begin//Ӣ�۽��밲ȫ���ھͲ���PKĿ�� 20080721
        if (m_TargetCret.m_btRaceServer = RC_PLAYOBJECT) or (m_TargetCret.m_btRaceServer = RC_HEROOBJECT) then begin
          m_TargetCret:= nil;
          {$IF M2Version = 1}
          HeroBatterStop;//Ӣ������ֹͣ
          {$IFEND}
          Exit;
        end;
      end;
      if (m_TargetCret = self) or (m_TargetCret = m_Master) then begin//20091022 ����,��ֹӢ���Լ����Լ�  20110713Ŀ��Ϊ����ʱ������
        m_TargetCret:= nil;
        Exit;
      end;
    end;
    nCode:= 2;
    m_dwTargetFocusTick := GetTickCount();
    if m_boDeath or m_boGhost then Exit;//20100125 ����
    case m_btJob of
      0: begin
          nCode:= 3;
          dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWarrorAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������  +�ٶ� 20080405
          nCode:= 31;
          if (m_dwTargetFocusTick - m_dwHitTick > dwAttackTime) or m_boStartUseSpell then begin
            {$IF M2Version = 1}
            nCode:= 9;
            if HeroBatterAttackTarget then begin
              m_dwHitTick := m_dwTargetFocusTick;
              m_boIsUseMagic := False;//�Ƿ��ܶ��
              Result := True;
              Exit;
            end;
            {$IFEND}
            m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080714
            nCode:= 8;
            Result := WarrorAttackTarget;
          end;
        end;
      1: begin
          nCode:= 4;
          dwAttackTime := _MAX(0, Integer(g_Config.dwHeroWizardAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������  +�ٶ� 20080405
          if (GetTickCount - m_dwHitTick > dwAttackTime) or m_boStartUseSpell {$IF M2Version = 1}or m_boUseBatter{$IFEND} then begin//����Ҳ���ܼ������ 20100408
            nCode:= 41;
            m_dwHitTick := GetTickCount();//20080530
            m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080714
            {$IF M2Version = 1}
            nCode:= 10;
            if HeroBatterAttackTarget then begin
              Result := True;
              Exit;
            end;
            {$IFEND}
            nCode:= 7;
            Result := WizardAttackTarget;
            Exit;//20080719
          end;
          m_nSelectMagic := 0;//20080719
        end;
      2: begin
          nCode:= 5;
          dwAttackTime := _MAX(0, Integer(g_Config.dwHeroTaoistAttackTime) - m_nHitSpeed * g_ClientConf.btItemSpeed); //��ֹ��������  +�ٶ� 20080405
          nCode:= 51;
          if (GetTickCount - m_dwHitTick > dwAttackTime) or m_boStartUseSpell {$IF M2Version = 1}or m_boUseBatter{$IFEND} then begin//����Ҳ���ܼ������ 20100408
            m_dwHitTick := GetTickCount();//20080530
            m_boIsUseMagic := False;//�Ƿ��ܶ�� 20080714
            {$IF M2Version = 1}
            nCode:= 11;
            if HeroBatterAttackTarget then begin
              Result := True;
              Exit;
            end;
            {$IFEND}
            nCode:= 6;
            Result := TaoistAttackTarget;
            Exit;//20080719
          end;
          m_nSelectMagic := 0;//20080719
        end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.AttackTarget Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

procedure THeroObject.SearchMagic();
var
  UserMagic: pTUserMagic;
  nCode: Byte;
begin
  m_nSelectMagic:= 0;
  nCode:= 0;
  try//20100304 ����
    m_nSelectMagic := SelectMagic;
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
       // m_boIsUseMagic:=IsUseMagic;
      end;
    end else begin
      nCode:= 4;
      m_boIsUseAttackMagic := False;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.SearchMagic Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function THeroObject.IsSearchTarget: Boolean;
begin
  Result := False;
  if (m_TargetCret <> nil) then begin
    if (m_TargetCret = Self) then m_TargetCret := nil;
  end;                                                                                     //20090608 �����ػ�״̬һ������Ŀ�꣬�������Ƿ�Ϊ����״̬
  if (m_TargetCret = nil) {or}and ((GetTickCount - m_dwSearchEnemyTick) > 400{8000}) and ((m_btStatus = 0) or (m_boProtectStatus)) then begin
    m_dwSearchEnemyTick := GetTickCount;
    Result := True;
    Exit;
  end;
 { if GetTickCount - m_dwSearchEnemyTick < 1000 then Exit; //20080222 ע��
  m_dwSearchEnemyTick := GetTickCount;
  Result := True; }
  {case m_btJob of
    0: begin
        if (m_TargetCret <> nil) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) and (CheckTargetXYCount(m_nCurrX, m_nCurrY, 1) >= 1) then begin
          m_dwSearchEnemyTick := GetTickCount;
          Result := True;
          Exit;
        end;
      end;
    1, 2: begin
        if m_boIsUseAttackMagic then begin
          if (m_TargetCret <> nil) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 3) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 3)) and (CheckTargetXYCount(m_nCurrX, m_nCurrY, 1) > 0) then begin
            m_dwSearchEnemyTick := GetTickCount;
            Result := True;
            Exit;
          end;
        end else begin
          if (m_TargetCret <> nil) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) > 1) or (abs(m_TargetCret.m_nCurrY - m_nCurrY) > 1)) and (CheckTargetXYCount(m_nCurrX, m_nCurrY, 1) >= 2) then begin
            m_dwSearchEnemyTick := GetTickCount;
            Result := True;
            Exit;
          end;
        end;
      end;
  end; }
end;
//�����Ʒ�Ƿ�Ϊ����֮��
function THeroObject.WearFirDragon: Boolean;
var
  StdItem: pTStdItem;
begin
 Result := False;
  if m_UseItems[U_BUJUK].wIndex > 0 then begin
    StdItem := UserEngine.GetStdItem(m_UseItems[U_BUJUK].wIndex);
    if (StdItem <> nil) and (StdItem.StdMode = 25) and (StdItem.Shape = 9) then begin
      Result := True;
    end;
  end;
end;
//�޲�����֮��  20071229   btType:2--����  4--Ӣ��
//42 ���࣬�־�+ŭ��
procedure THeroObject.RepairFirDragon(btType: Byte; nItemIdx: Integer; sItemName: string);
var
  I, n14: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sUserItemName: string;
  boRepairOK: Boolean;
  ItemList: TList;
  OldDura: Word;
begin
  boRepairOK := False;
  ItemList := nil;
  StdItem := nil;
  UserItem := nil;
  n14 := -1;
  OldDura :=0;
  if (m_Master <> nil) and WearFirDragon then begin
    if m_UseItems[U_BUJUK].Dura < m_UseItems[U_BUJUK].DuraMax then begin
      OldDura := m_UseItems[U_BUJUK].Dura;
      case btType of
        2: ItemList := m_Master.m_ItemList;
        4: ItemList := m_ItemList;
      end;
      if ItemList <> nil then begin
        if ItemList.Count > 0 then begin//20080630
          for I := 0 to ItemList.Count - 1 do begin
            UserItem := ItemList.Items[I];
            if (UserItem <> nil) then begin
              if(UserItem.MakeIndex = nItemIdx) then begin
                //ȡ�Զ�����Ʒ����
                sUserItemName := '';
                if UserItem.btValue[13] = 1 then
                  sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
                if sUserItemName = '' then sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
                StdItem := UserEngine.GetStdItem(UserItem.wIndex);
                if StdItem <> nil then begin
                  if CompareText(sUserItemName, sItemName) = 0 then begin
                    n14 := I;
                    Break;
                  end;
                end;
              end;
            end;
            UserItem := nil;
          end;
        end;
        if (StdItem <> nil) and (UserItem <> nil) then begin
          case StdItem.StdMode of
            4, 47: begin//װ����ŭ���־� ������ �ر�ͼ(StdItem.Source = 127ʱ��Ϊ�ǿ����޸�����֮�ģ�����ֵΪReserved*100) 
                if (StdItem.Source = 127) and (StdItem.Reserved > 0) then begin
                  Inc(m_UseItems[U_BUJUK].Dura, StdItem.Reserved * 100);
                  if m_UseItems[U_BUJUK].Dura > m_UseItems[U_BUJUK].DuraMax then m_UseItems[U_BUJUK].Dura:=m_UseItems[U_BUJUK].DuraMax;
                  boRepairOK := True;
                  case btType of
                    2: m_Master.DelBagItem(n14);
                    4: DelBagItem(n14);
                  end;
                end;
              end;
            15,19..24,26..29: begin//ʥս���������������ͷ��(StdItem.Source = 127ʱ��Ϊ�ǿ����޸�����֮�ģ�����ֵΪStock*100)
                if (StdItem.Source = 127) and (StdItem.Stock > 0) then begin
                  Inc(m_UseItems[U_BUJUK].Dura, StdItem.Stock * 100);
                  if m_UseItems[U_BUJUK].Dura > m_UseItems[U_BUJUK].DuraMax then m_UseItems[U_BUJUK].Dura:=m_UseItems[U_BUJUK].DuraMax;
                  boRepairOK := True;
                  case btType of
                    2: m_Master.DelBagItem(n14);
                    4: DelBagItem(n14);
                  end;
                end;
              end;
            42: begin//������Ʒ
              Inc(m_UseItems[U_BUJUK].Dura, UserItem.DuraMax);
              if m_UseItems[U_BUJUK].Dura > m_UseItems[U_BUJUK].DuraMax then m_UseItems[U_BUJUK].Dura:=m_UseItems[U_BUJUK].DuraMax;
              boRepairOK := True;
              case btType of
                2: m_Master.DelBagItem(n14);
                4: DelBagItem(n14);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  if boRepairOK then begin
    if OldDura <> m_UseItems[U_BUJUK].Dura then
      SendMsg(Self, RM_HERODURACHANGE, U_BUJUK, m_UseItems[U_BUJUK].Dura, m_UseItems[U_BUJUK].DuraMax, 0, '');
    SendDefMessage(SM_REPAIRFIRDRAGON_OK, btType, 0, 0, 0, '');
  end else begin
    SendDefMessage(SM_REPAIRFIRDRAGON_FAIL, btType, 0, 0, 0, '');
    //SysMsg('�޲�����֮��ʧ��!', BB_Fuchsia, t_Hint);
  end;
end;

//ʹ��ħѪʯ�������ӡ 20110116
procedure THeroObject.RepairDragonIndia(nItemIdx: Integer; sItemName: string);
var
  I, n14: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sUserItemName, sDragonIndiaName: string;
  boRepairOK: Boolean;
  OldDura: Word;
begin
  boRepairOK := False;
  StdItem := nil;
  UserItem := nil;
  n14 := -1;
  OldDura :=0;
  if (m_Master <> nil) then begin
    if (m_UseItems[U_CHARM].wIndex > 0) and (m_UseItems[U_CHARM].Dura < m_UseItems[U_CHARM].DuraMax) then begin
      StdItem := UserEngine.GetStdItem(m_UseItems[U_CHARM].wIndex);
      if (StdItem <> nil) and (StdItem.StdMode = 7) and (StdItem.Shape = 5) then begin//����ӡ��Ʒ
        sDragonIndiaName:= StdItem.Name;
        StdItem := nil;
        OldDura := m_UseItems[U_CHARM].Dura;
        if m_ItemList.Count > 0 then begin
          for I := 0 to m_ItemList.Count - 1 do begin
            UserItem := m_ItemList.Items[I];
            if (UserItem <> nil) then begin
              if(UserItem.MakeIndex = nItemIdx) then begin
                //ȡ�Զ�����Ʒ����
                sUserItemName := '';
                if UserItem.btValue[13] = 1 then
                  sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
                if sUserItemName = '' then sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);
                StdItem := UserEngine.GetStdItem(UserItem.wIndex);
                if StdItem <> nil then begin
                  if CompareText(sUserItemName, sItemName) = 0 then begin
                    n14 := I;
                    Break;
                  end;
                end;
              end;
            end;
            UserItem := nil;
          end;
        end;
        if (StdItem <> nil) and (UserItem <> nil) and (n14 > -1) then begin
          if (StdItem.StdMode = 7) and (StdItem.Shape = 3) then begin//ħѪʯ��Ʒ
            m_UseItems[U_CHARM].Dura:= _MIN(High(Word),m_UseItems[U_CHARM].Dura + UserItem.Dura);
            if m_UseItems[U_CHARM].Dura > m_UseItems[U_CHARM].DuraMax then m_UseItems[U_CHARM].Dura:=m_UseItems[U_CHARM].DuraMax;
            if sDragonIndiaName <> '' then SysMsg(Format('��Ϊ%s�������1��%s���־�������%d��',[sDragonIndiaName, StdItem.Name, UserItem.Dura * 10]), c_Blue, t_Hint);
            boRepairOK := True;
            DelBagItem(n14);
          end;
        end;
      end;
    end;
  end;
  if boRepairOK then begin
    if OldDura <> m_UseItems[U_CHARM].Dura then
      SendMsg(Self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
      SendDefMessage(SM_REPAIRDRAGONINDIA_OK, 1{Ӣ��}, 0, 0, 0, '');
  end else begin
    SendDefMessage(SM_REPAIRDRAGONINDIA_FAIL, 1{Ӣ��}, 0, 0, 0, '');
  end;
end;

//ȡ��ɱλ
function THeroObject.GetGotoXY(BaseObject: TBaseObject; nCode:Byte): Boolean;
begin
  Result := False;
  Case nCode of
    2:begin//��ɱλ
      if (m_nCurrX - 2 <= BaseObject.m_nCurrX) and
         (m_nCurrX + 2 >= BaseObject.m_nCurrX) and
         (m_nCurrY - 2 <= BaseObject.m_nCurrY) and
         (m_nCurrY + 2 >= BaseObject.m_nCurrY) and
        ((m_nCurrX <> BaseObject.m_nCurrX) or (m_nCurrY <> BaseObject.m_nCurrY)) then begin
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

procedure THeroObject.NewGotoTargetXY;
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
    MainOutMessage(Format('{%s} THeroObject.NewGotoTargetXY', [g_sExceptionVer]));
  end;
end;

procedure THeroObject.HeroTail();
var
  nX, nY, nDir: Integer;
begin
  try
    if (GetTickCount - dwTick5F41) > g_Config.dwHeroRunIntervalTime1 then begin//20110717 �޸�
      dwTick5F41 := GetTickCount;
      m_dwAutoAvoidTick := GetTickCount();//20110717 ����
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
    MainOutMessage(Format('{%s} THeroObject.HeroTail', [g_sExceptionVer]));
  end;
end;

procedure THeroObject.Run;
var
  nX, nY, n18, I, II, nWhere, nPercent, nValue: Integer;
  nCheckCode: Byte;
  StdItem: pTStdItem;
  UserItem: pTUserItem;
  boNeedRecalc, boRecalcAbilitys, boFind: Boolean;
resourcestring
  sExceptionMsg = '{%s} THeroObject.Run Code:%d';
begin
  nCheckCode:= 0;
  try
    if (not m_boGhost) and (not m_boDeath) and (not m_boFixedHideMode) and (not m_boStoneMode) then begin
      if g_Config.boAutoHeroUseEat and (not m_boAI) then EatMedicine();//�Զ���ҩ
      if m_boRevengeMode then begin//����ģʽ
        boNeedRecalc:= False;
        for I := 0 to 6 do begin
          if m_wSnapArrValue[I] > 0 then begin
            if GetTickCount() > m_dwSnapArrTimeOutTick[I] then begin
              boNeedRecalc:= True;
              m_wSnapArrValue[I]:= 0;
            end;
          end;
        end;
        if boNeedRecalc then begin
          m_boRevengeMode:= False;
          RecalcAbilitys();
          CompareSuitItem(False);
          SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');
        end;
      end;
      {$IF M2Version <> 2}
      if (not m_boCanUerSkill102) and ((GetTickCount -  m_dwLatest102Tick) >= g_Config.nKill102UseTime * 1000) and (m_Skill69NH > 10)
        and (m_wStatusTimeArr[POISON_STONE] > 0) and (m_Magic102Skill <> nil) then begin//Ψ�Ҷ���,�Զ�����
        if IsAllowUseMagic(SKILL_102) then begin
          m_dwLatest102Tick := GetTickCount();
          ClientSpellXY(m_Magic102Skill, m_nCurrX, m_nCurrY, self); //ʹ��ħ��
          inherited;
          Exit;
        end;
      end;
      {$IFEND}
      if (m_wStatusTimeArr[POISON_STONE] = 0) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
        and (m_wStatusArrValue[23] = 0) then begin//û�б����
        nCheckCode:= 11;
        if Think then begin
          inherited;
          Exit;
        end;
        nCheckCode:= 12;
        {$IF M2Version <> 2}
        if m_Master <> nil then PlaySuperRock;//��Ѫʯ ħѪʯ  20080729
        {$IFEND}
    //----------------------------���ƾ�����������--------------------------------------
        if m_Abil.WineDrinkValue > 0 then begin//��ƶȴ���0ʱ�Ŵ���
          if (GetTickCount() - m_dwAddAlcoholTick + n_DrinkWineQuality * 1000 > (g_Config.nIncAlcoholTick * 1000)) and (not n_DrinkWineDrunk) then begin//���Ӿ�������
            m_dwAddAlcoholTick := GetTickCount();
            SendRefMsg(RM_MYSHOW, 8, 0, 0, 0, ''); //�������Ӷ���  20080623
            Inc(m_Abil.Alcohol, _MAX(5,(n_DrinkWineAlcohol * m_Abil.MaxAlcohol) div 1000));//�ƶ��� ����������
            if m_Abil.Alcohol > m_Abil.MaxAlcohol then begin//��������
              m_Abil.Alcohol:= m_Abil.Alcohol - m_Abil.MaxAlcohol;
              if m_Abil.MaxAlcohol + g_Config.nIncAlcoholValue > High(word) then//20090320 �޸�
                m_Abil.MaxAlcohol:= High(word)
              else m_Abil.MaxAlcohol:= m_Abil.MaxAlcohol+ g_Config.nIncAlcoholValue;
              if m_Magic67Skill <> nil then begin//����Ԫ��ħ������
                m_Magic67Skill.nTranPoint:= m_Abil.MaxAlcohol;
                if not CheckMagicLevelup(m_Magic67Skill) then begin
                  SendDelayMsg(self, RM_HEROMAGIC_LVEXP, m_Magic67Skill.MagicInfo.wMagicId, 0, m_Magic67Skill.btLevel, m_Magic67Skill.nTranPoint, '', 1000);
                end;
                if m_Abil.WineDrinkValue >= abs(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue67 div 100) then begin//�������ڻ���ھ������޵�5%ʱ����Ч
                   if m_Magic67Skill.btLevel > 0 then begin
                     m_WAbil.AC := MakeLong(LoWord(m_WAbil.AC),HiWord(m_WAbil.AC)+ m_Magic67Skill.btLevel * 2);
                     m_WAbil.MAC := MakeLong(LoWord(m_WAbil.MAC), HiWord(m_WAbil.MAC)+ m_Magic67Skill.btLevel * 2);
                     SendMsg(Self, RM_HEROABILITY, 0, 0, 0, 0, '');//20080823 ����
                   end;
                end;
              end;
            end;
            {$IF M2Version <> 2}
            GetNGExp(g_Config.nDrinkIncNHExp, 2); //���������ڹ����� 2008103
            {$IFEND}
            RecalcAbilitys();
            CompareSuitItem(False);//��װ������װ���Ա� 20080729
            SendMsg(Self, RM_HEROMAKEWINEABILITY, 0, 0, 0, 0, '');//��2������� 20080804
          end;

          if GetTickCount() - m_dwDecWineDrinkValueTick > g_Config.nDesDrinkTick * 1000 then begin//������ƶ�
             m_dwDecWineDrinkValueTick:= GetTickCount();
             m_Abil.WineDrinkValue:= _MAX(0, m_Abil.WineDrinkValue - m_Abil.MaxAlcohol div 100);
             if m_Abil.WineDrinkValue = 0 then begin
                n_DrinkWineQuality:= 0;//����ʱ�Ƶ�Ʒ�� 20080627
                n_DrinkWineAlcohol:= 0;//����ʱ�ƵĶ��� 20080627         
                n_DrinkWineDrunk:= False;//�Ⱦ����� 20080623
                if g_sJiujinOverHintMsg <> '' then SysMsg('Ӣ�� '+g_sJiujinOverHintMsg{'�ƾ�������ʧ��,����Ҳ�ָ�ƽ����״̬'},c_Green,t_Hint);//��ʾ�û�
             end;
             RecalcAbilitys();
             CompareSuitItem(False);//��װ������װ���Ա� 20080729
             SendMsg(Self, RM_HEROMAKEWINEABILITY, 0, 0, 0, 0, '');//��2������� 20080804
          end;
        end;
        {$IF M2Version <> 2}
        if m_boTrainingNG then begin//ѧ���ڹ�,���ʱ����������ֵ 20081002
          if GetTickCount() - m_dwIncNHTick > g_Config.dwIncNHTime then begin
            m_dwIncNHTick := GetTickCount();
            n18 := (m_Skill69MaxNH div 75) + 1 + m_nIncNHPoint;//���ڹ��ȼ�ÿ�����ӵ�����ֵ 20090701
            n18 := Round(n18 * ( 1 + m_nIncNHRecover / 100));//�����ָ��ٷ���
            if (m_Skill69NH < m_Skill69MaxNH) then begin
              if m_Skill69NH > High(Integer) - n18 then m_Skill69NH:= High(Integer)
              else m_Skill69NH:= _MIN(m_Skill69MaxNH, m_Skill69NH + n18);// 20090701 �޸�
              if m_Skill69NH > m_Skill69MaxNH then m_Skill69NH:= m_Skill69MaxNH;
              SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
            end;
          end;
          {$IF M2Version = 1}
          if GetTickCount() - m_dwIncTransferTick > g_Config.nIncTransferValueTime then begin
            m_dwIncTransferTick := GetTickCount();
            if (m_WAbil.TransferValue < m_WAbil.MaxTransferValue) and (m_Magic95Skill <> nil) then begin//��תֵ�ظ�
              n18 := (m_WAbil.MaxTransferValue div 10) + 1;//20110128
              m_WAbil.TransferValue:= _MIN(m_WAbil.MaxTransferValue, m_WAbil.TransferValue + n18);
              SendMsg(Self, RM_HEROABILITY, 0, 0, 0, 0, '');
            end;
          end;
          {$IFEND}
        end;
        {$IFEND}
    //------------------------------------------------------------------------------
        nCheckCode:= 1;
        if (not m_boStartUseSpell) and (not m_boDecDragonPoint) then begin
          if m_nFirDragonPoint < g_Config.nMaxFirDragonPoint then begin
            if GetTickCount() - m_dwAddFirDragonTick > g_Config.nIncDragonPointTick{1000 * 3} then begin//20080606 ��ŭ��ʱ��ɵ���
              m_dwAddFirDragonTick := GetTickCount();
              if WearFirDragon and (m_UseItems[U_BUJUK].Dura > 0) then begin    //20080129 ����֮�ĳ־�
                if m_UseItems[U_BUJUK].Dura  >= g_Config.nDecFirDragonPoint then begin
                  Dec(m_UseItems[U_BUJUK].Dura, g_Config.nDecFirDragonPoint);
                end else m_UseItems[U_BUJUK].Dura := 0;
                Inc(m_nFirDragonPoint, g_Config.nAddFirDragonPoint); //����Ӣ��ŭ��
                if m_nFirDragonPoint > g_Config.nMaxFirDragonPoint then m_nFirDragonPoint:=g_Config.nMaxFirDragonPoint;//20071231 ����ŭ��ֵ��ӳ���
                SendMsg(Self, RM_HERODURACHANGE, U_BUJUK, m_UseItems[U_BUJUK].Dura, m_UseItems[U_BUJUK].DuraMax, 0, '');
                SendMsg(Self, RM_FIRDRAGONPOINT, g_Config.nMaxFirDragonPoint, m_nFirDragonPoint, 0, 0, '');
              end;
            end;
          end;
        end else begin
           if m_boDecDragonPoint and WearFirDragon then begin //��ŭ��
             if m_nFirDragonPoint > 0 then begin
               if GetTickCount() - m_dwAddFirDragonTick > 2000{1000 * 2} then begin
                 m_dwAddFirDragonTick := GetTickCount();
                 Dec(m_nFirDragonPoint, (g_Config.nMaxFirDragonPoint div 10)); //��Ӣ��ŭ��  20080525
                 if m_nFirDragonPoint <= 0 then begin
                   m_nFirDragonPoint:= 0;
                   m_boDecDragonPoint:= False;//20080418 ֹͣ��ŭ��
                   m_boStartUseSpell := False;
                 end;
                 SendMsg(Self, RM_FIRDRAGONPOINT, g_Config.nMaxFirDragonPoint, m_nFirDragonPoint, 0, 0, '');
               end;
               //ְҵ��ս,�������,�Զ��źϻ� 20080419
               if (m_TargetCret <> nil) and (not m_TargetCret.m_boDeath) and (m_Master <> nil) then begin
                  case GetTogetherUseSpell of
                     SKILL_60:begin
                        if (m_PEnvir.GetXYObjCount(m_nCurrX, m_nCurrY) < 2) and (m_Magic60Skill <> nil) then begin//20090511 ���Ӣ������λ���Ƿ�����ص�
                          if (((m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0))
                            or (g_ClientConf.boParalyCanSpell)) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
                            and (m_Master.m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_wStatusArrValue[23] = 0)
                            and (m_Master.m_wStatusArrValue[23] = 0) then begin//20080913 ����� //20090105�޸ģ�ֱ�߲ŷ��ƻ�ն
                            if (((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
                                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 1)) or
                                ((abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 2)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_nCurrX) = 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 3)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_nCurrX) = 3) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 0)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) = 3)) ) and//20100719 �ļ��ƻ�ն3��
                               (((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 0)) or
                                ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 1) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 1)) or
                                ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 2)) or
                                ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 2) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 0)) or
                                ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 1)) or
                                ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 2)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 3) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 3)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 3) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 0)) or
                                ((m_Magic60Skill.btLevel = 4) and (abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) = 0) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) = 3))) then begin//20100719 �ļ��ƻ�ն3��
                               m_boDecDragonPoint:= False;//ֹͣ��ŭ��
                               m_boStartUseSpell := True;//�ϻ����ܿ���
                               m_dwStartUseSpellTick := GetTickCount();
                            end;
                          end;
                        end;
                      end;
                    SKILL_61,SKILL_62:begin//����ն,����һ��
                       if (((m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0))
                          or (g_ClientConf.boParalyCanSpell)) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
                          and (m_Master.m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_Master.m_wStatusArrValue[23] = 0)
                          and (m_wStatusArrValue[23] = 0) then begin//20080913 �����
                         if ((m_btJob = 0) and ((abs(m_TargetCret.m_nCurrX - m_nCurrX) <= 2) and (abs(m_TargetCret.m_nCurrY - m_nCurrY) <= 2))) or
                            ((m_Master.m_btJob = 0) and ((abs(m_TargetCret.m_nCurrX - m_Master.m_nCurrX) <= 2) and (abs(m_TargetCret.m_nCurrY - m_Master.m_nCurrY) <= 2))) then begin
                            m_boDecDragonPoint:= False;//ֹͣ��ŭ��
                            m_boStartUseSpell := True;//�ϻ����ܿ���
                            m_dwStartUseSpellTick := GetTickCount();
                         end;
                       end;
                     end;
                    SKILL_63,SKILL_64,SKILL_65:begin//20080913 �����
                       if (((m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0))
                         or (g_ClientConf.boParalyCanSpell)) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
                         and (m_Master.m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_Master.m_wStatusArrValue[23] = 0)
                         and (m_wStatusArrValue[23] = 0) then begin
                         m_boDecDragonPoint:= False;//ֹͣ��ŭ��
                         m_boStartUseSpell := True;//�ϻ����ܿ���
                         m_dwStartUseSpellTick := GetTickCount();
                       end;
                    end;
                  end;
               end;//if m_nFirDragonPoint > 0 then begin
             end;//if m_boDecDragonPoint and WearFirDragon then begin //��ŭ��
           end;
          if m_boStartUseSpell and (GetTickCount - m_dwStartUseSpellTick > 3000) then begin
           // m_nStartUseSpell := 0;
            m_boStartUseSpell := False;
            m_boDecDragonPoint:= False;//20080418 ֹͣ��ŭ��
          end;
          SendMsg(Self, RM_FIRDRAGONPOINT, g_Config.nMaxFirDragonPoint, m_nFirDragonPoint, 0, 0, '');//����Ӣ��ŭ��ֵ
        end;

        if m_boFireHitSkill and ((GetTickCount - m_dwLatestFireHitTick) > 20000) then m_boFireHitSkill := False;//20���ٻ��һ����
        if m_boDailySkill and ((GetTickCount - m_dwLatestDailyTick) > 20000) then m_boDailySkill := False;//20������ս�������
        {$IF M2Version <> 2}
        if m_boCanUerSkill101 and ((GetTickCount - m_dwUseSkillTime) > g_Config.nKill101UseLogTime * 1000) then begin//�ر���������
          m_boCanUerSkill101:= False;
          if sSkill101Off1 <> '' then SysMsg('(Ӣ��) ' + sSkill101Off1, BB_Fuchsia, t_Hint);
        end;
        {$IFEND}
        if GetTickCount - m_dwRateTick > 1000 then begin//ÿ�봦��
          m_dwRateTick := GetTickCount();
          if (m_Abil.MedicineValue > 0) and (dw_UseMedicineTime > 0) then begin//��ʱ�䲻�Ⱦƣ����ҩ��ֵ 20091111
            Dec(dw_UseMedicineTime);
            if dw_UseMedicineTime <= 0 then begin//ʹ��ʱ�䵽
              m_Abil.MedicineValue:= _MAX(0, m_Abil.MedicineValue - g_Config.nDesMedicineValue);
              if m_Abil.MedicineValue > 0 then dw_UseMedicineTime:= g_Config.nDesMedicineTick;//ʼ��ʹ��ҩ��ʱ��(12Сʱ)
              RecalcAbilitys();
              CompareSuitItem(False);//200080729 ��װ
              SendMsg(Self, RM_HEROMAKEWINEABILITY, 0, 0, 0, 0, '');//��2�������
            end;
          end;
          {$IF M2Version <> 2}
          if m_boCanUerSkill102 then begin//Ψ�Ҷ��������
            if GetTickCount > m_dwUseSkill102Time then begin
              m_boCanUerSkill102:= False;
              if sSkill102Off1 <> '' then SysMsg('(Ӣ��) ' + sSkill102Off1, BB_Fuchsia, t_Hint);
            end else begin
              if m_Skill69NH >= 250 then begin//ÿ���250����
                m_Skill69NH := _MAX(0, m_Skill69NH - 250);
                SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
              end else begin//����������ֹͣ
                m_boCanUerSkill102:= False;
                if sSkill102Off1 <> '' then SysMsg('(Ӣ��) ' + sSkill102Off1, BB_Fuchsia, t_Hint);
              end;
            end;
          end;
          {$IFEND}
          {$IF M2Version = 1}
          //����������ָ��ֵ�󣬳�ʱ�䲻�Ⱦƣ�������� 20100212
          if (m_Abil.MaxAlcohol > g_Config.nDesMaxAlcoholValue) and (dw_UseMedicineTime1 > 0) and (not m_boDeath) and (not m_boGhost) then begin
            Inc(n_UsesMedicineTime);//���Ⱦ�ʱ��һ���Ӽ�ʱ
            if n_UsesMedicineTime >= 60 then begin
              Dec(dw_UseMedicineTime1);
              n_UsesMedicineTime:= 0;
              if dw_UseMedicineTime1 <= 0 then begin
                m_Abil.Alcohol:= _MAX(0, m_Abil.Alcohol - g_Config.nDesAlcoholValue);
                m_Abil.MaxAlcohol:= _MAX(g_Config.nDesMaxAlcoholValue, m_Abil.MaxAlcohol - g_Config.nDesAlcoholValue);
                if m_Abil.MaxAlcohol > g_Config.nDesMaxAlcoholValue then dw_UseMedicineTime1:= g_Config.nDesAlcoholTick;//ʼ��ʹ�úȾ�ʱ��
                RecalcAbilitys();
                CompareSuitItem(False);
                SendMsg(Self, RM_HEROMAKEWINEABILITY, 0, 0, 0, 0, '');//��2�������
              end;
            end;
          end;
          {$IFEND}
        end;
        {$IF M2Version = 1}
        if m_boUseBatter and (m_btJob = 0) then begin//սʹ��������10��δʹ�ã����Զ��ر�
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
        {$IFEND}
        nCheckCode:= 2;
        if IsSearchTarget then SearchTarget(); //����Ŀ�� 20080327
        //m_dwWalkWait := 10;
        //m_nWalkSpeed := 10;
        nCheckCode:= 21;
        if m_boWalkWaitLocked then begin
          if (GetTickCount - m_dwWalkWaitTick) > m_dwWalkWait then m_boWalkWaitLocked := False;
        end;

        if not m_boWalkWaitLocked and ((GetTickCount - m_dwWalkTick) > m_nWalkSpeed) then begin
          m_dwWalkTick := GetTickCount();
          if m_btRaceServer <> RC_HEROOBJECT then begin//20090212 �ָ�
            Inc(m_nWalkCount);
            if m_nWalkCount > m_nWalkStep then begin
              m_nWalkCount := 0;
              m_boWalkWaitLocked := True;
              m_dwWalkWaitTick := GetTickCount();
            end;
          end;
          nCheckCode:= 22;
          if not m_boRunAwayMode then begin
            if not m_boNoAttackMode then begin
              if m_boProtectStatus then begin//�ػ�״̬,����̫Զ,ֱ�ӷɹ�ȥ  20080417
                if not m_boProtectOK then begin//û�ߵ��ػ����� 20080603
                  if RunToTargetXY(m_nProtectTargetX, m_nProtectTargetY) then m_boProtectOK:= True
                  else if WalkToTargetXY2(m_nProtectTargetX, m_nProtectTargetY) then m_boProtectOK:= True; //ת��
                end;
              end;
              nCheckCode:= 60;
              if (m_TargetCret <> nil) then begin
                if m_boStartUseSpell then begin
                  nCheckCode:= 61;
                  m_nSelectMagic := GetTogetherUseSpell; //�жϺϻ�ħ��ID
                  nCheckCode:= 62;
                  if (m_btJob = 0) and (m_nSelectMagic = 60) then //20080227  ����Ϣ��ǰ�Ƿ��ͺϻ� ���ͻ��˵���Ϣ  ����ûʵ���ô�  �����ڷ��ƻ��ȹ�����ʾ�±���������
                    SendMsg(m_TargetCret, RM_GOTETHERUSESPELL, m_nSelectMagic, m_TargetCret.m_nCurrX, m_TargetCret.m_nCurrY, 0, '');//ʹ�úϻ�
                  m_nFirDragonPoint := 0;//���ŭ��
                end;
                nCheckCode:= 64;
                if AttackTarget then begin//���� 20080710
                  nCheckCode:= 70;
                  m_boStartUseSpell := False;
                  inherited;
                  Exit;
                end else if not m_boWalkWaitLocked then begin

                if IsNeedAvoid then begin //�Զ����
                  nCheckCode:= 71;
                  m_dwActionTick := GetTickCount()- 10;//20080720
                  AutoAvoid();
                  inherited;
                  Exit;
                end else begin
                  nCheckCode:= 73;
                  if IsNeedGotoXY then begin//�Ƿ�����Ŀ��
                    nCheckCode:= 72;
                    m_dwActionTick := GetTickCount();//20080718 ����
                    m_nTargetX:= m_TargetCret.m_nCurrX;
                    m_nTargetY:= m_TargetCret.m_nCurrY;
                    if (IsAllowUseMagic(12) or IsAllowUseMagic(SKILL_89)) and (m_btJob = 0) then GetGotoXY(m_TargetCret, 2);//20080617 �޸�
                    if (m_btJob > 0) then begin                                    //20090106
                      if (g_Config.boHeroAttackTarget and (m_Abil.Level < 22)) or
                       (g_Config.boHeroAttackTao and (m_TargetCret.m_WAbil.MaxHP < 700) and (m_btJob = 2) and (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT)) then begin//20081218 ����22ǰ�Ƿ�������
                        if m_Master <> nil then begin//20090111
                          if (abs(m_Master.m_nCurrX - m_nCurrX) > 6) or (abs(m_Master.m_nCurrY - m_nCurrY) > 6) then begin
                            inherited;
                            Exit;
                          end;
                        end;
                      end else GetGotoXY(m_TargetCret, 3);//20080710 ����ֻ����Ŀ��3��Χ
                    end;
                    GotoTargetXY( m_nTargetX, m_nTargetY, 0);
                    inherited;
                    Exit;
                  end;
                end;
                end;
              end else begin
                if not m_boProtectStatus then m_nTargetX := -1;
              end;
            end;
            nCheckCode:= 8;
            if m_TargetCret <> nil then begin
              m_nTargetX := m_TargetCret.m_nCurrX;
              m_nTargetY := m_TargetCret.m_nCurrY;
            end;
            {nCheckCode:= 81; //20101027 ע��
            if SearchIsPickUpItem then begin
              nCheckCode:= 82;
              SearchPickUpItem(500);
              inherited;
              Exit;
            end; }
            nCheckCode:= 9;
            if m_Master <> nil then begin
              if m_boProtectStatus then begin //�ػ�״̬
                if (abs(m_nCurrX - m_nProtectTargetX) > 9{6}) or (abs(m_nCurrY - m_nProtectTargetY) > 9{6}) then begin//20081219 �޸��ػ���Χ
                  m_nTargetX := m_nProtectTargetX;
                  m_nTargetY := m_nProtectTargetY;
                  m_TargetCret := nil;
                end else begin
                  m_nTargetX := -1;
                end;
              end else begin
                if (m_TargetCret = nil) and (not m_boProtectStatus) and (m_btStatus <> 2) then begin
                  nCheckCode:= 95;
                  m_Master.GetBackPosition(nX, nY);
                  if (abs(m_nTargetX - nX) > 2{1}) or (abs(m_nTargetY - nY ) > 2{1}) then begin//20081016 �޸�2��
                    m_nTargetX := nX;
                    m_nTargetY := nY;
                    if (abs(m_nCurrX - nX) <= 3{2}) and (abs(m_nCurrY - nY) <= 3{2}) then begin//20081016
                      if m_PEnvir.GetMovingObject(nX, nY, True) <> nil then begin
                        m_nTargetX := m_nCurrX;
                        m_nTargetY := m_nCurrY;
                      end;
                    end; 
                  end;
                end; //if m_TargetCret = nil then begin
              end;
              nCheckCode:= 12;
              if m_Master <> nil then begin//20090128
                if (not m_boProtectStatus) and ((m_btStatus = 1) or ((m_btStatus = 0) and ((m_TargetCret = nil) or (not g_Config.boHeroAttackNoFollow)))) and//20090722 �޸�
                  ((m_PEnvir <> m_Master.m_PEnvir) or
                  (abs(m_nCurrX - m_Master.m_nCurrX) > 20) or//20090723 12��Ϊ20
                  (abs(m_nCurrY - m_Master.m_nCurrY) > 20)) then begin
                  nCheckCode:= 96;
                  m_Master.GetBackPosition(m_nTargetX, m_nTargetY);//20090525 ����
                  SpaceMove(m_Master.m_PEnvir.sMapName, m_nTargetX, m_nTargetY, 1);
                end;
              end;
              if (m_TargetCret <> nil) then begin//��Ŀ����Ӣ�۲���ͬ����ͼ��ɾ��Ŀ�� 20081214
                nCheckCode:= 13;
                if (m_TargetCret.m_PEnvir <> m_PEnvir) then DelTargetCreat();
              end;
            end; //if m_Master <> nil then begin
          end else begin
            if (m_dwRunAwayTime > 0) and ((GetTickCount - m_dwRunAwayStart) > m_dwRunAwayTime) then begin
              m_boRunAwayMode := False;
              m_dwRunAwayTime := 0;
            end;
          end;
          nCheckCode:= 10;

          if m_boAI and (not m_boGhost) and (not m_boDeath) then begin
{$REGION '�Զ�����'}
            if g_Config.boAutoRepairItem then begin//�Ƿ������Զ�����
              if GetTickCount - m_dwAutoRepairItemTick > 15000 then begin
                m_dwAutoRepairItemTick := GetTickCount;
                boRecalcAbilitys := False;
                for nWhere := Low(THumanUseItems) to High(THumanUseItems) do begin//9��װ��+4��װ��
                  if (m_UseItemNames[nWhere] <> '') and (m_UseItems[nWhere].wIndex <= 0) then begin
                    StdItem := UserEngine.GetStdItem(m_UseItemNames[nWhere]);
                    if StdItem <> nil then begin
                      New(UserItem);
                      if UserEngine.CopyToUserItemFromName(m_UseItemNames[nWhere], UserItem) then begin
                        boRecalcAbilitys := True;
                        if StdItem.StdMode in [15, 19, 20, 21, 22, 23, 24, 26] then begin
                          if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                            UserEngine.GetUnknowItemValue(UserItem);
                          end;
                        end;
                      end;
                      m_UseItems[nWhere] := UserItem^;
                      Dispose(UserItem);
                    end;
                  end;
                end;
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
                    if not boFind then begin
                      New(UserItem);
                      if UserEngine.CopyToUserItemFromName(m_BagItemNames.Strings[I], UserItem) then begin
                        if not AddItemToBag(UserItem) then begin
                          Dispose(UserItem);
                          break;
                        end;
                      end else Dispose(UserItem);
                    end;
                  end;
                end;
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
                if boRecalcAbilitys then RecalcAbilitys;
              end;
            end;
{$EndREGION '�Զ�����'}
{$REGION '�Զ�����HP MP'}
            if g_Config.boRenewHealth then begin//�Զ�����HP MP
              if GetTickCount - m_dwAutoAddHealthTick > 5000 then begin
                m_dwAutoAddHealthTick := GetTickCount;
                nPercent := m_WAbil.HP * 100 div m_WAbil.MaxHP;
                nValue := m_WAbil.MaxHP div 10;
                if nPercent < g_Config.nRenewPercent then begin
                  if m_WAbil.HP + nValue >= m_WAbil.MaxHP then begin
                    m_WAbil.HP := m_WAbil.MaxHP; // HeroHP
                  end else begin
                    Inc(m_WAbil.HP, nValue);
                  end;
                end;

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
{$EndREGION '�Զ�����HP MP'}
          end;
         { if (m_Master <> nil) and m_Master.m_boSlaveRelax then begin //20080408 Ӣ��������Ϊ��Ϣʱ,����Ϣ
            inherited;
            Exit;
          end; }
          if (m_TargetCret = nil) and (m_btStatus <> 2) then begin
            if m_nTargetX <> -1 then begin
              if (abs(m_nCurrX - m_nTargetX) > 1) or (abs(m_nCurrY - m_nTargetY) > 1) then begin
                GotoTargetXY(m_nTargetX, m_nTargetY, 0);
              end;
            end else begin
              Wondering();
            end;
          end;
        end;

      end else begin//���ʱ,��������ŭ�� 20081204
        nCheckCode:= 11;
        if (not m_boStartUseSpell) and (not m_boDecDragonPoint) then begin
          if m_nFirDragonPoint < g_Config.nMaxFirDragonPoint then begin
            if GetTickCount() - m_dwAddFirDragonTick > g_Config.nIncDragonPointTick then begin//20080606 ��ŭ��ʱ��ɵ���
              m_dwAddFirDragonTick := GetTickCount();
              if WearFirDragon and (m_UseItems[U_BUJUK].Dura > 0) then begin    //20080129 ����֮�ĳ־�
                if m_UseItems[U_BUJUK].Dura  >= g_Config.nDecFirDragonPoint then begin
                  Dec(m_UseItems[U_BUJUK].Dura, g_Config.nDecFirDragonPoint);
                end else begin
                  m_UseItems[U_BUJUK].Dura := 0;
                  //m_UseItems[U_BUJUK].wIndex:= 0;//20081014 20081218 ���������֮��
                end;
                Inc(m_nFirDragonPoint, g_Config.nAddFirDragonPoint); //����Ӣ��ŭ��
                if m_nFirDragonPoint > g_Config.nMaxFirDragonPoint then m_nFirDragonPoint:=g_Config.nMaxFirDragonPoint;//20071231 ����ŭ��ֵ��ӳ���
                SendMsg(Self, RM_HERODURACHANGE, U_BUJUK, m_UseItems[U_BUJUK].Dura, m_UseItems[U_BUJUK].DuraMax, 0, '');
                SendMsg(Self, RM_FIRDRAGONPOINT, g_Config.nMaxFirDragonPoint, m_nFirDragonPoint, 0, 0, '');
              end;
            end;
          end;
        end;
      end;
    end;
    //inherited;//20090213
  except
    on E: Exception do begin
      MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
    end;
  end;
  inherited;//20090213 �ƶ�λ�ã���ֹ�쳣�˲��ܶ�
end;

procedure THeroObject.RecalcAbilitys;
begin
  inherited;
  if m_btRaceServer = RC_HEROOBJECT then begin
    SendUpdateMsg(Self, RM_CHARSTATUSCHANGED, m_nHitSpeed, m_nCharStatus, 0, 0, '');
    RecalcAdjusBonus();//ˢ��Ӣ������������20081126
  end;
end;
//Ӣ������   ����Ӣ������  ���ﱻ���� Ӣ���Զ�ǿ���ٻ�  20080129
procedure THeroObject.Die;
var
  nDecExp: Integer;
begin
  {$IF HEROVERSION = 1}
  if (m_Master <> nil) then begin
    {$IF M2Version <> 2}
    TPlayObject(m_Master).m_nDieCount:= _MIN(High(Byte), TPlayObject(m_Master).m_nDieCount + 1);
    {$IFEND}
    TPlayObject(m_Master).m_boHeroDieTreatment:= True;//Ӣ������������
  end;
  try
    inherited;
    //����������,���鲻��,�򽵼� 20080605
    if g_Config.boHeroDieExp then begin
      nDecExp:= Round({GetLevelExp(m_Abil.Level)}m_Abil.nExp * (g_Config.nHeroDieExpRate / 10000));//�����о����һ������ 20090909
      SysMsg('(Ӣ��) �������侭��ֵ������ '+IntToStr(nDecExp), c_Red, t_Hint); //20090108
      if m_Abil.nExp >= nDecExp then begin
        Dec(m_Abil.nExp, nDecExp);
      end else begin
        m_Abil.nExp := 0;//20090108 ���꾭�鲻����
        {if m_Abil.Level >= 1 then begin
           Dec(m_Abil.Level);
           Inc(m_Abil.Exp, GetLevelExp(m_Abil.Level));
           Dec(m_Abil.Exp, nDecExp);
           if m_Abil.Exp < 0 then m_Abil.Exp:= 0;
        end else begin
           m_Abil.Level := 0;
           m_Abil.Exp := 0;
        end;}
      end;
    end;

    if (m_btRaceServer = RC_HEROOBJECT) and (m_Master <> nil) then begin //����Ӣ��������Ϣ
      if TPlayObject(m_Master).m_sDeputyHeroName <> '' then begin
        if TPlayObject(m_Master).m_boCallDeputyHero then begin//����Ӣ������
          TPlayObject(m_Master).m_boCallDeputyHero:= False;
          TPlayObject(m_Master).m_nRecallDeputyHeroTime:= GetTickCount();
        end else begin//��������
          TPlayObject(m_Master).m_nRecallHeroTime:= GetTickCount();//�ٻ�����Ӣ�ۼ��
          TPlayObject(m_Master).SendMsg(TPlayObject(m_Master), RM_MOVEMESSAGE1, 2{����ʱ��Ϣ}, 251, 0, 60, '��ø�����%s����');//����ģʽ����ʱ
          TPlayObject(m_Master).m_boMainHeroDie:= True;//��������
          TPlayObject(m_Master).m_boMainHeroDieTick:= GetTickCount();//����������ʱ�����ڸ�������ģʽ��ʱ
        end;
      end else TPlayObject(m_Master).m_nRecallHeroTime:= GetTickCount();//�ٻ�Ӣ�ۼ��
      if TPlayObject(m_Master).m_boAI then begin//��������
        TAIPlayObject(m_Master).m_boAutoRecallHero:= True;//�Զ��ٻ�Ӣ��
      end;
      m_nLoyal:=_MAX(0,m_nLoyal - g_Config.nDeathDecLoyal);//���������ҳ϶� 20080110
      UserEngine.SaveHeroRcd(TPlayObject(m_Master));//��������
      TPlayObject(m_Master).m_MyHero := nil;
    end;
  finally
    if (m_Master <> nil) then TPlayObject(m_Master).m_boHeroDieTreatment:= False;//Ӣ������������
  end;
  {$IFEND}
end;

function THeroObject.FindMagic(wMagIdx: Word): pTUserMagic;
var
  UserMagic: pTUserMagic;
  I: Integer;
begin
  Result := nil;
  try
    if m_MagicList.Count > 0 then begin//20080630
      for I := 0 to m_MagicList.Count - 1 do begin
        UserMagic := m_MagicList.Items[I];
        if UserMagic <> nil then begin//20090502 ����
          if UserMagic.MagicInfo.wMagicId = wMagIdx then begin
            Result := UserMagic;
            Break;
          end;
        end;
      end;
    end;
  except
    Result := nil;//20090502 ����
  end;
end;

function THeroObject.FindMagic1(sMagicName: string): pTUserMagic;
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
//Ӣ�ۼ�鴩��װ��������
function THeroObject.CheckTakeOnItems(nWhere: Integer; var StdItem: TStdItem): Boolean;
  function GetUserItemWeitht(nWhere: Integer): Integer;
  var
    I: Integer;
    n14: Integer;
    StdItem: pTStdItem;
  begin
    n14 := 0;
    for I := Low(THumanUseItems) to High(THumanUseItems) do begin
      if (nWhere = -1) or (not (I = nWhere) and not (I = 1) and not (I = 2)) then begin
        StdItem := UserEngine.GetStdItem(m_UseItems[I].wIndex);
        if StdItem <> nil then Inc(n14, StdItem.Weight);
      end;
    end;
    Result := n14;
  end;
var
  Castle: TUserCastle;
begin
  Result := False;
  if (StdItem.StdMode = 10) and (m_btGender <> 0) then begin
    if sWearNotOfWoMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfWoMan, BB_Fuchsia, t_Hint); //20080312
    Exit;
  end;
  if (StdItem.StdMode = 11) and (m_btGender <> 1) then begin
    if sWearNotOfMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfMan, BB_Fuchsia, t_Hint); //20080312
    Exit;
  end;
  if (nWhere = 1) or (nWhere = 2) then begin
    if StdItem.Weight > m_WAbil.MaxHandWeight then begin
      if sHandWeightNot <> '' then SysMsg('(Ӣ��) '+sHandWeightNot, BB_Fuchsia, t_Hint); //20080312
      Exit;
    end;
  end else begin
    if (StdItem.Weight + GetUserItemWeitht(nWhere)) > m_WAbil.MaxWearWeight then begin
      if sWearWeightNot <> '' then SysMsg('(Ӣ��) '+sWearWeightNot, BB_Fuchsia, t_Hint);//20080312
      Exit;
    end;
  end;
  case StdItem.Need of //
    0,14,18,22,26,30,34,45,49,53,65,71, 91: begin//9---�ȼ�+����װ����Ӣ�۲������������(��������)  18-��ȼ���װ������������ָ��ٶ�%(��ţ��װ) 26-��ȼ���װ��(Stock)�����ӷ������� 30-��ȼ���װ��(Stock)��������Ѫ���� 34-��ȼ���������  45-��ȼ����������  49-������������ȼ�  53-Ӣ����Ʒ��ȼ� 65-Ŀ�걬��
        if m_Abil.Level >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          if g_sLevelNot <> '' then SysMsg('(Ӣ��) '+g_sLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    1,15,19,23,27,31,35,46,50,54,66,72,92: begin//15--����+���� ��Ӣ�۲������������(��������)  19-�蹥������װ������������ָ��ٶ�%   27-�蹥������װ��(Stock)�����ӷ������� 31-�蹥������װ��(Stock)��������Ѫ���� 35-�蹥������������ 46-�蹥������������� 50-�����������蹥�� 54-Ӣ����Ʒ�蹥���� 66-Ŀ�걬��
        if HiWord(m_WAbil.DC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          if g_sDCNot <>'' then SysMsg('(Ӣ��) '+g_sDCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    2,16,20,24,28,32,36,47,51,55,67,73,93: begin//16--ħ��+������Ӣ�۲������������(��������) 20-��ħ������װ������������ָ��ٶ�%  28-��ħ����װ��(Stock)�����ӷ������� 32-��ħ����װ��(Stock)��������Ѫ���� 36-��ħ����������  47-��ħ�����������  51-������������ħ��  55-Ӣ����Ʒ��ħ�� 67-Ŀ�걬��
        if HiWord(m_WAbil.MC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          if g_sMCNot <> '' then SysMsg('(Ӣ��) '+g_sMCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    3,17,21,25,29,33,37,48,52,56,68,74,94: begin//17--����+������Ӣ�۲������������(��������) 21-�������װ������������ָ��ٶ�%  29-�������װ��(Stock)�����ӷ������� 33-�������װ��(Stock)��������Ѫ���� 37-������������� 48-��������������  52-��������������� 56-Ӣ����Ʒ����� 68-Ŀ�걬��
        if HiWord(m_WAbil.SC) >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          if g_sSCNot <> '' then SysMsg('(Ӣ��) '+g_sSCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    4: begin
        if m_btReLevel >= StdItem.NeedLevel then begin
          Result := True;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+g_sReNewLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;      
    10: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (m_Abil.Level >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sJobOrLevelNot <> '' then SysMsg('(Ӣ��) '+g_sJobOrLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    11: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.DC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sJobOrDCNot <> '' then SysMsg('(Ӣ��) '+g_sJobOrDCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    12: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.MC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sJobOrMCNot <> '' then SysMsg('(Ӣ��) '+g_sJobOrMCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    13: begin
        if (m_btJob = LoWord(StdItem.NeedLevel)) and (HiWord(m_WAbil.SC) >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sJobOrSCNot <> '' then SysMsg('(Ӣ��) '+g_sJobOrSCNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    40: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if m_Abil.Level >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            if g_sLevelNot <> '' then SysMsg('(Ӣ��) '+g_sLevelNot, BB_Fuchsia, t_Hint); //20080312
          end;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+g_sReNewLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    41: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.DC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            if g_sDCNot <>'' then SysMsg('(Ӣ��) '+g_sDCNot, BB_Fuchsia, t_Hint);//20080312
          end;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+g_sReNewLevelNot, BB_Fuchsia, t_Hint); //20080312
        end;
      end;
    42: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.MC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            if g_sMCNot <> '' then SysMsg('(Ӣ��) '+g_sMCNot, BB_Fuchsia, t_Hint);//20080312
          end;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+g_sReNewLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    43: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.SC) >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
          end else begin
            if g_sSCNot <> '' then SysMsg('(Ӣ��) '+g_sSCNot, BB_Fuchsia, t_Hint);//20080312
          end;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+g_sReNewLevelNot, BB_Fuchsia, t_Hint);//20080312
        end;
      end;
    44: begin
        if m_btReLevel >= LoWord(StdItem.NeedLevel) then begin //����װ��,������ 20080509
         // if m_btCreditPoint >= HiWord(StdItem.NeedLevel) then begin
            Result := True;
         // end else begin
            //SysMsg('(Ӣ��)'+g_sCreditPointNot, BB_Fuchsia, t_Hint);//20080118
         //   SysMsg('(Ӣ��)'+g_sLevelNot, BB_Fuchsia, t_Hint);// 20080426
         // end;
        end else begin
          if g_sReNewLevelNot <> '' then SysMsg('(Ӣ��) '+ g_sReNewLevelNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    5: begin //����װ��,������ 20080509
        //if m_btCreditPoint >= StdItem.NeedLevel then begin
          Result := True;
        //end else begin
          //SysMsg('(Ӣ��)'+g_sCreditPointNot, BB_Fuchsia, t_Hint);//20080118
        //  SysMsg('(Ӣ��)'+g_sLevelNot, BB_Fuchsia, t_Hint);// 20080426
       // end;
      end;
    6: begin
        if (m_MyGuild <> nil) then begin
          Result := True;
        end else begin
          if g_sGuildNot <>'' then SysMsg('(Ӣ��) '+g_sGuildNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    60: begin
        if (m_MyGuild <> nil) and (m_nGuildRankNo = 1) then begin
          Result := True;
        end else begin
          if g_sGuildMasterNot <> '' then SysMsg('(Ӣ��) '+g_sGuildMasterNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    61: begin//�Ա���Ʒ����Ҫ�ȼ�
        if (m_btGender = StdItem.NeedLevel) then begin
          if m_Abil.Level >= StdItem.Stock then begin
            Result := True;
          end else begin
            if g_sLevelNot <> '' then SysMsg('(Ӣ��) '+g_sLevelNot, BB_Fuchsia, t_Hint);
          end;
        end else begin
          case StdItem.NeedLevel of
            0: if sWearNotOfWoMan <>'' then SysMsg('(Ӣ��) '+sWearNotOfWoMan, BB_Fuchsia, t_Hint);
            1: if sWearNotOfMan <>'' then SysMsg('(Ӣ��) '+sWearNotOfMan, BB_Fuchsia, t_Hint);
          end;
        end;
      end;
    62: begin//�Ա���Ʒ����Ҫ����
        if (m_btGender = StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.DC) >= StdItem.Stock then begin
            Result := True;
          end else begin
            if g_sDCNot <>'' then SysMsg('(Ӣ��) '+g_sDCNot, BB_Fuchsia, t_Hint);
          end;
        end else begin
          case StdItem.NeedLevel of
            0: if sWearNotOfWoMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfWoMan, BB_Fuchsia, t_Hint);
            1: if sWearNotOfMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfMan, BB_Fuchsia, t_Hint);
          end;
        end;
      end;
    63: begin//�Ա���Ʒ����Ҫħ��
        if (m_btGender = StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.MC) >= StdItem.Stock then begin
            Result := True;
          end else begin
            if g_sMCNot <> '' then SysMsg('(Ӣ��) '+g_sMCNot, BB_Fuchsia, t_Hint);
          end;
        end else begin
          case StdItem.NeedLevel of
            0: if sWearNotOfWoMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfWoMan, BB_Fuchsia, t_Hint);
            1: if sWearNotOfMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfMan, BB_Fuchsia, t_Hint);
          end;
        end;
      end;
    64: begin//�Ա���Ʒ����Ҫ����
        if (m_btGender = StdItem.NeedLevel) then begin
          if HiWord(m_WAbil.SC) >= StdItem.Stock then begin
            Result := True;
          end else begin
            if g_sSCNot <> '' then SysMsg('(Ӣ��) '+g_sSCNot, BB_Fuchsia, t_Hint);
          end;
        end else begin
          case StdItem.NeedLevel of
            0: if sWearNotOfWoMan <> '' then SysMsg('(Ӣ��) '+sWearNotOfWoMan, BB_Fuchsia, t_Hint);
            1: if sWearNotOfMan <>'' then SysMsg('(Ӣ��) '+sWearNotOfMan, BB_Fuchsia, t_Hint);
          end;
        end;
      end;
    7: begin
        Castle := g_CastleManager.IsCastleMember(Self);//20090911 ����
        if (m_MyGuild <> nil) and (Castle <> nil) then begin
          Result := True;
        end else begin
          if g_sSabukHumanNot <> '' then SysMsg('(Ӣ��) '+g_sSabukHumanNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    70: begin
        Castle := g_CastleManager.IsCastleMember(Self);//20090911 ����
        if (m_MyGuild <> nil) and (Castle <> nil) and (m_nGuildRankNo = 1) then begin
          if m_Abil.Level >= StdItem.NeedLevel then begin
            Result := True;
          end else begin
            if g_sLevelNot <> '' then SysMsg('(Ӣ��) '+g_sLevelNot, BB_Fuchsia, t_Hint);//20080118
          end;
        end else begin
          if g_sSabukMasterManNot <> '' then SysMsg('(Ӣ��) '+g_sSabukMasterManNot, BB_Fuchsia, t_Hint); //20080118
        end;
      end;
    8: begin
        if m_nMemberType <> 0 then begin
          Result := True;
        end else begin
          if g_sMemberNot <>'' then SysMsg('(Ӣ��) '+g_sMemberNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    81: begin
        if (m_nMemberType = LoWord(StdItem.NeedLevel)) and (m_nMemberLevel >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sMemberTypeNot <>'' then SysMsg('(Ӣ��) '+g_sMemberTypeNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
    82: begin
        if (m_nMemberType >= LoWord(StdItem.NeedLevel)) and (m_nMemberLevel >= HiWord(StdItem.NeedLevel)) then begin
          Result := True;
        end else begin
          if g_sMemberTypeNot <>'' then SysMsg('(Ӣ��) '+g_sMemberTypeNot, BB_Fuchsia, t_Hint);//20080118
        end;
      end;
  end;
end;
//ȡ�������ĵ�MPֵ
function THeroObject.GetSpellPoint(UserMagic: pTUserMagic): Integer;
begin
  Result := Round(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
end;
//Ӣ�۽���Ұ����ײ 20080331
function THeroObject.DoMotaebo(nDir: Byte; nMagicLevel: Integer): Boolean;
  function CanMotaebo(BaseObject: TBaseObject): Boolean;
  var
    nC: Integer;
  begin
    Result := False;
    if (m_Abil.Level > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
      nC := m_Abil.Level - BaseObject.m_Abil.Level;
      if Random(20) < ((nMagicLevel * 4) + 6 + nC) then begin
        if IsProperTarget(BaseObject) then Result := True;
      end;
    end;
  end;
var
  bo35: Boolean;
  I, n20, n24, n28: Integer;
  PoseCreate: TBaseObject;
  BaseObject_30: TBaseObject;
  BaseObject_34: TBaseObject;
  nX, nY: Integer;
begin
  Result := False;
  bo35 := True;
  m_btDirection := nDir;
  BaseObject_34 := nil;
  n24 := nMagicLevel + 1;
  n28 := n24;
  PoseCreate := GetPoseCreate();
  if PoseCreate <> nil then begin
    for I := 0 to _MAX(2, nMagicLevel + 1) do begin
      PoseCreate := GetPoseCreate();
      if PoseCreate <> nil then begin
        n28 := 0;
        if not CanMotaebo(PoseCreate) then Break;
        if nMagicLevel >= 3 then begin
          if m_PEnvir.GetNextPosition(m_nCurrX, m_nCurrY, m_btDirection, 2, nX, nY) then begin
            BaseObject_30 := m_PEnvir.GetMovingObject(nX, nY, True);
            if (BaseObject_30 <> nil) and CanMotaebo(BaseObject_30) then
              BaseObject_30.CharPushed(m_btDirection, 1);
          end;
        end;
        BaseObject_34 := PoseCreate;
        if PoseCreate.CharPushed(m_btDirection, 1) <> 1 then Break;
        GetFrontPosition(nX, nY);
        if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
          m_nCurrX := nX;
          m_nCurrY := nY;
          SendRefMsg(RM_RUSH, nDir, m_nCurrX, m_nCurrY, 0, '');
          bo35 := False;
          Result := True;
        end;
        Dec(n24);
      end; //if PoseCreate <> nil  then begin
    end; //for i:=0 to _MAX(2,nMagicLevel + 1) do begin
  end else begin //if PoseCreate <> nil  then begin
    bo35 := False;
    for I := 0 to _MAX(2, nMagicLevel + 1) do begin
      GetFrontPosition(nX, nY); //sub_004B2790
      if m_PEnvir.MoveToMovingObject(m_nCurrX, m_nCurrY, Self, nX, nY, False) > 0 then begin
        m_nCurrX := nX;
        m_nCurrY := nY;
        SendRefMsg(RM_RUSH, nDir, m_nCurrX, m_nCurrY, 0, '');
        Dec(n28);
      end else begin
        if m_PEnvir.CanWalk(nX, nY, True) then n28 := 0
        else begin
          bo35 := True;
          Break;
        end;
      end;
    end;
  end;
  if (BaseObject_34 <> nil) then begin
    if n24 < 0 then n24 := 0;
    //n20 := Random((n24 + 1) * 10) + ((n24 + 1) * 10);
    if n24 > 3 then n24 := 3; //20090302 �����㷨
    n20 := Random((n24 + 1) * 5) + ((n24 + 1) * 5);    
    n20 := BaseObject_34.GetHitStruckDamage(Self, n20);
    BaseObject_34.StruckDamage(n20);
    BaseObject_34.SendRefMsg(RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
    if BaseObject_34.m_btRaceServer <> RC_PLAYOBJECT then begin
      BaseObject_34.SendMsg(BaseObject_34, RM_STRUCK, n20, BaseObject_34.m_WAbil.HP, BaseObject_34.m_WAbil.MaxHP, Integer(Self), '');
    end;
  end;
  if bo35 then begin
    GetFrontPosition(nX, nY);
    SendRefMsg(RM_RUSHKUNG, m_btDirection, nX, nY, 0, '');
    //SysMsg('(Ӣ��) '+sMateDoTooweak {��ײ������������}, BB_Fuchsia, t_Hint);  //20080312
  end;
  if n28 > 0 then begin
    if n24 < 0 then n24 := 0;
    n20 := Random(n24 * 10) + ((n24 + 1) * 3);
    n20 := GetHitStruckDamage(Self, n20);
    StruckDamage(n20);
    SendRefMsg(RM_STRUCK, n20, m_WAbil.HP, m_WAbil.MaxHP, 0, '');
  end;
end;

function THeroObject.ClientSpellXY(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  nSpellPoint: Integer;
  n14: Integer;
  BaseObject: TBaseObject;
  dwCheckTime,dwDelayTime: LongWord;
  boIsWarrSkill: Boolean;
resourcestring
  sDisableMagicCross = '��ǰ��ͼ������ʹ�ã�%s';
begin
  Result := False;
  if not m_boCanSpell then Exit;

  if m_boDeath or (m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0) or (m_wStatusArrValue[23] <> 0) then Exit;//����
  if UserMagic.wMagIdx <> SKILL_102 then
     if (m_wStatusTimeArr[POISON_STONE] <> 0) and not g_ClientConf.boParalyCanSpell then Exit;//����
  if m_PEnvir <> nil then begin
    if m_PEnvir.m_boNOSKILL then Exit;//��ֹʹ�����м���
    if not m_PEnvir.AllowMagics(UserMagic.MagicInfo.sMagicName) then begin
      SysMsg(Format(sDisableMagicCross, [UserMagic.MagicInfo.sMagicName]), BB_Fuchsia, t_Notice);
      Exit;
    end;
  end;
  boIsWarrSkill := MagicManager.IsWarrSkill(UserMagic.wMagIdx); //�Ƿ���սʿ����

  if not boIsWarrSkill then begin
    dwCheckTime := GetTickCount - m_dwMagicAttackTick;
    if dwCheckTime < m_dwMagicAttackInterval then begin
      Inc(m_dwMagicAttackCount);
      dwDelayTime := m_dwMagicAttackInterval - dwCheckTime;
      if dwDelayTime > g_Config.dwHeroMagicHitIntervalTime div 3 then begin
        if m_dwMagicAttackCount >= 2 then begin
          m_dwMagicAttackTick := GetTickCount();
          m_dwMagicAttackCount := 0;
        end else m_dwMagicAttackCount := 0;
        Exit;
      end else Exit;
    end;
  end;
  {$IF M2Version <> 2}
  m_dwIncNHTick := GetTickCount();
  {$IFEND}
  Dec(m_nSpellTick, 450);
  m_nSpellTick := _MAX(0, m_nSpellTick);

  if boIsWarrSkill then begin
    //m_dwMagicAttackInterval:=0;
    m_dwMagicAttackInterval:= UserMagic.MagicInfo.dwDelayTime {+ g_Config.dwHeroMagicHitIntervalTime}; //20080524 ħ�����
  end else begin
    m_dwMagicAttackInterval := UserMagic.MagicInfo.dwDelayTime + g_Config.dwHeroMagicHitIntervalTime ;//20080524
  end;
  if GetTickCount - m_dwMagicAttackTick > m_dwMagicAttackInterval then begin//20080222 Ӣ��ħ�����
  m_dwMagicAttackTick := GetTickCount();
  case UserMagic.wMagIdx of //
   SKILL_YEDO{7}:begin //��ɱ����  20071213����
        if m_MagicPowerHitSkill <> nil then begin
          if m_boPowerHit then begin
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;
          end;
        end;
        Result := True;
      end;      
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
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;
          end;
          Result := True;
        end;
      end;
    SKILL_74 :begin////���ս��� 20080511
        if m_Magic74Skill <> nil then begin
          if AllowDailySkill then begin
            nSpellPoint := GetSpellPoint(m_Magic74Skill);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
              end;
            end;
          end;
          Result := True;
        end;
      end;
    {$IF M2Version <> 2}
    SKILL_96: begin//Ѫ��һ��(ս)
        if m_Magic96Skill <> nil then begin
          if AllowBloodSoulSkill then begin
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_Skill69NH < nSpellPoint then begin//������ֵ��û����ֵ��HP
              if g_Config.dwNotGNDecHPRate > 0 then begin
                DamageHealth(Abs(Round(m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
                HealthSpellChanged();
              end;
            end else begin
              m_Skill69NH := _MAX(0, m_Skill69NH - nSpellPoint);
              SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
            end;
          end;
          Result := True;
        end;
      end;
    SKILL_69: begin//����ٵ�
        if (GetTickCount -  m_dwLatest69Tick) > g_Config.nKill69UseTime * 1000 then begin
          m_dwLatest69Tick := GetTickCount();
          nSpellPoint := GetSpellPoint(UserMagic);
          if m_Skill69NH >= nSpellPoint then begin
            if nSpellPoint > 0 then begin
              m_Skill69NH := _MAX(0, m_Skill69NH - nSpellPoint);
              SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
            end;
            m_btDirection := GetNextDirection(m_nCurrX, m_nCurrY, nTargetX, nTargetY);
            MagicManager.Attack_69(Self, UserMagic, nTargetX, nTargetY);
          end else begin
            SysMsg('��������', c_Green, t_Hint);
            SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
          end;
        end else SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
        Result := True;
      end;
    SKILL_101: begin//��������
        nSpellPoint := GetSpellPoint(UserMagic);
        if m_Skill69NH >= nSpellPoint then begin
          if nSpellPoint > 0 then begin
            m_Skill69NH := _MAX(0, m_Skill69NH - nSpellPoint);
            SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
          end;
          m_boCanUerSkill101:= True;
          m_dwUseSkillTime:= GetTickCount();
          if sSkill101On <> '' then SysMsg('(Ӣ��) '+sSkill101On, BB_Fuchsia, t_Hint);
          SendRefMsg(RM_10205, 22, 0{X}, 0{Y}, 0, '');
        end else begin
          SysMsg('��������', c_Green, t_Hint);
          SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
        end;
        Result := True;
      end;
    SKILL_102: begin//Ψ�Ҷ���
        nSpellPoint := GetSpellPoint(UserMagic);
        if m_Skill69NH >= nSpellPoint then begin
          if nSpellPoint > 0 then begin
            m_Skill69NH := _MAX(0, m_Skill69NH - nSpellPoint);
            SendRefMsg(RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
          end;
          SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          if m_wStatusTimeArr[POISON_STONE] > 0 then m_wStatusTimeArr[POISON_STONE] := 1;//�����״̬��ֱ�ӽ��
          m_boCanUerSkill102:= True;
          case UserMagic.btLevel of
            1: begin
              m_dwUseSkill102Time:= GetTickCount() + 3000;//1������Ч��3��
              if sSkill102On <>'' then SysMsg(Format_ToStr('(Ӣ��) ' + sSkill102On, [(m_dwUseSkill102Time - GetTickCount()) div 1000]), BB_Fuchsia, t_Hint);//��ʾ�û�
            end;
            2: begin
              m_dwUseSkill102Time:= GetTickCount() + 6000;//2������Ч��6��
              if sSkill102On <>'' then SysMsg(Format_ToStr('(Ӣ��) ' + sSkill102On, [(m_dwUseSkill102Time - GetTickCount()) div 1000]), BB_Fuchsia, t_Hint);//��ʾ�û�
            end;
            3: begin//3������Ч��10��,ͬʱ����Χ3����Ŀ��ķ�����ħ������0������Ч������10��
              m_dwUseSkill102Time:= GetTickCount() + 10000;
              if sSkill102On <>'' then SysMsg(Format_ToStr('(Ӣ��) ' + sSkill102On, [(m_dwUseSkill102Time - GetTickCount()) div 1000]), BB_Fuchsia, t_Hint);//��ʾ�û�
              Skill102MagicAttack(m_nCurrX, m_nCurrY, 3);
            end;
          end;
          SendRefMsg(RM_MAGICFIRE, 0,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                            MakeLong(m_nCurrX, m_nCurrY),Integer(Self),'');
        end else begin
          SysMsg('��������', c_Green, t_Hint);
          SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');
        end;
        Result := True;
      end;  
    {$IFEND}
    SKILL_MOOTEBO {27}: begin //Ұ����ײ
        Result := True;
        if (GetTickCount - m_dwDoMotaeboTick) > {3 * 1000}3000 then begin
          m_dwDoMotaeboTick := GetTickCount();
          // m_btDirection := TargeTBaseObject.m_btDirection{nTargetX};//20080409 �޸�Ұ����ײ�ķ���
          if GetAttackDir(TargeTBaseObject,m_btDirection) then begin//20080409 �޸�Ұ����ײ�ķ���
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
              if DoMotaebo(m_btDirection, UserMagic.btLevel) then begin
                if UserMagic.btLevel < 3 then begin
                  if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] < m_Abil.Level then begin
                    TrainSkill(UserMagic, Random(3) + 1);
                    if not CheckMagicLevelup(UserMagic) then begin
                      SendDelayMsg(Self,RM_HEROMAGIC_LVEXP,UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel,UserMagic.nTranPoint,'', 1000);
                    end;
                  end;
                end;
              end;
            end;
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
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;
          end;
        end;
        Result := True;
      end;
    SKILL_43: begin //��Ӱ����
        if m_Magic43Skill <> nil then begin
          if Skill43OnOff then begin//20080619
            nSpellPoint := GetSpellPoint(UserMagic);
            if m_WAbil.MP >= nSpellPoint then begin
              if nSpellPoint > 0 then begin
                DamageSpell(nSpellPoint);
                HealthSpellChanged();
              end;
            end;
          end;
        end;
        Result := True;
     end;
  else begin
      n14 := GetNextDirection(m_nCurrX, m_nCurrY, nTargetX, nTargetY);
      m_btDirection := n14;
      BaseObject := nil;

      //���Ŀ���ɫ����Ŀ��������Χ���������Χ��������Ŀ������
      case UserMagic.wMagIdx of//20080814 �޸�
        60..65: begin
            if (((m_wStatusTimeArr[POISON_STONE] = 0) and (m_Master.m_wStatusTimeArr[POISON_STONE] = 0))
              or g_ClientConf.boParalyCanSpell) and (m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0)
              and (m_Master.m_wStatusTimeArr[POISON_LOCKSPELL{7}] = 0) and (m_Master.m_wStatusArrValue[23] = 0)
              and (m_wStatusArrValue[23] = 0) then begin//20080913 ��Բ��ܺϻ�
              if CretInNearXY(TargeTBaseObject, nTargetX, nTargetY, 12) then begin//20080406
                BaseObject := TargeTBaseObject;
                nTargetX := BaseObject.m_nCurrX;
                nTargetY := BaseObject.m_nCurrY;
                if m_Master <> nil then TPlayObject(m_Master).DoSpell(UserMagic, nTargetX, nTargetY, BaseObject);//�ϻ����˹��� 20080522
              end;
            end else Exit;
          end;
        else begin
           if CretInNearXY(TargeTBaseObject, nTargetX, nTargetY) then begin//20080419 ע��
              BaseObject := TargeTBaseObject;
              nTargetX := BaseObject.m_nCurrX;
              nTargetY := BaseObject.m_nCurrY;
            end;
        end;
      end;//case

      if not DoSpell(UserMagic, nTargetX, nTargetY, BaseObject) then begin
        SendRefMsg(RM_MAGICFIREFAIL, 0, 0, 0, 0, '');//20080216 �������Ӣ�ۻ���ʧ 20080407
      end;
      Result := True;
    end;
  end;
  end;//20080222  Ӣ��ħ�����
end;

function THeroObject.DoSpell(UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; BaseObject: TBaseObject): Boolean;
var
  boTrain: Boolean;
  nSpellPoint: Integer;
  boSpellFail: Boolean;
  boSpellFire: Boolean;
  nPower: Integer;
  nAmuletIdx: Integer;
  nPowerRate: Integer;
  nDelayTime: Integer;
  nDelayTimeRate: Integer;
  dwDelayTime: LongWord;//20080718
  nCode: Byte;//20090105
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then //20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
  function GetPower13(nInt: Integer): Integer;
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)))
    else Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + UserMagic.MagicInfo.btDefPower);
  end;
  procedure sub_4934B4(PlayObject: TBaseObject);
  begin
    if PlayObject.m_UseItems[U_ARMRINGL].Dura < 100 then begin
      PlayObject.m_UseItems[U_ARMRINGL].Dura := 0;
      if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
        THeroObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
      end;
      PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
    end;
  end;
begin
  nCode:= 0;
  Result := False;
  boSpellFail := False;
  boSpellFire := True;
  nSpellPoint := GetSpellPoint(UserMagic); //��Ҫ��ħ��ֵ
  if (nSpellPoint > 0) then begin
    case UserMagic.wMagIdx of
      SKILL_68,SKILL_97,SKILL_98,SKILL_60,SKILL_61,SKILL_62,SKILL_63,SKILL_64,SKILL_65:;
      else begin
        if m_WAbil.MP < nSpellPoint then Exit;//���ħ��ֵ С�� ��Ҫ��ħ��ֵ ��ô�˳�
        DamageSpell(nSpellPoint);//��Ӣ�� ���� nSpellPoint mp
        HealthSpellChanged();
      end;
    end;
  end;
  {$IF M2Version <> 2}
  if m_boTrainingNG and (UserMagic.wMagIdx <> SKILL_HEALLING) and //20110701 ��������������ֵ
    (UserMagic.wMagIdx <> SKILL_BIGHEALLING) then begin//20081003 ѧ���ڹ��ķ�,ÿ����һ�μ�
    m_Skill69NH := _MAX(0, m_Skill69NH - g_Config.nHitStruckDecNH);
    SendREFMsg( RM_MAGIC69SKILLNH, 0, m_Skill69NH, m_Skill69MaxNH, 0, '');
  end;
  {$IFEND}
  nCode:= 1;
  try
    if BaseObject <> nil then  //20080215 �޸�,
      if (BaseObject.m_boGhost) or (BaseObject.m_boDeath) or (BaseObject.m_WAbil.HP <=0) then Exit;//20080428 �޸�
    if MagicManager.IsWarrSkill(UserMagic.wMagIdx) then Exit;
    if (abs(m_nCurrX - nTargetX) > {g_Config.nMagicAttackRage}7) or (abs(m_nCurrY - nTargetY) > {g_Config.nMagicAttackRage}7) then begin//20110922 ������ƶ�����һ�£���ֹ������������
      Exit;
    end;
    nCode:= 24;
    if (not CheckActionStatus(UserMagic.MagicInfo.wMagicId, dwDelayTime)) {or (GetSpellMsgCount > 0 )} then Exit;//20080720
    nCode:= 25;
    if (m_btJob = 0) and (UserMagic.MagicInfo.wMagicId = 61) then begin //20080604 ����նսʿЧ��
      nCode:= 20;
      if BaseObject <> nil then //20090204
        m_btDirection:= GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);//20080611
      nCode:= 21;
      SendRefMsg(RM_MYSHOW, 5,0, 0, 0, ''); //����սʿ������ 20080611
      SendAttackMsg(RM_PIXINGHIT, m_btDirection, 0, m_nCurrX, m_nCurrY);//20080611
    end else
    if (m_btJob = 0) and (UserMagic.MagicInfo.wMagicId = 62) then begin //20080611 ����һ��սʿЧ��
       nCode:= 22;
       if BaseObject <> nil then //20090204
         m_btDirection:= GetNextDirection(m_nCurrX, m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);//20080611
       nCode:= 23;  
       SendAttackMsg(RM_LEITINGHIT, m_btDirection, 0, m_nCurrX, m_nCurrY);
    end else begin
      case UserMagic.MagicInfo.wMagicId of //4�����ܷ���ͬ����Ϣ
       13:begin
           if (UserMagic.btLevel = 4) and (m_nLoyal >=g_Config.nGotoLV4) then //4�����
              SendRefMsg(RM_SPELL, 100, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
           else
              SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
         end;
       26:;
       45:begin
          if (UserMagic.btLevel = 4) and (m_nLoyal >=g_Config.nGotoLV4)  then
            SendRefMsg(RM_SPELL, 101, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
          else SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
         end;
       SKILL_58: begin//���ǻ���
            SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_92: begin//�ļ����ǻ���
            //��˪ѩ��
            {if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil)
              and (TPlayObject(PlayObject).m_HeartArrValue > 0) and (TPlayObject(PlayObject).m_MagicSkill_108 <> nil) then begin
              PlayObject.SendRefMsg(RM_SPELL, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffect, nTargetX, nTargetY, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.wMagicId, '');
            end else }begin
              {if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                SendRefMsg(RM_SPELL, 127, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
              else}
              SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
            end;
          end;
       else//0..12,14..25,27..44,46..100: //20080324
       SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
      end;
    end;
    nCode:= 3;
    if (BaseObject <> nil) and (UserMagic.MagicInfo.wMagicId <> SKILL_57) and (UserMagic.MagicInfo.wMagicId <> SKILL_54) and (UserMagic.MagicInfo.wMagicId < 100) then begin
      if (BaseObject.m_boDeath) then BaseObject := nil;
    end;
    boTrain := False;
    boSpellFail := False;
    boSpellFire := True;
    nCode:= 4;
    case UserMagic.MagicInfo.wMagicId of //
      SKILL_FIREBALL {1},
        SKILL_FIREBALL2 {5}: begin //������ �����
          if MagicManager.MagMakeFireball(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_HEALLING {2}: begin //������
          if MagicManager.MagTreatment(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_AMYOUNSUL{6}, SKILL_93: begin //ʩ����, �ļ�ʩ����
          if MagicManager.MagLightening(self, UserMagic, nTargetX, nTargetY, BaseObject, boSpellFail) then boTrain := True;
          boSpellFire:= False;//20091218 ���ӹ����з���Ϣ
        end;
      SKILL_FIREWIND {8}: begin //���ܻ�
          if MagicManager.MagPushArround(self, UserMagic.btLevel, False, UserMagic) > 0 then boTrain := True;
        end;
      SKILL_FIRE {9}: begin //������
          if MagicManager.MagMakeHellFire(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_SHOOTLIGHTEN {10}: begin //�����Ӱ
          if MagicManager.MagMakeQuickLighting(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_LIGHTENING{11}, SKILL_91: begin //�׵���,�ļ��׵���
          if MagicManager.MagMakeLighting(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_FIRECHARM {13},
      SKILL_HANGMAJINBUB {14},
      SKILL_DEJIWONHO {15},
      SKILL_HOLYSHIELD {16},
      SKILL_SKELLETON {17},
      SKILL_CLOAK {18},
      SKILL_BIGCLOAK {19},
      SKILL_52{52}, 
      SKILL_57,
      SKILL_59,
      SKILL_94: begin
          boSpellFail := True;
          if CheckAmulet(self, 1, 1, nAmuletIdx) then begin
            UseAmulet(self, 1, 1, nAmuletIdx);
            case UserMagic.MagicInfo.wMagicId of //
              SKILL_FIRECHARM {13}: begin //�����
                  if MagicManager.MagMakeFireCharm(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
                end;
              SKILL_HANGMAJINBUB {14}: begin //�����
                  nPower := GetAttackPower(GetPower13(80) + {LoWord}HiWord(m_WAbil.SC) * 10, SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1);
                  if MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 1) > 0 then boTrain := True;
                end;
              SKILL_DEJIWONHO {15}: begin //��ʥս����
                  nPower := GetAttackPower(GetPower13(80) + {LoWord}HiWord(m_WAbil.SC) * 10, SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1);
                  if MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 0) > 0 then boTrain := True;
                end;
              SKILL_HOLYSHIELD {16}: begin //��ħ��
                  if MagicManager.MagMakeHolyCurtain(self, GetPower13(40) + GetRPow(m_WAbil.SC) * 3, nTargetX, nTargetY) > 0 then boTrain := True;
                end;
              SKILL_SKELLETON {17}: begin //�ٻ�����
                  if MagicManager.MagMakeSlave(self, UserMagic) then  boTrain := True;
                end;
              SKILL_CLOAK {18}: begin //������
                  if MagicManager.MagMakePrivateTransparent(self, GetPower13(30) + GetRPow(m_WAbil.SC) * 3) then
                    boTrain := True;
                end;
              SKILL_BIGCLOAK {19}: begin //����������
                  if MagicManager.MagMakeGroupTransparent(self, nTargetX, nTargetY, GetPower13(30) + GetRPow(m_WAbil.SC) * 3) then
                    boTrain := True;
                end;
              SKILL_52: begin //������
                  nPower := GetAttackPower(GetPower13(20) + LoWord(m_WAbil.SC) * 2, SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1);
                  if MagMakeAbilityArea(nTargetX, nTargetY, 3, nPower) > 0 then boTrain := True;
                end;
              SKILL_57: begin //������
                  if MagicManager.MagMakeLivePlayObject(self, UserMagic, BaseObject) then boTrain := True;
                end;
              SKILL_59, SKILL_94: begin//��Ѫ��,�ļ���Ѫ��
                  if MagicManager.MagFireCharmTreatment(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
                end;
            end;
            boSpellFail := False;
            sub_4934B4(self);
          end;
        end;
      SKILL_TAMMING {20}: begin //�ջ�֮��
          if IsProperTarget(BaseObject) then begin
            if MagicManager.MagTamming(self, BaseObject, nTargetX, nTargetY, UserMagic.btLevel) then boTrain := True;
          end;
        end;
      SKILL_SPACEMOVE {21}: begin //˲Ϣ�ƶ�
          SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(BaseObject), '');
          boSpellFire := False;
          if MagicManager.MagSaceMove(self, UserMagic.btLevel) then boTrain := True;
        end;
      SKILL_EARTHFIRE {22}: begin //��ǽ
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
          nDelayTime := GetPower(10) + (Word(GetRPow(m_WAbil.MC)) shr 1);
          nPowerRate := Round(nPower * (g_Config.nFirePowerRate / 100));//��ǽ��������
          nDelayTimeRate := Round(nDelayTime * (g_Config.nFireDelayTimeRate / 100));//��ǽʱ��
          if MagicManager.MagMakeFireCross(self, nPowerRate, nDelayTimeRate, nTargetX, nTargetY, UserMagic.btLevelEx) > 0 then boTrain := True;
        end;
      SKILL_FIREBOOM {23}: begin //���ѻ���
          if MagicManager.MagBigExplosion(self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX, nTargetY, g_Config.nFireBoomRage {1},SKILL_FIREBOOM) then boTrain := True;
        end;
      SKILL_LIGHTFLOWER {24}: begin //�����׹�
          if MagicManager.MagElecBlizzard(self, GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1)) then boTrain := True;
        end;
      SKILL_SHOWHP {28}: begin//������ʾ
          if (BaseObject <> nil) and not BaseObject.m_boShowHP then begin
            if Random(6) <= (UserMagic.btLevel + 3) then begin
              BaseObject.m_dwShowHPTick := GetTickCount();
              BaseObject.m_dwShowHPInterval := GetPower13(GetRPow(m_WAbil.SC) * 2 + 30) * 1000;
              BaseObject.SendDelayMsg(BaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
              boTrain := True;
            end;
          end;
        end;
      SKILL_BIGHEALLING {29}: begin //Ⱥ��������
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.SC) * 2,
            SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) * 2 + 1);
          if MagicManager.MagBigHealing(self, nPower + m_WAbil.Level, nTargetX, nTargetY, UserMagic) then boTrain := True;
        end;
      SKILL_SINSU {30}: begin  //�ٻ�����
          boSpellFail := True;
          if CheckAmulet(self, 5, 1, nAmuletIdx) then begin
            UseAmulet(self, 5, 1, nAmuletIdx);
            if MagicManager.MagMakeSinSuSlave(self, UserMagic) then boTrain := True;
            boSpellFail := False;
          end;
        end;
      SKILL_SHIELD {31},SKILL_66{66}: begin //ħ����,4��ħ���� 20080624
          if MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(m_WAbil.MC) + 15)) then boTrain := True;
        end;
      SKILL_73 {73}: begin //������  20080301
          if MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(m_WAbil.SC) + 15)) then boTrain := True;
        end;
      SKILL_KILLUNDEAD {32}: begin //ʥ����
          if IsProperTarget(BaseObject) then begin
            if MagicManager.MagTurnUndead(self, BaseObject, nTargetX, nTargetY, UserMagic.btLevel) then boTrain := True;
          end;
        end;
      SKILL_SNOWWIND {33}: begin //������
          if MagicManager.MagBigExplosion(self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX, nTargetY, g_Config.nSnowWindRange {1},SKILL_SNOWWIND) then boTrain := True;
        end;
      SKILL_UNAMYOUNSUL {34}: begin //�ⶾ��
          if MagicManager.MagMakeUnTreatment(self,UserMagic,nTargetX,nTargetY,BaseObject) then boTrain := True;
        end;
      SKILL_WINDTEBO {35}: if MagicManager.MagWindTebo(self, UserMagic) then boTrain := True;
      SKILL_MABE {36}: begin //�����
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
          if MagicManager.MabMabe(self, BaseObject, nPower, UserMagic.btLevel, nTargetX, nTargetY) then boTrain := True;
        end;
      SKILL_GROUPLIGHTENING {37}: begin//Ⱥ���׵���
          if MagicManager.MagGroupLightening(self, UserMagic, nTargetX, nTargetY, BaseObject, boSpellFire) then boTrain := True;
        end;
      SKILL_GROUPAMYOUNSUL {38}: begin//Ⱥ��ʩ����
          if MagicManager.MagGroupAmyounsul(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_GROUPDEDING {39}: begin//�ض�
          if GetTickCount - m_dwDedingUseTick > g_Config.nDedingUseTime * 1000 then begin
            m_dwDedingUseTick := GetTickCount;
            if MagicManager.MagGroupDeDing(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
          end;
        end;
      SKILL_41: begin //ʨ�Ӻ�
          if MagicManager.MagGroupMb(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_42: begin //����ն
          if MagicManager.MagHbFireBall(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_43: begin //��Ӱ����
          if MagicManager.MagHbFireBall(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_44: begin //������
          if MagicManager.MagHbFireBall(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_45: begin //�����
          if MagicManager.MagMakeFireDay(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
         // boSpellFire:=False;//20080113
        end;
      SKILL_46: begin //������
          if MagicManager.MagMakeSelf(self, BaseObject, UserMagic) then  boTrain := True;
        end;
      SKILL_47: begin //��������
          if MagicManager.MagBigExplosion(self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX, nTargetY, g_Config.nFireBoomRage {1},SKILL_47) then boTrain := True;
        end;
      SKILL_58, SKILL_92: begin //���ǻ���,�ļ����ǻ���
          if MagicManager.MagBigExplosion1(self,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
            nTargetX, nTargetY, g_Config.nMeteorFireRainRage, BaseObject, False, UserMagic.MagicInfo.wMagicId) then boTrain := True;
        end;
      //��ʿ
      SKILL_48: begin //������
          if MagicManager.MagPushArround(self, UserMagic.btLevel, True, UserMagic) > 0 then boTrain := True;
        end;
      SKILL_49: begin //������
          boTrain := True;
        end;
      SKILL_50: begin //�޼�����
          if AbilityUp(UserMagic) then boTrain := True;
        end;
      SKILL_51: begin //쫷���
          if MagicManager.MagGroupFengPo(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
        end;
      SKILL_53: begin //Ѫ��
          boTrain := True;
        end;
      SKILL_54: begin //������
          if IsProperTargetSKILL_54(BaseObject) then begin
            if MagicManager.MagTamming2(self, BaseObject, nTargetX, nTargetY, UserMagic.btLevel) then boTrain := True;
          end;
        end;
      SKILL_55: begin //������
          if MagicManager.MagMakeArrestObject(self, UserMagic, BaseObject) then boTrain := True;
        end;
      SKILL_56: begin //���л�λ
          if MagicManager.MagChangePosition(self, nTargetX, nTargetY) then boTrain := True;
        end;
      SKILL_68: begin//Ӣ�۾������� 20080925
          MagMakeHPUp(UserMagic);
          boTrain := False;
        end;
      SKILL_71: begin//�ٻ�ʥ��
          boSpellFail := True;
          if (GetTickCount - m_dwDoSuSlaveTick) > 30000 then begin//�ٻ�ʥ�޼��
            if CheckAmulet(self, 5, 1, nAmuletIdx) then begin
              m_dwDoSuSlaveTick:= GetTickCount();
              UseAmulet(self, 5, 1, nAmuletIdx);
              if MagicManager.MagMakeShengSuSlave(self, UserMagic) then boTrain := True;
              boSpellFail := False;
            end;
          end;
        end;
      SKILL_72: begin //�ٻ�����
          if CheckAmulet(self, 5, 1, nAmuletIdx) then begin
            UseAmulet(self, 5, 1, nAmuletIdx);
            if MagicManager.MagMakeFairy(self, UserMagic) then boTrain := True;
          end;
        end;
      SKILL_104: begin //�ٻ�����
          if CheckAmulet(self, 5, 1, nAmuletIdx) then begin
            UseAmulet(self, 5, 1, nAmuletIdx);
            if MagicManager.MagMakeFireFairy(self, UserMagic) then boTrain := True;
          end;
        end;
{$IF M2Version <> 2}
      SKILL_97: begin//Ѫ��һ��(��)
          boSpellFail := True;
          if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ�����
            boSpellFail := False;
            if MagicManager.MagBigExplosion_97(self,
                            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1),
                            nTargetX, nTargetY, g_Config.nExplosion_97Range , UserMagic, BaseObject) then boTrain := True;
          end;
        end;
      SKILL_98: begin//Ѫ��һ��(��)
          boSpellFail := True;
          if (GetTickCount - m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ�����
            boSpellFail := False;
            if MagicManager.MagMakeFireCharm_98(self, UserMagic, nTargetX, nTargetY, g_Config.nExplosion_98Range, BaseObject) then boTrain := True;
          end;
        end;
{$IFEND}        
      {$IF HEROVERSION = 1}
      SKILL_60: begin  //�ƻ�ն  ս+ս
          nCode:= 5;
          if MagicManager.MagMakeSkillFire_60(self, UserMagic,
            GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)) + 1) * 3) then boTrain := True;
          nCode:= 6;
        end;
      SKILL_61: begin //����ն  ս+��
          nCode:= 7;
          if MagicManager.MagMakeSkillFire_61(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
          nCode:= 8;
        end;
      SKILL_62: begin//����һ��  ս+��
          nCode:= 9;
          if MagicManager.MagMakeSkillFire_62(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
          //if m_btJob = 1 then boSpellFire := False;//20080611
          nCode:= 10;
        end;
      SKILL_63: begin //�ɻ�����  ��+��
          nCode:= 11;
          if MagicManager.MagMakeSkillFire_63(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
          nCode:= 12;
        end;
      SKILL_64: begin //ĩ������  ��+��
          nCode:= 13;
          if MagicManager.MagMakeSkillFire_64(self, UserMagic, nTargetX, nTargetY, BaseObject) then boTrain := True;
          nCode:= 14;
        end;
      SKILL_65: begin //��������  ��+��
          nCode:= 15;
          if MagicManager.MagMakeSkillFire_65(self, UserMagic, GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1)) then
            boTrain := True;
          nCode:= 16;
        end;
      {$IFEND}  
    else begin
        if Assigned(zPlugOfEngine.SetHookDoSpell) then
          boTrain := zPlugOfEngine.SetHookDoSpell(MagicManager{Self}, TPlayObject(self), UserMagic, nTargetX, nTargetY, BaseObject, boSpellFail, boSpellFire);
      end;
    end;
    nCode:= 17;
    m_dwActionTick := GetTickCount();//20080713
    m_dwHitTick := GetTickCount();//20080713
    m_nSelectMagic := 0;
    m_boIsUseMagic := True;//�Ƿ��ܶ�� 20080714

    if boSpellFail then Exit;
    nCode:= 18;
    if boSpellFire then begin //20080111 ��4���ټ��ܲ�����Ϣ
      try
        case UserMagic.MagicInfo.wMagicId of //20080113 ��4���ټ��ܲ�����Ϣ      20080227 �޸�
          13:begin
             if (UserMagic.btLevel = 4) and (m_nLoyal >=g_Config.nGotoLV4) then //4����� 20080111
               SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType,100),MakeLong(nTargetX, nTargetY),Integer(BaseObject),'')
             else SendRefMsg(RM_MAGICFIRE, 0,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(BaseObject),'');
           end;
          26:;
          45:begin
              if (UserMagic.btLevel = 4) and (m_nLoyal >=g_Config.nGotoLV4) then // 20080227 �޸�
                SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType,101),MakeLong(nTargetX, nTargetY),Integer(BaseObject),'')
              else SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType,UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(BaseObject),'');
           end;
          else//0..12,14..25,27..44,46..100://20080324
            SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(BaseObject),'');
        end;//Case
      except
      end;
    end;
    nCode:= 19;
    if (UserMagic.btLevel < 3) and (boTrain) then begin//���ܼ���������
      if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= m_Abil.Level then begin
        TrainSkill(UserMagic, Random(3) + 1);
        if not CheckMagicLevelup(UserMagic) then begin
          SendDelayMsg(self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
        end;
      end;
    end;
    Result := True;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} THeroObject.DoSpell MagID:%d X:%d Y:%d Code:%d', [g_sExceptionVer, UserMagic.wMagIdx, nTargetX, nTargetY, nCode]));
    end;
  end;
end;

procedure THeroObject.MakeSaveRcd(var HumanRcd: THumDataInfo; var NewHeroDataInfo: TNewHeroDataInfo);
var
  I, J, K, H: Integer;
  HumData: pTHumData;
  HumItems, HumItems2: pTHumItems;
  HumAddItems, HumAddItems2: pTHumAddItems;
  BagItems, BagItems2: pTBagItems;
  HumMagics, HumMagics2: pTHumMagics;
  HumNGMagics, HumNGMagics2: pTHumNGMagics;//20081001
  UserMagic, UserMagic1: pTUserMagic;
  nCode: Byte;//20081018
  boMagic67, boMagic68{$IF M2Version <> 2}, boMagic99, boMagic102{$IFEND}{$IF M2Version = 1},boMagic95, boMagic76{$IFEND}: Boolean;
  nFindMagID: Word;
begin
  nCode:= 0;
  boMagic67:= False;
  boMagic68:= False;
  {$IF M2Version <> 2}
  boMagic99:= False;
  boMagic102:= False;
  {$IFEND}
  Try
    HumanRcd.Header.boIsHero := True;
    HumData := @HumanRcd.Data;
    HumData.sAccount := m_sUserID;
    HumData.sChrName := m_sCharName;
    HumData.sCurMap := m_sMapName;
    HumData.wCurX := m_nCurrX;
    HumData.wCurY := m_nCurrY;
    HumData.btDir := m_btDirection;
    HumData.btHair := m_btHair;
    HumData.btSex := m_btGender;
    HumData.nGold := m_nFirDragonPoint;//�����������������ŭ��ֵ 20080419
    nCode:= 1;
    HumData.Abil.Level := m_Abil.Level;
    {HumData.Abil.HP := m_Abil.HP;
    HumData.Abil.MP := m_Abil.MP;
    HumData.Abil.MaxHP := m_Abil.MaxHP;
    HumData.Abil.MaxMP := m_Abil.MaxMP;}
    HumData.Abil.HP := LoWord(m_WAbil.HP);//20091026 �޸�
    HumData.Abil.AC := HiWord(m_WAbil.HP);//20091026

    HumData.Abil.MP := LoWord(m_WAbil.MP);//20091026 �޸�
    HumData.Abil.MAC:= HiWord(m_WAbil.MP);//20091026

    HumData.Abil.MaxHP := LoWord(m_Abil.MaxHP);//20091026 �޸�
    HumData.Abil.DC:= HiWord(m_Abil.MaxHP);//20091026

    HumData.Abil.MaxMP := LoWord(m_Abil.MaxMP);//20091026 �޸�
    HumData.Abil.MC:= HiWord(m_Abil.MaxMP);//20091026

    HumData.Abil.nExp := m_Abil.nExp;
    HumData.Abil.nMaxExp := m_Abil.nMaxExp;
    HumData.Abil.Weight := m_Abil.Weight;
    HumData.Abil.MaxWeight := m_Abil.MaxWeight;
    HumData.Abil.WearWeight := m_Abil.WearWeight;
    HumData.Abil.MaxWearWeight := m_Abil.MaxWearWeight;
    HumData.Abil.HandWeight := m_Abil.HandWeight;
    HumData.Abil.MaxHandWeight := m_Abil.MaxHandWeight;
    nCode:= 2;
    HumData.Abil.NG := LoWord(m_Skill69NH);//�ڹ���ǰ����ֵ 20110226
    HumData.Abil.MaxNG := HiWord(m_Skill69NH);//����ֵ���� 20110226
    HumData.UnKnow[6] := Integer(m_boTrainingNG);//�Ƿ�ѧϰ���ڹ� 20081002
    if m_boTrainingNG then begin
      HumData.UnKnow[7] := LoByte(m_NGLevel);//�ڹ��ȼ� 20081204
      HumData.UnKnow[33] := HiByte(m_NGLevel);//�ڹ��ȼ�
    end else begin
      HumData.UnKnow[7] := 0;
      HumData.UnKnow[33] := 0;
    end;
    HumData.nExpSkill69 := m_ExpSkill69;//�ڹ���ǰ���� 20080930
    nCode:= 3;
    HumData.n_Reserved:= m_Abil.Alcohol;//���� 20080622
    HumData.n_Reserved1:= m_Abil.MaxAlcohol;//�������� 20080622
    HumData.n_Reserved2 := m_Abil.WineDrinkValue;//��ƶ� 2008623

    HumData.btUnKnow2[2] := n_DrinkWineQuality;//����ʱ�Ƶ�Ʒ��
    HumData.UnKnow[4] := n_DrinkWineAlcohol;//����ʱ�ƵĶ��� 20080624
    HumData.UnKnow[5] := m_btMagBubbleDefenceLevel;//ħ���ܵȼ� 20080811
    nCode:= 4;
    HumData.nReserved1:= m_Abil.MedicineValue;//��ǰҩ��ֵ 20080623
    HumData.nReserved2:= m_Abil.MaxMedicineValue;//ҩ��ֵ���� 20080623
    HumData.boReserved3:= n_DrinkWineDrunk;//���Ƿ�Ⱦ����� 20080627
    HumData.nReserved3:= dw_UseMedicineTime;//ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ�� 20080623
    HumData.n_Reserved3:= n_MedicineLevel;//ҩ��ֵ�ȼ� 20080623

    HumData.Abil.HP := m_WAbil.HP;
    HumData.Abil.MP := m_WAbil.MP;

    nCode:= 5;
    HumData.m_nReserved1:= m_nDecDamage;//�������� 20090618
    HumData.UnKnow[17]:= m_PulseAddAC;
    HumData.UnKnow[18]:= m_PulseAddAC1;
    HumData.UnKnow[19]:= m_PulseAddMAC;
    HumData.UnKnow[20]:= m_PulseAddMAC1;
    {$IF M2Version = 1}
    HumData.UnKnow[35]:= Integer(m_boOpenupSkill95);//��ͨ��ת99��
    if m_Magic95Skill <> nil then HumData.Reserved4:= m_WAbil.TransferValue;//��ǰ��תֵ

    HumData.wContribution:= dw_UseMedicineTime1;//������ʱ��
    HumData.nReserved:= m_ExpPuls;//Ӣ�۾��羭�� 20090911
  //��������
    HumData.UnKnow[9]:= m_wHumanPulseArr[0].nPulsePoint;
    HumData.UnKnow[10]:= m_wHumanPulseArr[0].nPulseLevel;

    HumData.UnKnow[11]:= m_wHumanPulseArr[1].nPulsePoint;
    HumData.UnKnow[12]:= m_wHumanPulseArr[1].nPulseLevel;

    HumData.UnKnow[13]:= m_wHumanPulseArr[2].nPulsePoint;
    HumData.UnKnow[14]:= m_wHumanPulseArr[2].nPulseLevel;

    HumData.UnKnow[15]:= m_wHumanPulseArr[3].nPulsePoint;
    HumData.UnKnow[16]:= m_wHumanPulseArr[3].nPulseLevel;

    HumData.UnKnow[32]:= m_wHumanPulseArr[4].nPulsePoint;//�澭

    HumData.UnKnow[29]:= Integer(m_boUser4BatterSkill);//ʹ�õ��ĸ����� 20100720
    HumData.UnKnow[21]:= Integer(m_boTrainBatterSkill);//�Ƿ�ѧϰ���������� 20090915
    HumData.UnKnow[22]:= m_SetBatterKey;//��һ���������ܸ�
    HumData.UnKnow[23]:= m_SetBatterKey1;//�ڶ����������ܸ�
    HumData.UnKnow[24]:= m_SetBatterKey2;//�������������ܸ�
    HumData.UnKnow[28]:= m_SetBatterKey3;//���ĸ��������ܸ� 20100719
    HumData.UnKnow[25]:= Integer(m_boOpenHumanPulseArr);//Ӣ���Ƿ�ͨ����
    {$IFEND}
    HumData.UnKnow[26]:= Integer(m_boProtectionDefence);//�Ƿ�ѧ��������� 20091126

    nCode:= 6;
    HumData.wStatusTimeArr := m_wStatusTimeArr;
    nCode:= 7;
    HumData.sHomeMap := m_sHomeMap;
    HumData.wHomeX := m_nHomeX;
    HumData.wHomeY := m_nHomeY;
    HumData.nPKPOINT := m_nPkPoint;
    nCode:= 8;
    HumData.BonusAbil := m_BonusAbil;//20081126 Ӣ����������
    HumData.nBonusPoint := m_nBonusPoint; // 08/09
    HumData.btCreditPoint := m_btCreditPoint;
    HumData.btReLevel := m_btReLevel;
    HumData.nLoyal:= m_nLoyal; //Ӣ�۵��ҳ϶�(20080110)
    HumData.n_WinExp:= m_nWinExp;//�������ۼƾ��� 20090106
    nCode:= 9;
    HumData.sMasterName:= m_sMasterName;//�������� 20090529
    nCode:= 10;
    HumData.btAttatckMode := m_btAttatckMode;
    HumData.btIncHealth := m_nIncHealth;
    HumData.btIncSpell := m_nIncSpell;
    HumData.btIncHealing := m_nIncHealing;
    HumData.btFightZoneDieCount := m_nFightZoneDieCount;
    nCode:= 11;
    HumData.btHeroType := n_HeroTpye;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-���� 3-����
    HumData.dBodyLuck := m_dBodyLuck;
    HumData.btLastOutStatus := m_btLastOutStatus; //2006-01-12���� �˳�״̬ 1Ϊ�����˳�
    HumData.QuestFlag := m_QuestFlag;
    HumData.boHasHero := False;
    HumData.boIsHero := True; //20080118
    HumData.btStatus := m_btStatus;//����Ӣ�۵�״̬ 20080717
    nCode:= 12;
    if m_boIsBakData then begin//����Ӣ�ۣ���ְҵ��һ��
      NewHeroDataInfo.Data.nHP := m_WAbil.HP;
      NewHeroDataInfo.Data.nMP := m_WAbil.MP;
      NewHeroDataInfo.Data.sHeroChrName:= m_sCharName;
      NewHeroDataInfo.Data.btJob:= m_btJob;
      HumData.btJob := m_btHeroTwoJob;
      HumItems2 := @NewHeroDataInfo.Data.HumItems;
      HumItems2[U_DRESS] := m_UseItems[U_DRESS];
      HumItems2[U_WEAPON] := m_UseItems[U_WEAPON];
      HumItems2[U_RIGHTHAND] := m_UseItems[U_RIGHTHAND];
      HumItems2[U_HELMET] := m_UseItems[U_NECKLACE];
      HumItems2[U_NECKLACE] := m_UseItems[U_HELMET];
      HumItems2[U_ARMRINGL] := m_UseItems[U_ARMRINGL];
      HumItems2[U_ARMRINGR] := m_UseItems[U_ARMRINGR];
      HumItems2[U_RINGL] := m_UseItems[U_RINGL];
      HumItems2[U_RINGR] := m_UseItems[U_RINGR];
      nCode:= 213;
      HumAddItems2 := @NewHeroDataInfo.Data.HumAddItems;
      HumAddItems2[U_BUJUK] := m_UseItems[U_BUJUK];
      HumAddItems2[U_BELT] := m_UseItems[U_BELT];
      HumAddItems2[U_BOOTS] := m_UseItems[U_BOOTS];
      HumAddItems2[U_CHARM] := m_UseItems[U_CHARM];
      HumAddItems2[U_ZHULI] := m_UseItems[U_ZHULI];//����
      HumAddItems2[U_DRUM] := m_UseItems[U_DRUM];//����

      nCode:= 214;
      BagItems2 := @NewHeroDataInfo.Data.BagItems;
      nCode:= 215;
      if m_ItemList <> nil then begin
        for I := 0 to m_ItemList.Count - 1 do begin
          if I >= MAXHEROBAGITEM then Break;
          nCode:= 216;
          if pTUserItem(m_ItemList.Items[I]) <> nil then begin
            nCode:= 217;
            if (pTUserItem(m_ItemList.Items[I]).wIndex = 0) or (pTUserItem(m_ItemList.Items[I]).MakeIndex <= 0) then Continue;//IDΪ0����Ʒ�򲻱���,����IDΪ0Ҳ������
            BagItems2[I] := pTUserItem(m_ItemList.Items[I])^;
          end;
        end;
      end;
      nCode:= 218;
      HumMagics2 := @NewHeroDataInfo.Data.HumMagics;
      nCode:= 219;
      HumNGMagics2:= @NewHeroDataInfo.Data.HumNGMagics;//�ڹ�����
      if m_MagicList.Count > 0 then begin
        J:= 0;
        K:= 0;
        for I := 0 to m_MagicList.Count - 1 do begin
          UserMagic := m_MagicList.Items[I];
          nCode:= 220;
          if UserMagic <> nil then begin
            nCode:= 221;
            if UserMagic.MagicInfo <> nil then begin//20100929 ����
              if (UserMagic.MagicInfo.wMagicId = SKILL_75) then Continue;//ԭ������ܼ��ܲ�����
              nFindMagID:= 0;
              case UserMagic.MagicInfo.wMagicId of
                SKILL_67: begin//����Ԫ������±��ݼ����б�
                  for H := m_MagicList_bak.Count - 1 downto 0 do begin
                    if m_MagicList_bak.Count <= 0 then Break;
                    UserMagic1 := m_MagicList_bak.Items[H];
                    if UserMagic1 <> nil then begin
                      if UserMagic1.MagicInfo.wMagicId = SKILL_67 then begin
                        UserMagic1.wMagIdx := UserMagic.wMagIdx;
                        UserMagic1.btLevel := UserMagic.btLevel;
                        UserMagic1.btKey := UserMagic.btKey;
                        UserMagic1.nTranPoint := UserMagic.nTranPoint;
                        boMagic67:= True;
                        Break;
                      end;
                    end;
                  end;
                  if not boMagic67 then m_MagicList_bak.Add(UserMagic);
                  Continue;
                end;
                SKILL_68: begin//������������±��ݼ����б�
                  for H := m_MagicList_bak.Count - 1 downto 0 do begin
                    if m_MagicList_bak.Count <= 0 then Break;
                    UserMagic1 := m_MagicList_bak.Items[H];
                    if UserMagic1 <> nil then begin
                      if UserMagic1.MagicInfo.wMagicId = SKILL_68 then begin
                        UserMagic1.wMagIdx := UserMagic.wMagIdx;
                        UserMagic1.btLevel := UserMagic.btLevel;
                        UserMagic1.btKey := UserMagic.btKey;
                        UserMagic1.nTranPoint := UserMagic.nTranPoint;
                        boMagic68:= True;
                        Break;
                      end;
                    end;
                  end;
                  if not boMagic68 then m_MagicList_bak.Add(UserMagic);
                  Continue;
                end;
                {$IF M2Version <> 2}
                SKILL_99: begin//ǿ��������±��ݼ����б�
                  for H := m_MagicList_bak.Count - 1 downto 0 do begin
                    if m_MagicList_bak.Count <= 0 then Break;
                    UserMagic1 := m_MagicList_bak.Items[H];
                    if UserMagic1 <> nil then begin
                      if UserMagic1.MagicInfo.wMagicId = SKILL_99 then begin
                        UserMagic1.wMagIdx := UserMagic.wMagIdx;
                        UserMagic1.btLevel := UserMagic.btLevel;
                        UserMagic1.btKey := UserMagic.btKey;
                        UserMagic1.nTranPoint := UserMagic.nTranPoint;
                        boMagic99:= True;
                        Break;
                      end;
                    end;
                  end;
                  if not boMagic99 then m_MagicList_bak.Add(UserMagic);
                  Continue;
                end;
                SKILL_102: begin//Ψ�Ҷ�������±��ݼ����б�
                  for H := m_MagicList_bak.Count - 1 downto 0 do begin
                    if m_MagicList_bak.Count <= 0 then Break;
                    UserMagic1 := m_MagicList_bak.Items[H];
                    if UserMagic1 <> nil then begin
                      if UserMagic1.MagicInfo.wMagicId = SKILL_102 then begin
                        UserMagic1.wMagIdx := UserMagic.wMagIdx;
                        UserMagic1.btLevel := UserMagic.btLevel;
                        UserMagic1.btKey := UserMagic.btKey;
                        UserMagic1.nTranPoint := UserMagic.nTranPoint;
                        boMagic102:= True;
                        Break;
                      end;
                    end;
                  end;
                  if not boMagic102 then m_MagicList_bak.Add(UserMagic);
                  Continue;
                end;
                {$IFEND}
                {$IF M2Version = 1}
                SKILL_95: begin//��ת��������±��ݼ����б�
                  boMagic95:= False;
                  for H := m_MagicList_bak.Count - 1 downto 0 do begin
                    if m_MagicList_bak.Count <= 0 then Break;
                    UserMagic1 := m_MagicList_bak.Items[H];
                    if UserMagic1 <> nil then begin
                      if UserMagic1.MagicInfo.wMagicId = SKILL_95 then begin
                        UserMagic1.wMagIdx := UserMagic.wMagIdx;
                        UserMagic1.btLevel := UserMagic.btLevel;
                        UserMagic1.btKey := UserMagic.btKey;
                        UserMagic1.nTranPoint := UserMagic.nTranPoint;
                        boMagic95:= True;
                        Break;
                      end;
                    end;
                  end;
                  if not boMagic95 then m_MagicList_bak.Add(UserMagic);
                  Continue;
                end;
                SKILL_76, SKILL_77, SKILL_78: begin//����ɱ,˫����,��Х���������ٻ�ְҵ���±��ݼ����б�
                  boMagic76:= False;
                  case m_btHeroTwoJob of
                    0: nFindMagID:= SKILL_76;
                    1: nFindMagID:= SKILL_77;
                    2: nFindMagID:= SKILL_78;
                  end;//case
                  if nFindMagID > 0 then begin
                    for H := m_MagicList_bak.Count - 1 downto 0 do begin
                      if m_MagicList_bak.Count <= 0 then Break;
                      UserMagic1 := m_MagicList_bak.Items[H];
                      if UserMagic1 <> nil then begin
                        if (UserMagic1.wMagIdx = SKILL_76) or (UserMagic1.wMagIdx = SKILL_77) or (UserMagic1.wMagIdx = SKILL_78) then begin
                          UserMagic1.wMagIdx := nFindMagID;
                          UserMagic1.btLevel := UserMagic.btLevel;
                          UserMagic1.btKey := UserMagic.btKey;
                          UserMagic1.nTranPoint := UserMagic.nTranPoint;
                          boMagic76:= True;
                          Break;
                        end;
                      end;
                    end;
                    if not boMagic76 then begin
                      UserMagic.MagicInfo := UserEngine.FindHeroMagic(nFindMagID);
                      UserMagic.wMagIdx := nFindMagID;
                      m_MagicList_bak.Add(UserMagic);
                    end;
                  end;
                  Continue;
                end;
                SKILL_79, SKILL_80, SKILL_81: begin//׷�Ĵ�,�����,������
                  boMagic76:= False;
                  case m_btHeroTwoJob of
                    0: nFindMagID:= SKILL_79;
                    1: nFindMagID:= SKILL_80;
                    2: nFindMagID:= SKILL_81;
                  end;//case
                  if nFindMagID > 0 then begin
                    for H := m_MagicList_bak.Count - 1 downto 0 do begin
                      if m_MagicList_bak.Count <= 0 then Break;
                      UserMagic1 := m_MagicList_bak.Items[H];
                      if UserMagic1 <> nil then begin
                        if (UserMagic1.MagicInfo.wMagicId = SKILL_79) or (UserMagic1.MagicInfo.wMagicId = SKILL_80) or (UserMagic1.MagicInfo.wMagicId = SKILL_81) then begin
                          UserMagic1.wMagIdx := nFindMagID;
                          UserMagic1.btLevel := UserMagic.btLevel;
                          UserMagic1.btKey := UserMagic.btKey;
                          UserMagic1.nTranPoint := UserMagic.nTranPoint;
                          boMagic76:= True;
                          Break;
                        end;
                      end;
                    end;
                    if not boMagic76 then begin
                      UserMagic.MagicInfo := UserEngine.FindHeroMagic(nFindMagID);
                      UserMagic.wMagIdx := nFindMagID;
                      m_MagicList_bak.Add(UserMagic);
                    end;
                  end;
                  Continue;
                end;
                SKILL_82,SKILL_83,SKILL_84: begin//����ն,���ױ�,������
                  boMagic76:= False;
                  case m_btHeroTwoJob of
                    0: nFindMagID:= SKILL_82;
                    1: nFindMagID:= SKILL_83;
                    2: nFindMagID:= SKILL_84;
                  end;//case
                  if nFindMagID > 0 then begin
                    for H := m_MagicList_bak.Count - 1 downto 0 do begin
                      if m_MagicList_bak.Count <= 0 then Break;
                      UserMagic1 := m_MagicList_bak.Items[H];
                      if UserMagic1 <> nil then begin
                        if (UserMagic1.MagicInfo.wMagicId = SKILL_82) or (UserMagic1.MagicInfo.wMagicId = SKILL_83) or (UserMagic1.MagicInfo.wMagicId = SKILL_84) then begin
                          UserMagic1.wMagIdx := nFindMagID;
                          UserMagic1.btLevel := UserMagic.btLevel;
                          UserMagic1.btKey := UserMagic.btKey;
                          UserMagic1.nTranPoint := UserMagic.nTranPoint;
                          boMagic76:= True;
                          Break;
                        end;
                      end;
                    end;
                    if not boMagic76 then begin
                      UserMagic.MagicInfo := UserEngine.FindHeroMagic(nFindMagID);
                      UserMagic.wMagIdx := nFindMagID;
                      m_MagicList_bak.Add(UserMagic);
                    end;
                  end;
                  Continue;
                end;
                SKILL_85,SKILL_86,SKILL_87: begin//��ɨǧ��,����ѩ��,�򽣹���
                  boMagic76:= False;
                  case m_btHeroTwoJob of
                    0: nFindMagID:= SKILL_85;
                    1: nFindMagID:= SKILL_86;
                    2: nFindMagID:= SKILL_87;
                  end;//case
                  if nFindMagID > 0 then begin
                    for H := m_MagicList_bak.Count - 1 downto 0 do begin
                      if m_MagicList_bak.Count <= 0 then Break;
                      UserMagic1 := m_MagicList_bak.Items[H];
                      if UserMagic1 <> nil then begin
                        if (UserMagic1.MagicInfo.wMagicId = SKILL_85) or (UserMagic1.MagicInfo.wMagicId = SKILL_86) or (UserMagic1.MagicInfo.wMagicId = SKILL_87) then begin
                          UserMagic1.wMagIdx := nFindMagID;
                          UserMagic1.btLevel := UserMagic.btLevel;
                          UserMagic1.btKey := UserMagic.btKey;
                          UserMagic1.nTranPoint := UserMagic.nTranPoint;
                          boMagic76:= True;
                          Break;
                        end;
                      end;
                    end;
                    if not boMagic76 then begin
                      UserMagic.MagicInfo := UserEngine.FindHeroMagic(nFindMagID);
                      UserMagic.wMagIdx := nFindMagID;
                      m_MagicList_bak.Add(UserMagic);
                    end;
                  end;
                  Continue;
                end;
                {$IFEND}
              end;//case

              if (UserMagic.MagicInfo.sDescr = '�ڹ�') and (UserMagic.MagicInfo.wMagicId <> SKILL_102) then begin
                nCode:= 227;
                if K >= MAXNGMAGIC then Continue;
                nCode:= 228;
                HumNGMagics2[K].wMagIdx := UserMagic.wMagIdx;
                nCode:= 229;
                HumNGMagics2[K].btLevel := UserMagic.btLevel;
                nCode:= 230;
                HumNGMagics2[K].btKey := UserMagic.btKey;
                nCode:= 231;
                HumNGMagics2[K].nTranPoint := UserMagic.nTranPoint;
                Inc(K);
              end else begin
                nCode:= 222;
                if J >= MAXMAGIC then Continue;
                nCode:= 223;
                HumMagics2[J].wMagIdx := UserMagic.wMagIdx;
                nCode:= 224;
                HumMagics2[J].btLevel := UserMagic.btLevel;
                nCode:= 225;
                HumMagics2[J].btKey := UserMagic.btKey;
                nCode:= 226;
                HumMagics2[J].nTranPoint := UserMagic.nTranPoint;
                HumMagics2[J].btLevelEx:= UserMagic.btLevelEx;
                Inc(J);
              end;
            end;
          end;
        end;
      end;
//------------------------------------------------------------------------------
      HumData.Abil.HP := LoWord(m_nHP_Bak);
      HumData.Abil.AC := HiWord(m_nHP_Bak);
      HumData.Abil.MP := LoWord(m_nMP_Bak);
      HumData.Abil.MAC:= HiWord(m_nMP_Bak);

      HumItems := @HumanRcd.Data.HumItems;
      HumItems[U_DRESS] := m_UseItems_bak[U_DRESS];
      HumItems[U_WEAPON] := m_UseItems_bak[U_WEAPON];
      HumItems[U_RIGHTHAND] := m_UseItems_bak[U_RIGHTHAND];
      HumItems[U_HELMET] := m_UseItems_bak[U_NECKLACE];
      HumItems[U_NECKLACE] := m_UseItems_bak[U_HELMET];
      HumItems[U_ARMRINGL] := m_UseItems_bak[U_ARMRINGL];
      HumItems[U_ARMRINGR] := m_UseItems_bak[U_ARMRINGR];
      HumItems[U_RINGL] := m_UseItems_bak[U_RINGL];
      HumItems[U_RINGR] := m_UseItems_bak[U_RINGR];
      nCode:= 113;
      HumAddItems := @HumanRcd.Data.HumAddItems;
      HumAddItems[U_BUJUK] := m_UseItems_bak[U_BUJUK];
      HumAddItems[U_BELT] := m_UseItems_bak[U_BELT];
      HumAddItems[U_BOOTS] := m_UseItems_bak[U_BOOTS];
      HumAddItems[U_CHARM] := m_UseItems_bak[U_CHARM];
      HumAddItems[U_ZHULI] := m_UseItems_bak[U_ZHULI];//����
      HumAddItems[U_DRUM] := m_UseItems_bak[U_DRUM];//����
      nCode:= 114;
      BagItems := @HumanRcd.Data.BagItems;
      nCode:= 115;
      if m_ItemList_bak <> nil then begin
        for I := 0 to m_ItemList_bak.Count - 1 do begin
          if I >= MAXHEROBAGITEM then Break;
          nCode:= 116;
          if pTUserItem(m_ItemList_bak.Items[I]) <> nil then begin
            nCode:= 117;
            if (pTUserItem(m_ItemList_bak.Items[I]).wIndex = 0) or (pTUserItem(m_ItemList_bak.Items[I]).MakeIndex <= 0) then Continue;//IDΪ0����Ʒ�򲻱���,����IDΪ0Ҳ������
            BagItems[I] := pTUserItem(m_ItemList_bak.Items[I])^;
          end;
        end;
      end;
      nCode:= 118;
      HumMagics := @HumanRcd.Data.HumMagics;
      nCode:= 119;
      HumNGMagics:= @HumanRcd.Data.HumNGMagics;//�ڹ�����
      nCode:= 134;
      if m_MagicList_bak.Count > 0 then begin
        J:= 0;
        K:= 0;
        for I := 0 to m_MagicList_bak.Count - 1 do begin
          nCode:= 132;
          UserMagic := m_MagicList_bak.Items[I];
          nCode:= 120;
          if UserMagic <> nil then begin
            nCode:= 121;
            if UserMagic.MagicInfo.wMagicId = SKILL_75 then Continue;//ԭ������ܼ��ܲ�����
            nCode:= 133;
            if (UserMagic.MagicInfo.sDescr = '�ڹ�') and (UserMagic.MagicInfo.wMagicId <> SKILL_102) then begin
              nCode:= 127;
              if K >= MAXNGMAGIC then Continue;
              nCode:= 128;
              HumNGMagics[K].wMagIdx := UserMagic.wMagIdx;
              nCode:= 129;
              HumNGMagics[K].btLevel := UserMagic.btLevel;
              nCode:= 130;
              HumNGMagics[K].btKey := UserMagic.btKey;
              nCode:= 131;
              HumNGMagics[K].nTranPoint := UserMagic.nTranPoint;
              Inc(K);
            end else begin
              nCode:= 122;
              if J >= MAXMAGIC then Continue;
              nCode:= 123;
              HumMagics[J].wMagIdx := UserMagic.wMagIdx;
              nCode:= 124;
              HumMagics[J].btLevel := UserMagic.btLevel;
              nCode:= 125;
              HumMagics[J].btKey := UserMagic.btKey;
              nCode:= 126;
              HumMagics[J].nTranPoint := UserMagic.nTranPoint;
              HumMagics2[J].btLevelEx:= UserMagic.btLevelEx;
              Inc(J);
            end;
          end;
        end;
      end;
    end else begin//�Ǹ���Ӣ��
      HumData.btJob := m_btJob;
      NewHeroDataInfo.Data.sHeroChrName:='';
      NewHeroDataInfo.Data.btJob:= 255;
      HumItems := @HumanRcd.Data.HumItems;
      HumItems[U_DRESS] := m_UseItems[U_DRESS];
      HumItems[U_WEAPON] := m_UseItems[U_WEAPON];
      HumItems[U_RIGHTHAND] := m_UseItems[U_RIGHTHAND];
      HumItems[U_HELMET] := m_UseItems[U_NECKLACE];
      HumItems[U_NECKLACE] := m_UseItems[U_HELMET];
      HumItems[U_ARMRINGL] := m_UseItems[U_ARMRINGL];
      HumItems[U_ARMRINGR] := m_UseItems[U_ARMRINGR];
      HumItems[U_RINGL] := m_UseItems[U_RINGL];
      HumItems[U_RINGR] := m_UseItems[U_RINGR];
      nCode:= 13;
      HumAddItems := @HumanRcd.Data.HumAddItems;
      HumAddItems[U_BUJUK] := m_UseItems[U_BUJUK];
      HumAddItems[U_BELT] := m_UseItems[U_BELT];
      HumAddItems[U_BOOTS] := m_UseItems[U_BOOTS];
      HumAddItems[U_CHARM] := m_UseItems[U_CHARM];
      HumAddItems[U_ZHULI] := m_UseItems[U_ZHULI];//����
      HumAddItems[U_DRUM] := m_UseItems[U_DRUM];//����
      
      nCode:= 14;
      BagItems := @HumanRcd.Data.BagItems;
      nCode:= 15;
      if m_ItemList <> nil then begin//20090512 ����
        nCode:= 151;
        for I := 0 to m_ItemList.Count - 1 do begin
          if I >= MAXHEROBAGITEM then Break;
          nCode:= 16;
          if pTUserItem(m_ItemList.Items[I]) <> nil then begin//20090212 ����
            nCode:= 17;
            if (pTUserItem(m_ItemList.Items[I]).wIndex = 0) or (pTUserItem(m_ItemList.Items[I]).MakeIndex <= 0) then Continue;//20080915 IDΪ0����Ʒ�򲻱��� 20090502����IDΪ0Ҳ������
            BagItems[I] := pTUserItem(m_ItemList.Items[I])^;
          end;
        end;
      end;
      nCode:= 18;
      HumMagics := @HumanRcd.Data.HumMagics;
      nCode:= 19;
      HumNGMagics:= @HumanRcd.Data.HumNGMagics;//�ڹ�����
      nCode:= 190;
      if m_MagicList.Count > 0 then begin
        J:= 0;
        K:= 0;
        for I := 0 to m_MagicList.Count - 1 do begin
          nCode:= 191;
          UserMagic := m_MagicList.Items[I];
          nCode:= 20;
          if UserMagic <> nil then begin//20090210 ����
            nCode:= 21;
            if UserMagic.MagicInfo.wMagicId = SKILL_75 then Continue;//ԭ������ܼ��ܲ����� 20091126
            if (UserMagic.MagicInfo.sDescr = '�ڹ�') and (UserMagic.MagicInfo.wMagicId <> SKILL_102) then begin
              nCode:= 27;
              if K >= MAXNGMAGIC then Continue;
              nCode:= 28;
              HumNGMagics[K].wMagIdx := UserMagic.wMagIdx;
              nCode:= 29;
              HumNGMagics[K].btLevel := UserMagic.btLevel;
              nCode:= 30;
              HumNGMagics[K].btKey := UserMagic.btKey;
              nCode:= 31;
              HumNGMagics[K].nTranPoint := UserMagic.nTranPoint;
              Inc(K);
            end else begin
              nCode:= 22;
              if J >= MAXMAGIC then Continue;
              nCode:= 23;
              HumMagics[J].wMagIdx := UserMagic.wMagIdx;
              nCode:= 24;
              HumMagics[J].btLevel := UserMagic.btLevel;
              nCode:= 25;
              HumMagics[J].btKey := UserMagic.btKey;
              nCode:= 26;
              HumMagics[J].nTranPoint := UserMagic.nTranPoint;
              HumMagics[J].btLevelEx:= UserMagic.btLevelEx;
              Inc(J);
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.MakeSaveRcd Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//Ӣ�۵�¼ 20080320
procedure THeroObject.Login();
var
  I, II: Integer;
  UserItem, UserItem1: pTUserItem;
  StdItem: pTStdItem;
  s14, sItem: string;
  TempList: TStringList;
resourcestring
  sExceptionMsg = '{%s} THeroObject::Login';
begin
  try
    //����������������Ʒ
    if m_boNewHuman then begin
      if g_Config.sHeroBasicDrug <>'' then begin
        TempList := TStringList.Create;
        try
          ExtractStrings(['|', '\', '/', ','], [], PChar(g_Config.sHeroBasicDrug), TempList);
          if TempList.Count > 0 then begin
            for I := 0 to TempList.Count - 1 do begin
              New(UserItem);
              if UserEngine.CopyToUserItemFromName(TempList.Strings[I], UserItem) then begin
                m_ItemList.Add(UserItem);
              end else Dispose(UserItem);
            end;
          end;
        finally
          TempList.Free;
        end;
      end;
      if g_Config.sHeroWoodenSword <> '' then begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(g_Config.sHeroWoodenSword, UserItem) then begin
          m_ItemList.Add(UserItem);
        end else Dispose(UserItem);
      end;
      New(UserItem);
      if m_btGender = 0 then
        sItem := g_Config.sHeroClothsMan
      else
        sItem := g_Config.sHeroClothsWoman;
      if UserEngine.CopyToUserItemFromName(sItem, UserItem) then begin
        m_ItemList.Add(UserItem);
      end else Dispose(UserItem);
    end;
    if not m_boAI then begin
      //��鱳���е���Ʒ�Ƿ�Ϸ�
      for I := m_ItemList.Count - 1 downto 0 do begin
        if m_ItemList.Count <= 0 then Break;
        UserItem := m_ItemList.Items[I];
        if UserItem <> nil then begin
          if (UserItem.AddValue[0] = 1) and (GetHoursCount(UserItem.MaxDate, Now) <= 0) then begin //ɾ������װ��
            m_ItemList.Delete(I);
            Dispose(UserItem);
            Continue;
          end;
          if (UserItem.AddValue[0] = 2) and (GetHoursCount(UserItem.MaxDate, Now) <= 0) then UserItem.AddValue[0]:= 0;//���ڵ����ָ�����
          if CheckIsOKItem(UserItem) then begin//����̬��Ʒ 20081006
            Dispose(pTUserItem(m_ItemList.Items[I]));
            m_ItemList.Delete(I);
            Continue;
          end;
          //��鱳�����Ƿ��и���Ʒ
          s14 := UserEngine.GetStdItemName(UserItem.wIndex);
          for II := I - 1 downto 0 do begin
            UserItem1 := m_ItemList.Items[II];
            if (UserEngine.GetStdItemName(UserItem1.wIndex) = s14) and
              (UserItem.MakeIndex = UserItem1.MakeIndex) then begin
              m_ItemList.Delete(II);
              Break;
            end;
          end;
        end;
      end;
    end;

    //����������ϵ���Ʒ�Ƿ����ʹ�ù���
    if g_Config.boCheckUserItemPlace then begin
      for I := Low(THumanUseItems) to High(THumanUseItems) do begin
        if m_UseItems[I].wIndex > 0 then begin
          if (m_UseItems[I].AddValue[0] = 1) and (GetHoursCount(m_UseItems[I].MaxDate, Now) <= 0) then begin //ɾ������װ��
            m_UseItems[I].wIndex := 0;
            Continue;
          end;
          StdItem := UserEngine.GetStdItem(m_UseItems[I].wIndex);
          if StdItem <> nil then begin
            if CheckIsOKItem(@m_UseItems[I]) then begin//����̬��Ʒ 20081006
              m_UseItems[I].wIndex := 0;
              Continue;
            end;
            {$IF M2Version <> 2} //��ʱ�����������ȥ�� 20100901
            if (m_UseItems[I].btAppraisalLevel = 0) and (g_Config.boUseCanKamPo) then begin
              if StdItem.StdMode in [5,6,10,11,52,54,55,62,64,27,28,29,30,15,16, 19..24, 26] then m_UseItems[I].btAppraisalLevel:= 1;
            end;
            {$IFEND}
            {$IF M2var = 1}
            if m_UseItems[I].AddValue[2] <> 255 then begin//��ʱ����14-19����ֵ����N���ȥ�� 20110528
              m_UseItems[I].AddValue[2]:= m_UseItems[I].btValue[14];
              m_UseItems[I].btValue[14]:= 0;
              SetItemState(@m_UseItems[I], 0, m_UseItems[I].AddValue[2]);
              SetItemState(@m_UseItems[I], 1, m_UseItems[I].btValue[15]);
              SetItemState(@m_UseItems[I], 2, m_UseItems[I].btValue[16]);
              SetItemState(@m_UseItems[I], 3, m_UseItems[I].btValue[17]);
              SetItemState(@m_UseItems[I], 4, m_UseItems[I].btValue[18]);
              SetItemState(@m_UseItems[I], 5, m_UseItems[I].btValue[19]);
              m_UseItems[I].btValue[15]:= 0;
              m_UseItems[I].btValue[16]:= 0;
              m_UseItems[I].btValue[17]:= 0;
              m_UseItems[I].btValue[18]:= 0;
              m_UseItems[I].btValue[19]:= 0;
              m_UseItems[I].AddValue[2]:= 255;
            end;
            {$IFEND}            
            if not CheckUserItems(I, StdItem) then begin
              New(UserItem);
              FillChar(UserItem^, SizeOf(TUserItem), #0);//20080820 ����
              UserItem^ := m_UseItems[I];
              if not AddItemToBag(UserItem) then begin
                m_ItemList.Insert(0, UserItem);
              end;
              m_UseItems[I].wIndex := 0;
            end;
          end else m_UseItems[I].wIndex := 0;
        end;
      end;
    end;

    {//��鱳�����Ƿ��и���Ʒ
    for I := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then Break;
      UserItem := m_ItemList.Items[I];
      s14 := UserEngine.GetStdItemName(UserItem.wIndex);
      for II := I - 1 downto 0 do begin
        UserItem1 := m_ItemList.Items[II];
        if (UserEngine.GetStdItemName(UserItem1.wIndex) = s14) and
          (UserItem.MakeIndex = UserItem1.MakeIndex) then begin
          m_ItemList.Delete(II);
          Break;
        end;
      end;
    end; }
    for I := Low(m_dwStatusArrTick) to High(m_dwStatusArrTick) do begin
      if m_wStatusTimeArr[I] > 0 then m_dwStatusArrTick[I] := GetTickCount();
    end;
    if m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 0 then m_boAbilMagBubbleDefence := True;//ʹ��ħ����

    if m_btLastOutStatus = 1 then begin
      m_WAbil.HP := (m_WAbil.MaxHP div 15)+ 2;//20080404 ��������Ӣ��,ѪҪ���ܵ�
      m_btLastOutStatus := 0;
    end;

    if (m_Master <> nil) then begin//Ӣ�����ߴ���
      if (g_ManageNPC <> nil) then g_ManageNPC.GotoLable(TPlayObject(m_Master), '@HeroLogin', False, False);
      {$IF M2Version <> 2}
      if (TPlayObject(m_Master).m_nDecGameGirdCount > 0) then begin
        if (m_Magic99Skill <> nil) then
        SysMsg(Format('(Ӣ��) �ٻ���Ӣ�ۣ�����Զ�����������ǿ�����������У�Ŀǰ��ʣ%d��',[TPlayObject(m_Master).m_nDecGameGirdCount]), c_Blue, t_Hint);
      end else begin
        {$IF M2Version = 1}
        if (TPlayObject(m_Master).m_nDecGameGirdCount_Hero95 > 0) then begin
          SysMsg(Format('(Ӣ��) �ٻ���Ӣ�ۣ�����Զ������澭�������У�Ŀǰ��ʣ%d��',[TPlayObject(m_Master).m_nDecGameGirdCount_Hero95]), c_Blue, t_Hint);
        end else
        if (TPlayObject(m_Master).m_nDecGameGirdCount_95 > 0) then begin
          SysMsg(Format('(Ӣ��) �ٻ���Ӣ�ۣ�����Զ������澭�������У�Ŀǰ��ʣ%d��',[TPlayObject(m_Master).m_nDecGameGirdCount_95]), c_Blue, t_Hint);
        end;
        {$IFEND}
      end;  
      {$IFEND}
    end;
    m_boFixedHideMode := False;
  except
    on E: Exception do MainOutMessage(Format(sExceptionMsg,[g_sExceptionVer]));
  end;
end;

//�жϵ�Ӣ�۶����Ƿ�����,��ʾ�û� 20080401
//���� nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ    nCount Ϊ�־�,������
Function THeroObject.CheckHeroAmulet(nType: Integer; nCount: Integer):Boolean;
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
      MainOutMessage(Format('{%s} THeroObject.CheckHeroAmulet',[g_sExceptionVer]));
    end;
  end;
end;

//Ӣ����������  20080423
function THeroObject.LevelUpFunc: Boolean;
begin
  Result := False;
  if (g_FunctionNPC <> nil) and (m_Master <> nil) then begin
    g_FunctionNPC.GotoLable(TPlayObject(m_Master), '@HeroLevelUp', False, False);
    Result := True;
  end;
end;

//Ӣ���ڹ���������  20090509
function THeroObject.NGLevelUpFunc: Boolean;
begin
  Result := False;
  if (g_FunctionNPC <> nil) and (m_Master <> nil) then begin
    g_FunctionNPC.GotoLable(TPlayObject(m_Master), '@HeroNGLevelUp', False, False);
    Result := True;
  end;
end;

//Ӣ��ʹ����Ʒ����  20080728
function THeroObject.UseStdmodeFunItem(StdItem: pTStdItem): Boolean;
begin
  Result := False;
  if (g_FunctionNPC <> nil) and (m_Master <> nil) then begin
    g_FunctionNPC.GotoLable(TPlayObject(m_Master), '@StdModeFunc' + IntToStr(StdItem.AniCount), False, False);
    Result := True;
  end;
end;
//�ͻ�������ħ������ 20080606
procedure THeroObject.ChangeHeroMagicKey(nSkillIdx, nKey: Integer; sMsg: string);
var
  I: Integer;
  UserMagic: pTUserMagic;
  Str,Str1, Str2:String;
begin
  {$IF M2Version = 1}
  if sMsg <> '' then begin//�޸�������ݼ����� 20090915
    sMsg := GetValidStr3(sMsg, Str,  ['/']);
    sMsg := GetValidStr3(sMsg, Str1,  ['/']);
    sMsg := GetValidStr3(sMsg, Str2,  ['/']);
    m_SetBatterKey := Str_ToInt(Str,0);//��һ���������ܸ�
    m_SetBatterKey1 := Str_ToInt(Str1,0);//�ڶ����������ܸ�
    m_SetBatterKey2 := Str_ToInt(Str2,0);//�������������ܸ�
    m_SetBatterKey3 := Str_ToInt(sMsg,0);//���ĸ��������ܸ�
    if not m_boUser4BatterSkill then m_SetBatterKey3:= 0;//δ�������ĸ����� 20100720
  end;
  {$IFEND}
  if (nKey > 4) or (nKey < 0) then Exit;
  if m_MagicList.Count > 0 then begin
    for I := 0 to m_MagicList.Count - 1 do begin
      UserMagic := m_MagicList.Items[I];
      if UserMagic <> nil then begin
        if UserMagic.MagicInfo.wMagicId = nSkillIdx then begin
          UserMagic.btKey := nKey;
          Break;
        end;
      end;
    end;
  end;
end;
//�������и���Ʒ 20080901
procedure THeroObject.ClearCopyItem(wIndex, MakeIndex: Integer);
var
  I: Integer;
  UserItem: pTUserItem;
begin
  Try
    m_boOperationItemList:= True;//20080928 ��ֹͬʱ���������б�ʱ����
    for I := m_ItemList.Count - 1 downto 0 do begin
      if m_ItemList.Count <= 0 then Break;
      UserItem := m_ItemList.Items[I];
      if UserItem <> nil then begin//20090212 ����
        if (UserItem.wIndex = wIndex) and (UserItem.MakeIndex = MakeIndex) then begin
          SendDelItems(UserItem);
          m_ItemList.Delete(I);
          Dispose(UserItem);//20100928 ����
          Break;//20081014 ֻ�ҵ�һ�����˳������Ч��
        end;
      end;
    end;
    m_boOperationItemList:= False;//20080928 ��ֹͬʱ���������б�ʱ����
  except
    m_boOperationItemList:= False;//20080928 ��ֹͬʱ���������б�ʱ����
    MainOutMessage(Format('{%s} THeroObject.ClearCopyItem',[g_sExceptionVer]));
  end;
end;
{$IF M2Version <> 2}
//�������Ƿ�����Ѫʯ�������Զ����� 20090302
procedure THeroObject.CheckItmeAutoItme(btWhere, btStdMode, btShape: Byte);
var
  I, nItemIdx: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  boFound: Boolean;
  sItemName: string;
begin
  {$IF HEROVERSION = 1}
  if (m_Master = nil) or m_boDeath or m_boGhost then Exit;//20091123 ����
  try
    if m_ItemList.Count > 0 then begin
      for I := 0 to m_ItemList.Count - 1 do begin
        UserItem := m_ItemList.Items[I];
        if UserItem <> nil then begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then begin
            if (StdItem.StdMode = btStdMode) and (StdItem.Shape = btShape) then begin
              boFound := True;
              nItemIdx := UserItem.MakeIndex;
              sItemName:= StdItem.Name;
              Break;
            end;
          end;
        end;
      end;
    end;
    if (nItemIdx >= 0) and boFound then begin
      if m_Master <> nil then begin
        TPlayObject(m_Master).ClientHeroTakeOnItems(btWhere, nItemIdx, sItemName);
        SendUseitems();//����ʹ�õ���Ʒ
        ClientQueryBagItems;
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.CheckItmeAutoItme',[g_sExceptionVer]));
  end;
  {$IFEND}
end;

//��Ѫʯ���� 20080729
procedure THeroObject.PlaySuperRock;
var
  StdItem: pTStdItem;
  nTempDura: Integer;
  nCode: Byte;//20091124
begin
  nCode:= 0;
  Try
    //��Ѫʯ ħѪʯ
    if (not m_boDeath) and (not m_boGhost) and (m_WAbil.HP > 0) then begin
      nCode:= 1;
      if (m_UseItems[U_CHARM].wIndex > 0) and (m_UseItems[U_CHARM].Dura > 0) then begin
        nCode:= 2;
        StdItem := UserEngine.GetStdItem(m_UseItems[U_CHARM].wIndex);
        if (StdItem <> nil) then begin//20090128
          nCode:= 3;
          if (StdItem.Shape > 0) and (StdItem.StdMode = 7) and m_PEnvir.AllowStdItems(StdItem.Name) then begin//20090302
            case StdItem.Shape of
              1: begin //��Ѫʯ
                  if (m_WAbil.MaxHP - m_WAbil.HP) >= g_Config.nStartHPRock then begin//200081215 �ĳɵ���������
                    if GetTickCount - dwRockAddHPTick > g_Config.nHPRockSpell then begin
                      dwRockAddHPTick:= GetTickCount();//��ʯ��HP���
                      nCode:= 4;
                      if m_UseItems[U_CHARM].Dura * 10 > g_Config.nHPRockDecDura then begin
                        Inc(m_WAbil.HP, g_Config.nRockAddHP);
                        nTempDura := m_UseItems[U_CHARM].Dura * 10;
                        Dec(nTempDura, g_Config.nHPRockDecDura);
                        m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                        if m_UseItems[U_CHARM].Dura > 0 then begin
                          SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                        end else begin
                          nCode:= 5;
                          SendDelItems(@m_UseItems[U_CHARM]);
                          m_UseItems[U_CHARM].wIndex:= 0;
                          nCode:= 6;
                          CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                        end;
                      end else begin
                        nCode:= 7;
                        Inc(m_WAbil.HP, g_Config.nRockAddHP);
                        m_UseItems[U_CHARM].Dura := 0;
                        nCode:= 8;
                        SendDelItems(@m_UseItems[U_CHARM]);
                        m_UseItems[U_CHARM].wIndex:= 0;
                        nCode:= 9;
                        CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                      end;
                      if m_WAbil.HP > m_WAbil.MaxHP then m_WAbil.HP := m_WAbil.MaxHP;
                      nCode:= 10;
                      PlugHealthSpellChanged();
                    end;
                  end;
                end;
              2: begin
                  if (m_WAbil.MaxMP - m_WAbil.MP) >= g_Config.nStartMPRock then begin//200081215 �ĳɵ���������
                    if GetTickCount - dwRockAddMPTick > g_Config.nMPRockSpell then begin
                      dwRockAddMPTick:= GetTickCount;//��ʯ��MP���
                      nCode:= 11;
                      if m_UseItems[U_CHARM].Dura * 10 > g_Config.nMPRockDecDura then begin
                        Inc(m_WAbil.MP, g_Config.nRockAddMP);
                        nTempDura := m_UseItems[U_CHARM].Dura * 10;
                        Dec(nTempDura, g_Config.nMPRockDecDura);
                        m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                        nCode:= 12;
                        if m_UseItems[U_CHARM].Dura > 0 then begin
                          SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                        end else begin
                          nCode:= 13;
                          SendDelItems(@m_UseItems[U_CHARM]);
                          m_UseItems[U_CHARM].wIndex:= 0;
                          nCode:= 14;
                          CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                        end;
                      end else begin
                        nCode:= 15;
                        Inc(m_WAbil.MP, g_Config.nRockAddMP);
                        m_UseItems[U_CHARM].Dura := 0;
                        nCode:= 16;
                        SendDelItems(@m_UseItems[U_CHARM]);
                        m_UseItems[U_CHARM].wIndex:= 0;
                        nCode:= 17;
                        CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                      end;
                      if m_WAbil.MP > m_WAbil.MaxMP then  m_WAbil.MP:= m_WAbil.MaxMP ;
                      nCode:= 18;
                      PlugHealthSpellChanged();
                    end;
                  end;
                end;
              3: begin
                if (m_WAbil.MaxHP - m_WAbil.HP ) >= g_Config.nStartHPMPRock then begin//200081215 �ĳɵ���������
                  if GetTickCount - dwRockAddHPTick > g_Config.nHPMPRockSpell then begin
                    dwRockAddHPTick:= GetTickCount;//��ʯ��HP���
                    nCode:= 19;
                    if m_UseItems[U_CHARM].Dura * 10 > g_Config.nHPMPRockDecDura then begin
                      Inc(m_WAbil.HP, g_Config.nRockAddHPMP);
                      nTempDura := m_UseItems[U_CHARM].Dura * 10;
                      Dec(nTempDura, g_Config.nHPMPRockDecDura);
                      m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                      nCode:= 20;
                      if m_UseItems[U_CHARM].Dura > 0 then begin
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      end else begin
                        nCode:= 21;
                        SendDelItems(@m_UseItems[U_CHARM]);
                        m_UseItems[U_CHARM].wIndex:= 0;
                        nCode:= 22;
                        CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                      end;
                    end else begin
                      nCode:= 23;
                      Inc(m_WAbil.HP, g_Config.nRockAddHPMP);
                      m_UseItems[U_CHARM].Dura := 0;
                      SendDelItems(@m_UseItems[U_CHARM]);
                      nCode:= 24;
                      m_UseItems[U_CHARM].wIndex:= 0;
                      CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                    end;
                    if m_WAbil.HP > m_WAbil.MaxHP then m_WAbil.HP := m_WAbil.MaxHP;
                    nCode:= 25;
                    PlugHealthSpellChanged();
                  end;
                end;
                //======================================================================
                if (m_WAbil.MaxMP - m_WAbil.MP ) >= g_Config.nStartHPMPRock then begin//200081215 �ĳɵ���������
                  if GetTickCount - dwRockAddMPTick > g_Config.nHPMPRockSpell then begin
                    dwRockAddMPTick:= GetTickCount;//��ʯ��MP���
                    nCode:= 26;
                    if m_UseItems[U_CHARM].Dura * 10 > g_Config.nHPMPRockDecDura then begin
                      Inc(m_WAbil.MP, g_Config.nRockAddHPMP);
                      nTempDura := m_UseItems[U_CHARM].Dura * 10;
                      Dec(nTempDura, g_Config.nHPMPRockDecDura);
                      m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                      nCode:= 27;
                      if m_UseItems[U_CHARM].Dura > 0 then begin
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      end else begin
                        nCode:= 28;
                        SendDelItems(@m_UseItems[U_CHARM]);
                        m_UseItems[U_CHARM].wIndex:= 0;
                        nCode:= 29;
                        CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                      end;
                    end else begin
                      nCode:= 30;
                      Inc(m_WAbil.MP, g_Config.nRockAddHPMP);
                      m_UseItems[U_CHARM].Dura := 0;
                      SendDelItems(@m_UseItems[U_CHARM]);
                      nCode:= 31;
                      m_UseItems[U_CHARM].wIndex:= 0;
                      CheckItmeAutoItme(U_CHARM, StdItem.StdMode, StdItem.Shape);//�������Ƿ�����Ѫʯ�������Զ����� 20090302
                    end;
                    if m_WAbil.MP > m_WAbil.MaxMP then m_WAbil.MP := m_WAbil.MaxMP;
                    nCode:= 32;
                    PlugHealthSpellChanged();
                  end;
                end;
              end;//3 begin
              5: begin
                if (m_WAbil.MaxHP - m_WAbil.HP ) >= g_Config.nStartHPMPRock1 then begin
                  if GetTickCount - dwRockAddHPTick > g_Config.nHPMPRockSpell1 then begin
                    dwRockAddHPTick:= GetTickCount;//��HP���
                    nCode:= 19;
                    if m_UseItems[U_CHARM].Dura * 10 > g_Config.nHPMPRockDecDura1 then begin
                      Inc(m_WAbil.HP, g_Config.nRockAddHPMP1);
                      nTempDura := m_UseItems[U_CHARM].Dura * 10;
                      Dec(nTempDura, g_Config.nHPMPRockDecDura1);
                      m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                      nCode:= 20;
                      if m_UseItems[U_CHARM].Dura > 0 then begin
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      end else begin
                        m_UseItems[U_CHARM].Dura:= 0;
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                        RecalcAbilitys();
                        CompareSuitItem(False);
                        SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//����Ӣ������
                      end;
                    end else begin
                      nCode:= 23;
                      Inc(m_WAbil.HP, g_Config.nRockAddHPMP1);
                      m_UseItems[U_CHARM].Dura := 0;
                      SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      RecalcAbilitys();
                      CompareSuitItem(False);
                      SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//����Ӣ������
                    end;
                    if m_WAbil.HP > m_WAbil.MaxHP then m_WAbil.HP := m_WAbil.MaxHP;
                    nCode:= 25;
                    PlugHealthSpellChanged();
                  end;
                end;
                //======================================================================
                if (m_WAbil.MaxMP - m_WAbil.MP ) >= g_Config.nStartHPMPRock1 then begin
                  if GetTickCount - dwRockAddMPTick > g_Config.nHPMPRockSpell1 then begin
                    dwRockAddMPTick:= GetTickCount;//��MP���
                    nCode:= 26;
                    if m_UseItems[U_CHARM].Dura * 10 > g_Config.nHPMPRockDecDura1 then begin
                      Inc(m_WAbil.MP, g_Config.nRockAddHPMP1);
                      nTempDura := m_UseItems[U_CHARM].Dura * 10;
                      Dec(nTempDura, g_Config.nHPMPRockDecDura1);
                      m_UseItems[U_CHARM].Dura := Round(nTempDura / 10);
                      nCode:= 27;
                      if m_UseItems[U_CHARM].Dura > 0 then begin
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      end else begin
                        m_UseItems[U_CHARM].Dura:= 0;
                        SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                        RecalcAbilitys();
                        CompareSuitItem(False);
                        SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//����Ӣ������
                      end;
                    end else begin
                      nCode:= 30;
                      Inc(m_WAbil.MP, g_Config.nRockAddHPMP1);
                      m_UseItems[U_CHARM].Dura := 0;
                      SendMsg(self, RM_HERODURACHANGE, U_CHARM, m_UseItems[U_CHARM].Dura, m_UseItems[U_CHARM].DuraMax, 0, '');
                      RecalcAbilitys();
                      CompareSuitItem(False);
                      SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');//����Ӣ������
                    end;
                    if m_WAbil.MP > m_WAbil.MaxMP then m_WAbil.MP := m_WAbil.MaxMP;
                    nCode:= 32;
                    PlugHealthSpellChanged();
                  end;
                end;
              end;//5 begin
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s} THeroObject.PlaySuperRock Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//�����Ʒ�Ƿ�Ϊ��ý��Ʒ
function THeroObject.CheckItemSpiritMedia(UserItem: pTUserItem): Boolean;
begin
  Result :=(UserItem.btAppraisalValue[2] in [231..250]) or (UserItem.btAppraisalValue[3] in [231..250]) or
           (UserItem.btAppraisalValue[4] in [231..250]) or (UserItem.btAppraisalValue[5] in [231..250]) or
           (UserItem.btUnKnowValue[6] in [231..250]) or (UserItem.btUnKnowValue[7] in [231..250]) or
           (UserItem.btUnKnowValue[8] in [231..250]) or (UserItem.btUnKnowValue[9] in [231..250]);
end;
//�����Ʒ�Ƿ�Ϊ��ý��Ʒ
function THeroObject.CheckItemSpiritMedia(UserItem: TUserItem): Boolean;
begin
  Result :=(UserItem.btAppraisalValue[2] in [231..250]) or (UserItem.btAppraisalValue[3] in [231..250]) or
           (UserItem.btAppraisalValue[4] in [231..250]) or (UserItem.btAppraisalValue[5] in [231..250]) or
           (UserItem.btUnKnowValue[6] in [231..250]) or (UserItem.btUnKnowValue[7] in [231..250]) or
           (UserItem.btUnKnowValue[8] in [231..250]) or (UserItem.btUnKnowValue[9] in [231..250]);
end;

//3��Ψ�Ҷ�����(Ŀ��ķ�����ħ������0������Ч������10��)
procedure THeroObject.Skill102MagicAttack(nX, nY: Integer; nRage: Integer);
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
        if TargeTBaseObject <> nil then begin
          if (TargeTBaseObject.m_Master <> nil) and (TargeTBaseObject.m_Master = self) then Continue;//�Լ�����������
          if IsProperTarget(TargeTBaseObject) then begin
            if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin //Ӣ��������,����������
              if not THeroObject(TargeTBaseObject).m_boTarget then TargeTBaseObject.SetTargetCreat(self);
            end else TargeTBaseObject.SetTargetCreat(self);
            TargeTBaseObject.MakeSkill102Mag(10);//
          end;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
end;
{$IFEND}
//Ӣ�۾������� 20080925
function THeroObject.MagMakeHPUp(UserMagic: pTUserMagic): Boolean;
  function GetSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wSpell + UserMagic.MagicInfo.btDefSpell;
  end;
var
  nSpellPoint, n14: Integer;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  if nSpellPoint > 0 then begin
    //if UserMagic.btLevel > 0 then begin
      if (m_Abil.WineDrinkValue >= Round(m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
        if (GetTickCount - m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (m_wStatusArrValue[4] = 0) then begin //ʱ����
          if m_WAbil.MP < nSpellPoint then begin
            SysMsg('MPֵ����!!!', c_Red, t_Hint);
            Exit;
          end;
          DamageSpell(nSpellPoint);//��MPֵ
          HealthSpellChanged();
          n14:= {UserMagic.btLevel}300 + g_Config.nHPUpUseTime;
          m_dwStatusArrTimeOutTick[4] := GetTickCount + n14 * 1000;//ʹ��ʱ��
          m_wStatusArrValue[4] := UserMagic.btLevel;//����ֵ
          SysMsg('(Ӣ��)����ֵ˲������, ����' + IntToStr(n14) + '��', c_Green, t_Hint);
          SysMsg('(Ӣ��)���������Ѿ��ڼ���״̬', c_Green, t_Hint);
          RecalcAbilitys();
          CompareSuitItem(False);//��װ������װ���Ա�
          SendMsg(self, RM_HEROABILITY, 0, 0, 0, 0, '');
          Result := True;
        end else begin
          if g_sOpenShieldOKMsg <> '' then SysMsg('(Ӣ��)'+g_sOpenShieldOKMsg, c_Red, t_Hint);
        end;
      end else SysMsg('(Ӣ��)��ƶȲ�����'+inttostr(g_Config.nMinDrinkValue68)+'%ʱ,����ʹ�ô˼��� ', c_Red, t_Hint);
    //end else SysMsg('�ȼ����1������,����ʹ�ô˼���', c_Red, t_Hint);
  end;
end;

//ˢ��Ӣ������������20081126
procedure THeroObject.RecalcAdjusBonus();
  procedure AdjustAb(Abil: Byte; Val: Word; var lov, hiv: Word);
  var
    Lo, Hi: Byte;
    I: Integer;
  begin
    Lo := LoByte(Abil);
    Hi := HiByte(Abil);
    lov := 0; hiv := 0;
    for I := 1 to Val do begin
      if Lo + 1 < Hi then begin
        Inc(Lo);
        Inc(lov);
      end else begin
        Inc(Hi);
        Inc(hiv);
      end;
    end;
  end;
var
  BonusTick: pTNakedAbility;
  NakedAbil: pTNakedAbility;
  adc, amc, asc, aac, amac: Integer;
  ldc, lmc, lsc, lac, lmac, hdc, hmc, hsc, hac, hmac: Word;
begin
  BonusTick := nil;
  NakedAbil := nil;
  case m_btJob of
    0: begin
        BonusTick := @g_Config.BonusAbilofWarr;
        NakedAbil := @g_Config.NakedAbilofWarr;
      end;
    1: begin
        BonusTick := @g_Config.BonusAbilofWizard;
        NakedAbil := @g_Config.NakedAbilofWizard;
      end;
    2: begin
        BonusTick := @g_Config.BonusAbilofTaos;
        NakedAbil := @g_Config.NakedAbilofTaos;
      end;
    {3: begin//�̿�(��ʱ��սʿ����)
        BonusTick := @g_Config.BonusAbilofWarr;
        NakedAbil := @g_Config.NakedAbilofWarr;
      end; }
  end;

  adc := m_BonusAbil.DC div BonusTick.DC;
  amc := m_BonusAbil.MC div BonusTick.MC;
  asc := m_BonusAbil.SC div BonusTick.SC;
  aac := m_BonusAbil.AC div BonusTick.AC;
  amac := m_BonusAbil.MAC div BonusTick.MAC;

  AdjustAb(NakedAbil.DC, adc, ldc, hdc);
  AdjustAb(NakedAbil.MC, amc, lmc, hmc);
  AdjustAb(NakedAbil.SC, asc, lsc, hsc);
  AdjustAb(NakedAbil.AC, aac, lac, hac);
  AdjustAb(NakedAbil.MAC, amac, lmac, hmac);
  //lac  := 0;  hac := aac;
  //lmac := 0;  hmac := amac;

  m_WAbil.DC := MakeLong(LoWord(m_WAbil.DC) + ldc, HiWord(m_WAbil.DC) + hdc);
  m_WAbil.MC := MakeLong(LoWord(m_WAbil.MC) + lmc, HiWord(m_WAbil.MC) + hmc);
  m_WAbil.SC := MakeLong(LoWord(m_WAbil.SC) + lsc, HiWord(m_WAbil.SC) + hsc);
  m_WAbil.AC := MakeLong(LoWord(m_WAbil.AC) + lac, HiWord(m_WAbil.AC) + hac);
  m_WAbil.MAC := MakeLong(LoWord(m_WAbil.MAC) + lmac, HiWord(m_WAbil.MAC) + hmac);

  if m_WAbil.MaxHP + m_BonusAbil.HP div BonusTick.HP > High(Integer) then begin//20091026 �޸�
    m_WAbil.MaxHP := High(Integer);
  end else m_WAbil.MaxHP := m_WAbil.MaxHP + m_BonusAbil.HP div BonusTick.HP;

  if m_WAbil.MaxMP + m_BonusAbil.MP div BonusTick.MP > High(Integer) then begin//20091026 �޸�
    m_WAbil.MaxMP := High(Integer);
  end else m_WAbil.MaxMP := m_WAbil.MaxMP + m_BonusAbil.MP div BonusTick.MP;
  //m_WAbil.MaxHP := _MIN(High(Word), m_WAbil.MaxHP + m_BonusAbil.HP div BonusTick.HP);
  //m_WAbil.MaxMP := _MIN(High(Word), m_WAbil.MaxMP + m_BonusAbil.MP div BonusTick.MP);
  //m_btSpeedPoint:=m_btSpeedPoint + m_BonusAbil.Speed div BonusTick.Speed;
  //m_btHitPoint:=m_btHitPoint + m_BonusAbil.Hit div BonusTick.Hit;
end;

//�������װ��������Ʒ�Ƿ� 20081127
function THeroObject.CheckItemBindDieNoDrop(UserItem: pTUserItem): Boolean;
var
  I: Integer;
  ItemBind: pTItemBind;
begin
  Result := False;
  g_ItemBindDieNoDropName.Lock;
  try
    if g_ItemBindDieNoDropName.Count > 0 then begin
      for I := 0 to g_ItemBindDieNoDropName.Count - 1 do begin
        ItemBind := g_ItemBindDieNoDropName.Items[I];
        if ItemBind <> nil then begin
          if ItemBind.nItemIdx = UserItem.wIndex then begin
            if (CompareText(ItemBind.sBindName, m_sCharName) = 0) then Result := True;
            Exit;
          end;
        end;
      end;
    end;
  finally
    g_ItemBindDieNoDropName.UnLock;
  end;
end;

//-----------------------------------------------------------------------------
//�ͻ���Ӣ�۰��������Ʒ 20090616
procedure THeroObject.ClientHeroItemSplit(nItemMakeIdx{����ID}: Integer; nDura{�������}: Integer);
var
  I: Integer;
  UserItem, UserItem1: pTUserItem;
  StdItem: pTStdItem;
begin
  if not m_boGhost then begin
    if m_boMergerIteming then Exit;
    m_boMergerIteming:= True;
    TPlayObject(m_Master).m_boCanQueryBag:= True;//����ˢ�°���
    try
      if (nItemMakeIdx > 0) and (nDura > 0) and (nDura < High(Word)) then begin//20090816 ����
        try
          if IsEnoughBag then begin//����δ��ʱ
            if m_ItemList.Count > 0 then begin
              for I := 0 to m_ItemList.Count - 1 do begin
                UserItem := m_ItemList.Items[I];
                if (UserItem <> nil) then begin
                  if (UserItem.MakeIndex = nItemMakeIdx) then begin
                    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
                    if StdItem <> nil then begin
                      if (StdItem.StdMode = 17) and (UserItem.Dura > nDura) then begin
                        UserItem.Dura:= UserItem.Dura - nDura;
                        SendUpdateItem(UserItem);//������Ʒ
                        New(UserItem1);
                        if UserEngine.CopyToUserItemFromName(StdItem.Name, UserItem1) then begin
                          UserItem1.AddValue[0]:= UserItem.AddValue[0];//20110911 ����
                          UserItem1.MaxDate:= UserItem.MaxDate;//���ʱ��  //20110911 ��
                          UserItem1.btValue[14]:= UserItem.btValue[14];//20110928 ����
                          UserItem1.Dura:= nDura;
                          if UserItem1.Dura > UserItem1.DuraMax then UserItem1.Dura:= UserItem1.DuraMax;
                          m_ItemList.Add(UserItem1);
                          SendAddItem(UserItem1);
                          if StdItem.NeedIdentify = 1 then begin
                            AddGameDataLog('42' + #9 + m_sMapName + #9 +
                              IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                              m_sCharName + #9 + StdItem.Name + #9 +
                              IntToStr(UserItem.MakeIndex) + #9 +
                              IntToStr(UserItem.Dura)+'/'+IntToStr(UserItem.DuraMax)+ #9 + '(Ӣ��)�����Ʒ');

                            AddGameDataLog('42' + #9 + m_sMapName + #9 +
                              IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                              m_sCharName + #9 + StdItem.Name + #9 +
                              IntToStr(UserItem1.MakeIndex) + #9 +
                              IntToStr(UserItem1.Dura)+'/'+IntToStr(UserItem1.DuraMax)+ #9 + '(Ӣ��)��ֻ��');
                          end;
                        end else Dispose(UserItem1);
                      end;
                      Break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        except
          MainOutMessage(Format('{%s} THeroObject.ClientHeroItemSplit',[g_sExceptionVer]));
        end;
      end;
    finally
      TPlayObject(m_Master).m_boCanQueryBag:= False;//����ˢ�°���
      m_boMergerIteming:= False;
    end;
  end;
end;

//�ͻ���(Ӣ�۰���)�ϲ���Ʒ 20090616
procedure THeroObject.ClientHeroItemMerger(nItemMakeIdx{��Ҫ�ϲ�����Ʒ����ID}: Integer; sMakeIdx{�ϲ�������Ʒ}: String);
var
  I, II, nMakeIdx: integer;
  UserItem, UserItem1: pTUserItem;
  StdItem, StdItem1: pTStdItem;
  boMergerOK: Byte;
begin
  if m_boMergerIteming or (m_boGhost) then Exit;//�Ƿ����ںϲ���Ʒ 20090616
  m_boMergerIteming:= True;
  TPlayObject(m_Master).m_boCanQueryBag:= True;//����ˢ�°���
  boMergerOK:= 0;
  UserItem:= nil;
  UserItem1:= nil;
  try
    nMakeIdx := Str_ToInt(sMakeIdx, 0);
    if (nItemMakeIdx > 0) and (nMakeIdx > 0) and (nItemMakeIdx <> nMakeIdx) then begin
      try
        for I := m_ItemList.Count - 1 downto 0 do begin
          if m_ItemList.Count <= 0 then Break;
          UserItem := m_ItemList.Items[I];
          if UserItem <> nil then begin
            if (UserItem.MakeIndex = nItemMakeIdx) then begin
              StdItem := UserEngine.GetStdItem(UserItem.wIndex);
              if StdItem <> nil then begin
                if StdItem.StdMode = 17 then begin
                  for II := m_ItemList.Count - 1 downto 0 do begin
                    UserItem1 := m_ItemList.Items[II];
                    if UserItem1 <> nil then begin
                      if (UserItem1.MakeIndex = nMakeIdx) then begin
                        StdItem1 := UserEngine.GetStdItem(UserItem1.wIndex);
                        if StdItem1 <> nil then begin
                          if (StdItem1.StdMode = 17) and (StdItem.Shape = StdItem1.Shape)
                            and (StdItem.Name = StdItem1.Name) and (UserItem1.AddValue[0]= UserItem.AddValue[0])
                            and (((128 shr 1) and (UserItem1.btValue[14])) = ((128 shr 1) and (UserItem.btValue[14])))
                            and (((128 shr 0) and (UserItem1.btValue[14])) = ((128 shr 0) and (UserItem.btValue[14]))) then begin
                            if UserItem1.Dura + UserItem.Dura > UserItem1.DuraMax then begin
                              UserItem.Dura:= UserItem1.Dura + UserItem.Dura - UserItem1.DuraMax;
                              UserItem1.Dura:= UserItem1.DuraMax;
                              boMergerOK:= 2;
                              SendDefMessage(SM_MERGER_FAIL, 0, 1, 0, 0,'');
                              SendUpdateItem(UserItem);//������Ʒ
                              SendUpdateItem(UserItem1);//������Ʒ
                              if StdItem.NeedIdentify = 1 then
                                AddGameDataLog('43' + #9 + m_sMapName + #9 +
                                  IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                                  m_sCharName + #9 + StdItem.Name + #9 + IntToStr(UserItem1.MakeIndex) + #9 +
                                  IntToStr(UserItem1.Dura)+'/'+IntToStr(UserItem1.DuraMax)+ #9 + '(Ӣ��)�ϲ���Ʒ1('+IntToStr(UserItem.MakeIndex)+'/'+IntToStr(UserItem.Dura)+')');
                            end else begin
                              UserItem1.Dura:= UserItem1.Dura + UserItem.Dura;
                              SendUpdateItem(UserItem1);//������Ʒ
                              if StdItem.NeedIdentify = 1 then
                                AddGameDataLog('43' + #9 + m_sMapName + #9 +
                                  IntToStr(m_nCurrX) + #9 + IntToStr(m_nCurrY) + #9 +
                                  m_sCharName + #9 + StdItem.Name + #9 + IntToStr(UserItem1.MakeIndex) + #9 +
                                  IntToStr(UserItem1.Dura)+'/'+IntToStr(UserItem1.DuraMax)+ #9 + '(Ӣ��)�ϲ���Ʒ('+IntToStr(UserItem.MakeIndex)+')');
                              UserItem.MakeIndex:= 0;
                              UserItem.wIndex:= 0;
                              boMergerOK:= 1;
                              m_ItemList.Delete(I);
                              SendDelItems(UserItem);
                              //DisPoseAndNil(UserItem);
                              DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                              UserItem := nil;
                            end;
                          end;
                        end;
                        Break;
                      end;
                    end;
                  end;//for
                end;
              end;
              Break;
            end;
          end;
        end;
      except
        MainOutMessage(Format('{%s} THeroObjectMerger',[g_sExceptionVer]));
      end;
    end;
    case boMergerOK of
      0: SendDefMessage(SM_MERGER_FAIL, 0, 1, 0, 0,'');
      1: SendDefMessage(SM_MERGER_OK, 0, 0, 0, 0,'');
    end;
  finally
    TPlayObject(m_Master).m_boCanQueryBag:= False;//����ˢ�°���
    m_boMergerIteming:= False;
  end;
end;

function THeroObject.QuestCheckItem(sItemName{��Ʒ��}: string; var nCount{����},
  nParam: Integer; var nDura: Integer): pTUserItem;
var
  I: Integer;
  UserItem: pTUserItem;
  s1C: string;
begin
  Result := nil;
  nParam := 0;
  nDura := 0;
  nCount := 0;
  if m_ItemList.Count > 0 then begin
    for I := 0 to m_ItemList.Count - 1 do begin
      UserItem := m_ItemList.Items[I];
      if UserItem <> nil then begin
        s1C := UserEngine.GetStdItemName(UserItem.wIndex);
        if CompareText(s1C, sItemName) = 0 then begin
          if UserItem.Dura > nDura then begin
            nDura := UserItem.Dura;
            Result := UserItem;
          end;
          Inc(nParam, UserItem.Dura);
          if Result = nil then Result := UserItem;
          Inc(nCount);
        end;
      end;
    end;
  end;
end;
{$IF M2Version = 1}
//��ת���� ȡ�ȼ��������辭��
function THeroObject.GetSkill95Exp(nLevel: Byte): LongWord;
begin
  Result := 0;
  if nLevel = 0 then nLevel:= 1;
  if (m_btRaceServer = RC_HEROOBJECT) then begin
    if nLevel < 100 then begin//���99��
      Result := g_Config.dwSkill95NeedExps[nLevel];
    end else Result := High(LongWord);
  end else Result := High(LongWord);
end;

//���㶷תֵ����
function THeroObject.GetSkill_95Value(nAC, nAMC: Integer; nLevel:Byte):Word;
  function GetValue(Key, nLevel: Integer): Integer;
  const
    BASE_KEY   =  20;
    BASE_VALUE = 306;
  var
    iKey, iMod, iDiv: Integer;
  begin
    iKey := Key - BASE_KEY;
    iDiv := iKey div 10;
    iMod := iKey mod 10;

    Result := BASE_VALUE + iDiv * 9 + iMod + nLevel * 3;
    if iMod > 0 then Result := Result - 1;
  end;
begin
  Result := 0;
  case m_btJob of
    0: Result := _MIN(High(Word),GetValue(nAC + nAMC, nLevel));
    1: Result := _MIN(High(Word), Round(0.598 * (nAC + nAMC) + 45.652 + nLevel));
    2: Result := _MIN(High(Word), Round((nAC + nAMC + 156.909) / 0.78668)  + (nLevel - 4) * 5);
  end;
  if m_wStatusArrValue[18] > 0 then Result := _MIN(High(Word), Result + m_wStatusArrValue[18]);//��Ԫ����������
end;

//��½ʱ������Ѩ����
procedure THeroObject.SendUserPulseArr;
var
  sSENDMSG: string;
begin
   {$IF HEROVERSION = 1}
  if m_boTrainingNG and m_boOpenHumanPulseArr then begin//ѧ���ڹ�
    //�����������辭��
    if m_wHumanPulseArr[0].boOpenPulse and (m_wHumanPulseArr[0].nPulseLevel < 5) then
       m_wHumanPulseArr[0].dwUpPulseLevelExp := g_Config.dwExpHeroPulsNeedExps0[m_wHumanPulseArr[0].nPulseLevel];
    if m_wHumanPulseArr[1].boOpenPulse and (m_wHumanPulseArr[1].nPulseLevel < 5) then
       m_wHumanPulseArr[1].dwUpPulseLevelExp := g_Config.dwExpHeroPulsNeedExps1[m_wHumanPulseArr[1].nPulseLevel];
    if m_wHumanPulseArr[2].boOpenPulse and (m_wHumanPulseArr[2].nPulseLevel < 5) then
       m_wHumanPulseArr[2].dwUpPulseLevelExp := g_Config.dwExpHeroPulsNeedExps2[m_wHumanPulseArr[2].nPulseLevel];
    if m_wHumanPulseArr[3].boOpenPulse and (m_wHumanPulseArr[3].nPulseLevel < 5) then
       m_wHumanPulseArr[3].dwUpPulseLevelExp := g_Config.dwExpHeroPulsNeedExps3[m_wHumanPulseArr[3].nPulseLevel];

    sSENDMSG := EncodeBuffer(@m_wHumanPulseArr, SizeOf(THeroPulseInfo1));
    if sSENDMSG <> '' then begin
      SendMsg(Self, RM_SENDUSERPULSEARR, 1, m_ExpPuls, 0, 0, sSENDMSG);
    end;
    SendUserPulsePulsePoint(0, False);
  end;
  {$IFEND}
end;
//������Ѩ��ӦѨλ�����Լ�������ڹ��ȼ�
procedure THeroObject.SendUserPulsePulsePoint(nPulse{����ҳ}: byte; boOK: Boolean);
var
  nPoint,m_nPulse,nLevel:Byte;
begin
  if m_boTrainingNG and (nPulse < 4) and m_boOpenHumanPulseArr then begin//ѧ���ڹ�
    if boOK then begin
      if m_wHumanPulseArr[nPulse].boOpenPulse then begin//��ǰ������ͨʱ
        if nPulse < 3 then begin
          nPoint:= 1 ;//��Ӧ��Ѩλ
          nLevel:= g_Config.dwPulsePointNGLevel[(nPulse + 1) * 5];//�ڹ��ȼ�
          m_nPulse:= nPulse + 1;//����ҳ
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, m_nPulse,'');
        end;
      end else begin
        if m_wHumanPulseArr[nPulse].nPulsePoint < 5 then begin
          nPoint:= m_wHumanPulseArr[nPulse].nPulsePoint + 1;
          nLevel:= g_Config.dwPulsePointNGLevel[nPulse * 5 + m_wHumanPulseArr[nPulse].nPulsePoint];
          m_nPulse:= nPulse ;//����ҳ
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, m_nPulse,'');
        end;
      end;
    end else begin
      if not m_wHumanPulseArr[0].boOpenPulse then begin
        if m_wHumanPulseArr[0].nPulsePoint < 5 then begin
          nLevel:= g_Config.dwPulsePointNGLevel[m_wHumanPulseArr[0].nPulsePoint];
          nPoint:= m_wHumanPulseArr[0].nPulsePoint + 1;
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, 0,'');
        end;
      end else
      if not m_wHumanPulseArr[1].boOpenPulse then begin
        if m_wHumanPulseArr[1].nPulsePoint < 5 then begin
          nLevel:= g_Config.dwPulsePointNGLevel[5 + m_wHumanPulseArr[1].nPulsePoint];
          nPoint:= m_wHumanPulseArr[1].nPulsePoint + 1;
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, 1,'');
        end;
      end else
      if not m_wHumanPulseArr[2].boOpenPulse then begin
        if m_wHumanPulseArr[2].nPulsePoint < 5 then begin
          nLevel:= g_Config.dwPulsePointNGLevel[10 + m_wHumanPulseArr[2].nPulsePoint];
          nPoint:= m_wHumanPulseArr[2].nPulsePoint + 1;
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, 2,'');
        end;
      end else
      if not m_wHumanPulseArr[3].boOpenPulse then begin
        if m_wHumanPulseArr[3].nPulsePoint < 5 then begin
          nLevel:= g_Config.dwPulsePointNGLevel[15 + m_wHumanPulseArr[3].nPulsePoint];
          nPoint:= m_wHumanPulseArr[3].nPulsePoint + 1;
          SendMsg(Self, RM_SENDUSERPULSESHINY, 1, nPoint, nLevel, 3,'');
        end;
      end;
    end;
  end;
end;

//�ͻ��˵��Ѩλ,ִ�нű�����ͨѨλ
procedure THeroObject.ClientOpenHeroPulsePoint(nPulse{����ҳ}, nPoint{Ѩλ}: byte);
begin
  if m_boTrainingNG and (nPoint < 6) and m_boOpenHumanPulseArr then begin//ѧ���ڹ�
    case nPulse of
      0..3: begin//����,����,��ά,����
        //���Ѩλ�Ƿ��Ѵ�ͨ
        if (m_wHumanPulseArr[nPulse].nPulsePoint >= nPoint) or m_wHumanPulseArr[nPulse].boOpenPulse then begin//Ѩλ�Ѵ�ͨʱ,�����Ѵ�ͨʱ
          if (g_BatterNPC <> nil) and (m_Master <> nil) then g_BatterNPC.GotoLable(TPlayObject(m_Master), '@Ѩλ��ͨ', False, False);
          Exit;
        end;
        //�����һ�����Ǵ�ͨ 20090718
        if nPulse > 0 then begin
          if not m_wHumanPulseArr[nPulse - 1].boOpenPulse then Exit;
        end;
        if (g_BatterNPC <> nil) and (m_Master <> nil) then g_BatterNPC.GotoLable(TPlayObject(m_Master), '@HeroPulse'+inttostr(nPulse)+'-'+inttostr(nPoint), False, False);
      end;
      4: begin//�澭
        if (m_wHumanPulseArr[nPulse].nPulsePoint < 6) then begin
          case nPoint of
            1: begin//���
              if (m_wHumanPulseArr[nPulse].nPulsePoint >= nPoint) then Exit;//����Ѵ�ͨ�����˳�
              if (g_BatterNPC <> nil) and (m_Master <> nil) then g_BatterNPC.GotoLable(TPlayObject(m_Master), '@HeroPulse'+inttostr(nPulse)+'-'+inttostr(nPoint), False, False);
            end;
            2: begin//�м�
              Exit;
            end;
            3: begin//����
              Exit;
            end;
            4: begin//�˷�
              Exit;
            end;
            5: begin//ӿȪ
              Exit;
            end;
          end;
        end;
      end;//4
    end;
  end;
end;

//���͸�����Ѩ����
procedure THeroObject.SendUpdataPulseArr(nPulse{����ҳ}: byte);
var
  sSENDMSG: string;
begin
  if m_boTrainingNG and m_boOpenHumanPulseArr and (nPulse < 5) then begin//ѧ���ڹ�
    sSENDMSG := EncodeBuffer(@m_wHumanPulseArr[nPulse], SizeOf(THeroPulseInfo));
    if sSENDMSG <> '' then begin                               
      m_DefMsg := MakeDefaultMsg(SM_SENDHEROUPDATAPULSEARR, nPulse, 0, 0, 0, m_ExpPuls);
      SendSocket(@m_DefMsg,sSENDMSG);
    end;
  end;
end;

//�ͻ��������澭����  nPage-����ҳ,0-���, nMakeIndex-����ID
procedure THeroObject.ClientHeroSkillToJingQing(nPage: Byte; nMakeIndex: Integer);
var
  I: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  nPoint, nMaxExp: LongWord;
  boSkill: Boolean;  
begin
  if (nMakeIndex > 0) then begin
    if (m_Master <> nil) and (not m_boDeath) and (not m_boGhost)then begin
      if TPlayObject(m_Master).IncSkill95Exping then Exit;//20110524 ��ֹ����
      TPlayObject(m_Master).IncSkill95Exping:= True;
      try
        TPlayObject(m_Master).m_dwDecGameGirdTick:= TPlayObject(m_Master).m_dwDecGameGirdTick + 3000;//20110202
        case nPage of
          0: begin//���
            nPoint:= 0;
            boSkill:= False;
            if m_Magic95Skill <> nil then begin
              if (m_Magic95Skill.btLevel < 64) or (m_boOpenupSkill95 and (m_Magic95Skill.btLevel < 100)) then begin
                for I := m_ItemList.Count - 1 downto 0 do begin
                  if m_ItemList.Count <= 0 then Break;
                  UserItem := m_ItemList.Items[I];
                  if (UserItem <> nil) then begin
                    if (UserItem.MakeIndex = nMakeIndex) then begin
                      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
                      if StdItem <> nil then begin
                        if (StdItem.StdMode = 17) and (StdItem.Shape = 238) and (StdItem.AniCount > 0) then begin
                          boSkill:= True;
                          nPoint:= StdItem.AniCount * 1000 * UserItem.Dura;
                          Inc(m_Magic95Skill.nTranPoint, nPoint);
                          SysMsg(Format('(Ӣ��) �������%d���澭�����㣡',[nPoint]), c_Red, t_Hint);
                          nMaxExp:= GetSkill95Exp(m_Magic95Skill.btLevel);
                          if m_Magic95Skill.nTranPoint >= nMaxExp then begin
                            Dec(m_Magic95Skill.nTranPoint, nMaxExp);
                            Inc(m_Magic95Skill.btLevel);
                            SysMsg(Format('(Ӣ��) ��ϲ��,ͻ�����Ѩ�Ľ�����������Ϊ��%d��!����ת���ơ�����������%d����',[m_Magic95Skill.btLevel, m_Magic95Skill.btLevel]), c_Red, t_Hint);
                            //����������Ķ�תֵ
                            m_WAbil.MaxTransferValue:= GetSkill_95Value(HiWord(m_WAbil.AC), HiWord(m_WAbil.MAC), m_Magic95Skill.btLevel);
                            if m_WAbil.TransferValue > m_WAbil.MaxTransferValue then m_WAbil.TransferValue:= m_WAbil.MaxTransferValue;
                            SendMsg(Self, RM_HEROABILITY, 0, 0, 0, 0, '');
                          end;
                          nMaxExp:= GetSkill95Exp(m_Magic95Skill.btLevel);
                          SendMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic95Skill.MagicInfo.wMagicId, nMaxExp, m_Magic95Skill.btLevel, m_Magic95Skill.nTranPoint, '');
                          m_ItemList.Delete(I);
                          //DisPoseAndNil(UserItem);
                          DisPose(UserItem);//DisPoseAndNil�Ǹ�������ʵ�ֵĺ��� By TasNat at: 2012-03-17 17:2
                          UserItem := nil;
                        end;
                      end;
                      Break;
                    end;
                  end;
                end; // for
              end;
            end;
            if boSkill then SendMsg(Self, RM_SKILLTOJINGQING_OK, 0, 1, 0, 0, '')
            else SendMsg(Self, RM_SKILLTOJINGQING_FAIL, 0, 1, 0, 0, '');
          end;//0
        end;
      finally
        TPlayObject(m_Master).IncSkill95Exping:= False;
      end;
    end;
  end;  
end;

//ȡ��Ӣ�۾��羭�� nType 1-��Ʒ�Ӿ��羭��
procedure THeroObject.GetPulsExp(dwExp: LongWord; nType: byte);
begin
  if m_boTrainingNG and m_boOpenHumanPulseArr and m_wHumanPulseArr[0].boOpenPulse and (not m_boGhost) then begin//���Ҵ�ͨһ������
    if nType <> 1 then begin
      if m_nKillMonExpRate <= 0 then m_nKillMonExpRate:= 100;//20100520 ��ֹ����Ϊ����
      dwExp := g_Config.dwKillMonExpMultiple * dwExp; //ϵͳָ��ɱ�־��鱶��
      dwExp := Round((m_nKillMonExpRate / 100) * dwExp); //����ָ����ɱ�־���ٷ���
      if m_PEnvir <> nil then begin
        if m_PEnvir.m_boEXPRATE then dwExp := Round((m_PEnvir.m_nEXPRATE / 100) * dwExp); //��ͼ��ָ��ɱ�־��鱶��
        if m_PEnvir.m_boPULSEXPRATE then dwExp := Round((m_PEnvir.m_nPULSEXPRATE / 100) * dwExp);//��ͼ��ָ��ɱ��Ӣ�۾��羭�鱶�� 20091029
      end;
      if m_boExpItem then dwExp := Round(m_rExpItem * dwExp);//��Ʒ���鱶��
      if m_Abil.Level >= 1000 then begin//�ȼ����侭��
        dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[1000] / 100));
        if dwExp <= 0 then dwExp:= 1;
      end else begin
        dwExp:= Round(dwExp * (g_Config.dwLevelToExpRate[m_Abil.Level] / 100));
        if dwExp <= 0 then dwExp:= 1;
      end;
      dwExp := abs(Round(dwExp * g_Config.dwKillMonHeroPulsExpMultiple / 100));//ɱ�־��羭�鱶��
    end;
    if dwExp <= 0 then dwExp:= 1;//20091109 ����

    if (dwExp > 0) then begin
      if m_ExpPuls >= LongWord(dwExp) then begin
        if (High(LongWord) - m_ExpPuls) < LongWord(dwExp) then begin
          dwExp := High(LongWord) - m_ExpPuls;
        end;
      end else begin
        if (High(LongWord) - LongWord(dwExp)) < m_ExpPuls then begin
          dwExp := High(LongWord) - LongWord(dwExp);
        end;
      end;

      Inc(m_ExpPuls, dwExp);//��ǰ���羭��
      SendGetPulsExp(dwExp);//���;��羭��
    end;
  end;
end;

procedure THeroObject.SendGetPulsExp(dwExp: LongWord);
begin
  if (m_Master <> nil) and (not m_boDeath) and (not m_boGhost)then begin
    if not TPlayObject(m_Master).m_boNotOnlineAddExp then begin//ֻ���͸������߹һ�����
      SendDefMessage1(SM_SENDHEROGETPULSEEXP , dwExp, 0, 0, 0, m_ExpPuls, '');
    end;
  end;
end;
//Ӣ��ȡ��������ID
function THeroObject.HeroGetBatterMagic(): Boolean;
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
    if (m_TargetCret <> nil) then begin
      if (m_TargetCret = m_Master) then begin//20110716Ŀ��Ϊ����ʱ������
        m_TargetCret:= nil;
        Exit;
      end;
    end;
    nCode:= 1;
    if (not boUseBatterToMon) and (m_TargetCret <> nil) then begin//�����ô�ֲ�ʹ������ʱ
      if (m_TargetCret.m_btRaceServer <> RC_PLAYOBJECT) and (m_TargetCret.m_btRaceServer <> RC_HEROOBJECT) and//����,Ӣ��
         (m_TargetCret.m_btRaceServer <> 110) and (m_TargetCret.m_btRaceServer <> 111) and//���ţ���ǽ
         (m_TargetCret.m_btRaceServer <> 10) and (m_TargetCret.m_btRaceServer <> 11) and (m_TargetCret.m_btRaceServer <> RC_GUARD) then begin
        Exit;
      end;
    end;
    nCode:= 2;
    if m_boTrainingNG and m_boTrainBatterSkill and (not m_boUseBatter) and (m_TargetCret <> nil) and
      (GetTickCount()- m_nUseBatterTick > g_Config.dwHeroUseBatterTick) and (m_BatterMagicList.Count > 0) then begin//ѧ������������ʱ��ﵽ
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
          if g_sUseBatterSummoned <> '' then SysMsg('(Ӣ��)'+g_sUseBatterSummoned, c_Green, t_Hint);//20110208 ����
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
    MainOutMessage(Format('{%s} THeroObject.HeroGetBatterMagic Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//������
procedure THeroObject.UseBatterSpell(nMagicID{����ID},StormsHit{������}: Byte);
var
  UserMagic: pTUserMagic;
  nSpellPoint: Integer;
  boTrain: Boolean;
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
          SysMsg(Format('(Ӣ��) ��ǰ��ͼ������ʹ�ã�%s', [UserMagic.MagicInfo.sMagicName]), c_Red, t_Notice);
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
        SysMsg('(Ӣ��) ��ǰ��ͼ������ʹ�ü���', c_Red, t_Notice);
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
        SysMsg('(Ӣ��) ��������', c_Green, t_Hint);
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
              if MagicManager.MagMakeSkillFire_77(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_80: begin //�����{��}
              if MagicManager.MagMakeSkillFire_80(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_83: begin //���ױ�{��}
              if MagicManager.MagMakeSkillFire_83(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_86: begin //����ѩ��{��}
              if MagicManager.MagMakeSkillFire_86(self, UserMagic, m_nTargetX, m_nTargetY,StormsHit) then boTrain := True;
            end;
          SKILL_78: begin //��Х��{��}
              if MagicManager.MagMakeSkillFire_78(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_81: begin //������{��}
              if MagicManager.MagMakeSkillFire_81(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_84: begin //������{��}
              if MagicManager.MagMakeSkillFire_84(self, UserMagic, m_nTargetX, m_nTargetY, m_TargetCret,StormsHit) then boTrain := True;
            end;
          SKILL_87: begin //�򽣹���{��}
              if MagicManager.MagMakeSkillFire_87(self, UserMagic, m_nTargetX, m_nTargetY,StormsHit) then boTrain := True;
            end;
        end;//Case
        nCode:= 12;
        SendRefMsg(RM_MAGICFIRE, 0,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                                MakeLong(m_nTargetX, m_nTargetY),Integer(m_TargetCret),'');
        if (UserMagic.btLevel < 5) and (boTrain) then begin
          nCode:= 14;
          case UserMagic.MagicInfo.wMagicId of
            SKILL_77, SKILL_78: begin //˫����{��} ��Х��{��}
                if UserMagic.btLevel < m_wHumanPulseArr[0].nPulseLevel then begin
                  TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
                  if not CheckMagicLevelup(UserMagic) then begin
                    SendDelayMsg(self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
                  end;
                end;
              end;
            SKILL_80, SKILL_81: begin //�����{��} ������{��}
                if UserMagic.btLevel < m_wHumanPulseArr[1].nPulseLevel then begin
                  TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
                  if not CheckMagicLevelup(UserMagic) then begin
                    SendDelayMsg(self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
                  end;
                end;
              end;
            SKILL_83, SKILL_84: begin //���ױ�{��} ������{��}
                if UserMagic.btLevel < m_wHumanPulseArr[2].nPulseLevel then begin
                  TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
                  if not CheckMagicLevelup(UserMagic) then begin
                    SendDelayMsg(self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
                  end;
                end;
              end;
            SKILL_86, SKILL_87: begin //����ѩ��{��} �򽣹���{��}
                if UserMagic.btLevel < m_wHumanPulseArr[3].nPulseLevel then begin
                  TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
                  if not CheckMagicLevelup(UserMagic) then begin
                    SendDelayMsg(self, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
                  end;
                end;
              end;
          end;//case
        end;
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
    MainOutMessage(Format('{%s} THeroObject.UseBatterSpell Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

//ս��������
procedure THeroObject.BatterAttackDir(TargeTBaseObject: TBaseObject; wHitMode: Word; StormsHit{������}: Byte);
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
              SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [m_Magic79Skill.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
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
            nWeaponDamage := (Random(5) + 2) - m_AddAbil.btWeaponStrong;//����ǿ��
            if (nWeaponDamage > 0) and (m_UseItems[U_WEAPON].wIndex > 0) then DoDamageWeapon(nWeaponDamage);
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
          nCode :=5;
          if (m_Magic79Skill <> nil) then begin //׷�Ĵ�
            nCode :=6;
            if Attack_79(nPower, m_Magic79Skill.btLevel, m_btDirection) then begin
              nCode :=18;
              if (m_Magic79Skill.btLevel < 5) and (m_Magic79Skill.btLevel < m_wHumanPulseArr[1].nPulseLevel) then begin//20110115 �޸�
              //if (m_Magic79Skill.btLevel < 3) and (m_Magic79Skill.MagicInfo.TrainLevel[m_Magic79Skill.btLevel] <= m_NGLevel) then begin
                nCode :=19;
                TrainSkill(m_Magic79Skill, Random(3) + 1);
                nCode :=20;
                if not CheckMagicLevelup(m_Magic79Skill) then begin
                  nCode :=21;
                  SendDelayMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic79Skill.MagicInfo.wMagicId, 0, m_Magic79Skill.btLevel, m_Magic79Skill.nTranPoint, '', 3000);
                end;
              end;
            end;
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
              SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [m_Magic76Skill.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
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
            nWeaponDamage := (Random(5) + 2) - m_AddAbil.btWeaponStrong;//����ǿ��
            if (nWeaponDamage > 0) and (m_UseItems[U_WEAPON].wIndex > 0) then DoDamageWeapon(nWeaponDamage);
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
            nCode :=11;
            if (m_Magic76Skill <> nil) then begin//����ɱ����
              nCode :=22;
              if (m_Magic76Skill.btLevel < 5) and (m_Magic76Skill.btLevel < m_wHumanPulseArr[0].nPulseLevel) then begin//20110115 �޸�
              //if (m_Magic76Skill.btLevel < 3) and (m_Magic76Skill.MagicInfo.TrainLevel[m_Magic76Skill.btLevel] <= m_NGLevel) then begin
                nCode :=23;
                TrainSkill(m_Magic76Skill, Random(3) + 1);
                nCode :=24;
                if not CheckMagicLevelup(m_Magic76Skill) then begin
                  nCode :=25;
                  SendDelayMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic76Skill.MagicInfo.wMagicId, 0, m_Magic76Skill.btLevel, m_Magic76Skill.nTranPoint, '', 3000);
                end;
              end;
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
              SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [m_Magic85Skill.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
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
            nCode :=14;
            if (m_Magic85Skill <> nil) then begin//��ɨǧ������
              nCode :=26;
              if (m_Magic85Skill.btLevel < 5) and (m_Magic85Skill.btLevel < m_wHumanPulseArr[3].nPulseLevel) then begin//20110115 �޸�
              //if (m_Magic85Skill.btLevel < 3) and (m_Magic85Skill.MagicInfo.TrainLevel[m_Magic85Skill.btLevel] <= m_NGLevel) then begin
                nCode :=27;
                TrainSkill(m_Magic85Skill, Random(3) + 1);
                nCode :=28;
                if not CheckMagicLevelup(m_Magic85Skill) then begin
                  nCode :=29;
                  SendDelayMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic85Skill.MagicInfo.wMagicId, 0, m_Magic85Skill.btLevel, m_Magic85Skill.nTranPoint, '', 3000);
                end;
              end;
            end;
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
              SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [m_Magic82Skill.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
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
            nCode :=17;
            if (m_Magic82Skill <> nil) then begin//����ն����
              nCode :=30;
              if (m_Magic82Skill.btLevel < 5) and (m_Magic82Skill.btLevel < m_wHumanPulseArr[2].nPulseLevel) then begin//20110115 �޸�
              //if (m_Magic82Skill.btLevel < 3) and (m_Magic82Skill.MagicInfo.TrainLevel[m_Magic82Skill.btLevel] <= m_NGLevel) then begin
                nCode :=31;
                TrainSkill(m_Magic82Skill, Random(3) + 1);
                nCode :=32;
                if not CheckMagicLevelup(m_Magic82Skill) then begin
                  nCode :=33;
                  SendDelayMsg(Self, RM_HEROMAGIC_LVEXP, m_Magic82Skill.MagicInfo.wMagicId, 0, m_Magic82Skill.btLevel, m_Magic82Skill.nTranPoint, '', 3000);
                end;
              end;
            end;        
          end;
          Result := True;
        end;//17
      end;
    except
      on E: Exception do begin
        MainOutMessage(Format('{%s} THeroObject._BatterAttack Code:%d',[g_sExceptionVer, nCode]));
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
      MainOutMessage(Format('{%s} TBaseObject.BatterAttackDir Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
end;

{$IFEND}
procedure THeroObject.Initialize;
var
  I: Integer;
  sFileName, sCopyHumBagItems, sLineText, sMagicName, sItemName: string;
  ItemIni: TIniFile;
  TempList: TStringList;
  UserItem: pTUserItem;
  Magic: pTMagic;
  MagicInfo: pTMagic;
  UserMagic: pTUserMagic;
  StdItem: pTStdItem;
begin
  if (m_Master <> nil) and (m_Master is TAIPlayObject) and m_boAI then begin
    sFileName := TAIPlayObject(m_Master).GetRandomConfigFileName(m_sCharName, 1);
    if (sFileName = '') or (not FileExists(sFileName)) then begin
      if (TAIPlayObject(m_Master).m_sHeroConfigFileName <> '') and FileExists(TAIPlayObject(m_Master).m_sHeroConfigFileName) then begin
        sFileName := TAIPlayObject(m_Master).m_sHeroConfigFileName;
      end;
    end;
    m_btStatus:= 0;
    if (sFileName <> '') and FileExists(sFileName) then begin
      for I := 0 to m_MagicList.Count - 1 do begin
        UserMagic := pTUserMagic(m_MagicList.Items[I]);
        Dispose(UserMagic);
        //��ֹ�ͷ��ڴ��ķǷ����� By TasNat at: 2012-03-11
        //m_MagicOfDelList.Add(UserMagic);
      end;
      m_MagicList.Clear;

      for I := 0 to m_ItemList.Count - 1 do begin
        Dispose(pTUserItem(m_ItemList.Items[I]));
      end;
      m_ItemList.Clear;
      for I := {$IF M2Version <> 2}U_DRESS to U_ZHULI{$ELSE}U_DRESS to U_RINGR{$IFEND} do begin
        m_UseItems[I].wIndex := 0;
      end;

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
        GetBagItemCount;

        sLineText := ItemIni.ReadString('Info', 'UseSkill', '');

        if sLineText <> '' then begin
          TempList := TStringList.Create;
          try
            ExtractStrings(['|', '\', '/', ','], [], PChar(sLineText), TempList);
            for I := 0 to TempList.Count - 1 do begin
              sMagicName := Trim(TempList.Strings[I]);
              if FindMagic1(sMagicName) = nil then begin
                Magic := UserEngine.FindHeroMagic(sMagicName);
                if Magic <> nil then begin
                  if (Magic.btJob = 99) or (Magic.btJob = m_btJob) then begin
                    if Magic.wMagicId = SKILL_75 then begin//�������
                      m_boProtectionDefence:= True;
                      Continue;//����
                    end;
                    if (Magic.btJob = SKILL_SHIELD) then boAutoOpenDefence:= True;//�Զ�����ħ����
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
          Magic := UserEngine.FindHeroMagic(GetTogetherUseSpell);//�Զ����Ӻϻ�����
          if Magic <> nil then begin
            New(UserMagic);
            UserMagic.MagicInfo := Magic;
            UserMagic.wMagIdx := Magic.wMagicId;
            UserMagic.btLevel := 3;
            UserMagic.btKey := 0;
            UserMagic.nTranPoint := Magic.MaxTrain[3];
            m_MagicList.Add(UserMagic);
          end;
        end;

        sLineText := ItemIni.ReadString('Info', 'InitItems', '');
        if sLineText <> '' then begin
          TempList := TStringList.Create;
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
          TempList.Free;
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

        for {$IF M2Version <> 2}I := U_DRESS to U_ZHULI{$ELSE}I := U_DRESS to U_RINGR{$IFEND} do begin
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
        m_WAbil.HP := m_WAbil.MaxHP;
        m_WAbil.MP := m_WAbil.MaxMP;

        AbilCopyToWAbil();
      end;
    end;
  end;
  inherited;
end;

end.



