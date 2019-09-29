unit MakeThread;

interface
uses Windows,Classes, SysUtils{, Controls, EDcodeUnit, HUtil32, DateUtils, EDcode, Common};

type
  TMakeLoginThread = class(TThread)//��½���߳�
  private

  protected
    procedure Execute;override;
  public
    bois176: Boolean; //�Ƿ�Ϊ176
    sData1: string;
    constructor Create(sData: string);
    destructor  Destroy;override;
  end;

  TMakeGateThread = class(TThread)//�����߳�
  private
  protected
    procedure Execute;override;
  public
    bois176: Boolean; //�Ƿ�Ϊ1.76
    sData1: string;
    constructor Create(sData: string);
    destructor  Destroy;override;
  end;

  TMakeM2RegThread = class(TThread)//M2ע���ļ��߳�
  private
    //procedure MakeM2FileKey(sData: string);
  protected
    procedure Execute;override;
  public
    sData1: string;
    constructor Create(sData: string);
    destructor  Destroy;override;
  end;

  TMakeM2RegThread_176 = class(TThread)//M2(176)ע���ļ��߳�
  private
    //procedure MakeM2FileKey_176(sData: string);
  protected
    procedure Execute;override;
  public
    sData1: string;
    constructor Create(sData: string);
    destructor  Destroy;override;
  end;
var
  MakeLoginThread: TMakeLoginThread;
  MakeGateThread: TMakeGateThread;
  MakeM2RegThread: TMakeM2RegThread;
  MakeM2RegThread_176: TMakeM2RegThread_176;
implementation
uses Main, Share;

constructor TMakeLoginThread.Create(sData: string);
begin
  inherited  Create(False);
  bois176 := False;
  FreeOnTerminate:= True;
  sData1:= sData;
  Inc(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

destructor TMakeLoginThread.Destroy;
begin
  inherited;
end;

procedure TMakeLoginThread.Execute;
begin
  FrmMain.MakeLogin(sData1, bois176);
  Dec(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

//-----------------------------------------------------------
constructor TMakeGateThread.Create(sData: string);
begin
  inherited  Create(False);
  bois176 := False;
  FreeOnTerminate:= True;
  sData1:= sData;
  Inc(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

destructor TMakeGateThread.Destroy;
begin
  inherited;
end;

procedure TMakeGateThread.Execute;
begin
  FrmMain.MakeGate(sData1, bois176);
  Dec(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

{ TMakeM2RegThread }

constructor TMakeM2RegThread.Create(sData: string);
begin
  inherited  Create(False);
  FreeOnTerminate:= True;
  sData1:= sData;
  Inc(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

destructor TMakeM2RegThread.Destroy;
begin
  inherited;
end;

(*//���ڴ˹��̣���Ҫ��WinlicenseSDK.dll�ļ�
procedure TMakeM2RegThread.MakeM2FileKey(sData: string);
var
{  ExpDateSysTime: SYSTEMTIME;
  LicenseKeyBuff: array[0..1000] of AnsiChar;
  SizeKey, i: integer;
  pName: PAnsiChar;
  pOrg: PAnsiChar;
  pCustom: PAnsiChar;
  pHardId: PAnsiChar;
  pExpDateSysTime: ^SYSTEMTIME;
  NumDays, NumExec: integer;
  KeyFile: file of AnsiChar;
  str: PAnsiChar;
  RegExpDate: TDate;}

  sStr: string;
  sSocketIndex: string;
  sAccount: string;
  sGatePass: string;
  sKeyPass: string;
  sHardId: string;
  sRegDate: String;
  nCheckCode, nCheckCode1: Integer;

  nCode: Byte;
begin
  nCode:= 0;
  try
    //UserInfo.sSockIndex + '/' + UserInfo.sAccount + '/' +sKeyPass + '/' + sGatePass + '/' + HardId + '/'+ sRegDate;
    nCheckCode := -1;
    sStr := DecryptString(sData);
    sStr := GetValidStr3(sStr, sSocketIndex, ['/']);//
    sStr := GetValidStr3(sStr, sAccount, ['/']);
    sStr := GetValidStr3(sStr, sKeyPass, ['/']);
    sStr := GetValidStr3(sStr, sGatePass, ['/']);
    sRegDate := GetValidStr3(sStr, sHardId, ['/']);
    nCode:= 1;
    if (sAccount <> '') and (sKeyPass <> '') and (sSocketIndex <> '') and (sGatePass <>'') and (sHardId <> '') and (sRegDate <> '') then begin
      nCode:= 2;
      if not DirectoryExists(g_MakeDir + '\' + sAccount) then ForceDirectories(g_MakeDir + '\' + sAccount); //Ŀ¼������,�򴴽�
      nCode:= 3;
      if FileExists(g_MakeDir + '\' + sAccount +'\IGEM2key.dat') then DeleteFile(g_MakeDir + '\' + sAccount +'\IGEM2key.dat');
      nCode:= 4;
      pName := PAnsiChar(sAccount);//�û���
      pOrg := PAnsiChar(sKeyPass);//��˾��Ϣ
      pCustom := PAnsiChar(sGatePass);//IP��Ϣ
      pHardId := PAnsiChar(Trim(sHardId));//Ӳ��ID

      NumExec := 0;//�������д�����0ֵ�򲻿������д���
      nCode:= 5;
      RegExpDate:= StrToDate(sRegDate) + 365;
      DateTimeToSystemTime(RegExpDate, ExpDateSysTime);
      pExpDateSysTime := addr(ExpDateSysTime){nil};//��������-
      nCode:= 6;
      if (Date() <= RegExpDate) then begin//�������ڴ��ڻ���ڵ�ǰ������ 20090825 �޸�
        NumDays:= DaysBetween(Date(),RegExpDate);//ȡ�����ڵ���
      end else NumDays:= 0;

      nCode:= 7;
      str:= PAnsiChar(DeCodeString(CodeString));//M2��ϣֵ
      nCode:= 8;
      SizeKey := WLGenLicenseFileKey({LicenseHash}str, pName, pOrg, pCustom, pHardId, NumDays, NumExec, pExpDateSysTime, 0, 0, 0, LicenseKeyBuff) ;
      nCode:= 9;
      //����ע���ļ�
      AssignFile(KeyFile, g_MakeDir + '\' + sAccount +'\IGEM2key.dat');
      nCode:= 10;
      Rewrite(KeyFile);
      nCode:= 11;
      for i:= 0 to SizeKey-1 do Write(KeyFile, LicenseKeyBuff[i]);
      CloseFile(KeyFile);
      if SizeKey > 0 then nCheckCode := 1;
      //nCheckCode1:= RunApp('', g_MakeDir, sData, 'A');//ִ���ں�EXE����ע���ļ�
      //if nCheckCode1 <> 0 then nCheckCode := 1;
    end else nCheckCode := -2;
    nCode:= 13;
    if nCheckCode = 1 then begin
      Inc(g_nMakeM2RegNum); //�����������ش���
      FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex,
                             EncodeMessage(MakeDefaultMsg(SM_USERMAKEM2REG_SUCCESS, 0, 0, 0, 0))+ EncryptString(g_Http + sAccount +'/IGEM2key.dat'));
    end else begin
      FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex,
                              EncodeMessage(MakeDefaultMsg(SM_USERMAKEM2REG_FAIL, 0, 0, 0, 0)));
    end;
  except
    MainOutMessage('{�쳣} MakeM2FileKey Code:' + IntToStr(nCode));
    FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex, EncodeMessage(MakeDefaultMsg(SM_USERMAKEM2REG_FAIL, 0, 0, 0, 0)));
  end;
end;  *)

procedure TMakeM2RegThread.Execute;
begin
  FrmMain.MakeM2FileKey(sData1);
  Dec(g_nNowMakeUserNum);//���� �����ж��ٸ��û�������
end;

{TMakeM2RegThread_176}
constructor TMakeM2RegThread_176.Create(sData: string);
begin
  inherited  Create(False);
  FreeOnTerminate:= True;
  sData1:= sData;
  Inc(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;

destructor TMakeM2RegThread_176.Destroy;
begin
  inherited;
end;

(*//����M2(176)ע���ļ�
procedure TMakeM2RegThread_176.MakeM2FileKey_176(sData: string);
var
  {ExpDateSysTime: SYSTEMTIME;
  LicenseKeyBuff: array[0..1000] of AnsiChar;
  SizeKey, i: integer;
  pName: PAnsiChar;
  pOrg: PAnsiChar;
  pCustom: PAnsiChar;
  pHardId: PAnsiChar;
  pExpDateSysTime: ^SYSTEMTIME;
  NumDays, NumExec: integer;
  KeyFile: file of AnsiChar;
  str: PAnsiChar;
  RegExpDate: TDate;}

  sStr: string;
  sSocketIndex: string;
  sAccount: string;
  sGatePass: string;
  sKeyPass: string;
  sHardId: string;
  sRegDate: String;
  nCheckCode, nCheckCode1: Integer;

  nCode: Byte;
begin
  nCode:= 0;
  try
    nCheckCode := -1;
    sStr := DecryptString(sData);
    sStr := GetValidStr3(sStr, sSocketIndex, ['/']);//
    sStr := GetValidStr3(sStr, sAccount, ['/']);
    sStr := GetValidStr3(sStr, sKeyPass, ['/']);
    sStr := GetValidStr3(sStr, sGatePass, ['/']);
    sRegDate := GetValidStr3(sStr, sHardId, ['/']);
    nCode:= 1;
    if (sAccount <> '') and (sKeyPass <> '') and (sSocketIndex <> '') and (sGatePass <>'') and (sHardId <> '') and (sRegDate <> '') then begin
      nCode:= 2;
      if not DirectoryExists(g_MakeDir + '\' + sAccount) then ForceDirectories(g_MakeDir + '\' + sAccount); //Ŀ¼������,�򴴽�
      nCode:= 3;
      if FileExists(g_MakeDir + '\' + sAccount +'\IGEM2key.dat') then DeleteFile(g_MakeDir + '\' + sAccount +'\IGEM2key.dat');
      nCode:= 4;
      pName := PAnsiChar(sAccount);//�û���
      pOrg := PAnsiChar(sKeyPass);//��˾��Ϣ
      pCustom := PAnsiChar(sGatePass);//IP��Ϣ
      pHardId := PAnsiChar(Trim(sHardId));//Ӳ��ID

      NumExec := 0;//�������д�����0ֵ�򲻿������д���
      nCode:= 5;
      RegExpDate:= StrToDate(sRegDate) + 365;
      DateTimeToSystemTime(RegExpDate, ExpDateSysTime);
      pExpDateSysTime := addr(ExpDateSysTime){nil};//��������-
      nCode:= 6;
      if (Date() <= RegExpDate) then begin//�������ڴ��ڻ���ڵ�ǰ������ 20090825 �޸�
        NumDays:= DaysBetween(Date(),RegExpDate);//ȡ�����ڵ���
      end else NumDays:= 0;

      nCode:= 7;
      str:= PAnsiChar(DeCodeString(s176CodeString));//1.76M2��ϣֵ 20090718
      nCode:= 8;
      SizeKey := WLGenLicenseFileKey(str, pName, pOrg, pCustom, pHardId, NumDays, NumExec, pExpDateSysTime, 0, 0, 0, LicenseKeyBuff) ;
      nCode:= 9;
      //����ע���ļ�
      AssignFile(KeyFile, g_MakeDir + '\' + sAccount +'\IGEM2key.dat');
      nCode:= 10;
      Rewrite(KeyFile);
      nCode:= 11;
      for i:= 0 to SizeKey-1 do Write(KeyFile, LicenseKeyBuff[i]);
      CloseFile(KeyFile);
      if SizeKey > 0 then nCheckCode := 1;

      //nCheckCode1:= RunApp('', g_MakeDir, sData, 'B');//ִ���ں�EXE����ע���ļ�
      //if nCheckCode1 <> 0 then nCheckCode := 1;
    end else nCheckCode := -2;
    nCode:= 13;
    if nCheckCode = 1 then begin
      Inc(g_nMakeM2RegNum); //�����������ش���
      FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex,
                             EncodeMessage(MakeDefaultMsg(SM_176USERMAKEM2REG_SUCCESS, 0, 0, 0, 0))+ EncryptString(g_Http + sAccount +'/IGEM2key.dat'));
    end else begin                                      
      FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex,
                              EncodeMessage(MakeDefaultMsg(SM_USERMAKEM2REG_FAIL, 0, 0, 0, 0)));
    end;
  except
    MainOutMessage('{�쳣}TFrmMain.MakeM2FileKey_176 Code:' + IntToStr(nCode));
    FrmMain.SendUserSocket(FrmMain.g_Socket, sSocketIndex, EncodeMessage(MakeDefaultMsg(SM_USERMAKEM2REG_FAIL, 0, 0, 0, 0)));
  end;
end;  *)

procedure TMakeM2RegThread_176.Execute;
begin
  FrmMain.MakeM2FileKey_176(sData1);
  Dec(g_nNowMakeUserNum);  //���� �����ж��ٸ��û�������
end;
end.
