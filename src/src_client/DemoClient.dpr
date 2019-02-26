program DemoClient;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {FrmPrincipal},
  UEntidades in '..\comum\UEntidades.pas',
  UAPIClient in 'UAPIClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
