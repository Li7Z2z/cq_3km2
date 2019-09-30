unit ChangePassword;

interface

uses
  Windows,  SysUtils, Forms,
  RzBmpBtn, RzLabel, Classes, Controls, StdCtrls,
  ExtCtrls, jpeg;

type
  TFrmChangePassword = class(TForm)
    ImageMain: TImage;
    RzLabel3: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    EditAccount: TEdit;
    EditPassword: TEdit;
    EditNewPassword: TEdit;
    EditConfirm: TEdit;
    ButtonOK: TRzBmpButton;
    btnCancel: TRzBmpButton;
    RzLabel10: TRzLabel;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditNewPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    procedure CreateParams(var Params:TCreateParams);override;//���ó�������� 20080412
  end;

var
  FrmChangePassword: TFrmChangePassword;
  dwOKTick     : LongWord;
implementation

uses Main, MsgBox, GameLoginShare;

{$R *.dfm}
//�û����޸����봰�� ��ʼ��
procedure TfrmChangePassword.Open;
begin
  ButtonOK.Enabled:=True;
  EditAccount.Text:='';
  EditPassword.Text:='';
  EditNewPassword.Text:='';
  EditConfirm.Text:='';
  ShowModal;
end;

procedure TFrmChangePassword.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 IF Key=13 then EditPassword.SetFocus ;
end;

procedure TFrmChangePassword.EditPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 IF Key=13 then EditNewPassword.SetFocus ;
end;

procedure TFrmChangePassword.EditNewPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 IF Key=13 then EditConfirm.SetFocus ;
end;

procedure TFrmChangePassword.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 IF Key=13 then ButtonOK.Click;
end;

procedure TFrmChangePassword.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmChangePassword.ButtonOKClick(Sender: TObject);
var
   uid, passwd, newpasswd: string;
begin
  if GetTickCount - dwOKTick < 5000 then begin
    FrmMessageBox.LabelHintMsg.Caption := {'���Ժ��ٵ�ȷ��������'}SetDate('���۵��ֺ�Ǹ��������');
    FrmMessageBox.ShowModal;
    exit;
  end;
  uid:=Trim(EditAccount.Text);
  passwd:=Trim(EditPassword.Text);
  newpasswd:=Trim(EditNewPassword.Text);
  if uid = '' then begin
    FrmMessageBox.LabelHintMsg.Caption := {'��¼�ʺ����벻��ȷ������'}SetDate('��ͳ�ŵ����佴��Ǹ������');
    FrmMessageBox.ShowModal;
    EditAccount.SetFocus;
    exit;
  end;
  if passwd = '' then begin
    FrmMessageBox.LabelHintMsg.Caption := {'���������벻��ȷ������'}SetDate('���������佴��Ǹ������');
    FrmMessageBox.ShowModal;
    EditPassword.SetFocus;
    exit;
  end;
  if length(newpasswd) < 4 then begin
    FrmMessageBox.LabelHintMsg.Caption := {'������λ��С����λ������'}SetDate('����������߮������������');
    FrmMessageBox.ShowModal;
    EditAccount.SetFocus;
    exit;
  end;  
  if newpasswd = '' then begin
    FrmMessageBox.LabelHintMsg.Caption := {'���������벻��ȷ������'}SetDate('���������佴��Ǹ������');
    FrmMessageBox.ShowModal;
    EditNewPassword.SetFocus;
    exit;
  end;
  if EditNewPassword.Text = EditConfirm.Text then begin
    FrmMain.SendChgPw (uid, passwd, newpasswd);
    dwOKTick:=GetTickCount();
    ButtonOK.Enabled:=False;
  end else begin
    FrmMessageBox.LabelHintMsg.Caption := {'������������벻ƥ�䣡����'}SetDate('�����������佴ɪ�묮����');
    FrmMessageBox.ShowModal;
    EditNewPassword.SetFocus;
   end;
end;

procedure TFrmChangePassword.CreateParams(var Params: TCreateParams);
  //���ȡ����
  function RandomGetPass():string;
  var
    s,s1:string;
    I,i0:Byte;
  begin
      s:='123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
      s1:='';
      Randomize(); //�������
      for i:=0 to 8 do begin
        i0:=random(35);
        s1:=s1+copy(s,i0,1);
      end;
      Result := s1;
  end;
var
  sClassName: string;
begin
  Inherited CreateParams(Params);
  sClassName := RandomGetPass;
  strpcopy(pchar(@Params.WinClassName),sClassName);
end;

end.
