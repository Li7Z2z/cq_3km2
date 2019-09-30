unit Aspwmutil;

interface

uses
  Windows, AbstractTextures;

const
  ZlibTitle = 'www.shandagames.com';
  
type

//-----------------------Zlib----------------------

   TWMZlibIndexHeader = record
      Title: array[0..43] of Char;  //string[44];
      IndexCount: integer;      // ��������
      //VerFlag:integer;
   end;
   PTWMZlibIndexHeader = ^TWMZlibIndexHeader;

   TWMZlibIndexInfo = record
      Position: integer;
      Size: integer;
   end;
   PTWMZlibIndexInfo = ^TWMZlibIndexInfo;

  TWMZlibImageHeader = record
      Title: array[0..43] of Char;        //'WEMADE Entertainment inc.'
      ImageCount: integer;//ͼƬ����
   end;
   PTWMZlibImageHeader = ^TWMZlibImageHeader;

   TWMZlibImageInfo = record
      wColor: Word; //��ɫ  8λ$103  16λ$105
      wUnknown: Word;//δ֪  ����λͼ�ĸ�ʽ��ʢ��ΪD3D׼��
      Width: smallint;
      Height: smallint;
      px: smallint;
      py: smallint;
      DecodeSize: Integer; //������С
   end;
   PTWMZlibImageInfo = ^TWMZlibImageInfo;

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
     LoadFailCount:DWord;
     Surface      :TAsphyreLockableTexture;
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

  TXY= array[0..65536] of Integer;
   TNewWilHeader=Packed Record
     Comp       :Smallint;
     Title      :Array[0..19] of Char;
     Ver        :Smallint;
     ImageCount :Integer;
   End;
   TNewWilImageInfo=Packed Record
     Width      :Smallint;
     Height     :Smallint;
     Px         :Smallint;
     Py         :SmallInt;
     Shadow     :Byte;
     Shadowx    :Smallint;
     Shadowy    :Smallint;
     Length     :Integer;
   End;
   TNewWixHeader=Packed Record//�µ�wix�ļ�ͷ
     Title      :Array[0..19] of char;
     ImageCount :Integer;
   End;
  
const
  Wis_Title = 'WISA?V���?';
function WidthBytes(w: Integer): Integer;

implementation

function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

end.
