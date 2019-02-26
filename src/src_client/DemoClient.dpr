program DemoClient;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {Form2},
  UEntidades in '..\comum\UEntidades.pas',
  UAPIClient in 'UAPIClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
