unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls,  Mask,
  BusinessSkinForm, bsSkinCtrls,
  bsSkinBoxCtrls, bsSkinShellCtrls, DBTables;

type
  TFrmLogin = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    EditServerDir: TbsSkinDirectoryEdit;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinStdLabel3: TbsSkinStdLabel;
    EditDBBase: TbsSkinEdit;
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation
uses Main, EGameToolsShare, DM;
{$R *.dfm}



procedure TFrmLogin.bsSkinButton1Click(Sender: TObject);
var
  ap: TStringList;
  sDir: string;
begin

  sDir := EditServerDir.Text;
  if not (sDir[length(sDir)] = '\') then begin
    FrmMain.bsSkinMessage1.MessageDlg('�汾Ŀ¼�������һ���ַ�����Ϊ"\"������',mtInformation,[mbOK],0);
    EditServerDir.SetFocus;
    exit;
  end;
  sGameDirectory := sDir;
  DBEName := Trim(EditDBBase.Text);
 ap := Tstringlist.Create;
 session.GetAliasNames(ap);
 if (ap.IndexOf(Trim(EditDBBase.Text)) = -1)then begin
    FrmMain.bsSkinMessage1.MessageDlg('û��⵽"'+DBEName+'"����Դ',mtInformation,[mbOK],0);
    ap.Free;
    Exit;
 end;

 if SaveConfig then begin
    FrmMain.Open;
    FrmDM.Query1.DatabaseName:= DBEName;//20080304 ��������Դ
    Close;
 end;
  ap.Free;
end;

procedure TFrmLogin.bsSkinButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;


procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  LoadConfig; //��������
  EditServerDir.Text:= sGameDirectory;
  EditDBBase.Text:= DBEName;
end;

end.
