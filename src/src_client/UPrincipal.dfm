object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 713
  ClientWidth = 1089
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
  object DBGrid1: TDBGrid
    Left = 8
    Top = 70
    Width = 1073
    Height = 635
    DataSource = DataSource1
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object BtnGetUFs: TButton
    Left = 8
    Top = 8
    Width = 118
    Height = 25
    Caption = 'UFs'
    TabOrder = 0
    OnClick = BtnGetUFsClick
  end
  object BtnGetBairros: TButton
    Left = 8
    Top = 39
    Width = 118
    Height = 25
    Caption = 'Bairros'
    TabOrder = 6
    OnClick = BtnGetBairrosClick
  end
  object BtnGetPessoas: TButton
    Left = 132
    Top = 8
    Width = 118
    Height = 25
    Caption = 'Pessoas'
    TabOrder = 1
    OnClick = BtnGetPessoasClick
  end
  object BtnGetPessoaID: TButton
    Left = 256
    Top = 8
    Width = 118
    Height = 25
    Caption = 'Pessoa (ID)'
    TabOrder = 2
    OnClick = BtnGetPessoaIDClick
  end
  object BtnGetPessoasBairro: TButton
    Left = 132
    Top = 39
    Width = 118
    Height = 25
    Caption = 'Pessoas (BAIRRO)'
    TabOrder = 7
    OnClick = BtnGetPessoasBairroClick
  end
  object BtnPessoaCadastrar: TButton
    Left = 715
    Top = 8
    Width = 118
    Height = 25
    Caption = 'Cadastrar Pessoa'
    TabOrder = 3
  end
  object BtnPessoaAtualizar: TButton
    Left = 839
    Top = 8
    Width = 118
    Height = 25
    Caption = 'Atualizar Pessoa'
    TabOrder = 4
  end
  object BtnPessoaApagar: TButton
    Left = 963
    Top = 8
    Width = 118
    Height = 25
    Caption = 'Apagar Pessoa'
    TabOrder = 5
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
    Left = 550
    Top = 370
  end
end
