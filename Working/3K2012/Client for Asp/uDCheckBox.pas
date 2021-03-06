unit uDCheckBox;
interface
uses Classes, DWinCtl, Graphics, AbstractCanvas, AbstractTextures, AsphyreTextureFonts,WIL, Math, Controls;
type
  TDCheckBox = class(TDControl)
  private
    FUpColor: TColor;
    FHotColor: TColor;
    FDownColor: TColor;
    FAlignment: TAlignment;
    FChecked: Boolean;
    procedure SetAlignment(Value: TAlignment);
  protected
    procedure CaptionChaged; override;
  public
    Downed: Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure SetImgIndex (Lib: TWMImages; index: integer); override;
    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    function  InRange (x, y: integer): Boolean; override;
    procedure Process; override;
    function  MouseMove (Shift: TShiftState; X, Y: Integer): Boolean; override;
    function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function  Click (X, Y: integer): Boolean; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Checked: Boolean read FChecked write FChecked;
    property UpColor: TColor read FUpColor write FUpColor;
    property HotColor: TColor read FHotColor write FHotColor;
    property DownColor: TColor read FDownColor write FDownColor;
  end;
procedure Register;
implementation

procedure Register;
begin
  RegisterComponents('MirGame', [TDCheckBox]);
end;

{ TDCheckBox }

procedure TDCheckBox.CaptionChaged;
begin
  if Assigned(AspTextureFont) then begin
    GWidth := Max(GWidth, GWidth + AspTextureFont.TextWidth(Caption));
    GHeight := Max(GHeight, GHeight + AspTextureFont.TextHeight('0'));
  end;
end;

function TDCheckBox.Click(X, Y: integer): Boolean;
begin
  Result := False;
end;

constructor TDCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //ButtonStyle := bsCheckBox;
  EnableFocus := False;
  FUpColor := clSilver;
  FHotColor := clWhite;
  FDownColor := clWhite;
  FAlignment := taRightJustify;
  Downed := False;
end;

procedure TDCheckBox.DirectPaint(dsurface: TAsphyreCanvas);
var
  I: Integer;
  d: TAsphyreLockableTexture;
  X: Integer;
begin
  d := nil;
  if Assigned(OnDirectPaint) then
    OnDirectPaint(Self, dsurface);

  X := SurfaceX(GLeft);
  if (WLib <> nil) and (Caption <> '') then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      GWidth := d.Width + AspTextureFont.TextWidth(Caption);
      case FAlignment of
        taLeftJustify: ;
        taRightJustify: X := X + d.Width;
      end;
    end;
    if Caption <> '' then X := X+2;
  end;

//  dsurface.TextOut(X, SurfaceY(GTop) + (GHeight - MainForm.Canvas.TextHeight('0')+1) div 2, Font.Color, Caption);
  AspTextureFont.BoldTextOut(X, SurfaceY(GTop) + (GHeight - AspTextureFont.TextHeight('0')) div 2, Caption, Font.Color, clBlack);

  for I := 0 to DControls.Count - 1 do
    if TDControl(DControls[I]).Visible then
      TDControl(DControls[I]).DirectPaint(dsurface);
end;

function TDCheckBox.InRange(x, y: integer): Boolean;
var
  boInrange: Boolean;
  nWidth: Integer;
begin
  if Caption <> '' then nWidth := GWidth + 2 else nWidth := GWidth;
  if (X >= GLeft) and (X < GLeft + nWidth) and (Y >= GTop) and (Y < GTop + GHeight) then begin
    boInrange := True;
    if Assigned(OnInRealArea) then
      OnInRealArea(Self, X - GLeft, Y - GTop, boInrange);
    Result := boInrange;
  end else
    Result := False;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown (Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl=nil) then begin
      if mbLeft = Button then begin
        Downed := TRUE;
        SetDCapture (self);
      end;
    end;
    Result := TRUE;
  end;
end;

function TDCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove (Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove (Shift, X, Y);
    if MouseCaptureControl = self then begin
      if InRange (X, Y) then begin
        Downed := TRUE;
      end else Downed := FALSE;
    end;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if Enabled then begin
        if InRange(X, Y) then begin
          if mbLeft = Button then begin
            FChecked := not FChecked;
            if Assigned(OnClick) then OnClick(self, X, Y);
          end;
        end;
      end;
    end;
    Downed := FALSE;
    Result := TRUE;
    exit;
  end else begin
    ReleaseDCapture;
    Downed := FALSE;
  end;      
end;

procedure TDCheckBox.Process;
begin
  if Assigned(OnProcess) then OnProcess(Self);
  Font.Color := FUpColor;

  if Enabled then begin
    //if MouseDownControl = Self then Font.Color := FDownColor;
    if Downed then Font.Color := FDownColor;
    if MouseMoveControl = Self then Font.Color := FHotColor;
  end;
end;

procedure TDCheckBox.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
  end;
end;

procedure TDCheckBox.SetImgIndex (Lib: TWMImages; index: integer);
var
  d: TAsphyreLockableTexture;
begin
  if Lib <> nil then begin
    d := Lib.Images[Index];
    WLib := Lib;
    FaceIndex := Index;
    if d <> nil then begin
      if Assigned(AspTextureFont) then
        GWidth := d.Width + AspTextureFont.TextWidth(Caption)
      else GWidth := d.Width;
      GHeight := d.Height;
    end;
  end;
end;

end.
