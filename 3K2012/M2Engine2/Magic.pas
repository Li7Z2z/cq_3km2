unit Magic;

interface
uses
  Windows, Classes, Grobal2, ObjBase, ObjHero, SysUtils;
type
  TMagicManager = class
  private
  public
    constructor Create();
    destructor Destroy; override;
    function MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean;
    function IsWarrSkill(wMagIdx: Integer): Boolean;
    function DoSpell(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;

    function MagBigHealing(PlayObject: TBaseObject; nPower, nX, nY: Integer; UserMagic: pTUserMagic): Boolean;
    function MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer; boType: Boolean; UserMagic: pTUserMagic): Integer;//20090508 �޸�
    function MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nLevel: Integer): Boolean;
    function MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer;
    function MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY: Integer; nHTime: Integer): Boolean;
    function MagTamming(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nMagicLevel: Integer): Boolean;
    function MagSaceMove(BaseObject: TBaseObject; nLevel: Integer): Boolean;
    function MagMakeFireCross(PlayObject: TBaseObject; nDamage, nHTime, nX, nY: Integer; LevelEx: Byte): Integer;
    function MagBigExplosion(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer; nCode: Byte): Boolean;
    //���ǻ��� 20080510
    function MagBigExplosion1(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer; var TargeObject: TBaseObject; boHeartSkill: Boolean; nID : Integer): Boolean;
    function MagElecBlizzard(BaseObject: TBaseObject; nPower: Integer): Boolean;
    function MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY: Integer): Boolean;

    function MagMakeSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�ٻ�����
    function MagMakeSlaveEx(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var boSpellFire: Boolean): Boolean;//ǿ���ٻ�����
    function MagMakeFairy(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�ٻ�����
    function MagMakeFireFairy(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�ٻ�����
    function MagMakeSelf(BaseObject, TargeTBaseObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
    function MagMakeShengSuSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�ٻ�ʥ��
    function MagMakeShengSuSlaveEx(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var boSpellFire: Boolean): Boolean;//ǿ���ٻ�ʥ��
    function MagMakeCallTrollSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�ٻ���ħ
    function MagMakeSinSuSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
    function MagWindTebo(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
    function MagGroupLightening(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    function MagGroupAmyounsul(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupDeDing(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupMb(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagHbFireBall(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    //function MagReturn(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY, nMagicLevel: Integer): Boolean;//δʹ�� 20080410
    function MagMakeSlave_(PlayObject: TBaseObject; UserMagic: pTUserMagic; sMonName: string; nCount, nHumLevel, nMonLevel: Integer): Boolean;
    function MagLightening(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    function MagMakeSuperFireCross(PlayObject: TBaseObject; nDamage, nHTime, nX, nY: Integer; nCount: Integer): Integer;

    function MagMakeFireball(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagTreatment(PlayObject: TBaseObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeHellFire(PlayObject: TBaseObject ; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeQuickLighting(PlayObject: TBaseObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeLighting(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeFireCharm(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagFireCharmTreatment(PlayObject: TBaseObject;UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
{$IF M2Version <> 2}
    function MagBigExplosion_105(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�����ķ�
    //����֮��
    function MagMakeFireCharm_110(PlayObject: TBaseObject; UserMagic: pTUserMagic;var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
    //��˪Ⱥ��
    function MagMakeFireCharm_111(PlayObject: TBaseObject; UserMagic: pTUserMagic;var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
    //ʮ��һɱ
    function MagMakeFireCharm_112(PlayObject: TBaseObject; UserMagic: pTUserMagic;var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    //��������
    function MagMakeFireCharm_113(BaseObject: TBaseObject; UserMagic: pTUserMagic; nTime, nX, nY: Integer;TargeObject: TBaseObject; var boSpellFire: Boolean): Integer;
    //ŭ�ɻ���
    function MagMakeFireCharm_114(PlayObject: TBaseObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    //Ѫ��һ��(��)
    function MagMakeFireCharm_98(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
    //Ѫ��һ��(��)
    function MagBigExplosion_97(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer; UserMagic: pTUserMagic; var TargeObject: TBaseObject): Boolean;
    function GetNGPow(BaseObject: TBaseObject; UserMagic: pTUserMagic; Power: Integer): Integer;//�ڹ����ܵ�����ֵ
{$IFEND}
    function MagMakeUnTreatment(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeLivePlayObject(PlayObject: TBaseObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeArrestObject(PlayObject: TBaseObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
    function MagChangePosition(PlayObject: TBaseObject; nTargetX, nTargetY: Integer): Boolean;
    function MagChangePosition2(PlayObject: TBaseObject; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeFireDay(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupFengPo(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagTamming2(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY, nMagicLevel: Integer): Boolean;
{$IF HEROVERSION = 1}
    function MagMakeSkillFire_60(PlayObject: TBaseObject; UserMagic: pTUserMagic; nPower: Integer): Boolean;
    function MagMakeSkillFire_61(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeSkillFire_62(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeSkillFire_63(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeSkillFire_64(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeSkillFire_65(BaseObject: TBaseObject; UserMagic: pTUserMagic; nPower: Integer): Boolean;
{$IFEND}
    function MagMakeHPUp(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;//�������� 20080625
{$IF M2Version = 1}
    //˫���� 1
    function MagMakeSkillFire_77(PlayObject: TBaseObject; UserMagic: pTUserMagic;nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //�����{��} 2
    function MagMakeSkillFire_80(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //���ױ�{��} 3
    function MagMakeSkillFire_83(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //����ѩ��{��} 4
    function MagMakeSkillFire_86(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; mStormsHit:Byte): Boolean;
    //��Х��{��} 1
    function MagMakeSkillFire_78(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //������{��} 2
    function MagMakeSkillFire_81(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //������{��} 3
    function MagMakeSkillFire_84(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
    //�򽣹���{��} 4
    function MagMakeSkillFire_87(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; mStormsHit:Byte): Boolean;
{$IFEND}
    //����ٵ�(Զ��ģʽ)
    function Attack_69(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer): Boolean;
  end;
  function MPow(UserMagic: pTUserMagic): Integer;
  function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
  function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
  function GetRPow(wInt: Integer): Word;
  function CheckAmulet(PlayObject: TBaseObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
  procedure UseAmulet(PlayObject: TBaseObject; nCount: Integer; nType: Integer; var Idx: Integer);

implementation

uses HUtil32, M2Share, Event, Envir ,PlugOfEngine, ObjAIPlayObject;


//�����������
function MPow(UserMagic: pTUserMagic): Integer;
begin
  if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
  else Result := UserMagic.MagicInfo.wPower;
end;
function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
begin
  if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
    Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
  else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
end;

function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
var
  d10: Double;
  d18: Double;
begin
  d10 := nInt / 3.0;
  d18 := nInt - d10;
  if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
    Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)))
  else Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + UserMagic.MagicInfo.btDefPower);
end;
function GetRPow(wInt: Integer): Word;
begin
  if HiWord(wInt) > LoWord(wInt) then begin
    Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
  end else Result := LoWord(wInt);
end;
{----------------------------------------------------------------------
��������:��黤����� �Ƿ����
���� nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
���ж�װ�������Ƿ���д�����Ʒ,��û��,����������Ƿ���д�����Ʒ
-----------------------------------------------------------------------}
function CheckAmulet(PlayObject: TBaseObject; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
var
  I: Integer;
  UserItem: pTUserItem; //��,�����ֱ��ʹ��
  AmuletStdItem: pTStdItem;
begin
  Result := False;
  try
  if PlayObject.m_boGhost then Exit;//20090101
  Idx := 0;
  if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    if (AmuletStdItem <> nil) then begin
      if (AmuletStdItem.StdMode = 25) then begin
        case nType of
          1: begin
              if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                Idx := U_ARMRINGL;
                Result := True;
                Exit;
              end;
            end;
          2: begin
              if PlayObject.m_btRaceServer =RC_PLAYOBJECT then begin
                if not PlayObject.m_boAI then begin
                  if (AmuletStdItem.Shape <= 2) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                    Idx := U_ARMRINGL;//20080722
                    Result := True;
                    Exit;
                  end;
                end else begin
                   case TAIPlayObject(PlayObject).n_AmuletIndx of
                     1: begin //�̶�
                        if (AmuletStdItem.Shape = 1) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                          Idx := U_ARMRINGL;
                          Result := True;
                          Exit;
                        end;
                     end;
                     2:begin //�춾
                         if (AmuletStdItem.Shape = 2) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                          Idx := U_ARMRINGL;
                          Result := True;
                          Exit;
                        end;
                     end;
                   end;//Case
                end;
              end else
              if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
                 case THeroObject(PlayObject).n_AmuletIndx of
                   1: begin //�̶�
                      if (AmuletStdItem.Shape = 1) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                        Idx := U_ARMRINGL;
                        Result := True;
                        Exit;
                      end;
                   end;
                   2:begin //�춾
                       if (AmuletStdItem.Shape = 2) and (Round(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
                        Idx := U_ARMRINGL;
                        Result := True;
                        Exit;
                      end;
                   end;
                 end;//Case
              end;
            end;
        end;
      end;
    end;
  end;

  if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
    if (AmuletStdItem <> nil) then begin
      if (AmuletStdItem.StdMode = 25) then begin
        case nType of //
          1: begin//��
              if (AmuletStdItem.Shape = 5) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                Idx := U_BUJUK;
                Result := True;
                Exit;
              end;
            end;
          2: begin//��
              if (PlayObject.m_btRaceServer =RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_PLAYMOSTER) then begin//20080722
                if not PlayObject.m_boAI then begin
                  if (AmuletStdItem.Shape <= 2) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                    Idx := U_BUJUK;
                    Result := True;
                    Exit;
                  end;
                end else begin
                   case TAIPlayObject(PlayObject).n_AmuletIndx of
                     1: begin //�̶�
                        if (AmuletStdItem.Shape = 1) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                          Idx := U_BUJUK;
                          Result := True;
                          Exit;
                        end;
                     end;
                     2:begin //�춾
                         if (AmuletStdItem.Shape = 2) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                          Idx := U_BUJUK;
                          Result := True;
                          Exit;
                        end;
                     end;
                   end;//Case
                end;
              end else
              if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
                 case THeroObject(PlayObject).n_AmuletIndx of
                   1: begin //�̶�
                      if (AmuletStdItem.Shape = 1) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                        Idx := U_BUJUK;
                        Result := True;
                        Exit;
                      end;
                   end;
                   2:begin //�춾
                       if (AmuletStdItem.Shape = 2) and (Round(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
                        Idx := U_BUJUK;
                        Result := True;
                        Exit;
                      end;
                   end;
                 end;//Case
              end;
            end;
        end;
      end;
    end;
  end;

  //20071228 ��,�����ֱ��ʹ��(�����������Ƿ���ڶ�,�����)
  if PlayObject.m_ItemList.Count > 0 then begin//20080628
    for I := 0 to PlayObject.m_ItemList.Count - 1 do begin //���������Ϊ��
      UserItem := PlayObject.m_ItemList.Items[I];
      AmuletStdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if (AmuletStdItem <> nil) then begin
        if (AmuletStdItem.StdMode = 25) then begin
          case nType of
            1: begin
                if (AmuletStdItem.Shape = 5) and (Round(UserItem.Dura / 100) >= nCount) then begin  //20071227
                  Idx :=UserItem.wIndex; //20071227
                  Result := True;
                  Exit;
                end;
              end;
            2: begin
                if PlayObject.m_btRaceServer =RC_PLAYOBJECT then begin
                  if not PlayObject.m_boAI then begin
                    if (AmuletStdItem.Shape <= 2) and (Round(UserItem.Dura / 100) >= nCount) then begin
                      Idx :=UserItem.wIndex;
                      Result := True;
                      Exit;
                    end;
                  end else begin
                     case TAIPlayObject(PlayObject).n_AmuletIndx of
                       1: begin //�̶�
                          if (AmuletStdItem.Shape = 1) and (Round(UserItem.Dura / 100) >= nCount) then begin
                            Idx := UserItem.wIndex;
                            Result := True;
                            Exit;
                          end;
                       end;
                       2:begin //�춾
                           if (AmuletStdItem.Shape = 2) and (Round(UserItem.Dura / 100) >= nCount) then begin
                            Idx :=UserItem.wIndex;
                            Result := True;
                            Exit;
                          end;
                       end;
                     end;//Case
                  end;
                end else
                if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
                   case THeroObject(PlayObject).n_AmuletIndx of
                     1: begin //�̶�
                        if (AmuletStdItem.Shape = 1) and (Round(UserItem.Dura / 100) >= nCount) then begin
                          Idx := UserItem.wIndex;
                          Result := True;
                          Exit;
                        end;
                     end;
                     2:begin //�춾
                         if (AmuletStdItem.Shape = 2) and (Round(UserItem.Dura / 100) >= nCount) then begin
                          Idx :=UserItem.wIndex;
                          Result := True;
                          Exit;
                        end;
                     end;
                   end;//Case
                end;
              end;//2
          end;//case
        end;
      end;
    end;
  end; 
//  end;
  except
    on E: Exception do begin
      MainOutMessage(format('{%s} TMagic.CheckAmulet',[g_sExceptionVer]));
    end;
  end;
end;
{-------------------------------------------------------------------------------
//ʹ�û���� nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
//20071227�޸�,ʹ�����еĶ�,���������ֱ��ʹ��,��װ����û�з��ϻ������,
�������д�����Ʒ,��ֱ��ʹ�ð������д�����Ʒ
--------------------------------------------------------------------------------}
procedure UseAmulet(PlayObject: TBaseObject; nCount: Integer; nType: Integer; var Idx: Integer);
var
  I : Integer;
  UserItem: pTUserItem; //20071227 ��,�����ֱ��ʹ��
  AmuletStdItem: pTStdItem;
  nCode: byte;
begin
  nCode:= 0;
  try
    if PlayObject.m_boGhost then Exit;//20090101
    nCode:= 1;                                                           {20080218 �޸�}
    if ((PlayObject.m_UseItems[U_BUJUK].wIndex > 0) or (PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0)) and ((U_BUJUK =Idx) or (U_ARMRINGL = Idx))//20080212 ����,�ж�װ����û���������Ʒ
      and (PlayObject.m_UseItems[Idx].Dura >= nCount * 100) then begin
      nCode:= 2;
      Dec(PlayObject.m_UseItems[Idx].Dura, nCount * 100);
      if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        nCode:= 3;
        PlayObject.SendMsg(PlayObject, RM_DURACHANGE, Idx, PlayObject.m_UseItems[Idx].Dura, PlayObject.m_UseItems[Idx].DuraMax, 0, '');
        nCode:= 4;
        TPlayObject(PlayObject).SendUpdateItem(@PlayObject.m_UseItems[Idx]);//20080212 ������Ʒ
        if PlayObject.m_UseItems[Idx].Dura <= 0 then begin
          nCode:= 5;
          TPlayObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[Idx]);
          PlayObject.m_UseItems[Idx].wIndex := 0;
        end;
      end else
      if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
        nCode:= 6;
        PlayObject.SendMsg(PlayObject, RM_HERODURACHANGE, Idx, PlayObject.m_UseItems[Idx].Dura, PlayObject.m_UseItems[Idx].DuraMax, 0, '');
        nCode:= 7;
        THeroObject(PlayObject).SendUpdateItem(@PlayObject.m_UseItems[Idx]);//20080212 ������Ʒ
        if PlayObject.m_UseItems[Idx].Dura <= 0 then begin
          nCode:= 8;
          THeroObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[Idx]);
          PlayObject.m_UseItems[Idx].wIndex := 0;
        end;
      end;
    end else begin
      nCode:= 9;
      for I := PlayObject.m_ItemList.Count - 1 downto 0 do begin //���������Ϊ�� 20080916 �޸�
        if PlayObject.m_ItemList.Count <= 0 then Break;//20080916
        nCode:= 10;
        UserItem := PlayObject.m_ItemList.Items[I];
        if UserItem.wIndex = idx then begin
          nCode:= 11;
          AmuletStdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if (AmuletStdItem <> nil) then begin
            nCode:= 12;
            if (AmuletStdItem.StdMode = 25) then begin
              case nType of
                1: begin  //�����
                    if(AmuletStdItem.Shape = 5) and (UserItem.Dura >= nCount* 100) then  //20071227
                      Dec(UserItem.Dura, nCount * 100);
                  end;
                2: begin // ��ҩ
                    if  (AmuletStdItem.Shape <= 2) and (UserItem.Dura >= nCount* 100) then  //20071227
                      Dec(UserItem.Dura, nCount * 100);
                  end;
              end; //case

              if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//20080212 �޸�
                nCode:= 13;
                PlayObject.SendMsg(PlayObject, RM_DURACHANGE,UserItem.wIndex, UserItem.Dura, UserItem.DuraMax, 0, '');
                nCode:= 14;
                TPlayObject(PlayObject).SendUpdateItem(UserItem);//������Ʒ
                if UserItem.Dura <= 0 then begin
                  nCode:= 15;
                  PlayObject.m_ItemList.Delete(I);
                  nCode:= 16;
                  TPlayObject(PlayObject).SendDelItems(UserItem);
                  Dispose(UserItem);//20100928 ����
                end;
              end else
              if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
                nCode:= 17;
                PlayObject.SendMsg(PlayObject, RM_HERODURACHANGE,UserItem.wIndex, UserItem.Dura, UserItem.DuraMax, 0, '');
                nCode:= 18;
                THeroObject(PlayObject).SendUpdateItem(UserItem);//������Ʒ
                if UserItem.Dura <= 0 then begin
                  nCode:= 19;
                  PlayObject.m_ItemList.Delete(I);
                  nCode:= 20;
                  THeroObject(PlayObject).SendDelItems(UserItem);
                  Dispose(UserItem);//20100928 ����
                end;
              end;
              Exit;
            end;
          end;
        end;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(format('{%s} TMagic.UseAmulet Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
end;

//�����������ܻ�  boType-T ���Զ�ͬ��ʹ�� F-�����Զ�ͬ��ʹ��
function TMagicManager.MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer; boType: Boolean; UserMagic : pTUserMagic): Integer; //00492204
var
  I, nDir, levelgap, push: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  if PlayObject.m_VisibleActors.Count > 0 then begin
    for I := 0 to PlayObject.m_VisibleActors.Count - 1 do begin
      BaseObject := TBaseObject(pTVisibleBaseObject(PlayObject.m_VisibleActors[I]).BaseObject);
      if BaseObject <> nil then begin
        if (abs(PlayObject.m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY - BaseObject.m_nCurrY) <= 1) then begin
          if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then begin
            if boType then begin//20090508 ����
              if ((PlayObject.m_nStickIncLevel + PlayObject.m_Abil.Level) >= BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
                levelgap := PlayObject.m_nStickIncLevel + PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
                if (Random(20) < 6 + nPushLevel * 3 + levelgap) then begin
                  if PlayObject.IsProperTarget(BaseObject) then begin
                    push := 1 + _MAX(0, nPushLevel - 1) + Random({2}3);//20081217 �޸�
                    nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
                    BaseObject.CharPushed(nDir, push);
                    if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
                      TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
                    Inc(Result);
                  end;
                end;
              end;
            end else begin
              if ((PlayObject.m_nStickIncLevel + PlayObject.m_Abil.Level) > BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
                levelgap := PlayObject.m_nStickIncLevel + PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
                if (Random(20) < 6 + nPushLevel * 3 + levelgap) then begin
                  if PlayObject.IsProperTarget(BaseObject) then begin
                    push := 1 + _MAX(0, nPushLevel - 1) + Random(3);
                    nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
                    BaseObject.CharPushed(nDir, push);
                    if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
                      TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
                    Inc(Result);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;
//Ⱥ��������
function TMagicManager.MagBigHealing;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nX, nY, 1, BaseObjectList);
    if BaseObjectList.Count > 0 then begin//20080629
      for I := 0 to BaseObjectList.Count - 1 do begin
        BaseObject := TBaseObject(BaseObjectList[I]);
        if PlayObject.IsProperFriend(BaseObject) then begin
          if BaseObject.m_WAbil.HP < BaseObject.m_WAbil.MaxHP then begin
            BaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
            if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

            Result := True;
          end;
          if PlayObject.m_boAbilSeeHealGauge then begin
            PlayObject.SendMsg(BaseObject, RM_10414, 0, 0, 0, 0, ''); //?? RM_INSTANCEHEALGUAGE
          end;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
end;

constructor TMagicManager.Create;
begin

end;

destructor TMagicManager.Destroy;
begin
  inherited;
end;
{����,�����}
function TMagicManager.MagMakeFireball(PlayObject: TBaseObject; 
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) or g_Config.boAutoCanHit then begin
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin
      if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
        with PlayObject do begin
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
            SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
        end;
        if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
          TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
        {$IF M2Version <> 2}
        case UserMagic.MagicInfo.wMagicId of
          SKILL_FIREBALL{1}: begin//������
              case PlayObject.m_btRaceServer of
                RC_PLAYOBJECT: begin
                  NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_208,nPower);//ŭ֮����
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end;
                  end;
                  nPower := _MAX(0, nPower + NGSecPwr);
                end;
                RC_HEROOBJECT: begin
                  NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_208,nPower);//ŭ֮����
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end;
                  end;
                  nPower := _MAX(0, nPower + NGSecPwr);
                end;
                RC_PLAYMOSTER: begin
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_209,nPower);//��֮����
                    end;
                    nPower := _MAX(0, nPower - NGSecPwr);
                  end;
                end;
              end;
            end;
          SKILL_FIREBALL2{5}: begin //�����
              Case PlayObject.m_btRaceServer of
                RC_PLAYOBJECT: begin
                  NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_210,nPower);//ŭ֮�����
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮�����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮�����
                    end;
                  end;
                  nPower := _MAX(0, nPower + NGSecPwr);
                end;
                RC_HEROOBJECT: begin
                  NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_210,nPower);//ŭ֮�����
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮�����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮����
                    end;
                  end;
                  nPower := _MAX(0, nPower + NGSecPwr);
                end;
                RC_PLAYMOSTER: begin
                  if TargeTBaseObject <> nil then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮�����
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_211,nPower);//��֮����
                    end;
                    nPower := _MAX(0, nPower - NGSecPwr);
                  end;
                end;
              end;
            end;
        end;
        {$IFEND}
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 600);
        {$IF M2Version = 1}
        if nPower > 0 then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              NGSecPwr:= 0;
              NGSecPwr := Random(PlayObject.m_nVampirePoint);
              if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
            end;
          end;
        end;
        {$IFEND}
        if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
        if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2}and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
          if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
            and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
            TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
          end else
          if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
            and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
            TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE { �ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
          end;
        end;
      end else
        TargeTBaseObject := nil;
    end else
      TargeTBaseObject := nil;
  end else
    TargeTBaseObject := nil;
end;

{������}
function TMagicManager.MagTreatment(PlayObject: TBaseObject; UserMagic: pTUserMagic;
   var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  if TargeTBaseObject = nil then begin
    TargeTBaseObject := PlayObject;
  end;
  if PlayObject.IsProperFriend(TargeTBaseObject) then begin
    nTargetX := TargeTBaseObject.m_nCurrX;
    nTargetY := TargeTBaseObject.m_nCurrY;
    nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
      SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1) + PlayObject.m_WAbil.Level;
    if TargeTBaseObject.m_WAbil.HP < TargeTBaseObject.m_WAbil.MaxHP then begin
      TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
      Result := True;
    end;
    if PlayObject.m_boAbilSeeHealGauge then//������ʾ
      PlayObject.SendMsg(TargeTBaseObject, RM_10414, 0, 0, 0, 0, '');
  end;
end;

//������
function TMagicManager.MagMakeHellFire(PlayObject: TBaseObject; UserMagic: pTUserMagic;
 nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  nPower,nSccPwr: Integer;
  n1C, NGSecPwr: Integer;
  n14, n18: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
  if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then begin
    PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 5, nTargetX, nTargetY);
    nSccPwr := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
      SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
    nPower:= nSccPwr;
    {$IF M2Version <> 2}
    if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
      NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_214,nSccPwr);//ŭ֮������
      nPower := _MAX(0, nSccPwr + NGSecPwr);
    end else
    if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
      NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_214,nSccPwr);//ŭ֮������
      nPower := _MAX(0, nSccPwr + NGSecPwr);
    end;
    {$IFEND}
    if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, nSccPwr, False, SKILL_FIRE) > 0 then begin
      {$IF M2Version = 1}
      if nPower > 0 then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            NGSecPwr:= 0;
            NGSecPwr := Random(PlayObject.m_nVampirePoint);
            if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
          end;
        end;
      end;
      {$IFEND}
      Result := True;
    end;
  end;
end;

//�����Ӱ
function TMagicManager.MagMakeQuickLighting(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  var nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  nPower,nSccPwr: Integer;
  n1C, NGSecPwr: Integer;
  n14, n18: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
  if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then begin
    PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 8, nTargetX, nTargetY);
    nSccPwr := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
      SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
    nPower:= nSccPwr;
    {$IF M2Version <> 2}
    if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
      NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_216,nSccPwr);//ŭ֮�����Ӱ
      nPower := _MAX(0, nSccPwr + NGSecPwr);
      //����ǿ�����ܵ�����
      if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
        if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
          nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[6] /100)))
        end;
      end;
      TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
    end else
    if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
      NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_216,nSccPwr);//ŭ֮�����Ӱ
      nPower := _MAX(0, nSccPwr + NGSecPwr);
    end;
    {$IFEND}
    if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, nSccPwr, True, SKILL_SHOOTLIGHTEN) > 0 then begin
      {$IF M2Version = 1}
      if nPower > 0 then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            NGSecPwr:= 0;
            NGSecPwr := Random(PlayObject.m_nVampirePoint);
            if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
          end;
        end;
      end;
      {$IFEND}    
      Result := True;
    end;
  end;
end;

//�׵���(��,Ӣ��ʹ�ô˹���,������)
function TMagicManager.MagMakeLighting(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin
    if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
        SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then nPower := Round(nPower * 1.5);
      if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
      {$IF M2Version <> 2}
      case PlayObject.m_btRaceServer of
        RC_PLAYOBJECT: begin
          NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_222,nPower);//ŭ֮�׵�
          if TargeTBaseObject <> nil then begin
            if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
              NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_223,nPower);//��֮�׵�
            end else
            if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
              NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_223,nPower);//��֮�׵�
            end;
          end;
          nPower := _MAX(0, nPower + NGSecPwr);
          if (UserMagic.wMagIdx = SKILL_91) then begin//����ǿ�����ܵ�����
            if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
              if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[5] /100)))
              end;
            end;
            TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
          end;
        end;
        RC_HEROOBJECT: begin
          NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_222,nPower);//ŭ֮�׵�
          if TargeTBaseObject <> nil then begin
            if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
              NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_223,nPower);//��֮�׵�
            end else
            if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
              NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_223,nPower);//��֮�׵�
            end;
          end;
          nPower := _MAX(0, nPower + NGSecPwr);
        end;
      end;
      {$IFEND}
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 600);
      {$IF M2Version = 1}
      if nPower > 0 then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            NGSecPwr:= 0;
            NGSecPwr := Random(PlayObject.m_nVampirePoint);
            if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
          end;
        end;
      end;
      {$IFEND}
      if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
      else if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
      if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2}and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
        if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
          and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate)  then begin//ħ����Խ�ָ
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
        end else
        if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
          and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
        end;
      end;
    end else TargeTBaseObject := nil
  end else TargeTBaseObject := nil;
end;

//�����,֧��4�����
function TMagicManager.MagMakeFireCharm(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr, I, nSePwr, nTwoPwr, K, nXX, nYY: Integer;
  boHeartSkill: boolean;
  BaseObjectList: TList;
  BaseObject, HitObject: TBaseObject;
  MaxTrain: LongWord;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
  function GetObject(var aList: TList; nX, nY: Integer): TBaseObject;
  var
    I, K, nC, n10, nCode:Integer;
    BaseObject: TBaseObject;
  begin
    Result := nil;
    K:= 0;
    nCode:= 0;
    try
      if aList.Count > 0 then begin
        nCode:= 1;
        for I := 0 to aList.Count - 1 do begin
          nCode:= 2;
          BaseObject := TBaseObject(aList.Items[I]);
          if BaseObject <> nil then begin
            nCode:= 3;
            if BaseObject = TargeTBaseObject then Continue;//����
            nCode:= 5;                               //�������䵽�Լ�Ӣ�۵�BUG By TasNat at: 2012-03-08 13:57:24
            if PlayObject.IsProperTarget(BaseObject) and
              (BaseObject <> TPlayObject(PlayObject).m_MyHero) and
              (BaseObject.m_Master <> PlayObject) and
              ((TPlayObject(PlayObject).m_MyHero = nil) or (BaseObject.m_Master <> TPlayObject(PlayObject).m_MyHero)) then begin
              nCode:= 6;
              nC := abs(nX - BaseObject.m_nCurrX) + abs(nY - BaseObject.m_nCurrY);
              if nC < n10 then begin
                n10 := nC;
                nCode:= 7;
                Result := BaseObject;
                K:= I;
              end;
            end;
          end;
        end;
        nCode:= 8;
        if Result <> nil then aList.Delete(K);
      end;
    except
      Result := nil;
      MainOutMessage(Format('{%s} MagMakeFireCharm.GetObject Code:%d',[g_sExceptionVer, nCode]));
    end;
  end;
begin
  Result := False;
  boHeartSkill:= False;
  K:= 2;
  if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin //ħ���ܹ���Ŀ��
    {$IF M2Version <> 2}
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
      if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
      and
         (TPlayObject(PlayObject).m_MagicSkill_109 <> nil) then begin
        boHeartSkill:= True;
        if PlayObject.m_wStatusArrValue[2] > 0 then
          K:= 4;                     //�����
        if TPlayObject(PlayObject).m_MagicSkill_109.btLevel < 9 then begin
          if g_Config.nSKILL_109NeedHeart[TPlayObject(PlayObject).m_MagicSkill_109.btLevel] <= TPlayObject(PlayObject).m_MagicSkill_105.btLevel then begin
            PlayObject.TrainSkill(TPlayObject(PlayObject).m_MagicSkill_109, Random(3) + 1);
            if not PlayObject.CheckMagicLevelup(TPlayObject(PlayObject).m_MagicSkill_109) then begin
              MaxTrain := TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.MaxTrain[0] + TPlayObject(PlayObject).m_MagicSkill_109.btLevel * (TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.MaxTrain[2]-TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.MaxTrain[1]);
              PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.wMagicId, MaxTrain, TPlayObject(PlayObject).m_MagicSkill_109.btLevel, TPlayObject(PlayObject).m_MagicSkill_109.nTranPoint, '', 1000);
            end;
          end;
        end;
      end;
    end;
    {$IFEND}
    if boHeartSkill then begin//�����
      BaseObjectList := TList.Create;
      try
        PlayObject.m_PEnvir.GetMapBaseObjects(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY, 5, BaseObjectList);
        if BaseObjectList.Count > 0 then begin
          NGSecPwr := PlayObject.m_WAbil.SC;
          if PlayObject.m_wStatusArrValue[2] > 0 then begin
            //��ȥ�޼����������ӵ�SC
            if g_Config.boAbilityAddMode then
            begin
              NGSecPwr := MakeLong(LoWord(NGSecPwr) - PlayObject.m_wStatusArrValue[2], HiWord(NGSecPwr) - PlayObject.m_wStatusArrValue[2]);
            end else NGSecPwr := MakeLong(LoWord(NGSecPwr), HiWord(NGSecPwr) - PlayObject.m_wStatusArrValue[2]);
          end;
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(NGSecPwr),
            SmallInt(HiWord(NGSecPwr) - LoWord(NGSecPwr)) + 1);
          if (PlayObject.m_btRaceServer = RC_HEROOBJECT) and (UserMagic.btLevel = 4) then begin//Ӣ���ж��Ƿ���4������,�ҳ϶ȴﵽ��,���ӹ����� 20080531
            if THeroObject(PlayObject).m_nLoyal >= g_Config.nGotoLV4 then nPower := nPower + g_Config.nPowerLV4;  //����������ͨħ������
          end;
          {$IF M2Version <> 2}
          case PlayObject.m_btRaceServer of//20100228 �޸�
            RC_PLAYOBJECT: begin
              NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_230,nPower);//ŭ֮���
              nPower := _MAX(0, nPower + NGSecPwr);
              if UserMagic.btLevel > 2 then begin
                if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                  if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                    nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[11] /100)));
                  end;
                end;
                if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
                and
                   (TPlayObject(PlayObject).m_MagicSkill_109 <> nil) then begin
                  nPower := nPower + GetPower(MPow(TPlayObject(PlayObject).m_MagicSkill_109));
                end;
                TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
              end;
            end;
            RC_HEROOBJECT: begin
              NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_230,nPower);//ŭ֮���
              nPower := _MAX(0, nPower + NGSecPwr);
            end;
          end;
          {$IFEND}
          if nPower > 0 then begin
            nTwoPwr:= nPower;
            //��ǰĿ��
            if PlayObject.IsProperTarget(TargeTBaseObject) then begin
              nSePwr:= 0;
              NGSecPwr:= 0;
              {$IF M2Version <> 2}
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_231, nTwoPwr);//��֮���
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_231, nTwoPwr);//��֮���
              end;
              {$IFEND}
              nSePwr := _MAX(0, nPower - NGSecPwr);
              PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nSePwr, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 4, Integer(TargeTBaseObject), '', 600);
              {$IF M2Version = 1}
              if nSePwr > 0 then begin//����װ����Ѫ
                if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
                  if Random(100) <= PlayObject.m_nVampireRate then begin
                    NGSecPwr:= 0;
                    NGSecPwr := Random(PlayObject.m_nVampirePoint);
                    if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
                  end;
                end;
              end;
              {$IFEND}
              if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
                if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                  and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                  TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
                end else
                if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                  and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                  TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
                end;
              end;
              Result := True;
              HitObject:= TargeTBaseObject;
            end;
            if HitObject <> nil then begin
              nXX:= TargeTBaseObject.m_nCurrX;
              nYY:= TargeTBaseObject.m_nCurrY;
              for I := 1 to K do begin
                BaseObject := GetObject(BaseObjectList, nXX, nYY);//ȡ���뵱ǰĿ������Ķ���
                if BaseObject <> nil then begin
                  if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                    TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

                  nSePwr:= 0;
                  NGSecPwr:= 0;
                  {$IF M2Version <> 2}
                  if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                    NGSecPwr:= GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_231, nTwoPwr);//��֮���
                  end else
                  if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                    NGSecPwr:= GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_231, nTwoPwr);//��֮���
                  end;
                  {$IFEND}
                  nSePwr := _MAX(0, nPower - NGSecPwr);
                  PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nSePwr, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 4, Integer(BaseObject), '', 300 * I + 500);
                  PlayObject.SendDelayMsg(HitObject, RM_DELAYMAGIC1, 38{����},BaseObject.m_nCurrX{X}, BaseObject.m_nCurrY{Y}, Integer(BaseObject), '', 300 * I + 500);//��ʱ������Ч��
                  HitObject:= BaseObject;//ǰһ������Ŀ��
                  {$IF M2Version = 1}
                  if nSePwr > 0 then begin//����װ����Ѫ
                    if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
                      if Random(100) <= PlayObject.m_nVampireRate then begin
                        NGSecPwr:= 0;
                        NGSecPwr := Random(PlayObject.m_nVampirePoint);
                        if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
                      end;
                    end;
                  end;
                  {$IFEND}
                  if (not BaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not BaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
                    if PlayObject.m_boParalysis3 and (Random(BaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                      and (Random(100) >= BaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                      BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 300 * I+ 500);
                    end else
                    if PlayObject.m_boParalysis2 and (Random(BaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                      and (Random(100) >= BaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                      BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 300 * I+ 500);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
    end else begin//�����
      if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
        if Random(10) >= TargeTBaseObject.m_nAntiMagic then begin
          if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
            if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25


            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
              SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
            if (PlayObject.m_btRaceServer = RC_HEROOBJECT) and (UserMagic.btLevel = 4) then begin//Ӣ���ж��Ƿ���4������,�ҳ϶ȴﵽ��,���ӹ����� 20080531
              if THeroObject(PlayObject).m_nLoyal >= g_Config.nGotoLV4 then nPower := nPower + g_Config.nPowerLV4;  //����������ͨħ������
            end;
            {$IF M2Version <> 2}
            case PlayObject.m_btRaceServer of//20100228 �޸�
              RC_PLAYOBJECT: begin
                NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_230,nPower);//ŭ֮���
                if TargeTBaseObject <> nil then begin
                  if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                    NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end else
                  if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                    NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end;
                end;
                nPower := _MAX(0, nPower + NGSecPwr);
                if UserMagic.btLevel > 2 then begin
                  if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                    if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                      nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[11] /100)));
                    end;
                  end;
                  TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
                end;
              end;
              RC_HEROOBJECT: begin
                NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_230,nPower);//ŭ֮���
                if TargeTBaseObject <> nil then begin
                  if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                    NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end else
                  if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                    NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end;
                end;
                nPower := _MAX(0, nPower + NGSecPwr);
              end;
              RC_PLAYMOSTER: begin
                if TargeTBaseObject <> nil then begin
                  if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                    NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end else
                  if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                    NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_231,nPower);//��֮���
                  end;
                  nPower := _MAX(0, nPower - NGSecPwr);
                end;
              end;
            end;
            {$IFEND}
            if g_Config.boAutoCanHit then begin//��������
              PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), {2}4, Integer(TargeTBaseObject), '', {1200}600);//20110723 �޸����������ķ�Χ
            end else begin
              PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', {1200}600);
            end;
            {$IF M2Version = 1}
            if nPower > 0 then begin//����װ����Ѫ
              if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
                if Random(100) <= PlayObject.m_nVampireRate then begin
                  NGSecPwr:= 0;
                  NGSecPwr := Random(PlayObject.m_nVampirePoint);
                  if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
                end;
              end;
            end;
            {$IFEND}
            if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
            else if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
            if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
              if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
              end else
              if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
              end;
            end;
          end;
        end;
      end;
    end;
  end else TargeTBaseObject := nil;
end;
//��Ѫ�� 20080511
//��ʹ��������Ե�������˺������к󣬻�����ȡ�Է�������Ϊ�Լ��ظ�һ����Ѫ������������ĳЩ�����ϰ���ֱ�����˵�Ҫ����
function TMagicManager.MagFireCharmTreatment(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then //20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
    if Random(10) >= TargeTBaseObject.m_nAntiMagic then begin
      if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
      if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
        NGSecPwr := 0;//20081213
        {$IF M2Version <> 2}
        case PlayObject.m_btRaceServer of//20091202 �޸�
          RC_PLAYOBJECT: begin
            NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_232,nPower);//ŭ֮��Ѫ
            if TargeTBaseObject <> nil then begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end;
            end;
            nPower := _MAX(0, nPower + NGSecPwr);
            if UserMagic.wMagIdx = SKILL_94 then begin
              if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                  nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[12] /100)))
                end;
              end;
              TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
            end;
          end;
          RC_HEROOBJECT: begin
            NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_232,nPower);//ŭ֮��Ѫ
            if TargeTBaseObject <> nil then begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end;
            end;
            nPower := _MAX(0, nPower + NGSecPwr);
          end;
          RC_PLAYMOSTER: begin
            if TargeTBaseObject <> nil then begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_233,nPower);//��֮��Ѫ
              end;
              nPower := _MAX(0, nPower - NGSecPwr);
            end;
          end;
        end;//case
        {$IFEND}
        if g_Config.boAutoCanHit59 then begin//�������� 20090521
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), {2}4, Integer(TargeTBaseObject), '', 1000);//20110723 �޸����������ķ�Χ
        end else begin
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 1000);
        end;
        {$IF M2Version = 1}
        if nPower > 0 then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              NGSecPwr:= 0;
              NGSecPwr := Random(PlayObject.m_nVampirePoint);
              if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
            end;
          end;
        end;
        {$IFEND}
        if PlayObject.m_WAbil.HP < PlayObject.m_WAbil.MaxHP then begin//�ظ�һ����HPֵ
          nPower:= Round(nPower * g_Config.nMagFireCharmTreatment / 100);
          if nPower > 0 then PlayObject.DamageHealth(-nPower);//ֱ��һ�λ�Ѫ
        end;
        case UserMagic.MagicInfo.wMagicId of
          SKILL_59: begin//��Ѫ��
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin//ǿ��ʩ����
              case UserMagic.btLevelEx of
                1: PlayObject.SendRefMsg(RM_10205, 27, 0{X}, 0{Y}, 0, '');
                2: PlayObject.SendRefMsg(RM_10205, 28, 0{X}, 0{Y}, 0, '');
                3: PlayObject.SendRefMsg(RM_10205, 29, 0{X}, 0{Y}, 0, '');
                4: PlayObject.SendRefMsg(RM_10205, 30, 0{X}, 0{Y}, 0, '');
                5: PlayObject.SendRefMsg(RM_10205, 31, 0{X}, 0{Y}, 0, '');
                6: PlayObject.SendRefMsg(RM_10205, 32, 0{X}, 0{Y}, 0, '');
                7: PlayObject.SendRefMsg(RM_10205, 33, 0{X}, 0{Y}, 0, '');
                8: PlayObject.SendRefMsg(RM_10205, 34, 0{X}, 0{Y}, 0, '');
                9: PlayObject.SendRefMsg(RM_10205, 35, 0{X}, 0{Y}, 0, '');
              end;
            end else begin
              {$IF M2Version <> 2}
              if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                  PlayObject.SendRefMsg(RM_10205, 24, 0{X}, 0{Y}, 0, '')
                else  PlayObject.SendRefMsg(RM_MYSHOW, 11, 0, 0, 0, '');
              end else{$IFEND} PlayObject.SendRefMsg(RM_MYSHOW, 11, 0, 0, 0, '');
            end;
          end;
          SKILL_94: begin//�ļ���Ѫ��
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin//ǿ��ʩ����
              case UserMagic.btLevelEx of
                1: PlayObject.SendRefMsg(RM_10205, 27, 0{X}, 0{Y}, 0, '');
                2: PlayObject.SendRefMsg(RM_10205, 28, 0{X}, 0{Y}, 0, '');
                3: PlayObject.SendRefMsg(RM_10205, 29, 0{X}, 0{Y}, 0, '');
                4: PlayObject.SendRefMsg(RM_10205, 30, 0{X}, 0{Y}, 0, '');
                5: PlayObject.SendRefMsg(RM_10205, 31, 0{X}, 0{Y}, 0, '');
                6: PlayObject.SendRefMsg(RM_10205, 32, 0{X}, 0{Y}, 0, '');
                7: PlayObject.SendRefMsg(RM_10205, 33, 0{X}, 0{Y}, 0, '');
                8: PlayObject.SendRefMsg(RM_10205, 34, 0{X}, 0{Y}, 0, '');
                9: PlayObject.SendRefMsg(RM_10205, 35, 0{X}, 0{Y}, 0, '');
              end;
            end else begin
              {$IF M2Version <> 2}
              if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                  PlayObject.SendRefMsg(RM_10205, 25, 0{X}, 0{Y}, 0, '')
                else PlayObject.SendRefMsg(RM_MYSHOW, 12, 0, 0, 0, '');
              end else{$IFEND} PlayObject.SendRefMsg(RM_MYSHOW, 12, 0, 0, 0, '');
            end;
          end;
        end;
        if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
        else if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
        if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
          if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
            and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
            TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
          end else
          if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
            and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
            TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
          end;
        end;
      end;
    end;
  end;
end;


{$IF M2Version <> 2}
//�����ķ�(����)
function TMagicManager.MagBigExplosion_105(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
begin
  Result := False;
  try
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
      if (GetTickCount - TPlayObject(PlayObject).m_HeartArrTick) > 2400 then begin//�ķ�����ʱ�� 20110926
        TPlayObject(PlayObject).m_HeartArrTick:= GetTickCount();
        if TPlayObject(PlayObject).m_Skill69NH >= g_Config.nActivHeartNH then begin
          PlayObject.SendRefMsg(RM_10205, 26, 0{X}, 0{Y}, 0, ''); //�������Ч��
          PlayObject.SendDelayMsg(PlayObject, RM_SHOWHEARTEFF, 0, 0, Integer(PlayObject), 0, '', 2400);
          Result := True;
        end else PlayObject.SysMsg(Format(sSkill105Fail,[g_Config.nActivHeartNH, UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);
      end;
    end;
  except
    MainOutMessage(Format('{%s} TMagicManager.MagBigExplosion_105',[g_sExceptionVer]));
  end;
end;

//����֮��
function TMagicManager.MagMakeFireCharm_110(PlayObject: TBaseObject; UserMagic: pTUserMagic;
 var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
var
  nPower, nSePwr, I, nPosionTime, nX, nY: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  BaseObjectList := TList.Create;
  nX:= nTargetX;
  nY:= nTargetY;
  if TargeObject <> nil then begin
    nX:= TargeObject.m_nCurrX;
    nY:= TargeObject.m_nCurrY;
    nTargetX:= nX;
    nTargetY:= nY;
  end;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    if BaseObjectList.Count > 0 then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
        SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
      nPosionTime:= 3 + UserMagic.btLevel div 4;//��ȼ�������������5��
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin
          if PlayObject.IsProperTarget(TargeTBaseObject) then begin
            PlayObject.SetTargetCreat(TargeTBaseObject);
            if (UserMagic <> nil) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(PlayObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

            if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
              TargeTBaseObject.MakePosion(POISON_STONE {�ж����� - ���}, nPosionTime{ʱ��}, 0);//���
            end;
            PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 4, Integer(TargeTBaseObject), '', 600);
            Result := True;
            TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {�ж����� - �춾}, nPower, Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 600);
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nPower > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(PlayObject.m_nVampirePoint);
            if nSePwr > 0 then PlayObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.free;
  end;
end;
//��˪Ⱥ��
function TMagicManager.MagMakeFireCharm_111(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
var
  nPower, nSePwr, I, nPosionTime, nX, nY: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  nX:= nTargetX;
  nY:= nTargetY;
  if TargeObject <> nil then begin
    nX:= TargeObject.m_nCurrX;
    nY:= TargeObject.m_nCurrY;
    nTargetX:= nX;
    nTargetY:= nY;
  end;
  BaseObjectList := TList.Create;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nX + 2, nY + 3, nRage, BaseObjectList);
    PlayObject.m_PEnvir.GetMapBaseObjects(nX - 2, nY - 3, nRage, BaseObjectList);
    PlayObject.m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    PlayObject.m_PEnvir.GetMapBaseObjects(nX + 2, nY - 3, nRage, BaseObjectList);
    PlayObject.m_PEnvir.GetMapBaseObjects(nX - 2, nY + 3, nRage, BaseObjectList);
    if BaseObjectList.Count > 0 then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
        SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      nPosionTime:= 3 + UserMagic.btLevel div 4;//��ȼ�������������5��
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin
          if PlayObject.IsProperTarget(TargeTBaseObject) then begin
            if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

            PlayObject.SetTargetCreat(TargeTBaseObject);
            PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 4, Integer(TargeTBaseObject), '', 1000);
            Result := True;
            if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
              TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, nPosionTime{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
            end;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nPower > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(PlayObject.m_nVampirePoint);
            if nSePwr > 0 then PlayObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.free;
  end;
end;

//ʮ��һɱ
function TMagicManager.MagMakeFireCharm_112(PlayObject: TBaseObject; UserMagic: pTUserMagic;
 var nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject; var boSpellFire: Boolean): Boolean;
var
  nPower, nSePwr, I, nPosionTime: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nX, nY, n1C, n10, nDir: Integer;

  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;

  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;

  function GetLeftPosition(nDir: Byte; var nX, nY: Integer): Boolean;
  var
    Envir: TEnvirnoment;
  begin
    Envir := PlayObject.m_PEnvir;
    nX := nTargetX;
    nY := nTargetY;
    case nDir of
      DR_UP{0}: if nX > 0 then Dec(nY);
      DR_DOWN{4}: if nX < (Envir.m_nWidth - 1) then Inc(nY);
      DR_LEFT{6}: if nY > 0 then Dec(nX);
      DR_RIGHT{2}: if nY < (Envir.m_nHeight - 1) then Inc(nX);
      DR_UPLEFT{������}: begin
          if (nX > 0) and (nY > 0) then begin
            Dec(nX);
            Dec(nY);
          end;
        end;
      DR_UPRIGHT{������}: begin
          if (nX > 0) and (nY < (Envir.m_nHeight - 1)) then begin
            Inc(nX);
            Dec(nY);
          end;
        end;
      DR_DOWNLEFT{������}: begin
          if (nX < (Envir.m_nWidth - 1)) and (nY > 0) then begin
            Dec(nX);
            Inc(nY);
          end
        end;
      DR_DOWNRIGHT{������}: begin
          if (nX < (Envir.m_nWidth - 1)) and (nY < (Envir.m_nHeight - 1)) then begin
            Inc(nX);
            Inc(nY);
          end;
        end;
    end;
    Result := True;
  end;

begin
  Result := False;
  if (abs(PlayObject.m_nCurrX - nTargetX) > 8) or (abs(PlayObject.m_nCurrY - nTargetY) > 8) then Exit;
  boSpellFire := False;
  PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,
    MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
    MakeLong(nTargetX, nTargetY), Integer(TargeObject), '');

  if (abs(PlayObject.m_nCurrX - nTargetX) > 1) or (abs(PlayObject.m_nCurrY - nTargetY) > 1) then begin
    nDir := PlayObject.GetBackDir(PlayObject.m_btDirection); // ����ǵõ�����
    GetLeftPosition(nDir, nX, nY);
    n1C:= 8;
    while (True) do begin
      try
        if not PlayObject.m_PEnvir.CanWalk(nX, nY, False) then begin//��������ߵ���������
          //n10 := (nDir + n1C) mod 8;
          //GetLeftPosition(n10, nX, nY);
          Exit;
        end else Break;
        Dec(n1C);
        if n1C >= 0 then Break;
      except
        Break;
      end;
    end;
    PlayObject.m_PEnvir.DeleteFromMap(PlayObject.m_nCurrX, PlayObject.m_nCurrY, OS_MOVINGOBJECT, PlayObject);
    PlayObject.m_nCurrX:= nX;
    PlayObject.m_nCurrY:= nY;
    PlayObject.m_btDirection := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
    PlayObject.m_PEnvir.AddToMap(PlayObject.m_nCurrX, PlayObject.m_nCurrY, OS_MOVINGOBJECT, PlayObject);
    PlayObject.SendRefMsg(RM_SPACEMOVE_SHOW3, PlayObject.m_btDirection, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0, '');
  end;
  PlayObject.SendRefMsg(RM_10205, 40, nTargetX, nTargetY, 0, '');//��ʾЧ��
  BaseObjectList := TList.Create;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, nRage, BaseObjectList);
    if BaseObjectList.Count > 0 then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.DC),
        SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1);
      nPosionTime:= 3 + UserMagic.btLevel div 4;//��ȼ���������߶���5��
      for I := 0 to BaseObjectList.Count - 1 do begin
        nSePwr:= nPower;
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin
          if PlayObject.IsProperTarget(TargeTBaseObject) then begin
            if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

            if TargeTBaseObject = TargeObject then begin//��ǰĿ��
              Inc(nSePwr, Round(nPower * 0.25));
              //����״̬
              TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, 65535{�ж����� - ����}, nPosionTime{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
            end;
            PlayObject.SetTargetCreat(TargeTBaseObject);
            PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nSePwr, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 4, Integer(TargeTBaseObject), '', 600);
            Result := True;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nPower > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(PlayObject.m_nVampirePoint);
            if nSePwr > 0 then PlayObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.free;
  end;
end;


//��������
function TMagicManager.MagMakeFireCharm_113(BaseObject: TBaseObject; UserMagic: pTUserMagic;
  nTime, nX, nY: Integer;TargeObject: TBaseObject; var boSpellFire: Boolean): Integer;
var
  I, nPower: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  HolyCurtainEvent: THolyCurtainLockEvent;
begin
  Result := 0;
  if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
    if BaseObject.m_PEnvir.CanWalk(nX, nY, True) then begin
      boSpellFire := False;
      BaseObject.m_nHolyCurtainLockX := nX;
      BaseObject.m_nHolyCurtainLockY := nY;
      BaseObjectList:= TList.Create;
      try
        BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, 2, BaseObjectList);
        if BaseObjectList.Count > 0 then begin
          nPower := BaseObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(BaseObject.m_WAbil.MC),
            SmallInt(HiWord(BaseObject.m_WAbil.MC) - LoWord(BaseObject.m_WAbil.MC)) + 1);
          nPower := Round(nPower * 1.5);
          for I := 0 to BaseObjectList.Count - 1 do begin
            TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
            if TargeTBaseObject.m_boDeath or (TargeTBaseObject.m_boGhost) then Continue;
            if BaseObject.IsProperTarget(TargeTBaseObject) then begin
              if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
                if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                  TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

                BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 600);
                if (BaseObject.m_btRaceServer = RC_PLAYMOSTER) or (BaseObject.m_btRaceServer = RC_HEROOBJECT) then Result := 1
                else if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := 1;
              end;
            end;
          end;
        end;
      finally
        BaseObjectList.Free;
      end;
      BaseObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,
        MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
        MakeLong(nX, nY), Integer(TargeObject), '');
      Result := 1;
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY - 2, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY - 1, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY + 1, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY + 2, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 3, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);

      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY - 2, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY - 1, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY + 1, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY + 2, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 3, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);

      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 2, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 1, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 1, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 2, nY - 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);

      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 2, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX - 1, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 1, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      HolyCurtainEvent := THolyCurtainLockEvent.Create(BaseObject, nX + 2, nY + 3, ET_NOTGOTO, nTime * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);

      TPlayObject(BaseObject).dw_SkillHitTick := GetTickCount();
      TPlayObject(BaseObject).m_SkillHit_113:= 4;
      TPlayObject(BaseObject).m_SkillHit_X:= nX;
      TPlayObject(BaseObject).m_SkillHit_Y:= nY;
      BaseObject.m_nCharStatus := BaseObject.GetCharStatus();
      BaseObject.StatusChanged('');
    end;
  end;
end;
//ŭ�ɻ���
function TMagicManager.MagMakeFireCharm_114(PlayObject: TBaseObject; UserMagic: pTUserMagic;
   var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, nRate, nIncHp, nIncMp, nSePwr, I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  if TargeTBaseObject = nil then begin
    TargeTBaseObject := PlayObject;
    nTargetX := TargeTBaseObject.m_nCurrX;
    nTargetY := TargeTBaseObject.m_nCurrY;
  end;
  if PlayObject.IsProperFriend(TargeTBaseObject) then begin
    nRate:= 10 + (UserMagic.btLevel div 4) * 10;//��ȼ�����,˲��ָ�Ŀ��Ѫ�����޺�ħ�����ޱ���
    nIncHP:= _MIN(100000 ,Round(TargeTBaseObject.m_WAbil.MaxHP * (nRate / 100)));
    nIncMP:= _MIN(100000 ,Round(TargeTBaseObject.m_WAbil.MaxMP * (nRate / 100)));
    TargeTBaseObject.IncHealthSpell(nIncHP, nIncMP);
    Result := True;
  end;
  nPower := _MIN(20 ,Round(2.2 * UserMagic.btLevel));//�˺�����
  if nPower <= 0 then nPower:= 2;
  BaseObjectList := TList.Create;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, 1, BaseObjectList);
    if BaseObjectList.Count > 0 then begin
      for I := 0 to BaseObjectList.Count - 1 do begin
        BaseObject := TBaseObject(BaseObjectList.Items[I]);
        if BaseObject <> nil then begin
          if PlayObject.IsProperTarget(BaseObject) and (not PlayObject.IsProperFriend(BaseObject)) then begin
            if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
            nSePwr:= Round(TargeTBaseObject.m_WAbil.MaxHP * (nPower / 100));
            PlayObject.SetTargetCreat(BaseObject);
            Result := True;
            if nSePwr > 0 then
              PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 4, Integer(BaseObject), '', 1000);
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nPower > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(PlayObject.m_nVampirePoint);
            if nSePwr > 0 then PlayObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.free;
  end;
end;

//Ѫ��һ��(��)
function TMagicManager.MagMakeFireCharm_98(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; nRage: Integer; var TargeObject: TBaseObject): Boolean;
var
  nPower, nSePwr, nSpellPoint, nTwoPwr, I, nLevelPoor: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
  function GetSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    Result := Round(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
  end;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  case PlayObject.m_btRaceServer of
    RC_PLAYOBJECT: begin
      if TPlayObject(PlayObject).m_Skill69NH < nSpellPoint then begin //������ֵ��û����ֵ��HP
        if g_Config.dwNotGNDecHPRate > 0 then begin
          PlayObject.DamageHealth(Abs(Round(PlayObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
          PlayObject.HealthSpellChanged();
        end;
      end else begin
        TPlayObject(PlayObject).m_Skill69NH := _MAX(0, TPlayObject(PlayObject).m_Skill69NH - nSpellPoint);
        PlayObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(PlayObject).m_Skill69NH, TPlayObject(PlayObject).m_Skill69MaxNH, 0, '');
      end;
    end;
    RC_HEROOBJECT: begin
      if THeroObject(PlayObject).m_Skill69NH < nSpellPoint then begin //������ֵ��û����ֵ��HP
        if g_Config.dwNotGNDecHPRate > 0 then begin
          PlayObject.DamageHealth(Abs(Round(PlayObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
          PlayObject.HealthSpellChanged();
        end;
      end else begin
        THeroObject(PlayObject).m_Skill69NH := _MAX(0, THeroObject(PlayObject).m_Skill69NH - nSpellPoint);
        THeroObject(PlayObject).SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(PlayObject).m_Skill69NH, THeroObject(PlayObject).m_Skill69MaxNH, 0, '');
      end;
    end;
    RC_PLAYMOSTER: begin
      if PlayObject.m_Master <> nil then Exit;
      if g_Config.dwNotGNDecHPRate > 0 then begin
        PlayObject.DamageHealth(Abs(Round(PlayObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
        PlayObject.HealthSpellChanged();
      end;
    end;
    else Exit;
  end;
  PlayObject.m_dwLatestBloodSoulTick:= GetTickCount();
  nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
    SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
  BaseObjectList := TList.Create;
  try
    PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, nRage, BaseObjectList);
    nTwoPwr:= nPower;
    if BaseObjectList.Count > 0 then begin
      if (Random(g_Config.dwBloodSoulRate) = 0) then
        nPower := Round(nPower * (g_Config.nBloodSoulHitRate / 100));//��������

      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin
          if PlayObject.IsProperTarget(TargeTBaseObject) then begin
            if Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10 then begin//ħ�����
              if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25

              nSePwr:= nPower;
              if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin //����Ӣ��������,����������
                 if not THeroObject(PlayObject).m_boTarget then PlayObject.SetTargetCreat(TargeTBaseObject);
              end else PlayObject.SetTargetCreat(TargeTBaseObject);
              if g_Config.boUseNewAttackFFT_96 then begin
                nLevelPoor:= 0;
                nLevelPoor:= TargeTBaseObject.m_Abil.Level - PlayObject.m_Abil.Level;
                if nLevelPoor > 50 then nLevelPoor := 50;
                if nLevelPoor > 0 then Inc(nSePwr, Round(nTwoPwr * nLevelPoor * 0.05));//20100701 �޸ģ����ȼ�����������
              end else begin
                if TargeTBaseObject.m_Abil.Level > PlayObject.m_Abil.Level then Inc(nSePwr, Round(nTwoPwr * 0.05));
              end;
              TargeTBaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nSePwr, 0, 0, '');
              if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)
                 or ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL)) then Result := True;
              if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
                if TargeObject = TargeTBaseObject then begin//20100928 ����
                  if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
                  end else
                  if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nSePwr > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(PlayObject.m_nVampirePoint);
            if nSePwr > 0 then PlayObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.free;
  end;
end;

//Ѫ��һ��(��)
function TMagicManager.MagBigExplosion_97(BaseObject: TBaseObject; nPower, nX,
  nY: Integer; nRage: Integer; UserMagic: pTUserMagic; var TargeObject: TBaseObject): Boolean;
var
  I,nSePwr, nTwoPwr, nSpellPoint, nLevelPoor: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function GetSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    Result := Round(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
  end;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  case BaseObject.m_btRaceServer of
    RC_PLAYOBJECT: begin
      if TPlayObject(BaseObject).m_Skill69NH < nSpellPoint then begin //������ֵ��û����ֵ��HP
        if g_Config.dwNotGNDecHPRate > 0 then begin
          BaseObject.DamageHealth(Abs(Round(BaseObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
          BaseObject.HealthSpellChanged();
        end;
      end else begin
        TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - nSpellPoint);
        BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
      end;
    end;
    RC_HEROOBJECT: begin
      if THeroObject(BaseObject).m_Skill69NH < nSpellPoint then begin //������ֵ��û����ֵ��HP
        if g_Config.dwNotGNDecHPRate > 0 then begin
          BaseObject.DamageHealth(Abs(Round(BaseObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
          BaseObject.HealthSpellChanged();
        end;
      end else begin
        THeroObject(BaseObject).m_Skill69NH := _MAX(0, THeroObject(BaseObject).m_Skill69NH - nSpellPoint);
        THeroObject(BaseObject).SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject).m_Skill69NH, THeroObject(BaseObject).m_Skill69MaxNH, 0, '');
      end;
    end;
    RC_PLAYMOSTER: begin
      if BaseObject.m_Master <> nil then Exit;
      if g_Config.dwNotGNDecHPRate > 0 then begin
        BaseObject.DamageHealth(Abs(Round(BaseObject.m_WAbil.HP * (g_Config.dwNotGNDecHPRate / 100))));
        BaseObject.HealthSpellChanged();
      end;
    end;
    else Exit;
  end;
  BaseObject.m_dwLatestBloodSoulTick:= GetTickCount();
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    nTwoPwr:= nPower;
    if BaseObjectList.Count > 0 then begin
      if (Random(g_Config.dwBloodSoulRate) = 0) then
        nPower := Round(nPower * (g_Config.nBloodSoulHitRate / 100));//��������

      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin
          if BaseObject.IsProperTarget(TargeTBaseObject) then begin
            if Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10 then begin//ħ�����
              if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
              nSePwr:= nPower;
              if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin //����Ӣ��������,����������
                 if not THeroObject(BaseObject).m_boTarget then BaseObject.SetTargetCreat(TargeTBaseObject);
              end else BaseObject.SetTargetCreat(TargeTBaseObject);
              if g_Config.boUseNewAttackFFT_96 then begin
                nLevelPoor:= 0;
                nLevelPoor:= TargeTBaseObject.m_Abil.Level - BaseObject.m_Abil.Level;
                if nLevelPoor > 50 then nLevelPoor := 50;
                if nLevelPoor > 0 then Inc(nSePwr, Round(nTwoPwr * nLevelPoor * 0.05));//20100701 �޸ģ����ȼ�����������
              end else begin
                if TargeTBaseObject.m_Abil.Level > BaseObject.m_Abil.Level then Inc(nSePwr, Round(nTwoPwr * 0.05));
              end;
              TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nSePwr, 0, 0, '');
              if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
                if TargeObject = TargeTBaseObject then begin//20100928 ����
                  if BaseObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
                    TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(BaseObject), 0{����}, '', 600);
                  end else
                  if BaseObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
                    TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(BaseObject), 0{����}, '', 600);
                  end;
                end;
              end;
              Result := True;
            end;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nSePwr > 0) and Result then begin//����װ����Ѫ
        if (BaseObject.m_nVampirePoint > 0) and ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= BaseObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(BaseObject.m_nVampirePoint);
            if nSePwr > 0 then BaseObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.Free;
  end;
end;

//�ڹ����ܵ�����ֵ,
function TMagicManager.GetNGPow(BaseObject: TBaseObject; UserMagic: pTUserMagic; Power: Integer): Integer;
  function MPow1(UserMagic: pTUserMagic): Integer;//���㼼������
  var nPower:Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then
      nPower := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else nPower := UserMagic.MagicInfo.wPower;
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then
      Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := nPower + (UserMagic.btLevel * UserMagic.MagicInfo.btDefPower);
  end;
var nNHPoint:Integer;
begin
  Result := 0;
  if (UserMagic <> nil) and (BaseObject <> nil) then begin
    if UserMagic.btKey = 0 then begin//�ڹ����ܿ��� 20110426
      case BaseObject.m_btRaceServer of
        RC_PLAYOBJECT: begin
          nNHPoint := TPlayObject(BaseObject).GetSpellPoint(UserMagic);
          if TPlayObject(BaseObject).m_Skill69NH >= nNHPoint then begin
            TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - nNHPoint);
            TPlayObject(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
            if g_Config.nNGSkillRate = 0 then begin
              Result := MPow1(UserMagic);
            end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
            TPlayObject(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
          end;
        end;
        RC_HEROOBJECT: begin
          nNHPoint := THEROOBJECT(BaseObject).GetSpellPoint(UserMagic);
          if THEROOBJECT(BaseObject).m_Skill69NH >= nNHPoint then begin
            THEROOBJECT(BaseObject).m_Skill69NH := _MAX(0, THEROOBJECT(BaseObject).m_Skill69NH - nNHPoint);
            THEROOBJECT(BaseObject).SendREFMsg( RM_MAGIC69SKILLNH, 0, THEROOBJECT(BaseObject).m_Skill69NH, THEROOBJECT(BaseObject).m_Skill69MaxNH, 0, '');
            if g_Config.nNGSkillRate = 0 then begin
              Result := MPow1(UserMagic);
            end else Result := Round(Power * ((UserMagic.btLevel + 1) * (g_Config.nNGSkillRate / 100)));//���㹥����
            THEROOBJECT(BaseObject).NGMAGIC_LVEXP(UserMagic);//�ڹ���������
          end;
        end;
      end;
    end;
  end;
end;
{$IFEND}
//����� ֧��4������(��������)
function TMagicManager.MagMakeFireDay(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then //20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin
    if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
      if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
        SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then nPower := Round(nPower * 1.5);
      if (PlayObject.m_btRaceServer = RC_HEROOBJECT) and (UserMagic.btLevel = 4) then begin
         if THeroObject(PlayObject).m_nLoyal >=g_Config.nGotoLV4 then nPower := nPower + g_Config.nPowerLV4;//����������ͨħ������
      end;
      NGSecPwr := 0;//20081217
      {$IF M2Version <> 2}
      if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_228,nPower);//ŭ֮�����
        if TargeTBaseObject <> nil then begin
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
            NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_229,nPower);//��֮�����
          end else
          if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
            NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_229,nPower);//��֮�����
          end;
        end;
        nPower := _MAX(0, nPower + NGSecPwr);
        if UserMagic.btLevel > 2 then begin
          //����ǿ�����ܵ�����
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[8] /100)))
            end;
          end;
          TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
        end;
      end else
      if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
        NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_228,nPower);//ŭ֮�����
        if TargeTBaseObject <> nil then begin
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
            NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_229,nPower);//��֮�����
          end else
          if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
            NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_229,nPower);//��֮�����
          end;
        end;
        nPower := _MAX(0, nPower + NGSecPwr);
      end;
      {$IFEND}
      if g_Config.boAutoCanHit45 then begin
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 600);
      end else PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY), 2, Integer(TargeTBaseObject), '', 600);
      {$IF M2Version = 1}
      if nPower > 0 then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            NGSecPwr:= 0;
            NGSecPwr := Random(PlayObject.m_nVampirePoint);
            if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
          end;
        end;
      end;
      {$IFEND}
      if g_Config.boPlayObjectReduceMP then begin//���м�MPֵ,��35% 20090104
        TargeTBaseObject.DamageSpell(Abs(Round(nPower * 0.35)));
      end;
      if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
      else if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
      if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з���
        if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3{5}) = 0)
          and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
        end else
        if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
          and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
        end;
      end;
    end else TargeTBaseObject := nil
  end else TargeTBaseObject := nil;
end;

{�ⶾ��}
function TMagicManager.MagMakeUnTreatment(PlayObject: TBaseObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if TargeTBaseObject = nil then begin
    TargeTBaseObject := PlayObject;
   // nTargetX := PlayObject.m_nCurrX;  20080117ע��
   // nTargetY := PlayObject.m_nCurrY;  20080117ע��
  end;
  if PlayObject.IsProperFriend(TargeTBaseObject) then begin
    if Random(7) - (UserMagic.btLevel + 1) < 0 then begin
      if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
      if TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] := 1;
        Result := True;
      end;
      if TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] := 1;
        Result := True;
      end;
      if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] := 1;
        Result := True;
      end;
      if TargeTBaseObject.m_wStatusTimeArr[POISON_LOCKSPELL{7}] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_LOCKSPELL{7}] := 1;
        Result := True;
      end;
    end;
  end;
end;

{������}
function TMagicManager.MagMakeLivePlayObject(PlayObject: TBaseObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if PlayObject.IsProperTargetSKILL_57(TargeTBaseObject) then begin
    if (Random(10 + UserMagic.btLevel) + UserMagic.btLevel) >= 8 then begin
      if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
        TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
      TPlayObject(TargeTBaseObject).ReAlive;
      TPlayObject(TargeTBaseObject).m_WAbil.HP := TPlayObject(TargeTBaseObject).m_WAbil.MaxHP;
      if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin//20090501 �޸�
        TPlayObject(TargeTBaseObject).SendMsg(TPlayObject(TargeTBaseObject), RM_ABILITY, 0, 0, 0, 0, '');
      end else
      if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin//20090501 �޸�
        THeroObject(TargeTBaseObject).SendMsg(TargeTBaseObject, RM_HEROABILITY, 0, 0, 0, 0, '');
      end;
      Result := True;
    end;
  end;
end;

{������}
function TMagicManager.MagMakeArrestObject(PlayObject: TBaseObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
var
  nX, nY: Integer;
begin
  Result := False;
  if (GetTickCount - PlayObject.m_dwSkill55Tick > g_Config.nKill55UseTime * 1000) then begin
    if PlayObject.IsProperTargetSKILL_55(PlayObject.m_WAbil.Level, TargeTBaseObject) then begin
      if (Random(10 + UserMagic.btLevel) + UserMagic.btLevel) >= 5 then begin
        if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
          TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
        PlayObject.m_dwSkill55Tick:= GetTickCount();
        PlayObject.GetFrontPosition(nX, nY);
        //���ӽ������򲻿�ץ
        if not TargeTBaseObject.InMag113LockRect(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY) then begin
          TargeTBaseObject.SpaceMove(TargeTBaseObject.m_PEnvir.sMapName, nX, nY, 0);
          TargeTBaseObject.SendRefMsg(RM_MONMOVE, 0, nX, nY, 0, '');
          Result := True;
        end;
        
      end;
    end;
  end;
end;
{���л�λ--δʹ��}
function TMagicManager.MagChangePosition2(PlayObject: TBaseObject; {�޸� TBaseObject} nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
//var
 { I,nX, nY, olddir, oldx, oldy, nBackDir, nDir: Integer;}
 // n01: Integer; 20080117ע��
begin
  Result := False;
//  n01 := 0; 20080117ע��
  if not PlayObject.m_boOnHorse then begin
   // if PlayObject.IsProperTargetSKILL_56(TargeTBaseObject, nTargetX, nTargetY) then begin
      //nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
    PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
    PlayObject.SpaceMove(PlayObject.m_PEnvir.sMapName, nTargetX, nTargetY, 0);
    Result := True;
    //end;
  end;
end;

{���л�λ}
function TMagicManager.MagChangePosition(PlayObject: TBaseObject; nTargetX, nTargetY: Integer): Boolean;
begin
  Result := False;
  if not PlayObject.m_boOnHorse and (not PlayObject.InMag113LockRect(PlayObject.m_nCurrX, PlayObject.m_nCurrY)) then begin
    if PlayObject.m_PEnvir.CanWalk(nTargetX, nTargetY, True) and (PlayObject.m_PEnvir.GetXYObjCount(nTargetX, nTargetY) = 0) then begin
      PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      PlayObject.SpaceMove2(nTargetX, nTargetY, 0);
      Result := True;
    end;
  end;
end;
{$IF HEROVERSION = 1}
//�ƻ�ն ս+ս
function TMagicManager.MagMakeSkillFire_60(PlayObject: TBaseObject; UserMagic: pTUserMagic; nPower: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerValue, NGSecPwr: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    PlayObject.GetDirectionBaseObjects(PlayObject.m_btDirection, g_Config.nHeroAttackRange_60, BaseObjectList);//�Լ������Ŀ��
    if BaseObjectList.Count > 0 then begin//20080629
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);  //Ŀ��
        if PlayObject.IsProperTarget(TargeTBaseObject) then begin
          if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
          if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin//�ϻ������Լ���Ӣ�� 20090126
            if (TPlayObject(PlayObject).m_MyHero <> nil) and (TargeTBaseObject <> nil) then begin
              if TPlayObject(PlayObject).m_MyHero = TargeTBaseObject then Continue;
            end;
          end;

          if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
            if not THeroObject(PlayObject).m_boTarget then PlayObject.SetTargetCreat(TargeTBaseObject);
          end else PlayObject.SetTargetCreat(TargeTBaseObject);
          
          if Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10 then begin//20090526 ����ħ�����
            nPowerValue := Round(nPower * (g_Config.nHeroAttackRate_60 / 100));
            if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
              nPowerValue := Round(nPowerValue * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
              if TPlayObject(PlayObject).m_nIncDragon > 0 then Inc(nPowerValue, TPlayObject(PlayObject).m_nIncDragon);
            end else
            if (PlayObject.m_btRaceServer =RC_HEROOBJECT) then begin
              nPowerValue := Round(nPowerValue * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
              if THeroObject(PlayObject).m_nIncDragon > 0 then Inc(nPowerValue, THeroObject(PlayObject).m_nIncDragon);
            end;

            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT) or
              ((TargeTBaseObject.m_btRaceServer = RC_PLAYMOSTER) and (TargeTBaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
               nPowerValue :=Round(nPowerValue* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
               if TargeTBaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                 nPowerValue :=Round(nPowerValue* (1 - g_Config.nDecDragonHitPoint / 100));
                 TargeTBaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
               end;
            end;
            TargeTBaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nPowerValue, 0, 0, ''); //����Ŀ����Ϣ
            if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
              case TargeTBaseObject.m_btRaceServer of
                RC_PLAYOBJECT: begin
                  if TPlayObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                    TPlayObject(TargeTBaseObject).m_Skill69NH := _MAX(0, TPlayObject(TargeTBaseObject).m_Skill69NH - Round(nPowerValue * g_Config.n4SKillDecNHRate / 100));
                    TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(TargeTBaseObject).m_Skill69NH, TPlayObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                    TargeTBaseObject.DamageSpell(Round(nPowerValue * g_Config.n4SKillDecMPRate / 100) + 1);//����
                    TargeTBaseObject.HealthSpellChanged();
                  end;
                end;
                RC_HEROOBJECT: begin
                  if THeroObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                    THeroObject(TargeTBaseObject).m_Skill69NH := _MAX(0, THeroObject(TargeTBaseObject).m_Skill69NH - Round(nPowerValue * g_Config.n4SKillDecNHRate / 100));
                    TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(TargeTBaseObject).m_Skill69NH, THeroObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                    TargeTBaseObject.DamageSpell(Round(nPowerValue * g_Config.n4SKillDecMPRate / 100) + 1);//����
                    TargeTBaseObject.HealthSpellChanged();
                  end;
                end;
              end;
            end;
            PlayObject.SendRefMsg(RM_MAGICFIRE, 0, //����������Ϣ  20080105
              MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
              MakeLong(TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY),
              Integer(TargeTBaseObject),
              '');
            Result := True;
          end;
        end;
      end;
      {$IF M2Version = 1}
      if (nPowerValue > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            NGSecPwr:= 0;
            NGSecPwr := Random(PlayObject.m_nVampirePoint);
            if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.Free;
  end;
end;
//����ն  ս+��
function TMagicManager.MagMakeSkillFire_61(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then //20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
var
  nPower, nSwrPower: Integer;
  nCode: Byte;
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;  
begin
  nCode:= 0;
  nPower := 0;
  Result := False;
  try
    BaseObjectList := TList.Create;
    try
      PlayObject.GetMapBaseObjects_61(PlayObject.m_PEnvir, nTargetX, nTargetY, 3, BaseObjectList);
      if TargeTBaseObject <> nil then BaseObjectList.Add(TargeTBaseObject); 
      if BaseObjectList.Count > 0 then begin
        with PlayObject do begin
          case m_btJob of
            2: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.SC), SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1) * 2;
            0: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)) + 1) * 2;
          end;
        end;
        nCode:=4;
        nPower := Round(nPower * (g_Config.nHeroAttackRate_61 / 100));//����ն����
        case PlayObject.m_btRaceServer of
          RC_PLAYOBJECT: begin
             nPower := Round(nPower * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����)
             if TPlayObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, TPlayObject(PlayObject).m_nIncDragon);
           end;
          RC_HEROOBJECT: begin
             nPower := Round(nPower * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����)
             if THeroObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, THeroObject(PlayObject).m_nIncDragon);
           end;
        end;
        for I := 0 to BaseObjectList.Count - 1 do begin
          BaseObject := TBaseObject(BaseObjectList.Items[I]);
          if BaseObject = nil then Continue;
          if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
          if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
            if (TPlayObject(PlayObject).m_MyHero <> nil) then begin//�����Լ�Ӣ��
              if (TPlayObject(PlayObject).m_MyHero = BaseObject) then Continue;
            end;
          if (PlayObject.m_btRaceServer = RC_HEROOBJECT) and (PlayObject.m_Master <> nil) then
            if (PlayObject.m_Master = BaseObject) then Continue;
          if PlayObject.IsProperTarget(BaseObject) then begin
            if Random(BaseObject.m_nAntiMagic + 10) <= 10 then begin//ħ�����
              if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
              nSwrPower:= nPower;
              if BaseObject <> nil then begin
                if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT) or
                  ((BaseObject.m_btRaceServer = RC_PLAYMOSTER) and (BaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
                   nCode:=8;
                   nSwrPower :=Round(nSwrPower * (g_Config.nDecDragonRate / 100));//�ϻ����˵��˺�����
                   if BaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                     nCode:=9;
                     nSwrPower :=Round(nSwrPower* (1 - g_Config.nDecDragonHitPoint / 100));
                     BaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч��
                   end;
                end;
                case (abs(nTargetX - BaseObject.m_nCurrX) + abs(nTargetY - BaseObject.m_nCurrY)) of//����������� 20100226
                  0:;
                  1..2: nSwrPower :=Round(nSwrPower * 0.8);
                  3..4: nSwrPower :=Round(nSwrPower * 0.6);
                  else nSwrPower :=Round(nSwrPower * 0.4);
                end;
                PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nSwrPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 2, Integer(BaseObject), '', 500);
                if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
                  case BaseObject.m_btRaceServer of
                    RC_PLAYOBJECT: begin
                      if TPlayObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                        TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - Round(nSwrPower * g_Config.n4SKillDecNHRate / 100));
                        BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
                        BaseObject.DamageSpell(Round(nSwrPower * g_Config.n4SKillDecMPRate / 100) + 1);//����
                        BaseObject.HealthSpellChanged();
                        if (BaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 0) and (Random(5) = 0) then BaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//��ħ����
                      end;
                    end;
                    RC_HEROOBJECT: begin
                      if THeroObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                        THeroObject(BaseObject).m_Skill69NH := _MAX(0, THeroObject(BaseObject).m_Skill69NH - Round(nSwrPower * g_Config.n4SKillDecNHRate / 100));
                        BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject).m_Skill69NH, THeroObject(BaseObject).m_Skill69MaxNH, 0, '');
                        BaseObject.DamageSpell(Round(nSwrPower * g_Config.n4SKillDecMPRate / 100) + 1);//����
                        BaseObject.HealthSpellChanged();
                        if (BaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 0) and (Random(5) = 0) then BaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//��ħ����
                      end;
                    end;
                  end;
                end;
                Result := True;
              end;
            end;
          end;
        end;
        {$IF M2Version = 1}
        if (nSwrPower > 0) and Result then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              nSwrPower:= 0;
              nSwrPower := Random(PlayObject.m_nVampirePoint);
              if nSwrPower > 0 then PlayObject.DamageHealth(-nSwrPower);
            end;
          end;
        end;
        {$IFEND}
      end;
    finally
      BaseObjectList.Free;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_61 Code:%d',[g_sExceptionVer, nCode]));
  end;
(*  try
    nPower := 0;
    if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
      nCode:=1;
      if PlayObject.IsProperTarget(TargeTBaseObject) then begin
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin//�ϻ������Լ���Ӣ��
          if (TPlayObject(PlayObject).m_MyHero <> nil) and (TargeTBaseObject <> nil) then begin
            if TPlayObject(PlayObject).m_MyHero = TargeTBaseObject then Exit;
          end;
        end;
        nCode:=2;
        if ({TargeTBaseObject.m_nAntiMagic <= Random(10)}Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
          nCode:=3;
          with PlayObject do begin
            case m_btJob of
              2: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.SC), SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1) * 2;
              0: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)) + 1) * 2;
            end;
          end;
          nCode:=4;
          nPower := Round(nPower * (g_Config.nHeroAttackRate_61 / 100));//20080131 ����ն����

          case PlayObject.m_btRaceServer of
            RC_PLAYOBJECT: nPower := Round(nPower * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
            RC_HEROOBJECT: nPower := Round(nPower * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
          end;

          nCode:=5;
          if TargeTBaseObject <> nil then begin//20080727 ����
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT) or
              ((TargeTBaseObject.m_btRaceServer = RC_PLAYMOSTER) and (TargeTBaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
               nCode:=8;
               nPower :=Round(nPower* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
               if TargeTBaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                  nCode:=9;
                  nPower :=Round(nPower* (1 - g_Config.nDecDragonHitPoint / 100));
                  TargeTBaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
               end;
            end;
          end;
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 500);
          nCode:=6;
          Result := True;
        end else TargeTBaseObject := nil;
      end else TargeTBaseObject := nil;
    end else TargeTBaseObject := nil;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_61 Code:%d',[g_sExceptionVer, nCode]));
  end;  *)
end;
//����һ��  ս+��
function TMagicManager.MagMakeSkillFire_62(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  nCode: Byte;//20080806
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  nPower := 0;
  nCode:= 0;
  try
    if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
      nCode:= 1;
      if PlayObject.IsProperTarget(TargeTBaseObject) then begin      {20080612 �޸����ֵ}
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin//�ϻ������Լ���Ӣ�� 20090126
          if (TPlayObject(PlayObject).m_MyHero <> nil) and (TargeTBaseObject <> nil) then begin
            if TPlayObject(PlayObject).m_MyHero = TargeTBaseObject then exit;
          end;
        end;
        nCode:= 2;
        if ({TargeTBaseObject.m_nAntiMagic <= Random(10)}Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
          nCode:= 3;
          with PlayObject do begin
            case m_btJob of
              1: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1) * 2;
              0: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)) + 1) * 2;
            end;
          end;
          nCode:= 4;
          nPower := Round(nPower * (g_Config.nHeroAttackRate_62 / 100)); //����һ������ 20080131

          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            nPower := Round(nPower * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
            if TPlayObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, TPlayObject(PlayObject).m_nIncDragon);
          end else
          if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
            nPower := Round(nPower * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
            if THeroObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, THeroObject(PlayObject).m_nIncDragon);
          end;
          nCode:= 5;
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT) or
            ((TargeTBaseObject.m_btRaceServer = RC_PLAYMOSTER) and (TargeTBaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
             nCode:= 8;
             nPower :=Round(nPower* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
             if TargeTBaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                nCode:= 9;
                nPower :=Round(nPower* (1 - g_Config.nDecDragonHitPoint / 100));
                TargeTBaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
             end;
          end;
          //TargeTBaseObject.MagDownHealth(0, (Random(10) + UserMagic.btLevel) * 2 + 1, nPower div 10 + 1);//20080830 ע��,ȥ������Ŀ���,Ŀ�껹Ҫ��Ѫ
          nCode:= 11;
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
          nCode:= 10;
          if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
            case TargeTBaseObject.m_btRaceServer of
              RC_PLAYOBJECT: begin
                if TPlayObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                  TPlayObject(TargeTBaseObject).m_Skill69NH := _MAX(0, TPlayObject(TargeTBaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                  TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(TargeTBaseObject).m_Skill69NH, TPlayObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                  TargeTBaseObject.DamageSpell(Round(nPower * g_Config.n4SKillDecMPRate / 100) + 1);//����
                  TargeTBaseObject.HealthSpellChanged();
                  if (TargeTBaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 0) and (Random(5) = 0) then TargeTBaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//��ħ����
                end;
              end;
              RC_HEROOBJECT: begin
                if THeroObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                  THeroObject(TargeTBaseObject).m_Skill69NH := _MAX(0, THeroObject(TargeTBaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                  TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(TargeTBaseObject).m_Skill69NH, THeroObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                  TargeTBaseObject.DamageSpell(Round(nPower * g_Config.n4SKillDecMPRate / 100) + 1);//����
                  TargeTBaseObject.HealthSpellChanged();
                  if (TargeTBaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP] > 0) and (Random(5) = 0) then TargeTBaseObject.m_wStatusTimeArr[STATE_BUBBLEDEFENCEUP]:= 1;//��ħ����
                end;
              end;
            end;
          end;
          Result := True;
          {$IF M2Version = 1}
          if (nPower > 0) then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
          {$IFEND}
        end else TargeTBaseObject := nil;
      end else TargeTBaseObject := nil;
    end else TargeTBaseObject := nil;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_62 Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//�ɻ����� ��+��
function TMagicManager.MagMakeSkillFire_63(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  try                   //20090609 ע��
    //if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin//20090203 ħ���Ƿ���Դ�Ŀ��
      BaseObjectList := TList.Create;
      try
        PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, g_Config.nHeroAttackRange_63{������Χ}, BaseObjectList); //�ɻ����� ������Χ 20080131
        if BaseObjectList.Count > 0 then begin//20080629
          for I := 0 to BaseObjectList.Count - 1 do begin
            BaseObject := TBaseObject(BaseObjectList.Items[I]);
            if BaseObject = nil then Continue;//20090126
            if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
            if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
              if (TPlayObject(PlayObject).m_MyHero <> nil) then begin//�����Լ�Ӣ��
                if (TPlayObject(PlayObject).m_MyHero = BaseObject) then Continue;//20080715 ����
              end;
            if (PlayObject.m_btRaceServer = RC_HEROOBJECT) and (PlayObject.m_Master <> nil) then
              if (PlayObject.m_Master = BaseObject) then Continue;//20080715 ����
            if PlayObject.IsProperTarget(BaseObject) then begin
              if Random(BaseObject.m_nAntiMagic + 10) <= 10 then begin//20090526 ����ħ�����
                if (Random(BaseObject.m_btAntiPoison + 7) <= 7) or (BaseObject.m_btRaceServer = 128) then begin//�ϻ�Ҳ���Դ򵽻��� 20090205
                  if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                    TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
                  Result := True;
                  with PlayObject do begin
                    nPower := GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(m_WAbil.SC),
                      SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1) * 2;
                  end;
                  nPower := Round(nPower * (g_Config.nHeroAttackRate_63 / 100));//�ɻ��������� 20080131
                  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                    nPower := Round(nPower * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
                    if TPlayObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, TPlayObject(PlayObject).m_nIncDragon);
                  end else
                  if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
                    nPower := Round(nPower * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
                    if THeroObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, THeroObject(PlayObject).m_nIncDragon);
                  end;

                  if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT) or
                    ((BaseObject.m_btRaceServer = RC_PLAYMOSTER) and (BaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
                    nPower :=Round(nPower* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
                    if BaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                      nPower :=Round(nPower* (1 - g_Config.nDecDragonHitPoint / 100));
                      BaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
                    end;
                  end;
                  if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
                    case BaseObject.m_btRaceServer of
                      RC_PLAYOBJECT: begin
                        if TPlayObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                          TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                          BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
                        end;
                      end;
                      RC_HEROOBJECT: begin
                        if THeroObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                          THeroObject(BaseObject).m_Skill69NH := _MAX(0, THeroObject(BaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                          BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject).m_Skill69NH, THeroObject(BaseObject).m_Skill69MaxNH, 0, '');
                        end;
                      end;
                    end;
                  end;
                  BaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '');

                  if g_Config.btHeroSkillMode_63 and (not (BaseObject.m_btRaceServer in [79, 109, 128, 143, 145, 147, 151, 153, 156..158])) then begin//�������̶� ����ħ��,�����ޣ���������ܶ�
                    nPower := GetPower13(50, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;//�ж�ʱ�� 20080822
                    BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000);
                    if (TargeTBaseObject <> nil) then PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, {nPower}0, MakeLong(nTargetX, nTargetY), 3, Integer(TargeTBaseObject), '', 600);//20080826
                  end;
                  BaseObject.SetLastHiter(PlayObject);
                  if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
                     if not THeroObject(PlayObject).m_boTarget then PlayObject.SetTargetCreat(BaseObject);
                  end else PlayObject.SetTargetCreat(BaseObject);
                end;
              end;
            end;
          end;
          {$IF M2Version = 1}
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
          {$IFEND}
        end;
      finally
        BaseObjectList.Free;
      end;
    //end;
  except
    //MainOutMessage('{�쳣} TMagicManager.MagMakeSkillFire_63');
  end;
end;
//ĩ������  ��+��  //20081216 �޸ĳ�Ⱥ�幥��
function TMagicManager.MagMakeSkillFire_64(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  I: Integer;//20081216
  BaseObjectList: TList;//20081216
  BaseObject: TBaseObject;//20081216
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else  Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  //if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin//20090609 ע��
    if PlayObject.m_TargetCret = nil then Exit;//��Ŀ�����������ܹ����ķ�Χ
    BaseObjectList := TList.Create;
    try                                                                                                                  
      PlayObject.m_PEnvir.GetMapBaseObjects(PlayObject.m_TargetCret.m_nCurrX, PlayObject.m_TargetCret.m_nCurrY, g_Config.nHeroAttackRange_64{������Χ}, BaseObjectList);
      if BaseObjectList.Count > 0 then begin
        for I := 0 to BaseObjectList.Count - 1 do begin
          BaseObject := TBaseObject(BaseObjectList.Items[I]);
          nPower := 0;
          if BaseObject <> nil then begin
            if PlayObject.IsProperTarget(BaseObject) then begin
              if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin//�ϻ������Լ���Ӣ�� 20090126
                if (TPlayObject(PlayObject).m_MyHero <> nil) and (BaseObject <> nil) then begin
                  if TPlayObject(PlayObject).m_MyHero = BaseObject then Continue;
                end;
              end;
              if BaseObject.m_Master <> nil then begin
                if BaseObject.m_Master = PlayObject then Continue;
              end;
              if (BaseObject.m_nAntiMagic <= Random(10)) and (abs(BaseObject.m_nCurrX - nTargetX) <= g_Config.nHeroAttackRange_64) and (abs(BaseObject.m_nCurrY - nTargetY) <= g_Config.nHeroAttackRange_64) then begin
                if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
                  TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
                with PlayObject do begin
                  case m_btJob of
                    1: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1) * 2;
                    2: nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.SC), SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC)) + 1) * 2;
                  end;
                end;
                nPower := Round(nPower * (g_Config.nHeroAttackRate_64 / 100));//ĩ���������� 20080131
                if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
                  nPower := Round(nPower * (1 + TPlayObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
                  if TPlayObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, TPlayObject(PlayObject).m_nIncDragon);
                end else
                if (PlayObject.m_btRaceServer =RC_HEROOBJECT) then begin
                  nPower := Round(nPower * (1 + THeroObject(PlayObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
                  if THeroObject(PlayObject).m_nIncDragon > 0 then Inc(nPower, THeroObject(PlayObject).m_nIncDragon);
                end;

                if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)  or
                  ((BaseObject.m_btRaceServer = RC_PLAYMOSTER) and (BaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
                   nPower :=Round(nPower* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
                   if BaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                     nPower :=Round(nPower* (1 - g_Config.nDecDragonHitPoint / 100));
                     BaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
                   end;
                end;
                if (abs(BaseObject.m_nCurrX - nTargetX) > 1) and (abs(BaseObject.m_nCurrY - nTargetY) > 1) then begin
                  nPower := Round(nPower * 0.4);
                end;
                if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
                  case BaseObject.m_btRaceServer of
                    RC_PLAYOBJECT: begin
                      if TPlayObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                        TPlayObject(BaseObject).m_Skill69NH := _MAX(0, TPlayObject(BaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                        BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(BaseObject).m_Skill69NH, TPlayObject(BaseObject).m_Skill69MaxNH, 0, '');
                      end;
                    end;
                    RC_HEROOBJECT: begin
                      if THeroObject(BaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                        THeroObject(BaseObject).m_Skill69NH := _MAX(0, THeroObject(BaseObject).m_Skill69NH - Round(nPower * g_Config.n4SKillDecNHRate / 100));
                        BaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(BaseObject).m_Skill69NH, THeroObject(BaseObject).m_Skill69MaxNH, 0, '');
                      end;
                    end;
                  end;
                end;
                {if BaseObject.m_btRaceServer <> RC_PLAYMOSTER then//20080604 �����ιֲ�����
                   //BaseObject.MagDownHealth(1, (Random(3) + UserMagic.btLevel) * 2 + 1, nPower div 15 + 1);//20081002 �޸�
                   BaseObject.MagDownHealth(1, 1, Round(nPower * 0.15)+ 1);//20090112 �޸�,��������15%����  20090204 ������}

                BaseObject.SendMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '');
                Result := True;
              end;
            end;
          end;
        end;
        {$IF M2Version = 1}
        if (nPower > 0) and Result then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              nPower:= 0;
              nPower := Random(PlayObject.m_nVampirePoint);
              if nPower > 0 then PlayObject.DamageHealth(-nPower);
            end;
          end;
        end;
        {$IFEND}
      end;
    finally
      BaseObjectList.Free;
    end;
  //end;
end;
//��������  ��+��
function TMagicManager.MagMakeSkillFire_65(BaseObject: TBaseObject; UserMagic: pTUserMagic; nPower: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerValue: Integer;
begin
  Result := False;
  if BaseObject.m_TargetCret= nil then Exit;//20080418 �޸���Ŀ�����������ܹ����ķ�Χ
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(BaseObject.m_TargetCret.m_nCurrX{BaseObject.m_nCurrX}, BaseObject.m_TargetCret.m_nCurrY{BaseObject.m_nCurrY}, g_Config.nHeroAttackRange_65{������Χ}, BaseObjectList); //�������� ������Χ 20080131
    if BaseObjectList.Count > 0 then begin//20080629
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if BaseObject.IsProperTarget(TargeTBaseObject) then begin
          if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin//�ϻ������Լ���Ӣ�� 20090126
            if (TPlayObject(BaseObject).m_MyHero <> nil) and (TargeTBaseObject <> nil) then begin
              if TPlayObject(BaseObject).m_MyHero = TargeTBaseObject then Continue;
            end;
          end;
          if Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10 then begin//����ħ�����
            if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
              TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
            nPowerValue := Round(nPower * 2 * (g_Config.nHeroAttackRate_65 / 100));//������������ 20080131
            if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
              nPowerValue := Round(nPowerValue * (1 + TPlayObject(BaseObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
              if TPlayObject(BaseObject).m_nIncDragon > 0 then Inc(nPowerValue, TPlayObject(BaseObject).m_nIncDragon);
            end else
            if (BaseObject.m_btRaceServer =RC_HEROOBJECT) then begin
              nPowerValue := Round(nPowerValue * (1 + THeroObject(BaseObject).m_nIncDragonRate / 100));//��װ�ϻ��˺�(����) 20090330
              if THeroObject(BaseObject).m_nIncDragon > 0 then Inc(nPowerValue, THeroObject(BaseObject).m_nIncDragon);
            end;
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT) or
              ((TargeTBaseObject.m_btRaceServer = RC_PLAYMOSTER) and (TargeTBaseObject.m_Master <> nil)) then begin//Ŀ�����˻�Ӣ�����жϾ��� 20080626
               nPowerValue :=Round(nPowerValue* (g_Config.nDecDragonRate / 100));//20080803 �ϻ����˵��˺�����
               if TargeTBaseObject.m_Abil.WineDrinkValue > 0 then begin//������Ϊ0ʱ
                 nPowerValue :=Round(nPowerValue * (1 - g_Config.nDecDragonHitPoint div 100));
                 TargeTBaseObject.SendRefMsg(RM_MYSHOW, ET_DRINKDECDRAGON, 0, 0, 0, '');//�ȾƵ����ϻ�����ʾ����Ч�� 20090105
               end;
            end;
            if UserMagic.btLevel = 4 then begin//�ļ��ϻ���Ŀ��(����,Ӣ��)����ֵ 20100719
              case TargeTBaseObject.m_btRaceServer of
                RC_PLAYOBJECT: begin
                  if TPlayObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                    TPlayObject(TargeTBaseObject).m_Skill69NH := _MAX(0, TPlayObject(TargeTBaseObject).m_Skill69NH - Round(nPowerValue * g_Config.n4SKillDecNHRate / 100));
                    TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, TPlayObject(TargeTBaseObject).m_Skill69NH, TPlayObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                  end;
                end;
                RC_HEROOBJECT: begin
                  if THeroObject(TargeTBaseObject).m_boTrainingNG then begin//ѧ���ڹ��ķ�
                    THeroObject(TargeTBaseObject).m_Skill69NH := _MAX(0, THeroObject(TargeTBaseObject).m_Skill69NH - Round(nPowerValue * g_Config.n4SKillDecNHRate / 100));
                    TargeTBaseObject.SendRefMsg(RM_MAGIC69SKILLNH, 0, THeroObject(TargeTBaseObject).m_Skill69NH, THeroObject(TargeTBaseObject).m_Skill69MaxNH, 0, '');
                  end;
                end;
              end;
            end;
            TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPowerValue, 0, 0, '');
            Result := True;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nPowerValue > 0) and Result then begin//����װ����Ѫ
        if (BaseObject.m_nVampirePoint > 0) and ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= BaseObject.m_nVampireRate then begin
            nPowerValue:= 0;
            nPowerValue := Random(BaseObject.m_nVampirePoint);
            if nPowerValue > 0 then BaseObject.DamageHealth(-nPowerValue);
          end;
        end;
      end;
      {$IFEND}
    end;
  except
    BaseObjectList.Free;
  end;
end;
{$IFEND}
//�Ƿ���սʿ����
function TMagicManager.IsWarrSkill(wMagIdx: Integer): Boolean;
begin
  Result := False;
  case wMagIdx of//20110312 �޸�
    SKILL_ONESWORD {3}, SKILL_88, SKILL_ILKWANG {4}, SKILL_YEDO {7}, SKILL_ERGUM {12}, SKILL_89{89},
    SKILL_BANWOL {25}, SKILL_FIRESWORD {26}, SKILL_MOOTEBO {27}, SKILL_40 {40},
    SKILL_42{42}, SKILL_43{43},SKILL_74{74}, SKILL_76, SKILL_79, SKILL_82,
    SKILL_85, SKILL_90, SKILL_96: Result := True;
  end;
end;

// ���ø���ħ���ĺ���, ������
function TMagicManager.DoSpell(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  boTrain, boSpellFail, boSpellFire, boHeartSkill: Boolean;
  nPower, nAmuletIdx, nPowerRate, nDelayTime, nDelayTimeRate: Integer;
  btLevel : Byte;//�����޸������Ч������ By TasNat at: 2012-04-24 21:27:18
  nCode: Byte;
  MaxTrain: LongWord;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.MagicInfo.wMaxPower > UserMagic.MagicInfo.wPower then//20090807
      Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower)
    else Result := UserMagic.MagicInfo.wPower;
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
  function GetPower13(nInt: Integer): Integer;
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)))
    else Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + UserMagic.MagicInfo.btDefPower);
  end;
  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
    end else Result := LoWord(wInt);
  end;
  procedure sub_4934B4(PlayObject: TBaseObject);
  begin
    if PlayObject.m_UseItems[U_ARMRINGL].Dura < 100 then begin
      PlayObject.m_UseItems[U_ARMRINGL].Dura := 0;
      if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
        TPlayObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
      end else
        if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
        THeroObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
      end;
      PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
    end;
  end;
begin
  Result := False;
  nCode:= 0;

try
  (*{$IF M2Version <> 2}
  if UserMagic.MagicInfo.wMagicId=SKILL_50 then // ���ʹ���������ķ�����ȥ���޼�����
  begin
    if (TPlayObject(PlayObject).m_HeartArrValue>0) and (TPlayObject(PlayObject).m_MagicSkill_105<>nil) then Exit;
  end;
  {$IFEND}*)

  if (TargeTBaseObject <> nil) and (UserMagic.MagicInfo.wMagicId <> SKILL_57) then //����������
    if (TargeTBaseObject.m_boGhost) or (TargeTBaseObject.m_boDeath) or (TargeTBaseObject.m_WAbil.HP <=0) then Exit;//20080428 �޸�
  nCode:= 1;
  if IsWarrSkill(UserMagic.wMagIdx) then Exit;
  if (abs(PlayObject.m_nCurrX - nTargetX) > g_Config.nMagicAttackRage) or
    (abs(PlayObject.m_nCurrY - nTargetY) > g_Config.nMagicAttackRage) then begin
    Exit;
  end;
  nCode:= 2;
  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
    TPlayObject(PlayObject).CmdUserCmd('@MagSelfFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
    {$IF M2Version <> 2}
    with TPlayObject(PlayObject) do begin
      if (m_MyDivision <> nil) and m_boTrainingNG then begin//�������򴥷�
        if (PlayObject.m_Abil.Level >= g_Config.nUpHeartNeedLevel[0]) then begin
          if (m_MagicSkill_105 = nil) and (m_MagicSkill_106 = nil) and
            (Random(g_Config.nDivisionSavvyRate) = 0) then begin
            if g_FunctionNPC <> nil then
              g_FunctionNPC.GotoLable(TPlayObject(PlayObject), '@Savvy', False, False);//�������򴥷�
          end;
        end;
      end;
    end;
   {$IFEND}
    nCode:= 3;
    if (PlayObject.m_btJob = 0) and (UserMagic.MagicInfo.wMagicId = 61) then begin //����նսʿЧ��
       PlayObject.m_btDirection:= GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);//20080611
       PlayObject.SendRefMsg(RM_MYSHOW, 5, 0, 0, 0, ''); //����սʿ������
       PlayObject.SendAttackMsg(RM_PIXINGHIT, PlayObject.m_btDirection, 0, PlayObject.m_nCurrX, PlayObject.m_nCurrY);
    end else
    if (PlayObject.m_btJob = 0) and (UserMagic.MagicInfo.wMagicId = 62) then begin //����һ��սʿЧ��
       PlayObject.m_btDirection:= GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);//20080611
       PlayObject.SendAttackMsg(RM_LEITINGHIT, PlayObject.m_btDirection, 0, PlayObject.m_nCurrX, PlayObject.m_nCurrY);
    end else begin
      nCode:= 4;
      case UserMagic.MagicInfo.wMagicId of //4�����ܷ���ͬ����Ϣ
        {$IF M2Version <> 2}
        SKILL_FIREBALL: begin//������
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 114, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_59: begin//��Ѫ��
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 115, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_94: begin//�ļ���Ѫ��
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 116, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
          end;
        SKILL_50: begin //�޼�����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then //ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 117, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_DEJIWONHO: begin//��ʥս����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 118, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
          end;
        SKILL_HANGMAJINBUB: begin//�����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 119, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
          end;
        SKILL_FIREBALL2: begin//�����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 120, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_FIREBOOM: begin//���ѻ���
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 121, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
          end;
        SKILL_SHIELD: begin//ħ����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 125, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_58: begin//���ǻ���
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 126, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '')
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
          end;
        SKILL_92: begin//�ļ����ǻ���
            //��˪ѩ��
            if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil)
              and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
              and (TPlayObject(PlayObject).m_MagicSkill_108 <> nil) then begin
              PlayObject.SendRefMsg(RM_SPELL, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffect, nTargetX, nTargetY, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.wMagicId, '');
            end else begin
              if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                PlayObject.SendRefMsg(RM_SPELL, 127, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
              else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
            end;
          end;
        SKILL_EARTHFIRE: begin//��ǽ
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_SPELL, 128, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
            else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
          end;
        {$IFEND}
        SKILL_FIRECHARM:begin//�����
           //�����
           {$IF M2Version <> 2}
           if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil)
             and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
             and (TPlayObject(PlayObject).m_MagicSkill_109 <> nil) then begin
             if (UserMagic.btLevel > 3) then//�޸���������˿���ʾЧ������ By TasNat at: 2012-04-24 21:46:22
               btLevel := _Max(UserMagic.btLevelEx, 1)
             else
               btLevel := UserMagic.btLevel;
             PlayObject.SendRefMsg(RM_SPELL, TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.btEffect, nTargetX, nTargetY, TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.wMagicId, IntToStr(btLevel));
           end else begin
           {$IFEND}
             if (UserMagic.btLevel = 4) then begin
               {$IF M2Version <> 2}
               if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                 PlayObject.SendRefMsg(RM_SPELL, 124, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
               else{$IFEND} PlayObject.SendRefMsg(RM_SPELL, 100, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));//�ļ����
             end else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
           {$IF M2Version <> 2}
           end;
           {$IFEND}
         end;
        SKILL_FIRESWORD:;
        SKILL_45:begin//�����
           if (UserMagic.btLevel = 4) then begin
             {$IF M2Version <> 2}
             if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
               PlayObject.SendRefMsg(RM_SPELL, 123, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
             else{$IFEND} PlayObject.SendRefMsg(RM_SPELL, 101, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));//�ļ������
           end else begin
             {$IF M2Version <> 2}
             if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
               PlayObject.SendRefMsg(RM_SPELL, 122, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx))
             else{$IFEND} PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
           end;
         end;
        else PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, IntToStr(UserMagic.btLevelEx));
      end;
    end;
  end;
  
  nCode:= 5;
  if (TargeTBaseObject <> nil) and (UserMagic.MagicInfo.wMagicId <> SKILL_57) and
    (UserMagic.MagicInfo.wMagicId <> SKILL_54) and (UserMagic.MagicInfo.wMagicId < 100) then begin
    if (TargeTBaseObject.m_boDeath) then TargeTBaseObject := nil;
  end;
  boTrain := False;
  boSpellFail := False;
  boSpellFire := True;
  nCode:= 6;
  if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
    if (TPlayObject(PlayObject).m_nSoftVersionDateEx = 0) and (TPlayObject(PlayObject).m_dwClientTick = 0)
    and (UserMagic.MagicInfo.wMagicId > 40) then Exit;
  end;
  nCode:= 7;
  case UserMagic.MagicInfo.wMagicId of //
    SKILL_FIREBALL {1},//������
      SKILL_FIREBALL2 {5}: begin //�����
        if MagMakeFireball(PlayObject, UserMagic,nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_HEALLING {2}: begin //������
        if MagTreatment(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_AMYOUNSUL{6}, SKILL_93{93}: begin //ʩ����,�ļ�ʩ����
        if MagLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail) then boTrain := True;
        boSpellFire:= False;//20091218 ���ӹ����з���Ϣ
      end;
    SKILL_FIREWIND {8}: begin //���ܻ�  00493754
        if MagPushArround(PlayObject, UserMagic.btLevel, False, UserMagic) > 0 then boTrain := True;
      end;
    SKILL_FIRE {9}: begin //������ 00493778
        if MagMakeHellFire(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_SHOOTLIGHTEN {10}: begin //�����Ӱ
        if MagMakeQuickLighting(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_LIGHTENING{11}, SKILL_91: begin //�׵���,�ļ��׵���
        if MagMakeLighting(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_FIRECHARM {13}, SKILL_HANGMAJINBUB {14}, SKILL_DEJIWONHO {15}, SKILL_HOLYSHIELD {16},
      SKILL_SKELLETON {17}, SKILL_CLOAK {18}, SKILL_BIGCLOAK {19}, SKILL_52,{52} SKILL_57,
      SKILL_59, SKILL_94: begin
        boSpellFail := True;
        if CheckAmulet(PlayObject, 1, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 1, 1, nAmuletIdx);
          case UserMagic.MagicInfo.wMagicId of //
            SKILL_FIRECHARM {13}: begin //�����
                if MagMakeFireCharm(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
                boSpellFail := False;
              end;
            SKILL_HANGMAJINBUB {14}: begin //�����
                nPower := PlayObject.GetAttackPower(GetPower13(80) + {LoWord}HiWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                {$IF M2Version <> 2}
                if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
                  if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                    if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                      nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[15] /100)))
                    end;
                  end;
                  TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
                end;
                {$IFEND}
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 1) > 0 then boTrain := True;
                boSpellFail := False;
              end;
            SKILL_DEJIWONHO {15}: begin //��ʥս����
                nPower := PlayObject.GetAttackPower(GetPower13(80) + {LoWord}HiWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                {$IF M2Version <> 2}
                if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
                  if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                    if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                      nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[16] /100)))
                    end;
                  end;
                  TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
                end;
                {$IFEND}
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 0) > 0 then boTrain := True;
                boSpellFail := False;
              end;
            SKILL_HOLYSHIELD {16}: begin //��ħ��
                if MagMakeHolyCurtain(PlayObject, GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 3, nTargetX, nTargetY) > 0 then
                  boTrain := True;
                boSpellFail := False;
              end;
            SKILL_SKELLETON {17}: begin //�ٻ�����
                if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin//ǿ���ٻ�����
                  boSpellFire:= False;
                  boTrain := False;
                  MagMakeSlaveEx(PlayObject, UserMagic, nTargetX, nTargetY, boSpellFail);
                end else begin
                  if MagMakeSlave(PlayObject, UserMagic) then boTrain := True;
                  boSpellFail := False;
                end;
              end;
            SKILL_CLOAK {18}: begin //������
                if MagMakePrivateTransparent(PlayObject, GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
                boSpellFail := False;
              end;
            SKILL_BIGCLOAK {19}: begin //����������
                if MagMakeGroupTransparent(PlayObject, nTargetX, nTargetY, GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
                boSpellFail := False;
              end;
            SKILL_52: begin //������
                nPower := PlayObject.GetAttackPower(GetPower13(20) + LoWord(PlayObject.m_WAbil.SC) * 2, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeAbilityArea(nTargetX, nTargetY, 3, nPower) > 0 then boTrain := True;
                boSpellFail := False;
              end;
            SKILL_57: begin //������
                if MagMakeLivePlayObject(PlayObject, UserMagic, TargeTBaseObject) then boTrain := True;
                boSpellFail := False;
              end;
            SKILL_59, SKILL_94: begin//��Ѫ��,�ļ���Ѫ��
                if MagFireCharmTreatment(PlayObject,UserMagic,nTargetX,nTargetY,TargeTBaseObject) then boTrain := True;
                boSpellFail := False;
              end;
          end;
          sub_4934B4(PlayObject);
        end else begin//�޶�ʱ��ʾ 20100815
          PlayObject.SysMsg('��ķ����þ�', c_Blue, t_Hint);
        end;
      end;
    SKILL_TAMMING {20}: begin //�ջ�֮��
        if PlayObject.IsProperTarget(TargeTBaseObject) then begin
          if MagTamming(PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then boTrain := True;
        end;
      end;
    SKILL_SPACEMOVE {21}: begin //˲Ϣ�ƶ�
        PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), '');
        boSpellFire := False;
        if MagSaceMove(PlayObject, UserMagic.btLevel) then boTrain := True;
      end;
    SKILL_EARTHFIRE {22}: begin //��ǽ
        nPowerRate := PlayObject.m_WAbil.MC;
        if g_Config.boMagFirNoneSSMagic and (PlayObject.m_boHeartActive) then//��ǽ�����ķ����ӵ�ħ�� By TasNat at: 2012-04-05 21:15:30
          nPowerRate := MakeLong(LoWord(nPowerRate) {- LoWord(PlayObject.m_dwHeartAddPower)}, HiWord(nPowerRate) - {HiWord}(PlayObject.m_dwHeartAddPower));
        //PlayObject.SysMsg(format('ħ����:%d-%d', [LoWord(nPowerRate), HiWord(nPowerRate)]), c_Blue, t_Hint);
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(nPowerRate),
          SmallInt(HiWord(nPowerRate) - LoWord(nPowerRate)) + 1);

        nDelayTime := GetPower(10) + (Word(GetRPow(PlayObject.m_WAbil.MC)) shr 1);
        //2006-11-12 ��ǽ������ʱ��ı���
        nPowerRate := Round(nPower * (g_Config.nFirePowerRate / 100));
        nDelayTimeRate := Round(nDelayTime * (g_Config.nFireDelayTimeRate / 100));
        {$IF M2Version <> 2}
        if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              nPowerRate := nPowerRate + Round(nPowerRate * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[7] /100)))
            end;
          end;
          TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
        end;
        {$IFEND}
        if MagMakeFireCross(PlayObject, nPowerRate, nDelayTimeRate, nTargetX, nTargetY, UserMagic.btLevelEx) > 0 then boTrain := True;
      end;
    SKILL_FIREBOOM {23}: begin //���ѻ���
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        {$IF M2Version <> 2}
        if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[13] /100)))
            end;
          end;
          TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
        end;
        {$IFEND}
        if MagBigExplosion(PlayObject, nPower, nTargetX, nTargetY, g_Config.nFireBoomRage {1}, SKILL_FIREBOOM) then
          boTrain := True;
      end;
    SKILL_LIGHTFLOWER {24}: begin //�����׹�
        if MagElecBlizzard(PlayObject, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1)) then
          boTrain := True;
      end;
    SKILL_SHOWHP {28}: begin//������ʾ
        if (TargeTBaseObject <> nil) and not TargeTBaseObject.m_boShowHP then begin
          if Random(6) <= (UserMagic.btLevel + 3) then begin
            TargeTBaseObject.m_dwShowHPTick := GetTickCount();
            TargeTBaseObject.m_dwShowHPInterval := GetPower13(GetRPow(PlayObject.m_WAbil.SC) * 2 + 30) * 1000;
            TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
            if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
              TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
            boTrain := True;
          end;
        end;
      end;
    SKILL_BIGHEALLING {29}: begin //Ⱥ��������
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
          SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
        if MagBigHealing(PlayObject, nPower + PlayObject.m_WAbil.Level, nTargetX, nTargetY, UserMagic) then boTrain := True;
      end;
    SKILL_SINSU{30}: begin//�ٻ�����
        boSpellFail := True;
        if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 5, 1, nAmuletIdx);
          if MagMakeSinSuSlave(PlayObject, UserMagic) then begin
            boTrain := True;
          end;
          boSpellFail := False;
        end;
      end;
    SKILL_SHIELD {31},SKILL_66: begin //ħ����,4��ħ���� 20080624
        if PlayObject.MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(PlayObject.m_WAbil.MC) + 15)) then boTrain := True;
      end;
    SKILL_73 {73}: begin //������  20080301
        if PlayObject.MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(PlayObject.m_WAbil.SC) + 15)) then boTrain := True;
      end;
    SKILL_KILLUNDEAD {32}: begin //ʥ����
        if PlayObject.IsProperTarget(TargeTBaseObject) then begin
          if MagTurnUndead(PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then
            boTrain := True;
        end;
      end;
    SKILL_SNOWWIND {33}: begin //������
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        {$IF M2Version <> 2}
        if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[14] /100)))
            end;
          end;
          TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
        end;
        {$IFEND}
        if MagBigExplosion(PlayObject, nPower, nTargetX, nTargetY, g_Config.nSnowWindRange {1},SKILL_SNOWWIND) then boTrain := True;
      end;
    SKILL_UNAMYOUNSUL {34}: begin //�ⶾ��
        if MagMakeUnTreatment(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_WINDTEBO {35}: if MagWindTebo(PlayObject, UserMagic) then boTrain := True;
    SKILL_MABE {36}: begin //�����
        with PlayObject do begin
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
            SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
        end;
        if MabMabe(PlayObject, TargeTBaseObject, nPower, UserMagic.btLevel, nTargetX, nTargetY) then boTrain := True;
      end;
    SKILL_GROUPLIGHTENING {37 Ⱥ���׵���}: begin
        if MagGroupLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFire) then
          boTrain := True;
      end;
    SKILL_GROUPAMYOUNSUL {38 Ⱥ��ʩ����}: begin
        if MagGroupAmyounsul(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then  boTrain := True;
      end;
    SKILL_GROUPDEDING {39 �ض�}: begin
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
          if GetTickCount - TPlayObject(PlayObject).m_dwDedingUseTick > g_Config.nDedingUseTime * 1000 then begin
            TPlayObject(PlayObject).m_dwDedingUseTick := GetTickCount;
            if MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
          end;
        end else begin
          if (TargeTBaseObject <> nil) and MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
            boTrain := True;
        end;
      end;
    SKILL_41: begin //ʨ�Ӻ�
        if MagGroupMb(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then begin
          boTrain := True;
        end;
      end;
    SKILL_42: begin //����ն
        if MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_43: begin //��Ӱ����
          if MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    //��ʦ
    SKILL_44: begin //������
        if MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_45: begin //�����
        if MagMakeFireDay(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_46: begin //������
        if MagMakeSelf(PlayObject, TargeTBaseObject, UserMagic) then begin
          boTrain := True;
        end;
      end;
    SKILL_47: begin //��������
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          g_Config.nFireBoomRage {1},SKILL_47) then
          boTrain := True;
      end;
    SKILL_58, SKILL_70: begin //���ǻ���,����
        if MagBigExplosion1(PlayObject,
             PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
             nTargetX, nTargetY, g_Config.nMeteorFireRainRage, TargeTBaseObject, False, UserMagic.MagicInfo.wMagicId) then boTrain := True;
      end;
    SKILL_92: begin//�ļ����ǻ���
        boHeartSkill:= False;
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        {$IF M2Version <> 2}
        if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
            if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[9] /100)))
            end;
          end;
          //��˪ѩ�������˺�
          if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) and (TPlayObject(PlayObject).m_boHeartActive) and
             (TPlayObject(PlayObject).m_MagicSkill_108 <> nil) then begin
            boHeartSkill:= True;
            nPower := nPower +  GetPower(MPow(TPlayObject(PlayObject).m_MagicSkill_108));
            if TPlayObject(PlayObject).m_MagicSkill_108.btLevel < 9 then begin
              if g_Config.nSKILL_108NeedHeart[TPlayObject(PlayObject).m_MagicSkill_108.btLevel] <= TPlayObject(PlayObject).m_MagicSkill_105.btLevel then begin
                PlayObject.TrainSkill(TPlayObject(PlayObject).m_MagicSkill_108, Random(3) + 1);
                if not PlayObject.CheckMagicLevelup(TPlayObject(PlayObject).m_MagicSkill_108) then begin
                  MaxTrain := TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.MaxTrain[0] + TPlayObject(PlayObject).m_MagicSkill_108.btLevel * (TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.MaxTrain[2]-TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.MaxTrain[1]);
                  PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.wMagicId, MaxTrain, TPlayObject(PlayObject).m_MagicSkill_108.btLevel, TPlayObject(PlayObject).m_MagicSkill_108.nTranPoint, '', 1000);
                end;
              end;
            end;
          end;
          TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
        end;
        {$IFEND}
        if MagBigExplosion1(PlayObject, nPower, nTargetX, nTargetY, g_Config.nMeteorFireRainRage, TargeTBaseObject, boHeartSkill, UserMagic.MagicInfo.wMagicId) then boTrain := True;
      end;
    //��ʿ
    SKILL_48: begin //������
        if MagPushArround(PlayObject, UserMagic.btLevel, True, UserMagic) > 0 then boTrain := True;
      end;
    SKILL_49: begin //������
        boTrain := True;
      end;
    SKILL_50: begin //�޼�����    // ��������ķ����ˣ�������
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
          if TPlayObject(PlayObject).AbilityUp(UserMagic) then boTrain := True;
        end else
        if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
          if THeroObject(PlayObject).AbilityUp(UserMagic) then boTrain := True;
        end;
      end;
    SKILL_51: begin //쫷���
        if MagGroupFengPo(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_53: begin //Ѫ��
        boTrain := True;
      end;
    SKILL_54: begin //������
        if PlayObject.IsProperTargetSKILL_54(TargeTBaseObject) then begin
          if MagTamming2(PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then boTrain := True;
        end;
      end;
    SKILL_55: begin //������
        if MagMakeArrestObject(PlayObject, UserMagic, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_56: begin //���л�λ
        if (GetTickCount - PlayObject.m_boMagChangXYTick > g_Config.dwMagChangXYTick) then begin//���л�λʹ�ü�� 20080616
           if MagChangePosition(PlayObject, nTargetX, nTargetY) then begin
              PlayObject.m_boMagChangXYTick:= GetTickCount;
              boTrain := True;
           end;
        end else begin
          if g_sOpenShieldTickMsg <> '' then
            PlayObject.SysMsg(Format_ToStr(g_sOpenShieldTickMsg, [(g_Config.dwMagChangXYTick-(GetTickCount - PlayObject.m_boMagChangXYTick))div 1000]), c_Red, t_Hint);
          Exit;
        end;
      end;
    SKILL_68: begin//�������� 20080625
        MagMakeHPUp(PlayObject, UserMagic);
        boTrain := False;
      end;
    SKILL_71: begin//�ٻ�ʥ�ޣ����ܲ�����
        boTrain := False;
        boSpellFail := True;
        if (GetTickCount - PlayObject.m_dwDoSuSlaveTick) > 30000 then begin//�ٻ�ʥ�޼��
          if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
            PlayObject.m_dwDoSuSlaveTick:= GetTickCount();
            UseAmulet(PlayObject, 5, 1, nAmuletIdx);
            if (UserMagic.btLevel > 98) and (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
              boSpellFire:= False;
              MagMakeShengSuSlaveEx(PlayObject, UserMagic, nTargetX, nTargetY, boSpellFail);
            end else begin
              MagMakeShengSuSlave(PlayObject, UserMagic);
              boSpellFail := False;
            end;
          end;
        end else PlayObject.SysMsg( sDailySuSlaveFail, c_Green, t_Hint);
      end;
    SKILL_103: begin//�ٻ���ħ�����ܲ�����
        boTrain := False;
        boSpellFail := True;
        if (GetTickCount - PlayObject.m_dwDoCallTrollTick) > g_Config.dwDoCallTrollTick * 1000 then begin//�ٻ����10����
          PlayObject.m_dwDoCallTrollTick:= GetTickCount();
          MagMakeCallTrollSlave(PlayObject, UserMagic);
          boSpellFail := False;
        end;
      end;
    SKILL_72: begin //�ٻ�����
        if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 5, 1, nAmuletIdx);
          if MagMakeFairy(PlayObject, UserMagic) then boTrain := True;
        end;
      end;
    SKILL_104: begin //�ٻ�����
        if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 5, 1, nAmuletIdx);
          if MagMakeFireFairy(PlayObject, UserMagic) then boTrain := True;
        end;
      end;
    {$IF M2Version <> 2}
    SKILL_97: begin//Ѫ��һ��(��)
        boSpellFail := True;
        if (GetTickCount - PlayObject.m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ�����
          boSpellFail := False;
          if MagBigExplosion_97(PlayObject,
            PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
                          nTargetX, nTargetY, g_Config.nExplosion_97Range , UserMagic, TargeTBaseObject) then boTrain := True;
        end else  PlayObject.SysMsg( sBloodSoulSkillFail, c_Green, t_Hint);
      end;
    SKILL_98: begin//Ѫ��һ��(��)
        boSpellFail := True;
        if (GetTickCount - PlayObject.m_dwLatestBloodSoulTick) > g_Config.dwUseBloodSoulTick then begin//Ѫ��һ�����
          boSpellFail := False;
          if MagMakeFireCharm_98(PlayObject, UserMagic, nTargetX, nTargetY, g_Config.nExplosion_98Range, TargeTBaseObject) then boTrain := True;
        end else  PlayObject.SysMsg( sBloodSoulSkillFail, c_Green, t_Hint);
      end;
    SKILL_110: begin//����֮��
        if ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
          and MagMakeFireCharm_110(PlayObject, UserMagic, nTargetX, nTargetY, 5, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_111: begin//��˪Ⱥ��
        if ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
        and MagMakeFireCharm_111(PlayObject, UserMagic, nTargetX, nTargetY, 1, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_112: begin//ʮ��һɱ
        boSpellFail := True;
        if ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
        and MagMakeFireCharm_112(PlayObject, UserMagic, nTargetX, nTargetY, 5, TargeTBaseObject, boSpellFire) then begin
          boSpellFail := False;
          boTrain := True;
        end;
      end;
    SKILL_113: begin//��������
        if ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
        and (MagMakeFireCharm_113(PlayObject, UserMagic, 5{����ʱ��}, nTargetX, nTargetY, TargeTBaseObject, boSpellFire) > 0) then
          boTrain := True;
      end;
    SKILL_114: begin//ŭ�ɻ���
        if ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57        
        and MagMakeFireCharm_114(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    {$IFEND}
    {$IF HEROVERSION = 1}
    SKILL_60: begin  //�ƻ�ն  ս+ս
        MagMakeSkillFire_60(PlayObject, UserMagic,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.DC), SmallInt(HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC)) + 1) * 3);
        boTrain:= False;
      end;
    SKILL_61: begin //����ն  ս+��
        MagMakeSkillFire_61(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
        boTrain:= False;
      end;
    SKILL_62: begin//����һ��  ս+��
        MagMakeSkillFire_62(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
        boTrain:= False;
      end;
    SKILL_63: begin //�ɻ�����  ��+��
        MagMakeSkillFire_63(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
        boTrain:= False;
     end;
    SKILL_64: begin //ĩ������  ��+��
        MagMakeSkillFire_64(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject);
        boTrain:= False;
      end;
    SKILL_65: begin //��������  ��+��
        MagMakeSkillFire_65(PlayObject, UserMagic, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1));
        boTrain:= False;
      end;
    {$IFEND}
  else begin
      nCode:= 8;
      if Assigned(zPlugOfEngine.SetHookDoSpell) then begin
        boTrain := zPlugOfEngine.SetHookDoSpell(Self, TPlayObject(PlayObject), UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail, boSpellFire);
      end;
    end;
  end;

  nCode:= 9;
  if boSpellFail then Exit;
  if boSpellFire then begin
    nCode:= 10;
    if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
      case UserMagic.MagicInfo.wMagicId of
        {$IF M2Version <> 2}
        SKILL_FIREBALL: begin//������
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 114), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_59: begin//��Ѫ��
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 115), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_94: begin//�ļ���Ѫ��
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 116), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_50: begin//�޼�����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 117), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_DEJIWONHO: begin//��ʥս����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 118), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_HANGMAJINBUB: begin//�����
               if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 119), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_FIREBALL2: begin//�����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 120), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_FIREBOOM: begin//���ѻ���
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 121), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_SHIELD: begin//ħ����
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 125), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_58: begin//���ǻ���  �޸�
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 126), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil)
              and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
              and (TPlayObject(PlayObject).m_MagicSkill_108 <> nil) then begin
              PlayObject.SendRefMsg(RM_MAGICFIRE, 0,MakeWord(TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffectType, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        SKILL_92: begin//�ļ����ǻ���
            //��˪ѩ��
            if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil)
              and ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
              and (TPlayObject(PlayObject).m_MagicSkill_108 <> nil) then begin
              PlayObject.SendRefMsg(RM_MAGICFIRE, 0,MakeWord(TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffectType, TPlayObject(PlayObject).m_MagicSkill_108.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end else begin
              if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 127), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
              else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end;
          end;
        SKILL_EARTHFIRE: begin//��ǽ
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 128), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        {$IFEND}
        SKILL_FIRECHARM: begin//�����
          //�����
          {$IF M2Version <> 2}
          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) and
             ((not g_Config.boHeratPowerNeed2) or TPlayObject(PlayObject).m_boHeartActive)//���ӿ�������״̬�²ſ����� By TasNat at: 2012-07-24 14:56:57
             and (TPlayObject(PlayObject).m_MagicSkill_109 <> nil) then begin
            PlayObject.SendRefMsg(RM_MAGICFIRE, 0,MakeWord(TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.btEffectType, TPlayObject(PlayObject).m_MagicSkill_109.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end else begin
          {$IFEND}
            if (UserMagic.btLevel = 4) then begin
              {$IF M2Version <> 2}
              if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
                PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 124), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
              else{$IFEND} PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 100), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          {$IF M2Version <> 2}
          end;
          {$IFEND}
        end;
        SKILL_FIRESWORD:;
        SKILL_45: begin//�����
          if (UserMagic.btLevel = 4) then begin
            {$IF M2Version <> 2}
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 123), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else{$IFEND} PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 101), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end else begin
            {$IF M2Version <> 2}
            if TPlayObject(PlayObject).m_boFengHaoMagicEffect then//ħ���ۺ�Ч��(����֮��)
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 122), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'')
            else{$IFEND} PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        end;
        else PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
      end;
    end;
  end;
  nCode:= 11;
  if (UserMagic.btLevel < 3) and (boTrain) then begin
    nCode:= 13;
    if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= PlayObject.m_Abil.Level then begin
      nCode:= 12;
      PlayObject.TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
      nCode:= 14;
      if not PlayObject.CheckMagicLevelup(UserMagic) then begin
        nCode:= 15;
        if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
          PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
        end else
          if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
          THeroObject(PlayObject).SendDelayMsg(PlayObject, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
        end;
      end;
    end;
  end;
  Result := True;
  except
    on E: Exception do begin
      MainOutMessage(Format('{%s} TMagicManager.DoSpell MagID:%d X:%d Y:%d Code:%d', [g_sExceptionVer, UserMagic.wMagIdx, nTargetX, nTargetY, nCode]));
    end;
  end;
end;
//������
function TMagicManager.MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  if BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT] > 0 then Exit;
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(BaseObject.m_nCurrX, BaseObject.m_nCurrY, 9, BaseObjectList);
    if BaseObjectList.Count > 0 then begin//20080628
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin//20090310
          if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and (TargeTBaseObject.m_TargetCret = BaseObject) then begin
            if (abs(TargeTBaseObject.m_nCurrX - BaseObject.m_nCurrX) > 1) or
              (abs(TargeTBaseObject.m_nCurrY - BaseObject.m_nCurrY) > 1) or
              (Random(2) = 0) then begin
              TargeTBaseObject.m_TargetCret := nil;
            end;
          end;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
  BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT] := nHTime;
  BaseObject.m_nCharStatus := BaseObject.GetCharStatus();
  BaseObject.StatusChanged('');
  BaseObject.m_boHideMode := True;
  BaseObject.m_boTransparent := True;
  Result := True;
end;
{//δʹ�� 20080410
function TMagicManager.MagReturn(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean;
begin
  Result := False;
  TargeTBaseObject.ReAlive;
  TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.MaxHP;
  TargeTBaseObject.SendMsg(TargeTBaseObject, RM_ABILITY, 0, 0, 0, 0, '');
  Result := True;
end;}

function TMagicManager.MagTamming2(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean;
begin
  Result := False;                                          //�ջ�֮�� ��Ӣ��,������Ч 20100110
  if (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and
    (TargeTBaseObject.m_btRaceServer <> 158) and//����
    (TargeTBaseObject.m_btRaceServer <> RC_HEROOBJECT) and
    (TargeTBaseObject.m_btRaceServer <> RC_PLAYMOSTER) and ((Random(4 - nMagicLevel) = 0)) then begin
    TargeTBaseObject.m_TargetCret := nil;
    if Random(2) = 0 then begin
      if TargeTBaseObject.m_Abil.Level <= BaseObject.m_Abil.Level + 2 then begin
        if Random(3) = 0 then begin
          if Random((BaseObject.m_Abil.Level + 20) + (nMagicLevel * 5)) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel {10}) then begin
            if (TargeTBaseObject.m_btLifeAttrib = 0) and
              (TargeTBaseObject.m_Abil.Level < g_Config.nMagTammingLevel {50}) and
              (BaseObject.m_SlaveList.Count < g_Config.nMagTammingCount {(nMagicLevel + 2)}) then begin
              TargeTBaseObject.m_Master := BaseObject;
              TargeTBaseObject.m_dwMasterRoyaltyTick := LongWord((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60000{60 * 1000}) {+ GetTickCount};
              if g_Config.boMasterTimeRoyalty then
                TargeTBaseObject.m_dwMasterRoyaltyTick := _MIN(g_Config.dwMasterTimeRoyaltyTime* (60 * 1000), TargeTBaseObject.m_dwMasterRoyaltyTick);
              TargeTBaseObject.m_dwMasterRoyaltyTime := GetTickCount;//20080813 ����
              TargeTBaseObject.m_btSlaveMakeLevel := nMagicLevel;
              if TargeTBaseObject.m_dwMasterTick = 0 then TargeTBaseObject.m_dwMasterTick := GetTickCount();
              TargeTBaseObject.BreakHolySeizeMode();
              if LongWord(1500 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nWalkSpeed) then begin
                TargeTBaseObject.m_nWalkSpeed := 1500 - nMagicLevel * 200;
              end;
              if LongWord(2000 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nNextHitTime) then begin
                TargeTBaseObject.m_nNextHitTime := 2000 - nMagicLevel * 200;
              end;
              TargeTBaseObject.ReAlive;
              TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.MaxHP;
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin//20090501 �޸�
                TargeTBaseObject.SendMsg(TargeTBaseObject, RM_ABILITY, 0, 0, 0, 0, '');
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin//20090501 �޸�
                THeroObject(TargeTBaseObject).SendMsg(TargeTBaseObject, RM_HEROABILITY, 0, 0, 0, 0, '');
              end;
              TargeTBaseObject.RefShowName();
              BaseObject.m_SlaveList.Add(TargeTBaseObject);
            end;
          end;
        end else begin
          if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
            TargeTBaseObject.OpenCrazyMode(Random(20) + 10);
        end;
      end else begin
        if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then
          TargeTBaseObject.OpenCrazyMode(Random(20) + 10); //���
      end;
    end;
  end;
  Result := True;
end;
//�ջ�֮��
function TMagicManager.MagTamming(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean;
var
  n14: Integer;
begin
  Result := False;                                          //�ջ�֮�� ��Ӣ��,������Ч 20100110
  if (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and
    (TargeTBaseObject.m_btRaceServer <> 158) and//����
    (TargeTBaseObject.m_btRaceServer <> RC_HEROOBJECT) and
    (TargeTBaseObject.m_btRaceServer <> RC_PLAYMOSTER) and
    ((Random(4 - nMagicLevel) = 0)) then begin
    TargeTBaseObject.m_TargetCret := nil;
    if TargeTBaseObject.m_Master = BaseObject then begin
      TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      Result := True;
    end else begin
      if Random(2) = 0 then begin
        if TargeTBaseObject.m_Abil.Level <= BaseObject.m_Abil.Level + 2 then begin
          if Random(3) = 0 then begin
            if Random((BaseObject.m_Abil.Level + 20) + (nMagicLevel * 5)) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel {10}) then begin
              if (TargeTBaseObject.m_btLifeAttrib = 0) and
                (TargeTBaseObject.m_Abil.Level < g_Config.nMagTammingLevel {50}) and
                (BaseObject.m_SlaveList.Count < g_Config.nMagTammingCount {(nMagicLevel + 2)}) then begin
                n14 := TargeTBaseObject.m_WAbil.MaxHP div g_Config.nMagTammingHPRate {100};
                if n14 <= 2 then n14 := 2
                else Inc(n14, n14);
                if (TargeTBaseObject.m_Master <> BaseObject) and (Random(n14) = 0) then begin
                  TargeTBaseObject.BreakCrazyMode();
                  if TargeTBaseObject.m_Master <> nil then begin
                    TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.HP div 10;
                  end;
                  TargeTBaseObject.m_Master := BaseObject;
                  TargeTBaseObject.m_dwMasterRoyaltyTick := LongWord((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60000{60 * 1000}) {+ GetTickCount};
                  if g_Config.boMasterTimeRoyalty then
                  TargeTBaseObject.m_dwMasterRoyaltyTick := _MIN(g_Config.dwMasterTimeRoyaltyTime* (60 * 1000), TargeTBaseObject.m_dwMasterRoyaltyTick);
                  TargeTBaseObject.m_dwMasterRoyaltyTime := GetTickCount;//20080813 ����
                  TargeTBaseObject.m_btSlaveMakeLevel := nMagicLevel;
                  if TargeTBaseObject.m_dwMasterTick = 0 then TargeTBaseObject.m_dwMasterTick := GetTickCount();
                  TargeTBaseObject.BreakHolySeizeMode();
                  if not g_Config.boMagTammingHitNew then begin//20110728 �����ܵȼ������ٶ�
                    if LongWord(1500 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nWalkSpeed) then begin
                      TargeTBaseObject.m_nWalkSpeed := 1500 - nMagicLevel * 200;
                    end;
                    if LongWord(2000 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nNextHitTime) then begin
                      TargeTBaseObject.m_nNextHitTime := 2000 - nMagicLevel * 200;
                    end;
                  end else begin
                    TargeTBaseObject.m_nWalkSpeed := _MAX(400 ,TargeTBaseObject.m_nWalkSpeed - nMagicLevel * 200);
                    TargeTBaseObject.m_nNextHitTime := _MAX(500,TargeTBaseObject.m_nNextHitTime - nMagicLevel * 200);
                  end;
                  TargeTBaseObject.RefShowName();
                  BaseObject.m_SlaveList.Add(TargeTBaseObject);
                end else begin //004925F2
                  if Random(14) = 0 then TargeTBaseObject.m_WAbil.HP := 0;
                end;
              end else begin //00492615
                if (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                  TargeTBaseObject.m_WAbil.HP := 0;
              end;
            end else begin //00492641
              if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                TargeTBaseObject.OpenCrazyMode(Random(20) + 10);
            end;
          end else begin //00492674
            if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then
              TargeTBaseObject.OpenCrazyMode(Random(20) + 10); //���
          end;
        end; //004926B0
      end else begin //00492699
        TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      end;
      Result := True;
    end;
  end else begin
    if Random(2) = 0 then Result := True;
  end;
end;

function TMagicManager.MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nLevel: Integer): Boolean; //004926D4
var
  n14: Integer;
  nCode: Byte;
begin
  Result := False;
  try
    nCode:= 0;
    if TargeTBaseObject <> nil then begin
      if (not TargeTBaseObject.m_boDeath) and (not TargeTBaseObject.m_boGhost) then begin//20110722
        nCode:= 1;
        if TargeTBaseObject.m_boSuperMan or not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then Exit;
        nCode:= 2;
        TAnimalObject(TargeTBaseObject).Struck(BaseObject);
        if TargeTBaseObject.m_TargetCret = nil then begin
          TAnimalObject(TargeTBaseObject).m_boRunAwayMode := True;
          TAnimalObject(TargeTBaseObject).m_dwRunAwayStart := GetTickCount();
          TAnimalObject(TargeTBaseObject).m_dwRunAwayTime := 10000{10 * 1000};
        end;
        nCode:= 3;
        if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
          if not THeroObject(BaseObject).m_boTarget then BaseObject.SetTargetCreat(TargeTBaseObject);
        end else BaseObject.SetTargetCreat(TargeTBaseObject);
        nCode:= 4;
        if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
          nCode:= 5;
          if TargeTBaseObject.m_Abil.Level < g_Config.nMagTurnUndeadLevel then begin
            nCode:= 6;
            n14 := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
            if Random(100) < ((nLevel shl 3) - nLevel + 15 + n14) then begin
              nCode:= 7;
              TargeTBaseObject.SetLastHiter(BaseObject);
              nCode:= 8;
              TargeTBaseObject.m_WAbil.HP := 0;
              Result := True;
            end
          end;
        end;
      end;
    end;
  except
    MainOutMessage(Format('{%s}MagicManager.MagTurnUndead Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TMagicManager.MagWindTebo(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  PoseBaseObject: TBaseObject;
begin
  Result := False;
  PoseBaseObject := PlayObject.GetPoseCreate;
  if (PoseBaseObject <> nil) and
    (PoseBaseObject <> PlayObject) and
    (not PoseBaseObject.m_boDeath) and
    (not PoseBaseObject.m_boGhost) and
    (PlayObject.IsProperTarget(PoseBaseObject)) and
    (not PoseBaseObject.m_boStickMode) then begin
    if (abs(PlayObject.m_nCurrX - PoseBaseObject.m_nCurrX) <= 1) and
      (abs(PlayObject.m_nCurrY - PoseBaseObject.m_nCurrY) <= 1) and
      (PlayObject.m_Abil.Level > PoseBaseObject.m_Abil.Level) then begin
      if Random(20) < UserMagic.btLevel * 6 + 6 + (PlayObject.m_Abil.Level - PoseBaseObject.m_Abil.Level) then begin
        if (UserMagic <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
          TPlayObject(PoseBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
        PoseBaseObject.CharPushed(GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, PoseBaseObject.m_nCurrX, PoseBaseObject.m_nCurrY), _MAX(0, UserMagic.btLevel - 1) + 1);
        Result := True;
      end;
    end;
  end;
end;

function TMagicManager.MagSaceMove(BaseObject: TBaseObject; nLevel: Integer): Boolean;
var
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := False;
  //���ӽ������򲻿��� By TasNat at: 2012-03-08 12:33:19
  if (Random(11) < nLevel * 2 + 4) and (not BaseObject.InMag113LockRect(BaseObject.m_nCurrX, BaseObject.m_nCurrY)) then begin
    BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE2, 0, 0, 0, 0, '');
    if BaseObject is TPlayObject then begin
      Envir := BaseObject.m_PEnvir;
      BaseObject.MapRandomMove(BaseObject.m_sHomeMap, 1);
      if (Envir <> BaseObject.m_PEnvir) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        PlayObject := TPlayObject(BaseObject);
        PlayObject.m_boTimeRecall := False;
      end;
    end;
    Result := True;
  end;
end;
//쫷���
function TMagicManager.MagGroupFengPo(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  if BaseObjectList.Count > 0 then begin//20080629
    for I := 0 to BaseObjectList.Count - 1 do begin
      BaseObject := TBaseObject(BaseObjectList.Items[I]);
      if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
      if PlayObject.IsProperTarget(BaseObject) then begin
        //nPower := PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.SC), SmallInt((HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC))));
        //�޸�û����
        nPower := MPow(UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
        {if (Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint) then begin
          nPower := 0;
        end;}
        if (UserMagic <> nil) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then
          TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
        if nPower > 0 then begin
          nPower := BaseObject.GetHitStruckDamage(PlayObject, nPower);
        end;
        if nPower > 0 then begin
          BaseObject.StruckDamage(nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 1, Integer(BaseObject), '', 200);
        end;
        if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
      end;
    end;
   {$IF M2Version = 1}
    if (nPower > 0) and Result then begin//����װ����Ѫ
      if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
        if Random(100) <= PlayObject.m_nVampireRate then begin
          nPower:= 0;
          nPower := Random(PlayObject.m_nVampirePoint);
          if nPower > 0 then PlayObject.DamageHealth(-nPower);
        end;
      end;
    end;
    {$IFEND}
  end;
  BaseObjectList.Free;
end;
//Ⱥ��ʩ����
function TMagicManager.MagGroupAmyounsul(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower{$IF M2Version = 1}, NGSecPwr{$IFEND}: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
  nCode: Byte;
begin
  Result := False;
  nCode:= 0;
  try
    BaseObjectList := TList.Create;
    try
      nCode:= 1;
      PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
      nCode:= 2;
      if BaseObjectList.Count > 0 then begin
        for I := 0 to BaseObjectList.Count - 1 do begin
          nCode:= 3;
          BaseObject := TBaseObject(BaseObjectList.Items[I]);
          nCode:= 4;
          if BaseObject <> nil then begin
            if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) or
              (BaseObject.m_btRaceServer in [79, 109, 128, 143, 145, 147, 151, 153, 156..158]) then Continue;//20090111 ����ħ��,�����ޣ���������ܶ�
            nCode:= 5;
            if PlayObject.IsProperTarget(BaseObject) then begin
              nCode:= 6;
              if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then begin
                nCode:= 7;
                StdItem := nil;//20080722
                if (nAmuletIdx = U_ARMRINGL) or (nAmuletIdx = U_BUJUK) then begin//20080722 �޸�
                  nCode:= 8;
                  if PlayObject.m_UseItems[nAmuletIdx].wIndex > 0 then
                      StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
                  nCode:= 9;
                end;
                nCode:= 20;
                if (StdItem = nil) then begin
                  StdItem:= UserEngine.GetStdItem(nAmuletIdx); //���װ������û����Ʒ,��Ӱ������� 20080314
                end else begin
                  if (StdItem <> nil) and (StdItem.StdMode <> 25) then StdItem:= UserEngine.GetStdItem(nAmuletIdx); //���װ������û����Ʒ,��Ӱ������� 20080314
                end;
                nCode:= 10;
                if StdItem <> nil then begin
                  UseAmulet(PlayObject, 1, 2, nAmuletIdx);
                  nCode:= 11;
                  if Random(BaseObject.m_btAntiPoison + 7) <= 6 then begin
                    case StdItem.Shape of
                      1: begin
                          nCode:= 12;
                          nPower := GetPower13(40, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                          //nPower :=11 + UserMagic.btLevel * 3 ;//20080329 �޸�ʱ���㷨
                          {$IF M2Version = 1}
                          case PlayObject.m_btRaceServer of
                            RC_PLAYOBJECT: begin
                              NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                              end;
                              nPower := _MAX(0, nPower + NGSecPwr);
                            end;
                            RC_HEROOBJECT: begin
                              NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                              end;
                              nPower := _MAX(0, nPower + NGSecPwr);
                            end;
                            RC_PLAYMOSTER: begin
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                                nPower := _MAX(0, nPower - NGSecPwr);
                              end;
                            end;
                          end;//case
                          {$IFEND}
                          nCode:= 13;
                          BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', {1000}200);
                          if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
                               TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
                        end;
                      2: begin
                          nCode:= 14;
                          nPower := GetPower13(30, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                          //nPower :=11 + UserMagic.btLevel * 3 ;//20080329 �޸�ʱ���㷨
                          {$IF M2Version = 1}
                          case PlayObject.m_btRaceServer of
                            RC_PLAYOBJECT: begin
                              NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                              end;
                              nPower := _MAX(0, nPower + NGSecPwr);
                            end;
                            RC_HEROOBJECT: begin
                              NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                              end;
                              nPower := _MAX(0, nPower + NGSecPwr);
                            end;
                            RC_PLAYMOSTER: begin
                              if BaseObject <> nil then begin
                                case BaseObject.m_btRaceServer of
                                  RC_PLAYOBJECT: NGSecPwr:= GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                  RC_HEROOBJECT: NGSecPwr:= GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                                end;
                                nPower := _MAX(0, nPower - NGSecPwr);
                              end;
                            end;
                          end;//case
                          {$IFEND}
                          nCode:= 15;
                          BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {�ж����� - �춾}, nPower, Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', {1000}200);
                          if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
                            TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

                        end;
                    end;
                    nCode:= 16;
                    if BaseObject <> nil then begin
                      if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
                      nCode:= 17;
                      if PlayObject <> nil then begin//20081216
                        BaseObject.SetLastHiter(PlayObject);
                        nCode:= 18;
                        if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
                          nCode:= 19;
                          if not THeroObject(PlayObject).m_boTarget then PlayObject.SetTargetCreat(BaseObject);
                        end else PlayObject.SetTargetCreat(BaseObject);
                        nCode:= 20;
                        if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin//20081108 ������Ӣ��,Ӣ�۲�����
                          nCode:= 21;
                          if not THeroObject(BaseObject).m_boTarget then BaseObject.SetTargetCreat(PlayObject);
                        end;
                      end;
                    end;
                    nCode:= 22;
                  end;
                end;
              end else begin//�޶�ʱ��ʾ 20100815
                if PlayObject.m_btRaceServer = RC_HEROOBJECT then
                  THeroObject(PlayObject).SysMsg('(Ӣ��) ��Ķ����þ�', c_Blue, t_Hint)
                else PlayObject.SysMsg('��Ķ����þ�', c_Blue, t_Hint);
              end;
            end;
          end;
        end;
      end;
    finally
      BaseObjectList.Free;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagGroupAmyounsul Code:%d',[g_sExceptionVer, nCode]));
  end;
end;

function TMagicManager.MagGroupDeDing(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  if BaseObjectList.Count > 0 then begin//20080629
    for I := 0 to BaseObjectList.Count - 1 do begin
      BaseObject := TBaseObject(BaseObjectList.Items[I]);
      if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
      if ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) and not g_Config.boDedingAllowPK then Continue;//20090526 ���ӹ���Ӣ��
      if PlayObject.IsProperTarget(BaseObject) then begin
        nPower := PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.DC), SmallInt((HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC))));

        if (Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint) then begin
          nPower := 0;
        end;
        if nPower > 0 then begin
          nPower := BaseObject.GetHitStruckDamage(PlayObject, nPower);
        end;
        nPower := Round(nPower * (g_Config.nDidingPowerRate / 100));
        if nPower > 0 then begin
          BaseObject.StruckDamage(nPower);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 1, Integer(BaseObject), '', 200);
          //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 1, Integer(BaseObject), '');
        end;
        if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
        if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
          TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609


      end;
      PlayObject.SendRefMsg(RM_10205, 1, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
    end;
   {$IF M2Version = 1}
    if (nPower > 0) and Result then begin//����װ����Ѫ
      if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
        if Random(100) <= PlayObject.m_nVampireRate then begin
          nPower:= 0;
          nPower := Random(PlayObject.m_nVampirePoint);
          if nPower > 0 then PlayObject.DamageHealth(-nPower);
        end;
      end;
    end;
    {$IFEND}
  end;
  BaseObjectList.Free;
end;
//Ⱥ���׵���
function TMagicManager.MagGroupLightening(PlayObject: TBaseObject; {�޸� TBaseObject}
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  boSpellFire := False;
  BaseObjectList := TList.Create;
  PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,
    MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
    MakeLong(nTargetX, nTargetY),
    Integer(TargeTBaseObject),
    '');
  if BaseObjectList.Count > 0 then begin//20080629
    for I := 0 to BaseObjectList.Count - 1 do begin
      BaseObject := TBaseObject(BaseObjectList.Items[I]);
      if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
      if PlayObject.IsProperTarget(BaseObject) then begin
        if (Random(10) >= BaseObject.m_nAntiMagic) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC),
            SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          if BaseObject.m_btLifeAttrib = LA_UNDEAD then nPower := Round(nPower * 1.5);
          if BaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(BaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 2, Integer(BaseObject), '', 600);
          if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
          else if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
        end;
        if (BaseObject.m_nCurrX <> nTargetX) or (BaseObject.m_nCurrY <> nTargetY) then
          PlayObject.SendRefMsg(RM_10205, 4{type}, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 0, '');
      end;
    end;
   {$IF M2Version = 1}
    if (nPower > 0) and Result then begin//����װ����Ѫ
      if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
        if Random(100) <= PlayObject.m_nVampireRate then begin
          nPower:= 0;
          nPower := Random(PlayObject.m_nVampirePoint);
          if nPower > 0 then PlayObject.DamageHealth(-nPower);
        end;
      end;
    end;
    {$IFEND}
  end;
  BaseObjectList.Free;
end;
//ʩ����  ���û��Ŀ��,�� boSpellFire:=False,�򲻷ų���Ч��
//0��--11�� 1��--14�� 2��--17�� 3��--20�� 
//ʱ��=11+3*���ܵȼ�
function TMagicManager.MagLightening(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject; var boSpellFire: Boolean{�Ƿ����}): Boolean;
var
  nPower{$IF M2Version = 1}, NGSecPwr{$IFEND}: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
  nCode: Byte;
  nType: Byte;//������
  function GetPower13(nInt: Integer): Integer; //0049338C
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
      Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + {Random}(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)))
    else Result := Round(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + UserMagic.MagicInfo.btDefPower);
  end;
  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result := {Random}(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt); //��ʹ�����ֵ,ʹ�����̺춾���� 20080328
    end else Result := LoWord(wInt);
  end;
begin
  Result := False;
  nCode:=0;
  nType:= 0;
  try
    boSpellFire:= True;//20080322
    if TargeTBaseObject = nil then Exit;//20080908
    if (TargeTBaseObject.m_btRaceServer in [79, 109, 128, 143, 145, 147, 151, 153, 156..158]) then Exit;//20090111 ����ħ��,�����ޣ���������ܶ�
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin
      nCode:=1;
      if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then begin
        StdItem := nil;//20080722
        nCode:=3;
        if (nAmuletIdx = U_ARMRINGL) or (nAmuletIdx = U_BUJUK) then begin//20080722 �޸�
          nCode:=4;
          if PlayObject.m_UseItems[nAmuletIdx].wIndex > 0 then//20080623 ����
              StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
        end;
        nCode:=5;
        if (StdItem = nil) or ((StdItem <> nil) and (StdItem.StdMode <> 25)) then StdItem:= UserEngine.GetStdItem(nAmuletIdx); //���װ������û����Ʒ,��Ӱ������� 20080314
        nCode:=6;
        if StdItem <> nil then begin
          nCode:=7;
          UseAmulet(PlayObject, 1, 2, nAmuletIdx);
          nCode:=8;
          if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then begin
            case StdItem.Shape of
              1: begin
                  nCode:=9;
                  nPower := GetPower13({40}20) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                  //nPower :=11 + UserMagic.btLevel * 3 ;//20080329 �޸�ʱ���㷨
                  {$IF M2Version = 1}
                  case PlayObject.m_btRaceServer of
                    RC_PLAYOBJECT: begin
                      NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                      end;
                      nPower := _MAX(0, nPower + NGSecPwr);
                    end;
                    RC_HEROOBJECT: begin
                      NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                      end;
                      nPower := _MAX(0, nPower + NGSecPwr);
                    end;
                    RC_PLAYMOSTER: begin
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                        nPower := _MAX(0, nPower - NGSecPwr);
                      end;
                    end;
                  end;//case
                  {$IFEND}
                  {$IF M2Version <> 2}
                  if (UserMagic.wMagIdx = SKILL_93) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
                    if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                      if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                        nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[10] /100)))
                      end;
                    end;
                    TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
                  end;
                  {$IFEND}
                  nCode:=10;
                  nType:= 1;
                  TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, _MIN(nPower, g_Config.nMaxMakePosionTime), Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000{150});//20110723 �޸�
                  if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                    TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

                end;
              2: begin
                  nCode:=11;
                  nPower := GetPower13({40}20) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                  //nPower :=11 + UserMagic.btLevel * 3 ;//20080329 �޸�ʱ���㷨
                  {$IF M2Version = 1}
                  case PlayObject.m_btRaceServer of
                    RC_PLAYOBJECT: begin
                      NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                      end;
                      nPower := _MAX(0, nPower + NGSecPwr);
                    end;
                    RC_HEROOBJECT: begin
                      NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_239,nPower);//ŭ֮ʩ����
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                      end;
                      nPower := _MAX(0, nPower + NGSecPwr);
                    end;
                    RC_PLAYMOSTER: begin
                      if TargeTBaseObject <> nil then begin
                        case TargeTBaseObject.m_btRaceServer of
                          RC_PLAYOBJECT: NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                          RC_HEROOBJECT: NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_240,nPower);//��֮ʩ����
                        end;
                        nPower := _MAX(0, nPower - NGSecPwr);
                      end;
                    end;
                  end;//case
                  {$IFEND}
                  {$IF M2Version <> 2}
                  if (UserMagic.wMagIdx = SKILL_93) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//����ǿ�����ܵ�����
                    if (TPlayObject(PlayObject).m_MagicSkill_105 <> nil) or (TPlayObject(PlayObject).m_MagicSkill_106 <> nil) then begin
                      if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin
                        nPower := nPower + Round(nPower * (UserMagic.btLevelEx * (g_Config.nSKILLStrongRate[10] /100)))
                      end;
                    end;
                    TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
                  end;
                  {$IFEND}
                  nCode:=12;
                  nType:= 2;
                  TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {�ж����� - �춾}, _MIN(nPower, g_Config.nMaxMakePosionTime), Integer(PlayObject), Round(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)), '', 1000{150});//20110723 �޸�
                  if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                    TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
                end;
            end;
            nCode:= 13;
            if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
          end;
          nCode:=14;
          if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
            nCode:=15;
            if not THeroObject(PlayObject).m_boTarget then PlayObject.SetTargetCreat(TargeTBaseObject);
          end else PlayObject.SetTargetCreat(TargeTBaseObject);
          if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin//20081102 ������Ӣ��,Ӣ�۲�����
            if not THeroObject(TargeTBaseObject).m_boTarget then TargeTBaseObject.SetTargetCreat(PlayObject);
          end;
          boSpellFire:= False;//20080322 ʩ��������
        end;
      end else begin//�޶�ʱ��ʾ 20100815
        if PlayObject.m_btRaceServer = RC_HEROOBJECT then
          THeroObject(PlayObject).SysMsg('(Ӣ��) ��Ķ����þ�', c_Blue, t_Hint)
        else PlayObject.SysMsg('��Ķ����þ�', c_Blue, t_Hint);
      end;
    end;
    if not boSpellFire then begin//ʩ�������ã��ŷ���Ϣ,�ļ�ʩ����������춾�̶�
      case UserMagic.MagicInfo.wMagicId of
        SKILL_AMYOUNSUL{6}: begin //ʩ����,�ļ�ʩ����
          if (UserMagic.btLevelEx > 0) and (UserMagic.btLevelEx < 10) then begin//ǿ��ʩ����
            if nType = 2 then begin
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 78),
                                MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end else begin
              PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 77),
                                MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
            end;
          end else begin
            PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                              MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        end;
        SKILL_93{93}: begin //�ļ�ʩ����
          if nType = 2 then begin
            PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, 78),
                              MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end else begin
            PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                              MakeLong(nTargetX, nTargetY),Integer(TargeTBaseObject),'');
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagLightening Code:%d',[g_sExceptionVer, nCode]));
  end;
end;
//������ ����ն ��Ӱ����
function TMagicManager.MagHbFireBall(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower, NGSecPwr: Integer;
  nDir: Integer;
  levelgap: Integer;
  push: Integer;
begin
  Result := False;
  if not PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if not PlayObject.IsProperTarget(TargeTBaseObject) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if (TargeTBaseObject.m_nAntiMagic > Random(10)) or (abs(TargeTBaseObject.m_nCurrX - nTargetX) > 1) or (abs(TargeTBaseObject.m_nCurrY - nTargetY) > 1) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  with PlayObject do begin
    nPower := GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(m_WAbil.MC),
      SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
  end;
  {$IF M2Version <> 2}
  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
    NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_226,nPower);//ŭ֮������
    if TargeTBaseObject <> nil then begin
      if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
        NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_227,nPower);//��֮������
      end else
      if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
        NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_227,nPower);//��֮������
      end;
    end;
    nPower := _MAX(0, nPower + NGSecPwr);
  end else
  if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
    NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_226,nPower);//ŭ֮������
    if TargeTBaseObject <> nil then begin
      if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
        NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_227,nPower);//��֮������
      end else
      if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
        NGSecPwr:= NGSecPwr - GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_227,nPower);//��֮������
      end;
    end;
    nPower := _MAX(0, nPower + NGSecPwr);
  end;
  {$IFEND}
  PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
  {$IF M2Version = 1}
  if nPower > 0 then begin//����װ����Ѫ
    if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
      if Random(100) <= PlayObject.m_nVampireRate then begin
        NGSecPwr:= 0;
        NGSecPwr := Random(PlayObject.m_nVampirePoint);
        if NGSecPwr > 0 then PlayObject.DamageHealth(-NGSecPwr);
      end;
    end;
  end;
  {$IFEND}
  if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
  if (UserMagic <> nil) and (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) then
    TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� By TasNat at: 2012-07-21 15:13:25
  if (UserMagic.MagicInfo.wMagicId = 44) and (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin //�����Ʋż���Ƿ�����Խ�ָ,�Է�û�з���
    if PlayObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
      and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
      TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(PlayObject), 0{����}, '', 600);
    end else
    if PlayObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
      and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ 20091009
      TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(PlayObject), 0{����}, '', 600);

    end;
  end;
  if (PlayObject.m_Abil.Level > TargeTBaseObject.m_Abil.Level) and (not TargeTBaseObject.m_boStickMode) then begin
    levelgap := PlayObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
    if (Random(20) < 6 + UserMagic.btLevel * 3 + levelgap) then begin
      push := Random(UserMagic.btLevel) - 1;
      if push > 0 then begin
        nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYPUSHED, nDir, MakeLong(nTargetX, nTargetY), push, Integer(TargeTBaseObject), '', 600);
      end;
    end;
  end;
end;

//����������״�Ļ�
function TMagicManager.MagMakeSuperFireCross(PlayObject: TBaseObject; nDamage,
  nHTime, nX, nY: Integer; nCount: Integer): Integer;
  function MagMakeSuperFireCrossOfDir(btDir: Integer): Integer;
  var
    FireBurnEvent: TFireBurnEvent;
    I,{ II,} x, y: Integer;
    nTime: Integer;
   // x1, X2, y1, y2: string;
  begin
    Result := 0;
    nTime := 1;
    case btDir of
      DR_UP: begin
          for y := PlayObject.m_nCurrY downto PlayObject.m_nCurrY - 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, PlayObject.m_nCurrX, y, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_UPRIGHT: begin
          for I := 0 to 6 do begin
            x := PlayObject.m_nCurrX + I;
            y := PlayObject.m_nCurrY - I;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_RIGHT: begin
          for x := PlayObject.m_nCurrX to PlayObject.m_nCurrX + 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, PlayObject.m_nCurrY, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWNRIGHT: begin
          for I := 0 to 6 do begin
            x := PlayObject.m_nCurrX + I;
            y := PlayObject.m_nCurrY + I;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWN: begin
          for y := PlayObject.m_nCurrY to PlayObject.m_nCurrY + 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, PlayObject.m_nCurrX, y, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWNLEFT: begin
          for I := 0 to 6 do begin
            x := PlayObject.m_nCurrX - I;
            y := PlayObject.m_nCurrY + I;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_LEFT: begin
          for x := PlayObject.m_nCurrX downto PlayObject.m_nCurrX - 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, PlayObject.m_nCurrY, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_UPLEFT: begin
          for I := 0 to 6 do begin
            x := PlayObject.m_nCurrX - I;
            y := PlayObject.m_nCurrY - I;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
    end;
    Result := 1;
  end;
var
  I: Integer;
begin
  Result := 0;
  case nCount of
    1: begin
        Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
      end;
    3: begin
        case PlayObject.m_btDirection of
          DR_UP: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
            end;
          DR_UPRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
          DR_RIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWNRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
            end;
          DR_DOWN: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWNLEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
            end;
          DR_LEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
            end;
          DR_UPLEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
            end;
        end;
      end;
    4: begin
        Result := MagMakeSuperFireCrossOfDir(DR_UP);
        Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
        Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
        Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
      end;
    5: begin
        case PlayObject.m_btDirection of
          DR_UP, DR_UPLEFT, DR_UPRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
          DR_LEFT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
            end;
          DR_RIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWN, DR_DOWNLEFT, DR_DOWNRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
        end;
      end;
    8: begin
        for I := DR_UP to DR_UPLEFT do Result := MagMakeSuperFireCrossOfDir(I);
      end;
  end;
end;

//��ǽ 2*2��Χ
function TMagicManager.MagMakeFireCross(PlayObject: TBaseObject; nDamage,
  nHTime, nX, nY: Integer; LevelEx: Byte): Integer;
var
  FireBurnEvent: TFireBurnEvent;
  NGSecPwr,nScePwr: Integer;
  boCrossForFengHao: Boolean;
begin
  nHTime := _MIN(g_Config.nFireMaxTime, nHTime);//���ƻ�ǽ�����Чʱ�� By TasNat at: 2012-03-17 13:59:47
  Result := 0;
  boCrossForFengHao:= False;
  nScePwr:= nDamage;
  if g_Config.boDisableInSafeZoneFireCross and PlayObject.InSafeZone(PlayObject.m_PEnvir, nX, nY) then begin
    PlayObject.SysMsg('��ȫ��������ʹ��...', c_Red, t_Notice);
    Exit;
  end;
  {$IF M2Version <> 2}
  if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
    NGSecPwr := GetNGPow(PlayObject, TPlayObject(PlayObject).m_MagicSkill_212,nDamage);//ŭ֮��ǽ
    nDamage := _MAX(0, nDamage + NGSecPwr);
    boCrossForFengHao:= TPlayObject(PlayObject).m_boFengHaoMagicEffect;//ħ���ۺ�Ч��(����֮��)
  end else
  if (PlayObject.m_btRaceServer = RC_HEROOBJECT) then begin
    NGSecPwr := GetNGPow(PlayObject, THEROOBJECT(PlayObject).m_MagicSkill_212,nDamage);//ŭ֮��ǽ
    nDamage := _MAX(0, nDamage + NGSecPwr);
  end;
  {$IFEND}
  if PlayObject.m_PEnvir.GetEvent(nX, nY - 1) = nil then begin
    if (LevelEx > 0) and (LevelEx < 10) then begin//ǿ����ǽ
      case LevelEx of
        1..3: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE_1, nHTime * 1000, nDamage);
        4..6: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE_2, nHTime * 1000, nDamage);
        7..9: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE_3, nHTime * 1000, nDamage);
      end;
    end else begin
      if not boCrossForFengHao then
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE, nHTime * 1000, nDamage)
      else FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE_FENGHAO, nHTime * 1000, nDamage);
    end;
    FireBurnEvent.nTwoPwr:= nScePwr;
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY) = nil then begin
    if (LevelEx > 0) and (LevelEx < 10) then begin//ǿ����ǽ
      case LevelEx of
        1..3: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE_1, nHTime * 1000, nDamage);
        4..6: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE_2, nHTime * 1000, nDamage);
        7..9: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE_3, nHTime * 1000, nDamage);
      end;
    end else begin
      if not boCrossForFengHao then
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE, nHTime * 1000, nDamage)
      else FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE_FENGHAO, nHTime * 1000, nDamage);
    end;
    FireBurnEvent.nTwoPwr:= nScePwr;
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX, nY) = nil then begin
    if (LevelEx > 0) and (LevelEx < 10) then begin//ǿ����ǽ
      case LevelEx of
        1..3: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE_1, nHTime * 1000, nDamage);
        4..6: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE_2, nHTime * 1000, nDamage);
        7..9: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE_3, nHTime * 1000, nDamage);
      end;
    end else begin
      if not boCrossForFengHao then
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE, nHTime * 1000, nDamage)
      else FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE_FENGHAO, nHTime * 1000, nDamage);
    end;
    FireBurnEvent.nTwoPwr:= nScePwr;
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY) = nil then begin
    if (LevelEx > 0) and (LevelEx < 10) then begin//ǿ����ǽ
      case LevelEx of
        1..3: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE_1, nHTime * 1000, nDamage);
        4..6: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE_2, nHTime * 1000, nDamage);
        7..9: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE_3, nHTime * 1000, nDamage);
      end;
    end else begin
      if not boCrossForFengHao then
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE, nHTime * 1000, nDamage)
      else FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE_FENGHAO, nHTime * 1000, nDamage);
    end;
    FireBurnEvent.nTwoPwr:= nScePwr;
    g_EventManager.AddEvent(FireBurnEvent);
  end; 
  if PlayObject.m_PEnvir.GetEvent(nX, nY + 1) = nil then begin
    if (LevelEx > 0) and (LevelEx < 10) then begin//ǿ����ǽ
      case LevelEx of
        1..3: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE_1, nHTime * 1000, nDamage);
        4..6: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE_2, nHTime * 1000, nDamage);
        7..9: FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE_3, nHTime * 1000, nDamage);
      end;
    end else begin
      if not boCrossForFengHao then
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE, nHTime * 1000, nDamage)
      else FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE_FENGHAO, nHTime * 1000, nDamage);
    end;
    FireBurnEvent.nTwoPwr:= nScePwr;
    g_EventManager.AddEvent(FireBurnEvent);
  end;
  Result := 1;
end;
//������ ���ѻ���
function TMagicManager.MagBigExplosion(BaseObject: TBaseObject; nPower, nX,
  nY: Integer; nRage: Integer; nCode:Byte): Boolean;
var
  I, NGSecPwr, nSePwr, nTwoPwr: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    nTwoPwr:= nPower;
    if BaseObjectList.Count > 0 then begin//20080629
      {$IF M2Version <> 2}
      case nCode of
        SKILL_FIREBOOM: begin//���ѻ���
            if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
              if TPlayObject(BaseObject).m_MagicSkill_218 <> nil then begin//20081223
                NGSecPwr := GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_218,nTwoPwr);//ŭ֮���ѻ���
                nPower := nPower + NGSecPwr;
              end;
            end else
            if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
              if THEROOBJECT(BaseObject).m_MagicSkill_218 <> nil then begin//20081223
                NGSecPwr := GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_218,nTwoPwr);//ŭ֮���ѻ���
                nPower := nPower + NGSecPwr;
              end;
            end;
         end;
        SKILL_SNOWWIND: begin//������
            if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
              if TPlayObject(BaseObject).m_MagicSkill_220 <> nil then begin//20081223
                NGSecPwr := GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_220,nTwoPwr);//ŭ֮������
                nPower := nPower + NGSecPwr;
              end;
            end else
            if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
              if THEROOBJECT(BaseObject).m_MagicSkill_220 <> nil then begin//20081223
                NGSecPwr := GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_220,nTwoPwr);//ŭ֮������
                nPower := nPower + NGSecPwr;
              end;
            end;
         end;
      end;
      {$IFEND}
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin//20090304
          if BaseObject.IsProperTarget(TargeTBaseObject) then begin
            if Random(TargeTBaseObject.m_nAntiMagic + 10) <= 10 then begin//20090526 ����ħ�����
              nSePwr:= nPower;
              if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
                 if not THeroObject(BaseObject).m_boTarget then BaseObject.SetTargetCreat(TargeTBaseObject);
              end else BaseObject.SetTargetCreat(TargeTBaseObject);
              {$IF M2Version <> 2}
              case nCode of
                SKILL_FIREBOOM: begin//���ѻ���
                    NGSecPwr:= 0;
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_219,nTwoPwr);//��֮���ѻ���
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_219,nTwoPwr);//��֮���ѻ���
                    end;
                    nSePwr := _MAX(0, nSePwr - NGSecPwr);
                  end;
                SKILL_SNOWWIND: begin//������
                    NGSecPwr:= 0;
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_221,nTwoPwr);//��֮������
                    end else
                    if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                      NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_221,nTwoPwr);//��֮������
                    end;
                    nSePwr := _MAX(0, nSePwr - NGSecPwr);
                  end;
              end;
              {$IFEND}
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(nCode));//���＼�ܴ��� 20080609


              TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nSePwr, 0, 0, '');
              Result := True;
            end;
          end;
        end;
      end;
     {$IF M2Version = 1}
      if (nSePwr > 0) and Result then begin//����װ����Ѫ
        if (BaseObject.m_nVampirePoint > 0) and ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= BaseObject.m_nVampireRate then begin
            nSePwr:= 0;
            nSePwr := Random(BaseObject.m_nVampirePoint);
            if nSePwr > 0 then BaseObject.DamageHealth(-nSePwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.Free;
  end;
end;
//���ǻ��� 20080510
function TMagicManager.MagBigExplosion1(BaseObject: TBaseObject; nPower, nX,
  nY: Integer; nRage: Integer; var TargeObject: TBaseObject; boHeartSkill: Boolean; nID : Integer): Boolean;
var
  I, NGSecPwr, nSePwr, nTwoPwr: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  Try
    BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, nRage, BaseObjectList);
    nTwoPwr:= nPower;
    if BaseObjectList.Count > 0 then begin//20080629
      {$IF M2Version <> 2}
      if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        if TPlayObject(BaseObject).m_MagicSkill_234 <> nil then begin//20081223
          NGSecPwr := GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_234, nTwoPwr);//ŭ֮���ǻ���
          if NGSecPwr > 0 then nPower := nPower + NGSecPwr;
        end;
      end else
      if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
        if THEROOBJECT(BaseObject).m_MagicSkill_234 <> nil then begin//20081223
          NGSecPwr := GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_234, nTwoPwr);//ŭ֮���ǻ���
          if NGSecPwr > 0 then nPower := nPower + NGSecPwr;
        end;
      end;
      {$IFEND}
      if nPower > 0 then begin
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin
            if (BaseObject.m_btRaceServer = RC_HEROOBJECT) or (BaseObject.m_btRaceServer = RC_PLAYMOSTER) then BaseObject.m_ExpHitter := TargeTBaseObject;//20081221 Ӣ�ۿ��԰���Χ��Ŀ��
            if BaseObject.IsProperTarget(TargeTBaseObject) then begin
              if BaseObject.m_btRaceServer = RC_HEROOBJECT then begin //20080531 ����Ӣ��������,����������
                if not THeroObject(BaseObject).m_boTarget then BaseObject.SetTargetCreat(TargeTBaseObject);
              end else BaseObject.SetTargetCreat(TargeTBaseObject);
              nSePwr:= 0;
              NGSecPwr:= 0;
              {$IF M2Version <> 2}
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_235, nTwoPwr);//��֮���ǻ���
              end else
              if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
                NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_235, nTwoPwr);//��֮���ǻ���
              end;
              {$IFEND}
              nSePwr := _MAX(0, nPower - NGSecPwr);
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(nId));//���＼�ܴ��� 20080609


              TargeTBaseObject.SendDelayMsg(BaseObject, RM_MAGSTRUCK, 0, nSePwr, 0, 0, '', 600);
              if (TargeTBaseObject.m_wStatusArrValue[10] = 0) and boHeartSkill then begin
                TargeTBaseObject.MagDownHealth(1, 1, Round(nSePwr * 0.1)+ 1);//����
              end;
              if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then begin//�Է�û�з��� 20101104����
                if TargeObject = TargeTBaseObject then begin
                  if BaseObject.m_boParalysis3 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate3 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
                    TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime3{ʱ��}, Integer(BaseObject), 0{����}, '', 600);
                  end else
                  if BaseObject.m_boParalysis2 and (Random(TargeTBaseObject.m_btAntiPoison + g_Config.nAttackPosionRate2 {5}) = 0)
                    and (Random(100) >= TargeTBaseObject.m_nUnParalysisRate) then begin//ħ����Խ�ָ
                    TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, g_Config.nAttackPosionTime2{ʱ��}, Integer(BaseObject), 0{����}, '', 600);
                  end;
                end;
              end;
              Result := True;
            end;
          end;
        end;
       {$IF M2Version = 1}
        if (nSePwr > 0) and Result then begin//����װ����Ѫ
          if (BaseObject.m_nVampirePoint > 0) and ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= BaseObject.m_nVampireRate then begin
              nSePwr:= 0;
              nSePwr := Random(BaseObject.m_nVampirePoint);
              if nSePwr > 0 then BaseObject.DamageHealth(-nSePwr);
            end;
          end;
        end;
        {$IFEND}
      end;
    end;
  Finally
    BaseObjectList.Free;
  end;
end;
//�����׹�
function TMagicManager.MagElecBlizzard(BaseObject: TBaseObject; nPower: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerPoint, NGSecPwr, nSewPwr, nTwoPwr: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(BaseObject.m_nCurrX, BaseObject.m_nCurrY, g_Config.nElecBlizzardRange {2}, BaseObjectList);
    nTwoPwr:= nPower;
    if BaseObjectList.Count > 0 then begin//20080629
      {$IF M2Version <> 2}
      if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        if TPlayObject(BaseObject).m_MagicSkill_224 <> nil then begin//20081223
          NGSecPwr := GetNGPow(BaseObject, TPlayObject(BaseObject).m_MagicSkill_224, nTwoPwr);//ŭ֮�����׹�
          nPower := nPower + NGSecPwr;
        end;
      end else
      if (BaseObject.m_btRaceServer = RC_HEROOBJECT) then begin
        if THEROOBJECT(BaseObject).m_MagicSkill_224 <> nil then begin//20081223
          NGSecPwr := GetNGPow(BaseObject, THEROOBJECT(BaseObject).m_MagicSkill_224, nTwoPwr);//ŭ֮�����׹�
          nPower := nPower + NGSecPwr;
        end;
      end;
      {$IFEND}
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        NGSecPwr:= 0;
        {$IF M2Version <> 2}
        //if nPower > nTwoPwr then begin//20081223 20090304�޸�
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
            NGSecPwr:= GetNGPow(TargeTBaseObject, TPlayObject(TargeTBaseObject).m_MagicSkill_225, nTwoPwr);//��֮�����׹�
          end else
          if TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT then begin
            NGSecPwr:= GetNGPow(TargeTBaseObject, THEROOBJECT(TargeTBaseObject).m_MagicSkill_225, nTwoPwr);//��֮�����׹�
          end;
        //end;
        {$IFEND}
        nSewPwr := _MAX(0, nPower - NGSecPwr);

        if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then begin//��Ϊ����ϵ
          nPowerPoint := nSewPwr div 10;
        end else nPowerPoint := nSewPwr;

        if BaseObject.IsProperTarget(TargeTBaseObject) then begin
          //BaseObject.SetTargetCreat(TargeTBaseObject);
          TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPowerPoint, 0, 0, '');
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(SKILL_LIGHTFLOWER));//���＼�ܴ��� 20080609

          Result := True;
        end;
      end;
     {$IF M2Version = 1}
      if (nSewPwr > 0) and Result then begin//����װ����Ѫ
        if (BaseObject.m_nVampirePoint > 0) and ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= BaseObject.m_nVampireRate then begin
            nSewPwr:= 0;
            nSewPwr := Random(BaseObject.m_nVampirePoint);
            if nSewPwr > 0 then BaseObject.DamageHealth(-nSewPwr);
          end;
        end;
      end;
      {$IFEND}
    end;
  finally
    BaseObjectList.Free;
  end;
end;
//��ħ��
function TMagicManager.MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer; //004928C0
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  MagicEvent: pTMagicEvent;
  HolyCurtainEvent: THolyCurtainEvent;
begin
  Result := 0;
  if BaseObject.m_PEnvir.CanWalk(nX, nY, True) then begin
    BaseObjectList := TList.Create;
    try
      MagicEvent := nil;
      BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, 1, BaseObjectList);
      if BaseObjectList.Count > 0 then begin//20080629
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin//20090505
            if ((TargeTBaseObject.m_btRaceServer = 127) or//��ħ���� �����жϵȼ� 20090112
              ((TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and ((Random(4) + (BaseObject.m_Abil.Level - 1))> TargeTBaseObject.m_Abil.Level)))
               and(TargeTBaseObject.m_Master = nil) then begin
              TargeTBaseObject.OpenHolySeizeMode(nPower * 1000);
              if MagicEvent = nil then begin
                New(MagicEvent);
                FillChar(MagicEvent^, SizeOf(TMagicEvent), #0);
                MagicEvent.BaseObjectList := TList.Create;
                MagicEvent.dwStartTick := GetTickCount();
                MagicEvent.dwTime := nPower * 1000;
              end;
              MagicEvent.BaseObjectList.Add(TargeTBaseObject);
              Inc(Result);
            end else begin
              Result := 0;
            end;
          end;
        end;
      end;
    finally
      BaseObjectList.Free;
    end;
    if (Result > 0) and (MagicEvent <> nil) then begin
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[0] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[1] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[2] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[3] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[4] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[5] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[6] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[7] := HolyCurtainEvent;
      UserEngine.m_MagicEventList.Add(MagicEvent);
    end else begin
      if MagicEvent <> nil then begin
        MagicEvent.BaseObjectList.Free;
        Dispose(MagicEvent);
      end;
    end;
  end;
end;
//Ⱥ��������
function TMagicManager.MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY,
  nHTime: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    BaseObject.m_PEnvir.GetMapBaseObjects(nX, nY, 1, BaseObjectList);
    if BaseObjectList.Count > 0 then begin//20080629
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
        if TargeTBaseObject <> nil then begin//20090310
          if BaseObject.IsProperFriend(TargeTBaseObject) then begin
            if TargeTBaseObject.m_wStatusTimeArr[STATE_TRANSPARENT ] = 0 then begin
              TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_TRANSPARENT, 0, nHTime, 0, 0, '', 800);
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(SKILL_BIGCLOAK));//���＼�ܴ��� 20080609
              Result := True;
            end;
          end;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
end;
//=====================================================================================
//���ƣ�
//���ܣ�
//������
//     BaseObject       ħ��������
//     TargeTBaseObject �ܹ�����ɫ
//     nPower           ħ������С
//     nLevel           ���������ȼ�
//     nTargetX         Ŀ������X
//     nTargetY         Ŀ������Y
//����ֵ��
//=====================================================================================
function TMagicManager.MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel,
  nTargetX, nTargetY: Integer): Boolean;
var
  nLv: Integer;
begin
  Result := False;
  if BaseObject.MagCanHitTarget(BaseObject.m_nCurrX, BaseObject.m_nCurrY, TargeTBaseObject) then begin
    if BaseObject.IsProperTarget(TargeTBaseObject) and (BaseObject <> TargeTBaseObject) then begin
      if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
        BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, nPower div 3, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
        if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
          nLv := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
          if (Random(g_Config.nMabMabeHitRandRate {100}) < _MAX(g_Config.nMabMabeHitMinLvLimit, (nLevel * 8) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
            // if (Random(100) < ((nLevel shl 3) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
            if (Random(g_Config.nMabMabeHitSucessRate {21}) < nLevel * 2 + 4) then begin
              if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT){or (TargeTBaseObject.m_btRaceServer = RC_HEROOBJECT)} then begin//Ӣ�ۻ�ɫ 20080721
                BaseObject.SetPKFlag(BaseObject);
                BaseObject.SetTargetCreat(TargeTBaseObject);
              end;
              TargeTBaseObject.SetLastHiter(BaseObject);
              nPower := TargeTBaseObject.GetMagStruckDamage(BaseObject, nPower, 0, 1);
              BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
              if (not TargeTBaseObject.m_boUnParalysis){$IF M2Version <> 2} and (not TargeTBaseObject.m_boCanUerSkill102){$IFEND} then
                TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, nPower div g_Config.nMabMabeHitMabeTimeRate {20} + Random(nLevel), Integer(BaseObject), nLevel, '', 650);
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(SKILL_MABE));//���＼�ܴ��� 20080609

              Result := True;
            end;
          end;
        end;
      end;
    end;
  end;
end;
//�ٻ���ħ
function TMagicManager.MagMakeCallTrollSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    try
      if not PlayObject.sub_4DD704 then begin
        case UserMagic.btLevel of
          0: sMonName := g_Config.sCallTroll;//������
          1..2: sMonName := g_Config.sCallTroll1;
          3..4: sMonName := g_Config.sCallTroll2;
        end;
        nMakeLevel := UserMagic.btLevel;//�ٻ��ȼ�
        nExpLevel := UserMagic.btLevel;//�����ȼ�
        dwRoyaltySec := g_Config.dwDoCallTrollTime;//���ʱ��5����(�ѱ�ʱ��)
        if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, 1{�����ٻ�����}, dwRoyaltySec) <> nil then begin
          Result := True;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeCallTrollSlave',[g_sExceptionVer]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;

//�ٻ�ʥ��
function TMagicManager.MagMakeShengSuSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  I, nSpellPoint, nCount, nMakeLevel, nExpLevel: Integer;
  sMonName: string;
  dwRoyaltySec: LongWord;
  Slave, Slave1: TBaseObject;
  nCode: Byte;
  function GetSuSlaveSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.btLevel < 4 then begin
      Result := Round(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
    end else Result := Round(UserMagic.MagicInfo.wSpell / 4 * 5) + UserMagic.MagicInfo.btDefSpell;
  end;
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    nSpellPoint := GetSuSlaveSpellPoint(UserMagic);
    if (nSpellPoint > 0) then begin
      if PlayObject.m_WAbil.MP < nSpellPoint then Exit;
      PlayObject.DamageSpell(nSpellPoint);
      PlayObject.HealthSpellChanged();
    end;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sSacredName;//������
        nMakeLevel := UserMagic.btLevel;//�ٻ��ȼ�
        nExpLevel := UserMagic.btLevel;//�����ȼ�
        nCount := g_Config.nSacredCount;//�����ٻ�ʥ������
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        for I := Low(g_Config.SacredArray) to High(g_Config.SacredArray) do begin
          if g_Config.SacredArray[I].nHumLevel = 0 then Break;
          if PlayObject.m_Abil.Level >= g_Config.SacredArray[I].nHumLevel then begin
            sMonName := g_Config.SacredArray[I].sMonName;
            nExpLevel := g_Config.SacredArray[I].nLevel;
            nCount := g_Config.SacredArray[I].nCount;
          end;
        end;
        nCode:= 3;
        Slave1:= PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec);
        if Slave1 <> nil then begin
          Slave1.n294 := UserMagic.nTranPoint;//ɱ������
          Result := True;
          {$IF M2Version <> 2}
          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            if UserMagic.btLevel > 98 then begin
              TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
            end;  
          end;
          {$IFEND}
        end else begin //���г���������,�ɵ��������
          nCode:= 4;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 5;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin
                if (CompareText(Slave.m_sCharName, sMonName) = 0) or (CompareText(Slave.m_sCharName, sMonName+'1') = 0) then begin
                  nCode:= 6;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;
                  nCode:= 7;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeShengSuSlave Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//ǿ���ٻ�ʥ��
function TMagicManager.MagMakeShengSuSlaveEx(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var boSpellFire: Boolean): Boolean;
var
  I, nSpellPoint, nCount, nMakeLevel, nExpLevel: Integer;
  sMonName: string;
  dwRoyaltySec: LongWord;
  Slave, Slave1: TBaseObject;
  nCode: Byte;
  function GetSuSlaveSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    if UserMagic.btLevel < 4 then begin
      Result := Round(UserMagic.MagicInfo.wSpell / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefSpell;
    end else Result := Round(UserMagic.MagicInfo.wSpell / 4 * 5) + UserMagic.MagicInfo.btDefSpell;
  end;
begin
  Result := False;
  boSpellFire:= True;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    nSpellPoint := GetSuSlaveSpellPoint(UserMagic);
    if (nSpellPoint > 0) then begin
      if PlayObject.m_WAbil.MP < nSpellPoint then Exit;
      PlayObject.DamageSpell(nSpellPoint);
      PlayObject.HealthSpellChanged();
    end;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sSkillStrongSacred;
        nMakeLevel := UserMagic.btLevelEx;
        nExpLevel := UserMagic.btLevel;
        nCount := g_Config.nSacredCount;//�����ٻ�ʥ������
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        Slave1:= PlayObject.MakeSlaveEx(sMonName, nMakeLevel, nExpLevel, nCount, nTargetX, nTargetY, dwRoyaltySec);
        if Slave1 <> nil then begin
          boSpellFire:= False;
          Slave1.n294 := UserMagic.nTranPoint;//ɱ������
          PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                            MakeLong(Slave1.m_nCurrX, Slave1.m_nCurrY),Integer(Slave1),'');
          Slave1.RefNameColor;
          Result := True;
          {$IF M2Version <> 2}
          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            if UserMagic.btLevel > 98 then begin
              TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
            end;  
          end;
          {$IFEND}
        end else begin //���г�����,�ɵ��������
          nCode:= 4;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 5;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin
                if (CompareText(Slave.m_sCharName, sMonName) = 0) or (CompareText(Slave.m_sCharName, sMonName+'1') = 0) then begin
                  nCode:= 6;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;
                  nCode:= 7;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeShengSuSlaveEx Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;

//�ٻ�����
function TMagicManager.MagMakeSinSuSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  I: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
  Slave: TBaseObject;//20080218
  nCode: Byte;//20080604
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sDogz;//������
        nMakeLevel := UserMagic.btLevel;
        nExpLevel := UserMagic.btLevel;
        nCount := g_Config.nDogzCount;//�����ٻ���������
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        for I := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
          if g_Config.DogzArray[I].nHumLevel = 0 then Break;
          if PlayObject.m_Abil.Level >= g_Config.DogzArray[I].nHumLevel then begin
            sMonName := g_Config.DogzArray[I].sMonName;
            nExpLevel := g_Config.DogzArray[I].nLevel;
            nCount := g_Config.DogzArray[I].nCount;
          end;
        end;
        nCode:= 3;
        if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then begin
          Result := True;
        end else begin //���г���������,�ɵ�������� 20080218
          nCode:= 4;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin//20080713
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 5;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin//20080604
                if (CompareText(Slave.m_sCharName, sMonName) = 0) or (CompareText(Slave.m_sCharName, sMonName+'1') = 0) then begin
                  nCode:= 6;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;//20080527 �����ٻ�����ߺ�,����ȥ��ԭ����Ŀ��
                  nCode:= 7;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                  //Break;//20080504 �������ʱ,һ���
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeSinSuSlave Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//�ٻ�����
function TMagicManager.MagMakeSlave(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  I, nMakeLevel, nExpLevel, nCount: Integer;
  sMonName: string;
  dwRoyaltySec: LongWord;
  Slave: TBaseObject;//20080323
  nCode: Byte;//20080604
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sBoneFamm;
        nMakeLevel := UserMagic.btLevel;
        nExpLevel := UserMagic.btLevel;
        nCount := g_Config.nBoneFammCount;
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        for I := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
          nCode:= 3;
          if g_Config.BoneFammArray[I].nHumLevel = 0 then Break;
          nCode:= 4;
          if PlayObject.m_Abil.Level >= g_Config.BoneFammArray[I].nHumLevel then begin
            nCode:= 5;
            sMonName := g_Config.BoneFammArray[I].sMonName;
            nExpLevel := g_Config.BoneFammArray[I].nLevel;
            nCount := g_Config.BoneFammArray[I].nCount;
            nCode:= 6;
          end;
        end;
        nCode:= 7;
        if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then begin
          nCode:= 8;
          Result := True;
          {$IF M2Version <> 2}
          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            if UserMagic.btLevel > 2 then
              TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
          end;
          {$IFEND}
        end else begin //���г����ı�������,�ɵ�������� //20080323
          nCode:= 9;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin//20080713
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              nCode:= 10;
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 11;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin//20080604
                if CompareText(Slave.m_sCharName, sMonName) = 0 then begin
                  nCode:= 12;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;//20080527 �����ٻ�����ߺ�,����ȥ��ԭ����Ŀ��
                  nCode:= 13;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                  //Break;//20080504 �������ʱ,һ���
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeSlave Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//ǿ���ٻ�����
function TMagicManager.MagMakeSlaveEx(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var boSpellFire: Boolean): Boolean;
var
  I, nMakeLevel, nExpLevel, nCount: Integer;
  sMonName: string;
  dwRoyaltySec: LongWord;
  Slave, Slave1: TBaseObject;
  nCode: Byte;
begin
  Result := False;
  boSpellFire:= True;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sSkillStrongBoneFamm;
        nMakeLevel := UserMagic.btLevelEx;
        nExpLevel := UserMagic.btLevelEx;
        nCount := g_Config.nBoneFammCount;
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        Slave1:= PlayObject.MakeSlaveEx(sMonName, nMakeLevel, nExpLevel, nCount, nTargetX, nTargetY, dwRoyaltySec);
        if Slave1 <> nil then begin
          boSpellFire:= False;
          nCode:= 8;
          Result := True;
          PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                            MakeLong(Slave1.m_nCurrX, Slave1.m_nCurrY),Integer(Slave1),'');
          Slave1.RefNameColor;
          {$IF M2Version <> 2}
          nCode:= 81;
          if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin
            if UserMagic.btLevel > 2 then
              TPlayObject(PlayObject).IncreaseSkillLevel(UserMagic);
          end;
          {$IFEND}
        end else begin //���г����ı�������,�ɵ��������
          nCode:= 9;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              nCode:= 10;
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 11;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin
                if CompareText(Slave.m_sCharName, sMonName) = 0 then begin
                  nCode:= 12;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;
                  nCode:= 13;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeSlaveEx Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//�ٻ�����
function TMagicManager.MagMakeFairy(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  I: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
  Slave: TBaseObject;//20080330
  nCode: Byte;//20080604
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sFairy;
        nMakeLevel := UserMagic.btLevel;
        nExpLevel := UserMagic.btLevel;
        nCount := g_Config.nFairyCount;
        dwRoyaltySec := 1728000{20 * 24 * 60 * 60};
        nCode:= 2;
        for I := Low(g_Config.FairyArray) to High(g_Config.FairyArray) do begin
          nCode:= 3;
          if g_Config.FairyArray[I].nHumLevel = 0 then Break;
          nCode:= 4;
          if PlayObject.m_Abil.Level >= g_Config.FairyArray[I].nHumLevel then begin
            nCode:= 5;
            sMonName := g_Config.FairyArray[I].sMonName;
            nExpLevel := g_Config.FairyArray[I].nLevel;
            nCount := g_Config.FairyArray[I].nCount;
            nCode:= 6;
          end;
        end;
        nCode:= 7;
        if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then begin
          Result := True;
        end else begin //���г���������,�ɵ�������� 20080330
          nCode:= 8;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin//20080713
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              nCode:= 9;
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 10;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin//20080604
                nCode:= 11;
                if CompareText(Slave.m_sCharName, sMonName) = 0 then begin
                  nCode:= 12;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;//20080527 �����ٻ�����ߺ�,����ȥ��ԭ����Ŀ��
                  nCode:= 13;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                  //Break;//20080504 �������ʱ,һ���
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeFairy Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//�ٻ�����
function TMagicManager.MagMakeFireFairy(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  I: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
  Slave, Slave1: TBaseObject;
  nCode: Byte;
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nCode:= 0;
    try
      if not PlayObject.sub_4DD704 then begin
        nCode:= 1;
        sMonName := g_Config.sFireFairy;
        nMakeLevel := UserMagic.btLevel;
        nExpLevel := UserMagic.btLevel;
        nCount := g_Config.nFireFairyCount;
        dwRoyaltySec := 20 * 24 * 60 * 60;
        nCode:= 2;
        Slave1:= PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec);
        if Slave1 <> nil then begin
          Slave1.n294 := UserMagic.nTranPoint;//ɱ������
          Result := True;
        end else begin //���г����Ļ���,�ɵ��������
          nCode:= 8;
          if (PlayObject.m_SlaveList.Count > 0) and g_Config.boSlaveMoveMaster then begin
            for I := 0 to PlayObject.m_SlaveList.Count -1 do begin
              nCode:= 9;
              Slave := TBaseObject(PlayObject.m_SlaveList.Items[I]);
              nCode:= 10;
              if (Slave <> nil) and (not Slave.m_boDeath) then begin
                nCode:= 11;
                if CompareText(Slave.m_sCharName, sMonName) = 0 then begin
                  nCode:= 12;
                  if Slave.m_TargetCret <> nil then Slave.m_TargetCret:= nil;
                  nCode:= 13;
                  Slave.SpaceMove( PlayObject.m_sMapName,PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0);
                  //Break;//�������ʱ,һ���
                end;
              end;
            end;//for
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeFireFairy Code:%d',[g_sExceptionVer, nCode]));
    end;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//�ٻ�����(���ʹ��)
function TMagicManager.MagMakeSlave_(PlayObject: TBaseObject; {�޸� TBaseObject} UserMagic: pTUserMagic; sMonName: string; nCount, nHumLevel, nMonLevel: Integer): Boolean;
var
  nMakeLevel, nExpLevel: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if PlayObject.m_boMakeSlave then Exit;
  PlayObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try
    nMakeLevel:= 0;//20080521
    nExpLevel:= 0;//20080521
    dwRoyaltySec:= 0;//20080522
    if not PlayObject.sub_4DD704 then begin
      nMakeLevel := UserMagic.btLevel;
      nExpLevel := UserMagic.btLevel;
      nCount := g_Config.nBoneFammCount;
      dwRoyaltySec := 864000{10 * 24 * 60 * 60};
      if PlayObject.m_Abil.Level >= nHumLevel then begin
        nExpLevel := nMonLevel;
      end;
    end;
    if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then Result := True;
  finally
    PlayObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//������
function TMagicManager.MagMakeSelf(BaseObject, TargeTBaseObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  sMonName: string;
  nCount: Integer;
  dwRoyaltySec: LongWord;
  boboAllowReCallMob: Boolean;
  BaseObject01: TBaseObject;
begin
  Result := False;
  if BaseObject.m_boMakeSlave then Exit;
  BaseObject.m_boMakeSlave:= True;//�Ƿ������ٻ�����
  try  
    if (GetTickCount - BaseObject.m_dwLatest46Tick) > (g_Config.nCopyHumanTick * 1000) then begin //�����ٻ���� 20080204
      BaseObject.m_dwLatest46Tick:=GetTickCount;
      boboAllowReCallMob := False;
      BaseObject01 := nil;
      if not BaseObject.sub_4DD704 then begin
        if g_Config.boAddMasterName then begin
          sMonName := BaseObject.m_sCharName + g_Config.sCopyHumName;
        end else begin
          sMonName := g_Config.sCopyHumName;
        end;
        nCount := g_Config.nAllowCopyHumanCount;
        if BaseObject.m_btRaceServer <> RC_HEROOBJECT then begin//Ӣ�۷������ܵȼ�����ʹ��ʱ�� 20081217
          dwRoyaltySec := g_Config.nMakeSelfTick ;//20080404 ����ʹ��ʱ����Ե���
        end else begin
          case UserMagic.btLevel of//20090817 Ӣ�۷�����������ֵ��
            0: dwRoyaltySec := g_Config.nHeroMakeSelfTick;
            1: dwRoyaltySec := g_Config.nHeroMakeSelfTick1;
            2: dwRoyaltySec := g_Config.nHeroMakeSelfTick2;
            3: dwRoyaltySec := g_Config.nHeroMakeSelfTick3;
          end;
        end;
        if g_Config.boAllowReCallMobOtherHum then begin                          {�ٻ�����Ľ�ɫ��Ӣ�� 20080204}
          if (TargeTBaseObject <> nil) and (not TargeTBaseObject.m_boDeath) and (BaseObject.m_btRaceServer <> RC_HEROOBJECT) then begin
            if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
              BaseObject01 := TargeTBaseObject;
              boboAllowReCallMob := True;
            end;
          end else begin
            BaseObject01 := BaseObject;
            boboAllowReCallMob := True;
          end;
          if g_Config.boNeedLevelHighTarget and (TargeTBaseObject <> nil) then begin
            if (BaseObject.m_Abil.Level < TargeTBaseObject.m_Abil.Level) then boboAllowReCallMob := False;
          end;
        end else begin
          BaseObject01 := BaseObject;
          boboAllowReCallMob := True;
        end;
        if boboAllowReCallMob then begin
          if TPlayObject(BaseObject).MakeSelf(TPlayObject(BaseObject01), sMonName, nCount, dwRoyaltySec) <> nil then Result := True;
        end;
      end;
    end;
  finally
    BaseObject.m_boMakeSlave:= False;//�Ƿ������ٻ�����
  end;
end;
//ʨ�Ӻ�
function TMagicManager.MagGroupMb(PlayObject: TBaseObject; {�޸� TBaseObject}
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nTime: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    //nTime := 5 * UserMagic.btLevel + 1;
    nTime := 1 * UserMagic.btLevel + 3;//20080330 0-3�� 1-4�� 2-5�� 3-6��
    PlayObject.m_PEnvir.GetMapBaseObjects(PlayObject.m_nCurrX, PlayObject.m_nCurrY, UserMagic.btLevel + 2, BaseObjectList);
    if BaseObjectList.Count > 0 then begin//20080629
      for I := 0 to BaseObjectList.Count - 1 do begin
        BaseObject := TBaseObject(BaseObjectList.Items[I]);
        if BaseObject <> nil then begin//20090413 ����                                                                                                            \
          if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
          if ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer = RC_HEROOBJECT)) and (not g_Config.boGroupMbAttackPlayObject) then Continue;//Ӣ��,������Ч 20080410
          if (BaseObject.m_btRaceServer = RC_PLAYMOSTER) and (not g_Config.boGroupMbAttackPlayMon) then Continue;//������Ч 20090413
          if (BaseObject.m_Master <> nil) and (BaseObject.m_Master = PlayObject) and  (not g_Config.boGroupMbAttackPlayObject) then Continue;//20080410 ��������������
          if (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) and (BaseObject.m_Master <> nil) and (not g_Config.boGroupMbAttackSlave) then Continue;
          if PlayObject.IsProperTarget(BaseObject) then begin
            if (not BaseObject.m_boUnParalysis) {$IF M2Version <> 2}and (not BaseObject.m_boCanUerSkill102){$IFEND} and (Random(BaseObject.m_btAntiPoison) = 0) and (Random(100) >= BaseObject.m_nUnParalysisRate) then begin//20100513 �������
              if (BaseObject.m_Abil.Level < PlayObject.m_Abil.Level) or (Random(PlayObject.m_Abil.Level - BaseObject.m_Abil.Level) = 0) then begin
                BaseObject.MakePosion(POISON_STONE, nTime, 0);
                //BaseObject.m_boFastParalysis := True;//������ԣ��ܹ��������������ʧ 20080329
              end;
            end;
          end;
          if (PlayObject.m_btRaceServer = RC_PLAYMOSTER) or (PlayObject.m_btRaceServer = RC_HEROOBJECT) then Result := True
          else if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
        end;
      end;
    end;
  finally
    BaseObjectList.Free;
  end;
end;

//�������� 20080625
function TMagicManager.MagMakeHPUp(PlayObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
  function GetSpellPoint(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wSpell + UserMagic.MagicInfo.btDefSpell;
  end;
var
  nSpellPoint, n14: Integer;
begin
  Result := False;
  nSpellPoint := GetSpellPoint(UserMagic);
  if nSpellPoint > 0 then begin
    if UserMagic.btLevel > 0 then begin
      if (PlayObject.m_Abil.WineDrinkValue >= Round(PlayObject.m_Abil.MaxAlcohol * g_Config.nMinDrinkValue68 / 100)) then begin//20090108 div��/
        if (GetTickCount - PlayObject.m_dwStatusArrTimeOutTick[4] > g_Config.nHPUpTick * 1000) and (PlayObject.m_wStatusArrValue[4] = 0) then begin //ʱ����
          if PlayObject.m_WAbil.MP < nSpellPoint then begin
            PlayObject.SysMsg('MPֵ����!!!', c_Red, t_Hint);
            Exit;
          end;
          PlayObject.DamageSpell(nSpellPoint);//��MPֵ 20080727
          PlayObject.HealthSpellChanged();//20080727
          n14:= {UserMagic.btLevel}300 + g_Config.nHPUpUseTime;
          PlayObject.m_dwStatusArrTimeOutTick[4] := GetTickCount + n14 * 1000;//ʹ��ʱ��
          PlayObject.m_wStatusArrValue[4] := UserMagic.btLevel;//����ֵ
          PlayObject.RecalcAbilitys();
          PlayObject.CompareSuitItem(False);//��װ������װ���Ա� 20080808
          if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin//20090501 �޸�
            PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
          end else
          if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin//20090501 �޸�
            THeroObject(PlayObject).SendMsg(PlayObject, RM_HEROABILITY, 0, 0, 0, 0, '');
          end;
          PlayObject.SysMsg('����ֵ˲������, ����' + IntToStr(n14) + '��', c_Green, t_Hint);
          PlayObject.SysMsg('��ľ��������Ѿ��ڼ���״̬', c_Green, t_Hint);
          Result := True;
        end else PlayObject.SysMsg(g_sOpenShieldOKMsg, c_Red, t_Hint);
      end else PlayObject.SysMsg('��ƶȲ�����'+inttostr(g_Config.nMinDrinkValue68)+'%ʱ,����ʹ�ô˼��� ', c_Red, t_Hint);
    end else PlayObject.SysMsg('�ȼ����1������,����ʹ�ô˼���', c_Red, t_Hint);
  end;
end;

{$IF M2Version = 1}
//˫����(��)
function TMagicManager.MagMakeSkillFire_77(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then //20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[0].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[0].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[0].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[0].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) '+ g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609


          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 150);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_77',[g_sExceptionVer]));
  end;
end;

//�����{��}
function TMagicManager.MagMakeSkillFire_80(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[1].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[1].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[1].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[1].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 150);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_80',[g_sExceptionVer]));
  end;
end;

//���ױ�{��}
function TMagicManager.MagMakeSkillFire_83(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[2].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[2].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[2].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[2].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');////������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 150);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_83',[g_sExceptionVer]));
  end;
end;

//����ѩ��{��}
function TMagicManager.MagMakeSkillFire_86(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; mStormsHit:Byte): Boolean;
var
  nPower, I, nTimer: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    try
      PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, g_Config.nBatterSkillFireRange_86, BaseObjectList);
      if BaseObjectList.Count > 0 then begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        case PlayObject.m_btRaceServer of//���㱬����
          RC_PLAYOBJECT: begin
            if TPlayObject(PlayObject).m_wHumanPulseArr[3].boOpenPulse then begin
              if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                Randomize(); //�������
                if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[3].nStormsHit + mStormsHit) then begin//20090726 �޸�
                  nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                  PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч 20090628
                  PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                end;
              end;
            end;
            nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
          end;
          RC_HEROOBJECT: begin
            if THeroObject(PlayObject).m_wHumanPulseArr[3].boOpenPulse then begin
              if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                Randomize(); //�������
                if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[3].nStormsHit + mStormsHit) then begin
                  nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                  PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч
                  THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                end;
              end;
            end;
            nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
          end;
        end;

        nTimer:= (Random(10) + UserMagic.btLevel) * 2 + 1;
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin
            if PlayObject.IsProperTarget(TargeTBaseObject) or (TargeTBaseObject.m_btRaceServer = 55) then begin //�Ƿ����ʵ���Ŀ��
              if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
                if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                  TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
                TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '', 600);
                if g_Config.nBatterSkillPoinson_86 > 0 then 
                  TargeTBaseObject.MagDownHealth(0, nTimer{ʱ��}, g_Config.nBatterSkillPoinson_86{����});//������Ŀ���,Ŀ�������Ѫ
                if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
              end;
            end;
          end;
        end;//for
        if (nPower > 0) and Result then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              nPower:= 0;
              nPower := Random(PlayObject.m_nVampirePoint);
              if nPower > 0 then PlayObject.DamageHealth(-nPower);
            end;
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_86',[g_sExceptionVer]));
    end;
  finally
    BaseObjectList.Free;
  end;
end;

//��Х��{��}
function TMagicManager.MagMakeSkillFire_78(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower, nSC: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if (PlayObject.m_wStatusArrValue[2] > 0) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//��������״ֱ̬����ʧ 20110115
      PlayObject.m_wStatusArrValue[2]:= 0;
      PlayObject.m_dwStatusArrTimeOutTick[2]:= GetTickCount();
      PlayObject.RecalcAbilitys();
      PlayObject.CompareSuitItem(False);
      PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    end;
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          if PlayObject.m_wStatusArrValue[2] > 0 then begin //ȥ���޼��������ӵĵ���
            nSC := MakeLong(LoWord(PlayObject.m_WAbil.SC), HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2]);
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(nSC), SmallInt(HiWord(nSC) - LoWord(nSC)) + 1);
          end else begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
          end;
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[0].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[0].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[0].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[0].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 80);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_78',[g_sExceptionVer]));
  end;
end;

//������{��}
function TMagicManager.MagMakeSkillFire_81(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower, nSC: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if (PlayObject.m_wStatusArrValue[2] > 0) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//��������״ֱ̬����ʧ 20110115
      PlayObject.m_wStatusArrValue[2]:= 0;
      PlayObject.m_dwStatusArrTimeOutTick[2]:= GetTickCount();
      PlayObject.RecalcAbilitys();
      PlayObject.CompareSuitItem(False);
      PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    end;
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          if PlayObject.m_wStatusArrValue[2] > 0 then begin//ȥ���޼��������ӵĵ���
            nSC := MakeLong(LoWord(PlayObject.m_WAbil.SC), HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2]);
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(nSC), SmallInt(HiWord(nSC) - LoWord(nSC)) + 1);
          end else begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
          end;
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[1].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[1].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[1].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[1].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609
          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 80);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_81',[g_sExceptionVer]));
  end;
end;

//������{��}
function TMagicManager.MagMakeSkillFire_84(PlayObject: TBaseObject; UserMagic: pTUserMagic;
  nTargetX, nTargetY: Integer;var TargeTBaseObject: TBaseObject; mStormsHit:Byte): Boolean;
var
  nPower, nSC: Integer;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  try
    if (PlayObject.m_wStatusArrValue[2] > 0) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//��������״ֱ̬����ʧ 20110115
      PlayObject.m_wStatusArrValue[2]:= 0;
      PlayObject.m_dwStatusArrTimeOutTick[2]:= GetTickCount();
      PlayObject.RecalcAbilitys();
      PlayObject.CompareSuitItem(False);
      PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
    end;
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin //�Ƿ����ʵ���Ŀ��
      if (10 >= Random(TargeTBaseObject.m_nAntiMagic + 10)) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= g_Config.nMagicAttackPassRage) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= g_Config.nMagicAttackPassRage) then begin
          if PlayObject.m_wStatusArrValue[2] > 0 then begin//ȥ���޼��������ӵĵ���
            nSC := MakeLong(LoWord(PlayObject.m_WAbil.SC), HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2]);
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(nSC), SmallInt(HiWord(nSC) - LoWord(nSC)) + 1);
          end else begin
            nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
          end;
          case PlayObject.m_btRaceServer of//���㱬����
            RC_PLAYOBJECT: begin
              if TPlayObject(PlayObject).m_wHumanPulseArr[2].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[2].nStormsHit + mStormsHit) then begin//20090726 �޸�
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч 20090628
                    PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
            RC_HEROOBJECT: begin
              if THeroObject(PlayObject).m_wHumanPulseArr[2].boOpenPulse then begin
                if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                  Randomize(); //�������
                  if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[2].nStormsHit + mStormsHit) then begin
                    nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                    PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч
                    THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                  end;
                end;
              end;
              nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
            end;
          end;
          if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
            TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

          TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                      _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 80);
          if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
          if (nPower > 0) and Result then begin//����װ����Ѫ
            if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
              if Random(100) <= PlayObject.m_nVampireRate then begin
                nPower:= 0;
                nPower := Random(PlayObject.m_nVampirePoint);
                if nPower > 0 then PlayObject.DamageHealth(-nPower);
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_84',[g_sExceptionVer]));
  end;
end;

//�򽣹���{��}
function TMagicManager.MagMakeSkillFire_87(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; mStormsHit:Byte): Boolean;
var
  nPower, I, nTimer,nSC: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  function GetPower(nPower: Integer): Integer;
  begin
    if UserMagic.MagicInfo.btDefMaxPower > UserMagic.MagicInfo.btDefPower then//20090807
      Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower))
    else Result := Round(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + UserMagic.MagicInfo.btDefPower;
  end;
begin
  Result := False;
  BaseObjectList := TList.Create;
  try
    try
      if (PlayObject.m_wStatusArrValue[2] > 0) and (PlayObject.m_btRaceServer = RC_PLAYOBJECT) then begin//��������״ֱ̬����ʧ 20110115
        PlayObject.m_wStatusArrValue[2]:= 0;
        PlayObject.m_dwStatusArrTimeOutTick[2]:= GetTickCount();
        PlayObject.RecalcAbilitys();
        PlayObject.CompareSuitItem(False);
        PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
      end;
      PlayObject.m_PEnvir.GetMapBaseObjects(nTargetX, nTargetY, g_Config.nBatterSkillFireRange_87, BaseObjectList);
      if BaseObjectList.Count > 0 then begin
        if PlayObject.m_wStatusArrValue[2] > 0 then begin//ȥ���޼��������ӵĵ���
          nSC := MakeLong(LoWord(PlayObject.m_WAbil.SC), HiWord(PlayObject.m_WAbil.SC) - PlayObject.m_wStatusArrValue[2]);
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(nSC), SmallInt(HiWord(nSC) - LoWord(nSC)) + 1);
        end else begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
        end;
        case PlayObject.m_btRaceServer of//���㱬����
          RC_PLAYOBJECT: begin
            if TPlayObject(PlayObject).m_wHumanPulseArr[3].boOpenPulse then begin
              if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                Randomize(); //�������
                if Random(100) <= (TPlayObject(PlayObject).m_wHumanPulseArr[3].nStormsHit + mStormsHit) then begin//20090726 �޸�
                  nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                  PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч 20090628
                  PlayObject.SysMsg(Format_ToStr(g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                end;
              end;
            end;
            nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
          end;
          RC_HEROOBJECT: begin
            if THeroObject(PlayObject).m_wHumanPulseArr[3].boOpenPulse then begin
              if (UserMagic.btLevel > 0) and (UserMagic.btLevel < 6) then begin
                Randomize(); //�������
                if Random(100) <= (THeroObject(PlayObject).m_wHumanPulseArr[3].nStormsHit + mStormsHit) then begin
                  nPower:= nPower + Round(nPower * (g_Config.nStormsHitRate[UserMagic.btLevel] / 100));
                  PlayObject.SendRefMsg(RM_10205, 14, 0{X}, 0{Y}, 0, '');//������Ч
                  THeroObject(PlayObject).SysMsg(Format_ToStr('(Ӣ��) ' + g_sUseBatterStorms, [UserMagic.MagicInfo.sMagicName]), c_Green, t_Hint);//������ʾ
                end;
              end;
            end;
            nPower:= nPower + PlayObject.m_wStatusArrValue[15];//�����˺�����
          end;
        end;

        if g_Config.nPoisonLength_87 = 0 then
          nTimer:= (Random(10) + UserMagic.btLevel) * 2 + 1//�ж�ʱ��
        else nTimer:= g_Config.nPoisonLength_87;
        for I := 0 to BaseObjectList.Count - 1 do begin
          TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
          if TargeTBaseObject <> nil then begin
            if (TargeTBaseObject.m_btRaceServer < RC_NPC) or (TargeTBaseObject.m_btRaceServer > RC_PEACENPC) then begin
              if (TargeTBaseObject.m_btRaceServer <> 110) and (TargeTBaseObject.m_btRaceServer <> 111) and
                 (TargeTBaseObject.m_btRaceServer <> 128) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
                if PlayObject.IsProperTarget(TargeTBaseObject) or (TargeTBaseObject.m_btRaceServer = 55) then begin //�Ƿ����ʵ���Ŀ��
                  if 10 >= Random(TargeTBaseObject.m_nAntiMagic + 10) then begin
                    if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                      TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '',
                                                  _MAX(abs(PlayObject.m_nCurrX - TargeTBaseObject.m_nCurrX), abs(PlayObject.m_nCurrY - TargeTBaseObject.m_nCurrY)) * 50 + 80);
                    TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_SKILLDECHEALTH, nTimer{ʱ��}, Integer(PlayObject), g_Config.nBatterSkillPoinson_87{����}, '', 1000);//������Ŀ���,Ŀ�������Ѫ
                    if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
                  end;
                end;
              end;
            end;    
          end;
        end;//for
        if (nPower > 0) and Result then begin//����װ����Ѫ
          if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
            if Random(100) <= PlayObject.m_nVampireRate then begin
              nPower:= 0;
              nPower := Random(PlayObject.m_nVampirePoint);
              if nPower > 0 then PlayObject.DamageHealth(-nPower);
            end;
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.MagMakeSkillFire_87',[g_sExceptionVer]));
    end;
  finally
    BaseObjectList.Free;
  end;
end;
{$IFEND}
//����ٵ�(Զ��ģʽ)
function TMagicManager.Attack_69(PlayObject: TBaseObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer): Boolean;
var
  I: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nDamage, nSecPwr: Integer;
begin
  Result := False;
  PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
  BaseObjectList := TList.Create;
  try
    try
      PlayObject.m_PEnvir.GetMapBaseObjects(PlayObject.m_nCurrX, PlayObject.m_nCurrY, 8, BaseObjectList);
      if BaseObjectList.Count > 0 then begin
        with PlayObject do begin
          case PlayObject.m_btJob of
            0: nSecPwr := GetAttackPower(MPow(UserMagic) + LoWord(m_WAbil.DC), SmallInt(HiWord(m_WAbil.DC) - LoWord(m_WAbil.DC)));
            1: nSecPwr := GetAttackPower(MPow(UserMagic) + LoWord(m_WAbil.MC), SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC))+ 1);
            2: nSecPwr := GetAttackPower(MPow(UserMagic) + LoWord(m_WAbil.SC), SmallInt(HiWord(m_WAbil.SC) - LoWord(m_WAbil.SC))+ 1);
          end;
        end;
        if nSecPwr > 0 then begin
          for I := 0 to BaseObjectList.Count - 1 do begin
            TargeTBaseObject := TBaseObject(BaseObjectList.Items[I]);
            if TargeTBaseObject <> nil then begin
              if TargeTBaseObject.m_boDeath or (TargeTBaseObject.m_boGhost) then Continue;
              if PlayObject.IsProperTarget(TargeTBaseObject) and (TargeTBaseObject.m_btRaceServer <> 79) then begin
                nDamage:= 0;
                nDamage := TargeTBaseObject.GetHitStruckDamage(PlayObject, nSecPwr);
                if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then
                  TPlayObject(TargeTBaseObject).CmdUserCmd('@MagTagFunc'+inttostr(UserMagic.MagicInfo.wMagicId));//���＼�ܴ��� 20080609

                if nDamage > 0 then begin

                  TargeTBaseObject.StruckDamage(nDamage);//�ܹ���,������װ���ĳ־�
                  TargeTBaseObject.SendDelayMsg(TBaseObject(RM_STRUCK), RM_10101, nDamage,
                                                TargeTBaseObject.m_WAbil.HP, TargeTBaseObject.m_WAbil.MaxHP, Integer(PlayObject), '', 500);
                  if (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and
                     (TargeTBaseObject.m_btRaceServer <> RC_HEROOBJECT) then begin
                    TargeTBaseObject.SendMsg(TargeTBaseObject, RM_STRUCK, nDamage, TargeTBaseObject.m_WAbil.HP,
                                             TargeTBaseObject.m_WAbil.MaxHP, Integer(PlayObject), '');
                  end;
                  if PlayObject.m_btRaceServer <> RC_HEROOBJECT then PlayObject.SetTargetCreat(TargeTBaseObject);
                end;
                Result := True;
              end;
            end;
          end;
        end;
      end;
      PlayObject.SendRefMsg(RM_MAGICFIRE, UserMagic.btLevelEx,MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
                              MakeLong(PlayObject.m_nCurrX, PlayObject.m_nCurrY),Integer(TargeTBaseObject),'');
     {$IF M2Version = 1}
      if (nSecPwr > 0) and Result then begin//����װ����Ѫ
        if (PlayObject.m_nVampirePoint > 0) and ((PlayObject.m_btRaceServer = RC_PLAYOBJECT) or (PlayObject.m_btRaceServer = RC_HEROOBJECT)) then begin
          if Random(100) <= PlayObject.m_nVampireRate then begin
            nSecPwr:= 0;
            nSecPwr := Random(PlayObject.m_nVampirePoint);
            if nSecPwr > 0 then PlayObject.DamageHealth(-nSecPwr);
          end;
        end;
      end;
      {$IFEND}
      if (UserMagic.btLevel < 3) and (Result) then begin
        if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= PlayObject.m_Abil.Level then begin
          PlayObject.TrainSkill(UserMagic, Random(3) + 1);///���Ӽ��ܵ�����ֵ
          if not PlayObject.CheckMagicLevelup(UserMagic) then begin
            if PlayObject.m_btRaceServer = RC_PLAYOBJECT then begin
              PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
            end else
              if PlayObject.m_btRaceServer = RC_HEROOBJECT then begin
              THeroObject(PlayObject).SendDelayMsg(PlayObject, RM_HEROMAGIC_LVEXP, UserMagic.MagicInfo.wMagicId, 0, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
            end;
          end;
        end;
      end;
    except
      MainOutMessage(format('{%s} TMagicManager.Attack_69',[g_sExceptionVer]));
    end;
  finally
    BaseObjectList.Free;
  end;
end;
end.

