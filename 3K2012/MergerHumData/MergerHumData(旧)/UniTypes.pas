unit UniTypes;

interface

uses SysUtils, Classes,Windows;

const
  MAX_STATUS_ATTRIBUTE = 12;
  MAPNAMELEN = 16;//��ͼ������
  ACTORNAMELEN = 14;//���ֳ���

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
    n70: Integer; //DB�汾��
    dUpdateDate: TDateTime; //��������
  end;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean; //�Ƿ�ɾ��
    nSelectID: Byte;   //ID
    boIsHero: Boolean; //�Ƿ�Ӣ��
    bt2: Byte;
    dCreateDate: TDateTime; //����ʱ��
    sName: string[15]; //��ɫ����   28
  end;
  pTRecordHeader = ^TRecordHeader;

{THumInfo}
  pTDBHum = ^TDBHum;
  TDBHum = packed record//FileHead  72�ֽ�   //Size 72
    Header: TRecordHeader;
    sChrName: string[14]; //��ɫ����   44
    sAccount: string[10]; //�˺�
    boDeleted: Boolean; //�Ƿ�ɾ��
    bt1: Byte; //δ֪
    dModDate: TDateTime;//��������
    btCount: Byte; //�����ƴ�
    boSelected: Boolean; //�Ƿ�ѡ��
    n6: array[0..5] of Byte;
  end;

  TUserItem = record // 20080313 �޸�
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: array[0..20] of Byte;//��������  12-����  13-�Զ�������
    btUnKnowValue: array[0..9] of Byte;//δ֪����(����ʹ��)
  end;

  TOAbility = packed record
    Level: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: Word;
    MP: Word;
    MaxHP: Word;
    MaxMP: Word;
    NG: Word;//20081001 ��ǰ����ֵ
    MaxNG: Word;//20081001 ����ֵ����
    Exp: LongWord;
    MaxExp: LongWord;
    Weight: Word;
    MaxWeight: Word; //����
    WearWeight: Byte;
    MaxWearWeight: Byte; //����
    HandWeight: Byte;
    MaxHandWeight: Byte; //����
  end;

  TNakedAbility = packed record //Size 20
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

  THumMagicInfo = record
    wMagIdx: Word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: LongWord; //��ǰ����ֵ
  end;

  TUnKnow = array[0..44] of Byte;
  TStatusTime = array[0..11] of Word;
  TQuestUnit = Array[0..127] of Byte;
  TQuestFlag = array[0..127] of Byte;

  THumItems=Array[0..8] of TUserItem;
  THumAddItems=Array[9..13] of TUserItem;//֧�ֶ��� 20080416
  TBagItems=Array[0..45] of TUserItem;
  THumMagics=Array[0..29] of THumMagicInfo;
  THumNGMagics = array[0..29] of THumMagicInfo;//�ڹ����� 20081001
  TStorageItems=Array[0..45] of TUserItem; //20071115
  TAddBagItems=Array[46..51] of TUSerItem;

  THumData = packed record {���������� Size = 4402 Ԥ��N������ 20081227}
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
    nGameGold: Integer;//��Ϸ��
    nGameDiaMond: Integer;//���ʯ
    nGameGird: Integer;//���
    nGamePoint: Integer;//����
    btGameGlory: Integer; //����(***Byte��չ��Integer****)
    nPayMentPoint: Integer; //��ֵ��
    nLoyal: LongWord;//�ҳ϶�(Ӣ��) �����ۼƾ���(����) 20100113 ��ΪLongWord����  
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
    UnKnow: TUnKnow;//
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
    m_nReserved1: Word;//��������
    m_nReserved2: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved3: Word;//����Ӣ�۵ȼ�(����)
    m_nReserved4: LongWord;//�����ؼ�ʹ��ʱ��
    m_nReserved5: LongWord;//ʹ����Ʒ(����,����,����)�ı�˵����ɫ��ʹ��ʱ��(����) 
    m_nReserved6: LongWord;//�����ۼ��ڹ�����(����)
    m_nReserved7: Word;//����Ӣ���ڹ��ȼ�(����)
    m_nReserved8: Word;//����Ӣ���ڹ��ȼ�(����)
    Reserved1: Word;//Ԥ������1
    Reserved2: Word;//Ԥ������2
    Reserved3: Word;//Ԥ������3
    Reserved4: Word;//Ԥ������4
    Exp68: LongWord;//����ʹ�ô˱���
    Reserved5: LongWord;//Ԥ������5
    Reserved6: LongWord;//Ԥ������6
    Reserved7: LongWord;//Ԥ������7

    {Reserved8: LongWord;//Ԥ������8
    Reserved9: LongWord;//Ԥ������9
    Reserved10: LongWord;//Ԥ������10
    Reserved11: LongWord;//Ԥ������11
    Reserved12: Word;//Ԥ������12
    Reserved13: Word;//Ԥ������13
    Reserved14: Word;//Ԥ������14
    Reserved15: Word;//Ԥ������15
    Reserved16: Word;//Ԥ������16
    Reserved17: Word;//Ԥ������17
    Reserved18: Word;//Ԥ������18
    sReservedName: string[ACTORNAMELEN];//Ԥ������9 }
    Reserved8: Byte;//Ԥ������8
    SpiritMedia: TUserItem;//��ýװ��λ    
  end;

  THumDataInfo = packed record //Size 3176
    Header: TRecordHeader;
    Data: THumData;
  end;
  
//�û�ע����Ϣ,��ID�˺�
  TUserEntry = packed record
    sAccount: string[10];//�˺�
    sPassword: string[10];//����
    sUserName: string[20];//�û���
    sSSNo: string[14];  //���֤
    sPhone: string[14];//�绰
    sQuiz: string[20];//����1
    sAnswer: string[12];//��1
    sEMail: string[40]; //����
  end;

  TUserEntryAdd = packed record
    sQuiz2: string[20];//����2
    sAnswer2: string[12];//��2
    sBirthDay: string[10];//����
    sMobilePhone: string[13];//�ƶ��绰
    sMemo: string[20];//��עһ
    sMemo2: string[20];//��ע��
  end;

//�˺ż�¼ͷ   size 32
  TIDRecordHeader = packed record
    boDeleted: Boolean;//�Ƿ�ɾ��
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime; //����ʱ��
    UpdateDate: TDateTime; //����¼ʱ��
    sAccount: string[11]; //�˺�
  end;

  TAccountDBRecord = packed record  //size 328
    Header: TIDRecordHeader;//�˺ż�¼ͷ
    UserEntry: TUserEntry;//ID�˺���Ϣ1
    UserEntryAdd: TUserEntryAdd;//ID�˺���Ϣ2
    nErrorCount: Integer;
    dwActionTick: LongWord;
    N: array[0..38] of Byte;
  end;

  TRecordDeletedHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    LastLoginDate: TDateTime;
    n14: Integer;
    nNextDeletedIdx: Integer;
  end;    

  TDealOffInfo = packed record //Ԫ���������ݽṹ
    sDealCharName: string[14];//������
    sBuyCharName: string[14];//������
    dSellDateTime: TDateTime;//����ʱ��
    nSellGold: Integer;//���׵�Ԫ����
    UseItems: array[0..9] of TUserItem;//��Ʒ
    N: Byte;//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 2-������ȡ��  3-���׽���(�õ�Ԫ��)
  end;
  pTDealOffInfo = ^TDealOffInfo;

  TDearData = packed record//��ż����(����ʹ��)  �����֣�������Ҳ�ô���
    sDearName: string[14];//��ż��
    sNewHumName: string[14];//������
  end;
  pTDearData = ^TDearData;

  TMasterData = packed record//ʦ������(����ʹ��)
    sName: string[14];//ԭ����
    sMasterName: string[14];//ʦ����
    sNewHumName: string[14];//������
  end;
  pTMasterData = ^TMasterData;

  THeroData = packed record//Ӣ������(����ʹ��)
    sHeroName: string[14];//Ӣ����
    sNewHumName: string[14];//��Ӣ����
    sMasterName: string[14];//������
    sAccount: string[11]; //�˺�
    nHeroType: Byte;//Ӣ������ 0-����Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
  end;
  pTHeroData = ^THeroData;

  TItemCount = Integer;

  TBigStorage = packed record //���޲ֿ����ݽṹ
    boDelete: Boolean;
    sCharName: string[14];
    SaveDateTime: TDateTime;
    UseItems: TUserItem;
    nCount: Integer;
  end;
  pTBigStorage = ^TBigStorage;

  //�ı��ϲ����ݽṹ 20080703
  TTxtData =  packed record
    nTxtTpye: Byte;//�ı����� 0-��ͨ�ı�(ֻ������) 1-ini����
    sFileName: string;//�ı���(XXX.txt)
    sData:TList;//�ı�����(������)
    boMakeOne: Boolean;
  end;
  pTTxtData = ^TTxtData;

  TTxtInfo =  packed record
    sHumName: string;//��ͨ�ı�-������� ini�ı�-�������,���ڵ�
    sKeyword: String;//ini�ؼ���,��ͨ�ı�����
    sIniValue: string;//iniֵ
  end;
  pTTxtInfo = ^TTxtInfo;

//------------------------------------------------------------------------------
  TNewHeroData = packed record {���������� Size = 2425}
    sHeroChrName: string[14];//Ӣ������
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
  pTNewHeroDataHeader = ^TNewHeroDataHeader;

  TNewHeroDataInfo = packed record
    Header: TNewHeroDataHeader;
    Data: TNewHeroData;
  end;
  pTNewHeroDataInfo = ^TNewHeroDataInfo;

//--------------------HumHero.dbʹ�ýṹ----------------------------------------
  TNewHeroName = record //����Ӣ������
    sChrName: string[14];//��������
    sNewHeroName: string[14];//��������
  end;
  pTNewHeroName = ^TNewHeroName;

  THeroNameInfo = packed record
    Header: TNewHeroDataHeader;
    Data: TNewHeroName;
  end;
  pTHeroNameInfo = ^THeroNameInfo;
  
const
  DBFileDesc = '3K�������ݿ��ļ� 2010/08/04';
  sDBIdxHeaderDesc = '3K�������ݿ������ļ� 2010/08/04';
  nDBVersion = 20100826;//DB�汾��
var
  boDataDBReady: Boolean; //0x004ADAF4
  boHumDBReady: Boolean;
  g_boDataDBReady: Boolean; //20081128

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
  if Length(S) >= 14 then begin
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

