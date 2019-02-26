unit UPrincipal;

interface

uses
  UAPIClient,

  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm2 = class(TForm)
    FDMemTable1: TFDMemTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    BtnGetUFs: TButton;
    BtnGetBairros: TButton;
    BtnGetPessoas: TButton;
    BtnGetPessoaID: TButton;
    BtnGetPessoasBairro: TButton;
    BtnPessoaCadastrar: TButton;
    BtnPessoaAtualizar: TButton;
    BtnPessoaApagar: TButton;
    procedure BtnGetUFsClick(Sender: TObject);
    procedure BtnGetBairrosClick(Sender: TObject);
    procedure BtnGetPessoasClick(Sender: TObject);
    procedure BtnGetPessoasBairroClick(Sender: TObject);
    procedure BtnGetPessoaIDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FAPIClient: TAPIClient;
  public
    property APIClient: TAPIClient read FAPIClient write FAPIClient;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.FormCreate(Sender: TObject);
begin
  FAPIClient := TAPIClient.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FAPIClient.Free;
end;

procedure TForm2.BtnGetBairrosClick(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  APIClient.GetBairros(FDMemTable1);
end;

procedure TForm2.BtnGetPessoaIDClick(Sender: TObject);
var
  StrCodigo: string;
begin
  InputQuery(
    'Código',
    'Informe o código da pessoa',
    StrCodigo
  );

  APIClient.GetPessoa(StrToInt(StrCodigo));
end;

procedure TForm2.BtnGetPessoasBairroClick(Sender: TObject);
var
  StrBairro: string;
begin
  InputQuery(
    'Código',
    'Informe o código da pessoa',
    StrBairro
  );

  APIClient.GetPessoasBairro(StrBairro, FDMemTable1);
end;

procedure TForm2.BtnGetPessoasClick(Sender: TObject);
begin
  APIClient.GetPessoas(FDMemTable1);
end;

procedure TForm2.BtnGetUFsClick(Sender: TObject);
begin
  APIClient.GetUFs(FDMemTable1);
end;

end.
