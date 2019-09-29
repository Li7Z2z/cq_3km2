unit Common;

interface

type
  //����Ľṹ
  TDLUserInfo = record  //���ظ��ͻ��˵�
    sAccount: string[12];//�˺�
    sUserQQ: string[20]; //QQ
    sName: string[20]; //��ʵ����
    CurYuE: Currency; //�ʻ����
    CurXiaoShouE: Currency; //�ʻ����۶�
    SAddrs: string[50]; //�ϴε�½��ַ
    dTimer: TDateTime; //�ϴε�½ʱ��
    sPrice:Currency;//��½������۸�
    sM2Price:Currency;//M2����۸�(����)
    sM2PriceMonth:Currency;//M2����۸�(����) 20110712
  end;
  pTDLUserInfo = ^TDLUserInfo;
  TUserEntry1 = record   //����û��Ļ���
    sAccount: string[12];//�˺�
    sUserQQ: string[20]; //QQ
    sGameListUrl: string[120];
    sBakGameListUrl: string[120];
    sPatchListUrl: string[120];
    sGameMonListUrl: string[120];
    sGameESystemUrl: string[120];
    sGatePass: string[30];
  end;
  TM2UserEntry = record   //����û��Ļ���
    sAccount: string[12];//�˺�(�û���)
    sUserQQ: string[20]; //QQ
    sGameListUrl: string[80];//��˾
    sBakGameListUrl: string[16];//IP��ַ
    sPatchListUrl: string[42];//Ӳ����Ϣ
    sUserTpye: Byte;//M2ע������ 1-���� 2-����  20110712
    {sGameMonListUrl: string[120];
    sGameESystemUrl: string[120];
    sGatePass: string[30]; }
  end;  
  //���ýṹ
  TUserSession = record
    sAccount: string[12];  //�ʺ�
    sPassword: string[20]; //����
    boLogined: Boolean;
  end;
  //��½������
  TLoginData = record
    sGameListUrl: string[120];
    sBakGameListUrl: string[120];
    sPatchListUrl: string[120];
    sGameMonListUrl: string[120];
    sGameESystemUrl: string[120];
    sGatePass: string[30];
  end;
  //��ͨ�û��Ľṹ
  TUserInfo = record
    sAccount: string[12];//�˺�
    sUserQQ: string[20]; //QQ
    nDayMakeNum: Byte; //�������ɴ���
    nMaxDayMakeNum: Byte; //������ɴ���
    sAddrs: string[50]; //�ϴε�½��ַ
    dTimer: TDateTime; //�ϴε�½ʱ��
    sGateVersionNum: string[20];
    sLoginVersionNum: string[20];
    LoginData: TLoginData; //��½������
  end;
  //��ͨ�û��Ľṹ
  TM2UserInfo = record
    sBakGameListUrl: string[16];//IP��ַ
    sPatchListUrl: string[42];//Ӳ����Ϣ
    sGameListUrl: string[80];//��˾  
    sAccount: string[12];//�˺�
    sUserQQ: string[20]; //QQ
    nDayMakeNum: Byte; //�������ɴ���
    nMaxDayMakeNum: Byte; //������ɴ���
    sAddrs: string[50]; //�ϴε�½��ַ
    dTimer: TDateTime; //�ϴε�½ʱ��
    nUpType: Byte;//�޸���Ϣ������(���޸�IP�������޸�Ӳ��) 0-���߶����޸� 1-ֻ���޸�IP 2-ֻ���޸�Ӳ�� 3-�����û������޸�
    nUpDataNum: Byte;//�޸Ĺ���Ӳ����Ϣ����
  end;  
const
///////////////////////////��Ȩ���/////////////////////////////////////////////
  //�������
  GM_LOGIN = 118;
  SM_LOGIN_SUCCESS = 119;
  SM_LOGIN_FAIL = 120;

  GM_GETUSER = 121;          //����û����Ƿ����
  SM_GETUSER_SUCCESS = 122;
  SM_GETUSER_FAIL = 123;

  GM_ADDUSER = 124;
  SM_ADDUSER_SUCCESS = 125;
  SM_ADDUSER_FAIL = 126;

  GM_CHANGEPASS = 127;         //�޸�����
  SM_CHANGEPASS_SUCCESS = 128;
  SM_CHANGEPASS_FAIL = 129;

  //�û����
  GM_USERLOGIN = 200;          //�û���½
  SM_USERLOGIN_SUCCESS = 201;
  SM_USERLOGIN_FAIL = 202;

  {GM_USERCHANGEPASS = 203;  //�޸�����
  SM_USERCHANGEPASS_SUCCESS = 204;
  SM_USERCHANGEPASS_FAIL = 205;    }

  GM_USERCHECKMAKEKEYANDDAYMAKENUM = 206; //��֤��Կ�׺ͽ������ɴ���
  SM_USERCHECKMAKEKEYANDDAYMAKENUM_SUCCESS = 207;
  SM_USERCHECKMAKEKEYANDDAYMAKENUM_FAIL = 208;

  GM_USERMAKELOGIN = 209;    //���ɵ�½��
  SM_USERMAKELOGIN_SUCCESS = 210;
  SM_USERMAKELOGIN_FAIL = 211;

  GM_USERMAKEGATE = 212;     //��������
  SM_USERMAKEGATE_SUCCESS = 213;
  SM_USERMAKEGATE_FAIL = 214;

  SM_USERMAKEONETIME_FAIL = 215; //��������������û�ͬʱ��������
  SM_USERVERSION = 216;  //�汾�ŷ���
////////////////////////////////////////////////////////////////////////////////
//ע��M2���
  GM_GETM2USER = 243;          //����û����Ƿ����
  SM_GETM2USER_SUCCESS = 217;
  SM_GETM2USER_FAIL = 218;

  GM_ADDM2USER = 219;          //����M2�û�
  SM_ADDM2USER_SUCCESS = 220;
  SM_ADDM2USER_FAIL = 221;

  GM_USERCHECKMAKEUPDATADATAUNM =222; //����û��޸ĵĴ���
  SM_USERCHECKMAKEUPDATADATAUNM_SUCCESS = 223;
  SM_USERCHECKMAKEUPDATADATAUNM_FAIL = 224;

  GM_USERUPDATAM2REGDATAIP = 225;//�޸�IP��Ϣ
  SM_USERUPDATAM2REGDATAIP_SUCCESS = 226;
  SM_USERUPDATAM2REGDATAIP_FAIL = 227;

  GM_USERUPDATAM2REGDATAHARD = 228;//�޸�Ӳ����Ϣ
  SM_USERUPDATAM2REGDATAHARD_SUCCESS = 229;
  SM_USERUPDATAM2REGDATAHARD_FAIL = 230;

  GM_USERMAKEM2REG = 231; //����M2ע���ļ�
  SM_USERMAKEM2REG_SUCCESS = 232;
  SM_USERMAKEM2REG_FAIL =233;

  GM_USERM2LOGIN = 234;          //�û���½
  SM_USERM2LOGIN_SUCCESS = 235;
  SM_USERM2LOGIN_FAIL = 236;

{  GM_USERM2CHANGEPASS = 237;  //�޸�����
  SM_USERM2CHANGEPASS_SUCCESS = 238;
  SM_USERM2CHANGEPASS_FAIL = 239;       }

  GM_USERCHECKM2DAYMAKENUM = 240; //��֤�������ɴ���
  SM_USERCHECKM2DAYMAKENUM_SUCCESS = 241;
  SM_USERCHECKM2DAYMAKENUM_FAIL = 242;

  SM_M2USERVERSION = 243;  //M2�汾�ŷ���
////////////////////////////////////////////////////////////////////////////////
//1.76��½��
  GM_176USERLOGIN = 244;          //�û���½
  GM_176USERCHECKMAKEKEYANDDAYMAKENUM = 245; //��֤��Կ�׺ͽ������ɴ���
  GM_176USERMAKELOGIN = 246;    //���ɵ�½��
  GM_176USERMAKEGATE = 247;     //��������
//1.76 M2
  GM_176USERM2LOGIN = 248;          //�û���½
  GM_176USERCHECKMAKEUPDATADATAUNM =249; //1.76����û��޸ĵĴ���
  GM_176USERUPDATAM2REGDATAHARD = 250;//1.76�޸�Ӳ����Ϣ
  GM_176USERCHECKM2DAYMAKENUM = 251; //1.76��֤�������ɴ���
  GM_176USERMAKEM2REG = 252; //1.76����M2ע���ļ�
  SM_176USERMAKELOGIN_SUCCESS = 253; //1.76���ɵ�½���ɹ�
  SM_176USERMAKEGATE_SUCCESS = 254;  //1.76�������سɹ�
  SM_176USERMAKEM2REG_SUCCESS = 255; //1.76����M2�ɹ�

  SM_UPDATEM2USERREGDATE_SUCCESS = 256;//M2���ڳɹ�
  SM_UPDATEM2USERREGDATE_FAIL = 257;//M2����ʧ��
  GM_UPDATEM2USERREGDATE = 258; //M2����
////////////////////////////////////////////////////////////////////////////////
  GS_QUIT = 2000; //�ر�
  SG_FORMHANDLE = 1000; //������HANLD
  SG_STARTNOW = 1001; //��������������...
  SG_STARTOK = 1002; //�������������...
  SG_RECONMAKE = 1003;//֪ͨ������W2�����������ɷ����� 20100102
const
  CLIENT_USEPE = 1;//��½��ʹ�ÿǱ�ʶ 0-VMP 1-WL
implementation

end.
