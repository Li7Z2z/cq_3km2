unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Clipbrd, ShellAPI, StdCtrls, Spin, ZLib, MD5;

type
  TFrmMain = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure WMDropFiles(var Msg : TWMDropFiles); message WM_DROPFILES;
  end;

var
  FrmMain: TFrmMain;
implementation

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;

//���������д��Ĵ�С By TasNat at: 2012-04-04 11:18:07
function FillBitmapHeader(var Buf : PChar; BufSize: DWord) : DWord;
var
  FileHeader: PBitmapFileHeader;
  InfoHeader: PBitmapInfoHeader;
  AWidth, AHeight : Integer;
  dwDibSize : DWord;
  Buffer: Pointer;
begin
  BufSize := (BufSize div 4);
  AHeight := Round(Sqrt(BufSize));
  AWidth := AHeight;
  dwDibSize := AWidth * AHeight * 4;
  //��������ͼ�һ��
  if dwDibSize < BufSize then
    Inc(AHeight);

  FileHeader := PBitmapFileHeader(Buf);
  FileHeader.bfType := $4D42;
  FileHeader.bfSize := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader) + AWidth * AHeight * 4;
  FileHeader.bfOffBits := FileHeader.bfSize - AWidth * AHeight * 4;
  FileHeader.bfReserved1 := 0;
  FileHeader.bfReserved2 := 0;
  Inc(Buf, SizeOf(TBitmapFileHeader));
  // λͼ��Ϣͷ
  InfoHeader := PBitmapInfoHeader(Buf);
  InfoHeader.biSize := SizeOf(TBitmapInfoHeader);
  InfoHeader.biWidth := AWidth;
  InfoHeader.biHeight := -AHeight;
  InfoHeader.biPlanes := 1;
  InfoHeader.biBitCount := 32;
  InfoHeader.biCompression := BI_RGB; //BI_RGB;
  InfoHeader.biSizeImage := AWidth * AHeight * 4;
  InfoHeader.biXPelsPerMeter := 0;
  InfoHeader.biYPelsPerMeter := 0;
  InfoHeader.biClrUsed := 0;
  InfoHeader.biClrImportant := 0;
  Inc(Buf, SizeOf(InfoHeader^));
  Result := InfoHeader.biSizeImage;
end;

//��ת��BMP��ʽ�����ݶ� ���ݶ���4�ֽ�Ϊʵ�ʴ�С By TasNat at: 2012-04-04 11:16:34
function GotoBitmapBits(var Buf : PChar) : DWord;
var
  FileHeader: PBitmapFileHeader;
  FileInfoHeader : PBitmapInfoHeader;
begin
  FileHeader := PBitmapFileHeader(Buf);
  if FileHeader.bfType = $4D42 then begin
    FileInfoHeader := PBitmapInfoHeader(Buf + SizeOf(TBitmapFileHeader));
    Result := FileInfoHeader.biSizeImage;
    Inc(Buf, FileHeader.bfOffBits);
  end else Result := 0;
end;

procedure EnCompressStream(InStream: TMemoryStream);
var
  SM: TCompressionStream;
  DM: TMemoryStream;
begin
  if InStream.Size <= 0 then exit;
  InStream.Position := 0;
  DM := TMemoryStream.Create;
  SM := TCompressionStream.Create(clMax, DM);//���е�clMax��ʾѹ������,���Ը���,ֵ�����в���֮һ:clNone, clFastest, clDefault, clMax
  try
    InStream.SaveToStream(SM); //SourceStream�б�����ԭʼ����
    SM.Free; //��ԭʼ������ѹ����DestStream�б�����ѹ�������
    InStream.Clear;
    InStream.CopyFrom(DM, 0); //д�뾭��ѹ������
    InStream.Position := 0;
  finally
    DM.Free;
  end;
end;

procedure DeCompressStream(InStream: TMemoryStream; dwOldSize : DWord);
var
  MS: TDecompressionStream;
  Buffer: PChar;
begin
  if InStream.Size <= 0 then exit;
  InStream.Position := 0; //��λ��ָ��
  //�ӱ�ѹ�����ļ����ж���ԭʼ�ĳߴ�
  GetMem(Buffer, dwOldSize); //���ݳߴ��СΪ��Ҫ�����ԭʼ�������ڴ��
  MS := TDecompressionStream.Create(InStream);
  try
    MS.ReadBuffer(Buffer^, dwOldSize);
    //����ѹ��������ѹ����Ȼ����� Buffer�ڴ����
    InStream.Clear;
    InStream.WriteBuffer(Buffer^, dwOldSize); //��ԭʼ�������� MS����
    InStream.Position := 0; //��λ��ָ��
  finally
    FreeMem(Buffer);
    MS.Free;//20110714
  end;
end;

procedure BuildBMP(pSrc : PChar; dwSrcSize : DWord; dwBlockSize : DWord; sFileName : string; boCompress : Boolean; Log : TStrings);
var
  dwFileCount : DWord;
  dwOldSize   : DWord;
  pSrc2 : PChar;
  dwSrcSize2 : DWord;
  BlockMem  : PChar;
  sMD5 : string;
  procedure SaveOutBMPFile(pOutBuf : PChar; dwSize : DWord);
  var
    sOutFileName : string;
  begin
    repeat
      sOutFileName := sFileName + '.' + IntToStr(dwFileCount) + '.bmp';
      Inc(dwFileCount);
    until not FileExists(sOutFileName);
    with TFileStream.Create(sOutFileName, fmCreate) do begin
      Write(pOutBuf^, dwSize);
      Free;
    end;
  end;
begin
  dwFileCount := 1;
  if boCompress then begin
    Log.Add('ѹ��...');
    dwOldSize := dwSrcSize;
    CompressBuf(pSrc, dwSrcSize, Pointer(pSrc), Integer(dwSrcSize));
    Log.Strings[Log.Count -1] := 'ѹ�����...';
  end;
  GetMem(BlockMem, dwBlockSize);
  if BlockMem <> nil then begin
    sMD5 := Md5.RivestBuf(pSrc, dwSrcSize);
    inFile.Position := 0;
    repeat
      FileHeader := PBitmapFileHeader(BufMem);
      Buf := BufMem;
      dwDibSize := FillBitmapHeader(Buf, dwBufSize);
      if dwFileCount = 1 then begin
        //��һ���ļ�д��ԭʼ��С
        PDWord(Buf)^ := inFile.Size;
        Inc(Buf, SizeOf(DWord));
        Dec(dwDibSize, 4);//�޸�ʵ�ʿ���д���С
        //д��MD5
        Move(sMD5[1], Buf^, Length(sMD5));
        Inc(Buf, Length(sMD5));
        Dec(dwDibSize, Length(sMD5));//�޸Ŀ���д��Ĵ�С

        PBoolean(Buf)^ := boCompress;
        Inc(Buf, 1);
        Dec(dwDibSize);//�޸Ŀ���д��Ĵ�С
        if boCompress then begin
          pDWord(Buf)^ := dwOldSize;
          Inc(Buf, SizeOf(DWord));
          Dec(dwDibSize, SizeOf(DWord));//�޸Ŀ���д��Ĵ�С
        end;

      end;

      Dec(dwDibSize, 4);//�޸�ʵ�ʿ���д���С

      //���ļ��������ݵ�BMP��Dibs
      dwSrcSize := inFile.Read(Buf[4], dwDibSize);
      //BMP��Dibs��ʼ��Ϊ�ļ����ݴ�С
      PDWord(Buf)^ := dwSrcSize;
      if dwSrcSize <= 0 then Break;
      //д��BMP ���ݵ��ļ�
      SaveOutBMPFile(PChar(FileHeader), FileHeader.bfSize);
    until inFile.Position >= inFile.Size;
    //FreeMem(BufMem);
    Log.Add('���!');
    Log.Add('�ļ����� : ' + IntToStr(dwFileCount));
    Log.Add('--------�������--------');
    Log.Add('--------��رճ���--------');
    FreeMem(BufMem);
  end else Log.Add('�����ڴ�ʧ��!!!');
end;

procedure TFrmMain.WMDropFiles(var Msg : TWMDropFiles);
var
  I : Integer;
  NameBuf : array [0..255] of Char;
  sFileName : string;
  sMD5 : string;
  sOutFileName : string;
  sInFileName : string;
  sDir : string;
  sLine : string;
  nFileSize : Integer;
  inFile, OutFile : TMemoryStream;
  BufMem,Buf : PChar;
  dwBufSize : DWord;
  dwDibSize : DWord;
  dwSrcSize : DWord;
  FileHeader: PBitmapFileHeader;
  dwFileCount : DWord;
  boCompress : Boolean;
  dwOldSize : DWord;//ѹ����

begin
  Memo1.Clear;
  I := DragQueryFile(Msg.Drop, MAXDWORD, NameBuf, 255);
  for I := 0 to I - 1 do begin
    DragQueryFile(Msg.Drop, I, NameBuf, 255);
    sFileName := NameBuf;
    case
      Application.MessageBox(PChar('��ȷ����ʼ����' + sFileName +'?'),
      '��ʼ����',
      MB_YESNOCANCEL +
      MB_ICONQUESTION)
      of
      IDYES:
      begin
        dwFileCount := 1;
        Memo1.Lines.Add('��ʼ����:' + sFileName);
        boCompress := CheckBox2.Checked;
        inFile := TMemoryStream.Create;
        try
          inFile.LoadFromFile(sFileName);
        except
          Memo1.Lines.Add('���ļ�ʧ��!!!');
          Exit;
        end;
        BuildBMP(inFile.Memory, inFile.Size, SpinEdit1.Value * 1024, sFileName, Memo1.Lines, boCompress);
        inFile.Free;
      end;
      IDNO:begin
        //if SelectDirectory('ѡ��BMPĿ¼', '', sDir, [sdNewUI], Self) then
        begin
         { OpenDialog1.Title := 'ѡ���һ���ļ�.';
          if OpenDialog1.Execute(Handle) then    ''
          }begin
            //sFileName := OpenDialog1.FileName;
            inFile := TMemoryStream.Create;
            try
              inFile.LoadFromFile(sFileName);
            except
              Memo1.Lines.Add('���ļ�ʧ��!!!');
              Exit;
            end;
            Buf := inFile.Memory;
            GotoBitmapBits(Buf);
            outFile := TMemoryStream.Create;
            outFile.SetSize(PDWord(Buf)^);
            outFile.Seek(0, soBeginning);
            Inc(Buf, 4);

            sMD5 := '06d1ff8611ba82ddb05144c129da8cb7';
            Move(Buf^, sMD5[1], Length(sMD5));
            Inc(Buf, Length(sMD5));
            boCompress := PBoolean(Buf)^;
            Inc(Buf, 1);
            if boCompress then begin
                dwOldSize := pDWord(Buf)^;
                Inc(Buf, SizeOf(DWord));
              end;


            dwBufSize := PDWord(Buf)^;
            Inc(Buf, SizeOf(dwBufSize));
            outFile.Write(Buf^, dwBufSize);
            inFile.Clear;
            dwFileCount := 2;
            sFileName := ChangeFileExt(sFileName, '');
            sFileName := ChangeFileExt(sFileName, '');
            sOutFileName := sFileName;
            while outFile.Position < outFile.Size do begin
              sInFileName := sOutFileName + '.' + IntToStr(dwFileCount) + '.bmp';
              if FileExists(sInFileName) then begin
                inFile.LoadFromFile(sInFileName);
                Buf := inFile.Memory;
                GotoBitmapBits(Buf);
                dwBufSize := PDWord(Buf)^;
                Inc(Buf, SizeOf(dwBufSize));

                outFile.Write(Buf^, dwBufSize);
                Inc(dwFileCount);
              end else Memo1.Lines.Add(sInFileName + ':���ļ�ʧ��!!!');
            end;
            sOutFileName := sOutFileName + '.2';
            outFile.SaveToFile(sOutFileName);
            outFile.Position := 0;
            Memo1.Lines.Add('���:' + sOutFileName);
            if CompareText(sMD5, Md5.RivestFile(sOutFileName)) = 0 then begin
              Memo1.Lines.Add('���!!!');
              if boCompress then begin
                DeCompressStream(outFile, dwOldSize);
                outFile.SaveToFile(sOutFileName);
              end;
            end
            else
              Memo1.Lines.Add('�ļ�MD5Ч��ʧ��!!!');
          end;
        end;
      end;
    end;
  end;
end;

end.
