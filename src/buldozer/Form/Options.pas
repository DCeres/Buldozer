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

  public
    NomStart:word;
  end;

var
  fmOptions: TfmOptions;

const
  MinBarHW=6;

implementation

uses ufTlo, uBuldozer, uData;

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
  FBuld: TBuldozer;
begin
  FBuld := TBuldozer.Create;
  FBuld.FKart := Levels[ListBox1.ItemIndex+1];
  FBuld.FImageList := DataModule1.ImageList1;
  FBuld.Napr := 0;
  FBuld.Redraw(Image1.Canvas, Image1.ClientRect);
  Image1.Invalidate;
end;

end.
