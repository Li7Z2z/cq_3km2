program MakeServer;

uses
  Forms, Windows,
  Main in 'Main.pas' {FrmMain},
  BasicSet in 'BasicSet.pas' {FrmBasicSet},
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  EDcode in '..\Common\EDCode.pas',
  EDcodeUnit in '..\Common\EDcodeUnit.pas',
  Common in '..\Common\Common.pas',
  Share in 'Share.pas',
  MakeThread in 'MakeThread.pas';

Resourcestring
  FMutex = 'Mutex_3KM2ONLY_ONE';//���������

{$R *.res}
{$R .\����ע���ļ�\data.Res}
var
  hMutex: HWND;
  iRet: integer;

begin
  Application.Initialize;
  hMutex := CreateMutex(nil,False,PChar(FMutex));//�����������
  iRet := GetLastError;
  if iRet <>ERROR_ALREADY_EXISTS then begin//��������ɹ�
    Application.Title := 'qk�Ƽ�������';
    Application.CreateForm(TFrmMain, FrmMain);
    Application.CreateForm(TFrmBasicSet, FrmBasicSet);
    Application.Run;
  end;
  ReleaseMutex(hMutex);
end.
