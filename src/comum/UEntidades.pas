unit UEntidades;

interface

uses
  System.Classes,
  System.Generics.Collections,
  MVCFramework.Serializer.Commons;

Type
  [MVCNameCaseAttribute(ncLowerCase)]
  TUF = class
  private
    FDescricao: string;
    FId: string;
  public
    [MVCColumn('UF')]
    property Id: string read FId write FId;

    [MVCColumn('DESCRICAO')]
    property Descricao: string read FDescricao write FDescricao;
  end;

  [MVCNameCaseAttribute(ncLowerCase)]
  TBairro = class
  private
    FDescricao: string;
  public
    [MVCColumn('BAIRRO')]
    property Descricao: string read FDescricao write FDescricao;
  end;

  TPessoaTelefone = class
  private
    FContato: string;
    FTelefone: string;
  public
    [MVCColumn('telefone')]
    property Telefone: string read FTelefone write FTelefone;

    [MVCColumn('contato')]
    property Contato: string read FContato write FContato;
  end;

  TPessoaTelefones = class(TObjectList<TPessoaTelefone>)
  private

  public
    function Add: TPessoaTelefone; overload;
  end;

  [MVCNameCaseAttribute(ncLowerCase)]
  TPessoa = class
  private
    Fbairro: string;
    Fuf: string;
    Fcep: string;
    Fid: Integer;
    Fnumero: string;
    Fnome: string;
    Fcidade: string;
    Fendereco: string;
    FTelefones: TPessoaTelefones;
  public
    constructor Create;
    destructor Destroy; override;

    class function FromJsonString(const AJSONString: string): TPessoa;

    [MVCColumn('Id')]
    property Id: Integer read Fid  write Fid;

    [MVCColumn('Nome')]
    property Nome: string read Fnome  write Fnome;

    [MVCColumn('Endereco')]
    property Endereco: string read Fendereco write Fendereco;

    [MVCColumn('Numero')]
    property Numero: string read Fnumero write Fnumero;

    [MVCColumn('Bairro')]
    property Bairro: string read Fbairro write Fbairro;

    [MVCColumn('Cidade')]
    property Cidade: string read Fcidade write Fcidade;

    [MVCColumn('UF')]
    property UF : string read Fuf write Fuf;

    [MVCColumn('CEP')]
    property CEP: string read Fcep write Fcep;

//    [MVCListOfAttribute(TPessoaTelefone)]
//    property Telefones: TPessoaTelefones read FTelefones write FTelefones;
  end;

implementation

uses
  REST.Json;

{ TPessoa }

constructor TPessoa.Create;
begin
  inherited Create;
  FTelefones := TPessoaTelefones.Create;
end;

destructor TPessoa.Destroy;
begin
  FTelefones.Free;
  inherited;
end;

class function TPessoa.FromJsonString(const AJSONString: string): TPessoa;
begin
  Result := REST.Json.TJson.JsonToObject<TPessoa>(AJSONString);
end;

{ TPessoaTelefones }

function TPessoaTelefones.Add: TPessoaTelefone;
begin
  Result := TPessoaTelefone.Create;
  Self.Add(Result);
end;

end.
