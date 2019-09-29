{------------------------------------------------------------------------------}
{ ��Ԫ����: Magiceff.pas                                                       }
{                                                                              }
{ ��������: 2007-10-28 20:30:00                                                }
{                                                                              }
{ ���ܽ���:                                                                    }
{   ����2 �ͻ���ħ��Ч���Ļ��������,��ȻҲ������ħ���˺�ʵ��                  }
{                                                                              }
{ ʹ��˵��:                                                                    }
{                                                                              }
{                                                                              }
{                                                                              }
{ ������ʷ:                                                                    }
{                                                                              }
{ �д�����:                                                                    }
{                                                                              }
{                                                                              }
{------------------------------------------------------------------------------}
unit magiceff;

interface

uses
  Windows, Grobal2, AbstractCanvas, AbstractTextures, AsphyreTextureFonts, ClFunc, HUtil32, AspWIl, SysUtils;

const
   FLYBASE = 10;
   EXPLOSIONBASE = 170;
   FLYOMAAXEBASE = 447;
   THORNBASE = 2967;
   ARCHERBASE = 2607;
   ARCHERBASE2 = 272; //2609;
   FIREGUNFRAME = 6;

  MAXEFFECT = 205;//���Ч��ħ��Ч��ͼ�� 20071028  update

  //0..1  0Ϊ���� 1Ϊǿ��
  EffectBase: array[0..MAXEFFECT-1, 0..1] of integer = (
    (0,   0),{1}       //������
    (200, 0),{2}    //������
    (400, 0),{3}    //�����
    (600, 0),{4}    //ʩ����
    (0,   0),{5}      //��ɱ����
    (900, 0),{6}    //���ܻ�
    (920, 0),{7}    //������
    (940, 1260),{8}    //�����Ӱ
    (20,  120),{9}     //�׵���
    (940, 500),{10}   //�����
    (940, 500),{11}   //�����
    (940, 500),{12}   //��ʥս����
    (0,   0),{13}     //��ɱ����
    (1380,0),{14}  //��ħ��
    (1500,860),{15}  //�ٻ�����
    (1520,0),{16}  //������
    (940, 0),{17}   //����������
    (1560,0),{18}  //�ջ�֮��
    (1590,0),{19}  //˲Ϣ�ƶ�
    (1620,0),{20}  //��ǽ
    (1650,260),{21}  //���ѻ���
    (1680,0),{22}  //�����׹�
    (0,   0),{23}     //�����䵶
    (0,   0),{24}     //�һ𽣷�
    (0,   0),{25}     //Ұ����ײ
    (3960,0),{26}  //������ʾ
    (1790,0),{27}  //Ⱥ��������
    (0,   0),{28}     //�ٻ�����
    (3880,0),{29}  //ħ����
    (3920,0),{30}  //ʥ����
    (3840,0),{31}  //������
    (0,   0),{32}     //
    (40,  0),{33}    //
    (130, 280),{34}  //�����
    (160, 0),{35}   //�޼�����
    (190, 0),{36}   //������
    (0,   0),{37}     //
    (210, 0),{38}   //
    (400, 0),{39}   //������
    (600, 0),{40}   //������
    (1500,0),{41} //�ٻ�����
    (0,   0),{42} //������ 20080415
    (710, 0),{43}  // ʨ�Ӻ�
    (740, 0),{44}  //
    (910, 0),{45}  //
    (940, 0),{46}  //Ⱥ��ʩ����
    (990, 0),{47}  //쫷���
    (1040,630),{48} //��Ѫ��
    (1110,0),{49} //������
    (0,   0),{50}   //����Ԫ��
    (630, 430),{51} //���ǻ��� 20080510
    (710, 0),{52}  //�ļ�ħ����
    (0,   0),{53}  //���ս���
    (0,   0),{54}  //4����ɱ
    (1379,0),{55}  //����ٵ�
    (0,   0),{56}  //Բ���䵶
    (0,   0),{57}
    (0,   0),{58}
    (0,   0),{59}
    (10,  0),{60}    //�ƻ�ն
    (440, 0),{61}  //����ն
    (270, 0),{62}  //����һ��
    (610, 0),{63}  //�ɻ�����
    (210, 0),{64}  //ĩ������
    (540, 0),{65}   //��������
    (690, 0),{66}
    (0,   0),{67}
    (0,   0),{68}
    (0,   0),{69}
    (0,   0),{70}
    (0,   0),{71}
    (0,   0),{72}
    (0,   0),{73}
    (1130,630),{74}   //4����Ѫ��(
    (0, 120),{75}  //4���׵���
    (0,   160),{76}  //�ٻ�ʥ��
    (50,  440),{77} //4��ʩ�����̶�
    (90,  650),{78} //4��ʩ�����춾
    (0,   0),{79}
    (240, 430),{80}  //4�����ǻ���
    (0,   0),{81}   //Ѫ��һ��(ս)
    (2040,0),{82}   //Ѫ��һ��(��)
    (2180,0),{83}   //Ѫ��һ��(��)
    (0,   0),{84}
    (0,   0),{85}
    (0,   0),{86}
    (0,   0),{87}
    (0,   0),{88}
    (0,   0),{89}
    (0,   0),{90}
    (790, 0),{91} //�������
    (0,   0),{92}
    (0,   0),{93}
    (0,   0),{94}
    (0,   0),{95}
    (0,   0),{96}//810,{96}  //��������
    (840, 0),{97} //Ψ�Ҷ���
    (0,   0),{98} //�ٻ���ħ
    (1010,0),{99}
    (120, 500),{100} //4������� 20080111
    (80,  280),{101}  //4������� 20080111
    (0,   0),{102}
    (1040,0),{103}  //˫����
    (1200,0),{104}  //��Х��
    (0,   0),{105}
    (640, 0),{106} //�����
    (1440,0),{107} //������
    (0,   0),{108}
    (4210,0),{109}
    (1600,0),{110} //������
    (0,   0),{111}
    (800, 0),{112}
    (1760,0),{113} //�򽣹���
    (1265,0),{114} //��ɫ������
    (1065,630),{115} //��ɫ��Ѫ��
    (1115,630),{116} //��ɫ�ļ���Ѫ��
    (1175,0),{117} //��ɫ�޼�����
    (1195,500),{118} //��ɫ��ʥս����
    (1225,500),{119} //��ɫ�����
    (1455,0),{120} //��ɫ�����
    (1645,260),{121} //��ɫ���ѻ���
    (1755,280),{122} //��ɫ�����
    (1755,280),{123} //��ɫ�ļ������
    (1805,0),{124} //��ɫ�ļ������
    (1825,0),{125} //��ɫħ����
    (1865,430),{126} //��ɫ���ǻ���
    (1925,430),{127} //��ɫ�ļ����ǻ���
    (1685,0),{128} //��ɫ��ǽ
    (100, 0),{129} //�ķ�
    (360, 0),{130} //��˪ѩ��
    (0,   0),{131} //�ݺὣ��
    (540, 0),{132} //�����
    (0,   0),{133} //����֮��
    (60,  0),{134} //��˪Ⱥ��
    (1030,0),{135} //ŭ�ɻ���
    (960, 0),{136} //��������
    (200, 0),{137} //ʮ��һɱ
    (0,   0),{138}
    (0,   0),{139}
    (0,   0),{140}
    (0,   0),{141}
    (0,   0),{142}
    (0,   0),{143}
    (0,   0),{144}
    (0,   0),{145}
    (0,   0),{146}
    (0,   0),{147}
    (0,   0),{148}
    (0,   0),{149}
    (0,   0),{150}
    (0,   0),{151}
    (0,   0),{152}
    (0,   0),{153}
    (0,   0),{154}
    (0,   0),{155}
    (0,   0),{156}
    (0,   0),{157}
    (0,   0),{158}
    (0,   0),{159}
    (0,   0),{160}
    (0,   0),{161}
    (0,   0),{162}
    (0,   0),{163}
    (0,   0),{164}
    (0,   0),{165}
    (0,   0),{166}
    (0,   0),{167}
    (0,   0),{168}
    (0,   0),{169}
    (0,   0),{170}
    (0,   0),{171}
    (0,   0),{172}
    (0,   0),{173}
    (0,   0),{174}
    (0,   0),{175}
    (0,   0),{176}
    (0,   0),{177}
    (0,   0),{178}
    (0,   0),{179}
    (0,   0),{180}
    (0,   0),{181}
    (0,   0),{182}
    (0,   0),{183}
    (0,   0),{184}
    (0,   0),{185}
    (0,   0),{186}
    (0,   0),{187}
    (0,   0),{188}
    (0,   0),{189}
    (0,   0),{190}
    (0,   0),{191}
    (0,   0),{192}
    (0,   0),{193}
    (0,   0),{194}
    (0,   0),{195}
    (0,   0),{196}
    (0,   0),{197}
    (1580,0),{198}
    (100, 0),{199} //������ͨ����
    (280, 0),{200} //�����ػ�
    (0,   0),{201}
    (0,   0),{202}
    (0,   0),{203}
    (0,   0),{204}
    (1500,0){205} //�ٻ�����
    );


  MAXHITEFFECT = 35;//���Ч������Ч��ͼ�� 20080212  update
  //ʵ�幥��    ���� ��ʿ�������һ𣬰���
  HitEffectBase: array[0..MAXHITEFFECT-1] of integer = (
    800,{1} //��ɱ
    1410,{2} //��ɱ
    1700,{3} //����
    3480,{4} //�һ�
    3390,{5} //
    40,  {6} //����
    470, {220} {7} //����ն�ػ�
    740, {8} //
    0,   {9} //4���һ� 20080112
    630, {10} //����ն��� 2008.02.12
    510, {11} //���ս��� 20080511
    310, {12} //����һ�� սʿЧ��
    80,  {13}  //׷�Ĵ�
    560, {14}//��ɨǧ��
    160, {15} //����ɱ
    320, {16} //����ն
    140, {17}  //4����ɱ
    310, {18} //Բ���䵶
    2380,{19} //Ѫ��һ��(ս)
    820, {20} //��ɫ��ɱ����
    910, {21} //��ɫ�һ𽣷�
    975, {22} //��ɫ���ս���
    0,   {23} //���ս���1..3��
    90,  {24} //���ս���4..6��
    1660,{25} //�һ�1..3��
    1750,{26} //�һ�4..6��
    1870,{27} //Բ��1..3��
    1960,{28} //Բ��4..6��
    2050,{29} //Բ��7..9��
    1600,{30} //��ɱ1..3��
    1690,{31} //��ɱ4..6��
    1780,{32} //��ɱ7..9��
    2140,{33} //��ɱ1..3��
    2230,{34} //��ɱ4..6��
    2320{35} //��ɱ5..9��
    );
   MAXMAGICTYPE = 16;

type         
   TMagicType = (mtReady,{׼��}     mtFly,{��}        mtExplosion{����},
  {ħ������}     mtFlyAxe{�ɸ�},    mtFireWind{���}, mtFireGun{����},
                 mtLightingThunder{������}, mtThunder{��1}, mtExploBujauk,
                 mtBujaukGroundEffect, mtKyulKai,     mtFlyArrow,
                 mt12,              mt13{����ħ��},             mt14,
                 mt15,              mt16,        mtRedThunder{��ɫ�׵�}, mtLava{�ҽ�}
                 );

   TUseMagicInfo = record
      ServerMagicCode: integer;
      MagicSerial: integer;
      Target: integer; //recogcode
      EffectType: TMagicType;
      EffectNumber: integer;
      EffectLevelEx: Byte; //ħ������
      TargX: integer;
      TargY: integer;
      Recusion: Boolean;
      AniTime: integer;
   end;
   PTUseMagicInfo = ^TUseMagicInfo;

   TMagicEff = class//Size 0xC8
      m_boActive: Boolean;           //0x04 ���
      ServerMagicId: integer;    //0x08
      MagOwner: TObject;         //0x0C
      TargetActor: TObject;      //0x10 Ŀ��
      ImgLib: TAspWMImages;         //0x14
      EffectBase: integer;       //0x18
      MagExplosionBase: integer; //0x1C
      px, py: integer;           //0x20 0x24
      RX, RY: integer;           //0x28 0x2C
      Dir16, OldDir16: byte;        //0x30  0x31
      TargetX, TargetY: integer;    //0x34 0x38
      TargetRx, TargetRy: integer;  //0x3C 0x40
      FlyX, FlyY, OldFlyX, OldFlyY: integer; //0x44 0x48 0x4C 0x50
      FlyXf, FlyYf: Real;        //0x54 0x5C
      Repetition: Boolean;       //0x64 //�ظ�
      FixedEffect: Boolean;      //0x65//�̶����
      MagicType: integer;        //0x68
      NextEffect: TMagicEff;     //0x6C
      ExplosionFrame: integer;   //0x70
      NextFrameTime: integer;    //0x74
      Light: integer;            //0x78
      n7C:Integer;
      bt80:Byte;
      bt81:Byte;
      start: integer;        //0x84 //��ʼ�
      curframe: integer;     //0x88
      frame: integer;        //0x8C //��Ч֡
   private

      m_dwFrameTime: longword;   //0x90
      m_dwStartTime: longword;  //0x94
      repeattime: longword;  //0x98 �ݺ� �ִϸ��̼� �ð� (-1: ���)
      steptime: longword;    //0x9C
      fireX, fireY: integer; //0xA0 0xA4
      firedisX, firedisY: integer;   //0xA8 0xAC
      newfiredisX, newfiredisY: integer;//0xB0 0xB4
      FireMyselfX, FireMyselfY: integer;//0xB8 0xBC
      prevdisx, prevdisy: integer; //0xC0 0xC4
   protected
      procedure GetFlyXY (ms: integer; var fx, fy: integer);
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      destructor Destroy; override;
      function  Run: Boolean; dynamic; //false:������.
      function  Shift: Boolean; dynamic;
      procedure DrawEff (surface: TAsphyreCanvas); dynamic;
   end;
   TMagicEffDir8 = class (TMagicEff)  //8�������ħ��
   private
     dir: Byte;
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer; btDir: Byte);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TFlyingAxe = class (TMagicEff)
      FlyImageBase: integer;
      ReadyFrame: integer;
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TFlyingBug = class (TMagicEff)//Size 0xD0
      FlyImageBase: integer;//0xC8
      ReadyFrame: integer;//0xCC
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TFlyingArrow = class (TFlyingAxe)
   public
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;
   TFlyingFireBall = class (TFlyingAxe) //0xD0
   public
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;
   TCharEffect = class (TMagicEff)
   public
      constructor Create (effbase, effframe: integer; target: TObject);
      function  Run: Boolean; override; //false:������.
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TMapEffect = class (TMagicEff)
   public
      RepeatCount: integer;
      boC8:Boolean;
      constructor Create (effbase, effframe: integer; x, y: integer);
      function  Run: Boolean; override; //false:������.
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TScrollHideEffect = class (TMapEffect)
   public
      constructor Create (effbase, effframe: integer; x, y: integer; target: TObject);
      function  Run: Boolean; override;
   end;

   TLightingEffect = class (TMagicEff)
   public
      constructor Create (effbase, effframe: integer; x, y: integer);
      function  Run: Boolean; override;
   end;

   TFireNode = record
      x: integer;
      y: integer;
      firenumber: Integer;
   end;

   TFireGunEffect = class (TMagicEff)
   public
      OutofOil: Boolean;
      firetime: longword;
      FireNodes: array[0..FIREGUNFRAME-1] of TFireNode;
      constructor Create (effbase, sx, sy, tx, ty: integer);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

{******************************************************************************}
//������
   TfenshenThunder = class (TMagicEff)
   private
      Rx,Ry,dir:Integer;
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; aowner: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;
{******************************************************************************}


   TThuderEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TLightingThunder = class (TMagicEff)
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TPHHitEffect = class (TMagicEff) //�ƻ�ն��  20080226
   private
    Rx, Ry: Integer;
   public
      constructor Create (effbase, sx, sy, tx, ty:Integer; aowner: TObject);
      procedure DrawEff (surface: TAsphyreCanvas);override;
   end;

   TExploBujaukEffect = class (TMagicEff)
   private
     m_boAddEffect: Boolean;
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject; AddEffect: Boolean);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TSYZBujaukEffect = class (TMagicEff)  //������
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;
   THXJBujaukEffect = class (TMagicEff)  //��Х��
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;
   
   //��ţħ��
   TJNExploBujaukEffect = class (TMagicEff)
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TBujaukGroundEffect = class (TMagicEff)//Size  0xD0
   public
      MagicNumber: integer;       //0xC8
      EffectLevelEx: Byte;
      BoGroundEffect: Boolean;    //0xCC
      m_boAddEffect: Boolean;
      constructor Create (effbase, magicnumb, sx, sy, tx, ty: integer; effLevelEx: Byte; AddEffect: Boolean);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TNormalDrawEffect = class (TMagicEff)//Size 0xCC
     boC8:Boolean;
   public
      constructor Create(XX,YY:Integer;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TRedThunderEffect = class (TMagicEff)
    n0:integer;
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TLavaEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject; nframe: Integer);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TFairyEffect = class (TMagicEff) //�����ػ�
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TObjectEffects = class (TMagicEff)
     ObjectID : TObject;
     boC8:Boolean;
   public
     constructor Create(ObjectiD2:TObject;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
     function  Run: Boolean; override;
     procedure DrawEff (surface: TAsphyreCanvas); override;
     destructor Destroy; override;
   end;

  { THit4Effects = class (TObjectEffects) //����ն
   public
     constructor Create(ObjectiD2:TObject;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
     function  Run: Boolean; override;
   end;  }

   TFireDragonEffect = class (TMagicEff)
     FlyX1,FlyY1, FlyX2,FlyY2: Integer;
     boflyFixedEffect: Boolean;
   public
     constructor Create(id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
     procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TFireFixedEffect = class (TMagicEff)
     FlyX1,FlyY1, FlyX2,FlyY2: Integer;
     boflyFixedEffect: Boolean;
   public
     constructor Create(id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
     procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   //��� �׵�
   TFoxRedDrawEffect = class (TMagicEff)//Size 0xCC
     btAddImage:Byte;
   public
      constructor Create(XX,YY:Integer;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;AddImage: Byte);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TIceRainEffect = class (TMagicEff)//��˪ѩ��
   public
     procedure DrawEff (surface: TAsphyreCanvas); override;
   end;

   TGroupThuderEffect = class(TThuderEffect) //��������
   public
     procedure DrawEff (surface: TAsphyreCanvas); override;
   end; 

   procedure GetEffectBase (mag, mtype: integer; var wimg: TAspWMImages; var idx: integer; btdir, btEffectLevelEx: Byte);



implementation

uses
   ClMain, Actor, SoundUtil, MShare;
   
{------------------------------------------------------------------------------}
//ȡ��ħ��Ч������ͼ��(20071028)
//GetEffectBase(mag, mtype,wimg,idx)
//������mag--���������ݱ��е�Effect�ֶ�(ħ��Ч��)��������ն�˴�Ϊ61-1
//      mtype--��ʵ����˼�Ĳ������˴� ȡֵ
//      wimg--TWMImages�࣬��ͼƬ��ʾ�ĵط�
//      idx---�ڶ�Ӧ��WIL�ļ� �ͼƬ������λ��
//
//***{EffectBase�ࣺ�����ӦIDX��ֵ��ӦWIL�ļ� ͼƬ����ֵ}***  ���� idx := EffectBase[mag];
{------------------------------------------------------------------------------}
procedure GetEffectBase (mag, mtype: integer; var wimg: TAspWMImages; var idx: integer; btdir, btEffectLevelEx: Byte);
begin
  wimg := nil;
  idx := 0;
  //�����
  if mag = 131 then mag := 9;
  if mag = 129 then btEffectLevelEx := 0;
  
  case mtype of
    0: begin  //ħ��Ч��
      if btEffectLevelEx in [1..9] then begin //���ؼ���

        case mag of
          7: begin //�����Ӱ
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1];
          end;
          8, 74: begin //�׵���
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          9, 10, 11, 99, 117, 118: begin //���,��ʥս����,�����,4�����
            wimg := g_WMagic8Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          14: begin //�ٻ�����
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 20;
          end;
          19: begin//��ǽ
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          20, 120: begin //���ѻ���
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          30: begin //������
            wimg := g_WMagic8Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          50, 79, 125, 126: begin//���ǻ���,4�����ǻ���, ��ɫ���ǻ���, ��ɫ4�����ǻ���
            wimg := g_WMagic9Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          75: begin//�ٻ�ʥ��
            wimg := g_WMagic8Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) div 3 * 20;
          end;
          33, 100, 121, 122: begin //�����,4�������,��ɫ�����,��ɫ�ļ������
            wimg := g_WMagic9Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 10;
          end;
          76, 77: begin//ʩ����ǿ��Ч��
            wimg := g_WMagic7Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 20;
          end;
          47, 73, 114, 115: begin//��Ѫ��, ǿ����Ѫ��
            wimg := g_WMagic9Images;
            if mag in [0..MAXEFFECT-1] then begin
              case btEffectLevelEx of
                1..3: begin
                  idx := EffectBase[mag][1] + (btEffectLevelEx-1) * 20;
                end;
                4..6: begin
                  idx := EffectBase[mag][1] + 150 + (btEffectLevelEx-4) * 20;
                end;
                7..9: begin
                  idx := EffectBase[mag][1] + 300 + (btEffectLevelEx-7) * 20;
                end;
              end;
            end;
          end;
        end;
      end else begin
        case mag of
          59: wimg := g_WMagic4Images;
          60,61,62,63,64: begin //Ӣ�ۺϻ�-����ն,����һ��,�ɻ�����,ĩ������,��������
            wimg := g_WMagic4Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          8,27,33..35,37..39,42,43,44,45{46}..48,54{����ٵ�},73,75: begin
            wimg := g_WMagic2Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          31: begin
            wimg := {FrmMain.WMon21Img20080720ע��}g_WMonImagesArr[20];
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          36: begin
            wimg := {FrmMain.WMon22Img20080720ע��}g_WMonImagesArr[21];
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          40, 204: begin  //�ٻ�����
            wimg := g_WMagicImages;//g_WMonImagesArr[17];
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          50,51: begin //���ǻ��� 20080510
            wimg := g_WMagic6Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          65: begin //��������
            wimg := g_WMain2Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          74, 76,77,79: begin  //4���׵���, 4�����ǻ���
            wimg := g_WMagic7Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          80..82: begin
            wimg := g_WMagic8Images; //Ѫ��һ��(ս), Ѫ��һ��(��), Ѫ��һ��(��)
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          89: begin
            wimg := g_WDragonImages;
            idx:=350;
          end;
          41, 90, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 198 ,199: begin //��������������ܣ���ɫ����������ɫ��Ѫ������ɫ�ļ���Ѫ������ɫ�޼�����
            wimg := g_WMagic5Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          96: begin //Ψ�Ҷ���
            wimg := g_WMagic7Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          98: begin
            wimg := g_WMonImagesArr[24];
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          99: begin //4�����   20080111
            wimg := g_WMagic6Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          100: begin
            wimg := g_WMagic6Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          102, 106, 109, 112: begin //˫����,������,������,�򽣹���
            wimg := g_WCboEffectImages;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0]+  btdir* 20;
          end;
          108: begin //���ױ� 20090624
            wimg := g_WCboEffectImages;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          103, 105, 111: begin //��Х��, �����,����ѩ�� 20090624
            wimg := g_WCboEffectImages;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0]+  btdir* 10;
          end;
          128, 129, 132..136: begin //�ķ� ��˪ѩ�� ����֮�� ��˪Ⱥ��
            wimg := g_WMagic10Images;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          131: begin //�����
            wimg := g_WMagic8Images16;
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          197: begin
            wimg := g_WMonImagesArr[33];
            if mag in [0..MAXEFFECT-1] then idx := EffectBase[mag][0];
          end;
          else begin
            wimg := g_WMagicImages;
            if mag in [0..MAXEFFECT-1] then
            idx := EffectBase[mag][0];
          end;
        end;
      end;
    end;
    1: begin //����Ч��
      wimg := g_WMagicImages;
      if mag in [0..MAXHITEFFECT-1] then idx := HitEffectBase[mag];
      case mag of
        5: wimg := g_WMagic2Images;
        6,9,19..21: wimg := g_Wmagic5Images; //����ն�ػ� ����ն���
        7: wimg := g_WMagic2Images;//��Ӱ����
        8,10: wimg := g_WMagic6Images;//4���һ� 20080112
        11: wimg := g_WMagic4Images;//����һ��սʿЧ�� 20080611
        12..15: wimg := g_WCboEffectImages;//׷�Ĵ� ����ɱ  ��ɨǧ��  ����ն  {����ٵ�}
        16,17: wimg := g_WMagic7Images;//4����ɱ����,Բ���䵶
        18: wimg := g_WMagic8Images;//Ѫ��һ��(ս)
        22, 23: wimg := g_WMagic9Images;
        24, 25: wimg := g_WMagic8Images16;
        26..34: wimg := g_WMagic7Images16;
      end;
    end;
  end;
end;

// new copy by liuzhigang 
constructor TMagicEff.Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
var
   tax, tay: integer;
begin
    ImgLib := g_WMagicImages;  //�⺻

   case mtype of
     mtReady: begin
       start := 0;
       frame := -1;
       ExplosionFrame := 20;
       curframe := start;
       FixedEffect := TRUE;
       Repetition := FALSE;
     end;
     mtFly,mtBujaukGroundEffect,mtExploBujauk: begin  //�����л����� 2007.10.31
       start:=0;
       frame:=6;
       curframe:=start;
       FixedEffect:=False;
       Repetition:=Recusion;
       ExplosionFrame:=10;
       if id = 38 then frame:=10;
       if id = 39 then begin
         frame:=4;
         ExplosionFrame:=8;
       end;
       if (id - 81 - 3) < 0 then begin
         bt80:=1;
         Repetition:=True;
         if id = 81 then begin
           if g_MySelf.m_nCurrX >= 84 then begin
             EffectBase:=130;
           end else begin
             EffectBase:=140;
           end;
           bt81:=1;
         end;
         if id = 82 then begin
           if (g_MySelf.m_nCurrX >= 78) and (g_MySelf.m_nCurrY >= 48) then begin
             EffectBase:=150;
           end else begin
             EffectBase:=160;
           end;
           bt81:=2;
         end;
         if id = 83 then begin
           EffectBase:=180;
           bt81:=3;
         end;
         start:=0;
         frame:=10;
         MagExplosionBase:=190;
         ExplosionFrame:=10;
       end;
     end;
     mt12: begin
       start:=0;
       frame:=6;
       curframe:=start;
       FixedEffect:=False;
       Repetition:=Recusion;
       ExplosionFrame:=1;
     end;
     mt13: begin
       start:=0;
       frame:=20;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ExplosionFrame:=20;
       ImgLib:={FrmMain.WMon21Img20080720ע��}g_WMonImagesArr[20];
     end;
     mtExplosion,mtThunder,mtLightingThunder,mtRedThunder,mtLava: begin
       start := 0;
       frame := -1;
       ExplosionFrame := 10;
       curframe := start;
       FixedEffect := TRUE;
       Repetition := FALSE;
       if id = 80 then begin
         bt80:=2;
         case Random(6) of
           0:begin
             EffectBase:=230;
           end;
           1:begin
             EffectBase:=240;
           end;
           2:begin
             EffectBase:=250;
           end;
           3:begin
             EffectBase:=230;
           end;
           4:begin
             EffectBase:=240;
           end;
           5:begin
             EffectBase:=250;
           end;
         end;
         Light:=4;
         ExplosionFrame:=5;
       end;
       if id = 70 then begin
         bt80:=3;
         case Random(3) of
           0:begin
             EffectBase:=400;
           end;
           1:begin
             EffectBase:=410;
           end;
           2:begin
             EffectBase:=420;
           end;
         end;
         Light:=4;
         ExplosionFrame:=5;
       end;
       if id = 71 then begin
         bt80:=3;
         ExplosionFrame:=20;
       end;
       if id = 72 then begin
         bt80:=3;
         Light:=3;
         ExplosionFrame:=10;
       end;
       if id = 73 then begin
         bt80:=3;
         Light:=5;
         ExplosionFrame:=20;
       end;
       if id = 74 then begin
         bt80:=3;
         Light:=4;
         ExplosionFrame:=35;
       end;
       if id = 90 then begin
         EffectBase:=350;
         MagExplosionBase:=350;
         ExplosionFrame:=30;
       end;
     end;
     mt14: begin
       start:=0;
       frame:=-1;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ImgLib:=g_WMagic2Images;
     end;
     mtFlyAxe: begin
       start := 0;
       frame := 3;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 3;
     end;
     mtFlyArrow: begin
       start := 0;
       frame := 1;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 1;
     end;
     mt15: begin
       start := 0;
       frame := 6;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 2;
     end;
     mt16: begin
       start := 0;
       frame := 1;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 1;
     end;
    else begin
   end;
  end;
   n7C:=0;
   ServerMagicId := id; //������ ID
   EffectBase := effnum; //MagicDB - Effect
   TargetX := tx;   // "   target x
   TargetY := ty;   // "   target y
   if bt80 =1 then begin
     if id = 81 then begin
       dec(sx,14);
       inc(sy,20);
     end;
     if id = 81 then begin
       dec(sx,70);
       dec(sy,10);
     end;
     if id = 83 then begin
       dec(sx,60);
       dec(sy,70);
     end;
     PlaySound(8208);
   end;
   fireX := sx;     //
   fireY := sy;     //
   FlyX := sx;      //
   FlyY := sy;
   OldFlyX := sx;
   OldFlyY := sy;
   FlyXf := sx;
   FlyYf := sy;
   FireMyselfX := g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX;
   FireMyselfY := g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY;
   if bt80 = 0 then begin
     MagExplosionBase := EffectBase + EXPLOSIONBASE;
   end;

   light := 1;

   if fireX <> TargetX then tax := abs(TargetX-fireX)
   else tax := 1;
   if fireY <> TargetY then tay := abs(TargetY-fireY)
   else tay := 1;
   if abs(fireX-TargetX) > abs(fireY-TargetY) then begin
      firedisX := Round((TargetX-fireX) * (500 / tax));
      firedisY := Round((TargetY-fireY) * (500 / tax));
   end else begin
      firedisX := Round((TargetX-fireX) * (500 / tay));
      firedisY := Round((TargetY-fireY) * (500 / tay));
   end;

   NextFrameTime := 50;
   m_dwFrameTime := GetTickCount;
   m_dwStartTime := GetTickCount;
   steptime := GetTickCount;
   RepeatTime := anitime;
   Dir16 := GetFlyDirection16 (sx, sy, tx, ty);
   OldDir16 := Dir16;
   NextEffect := nil;
   m_boActive := TRUE;
   prevdisx := 99999;
   prevdisy := 99999;
end;

destructor TMagicEff.Destroy;
begin
   inherited Destroy;
end;

function  TMagicEff.Shift: Boolean;
   function OverThrough (olddir, newdir: integer): Boolean;
   begin
      Result := FALSE;
      if abs(olddir-newdir) >= 2 then begin
         Result := TRUE;
         if ((olddir=0) and (newdir=15)) or ((olddir=15) and (newdir=0)) then
            Result := FALSE;
      end;
   end;
var
   {rrx, rry,} ms, stepx, stepy: integer;
   tax, tay, shx, shy, passdir16: integer;
   crash: Boolean;//��ײ
   stepxf, stepyf: Real;
begin
   Result := TRUE;
   if Repetition then begin
      if GetTickCount - steptime > longword(NextFrameTime) then begin
         steptime := GetTickCount;
         Inc (curframe);
         if curframe > start+frame-1 then
            curframe := start;
      end;
   end else begin
      if (frame > 0) and (GetTickCount - steptime > longword(NextFrameTime)) then begin
         steptime := GetTickCount;
         Inc (curframe);
         if curframe > start+frame-1 then begin
            curframe := start+frame-1;
            Result := FALSE;
         end;
      end;
   end;
   if (not FixedEffect) then begin //���Ϊ���̶��Ľ��
      crash := FALSE;
      if TargetActor <> nil then begin
         ms := GetTickCount - m_dwFrameTime;  //���� ȿ���� �׸��� �󸶳� �ð��� �귶����?
         m_dwFrameTime := GetTickCount;
         //TargetX, TargetY �缳��
        PlayScene.ScreenXYfromMCXY (TActor(TargetActor).m_nRx,
                                     TActor(TargetActor).m_nRy,
                                     TargetX,
                                     TargetY);
         shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
         shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
         TargetX := TargetX + shx;
         TargetY := TargetY + shy;

         //���ο� Ÿ���� ��ǥ�� ���� �����Ѵ�.
         if FlyX <> TargetX then tax := abs(TargetX-FlyX)
         else tax := 1;
         if FlyY <> TargetY then tay := abs(TargetY-FlyY)
         else tay := 1;
         if abs(FlyX-TargetX) > abs(FlyY-TargetY) then begin
            newfiredisX := Round((TargetX-FlyX) * (500 / tax));
            newfiredisY := Round((TargetY-FlyY) * (500 / tax));
         end else begin
            newfiredisX := Round((TargetX-FlyX) * (500 / tay));
            newfiredisY := Round((TargetY-FlyY) * (500 / tay));
         end;

         if firedisX < newfiredisX then firedisX := firedisX + _MAX(1, (newfiredisX - firedisX) div 10);
         if firedisX > newfiredisX then firedisX := firedisX - _MAX(1, (firedisX - newfiredisX) div 10);
         if firedisY < newfiredisY then firedisY := firedisY + _MAX(1, (newfiredisY - firedisY) div 10);
         if firedisY > newfiredisY then firedisY := firedisY - _MAX(1, (firedisY - newfiredisY) div 10);
         stepxf := (firedisX/700) * ms;
         stepyf := (firedisY/700) * ms;
         FlyXf := FlyXf + stepxf;
         FlyYf := FlyYf + stepyf;
         FlyX := Round (FlyXf);
         FlyY := Round (FlyYf);

         //���� �缳��
       //  Dir16 := GetFlyDirection16 (OldFlyX, OldFlyY, FlyX, FlyY);
         OldFlyX := FlyX;
         OldFlyY := FlyY;
         //������θ� Ȯ���ϱ� ���Ͽ�
         passdir16 := GetFlyDirection16 (FlyX, FlyY, TargetX, TargetY);


         {DebugOutStr (IntToStr(prevdisx) + ' ' + IntToStr(prevdisy) + ' / ' + IntToStr(abs(TargetX-FlyX)) + ' ' + IntToStr(abs(TargetY-FlyY)) + '   ' +
                      IntToStr(FlyX) + '.' + IntToStr(FlyY) + ' ' +
                      IntToStr(TargetX) + '.' + IntToStr(TargetY));  }
         if ((abs(TargetX-FlyX) <= 15) and (abs(TargetY-FlyY) <= 15)) or
            ((abs(TargetX-FlyX) >= prevdisx) and (abs(TargetY-FlyY) >= prevdisy)) or
            OverThrough(OldDir16, passdir16) then begin
            crash := TRUE;
         end else begin
            prevdisx := abs(TargetX-FlyX);
            prevdisy := abs(TargetY-FlyY);
            //if (prevdisx <= 5) and (prevdisy <= 5) then crash := TRUE;
         end;
         OldDir16 := passdir16;

      end else begin
         ms := GetTickCount - m_dwFrameTime;  //ȿ���� ������ �󸶳� �ð��� �귶����?

         {rrx := TargetX - fireX;
         rry := TargetY - fireY;  }

         stepx := Round ((firedisX/900) * ms);
         stepy := Round ((firedisY/900) * ms);
         FlyX := fireX + stepx;
         FlyY := fireY + stepy;
      end;

      PlayScene.CXYfromMouseXY (FlyX, FlyY, Rx, Ry);

      if crash and (TargetActor <> nil) then begin
         FixedEffect := TRUE;  //����
         start := 0;
         frame := ExplosionFrame;
         curframe := start;
         Repetition := FALSE;
         //������ ����
         if ServerMagicId <> 112 then begin
           PlaySound (TActor(MagOwner).m_nMagicExplosionSound)
         end else begin
           MyPlaySound (dnsbaozhu);
         end;
      end; 
      //if not Map.CanFly (Rx, Ry) then
      //   Result := FALSE;
   end;
   if FixedEffect then begin //�̶����
      if frame = -1 then frame := ExplosionFrame;
      if TargetActor = nil then begin
         FlyX := TargetX - ((g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX);
         FlyY := TargetY - ((g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY);
         PlayScene.CXYfromMouseXY (FlyX, FlyY, Rx, Ry);
      end else begin
         Rx := TActor(TargetActor).m_nRx;
         Ry := TActor(TargetActor).m_nRy;
         PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
         FlyX := FlyX + TActor(TargetActor).m_nShiftX;
         FlyY := FlyY + TActor(TargetActor).m_nShiftY;
      end;
   end;
end;

procedure TMagicEff.GetFlyXY (ms: integer; var fx, fy: integer);
var
   {rrx, rry,} stepx, stepy: integer;
begin
   {rrx := TargetX - fireX;
   rry := TargetY - fireY;    }

   stepx := Round ((firedisX/900) * ms);
   stepy := Round ((firedisY/900) * ms);
   fx := fireX + stepx;
   fy := fireY + stepy;
end;

function  TMagicEff.Run: Boolean;
begin
   Result := Shift;
   if Result then
      if GetTickCount - m_dwStartTime > 10000 then //2000 then
         Result := FALSE
      else Result := TRUE;

end;
{------------------------------------------------------------------------------}
//�˹�����ʾħ������Ʈ�ƹ���(20071031)
//DrawEff (Surface: TAsphyreCanvas);
//
//***EffectBase��ΪEffectBase���������***  
{------------------------------------------------------------------------------}
procedure TMagicEff.DrawEff (Surface: TAsphyreCanvas);
var
  img: integer;
  d: TAsphyreLockableTexture;
  shx, shy: integer;
  ErrorCode: Integer;
begin
  try
   ErrorCode := 0;
   if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin
      ErrorCode := 1;
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
      ErrorCode := 2;
      if not FixedEffect then begin
        ErrorCode := 3;
         //�뷽���йص�ħ��Ч��
         img := EffectBase + FLYBASE + Dir16 * 10;
         ErrorCode := 4;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         ErrorCode := 5;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
         ErrorCode := 6;
      end else begin
         ErrorCode := 7;
         //�뷽���޹ص�ħ��Ч�������籬ը��
         img := MagExplosionBase + curframe; //EXPLOSIONBASE;
         ErrorCode := 8;
         d := ImgLib.GetCachedImage (img, px, py);
         {$IF M2Version <> 2}
         if ImgLib = g_WMagic5Images then
         case MagExplosionBase of //���������λ
           1075: begin //��ɫ��Ѫ��
             if g_WMagic2Images <> nil then
               g_WMagic2Images.GetCachedImage(img-15, px, py);
           end;
           1125: begin //��ɫ�ļ���Ѫ��
             {if g_WMagic2Images <> nil then
               g_WMagic2Images.GetCachedImage(img+25, px, py);   }
             px := px + 30;
             py := py - 30;
           end;
           1180: begin //��ɫ�޼�����
             if g_WMagic2Images <> nil then
               g_WMagic2Images.GetCachedImage(img-1015, px, py); 
           end;
         end;
         {$IFEND}
         ErrorCode := 9;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d );
         end;
         ErrorCode := 10;
      end;
   end;
  except
    DebugOutStr ('TMagicEff.DrawEff:'+IntToStr(ErrorCode));
  end;
end;


{-----------------------------------------------------------}
//      TFlyingAxe : ���ư��� ����
{------------------------------------------------------------}
constructor TFlyingAxe.Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
   inherited Create (id, effnum, sx, sy, tx, ty, mtype, Recusion, anitime);
   FlyImageBase := FLYOMAAXEBASE;
   ReadyFrame := 65;
end;

procedure TFlyingAxe.DrawEff (Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
   if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         //
         img := FlyImageBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
      end;
   end;
  except
    DebugOutStr('TFlyingAxe.DrawEff');
  end;
end;


{------------------------------------------------------------}
//      TFlyingArrow : ���ư��� ȭ��
{------------------------------------------------------------}

procedure TFlyingArrow.DrawEff (Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
//(**6����ġ
   if m_boActive and ((Abs(FlyX-fireX) > 40) or (Abs(FlyY-fireY) > 40)) then begin
//*)
(**����
   if Active then begin //and ((Abs(FlyX-fireX) > 65) or (Abs(FlyY-fireY) > 65)) then begin
//*)
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         //���ư��°�
         img := FlyImageBase + Dir16; // * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
//(**6����ġ
         if d <> nil then begin
            //���ĺ������� ����
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy - 46,
                          d.ClientRect, d, TRUE);
         end;
//**)
(***����
         if d <> nil then begin
            //���ĺ������� ����
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
//**)
      end;
   end;
  except
    DebugOutStr('TFlyingArrow.DrawEff');
  end;
end;


{--------------------------------------------------------}

constructor TCharEffect.Create (effbase, effframe: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     TActor(target).m_nCurrX, TActor(target).m_nCurrY,
                     TActor(target).m_nCurrX, TActor(target).m_nCurrY,
                     mtExplosion,
                     FALSE,
                     0);
   TargetActor := target;
   frame := effframe;
   NextFrameTime := 30;
end;

function  TCharEffect.Run: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start+frame-1;
         Result := FALSE;
      end;
   end;
end;

procedure TCharEffect.DrawEff (Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
begin
  try
   if TargetActor <> nil then begin
      Rx := TActor(TargetActor).m_nRx;
      Ry := TActor(TargetActor).m_nRy;
      PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
      FlyX := FlyX + TActor(TargetActor).m_nShiftX;
      FlyY := FlyY + TActor(TargetActor).m_nShiftY;
      d := ImgLib.GetCachedImage (EffectBase + curframe, px, py);
      if d <> nil then begin
         Surface.DrawBlend(
                    FlyX + px - UNITX div 2,
                    FlyY + py - UNITY div 2,
                    d);
      end;
   end;
  except
    DebugOutStr('TCharEffect.DrawEff');
  end;
end;


{--------------------------------------------------------}

constructor TMapEffect.Create (effbase, effframe: integer; x, y: integer);
begin
   inherited Create (111, effbase,
                     x, y,
                     x, y,
                     mtExplosion,
                     FALSE,
                     0);
   TargetActor := nil;
   frame := effframe;
   NextFrameTime := 30;
   RepeatCount := 0;
   boC8 := True;
end;

function  TMapEffect.Run: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start+frame-1;
         if RepeatCount > 0 then begin
            Dec (RepeatCount);
            curframe := start;
         end else
            Result := FALSE;
      end;
   end;
end;

procedure TMapEffect.DrawEff (Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
begin
  try
   Rx := TargetX;
   Ry := TargetY;
   PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
   d := ImgLib.GetCachedImage (EffectBase + curframe, px, py);
    if d <> nil then begin
      if boC8 then begin
        Surface.DrawBlend(
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d);
      end else begin
        surface.Draw(FlyX + px - UNITX div 2, FlyY + py - UNITY div 2, d.ClientRect, d, True);
      end;
    end;
  except
    DebugOutStr('TMapEffect.DrawEff');
  end;
end;


{--------------------------------------------------------}

constructor TScrollHideEffect.Create (effbase, effframe: integer; x, y: integer; target: TObject);
begin
   inherited Create (effbase, effframe, x, y);
   //TargetCret := TActor(target);//�ڳ������������֮��ʱ��������Ŀ��
end;

function  TScrollHideEffect.Run: Boolean;
begin
   Result := inherited Run;

   if frame = 7 then
      if g_TargetCret <> nil then
         PlayScene.DeleteActor (g_TargetCret.m_nRecogId);
end;


{--------------------------------------------------------}


constructor TLightingEffect.Create (effbase, effframe: integer; x, y: integer);
begin

end;

function  TLightingEffect.Run: Boolean;
begin
  Result:=False;//Jacky
end;


{--------------------------------------------------------}


constructor TFireGunEffect.Create (effbase, sx, sy, tx, ty: integer);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtFireGun,
                     TRUE,
                     0);
   NextFrameTime := 50;
   FillChar (FireNodes, sizeof(TFireNode)*FIREGUNFRAME, #0);
   OutofOil := FALSE;
   firetime := GetTickCount;
end;

function  TFireGunEffect.Run: Boolean;
var
   i: integer;
   allgone: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      Shift;
      steptime := GetTickCount;
      //if not FixedEffect then begin  //��ǥ�� ���� �ʾ�����
      if not OutofOil then begin
         if (abs(RX-TActor(MagOwner).m_nRx) >= 5) or (abs(RY-TActor(MagOwner).m_nRy) >= 5) or (GetTickCount - firetime > 800) then
            OutofOil := TRUE;
         for i:=FIREGUNFRAME-2 downto 0 do begin
            FireNodes[i].FireNumber := FireNodes[i].FireNumber + 1;
            FireNodes[i+1] := FireNodes[i];
         end;
         FireNodes[0].FireNumber := 1;
         FireNodes[0].x := FlyX;
         FireNodes[0].y := FlyY;
      end else begin
         allgone := TRUE;
         for i:=FIREGUNFRAME-2 downto 0 do begin
            if FireNodes[i].FireNumber <= FIREGUNFRAME then begin
               FireNodes[i].FireNumber := FireNodes[i].FireNumber + 1;
               FireNodes[i+1] := FireNodes[i];
               allgone := FALSE;
            end;
         end;
         if allgone then Result := FALSE;
      end;
   end;
end;

procedure TFireGunEffect.DrawEff (Surface: TAsphyreCanvas);
var
   i, shx, shy, firex, firey, prx, pry, img: integer;
   d: TAsphyreLockableTexture;
begin
  try
   prx := -1;
   pry := -1;
   for i:=0 to FIREGUNFRAME-1 do begin
      if (FireNodes[i].FireNumber <= FIREGUNFRAME) and (FireNodes[i].FireNumber > 0) then begin
         shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
         shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
         img := EffectBase + (FireNodes[i].FireNumber - 1);
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            firex := FireNodes[i].x + px - UNITX div 2 - shx;
            firey := FireNodes[i].y + py - UNITY div 2 - shy;
            if (firex <> prx) or (firey <> pry) then begin
               prx := firex;
               pry := firey;
               Surface.DrawBlend( firex, firey, d);
            end;
         end;
      end;
   end;
  except
    DebugOutStr('TFireGunEffect.DrawEff');
  end;
end;

{--------------------------------------------------------}

constructor TThuderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtThunder,
                     FALSE,
                     0);
   TargetActor := target;

end;

procedure TThuderEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img, px, py: integer;
   d: TAsphyreLockableTexture;
begin
  try
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      Surface.DrawBlend(
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d);
   end;
  except
    DebugOutStr('TThuderEffect.DrawEff');
  end;
end;


{--------------------------------------------------------}

constructor TLightingThunder.Create (effbase, sx, sy, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtLightingThunder,
                     FALSE,
                     0);
   TargetActor := target;
end;

procedure TLightingThunder.DrawEff (Surface: TAsphyreCanvas);
var
   img, sx, sy, px, py {shx, shy}: integer;
   d: TAsphyreLockableTexture;
begin
  try
   img := EffectBase + Dir16 * 10;
   if curframe < 6 then begin

      {shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;   }

      d := ImgLib.GetCachedImage (img + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (TActor(MagOwner).m_nRx,
                                     TActor(MagOwner).m_nRy,
                                     sx,
                                     sy);
         Surface.DrawBlend(
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d);
      end;
   end;
  except
    DebugOutStr('TLightingThunder.DrawEff');
  end;
   {if (curframe < 10) and (TargetActor <> nil) then begin
      d := ImgLib.GetCachedImage (EffectBase + 17*10 + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (TActor(TargetActor).RX,
                                     TActor(TargetActor).RY,
                                     sx,
                                     sy);
         Surface.DrawBlend(
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d, 1);
      end;
   end;}
end;
{--------------------------------------------------------}
//�ƻ�ħ��������  20080226
constructor TPHHitEffect.Create (effbase, sx, sy, tx, ty: integer; aowner: TObject);
begin


   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, 
                     mtReady,
                     FALSE,
                     0);
   NextFrameTime := 80;

   Rx := TActor(aowner).m_nRx;
   Ry := TActor(aowner).m_nRy;
end;

procedure TPHHitEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img, sx, sy, px, py : integer;
   d: TAsphyreLockableTexture;
begin
  try
   img := (Dir16 div 2) * 20 + 10;
   if curframe < 20 then begin

      d := g_WMagic4Images.GetCachedImage (img + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (Rx, Ry, sx, sy);
         Surface.DrawBlend(
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d);
      end;
   end;
  except
    DebugOutStr('TPHHitEffect.DrawEff');
  end;
end;
{--------------------------------------------------------}


constructor TExploBujaukEffect.Create (effbase, sx, sy, tx, ty: integer; target: TObject; AddEffect: Boolean);
begin

   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtExploBujauk,
                     TRUE,
                     0);
   m_boAddEffect := AddEffect;
   frame := 3;
   TargetActor := target;
   NextFrameTime := 50;
end;

procedure TExploBujaukEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
   if m_boActive and ((Abs(FlyX-fireX) > 30) or (Abs(FlyY-fireY) > 30) or FixedEffect) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin //�ǹ̶����
         img := EffectBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            //���ĺ������� ����
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
         if m_boAddEffect then begin //�ļ����
           d := ImgLib.GetCachedImage (img + curframe+170, px, py);
           if d <> nil then begin
              Surface.DrawBlend (
                         FlyX + px - UNITX div 2 - shx,
                         FlyY + py - UNITY div 2 - shy,
                         d.ClientRect, d);
           end;
         end;
      end else
      begin
         //����
         img := MagExplosionBase + curframe;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            Surface.DrawBlend (
                       FLyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d.ClientRect, d);
         end;
      end;
   end;
  except
    DebugOutStr('TExploBujaukEffect.DrawEff');
  end;
end;

{--------------------------------------------------------}

constructor TBujaukGroundEffect.Create (effbase, magicnumb, sx, sy, tx, ty: integer; effLevelEx: Byte; AddEffect: Boolean);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtBujaukGroundEffect,
                     TRUE,
                     0);
   frame := 3;
   MagicNumber := magicnumb;
   EffectLevelEx := effLevelEx;
   m_boAddEffect := AddEffect;
   BoGroundEffect := FALSE;
   NextFrameTime := 50;
end;

function  TBujaukGroundEffect.Run: Boolean;
begin
   Result := inherited Run;
   if not FixedEffect then begin
      if ((abs(TargetX-FlyX) <= 15) and (abs(TargetY-FlyY) <= 15)) or
         ((abs(TargetX-FlyX) >= prevdisx) and (abs(TargetY-FlyY) >= prevdisy)) then begin
         FixedEffect := TRUE;  //�̶����
         start := 0;
         frame := ExplosionFrame;
         curframe := start;
         Repetition := FALSE;
         //������ ����
         PlaySound (TActor(MagOwner).m_nMagicExplosionSound);
         Result := TRUE;
      end else begin
         prevdisx := abs(TargetX-FlyX);
         prevdisy := abs(TargetY-FlyY);
      end;
   end;
end;

procedure TBujaukGroundEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
    if m_boActive and ((Abs(FlyX-fireX) > 30) or (Abs(FlyY-fireY) > 30) or FixedEffect) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         //���ư��°�
         img := EffectBase + Dir16 * 10;
         {$IF M2Version <> 2}
         if (MagicNumber in [118, 119]) and (EffectLevelEx = 0) then begin
           if g_WMagicImages <> nil then
            d := g_WMagicImages.GetCachedImage(img + curframe, px, py);
         end else
         {$IFEND}
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            //���ĺ������� ����
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
         if m_boAddEffect then begin //�ļ����
           d := ImgLib.GetCachedImage (img + curframe+170, px, py);
           if d <> nil then begin
              surface.DrawBlend (
                         FlyX + px - UNITX div 2 - shx,
                         FlyY + py - UNITY div 2 - shy,
                         d.ClientRect, d);
           end;
         end;
      end else begin
         case MagicNumber of
           11: begin
             if EffectLevelEx in [1..9] then begin
               case EffectLevelEx of
                 1..3: img := 2470 + curframe;
                 4..6: img := 2490 + curframe;
                 7..9: img := 2520 + curframe;
               end;
               ImgLib := g_WMagic7Images16;
             end else img := EffectBase + 16 * 10 + curframe;
           end;
           12: begin
             if EffectLevelEx in [1..9] then begin
               img := 2410 + (EffectLevelEx-1) div 3 * 20 + curframe;
               ImgLib := g_WMagic7Images16;
             end else img := EffectBase + 18 * 10 + curframe;
           end;
           118: begin
             if EffectLevelEx in [1..9] then begin
               img := 2410 + (EffectLevelEx-1) div 3 * 20 + curframe;
               ImgLib := g_WMagic7Images16;
             end else begin
               GetEffectBase (MagicNumber -1 , 0,ImgLib,img, TActor(MagOwner).m_btDir, EffectLevelEx);
               img := img + 10 + curframe;
             end;
           end;
           119: begin
             if EffectLevelEx in [1..9] then begin
               case EffectLevelEx of
                 1..3: img := 2470 + curframe;
                 4..6: img := 2490 + curframe;
                 7..9: img := 2520 + curframe;
               end;
               ImgLib := g_WMagic7Images16;
             end else begin
               GetEffectBase (MagicNumber -1 , 0,ImgLib,img, TActor(MagOwner).m_btDir, EffectLevelEx);
               img := img + 10 + curframe;
             end;
           end;
           46: begin
             GetEffectBase (MagicNumber -1 , 0,ImgLib,img, TActor(MagOwner).m_btDir, EffectLevelEx);
             img := img + 10 + curframe;
           end
           else img := EffectBase + 18 * 10 + curframe;
         end;

         d := ImgLib.GetCachedImage (img, px, py);

         if d <> nil then begin
            surface.DrawBlend (
                       FLyX + px - UNITX div 2, // - shx,
                       FlyY + py - UNITY div 2, // - shy,
                       d.ClientRect, d);
         end;

         {if not BoGroundEffect and (curframe = 8) then begin
            BoGroundEffect := TRUE;
            meff := TMapEffect.Create (img+2, 6, TargetRx, TargetRy);
            meff.NextFrameTime := 100;
            //meff.RepeatCount := 1;
            PlayScene.GroundEffectList.Add (meff);
         end; }
      end;
    end;
  except
    DebugOutStr('TBujaukGroundEffect.DrawEff');
  end;
end;


{ TNormalDrawEffect }

constructor TNormalDrawEffect.Create(XX,YY:Integer;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
begin
  inherited Create (111,effbase, XX, YY, XX, YY,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
end;

procedure TNormalDrawEffect.DrawEff(Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
   nRx,nRy,nPx,nPy:integer;
begin
  try
   d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
   if d <> nil then begin
     PlayScene.ScreenXYfromMCXY (FlyX, FlyY, nRx, nRy);
     if boC8 then begin
       Surface.DrawBlend(nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d);
     end else begin
       surface.Draw (nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d.ClientRect, d, TRUE);
     end;
   end;
  except
    DebugOutStr('TNormalDrawEffect.DrawEff');
  end;
end;

function TNormalDrawEffect.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;

{ TFlyingBug }

constructor TFlyingBug.Create(id, effnum, sx, sy, tx, ty: integer;
  mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
   inherited Create (id, effnum, sx, sy, tx, ty, mtype, Recusion, anitime);
   FlyImageBase := FLYOMAAXEBASE;
   ReadyFrame := 65;
end;

procedure TFlyingBug.DrawEff(Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
  if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := FlyImageBase + (Dir16 div 2) * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
         img := curframe + MagExplosionBase;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2,
                          FlyY + py - UNITY div 2,
                          d.ClientRect, d, TRUE);
         end;
      end;
   end;
   except
     DebugOutStr('TFlyingBug.DrawEff');
   end;
end;

{ TFlyingFireBall }

procedure TFlyingFireBall.DrawEff(Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
begin
  try
    if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin
      d := ImgLib.GetCachedImage (FlyImageBase + (GetFlyDirection (FlyX, FlyY, TargetX, TargetY) * 10) + curframe, px, py);
      if d <> nil then
        Surface.DrawBlend(
                   FLyX + px - UNITX div 2,
                   FlyY + py - UNITY div 2,
                   d);
    end;
  except
    DebugOutStr('TFlyingFireBall.DrawEff');
  end;
end;
{ TRedThunderEffect }

constructor TRedThunderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtRedThunder,
                     FALSE,
                     0);
   TargetActor := target;
   n0:=random(7);
end;

procedure TRedThunderEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img, px, py: integer;
   d: TAsphyreLockableTexture;
begin
  try
   ImgLib:={FrmMain.WDragonImg}g_WDragonImages;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + (7 * n0) + curframe, px, py);
   if d <> nil then begin
      Surface.DrawBlend(
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d);
   end;
  except
    DebugOutStr('TRedThunderEffect.DrawEff');
  end;
end;
{ TLavaEffect }
constructor TLavaEffect.Create (effbase, tx, ty: integer; target: TObject; nframe: Integer);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtLava,
                     FALSE,
                     0);
   TargetActor := target;
   frame :=nframe;
end;

procedure TLavaEffect.DrawEff (Surface: TAsphyreCanvas);
var
   img, px, py: integer;
   d: TAsphyreLockableTexture;
begin
  try
  ImgLib:=g_WDragonImages;
//draw explosion
  if curframe < frame then begin
   img := 470;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      Surface.DrawBlend(
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d);
   end;
  end;
  //draw the rest
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      Surface.DrawBlend(
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d);
   end;
  except
    DebugOutStr('TLavaEffect.DrawEff');
  end;
end;

{ TfenshenThunder }

constructor TfenshenThunder.Create(effbase, sx, sy, tx, ty: integer;
  aowner: TObject);
begin
   Rx := TActor(aowner).m_nRx;
   Ry:=  TActor(aowner).m_nRy;
   dir := TActor(aowner).m_btDir;
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtLightingThunder,
                     FALSE,
                     0);
end;

procedure TfenshenThunder.DrawEff(Surface: TAsphyreCanvas);
  procedure GetFrontPosition (sx, sy, dir: integer; var newx, newy: integer);
  begin
     newx := sx;
     newy := sy;
     case dir of
        DR_UP:      newy := newy-100;
        DR_DOWN:    newy := newy+100;
        DR_LEFT:    newx := newx-145;
        DR_RIGHT:   newx := newx+145;
        DR_UPLEFT:
           begin
              newx := newx - 140;
              newy := newy - 105;
           end;
        DR_UPRIGHT:
           begin
              newx := newx + 145;
              newy := newy - 100;
           end;
        DR_DOWNLEFT:
           begin
              newx := newx - 145;
              newy := newy + 90;
           end;
        DR_DOWNRIGHT:
           begin
              newx := newx + 145;
              newy := newy + 90;
           end;
     end;
  end;
var
   img, sx, sy, px, py: integer;
   d: TAsphyreLockableTexture;
   nx,ny:integer;
begin
  try
   img := EffectBase + Dir * 10;
   if curframe < 10 then begin
      d := ImgLib.GetCachedImage (img + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (Rx,
                                     Ry,
                                     sx,
                                     sy);
         GetFrontPosition(sx + px - UNITX div 2,
                    sy + py - UNITY div 2,Dir,nx,ny);
         Surface.DrawBlend(
                    nx,
                    ny,
                    d);
      end;
     img := 90;
     if curframe < 10 then begin
        d := ImgLib.GetCachedImage (img + curframe, px, py);
        if d <> nil then begin
           PlayScene.ScreenXYfromMCXY (Rx,
                                       Ry,
                                       sx,
                                       sy);

           GetFrontPosition(sx + px - UNITX div 2,
                      sy + py - UNITY div 2,Dir,nx,ny);
           Surface.DrawBlend(
                      nx,
                      ny,
                      d);
        end;
     end;
   end;
  except
    DebugOutStr('TfenshenThunder.DrawEff');
  end;
end;

{ TFairyEffect }

constructor TFairyEffect.Create(effbase, tx, ty: integer; target: TObject);
begin

end;

procedure TFairyEffect.DrawEff(Surface: TAsphyreCanvas);
begin
  inherited;

end;

{ TObjectEffects }
//�Զ���ħ���� 20080809
constructor TObjectEffects.Create(ObjectID2:TObject;WmImage:TAspWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
begin
  inherited Create (111,effbase, 0, 0, 0, 0,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
  ObjectID:=ObjectID2;
end;

destructor TObjectEffects.Destroy;
begin
  ObjectID := nil;
  inherited Destroy;
end;

procedure TObjectEffects.DrawEff(Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
   Rx,Ry,nRx,nRy,nPx,nPy:integer;
   ErrCode: Integer;
begin
  ErrCode := 0;
  try
    ErrCode := 1;
    d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
    ErrCode := 2;
    if (d <> nil) and (ObjectID <> nil) then begin
        ErrCode := 8;
        Rx := TActor(ObjectID).m_nRx;
        ErrCode := 9;
        Ry := TActor(ObjectID).m_nRy;
      ErrCode := 4;
      PlayScene.ScreenXYfromMCXY (Rx, Ry, nRx, nRy);
      ErrCode := 5;
      nRx := nRx + TActor(ObjectID).m_nShiftX;
      nRy := nRy + TActor(ObjectID).m_nShiftY;
      if boC8 then begin
        {$IF M2Version <> 2}
        if ImgLib = g_WMagic5Images then //����ħ�������λ
          case EffectBase of
            1095: begin //��ɫ��Ѫ��
              if g_WMagic2Images <> nil then
                g_WMagic2Images.GetCachedImage(EffectBase + curframe-5, nPx, nPy);
            end;
            1155: begin //��ɫ�ļ���Ѫ��
              if g_WMagic2Images <> nil then
                g_WMagic2Images.GetCachedImage(EffectBase + curframe+25, nPx, nPy);

            end;
          end;
        {$IFEND}
        
         ErrCode := 6;
              Surface.DrawBlend(
                    nRx + npx - UNITX div 2,
                    nRy + npy - UNITY div 2,
                    d);
      end else begin
        ErrCode := 7;
        surface.Draw (nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d.ClientRect, d, TRUE);
      end;
    end;
  except
    DebugOutStr('TObjectEffects.DrawEff Code:'+IntToStr(ErrCode));
  end;
end;

function TObjectEffects.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;

{ TFireDragonEffect }


constructor TFireDragonEffect.Create(id, effnum, sx, sy, tx, ty: integer;
  mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
  inherited Create(id, effnum, sx, sy, tx, ty, mtype,Recusion,anitime);
   FlyX1 := 0;
   FlyY1 := 0;
   FlyX2 := 0;
   FlyY2 := 0;
   boflyFixedEffect:= false;
end;

procedure TFireDragonEffect.DrawEff(Surface: TAsphyreCanvas);
var
  img: integer;
  d: TAsphyreLockableTexture;
  shx, shy: integer;
  ErrorCode: Integer;
begin
  try
   ErrorCode := 0;
   if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin
      ErrorCode := 1;
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
      ErrorCode := 2;
      if not FixedEffect then begin
        ErrorCode := 3;
         //�뷽���йص�ħ��Ч��
      case Dir16 div 2 of
        3,4:img := EffectBase + FLYBASE;
        5:img := EffectBase + FLYBASE + 10;
        6,7:img := EffectBase + FLYBASE + 20;
       end;
         ErrorCode := 4;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         ErrorCode := 5;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
         ErrorCode := 6;
      end else begin
         ErrorCode := 7;
         //�뷽���޹ص�ħ��Ч�������籬ը��
         img := MagExplosionBase + curframe; //EXPLOSIONBASE;
         ErrorCode := 8;
         d := ImgLib.GetCachedImage (img, px, py);
         ErrorCode := 9;
         if not boflyFixedEffect then begin
           flyx2:= TActor(TargetActor).m_nCurrX;
           flyy2:= TActor(TargetActor).m_nCurrY;
           boflyFixedEffect := true;
         end;
         PlayScene.ScreenXYfromMCXY (flyx2, flyy2, FlyX1, FlyY1);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX1 + px - UNITX div 2,
                       FlyY1 + py - UNITY div 2,
                       d);
         end;
         ErrorCode := 10;
      end;
   end;
  except
    DebugOutStr ('TMagicEff.DrawEff:'+IntToStr(ErrorCode));
  end;
end;

{ TFireFixedEffect }

constructor TFireFixedEffect.Create(id, effnum, sx, sy, tx, ty: integer;
  mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
  inherited Create(id, effnum, sx, sy, tx, ty, mtype,Recusion,anitime);
   FlyX1 := 0;
   FlyY1 := 0;
   FlyX2 := 0;
   FlyY2 := 0;
   boflyFixedEffect:= false;
end;

procedure TFireFixedEffect.DrawEff(Surface: TAsphyreCanvas);
var
  img: integer;
  d: TAsphyreLockableTexture;
  shx, shy: integer;
  ErrorCode: Integer;
begin
  try
   ErrorCode := 0;
   if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin
      ErrorCode := 1;
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
      ErrorCode := 2;
      if not FixedEffect then begin
        ErrorCode := 3;
         //�뷽���йص�ħ��Ч��
         img := EffectBase + FLYBASE + Dir16 * 10;
         ErrorCode := 4;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         ErrorCode := 5;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
         ErrorCode := 6;
      end else begin
         ErrorCode := 7;
         //�뷽���޹ص�ħ��Ч�������籬ը��
         img := MagExplosionBase + curframe; //EXPLOSIONBASE;
         ErrorCode := 8;
         d := ImgLib.GetCachedImage (img, px, py);
         ErrorCode := 9;
         if not boflyFixedEffect then begin
           flyx2:= TActor(TargetActor).m_nCurrX;
           flyy2:= TActor(TargetActor).m_nCurrY;
           boflyFixedEffect := true;
         end;
         PlayScene.ScreenXYfromMCXY (flyx2, flyy2, FlyX1, FlyY1);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX1 + px - UNITX div 2,
                       FlyY1 + py - UNITY div 2,
                       d);
         end;
         ErrorCode := 10;
      end;
   end;
  except
    DebugOutStr ('TMagicEff.DrawEff:'+IntToStr(ErrorCode));
  end;
end;

{ TJNExploBujaukEffect }

constructor TJNExploBujaukEffect.Create(effbase, sx, sy, tx, ty: integer;
  target: TObject);
begin
   inherited Create (112, effbase,
                     sx, sy,
                     tx, ty,
                     mtExploBujauk,
                     TRUE,
                     0);
   frame := 8;
   TargetActor := target;
   NextFrameTime := 50;
end;

procedure TJNExploBujaukEffect.DrawEff(Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
   if m_boActive and ((Abs(FlyX-fireX) > 50) or (Abs(FlyY-fireY) > 50) or FixedEffect) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         //���ư��°�
         img := EffectBase + (dir16 div 2) * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            //���ĺ������� ����
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
         if EffectBase = 140 then
         d := ImgLib.GetCachedImage (img + curframe+170, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
      end else begin
         //����
         img := MagExplosionBase + curframe;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FLyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d);
         end;
      end;
   end;
  except
    DebugOutStr('TJNExploBujaukEffect.DrawEff');
  end;
end;

{ TSYZBujaukEffect }

constructor TSYZBujaukEffect.Create(effbase, sx, sy, tx, ty: integer;
  target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtExploBujauk,
                     TRUE,
                     0);
   frame := 4;
   TargetActor := target;
   NextFrameTime := 50;
end;

procedure TSYZBujaukEffect.DrawEff(Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
    if m_boActive and ((Abs(FlyX-fireX) > 50) or (Abs(FlyY-fireY) > 50) or FixedEffect) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := EffectBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
         d := ImgLib.GetCachedImage (img + curframe-160, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
      end else begin
         img := MagExplosionBase + curframe;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FLyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d);
         end;
      end;
    end;
  except
    DebugOutStr('TSYZBujaukEffect.DrawEff');
  end;
end;

{ THXJBujaukEffect }

constructor THXJBujaukEffect.Create(effbase, sx, sy, tx, ty: integer;
  target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtExploBujauk,
                     TRUE,
                     0);
   frame := 4;
   TargetActor := target;
   NextFrameTime := 50;
end;

procedure THXJBujaukEffect.DrawEff(Surface: TAsphyreCanvas);
var
   img: integer;
   d: TAsphyreLockableTexture;
   shx, shy: integer;
begin
  try
    if m_boActive and ((Abs(FlyX-fireX) > 50) or (Abs(FlyY-fireY) > 50) or FixedEffect) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := EffectBase + (Dir16 div 2) * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
         d := ImgLib.GetCachedImage (img + curframe+80, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
      end else begin
         img := MagExplosionBase + (Dir16 div 2) * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
            {Surface.DrawBlend(
                       FLyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d, 1); }
         end;
         d := ImgLib.GetCachedImage (img + curframe+80, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
         d := ImgLib.GetCachedImage (img + curframe+160, px, py);
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
      end;
    end;
  except
    DebugOutStr('THXJBujaukEffect.DrawEff');
  end;
end;
(*
{ THit4Effects }

constructor THit4Effects.Create(ObjectiD2: TObject; WmImage: TAspWMImages;
  effbase, nX: Integer; frmTime: LongWord; boFlag: Boolean);
begin
  inherited Create (111,effbase, 0, 0, 0, 0,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
  ObjectID:=ObjectID2;
end;

function THit4Effects.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;  *)

{ TMagicEffDir8 }

constructor TMagicEffDir8.Create(id, effnum, sx, sy, tx, ty: integer;
  mtype: TMagicType; Recusion: Boolean; anitime: integer; btDir: Byte);
begin
   dir := btDir;
   inherited Create (id, effnum, sx, sy, tx, ty, mtype, Recusion, anitime);
end;

procedure TMagicEffDir8.DrawEff(Surface: TAsphyreCanvas);
var
  img: integer;
  d: TAsphyreLockableTexture;
  shx, shy: integer;
  ErrorCode: Integer;
begin
  try
   ErrorCode := 0;
   if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin
      ErrorCode := 1;
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
      ErrorCode := 2;
      if not FixedEffect then begin
        ErrorCode := 3;
         //�뷽���йص�ħ��Ч��
         img := EffectBase + FLYBASE + Dir * 10;
         ErrorCode := 4;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         ErrorCode := 5;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d);
         end;
         ErrorCode := 6;
      end else begin
         ErrorCode := 7;
         //�뷽���޹ص�ħ��Ч�������籬ը��
         img := MagExplosionBase + curframe; //EXPLOSIONBASE;
         ErrorCode := 8;
         d := ImgLib.GetCachedImage (img, px, py);
         ErrorCode := 9;
         if d <> nil then begin
            Surface.DrawBlend(
                       FlyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d);
         end;
         ErrorCode := 10;
      end;
   end;
  except
    DebugOutStr ('TMagicEffDir8.DrawEff:'+IntToStr(ErrorCode));
  end;
end;

{ TFoxRedDrawEffect }

constructor TFoxRedDrawEffect.Create(XX, YY: Integer; WmImage: TAspWMImages;
  effbase, nX: Integer; frmTime: LongWord; AddImage: Byte);
begin
  inherited Create (111,effbase, XX, YY, XX, YY,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  btAddImage := AddImage;
end;

procedure TFoxRedDrawEffect.DrawEff(Surface: TAsphyreCanvas);
var
   d: TAsphyreLockableTexture;
   nRx,nRy,nPx,nPy,nPx1,nPy1:integer;
begin
  try
   d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
    if d <> nil then begin
      PlayScene.ScreenXYfromMCXY (FlyX, FlyY, nRx, nRy);
      Surface.DrawBlend(nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d);
      if btAddImage > 0 then begin
        d := ImgLib.GetCachedImage (EffectBase + curframe + btAddImage, nPx1, nPy1);
        if d <> nil then begin
          Surface.DrawBlend(nRx + nPx1 - UNITX div 2,nRy + nPy1 - UNITY div 2,d);
        end;
      end;
    end;
  except
    DebugOutStr('TNormalDrawEffect.DrawEff');
  end;
end;

function TFoxRedDrawEffect.Run: Boolean;
begin
  Result := TRUE;
  if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
    steptime := GetTickCount;
    Inc (curframe);
    if curframe > start+frame-1 then begin
       curframe := start;
       Result := FALSE;
    end;
  end;
end;

{ TIceRainEffect }

procedure TIceRainEffect.DrawEff(surface: TAsphyreCanvas);
var
  img: integer;
  d: TAsphyreLockableTexture;
  shx, shy: integer;
const
  n14 = 90;
begin
  try
    if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
      img := MagExplosionBase + curframe; //EXPLOSIONBASE;
      d := ImgLib.GetCachedImage (img, px, py);
      if d <> nil then begin
        surface.DrawBlend (FlyX + px - UNITX div 2,
                   FlyY + py - UNITY div 2, d.ClientRect, d);
        surface.DrawBlend (FlyX + px - UNITX div 2-n14,
                   FlyY + py - UNITY div 2-n14, d.ClientRect, d);
        surface.DrawBlend (FlyX + px - UNITX div 2+n14,
                   FlyY + py - UNITY div 2-n14, d.ClientRect, d);
        surface.DrawBlend ( FlyX + px - UNITX div 2-n14,
                   FlyY + py - UNITY div 2+n14, d.ClientRect, d);
        surface.DrawBlend (FlyX + px - UNITX div 2+n14,
                   FlyY + py - UNITY div 2+n14, d.ClientRect, d);
      end;
    end;
  except
    DebugOutStr ('TIceRainEffect.DrawEff');
  end;
end;

{ TGroupThuderEffect }

procedure TGroupThuderEffect.DrawEff(surface: TAsphyreCanvas);
var
  img, px, py: integer;
  d: TAsphyreLockableTexture;
begin
  try
    img := EffectBase;
    d := ImgLib.GetCachedImage (img + curframe, px, py);
    if d <> nil then begin
      surface.DrawBlend (
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2 - 80,
                 d.ClientRect, d);
      surface.DrawBlend (
                 FlyX + px - UNITX div 2 + 80,
                 FlyY + py - UNITY div 2,
                 d.ClientRect, d);
      surface.DrawBlend (
                 FlyX + px - UNITX div 2 + 40,
                 FlyY + py - UNITY div 2 + 40,
                 d.ClientRect, d);
      surface.DrawBlend (
                 FlyX + px - UNITX div 2 - 20,
                 FlyY + py - UNITY div 2 + 80,
                 d.ClientRect, d);
      surface.DrawBlend (
                 FlyX + px - UNITX div 2 - 80,
                 FlyY + py - UNITY div 2 + 20,
                 d.ClientRect, d);
    end;
  except
    DebugOutStr('TGroupThuderEffect.DrawEff');
  end;
end;

end.
