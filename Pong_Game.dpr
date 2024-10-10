program Pong_Game;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape];
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
