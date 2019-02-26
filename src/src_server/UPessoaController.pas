unit UPessoaController;

interface

uses
  UEntidadesService,

  System.SysUtils,

  Redis.Commons,
  Redis.NetLib.indy,

  Data.DB,
  FireDAC.Comp.Client,

  MVCFramework,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.Controllers.CacheController;

type
  [MVCDoc('Recurso para manutenção de Pessoas')]
  [MVCPath('/api')]
  TPessoaController = class(TMVCCacheController)
  private
    FFDConnection: TFDConnection;
    FPessoaService: TPessoaService;
    FUFService: TUFService;
    FBairroService: TBairroService;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    [MVCDoc('Retorna página padrão com configurações de conexão')]
    [MVCPath('/')]
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCDoc('Retorna a lista de UFs cadastradas')]
    [MVCPath('/uf')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUFs;

    [MVCDoc('Retorna a lista de Bairros cadastrados')]
    [MVCPath('/bairro')]
    [MVCHTTPMethod([httpGET])]
    procedure GetBairros;

    [MVCDoc('Retorna a lista completa de Pessoas cadastrados')]
    [MVCPath('/pessoa')]
    [MVCHTTPMethod([httpGET])]
    procedure GetPessoas;

    [MVCDoc('Retorna a lista completa de Pessoas cadastrados em um determinado bairro')]
    [MVCPath('/pessoa/bairro/($ABairro)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetPessoasPorBairro(const ABairro: string);

    [MVCDoc('Retorna uma Pessoa especifica pelo ID')]
    [MVCPath('/pessoa/($AId)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetPessoa(const AId: Integer);

    [MVCDoc('Cadastra uma Pessoa no banco de dados')]
    [MVCPath('/pessoa')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreatePessoa;

    [MVCDoc('Atualiza uma Pessoa especifica no banco de dados')]
    [MVCPath('/pessoa/($AId)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdatePessoa(const AId: Integer);

    [MVCDoc('Apaga uma Pessoa especifica do banco de dados')]
    [MVCPath('/pessoa/($AId)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeletePessoa(const AId: Integer);
  end;

implementation

uses
  UEntidades,
  UConnectionDef;

procedure TPessoaController.Index;
begin
  Render(
    '<h1>Teste API DMVC</h1>' + sLineBreak +
    '<p>API de testes utilizando DMC e REST</p>' + sLineBreak +
    '</br>' + sLineBreak +

    '<dl>' + sLineBreak +
    '<dt>Servidor: </dt><dd>' + ConfiguracaoApp.Servidor       + '</dd>' + sLineBreak +
    '<dt>Porta: </dt><dd>'    + ConfiguracaoApp.Porta.ToString + '</dd>' + sLineBreak +
    '<dt>Caminho: </dt><dd>'  + ConfiguracaoApp.Caminho        + '</dd>' + sLineBreak +
    '</dl>'
  );

  ContentType := 'text/html';
end;

procedure TPessoaController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  inherited;

  FPessoaService.Free;
  FUFService.Free;
  FBairroService.Free;

  FFDConnection.Close;
  FFDConnection.Free;
end;

procedure TPessoaController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  if not Assigned(FFDConnection) then
    FFDConnection := TFDConnection.Create(nil);

  // setar somente o connection name pois o fdmanager se encarrega
  // de configurar e organizar o pool
  FFDConnection.ConnectionDefName := CONNECTION_DEF_NAME;

  if not Assigned(FUFService) then
    FUFService := TUFService.Create(FFDConnection);

  if not Assigned(FBairroService) then
    FBairroService := TBairroService.Create(FFDConnection);

  if not Assigned(FPessoaService) then
    FPessoaService := TPessoaService.Create(FFDConnection);

  inherited;
end;

procedure TPessoaController.GetUFs;
begin
  // verificar se existe cache, se sim, não continuar, o controller
  // vai utilizar o que já está em cache
  // a chave dever ser criada se forma que possa ser unica para a situação
  // eu costumo utilizar neste caso
  // "cache" :: <nome da entidade> :: <algum identificador especifico se necessário>
  SetCacheKey('cache::uf');
  if CacheAvailable then
    Exit;

  Render<TUF>(FUFService.GetAll);
  SetCache(600);   // expirar após 600 segundos (10 minutos)
end;

procedure TPessoaController.GetBairros;
begin
  SetCacheKey('cache::bairro');
  if CacheAvailable then
    Exit;

  Render<TBairro>(FBairroService.GetAll);
  SetCache(600);
end;

procedure TPessoaController.GetPessoas;
begin
  // cache geral de pessoas
  SetCacheKey('cache::pessoa');
  if CacheAvailable then
    Exit;

  Render<TPessoa>(FPessoaService.GetAll);
  SetCache(600);
end;

procedure TPessoaController.GetPessoasPorBairro(const ABairro: string);
begin
  // este é um caso de identificador especifico, pois quero o cache por bairro
  SetCacheKey('cache::pessoa::' + ABairro);
  if CacheAvailable then
    Exit;

  Render<TPessoa>(FPessoaService.GetByBairro(ABairro));
  SetCache(600);
end;

procedure TPessoaController.GetPessoa(const AId: Integer);
begin
  SetCacheKey('cache::pessoa::' + AId.ToString);
  if CacheAvailable then
    Exit;

  Render(FPessoaService.GetById(AId));
  SetCache(300);
end;

procedure TPessoaController.DeletePessoa(const AId: Integer);
var
  CountApagados: Integer;
begin
  CountApagados := FPessoaService.Delete(AId);

  if CountApagados > 0 then
    Render(200, Format('Apagados "%d" cliente(s) com sucesso para o Id: "%d"', [CountApagados, AId]))
  else
    raise EDatabaseError.CreateFmt('Nenhum cliente foi apagado para o ID: "%d"', [AId]);
end;

procedure TPessoaController.CreatePessoa;
var
  oPessoa: TPessoa;
begin
  oPessoa := Context.Request.BodyAs<TPessoa>;
  try
    FPessoaService.Post(oPessoa);

    Render(200, 'Pessoa cadastrada com sucesso');
  finally
    oPessoa.Free;
  end;
end;

procedure TPessoaController.UpdatePessoa(const AId: Integer);
var
  oPessoa: TPessoa;
begin
  oPessoa := Context.Request.BodyAs<TPessoa>;
  try
    oPessoa.Id := Aid;
    FPessoaService.Update(oPessoa);

    Render(200, 'Pessoa atualizada com sucesso');
  finally
    oPessoa.Free;
  end;
end;

end.

