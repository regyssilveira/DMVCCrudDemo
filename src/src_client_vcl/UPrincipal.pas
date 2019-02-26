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
  FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmPrincipal = class(TForm)
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    BtnPessoaCadastrar: TButton;
    BtnPessoaAtualizar: TButton;
    BtnPessoaApagar: TButton;
    Label1: TLabel;
    BtnGetPessoaID: TButton;
    EdtID: TEdit;
    EdtNome: TEdit;
    Label2: TLabel;
    EdtEndereco: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdtNumero: TEdit;
    EdtBairro: TEdit;
    Label5: TLabel;
    EdtCidade: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    EdtUF: TEdit;
    Label8: TLabel;
    EdtCEP: TEdit;
    BtnLimparCampos: TButton;
    Panel1: TPanel;
    BtnGetUFs: TButton;
    BtnGetBairros: TButton;
    BtnGetPessoas: TButton;
    BtnGetPessoasBairro: TButton;
    procedure BtnGetUFsClick(Sender: TObject);
    procedure BtnGetBairrosClick(Sender: TObject);
    procedure BtnGetPessoasClick(Sender: TObject);
    procedure BtnGetPessoasBairroClick(Sender: TObject);
    procedure BtnGetPessoaIDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPessoaCadastrarClick(Sender: TObject);
    procedure BtnPessoaAtualizarClick(Sender: TObject);
    procedure BtnPessoaApagarClick(Sender: TObject);
    procedure BtnLimparCamposClick(Sender: TObject);
  private
    FAPIClient: TAPIClient;
    procedure LimparCampos;
  public
    property APIClient: TAPIClient read FAPIClient write FAPIClient;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  UEntidades;

{$R *.dfm}

procedure TFrmPrincipal.LimparCampos;
begin
  EdtID.Clear;
  EdtNome.Clear;
  EdtEndereco.Clear;
  EdtNumero.Clear;
  EdtBairro.Clear;
  EdtCidade.Clear;
  EdtUF.Clear;
  EdtCEP.Clear;
end;


procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  LimparCampos;
  PageControl1.ActivePageIndex := 0;

  FAPIClient := TAPIClient.Create;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  FAPIClient.Free;
end;

procedure TFrmPrincipal.BtnGetBairrosClick(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  APIClient.GetBairros(FDMemTable1);
end;

procedure TFrmPrincipal.BtnGetPessoaIDClick(Sender: TObject);
var
  StrCodigo: string;
  oPessoa: TPessoa;
begin
  LimparCampos;

  InputQuery(
    'Código',
    'Informe o código da pessoa',
    StrCodigo
  );

  oPessoa := APIClient.GetPessoa(StrToInt(StrCodigo));
  try
    EdtID.Text       := oPessoa.Id.ToString;
    EdtNome.Text     := oPessoa.Nome;
    EdtEndereco.Text := oPessoa.Endereco;
    EdtNumero.Text   := oPessoa.Numero;
    EdtBairro.Text   := oPessoa.Bairro;
    EdtCidade.Text   := oPessoa.Cidade;
    EdtUF.Text       := oPessoa.UF;
    EdtCEP.Text      := oPessoa.CEP;
  finally
    oPessoa.Free;
  end;
end;

procedure TFrmPrincipal.BtnGetPessoasBairroClick(Sender: TObject);
var
  StrBairro: string;
begin
  InputQuery(
    'Código',
    'Informe o nome do bairro',
    StrBairro
  );

  APIClient.GetPessoasBairro(StrBairro, FDMemTable1);
end;

procedure TFrmPrincipal.BtnGetPessoasClick(Sender: TObject);
begin
  APIClient.GetPessoas(FDMemTable1);
end;

procedure TFrmPrincipal.BtnGetUFsClick(Sender: TObject);
begin
  APIClient.GetUFs(FDMemTable1);
end;

procedure TFrmPrincipal.BtnLimparCamposClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFrmPrincipal.BtnPessoaCadastrarClick(Sender: TObject);
var
  oPessoa: TPessoa;
begin
  oPessoa := TPessoa.Create;
  try
    oPessoa.Nome     := EdtNome.Text;
    oPessoa.Endereco := EdtEndereco.Text;
    oPessoa.Numero   := EdtNumero.Text;
    oPessoa.Bairro   := EdtBairro.Text;
    oPessoa.Cidade   := EdtCidade.Text;
    oPessoa.UF       := EdtUF.Text;
    oPessoa.CEP      := EdtCEP.Text;

    APIClient.CreatePessoa(oPessoa);
    LimparCampos;
  finally
    oPessoa.Free;
  end;
end;

procedure TFrmPrincipal.BtnPessoaAtualizarClick(Sender: TObject);
var
  oPessoa: TPessoa;
begin
  if Trim(EdtID.Text).IsEmpty then
    raise Exception.Create('Primeiro busque uma pessoa utilizando o "Buscar por ID"');


  oPessoa := TPessoa.Create;
  try
    oPessoa.Id       := StrToInt(EdtID.Text);
    oPessoa.Nome     := EdtNome.Text;
    oPessoa.Endereco := EdtEndereco.Text;
    oPessoa.Numero   := EdtNumero.Text;
    oPessoa.Bairro   := EdtBairro.Text;
    oPessoa.Cidade   := EdtCidade.Text;
    oPessoa.UF       := EdtUF.Text;
    oPessoa.CEP      := EdtCEP.Text;

    APIClient.UpdatePessoa(oPessoa);
    LimparCampos;
  finally
    oPessoa.Free;
  end;
end;

procedure TFrmPrincipal.BtnPessoaApagarClick(Sender: TObject);
begin
  if Trim(EdtID.Text).IsEmpty then
    raise Exception.Create('Primeiro busque uma pessoa utilizando o "Buscar por ID"');

  APIClient.DeletePessoa(StrToInt(EdtID.Text));
end;

end.
