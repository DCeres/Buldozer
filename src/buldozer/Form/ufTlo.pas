unit ufTlo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, TypConst, Menus, XPMan, ActnList;


type
  TfmTlo = class(TForm)
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    Help1: TMenuItem;
    RestartLevel1: TMenuItem;
    UndoLastMove1: TMenuItem;
    N1: TMenuItem;
    Options1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    About1: TMenuItem;
    ActionList1: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Exit1Click(Sender: TObject);
    procedure RestartLevel1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    NomLevel    :word;
    x,y         :byte;
    Napr        :byte;
    Byf         :Karta;
    Procedure ResetPole;
    Procedure BarPole(x,y:integer;typ:byte);
    procedure BLeft;
    procedure BRight;
    procedure BVerx;
    procedure BNuz;
    Function Stop(ix,iy:integer):boolean;
  public
    Kart  :Karta;
  end;

var
  fmTlo: TfmTlo;

implementation

{$R *.dfm}
uses options, ufAbout, uData;

procedure TfmTlo.BarPole(x, y:integer; typ: byte);
begin
  DataModule1.ImageList1.Draw(Canvas, x,y, 0);
  case typ of
    1: DataModule1.ImageList1.Draw(Canvas, x,y, 1);
    10,11: DataModule1.ImageList1.Draw(Canvas, x,y, 2);
    22: DataModule1.ImageList1.Draw(Canvas, x,y, 7);

    20,21:case Napr of
           1: DataModule1.ImageList1.Draw(Canvas, x,y, 3);
           2: DataModule1.ImageList1.Draw(Canvas, x,y, 4);
           3: DataModule1.ImageList1.Draw(Canvas, x,y, 5);
           4: DataModule1.ImageList1.Draw(Canvas, x,y, 6);
         end;
  end;
  case typ of
    1,11,21: DataModule1.ImageList1.Draw(Canvas, x,y, 1);
  end;
end;

procedure TfmTlo.ResetPole;
Var i,j:integer;
begin
      For i:=0 to 11 do
       for  j:=0  to 19 do
       begin
            BarPole(j*32,i*32,Kart[i,j]);
            if Kart[i,j] = 20 then
            Begin
                x:=i;
                y:=j;
            end;
       end;

end;

procedure TfmTlo.FormCreate(Sender: TObject);
var i:integer;
begin
  NomLevel:=1;
  Kart:=Levels[NomLevel];
  Napr:=1;
  Caption:='Bulldozer - Level ' + intToStr(NomLevel);
end;

procedure TfmTlo.FormPaint(Sender: TObject);
begin
  ResetPole;
end;

procedure TfmTlo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
       27:Application.Minimize;
       37:BRight;
       38:BVerx;
       39:BLeft;
       40:BNuz;
     end;
     FillChar(Byf,SizeOf(Karta),0);
     if Not Stop(x,y) then
     Begin
        if NomLevel = MaxLevel then
        Begin
             ShowMessage('Game over');
             NomLevel:=0;
        end
        else ShowMessage('You Completed Level '+IntToStr(NomLevel)+
                  '  Prepere for Level '+IntToStr(NomLevel+1));
        inc(NomLevel);
        Kart:=Levels[NomLevel];
        Caption:='Bulldozer - Level' + intToStr(NomLevel);
     end;
     Invalidate;
end;

procedure TfmTlo.BLeft;
begin
     Napr:=4;
     if (Kart[x,y]+Kart[x,y+1]+Kart[x,y+2]<40)or(Kart[x,y+1]<5) then
     begin
        if Kart[x,y+1]>9 then
        Begin
             Kart[x,y+1]:=Kart[x,y+1]-10;
             Kart[x,y+2]:=Kart[x,y+2]+10;
        end;
        Kart[x,y]:=Kart[x,y]-20;
        Kart[x,y+1]:=Kart[x,y+1]+20;
        BarPole((y+2)*32,x*32,Kart[x,y+2]);
        BarPole(y*32,x*32,Kart[x,y]);
        inc(y);
     end;
     BarPole(y*32,x*32,Kart[x,y]);
end;

procedure TfmTlo.BRight;
begin
     Napr:=2;
     if (Kart[x,y]+Kart[x,y-1]+Kart[x,y-2]<40)or(Kart[x,y-1]<5) then
     begin
        if Kart[x,y-1]>9 then
        Begin
             Kart[x,y-1]:=Kart[x,y-1]-10;
             Kart[x,y-2]:=Kart[x,y-2]+10;
        end;
        Kart[x,y]:=Kart[x,y]-20;
        Kart[x,y-1]:=Kart[x,y-1]+20;
        BarPole((y-2)*32,x*32,Kart[x,y-2]);
        BarPole(y*32,x*32,Kart[x,y]);
        dec(y);
     end;
     BarPole(y*32,x*32,Kart[x,y]);
end;

procedure TfmTlo.BVerx;
begin
     Napr:=3;
     if (Kart[x,y]+Kart[x-1,y]+Kart[x-2,y]<40)or(Kart[x-1,y]<5) then
     begin
        if Kart[x-1,y]>9 then
        Begin
             Kart[x-1,y]:=Kart[x-1,y]-10;
             Kart[x-2,y]:=Kart[x-2,y]+10;
        end;
        Kart[x,y]:=Kart[x,y]-20;
        Kart[x-1,y]:=Kart[x-1,y]+20;
        BarPole(y*32,(x-2)*32,Kart[x-2,y]);
        BarPole(y*32,x*32,Kart[x,y]);
        dec(x);
     end;
     BarPole(y*32,x*32,Kart[x,y]);

end;

procedure TfmTlo.BNuz;
begin
     Napr:=1;
     if (Kart[x,y]+Kart[x+1,y]+Kart[x+2,y]<40)or(Kart[x+1,y]<5) then
     begin
        if Kart[x+1,y]>9 then
        Begin
             Kart[x+1,y]:=Kart[x+1,y]-10;
             Kart[x+2,y]:=Kart[x+2,y]+10;
        end;
        Kart[x,y]:=Kart[x,y]-20;
        Kart[x+1,y]:=Kart[x+1,y]+20;
        BarPole(y*32,(x+2)*32,Kart[x+2,y]);
        BarPole(y*32,x*32,Kart[x,y]);
        inc(x);
     end;
     BarPole(y*32,x*32,Kart[x,y]);
end;


function TfmTlo.Stop(ix, iy: integer): boolean;
var bool:Boolean;
begin
     Bool:=False;
     Byf[ix,iy]:=15;
     if Kart[ix+1,iy]+Byf[ix+1,iy]<15 then Bool:=Stop(ix+1, iy) or Bool;
     if Kart[ix,iy+1]+Byf[ix,iy+1]<15 then Bool:=Stop(ix, iy+1) or Bool;
     if Kart[ix-1,iy]+Byf[ix-1,iy]<15 then Bool:=Stop(ix-1, iy) or Bool;
     if Kart[ix,iy-1]+Byf[ix,iy-1]<15 then Bool:=Stop(ix, iy-1) or Bool;
     if Kart[ix,iy]=1 then Bool:=true;
     if Kart[ix,iy]=21 then Bool:=true;
     Stop:=Bool;
end;
procedure TfmTlo.Exit1Click(Sender: TObject);
begin
     Close;
end;

procedure TfmTlo.RestartLevel1Click(Sender: TObject);
begin
  {ShowMessage('You Completed Level '+IntToStr(NomLevel-1)+
         '  Prepere for Level '+IntToStr(NomLevel));
  }
  Kart:=Levels[NomLevel];
  Caption:='Bulldozer - Level' + intToStr(NomLevel);
  ResetPole;
end;

procedure TfmTlo.Options1Click(Sender: TObject);
begin
  fmOptions.ShowModal;
  NomLevel:=fmOptions.NomStart;
  Kart:=Levels[NomLevel];
  Caption:='Bulldozer - Level' + intToStr(NomLevel);
  ResetPole;
end;

procedure TfmTlo.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
