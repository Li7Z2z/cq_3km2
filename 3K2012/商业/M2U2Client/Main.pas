unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, JSocket, WinSkinData, StdCtrls, ComCtrls, EDcode,
  EDcodeUnit ,Login, Clipbrd, IdHTTP, Common, Grobal2, ShellAPI;

type
  TFrmMain = class(TForm)
    DecodeTimer: TTimer;
    ClientSocket: TClientSocket;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelUserName: TLabel;
    LabelQQ: TLabel;
    LabelDayMakeNum: TLabel;
    LabelAddrs: TLabel;
    LabelTime: TLabel;
    LabelMaxDayMakeNum: TLabel;
    Label7: TLabel;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_REFLOGIN: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MEMU_CENECT: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    StatusPaneMsg: TStatusBar;
    N1: TMenuItem;
    N2: TMenuItem;
    C1: TMenuItem;
    SkinData1: TSkinData;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormActivate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure MENU_CONTROL_REFLOGINClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Login: TFrmLogin;
    procedure SendLoginUser(sAccount, sPassword: string);
    procedure DecodeMessagePacket(sData: string);
    procedure LoginSucces(sData: string);
    procedure GetChangePass(Msg:TDefaultMessage; sData: string);
    procedure GetCheckMakeKeyAndDayMakeNum(Msg:TDefaultMessage; sData: string);
    procedure GetCheckUpdataM2RegData(Msg: TDefaultMessage; sData: string);
    procedure GetUpdataM2RegIP(Msg: TDefaultMessage; sData: string);
    procedure GetUpdataM2RegHARD(Msg: TDefaultMessage; sData: string);
    procedure GetMakeM2Reg(sData: string);
    procedure GetMakeM2RegFail(Code: Integer);
    procedure GetUserLoginFail(Code: Integer);
    procedure GetVersion();
    procedure GetVersionNum(sData: string);
  public
    procedure SendSocket(Socket: TCustomWinSocket; sSendMsg: string);
    procedure SendAddAccount(ue: TUserEntry1);
    procedure SendCheckAccount(sAccount: string);
    procedure SendChangePass(sAccount,OldPass,NewPass: string);
    procedure SendCheckMakeKeyAndDayMakeNum(key: string);
    procedure SendCheckMakeUpdataDataNum(sAcount: string);//����Ƿ��޸Ĺ���Ϣ����
    procedure SendMakeLogin(sData: string);
    procedure SendMakeGate(sData: string);
    procedure SendMakeM2Reg(sData: string);
    procedure SendUpdataM2RegIP(sData: string);//�޸�IP��Ϣ
    procedure SendUpdataM2RegHARD(sData: string);//�޸�Ӳ����Ϣ
  end;
var
  FrmMain: TFrmMain;

implementation

uses Share, HUtil32, PassWord, About, M2regFile;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  GetVersion();
  LabelUserName.Caption := '';
  LabelQQ.Caption := '';
  LabelDayMakeNum.Caption := '0';
  LabelMaxDayMakeNum.Caption := '0';
  LabelAddrs.Caption := '';
  LabelTime.Caption := '2000-00-00 00:00:00';  
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_sRecvMsg := '';
  g_sRecvGameMsg := '';
  g_boBusy := False;
  StatusPaneMsg.Panels[0].Text := '���������ӳɹ�...';
  StatusPaneMsg.Panels[0].Text := '���ڵ�½...';
  g_boConnect := True;
  SendLoginUser(g_sAccount, g_sPassword);
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusPaneMsg.Panels[0].Text := '���������ӶϿ�...';
  g_boConnect := False;
  g_boLogined := False;
  if Login <> nil then begin
   Login.BtnLogin.Enabled := True;
   Login.ComboBoxUser.Enabled := True;
   Login.EdtPass.Enabled := True;
  end;
end;

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if Login <> nil then begin
  Login.BtnLogin.Enabled := True;
  Login.ComboBoxUser.Enabled := True;
  Login.EdtPass.Enabled := True;
  end;
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.SendSocket(Socket: TCustomWinSocket; sSendMsg: string);
const
  btCode: Byte = 1;
var
  sSendText: string;
begin
  if Socket.Connected then begin
    sSendText := '#' + IntToStr(btCode) + sSendMsg + '!';
    Inc(btCode);
    if btCode >= 10 then btCode := 1;
    while True do begin
      if Socket.SendText (sSendText) <> -1 then Break;
    end;
  end;
end;
procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
var
  sData: string;
begin
  if g_boBusy then Exit;
  g_boBusy := True;
  try
    g_sRecvGameMsg := g_sRecvGameMsg + g_sRecvMsg;
    g_sRecvMsg := '';
    if g_sRecvGameMsg <> '' then begin
      while Pos('!', g_sRecvGameMsg) > 0 do begin
        if Pos('!', g_sRecvGameMsg) <= 0 then Break;
        g_sRecvGameMsg := ArrestStringEx(g_sRecvGameMsg, '#', '!', sData);
        if sData = '' then Break;
        DecodeMessagePacket(sData);
        if Pos('!', g_sRecvGameMsg) <= 0 then Break;
      end;
    end;
  finally
    g_boBusy := False;
  end;
end;

procedure TFrmMain.DecodeMessagePacket(sData: string);
var
  nDataLen: Integer;
  sDataMsg, sDefMsg: string;
  DefMsg: TDefaultMessage;
begin
  nDataLen := Length(sData);
  if (nDataLen >= DEFBLOCKSIZE) then begin
    sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
    sDataMsg := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
    case DefMsg.Ident of
      SM_USERM2LOGIN_FAIL: GetUserLoginFail(DefMsg.Recog);
      SM_USERM2LOGIN_SUCCESS: LoginSucces(sDataMsg);//��½�ɹ�
      //SM_USERM2CHANGEPASS_SUCCESS,
      //SM_USERM2CHANGEPASS_FAIL: GetChangePass(DefMsg, sDataMsg); //�޸�����
      SM_USERCHECKM2DAYMAKENUM_SUCCESS,
      SM_USERCHECKM2DAYMAKENUM_FAIL: GetCheckMakeKeyAndDayMakeNum(DefMsg, sDataMsg);
      SM_USERCHECKMAKEUPDATADATAUNM_SUCCESS,
      SM_USERCHECKMAKEUPDATADATAUNM_FAIL: GetCheckUpdataM2RegData(DefMsg, sDataMsg);
      SM_USERUPDATAM2REGDATAIP_SUCCESS,
      SM_USERUPDATAM2REGDATAIP_FAIL: GetUpdataM2RegIP(DefMsg, sDataMsg);
      SM_USERUPDATAM2REGDATAHARD_SUCCESS,
      SM_USERUPDATAM2REGDATAHARD_FAIL: GetUpdataM2RegHARD(DefMsg, sDataMsg);
      SM_176USERMAKEM2REG_SUCCESS,
      SM_USERMAKEM2REG_SUCCESS:begin
        GetMakeM2Reg(sDataMsg);
        g_MySelf.nDayMakeNum := DefMsg.Recog;
        LabelDayMakeNum.Caption := IntToStr(g_MySelf.nDayMakeNum);
      end;
      SM_USERMAKEM2REG_FAIL: GetMakeM2RegFail(DefMsg.Recog);
      SM_USERMAKEONETIME_FAIL: Application.MessageBox('�������������ͬʱ�����������Ժ����ɣ�', 
        'Error', MB_OK + MB_ICONSTOP);
      SM_M2USERVERSION: GetVersionNum(sDataMsg);
    end;
  end;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_sRecvMsg := g_sRecvMsg + Socket.ReceiveText;
end;

procedure TFrmMain.LoginSucces(sData: string);
begin
  FillChar(g_MySelf, SizeOf(TM2UserInfo), #0);
  DecryptBuffer(sData, @g_MySelf, SizeOf(TM2UserInfo));
  LabelUserName.Caption := g_MySelf.sAccount;
  LabelQQ.Caption := g_MySelf.sUserQQ;
  LabelDayMakeNum.Caption := IntToStr(g_MySelf.nDayMakeNum);
  LabelMaxDayMakeNum.Caption := IntToStr(g_MySelf.nMaxDayMakeNum);
  LabelAddrs.Caption := g_MySelf.SAddrs;
  LabelTime.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',g_MySelf.dTimer);
  StatusPaneMsg.Panels[0].Text := '��½�ɹ�...';
  g_boLogined := True;
  Login.Free;
  Login := nil;
end;

procedure TFrmMain.ClientSocketConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusPaneMsg.Panels[0].Text := '�������ӷ�����...';
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  if g_boConnect then Exit;
  Login := TFrmLogin.Create(Application);
  Login.Caption := '��¼';
end;

procedure TFrmMain.SendLoginUser(sAccount, sPassword: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF Version = 1}//1.76
  DefMsg := MakeDefaultMsg(GM_176USERM2LOGIN, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERM2LOGIN, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount + '/' + sPassword));//20080709
end;

procedure TFrmMain.SendAddAccount(ue: TUserEntry1);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(GM_ADDUSER, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(Msg) + EncryptBuffer(@ue, SizeOf(TUserEntry1)));
end;

procedure TFrmMain.SendCheckAccount(sAccount: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(GM_GETUSER, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount));//20080709
end;

procedure TFrmMain.N1Click(Sender: TObject);
begin
{  if g_boLogined then begin
    FrmMakeLogin.Open;
  end;}
end;

procedure TFrmMain.C1Click(Sender: TObject);
begin
  if g_boLogined then begin
    {FrmPassWord := TFrmPassWord.Create(Application);
    FrmPassWord.Open();
    FrmPassWord.Free;  }
    ShellExecute(Handle, 'Open', PChar('IEXPLORE.EXE'),
      PChar('http://i.3km2.com/?action=c'),
      '',
      SW_SHOWNORMAL)
  end;
end;

procedure TFrmMain.SendChangePass(sAccount, OldPass, NewPass:string);
var
  DefMsg: TDefaultMessage;
begin
 { DefMsg := MakeDefaultMsg(GM_USERM2CHANGEPASS, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount + '/' + OldPass + '/' + NewPass));//20080709  }
end;

procedure TFrmMain.GetChangePass(Msg:TDefaultMessage; sData: string);
begin
 { if Msg.Ident = SM_USERM2CHANGEPASS_SUCCESS then begin
     Application.MessageBox('�����޸ĳɹ�,�����µ�¼��', '��ʾ', MB_OK + MB_ICONINFORMATION);
     Close;
  end else begin
    case Msg.Recog of
      -1: FrmPassWord.StatusBar1.Panels[0].Text := '�����½�Ժ��ڲ�����';
      -2: FrmPassWord.StatusBar1.Panels[0].Text := '��ĵ�½�ʺŴ���';
      -3: FrmPassWord.StatusBar1.Panels[0].Text := 'ԭ���벻��ȷ��';
      -4: FrmPassWord.StatusBar1.Panels[0].Text := 'ϵͳδ֪���� Code='+IntToStr(Msg.Recog);
    end;
  end;
  FrmPassWord.BtnChange.Enabled := True;     } 
end;

procedure TFrmMain.SendCheckMakeKeyAndDayMakeNum(key: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(GM_USERCHECKM2DAYMAKENUM, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(key));//20080709
end;
//����Ƿ��޸Ĺ���Ϣ����
procedure TFrmMain.SendCheckMakeUpdataDataNum(sAcount: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF Version = 1}//1.76
  DefMsg := MakeDefaultMsg(GM_176USERCHECKMAKEUPDATADATAUNM, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERCHECKMAKEUPDATADATAUNM, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAcount));
end;

procedure TFrmMain.GetCheckMakeKeyAndDayMakeNum(Msg: TDefaultMessage;
  sData: string);
begin
  if Msg.Ident = SM_USERCHECKM2DAYMAKENUM_SUCCESS then begin
    case MakeType of
      2: SendMakeM2Reg(g_MySelf.sAccount);
    end;
  end else begin
    case msg.Recog of
      -1: Application.MessageBox('�����½�Ժ��ڲ�����', 'Error', MB_OK + MB_ICONSTOP);
      -2: Application.MessageBox('�벻Ҫ�Ƿ�������', 'Error', MB_OK + MB_ICONSTOP);
      -3: Application.MessageBox('��������ɵĴ����ѳ���ÿ���������ɴ�����',  'Error', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure TFrmMain.GetCheckUpdataM2RegData(Msg: TDefaultMessage; sData: string);
begin
  if Msg.Ident = SM_USERCHECKMAKEUPDATADATAUNM_SUCCESS then begin
    case MakeType of
      3: M2regFileFrm.UpdataM2RegIP();//�޸�IP��Ϣ
      4: M2regFileFrm.UpdataM2RegHARD();//�޸�Ӳ����Ϣ
    end;
  end else begin
    Application.MessageBox('�����޸Ĺ����Σ����������޸���Ϣ��', 'Error', MB_OK + MB_ICONSTOP);
    M2regFileFrm.Close;
  end;
end;

procedure TFrmMain.GetUpdataM2RegIP(Msg: TDefaultMessage; sData: string);
begin
  if Msg.Ident = SM_USERUPDATAM2REGDATAIP_SUCCESS then begin
     g_MySelf.sBakGameListUrl:= M2regFileFrm.Edit2.Text;
     g_MySelf.nUpType := 1;
     Application.MessageBox('IP��Ϣ�޸ĳɹ�������������ע���ļ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
     M2regFileFrm.Button2.Enabled := True;
     M2regFileFrm.Edit2.Enabled := True;
     M2regFileFrm.Edit6.Enabled := True;
     M2regFileFrm.Button3.Enabled := True;
     M2regFileFrm.Close;
  end else begin
    case Msg.Recog of
      -1: Application.MessageBox('�����½�Ժ��ڲ�����', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -2: Application.MessageBox('��ĵ�½�ʺŴ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -3: Application.MessageBox('�޸�IP��Ϣʧ�ܣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -4: Application.MessageBox('�����쳣��', '��ʾ', MB_OK + MB_ICONINFORMATION);
    end;
    M2regFileFrm.Button2.Enabled := True;
    M2regFileFrm.Edit2.Enabled := True;
    M2regFileFrm.Edit6.Enabled := True;
    M2regFileFrm.Button3.Enabled := True;
    M2regFileFrm.Close;
  end;
end;

procedure TFrmMain.GetUpdataM2RegHARD(Msg: TDefaultMessage; sData: string);
begin
  if Msg.Ident = SM_USERUPDATAM2REGDATAHARD_SUCCESS then begin
     g_MySelf.sPatchListUrl:= M2regFileFrm.Edit6.Text;
     g_MySelf.nUpType := 2;
     g_MySelf.nUpDataNum := Msg.Recog;
     M2regFileFrm.Label15.Caption := IntToStr(Msg.Recog);
     M2regFileFrm.Label16.Caption := IntToStr(Msg.Recog);
     Application.MessageBox('Ӳ����Ϣ�޸ĳɹ�������������ע���ļ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
     M2regFileFrm.Button2.Enabled := True;
     M2regFileFrm.Edit2.Enabled := True;
     M2regFileFrm.Edit6.Enabled := True;
     M2regFileFrm.Button3.Enabled := True;
     M2regFileFrm.Close;
  end else begin
    case Msg.Recog of
      -5: Application.MessageBox('�����½�Ժ��ڲ�����', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -2: Application.MessageBox('��ĵ�½�ʺŴ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -3: Application.MessageBox('�޸�Ӳ����Ϣʧ�ܣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -4: Application.MessageBox('�����쳣��', '��ʾ', MB_OK + MB_ICONINFORMATION);
      -1: Application.MessageBox('����Ĳ�����Ч��Ӳ����Ϣ��', '��ʾ', MB_OK + MB_ICONINFORMATION);
    end;
    M2regFileFrm.Button2.Enabled := True;
    M2regFileFrm.Edit2.Enabled := True;
    M2regFileFrm.Edit6.Enabled := True;
    M2regFileFrm.Button3.Enabled := True;
    M2regFileFrm.Close;
  end;
end;

procedure TFrmMain.SendMakeLogin(sData: string);
//var
//  DefMsg: TDefaultMessage;
begin
//  DefMsg := MakeDefaultMsg(GM_USERMAKELOGIN, 0, 0, 0, 0);
//  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));//20080709
end;

procedure TFrmMain.SendMakeGate(sData: string);
//var
//  DefMsg: TDefaultMessage;
begin
//  DefMsg := MakeDefaultMsg(GM_USERMAKEGATE, 0, 0, 0, 0);
//  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));//20080709
end;

procedure TFrmMain.SendMakeM2Reg(sData: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF Version = 1}//1.76
  DefMsg := MakeDefaultMsg(GM_176USERMAKEM2REG, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERMAKEM2REG, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));
end;

//�޸�IP��Ϣ
procedure TFrmMain.SendUpdataM2RegIP(sData: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(GM_USERUPDATAM2REGDATAIP, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));
end;

//�޸�Ӳ����Ϣ
procedure TFrmMain.SendUpdataM2RegHARD(sData: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF Version = 1}
  DefMsg := MakeDefaultMsg(GM_176USERUPDATAM2REGDATAHARD, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERUPDATAM2REGDATAHARD, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));
end;

procedure TFrmMain.GetMakeM2Reg(sData: string);
var
  sStr: string;
  sHttp: string;
begin
  sHttp := DecryptString(sData);
  if sHttp <> '' then begin
    sStr := '����M2ע���ļ��ɹ��������غ�ŵ�Mir200Ŀ¼��' + #13 + #10 + '���ص�ַ�Ѿ��Զ����㸴�Ƶ����а棡' + sHttp;
    Application.MessageBox(PChar(sStr), '��ʾ', MB_OK +
      MB_ICONINFORMATION);
    Clipbrd.Clipboard.AsText := sHttp;
    M2regFileFrm.Button1.Enabled := True;
  end;
end;

procedure TFrmMain.MENU_CONTROL_REFLOGINClick(Sender: TObject);
begin
  if Login = nil then begin
    g_boConnect:= False;
    g_boLogined := False;
    Login := TFrmLogin.Create(nil);
    with Login do begin
      StatusPaneMsg.Panels[0].Text := '�������ӷ�����...';
      Login.Update;
      Caption := '��¼';
      BtnLogin.Enabled := True;
      ComboBoxUser.Enabled := True;
      EdtPass.Enabled := True;
      Label1.Visible :=True;
      label2.Visible :=True;
    end;
  end;
end;

procedure TFrmMain.GetMakeM2RegFail(Code: Integer);
begin
  case Code of
    -2: Application.MessageBox('����M2ע���ļ�ʧ�ܣ� ��Ϣ��������', 'Error',MB_OK + MB_ICONSTOP);
    else
      Application.MessageBox(PChar('����M2ע���ļ�ʧ�� Code:'+IntToStr(Code)), 'Error', MB_OK + MB_ICONSTOP);
  end;
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  FrmAbout.Open;
end;

procedure TFrmMain.GetUserLoginFail(Code: Integer);
begin
  case Code of
    0: StatusPaneMsg.Panels[0].Text := '�û������������'; //��½ʧ��
    1: Application.MessageBox('����ʺ��Ѿ��ڷ������ϵ�½�ˣ�', 'Error', MB_OK + MB_ICONWARNING);
  end;
  if Login <> nil then begin
   Login.BtnLogin.Enabled := True;
   Login.ComboBoxUser.Enabled := True;
   Login.EdtPass.Enabled := True;
  end;
end;

//����ָ����վ�ı�,���Ϊ����ָ��,����M2����ʾ�����Ϣ 20081018
procedure TFrmMain.GetVersion();
  //�ַ����ӽ��ܺ��� 20080217
  Function SetDate(Text: String): String;
  Var
   I: Word;
   C: Word;
  Begin
    {$IF CLIENT_USEPE = 0}
    asm
      db $EB,$10,'VMProtect begin',0
    end;
    {$IFEND}
      Result := '';
      For I := 1 To Length(Text) Do Begin
        C := Ord(Text[I]);
        Result := Result + Chr((C Xor 12));
      End;
    {$IF CLIENT_USEPE = 0}
    asm
      db $EB,$0E,'VMProtect end',0
    end;
    {$IFEND}
  End;
var
  sRemoteAddress: string;
  IdHTTP: TIdHTTP;
  s: string;
  sEngineVersion, str0, Str1,sboClose: string;
  sStr, str2, str3, str4, str5, str6, str7, str8, str9, str10: string;   
begin
{$IF CLIENT_USEPE = 0}
asm
  db $EB,$10,'VMProtect begin',0
end;
{$IFEND}
  sRemoteAddress := '';
  Decode(_sProductAddress,sRemoteAddress);//ָ����վ�ϵ��ļ�
  if sRemoteAddress = '' then Exit;
  Try
    IdHTTP := TIdHTTP.Create(nil);
    IdHTTP.ReadTimeout := 3000;
    //S := TStringlist.Create;
    Try
      try
        S := IdHTTP.Get(sRemoteAddress);
      except
      end;
      if S <> '' then begin
        {$IF CLIENT_USEPE = 1}
        asm//WL�������ʶ
          DB $EB, $10, $57, $4c, $20, $20, $0C, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
        end;
        {$IFEND}
        {$IF Version = 1}  //1.76
        sEngineVersion := SetDate(getXmlNodeValue(s, '����.����176.��ʶ', ''));
        Str1:= SetDate(_sProductAddress1);
        str0:= getXmlNodeValue(s, '����.����176.����', '');
        sboClose:= getXmlNodeValue(s, '����.����176.�Ƿ�ر�', '');
        {$ELSE}
        sEngineVersion := SetDate(getXmlNodeValue(s, '����.��������.��ʶ', ''));
        Str1:= SetDate(_sProductAddress1);
        str0:= getXmlNodeValue(s, '����.��������.����', '');
        sboClose:= getXmlNodeValue(s, '����.��������.�Ƿ�ر�', '');
        {$IFEND}
        if CompareText(sEngineVersion, Str1) = 0 then begin//�ж��Ƿ�Ϊָ����ָ��(www.92m2.com.cn)
          if str0 <> '' then begin
            sStr := GetValidStr3(str0, str2, ['|']);
            sStr := GetValidStr3(sStr, str3, ['|']);
            sStr := GetValidStr3(sStr, str4, ['|']);
            sStr := GetValidStr3(sStr, str5, ['|']);
            sStr := GetValidStr3(sStr, str6, ['|']);
            sStr := GetValidStr3(sStr, str7, ['|']);
            sStr := GetValidStr3(sStr, str8, ['|']);
            sStr := GetValidStr3(sStr, str9, ['|']);
            sStr := GetValidStr3(sStr, str10, ['|']);
            Application.MessageBox(PChar(str2 + #13#10 +str3+ #13#10 +
                                  str4+ #13#10 +str5+ #13#10 +str6+ #13#10 +
                                  str7+ #13#10 +str8+ #13#10 +str9+ #13#10 +
                                  str10
            ), '��ʾ', MB_OK + MB_ICONINFORMATION);
            if sboClose = '1' then Application.Terminate;
          end;
        end;
        {$IF CLIENT_USEPE = 1}
        asm
          DB $EB, $10, $57, $4c, $20, $20, $0D, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
        end;
        {$IFEND}
      end else begin
        sRemoteAddress := '';
        Decode(_sProductAddressBak,sRemoteAddress);//��ȡ����վ
        if sRemoteAddress = '' then Exit;
        try
          S := IdHTTP.Get(sRemoteAddress);
        except
        end;
        if S <> '' then begin
          {$IF CLIENT_USEPE = 1}
          asm//WL�������ʶ
            DB $EB, $10, $57, $4c, $20, $20, $0C, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
          end;
          {$IFEND}
          {$IF Version = 1}  //1.76
          sEngineVersion := SetDate(getXmlNodeValue(s, '����.����176.��ʶ', ''));
          Str1:= SetDate(_sProductAddress1);
          str0:= getXmlNodeValue(s, '����.����176.����', '');
          sboClose:= getXmlNodeValue(s, '����.����176.�Ƿ�ر�', '');
          {$ELSE}
          sEngineVersion := SetDate(getXmlNodeValue(s, '����.��������.��ʶ', ''));
          Str1:= SetDate(_sProductAddress1);
          str0:= getXmlNodeValue(s, '����.��������.����', '');
          sboClose:= getXmlNodeValue(s, '����.��������.�Ƿ�ر�', '');
          {$IFEND}
          if CompareText(sEngineVersion, Str1) = 0 then begin//�ж��Ƿ�Ϊָ����ָ��(www.92m2.com.cn)
            if str0 <> '' then begin
              sStr := GetValidStr3(str0, str2, ['|']);
              sStr := GetValidStr3(sStr, str3, ['|']);
              sStr := GetValidStr3(sStr, str4, ['|']);
              sStr := GetValidStr3(sStr, str5, ['|']);
              sStr := GetValidStr3(sStr, str6, ['|']);
              sStr := GetValidStr3(sStr, str7, ['|']);
              sStr := GetValidStr3(sStr, str8, ['|']);
              sStr := GetValidStr3(sStr, str9, ['|']);
              sStr := GetValidStr3(sStr, str10, ['|']);
              Application.MessageBox(PChar(str2 + #13#10 +str3+ #13#10 +
                                    str4+ #13#10 +str5+ #13#10 +str6+ #13#10 +
                                    str7+ #13#10 +str8+ #13#10 +str9+ #13#10 +
                                    str10
              ), '��ʾ', MB_OK + MB_ICONINFORMATION);
              if sboClose = '1' then Application.Terminate;
            end;
          end;
          {$IF CLIENT_USEPE = 1}
          asm
            DB $EB, $10, $57, $4c, $20, $20, $0D, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
          end;
          {$IFEND}
        end;
      end;
    finally
      IdHTTP.Free;
    end;
  except
    //MainOutMessasge('{�쳣} GetProductAddress', 0);
  end;
{$IF CLIENT_USEPE = 0}
asm
  db $EB,$0E,'VMProtect end',0
end;
{$IFEND}
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  if g_boLogined then begin
    M2regFileFrm.Open;
  end;
end;

procedure TFrmMain.GetVersionNum(sData: string);
var
  sVersionNum: string;
begin
  {$IF CLIENT_USEPE = 1}
    asm//WL�������ʶ
      DB $EB, $10, $57, $4c, $20, $20, $0C, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
    end;
  {$ELSE}
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  {$IFEND}
    try
      Decode(g_sVersionNum, sVersionNum);
      if StrToInt(sData) > StrToInt(sVersionNum) then begin
        Application.MessageBox('��ʹ�õ�VIP�������Ǿɰ汾���뵽��ҳ�������°汾��', 
          '��ʾ', MB_OK + MB_ICONSTOP);
        Application.Terminate;  
      end;
    except
    end;
  {$IF CLIENT_USEPE = 1}
    asm
      DB $EB, $10, $57, $4c, $20, $20, $0D, $00, $00, $00, $00, $00, $00, $00, $57, $4c, $20, $20
    end;
  {$ELSE}
  asm
    db $EB,$0E,'VMProtect end',0
  end;
  {$IFEND}
end;
procedure TFrmMain.FormShow(Sender: TObject);
var
  sProductName: string;
begin
  Decode(g_sProductName, sProductName);
  Caption := sProductName;
end;

end.
