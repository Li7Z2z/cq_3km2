unit u_QuickSort;

{LTist ��������}
interface

uses
  sysUtils,classes,Dialogs;

type
  TtdCompareFunc = function (aData1, aData2 : pointer) : Longint;   {��������}

procedure QSS(aList : TList; aFirst : Longint; aLast : Longint; aCompare : TtdCompareFunc);
{-����QuickSort}
procedure TDQuickSortStd(aList : TList; aFirst : Longint; aLast : Longint; aCompare : TtdCompareFunc);
{-����QuickSort����������}
procedure QSNR(aList: TList; aFirst: Longint; aLast: Longint; aCompare : TtdCompareFunc);
{-�ǵݹ�QuickSort}
procedure TDQuickSortNoRecurse(aList: TList; aFirst: Longint;aLast: Longint;aCompare: TtdCompareFunc);
{-�ǵݹ�QuickSort����������}
procedure QSR(aList : TList;aFirst: Longint;aLast: Longint;aCompare : TtdCompareFunc);
{-���֧���Quicksort}
procedure TDQuickSortRandom(aList: TList;aFirst: Longint;aLast: Longint;aCompare : TtdCompareFunc);
{-���֧���Quicksort����������}
procedure TDQuickSortMedian(aList : TList;aFirst: Longint;aLast: Longint;aCompare : TtdCompareFunc);
{-3��֧��QuickSort����������}
procedure QSInsertionSort(aList : TList;aFirst: Longint;aLast : Longint;aCompare : TtdCompareFunc);
{-Ϊ����QuickSort�����InsertionSort}
procedure QS(aList : TList; aFirst: Longint;aLast : Longint;aCompare : TtdCompareFunc);
{-����QuickSort}
procedure TDQuickSort(aList : TList; aFirst: Longint; aLast : Longint; aCompare : TtdCompareFunc);
{-����QuickSort����������}

{��鷶Χ�Ƿ�Ϸ�}
procedure TDValidateListRange(aList : TList; aStart, aEnd : Longint);

implementation
{===����QuickSort===============================================}
procedure QSS(aList : TList; aFirst: Longint;aLast : Longint;aCompare : TtdCompareFunc);
var
  L, R  : Longint;
  Pivot : pointer;
  Temp  : pointer;
begin
  {������������Ԫ��}
  while (aFirst < aLast) do begin
    {֧��Ϊ�е�Ԫ��}
    Pivot := aList.List[(aFirst+aLast) div 2];
    {�����������л���}
    L := pred(aFirst);
    R := succ(aLast);
    while true do begin
      repeat dec(R); until (aCompare(aList.List[R], Pivot) <= 0);
      repeat inc(L); until (aCompare(aList.List[L], Pivot) >= 0);
      if (L >= R) then Break;
      Temp := aList.List[L];
      aList.List[L] := aList.List[R];
      aList.List[R] := Temp;
    end;
    {�Ե�һ���Ӽ�����quicksort}
    if (aFirst < R) then QSS(aList, aFirst, R, aCompare);
    {�Եڶ����Ӽ�����quicksort}
    aFirst := succ(R);
  end;
end;

procedure TDQuickSortStd(aList : TList; aFirst: Longint; aLast: Longint; aCompare : TtdCompareFunc);
begin
  TDValidateListRange(aList, aFirst, aLast);
  QSS(aList, aFirst, aLast, aCompare);
end;
{====================================================================}
procedure QSNR(aList : TList; aFirst: Longint; aLast: Longint; aCompare : TtdCompareFunc);
var
  L, R  : Longint;
  Pivot : pointer;
  Temp  : pointer;
  Stack : array [0..63] of Longint;
  SP    : Longint;
begin
  {��ʼ��ջ}
  Stack[0] := aFirst;
  Stack[1] := aLast;
  SP := 2;
  while (SP <> 0) do begin
    {����ջ���ӱ�}
    dec(SP, 2);
    aFirst := Stack[SP];
    aLast := Stack[SP+1];
    {������������Ԫ��}
    while (aFirst < aLast) do begin
      {֧��Ϊ�м�Ԫ��}
      Pivot := aList.List[(aFirst+aLast) div 2];
      {�������������л���}
      L := pred(aFirst);
      R := succ(aLast);
      while true do begin
        repeat dec(R); until (aCompare(aList.List[R], Pivot) <= 0);
        repeat inc(L); until (aCompare(aList.List[L], Pivot) >= 0);
        if (L >= R) then Break;
        Temp := aList.List[L];
        aList.List[L] := aList.List[R];
        aList.List[R] := Temp;
      end;
      {����һЩ���ӱ�ѹ��ջ������С�ӱ���}
      if (R - aFirst) < (aLast - R) then begin
        Stack[SP] := succ(R);
        Stack[SP+1] := aLast;
        inc(SP, 2);
        aLast := R;
      end else begin
        Stack[SP] := aFirst;
        Stack[SP+1] := R;
        inc(SP, 2);
        aFirst := succ(R);
      end;
    end;
  end;
end;
procedure TDQuickSortNoRecurse(aList: TList; aFirst : Longint;aLast: Longint;aCompare : TtdCompareFunc);
begin
  TDValidateListRange(aList, aFirst, aLast);
  QSNR(aList, aFirst, aLast, aCompare);
end;
{====================================================================}
procedure QSR(aList : TList;aFirst: Longint;aLast : Longint;aCompare : TtdCompareFunc);
var
  L, R  : Longint;
  Pivot : pointer;
  Temp  : pointer;
begin
  while (aFirst < aLast) do begin
    {ѡ��һ�����Ԫ����֧��}
    R := aFirst + Random(aLast - aFirst + 1);
    L := (aFirst + aLast) div 2;
    Pivot := aList.List[R];
    aList.List[R] := aList.List[L];
    aList.List[L] := Pivot;
    {�������������л���}
    L := pred(aFirst);
    R := succ(aLast);
    while true do begin
      repeat dec(R); until (aCompare(aList.List[R], Pivot) <= 0);
      repeat inc(L); until (aCompare(aList.List[L], Pivot) >= 0);
      if (L >= R) then Break;
      Temp := aList.List[L];
      aList.List[L] := aList.List[R];
      aList.List[R] := Temp;
    end;
    {�Ե�һ���Ӽ�����quicksort}
    if (aFirst < R) then QSR(aList, aFirst, R, aCompare);
    {�Եڶ����Ӽ�����quicksort}
    aFirst := succ(R);
  end;
end;

procedure TDQuickSortRandom(aList : TList; aFirst: Longint; aLast: Longint; aCompare : TtdCompareFunc);
begin
  TDValidateListRange(aList, aFirst, aLast);
  QSR(aList, aFirst, aLast, aCompare);
end;
{====================================================================}
procedure QSM(aList: TList; aFirst: Longint; aLast: Longint; aCompare : TtdCompareFunc);
var
  L, R  : Longint;
  Pivot : pointer;
  Temp  : pointer;
begin
  while (aFirst < aLast) do begin
    {����3��������Ԫ�أ�ѡ���һ��Ԫ�أ����һ��Ԫ�أ��м�Ԫ����֧��}
    if (aLast - aFirst) >= 2 then begin
      R := (aFirst + aLast) div 2;
      if (aCompare(aList.List[aFirst], aList.List[R]) > 0) then begin
        Temp := aList.List[aFirst];
        aList.List[aFirst] := aList.List[R];
        aList.List[R] := Temp;
      end;
      if (aCompare(aList.List[aFirst], aList.List[aLast]) > 0) then begin
        Temp := aList.List[aFirst];
        aList.List[aFirst] := aList.List[aLast];
        aList.List[aLast] := Temp;
      end;
      if (aCompare(aList.List[R], aList.List[aLast]) > 0) then begin
        Temp := aList.List[R];
        aList.List[R] := aList.List[aLast];
        aList.List[aLast] := Temp;
      end;
      Pivot := aList.List[R];
    end
    {��ֻ������Ԫ�أ�ѡ��һ����֧��}
    else
      Pivot := aList.List[aFirst];
    {�������������л���}
    L := pred(aFirst);
    R := succ(aLast);
    while true do begin
      repeat dec(R); until (aCompare(aList.List[R], Pivot) <= 0);
      repeat inc(L); until (aCompare(aList.List[L], Pivot) >= 0);
      if (L >= R) then Break;
      Temp := aList.List[L];
      aList.List[L] := aList.List[R];
      aList.List[R] := Temp;
    end;
    { �Ե�һ���Ӽ�����quicksort}
    if (aFirst < R) then QSM(aList, aFirst, R, aCompare);
    {�Եڶ����Ӽ�����quicksort}
    aFirst := succ(R);
  end;
end;
{--------}
procedure TDQuickSortMedian(aList: TList;aFirst: Longint;aLast: Longint; aCompare : TtdCompareFunc);
begin
  TDValidateListRange(aList, aFirst, aLast);
  QSM(aList, aFirst, aLast, aCompare);
end;
{====================================================================}

const
  QSCutOff = 15;
procedure QSInsertionSort(aList : TList;aFirst: Longint;aLast : Longint; aCompare : TtdCompareFunc);
var
  i, j       : Longint;
  IndexOfMin : Longint;
  Temp       : pointer;
begin
  {�ҵ���СԪ�أ�������ŵ���һλ}
  IndexOfMin := aFirst;
  j := QSCutOff;
  if (j > aLast) then j := aLast;
  for i := succ(aFirst) to j do
    if (aCompare(aList.List[i], aList.List[IndexOfMin]) < 0) then IndexOfMin := i;
  if (aFirst <> IndexOfMin) then begin
    Temp := aList.List[aFirst];
    aList.List[aFirst] := aList.List[IndexOfMin];
    aList.List[IndexOfMin] := Temp;
  end;
  {����quicksort}
  for i := aFirst+2 to aLast do begin
    Temp := aList.List[i];
    j := i;
    while (aCompare(Temp, aList.List[j-1]) < 0) do begin
      aList.List[j] := aList.List[j-1];
      Dec(j);
    end;
    aList.List[j] := Temp;
  end;
end;

{--------}
procedure QS(aList : TList; aFirst: Longint; aLast : Longint; aCompare : TtdCompareFunc);
var
  L, R  : Longint;
  Pivot : pointer;
  Temp  : pointer;
  Stack : array [0..63] of Longint;
  SP    : Longint;
begin
  {��ʼ��ջ}
  Stack[0] := aFirst;
  Stack[1] := aLast;
  SP := 2;
  {ջ�����ӱ�ʱ}
  while (SP <> 0) do begin
    {����ջ���ӱ�}
    dec(SP, 2);
    aFirst := Stack[SP];
    aLast := Stack[SP+1];
    {���ӱ����㹻Ԫ�أ������ѭ��}
    while ((aLast - aFirst) > QSCutOff) do begin
      {����3��������Ԫ�أ�ѡ���һ��Ԫ�أ����һ��Ԫ�أ��м�Ԫ����֧��}
      R := (aFirst + aLast) div 2;
      if (aCompare(aList.List[aFirst], aList.List[R]) > 0) then begin
        Temp := aList.List[aFirst];
        aList.List[aFirst] := aList.List[R];
        aList.List[R] := Temp;
      end;
      if (aCompare(aList.List[aFirst], aList.List[aLast]) > 0) then begin
        Temp := aList.List[aFirst];
        aList.List[aFirst] := aList.List[aLast];
        aList.List[aLast] := Temp;
      end;
      if (aCompare(aList.List[R], aList.List[aLast]) > 0) then begin
        Temp := aList.List[R];
        aList.List[R] := aList.List[aLast];
        aList.List[aLast] := Temp;
      end;
      Pivot := aList.List[R];
      {�������������л���}
      L := aFirst;
      R := aLast;
      while true do begin
        repeat dec(R); until (aCompare(aList.List[R], Pivot) <= 0);
        repeat inc(L); until (aCompare(aList.List[L], Pivot) >= 0);
        if (L >= R) then Break;
        Temp := aList.List[L];
        aList.List[L] := aList.List[R];
        aList.List[R] := Temp;
      end;

      {����һЩ���ӱ�ѹ��ջ������С�ӱ���}
      if (R - aFirst) < (aLast - R) then begin
        Stack[SP] := succ(R);
        Stack[SP+1] := aLast;
        inc(SP, 2);
        aLast := R;
      end else begin
        Stack[SP] := aFirst;
        Stack[SP+1] := R;
        inc(SP, 2);
        aFirst := succ(R);
      end;
    end;
  end;
end;

procedure TDQuickSort(aList: TList; aFirst: Longint; aLast: Longint;aCompare : TtdCompareFunc);
begin
  TDValidateListRange(aList, aFirst, aLast);
  QS(aList, aFirst, aLast, aCompare);
  QSInsertionSort(aList, aFirst, aLast, aCompare);
  QSS(aList, aFirst, aLast, aCompare);
end;

{��鷶Χ�Ƿ�Ϸ�}
procedure TDValidateListRange(aList : TList; aStart, aEnd : Longint);
begin
  if (aList = nil) then Exit;
  if (aStart < 0) or (aStart >= aList.Count) or (aEnd < 0) or (aEnd >= aList.Count) or //��鷶Χ�Ƿ�Խ��
     (aStart > aEnd) then Exit;
end;

end.

