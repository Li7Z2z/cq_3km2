unit PlayScn;
//��Ϸ������
interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  AbstractCanvas, AbstractTextures, AsphyreTextureFonts, AsphyreTypes, AsphyreFactory,
  IntroScn, Grobal2, HUtil32,
  Actor, HerbActor, AxeMon, AxeMon2, SoundUtil, ClEvent, AspWIL,
  StdCtrls, clFunc, Magiceff, extctrls, MShare, Share, AspDWinCtl;

const
  //LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410; //��Ʒ��˸Ч���Ŀ�ʼ֡ By TasNat at: 2012-03-17 16:48:20
  AAX = 16;
  SOFFX = 0;
  SOFFY = 0;
  DrawTileMapUsesBuf = 0;

type


  TPlayScene = class(TScene)
  private
  {$IF DrawTileMapUsesBuf = 1}
    m_MapSurface: TAsphyreRenderTargetTexture;
  {$Ifend}
     {m_ObjSurface    :TDirectDrawSurface; //0x0C }

    m_dwMoveTime: LongWord;
    m_nMoveStepCount: Integer;
    m_dwAniTime: LongWord;

    m_nDefXX: Integer;
    m_nDefYY: Integer;
    m_MainSoundTimer: TTimer;
    m_MsgList: TList;
    m_nDrawTileMapX, m_nDrawTileMapY: Integer;
     //���嶶��
{$IF M2Version <> 2} //1.76
    m_boScreenShake: Boolean;
    m_dwShakeTime: LongWord;
    m_dwShakeYTime: LongWord;
    m_nShakeY: integer;
    m_btShakeNum: Byte;
    
      //������ʱ��Ϊ��������  �ǰ�֡��
    m_dwMySelfEffTimeTick: LongWord;
    m_btMySelfEffImgFrame: Byte;
    m_btMySelfEffType: Byte; //�������� 1-СȦ 2-��Ȧ 3-��Ȧ 4-��ͷ
    m_btMySelfEffDir: Byte; //����
    m_boShowMySelfEff: Boolean; //�Ƿ���ʾ����
    m_nMySelfNextFrameTime: Integer; //��һ֡ʱ��
    m_dwMySelfAllTime: LongWord;
{$IFEND}
     //procedure DrawTileMap(DX, DY : Integer; MSurface: TAsphyreCanvas);
    procedure DrawTileMap(Sender: TObject);
{$IF M2Version <> 2} //1.76
    procedure ScreenShake;
    procedure DrawMySelfEff(Surface: TAsphyreCanvas; dx, dy: integer);
{$IFEND}
{$IF M2Version = 2} //1.76
    { procedure LoadFog; // 20080816ע����ʾ�ڰ�
     procedure ClearLightMap; // 20080816ע����ʾ�ڰ�
     procedure AddLight (x, y, shiftx, shifty, light: integer; nocheck: Boolean);// 20080816ע����ʾ�ڰ�
     procedure UpdateBright (x, y, light: integer); // 20080816ע����ʾ�ڰ�
     function  CheckOverLight (x, y, light: integer): Boolean;// 20080816ע����ʾ�ڰ�
     procedure ApplyLightMap;//20080816ע����ʾ�ڰ�
     procedure DrawLightEffect (lx, ly, bright: integer);   //20080816ע����ʾ�ڰ�       }
{$IFEND}
    procedure EdChatKeyPress(Sender: TObject; var Key: Char);
    procedure EdChatMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SoundOnTimer(Sender: TObject);
    function CrashManEx(mx, my: integer): Boolean;
    procedure ClearDropItem();
  public
    m_nAniCount: Integer;
    MemoLog: TMemo;
    EdAccountt: TEdit; //2004/05/17
    EdChrNamet: TEdit; //2004/05/17

    m_ActorList: TList;
     //m_GroundEffectList :TList;  20080721ע��  û�õ�
    m_EffectList: TList;
    m_FlyList: TList;
     //m_dwBlinkTime      :LongWord;   20080323
     //m_boViewBlink      :Boolean;

    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
      //procedure DrawMiniMap (surface: TDirectDrawSurface); 20080323
    function Run: Boolean;
    {$IF DrawTileMapUsesBuf = 1}
    procedure DrawTileMapBuf;
    {$IFend}
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
    function ButchAnimal(x, y: integer): TActor;

    function FindActor(id: integer): TActor; overload;
    function FindActor(sName: string): TActor; overload;
    function FindActorXY(x, y: integer): TActor;
    function IsValidActor(actor: TActor): Boolean;
    function NewActor(chrid: integer; cx, cy, cdir: word; {cfeature, } cfeature: TFeatures; cstate: integer; cMonShowName: Byte): TActor;
    procedure ActorDied(actor: TObject);
    procedure SetActorDrawLevel(actor: TObject; level: integer);
    procedure ClearActors;
    function DeleteActor(id: integer): TActor;
    procedure DelActor(actor: TObject);
    procedure SendMsg(ident, chrid, x, y, cdir, feature, state: integer; cMonShowName: Byte; NewFeature: TFeatures; str: string);


    procedure NewMagic(aowner: TActor;
      magid, magnumb, cx, cy, tx, ty, targetcode: integer;
      mtype: TMagicType;
      Recusion: Boolean;
      anitime: integer;
      btEffectLevelEx: Byte;
      var bofly: Boolean);
      //procedure DelMagic (magid: integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer; mtype: TMagicType): TMagicEff;
    procedure ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
    procedure CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
    function GetCharacter(x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
    function GetAttackFocusCharacter(x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
    function IsSelectMyself(x, y: integer): Boolean;
    function GetDropItems(x, y: integer; var inames: string): PTDropItem;
      //function  GetXYDropItems (nX,nY:Integer):pTDropItem;
    procedure GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
    function CanRun(sx, sy, ex, ey: integer): Boolean;
    function CanWalk(mx, my: integer): Boolean;
    function CanWalkEx(mx, my: integer): Boolean;
    function CrashMan(mx, my: integer): Boolean;
    function NewCanWalkEx(mx, my: Integer): Boolean;
      //function  CanFly (mx, my: integer): Boolean;
      //procedure RefreshScene;
    procedure CleanObjects;
{$IF M2Version <> 2} //1.76
    procedure OpenScreenShake;
    procedure ShowMySelfEff(EffType: Byte; Dir: Byte);
{$IFEND}
  end;

implementation

uses
  ClMain, FState, uMyDxUnit, Monpj;


constructor TPlayScene.Create;
begin
  inherited Create(stPlayGame);
   {m_MapSurface := nil;
   m_ObjSurface := nil;  }
  m_MsgList := TList.Create; //��Ϣ�б�
  m_ActorList := TList.Create; //��ɫ�б�
   //m_GroundEffectList := TList.Create; 20080721ע��  û�õ�
  m_EffectList := TList.Create;
  m_FlyList := TList.Create;
  m_dwBlinkTime := GetTickCount;
  m_boViewBlink := FALSE;
{$IF M2Version <> 2} //1.76
  m_boScreenShake := False;
  m_dwShakeYTime := GetTickCount;
  m_nShakeY := 0;
  m_btShakeNum := 0;
  m_btMySelfEffImgFrame := 0;
  m_btMySelfEffType := 0;
  m_boShowMySelfEff := False;
{$IFEND}

   //������Ϣ�����
  {EdChat := TEdit.Create(FrmMain.Owner);
  with EdChat do begin
    Parent := FrmMain;
    BorderStyle := bsNone;
    OnKeyPress := EdChatKeyPress;
    OnMouseDown := EdChatMouseDown;
    Visible := FALSE;
    MaxLength := 70;
    Ctl3D := FALSE;
    Left := 208;
    Top := g_D3DConfig.wScreenHeight - 19;
    Height := 12;
    Width := (g_D3DConfig.wScreenWidth div 2 - 207) * 2 ;
    Color := clSilver;
    AutoSize := False;
  end;  }
  MemoLog := TMemo.Create(FrmMain.Owner);
  with MemoLog do begin
    Parent := FrmMain;
    BorderStyle := bsNone;
    Visible := False;
      //Visible := True;
    Ctl3D := False;
    Left := 0;
    Top := 250;
    Width := 300;
    Height := 150;
  end;
   //2004/05/17
  EdAccountt := TEdit.Create(FrmMain.Owner);
  with EdAccountt do begin
    Parent := FrmMain;
    BorderStyle := bsSingle;
    Visible := False;
    MaxLength := 70;
    Ctl3D := True;
    Left := (g_D3DConfig.wScreenWidth - 194) div 2;
    Top := g_D3DConfig.wScreenHeight - 200;
    Height := 12;
    Width := 194;
  end;
   //2004/05/17
   //2004/05/17
  EdChrNamet := TEdit.Create(FrmMain.Owner);
  with EdChrNamet do begin
    Parent := FrmMain;
    BorderStyle := bsSingle;
    Visible := False;
    MaxLength := 70;
    Ctl3D := True;
    Left := (g_D3DConfig.wScreenWidth - 194) div 2;
    Top := g_D3DConfig.wScreenHeight - 176;
    Height := 12;
    Width := 194;
  end;
   //2004/05/17

  m_dwMoveTime := GetTickCount;
  m_dwAniTime := GetTickCount;
  m_nAniCount := 0;
  m_nMoveStepCount := 0;
  m_MainSoundTimer := TTimer.Create(FrmMain.Owner);
  with m_MainSoundTimer do begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := FALSE;
  end;
  // nx := g_D3DConfig.wScreenWidth div 2 - 210;
  // ny := g_D3DConfig.wScreenHeight div 2 - 150;
end;

destructor TPlayScene.Destroy;
var
  I: Integer;
begin
  if m_MsgList.Count > 0 then begin //20080629
    for I := 0 to m_MsgList.Count - 1 do
      if pTChrMsg(m_MsgList.Items[I]) <> nil then Dispose(pTChrMsg(m_MsgList.Items[I]));
  end;
  FreeAndNil(m_MsgList);

  if m_ActorList.Count > 0 then begin //�ͷ����� 20080718
    for I := 0 to m_ActorList.Count - 1 do
      if TActor(m_ActorList[I]) <> nil then TActor(m_ActorList[I]).Free;
  end;
  FreeAndNil(m_ActorList);
  {  20080721ע��  û�õ�
  if m_GroundEffectList.Count > 0 then begin   //�ͷ����� 20080718
    for I := 0 to m_GroundEffectList.Count - 1 do
      if TMagicEff(m_GroundEffectList.Items[I]) <> nil then TMagicEff(m_GroundEffectList.Items[I]).Free;
  end;
  FreeAndNil(m_GroundEffectList);   }
  if m_EffectList.Count > 0 then begin //�ͷ����� 20080718
    for I := 0 to m_EffectList.Count - 1 do
      if TMagicEff(m_EffectList[I]) <> nil then TMagicEff(m_EffectList[I]).Free;
  end;
  FreeAndNil(m_EffectList);
  if m_FlyList.Count > 0 then begin //�ͷ����� 20080718
    for I := 0 to m_FlyList.Count - 1 do
      if TMagicEff(m_FlyList.Items[I]) <> nil then TMagicEff(m_FlyList.Items[I]).Free;
  end;
  FreeAndNil(m_FlyList);
  inherited Destroy;
end;
//��Ϸ�������ı������֣����ȣ�43�룩

procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  PlaySound(s_main_theme);
  m_MainSoundTimer.Interval := 46 * 1000;
end;
//������Ϣ����

procedure TPlayScene.EdChatKeyPress(Sender: TObject; var Key: Char);
begin

end;
//��ʼ������

procedure TPlayScene.Initialize;
{$IF M2Version = 2} //1.76
{var
  I: Integer;}
{$IFEND}
var
  W, H: Integer;
begin
   //MAPSURFACEWIDTH = SCREENWIDTH;
   //MAPSURFACEHEIGHT = SCREENHEIGHT- 155;
  W := g_GameDevice.Size.x;
  W := W + UNITX * 4 + 30;
  H := g_GameDevice.Size.Y;
  H := H + UNITY * 4;
  {$IF DrawTileMapUsesBuf = 1}
  m_MapSurface := Factory.CreateRenderTargetTexture;
  m_MapSurface.Format := apf_X8R8G8B8;
  m_MapSurface.SetSize(W, H);
  {$Ifend}
  //g_RenderTargets.Add(1, W, H, apf_X8R8G8B8);

   //frmMain.DXDraw.BeginScene; //20080718
   //��ͼ
  { m_MapSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
   m_MapSurface.SystemMemory := TRUE;
   m_MapSurface.SetSize (MAPSURFACEWIDTH+UNITX*4+30, MAPSURFACEHEIGHT+UNITY*4);
   //��Ʒ
   m_ObjSurface := TDirectDrawSurface.Create (frmMain.DxDraw.DDraw);
   m_ObjSurface.SystemMemory := TRUE;
   m_ObjSurface.SetSize (MAPSURFACEWIDTH-SOFFX*2, MAPSURFACEHEIGHT);      }
{$IF M2Version = 2} //1.76
   {//�� 20080816ע����ʾ�ڰ�
   m_nFogWidth := MAPSURFACEWIDTH - SOFFX * 2;
   m_nFogHeight := MAPSURFACEHEIGHT;
   m_PFogScreen := @m_FogScreen;
   ZeroMemory (m_PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);

   g_boViewFog := FALSE; // 20080816ע����ʾ�ڰ�
   for i:=0 to MAXLIGHT do
      m_Lights[i].PFog := nil;
   LoadFog;      }
{$IFEND}
end;

procedure TPlayScene.Finalize;
{$IF M2Version = 2} //1.76
{var
  I: Integer;    }
{$IFEND}
var
  I: Integer;
begin
  //����ͼƬ��Դ������ By TasNat at: 2012-03-12 22:36:11
  try
    if m_ActorList <> nil then     
    for I := 0 to m_ActorList.Count - 1 do
      TActor(m_ActorList[I]).ClearSurfaceRef;
  except
  end;
  //m_MapSurface.Free;
   {if m_MapSurface <> nil then begin
     m_MapSurface.Free;
     m_MapSurface := nil;
   end;
   if m_ObjSurface <> nil then begin
     m_ObjSurface.Free;
     m_MapSurface := nil;
   end; }

{$IF M2Version = 2} //1.76
   //20080718�ͷ��ڴ�
      //20080816ע����ʾ�ڰ�
   { for I:=0 to MAXLIGHT do begin
       if m_Lights[i].PFog <> nil then
          FreeMem(m_Lights[i].PFog);
    end;  }
{$IFEND}

end;
//������ʼ

procedure TPlayScene.OpenScene;
begin
  g_WMainImages.ClearCache; //�ͷų���
  FrmDlg.ViewBottomBox(TRUE);
  SetImeMode(FrmMain.Handle, LocalLanguage);
   //MainSoundTimer.Interval := 1000;
   //MainSoundTimer.Enabled := TRUE;
end;
//�رճ���

procedure TPlayScene.CloseScene;
begin
   //MainSoundTimer.Enabled := FALSE;
  SilenceSound;
  FrmDlg.ViewBottomBox(FALSE);
end;

procedure TPlayScene.OpeningScene;
begin
end;
{//ˢ�³���(��Ϸ��ɫ��
procedure TPlayScene.RefreshScene;
var
   i: integer;
begin
   Map.m_OldClientRect.Left := -1;
   if m_ActorList.Count > 0 then //20080629
   for i:=0 to m_ActorList.Count-1 do
      TActor (m_ActorList[i]).LoadSurface;
end; }

procedure TPlayScene.CleanObjects;
var
  I: integer;
begin
  if m_ActorList.Count > 0 then begin //20080629
    if g_HeroSelf = nil then begin
       //ɾ�����зǵ�ǰ��ҽ�ɫ
      for i := m_ActorList.Count - 1 downto 0 do begin
        if TActor(m_ActorList[i]) <> g_MySelf then begin
          TActor(m_ActorList[i]).Free;
          m_ActorList.Delete(i);
        end;
      end;
    end else begin
        //��� Ӣ�ۻ���ͼ  ����û�˵�����    2007.11.9
      for i := m_ActorList.Count - 1 downto 0 do begin
        if (TActor(m_ActorList[i]) <> g_MySelf) and (TActor(m_ActorList[i]) <> g_HeroSelf) then begin
          TActor(m_ActorList[i]).Free;
          m_ActorList.Delete(i);
        end;
      end;
    end;
  end;
  m_MsgList.Clear;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
   //���ħ��Ч��
   { 20080721ע��  û�õ�
   if m_GroundEffectList.Count > 0 then begin//20080629
     for i:=0 to m_GroundEffectList.Count-1 do
        TMagicEff (m_GroundEffectList[i]).Free;
     m_GroundEffectList.Clear;
   end; }
  if m_EffectList.Count > 0 then begin //20080629
    for i := 0 to m_EffectList.Count - 1 do TMagicEff(m_EffectList[i]).Free;
    m_EffectList.Clear;
  end;
end;

{---------------------- Draw Map -----------------------}
//����ͼ
//procedure TPlayScene.DrawTileMap(DX, DY : Integer; MSurface: TAsphyreCanvas);

procedure TPlayScene.DrawTileMap(Sender: TObject);
{$IF DrawTileMapUsesBuf = 1}
var
  i, j, nY, nX, nImgNumber, nPaintX, nPaintY, nOffsetX, nOffsetY: integer;
  DSurface: TAsphyreLockableTexture;
  DesRect: TRect;
  ALOGICALMAPUNIT: Integer;
begin
  {with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then Exit;  }

  Map.m_OldClientRect := Map.m_ClientRect;
  ALOGICALMAPUNIT := LOGICALMAPUNIT * 3;

//��ͼ����
 //if not g_boDrawTileMap then Exit;
  DesRect := Map.m_ClientRect;
  Windows.OffsetRect(DesRect, -Map.m_nBlockLeft, -Map.m_nBlockTop);
  with DesRect do begin
    {Right := _Min(Right, ALOGICALMAPUNIT);
    Bottom := _Min(Bottom, ALOGICALMAPUNIT);

    Left := _Max(Left, 0);
    Top := _Max(Top, 0);    }
    Inc(Left, 2);

    Inc(Top, 3);

    //Inc(Right, 2);
    //Inc(Bottom, 1);
    nY := 0; //-32*2=-64
    for J := Top to Bottom do begin //�ӵ�ͼ�������²�
      nX := 0; //16+14-48=-18
      for i := Left to Right do begin //����ߵ��ұ�
        nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
        if nImgNumber > 0 then begin
          //if (i mod 2 = 0) and (j mod 2 = 0) then
          begin
            Dsurface := GetTiles(Map.m_MArr[i, j].btNew, nImgNumber - 1);
            if Dsurface <> nil then begin
              GameCanvas.Draw(nX, nY, Dsurface, False);
            end;
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
    nY := 0;
    for J := Top to Bottom do begin //�ӵ�ͼ�������²�
      nX := 0; //16+14-48=-18
      for i := Left to Right do begin //����ߵ��ұ�
        nImgNumber := Map.m_MArr[i, j].wMidImg;
        if nImgNumber > 0 then begin
          nImgNumber := nImgNumber - 1;
          Dsurface := GetSmTiles(Map.m_MArr[i, j].btNew1, nImgNumber);
          if Dsurface <> nil then begin
            GameCanvas.Draw(nX, nY, Dsurface, False);
          end;
        end;

        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;
end;
{$ELSE}
var
  i,j, nY,nX,nImgNumber,nPaintX, nPaintY, nOffsetX, nOffsetY:integer;
  DSurface: TAsphyreLockableTexture;
  SrcRect: TRect;
  PaintRect: TRect;
begin
  {with Map do
    if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then Exit;  }

  Map.m_OldClientRect := Map.m_ClientRect;
  //m_MapSurface.Fill(0);

//��ͼ����
 //if not g_boDrawTileMap then Exit;
  with Map.m_ClientRect do begin
    nY := -UNITY * 2;  //-32*2=-64
    for J:=(Top - Map.m_nBlockTop - 1) to (Bottom - Map.m_nBlockTop + 1) do begin  //�ӵ�ͼ�������²�
      nX := AAX + 14 -UNITX; //16+14-48=-18
      for i:=(Left - Map.m_nBlockLeft -2) to (Right - Map.m_nBlockLeft + 1) do begin //����ߵ��ұ�
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT *3) then begin
          nImgNumber := (Map.m_MArr[i, j].wBkImg and $7FFF);
          if nImgNumber > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              Dsurface := GetTiles(Map.m_MArr[i, j].btNew,  nImgNumber - 1);
              if Dsurface <> nil then begin
                nOffsetX := nX - m_nDrawTileMapX;
                nOffsetY := nY - m_nDrawTileMapY;
                nPaintX := _MAX(nOffsetX, 0);
                nPaintY := _MAX(nOffsetY, 0);
                PaintRect := Dsurface.ClientRect;
                if nOffsetX < 0 then PaintRect.Left := -nOffsetX;
                if nOffsetY < 0 then PaintRect.Top := -nOffsetY;

                if (PaintRect.Left < PaintRect.Right) and (PaintRect.Top < PaintRect.Bottom) then

                  GameCanvas.Draw(nPaintX, nPaintY, PaintRect, Dsurface, False);
              end;
             end;
           end;
         end;
         Inc (nX, UNITX);
      end;
       Inc (nY, UNITY);
    end;
  end;


   //��ʾ���ϵĲ�   ������밲ȫ���Ĳ�
   with Map.m_ClientRect do begin
      nY := -UNITY * 2;
      for j:=(Top - Map.m_nBlockTop-1) to (Bottom - Map.m_nBlockTop+1) do begin
         nX := AAX + 14 -UNITX;
         for i:=(Left - Map.m_nBlockLeft-2) to (Right - Map.m_nBlockLeft+1) do begin
            if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
               nImgNumber := Map.m_MArr[i, j].wMidImg;
               if nImgNumber > 0 then begin
                  nImgNumber := nImgNumber - 1;
                  Dsurface := GetSmTiles(Map.m_MArr[i, j].btNew1, nImgNumber);
                  if Dsurface <> nil then begin
                    PaintRect := Dsurface.ClientRect;
                    nOffsetX := nX - m_nDrawTileMapX;
                    nOffsetY := nY - m_nDrawTileMapY;
                    nPaintX := _MAX(nOffsetX, 0);
                    nPaintY := _MAX(nOffsetY, 0);
                    PaintRect := Dsurface.ClientRect;
                    if nOffsetX < 0 then PaintRect.Left := -nOffsetX;
                    if nOffsetY < 0 then PaintRect.Top := -nOffsetY;

                    if (PaintRect.Left < PaintRect.Right) and (PaintRect.Top < PaintRect.Bottom) then

                      GameCanvas.Draw(nPaintX, nPaintY, PaintRect, Dsurface, False);
                  end;
               end;
            end;
            Inc (nX, UNITX);
         end;
         Inc (nY, UNITY);
      end;
   end;

end;
{$Ifend}

procedure TPlayScene.ClearDropItem;
var
  I: Integer;
  DropItem: pTDropItem;
  nErrorCode: Byte;
begin
  nErrorCode := 0;
  try
    if g_DropedItemList.Count > 0 then begin //20080629
      for I := g_DropedItemList.Count - 1 downto 0 do begin
        nErrorCode := 1;
        DropItem := g_DropedItemList.Items[I];
        nErrorCode := 2;
        if DropItem = nil then begin
          nErrorCode := 3;
          g_DropedItemList.Delete(I);
          Continue;
        end;
        nErrorCode := 4;
        if g_MySelf <> nil then begin
          nErrorCode := 7;
          if (abs(DropItem.x - g_MySelf.m_nCurrX) > 20) and (abs(DropItem.y - g_MySelf.m_nCurrY) > 20) then begin
{$IF DEBUG = 1}
            DScreen.AddChatBoardString(format('DropItem:%s X:%d Y:%d', [DropItem.Name, DropItem.X, DropItem.Y]), clWhite, clRed);
{$IFEND}
            nErrorCode := 5;
            Dispose(DropItem);
            nErrorCode := 6;
            g_DropedItemList.Delete(I);
          end;
        end;
      end;
    end;
  except
    DebugOutStr(Format('TPlayScene.ClearDropItem Code:%d', [nErrorCode]));
  end;
end;


function TPlayScene.Run: Boolean;
var
  movetick: Boolean;
  ErrorCode: Integer;
  I: Integer;
  actor: TActor;
  meff: TMagicEff;
  evn: TClEvent;
begin
  Result := g_MySelf <> nil;
  if Result then begin

    g_boDoFastFadeOut := FALSE;
    movetick := FALSE;
    if GetTickCount - m_dwMoveTime >= 90 {94} then begin
      m_dwMoveTime := GetTickCount; //�ƶ���ʼʱ��
      movetick := TRUE; //�����ƶ�
      Inc(m_nMoveStepCount);
      if m_nMoveStepCount > 1 then m_nMoveStepCount := 0;
    end;
    if GetTickCount - m_dwAniTime >= 50 then begin
      m_dwAniTime := GetTickCount;
      Inc(m_nAniCount);
      if m_nAniCount > 100000 then m_nAniCount := 0;
    end;
   //�����ɫһЩ��ض���
    ErrorCode := 0;
    try
      I := 0;
      while TRUE do begin
        if i >= m_ActorList.Count then break;
        ErrorCode := 1; //20090722 �������
        actor := m_ActorList[i];
        ErrorCode := 2;
        if actor <> nil then begin //20090725��
          if movetick then actor.m_boLockEndFrame := FALSE; //�����ƶ�
          if not actor.m_boLockEndFrame then begin //û����������
            ErrorCode := 3;
            actor.ProcMsg; //�����ɫ����Ϣ.
            ErrorCode := 4;
            if MoveTick then
              if actor.Move(m_nMoveStepCount) then begin //��ɫ�ƶ�
                Inc(I);
                continue;
              end;
            ErrorCode := 5;
            if actor <> nil then begin
              actor.Run; //
              ErrorCode := 6;
              if actor <> g_MySelf then actor.ProcHurryMsg;
            end;
          end;
          ErrorCode := 7;
          if actor = g_MySelf then actor.ProcHurryMsg;
          ErrorCode := 8;
          if (actor.m_nWaitForRecogId <> 0) and (actor.IsIdle) {��ǰ�Ƿ�û�п�ִ�еĶ���} then begin
            ErrorCode := 9;
            DelChangeFace(actor.m_nWaitForRecogId);
            ErrorCode := 10;
            NewActor(actor.m_nWaitForRecogId, actor.m_nCurrX, actor.m_nCurrY, actor.m_btDir, actor.m_nWaitForFeature, actor.m_nWaitForStatus, 0);
            actor.m_nWaitForRecogId := 0;
            actor.m_boDelActor := TRUE;
          end;
          ErrorCode := 11;
          if actor.m_boDelActor then begin
            ErrorCode := 12;
            g_FreeActorList.Add(actor);
            ErrorCode := 13;
            m_ActorList.Delete(i);
            ErrorCode := 14;
            if g_TargetCret = actor then g_TargetCret := nil;
            if g_FocusCret = actor then g_FocusCret := nil;
            if g_MagicTarget = actor then g_MagicTarget := nil;
          end else Inc(i);
        end;
      end;
    except
      DebugOutStr('101 Code:' + inttostr(ErrorCode));
    end;
    g_dwRunTime := GetTickCount;

   //��Ч�����˶����Եļ���
    try
      i := 0;
      ErrorCode := 0;
      while TRUE do begin
        if I >= m_EffectList.Count then break;
        ErrorCode := 1;
        meff := m_EffectList[i];
        if meff.m_boActive then begin
          ErrorCode := 2;
          if not meff.Run then begin //����ȿ��
            meff.Free;
            m_EffectList.Delete(i);
            continue;
          end;
        end;
        Inc(i);
      end;
     //����ħ���ͷ�
      i := 0;
      ErrorCode := 3;
      while TRUE do begin
        if i >= m_FlyList.Count then break;
        ErrorCode := 6;
        meff := m_FlyList[i];
        ErrorCode := 7;
        if meff.m_boActive then begin
          ErrorCode := 8;
          if not meff.Run then begin //����,ȭ��� ���ư���
            ErrorCode := 9;
            meff.Free;
            ErrorCode := 10;
            m_FlyList.Delete(i);
            continue;
          end;
        end;
        Inc(i);
      end;
      ErrorCode := 4;
      EventMan.Execute;
      ErrorCode := 5;
    except
      DebugOutStr('102 Code:' + IntToStr(ErrorCode));
    end;

    try
      ErrorCode := 0;
     //������Ʒ����
      ClearDropItem();
      ErrorCode := 1;
     //�ͷ��¼��ĵط�
      if EventMan.EventList.Count > 0 then begin //20080629
        for i := 0 to EventMan.EventList.Count - 1 do begin
          ErrorCode := 2;
          evn := TClEvent(EventMan.EventList[i]);
          ErrorCode := 5;
          if evn <> nil then begin
            ErrorCode := 8;
            if (Abs(evn.m_nX - g_MySelf.m_nCurrX) > 20) or (Abs(evn.m_nY - g_MySelf.m_nCurrY) > 20) then begin
              ErrorCode := 6;
              evn.Free;
              ErrorCode := 7;
              EventMan.EventList.Delete(i);
              break; //�ѹ��� �Ѱ���
            end;
          end;
        end;
      end;
      ErrorCode := 4;
    except
      DebugOutStr('103 Code:' + IntToStr(ErrorCode));
    end;
   //���µ�ͼ�ɼ���Χ
    try
      ErrorCode := 0;
      if g_MySelf <> nil then begin
        with g_ScreenMapRect do begin
          if g_D3DConfig.wScreenWidth = 800 then begin
            Top := 9;
            Bottom := 8;
            Left := 9;
            Right := 9;
          end else if g_D3DConfig.wScreenWidth = 1024 then begin //1024X768ģʽ
            Left := 12;
            Right := 12;
            Top := 12;
            Bottom := 15;
          end;
        end;

        with Map.m_ClientRect do begin //800x600ģʽ ��ͼ�ķ�Χ�����Ϊ���ģ����Ҹ�9
          Left := g_MySelf.m_nRx - g_ScreenMapRect.Left;
          Top := g_MySelf.m_nRy - g_ScreenMapRect.Top;
          Right := g_MySelf.m_nRx + g_ScreenMapRect.Right;
          Bottom := g_MySelf.m_nRy + g_ScreenMapRect.Bottom;
        end;
        ErrorCode := 1;
     //װ�ص�ͼ����
        Result := Map.UpdateMapPos(g_MySelf.m_nRx, g_MySelf.m_nRy);
        with Map do
          Result := Result or (m_ClientRect.Left <> m_OldClientRect.Left) or (m_ClientRect.Top <> m_OldClientRect.Top);

        ErrorCode := 2;
{$IF M2Version <> 2}
        ScreenShake;
{$IFEND}
      end;
    except
      DebugOutStr('104 Code:' + IntToStr(ErrorCode));
    end;
  end;
end;
{$IF DrawTileMapUsesBuf = 1}
procedure TPlayScene.DrawTileMapBuf; //����ͼ
begin        
  m_nDrawTileMapX := 0;
  m_nDrawTileMapY := 0;
  g_GameDevice.RenderTo(DrawTileMap, 0, True, m_MapSurface);
end;
{$IFend}

//����Ϸ��ʽ����

procedure TPlayScene.PlayScene(MSurface: TAsphyreCanvas);
var
  i, j, k, n, m, mmm, ix, iy, line, defx, defy, wunit, fridx, ani, anitick, ax, ay, idx, drawingbottomline: Integer;
  DSurface, d: TAsphyreLockableTexture;
  blend, movetick: Boolean;
  DropItem: PTDropItem;
  evn: TClEvent;
  actor: TActor;
  meff: TMagicEff;
  msgstr: string;
  ErrorCode: Integer;
  OldSize: Byte;
  OldFontStyle: TFontStyles;
begin
  DrawingBottomLine := 0; //jacky
  if (g_MySelf = nil) then begin
    msgstr := '�����˳���Ϸ�����Ժ�...';
    AspTextureFont.BoldTextOut((g_D3DConfig.wScreenWidth - AspTextureFont.TextWidth(msgstr)) div 2, 200,
      msgstr, clWhite, clBlack);
    Exit;
  end;
   //Run();
  drawingbottomline := g_D3DConfig.wScreenHeight;
{$IF DrawTileMapUsesBuf = 1}
  m_nDrawTileMapX := -g_MySelf.m_nShiftX;
  m_nDrawTileMapY := -g_MySelf.m_nShiftY;
  GameCanvas.Draw(m_MapSurface, m_nDrawTileMapX, m_nDrawTileMapY);
{$ELSE}
   m_nDrawTileMapX :=UNITX*3 + g_MySelf.m_nShiftX;
   m_nDrawTileMapY :=UNITY*2 + g_MySelf.m_nShiftY;
   DrawTileMap(nil);
{$ifend}
  defx := -UNITX * 2 - g_MySelf.m_nShiftX + AAX + 14;
  defy := -UNITY * 2 - g_MySelf.m_nShiftY;
  m_nDefXX := defx;
  m_nDefYY := defy;
   //�������ϵ����壬�緿�ݵ�
  try
    ErrorCode := 0;
    m := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop {+ LONGHEIGHT_IMAGE} {20081226�Ż�}) do begin
      if j < 0 then begin Inc(m, UNITY); continue; end;
      n := defx - UNITX * 2;
      //*** 48*32 ��һ������СͼƬ�Ĵ�С
      ErrorCode := 1;
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2 {20081226�Ż�}) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            ani := Map.m_MArr[i, j].btAniFrame;
            wunit := Map.m_MArr[i, j].btArea;
            if (ani and $80) > 0 then begin
              blend := TRUE;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //����
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then //������ ǥ�õ� �͸�
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //���� ��
            end;
            fridx := fridx - 1;
            dsurface := GetObjs(wunit, fridx);
               //end;
            if DSurface <> nil then begin
              if (DSurface.Width = 48) and (DSurface.Height = 32) then begin
                mmm := m + UNITY - DSurface.Height;
                if (n + DSurface.Width > 0) and (n <= g_D3DConfig.wScreenWidth) and (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                  MSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                end else begin
                  if mmm < drawingbottomline then begin //���ʿ��ϰ� �׸��� ���� ����
                    MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, TRUE)
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
   { 20080721ע��  û�õ�
   //����������Ч��
   if m_GroundEffectList.Count > 0 then //20080629
   for k:=0 to m_GroundEffectList.Count-1 do begin
      meff := TMagicEff(m_GroundEffectList[k]);
      meff.DrawEff (m_ObjSurface);
      if g_boViewFog then begin
         AddLight (meff.Rx, meff.Ry, 0, 0, meff.light, FALSE);
      end;
   end; }

  except
    DebugOutStr('105 Code:' + IntToStr(ErrorCode));
  end;

  try
    ErrorCode := 0;
    m := defy - UNITY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + 20 {+ LONGHEIGHT_IMAGE} {20080821�Ż�}) do begin
      if j < 0 then begin Inc(m, UNITY); continue; end;
      n := defx - UNITX * 2;
        //*** ��������Ʈ �׸���
      ErrorCode := 1;
      for i := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2 {20080821�Ż�}) do begin
        ErrorCode := 19;
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then begin
          ErrorCode := 20;
          fridx := (Map.m_MArr[i, j].wFrImg) and $7FFF;
          if fridx > 0 then begin
            blend := FALSE;
            ErrorCode := 21;
            wunit := Map.m_MArr[i, j].btArea;
                 //���ϸ��̼�
            ErrorCode := 22;
            ani := Map.m_MArr[i, j].btAniFrame;
            if (ani and $80) > 0 then begin
              blend := TRUE;
              ani := ani and $7F;
            end;
            if ani > 0 then begin
              ErrorCode := 23;
              anitick := Map.m_MArr[i, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            ErrorCode := 24;
            if (Map.m_MArr[i, j].btDoorOffset and $80) > 0 then begin //����
              ErrorCode := 25;
              if (Map.m_MArr[i, j].btDoorIndex and $7F) > 0 then //������ ǥ�õ� �͸�
                fridx := fridx + (Map.m_MArr[i, j].btDoorOffset and $7F); //���� ��
            end;
            fridx := fridx - 1;
                 // ��ü �׸�

            if not blend then begin
              ErrorCode := 26;
                    {if Map.GetBitCountIs16 then begin //2010-12-19���Ӷ�ȡ��ʵ�ͼ�ز�
                       dsurface := GetObjs16(wunit, fridx);
                    end else begin   }
              dsurface := GetObjs(wunit, fridx);
                    //end;
              if DSurface <> nil then begin
                if (DSurface.Width <> 48) or (DSurface.Height <> 32) then begin
                  mmm := m + UNITY - DSurface.Height;
                  if (n + DSurface.Width > 0) and (n <= g_D3DConfig.wScreenWidth) and (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                    ErrorCode := 27;
                    MSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, TRUE)
                  end else begin
                    if mmm < drawingbottomline then begin //���ʿ��ϰ� �׸��� ���� ����
                      ErrorCode := 28;
                      MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, TRUE)
                    end;
                  end;
                end;
              end;
            end else begin
              ErrorCode := 2;
                    //---------------------��ʾ�ƹ�ĵط�
                    {if Map.GetBitCountIs16 then begin //2010-12-19���Ӷ�ȡ��ʵ�ͼ�ز�
                      DSurface := GetObjsEx16 (wunit, fridx, ax, ay);
                    end else begin }
              DSurface := GetObjsEx(wunit, fridx, ax, ay);
                    //end;
              if DSurface <> nil then begin
                mmm := m + ay - 68;
                if (n > 0) and (mmm + DSurface.Height > 0) and (n + Dsurface.Width < g_D3DConfig.wScreenWidth) and (mmm < drawingbottomline) then begin
                  MSurface.DrawBlend(n + ax - 2, mmm, DSurface);
                end else begin
                  if mmm < drawingbottomline then begin
                    MSurface.DrawBlend(n + ax - 2, mmm, DSurface);
                  end;
                end;
              end;
            end;
          end;

        end;
        Inc(n, UNITX);
      end;
      ErrorCode := 3;
      if (j <= (Map.m_ClientRect.Bottom - Map.m_nBlockTop)) and (not g_boServerChanging) then begin
        if EventMan.EventList.Count > 0 then begin //20080629
          for k := 0 to EventMan.EventList.Count - 1 do begin
            evn := TClEvent(EventMan.EventList[k]);
            if j = (evn.m_nY - Map.m_nBlockTop) then begin
              evn.DrawEvent(MSurface, (evn.m_nX - Map.m_ClientRect.Left) * UNITX + defx, m);
            end;
          end;
        end;


           //if g_boDrawDropItem then begin
        ErrorCode := 4;
           //��ʾ������Ʒ����
        if g_DropedItemList.Count > 0 then //20080629
          for k := 0 to g_DropedItemList.Count - 1 do begin
            ErrorCode := 5;
            DropItem := PTDropItem(g_DropedItemList[k]);
            ErrorCode := 6;
            if DropItem <> nil then begin
              if j = (DropItem.y - Map.m_nBlockTop) then begin
                d := frmMain.GeDnItemsImg(DropItem.Looks);
                if d <> nil then begin
                  ix := (DropItem.x - Map.m_ClientRect.Left) * UNITX + defx + SOFFX; // + actor.ShiftX;
                  iy := m; // + actor.ShiftY;
                  ErrorCode := 7;
                  if DropItem = g_FocusItem then begin
                    MSurface.Draw(ix + HALFX - (d.Width div 2),
                      iy + HALFY - (d.Height div 2),
                      d.ClientRect,
                      d, deSrcBright);
                  end else begin
                    MSurface.Draw(ix + HALFX - (d.Width div 2),
                      iy + HALFY - (d.Height div 2),
                      d.ClientRect,
                      d, TRUE);
                  end;

                end;
              end;
            end;
          end;
           //end;
        ErrorCode := 8;
           //*** ��ʾ����˵����Ϣ
        for k := 0 to m_ActorList.Count - 1 do begin
          ErrorCode := 9;
          actor := m_ActorList[k];
          ErrorCode := 10;
          if (j = actor.m_nRy - Map.m_nBlockTop - actor.m_nDownDrawLevel) then begin
            ErrorCode := 11;
            actor.m_nSayX := (actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx + actor.m_nShiftX + 24;
            if actor.m_boDeath then
              actor.m_nSayY := m + UNITY + actor.m_nShiftY + 16 - 60 + (actor.m_nDownDrawLevel * UNITY)
            else actor.m_nSayY := m + UNITY + actor.m_nShiftY + 16 - 95 + (actor.m_nDownDrawLevel * UNITY);
            ErrorCode := 12;
            if actor.m_boDeath and g_boHideHummanShiTi then Continue;
            {
            �� THumActor.DrawChr ���� ��ʡ ����VMT��CPU By TasNat at: 2012-03-17 16:46:38
            actor.DrawStall(MSurface, (actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              m + (actor.m_nDownDrawLevel * UNITY));
            }
            actor.DrawChr(MSurface, (actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              m + (actor.m_nDownDrawLevel * UNITY),
              FALSE, True);
          end;
        end;
        ErrorCode := 13;
           //������ħ���ط�
        if m_FlyList.Count > 0 then //20080629
          for k := 0 to m_FlyList.Count - 1 do begin
            ErrorCode := 14;
            meff := TMagicEff(m_FlyList[k]);
            ErrorCode := 15;
            if meff <> nil then begin
              ErrorCode := 16;
              if j = (meff.Ry - Map.m_nBlockTop) then begin
                ErrorCode := 17;
                meff.DrawEff(MSurface);
                ErrorCode := 18;
              end;
            end;
          end;
      end;
      Inc(m, UNITY);
    end;
  except
    DebugOutStr('106 Code:' + IntToStr(ErrorCode));
  end;
{$IF M2Version = 2} //1.76
   //�����Ч�������ߣ�
  { try
   if g_boViewFog then begin
      m := defy - UNITY*4;
      for j:=(Map.m_ClientRect.Top - Map.m_nBlockTop - 4) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do begin
         if j < 0 then begin Inc (m, UNITY); continue; end;
         n := defx-UNITX*5;
         //��� ���� �׸���
         for i:=(Map.m_ClientRect.Left - Map.m_nBlockLeft-5) to (Map.m_ClientRect.Right - Map.m_nBlockLeft+5) do begin
            if (i >= 0) and (i < LOGICALMAPUNIT*3) and (j >= 0) and (j < LOGICALMAPUNIT*3) then begin
               idx := Map.m_MArr[i, j].btLight;
               if idx > 0 then begin
                  AddLight (i+Map.m_nBlockLeft, j+Map.m_nBlockTop, 0, 0, idx, FALSE);
               end;
            end;
            Inc (n, UNITX);
         end;
         Inc (m, UNITY);
      end;

      //ĳ���� ���� �׸���
      if m_ActorList.Count > 0 then begin
         for k:=0 to m_ActorList.Count-1 do begin
            actor := m_ActorList[k];
            if actor <> nil then begin
              if (actor = g_MySelf) or (actor.Light > 0) then
                 AddLight (actor.m_nRx, actor.m_nRy, actor.m_nShiftX, actor.m_nShiftY, actor.Light, actor=g_MySelf);
            end;
         end;
      end else begin
         if g_MySelf <> nil then
            AddLight (g_MySelf.m_nRx, g_MySelf.m_nRy, g_MySelf.m_nShiftX, g_MySelf.m_nShiftY, g_MySelf.Light, TRUE);
      end;
   end;
   except
      DebugOutStr ('107');
   end;     }
{$IFEND}

  if not g_boServerChanging then begin
    try
      ErrorCode := 0;
      //**** ������״̬
      if g_MySelf.m_nState and $00800000 = 0 then
        g_MySelf.DrawChr(MSurface, (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, TRUE, FALSE);
      ErrorCode := 1;
      //**** ��ǰ���ָ��Ľ�ɫ
      if (g_FocusCret <> nil) then begin
        if (g_FocusCret.m_btRace = 50) then begin
          if g_FocusCret.m_wAppearance <> 54 then begin //ѩ��NPC
            if IsValidActor(g_FocusCret) and (g_FocusCret <> g_MySelf) then
              if (g_FocusCret.m_nState and $00800000 = 0) then //Jacky
                g_FocusCret.DrawChr(MSurface,
                  (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
                  (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, TRUE, FALSE);
          end;
        end else begin
          if IsValidActor(g_FocusCret) and (g_FocusCret <> g_MySelf) then
            if (g_FocusCret.m_nState and $00800000 = 0) then //Jacky
              g_FocusCret.DrawChr(MSurface,
                (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
                (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, TRUE, FALSE);
        end;
      end;
      ErrorCode := 2;
      //**** ��ħ����ʱ����������ʾ
      if (g_MagicTarget <> nil) then begin
        if IsValidActor(g_MagicTarget) and (g_MagicTarget <> g_MySelf) then
          if g_MagicTarget.m_nState and $00800000 = 0 then //������ �ƴϸ�
            g_MagicTarget.DrawChr(MSurface,
              (g_MagicTarget.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
              (g_MagicTarget.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, TRUE, FALSE);
      end;
      ErrorCode := 3;
    except
      DebugOutStr('108 Code:' + IntToStr(ErrorCode));
    end;
  end;

  try
    ErrorCode := 0;
   //**** ����ɫЧ��
    if m_ActorList.Count > 0 then begin //20080629
      ErrorCode := 4;
      for k := 0 to m_ActorList.Count - 1 do begin
        ErrorCode := 5;
        actor := m_ActorList[k];
        ErrorCode := 6;
        if actor <> nil then begin
          ErrorCode := 7;
          actor.DrawEff(MSurface,
            (actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
            (actor.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy);
        end;
      end;
    end;

{$IF M2Version <> 2}
    DrawMySelfEff(MSurface,
      (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx,
      (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy);
{$IFEND}

    ErrorCode := 1;
   //��ħ��Ч��
    if m_EffectList.Count > 0 then begin //20080629
      ErrorCode := 8;
      for k := 0 to m_EffectList.Count - 1 do begin
        ErrorCode := 9;
        meff := TMagicEff(m_EffectList[k]);
        ErrorCode := 10;
        if meff <> nil then begin
          ErrorCode := 11;
          meff.DrawEff(MSurface);
          ErrorCode := 12;
        end;
{$IF M2Version = 2} //1.76
        {if g_boViewFog then begin
          ErrorCode := 12;
           AddLight (meff.Rx, meff.Ry, 0, 0, meff.Light, FALSE);
        end;  }
{$IFEND}
      end;
    end;
    ErrorCode := 2;
{$IF M2Version = 2} //1.76
   {if g_boViewFog then begin
      if EventMan.EventList.Count > 0 then //20080629
      for k:=0 to EventMan.EventList.Count-1 do begin
         evn := TClEvent (EventMan.EventList[k]);
         if evn.m_nLight > 0 then
            AddLight (evn.m_nX, evn.m_nY, 0, 0, evn.m_nLight, FALSE);
      end;
   end;
   ErrorCode := 3;       }
{$IFEND}
  except
    DebugOutStr('109 Code:' + IntToStr(ErrorCode));
  end;

   //������Ʒ����
  try
    ErrorCode := 0;
    if g_DropedItemList.Count > 0 then //20080629
      for k := 0 to g_DropedItemList.Count - 1 do begin
        ErrorCode := 1;
        DropItem := PTDropItem(g_DropedItemList[k]);
        ErrorCode := 2;
        if DropItem <> nil then begin
          ErrorCode := 4;
          if GetTickCount - DropItem.FlashTime > 5000 then begin //��˸
            DropItem.FlashTime := GetTickCount;
            DropItem.BoFlash := TRUE;
            DropItem.FlashStepTime := GetTickCount;
            DropItem.FlashStep := 0;
          end;
          ErrorCode := 5;
          ix := (DropItem.x - Map.m_ClientRect.Left) * UNITX + defx + SOFFX;
          iy := (DropItem.y - Map.m_ClientRect.Top - 1) * UNITY + defy + SOFFY;
          ErrorCode := 6;
          if DropItem.BoFlash then begin
            if GetTickCount - DropItem.FlashStepTime >= 20 then begin
              DropItem.FlashStepTime := GetTickCount;
              Inc(DropItem.FlashStep);
            end;
            ErrorCode := 7;
            if (DropItem.FlashStep >= 0) and (DropItem.FlashStep < 10) then begin
              ErrorCode := 8;
              DSurface := g_WMainImages.GetCachedImage(FLASHBASE + DropItem.FlashStep, ax, ay);
              ErrorCode := 9;
              if DSurface <> nil then MSurface.DrawBlend(ix + ax, iy + ay, DSurface);
              ErrorCode := 10;
            end else DropItem.BoFlash := FALSE;
            ErrorCode := 11;
          end;
        end;
      end;
    ErrorCode := 3;
  except
    DebugOutStr('110 Code:' + IntToStr(ErrorCode));
  end;
  // try
  ErrorCode := 0;
 // g_boViewFog:=False;      //Jacky ����
{$IF M2Version = 2}
   (*if  g_boViewFog {and not g_boForceNotViewFog 20080816ע������} then begin
      ApplyLightMap;   //һ���о�
      DrawFog (m_ObjSurface, m_PFogScreen, m_nFogWidth);
      MSurface.Draw (SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
   end else begin    *)
{$IFEND}
  if g_MySelf.m_boDeath then begin //������������ʾ�ڰ׻���
         //DrawEffect (0, 0, m_ObjSurface, m_ObjSurface, g_DeathColorEffect{ceGrayScale});
    MSurface.FillRect(MSurface.ClientRect, clGray1, deInvMultiply);
  end;
      //MSurface.TextOut(365, 300, clRed, 'С�ˣ�Alt+X������');
      (*{$IF M2Version <> 2}
      MSurface.Draw (SOFFX, SOFFY+m_nShakeY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
      {$ELSE}
      MSurface.Draw (SOFFX, SOFFY, m_ObjSurface.ClientRect, m_ObjSurface, FALSE);
      {$IFEND}*)
  if g_MySelf.m_boDeath then begin //������������ʾ�ڰ׻���
    OldSize := FontManager.FontSize;
    FontManager.SetFont('����', 14);
    AspTextureFont.TextOut(365, 300, 'С��(Alt+X)����', clRed, [fsBold]);
    FontManager.SetFont('����', OldSize);
  end;
{$IF M2Version = 2}
   //end;
{$IFEND}
  ErrorCode := 1;
   {except
      DebugOutStr ('111 Code:'+IntToStr(ErrorCode));
   end;   }





   {if g_boViewMiniMap then begin
      DrawMiniMap (MSurface);
   end; }//20080323
end;

{------------------------------------------------------------------------------}
//ʵ����ָ��Ŀ�겥��ĳ��ħ��Ч��(20071029 )
//NewMagic(aowner, magid,magnumb,cx,cy,tx,ty,targetcode,mtype,Recusion,anitime,bofly)
//
//
//        �����Ժ�����
//
//
//
{------------------------------------------------------------------------------}
//cx, cy, tx, ty : ���� ��ǥ
// new copy by liuzhigang ��ħ��

procedure TPlayScene.NewMagic(aowner: TActor;
  magid, magnumb {Effect}, cx, cy, tx, ty, targetcode: integer;
  mtype: TMagicType; //EffectType
  Recusion: Boolean;
  anitime: integer;
  btEffectLevelEx: Byte;
  var boFly: Boolean);
var
  i, scx, scy, sctx, scty, effnum: integer;
  meff: TMagicEff;
  target: TActor;
  wimg: TAspWMImages;
begin
  try
    boFly := FALSE;
    if magid <> 111 then begin //
      if m_EffectList.Count > 0 then //20080629
        for i := 0 to m_EffectList.Count - 1 do
          if TMagicEff(m_EffectList[i]).ServerMagicId = magid then exit;
    end;

    ScreenXYfromMCXY(cx, cy, scx, scy);
    ScreenXYfromMCXY(tx, ty, sctx, scty);
    if aowner <> nil then begin
      if magnumb > 0 then GetEffectBase(magnumb - 1, 0, wimg, effnum, aowner.m_btDir, btEffectLevelEx) //magnumbΪEffect
      else effnum := -Magnumb;
    end;
    Target := FindActor(Targetcode); //Ŀ��
    meff := nil;
    case mtype of //EffectType
      mtReady, mtFly, mtFlyAxe: begin
          case magnumb of
            39: begin //������
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                meff.frame := 4;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            63: begin //�ɻ�����
                meff := TFireFixedEffect.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                meff.ExplosionFrame := 36;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            42: begin //������
                meff := TfenshenThunder.Create(10, scx, scy, sctx, scty, aowner);
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            82: begin //Ѫ��һ��(��)
                meff := {TMagicEff.} TMagicEffDir8.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime, Tactor(aowner).m_btDir);
            //meff.EffectBase := 2050{+Tactor(aowner).m_btDir*10};
            //meff.frame := 6;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 2150; //Ϊwis���idx
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 10; //���󲥷ŵ�����
            //meff.Dir16 := meff.Dir16 div 2;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            199: begin //������ͨ����
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 270;
            //meff.frame := 3;
                meff.ExplosionFrame := 6;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            200: begin //�����ػ�
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 450;
            //meff.frame := 6;
                meff.ExplosionFrame := 10;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            102: begin
                Effnum := 130;
                meff := TFireDragonEffect.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 200;
                meff.ExplosionFrame := 20;
                if wimg <> nil then meff.ImgLib := g_WDragonImages;
              end;
            60: meff := TPHHitEffect.Create(0, scx, scy, sctx, scty, aowner);
            103: begin //˫����
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.EffectBase := 2600;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 2770; //Ϊwis���idx
                meff.ExplosionFrame := 25; //���󲥷ŵ�����
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            106: begin //�����
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.EffectBase := 2410;
                meff.frame := 3;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 2580; //Ϊwis���idx
                meff.ExplosionFrame := 10; //���󲥷ŵ�����
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            107: begin //������
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.EffectBase := 2080;
                meff.frame := 3;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 2251 + meff.Dir16 * 10; //Ϊwis���idx
                meff.ExplosionFrame := 4; //���󲥷ŵ�����
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            109: begin //���ױ� 20090624
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.EffectBase := 4220;
                meff.frame := 4;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 4240; //Ϊwis���idx
                meff.ExplosionFrame := 7; //���󲥷ŵ�����
                meff.Dir16 := 0;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            113: begin //�򽣹���
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.EffectBase := 2810;
                meff.frame := 5;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.MagExplosionBase := 2980 + meff.Dir16 * 10; //Ϊwis���idx
                meff.ExplosionFrame := 8; //���󲥷ŵ�����
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            114: begin //��ɫС����
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            120: begin //��ɫ�����
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                if wimg <> nil then meff.ImgLib := wimg;
              end
          else begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.TargetActor := target;
            end;
          end;
          bofly := TRUE;
        end;
      mtExplosion:
        case magnumb of
          18: begin //�ջ�֮��
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1570;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
            end;
          19: begin //���л�λ 20080424
              meff := nil;
            end;
          21: begin //���ѻ���
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 330 + (btEffectLevelEx - 1) div 3 * 10;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1660;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
              end;
            end;
          121: begin //��ɫ���ѻ���
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 330 + (btEffectLevelEx - 1) div 3 * 10;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1655;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          26: begin //������ʾ
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3990;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 2;
            end;
          27: begin //Ⱥ��������
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1800;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
            end;
          30: begin //ʥ����
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3930;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 16;
              meff.Light := 3;
            end;
          31: begin //������
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 90 + (btEffectLevelEx - 1) div 3 * 20;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 18;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 3850;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
              end;
            end;
          34: begin //�����
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 140;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          122: begin //��ɫ�����
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1765;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          123: begin //��ɫ�ļ������
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1785;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 15;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          40: begin // ������
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 620;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          45: begin //��������
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 920;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          47: begin //쫷���
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1010;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          48: begin //��Ѫ��
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                case btEffectLevelEx of
                  1..3: meff.MagExplosionBase := 690;
                  4..6: meff.MagExplosionBase := 840;
                  7..9: meff.MagExplosionBase := 990;
                end;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1060;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          115: begin //��ɫ��Ѫ��
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                case btEffectLevelEx of
                  1..3: meff.MagExplosionBase := 690;
                  4..6: meff.MagExplosionBase := 840;
                  7..9: meff.MagExplosionBase := 990;
                end;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1075;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          49: begin //������
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1110;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          51: begin //���ǻ��� 20080510
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 530 + (btEffectLevelEx - 1) div 3 * 30;
                meff.TargetActor := target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 650;
                meff.TargetActor := target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          126: begin //��ɫ���ǻ���
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 530 + (btEffectLevelEx - 1) div 3 * 30;
                meff.TargetActor := target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1885;
                meff.TargetActor := target;
                meff.NextFrameTime := 46;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            end;
          130: begin //��˪ѩ��
              //111, 0,
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 380;
              meff.TargetActor := nil;
              meff.NextFrameTime := 46;
              meff.ExplosionFrame := 30;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          133: begin //����֮��
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 30;
              meff.TargetActor := nil;
              meff.NextFrameTime := 46;
              meff.ExplosionFrame := 21;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          134: begin //��˪Ⱥ��
              meff := TIceRainEffect.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 80;
              meff.TargetActor := nil;
              meff.NextFrameTime := 46;
              meff.ExplosionFrame := 17;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          135: begin //ŭ�ɻ���
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1040;
              meff.TargetActor := nil;
              meff.NextFrameTime := 46;
              meff.ExplosionFrame := 24;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          55: begin //����ٵ�
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1391;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 14;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          74: begin //4����Ѫ��
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                case btEffectLevelEx of
                  1..3: meff.MagExplosionBase := 690;
                  4..6: meff.MagExplosionBase := 840;
                  7..9: meff.MagExplosionBase := 990;
                end;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1150;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          116: begin //��ɫ�ļ���Ѫ��
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                case btEffectLevelEx of
                  1..3: meff.MagExplosionBase := 690;
                  4..6: meff.MagExplosionBase := 840;
                  7..9: meff.MagExplosionBase := 990;
                end;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1125;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 50;
                meff.ExplosionFrame := 20;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          77: begin //4��ʩ������
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 620 + (btEffectLevelEx - 1) div 3 * 10;
                meff.TargetActor := target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 70;
                meff.TargetActor := target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          78: begin //4��ʩ������
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 830 + (btEffectLevelEx - 1) div 3 * 10;
                meff.TargetActor := target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 110;
                meff.TargetActor := target;
                meff.NextFrameTime := 80;
                meff.ExplosionFrame := 8;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          80: begin //4�����ǻ���
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 530 + (btEffectLevelEx - 1) div 3 * 30;
                meff.TargetActor := target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 260;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 28;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          127: begin //��ɫ�ļ����ǻ���
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 530 + (btEffectLevelEx - 1) div 3 * 30;
                meff.TargetActor := target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 30;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end else begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.MagExplosionBase := 1945;
                meff.TargetActor := nil; //target;
                meff.NextFrameTime := 30;
                meff.ExplosionFrame := 28;
                meff.Light := 3;
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            end;
          83: begin //Ѫ��һ��(��)
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 2200 + aowner.m_btDir * 20;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 12;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          97: begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 860;
              meff.ExplosionFrame := 20;
              meff.TargetActor := aowner;
              meff.NextFrameTime := 80;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
          102: begin //�������� ����
              Effnum := 3730;
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3730;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 200;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
              if wimg <> nil then meff.ImgLib := g_WMonImagesArr[23];
            end;
          112: begin //����ѩ��
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3150 + Tactor(aowner).m_btDir * 10;
              meff.TargetActor := nil; //target;
              meff.NextFrameTime := 100;
              meff.ExplosionFrame := 8;
              if wimg <> nil then meff.ImgLib := wimg;
            end;
        else begin //Ĭ��
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
        end;
      mtFireWind:
        case magnumb of
          15: begin //�ٻ�����
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.start := 0;
                meff.frame := -1;
                meff.curframe := meff.start;
                meff.FixedEffect := TRUE;
                meff.Repetition := FALSE;
                meff.MagExplosionBase := 1040 + (btEffectLevelEx - 1) div 3 * 20;
                meff.TargetActor := nil;
                meff.ExplosionFrame := 15;
                if wimg <> nil then meff.ImgLib := wimg;
              end else meff := nil;
            end;
          76: begin //�ٻ�ʥ��
              if btEffectLevelEx in [1..9] then begin
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.start := 0;
                meff.frame := -1;
                meff.curframe := meff.start;
                meff.FixedEffect := TRUE;
                meff.Repetition := FALSE;
                meff.MagExplosionBase := 220 + (btEffectLevelEx - 1) div 3 * 10;
                meff.TargetActor := nil;
                meff.ExplosionFrame := 9;
                if wimg <> nil then meff.ImgLib := wimg;
              end else meff := nil;
            end;
          35: begin //�޼�����
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
              meff.MagExplosionBase := 165; //Ϊwil���idx
              meff.TargetActor := aowner; //nil;//��Ŀ��
              meff.NextFrameTime := 60; //ʱ��
              meff.ExplosionFrame := 10; //���󲥷ŵ�֡��
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          117: begin //��ɫ�޼�����
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
              meff.MagExplosionBase := 1180; //Ϊwil���idx
              meff.TargetActor := aowner; //nil;//��Ŀ��
              meff.NextFrameTime := 60; //ʱ��
              meff.ExplosionFrame := 10; //���󲥷ŵ�֡��
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          129: begin //�ķ�
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
              meff.MagExplosionBase := 110; //Ϊwil���idx
              meff.TargetActor := aowner; //nil;//��Ŀ��
              meff.NextFrameTime := 80; //ʱ��
              meff.ExplosionFrame := 40; //���󲥷ŵ�֡��
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
        else meff := nil;
        end;
      mtFireGun: //ȭ�����    //���һ���
        meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
      mtThunder: begin
          case magnumb of
            9: begin //�׵���
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(210 + (btEffectLevelEx - 1) div 3 * 20, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 7;
                  meff.ImgLib := g_WMagic7Images16;
                end else begin
                  meff := TThuderEffect.Create(10, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 6;
                  meff.ImgLib := g_WMagic2Images;
                end;
              end;
            80, 70 {Ⱥ���׵�}, 71, 72, 73, 74: begin
                meff := TThuderEffect.Create(10, sctx, scty, nil); //target);
                meff.ExplosionFrame := 6;
                meff.ImgLib := g_WMagic2Images;
              end;
            136: begin //��������
                meff := TGroupThuderEffect.Create(10, sctx, scty, nil); //target);
                meff.ExplosionFrame := 6;
                meff.ImgLib := g_WMagic2Images;
              end;
            75: begin //4���׵���
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(210 + (btEffectLevelEx - 1) div 3 * 20, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 7;
                  meff.ImgLib := g_WMagic7Images16;
                end else begin
                  meff := TThuderEffect.Create(20, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 6;
                  meff.ImgLib := g_WMagic7Images;
                end;
              end;
            61: begin //Ӣ�ۺϻ� ����ն 2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 495; //Ϊwil���idx
                meff.TargetActor := nil; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 19; //���󲥷ŵ�֡��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            62: begin //Ӣ�ۺϻ� ����һ�� 2007.10.31
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 390; //Ϊwil���idx
                meff.TargetActor := nil; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 25; //���󲥷ŵ�֡��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            64: begin //Ӣ�ۺϻ� ĩ������ 2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 230; //Ϊwil���idx
                meff.TargetActor := nil; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 27; //���󲥷ŵ�֡��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            65: begin //Ӣ�ۺϻ� �������� 2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 561; //Ϊwil���idx
                meff.TargetActor := nil; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 37; //���󲥷ŵ�֡��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
          end;
        end;
      mtRedThunder: begin
          meff := TRedThunderEffect.Create(230, sctx, scty, nil);
          meff.ExplosionFrame := 6;
        end;
      mtLava: begin
          case magnumb of
            91: meff := TLavaEffect.Create(470, sctx, scty, nil, 10); //�ҽ�
            92: meff := TLavaEffect.Create(350, sctx, scty, nil, 34); //�����ػ�����Ч��
          end;
        end;
      mtLightingThunder: begin //�����Ӱ ħ��
          if magnumb = 8 then begin
            if btEffectLevelEx in [1..9] then begin
              meff := TLightingThunder.Create(1100 + (btEffectLevelEx - 1) div 3 * 170, scx, scy, sctx, scty, target);
              meff.ImgLib := g_WMagic7Images16;
            end else meff := TLightingThunder.Create(970, scx, scy, sctx, scty, target);
          end else meff := TLightingThunder.Create(970, scx, scy, sctx, scty, target);
        end;
      mtExploBujauk: begin
          case magnumb of
            110: begin //������
                meff := TSYZBujaukEffect.Create(3400, scx, scy, sctx, scty, target);
            //meff.EffectBase := 3990;
                meff.MagExplosionBase := 3560;
            //meff.TargetActor := target; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 6; //���󲥷ŵ�֡��
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            100: begin //4������� 20080111
                if btEffectLevelEx in [1..9] then begin
                  meff := TExploBujaukEffect.Create(600 + (btEffectLevelEx - 1) div 3 * 340, scx, scy, sctx, scty, target, True);
                  meff.MagExplosionBase := 1620 + (btEffectLevelEx - 1) div 3 * 10;
                  meff.NextFrameTime := 80; //ʱ��
                  meff.ExplosionFrame := 6; //���󲥷ŵ�֡��
                  if wimg <> nil then meff.ImgLib := wimg;
                end else begin
                  meff := TExploBujaukEffect.Create(140, scx, scy, sctx, scty, target, True);
                  meff.MagExplosionBase := 300;
                  meff.NextFrameTime := 80; //ʱ��
                  meff.ExplosionFrame := 4; //���󲥷ŵ�֡��
                  if wimg <> nil then
                    meff.ImgLib := wimg;
                end;
              end;
          {132: begin //�����
            meff := TExploBujaukEffect.Create (1280, scx, scy, sctx, scty, target, True);
            meff.MagExplosionBase := 1640;
            meff.NextFrameTime := 80; //ʱ��
            meff.ExplosionFrame := 6; //���󲥷ŵ�֡��
            if wimg <> nil then meff.ImgLib:=wimg;
          end;}
            124: begin //��ɫ�ļ��������
                meff := TExploBujaukEffect.Create(140, scx, scy, sctx, scty, target, False);
                meff.MagExplosionBase := 300;
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 4; //���󲥷ŵ�֡��
                if g_WMagic6Images <> nil then
                  meff.ImgLib := g_WMagic6Images;
              end;
            104: begin //��Х��
                meff := THXJBujaukEffect.Create(3580, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 3740;
            //meff.TargetActor := target; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 10; //���󲥷ŵ�֡��
                if wimg <> nil then meff.ImgLib := wimg;
              end;
            99: begin
                meff := TJNExploBujaukEffect.Create(1510, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 1590;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                meff.ExplosionFrame := 8; //���󲥷ŵ�֡��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            198: begin
                meff := TJNExploBujaukEffect.Create(1590, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 1746;
                meff.TargetActor := target; //nil;//��Ŀ��
                meff.NextFrameTime := 80; //ʱ��
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            10, 132: begin //�����
                if btEffectLevelEx in [1..9] then begin
                  meff := TExploBujaukEffect.Create(600 + (btEffectLevelEx - 1) div 3 * 340, scx, scy, sctx, scty, target, True);
                  meff.MagExplosionBase := 1620 + (btEffectLevelEx - 1) div 3 * 10;
                  meff.NextFrameTime := 80; //ʱ��
                  meff.ExplosionFrame := 6; //���󲥷ŵ�֡��
                  if wimg <> nil then meff.ImgLib := wimg;
                end else begin
                  meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target, False);
                  meff.MagExplosionBase := 1360;
                  meff.NextFrameTime := 80; //ʱ��
                end;
              end;
            17: begin //����������
                meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target, False);
                meff.MagExplosionBase := 1540;
              end;
          end;
          bofly := TRUE;
        end;
      mtBujaukGroundEffect: begin
          case magnumb of
            11, 12: begin //�����  ��ʥս����
                if btEffectLevelEx in [1..9] then begin
                  meff := TBujaukGroundEffect.Create(600 + (btEffectLevelEx - 1) div 3 * 340, magnumb, scx, scy, sctx, scty, btEffectLevelEx, True);
                  meff.ExplosionFrame := 20; //���󲥷ŵ�֡��
                  if wimg <> nil then meff.ImgLib := wimg;
                end else begin
                  meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty, btEffectLevelEx, False);
                  meff.ExplosionFrame := 16;
                end;
              end;
            46: begin
                meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty, btEffectLevelEx, False);
                meff.ExplosionFrame := 24; //������
              end;
            118, 119: begin //��ɫ��ʥս����  ��ɫ�����
                if btEffectLevelEx in [1..9] then begin
                  meff := TBujaukGroundEffect.Create(600 + (btEffectLevelEx - 1) div 3 * 340, magnumb, scx, scy, sctx, scty, btEffectLevelEx, True);
                  meff.ExplosionFrame := 20; //���󲥷ŵ�֡��
                  if wimg <> nil then meff.ImgLib := wimg;
                end else begin
                  meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty, btEffectLevelEx, False);
                  meff.ExplosionFrame := 16;
                  if wimg <> nil then meff.ImgLib := wimg;
                end;
              end;
          end;
          bofly := TRUE;
        end;
      mtKyulKai: begin
          meff := nil; //TKyulKai.Create (1380, scx, scy, sctx, scty);
        end;
      mt12: begin

        end;
      mt13: begin
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
          if meff <> nil then begin
            case magnumb of
              32: begin
                  meff.ImgLib := {FrmMain.WMon21Img20080720ע��} g_WMonImagesArr[20];
                  meff.MagExplosionBase := 3580;
                  meff.TargetActor := target;
                  meff.Light := 3;
                  meff.NextFrameTime := 20;
                end;
              37: begin
                  meff.ImgLib := {FrmMain.WMon22Img20080720ע��} g_WMonImagesArr[21];
                  meff.MagExplosionBase := 3520;
                  meff.TargetActor := target;
                  meff.Light := 5;
                  meff.NextFrameTime := 20;
                end;
            end;
          end;
        end;
      mt14: begin
          case magnumb of
            101: begin //�ļ������
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(380 + (btEffectLevelEx - 1) div 3 * 10, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 9;
                  meff.ImgLib := g_WMagic9Images;
                end else begin
                  meff := TThuderEffect.Create(100, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 15;
                  meff.ImgLib := g_WMagic6Images;
                end;
              end;
            34: begin //�����
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(380 + (btEffectLevelEx - 1) div 3 * 10, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 9;
                  meff.ImgLib := g_WMagic9Images;
                end else begin
                  meff := TThuderEffect.Create(140, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 10;
                  meff.ImgLib := g_WMagic2Images;
                end;
              end;
            122: begin //��ɫ�����
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(380 + (btEffectLevelEx - 1) div 3 * 10, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 9;
                  meff.ImgLib := g_WMagic9Images;
                end else begin
                  meff := TThuderEffect.Create(1765, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 10;
                  if wimg <> nil then meff.ImgLib := wimg;
                end;
              end;
            123: begin //��ɫ�ļ������
                if btEffectLevelEx in [1..9] then begin
                  meff := TThuderEffect.Create(380 + (btEffectLevelEx - 1) div 3 * 10, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 9;
                  meff.ImgLib := g_WMagic9Images;
                end else begin
                  meff := TThuderEffect.Create(1785, sctx, scty, nil); //target);
                  meff.ExplosionFrame := 10;
                  if wimg <> nil then meff.ImgLib := wimg;
                end;
              end;
          end;
        end;
      mt15: begin
          meff := TFlyingBug.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
          meff.TargetActor := target;
          bofly := True;
        end;
      mt16: begin

        end;

    end;
    if (meff = nil) then Exit;

    meff.TargetRx := tx;
    meff.TargetRy := ty;
    if meff.TargetActor <> nil then begin
      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
    end;
    meff.MagOwner := aowner;
    m_EffectList.Add(meff);
  except
    DebugOutStr('TPlayScene.NewMagic' + IntToStr(magnumb));
  end;
end;

//cx, cy, tx, ty : ���� ��ǥ

function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer; mtype: TMagicType): TMagicEff;
var
  scx, scy, sctx, scty: integer;
  meff: TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case mtype of
    mtFlyArrow: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
    mt12: meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
    mt15: meff := TFlyingBug.Create(1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
  else meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
  end;
  meff.TargetRx := tx;
  meff.TargetRy := ty;
  meff.TargetActor := FindActor(targetcode);
  meff.MagOwner := aowner;
  m_FlyList.Add(meff);
  Result := meff;
end;

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
begin
  if g_MySelf = nil then exit;
  if g_D3DConfig.wScreenWidth = 800 then begin
    sx := (cx - g_MySelf.m_nRx) * UNITX + 364 + UNITX div 2 - g_MySelf.m_nShiftX;
    sy := (cy - g_MySelf.m_nRy) * UNITY + 192 + UNITY div 2 - g_MySelf.m_nShiftY;
    Exit;
  end else
    sx := (cx - g_MySelf.m_nRx) * UNITX + 505 + UNITX div 2 - g_MySelf.m_nShiftX;
  sy := (cy - g_MySelf.m_nRy) * UNITY + 290 + UNITY div 2 - g_MySelf.m_nShiftY;
end;

//��Ļ���� mx, myת����ccx, ccy��ͼ����

procedure TPlayScene.CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
begin
  if g_MySelf = nil then exit;
  if g_D3DConfig.wScreenWidth = 800 then begin

    ccx := UpInt((mx - 364 + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
    ccy := UpInt((my - 192 + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
  end else begin
    ccx := Round((mx - 485 {364} + g_MySelf.m_nShiftX - UNITX) / UNITX) + g_MySelf.m_nRx;
    ccy := Round((my - 270 {192} + g_MySelf.m_nShiftY - UNITY) / UNITY) + g_MySelf.m_nRy;
  end;
end;

//ȭ����ǥ�� ĳ����, �ȼ� ������ ����..

function TPlayScene.GetCharacter(x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy: integer;
  a: TActor;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 8 downto ccy - 1 do begin
    if m_ActorList.Count > 0 then begin //20080629
      for i := m_ActorList.Count - 1 downto 0 do
        if TActor(m_ActorList[i]) <> g_MySelf then begin
          a := TActor(m_ActorList[i]);
          if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
            if a.m_nCurrY = k then begin
                    //�� ���� ������ ���õǰ�
              dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
              dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
              if a.CheckSelect(x - dx, y - dy) then begin
                Result := a;
                Inc(nowsel);
                if nowsel >= wantsel then Exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

//ȡ�������ָ����Ľ�ɫ

function TPlayScene.GetAttackFocusCharacter(x, y, wantsel: integer; var nowsel: integer; liveonly: Boolean): TActor;
var
  k, i, ccx, ccy, dx, dy, centx, centy: integer;
  a: TActor;
begin
  Result := GetCharacter(x, y, wantsel, nowsel, liveonly);
  if Result = nil then begin
    nowsel := -1;
    CXYfromMouseXY(x, y, ccx, ccy);
    for k := ccy + 8 downto ccy - 1 do begin
      if m_ActorList.Count > 0 then //20080629
        for i := m_ActorList.Count - 1 downto 0 do
          if TActor(m_ActorList[i]) <> g_MySelf then begin
            a := TActor(m_ActorList[i]);
            if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) and (a.m_boVisible) then begin
              if a.m_nCurrY = k then begin
                dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
                dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
                if a.CharWidth > 40 then centx := (a.CharWidth - 40) div 2
                else centx := 0;
                if a.CharHeight > 70 then centy := (a.CharHeight - 70) div 2
                else centy := 0;
                if (x - dx >= centx) and (x - dx <= a.CharWidth - centx) and (y - dy >= centy) and (y - dy <= a.CharHeight - centy) then begin
                  Result := a;
                  Inc(nowsel);
                  if nowsel >= wantsel then Exit;
                end;
              end;
            end;
          end;
    end;
  end;
   //if (Result.m_btRace = 50) and (Result.m_wAppearance in [54..58]) then Result := nil;
end;

function TPlayScene.IsSelectMyself(x, y: integer): Boolean;
var
  k, ccx, ccy, dx, dy: integer;
begin
  Result := FALSE;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do begin
    if g_MySelf.m_nCurrY = k then begin
      //�� ���� ������ ���õǰ�
      dx := (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + g_MySelf.m_nPx + g_MySelf.m_nShiftX;
      dy := (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + g_MySelf.m_nPy + g_MySelf.m_nShiftY;
      if g_MySelf.CheckSelect(x - dx, y - dy) then begin
        Result := TRUE;
        exit;
      end;
    end;
  end;
end;
{
//ȡ��ָ�����������Ʒ
// x,y Ϊ��Ļ����
function  TPlayScene.GetDropItems (x, y: integer; var inames: string): PTDropItem; //ȭ����ǥ�� ������
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: integer;
  DropItem:PTDropItem;
  s: TDirectDrawSurface;
  c: byte;
begin
  Result := nil;
  CXYfromMouseXY (x, y, ccx, ccy);
  ScreenXYfromMCXY (ccx, ccy, ssx, ssy);
  dx := x - ssx;
  dy := y - ssy;
  inames := '';
  for i:=0 to g_DropedItemList.Count-1 do begin
    DropItem := PTDropItem(g_DropedItemList[i]);
    if (DropItem.X = ccx) and (DropItem.Y = ccy) then begin

      s := g_WDnItemImages.Images[DropItem.Looks];
      if s = nil then continue;
      dx := (x - ssx) + (s.Width div 2) - 3;
      dy := (y - ssy) + (s.Height div 2);
      c := s.Pixels[dx, dy];
      if c <> 0 then begin

        if Result = nil then Result := DropItem;
        inames := inames + DropItem.Name + '\';
        //break;
      end;
    end;
  end;
end;
}

//ȡ��ָ�����������Ʒ
// x,y Ϊ��Ļ����

function TPlayScene.GetDropItems(x, y: integer; var inames: string): PTDropItem;
var
  i, ccx, ccy, ssx, ssy: integer;
  d: PTDropItem;
begin
  Result := nil;
  CXYfromMouseXY(x, y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  inames := '';
  if g_DropedItemList.Count > 0 then //20080629
    for i := 0 to g_DropedItemList.Count - 1 do begin
      d := PTDropItem(g_DropedItemList[i]);
      if (d.X = ccx) and (d.Y = ccy) then begin // ��������ƶ�����Ʒ����ʾ���ֺ���  20080314
         {s := FrmMain.WDnItem.Images[d.Looks];        // �������Ʒ�Ƿ������ͼƬ
         if s = nil then continue;
         dx := (x - ssx) + (s.Width div 2) - 3;
         dy := (y - ssy) + (s.Height div 2);
         c := s.Pixels[dx, dy];
        if c <> 0 then }begin
          if Result = nil then Result := d;
          inames := inames + d.Name + '\';
            //break;
        end;
      end;
    end;
end;

procedure TPlayScene.GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
var
  I: Integer;
  DropItem: pTDropItem;
begin
  if g_DropedItemList.Count > 0 then //20080629
    for I := 0 to g_DropedItemList.Count - 1 do begin
      DropItem := g_DropedItemList[i];
      if (DropItem.X = nX) and (DropItem.Y = nY) then begin
        ItemList.Add(DropItem);
      end;
    end;
end;

{function TPlayScene.GetXYDropItems(nX, nY: Integer): pTDropItem;
var
  I:Integer;
  DropItem:pTDropItem;
begin
  Result:=nil;
  if g_DropedItemList.Count > 0 then //20080629
  for I:= 0 to g_DropedItemList.Count - 1 do begin
    DropItem:=g_DropedItemList[i];
    if (DropItem.X = nX) and (DropItem.Y = nY) then begin
      Result:=DropItem;
      break;
    end;
  end;
end; }

function TPlayScene.CanRun(sx, sy, ex, ey: integer): Boolean;
var
  ndir, rx, ry: integer;
begin
  ndir := GetNextDirection(sx, sy, ex, ey);
  rx := sx;
  ry := sy;
  GetNextPosXY(ndir, rx, ry);

  if Map.CanMove(rx, ry) and Map.CanMove(ex, ey) then
    Result := True
  else Result := False;

  if CanWalkEx(rx, ry) and CanWalkEx(ex, ey) then
    Result := TRUE
  else Result := FALSE;
end;

function TPlayScene.CanWalkEx(mx, my: integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashManEx(mx, my); {true;} //����
end;
//����

function TPlayScene.CrashManEx(mx, my: integer): Boolean;
var
  I: Integer;
  Actor: TActor;
begin
  try
    Result := False;
    if m_ActorList.Count > 0 then //20080629
      for i := 0 to m_ActorList.Count - 1 do begin
        Actor := TActor(m_ActorList[i]);
        if Actor <> nil then begin
          if (Actor.m_boVisible) and (Actor.m_boHoldPlace) and (not Actor.m_boDeath) and (Actor.m_nCurrX = mx) and (Actor.m_nCurrY = my) then begin
    //      DScreen.AddChatBoardString ('Actor.m_btRace ' + IntToStr(Actor.m_btRace),clWhite, clRed);
            if (Actor.m_btRace in [RCC_USERHUMAN, 1, 150]) and g_boCanRunHuman then Continue;
          //if (Actor.m_btRace = RCC_MERCHANT) and g_boCanRunNpc then Continue;
            if (Actor.m_btRace <> 0) and (Actor.m_btRace <> 50) and g_boCanRunMon then Continue;
          //if ((Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT)) and g_boCanRunMon then Continue;
          //m_btRace ���� 0 �������� 50 ��Ϊ����
            Result := True;
            break;
          end;
        end;
      end;
  except
    DebugOutStr('TPlayScene.CrashManEx');
  end;
end;

function TPlayScene.CanWalk(mx, my: integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);

end;

function TPlayScene.CrashMan(mx, my: integer): Boolean;
var
  i: integer;
  a: TActor;
begin
  Result := FALSE;
  if m_ActorList.Count > 0 then //20080629
    for i := 0 to m_ActorList.Count - 1 do begin
      a := TActor(m_ActorList[i]);
      if (a.m_boVisible) and (a.m_boHoldPlace) and (not a.m_boDeath) and (a.m_nCurrX = mx) and (a.m_nCurrY = my) then begin
        if (a.m_btRace in [RCC_USERHUMAN, 1, 150]) and g_boCanRunHuman then Continue;
        if (a.m_btRace <> 0) and (a.m_btRace <> 50) and g_boCanRunMon then Continue;
        Result := TRUE;
        break;
      end;
    end;
end;

{function  TPlayScene.CanFly (mx, my: integer): Boolean;
begin
   Result := Map.CanFly (mx, my);
end; }


{------------------------ Actor ------------------------}
//ͨ��ID ���������ɫ

function TPlayScene.FindActor(id: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  if m_ActorList.Count > 0 then //20080629
    for i := 0 to m_ActorList.Count - 1 do begin
      if TActor(m_ActorList[i]).m_nRecogId = id then begin
        Result := TActor(m_ActorList[i]);
        break;
      end;
    end;
end;
//ͨ�������������ɫ

function TPlayScene.FindActor(sName: string): TActor;
var
  I: Integer;
  Actor: TActor;
begin
  Result := nil;
  if m_ActorList.Count > 0 then //20080629
    for I := 0 to m_ActorList.Count - 1 do begin
      Actor := TActor(m_ActorList[i]);
      if CompareText(Actor.m_sUserName, sName) = 0 then begin
        Result := Actor;
        break;
      end;
    end;
end;
//��X��Y�����������ɫ

function TPlayScene.FindActorXY(x, y: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  if m_ActorList.Count > 0 then //20080629
    for i := 0 to m_ActorList.Count - 1 do begin
      if (TActor(m_ActorList[i]).m_nCurrX = x) and (TActor(m_ActorList[i]).m_nCurrY = y) then begin
        Result := TActor(m_ActorList[i]);
        if not Result.m_boDeath and Result.m_boVisible and Result.m_boHoldPlace then break;
      end;
    end;
end;
//�б����Ƿ��������ɫ

function TPlayScene.IsValidActor(actor: TActor): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  if m_ActorList.Count > 0 then //20080629
    for i := 0 to m_ActorList.Count - 1 do begin
      if TActor(m_ActorList[i]) = actor then begin
        Result := TRUE;
        break;
      end;
    end;
end;

// new copy by liuzhigang

function TPlayScene.NewActor(chrid: integer; //��ɫID
  cx: word; //x
  cy: word; //y
  cdir: word;
  cfeature: TFeatures; //cfeature:  integer; //race, hair, dress, weapon
  cstate: integer;
  cMonShowName: Byte): TActor;
var
  i: integer;
  actor: TActor;
begin
  Result := nil; //jacky
   //��������ɫ�Ƿ��Ѿ����ڽ�ɫ�б��У������ڣ����ô���
  if m_ActorList.Count > 0 then //20080629
    for i := 0 to m_ActorList.Count - 1 do
      if TActor(m_ActorList[i]).m_nRecogId = chrid then begin
        Result := TActor(m_ActorList[i]);
        Exit;
      end;
  if IsChangingFace(chrid) then exit; //������...
   //����Race������Ӧ�Ľ�ɫ����
   //case RACEfeature (cfeature) of //m_btRaceImg
  case cfeature.nRaceImg of
    0: actor := THumActor.Create; //����
    1: begin
        actor := THumActor.Create; //Ӣ��
      end;
    9: actor := TSoccerBall.Create; //����
    13: actor := TKillingHerb.Create; //ʳ�˻�
    14: actor := TSkeletonOma.Create; //����
    15: actor := TDualAxeOma.Create; //��������

    16: actor := TGasKuDeGi.Create; //����

    17: actor := TCatMon.Create; //��צè
    18: actor := THuSuABi.Create; //������
    19: actor := TCatMon.Create; //����սʿ

    20: actor := TFireCowFaceMon.Create; //��������
    21: actor := TCowFaceKing.Create; //�������
    22: actor := TDualAxeOma.Create; //�ڰ�սʿ
    23: actor := TWhiteSkeleton.Create; //��������
    24: actor := TSuperiorGuard.Create; //������ʿ
    30: actor := TCatMon.Create; //������
    31: actor := TCatMon.Create; //��Ӭ
    32: actor := TScorpionMon.Create; //Ы��

    33: actor := TCentipedeKingMon.Create; //������
    34: actor := TBigHeartMon.Create; //���¶�ħ
    35: actor := TSpiderHouseMon.Create; //��Ӱ֩��
    36: actor := TExplosionSpider.Create; //��ħ֩��
    37: actor := TFlyingSpider.Create; //

    40: actor := TZombiLighting.Create; //��ʬ1
    41: actor := TZombiDigOut.Create; //��ʬ2
    42: actor := TZombiZilkin.Create; //��ʬ3

    43: actor := TBeeQueen.Create; //��Ӭ��

    45: actor := TArcherMon.Create; //������
    47: actor := TSculptureMon.Create; //�������  ������ʿ
    48: actor := TSculptureMon.Create; //
    49: actor := TSculptureKingMon.Create; //�������

    50: actor := TNpcActor.Create;

    52: actor := TGasKuDeGi.Create; //Ш��
    53: actor := TGasKuDeGi.Create; //���
    54: actor := TSmallElfMonster.Create; //����,ʥ��
    55: actor := TWarriorElfMonster.Create; //����1,ʥ��1

    60: actor := TElectronicScolpionMon.Create;
    61: actor := TBossPigMon.Create;
    62: actor := TKingOfSculpureKingMon.Create;
    63: actor := TSkeletonKingMon.Create;
    64: actor := TGasKuDeGi.Create;
    65: actor := TSamuraiMon.Create;
    66: actor := TSkeletonSoldierMon.Create;
    67: actor := TSkeletonSoldierMon.Create;
    68: actor := TSkeletonSoldierMon.Create;
    69: actor := TSkeletonArcherMon.Create;
    70: actor := TBanyaGuardMon.Create; //ţħ��ʦ
    71: actor := TBanyaGuardMon.Create; //ţħ��˾
    72: actor := TBanyaGuardMon.Create; //��֮ţħ��
    73: actor := TPBOMA1Mon.Create;
    74: actor := TCatMon.Create;
    75: actor := TStoneMonster.Create;
    76: actor := TSuperiorGuard.Create;
    77: actor := TStoneMonster.Create;
    78: actor := TBanyaGuardMon.Create; //ħ����
    79: actor := TPBOMA6Mon.Create;
    80: actor := TMineMon.Create;
    81: actor := TAngel.Create;
    83: actor := TFireDragon.Create; //��������  20080304
    84: actor := TDragonStatue.Create;
    90: actor := TDragonBody.Create; //��
      //91: actor := TTempleGuardian.Create;   //ʥ����ʿ 20080809
    91: actor := TRedThunderZuma.create;
    92: actor := TheCrutchesSpider.Create; //����֩��
    93: actor := TYanLeiWangSpider.Create; //�������� 20080812
    94: actor := TSnowy.Create; //ѩ�򺮱�ħ��ѩ������ħ��ѩ���嶾ħ
    95: actor := TFireDragonGuard.Create; //�����ػ���
    96: actor := TSwordsmanMon.Create;
    97: actor := TSwordsmanMon.Create;
    98: actor := TWallStructure.Create; //LeftWall
    99: actor := TCastleDoor.Create; //MainDoor
    100: actor := TFairyMonster.Create; //����
    101: actor := TWealthAnimalMon.Create; //������
    102: actor := TSnowyHousecarl.Create; //ѩ������
    103: actor := TSnowyLuxman.Create; //ѩ����ʿ
    104: actor := TSnowyGuards.Create; //ѩ����ʿ
    105: actor := TSnowyHousecarl.Create; //ѩ��ս��
    106: actor := TSnowyHousecarl.Create; //TSnowyDaysWillbe.Create; //ѩ���콫
    107: actor := TSnowyBE.Create; //ѩ��ħ��
    108: actor := TFoxRed.Create;
    109: actor := TFoxRed.Create; //���
    110: actor := TFoxRed.Create; //�غ�
    111: actor := TFoxBall.Create;
    112: actor := TFoxStone.Create;
    113: actor := TFoxBall.Create; //
    114: actor := TFireMonster.Create; //����
    115: actor := TFoxBall1.Create; //���
    116: actor := TRabbitMonster.Create; //����
    117: actor := TNewFireDragon.Create; //�»���
    118: actor := TNPCMonster.Create; //29.wil���������NPCͼ
    119: actor := TTigerMonster.Create; //�ϻ�
    120,121,122,123: actor := TpjMon.Create;
    150: actor := THumActor.Create; //����
  else actor := TActor.Create;
  end;

  with actor do begin
    m_nRecogId := chrid;
    m_nCurrX := cx;
    m_nCurrY := cy;
    m_nRx := m_nCurrX;
    m_nRy := m_nCurrY;
    m_btDir := cdir;
    m_nFeature := cfeature;
    m_btRace := cfeature.nRaceImg; //RACEfeature(cfeature);         //����
    if cMonShowName = 158 then //����
      m_btHair := cMonShowName
    else m_btHair := cfeature.btHair; //HAIRfeature(cfeature);         //ͷ��
    m_boMagicShield := cfeature.btStatus = 1;
    m_btDress := cfeature.nDress; //DRESSfeature(cfeature);        //��װ
    m_btWeapon := cfeature.nWeapon; //WEAPONfeature(cfeature);       //����

    m_wAppearance := cfeature.nDress;//cfeature.nAppr; //APPRfeature(cfeature);         //��ò

      //m_Action     := GetMonAction(m_wAppearance);
    if m_btRace in [0, 1, 150] then begin //����,Ӣ��,����20080629
      m_btSex := m_btDress mod 2; //0:�� 1:Ů
    end else begin
      m_btSex := 0;
    end;
    m_nState := cstate;
    m_SayingArr[0] := '';
  end;
  m_ActorList.Add(actor);
  Result := actor;
end;


//��ɫ�������Ѹý�ɫɾ����Ȼ�����·ŵ���ɫ�б��еĵ�һ��δ������ɫǰ��

procedure TPlayScene.ActorDied(actor: TObject);
var
  i: integer;
  flag: Boolean;
begin
  try
    if m_ActorList.Count > 0 then //20080629
      for i := 0 to m_ActorList.Count - 1 do
        if m_ActorList[i] = actor then begin
          m_ActorList.Delete(i);
          break;
        end;
    flag := FALSE;
    if m_ActorList.Count > 0 then //20080629
      for i := 0 to m_ActorList.Count - 1 do
        if not TActor(m_ActorList[i]).m_boDeath then begin
          m_ActorList.Insert(i, actor);
          flag := TRUE;
          break;
        end;
    if not flag then m_ActorList.Add(actor);
  except
    DebugOutStr('TPlayScene.ActorDied');
  end;
end;
//���ý�ɫ����ʾ�㼶����ɫ�б��˳��
//��Level=0ʱ������ָ���Ľ�ɫ���ڽ�ɫ�б����ǰ��

procedure TPlayScene.SetActorDrawLevel(actor: TObject; level: integer);
var
  i: integer;
begin
  try
    if level = 0 then begin
      if m_ActorList.Count > 0 then //20080629
        for i := 0 to m_ActorList.Count - 1 do
          if m_ActorList[i] = actor then begin
            m_ActorList.Delete(i);
            m_ActorList.Insert(0, actor);
            break;
          end;
    end;
  except
    DebugOutStr('TPlayScene.SetActorDrawLevel');
  end;
end;
//������н�ɫ

procedure TPlayScene.ClearActors; //�α׾ƿ��� ���
var
  I: integer;
  ErrCode: Integer;
begin
  ErrCode := 0;
  try
    ErrCode := 1;
    if m_ActorList.Count > 0 then begin //20080629
      ErrCode := 2;
      for i := 0 to m_ActorList.Count - 1 do TActor(m_ActorList.Items[i]).Free;
      m_ActorList.Clear;
    end;
    ErrCode := 3;
    g_MySelf := nil;
    g_HeroSelf := nil;
    g_TargetCret := nil;
    g_FocusCret := nil;
    g_MagicTarget := nil;
    ErrCode := 4;
    //���ħ��Ч������
    if m_EffectList.Count > 0 then begin //20080629
      ErrCode := 5;
      for i := 0 to m_EffectList.Count - 1 do TMagicEff(m_EffectList[i]).Free;
      m_EffectList.Clear;
    end;
  except
    DebugOutStr('TPlayScene.ClearActors Code:' + IntToStr(ErrCode));
  end;
end;
//���ݽ�ɫIDɾ��һ����ɫ

function TPlayScene.DeleteActor(id: integer): TActor;
var
  i: integer;
begin
  try
    Result := nil;
    i := 0;
    while TRUE do begin
      if i >= m_ActorList.Count then break;
      if TActor(m_ActorList[i]).m_nRecogId = id then begin
        if g_TargetCret = TActor(m_ActorList[i]) then g_TargetCret := nil;
        if g_FocusCret = TActor(m_ActorList[i]) then g_FocusCret := nil;
        if g_MagicTarget = TActor(m_ActorList[i]) then g_MagicTarget := nil;
        TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
        g_FreeActorList.Add(m_ActorList[i]);
         //TActor(ActorList[i]).Free;
        m_ActorList.Delete(i);
      end else
        Inc(i);
    end;
  except
    DebugOutStr('TPlayScene.DeleteActor');
  end;
end;
//�ӽ�ɫ�б���ɾ��һ����ɫ

procedure TPlayScene.DelActor(actor: TObject);
var
  i: integer;
begin
  try
    if m_ActorList.Count > 0 then //20080629
      for i := 0 to m_ActorList.Count - 1 do
        if m_ActorList[i] = actor then begin
          TActor(m_ActorList[i]).m_dwDeleteTime := GetTickCount;
          g_FreeActorList.Add(m_ActorList[i]);
          m_ActorList.Delete(i);
          break;
        end;
  except
    DebugOutStr('TPlayScene.DelActor');
  end;
end;
//��������(X,Y)���Ľ�ɫ�������ɫ�Ѿ��������Ҳ�������

function TPlayScene.ButchAnimal(x, y: integer): TActor;
var
  i: integer;
  a: TActor;
begin
  try
    Result := nil;
    if m_ActorList.Count > 0 then //20080629
      for i := 0 to m_ActorList.Count - 1 do begin
        a := TActor(m_ActorList[i]);
        if a.m_boDeath and (a.m_btRace <> 0) then begin //2008.01.20 ���͹ֺ������ͻ
          if (abs(a.m_nCurrX - x) <= 1) and (abs(a.m_nCurrY - y) <= 1) then begin
            Result := a;
            break;
          end;
        end;
      end;
  except
    DebugOutStr('TPlayScene.ButchAnimal');
  end;
end;




{------------------------- Msg -------------------------}
//�޼����� ���۸��ϴ� ������ ?
//ĳ������ �޼��� ���ۿ� �޼����� ���� �ִ� ���¿���
//���� �޼����� ó���Ǹ� �ȵǱ� ������.

procedure TPlayScene.SendMsg(ident, chrid, x, y, cdir, feature, state: integer; cMonShowName: Byte; NewFeature: TFeatures; str: string);
var
  actor: TActor;
  S: array[0..2] of string;
begin
  try
    case ident of
      SM_TEST:
        begin
          actor := NewActor(111, 254 {x}, 214 {y}, 0, NewFeature, 0, 0);
          g_MySelf := THumActor(actor);
          Map.LoadMap('0', g_MySelf.m_nCurrX, g_MySelf.m_nCurrY);
        end;
      SM_CHANGEMAP,
        SM_NEWMAP: begin
          Map.LoadMap(str, x, y);
{$IF M2Version = 2} //1.76
        {DarkLevel := cdir;
        if DarkLevel = 0 then g_boViewFog := FALSE
        else g_boViewFog := TRUE;   }
{$IFEND}
            //
          if g_boViewMiniMap then begin
            g_nMiniMapIndex := -1;
            FrmMain.SendWantMiniMap;
          end;
            //
          if (ident = SM_NEWMAP) and (g_MySelf <> nil) then begin
            g_MySelf.m_nCurrX := x;
            g_MySelf.m_nCurrY := y;
            g_MySelf.m_nRx := x;
            g_MySelf.m_nRy := y;
            DelActor(g_MySelf);
            if g_HeroSelf <> nil then //20080720����
              DelActor(g_HeroSelf);
          end;
        end;
     { SM_RUSH79: begin
        actor := FindActor (chrid);
        if actor <> nil then begin
          actor.m_nCurrX := x;
          actor.m_nCurrY := y;
          actor.m_nRx := x;
          actor.m_nRy := y;
        end;
      end;   }
      SM_RECALLHERO:
        begin
          actor := FindActor(chrid);
          if actor = nil then begin
            actor := NewActor(chrid, x, y, Lobyte(cdir), NewFeature, state, cMonShowName);
            actor.m_nChrLight := Hibyte(cdir);
          end;
          if g_HeroSelf <> nil then begin
            g_HeroSelf := nil;
          end;
          g_HeroSelf := THumActor(actor);
        end;
      SM_CREATEHERO:
        begin
          actor := FindActor(chrid);
          if actor = nil then begin
            actor := NewActor(chrid, x, y, Lobyte(cdir), NewFeature, state, cMonShowName);
            actor.m_nChrLight := Hibyte(cdir);
            cdir := Lobyte(cdir);
            actor.SendMsg(SM_TURN, x, y, cdir, feature, state, '', 0, NewFeature); //����Ӣ�۸��г�����ͷ����
          end;
        end;
      SM_LOGON:
        begin

          actor := FindActor(chrid);
          if actor = nil then begin
            actor := NewActor(chrid, x, y, Lobyte(cdir), NewFeature, state, cMonShowName);
            actor.m_nChrLight := Hibyte(cdir);
            cdir := Lobyte(cdir);
            actor.SendMsg(SM_TURN, x, y, cdir, Feature, state, '', 0, NewFeature); //ת��
          end;
          if g_MySelf <> nil then begin
            g_MySelf := nil;
          end;
          g_MySelf := THumActor(actor);
        end;
      SM_HIDE:
        begin
          actor := FindActor(chrid);
          if actor = g_HeroSelf then Exit; //�ڴ�����Ӣ��������ʧ 2008.01.27
          if actor <> nil then begin
            if actor.m_boDelActionAfterFinished then exit;
            if actor.m_nWaitForRecogId <> 0 then Exit;
          end;
          DeleteActor(chrid);
        end;
    else begin
        actor := FindActor(chrid);
        if (ident = SM_TURN) or (ident = SM_RUN) {or (ident=SM_HORSERUN)20080803ע��������Ϣ} or (ident = SM_WALK) or (ident = SM_NPCWALK) or
          (ident = SM_BACKSTEP) or
          (ident = SM_DEATH) or (ident = SM_SKELETON) or
          (ident = SM_DIGUP) or (ident = SM_ALIVE) then
        begin
          if actor = nil then
            actor := NewActor(chrid, x, y, Lobyte(cdir), NewFeature, state, cMonShowName);
          if actor <> nil then begin
            actor.m_nSerX:=x;//��������µ�����By TasNat at: 2012-07-22 13:42:44
            Actor.m_nSerY:=y;
            actor.m_nChrLight := Hibyte(cdir);
            cdir := Lobyte(cdir);
            if ident = SM_SKELETON then begin
              actor.m_boDeath := TRUE;
              actor.m_boSkeleton := TRUE;
            end;
          end;
        end;
        if actor = nil then exit;
        case ident of
          SM_FEATURECHANGED: begin
              actor.m_nFeature := NewFeature;
              actor.m_nFeatureEx := state;
              actor.FeatureChanged;
            end;
          SM_CHARSTATUSCHANGED: begin
              actor.m_nState := Feature;
              actor.m_nHitSpeed := state;
              if actor = g_MySelf then
                g_MySelfSuitAbility.nGongJiSuDu := state;
              actor.m_nMoveTimeStep := X;
                 {if actor.m_btRace in [0,1,150] then begin
                 if str = '444' then THumActor(actor).m_boMagbubble4 := True; //��
                 if str = '555' then THumActor(actor).m_boMagbubble4 := False;//��
                 end; }
            end;
          SM_MAGIC69SKILLNH: begin
              actor.m_Skill69NH := x;
              actor.m_Skill69MaxNH := y;
            end;
        else begin
            if ident = SM_TURN then begin
              if str <> '' then
                actor.m_sUserName := str;
            end;
            actor.SendMsg(ident, x, y, cdir, feature, state, '', 0, NewFeature);
          end;
        end;
      end;
    end;
  except
    DebugOutStr(format('TPlayScene.SendMsg ident: %d', [ident]));
  end;
end;


procedure TPlayScene.EdChatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

function TPlayScene.NewCanWalkEx(mx, my: Integer): Boolean;
begin
  Result := FALSE;
  if Map.NewCanMove(mx, my) then //Result := TRUE;
    Result := not CrashManEx(mx, my);
end;
{$IF M2Version <> 2} //1.76

procedure TPlayScene.OpenScreenShake;
begin
  if m_boScreenShake or not FrmDlg.DCheckScreenShake.Checked then Exit;
   //m_dwShakeTime := GetTickCount;
  m_nShakeY := 0;
  m_btShakeNum := 0;
  m_boScreenShake := True;
end;

procedure TPlayScene.ScreenShake;
var
  nTime: Integer;
begin
  if not m_boScreenShake then Exit;
  case m_btShakeNum of
    0: nTime := 0;
    1: nTime := 120;
    2: nTime := 120;
    3: nTime := 170;
  end;
  if GetTickCount - m_dwShakeTime >= nTime then begin
    if m_nShakeY = 0 then begin
      case m_btShakeNum of
        0: begin
            m_dwShakeYTime := GetTickCount + 200;
            Dec(m_nShakeY, 6);
            nTime := 50;
          end;
        1: begin
            Dec(m_nShakeY, 6);
            nTime := 120;
          end;
        2: begin
            Dec(m_nShakeY, 4);
            nTime := 90;
          end;
        3: begin
            Dec(m_nShakeY, 5);
            nTime := 170;
          end;
      else begin
          m_boScreenShake := False;
          m_nShakeY := 0;
        end;
      end;
    end;
    if not m_boScreenShake then Exit;
    if GetTickCount - m_dwShakeYTime >= nTime then begin
      m_dwShakeYTime := GetTickCount;
      case m_btShakeNum of
        0: Inc(m_nShakeY, 6);
        1: Inc(m_nShakeY, 6);
        2: Inc(m_nShakeY, 4);
        3: Inc(m_nShakeY, 5);
      end;
      Inc(m_btShakeNum)
    end;
  end;
end;

procedure TPlayScene.ShowMySelfEff(EffType: Byte; Dir: Byte);
begin
  m_btMySelfEffType := EffType;
  m_btMySelfEffDir := Dir;
  m_boShowMySelfEff := True;
  m_btMySelfEffImgFrame := 0;
  m_dwMySelfAllTime := GetTickCount();
  m_nMySelfNextFrameTime := 100;
end;

procedure TPlayScene.DrawMySelfEff(Surface: TAsphyreCanvas; dx, dy: integer);
var
  d: TAsphyreLockableTexture;
  AllEffTime: Integer;
  ax, ay: Integer;
begin
  if m_boShowMySelfEff then begin
    if (GetTickCount - m_dwMySelfEffTimeTick > longword(m_nMySelfNextFrameTime)) then begin
      m_dwMySelfEffTimeTick := GetTickCount;
      Inc(m_btMySelfEffImgFrame);
      if m_btMySelfEffImgFrame > 5 then begin
        m_btMySelfEffImgFrame := 0;
      end;
    end;
    case m_btMySelfEffType of
      1: begin //СȦ
          d := g_WUI1Images.GetCachedImage(1170 + m_btMySelfEffImgFrame, ax, ay);
          AllEffTime := 5000;
        end;
      2: begin //��Ȧ
          d := g_WUI1Images.GetCachedImage(1180 + m_btMySelfEffImgFrame, ax, ay);
          AllEffTime := 5000;
        end;
      3: begin //��Ȧ
          d := g_WUI1Images.GetCachedImage(1190 + m_btMySelfEffImgFrame, ax, ay);
          AllEffTime := 5000;
        end;
      4: begin //��ͷ
          d := g_WUI1Images.GetCachedImage(1080 + m_btMySelfEffDir * 10 + m_btMySelfEffImgFrame, ax, ay);
          AllEffTime := 5000;
        end;
    else begin
        m_boShowMySelfEff := False;
      end;
    end;
    if not m_boShowMySelfEff then Exit;
    if d <> nil then begin
      Surface.DrawBlend(dx + ax + g_MySelf.m_nShiftX, dy + ay + g_MySelf.m_nShiftY, d);
    end;
    if GetTickCount - m_dwMySelfAllTime > LongWord(AllEffTime) then begin
      m_boShowMySelfEff := False;
    end;
  end;
end;
{$IFEND}

end.

