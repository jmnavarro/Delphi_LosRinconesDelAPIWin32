object MainForm: TMainForm
  Left = 214
  Top = 115
  Width = 507
  Height = 376
  Caption = 'Pruebas con montones'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TBevel
    Left = 200
    Top = 17
    Width = 296
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object l_info: TLabel
    Left = 176
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
  object bv: TBevel
    Left = 5
    Top = 311
    Width = 484
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
  object TBevel
    Left = 93
    Top = 202
    Width = 395
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object i_icono: TImage
    Left = 3
    Top = 16
    Width = 32
    Height = 32
    AutoSize = True
  end
  object TLabel
    Left = 70
    Top = 10
    Width = 66
    Height = 13
    Caption = 'Los Montones'
  end
  object TLabel
    Left = 78
    Top = 26
    Width = 51
    Height = 13
    Caption = 'Síntesis 12'
  end
  object TLabel
    Left = 53
    Top = 42
    Width = 97
    Height = 13
    Caption = 'JM - Diciembre/2002'
  end
  object l_jm: TLabel
    Left = 53
    Top = 42
    Width = 13
    Height = 13
    Cursor = crHandPoint
    Hint = 'mailto: jose_manuel_navarro@yahoo.es'
    Caption = 'JM'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = l_jmClick
  end
  object TBevel
    Left = 164
    Top = 13
    Width = 12
    Height = 190
    Shape = bsLeftLine
  end
  object rb_THeap: TRadioButton
    Left = 16
    Top = 114
    Width = 138
    Height = 17
    Caption = 'Uso de la clase THeap'
    TabOrder = 0
    OnClick = rb_THeapClick
  end
  object rb_heapAPI: TRadioButton
    Left = 16
    Top = 84
    Width = 145
    Height = 17
    Caption = 'Uso de Heaps con el API'
    TabOrder = 1
    OnClick = rb_heapAPIClick
  end
  object rb_THeapList: TRadioButton
    Left = 16
    Top = 144
    Width = 146
    Height = 17
    Caption = 'Uso de la clase THeapList'
    TabOrder = 2
    OnClick = rb_THeapListClick
  end
  object b_ejecutar: TButton
    Left = 343
    Top = 319
    Width = 73
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Ejecutar'
    Default = True
    TabOrder = 3
  end
  object m_info: TMemo
    Left = 178
    Top = 35
    Width = 318
    Height = 165
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Lines.Strings = (
      'm_info')
    ParentColor = True
    TabOrder = 4
  end
  object b_salir: TButton
    Left = 425
    Top = 319
    Width = 65
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Salir'
    ModalResult = 1
    TabOrder = 5
    OnClick = b_salirClick
  end
  object lb_log: TListBox
    Left = 5
    Top = 212
    Width = 483
    Height = 94
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 6
    TabWidth = 150
  end
  object b_montones: TButton
    Left = 5
    Top = 319
    Width = 140
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'Ver montones del proceso'
    TabOrder = 7
    OnClick = b_montonesClick
  end
  object b_InfoMem: TButton
    Left = 152
    Top = 319
    Width = 125
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'Información de memoria'
    TabOrder = 8
    OnClick = b_InfoMemClick
  end
end
