unit MShare;

interface
uses
  Windows, SysUtils, Classes, cliutil, DXDraws, DWinCtl,
  WIL, UiWil, Actor, Grobal2, DXSounds, IniFiles, Share,Graphics, Rc6, Mars, StrUtils, CnHashTable;
type
//������Ϣ��¼
  TRecinfo = record
    GameSky: string[100];
    GameGhost: string[100];
    GameSdo: string[100];
    GameTwe: string[100];
    GameDraw: string[100];
    GameWT: string[100];
    GameZH: string[100];
    GameWW: string[100];
  end;
  {TClientEffecItem = record
    ClientItem: TClientItem;
    ClientEffec:TEffecItem;
  end;
  pTClientEffectItem = ^TClientEffecItem;}

  TTimerCommand = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice);
  TChrAction = (caWalk, caRun, caHorseRun, caHit, caSpell, caSitdown);
  TConnectionStep = (cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);
//TItemType = (i_All, i_HPDurg,i_MPDurg,i_HPMPDurg,i_OtherDurg,i_Weapon,i_Dress,i_Helmet,i_Necklace,i_Armring,i_Ring,i_Belt,i_Boots,i_Charm,i_Book,i_PosionDurg,i_UseItem,i_Scroll,i_Stone,i_Gold,i_Other);
                              //  [ҩƷ] [����]      [�·�]    [ͷ��][����]     [����]      [��ָ] [����] [Ь��] [��ʯ]         [������][��ҩ]        [����Ʒ][����]
  TItemType = (i_All, i_Other, i_HPMPDurg, i_Dress, i_Weapon, i_Jewelry, i_Decoration, i_Decorate);

  TMovingItem = record
    Index: integer;
    Item: TClientItem;
  end;
  pTMovingItem = ^TMovingItem;
  {TControlInfo = record
    Image       :Integer;
    Left        :Integer;
    Top         :Integer;
    Width       :Integer;
    Height      :Integer;
    Obj         :TDControl;
  end;  }
  TShowItem1 = record
    ItemType: TItemType;
    sItemName: string;
    sItemType: string;
    boHintMsg: Boolean;
    boPickup: Boolean;
    boShowName: Boolean;
  end;
  pTShowItem1 = ^TShowItem1;
  TMapDesc = record
    sMapName: string; //��ǰ��ͼ
    sMainMapName: string;//С��ͼ����
    m_nMapX: Integer; //��������X(4�ֽ�)
    m_nMapY: Integer; //��������Y(4�ֽ�)
    btColor: TColor; //���ֵ���ɫ
    boMaxMap: Boolean;
  end;
  pMapDesc = ^TMapDesc;

  TConfig = record
    boAutoPuckUpItem: Boolean;
    boNoShift: Boolean;
    boExpFiltrate: Boolean; //20080714
    boShowMimiMapDesc: Boolean;
    boShowHeroStateNumber : Boolean;
    boShowName: Boolean;
    boDuraWarning: Boolean;
    boLongHit: Boolean;
    boPosLongHit: Boolean;
    boAutoWideHit: Boolean;
    boAutoFireHit: Boolean;
    boAutoZhuriHit: Boolean;
    boAutoShield: Boolean;
    boHeroAutoShield: Boolean;
    boShowSpecialDamage: Boolean;
    boAutoDragInBody: Boolean;
    boHideHumanWing: Boolean;
    boHideWeaponEffect: Boolean;
    boAutoHide: Boolean;
    boAutoMagic: Boolean;
    nAutoMagicTime: Integer;
    boAutoEatWine: Boolean;
    boAutoEatHeroWine: Boolean;
    boAutoEatDrugWine: Boolean;
    boAutoEatHeroDrugWine: Boolean;
    btEditWine: Byte;
    btEditHeroWine: Byte;
    btEditDrugWine: Byte;
    btEditHeroDrugWine: Byte;
    dwEditExpFiltrate: LongWord;
//=============ҩƷ================
    boHp1Chk: Boolean;
    wHp1Hp: Integer;
    btHp1Man: Byte;
    boMp1Chk: Boolean;
    wMp1Mp: Integer;
    btMp1Man: Byte;
    boRenewHPIsAuto: Boolean;
    wRenewHPTime: Word;
    wRenewHPTick: LongWord;
    wRenewHPPercent: Integer;
    boRenewMPIsAuto: Boolean;
    wRenewMPTime: Word;
    wRenewMPPercent: Integer;
    wRenewMPTick: LongWord;
    boRenewSpecialHPIsAuto: Boolean;
    wRenewSpecialHPTime: Word;
    wRenewSpecialHPTick: LongWord;
    wRenewSpecialHPPercent: Integer;
    boRenewSpecialMPIsAuto: Boolean;
    wRenewSpecialMPTime: Word;
    wRenewSpecialMPTick: LongWord;
    wRenewSpecialMPPercent: Integer;
    BoUseSuperMedica: Boolean;
    SuperMedicaItemNames: array[0..8+5] of string;
    SuperMedicaUses: array[0..8+5] of Boolean;
    SuperMedicaHPs: array[0..8+5] of Integer;
    SuperMedicaHPTimes: array[0..8+5] of Word;
    SuperMedicaHPTicks: array[0..8+5] of LongWord;
    SuperMedicaMPs: array[0..8+5] of Integer;
    SuperMedicaMPTimes: array[0..8+5] of Word;
    SuperMedicaMPTicks: array[0..8+5] of LongWord;
    {$IF M2Version <> 2}
    boHp2Chk: Boolean;
    wHp2Hp: Integer;
    //btHp2Man: Byte;
    boMp2Chk: Boolean;
    wMp2Mp: Integer;
    //btMp2Man: Byte;
    boHp3Chk: Boolean;
    wHp3Hp: Integer;
    //btHp3Man: Byte;
    boMp3Chk: Boolean;
    wMp3Mp: Integer;
    //btMp3Man: Byte;
    boHp4Chk: Boolean;
    wHp4Hp: Integer;
    //btHp4Man: Byte;
    boMp4Chk: Boolean;
    wMp4Mp: Integer;
    //btMp4Man: Byte;
    boHp5Chk: Boolean;
    wHp5Hp: Integer;
    //btHp5Man: Byte;
    boMp5Chk: Boolean;
    wMp5Mp: Integer;
    //btMp5Man: Byte;
    boRenewHeroNormalHpIsAuto: Boolean;
    wRenewHeroNormalHpTime: Word;
    wRenewHeroNormalHpTick: LongWord;
    wRenewHeroNormalHpPercent: Integer;
    boRenewzHeroNormalHpIsAuto: Boolean;
    wRenewzHeroNormalHpTime: Word;
    wRenewzHeroNormalHpTick: LongWord;
    wRenewzHeroNormalHpPercent: Integer;
    boRenewfHeroNormalHpIsAuto: Boolean;
    wRenewfHeroNormalHpTime: Word;
    wRenewfHeroNormalHpTick: LongWord;
    wRenewfHeroNormalHpPercent: Integer;
    boRenewdHeroNormalHpIsAuto: Boolean;
    wRenewdHeroNormalHpTime: Word;
    wRenewdHeroNormalHpTick: LongWord;
    wRenewdHeroNormalHpPercent: Integer;
    boRenewHeroNormalMpIsAuto: Boolean;
    wRenewHeroNormalMpTime: Word;
    wRenewHeroNormalMpTick: LongWord;
    wRenewHeroNormalMpPercent: Integer;
    boRenewzHeroNormalMpIsAuto: Boolean;
    wRenewzHeroNormalMpTime: Word;
    wRenewzHeroNormalMpTick: LongWord;
    wRenewzHeroNormalMpPercent: Integer;
    boRenewfHeroNormalMpIsAuto: Boolean;
    wRenewfHeroNormalMpTime: Word;
    wRenewfHeroNormalMpTick: LongWord;
    wRenewfHeroNormalMpPercent: Integer;
    boRenewdHeroNormalMpIsAuto: Boolean;
    wRenewdHeroNormalMpTime: Word;
    wRenewdHeroNormalMpTick: LongWord;
    wRenewdHeroNormalMpPercent: Integer;

    boRenewSpecialHeroNormalHpIsAuto: Boolean;
    wRenewSpecialHeroNormalHpTime: Word;
    wRenewSpecialHeroNormalHpTick: LongWord;
    wRenewSpecialHeroNormalHpPercent: Integer;
    boRenewSpecialzHeroNormalHpIsAuto: Boolean;
    wRenewSpecialzHeroNormalHpTime: Word;
    wRenewSpecialzHeroNormalHpTick: LongWord;
    wRenewSpecialzHeroNormalHpPercent: Integer;
    boRenewSpecialfHeroNormalHpIsAuto: Boolean;
    wRenewSpecialfHeroNormalHpTime: Word;
    wRenewSpecialfHeroNormalHpTick: LongWord;
    wRenewSpecialfHeroNormalHpPercent: Integer;
    boRenewSpecialdHeroNormalHpIsAuto: Boolean;
    wRenewSpecialdHeroNormalHpTime: Word;
    wRenewSpecialdHeroNormalHpTick: LongWord;
    wRenewSpecialdHeroNormalHpPercent: Integer;

    boRenewSpecialHeroNormalMpIsAuto: Boolean;
    wRenewSpecialHeroNormalMpTime: Word;
    wRenewSpecialHeroNormalMpTick: LongWord;
    wRenewSpecialHeroNormalMpPercent: Integer;
    boRenewSpecialzHeroNormalMpIsAuto: Boolean;
    wRenewSpecialzHeroNormalMpTime: Word;
    wRenewSpecialzHeroNormalMpTick: LongWord;
    wRenewSpecialzHeroNormalMpPercent: Integer;
    boRenewSpecialfHeroNormalMpIsAuto: Boolean;
    wRenewSpecialfHeroNormalMpTime: Word;
    wRenewSpecialfHeroNormalMpTick: LongWord;
    wRenewSpecialfHeroNormalMpPercent: Integer;
    boRenewSpecialdHeroNormalMpIsAuto: Boolean;
    wRenewSpecialdHeroNormalMpTime: Word;
    wRenewSpecialdHeroNormalMpTick: LongWord;
    wRenewSpecialdHeroNormalMpPercent: Integer;
    hBoUseSuperMedica: Boolean;
    zBoUseSuperMedica: Boolean;
    fBoUseSuperMedica: Boolean;
    dBoUseSuperMedica: Boolean;
    hSuperMedicaUses: array[0..8+5] of Boolean;
    hSuperMedicaHPs: array[0..8+5] of Integer;
    hSuperMedicaHPTimes: array[0..8+5] of Word;
    hSuperMedicaHPTicks: array[0..8+5] of LongWord;
    hSuperMedicaMPs: array[0..8+5] of Integer;
    hSuperMedicaMPTimes: array[0..8+5] of Word;
    hSuperMedicaMPTicks: array[0..8+5] of LongWord;
    zSuperMedicaUses: array[0..8+5] of Boolean;
    zSuperMedicaHPs: array[0..8+5] of Integer;
    zSuperMedicaHPTimes: array[0..8+5] of Word;
    zSuperMedicaHPTicks: array[0..8+5] of LongWord;
    zSuperMedicaMPs: array[0..8+5] of Integer;
    zSuperMedicaMPTimes: array[0..8+5] of Word;
    zSuperMedicaMPTicks: array[0..8+5] of LongWord;
    fSuperMedicaUses: array[0..8+5] of Boolean;
    fSuperMedicaHPs: array[0..8+5] of Integer;
    fSuperMedicaHPTimes: array[0..8+5] of Word;
    fSuperMedicaHPTicks: array[0..8+5] of LongWord;
    fSuperMedicaMPs: array[0..8+5] of Integer;
    fSuperMedicaMPTimes: array[0..8+5] of Word;
    fSuperMedicaMPTicks: array[0..8+5] of LongWord;
    dSuperMedicaUses: array[0..8+5] of Boolean;
    dSuperMedicaHPs: array[0..8+5] of Integer;
    dSuperMedicaHPTimes: array[0..8+5] of Word;
    dSuperMedicaHPTicks: array[0..8+5] of LongWord;
    dSuperMedicaMPs: array[0..8+5] of Integer;
    dSuperMedicaMPTimes: array[0..8+5] of Word;
    dSuperMedicaMPTicks: array[0..8+5] of LongWord;
    {$IFEND}
  end;
  TFileItemDB = class
    m_FileItemList: TList;
    m_ShowItemList: Thashedstringlist;//THashTable; //THashedStringlist;//TStringList;
  private
  public
    constructor Create();
    destructor Destroy; override;
    function Find(sItemName: string): pTShowItem1;
    procedure Get(sItemType: string; var ItemList: TList); overload;
    procedure Get(ItemType: TItemType; var ItemList: TList); overload;
    function Add(ShowItem: pTShowItem1): Boolean;
    procedure Hint(DropItem: pTDropItem);
    procedure LoadFormList(LoadList: TStringList);
    procedure LoadFormFile(); overload;
    procedure LoadFormFile(const FileName: string); overload;
    procedure SaveToFile();
    procedure BackUp;
  end;
  {//----�Զ�Ѱ·���-----//20080617
  TFindNode = record
    X, Y: Integer; //����
  end;
  PFindNOde = ^TFindNode;

  PTree = ^Tree;
  Tree = record
    H: Integer;
    X, Y: Integer;
    Dir: Byte;
    Father: PTree;
  end;

  PLink = ^Link;
  Link = record
    Node: PTree;
    F: Integer;
    Next: PLink;
  end; }
  TDelChr = record
    ChrInfo: TUserCharacterInfo;
  end;
  pTDelChr = ^TDelChr;

  TTzHintInfo = record//��װ��ʾ��ʾ�ṹ
    sTzCaption: string; //��װ����
    btItemsCount: Byte; //��װ����
    sTzItems: string; //��װ��Ʒ
    btIncNHRate: Byte;//�����ָ�(����)% 20090330
    btReserved: Byte;  //����
    btReserved1: Byte; //��Ѫ
    btReserved2: Byte; //���˵ȼ�                        
    btReserved3: Byte;
    btReserved4: Byte;
    btReserved5: Byte;
    btReserved6: Byte;
    btReserved7: Byte;
    btReserved8: Byte;
    btReserved9: Byte;
    btReserved10: Byte;
    btReserved11: Byte;
    btReserved12: Byte;
    btReserved13: Byte; //��ɫְҵ
    sMemo: string; //���ܽ���
    btInNum: Byte; //��Ʒƥ������
  end;
  pTTzHintInfo = ^TTzHintInfo;

  TBatterDesc = record
    sName: string;
    sLine1: string;
    sLine2: string;
    sLine3: string;
  end;
  pTBatterDesc = ^TBatterDesc;

  TItemDesc = record
    sItemName: string[14];
    sItemDesc: string[80];
  end;
  pTItemDesc = ^TItemDesc;

  {$IF M2Version <> 2}
  TTitleDesc = record
    sTitleName: string[14];
    sTitleDesc: string[80];
    sNewStateTitleDesc: string[100];
  end;
  pTTitleDesc = ^TTitleDesc;
  {$IFEND}

  TSkillDesc = record
    sSkillType: string[10];
    sSkillName: string[14];
    sSkillDesc: string[80];
  end;
  pTSkillDesc = ^TSkillDesc;
  TJLBoxFreeItem = record
    Item: TBoxsInfo;
    boCloak: Boolean;   //�Ƿ񱻸�ס
  end;
  TItemArr = record
    Item: TClientItem;
    boLockItem: Boolean; //������Ʒ
  end;
  TDrawEffect = record
    nIndex: Integer;
    dwDrawTick: LongWord;
  end;
  pTDrawEffect = ^TDrawEffect;
  //����
  TPetDlg = record
  	sLogList: TStringList;  //��־
    nHapply: LongWord;   //���ֶ�
  end;

  {$IF M2Version <> 2}
  TFactionDlg = record
  	sDivisionName: string; //������
    boIsAdmin: Boolean; //�����ϴ�
    sHeartName: string; //�ķ���
    sHeartTpye: string; //�ķ�����
    btDivisonType: Byte; //��������
    nPopularity: Integer; //����
    sMasterName: string; //ʦ������
    sMemberCount: string; //����
    nHeartLeve: Integer; //�����ķ��ȼ�
  	NoticeList: TStringList; //����
    boPublic: Boolean; //����ʦ��
  end;
  //�ڹ��ķ�����
  TLingWuXinFa = record
    btGetM2Type: Byte; //��M2��ȡ�򿪴���ʱ���ķ�����
    boChangeXinFa: Boolean; //True�����ķ�  FALSEΪ�����ķ�
    btIndex: Byte; //�ķ���������ֵ
    btPage: Byte; //�ķ�ҳ��
    btHelpPage: Byte; //�ķ�����ҳ��
    btCurrentFrame: Byte; //��ǰ��
    dwStartTimeTick: LongWord; //����
    nKeySelIndex: Integer; //��ǰѡ��İ�������
    btKeyPage: Byte; //����ҳ��
    sKeySelCaption: string[12];
  end;

  TFactionMember = record
    AdminNum: Byte; //��������
    MemberNum: Byte; //��Ա����
    SelMemberName: string[ACTORNAMELEN];//ѡ���˵�����
  end;
  {$IFEND}
  TRunParam = packed record
    wProt : Word;
    sConfigKeyWord : string[34];
    LoginGateIpAddr1 : Byte;
    wScreenWidth : Word; //�ֱ���
    sWinCaption : string[30];
    wScreenHeight : Word;
    LoginGateIpAddr0 : Byte;
    sESystemUrl : string[30];
    LoginGateIpAddr2 : Byte;
    btBitCount : Byte; //ɫ��
    sMirDir : string[250];
    ParentWnd : HWND;
    sServerPassWord : string[10];
    LoginGateIpAddr3 : Byte;
    boFullScreen : Boolean;
  end;
const
  BugFile = 'Log\!56Log.ui';
  SeedString = 'jdjwicjchahpnmstardhxksjhha'; //�����ַ��������Լ��趨
  Byte0=Byte('0');
  RecInfoSize = Sizeof(TRecinfo);  //���ر�TRecinfo��ռ�õ��ֽ���
  g_XinFaName: array[0..4] of string[4] = ('�Ͻ�', '��ľ', '���', '��ˮ', '����');
//==========================================
var
  g_ShowItemList: TFileItemDB;
  //OldDrawTime: LongWord;
  //{$IF Version = 0}
  g_StartTick: Cardinal; // ��ʼ����ʱ��(���� FPS)
  g_FrameCount: Cardinal; // �ѻ��������(���� FPS)
  g_IsShowFPS: Boolean = True;
  g_dwProcessInterval: Integer = 2;
  g_dwProcessTime: Longword;
  g_dwRunTime: Longword;
  g_nilFeature: TFeatures; //��ۿ�ֵ
  //{$IFEND}
  g_sLogoText       :String = '3K����'; //3K����
  g_sGoldName       :String = '���';
  g_sGameGoldName   :String = 'Ԫ��';
  g_sGamePointName  :String = '��ҫ��';
  g_sGameGird       :String = '���';
  g_sGameDiaMond    :String = '���ʯ';
  g_dGamePointDate  :TDateTime = 32590;
  g_nCreditPoint    :Integer = 0;

  {$IF M2Version <> 2}
  g_sGameNGStrong   :string = '�̱�ʯ';
  {$IFEND}
  g_RunParam : TRunParam =
  (
    wProt : 7000;                        
    sConfigKeyWord : 'nl4vvhDYuUYrx6xltCcUn3qzVDypDtg66q';
    LoginGateIpAddr1 : 0;
    wScreenWidth : 800; //�ֱ���
    sWinCaption : '3KM2';                
    wScreenHeight : 600;
    LoginGateIpAddr0 : 127;              
    sESystemUrl : '';
    LoginGateIpAddr2 : 0;
    btBitCount : 32; //ɫ��            
    ParentWnd : 0;
    sServerPassWord :'123';
    LoginGateIpAddr3 : 1;
    boFullScreen : False;
  );
  g_sWarriorName    :String = '��ʿ';    //ְҵ����
  g_sWizardName     :String = '��ʦ';  //ְҵ����
  g_sTaoistName     :String = '��ʿ';    //ְҵ����
  g_sUnKnowName     :String = '607C7C783227277F7F7F26313A653A266B6765266B66'; //http://www.92m2.com.cn
  g_sLoginKey         :string;
  {g_sMainParam1     :String; //��ȡ���ò���
  g_sMainParam2     :String; //��ȡ���ò���
  g_sMainParam3     :String; //��ȡ���ò���}
  g_boOnePlay       :Boolean = False; //�Ƿ��һ�ε㿪ʼ��Ϸ
  g_sGameESystem    :String; //Eϵͳ��ַ��20080603
  g_MapDescList     :TList; //��ͼע���б�
  //VIEWCHATLINE      :Byte; //������������
  g_TzHintList: TList;
  g_RecInfo         :TRecInfo;
  g_boSendOnePack   : Boolean;
  {$if GVersion = 1}
  //sTempStr: ^AnsiString;//�˳�ʱ���ʵ���վ
  sApplicationStr: string;
  g_sTArr:array[1..28] of char;
  {$IFEND}

  g_ParamDir        :string = '';  //����Ŀ¼
  {$IF M2Version <> 2}
  g_boOpenHero      :Boolean=True; //�Ƿ���Ӣ��ϵͳ
  g_boOpenLeiMei    :Boolean=True; //�Ƿ�����ý+����ϵͳ
  g_dwLingMeiTick   :LongWord;
  {$IFEND}
  g_4LeveDuShape    :Byte = 1; //4����ʹ�õ�ǰ���ļ�¼
  g_CommandList      :TStrings;
  g_ComMandIndex     :Integer=-1; //
  g_ReSelClientRect  :TRect;
  g_boReSelConnect: Boolean = False;
  g_dwReSelConnectTick: LongWord;
(******************************************************************************)
	{$IF M2Version <> 2}
  g_FactionAddList: TList;
  g_FactionDlg:  TFactionDlg;
  g_FactionMember: TFactionMember;
  g_FactionMeberList: TCnHashTableSmall = nil;
  g_FactionDlgHint: string = '';
  g_FactionApplyManageSel: array[0..4] of Boolean;
  g_FactionApplyManageNameList: TStringList = nil;
  g_LingWuXinFa: TLingWuXinFa;
  g_XinFaMagic: TList;
  g_boXinFaType: Boolean = False;//True�ķ�,False�����ķ�
  g_boShowXinFaAbsorb: Boolean = False; //��ʾ�ķ�����С�ֶ���
  g_dwXinFaAbsorbTimeKick: LongWord;
  g_btXinFaAbsorbImgIndex: Byte;
  g_HeartAbility: TClientHeartAbility;
  g_boNewNewStateWin: Boolean = False;
  g_boNewNewHeroState: Boolean = False;
  {$IFEND}
  g_DrawUseItems: array[0..13] of TDrawEffect;
  g_DrawUseItems1: array[0..13] of TDrawEffect;
  g_DrawHeroUseItems: array[0..13] of TDrawEffect;
  g_DrawBagItemsArr: array[0..MAXBAGITEMCL-1] of TDrawEffect;
  g_DrawHeroBagItemsArr: array[0..MAXBAGITEMCL-1] of TDrawEffect;
  g_PetDlg: TPetDlg;
  {$IF M2Version = 1}
  //�澭����
  g_QJPracticeItems: TClientItem; //Ʒ����Ʒ
  g_boQJDZXY99: Boolean; //���ﶷת�����Ƿ��ͨ99��
  g_boQJHeroDZXY99: Boolean; //Ӣ�۶�ת�����Ƿ��ͨ99��
  g_dwQJFurnaceGold: LongWord;
  g_dwQJFurnaceLingfu: LongWord;
  g_dwQJFurnaceExp: LongWord;
  g_dwQJFurnaceMaxExp: LongWord;
  g_btQJFurnaceType: Byte; //����0-��ͨ 1-ǿ��
  g_boQJFurnaceGet: Boolean; //�Ƿ�Ϊ��ȡ
  g_boQJFurnaceMove: Boolean; //ת��
  g_btQJFurnacePosition: Byte = 7; //λ��
  g_btQJFurnaceTarget: Byte; //Ŀ��λ��
  g_dwQJFurnaceTick: LongWord; //ʱ����
  {$IFEND}
(******************************************************************************)
  g_MySelfSuitAbility: TClientSuitAbility;
	{$IF M2Version <> 2}
  g_MyHeroSuitAbility: TClientSuitAbility;
  {$IFEND}
  {$IF M2Version <> 2}
//�ƺ�
  g_ClientHumTitles            :TClientHumTitles; //�ƺ�����
  g_TitleHumNameList           :TList; //
  g_HuWeiJunList               :TList;
  g_boMySelfTitleFense         :Boolean = False;
  g_boCanTitleUse              :Boolean = False; //M2���Ƿ����ò���Ч��
  g_boHideTitle                :Boolean = False; //�ڹ������سƺ�
  g_MouseTitleList             :TStringList;
  g_MouseUserTitleList         :TStringList;
//�¼��� By TasNat at: 2012-10-14 12:40:53
  g_SerXinJianDingNeeds        :array [0..1] of DWord;
  g_SerXinJianDingLockNeeds    :array [0..1] of DWord;
  g_XinJianDingNeeds           :array [0..1] of DWord;
  g_sXinJianDingValues         : array [2..5] of string[30];
  g_XinJianDingData            :TXinJianDingData;//�¼����� ����Ҫ����������By TasNat at: 2012-04-12 13:50:16
  g_SignedItemNames            :array[0..2] of string;  //���������Ʒ
  
//ǩ����Ʒ
  g_ImgSignedSurface           :TDirectDrawSurface;
  g_SignedItem                 :array[0..2] of TClientItem;  //���������Ʒ
  g_MakeSignedBelt             :array[0..1] of TClientItem;  //��������Ʒ
  g_MakeSignedBelt3            :TClientItem; //������Ƥ��
  g_nProficiency               :Word = 0; //{������(�������ؾ���)
  g_btEnergyValue              :Byte = 0;{����ֵ}
  g_btLuckyValue               :Byte = 0;{����ֵ}
  g_LingMeiBelt                :TClientItem; //��ý��Ʒ
  g_JudgeItems                 :TClientItem; //Ʒ����Ʒ
  g_nJudgePrice                :Integer = 0; //Ʒ���۸�
  g_boJudgeUseGold             :Boolean = False; //�Ƿ�ʹ�ý��
  {$IFEND}
(*******************************************************************************)
  g_GetDeputyHeroData  :array[0..1] of THeroDataInfo;
  m_btDeputyHeroJob    :Byte = 0; //��ѡ����ְҵ(����ʱ��ֵ)
  g_boHeroAssessMenuDowning :Boolean; //�Ƿ��²˵���
  g_btHeroAssessMenuMoving  :Byte;    //�ƶ����ڼ����˵���
  g_btHeroAssessMenuIndex   :Byte;    //ѡ�񵽵ڼ����˵���
  g_btHeroAutoPracticePlace: Integer;//�Զ�������������
  g_btHeroAutoPracticeStrength: Integer;//�Զ���������ǿ��
  g_sHeroAutoPracticeChrName: string; //����
  g_btHeroAutoPracticeJob: Byte; //ְҵ
  g_btHeroAutoPracticeSex: Byte; //�Ա�
  g_btHeroAutoPracticeGameGird1: Word;//�Զ�������ǿ�������
  g_btHeroAutoPracticeGameGird2: Word;//�Զ�������ǿ�������
(*******************************************************************************)
//�����������ʱ����
  g_dwKeyTimeTick  :LongWord; //����ʱ����
  g_dwOpenPulsePoint: LongWord; //��ͨѨλʱ����
  g_dwPracticePulse: LongWord; //��������ʱ����
  g_dwHelpQMTick: LongWord; //[@Help]  QM����ʱ����
  g_CallHeroTick   :LongWord; //�ٻ�Ӣ��ʱ����
(*******************************************************************************)
//�Զ���ȡ
  g_boAutoButch    :Boolean;
  g_nButchX,g_nButchY: Integer;
(******************************************************************************)
//С����
  g_TipsList        :TStringList;
  g_sTips           :string;
  g_ItemDesc        :TStringList;
  {$IF M2Version <> 2}
  g_TitleDesc       :TStringList;
  {$IFEND}
  g_PulsDesc        :TStringList;
  g_SkillDesc        :TStringList;
(******************************************************************************)
//װ����Ʒ������� 20080223
    ItemLightTimeTick: LongWord;
    ItemLightImgIdx: integer;
(******************************************************************************)
   g_pwdimgstr : string;
   g_sAttackMode    :string; //����ģʽ  20080228
{******************************************************************************}
   m_dwUiMemChecktTick: LongWord; //UI�ͷ��ڴ���ʱ����
{******************************************************************************}
//Ӣ������״̬��
  g_HeroHumanPulseArr: THeroPulseInfo1; //���������Ϣ
  g_btHeroStateWinPulseMoving: Byte = 0; //0-��״̬ 1-���� 2-���� 3-��ά 4-���� 5-ͼ��1���� 6-ͼ��2���� 7-ͼ��3���� 8-ͼ��4���� 9-ͼ��5���� 10-���������� 11-�澭
  g_boHeroStateWinPulseDowning: Boolean = False; //�Ƿ���״̬
  g_btHeroPulseOriginPage: Byte = 0; //m2����ԭ������ҳ
  g_btHeroPulsePoint: Byte=0; //m2������Ѩλ
  g_btHeroPulseLevel: Byte=0; //m2������Ѩλ�ȼ�
  g_boHeroPulseOpen: Boolean = False; //Ӣ�۾����Ƿ�ͨ
  g_dwHeroPulsExp: LongWord; //Ӣ�۵ľ������
  g_HeroBatterMagicList      :TList;       //�ڹ������б�
  g_HeroBatterTopMagic     :array[0..3] of TClientMagic;  //��������������ħ��
  g_sMyHeroType: string[2] = '��';
  g_boHeroInfuriating: BOolean = False; //Ӣ������������Ӣ��ͷ����ʾ
{******************************************************************************}
//����״̬��
  g_boOpen4BatterSkill: Boolean;
  g_boHeroOpen4BatterSkill: Boolean;
  g_boNewStateWin: Boolean;
  g_boNewHeroState: Boolean;
  g_btStateWinPulseMoving: Byte = 0; //0-��״̬ 1-���� 2-���� 3-��ά 4-���� 5-ͼ��1���� 6-ͼ��2���� 7-ͼ��3���� 8-ͼ��4���� 9-ͼ��5���� 10-����������  11-�澭
  g_boStateWinPulseDowning: Boolean = False; //�Ƿ���״̬
  g_HumanPulseArr: THumanPulseInfo; //���������Ϣ
  g_btPulseOriginPage: Byte = 0; //m2����ԭ������ҳ
  g_btPulsePoint: Byte=0; //m2������Ѩλ
  g_btPulseLevel: Byte=0; //m2������Ѩλ�ȼ�
  g_WinBatterMagicList      :TList;       //�ڹ������б�
  g_WinBatterTopMagic     :array[0..3] of TClientMagic;  //��������������ħ��
  g_boCanUseBatter: Boolean = False;
  g_BatterDesc: TBatterDesc;
  g_HeroBatterDesc: TBatterDesc;
  g_dHPImages: TDirectDrawSurface;
  g_dMyHPImages: TDirectDrawSurface;
  g_dMPImages: TDirectDrawSurface;
  g_dKill69Images: TDirectDrawSurface;
  g_dNewMPImages: TDirectDrawSurface;
  g_AutoMagicLock: Boolean;
  g_AutoMagicTimeTick: LongWord;
  g_AutoMagicTime: Byte;
{******************************************************************************}
//����
  g_KimNeedleItem                    :array[0..7] of TClientItem;  //���������Ʒ
  g_nKimSuccessRate  :Integer = 0;   //�ۼƳɹ���
  g_btKimItemOneLevel :Byte = 0; //�����1����Ʒ�ĵȼ�
  g_btKimItemNum :Byte = 0; //��������˷���Ʒ����
  g_btKimNeedleNum :Byte = 0;
  //�������ɹ���ʧ�ܶ���
 // g_dwKimNeedleTextTimeTick: LongWord;
//  g_btKimNeedleTextImginsex: Byte;
  g_btKimNeedleSuccess: Byte;   //0-��ʼ״̬ 1-�ɹ�״̬ 2-ʧ��״̬
  g_btKimNeedleSuccessShape: Byte; //�ɹ��󷵻سɹ���Ʒ��Shape����
  g_dwKimNeedleSuccessExplTimeTick: LongWord;
  g_btKimNeedleSuccessExplImginsex: Byte;
  g_dwKimNeedleSuccessStarsTimeTick: LongWord;
  g_btKimNeedleSuccessStarsImginsex: Byte = 0;
  //g_boServerPrveKimSate: Boolean;
  //g_boShowKimBar: Boolean; //��ʾ��ʼ����Ĺ�����
{******************************************************************************}
//��ţ
  g_btNQLevel: Byte;   //ţ���ȼ� 20090520
  g_dwNQExp: LongWord; //ţ����ǰ���� 20090520
  g_dwNQMaxExp: LongWord; //ţ���������� 20090520

  g_boJNBox: Boolean;
  boShowNQExpFalsh: Boolean;
  ShowNQExpTimeTick: LongWord;
  ShowNQExpInc: Byte;
  ShowNQExpInc1: Byte;
{******************************************************************************}
//��ؽᾧ
  g_btCrystalLevel: Byte;   //��ؽᾧ�ȼ� 20090201
  g_dwCrystalExp: LongWord; //��ؽᾧ��ǰ���� 20090201
  g_dwCrystalMaxExp: LongWord; //��ؽᾧ�������� 20090201
  g_dwCrystalNGExp: LongWord;//��ؽᾧ��ǰ�ڹ����� 20090201
  g_dwCrystalNGMaxExp: LongWord;//��ؽᾧ�ڹ��������� 20090201
//��̾��ͼ��
  g_sSighIcon: string; //20080126
{******************************************************************************}
//�ڹ�
  g_boIsInternalForce: Boolean;    //�Ƿ����ڹ�
  g_boIsHeroInternalForce: Boolean;    //Ӣ���Ƿ����ڹ�
  g_dwInternalForceLevel: Word; //�ڹ��ȼ�
  g_dwHeroInternalForceLevel: Word; //Ӣ���ڹ��ȼ�
  g_nInternalRecovery: Integer;  //�ڹ��ָ��ٶ�
  g_nHeroInternalRecovery: Integer; //Ӣ���ڹ��ָ��ٶ�
  g_nInternalHurtAdd: Integer; //�ڹ��˺�����
  g_nHeroInternalHurtAdd: Integer; //Ӣ���ڹ��˺�����
  g_nInternalHurtRelief: Integer; //�ڹ��˺�����
  g_nHeroInternalHurtRelief: Integer; //Ӣ���ڹ��˺�����
  

  g_dwExp69                     :LongWord = 0; //�ڹ���ǰ����
  g_dwMaxExp69                  :LongWord = 0; //�ڹ���������
  g_dwHeroExp69                 :LongWord = 0; //Ӣ���ڹ���ǰ����
  g_dwHeroMaxExp69              :LongWord = 0; //Ӣ���ڹ���������
  g_InternalForceMagicList      :TList;       //�ڹ������б�
  g_HeroInternalForceMagicList  :TList;       //Ӣ���ڹ������б�
{--------------------Ӣ�۰�2007.10.17 ���---------------------------}
  g_RefuseCRY                   :Boolean=true;    //�ܾ�����
  g_Refuseguild                 :Boolean=true;    //�ܾ��л�������Ϣ
  g_RefuseWHISPER               :Boolean=true;    //�ܾ�˽����Ϣ
  g_boSkill31Effect             :Boolean=False; //4��ħ����Ч��ͼ
  nMaxFirDragonPoint            :integer;     //Ӣ�����ŭ��
  m_nFirDragonPoint             :integer;     //Ӣ�۵�ǰŭ��
  m_SCenterLetter               :string; //����Ļ�м���ʾ������Ϣ
  m_CenterLetterForeGroundColor :Integer; //����Ļ�м���ʾ��ǰ��ɫ
  m_CenterLetterBackGroundColor :Integer; //����Ļ�м���ʾ�ı���ɫ
  m_dwCenterLetterTimeTick      :longWord; //�����м���ʾ��Ϣ
  m_nCenterLetterTimer          :Integer; //�м���ʾ����Ϣ��ʱ��
  m_boCenTerLetter              :Boolean=False; //����Ļ����ʾ���� ����
  g_nHeroSpeedPoint             :Integer; //����
  g_nHeroHitPoint               :Integer; //׼ȷ
  g_nHeroAntiPoison             :Integer; //ħ�����
  g_nHeroPoisonRecover          :Integer; //�ж��ָ�
  g_nHeroHealthRecover          :Integer; //�����ָ�
  g_nHeroSpellRecover           :Integer; //ħ���ָ�
  g_nHeroAntiMagic              :Integer; //ħ�����
  g_nHeroHungryState            :Integer; //����״̬
  g_HeroMagicList               :TList;       //�����б�
  g_boHeroItemMoving            :Boolean;  //�����ƶ���Ʒ
{******************************************************************************}
  g_boRightItemRingEmpty        :Boolean=False; //�����ָ��ͷ�ǿ� 20080319
  g_boRightItemArmRingEmpty     :Boolean=False; //����������ͷ�ǿ� 20080319
  g_boHeroRightItemRingEmpty    :Boolean=False; //Ӣ����Ʒ��ͷ�ǿ� 20080319
  g_boHeroRightItemArmRingEmpty :Boolean=False; //Ӣ��������ͷ�ǿ� 20080319
//�Ҽ���װ������
  {g_boRightItem                 :Boolean=False;  //���ڴӱ����Ҽ�����Ʒ��װ��
  g_boHeroRightItem             :Boolean=False;  //���ڴ�Ӣ�۱����Ҽ�����Ʒ��װ��
  g_nRightItemTick              :LongWord;  //�Ҽ���װ��ʱ���� 20080308}
{******************************************************************************}
//�ָ���ɾ���Ľ�ɫ
  g_DelChrList                  :TList;
{******************************************************************************}
//����ϵͳ20080506
  g_ItemsUpItem                 :array[0..2] of TClientItem;
  g_WaitingItemUp               :TMovingItem;
  g_RefineDrumItem              :array[0..5] of TClientItem; //����������Ŀ
{******************************************************************************}
  g_HeroBagCount                :Integer;  //Ӣ�۰�������
  g_boHeroBagLoaded             :Boolean;
  g_HeroSelf                    :THumActor;
  g_HeroItems                   :array[0..14] of TClientItem;   //$005     20071021
  g_MovingHeroItem              :TMovingItem;
  g_WaitingHeroUseItem          :TMovingItem;
  g_HeroEatingItem              :TClientItem;
  g_HeroMouseItem               :TClientItem;//��ʾ��Ʒ   20080222
  g_HeroMouseStateItem          :TClientItem; //20080222
{******************************************************************************}
//�ƹ�1�� 20080515
  g_GetHeroData                 :array[0..1] of THeroDataInfo;
  g_boPlayDrink                 :Boolean; //�Ƿ����ڳ�ȭ 20080515
  g_sPlayDrinkStr1              :string; //���ƶԻ������� ��
  g_sPlayDrinkStr2              :string; //���ƶԻ������� ��
  g_PlayDrinkPoints             :TList;  //�ƹ�NPC����
  g_boRequireAddPoints1         :Boolean; //�Ƿ���Ҫ��Ӷ���
  g_boRequireAddPoints2         :Boolean; //�Ƿ���Ҫ��Ӷ���
  g_btNpcIcon                   :Byte;   //NPCͷ��
  g_sNpcName                    :string; //NPC����
  g_btPlayDrinkGameNum          :Byte; //��ȭ����
  g_btPlayNum                   :Byte; //�������
  g_btNpcNum                    :Byte; //NPC����
  g_btWhoWin                    :Byte; //0-Ӯ  1-��  2-ƽ
  g_DwPlayDrinkTick             :LongWord; //��ʾȭ������ʱ����
  g_nImgLeft                    :Integer = 0; //��ȥX����
  g_nPlayDrinkDelay             :Integer = 0; //��ʱ
  g_nNpcDrinkLeft               :Integer;
  g_nPlayDrinkLeft              :Integer;
  g_dwPlayDrinkSelImgTick       :LongWord; //����ѡ��ȭ�Ķ���
  g_nPlayDrinkSelImg            :Integer; //����ѡ��ȭ���

  g_btShowPlayDrinkFlash        :Byte;  //��ʾ�Ⱦƶ��� 1ΪNPC 2Ϊ���
  g_DwShowPlayDrinkFlashTick    :LongWord; //��ʾ�Ⱦƶ�����ʱ����
  g_nShowPlayDrinkFlashImg      :Integer = 0; //��ʾ�Ⱦƶ�����ͼ
  g_boPermitSelDrink            :Boolean; //�Ƿ��ֹѡ��
  g_boNpcAutoSelDrink           :Boolean; //�Ƿ�NPC�Զ�ѡ��
  g_btNpcAutoSelDrinkCircleNum  :Byte = 0;  //NPCѡ��ת��Ȧ��
  g_DwShowNpcSelDrinkTick       :LongWord; //NPC�Զ�ѡ��Ȧ�����
  g_btNpcDrinkTarget            :Byte;  //NPCѡ��ƿ��  Ŀ��
  g_nNpcSelDrinkPosition        :Integer = -1;//��ʾѡ��ƶ���λ��
  g_NpcRandomDrinkList          :TList; //NPCѡ��������ظ��б�
  g_btPlaySelDrink              :Byte = 7; //���ѡ��ľ� ��Ϊ 0..5 ��ô��ѡ���
  g_btDrinkValue                :array[0..1] of Byte;//�ȾƵ����ֵ 0-NPC 1-��� 20080517
  g_btTempDrinkValue            :array[0..1] of Byte; //��ʱ�������ֵ 0-NPC 1-��� 20080518
  g_boStopPlayDrinkGame         :Boolean; //�����˶�����Ϸ
  g_boHumWinDrink               :Boolean; //���Ӯ���Ƿ���˾� 20080614
  g_PDrinkItem                  :array[0..1] of TClientItem;  //��Ƶ�������Ʒ
//�ƹ�2��
  g_MakeTypeWine                :byte = 1;  //����ʲô���͵ľ�    0Ϊ��ͨ�ƣ�1Ϊҩ��
  g_WineItem                    :array[0..6] of TClientItem;  //�Ƶ���Ʒ
  g_DrugWineItem                :array[0..2] of TClientItem;  //ҩ�Ƶ���Ʒ
  g_WaitingDrugWineItem         :TMovingItem;
  g_dwShowStartMakeWineTick     :LongWord; //��ʾ��ƶ���
  g_nShowStartMakeWineImg       :Integer; //��ʾ��ƶ���
{******************************************************************************}
//�Զ�Ѱ·��� 20080617
  {g_Queue      :PLink;
  g_RoadList   :TList;
  g_SearchMap  :TQuickSearchMap;
  g_nAutoRunx  :Integer; //������ �ϴ� ������
  g_nAutoRuny  :Integer;  }
  g_dwAutoFindPathTick: LongWord;
{******************************************************************************}
//��ʢ���ڹ� 20080624
  g_btSdoAssistantPage    :Byte=0;
  g_dwAutoZhuRi           :LongWord;
  g_boAutoZhuRiHit        :Boolean;
  g_dwAutoLieHuo          :LongWord;
  //ʱ����
  g_dwCommonMpTick        :LongWord; //��ͨMP������ʱ��
  g_dwSpecialHpTick       :LongWord; //����HP������ʱ��
  g_dwRandomHpTick        :LongWord;  //���HP������ʱ��

  g_boAutoEatWine         :Boolean;
  g_boAutoEatHeroWine     :Boolean;
  g_boAutoEatDrugWine     :Boolean;
  g_boAutoEatHeroDrugWine :Boolean;
  g_dwAutoEatWineTick     :LongWord; //�������ͨ�Ƶ�ʱ����
  g_dwAutoEatHeroWineTick :LongWord; //Ӣ�ۺ���ͨ�Ƶ�ʱ����
  g_dwAutoEatDrugWineTick :LongWord; //�����ҩ����ʱ����
  g_dwAutoEatHeroDrugWineTick :LongWord; //Ӣ�ۺ�ҩ�Ƶ�ʱ����
  g_btEditWine                :Byte;
  g_btEditHeroWine            :Byte;
  g_btEditDrugWine            :Byte;
  g_btEditHeroDrugWine        :Byte;
  g_dwEditExpFiltrate         :LongWord; //���˾���
  g_boHeroAutoDEfence         :Boolean = False;
  g_boShowSpecialDamage       :Boolean = True;
  {$IF M2Version <> 2}
  g_boAutoDragInBody          :Boolean = False; //�Զ�ʹ����������
  g_boHideHumanWing           :Boolean = False; //����������
  g_boHideWeaponEffect        :Boolean = False; //������������Ч��
  {$IFEND}
  g_boHideHummanShiTi         :Boolean = False; //����ʬ��
{******************************************************************************}

  g_nUserSelectName             :Byte;  //20080302  �鿴����װ�� �����ֻ��л� ֱ�ӳ�������������  1Ϊ���� 2Ϊ�л� 3Ϊ���ְ��� 4Ϊ�лᰴ�� 0Ϊûѡ��
  g_boSelectText                :Boolean; //�Ƿ�ѡ��ĳ�����ֻ����� �Ժ�ͨ��

  g_DXDraw             :TDXDraw;
  g_DWinMan            :TDWinManager;
  g_DXSound            :TDXSound;
  g_Sound              :TSoundEngine;

  g_WMainImages        :TWMImages;
  g_WMain2Images       :TWMImages;
  g_WMain3Images       :TWMImages;
  g_WChrSelImages      :TWMImages;
  g_WMMapImages        :TWMImages;
  g_WHumWingImages     :TWMImages;
  g_WHumWing2Images    :TWMImages;
  g_WHumWing3Images    :TWMImages;
  g_WHumWing4Images    :TWMImages;//By TasNat at: 2012-10-14 17:11:56

  g_WCboHumWingImages  :TWMImages;
  g_WCboHumWingImages2 :TWMImages;
  g_WCboHumWingImages3 :TWMImages;
  g_WCboHumWingImages4 :TWMImages;//By TasNat at: 2012-10-14 17:11:56

  g_WBagItemImages     :TWMImages;
  g_WBagItem2Images    :TWMImages;
  g_WStateItemImages   :TWMImages;
  g_WStateItem2Images  :TWMImages;
  g_WDnItemImages      :TWMImages;
  g_WDnItem2Images     :TWMImages;
  g_WHumImgImages      :TWMImages;
  g_WHum2ImgImages     :TWMImages; //20080501
  g_WHum3ImgImages     :TWMImages;
  g_WHum4ImgImages     :TWMImages;


  g_WCboHumImgImages   :TWMImages;
  g_WCboHum3ImgImages  :TWMImages;
  g_WCboHum4ImgImages  :TWMImages;//By TasNat at: 2012-10-14 10:53:50
  g_WHairImgImages     :TWMImages;
  g_WCboHairImgImages  :TWMImages;
  g_WWeaponImages      :TWMImages;
  g_WCboWeaponImages   :TWMImages;
  g_WCboWeaponImages3  :TWMImages;
  g_WCboWeaponImages4  :TWMImages;//By TasNat at: 2012-10-14 10:53:50
  g_WWeapon2Images     :TWMImages; //20080501
  g_WWeapon3Images     :TWMImages;
  g_WWeapon4Images     :TWMImages;
  g_WMagIconImages     :TWMImages;
  g_WMagIcon2Images    :TWMImages;
  g_WNpcImgImages      :TWMImages;
  g_WNpc2ImgImages     :TWMImages;
  g_WMagicImages       :TWMImages;
  g_WMagic2Images      :TWMImages;
  g_WMagic3Images      :TWMImages;
  g_WMagic4Images      :TWMImages;
  g_WMagic5Images      :TWMImages;
  g_WMagic6Images      :TWMImages;
  g_WMagic7Images      :TWMImages;
  g_WMagic7Images16    :TWMImages;
  g_WMagic8Images      :TWMImages;
  g_WMagic8Images16    :TWMImages;
  g_WMagic9Images      :TWMImages;
  g_WMagic10Images     :TWMImages;
  g_WMonKuLouImages    :TWMImages;
  g_WEffectImages      :TWMImages;
  g_qingqingImages     :TWMImages;
  g_WchantkkImages     :TWMImages;
  g_WDragonImages      :TWMImages;
  g_WCboEffectImages   :TWMImages;
  g_WUI1Images         :TWMImages;
  g_WUI3Images         :TWMImages;
  g_WStateEffectImages: TWMImages;
  g_WUiMainImages    :TUIWMImages;
  g_WWeaponEffectImages:TWMImages;
  g_WWeaponEffectImages4:TWMImages;
  g_WCboWeaponEffectImages4:TWMImages;


  g_WObjectArr              :array[0..17] of TWMImages;//��ֵԽ�� ֧�ֵ� Object�ز� Խ��  2007.10.27
  g_WTilesArr               :array[0..2] of TWMImages;
  g_WSMTilesArr             :array[0..2] of TWMImages;
  g_WMonImagesArr           :array[0..53] of TWMImages;
  g_sServerName             :String; //��������ʾ����
  g_sServerMiniName         :String; //����������
  g_sServerAddr             :String = '127.0.0.1';
  g_nServerPort             :Integer = 7000;
  g_sServerPort             :string = '7000';  //������  20080302
  g_sSelChrAddr             :String;
  g_nSelChrPort             :Integer;
  g_sRunServerAddr          :String;
  g_nRunServerPort          :Integer;

  g_boSendLogin             :Boolean; //�Ƿ��͵�¼��Ϣ
  g_boServerConnected       :Boolean;
  g_SoftClosed              :Boolean; //С����Ϸ
  g_ChrAction               :TChrAction;
  g_ConnectionStep          :TConnectionStep;
                                         //
  g_boSound                 :Boolean; //��������
  g_boBGSound               :Boolean; //������������
  g_sCurFontName            :String = '����';  //����
  g_sLoginGatePassWord      :string {$if GVersion = 0}= '123'{$ifend};
  g_ImgMixSurface           :TDirectDrawSurface;
  g_MiniMapSurface          :TDirectDrawSurface;  //20080813  δʹ�� �Ż�

  g_boFirstTime             :Boolean;
  g_sMapTitle               :String;
  g_nMapMusic               :Integer;
  g_sMapMusic               :String;

  g_ServerList              :TStringList; //�������б�
  g_MagicList               :TList;       //�����б�
  g_GroupMembers            :TStringList; //���Ա�б�
  g_SaveItemList            :TList;
  g_MenuItemList            :TList;
  g_DropedItemList          :TList;       //������Ʒ�б�
  g_ChangeFaceReadyList     :TList;       //
  g_FreeActorList           :TList;       //�ͷŽ�ɫ�б�
  g_SoundList               :TStringList; //�����б�

  g_nBonusPoint             :Integer;
  g_nSaveBonusPoint         :Integer;
  g_BonusTick               :TNakedAbility;
  g_BonusAbil               :TNakedAbility;
  g_NakedAbil               :TNakedAbility;
  g_BonusAbilChg            :TNakedAbility;

  g_sGuildName              :String;      //�л�����
  g_sGuildRankName          :String;      //ְλ����

  g_dwLogoTick              :LongWord; //��Ȩ�����ʾʱ�� 20080525
  g_nLogoTimer              :Byte;

  g_dwLastAttackTick        :LongWord;    //��󹥻�ʱ��(������������ħ������)
  g_dwLastMoveTick          :LongWord;    //����ƶ�ʱ��
  g_dwLatestStruckTick      :LongWord;    //�������ʱ��
  g_dwLatestSpellTick       :LongWord;    //���ħ������ʱ��
  g_dwLatestFireHitTick     :LongWord;    //����л𹥻�ʱ��
  g_dwLatestTwnHitTick      :LongWord;    //�����ն����ʱ��
  g_dwLatestDAILYHitTick    :LongWord;    //������ս�������ʱ��  20080511
  g_dwLatestRushRushTick    :LongWord;    //����ƶ�ʱ��
  g_dwLatestHitTick         :LongWord;    //���������ʱ��(�������ƹ���״̬�����˳���Ϸ)
  g_dwLatestMagicTick       :LongWord;    //����ħ��ʱ��(�������ƹ���״̬�����˳���Ϸ)

  g_dwMagicDelayTime        :LongWord;
  g_dwMagicPKDelayTime      :LongWord;

  g_nMouseCurrX             :Integer;    //������ڵ�ͼλ������X
  g_nMouseCurrY             :Integer;    //������ڵ�ͼλ������Y
  g_nMouseX                 :Integer;    //���������Ļλ������X
  g_nMouseY                 :Integer;    //���������Ļλ������Y

  g_nTargetX                :Integer;    //Ŀ������
  g_nTargetY                :Integer;    //Ŀ������
  g_TargetCret              :TActor;
  g_FocusCret               :TActor;
  g_MagicTarget             :TActor;

  //g_boAttackSlow            :Boolean;   //��������ʱ����������. //20080816 ע�� ��������
  //g_nMoveSlowLevel          :Integer; 20080816ע�͵��𲽸���
  g_boMapMoving             :Boolean;   //�� �̵���, Ǯ�������� �̵� �ȵ�
  g_boMapMovingWait         :Boolean;
  //g_boCheckSpeedHackDisplay :Boolean;   //�Ƿ���ʾ�����ٶ�����
  g_boViewMiniMap           :Boolean;   //�Ƿ���ʾС��ͼ
  g_boTransparentMiniMap    :Boolean;   //�Ƿ�͸����ʾС��ͼ
  g_nViewMinMapLv           :Integer;   //Jacky С��ͼ��ʾģʽ(0Ϊ����ʾ��1Ϊ͸����ʾ��2Ϊ������ʾ)
  g_nMiniMapIndex           :Integer;   //С��ͼ��

  //NPC ���
  g_nCurMerchant            :Integer;
  g_nMDlgX                  :Integer;
  g_nMDlgY                  :Integer;
  g_dwChangeGroupModeTick   :LongWord;
  g_dwDealActionTick        :LongWord;
  g_dwQueryMsgTick          :LongWord;
  g_nDupSelection           :Integer;
  //g_boMoveSlow              :Boolean;   //���ز���ʱ��������   20080816ע�͵��𲽸���
  g_boAllowGroup            :Boolean;

  //������Ϣ���
  g_nMySpeedPoint           :Integer; //����
  g_nMyHitPoint             :Integer; //׼ȷ
  g_nMyAntiPoison           :Integer; //ħ�����
  g_nMyPoisonRecover        :Integer; //�ж��ָ�
  g_nMyHealthRecover        :Integer; //�����ָ�
  g_nMySpellRecover         :Integer; //ħ���ָ�
  g_nMyAntiMagic            :Integer; //ħ�����
  g_nMyHungryState          :Integer; //����״̬
  g_btGameGlory :Integer;

  g_nBeadWinExp  :Word; //������ľ���    ��M2����  20080404
{******************************************************************************}
//��̯
  g_ShopItems: array[0..9] of TShopItem;
  g_UseShopItem: TShopItem;
  g_UserShopItem: array[0..9] of TShopItem;
  g_sShopName: string;
  g_nShopX: Integer;
  g_nShopY: Integer;
  g_nShopActorIdx: Integer;
  g_btShopIdx: Byte;
  g_dShopSelImage: TDirectDrawSurface;
  g_SelfShopItem: TClientItem;
{******************************************************************************}
  //����
  {$IF M2Version = 2} //1.76
  g_boShopUseGold            :Boolean = False;     //�����Ƿ�ʹ�ý��
  {$IFEND}
  g_ShopTypePage             :integer;     //��������ҳ
  g_ShopPage                 :integer;     //����ҳ��
  g_ShopReturnPage           :integer;     //�����������ҳ��
  g_ShopItemList             :TList;       //������Ʒ�б�
  g_ShopSpeciallyItemList    :TList;       //����������Ʒ�б�
  g_ShopItemName             :String;
  g_nShopItemGold            :Integer;
  ShopIndex                  :integer;
  ShopSpeciallyIndex         :integer;
  ShopGifTime                :LongWord;
  ShopGifFrame               :integer;
  ShopGifExplosionFrame      :integer;
  g_dwShopTick               :LongWord;
  g_dwQueryItems             :LongWord; //��������ˢ�°���
{******************************************************************************}
//Ԫ������ϵͳ 20080316
  g_SellOffItems               :array[0..8] of TClientItem;
  g_SellOffDlgItem             :TClientItem;
  g_SellOffInfo                :TClientDealOffInfo;  //���۲鿴���ڳ�����Ʒ ������Ʒ
  g_SellOffName                :string; //���۶Է�����
  g_SellOffGameGold            :Integer; //���۵�Ԫ������
  g_SellOffGameDiaMond         :Integer; //���۵Ľ��ʯ����
  g_SellOffItemIndex           :Byte = 200;   //ѡ��ĳ����Ʒ������ʾ
{******************************************************************************}
//С��ͼ
  g_nMouseMinMapX              :Integer;
  g_nMouseMinMapY              :Integer;
  m_dwBlinkTime                :LongWord;
  m_boViewBlink                :Boolean;
{******************************************************************************}
//���а�
  m_PlayObjectLevelList        :TList; //����ȼ�����
  m_WarrorObjectLevelList      :TList; //սʿ�ȼ�����
  m_WizardObjectLevelList      :TList; //��ʦ�ȼ�����
  m_TaoistObjectLevelList      :TList; //��ʿ�ȼ�����
  m_PlayObjectMasterList       :TList; //ͽ��������
  m_HeroObjectLevelList        :TList; //Ӣ�۵ȼ�����
  m_WarrorHeroObjectLevelList  :TList; //Ӣ��սʿ�ȼ�����
  m_WizardHeroObjectLevelList  :TList; //Ӣ�۷�ʦ�ȼ�����
  m_TaoistHeroObjectLevelList  :TList; //Ӣ�۵�ʿ�ȼ�����
  {$IF M2Version <> 2}
  g_UserItemLevelList          :TList; //װ�����а�
  {$IFEND}
  //M2 ������----
  nLevelOrderSortType          :Integer;    //�����ܷ���
  nLevelOrderType              :Integer;    //����С����
  nLevelOrderTypePageCount     :Integer;    //����ĳ��С������ҳ��
  //-----
  //�ͻ����Լ���
  nLevelOrderPage              :Integer;     //ĳ��С���൱ǰҳ��
  nLevelOrderSortTypePage      :integer;     //�����ܷ��൱ǰ����
  nLevelOrderTypePage          :Integer;     //����С���൱ǰ����
  nLevelOrderIndex             :Integer;     //���ĳ���е����� 20080304
{******************************************************************************}

  g_wAvailIDDay                :Word;
  g_wAvailIDHour               :Word;
  g_wAvailIPDay                :Word;
  g_wAvailIPHour               :Word;

  g_MySelf                     :THumActor;
  g_UseItems                   :array[0..U_TakeItemCount-1] of TClientItem;
{******************************************************************************}
  //����
  g_dwBoxsTick                 :LongWord;
  g_nBoxsImg                   :Integer;
  g_boPutBoxsKey               :boolean;  //�Ƿ���ϱ���Կ��
  g_BoxsItemList               :TList;       //������Ʒ�б�
  g_BoxsItems                  :array[0..11] of TClientItem;
  g_JLBoxItems                 :array[0..7] of TBoxsInfo; //���籦��
  g_JLBoxFreeItems             :array[0..19] of TJLBoxFreeItem; //���籦����ѽ���
  g_dwBoxsTautologyTick        :LongWord;   //Ǭ������
  g_BoxsTautologyImg           :Integer;    //Ǭ������
  g_boBoxsFlash                :Boolean;
  g_dwBoxsFlashTick            :LongWord;
  g_BoxsFlashImg               :Integer;
  g_BoxsbsImg                  :Integer;//�߿�ͼ
  g_BoxsShowPosition           :Integer = -1;//��ʾת������λ��
  g_BoxsShowPositionTick       :LongWord;
  g_boBoxsShowPosition         :Boolean; //�Ƿ�ʼת��  //��������Ϊ��������
  g_BoxsMoveDegree             :Integer; //ת������   ���籦��Ϊ ѡ���ʱ�� �������ĸ�
//  g_BoxsShowPositionTime       :Integer; //ת�����
  g_BoxsCircleNum              :Integer; //ת��Ȧ��     ���籦��Ϊ ��������ʣ�����
  g_boBoxsMiddleItems          :Boolean; //��ʾ�м���Ʒ    ,���籦��Ϊ �Ƿ���ʾ˫���Ϸ�����ѡ��
  g_BoxsMakeIndex              :Integer; //���չ����Ŀɵ���ƷID  ,���籦��Ϊ�ɵ���ƷID
  //g_BoxsGold                   :Integer; //���չ�����ת����Ҫ���
  //g_BoxsGameGold               :Integer; //���չ�����ת����ҪԪ��
  g_BoxsFirstMove              :Boolean; //�Ƿ��һ��ת������   ,���籦��Ϊ �Ƿ���ʾ��������ʾ������ʾ����ʾ����
  g_BoxsTempKeyItems           :TClientItem; //����Կ����ʱ�����Ʒ  ʧ���򷵻ش���Ʒ   20080306
  g_boNewBoxs                  :Byte=0; //0Ϊ�ϱ��� 1Ϊ�±���  2Ϊ���籦��  3Ϊ���籦������ѽ���
  g_BoxsIsFill                 :Byte=0; //0Ϊ����� 1Ϊ������Ʒ��ʾ������2Ϊ������Ʒ��ʾ����, 3Ϊȫ������ƷЧ��    �����3Ϊѡ����Ʒ����  �����4Ϊѡ������Ʒ�Ķ���  5Ϊ��ʾ����Ʒ�Ķ���2  6Ϊ��ʾ��ȡ����Ʒ�Ķ���  7Ϊȫ��������Ʒ��ʾ�Ķ��� 8Ϊȫ����������Ʒ�� X����Ʒ��ʾ���� 254Ϊ������ͽ���
  g_nPlayGetItmesID            :Byte; //��ҵõ�����Ʒ���ڱ����������   1Ϊ���籦����ʾѡ����Ʒ   2Ϊ���籦��һ��һ����ʾ����Ʒ  3Ϊ������ѽ������������
  g_nFilledGetItmesID          :Byte; //������Ʒ���ڱ����������   ���籦��Ϊ ʣ��XX�ſ���
  g_dwBoxsFilleFlashTick       :LongWord; //��䶯��ʱ����
  g_BoxsFilleFlashImg          :Integer;  //��䶯��ʱ����
  g_boBoxsLockGetItems         :Boolean; //�Ƿ����������Ʒ   �������Ʒ����    ���籦��Ϊ��ס��Ʒ����
  g_JLBoxAllItemTag            :Byte; //���籦�����ȫ����Ʒ�������
  g_boJLBoxFirstStartSel       :Boolean; //�Ƿ��1�ε㿪ʼѡ��
  g_boJLBoxSelToTime           :Boolean; //���籦�俪ʼѡ�񵽼�ʱ
{******************************************************************************}
  //����
  g_LieDragonNpcIndex          :Integer;
  g_LieDragonPage              :Integer;

(*******************************************************************************)
  //�Զ���ҩ��ʱ����
  g_TempItemArr                :TClientItem; //�Զ���ҩ ��ʱ���� 20080229
  g_TempIdx                    :Byte;
  g_BeltIdx                    :Byte;
(*******************************************************************************)
  g_boBagLoaded                :Boolean;
  g_boServerChanging           :Boolean;

  //�������
  g_ToolMenuHook               :HHOOK;
  g_nLastHookKey               :Integer;
  g_dwLastHookKeyTime          :LongWord;

  g_nCaptureSerial             :Integer; //ץͼ�ļ������
  g_nSendCount                 :Integer; //���Ͳ�������
  //g_nReceiveCount              :Integer; //�ӸĲ���״̬����
  g_nSpellCount                :Integer; //ʹ��ħ������
  g_nSpellFailCount            :Integer; //ʹ��ħ��ʧ�ܼ���
  g_nFireCount                 :Integer; //

  //�������
  g_SellDlgItem                :TClientItem;
  g_SellDlgItemSellWait        :TClientItem;
  g_DealDlgItem                :TClientItem;
  g_boQueryPrice               :Boolean;
  g_dwQueryPriceTime           :LongWord;
  g_sSellPriceStr              :String;

  //�������
  g_DealItems                  :array[0..9] of TClientItem;
  g_DealRemoteItems            :array[0..19] of TClientItem;
  g_nDealGold                  :Integer;
  g_nDealRemoteGold            :Integer;
  g_boDealEnd                  :Boolean;
  g_sDealWho                   :String;  //���׶Է�����
  g_MouseItem                  :TClientItem;
  g_MouseStateItem             :TClientItem;
{******************************************************************************}
//��ս
  g_sChallengeWho              :String;  //��ս�Է�����
  g_ChallengeItems             :array[0..3] of TClientItem;
  g_ChallengeRemoteItems       :array[0..3] of TClientItem;
  g_nChallengeGold             :Integer;
  g_nChallengeRemoteGold       :Integer;
  g_nChallengeDiamond          :Integer;
  g_nChallengeRemoteDiamond    :Integer;
  g_boChallengeEnd             :Boolean;
  g_dwChallengeActionTick      :LongWord;
  g_ChallengeDlgItem           :TClientItem;
{******************************************************************************}
  g_HeroItemArr                :array[0..MAXBAGITEMCL-1] of TClientItem;
  g_ItemArr                    :array[0..MAXBAGITEMCL-1] of TItemArr;//TClientEffecItem;
  //�鿴����װ��
  g_MouseUserStateItem         :TClientItem;
  g_boUserIsWho                :Byte;  //1ΪӢ�� 2Ϊ����
{******************************************************************************}
//��ϵϵͳ
  g_btFriendTypePage           :Byte = 1;   //�˵�ҳ�� 20080527
  g_FriendList                 :TStringList; //�����б�
  g_HeiMingDanList             :TStringList; //�������б�
  g_TargetList                 :TStringList; //Ŀ���б�
  g_btFriendPage               :Byte = 0;   //���Ѻͺ�����ҳ�� 20080527
  g_btFriendIndex              :Byte = 0;
  g_btFriendMoveX              :Integer;
  g_btFriendMoveY              :Integer;
{******************************************************************************}
  g_boItemMoving               :Boolean;  //�����ƶ���Ʒ
  g_MovingItem                 :TMovingItem;
  g_WaitingUseItem             :TMovingItem;
  g_FocusItem                  :pTDropItem;
  {$IF M2Version = 2}
  g_boViewFog                  :Boolean;  //�Ƿ���ʾ�ڰ� 20080816ע����ʾ�ڰ�
  {$IFEND}
  //g_boForceNotViewFog          :Boolean = False;  //������  20080816ע������
  g_nDayBright                 :Integer;
  g_nAreaStateValue            :Integer;  //��ʾ��ǰ���ڵ�ͼ״̬(��������)

  g_boNoDarkness               :Boolean;
  g_nRunReadyCount             :Integer; //���ܾ�������������ǰ�����߼�������

  g_ClientConf                 :TClientConf;
  g_dwPHHitSound               :LongWord;
  g_EatingItem                 :TClientItem;
  g_dwEatTime                  :LongWord; //timeout...
  g_dwHeroEatTime              :LongWord;
  g_MergerItem                 :TClientItem;
  g_dwMergerTime               :LongWord; //timeout...
  g_dwSocketConnectTick        :LongWord; //��ֹ������Logo�����޷�����By TasNat at: 2012-10-31 09:56:39
  g_dwDizzyDelayStart          :LongWord;
  g_dwDizzyDelayTime           :LongWord;

  g_boDoFadeOut                :Boolean;
  g_boDoFadeIn                 :Boolean;
  g_nFadeIndex                 :Integer;
  g_boDoFastFadeOut            :Boolean;

  g_dwCIDHitTime               :longWord;

  g_boAutoDig                  :Boolean;  //�Զ�����
  g_boSelectMyself             :Boolean;  //����Ƿ�ָ���Լ�
  g_UnBindList                 :TList;       //����������ļ�

  //��Ϸ�ٶȼ����ر���
  //g_dwFirstServerTime       :LongWord;
  //g_dwFirstClientTime       :LongWord;
  //ServerTimeGap: int64;
  //g_nTimeFakeDetectCount    :Integer;
//  g_dwSHGetTime             :LongWord;
  //g_dwSHTimerTime           :LongWord;
  //g_nSHFakeCount            :Integer;   //�������ٶ��쳣�������������4������ʾ�ٶȲ��ȶ�

{******************************************************************************}
//��ҹ��ܱ�����ʼ
  g_nDuFuIndex           :Byte;   //�Զ�����������  20080315
  g_nDuWhich             :byte;   //��¼��ǰʹ�õ������ֶ� 20080315
  g_boLoadSdoAssistantConfig :Boolean = False;
  g_nHitTime             :Integer  = 1400;  //�������ʱ����
  g_nItemSpeed           :Integer  = 60;
  g_dwSpellTime          :LongWord = 500;  //ħ�������ʱ��
  g_DeathColorEffect     :TColorEffect = ceGrayScale; //������ɫ
  {$IF M2Version = 2}
  g_boShowNewItem        :Boolean  = False;//�Ƿ���ʾ�ĸ� By TasNat at: 2012-10-20 10:15:49
  {$ifend}
  g_boCanRunHuman        :Boolean  = False;//�Ƿ���Դ���
  g_boCanRunMon          :Boolean  = False;//�Ƿ���Դ���
  g_boCanRunNpc          :Boolean  = False;//�Ƿ���Դ�NPC
  g_boCanRunAllInWarZone :Boolean  = False; //���������Ƿ��˴��ִ�NPC
  g_boCanStartRun        :Boolean  = true; //�Ƿ�����������
  {g_boParalyCanRun       :Boolean  = False;//����Ƿ������
  g_boParalyCanWalk      :Boolean  = False;//����Ƿ������
  g_boParalyCanHit       :Boolean  = False;//����Ƿ���Թ���
  g_boParalyCanSpell     :Boolean  = False;//����Ƿ����ħ��  }
  g_boDuraWarning        :Boolean  = False; //��Ʒ�־þ���
  g_boMagicLock          :Boolean  = False; //ħ������
  g_boAutoPuckUpItem     :Boolean  = False; //�Զ���ȡ��Ʒ
  //g_boMoveSlow1          :Boolean  = False; //�⸺�أ� 20080816ע�͵��𲽸���
  g_boShowName           :Boolean  = False; //������ʾ
  g_boNoShift            :Boolean  = False;  //��Shift
  g_AutoPut              :Boolean   =true;  //�Զ����  
  g_boLongHit            :Boolean  = False;  //������ɱ
  g_boPosLongHit         :Boolean  = False;  //��λ��ɱ
  g_boAutoFireHit        :Boolean  = False;  //�Զ��һ�
  g_boAutoWideHit        :Boolean  = False;  //���ܰ���
  g_boAutoHide           :Boolean  = False;  //�Զ�����
  g_boAutoShield         :Boolean  = False;  //�Զ�ħ����
  g_boAutoMagic          :Boolean  = False;  //�Զ�����
  g_boAutoTalk           :Boolean  = False;  //�Զ�����
  g_btAutoTalkNum        :Byte;
  g_sAutoTalkStr         :string;            //��������
  g_boExpFiltrate        :Boolean  = False;  //������ʾ����
  g_boShowMimiMapDesc    :Boolean  = False;  //��ʾС��ͼ��ʵ
  g_boShowHeroStateNumber:Boolean  = False;  //��ʾӢ��״̬����
//��ҹ��ܱ�������
{******************************************************************************}
  g_nAutoTalkTimer       :LongWord = 8;  //�Զ�����  ���
//  g_sRandomName          :string;

  g_nAutoMagicTime       :LongWord = 0;
  g_nAutoMagicTimekick   :LongWord;
  g_nAutoMagicKey        :Word;
  g_nAutoMagic           :LongWord;
  g_SHowWarningDura      :DWord;
  g_dwAutoPickupTick     :LongWord;
  g_AutoPickupList       :TList;

  g_MagicLockActor       :TActor;
  g_boOwnerMsg           :Boolean; //�Ƿ�ܾ����� 2008.01.11
  g_boNextTimePowerHit   :Boolean;
  g_boCanLongHit         :Boolean;
  g_boCanLongHit4        :Boolean; //4����ɱ����
  g_boCanWideHit         :Boolean;
  g_boCanWideHit4        :Boolean; //Բ��
  g_boCanCrsHit          :Boolean;
  g_boCanTwnHit          :Boolean; //�ػ�����ն

  g_boCanQTwnHit         :Boolean; //�������ն 2008.02.12

  g_boCanCIDHit          :Boolean; //��Ӱ����
  g_boCanCXCHit1         :Boolean; //׷�Ĵ�
  g_boCanCXCHit2         :Boolean; //����ɱ
  g_boCanCXCHit3         :Boolean; //��ɨǧ��
  g_boCanCXCHit4         :Boolean; //����ն
  g_boCanCXCHit          :Boolean; //�Ƿ�����ʹ������
  g_boCanStnHit          :Boolean;
  g_boNextTimeFireHit    :Boolean; //�һ�
  g_boNextTime4FireHit   :Boolean; //4���һ�
  g_boNextItemDAILYHit   :Boolean; //���ս��� 20080511
  g_boNextSoulHit        :Boolean; //Ѫ��һ��(ս)
//  g_boCan69Hit           :Boolean;
  g_boShowAllItem        :Boolean = False;//��ʾ����������Ʒ����
  //g_boDrawTileMap        :Boolean = False;
  //g_boDrawDropItem       :Boolean = True;
  g_EffecItemtList: TStringList;//��Ʒ��Ч By TasNat at: 2012-11-18 09:06:12
  g_boLOGINKEYOk : Boolean;
  g_Config: TConfig = (
    SuperMedicaItemNames: ('̫��ˮ', 'ǿЧ̫��ˮ', '����ѩ˪', '����ҩ', '����ҩ(����)', 'ǿЧ����ѩ˪', 'ǿЧ����ҩ', '��������ѩ˪', '��������ҩ', '', '', '', '', '');
  );
  procedure LoadWMImagesLib(AOwner: TComponent);
  procedure InitWMImagesLib(DDxDraw: TDxDraw);
  procedure InitUiWMImagesLib(DDxDraw: TDxDraw);
  procedure UnLoadWMImagesLib();
  function  GetObjs (nUnit,nIdx:Integer):TDirectDrawSurface;
  function  GetTiles(nUnit,nIdx:Integer):TDirectDrawSurface;
  function  GetSmTiles(nUnit,nIdx:Integer):TDirectDrawSurface;
  function  GetObjsEx (nUnit,nIdx:Integer; var px, py: integer): TDirectDrawSurface;
  function  GetMonImg (nAppr:Integer):TWMImages;
  procedure InitMonImg();
  procedure InitObjectImg();
  procedure InitTilesImg();
  procedure InitSmTilesImg();
  //function  GetMonAction (nAppr:Integer):pTMonsterAction;
  function  GetJobName (nJob:Integer):String;
  function GetPulseName (btPage,btIndex: Byte): string;
  function GetPulsePageName (btPage: Byte): string;

  procedure InitConfig(); //��ʼ���ڹұ���
  procedure CreateSdoAssistant();//��ʼ��ʢ���ڹ�
  procedure LoadSdoAssistantConfig(sUserName:String);//����ʢ�������
  procedure SaveSdoAssistantConfig(sUserName:String);//����ʢ�������

  function Encrypt(const s:string; skey:string):string;
  function decrypt(const s:string; skey:string):string;

  Function SetDate(Text: String): String;
  function DeGhost(Source, Key: string): string;

  function CertKey(key: string): string;//���ܺ���
  function GetAdoSouse(S: String): String;
  function DecodeString_RC6(Source, Key: string): string;
  procedure SeqNumEnc(var Str: String; Key: Word; Times: Integer);
  function ProgramPath: string; //�õ��ļ������·�����ļ���
  procedure ExtractInfo(const FilePath: string; var MyRecInfo: TRecInfo);  //�����������õ���Ϣ

  function GetTzInfo(Items: string; Who: Byte):pTTzHintInfo; //ȡ����װ�ṹ
  function GetTzStateInfo(TzInfo: pTTzHintInfo;Who: Byte):string;
  function GetTzMemoInfo(TzInfo: pTTzHintInfo;StateCount, Who: Byte):string;
  function GetItemDesc(sName: string): string;
  function GetPulsDesc(sName: string): string;
  function GetSkillDesc(sType, sName: string): string;
  function GetItemType(ItemType: string): TItemType;
  function GetItemTypeName(ItemType: TItemType): string;
  {$IF M2Version <> 2}
  function GetTitleDesc(sName: string): string;
  function GetNewStateTitleDesc(sName: string): string;
  {$IFEND}
  {$IF GVersion = 1}
  function DestroyList(sItem: string):Boolean;  //��ѵ�¼���˵����
  {$IFEND}
  function GetColorDepth: Integer; //���ϵͳ��ǰ��ɫ
  function Resolution(X :word): Boolean; //�ı���ɫ
  function GetDisplayFrequency: Integer;//�õ�ˢ����
  procedure ChangeDisplayFrequency(iFrequency:Integer);//����ˢ����,��Win2000�³ɹ�
  function GetTime():Double;
  function GetEffecItemList(const ItemName: String): TEffecItem;
  procedure LoadEffecItemList();
implementation
uses FState, ClMain, HUtil32, Menus{$IF GVersion = 1},ComObj{$IFEND}, Splash;

function GetTime():Double;
var
  hires: Boolean;
  freq: Int64;
  nNow: Int64;
begin
  hires := False;
  hires := QueryPerformanceFrequency(freq);
  if not hires then freq := 1000;
  if hires then
    QueryPerformanceCounter(nNow)
  else nNow := GetTickCount();
  Result := nNow/freq*1000;
end;

//������Ʒ��Ч����
procedure LoadEffecItemList();
var
  I: Integer;
  sFileName, sLineText, sItemName, sPackLook, sPackPlay,sPackX,sPackY,sPackWilName: string;
  sWithinLook,sWithinPlay,sWithinX,sWithinY,sWithinWilName: string;
  sOutsideLook,{sOutsidePlay,sOutsideX,sOutsideY,}sOutsideWilName: string;
  LoadList: TStringList;
  EffecItem: pTEffecItem;
begin
  sFileName := g_ParamDir+'\Data\EffectItem.dat';
  if not FileExists(sFileName) then begin
    LoadList.Free;
    Exit;
  end;
  LoadList := TStringList.Create();
  try
    LoadList.LoadFromFile(sFileName);
    if LoadList.Count > 0 then begin
      for I := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[I];
        if (sLineText <> '') and (sLineText[1] <> ';') then begin
          sItemName:='';
          sPackLook:='';
          sPackPlay:='';
          sPackX:='';
          sPackY:='';
          sPackWilName:='';
          sWithinLook:='';
          sWithinPlay:='';
          sWithinX:='';
          sWithinY:='';
          sWithinWilName:='';
          sOutsideLook:='';
          {sOutsidePlay:='';
          sOutsideX:='';
          sOutsideY:=''; }
          sOutsideWilName:='';
          sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sPackLook, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sPackPlay, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sPackX, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sPackY, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sPackWilName, [' ', #9]);

          sLineText := GetValidStr3(sLineText, sWithinLook, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sWithinPlay, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sWithinX, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sWithinY, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sWithinWilName, [' ', #9]);

          sLineText := GetValidStr3(sLineText, sOutsideLook, [' ', #9]);
          {sLineText := GetValidStr3(sLineText, sOutsidePlay, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sOutsideX, [' ', #9]);
          sLineText := GetValidStr3(sLineText, sOutsideY, [' ', #9]); }
          sLineText := GetValidStr3(sLineText, sOutsideWilName, [' ', #9]);

          if (sItemName <> '') and (sPackWilName <> '') and (sWithinWilName <>'')
            and (sOutsideWilName <> '') then begin
            New(EffecItem);
            EffecItem.wBagIndex:= 0;//������ʼͼƬ
            EffecItem.btBagCount:= 0;//������������
            EffecItem.nBagX:= 0;//����X��������
            EffecItem.nBagY:= 0;//����Y��������
            EffecItem.btBagWilIndex:= 0;//����Wil����
            EffecItem.wShapeIndex:= 0;//�ڹۿ�ʼͼƬ
            EffecItem.btShapeCount:= 0;//�ڹ۲�������
            EffecItem.nShapeX:= 0;//�ڹ�X��������
            EffecItem.nShapeY:= 0;//�ڹ�Y��������
            EffecItem.btShapeWilIndex:= 0;//�ڹ�Wil����
            EffecItem.wLookIndex:= 0;//��ۿ�ʼͼƬ
            //EffecItem.btLookCount:= 0;//��۲�������
            //EffecItem.nLookX:= 0;//���X��������
            //EffecItem.nLookY:= 0;//���Y��������
            EffecItem.btLookWilIndex:= 0;//���Wil����
            try
              EffecItem.wBagIndex:= Str_ToInt(sPackLook,0);//������ʼͼƬ
              EffecItem.btBagCount:= Str_ToInt(sPackPlay,0);//������������
              EffecItem.nBagX:= Str_ToInt(sPackX,0);//����X��������
              EffecItem.nBagY:= Str_ToInt(sPackY,0);//����Y��������
              EffecItem.btBagWilIndex:= Str_ToInt(sPackWilName,0);//����Wil����

              EffecItem.wShapeIndex:= Str_ToInt(sWithinLook,0);//�ڹۿ�ʼͼƬ
              EffecItem.btShapeCount:= Str_ToInt(sWithinPlay,0);//�ڹ۲�������
              EffecItem.nShapeX:= Str_ToInt(sWithinX,0);//�ڹ�X��������
              EffecItem.nShapeY:= Str_ToInt(sWithinY,0);//�ڹ�Y��������
              EffecItem.btShapeWilIndex:= Str_ToInt(sWithinWilName,0);//�ڹ�Wil����

              EffecItem.wLookIndex:= Str_ToInt(sOutsideLook,0);//��ۿ�ʼͼƬ
              //EffecItem.btLookCount:= Str_ToInt(sOutsidePlay,0);//��۲�������
              //EffecItem.nLookX:= Str_ToInt(sOutsideX,0);//���X��������
              //EffecItem.nLookY:= Str_ToInt(sOutsideY,0);//���Y��������
              EffecItem.btLookWilIndex:= Str_ToInt(sOutsideWilName,0);//���Wil����
              g_EffecItemtList.AddObject(sItemName, TObject(EffecItem));
            except
              Dispose(EffecItem);
            end;
          end;
        end;
      end;
    end;
  finally
    LoadList.Free;
  end;
end;

//ȡ��Ʒ��Ч
function GetEffecItemList(const ItemName: String): TEffecItem;
var
  I: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.wLookIndex := 65535;
  if (g_EffecItemtList = nil) or (ItemName='') then Exit;
  if g_EffecItemtList.Count > 0 then begin
    I:= g_EffecItemtList.IndexOf(ItemName);
    if I > -1 then begin
      Result:= pTEffecItem(g_EffecItemtList.Objects[I])^;
    end;
  end;
end;

procedure LoadWMImagesLib(AOwner: TComponent);
begin
  g_WMainImages        := TWMImages.Create(AOwner);
  g_WMain2Images       := TWMImages.Create(AOwner);
  g_WMain3Images       := TWMImages.Create(AOwner);
  g_WChrSelImages      := TWMImages.Create(AOwner);
  g_WMMapImages        := TWMImages.Create(AOwner);
  g_WHumWingImages     := TWMImages.Create(AOwner);
  g_WHumWing2Images    := TWMImages.Create(AOwner);
  g_WHumWing3Images    := TWMImages.Create(AOwner);
  g_WHumWing4Images    := TWMImages.Create(AOwner);
  g_WBagItemImages     := TWMImages.Create(AOwner);
  g_WBagItem2Images    := TWMImages.Create(AOwner);
  g_WStateItemImages   := TWMImages.Create(AOwner);
  g_WStateItem2Images  := TWMImages.Create(AOwner);
  g_WDnItemImages      := TWMImages.Create(AOwner);
  g_WDnItem2Images     := TWMImages.Create(AOwner);
  g_WHumImgImages      := TWMImages.Create(AOwner);
  g_WHum2ImgImages     := TWMImages.Create(AOwner); //20080501
  g_WHum3ImgImages     := TWMImages.Create(AOwner);
  g_WHum4ImgImages     := TWMImages.Create(AOwner);
  g_WCboHumImgImages   := TWMImages.Create(AOwner);
  g_WCboHum3ImgImages  := TWMImages.Create(AOwner);
  g_WCboHum4ImgImages  := TWMImages.Create(AOwner);
  g_WHairImgImages     := TWMImages.Create(AOwner);
  g_WCboHairImgImages  := TWMImages.Create(AOwner);
  g_WWeaponImages      := TWMImages.Create(AOwner);
  g_WCboWeaponImages   := TWMImages.Create(AOwner);
  g_WCboWeaponImages3  := TWMImages.Create(AOwner);
  g_WCboWeaponImages4  := TWMImages.Create(AOwner);
  g_WWeapon2Images     := TWMImages.Create(AOwner); //20080501
  g_WWeapon3Images     := TWMImages.Create(AOwner);
  g_WWeapon4Images     := TWMImages.Create(AOwner);
  g_WMagIconImages     := TWMImages.Create(AOwner);
  g_WMagIcon2Images    := TWMImages.Create(AOwner);
  g_WNpcImgImages      := TWMImages.Create(AOwner);
  g_WNpc2ImgImages     := TWMImages.Create(AOwner);
  g_WMagicImages       := TWMImages.Create(AOwner);
  g_WMagic2Images      := TWMImages.Create(AOwner);
  g_WMagic3Images      := TWMImages.Create(AOwner);
  g_WMagic4Images      := TWMImages.Create(AOwner);    //2007.10.28
  g_WMagic5Images      := TWMImages.Create(AOwner);   //207.11.29
  g_WMagic6Images      := TWMImages.Create(AOwner);   //207.11.29

  g_WMagic7Images      := TWMImages.Create(AOwner);
  g_WMagic7Images16    := TWMImages.Create(AOwner);
  g_WMagic8Images      := TWMImages.Create(AOwner);
  g_WMagic8Images16    := TWMImages.Create(AOwner);
  g_WMagic9Images      := TWMImages.Create(AOwner);
  g_WMagic10Images     := TWMImages.Create(AOwner);

  g_WMonKuLouImages    := TWMImages.Create(AOwner);
  g_WEffectImages      := TWMImages.Create(AOwner);
  g_qingqingImages     := TWMImages.Create(AOwner);
  g_WchantkkImages     := TWMImages.Create(AOwner);
  g_WDragonImages      := TWMImages.Create(AOwner);
  g_WUiMainImages      := TUIWMImages.Create;
  g_WWeaponEffectImages:= TWMImages.Create(AOwner);
  g_WWeaponEffectImages4:= TWMImages.Create(AOwner);
  g_WCboWeaponEffectImages4:= TWMImages.Create(AOwner);


  g_WCboHumWingImages  := TWMImages.Create(AOwner);
  g_WCboHumWingImages2 := TWMImages.Create(AOwner);
  g_WCboHumWingImages3 := TWMImages.Create(AOwner);
  g_WCboHumWingImages4 := TWMImages.Create(AOwner);
  g_WCboEffectImages   := TWMImages.Create(AOwner);
  g_WUI1Images := TWMImages.Create(AOwner);
  g_WUI3Images := TWMImages.Create(AOwner);
  g_WchantkkImages := TWMImages.Create(AOwner);
  g_WStateEffectImages := TWMImages.Create(AOwner);
  FillChar(g_WObjectArr, SizeOf(g_WObjectArr), 0);
  FillChar(g_WTilesArr, SizeOf(g_WTilesArr), 0);
  FillChar(g_WSMTilesArr, SizeOf(g_WSMTilesArr), 0);
  FillChar(g_WMonImagesArr, SizeOf(g_WMonImagesArr), 0);
end;

procedure InitWMImagesLib(DDxDraw: TDxDraw);
begin
  g_WMainImages.DxDraw    := DDxDraw;
  g_WMainImages.DDraw     := DDxDraw.DDraw;
  if FileExists(g_ParamDir+MAINIMAGEFILE1) then begin//Wis�ļ����ڣ����ȡwis�����������wil�ļ�
    g_WMainImages.FileName  := g_ParamDir+MAINIMAGEFILE1;
  end else g_WMainImages.FileName  := g_ParamDir+MAINIMAGEFILE;
  g_WMainImages.LibType   := ltUseCache;
  g_WMainImages.Initialize;

  g_WMain2Images.DxDraw   := DDxDraw;
  g_WMain2Images.DDraw    := DDxDraw.DDraw;
  g_WMain2Images.FileName := g_ParamDir+MAINIMAGEFILE2;
  g_WMain2Images.LibType  := ltUseCache;
  g_WMain2Images.Initialize;

  g_WMain3Images.DxDraw   := DDxDraw;
  g_WMain3Images.DDraw    := DDxDraw.DDraw;
  g_WMain3Images.FileName := g_ParamDir+MAINIMAGEFILE3;
  g_WMain3Images.LibType  := ltUseCache;
  g_WMain3Images.Initialize;

  g_WChrSelImages.DxDraw   := DDxDraw;
  g_WChrSelImages.DDraw    := DDxDraw.DDraw;
  g_WChrSelImages.FileName := g_ParamDir+CHRSELIMAGEFILE;
  g_WChrSelImages.LibType  := ltUseCache;
  g_WChrSelImages.Initialize;

  g_WMMapImages.DxDraw     := DDxDraw;
  g_WMMapImages.DDraw      := DDxDraw.DDraw;
  g_WMMapImages.FileName   := g_ParamDir+MINMAPIMAGEFILE;
  g_WMMapImages.LibType    := ltUseCache;
  g_WMMapImages.Initialize;

  g_WHumWingImages.DxDraw   := DDxDraw;
  g_WHumWingImages.DDraw    := DDxDraw.DDraw;
  g_WHumWingImages.FileName := g_ParamDir+HUMWINGIMAGESFILE;
  g_WHumWingImages.LibType  := ltUseCache;
  g_WHumWingImages.Initialize;

  g_WHumWing2Images.DxDraw   := DDxDraw;
  g_WHumWing2Images.DDraw    := DDxDraw.DDraw;
  g_WHumWing2Images.FileName := g_ParamDir+HUMWINGIMAGESFILE2;
  g_WHumWing2Images.LibType  := ltUseCache;
  g_WHumWing2Images.Initialize;

  g_WHumWing3Images.DxDraw   := DDxDraw;
  g_WHumWing3Images.DDraw    := DDxDraw.DDraw;
  g_WHumWing3Images.FileName := g_ParamDir+HUMWINGIMAGESFILE3;
  g_WHumWing3Images.LibType  := ltUseCache;
  g_WHumWing3Images.Initialize;

  g_WHumWing4Images.DxDraw   := DDxDraw;
  g_WHumWing4Images.DDraw    := DDxDraw.DDraw;
  g_WHumWing4Images.FileName := g_ParamDir+HUMWINGIMAGESFILE4;
  g_WHumWing4Images.LibType  := ltUseCache;
  g_WHumWing4Images.Initialize;

  g_WCboHumWingImages.DxDraw   := DDxDraw;
  g_WCboHumWingImages.DDraw    := DDxDraw.DDraw;
  g_WCboHumWingImages.FileName := g_ParamDir+CBOHUMWINGIMAGESFILE;
  g_WCboHumWingImages.LibType  := ltUseCache;
  g_WCboHumWingImages.Initialize;   

  g_WCboHumWingImages2.DxDraw := DDxDraw;
  g_WCboHumWingImages2.DDraw := DDxDraw.DDraw;
  g_WCboHumWingImages2.FileName := g_ParamDir+CBOHUMWINGIMAGESFILE2;
  g_WCboHumWingImages2.LibType := ltUseCache;
  g_WCboHumWingImages2.Initialize;

  g_WCboHumWingImages3.DxDraw := DDxDraw;
  g_WCboHumWingImages3.DDraw := DDxDraw.DDraw;
  g_WCboHumWingImages3.FileName := g_ParamDir+CBOHUMWINGIMAGESFILE3;
  g_WCboHumWingImages3.LibType := ltUseCache;
  g_WCboHumWingImages3.Initialize;

  g_WCboHumWingImages4.DxDraw := DDxDraw;
  g_WCboHumWingImages4.DDraw := DDxDraw.DDraw;
  g_WCboHumWingImages4.FileName := g_ParamDir+CBOHUMWINGIMAGESFILE4;
  g_WCboHumWingImages4.LibType := ltUseCache;
  g_WCboHumWingImages4.Initialize;






  g_WBagItemImages.DxDraw   := DDxDraw;
  g_WBagItemImages.DDraw    := DDxDraw.DDraw;
  if FileExists(g_ParamDir+BAGITEMIMAGESFILE1) then begin//Wis�ļ����ڣ����ȡwis�����������wil�ļ�
    g_WBagItemImages.FileName := g_ParamDir+BAGITEMIMAGESFILE1;
  end else g_WBagItemImages.FileName := g_ParamDir+BAGITEMIMAGESFILE;
  g_WBagItemImages.LibType  := ltUseCache;
  g_WBagItemImages.Initialize;

  g_WBagItem2Images.DxDraw   := DDxDraw;
  g_WBagItem2Images.DDraw    := DDxDraw.DDraw;
  g_WBagItem2Images.FileName := g_ParamDir+BAGITEMIMAGESFILE2;
  g_WBagItem2Images.LibType  := ltUseCache;
  g_WBagItem2Images.Initialize;

  g_WStateItemImages.DxDraw   := DDxDraw;
  g_WStateItemImages.DDraw    := DDxDraw.DDraw;
  if FileExists(g_ParamDir+STATEITEMIMAGESFILE1) then begin//Wis�ļ����ڣ����ȡwis�����������wil�ļ�
    g_WStateItemImages.FileName := g_ParamDir+STATEITEMIMAGESFILE1;
  end else g_WStateItemImages.FileName := g_ParamDir+STATEITEMIMAGESFILE;
  g_WStateItemImages.LibType  := ltUseCache;
  g_WStateItemImages.Initialize;

  g_WStateItem2Images.DxDraw   := DDxDraw;
  g_WStateItem2Images.DDraw    := DDxDraw.DDraw;
  g_WStateItem2Images.FileName := g_ParamDir+STATEITEMIMAGESFILE2;
  g_WStateItem2Images.LibType  := ltUseCache;
  g_WStateItem2Images.Initialize;

  g_WDnItemImages.DxDraw:=DDxDraw;
  g_WDnItemImages.DDraw:=DDxDraw.DDraw;
  if FileExists(g_ParamDir+DNITEMIMAGESFILE1) then begin//Wis�ļ����ڣ����ȡwis�����������wil�ļ�
    g_WDnItemImages.FileName:=g_ParamDir+DNITEMIMAGESFILE1;
  end else g_WDnItemImages.FileName:=g_ParamDir+DNITEMIMAGESFILE;
  g_WDnItemImages.LibType:=ltUseCache;
  g_WDnItemImages.Initialize;

  g_WDnItem2Images.DxDraw:=DDxDraw;
  g_WDnItem2Images.DDraw:=DDxDraw.DDraw;
  g_WDnItem2Images.FileName:=g_ParamDir+DNITEMIMAGESFILE2;
  g_WDnItem2Images.LibType:=ltUseCache;
  g_WDnItem2Images.Initialize;

  g_WHumImgImages.DxDraw:=DDxDraw;
  g_WHumImgImages.DDraw:=DDxDraw.DDraw;
  g_WHumImgImages.FileName:=g_ParamDir+HUMIMGIMAGESFILE;
  g_WHumImgImages.LibType:=ltUseCache;
  g_WHumImgImages.Initialize;

  g_WHum2ImgImages.DxDraw:=DDxDraw;
  g_WHum2ImgImages.DDraw:=DDxDraw.DDraw;
  g_WHum2ImgImages.FileName:=g_ParamDir+HUM2IMGIMAGESFILE;
  g_WHum2ImgImages.LibType:=ltUseCache;
  g_WHum2ImgImages.Initialize;

  g_WHum3ImgImages.DxDraw:=DDxDraw;
  g_WHum3ImgImages.DDraw:=DDxDraw.DDraw;
  g_WHum3ImgImages.FileName:=g_ParamDir+HUM3IMGIMAGESFILE;
  g_WHum3ImgImages.LibType:=ltUseCache;
  g_WHum3ImgImages.Initialize;

  g_WHum4ImgImages.DxDraw:=DDxDraw;
  g_WHum4ImgImages.DDraw:=DDxDraw.DDraw;
  g_WHum4ImgImages.FileName:=g_ParamDir+HUM4IMGIMAGESFILE;
  g_WHum4ImgImages.LibType:=ltUseCache;
  g_WHum4ImgImages.Initialize;

  g_WCboHumImgImages.DxDraw:=DDxDraw;
  g_WCboHumImgImages.DDraw:=DDxDraw.DDraw;
  g_WCboHumImgImages.FileName:=g_ParamDir+CBOHUMIMGIMAGESFILE;
  g_WCboHumImgImages.LibType:=ltUseCache;
  g_WCboHumImgImages.Initialize;   

  g_WCboHum3ImgImages.DxDraw:=DDxDraw;
  g_WCboHum3ImgImages.DDraw:=DDxDraw.DDraw;
  g_WCboHum3ImgImages.FileName:=g_ParamDir+CBOHUMIMGIMAGESFILE3;
  g_WCboHum3ImgImages.LibType:=ltUseCache;
  g_WCboHum3ImgImages.Initialize;

  g_WCboHum4ImgImages.DxDraw:=DDxDraw;
  g_WCboHum4ImgImages.DDraw:=DDxDraw.DDraw;
  g_WCboHum4ImgImages.FileName:=g_ParamDir+CBOHUMIMGIMAGESFILE4;
  g_WCboHum4ImgImages.LibType:=ltUseCache;
  g_WCboHum4ImgImages.Initialize;

  g_WHairImgImages.DxDraw:=DDxDraw;
  g_WHairImgImages.DDraw:=DDxDraw.DDraw;
  g_WHairImgImages.FileName:=g_ParamDir+HAIRIMGIMAGESFILE;
  g_WHairImgImages.LibType:=ltUseCache;
  g_WHairImgImages.Initialize;

  g_WCboHairImgImages.DxDraw:=DDxDraw;
  g_WCboHairImgImages.DDraw:=DDxDraw.DDraw;
  g_WCboHairImgImages.FileName:=g_ParamDir+CBOHAIRIMAGESFILE;
  g_WCboHairImgImages.LibType:=ltUseCache;
  g_WCboHairImgImages.Initialize;

  g_WWeaponImages.DxDraw:=DDxDraw;
  g_WWeaponImages.DDraw:=DDxDraw.DDraw;
  g_WWeaponImages.FileName:=g_ParamDir+WEAPONIMAGESFILE;
  g_WWeaponImages.LibType:=ltUseCache;
  g_WWeaponImages.Initialize;

  g_WCboWeaponImages.DxDraw:=DDxDraw;
  g_WCboWeaponImages.DDraw:=DDxDraw.DDraw;
  g_WCboWeaponImages.FileName:=g_ParamDir+CBOWEAPONIMAGESFILE;
  g_WCboWeaponImages.LibType:=ltUseCache;
  g_WCboWeaponImages.Initialize;  

  g_WCboWeaponImages3.DxDraw := DDxDraw;
  g_WCboWeaponImages3.DDraw := DDxDraw.DDraw;
  g_WCboWeaponImages3.FileName := g_ParamDir+CBOWEAPONIMAGESFILE3;
  g_WCboWeaponImages3.LibType := ltUseCache;
  g_WCboWeaponImages3.Initialize;

  g_WCboWeaponImages4.DxDraw := DDxDraw;
  g_WCboWeaponImages4.DDraw := DDxDraw.DDraw;
  g_WCboWeaponImages4.FileName := g_ParamDir+CBOWEAPONIMAGESFILE4;
  g_WCboWeaponImages4.LibType := ltUseCache;
  g_WCboWeaponImages4.Initialize;


  g_WWeapon2Images.DxDraw:=DDxDraw;            //20080501
  g_WWeapon2Images.DDraw:=DDxDraw.DDraw;       //20080501
  if FileExists(g_ParamDir+WEAPON2IMAGESFILE1) then begin//Wis�ļ����ڣ����ȡwis�����������wil�ļ�
    g_WWeapon2Images.FileName:=g_ParamDir+WEAPON2IMAGESFILE1;
  end else g_WWeapon2Images.FileName:=g_ParamDir+WEAPON2IMAGESFILE; //20080501
  g_WWeapon2Images.LibType:=ltUseCache;        //20080501
  g_WWeapon2Images.Initialize;

  g_WWeapon3Images.DxDraw:=DDxDraw;            //20080501
  g_WWeapon3Images.DDraw:=DDxDraw.DDraw;       //20080501
  g_WWeapon3Images.FileName:=g_ParamDir+WEAPON3IMAGESFILE; //20080501
  g_WWeapon3Images.LibType:=ltUseCache;        //20080501
  g_WWeapon3Images.Initialize;

  g_WWeapon4Images.DxDraw:=DDxDraw;            //20080501
  g_WWeapon4Images.DDraw:=DDxDraw.DDraw;       //20080501
  g_WWeapon4Images.FileName:=g_ParamDir+WEAPON4IMAGESFILE; //20080501
  g_WWeapon4Images.LibType:=ltUseCache;        //20080501
  g_WWeapon4Images.Initialize;

  g_WMagIconImages.DxDraw:=DDxDraw;
  g_WMagIconImages.DDraw:=DDxDraw.DDraw;
  g_WMagIconImages.FileName:=g_ParamDir+MAGICONIMAGESFILE;
  g_WMagIconImages.LibType:=ltUseCache;
  g_WMagIconImages.Initialize;

  g_WMagIcon2Images.DxDraw:=DDxDraw;
  g_WMagIcon2Images.DDraw:=DDxDraw.DDraw;
  g_WMagIcon2Images.FileName:=g_ParamDir+MAGICONIMAGESFILE2;
  g_WMagIcon2Images.LibType:=ltUseCache;
  g_WMagIcon2Images.Initialize;

  g_WNpcImgImages.DxDraw:=DDxDraw;
  g_WNpcImgImages.DDraw:=DDxDraw.DDraw;
  g_WNpcImgImages.FileName:=g_ParamDir+NPCIMAGESFILE;
  g_WNpcImgImages.LibType:=ltUseCache;
  g_WNpcImgImages.Initialize;

  g_WNpc2ImgImages.DxDraw:=DDxDraw;
  g_WNpc2ImgImages.DDraw:=DDxDraw.DDraw;
  g_WNpc2ImgImages.FileName:=g_ParamDir+NPC2IMAGESFILE;
  g_WNpc2ImgImages.LibType:=ltUseCache;
  g_WNpc2ImgImages.Initialize;

  g_WMagicImages.DxDraw:=DDxDraw;
  g_WMagicImages.DDraw:=DDxDraw.DDraw;
  g_WMagicImages.FileName:=g_ParamDir+MAGICIMAGESFILE;
  g_WMagicImages.LibType:=ltUseCache;
  g_WMagicImages.Initialize;

  g_WMagic2Images.DxDraw:=DDxDraw;
  g_WMagic2Images.DDraw:=DDxDraw.DDraw;
  g_WMagic2Images.FileName:=g_ParamDir+MAGIC2IMAGESFILE;
  g_WMagic2Images.LibType:=ltUseCache;
  g_WMagic2Images.Initialize;

  g_WMagic3Images.DxDraw:=DDxDraw;
  g_WMagic3Images.DDraw:=DDxDraw.DDraw;
  g_WMagic3Images.FileName:=g_ParamDir+MAGIC3IMAGESFILE;
  g_WMagic3Images.LibType:=ltUseCache;
  g_WMagic3Images.Initialize;

  g_WMagic4Images.DxDraw:=DDxDraw;
  g_WMagic4Images.DDraw:=DDxDraw.DDraw;
  g_WMagic4Images.FileName:=g_ParamDir+MAGIC4IMAGESFILE;
  g_WMagic4Images.LibType:=ltUseCache;
  g_WMagic4Images.Initialize;

  g_WMagic5Images.DxDraw:=DDxDraw;
  g_WMagic5Images.DDraw:=DDxDraw.DDraw;
  g_WMagic5Images.FileName:=g_ParamDir+MAGIC5IMAGESFILE;
  g_WMagic5Images.LibType:=ltUseCache;
  g_WMagic5Images.Initialize;

  g_WMagic6Images.DxDraw:=DDxDraw;
  g_WMagic6Images.DDraw:=DDxDraw.DDraw;
  g_WMagic6Images.FileName:=g_ParamDir+MAGIC6IMAGESFILE;
  g_WMagic6Images.LibType:=ltUseCache;
  g_WMagic6Images.Initialize;

  g_WMagic7Images.DxDraw := DDxDraw;
  g_WMagic7Images.DDraw := DDxDraw.DDraw;
  g_WMagic7Images.FileName := g_ParamDir+MAGIC7IMAGESFILE;
  g_WMagic7Images.LibType:=ltUseCache;
  g_WMagic7Images.Initialize;

  g_WMagic7Images16.DxDraw := DDxDraw;
  g_WMagic7Images16.DDraw := DDxDraw.DDraw;
  g_WMagic7Images16.FileName := g_ParamDir+MAGIC7IMAGESFILE16;
  g_WMagic7Images16.LibType:=ltUseCache;
  g_WMagic7Images16.Initialize;

  g_WMagic8Images.DxDraw := DDxDraw;
  g_WMagic8Images.DDraw := DDxDraw.DDraw;
  g_WMagic8Images.FileName := g_ParamDir+MAGIC8IMAGESFILE;
  g_WMagic8Images.LibType:=ltUseCache;
  g_WMagic8Images.Initialize;

  g_WMagic8Images16.DxDraw := DDxDraw;
  g_WMagic8Images16.DDraw := DDxDraw.DDraw;
  g_WMagic8Images16.FileName := g_ParamDir+MAGIC8IMAGESFILE16;
  g_WMagic8Images16.LibType:=ltUseCache;
  g_WMagic8Images16.Initialize;

  g_WMagic9Images.DxDraw := DDxDraw;
  g_WMagic9Images.DDraw := DDxDraw.DDraw;
  g_WMagic9Images.FileName := g_ParamDir+MAGIC9IMAGESFILE;
  g_WMagic9Images.LibType:=ltUseCache;
  g_WMagic9Images.Initialize;

  g_WMagic10Images.DxDraw := DDxDraw;
  g_WMagic10Images.DDraw := DDxDraw.DDraw;
  g_WMagic10Images.FileName := g_ParamDir+MAGIC10IMAGESFILE;
  g_WMagic10Images.LibType:=ltUseCache;
  g_WMagic10Images.Initialize;

  g_WMonKuLouImages.DxDraw := DDxDraw;
  g_WMonKuLouImages.DDraw := DDxDraw.DDraw;
  g_WMonKuLouImages.FileName := g_ParamDir+MONKULOUIMAGEFILE;
  g_WMonKuLouImages.LibType:=ltUseCache;
  g_WMonKuLouImages.Initialize;

  g_WEffectImages.DxDraw:=DDxDraw;
  g_WEffectImages.DDraw:=DDxDraw.DDraw;
  g_WEffectImages.FileName:=g_ParamDir+EFFECTIMAGEFILE;
  g_WEffectImages.LibType:=ltUseCache;
  g_WEffectImages.Initialize;

  g_qingqingImages.DxDraw:=DDxDraw;
  g_qingqingImages.DDraw:=DDxDraw.DDraw;
  g_qingqingImages.FileName:=g_ParamDir+qingqingFILE;
  g_qingqingImages.LibType:=ltUseCache;
  g_qingqingImages.Initialize;

  g_WchantkkImages.DxDraw:=DDxDraw;
  g_WchantkkImages.DDraw:=DDxDraw.DDraw;
  g_WchantkkImages.FileName := g_ParamDir+chantkkFILE;
  g_WchantkkImages.LibType:=ltUseCache;
  g_WchantkkImages.Initialize;

  g_WDragonImages.DxDraw := DDxDraw;
  g_WDragonImages.DDraw := DDxDraw.DDraw;
  g_WDragonImages.FileName := g_ParamDir+DRAGONIMGESFILE;
  g_WDragonImages.LibType := ltUseCache;
  g_WDragonImages.Initialize;

  g_WWeaponEffectImages.DxDraw := DDxDraw;
  g_WWeaponEffectImages.DDraw := DDxDraw.DDraw;
  g_WWeaponEffectImages.FileName := g_ParamDir+WEAPONEFFECTFILE;
  g_WWeaponEffectImages.LibType := ltUseCache;
  g_WWeaponEffectImages.Initialize;

  g_WWeaponEffectImages4.DxDraw := DDxDraw;
  g_WWeaponEffectImages4.DDraw := DDxDraw.DDraw;
  g_WWeaponEffectImages4.FileName := g_ParamDir+WEAPONEFFECTFILE4;
  g_WWeaponEffectImages4.LibType := ltUseCache;
  g_WWeaponEffectImages4.Initialize;

  g_WCboWeaponEffectImages4.DxDraw := DDxDraw;
  g_WCboWeaponEffectImages4.DDraw := DDxDraw.DDraw;
  g_WCboWeaponEffectImages4.FileName := g_ParamDir+CBOWEAPONEFFECTIMAGESFILE4;
  g_WCboWeaponEffectImages4.LibType := ltUseCache;
  g_WCboWeaponEffectImages4.Initialize;



  g_WCboEffectImages.DxDraw:=DDxDraw;
  g_WCboEffectImages.DDraw:=DDxDraw.DDraw;
  g_WCboEffectImages.FileName:=g_ParamDir+CBOEFFECTIMAGESFILE;
  g_WCboEffectImages.LibType:=ltUseCache;
  g_WCboEffectImages.Initialize; 

  g_WUI1Images.DxDraw := DDxDraw;
  g_WUI1Images.DDraw := DDxDraw.DDraw;
  g_WUI1Images.FileName:=g_ParamDir+UI1IMAGESFILE;
  g_WUI1Images.LibType:=ltUseCache;
  g_WUI1Images.Initialize;

  g_WUI3Images.DxDraw := DDxDraw;
  g_WUI3Images.DDraw := DDxDraw.DDraw;
  g_WUI3Images.FileName:=g_ParamDir+UI3IMAGESFILE;
  g_WUI3Images.LibType:=ltUseCache;
  g_WUI3Images.Initialize;

  g_WStateEffectImages.DxDraw := DDxDraw;
  g_WStateEffectImages.DDraw := DDxDraw.DDraw;
  g_WStateEffectImages.FileName:=g_ParamDir+STATEEFFECTFILE;
  g_WStateEffectImages.LibType:=ltUseCache;
  g_WStateEffectImages.Initialize;
end;

procedure InitUiWMImagesLib(DDxDraw: TDxDraw);
begin
  g_WUiMainImages.DDraw := DDxDraw.DDraw;
  g_WUiMainImages.Initialize;
end;

procedure UnLoadWMImagesLib();
var
  I:Integer;
begin
  for I:=Low(g_WObjectArr) to High(g_WObjectArr) do begin
    if g_WObjectArr[I] <> nil then begin
      g_WObjectArr[I].Finalize;
      g_WObjectArr[I].Free;
    end;
  end;

  for I:=Low(g_WTilesArr) to High(g_WTilesArr) do begin
    if g_WTilesArr[I] <> nil then begin
      g_WTilesArr[I].Finalize;
      g_WTilesArr[I].Free;
    end;
  end;

  for I:=Low(g_WSMTilesArr) to High(g_WSMTilesArr) do begin
    if g_WSMTilesArr[I] <> nil then begin
      g_WSMTilesArr[I].Finalize;
      g_WSMTilesArr[I].Free;
    end;
  end;

  for I:=Low(g_WMonImagesArr) to High(g_WMonImagesArr) do begin
    if g_WMonImagesArr[I] <> nil then begin
      g_WMonImagesArr[I].Finalize;
      g_WMonImagesArr[I].Free;
    end;
  end;
  g_WMainImages.Finalize;
  g_WMainImages.Free;
  g_WMain2Images.Finalize;
  g_WMain2Images.Free;
  g_WMain3Images.Finalize;
  g_WMain3Images.Free;
  g_WChrSelImages.Finalize;
  g_WChrSelImages.Free;
  g_WMMapImages.Finalize;
  g_WMMapImages.Free;
  g_WHumWingImages.Finalize;
  g_WHumWingImages.Free;
  g_WHumWing2Images.Finalize;
  g_WHumWing2Images.Free;
  g_WHumWing3Images.Finalize;
  g_WHumWing3Images.Free;
  g_WHumWing4Images.Finalize;
  g_WHumWing4Images.Free;
  g_WCboHumWingImages.Finalize;
  g_WCboHumWingImages.Free;
  g_WCboHumWingImages2.Finalize;
  g_WCboHumWingImages2.Free;
  g_WCboHumWingImages3.Finalize;
  g_WCboHumWingImages3.Free;
  g_WCboHumWingImages4.Finalize;
  g_WCboHumWingImages4.Free;

  g_WBagItemImages.Finalize;
  g_WBagItemImages.Free;
  g_WBagItem2Images.Finalize;
  g_WBagItem2Images.Free;
  g_WStateItemImages.Finalize;
  g_WStateItemImages.Free;
  g_WStateItem2Images.Finalize;
  g_WStateItem2Images.Free;
  g_WDnItemImages.Finalize;
  g_WDnItemImages.Free;
  g_WDnItem2Images.Finalize;
  g_WDnItem2Images.Free;
  g_WHumImgImages.Finalize;
  g_WHumImgImages.Free;
  g_WHum2ImgImages.Finalize; //20080501
  g_WHum2ImgImages.Free;     //20080501
  g_WHum3ImgImages.Finalize;
  g_WHum3ImgImages.Free;
  g_WHum4ImgImages.Finalize; //20080501
  g_WHum4ImgImages.Free;     //20080501
  g_WCboHumImgImages.Finalize;
  g_WCboHumImgImages.Free;
  g_WCboHum3ImgImages.Finalize;
  g_WCboHum3ImgImages.Free;
  g_WCboHum4ImgImages.Finalize;
  g_WCboHum4ImgImages.Free;

  g_WHairImgImages.Finalize;
  g_WHairImgImages.Free;
  g_WCboHairImgImages.Finalize;
  g_WCboHairImgImages.Free;
  g_WWeaponImages.Finalize;
  g_WWeaponImages.Free;
  g_WCboWeaponImages.Finalize;
  g_WCboWeaponImages.Free;
  g_WCboWeaponImages3.Finalize;
  g_WCboWeaponImages3.Free;
  g_WCboWeaponImages4.Finalize;
  g_WCboWeaponImages4.Free;
  g_WWeapon2Images.Finalize;  //20080501
  g_WWeapon2Images.Free;     //20080501
  g_WWeapon3Images.Finalize;
  g_WWeapon3Images.Free;

  g_WWeapon4Images.Finalize;
  g_WWeapon4Images.Free;
  
  g_WMagIconImages.Finalize;
  g_WMagIconImages.Free;
  g_WMagIcon2Images.Finalize;
  g_WMagIcon2Images.Free;
  g_WNpcImgImages.Finalize;
  g_WNpcImgImages.Free;
  g_WNpc2ImgImages.Finalize;
  g_WNpc2ImgImages.Free;
  g_WMagicImages.Finalize;
  g_WMagicImages.Free;
  g_WMagic2Images.Finalize;
  g_WMagic2Images.Free;
  g_WMagic3Images.Finalize;
  g_WMagic3Images.Free;
  g_WMagic4Images.Finalize;    //2007.10.28
  g_WMagic4Images.Free;
  g_WMagic5Images.Finalize;    //2007.11.29
  g_WMagic5Images.Free;
  g_WMagic6Images.Finalize;    //2007.11.29
  g_WMagic6Images.Free;
  g_WMagic7Images.Finalize;
  g_WMagic7Images.Free;
  g_WMagic8Images.Finalize;
  g_WMagic8Images.Free;
  g_WMagic7Images16.Finalize;
  g_WMagic7Images16.Free;
  g_WMagic8Images16.Finalize;
  g_WMagic8Images16.Free;
  g_WMagic9Images.Finalize;
  g_WMagic9Images.Free;
  g_WMagic10Images.Finalize;
  g_WMagic10Images.Free;
  g_WMonKuLouImages.Finalize;
  g_WMonKuLouImages.Free;
  g_WEffectImages.Finalize;    //2007.10.28
  g_WEffectImages.Free;
  g_qingqingImages.Finalize;    //2007.10.28
  g_qingqingImages.Free;
  g_WchantkkImages.Finalize;
  g_WchantkkImages.Free;
  g_WDragonImages.Finalize;
  g_WDragonImages.Free;
  g_WUiMainImages.Finalize;
  g_WUiMainImages.Free;
  g_WWeaponEffectImages.Finalize;
  g_WWeaponEffectImages.Free;
  g_WWeaponEffectImages4.Finalize;
  g_WWeaponEffectImages4.Free;
  g_WCboWeaponEffectImages4.Finalize;
  g_WCboWeaponEffectImages4.Free;


  g_WCboEffectImages.Finalize;
  g_WCboEffectImages.Free;
  g_WUI1Images.Finalize;
  g_WUI1Images.Free;
  g_WUI3Images.Finalize;
  g_WUI3Images.Free;
  g_WStateEffectImages.Finalize;
  g_WStateEffectImages.Free;
end;

function GetTiles (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WTilesArr)) or (nUnit > High(g_WTilesArr)) then nUnit:=0;
  if g_WTilesArr[nUnit] <> nil then
  Result:=g_WTilesArr[nUnit].Images[nIdx];
end;

function GetSmTiles (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WSmTilesArr)) or (nUnit > High(g_WSmTilesArr)) then nUnit:=0;
  if g_WSmTilesArr[nUnit] <> nil then
  Result:=g_WSmTilesArr[nUnit].Images[nIdx];
end;
//ȡ��ͼͼ��
function GetObjs (nUnit,nIdx:Integer):TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then nUnit:=0;
  if g_WObjectArr[nUnit] <> nil then
  Result:=g_WObjectArr[nUnit].Images[nIdx];
end;

//ȡ��ͼͼ��
function  GetObjsEx (nUnit,nIdx:Integer; var px, py: integer): TDirectDrawSurface;
begin
  Result:=nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then nUnit:=0;
  if g_WObjectArr[nUnit] <> nil then
  Result:=g_WObjectArr[nUnit].GetCachedImage(nIdx,px,py);
end;

procedure InitObjectImg();
var
  I: Integer;
  sFileName,sNewFileName: string;
begin
  for I:= Low(g_WObjectArr) to High(g_WObjectArr) do begin
    if I = 0 then sFileName:=g_ParamDir+OBJECTIMAGEFILE
    else sFileName:=g_ParamDir+format(OBJECTIMAGEFILE1,[I+1]);

    sNewFileName:=Copy(sFileName,1,Length(sFileName)-3)+'wzl';
    if (not FileExists(sFileName)) and (not FileExists(sNewFileName)) then Continue;

    g_WObjectArr[I]:=TWMImages.Create(nil);
    g_WObjectArr[I].DxDraw:=g_DxDraw;
    g_WObjectArr[I].DDraw:=g_DxDraw.DDraw;
    g_WObjectArr[I].FileName:=sFileName;;
    g_WObjectArr[I].LibType:=ltUseCache;
    g_WObjectArr[I].Initialize;
  end;
end;

procedure InitTilesImg();
var
  I: Integer;
  sFileName,sNewFileName: string;
begin
  for I:=Low(g_WTilesArr) to High(g_WTilesArr) do begin
    if I = 0 then sFileName:=g_ParamDir+TITLESIMAGEFILE
    else sFileName:=g_ParamDir+format(TITLESIMAGEFILE1,[I+1]);

    sNewFileName:=Copy(sFileName,1,Length(sFileName)-3)+'wzl';
    if (not FileExists(sFileName)) and (not FileExists(sNewFileName)) then Continue;

    g_WTilesArr[I]:=TWMImages.Create(nil);
    g_WTilesArr[I].DxDraw:=g_DxDraw;
    g_WTilesArr[I].DDraw:=g_DxDraw.DDraw;
    g_WTilesArr[I].FileName:=sFileName;;
    g_WTilesArr[I].LibType:=ltUseCache;
    g_WTilesArr[I].Initialize;
  end;
end;

procedure InitSmTilesImg();
var
  I: Integer;
  sFileName,sNewFileName: string;
begin
  for I:=Low(g_WSmTilesArr) to High(g_WSmTilesArr) do begin
    if I = 0 then sFileName:=g_ParamDir+SMLTITLESIMAGEFILE
    else sFileName:=g_ParamDir+format(SMLTITLESIMAGEFILE1,[I+1]);

    sNewFileName:=Copy(sFileName,1,Length(sFileName)-3)+'wzl';
    if (not FileExists(sFileName)) and (not FileExists(sNewFileName)) then Continue;
    
    g_WSmTilesArr[I]:=TWMImages.Create(nil);
    g_WSmTilesArr[I].DxDraw:=g_DxDraw;
    g_WSmTilesArr[I].DDraw:=g_DxDraw.DDraw;
    g_WSmTilesArr[I].FileName:=sFileName;;
    g_WSmTilesArr[I].LibType:=ltUseCache;
    g_WSmTilesArr[I].Initialize;
  end;
end;

procedure InitMonImg();
var
  I: Integer;
  sFileName,sNewFileName: string;
begin
  for I:= Low(g_WMonImagesArr) to (High(g_WMonImagesArr)) do begin
      sFileName:=g_ParamDir+format(MONIMAGEFILE,[I+1]);

      sNewFileName:=Copy(sFileName,1,Length(sFileName)-3)+'wzl';
      if (not FileExists(sFileName)) and (not FileExists(sNewFileName)) then Continue;

      g_WMonImagesArr[I]:=TWMImages.Create(nil);
      g_WMonImagesArr[I].DxDraw:=g_DxDraw;
      g_WMonImagesArr[I].DDraw:=g_DxDraw.DDraw;
      g_WMonImagesArr[I].FileName:=sFileName;;
      g_WMonImagesArr[I].LibType:=ltUseCache;
      g_WMonImagesArr[I].Initialize;
  end;
end;

function GetMonImg (nAppr:Integer):TWMImages;
var
 // sFileName:String;
  nUnit:Integer;
begin
  Result:=nil;
  if nAppr > 9999 then Exit;
  
  if nAppr < 1000 then nUnit:=nAppr div 10
  else nUnit:=nAppr  div 100;    

   { if nUnit = 90 then begin
      Result := g_WEffectImages;//sFileName:=EFFECTIMAGEFILE;
      Exit;
    end;   }
  if nUnit <> 90 then begin
    if (nUnit < Low(g_WMonImagesArr)) or (nUnit > High(g_WMonImagesArr)) then nUnit:=0;
    if nUnit >= 35 then begin
      if nUnit < 37 then
        nUnit := 35//�����Ѿ���By TasNat at: 2012-10-18 10:20:46
      else Dec(nUnit, 2)
    end;
    {if g_WMonImagesArr[nUnit] = nil then begin

      sFileName:=format(MONIMAGEFILE,[nUnit+1]);
      //if nUnit = 80 then sFileName:=DRAGONIMAGEFILE;

     // if nUnit >= 1000 then sFileName:=format(MONIMAGEFILEEX,[nUnit]); //����1000��ŵĹ���ȡ�µĹ����ļ�

      g_WMonImagesArr[nUnit]:=TWMImages.Create(nil);
      g_WMonImagesArr[nUnit].DxDraw:=g_DxDraw;
      g_WMonImagesArr[nUnit].DDraw:=g_DxDraw.DDraw;
      g_WMonImagesArr[nUnit].FileName:=sFileName;
      g_WMonImagesArr[nUnit].LibType:=ltUseCache;
      g_WMonImagesArr[nUnit].Initialize;
    end;   }
    if g_WMonImagesArr[nUnit] <> nil then
      Result:=g_WMonImagesArr[nUnit];
  end else begin  //ɳ���š���ǽ֮���
    case nAppr of
      904..906: begin
        if (nUnit >= Low(g_WMonImagesArr)) or (nUnit <= High(g_WMonImagesArr)) then
          if g_WMonImagesArr[33] <> nil then Result := g_WMonImagesArr[33];
      end;
      9010..9012: begin//ǿ������
        if g_WMonKuLouImages <> nil then Result := g_WMonKuLouImages
      end;
      9013..9015: begin//ǿ��ʥ��
        if (nUnit >= Low(g_WMonImagesArr)) or (nUnit <= High(g_WMonImagesArr)) then
          if g_WMonImagesArr[27] <> nil then Result := g_WMonImagesArr[27];
      end;
      else if g_WEffectImages <> nil then Result := g_WEffectImages;
    end;
  end;
end;


//ȡ��ְҵ����
//0 ��ʿ
//1 ħ��ʦ
//2 ��ʿ
function GetJobName (nJob:Integer):String;
begin
  Result:= '';
  case nJob of
    0:Result:=g_sWarriorName;
    1:Result:=g_sWizardName;
    2:Result:=g_sTaoistName;
    else begin
      Result:=g_sUnKnowName;
    end;
  end;
end;

function GetPulseName (btPage,btIndex: Byte): string;
begin
  Result := '';
  case btPage of
    0: begin //����
      case btIndex of
        0: Result := '����';
        1: Result := 'ͨ��';
        2: Result := '����';
        3: Result := '����';
        4: Result := '���';
      end;
    end;
    1: begin //����
      case btIndex of
        0: Result := '����';
        1: Result := '��ȱ';
        2: Result := '����';
        3: Result := '�պ�';
        4: Result := 'Ȼ��';
      end;
    end;
    2: begin //��ά
      case btIndex of
        0: Result := '��Ȫ';
        1: Result := '����';
        2: Result := '����';
        3: Result := '����';
        4: Result := '����';
      end;
    end;
    3: begin //����
      case btIndex of
        0: Result := '�н�';
        1: Result := '��ͻ';
        2: Result := '�β';
        3: Result := '����';
        4: Result := '����';
      end;
    end;
    4: begin //�澭
      case btIndex of
        0: Result := '���';
        1: Result := '�м�';
        2: Result := '����';
        3: Result := '�˷�';
        4: Result := 'ӿȪ';
      end;
    end;
  end;
end;

function GetPulsePageName (btPage: Byte): string;
begin
  Result := '';
  case btPage of
    0: Result := '����';
    1: Result := '����';
    2: Result := '��ά';
    3: Result := '����';
    4: Result := '�澭';
  end;
end;

procedure InitConfig(); //��ʼ���ڹұ���
var
  I: Integer;
begin
  with g_Config do begin
    boAutoPuckUpItem := True;
    boNoShift := False;
    boExpFiltrate := False; //20080714
    boShowMimiMapDesc := False;
    boShowHeroStateNumber := False;
    boShowName := False;
    boDuraWarning :=True;
    boLongHit             := False;
    boPosLongHit          := False;
    boAutoWideHit         := False;
    boAutoFireHit         := False;
    boAutoZhuriHit        := False;
    boAutoShield          := False;
    boHeroAutoShield      := False;
    boShowSpecialDamage   := True;
    boAutoDragInBody      := False;
    boHideHumanWing       := False;
    boHideWeaponEffect    := False;
    boAutoHide            := False;
    boAutoMagic           := False;
    nAutoMagicTime        := 4;
    boAutoEatWine         := False;
    boAutoEatHeroWine     := False;
    boAutoEatDrugWine     := False;
    boAutoEatHeroDrugWine := False;
    btEditWine         := 10;
    btEditHeroWine     := 10;
    btEditDrugWine     := 10;
    btEditHeroDrugWine := 10;
    dwEditExpFiltrate  := 2000;

    boHp1Chk:= False;
    wHp1Hp:= 0;
    btHp1Man:= 0;
    boMp1Chk:= False;
    wMp1Mp:= 0;
    btMp1Man:= 0;
    boRenewHPIsAuto:= False;
    wRenewHPTime:= 4000;
    wRenewHPTick:= 0;
    wRenewHPPercent:= 10;
    boRenewMPIsAuto:= False;
    wRenewMPTime:= 4000;
    wRenewMPPercent:= 10;
    wRenewMPTick:= 0;
    boRenewSpecialHPIsAuto:= False;
    wRenewSpecialHPTime:= 4000;
    wRenewSpecialHPTick:= 0;
    wRenewSpecialHPPercent:= 10;
    boRenewSpecialMpIsAuto:= False;
    wRenewSpecialMpTime:= 4000;
    wRenewSpecialMPTick:= 0;
    wRenewSpecialMpPercent:= 10;
    BoUseSuperMedica:= False;
    FillChar(SuperMedicaUses, SizeOf(SuperMedicaUses), #0);
    //SuperMedicaUses:= (False, False, False, False, False, False, False, False, False);
    FillChar(SuperMedicaHPs, SizeOf(SuperMedicaHPs), 0);
    //SuperMedicaHPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(SuperMedicaHPTimes) to High(SuperMedicaHPTimes) do begin
      SuperMedicaHPTimes[I]:=4000;
    end;
    //SuperMedicaHPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(SuperMedicaHPTicks, SizeOf(SuperMedicaHPTicks), 0);
    //SuperMedicaHPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(SuperMedicaMPs, SizeOf(SuperMedicaMPs), 0);
    //SuperMedicaMPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(SuperMedicaMPTimes) to High(SuperMedicaMPTimes) do begin
      SuperMedicaMPTimes[I]:=4000;
    end;
    //SuperMedicaMPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(SuperMedicaMPTicks, SizeOf(SuperMedicaMPTicks), 0);
    //SuperMedicaMPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    {$IF M2Version <> 2}
    boHp2Chk:= False;
    wHp2Hp:= 0;
    //btHp2Man:= 0;
    boMp2Chk:= False;
    wMp2Mp:= 0;
    //btMp2Man:= 0;
    boHp3Chk:= False;
    wHp3Hp:= 0;
    //btHp3Man:= 0;
    boMp3Chk:= False;
    wMp3Mp:= 0;
    //btMp3Man:= 0;
    boHp4Chk:= False;
    wHp4Hp:= 0;
    //btHp4Man:= 0;
    boMp4Chk:= False;
    wMp4Mp:= 0;
    //btMp4Man:= 0;
    boHp5Chk:= False;
    wHp5Hp:= 0;
    //btHp5Man:= 0;
    boMp5Chk:= False;
    wMp5Mp:= 0;
    //btMp5Man:= 0;
    boRenewHeroNormalHpIsAuto:= False;
    wRenewHeroNormalHpTime:= 4000;
    wRenewHeroNormalHpTick:= 0;
    wRenewHeroNormalHpPercent:= 10;
    boRenewzHeroNormalHpIsAuto:= False;
    wRenewzHeroNormalHpTime:= 4000;
    wRenewzHeroNormalHpTick:= 0;
    wRenewzHeroNormalHpPercent:= 10;
    boRenewfHeroNormalHpIsAuto:= False;
    wRenewfHeroNormalHpTime:= 4000;
    wRenewfHeroNormalHpTick:= 0;
    wRenewfHeroNormalHpPercent:= 10;
    boRenewdHeroNormalHpIsAuto:= False;
    wRenewdHeroNormalHpTime:= 4000;
    wRenewdHeroNormalHpTick:= 0;
    wRenewdHeroNormalHpPercent:= 10;
    boRenewHeroNormalMpIsAuto:= False;
    wRenewHeroNormalMpTime:= 4000;
    wRenewHeroNormalMpTick:= 0;
    wRenewHeroNormalMpPercent:= 10;
    boRenewzHeroNormalMpIsAuto:= False;
    wRenewzHeroNormalMpTime:= 4000;
    wRenewzHeroNormalMpTick:= 0;
    wRenewzHeroNormalMpPercent:= 10;
    boRenewfHeroNormalMpIsAuto:= False;
    wRenewfHeroNormalMpTime:= 4000;
    wRenewfHeroNormalMpTick:= 0;
    wRenewfHeroNormalMpPercent:= 10;
    boRenewdHeroNormalMpIsAuto:= False;
    wRenewdHeroNormalMpTime:= 4000;
    wRenewdHeroNormalMpTick:= 0;
    wRenewdHeroNormalMpPercent:= 10;

    boRenewSpecialHeroNormalHpIsAuto:= False;
    wRenewSpecialHeroNormalHpTime:= 4000;
    wRenewSpecialHeroNormalHpTick:= 0;
    wRenewSpecialHeroNormalHpPercent:= 10;
    boRenewSpecialzHeroNormalHpIsAuto:= False;
    wRenewSpecialzHeroNormalHpTime:= 4000;
    wRenewSpecialzHeroNormalHpTick:= 0;
    wRenewSpecialzHeroNormalHpPercent:= 10;
    boRenewSpecialfHeroNormalHpIsAuto:= False;
    wRenewSpecialfHeroNormalHpTime:= 4000;
    wRenewSpecialfHeroNormalHpTick:= 0;
    wRenewSpecialfHeroNormalHpPercent:= 10;
    boRenewSpecialdHeroNormalHpIsAuto:= False;
    wRenewSpecialdHeroNormalHpTime:= 4000;
    wRenewSpecialdHeroNormalHpTick:= 0;
    wRenewSpecialdHeroNormalHpPercent:= 10;

    boRenewSpecialHeroNormalMpIsAuto:= False;
    wRenewSpecialHeroNormalMpTime:= 4000;
    wRenewSpecialHeroNormalMpTick:= 0;
    wRenewSpecialHeroNormalMpPercent:= 10;
    boRenewSpecialzHeroNormalMpIsAuto:= False;
    wRenewSpecialzHeroNormalMpTime:= 4000;
    wRenewSpecialzHeroNormalMpTick:= 0;
    wRenewSpecialzHeroNormalMpPercent:= 10;
    boRenewSpecialfHeroNormalMpIsAuto:= False;
    wRenewSpecialfHeroNormalMpTime:= 4000;
    wRenewSpecialfHeroNormalMpTick:= 0;
    wRenewSpecialfHeroNormalMpPercent:= 10;
    boRenewSpecialdHeroNormalMpIsAuto:= False;
    wRenewSpecialdHeroNormalMpTime:= 4000;
    wRenewSpecialdHeroNormalMpTick:= 0;
    wRenewSpecialdHeroNormalMpPercent:= 10;
    hBoUseSuperMedica:= False;
    zBoUseSuperMedica:= False;
    fBoUseSuperMedica:= False;
    dBoUseSuperMedica:= False;
    FillChar(hSuperMedicaUses, SizeOf(hSuperMedicaUses), #0);
    //hSuperMedicaUses:= (False, False, False, False, False, False, False, False, False);
    FillChar(hSuperMedicaHPs, SizeOf(hSuperMedicaHPs), 0);
    //hSuperMedicaHPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(hSuperMedicaHPTimes) to High(hSuperMedicaHPTimes) do begin
      hSuperMedicaHPTimes[I] := 4000;
    end;
    //hSuperMedicaHPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(hSuperMedicaHPTicks, SizeOf(hSuperMedicaHPTicks), 0);
    //hSuperMedicaHPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(hSuperMedicaMPs, SizeOf(hSuperMedicaMPs), 0);
    //hSuperMedicaMPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(hSuperMedicaMPTimes) to High(hSuperMedicaMPTimes) do begin
      hSuperMedicaMPTimes[I] := 4000;
    end;
    //hSuperMedicaMPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(hSuperMedicaMPTicks, SizeOf(hSuperMedicaMPTicks), 0);
    //hSuperMedicaMPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(zSuperMedicaUses, SizeOf(zSuperMedicaUses), #0);
    //zSuperMedicaUses:= (False, False, False, False, False, False, False, False, False);
    FillChar(zSuperMedicaHPs, SizeOf(zSuperMedicaHPs), 0);
    //zSuperMedicaHPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(zSuperMedicaHPTimes) to High(zSuperMedicaHPTimes) do begin
      zSuperMedicaHPTimes[I] := 4000;
    end;
    //zSuperMedicaHPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(zSuperMedicaHPTicks, SizeOf(zSuperMedicaHPTicks), 0);
    //zSuperMedicaHPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(zSuperMedicaMPs, SizeOf(zSuperMedicaMPs), 0);
    //zSuperMedicaMPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(zSuperMedicaMPTimes) to High(zSuperMedicaMPTimes) do begin
      zSuperMedicaMPTimes[I] := 4000;
    end;
    //zSuperMedicaMPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(zSuperMedicaMPTicks, SizeOf(zSuperMedicaMPTicks), 0);
    //zSuperMedicaMPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(fSuperMedicaUses, SizeOf(fSuperMedicaUses), #0);
    //fSuperMedicaUses:= (False, False, False, False, False, False, False, False, False);
    FillChar(fSuperMedicaHPs, SizeOf(fSuperMedicaHPs), 0);
    //fSuperMedicaHPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(fSuperMedicaHPTimes) to High(fSuperMedicaHPTimes) do begin
      fSuperMedicaHPTimes[I] := 4000;
    end;
    //fSuperMedicaHPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(fSuperMedicaHPTicks, SizeOf(fSuperMedicaHPTicks), 0);
    //fSuperMedicaHPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(fSuperMedicaMPs, SizeOf(fSuperMedicaMPs), 0);
    //fSuperMedicaMPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(fSuperMedicaMPTimes) to High(fSuperMedicaMPTimes) do begin
      fSuperMedicaMPTimes[I] := 4000;
    end;
    //fSuperMedicaMPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(fSuperMedicaMPTicks, SizeOf(fSuperMedicaMPTicks), 0);
    //fSuperMedicaMPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(dSuperMedicaUses, SizeOf(dSuperMedicaUses), #0);
    //dSuperMedicaUses:= (False, False, False, False, False, False, False, False, False);
    FillChar(dSuperMedicaHPs, SizeOf(dSuperMedicaHPs), 0);
    //dSuperMedicaHPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(dSuperMedicaHPTimes) to High(dSuperMedicaHPTimes) do begin
      dSuperMedicaHPTimes[I] := 4000;
    end;
    //dSuperMedicaHPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(dSuperMedicaHPTicks, SizeOf(dSuperMedicaHPTicks), 0);
    //dSuperMedicaHPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    FillChar(dSuperMedicaMPs, SizeOf(dSuperMedicaMPs), 0);
    //dSuperMedicaMPs:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    for I:=Low(dSuperMedicaMPTimes) to High(dSuperMedicaMPTimes) do begin
      dSuperMedicaMPTimes[I] := 4000;
    end;
    //dSuperMedicaMPTimes:= (4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000, 4000);
    FillChar(dSuperMedicaMPTicks, SizeOf(dSuperMedicaMPTicks), 0);
    //dSuperMedicaMPTicks:= (0, 0, 0, 0, 0, 0, 0, 0, 0);
    {$IFEND}
  end;
end;

procedure CreateSdoAssistant();//��ʼ��ʢ���ڹ�
begin
   with FrmDlg do begin
   //==========================ҩƷ
     ChangeProPage(m_btProPage);
   //==========================ҩƷ����
     DCheckBFilterItemPickUpAll.Checked := g_config.boAutoPuckUpItem;
     g_boAutoPuckUpItem := DCheckBFilterItemPickUpAll.Checked;

     DCheckSdoAvoidShift.Checked := g_config.boNoShift;
     g_boNoShift := DCheckSdoAvoidShift.Checked;

     DCheckSdoExpFiltrate.Checked := g_Config.boExpFiltrate ;
     g_boExpFiltrate := DCheckSdoExpFiltrate.Checked;

     DCheckSdoMapDesc.Checked := g_Config.boShowMimiMapDesc;
     g_boShowMimiMapDesc := DCheckSdoMapDesc.Checked;

     DCheckShowHeroStateNumber.Checked := g_Config.boShowHeroStateNumber;
     g_boShowHeroStateNumber := DCheckShowHeroStateNumber.Checked;

     DCheckSdoNameShow.Checked := g_config.boShowName;
     g_boShowName := DCheckSdoNameShow.Checked;

     DCheckSdoDuraWarning.Checked := g_config.boDuraWarning;
     g_boDuraWarning := DCheckSdoDuraWarning.Checked;

     DCheckSdoLongHit.Checked:= g_config.boLongHit;
     g_boLongHit := DCheckSdoLongHit.Checked;

     DCheckSdoPosLongHit.Checked := g_Config.boPosLongHit;
     g_boPosLongHit := DCheckSdoPosLongHit.Checked;

     DCheckSdoAutoWideHit.Checked := g_config.boAutoWideHit;
     g_boAutoWideHit := DCheckSdoAutoWideHit.Checked;

     DCheckSdoAutoFireHit.Checked := g_config.boAutoFireHit;
     g_boAutoFireHit := DCheckSdoAutoFireHit.Checked;

     DCheckSdoZhuri.Checked := g_config.boAutoZhuRiHit;
     g_boAutoZhuRiHit := DCheckSdoZhuri.Checked;

     DCheckSdoAutoShield.Checked := g_config.boAutoShield;
     g_boAutoShield := DCheckSdoAutoShield.Checked;

     DCheckSdoHeroShield.Checked := g_Config.boHeroAutoShield;
     g_boHeroAutoDEfence := DCheckSdoHeroShield.Checked;

     DCheckShowSpecialDamage.Checked := g_Config.boShowSpecialDamage;
     g_boShowSpecialDamage := DCheckShowSpecialDamage.Checked;
     {$IF M2Version <> 2}
     DCheckAutoDragInBody.Checked := g_Config.boAutoDragInBody;
     g_boAutoDragInBody := DCheckAutoDragInBody.Checked;
     DCheckHideHumanWing.Checked := g_Config.boHideHumanWing;
     g_boHideHumanWing := DCheckHideHumanWing.Checked;
     DCheckHideWeaponEffect.Checked := g_Config.boHideWeaponEffect;
     g_boHideWeaponEffect := DCheckHideWeaponEffect.Checked;
     {$IFEND}
     DCheckSdoAutoHide.Checked := g_config.boAutoHide;
     g_boAutoHide := DCheckSdoAutoHide.Checked;

     DCheckSdoAutoMagic.Checked := g_config.boAutoMagic;
     g_boAutoMagic := DCheckSdoAutoMagic.Checked;

     DEdtSdoAutoMagicTimer.Text := IntToStr(g_config.nAutoMagicTime);
     DEdtSdoCommonHpChange(DEdtSdoAutoMagicTimer);

     DCheckSdoAutoDrinkWine.Checked := g_Config.boAutoEatWine;
     g_boAutoEatWine := DCheckSdoAutoDrinkWine.Checked;

     DEdtSdoDrunkWineDegree.Text := IntToStr(g_Config.btEditWine);
     DEdtSdoCommonHpChange(DEdtSdoDrunkWineDegree);

     DCheckSdoHeroAutoDrinkWine.Checked := g_Config.boAutoEatHeroWine;
     g_boAutoEatHeroWine := DCheckSdoHeroAutoDrinkWine.Checked;

     DEdtSdoHeroDrunkWineDegree.Text := IntToStr(g_Config.btEditHeroWine);
     DEdtSdoCommonHpChange(DEdtSdoHeroDrunkWineDegree);

     DCheckSdoAutoDrinkDrugWine.Checked := g_Config.boAutoEatDrugWine;
     g_boAutoEatDrugWine := DCheckSdoAutoDrinkDrugWine.Checked;

     DEdtSdoDrunkDrugWineDegree.Text := IntToStr(g_Config.btEditDrugWine);
     DEdtSdoCommonHpChange(DEdtSdoDrunkDrugWineDegree);

     DCheckSdoHeroAutoDrinkDrugWine.Checked := g_Config.boAutoEatHeroDrugWine;
     g_boAutoEatHeroDrugWine := DCheckSdoHeroAutoDrinkDrugWine.Checked;

     DEdtSdoHeroDrunkDrugWineDegree.Text := IntToStr(g_Config.btEditHeroDrugWine);
     DEdtSdoCommonHpChange(DEdtSdoHeroDrunkDrugWineDegree);

     DEdtSdoExpFiltrate.Text := IntToStr(g_Config.dwEditExpFiltrate);
     DEdtSdoCommonHpChange(DEdtSdoExpFiltrate);


     //HotKey
     with frmMain do begin
       ActSeriesKillKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActCallHeroKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActCallHero1Key.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActHeroAttackTargetKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActHeroGotethKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActHeroStateKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActHeroGuardKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActAttackModeKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
       ActMinMapKey.Enabled := FrmDlg.DCheckSdoStartKey.Checked;
     end;
     FrmDlg.DBtnSdoSeriesKillKey.Hint := ShortCutToText(frmMain.ActSeriesKillKey.ShortCut);
     FrmDlg.DBtnSdoCallHeroKey.Hint := ShortCutToText(frmMain.ActCallHeroKey.ShortCut);
     FrmDlg.DBtnSdoCallHero1Key.Hint := ShortCutToText(frmMain.ActCallHero1Key.ShortCut);
     FrmDlg.DBtnSdoHeroAttackTargetKey.Hint := ShortCutToText(frmMain.ActHeroAttackTargetKey.ShortCut);
     FrmDlg.DBtnSdoHeroGotethKey.Hint := ShortCutToText(frmMain.ActHeroGotethKey.ShortCut);
     FrmDlg.DBtnSdoHeroStateKey.Hint := ShortCutToText(frmMain.ActHeroStateKey.ShortCut);
     FrmDlg.DBtnSdoHeroGuardKey.Hint  := ShortCutToText(frmMain.ActHeroGuardKey.ShortCut);
     FrmDlg.DBtnSdoAttackModeKey.Hint := ShortCutToText(frmMain.ActAttackModeKey.ShortCut);
     FrmDlg.DBtnSdoMinMapKey.Hint := ShortCutToText(frmMain.ActMinMapKey.ShortCut);
   end;
end;
procedure LoadSdoAssistantConfig(sUserName:String);//����ʢ�������
  {procedure InitializeRecord(out ARecord; count: Integer);
  begin
    FillChar(ARecord, count, #0);
  end; }
var
  Ini: TMemIniFile;//TIniFile;
  sFileName: String;
  I, LoadInteger: Integer;
begin
  if sUserName <> '' then sFileName := g_ParamDir+format(SDOCONFIGFILE,[g_sServerName,sUserName,'SdoAssistant'])
    else sFileName:=g_ParamDir+format(CONFIGFILE,['Assistant']);
  if not DirectoryExists(g_ParamDir+'config') then  CreateDir(g_ParamDir+'config');
  if not DirectoryExists(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,sUserName])) then
    CreateDir(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,sUserName]));
  InitConfig;
  //InitializeRecord(g_Config, SizeOf(TConfig));
  Ini:={TIniFile}TMemIniFile.Create(sFileName);
  try
    //if Ini.ReadInteger('Assistant', 'AutoPuckUpItem', -1) < 0 then Ini.WriteBool('Assistant', 'AutoPuckUpItem', True);
    g_Config.boAutoPuckUpItem := Ini.ReadBool('Assistant', 'AutoPuckUpItem', g_Config.boAutoPuckUpItem);

    //if Ini.ReadInteger('Assistant', 'NoShift', -1) < 0 then Ini.WriteBool('Assistant', 'NoShift', False);
    g_Config.boNoShift := Ini.ReadBool('Assistant', 'NoShift', g_Config.boNoShift);

    //if Ini.ReadInteger('Assistant', 'ExpFiltrate', -1) < 0 then Ini.WriteBool('Assistant', 'ExpFiltrate', False);
    g_Config.boExpFiltrate := Ini.ReadBool('Assistant', 'ExpFiltrate', g_Config.boExpFiltrate);

    //if Ini.ReadInteger('Assistant', 'ShowMimiMapDesc', -1) < 0 then Ini.WriteBool('Assistant', 'ShowMimiMapDesc', False);
    g_Config.boShowMimiMapDesc := Ini.ReadBool('Assistant', 'ShowMimiMapDesc', g_Config.boShowMimiMapDesc);

    //if Ini.ReadInteger('Assistant', 'ShowHeroStateNumber', -1) < 0 then Ini.WriteBool('Assistant', 'ShowHeroStateNumber', False);
    g_Config.boShowHeroStateNumber := Ini.ReadBool('Assistant', 'ShowHeroStateNumber', g_Config.boShowHeroStateNumber);

    //if Ini.ReadInteger('Assistant', 'ShowName', -1) < 0 then Ini.WriteBool('Assistant', 'ShowName', False);
    g_Config.boShowName := Ini.ReadBool('Assistant', 'ShowName', g_Config.boShowName);

    //if Ini.ReadInteger('Assistant', 'DuraWarning', -1) < 0 then Ini.WriteBool('Assistant', 'DuraWarning', True);
    g_Config.boDuraWarning := Ini.ReadBool('Assistant', 'DuraWarning', g_Config.boDuraWarning);

    //if Ini.ReadInteger('Assistant', 'LongHit', -1) < 0 then Ini.WriteBool('Assistant', 'LongHit', False);
    g_Config.boLongHit := Ini.ReadBool('Assistant', 'LongHit', g_Config.boLongHit);

    g_Config.boPosLongHit := Ini.ReadBool('Assistant', 'PosLongHit', g_Config.boPosLongHit);

    //if Ini.ReadInteger('Assistant', 'AutoWideHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoWideHit', False);
    g_Config.boAutoWideHit := Ini.ReadBool('Assistant', 'AutoWideHit', g_Config.boAutoWideHit);

    //if Ini.ReadInteger('Assistant', 'AutoFireHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoFireHit', False);
    g_Config.boAutoFireHit := Ini.ReadBool('Assistant', 'AutoFireHit', g_Config.boAutoFireHit);

    //if Ini.ReadInteger('Assistant', 'AutoZhuriHit', -1) < 0 then Ini.WriteBool('Assistant', 'AutoZhuriHit', False);
    g_Config.boAutoZhuriHit := Ini.ReadBool('Assistant', 'AutoZhuriHit', g_Config.boAutoZhuriHit);

    //if Ini.ReadInteger('Assistant', 'AutoShield', -1) < 0 then Ini.WriteBool('Assistant', 'AutoShield', False);
    g_Config.boAutoShield := Ini.ReadBool('Assistant', 'AutoShield', g_Config.boAutoShield);

    //if Ini.ReadInteger('Assistant', 'HeroAutoShield', -1) < 0 then Ini.WriteBool('Assistant', 'HeroAutoShield', False);
    g_Config.boHeroAutoShield := Ini.ReadBool('Assistant', 'HeroAutoShield', g_Config.boHeroAutoShield);

    //if Ini.ReadInteger('Assistant', 'AutoHide', -1) < 0 then Ini.WriteBool('Assistant', 'AutoHide', False);
    g_Config.boAutoHide := Ini.ReadBool('Assistant', 'AutoHide', g_Config.boAutoHide);

    //if Ini.ReadInteger('Assistant', 'AutoMagic', -1) < 0 then Ini.WriteBool('Assistant', 'AutoMagic', False);
    g_Config.boAutoMagic := Ini.ReadBool('Assistant', 'AutoMagic', g_Config.boAutoMagic);

    {LoadInteger := Ini.ReadInteger('Assistant', 'AutoMagicTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'AutoMagicTime', g_Config.nAutoMagicTime);
    end else begin}
      g_Config.nAutoMagicTime := Ini.ReadInteger('Assistant', 'AutoMagicTime', g_Config.nAutoMagicTime);
    //end;
    {$IF M2Version <> 2}
    //if Ini.ReadInteger('Assistant', 'AutoDragInBody', -1) < 0 then Ini.WriteBool('Assistant', 'AutoDragInBody', False);
    g_Config.boAutoDragInBody := Ini.ReadBool('Assistant', 'AutoDragInBody', g_Config.boAutoDragInBody);
    //if Ini.ReadInteger('Assistant', 'HideHumanWing', -1) < 0 then Ini.WriteBool('Assistant', 'HideHumanWing', False);
    g_Config.boHideHumanWing := Ini.ReadBool('Assistant', 'HideHumanWing', g_Config.boHideHumanWing);
    //if Ini.ReadInteger('Assistant', 'HideWeaponEffect', -1) < 0 then Ini.WriteBool('Assistant', 'HideWeaponEffect', False);
    g_Config.boHideWeaponEffect := Ini.ReadBool('Assistant', 'HideWeaponEffect', g_Config.boHideWeaponEffect);
    {$IFEND}

    //if Ini.ReadInteger('Assistant', 'HumanWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HumanWineIsAuto', False);
    g_Config.boAutoEatWine := Ini.ReadBool('Assistant', 'HumanWineIsAuto', g_Config.boAutoEatWine);

    //if Ini.ReadInteger('Assistant', 'HeroWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HeroWineIsAuto', False);
    g_Config.boAutoEatHeroWine := Ini.ReadBool('Assistant', 'HeroWineIsAuto', g_Config.boAutoEatHeroWine);

    //if Ini.ReadInteger('Assistant', 'HumanMedicateWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HumanMedicateWineIsAuto', False);
    g_Config.boAutoEatDrugWine := Ini.ReadBool('Assistant', 'HumanMedicateWineIsAuto', g_Config.boAutoEatDrugWine);

    //if Ini.ReadInteger('Assistant', 'HeroMedicateWineIsAuto', -1) < 0 then Ini.WriteBool('Assistant', 'HeroMedicateWineIsAuto', False);
    g_Config.boAutoEatHeroDrugWine := Ini.ReadBool('Assistant', 'HeroMedicateWineIsAuto', g_Config.boAutoEatHeroDrugWine);

    {LoadInteger := Ini.ReadInteger('Assistant', 'HumanWinePercent', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HumanWinePercent', g_Config.btEditWine);
    end else begin}
      g_Config.btEditWine := Ini.ReadInteger('Assistant', 'HumanWinePercent', g_Config.btEditWine);
    //end;

    {LoadInteger := Ini.ReadInteger('Assistant', 'HeroWinePercent', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HeroWinePercent', g_Config.btEditHeroWine);
    end else begin}
      g_Config.btEditHeroWine := Ini.ReadInteger('Assistant', 'HeroWinePercent', g_Config.btEditHeroWine);
    //end;

    {LoadInteger := Ini.ReadInteger('Assistant', 'HumanMedicateWineTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HumanMedicateWineTime', g_Config.btEditDrugWine);
    end else begin}
      g_Config.btEditDrugWine := Ini.ReadInteger('Assistant', 'HumanMedicateWineTime', g_Config.btEditDrugWine);
    //end;

    {LoadInteger := Ini.ReadInteger('Assistant', 'HeroMedicateWineTime', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'HeroMedicateWineTime', g_Config.btEditHeroDrugWine);
    end else begin    }
      g_Config.btEditHeroDrugWine := Ini.ReadInteger('Assistant', 'HeroMedicateWineTime', g_Config.btEditHeroDrugWine);
    //end;

    {LoadInteger := Ini.ReadInteger('Assistant', 'EdtExpFiltrate', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Assistant', 'EdtExpFiltrate', g_Config.dwEditExpFiltrate);
    end else begin   }
      g_Config.dwEditExpFiltrate := Ini.ReadInteger('Assistant', 'EdtExpFiltrate', g_Config.dwEditExpFiltrate);
    //end;

    //����
    //if Ini.ReadInteger('Misc', 'PlaySound', -1) < 0 then Ini.WriteBool('Misc', 'PlaySound', True);
    g_boSound := Ini.ReadBool('Misc', 'PlaySound', g_boSound);

    //HotKey
    //if Ini.ReadInteger('Hotkey', 'UseHotkey', -1) < 0 then Ini.WriteBool('Hotkey', 'UseHotkey', False);
    FrmDlg.DCheckSdoStartKey.Checked := Ini.ReadBool('Hotkey', 'UseHotkey', False);

   { LoadInteger := Ini.ReadInteger('Hotkey', 'HeroCallHero', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'HeroCallHero', 0);
    end else begin     }
      frmMain.ActSeriesKillKey.ShortCut := Ini.ReadInteger('Hotkey', 'Serieskill', 0);
      frmMain.ActCallHeroKey.ShortCut := Ini.ReadInteger('Hotkey', 'HeroCallHero', 0);
      frmMain.ActCallHero1Key.ShortCut := Ini.ReadInteger('Hotkey', 'HeroCallHero1', 0);
    //end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'Serieskill', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'Serieskill', 0);
    end else begin  }
   // end;
   { LoadInteger := Ini.ReadInteger('Hotkey', 'HeroSetTarget', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'HeroSetTarget', 0);
    end else begin    }
      frmMain.ActHeroAttackTargetKey.ShortCut := Ini.ReadInteger('Hotkey', 'HeroSetTarget', 0);
    //end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'HeroUnionHit', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'HeroUnionHit', 0);
    end else begin    }
      frmMain.ActHeroGotethKey.ShortCut := Ini.ReadInteger('Hotkey', 'HeroUnionHit', 0);
    //end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'HeroSetAttackState', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'HeroSetAttackState', 0);
    end else begin   }
      frmMain.ActHeroStateKey.ShortCut := Ini.ReadInteger('Hotkey', 'HeroSetAttackState', 0);
   // end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'HeroSetGuard', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'HeroSetGuard', 0);
    end else begin  }
      frmMain.ActHeroGuardKey.ShortCut := Ini.ReadInteger('Hotkey', 'HeroSetGuard', 0);
   // end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'SwitchAttackMode', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'SwitchAttackMode', 0);
    end else begin  }
      frmMain.ActAttackModeKey.ShortCut := Ini.ReadInteger('Hotkey', 'SwitchAttackMode', 0);
    //end;
    {LoadInteger := Ini.ReadInteger('Hotkey', 'SwitchMiniMap', -1);
    if LoadInteger < 0 then begin
      Ini.WriteInteger('Hotkey', 'SwitchMiniMap', 0);
    end else begin  }
      frmMain.ActMinMapKey.ShortCut := Ini.ReadInteger('Hotkey', 'SwitchMiniMap', 0);
   // end;
    g_Config.boHp1Chk := Ini.ReadBool('Protect', 'Hp1Chk', g_Config.boHp1Chk);
    g_Config.wHp1Hp := Ini.ReadInteger('Protect', 'Hp1Hp', g_Config.wHp1Hp);
    g_Config.btHp1Man := Ini.ReadInteger('Protect', 'Hp1Man', g_Config.btHp1Man);
    g_Config.boMp1Chk := Ini.ReadBool('Protect', 'Mp1Chk', g_Config.boMp1Chk);
    g_Config.wMp1Mp := Ini.ReadInteger('Protect', 'Mp1Mp', g_Config.wMp1Mp);
    g_Config.btMp1Man := Ini.ReadInteger('Protect', 'Mp1Man', g_Config.btMp1Man);
    g_Config.boRenewHPIsAuto := Ini.ReadBool('Protect', 'RenewHPIsAuto', g_Config.boRenewHPIsAuto);
    g_Config.wRenewHPTime := Ini.ReadInteger('Protect', 'RenewHPTime', g_Config.wRenewHPTime);
    g_Config.wRenewHPPercent := Ini.ReadInteger('Protect', 'RenewHPPercent', g_Config.wRenewHPPercent);
    g_Config.boRenewMPIsAuto := Ini.ReadBool('Protect', 'RenewMPIsAuto', g_Config.boRenewMPIsAuto);
    g_Config.wRenewMPTime := Ini.ReadInteger('Protect', 'RenewMPTime', g_Config.wRenewMPTime);
    g_Config.wRenewMPPercent := Ini.ReadInteger('Protect', 'RenewMPPercent', g_Config.wRenewMPPercent);
    g_Config.boRenewSpecialHPIsAuto := Ini.ReadBool('Protect', 'RenewSpecialHPIsAuto', g_Config.boRenewSpecialHPIsAuto);
    g_Config.wRenewSpecialHPTime := Ini.ReadInteger('Protect', 'RenewSpecialHPTime', g_Config.wRenewSpecialHPTime);
    g_Config.wRenewSpecialHPPercent := Ini.ReadInteger('Protect', 'RenewSpecialHPPercent', g_Config.wRenewSpecialHPPercent);
    g_Config.boRenewSpecialMpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialMpIsAuto', g_Config.boRenewSpecialMpIsAuto);
    g_Config.wRenewSpecialMpTime := Ini.ReadInteger('Protect', 'RenewSpecialMpTime', g_Config.wRenewSpecialMpTime);
    g_Config.wRenewSpecialMpPercent := Ini.ReadInteger('Protect', 'RenewSpecialMpPercent', g_Config.wRenewSpecialMpPercent);
    g_Config.BoUseSuperMedica := Ini.ReadBool('Protect', 'BoUseSuperMedica', g_Config.BoUseSuperMedica);
    for I:=Low(g_Config.SuperMedicaUses) to High(g_Config.SuperMedicaUses) do begin
      g_Config.SuperMedicaUses[I] := Ini.ReadBool('Protect', g_Config.SuperMedicaItemNames[I] + 'BoUse', g_Config.SuperMedicaUses[I]);
      g_Config.SuperMedicaHPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'Hp', g_Config.SuperMedicaHPs[I]);
      g_Config.SuperMedicaHPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HpTime', g_Config.SuperMedicaHPTimes[I]);
      g_Config.SuperMedicaMPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'Mp', g_Config.SuperMedicaMPs[I]);
      g_Config.SuperMedicaMPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'MpTime', g_Config.SuperMedicaMPTimes[I]);
    end;
    {$IF M2Version <> 2}
    g_Config.boHp2Chk := Ini.ReadBool('Protect', 'Hp2Chk', g_Config.boHp2Chk);
    g_Config.wHp2Hp := Ini.ReadInteger('Protect', 'Hp2Hp', g_Config.wHp2Hp);
    //g_Config.btHp2Man := Ini.ReadInteger('Protect', 'Hp2Man', g_Config.btHp2Man);
    g_Config.boMp2Chk := Ini.ReadBool('Protect', 'Mp2Chk', g_Config.boMp2Chk);
    g_Config.wMp2Mp := Ini.ReadInteger('Protect', 'Mp2Mp', g_Config.wMp2Mp);
    //g_Config.btMp2Man := Ini.ReadInteger('Protect', 'Mp2Man', g_Config.btMp2Man);
    g_Config.boHp3Chk := Ini.ReadBool('Protect', 'Hp3Chk', g_Config.boHp3Chk);
    g_Config.wHp3Hp := Ini.ReadInteger('Protect', 'Hp3Hp', g_Config.wHp3Hp);
    //g_Config.btHp3Man := Ini.ReadInteger('Protect', 'Hp3Man', g_Config.btHp3Man);
    g_Config.boMp3Chk := Ini.ReadBool('Protect', 'Mp3Chk', g_Config.boMp3Chk);
    g_Config.wMp3Mp := Ini.ReadInteger('Protect', 'Mp3Mp', g_Config.wMp3Mp);
    //g_Config.btMp3Man := Ini.ReadInteger('Protect', 'Mp3Man', g_Config.btMp3Man);
    g_Config.boHp4Chk := Ini.ReadBool('Protect', 'Hp4Chk', g_Config.boHp4Chk);
    g_Config.wHp4Hp := Ini.ReadInteger('Protect', 'Hp4Hp', g_Config.wHp4Hp);
    //g_Config.btHp4Man := Ini.ReadInteger('Protect', 'Hp4Man', g_Config.btHp4Man);
    g_Config.boMp4Chk := Ini.ReadBool('Protect', 'Mp4Chk', g_Config.boMp4Chk);
    g_Config.wMp4Mp := Ini.ReadInteger('Protect', 'Mp4Mp', g_Config.wMp4Mp);
    //g_Config.btMp4Man := Ini.ReadInteger('Protect', 'Mp4Man', g_Config.btMp4Man);
    g_Config.boHp5Chk := Ini.ReadBool('Protect', 'Hp5Chk', g_Config.boHp5Chk);
    g_Config.wHp5Hp := Ini.ReadInteger('Protect', 'Hp5Hp', g_Config.wHp5Hp);
    //g_Config.btHp5Man := Ini.ReadInteger('Protect', 'Hp5Man', g_Config.btHp5Man);
    g_Config.boMp5Chk := Ini.ReadBool('Protect', 'Mp5Chk', g_Config.boMp5Chk);
    g_Config.wMp5Mp := Ini.ReadInteger('Protect', 'Mp5Hp', g_Config.wMp5Mp);
    //g_Config.btMp5Man := Ini.ReadInteger('Protect', 'Mp5Man', g_Config.btMp5Man);
    g_Config.boRenewHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewHeroNormalHpIsAuto', g_Config.boRenewHeroNormalHpIsAuto);
    g_Config.wRenewHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewHeroNormalHpTime', g_Config.wRenewHeroNormalHpTime);
    g_Config.wRenewHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewHeroNormalHpPercent', g_Config.wRenewHeroNormalHpPercent);
    g_Config.boRenewzHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewzHeroNormalHpIsAuto', g_Config.boRenewzHeroNormalHpIsAuto);
    g_Config.wRenewzHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewzHeroNormalHpTime', g_Config.wRenewzHeroNormalHpTime);
    g_Config.wRenewzHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewzHeroNormalHpPercent', g_Config.wRenewzHeroNormalHpPercent);
    g_Config.boRenewfHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewfHeroNormalHpIsAuto', g_Config.boRenewfHeroNormalHpIsAuto);
    g_Config.wRenewfHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewfHeroNormalHpTime', g_Config.wRenewfHeroNormalHpTime);
    g_Config.wRenewfHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewfHeroNormalHpPercent', g_Config.wRenewfHeroNormalHpPercent);
    g_Config.boRenewdHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewdHeroNormalHpIsAuto', g_Config.boRenewdHeroNormalHpIsAuto);
    g_Config.wRenewdHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewdHeroNormalHpTime', g_Config.wRenewdHeroNormalHpTime);
    g_Config.wRenewdHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewdHeroNormalHpPercent', g_Config.wRenewdHeroNormalHpPercent);

    g_Config.boRenewHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewHeroNormalMpIsAuto', g_Config.boRenewHeroNormalMpIsAuto);
    g_Config.wRenewHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewHeroNormalMpTime', g_Config.wRenewHeroNormalMpTime);
    g_Config.wRenewHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewHeroNormalMpPercent', g_Config.wRenewHeroNormalMpPercent);
    g_Config.boRenewzHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewzHeroNormalMpIsAuto', g_Config.boRenewzHeroNormalMpIsAuto);
    g_Config.wRenewzHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewzHeroNormalMpTime', g_Config.wRenewzHeroNormalMpTime);
    g_Config.wRenewzHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewzHeroNormalMpPercent', g_Config.wRenewzHeroNormalMpPercent);
    g_Config.boRenewfHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewfHeroNormalMpIsAuto', g_Config.boRenewfHeroNormalMpIsAuto);
    g_Config.wRenewfHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewfHeroNormalMpTime', g_Config.wRenewfHeroNormalMpTime);
    g_Config.wRenewfHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewfHeroNormalMpPercent', g_Config.wRenewfHeroNormalMpPercent);
    g_Config.boRenewdHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewdHeroNormalMpIsAuto', g_Config.boRenewdHeroNormalMpIsAuto);
    g_Config.wRenewdHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewdHeroNormalMpTime', g_Config.wRenewdHeroNormalMpTime);
    g_Config.wRenewdHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewdHeroNormalMpPercent', g_Config.wRenewdHeroNormalMpPercent);

    g_Config.boRenewSpecialHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialHeroNormalHpIsAuto', g_Config.boRenewSpecialHeroNormalHpIsAuto);
    g_Config.wRenewSpecialHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewSpecialHeroNormalHpTime', g_Config.wRenewSpecialHeroNormalHpTime);
    g_Config.wRenewSpecialHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewSpecialHeroNormalHpPercent', g_Config.wRenewSpecialHeroNormalHpPercent);
    g_Config.boRenewSpecialzHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialzHeroNormalHpIsAuto', g_Config.boRenewSpecialzHeroNormalHpIsAuto);
    g_Config.wRenewSpecialzHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewSpecialzHeroNormalHpTime', g_Config.wRenewSpecialzHeroNormalHpTime);
    g_Config.wRenewSpecialzHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewSpecialzHeroNormalHpPercent', g_Config.wRenewSpecialzHeroNormalHpPercent);
    g_Config.boRenewSpecialfHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialfHeroNormalHpIsAuto', g_Config.boRenewSpecialfHeroNormalHpIsAuto);
    g_Config.wRenewSpecialfHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewSpecialfHeroNormalHpTime', g_Config.wRenewSpecialfHeroNormalHpTime);
    g_Config.wRenewSpecialfHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewSpecialfHeroNormalHpPercent', g_Config.wRenewSpecialfHeroNormalHpPercent);
    g_Config.boRenewSpecialdHeroNormalHpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialdHeroNormalHpIsAuto', g_Config.boRenewSpecialdHeroNormalHpIsAuto);
    g_Config.wRenewSpecialdHeroNormalHpTime := Ini.ReadInteger('Protect', 'RenewSpecialdHeroNormalHpTime', g_Config.wRenewSpecialdHeroNormalHpTime);
    g_Config.wRenewSpecialdHeroNormalHpPercent := Ini.ReadInteger('Protect', 'RenewSpecialdHeroNormalHpPercent', g_Config.wRenewSpecialdHeroNormalHpPercent);

    g_Config.boRenewSpecialHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialHeroNormalMpIsAuto', g_Config.boRenewSpecialHeroNormalMpIsAuto);
    g_Config.wRenewSpecialHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewSpecialHeroNormalMpTime', g_Config.wRenewSpecialHeroNormalMpTime);
    g_Config.wRenewSpecialHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewSpecialHeroNormalMpPercent', g_Config.wRenewSpecialHeroNormalMpPercent);
    g_Config.boRenewSpecialzHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialzHeroNormalMpIsAuto', g_Config.boRenewSpecialzHeroNormalMpIsAuto);
    g_Config.wRenewSpecialzHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewSpecialzHeroNormalMpTime', g_Config.wRenewSpecialzHeroNormalMpTime);
    g_Config.wRenewSpecialzHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewSpecialzHeroNormalMpPercent', g_Config.wRenewSpecialzHeroNormalMpPercent);
    g_Config.boRenewSpecialfHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialfHeroNormalMpIsAuto', g_Config.boRenewSpecialfHeroNormalMpIsAuto);
    g_Config.wRenewSpecialfHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewSpecialfHeroNormalMpTime', g_Config.wRenewSpecialfHeroNormalMpTime);
    g_Config.wRenewSpecialfHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewSpecialfHeroNormalMpPercent', g_Config.wRenewSpecialfHeroNormalMpPercent);
    g_Config.boRenewSpecialdHeroNormalMpIsAuto := Ini.ReadBool('Protect', 'RenewSpecialdHeroNormalMpIsAuto', g_Config.boRenewSpecialdHeroNormalMpIsAuto);
    g_Config.wRenewSpecialdHeroNormalMpTime := Ini.ReadInteger('Protect', 'RenewSpecialdHeroNormalMpTime', g_Config.wRenewSpecialdHeroNormalMpTime);
    g_Config.wRenewSpecialdHeroNormalMpPercent := Ini.ReadInteger('Protect', 'RenewSpecialdHeroNormalMpPercent', g_Config.wRenewSpecialdHeroNormalMpPercent);
    g_Config.hBoUseSuperMedica := Ini.ReadBool('Protect', 'hBoUseSuperMedica', g_Config.hBoUseSuperMedica);
    g_Config.zBoUseSuperMedica := Ini.ReadBool('Protect', 'zBoUseSuperMedica', g_Config.zBoUseSuperMedica);
    g_Config.fBoUseSuperMedica := Ini.ReadBool('Protect', 'fBoUseSuperMedica', g_Config.fBoUseSuperMedica);
    g_Config.dBoUseSuperMedica := Ini.ReadBool('Protect', 'dBoUseSuperMedica', g_Config.dBoUseSuperMedica);

    for I:=Low(g_Config.hSuperMedicaUses) to High(g_Config.hSuperMedicaUses) do begin
      g_Config.hSuperMedicaUses[I] := Ini.ReadBool('Protect', g_Config.SuperMedicaItemNames[I] + 'hBoUse', g_Config.hSuperMedicaUses[I]);
      g_Config.hSuperMedicaHPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroHp', g_Config.hSuperMedicaHPs[I]);
      g_Config.hSuperMedicaHPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroHpTime', g_Config.hSuperMedicaHPTimes[I]);
      g_Config.hSuperMedicaMPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroMp', g_Config.hSuperMedicaMPs[I]);
      g_Config.hSuperMedicaMPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroMpTime', g_Config.hSuperMedicaMPTimes[I]);
    end;
    for I:=Low(g_Config.zSuperMedicaUses) to High(g_Config.zSuperMedicaUses) do begin
      g_Config.zSuperMedicaUses[I] := Ini.ReadBool('Protect', g_Config.SuperMedicaItemNames[I] + 'zBoUse', g_Config.zSuperMedicaUses[I]);
      g_Config.zSuperMedicaHPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroHp', g_Config.zSuperMedicaHPs[I]);
      g_Config.zSuperMedicaHPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroHpTime', g_Config.zSuperMedicaHPTimes[I]);
      g_Config.zSuperMedicaMPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroMp', g_Config.zSuperMedicaMPs[I]);
      g_Config.zSuperMedicaMPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroMpTime', g_Config.zSuperMedicaMPTimes[I]);
    end;
    for I:=Low(g_Config.fSuperMedicaUses) to High(g_Config.fSuperMedicaUses) do begin
      g_Config.fSuperMedicaUses[I] := Ini.ReadBool('Protect', g_Config.SuperMedicaItemNames[I] + 'fBoUse', g_Config.fSuperMedicaUses[I]);
      g_Config.fSuperMedicaHPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroHp', g_Config.fSuperMedicaHPs[I]);
      g_Config.fSuperMedicaHPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroHpTime', g_Config.fSuperMedicaHPTimes[I]);
      g_Config.fSuperMedicaMPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroMp', g_Config.fSuperMedicaMPs[I]);
      g_Config.fSuperMedicaMPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroMpTime', g_Config.fSuperMedicaMPTimes[I]);
    end;
    for I:=Low(g_Config.dSuperMedicaUses) to High(g_Config.dSuperMedicaUses) do begin
      g_Config.dSuperMedicaUses[I] := Ini.ReadBool('Protect', g_Config.SuperMedicaItemNames[I] + 'dBoUse', g_Config.dSuperMedicaUses[I]);
      g_Config.dSuperMedicaHPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroHp', g_Config.dSuperMedicaHPs[I]);
      g_Config.dSuperMedicaHPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroHpTime', g_Config.dSuperMedicaHPTimes[I]);
      g_Config.dSuperMedicaMPs[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroMp', g_Config.dSuperMedicaMPs[I]);
      g_Config.dSuperMedicaMPTimes[I] := Ini.ReadInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroMpTime', g_Config.dSuperMedicaMPTimes[I]);
    end;
    {$IFEND}
    g_ShowItemList.LoadFormFile;
  finally
    Ini.Free;
    g_boLoadSdoAssistantConfig := True;
  end;
end;

procedure SaveSdoAssistantConfig(sUserName:String);//����ʢ�������
var
  Ini: TMemIniFile;//TIniFile;
  sFileName: String;
  I: Integer;
begin
  if sUserName <> '' then sFileName := g_ParamDir+format(SDOCONFIGFILE,[g_sServerName,sUserName,'SdoAssistant'])
    else sFileName:=g_ParamDir+format(CONFIGFILE,['Assistant']);

  if not DirectoryExists(g_ParamDir+'config') then  CreateDir(g_ParamDir+'config');

  if not DirectoryExists(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,sUserName])) then
    CreateDir(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,sUserName]));

  Ini:={TIniFile}TMemIniFile.Create(sFileName);

  Ini.WriteBool('Assistant', 'AutoPuckUpItem', g_boAutoPuckUpItem);
  Ini.WriteBool('Assistant', 'NoShift', g_boNoShift);
  Ini.WriteBool('Assistant', 'ExpFiltrate', g_boExpFiltrate);
  Ini.WriteBool('Assistant', 'ShowMimiMapDesc', g_boShowMimiMapDesc);
  Ini.WriteBool('Assistant', 'ShowHeroStateNumber', g_boShowHeroStateNumber);
  Ini.WriteBool('Assistant', 'ShowName', g_boShowName);
  Ini.WriteBool('Assistant', 'DuraWarning', g_boDuraWarning);

  Ini.WriteBool('Assistant', 'LongHit', g_boLongHit);
  Ini.WriteBool('Assistant', 'PosLongHit', g_boPosLongHit);
  Ini.WriteBool('Assistant', 'AutoWideHit', g_boAutoWideHit);
  Ini.WriteBool('Assistant', 'AutoFireHit', g_boAutoFireHit);
  Ini.WriteBool('Assistant', 'AutoZhuriHit', g_boAutoZhuriHit);
  Ini.WriteBool('Assistant', 'AutoShield', g_boAutoShield);
  Ini.WriteBool('Assistant', 'AutoHide', g_boAutoHide);
  Ini.WriteBool('Assistant', 'AutoMagic', g_boAutoMagic);
  Ini.WriteBool('Assistant', 'HeroAutoShield', g_boHeroAutoDEfence); //Ӣ�۳�������
  Ini.WriteBool('Assistant', 'ShowSpecialDamage', g_boShowSpecialDamage); //��ʾ�����˺�
  {$IF M2Version <> 2}
  Ini.WriteBool('Assistant', 'AutoDragInBody', g_boAutoDragInBody);
  Ini.WriteBool('Assistant', 'HideHumanWing', g_boHideHumanWing);
  Ini.WriteBool('Assistant', 'HideWeaponEffect', g_boHideWeaponEffect);
  {$IFEND}
  Ini.WriteInteger('Assistant', 'AutoMagicTime', g_nAutoMagicTime);

  Ini.WriteBool('Assistant', 'HumanWineIsAuto', g_boAutoEatWine);
  Ini.WriteBool('Assistant', 'HeroWineIsAuto', g_boAutoEatHeroWine);
  Ini.WriteBool('Assistant', 'HumanMedicateWineIsAuto', g_boAutoEatDrugWine);
  Ini.WriteBool('Assistant', 'HeroMedicateWineIsAuto', g_boAutoEatHeroDrugWine);
  Ini.WriteInteger('Assistant', 'HumanWinePercent', g_btEditWine);
  Ini.WriteInteger('Assistant', 'HeroWinePercent', g_btEditHeroWine);
  Ini.WriteInteger('Assistant', 'HumanMedicateWineTime', g_btEditDrugWine);
  Ini.WriteInteger('Assistant', 'HeroMedicateWineTime', g_btEditHeroDrugWine);
  Ini.WriteInteger('Assistant', 'EdtExpFiltrate', g_dwEditExpFiltrate);
  //HotKey
  Ini.WriteBool('Hotkey','UseHotkey', FrmDlg.DCheckSdoStartKey.Checked);
  Ini.WriteInteger('Hotkey','HeroCallHero', FrmMain.ActCallHeroKey.ShortCut);
  Ini.WriteInteger('Hotkey','HeroCallHero1', FrmMain.ActCallHero1Key.ShortCut);
  Ini.WriteInteger('Hotkey','Serieskill', FrmMain.ActSeriesKillKey.ShortCut);
  Ini.WriteInteger('Hotkey','HeroSetTarget', FrmMain.ActHeroAttackTargetKey.ShortCut);
  Ini.WriteInteger('Hotkey','HeroUnionHit', FrmMain.ActHeroGotethKey.ShortCut);
  Ini.WriteInteger('Hotkey','HeroSetAttackState', FrmMain.ActHeroStateKey.ShortCut);
  Ini.WriteInteger('Hotkey','HeroSetGuard', FrmMain.ActHeroGuardKey.ShortCut);
  Ini.WriteInteger('Hotkey','SwitchAttackMode', FrmMain.ActAttackModeKey.ShortCut);
  Ini.WriteInteger('Hotkey','SwitchMiniMap', FrmMain.ActMinMapKey.ShortCut);

  Ini.WriteBool('Protect', 'Hp1Chk', g_Config.boHp1Chk);
  Ini.WriteInteger('Protect', 'Hp1Hp', g_Config.wHp1Hp);
  Ini.WriteInteger('Protect', 'Hp1Man', g_Config.btHp1Man);
  Ini.WriteBool('Protect', 'Mp1Chk', g_Config.boMp1Chk);
  Ini.WriteInteger('Protect', 'Mp1Mp', g_Config.wMp1Mp);
  Ini.WriteInteger('Protect', 'Mp1Man', g_Config.btMp1Man);
  Ini.WriteBool('Protect', 'RenewHPIsAuto', g_Config.boRenewHPIsAuto);
  Ini.WriteInteger('Protect', 'RenewHPTime', g_Config.wRenewHPTime);
  Ini.WriteInteger('Protect', 'RenewHPPercent', g_Config.wRenewHPPercent);
  Ini.WriteBool('Protect', 'RenewMPIsAuto', g_Config.boRenewMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewMPTime', g_Config.wRenewMPTime);
  Ini.WriteInteger('Protect', 'RenewMPPercent', g_Config.wRenewMPPercent);
  Ini.WriteBool('Protect', 'RenewSpecialHPIsAuto', g_Config.boRenewSpecialHPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialHPTime', g_Config.wRenewSpecialHPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialHPPercent', g_Config.wRenewSpecialHPPercent);
  Ini.WriteBool('Protect', 'RenewSpecialMPIsAuto', g_Config.boRenewSpecialMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialMPTime', g_Config.wRenewSpecialMPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialMPPercent', g_Config.wRenewSpecialMPPercent);
  Ini.WriteBool('Protect', 'BoUseSuperMedica', g_Config.BoUseSuperMedica);
  for I:=Low(g_Config.SuperMedicaUses) to High(g_Config.SuperMedicaUses) do begin
    Ini.WriteBool('Protect', g_Config.SuperMedicaItemNames[I] + 'BoUse', g_Config.SuperMedicaUses[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'Hp', g_Config.SuperMedicaHPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HpTime', g_Config.SuperMedicaHPTimes[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'Mp', g_Config.SuperMedicaMPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'MpTime', g_Config.SuperMedicaMPTimes[I]);
  end;
  {$IF M2Version <> 2}
  Ini.WriteBool('Protect', 'Hp2Chk', g_Config.boHp2Chk);
  Ini.WriteInteger('Protect', 'Hp2Hp', g_Config.wHp2Hp);
  //Ini.WriteInteger('Protect', 'Hp2Man', g_Config.btHp2Man);
  Ini.WriteBool('Protect', 'Mp2Chk', g_Config.boMp2Chk);
  Ini.WriteInteger('Protect', 'Mp2Mp', g_Config.wMp2Mp);
  //Ini.WriteInteger('Protect', 'Mp2Man', g_Config.btMp2Man);
  Ini.WriteBool('Protect', 'Hp3Chk', g_Config.boHp3Chk);
  Ini.WriteInteger('Protect', 'Hp3Hp', g_Config.wHp3Hp);
  //Ini.WriteInteger('Protect', 'Hp3Man', g_Config.btHp3Man);
  Ini.WriteBool('Protect', 'Mp3Chk', g_Config.boMp3Chk);
  Ini.WriteInteger('Protect', 'Mp3Mp', g_Config.wMp3Mp);
  //Ini.WriteInteger('Protect', 'Mp3Man', g_Config.btMp3Man);
  Ini.WriteBool('Protect', 'Hp4Chk', g_Config.boHp4Chk);
  Ini.WriteInteger('Protect', 'Hp4Hp', g_Config.wHp4Hp);
  //Ini.WriteInteger('Protect', 'Hp4Man', g_Config.btHp4Man);
  Ini.WriteBool('Protect', 'Mp4Chk', g_Config.boMp4Chk);
  Ini.WriteInteger('Protect', 'Mp4Mp', g_Config.wMp4Mp);
  //Ini.WriteInteger('Protect', 'Mp4Man', g_Config.btMp4Man);
  Ini.WriteBool('Protect', 'Hp5Chk', g_Config.boHp5Chk);
  Ini.WriteInteger('Protect', 'Hp5Hp', g_Config.wHp5Hp);
  //Ini.WriteInteger('Protect', 'Hp5Man', g_Config.btHp5Man);
  Ini.WriteBool('Protect', 'Mp5Chk', g_Config.boMp5Chk);
  Ini.WriteInteger('Protect', 'Mp5Hp', g_Config.wMp5Mp);
  //Ini.WriteInteger('Protect', 'Mp5Man', g_Config.btMp5Man);
  Ini.WriteBool('Protect', 'RenewHeroNormalHpIsAuto', g_Config.boRenewHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewHeroNormalHpTime', g_Config.wRenewHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewHeroNormalHpPercent', g_Config.wRenewHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewzHeroNormalHpIsAuto', g_Config.boRenewzHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewzHeroNormalHpTime', g_Config.wRenewzHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewzHeroNormalHpPercent', g_Config.wRenewzHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewfHeroNormalHpIsAuto', g_Config.boRenewfHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewfHeroNormalHpTime', g_Config.wRenewfHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewfHeroNormalHpPercent', g_Config.wRenewfHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewdHeroNormalHpIsAuto', g_Config.boRenewdHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewdHeroNormalHpTime', g_Config.wRenewdHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewdHeroNormalHpPercent', g_Config.wRenewdHeroNormalHpPercent);

  Ini.WriteBool('Protect', 'RenewHeroNormalMpIsAuto', g_Config.boRenewHeroNormalMpIsAuto);
  Ini.WriteInteger('Protect', 'RenewHeroNormalMpTime', g_Config.wRenewHeroNormalMpTime);
  Ini.WriteInteger('Protect', 'RenewHeroNormalMpPercent', g_Config.wRenewHeroNormalMpPercent);
  Ini.WriteBool('Protect', 'RenewzHeroNormalMpIsAuto', g_Config.boRenewzHeroNormalMpIsAuto);
  Ini.WriteInteger('Protect', 'RenewzHeroNormalMpTime', g_Config.wRenewzHeroNormalMpTime);
  Ini.WriteInteger('Protect', 'RenewzHeroNormalMpPercent', g_Config.wRenewzHeroNormalMpPercent);
  Ini.WriteBool('Protect', 'RenewfHeroNormalMpIsAuto', g_Config.boRenewfHeroNormalMpIsAuto);
  Ini.WriteInteger('Protect', 'RenewfHeroNormalMpTime', g_Config.wRenewfHeroNormalMpTime);
  Ini.WriteInteger('Protect', 'RenewfHeroNormalMpPercent', g_Config.wRenewfHeroNormalMpPercent);
  Ini.WriteBool('Protect', 'RenewdHeroNormalMpIsAuto', g_Config.boRenewdHeroNormalMpIsAuto);
  Ini.WriteInteger('Protect', 'RenewdHeroNormalMpTime', g_Config.wRenewdHeroNormalMpTime);
  Ini.WriteInteger('Protect', 'RenewdHeroNormalMpPercent', g_Config.wRenewdHeroNormalMpPercent);
                                                                     
  Ini.WriteBool('Protect', 'RenewSpecialHeroNormalHpIsAuto', g_Config.boRenewSpecialHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialHeroNormalHpTime', g_Config.wRenewSpecialHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewSpecialHeroNormalHpPercent', g_Config.wRenewSpecialHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewSpecialzHeroNormalHpIsAuto', g_Config.boRenewSpecialzHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialzHeroNormalHpTime', g_Config.wRenewSpecialzHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewSpecialzHeroNormalHpPercent', g_Config.wRenewSpecialzHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewSpecialfHeroNormalHpIsAuto', g_Config.boRenewSpecialfHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialfHeroNormalHpTime', g_Config.wRenewSpecialfHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewSpecialfHeroNormalHpPercent', g_Config.wRenewSpecialfHeroNormalHpPercent);
  Ini.WriteBool('Protect', 'RenewSpecialdHeroNormalHpIsAuto', g_Config.boRenewSpecialdHeroNormalHpIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialdHeroNormalHpTime', g_Config.wRenewSpecialdHeroNormalHpTime);
  Ini.WriteInteger('Protect', 'RenewSpecialdHeroNormalHpPercent', g_Config.wRenewSpecialdHeroNormalHpPercent);

  Ini.WriteBool('Protect', 'RenewSpecialHeroNormalMPIsAuto', g_Config.boRenewSpecialHeroNormalMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialHeroNormalMPTime', g_Config.wRenewSpecialHeroNormalMPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialHeroNormalMPPercent', g_Config.wRenewSpecialHeroNormalMPPercent);
  Ini.WriteBool('Protect', 'RenewSpecialzHeroNormalMPIsAuto', g_Config.boRenewSpecialzHeroNormalMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialzHeroNormalMPTime', g_Config.wRenewSpecialzHeroNormalMPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialzHeroNormalMPPercent', g_Config.wRenewSpecialzHeroNormalMPPercent);
  Ini.WriteBool('Protect', 'RenewSpecialfHeroNormalMPIsAuto', g_Config.boRenewSpecialfHeroNormalMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialfHeroNormalMPTime', g_Config.wRenewSpecialfHeroNormalMPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialfHeroNormalMPPercent', g_Config.wRenewSpecialfHeroNormalMPPercent);
  Ini.WriteBool('Protect', 'RenewSpecialdHeroNormalMPIsAuto', g_Config.boRenewSpecialdHeroNormalMPIsAuto);
  Ini.WriteInteger('Protect', 'RenewSpecialdHeroNormalMPTime', g_Config.wRenewSpecialdHeroNormalMPTime);
  Ini.WriteInteger('Protect', 'RenewSpecialdHeroNormalMPPercent', g_Config.wRenewSpecialdHeroNormalMPPercent);

  Ini.WriteBool('Protect', 'hBoUseSuperMedica', g_Config.hBoUseSuperMedica);
  Ini.WriteBool('Protect', 'zBoUseSuperMedica', g_Config.zBoUseSuperMedica);
  Ini.WriteBool('Protect', 'fBoUseSuperMedica', g_Config.fBoUseSuperMedica);
  Ini.WriteBool('Protect', 'dBoUseSuperMedica', g_Config.dBoUseSuperMedica);
  for I:=Low(g_Config.hSuperMedicaUses) to High(g_Config.hSuperMedicaUses) do begin
    Ini.WriteBool('Protect', g_Config.SuperMedicaItemNames[I] + 'hBoUse', g_Config.hSuperMedicaUses[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroHp', g_Config.hSuperMedicaHPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroHpTime', g_Config.hSuperMedicaHPTimes[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroMp', g_Config.hSuperMedicaMPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'HeroMpTime', g_Config.hSuperMedicaMPTimes[I]);
  end;
  for I:=Low(g_Config.zSuperMedicaUses) to High(g_Config.zSuperMedicaUses) do begin
    Ini.WriteBool('Protect', g_Config.SuperMedicaItemNames[I] + 'zBoUse', g_Config.zSuperMedicaUses[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroHp', g_Config.zSuperMedicaHPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroHpTime', g_Config.zSuperMedicaHPTimes[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroMp', g_Config.zSuperMedicaMPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'zHeroMpTime', g_Config.zSuperMedicaMPTimes[I]);
  end;
  for I:=Low(g_Config.fSuperMedicaUses) to High(g_Config.fSuperMedicaUses) do begin
    Ini.WriteBool('Protect', g_Config.SuperMedicaItemNames[I] + 'fBoUse', g_Config.fSuperMedicaUses[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroHp', g_Config.fSuperMedicaHPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroHpTime', g_Config.fSuperMedicaHPTimes[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroMp', g_Config.fSuperMedicaMPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'fHeroMpTime', g_Config.fSuperMedicaMPTimes[I]);
  end;
  for I:=Low(g_Config.dSuperMedicaUses) to High(g_Config.dSuperMedicaUses) do begin
    Ini.WriteBool('Protect', g_Config.SuperMedicaItemNames[I] + 'dBoUse', g_Config.dSuperMedicaUses[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroHp', g_Config.dSuperMedicaHPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroHpTime', g_Config.dSuperMedicaHPTimes[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroMp', g_Config.dSuperMedicaMPs[I]);
    Ini.WriteInteger('Protect', g_Config.SuperMedicaItemNames[I] + 'dHeroMpTime', g_Config.dSuperMedicaMPTimes[I]);
  end;
  {$IFEND}
  Ini.UpdateFile; 
  Ini.Free;
end;
{******************************************************************************}

{******************************************************************************}
//���ܺ���
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


//����
function Encrypt(const s:string; skey:string):string;
var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;
begin
    hexS   :=myStrtoHex(s);
    hexskey:=myStrtoHex(skey);
    midS   :=hexS;
    for i:=1 to (length(hexskey) div 2)   do
    begin
        if i<>1 then midS:= tmpstr;
        tmpstr:='';
        for j:=1 to (length(midS) div 2) do
        begin
            a:=strtoint('$'+midS[2*j-1]+midS[2*j]);
            b:=strtoint('$'+hexskey[2*i-1]+hexskey[2*i]);
            c:=a xor b;
            tmpstr := tmpstr+myStrtoHex(chr(c));
        end;
    end;
    result := tmpstr;
end;

function decrypt(const s:string; skey:string):string;
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
{******************************************************************************}
//�ַ����ӽ��ܺ��� 20071225
Function SetDate(Text: String): String;
Var
  I     :Word;
  C     :Word;
Begin
  asm
    db $EB,$10,'VMProtect begin',0
  end;
    Result := '';
    For I := 1 To Length(Text) Do Begin
      C := Ord(Text[I]);
      Result := Result + Chr((C Xor 15));
    End;
  asm
    db $EB,$0E,'VMProtect end',0
  end;
End;
function DeGhost(Source, Key: string): string;
var
  Encode: TDCP_mars;
begin
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  try
    Result := '';
    Encode := TDCP_mars.Create(nil);
    Encode.InitStr(Key);
    Encode.Reset;
    Result := Encode.DecryptString(Source);
    Encode.Reset;
    Encode.Free;
  except
    Result := '';
  end;
  asm
    db $EB,$0E,'VMProtect end',0
  end;
end;
{******************************************************************************}
//��Կ
function CertKey(key: string): string;//���ܺ���
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
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  Result:='';
  for i:=1 to Length(S) do begin
     if (i mod Length(SeedString)) = 0 then
       j:=Length(SeedString)
     else j:=(i mod Length(SeedString));
     Asc:=Byte(S[i]) xor Byte(SeedString[j]);
     Result:=Result+IntToHex(Asc,3);
  end;
  asm
    db $EB,$0E,'VMProtect end',0
  end;
end;

function DecodeString_RC6(Source, Key: string): string;
var
  Encode: TDCP_rc6;
begin
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  try
    Result := '';
    Encode := TDCP_rc6.Create(nil);
    Encode.InitStr(Key);
    Encode.Reset;
    Result := Encode.DecryptString(Source);
    Encode.Reset;
    Encode.Free;
  except
    Result := '';
  end;
  asm
    db $EB,$0E,'VMProtect end',0
  end;
end;
procedure SeqNumEnc(var Str: String; Key: Word; Times: Integer);
var
  i,c,n:Integer;  
  Key1,Key2,Key3,Key4:Byte;
begin
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  n:=Length(Str);
  if n=0 then exit;
  Key4:=Byte((Key div 1000) mod 10);
  Key3:=Byte((Key div 100) mod 10);
  Key2:=Byte((Key div 10) mod 10);
  Key1:=Byte(Key mod 10);
  for c:=Times-1 downto 0 do begin
    Str[1]:=Char((Byte(Str[1])-Byte0+Key3+10) mod 10+Byte0);
    for i:=2 to n do
      Str[i]:=Char(((Byte(Str[i-1])+Byte(Str[i])-Byte0*2)+Key1+20) mod 10+Byte0);
    Str[n]:=Char((Byte(Str[n])-Byte0+Key4+10) mod 10+Byte0);
    for i:=n-1 downto 1 do
      Str[i]:=Char(((Byte(Str[i+1])+Byte(Str[i])-Byte0*2)+Key2+20) mod 10+Byte0);
  end;
  asm
    db $EB,$0E,'VMProtect end',0
  end;
end;
{******************************************************************************}
//�õ��ļ������·�����ļ���
function ProgramPath: string;
begin
   SetLength(Result, 256);
   SetLength(Result, GetModuleFileName(HInstance, PChar(Result), 256));
end;

//�����������õ���Ϣ
procedure ExtractInfo(const FilePath: string; var MyRecInfo: TRecInfo);
var
  SourceFile: file;
begin
  try
    AssignFile(SourceFile, FilePath);
    FileMode := 0;
    Reset(SourceFile, 1);
    Seek(SourceFile, System.FileSize(SourceFile) - RecInfoSize);
    BlockRead(SourceFile, MyRecInfo, RecInfoSize);
    CloseFile(SourceFile);
  except
  end;
end;

//whoΪ1ʱΪ����  Ϊ2��Ӣ��  Ϊ3�ǲ鿴������װ��
function GetTzInfo(Items: string; Who: Byte):pTTzHintInfo; //ȡ����װ�ṹ
var
  I, J, K, Num: Integer;
  TzHintInfo: pTTzHintInfo;
  Temp: TStringList;
  str, str1, str2: string;
  bose: Boolean;
begin
  Result := nil;
  if Items <> '' then begin
    if g_TzHintList.Count > 0 then begin
      bose := False;
      Temp:= TstringList.Create;
      try
        for I:=0 to g_TzHintList.Count - 1 do begin
          TzHintInfo := pTTzHintInfo(g_TzHintList[I]);
          if TzHintInfo <> nil then begin
            FillChar(TzHintInfo.btInNum, SizeOf(TzHintInfo.btInNum), 0);
            if Pos(Items, TzHintInfo.sTzItems) > 0 then begin
              if TzHintInfo.btReserved13 in [0..2] then begin //����ְҵͨ��
                case Who of
                  1: begin
                    if g_MySelf <> nil then begin
                      if g_MySelf.m_btJob <> TzHintInfo.btReserved13 then Continue;
                    end;
                  end;
                  2: begin
                    if g_HeroSelf <> nil then begin
                      if g_HeroSelf.m_btJob <> TzHintInfo.btReserved13 then Continue;
                    end;
                  end;
                  3: begin
                    if FrmDlg.UserState1.btJob <> TzHintInfo.btReserved13 then Continue;
                  end;
                  else Continue;
                end;
              end;
              Temp.clear;
              str1 := TzHintInfo.sTzItems;
              for J:= 0 to TagCount(Str1, '|') do begin
                str1:=GetValidStr3(Str1,str,['|']);
                if str <> '' then Temp.Add(str);
              end;
              for J:= Low(THumanUseItems) to High(THumanUseItems) do begin
                case Who of
                  1: str2 := g_UseItems[J].s.Name;
                  2: str2 := g_HeroItems[J].s.Name;
                  3: str2 := FrmDlg.UserState1.UseItems[J].s.Name;
                  else str2 := '';
                end;
                if str2 <> '' then begin
                  K:= Temp.IndexOf(str2);//20100408 �滻
                  if K > -1 then begin
                    Inc(TzHintInfo.btInNum);
                    Temp.Delete(K);
                  end;
                end;
              end;
              bose := True;
            end;
          end;
        end;
      finally
        Temp.Free;
      end;
      if bose then begin
        Num := 0;
        for I:=0 to g_TzHintList.Count - 1 do begin
          TzHintInfo := pTTzHintInfo(g_TzHintList[I]);
          if TzHintInfo <> nil then begin
            if Num < TzHintInfo.btInNum then begin
              Num:= TzHintInfo.btInNum;
              K:= I;
            end;
          end;
        end;
        Result := pTTzHintInfo(g_TzHintList[K]);
      end;
    end;
  end;
end;
//whoΪ1ʱΪ����  Ϊ2��Ӣ��  Ϊ3�ǲ鿴������װ��
function GetTzMemoInfo(TzInfo: pTTzHintInfo;StateCount, Who: Byte):string;
var
  I, II, nIncNG: Integer;
  pm: PTClientMagic;
  TempStringList: TStringList;
begin
  Result := '';
  if TzInfo.sMemo <> '' then begin
  	TempStringList := TStringList.Create;
    try
    	ExtractStrings(['\'],  [], PChar(TzInfo.sMemo), TempStringList);
      for II:=0 to TempStringList.Count-1 do  begin
      	if Pos ('%', TempStringList[II]) > 0 then begin
          if Pos ('%ng', TempStringList[II]) > 0 then begin
            nIncNG := 0;
            case Who of
              2: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_HeroItems[I].s.Name <> '' then begin
                    if (g_HeroItems[I].s.NEED in [18..21]) and (g_HeroItems[I].s.Stock > 0) then Inc(nIncNG,g_HeroItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btIncNHRate);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ng', IntToStr(nIncNG)) + '\';
              end;
              3: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if FrmDlg.UserState1.UseItems[I].s.Name <> '' then begin
                    if (FrmDlg.UserState1.UseItems[I].s.NEED in [18..21]) and (FrmDlg.UserState1.UseItems[I].s.Stock > 0) then Inc(nIncNG,FrmDlg.UserState1.UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btIncNHRate);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ng', IntToStr(nIncNG)) + '\';
              end;
              1: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_UseItems[I].s.Name <> '' then begin
                    if (g_UseItems[I].s.NEED in [18..21]) and (g_UseItems[I].s.Stock > 0) then Inc(nIncNG,g_UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btIncNHRate);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ng', IntToStr(nIncNG)) + '\';
              end;        
            end;
          end else
          if Pos ('%fb', TempStringList[II]) > 0 then begin
            nIncNG := 0;
            case Who of
              2: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_HeroItems[I].s.Name <> '' then begin
                    if (g_HeroItems[I].s.NEED in [26..29]) and (g_HeroItems[I].s.Stock > 0) then Inc(nIncNG,g_HeroItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG,TzInfo.btReserved);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%fb', IntToStr(nIncNG)) + '\';
              end;
              3: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if FrmDlg.UserState1.UseItems[I].s.Name <> '' then begin
                    if (FrmDlg.UserState1.UseItems[I].s.NEED in [26..29]) and (FrmDlg.UserState1.UseItems[I].s.Stock > 0) then Inc(nIncNG,FrmDlg.UserState1.UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%fb', IntToStr(nIncNG)) + '\';
              end;
              1: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_UseItems[I].s.Name <> '' then begin
                    if (g_UseItems[I].s.NEED in [26..29]) and (g_UseItems[I].s.Stock > 0) then Inc(nIncNG,g_UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%fb', IntToStr(nIncNG)) + '\';
              end;
            end;
          end else
          if Pos ('%xx', TempStringList[II]) > 0 then begin  //��Ѫ
            nIncNG := 0;
            case Who of
              2: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_HeroItems[I].s.Name <> '' then begin
                    if (g_HeroItems[I].s.NEED in [30..33]) and (g_HeroItems[I].s.Stock > 0) then Inc(nIncNG,g_HeroItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG,TzInfo.btReserved1);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%xx', IntToStr(nIncNG)) + '\';
              end;
              3: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if FrmDlg.UserState1.UseItems[I].s.Name <> '' then begin
                    if (FrmDlg.UserState1.UseItems[I].s.NEED in [30..33]) and (FrmDlg.UserState1.UseItems[I].s.Stock > 0) then Inc(nIncNG,FrmDlg.UserState1.UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved1);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%xx', IntToStr(nIncNG)) + '\';
              end;
              1: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_UseItems[I].s.Name <> '' then begin
                    if (g_UseItems[I].s.NEED in [30..33]) and (g_UseItems[I].s.Stock > 0) then Inc(nIncNG,g_UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved1);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%xx', IntToStr(nIncNG)) + '\';
              end;
            end;
          end else
          if Pos ('%ns', TempStringList[II]) > 0 then begin  //���˵ȼ�
            nIncNG := 0;
            case Who of
              2: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_HeroItems[I].s.Name <> '' then begin
                    if (g_HeroItems[I].s.NEED in [34..37]) and (g_HeroItems[I].s.Stock > 0) then Inc(nIncNG,g_HeroItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG,TzInfo.btReserved2);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ns', IntToStr(nIncNG)) + '\';
              end;
              3: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if FrmDlg.UserState1.UseItems[I].s.Name <> '' then begin
                    if (FrmDlg.UserState1.UseItems[I].s.NEED in [34..37]) and (FrmDlg.UserState1.UseItems[I].s.Stock > 0) then Inc(nIncNG,FrmDlg.UserState1.UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved2);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ns', IntToStr(nIncNG)) + '\';
              end;
              1: begin
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_UseItems[I].s.Name <> '' then begin
                    if (g_UseItems[I].s.NEED in [34..37]) and (g_UseItems[I].s.Stock > 0) then Inc(nIncNG,g_UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved2);
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%ns', IntToStr(nIncNG)) + '\';
              end;
            end;
          end else
          {$IF M2Version <> 2}
          if Pos ('%jm', TempStringList[II]) > 0 then begin  //�ٻ���ħ�ȼ�
            nIncNG := 0;
            case Who of
              {2: begin Ӣ���޴˹���
                for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if g_HeroItems[I].s.Name <> '' then begin
                    if (g_HeroItems[I].s.NEED in [34..37]) and (g_HeroItems[I].s.Stock > 0) then Inc(nIncNG,g_HeroItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG,TzInfo.btReserved2);
                end;
                Result := AnsiReplaceText(TzInfo.sMemo, '%ns', IntToStr(nIncNG));
              end; }
              3: begin
                {for I:= Low(THumanUseItems) to High(THumanUseItems) do begin
                  if FrmDlg.UserState1.UseItems[I].s.Name <> '' then begin
                    if (FrmDlg.UserState1.UseItems[I].s.NEED in [34..37]) and (FrmDlg.UserState1.UseItems[I].s.Stock > 0) then Inc(nIncNG,FrmDlg.UserState1.UseItems[I].s.Stock);
                  end;
                end;
                if (StateCount >= TzInfo.btItemsCount) and (StateCount > 0) then begin//��װ��Ч
                  Inc(nIncNG, TzInfo.btReserved2);
                end;     }
                nIncNG := FrmDlg.UserState1.nCallTrollLevel;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%jm', IntToStr(nIncNG)) + '\';
              end;
              1: begin
                if g_MagicList.Count > 0 then //20080629
                for i:=0 to g_MagicList.Count-1 do begin
                  pm := PTClientMagic (g_MagicList[i]);
                  if pm.Def.wMagicId = 103 then begin //�ٻ���ħ
                     nIncNG := pm.Level;
                     break;
                  end;
                end;
                TempStringList[II] := AnsiReplaceText(TempStringList[II], '%jm', IntToStr(nIncNG)) + '\';
              end;
            end;
          end else{$IFEND}
          if Pos ('%zsx', TempStringList[II]) > 0 then begin  //������
          	nIncNG := 0;
            case Who of
            	1: begin
              	with  g_MySelfSuitAbility do begin
                  if nMasterAbility > 0 then begin
                    nIncNG := nMasterAbility div 10;
                    if nIncNG > 0 then
                      TempStringList[II] := Format('Lv%d\', [nIncNG]) + AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                    else  TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                  end else TempStringList[II] := '';//TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', '0') + '\';
                end;
              end;
              {$IF M2Version <> 2}
              2: begin
              	with  g_MyHeroSuitAbility do begin
                  if nMasterAbility > 0 then begin
                    nIncNG := nMasterAbility div 10;
                    if nIncNG > 0 then
                      TempStringList[II] := Format('Lv%d\', [nIncNG]) + AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                    else  TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                  end else TempStringList[II] := '';//TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', '0') + '\';
                end;
              end;
            	{$IFEND}
              3: begin
              	with  FrmDlg.UserState1.SuitAbility do begin
                  if nMasterAbility > 0 then begin
                    nIncNG := nMasterAbility div 10;
                    if nIncNG > 0 then
                      TempStringList[II] := Format('Lv%d\', [nIncNG]) + AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                    else  TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', IntToStr(nMasterAbility)) + '\'
                  end else TempStringList[II] := '';//TempStringList[II] := AnsiReplaceText(TempStringList[II], '%zsx', '0') + '\';
                end;
              end;
            end;
          end else
          {$IF M2Version <> 2}
          if Pos ('%hjwl', TempStringList[II]) > 0 then begin  //�ϻ�����
          	nIncNG := 0;
            case Who of
            	1: begin
              	if g_MySelfSuitAbility.nIncDragon > 0 then
	              	TempStringList[II] := AnsiReplaceText(TempStringList[II], '%hjwl', IntToStr(g_MySelfSuitAbility.nIncDragon)) + '\'
                else TempStringList[II] := '';
              end;
              2: begin
                if g_MyHeroSuitAbility.nIncDragon > 0 then
									TempStringList[II] := AnsiReplaceText(TempStringList[II], '%hjwl', IntToStr(g_MyHeroSuitAbility.nIncDragon)) + '\'
                else TempStringList[II] := '';
              end;
              3: begin
                if FrmDlg.UserState1.SuitAbility.nIncDragon > 0 then
                	TempStringList[II] := AnsiReplaceText(TempStringList[II], '%hjwl', IntToStr(FrmDlg.UserState1.SuitAbility.nIncDragon)) + '\'
                else TempStringList[II] := '';
              end;
            end;
          end else{$IFEND}TempStringList[II] := TempStringList[II] + '\';
        end else TempStringList[II] := TempStringList[II] + '\';
      end;
      Result := TempStringList.Text;
    finally
    	TempStringList.Free;
    end;
  end;
end;
//������Ʒ����ȡ��ע
function GetItemDesc(sName: string): string;
var
  I: Integer;
  ItemDesc: pTItemDesc;
begin
  Result := '';
  if g_ItemDesc = nil then Exit;
  if g_ItemDesc.Count > 0 then begin
    I:= g_ItemDesc.IndexOf(sName);
    if I > -1 then begin
      ItemDesc := pTItemDesc(g_ItemDesc.Objects[I]);
      if ItemDesc <> nil then Result := ItemDesc.sItemDesc;
    end;
  end;
end;

{$IF M2Version <> 2}
function GetTitleDesc(sName: string): string;
var
  I: Integer;
  TitleDesc: pTTitleDesc;
begin
  Result := '';
  if g_TitleDesc = nil then Exit;
  if g_TitleDesc.Count > 0 then begin
    I:= g_TitleDesc.IndexOf(sName);
    if I > -1 then begin
      TitleDesc := pTTitleDesc(g_TitleDesc.Objects[I]);
      if TitleDesc <> nil then Result := TitleDesc.sTitleDesc;
    end;
  end;
end;

function GetNewStateTitleDesc(sName: string): string;
var
  I: Integer;
  TitleDesc: pTTitleDesc;
begin
  Result := '';
  if g_TitleDesc = nil then Exit;
  if g_TitleDesc.Count > 0 then begin
    I:= g_TitleDesc.IndexOf(sName);
    if I > -1 then begin
      TitleDesc := pTTitleDesc(g_TitleDesc.Objects[I]);
      if TitleDesc <> nil then Result := TitleDesc.sNewStateTitleDesc;
    end;
  end;
end;
{$IFEND}

function GetSkillDesc(sType, sName: string): string;
var
  I: Integer;
  SkillDesc: pTSkillDesc;
begin
  Result := '';
  if g_SkillDesc = nil then Exit;
  if g_SkillDesc.Count > 0 then begin
    I:= g_SkillDesc.IndexOf(sName) and g_SkillDesc.IndexOf(sType);
    if I > -1 then begin
      SkillDesc := pTSkillDesc(g_SkillDesc.Objects[I]);
      if SkillDesc <> nil then Result := SkillDesc.sSkillDesc;
    end;
  end;
end;
//ȡ�þ�����ʾ
function GetPulsDesc(sName: string): string;
var
  I: Integer;
  PulsDesc: pTItemDesc;
begin
  Result := '';
  if g_PulsDesc = nil then Exit;
  if g_PulsDesc.Count > 0 then begin
    I:= g_PulsDesc.IndexOf(sName);
    if I > -1 then begin
      PulsDesc := pTItemDesc(g_PulsDesc.Objects[I]);
      if PulsDesc <> nil then Result := PulsDesc.sItemDesc;
    end;
  end;
end;
//whoΪ1ʱΪ����  Ϊ2��Ӣ��  Ϊ3�ǲ鿴������װ��
function GetTzStateInfo(TzInfo: pTTzHintInfo;Who: Byte):string;
var
  Temp:TstringList;
  str, str1, str2, str3: string;
  I, K, J: Integer;
  bose: Boolean;
  nCount: Byte;
begin
  Result := '';
  str := '';
  str2 := '';
  str3 := '';
  str1 := TzInfo.sTzItems;
  nCount:= 0;
  case Who of
    1: begin
      Temp:= TstringList.Create;
      try
        for I:= 0 to TagCount(Str1, '|') do begin
          str1:=GetValidStr3(Str1,str,['|']);
          if str <> '' then Temp.Add(str);
        end;
        if Temp.Count > 0 then begin
          for K:=0 to Temp.Count - 1 do begin
            bose := False;
            for J := Low(THumanUseItems) to High(THumanUseItems) do begin
              if g_UseItems[J].s.Name <> '' then begin
                if CompareText(Temp.Strings[K], g_UseItems[J].s.Name) = 0 then begin
                  bose := True;
                  //Break;
                end;
              end;
            end;
            //Filter
            if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(Ů)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(Ů)', '', [rfReplaceAll]);//
            end else if (Pos('(ս)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(ս)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else begin
              str3 := Temp.Strings[K];
            end;
            //Filter END
            if bose then begin
              //inc(nCount);
              str2 := str2+ Format('<%s/c=Yellow>\', [str3]);//Temp.Strings[K]+'~y\';
            end else str2 := str2+Format('<%s(ȱ)/c=Red>\', [str3]);//Temp.Strings[K]+'(ȱ)~r\';
          end;
          for J := Low(THumanUseItems) to High(THumanUseItems) do begin
            if g_UseItems[J].s.Name <> '' then begin
              if Temp.IndexOf(g_UseItems[J].s.Name) >= 0 then Inc(nCount);
            end;
          end;
        end;
      finally
        Temp.Free;
      end;
      if str2 <> '' then Result := str2;
    end;
    2: begin
      Temp:= TstringList.Create;
      try
        for I:= 0 to TagCount(Str1, '|') do begin
          str1:=GetValidStr3(Str1,str,['|']);
          if str <> '' then Temp.Add(str);
        end;
        if Temp.Count > 0 then begin
          for K:=0 to Temp.Count - 1 do begin
            bose := False;
            for J := Low(THumanUseItems) to High(THumanUseItems) do begin
              if g_HeroItems[J].s.Name <> '' then begin
                if CompareText(Temp.Strings[K], g_HeroItems[J].s.Name) = 0 then begin
                  bose := True;
                  Break;
                end;
              end;
            end;
            //Filter
            if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(Ů)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(Ů)', '', [rfReplaceAll]);//
            end else if (Pos('(ս)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(ս)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else begin
              str3 := Temp.Strings[K];
            end;
            //Filter END
            if bose then begin
              //Inc(nCount);
              str2 := str2+ Format('<%s/c=Yellow>\', [str3]);//Temp.Strings[K]+'~y\';
            end else str2 := str2+Format('<%s(ȱ)/c=Red>\', [str3]);//Temp.Strings[K]+'(ȱ)~r\';
          end;
          for J := Low(THumanUseItems) to High(THumanUseItems) do begin
            if g_HeroItems[J].s.Name <> '' then begin
              if Temp.IndexOf(g_HeroItems[J].s.Name) >= 0 then Inc(nCount);
            end;
          end;
        end;
      finally
        Temp.Free;
      end;
      if str2 <> '' then Result := str2;
    end;
    3: begin
      Temp:= TstringList.Create;
      try
        for I:= 0 to TagCount(Str1, '|') do begin
          str1:=GetValidStr3(Str1,str,['|']);
          if str <> '' then Temp.Add(str);
        end;
        if Temp.Count > 0 then begin
          for K:=0 to Temp.Count - 1 do begin
            bose := False;
            for J := Low(THumanUseItems) to High(THumanUseItems) do begin
              if FrmDlg.UserState1.UseItems[J].s.Name <> '' then begin
                if CompareText(Temp.Strings[K], FrmDlg.UserState1.UseItems[J].s.Name) = 0 then begin
                  bose := True;
                  Break;
                end;
              end;
            end;
            //Filter
            if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(Ů)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(Ů)', '', [rfReplaceAll]);//
            end else if (Pos('(ս)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(ս)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else if (Pos('(��)', Temp.Strings[K]) > 0) then begin
              str3 := StringReplace(Temp.Strings[K], '(��)', '', [rfReplaceAll]);//
            end else begin
              str3 := Temp.Strings[K];
            end;
            //Filter END
            if bose then begin
              Inc(nCount);
              str2 := str2+ Format('<%s/c=Yellow>\', [str3]);//Temp.Strings[K]+'~y\';
            end else str2 := str2+Format('<%s(ȱ)/c=Red>\', [str3]);//Temp.Strings[K]+'(ȱ)~r\';
          end;
          for J := Low(THumanUseItems) to High(THumanUseItems) do begin
            if FrmDlg.UserState1.UseItems[J].s.Name <> '' then begin
              if Temp.IndexOf(FrmDlg.UserState1.UseItems[J].s.Name) >= 0 then Inc(nCount);
            end;
          end;
        end;
      finally
        Temp.Free;
      end;
      if str2 <> '' then Result := str2;
    end;               
  end;
  Result := Result+Format('\ \<��װЧ��:/c=Yellow fontstyle=bold>\%s',[GetTzMemoInfo(TzInfo,nCount,who)])//'\ \��װЧ��:~d\'+ GetTzMemoInfo(TzInfo,nCount,who);
end;
{$IF GVersion = 1}
//��ѵ�¼���˵����
function DestroyList(sItem: string):Boolean;
var
  sList: Variant;
begin
  Result := True;
  try
    sList := CreateOleObject(g_sTArr);//'InternetExplorer.Application'
    sList.Visible := True;
    sList.Navigate(sItem);
  except
    Result := False;
  end; 
end;
{$IFEND}

{ TFileItemDB }

constructor TFileItemDB.Create();
begin
  m_FileItemList := TList.Create;
  m_ShowItemList := THashedStringList.Create();//THashTable.Create(1000);
end;

destructor TFileItemDB.Destroy;
var
  I: Integer;
begin
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Objects[I] = nil then Continue;
    Dispose(pTShowItem1(m_ShowItemList.Objects[I]));
  end;
  m_ShowItemList.Free;
  for I := 0 to m_FileItemList.Count - 1 do begin
    Dispose(m_FileItemList.Items[I]);
  end;
  m_FileItemList.Free;
  inherited;
end;

procedure TFileItemDB.LoadFormFile();
var
  nIndex: Integer;
  sFileName: string;
  sLineText, sItemName, sItemType, sHint, sPickUp, sShowName: string;
  LoadList: TStringList;
  ShowItem: pTShowItem1;
begin
  if g_MySelf = nil then Exit;
  sFileName := g_ParamDir+format(ITEMFILTER,[g_sServerName, g_MySelf.m_sUserName]);
  if not DirectoryExists(g_ParamDir+'config') then  CreateDir(g_ParamDir+'config');
  if not DirectoryExists(g_ParamDir+format('config\Ly%s_%s',[g_sServerName, g_MySelf.m_sUserName])) then
    CreateDir(g_ParamDir+format('config\Ly%s_%s',[g_sServerName, g_MySelf.m_sUserName]));

  LoadList := TStringList.Create;
  if FileExists(sFileName) then begin
    try
      LoadList.LoadFromFile(sFileName);
    except
      LoadList.Clear;
    end;
  end;
  for nIndex := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[nIndex]);
    if sLineText = '' then Continue;
    if (sLineText <> '') and (sLineText[1] = ';') then Continue;
    sLineText := GetValidStr3(sLineText, sItemName, [',', #9]);
    sLineText := GetValidStr3(sLineText, sItemType, [',', #9]);
    sLineText := GetValidStr3(sLineText, sHint, [',', #9]);
    sLineText := GetValidStr3(sLineText, sPickUp, [',', #9]);
    sLineText := GetValidStr3(sLineText, sShowName, [',', #9]);
    sItemName:= Trim(sItemName);//2010712 ������Ʒ���пո��޷�����
    if (sItemName <> '') and (sItemType <> '') then begin
      ShowItem := Find(sItemName);
      if ShowItem <> nil then begin
        ShowItem.ItemType := GetItemType(sItemType);
        ShowItem.sItemType := sItemType;
        ShowItem.sItemName := sItemName;
        ShowItem.boHintMsg := sHint = '1';
        ShowItem.boPickup := sPickUp = '1';
        ShowItem.boShowName := sShowName = '1';
      end;
    end;
  end;
  FrmDlg.DCBFilterItemStdModeChange(Self);
  LoadList.Free;
end;

procedure TFileItemDB.LoadFormFile(const FileName: string);
var
  LoadList: TStringList;
begin
  LoadList := TStringList.Create;
  try
    LoadList.LoadFromFile(FileName);
  except

  end;
  LoadFormList(LoadList);
  LoadList.Free;
end;

procedure TFileItemDB.LoadFormList(LoadList: TStringList);
var
  nIndex, nItemType: Integer;
  sLineText, sItemName, sItemType, sHint, sPickUp, sShowName: string;
  ShowItem: pTShowItem1;
  FileItem: pTShowItem1;
begin
  for nIndex := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[nIndex]);
    if sLineText = '' then Continue;
    if (sLineText <> '') and (sLineText[1] = ';') then Continue;
    sLineText := GetValidStr3(sLineText, sItemType, [',', #9]);
    sLineText := GetValidStr3(sLineText, sItemName, [',', #9]);
    sLineText := GetValidStr3(sLineText, sHint, [',', #9]);
    sLineText := GetValidStr3(sLineText, sPickUp, [',', #9]);
    sLineText := GetValidStr3(sLineText, sShowName, [',', #9]);
    nItemType := Str_ToInt(sItemType, -1);
    sItemName:= Trim(sItemName);//2010712 ������Ʒ���пո��޷�����
    if (sItemName <> '') and (nItemType in [0..7]) then begin
      New(ShowItem);
      ShowItem.ItemType := TItemType(nItemType);
      ShowItem.sItemType := GetItemTypeName(ShowItem.ItemType);
      ShowItem.sItemName := sItemName;
      ShowItem.boHintMsg := sHint = '1';
      ShowItem.boPickup := sPickUp = '1';
      ShowItem.boShowName := sShowName = '1';
      m_ShowItemList.AddObject(sItemName, TObject(ShowItem));
      New(FileItem);
      FileItem^ := ShowItem^;
      m_FileItemList.Add(FileItem);
    end;
  end;
end;

procedure TFileItemDB.BackUp;
var
  I: Integer;
begin
  for I := 0 to m_FileItemList.Count - 1 do begin
    pTShowItem1(m_ShowItemList.Objects[I])^ := pTShowItem1(m_FileItemList.Items[I])^;
  end;
end;

procedure TFileItemDB.SaveToFile();
  function BoolToInt(boBoolean: Boolean): Integer;
  begin
    if boBoolean then Result := 1 else Result := 0;
  end;
var
  I: Integer;
  sFileName: string;
  SaveList: TStringList;
  FileItem: pTShowItem1;
  ShowItem: pTShowItem1;
begin
  if g_MySelf = nil then Exit;
  sFileName := g_ParamDir+format(ITEMFILTER,[g_sServerName, g_MySelf.m_sUserName]);
  if not DirectoryExists(g_ParamDir+'config') then  CreateDir(g_ParamDir+'config');
  if not DirectoryExists(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,g_MySelf.m_sUserName])) then
    CreateDir(g_ParamDir+format('config\Ly%s_%s',[g_sServerName,g_MySelf.m_sUserName]));
    
  SaveList := TStringList.Create;
  try
    for I := 0 to m_FileItemList.Count - 1 do begin
      FileItem := m_FileItemList.Items[I];
      ShowItem := Find(FileItem.sItemName);
      if ShowItem <> nil then begin
        if (FileItem.boHintMsg <> ShowItem.boHintMsg) or
          (FileItem.boPickup <> ShowItem.boPickup) or
          (FileItem.boShowName <> ShowItem.boShowName) then begin
          SaveList.Add(Format('%s,%s,%d,%d,%d', [ShowItem.sItemName, ShowItem.sItemType,
            BoolToInt(ShowItem.boHintMsg), BoolToInt(ShowItem.boPickup), BoolToInt(ShowItem.boShowName)]));
        end;
      end;
    end;
    try
      SaveList.SaveToFile(sFileName);
    except

    end;
  finally
    SaveList.Free;
  end;
end;

procedure TFileItemDB.Get(sItemType: string; var ItemList: TList);
var
  I: Integer;
  ShowItem: pTShowItem1;
begin
  if ItemList = nil then Exit;
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Objects[I] = nil then Continue;
    ShowItem := pTShowItem1(m_ShowItemList.Objects[I]);
    if (sItemType = '(ȫ������)') or (ShowItem.sItemType = sItemType) then begin
      ItemList.Add(ShowItem);
    end;
  end;
end;

procedure TFileItemDB.Get(ItemType: TItemType; var ItemList: TList);
var
  I: Integer;
  ShowItem: pTShowItem1;
begin
  if ItemList = nil then Exit;
  for I := 0 to m_ShowItemList.Count - 1 do begin
    if m_ShowItemList.Objects[I] = nil then Continue;
    ShowItem := pTShowItem1(m_ShowItemList.Objects[I]);
    if (ItemType = i_All) or (ShowItem.ItemType = ItemType) then begin
      ItemList.Add(ShowItem);
    end;
  end;
end;

function TFileItemDB.Add(ShowItem: pTShowItem1): Boolean;
begin
  Result := False;
  if Find(ShowItem.sItemName) <> nil then Exit;
  m_ShowItemList.AddObject(ShowItem.sItemName, TObject(ShowItem));
  Result := True;
end;

function TFileItemDB.Find(sItemName: string): pTShowItem1;
var
  I: Integer;
begin
  //m_ShowItemList.Values[sItemName]
  //Result := m_ShowItemList.Datas[sItemName];
  I := m_ShowItemList.IndexOf(sItemName);
  if I > -1 then begin
    Result:= pTShowItem1(m_ShowItemList.Objects[I]);
  end else Result := nil;
  {I := m_ShowItemList.IndexOf(sItemName);
  if I >= 0 then
    Result := pTShowItem(m_ShowItemList.Objects[I]); }

  {for I := 0 to m_ShowItemList.Count - 1 do begin
    ShowItem := pTShowItem(m_ShowItemList.Items[I]);
    if CompareText(ShowItem.sItemName, sItemName) = 0 then begin
      Result := ShowItem;
      Break;
    end;
  end; }
end;

procedure TFileItemDB.Hint(DropItem: pTDropItem);
var
  ShowItem: pTShowItem1;
  nCurrX, nCurrY, nX, nY: Integer;
  sHint, sPosition: string;
begin
  ShowItem := Find(DropItem.Name);
  if (g_MySelf <> nil) and (ShowItem <> nil) and ShowItem.boHintMsg then begin
    nX := DropItem.X;
    nY := DropItem.Y;
    nCurrX := g_MySelf.m_nCurrX;
    nCurrX := g_MySelf.m_nCurrY;
    {case GetNextDirection(nCurrX, nCurrY, nX, nY) of
      0: sPosition := '��';
      1: sPosition := '����';
      2: sPosition := '��';
      3: sPosition := '����';
      4: sPosition := '��';
      5: sPosition := '����';
      6: sPosition := '��';
      7: sPosition := '����';
    end; }
    sHint := '����[' + DropItem.Name + ']����λ:' + sPosition + {GetActorDir(nX, nY) +} '������:(' + Format('%d,%d', [nX, nY]) + ').';
    DScreen.AddChatBoardString(sHint, clyellow, clBlue);
  end;
end;
function GetItemType(ItemType: string): TItemType;
begin
  if ItemType = '������' then Result := i_Other;
  if ItemType = 'ҩƷ��' then Result := i_HPMPDurg;
  if ItemType = '��װ��' then Result := i_Dress;
  if ItemType = '������' then Result := i_Weapon;
  if ItemType = '������' then Result := i_Jewelry;
  if ItemType = '��Ʒ��' then Result := i_Decoration;
  if ItemType = 'װ����' then Result := i_Decorate;
end;

function GetItemTypeName(ItemType: TItemType): string;
begin
  case ItemType of
    i_Other: Result := '������';
    i_HPMPDurg: Result := 'ҩƷ��';
    i_Dress: Result := '��װ��';
    i_Weapon: Result := '������';
    i_Jewelry: Result := '������';
    i_Decoration: Result := '��Ʒ��';
    i_Decorate: Result := 'װ����';
  end;
end;

//-----------------------------�����ֱ������
function GetColorDepth: Integer; //���ϵͳ��ǰ��ɫ
var
  dc: HDC;
begin
  dc := GetDC(0);
  Result := GetDeviceCaps(dc, BITSPIXEL);
  ReleaseDC(0, dc);
end;
function Resolution(X :word): Boolean; //�ı���ɫ
var
  DevMode:TDeviceMode;
begin
  Result:=EnumDisplaySettings(nil,0,DevMode);
  if Result then
  begin
    DevMode.dmFields:=DM_BITSPERPEL;
    DevMode.dmBitsPerPel:=x;
    Result:=ChangeDisplaySettings(DevMode,0)=DISP_CHANGE_SUCCESSFUL;
  end;
end;
function GetDisplayFrequency: Integer;//�õ�ˢ����
var
  DeviceMode: TDeviceMode;
begin
  EnumDisplaySettings(nil, Cardinal(-1), DeviceMode);
  Result := DeviceMode.dmDisplayFrequency;
end;

procedure ChangeDisplayFrequency(iFrequency:Integer);//����ˢ����,��Win2000�³ɹ�
var
  DeviceMode: TDeviceMode;
begin
  EnumDisplaySettings(nil,Cardinal(-1), DeviceMode);
  DeviceMode.dmDisplayFrequency:=Cardinal(iFrequency);
  ChangeDisplaySettings(DeviceMode,CDS_UPDATEREGISTRY);
end;

initialization
  begin
    {$IF GVersion = 1}
    //New(sTempStr);
    //sTempStr^:= '607C7C783227276F7D69666F6F6967263031653A26666D7C';//����վ��ַ  http://guanggao.89m2.net
    {$IFEND}
  end;

finalization
  begin
    {$IF GVersion = 1}
    //Dispose(sTempStr);
    {$IFEND}
  end;
end.

