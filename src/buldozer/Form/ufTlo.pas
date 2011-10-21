unit ufTlo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, TypConst, Menus, XPMan, ActnList, uBuldozer;


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
    FBuld: TBuldozer;

    NomLevel    :word;
    procedure SetLevel(lev: Integer);
    Function Stop(ix,iy:integer):boolean;
  public
    //Kart  :Karta;
  end;

var
  fmTlo: TfmTlo;

implementation

{$R *.dfm}
uses options, ufAbout, uData;

procedure TfmTlo.FormCreate(Sender: TObject);
var i:integer;
begin
  FBuld := TBuldozer.Create;
  FBuld.FImageList := DataModule1.ImageList1;
  FBuld.Napr := 1;
  SetLevel(0);
end;

procedure TfmTlo.SetLevel(lev: Integer);
begin
  NomLevel := lev;
  FBuld.FKart := Levels[NomLevel];
  Caption := 'Bulldozer - Level ' + intToStr(NomLevel);
end;

procedure TfmTlo.FormPaint(Sender: TObject);
begin
  FBuld.Redraw(Canvas, ClientRect);
end;

procedure TfmTlo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
   27:Application.Minimize;
   37:FBuld.Right;
   38:FBuld.Up;
   39:FBuld.Left;
   40:FBuld.Down;
  end;
{
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
        FBuld.FKart:=Levels[NomLevel];
        Caption:='Bulldozer - Level' + intToStr(NomLevel);
     end;
}
  Invalidate;
end;

function TfmTlo.Stop(ix, iy: integer): boolean;
var
  bool: Boolean;
  Kart: Karta;
  Byf: Karta;
begin
  Kart := FBuld.FKart;
  Bool := False;
  //FillChar(Byf, SizeOf(Karta), 0);
  Byf[ix,iy] := 15;
  if Kart[ix+1,iy] + Byf[ix+1,iy] < 15 then Bool := Stop(ix+1, iy) or Bool;
  if Kart[ix,iy+1] + Byf[ix,iy+1] < 15 then Bool := Stop(ix, iy+1) or Bool;
  if Kart[ix-1,iy] + Byf[ix-1,iy] < 15 then Bool := Stop(ix-1, iy) or Bool;
  if Kart[ix,iy-1] + Byf[ix,iy-1] < 15 then Bool := Stop(ix, iy-1) or Bool;
  if Kart[ix,iy] = 1 then Bool := true;
  if Kart[ix,iy] = 21 then Bool := true;
  Stop := Bool;
  FBuld.FKart := Kart;
end;

procedure TfmTlo.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmTlo.RestartLevel1Click(Sender: TObject);
begin
  SetLevel(NomLevel);
  Invalidate;
end;

procedure TfmTlo.Options1Click(Sender: TObject);
begin
  if fmOptions.ShowModal = IDOK then
    SetLevel(fmOptions.NomStart);
  Invalidate;
end;

procedure TfmTlo.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
