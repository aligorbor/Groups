object fConnect: TfConnect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '#1089' '#1073#1072#1079#1086#1081' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 363
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TBitBtn
    Left = 72
    Top = 320
    Width = 75
    Height = 25
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Kind = bkOK
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TBitBtn
    Left = 216
    Top = 320
    Width = 75
    Height = 25
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Kind = bkCancel
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 1
  end
  object pc1: TPageControl
    Left = 0
    Top = 0
    Width = 386
    Height = 305
    ActivePage = tsConn
    Align = alTop
    TabOrder = 2
    OnChange = pc1Change
    object tsConn: TTabSheet
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      object Label1: TLabel
        Left = 30
        Top = 27
        Width = 63
        Height = 13
        Caption = #1048#1084#1103' '#1089#1077#1088#1074#1077#1088#1072
      end
      object Label2: TLabel
        Left = 28
        Top = 67
        Width = 65
        Height = 13
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
      end
      object Label3: TLabel
        Left = 21
        Top = 110
        Width = 72
        Height = 13
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      end
      object Label4: TLabel
        Left = 56
        Top = 153
        Width = 37
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100
      end
      object edServer: TEdit
        Left = 112
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = edServerChange
      end
      object edDatabase: TEdit
        Left = 112
        Top = 64
        Width = 121
        Height = 21
        TabOrder = 1
        OnChange = edDatabaseChange
      end
      object edUser: TEdit
        Left = 112
        Top = 107
        Width = 121
        Height = 21
        TabOrder = 2
        OnChange = edUserChange
      end
      object edPassw: TEdit
        Left = 112
        Top = 150
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
        OnChange = edPasswChange
      end
      object btTry: TButton
        Left = 64
        Top = 200
        Width = 169
        Height = 25
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
        TabOrder = 4
        OnClick = btTryClick
      end
    end
    object tsAll: TTabSheet
      Caption = #1042#1089#1077
      ImageIndex = 1
      object vle1: TValueListEditor
        Left = 0
        Top = 0
        Width = 378
        Height = 277
        Align = alClient
        TabOrder = 0
        TitleCaptions.Strings = (
          #1050#1083#1102#1095
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          150
          222)
      end
    end
  end
end
