unit UConnectionDef;

interface

uses
  System.IniFiles,

  Data.DB,

  FireDAC.DApt,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.FBDef,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB;

type
  TConfigApp = class(TIniFile)
  const
    SEC_NAME    = 'CONFIG';
    ID_SERVIDOR = 'Servidor';
    ID_PORTA    = 'Porta';
    ID_CAMINHO  = 'Caminho';
  private
    function GetServidor: string;
    procedure SetServidor(const Value: string);
    function GetPorta: Integer;
    procedure SetPorta(const Value: Integer);
    function GetCaminho: string;
    procedure SetCaminho(const Value: string);
  public
    property Servidor: string read GetServidor write SetServidor;
    property Porta: Integer read GetPorta write SetPorta;
    property Caminho: string read GetCaminho write SetCaminho;
  end;



procedure CriarConfiguracaoFBPadrao;

const
  CONNECTION_DEF_NAME = 'ConexaoBancoDadosFB';

var
  ConfiguracaoApp: TConfigApp;

implementation

uses
  System.Classes,
  System.SysUtils,

  MVCFramework.Logger, System.IOUtils;

procedure CriarConfiguracaoFBPadrao;
var
  oParams: TStrings;
begin
  LogI('CriarConfiguracaoFBPadrao: Criando a configuração de conexão ao firebird.');

  // configurações de acesso, adicionar ao manager para que
  // funcione corretamente o pool de conexões
  FDManager.Close;
  oParams := TStringList.Create;
  try
    oParams.Clear;
    oParams.Add('DriverID=FB');
    oParams.Add('Protocol=LOCAL');
    oParams.Add('Server='   + ConfiguracaoApp.Servidor);
    oParams.Add('Port='     + ConfiguracaoApp.Porta.ToString);
    oParams.Add('Database=' + ConfiguracaoApp.Caminho);
    oParams.Add('User_Name=sysdba');
    oParams.Add('Password=masterkey');
    oParams.Add('CharacterSet=WIN1252');
    oParams.Add('OSAuthent=No');
    oParams.Add('SQLDialect=3');

    //oParams.Add('POOL_CleanupTimeout=30000');
    //oParams.Add('POOL_ExpireTimeout=90000');
    //oParams.Add('POOL_MaximumItems=50');

    LogI('CreateFirebirdConnection: Adicionando configuração do FDManager.');
    FDManager.AddConnectionDef(CONNECTION_DEF_NAME, 'FB', oParams);
    FDManager.Open;
  finally
    oParams.Free;
  end;
end;

{ TConfigApp }

function TConfigApp.GetCaminho: string;
begin
  Result := Self.ReadString(SEC_NAME, ID_CAMINHO, EmptyStr);
end;

function TConfigApp.GetPorta: Integer;
begin
  Result := Self.ReadInteger(SEC_NAME, ID_PORTA, 3050);
end;

function TConfigApp.GetServidor: string;
begin
  Result := Self.ReadString(SEC_NAME, ID_SERVIDOR, 'localhost');
end;

procedure TConfigApp.SetCaminho(const Value: string);
begin
  Self.WriteString(SEC_NAME, ID_CAMINHO, Value);
end;

procedure TConfigApp.SetPorta(const Value: Integer);
begin
  Self.WriteInteger(SEC_NAME, ID_PORTA, Value);
end;

procedure TConfigApp.SetServidor(const Value: string);
begin
  Self.WriteString(SEC_NAME, ID_SERVIDOR, Value);
end;

initialization
  ConfiguracaoApp := TConfigApp.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'ServerConfig.ini'));

finalization
  ConfiguracaoApp.Free;

end.
