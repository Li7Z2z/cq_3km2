unit Grobal2;

interface
uses
  Windows;
const
  M2Version = 1;//0-0627�����(������-�ڹ�) 1-���°�(�ڹ�+������) 2-1.76��(���ڹ�,������)ʹ�ò�ͬ����Ϣ�����㷨 20100711
  CLIENT_VERSION_NUMBER = 920080512;//9+�ͻ��˰汾�� 20090208
  
  DEFBLOCKSIZE = {16}22;//20081216
  BUFFERSIZE = 10000;

  CM_DROPITEM = 1000;
  CM_PICKUP = 1001;
  CM_EAT = 1005; //ʹ����Ʒ,��ҩ
  CM_HEROEAT = 5043;       //�Զ���
  SM_HEROEAT_FAIL = 5045; //�Զ���ʧ��
  SM_EAT_FAIL = 636;
  CM_BUTCH = 1007;//��

  CM_THROW = 3005;
  CM_TURN = 3010;//ת��(����ı�)
  CM_WALK = 3011;
  CM_SITDOWN = 3012;
  CM_RUN = 3013;
  CM_HIT = 3014;
  CM_HEAVYHIT = 3015;
  CM_BIGHIT = 3016;
  CM_SPELL = 3017;
  CM_POWERHIT = 3018;
  CM_LONGHIT = 3019;
  CM_LONGHIT4 = 3020;//�ļ���ɱ
  CM_WIDEHIT4 = 3021;//Բ���䵶(�ļ�����)

  CM_LONGHITFORFENGHAO = 10191;//��ɱ�ۺ�Ч��
  CM_FIREHITFORFENGHAO = 10193;//�һ�ۺ�Ч��
  CM_DAILYFORFENGHAO = 10195;//���շۺ�Ч��
  CM_CRSHIT = 3036; //���µ�
  CM_4FIREHIT = 3031; //4���һ𹥻�

  CM_WIDEHIT = 3024;
  CM_FIREHIT = 3025;
  CM_DAILY = 3042; //���ս��� 20080511
  CM_CIDHIT = 3040; //��Ӱ����
  CM_TWNHIT = 3037; //����ն�ػ�
  CM_QTWINHIT = 3041; //����ն���
  CM_BLOODSOUL = 3048;//Ѫ��һ��(ս)

  CM_SAY = 3030;

  //CM_USERBUYITEM = 1014; //�û����붫��
  CM_BUYSHOPITEM = 9002;
  CM_BUYSHOPITEMGIVE = 9006; //����
  CM_EXCHANGEGAMEGIRD = 20042; //���̶һ����
  CM_MERCHANTDLGSELECT = 1011; //��Ʒѡ��,����,�����������Ϣ�󷵻�
  CM_OPENHEROPULSEPOINT = 20225;//�ͻ��˵��Ӣ��Ѩλ
  CM_REPAIRDRAGON = 5061;  //ף����.ħ�������
  CM_REPAIRFINEITEM = 20060; //�޲�����ʯ
  CM_GETBOXS  = 20031;//�ͻ���ȡ�ñ�����Ʒ
  CM_QUERYBAGITEMS = 81;  //��ѯ������Ʒ
  CM_CLICKSIGHICON = 20165; //�����̾��ͼ��
  CM_CLICKCRYSTALEXPTOP = 20172; //�����ؽᾧ��þ���
  CM_CHALLENGETRY = 20115;//��ҵ���ս
  CM_DEALTRY = 1025;  //��ʼ����,���׿�ʼ
  CM_ITEMSPLIT = 20189;//�ͻ��˲����Ʒ
  CM_ITEMMERGER = 20190;//�ͻ��˺ϲ���Ʒ
  CM_EXERCISEKIMNEEDLE = 20193;//�ͻ��˿�ʼ����
  CM_OPENPULSEPOINT = 20198;//�ͻ��˵��Ѩλ
  CM_CLICKBATTERNPC = 20199; //����NPCִ�д����ű���
  CM_PRACTICEPULSE = 20201;//�ͻ�����������
  CM_HEROPRACTICEPULSE = 20227;//�ͻ���Ӣ����������

  RUNGATECODE = $AA55AA55;

  RUNGATEMAX = 20;
  // For Game Gate
  GM_OPEN = 1;
  GM_CLOSE = 2;
  GM_CHECKSERVER = 3; // Send check signal to Server
  GM_CHECKCLIENT = 4; // Send check signal to Client
  GM_DATA = 5;
  GM_SERVERUSERINDEX = 6;
  GM_RECEIVE_OK = 7;
  GM_TEST = 20;
  //GM_KickConn = 21;//20081221 ��Rungate.exe��Ӧ������

  OS_MOVINGOBJECT = 1;
  OS_ITEMOBJECT = 2;
  OS_EVENTOBJECT = 3;
  OS_GATEOBJECT = 4;
  OS_SWITCHOBJECT = 5;
  OS_MAPEVENT = 6;
  OS_DOOR = 7;
  OS_ROON = 8;

  RC_PLAYOBJECT = 1;
  RC_MONSTER = 2;
  RC_ANIMAL = 6;
  RC_NPC = 8;
  RC_PEACENPC = 9; //jacky

type
  TDefaultMessage = record
    Recog: Integer;
    Ident: word;
    Param: word;
    Tag: word;
    Series: word;
    nSessionID: Integer;//20081210
  end;
  pTDefaultMessage = ^TDefaultMessage;

  TMsgHeader = record
    dwCode: LongWord;//���ر�ʶ  RUNGATECODE
    nSocket: Integer; //0x04
    wGSocketIdx: Word; //0x08
    wIdent: Word; //��ϢID
    wUserListIndex: Word; //0x0C
    nLength: Integer; //0x10
  end;
  pTMsgHeader = ^TMsgHeader;
  function aa(const Value,key:Word):Word;
  function bb(const Value,key:Word):Word;  
implementation
{$IF M2Version <> 2}
//��ϢID����
function aa(const Value,key:Word):Word;
begin
  Result:=(Value+(key shl 3)) xor (key shr 1);
end;
//��ϢID����
function bb(const Value,key:Word):Word;
begin
  Result:= (Value xor (key shr 1)) - (key shl 3);
end;
{$ELSE}
//��ϢID����
function aa(const Value,key:Word):Word;
begin
  Result:=(Value+(key shl 6)) xor (key shr 2);
end;
//��ϢID����
function bb(const Value,key:Word):Word;
begin
  Result:= (Value xor (key shr 2)) - (key shl 6);
end;
{$IFEND}
end.
