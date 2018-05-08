object fFind: TfFind
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1081#1090#1080
  ClientHeight = 373
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object edFindStr: TEdit
    Left = 0
    Top = 0
    Width = 253
    Height = 24
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChange = edFindStrChange
    ExplicitTop = -6
    ExplicitWidth = 269
  end
  object rgUsrGr: TRadioGroup
    Left = 0
    Top = 24
    Width = 253
    Height = 36
    Align = alTop
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      #1043#1088#1091#1087#1087#1072)
    ParentFont = False
    TabOrder = 1
    OnClick = rgUsrGrClick
    ExplicitTop = 18
    ExplicitWidth = 269
  end
  object grFind: TDBGrid
    Left = 0
    Top = 60
    Width = 253
    Height = 229
    Align = alTop
    DataSource = DM.dsFindUsr
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DisplayName'
        Title.Caption = #1048#1084#1103
        Visible = True
      end>
  end
  object BitBtn1: TBitBtn
    Left = 40
    Top = 304
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 136
    Top = 304
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkCancel
    ParentDoubleBuffered = False
    TabOrder = 4
  end
end
