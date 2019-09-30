unit UpRegM2Date;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TUpRegM2DateFrm = class(TForm)
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Edit7: TEdit;
    EdtDLName: TEdit;
    Edit1: TEdit;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    EdtUserAccount: TEdit;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    StatusBar1: TStatusBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    bois176: Boolean;
  public
    procedure Open(is176: Boolean);
  end;

var
  UpRegM2DateFrm: TUpRegM2DateFrm;
  dwRegM2Tick: LongWord;
implementation

uses Main, Share, Common, StrUtils;
{$R *.dfm}

procedure TUpRegM2DateFrm.BitBtn1Click(Sender: TObject);
  function CheckAccountName(sName: string): Boolean;//����Ƿ��зǷ��ַ�
  begin
    Result := False;
    if (sName = '') or (pos('/',sName) > 0) or (pos('\',sName) > 0) or
       (pos(':',sName) > 0) or (pos('?',sName) > 0) or (pos('<',sName) > 0) or
       (pos('>',sName) > 0) then Exit;
    Result := true;
  end;
var
  sUserTpye: String;
begin
  if not g_boConnect then begin
    Application.MessageBox('�ͷ������Ѿ��Ͽ�����,�����µ�½��', '����', MB_OK + MB_ICONSTOP);
    Exit;
  end;
  if RadioButton1.Checked then sUserTpye:= '[��������]' else sUserTpye:= '[��������]';
  if Application.MessageBox(PChar(sUserTpye+'�Ƿ�ȷ�������û����ڣ�ע��:���ڳɹ���ӵ��ռ���ʹ������'), '��ʾ',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    if Trim(EdtUserAccount.Text) = '' then begin
      Application.MessageBox('����д�û���½�ʺţ�', 'Error', MB_OK + MB_ICONSTOP);
      EdtUserAccount.SetFocus;
      Exit;
    end;
    if not CheckAccountName(Trim(EdtUserAccount.Text)) then begin
      Application.MessageBox('�û���½�ʺŰ����Ƿ��ַ���', 'Error', MB_OK + MB_ICONSTOP);
      EdtUserAccount.SetFocus;
      Exit;
    end;
    if GetTickCount - dwRegM2Tick < 5000 then begin
      Application.MessageBox('��������죬���Ժ������', 'Error', MB_OK + MB_ICONWARNING);
      Exit;
    end;
    sUserTpye:= '';
    if RadioButton1.Checked then sUserTpye := '1' //����ע��M2���� 20110712
    else if RadioButton2.Checked then sUserTpye := '2';

    FrmMain.SendM2DateUpdata(EdtUserAccount.Text, sUserTpye, bois176);
    dwRegM2Tick := GetTickCount();
    StatusBar1.Panels[0].Text := '���ڽ��������û����ڣ����Ժ󡭡�';
  end;
end;

procedure TUpRegM2DateFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TUpRegM2DateFrm.FormDestroy(Sender: TObject);
begin
  UpRegM2DateFrm:= nil;
end;

procedure TUpRegM2DateFrm.Open(is176: Boolean);
begin
  if is176 then begin
    Caption := '1.76��������';
  end else Caption := '������������';
  bois176 := is176;
  EdtDLName.Text := g_MySelf.sAccount;
  Edit7.Text:= CurrToStr(g_MySelf.sM2Price);
  Edit1.Text:= CurrToStr(g_MySelf.sM2PriceMonth);//��ʾ���¼۸� 20110712
  EdtUserAccount.Text := '';
  StatusBar1.Panels[0].Text := '';
  ShowModal;
end;
end.
