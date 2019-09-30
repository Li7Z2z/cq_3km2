unit uFileUnit;
//�ļ����ӽ���
interface
uses SysUtils, Classes;
type TGXEDecEncOp = (opDecrypt, opEncrypt);
type TDiyDecEncAlg = (algBlowFish, algCast128, algGost, algIdea, algMisty1, algRC2, algRijnDael, algTwoFish);
type TSHA_HashDigest = string[40];
const DiyAlgNames: array[algBlowFish..algTwoFish] of string = ('Blowfish', 'Cast 128', 'Gost', 'Idea', 'Misty1', 'RC2', 'RijnDael', 'TwoFish');
const
TGXEDecEncAlgHashes: array[TDiyDecEncAlg] of TSHA_HashDigest =
   ('WDGVXDF5668KGHFG8CVBDF9834DXFYHCDHKNFRKI',//'C1C02118909B9BCF57C4CFB773720423EA0ABBBA',
    'EDJKBF46IU9HD4657678GDFBD24556DFS3574R5F',//'15285659087E77B3313C9119878E873B9D3AA27D',
    'GHJF56685DFGFGHYFG24345DBDXDFHERI8978ERK',//'0F068CDD5E5C651D1470C095772CDE0BC7B7271D',
    'XBVHGKUO964DFHGKU776QWE45GJJLPI78531GHJK',//'2853D1F1C7FBE524C961103EBC77CF9C8181A34C',
    'CVDCGM675876NKHGGJIJGTJHVR24DHJI09JUHGRF',//'D30EE03CAC992A211C7DFC8D25C4BA5C6AD9F1D9',
    '098U7HFCJYUIHTRDGWER4FJYI9FGFDG12DFE54GU',//'2B69EA076BD364D53AD2617C3A0BF3387013220C',
    '12DRVNFGGHJ6573534JFGJJKVRT78802GDFGMKFD',//'34380E57F8FBFCACBF6A15EC302EE1A148AD5296',
    '90NHRFDSEHY56901WE5G7JLOJ8HVFDGGFJ67867D');//'3A70C13A7977E75260E88E3E85C851F56FA5052D'
function EncryptFile(SourceFile_PathFileName, Dest_FilePath, EncFileExtention, The_PW: string;
  The_Alg: TDiyDecEncAlg): boolean;
function DecryptFile(SourceFile_PathFileName, Dest_FilePath, The_PW: string): boolean;

//������       
function EncDecToStream(var Source: TMemoryStream; The_Alg: TDiyDecEncAlg; The_PW: string): boolean;
function DecryptToStream(var SourceStream: TMemoryStream; The_PW: string): boolean;

function ExtractFilePathA(const FileName: string): string;
implementation
uses
   SHA1, DCPcrypt, Blowfish, Cast128, Gost, IDEA, Misty1, RC2, Rijndael, Twofish;
   
function ExtractFilePathA(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function Create_Comp(The_Alg: TDiyDecEncAlg): TDCP_BlockCipher;
begin
  result := nil;
  try
    case The_Alg of
      algBlowFish: result := TDCP_BlowFish.Create(nil);
      algCast128: result := TDCP_Cast128.Create(nil);
      algGost: result := TDCP_Gost.Create(nil);
      algIdea: result := TDCP_Idea.Create(nil);
      algMisty1: result := TDCP_Misty1.Create(nil);
      algRC2: result := TDCP_RC2.Create(nil);
      algRijnDael: result := TDCP_RijnDael.Create(nil);
      algTwoFish: result := TDCP_TwoFish.Create(nil);
    end;
  except
    on E: Exception do
      Exception.Create(E.Message);
  end;
end;

function EncDec_File(SourcePathFileName, DestPathFileName: string;
  Operation: TGXEDecEncOp; The_Alg: TDiyDecEncAlg; The_PW: string): boolean;
var
  c: SmallInt;
  EncUsed: TSHA_HashDigest;
  Source, Dest: TMemoryStream;
  BufferFName: array[0..500] of char;
  Buffer: array[0..8191] of byte;
  Hash: TDCP_SHA1;
  HashDigest, HashRead: array[0..31] of byte;
  EncDecComp: TDCP_BlockCipher;
  Read: integer;
begin
  result := FALSE;
  try
    EncDecComp := Create_Comp(The_Alg);//��Ҫ������Դ
    try
      Source:= TMemoryStream.Create;
      Dest:= TMemoryStream.Create;
      Source.LoadFromFile(SourcePathFileName);

      FillChar(HashDigest, Sizeof(HashDigest), $FF); //�����������ϣ
      Hash := TDCP_SHA1.Create(nil);
      try
        Hash.Init;
        Hash.UpdateStr(The_PW);
        Hash.Final(HashDigest);
      finally
        Hash.Burn;
        Hash.Free;
      end;

      //��ʼ����Կ
      if (Sizeof(HashDigest) * 8) > EncDecComp.MaxKeySize then//ȷ����Կ����̫��
        EncDecComp.Init(HashDigest, EncDecComp.MaxKeySize, nil)
      else EncDecComp.Init(HashDigest, Sizeof(HashDigest) * 8, nil);//ʹ�ù�ϣ��Կ
      
      //���ܹ�ϣ��ʹ���ǿ��԰���д���ļ����������Ҫ����
      EncDecComp.EncryptCBC(HashDigest, HashDigest, Sizeof(HashDigest));
      EncDecComp.Reset;

      case Operation of
        opEncrypt: begin
            //дһ���㷨�Ĺ�ϣ�����ļ�
            Dest.WriteBuffer(TGXEDecEncAlgHashes[The_Alg], Sizeof(TSHA_HashDigest));
            Dest.WriteBuffer(HashDigest, Sizeof(HashDigest));
            //�����ļ�����д�뵽�ļ�
            FillChar(BufferFName, SizeOf(BufferFName), 0);
            for c := 1 to Length(ExtractFileName(SourcePathFileName)) do
              BufferFName[c - 1] := ExtractFileName(SourcePathFileName)[c];
            EncDecComp.EncryptCBC(BufferFName, BufferFName, SizeOf(BufferFName));
            Dest.WriteBuffer(BufferFName, SizeOf(BufferFName));
            repeat
              Read:= Source.Read(Buffer, Sizeof(Buffer));
              EncDecComp.EncryptCBC(Buffer, Buffer, Read);
              Dest.WriteBuffer(Buffer, Read);
            until Read <> Sizeof(Buffer);
            Dest.SaveToFile(DestPathFileName);
          end;
        opDecrypt: begin
                //�ո��Ƶ�ָ��ʹ�õļ���ɢ���ļ�ָ��
            Source.ReadBuffer(EncUsed, Sizeof(TSHA_HashDigest));
                //���ļ��ж�ȡ����Ĺ�ϣ
            Source.ReadBuffer(HashRead, Sizeof(HashRead));
            if not CompareMem(@HashRead, @HashDigest, Sizeof(HashRead)) then Exception.Create('Incorrect password.');
                //�Ķ��ļ���
            FillChar(BufferFName, SizeOf(BufferFName), 0);
            Source.ReadBuffer(BufferFName, Sizeof(BufferFName));
            EncDecComp.DecryptCBC(BufferFName, BufferFName, Sizeof(BufferFName));
              //��ȡԴ�ļ��ͽ���
            repeat
              Read:= Source.Read(Buffer, Sizeof(Buffer));
              EncDecComp.DecryptCBC(Buffer, Buffer, Read);
              Dest.WriteBuffer(Buffer, Read);
            until Read <> Sizeof(Buffer);
          end;
      end;                                                                
    finally
      //�ͷ���Դ
      EncDecComp.Burn;
      EncDecComp.Free;
      //�ر��ļ����������ļ�������б�Ҫ
      if Operation = opEncrypt then begin
        Source.Free;
        Dest.Free;
      end else begin
        if FileExists(ExtractFilePath(DestPathFileName) + BufferFName) then begin
          DeleteFile(ExtractFilePath(DestPathFileName) + BufferFName);
        end;;
        Dest.SaveToFile(ExtractFilePath(DestPathFileName) + BufferFName);
        Source.Free;
        Dest.Free;
      end;
    end;
    result := TRUE;
  except
    on E: Exception do
      Exception.Create(E.Message);
  end;
end;

//��Կ��֧���������
function EncryptFile(SourceFile_PathFileName, Dest_FilePath, EncFileExtention, The_PW: string;
  The_Alg: TDiyDecEncAlg): boolean;
var
  EncFileName: string;
begin
  result := FALSE;
  try
    EncFileName := ExtractFileName(SourceFile_PathFileName);
    Delete(EncFileName, Pos('.', EncFileName) + 1, Length(EncFileName) - Pos('.', EncFileName));
    EncFileName := EncFileName + EncFileExtention;
    result := EncDec_File(SourceFile_PathFileName, ExtractFilePath(SourceFile_PathFileName) + EncFileName, opEncrypt, The_Alg, The_PW)
  except
    on E: Exception do
      Exception.Create(E.Message);
  end;
end;
//�ļ�����  ��Կ��֧�������ַ�
function DecryptFile(SourceFile_PathFileName, Dest_FilePath, The_PW: string): boolean;
var
  AlgFound: boolean;
  CurrAlg: TDiyDecEncAlg;
  EncUsed: TSHA_HashDigest;
  Source: TMemoryStream;
  The_Alg: TDiyDecEncAlg;
begin
  result := FALSE;
  try
    try
      Source:= TMemoryStream.Create;
      Source.LoadFromFile(SourceFile_PathFileName);
      Source.ReadBuffer(EncUsed, Sizeof(TSHA_HashDigest));
    finally
      Source.Free;
    end;
    AlgFound := FALSE;
    for CurrAlg := Low(TDiyDecEncAlg) to High(TDiyDecEncAlg) do begin
      The_Alg := CurrAlg;
      if EncUsed = TGXEDecEncAlgHashes[CurrAlg] then begin
        AlgFound := TRUE;
        Break;
      end;
    end;
    if not AlgFound then Exception.Create('����ļ����Ǽ����ļ�.');
    result := EncDec_File(SourceFile_PathFileName, Dest_FilePath, opDecrypt, The_Alg, The_PW);
  except
    on E: Exception do Exception.Create(E.Message);
  end;
end;
//������       
function EncDecToStream(var Source: TMemoryStream; The_Alg: TDiyDecEncAlg; The_PW: string): boolean;
var
  c: SmallInt;
  EncUsed: TSHA_HashDigest;
  Dest: TMemoryStream;
  BufferFName: array[0..500] of char;
  Buffer: array[0..8191] of byte;
  Hash: TDCP_SHA1;
  HashDigest, HashRead: array[0..31] of byte;
  EncDecComp: TDCP_BlockCipher;
  Read: integer;
  SourcePathFileName: string;
begin
  result := FALSE;
  try
    EncDecComp := Create_Comp(The_Alg);//��Ҫ������Դ
    try
      Dest:= TMemoryStream.Create;

      FillChar(HashDigest, Sizeof(HashDigest), $FF); //�����������ϣ
      Hash := TDCP_SHA1.Create(nil);
      try
        Hash.Init;
        Hash.UpdateStr(The_PW);
        Hash.Final(HashDigest);
      finally
        Hash.Burn;
        Hash.Free;
      end;

      //��ʼ����Կ
      if (Sizeof(HashDigest) * 8) > EncDecComp.MaxKeySize then//ȷ����Կ����̫��
        EncDecComp.Init(HashDigest, EncDecComp.MaxKeySize, nil)
      else EncDecComp.Init(HashDigest, Sizeof(HashDigest) * 8, nil);//ʹ�ù�ϣ��Կ
      
      //���ܹ�ϣ��ʹ���ǿ��԰���д���ļ����������Ҫ����
      EncDecComp.EncryptCBC(HashDigest, HashDigest, Sizeof(HashDigest));
      EncDecComp.Reset;

      //дһ���㷨�Ĺ�ϣ�����ļ�
      Dest.WriteBuffer(TGXEDecEncAlgHashes[The_Alg], Sizeof(TSHA_HashDigest));
      Dest.WriteBuffer(HashDigest, Sizeof(HashDigest));
      //�����ļ�����д�뵽�ļ�
      FillChar(BufferFName, SizeOf(BufferFName), 0);
      SourcePathFileName:='3Km2VIPLogin';
      for c := 1 to Length(SourcePathFileName) do BufferFName[c - 1] := SourcePathFileName[c];
      //for c := 1 to Length(ExtractFileName(SourcePathFileName)) do
      //  BufferFName[c - 1] := ExtractFileName(SourcePathFileName)[c];
      EncDecComp.EncryptCBC(BufferFName, BufferFName, SizeOf(BufferFName));
      Dest.WriteBuffer(BufferFName, SizeOf(BufferFName));
      repeat
        Read:= Source.Read(Buffer, Sizeof(Buffer));
        EncDecComp.EncryptCBC(Buffer, Buffer, Read);
        Dest.WriteBuffer(Buffer, Read);
      until Read <> Sizeof(Buffer);
      Source.Clear;
      Source.CopyFrom(Dest, 0);
      Source.Position := 0; //��λ��ָ��
    finally
      //�ͷ���Դ
      EncDecComp.Burn;
      EncDecComp.Free;
      Dest.Free;
    end;
    result := TRUE;
  except
    on E: Exception do
      Exception.Create(E.Message);
  end;
end;

//��ѹ��
function DecryptToStream(var SourceStream: TMemoryStream; The_PW: string): boolean;
  function Dec_ToStream(var Source: TMemoryStream; The_Alg: TDiyDecEncAlg; The_PW: string): boolean;
  var
    //c: SmallInt;
    EncUsed: TSHA_HashDigest;
    Dest: TMemoryStream;
    BufferFName: array[0..500] of char;
    Buffer: array[0..8191] of byte;
    Hash: TDCP_SHA1;
    HashDigest, HashRead: array[0..31] of byte;
    EncDecComp: TDCP_BlockCipher;
    Read: integer;
  begin
    Result := FALSE;
    try
      EncDecComp := Create_Comp(The_Alg);//��Ҫ������Դ
      try
        Source.Position := 0; //��λ��ָ��
        Dest:= TMemoryStream.Create;
        FillChar(HashDigest, Sizeof(HashDigest), $FF); //�����������ϣ
        Hash := TDCP_SHA1.Create(nil);
        try
          Hash.Init;
          Hash.UpdateStr(The_PW);
          Hash.Final(HashDigest);
        finally
          Hash.Burn;
          Hash.Free;
        end;

        //��ʼ����Կ
        if (Sizeof(HashDigest) * 8) > EncDecComp.MaxKeySize then//ȷ����Կ����̫��
          EncDecComp.Init(HashDigest, EncDecComp.MaxKeySize, nil)
        else EncDecComp.Init(HashDigest, Sizeof(HashDigest) * 8, nil);//ʹ�ù�ϣ��Կ

        //���ܹ�ϣ��ʹ���ǿ��԰���д���ļ����������Ҫ����
        EncDecComp.EncryptCBC(HashDigest, HashDigest, Sizeof(HashDigest));
        EncDecComp.Reset;

        //�ո��Ƶ�ָ��ʹ�õļ���ɢ���ļ�ָ��
        Source.ReadBuffer(EncUsed, Sizeof(TSHA_HashDigest));
        //���ļ��ж�ȡ����Ĺ�ϣ
        Source.ReadBuffer(HashRead, Sizeof(HashRead));
        if not CompareMem(@HashRead, @HashDigest, Sizeof(HashRead)) then Exception.Create('Incorrect password.');
            //�Ķ��ļ���
        FillChar(BufferFName, SizeOf(BufferFName), 0);
        Source.ReadBuffer(BufferFName, Sizeof(BufferFName));
        EncDecComp.DecryptCBC(BufferFName, BufferFName, Sizeof(BufferFName));
        //��ȡԴ�ļ��ͽ���
        repeat
          Read:= Source.Read(Buffer, Sizeof(Buffer));
          EncDecComp.DecryptCBC(Buffer, Buffer, Read);
          Dest.WriteBuffer(Buffer, Read);
        until Read <> Sizeof(Buffer);
        Source.Clear;
        Source.CopyFrom(Dest, 0);
        Source.Position := 0; //��λ��ָ��
      finally
        EncDecComp.Burn;
        EncDecComp.Free;
        Dest.Free;
      end;
      Result := TRUE;
    except
      on E: Exception do Exception.Create(E.Message);
    end;
  end;
var
  AlgFound: boolean;
  CurrAlg: TDiyDecEncAlg;
  EncUsed: TSHA_HashDigest;
  The_Alg: TDiyDecEncAlg;
begin
  Result := FALSE;
  try
    SourceStream.Position := 0; //��λ��ָ��
    SourceStream.ReadBuffer(EncUsed, Sizeof(TSHA_HashDigest));
    AlgFound := FALSE;
    for CurrAlg := Low(TDiyDecEncAlg) to High(TDiyDecEncAlg) do begin
      The_Alg := CurrAlg;
      if EncUsed = TGXEDecEncAlgHashes[CurrAlg] then begin
        AlgFound := TRUE;
        Break;
      end;
    end;
    if not AlgFound then begin
      Exception.Create('����ļ����Ǽ�����.');
      Exit;
    end;
    Result := Dec_ToStream(SourceStream, The_Alg, The_PW);
  except
    on E: Exception do Exception.Create(E.Message);
  end;
end;
end.
