program Groups;

uses
  Forms,
  GRPMAIN in 'GRPMAIN.pas' {fGrpApp},
  ABOUT in 'ABOUT.PAS' {AboutBox},
  DMUnit in 'DMUnit.pas' {DM: TDataModule},
  FindUnit in 'FindUnit.pas' {fFind},
  ConnectUnit in 'ConnectUnit.pas' {fConnect};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfGrpApp, fGrpApp);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfFind, fFind);
  Application.CreateForm(TfConnect, fConnect);
  Application.Run;
end.
 
