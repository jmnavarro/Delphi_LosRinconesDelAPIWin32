object MainForm: TMainForm
  Left = 241
  Top = 133
  Width = 349
  Height = 327
  Caption = 'Memoria Virtual'
  Color = clBtnFace
  Constraints.MinHeight = 285
  Constraints.MinWidth = 349
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TBevel
    Left = 171
    Top = 17
    Width = 165
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object l_info: TLabel
    Left = 160
    Top = 10
    Width = 31
    Height = 13
    Caption = 'l_info'
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bv_1: TBevel
    Left = 4
    Top = 263
    Width = 332
    Height = 2
    Anchors = [akLeft, akRight, akBottom]
  end
  object TLabel
    Left = 4
    Top = 66
    Width = 39
    Height = 13
    Caption = 'Pruebas'
  end
  object TBevel
    Left = 51
    Top = 73
    Width = 97
    Height = 2
  end
  object l_log: TLabel
    Left = 5
    Top = 195
    Width = 84
    Height = 13
    Caption = 'Log de ejecución:'
  end
  object Bevel1: TBevel
    Left = 92
    Top = 203
    Width = 243
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object Image1: TImage
    Left = 3
    Top = 16
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      055449636F6E0000010002002020100001000400E80200002600000010101000
      01000400280100000E0300002800000020000000400000000100040000000000
      8002000000000000000000000000000000000000000000000000800000800000
      00808000800000008000800080800000C0C0C000808080000000FF0000FF0000
      00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000000000000000000000000780800080000000
      0000000000000000778080008000000000000000000000087780708080008000
      00000000000000087F880880800080000000000000000078F778888070808000
      8000000000008878777778880880800080000000000788787777777888807080
      80008000087788778777777778880880800080000877F8887777777777788880
      70808000087F777777777777777778880880800008F777777777777777777778
      8880700008777777777777777777777778880800008877777777777777777777
      7778880000008877777777777777777777777800000000887777777777777777
      7777700000000000887777777777777777770000000000000088777777777777
      7770000000000000000088777777777777000000000000000000008877777777
      7000000000000000000000008877777700000000000000000000000000887770
      0000000000000000000000000000880000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFFFFFFFFF7FFFFFFE3FFFF
      FF837FFFFF023FFFFE0037FFFE0023FFFC00037FF000023FE0000037C0000023
      8000000380000003800000018000000180000001C0000001E0000001FC000003
      FE000007FFC0000FFFE0001FFFFC003FFFFE007FFFFFC0FFFFFFE1FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000
      0100040000000000000000000000000000000000000000000000000000000000
      000080000080000000808000800000008000800080800000C0C0C00080808000
      0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
      00000000000008000000000000007078000000000008F88078000000008F7788
      8078000007F77777888078008F77777777888070087777777777888000087777
      7777778000000877777777000000000877777000000000000877000000000000
      00000000000000000000000000000000000000000000000000000000FDFF0000
      F17F0000E05F0000C017000080050000000100000000000080000000C0000000
      F0010000FC030000FF070000FFCF0000FFFF0000FFFF0000FFFF0000}
  end
  object Label1: TLabel
    Left = 53
    Top = 10
    Width = 73
    Height = 13
    Caption = 'Memoria Virtual'
  end
  object Label2: TLabel
    Left = 57
    Top = 26
    Width = 65
    Height = 13
    Cursor = crHandPoint
    Caption = 'La web de JM'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 53
    Top = 42
    Width = 72
    Height = 13
    Caption = 'JM - Julio/2002'
  end
  object l_jm: TLabel
    Left = 53
    Top = 42
    Width = 13
    Height = 13
    Cursor = crHandPoint
    Caption = 'JM'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = l_jmClick
  end
  object rb_prueba_1: TRadioButton
    Left = 24
    Top = 88
    Width = 113
    Height = 17
    Caption = 'Prueba 1 '
    TabOrder = 0
    OnClick = rb_prueba_1Click
  end
  object rb_prueba_2: TRadioButton
    Left = 24
    Top = 116
    Width = 113
    Height = 17
    Caption = 'Prueba 2 '
    TabOrder = 1
    OnClick = rb_prueba_2Click
  end
  object rb_prueba_3: TRadioButton
    Left = 24
    Top = 144
    Width = 113
    Height = 17
    Caption = 'Prueba 3 '
    TabOrder = 2
    OnClick = rb_prueba_3Click
  end
  object b_ejecutar: TButton
    Left = 186
    Top = 271
    Width = 73
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Ejecutar'
    Default = True
    TabOrder = 3
  end
  object m_info: TMemo
    Left = 160
    Top = 35
    Width = 166
    Height = 165
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Lines.Strings = (
      'm_info')
    ParentColor = True
    TabOrder = 4
  end
  object b_salir: TButton
    Left = 269
    Top = 271
    Width = 65
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Salir'
    ModalResult = 1
    TabOrder = 5
    OnClick = b_salirClick
  end
  object lb_log: TListBox
    Left = 4
    Top = 212
    Width = 331
    Height = 46
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 6
  end
end
