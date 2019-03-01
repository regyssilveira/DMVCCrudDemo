unit UEntidadesService;

interface

uses
  UEntidades,

  System.SysUtils,
  System.Classes,

  System.Generics.Collections,

  FireDAC.Comp.Client,

  MVCFramework.Serializer.Commons;

Type
  TBaseService = class
  private
    FFDConnection: TFDConnection;
    function GetFDConnection: TFDConnection;
  public
    constructor Create(const AFDConnection: TFDConnection); virtual;

    property FDConnection: TFDConnection read GetFDConnection write FFDConnection;
  end;

  TUFService = class(TBaseService)
  private

  public
    function GetAll: TObjectList<TUF>;
  end;

  TBairroService = class(TBaseService)
  private

  public
    function GetAll: TObjectList<TBairro>;
  end;

  TPessoaService = class(TBaseService)
  private

  public
    function GetAll: TObjectList<TPessoa>;
    function GetById(const AId: Integer): TPessoa;
    function GetByBairro(const ABairro: string): TObjectList<TPessoa>;

    procedure Post(const APessoa: TPessoa);
    procedure Update(const APessoa: TPessoa);
    function Delete(const AId: Integer): Integer;
  end;

implementation

uses
  UConnectionDef,

  Data.DB,

  FireDAC.Stan.Option,
  FireDAC.Stan.Param,

  MVCFramework.Logger,
  MVCFramework.FireDAC.Utils,
  MVCFramework.DataSet.Utils;

{ TBaseService }

constructor TBaseService.Create(const AFDConnection: TFDConnection);
begin
  inherited Create;

  FFDConnection := AFDConnection;
end;

function TBaseService.GetFDConnection: TFDConnection;
begin
  if not Assigned(FFDConnection) then
    FFDConnection := TFDConnection.Create(nil);

  // setar somente o connection name pois o fdmanager se encarrega
  // de configurar e organizar o pool
  FFDConnection.ConnectionDefName := CONNECTION_DEF_NAME;
  Result := FFDConnection
end;

{ TUF }

function TUFService.GetAll: TObjectList<TUF>;
var
  TmpDataset: TDataset;
begin
  // log somente para mostrar quando busca ou não na base de dados
  // e perceber o cache funcionando
  LogI('Buscando ufs na base de dados');

  // select normal
  Self.FDConnection.ExecSQL('select * from tb_uf', TmpDataset);
  try
    if TmpDataset.IsEmpty then
      raise Exception.Create('Nenhuma UF foi encontrado na base de dados');

    // retorna a lista baseada no datasetS
    Result := TmpDataset.AsObjectList<TUF>(True);
  finally
    TmpDataset.Free;
  end;
end;

{ TBairro }

function TBairroService.GetAll: TObjectList<TBairro>;
var
  TmpDataset: TDataset;
begin
  LogI('Buscando bairros na base de dados');

  Self.FDConnection.ExecSQL('select bairro from vw_bairros', TmpDataset);
  try
    if TmpDataset.IsEmpty then
      raise Exception.Create('Nenhum bairro foi encontrado na base de dados');

    Result := TmpDataset.AsObjectList<TBairro>(True);
  finally
    TmpDataset.Free;
  end;
end;

{ TPessoa }

function TPessoaService.Delete(const AId: Integer): Integer;
begin
  if AId <= 0 then
    raise EDatabaseError.Create('Parametro "Id da pessoa" não foi informado');

  Result := Self.FDConnection.ExecSQL(
    'delete from tb_pessoa where Id=?', [AId], [ftInteger]
  );
end;

function TPessoaService.GetByBairro(const ABairro: string): TObjectList<TPessoa>;
var
  oQuery: TFDQuery;
begin
  if ABairro.Trim.IsEmpty then
    raise EDatabaseError.Create('Parametro "nome do bairro" não foi informado');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := Self.FDConnection;
    oQuery.Open(
      'select * from tb_pessoa where bairro=?',
      [ABairro],
      [ftString]
    );

    if oQuery.IsEmpty then
    begin
      raise Exception.CreateFmt(
        'Nenhum Pessoa foi encontrado na base de dados para o bairro: "%s"',
        [ABairro]
      );
    end;

    Result := oQuery.AsObjectList<TPessoa>(True);
  finally
    oQuery.Free;
  end;
end;

function TPessoaService.GetById(const AId: Integer): TPessoa;
var
  oQuery: TFDQuery;
begin
  if AId <= 0 then
    raise EDatabaseError.Create('Parametro "Id da pessoa" não foi informado');

  LogI('Buscando Pessoa na base de dados para o código: ' + AId.ToString);

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := Self.FDConnection;
    oQuery.Open(
      'select * from tb_pessoa where ID=?',
      [AId],
      [ftInteger]
    );

    if oQuery.IsEmpty then
    begin
      raise Exception.CreateFmt(
        'Nenhuma Pessoa foi encontrado na base de dados para o código: "%d"',
        [AId]
      );
    end;

    Result := oQuery.AsObject<TPessoa>(True);
  finally
    oQuery.Free;
  end;
end;

function TPessoaService.GetAll: TObjectList<TPessoa>;
var
  oQuery: TFDQuery;
begin
  LogI('Buscando Pessoas na base de dados');

  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := Self.FDConnection;
    oQuery.Open('select * from tb_pessoa');

    if oQuery.IsEmpty then
      raise Exception.Create('Nenhum Pessoa foi encontrado na base de dados');

    Result := oQuery.AsObjectList<TPessoa>(True);
  finally
    oQuery.Free;
  end;
end;

procedure TPessoaService.Post(const APessoa: TPessoa);
const
  SQL_INSERT_PESSOA: string =
    'INSERT INTO TB_PESSOA (                                  ' + sLineBreak +
    '  NOME, ENDERECO, NUMERO, BAIRRO, CIDADE, UF, CEP        ' + sLineBreak +
    ') VALUES (                                               ' + sLineBreak +
    '  :NOME, :ENDERECO, :NUMERO, :BAIRRO, :CIDADE, :UF, :CEP ' + sLineBreak +
    ')                                                        ' ;

  SQL_INSERT_TELEFONE: string =
    'INSERT INTO TB_PESSOA_TELEFONE (  ' + sLineBreak +
    '  ID_PESSOA, TELEFONE, CONTATO    ' + sLineBreak +
    ') VALUES (                        ' + sLineBreak +
    '  :ID_PESSOA, :TELEFONE, :CONTATO ' + sLineBreak +
    ');                                ' ;

var
  Telefone: TPessoaTelefone;

begin
  // o ideal é utilizar um orm ao inves de datasets

  if APessoa.nome.Trim.IsEmpty then
    raise EDatabaseError.Create('Nome não foi informado');

  if APessoa.endereco.Trim.IsEmpty then
    raise EDatabaseError.Create('Endereço não foi informado');

  if APessoa.numero.Trim.IsEmpty then
    raise EDatabaseError.Create('Número não foi informado');

  if APessoa.bairro.Trim.IsEmpty then
    raise EDatabaseError.Create('Bairro não foi informado');

  if APessoa.cidade.Trim.IsEmpty then
    raise EDatabaseError.Create('Cidade não foi informado');

  if APessoa.uf.Trim.IsEmpty then
    raise EDatabaseError.Create('UF não foi informado');

  if APessoa.cep.Trim.IsEmpty then
    raise EDatabaseError.Create('CEP não foi informado');

  Self.FDConnection.ExecSQL(SQL_INSERT_PESSOA,
    [
      APessoa.Nome,
      APessoa.Endereco,
      APessoa.Numero,
      APessoa.Bairro,
      APessoa.Cidade,
      APessoa.UF,
      APessoa.CEP
    ],
    [
      ftString,
      ftString,
      ftString,
      ftString,
      ftString,
      ftString,
      ftString
    ]
  );

//  if APessoa.Telefones.Count > 0 then
//  begin
//    for Telefone in APessoa.Telefones do
//    begin
//      Self.FDConnection.ExecSQL(SQL_INSERT_PESSOA,
//        [
//          Telefone.Telefone,
//          Telefone.Contato
//        ],
//        [
//          ftString,
//          ftString
//        ]
//      );
//    end;
//  end;
end;

procedure TPessoaService.Update(const APessoa: TPessoa);
var
  CountUpdate: Integer;
const
  SQL_UPDATE: string =
    'UPDATE TB_PESSOA SET    ' + sLineBreak +
    '  NOME     = :NOME,     ' + sLineBreak +
    '  ENDERECO = :ENDERECO, ' + sLineBreak +
    '  NUMERO   = :NUMERO,   ' + sLineBreak +
    '  BAIRRO   = :BAIRRO,   ' + sLineBreak +
    '  CIDADE   = :CIDADE,   ' + sLineBreak +
    '  UF       = :UF,       ' + sLineBreak +
    '  CEP      = :CEP       ' + sLineBreak +
    'WHERE                   ' + sLineBreak +
    '  ID = :ID              ' ;
begin
  // o ideal é utilizar um orm ao inves de datasets
  // desta forma sempre vai atualizar todos os campos

  CountUpdate := Self.FDConnection.ExecSQL(SQL_UPDATE,
    [
      APessoa.Nome,
      APessoa.Endereco,
      APessoa.Numero,
      APessoa.Bairro,
      APessoa.Cidade,
      APessoa.UF,
      APessoa.CEP,
      APessoa.Id
    ],
    [
      ftString,
      ftString,
      ftString,
      ftString,
      ftString,
      ftString,
      ftString,
      ftInteger
    ]
  );

  if CountUpdate <= 0 then
  begin
    raise EDatabaseError.CreateFmt(
      'Nenhuma pessoa foi atualizada para o código: "%d"',
      [APessoa.Id]
    );
  end;
end;

end.
