unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TypConst, StdCtrls, ExtCtrls;

type
  TfmOptions = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    Procedure MinBarPole(x,y:integer;typ:byte);
  public
    NomStart:word;
  end;

var
  fmOptions: TfmOptions;

const
  MinBarHW=6;

implementation

uses ufTlo;

{$R *.dfm}

procedure TfmOptions.FormCreate(Sender: TObject);
var i :integer;
begin
     i:=1;
     while i<=MaxLevel do
     Begin
        ListBox1.AddItem('Level '+intToStr(i),ListBox1);
        inc(i);
     end;
     NomStart:=1;
     ListBox1.ItemIndex:=1;
     ListBox1Click(Sender);
end;

procedure TfmOptions.Button1Click(Sender: TObject);
begin
     NomStart:=ListBox1.ItemIndex+1;

     Close;
end;
procedure TfmOptions.ListBox1DblClick(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TfmOptions.ListBox1Click(Sender: TObject);
var i,j:integer;
begin
  For i:=0 to 11 do
   for  j:=0  to 19 do
   begin
        MinBarPole(j*MinBarHW,i*MinBarHW,Levels[ListBox1.ItemIndex+1][i,j]);
   end;
end;

procedure TfmOptions.MinBarPole(x, y: integer; typ: byte);
Var
  TmpBit:TBitmap;
begin
  TmpBit:=TBitmap.Create;
  TmpBit.Width:=MinBarHW;
  TmpBit.Height:=MinBarHW;
  TmpBit.PixelFormat:=pf24bit;
  with Image1 do
  Begin
     StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW,
            fmTlo.mal[0].Canvas.Handle,0,0,32,32,SRCCOPY);
     case typ of
//           1: StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW,
//              fmTlo.mal[1].Canvas.Handle,0,0,32,32,SRCCOPY);
         10,11: StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW,
            fmTlo.mal[2].Canvas.Handle,0,0,32,32,SRCCOPY);
         22:StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW,
            fmTlo.mal[7].Canvas.Handle,0,0,32,32,SRCCOPY);
       end;
     case typ of
       1, 11, 21:
       Begin
         StretchBlt(TmpBit.Canvas.Handle,0,0,MinBarHW,MinBarHW,
              fmTlo.mal[1].Canvas.Handle,0,0,32,32,SRCCOPY);
         TmpBit.TransparentColor:=TmpBit.Canvas.Pixels[0,0];
         TmpBit.Transparent:=true;
         Canvas.Draw(x,y,TmpBit);
       end;
     end;
  End;
end;

end.
