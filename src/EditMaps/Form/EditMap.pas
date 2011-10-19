unit EditMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,TypConst, StdCtrls, Grids, ImgList, ComCtrls, ToolWin, ExtCtrls,
  AppEvnts, Menus, XPMan, ActnList, StdActns, CommCtrl;

type
  TfrmEdit = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton4: TToolButton;
    ApplicationEvents1: TApplicationEvents;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Games: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    New1: TMenuItem;
    Refresh1: TMenuItem;
    Options1: TMenuItem;
    ToolBar2: TToolBar;
    ActionList1: TActionList;
    ActionEdit: TAction;
    ToolBar3: TToolBar;
    Edit3: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ImageList2: TImageList;
    FileExit1: TFileExit;
    Exit1: TMenuItem;
    ActionSave: TAction;
    FileOpen1: TFileOpen;
    ActionRefresh: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionNew: TAction;
    ActionRestart: TAction;
    ActionOptions: TAction;
    Refresh2: TMenuItem;
    ListView1: TListView;
    ImageListTumb: TImageList;
    DrawGrid1: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ToolButton1Click(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey;
      var Handled: Boolean);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ActionEditUpdate(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    Map,Byf:Karta;
    NomLev:word;
    ActBar:Integer;

    x,y         :byte;
    Napr        :byte;
    procedure ResetPole;
    Procedure BarPole(ACol, ARow:integer;typ:byte);
    procedure BLeft;
    procedure BRight;
    procedure BVerx;
    procedure BNuz;
    Function Stop(ix,iy:integer):boolean;

    Procedure MinBarPole(Canvas: TCanvas; x,y:integer;typ:byte);
  public
    { Public declarations }
  end;

var
  frmEdit: TfrmEdit;

implementation

uses uData;

{$R *.dfm}

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
    NomLev:=1;
    Map:=Levels[NomLev];
    ToolButton1.Down:=true;
    ActBar:=ToolButton1.ImageIndex;
    ResetPole;
end;

procedure TfrmEdit.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  ActionRefresh.Execute;
end;

procedure TfrmEdit.MinBarPole(Canvas: TCanvas; x, y: integer; typ: byte);
Var
  TmpBit:TBitmap;
const
  MinBarHW = 6;
begin
  TmpBit := TBitmap.Create;
{
  TmpBit.Width := MinBarHW;
  TmpBit.Height := MinBarHW;
  TmpBit.PixelFormat := pf24bit;
}
  DataModule1.ImageList1.GetBitmap(0, TmpBit);
  StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW, TmpBit.Canvas.Handle,0,0,32,32,SRCCOPY);
  case typ of
    10,11: DataModule1.ImageList1.GetBitmap(2, TmpBit);
    22:DataModule1.ImageList1.GetBitmap(7, TmpBit);
     end;
  StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW, TmpBit.Canvas.Handle,0,0,32,32,SRCCOPY);
  case typ of
     1, 11, 21:
     Begin
       DataModule1.ImageList1.GetBitmap(1, TmpBit);
       TmpBit.TransparentColor := TmpBit.Canvas.Pixels[0,0];
       TmpBit.Transparent := true;
       //Canvas.Draw(x,y,TmpBit);
     end;
   end;
  StretchBlt(Canvas.Handle,x,y,MinBarHW,MinBarHW, TmpBit.Canvas.Handle,0,0,32,32,SRCCOPY);
end;

procedure TfrmEdit.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
const bar:array [0..7] of byte =(0,1,10,20,0,0,0,22);
begin
  if CanSelect and(ActBar>-1)and ActionEdit.Checked
    then Map[ARow,ACol]:=Bar[ActBar];
end;

procedure TfrmEdit.ToolButton1Click(Sender: TObject);
begin
  ActBar := TToolButton(Sender).ImageIndex;
end;

procedure TfrmEdit.ResetPole;
Var i,j:integer;
begin
  For i:=0 to 11 do
    for  j:=0  to 19 do
    begin
      if Map[i,j] = 20 then
      Begin
        x:=i;
        y:=j;
        BarPole(j,i,Map[i,j]);
      end;
    end;
end;

procedure TfrmEdit.ActionEditExecute(Sender: TObject);
begin
   ActionRefresh.Execute;
end;

procedure TfrmEdit.ActionEditUpdate(Sender: TObject);
begin
   DrawGrid1.Enabled := ActionEdit.Checked;
end;

procedure TfrmEdit.ActionNewExecute(Sender: TObject);
var
  i: integer;
  bmp: TBitmap;
  item: TListItem;
var
  x,y:integer;
var
  tvi: TLVTILEVIEWINFO;
var
  ti: TLVTILEINFO;
  Order: array of Integer;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf32bit;
  bmp.Width := ImageListTumb.Width;
  bmp.Height := ImageListTumb.Height;
  bmp.Canvas.Brush.Color := clRed;
  bmp.Canvas.Ellipse(0, 0, bmp.Width, bmp.Height);
  ListView_SetView(ListView1.Handle, LV_VIEW_TILE);

  tvi.cbSize := Sizeof(tvi);
  tvi.dwMask := LVTVIM_COLUMNS;
  // Requesting space to draw the caption + 3 subitems
  tvi.cLines := 4;
  ListView_SetTileViewInfo(ListView1.Handle, tvi);

  ti.cbSize := SizeOf(ti);
  // Specifying the order for three columns
  ti.cColumns := 3;
  // Array initialization
  SetLength(order, ti.cColumns);
  // The order is 2nd, 3rd and 4th columns
  order[0] := 1;
  order[1] := 2;
  order[2] := 3;
  ti.puColumns := PUINT(order);
  ti.iItem := 0;

  i := 1;
  while i <= MaxLevel do
  Begin
    For x := 0 to 11 do
    for  y := 0  to 19 do
    begin
      MinBarPole(bmp.Canvas, y * 6, x * 6, Levels[i][x, y]);
    end;

    ImageListTumb.Add(bmp, bmp);
    item := ListView1.Items.Add;
    item.Caption := 'Level #' + intToStr(i);
    item.ImageIndex := i - 1;
    item.SubItems.Add('Level #' + intToStr(i));
    item.SubItems.Add('124');
    item.SubItems.Add('125');
    // First item
    //ListView_SetTileInfo(ListView1.Handle, ti);
    //inc(ti.iItem);
    inc(i);
  end;
  bmp.Free;
end;

procedure TfrmEdit.ActionRefreshExecute(Sender: TObject);
begin
   //NomLev:=StrToInt(Edit1.Text);
   if Assigned(ListView1.Selected) then
     NomLev := ListView1.Selected.ImageIndex + 1;
   if not (NomLev in [1..4]) then NomLev:=1;
   Map:=Levels[NomLev];
   ResetPole;
   DrawGrid1.Refresh;
end;

procedure TfrmEdit.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
     case Msg.CharCode of
       27:WindowState:=wsMinimized;
       37:BRight;
       38:BVerx;
       39:BLeft;
       40:BNuz;
     end;
end;

procedure TfrmEdit.BLeft;
begin
     Napr:=4;
     if (Map[x,y]+Map[x,y+1]+Map[x,y+2]<40)or(Map[x,y+1]<5) then
     begin
        if Map[x,y+1]>9 then
        Begin
             Map[x,y+1]:=Map[x,y+1]-10;
             Map[x,y+2]:=Map[x,y+2]+10;
        end;
        Map[x,y]:=Map[x,y]-20;
        Map[x,y+1]:=Map[x,y+1]+20;

        BarPole((y+2),x,Map[x,y+2]);
        BarPole(y,x,Map[x,y]);

        inc(y);
     end;
    BarPole(y,x,Map[x,y]);
end;

procedure TfrmEdit.BRight;
begin
     Napr:=2;
     if (Map[x,y]+Map[x,y-1]+Map[x,y-2]<40)or(Map[x,y-1]<5) then
     begin
        if Map[x,y-1]>9 then
        Begin
             Map[x,y-1]:=Map[x,y-1]-10;
             Map[x,y-2]:=Map[x,y-2]+10;
        end;
        Map[x,y]:=Map[x,y]-20;
        Map[x,y-1]:=Map[x,y-1]+20;
        BarPole((y-2),x,Map[x,y-2]);
        BarPole(y,x,Map[x,y]);

        dec(y);
     end;
    BarPole(y,x,Map[x,y]);
end;

procedure TfrmEdit.BVerx;
begin
     Napr:=3;
     if (Map[x,y]+Map[x-1,y]+Map[x-2,y]<40)or(Map[x-1,y]<5) then
     begin
        if Map[x-1,y]>9 then
        Begin
             Map[x-1,y]:=Map[x-1,y]-10;
             Map[x-2,y]:=Map[x-2,y]+10;
        end;
        Map[x,y]:=Map[x,y]-20;
        Map[x-1,y]:=Map[x-1,y]+20;
        BarPole(y,(x-2),Map[x-2,y]);
        BarPole(y,x,Map[x,y]);

        dec(x);
     end;
     BarPole(y,x,Map[x,y]);
end;

procedure TfrmEdit.BNuz;
begin
     Napr:=1;
     if (Map[x,y]+Map[x+1,y]+Map[x+2,y]<40)or(Map[x+1,y]<5) then
     begin
        if Map[x+1,y]>9 then
        Begin
             Map[x+1,y]:=Map[x+1,y]-10;
             Map[x+2,y]:=Map[x+2,y]+10;
        end;
        Map[x,y]:=Map[x,y]-20;
        Map[x+1,y]:=Map[x+1,y]+20;
        BarPole(y,(x+2),Map[x+2,y]);
        BarPole(y,x,Map[x,y]);
        inc(x);
     end;
     BarPole(y,x,Map[x,y]);
end;


function TfrmEdit.Stop(ix, iy: integer): boolean;
var bool:Boolean;
begin
     Bool:=False;
     Byf[ix,iy]:=15;
     if Map[ix+1,iy]+Byf[ix+1,iy]<15 then Bool:=Stop(ix+1, iy) or Bool;
     if Map[ix,iy+1]+Byf[ix,iy+1]<15 then Bool:=Stop(ix, iy+1) or Bool;
     if Map[ix-1,iy]+Byf[ix-1,iy]<15 then Bool:=Stop(ix-1, iy) or Bool;
     if Map[ix,iy-1]+Byf[ix,iy-1]<15 then Bool:=Stop(ix, iy-1) or Bool;
     if Map[ix,iy]=1 then Bool:=true;
     if Map[ix,iy]=21 then Bool:=true;
     Stop:=Bool;
end;

procedure TfrmEdit.BarPole(ACol, ARow: integer; typ: byte);
begin
     DrawGrid1.Row:=ARow;
     DrawGrid1.Col:=ACol;
end;

procedure TfrmEdit.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
       DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,0);
       case Map[ARow,ACol] of
         1:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,1);
         10,11:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,2);
         22:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,7);
         20,21:
              case Napr of
                 1:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,3);
                 2:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,4);
                 3:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,5);
                 4:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,6);
               end;
        end;
       case Levels[NomLev][ARow,ACol] of
         1,11,21:DataModule1.ImageList1.Draw(DrawGrid1.Canvas,Rect.Left,Rect.Top,1);
       end;
end;

end.
