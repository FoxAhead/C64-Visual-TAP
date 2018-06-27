object Form1: TForm1
  Left = 462
  Top = 186
  AutoScroll = False
  Caption = 'Visual TAP'
  ClientHeight = 606
  ClientWidth = 757
  Color = clBtnFace
  Constraints.MinHeight = 535
  Constraints.MinWidth = 586
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  DesignSize = (
    757
    606)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 224
    Width = 225
    Height = 177
  end
  object Memo1: TMemo
    Left = 500
    Top = 420
    Width = 241
    Height = 154
    Anchors = [akLeft, akTop, akBottom]
    Color = clBtnFace
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 587
    Width = 757
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object TapDisplay1: TTapDisplay
    Left = 228
    Top = 40
    Width = 528
    Height = 545
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseMoveGCellYChanged = TapDisplay1MouseMoveGCellYChanged
  end
  object ValueListEditor1: TValueListEditor
    Left = 0
    Top = 0
    Width = 225
    Height = 73
    Color = clBtnFace
    Ctl3D = True
    DefaultColWidth = 120
    DefaultRowHeight = 16
    DisplayOptions = [doAutoColResize, doKeyColFixed]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    ScrollBars = ssNone
    Strings.Strings = (
      '=')
    TabOrder = 0
    ColWidths = (
      120
      99)
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 568
    Width = 225
    Height = 16
    Anchors = [akLeft, akBottom]
    Max = 10
    TabOrder = 2
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 76
    Width = 225
    Height = 97
    Caption = 'Parse WAV to TAP'
    TabOrder = 5
    object LabelThr: TLabel
      Left = 56
      Top = 52
      Width = 16
      Height = 13
      Caption = 'Thr'
    end
    object LabelMA: TLabel
      Left = 100
      Top = 52
      Width = 16
      Height = 13
      Caption = 'MA'
    end
    object LabelDC: TLabel
      Left = 188
      Top = 52
      Width = 15
      Height = 13
      Caption = 'DC'
    end
    object LabelChn: TLabel
      Left = 12
      Top = 52
      Width = 19
      Height = 13
      Caption = 'Chn'
    end
    object LabelAcc: TLabel
      Left = 140
      Top = 52
      Width = 19
      Height = 13
      Caption = 'Acc'
    end
    object Label1: TLabel
      Left = 152
      Top = 12
      Width = 43
      Height = 13
      Caption = 'Algorithm'
    end
    object SpinEditThr: TSpinEdit
      Left = 48
      Top = 68
      Width = 41
      Height = 22
      Hint = 'Threshold %'
      HelpContext = 11
      MaxValue = 100
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 10
      OnKeyDown = SpinEditKeyDownParse
    end
    object ButtonParse: TButton
      Left = 72
      Top = 16
      Width = 61
      Height = 33
      HelpContext = 7
      Caption = 'Parse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonParseClick
    end
    object SpinEditMA: TSpinEdit
      Left = 92
      Top = 68
      Width = 41
      Height = 22
      Hint = 'Moving average'
      HelpContext = 12
      MaxValue = 100
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 3
      OnKeyDown = SpinEditKeyDownParse
    end
    object SpinEditDC: TSpinEdit
      Left = 180
      Top = 68
      Width = 37
      Height = 22
      Hint = 'Duty cycle'
      HelpContext = 14
      MaxValue = 5
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 3
      OnKeyDown = SpinEditKeyDownParse
    end
    object SpinEditChn: TSpinEdit
      Left = 8
      Top = 68
      Width = 37
      Height = 22
      Hint = 'Channel'
      HelpContext = 10
      MaxValue = 1
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Value = 1
      OnChange = SpinEditChnChange
      OnKeyDown = SpinEditKeyDownParse
    end
    object SpinEditAcc: TSpinEdit
      Left = 136
      Top = 68
      Width = 41
      Height = 22
      Hint = 'Acceleration %'
      HelpContext = 13
      MaxValue = 50
      MinValue = -50
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Value = 0
      OnKeyDown = SpinEditKeyDownParse
    end
    object ComboBoxAlgorithm: TComboBox
      Left = 140
      Top = 28
      Width = 77
      Height = 21
      Hint = 'Algorithm'
      HelpContext = 9
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = 'Edge'
      Items.Strings = (
        'Tape64'
        'MinMax'
        'Edge')
    end
    object CheckBoxInvert: TCheckBox
      Left = 8
      Top = 20
      Width = 53
      Height = 21
      Hint = 'Invert waveform'
      Caption = 'Invert'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      WordWrap = True
      OnClick = CheckBoxInvertClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 176
    Width = 225
    Height = 45
    Caption = 'Edit'
    TabOrder = 6
    object ButtonSet: TButton
      Left = 56
      Top = 16
      Width = 33
      Height = 21
      Caption = 'Set'
      TabOrder = 0
      OnClick = ButtonSetClick
    end
    object EditSet: TEdit
      Left = 8
      Top = 16
      Width = 45
      Height = 21
      HelpContext = 18
      TabOrder = 1
      OnKeyDown = EditSetKeyDown
    end
    object ButtonSet30: TButton
      Tag = 48
      Left = 92
      Top = 16
      Width = 29
      Height = 21
      Caption = '$30'
      TabOrder = 2
      OnClick = ButtonSetValueClick
    end
    object ButtonSet42: TButton
      Tag = 66
      Left = 124
      Top = 16
      Width = 29
      Height = 21
      Caption = '$42'
      TabOrder = 3
      OnClick = ButtonSetValueClick
    end
    object ButtonSet56: TButton
      Tag = 86
      Left = 156
      Top = 16
      Width = 29
      Height = 21
      Caption = '$56'
      TabOrder = 4
      OnClick = ButtonSetValueClick
    end
    object ButtonSetAvg: TButton
      Left = 188
      Top = 16
      Width = 29
      Height = 21
      Caption = 'Avg'
      TabOrder = 5
      OnClick = ButtonSetAvgClick
    end
  end
  object Panel1: TPanel
    Left = 228
    Top = 0
    Width = 529
    Height = 37
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 7
    object ButtonZoomIn: TButton
      Left = 120
      Top = 8
      Width = 77
      Height = 25
      Caption = 'Zoom Normal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ButtonZoomInClick
    end
    object ButtonZoomOut: TButton
      Left = 200
      Top = 8
      Width = 61
      Height = 25
      Caption = 'Zoom Full'
      TabOrder = 1
      OnClick = ButtonZoomOutClick
    end
    object Button1: TButton
      Left = 264
      Top = 8
      Width = 41
      Height = 25
      Hint = 'Previous Pause'
      Caption = 'PrevP'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 308
      Top = 8
      Width = 41
      Height = 25
      Hint = 'Next Pause'
      Caption = 'NextP'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = Button3Click
    end
    object RadioGroupEndianness: TRadioGroup
      Left = 4
      Top = 2
      Width = 113
      Height = 31
      Caption = 'Endianness'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'LSbF'
        'MSbF')
      TabOrder = 4
      OnClick = RadioGroupEndiannessClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'WAV|*.wav'
    Left = 596
    Top = 568
  end
  object SaveDialog1: TSaveDialog
    Filter = 'TAP|*.tap'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 652
    Top = 568
  end
  object OpenDialog2: TOpenDialog
    Filter = 'TAP|*.tap'
    Left = 624
    Top = 568
  end
  object MainMenu1: TMainMenu
    Left = 680
    Top = 568
    object MenuFile: TMenuItem
      Caption = 'File'
      object MenuOpenWAV: TMenuItem
        Caption = 'Open WAV...'
        OnClick = OpenWAV
      end
      object MenuOpenTAP: TMenuItem
        Caption = 'Open TAP...'
        OnClick = OpenTAP
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MenuSaveAs: TMenuItem
        Caption = 'Save TAP As...'
        OnClick = SaveAs
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MenuExit: TMenuItem
        Caption = 'Exit'
        OnClick = MenuExitClick
      end
    end
    object MenuHelp: TMenuItem
      Caption = 'Help'
      object VisualTAPhelp1: TMenuItem
        Caption = 'Visual TAP Help'
        OnClick = VisualTAPhelp1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MenuAbout: TMenuItem
        Caption = 'About'
        OnClick = MenuAboutClick
      end
    end
  end
end
