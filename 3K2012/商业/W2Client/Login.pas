unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, RzCmboBx, Mask, RzEdit, Buttons,
  WinSkinData;

type
  TFrmLogin = class(TForm)
    BtnLogin: TBitBtn;
    BtnExit: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    EdtPass: TEdit;
    ComboBoxUser: TComboBox;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses Main, Share, EDcodeUnit, WinlicenseSDK, Clipbrd;

{$R *.dfm}

procedure TFrmLogin.BtnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
var
  sAccount: string;
  sPassword: string;
  sServerAdd: string;
begin
  sAccount := Trim(ComboBoxUser.Text);
  sPassword := Trim(EdtPass.Text);
  if sAccount = '' then begin
    Application.MessageBox('�������¼�ʺţ�', '��ʾ��Ϣ', MB_OK + MB_ICONWARNING);
    ComboBoxUser.SetFocus;
    Exit;
  end;
  if sPassword = '' then begin
    Application.MessageBox('���������룡', '��ʾ��Ϣ', MB_OK + MB_ICONWARNING);
    EdtPass.SetFocus;
    Exit;
  end;
  BtnLogin.Enabled := False;
  ComboBoxUser.Enabled := False;
  EdtPass.Enabled := False;
  g_sAccount := sAccount;
  g_sPassword := sPassword;
  Decode(g_sServerAdd, sServerAdd);
  FrmMain.ClientSocket.Active := False;
  FrmMain.ClientSocket.Host := sServerAdd;
  FrmMain.ClientSocket.Port := 36009;
  FrmMain.ClientSocket.Active := True;
  FrmMain.StatusPaneMsg.Panels[0].Text := '�������ӷ�����...';  
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  ClStr, s1:string;
  MachineId: array [0..100] of AnsiChar;
begin
  if WLProtectCheckDebugger then begin//�������������ڴ���
    asm //�رճ���
      MOV FS:[0],0;
      MOV DS:[0],EAX;
    end;
  end;
  nY:= WLRegGetStatus(nX);
  if nY = 0 then begin//�������Ƿ�ע�� û��ע������ʾ
    WLHardwareGetID(MachineId);//ȡӲ��ID
    Clipbrd.Clipboard.AsText := MachineId;//���Ƶ����а���
    //ʹ����ͨ������ܺ���
    Decode('243F2F9136D9C6465A54A4BA779F619B5EEED0F138F326D167474A5D5AC935FD77CC253F46D9021D', s1); //�벻Ҫ�޸ļ�������ڣ�ע�������
    ClStr:= s1+#13+#13;
    Decode('E7FEAF3C7D9F4C29DF69FE5E0BEF3653', s1);//������Ϣ��
    ClStr:= ClStr+s1+MachineId;
    Decode('5D3CA29078AABDFAB945726BA94B8FFB22DBA80E58FC037699E6A68EB2FC282496757BDE4AF342C4D870098E6590BBC3', s1);// (Ctrl+vճ�����ı�) ���͸�����Ա����ע��
    ClStr:= ClStr+s1+#13+#13;;
    Decode('83D7FD6174C8CE82FFE6BEC522700B9AFA458CECC1AEA7EC6CC672654BD08339DC7B66F228B8D058', s1);//�ٷ���վ��http://www.3km2.com
    ClStr:= ClStr+s1;
    Decode('4F760445F72C3BF5818267F89D7FD29A', s1);//3k���
    Application.MessageBox(PChar(ClStr) ,PChar(s1),MB_IConERROR+MB_OK);
    asm //�رճ���
      MOV FS:[0],0;
      MOV DS:[0],EAX;  
    end;
  end else
  if nY = wlIsRegistered then begin//��ע��ģ�ȡIP��Ϣ
  end else begin
    asm //�رճ���
      MOV FS:[0],0;
      MOV DS:[0],EAX;
    end;   
  end;
end;

end.
