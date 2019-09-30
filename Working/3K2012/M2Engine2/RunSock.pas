unit RunSock;
//������Rungate��ص�����
interface
uses
  Windows, Classes, SysUtils, StrUtils, SyncObjs, JSocket, ObjBase, Grobal2,
  FrnEngn, UsrEngn, Common, SDK;
const
  RunGateUsesThread = 1; //��1��ʹ���߳� By TasNat at: 2012-03-19 20:08:33
type
  TGateInfo = record
    Socket: TCustomWinSocket;
    boUsed: Boolean;//�����Ƿ�������
    sAddr: string[15];//����IP
    nPort: Integer;//�˿�

    UserList: TList;
    nUserCount: Integer; //��������
    RecvBuffer: PChar;
    nBuffLen: Integer;
    BufferList: TList;
    //TempBufferList: TGList;
    boSendKeepAlive: Boolean;
    nSendChecked: Integer;
    nSendBlockCount: Integer;
    nSendMsgCount: Integer;//�ж�����
    nSendRemainCount: Integer;//ʣ������
    dwSendTick: LongWord;
    nSendMsgBytes: Integer;
    nSendBytesCount: Integer;//���͵��ֽ�����
    nSendedMsgCount: Integer;//��������
    nSendCount: Integer;//��������
    dwSendCheckTick: LongWord;
  end;
  pTGateInfo = ^TGateInfo;
  TGateUserInfo = record
    sAccount: string;
    sCharName: string;
    sIPaddr: string;
    //sMac: string; //Mac���� Mac����û��..
    nSocket: Integer;
    nGSocketIdx: Integer;
    nSessionID: Integer;
    nClientVersion: Integer;
    UserEngine: TUserEngine;
    FrontEngine: TFrontEngine;
    PlayObject: TPlayObject;
    SessInfo: pTSessInfo;
    dwNewUserTick: LongWord;
    boCertification: Boolean;
  end;
  pTGateUserInfo = ^TGateUserInfo;

  TRunSocket = class{$If RunGateUsesThread =1}(TThread){$ifend}
    m_RunSocketSection: TRTLCriticalSection;
    m_RunAddrList: TStringList;
    //n8: Integer;//20090818 ע��
    //m_IPaddrArr: array[0..19] of TIPaddr; //20090818 ע��
    n4F8: Integer;
    dwSendTestMsgTick: LongWord;
    m_nErrorCount: Integer;
  private
    procedure LoadRunAddr;
    procedure ExecGateBuffers(nGateIndex: Integer; Gate: pTGateInfo; Buffer: PChar; nMsgLen: Integer);
    procedure DoClientCertification(GateIdx: Integer; GateUser: pTGateUserInfo; nSocket: Integer; sMsg: string);
    procedure ExecGateMsg(GateIdx: Integer; Gate: pTGateInfo; MsgHeader: pTMsgHeader; MsgBuff: PChar; nMsgLen: Integer);
    procedure SendCheck(Socket: TCustomWinSocket; nIdent: Integer);
    function OpenNewUser(nSocket: Integer; nGSocketIdx: Integer; sIPaddr: string; UserList: TList): Integer;
    procedure SendNewUserMsg(Socket: TCustomWinSocket; nSocket: Integer; nSocketIndex, nUserIdex: Integer);
    procedure SendGateTestMsg(nIndex: Integer);
    function SendGateBuffers(GateIdx: Integer; Gate: pTGateInfo; MsgList: TList): Boolean;
    //function GetGateAddr(sIPaddr: string): string;//20090818 ע��
    //procedure SendScanMsg(DefMsg: pTDefaultMessage; sMsg: string; nGateIdx, nSocket, nGsIdx: Integer);//20100911 ע��
  {$If RunGateUsesThread =1}
  protected
    procedure Execute; override;
  {$Ifend RunGateUsesThread}
  public
    constructor Create();
    destructor Destroy; override;
    procedure AddGate(Socket: TCustomWinSocket);
    procedure SocketRead(Socket: TCustomWinSocket);
    procedure CloseGate(Socket: TCustomWinSocket);
    procedure CloseErrGate(Socket: TCustomWinSocket; var ErrorCode: Integer);
    //procedure CloseAllGate();//�ر���������
    procedure Run();
    procedure CloseUser(GateIdx, nSocket: Integer);
    function AddGateBuffer(GateIdx: Integer; Buffer: PChar): Boolean;
    procedure SendOutConnectMsg(nGateIdx, nSocket, nGsIdx: Integer);
    procedure SetGateUserList(nGateIdx, nSocket: Integer; PlayObject: TPlayObject);
    procedure KickUser(sAccount: string; nSessionID: Integer; nCode: byte);
  end;
var
  g_GateArr: array[0..7{19}] of TGateInfo;//20090818 �޸ģ�ֻ����8������
  g_nGateRecvMsgLenMin: Integer;
  g_nGateRecvMsgLenMax: Integer;
implementation

uses M2Share, IdSrvClient, HUtil32, EDcode, EDcodeUnit;

var
  nRunSocketRun: Integer = -1;
  nExecGateBuffers: Integer = -1;
  { TRunSocket }

procedure TRunSocket.AddGate(Socket: TCustomWinSocket);
var
  I: Integer;
  sIPaddr: string;
  Gate: pTGateInfo;
resourcestring
  sGateOpen = '��Ϸ����[%d](%s:%d)�Ѵ�...';
  sKickGate = '������δ����: %s';
begin
  try
    sIPaddr := Socket.RemoteAddress;
    if boStartReady then begin
      for I := Low(g_GateArr) to High(g_GateArr) do begin
        Gate := @g_GateArr[I];
        if Gate.boUsed then Continue;
        Gate.boUsed := True;
        Gate.Socket := Socket;
        Gate.sAddr := {GetGateAddr(sIPaddr)}sIPaddr;//20090818 �޸�
        Gate.nPort := Socket.RemotePort;
        Gate.UserList := TList.Create;
        Gate.nUserCount := 0;
        Gate.RecvBuffer := nil;
        Gate.nBuffLen := 0;
        Gate.BufferList := TList.Create;
        //Gate.TempBufferList := TGList.Create;
        Gate.boSendKeepAlive := False;
        Gate.nSendChecked := 0;
        Gate.nSendBlockCount := 0;
        MainOutMessage(Format(sGateOpen, [I, Socket.RemoteAddress, Socket.RemotePort]));
        Break;
      end;
    end else begin
      MainOutMessage(Format(sKickGate, [sIPaddr]));
      Socket.Close;
    end;
  except
    MainOutMessage(Format('{%s} TRunSocket.AddGate',[g_sExceptionVer]));
  end;
end;
{//�ر���������
procedure TRunSocket.CloseAllGate;
var
  GateIdx: Integer;
  Gate: pTGateInfo;
begin
  for GateIdx := Low(g_GateArr) to High(g_GateArr) do begin
    Gate := @g_GateArr[GateIdx];
    if Gate.Socket <> nil then begin
      Gate.Socket.Close;
    end;
  end;
end;  }
     
procedure TRunSocket.CloseErrGate(Socket: TCustomWinSocket;
  var ErrorCode: Integer);
begin
  try
    if Socket.Connected then Socket.Close;
    ErrorCode := 0;
  except
    MainOutMessage(Format('{%s} TRunSocket.CloseErrGate',[g_sExceptionVer]));
  end;
end;
{$If RunGateUsesThread =1}
procedure TRunSocket.Execute;
begin
  while not Terminated do begin
    Run;
    Sleep(10);
  end;
end;
{$Ifend RunGateUsesThread =1}
procedure TRunSocket.CloseGate(Socket: TCustomWinSocket);
var
  I, GateIdx: Integer;
  GateUser: pTGateUserInfo;
  UserList: TList;
  Gate: pTGateInfo;
resourcestring
  sGateClose = '��Ϸ����[%d](%s:%d)�ѹر�...';
begin
  try
    EnterCriticalSection(m_RunSocketSection);
    try
      for GateIdx := Low(g_GateArr) to High(g_GateArr) do begin
        Gate := @g_GateArr[GateIdx];
        if Gate.Socket = Socket then begin
          UserList := Gate.UserList;
          if UserList.Count > 0 then begin//20091113 ����
            for I := 0 to UserList.Count - 1 do begin
              GateUser := UserList.Items[I];
              if GateUser <> nil then begin
                if GateUser.PlayObject <> nil then begin
                  TPlayObject(GateUser.PlayObject).m_boEmergencyClose := True;
                  TPlayObject(GateUser.PlayObject).m_boPlayOffLine := False;
                  if not TPlayObject(GateUser.PlayObject).m_boReconnection then begin
                    FrmIDSoc.SendHumanLogOutMsg(GateUser.sAccount, GateUser.nSessionID);
                  end;
                end;
                Dispose(GateUser);
                UserList.Items[I] := nil;
              end;
            end;//for
          end;
          Gate.UserList.Free;
          Gate.UserList := nil;
          if Gate.RecvBuffer <> nil then FreeMem(Gate.RecvBuffer);
          Gate.RecvBuffer := nil;
          Gate.nBuffLen := 0;
          if Gate.BufferList.Count > 0 then begin//20091113 ����
            for I := 0 to Gate.BufferList.Count - 1 do begin
              FreeMem(Gate.BufferList.Items[I]);
            end;
          end;
          Gate.BufferList.Free;
          Gate.BufferList := nil;

          {if Gate.TempBufferList.Count > 0 then begin//20091113 ����
            for I := 0 to Gate.TempBufferList.Count - 1 do begin
              FreeMem(Gate.TempBufferList.Items[I]);
            end;
          end;
          Gate.TempBufferList.Free;
          Gate.TempBufferList := nil; }

          Gate.boUsed := False;
          Gate.Socket := nil;
          MainOutMessage(Format(sGateClose, [GateIdx, Socket.RemoteAddress, Socket.RemotePort]));
          Break;
        end;
      end;
    finally
      LeaveCriticalSection(m_RunSocketSection);
    end;
  except
    MainOutMessage(Format('{%s} TRunSocket.CloseGate',[g_sExceptionVer]));
  end;
end;

procedure TRunSocket.ExecGateBuffers(nGateIndex: Integer; Gate: pTGateInfo; Buffer: PChar; nMsgLen: Integer);
var
  nLen: Integer;
  Buff: PChar;
  MsgBuff: PChar;
  MsgHeader: pTMsgHeader; {Size 20}
  nCheckMsgLen: Integer;
  TempBuff: PChar;
resourcestring
  sExceptionMsg1 = '{%s} TRunSocket::ExecGateBuffers -> pBuffer';
  sExceptionMsg2 = '{%s} TRunSocket::ExecGateBuffers -> @pwork,ExecGateMsg ';
  sExceptionMsg3 = '{%s} TRunSocket::ExecGateBuffers -> FreeMem';
begin
  nLen := 0;
  Buff := nil;
  {$If RunGateUsesThread =1}
  try
  EnterCriticalSection(m_RunSocketSection);
  {$Ifend RunGateUsesThread =1} 
  try
    if (Buffer = nil) or (nMsgLen <= 0) then Exit;//20100910 ���ӣ��ο�JS
    if Buffer <> nil then begin
      ReAllocMem(Gate.RecvBuffer, Gate.nBuffLen + nMsgLen);
      Move(Buffer^, Gate.RecvBuffer[Gate.nBuffLen], nMsgLen);
    end;
  except
    MainOutMessage(format(sExceptionMsg1,[g_sExceptionVer]));
    Exit;//20100910 ���ӣ��ο�JS
  end;
  try
    nLen := Gate.nBuffLen + nMsgLen;
    Buff := Gate.RecvBuffer;
    if nLen >= SizeOf(TMsgHeader) then begin
      while (True) do begin
        try//20101126 ��ֹ��ѭ��
          MsgHeader := pTMsgHeader(Buff);
          nCheckMsgLen := abs(MsgHeader.nLength) + SizeOf(TMsgHeader);
          if (MsgHeader.dwCode = RUNGATECODE) and (nCheckMsgLen < $8000) then begin
            if nLen < nCheckMsgLen then Break;
            MsgBuff := Buff + SizeOf(TMsgHeader); //Jacky 1009 ����
            ExecGateMsg(nGateIndex, Gate, MsgHeader, MsgBuff, MsgHeader.nLength);
            Buff := Buff + SizeOf(TMsgHeader) + MsgHeader.nLength; //Jacky 1009 ����
            nLen := nLen - (MsgHeader.nLength + SizeOf(TMsgHeader));
          end else begin
            Inc(Buff);
            Dec(nLen);
          end;
        except
          Break;
        end;
        if nLen < SizeOf(TMsgHeader) then Break;
      end;
    end;
  except
    MainOutMessage(format(sExceptionMsg2,[g_sExceptionVer]));
    Exit;//20100910 ���ӣ��ο�JS
  end;
  try
    if nLen > 0 then begin
      GetMem(TempBuff, nLen);
      Move(Buff^, TempBuff^, nLen);
      FreeMem(Gate.RecvBuffer);
      Gate.RecvBuffer := TempBuff;
      Gate.nBuffLen := nLen;
    end else begin
      FreeMem(Gate.RecvBuffer);
      Gate.RecvBuffer := nil;
      Gate.nBuffLen := 0;
    end;
  except
    MainOutMessage(format(sExceptionMsg3,[g_sExceptionVer]));
  end;

  
  {$If RunGateUsesThread =1}
  finally
    LeaveCriticalSection(m_RunSocketSection);
  end;
  {$Ifend RunGateUsesThread =1}
end;

procedure TRunSocket.SocketRead(Socket: TCustomWinSocket);
var
  nMsgLen, GateIdx: Integer;
  Gate: pTGateInfo;
{$IF SOCKETTYPE = 0}
  RecvBuffer: array[0..DATA_BUFSIZE * 2 - 1] of Char;
{$ELSEIF SOCKETTYPE = 1}
  RecvBuffer: PChar;
{$IFEND}
 // nLoopCheck: Integer;
resourcestring
  sExceptionMsg1 = '{%s} TRunSocket::SocketRead';
begin
  Try
    for GateIdx := Low(g_GateArr) to High(g_GateArr) do begin
      Gate := @g_GateArr[GateIdx];
      if Gate <> nil then begin//20090507 ����
        if Gate.Socket = Socket then begin
          try
    {$IF SOCKETTYPE = 0}
            while (True) do begin
              nMsgLen := Socket.ReceiveBuf(RecvBuffer, SizeOf(RecvBuffer));
              if nMsgLen <= 0 then Break;
              ExecGateBuffers(GateIdx, Gate, @RecvBuffer, nMsgLen);
            end;
    {$ELSEIF SOCKETTYPE = 1}
            nMsgLen := Socket.ReceiveLength;
            GetMem(RecvBuffer, nMsgLen);
            Socket.ReceiveBuf(RecvBuffer^, nMsgLen);
            ExecGateBuffers(GateIdx, Gate, RecvBuffer, nMsgLen);
            FreeMem(RecvBuffer);
    {$IFEND}      
          except
    {$IF SOCKETTYPE = 1}
            if RecvBuffer <> nil then FreeMem(RecvBuffer);
    {$IFEND}
            MainOutMessage(format(sExceptionMsg1,[g_sExceptionVer]));
          end;
          Break;//�˳�ѭ�� By TasNat at: 2012-03-17 12:55:30
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TRunSocket::SocketRead1',[g_sExceptionVer]));
  end;
end;

procedure TRunSocket.Run;
var
  dwRunTick: LongWord;
  I, {II,} II: Integer;
  Gate: pTGateInfo;
  Buffer: PChar;
  nCode: byte;
  Tick : DWord;
resourcestring
  sExceptionMsg = '{%s} TRunSocket::Run Code:%d';
begin
  dwRunTick := GetTickCount();
  if boStartReady then begin
    nCode:= 0 ;
    try
      {$IF TESTMODE = 1}
      if g_Config.nGateLoad > 0 then begin//���ز���
        if (GetTickCount - dwSendTestMsgTick) >= 100 then begin
          dwSendTestMsgTick := GetTickCount();
          for I := Low(g_GateArr) to High(g_GateArr) do begin
            Gate := @g_GateArr[I];
            if Gate.BufferList <> nil then begin
              for II := 0 to g_Config.nGateLoad - 1 do SendGateTestMsg(I);
            end;
          end;
        end;
      end;
      {$IFEND}
      //20100913 ע��
      (*for I := Low(g_GateArr) to High(g_GateArr) do begin //2007-01-21����40����û��½�ɹ��û�������
        Gate := @g_GateArr[I];
        nCode:= 6;
        if Gate.UserList <> nil then begin
          EnterCriticalSection(m_RunSocketSection);
          try
            nCode:= 7;
            for II := Gate.UserList.Count - 1 downto 0 do begin
              nCode:= 8;
              if Gate.UserList.Items[II] <> nil then begin
                nCode:= 9;
                GateUser := Gate.UserList.Items[II];
                if GateUser <> nil then begin
                  nCode:= 10;
                  if (GetTickCount - GateUser.dwNewUserTick > 40000{1000 * 40}) and not GateUser.boCertification then begin
                    nCode:= 11;
                    CloseUser(I, GateUser.nSocket);
                    nCode:= 12;
                    SendOutConnectMsg(I, GateUser.nSocket, GateUser.nGSocketIdx);
                  end;
                end;
              end;
            end;//for
          finally
            LeaveCriticalSection(m_RunSocketSection);
          end;
        end;
      end;  *)
      nCode:= 14;
      for I := Low(g_GateArr) to High(g_GateArr) do begin
        Gate := @g_GateArr[I];
        nCode:= 15;
        if Gate <> nil then begin//20090722 ����
          if Gate.BufferList <> nil then begin
            EnterCriticalSection(m_RunSocketSection);
            try
              Gate.nSendMsgCount := Gate.BufferList.Count;
              nCode:= 17;
              SendGateBuffers(I, Gate, Gate.BufferList);
              Gate.nSendRemainCount := Gate.BufferList.Count;
            finally
              LeaveCriticalSection(m_RunSocketSection);
            end;
          end;
        end;
      end;
      nCode:= 18;
      for I := Low(g_GateArr) to High(g_GateArr) do begin
        nCode:= 19;
        if g_GateArr[I].Socket <> nil then begin
          Gate := @g_GateArr[I];
          nCode:= 20;
          if (GetTickCount - Gate.dwSendTick) >= 1000 then begin
            Gate.dwSendTick := GetTickCount();
            Gate.nSendMsgBytes := Gate.nSendBytesCount;
            Gate.nSendedMsgCount := Gate.nSendCount;
            Gate.nSendBytesCount := 0;
            Gate.nSendCount := 0;
          end;
          nCode:= 21;
          if Gate.boSendKeepAlive then begin
            Gate.boSendKeepAlive := False;
            nCode:= 22;
            SendCheck(Gate.Socket, GM_CHECKSERVER);//����Rungate.exe���������Ƿ�����
          end;
        end;
      end;
      //��������߳��ﴦ��
      {$If RunGateUsesThread =1}
      {for I := Low(g_GateArr) to High(g_GateArr) do begin
        nCode:= 30;
        Gate := @g_GateArr[I];
        if (Gate.Socket <> nil) and (Gate.TempBufferList <> nil) and (Gate.BufferList <> nil) then begin
          nCode:= 31;
          try
            Gate.TempBufferList.Lock;
            Tick := GetTickCount;
            //������AddBuf�ķ������ԼӸ�ʱ����
            while Gate.TempBufferList.Count > 0 do begin
              Buffer := Gate.TempBufferList[0];
              Gate.BufferList.Add(Buffer);
              Gate.TempBufferList.Delete(0);
              if GetTickCount - Tick > 100 then Break;
            end;
          finally
            Gate.TempBufferList.UnLock;
          end;
        end;
      end;  }
      {$Ifend RunGateUsesThread =1}
    except
      on E: Exception do begin
        MainOutMessage(format(sExceptionMsg,[g_sExceptionVer, nCode]));
      end;
    end;
  end;
  g_nSockCountMin := GetTickCount - dwRunTick;
  if g_nSockCountMin > g_nSockCountMax then g_nSockCountMax := g_nSockCountMin;
end;
//�ͻ�����֤ TfrmMain.SendRunLogin
procedure TRunSocket.DoClientCertification(GateIdx: Integer; GateUser: pTGateUserInfo; nSocket: Integer; sMsg: string);
  function GetCertification(sMsg: string; var sAccount: string; var sChrName: string; var nSessionID: Integer; var nClientVersion: Integer; var boFlag: Boolean; var nRandomKey: Integer): Boolean; //004E0DE0
  var
    sData, sCodeStr, sClientVersion, sIdx: string;
  begin
    Result := False;
    try
      sData := DeCodeString(sMsg);
      if (Length(sData) > 2) and (sData[1] = '*') and (sData[2] = '*') then begin
        sData := Copy(sData, 3, Length(sData) - 2);
        sData := GetValidStr3(sData, sAccount, ['/']);
        sData := GetValidStr3(sData, sChrName, ['/']);
        sData := GetValidStr3(sData, sCodeStr, ['/']);
        sData := GetValidStr3(sData, sClientVersion, ['/']);
        sData := GetValidStr3(sData, sIdx, ['/']);
        nRandomKey := Str_ToInt(sData, 0);
        nSessionID := Str_ToInt(sCodeStr, 0);
        if sIdx = '0' then begin
          boFlag := True;
        end else begin
          boFlag := False;
        end;
        if (sAccount <> '') and (sChrName <> '') and (nSessionID >= 2) then begin
          nClientVersion := Str_ToInt(sClientVersion, 0);
          Result := True;
        end;
      end;
    except
      MainOutMessage(format('{%s} TRunSocket::DoClientCertification -> GetCertification',[g_sExceptionVer]));
    end;
  end;
var
  nCheckCode: Integer;
  sData, sAccount, sChrName: string;
  nSessionID, nRandomKey: Integer;
  boFlag: Boolean;
  nClientVersion: Integer;
  nPayMent, nPayMode: Integer;
  dwHCode : DWord;//������
  SessInfo: pTSessInfo;
  PlayObject: TPlayObject;
  I: Integer;
resourcestring
  sExceptionMsg = '{%s} TRunSocket::DoClientCertification CheckCode:%d';
  sDisable = '*disable*';
begin
  nCheckCode := 0;
  try
    if GateUser.sAccount = '' then begin
      if TagCount(sMsg, '!') > 0 then begin
        sData := ArrestStringEx(sMsg, '#', '!', sMsg);
        sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
        if GetCertification(sMsg, sAccount, sChrName, nSessionID, nClientVersion, boFlag, nRandomKey) then begin
          SessInfo := FrmIDSoc.GetAdmission(sAccount, GateUser.sIPaddr, nSessionID, dwHCode, nPayMode, nPayMent);
          if (SessInfo <> nil) and (dwHCode > 0) and (nPayMent > 0) then begin
            PlayObject := UserEngine.GetPlayObjectExOfAutoGetExp(Trim(sAccount));
            if PlayObject <> nil then begin //���߹һ�����ֱ�ӵ�½��Ϸ
              if CompareText(PlayObject.m_sCharName, Trim(sChrName)) = 0 then begin
                PlayObject.m_boGhost := False;
                PlayObject.m_boDeath := False;

                PlayObject.m_boEmergencyClose := False;
                PlayObject.m_boSwitchData := False;
                PlayObject.m_boReconnection := False;
                PlayObject.m_boKickFlag := False;
                PlayObject.m_boSoftClose := False;
                PlayObject.m_dwHCode := dwHCode;

                PlayObject.m_dwSaveRcdTick := GetTickCount();
                PlayObject.m_boWantRefMsg := True;
                PlayObject.m_boDieInFight3Zone := False;
                PlayObject.m_Script := nil;
                PlayObject.m_boTimeRecall := False;
                PlayObject.m_sMoveMap := '';
                PlayObject.m_nMoveX := 0;
                PlayObject.m_nMoveY := 0;
                PlayObject.m_dwRunTick := GetTickCount();
                PlayObject.m_nRunTime := 250;
                PlayObject.m_dwSearchTime := 1000;
                PlayObject.m_dwSearchTick := GetTickCount();
                PlayObject.m_nViewRange := 12;
                PlayObject.m_boNewHuman := False;
                PlayObject.m_boLoginNoticeOK := False;
                PlayObject.bo6AB := False;
                PlayObject.m_boExpire := False;
                PlayObject.m_boSendNotice := False;
                PlayObject.m_dwCheckDupObjTick := GetTickCount();
                PlayObject.dwTick578 := GetTickCount();
                PlayObject.m_boInSafeArea := False;
                PlayObject.m_dwMagicAttackTick := GetTickCount();
                PlayObject.m_dwMagicAttackInterval := 0;
                PlayObject.m_dwAttackTick := GetTickCount();
                PlayObject.m_dwMoveTick := GetTickCount();
                PlayObject.m_dwTurnTick := GetTickCount();
                PlayObject.m_dwActionTick := GetTickCount();
                PlayObject.m_dwAttackCount := 0;
                PlayObject.m_dwAttackCountA := 0;
                PlayObject.m_dwMagicAttackCount := 0;
                PlayObject.m_dwMoveCount := 0;
                PlayObject.m_dwMoveCountA := 0;
                PlayObject.m_nOverSpeedCount := 0;

                //PlayObject.m_sOldSayMsg := '';//δʹ�� 20080329
                PlayObject.m_dwSayMsgTick := GetTickCount();
                PlayObject.m_boDisableSayMsg := False;
                PlayObject.m_dwDisableSayMsgTick := GetTickCount();
                PlayObject.m_dLogonTime := Now();
                PlayObject.m_dwLogonTick := GetTickCount();
                PlayObject.m_boSwitchData := False;
                PlayObject.m_boSwitchDataSended := False;
                PlayObject.m_nWriteChgDataErrCount := 0;
                PlayObject.m_dwShowLineNoticeTick := GetTickCount();
                PlayObject.m_nShowLineNoticeIdx := 0;
                //PlayObject.m_nSoftVersionDateEx := 0;

                //PlayObject.m_nKillMonExpRate := PlayObject.m_nKillMonExpRate;//20080607  20090813ע��
                //PlayObject.m_nOldKillMonExpRate := PlayObject.m_nKillMonExpRate;//20080608  20090813ע��
                PlayObject.m_dwRateTick := GetTickCount();
                PlayObject.m_nPowerRate := 100;

                PlayObject.m_boSetStoragePwd := False;
                PlayObject.m_boReConfigPwd := False;
                PlayObject.m_boCheckOldPwd := False;
                PlayObject.m_boUnLockPwd := False;
                PlayObject.m_boUnLockStoragePwd := False;
                PlayObject.m_boPasswordLocked := False; //���ֿ�
                PlayObject.m_btPwdFailCount := 0;

                PlayObject.m_boFilterSendMsg := False;

                PlayObject.m_boCanDeal := True;
                PlayObject.m_boCanDrop := True;
                PlayObject.m_boCanGetBackItem := True;
                PlayObject.m_boCanWalk := True;
                PlayObject.m_boCanRun := True;
                PlayObject.m_boCanHit := True;
                PlayObject.m_boCanSpell := True;
                PlayObject.m_boCanUseItem := True;
                PlayObject.m_nMemberType := 0;
                PlayObject.m_nMemberLevel := 0;

                PlayObject.m_boDecGameGold := False;
                PlayObject.m_nDecGameGold := 1;
                PlayObject.m_dwDecGameGoldTick := GetTickCount();
                PlayObject.m_dwDecGameGoldTime := 60000{60 * 1000};

                PlayObject.m_boIncGameGold := False;
                PlayObject.m_nIncGameGold := 1;
                PlayObject.m_dwIncGameGoldTick := GetTickCount();
                PlayObject.m_dwIncGameGoldTime := 60000{60 * 1000};

                PlayObject.m_dwIncGamePointTick := GetTickCount();
                PlayObject.m_dwDecGamePointTick := GetTickCount();//20080413

                PlayObject.m_nPayMentPoint := 0;
                PlayObject.m_dwPayMentPointTick := GetTickCount();//�뿨����

                PlayObject.m_DearHuman := nil;
                PlayObject.m_MasterHuman := nil;
                //�޸������ڴ�й¶By TasNat at: 2012-05-27 10:32:01
                //PlayObject.m_MasterList := TList.Create;
                PlayObject.m_boSendMsgFlag := False;
                PlayObject.m_boChangeItemNameFlag := False;

                PlayObject.m_boCanMasterRecall := False;
                PlayObject.m_boCanDearRecall := False;
                PlayObject.m_dwDearRecallTick := GetTickCount();
                PlayObject.m_dwMasterRecallTick := GetTickCount();
                PlayObject.m_btReColorIdx := 0;
                PlayObject.m_GetWhisperHuman := nil;
                PlayObject.m_boOnHorse := False;
                PlayObject.m_wContribution := 0;
                PlayObject.m_sRankLevelName := g_sRankLevelName;
                PlayObject.m_boFixedHideMode := True;
                //PlayObject.m_nStep := 0;//20110303ע��

                PlayObject.m_nClientFlagMode := -1;
                PlayObject.m_dwAutoGetExpTick := GetTickCount;
                PlayObject.m_nAutoGetExpPoint := 0;
                PlayObject.m_AutoGetExpEnvir := nil;
                //PlayObject.m_dwHitIntervalTime := g_Config.dwHitIntervalTime; //�������  20080826 δʹ��
                PlayObject.m_dwMagicHitIntervalTime := g_Config.dwMagicHitIntervalTime; //ħ�����
                PlayObject.m_dwRunIntervalTime := g_Config.dwRunIntervalTime; //��·���
                PlayObject.m_dwWalkIntervalTime := g_Config.dwWalkIntervalTime; //��·���
                PlayObject.m_dwTurnIntervalTime := g_Config.dwTurnIntervalTime; //��������
                PlayObject.m_dwActionIntervalTime := g_Config.dwActionIntervalTime; //��ϲ������
                PlayObject.m_dwRunLongHitIntervalTime := g_Config.dwRunLongHitIntervalTime; //��ϲ������
                PlayObject.m_dwRunHitIntervalTime := g_Config.dwRunHitIntervalTime; //��ϲ������
                PlayObject.m_dwWalkHitIntervalTime := g_Config.dwWalkHitIntervalTime; //��ϲ������
                PlayObject.m_dwRunMagicIntervalTime := g_Config.dwRunMagicIntervalTime; //��λħ�����

                PlayObject.m_boTestSpeedMode := False;
                PlayObject.m_boLockLogon := True;
                PlayObject.m_boLockLogoned := False;

                PlayObject.m_boRemoteMsg := False; //�Ƿ����������Ϣ

                //PlayObject.m_boNotOnlineAddExp := False; //�Ƿ������߹һ�����
                PlayObject.m_boStartAutoAddExpPoint := False; //�Ƿ�ʼ���Ӿ���
                PlayObject.m_dwStartNotOnlineAddExpTime := 0; //���߹һ���ʼʱ��
                PlayObject.m_dwNotOnlineAddExpTime := 0; //���߹һ�ʱ��
                PlayObject.m_nNotOnlineAddExpPoint := 0; //���߹һ�ÿ�������Ӿ���ֵ
                PlayObject.m_dwAutoAddExpPointTick := GetTickCount;
                PlayObject.m_dwAutoAddExpPointTimeTick := GetTickCount;
                PlayObject.m_sAutoSendMsg := sAutoSendMsg; //�Զ��ظ���Ϣ
                PlayObject.m_boKickAutoAddExpUser := False;

                PlayObject.m_boTimeGoto := False;
                PlayObject.m_dwTimeGotoTick := GetTickCount;
                PlayObject.m_sTimeGotoLable := '';
                PlayObject.m_TimeGotoNPC := nil;
                {$IF M2Version <> 2}
                PlayObject.m_nJewelX:= -1;//����X����
                PlayObject.m_nJewelY:= -1;//����Y����
                PlayObject.m_boSendDominateMapName:= False;//�Ƿ��͹���ͼ�б�
                PlayObject.m_boOpenDominateToken:= False;//�Ƿ����������
                PlayObject.m_MyDivision := g_DivisionManager.MemberOfDivision(PlayObject.m_sCharName);//ȡ���������ʦ��
                {$IFEND}
                PlayObject.m_nDealGoldPose := 0;
                PlayObject.m_nScriptGotoCount := 0; //2006-11-12 Ҷ���Ʈ �������߹һ������߻��нű���ѭ���Ĵ���
                PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName); //2006-12-10  �����ѻ��������¶�ȡ�л�
                {$IF M2Version = 1}
                PlayObject.m_nDecDamageRate:= 0;//��������ʱ�����˰ٷ���
                PlayObject.m_nBatterMagIdx1:= 0;//��������ID1
                PlayObject.m_nBatterMagIdx2:= 0;//��������ID2
                PlayObject.m_nBatterMagIdx3:= 0;//��������ID3
                PlayObject.m_nBatterMagIdx4:= 0;//��������ID4 20100719
                PlayObject.m_boUseBatter:= False;
                PlayObject.m_boSendCanBatterMsg:= False;
                PlayObject.m_boWarUseBatter:= False;
                PlayObject.m_nUseBatterTick:= GetTickCount();
                {$IFEND}
                PlayObject.m_boNPCCanGoto:= False;//@@InPutString @@InPutInteger ��ת��ʶ 20090818
                PlayObject.m_boButching:= False;//��������

                if PlayObject.m_DynamicVarList.Count > 0 then begin//20080630
                  for I := 0 to PlayObject.m_DynamicVarList.Count - 1 do begin //�����������
                    if pTDynamicVar(PlayObject.m_DynamicVarList.Items[I]) <> nil then
                       Dispose(pTDynamicVar(PlayObject.m_DynamicVarList.Items[I]));
                  end;
                end;
                PlayObject.m_DynamicVarList.Clear;

                {PlayObject.m_sIPaddr := GateUser.sIPaddr;
                PlayObject.m_sIPaddr := GateUser.sMac;  }
                //Ϊʲôд����
                PlayObject.m_sIPaddr := GateUser.sIPaddr;
                PlayObject.m_nGSocketIdx := GateUser.nGSocketIdx;
                PlayObject.m_nGateIdx := GateIdx;
                PlayObject.m_nSocket := nSocket;
                PlayObject.m_nSessionID := nSessionID;
                PlayObject.m_nRandomKey := nRandomKey;//�����Կ 200901026
                PlayObject.m_nSendMsgCount:= 0;
                PlayObject.m_nPayMent := nPayMent;
                PlayObject.m_nPayMode := nPayMode;
                PlayObject.m_dwHCode := dwHCode;
                PlayObject.m_boReadyRun := False;

                GateUser.boCertification := True;
                GateUser.sAccount := Trim(sAccount);
                GateUser.sCharName := Trim(sChrName);
                GateUser.nSessionID := nSessionID;
                GateUser.nClientVersion := nClientVersion;
                GateUser.SessInfo := SessInfo;
                SetGateUserList(PlayObject.m_nGateIdx, PlayObject.m_nSocket, PlayObject);
                //UserEngine.SendServerGroupMsg(SS_201, nServerIndex, PlayObject.m_sCharName);//20101022 ע��
              end else begin //ͬһ���˺Ų�ͬ����
                PlayObject.m_boPlayOffLine := False;
                PlayObject.m_boNotOnlineAddExp := False;
                //PlayObject.m_boReconnection := False;
                //PlayObject.m_boSoftClose := True;
                GateUser.boCertification := True;
                GateUser.sAccount := Trim(sAccount);
                GateUser.sCharName := Trim(sChrName);
                GateUser.nSessionID := nSessionID;
                GateUser.nClientVersion := nClientVersion;
                GateUser.SessInfo := SessInfo;
                try
                  FrontEngine.AddToLoadRcdList(sAccount,
                    sChrName,
                    GateUser.sIPaddr,
                    boFlag,
                    nSessionID,
                    dwHCode,
                    nPayMent,
                    nPayMode,
                    nClientVersion,
                    nSocket,
                    GateUser.nGSocketIdx,
                    GateIdx,False, nRandomKey);
                except
                  MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
                end;
              end;
            end else begin
              GateUser.boCertification := True;
              GateUser.sAccount := Trim(sAccount);
              GateUser.sCharName := Trim(sChrName);
              GateUser.nSessionID := nSessionID;
              GateUser.nClientVersion := nClientVersion;
              GateUser.SessInfo := SessInfo;
              try
                FrontEngine.AddToLoadRcdList(sAccount,//�˺�
                  sChrName,//��ɫ��
                  GateUser.sIPaddr,//IP��ַ
                  boFlag,
                  nSessionID,//�ỰID
                  dwHCode,
                  nPayMent,
                  nPayMode,
                  nClientVersion,
                  nSocket,
                  GateUser.nGSocketIdx,
                  GateIdx,False, nRandomKey);
              except                 
                MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
              end;
            end;
          end else begin
            nCheckCode := 2;
            GateUser.sAccount := sDisable;
            GateUser.boCertification := False;
            CloseUser(GateIdx, nSocket);
            nCheckCode := 3;
          end;
        end else begin
          nCheckCode := 4;
          GateUser.sAccount := sDisable;
          GateUser.boCertification := False;
          CloseUser(GateIdx, nSocket);
          nCheckCode := 5;
        end;
      end;
    end;         
  except
    MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
  end;
end;
//����Ϣ����Rungate.exe
function TRunSocket.SendGateBuffers(GateIdx: Integer; Gate: pTGateInfo; MsgList: TList): Boolean;
var
  dwRunTick: LongWord;
  BufferA: PChar;
  BufferB: PChar;
  BufferC: PChar;
  I: Integer;
  nBuffALen: Integer;
  nBuffBLen: Integer;
  nBuffCLen: Integer;
  nSendBuffLen: Integer;
  nSendCount: Integer;//20110309
  DefMsg : TDefaultMessage;
resourcestring
  sExceptionMsg1 = '{%s} TRunSocket::SendGateBuffers -> ProcessBuff';
  sExceptionMsg2 = '{%s} TRunSocket::SendGateBuffers -> SendBuff';
begin
  Result := True;
  if (MsgList.Count = 0) or (Gate = nil) then Exit;//20091125 �޸�
  dwRunTick := GetTickCount();
  if Gate.nSendChecked > 0 then begin
    if (GetTickCount - Gate.dwSendCheckTick) > g_dwSocCheckTimeOut {2 * 1000} then begin
      Gate.nSendChecked := 0;
      Gate.nSendBlockCount := 0;
    end;
    Exit;
  end;
  //��С���ݺϲ�Ϊһ��ָ����С������
{$IF CATEXCEPTION = TRYEXCEPTION}
  try
{$IFEND}
    I := 0;
    BufferA := MsgList.Items[I];
    while (True) do begin
      if (I + 1) >= MsgList.Count then Break;
      BufferB := MsgList.Items[I + 1];
      Move(BufferA^, nBuffALen, SizeOf(Integer));
      Move(BufferB^, nBuffBLen, SizeOf(Integer));
      if (nBuffALen + nBuffBLen) < g_Config.nSendBlock then begin
        MsgList.Delete(I + 1);
        GetMem(BufferC, nBuffALen + SizeOf(Integer) + nBuffBLen);
        nBuffCLen := nBuffALen + nBuffBLen;
        Move(nBuffCLen, BufferC^, SizeOf(Integer));
        Move(BufferA[SizeOf(Integer)], PChar(BufferC + SizeOf(Integer))^, nBuffALen);
        Move(BufferB[SizeOf(Integer)], PChar(BufferC + nBuffALen + SizeOf(Integer))^, nBuffBLen);
        try//20090413 �޸�
          if BufferA <> nil then FreeMem(BufferA);
        except
          BufferA:= nil;
        end;
        try//20090413 �޸�
          if BufferB <> nil then FreeMem(BufferB);
        except
          BufferB:= nil;
        end;
        BufferA := BufferC;
        MsgList.Items[I] := BufferA;
        Continue;
      end;
      Inc(I);
      BufferA := BufferB;
    end;
{$IF CATEXCEPTION = TRYEXCEPTION}
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg1,[g_sExceptionVer]));
      MsgList.Clear;//20110309 ����(�ο�JS����)
      Exit;//20110309 ����(�ο�JS����)
    end;
  end;
{$IFEND}

{$IF CATEXCEPTION = TRYEXCEPTION}
  try
{$IFEND}
    while MsgList.Count > 0 do begin
      BufferA := MsgList.Items[0];
      if BufferA = nil then begin
        MsgList.Delete(0);
        Continue;
      end;
      Move(BufferA^, nSendBuffLen, SizeOf(Integer));
      if (Gate.nSendChecked = 0) and ((Gate.nSendBlockCount + nSendBuffLen) >= g_Config.nCheckBlock * 10) then begin
        //{$IF (M2Sion = 1) or (TESTMODE = 1)}
        //Move(DefMsg, BufferA[SizeOf(Integer) + SizeOf(TMsgHeader)], SizeOf(TDefaultMessage));
        //MainOutMessage(Format('{%s} ��Ϣ Ident:%d Identbb:%d',[g_sExceptionVer, DefMsg.Ident, DefMsg.Ident]));
        //MainOutMessage(Format('{%s} ���ݴ�С Block:%d sMsg:%d %d',[g_sExceptionVer, g_Config.nCheckBlock, Gate.nSendBlockCount + nSendBuffLen, nSendBuffLen]));
        //{$IFEND}


        if (Gate.nSendBlockCount = 0) and (g_Config.nCheckBlock * 10 <= nSendBuffLen) then begin
          MsgList.Delete(0); //������ݴ�С����ָ����С���ӵ�(�༭���ݱȽϴ�����е��ϵ)
          try
            if BufferA <> nil then FreeMem(BufferA);//20090413 �޸�
          except
            BufferA:= nil;
          end;
        end else begin
          SendCheck(Gate.Socket, GM_RECEIVE_OK);
          Gate.nSendChecked := 1;
          Gate.dwSendCheckTick := GetTickCount();
        end;
        Break;
      end;
      MsgList.Delete(0);
      BufferB := BufferA + SizeOf(Integer);
      if nSendBuffLen > 0 then begin
        while (Gate.Socket <> nil) and Gate.Socket.Connected do begin
          if g_Config.nSendBlock <= nSendBuffLen then begin
            {if  Gate.Socket <> nil then }begin
              {if Gate.Socket.Connected then }begin
                nSendCount := Gate.Socket.SendBuf(BufferB^, g_Config.nSendBlock);
                {if nSendCount = -1 then begin //����ʧ�ܣ����¼������ 20110309 �ο�JS
                  GetMem(BufferC, nSendBuffLen + SizeOf(Integer));
                  Move(nSendBuffLen, BufferC^, SizeOf(Integer));
                  Move(BufferB^, BufferC[SizeOf(Integer)], nSendBuffLen);
                  MsgList.Insert(0, BufferC);
                  FreeMem(BufferA);
                  Exit;
                end;}
                Inc(Gate.nSendCount);
                Inc(Gate.nSendBytesCount, g_Config.nSendBlock);
              end;
            end;
            Inc(Gate.nSendBlockCount, g_Config.nSendBlock);
            BufferB := @BufferB[g_Config.nSendBlock];
            Dec(nSendBuffLen, g_Config.nSendBlock);
            Continue;
          end;
          {if Gate <> nil then }begin
            {if Gate.Socket <> nil then }begin
              {if Gate.Socket.Connected then }begin
                nSendCount := Gate.Socket.SendBuf(BufferB^, nSendBuffLen);
                {if nSendCount = -1 then begin //����ʧ�ܣ����¼������ 20110309 �ο�JS
                  MsgList.Insert(0, BufferA);
                  Exit;
                end; }
              end;
              Inc(Gate.nSendCount);
              Inc(Gate.nSendBytesCount, nSendBuffLen);
              Inc(Gate.nSendBlockCount, nSendBuffLen);
            end;
          end;
          nSendBuffLen := 0;
          Break;
        end;
      end;
      try
        if BufferA <> nil then FreeMem(BufferA);
      except
        BufferA:= nil;
      end;
      {.$If RunGateUsesThread <> 1} //���̲߳������ÿ���By TasNat at: 2012-04-21 10:35:25
      if (GetTickCount - dwRunTick) > g_dwSocLimit then begin
        Result := False;
        Break;
      end;
      {.$ifend}
    end;
{$IF CATEXCEPTION = TRYEXCEPTION}
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2,[g_sExceptionVer]));
    end;
  end;
{$IFEND}
end;
//�ر��û�
procedure TRunSocket.CloseUser(GateIdx, nSocket: Integer);
var
  I: Integer;
  GateUser: pTGateUserInfo;
  Gate: pTGateInfo;
resourcestring
  sExceptionMsg0 = '{%s} TRunSocket::CloseUser 0';
  sExceptionMsg1 = '{%s} TRunSocket::CloseUser 1';
  sExceptionMsg2 = '{%s} TRunSocket::CloseUser 2';
  sExceptionMsg3 = '{%s} TRunSocket::CloseUser 3';
  sExceptionMsg4 = '{%s} TRunSocket::CloseUser 4';
begin
  //if GateIdx <= High(g_GateArr) then begin
  if GateIdx in [Low(g_GateArr)..High(g_GateArr)] then begin//20100913 ��JS�޸�
    Gate := @g_GateArr[GateIdx];
    if Gate <> nil then begin//20110329
      if Gate.UserList <> nil then begin
        EnterCriticalSection(m_RunSocketSection);
        try
          try
            if Gate.UserList.Count > 0 then begin//20091113 ����
              for I := 0 to Gate.UserList.Count - 1 do begin
                if Gate.UserList.Items[I] <> nil then begin
                  GateUser := Gate.UserList.Items[I];
                  if GateUser.nSocket = nSocket then begin
                    try
                      if GateUser.FrontEngine <> nil then begin
                        TFrontEngine(GateUser.FrontEngine).DeleteHuman(I, GateUser.nSocket);
                      end;
                    except
                      MainOutMessage(format(sExceptionMsg1,[g_sExceptionVer]));
                    end;

                    try
                      if TPlayObject(GateUser.PlayObject) <> nil then begin
                        TPlayObject(GateUser.PlayObject).m_boSoftClose := True;
                      end;
                    except
                      MainOutMessage(format(sExceptionMsg2,[g_sExceptionVer]));
                    end;

                    try
                      if (GateUser.PlayObject <> nil) then begin//20090101 �޸�
                        if (TPlayObject(GateUser.PlayObject).m_boGhost) and (not TPlayObject(GateUser.PlayObject).m_boReconnection) then begin
                          FrmIDSoc.SendHumanLogOutMsg(GateUser.sAccount, GateUser.nSessionID);
                        end;
                      end;
                    except
                      MainOutMessage(format(sExceptionMsg3,[g_sExceptionVer]));
                    end;

                    try
                      Dispose(GateUser);
                      Gate.UserList.Items[I] := nil;
                      Dec(Gate.nUserCount);
                    except
                      MainOutMessage(format(sExceptionMsg4,[g_sExceptionVer]));
                    end;
                    Break;
                  end;
                end;
              end;//for
            end;
          except
            MainOutMessage(format(sExceptionMsg0,[g_sExceptionVer]));
          end;
        finally
          LeaveCriticalSection(m_RunSocketSection);
        end;
      end;
    end;
  end;
end;
//���û�����
function TRunSocket.OpenNewUser(nSocket: Integer; nGSocketIdx: Integer; sIPaddr: string; UserList: TList): Integer; //004E0364
var
  GateUser: pTGateUserInfo;
  I: Integer;
begin
  New(GateUser);
  GateUser.sAccount := '';
  GateUser.sCharName := '';
  GateUser.sIPaddr := sIPaddr;
  GateUser.nSocket := nSocket;
  GateUser.nGSocketIdx := nGSocketIdx;
  GateUser.nSessionID := 0;
  GateUser.UserEngine := nil;
  GateUser.FrontEngine := nil;
  GateUser.PlayObject := nil;
  GateUser.dwNewUserTick := GetTickCount();
  GateUser.boCertification := False;
  if UserList.Count > 0 then begin//20091113 ����
    for I := 0 to UserList.Count - 1 do begin
      if UserList.Items[I] = nil then begin
        UserList.Items[I] := GateUser;
        Result := I;
        Exit;
      end;
    end;
  end;
  UserList.Add(GateUser);
  Result := UserList.Count - 1;
end;

procedure TRunSocket.SendNewUserMsg(Socket: TCustomWinSocket; nSocket: Integer; nSocketIndex, nUserIdex: Integer);
var
  MsgHeader: TMsgHeader;
begin
  try
    if not Socket.Connected then begin
      {$IF (M2Sion = 1) or (TESTMODE = 1)}
      MainOutMessage(Format('{%s} SendNewUserMsg:Socket 1 δ����',[g_sExceptionVer]));
      {$IFEND}
      Exit;
    end;
    MsgHeader.dwCode := RUNGATECODE;
    MsgHeader.nSocket := nSocket;
    MsgHeader.wGSocketIdx := nSocketIndex;
    MsgHeader.wIdent := GM_SERVERUSERINDEX;
    MsgHeader.wUserListIndex := nUserIdex;
    MsgHeader.nLength := 0;
    if (Socket <> nil) and Socket.Connected then begin
      Socket.SendBuf(MsgHeader, SizeOf(TMsgHeader));
    end else begin
      {$IF (M2Sion = 1) or (TESTMODE = 1)}
      MainOutMessage(Format('{%s} SendNewUserMsg:Socket 2 δ����',[g_sExceptionVer]));
      {$IFEND}
    end;
  except
    MainOutMessage(format('{%s} TRunSocket.SendNewUserMsg',[g_sExceptionVer]));
  end;
end;

//����Rungate�����İ�
procedure TRunSocket.ExecGateMsg(GateIdx: Integer; Gate: pTGateInfo; MsgHeader: pTMsgHeader; MsgBuff: PChar; nMsgLen: Integer);
var
  nCheckCode: Integer;
  nUserIdx: Integer;
  sIPaddr: string;
  GateUser: pTGateUserInfo;
  I: Integer;
resourcestring
  sExceptionMsg = '{%s} TRunSocket::ExecGateMsg %d';
begin
  nCheckCode := 0;

  try
    case MsgHeader.wIdent of
      GM_OPEN {1}: begin//�ͻ�������Rungate.exe
          {$IF (M2Sion = 1) or (TESTMODE = 1)}
          MainOutMessage(Format('{%s} ����GM_OPEN',[g_sExceptionVer]));
          {$IFEND}
          nCheckCode := 1;
          sIPaddr := StrPas(MsgBuff);
          nUserIdx := OpenNewUser(MsgHeader.nSocket, MsgHeader.wGSocketIdx, sIPaddr, Gate.UserList);
          SendNewUserMsg(Gate.Socket, MsgHeader.nSocket, MsgHeader.wGSocketIdx, nUserIdx + 1);
          Inc(Gate.nUserCount);
        end;
      GM_CLOSE {2}: begin
          nCheckCode := 2;
          CloseUser(GateIdx, MsgHeader.nSocket);
        end;
      GM_CHECKCLIENT {4}: begin //RunGate.exe��M2��ͨѶ ÿ����RunGate���͵�������
          nCheckCode := 3;
          Gate.boSendKeepAlive := True;
        end;
      GM_RECEIVE_OK {7}: begin
          nCheckCode := 4;
          Gate.nSendChecked := 0;
          Gate.nSendBlockCount := 0;
        end;
      GM_DATA {5}: begin
          nCheckCode := 5;
          GateUser := nil;
          if MsgHeader.wUserListIndex >= 1 then begin
            nUserIdx := MsgHeader.wUserListIndex - 1;
            nCheckCode := 51;
            if (Gate.UserList <> nil) and (Gate.UserList.Count > nUserIdx) then begin
              nCheckCode := 52;
              GateUser := Gate.UserList.Items[nUserIdx];
              //GateUser.SessInfo.
              if (GateUser <> nil) then begin
                nCheckCode := 53;
                if GateUser.nSocket <> MsgHeader.nSocket then GateUser := nil;
              end;
            end;
          end;
          nCheckCode := 54;
          if GateUser = nil then begin
            nCheckCode := 55;
            if (Gate.UserList <> nil) and (Gate.UserList.Count > 0) then begin//20091113 ����
              for I := 0 to Gate.UserList.Count - 1 do begin
                if Gate.UserList.Items[I] = nil then Continue;
                nCheckCode := 56;
                if pTGateUserInfo(Gate.UserList.Items[I]).nSocket = MsgHeader.nSocket then begin
                  GateUser := Gate.UserList.Items[I];
                  Break;
                end;
              end;
            end;
          end;

          nCheckCode := 6;
          if GateUser <> nil then begin
            nCheckCode := 7;
            if (GateUser.PlayObject <> nil) and (GateUser.UserEngine <> nil) then begin
              nCheckCode := 8;
              if GateUser.boCertification and (nMsgLen >= SizeOf(TDefaultMessage)) then begin
                if nMsgLen = SizeOf(TDefaultMessage) then begin
                  nCheckCode := 9;
                  if TPlayObject(GateUser.PlayObject) <> nil then begin//20090808 ����
                    UserEngine.ProcessUserMessage(TPlayObject(GateUser.PlayObject), pTDefaultMessage(MsgBuff), nil);
                  end;
                end else begin
                  nCheckCode := 10;
                  if TPlayObject(GateUser.PlayObject) <> nil then begin//20090808 ����
                    UserEngine.ProcessUserMessage(TPlayObject(GateUser.PlayObject), pTDefaultMessage(MsgBuff), @MsgBuff[SizeOf(TDefaultMessage)]);
                  end;
                end;
              end;
            end else begin
              nCheckCode := 11;
              if GetTickCount - GateUser.dwNewUserTick < 40000{1000 * 40} then begin
                nCheckCode := 12;
                DoClientCertification(GateIdx, GateUser, MsgHeader.nSocket, StrPas(MsgBuff));
              end else begin //2007-01-21���� 40����û��½�ɹ�������
                nCheckCode := 13;
                CloseUser(GateIdx, MsgHeader.nSocket);
                SendOutConnectMsg(GateIdx, MsgHeader.nSocket, GateUser.nGSocketIdx);
              end;
            end;
          end else begin
            {$IF TESTMODE = 1}
            MainOutMessage('[RunSock] GateUser δ�ҵ�!');
            {$IFEND}
          end;
        end;
    end;
  except
    MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
  end;
end;
//������Rungate.exe����������Ƿ�����
procedure TRunSocket.SendCheck(Socket: TCustomWinSocket; nIdent: Integer);
var
  MsgHeader: TMsgHeader;
begin
  if not Socket.Connected then Exit;
  MsgHeader.dwCode := RUNGATECODE;
  MsgHeader.nSocket := 0;
  MsgHeader.wIdent := nIdent;
  MsgHeader.nLength := 0;
  if Socket <> nil then Socket.SendBuf(MsgHeader, SizeOf(TMsgHeader));
end;

procedure TRunSocket.LoadRunAddr();
var
  sFileName: string;
begin
  sFileName := '.\RunAddr.txt';
  if FileExists(sFileName) then begin
    m_RunAddrList.LoadFromFile(sFileName);
    TrimStringList(m_RunAddrList);
  end;
end;

constructor TRunSocket.Create();
var
  I: Integer;
  Gate: pTGateInfo;
begin
  {$If RunGateUsesThread =1}
  inherited Create(True);
  {$Ifend RunGateUsesThread =1}
  InitializeCriticalSection(m_RunSocketSection);
  m_RunAddrList := TStringList.Create;
  for I := Low(g_GateArr) to High(g_GateArr) do begin
    Gate := @g_GateArr[I];
    Gate.boUsed := False;
    Gate.Socket := nil;
    Gate.boSendKeepAlive := False;
    Gate.nSendMsgCount := 0;
    Gate.nSendRemainCount := 0;
    Gate.dwSendTick := GetTickCount();
    Gate.nSendMsgBytes := 0;
    Gate.nSendedMsgCount := 0;
  end;
  m_nErrorCount := 0;
  LoadRunAddr();
  n4F8 := 0;
  {$If RunGateUsesThread =1}
  Resume;
  {$Ifend RunGateUsesThread =1}
end;

destructor TRunSocket.Destroy;
begin
  {$If RunGateUsesThread =1}
  Terminate;
  {$Ifend RunGateUsesThread =1}
  m_RunAddrList.Free;
  DeleteCriticalSection(m_RunSocketSection);
  inherited Destroy;
end;
//����Ϣ�������б��У�Ȼ�󷢸�RunGate.exe����
function TRunSocket.AddGateBuffer(GateIdx: Integer; Buffer: PChar): Boolean;
var
  Gate: pTGateInfo;
begin
  Result := False;
  //{$If RunGateUsesThread <> 1}
  EnterCriticalSection(m_RunSocketSection);
  try
    if GateIdx < RUNGATEMAX then begin
      Gate := @g_GateArr[GateIdx];
      if (Gate.BufferList <> nil) and (Buffer <> nil) then begin
        if Gate.boUsed and (Gate.Socket <> nil) then begin
          Gate.BufferList.Add(Buffer);
          Result := True;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(m_RunSocketSection);
  end;
  (*{$else}//���߳�ģʽ
    if (GateIdx <= High(g_GateArr)) and (GateIdx >= Low(g_GateArr)) then begin
      Gate := @g_GateArr[GateIdx];
      if (Gate.TempBufferList <> nil) and (Buffer <> nil) then begin
        if Gate.boUsed and (Gate.Socket <> nil) then begin
          try
            Gate.TempBufferList.Lock;
            Gate.TempBufferList.Add(Buffer);
          finally
            Gate.TempBufferList.UnLock;
          end;
          Result := True;
        end;
      end;
    end;
  {$Ifend RunGateUsesThread =1}*)

end;
//ǿ���û�����
procedure TRunSocket.SendOutConnectMsg(nGateIdx, nSocket, nGsIdx: Integer);
var
  DefMsg: TDefaultMessage;
  MsgHeader: TMsgHeader;
  nLen: Integer;
  Buff: PChar;
begin
  DefMsg := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0, 0);
  MsgHeader.dwCode := RUNGATECODE;
  MsgHeader.nSocket := nSocket;
  MsgHeader.wGSocketIdx := nGsIdx;
  MsgHeader.wIdent := GM_DATA;
  MsgHeader.nLength := SizeOf(TDefaultMessage);

  nLen := MsgHeader.nLength + SizeOf(TMsgHeader);
  GetMem(Buff, nLen + SizeOf(Integer));
  Move(nLen, Buff^, SizeOf(Integer));
  Move(MsgHeader, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
  Move(DefMsg, Buff[SizeOf(Integer) + SizeOf(TMsgHeader)], SizeOf(TDefaultMessage));
  if not AddGateBuffer(nGateIdx, Buff) then FreeMem(Buff);
end;

{procedure TRunSocket.SendScanMsg(DefMsg: pTDefaultMessage; sMsg: string; nGateIdx, nSocket, nGsIdx: Integer);
var
  MsgHdr: TMsgHeader;
  Buff: PChar;
  nSendBytes: Integer;
begin
  MsgHdr.dwCode := RUNGATECODE;
  MsgHdr.nSocket := nSocket;
  MsgHdr.wGSocketIdx := nGsIdx;
  MsgHdr.wIdent := GM_DATA;
  MsgHdr.nLength := SizeOf(TDefaultMessage);

  if DefMsg <> nil then begin
    if sMsg <> '' then begin
      MsgHdr.nLength := Length(sMsg) + SizeOf(TDefaultMessage) + 1;
      nSendBytes := MsgHdr.nLength + SizeOf(TMsgHeader);
      GetMem(Buff, nSendBytes + SizeOf(Integer));
      Move(nSendBytes, Buff^, SizeOf(Integer));
      Move(MsgHdr, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
      Move(DefMsg^, Buff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
      Move(sMsg[1], Buff[SizeOf(TDefaultMessage) + SizeOf(TMsgHeader) + SizeOf(Integer)], Length(sMsg) + 1);
    end else begin
      MsgHdr.nLength := SizeOf(TDefaultMessage);
      nSendBytes := MsgHdr.nLength + SizeOf(TMsgHeader);
      GetMem(Buff, nSendBytes + SizeOf(Integer));
      Move(nSendBytes, Buff^, SizeOf(Integer));
      Move(MsgHdr, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
      Move(DefMsg^, Buff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
    end;
  end else begin
    if sMsg <> '' then begin
      MsgHdr.nLength := -(Length(sMsg) + 1);
      nSendBytes := abs(MsgHdr.nLength) + SizeOf(TMsgHeader);
      GetMem(Buff, nSendBytes + SizeOf(Integer));
      Move(nSendBytes, Buff^, SizeOf(Integer));
      Move(MsgHdr, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
      Move(sMsg[1], Buff[SizeOf(TMsgHeader) + SizeOf(Integer)], Length(sMsg) + 1);
    end;
  end;
  if not RunSocket.AddGateBuffer(nGateIdx, Buff) then FreeMem(Buff);
end; }

procedure TRunSocket.SetGateUserList(nGateIdx, nSocket: Integer; PlayObject: TPlayObject);
var
  I: Integer;
  GateUserInfo: pTGateUserInfo;
  Gate: pTGateInfo;
begin
  //if nGateIdx > High(g_GateArr) then Exit;//20100910ע��
  if nGateIdx in [Low(g_GateArr)..High(g_GateArr)] then begin//20100910 ���ӣ��ο�JS
    Gate := @g_GateArr[nGateIdx];
    if Gate.UserList = nil then Exit;
    EnterCriticalSection(m_RunSocketSection);
    try
      if Gate.UserList.Count > 0 then begin//20091113 ����
        for I := 0 to Gate.UserList.Count - 1 do begin
          GateUserInfo := Gate.UserList.Items[I];
          if (GateUserInfo <> nil) then begin
            if (GateUserInfo.nSocket = nSocket) then begin
              GateUserInfo.FrontEngine := nil;
              GateUserInfo.UserEngine := UserEngine;
              GateUserInfo.PlayObject := PlayObject;
              Break;
            end;
          end;
        end;
      end;
    finally
      LeaveCriticalSection(m_RunSocketSection);
    end;
  end;
end;
//�����ط��Ͳ�����Ϣ
procedure TRunSocket.SendGateTestMsg(nIndex: Integer);
var
  MsgHdr: TMsgHeader;
  Buff: PChar;
  nLen: Integer;
  DefMsg: TDefaultMessage;
begin
  MsgHdr.dwCode := RUNGATECODE;
  MsgHdr.nSocket := 0;
  MsgHdr.wIdent := GM_TEST;
  MsgHdr.nLength := 100;
  nLen := MsgHdr.nLength + SizeOf(TMsgHeader);
  GetMem(Buff, nLen + SizeOf(Integer));
  Move(nLen, Buff^, SizeOf(Integer));
  Move(MsgHdr, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
  Move(DefMsg, Buff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
  if not AddGateBuffer(nIndex, Buff) then FreeMem(Buff);
end;

procedure TRunSocket.KickUser(sAccount: string; nSessionID: Integer; nCode: byte);
var
  I: Integer;
  II: Integer;
  GateUserInfo: pTGateUserInfo;
  Gate: pTGateInfo;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '{%s} TRunSocket::KickUser CheckCode: %d';
  sKickUserMsg = '��ǰ��¼�ʺ���������λ�õ�¼�������ѱ�ǿ�����ߣ�����';
begin
  nCheckCode := 0;
  try
    for I := Low(g_GateArr) to High(g_GateArr) do begin
      Gate := @g_GateArr[I];
      nCheckCode := 1;
      if Gate.boUsed and (Gate.Socket <> nil) and (Gate.UserList <> nil) then begin
        nCheckCode := 2;
        EnterCriticalSection(m_RunSocketSection);
        try
          nCheckCode := 3;
          if Gate.UserList.Count > 0 then begin//20091113 ����
            for II := 0 to Gate.UserList.Count - 1 do begin
              nCheckCode := 4;
              GateUserInfo := Gate.UserList.Items[II];
              if GateUserInfo = nil then Continue;
              nCheckCode := 5;
              if (GateUserInfo.sAccount = sAccount) {or}and (GateUserInfo.nSessionID = nSessionID) then begin//20090510 �޸� or
                nCheckCode := 6;
                if GateUserInfo.FrontEngine <> nil then begin
                  nCheckCode := 7;
                  TFrontEngine(GateUserInfo.FrontEngine).DeleteHuman(I, GateUserInfo.nSocket);
                end;
                nCheckCode := 8;
                if GateUserInfo.PlayObject <> nil then begin
                  nCheckCode := 9;
                  if nCode = 0 then TPlayObject(GateUserInfo.PlayObject).SysMsg(sKickUserMsg, c_Red, t_Hint)
                  else TPlayObject(GateUserInfo.PlayObject).SysMsg('�˺Ÿ���ʱ���ѵ�,�����ѱ�ǿ������,���ֵ���ټ���������Ϸ��', c_Red, t_Hint);
                  TPlayObject(GateUserInfo.PlayObject).m_boEmergencyClose := True;
                  TPlayObject(GateUserInfo.PlayObject).m_boSoftClose := True;
                  TPlayObject(GateUserInfo.PlayObject).m_boPlayOffLine := False;
                end;
                nCheckCode := 10;
                Dispose(GateUserInfo);
                nCheckCode := 11;
                Gate.UserList.Items[II] := nil;
                nCheckCode := 12;
                Dec(Gate.nUserCount);
                Break;
              end;
            end;//for
          end;
          nCheckCode := 13;
        finally
          LeaveCriticalSection(m_RunSocketSection);
        end;
        nCheckCode := 14;
      end;
    end;
  except
    on E: Exception do begin     
      MainOutMessage(Format(sExceptionMsg, [g_sExceptionVer, nCheckCode]));
      //MainOutMessage(E.Message);
    end;
  end;
end;


end.

