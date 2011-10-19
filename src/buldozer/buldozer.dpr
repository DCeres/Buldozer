program buldozer;

uses
  Forms,
  ufTlo in 'Form\ufTlo.pas' {fmTlo},
  TypConst in '..\TypConst.pas',
  Options in 'Form\Options.pas' {fmOptions},
  ufAbout in 'Form\ufAbout.pas' {AboutBox},
  uData in '..\uData.pas' {DataModule1: TDataModule},
  uBuldozer in '..\uBuldozer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmTlo, fmTlo);
  Application.CreateForm(TfmOptions, fmOptions);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
