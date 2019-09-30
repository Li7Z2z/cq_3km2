unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uRes, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Buf : PChar;
  BufSize : DWORD;
begin
  if LoadRes(Buf, BufSize) then
    ShowMessage('��ȡ�ɹ�.' + sLineBreak + IntToStr(BufSize))
  else
    ShowMessage('��ȡʧ��.');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  sSrcFile : string;
begin
  with TOpenDialog.Create(Self) do begin
    Title := 'ѡ����Ҫд����ļ�'; 
    if Execute(Self.Handle) then begin
      sSrcFile := FileName;
      with TMemoryStream.Create do begin
        LoadFromFile(sSrcFile);
        if SaveRes(Application.ExeName, ExtractFilePath(Application.ExeName) + '\Out.exe', PChar(Memory), Size) then
          ShowMessage('д��ɹ�.' + sLineBreak + IntToStr(Size))
        else
          ShowMessage('д��ʧ��.');
        Free;
      end;
    end;
    Free;
  end;

end;

end.
