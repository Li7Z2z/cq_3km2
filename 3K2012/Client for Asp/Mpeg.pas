unit Mpeg;

interface
uses
  Windows,AsphyreDXDShow,ActiveX,Controls;
type
  TMPEG = class
  private
    g_pGraphBuilder: IGraphBuilder;
    g_pMediaControl: IMediaControl; // ���Š�B�O��.
    g_pMediaSeeking: IMediaSeeking; // ����λ��.
    g_pAudioControl: IBasicAudio; // ����/ƽ���O��.
    g_pVideoWindow: IVideoWindow; //�O�ò��ű��.
    boInit     :Boolean;
    boPlay     :Boolean;
    MovieWindow :TWinControl;
    function Init():Boolean;
    procedure Close();
//    function boStop(): Boolean; //�ж��Ƿ����
    { Private declarations }
  public
    constructor Create(PlayWindow:TWinControl);
    destructor Destroy; override;
    function GetState: Longint;
    function GetPosition: Int64;
    function GetStopPosition: Int64;
    function Play(sFileName:String):Boolean;
    procedure Pause();
    procedure Stop();
    { Public declarations }
  end;
implementation


{ TMPEG }

procedure TMPEG.Close;
begin
  if Assigned(g_pMediaControl) then g_pMediaControl.Stop; // ጷ������õ��Ľ��档
  if Assigned(g_pAudioControl) then g_pAudioControl := nil;
  if Assigned(g_pMediaSeeking) then g_pMediaSeeking := nil;
  if Assigned(g_pMediaControl) then g_pMediaControl := nil;
  if Assigned(g_pVideoWindow) then g_pVideoWindow := nil;
  if Assigned(g_pGraphBuilder) then g_pGraphBuilder := nil;
  
  CoUninitialize;
  boInit:=False;
end;

constructor TMPEG.Create(PlayWindow:TWinControl);
begin
  MovieWindow:=PlayWindow;
  g_pGraphBuilder:=nil;
  g_pMediaControl:=nil;
  g_pMediaSeeking:=nil;
  g_pAudioControl:=nil;
  g_pVideoWindow:=nil;
//  boInit:=Init();
  boInit:=False;
end;

destructor TMPEG.Destroy;
begin
  Close();
  inherited;
end;

function TMPEG.Init: Boolean;
begin
  Result := false; // ��ʼ��COM����
  if failed(CoInitialize(nil)) then exit; // ����DirectShow Graph
  if failed(CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC, TGUID(IID_IGraphBuilder), g_pGraphBuilder)) then exit; // �@ȡIMediaControl ����
  if failed(g_pGraphBuilder.QueryInterface(IID_IMediaControl, g_pMediaControl)) then exit; // �@ȡIMediaSeeking ����
  if failed(g_pGraphBuilder.QueryInterface(IID_IMediaSeeking, g_pMediaSeeking)) then exit; // �@ȡIBasicAudio ����
  if failed(g_pGraphBuilder.QueryInterface(IID_IBasicAudio, g_pAudioControl)) then exit; // �@ȡIVideowindow ����
  if failed(g_pGraphBuilder.QueryInterface(IID_IVideoWindow, g_pVideoWindow)) then exit; // ���н���@ȡ�ɹ� R
  Result := true;
end;

procedure TMPEG.Pause;
begin
  g_pMediaControl.Pause;
end;

function TMPEG.Play(sFileName: String): Boolean;
var
  _hr: Hresult;
  wFile: array[0..(MAX_PATH * 2) - 1] of char;
begin
  try
    Result:=False;
    boInit:=Init();
    MultiByteToWideChar(CP_ACP, 0, pchar(sFileName), -1, @wFile, MAX_PATH); //�D�Q��ʽ
    _hr := g_pGraphBuilder.renderfile(@wfile, nil);
    if failed(_hr) then exit;
    if MovieWindow <> nil then begin
      g_pVideoWindow.put_Owner(MovieWindow.Handle);
      g_pVideoWindow.put_windowstyle(WS_CHILD or WS_Clipsiblings);
      g_pVideoWindow.SetWindowposition(0, 0, MovieWindow.Width, MovieWindow.Height); //���ŵĈD������panel1��ClientRect//
    end;
  //  g_pVideoWindow.SetWindowposition(0, 0, MovieWindow.Width, MovieWindow.Handle); //���ŵĈD������panel1��ClientRect//
  //  g_pAudioControl.put_Volume(VOLUME_FULL);//�O�à��������

    if Failed(g_pMediaControl.Run) then Exit;
    Result := True;
    boPlay := true;
  except
  end;
end;

function TMPEG.GetState: Longint;
var
  AState: Longint;
begin
  if not boInit then exit;
  g_pMediaControl.GetState(0,AState);
  Result:=AState;
end;

function TMPEG.GetPosition: Int64;
begin
  if boInit then
    g_pMediaSeeking.GetCurrentPosition(Result)
  else
    Result := 0;
    //DebugOutStr('GetPosition:'+inttostr(Result));
end;

function TMPEG.GetStopPosition: Int64;
begin
  if boInit then
    g_pMediaSeeking.GetStopPosition(Result) 
  else
    Result := 0;
    //DebugOutStr('GetStopPosition'+inttostr(Result));
end;


procedure TMPEG.Stop;
begin
  if not boInit then exit;
    g_pMediaControl.Stop;
    Close();
end;

end.

