unit Grobal2;//ȫ��(�������Ϳͻ���ͨ��)��Ϣ,���ݽṹ,������

interface

uses
  Windows, Classes, JSocket;
const
  M2var = 1;//������ƷbtValue14-19���ԣ���JSģʽ��ͬʱ�ı�AddValue[2]��255����ʶ����N���ȥ�� 20110528
  M2Sion = 0;//����(��ʾ��DBS��ͨѶ����)
  M2Version = 2; //0-0627�����(������+�ڹ�) 1-���°�(�ڹ�+������) 2-1.76��(���ڹ�,������)
  {$IF M2Version = 2}
  HEROVERSION = 0; //0-��ҵ��(��Ӣ��) 1-Ӣ�۰�
  {$ELSE}
  HEROVERSION = 1; //0-��ҵ��(��Ӣ��) 1-Ӣ�۰�
  {$IFEND}
  CLIENT_VERSION_NUMBER = 920121015;//9+�ͻ��˰汾�� 20091025����С��20080512ʱ��Run���ػ�����T�ˣ�RUN�����м���Լ���G��Ԫ������(20080512)
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MAPNAMELEN = 16;//��ͼ������
  ACTORNAMELEN = 14;//���ֳ���
  DEFBLOCKSIZE = {16}22;//20081221
  BUFFERSIZE = 10000; //���嶨�� Ӱ���������ݸ�ʽ GetCodeMsgSize(SizeOf(THumDataInfo) * 4 / 3)
  DATA_BUFSIZE2 = 16348; //8192;
  DATA_BUFSIZE = 8192; //8192;
  GROUPMAX = 11;
  BAGGOLD = 5000000;
  BODYLUCKUNIT = 10;
  MAX_STATUS_ATTRIBUTE = 12;//���״̬��         \

//����������ֻ��8������,���Ǵ��,�ƶ����,��ӥ����16���� (...���ƶ꿪ʼ�Ƿ�ƨ by TasNat)
  DR_UP = 0;//����
  DR_UPRIGHT = 1;//������
  DR_RIGHT = 2; //��
  DR_DOWNRIGHT = 3;//������
  DR_DOWN = 4;//��
  DR_DOWNLEFT = 5;//������
  DR_LEFT = 6;//��
  DR_UPLEFT = 7;//������

  MAXORDERSCOUNT = 2000;//���а񱣴�����

//װ����Ŀ
  U_DRESS = 0; //�·�
  U_WEAPON = 1; //����
  U_RIGHTHAND = 2; //ѫ��,��,���
  U_NECKLACE = 3; //����
  U_HELMET = 4; //ͷ��
  U_ARMRINGL = 5; //��������,��
  U_ARMRINGR = 6;//��������
  U_RINGL = 7;  //���ָ
  U_RINGR = 8;//�ҽ�ָ
  U_BUJUK = 9; //��Ʒ
  U_BELT = 10; //����
  U_BOOTS = 11; //Ь
  U_CHARM = 12; //��ʯ
  U_ZHULI = 13;//����
  U_DRUM = 14;//����
  U_TakeItemCount=15;
  X_RepairFir = 20; //�޲�����֮��

  POISON_LOCK1 = 2;//�ж�Ŀ��ķ�����ħ������0(Ψ�Ҷ���)
  POISON_LOCKSPELL = 7;//�����������ܹ����������ܣ�������
  POISON_DECHEALTH = 0;//�ж����ͣ��̶�,��Ѫ
  POISON_DAMAGEARMOR = 1;//�ж����ͣ��춾
  STATE_LOCKRUN = 3;//�����ܶ�(������) 20080811
  POISON_DONTMOVE = 4;//�����ƶ�����ս���� 20090903
  POISON_STONE = 5; //�ж�����:���
  POISON_SKILLDECHEALTH = 6;//�ж����ͣ���Ѫ�������������򽣹��ڻ��к��Ѫ 20090626

  STATE_STONE_MODE = 1;//��ʯ��
  STATE_TRANSPARENT = 8;//����
  STATE_DEFENCEUP = 9;//��ʥս����(������)
  STATE_MAGDEFENCEUP = 10;//�����(ħ����)
  STATE_BUBBLEDEFENCEUP = 11;//ħ����

  USERMODE_PLAYGAME = 1;
  USERMODE_LOGIN = 2;
  USERMODE_LOGOFF = 3;
  USERMODE_NOTICE = 4;

  RUNGATEMAX = 20;

  RUNGATECODE = $AA55AA55;

  OS_MOVINGOBJECT = 1;//�ƶ�����
  OS_ITEMOBJECT = 2;//��Ʒ
  OS_EVENTOBJECT = 3;//����
  OS_GATEOBJECT = 4;//��ͼ���ӵ�
  OS_SWITCHOBJECT = 5;
  OS_MAPEVENT = 6;
  OS_DOOR = 7;//��
  OS_ROON = 8;

  RC_PLAYOBJECT = 0;//����
  RC_PLAYMOSTER = 150; //���ι���
  RC_HEROOBJECT = 66; //Ӣ��
  RC_GUARD = 12; //������
  RC_PEACENPC = 15;
  RC_ANIMAL = 50;
  RC_MONSTER = 80;
  RC_NPC = 10;//NPC
  RC_ARCHERGUARD = 112;//NPC ������


  RCC_USERHUMAN = RC_PLAYOBJECT;
  RCC_GUARD = RC_GUARD;
  RCC_MERCHANT = RC_ANIMAL;

  //ISM_WHISPER = 1234;//20091022 ע��
//-------------------------�ͻ�����DBS������Ϣָ��------------------------------
  CM_QUERYCHR = 100;  //��¼�ɹ�,�ͻ����Գ����ҽ�ɫ����һ˲
  CM_NEWCHR = 101;      //������ɫ
  CM_DELCHR = 102;      //ɾ����ɫ
  CM_SELCHR = 103;      //ѡ���ɫ
  CM_SELECTSERVER = 104;//��ѯ����������,ע�ⲻ��ѡ��,ʢ��һ��������(����8��??group.dat������ôд��)��ֹһ���ķ�����
  CM_QUERYDELCHR = 105;//��ѯɾ�����Ľ�ɫ��Ϣ 20080706
  CM_RESDELCHR = 106;//�ָ�ɾ���Ľ�ɫ 20080706
  CM_HARDWARECODE = 107;
//------------------------LoginSrv.exe ʹ��-------------------------------------
  CM_PROTOCOL = 2000;//���汾��(LoginSrv nVersionDate����),3K�ͻ���δʹ��
  CM_IDPASSWORD = 2001; //�ͻ��������������ID������
  CM_ADDNEWUSER = 2002; //�½��û�,����ע�����˺�,��¼ʱѡ����"���û�"�������ɹ�
  CM_CHANGEPASSWORD = 2003;  //�޸�����
  CM_UPDATEUSER = 2004;  //����ע������??
  //CM_RANDOMCODE = 2006;//ȡ��֤�� 20080612 δʹ��
  SM_RANDOMCODE = 2007;
  CM_CLIENTCONN = 2008;//�ͻ������ӣ�֪ͨ�˺ų�������������Ϣ 20090310
  CM_GETBACKPASSWORD = 2010; //�����һ�

  SM_RUSH = 6; //�ܶ��иı䷽��
  SM_RUSHKUNG = 7; //Ұ����ײ
  SM_FIREHIT = 8; //�һ�
  SM_BACKSTEP = 9; //����,Ұ��Ч��? //����ͳ�칫���ֹ�����ҵĺ���??axemon.pas��procedure   TDualAxeOma.Run
  SM_TURN = 10; //ת��
  SM_WALK = 11; //��
  SM_SITDOWN = 12;
  SM_RUN = 13; //��
  SM_HIT = 14; //��
  SM_HEAVYHIT = 15; //
  SM_BIGHIT = 16; //
  SM_SPELL = 17; //ʹ��ħ��
  SM_POWERHIT = 18;//��ɱ
  SM_LONGHIT = 19; //��ɱ
  SM_DIGUP = 20;//����һ"��"һ"��",�������ڶ�����"��"
  SM_DIGDOWN = 21;//�ڶ�����"��"
  SM_FLYAXE = 22;//�ɸ�,����ͳ��Ĺ�����ʽ?
  SM_LIGHTING = 23;//��������
  SM_WIDEHIT = 24; //����
  SM_CRSHIT = 25; //���µ�
  SM_TWINHIT = 26; //����ն�ػ�
  SM_ALIVE = 27; //����??�����ָ
  SM_MOVEFAIL = 28; //�ƶ�ʧ��,�߶����ܶ�
  SM_HIDE = 29; //����?
  SM_DISAPPEAR = 30;//������Ʒ��ʧ
  SM_STRUCK = 31; //�ܹ���
  SM_DEATH = 32; //��������
  SM_SKELETON = 33; //ʬ��
  SM_NOWDEATH = 34; //��ɱ

  SM_HEAR = 40;  //���˻���Ļ�
  SM_FEATURECHANGED = 41;
  SM_USERNAME = 42;
  SM_WINEXP = 44;//��þ���
  SM_LEVELUP = 45; //����,���Ͻǳ���ī�̵���������
  SM_DAYCHANGING = 46;//����������½ǵ�̫����������

  SM_LOGON = 50;//logon
  SM_NEWMAP = 51; //�µ�ͼ??
  SM_ABILITY = 52;//�����ԶԻ���,F11
  SM_HEALTHSPELLCHANGED = 53;//������ʹ�����������
  SM_MAPDESCRIPTION = 54;//��ͼ����,�л�ս��ͼ?��������?��ȫ����?
  //SM_SPELL2 = 117;//20090901 δʹ��
  
  SM_CIDHIT = 57; //��Ӱ����
  SM_4FIREHIT = 58; //4���һ� 20080112
  SM_QTWINHIT = 59; //����ն���
  SM_LONGHIT4 = 60;//�ļ���ɱ
  SM_WIDEHIT4 = 61;//Բ���䵶

  SM_ACTION_MIN = SM_RUSH;
  SM_ACTION_MAX = SM_WIDEHIT;
  SM_ACTION2_MIN = 65072;
  SM_ACTION2_MAX = 65073;
  SM_AddEffecItemList= 1207;
//�Ի���Ϣ
  SM_MOVEMESSAGE = 99;
  SM_SYSMESSAGE = 100; //ϵͳ��Ϣ,ʢ��һ�����,˽������
  SM_GROUPMESSAGE = 101;//��������!!
  SM_CRY = 102; //����
  SM_WHISPER = 103;//˽��
  SM_GUILDMESSAGE = 104;  //�л�����!~

  SM_ADDITEM = 200;
  SM_BAGITEMS = 201;
  SM_DELITEM = 202;
  SM_UPDATEITEM = 203;
  SM_ADDMAGIC = 210;
  SM_SENDMYMAGIC = 211;
  SM_DELMAGIC = 212;

 //�������˷��͵����� SM:server msg,�������ͻ��˷��͵���Ϣ

//��¼�����ʺš��½�ɫ����ѯ��ɫ��  
  SM_CERTIFICATION_FAIL = 501;
  SM_ID_NOTFOUND = 502;
  SM_PASSWD_FAIL = 503;//��֤ʧ��,"��������֤ʧ��,��Ҫ���µ�¼"??
  SM_NEWID_SUCCESS = 504;//�������˺ųɹ�
  SM_NEWID_FAIL = 505; //�������˺�ʧ��
  SM_CHGPASSWD_SUCCESS = 506; //�޸�����ɹ�
  SM_CHGPASSWD_FAIL = 507;  //�޸�����ʧ��
  SM_GETBACKPASSWD_SUCCESS = 508; //�����һسɹ�
  SM_GETBACKPASSWD_FAIL = 509; //�����һ�ʧ��

  SM_QUERYCHR = 520; //���ؽ�ɫ��Ϣ���ͻ���
  SM_NEWCHR_SUCCESS = 521; //�½���ɫ�ɹ�
  SM_NEWCHR_FAIL = 522; //�½���ɫʧ��
  SM_DELCHR_SUCCESS = 523; //ɾ����ɫ�ɹ�
  SM_DELCHR_FAIL = 524; //ɾ����ɫʧ��
  SM_STARTPLAY = 525; //��ʼ������Ϸ����(���˽�����Ϸ�Ҹ�������Ϸ����)
  SM_STARTFAIL = 526; ////��ʼʧ��,�洫���������,��ʱѡ���ɫ,�㽡����Ϸ�Ҹ�����

  SM_QUERYCHR_FAIL = 527;//���ؽ�ɫ��Ϣ���ͻ���ʧ��
  SM_OUTOFCONNECTION = 528; //�������������,ǿ���û�����
  SM_SELECTSERVER = 529;  //���ͷ�����Ϣ����ʼѡ�� 20090309
  SM_SELECTSERVER_OK = 530;  //ѡ���ɹ�
  SM_PASSOK = 539;//����������ȷ�󣬷��ظ��ͻ���2009030
  SM_NEEDUPDATE_ACCOUNT = 531;//��Ҫ����,ע����ID�ᷢ��ʲô�仯?˽���е���ͨID������ֵ??��������ͨID��Ϊ��ԱID,GM?
  SM_UPDATEID_SUCCESS = 532; //���³ɹ�
  SM_UPDATEID_FAIL = 533;  //����ʧ��

  SM_QUERYDELCHR = 534;//����ɾ�����Ľ�ɫ 20080706
  SM_QUERYDELCHR_FAIL = 535;//����ɾ�����Ľ�ɫʧ�� 20080706
  SM_RESDELCHR_SUCCESS = 536;//�ָ�ɾ����ɫ�ɹ� 20080706
  SM_RESDELCHR_FAIL = 537;//�ָ�ɾ����ɫʧ�� 20080706
  SM_NOCANRESDELCHR = 538;//��ֹ�ָ�ɾ����ɫ,�����ɲ鿴 200800706

  SM_DROPITEM_SUCCESS = 600;
  SM_DROPITEM_FAIL = 601;

  SM_ITEMSHOW = 610;
  SM_ITEMHIDE = 611;
  //  SM_DOOROPEN           = 612;
  SM_OPENDOOR_OK = 612; //ͨ�����ŵ�ɹ�
  SM_OPENDOOR_LOCK = 613;//���ֹ��ſ��Ƿ�����,��ǰʢ������ͨ��ȥ���µ���Ҫ5���ӿ�һ��
  SM_CLOSEDOOR = 614;//�û�����,�����йر�
  SM_TAKEON_OK = 615;
  SM_TAKEON_FAIL = 616;
  SM_TAKEOFF_OK = 619;
  SM_TAKEOFF_FAIL = 620;
  SM_SENDUSEITEMS = 621;
  SM_WEIGHTCHANGED = 622;
  SM_CLEAROBJECTS = 633;
  SM_CHANGEMAP = 634; //��ͼ�ı�,�����µ�ͼ
  SM_EAT_OK = 635;
  SM_EAT_FAIL = 636;
  SM_BUTCH = 637; //Ұ��?
  SM_MAGICFIRE = 638; //������,��ǽ??
  SM_MAGICFIRE_FAIL = 639;
  SM_MAGIC_LVEXP = 640;
  SM_DURACHANGE = 642;
  SM_MERCHANTSAY = 643;
  SM_MERCHANTDLGCLOSE = 644;
  SM_SENDGOODSLIST = 645;
  SM_SENDUSERSELL = 646;
  SM_SENDBUYPRICE = 647;
  SM_USERSELLITEM_OK = 648;
  SM_USERSELLITEM_FAIL = 649;
  SM_BUYITEM_SUCCESS = 650; //?
  SM_BUYITEM_FAIL = 651; //?
  SM_SENDDETAILGOODSLIST = 652;
  SM_GOLDCHANGED = 653;
  SM_CHANGELIGHT = 654; //���ظı�
  SM_LAMPCHANGEDURA = 655;//����־øı�
  SM_CHANGENAMECOLOR = 656;//������ɫ�ı�,����,����,����,����
  SM_CHARSTATUSCHANGED = 657;
  SM_SENDNOTICE = 658; //���ͽ�����Ϸ�Ҹ�(����)
  SM_GROUPMODECHANGED = 659;//���ģʽ�ı�
  SM_CREATEGROUP_OK = 660;
  SM_CREATEGROUP_FAIL = 661;
  SM_GROUPADDMEM_OK = 662;
  SM_GROUPDELMEM_OK = 663;
  SM_GROUPADDMEM_FAIL = 664;
  SM_GROUPDELMEM_FAIL = 665;
  SM_GROUPCANCEL = 666;
  SM_GROUPMEMBERS = 667;
  SM_SENDUSERREPAIR = 668;
  SM_USERREPAIRITEM_OK = 669;
  SM_USERREPAIRITEM_FAIL = 670;
  SM_SENDREPAIRCOST = 671;
  SM_DEALMENU = 673;
  SM_DEALTRY_FAIL = 674;
  SM_DEALADDITEM_OK = 675;
  SM_DEALADDITEM_FAIL = 676;
  SM_DEALDELITEM_OK = 677;
  SM_DEALDELITEM_FAIL = 678;
  SM_DEALCANCEL = 681;
  SM_DEALREMOTEADDITEM = 682;
  SM_DEALREMOTEDELITEM = 683;
  SM_DEALCHGGOLD_OK = 684;
  SM_DEALCHGGOLD_FAIL = 685;
  SM_DEALREMOTECHGGOLD = 686;
  SM_DEALSUCCESS = 687;
  SM_SENDUSERSTORAGEITEM = 700;//���ƶ��ֿ�
  SM_STORAGE_OK = 701;
  SM_STORAGE_FULL = 702;
  SM_STORAGE_FAIL = 703;
  SM_SAVEITEMLIST = 704;
  SM_TAKEBACKSTORAGEITEM_OK = 705;
  SM_TAKEBACKSTORAGEITEM_FAIL = 706;
  SM_TAKEBACKSTORAGEITEM_FULLBAG = 707;

  SM_AREASTATE = 708; //��Χ״̬
  SM_MYSTATUS = 766;//�ҵ�״̬,���һ������״̬,���Ƿ񱻶�,���˾�ǿ�ƻس�

  SM_DELITEMS = 709;
  SM_READMINIMAP_OK = 710;
  SM_READMINIMAP_FAIL = 711;
  SM_SENDUSERMAKEDRUGITEMLIST = 712;
  SM_MAKEDRUG_SUCCESS = 713;
  SM_UPSENDMSGCOUNT = 714;//ͬ���ͻ�����M2�ķ���Ϣ����
  //  716
  SM_MAKEDRUG_FAIL = 65036;

  SM_CHANGEGUILDNAME = 750;
  SM_SENDUSERSTATE = 751; //
  SM_SUBABILITY = 752; //���������ԶԻ���
  SM_OPENGUILDDLG = 753; //
  SM_OPENGUILDDLG_FAIL = 754; //
  SM_SENDGUILDMEMBERLIST = 756; //
  SM_GUILDADDMEMBER_OK = 757; //
  SM_GUILDADDMEMBER_FAIL = 758;
  SM_GUILDDELMEMBER_OK = 759;
  SM_GUILDDELMEMBER_FAIL = 760;
  SM_GUILDRANKUPDATE_FAIL = 761;
  SM_BUILDGUILD_OK = 762;
  SM_BUILDGUILD_FAIL = 763;
  SM_DONATE_OK = 764;
  SM_DONATE_FAIL = 765;

  SM_MENU_OK = 767; //?
  SM_GUILDMAKEALLY_OK = 768;
  SM_GUILDMAKEALLY_FAIL = 769;
  SM_GUILDBREAKALLY_OK = 770; //?
  SM_GUILDBREAKALLY_FAIL = 771; //?
  SM_DLGMSG = 772; //Jacky
  SM_SPACEMOVE_HIDE = 800;//��ʿ��һ������
  SM_SPACEMOVE_SHOW = 801;//��ʿ��һ���������Ϊ����
  SM_RECONNECT = 802; //�����������
  SM_GHOST = 803; //ʬ�����,��ħ��������Ч��?
  SM_SHOWEVENT = 804;//��ʾ�¼�
  SM_HIDEEVENT = 805;//�����¼�
  SM_SPACEMOVE_HIDE2 = 806;
  SM_SPACEMOVE_SHOW2 = 807;
  SM_TIMECHECK_MSG = 810; //ʱ�Ӽ��,����ͻ�������
  SM_ADJUST_BONUS = 811; //���͸�������ֵ

  SM_ITEMUPDATE = 1500;
  SM_MONSTERSAY = 1501;

  SM_EXCHGTAKEON_OK = 65023;
  SM_EXCHGTAKEON_FAIL = 65024;

  SM_TEST = 65037;//
  SM_TESTHERO = 65038;//������Ϣ
  SM_THROW = 65069;
  RM_SendItemEffs = 8000;//
  RM_DELITEMS = 9000; //Jacky
  RM_TURN = 10001;
  RM_WALK = 10002;
  RM_RUN = 10003;
  RM_HIT = 10004;
  RM_HEAVYHIT = 10005;
  RM_BIGHIT = 10006;  
  RM_SPELL = 10007;
  RM_SPELL2 = 10008;
  RM_LONGHIT4 = 10009;//�ļ���ɱ
  RM_MOVEFAIL = 10010;
  RM_LONGHIT = 10011;//��ɱ
  RM_WIDEHIT = 10012;//����
  RM_PUSH = 10013;//����ײ�����
  RM_FIREHIT = 10014;//�һ�
  RM_RUSH = 10015;//��ײ��ǰ��
  RM_4FIREHIT = 10016;//4���һ� 20080112
  RM_WIDEHIT4 = 10017;//Բ���䵶
  RM_STRUCK = 10020;//��������
  RM_DEATH = 10021;
  RM_DISAPPEAR = 10022;
  RM_MAGSTRUCK = 10025;
  RM_MAGHEALING = 10026;
  RM_STRUCK_MAG = 10027;//��ħ�����
  RM_MAGSTRUCK_MINE = 10028;
  RM_INSTANCEHEALGUAGE = 10029; //jacky
  RM_HEAR = 10030;//����
  RM_WHISPER = 10031;
  RM_CRY = 10032;
  RM_RIDE = 10033;
  RM_STRUCK1 = 10034;//�������ܹ���ʱ�Ķ���Ч�� 20090518
  RM_WINEXP = 10044;
  RM_USERNAME = 10043;
  RM_LEVELUP = 10045;
  RM_CHANGENAMECOLOR = 10046;

  RM_LOGON = 10050;
  RM_ABILITY = 10051;
  RM_HEALTHSPELLCHANGED = 10052;
  RM_DAYCHANGING = 10053;
  RM_HEROHEALTHSPELLCHANGED = 10054;
  SM_HEROHEALTHSPELLCHANGED = 10055;

  RM_HEALTHSPELLCHANGED1 = 10056;
  SM_HEALTHSPELLCHANGED1 = 10057;
  RM_HEROHEALTHSPELLCHANGED1 = 10058;
  SM_HEROHEALTHSPELLCHANGED1 = 10059;

  RM_MOVEMESSAGE1 = 10097;//�����Ƶ���ʱ
  SM_MOVEMESSAGE1 = 10098;//�����Ƶ���ʱ
  RM_MOVEMESSAGE = 10099;//��������    2007.11.13
  RM_SYSMESSAGE = 10100;
  RM_GROUPMESSAGE = 10102;
  RM_SYSMESSAGE2 = 10103;
  RM_GUILDMESSAGE = 10104;
  RM_SYSMESSAGE3 = 10105; //Jacky
  RM_ITEMSHOW = 10110;
  RM_ITEMHIDE = 10111;
  RM_DOOROPEN = 10112;
  RM_DOORCLOSE = 10113;
  RM_SENDUSEITEMS = 10114;//����ʹ�õ���Ʒ
  RM_WEIGHTCHANGED = 10115;

  RM_FEATURECHANGED = 10116;
  RM_CLEAROBJECTS = 10117;
  RM_CHANGEMAP = 10118;
  RM_BUTCH = 10119;//��
  RM_MAGICFIRE = 10120;
  RM_SENDMYMAGIC = 10122;//����ʹ�õ�ħ��
  RM_MAGIC_LVEXP = 10123;
  RM_SKELETON = 10024;//��ʾʬ��
  RM_DURACHANGE = 10125;//�־øı�
  RM_MERCHANTSAY = 10126;
  RM_GOLDCHANGED = 10136;
  RM_CHANGELIGHT = 10137;
  RM_CHARSTATUSCHANGED = 10139;
  RM_DELAYMAGIC = 10154;
  RM_DELAYMAGIC1 = 10216;//��ʱȺ��ħ����Ϣ

  RM_DIGUP = 10200;
  RM_DIGDOWN = 10201;
  RM_FLYAXE = 10202;
  RM_LIGHTING = 10204;
  RM_SUBABILITY = 10302;
  RM_TRANSPARENT = 10308;

  RM_SPACEMOVE_SHOW = 10331;
  RM_RECONNECTION = 11332;
  RM_SPACEMOVE_SHOW2 = 10332; //?
  RM_HIDEEVENT = 10333;//�����̻�
  RM_SHOWEVENT = 10334;//��ʾ�̻�
  RM_SPACEMOVE_SHOW3 = 10335;//�ƶ�(��Ч������)
  SM_SPACEMOVE_SHOW3 = 10336;//�ƶ�(��Ч������)
  RM_ZEN_BEE = 10337;

  RM_OPENHEALTH = 10410;
  RM_CLOSEHEALTH = 10411;
  RM_DOOPENHEALTH = 10412;
  RM_CHANGEFACE = 10415;

  RM_ITEMUPDATE = 11000;
  RM_MONSTERSAY = 11001;
  RM_MAKESLAVE = 11002;

  RM_MONMOVE = 21004;
  {SS_200 = 200;//20101022 ע��
  SS_201 = 201;
  SS_202 = 202;
  SS_WHISPER = 203;
  SS_204 = 204;
  SS_205 = 205;
  SS_206 = 206;
  SS_207 = 207;
  SS_208 = 208;
  SS_209 = 219;
  SS_210 = 210;
  SS_211 = 211;
  SS_212 = 212;
  SS_213 = 213;
  SS_214 = 214; }

  RM_10205 = 10205;
  RM_10101 = 10101;
  RM_ALIVE = 10153;//����
  RM_CHANGEGUILDNAME = 10301;
  RM_10414 = 10414;
  RM_POISON = 10300;
  LA_UNDEAD = 1; //����ϵ

  RM_DELAYPUSHED = 10555;

  CM_QUERYUSERNAME = 80; //������Ϸ,���������ؽ�ɫ�����ͻ���
  CM_QUERYBAGITEMS = 81;  //��ѯ������Ʒ
  CM_QUERYUSERSTATE = 82;//�鿴������ɫ��װ��

  CM_DROPITEM = 1000;//�Ӱ������ӳ���Ʒ����ͼ,��ʱ��������ڰ�ȫ�����ܻ���ʾ��ȫ���������Ӷ���
  CM_PICKUP = 1001;//����
  CM_OPENDOOR = 1002;  //����,�����ߵ���ͼ��ĳ�����ŵ�ʱ
  CM_TAKEONITEM = 1003;//װ��װ�������ϵ�װ��λ��
  CM_TAKEOFFITEM = 1004; //������ĳ��װ��λ��ȡ��ĳ��װ��
  CM_EAT = 1005; //ʹ����Ʒ,��ҩ
  CM_BUTCH = 1007;//��
  CM_MAGICKEYCHANGE = 1008;//ħ����ݼ��ı�
  CM_SOFTCLOSE = 1009;//�˳�����(��Ϸ����,����Ϸ��С��)
//���̵�NPC�������
  CM_CLICKNPC = 1010; //�û������ĳ��NPC���н���
  CM_MERCHANTDLGSELECT = 1011; //��Ʒѡ��,����,�����������Ϣ�󷵻�
  CM_PLAYDICELabel = 2011;//�޸�������ɫ��
  CM_MERCHANTQUERYSELLPRICE = 1012;//��Ʒ�ŵ����ۿ��У����ؼ۸�,��׼�۸�,����֪���̵��û��������Щ�������־û�������
  CM_USERSELLITEM = 1013; //�û�������(�����OK����)
  CM_USERBUYITEM = 1014; //�û����붫��
  CM_USERGETDETAILITEM = 1015;//ȡ����Ʒ�嵥,������"���۽�ָ"����,�����һ�����۽�ָ����ѡ��
  CM_DROPGOLD = 1016; //�û����½�Ǯ������
  //CM_1017 = 1017;//20090901 δʹ��
  CM_LOGINNOTICEOK = 1018; //������Ϸ�Ҹ����ȷʵ,������Ϸ
  CM_GROUPMODE = 1019;   //���黹�ǿ���
  CM_CREATEGROUP = 1020; //�½����
  CM_ADDGROUPMEMBER = 1021;//��������
  CM_DELGROUPMEMBER = 1022; //����ɾ��
  CM_USERREPAIRITEM = 1023; //�û�������
  CM_MERCHANTQUERYREPAIRCOST = 1024; //�ͻ�����NPCȡ���������
  CM_DEALTRY = 1025;  //��ʼ����,���׿�ʼ
  CM_DEALADDITEM = 1026; //�Ӷ�����������Ʒ����
  CM_DEALDELITEM = 1027;//�ӽ�����Ʒ���ϳ��ض���???��������Ŷ
  CM_DEALCANCEL = 1028;  //ȡ������
  CM_DEALCHGGOLD = 1029; //�����������Ͻ�ǮΪ0,,���н�Ǯ����,����˫�������������Ϣ
  CM_DEALEND = 1030; //���׳ɹ�,��ɽ���
  CM_USERSTORAGEITEM = 1031; //�û��Ĵ涫��
  CM_USERTAKEBACKSTORAGEITEM = 1032;//�û��򱣹�Աȡ�ض���
  CM_WANTMINIMAP = 1033;  //�û������"С��ͼ"��ť
  CM_USERMAKEDRUGITEM = 1034; //�û����춾ҩ(������Ʒ)
  CM_OPENGUILDDLG = 1035; //�û������"�л�"��ť
  CM_GUILDHOME = 1036; //���"�л���ҳ"
  CM_GUILDMEMBERLIST = 1037; //���"��Ա�б�"
  CM_GUILDADDMEMBER = 1038; //���ӳ�Ա
  CM_GUILDDELMEMBER = 1039;//���˳��л�
  CM_GUILDUPDATENOTICE = 1040; //�޸��лṫ��
  CM_GUILDUPDATERANKINFO = 1041; //����������Ϣ(ȡ����������)
  //CM_1042 = 1042;//20090901 δʹ��
  CM_ADJUST_BONUS = 1043;  //�û��õ�����??˽���бȽ�����,С������ʱ��ó���Ǯ������,���Ǻ�ȷ��
  CM_GUILDALLY = 1044;//�л�����
  CM_GUILDBREAKALLY = 1045;//ȡ���л�����
  CM_HEROMAGICKEYCHANGE = 1046;//Ӣ��ħ���������� 20080606
//�����̵����
  SM_ISSHOP = 1047;
  SM_PLAYSHOPLIST = 1048;//���˲鿴�����̵���Ʒ
  SM_PLAYSHOP_OK = 1049;//��������̵���Ʒ�ɹ�
  SM_PLAYSHOP_FALL = 1050;//��������̵���Ʒʧ��
  SM_DELSHOPITEM = 1051;//ɾ�������̵���Ʒ
  RM_ISSHOP = 1052;
  CM_SELFSHOPITEMS = 1053;//���������̵�
  CM_SELFCLOSESHOP = 1054;//��̯
  CM_CLICKSHOP = 1055;//���˲鿴�����̵���Ʒ
  CM_SELFSHOPBUY = 1056;//�����̯��Ʒ
  RM_SELFSHOPLIST = 1057;//�����¼���͸����̵��б�����
  SM_SELLSHOPLIST = 1058;//�����¼���͸����̵��б�����
  SM_SELLSHOPTITLE = 1059;
{$IF M2Version <> 2}
  CM_MERCHANTQUERYARMSEXCHANGEPRICE = 1060;//��װ���ŵ����׿�ȡװ�����õľ�����Ƭ�� 20100812
  RM_SENDARMSEXCHANGEPRICE = 1061;//����װ�����õľ�����Ƭ��
  SM_SENDARMSEXCHANGEPRICE = 1062;//����װ�����õľ�����Ƭ��
  CM_USERARMSEXCHANGE = 1063;//�ͻ��˶һ�������Ƭ
  RM_USERARMSEXCHANGE_FAIL = 1064;//�ͻ��˶һ�������Ƭ ʧ��
  SM_USERARMSEXCHANGE_FAIL = 1065;//�ͻ��˶һ�������Ƭ ʧ��
  RM_USERARMSEXCHANGE_OK = 1066;//�ͻ��˶һ�������Ƭ �ɹ�
  SM_USERARMSEXCHANGE_OK = 1067;//�ͻ��˶һ�������Ƭ �ɹ�
  CM_USERKAMPO = 1068;//�ͻ��˼�����Ʒ
  RM_USERKAMPO_FAIL = 1069;//�ͻ��˼�����Ʒ ʧ��
  SM_USERKAMPO_FAIL = 1070;//�ͻ��˼�����Ʒ ʧ��
  RM_USERKAMPO_OK = 1071;//�ͻ��˼�����Ʒ �ɹ�
  SM_USERKAMPO_OK = 1072;//�ͻ��˼�����Ʒ �ɹ�
  //�¼���
  CM_NewUSERKAMPO = 1168;//�ͻ��˼�����Ʒ
  RM_NewUSERKAMPO_FAIL = 1169;//�ͻ��˼�����Ʒ ʧ��
  SM_NewUSERKAMPO_FAIL = 1170;//�ͻ��˼�����Ʒ ʧ��
  RM_NewUSERKAMPO_OK = 1171;//�ͻ��˼�����Ʒ �ɹ�
  SM_NewUSERKAMPO_OK = 1172;//�ͻ��˼�����Ʒ �ɹ�



  CM_USERCHANGEKAMPO = 1073;//�ͻ��˸�����Ʒ
  RM_USERCHANGEKAMPO_FAIL = 1074;//�ͻ��˸�����Ʒ ʧ��
  SM_USERCHANGEKAMPO_FAIL = 1075;//�ͻ��˸�����Ʒ ʧ��
  RM_USERCHANGEKAMPO_OK = 1076;//�ͻ��˸�����Ʒ �ɹ�
  SM_USERCHANGEKAMPO_OK = 1077;//�ͻ��˸�����Ʒ �ɹ�
  SM_UPDATEKAMPOITME = 1078;//���¼�����Ʒ����Ʒ����
  CM_OPENQUERYPROFICIENCY = 1079;//��ѯ���ؽ����������
  SM_OPENQUERYPROFICIENCY = 1080;//��ѯ���ؽ����������
  CM_OPENSCROLLFRM = 1081;//�򿪾��ᴰ�ڣ�ȡ����ֵ������ֵ
  SM_OPENSCROLLFRM = 1082;//�򿪾��ᴰ�ڣ�ȡ����ֵ������ֵ
  CM_USERMAKESCROLL = 1083;//�ͻ���ʹ����Ƥ���������ؾ���
  RM_USERMAKESCROLL_OK = 1084;
  SM_USERMAKESCROLL_OK = 1085;
  RM_USERMAKESCROLL_FAIL = 1086;
  SM_USERMAKESCROLL_FAIL = 1087;
  CM_USERSCROLLCHANGEITME = 1088;//�ͻ���ʹ�����ؾ�������������
  RM_USERSCROLLCHANGEITME_OK = 1089;
  SM_USERSCROLLCHANGEITME_OK = 1090;
  RM_USERSCROLLCHANGEITME_FAIL = 1091;
  SM_USERSCROLLCHANGEITME_FAIL = 1092;
  RM_SENDUSESPIRITITEMS = 1093;//������ýװ��λ��Ʒ����
  SM_SENDUSESPIRITITEMS = 1094;
  CM_TAKEONSPIRITITEM = 1095;//����ý�ŵ���ýλ��
  SM_TAKEONSPIRITITEM_OK = 1096;
  SM_TAKEONSPIRITITEM_FAIL = 1097;
  CM_TAKEOFFSPIRITITEM = 1098;//����ýλ������Ʒ
  SM_TAKEOFFSPIRITITEM_OK = 1099;
  SM_TAKEOFFSPIRITITEM_FAIL = 1107;
  RM_OPENDJUDGE = 1108;//��Ʒ������
  SM_OPENDJUDGE = 1109;
  CM_USERJUDGE = 1110;//�ͻ���Ʒ��
  SM_USERJUDGE_OK = 1111;//Ʒ���ɹ�
  SM_USERJUDGE_FAIL = 1112;//Ʒ��ʧ��
  CM_USERFINDJEWEL = 1113;//ʹ����ý��������
  SM_USERFINDJEWEL_OK = 1114;//ʹ����ý��������ɹ�
  SM_USERFINDJEWEL_FAIL = 1115;//ʹ����ý��������ʧ��
  CM_USERDIGJEWELITME = 1116;//�ͻ����ڱ�
{$IFEND}
  SM_OPENHEALTH = 1100;
  SM_CLOSEHEALTH = 1101;
  SM_BREAKWEAPON = 1102; //��������
  SM_INSTANCEHEALGUAGE = 1103; //ʵʱ����
  SM_CHANGEFACE = 1104; //����,���͸ı�?
  CM_PASSWORD = 1105;
  //SM_VERSION_FAIL = 1106; //�ͻ��˰汾��֤ʧ��

  CM_THROW = 3005;//�׷�(�ͻ���ʹ��)

//��������1
  CM_HORSERUN = 3009;//����
  CM_TURN = 3010; //ת��(����ı�)
  CM_WALK = 3011; //��
  CM_SITDOWN = 3012;//��(����)
  CM_RUN = 3013; //��
  CM_HIT = 3014;   //��ͨ���������
  CM_HEAVYHIT = 3015;//��������Ķ���
  CM_BIGHIT = 3016;
  CM_SPELL = 3017; //ʩħ��
  CM_POWERHIT = 3018; //��ɱ
  CM_LONGHIT = 3019;  //��ɱ
  CM_LONGHIT4 = 3020;//�ļ���ɱ
  CM_WIDEHIT4 = 3021;//Բ���䵶(�ļ�����)
  CM_WIDEHIT = 3024; //����
  CM_FIREHIT = 3025; //�һ𹥻�
  CM_SAY = 3030;    //��ɫ����
  CM_4FIREHIT = 3031; //4���һ𹥻�
  CM_CRSHIT = 3036; //���µ�
  CM_TWNHIT = 3037; //����ն�ػ�
  CM_QTWINHIT = 3041; //����ն���
  CM_CIDHIT = 3040; //��Ӱ����
  CM_TWINHIT = CM_TWNHIT;
  CM_PHHIT = 3038; //�ƻ�ն
  CM_DAILY = 3042; //���ս��� 20080511
  CM_BATTERHIT1 = 3043;//׷�Ĵ� 20090625
  CM_BATTERHIT2 = 3044;//����ɱ 20090703
  CM_BATTERHIT3 = 3045;//��ɨǧ�� 20090703
  CM_BATTERHIT4 = 3046;//����ն
  CM_BLOODSOUL = 3048;//Ѫ��һ��(ս)
  CM_3037 = 3039;//2007.10.15����ֵ  ��ǰ��  3037(�ͻ���ʹ��)
  CM_HIT_107 = 3049;//�ݺὣ��
  RM_HIT_107 = 3050;//�ݺὣ��
  SM_HIT_107 = 3051;//�ݺὣ��
  RM_41 = 41;
  //RM_42 = 42;
  //RM_43 = 43;
  RM_44 = 56;

  RM_DONATE_FAIL = 10306;
  RM_MENU_OK = 10309; //�˵�

  RM_MAGICFIREFAIL = 10121;
  RM_MERCHANTDLGCLOSE = 10127;
  RM_SENDGOODSLIST = 10128;//������Ʒ����
  RM_SENDUSERSELL = 10129;//�����û�����
  RM_SENDBUYPRICE = 10130;//���͹���۸�
  RM_USERSELLITEM_OK = 10131;//�û����۳ɹ�
  RM_USERSELLITEM_FAIL = 10132;//�û�����ʧ��
  RM_BUYITEM_SUCCESS = 10133;//������Ŀ�ɹ�
  RM_BUYITEM_FAIL = 10134;//������Ŀʧ��
  RM_SENDDETAILGOODSLIST = 10135; //������ϸ����Ʒ����
  RM_LAMPCHANGEDURA = 10138;
  RM_SENDUSERREPAIR = 11139;//�����û�����
  RM_GROUPCANCEL = 10140;
  RM_SENDUSERSREPAIR = 10141;//�����û�����
  RM_SENDREPAIRCOST = 10142;//��������ɱ�
  RM_USERREPAIRITEM_OK = 10143;//�û�������Ŀ�ɹ�
  RM_USERREPAIRITEM_FAIL = 10144;//�û�������Ŀʧ��
  //10145
  RM_USERSTORAGEITEM = 10146;//�û��ֿ���Ŀ
  RM_USERGETBACKITEM = 10147;//�û���ûصĲֿ���Ŀ
  RM_SENDDELITEMLIST = 10148;//����ɾ����Ŀ������
  RM_USERMAKEDRUGITEMLIST = 10149;//�û���ҩƷ��Ŀ������
  RM_MAKEDRUG_SUCCESS = 10150;//��ҩ�ɹ�
  RM_MAKEDRUG_FAIL = 10151;//��ҩʧ��

  RM_SENDUSERARMSTEAR = 10152;//������ж����ʯ 20100708
  RM_10155 = 10155;
  SM_SENDUSERARMSTEAR = 10156;//������ж����ʯ 20100708
  CM_USERARMSTEARITEM = 10157; //�ͻ��˷�����Ҫ��ֵ���Ʒ��Ϣ 20100708
  RM_USERARMSTEAR_OK = 10158;//�����Ʒ�ɹ� 20100708
  SM_USERARMSTEAR_OK = 10159;
  RM_USERARMSTEAR_FAIL = 10160;//�����Ʒʧ�� 20100708
  SM_USERARMSTEAR_FAIL = 10161;
  RM_ARMSCRIT = 10162;//����ƮѪЧ�� 20100710
  SM_ARMSCRIT = 10163;//����ƮѪЧ�� 20100710

  RM_SENDUSERARMSEXCHANGE = 10164;//�����һ�������Ƭ 20100809
  SM_SENDUSERARMSEXCHANGE = 10165;//�����һ�������Ƭ 20100809

  CM_AUTOGAMEGIRDUPSKILL99 = 10166; //�Զ���������ǿ����������1��ʹ��1800���������180�Σ�ÿ��10��
                                                            {2��ʹ��3600���������360�Σ�ÿ��10��
                                                             3��ʹ��5400���������180�Σ�ÿ��30��
                                                             4��ʹ��10800���������360�Σ�ÿ��30��}
  CM_CLOSEGAMEGIRDUPSKILL99 = 10167; //ȡ���Զ�����
  CM_QUERYGAMEGIRDUPSKILL99 = 10168; //��ѯʣ����������

  CM_SKILLTOJINGQING = 10169;//�����澭
  RM_SKILLTOJINGQING_FAIL = 10170;//�����澭ʧ��
  SM_SKILLTOJINGQING_FAIL = 10171;
  RM_SKILLTOJINGQING_OK = 10172;//�����澭�ɹ�
  SM_SKILLTOJINGQING_OK = 10173;

  CM_AUTOGAMEGIRDUPSKILL95 = 10174;//�Զ�������ת���� ����1��1800�����60�� 2=3600�����120�� ����2=0�������� 1=Ӣ������
  CM_CLOSEGAMEGIRDUPSKILL95 = 10175; //ȡ���Զ�����
  CM_QUERYGAMEGIRDUPSKILL95 = 10176; //��ѯʣ����������
  RM_OPENLIANQI = 10177; //����������
  SM_OPENLIANQI = 10178; //����������
  CM_LIANQIPRACTICE = 10179;//��������,�������
  RM_LIANQIPRACTICE = 10180;
  SM_LIANQIPRACTICE = 10181;
  RM_SENDJINGYUANVALUE = 10182;//���¾�Ԫֵ����
  SM_SENDJINGYUANVALUE = 10183;
  CM_CLENTGETLIANQIPRACTICE = 10184;//��ȡ������Ʒ

  SM_POWERHITEX1 = 9984;//ǿ����ɱ����1
  SM_POWERHITEX2 = 9985;//ǿ����ɱ����2
  SM_POWERHITEX3 = 9986;//ǿ����ɱ����3
  SM_WIDEHIT4EX1 = 9987;//ǿ��Բ���䵶1
  SM_WIDEHIT4EX2 = 9989;//ǿ��Բ���䵶2
  SM_WIDEHIT4EX3 = 9990;//ǿ��Բ���䵶3
  SM_LONGHITEX1 = 9991;//ǿ����ɱ1(�ͻ���ʹ��)
  SM_LONGHITEX2 = 9992;//ǿ����ɱ2(�ͻ���ʹ��)
  SM_LONGHITEX3 = 9993;//ǿ����ɱ3(�ͻ���ʹ��)
  SM_FIREHITEX1 = 9994;//ǿ���һ�1(�ͻ���ʹ��)
  SM_FIREHITEX2 = 9995;//ǿ���һ�2(�ͻ���ʹ��)
  SM_FIREHITEX3 = 9996;//ǿ���һ�3(�ͻ���ʹ��)
  SM_DAILYEX1 = 9997;//ǿ������1(�ͻ���ʹ��)
  SM_DAILYEX2 = 9998;//ǿ������2(�ͻ���ʹ��)
  SM_DAILYEX3 = 9999;//ǿ������3(�ͻ���ʹ��)
  RM_MAGIC_UPLVEXPEXP = 10049;//ǿ����������
  {$IF M2Version <> 2}
  SM_SENDHUMTITLES = 10185;//���ͳƺ�����
  CM_SETUSERTITLES = 10186;//�ͻ������óƺ�
  RM_SETUSERTITLES = 10187;//���óƺųɹ�
  SM_SETUSERTITLES = 10188;
  RM_SENDHUMTITLES = 10189;//���ͳƺ�����
  CM_SETSHOWFENGHAO = 10190;//�ڹ��������سƺ�
  CM_LONGHITFORFENGHAO = 10191;//��ɱ�ۺ�Ч��
  SM_LONGHITFORFENGHAO = 10192;//��ɱ�ۺ�Ч��(�ͻ���ʹ��)
  CM_FIREHITFORFENGHAO = 10193;//�һ�ۺ�Ч��
  SM_FIREHITFORFENGHAO = 10194;//�һ�ۺ�Ч��(�ͻ���ʹ��)
  CM_DAILYFORFENGHAO = 10195;//���շۺ�Ч��
  SM_DAILYFORFENGHAO = 10196;//���շۺ�Ч��(�ͻ���ʹ��)
  SM_SENDFENGHAOLIST = 10197;//���ͻ���ʹ�߻������б�
  CM_CALLFENGHAO = 10198;//�ٻ����ͳƺ���Ա(����֮�ǲ�������)
  CM_RECYCFENGHAO = 10199;//���ճƺ�
  CM_AGREECALLFENGHAO = 10203;//ͬ���ٻ�����(����ʹ�߻�����)
  CM_CANCELCALLFENGHAO = 10206;//ȡ���ٻ�����
  SM_SENDDOMINATLIST = 10207;//���������ͼ��ͼ���б�
  CM_WORLDFLY = 10208;//��������ͼ����(������)
  RM_WORLDFLY = 10209;
  SM_WORLDFLY = 10210;
  CM_CLOSEDOMINATETOKEN = 10211;//�ر�������
  CM_FENGHAOAGREE = 10212;//�����ƺ�ȷ�� 20110313


  SM_MAGIC_UPLVEXPEXP = 10060;
  RM_SENDHEARTINFO = 10061;
  RM_SHOWHEARTEFF = 10062;//��ʾ����״̬Ч��
  SM_SENDHEARTINFO = 10063;//�����ķ�ҳ�������
  CM_CHANGESAVVYHEARTSKILL = 10064;//�ı������ķ�����
  SM_UPDIVISIONPONT = 10065;//������������ֵ
  CM_DIVISIONGETFENGHAO = 10066;//�����ϴ���"�ƺ���ȡ"
  CM_SAVVYHEARTSKILL = 10067;//���������ķ�
  CM_INCHEATRPOINT = 10068;//���Exp������ִ��QF�ű���(999�ķ����չ���)
  CM_DIVISIONAPPLYLIST = 10069;//ȡ���������б�
  SM_SENDDIVISIONAPPLYLIST = 10070;//�������������б�
  CM_DIVISIONMEMBERLIST = 10071;//ȡ���ɳ�Ա����
  SM_SENDDIVISIONMEMBERLIST = 10072;//�������ɳ�Ա����
  CM_DIVISIONHOME = 10073;//��������ҳ
  CM_OPENDIVISIONDLG = 10074;//�����ɶԻ���
  SM_OPENDIVISIONDLG = 10075;//�����ɶԻ���ɹ�
  SM_OPENDIVISIONDLG_FAIL = 10076;//�����ɶԻ���ʧ��
  CM_DIVISIONUPDATENOTICE = 10077;//�޸����ɹ���
  CM_DIVISIONDDELMEMBER = 10078;//ɾ�����ɳ�Ա
  SM_DIVISIONDDELMEMBER_OK = 10079;//�����ϴ�ɾ�����ӳɹ�
  SM_DIVISIONDDELMEMBER_OK1 = 10080;//�����˳����ɳɹ�
  SM_DIVISIONDELMEMBER_FAIL = 10081;//����ɾ�����ӳɹ�
  CM_AGREEAPPLYDIVISION = 10082;//�����ϴ�ͬ����������
  CM_CANCELAPPLYDIVISION = 10083;//�����ϴ�ȡ����������
  RM_OPENSAVVYHEART = 10084;//�������ķ�����
  SM_OPENSAVVYHEART = 10085;//�������ķ�����
  CM_APPLYDIVISION = 10086;//����(ȡ��)������
  CM_NAMEQUERYDIVISIONLIST = 10087;//���������ɴ��ڰ���ʦ����ѯ
  CM_QUERYDIVISIONLIST = 10088;//���������ɴ��ڷ�ҳ
  RM_QUERYDIVISIONLIST = 10089;//�����������ɴ���
  SM_QUERYDIVISIONLIST = 10090;
  RM_BUILDDIVISION_OK = 10091;//����ʦ�ųɹ�
  SM_BUILDDIVISION_OK = 10092;
  RM_BUILDDIVISION_FAIL = 10093;//����ʦ��ʧ��
  SM_BUILDDIVISION_FAIL = 10094;
  {$IFEND}
  RM_DIVISIONMESSAGE = 10095;//ʦ������
  SM_DIVISIONMESSAGE = 10096;
    
  CM_OPENUPSKILL95 = 10213;//��ͨ��ת99��
  RM_OPENUPSKILL95_FAIL = 10214;//��ͨ��ת99��ʧ��
  SM_OPENUPSKILL95_FAIL = 10215;//��ͨ��ת99��ʧ��
  RM_BUILDGUILD_OK = 10303;
  RM_BUILDGUILD_FAIL = 10304;
  RM_DONATE_OK = 10305;
  
  RM_SPACEMOVE_FIRE2 = 11330;//�ռ��ƶ�
  RM_SPACEMOVE_FIRE = 11331;//�ռ��ƶ�

  RM_ADJUST_BONUS = 10400;
  RM_10401 = 10401;
  RM_BREAKWEAPON = 10413;
  RM_PASSWORD = 10416;
  RM_PLAYDICE = 10500;//ת����
  RM_PASSWORDSTATUS = 10601;
  RM_GAMEGOLDCHANGED = 10666;
  RM_MYSTATUS = 10777;

  RM_HORSERUN = 11000;
  RM_CRSHIT = 11014;
  RM_RUSHKUNG = 11015;

  STATE_OPENHEATH = 1;
  POISON_68 = 68;
  //CM_QUERYUSERSET = 49999;//δʹ�� 20090226 ע��

  SM_40 = 35;
  SM_41 = 36;
  SM_42 = 37;
  SM_43 = 38;
  SM_44 = 39; //��Ӱ����

  SM_HORSERUN = 5;
  SM_716 = 716;

  SM_PASSWORD = 3030;
  SM_PLAYDICE = 1200;//ת����

  SM_GAMEGOLDNAME = 55; //��ͻ��˷�����Ϸ��,��Ϸ��,���ʯ,�������
  SM_GAMEGOLDNAME1 = 56;//��ͻ��˷��ͽ��ʯ,������� 20090524

  SM_PASSWORDSTATUS = 20001;
  SM_SERVERCONFIG = 20002;
  SM_GETREGINFO = 20003;

  ET_DIGOUTZOMBI = 1;
  ET_VORTEX = 2;//����
  ET_PILESTONES = 3;
  ET_HOLYCURTAIN = 4;//��ħ��Ч��
  ET_FIRE = 5;//��ǽ(��ͨ)
  ET_SCULPEICE = 6;//��������ƿǶ����󣬵��ϵĳ���
{6���̻�}
  ET_FIREFLOWER_1 = 7;//һ��һ��
  ET_FIREFLOWER_2 = 8;//������ӡ
  ET_FIREFLOWER_3 = 9;
  ET_FIREFLOWER_4 = 10;
  ET_FIREFLOWER_5 = 11;
  ET_FIREFLOWER_6 = 12;
  ET_FIREFLOWER_7 = 13;
  ET_FIREFLOWER_8 = 14;//û��ͼƬ
  ET_FOUNTAIN = 15;//��ȪЧ�� 20080624
  ET_DIEEVENT = 16; //����ׯ����������Ч�� 20080918
  ET_FIREDRAGON = 17;//�ػ���С��ȦЧ�� 20090123
  ET_SCULPEICE_1 = 18;//ѩ����ʿ�Ʊ������󣬵��ϵĳ���
  ET_FIRE_FENGHAO = 19;//�ۺ��ǽ(�ƺ�)
  ET_FIRE_1 = 20;//ǿ����ǽ1
  ET_FIRE_2 = 21;//ǿ����ǽ2
  ET_FIRE_3 = 22;//ǿ����ǽ3
  ET_NOTGOTO = 23;//���ܴ���(��������)
  //SM_NEEDPASSWORD = 8003;//δʹ�� 20100925 ע��
  //CM_POWERBLOCK = 0;//δʹ�� 20091022 ע��

  //�������
  CM_OPENSHOP = 9000; //������
  SM_SENGSHOPITEMS = 9001; // SERIES 7 ÿҳ������    wParam ��ҳ��
  CM_BUYSHOPITEM = 9002;
  SM_BUYSHOPITEM_SUCCESS = 9003;
  SM_BUYSHOPITEM_FAIL = 9004;
  SM_SENGSHOPSPECIALLYITEMS = 9005; //��������
  CM_BUYSHOPITEMGIVE = 9006; //����
  SM_BUYSHOPITEMGIVE_FAIL = 9007;
  SM_BUYSHOPITEMGIVE_SUCCESS = 9008;

  RM_OPENSHOPSpecially = 30000;
  RM_OPENSHOP = 30001;
  RM_BUYSHOPITEM_FAIL = 30003;//���̹�����Ʒʧ��
  RM_BUYSHOPITEMGIVE_FAIL = 30004;
  RM_BUYSHOPITEMGIVE_SUCCESS = 30005;
  //==============================================================================
  CM_QUERYUSERLEVELSORT = 3500; //�û��ȼ�����
  RM_QUERYUSERLEVELSORT = 35000;
  SM_QUERYUSERLEVELSORT = 2500;
  //==============================������Ʒ����ϵͳ(����)==========================
  RM_SENDSELLOFFGOODSLIST = 21008;//����
  SM_SENDSELLOFFGOODSLIST = 20008;//����
  RM_SENDUSERSELLOFFITEM = 21005; //������Ʒ
  SM_SENDUSERSELLOFFITEM = 20005; //������Ʒ
  RM_SENDSELLOFFITEMLIST = 22009; //��ѯ�õ��ļ�����Ʒ
  CM_SENDSELLOFFITEMLIST = 20009; //��ѯ�õ��ļ�����Ʒ
  RM_SENDBUYSELLOFFITEM_OK = 21010; //���������Ʒ�ɹ�
  SM_SENDBUYSELLOFFITEM_OK = 20010; //���������Ʒ�ɹ�
  RM_SENDBUYSELLOFFITEM_FAIL = 21011; //���������Ʒʧ��
  SM_SENDBUYSELLOFFITEM_FAIL = 20011; //���������Ʒʧ��
  RM_SENDBUYSELLOFFITEM = 41005; //����ѡ�������Ʒ
  CM_SENDBUYSELLOFFITEM = 4005; //����ѡ�������Ʒ
  RM_SENDQUERYSELLOFFITEM = 41006; //��ѯѡ�������Ʒ
  CM_SENDQUERYSELLOFFITEM = 4006; //��ѯѡ�������Ʒ
  RM_SENDSELLOFFITEM = 41004; //���ܼ�����Ʒ
  CM_SENDSELLOFFITEM = 4004; //���ܼ�����Ʒ
  RM_SENDUSERSELLOFFITEM_FAIL = 2007; //R = -3  ������Ʒʧ��
  RM_SENDUSERSELLOFFITEM_OK = 2006; //������Ʒ�ɹ�
  SM_SENDUSERSELLOFFITEM_FAIL = 20007; //R = -3  ������Ʒʧ��
  SM_SENDUSERSELLOFFITEM_OK = 20006; //������Ʒ�ɹ�
//==============================Ԫ������ϵͳ(20080316)==========================
  RM_SENDDEALOFFFORM = 23000;//�򿪳�����Ʒ����
  SM_SENDDEALOFFFORM = 23001;//�򿪳�����Ʒ����
  //���¼�������
  RM_OpenKampoDlgNew = 27000;//�򿪳�����Ʒ����
  SM_OpenKampoDlgNew = 27001;//�򿪳�����Ʒ����

  CM_SELLOFFADDITEM  = 23002;//�ͻ�����������Ʒ���������Ʒ
  SM_SELLOFFADDITEM_OK = 23003;//�ͻ�����������Ʒ���������Ʒ �ɹ�
  RM_SELLOFFADDITEM_OK = 23004;
  SM_SellOffADDITEM_FAIL=23005;//�ͻ�����������Ʒ���������Ʒ ʧ��
  RM_SellOffADDITEM_FAIL=23006;
  CM_SELLOFFDELITEM = 23007;//�ͻ���ɾ��������Ʒ�������Ʒ
  SM_SELLOFFDELITEM_OK = 23008;//�ͻ���ɾ��������Ʒ�������Ʒ �ɹ�
  RM_SELLOFFDELITEM_OK = 23009;
  SM_SELLOFFDELITEM_FAIL = 23010;//�ͻ���ɾ��������Ʒ�������Ʒ ʧ��
  RM_SELLOFFDELITEM_FAIL = 23011;
  CM_SELLOFFCANCEL = 23012;//�ͻ���ȡ��Ԫ������
  RM_SELLOFFCANCEL = 23013; // Ԫ������ȡ������
  SM_SellOffCANCEL = 23014;//Ԫ������ȡ������
  CM_SELLOFFEND    = 23015; //�ͻ���Ԫ�����۽���
  SM_SELLOFFEND_OK = 23016; //�ͻ���Ԫ�����۽��� �ɹ�
  RM_SELLOFFEND_OK = 23017;
  SM_SELLOFFEND_FAIL= 23018; //�ͻ���Ԫ�����۽��� ʧ��
  RM_SELLOFFEND_FAIL= 23019;
  RM_QUERYYBSELL = 23020;//��ѯ���ڳ��۵���Ʒ
  SM_QUERYYBSELL = 23021;//��ѯ���ڳ��۵���Ʒ
  RM_QUERYYBDEAL = 23022;//��ѯ���ԵĹ�����Ʒ
  SM_QUERYYBDEAL = 23023;//��ѯ���ԵĹ�����Ʒ
  CM_CANCELSELLOFFITEMING = 23024; //ȡ�����ڼ��۵���Ʒ 20080318(������)
  CM_SELLOFFBUYCANCEL = 23025; //ȡ������ ��Ʒ���� 20080318(������)
  CM_SELLOFFBUY = 23026; //ȷ�����������Ʒ 20080318
  SM_SELLOFFBUY_OK =23027;//����ɹ�
  RM_SELLOFFBUY_OK =23028;
//===========================Ӣ��=============================================
  CM_RECALLHERO = 5000; //�ٻ�Ӣ��
  SM_RECALLHERO = 5001;
  CM_HEROLOGOUT = 5002; //Ӣ���˳�
  SM_HEROLOGOUT = 5003;
  SM_CREATEHERO = 5004; //����Ӣ��

  SM_HERODEATH = 5005;  //��������
  CM_HEROCHGSTATUS = 5006; //�ı�Ӣ��״̬
  CM_HEROATTACKTARGET = 5007; //Ӣ������Ŀ��
  CM_HEROPROTECT = 5008; //�ػ�Ŀ��
  CM_HEROTAKEONITEM = 5009;  //����Ʒ��
  CM_HEROTAKEOFFITEM = 5010; //�ر���Ʒ��
  //CM_TAKEOFFITEMHEROBAG = 5011; //װ�����µ�Ӣ�۰��� 20110920 ע��
  //CM_TAKEOFFITEMTOMASTERBAG = 5012; //װ�����µ����˰���  20110920 ע��
  CM_SENDITEMTOMASTERBAG = 5013; //Ӣ�۰��������˰���
  CM_SENDITEMTOHEROBAG = 5014; //���˰�����Ӣ�۰���
  SM_HEROTAKEON_OK = 5015;
  SM_HEROTAKEON_FAIL = 5016;
  SM_HEROTAKEOFF_OK = 5017;
  SM_HEROTAKEOFF_FAIL = 5018;
  //SM_TAKEOFFTOHEROBAG_OK = 5019;  20110920 ע��
  //SM_TAKEOFFTOHEROBAG_FAIL = 5020; 20110920 ע��
  //SM_TAKEOFFTOMASTERBAG_OK = 5021; 20110920 ע��
  //SM_TAKEOFFTOMASTERBAG_FAIL = 5022;20110920 ע��
  CM_HEROTAKEONITEMFORMMASTERBAG = 5023; //�����˰�����װ����Ӣ�۰���
  CM_TAKEONITEMFORMHEROBAG = 5024; //��Ӣ�۰�����װ�������˰���
  SM_SENDITEMTOMASTERBAG_OK = 5025; //���˰�����Ӣ�۰����ɹ�
  SM_SENDITEMTOMASTERBAG_FAIL = 5026; //���˰�����Ӣ�۰���ʧ��
  SM_SENDITEMTOHEROBAG_OK = 5027; //Ӣ�۰��������˰���
  SM_SENDITEMTOHEROBAG_FAIL = 5028; //Ӣ�۰��������˰���
  CM_QUERYHEROBAGCOUNT = 5029; //�鿴Ӣ�۰�������
  SM_QUERYHEROBAGCOUNT = 5030; //�鿴Ӣ�۰�������
  CM_QUERYHEROBAGITEMS = 5031; //�鿴Ӣ�۰���
  SM_SENDHEROUSEITEMS = 5032;  //����Ӣ������װ��
  SM_HEROBAGITEMS = 5033;     //����Ӣ����Ʒ
  SM_HEROADDITEM = 5034;  //Ӣ�۰��������Ʒ
  SM_HERODELITEM = 5035;  //Ӣ�۰���ɾ����Ʒ
  SM_HEROUPDATEITEM = 5036; //Ӣ�۰���������Ʒ
  SM_HEROADDMAGIC = 5037;   //���Ӣ��ħ��
  SM_HEROSENDMYMAGIC = 5038; //����Ӣ�۵�ħ��
  SM_HERODELMAGIC = 5039;   //ɾ��Ӣ��ħ��
  SM_HEROABILITY = 5040;   //Ӣ������1
  SM_HEROSUBABILITY = 5041;//Ӣ������2
  SM_HEROWEIGHTCHANGED = 5042;
  CM_HEROEAT = 5043;       //�Զ���
  SM_HEROEAT_OK = 5044;    //�Զ����ɹ�
  SM_HEROEAT_FAIL = 5045; //�Զ���ʧ��
  SM_HEROMAGIC_LVEXP = 5046;//ħ���ȼ�
  SM_HERODURACHANGE = 5047;  //Ӣ�۳־øı�
  SM_HEROWINEXP = 5048;    //Ӣ�����Ӿ���
  SM_HEROLEVELUP = 5049;  //Ӣ������
  //SM_HEROCHANGEITEM = 5050; //Ӣ���Զ�������Ʒ(����û����) 20110912 ע��
  SM_HERODELITEMS = 5051;   //ɾ��Ӣ����Ʒ
  CM_HERODROPITEM = 5052;   //Ӣ������������Ʒ
  SM_HERODROPITEM_SUCCESS = 5053;//Ӣ������Ʒ�ɹ�
  SM_HERODROPITEM_FAIL = 5054;  //Ӣ������Ʒʧ��
  CM_HEROGOTETHERUSESPELL = 5055; //ʹ�úϻ�
  SM_GOTETHERUSESPELL = 5056; //ʹ�úϻ�
  SM_FIRDRAGONPOINT = 5057;   //Ӣ��ŭ��ֵ
  CM_REPAIRFIRDRAGON = 5058;  //�޲�����֮��
  SM_REPAIRFIRDRAGON_OK = 5059; //�޲�����֮�ĳɹ�
  SM_REPAIRFIRDRAGON_FAIL = 5060; //�޲�����֮��ʧ��
  CM_ASSESSMENTHERO = 1006;//����Ӣ��
  SM_ASSESSMENTHERO_OK = 3032;//Ӣ�������ɹ�
  SM_ASSESSMENTHERO_FAIL = 3033;//Ӣ������ʧ��
  CM_CHOOSEHEROJOB = 3026;//������ѡ����ְҵ(�����ѡ���ĸ�ְҵӢ�۳�ս)
  CM_HEROAUTOPRACTICE = 3027;//Ӣ����������
  SM_HEROAUTOPRACTICE_OK = 3028;//Ӣ�����������ɹ�
  SM_OPENHEROAUTOPRA = 3029;//��Ӣ��������������
  RM_GOLDGAMEGIRDCHANGED = 3034;//���¿ͻ��˽�Ҽ����
  SM_GOLDGAMEGIRDCHANGED = 3035;//���¿ͻ��˽�Ҽ����
  CM_SHOWHEROLEVEL = 3047;//����Ӣ�۵ȼ�������ʾ����
//------------------ף����.ħ�������---------------------------
  CM_DBLREPAIRDRAGON = 4999;//˫��װ��λ�õ�ף����,�Զ��Ѱ������ף����������) 20100928
  CM_REPAIRDRAGON = 5061;  //ף����.ħ�������
  SM_REPAIRDRAGON_OK = 5062; //�޲�ף����.ħ����ɹ�
  SM_REPAIRDRAGON_FAIL = 5063; //�޲�ף����.ħ���ʧ��
//----------------------------------------------------
  SM_OPENBOXS = 5064;//�򿪱��� 20080115
  SM_ASSESSMENTHEROINFO = 5065; //��������Ӣ������
  RM_OPENHEROAUTOPRA = 5066;//��Ӣ��������������

  CM_REPAIRDRAGONINDIA = 5067;  //�޲�����ӡ
  SM_REPAIRDRAGONINDIA_OK = 5068; //�޲�����ӡ�ɹ�
  SM_REPAIRDRAGONINDIA_FAIL = 5069; //�޲�����ӡʧ��

  {$IF M2Version <> 2}
  RM_NGMAGIC_LVEXP = 5070;//ŭ֮�ڹ�����ǿ���ɹ� 20110604
  SM_NGMAGIC_LVEXP = 5071;
  RM_HERONGMAGIC_LVEXP = 5072;//ŭ֮�ڹ�����ǿ���ɹ� 20110605
  SM_HERONGMAGIC_LVEXP = 5073;
  CM_NGMAGICLVEXP = 5074;//�ͻ��˵���ڹ���������ϵġ�������
  {$IFEND}
  RM_PETSMONHAPPLOG = 5075;//�򿪳���ι����־
  SM_PETSMONHAPPLOG = 5076;//�򿪳���ι����־
  CM_PETSMONHAPPLOG = 5078;//ι����־��ҳ
  CM_MOVETOPETSMON = 5079;//���͵���������
  SM_MOVETOPETSMON = 5080;//���ͳɹ�
  RM_UPPETSMONHAPP = 5081;//���³���Ŀ��ֶ�
  SM_UPPETSMONHAPP = 5082;

  CM_CHECK9YEARSBOXSKEY = 19985;//�������ʼѡ�񡱣����ж��Ƿ���Կ�ף�ûԿ�ף�����ʾ����
  RM_GET9YEARSBOXSITEM_OK = 19986; //�����걦��ȡ��Ʒ�ɹ�
  SM_GET9YEARSBOXSITEM_OK = 19987; //�����걦��ȡ��Ʒ�ɹ�
  RM_SEND9YEARSITEMID = 19988;//����ѡ�����Ʒ����ID
  SM_SEND9YEARSITEMID = 19989;//����ѡ�����Ʒ����ID
  CM_OPENNEW9YEARSBOXS = 19990;//���������
  CM_GETFREE9YEARSBOXSITEM = 19991;//ȡ20����ѽ���������Ʒ
  CM_OPENFREE9YEARSBOXS = 19992;//����ѽ�������
  CM_GET9YEARSBOXSITEM = 19993;//ȡ9���걦����Ʒ
  CM_UPDATA9YEARSBOXSITEM = 19994;//����������Ʒ
  CM_OPEN9YEARSBOXS = 19995;//��9���걦��
  CM_BUY9YEARSBOXSKEY = 19996; //����9���걦���Կ��

  RM_BLOODSOUL = 19997;//Ѫ��һ��(ս)
  SM_BLOODSOUL = 19998;//Ѫ��һ��(ս)
  RM_RECALLHERO = 19999;//�ٻ�Ӣ��
  RM_HEROWEIGHTCHANGED = 20000;
  RM_SENDHEROUSEITEMS = 20001;
  RM_SENDHEROMYMAGIC = 20002;
  RM_HEROMAGIC_LVEXP = 20003;
  RM_QUERYHEROBAGCOUNT = 20004;
  RM_HEROABILITY = 20005;
  RM_HERODURACHANGE = 20006;
  RM_HERODEATH = 20007;
  RM_HEROLEVELUP = 20008;
  RM_HEROWINEXP = 20009;
  RM_ASSESSMENTHEROINFO = 20010;//��������Ӣ������
  RM_CREATEHERO = 20011;
  RM_MAKEGHOSTHERO = 20012;
  RM_HEROSUBABILITY = 20013;

  RM_GOTETHERUSESPELL = 20014; //ʹ�úϻ�
  RM_FIRDRAGONPOINT = 20015;  //����Ӣ��ŭ��ֵ
  //-----------------------------------�����ػ�
  RM_FAIRYATTACKRATE = 20017;
  SM_FAIRYATTACKRATE = 20018;
  //-----------------------------------
  SM_SERVERUNBIND = 20019;
  RM_DESTROYHERO = 20020;//Ӣ������
  SM_DESTROYHERO = 20021;//Ӣ������

  ET_PROTECTION_STRUCK = 20022; //�����ܹ���  20080108
  ET_PROTECTION_PIP = 20023;  //���屻��
  
  SM_MYSHOW = 20024; //��ʾ������
  RM_MYSHOW = 20025; //

  RM_OPENBOXS = 20026;//�򿪱��� 20080115
  CM_OPENBOXS = 20027;//�򿪱��� 20080115 ��
  CM_MOVEBOXS = 20028;//ת������ 20080117
  RM_MOVEBOXS = 20029;//ת������ 20080117
  SM_MOVEBOXS = 20030;//ת������ 20080117
  CM_GETBOXS  = 20031;//�ͻ���ȡ�ñ�����Ʒ 20080118
  SM_GETBOXS  = 20032;
  RM_GETBOXS  = 20033;
  SM_OPENBOOKS  = 20034; //������NPC 20080119
  RM_OPENBOOKS  = 20035;
  RM_DRAGONPOINT = 20036;  //���ͻ�����ֵ 20080201
  SM_DRAGONPOINT = 20037;
  ET_OBJECTLEVELUP = 20038; //��������������ʾ 20080222
  RM_CHANGEATTATCKMODE = 20039; //�ı乥��ģʽ 20080228
  SM_CHANGEATTATCKMODE = 20040; //�ı乥��ģʽ 20080228
  CM_EXCHANGEGAMEGIRD = 20042; //���̶һ����  20080302
  SM_EXCHANGEGAMEGIRD_FAIL = 20043;//���̹�����Ʒʧ��
  SM_EXCHANGEGAMEGIRD_SUCCESS = 20044;
  RM_EXCHANGEGAMEGIRD_FAIL = 20045;
  RM_EXCHANGEGAMEGIRD_SUCCESS = 20046;
  RM_OPENDRAGONBOXS = 20047; //���������� 20080306
  SM_OPENDRAGONBOXS = 20048; //���������� 20080306
  RM_OPENBOXS_FAIL = 20049; //�򿪱���ʧ�� 20080306
  SM_OPENBOXS_FAIL = 20050; //�򿪱���ʧ�� 20080306

  RM_EXPTIMEITEMS = 20051;  //������ ����ʱ��ı���Ϣ 20080306
  SM_EXPTIMEITEMS = 20052;  //������ ����ʱ��ı���Ϣ 20080306

  ET_OBJECTBUTCHMON = 20053; //������ʬ��õ���Ʒ��ʾ 20080325
  ET_DRINKDECDRAGON = 20054;//�ȾƵ����ϻ�����ʾ����Ч�� 20090105

  SM_SENDHERONGRESUME  = 20055;//Ӣ���ڹ��ָ��ٶ�ֵ���˺�ֵ������ֵ 20090812
//---------------------------����ϵͳ------------------------------------------
  RM_QUERYREFINEITEM = 20056; //�򿪴������
  SM_QUERYREFINEITEM = 20057; //�򿪴������
  CM_REFINEITEM = 20058;      //�ͻ��˷��ʹ�����Ʒ 20080507

  SM_UPDATERYREFINEITEM = 20059; //���´�����Ʒ 20080507
  CM_REPAIRFINEITEM = 20060; //�޲�����ʯ 20080507
  SM_REPAIRFINEITEM_OK = 20061; //�޲�����ʯ�ɹ�  20080507
  SM_REPAIRFINEITEM_FAIL = 20062; //�޲�����ʯʧ��  20080507
//-----------------------------------------------------------------------------
  RM_DAILY = 20063;//���ս��� 20080511
  SM_DAILY = 20064;//���ս��� 20080511
  RM_GLORY = 20065;//���͵��ͻ��� ����ֵ 20080511
  SM_GLORY = 20066;//���͵��ͻ��� ����ֵ 20080511

  RM_GETHEROINFO = 20067;
  SM_GETHEROINFO = 20068; //���Ӣ������
  CM_SELGETHERO  = 20069; //ȡ��Ӣ��
  RM_SENDUSERPLAYDRINK = 20070;//������ƶԻ��� 20080515
  SM_SENDUSERPLAYDRINK = 20071;//������ƶԻ��� 20080515
  CM_USERPLAYDRINKITEM = 20072;//��ƿ������Ʒ���͵�M2
  SM_USERPLAYDRINK_OK = 20073;  //��Ƴɹ�  20080515
  SM_USERPLAYDRINK_FAIL = 20074; //���ʧ�� 20080515
  RM_PLAYDRINKSAY = 20075;//
  SM_PLAYDRINKSAY = 20076;
  CM_PlAYDRINKDLGSELECT = 20077; //��Ʒѡ��,����
  RM_OPENPLAYDRINK = 20078;   //�򿪴���
  SM_OPENPLAYDRINK = 20079;   //�򿪴���
  CM_PlAYDRINKGAME = 20080;  //���Ͳ�ȭ���� 20080517
  RM_PlayDrinkToDrink = 20081; //���͵��ͻ���˭Ӯ˭��
  SM_PlayDrinkToDrink = 20082; //
  CM_DrinkUpdateValue = 20083; //���ͺȾ�
  RM_DrinkUpdateValue = 20084; //���غȾ�
  SM_DrinkUpdateValue = 20085; //���غȾ�
  RM_CLOSEDRINK = 20086;//�رն��ƣ���ƴ���
  SM_CLOSEDRINK = 20087;//�رն��ƣ���ƴ���
  CM_USERPLAYDRINK = 20088; //�ͻ��˷��������Ʒ
  SM_USERPLAYDRINKITEM_OK = 20089;  //�����Ʒ�ɹ�
  SM_USERPLAYDRINKITEM_FAIL = 20090; //�����Ʒʧ��
  RM_Browser = 20091;//����ָ����վ
  SM_Browser = 20092;

  RM_PIXINGHIT = 20093;//����նЧ�� 20080611
  SM_PIXINGHIT = 20094;

  RM_LEITINGHIT = 20095;//����һ��Ч�� 20080611
  SM_LEITINGHIT = 20096;

  CM_CHECKNUM = 20097;//�����֤��(DBServer) 20080612
  SM_CHECKNUM_OK = 20098;
  CM_CHANGECHECKNUM = 20099;//(DBServer)

  RM_AUTOGOTOXY = 20100;//�Զ�Ѱ·
  SM_AUTOGOTOXY = 20101;
//-----------------------���ϵͳ---------------------------------------------
  RM_OPENMAKEWINE =20102;//����ƴ���
  SM_OPENMAKEWINE =20103;//����ƴ���
  CM_BEGINMAKEWINE = 20104;//��ʼ���(���Ѳ���ȫ���ϴ���)
  RM_MAKEWINE_OK = 20105;//��Ƴɹ�
  SM_MAKEWINE_OK = 20106;//��Ƴɹ�
  RM_MAKEWINE_FAIL = 20107;//���ʧ��
  SM_MAKEWINE_FAIL = 20108;//���ʧ��
  RM_NPCWALK = 20109;//���NPC�߶�
  SM_NPCWALK = 20110;//���NPC�߶�
//------------------------��սϵͳ--------------------------------------------
  SM_CHALLENGE_FAIL = 20113;//��սʧ��
  SM_CHALLENGEMENU =20114;//����ս��Ѻ��Ʒ����
  CM_CHALLENGETRY = 20115;//��ҵ���ս

  CM_CHALLENGEADDITEM = 20116;//��Ұ���Ʒ�ŵ���ս����
  SM_CHALLENGEADDITEM_OK = 20117;//������ӵ�Ѻ��Ʒ�ɹ�
  SM_CHALLENGEADDITEM_FAIL = 20118;//������ӵ�Ѻ��Ʒʧ��
  SM_CHALLENGEREMOTEADDITEM = 20119;//�������ӵ�Ѻ����Ʒ��,���ͻ�����ʾ

  CM_CHALLENGEDELITEM = 20120;//��Ҵ���ս����ȡ����Ʒ
  SM_CHALLENGEDELITEM_OK= 20121;//���ɾ����Ѻ��Ʒ�ɹ�
  SM_CHALLENGEDELITEM_FAIL = 20122;//���ɾ����Ѻ��Ʒʧ��
  SM_CHALLENGEREMOTEDELITEM = 20123;//����ɾ����Ѻ����Ʒ��,���ͻ�����ʾ

  CM_CHALLENGECANCEL = 20124;//���ȡ����ս
  SM_CHALLENGECANCEL = 20125;//���ȡ����ս

  CM_CHALLENGECHGGOLD = 20126; //�ͻ��˰ѽ�ҷŵ���ս����
  SM_CHALLENCHGGOLD_FAIL = 20127; //�ͻ��˰ѽ�ҷŵ���ս����ʧ��
  SM_CHALLENCHGGOLD_OK = 20128; //�ͻ��˰ѽ�ҷŵ���ս���гɹ�
  SM_CHALLENREMOTECHGGOLD = 20129; //�ͻ��˰ѽ�ҷŵ���ս����,���ͻ�����ʾ

  CM_CHALLENGECHGDIAMOND = 20130; //�ͻ��˰ѽ��ʯ�ŵ���ս����
  SM_CHALLENCHGDIAMOND_FAIL = 20131; //�ͻ��˰ѽ��ʯ�ŵ���ս����ʧ��
  SM_CHALLENCHGDIAMOND_OK = 20132; //�ͻ��˰ѽ��ʯ�ŵ���ս���гɹ�
  SM_CHALLENREMOTECHGDIAMOND = 20133; //�ͻ��˰ѽ��ʯ�ŵ���ս����,���ͻ�����ʾ

  CM_CHALLENGEEND = 20134;//��ս��Ѻ��Ʒ����
  SM_CLOSECHALLENGE = 20135;//�ر���ս��Ѻ��Ʒ����
//----------------------------------------------------------------------------
  RM_PLAYMAKEWINEABILITY = 20136;//��2������� 20080804
  SM_PLAYMAKEWINEABILITY = 20137;//��2������� 20080804
  RM_HEROMAKEWINEABILITY = 20138;//��2������� 20080804
  SM_HEROMAKEWINEABILITY = 20139;//��2������� 20080804

  RM_CANEXPLORATION = 20140;//��̽�� 20080810
  SM_CANEXPLORATION = 20141;//��̽�� 20080810
//----------------------------------------------------------------------------
  SM_SENDLOGINKEY = 20142; //���ظ��ͻ��˻��½�����͵�½������� 20080901
  CM_SENDLOGINKEY = 142; //���ظ��ͻ��˻��½�����͵�½������� 20080901
  SM_GATEPASS_FAIL = 20143; //�����ص��������

  RM_USERBIGSTORAGEITEM = 20146;//�û����޲ֿ���Ŀ
  RM_USERBIGGETBACKITEM = 20147;//�û���ûص����޲ֿ���Ŀ
  RM_USERLEVELORDER = 20148;//�û��ȼ�����

  RM_HEROAUTOOPENDEFENCE = 20149;//Ӣ���ڹ��Զ��������� 20080930
  SM_HEROAUTOOPENDEFENCE = 20150;//Ӣ���ڹ��Զ��������� 20080930
  CM_HEROAUTOOPENDEFENCE = 20151;//Ӣ���ڹ��Զ��������� 20080930

  RM_MAGIC69SKILLEXP = 20152;//�ڹ��ķ�����
  SM_MAGIC69SKILLEXP = 20153;//�ڹ��ķ�����
  RM_HEROMAGIC69SKILLEXP = 20154;//Ӣ���ڹ��ķ�����  20080930
  SM_HEROMAGIC69SKILLEXP = 20155;//Ӣ���ڹ��ķ�����  20080930

  RM_MAGIC69SKILLNH = 20156;//����ֵ(����) 20081002
  SM_MAGIC69SKILLNH = 20157;//����ֵ(����) 20081002
  RM_WINNHEXP = 20158;//ȡ���ڹ����� 20081007
  SM_WINNHEXP = 20159;//ȡ���ڹ����� 20081007
  RM_HEROWINNHEXP = 20160;//Ӣ��ȡ���ڹ����� 20081007
  SM_HEROWINNHEXP = 20161;//Ӣ��ȡ���ڹ����� 20081007

  SM_SHOWSIGHICON = 20162; //��ʾ��̾��ͼ�� 20090126
  RM_HIDESIGHICON = 20163; //���ظ�̾��ͼ�� 20090126
  SM_HIDESIGHICON = 20164; //���ظ�̾��ͼ�� 20090126
  CM_CLICKSIGHICON = 20165; //�����̾��ͼ�� 20090126
  SM_UPDATETIME = 20166;//ͳһ��ͻ��˵ĵ���ʱ 20090129

  RM_OPENEXPCRYSTAL = 20167; //��ʾ��ؽᾧͼ�� 20090201
  SM_OPENEXPCRYSTAL = 20168; //��ʾ��ؽᾧͼ�� 20090201
  SM_SENDCRYSTALNGEXP = 20169; //������ؽᾧ���ڹ����� 20090201
  SM_SENDCRYSTALEXP = 20170; //������ؽᾧ���ڹ����� 20090201
  SM_SENDCRYSTALLEVEL = 20171; //������ؽᾧ�ĵȼ� 20090202
  CM_CLICKCRYSTALEXPTOP = 20172; //�����ؽᾧ��þ��� 20090202
//----------------------------------------------------------------------------
  CM_OPENNEWBOXS = 20173;//���µı���
  CM_BUYNEWBOXSKEY = 20174; //�����±����Կ��
  CM_ROTATIONBOX = 20175;//ת������ ��ģʽ
  RM_BOXITMEFILLED = 20176;//�����Ʒ  ��ģʽ
  SM_BOXITMEFILLED = 20177;//�����Ʒ  ��ģʽ
  CM_UPDADEBOXSITMES = 20178;//��䱦����Ʒ
  CM_REQUESTGUILDWAR = 20180;//�лᴰ�������л�ս 20090510

  RM_OPENCATTLEGAS = 20181;//��ʾţ���� 20090518
  SM_OPENCATTLEGAS = 20182;//��ʾţ���� 20090518
  SM_SENDCATTLEGASEXP = 20183; //����ţ��ֵ����������ֵ 20090520
  SM_SENDCATTLEGASLEVEL = 20184; //����ţ���ܵȼ� 20090520
  RM_WINCATTLEGASEXP = 20185;//ȡ��ţ��ֵ���� 20090520
  SM_WINCATTLEGASEXP = 20186;//ȡ��ţ��ֵ���� 20090520
//--------------------------------�������-------------------------------------
  RM_OPENMAKEKIMNEEDLE = 20187;//�ͻ�����ʾ�������봰�� 20090615
  SM_OPENMAKEKIMNEEDLE = 20188;//�ͻ�����ʾ�������봰�� 20090615
  CM_ITEMSPLIT = 20189;//�ͻ��˲����Ʒ 20090615
  CM_ITEMMERGER = 20190;//�ͻ��˺ϲ���Ʒ 20090615
  SM_MERGER_OK = 20191;//�ͻ��˺ϲ���Ʒ�ɹ�
  SM_MERGER_FAIL = 20192;//�ͻ��˺ϲ���Ʒʧ��
  CM_EXERCISEKIMNEEDLE = 20193;//�ͻ��˿�ʼ���� 20090620
  SM_EXERCISEKIMNEEDLE_OK = 20194;//����ɹ�
  SM_EXERCISEKIMNEEDLE_FAIL = 20195;//����ʧ��
  RM_SENDUSERPULSEARR = 20196;//��½ʱ���͸����������
  SM_SENDUSERPULSEARR = 20197;//��½ʱ���͸���������� 20090621
  CM_OPENPULSEPOINT = 20198;//�ͻ��˵��Ѩλ 20090621
  CM_CLICKBATTERNPC = 20199; //����NPCִ�д����ű��� 20090623
  SM_SENDUPDATAPULSEARR = 20200;//���¾������� 20090623
  CM_PRACTICEPULSE = 20201;//�ͻ����������� 20090623
  CM_USEBATTERSPELL = 20202; //ʹ������ 20090624
  RM_SENDUSERPULSESHINY = 20203;//����ͨ��Ѩλ���� 20090624
  SM_SENDUSERPULSESHINY = 20204;//����ͨ��Ѩλ���� 20090624

  RM_BATTERHIT1 = 20205;//׷�Ĵ� 20090625
  SM_BATTERHIT1 = 20206;//׷�Ĵ� 20090625
  RM_BATTERHIT2 = 20207;//����ɱ 20090702
  SM_BATTERHIT2 = 20208;//����ɱ 20090702

  RM_SENDCANUSEBATTER = 20209;//���Ϳ�ʹ��������֪ͨ
  SM_SENDCANUSEBATTER = 20210;//���Ϳ�ʹ��������֪ͨ

  RM_BATTERHIT3 = 20211;//��ɨǧ�� 20090702
  SM_BATTERHIT3 = 20212;//��ɨǧ�� 20090702
  RM_BATTERHIT4 = 20213;//����ն
  SM_BATTERHIT4 = 20214;//����ն

  RM_RUSH79 = 20215;//׷�Ĵ̳ɹ�
  SM_RUSH79 = 20216;

  RM_BATTEROVER = 20217;//������������
  SM_BATTEROVER = 20218;//������������

  RM_10102 = 20219;//ս������Ϣ��ʹ�˺��� 20090726

  CM_CLIENTPUNISHMENT = 20220; //���Υ������������QF @Punishment 20090808
  RM_SENDNGRESUME  = 20221;//�ڹ��ָ��ٶ�ֵ���˺�ֵ������ֵ 20090812
  SM_SENDNGRESUME  = 20222;//�ڹ��ָ��ٶ�ֵ���˺�ֵ������ֵ 20090812

  SM_SENDHEROPULSESHINY = 20223;//Ӣ�۴���ͨ��Ѩλ����
  SM_SENDHEROPULSEARR = 20224;//��½ʱ���͸����������

  CM_OPENHEROPULSEPOINT = 20225;//�ͻ��˵��Ӣ��Ѩλ
  SM_SENDHEROUPDATAPULSEARR = 20226;//����Ӣ�۾�������
  CM_HEROPRACTICEPULSE = 20227;//�ͻ���Ӣ���������� 20090911

  SM_SENDHEROGETPULSEEXP = 20228;//����Ӣ��ȡ���ľ��羭��

  CM_HEROUSEBATTERTOMON = 20231;//Ӣ�۴���Ƿ�ʹ������

  RM_OPEN4BATTERSKILL = 20232;//���������������� 20100720
  SM_OPEN4BATTERSKILL = 20233;//���������������� 20100720

  RM_OPENSHINY = 20234;//��ʾ�ɳ�����
  SM_OPENSHINY = 20235; //��ʾ�ɳ�����
  CM_CLICKMMISSION = 20236;//�ͻ��˵����������ť
  RM_CLICKMMISSION = 20237;//M2�ظ��ͻ��˵���¼�
  SM_CLICKMMISSION = 20238;//M2�ظ��ͻ��˵���¼�
  RM_SHOWSHINY = 20239; //�ڿͻ����á��ɳ����񡱰�������
  SM_SHOWSHINY = 20240; //�ڿͻ����á��ɳ����񡱰�������
  RM_PALYVIDEO = 20242;//����ָ������Ƶ�ļ�
  SM_PALYVIDEO = 20243;//����ָ������Ƶ�ļ�
  RM_HEAR2 = 20244;

  RM_OpenRefineArmyDrum = 20251;    // �򿪴������Ĵ���, �����NPC����TPlayObject
  SM_OpenRefineArmyDrum = 20252;    // �򿪴������Ĵ���
  CM_RefineArmyDrum = 20253;        // �ͻ��˷��ʹ������ĵ���Ʒ

  CM_DragonRect = 20254;        // �ͻ��˷��ʹ������ĵ���Ʒ
  RM_DragonRect = 20256;        // �ͻ��˷��ʹ������ĵ���Ʒ
  SM_DragonRect = 20257;        // �ͻ��˷��ʹ������ĵ���Ʒ

  //
  SM_HUMTAKEITEM = 20255;  // �����������ָ wParam=1 ��� 0:ժ��
  RM_HUMTAKEITEM = 20256;
  SM_SENDLOGINFAILBYHC = 20258; //�������ط������

  ////////////////////////////////////////////////////////////////////////////////
  UNITX = 48;//�ͻ���ʹ��
  UNITY = 32;//�ͻ���ʹ��
  HALFX = 24;//�ͻ���ʹ��
  HALFY = 16;//�ͻ���ʹ��

  MAXMAGIC = 35; //�����ͨ������
  MAXNGMAGIC = 30; //����ڹ�������
  MAXBAGITEM = 46;//���ﱳ���������(�ֿ���Ʒ����)
  MAXHEROBAGITEM = 40; //Ӣ�۰����������
  MAXUSEITEM = 13;//����װ������
  MAXSTORAGEITEM = 50;
  LOGICALMAPUNIT = 40;
type
  TMonStatus = (s_KillHuman{ɱ��}, s_UnderFire{������}, s_Die{����}, s_MonGen{ˢ��});//����˵����
  TMsgColor = (c_Red{��}, c_Green, c_Blue{��}, c_White, c_Fuchsia{ǧ�ﴫ����ɫ},BB_Fuchsia{���������ʾ},C_HeroHint{Ӣ��״̬});
  TMsgType = (t_Notice{����}, t_Hint{��ʾ}, t_System{ϵͳ}, t_Say, t_Mon, t_GM, t_Cust, t_Castle{�Ǳ�});
  TDefaultMessage = record
    Recog: Integer;//ʶ����
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;
    nSessionID: Integer;//�ͻ��˻ỰID 20081210
  end;
  pTDefaultMessage = ^TDefaultMessage;

  {TItemType = (i_HPDurg,i_MPDurg,i_HPMPDurg,i_OtherDurg,i_Weapon,i_Dress,i_Helmet,i_Necklace,i_Armring,i_Ring,i_Belt,i_Boots,i_Charm,i_Book,i_PosionDurg,i_UseItem,i_Scroll,i_Stone,i_Gold,i_Other);
                              //  [ҩƷ] [����]      [�·�]    [ͷ��][����]     [����]      [��ָ] [����] [Ь��] [��ʯ]         [������][��ҩ]        [����Ʒ][����]
  TShowItem = record
    sItemName    :String;
   // ItemType     :TItemType;
    boAutoPickup :Boolean;
    boShowName   :Boolean;
    //nFColor      :Integer;
    //nBColor      :Integer;
  end;
  pTShowItem = ^TShowItem;  }


  TOSObject = record
    btType: Byte;//����
    CellObj: TObject;//����
    dwAddTime: LongWord;//���ӵ�ʱ��
    boObjectDisPose: Boolean;//���Ƿ����ͷ�
  end;
  pTOSObject = ^TOSObject;

  TSendMessage = record
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    BaseObject: TObject;
    dwAddTime: LongWord;
    dwDeliveryTime: LongWord;//������ʱ��
    boLateDelivery: Boolean;//�Ƿ���󴫳�
    Buff: PChar;
  end;
  pTSendMessage = ^TSendMessage;

  TProcessMessage = record
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    BaseObject: TObject;
    boLateDelivery: Boolean;//��ʱ����
    dwDeliveryTime: LongWord;//��ʱʱ��
    sMsg: string;
  end;
  pTProcessMessage = ^TProcessMessage;

  TLoadHuman = record//M2,DBSʹ��(Ӣ��������ʹ��ͬһ�ṹ)
    sAccount: string[12];//�˺�
    sChrName: string[ACTORNAMELEN];//����
    sUserAddr: string[15];//IP��ַ
    nSessionID: Integer;//�ỰID
    boIsNewHero: boolean;//�Ƿ񸱽�
    nJob: Byte;//����ְҵ 0-ս 1-�� 2-�� 3-�̿�
  end;

  TShortMessage = record
    Ident: Word;
    wMsg: Word;
  end;

  TMessageBodyW = record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end;

  TFeatures = packed record//��۽ṹ
    nDress: Word;//�·�
    nWeapon: Word;//����
    nRaceImg: Word;//��ɫ����
    btHair: Byte;//����
    btStatus:Byte;
    //nAppr: Word;//��ʹ��
    nDressLook: Word;//�·������Ч
    nDressLookWil: Byte;//�·����WIL����
    nWeaponLook: Word;//���������Ч
    nWeaponLookWil: Byte;//�������WIL����
  end;

  TMessageBodyWL2 = record
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TMessageBodyWL = record
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
    MonShowName: Byte;//�������� 20110713
    feature: TFeatures;
  end;

  TCharDesc = record
    Status: Integer;
    MonShowName: Byte;//�������� 20110713
    feature: TFeatures;
  end;

  TCharDesc1 = record//�ּ�¼����ʹ��
    feature: Integer;
    Status: Integer;
  end;

  TSessInfo = record //ȫ�ֻỰ
    sAccount: string[12];
    sIPaddr: string[15];
    nSessionID: Integer;
    dwHCode:DWord;//�����û�� �����Ӳ����
    nPayMent: Integer;//��ֵ��
    nPayMode: Integer;//��ֵģʽ
    nSessionStatus: Integer;
    dwStartTick: LongWord;
    dwActiveTick: LongWord;
    nRefCount: Integer;
  end;
  pTSessInfo = ^TSessInfo;

  TQuestInfo = record
    wFlag: Word;
    btValue: Byte;
    nRandRage: Integer;
  end;
  pTQuestInfo = ^TQuestInfo;

  TScript = record
    boQuest: Boolean;
    QuestInfo: array[0..9] of TQuestInfo;
    nQuest: Integer;
    RecordList: TList;
  end;
  pTScript = ^TScript;

  TMonItem = record
    n00: Integer;//����ֵ 1/10�е�1
    n04: Integer;//�������� 1/10�е�10
    sMonName: string;//��Ʒ����
    n18: Integer;//��Ʒ����
    NewMonList: TList;//��ģʽ
  end;
  pTMonItem = ^TMonItem;

  TItemName = record
    nItemIndex: Integer;
    nMakeIndex: Integer;
    sItemName: string;
  end;
  pTItemName = ^TItemName;

  TVarType = (vNone, vInteger, vString);

  TDynamicVar = record//���˱����ṹ
    sName: string;
    VarType: TVarType;
    nInternet: LongWord;
    sString: string;
  end;
  pTDynamicVar = ^TDynamicVar;

  TRecallMigic = record
    nHumLevel: Integer;
    sMonName: string;
    nCount: Integer;
    nLevel: Integer;
  end;

  TMonSayMsg = record
    nRate: Integer;//����
    sSayMsg: string;//˵������
    State: TMonStatus;//״̬
    Color: TMsgColor;//��ɫ
  end;
  pTMonSayMsg = ^TMonSayMsg;

  TMonDrop = record//���ﱬ��Ʒ��
    sItemName: string;//��Ʒ��
    nDropCount: Integer;//�ѱ�����
    nNoDropCount: Integer;//δ������
    nCountLimit: Integer;//�ɱ�����
  end;
  pTMonDrop = ^TMonDrop;

  TGameCmd = record
    sCmd: string[25];
    nPermissionMin: Integer;
    nPermissionMax: Integer;
  end;
  pTGameCmd = ^TGameCmd;

  TSrvNetInfo = record
    sIPaddr: string[15];
    nPort: Integer;
  end;
  pTSrvNetInfo = ^TSrvNetInfo;

  TCheckCode = record
  end;

  TOnTimer=packed record//���˶�ʱ��
    NextTimer   :LongWord;
    RunCount    :Byte;
    Interval    :LongWord;
    nIdx        :Byte;
  end;
  pTOnTimer=^TOnTimer;   

  TStdItem = packed record//���������޸ģ���Ӱ��װ�����а� 20110315
    Name: string[14*2];//��Ʒ����14
    StdMode: Byte; //��Ʒ���� 0/1/2/3��ҩ�� 5/6:������10/11�����ף�15��ͷ����22/23����ָ��24/26������19/20/21������
    Shape: Byte;//װ�����
    Weight: Byte;//����
    AniCount: {Byte}Word;//20110131 ��չ
    Source: ShortInt;//Դ����
    Reserved: Byte; //����
    NeedIdentify: Byte; //��Ҫ��¼��־
    Looks: Word; //��ۣ���Items.WIL�е�ͼƬ����
    DuraMax: Word; //���־�
    Reserved1: Word;//��������
    AC: Integer; //0x1A
    MAC: Integer; //0x1C
    DC: Integer; //0x1E
    MC: Integer; //0x20
    SC: Integer; //0x22
    Need: Integer; //0x24
    NeedLevel: Integer; //0x25
    Price: Integer; //�۸�
    Stock: Integer;//װ����������������+�ȼ���������������ʹ��
    nHP:Integer;  // ��Ʒ������ֵ  on 2012.12.31
    nMP:Integer; // ��Ʒ��ħ��ֵ add by liuzhigang  on 2012.12.31
  end;
  pTStdItem = ^TStdItem;

  TOStdItem = packed record //OK
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: Byte;
    NeedLevel: Byte;
    w26: Word;
    Price: Integer;
  end;
  pTOStdItem = ^TOStdItem;

  TOClientItem = record //OK
    s: TOStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTOClientItem = ^TOClientItem;

  TClientItem = packed record //OK 20110710 ��packed����TDateTime����һ��Ҫ��packed����Ȼ��ͻ��˴�С��һ��(Ӱ��װ�����а�)
    s: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
    btValue:array[0..20] of Byte;  // ���ø�������ֵ��(ǰ5������:AC MAC DC MC SC) add by liuzhigang on 2011.12.20
    btAppraisalLevel : Byte;//0-�Ƿ�ɼ���(1-�ɼ��� 2-һ�� 3-���� 4-����)
    btUnKnowValueCount : Byte;
    btAppraisalValue :array[2..5] of Byte;
    //6..9
    btUnKnowValue: array[6..9] of Byte;
    //btUnKnowValue: array[0..9] of Byte;//��������
    Aura: Byte;//��ǰ����ֵ
    MaxAura: Byte;//����ֵ����
    MaxDate: TDateTime;//���ʹ������
    BindValue: Byte;//1��ʱ��Ʒ 2����(�����ں��ʹ��,���ڲ��ɽ���,����) 3���ð�(�Լ���ʹ��,���ɽ���,���󲻿ɼ���)
  end;
  PTClientItem = ^TClientItem;

  TEffecItem = packed record//��Ʒ��Ч
    sName : string[14*2];
    wBagIndex: Word;//������ʼͼƬ
    btBagCount: Byte;//������������
    nBagX: ShortInt;//����X��������
    nBagY: ShortInt;//����Y��������
    btBagWilIndex: Byte;//����Wil����
    wShapeIndex: Word;//�ڹۿ�ʼͼƬ
    btShapeCount: Byte;//�ڹ۲�������
    nShapeX: ShortInt;//�ڹ�X��������
    nShapeY: ShortInt;//�ڹ�Y��������
    btShapeWilIndex: Byte;//�ڹ�Wil����
    wLookIndex: Word;//��ۿ�ʼͼƬ
    //btLookCount: Byte;//��۲�������
    //nLookX: ShortInt;//���X��������
    //nLookY: ShortInt;//���Y��������
    btLookWilIndex: Byte;//���Wil����
  end;
  pTEffecItem = ^TEffecItem;
  TXinJianDingData = record
    ItemValueRetainMarks : array [0..3] of Byte; //��������
    Item3MakeIndex : Integer;
  end;
  {TClientEffecItem = record
    ClientItem: TClientItem;
    ClientEffec:TEffecItem;
  end;
  pTClientEffectItem = ^TClientEffecItem; }

  TMonInfo = record
    sName: string[14];//������
    btRace: Byte;//����
    btRaceImg: Byte;//����ͼ��
    wAppr: Word;//������� 1000> ֵʱ��ֵΪ258����mon25.wil��8���֣���ֵ10000>ֵ��1000<ֵʱ��ֵΪ3315,��mon33.wil��15���� 
    wLevel: Word;
    btLifeAttrib: Byte;//����ϵ
    boUndead: Boolean;
    wCoolEye: Word;//���߷�Χ
    dwExp: LongWord;
    wMP: {Word}Integer;//20091026 �޸�
    wHP: {Word}Integer;//20091026 �޸�
    wAC: Word;
    wMAC: Word;
    wDC: Word;
    wMaxDC: Word;
    wMC: Word;
    wSC: Word;
    wSpeed: Word;
    wHitPoint: Word;//������
    wWalkSpeed: Word;//�����ٶ�
    wWalkStep: Word;//���߲���
    wWalkWait: Word;//���ߵȴ�
    wAttackSpeed: Word;//�����ٶ�
    ItemList: TList;
  end;
  pTMonInfo = ^TMonInfo;

  TMagic = record //������
    wMagicId: Word;//����ID
    sMagicName: string[18];//��������
    btEffectType: Byte;//����Ч��
    btEffect: Byte;//ħ��Ч��
    wSpell: Word;//ħ������
    wPower: Word;//��������(�ͻ���:ŭ֮����ǿ��������ڹ��ȼ�)
    TrainLevel: array[0..3] of Byte;//���ܵȼ�
    MaxTrain: array[0..3] of LongWord;//�����ܵȼ����������  68,71,99,100����MaxTrain[0]--������������ 20091223�޸�
    btTrainLv: Byte;//�����ȼ�
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    dwDelayTime: LongWord;//������ʱ
    btDefSpell: Byte;//����ħ��
    btDefPower: Byte;//��������
    wMaxPower: Word;//�������(�ͻ���:ŭ֮����ǿ��������̱�ʯ��)
    btDefMaxPower: Byte;//�����������
    sDescr: string[8];//��ע˵��:��Ϊ���弼�� ��Ӣ�ۡ� �������� ���ڹ��� ��ͨ�á� ���񼼡�
  end;
  pTMagic = ^TMagic;

  TClientMagic = record //84
    Key: Char;//�������ܣ�1-��ʾ�˼����ڵ�һ��λ�� 2-��ʾ�˼����ڵڶ���λ�� 3-��ʾ�˼����ڵ�����λ��
    Level: Byte;//���ܵȼ�
    CurTrain: LongWord;//��������:0-Ϊ�� 1-���  ��ͨ����:��ǰ����
    Def: TMagic;
    btLevelEx: Byte;//ǿ���ȼ� 20110812
  end;
  PTClientMagic = ^TClientMagic;

  TUserMagic = record
    MagicInfo: pTMagic;
    wMagIdx: Word;//����ID
    btLevel: Byte;//�ȼ�
    btKey: Byte;//���ܿ�ݼ� Ӣ�ۼ��ܡ��ڹ�����(0-���ܿ�,1--���ܹ�)
    nTranPoint: LongWord;//��ǰ����ֵ
    btLevelEx: Byte;//ǿ���ȼ� 20110812
  end;
  pTUserMagic = ^TUserMagic;

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

  TShopInfo = record//������Ʒ
    StdItem: TSTDITEM;
    sIntroduce:array [0..200] of Char;
    Idx: string[1];
    ImgBegin: string[5];
    Imgend: string[5];
    Introduce1:string[20];
  end;
  pTShopInfo = ^TShopInfo;

  TUnbindInfo = record//���Ϳͻ��˽������
    nUnbindCode: Integer;
    sItemName: string[14*2];
  end;
  pTUnbindInfo = ^TUnbindInfo;

  TAdminInfo = record //����Ա��
    nLv: Integer;
    sChrName: string[ACTORNAMELEN];
    sIPaddr: string[15];
  end;
  pTAdminInfo = ^TAdminInfo;

  TMasterList = record //ͽ����������  20080530
    ID:Integer;//����
    sChrName: string[ACTORNAMELEN];//ͽ����
  end;
  pTMasterList = ^TMasterList;

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
  pTNakedAbility = ^TNakedAbility;
  TExpData = record
    nExp: Int64; //��ǰ����
    nMaxExp: Int64; //��������
    //nCurAdd: Int64; //��������
  end;
  TAbility = packed record//Size 40
    Level: Word; //�ȼ�
    AC: Integer; //����
    MAC: Integer; //ħ��
    DC: Integer; //������
    MC: Integer; //ħ��
    SC: Integer; //����
    HP: Integer;//��ǰHP
    MP: Integer;//��ǰMP
    MaxHP: Integer;//HP����
    MaxMP: Integer;//MP����
    nExp: Int64; //��ǰ����
    nMaxExp: Int64; //��������
    Weight: Word; //
    MaxWeight: Word; //����
    WearWeight: Word; //��������
    MaxWearWeight: Word;//������������
    HandWeight: Word; //
    MaxHandWeight: Word;//����
    Alcohol:Word;//����
    MaxAlcohol:Word;//��������
    WineDrinkValue: Word;//��ƶ�
    MedicineValue: Word;//��ǰҩ��ֵ
    MaxMedicineValue: Word;//ҩ��ֵ����
    {$IF M2Version = 1}
    TransferValue: Word;//��ǰ��תֵ
    MaxTransferValue: Word;//��תֵ����
    {$IFEND}
  end;
  pTAbility = ^TAbility;

  TOAbility = packed record//��������ʹ��
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
    NG: Word;//��ǰ����ֵLoWord()
    MaxNG: Word;//��ǰ����ֵHiWord()
    nExp: Int64; //��ǰ����
    nMaxExp: Int64; //��������
    Weight: Word;
    MaxWeight: Word;//�������
    WearWeight: Byte;
    MaxWearWeight: Byte;//�����
    HandWeight: Byte;
    MaxHandWeight: Byte;//����
  end;
  pTOAbility = ^TOAbility;

  TAddAbility = record //OK    //Size 40
    wHP: Integer;//HP����
    wMP: Integer;//MP����
    wHitPoint: Word;
    wSpeedPoint: Word;
    wAC: Integer;//���� ��������
    wMAC: Integer;//ħ�� ��������
    wDC: Integer;//������ ��������
    wMC: Integer;//ħ�� ��������
    wSC: Integer;//���� ��������
    bt1DF: Byte; //��ʥ
    wIncDragon: Byte;//�ϻ���������
    wAntiPoison: Word;//�ж����
    wPoisonRecover: Word;//�ж��ָ�
    wHealthRecover: Word;//�����ָ�
    wSpellRecover: Word;//ħ���ָ�
    wIncNHRecover: Word;//�����ָ�%���� 20090331
    wIncNHPoint: Word;//�����ָ����� 20090712
    wUnBurstRate: Byte;//�������� 20091227
    wDecTargetNHPoint: Byte;//Ŀ������ֵ���ٵ��� 20100513
    wAntiMagic: Word;
    btLuck: Byte;//����
    btUnLuck: Byte;//����
    nHitSpeed: Integer;
    btWeaponStrong: Byte;//ǿ��
    wWearWeight: Word;//���� 20080325
    btBurstRate: Byte;//��Ʒ���� 20091129
    wVampirePoint: Byte;//��Ѫ����(����)
    wVampireRate: Byte;//��Ѫ����(����)
    wUnParalysisRate: Word;//�������(�Ի��·�) 20100513
    wParalysisAddRate: Word;//���ǿ��(���磺����)
  end;
  pTAddAbility = ^TAddAbility;

{$IF M2Version <> 2}
  TAddUnKnowAbility = record  //��������
    boRebirth: Boolean;//��������
    boMagicShield: Boolean;//���Ի�����
    boParalysis: Boolean;//��Լ��� 
    boParalysis2: Boolean;//ħ����Լ���
    boParalysis1: Boolean;//ս����Լ���
    boProbeNecklace: Boolean;//̽�⼼��
    boTeleport: Boolean;//���ͼ���
    wDC: Word;//������ ����
    wMC: Word;//ħ�� ����
    wSC: Word;//���� ����
    wMAC: Word;//ħ�� ����
    wAC: Word;//���� ����
    wMain: Word;//������
    wIncNHPoint: Word;//�����ָ�����
    wMagicShieldLevel: Word;//��ħ�ȼ�(������ְҵ��ͬ�ӵ�����ͬ ս+50 ��+20 ��+35)
    wPhysicalLevel: Word;//ǿ��ȼ�(��Ѫ��ְҵ��ͬ�ӵ�����ͬ ս+50 ��+20 ��+35)
    wVampirePoint: Byte;//��Ѫ����(����)
    wDecTargetNHLevel: Byte;//���˵ȼ�
    wCritLevel: Byte;//�����ȼ�
    wUnBurstRate: Byte;//����
    wHitPoint: Byte; //׼ȷ
    wSpeedPoint: Byte; //����
    wUnParalysisRate: Byte;//��Կ���(�Ի��·�)
    wParalysisAddRate: Byte;//���ǿ��(���磺����)
    wIncDragonRate: Word;//�ϻ�����
    //��ýƷ�� ��btValue[11]���棬������btValue[12]
  end;

  TFengHaoAbility = record//�ƺ�����
    wHP: Word;//��������
    wDC: Word;//������ ����
    wMC: Word;//ħ�� ����
    wSC: Word;//���� ����
    wMagicShieldLevel: Word;//��ħ�ȼ�
    wUnParalysisRate: Byte;//��Կ���
    wParalysisAddRate: Byte;//���ǿ��(���磺����)
    wPhysicalLevel: Word;//ǿ��ȼ�
    wDecTargetNHPoint: Byte;//���˵ȼ�
    wCritLevel: Byte;//�����ȼ�
    wIncDragonRate: Word;//�ϻ�����
    //��ʱ��������������
    wExpRate: Word;//���鱶��
  end;

  TClientHeartAbility = record//�ķ��ṹ
      {
    boTpye: Boolean;//�ķ����� F-�����ķ� T-�����ķ�
    sUpLevelSKillName: String[16];//��ѧ��ǿ������
    nHeartTpye: Byte;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
    wUpPower: Word;//��һ�� ��������(�����ķ�)  ������(�����ķ�)
    wUpMaxPower: Word;//��һ�� ��������(�����ķ�) ħ������(�����ķ�)
    wPower: Word;//��������
    wMaxPower: Word;//��������
    wUpPassHeartLevel: Byte;//��һ�������ķ�ʦ���ķ��ȼ�
    wUpLevel: Word;//��һ�������ķ��Լ��ȼ�����
    }
    boHeartTpye: Boolean;//�ķ����� F-�����ķ� T-�����ķ�
    sUpLevelSKillName: String[16];//��ѧ��ǿ������
    nHeartTpye: Byte;//�ķ����� 0-�Ͻ� 1-��ľ 2-��� 3-��ˮ 4-����
    wUpDefence: Word;//��һ�� ��������(�����ķ�)  ������(�����ķ�)
    wUpMaxDefence: Word;//��һ�� ��������(�����ķ�) ħ������(�����ķ�)
    wMainPower: Word;//��������
    wMainMaxPower: Word;//��������
    wUpPassHeartLevel: Byte;//��һ�������ķ�ʦ���ķ��ȼ�
    wUpLevel: Word;//��һ�������ķ��Լ��ȼ�����
  end;
{$IFEND}

  TWAbility = record
    dwExp: LongWord; //���ﾭ��ֵ(Dword)
    wHP: Word;
    wMP: Word;
    wMaxHP: Word;
    wMaxMP: Word
  end;

  TMerchantInfo = record
    sScript: string[14];
    sMapName: string[14];
    nX: Integer;
    nY: Integer;
    sNPCName: string[40];
    nFace: Integer;
    nBody: Integer;
    boCastle: Boolean;
  end;
  pTMerchantInfo = ^TMerchantInfo;

  TSocketBuff = record
    Buffer: PChar; //0x24
    nLen: Integer; //0x28
  end;
  pTSocketBuff = ^TSocketBuff;

  TSendBuff = record
    nLen: Integer;
    Buffer: array[0..DATA_BUFSIZE - 1] of Char;
  end;
  pTSendBuff = ^TSendBuff;
 {$IF M2Version <> 2}
  TClientDominatPoint = record
    nIdx: Byte;//λ��ID
    m_sMapDesc: string[MAPNAMELEN];//��ͼ����
  end;
  TDominatSendPoint = record //������ͽṹ
    nIdx: Byte;//λ��ID
    m_sMapDesc: string[MAPNAMELEN];//��ͼ����
    m_sMapName: string[MAPNAMELEN];//��ͼID
    m_nCurrX: Integer; //����X(4�ֽ�)
    m_nCurrY: Integer; //����Y(4�ֽ�)
  end;
  pTDominatSendPoint = ^TDominatSendPoint;

  TClientHumName = record//����ʹ�߻��������ƽṹ
    sChrName: string[ACTORNAMELEN];//����
    boOnline: Boolean;//�Ƿ�����
  end;
  pTClientHumName = ^TClientHumName;

  TClientHumTitle = packed record//�ͻ��˳ƺŽṹ
    MakeIndex: Integer;//�ƺ�����ID
    StdMode: Byte; //����
    AniCount: Word;//��ЧID
    Looks: Word;//�ƺ�ͼƬ
    nHours: Word;//ʣ��Сʱ
    sTitleName: String[ACTORNAMELEN];//�ƺ���
    wDura: Word;//ǧ�ﴫ������(ˮ��֮�ǣ����豣��)
    wDC: Word;//��������
    wMC: Word;//ħ������
    wSC: Word;//��������  
    wHP: Word;//��������
  end;

  TClientHumTitles = packed record//���Ϳͻ��˳ƺŽṹ
    nUseTitleIndex: Byte;//ʹ�óƺ�����
    ClientHumTitles: array[0..7] of TClientHumTitle;//�ƺ�����
  end;

//���ݿ�ṹ
  THumTitleDB = packed record//�ƺŽṹ
    Idx: Integer;
    sTitleName: String[ACTORNAMELEN];//�ƺ�
    StdMode: Byte; //����
    Shape: Byte;//װ�����    
    AniCount: Word;
    nHours: Word; //ʹ����
    Looks: Word; //��ۣ���WIL�е�ͼƬ����
    DuraMax: Word; //���־�(ǧ�ﴫ��)
    AC: Integer; //AC1 - AC2 
    MAC: Integer; //Mac1 - Mac2
    DC: Integer; //����
    MC: Integer; //ħ��
    SC: Integer; //����
    Need: Integer;//��Ҫ����
    NeedLevel: Integer;//����ֵ
    Stock: Integer;//����
  end;
  pTHumTitleDB = ^THumTitleDB;

  TClientDivisionInfo = record//��ѯ�������ݽṹ
    sDivisionName: string[14];//��������
    sChrName: string[ACTORNAMELEN];//ʦ����
    nPopularity: Integer;//����ֵ
    nStatus: Byte;//״̬(0-��ʾ"�������" 1-��ʾ"ȡ������" 2-����ʾ"�������","ȡ������")
  end;
  pTClientDivisionInfo = ^TClientDivisionInfo;
{$IFEND}
  TDivisionMember = packed record//ʦ�ų�Ա����
    btGender: Byte; //�Ա�
    btJob: Byte; //ְҵ 0-ս 1-�� 2-�� 3-�̿�
    nLevel: Word; //�ȼ�
    nContribution: LongWord;//����ֵ
    dLogonTime: TDateTime; //��¼ʱ��
    boStatus: Boolean;//״̬(���ߡ�����)
  end;
  pTDivisionMember = ^TDivisionMember;

  TClientDivisionMember = record
    sChrName: string[ACTORNAMELEN];//����
    DivisionMember: TDivisionMember;
  end;  
  pTClientDivisionMember = ^TClientDivisionMember;
  
  TApplyDivision = record//������ʦ�Žṹ 20110731
    sChrName: string[ACTORNAMELEN];//����
    btGender: Byte;//�Ա�
    btJob: Byte;//ְҵ
    nLevel: Word;//�ȼ�
  end;
  pTApplyDivision = ^TApplyDivision;  

  THumTitle = packed record//����ƺŽṹ 20110130
    ApplyDate: TDateTime;//����ʱ��
    MakeIndex: Integer;//�ƺ�����ID
    wIndex: Word; //�ƺ�����id
    boUseTitle: Boolean;//ʹ�ô˳ƺ�
    wDura: Word;//ǧ�ﴫ������(ˮ��֮��)
    wMaxDura: Word;
    sChrName: string[ACTORNAMELEN];//������(��������������ʹ��)
  end;
  pTHumTitle = ^THumTitle;

  TUserItem = packed record //20110130 ��չ
    MakeIndex: Integer;//����ID
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    //���õ�װ���������� 0:AC 1:MAC 2: DC 3:MC 4:SC:
    btValue: array[0..20] of Byte;    //��������:8-����װ�� 9-(��������)װ���ȼ� 12-����(1Ϊ����,0������,2�����鲻�ܾۼ� ����,�·�,ͷ����Ч),13-�Զ�������,14-��ֹ�ӡ����ס��ޡ������� 15-,16-,17-,18-,19- 20-����(������,1-��ʼ�۾���,2-�۽���) 11-�����౩���ȼ� 10-������������(1-���� 10-12����DC, 20-22����MC��30-32����SC)
    //btUnKnowValue: array[0..9] of Byte; //0-�Ƿ�ɼ���(1-�ɼ��� 2-һ�� 3-���� 4-����)
                                        //1-���ڶ�����������(0-�� 1-1������ 2-2������ 3-3������ 4-4������)
                                        //δ֪����(����ʹ��)
    btAppraisalLevel : Byte;//0-�Ƿ�ɼ���(1-�ɼ��� 2-һ�� 3-���� 4-����)
    btUnKnowValueCount : Byte;
    btAppraisalValue :array[2..5] of Byte;
    //6..9
    btUnKnowValue: array[6..9] of Byte;

                                        //1-���ڶ�����������(0-�� 1-1������ 2-2������ 3-3������ 4-4������)
                                        //δ֪����(����ʹ��)
    AddValue: array[0..2] of Byte;//0-1��ʱ��Ʒ 2����(�����ں��ʹ��,���ڲ��ɽ���,����) 3���ð�(�Լ���ʹ��,���ɽ���,���󲻿ɼ���)
                                  //2-��ʱ����btValue14-19��ʵ 20110528
    MaxDate: TDateTime;//���ʹ������ ��AddValue[0]��1ʱ����ʱ��ɾ����Ʒ����ʱ��Ʒ  20110130 ��չ
  end ;
  {TUserItem = record // 20100803 ��չ  Size 44
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: array[0..20] of Byte;//��������:8-����װ�� 9-(��������)װ���ȼ� 12-����(1Ϊ����,0������,2�����鲻�ܾۼ� ����,�·�,ͷ����Ч),13-�Զ�������,14-��ֹ��,15-��ֹ����,16-��ֹ��,17-��ֹ��,18-��ֹ����,19-��ֹ���� 20-����(������,1-��ʼ�۾���,2-�۽���) 11-�����౩���ȼ� 10-������������(1-���� 10-12����DC, 20-22����MC��30-32����SC)
    btUnKnowValue: array[0..9] of Byte;//0-�Ƿ�ɼ���(1-�ɼ��� 2-һ�� 3-���� 4-����) 1-���ڶ�����������(0-�� 1-1������ 2-2������ 3-3������ 4-4������) δ֪����(����ʹ��)
  end ;}
  pTUserItem = ^TUserItem;   
 //(��ָ)          0 AC2 ����  1 MAC2 ħ�� 2 DC2 ���� 3 MC2 ħ�� 4 SC2 ���� 6 ������� 7 ������� 8-����װ�� 11-��ý����ֵ 9-10 12-13 �ݲ�֪�� 14 �־�
 //(����)          0 DC2 1 MC2 2 SC2 3 ���� 4 ���� 5 ׼ȷ 6 �����ٶ� 7 ǿ�� 8-����װ�� 9-(��������)װ���ȼ� 10-�迪��,������������(1-���� 10-12����DC, 20-22����MC��30-32����SC) 11-�����౩���ȼ� 12-��ý����ֵ 13-�ݲ�֪�� 14 �־� 20-�������ı����ȼ� 
 //(�·�,ѥ��,����)0 ���� 1 ħ�� 2 ���� 3 ħ�� 4 ����  11-��ý����ֵ 5-10 12-13 ��Ч�� 14 �־�
 //(ͷ��)          0 ���� 1 ħ�� 2 ���� 3 ħ�� 4 ���� 5 ������� 6 ������� 7  8-����װ��  11-��ý����ֵ 9-10 12-13 ��Ч�� 14 �־�
 //(����,����)     0 AC2 1 MAC2 2 DC2 3 MC2 4 SC2 6 ������� 7 ������� 8 Reserved  11-��ý����ֵ 9-10 12-13 �ݲ�֪�� 14 �־�
 //��              0 Ʒ�� 1 �ƾ��� 2 ҩ��ֵ 3�Ƶȼ�
 //��Ʋ���        0 Ʒ��
 //���ؾ���        0 �ȼ� �־�=������
 //��ħ��ý        11-��ý����ֵ
{btUnKnowValue
0-�Ƿ�ɼ���
����  1���ɼ��� 2��һ�� 3-����  4-����
1��: 11-�ɼ��� 12-һ�� 13-���� 14-����
2��: 21-�ɼ��� 22-һ�� 23-���� 24-����
3��: 31-�ɼ��� 32-һ�� 33-���� 34-����
4��: 41-�ɼ��� 42-һ�� 43-���� 44-����
5��: 51-�ɼ��� 52-һ�� 53-���� 54-����

1-���ڶ�����������(0-�� 1-1������ 2-2������ 3-3������ 4-4������  �ٸ��ݺ��ĸ�����λ��ֵ�ж��Ƿ���)
2..5 ��������
6..9 ��������

1..10    ��������(1-�������� 2-���Ի����� 3-��Լ��� 4-ħ����Լ��� 5-ս����Լ��� 6-̽�⼼�� 7-���ͼ���)
11..20   ��������
21..30   ħ������
31..40   ��������
41..50   ħ������(ħ����������)
51..60   �������(�����������)
61..70   ������
71..80   �����ָ�(ͬ���飬��ţ)
81..90   ��ħ�ȼ�(������ְҵ��ͬ�ӵ�ħ������Ӧ���ǲ�ͬ)
91..100  ǿ��ȼ�(��Ѫ��ְҵ��ͬ�ӵ�Ѫ����ͬ ս+50 ��+20 ��+35)
101..110 ��Ѫ����(�뻢��װ������ͬ)
111..120 ���˵ȼ�
121..130 �����ȼ�(�������ʯ�ı�������)
131..140 ����
141..150 ׼ȷ
151..160 ����
161..180 ��Կ���(1..20)
181..230 �ϻ�����(1..50) (ͬ��ţ�ĺϻ��˺�)
231..250 ������ý Ʒ��(11.4 * ֵ ����228) ��ǰ����ֵ��btValue[11]���棬������btValue[12]
251..254 Ԥ��
255      ��������δ���}

  TMonItemInfo = record //���ﱬ��Ʒ��(MonItemsĿ¼��,����.txt)
    SelPoint: Integer;//���ֵ���
    MaxPoint: Integer;//�ܵ���
    ItemName: string;//��Ʒ����
    Count: Integer;//��Ʒ����
    NewMonList: TList;//��ģʽ
  end;
  pTMonItemInfo = ^TMonItemInfo;

  TMapItem = record //��ͼ��Ʒ
    Name: string[30];//����
    Looks: Word; //���
    AniCount: Byte;//StdItem.AniCount
    Reserved: Byte;//�˲���������ʲô��
    Count: Integer;//����
    OfBaseObject: TObject;//��Ʒ˭���Լ���
    DropBaseObject: TObject;//˭�����
    dwCanPickUpTick: LongWord;
    UserItem: TUserItem;
  end;
  PTMapItem = ^TMapItem;

  TVisibleMapItem = record //�ɼ��ĵ�ͼ��Ʒ
    MapItem: PTMapItem;
    nVisibleFlag: Byte;//0-����(���ɼ�) 1-������� 2-�跢��Ϣ����
    nX: Integer;
    nY: Integer;
    sName: string;
    wLooks: Word;
  end;
  pTVisibleMapItem = ^TVisibleMapItem;

  TVisibleBaseObject = record
    BaseObject: TObject;
    nVisibleFlag: Byte;//0-��� 1-������ 2-����
  end;
  pTVisibleBaseObject = ^TVisibleBaseObject;

  THumanRcd = record
    sUserID: string[10];
    sCharName: string[14];
    btJob: Byte;
    btGender: Byte;
    btLevel: Byte;
    btHair: Byte;
    sMapName: string[16];
    btAttackMode: Byte;
    btIsAdmin: Byte;
    nX: Integer;
    nY: Integer;
    nGold: Integer;
    dwExp: LongWord;
  end;
  pTHumanRcd = ^THumanRcd;

  TObjectFeature = record
    btGender: Byte;
    btWear: Byte;
    btHair: Byte;
    btWeapon: Byte;
  end;
  pTObjectFeature = ^TObjectFeature;

  TStatusInfo = record
    nStatus: Integer;
    dwStatusTime: LongWord;
    sm218: SmallInt;
    dwTime220: LongWord;
  end;

  TMsgHeader = record
    dwCode: LongWord;
    nSocket: Integer;
    wGSocketIdx: Word;
    wIdent: Word;
    wUserListIndex: Integer;
    nLength: Integer;
  end;
  pTMsgHeader = ^TMsgHeader;

  TUserInfo = record
    bo00: Boolean; //0x00
    bo01: Boolean; //0x01 ?
    bo02: Boolean; //0x02 ?
    bo03: Boolean; //0x03 ?
    n04: Integer; //0x0A ?
    n08: Integer; //0x0B ?
    bo0C: Boolean; //0x0C ?
    bo0D: Boolean; //0x0D
    bo0E: Boolean; //0x0E ?
    bo0F: Boolean; //0x0F ?
    n10: Integer; //0x10 ?
    n14: Integer; //0x14 ?
    n18: Integer; //0x18 ?
    sStr: string[20]; //0x1C
    nSocket: Integer; //0x34
    nGateIndex: Integer; //0x38
    n3C: Integer; //0x3C
    n40: Integer; //0x40 ?
    n44: Integer; //0x44
    List48: TList; //0x48
    Cert: TObject; //0x4C
    dwTime50: LongWord; //0x50
    bo54: Boolean; //0x54
  end;
  pTUserInfo = ^TUserInfo;

  TGlobaSessionInfo = record
    sAccount: string;//��¼�˺�
    sIPaddr: string;//IP��ַ
    sSelChrName : string;
    nSessionID: Integer;//�ỰID
    n24: Integer;
    bo28: Boolean;
    boLoadRcd: Boolean;//�Ƿ��ȡ
    boStartPlay: Boolean;//�Ƿ�ʼ��Ϸ
    dwAddTick: LongWord;//�����б��ʱ��
    dAddDate: TDateTime;//�����б������
  end;
  pTGlobaSessionInfo = ^TGlobaSessionInfo;

  TSellOffHeader = record
    nItemCount: Integer;
  end;
//------------------------------------------------------------------------------
  TBoxsInfo = record //�������ݽṹ 20090225 �޸�
    sBoxsID: Integer;//�����ļ�ID
    nItemNum: LongWord;//��Ʒ����
    nItemType: Byte;//��Ʒ����(0-��ͨ��Ʒ 1-�����Ʒ 2-�м����Ʒ)
    nItemRace: Word;//����
    StdItem: TClientItem;//20110919
  end;
  pTBoxsInfo = ^TBoxsInfo;
//------------------------------------------------------------------------------
  TSuitItem = packed record //��װ���ݽṹ  20080225
    ItemCount: Byte; //��װ��Ʒ����
    Note: String[30];//˵��
    Name: String;//��Ʒ����
    MaxHP: DWord;//HP����
    MaxMP: DWord;//MP����
    DC: Word;//������
    MaxDC: Word;
    MC: Word;//ħ��
    MaxMC: Word;
    SC: Word;//����
    MaxSC: Word;
    AC: Integer; //����
    MaxAC: Integer;
    MAC: Word; //ħ��
    MaxMAC: Word;
    HitPoint: Byte;//׼ȷ��
    SpeedPoint: Byte;//���ݶ�
    HealthRecover: ShortInt; //�����ָ�
    SpellRecover: ShortInt; //ħ���ָ�
    RiskRate: Integer; //����ֵ
    btReserved: Byte; //��Ѫ(����)
    btReserved1: Byte; //������ֵ
    btReserved2: Byte; //����
    btReserved3: Byte; //����
    nEXPRATE: Integer;//���鱶��
    nPowerRate: Byte;//��������
    nMagicRate: Byte;//ħ������
    nSCRate: Byte;//��������
    nACRate: Byte;//��������
    nMACRate: Byte;//ħ������
    nAntiMagic: ShortInt; //ħ�����
    nAntiPoison: Byte; //������
    nPoisonRecover: ShortInt; //�ж��ָ�
    boNewHPMPAdd : Boolean;//����HPMP
    boTeleport : Boolean;//����  20080824
    boParalysis : Boolean;//���
    boRevival : Boolean;//����
    boMagicShield : Boolean;//����
    boUnParalysis : Boolean;//�����
    nIncDragonRate: Byte;//�ϻ��˺�����(����) 20090330
    nIncNHRate: Byte;//�����ָ�%(����) 20090330
    boUnRevival : Boolean;//������
    boUnMagicShield : Boolean;//������
    nUnBurstRate: Byte;//������
    nVampirePoint: Byte;//��Ѫ����(����װ��)
    nCallTrollLevel: Byte;//�ٻ���ħ�ȼ�(������װ)
    nJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-����ְҵ
    nIncDragon: Word;//�ϻ��˺�����(����)
    nMasterAbility: Byte;//������
    boParalysis1 : Boolean;//ս�����
    boParalysis2 : Boolean;//ħ�����
    boParalysis3 : Boolean;//ħ�����
  end;
  pTSuitItem = ^TSuitItem;

  TClientSuitAbility = record//�ͻ�����װ����ֵ 20110711
    nMasterAbility: Byte;//������
    nIncDragon: Word;//�ϻ��˺�����

    nShangHaiXiShou:Integer; // ������������Ū���
    nGongJiSuDu:Integer;     // �����ٶ�
    nGongJiXiXue:Integer;
    nQiangShenDengJi:Integer;
    nJuMoDengJi:Integer;
    nBaoJiDengJi:Integer;
    nNeiShangDengJi:Integer;
    nHeJiWeiLi:Integer;
    nBingDongKangXing:Integer;
  end;

//------------------------------------------------------------------------------
  TDealOffInfo = packed record //   Ԫ���������ݽṹ  20080316
    sDealCharName: string[ACTORNAMELEN];//������ *
    sBuyCharName: string[ACTORNAMELEN];//������
    dSellDateTime: TDateTime;//����ʱ��
    nSellGold: Integer;//���׵�Ԫ����
    UseItems: array[0..9] of TUserItem;//��Ʒ
    N: Byte;//����ʶ�� 0-���� 1-����,��������δ�õ�Ԫ�� 2-���׽���(�õ�Ԫ��) 3-������ȡ�� 4-���ڲ�����
  end;
  pTDealOffInfo = ^TDealOffInfo;

  TClientDealOffInfo = packed record //�ͻ���Ԫ���������ݽṹ  20080317
    sDealCharName: string[ACTORNAMELEN];//������
    sBuyCharName: string[ACTORNAMELEN];//������
    dSellDateTime: TDateTime;//����ʱ��
    nSellGold: Integer;//���׵�Ԫ����
    UseItems: array[0..9] of TClientItem;//��Ʒ //20110919
    N: Byte;//����ʶ��
  end;
  pTClientDealOffInfo = ^TClientDealOffInfo;
//------------------------------------------------------------------------------
  TAttribute = record //������Ʒ����
    nPoints: Byte;//�������������
    nDifficult: Byte;//�����Ѷ�
  end;


  TRefineItemInfo = packed record //Size 36 �������ݽṹ  20080502
    sItemName: string;//��Ʒ����
    nRefineRate: Byte;//�����ɹ���
    nReductionRate: Byte;//ʧ�ܻ�ԭ��
    boDisappear: Boolean;//����ʯ�Ƿ���ʧ 0-����1�־�,1-��ʧ
    nNeedRate: Byte;//��Ʒ����
    nAttribute: array[0..13] of TAttribute;//������Ʒ����
  end;
  pTRefineItemInfo = ^TRefineItemInfo;

  TRefineDrumItemInfo = packed record // Size 36 ��������(ͬʱ���Դ���������Ʒ)���ݽṹ  20080502
    GiveName:string; // �ϳɵ���Ʒ����
    MainItemName: string;// ����������
    ItemNamesCount:Integer;
    ItemNames:array[0..5] of String;  // ������Ʒ����

    sPriceCount:Integer;
    sPriceType:array[0..5] of Char;  // ��ҪԪ��������ȵ�
    nPriceCounts:array[0..5] of Integer;  // ��Ҫ������

    SuccessRate: Byte;  //�����ɹ���
    FailRate:Byte;      //ʧ�ܵ�ʱ����Ʒ��ʧ�ļ���
    boInherit: Boolean; //�Ƿ�̳������ϵļ�������  By TasNat at: 2012-04-19 22:47:37
  end;
  pTRefineDrumItemInfo = ^TRefineDrumItemInfo;
//------------------------------------------------------------------------------
  TSellOffInfo = packed record //Size 59    �������ݽṹ
    sCharName: string[ACTORNAMELEN];//������
    dSellDateTime: TDateTime;//����ʱ��
    nSellGold: Integer;//���
    N: Integer;
    UseItems: TUserItem;//��Ʒ
    n1: Integer;
  end;
  pTSellOffInfo = ^TSellOffInfo;

  TItemCount = Integer;//��Ʒ����

  TBigStorage = packed record //���޲ֿ����ݽṹ
    boDelete: Boolean;
    sCharName: string[ACTORNAMELEN];
    SaveDateTime: TDateTime;
    UseItems: TUserItem;
    nCount: Integer;
  end;
  pTBigStorage = ^TBigStorage;

  TBindItem = record //�����Ʒ��
    sUnbindItemName: string[ACTORNAMELEN];//�����Ʒ����
    nStdMode: Integer;//��Ʒ����
    nShape: Integer;//װ�����
    btItemType: Byte;//����
  end;
  pTBindItem = ^TBindItem;

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

  TOUserStateInfo = packed record //OK
    feature: {Integer}TFeatures;
    UserName: string[15]; // 15
    GuildName: string[14]; //14
    GuildRankName: string[16]; //15
    NAMECOLOR: Word;
    UseItems: array[0..8] of TOClientItem;
  end;

  TIDRecordHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    UpdateDate: TDateTime;
    sAccount: string[11];
  end;

  TRecordHeader = packed record //Size 28
    boDeleted: Boolean; //�Ƿ�ɾ��
    nSelectID: Byte;   //ID
    boIsHero: Boolean; //�Ƿ�Ӣ��
    bt2: Byte;
    dCreateDate: TDateTime; //����¼ʱ��
    sName: string[15]; //��ɫ����   28
  end;
  pTRecordHeader = ^TRecordHeader;

  TUseItemNames = array[0..14] of string[16];
  pTUseItemNames = ^TUseItemNames;//���˴���Ʒ��ʹ��

  THumanUseItems = array[0..14] of TUserItem;//��չ֧�ֶ��� 20080416

  THumTitles = array[0..7] of THumTitle;//����ƺ� 20110130
  TUnKnow1 = array[0..5] of Word;//Ԥ��6��Word���� 20110130

  TUnKnow = array[0..44] of Byte;//20100803
  TQuestFlag = array[0..127] of Byte;
  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;

  THumItems = array[0..8] of TUserItem;//9��װ��
  THumAddItems = array[9..14] of TUserItem;//����4��װ�� ��չ֧�ֶ��� 20080416
  TBagItems = array[0..45] of TUserItem;//������Ʒ
  TStorageItems = array[0..45] of TUserItem;
  THumMagics = array[0..{29}34] of THumMagic;//���＼�� 20110812 ��չ********
  THumNGMagics = array[0..29] of THumNGMagic;//�ڹ�����
  THumanPulseInfo = array[0..4] of TPulseInfo;//������Ѩ 0-3����,����,��ά,���� 4�澭
  THeroPulseInfo1 = array[0..4] of THeroPulseInfo;//Ӣ����Ѩ
  PTPLAYUSEITEMS = ^THumanUseItems;

  pTHumItems = ^THumItems;
  pTBagItems = ^TBagItems;
  pTStorageItems = ^TStorageItems;
  pTHumAddItems = ^THumAddItems;
  pTHumMagics = ^THumMagics;
  pTHumNGMagics = ^THumNGMagics;//�ڹ�����

  pTHumData = ^THumData;
  THumData = packed record //(�ƺ�ϵͳ)���ݽṹ 20110130
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
    btHeroType: Byte;//Ӣ������ 0-������Ӣ�� 1-����Ӣ�� 2-����Ӣ�� 3-����Ӣ��
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
                    //7-�ڹ��ȼ�(1)
                    //8-ʹ����Ʒ�ı�˵������ɫ
                    //9..16��������
                    //17..20�������ӵ���������
                    //21�Ƿ�ѧ����������
                    //22..24����������(0-������ 1-��ʾ"?")
                    //25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ��
                    //26-�Ƿ�ѧ���������
                    //27-����Ӣ���Ƿ��Զ�����(����)
                    //28-���ĸ�����������(0-������ 1-��ʾ"?")
                    //29-���������Ƿ����
                    //30-����ֵ(�������ؾ���)
                    //31-����ֵ
                    //32-�澭(0-δѧϰ 1-��� 2-�м� 3-���� 4-�˷� 5-ӿȪ)
                    //33-�ڹ��ȼ�(2)
                    //34-��������(�ƺ�ʹ��)
                    //35-�Ƿ�ͻ��99����ת
                    //36-�����ķ�����
                    //37-�������ʣ��ʱ��By TasNat at: 2012-04-23 18:49:20
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
(*  THumData = packed record {���������� Size = 5757 Ԥ��N������ 20100804}
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
    UnKnow: TUnKnow;//0-3���ʹ�� 4-����ʱ�Ķ��� 5-ħ���ܵȼ� 6-�Ƿ�ѧ���ڹ�
                    //7-�ڹ��ȼ�(1) 8-ʹ����Ʒ�ı�˵������ɫ  9..16�������� 17..20�������ӵ���������
                    //21�Ƿ�ѧ���������� 22..24����������(0-������ 1-��ʾ"?") 25-Ӣ�ۿ�ͨ����(Ӣ��) (����)�Ⱦ�ʱ��
                    //26-�Ƿ�ѧ��������� 27-����Ӣ���Ƿ��Զ�����(����) 28-���ĸ�����������(0-������ 1-��ʾ"?")
                    //29-���������Ƿ���� 30-����ֵ(�������ؾ���) 31-����ֵ 32-�澭(0-δѧϰ 1-��� 2-�м� 3-���� 4-�˷� 5-ӿȪ)
                    //33-�ڹ��ȼ�(2)
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
    Proficiency: Word;//������(�������ؾ���)
    Reserved2: Word;//��������(����) 20101025
    Reserved3: Word;//��ǰ��Ԫֵ(����)
    Reserved4: Word;//��ǰ��תֵ
    Exp68: LongWord;//�����ʼ��Ԫֵ������
    Reserved5: LongWord;//Ԥ������5
    Reserved6: LongWord;//Ԥ������6
    Reserved7: LongWord;//Ԥ������7
    Reserved8: Byte;//Ԥ������8
    SpiritMedia: TUserItem;//��ýװ��λ
  end;  *)
  
  //��BUFFERSIZE = 10000;ʱ,THumDataInfo���Ϊ7498,������Ӱ�����ݱ���,�޷����� 20110131
  THumDataInfo = packed record //Size 6940(20110130) 7124(20110812)
    Header: TRecordHeader;
    Data: THumData;
  end;
  pTHumDataInfo = ^THumDataInfo;
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
  pTNewHeroData = ^TNewHeroData;

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
//--------------------HumHero.dbʹ�ýṹ(�ƺ�ϵͳע��)----------------------------------------
{  TNewHeroName = record //����Ӣ������
    sChrName: string[ACTORNAMELEN];//��������
    sNewHeroName: string[ACTORNAMELEN];//��������
  end;
  pTNewHeroName = ^TNewHeroName;

  THeroNameInfo = packed record
    Header: TNewHeroDataHeader;
    Data: TNewHeroName;
  end;
  pTHeroNameInfo = ^THeroNameInfo;   }
//------------------------------------------------------------------------------
  THeroDataInfo = packed record //��ѯӢ������(�ƹ�)
    sChrName: string[ACTORNAMELEN];//����
    Level: Word; //�ȼ�
    btSex: Byte; //�Ա�
    btJob: Byte;//ְҵ 0-ս 1-�� 2-�� 3-�̿�
    btType: Byte;//Ӣ������ 0-������Ӣ�� 1-����Ӣ��
  end;
  pTHeroDataInfo = ^THeroDataInfo;

  TSaveRcd = record
    sAccount: string[12];//�˺�
    sChrName: string[ACTORNAMELEN];//����
    nSessionID: Integer;//�ỰID
    nReTryCount: Integer;//����ʧ�ܼ���
    dwSaveTick: LongWord;//��������´α���TICK
    PlayObject: TObject;
    HumanRcd: THumDataInfo;//���ݰ�
    boIsNewHero: Boolean;//�Ƿ񸱽�
    NewHeroDataInfo: TNewHeroDataInfo;//��������
    boIsHero: Boolean;//�Ƿ�Ӣ��
    boSaveing: Boolean;//���ڱ�����
  end;
  pTSaveRcd = ^TSaveRcd;

  TLoadDBInfo = record
    sAccount: string[12];//�˺�
    sCharName: string[ACTORNAMELEN];//��ɫ����
    sIPaddr: string[15];//IP��ַ
    dwHCode: DWord; // Ӳ����
    sMsg: string;
    nSessionID: Integer;//�ỰID
    nSoftVersionDate: Integer;//�ͻ��˰汾��
    nPayMent: Integer;
    nPayMode: Integer;//���ģʽ 
    nSocket: Integer;//�˿�
    nGSocketIdx: Integer;
    nGateIdx: Integer;
    boClinetFlag: Boolean;
    dwNewUserTick: LongWord;
    PlayObject: TObject;
    nReLoadCount: Integer;//��ȡ�������
    boIsHero: Boolean;//�Ƿ�Ӣ��
    btLoadDBType: Byte;//��ȡ���� 0-�ٻ�Ӣ�� 1-�½�Ӣ�� 2-ɾ��Ӣ�� 3-��ѯ����(ȡ��Ӣ��) 4-����Ӣ��ȡ����
    M2isCreate: Boolean;//20090318 �Ƿ�M2ֱ�Ӵ���
    wRandomKey: Word;//�����Կ 20091026
    boIsNewHero: boolean;//�Ƿ񸱽�
    nJob: Byte;//����ְҵ 0-ս 1-�� 2-�� 3-�̿�    
  end;
  pTLoadDBInfo = ^TLoadDBInfo;

  TUserOpenInfo = record
    sAccount: string[12];
    sChrName: string[ACTORNAMELEN];
    LoadUser: TLoadDBInfo;
    HumanRcd: THumDataInfo;
    nOpenStatus: Integer;
    NewHeroDataInfo: TNewHeroDataInfo;//��������
  end;
  pTUserOpenInfo = ^TUserOpenInfo;

  TLoadUser = record
    sAccount: string[12];
    sChrName: string[ACTORNAMELEN];
    sIPaddr: string[15];
    nSessionID: Integer;
    nSocket: Integer;
    nGateIdx: Integer;
    nGSocketIdx: Integer;
    nPayMent: Integer;
    nPayMode: Integer;
    dwNewUserTick: LongWord;
    nSoftVersionDate: Integer;
  end;
  pTLoadUser = ^TLoadUser;

  TUserStateInfo = record
    feature: {Integer}TFeatures;
    UserName: string[ACTORNAMELEN];
    NAMECOLOR: Integer;
    GuildName: string[ACTORNAMELEN];
    GuildRankName: string[16];
    //UseItems: array[0..13] of TClientItem;//20080417 ֧�ֶ���,0..12��0..13
    UseItems: array[0..14] of TClientItem;//20110912 ������Ʒ��Ч
    btJob: Byte;//ְҵ 20110113
    {$IF M2Version <> 2}
    wHumTitles: TClientHumTitles;//�ƺ�
    nCallTrollLevel: Byte;//�ٻ���ħ�ȼ�
    {$IFEND}
    SuitAbility: TClientSuitAbility;//��װ����ֵ 20110711
  end;
  pTUserStateInfo = ^TUserStateInfo;

  TDoorStatus = record
    bo01: Boolean;
    boOpened: Boolean;
    dwOpenTick: LongWord;
    nRefCount: Integer;
    n04: Integer;
  end;
  pTDoorStatus = ^TDoorStatus;

  TDoorInfo = record
    nX: Integer;
    nY: Integer;
    n08: Integer;
    Status: pTDoorStatus;
  end;
  pTDoorInfo = ^TDoorInfo;

  TSlaveInfo = record
    sSalveName: string;
    btSalveLevel: Byte;
    btSlaveExpLevel: Byte;
    dwRoyaltySec: LongWord;
    nKillCount: Integer;
    nHP: Integer;
    nMP: Integer;
  end;
  pTSlaveInfo = ^TSlaveInfo;

  TSwitchDataInfo = record
    sChrName: string[ACTORNAMELEN];
    sMAP: string[MAPNAMELEN];
    wX: Word;
    wY: Word;
    Abil: TAbility;
    nCode: Integer;
    boC70: Boolean;//δʹ��
    boBanShout: Boolean;
    boHearWhisper: Boolean;
    boBanGuildChat: Boolean;
    boAdminMode: Boolean;
    boObMode: Boolean;
    BlockWhisperArr: array[0..5] of string;
    SlaveArr: array[0..10] of TSlaveInfo;
    StatusValue: array[0..5] of Word;
    StatusTimeOut: array[0..5] of LongWord;
  end;
  pTSwitchDataInfo = ^TSwitchDataInfo;

  TGoldChangeInfo = record
    sGameMasterName: string;//��Ϸ�������
    sGetGoldUser: string;
    nGold: Integer;
  end;
  pTGoldChangeInfo = ^TGoldChangeInfo;


  TStartPoint = record //��ȫ���سǵ� ���ӹ⻷Ч��
    m_sMapName: string[MAPNAMELEN];//��ͼ
    m_nCurrX: Integer; //����X(4�ֽ�)
    m_nCurrY: Integer; //����Y(4�ֽ�)
    m_boNotAllowSay: Boolean;//������˵�� δʹ��
    m_nRange: Integer;//��Χ
    m_nType: Integer;//����
  end;
  pTStartPoint = ^TStartPoint;

  TFindRout = record //Ѱ·Ŀ��
    m_sMapName: string[MAPNAMELEN];//��ͼ
    m_nCurrX: Integer; //����X(4�ֽ�)
    m_nCurrY: Integer; //����Y(4�ֽ�)
  end;
  pTFindRout = ^TFindRout;

  //��ͼ�¼������������
  TQuestUnitStatus = record
    nQuestUnit: Integer;
    boOpen: Boolean;
  end;
  pTQuestUnitStatus = ^TQuestUnitStatus;

  TMapCondition = record
    nHumStatus: Integer;//�˵�״̬
    sItemName: string[14*2];//��Ʒ
    boNeedGroup: Boolean;//�Ƿ���Ҫ���
  end;
  pTMapCondition = ^TMapCondition;

  TStartScript = record
    nLable: Integer;
    sLable: string[100];
  end;

  TMapEvent = record
    m_sMapName: string[MAPNAMELEN];//��ͼ
    m_nCurrX: Integer;//X
    m_nCurrY: Integer;//Y
    m_nRange: Integer;//��Χ
    m_MapFlag: TQuestUnitStatus;
    m_nRandomCount: Integer; //����(0 - 999999) 0 �Ļ���Ϊ100% ; ����Խ�󣬻���Խ��
    m_Condition: TMapCondition; //��������
    m_StartScript: TStartScript;
  end;
  pTMapEvent = ^TMapEvent;

  TItemEvent = record
    m_sItemName: string[ACTORNAMELEN];
    m_nMakeIndex: Integer;
    m_sMapName: string[MAPNAMELEN];
    m_nCurrX: Integer;
    m_nCurrY: Integer;
  end;
  pTItemEvent = ^TItemEvent;

  TSendUserData = record
    nSocketIndx: Integer;
    nSocketHandle: Integer;
    sMsg: string;
  end;
  pTSendUserData = ^TSendUserData;

 { TCheckVersion = record
  end;
  pTCheckVersion = ^TCheckVersion;   }//20110220ע��

  TRecordDeletedHeader = packed record
    boDeleted: Boolean;
    bt1: Byte;
    bt2: Byte;
    bt3: Byte;
    CreateDate: TDateTime;
    LastLoginDate: TDateTime;
    n14: Integer;
    nNextDeletedIdx: Integer;
    //    sAccount   :String[11];//0x14
  end;

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
  TUserEntryAdd = packed record
    sQuiz2: string[20];//����2
    sAnswer2: string[12];//��2
    sBirthDay: string[10];//����
    sMobilePhone: string[13];//�ƶ��绰
    sMemo: string[20];//��עһ
    sMemo2: string[20];//��ע��
  end;

  TAccountDBRecord = packed record
    Header: TIDRecordHeader;
    UserEntry: TUserEntry;
    UserEntryAdd: TUserEntryAdd;
    nErrorCount: Integer;
    dwActionTick: LongWord;
    N: array[0..38] of Byte;
  end;

  TMapFlag = record //��ͼ����
    boSAFE: Boolean;//��ȫ��
    boSAFENORUN: Boolean;//��ȫ�����ﲻ�ܴ�
    boSAFEHERONORUN: Boolean;//Ӣ�۰�ȫ�����ܴ� 20090525
    boDARK: Boolean;//����
    boFIGHT: Boolean;
    boFIGHT2: Boolean;//��PK��ͼ������pk������װ�� 20080525
    boFIGHT3: Boolean;
    boFIGHT4: Boolean;//��ս��ͼ 20080706
    boFIGHT5: Boolean;//��ͬ�л����ֱ䲻ͬ��ɫ 20090318
    boNoFIGHT4: Boolean;//��ֹ��ս��ͼ
    boDAY: Boolean;
    boQUIZ: Boolean;
    boNORECONNECT: Boolean;
    boMUSIC: Boolean;
    boEXPRATE: Boolean;
    boCRIT: Boolean;
    nCRIT: Integer;
    
    boPeak: Boolean;//�۷�״̬(��߹�������)
    nPeakMinRate: Integer;//��͹�������
    nPeakMaxRate: Integer;//��߹�������

    boPKWINLEVEL: Boolean;
    boPKWINEXP: Boolean;
    boPKLOSTLEVEL: Boolean;
    boPKLOSTEXP: Boolean;
    boDECHP: Boolean;
    boINCHP: Boolean;
    boDECGAMEGOLD: Boolean;
    boDECGAMEPOINT: Boolean;//�Զ�����Ϸ��
    boINCGAMEGOLD: Boolean;
    boINCGAMEPOINT: Boolean;//�Զ�����Ϸ��
    boNoCALLHERO: Boolean;//��ֹ�ٻ�Ӣ�� 20080124
    
    boNEEDLEVELTIME: Boolean;//ѩ���ͼ����,�жϵȼ�,��ͼʱ�� 20081228
    nNEEDLEVELPOINT: Integer;//��ѩ���ͼ��͵ȼ�
    boMoveToHome: Boolean;//�Ƿ��赹��ʱ���͵�ָ����(ѩ��) 20081230
    sMoveToHomeMap: string;//���͵ĵ�ͼ��
    nMoveToHomeX : Integer;//���͵ĵ�ͼX
    nMoveToHomeY : Integer;//���͵ĵ�ͼY

    boDECEXPRATETIME: Boolean;//��˫������ʱ�� 20090206
    nDECEXPRATETIME: Integer;//ÿ�μ�˫�������ֵ 20090206

    boPULSEXPRATE: Boolean;//��ͼɱ��Ӣ�۾��鱶�� 20091029
    nPULSEXPRATE: Integer;//��ͼɱ��Ӣ�۾��鱶�� 20091029
    boNGEXPRATE: Boolean;//��ͼɱ���ڹ����鱶�� 20091029
    nNGEXPRATE: Integer;//��ͼɱ���ڹ����鱶�� 20091029

    boNOHEROPROTECT: Boolean;//��ֹӢ���ػ� 20080629
    boNODROPITEM: Boolean;//��ֹ��������Ʒ 20080503
    boMISSION: Boolean;//������ʹ���κ���Ʒ�ͼ��� 20080124
    boNOSKILL: Boolean;//������ʹ���κμ���������������Ӣ���ջ�
    boRUNHUMAN: Boolean;
    boRUNMON: Boolean;
    boNEEDHOLE: Boolean;
    boNORECALL: Boolean;
    boNOGUILDRECALL: Boolean;
    boNODEARRECALL: Boolean;
    boNOMASTERRECALL: Boolean;
    boNORANDOMMOVE: Boolean;
    boNODRUG: Boolean;
    boMINE: Boolean;
    boNOPOSITIONMOVE: Boolean;
    boNoManNoMon: Boolean;//����ˢ��,���˲�����ˢ�� 20080525
    boKILLFUNC: Boolean;//��ͼɱ�˴��� 20080415
    nKILLFUNC: Integer;//��ͼɱ�˴��� 20080415 

    nNEEDSETONFlag: Integer;
    nNeedONOFF: Integer;
    nMUSICID: Integer;

    nPKWINLEVEL: Integer;
    nEXPRATE: Integer;
    nPKWINEXP: Integer;
    nPKLOSTLEVEL: Integer;
    nPKLOSTEXP: Integer;
    nDECHPPOINT: Integer;
    nDECHPTIME: Integer;
    nINCHPPOINT: Integer;
    nINCHPTIME: Integer;
    nDECGAMEGOLD: Integer;
    nDECGAMEGOLDTIME: Integer;
    nDECGAMEPOINT: Integer;
    nDECGAMEPOINTTIME: Integer;
    nINCGAMEGOLD: Integer;
    nINCGAMEGOLDTIME: Integer;
    nINCGAMEPOINT: Integer;
    nINCGAMEPOINTTIME: Integer;
    boHitMon: Boolean;//�����ִ��� 20110114
    sHitMonScript: string;
    sReConnectMap: string;
    sMUSICName: string;
    boUnAllowStdItems: Boolean;
    sUnAllowStdItemsText: string;//��ͼ������Ʒ
    boChangMapDrops: Boolean;//����ͼ��ָ����Ʒ
    sChangMapDropsText: string;
    sUnAllowMagicText: string; //������ħ��
    boNOTALLOWUSEMAGIC: Boolean; //������ħ��
    boAutoMakeMonster: Boolean;
    boFIGHTPK: Boolean; //PK���Ա�װ��������
    nThunder:Integer;//���� 20080327
    nLava:Integer;//����ð�ҽ� 20080327
    boSHOP:Boolean;//�����̵��ͼ
    boDigJewel: Boolean;//�ڱ�
    boLimitLevel: Boolean;//����ɫ����ָ���ȼ�1ʱ�����ȼ�2ֵ����HP MP ��ͼ����
    nLimitLevel1: Integer;//ָ���ȼ�1
    nLimitLevel2: Integer;//ָ���ȼ�2
    nLimitLevelHero: Integer;//ָ��Ӣ�۵ȼ�
    nLimitLevelHero1: Integer;//ָ��Ӣ�۵ȼ�
  end;
  pTMapFlag = ^TMapFlag;

  TOrders = record
    sName      : String[ACTORNAMELEN];
    sHeroName  : String[ACTORNAMELEN];
    nLevel     : Integer;
    nExp       : LongWord;
    nMaster    : Integer;
    nHeartLevel: Byte;//�ķ��ȼ� 20111007
  end;
  pTOrders = ^TOrders;

  TUserLevelSort = record //����ȼ�����
    nIndex: Integer;
    wLevel: Word;
    sChrName: string[ACTORNAMELEN];
    nHeartLevel: Byte;//�ķ��ȼ� 20111007
  end;
  pTUserLevelSort = ^TUserLevelSort;

  THeroLevelSort = record //Ӣ�۵ȼ�����
    nIndex: Integer;
    wLevel: Word;
    sChrName: string[ACTORNAMELEN];
    sHeroName: string[ACTORNAMELEN];
  end;
  pTHeroLevelSort = ^THeroLevelSort;

  THumList  = Array[0..MAXORDERSCOUNT-1] of TUserLevelSort;
  THeroList = Array[0..MAXORDERSCOUNT-1] of THeroLevelSort;

  THumSort = record
    nUpDate : TDateTime;
    nMaxIdx : Integer;
    List    : THumList;
  end;
  THeroSort = record
    nUpDate : TDateTime;
    nMaxIdx : Integer;
    List    : THeroList;
  end;

  TCharName = string[ACTORNAMELEN + 1];
  pTCharName = ^TCharName;

  THeroName = string[ACTORNAMELEN * 2 + 2];
  pTHeroName = ^THeroName;
{$IF M2Version <> 2}
  TItemLevelSort = record//��Ʒ����
    nIndex: Word;//����
    wLevel: Word;//����
    sChrName: string[ACTORNAMELEN];//ӵ����
    Item: TClientItem;//��Ʒ����
  end;
  pTItemLevelSort = ^TItemLevelSort;
{$IFEND}  
  TChrMsg = record
    Ident: Integer;
    x: Integer;
    y: Integer;
    dir: Integer;
    State: Integer;
    feature: Integer;
    saying: string;
    sound: Integer;
    NewFeature: TFeatures;
  end;
  pTChrMsg = ^TChrMsg;

 { TRegInfo = record//20110220 ע��
    sKey: string;
    sServerName: string;
    sRegSrvIP: string[15];
    nRegPort: Integer;
  end; }

  TDropItem = record
    x: Integer;
    y: Integer;
    id: Integer;
    Looks: Integer;
    Name: string;
    FlashTime: DWord;
    FlashStepTime: DWord;
    FlashStep: Integer;
    BoFlash: Boolean;
  end;
  pTDropItem = ^TDropItem;

  TUserCharacterInfo = record
    Name: string[19];
    Job: Byte;
    HAIR: Byte;
    Level: Word;
    sex: Byte;
  end;

  TClientGoods = record
    Name: string;
    SubMenu: Integer;
    Price: Integer;
    Stock: Integer;
    Grade: Integer;
  end;
  PTClientGoods = ^TClientGoods;   

  TClientConf = record
    boRUNHUMAN: Boolean;
    boRUNMON: Boolean;
    boRunNpc: Boolean;
    boWarRunAll: Boolean;
    btDieColor: Byte;
    wSpellTime: Word;
    wHitIime: Word;
    wItemFlashTime: Word;
    btItemSpeed: Byte;//װ������
    boParalyCanRun: Boolean;//�������
    boParalyCanWalk: Boolean;//�������
    boParalyCanHit: Boolean;//����ܹ���
    boParalyCanSpell: Boolean;//�����ħ��
    boShowJobLevel: Boolean;
    boDuraAlert: Boolean;
    boSkill31Effect: Boolean;//ħ����Ч�� T-��ɫЧ�� F-ʢ��Ч�� 20080808
    boCanShop: Boolean;//�������� 20100630
    boShopUseGold: Boolean;//����ʹ�ý�ҽ��� 20100630
    boUsePlayShop: Boolean;//�Ƿ񿪷Ÿ����̵� 20100706
    boNoUseProtection: Boolean;//�ڹҽ������屣��
    boNoUseHeroProtection: Boolean;//�ڹҽ���Ӣ�۱���
    boNoCanUseComparThrust: Boolean;//�ڹҸ�λ��ɱ�Ƿ����
    boUseCanDivision: Boolean;//ʦ���Ƿ����
    boShowMoveHP:Boolean;
    {$IF M2Version = 2}
    boShowNewItem:Boolean;//1.76�Ƿ���ʾ�ĸ�By TasNat at: 2012-10-20 10:13:42
    {$ifend}
    {$IF M2Version = 0}
    boUses176StateWin:Boolean;//�ϻ�ʹ����F10����By TasNat at: 2012-10-29 11:07:26
    {$ifend}
    dwMaxLevel : DWord;
  end;

 { pTPowerBlock = ^TPowerBlock;      //20110222 ע��
  TPowerBlock = array[0..100 - 1] of Word; }

  TShowRemoteMessage = record
    btMessageType: Byte;
    boShow: Boolean;
    BeginDateTime: TDateTime;
    EndDateTime: TDateTime;
    dwShowTime: LongWord;
    dwShowTick: LongWord;
    boSuperUserShow: Boolean;
    sMsg: string;
  end;
  pTShowRemoteMessage = ^TShowRemoteMessage;

  TDisallowInfo = record //��ֹ��Ʒ���� 20080418
    boDrop: Boolean; //����
    boDeal: Boolean; //����
    boStorage: Boolean; //���
    boRepair: Boolean;  //����
    boDropHint: Boolean; //������ʾ
    boOpenBoxsHint: Boolean; //������ʾ
    boNoDropItem: Boolean; //��������
    boButchHint: Boolean; //��ȡ��ʾ
    boHeroUse: Boolean; //��ֹӢ��ʹ��
    boPickUpItem: Boolean;//��ֹ����(��GM��)
    boDieDropItems: Boolean;//��������
    boBuyShopItemGive: Boolean;//��ֹ��������
    boButchItem: Boolean;//��ֹ��
    boRefineItem: Boolean;//������ʾ
    boNpcGiveItem: Boolean;//һ��ʱ����ܼ���
    boCanDigJewelHint: Boolean;//�ڱ���ʾ
    bo24HourDisap: Boolean;//24ʱ����ʧ
    boPermanentBind: Boolean;//���ð�
    bo48HourUnBind: Boolean;//��48ʱ
  end;
  pTDisallowInfo = ^TDisallowInfo;

  TCheckItem = packed record
    szItemName: string[14*2];
    boCanDrop: Boolean;
    boCanDeal: Boolean;
    boCanStorage: Boolean;
    boCanRepair: Boolean;
    boCanDropHint: Boolean;
    boCanOpenBoxsHint: Boolean;
    boCanNoDropItem: Boolean;
    boCanButchHint: Boolean;
    boCanHeroUse: Boolean; //��ֹӢ��ʹ��
    boPickUpItem: Boolean;//��ֹ����(��GM��)
    boDieDropItems: Boolean;//��������
    boBuyShopItemGive: Boolean;//��ֹ��������
    boButchItem: Boolean;//��ֹ��
    boRefineItem: Boolean;//������ʾ
    boNpcGiveItem: Boolean;//һ��ʱ����ܼ���
    boCanDigJewelHint: Boolean;//�ڱ���ʾ
    bo24HourDisap: Boolean;//24ʱ����ʧ
    boPermanentBind: Boolean;//���ð�
    bo48HourUnBind: Boolean;//��48ʱ
  end;
  pTCheckItem = ^TCheckItem;
  
  TFilterMsg = record//��Ϣ����
    sFilterMsg: string[100];
    sNewMsg: string[100];
  end;
  pTFilterMsg = ^TFilterMsg;

  TagMapInfo = record //��·��ʯ 20081019
    TagMapName: String[MAPNAMELEN];
    TagX: Integer;
    TagY: Integer;
  end;
  TagMapInfos = array[1..6] of TagMapInfo;//��·��ʯ 20081019

  TClientShopItem = packed record//�����̵�����
    nItemIdx: Integer;//��Ʒ����ID
    nPic: Integer;//�۸�
    boCls : Boolean;//T-Ԫ�� F-���
  end;

  TUserShopItem = record
    Item: Integer;//��Ʒ����ID
    nPic: Integer;//�۸�
    boCls: Boolean;//T-Ԫ�� F-���
  end;
  pTUserShopItem = ^TUserShopItem;

  TShopItem = packed record//�����̵���Ʒ
    Item: TClientItem;//20110919
    nPic: Integer;//�۸�
    boCls: Boolean;//T-Ԫ�� F-���
  end;

  TMapWalkXY = record
    nWalkStep: Integer;//�߲���
    nMonCount: Integer;//������
    nMonRange: Integer;//�ַ�Χ
    nMastrRange: Integer;//���巶Χ
    nX: Integer;
    nY: Integer;
  end;
  pTMapWalkXY = ^TMapWalkXY;
  TWalkStep = array[0..7] of TMapWalkXY;
  pTWalkStep = ^TWalkStep;

  TRunPos = record
    btDirection: Byte; //1˳ʱ�� 2��ʱ��
    nAttackCount: Integer;
  end;
  pTRunPos = ^TRunPos;   

function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): Byte;
function HAIRfeature(cfeature: Integer): Byte;
function DRESSfeature(cfeature: Integer): Byte;
function WEAPONfeature(cfeature: Integer): Byte;
function Horsefeature(cfeature: Integer): Byte;
function Effectfeature(cfeature: Integer): Byte;
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
function aa(const Value,key:Word):Word;
function bb(const Value,key:Word):Word;

function EncodeExp(nExp,nExpMax : Int64) : string;

implementation
uses
  EDcode;

function EncodeExp(nExp,nExpMax : Int64) : string;
var
  ExpData : TExpData;
begin
  ExpData.nMaxExp := nExpMax;
  ExpData.nExp := nExp;
  Result := EncodeBuffer(@ExpData, SizeOf(ExpData));
end;

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
function WEAPONfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(cfeature);
end;
function DRESSfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := HiWord(cfeature);
end;
function HAIRfeature(cfeature: Integer): Byte;
begin
  Result := HiWord(cfeature);
end;

function RACEfeature(cfeature: Integer): Byte;
begin
  Result := cfeature;
end;

function Horsefeature(cfeature: Integer): Byte;
begin
  Result := LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(LoWord(cfeature));
end;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: Byte): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;
function MakeMonsterFeature(btRaceImg, btWeapon: Byte; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;
end.

