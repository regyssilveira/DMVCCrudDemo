unit UEntidades;

interface

uses
  System.Classes,
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
  public
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
  end;

implementation

uses
  REST.Json;

{ TPessoa }

class function TPessoa.FromJsonString(const AJSONString: string): TPessoa;
begin
  Result := REST.Json.TJson.JsonToObject<TPessoa>(AJSONString);
end;

end.
