unit DenyChrName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TDenyChrNameFrm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox24: TGroupBox;
    sDisableNameList: TListBox;
    GroupBox25: TGroupBox;
    Label22: TLabel;
    DisableName_Edt: TEdit;
    DisableName_Add: TButton;
    DisableNameListDelete: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DisableStrList();
    procedure FormShow(Sender: TObject);
    procedure sDisableNameListClick(Sender: TObject);
    procedure DisableName_EdtChange(Sender: TObject);
    procedure DisableName_AddClick(Sender: TObject);
    procedure DisableNameListDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DenyChrNameFrm: TDenyChrNameFrm;

implementation
uses DBShare; 
{$R *.dfm}

procedure TDenyChrNameFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TDenyChrNameFrm.FormDestroy(Sender: TObject);
begin
  DenyChrNameFrm:= nil;
end;

procedure TDenyChrNameFrm.DisableStrList();
var
  I: Integer;
begin
  sDisableNameList.Clear;
  DisableName_Edt.Text := '';
  if DenyChrNameList.Count > 0 then begin
    for I := 0 to DenyChrNameList.Count - 1 do begin
      sDisableNameList.Items.Add(DenyChrNameList.Strings[I]);
    end;
  end;
end;

procedure TDenyChrNameFrm.FormShow(Sender: TObject);
begin
  DisableStrList();
end;

procedure TDenyChrNameFrm.sDisableNameListClick(Sender: TObject);
begin
  if sDisableNameList.ItemIndex >= 0 then DisableNameListDelete.Enabled := True;
end;

procedure TDenyChrNameFrm.DisableName_EdtChange(Sender: TObject);
begin
  DisableName_Add.Enabled:= True;
end;

procedure TDenyChrNameFrm.DisableName_AddClick(Sender: TObject);
var
  I: Integer;
  sFileName: string;
begin
    for I := 0 to sDisableNameList.Items.Count - 1 do begin
      if sDisableNameList.Items.Strings[I] = Trim(DisableName_Edt.text) then begin
        Application.MessageBox('�˽�ɫ���������б��У�����', '������Ϣ', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    sDisableNameList.Items.Add(Trim(DisableName_Edt.text));

//�������ӵ���Ϣ���ļ���
  sFileName := 'DenyChrName.txt';

  DenyChrNameList.Clear;
  for I := 0 to sDisableNameList.Items.Count - 1 do
    DenyChrNameList.Add(Trim(sDisableNameList.Items.Strings[I]));

  try
    DenyChrNameList.SaveToFile(sFileName);
  except
    if boViewHackMsg then MainOutMessage('[�쳣] TDenyChrNameFrm.DisableName_AddClick');
  end;
  DisableName_Add.Enabled:=False;
  DisableName_Edt.text:='';
end;

procedure TDenyChrNameFrm.DisableNameListDeleteClick(Sender: TObject);
var
  I: Integer;
  sFileName: string;
begin
  if sDisableNameList.ItemIndex >= 0 then
    sDisableNameList.Items.Delete(sDisableNameList.ItemIndex);

//����ɾ������Ϣ���ļ���
  sFileName := 'DenyChrName.txt';
  DenyChrNameList.Clear;
  for I := 0 to sDisableNameList.Items.Count - 1 do
    DenyChrNameList.Add(Trim(sDisableNameList.Items.Strings[I]));

  try
    DenyChrNameList.SaveToFile(sFileName);
  except
    if boViewHackMsg then MainOutMessage('[�쳣] TDenyChrNameFrm.DisableNameListDeleteClick');
  end;
end;

end.
