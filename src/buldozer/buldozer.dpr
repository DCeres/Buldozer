program buldozer;

uses
  Forms,
  ufTlo in 'Form\ufTlo.pas' {fmTlo},
  TypConst in '..\TypConst.pas',
  Options in 'Form\Options.pas' {fmOptions},
  ufAbout in 'Form\ufAbout.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmTlo, fmTlo);
  Application.CreateForm(TfmOptions, fmOptions);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
