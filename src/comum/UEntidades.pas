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
    property Id: string        read FId        write FId;
    property Descricao: string read FDescricao write FDescricao;
  end;

  [MVCNameCaseAttribute(ncLowerCase)]
  TBairro = class
  private
    FDescricao: string;
  public
    [MVCColumn('BAIRRO')] // usar quando o nome da propriedade for diferente do nome do campo
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

    property Id       : Integer read Fid       write Fid;
    property Nome     : string  read Fnome     write Fnome;
    property Endereco : string  read Fendereco write Fendereco;
    property Numero   : string  read Fnumero   write Fnumero;
    property Bairro   : string  read Fbairro   write Fbairro;
    property Cidade   : string  read Fcidade   write Fcidade;
    property UF       : string  read Fuf       write Fuf;
    property CEP      : string  read Fcep      write Fcep;
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
