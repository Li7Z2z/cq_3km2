unit wmutil;

interface

uses
  Windows, AbstractTextures;

type

   TWMImageHeader = record
      Title: String[40];        // ���ļ����� 'WEMADE Entertainment inc.'
      ImageCount: integer;      // ͼƬ����
      ColorCount: integer;      // ɫ������
      PaletteSize: integer;     // ��ɫ���С
      VerFlag:integer;
   end;
   PTWMImageHeader = ^TWMImageHeader;

   TWMImageInfo = record
     nWidth    :SmallInt;     // λͼ���
     nHeight   :SmallInt;     // λͼ�߶�
      px: smallint;
      py: smallint;
      bits: PByte;
   end;
   PTWMImageInfo = ^TWMImageInfo;

   TWMIndexHeader = record
      Title: string[40];        //'WEMADE Entertainment inc.'
      IndexCount: integer;      // ��������
      VerFlag:integer;
   end;

   PTWMIndexHeader = ^TWMIndexHeader;

   TWMIndexInfo = record
      Position: integer;
      Size: integer;
   end;
   PTWMIndexInfo = ^TWMIndexInfo;


   TDXImage = record
     nPx          :SmallInt;
     nPy          :SmallInt;
     Surface      :TAsphyreLockableTexture;
     Alpha        :TAsphyreLockableTexture;
     dwLatestAlphaTime: LongWord;
     dwLatestTime :LongWord;
   end;
   pTDxImage = ^TDXImage;
//==============================Wis��ʽ�ṹ=====================================
  TWisHeader = packed record
    shTitle: array[0..11] of Char;//�ļ���ʶ:WISA?V���?
    shComp: {DWord}Integer;  //DWord,IntegerΪ4λ
    shOffset: {DWord}Integer ;//λ��
  end;

  TWisIndexInfo = packed record//Wis����
    nPosition: Integer;//ͼƬ��������λ��
    nSize: Integer;//ͼƬ���ݿ��С
    nUnknown: Integer;
  end;
  pTWisIndexInfo = ^TWisIndexInfo;
  TWisFileHeaderArray = array of TWisIndexInfo;
  
  TWisImageInfo = record
    nUnknown: Integer;//�Ƿ����ѹ������ 01 00 00 00,��ʾ�������00 00 00 00,δ�����
    Width: smallint;//��
    Height: smallint;//��
    px: smallint;//X
    py: smallint;//Y   
  end;
  
const
  Wis_Title = 'WISA?V���?';
function WidthBytes(w: Integer): Integer;

implementation

function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

end.
