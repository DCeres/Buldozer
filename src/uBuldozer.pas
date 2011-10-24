unit uBuldozer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, TypConst;
type
  TBuldozer = class
  private
    FCol: integer;
    FRow: integer;
    FSize: integer;
    x, y: Integer;
    //Kart: array of array of integer;
    procedure DrawItem(const Canvas: TCanvas; const x, y, cod: integer);
  public
    FKart: Karta;
    Napr: byte;
    FImageList: TImageList;
    constructor Create;
    procedure Redraw(const Canvas: TCanvas; const rc: TRect);

    procedure pos(const ax, ay: integer);
    function Port(var old, next, pre: byte): boolean;
    procedure Left;
    procedure Right;
    procedure Up;
    procedure Down;
  protected

  end;

implementation

{ TBuldozer }

constructor TBuldozer.Create;
begin
  //inherited;

  FCol := 11;
  FRow := 19;
  FSize := 32;
  //FKart := nil;
end;

procedure TBuldozer.DrawItem(const Canvas: TCanvas; const x, y, cod: integer);
begin
  FImageList.Draw(Canvas, x,y, 0);
  case cod of
    1: FImageList.Draw(Canvas, x,y, 1);
    10,11: FImageList.Draw(Canvas, x,y, 2);
    22: FImageList.Draw(Canvas, x,y, 7);

    20,21:case Napr of
           1: FImageList.Draw(Canvas, x,y, 3);
           2: FImageList.Draw(Canvas, x,y, 4);
           3: FImageList.Draw(Canvas, x,y, 5);
           4: FImageList.Draw(Canvas, x,y, 6);
         end;
  end;
  case cod of
    1,11,21: FImageList.Draw(Canvas, x,y, 1);
  end;
end;

procedure TBuldozer.Redraw(const Canvas: TCanvas; const rc: TRect);
var
  bmp: TBitmap;
  i, j: Integer;
begin
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.Width := FSize * FRow;
    bmp.Height := FSize * FCol;
    For i := 0 to FCol do
    begin
      for j := 0 to FRow do
      begin
        DrawItem(bmp.Canvas, j * FSize, i * FSize, FKart[i, j]);

        if FKart[i, j] = 20 then
        Begin
          x := i;
          y := j;
        end;
      end;
    end;

    StretchBlt(
        Canvas.Handle,
        rc.Left,
        rc.Top,
        rc.Right - rc.Left,
        rc.Bottom - rc.Top,
        bmp.Canvas.Handle,
        0,
        0,
        bmp.Width,
        bmp.Height,
        SRCCOPY
      );
  finally
    bmp.Free;
  end;
end;

function TBuldozer.Port(var old, next, pre: byte): boolean;
begin
  Result := (old + next + pre < 40) or (next < 5);
  if Result then
  begin
    if next > 9 then
    Begin
      next := next - 10;
      pre := pre + 10;
    end;
    old := old - 20;
    next := next + 20;
  end;
end;

procedure TBuldozer.pos(const ax, ay: integer);
begin
  x := ax;
  y := ay;
end;

procedure TBuldozer.Left;
begin
  Napr := 4;
  if Port(FKart[x, y], FKart[x, y + 1], FKart[x, y + 2]) then
  begin
    inc(y);
  end;
end;

procedure TBuldozer.Right;
begin
  Napr := 2;
  if Port(FKart[x, y], FKart[x, y - 1], FKart[x, y - 2]) then
  begin
    dec(y);
  end;
end;

procedure TBuldozer.Up;
begin
  Napr := 3;
  if Port(FKart[x, y], FKart[x - 1, y], FKart[x - 2, y]) then
  begin
    dec(x);
  end;
end;

procedure TBuldozer.Down;
begin
  Napr := 1;
  if Port(FKart[x, y], FKart[x + 1, y], FKart[x + 2, y]) then
  begin
    inc(x);
  end;
end;

end.
