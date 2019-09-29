unit EngineRegister;

interface

uses
  SysUtils, Classes, Controls, Forms, WinlicenseSDK, Windows,
  Dialogs, StdCtrls, RzButton, Mask, RzEdit, jpeg, ExtCtrls;

type
  TFrmRegister = class(TForm)
    RzBitBtnRegister: TRzBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    EditUserName: TRzEdit;
    EditRegisterName: TRzEdit;
    Label4: TLabel;
    CompanyNameEdit: TRzEdit;
    Label5: TLabel;
    EditIPdata: TRzEdit;
    Label6: TLabel;
    RegDateTime: TRzEdit;
    Label2: TLabel;
    RzEdit1: TRzEdit;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure RzBitBtnRegisterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmRegister: TFrmRegister;

implementation
uses M2Share, SDK , DESCrypt;
{$R *.dfm}
procedure TFrmRegister.Open();
var
  MachineId: array [0..100] of AnsiChar;
  RegName: array [0..255] of AnsiChar;
  CompanyName: array [0..255] of AnsiChar;
  CustomData: array [0..255] of AnsiChar;
  TrialDate: SYSTEMTIME;
begin
{$IF UserMode1 = 2}
  if not WLProtectCheckDebugger then begin//�������������ڴ���
    EditRegisterName.Text := 'http://3KM2.com';
    TrialDate.wYear := 0;
    TrialDate.wMonth := 0;
    TrialDate.wDay := 0;
    TrialDate.wSecond := 0;
    TrialDate.wDayOfWeek := 0;
    TrialDate.wHour := 0;
    TrialDate.wMinute := 0;
    TrialDate.wSecond := 0;
    TrialDate.wMilliseconds := 0;

    {$I VM_Start.inc}//�������ʶ
    WLHardwareGetID(MachineId);//ȡӲ��ID
    {$I VM_End.inc}
    {$I Encode_Start.inc}//������ܱ�ʶ
    if WLHardwareCheckID(MachineId) and (pMaxPlayCount^ > 10000) then begin//���Ӳ��ID�Ƿ�Ϸ�
      EditRegisterName.Text := MachineId;
      WLRegGetLicenseInfo(RegName, CompanyName, CustomData);//��ȡע����Ϣ
      EditUserName.Text := RegName;//�û�
      CompanyNameEdit.Text := CompanyName;//��˾
      EditIPdata.Text := {CustomData}'-';//IP
      //WLRegExpirationDate(Addr(TrialDate));//ȡ��������
      WLRegExpirationDate(TrialDate);//ȡ�������� 20101128�޸�WL����,������2140��
      if TrialDate.wYear <> 0 then begin
        RegDateTime.text := DateToStr(SystemTimeToDateTime(TrialDate));
      end else RegDateTime.text := '-';
      RzEdit1.Text := IntToStr({WLRegDaysLeft()}WLRegDateDaysLeft);

      {  WLRegLicenseCreationDate(TrialDate);
        MainOutMessage(Format('WLRegExecutionsLeft:%d WLRegTotalExecutions:%d WLRegTotalDays:%d %s %d %d WLRegTotalDays:%d',[WLRegExecutionsLeft,
          WLRegTotalExecutions,
          WLRegTotalDays,
          DateToStr(SystemTimeToDateTime(TrialDate)),
          WLRegDateDaysLeft(),
          WLRegGlobalTimeLeft(),
          WLRegTotalDays]));  }

      {  WLRegExecutionsLeft--��������������Ŀǰ�������Կ
        WLRegTotalExecutions����������Ŀǰ�������Կ
        WLRegTotalDays��������Ŀǰ�������Կ
        WLRegLicenseCreationDate//���֤��������   }

      ShowModal;
    end else begin
      asm //�رճ���
        MOV FS:[0],0;
        MOV DS:[0],EAX;
      end;    
    end;
    {$I Encode_End.inc}
  end;
{$IFEND}
end;

procedure TFrmRegister.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmRegister.FormDestroy(Sender: TObject);
begin
  FrmRegister:= nil;
end;

procedure TFrmRegister.RzBitBtnRegisterClick(Sender: TObject);
begin
  Close;
end;
end.
