unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Clipbrd, ShellAPI, StdCtrls, Spin, ZLib, MD5, jpeg;

type
  TFrmMain = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    OpenDialog1: TOpenDialog;
    CheckBox3: TCheckBox;
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
begin
  AHeight := Round(Sqrt((BufSize div 4)));
  AWidth := AHeight;
  dwDibSize := AWidth * AHeight * 4;
  //��������ͼ�һ��
  if dwDibSize < BufSize then
    Inc(AHeight);

  FileHeader := PBitmapFileHeader(Buf);
  Inc(Buf, SizeOf(TBitmapFileHeader));
  // λͼ��Ϣͷ
  InfoHeader := PBitmapInfoHeader(Buf);
  InfoHeader.biSizeImage := AWidth * AHeight * 4;


  FileHeader.bfType := $4D42;
  FileHeader.bfOffBits := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader);
  FileHeader.bfSize := FileHeader.bfOffBits + InfoHeader.biSizeImage;

  FileHeader.bfReserved1 := ord('T') or (Ord('a') shl 8);
  FileHeader.bfReserved2 := ord('s') or (Ord('.') shl 8);

  InfoHeader.biSize := SizeOf(TBitmapInfoHeader);
  InfoHeader.biWidth := AWidth;
  InfoHeader.biHeight := -AHeight;
  InfoHeader.biPlanes := 1;
  InfoHeader.biBitCount := 32;
  InfoHeader.biCompression := BI_RGB; //BI_RGB;

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
  if (FileHeader.bfType = $4D42) and (FileHeader.bfReserved1 = ord('T') or (Ord('a') shl 8)) and
     (FileHeader.bfReserved2 = ord('s') or (Ord('.') shl 8)) then begin
    FileInfoHeader := PBitmapInfoHeader(Buf + SizeOf(TBitmapFileHeader));
    Result := FileInfoHeader.biSizeImage;
    Inc(Buf, FileHeader.bfOffBits);
  end else begin
    Result := 0;
    Buf := nil;
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

function Min(A, B : DWord) : DWord;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

procedure BuildBMP(pSrc : PChar; dwSrcSize : DWord; dwBlockSize : DWord; sFileName : string; boCompress : Boolean; Log : TStrings);
var
  dwFileCount : DWord;
  dwOldSize   : DWord;
  pSrc2 : PChar;
  BlockMem  : PChar;
  BlockMemProc : PChar;
  sMD5 : string;
  FileHeader: PBitmapFileHeader;
  dwDibSize : DWord;
  procedure SaveOutBMPFile(pOutBuf : PChar; dwSize : DWord);
  var
    sOutFileName : string;
    M : TMemoryStream;
    bmp : TBitmap;
    jpg : TJPEGImage;
  begin
    Inc(dwFileCount);
    if not FrmMain.CheckBox3.Checked then
      sOutFileName := sFileName + '.' + IntToStr(dwFileCount) + '.bmp'
    else
      sOutFileName := sFileName + '.' + IntToStr(dwFileCount) + '.jpg';
    M := TMemoryStream.Create;
    M.Write(pOutBuf^, dwSize);
    M.Position := 0;
    if FrmMain.CheckBox3.Checked then begin
      jpg := TJPEGImage.Create;
      bmp := TBitmap.Create;
      bmp.LoadFromStream(M);
      jpg.ProgressiveEncoding := False;
      jpg.CompressionQuality := 100;
      jpg.Assign(bmp);
      jpg.CompressionQuality := 100;
      bmp.Free;
      //jpg.LoadFromStream(M);
      jpg.SaveToFile(sOutFileName);
      jpg.Free;
    end else M.SaveToFile(sOutFileName);
    M.Free;
    {with TFileStream.Create(sOutFileName, fmCreate) do begin
      Write(pOutBuf^, dwSize);
      Free;
    end;}
  end;
begin
  dwFileCount := 0;
  if boCompress then begin
    Log.Add('ѹ��...');
    dwOldSize := dwSrcSize;
    CompressBuf(pSrc, dwSrcSize, Pointer(pSrc), Integer(dwSrcSize));
    Log.Strings[Log.Count -1] := 'ѹ�����...';
  end;
  GetMem(BlockMem, dwBlockSize);
  if BlockMem <> nil then begin
    sMD5 := Md5.RivestBuf(pSrc, dwSrcSize);
    pSrc2 := pSrc;
    repeat
      FileHeader := PBitmapFileHeader(BlockMem);
      BlockMemProc := BlockMem;
      if dwFileCount = 0 then begin
        dwBlockSize := Min(dwSrcSize + 4, dwBlockSize);
        Inc(dwBlockSize, SizeOf(DWord));
        Inc(dwBlockSize, Length(sMD5));
        Inc(dwBlockSize);
        if boCompress then        
          Inc(dwBlockSize, SizeOf(DWord));
      end else
        dwBlockSize := Min(dwSrcSize + 4, dwBlockSize);
      dwDibSize := FillBitmapHeader(BlockMemProc, dwBlockSize);
      Dec(dwDibSize, 4);//�޸�ʵ�ʿ���д���С
      if dwFileCount = 0 then begin
        //��һ���ļ�д��ԭʼ��С
        PDWord(BlockMemProc)^ := dwSrcSize;
        Inc(BlockMemProc, SizeOf(DWord));
        Dec(dwDibSize, 4);//�޸�ʵ�ʿ���д���С
        //д��MD5
        Move(sMD5[1], BlockMemProc^, Length(sMD5));
        Inc(BlockMemProc, Length(sMD5));
        Dec(dwDibSize, Length(sMD5));//�޸Ŀ���д��Ĵ�С

        PBoolean(BlockMemProc)^ := boCompress;
        Inc(BlockMemProc, 1);
        Dec(dwDibSize);//�޸Ŀ���д��Ĵ�С
        if boCompress then begin
          pDWord(BlockMemProc)^ := dwOldSize;
          Inc(BlockMemProc, SizeOf(DWord));
          Dec(dwDibSize, SizeOf(DWord));//�޸Ŀ���д��Ĵ�С
        end;
      end;


      dwDibSize := Min(dwDibSize, dwSrcSize);
      Dec(dwSrcSize, dwDibSize);
      if dwDibSize <= 0 then Break;
      //BMP��Dibs��ʼ��Ϊ�ļ����ݴ�С
      PDWord(BlockMemProc)^ := dwDibSize;
      Inc(BlockMemProc, SizeOf(DWord));

      //���ļ��������ݵ�BMP��Dibs
      Move(pSrc2^, BlockMemProc^, dwDibSize);
      Inc(pSrc2, dwDibSize);

      //д��BMP ���ݵ��ļ�
      SaveOutBMPFile(PChar(FileHeader), FileHeader.bfSize);
    until dwSrcSize <= 0;
    //FreeMem(BufMem);
    Log.Add('���!');
    Log.Add('�ļ����� : ' + IntToStr(dwFileCount));
    Log.Add('--------�������--------');
    //Log.Add(sMD5);
    //FreeMem(pSrc);
    FreeMem(BlockMem);
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
  inFile, OutFile : TMemoryStream;
  Buf : PChar;
  dwBufSize : DWord;
  dwFileCount : DWord;
  boCompress : Boolean;
  dwOldSize : DWord;//ѹ����
  bmp : TBitmap;
  jpg : TJPEGImage;
begin
  Memo1.Clear;
  {GetClassName(Msg.Drop, @NameBuf, SizeOf(NameBuf));
  ShowMessage(NameBuf); }
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
        Memo1.Lines.Add('��ʼ����:' + sFileName);
        boCompress := CheckBox2.Checked;
        inFile := TMemoryStream.Create;
        try
          inFile.LoadFromFile(sFileName);
        except
          Memo1.Lines.Add('���ļ�ʧ��!!!');
          Exit;
        end;
        BuildBMP(inFile.Memory, inFile.Size, SpinEdit1.Value * 1024, sFileName, boCompress, Memo1.Lines);
        //inFile.Free;
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
            if (PLongword(Buf)^ = $E0FFD8FF) or (PInt64(Buf)^ = $2020506A0C000000) then begin
              inFile.Position := 0;
              jpg := TJPEGImage.Create;
              jpg.LoadFromStream(inFile);
              bmp := TBitmap.Create;
              bmp.Width := jpg.Width;
              bmp.Height := jpg.Height;
              bmp.PixelFormat := pf32bit;
              bmp.Canvas.Draw(0,0,jpg);
              //bmp.Assign(jpg);
              inFile.Clear;
              bmp.SaveToStream(inFile);
              //bmp.SaveToFile('D:\Working\3K2012\1.bmp');
              bmp.Free;
              Buf := inFile.Memory;
              with PBitmapFileHeader(Buf)^ do begin
                bfReserved1 := ord('T') or (Ord('a') shl 8);
                bfReserved2 := ord('s') or (Ord('.') shl 8);
              end;
              Exit;//ֱ���˳� jpg �������....
            end;
            GotoBitmapBits(Buf);
            if Buf <> nil then begin
              outFile := TMemoryStream.Create;
              dwBufSize := PDWord(Buf)^;
              outFile.SetSize(dwBufSize);
              outFile.Seek(0, soBeginning);
              Inc(Buf, 4);

              sMD5 := 'TasNatUpDataWriteAt201204042009.';
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
                  if (Buf <> nil) then begin
                    dwBufSize := PDWord(Buf)^;
                    Inc(Buf, SizeOf(dwBufSize));
                    outFile.Write(Buf^, dwBufSize);
                  end else Memo1.Lines.Add(sInFileName + ':�ļ���ʽЧ��ʧ��!!!');
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
            end else Memo1.Lines.Add('�ļ���ʽЧ��ʧ��!!!');
          end;
        end;
      end;
    end;
  end;
end;

end.
