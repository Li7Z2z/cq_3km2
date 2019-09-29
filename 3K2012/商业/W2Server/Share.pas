unit Share;

interface
uses Windows, Classes, SysUtils, JSocket, Controls, ADODB, DB, Md5, StrUtils,Messages;

type
  TConfig = record
    sGateIPaddr: string[30];
    boShowDetailMsg: Boolean;
    GateCriticalSection: TRTLCriticalSection;
    dwProcessGateTick: LongWord;
    dwProcessGateTime: LongWord;
    GateList: TList;
  end;
  pTConfig = ^TConfig;

  TLoginGateInfo = record
    Socket: TCustomWinSocket;
    sIPaddr: string;
    nPort: Integer;
    sReceiveMsg: string;
    nSuccesCount: Integer;
    nFailCount: Integer;
    UserList: TList;
    dwKeepAliveTick: LongWord;
  end;
  pTLoginGateInfo = ^TLoginGateInfo;

  TM2UserInfo = record
    Socket: TCustomWinSocket;
    sUserIPaddr: string; //�û�IP
    sSockIndex: string;  //ͨѶ��ʵ
    sReceiveMsg: string;//���յ���Ϣ
    dwClientTick: LongWord;
    dwKickTick: LongWord;
    boKick: Boolean;
    sAccount: string;
    sPassWord: string;
    boLogined: Boolean; //�Ƿ��Ѿ���½
  end;
  pTM2UserInfo = ^TM2UserInfo;
const
  USERMAXSESSION = 1000; //�û����������
  sPrice = 200; //����ע���½���۸�
  sM2Price = 220;//����ע��M2�۸�(����)
  sM2PriceMonth = 70;//����ע��M2�۸�(����) 20110712
  tW2Server= 0;
var
  g_boCanStart: Boolean;
  g_dwServerStartTick: LongWord;
  g_Config: pTConfig;
  UserSessionCount: Integer; //0x32C �û����ӻỰ��
  g_btMaxDayMakeNum: Integer = 10; //ÿ��������ɴ���
  g_sGateVersionNum: string = ''; //���ذ汾��
  g_sLoginVersionNum: string = ''; //��½���汾��
  g_s176GateVersionNum: string = ''; //1.76���ذ汾��
  g_s176LoginVersionNum: string = ''; //1.76��½���汾��
  g_sLoginVersion: string = '';//��¼���������汾��
  g_sM2Version: string = '';//M2�������汾��
  g_s176LoginVersion: string = ''; //1.76��½���������汾��
  g_s176M2Version: string = ''; //1.76M2�������汾��
  g_nW2Version: integer = 20090830;//�����������汾��
  g_sSqlConnect: string;//���ݿ�����
  MakeSockeMsgList: TStringList; //����������������Ϣ�б�
  sProcMsg: string = '';
  boGateReady: Boolean = False;//�Ƿ������ɷ���������
  boServiceStart: Boolean = False;//�����Ƿ�����
  g_dwStartTick: LongWord; //�������
  g_ServerIp: string='127.0.0.1';
  g_ServerPort: Integer=37002;

  g_dwGameCenterHandle: THandle;
function CheckUserExist (str, sAccount: string): Boolean;
function CheckUserExist1(str, sAccount: string; nM2Type: Byte): Boolean;
function MaxCurr(Val1, Val2: Currency): Currency;
function CheckMaXID(Ado: TADOQuery; str: string): Integer;
function UserLogined(sLoginID: string; GateInfo: pTLoginGateInfo): Boolean;
//procedure CheckUserTime(UserName: string);
//procedure MainOutMessage(sMsg: string);

Function RivestStr1(Str:String):String;//������MD5
function IsIPAddr(IP: string): Boolean;//���IP��ַ�Ƿ���Ч

procedure AddUserTips(DLUserName,UserName,ZT: string; Yue: Currency);//������־

procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
implementation
uses DM;
//����û��Ƿ����
//strΪ����
//����ֵ True Ϊ��������û�
function CheckUserExist(str, sAccount: string): Boolean;
var
  Ado: TADOQuery;
begin
  Ado := TADOQuery.Create(nil);
  Ado.Connection := FrmDm.ADOconn;
  try
    with Ado do begin
       Close;
       SQL.Clear;
       SQL.Add('Select User from '+str+' where [User] =:a0');
       Parameters.ParamByName('a0').DataType:=Ftstring;
       Parameters.ParamByName('a0').Value :=Trim(sAccount);
       Open;
       if RecordCount <> 0 then Result := True
       else Result := False;
    end;
  finally
    Ado.Free;
    FrmDm.ADOconn.Close;
  end;
end;

function CheckUserExist1(str, sAccount: string; nM2Type: Byte): Boolean;
var
  Ado: TADOQuery;
begin
  Ado := TADOQuery.Create(nil);
  Ado.Connection := FrmDm.ADOconn;
  try
    with Ado do begin
       Close;
       SQL.Clear;
       SQL.Add('Select User from '+str+' where [User] =:a0 and M2Type=:a1');
       Parameters.ParamByName('a0').DataType:=Ftstring;
       Parameters.ParamByName('a0').Value :=Trim(sAccount);
       Parameters.ParamByName('a1').DataType:= FtInteger;
       Parameters.ParamByName('a1').Value := nM2Type;
       Open;
       if RecordCount <> 0 then Result := True
       else Result := False;
    end;
  finally
    Ado.Free;
    FrmDm.ADOconn.Close;
  end;
end;

//ȡ����ID��,
function CheckMaXID(Ado: TADOQuery; str: string): Integer;
begin
  try
    with Ado do begin
       Close;
       SQL.Clear;
       SQL.Add('Select Max(ID) as a from '+str);
       Open;
       IF Ado.Fields[0].AsInteger=0 then Result := 1
       Else Result:=Ado.Fields[0].AsInteger+1;
    end;
  finally
  end;
end;
{//�Ƚϵ�½ʱ��,��Ϊ��ǰ����,���ÿ�����ɴ�����ʼ
procedure CheckUserTime(UserName: string);
var
  Ado: TADOQuery;
begin
  Ado := TADOQuery.Create(nil);
  Ado.Connection := FrmDm.ADOconn;
  try
    with Ado do begin
       Close;
       SQL.Clear;
       SQL.Add('SELECT * FROM UserInfo where (datediff(dd,Timer,:a1) = 0) and [User]=:a2 ');
       parameters.ParamByName('a1').DataType:=Ftstring;
       parameters.ParamByName('a1').Value := DateToStr(now);
       parameters.ParamByName('a2').DataType :=Ftstring;
       parameters.ParamByName('a2').Value := Trim(UserName);
       Open;
       IF Ado.RecordCount = 0 then begin
          Close;
          SQL.Clear;
          SQL.Add('Update UserInfo set dayMakeNum=:a1 Where [User]=:a2') ;
          parameters.ParamByName('a1').DataType:=FtInteger;
          parameters.ParamByName('a1').Value := 0;
          parameters.ParamByName('a2').DataType :=Ftstring;
          parameters.ParamByName('a2').Value := Trim(UserName);
          ExecSQL;
       end;
    end;
  finally
    Ado.Free;
  end;
end;  }

//������־
//ZT 1-�޸Ĵ��������  2-ע��1.76��½���û� 3-ע���û�(��½��) 4-ע����� 5-�û��޸����� 6-�����޸�����
//   7-M2ע���û�,�û�����(���) 8-1.76M2ע��,�û�����(���)  9-M2�û��޸����� 10-1.76M2�޸�Ӳ����Ϣ 12-�û��޸�Ӳ����Ϣ  13-�һ�����
//   14-VIP��� 15-M2ע���û�,�û�����(�°�)  16-1.76M2ע��,�û�����(�°�)
procedure AddUserTips(DLUserName,UserName,ZT: string; Yue: Currency);
var
  Ado: TADOQuery;
begin
  Ado := TADOQuery.Create(nil);
  Ado.Connection := FrmDm.ADOconn;
  try
    with Ado do begin
      Close;
      SQL.Clear;
      SQL.Add('EXEC ADDTips :a1,:a2,:a3,:a4') ;
      parameters.ParamByName('a1').DataType:=Ftstring;
      parameters.ParamByName('a1').Value := Trim(DLUserName);
      parameters.ParamByName('a2').DataType :=Ftstring;
      parameters.ParamByName('a2').Value := Trim(UserName);
      parameters.ParamByName('a3').DataType :=FtCurrency;
      parameters.ParamByName('a3').Value := Yue;
      parameters.ParamByName('a4').DataType :=Ftstring;
      parameters.ParamByName('a4').Value := ZT;
      ExecSQL;
    end;
  finally
    Ado.Free;
    FrmDm.ADOconn.Close;
  end;
end;

function MaxCurr(Val1, Val2: Currency): Currency;
begin
  if Val1>=Val2 then Result := Val1 else Result := Val2;
end;

function UserLogined(sLoginID: string; GateInfo: pTLoginGateInfo): Boolean;
var
  UserInfo: pTM2UserInfo;
  I: Integer;
begin
  Result := False;
  for I := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[I];
    if (UserInfo.sAccount = sLoginID) then begin
      UserInfo.boKick := True;          //T���û�
      UserInfo.dwKickTick := GetTickCount + 5000; //T���û�
      Result := True;
    end;
  end;
end;

//-------------------------------------------------------------------------
Function RivestStr1(Str:String):String;
var
  dcpMD5: TDCP_md5;
  Len,i:integer;
  HashDigest:array[0..31]of   byte;
  MiWen:String;
begin
  dcpMD5:=TDCP_md5.Create(nil);
  try
    dcpMD5.Init;
    dcpMD5.UpdateStr(Str);
    dcpMD5.Final(HashDigest);
    Len:=dcpMD5.HashSize;
    MiWen:='';
    //For i:=0  to ((Len div 8)-1) do//����MD5
    For i:=((Len div 8)-1) downto 0 do//������MD5
        MiWen:=MiWen+IntToHex(HashDigest[i],2);
    Result:=MiWen;
  Finally
    dcpMD5.Free;
  end;
end;

{/////////////////////////////////////////////////////////
  ��  ��:  ���IP��ַ�Ƿ���Ч
  ��  ��:  �ַ���
  ����ֵ:  �ɹ�:  True  ʧ��: False;
  �� ע:   uses StrUtils
////////////////////////////////////////////////////////}
function IsIPAddr(IP: string): Boolean;
var
  Node: array[0..3] of Integer;
  tIP: string;
  tNode: string;
  tPos: Integer;
  tLen: Integer;
begin
  Result := False;
  tIP := IP;
  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[0]) then Exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[1]) then Exit;

  tLen := Length(tIP);
  tPos := Pos('.', tIP);
  tNode := MidStr(tIP, 1, tPos - 1);
  tIP := MidStr(tIP, tPos + 1, tLen - tPos);
  if not TryStrToInt(tNode, Node[2]) then Exit;

  if not TryStrToInt(tIP, Node[3]) then Exit;
  for tLen := Low(Node) to High(Node) do begin
    if (Node[tLen] < 0) or (Node[tLen] > 255) then Exit;
  end;
  Result := True;
end;

procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  SendData:TCopyDataStruct;
  nParam:Integer;
begin
  nParam:=MakeLong(Word(tW2Server),wIdent);
  SendData.cbData:=Length (sSendMsg) + 1;
  GetMem(SendData.lpData,SendData.cbData);
  StrCopy (SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle,WM_COPYDATA,nParam,Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;
end.
