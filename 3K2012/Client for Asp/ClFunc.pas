unit ClFunc;
//����������
interface

uses
  Windows, SysUtils, Classes,
  Grobal2, HUtil32, Share, AspWil;

var
   DropItems: TList;  //lsit of TClientItem

   
function  fmStr (str: string; len: integer): string;
function  GetGoldStr (gold: integer): string;
procedure SaveBags (flname: string; pbuf: Pbyte);
procedure Loadbags (flname: string; pbuf: Pbyte);
procedure ClearBag;
function  AddItemBag (cu: TClientItem): Boolean;
function AddItemBagLock(cu: TClientItem): Boolean;
function DelItemBagLock(cu: TClientItem): Boolean;
function  AddHeroItemBag (cu: TClientItem): Boolean;//Ӣ�۰� $016 2007.10.23
procedure ArrangeHeroItemBag;//Ӣ�۰� $017 2007.10.23
function  HeroUpdateItemBag (cu: TClientItem): Boolean;    //����Ӣ�۰���
function  DelHeroItemBag (iname: string; iindex: integer): Boolean; //ɾ��Ӣ����Ʒ����
function  UpdateItemBag (cu: TClientItem): Boolean;
function  DelItemBag (iname: string; iindex: integer): Boolean;
procedure ArrangeItemBag;
procedure AddDropItem (ci: TClientItem);
function  GetDropItem (iname: string; MakeIndex: integer): PTClientItem;
procedure DelDropItem (iname: string; MakeIndex: integer);
procedure AddShopItem (ci: TShopItem);
procedure DelShopItem (ci: TShopItem);
procedure DelUserShopItem (nItemidx:Integer;sItemName:string);
procedure DelShopItemEx(nItemidx:Integer);
function GetShopItemRoom(): Boolean;
procedure AddDealItem (ci: TClientItem);
procedure DelDealItem (ci: TClientItem);
procedure AddSellOffItem (ci: TClientItem); //��ӵ����۳��ۿ��� 20080316
procedure MoveSellOffItemToBag; //������� 20080316
procedure AddChallengeItem (ci: TClientItem);
procedure DelChallengeItem (ci: TClientItem);
procedure MoveChallengeItemToBag;
procedure AddChallengeRemoteItem (ci: TClientItem);
procedure DelChallengeRemoteItem (ci: TClientItem);
procedure MoveDealItemToBag;
procedure AddDealRemoteItem (ci: TClientItem);
procedure DelDealRemoteItem (ci: TClientItem);
function  GetDistance (sx, sy, dx, dy: integer): integer;
procedure GetNextPosXY (dir: byte; var x, y:Integer);
function GetNextPosCanXY (var dir: byte; x, y: Integer):Boolean;
procedure GetNextRunXY (dir: byte; var x, y:Integer);
procedure GetNextHorseRunXY (dir: byte; var x, y:Integer);
function  GetNextDirection (sx, sy, dx, dy: Integer): byte;
function  GetBack (dir: integer): integer;
procedure GetBackPosition (sx, sy, dir: integer; var newx, newy: integer);
procedure GetFrontPosition (sx, sy, dir: integer; var newx, newy: integer);
function  GetFlyDirection (sx, sy, ttx, tty: integer): Integer;
function  GetFlyDirection16 (sx, sy, ttx, tty: integer): Integer;
function  PrivDir (ndir: integer): integer;
function  NextDir (ndir: integer): integer;
function  GetTakeOnPosition (smode: integer): integer;
function  IsKeyPressed (key: byte): Boolean;
procedure AddChangeFace (recogid: integer);
procedure DelChangeFace (recogid: integer);
function  IsChangingFace (recogid: integer): Boolean;
function  GetTipsStr():string;
function  GetMagicIcon (Effect, Level: Byte; Id: Word; LevelEx: Byte; var Icon: Integer): TAspWMImages;
function GetHeroJobStr(btJob: Byte): string;

{$IF M2Version = 1}
function GetBatterMagicIcon(Effect: Byte): Integer;
{$IFEND}

{$IF M2Version <> 2}
function GetAAppendItemValue(Value : Byte): string;
function GetAppendItemValue(cu: TClientItem): string;
function GetSecretItemValue(cu: TClientItem): string;
function CheckItemSpiritMedia(cu: TClientItem): Boolean;
function GetHeroSkillMemoAddHp(level: Integer):Integer;
function FindHeroItemArrItemName(btType: Byte; flag: Boolean): Integer; overload;
function FindHeroItemArrItemName(sItemName: string): Integer; overload;
function FindHeroItemArrBindItemName(btType: Byte; flag: Boolean): Integer; overload;
function FindHeroItemArrBindItemName(sItemName: string): Integer; overload;
function HeroBagItemCount: Integer;
{$IFEND}
function boISAngerMagic(MagicID: Word): Boolean; //�Ƿ�Ϊŭ֮����

function FindItemArrItemName(btType: Byte; flag: Boolean): Integer; overload;
function FindItemArrItemName(sItemName: string): Integer; overload;
function FindItemArrBindItemName(btType: Byte; flag: Boolean): Integer; overload;
function FindItemArrBindItemName(sItemName: string): Integer; overload;
function BagItemCount: Integer;

function GetMagicEffLevelEx(MagicID: Word): Byte; // Copy on 2011.11.18
function GetXinFaMagicByID(Id: Byte): Boolean;    // Copy
function GetItemEffectWil(idx: Byte): TAspWMImages;  // Copy



implementation

uses clMain, MShare;

function GetItemEffectWil(idx: Byte): TAspWMImages;
begin
  case idx of
    0: Result := g_WMainImages;
    1: Result := g_WMain2Images;
    2: Result := g_WMain3Images;
    3: Result := g_WUI1Images;
    4: Result := g_WEffectImages;
    5: Result := g_WStateEffectImages;
    6: Result := g_WHumWingImages;
    7: Result := g_WHumWing2Images;
    8: Result := g_WStateItemImages;
    9: Result := g_WStateItem2Images;
    else Result := nil;
  end;
end;

function GetXinFaMagicByID(Id: Byte): Boolean;
{$IF M2Version <> 2}
var
  i: integer;
  pm: PTClientMagic;
{$IFEND}
begin
{$IF M2Version <> 2}
  Result := False;
  if g_XinFaMagic.Count > 0 then //20080629
  for i:=0 to g_XinFaMagic.Count-1 do begin
    pm := PTClientMagic (g_XinFaMagic[i]);
    if pm.Def.wMagicId = Id then begin
       Result := True;
       break;
    end;
  end;
{$IFEND}
end;

function GetMagicEffLevelEx(MagicID: Word): Byte;
var
  I: Integer;
  pcm: PTClientMagic;
begin
  Result := 0;
  for I:=0 to g_MagicList.Count - 1 do begin
    pcm := PTClientMagic(g_MagicList[I]);
    if pcm <> nil then begin
      if pcm.Def.wMagicId = MagicID then begin
        Result := pcm.btLevelEx;
        Break;
      end;
    end;
  end;
end;

function BagItemCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to MAXBAGITEMCL-1 do begin
    if g_ItemArr[I].Item.s.Name <> '' then Inc(Result);
  end;
end;
//btType 1 hp 2 mp 3����ҩƷ   flag: TrueΪ��Ч False ����Ч
function FindItemArrItemName(btType: Byte; flag: Boolean): Integer;
var
  I: integer;
begin
  try
    Result := -1;
    for I := MAXBAGITEMCL - 1 downto 0 do begin
      if (g_ItemArr[I].Item.S.Name <> '') and
         ((g_ItemArr[I].Item.S.StdMode = 0) or
         ((g_ItemArr[I].Item.S.StdMode = 17) and (g_ItemArr[I].Item.S.Shape = 237))) and
         (flag and (Pos('��Ч',g_ItemArr[I].Item.S.Name) > 0) or
         (not flag and (Pos('��Ч',g_ItemArr[I].Item.S.Name) = 0))) then begin
        case btType of
          1: begin
            if g_ItemArr[I].Item.S.AC > 0 then begin
              case g_ItemArr[I].Item.S.StdMode of
                0: begin
                  if g_ItemArr[I].Item.S.Shape = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_ItemArr[I].Item.S.AniCount = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
          2: begin
            if g_ItemArr[I].Item.S.MAC > 0 then begin
              case g_ItemArr[I].Item.S.StdMode of
                0: begin
                  if g_ItemArr[I].Item.S.Shape = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_ItemArr[I].Item.S.AniCount = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
          3: begin
            if g_ItemArr[I].Item.S.AC > 0 then begin
              case g_ItemArr[I].Item.S.StdMode of
                0: begin
                  if g_ItemArr[I].Item.S.Shape = 1 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_ItemArr[I].Item.S.AniCount = 1 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    DebugOutStr('[Exception] FindItemArrItemName1'); 
  end;
end;

function FindItemArrItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I:=0 to MAXBAGITEMCL-1 do begin
    if g_ItemArr[I].Item.s.Name <> '' then begin
      if g_ItemArr[I].Item.s.Name = sItemName then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

//btType 1 hp 2 mp 3����ҩƷ   flag: TrueΪ��Ч False ����Ч
function FindItemArrBindItemName(btType: Byte; flag: Boolean): Integer;
var
  I: Integer;
begin
  try
    Result := -1;
    for I := MAXBAGITEMCL - 1 downto 0 do begin
      if (g_ItemArr[I].Item.S.Name <> '') and
        (g_ItemArr[I].Item.S.StdMode = 31) and
        ((flag and (Pos('��Ч',g_ItemArr[I].Item.S.Name) > 0)) or
        (not flag and (Pos('��Ч',g_ItemArr[I].Item.S.Name) = 0))) and
        (g_ItemArr[I].Item.S.AniCount = btType) then
      begin
        Result := I;
        break;
      end;
    end;
  except
    DebugOutStr('[Exception] FindItemArrBindItemName1');
  end;
end;
function FindItemArrBindItemName(sItemName: string): Integer;
  function FindBindList(s: string): Integer;
  var
    I: Integer;
    pcm: pTUnbindInfo;
  begin
    Result := -1;
    if g_UnBindList.Count > 0 then begin
      for I:=0 to g_UnBindList.Count -1 do begin
        pcm := pTUnbindInfo (g_UnBindList[i]);
        if s = pcm.sItemName then begin
          Result := pcm.nUnbindCode;   //�ҵ�����ļ���Shapeֵ
          Break;
        end;
      end;
    end;
  end;
var
  I: Integer;
  nIndex: Integer;
begin
  Result := -1;
  nIndex := FindBindList(sItemName);
  if nIndex >= 0 then begin
    for I := MAXBAGITEMCL - 1 downto 0 do begin
      if (g_ItemArr[I].Item.S.Name <> '') and
        (g_ItemArr[I].Item.S.StdMode = 31) and
        (g_ItemArr[I].Item.S.Shape = nIndex) then
      begin
        Result := I;
        break;
      end;
    end;
  end;
end;
{$IF M2Version <> 2}
function HeroBagItemCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to g_HeroBagCount-1 do begin
    if g_HeroItemArr[I].s.Name <> '' then Inc(Result);
  end;
end;
//btType 1 hp 2 mp 3����ҩƷ   flag: TrueΪ��Ч False ����Ч
function FindHeroItemArrItemName(btType: Byte; flag: Boolean): Integer;
var
  I: integer;
begin
  try
    Result := -1;
    for I := g_HeroBagCount - 1 downto 0 do begin
      if (g_HeroItemArr[I].S.Name <> '') and
         ((g_HeroItemArr[I].S.StdMode = 0) or
         ((g_HeroItemArr[I].S.StdMode = 17) and (g_HeroItemArr[I].S.Shape = 237))) and
         (flag and (Pos('��Ч',g_HeroItemArr[I].S.Name) > 0) or
         (not flag and (Pos('��Ч',g_HeroItemArr[I].S.Name) = 0))) then begin
        case btType of
          1: begin
            if g_HeroItemArr[I].S.AC > 0 then begin
              case g_HeroItemArr[I].S.StdMode of
                0: begin
                  if g_HeroItemArr[I].S.Shape = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_HeroItemArr[I].S.AniCount = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
          2: begin
            if g_HeroItemArr[I].S.MAC > 0 then begin
              case g_HeroItemArr[I].S.StdMode of
                0: begin
                  if g_HeroItemArr[I].S.Shape = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_HeroItemArr[I].S.AniCount = 0 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
          3: begin
            if g_HeroItemArr[I].S.AC > 0 then begin
              case g_HeroItemArr[I].S.StdMode of
                0: begin
                  if g_HeroItemArr[I].S.Shape = 1 then begin
                    Result := I;
                    break;
                  end;
                end;
                17: begin
                  if g_HeroItemArr[I].S.AniCount = 1 then begin
                    Result := I;
                    break;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    DebugOutStr('[Exception] FindHeroItemArrItemName1'); 
  end;
end;

function FindHeroItemArrItemName(sItemName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I:=0 to g_HeroBagCount-1 do begin
    if g_HeroItemArr[I].s.Name <> '' then begin
      if g_HeroItemArr[I].s.Name = sItemName then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

function FindHeroItemArrBindItemName(btType: Byte; flag: Boolean): Integer;
var
  I: Integer;
begin
  try
    Result := -1;
    for I := g_HeroBagCount - 1 downto 0 do begin
      if (g_HeroItemArr[I].S.Name <> '') and
        (g_HeroItemArr[I].S.StdMode = 31) and
        ((flag and (Pos('��Ч',g_HeroItemArr[I].S.Name) > 0)) or
        (not flag and (Pos('��Ч',g_HeroItemArr[I].S.Name) = 0))) and
        (g_HeroItemArr[I].S.AniCount = btType) then
      begin
        Result := I;
        break;
      end;
    end;
  except
    DebugOutStr('[Exception] FindHeroItemArrBindItemName1');
  end;
end;

function FindHeroItemArrBindItemName(sItemName: string): Integer;
  function FindBindList(s: string): Integer;
  var
    I: Integer;
    pcm: pTUnbindInfo;
  begin
    Result := -1;
    if g_UnBindList.Count > 0 then begin
      for I:=0 to g_UnBindList.Count -1 do begin
        pcm := pTUnbindInfo (g_UnBindList[i]);
        if s = pcm.sItemName then begin
          Result := pcm.nUnbindCode;   //�ҵ�����ļ���Shapeֵ
          Break;
        end;
      end;
    end;
  end;
var
  I: Integer;
  nIndex: Integer;
begin
  Result := -1;
  nIndex := FindBindList(sItemName);
  if nIndex >= 0 then begin
    for I := g_HeroBagCount - 1 downto 0 do begin
      if (g_HeroItemArr[I].S.Name <> '') and
        (g_HeroItemArr[I].S.StdMode = 31) and
        (g_HeroItemArr[I].S.Shape = nIndex) then
      begin
        Result := I;
        break;
      end;
    end;
  end;
end;

function GetHeroSkillMemoAddHp(level: Integer):Integer;
begin
  if g_HeroSelf <> nil then begin
    case g_HeroSelf.m_btJob of//��ְҵ����HP����
      0: Result := Round(142 +(((level-1)/2)*level+1) -((level/2)*(level+1)+1));//ս
      1: begin
        if level < 10 then
          Result := Round(41 +(((level-1)/2)*level+1)-((level/2)*(level+1)+1))//��
        else Result := 23;
      end;
      2: Result := Round(109 +(((level-1)/2)*level+1) -((level/2)*(level+1)+1));//��
    end;
  end;
end;
//�����Ʒ�Ƿ�Ϊ��ý��Ʒ
function CheckItemSpiritMedia(cu: TClientItem): Boolean;
begin
  Result := (cu.btAppraisalValue[2] in [231..250]) or (cu.btAppraisalValue[3] in [231..250]) or
            (cu.btAppraisalValue[4] in [231..250]) or (cu.btAppraisalValue[5] in [231..250]) or
            (cu.btUnKnowValue[6] in [231..250]) or (cu.btUnKnowValue[7] in [231..250]) or
            (cu.btUnKnowValue[8] in [231..250]) or (cu.btUnKnowValue[9] in [231..250]);
end;

function GetAAppendItemValue(Value : Byte): string;
begin
  Result := '';
  case Value of
    11..20:   Result := Format(' �������� +%d',[Value-10]);
    21..30:   Result := Format(' ħ������ +%d',[Value-20]);
    31..40:   Result := Format(' �������� +%d',[Value-30]);
    41..50:   Result := Format(' ħ������ +%d',[Value-40]);
    51..60:   Result := Format(' ������� +%d',[Value-50]);
    61..70:   Result := Format(' ������   +%d',[Value-60]);
    71..80:   Result := Format(' �����ָ� +%d',[Value-70]);
    81..90:   Result := Format(' ��ħ�ȼ� +%d',[Value-80]);
    91..100:  Result := Format(' ǿ��ȼ� +%d',[Value-90]);
    101..110: Result := Format(' ��Ѫ���� +%d',[Value-100]);
    111..120: Result := Format(' ���˵ȼ� +%d',[Value-110]);
    121..130: Result := Format(' �����ȼ� +%d',[Value-120]);
    131..140: Result := Format(' ����     +%d',[Value-130]);
    141..150: Result := Format(' ׼ȷ     +%d',[Value-140]);
    151..160: Result := Format(' ����     +%d',[Value-150]);
    161..180: Result := Format(' ��Կ��� +%d',[Value-160]);
    181..230: Result := Format(' �ϻ����� +%d',[Value-180]);
  end;
end;

function GetAppendItemValue(cu: TClientItem): string;
var
  LingMeiLines: string;
  I,  nCount: Integer;
begin
  Result := '';
  LingMeiLines := '';
  if cu.btAppraisalValue[2] > 0 then begin
    case cu.btAppraisalValue[2] of
      231..250: begin
        if cu.Aura > 0 then begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (cu.btAppraisalValue[2]-230){ֵ}) , cu.Aura, cu.MaxAura]);
        end else begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (cu.btAppraisalValue[2]-230){ֵ}) , 0, cu.MaxAura]);
        end;
      end
      else Result := GetAAppendItemValue(cu.btAppraisalValue[2]);
    end;
  end;
  for I := 3 to 5 do begin
    nCount := cu.btAppraisalValue[I];
    if nCount > 0 then begin
      case nCount of
        11..20:   Result := Format('%s\ �������� +%d',[Result, nCount-10]);
        21..30:   Result := Format('%s\ ħ������ +%d',[Result, nCount-20]);
        31..40:   Result := Format('%s\ �������� +%d',[Result, nCount-30]);
        41..50:   Result := Format('%s\ ħ������ +%d',[Result, nCount-40]);
        51..60:   Result := Format('%s\ ������� +%d',[Result, nCount-50]);
        61..70:   Result := Format('%s\ ������   +%d',[Result, nCount-60]);
        71..80:   Result := Format('%s\ �����ָ� +%d',[Result, nCount-70]);
        81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, nCount-80]);
        91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, nCount-90]);
        101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, nCount-100]);
        111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, nCount-110]);
        121..130: Result := Format('%s\ �����ȼ� +%d',[Result, nCount-120]);
        131..140: Result := Format('%s\ ����     +%d',[Result, nCount-130]);
        141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, nCount-140]);
        151..160: Result := Format('%s\ ����     +%d',[Result, nCount-150]);
        161..180: Result := Format('%s\ ��Կ��� +%d',[Result, nCount-160]);
        181..230: Result := Format('%s\ �ϻ����� +%d',[Result, nCount-180]);
        231..250: begin
          if cu.Aura > 0 then begin
            LingMeiLines := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (nCount-230){ֵ}) , cu.Aura, cu.MaxAura]);
          end else begin
            LingMeiLines := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (nCount-230){ֵ}) , 0, cu.MaxAura]);
          end;
        end;
      end;
    end;
  end;

(*

  if cu.btUnKnowValue[3] > 0 then begin
    case cu.btUnKnowValue[3] of
      11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[3]-10]);
      21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[3]-20]);
      31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[3]-30]);
      41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[3]-40]);
      51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[3]-50]);
      61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[3]-60]);
      71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[3]-70]);
      81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[3]-80]);
      91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[3]-90]);
      101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[3]-100]);
      111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[3]-110]);
      121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[3]-120]);
      131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[3]-130]);
      141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[3]-140]);
      151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[3]-150]);
      161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[3]-160]);
      181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[3]-180]);
      231..250: begin
        if cu.Aura > 0 then begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (cu.btUnKnowValue[3]-230){ֵ}) , cu.Aura, cu.MaxAura]);
        end else begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (cu.btUnKnowValue[3]-230){ֵ}) , 0, cu.MaxAura]);
        end;
      end;
    end;
  end;
  if cu.btUnKnowValue[4] > 0 then begin
    case cu.btUnKnowValue[4] of
      11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[4]-10]);
      21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[4]-20]);
      31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[4]-30]);
      41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[4]-40]);
      51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[4]-50]);
      61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[4]-60]);
      71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[4]-70]);
      81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[4]-80]);
      91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[4]-90]);
      101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[4]-100]);
      111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[4]-110]);
      121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[4]-120]);
      131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[4]-130]);
      141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[4]-140]);
      151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[4]-150]);
      161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[4]-160]);
      181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[4]-180]);
      231..250: begin
        if cu.Aura > 0 then begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (cu.btUnKnowValue[4]-230){ֵ}) , cu.Aura, cu.MaxAura]);
        end else begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (cu.btUnKnowValue[4]-230){ֵ}) , 0, cu.MaxAura]);
        end;
      end;
    end;
  end;
  if cu.btUnKnowValue[5] > 0 then begin
    case cu.btUnKnowValue[5] of
      11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[5]-10]);
      21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[5]-20]);
      31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[5]-30]);
      41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[5]-40]);
      51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[5]-50]);
      61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[5]-60]);
      71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[5]-70]);
      81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[5]-80]);
      91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[5]-90]);
      101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[5]-100]);
      111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[5]-110]);
      121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[5]-120]);
      131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[5]-130]);
      141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[5]-140]);
      151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[5]-150]);
      161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[5]-160]);
      181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[5]-180]);
      231..250: begin
        if cu.Aura > 0 then begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (cu.btUnKnowValue[5]-230){ֵ}) , cu.Aura, cu.MaxAura]);
        end else begin
          LingMeiLines := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (cu.btUnKnowValue[5]-230){ֵ}) , 0, cu.MaxAura]);
        end;
      end;
    end;
  end;
*)
  if (Result <> '') or (LingMeiLines <> '') then begin
      Result := ' \<���ӻ�������/c=Yellow>\'+Result + LingMeiLines;
  end;
end;

function GetSecretItemValue(cu: TClientItem): string;
var
  btNum: Byte;
begin
  Result := '';
  if (cu.btUnKnowValueCount > 0) and (cu.btUnKnowValueCount < 5) then begin
    btNum := 0;
    if cu.btUnKnowValue[6] > 0 then begin
      case cu.btUnKnowValue[6] of
        1..10: begin
          case cu.btUnKnowValue[6] of
            1: Result := ' <��������/c=Lime>\';
            2: Result := ' <���Ի�����/c=Lime>\';
            3: Result := ' <�����/c=Lime>\';
            4: Result := ' <ħ����Լ���/c=Lime>\';
            5: Result := ' <ս����Լ���/c=Lime>\';
            6: Result := ' <̽�⼼��/c=Lime>\';
            7: Result := ' <���ͼ���/c=Lime>\';
          end;
        end;
        11..20:   Result := Format(' �������� +%d',[cu.btUnKnowValue[6]-10]);
        21..30:   Result := Format(' ħ������ +%d',[cu.btUnKnowValue[6]-20]);
        31..40:   Result := Format(' �������� +%d',[cu.btUnKnowValue[6]-30]);
        41..50:   Result := Format(' ħ������ +%d',[cu.btUnKnowValue[6]-40]);
        51..60:   Result := Format(' ������� +%d',[cu.btUnKnowValue[6]-50]);
        61..70:   Result := Format(' ������   +%d',[cu.btUnKnowValue[6]-60]);
        71..80:   Result := Format(' �����ָ� +%d',[cu.btUnKnowValue[6]-70]);
        81..90:   Result := Format(' ��ħ�ȼ� +%d',[cu.btUnKnowValue[6]-80]);
        91..100:  Result := Format(' ǿ��ȼ� +%d',[cu.btUnKnowValue[6]-90]);
        101..110: Result := Format(' ��Ѫ���� +%d',[cu.btUnKnowValue[6]-100]);
        111..120: Result := Format(' ���˵ȼ� +%d',[cu.btUnKnowValue[6]-110]);
        121..130: Result := Format(' �����ȼ� +%d',[cu.btUnKnowValue[6]-120]);
        131..140: Result := Format(' ����     +%d',[cu.btUnKnowValue[6]-130]);
        141..150: Result := Format(' ׼ȷ     +%d',[cu.btUnKnowValue[6]-140]);
        151..160: Result := Format(' ����     +%d',[cu.btUnKnowValue[6]-150]);
        161..180: Result := Format(' ��Կ��� +%d',[cu.btUnKnowValue[6]-160]);
        181..230: Result := Format(' �ϻ����� +%d',[cu.btUnKnowValue[6]-180]);
        231..250: begin
          if cu.Aura > 0 then begin
            Result := Format('\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Round(11.4 * (cu.btUnKnowValue[6]-230){ֵ}) , cu.Aura, cu.MaxAura]);
          end else begin
            Result := Format('\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Round(11.4 * (cu.btUnKnowValue[6]-230){ֵ}) , 0, cu.MaxAura]);
          end;
        end;
        255: Result := '<��������(�����)/c=Red>\';      
      end;
    end;
    if cu.btUnKnowValue[7] > 0 then begin
      case cu.btUnKnowValue[7] of
        1..10: begin
          case cu.btUnKnowValue[7] of
            1: Result := Format('%s\ <��������/c=Lime>\', [Result]);
            2: Result := Format('%s\ <���Ի�����/c=Lime>\', [Result]);
            3: Result := Format('%s\ <�����/c=Lime>\', [Result]);
            4: Result := Format('%s\ <ħ����Լ���/c=Lime>\', [Result]);
            5: Result := Format('%s\ <ս����Լ���/c=Lime>\', [Result]);
            6: Result := Format('%s\ <̽�⼼��/c=Lime>\', [Result]);
            7: Result := Format('%s\ <���ͼ���/c=Lime>\', [Result]);
          end;
        end;
        11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[7]-10]);
        21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[7]-20]);
        31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[7]-30]);
        41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[7]-40]);
        51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[7]-50]);
        61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[7]-60]);
        71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[7]-70]);
        81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[7]-80]);
        91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[7]-90]);
        101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[7]-100]);
        111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[7]-110]);
        121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[7]-120]);
        131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[7]-130]);
        141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[7]-140]);
        151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[7]-150]);
        161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[7]-160]);
        181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[7]-180]);
        231..250: begin
          if cu.Aura > 0 then begin
            Result := Format('%s\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Result, Round(11.4 * (cu.btUnKnowValue[7]-230){ֵ}) , cu.Aura, cu.MaxAura]);
          end else begin
            Result := Format('%s\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Result, Round(11.4 * (cu.btUnKnowValue[7]-230){ֵ}) , 0, cu.MaxAura]);
          end;
        end;
        255: Result := Result + '\' + '<��������(�����)/c=Red>\';
      end;
    end;
    if cu.btUnKnowValue[8] > 0 then begin
      case cu.btUnKnowValue[8] of
        1..10: begin
          case cu.btUnKnowValue[8] of
            1: Result := Format('%s\ <��������/c=Lime>\', [Result]);
            2: Result := Format('%s\ <���Ի�����/c=Lime>\', [Result]);
            3: Result := Format('%s\ <�����/c=Lime>\', [Result]);
            4: Result := Format('%s\ <ħ����Լ���/c=Lime>\', [Result]);
            5: Result := Format('%s\ <ս����Լ���/c=Lime>\', [Result]);
            6: Result := Format('%s\ <̽�⼼��/c=Lime>\', [Result]);
            7: Result := Format('%s\ <���ͼ���/c=Lime>\', [Result]);
          end;
        end;
        11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[8]-10]);
        21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[8]-20]);
        31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[8]-30]);
        41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[8]-40]);
        51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[8]-50]);
        61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[8]-60]);
        71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[8]-70]);
        81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[8]-80]);
        91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[8]-90]);
        101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[8]-100]);
        111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[8]-110]);
        121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[8]-120]);
        131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[8]-130]);
        141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[8]-140]);
        151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[8]-150]);
        161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[8]-160]);
        181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[8]-180]);
        231..250: begin
          if cu.Aura > 0 then begin
            Result := Format('%s\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Result, Round(11.4 * (cu.btUnKnowValue[8]-230){ֵ}) , cu.Aura, cu.MaxAura]);
          end else begin
            Result := Format('%s\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Result, Round(11.4 * (cu.btUnKnowValue[8]-230){ֵ}) , 0, cu.MaxAura]);
          end;
        end;
        255: Result := Result + '\' + '<��������(�����)/c=Red>\';
      end;
    end;
    if cu.btUnKnowValue[9] > 0 then begin
      case cu.btUnKnowValue[9] of
        1..10: begin
          case cu.btUnKnowValue[9] of
            1: Result := Format('%s\ <��������/c=Lime>\', [Result]);
            2: Result := Format('%s\ <���Ի�����/c=Lime>\', [Result]);
            3: Result := Format('%s\ <�����/c=Lime>\', [Result]);
            4: Result := Format('%s\ <ħ����Լ���/c=Lime>\', [Result]);
            5: Result := Format('%s\ <ս����Լ���/c=Lime>\', [Result]);
            6: Result := Format('%s\ <̽�⼼��/c=Lime>\', [Result]);
            7: Result := Format('%s\ <���ͼ���/c=Lime>\', [Result]);
          end;
        end;
        11..20:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[9]-10]);
        21..30:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[9]-20]);
        31..40:   Result := Format('%s\ �������� +%d',[Result, cu.btUnKnowValue[9]-30]);
        41..50:   Result := Format('%s\ ħ������ +%d',[Result, cu.btUnKnowValue[9]-40]);
        51..60:   Result := Format('%s\ ������� +%d',[Result, cu.btUnKnowValue[9]-50]);
        61..70:   Result := Format('%s\ ������   +%d',[Result, cu.btUnKnowValue[9]-60]);
        71..80:   Result := Format('%s\ �����ָ� +%d',[Result, cu.btUnKnowValue[9]-70]);
        81..90:   Result := Format('%s\ ��ħ�ȼ� +%d',[Result, cu.btUnKnowValue[9]-80]);
        91..100:  Result := Format('%s\ ǿ��ȼ� +%d',[Result, cu.btUnKnowValue[9]-90]);
        101..110: Result := Format('%s\ ��Ѫ���� +%d',[Result, cu.btUnKnowValue[9]-100]);
        111..120: Result := Format('%s\ ���˵ȼ� +%d',[Result, cu.btUnKnowValue[9]-110]);
        121..130: Result := Format('%s\ �����ȼ� +%d',[Result, cu.btUnKnowValue[9]-120]);
        131..140: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[9]-130]);
        141..150: Result := Format('%s\ ׼ȷ     +%d',[Result, cu.btUnKnowValue[9]-140]);
        151..160: Result := Format('%s\ ����     +%d',[Result, cu.btUnKnowValue[9]-150]);
        161..180: Result := Format('%s\ ��Կ��� +%d',[Result, cu.btUnKnowValue[9]-160]);
        181..230: Result := Format('%s\ �ϻ����� +%d',[Result, cu.btUnKnowValue[9]-180]);
        231..250: begin
          if cu.Aura > 0 then begin
            Result := Format('%s\ \<������ý Ʒ��%d ����ֵ%d/%d/c=Yellow>', [Result, Round(11.4 * (cu.btUnKnowValue[9]-230){ֵ}) , cu.Aura, cu.MaxAura]);
          end else begin
            Result := Format('%s\ \<������ý Ʒ��%d/c=Yellow> <����ֵ%d/%d/c=Red>', [Result, Round(11.4 * (cu.btUnKnowValue[9]-230){ֵ}) , 0, cu.MaxAura]);
          end;
        end; 
        255: Result := Result + '\' + '<��������(�����)/c=Red>\';
      end;
    end;
    if Result <> '' then begin
      if (cu.btUnKnowValue[6] > 0) and (cu.btUnKnowValue[6] < 255) then Inc(btNum);
      if (cu.btUnKnowValue[7] > 0) and (cu.btUnKnowValue[7] < 255) then Inc(btNum);
      if (cu.btUnKnowValue[8] > 0) and (cu.btUnKnowValue[8] < 255) then Inc(btNum);
      if (cu.btUnKnowValue[9] > 0) and (cu.btUnKnowValue[9] < 255) then Inc(btNum);
      Result := Format(' \<������������(%d/%d)/c=Yellow>\', [btNum, cu.btUnKnowValueCount]) + Result;
    end;
  end;
end;
{$IFEND}

//�Ƿ�Ϊŭ֮����
function boISAngerMagic(MagicID: Word): Boolean;
begin
  Result := MagicID in [200,202,204,206,208,210,212,214,216,218,220,222,224,226,228,230,232,234,236,239,241];
end;

function GetMagicIcon (Effect, Level: Byte; Id: Word; LevelEx: Byte; var Icon: Integer): TAspWMImages;
begin
  Result := nil;
  if LevelEx in [1..9] then begin //ǿ��
    case Effect of
      56: begin//Բ���䵶
        Icon := 420;
      end;
      13, 54: begin//��ɱ
        Icon := 430;
      end;
      5: begin//��ɱ
        Icon := 440;
      end;
      24: begin //�һ𽣷�
        Icon := 460;
      end;
      53: begin //���ս���
        Icon := 470;
      end;
      10, 100: begin//���,4�����
        Icon := 490;
      end;
      12: begin//��ʥս����
        Icon := 510;
      end;
      4, 77: begin //ʩ����,4��ʩ����
        Icon := 520;
      end;
      48, 74: begin//��Ѫ��,4����Ѫ��
        Icon := 530;
      end;
      11: begin//�����
        Icon := 540;
      end;
      15: begin//�ٻ�����
        Icon := 550;
      end;
      76: begin//�ٻ�ʥ��
        Icon := 560;
      end;
      21: begin//���ѻ���
        Icon := 580;
      end;
      31: begin //������
        Icon := 590;
      end;
      20: begin //��ǽ
        Icon := 600;
      end;
      8: begin //�����Ӱ
        Icon := 610;
      end;
      9, 75: begin//�׵���,4���׵�
        Icon := 630;
      end;
      51, 80: begin//���ǻ���,4�����ǻ���
        Icon := 640;
      end;
      34, 101: begin//�����,4�������
        Icon := 650;
      end;
    end;
    Icon := Icon + _MIN(3, (LevelEx-1) div 2) * 2;
    Result := g_WMagIconImages;
  end else begin
    case Effect of
      0: begin
        if Id = 88 then icon := 146    //4����������
        else icon := Effect * 2;
      end;
      10, 100: begin
        if Level = 4 then icon := 140  //4�����
        else icon := Effect * 2;
      end;
      //17: icon := 444; //4����ɱ����
      //23: icon := 420; //Բ���䵶
      24: begin
        if Level = 4 then icon := 142  //4���һ�ͼ��
        else icon := Effect * 2;
      end;
      34,101,123,122: begin
        if Level = 4 then icon := 144  //4�������ͼ��
        else icon := Effect * 2;
      end;
      54: icon := 444; //4����ɱ����
      56: icon := 420; //Բ���䵶
      74: icon := 148; //��Ѫ��
      75: icon := 456; //4���׵���
      76: icon := 160; //�ٻ�ʥ��
      77: icon := 474; //ʩ����
      80: icon := 160; //���ǻ���
      81: Icon := 170; //Ѫ��һ��(ս)
      82: Icon := 172; //Ѫ��һ��(��)
      83: Icon := 174; //Ѫ��һ��(��)
      91: icon := 0;//�������ħ������ͼ��  20080229
      92: Icon := 761; //ǿ����
      95: ICon := 767; //���ؽ��
      96: Icon := 170; //��������
      97: Icon := 172; //Ψ�Ҷ���
      98: Icon := 530; //�ٻ���ħ
      102:icon := 952;//����ɱ
      103:icon := 944;//˫����
      104:icon := 934;//��Х��
      105:icon := 950;//׷�Ĵ�
      106:icon := 942;//�����
      107:icon := 936;//������
      108:icon := 956;//����ն
      109:icon := 946;//���ױ�
      110:icon := 932;//������
      111:icon := 954;//��ɨǧ��
      112:icon := 940;//����ѩ��
      113:icon := 930;//�򽣹���
      114:Icon := 960;//��ת����
      {$IF M2Version <> 2}
      129:Icon := 580;//�����ķ��������ķ�
      130: Icon := 590; //��˪ѩ��
      131: Icon := 594;// �ݺὣ��
      132: Icon := 592;// �����
      133: Icon := 586;//����֮��
      134: Icon := 582;//��˪Ⱥ��
      135: Icon := 610; //ŭ�ɻ���
      136: Icon := 612;//��������
      137: Icon := 584;//ʮ��һɱ
      {$IFEND}
    else icon := Effect * 2;
    end;
    case Effect of
      54,56,75,77,80..83,96..98, 129..137: Result := g_WMagIcon2Images; //4����ɱ����
      92,95: Result := g_WUI1Images;
      102..114: Result := g_WMainImages;
    else Result := g_WMagIconImages;
    end;
  end;
end;

{begin
  Result := nil;
  case Effect of
    0: begin
      if Id = 88 then icon := 146    //4����������
      else icon := Effect * 2;
    end;
    10, 100: begin
      if Level = 4 then icon := 140  //4�����
      else icon := Effect * 2;
    end;
    //17: icon := 444; //4����ɱ����
    //23: icon := 420; //Բ���䵶
    24: begin
      if Level = 4 then icon := 142  //4���һ�ͼ��
      else icon := Effect * 2;
    end;
    34,101,123,122: begin
      if Level = 4 then icon := 144  //4�������ͼ��
      else icon := Effect * 2;
    end;
    54: icon := 444; //4����ɱ����
    56: icon := 420; //Բ���䵶
    74: icon := 148; //��Ѫ��
    75: icon := 456; //4���׵���
    76: icon := 160; //�ٻ�ʥ��
    77: icon := 474; //ʩ����
    80: icon := 160; //���ǻ���
    81: Icon := 170; //Ѫ��һ��(ս)
    82: Icon := 172; //Ѫ��һ��(��)
    83: Icon := 174; //Ѫ��һ��(��)
    91: icon := 0;//�������ħ������ͼ��  20080229
    92: Icon := 761; //ǿ����
    95: ICon := 767; //���ؽ��
    96: Icon := 170; //��������
    97: Icon := 172; //Ψ�Ҷ���
    98: Icon := 530; //�ٻ���ħ
    102:icon := 952;//����ɱ
    103:icon := 944;//˫����
    104:icon := 934;//��Х��
    105:icon := 950;//׷�Ĵ�
    106:icon := 942;//�����
    107:icon := 936;//������
    108:icon := 956;//����ն
    109:icon := 946;//���ױ�
    110:icon := 932;//������
    111:icon := 954;//��ɨǧ��
    112:icon := 940;//����ѩ��
    113:icon := 930;//�򽣹���
    114:Icon := 960;//��ת����
  else icon := Effect * 2;
  end;
  case Effect of
    54,56,75,77,80..83,96..98: Result := g_WMagIcon2Images; //4����ɱ����
    92,95: Result := g_WUI1Images;
    102..114: Result := g_WMainImages;
  else Result := g_WMagIconImages;
  end;
end;}

{$IF M2Version = 1}
function GetBatterMagicIcon(Effect: Byte): Integer;
begin
  case Effect of
    102: Result := 952;//����ɱ
    103: Result := 944;//˫����
    104: Result := 934;//��Х��
    105: Result := 950;//׷�Ĵ�
    106: Result := 942;//�����
    107: Result := 936;//������
    108: Result := 956;//����ն
    109: Result := 946;//���ױ�
    110: Result := 932;//������
    111: Result := 954;//��ɨǧ��
    112: Result := 940;//����ѩ��
    113: Result := 930;//�򽣹���
    else Result := -1;
  end;
end;
{$IFEND}

//��ʽ���ַ���Ϊָ�����ȣ�������ո�
function fmStr (str: string; len: integer): string;
var i: integer;
begin
try
   Result := str + ' ';
   for i:=1 to len - Length(str)-1 do
      Result := Result + ' ';
except
	Result := str + ' ';
end;
end;
//����ת��Ϊǧλ�����ŵ��ַ���������1234567ת��Ϊ��1,234,567��
//����������ʾ��Ǯ����
function  GetGoldStr (gold: integer): string;
var
   i, n: integer;
   str: string;
begin
   str := IntToStr (gold);
   n := 0;
   Result := '';
   for i:=Length(str) downto 1 do begin
      if n = 3 then begin
         Result := str[i] + ',' + Result;
         n := 1;
      end else begin
         Result := str[i] + Result;
         Inc(n);
      end;
   end;
end;
//����װ����Ʒ���ļ�
procedure SaveBags (flname: string; pbuf: Pbyte);
var
   fhandle: integer;
begin
   if FileExists (flname) then
      fhandle := FileOpen (flname, fmOpenWrite or fmShareDenyNone)
   else fhandle := FileCreate (flname);
   if fhandle > 0 then begin
      FileWrite (fhandle, pbuf^, sizeof(TItemArr) * MAXBAGITEMCL);
      FileClose (fhandle);
   end;
end;
//װ��װ����Ʒ
procedure Loadbags (flname: string; pbuf: Pbyte);
var
   fhandle: integer;
begin
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
         FileRead (fhandle, pbuf^, sizeof(TItemArr) * MAXBAGITEMCL);
         FileClose (fhandle);
      end;
   end;
end;
//�����Ʒ
procedure ClearBag;
var
   i: integer;
begin
   for i:=0 to MAXBAGITEMCL-1 do
      g_ItemArr[I].Item.S.Name := '';
end;
//���Ӱ�����Ʒ״̬Ϊ����
function AddItemBagLock(cu: TClientItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I:=0 to MAXBAGITEMCL-1 do begin
    if (g_ItemArr[I].Item.MakeIndex = cu.MakeIndex) and (g_ItemArr[I].Item.S.Name = cu.S.Name) then begin
       g_ItemArr[i].boLockItem := True;
       Result := True;
       Break;
    end;
  end;
end;
//ɾ��������Ʒ״̬Ϊ����
function DelItemBagLock(cu: TClientItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I:=0 to MAXBAGITEMCL-1 do begin
    if (g_ItemArr[I].Item.MakeIndex = cu.MakeIndex) and (g_ItemArr[I].Item.S.Name = cu.S.Name) then begin
       g_ItemArr[i].boLockItem := False;
       Result := True;
       Break;
    end;
  end;
end;
//�����Ʒ
function  AddItemBag (cu: TClientItem): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   //���Ҫ��ӵ���Ʒ�Ƿ��Ѿ�����
   for i:=0 to MAXBAGITEMCL-1 do begin
      if (g_ItemArr[I].Item.MakeIndex = cu.MakeIndex) and (g_ItemArr[I].Item.S.Name = cu.S.Name) then begin
         exit;
      end;
   end;

   if cu.S.Name = '' then exit;
   if (cu.S.StdMode <= 3) or ((cu.S.StdMode = 60) and (cu.S.Shape <> 0)) or ((cu.S.StdMode = 17) and (cu.S.Shape = 237)) then begin //����ʹ�õ���Ʒ,���ȷ��ڿ����Ʒ��
      if (cu.S.StdMode = 2) and (cu.S.Need = 1) then  //������������Ʒ 20080331
      
      else begin
        for i:=0 to 5 do
           if g_ItemArr[I].Item.S.Name = '' then begin     //��һ���յ�����
              g_ItemArr[I].Item := cu;
              Result := TRUE;
              Exit;
           end;
      end;
   end;
   for i:=6 to MAXBAGITEMCL-1 do begin
      if g_ItemArr[I].Item.S.Name = '' then begin
         g_ItemArr[I].Item := cu;
         Result := TRUE;
         break;
      end;
   end;
   ArrangeItembag;
end;

function  AddHeroItemBag (cu: TClientItem): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=0 to g_HeroBagCount-1 do begin
      if (g_HeroItemArr[I].MakeIndex = cu.MakeIndex) and (g_HeroItemArr[I].S.Name = cu.S.Name) then begin
         Exit;  
      end;
   end;

   if cu.S.Name = '' then exit;
   for i:=0 to MAXHEROBAGITEM{Ӣ�۰������������G��Ԫ��}-1 do begin
      if g_HeroItemArr[I].S.Name = '' then begin
         g_HeroItemArr[I] := cu;
         Result := TRUE;
         break;
      end;
   end;
   ArrangeHeroItembag;
end;
//�õ�ǰ����Ʒ��������Ѿ����ڵĸ���Ʒ����
function  HeroUpdateItemBag (cu: TClientItem): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=MAXBAGITEMCL-1 downto 0 do begin
      if (g_HeroItemArr[i].S.Name = cu.S.Name) and (g_HeroItemArr[i].MakeIndex = cu.MakeIndex) then begin
         g_HeroItemArr[i] := cu;  //������Ʈ
         Result := TRUE;
         break;
      end;
   end;
end;
//ɾ��ָ������Ʒ
function  DelHeroItemBag (iname: string; iindex: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=MAXBAGITEMCL-1 downto 0 do begin
      if (g_HeroItemArr[I].S.Name = iname) and (g_HeroItemArr[I].MakeIndex = iindex) then begin
         FillChar (g_HeroItemArr[I], sizeof(TClientItem), #0);
         Result := TRUE;
         break;
      end;
   end;
   ArrangeHeroItembag;
end;
//�õ�ǰ����Ʒ��������Ѿ����ڵĸ���Ʒ����
function  UpdateItemBag (cu: TClientItem): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=MAXBAGITEMCL-1 downto 0 do begin
      if (g_ItemArr[i].Item.S.Name = cu.S.Name) and (g_ItemArr[i].Item.MakeIndex = cu.MakeIndex) then begin
         g_ItemArr[i].Item := cu;  //������Ʈ
         Result := TRUE;
         break;
      end;
   end;
end;
//ɾ��ָ������Ʒ
function  DelItemBag (iname: string; iindex: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   for i:=MAXBAGITEMCL-1 downto 0 do begin
      if (g_ItemArr[I].Item.S.Name = iname) and (g_ItemArr[I].Item.MakeIndex = iindex) then begin
         FillChar (g_ItemArr[i], sizeof(TItemArr), #0);
         Result := TRUE;
         break;
      end;
   end;
   ArrangeItembag;
end;
//������Ʒ��
procedure ArrangeItemBag;
var
   i, k: integer;
begin
   //��������Ʒ
   for i:=0 to MAXBAGITEMCL-1 do begin
      if g_ItemArr[I].Item.S.Name <> '' then begin
         for k:=i+1 to MAXBAGITEMCL-1 do begin   //�����ͬ����Ʒ
            if (g_ItemArr[I].Item.S.Name = g_ItemArr[k].Item.S.Name) and (g_ItemArr[I].Item.MakeIndex = g_ItemArr[k].Item.MakeIndex) then begin
               FillChar (g_ItemArr[k], sizeof(TItemArr), #0);
            end;
         end;
         {for k:=0 to 9 do begin
            if (ItemArr[i].S.Name = DealItems[k].S.Name) and (ItemArr[i].MakeIndex = DealItems[k].MakeIndex) then begin
               FillChar (ItemArr[i], sizeof(TClientItem), #0);
               //FillChar (DealItems[k], sizeof(TClientItem), #0);
            end;
         end; }
         //�����ƶ�����Ʒ
         if (g_ItemArr[I].Item.S.Name = g_MovingItem.Item.S.Name) and (g_ItemArr[I].Item.MakeIndex = g_MovingItem.Item.MakeIndex) then begin
            g_MovingItem.Index := 0;
            g_MovingItem.Item.S.Name := '';
         end;
      end;
   end;

   //6�������Ʒ����Ʒ
   for i:=46 to MAXBAGITEMCL-1 do begin
      if g_ItemArr[I].Item.S.Name <> '' then begin
         for k:=6 to 45 do begin
            if g_ItemArr[k].Item.S.Name = '' then begin
               g_ItemArr[k].Item := g_ItemArr[I].Item;
               g_ItemArr[I].Item.S.Name := '';
               break;
            end;
         end;
      end;
   end; 
end;


//����Ӣ�۰� $017 2007.10.23
procedure ArrangeHeroItemBag;
var
   i, k: integer;
begin
   //��������Ʒ
   for i:=0 to MAXBAGITEMCL-1 do begin
      if g_HeroItemArr[I].S.Name <> '' then begin
         for k:=i+1 to MAXBAGITEMCL-1 do begin
            if (g_HeroItemArr[I].S.Name = g_HeroItemArr[k].S.Name) and (g_HeroItemArr[I].MakeIndex = g_HeroItemArr[k].MakeIndex) then begin
               FillChar (g_HeroItemArr[k], sizeof(TClientItem), #0);
            end;
         end;
         //�����ƶ�����Ʒ
         if (g_HeroItemArr[I].S.Name = g_MovingHeroItem.Item.S.Name) and (g_HeroItemArr[I].MakeIndex = g_MovingHeroItem.Item.MakeIndex) then begin
            g_MovingHeroItem.Index := 0;
            g_MovingHeroItem.Item.S.Name := '';
         end;
      end;
   end;

   {//6�������Ʒ����Ʒ
   for i:=46 to MAXBAGITEMCL-1 do begin
      if g_HeroItemArr[I].S.Name <> '' then begin
         for k:=6 to 45 do begin
            if g_HeroItemArr[k].S.Name = '' then begin
               g_HeroItemArr[k] := g_HeroItemArr[I];
               g_HeroItemArr[I].S.Name := '';
               break;
            end;
         end;
      end;
   end;  }
end;
{----------------------------------------------------------}
//��ӵ�����Ʒ
procedure AddDropItem (ci: TClientItem);
var
   pc: PTClientItem;
begin
   new (pc);
   pc^ := ci;
   DropItems.Add (pc);
end;
//��ȡ������Ʒ
function  GetDropItem (iname: string; MakeIndex: integer): PTClientItem;
var
   i: integer;
begin
   Result := nil;
   if DropItems.Count > 0 then //20080629
   for i:=0 to DropItems.Count-1 do begin
      if (PTClientItem(DropItems[i]).S.Name = iname) and (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then begin
         Result := PTClientItem(DropItems[i]);
         break;
      end;
   end;
end;
//ɾ��������Ʒ
procedure DelDropItem (iname: string; MakeIndex: integer);
var
   I: integer;
begin
   if DropItems.Count > 0 then //20080629
   for i:=0 to DropItems.Count-1 do begin
      if (PTClientItem(DropItems[i]).S.Name = iname) and (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then begin
         Dispose (PTClientItem(DropItems[i]));
         DropItems.Delete (i);
         break;
      end;
   end;
end;
{----------------------------------------------------------}
procedure AddShopItem (ci: TShopItem);
var
   i: integer;
begin
   for i:=0 to 10-1 do begin
      if g_ShopItems[i].Item.S.Name = '' then begin
         g_ShopItems[i] := ci;
         break;
      end;
   end;
end;
procedure DelShopItem (ci: TShopItem);
var
   i: integer;
begin
   for i:=0 to 10-1 do begin
      if (g_ShopItems[i].Item.S.Name = ci.Item.S.Name) and (g_ShopItems[i].Item.MakeIndex = ci.Item.MakeIndex) then begin
         FillChar (g_ShopItems[i], sizeof(TShopItem), #0);
         break;
      end;
   end;
end;

procedure DelUserShopItem (nItemidx:Integer;sItemName:string);
var
  I:integer;
begin
  try
    for I:=Low(g_UserShopItem) to High(g_UserShopItem) do begin
      if (g_UserShopItem[I].Item.MakeIndex=nItemidx) then begin
        g_UserShopItem[I].Item.S.Name:='';
        break;
      end;
    end;
  except
    DebugOutStr('[Exception] UnClFunc.DelUserShopItem');
  end;
end;

procedure DelShopItemEx(nItemidx:Integer);
var
  I:integer;
  sItemName: string;
begin
  try
    sItemName := '';
    for I:=Low(g_ShopItems) to High(g_ShopItems) do begin
      if (g_ShopItems[I].Item.MakeIndex=nItemidx) then begin
        sItemName := g_ShopItems[I].Item.S.Name;
        g_ShopItems[I].Item.S.Name:='';
        break;
      end;
    end;
    if sItemName <> '' then DelItemBag(sItemName, nItemidx);
  except
    DebugOutStr('[Exception] UnClFunc.DelShopItemEx');
  end;
end;

function GetShopItemRoom(): Boolean;
var
  I: Integer;
begin
  Result := False;
  for i:=0 to 9 do begin
    if g_ShopItems[i].Item.S.Name = '' then begin
       Result := True;
       break;
    end;
  end;
end;
{----------------------------------------------------------}

procedure AddDealItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 10-1 do begin
      if g_DealItems[i].S.Name = '' then begin
         g_DealItems[i] := ci;
         break;
      end;
   end;
end;

procedure DelDealItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 10-1 do begin
      if (g_DealItems[i].S.Name = ci.S.Name) and (g_DealItems[i].MakeIndex = ci.MakeIndex) then begin
         FillChar (g_DealItems[i], sizeof(TClientItem), #0);
         break;
      end;
   end;
end;
{******************************************************************************}
//��ս 20080705
procedure AddChallengeItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 3 do begin
      if g_ChallengeItems[i].S.Name = '' then begin
         g_ChallengeItems[i] := ci;
         break;
      end;
   end;
end;

procedure DelChallengeItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 3 do begin
      if (g_ChallengeItems[i].S.Name = ci.S.Name) and (g_ChallengeItems[i].MakeIndex = ci.MakeIndex) then begin
         FillChar (g_ChallengeItems[i], sizeof(TClientItem), #0);
         break;
      end;
   end;
end;

procedure MoveChallengeItemToBag;
var
   i: integer;
begin
   for i:=0 to 3 do begin
      if g_ChallengeItems[i].S.Name <> '' then
         AddItemBag (g_ChallengeItems[i]);
   end;
   FillChar (g_ChallengeItems, sizeof(TClientItem)*4, #0);
end;

procedure AddChallengeRemoteItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 3 do begin
      if g_ChallengeRemoteItems[i].S.Name = '' then begin
         g_ChallengeRemoteItems[i] := ci;
         break;
      end;
   end;
end;

procedure DelChallengeRemoteItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 3 do begin
      if (g_ChallengeRemoteItems[i].S.Name = ci.S.Name) and (g_ChallengeRemoteItems[i].MakeIndex = ci.MakeIndex) then begin
         FillChar (g_ChallengeRemoteItems[i], sizeof(TClientItem), #0);
         break;
      end;
   end;
end;

{******************************************************************************}
//Ԫ������ϵͳ 20080316
procedure AddSellOffItem (ci: TClientItem); //��ӵ����۳��ۿ���
var
   i: integer;
begin
   for i:=0 to 9-1 do begin
      if g_SellOffItems[i].S.Name = '' then begin
         g_SellOffItems[i] := ci;
         break;
      end;
   end;
end;

procedure MoveSellOffItemToBag;   //������� 20080316
var
   i: integer;
begin
   for i:=0 to 9-1 do begin
      if g_SellOffItems[i].S.Name <> '' then
         AddItemBag (g_SellOffItems[i]);
   end;
   FillChar (g_SellOffItems, sizeof(TClientItem)*9, #0);
end;
{******************************************************************************}
procedure MoveDealItemToBag;
var
   i: integer;
begin
   for i:=0 to 10-1 do begin
      if g_DealItems[i].S.Name <> '' then
         AddItemBag (g_DealItems[i]);
   end;
   FillChar (g_DealItems, sizeof(TClientItem)*10, #0);
end;

procedure AddDealRemoteItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 20-1 do begin
      if g_DealRemoteItems[i].S.Name = '' then begin
         g_DealRemoteItems[i] := ci;
         break;
      end;
   end;
end;

procedure DelDealRemoteItem (ci: TClientItem);
var
   i: integer;
begin
   for i:=0 to 20-1 do begin
      if (g_DealRemoteItems[i].S.Name = ci.S.Name) and (g_DealRemoteItems[i].MakeIndex = ci.MakeIndex) then begin
         FillChar (g_DealRemoteItems[i], sizeof(TClientItem), #0);
         break;
      end;
   end;
end;

{----------------------------------------------------------}
//���������ľ��루X��Y����
function  GetDistance (sx, sy, dx, dy: integer): integer;
begin
   Result := _MAX(abs(sx-dx), abs(sy-dy));
end;
//���ݷ���͵�ǰλ��ȷ����һ��λ������(λ����=1��
procedure GetNextPosXY (dir: byte; var x, y:Integer);
begin
   case dir of
      DR_UP:     begin x := x;   y := y-1; end;
      DR_UPRIGHT:   begin x := x+1; y := y-1; end;
      DR_RIGHT:  begin x := x+1; y := y; end;
      DR_DOWNRIGHT:  begin x := x+1; y := y+1; end;
      DR_DOWN:   begin x := x;   y := y+1; end;
      DR_DOWNLEFT:   begin x := x-1; y := y+1; end;
      DR_LEFT:   begin x := x-1; y := y; end;
      DR_UPLEFT:  begin x := x-1; y := y-1; end;
   end;
end;
//�ҷ���͵�ǰλ��ȷ��������һ��λ������(λ����=1)
function GetNextPosCanXY (var dir: byte; x, y: Integer):Boolean;
var
  mx,my: Integer;
begin
  Result := False;
  dir := 0;//GetNextDirection(x, y, TargetX, TargetY);
  while True do begin
    if dir > DR_UPLEFT then break;   //DIR �����һ������ ���߲��� ��ô�˳�
    case dir of
      DR_UP: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_UP, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_UP;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_UPRIGHT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_UPRIGHT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_UPRIGHT;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_RIGHT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_RIGHT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_RIGHT;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_DOWNRIGHT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_DOWNRIGHT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_DOWNRIGHT;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_DOWN: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_DOWN, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_DOWN;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_DOWNLEFT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_DOWNLEFT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_DOWNLEFT;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_LEFT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_LEFT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_LEFT;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end;
      DR_UPLEFT: begin
         mx := x;
         my := y;
         GetNextPosXY (DR_UPLEFT, mx, my);
         if PlayScene.CanWalk(mx, my) then begin
            //x:=mx;
            //y:=my;
            Dir:=DR_UPLEFT;
            Result := True;
            break;
         end else begin
            inc(dir);
            Continue;
         end;
      end; else Break;
    end;
  end;
end;
//���ݷ���͵�ǰλ��ȷ����һ��λ������(λ����=2��
procedure GetNextRunXY (dir: byte; var x, y:Integer);
begin
   case dir of
      DR_UP:     begin x := x;   y := y-2; end;
      DR_UPRIGHT:   begin x := x+2; y := y-2; end;
      DR_RIGHT:  begin x := x+2; y := y; end;
      DR_DOWNRIGHT:  begin x := x+2; y := y+2; end;
      DR_DOWN:   begin x := x;   y := y+2; end;
      DR_DOWNLEFT:   begin x := x-2; y := y+2; end;
      DR_LEFT:   begin x := x-2; y := y; end;
      DR_UPLEFT:  begin x := x-2; y := y-2; end;
   end;
end;

procedure GetNextHorseRunXY (dir: byte; var x, y:Integer);
begin
   case dir of
      DR_UP:     begin x := x;   y := y-3; end;
      DR_UPRIGHT:   begin x := x+3; y := y-3; end;
      DR_RIGHT:  begin x := x+3; y := y; end;
      DR_DOWNRIGHT:  begin x := x+3; y := y+3; end;
      DR_DOWN:   begin x := x;   y := y+3; end;
      DR_DOWNLEFT:   begin x := x-3; y := y+3; end;
      DR_LEFT:   begin x := x-3; y := y; end;
      DR_UPLEFT:  begin x := x-3; y := y-3; end;
   end;
end;

//������������ƶ��ķ���
function GetNextDirection (sx, sy, dx, dy: Integer): byte;
var
   flagx, flagy: integer;
begin
   Result := DR_DOWN;
   if sx < dx then flagx := 1
   else if sx = dx then flagx := 0
   else flagx := -1;
   if abs(sy-dy) > 2
    then if (sx >= dx-1) and (sx <= dx+1) then flagx := 0;

   if sy < dy then flagy := 1
   else if sy = dy then flagy := 0
   else flagy := -1;
   if abs(sx-dx) > 2 then if (sy > dy-1) and (sy <= dy+1) then flagy := 0;

   if (flagx = 0)  and (flagy = -1) then Result := DR_UP;
   if (flagx = 1)  and (flagy = -1) then Result := DR_UPRIGHT;
   if (flagx = 1)  and (flagy = 0)  then Result := DR_RIGHT;
   if (flagx = 1)  and (flagy = 1)  then Result := DR_DOWNRIGHT;
   if (flagx = 0)  and (flagy = 1)  then Result := DR_DOWN;
   if (flagx = -1) and (flagy = 1)  then Result := DR_DOWNLEFT;
   if (flagx = -1) and (flagy = 0)  then Result := DR_LEFT;
   if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
end;

//���ݵ�ǰ������ת���ķ���
function  GetBack (dir: integer): integer;
begin
   Result := DR_UP;
   case dir of
      DR_UP:     Result := DR_DOWN;
      DR_DOWN:   Result := DR_UP;
      DR_LEFT:   Result := DR_RIGHT;
      DR_RIGHT:  Result := DR_LEFT;
      DR_UPLEFT:     Result := DR_DOWNRIGHT;
      DR_UPRIGHT:    Result := DR_DOWNLEFT;
      DR_DOWNLEFT:   Result := DR_UPRIGHT;
      DR_DOWNRIGHT:  Result := DR_UPLEFT;
   end;
end;
//���ݵ�ǰ����ͷ����ú��˵�����
procedure GetBackPosition (sx, sy, dir: integer; var newx, newy: integer);
begin
   newx := sx;
   newy := sy;
   case dir of
      DR_UP:      newy := newy+1;
      DR_DOWN:    newy := newy-1;
      DR_LEFT:    newx := newx+1;
      DR_RIGHT:   newx := newx-1;
      DR_UPLEFT:
         begin
            newx := newx + 1;
            newy := newy + 1;
         end;
      DR_UPRIGHT:
         begin
            newx := newx - 1;
            newy := newy + 1;
         end;
      DR_DOWNLEFT:
         begin
            newx := newx + 1;
            newy := newy - 1;
         end;
      DR_DOWNRIGHT:
         begin
            newx := newx - 1;
            newy := newy - 1;
         end;
   end;
end;
//���ݵ�ǰλ�úͷ�����ǰ��һ��������
procedure GetFrontPosition (sx, sy, dir: integer; var newx, newy: integer);
begin
   newx := sx;
   newy := sy;
   case dir of
      DR_UP:      newy := newy-1;
      DR_DOWN:    newy := newy+1;
      DR_LEFT:    newx := newx-1;
      DR_RIGHT:   newx := newx+1;
      DR_UPLEFT:
         begin
            newx := newx - 1;
            newy := newy - 1;
         end;
      DR_UPRIGHT:
         begin
            newx := newx + 1;
            newy := newy - 1;
         end;
      DR_DOWNLEFT:
         begin
            newx := newx - 1;
            newy := newy + 1;
         end;
      DR_DOWNRIGHT:
         begin
            newx := newx + 1;
            newy := newy + 1;
         end;
   end;
end;
//��������λ�û�÷��з���8������
function  GetFlyDirection (sx, sy, ttx, tty: integer): Integer;
var
   fx, fy: Real;
begin
   fx := ttx - sx;
   fy := tty - sy;
   {sx := 0;
   sy := 0;  }
   Result := DR_DOWN;
   if fx=0 then begin         //�����X�������
      if fy < 0 then Result := DR_UP
      else Result := DR_DOWN;
      exit;
   end;
   if fy=0 then begin         //�����Y�������
      if fx < 0 then Result := DR_LEFT
      else Result := DR_RIGHT;
      exit;
   end;
   if (fx > 0) and (fy < 0) then begin
      if -fy > fx*2.5 then Result := DR_UP
      else if -fy < fx/3 then Result := DR_RIGHT
      else Result := DR_UPRIGHT;
   end;
   if (fx > 0) and (fy > 0) then begin
      if fy < fx/3 then Result := DR_RIGHT
      else if fy > fx*2.5 then Result := DR_DOWN
      else Result := DR_DOWNRIGHT;
   end;
   if (fx < 0) and (fy > 0) then begin
      if fy  < -fx/3 then Result := DR_LEFT
      else if fy > -fx*2.5 then Result := DR_DOWN
      else Result := DR_DOWNLEFT;
   end;
   if (fx < 0) and (fy < 0) then begin
      if -fy > -fx*2.5 then Result := DR_UP
      else if -fy < -fx/3 then Result := DR_LEFT
      else Result := DR_UPLEFT;
   end;
end;
//��������λ�û�÷��з���(16������)
function  GetFlyDirection16 (sx, sy, ttx, tty: integer): Integer;
var
   fx, fy: Real;
begin
   fx := ttx - sx;
   fy := tty - sy;
   {sx := 0;
   sy := 0; }
   Result := 0;
   if fx=0 then begin
      if fy < 0 then Result := 0
      else Result := 8;
      exit;
   end;
   if fy=0 then begin
      if fx < 0 then Result := 12
      else Result := 4;
      exit;
   end;
   if (fx > 0) and (fy < 0) then begin
      Result := 4;
      if -fy > fx/4 then Result := 3;
      if -fy > fx/1.9 then Result := 2;
      if -fy > fx*1.4 then Result := 1;
      if -fy > fx*4 then Result := 0;
   end;
   if (fx > 0) and (fy > 0) then begin
      Result := 4;
      if fy > fx/4 then Result := 5;
      if fy > fx/1.9 then Result := 6;
      if fy > fx*1.4 then Result := 7;
      if fy > fx*4 then Result := 8;
   end;
   if (fx < 0) and (fy > 0) then begin
      Result := 12;
      if fy > -fx/4 then Result := 11;
      if fy > -fx/1.9 then Result := 10;
      if fy > -fx*1.4 then Result := 9;
      if fy > -fx*4 then Result := 8;
   end;
   if (fx < 0) and (fy < 0) then begin
      Result := 12;
      if -fy > -fx/4 then Result := 13;
      if -fy > -fx/1.9 then Result := 14;
      if -fy > -fx*1.4 then Result := 15;
      if -fy > -fx*4 then Result := 0;
   end;
end;
//����ʱ��ת��һ�������ķ���
function  PrivDir (ndir: integer): integer;
begin
   if ndir - 1 < 0 then Result := 7
   else Result := ndir-1;
end;
//��˳ʱ��ת��һ�������ķ���
function  NextDir (ndir: integer): integer;
begin
   if ndir + 1 > 7 then Result := 0
   else Result := ndir+1;
end;

function  GetTakeOnPosition (smode: integer): integer;
begin
   //4,47,15,20,22,26
   Result := -1;
   case smode of //StdMode
      5, 6     :Result := U_WEAPON;//����
      10, 11   :Result := U_DRESS;
      15    :Result := U_HELMET;
      16    :Result := U_ZHULI;  //����
      19,20,21,28,29 :Result := U_NECKLACE;//20100628 ����29����
      22,23,27 :Result := U_RINGR;
      24,26    :Result := U_ARMRINGR;
      30{,29} :Result := U_RIGHTHAND;//20100628 ע��29
      {$IF M2Version <> 2}
      25,2{ף����,ħ���}    :Result := U_BUJUK; //��
      {$ELSE}
      25: Result := U_ARMRINGL;
      {$IFEND}
      52,62    :Result := U_BOOTS; //Ь
      55{,62}  :Result := U_DRUM; //  remark��������
      53,63,7{��Ѫʯ}    :Result := U_CHARM; //��ʯ
      54,64    :Result := U_BELT;  //����
      4, 47, 42,3{ף����},41{ħ��ָ����}:Result := X_RepairFir; //�޲�����֮��
   end;
end;

//�ж�ĳ�����Ƿ���
function  IsKeyPressed (key: byte): Boolean;
var
   keyvalue: TKeyBoardState;
begin
   Result := FALSE;
   FillChar(keyvalue, sizeof(TKeyboardState), #0);
   if GetKeyboardState (keyvalue) then
      if (keyvalue[key] and $80) <> 0 then
         Result := TRUE;
end;

procedure AddChangeFace (recogid: integer);
begin
   g_ChangeFaceReadyList.Add (pointer(recogid));
end;

procedure DelChangeFace (recogid: integer);
var
   i: integer;
begin
   if g_ChangeFaceReadyList.Count > 0 then //20080629
   for i:=0 to g_ChangeFaceReadyList.Count-1 do begin
      if integer(g_ChangeFaceReadyList[i]) = recogid then begin
         g_ChangeFaceReadyList.Delete (i);
         break;
      end;
   end;
end;

function  IsChangingFace (recogid: integer): Boolean;
var
   i: integer;
begin
   Result := FALSE;
   if g_ChangeFaceReadyList.Count > 0 then //20080629 
   for i:=0 to g_ChangeFaceReadyList.Count-1 do begin
      if integer(g_ChangeFaceReadyList[i]) = recogid then begin
         Result := TRUE;
         break;
      end;
   end;
end;

function GetTipsStr():string;
begin
  Result := '';
  if (g_TipsList <> nil) and //���������˳���Ϸ��BUG
  (g_TipsList.Count > 0) then begin
    Randomize(); //�������
    Result := g_TipsList.Strings[Random(g_TipsList.Count)];
  end;
end;

function GetHeroJobStr(btJob: Byte): string;
begin
  case btJob of
    0: Result := 'ս';
    1: Result := '��';
    2: Result := '��';
  end;
end;

Initialization
  DropItems := TList.Create;
Finalization
  DropItems.Free;
end.
