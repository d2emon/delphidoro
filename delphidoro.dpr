program delphidoro;

uses
  Forms,
  unMain in 'unMain.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�������';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
