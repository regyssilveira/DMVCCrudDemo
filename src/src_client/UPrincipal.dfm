object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Demo de utiliza'#231#227'o da API DMVC'
  ClientHeight = 535
  ClientWidth = 845
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 839
    Height = 529
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    TabWidth = 150
    object TabSheet1: TTabSheet
      Caption = 'Buscas'
      object DBGrid1: TDBGrid
        AlignWithMargins = True
        Left = 3
        Top = 39
        Width = 825
        Height = 459
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 831
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BtnGetUFs: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 118
          Height = 30
          Align = alLeft
          Caption = 'UFs'
          TabOrder = 0
          OnClick = BtnGetUFsClick
        end
        object BtnGetBairros: TButton
          AlignWithMargins = True
          Left = 127
          Top = 3
          Width = 118
          Height = 30
          Align = alLeft
          Caption = 'Bairros'
          TabOrder = 1
          OnClick = BtnGetBairrosClick
        end
        object BtnGetPessoas: TButton
          AlignWithMargins = True
          Left = 251
          Top = 3
          Width = 118
          Height = 30
          Align = alLeft
          Caption = 'Pessoas (TOTAL)'
          TabOrder = 2
          OnClick = BtnGetPessoasClick
        end
        object BtnGetPessoasBairro: TButton
          AlignWithMargins = True
          Left = 375
          Top = 3
          Width = 118
          Height = 30
          Align = alLeft
          Caption = 'Pessoas (BAIRRO)'
          TabOrder = 3
          OnClick = BtnGetPessoasBairroClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'CRUD'
      ImageIndex = 1
      object Label1: TLabel
        Left = 10
        Top = 10
        Width = 11
        Height = 13
        Caption = 'ID'
      end
      object Label2: TLabel
        Left = 10
        Top = 53
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object Label3: TLabel
        Left = 10
        Top = 96
        Width = 45
        Height = 13
        Caption = 'Endere'#231'o'
      end
      object Label4: TLabel
        Left = 10
        Top = 139
        Width = 37
        Height = 13
        Caption = 'Numero'
      end
      object Label5: TLabel
        Left = 10
        Top = 182
        Width = 28
        Height = 13
        Caption = 'Bairro'
      end
      object Label6: TLabel
        Left = 10
        Top = 225
        Width = 33
        Height = 13
        Caption = 'Cidade'
      end
      object Label7: TLabel
        Left = 10
        Top = 268
        Width = 13
        Height = 13
        Caption = 'UF'
      end
      object Label8: TLabel
        Left = 10
        Top = 311
        Width = 19
        Height = 13
        Caption = 'CEP'
      end
      object Panel2: TPanel
        Left = 0
        Top = 460
        Width = 831
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 8
        object BtnPessoaCadastrar: TButton
          AlignWithMargins = True
          Left = 127
          Top = 3
          Width = 118
          Height = 35
          Align = alLeft
          Caption = 'Cadastrar Pessoa'
          TabOrder = 1
          OnClick = BtnPessoaCadastrarClick
        end
        object BtnPessoaAtualizar: TButton
          AlignWithMargins = True
          Left = 251
          Top = 3
          Width = 118
          Height = 35
          Align = alLeft
          Caption = 'Atualizar Pessoa'
          TabOrder = 2
          OnClick = BtnPessoaAtualizarClick
        end
        object BtnPessoaApagar: TButton
          AlignWithMargins = True
          Left = 375
          Top = 3
          Width = 118
          Height = 35
          Align = alLeft
          Caption = 'Apagar Pessoa'
          TabOrder = 3
          OnClick = BtnPessoaApagarClick
        end
        object BtnGetPessoaID: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 118
          Height = 35
          Align = alLeft
          Caption = 'Buscar por ID'
          TabOrder = 0
          OnClick = BtnGetPessoaIDClick
        end
        object BtnLimparCampos: TButton
          AlignWithMargins = True
          Left = 710
          Top = 3
          Width = 118
          Height = 35
          Align = alRight
          Caption = 'Limpar Campos'
          TabOrder = 4
          OnClick = BtnLimparCamposClick
        end
      end
      object EdtID: TEdit
        Left = 10
        Top = 26
        Width = 111
        Height = 21
        Enabled = False
        TabOrder = 0
        Text = 'EdtID'
      end
      object EdtNome: TEdit
        Left = 10
        Top = 69
        Width = 796
        Height = 21
        TabOrder = 1
        Text = 'Edit1'
      end
      object EdtEndereco: TEdit
        Left = 10
        Top = 112
        Width = 796
        Height = 21
        TabOrder = 2
        Text = 'Edit1'
      end
      object EdtNumero: TEdit
        Left = 10
        Top = 155
        Width = 359
        Height = 21
        TabOrder = 3
        Text = 'Edit1'
      end
      object EdtBairro: TEdit
        Left = 10
        Top = 198
        Width = 359
        Height = 21
        TabOrder = 4
        Text = 'Edit1'
      end
      object EdtCidade: TEdit
        Left = 10
        Top = 241
        Width = 359
        Height = 21
        TabOrder = 5
        Text = 'Edit1'
      end
      object EdtUF: TEdit
        Left = 10
        Top = 284
        Width = 359
        Height = 21
        TabOrder = 6
        Text = 'Edit1'
      end
      object EdtCEP: TEdit
        Left = 10
        Top = 327
        Width = 359
        Height = 21
        TabOrder = 7
        Text = 'Edit1'
      end
    end
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 540
    Top = 360
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 540
    Top = 405
  end
end
