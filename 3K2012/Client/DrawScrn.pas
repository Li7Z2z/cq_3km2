unit DrawScrn;//DrawScrn,��ʵ��׼ȷ��˵��DrawScrn-txt,,,,����������ʵ�ʻ�ͼ�����Ѿ���introscrn.pas��playscrn.pas�������
//����������
interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, 
  DXDraws, DXClass, IntroScn, Actor, clFunc,
  HUtil32,Grobal2, uDListView, uDChatMemo;


const
   //VIEWCHATLINE = 9;//9���ı������
   AREASTATEICONBASE = 150;//area state icon base Prguse.wil��150ս��151��ȫ
   HEALTHBAR_BLACK = 0;//Prguse3.wil��
   HEALTHBAR_RED = 1; //Prguse3.wil��


type
//�����
  PBoardStyle=^TBoardStyle;
  TBoardStyle=Record
     FColor:Integer;
     BColor:Integer;
     Time :Integer;
     Createtime:Integer;
  end;
//�ײ���Ϣ
  PBottomSysStyle=^TBottomSysStyle;
  TBottomSysStyle=Record
     FColor:Integer;
     Createtime:LongWord;
  end;
//������Ϣ
  PRightBottomSysStyle=^TRightBottomSysStyle;
  TRightBottomSysStyle=Record
     FColor: Integer;
     BColor: Integer;
     Createtime:LongWord;
     ShowTime: LongWord;
  end;
//������������Ϣ
  TTopChat=record
    FColor :Integer;
    BColor :Integer;
    Time   :LongWord;
  end;
  pTopChat=^TTopChat;

  TMoveTopStrShow = packed record
    sMoveStr    :string;
    btMoveNil   :Byte;
    nMoveStrEnd     :Integer;
    btMoveAlpha     :Byte;
    boMoveStrShow   :Boolean;
    btFColor: Byte; //ǰ��ɫ
    btBColor: Byte; //����ɫ
    dwMoveStrTick   :LongWord;
  end;
  pTMoveTopStrShow= ^TMoveTopStrShow;

//�����
   TDrawScreen = class
   private
      m_dwFrameTime       :LongWord;
      //m_dwFrameCount      :LongWord;
      //m_dwDrawFrameCount  :LongWord;
      m_SysMsgList        :TStringList;
      m_SysMsgListBottom  :TStringList; //������ʾ
      m_SysMsgListRightBottom: TStringList; //������ʾ

       //������Ϣ
      m_SysBoard:TStringList;
      m_SysBoardIndex: Integer;
      m_SysBoardxPos :Integer;
      m_SysBoardTime: LongWord;
      function GetShowItemName(DropItem: pTDropItem): Pointer; overload;
   public
      CurrentScene: TScene;       //��ǰ����
      ChatStrs: TStringList;      //��������
      //TopChatStrs: TStringList;   //������������
      ChatBks: TList;             //��Ӧ�ı���ɫ
      ChatBoardTop: integer;

      HintList: TStringList;      //��ʾ��Ϣ�б�
      HintX, HintY, HintWidth, HintHeight: integer;
      HintUp: Boolean;
      HintDec: Boolean;
      HintColor: TColor;

      TzHintList: TStringList;      //��װ��ʾ��Ϣ�б�
      SpecialHintList: TStringList;  //������ʾ��Ϣ�б�
      //����������ĵ���ʱ����
      m_boCountDown: Boolean;  //�Ƿ���ʾ
      m_SCountDown :string; //��ʾ����
      m_CountDownForeGroundColor :Integer;
      m_dwCountDownTimeTick :longWord;
      m_dwCountDownTimer :longWord;
      m_dwCountDownTimeTick1 :longWord;
      //����Ӣ�۸���ģʽ
      m_boHeroCountDown: Boolean; //Ӣ�۸���ģʽ�Ƿ���ʾ
      m_SHeroCountDown :string; //��ʾ����
      m_HeroCountDownForeGroundColor :Integer;
      m_dwHeroCountDownTimeTick :longWord;
      m_dwHeroCountDownTimer :longWord;
      m_dwHeroCountDownTimeTick1 :longWord;

      m_MoveTopStrList: TList;

      constructor Create;
      destructor Destroy; override;
      procedure KeyPress (var Key: Char);
      procedure KeyDown (var Key: Word; Shift: TShiftState);
      procedure MouseMove (Shift: TShiftState; X, Y: Integer);
      procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure Initialize;
      procedure Finalize;
      procedure ChangeScene (scenetype: TSceneType);
      procedure DrawScreen (MSurface: TDirectDrawSurface);
      procedure DrawScreenTop (MSurface: TDirectDrawSurface);
      procedure Draw3km2Help (MSurface: TDirectDrawSurface);
      procedure AddSysMsg (msg: string);
      procedure AddBottomSysMsg (msg: string; btType:Byte);
      procedure AddRightBottomMsg(fcolor, bcolor: Integer; dWTime:LongWord; msg: string);  //������Ϣ
      procedure AddSysBoard(msg: string;FColor,BColor,Time:Integer);
      procedure AddChatTopString (str: string; fcolor, bcolor: Integer); //���������������Ϣ
      procedure DelChatTopString();//�����ʱ����������Ϣ
      procedure AddChatBoardString (str: string; fcolor, bcolor: integer);
      procedure ClearChatBoard;
      procedure DrawScreenBoard(MSurface: TDirectDrawSurface);//�����
      procedure AddCenterLetter(ForeGroundColor,BackGroundColor,Timer:Integer; CenterLetter:string);
      procedure DrawScreenCenterLetter(MSurface: TDirectDrawSurface);//��Ļ�м���ʾ������Ϣ
      procedure DrawScreenTopLetter(MSurface: TDirectDrawSurface); //��Ļ����������ʾ����Ч��
      procedure AddTopLetter(ForeGroundColor,BackGroundColor:Byte; CenterLetter:string);
      procedure AddCountDown(ForeGroundColor:Integer;Timer:LongWord;CountDown:string);//�������Ļ�м���ʾ������Ϣ
      procedure AddHeroCountDown(ForeGroundColor:Integer;Timer:LongWord;CountDown:string);//�������Ļ�м���ʾӢ�۸���������Ϣ
      procedure DrawScreenCountDown(MSurface: TDirectDrawSurface);//��ʾ����������ĵ���ʱ
      //**��ʾ��ʾ��Ϣ**
      procedure DrawHint (MSurface: TDirectDrawSurface);
      procedure ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
      procedure ClearHint;
      //**��ʾ��װ��Ϣ**
      procedure DrawTzHint (MSurface: TDirectDrawSurface);
      procedure ShowTzHint (x, y: integer; str: string; drawup, HintDec: Boolean; nWidth: Byte{�¼ӿ��});
      //**������ʾ��Ϣ**
      procedure DrawSpecialHint (MSurface: TDirectDrawSurface);
      procedure ShowSpecialHint (x, y: integer; str: string; drawup: Boolean);
   end;


implementation

uses
   ClMain, MShare, Share, FState;


constructor TDrawScreen.Create;
begin
   CurrentScene := nil;
   m_dwFrameTime := GetTickCount;
   //m_dwFrameCount := 0;
   m_SysMsgList := TStringList.Create;
   m_SysMsgListBottom := TStringList.Create;
   m_SysMsgListRightBottom := TStringList.Create;
   m_SysBoard:=TStringList.Create;//��ʼ��������б�
   ChatStrs := TStringList.Create;
   //TopChatStrs := TStringList.Create;
   ChatBks := TList.Create;
   //�����
   m_SysBoardIndex:=0;
   m_SysBoardxPos:=800;
   //�����
   ChatBoardTop := 0;
   HintList := TStringList.Create;

   TzHintList := TStringList.Create;
   SpecialHintList := TStringList.Create;
   m_MoveTopStrList := TList.Create;
   m_boCountDown := False;  //�Ƿ���ʾ
   m_boHeroCountDown := False;
end;

destructor TDrawScreen.Destroy;
var
  I: Integer;
begin
  m_SysMsgList.Free;
  m_SysMsgListBottom.Free;
  m_SysMsgListRightBottom.Free;
  m_SysBoard.Free;//������б�
  ChatStrs.Free;
  //TopChatStrs.Free;
  ChatBks.Free;
  HintList.Free;
  TzHintList.Free;
  SpecialHintList.Free;
  for I:=0 to m_MoveTopStrList.Count-1 do begin
    Dispose(pTMoveTopStrShow(m_MoveTopStrList.Items[I]));
  end;
  FreeAndNil(m_MoveTopStrList);
  inherited Destroy;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
end;

procedure TDrawScreen.KeyPress (var Key: Char);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyPress (Key);
end;

procedure TDrawScreen.KeyDown (var Key: Word; Shift: TShiftState);
begin
   if CurrentScene <> nil then
      CurrentScene.KeyDown (Key, Shift);
end;

procedure TDrawScreen.MouseMove (Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseMove (Shift, X, Y);
end;

procedure TDrawScreen.MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if CurrentScene <> nil then
      CurrentScene.MouseDown (Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene (scenetype: TSceneType);
begin
   if CurrentScene <> nil then
      CurrentScene.CloseScene;
   case scenetype of
      stIntro:  CurrentScene := IntroScene;
      stLogin:  CurrentScene := LoginScene;
      stSelectCountry:  ;
      stSelectChr: CurrentScene := SelectChrScene;
      stNewChr:     ;
      stLoading:    ;
      stLoginNotice: CurrentScene := LoginNoticeScene;
      stPlayGame: CurrentScene := PlayScene;
   end;
   if CurrentScene <> nil then
      CurrentScene.OpenScene;
end;
//���ϵͳ��Ϣ
procedure TDrawScreen.AddSysMsg (msg: string);
begin
   if m_SysMsgList.Count >= 10 then m_SysMsgList.Delete (0);
   m_SysMsgList.AddObject (msg, TObject(GetTickCount));
end;
//�������ϵͳ��Ϣ
//����btType  0��ǰ��Ϊ��ɫ  1��ǰ��Ϊ��ɫ
procedure TDrawScreen.AddBottomSysMsg (msg: string; btType:Byte);
var
  BottomSysStyle:PBottomSysStyle;
begin
  if m_SysMsgListBottom.Count >= 10 then m_SysMsgListBottom.Delete (0);
  New(BottomSysStyle);
  BottomSysStyle^.Createtime := GetTickCount;
  if btType = 0 then BottomSysStyle^.FColor := clRed
  else if btType = 1 then BottomSysStyle^.FColor := clYellow;
  m_SysMsgListBottom.AddObject(msg, TObject(BottomSysStyle));
end;

//�����Ϣ��������б�    2007.11.11
procedure TDrawScreen.AddSysBoard(msg: string;FColor,BColor,Time:Integer);
var
  Boardstyle:PBoardStyle;
begin
  if m_SysBoard.Count >= 10 then begin
    Boardstyle:=PBoardStyle(m_SysBoard.Objects[0]);
    DisPose(Boardstyle);
    m_SysBoard.Delete(0);
  end;
  New(Boardstyle);
  Boardstyle^.FColor:=FColor;
  Boardstyle^.BColor:=Bcolor;
  Boardstyle^.Time:=Time;
  Boardstyle^.Createtime:=0;
  m_SysBoard.AddObject(msg, TObject(Boardstyle));
end;
//�����ʱ����������Ϣ
procedure TDrawScreen.DelChatTopString();
var
  I: Integer;
  ViewItem: pTViewItem;
begin
 { for I:=0 to TopChatStrs.Count-1 do begin
    if GetTickCount() - pTopChat(TopChatStrs.Objects[I]).Time > 45000 then begin
      Dispose(pTopChat(TopChatStrs.Objects[I]));
      TopChatStrs.Delete(I);
    end;
  end;   }
  for I := FrmDlg.DChatMemo.TopLines.Count - 1 downto 0 do begin 
    ViewItem := TDChatMemoLines(FrmDlg.DChatMemo.TopLines).Items[I];
    if GetTickCount > ViewItem.TimeTick then begin
      FrmDlg.DChatMemo.DeleteTop(I);
    end;
  end;
end;

//���������������Ϣ
procedure TDrawScreen.AddChatTopString (str: string; fcolor, bcolor: Integer);
{var
  TopChat: pTopChat;    }
begin
 { if TopChatStrs.Count > 2 then begin
    Dispose(pTopChat(TopChatStrs.Objects[0]));
    TopChatStrs.Delete(0);
  end;
  New(TopChat);
  TopChat^.FColor := fcolor;
  TopChat^.BColor := bcolor;
  TopChat^.Time := GetTickCount();
  TopChatStrs.AddObject(str, TObject(TopChat));    }
  FrmDlg.DChatMemo.AddTop(str, fcolor, bcolor, 45);
end;
//�����Ϣ�����
procedure TDrawScreen.AddChatBoardString (str: string; fcolor, bcolor: integer);
(*var
   i, len, aline: integer;
   temp: string;
const
   BOXWIDTH = (SCREENWIDTH div 2 - 214) * 2{374; //41 ��������ֿ��  *)
begin
  (* len := Length (str);
   temp := '';
   i := 1;
   while TRUE do begin
      if i > len then break;
      if byte (str[i]) >= 128 then begin
         temp := temp + str[i];
         Inc (i);
         if i <= len then temp := temp + str[i]
         else break;
      end else
         temp := temp + str[i];

      aline := FrmMain.Canvas.TextWidth (temp);
      if aline > BOXWIDTH then begin
         ChatStrs.AddObject (temp, TObject(fcolor));
         ChatBks.Add (Pointer(bcolor));
         str := Copy (str, i+1, Len-i);
         temp := '';
         break;
      end;
      Inc (i);
   end;
   if temp <> '' then begin
      ChatStrs.AddObject (temp, TObject(fcolor));
      ChatBks.Add (Pointer(bcolor));
      str := '';
   end;
   if ChatStrs.Count > 200 then begin
      ChatStrs.Delete (0);
      ChatBks.Delete (0);
      if ChatStrs.Count - ChatBoardTop < {VIEWCHATLINE}9-TopChatStrs.Count then Dec(ChatBoardTop);
   end else if (ChatStrs.Count-ChatBoardTop) > {VIEWCHATLINE}9-TopChatStrs.Count then begin
      Inc (ChatBoardTop);
   end;

   if str <> '' then
      AddChatBoardString (' ' + str, fcolor, bcolor);     *)
   FrmDlg.DChatMemo.Add(str, fcolor, bcolor);

end;
//������ĳ����Ʒ����ʾ����Ϣ    2007.10.21
procedure TDrawScreen.ShowHint (x, y: integer; str: string; color: TColor; drawup: Boolean);
var
   data: string;
   w: integer;
begin
   ClearHint;
   HintX := x;
   HintY := y;
   HintWidth := 0;
   HintHeight := 0;
   HintUp := drawup;
   HintColor := color;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['\']);
      w := FrmMain.Canvas.TextWidth (data) + 4{����} * 2;
      if w > HintWidth then HintWidth := w;
      if data <> '' then HintList.Add (data)
   end;
   HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * HintList.Count + 3{����} * 2;
   if HintUp then
      HintY := HintY - HintHeight;
end;
//���������ĳ����Ʒ����ʾ����Ϣ    2007.10.21
procedure TDrawScreen.ClearHint;
begin
  if HintList.Count > 0 then HintList.Clear;
  if TzHintList.Count > 0 then TzHintList.Clear;
  if SpecialHintList.Count > 0 then SpecialHintList.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
begin
   m_SysMsgList.Clear;
   m_SysMsgListBottom.Clear;
   m_SysMsgListRightBottom.Clear;
   ChatStrs.Clear;
   //TopChatStrs.Clear;
   ChatBks.Clear;
   ChatBoardTop := 0;
end;


procedure TDrawScreen.DrawScreen (MSurface: TDirectDrawSurface);
  procedure NameTextOut (actor: TActor; surface: TDirectDrawSurface; x, y, fcolor, bcolor: integer; namestr: string);
  var
    i, row: integer;
    nstr: string;
    nfcolor: Integer;
  begin
    row := 0;
    for i:=0 to 10 do begin
      if namestr = '' then break;
      namestr := GetValidStr3 (namestr, nstr, ['\']);
      if Pos('(��̽��)',nstr) > 0 then nfcolor := $005AC663 else nfcolor := fcolor;
      surface.BoldTextOut (x - FrmMain.Canvas.TextWidth(nstr) div 2,
                  y + row * 12,
                  nfcolor, bcolor, nstr);
      Inc (row);
    end;
  end;
var
  I, K: integer;
  actor: TActor;
  uname: string;
  d: TDirectDrawSurface;
  rc: TRect;
  infoMsg :String;
  DropItem: PTDropItem;
  ShowItem: pTShowItem1;
  mx,my:integer;
  ItemColor: TColor;
  {$IF M2Version <> 2}
  II: Integer;
  MoveShow: pTMoveHMShow;
  TitleWidth: Word;
  {$IFEND}
begin
  MSurface.Fill(0);
  if CurrentScene <> nil then CurrentScene.PlayScene (MSurface);
  if g_MySelf = nil then Exit;

  if CurrentScene = PlayScene then begin
    with MSurface do begin
      with PlayScene do begin
        if g_DropedItemList.Count > 0 then begin
          for k:=0 to g_DropedItemList.Count-1 do begin
            DropItem := PTDropItem (g_DropedItemList[k]);
            if DropItem <> nil then begin
              if (abs(g_MySelf.m_nCurrX - DropItem.X) >= 9) or (abs(g_MySelf.m_nCurrY - DropItem.Y) >= 7) then Continue;
              ShowItem := GetShowItemName(DropItem);
              if (ShowItem <> nil) and (ShowItem.boHintMsg or ShowItem.boShowName or g_boShowAllItem) then begin
                if ShowItem.boHintMsg then
                  ItemColor := clRed
                else ItemColor := clSkyBlue;
                ScreenXYfromMCXY(DropItem.X, DropItem.Y, mx, my);
                MSurface.BoldTextOut(mx - 15, my - 19, ItemColor, clBlack, DropItem.Name);
              end else if g_boShowAllItem or (ShowItem = nil) then begin
                ScreenXYfromMCXY(DropItem.X, DropItem.Y, mx, my);
                MSurface.BoldTextOut(mx - 15, my - 19, clSkyBlue, clBlack, DropItem.Name);
              end;
            end;
          end;
        end;
        if m_ActorList.Count > 0 then begin//20080629
          for k:=0 to m_ActorList.Count-1 do begin  //����ÿһ�������״̬
            actor := m_ActorList[k];
            {$IF M2Version <> 2}
            //��ʾ�ƶ�HP
            II:=0;
            with actor do begin
              while TRUE do begin
                if II >=m_nMoveHpList.Count then break;
                MoveShow:=m_nMoveHpList.Items[II];
                if MoveShow.boMoveHpShow then begin
                  frmMain.Canvas.Font.Size := 11;
                  MSurface.BoldTextOut(m_nSayX + MoveShow.nMoveHpEnd, m_nSayY - MoveShow.nMoveHpEnd-30, clRed, clBlack, MoveShow.sMoveHpstr);
                  frmMain.Canvas.Font.Size := 9;
                  if (GetTickCount-MoveShow.dwMoveHpTick) > 30 then begin
                    MoveShow.dwMoveHpTick:=GetTickCount;
                    Inc(MoveShow.nMoveHpEnd);
                  end;
                  if MoveShow.nMoveHpEnd > 20 then begin
                    MoveShow.boMoveHpShow:=False;
                    m_nMoveHpList.Delete(II);
                    Dispose(MoveShow);
                  end else Inc(II);
                end;
              end;
            end;
            {$IFEND}
            //��ʾ����Ѫ��(������ʾ)
            if (actor.m_Abil.MaxHP > 1) and not actor.m_boDeath then begin
              if actor = g_HeroSelf then begin   //�ڴ�����Ӣ��������ʧ 2008.01.27
                if (abs(g_MySelf.m_nCurrX - g_HeroSelf.m_nCurrX) <= 8) and (abs(g_MySelf.m_nCurrY - g_HeroSelf.m_nCurrY) <= 7) then begin
                  InfoMsg:=Format('%d/%d',[actor.m_Abil.HP,actor.m_Abil.MaxHP]);
                  MSurface.BoldTextOut (actor.m_nSayX - FrmMain.Canvas.TextWidth(infoMsg) div 2 ,actor.m_nSayY - 22,clWhite, clBlack,infoMsg );
                end;
              end else begin
                if (actor.m_btRace <> 50) and (actor.m_btRace <> 101{������}) and (actor.m_btHair <> 158) and (abs(g_MySelf.m_nCurrX - Actor.m_nCurrX) <= 8) and (abs(g_MySelf.m_nCurrY - Actor.m_nCurrY) <= 7) then begin  //NPC��������Ѫ 20080410
                  InfoMsg:=Format('%d/%d',[actor.m_Abil.HP,actor.m_Abil.MaxHP]);
                  MSurface.BoldTextOut (actor.m_nSayX - FrmMain.Canvas.TextWidth(infoMsg) div 2 ,actor.m_nSayY - 22,clWhite, clBlack,infoMsg );
                end;
              end;
            end;

            //��ʾѪ��  
            if not actor.m_boDeath and ((abs(g_MySelf.m_nCurrX - Actor.m_nCurrX) <= 8) and (abs(g_MySelf.m_nCurrY - Actor.m_nCurrY) <= 7)) then  begin
                if (actor = g_HeroSelf) and (g_sMyHeroType = '��') then begin  //����Ӣ�۱�־
                  d := g_WMainImages.Images[1711];
                  if d <> nil then
                  MSurface.Draw (actor.m_nSayX-7, actor.m_nSayY+12, d.ClientRect, d, TRUE);
                end; 
                if (actor.m_btRace = 50) and   //ĳЩNPC ����ʾѪ�� 20080323
                      ((actor.m_wAppearance in [33..40,48..50,54..58,60..62,65..66,70..75,82..84,90..92,107..113]) or (TNpcActor(actor).g_boNpcWalk) ) then Continue;
                if actor.m_btRace = 95 then Continue; //�����ػ���
                if not(actor is THumActor) and not(actor is TNpcActor) and (actor.m_btHair = 158) then Continue; //����
                if actor.m_noInstanceOpenHealth then
                   if GetTickCount - actor.m_dwOpenHealthStart > actor.m_dwOpenHealthTime then
                      actor.m_noInstanceOpenHealth := FALSE;
                d := g_WMain3Images.Images[HEALTHBAR_BLACK];
                if d <> nil then begin
                   MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, d.ClientRect, d, TRUE);
                   //�ڹ���������
                   if actor.m_Skill69MaxNH > 0 then begin
                      MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 7, d.ClientRect, d, TRUE);
                   end;
                end;
                if actor.m_btRace in [12,24,50] then //�󵶣�������NPC
                begin
                   d := g_dMPImages;  // ��ɫѪ��
                   if d <> nil then begin // ����ط�ʱ��Ѫ�� remark by liuzhigang
                         rc := d.ClientRect;
                         if actor.m_Abil.MaxHP > 0 then
                            rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxHP * actor.m_Abil.HP);
                         MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                   end;
                end else begin
                  d := g_dHPImages;
                  if Actor.m_boMagicShield then//By TasNat at:2012-12-12 12:47:32
                  begin
                    if (d <> nil) then begin // ����ط�ʱ��Ѫ�� remark by liuzhigang
                         rc := d.ClientRect;
                         if (actor.m_Abil.MaxHP > 0) and (actor.m_Abil.MP<actor.m_Abil.MaxMP) then
                            rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxHP * actor.m_Abil.HP);
                         MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                    end;
                    d := g_dNewMPImages;
                    if d <> nil then begin // ����ط�ʱ��Ѫ�� remark by liuzhigang
                         rc := d.ClientRect;
                         if (actor.m_Abil.MaxMP > 0)  and (actor.m_Abil.MP<actor.m_Abil.MaxMP)then
                            rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxMP * actor.m_Abil.MP);
                         MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                    end;
                  end else
                  begin
                    if FrmDlg.DCheckMyHp.Checked then begin
                      if (actor = g_MySelf) or (actor = g_HeroSelf) then 
                        d := g_dMyHPImages;
                    end;
                    if d <> nil then begin // ����ط�ʱ��Ѫ�� remark by liuzhigang
                         rc := d.ClientRect;
                         if actor.m_Abil.MaxHP > 0 then
                            rc.Right := Round((rc.Right-rc.Left) / actor.m_Abil.MaxHP * actor.m_Abil.HP);
                         MSurface.Draw (actor.m_nSayX - d.Width div 2, actor.m_nSayY - 10, rc, d, TRUE);
                    end;
                  end;
                end;
                //�ڹ�����
                if actor.m_Skill69MaxNH > 0 then begin
                  d := g_dKill69Images;//g_qingqingImages.Images[9];
                  if d <> nil then begin
                    rc := d.ClientRect;
                    rc.Right := Round((rc.Right-rc.Left) / actor.m_Skill69MaxNH * actor.m_Skill69NH);
                      MSurface.Draw(actor.m_nSayX - d.Width div 2, actor.m_nSayY - 7, rc, d, False);
                  end;  
                end;
              //end;
            end;
          end;
        end;
      end;

     //�Զ���ʾ����    2007.12.18
      if g_boShowName then begin
        with PlayScene do begin
          for k := 0 to m_ActorList.Count - 1 do begin
            Actor := m_ActorList[k];
            if (Actor <> nil)  and (not Actor.m_boDeath) and
              (Actor.m_nSayX <> 0) and (Actor.m_nSayY <> 0)  and ((actor.m_btRace = 0) or (actor.m_btRace = 1) or (actor.m_btRace = 150) or (actor.m_btRace = 50) or (not(actor is THumActor) and not(actor is TNpcActor) and (actor.m_btHair = 158)){����,Ӣ��,����,����}) then begin
              if (Actor <> g_FocusCret) then begin
                if (abs(g_MySelf.m_nCurrX - actor.m_nCurrX) >= 9) or (abs(g_MySelf.m_nCurrY - actor.m_nCurrY) >= 7) then Continue;
                if (actor.m_btRace = 50) and   //ĳЩNPC ����ʾѪ�� 20080323
                      ((actor.m_wAppearance in [33..40,48..50,60..62,65..66,70..75,82..84,90..92]) or (TNpcActor(actor).g_boNpcWalk) ) then Continue;
                if (actor = g_MySelf) and g_boSelectMyself then Continue;
                if not(actor is THumActor) and not(actor is TNpcActor) and (actor.m_btHair = 158) then
                	uname := Actor.m_sDescUserName + '\' + Actor.m_sUserName
                else uname := Actor.m_sUserName;
                if not frmMain.InTargetListOfName(uname) then begin
                  NameTextOut(Actor, MSurface,
                    Actor.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                    Actor.m_nSayY + 30,
                    Actor.m_nNameColor, ClBlack,
                    uname);
                end else begin
                  NameTextOut(Actor, MSurface,
                    Actor.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                    Actor.m_nSayY + 30,
                    GetRGB(223), ClBlack,
                    uname);
                end;
              end;
            end;
          end;
        end;
      end; //with
      //�Զ���ʾ����  ����
      
      with PlayScene do begin  //��̯
        if m_ActorList.Count > 0 then begin//20080629
          for k:=0 to m_ActorList.Count-1 do begin
            actor := m_ActorList[k];
            if (actor <> nil) and (actor.m_btRace = 0) and actor.m_boIsShop and (not Actor.m_boDeath) and
              (Actor.m_nSayX <> 0) and (Actor.m_nSayY <> 0) then begin //��̯
              if (abs(g_MySelf.m_nCurrX - actor.m_nCurrX) >= 9) or (abs(g_MySelf.m_nCurrY - actor.m_nCurrY) >= 8) then Continue;
              if (actor.m_Abil.MaxHP > 1) then begin //������Ѫ
                MSurface.BoldTextOut(actor.m_nSayX - FrmMain.Canvas.TextWidth(actor.m_sShopMsg) div 2, actor.m_nSayY - 34, $004AA6EF, clBlack, actor.m_sShopMsg);
              end else begin
                MSurface.BoldTextOut(actor.m_nSayX - FrmMain.Canvas.TextWidth(actor.m_sShopMsg) div 2, actor.m_nSayY - 24, $004AA6EF, clBlack, actor.m_sShopMsg);
              end;
            end;
            //��ʾ���
            {$IF M2Version <> 2}
            if not g_boHideTitle and ((actor.m_btRace = 0) or (actor.m_btRace = 150)) then begin //������
              with THumActor(actor) do begin
                if (m_sTitleName <> '') and (m_wTitleIcon > 0) then begin
                  case m_wTitleIcon of
                    743, 744, 1265, 1275: begin
                      d := g_WUI1Images.Images[m_wTitleIcon];
                      if d<>nil then begin
                        MSurface.Draw (m_nSayX - d.Width div 2, m_nSayY - d.Height div 2 - 32, d.ClientRect, d, TRUE);
                      end;
                    end;
                    else begin
                      d := g_WUI1Images.Images[m_wTitleIcon];
                      if d<>nil then begin
                        TitleWidth := (FrmMain.Canvas.TextWidth(m_sTitleName) - d.Width) div 2;
                        MSurface.Draw (m_nSayX - d.Width -TitleWidth, m_nSayY - d.Height div 2 - 28, d.ClientRect, d, TRUE);
                        MSurface.BoldTextOut (m_nSayX - TitleWidth,m_nSayY - 34, clYellow, clBlack, m_sTitleName);
                      end;
                    end;
                  end;
                end;
              end;
            end;
            {$IFEND}
          end;
        end;
      end;
      
       //����ǰѡ�����Ʒ/���������
       if ((g_FocusCret <> nil) and PlayScene.IsValidActor (g_FocusCret)) then begin
          if (g_FocusCret.m_btRace = 50) then begin
            if not TNpcActor(g_FocusCret).g_boNpcWalk then begin
              uname := g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName;
              NameTextOut (g_FocusCret, MSurface,
                        g_FocusCret.m_nSayX,
                        g_FocusCret.m_nSayY + 30,
                        g_FocusCret.m_nNameColor, clBlack,
                        uname);
            end;
          end else begin
              uname := g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName;
              if not frmMain.InTargetListOfName(g_FocusCret.m_sUserName) then begin
                NameTextOut (g_FocusCret, MSurface,
                        g_FocusCret.m_nSayX,
                        g_FocusCret.m_nSayY + 30,
                        g_FocusCret.m_nNameColor, clBlack,
                        uname);
              end else begin
                NameTextOut (g_FocusCret, MSurface,
                        g_FocusCret.m_nSayX,
                        g_FocusCret.m_nSayY + 30,
                        GetRGB(223), clBlack,
                        uname);
              end;
          end;
       end;

       //�������
       if g_boSelectMyself then begin
          uname := g_MySelf.m_sDescUserName + '\' + g_MySelf.m_sUserName;
          NameTextOut (g_MySelf, MSurface,
                  g_MySelf.m_nSayX, // - Canvas.TextWidth(uname) div 2,
                  g_MySelf.m_nSayY + 30,
                  g_MySelf.m_nNameColor, clBlack,
                  uname);
       end;

       //��ʾ��ɫ˵������
       with PlayScene do begin
          if m_ActorList.Count > 0 then begin//20080629
            for k:=0 to m_ActorList.Count-1 do begin
              actor := m_ActorList[k];
              if (actor.m_SayingArr[0] <> '') and (GetTickCount - actor.m_dwSayTime < 4 * 1000) then begin
                 if actor.m_nSayLineCount > 0 then begin//20080629
                   for i:=0 to actor.m_nSayLineCount - 1 do //��ʾÿ�����˵�Ļ�
                      if actor.m_boDeath then begin              //���˵Ļ��ͻ�/��ɫ��ʾ
                         MSurface.BoldTextOut (actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                   actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14 - 20,
                                   clGray, clBlack,
                                   actor.m_SayingArr[i])
                      end else begin                         //����������ú�/��ɫ��ʾ
                         if actor.m_boIsShop and (actor.m_Abil.MaxHP > 1) then begin
                           MSurface.BoldTextOut (actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                   actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14 - 30,
                                   actor.m_SayColor, clBlack,
                                   actor.m_SayingArr[i]);
                         end else begin
                           MSurface.BoldTextOut (actor.m_nSayX - (actor.m_SayWidthsArr[i] div 2),
                                   actor.m_nSayY - (actor.m_nSayLineCount*16) + i*14 - 20,
                                   actor.m_SayColor, clBlack,
                                   actor.m_SayingArr[i]);
                         end;
                      end;
                 end;
              end else actor.m_SayingArr[0] := '';  //˵�Ļ���ʾ4��
            end;
          end;
       end;


       //System Message
       if (g_nAreaStateValue and $04) <> 0 then begin
          MSurface.BoldTextOut (0, 0, clWhite, clBlack, '��������');
       end;
       //Canvas.Release;  ���������� 20110912


       //��ʾ��ͼ״̬��16�֣�0000000000000000 ���ҵ���Ϊ1��ʾ��ս������ȫ�����������״̬ (��ǰֻ���⼸��״̬)
       {k := 0;
       for i:=0 to 15 do begin
          if g_nAreaStateValue and ($01 shr i) <> 0 then begin
             d := g_WMainImages.Images[AREASTATEICONBASE + i];
             if d <> nil then begin
                k := k + d.Width;
                MSurface.Draw (SCREENWIDTH-k, 0, d.ClientRect, d, TRUE);
             end;
          end;
       end; }
       k := 0;
       if g_nAreaStateValue <> 0 then begin
           d := g_WMainImages.Images[AREASTATEICONBASE + g_nAreaStateValue - 1];
           if d <> nil then begin
              k := k + d.Width;
              MSurface.Draw (SCREENWIDTH-k, 0, d.ClientRect, d, TRUE);
           end;
       end;

      DrawScreenCenterLetter(MSurface); //����Ļ�м���ʾ
      DrawScreenCountDown(MSurface); //��������������ʾ����ʱ��Ϣ
      DrawScreenTopLetter(MSurface); //����Ļ������ʾ��������
      DrawScreenBoard(MSurface);//����������ʾ
    end;
  end;
end;
//��ʾ���Ͻ���Ϣ����
procedure TDrawScreen.DrawScreenTop (MSurface: TDirectDrawSurface);
var
   i, sx, sy: integer;
begin
   if g_MySelf = nil then Exit;

   if CurrentScene = PlayScene then begin
      with MSurface do begin
         (*{$if Version = 1}
         SetBkMode (Canvas.Handle, TRANSPARENT);
         {$IFEND}*)
         if m_SysMsgList.Count > 0 then begin
            sx := 30;
            sy := 40;
            for i:=0 to m_SysMsgList.Count-1 do begin
               MSurface.BoldTextOut (sx, sy, clGreen, clBlack, m_SysMsgList[i]);
               inc (sy, 16);
            end;
            //3�����һ��ϵͳ��Ϣ
            if GetTickCount - longword(m_SysMsgList.Objects[0]) >= 3000 then
               m_SysMsgList.Delete (0);
         end;
         //Canvas.Release;
         (*{$if Version = 1}
         SetBkMode (Canvas.Handle, TRANSPARENT);
         {$IFEND}*)
         if m_SysMsgListBottom.Count > 0 then begin
            sx := 15;
            sy := 376;
            for i:=0 to m_SysMsgListBottom.Count-1 do begin
               MSurface.BoldTextOut (sx, sy, PBottomSysStyle(m_SysMsgListBottom.Objects[0]).FColor, clBlack, m_SysMsgListBottom[i]);
               Dec (sy, 16);
            end;
            //3�����һ��ϵͳ��Ϣ
            if GetTickCount - PBottomSysStyle(m_SysMsgListBottom.Objects[0]).Createtime >= 3000 then
               m_SysMsgListBottom.Delete (0);
         end;
         //������Ϣ
         if m_SysMsgListRightBottom.Count > 0 then begin
           sx := 780;
           sy := 320;
           for I:=0 to m_SysMsgListRightBottom.Count - 1 do begin
             MSurface.BoldTextOut(sx-FrmMain.Canvas.TextWidth(m_SysMsgListRightBottom[i]), sy, PRightBottomSysStyle(m_SysMsgListRightBottom.Objects[0]).FColor, PRightBottomSysStyle(m_SysMsgListRightBottom.Objects[0]).BColor, m_SysMsgListRightBottom[i]);
             Dec(sy, 16);
           end;
           if GetTickCount - PRightBottomSysStyle(m_SysMsgListRightBottom.Objects[0]).CreateTime >= PRightBottomSysStyle(m_SysMsgListRightBottom.Objects[0]).ShowTime * 1000 then
             m_SysMsgListRightBottom.Delete(0);
         end;
         //Canvas.Release;
      end;
   end;
end;

function _Copy(str:String;Index,COunt:Integer):String;
var
  s:WideString;
Begin
  s:=WideString(str);
  Result:=Copy(s,index,count);
End;
(*******************************************************************************
  ���� :  �������Ļ�м���ʾ������Ϣ
  ���� :  AddCenterLetter(ForeGroundColor,BackGroundColor,Timer:Integer; CenterLetter:string; boTop: Boolean);
  ���� :  ForeGroundColorǰ��ɫ;BackGroundColor����ɫ;CenterLetter��ʾ����;boTop�Ƿ��Ƕ�������
*******************************************************************************)
procedure TDrawScreen.AddCenterLetter(ForeGroundColor,BackGroundColor,Timer:Integer; CenterLetter:string);
begin
  m_boCenTerLetter := True;
  m_SCenterLetter := CenterLetter;
  m_CenterLetterForeGroundColor := ForeGroundColor;
  m_CenterLetterBackGroundColor := BackGroundColor;
  m_dwCenterLetterTimeTick := GetTickCount;
  m_nCenterLetterTimer := Timer;
end;
(*******************************************************************************
  ���� :  ����Ļ�м���ʾ������Ϣ
  ���� :  DrawScreenCenterLetter(MSurface: TDirectDrawSurface)
  ���� :  MSurface Ϊ����
*******************************************************************************)
procedure TDrawScreen.DrawScreenCenterLetter(MSurface: TDirectDrawSurface);
var
    nTextWidth, nTextHeight: Integer;
begin
  if m_boCenTerLetter then begin
    if CurrentScene = PlayScene then begin//���Ϊ��Ϸ����ҳ
      with MSurface.Canvas do begin
          frmMain.Canvas.Font.Size := 18;
          nTextWidth := frmMain.Canvas.TextExtent(m_SCenterLetter).cx;
          nTextHeight := frmMain.Canvas.TextExtent(m_SCenterLetter).cy;
          frmMain.Canvas.Font.Style:=[fsBold];
          MSurface.BoldTextOut (SCREENWIDTH Div 2 - nTextWidth div 2,
                                SCREENHEIGHT Div 2 - 100 - nTextHeight div 2,
                                GetRGB(m_CenterLetterForeGroundColor), GetRGB(m_CenterLetterBackGroundColor), m_SCenterLetter);
          frmMain.Canvas.Font.Style:=[];
          frmMain.Canvas.Font.Size := 9;
      end;
    end;
  end;
  if GetTickCount - m_dwCenterLetterTimeTick > m_nCenterLetterTimer*1000 then begin
    m_dwCenterLetterTimeTick := GetTickCount;
    m_boCenTerLetter := False;
  end;
end;

//����� ������Ϣ
procedure TDrawScreen.DrawScreenBoard(MSurface: TDirectDrawSurface);
var
  sx,xpos: Integer;
  Boardstyle:PBoardStyle;
  Str:String;
  Len:Integer;
begin
  if (g_MySelf = nil) or (m_SysBoard.Count = 0) then Exit;
  if CurrentScene = PlayScene then begin//���Ϊ��Ϸ����ҳ
    with MSurface do begin
      SetBkMode(Canvas.handle, TRANSPARENT);
      if m_SysBoard.Count > 0 then begin //�������Ƶ��б�Ϊ0
        xpos:=1;
        if m_SysBoardIndex>=m_SysBoard.Count then begin
           m_SysBoardIndex:=0;
          m_SysBoard.Clear;
        end;
        if m_SysBoard.Count > 0 then begin //20080802
          if PBoardStyle(m_SysBoard.Objects[m_SysBoardIndex]) <> nil then begin
            Boardstyle:=PBoardStyle(m_SysBoard.Objects[m_SysBoardIndex]);
            Len:=(804-m_SysBoardXPos) div Canvas.TextWidth('a')+1;   //����
            if m_SysBoardXPos<=-600 then begin
              Xpos:=(-600-m_sysBoardXpos) div Canvas.TextWidth('a')+1;
              Len:=Len-Xpos-1;
            end;
            Str:=m_SysBoard[m_SysBoardIndex];
            Str:=_Copy(Str,Xpos,len);
            if (Str='') or (Xpos > Length(m_SysBoard[m_SysBoardIndex])) then begin
              m_SysBoardXPos:=800;
              Inc(m_SysBoardIndex);
            end;
            sx := Max(-600,m_SysBoardXPos+1);
            BoldTextOut1(MSurface,sx,15,GetRGB(Boardstyle.FColor),GetRGB(Boardstyle.BColor),str);
            if GetTickCount-m_SysBoardTime>100 then begin
               Dec(m_SysBoardXPos,2);
               m_SysBoardTime:=GetTickCount;
            end;
            //Canvas.Release; ���������� 20110912
          end;
        end;
      end;
      Canvas.Release; //���������� 20110912
    end;
  end;
end;

//��ʾ��ʾ��Ϣ
procedure TDrawScreen.DrawHint (MSurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   i, hx, hy: integer;
begin
  //��ʾ��ʾ��
   hx:=0;
   hy:=0;//Jacky
   if HintList.Count > 0 then begin
     d := g_WMainImages.Images[394];
     if d <> nil then begin
       if HintWidth > d.Width then HintWidth := d.Width;
       if HintHeight > d.Height then HintHeight := d.Height;
       if HintX + HintWidth > SCREENWIDTH then hx := SCREENWIDTH - HintWidth
       else hx := HintX;
       if HintY < 0 then hy := 0
       else hy := HintY;
       if hx < 0 then hx := 0;
       //DrawBlendEx(MSurface, hx, hy, d, 0, 0, HintWidth, HintHeight, 0, 170);
       MSurface.FastDrawAlpha(Bounds(hx, hy,HintWidth, HintHeight ),Rect(0,0,HintWidth, HintHeight),d);
     end;
   end;
   //����ʾ������ʾ��ʾ��Ϣ
   with MSurface do begin
      if HintList.Count > 0 then begin
         for i:=0 to HintList.Count-1 do begin
            MSurface.TextOut(hx+5, hy+4+(FrmMain.Canvas.TextHeight('A')+1)*i, HintColor, HintList[i]);
         end;
      end;
   end;
end;

(*******************************************************************************
  ���� :  ��������������ʾ����ʱ������Ϣ
  ���� :  DrawScreenCountDown(MSurface: TDirectDrawSurface)
  ���� :  MSurface Ϊ����
*******************************************************************************)
procedure TDrawScreen.DrawScreenCountDown(MSurface: TDirectDrawSurface);
var
  line1,Str: string;
begin
  if CurrentScene = PlayScene then begin//���Ϊ��Ϸ����ҳ
    if m_boCountDown then begin
      if m_dwCountDownTimer >= 60 then begin
        line1 := Inttostr(m_dwCountDownTimer div 60)+'��'+IntToStr(m_dwCountDownTimer mod 60)+'��';
      end else begin
        line1 := IntToStr(m_dwCountDownTimer mod 60)+'��';
      end;
      Str := Format(m_SCountDown,[line1]);
      with MSurface.Canvas do begin
          MSurface.BoldTextOut (SCREENWIDTH Div 2 - FrmMain.Canvas.TextWidth(Str) div 2,
                                 SCREENHEIGHT - 210 - FrmMain.Canvas.TextHeight(Str) div 2,
                                 GetRGB(m_CountDownForeGroundColor), clBlack, Str);
      end;
    end;
    if m_boHeroCountDown then begin
      if m_dwHeroCountDownTimer >= 60 then begin
        line1 := Inttostr(m_dwHeroCountDownTimer div 60)+'��'+IntToStr(m_dwHeroCountDownTimer mod 60)+'��';
      end else begin
        line1 := IntToStr(m_dwHeroCountDownTimer mod 60)+'��';
      end;
      Str := Format(m_SHeroCountDown,[line1]);
      with MSurface.Canvas do begin
        if not m_boCountDown then begin //����ʱû��ʾ
          MSurface.BoldTextOut (SCREENWIDTH Div 2 - FrmMain.Canvas.TextWidth(Str) div 2,
                                 SCREENHEIGHT - 210 - FrmMain.Canvas.TextHeight(Str) div 2,
                                 GetRGB(m_HeroCountDownForeGroundColor), clBlack, Str);
        end else begin
          MSurface.BoldTextOut (SCREENWIDTH Div 2 - FrmMain.Canvas.TextWidth(Str) div 2,
                                 SCREENHEIGHT - 210 - FrmMain.Canvas.TextHeight(Str) div 2 - 14,
                                 GetRGB(m_HeroCountDownForeGroundColor), clBlack, Str);
        end;
      end;
    end;
  end;
end;
//�������Ļ�м���ʾ������Ϣ
procedure TDrawScreen.AddCountDown(ForeGroundColor: Integer;
  Timer: LongWord; CountDown: string);
begin
  m_boCountDown := True;
  m_SCountDown := CountDown;
  m_CountDownForeGroundColor := ForeGroundColor;
  m_dwCountDownTimeTick := GetTickCount;
  m_dwCountDownTimeTick1 := GetTickCount;
  m_dwCountDownTimer := Timer;
  frmMain.CountDownTimer.Enabled := True;
end;
//�������Ļ�м���ʾӢ�۸���������Ϣ
procedure TDrawScreen.AddHeroCountDown(ForeGroundColor: Integer;
  Timer: LongWord; CountDown: string);
begin
  m_boHeroCountDown := True;
  m_SHeroCountDown := CountDown;
  m_HeroCountDownForeGroundColor := ForeGroundColor;
  m_dwHeroCountDownTimeTick := GetTickCount;
  m_dwHeroCountDownTimeTick1 := GetTickCount;
  m_dwHeroCountDownTimer := Timer;
  frmMain.CountDownTimer.Enabled := True;
end;

procedure TDrawScreen.AddRightBottomMsg(fcolor, bcolor: Integer; dWTime:LongWord; msg: string);  //������Ϣ
var
  RightBottomSysStyle: PRightBottomSysStyle;
begin
  if m_SysMsgListRightBottom.Count >= 10 then m_SysMsgListRightBottom.Delete (0);
  New(RightBottomSysStyle);
  RightBottomSysStyle^.Createtime := GetTickCount;
  RightBottomSysStyle^.ShowTime := dWTime;
  RightBottomSysStyle^.FColor := fcolor;
  RightBottomSysStyle^.BColor := bcolor;
  m_SysMsgListRightBottom.AddObject(msg, TObject(RightBottomSysStyle));
end;

procedure TDrawScreen.DrawTzHint(MSurface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   i, j, hx, hy: integer;
   sParam,fdata: string;
   sCmd: Char;
begin
  //��ʾ��ʾ��
   hx:=0;
   hy:=0;//Jacky
   if TzHintList.Count > 0 then begin
     d := g_WMainImages.Images[403];
     if d <> nil then begin
       if HintWidth > d.Width then HintWidth := d.Width;
       if HintHeight > d.Height then HintHeight := d.Height;
       if HintDec then begin
         if HintX + HintWidth > SCREENWIDTH then hx := SCREENWIDTH - HintWidth
         else hx := HintX;
       end else hx := HintX;
       if HintY < 0 then hy := 0
       else hy := HintY;
       if hx < 0 then hx := 0;
       MSurface.FastDrawAlpha(Bounds(hx, hy,HintWidth, HintHeight ),Rect(0,0,HintWidth, HintHeight),d);
     end;
   end;
   //����ʾ������ʾ��ʾ��Ϣ
   with MSurface do begin
      if TzHintList.Count > 0 then begin
         for i:=0 to TzHintList.Count-1 do begin
            if (TzHintList[i][1] = '*') and (TzHintList[i][2] in ['1'..'5']) then begin
              for j:=1 to StrToInt(TzHintList[i][2]) do begin
                d := g_WUI1Images.Images[1345];
                if d <> nil then begin
                  MSurface.Draw(hx + 4 + (j-1) * (d.Width+3), hy+5+(FrmMain.Canvas.TextHeight('A')+1)*i, d.ClientRect, d, True);
                end;
              end;
            end else if (pos('~', TzHintList[i]) > 0) then begin
              fdata := TzHintList[i];
              sParam := GetValidStr3 (fdata, fdata, ['~']);
              if (sParam <> '') and (fdata <> '')then begin
                sParam := Uppercase(sParam);
                sCmd := sParam[1];
                case sCmd of
                  'A': begin
                    frmMain.Canvas.Font.Size := 12;
                    MSurface.BoldTextOut (hx+4, hy+2+(FrmMain.Canvas.TextHeight('A'))*i, $000075EA, clBlack, fdata);
                    frmMain.Canvas.Font.Size := 9;
                  end;
                  'L': begin //��ɫ
                    MSurface.BoldTextOut (hx+4, hy+2+(FrmMain.Canvas.TextHeight('A'))*i, clLime, clBlack, fdata);
                  end;
                  'C': begin
                    frmMain.Canvas.Font.Size := 10;
                    MSurface.BoldTextOut (hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clYellow, clBlack, fdata);
                    frmMain.Canvas.Font.Size := 9;
                  end;
                  'D': begin
                    MSurface.BoldTextOut (hx+4, hy+2+(FrmMain.Canvas.TextHeight('A')+1)*i, clYellow, clBlack, fdata);
                  end;
                  'R': MSurface.TextOut(hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clRed, fdata);
                  'H': MSurface.TextOut(hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clLime, fdata);
                  'Y': MSurface.TextOut(hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clYellow, fdata);
                  'W': MSurface.BoldTextOut (hx+4, hy+2+(FrmMain.Canvas.TextHeight('A')+1)*i, clWhite, clBlack, fdata);
                end;
                if sParam = 'R' then
                if sParam = 'Y' then
               // if sParam = 'W' then clFunc.TextOut(MSurface, hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clYellow, fdata);
              end;
            end else MSurface.TextOut(hx+4, hy+3+(FrmMain.Canvas.TextHeight('A')+1)*i, clWhite, TzHintList[i]);
         end;
      end;
   end;
end;

procedure TDrawScreen.ShowTzHint (x, y: integer; str: string; drawup, HintDec: Boolean;{�Ƿ�ɾ��������Ļ���} nWidth: Byte{�¼ӿ��});
var
   data: string;
   w: integer;
begin
   ClearHint;
   HintX := x;
   HintY := y;
   HintWidth := 0;
   HintHeight := 0;
   HintUp := drawup;
   //HintDec := HintDec;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, data, ['\']);
      if data <> '' then begin
        if data[1] <> '~' then begin
          if (data[1] = '*') and (data[2] in ['1'..'5']) then begin
            w := (14)*StrToInt(data[2]) + 8;
          end else w := FrmMain.Canvas.TextWidth (data) + 8;
          if w > HintWidth then HintWidth := w+nWidth;
          TzHintList.Add (data);
        end;
      end;
   end;
   HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * TzHintList.Count + 6;
   if HintUp then
      HintY := HintY - HintHeight;
end;

procedure TDrawScreen.DrawSpecialHint(MSurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, j, hx, hy, hW, hH: integer;
  data, fdata, cmdstr, cmdparam, cmdColor, cmdFontStyle, cmdFontSize: string;
  sStr, sStr1, sStr2:string;
  FColor: TColor;
  sx: integer;
  strList: TStringList;
  fontsize,oldfontsize: Byte;
begin
  //��ʾ��ʾ��
  if SpecialHintList.Count > 0 then begin
    hx:=0;
    hy:=0;//Jacky
    hW:=0;
    hH:=0;
    d := g_WMainImages.Images[403];
    if d <> nil then begin
      if HintWidth > d.Width then hW := d.Width else hW := HintWidth;
      if HintHeight > d.Height then hH := d.Height else hH := HintHeight;
      if HintX + hW > SCREENWIDTH then hx := SCREENWIDTH - hW else hx := HintX;
      if HintY < 0 then hy := 0 else hy := HintY;
      if hx < 0 then hx := 0;
      MSurface.FastDrawAlpha(Bounds(hx, hy,hW, hH ),Rect(0,0,hW, hH),d);
    end;
    //����ʾ������ʾ��ʾ��Ϣ
    for i:=0 to SpecialHintList.Count-1 do begin
      data := SpecialHintList[i];
      if data <> '' then begin
        if (data[1] = '*') and (data[2] in ['1'..'5']) then begin
          for j:=1 to StrToInt(data[2]) do begin
            d := g_WUI1Images.Images[1345];
            if d <> nil then begin
              MSurface.Draw(hx + 4 + (j-1) * (d.Width+3), hy+5+({FrmMain.Canvas.TextHeight('A')}12+1)*i, d.ClientRect, d, True);
            end;
          end;          
        end else begin
          strList := TStringList.Create;
          try
            strList.Add('Yellow');
            strList.Add('Lime');
            strList.Add('Red'); 
            cmdstr := '';
            fdata := '';
            sx := 0;
            while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do begin
              if data[1] <> '<' then begin
                data := '<' + GetValidStr3 (data, fdata, ['<']); //ȡ<ǰ�Ĳ���   data��ȡ������Ĳ���
              end;
              FColor := clWhite;
              fontsize := 9;
              cmdColor := '';
              cmdFontStyle := '';
              cmdFontSize := '';
              data := ArrestStringEx (data, '<', '>', cmdstr);//�õ�"<"��">" ��֮�����   ����� cmdstr
              if (cmdstr <> '') and (cmdstr[1] <> '/') then begin  //20100829
                cmdparam := GetValidStrFinal(cmdstr, cmdstr, ['/']);    // cmdstrΪ��ʾ������ �õ���ʾ����
                sStr:= cmdparam+' ';  //�ַ�����ʽΪ XXX XXX XXX    �����Զ�����ո�
                if (sStr <> '') and (Pos('fontstyle',sStr) > 0) then begin
                  cmdparam := Copy(sStr, Pos('fontstyle',sStr)+10, Length(sStr));
                  cmdparam := Copy(cmdparam, 1, Pos(' ',cmdparam)-1);
                  cmdFontStyle := Trim(cmdparam);   //�õ�������
                  sStr1:= Copy(sStr, 1,Pos('fontstyle',sStr)-1);//ǰ
                  sStr2:= Copy(sStr, Pos(cmdparam,sStr)+length(cmdparam)-1, Length(sStr));//��
                  sStr:= sStr1+sStr2;
                end;
                if (sStr <> '') and (Pos('c',sStr) > 0) then begin
                  cmdparam := Copy(sStr, Pos('c',sStr)+2, Length(sStr));
                  cmdparam := Copy(cmdparam, 1, Pos(' ',cmdparam)-1);
                  cmdColor := Trim(cmdparam);   //�õ�������ɫ
                  sStr1:= Copy(sStr, 1,Pos('c',sStr)-1);//ǰ
                  sStr2:= Copy(sStr, Pos(cmdparam,sStr)+length(cmdparam)-1, Length(sStr));//��
                  sStr:= sStr1+sStr2;
                end;
                if (sStr <> '') and (Pos('fontsize',sStr) > 0) then begin
                  cmdparam := Copy(sStr, Pos('fontsize',sStr)+9, Length(sStr));
                  cmdparam := Copy(cmdparam, 1, Pos(' ',cmdparam)-1);
                  cmdFontSize := Trim(cmdparam);         //�õ������С
                  sStr1:= Copy(sStr, 1,Pos('fontsize',sStr)-1);//ǰ
                  sStr2:= Copy(sStr, Pos(cmdparam,sStr)+length(cmdparam)-1, Length(sStr));//��
                  sStr:= sStr1+sStr2;
                end;
                if cmdColor <> '' then begin
                  case strList.IndexOf(cmdColor) of
                    0: FColor := clYellow;
                    1: FColor := clLime;
                    2: Fcolor := clRed;
                    else begin
                      try
                        FColor := StringToColor(cmdColor);
                      except
                        FColor := clWhite;
                      end;
                    end;
                  end;
                end;
                if cmdFontSize <> '' then begin
                  fontsize := Str_ToInt(cmdFontSize, 9);
                end;
                if fdata <> '' then begin
                  MSurface.TextOut (hx+5+sx, hy+4+({FrmMain.Canvas.TextHeight('A')}12+1)*i, clWhite, fdata);
                  sx := sx + frmMain.Canvas.TextWidth(fdata);
                end;
                oldfontsize := frmMain.Canvas.Font.Size;
                frmMain.Canvas.Font.Size := fontsize;
                if cmdstr <> ''  then begin
                  if cmdFontStyle = 'bold' then begin
                    MSurface.BoldTextOut (hx+5+sx, hy+4+({FrmMain.Canvas.TextHeight('A')}12+1)*i, FColor, clBlack, cmdstr);
                  end else begin
                    MSurface.TextOut (hx+5+sx, hy+4+({FrmMain.Canvas.TextHeight('A')}12+1)*i, FColor, cmdstr);
                  end;
                  sx := sx + frmMain.Canvas.TextWidth(cmdstr);
                  frmMain.Canvas.Font.Size := oldfontsize;
                end;
              end;
            end;
            if data <> '' then MSurface.TextOut (hx+5+sx, hy+4+({FrmMain.Canvas.TextHeight('A')}12+1)*i, clWhite, data);
          finally
            strList.Free;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDrawScreen.ShowSpecialHint(x, y: integer; str: string;
  drawup: Boolean);
  {$REGION '��ȡDrawHintһ�����ֵĿ��'}
  function GetHintSize(sText: string): Integer;
  var
    data, cmdstr, fdata: string;
  begin
    data := sText;
    Result := 0;
    while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do begin
      if data[1] <> '<' then begin
        data := '<' + GetValidStr3 (data, fdata, ['<']); //ȡ<ǰ�Ĳ���   data��ȡ������Ĳ���
      end;
      data := ArrestStringEx (data, '<', '>', cmdstr);//�õ�"<"��">" ��֮�����   ����� cmdstr
      if (cmdstr = '') or (cmdstr[1] = '/') then Continue;
      GetValidStrFinal(cmdstr, cmdstr, ['/']);    // cmdstrΪ��ʾ������ �õ���ʾ����
      Result := Result + FrmMain.Canvas.TextWidth(fdata+cmdstr);
    end;
    if data <> '' then Result := Result + FrmMain.Canvas.TextWidth(data);
  end;
  {$ENDREGION}
var
  data: string;
  w: integer;
begin
  ClearHint;
  HintX := x;
  HintY := y;
  HintWidth := 0;
  HintHeight := 0;
  HintUp := drawup;
  //HintColor := color;
  while TRUE do begin
    if str = '' then break;
    str := GetValidStr3 (str, data, ['\']);
    if data = '' then Continue;
    if (data[1] = '*') and (data[2] in ['1'..'5']) then begin
      w := (11+3)*StrToInt(data[2]) + 8;
    end else w := GetHintSize (data) + 8;
    if w > HintWidth then HintWidth := w;
    if (data <> '') and (GetHintSize (data) > 0) then SpecialHintList.Add (data)
  end;
  HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) * SpecialHintList.Count + 6;
  if HintUp then HintY := HintY - HintHeight;
end;

procedure TDrawScreen.Draw3km2Help(MSurface: TDirectDrawSurface);
{var
  d: TDirectDrawSurface;    }
begin
 { if g_MySelf = nil then Exit;
  if CurrentScene = PlayScene then begin
    with MSurface do begin
      d := g_WUI1Images.Images[500];
      if d <> nil then
      MSurface.FastDrawAlpha(Bounds(0, 0, d.Width, d.Height), d.ClientRect, d, True);
      d := g_WUI1Images.Images[502];
      if d <> nil then
        MSurface.Draw (0, 0, d.ClientRect, d, TRUE);
    end;
  end;  }
end;

function TDrawScreen.GetShowItemName(DropItem: pTDropItem): Pointer;
var
  ShowItem: pTShowItem1;
begin
  Result := nil;
  ShowItem := g_ShowItemList.Find(DropItem.Name);
  if (ShowItem <> nil){ and ShowItem.boShowName }then begin
    Result := ShowItem;
  end;
end;

procedure TDrawScreen.DrawScreenTopLetter(MSurface: TDirectDrawSurface);
var
  MoveShow: pTMoveTopStrShow;
  I: Integer;
begin
  I := 0;
  while TRUE do begin
    if I >=m_MoveTopStrList.Count then break;
    if I > 0 then break;
    MoveShow:=m_MoveTopStrList.Items[I];
    if MoveShow.boMoveStrShow then begin
      MainForm.Canvas.Font.Size := 17;
      MainForm.Canvas.Font.Style := [fsBold];
      MSurface.BoldTextOut(200, 66 - MoveShow.nMoveStrEnd*3, GetRGB(MoveShow.btFColor), GetRGB(MoveShow.btBColor), MoveShow.sMovestr, MoveShow.btMoveAlpha * 25);
      MainForm.Canvas.Font.Style := [];
      MainForm.Canvas.Font.Size := 9;
      if MoveShow.nMoveStrEnd = 10 then begin
        if (GetTickCount-MoveShow.dwMoveStrTick) > 1000 then begin
          MoveShow.dwMoveStrTick:=GetTickCount;
          Inc(MoveShow.btMoveNil);
          if MoveShow.btMoveNil = 2 then begin
            Inc(I);
            Continue;//����
          end;
          Inc(MoveShow.nMoveStrEnd);
        end;
      end else begin
        if (GetTickCount-MoveShow.dwMoveStrTick) > 120 then begin
          MoveShow.dwMoveStrTick:=GetTickCount;
          Inc(MoveShow.nMoveStrEnd);
          if MoveShow.nMoveStrEnd > 10 then begin
            Dec(MoveShow.btMoveAlpha);
          end else Inc(MoveShow.btMoveAlpha);
        end;
      end;
      if MoveShow.nMoveStrEnd > 21 then begin
        MoveShow.boMoveStrShow:=False;
        m_MoveTopStrList.Delete(I);
        Dispose(MoveShow);
      end else Inc(I);
    end;
  end;   
end;

procedure TDrawScreen.AddTopLetter(ForeGroundColor,BackGroundColor:Byte; CenterLetter:string);
var
  MoveShow: pTMoveTopStrShow;
Begin
  try
    New(MoveShow);
    MoveShow.sMovestr := CenterLetter;
    MoveShow.boMoveStrShow := True;
    MoveShow.btFColor := ForeGroundColor;
    MoveShow.btBColor := BackGroundColor;
    MoveShow.nMoveStrEnd := 0;
    MoveShow.btMoveAlpha := 0;
    MoveShow.btMoveNil := 0;
    m_MoveTopStrList.Add(MoveShow);
  except
    DebugOutStr('[Exception] TDrawScreen.AddTopLetter'); //�����Զ�����
  end;
end;

end.
