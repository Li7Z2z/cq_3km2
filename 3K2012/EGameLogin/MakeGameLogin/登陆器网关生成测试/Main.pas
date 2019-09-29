unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ComCtrls, StdCtrls, ExtDlgs, jpeg, RSA;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EdtLoginName: TEdit;
    EdtClientFileName: TEdit;
    Button1: TButton;
    EdtGameListURL: TEdit;
    BtnAssistantFilter: TButton;
    EdtBakGameListURL: TEdit;
    BtnLoginMainImages: TButton;
    EdtPatchListURL: TEdit;
    BtnLoginFile: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EdtGameMonListURL: TEdit;
    EdtGameESystem: TEdit;
    EdtAssistantFilter: TEdit;
    EdtLoginMainImages: TEdit;
    EdtLoginFile: TEdit;
    Label11: TLabel;
    EdtGatePass: TEdit;
    Button5: TButton;
    BtnMakeLogin: TButton;
    BtnMakeGate: TButton;
    OpenDialog1: TOpenDialog;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    EdtGateFile: TEdit;
    BtnGateFile: TButton;
    Label13: TLabel;
    EdtTzHintFile: TEdit;
    BtnTzHintFile: TButton;
    Label14: TLabel;
    EdtPulsDescFile: TEdit;
    BtnPulsDescFile: TButton;
    RSA1: TRSA;
    CheckBoxFD: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BtnAssistantFilterClick(Sender: TObject);
    procedure BtnLoginMainImagesClick(Sender: TObject);
    procedure BtnLoginFileClick(Sender: TObject);
    procedure BtnMakeGateClick(Sender: TObject);
    procedure BtnGateFileClick(Sender: TObject);
    procedure BtnMakeLoginClick(Sender: TObject);
    procedure BtnTzHintFileClick(Sender: TObject);
    procedure BtnPulsDescFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation
uses Share, EDcodeUnit, Zlib, uFileUnit;
{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
  //���ȡ��
  function RandomGetName():string;
  var
    s,s1:string;
    I,i0:integer;
  begin
      s:='123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
      s1:='';
      Randomize(); //�������
      for i:=0 to 6 do begin
        i0:=random(35);
        s1:=s1+copy(s,i0,1);
      end;
      Result := s1;
  end;
begin
  EdtClientFileName.Text := RandomGetName()+'.THG';
end;

procedure TFrmMain.Button5Click(Sender: TObject);
  //���ȡ��
  function RandomGetName():string;
  var
    s,s1:string;
    I,i0:integer;
  begin
      s:='123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
      s1:='';
      Randomize(); //�������
      for i:=0 to 19 do begin
        i0:=random(35);
        s1:=s1+copy(s,i0,1);
      end;
      Result := s1;
  end;
begin
  EdtGatePass.Text := RandomGetName;
end;

procedure TFrmMain.BtnAssistantFilterClick(Sender: TObject);
begin
  OpenDialog1.Filter := '�ڹҹ����ļ�(*.TXT)|*.TXT';
  if OpenDialog1.Execute then begin
    EdtAssistantFilter.Text := OpenDialog1.FileName;
  end;
end;

procedure TFrmMain.BtnLoginMainImagesClick(Sender: TObject);
begin
  OpenDialog1.Filter := '��½��Ƥ���ļ�(*.3kskin)|*.3kskin';
  if OpenDialog1.Execute then begin
    EdtLoginMainImages.Text := OpenDialog1.FileName;
  end;
end;

procedure TFrmMain.BtnLoginFileClick(Sender: TObject);
begin
  OpenDialog1.Filter := '��½���ļ�(*.EXE)|*.EXE';
  if OpenDialog1.Execute then begin
    EdtLoginFile.Text := OpenDialog1.FileName;
  end;
end;

procedure TFrmMain.BtnMakeGateClick(Sender: TObject);
var
  MyRecInfo: TRecGateinfo;
begin
  if CopyFile(PChar(EdtGateFile.Text), PChar('C:\2.exe'), False) then begin
    MyRecInfo.GatePass := RSA1.EncryptStr(EdtGatePass.Text);
    if WriteGateInfo('C:\2.exe', MyRecInfo) then Application.MessageBox('�������سɹ���λ��C:\2.exe��', 
      '��ʾ', MB_OK +
      MB_ICONINFORMATION);
  end;
end;

procedure TFrmMain.BtnGateFileClick(Sender: TObject);
begin
  OpenDialog1.Filter := '�����ļ�(*.EXE)|*.EXE';
  if OpenDialog1.Execute then begin
    EdtGateFile.Text := OpenDialog1.FileName;
  end;
end;

procedure EnCompressStream(CompressedStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
  Count: int64; //ע�⣬�˴��޸���,ԭ����int
begin
  if CompressedStream.Size <= 0 then exit;
  CompressedStream.Position := 0;
  Count := CompressedStream.Size; //�������ԭʼ�ߴ�
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(clMax, DM);//���е�clMax��ʾѹ������,���Ը���,ֵ�����в���֮һ:clNone, clFastest, clDefault, clMax
  try
    CompressedStream.SaveToStream(SM); //SourceStream�б�����ԭʼ����
    SM.Free; //��ԭʼ������ѹ����DestStream�б�����ѹ�������
    CompressedStream.Clear;
    CompressedStream.WriteBuffer(Count, SizeOf(Count)); //д��ԭʼ�ļ��ĳߴ�
    CompressedStream.CopyFrom(DM, 0); //д�뾭��ѹ������
    CompressedStream.Position := 0;
  finally
    DM.Free;
  end;
end;

procedure TFrmMain.BtnMakeLoginClick(Sender: TObject);
  //�ַ����ӽ��ܺ��� 20071225
  Function SetDate(Text: String): String;
  Var
    I     :Word;
    C     :Word;
  Begin
    Result := '';
    For I := 1 To Length(Text) Do Begin
      C := Ord(Text[I]);
      Result := Result + Chr((C Xor 15));
    End;
  End;
var
  Target,Pic_Memo, TzHint, PulsDescFile, GameSdoFilterFile, MemFd: TMemoryStream;//����ļ���
  Dest_Memo, Stream: TMemoryStream;
  MyRecInfo: TRecinfo;
  nSourceFileSize: Int64;
  RecInfoStreamSize: Integer;
begin
  FillChar(MyRecInfo, SizeOf(MyRecInfo), 0);
  Pic_Memo:= TMemoryStream.Create;
  Target:=TMemoryStream.Create;
  Dest_Memo:=TMemoryStream.Create;
  Stream:= TMemoryStream.Create;
  try
    //д��ͼƬ�ļ�
    Pic_Memo.LoadFromFile(PChar(EdtLoginMainImages.Text));
    EncDecToStream(Pic_Memo, TDiyDecEncAlg(1), 'dfgt542');//������
    EnCompressStream(Pic_Memo);//ѹ����
    Target.LoadFromFile(PChar(EdtLoginFile.Text));
    Target.Position:=0;
    nSourceFileSize := Target.Size;
    Dest_Memo.SetSize(Target.Size+Pic_Memo.size);
    Dest_Memo.Position:=0;
    Dest_Memo.CopyFrom(Target,Target.Size);
    Dest_Memo.CopyFrom(Pic_Memo,Pic_Memo.Size);
    MyRecInfo.MainImagesFileSize:= Pic_Memo.Size;//ͼƬ��С

    if EdtTzHintFile.Text <> '' then begin//д����װ�ļ�
      TzHint:= TMemoryStream.Create;
      try
        TzHint.LoadFromFile(PChar(EdtTzHintFile.Text));
        EnCompressStream(TzHint);//ѹ����
        Dest_Memo.Seek(0,soFromEnd);//�ƶ�����β��
        Dest_Memo.CopyFrom(TzHint, TzHint.Size);//д����װ�ļ���
        MyRecInfo.TzHintListFileSize:= TzHint.Size;//��¼��װ�ļ���С
      finally
        TzHint.Free;
      end;
    end else MyRecInfo.TzHintListFileSize:= 0;

    if EdtPulsDescFile.Text <> '' then begin//д�뾭���ļ�
      PulsDescFile:= TMemoryStream.Create;
      try
        PulsDescFile.LoadFromFile(PChar(EdtPulsDescFile.Text));
        EnCompressStream(PulsDescFile);//ѹ����
        Dest_Memo.Seek(0,soFromEnd);//�ƶ�����β��
        Dest_Memo.CopyFrom(PulsDescFile, PulsDescFile.Size);//д�뾭���ļ���
        MyRecInfo.PulsDescFileSize:= PulsDescFile.Size;//��¼�����ļ���С
      finally
        PulsDescFile.Free;
      end;
    end else MyRecInfo.PulsDescFileSize:= 0;

    if EdtAssistantFilter.Text <> '' then begin//д���ڹ��ļ�
      GameSdoFilterFile:= TMemoryStream.Create;
      try
        GameSdoFilterFile.LoadFromFile(PChar(EdtAssistantFilter.Text));
        EnCompressStream(GameSdoFilterFile);//ѹ����
        Dest_Memo.Seek(0,soFromEnd);//�ƶ�����β��
        Dest_Memo.CopyFrom(GameSdoFilterFile, GameSdoFilterFile.Size);//д���ļ���
        MyRecInfo.GameSdoFilterFileSize:= GameSdoFilterFile.Size;//��¼�ļ���С
      finally
        GameSdoFilterFile.Free;
      end;
    end else MyRecInfo.GameSdoFilterFileSize:= 0;

    if CheckBoxFD.Checked then begin//д���ڹ��ļ�
      MemFd:= TMemoryStream.Create;
      try
        MemFd.LoadFromFile('LoginDLL.dll');
        EnCompressStream(MemFd);//ѹ����
        Dest_Memo.Seek(0,soFromEnd);//�ƶ�����β��
        Dest_Memo.CopyFrom(MemFd, MemFd.Size);//д���ļ���
        MyRecInfo.FDFileSize:= MemFd.Size;//��¼�ļ���С
      finally
        MemFd.Free;
      end;
    end else MyRecInfo.FDFileSize:= 0;


    MyRecInfo.lnkName := EdtLoginName.Text;
    MyRecInfo.GameListURL := RSA1.EncryptStr(EdtGameListURL.Text);
    MyRecInfo.BakGameListURL := RSA1.EncryptStr(EdtBakGameListURL.Text);
    MyRecInfo.boGameMon := True;
    MyRecInfo.GameMonListURL := RSA1.EncryptStr(EdtGameMonListURL.Text);
    MyRecInfo.PatchListURL := RSA1.EncryptStr(EdtPatchListURL.Text);
    MyRecInfo.GameESystemUrl := RSA1.EncryptStr(EdtGameESystem.Text);
    MyRecInfo.ClientFileName := EdtClientFileName.Text;
    MyRecInfo.GatePass := RSA1.EncryptStr(EdtGatePass.Text);
    MyRecInfo.SourceFileSize := nSourceFileSize;//Դ��½����С 

    Stream.Position:= 0;
    Stream.WriteBuffer(MyRecInfo, RecInfoSize);
    Stream.Position:= 0;
    EncDecToStream(Stream, TDiyDecEncAlg(0), 'dfgt542');//������
    EnCompressStream(Stream);//ѹ����
    Dest_Memo.Seek(0,soFromEnd);
    Dest_Memo.CopyFrom(Stream, 0);
    
    Dest_Memo.Seek(0,soFromEnd);
    RecInfoStreamSize:= Stream.Size;//�ṹ���Ĵ�С,д���ļ����
    Dest_Memo.WriteBuffer(RecInfoStreamSize, Sizeof(RecInfoStreamSize));

    Dest_Memo.SaveToFile('c:\1.exe');
    Application.MessageBox('���ɵ�½���ɹ���λ��C:\1.exe��',  '��ʾ', MB_OK + MB_ICONINFORMATION);
  finally
    Dest_Memo.free;
    Target.Free;
    Pic_Memo.Free;
    Stream.free;
  end;
end;

procedure TFrmMain.BtnTzHintFileClick(Sender: TObject);
begin
  OpenDialog1.Filter := '��װ��ʾ�ļ�(*.Txt)|*.Txt';
  if OpenDialog1.Execute then begin
    EdtTzHintFile.Text := OpenDialog1.FileName;
  end;
end;

procedure TFrmMain.BtnPulsDescFileClick(Sender: TObject);
begin
  OpenDialog1.Filter := '������ʾ�ļ�(*.Txt)|*.Txt';
  if OpenDialog1.Execute then begin
    EdtPulsDescFile.Text := OpenDialog1.FileName;
  end;
end;

end.
