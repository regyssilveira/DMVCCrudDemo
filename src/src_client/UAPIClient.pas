unit UAPIClient;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,

  Data.DB,
  FireDAC.Comp.Client,

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
    procedure FDMemtableFromArray(const AJSONArray: String;
      const ADataset: TFDMemTable);
  public
    destructor Destroy; override;

    procedure GetUFs(const ADataset: TFDMemTable);

    procedure GetBairros(const ADataset: TFDMemTable);

    procedure GetPessoas(const ADataset: TFDMemTable);
    function GetPessoa(const AID: Integer): TPessoa;
    procedure GetPessoasBairro(const ABairro: string; const ADataset: TFDMemTable);

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
  JsonDataObjects,
  MVCFramework.DataSet.Utils, Vcl.Dialogs;

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

procedure TAPIClient.FDMemtableFromArray(const AJSONArray: String;
  const ADataset: TFDMemTable);
var
  oArray: TJsonArray;
  oItem: TJsonObject;
  Campo: TField;
  I: Integer;
begin
  oArray := TJsonArray.Parse(AJSONArray) as TJsonArray;
  try
    ADataset.Close;

    // criar campos se não existir
    ADataset.FieldDefs.Clear;
    oItem := oArray[0];
    for I := 0 to oItem.Count - 1 do
    begin
      if ADataset.FindField(oItem.Names[I]) = nil then
      begin
        with ADataset.FieldDefs.AddFieldDef do
        begin
          Name := oItem.Names[I];

          case oItem.Types[oItem.Names[I]] of
            jdtString:
              begin
                DataType := TFieldType.ftString;
                Size     := 255;
              end;

            jdtInt, jdtLong, jdtULong:
              begin
                DataType := TFieldType.ftInteger;
              end;

            jdtFloat:
              begin
                DataType  := TFieldType.ftFloat;
                Size      := 15;
                Precision := 4;
              end;

            jdtDateTime:
              begin
                DataType := TFieldType.ftDateTime;
              end;
            jdtBool:
              begin
                DataType := TFieldType.ftBoolean;
              end
          else
            DataType := TFieldType.ftString;
          end;
        end;
      end;
    end;

    // preencher os dados
    ADataset.CreateDataSet;
    ADataset.BeginBatch;
    try
      for oItem in oArray do
      begin
        ADataset.Append;
        for I := 0 to oItem.Count - 1do
        begin
          Campo := ADataset.FindField(oItem.Names[I]);
          if Campo <> nil then
            Campo.Value := oItem[oItem.Names[I]];
        end;
        ADataset.Post;
      end;
    finally
      ADataset.EndBatch;
    end;
  finally
    oArray.DisposeOf;
  end;
end;

procedure TAPIClient.GetUFs(const ADataset: TFDMemTable);
begin
  Response := RESTClient.doGET('/api/uf', []);
  if FResponse.HasError then
    ShowError(FResponse);

  FDMemtableFromArray(Response.BodyAsString, ADataset);
end;

procedure TAPIClient.GetBairros(const ADataset: TFDMemTable);
begin
  Response := RESTClient.doGET('/api/bairro', []);
  if FResponse.HasError then
    ShowError(FResponse);

  FDMemtableFromArray(Response.BodyAsString, ADataset);
end;

procedure TAPIClient.GetPessoas(const ADataset: TFDMemTable);
begin
  Response := RESTClient.doGET('/api/pessoa', []);
  if FResponse.HasError then
    ShowError(FResponse);

  FDMemtableFromArray(Response.BodyAsString, ADataset);
end;

function TAPIClient.GetPessoa(const AID: Integer): TPessoa;
begin
  Response := RESTClient.doGET('/api/pessoa', AID.ToString);
  if FResponse.HasError then
    ShowError(FResponse);

  Result := TPessoa.FromJsonString(Response.BodyAsString);
end;

procedure TAPIClient.GetPessoasBairro(const ABairro: string; const ADataset: TFDMemTable);
begin
  Response := RESTClient.doGET('/api/pessoa/bairro', ABairro);
  if FResponse.HasError then
    ShowError(FResponse);

  FDMemtableFromArray(Response.BodyAsString, ADataset);
end;

procedure TAPIClient.CreatePessoa(const APessoa: TPessoa);
begin
  Response := RESTClient
                .Resource('/api/pessoa')
                .doPOST<TPessoa>(APessoa, False);

  if FResponse.HasError then
    ShowError(FResponse)
  else
    ShowMessage(Response.ResponseText);
end;

procedure TAPIClient.UpdatePessoa(const APessoa: TPessoa);
begin
  Response := RESTClient
                .Resource('/api/pessoa')
                .doPUT<TPessoa>(APessoa, False);

  if FResponse.HasError then
    ShowError(FResponse)
  else
    ShowMessage(Response.ResponseText);
end;

procedure TAPIClient.DeletePessoa(const AID: Integer);
begin
  Response := RESTClient.doDELETE('/api/pessoa', AID.ToString);
  if FResponse.HasError then
    ShowError(FResponse)
  else
    ShowMessage(Response.ResponseText);

end;

end.
