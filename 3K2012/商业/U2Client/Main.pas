unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, RzPanel, RzSplit, JSocket, WinSkinData,
  StdCtrls, RzStatus, ComCtrls, ToolWin, EDcode, EDcodeUnit ,Login, Clipbrd,
  RzGroupBar, OleCtrls, SHDocVw, IniFiles, IdHTTP,
  Grobal2, Common, ShellAPI, Share;

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
    Label4: TLabel;
    LabelGateVersionNum: TLabel;
    Label8: TLabel;
    LabelLoginVersionNum: TLabel;
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
    procedure FormDestroy(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Login: TFrmLogin;

    procedure LoadConfig();
    {$IF g_Version = 1}//1.76
    procedure Send176LoginUser(sAccount, sPassword: string);
    {$ELSE}
    procedure SendLoginUser(sAccount, sPassword: string);
    {$IFEND}
    procedure DecodeMessagePacket(sData: string);
    procedure LoginSucces(sData: string);
    procedure GetChangePass(Msg:TDefaultMessage; sData: string);
    procedure GetCheckMakeKeyAndDayMakeNum(Msg:TDefaultMessage; sData: string);
    procedure GetMakeLogin(sData: string);
    procedure GetMakeGate(sData: string);
    procedure GetMakeLoginFail(Code: Integer; sMsg : String = '');
    procedure GetMakeGateFail(Code: Integer);
    procedure GetUserLoginFail(Code: Integer);
    procedure GetVersion();
    procedure GetVersionNum(sData: string);
  public
    TempList: TStringlist;
    procedure SendSocket(Socket: TCustomWinSocket; sSendMsg: string);
    procedure SendAddAccount(ue: TUserEntry1);
    procedure SendCheckAccount(sAccount: string);
    procedure SendChangePass(sAccount,OldPass,NewPass: string);
    procedure SendCheckMakeKeyAndDayMakeNum(key: string);
    procedure SendMakeLogin(sData: string);
    procedure SendMakeGate(sData: string);
  end;
var
  FrmMain: TFrmMain;

implementation

uses HUtil32, MakeLogin, PassWord, About, Querydata;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  TempList:= TStringlist.Create;
  g_FilterItemList := TList.Create;
  LabelUserName.Caption := '';
  LabelQQ.Caption := '';
  LabelDayMakeNum.Caption := '0';
  LabelMaxDayMakeNum.Caption := '0';
  LabelAddrs.Caption := '';
  LabelTime.Caption := '2000-00-00 00:00:00';
  LabelGateVersionNum.Caption := '00000000';
  LabelLoginVersionNum.Caption := '00000000';
  LoadConfig();
  GetVersion();
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
  {$IF g_Version = 1} //1.76
  Send176LoginUser(g_sAccount, g_sPassword);
  {$ELSE}
  SendLoginUser(g_sAccount, g_sPassword);
  {$IFEND}
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusPaneMsg.Panels[0].Text := '���������ӶϿ�...';
  g_boConnect := False;
  g_boLogined := False;
 // g_MySelf.boLogined := False;
  if Login <> nil then begin
   Login.BtnLogin.Enabled := True;
   Login.ComboBoxUser.Enabled := True;
   Login.EdtPass.Enabled := True;
  end;
  //Caption := g_sCaption;
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
      SM_USERLOGIN_FAIL: GetUserLoginFail(DefMsg.Recog);
      SM_USERLOGIN_SUCCESS: LoginSucces(sDataMsg);//��½�ɹ�
      //SM_USERCHANGEPASS_SUCCESS,
      //SM_USERCHANGEPASS_FAIL: GetChangePass(DefMsg, sDataMsg); //�޸�����
      SM_USERCHECKMAKEKEYANDDAYMAKENUM_SUCCESS,
      SM_USERCHECKMAKEKEYANDDAYMAKENUM_FAIL: GetCheckMakeKeyAndDayMakeNum(DefMsg, sDataMsg);
      SM_176USERMAKELOGIN_SUCCESS,
      SM_USERMAKELOGIN_SUCCESS: begin
        GetMakeLogin(sDataMsg);
        g_MySelf.nDayMakeNum := DefMsg.Recog;
        LabelDayMakeNum.Caption := IntToStr(g_MySelf.nDayMakeNum);
      end;
      SM_176USERMAKEGATE_SUCCESS,
      SM_USERMAKEGATE_SUCCESS: begin
        GetMakeGate(sDataMsg);
        g_MySelf.nDayMakeNum := DefMsg.Recog;
        LabelDayMakeNum.Caption := IntToStr(g_MySelf.nDayMakeNum);
      end;
      SM_USERMAKELOGIN_FAIL: GetMakeLoginFail(DefMsg.Recog);
      SM_USERMAKEGATE_FAIL: GetMakeGateFail(DefMsg.Recog);
      SM_USERMAKEONETIME_FAIL: Application.MessageBox('�������������ͬʱ�����������Ժ����ɣ�', 
        'Error', MB_OK + MB_ICONSTOP);
      SM_USERVERSION: GetVersionNum(sDataMsg);
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
  FillChar(g_MySelf, SizeOf(TUserInfo), #0);
  DecryptBuffer(sData, @g_MySelf, SizeOf(TUserInfo));
  LabelUserName.Caption := g_MySelf.sAccount;
  LabelQQ.Caption := g_MySelf.sUserQQ;
  LabelDayMakeNum.Caption := IntToStr(g_MySelf.nDayMakeNum);
  LabelMaxDayMakeNum.Caption := IntToStr(g_MySelf.nMaxDayMakeNum);
  LabelAddrs.Caption := g_MySelf.SAddrs;
  LabelTime.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',g_MySelf.dTimer);
  LabelGateVersionNum.Caption := g_MySelf.sGateVersionNum;
  LabelLoginVersionNum.Caption := g_MySelf.sLoginVersionNum;
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
{$IF g_Version = 1}//1.76
procedure TFrmMain.Send176LoginUser(sAccount, sPassword: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(GM_176USERLOGIN, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount + '/' + sPassword));//20080709
end;
{$ELSE}
procedure TFrmMain.SendLoginUser(sAccount, sPassword: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(GM_USERLOGIN, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount + '/' + sPassword));//20080709
end;
{$IFEND}
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
  if g_boLogined then begin
    FrmMakeLogin.Open;
  end;
end;

procedure TFrmMain.C1Click(Sender: TObject);
begin
  if g_boLogined then begin
    {FrmPassWord := TFrmPassWord.Create(Application);
    FrmPassWord.Open();
    FrmPassWord.Free;}
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
  {DefMsg := MakeDefaultMsg(GM_USERCHANGEPASS, 0, 0, 0, 0);
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sAccount + '/' + OldPass + '/' + NewPass));//20080709   }
end;

procedure TFrmMain.GetChangePass(Msg:TDefaultMessage; sData: string);
begin
 { if Msg.Ident = SM_USERCHANGEPASS_SUCCESS then begin
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
  FrmPassWord.BtnChange.Enabled := True;    }
end;

procedure TFrmMain.SendCheckMakeKeyAndDayMakeNum(key: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF g_Version = 1}//1.76
  DefMsg := MakeDefaultMsg(GM_176USERCHECKMAKEKEYANDDAYMAKENUM, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERCHECKMAKEKEYANDDAYMAKENUM, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(key));//20080709
end;

procedure TFrmMain.GetCheckMakeKeyAndDayMakeNum(Msg: TDefaultMessage;
  sData: string);
begin
  if Msg.Ident = SM_USERCHECKMAKEKEYANDDAYMAKENUM_SUCCESS then begin
    case MakeType of
      0: FrmMakeLogin.UpFile();
      1: FrmMakeLogin.MakeGate();
    end;
  end else begin
    case msg.Recog of
      -1: Application.MessageBox('�����½�Ժ��ڲ�����', 'Error', MB_OK + MB_ICONSTOP);
      -2: Application.MessageBox('��Կ��������д��ȷ����Կ��', 'Error', MB_OK + MB_ICONSTOP);
      -3: Application.MessageBox('��������ɵĴ����ѳ���ÿ���������ɴ�����',  'Error', MB_OK + MB_ICONSTOP);
    end;
    FrmMakeLogin.BtnMakeLogin.Enabled := True;
    FrmMakeLogin.BtnMakeGate.Enabled := True;
  end;
end;

procedure TFrmMain.SendMakeLogin(sData: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF g_Version = 1}//1.76
  DefMsg := MakeDefaultMsg(GM_176USERMAKELOGIN, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERMAKELOGIN, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));//20080709
end;

procedure TFrmMain.SendMakeGate(sData: string);
var
  DefMsg: TDefaultMessage;
begin
  {$IF g_Version = 1} //1.76
  DefMsg := MakeDefaultMsg(GM_176USERMAKEGATE, 0, 0, 0, 0);
  {$ELSE}
  DefMsg := MakeDefaultMsg(GM_USERMAKEGATE, 0, 0, 0, 0);
  {$IFEND}
  SendSocket(ClientSocket.Socket, EncodeMessage(DefMsg) + EncryptString(sData));//20080709
end;

procedure TFrmMain.GetMakeLogin(sData: string);
var
  sStr: string;
  sHttp: string;
begin
  sHttp := DecryptString(sData);
  if sHttp <> '' then begin
    sStr := '���ɵ�½���ɹ���' + #13 + #10 + '���ص�ַ�Ѿ��Զ����㸴�Ƶ����а棡' + sHttp;
    Application.MessageBox(PChar(sStr), '��ʾ', MB_OK + MB_ICONINFORMATION);
    Clipbrd.Clipboard.AsText := sHttp;
    FrmMakeLogin.BtnMakeLogin.Enabled := True;
    FrmMakeLogin.BtnMakeGate.Enabled := True;
    FrmMakeLogin.ProgressBar1.Position := 0;
  end;
end;

procedure TFrmMain.GetMakeGate(sData: string);
var
  sStr: string;
  sHttp: string;
begin
  sHttp := DecryptString(sData);
  if sHttp <> '' then begin
    sStr := '�����������سɹ���' + #13 + #10 + '���ص�ַ�Ѿ��Զ����㸴�Ƶ����а棡' + sHttp;
    Application.MessageBox(PChar(sStr), '��ʾ', MB_OK + MB_ICONINFORMATION);
    Clipbrd.Clipboard.AsText := sHttp;
    FrmMakeLogin.BtnMakeLogin.Enabled := True;
    FrmMakeLogin.BtnMakeGate.Enabled := True;
    FrmMakeLogin.ProgressBar1.Position := 0;
  end;
end;

procedure TFrmMain.LoadConfig;
begin
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

procedure TFrmMain.GetMakeGateFail(Code: Integer);
begin
  Application.MessageBox(PChar('ϵͳ�쳣������֪ͨ����Ա���� Code:'+IntToStr(Code)), 'Error', MB_OK + MB_ICONSTOP);
  FrmMakeLogin.BtnMakeLogin.Enabled := True;
  FrmMakeLogin.BtnMakeGate.Enabled := True;
  FrmMakeLogin.ProgressBar1.Position := 0;
end;

procedure TFrmMain.GetMakeLoginFail(Code: Integer; sMsg : String = '');
begin
  case Code of
    -5: Application.MessageBox('����ʧ�ܣ� �ڹҹ����ļ���С����С��48KB��', 'Error',MB_OK + MB_ICONSTOP);
    -6: Application.MessageBox('����ʧ�ܣ� Ƥ���ļ���С����С��1MB��', 'Error', MB_OK + MB_ICONSTOP);
    -7: Application.MessageBox('����ʧ�ܣ� Ƥ���ļ�������3KSkin��ʽ��', 'Error', MB_OK + MB_ICONSTOP);
    -8: Application.MessageBox('����ʧ�ܣ� ��װ��ʾ�ļ���С����С��29KB��', 'Error', MB_OK + MB_ICONSTOP);
    else begin
      {sMsg := DecodeString(sMsg);
      if False then
        Application.MessageBox(PChar('Code:'+IntToStr(Code) + sMsg), 'Error', MB_OK + MB_ICONSTOP)
      else}
      Application.MessageBox(PChar('ϵͳ�쳣������֪ͨ����Ա���� Code:'+IntToStr(Code)), 'Error', MB_OK + MB_ICONSTOP);
    end;
  end;
  FrmMakeLogin.BtnMakeLogin.Enabled := True;
  FrmMakeLogin.BtnMakeGate.Enabled := True;
  FrmMakeLogin.ProgressBar1.Position := 0;
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
    Result := '';
    {$IF CLIENT_USEPE = 1}
    {$I VM_Start.inc}//WL�������ʶ
    {$IFEND}
    For I := 1 To Length(Text) Do
      Begin
        C := Ord(Text[I]);
        Result := Result + Chr((C Xor 12));
      End;
    {$IF CLIENT_USEPE = 1}
    {$I VM_End.inc}
    {$IFEND}
  End;
var
  sRemoteAddress, sRemoteAddressBak: string;
  IdHTTP: TIdHTTP;
//  s: TStringlist;
  s: string;
  sEngineVersion, str0, Str1,sboClose: string;
  sStr, str2, str3, str4, str5, str6, str7, str8, str9, str10: string;
  str11:string;
begin
  sRemoteAddress := '';
  sRemoteAddressBak:='';
  TempList.Clear;
  Try
    {$IF CLIENT_USEPE = 0}
    asm
      db $EB,$10,'VMProtect begin',0
    end;
    {$IFEND}
    Decode(_sProductAddress,sRemoteAddress);//ָ����վ�ϵ��ļ�
    if sRemoteAddress = '' then Exit;
    Try
      IdHTTP := TIdHTTP.Create(nil);
      IdHTTP.ReadTimeout := 3000;
      try
        S := IdHTTP.Get(sRemoteAddress);
      except
      end;
      if S <> '' then begin
        {$IF g_Version = 1}  //1.76
        sEngineVersion := SetDate(getXmlNodeValue(s, '����.��½��176.��ʶ', ''));
        Str1:= SetDate(_sProductAddress1);
        str0:= getXmlNodeValue(s, '����.��½��176.����', '');
        sboClose:= getXmlNodeValue(s, '����.��½��176.�Ƿ�ر�', '');
        str11:= getXmlNodeValue(s, '����.��½��176.��½���汾��', '');//ȡ��½���汾��
        {$ELSE}
        sEngineVersion := SetDate(getXmlNodeValue(s, '����.������½��.��ʶ', ''));
        Str1:= SetDate(_sProductAddress1);
        str0:= getXmlNodeValue(s, '����.������½��.����', '');
        sboClose:= getXmlNodeValue(s, '����.������½��.�Ƿ�ر�', '');
        str11:= getXmlNodeValue(s, '����.������½��.��½���汾��', '');//ȡ��½���汾��
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
            ), '��ʾ', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
          // if sboClose = '1' then Application.Terminate;
          end;
        end;
        if str11 <> '' then begin
          ExtractStrings(['|'], [], PChar(str11), TempList);
        end else begin
          {$IF g_Version = 1}  //1.76
          TempList.Add('���°�');
          {$ELSE}
          TempList.Add('���°�');
          TempList.Add('0627��');
          {$IFEND}
        end;
      end else begin
        Decode(_sProductAddressBak,sRemoteAddressBak);//��ȡ����վ
        if sRemoteAddressBak = '' then Exit;
        try
          S := IdHTTP.Get(sRemoteAddressBak);
        except
        end;
        if S <> '' then begin
          {$IF g_Version = 1}  //1.76
          sEngineVersion := SetDate(getXmlNodeValue(s, '����.��½��176.��ʶ', ''));
          Str1:= SetDate(_sProductAddress1);
          str0:= getXmlNodeValue(s, '����.��½��176.����', '');
          sboClose:= getXmlNodeValue(s, '����.��½��176.�Ƿ�ر�', '');
          str11:= getXmlNodeValue(s, '����.��½��176.��½���汾��', '');//ȡ��½���汾��
          {$ELSE}
          sEngineVersion := SetDate(getXmlNodeValue(s, '����.������½��.��ʶ', ''));
          Str1:= SetDate(_sProductAddress1);
          str0:= getXmlNodeValue(s, '����.������½��.����', '');
          sboClose:= getXmlNodeValue(s, '����.������½��.�Ƿ�ر�', '');
          str11:= getXmlNodeValue(s, '����.������½��.��½���汾��', '');//ȡ��½���汾��
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
              ), '��ʾ', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
              if sboClose = '1' then Application.Terminate;
            end;
          end;
          if str11 <> '' then begin
            ExtractStrings(['|'], [], PChar(str11), TempList);
          end else begin
            {$IF g_Version = 1}  //1.76
            TempList.Add('���°�');
            {$ELSE}
            TempList.Add('���°�');
            TempList.Add('0627��');
            {$IFEND}
          end;
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

procedure TFrmMain.GetVersionNum(sData: string);
var
  sVersionNum: string;
begin
  {$IF CLIENT_USEPE = 1}
  {$I VM_Start.inc}//WL�������ʶ
  {$ELSE}
  asm
    db $EB,$10,'VMProtect begin',0
  end;
  {$IFEND}
  try
    Decode(g_sVersionNum, sVersionNum);
    if sData <> '' then begin
      if StrToInt(sData) > StrToInt(sVersionNum) then begin
        Application.MessageBox('��ʹ�õ�VIP�������Ǿɰ汾���뵽��ҳ�������°汾��',
          '��ʾ', MB_OK + MB_ICONSTOP + MB_TOPMOST);
        Application.Terminate;
      end;
    end;
  except
  end;
  {$IF CLIENT_USEPE = 1}
  {$I VM_End.inc}
  {$ELSE}
  asm
    db $EB,$0E,'VMProtect end',0
  end;
  {$IFEND}
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  TempList.Free;
  UnLoadFilterItemList;
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  if g_boLogined then begin
    FrmQuerydata := TFrmQuerydata.Create(Application);
    FrmQuerydata.Open();
    FrmQuerydata.Free;
  end;
end;

procedure TFrmMain.FormShow(Sender: TObject);
var
  sProductName: string;
begin
  Decode(g_sProductName, sProductName);
  Caption := sProductName;
end;

end.
