program EditMaps;

uses
  Forms,
  EditMap in 'Form\EditMap.pas' {frmEdit},
  TypConst in '..\TypConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEdit, frmEdit);
  Application.Run;
end.
