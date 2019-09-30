unit UniTypes;

interface

uses SysUtils, Classes;

const
  MAX_STATUS_ATTRIBUTE = 12;
  MAPNAMELEN = 16;//��ͼ������
  ACTORNAMELEN = 14;//���ֳ���
  Version    = 0;
  DBFileDesc = '3K�������ݿ��ļ� 2011/08/12';
  nDBVersion = 20110812;//DB�汾��

type
  TListArray  = array [Ord('A')..Ord('Z') + 10 + 1] of TStrings;

  pTQuickInfo = ^TQuickInfo;
  TQuickInfo  = packed record
    sChrName  : string[16];
    nPosition : Cardinal;
  end;

  //size 124 ID.DB ����ͷ  
  TDBHeader = packed record
    sDesc: string[34]; //0x00    #
    n23: Integer; //0x23
    n28: Integer; //0x27
    n2C: Integer; //0x2B
    n30: Integer; //0x2F
    n34: Integer; //0x33
    n38: Integer; //0x37
    n3C: Integer; //0x3B
    n40: Integer; //0x3F
    n44: Integer; //0x43
    n48: Integer; //0x47
    n4B: Byte; //0x4B
    n4C: Integer; //0x4C
    n50: Integer; //0x50
    n54: Integer; //0x54
    n58: Integer; //0x58
    nLastIndex: Integer; //0x5C �������� #
    dLastDate: TDateTime; //0x60           #
    nIDCount: Integer; //0x68 ID����       #
    n6C: Integer; //0x6C
    nDeletedIdx: Integer; //0x70     := -1 #
    dUpdateDate: TDateTime; //0x74         # 
  end;
  pTDBHeader = ^TDBHeader;

  //��������ͷ
  TDBHeader1 = packed record //Size 124
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
    nLastIndex: Integer; //0x5C
    dLastDate: TDateTime; //����˵�����
    nHumCount: Integer; //0x68
    n6C: Integer; //0x6C
    n70: Integer; //0x70
    dUpdateDate: TDateTime; //��������
  end;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean; //�Ƿ�ɾ��
    nSelectID: Byte;   //ID
    boIsHero: Boolean; //�Ƿ�Ӣ��
    bt2: Byte;
    dCreateDate: TDateTime; //����ʱ��
    sName: string[15]; //0x15  //��ɫ����   28
  end;
  pTRecordHeader = ^TRecordHeader;

{THumInfo}
  pTDBHum       = ^TDBHum;
  TDBHum        = packed record     //FileHead  72�ֽ�   //Size 72
    Header: TRecordHeader;
    sChrName: string[14]; //0x14  //��ɫ����   44
    sAccount: string[10]; //�˺�
    boDeleted: Boolean; //�Ƿ�ɾ��
    bt1: Byte; //δ֪
    dModDate: TDateTime;//��������
    btCount: Byte; //�����ƴ�
    boSelected: Boolean; //�Ƿ�ѡ��
    n6: array[0..5] of Byte;
  end;

  TNewAbility = packed record//��������ʹ��
    Level: Word;//�ȼ�
    AC: Word;//HP ���� 20091026
    MAC: Word;//MP ���� 20091026
    DC: Word;//MaxHP ���� 20091026
    MC: Word;//MaxMP ���� 20091026
    SC: Word;//LoByte()-�Զ������������� HiByte()-�Զ���������ǿ��(����)
    HP: Word;//-AC,HP����
    MP: Word;//-MAC,Mp����
    MaxHP: Word;//-DC,MaxHP����
    MaxMP: Word;//-MC,MaxMP����
    NG: Word;//��ǰ����ֵ
    MaxNG: Word;//����ֵ����
    Exp: uInt64;//��ǰ����
    MaxExp: uInt64;//��������
    Weight: Word;
    MaxWeight: Word;//�������
    WearWeight: Byte;
    MaxWearWeight: Byte;//�����
    HandWeight: Byte;
    MaxHandWeight: Byte;//����
  end;
  TOldAbility = packed record//��������ʹ��
    Level: Word;//�ȼ�
    AC: Word;//HP ���� 20091026
    MAC: Word;//MP ���� 20091026
    DC: Word;//MaxHP ���� 20091026
    MC: Word;//MaxMP ���� 20091026
    SC: Word;//LoByte()-�Զ������������� HiByte()-�Զ���������ǿ��(����)
    HP: Word;//-AC,HP����
    MP: Word;//-MAC,Mp����
    MaxHP: Word;//-DC,MaxHP����
    MaxMP: Word;//-MC,MaxMP����
    NG: Word;//��ǰ����ֵ
    MaxNG: Word;//����ֵ����
    Exp: LongWord;//��ǰ����
    MaxExp: LongWord;//��������
    Weight: Word;
    MaxWeight: Word;//�������
    WearWeight: Byte;
    MaxWearWeight: Byte;//�����
    HandWeight: Byte;
    MaxHandWeight: Byte;//����
  end;

  TNakedAbility = packed record //Size 20 ���Խ���
    DC: Word;
    MC: Word;
    SC: Word;
    AC: Word;
    MAC: Word;
    HP: Word;
    MP: Word;
    Hit: Word;
    Speed: Word;
    X2: Word;
  end;

  TPulseInfo = packed record//������Ѩ��
    nPulsePoint: Byte;//Ѩλ 0-��ʾû��ͨһ��Ѩλ��1��2��3��4��5,����ʾ��ͨ���ڼ���Ѩλ��5ʱ��ʾ���Ѵ�ͨ
    boOpenPulse: Boolean;//���Ƿ��ͨ
    nPulseLevel: Byte;//���ȼ�(1-5��)
    nStormsHit: Byte;//������
  end;

  THeroPulseInfo = packed record//Ӣ����Ѩ��
    nPulsePoint: Byte;//Ѩλ 0-��ʾû��ͨһ��Ѩλ��1��2��3��4��5,����ʾ��ͨ���ڼ���Ѩλ��5ʱ��ʾ���Ѵ�ͨ
    boOpenPulse: Boolean;//���Ƿ��ͨ
    nPulseLevel: Byte;//���ȼ�(1-5��)
    nStormsHit: Byte;//������
    dwUpPulseLevelExp: LongWord;//��������ľ��羭��
  end;
  TUnKnow = array[0..44] of Byte;
  TQuestFlag = array[0..127] of Byte;
  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;
  THumanPulseInfo = array[0..3] of TPulseInfo;//������Ѩ
  THeroPulseInfo1 = array[0..3] of THeroPulseInfo;//Ӣ����Ѩ

//------------------------------------------------------------------------------
  TUserItem = packed record
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: array[0..20] of Byte;
    btUnKnowValue: array[0..9] of Byte;//��������
    AddValue: array[0..2] of Byte;//0-1��ʱ��Ʒ 2����
    MaxDate: TDateTime;//���ʹ������ ��AddValue[0]��1ʱ����ʱ��ɾ����Ʒ����ʱ��Ʒ
  end;

  THumTitle = packed record//����ƺŽṹ(��������) 20110124***����****
    ApplyDate: TDateTime;//����ʱ��
    MakeIndex: Integer;//�ƺ�����ID
    wIndex: Word; //�ƺ�����id
    boUseTitle: Boolean;//ʹ�ô˳ƺ�
    wDura: Word;//ǧ�ﴫ������(ˮ��֮��)
    wMaxDura: Word;
    sChrName: string[14];//������(��������������ʹ��) ���߼���Ӧ��ɫ�Ƿ����ߣ�ͬ��ż����
  end;

  // �ϸ�ʽ
  THumItems = array[0..8] of TUserItem;//9��װ��
  THumAddItems = array[9..13] of TUserItem;//����4��װ�� ��չ֧�ֶ��� 20080416
  TBagItems = array[0..45] of TUserItem;//������Ʒ
  TStorageItems = array[0..45] of TUserItem;
  THumTitles = array[0..7] of THumTitle;//����ƺ�
  TUnKnow1 = array[0..5] of Word;//Ԥ��6��Word����
  // �¸�ʽ
  TNewHumAddItems = array[14..14] of TUserItem;//����4��װ�� ��չ֧�ֶ��� 20080416

  THumNGMagic = record //�ڹ�����(DB)
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ�  Ӣ��:0-���ܿ�,1--���ܹ�
    nTranPoint: LongWord; //��ǰ����ֵ
  end;
  THumNGMagics = array[0..29] of THumNGMagic;//�ڹ�����

  THumMagic = record //���＼��(DB)
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ�  Ӣ��:0-���ܿ�,1--���ܹ�
    nTranPoint: LongWord; //��ǰ����ֵ 20091225 �޸�
  end;
  THumMagics = array[0..29] of THumMagic;//���＼��(��)
  
  TNewHumMagic = record //���＼��(DB)��
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ�  Ӣ��:0-���ܿ�,1--���ܹ�
    nTranPoint: LongWord; //��ǰ����ֵ
    btLevelEx: Byte;//ǿ���ȼ� 20110812
  end;
  TNewHumMagics = array[0..34] of TNewHumMagic;//���＼��(��)

  TNewHumData = packed record //(�ķ�ϵͳ)���ݽṹ 20110812
    sChrName: string[ACTORNAMELEN];//����
    sCurMap: string[MAPNAMELEN];//��ͼ
    wCurX: Word; //����X
    wCurY: Word; //����Y
    btDir: Byte; //����
    btHair: Byte;//ͷ��
    btSex: Byte; //�Ա�(0-�� 1-Ů)
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nGold: Integer;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)
    Abil: TNewAbility;//+40 ������������
    wStatusTimeArr: TStatusTime; //+24 ����״̬����ֵ��һ���ǳ���������
    sHomeMap: string[MAPNAMELEN];//Home ��(����),�����Ƿ��һ���ٻ�(Ӣ��)
    wHomeX: Word;//Home X
    wHomeY: Word;//Home Y
    sDearName: string[ACTORNAMELEN]; //����(��ż)
    sMasterName: string[ACTORNAMELEN];//����-ʦ������ Ӣ��-��������
    boMaster: Boolean;//�Ƿ���ͽ��
    btCreditPoint: Integer;//������
    btDivorce: Byte; //(����)�Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(btDivorce��UnKnow[25]��ϳ�word)
    btMarryCount: Byte; //������
    sStoragePwd: string[7];//�ֿ�����
    btReLevel: Byte;//ת���ȼ�
    btUnKnow2: array[0..2] of Byte;//0-�Ƿ�ͨԪ������(1-��ͨ) 1-�Ƿ�Ĵ�Ӣ��(1-����Ӣ��) 2-����ʱ�Ƶ�Ʒ��
    BonusAbil: TNakedAbility; //+20 ���������ֵ
    nBonusPoint: Integer;//������
    nGameGold: Integer;//��Ϸ��(Ԫ��)
    nGameDiaMond: Integer;//���ʯ
    nGameGird: Integer;//���
    nGamePoint: Integer;//��Ϸ��
    btGameGlory: Integer; //����
    nPayMentPoint: Integer; //��ֵ��
    nLoyal: LongWord;//�ҳ϶�(Ӣ��) �����ۼƾ���(����)
    nPKPOINT: Integer;//PK����
    btAllowGroup: Byte;//�������
    btF9: Byte;
    btAttatckMode: Byte;//����ģʽ
    btIncHealth: Byte;//���ӽ�����
    btIncSpell: Byte;//���ӹ�����
    btIncHealing: Byte;//����������
    btFightZoneDieCount: Byte;//���л�ռ����ͼ����������
    sAccount: string[10];//��¼�ʺ�
    btEF: Byte;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
    boLockLogon: Boolean;//�Ƿ�������½
    wContribution: Word;//����ֵ(����) �Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(Ӣ��)
    nHungerStatus: Integer;//����״̬(����)
    boAllowGuildReCall: Boolean;//�Ƿ������л��һ
    wGroupRcallTime: Word; //�Ӵ���ʱ��
    dBodyLuck: Double; //���˶�  8
    boAllowGroupReCall: Boolean; //�Ƿ�������غ�һ
    nEXPRATE: Integer; //���鱶��
    nExpTime: LongWord; //���鱶��ʱ��
    btLastOutStatus: Byte; //�˳�״̬ 1Ϊ�����˳�
    wMasterCount: Word; //��ʦͽ����
    boHasHero: Boolean; //�Ƿ��а�����Ӣ��(����ʹ��)
    boIsHero: Boolean; //�Ƿ���Ӣ��
    btStatus: Byte; //Ӣ��״̬(Ӣ��) ��ѡ����ְҵ(����)
    sHeroChrName: string[ACTORNAMELEN];//Ӣ������, size=15
    sHeroChrName1: string[ACTORNAMELEN];//����Ӣ����(size=15) 20110130
    UnKnow: TUnKnow;//44: 0-3���ʹ�� 4-����ʱ�Ķ��� 5-ħ���ܵȼ� 6-�Ƿ�ѧ���ڹ�
                    //7-�ڹ��ȼ�(1) 8-ʹ����Ʒ�ı�˵������ɫ  9..16�������� 17..20�������ӵ���������
                    //21�Ƿ�ѧ���������� 22..24����������(0-������ 1-��ʾ"?") 25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ��
                    //26-�Ƿ�ѧ��������� 27-����Ӣ���Ƿ��Զ�����(����) 28-���ĸ�����������(0-������ 1-��ʾ"?")
                    //29-���������Ƿ���� 30-����ֵ(�������ؾ���) 31-����ֵ 32-�澭(0-δѧϰ 1-��� 2-�м� 3-���� 4-�˷� 5-ӿȪ)
                    //33-�ڹ��ȼ�(2) 34-��������(�ƺ�ʹ��) 35-�Ƿ�ͻ��99����ת 36-�����ķ�����
    QuestFlag: TQuestFlag; //�ű�����
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    BagItems: TBagItems; //����װ��
    HumMagics: TNewHumMagics;//��ͨħ��
    StorageItems: TStorageItems;//�ֿ���Ʒ

    HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
    NewHumAddItems: TNewHumAddItems;//����1�� ����

    n_WinExp: LongWord;//�ۼƾ���
    n_UsesItemTick: Integer;//������ۼ�ʱ��
    nReserved: LongWord; //(����)��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� (Ӣ��)������������
    nReserved1: Integer; //��ǰҩ��ֵ
    nReserved2: Integer; //ҩ��ֵ����
    nReserved3: Integer; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ��
    n_Reserved: Word;   //��ǰ����ֵ
    n_Reserved1: Word;  //��������
    n_Reserved2: Word;  //��ǰ��ƶ�
    n_Reserved3: Word;  //ҩ��ֵ�ȼ�
    boReserved: Boolean; //�Ƿ������ T-�����(����)
    boReserved1: Boolean;//�Ƿ�������Ӣ��(����)
    boReserved2: Boolean;//�Ƿ���� T-������� (����)
    boReserved3: Boolean;//���Ƿ�Ⱦ�����(����)
    m_GiveDate: Integer;//������ȡ�л��Ȫ����(����)
    MaxExp68: LongWord;//�Զ������ۼ�ʱ��(����)
    nExpSkill69: Integer;//�ڹ���ǰ����
    HumNGMagics: THumNGMagics;//�ڹ�����
    HumTitles: THumTitles;//�ƺ�����  20110130
    m_nReserved1: Word;//��������
    m_nReserved2: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved3: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved4: LongWord;//�����ؼ�ʹ��ʱ��
    m_nReserved5: LongWord;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����)
    m_nReserved6: LongWord;//�����ۼ��ڹ�����(����)
    m_nReserved7: Word;//����Ӣ���ڹ��ȼ�(����)
    m_nReserved8: Word;//����Ӣ���ڹ��ȼ�(����)
    Proficiency: Word;//������(�������ؾ���)
    Reserved2: Word;//��������(����)
    Reserved3: Word;//��ǰ��Ԫֵ(����)
    Reserved4: Word;//��ǰ��תֵ
    Exp68: LongWord;//�����ʼ��Ԫֵ������
    sHeartName: String[12];//�����Զ����ķ����� 20110808
    SpiritMedia: TUserItem;//��ýװ��λ
    UnKnow1: TUnKnow1;//Ԥ��6��Word����  20110130
    Reserved5: LongWord;//Ԥ������1 20110812******
    Reserved6: LongWord;//Ԥ������2 20110812******
    Reserved7: LongWord;//Ԥ������3 20110812******
  end;
  
//-----------------------(�ɽṹ)------------------------------------------------
  pTHumData = ^THumData;
  THumData = packed record //(�ķ�ϵͳ)���ݽṹ 20110812
    sChrName: string[ACTORNAMELEN];//����
    sCurMap: string[MAPNAMELEN];//��ͼ
    wCurX: Word; //����X
    wCurY: Word; //����Y
    btDir: Byte; //����
    btHair: Byte;//ͷ��
    btSex: Byte; //�Ա�(0-�� 1-Ů)
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nGold: Integer;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)
    Abil: TOldAbility;//+40 ������������
    wStatusTimeArr: TStatusTime; //+24 ����״̬����ֵ��һ���ǳ���������
    sHomeMap: string[MAPNAMELEN];//Home ��(����),�����Ƿ��һ���ٻ�(Ӣ��)
    wHomeX: Word;//Home X
    wHomeY: Word;//Home Y
    sDearName: string[ACTORNAMELEN]; //����(��ż)
    sMasterName: string[ACTORNAMELEN];//����-ʦ������ Ӣ��-��������
    boMaster: Boolean;//�Ƿ���ͽ��
    btCreditPoint: Integer;//������
    btDivorce: Byte; //(����)�Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(btDivorce��UnKnow[25]��ϳ�word)
    btMarryCount: Byte; //������
    sStoragePwd: string[7];//�ֿ�����
    btReLevel: Byte;//ת���ȼ�
    btUnKnow2: array[0..2] of Byte;//0-�Ƿ�ͨԪ������(1-��ͨ) 1-�Ƿ�Ĵ�Ӣ��(1-����Ӣ��) 2-����ʱ�Ƶ�Ʒ��
    BonusAbil: TNakedAbility; //+20 ���������ֵ
    nBonusPoint: Integer;//������
    nGameGold: Integer;//��Ϸ��(Ԫ��)
    nGameDiaMond: Integer;//���ʯ
    nGameGird: Integer;//���
    nGamePoint: Integer;//��Ϸ��
    btGameGlory: Integer; //����
    nPayMentPoint: Integer; //��ֵ��
    nLoyal: LongWord;//�ҳ϶�(Ӣ��) �����ۼƾ���(����)
    nPKPOINT: Integer;//PK����
    btAllowGroup: Byte;//�������
    btF9: Byte;
    btAttatckMode: Byte;//����ģʽ
    btIncHealth: Byte;//���ӽ�����
    btIncSpell: Byte;//���ӹ�����
    btIncHealing: Byte;//����������
    btFightZoneDieCount: Byte;//���л�ռ����ͼ����������
    sAccount: string[10];//��¼�ʺ�
    btEF: Byte;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
    boLockLogon: Boolean;//�Ƿ�������½
    wContribution: Word;//����ֵ(����) �Ⱦ�ʱ��,���㳤ʱ��ûʹ�úȾ�(Ӣ��)
    nHungerStatus: Integer;//����״̬(����)
    boAllowGuildReCall: Boolean;//�Ƿ������л��һ
    wGroupRcallTime: Word; //�Ӵ���ʱ��
    dBodyLuck: Double; //���˶�  8
    boAllowGroupReCall: Boolean; //�Ƿ�������غ�һ
    nEXPRATE: Integer; //���鱶��
    nExpTime: LongWord; //���鱶��ʱ��
    btLastOutStatus: Byte; //�˳�״̬ 1Ϊ�����˳�
    wMasterCount: Word; //��ʦͽ����
    boHasHero: Boolean; //�Ƿ��а�����Ӣ��(����ʹ��)
    boIsHero: Boolean; //�Ƿ���Ӣ��
    btStatus: Byte; //Ӣ��״̬(Ӣ��) ��ѡ����ְҵ(����)
    sHeroChrName: string[ACTORNAMELEN];//Ӣ������, size=15
    sHeroChrName1: string[ACTORNAMELEN];//����Ӣ����(size=15) 20110130
    UnKnow: TUnKnow;//44: 0-3���ʹ�� 4-����ʱ�Ķ��� 5-ħ���ܵȼ� 6-�Ƿ�ѧ���ڹ�
                    //7-�ڹ��ȼ�(1) 8-ʹ����Ʒ�ı�˵������ɫ  9..16�������� 17..20�������ӵ���������
                    //21�Ƿ�ѧ���������� 22..24����������(0-������ 1-��ʾ"?") 25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ��
                    //26-�Ƿ�ѧ��������� 27-����Ӣ���Ƿ��Զ�����(����) 28-���ĸ�����������(0-������ 1-��ʾ"?")
                    //29-���������Ƿ���� 30-����ֵ(�������ؾ���) 31-����ֵ 32-�澭(0-δѧϰ 1-��� 2-�м� 3-���� 4-�˷� 5-ӿȪ)
                    //33-�ڹ��ȼ�(2) 34-��������(�ƺ�ʹ��) 35-�Ƿ�ͻ��99����ת 36-�����ķ�����
    QuestFlag: TQuestFlag; //�ű�����
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    BagItems: TBagItems; //����װ��
    HumMagics: TNewHumMagics;//��ͨħ��
    StorageItems: TStorageItems;//�ֿ���Ʒ

    HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
    {$if Version <> 0}//0404
    NewHumAddItems: TNewHumAddItems;//����1�� ����
    {$ifend}
    n_WinExp: LongWord;//�ۼƾ���
    n_UsesItemTick: Integer;//������ۼ�ʱ��
    nReserved: LongWord; //(����)��Ƶ�ʱ��,�����ж೤ʱ�����ȡ�ؾ� (Ӣ��)������������
    nReserved1: Integer; //��ǰҩ��ֵ
    nReserved2: Integer; //ҩ��ֵ����
    nReserved3: Integer; //ʹ��ҩ��ʱ��,���㳤ʱ��ûʹ��ҩ��
    n_Reserved: Word;   //��ǰ����ֵ
    n_Reserved1: Word;  //��������
    n_Reserved2: Word;  //��ǰ��ƶ�
    n_Reserved3: Word;  //ҩ��ֵ�ȼ�
    boReserved: Boolean; //�Ƿ������ T-�����(����)
    boReserved1: Boolean;//�Ƿ�������Ӣ��(����)
    boReserved2: Boolean;//�Ƿ���� T-������� (����)
    boReserved3: Boolean;//���Ƿ�Ⱦ�����(����)
    m_GiveDate: Integer;//������ȡ�л��Ȫ����(����)
    MaxExp68: LongWord;//�Զ������ۼ�ʱ��(����)
    nExpSkill69: Integer;//�ڹ���ǰ����
    HumNGMagics: THumNGMagics;//�ڹ�����
    HumTitles: THumTitles;//�ƺ�����  20110130
    m_nReserved1: Word;//��������
    m_nReserved2: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved3: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved4: LongWord;//�����ؼ�ʹ��ʱ��
    m_nReserved5: LongWord;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����)
    m_nReserved6: LongWord;//�����ۼ��ڹ�����(����)
    m_nReserved7: Word;//����Ӣ���ڹ��ȼ�(����)
    m_nReserved8: Word;//����Ӣ���ڹ��ȼ�(����)
    Proficiency: Word;//������(�������ؾ���)
    Reserved2: Word;//��������(����)
    Reserved3: Word;//��ǰ��Ԫֵ(����)
    Reserved4: Word;//��ǰ��תֵ
    Exp68: LongWord;//�����ʼ��Ԫֵ������
    sHeartName: String[12];//�����Զ����ķ����� 20110808
    SpiritMedia: TUserItem;//��ýװ��λ
    UnKnow1: TUnKnow1;//Ԥ��6��Word����  20110130
    Reserved5: LongWord;//Ԥ������1 20110812******
    Reserved6: LongWord;//Ԥ������2 20110812******
    Reserved7: LongWord;//Ԥ������3 20110812******
  end;

  THumDataInfo = packed record //��
    Header: TRecordHeader;
    Data: THumData;
  end;
  pTHumDataInfo = ^THumDataInfo;

  TNewHumDataInfo = packed record //�µ����ݽṹ
    Header: TRecordHeader;
    Data: TNewHumData;
  end;
  pTNewHumDataInfo = ^TNewHumDataInfo;


  THeroData = packed record {�� ���������� Size = 2425}
    sHeroChrName: string[ACTORNAMELEN];//Ӣ������
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nHP: Integer;//��ǰHPֵ
    nMP: Integer;//��ǰMPֵ
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
    BagItems: TBagItems; //����װ��
    HumMagics: THumMagics;//��ͨħ��
    HumNGMagics: THumNGMagics;//�ڹ�����
  end;
  pTHeroData = ^THeroData;

  TNewHeroData = packed record {�� ���������� Size = 2425}
    sHeroChrName: string[ACTORNAMELEN];//Ӣ������
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nHP: Integer;//��ǰHPֵ
    nMP: Integer;//��ǰMPֵ
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
    BagItems: TBagItems; //����װ��
    HumMagics: TNewHumMagics;//��ͨħ��
    HumNGMagics: THumNGMagics;//�ڹ�����
  end;
  pTNewHeroData = ^TNewHeroData;

  THeroDataHeader = packed record
    boDeleted: Boolean; //�Ƿ�ɾ��
    dCreateDate: TDateTime; //����¼ʱ��
  end;
  pTHeroDataHeader = ^THeroDataHeader;

  THeroDataInfo = packed record//��
    Header: THeroDataHeader;
    Data: THeroData;
  end;
  pTHeroDataInfo = ^THeroDataInfo;

  TNewHeroDataInfo = packed record//��
    Header: THeroDataHeader;
    Data: TNewHeroData;
  end;
  pTNewHeroDataInfo = ^TNewHeroDataInfo;
    
function  GetFirstChar(const  AHzStr:  string):  string;
function  GetWWIndex(const S: string): Integer;
function  _Max14ReName(S: string; DefChar: Char): string;
function  _Max10ReName(S: string; DefChar: Char): string;

implementation

function  GetFirstChar(const  AHzStr:  string):  string;
const
   ChinaCode:  array[0..25,  0..1]  of  Integer  =  ((1601,  1636),
                                                     (1637,  1832),
                                                     (1833,  2077),
                                                     (2078,  2273),
                                                     (2274,  2301),
                                                     (2302,  2432),
                                                     (2433,  2593),
                                                     (2594,  2786),
                                                     (9999,  0000),
                                                     (2787,  3105),
                                                     (3106,  3211),
                                                     (3212,  3471),
                                                     (3472,  3634),
                                                     (3635,  3722),
                                                     (3723,  3729),
                                                     (3730,  3857),
                                                     (3858,  4026),
                                                     (4027,  4085),
                                                     (4086,  4389),
                                                     (4390,  4557),
                                                     (9999,  0000),
                                                     (9999,  0000),
                                                     (4558,  4683),
                                                     (4684,  4924),
                                                     (4925,  5248),
                                                     (5249,  5589));
var  
   i, j, HzOrd:  Integer;
begin  
   i  :=  1;
   while  i  <=  Length(AHzStr)  do  
    begin
      if  (AHzStr[i]  >=  #160)  and  (AHzStr[i  +  1]  >=  #160)  then
        begin
          HzOrd  :=  (Ord(AHzStr[i])  -  160)  *  100  +  Ord(AHzStr[i  +  1])  -  160;
          for  j  :=  0  to  25  do
            begin
              if  (HzOrd  >=  ChinaCode[j][0])  and  (HzOrd  <=  ChinaCode[j][1])  then
               begin
                Result  :=  Result  +  Char(Byte('A')  +  j);
                Break;
               end;
            end;
          Inc(i);
        end  else  Result  :=  Result  +  AHzStr[i];
      Inc(i);
    end;
  Result := UpperCase(Result);
end;

function GetWWIndex(const S: string): Integer;
var
  Str2: string;
begin
  Str2  :=  GetFirstChar(S);
  Result  := High(TListArray);
  if Str2 <> '' then
    begin
      Result := Ord(Str2[1]);
      if Result < 65 then
        Result := Result - 47 + 90;
    end;
  if Result > High(TListArray) - 1
    then Result := High(TListArray);
end;

function  _Max14ReName(S: string; DefChar: Char): string;
begin
  if Length(S) >= 14 then
    begin
     case ByteType(S, Length(S)) of
       mbSingleByte: S := Copy(S, 1, Length(S) - 1);
       mbLeadByte,
       mbTrailByte : S := Copy(S, 1, Length(S) - 2);
     end;
    end;
  Result  := S + DefChar;
end;

function  _Max10ReName(S: string; DefChar: Char): string;
begin
  if Length(S) >= 10 then
    begin
     case ByteType(S, Length(S)) of
       mbSingleByte: S := Copy(S, 1, Length(S) - 1);
       mbLeadByte,
       mbTrailByte : S := Copy(S, 1, Length(S) - 2);
     end;
    end;
  Result  := S + DefChar;
end;

end.

