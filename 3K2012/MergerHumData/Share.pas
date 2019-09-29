unit Share;

interface

///////////////////////Ӣ�۰����ݿ�ṹ����////////////////////////////////////////////
resourcestring
  sDBHeaderDesc = '3K�������ݿ��ļ� 2011/03/11';

const
  g_sProductName = '868217CBFB2539C4CA02C63660C482A3221DECC20028A7E50D7F5D73905DAA27CC418BAACE95E89D'; //��Ȩ���� (C) 2009-2010 3K�Ƽ�
  g_sURL1 = 'C5DB86D6E7E9CDE140574B5A981AB175F035B21DBC70456C'; //Http://www.3KM2.com
  nDBVersion = 20110311;//DB�汾��

  MAPNAMELEN = 16;//��ͼ������
  ACTORNAMELEN = 14;//���ֳ���
  MAX_STATUS_ATTRIBUTE = 12;//״̬���Ը���

  SAVEITEMNAME      = 'UserData.dat';//������Ʒ�ļ�
  USERDATADIR       = 'UserData\';
type
//id.db�ļ�ͷ
 TIdHeader = packed record //Size 124
    sDesc: string[34]; //0x00
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
    nLastIndex: Integer; //0x5C
    dLastDate: TDateTime; //0x60
    nIDCount: Integer; //0x68
    n6C: Integer; //0x6C
    nDeletedIdx: Integer; //0x70
    dUpdateDate: TDateTime; //0x74
  end;

  //ID�ʺ���������
  TIdxRecord = packed record
    sName: string[11];
    nIndex: Integer;
  end;

  //ID�ʺż�¼ͷ
  TIDRecordHeader = packed record
    boDeleted:boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    UpdateDate: TDateTime;
    sAccount: string[11];
  end;

 //ID�ʺż�¼�û���Ϣ
  TUserEntry = packed record
    sAccount: string[10];//�˺�
    sPassword: string[10];//����
    sUserName: string[20];//�û�����
    sSSNo: string[14];//���֤
    sPhone: string[14];//�绰
    sQuiz: string[20];//����1
    sAnswer: string[12];//��1
    sEMail: string[40];//����
  end;

// ID�ʺż�¼�û���ַ��
  TUserEntryAdd = packed record
    sQuiz2: string[20];//����2
    sAnswer2: string[12];//��2
    sBirthDay: string[10];//����
    sMobilePhone: string[13];//�ƶ��绰
    sMemo: string[20];//��עһ
    sMemo2: string[20];//��ע��
  end;

 //ID�ʺż�¼����
  TAccountDBRecord = packed record
    Header: TIDRecordHeader;
    UserEntry: TUserEntry;
    UserEntryAdd: TUserEntryAdd;
    nErrorCount: Integer;
    dwActionTick: LongWord;
    N: array[0..38] of Byte;
  end;

/////////////////////////////////////////////////////////////////////
//������¼ͷ(Hum.db Mir.db����)
  TRecordHeader = packed record //Size 28
    boDeleted: Boolean; //�Ƿ�ɾ��
    nSelectID: Byte;   //ID
    boIsHero: Boolean; //�Ƿ�Ӣ��
    bt2: Byte;
    dCreateDate: TDateTime; //����¼ʱ��
    sName: string[15]; //��ɫ����   28
  end;
  
  ///hum.db�ļ���¼
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
/////////////////////////////////////////////////////////////////////
//Hum.DB, Mir.db�ļ�ͷ
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

  //���������
  TdbxRecord = record
    sChrName: string[15];
    nIndex: Integer;
  end;

    //���Ե����
  TNakedAbility = packed record //Size 20 OK
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

   //��������
  TOAbility = packed record//��������ʹ��  size 40 OK
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
    Exp: Int64;//��ǰ����
    MaxExp: Int64;//��������
    Weight: Word;
    MaxWeight: Word;//�������
    WearWeight: Byte;
    MaxWearWeight: Byte;//�����
    HandWeight: Byte;
    MaxHandWeight: Byte;//����
  end;

  TUserItem = packed record//��Ʒ
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: array[0..20] of Byte;//��������:8-����װ�� 9-(��������)װ���ȼ� 12-����(1Ϊ����,0������,2�����鲻�ܾۼ� ����,�·�,ͷ����Ч),13-�Զ�������,14-��ֹ��,15-��ֹ����,16-��ֹ��,17-��ֹ��,18-��ֹ����,19-��ֹ���� 20-����(������,1-��ʼ�۾���,2-�۽���) 11-�����౩���ȼ� 8-������Ʒ 10-������������(1-���� 10-12����DC, 20-22����MC��30-32����SC)
    btUnKnowValue: array[0..9] of Byte;//0-�Ƿ�ɼ���(1-�ɼ��� 2-һ�� 3-���� 4-����) 1-���ڶ�����������(0-�� 1-1������ 2-2������ 3-3������ 4-4������) δ֪����(����ʹ��)

    AddValue: array[0..2] of Byte;//0-1��ʱ��Ʒ 2����
    MaxDate: TDateTime;//���ʹ������ ��AddValue[0]��1ʱ����ʱ��ɾ����Ʒ����ʱ��Ʒ
  end ;

  THumMagic = record //���＼��(DB)
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ�  Ӣ��:0-���ܿ�,1--���ܹ�
    nTranPoint: LongWord; //��ǰ����ֵ
    btLevelEx: Byte;//ǿ���ȼ�  20110812 ��չ********
  end;
  THumNGMagic = record //�ڹ�����(DB)
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ�  Ӣ��:0-���ܿ�,1--���ܹ�
    nTranPoint: LongWord; //��ǰ����ֵ
  end;

  THumTitle = packed record//����ƺŽṹ(��������)
    ApplyDate: TDateTime;//����ʱ��
    MakeIndex: Integer;//�ƺ�����ID
    wIndex: Word; //�ƺ�����id
    boUseTitle: Boolean;//ʹ�ô˳ƺ�
    wDura: Word;//ǧ�ﴫ������(ˮ��֮��)
    wMaxDura: Word;
    sChrName: string[ACTORNAMELEN];//������(��������������ʹ��) ���߼���Ӧ��ɫ�Ƿ����ߣ�ͬ��ż����
  end;

  THumTitles = array[0..7] of THumTitle;//����ƺ� 20110124***����****
  TUnKnow1 = array[0..5] of Word;//Ԥ��6��Word���� 20110124***����****
  
  TUnKnow = array[0..44] of Byte;
  TQuestFlag = array[0..127] of Byte;
  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;
  THumItems = array[0..8] of TUserItem;//9��װ��
  THumAddItems = array[9..14] of TUserItem;//����4��װ�� ��չ֧�ֶ���
  TBagItems = array[0..45] of TUserItem;//������Ʒ
  TStorageItems = array[0..45] of TUserItem;
  THumMagics = array[0..{29}34] of THumMagic;//���＼�� 20110812 ��չ********
  THumNGMagics = array[0..29] of THumNGMagic;//�ڹ�����
  
 //������˼�¼��״̬����
  THumData = packed record {���������� Size = 5757 Ԥ��N������ 20100804}
    sChrName: string[ACTORNAMELEN];//����
    sCurMap: string[MAPNAMELEN];//��ͼ
    wCurX: Word; //����X
    wCurY: Word; //����Y
    btDir: Byte; //����
    btHair: Byte;//ͷ��
    btSex: Byte; //�Ա�(0-�� 1-Ů)
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nGold: Integer;//�����(����) Ӣ��ŭ��ֵ(Ӣ��)
    Abil: TOAbility;//+40 ������������
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
    HumMagics: THumMagics;//��ͨħ��
    StorageItems: TStorageItems;//�ֿ���Ʒ
    HumAddItems: THumAddItems;//����4�� ����� ���� Ь�� ��ʯ
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
    Reserved5: LongWord;//��Ϸ����������
    Reserved6: LongWord;//Ԥ������2 20110812******
    Reserved7: LongWord;//Ԥ������3 20110812******
  end;
///����������¼����
  THumDataInfo = packed record //Size 5785 OK
    Header: TRecordHeader;
    Data: THumData;
  end;
//-------------------����Ӣ�����ݽṹHeroMir.db---------------------------------
  TNewHeroData = packed record {���������� Size = 2425}
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

  TNewHeroDataHeader = packed record
    boDeleted: Boolean; //�Ƿ�ɾ��
    dCreateDate: TDateTime; //����¼ʱ��
  end;

  TNewHeroDataInfo = packed record
    Header: TNewHeroDataHeader;
    Data: TNewHeroData;
  end;
//------------------------------------------------------------------------------
  TDealOffInfo = packed record //Ԫ���������ݽṹ
    sDealCharName: string[ACTORNAMELEN];//������ *
    sBuyCharName: string[ACTORNAMELEN];//������
    dSellDateTime: TDateTime;//����ʱ��
    nSellGold: Integer;//���׵�Ԫ����
    UseItems: array[0..9] of TUserItem;//��Ʒ
    N: Byte;//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 2-���׽���(�õ�Ԫ��) 3-������ȡ�� 4-���ڲ�����
  end;
  pTDealOffInfo = ^TDealOffInfo;

  TBigStorage = packed record //���޲ֿ����ݽṹ
    boDelete: Boolean;
    sCharName: string[14];
    SaveDateTime: TDateTime;
    UseItems: TUserItem;
    nCount: Integer;
  end;
  pTBigStorage = ^TBigStorage;  

  TItemCount = Integer;

//�������ݶ���
 TPlacingHead=packed record
    dwDateTime:TDateTime;
    nCount:integer;    //20
    n1:integer;        //24
    n2:integer;        //28
    n3:integer;        //32
    n4:integer;        //36
    n5:integer;        //40
  end;

  TUserPlacing =packed  record
    Item      :TUserItem;
    nPrice    :Integer;
    nPicCls   :Boolean;
    nTime     :TDateTime;
    sName     :String[ActorNameLen];
    sItemName :String[ActorNameLen];
    boSell    :Boolean;
    nIdx      :Byte;
  end;
  pTUserPlacing = ^TUserPlacing;   

implementation

end.
