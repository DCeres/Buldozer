program EditMaps;

uses
  Forms,
  EditMap in 'Form\EditMap.pas' {frmEdit},
  TypConst in '..\TypConst.pas',
  uData in '..\uData.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEdit, frmEdit);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
