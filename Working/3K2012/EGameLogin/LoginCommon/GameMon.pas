unit GameMon;

//20110513 ����ͨ��ȡ��ǰIE��URL���ж��Ƿ�Ϊ���
interface

uses Windows, SysUtils, Messages, TlHelp32, Forms, psapi;

type
  TProcessInfo=Record
    ExeFile:string;
    ProcessID:Dword;
  end;
  sProcessInfo=^TProcessInfo;

var
  ProcessInfo : TProcessInformation;
//  AsmBuf : array[0..20] of Byte = ($B8, $00, $00, $00, $00, $68, $00, $00, $00, $00, $FF, $D0, $B8, $00, $00, $00, 00, $6A, $00, $FF, $D0);

//��������
//procedure EndProcess(AFileName: string);
procedure Enum_Proccess;
//Ѱ�Ҵ��� �ص�����
function EnumWindowsProc(ahwnd: hwnd; lParam: lParam): Boolean; stdcall;

implementation
uses Common, Main, GameLoginShare{, SHDocVw, MSHTML, ActiveX};

(*//---------------------ȡָ������е�IE����-------------------------------------
const
  RSPSIMPLESERVICE = 1;
  RSPUNREGISTERSERVICE = 0; 
type
  TObjectFromLResult = function(LRESULT: lResult; const IID: TIID; WPARAM: wParam; out pObject): HRESULT; stdcall;

function GetIEFromHWND(WHandle: HWND; var IE: IWebbrowser2): HRESULT;
var
  hInst: HWND;
  lRes: Cardinal;
  MSG: Integer;
  pDoc: IHTMLDocument2;
  ObjectFromLresult: TObjectFromLresult;
begin
  hInst := LoadLibrary('Oleacc.dll');
  @ObjectFromLresult := GetProcAddress(hInst, 'ObjectFromLresult');
  if @ObjectFromLresult <> nil then begin
    try
      MSG := RegisterWindowMessage('WM_HTML_GETOBJECT');
      SendMessageTimeOut(WHandle, MSG, 0, 0, SMTO_ABORTIFHUNG, 1000, lRes);
      Result := ObjectFromLresult(lRes, IHTMLDocument2, 0, pDoc);
      if Result = S_OK then
        (pDoc.parentWindow as IServiceprovider).QueryService(IWebbrowserApp, IWebbrowser2, IE);
    finally
      FreeLibrary(hInst);
    end;
  end;
end;
//����URL��ַ��ȥ��HTTP://ͬʱȥ����com���'/'
function GetUrlPath(Str:String): string;
var
  TempStr, Temp, St1:string;
  I:integer;
begin
  Result := '';
  if Str <> '' then begin
    St1:= LowerCase(Str);//ת��ΪСд
    if pos('http://',St1) > 0 then begin
      Temp:= copy(St1, 8, Length(St1));
      I:= pos('/',Temp);
      if I > 0 then begin
        TempStr:= copy(Temp, 1, I - 1);
        Result := TempStr;
      end else Result := Temp;
    end;
  end;
end;   *)
//------------------------------------------------------------------------------
{���ݴ��ھ����ȡ���ڳ���·���ĺ���}
function GetProcessExePath(h: HWND): string;
var
  pid: Cardinal;
  pHandle: THandle;
  buf: array[0..MAX_PATH] of Char;
begin
  GetWindowThreadProcessId(h, @pid);//�Ȼ�ȡ���� ID
  pHandle := OpenProcess(PROCESS_ALL_ACCESS, False, pid);//�ٻ�ȡ���̾��
  GetModuleFileNameEx(pHandle, 0, buf, Length(buf));//��ȡ����·��
  CloseHandle(pHandle);
  Result := buf;
end;

{!------����Ҵ��뿪ʼ-------!}
function GetIt(Handle:Thandle):boolean;
var
  WndCaption: array[0..254] of char;
  WndClassName: array[0..254] of char;
  WndChild: HWND;
{  IE: IWebBrowser2;
  Title: string;}
begin
  if Handle > 0 then begin
    GetClassName(Handle, @WndClassName, Length(WndClassName));
    GetWindowText(Handle, @WndCaption, Length(WndCaption));//��ÿؼ���
    if (g_GameMonTitle.IndexOf(WndClassName) > -1) or (g_GameMonTitle.IndexOf(WndCaption) > -1) then begin
      FrmMain.TimerKillCheat.Enabled := False;
      FrmMain.Caption := '';
      Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
        + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
        + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
        + #13 + {'�����ļ���'}Setdate('�����˳�') + GetProcessExePath(Handle)), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING + MB_TOPMOST);
      asm //�رճ���
        MOV FS:[0],0;
        MOV DS:[0],EAX;
      end;
    end else begin
      (*try
        //��ͨ��ȡ��ǰIE��Url��ַ�ж��Ƿ�ΪWG��վ 20110513
        WndChild := FindWindowEX(Handle, 0, 'Internet Explorer_Server', nil);
        if WndChild <> 0 then begin
          GetIEFromHWnd(WndChild, IE);//ȡIwebbrowser2�ľ��
          if Assigned(IE) then begin
            Title:= GetUrlPath(IE.LocationURL);//ȡIE��ǰλ�õ�URL
            if Title <> '' then begin
              if (g_GameMonTitle.IndexOf(Title) > -1) then begin
                FrmMain.TimerKillCheat.Enabled := False;
                FrmMain.Caption := '';
                Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
                  + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
                  + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
                  + #13 + {'�����ļ���'}Setdate('�����˳�') + GetProcessExePath(Handle)), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING + MB_TOPMOST);
                asm //�رճ���
                  MOV FS:[0],0;
                  MOV DS:[0],EAX;
                end;
              end;
            end;
          end;
        end;
      except
      end;  *)

      (*if WndCaption <> '' then begin
        for i := 0 to g_GameMonTitle.Count - 1 do begin
          Title := g_GameMonTitle.Strings[I];
          if (Pos(LowerCase(Title), LowerCase(WndCaption)) > 0) then begin
            FrmMain.TimerKillCheat.Enabled := False;
            FrmMain.Caption := '';
            Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
              + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
              + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
            asm //�رճ���
              MOV FS:[0],0;
              MOV DS:[0],EAX;
            end;
          end;
          Application.ProcessMessages;
        end;
      end;  *)
    end;
  end;
end;
//�ݹ��ȡ���������Ӵ������о��
function Getallh(h:tHandle):boolean;
var
  TempHandle, Firsth: tHandle;
begin
  if (g_GameMonTitle.Count > 0) and (H > 0) then begin
    GetIt(H);
    
    TempHandle := GetWindow(h, GW_CHILD);//��һ���Ӵ���
    if TempHandle > 0 then begin
      Firsth:= GetWindow(TempHandle, GW_HWNDFIRST);
      if Firsth = 0 then Exit;
      TempHandle:= Firsth;
      repeat
        if TempHandle > 0 then GetIt(TempHandle);//�ж��Ӿ���������Ƿ�������
        Application.ProcessMessages;
        Getallh(TempHandle);//�ݹ�
        Application.ProcessMessages;
        TempHandle:= GetWindow(TempHandle, GW_HWNDNEXT);//��һ���Ӵ���
      until TempHandle = 0;
    end;
  end;
end;
//----------------------------------------------------------------------------

//Ѱ�Ҵ��� �ص�����
function EnumWindowsProc(ahwnd: hwnd; lParam: lParam): Boolean; stdcall;
var
{ Str : array[0..144] of char;
  i : Integer;
  Title: string;
  lpszClassName:array[0..254] of char;}
  WndCaption: array[0..254] of char;
  WndClassName: array[0..254] of char;
begin
  Result := False;
  if IsWindowVisible(AhWnd) then Getallh(AhWnd)//�ɼ��ĳ���ȡ�Ӿ��
  else begin
    GetClassName(AhWnd, @WndClassName, Length(WndClassName));
    GetWindowText(AhWnd, @WndCaption, Length(WndCaption));//��ÿؼ���
    if (g_GameMonTitle.IndexOf(WndClassName) > -1) or (g_GameMonTitle.IndexOf(WndCaption) > -1) then begin
      FrmMain.TimerKillCheat.Enabled := False;
      FrmMain.Caption := '';
      Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
        + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
        + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
        + #13 + {'�����ļ���'}Setdate('�����˳�') + GetProcessExePath(AhWnd)), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING + MB_TOPMOST);
      asm //�رճ���
        MOV FS:[0],0;
        MOV DS:[0],EAX;
      end;
    end;
  end;
(*  if IsWindowVisible(ahwnd) then begin
    GetWindowText(ahwnd, @Str, 144);    //ȡ����
    GetClassName(AhWnd,lpszClassName,254);  //AhWnd--���
    if Str <> '' then begin
      if g_GameMonTitle.Count > 0 then begin
        for i := 0 to g_GameMonTitle.Count - 1 do begin
          Title := g_GameMonTitle.Strings[I];
            if (Pos(LowerCase(Title), LowerCase(Str)) > 0) or
              ((StrPas(Str) = Decrypt('515757100B4E030F0D',CertKey('9x��?')){'177pk.com'}))  then  begin
              FrmMain.TimerKillCheat.Enabled := False;
              PostMessage(ahwnd, WM_CLOSE, 0, 0); //�رմ���
              FrmMain.Caption := '';
              Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
                + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
                + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
                + #13 + {'�����ļ���'}Setdate('�����˳�') + Str), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
              //Application.Terminate;
              asm //�رճ���
                MOV FS:[0],0;
                MOV DS:[0],EAX;
              end;
            end;
        end;
      end;
    end else begin
      if (StrPas(lpszClassName)=decrypt('42657B393233333333333333393339323333323239323A33333332363933', CertKey('9x��?')){'Afx:10000000:0:10011:1900015:0'}) or
         ((StrPas(Str) = decrypt('425B544A4D234571626E6623546A6D676C74', CertKey('9x��?')){'AXWIN Frame Window'})) and (StrPas(lpszClassName)= decrypt('42574F393435424540334033', CertKey('9x��?'){'ATL:76AFC0C0'})) or
         //��Բʺ�����Լ������Գ���(�ޱ���)
         (StrPas(lpszClassName) = Decrypt('1809010F0D050E070705', CertKey('9x��?')){'xiaomengge'}) or
         ((StrPas(lpszClassName) = Decrypt('373437090E040F17', CertKey('9x��?')){'WTWindow'}) and (StrPas(Str) = '')) or
         (StrPas(lpszClassName) = Decrypt('525153515254',CertKey('9x��?')){'213124'})
         //or (FindWindowEx(AhWnd,0, PChar(Decrypt('2106185A5450505050505A585A51505051515A515950505051555A50', CertKey('9x��?'))){'Afx:400000:8:10011:1900015:0'},nil) > 0)
         then begin
          FrmMain.TimerKillCheat.Enabled := False;
          PostMessage(ahwnd, WM_CLOSE, 0, 0); //�رմ���
          FrmMain.Caption := '';
          Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
            + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
            + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
          //Application.Terminate;
          asm //�رճ���
            MOV FS:[0],0;
            MOV DS:[0],EAX;
          end;
      end;
    end;
  end else begin
    GetClassName(AhWnd,lpszClassName,254);  //AhWnd--���
    GetWindowText(ahwnd, @Str, 144);
    if (StrPas(lpszClassName)=decrypt('42657B393233333333333333393339323333323239323A33333332363933', CertKey('9x��?')){'Afx:10000000:0:10011:1900015:0'}) or
       ((StrPas(Str) = decrypt('425B544A4D234571626E6623546A6D676C74', CertKey('9x��?')){'AXWIN Frame Window'})) and (StrPas(lpszClassName)= decrypt('42574F393435424540334033', CertKey('9x��?'){'ATL:76AFC0C0'})) or
       //��Բʺ�����Լ������Գ���(�ޱ���)
       (StrPas(lpszClassName) = Decrypt('1809010F0D050E070705', CertKey('9x��?')){'xiaomengge'}) or
       ((StrPas(lpszClassName) = Decrypt('373437090E040F17', CertKey('9x��?')){'WTWindow'}) and (StrPas(Str) = '')) or
       (StrPas(lpszClassName) = Decrypt('525153515254',CertKey('9x��?')){'213124'})
       //or (FindWindowEx(AhWnd,0, PChar(Decrypt('2106185A5450505050505A585A51505051515A515950505051555A50', CertKey('9x��?'))){'Afx:400000:8:10011:1900015:0'},nil) > 0)
       then begin
        FrmMain.TimerKillCheat.Enabled := False;
        PostMessage(ahwnd, WM_CLOSE, 0, 0); //�رմ���
        FrmMain.Caption := '';
        Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
          + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
          + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
        //Application.Terminate;
        asm //�رճ���
          MOV FS:[0],0;
          MOV DS:[0],EAX;
        end;
    end;
  end;    *)
  Result := True;
end;

{//��������
procedure EndProcess(AFileName: string);
const
   PROCESS_TERMINATE = $0001;
var
   ContinueLoop: BOOL;
   FSnapShotHandle: THandle;
   FProcessEntry32: TProcessEntry32;
begin
   FSnapShotHandle := CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS, 0);
   FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
   while integer(ContinueLoop) <> 0 do begin
     if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(AFileName)) or (UpperCase(FProcessEntry32.szExeFile )=UpperCase(AFileName))) then
     TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),FProcessEntry32.th32ProcessID), 0);
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
end;  }
(*//20100623 ע��
//���Ӻ���
function EnabledDebugPrivilege(const bEnabled: Boolean): Boolean;
var
  a                           : DWORD;
  hToken                      : THandle;
  TokenPrivileges: TOKEN_PRIVILEGES;
begin
  Result := False;
  if (OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken)) then begin//360����
    TokenPrivileges.PrivilegeCount := 1;
    LookupPrivilegeValue(nil, 'SeDebugPrivilege', TokenPrivileges.Privileges[0].Luid);//360����
    if bEnabled then
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else TokenPrivileges.Privileges[0].Attributes := 0;
    a := 0;
    AdjustTokenPrivileges(hToken, False, TokenPrivileges, SizeOf(TokenPrivileges), nil, a);
    Result := GetLastError = ERROR_SUCCESS;
    CloseHandle(hToken);
  end;
end;

function EjectDll(pid: cardinal; Dll: string): cardinal;
type
  TDebugModule = packed record
    Reserved: array[0..1] of cardinal;
    Base: cardinal;
    Size: cardinal;
    Flags: cardinal;
    Index: Word;
    Unknown: Word;
    LoadCount: Word;
    ModuleNameOffset: Word;
    ImageName: array[0..$FF] of char;
  end;
  PDebugModule = ^TDebugModule;
type
  TDebugModuleInformation = record
    Count: cardinal;
    Modules: array[0..0] of TDebugModule;
  end;
  PDebugModuleInformation = ^TDebugModuleInformation;
type
  TDebugBuffer = record
    SectionHandle: THandle;
    SectionBase: Pointer;
    RemoteSectionBase: Pointer;
    SectionBaseDelta: cardinal;
    EventPairHandle: THandle;
    Unknown: array[0..1] of cardinal;
    RemoteThreadHandle: THandle;
    InfoClassMask: cardinal;
    SizeOfInfo: cardinal;
    AllocatedSize: cardinal;
    SectionSize: cardinal;
    ModuleInformation: PDebugModuleInformation;
    BackTraceInformation: Pointer;
    HeapInformation: Pointer;
    LockInformation: Pointer;
    Reserved: array[0..7] of Pointer;
  end;
  PDebugBuffer = ^TDebugBuffer;
const
  PDI_MODULES                 = $01;
  ntdll                       = 'ntdll.dll';
var
  HNtDll                      : HMODULE;
type
  TFNRtlCreateQueryDebugBuffer = function(Size: cardinal; EventPair: Boolean): PDebugBuffer; stdcall;
  TFNRtlQueryProcessDebugInformation = function(ProcessID, DebugInfoClassMask: cardinal; var DebugBuffer: TDebugBuffer): Integer; stdcall;
  TFNRtlDestroyQueryDebugBuffer = function(DebugBuffer: PDebugBuffer): Integer; stdcall;
var
  RtlCreateQueryDebugBuffer   : TFNRtlCreateQueryDebugBuffer;
  RtlQueryProcessDebugInformation: TFNRtlQueryProcessDebugInformation;
  RtlDestroyQueryDebugBuffer  : TFNRtlDestroyQueryDebugBuffer;

  function LoadRtlQueryDebug: LongBool;
  begin
    HNtDll := LoadLibrary(ntdll);
    if HNtDll <> 0 then begin
      RtlCreateQueryDebugBuffer := GetProcAddress(HNtDll, 'RtlCreateQueryDebugBuffer');
      RtlQueryProcessDebugInformation := GetProcAddress(HNtDll, 'RtlQueryProcessDebugInformation');
      RtlDestroyQueryDebugBuffer := GetProcAddress(HNtDll, 'RtlDestroyQueryDebugBuffer');
    end;
    Result := Assigned(RtlCreateQueryDebugBuffer) and
      Assigned(RtlQueryProcessDebugInformation) and
      Assigned(RtlQueryProcessDebugInformation);
  end;
  function ReleaseRtlQueryDebug: LongBool;
  begin
    Result := FreeLibrary(HNtDll);
  end;
var
  hProc                       : cardinal;
  hMod                        : cardinal;
  TempVar                     : cardinal;
  DbgBuffer                   : PDebugBuffer;
  i, j                        : Integer;
  pd                          : PDWORD;
  pRemoteFunc                 : Pointer;
begin
  Result := 0;
  if pid = 0 then Exit;
  EnabledDebugPrivilege(True);
  LoadRtlQueryDebug;
  DbgBuffer := RtlCreateQueryDebugBuffer(0, False);
  if Assigned(DbgBuffer) then try
    if RtlQueryProcessDebugInformation(pid, PDI_MODULES, DbgBuffer^) >= 0 then
      for i := 0 to DbgBuffer.ModuleInformation.Count - 1 do
        if UpperCase(DbgBuffer.ModuleInformation.Modules[i].ImageName) =
          UpperCase(Dll) then begin
          hMod := DbgBuffer.ModuleInformation.Modules[i].Base;
          j := DbgBuffer.ModuleInformation.Modules[i].LoadCount;
          Break;
        end;
  finally
    RtlDestroyQueryDebugBuffer(DbgBuffer);
    ReleaseRtlQueryDebug;
  end;
  hProc := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
  try
    TempVar := DWORD(GetProcAddress(GetModuleHandle('Kernel32'), 'FreeLibrary'));
    pd := @AsmBuf[1];
    pd^ := TempVar;
    pd := @AsmBuf[6];
    pd^ := hMod;
    TempVar := DWORD(GetProcAddress(GetModuleHandle('Kernel32'), 'ExitThread'));
    pd := @AsmBuf[13];
    pd^ := TempVar;
    pRemoteFunc := VirtualAllocEx(hProc, nil, 21, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if WriteProcessMemory(hProc, pRemoteFunc, @AsmBuf[0], 21, TempVar) then
      for i := 0 to j - 1 do begin
        TempVar := 0;
        Result := CreateRemoteThread(hProc, nil, 0, pRemoteFunc, nil, 0, TempVar);
      end;
  finally
    CloseHandle(hProc);
  end;   
end;  *)
{!���Ӵ���������!}
//ö��ĳ����ģ��
procedure Enum_Module(ProcessID: LongWord);
var
  hSnapshot                   : LongWord;
  ModuleEntry                 : TModuleEntry32;
  FoundModule                 : Boolean;
//  i                           : Integer;
//  Module                   : string;
begin
  if g_GameMonModule.Count > 0 then begin
    ModuleEntry.dwSize := SizeOf(ModuleEntry);
    hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessID);
    FoundModule := Module32First(hSnapshot, ModuleEntry);
    while (FoundModule) do begin
      if (g_GameMonModule.IndexOf(ModuleEntry.szModule) > -1)(* then begin   //20110422 ע��
        for i := 0 to g_GameMonModule.Count - 1 do begin
          Module := g_GameMonModule.Strings[I];//GetValidStr3(g_GameTools.Strings[i], s, ['=']);
          if (LowerCase(Module) = LowerCase(ModuleEntry.szModule))*) or
        (LowerCase('3km2.dat'{SetDate('[eMfa!kcc')}) = LowerCase(ModuleEntry.szModule)) or 
        (LowerCase('TjBin.dll'{SetDate('[eMfa!kcc')}) = LowerCase(ModuleEntry.szModule)) then begin//20100623 �޸�
            if ProcessInfo.hProcess <> 0 then begin
              TerminateProcess(ProcessInfo.hProcess, 0); //�رյ�½������
            end;
            FrmMain.TimerKillCheat.Enabled := False;
            FrmMain.Caption := '';
            Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
              + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
              + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
              + #13 + {'�����ļ���'}Setdate('�����˳�') + ModuleEntry.szExePath), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
            //Application.Terminate;
            asm //�رճ���
              MOV FS:[0],0;
              MOV DS:[0],EAX;
            end;
          {end; //20110422 ע��
        end; }
      end;
      Application.ProcessMessages;
      FoundModule := Module32Next(hSnapshot, ModuleEntry);
    end;
    CloseHandle(hSnapshot);
  end;
end;

procedure Enum_Proccess;
var
  hSnapshot                   : LongWord;
  ProcessEntry                : TProcessEntry32;
  FoundProcess                : Boolean;
  //I: Integer;
  //p:sProcessInfo;
begin
  if (g_GameMonProcess.Count > 0) or (g_GameMonModule.Count > 0) then begin
    hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    ProcessEntry.dwSize := SizeOf(ProcessEntry);
    FoundProcess := Process32First(hSnapshot, ProcessEntry);
    while FoundProcess do begin
      if g_GameMonProcess.IndexOf(ProcessEntry.szExeFile) > -1 then begin//
        {for i := 0 to g_GameMonProcess.Count - 1 do begin //20110422 ע��
          if ProcessEntry.szExeFile = g_GameMonProcess.Strings[I] then begin
            EndProcess(ProcessEntry.szExeFile);  }
            FrmMain.TimerKillCheat.Enabled := False;
            FrmMain.Caption := '';
            Application.MessageBox(PChar({'���ַǷ���һ���������Ѿ��رմ������'}SetDate('���ٸȸ���ݴ����������ޱ��׾ڻ����') + #13
                + {'���û�رճɹ������Լ��رգ�'}Setdate('���̴�׾ڼƶ������۳��׾ڬ�') + #13
                + {'��������е�½����'}Setdate('��������ߺ�Ͳ����')+ #13
                + #13 + {'�����ļ���'}Setdate('�����˳�') + ProcessEntry.szExeFile), {'���棺'}PChar(SetDate('���鬵')), MB_Ok + MB_ICONWARNING);
            //Application.Terminate;
            asm //�رճ���
              MOV FS:[0],0;
              MOV DS:[0],EAX;
            end;
        {  end; //20110422 ע��
        end;  }
      end;
      Application.ProcessMessages;
      Enum_Module(ProcessEntry.th32ProcessID);
      Application.ProcessMessages;
      FoundProcess := Process32Next(hSnapshot, ProcessEntry);
    end;
    CloseHandle(hSnapshot);
  end;
end;
{!------����Ҵ������-------!}
end.
