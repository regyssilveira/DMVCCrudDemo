unit UAPIClient;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,

  Data.DB,

  UEntidades,

  MVCFramework.RESTClient;


type
  EAPIClient = class(Exception);

  TAPIClient = class
  private
    FRESTClient: TRESTClient;
    FResponse: IRESTResponse;
    function GetRESTClient: TRESTClient;
    procedure ShowError(const AResponse: IRESTResponse);
    procedure SetProxyPassword(const Value: string);
    procedure SetProxyPort(const Value: integer);
    procedure SetProxyServer(const Value: string);
    procedure SetProxyUsername(const Value: string);
  public
    destructor Destroy; override;

    procedure GetUFs(const ADataset: TDataSet);

    procedure GetBairros(const ADataset: TDataSet);

    procedure GetPessoas(const ADataset: TDataSet);
    function GetPessoa(const AID: Integer): TPessoa;
    procedure GetPessoasBairro(const ABairro: string; const ADataset: TDataSet);

    procedure CreatePessoa(const APessoa: TPessoa);
    procedure UpdatePessoa(const APessoa: TPessoa);
    procedure DeletePessoa(const AID: Integer);

    property RESTClient: TRESTClient read GetRESTClient write FRESTClient;
    property Response: IRESTResponse read FResponse     write FResponse;

    property ProxyServer: string   write SetProxyServer;
    property ProxyPort: integer    write SetProxyPort;
    property ProxyUsername: string write SetProxyUsername;
    property ProxyPassword: string write SetProxyPassword;
  end;

implementation

uses
  MVCFramework.DataSet.Utils;

destructor TAPIClient.Destroy;
begin
  if Assigned(FRESTClient) then
    FRESTClient.Free;

  inherited;
end;

function TAPIClient.GetRESTClient: TRESTClient;
begin
  if not Assigned(FRESTClient) then
    FRESTClient := TRESTClient.Create('localhost', 8080);

  FRESTClient.Username := 'admin';
  FRESTClient.Password := 'admin';

  // se o servidor estiver on-line utilizar está propriedade para setar o caminho
  //FRESTClient.URL := '';

  Result := FRESTClient;
end;

procedure TAPIClient.ShowError(const AResponse: IRESTResponse);
begin
  if AResponse.HasError then
  begin
    raise EAPIClient.Create(
      AResponse.Error.ExceptionMessage
      //AResponse.Error.HTTPError.ToString + ': ' +
      //AResponse.Error.ExceptionMessage + sLineBreak +
      //'[' + AResponse.Error.ExceptionClassname + ']'
    );
  end
  else
  begin
    raise EAPIClient.Create(
      AResponse.ResponseText
      //AResponse.ResponseCode.ToString + ': ' +
      //AResponse.ResponseText + sLineBreak +
      //AResponse.BodyAsString
    );
  end;
end;

procedure TAPIClient.SetProxyPassword(const Value: string);
begin
  RESTClient.ProxyPassword := Value;
end;

procedure TAPIClient.SetProxyPort(const Value: integer);
begin
  RESTClient.ProxyPort := Value;
end;

procedure TAPIClient.SetProxyServer(const Value: string);
begin
  RESTClient.ProxyServer := Value;
end;

procedure TAPIClient.SetProxyUsername(const Value: string);
begin
  RESTClient.ProxyUsername := Value;
end;

procedure TAPIClient.GetUFs(const ADataset: TDataSet);
begin
  Response := RESTClient.doGET('/api/uf', []);
  if FResponse.HasError then
    ShowError(FResponse);

  ADataset.LoadFromJSONArray(Response.BodyAsString);
end;

procedure TAPIClient.GetBairros(const ADataset: TDataSet);
begin
  Response := RESTClient.doGET('/api/bairro', []);
  if FResponse.HasError then
    ShowError(FResponse);

  ADataset.LoadFromJSONArray(Response.BodyAsString);
end;

procedure TAPIClient.GetPessoas(const ADataset: TDataSet);
begin
  Response := RESTClient.doGET('/api/pessoa', []);
  if FResponse.HasError then
    ShowError(FResponse);

  ADataset.LoadFromJSONArray(Response.BodyAsString);
end;

function TAPIClient.GetPessoa(const AID: Integer): TPessoa;
begin
  Response := RESTClient.doGET('/api/pessoa', AID.ToString);
  if FResponse.HasError then
    ShowError(FResponse);

  Result := TPessoa.FromJsonString(Response.BodyAsString);
end;

procedure TAPIClient.GetPessoasBairro(const ABairro: string; const ADataset: TDataSet);
begin
  Response := RESTClient.doGET('/api/pessoa/bairro', ABairro);
  if FResponse.HasError then
    ShowError(FResponse);

  ADataset.LoadFromJSONArray(Response.BodyAsString);
end;

procedure TAPIClient.CreatePessoa(const APessoa: TPessoa);
begin
  Response := RESTClient
                .Resource('/api/pessoa')
                .doPOST<TPessoa>(APessoa, False);

  if FResponse.HasError then
    ShowError(FResponse);
end;

procedure TAPIClient.UpdatePessoa(const APessoa: TPessoa);
begin
  Response := RESTClient
                .Resource('/api/pessoa')
                .doPUT<TPessoa>(APessoa, False);

  if FResponse.HasError then
    ShowError(FResponse);
end;

procedure TAPIClient.DeletePessoa(const AID: Integer);
begin
  Response := RESTClient.doDELETE('/api/pessoa', AID.ToString);
  if FResponse.HasError then
    ShowError(FResponse);

end;

end.
