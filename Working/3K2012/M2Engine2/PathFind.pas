(******************************************************************************
  ����TLegendMap(λ��PathFind.pas)���÷�
  1��FLegendMap:=TLegendMap.Create;
     FLegendMap.LoadMap('mapfile')
        --�ɹ����غ����ɵ�ͼ����FLegendMap.MapData[i, j]:TMapData
     FLegendMap.SetStartPos(StartX, StartY,PathSpace)
     Path:=FLegendMap.FindPath(StopX, StopY)
  2��FLegendMap:=TLegendMap.Create;
     FLegendMap.LoadMap('mapfile')
     Path:=FLegendMap.FindPath(StartX,StartY,StopX, StopY,PathSpace)

     ����
     PathΪTPath = array of TPoint Ϊnilʱ��ʾ���ܵ���
     ��һ��ֵΪ��㣬���һ��ֵΪ�յ�
     High(Path)��·����Ҫ�Ĳ���

     PathSpaceΪ�뿪�ϰ�����ٸ�����
******************************************************************************)

(*****************************************************************************
  ����TPathMap���ص�
  1������Ҫ���ݵ�ͼ���ݣ���ʡ�ڴ��Ƶ������
  2�����Զ�����ۺ����������Լ���Ҫ������ͬ·��

  ����TPathMap���÷�
  1��������ۺ���MovingCost(X, Y, Direction: Integer)
     ֻ������Զ���ĵ�ͼ��ʽ��д)
  2��FPathMap:=TPathMap.Create;
     FPathMap.MakePathMap(MapHeader.width, MapHeader.height, StartX, StartY,MovingCost);
     Path:=FPathMap.FindPathOnMap( EndX, EndY)
     ����PathΪTPath = array of TPoint;

  �����ϲ����TPathMap�ⲿ������ۺ������ɼ̳�TPathMap��
  ����ͼ���ݵĶ�ȡ�͹��ۺ�����װ��һ����ʹ�á�
*******************************************************************************)
unit PathFind;

interface

uses
  Windows, Classes, SysUtils, Graphics, Math, Envir;

type
 {  //��ͼԪ�ط���
  TTerrainTypes = (ttNormal, ttSand, ttForest, ttRoad, ttObstacle, ttPath);
  TTerrainParam = record
    CellColor: TColor;
    CellLabel: string[16];
    MoveCost: Integer;
  end;}

  TPath = array of TPoint; //·������

  TPathMapCell = record //·��ͼԪ
    Distance: Integer; //�����ľ���
    Direction: Integer;
  end;
  TPathMapArray = array of array of TPathMapCell; // ·��ͼ�洢����

 { TCellParams = record
    TerrainType: TTerrainTypes;
    OnPath: Boolean;
  end;
  TMapData = array of array of TCellParams; //��ͼ�洢����(�㷨��ʶ���ʽ) }

  //TGetCostFunc = procedure(Sender: Tobject; X, Y, Direction: Integer; var Result: Integer) of object;
  TGetCostFunc = function(X, Y, Direction: Integer; PathWidth: Integer = 0): Integer;//20091231 �޸�

  TPathMap = class //Ѱ·��
  public
    PathMapArray: TPathMapArray;
    Height: Integer;//��ͼ��(X���ֵ)
    Width: Integer;//��ͼ��(Y���ֵ)
    GetCostFunc: TGetCostFunc;
    ClientRect: TRect;
    ScopeValue: Integer; //Ѱ�ҷ�Χ
    StartFind: Boolean;//��ʼѰ·
    constructor Create;
    procedure GetClientRect(X, Y: Integer); overload;
    procedure GetClientRect(X1, Y1, X2, Y2: Integer); overload;
    function FindPathOnMap(X, Y: Integer; Run: Boolean): TPath;
    function WalkToRun(Path: TPath): TPath; //��WALK�ϲ���RUN
    function MapX(X: Integer): Integer;
    function MapY(Y: Integer): Integer;
    function LoaclX(X: Integer): Integer;
    function LoaclY(Y: Integer): Integer;
  private
    function DirToDX(Direction: Integer): Integer;
    function DirToDY(Direction: Integer): Integer;

  protected
    function GetCost(X, Y, Direction: Integer): Integer; virtual;
    function FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;

  end;

  TFindPath = class(TPathMap) //�����ͼ��ȡ��Ѱ·��
  private
    FPath: TPath;
    FEnvir: TEnvirnoment;
  public
    BeginX, BeginY, EndX, EndY: Integer;
    constructor Create;
    property Path: TPath read FPath write FPath;
    function FindPath(Envir: TEnvirnoment; StartX, StartY, StopX, StopY: Integer; Run: Boolean): TPath; overload;
    function FindPath(StopX, StopY: Integer; Run: Boolean): TPath; overload;

    procedure SetStartPos(StartX, StartY: Integer);
    procedure Stop;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; override;
  end;

  TWaveCell = record //·�ߵ�
    X, Y: Integer; //
    Cost: Integer; //
    Direction: Integer;
  end;

  TWave = class //·����
  private
    FData: array of TWaveCell;
    FPos: Integer; //
    FCount: Integer; //
    FMinCost: Integer;
    function GetItem: TWaveCell;
  public
    property Item: TWaveCell read GetItem; //
    property MinCost: Integer read FMinCost; // Cost

    constructor Create;
    destructor Destroy; override;
    procedure Add(NewX, NewY, NewCost, NewDirection: Integer); //
    procedure Clear; //FCount
    function Start: Boolean; //
    function Next: Boolean; //
  end;

{const
  TerrainParams: array[TTerrainTypes] of TTerrainParam = (
    (CellColor: clWhite; CellLabel: 'ƽ��'; MoveCost: 4),
    (CellColor: clOlive; CellLabel: 'ɳ��'; MoveCost: 6),
    (CellColor: clGreen; CellLabel: '����'; MoveCost: 10),
    (CellColor: clSilver; CellLabel: '��·'; MoveCost: 2),
    (CellColor: clBlack; CellLabel: '�ϰ���'; MoveCost: - 1),
    (CellColor: clRed; CellLabel: '·��'; MoveCost: 0));
                                                               }

implementation
uses M2Share;
constructor TWave.Create;
begin
  Clear; //
end;

destructor TWave.Destroy;
begin
  FData := nil; //
  inherited Destroy;
end;

function TWave.GetItem: TWaveCell;
begin
  Result := FData[FPos]; //
end;

procedure TWave.Add(NewX, NewY, NewCost, NewDirection: Integer);
begin
  if FCount >= Length(FData) then SetLength(FData, Length(FData) + 30); //
  with FData[FCount] do begin
    X := NewX;
    Y := NewY;
    Cost := NewCost;
    Direction := NewDirection;
  end;
  if NewCost < FMinCost then FMinCost := NewCost;
  Inc(FCount); //
end;

procedure TWave.Clear;
begin
  FPos := 0;
  FCount := 0;
  FMinCost := High(Integer);
end;

function TWave.Start: Boolean;
begin
  FPos := 0; //
  Result := (FCount > 0); //
end;

function TWave.Next: Boolean;
begin
  Inc(FPos); //
  Result := (FPos < FCount); // false,
end;

{------------------------------------------------------------------------------}

constructor TPathMap.Create;
begin
  inherited Create;
  ScopeValue := {24}1000; // Ѱ·��Χ 20091231
  GetCostFunc := nil;
end;

//*************************************************************
//    ������תΪX�������
//     7  0  1
//     6  X  2
//     5  4  3
//*************************************************************
function TPathMap.DirToDX(Direction: Integer): Integer;
begin
  case Direction of
    0, 4: Result := 0;
    1..3: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.DirToDY(Direction: Integer): Integer;
begin
  case Direction of
    2, 6: Result := 0;
    3..5: Result := 1;
  else
    Result := -1;
  end;
end;
//*************************************************************
//    ��TPathMap���ҳ� TPath
//*************************************************************
function TPathMap.FindPathOnMap(X, Y: Integer; Run: Boolean): TPath;
var
//  I: Integer;
  nX, nY: Integer;
  Direction: Integer;
  nCount: Integer;
begin
  Result := nil;
  nCount := 0;
  nX := LoaclX(X);
  nY := LoaclY(Y);
  if (nX < 0) or (nY < 0) or (nX >= ClientRect.Right - ClientRect.Left) or (nY >= ClientRect.Bottom - ClientRect.Top) then Exit;

  if (Length(PathMapArray) <= 0) or (PathMapArray[nY, nX].Distance < 0) then Exit;

  SetLength(Result, PathMapArray[nY, nX].Distance + 1); //
  while PathMapArray[nY, nX].Distance > 0 do begin
    if not StartFind then Break;
    Result[PathMapArray[nY, nX].Distance] := Point(nX, nY);
    Direction := PathMapArray[nY, nX].Direction;
    nX := nX - DirToDX(Direction);
    nY := nY - DirToDY(Direction);
    Inc(nCount);
  end;

  Result[0] := Point(nX, nY);
  //for I := 0 to Length(Result) - 1 do Result[I] := Point(MapX(Result[I].X), MapY(Result[I].Y));//20100101ע��

  if Run then Result := WalkToRun(Result);
end;

function TPathMap.WalkToRun(Path: TPath): TPath; //��WALK�ϲ���RUN
  function GetNextDirection(sx, sy, dx, dy: Integer): Byte;
  var
    flagx, flagy: Integer;
  const
    DR_UP = 0;
    DR_UPRIGHT = 1;
    DR_RIGHT = 2;
    DR_DOWNRIGHT = 3;
    DR_DOWN = 4;
    DR_DOWNLEFT = 5;
    DR_LEFT = 6;
    DR_UPLEFT = 7;
  begin
    Result := DR_DOWN;
    if sx < dx then flagx := 1
    else if sx = dx then flagx := 0
    else flagx := -1;
    if abs(sy - dy) > 2
      then if (sx >= dx - 1) and (sx <= dx + 1) then flagx := 0;

    if sy < dy then flagy := 1
    else if sy = dy then flagy := 0
    else flagy := -1;
    if abs(sx - dx) > 2 then if (sy > dy - 1) and (sy <= dy + 1) then flagy := 0;

    if (flagx = 0) and (flagy = -1) then Result := DR_UP;
    if (flagx = 1) and (flagy = -1) then Result := DR_UPRIGHT;
    if (flagx = 1) and (flagy = 0) then Result := DR_RIGHT;
    if (flagx = 1) and (flagy = 1) then Result := DR_DOWNRIGHT;
    if (flagx = 0) and (flagy = 1) then Result := DR_DOWN;
    if (flagx = -1) and (flagy = 1) then Result := DR_DOWNLEFT;
    if (flagx = -1) and (flagy = 0) then Result := DR_LEFT;
    if (flagx = -1) and (flagy = -1) then Result := DR_UPLEFT;
  end;
var
  nDir1, nDir2: Integer;
  I, n01: Integer;
  WalkPath: TPath;
  nStep: Integer;
begin
  Result := nil;
  WalkPath := nil;
  if (Path <> nil) and (Length(Path) > 1) then begin
    SetLength(WalkPath, Length(Path));
    WalkPath := Path;
    nStep := 0;
    I := 0;
    while True do begin
      if not StartFind then Break;
      if I >= Length(WalkPath) then Break;
      if nStep >= 2 then begin
        nDir1 := GetNextDirection(WalkPath[I - 2].x, WalkPath[I - 2].y, WalkPath[I - 1].x, WalkPath[I - 1].y);
        nDir2 := GetNextDirection(WalkPath[I - 1].x, WalkPath[I - 1].y, WalkPath[I].x, WalkPath[I].y);
        if nDir1 = nDir2 then begin
          WalkPath[I - 1].x := -1;
          WalkPath[I - 1].y := -1;
          nStep := 0;
        end else begin //��Ҫת���ܺϲ�
          Dec(I);
          nStep := 0;
          Continue;
        end;
      end;
      Inc(nStep);
      Inc(I);
    end;

    n01 := 0;
    for I := 1 to Length(WalkPath) - 1 do begin
      if (WalkPath[I].x <> -1) and (WalkPath[I].y <> -1) then begin
        Inc(n01);
        SetLength(Result, n01);
        Result[n01 - 1] := WalkPath[I];
      end;
    end;
    Exit;
  end;
  if (Path <> nil) and (Length(Path) > 0) then begin
    SetLength(Result, Length(Path) - 1);
    for I := 1 to Length(Path) - 1 do Result[I - 1] := Path[I];
  end else begin
    SetLength(Result, 0);
    Result := nil;
  end;
end;

//*************************************************************
//    Ѱ·�㷨
//    X1,Y1Ϊ·��������㣬X2��Y2Ϊ·�������յ�
//*************************************************************
function TPathMap.MapX(X: Integer): Integer;
begin
  Result := X + ClientRect.Left;
end;

function TPathMap.MapY(Y: Integer): Integer;
begin
  Result := Y + ClientRect.Top;
end;

function TPathMap.LoaclX(X: Integer): Integer;
begin
  Result := X - ClientRect.Left;
end;

function TPathMap.LoaclY(Y: Integer): Integer;
begin
  Result := Y - ClientRect.Top;
end;

procedure TPathMap.GetClientRect(X, Y: Integer);
begin
  ClientRect := Bounds(0, 0, Width, Height);//Bounds����һ������
  if Width > ScopeValue then begin
    ClientRect.Left := Max(0, X - ScopeValue div 2);
    ClientRect.Right := ClientRect.Left + Min(Width, X + ScopeValue div 2);
  end;
  if Height > ScopeValue then begin
    ClientRect.Top := Max(0, Y - ScopeValue div 2);
    ClientRect.Bottom := ClientRect.Top + Min(Height, Y + ScopeValue div 2);
  end; 
end;

procedure TPathMap.GetClientRect(X1, Y1, X2, Y2: Integer);
var
  X, Y: Integer;
begin
  if X1 > X2 then begin
    X := X2 + (X1 - X2) div 2;
  end else
    if X1 < X2 then begin
    X := X1 + (X2 - X1) div 2;
  end else begin
    X := X1;
  end;

  if Y1 > Y2 then begin
    Y := Y2 + (Y1 - Y2) div 2;
  end else
    if Y1 < Y2 then begin
    Y := Y1 + (Y2 - Y1) div 2;
  end else begin
    Y := Y1;
  end;

  ClientRect := Bounds(0, 0, Width, Height);
  if Width > ScopeValue then begin
    ClientRect.Left := Max(0, X - ScopeValue div 2);
    ClientRect.Right := ClientRect.Left + Min(Width, X + ScopeValue div 2);
  end;
  if Height > ScopeValue then begin
    ClientRect.Top := Max(0, Y - ScopeValue div 2);
    ClientRect.Bottom := ClientRect.Top + Min(Height, Y + ScopeValue div 2);
  end;
end;
//*************************************************************
//    Ѱ·�㷨
//    X1,Y1Ϊ·��������㣬X2��Y2Ϊ·�������յ�
//*************************************************************
function TPathMap.FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
var
  OldWave, NewWave: TWave;
  Finished: Boolean;
  I: TWaveCell;
  nX1, nY1, nX2, nY2: Integer;
  //nCount: Integer;
  //nLoopCount: Integer;
  procedure PreparePathMap; //��ʼ��PathMapArray
  var
    X, Y: Integer; //
    nWidth, nHeight: Integer;
  begin
    nWidth := ClientRect.Right - ClientRect.Left;
    nHeight := ClientRect.Bottom - ClientRect.Top;
    SetLength(Result, nHeight, nWidth);
    for Y := 0 to nHeight - 1 do
      for X := 0 to nWidth - 1 do
        Result[Y, X].Distance := -1;
  end;

//��������8���ڵ��Ȩcost�����Ϸ������NewWave(),��������Сcost
//�Ϸ�����ָ���ϰ�����Result[X��Y]��δ���ʵĵ�
  procedure TestNeighbours;
  var
    X, Y, C, D: Integer;
  begin
    for D := 0 to 7 do begin
      X := OldWave.Item.X + DirToDX(D);
      Y := OldWave.Item.Y + DirToDY(D);
      C := GetCost(X, Y, D);
      if (C >= 0) and (Result[Y, X].Distance < 0) then NewWave.Add(X, Y, C, D); //
    end;
  end;

  procedure ExchangeWaves; //
  var
    W: TWave;
  begin
    W := OldWave;
    OldWave := NewWave;
    NewWave := W;
    NewWave.Clear;
  end;
begin
  GetClientRect(X1, Y1);
  nX1 := LoaclX(X1);
  nY1 := LoaclY(Y1);
  nX2 := LoaclX(X2);
  nY2 := LoaclY(Y2);

  if X2 < 0 then nX2 := X2;
  if Y2 < 0 then nY2 := Y2;

  if (X2 >= 0) and (Y2 >= 0) then begin
    if (abs(nX1 - nX2) > (ClientRect.Right - ClientRect.Left)) or
      (abs(nY1 - nY2) > (ClientRect.Bottom - ClientRect.Top)) then begin
      SetLength(Result, 0, 0);
      Exit;
    end;
  end;
  PreparePathMap; // ��ʼ��PathMapArray ,Distance:=-1
  OldWave := TWave.Create;
  NewWave := TWave.Create;
  try
    Result[nY1, nX1].Distance := 0; // ���Distance:=0
    OldWave.Add(nX1, nY1, 0, 0); //��������OldWave
    TestNeighbours; //

    //nCount := 0;
    //nLoopCount := 0;
    Finished := ((nX1 = nX2) and (nY1 = nY2)); //�����Ƿ񵽴��յ�
    while not Finished do begin
      //Inc(nCount);
      //if (nCount >= 100) then Break;
      ExchangeWaves; //
      //nLoopCount := 0;
      if not StartFind then Break;
      if not OldWave.Start then Break;
      repeat
        //Inc(nLoopCount);
        //if (nLoopCount >= 300) then Break;
        if not StartFind then Break;
        I := OldWave.Item;
        I.Cost := I.Cost - OldWave.MinCost; // �������MinCost
        if I.Cost > 0 then // ����NewWave
          NewWave.Add(I.X, I.Y, I.Cost, I.Direction) //����Cost= cost-MinCost
        else begin //  ������СCOST�ĵ�
          if Result[I.Y, I.X].Distance >= 0 then Continue;
          Result[I.Y, I.X].Distance := Result[I.Y - DirToDY(I.Direction), I.X - DirToDX(I.Direction)].Distance + 1; // �˵� Distance:=��һ����Distance+1
          Result[I.Y, I.X].Direction := I.Direction;
          Finished := ((I.X = nX2) and (I.Y = nY2)); //�����Ƿ񵽴��յ�
          if Finished then Break;
          TestNeighbours;
        end;
      until not OldWave.Next; //
    end; // OldWave;
  finally
    NewWave.Free;
    OldWave.Free;
  end;
end;
//20091231 �޸�
function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= Width) or (Y < 0) or (Y >= Height) then Result := -1
  else Result := GetCostFunc(X, Y, Direction, {PathWidth}0);
end;

constructor TFindPath.Create;
begin
  inherited Create;
  StartFind := False;
end;

procedure TFindPath.Stop;
begin
  StartFind := False;
  BeginX := -1;
  BeginY := -1;
  EndX := -1;
  EndY := -1;
  SetLength(PathMapArray, 0, 0);
  PathMapArray := nil;
end;

function TFindPath.FindPath(StopX, StopY: Integer; Run: Boolean): TPath;
begin
  EndX := StopX;
  EndY := StopY;
  Result := FindPathOnMap(StopX, StopY, Run);
end;

function TFindPath.FindPath(Envir: TEnvirnoment; StartX, StartY, StopX, StopY: Integer; Run: Boolean): TPath;
begin
  Width := Envir.m_nWidth;
  Height := Envir.m_nHeight;
  BeginX := StartX;
  BeginY := StartY;
  EndX := StopX;
  EndY := StopY;
  FPath := nil;
  FEnvir := Envir;
  StartFind := True;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY, Run);
end;

procedure TFindPath.SetStartPos(StartX, StartY: Integer);
begin
  BeginX := StartX;
  BeginY := StartY;
  PathMapArray := FillPathMap(StartX, StartY, -1, -1);
end;

function TFindPath.GetCost(X, Y, Direction: Integer): Integer;
var
//  cost: Integer;
  nX, nY: Integer;
begin
  if FEnvir <> nil then begin
    Direction := (Direction and 7);
    if (X < 0) or (X >= ClientRect.Right - ClientRect.Left) or (Y < 0) or (Y >= ClientRect.Bottom - ClientRect.Top) then
      Result := -1
    else begin
      nX := MapX(X);
      nY := MapY(Y);
      if FEnvir.CanWalkEx(nX, nY, False) then Result := 4 else Result := -1;
      //�����б����,��COST����
      if ((Direction and 1) = 1) and (Result > 0) then Result := Result + (Result shr 1); //ӦΪResult*sqt(2),�˴�����Ϊ1.5
    end;
  end else Result := -1;
end;

end.

