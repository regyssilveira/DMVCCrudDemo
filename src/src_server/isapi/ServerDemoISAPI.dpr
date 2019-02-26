library ServerDemoISAPI;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  UConnectionDef in '..\UConnectionDef.pas',
  UDemoWemodule in '..\UDemoWemodule.pas' {DemoWebmodule: TWebModule},
  UPessoaController in '..\UPessoaController.pas',
  UEntidades in '..\..\comum\UEntidades.pas',
  UEntidadesService in '..\UEntidadesService.pas';

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  // criar a configuraçã padrão e adicionar no pool no primeiro momento
  // para ficar disponivel assim que necessário
  CriarConfiguracaoFBPadrao;

  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
