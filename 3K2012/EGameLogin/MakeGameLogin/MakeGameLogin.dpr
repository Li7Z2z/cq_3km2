program MakeGameLogin;


uses
  Forms,
  Main in 'Main.pas' {MainFrm},
  Md5 in '..\LoginCommon\Md5.pas',
  AddGameList in 'AddGameList.pas' {AddGameListFrm},
  HUtil32 in '..\..\Common\HUtil32.pas',
  //MakeGameLoginShare in 'MakeGameLoginShare.pas',
  uTzHelp in 'uTzHelp.pas' {FrmTzHelp},
  uSelectDB in 'uSelectDB.pas' {FrmSelectDB},
  Common in '..\LoginCommon\Common.pas',
  uFileUnit in '..\LoginCommon\uFileUnit.pas',
  GameLoginShare in '..\LoginCommon\GameLoginShare.pas',
  FileUnit in '..\LoginCommon\FileUnit.pas';

{$R *.res}
{$R .\��Դ�ļ�\GameLogin.res}
begin
  Application.Initialize;
  Application.Title := '3K�����½��������';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TAddGameListFrm, AddGameListFrm);
  Application.CreateForm(TFrmTzHelp, FrmTzHelp);
  Application.CreateForm(TFrmSelectDB, FrmSelectDB);
  Application.Run;
end.
