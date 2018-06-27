unit Unit1;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  Types,
  UnitWAVFile,
  UnitTAPFile,
  Spin,
  TapDisplay,
  TapDisplayTypes,
  ValEdit,
  Math,
  Menus,
  Grids,
  HTMLHelpViewerEx;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    ButtonParse: TButton;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    CheckBoxInvert: TCheckBox;
    SpinEditThr: TSpinEdit;
    SpinEditChn: TSpinEdit;
    SaveDialog1: TSaveDialog;
    ButtonZoomOut: TButton;
    TapDisplay1: TTapDisplay;
    ValueListEditor1: TValueListEditor;
    EditSet: TEdit;
    ButtonSet: TButton;
    RadioGroupEndianness: TRadioGroup;
    ProgressBar1: TProgressBar;
    ButtonSet30: TButton;
    ButtonSet42: TButton;
    ButtonSet56: TButton;
    Image1: TImage;
    ComboBoxAlgorithm: TComboBox;
    SpinEditMA: TSpinEdit;
    SpinEditAcc: TSpinEdit;
    ButtonSetAvg: TButton;
    SpinEditDC: TSpinEdit;
    OpenDialog2: TOpenDialog;
    Button3: TButton;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    MenuOpenWAV: TMenuItem;
    MenuOpenTAP: TMenuItem;
    MenuSaveAs: TMenuItem;
    MenuHelp: TMenuItem;
    MenuExit: TMenuItem;
    N2: TMenuItem;
    LabelDC: TLabel;
    LabelChn: TLabel;
    LabelThr: TLabel;
    LabelMA: TLabel;
    LabelAcc: TLabel;
    Button1: TButton;
    ButtonZoomIn: TButton;
    N1: TMenuItem;
    MenuAbout: TMenuItem;
    VisualTAPhelp1: TMenuItem;
    N3: TMenuItem;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    procedure ButtonParseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure CheckBoxInvertClick(Sender: TObject);
    procedure SpinEditChnChange(Sender: TObject);
    procedure ButtonZoomOutClick(Sender: TObject);
    procedure ButtonSetClick(Sender: TObject);
    procedure RadioGroupEndiannessClick(Sender: TObject);
    procedure ButtonSetValueClick(Sender: TObject);
    procedure SpinEditKeyDownParse(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonSetAvgClick(Sender: TObject);
    procedure TapDisplay1MouseMoveGCellYChanged(Sender: TObject; MouseMoveGCellY: Integer);
    procedure EditSetKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure OpenWAV(Sender: TObject);
    procedure OpenTAP(Sender: TObject);
    procedure SaveAs(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonZoomInClick(Sender: TObject);
    procedure VisualTAPhelp1Click(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
  private
    { Private declarations }
    WAVFile: TWAVFile;
    FOldProgress: Integer;
    FWorkFileName: string;
    procedure Log(Text: string = ''); overload;
    procedure Log(Level: Integer; Text: string); overload;
    procedure Log(Number: Integer); overload;
    procedure OpenWAVFile;
    procedure SetTitles;
    procedure ShowProgress(Position, Max: Integer);
    function ParsingAlgorithm1(Threshold: Integer; Acceleration: Double = 1.0): Integer;
    function ParsingAlgorithm2(Threshold: Integer; Acceleration: Double = 1.0; PulseDutyCycleRadius: Double = 0.1): Integer;
    function ParsingAlgorithm3(Threshold: Integer; Acceleration: Double = 1.0; PulseDutyCycleRadius: Double = 0.1): Integer;
  public
    { Public declarations }
    procedure Parse;
  end;

const
  APPLICATION_NAME = 'C64 Visual TAP';

var
  Form1: TForm1;

implementation

uses UnitAbout;

{$R *.dfm}

procedure TForm1.Log(Text: string);
begin
  Log(0, Text);
end;

procedure TForm1.Log(Level: Integer; Text: string);
begin
  if Text = '' then
    Memo1.Lines.Clear()
  else
    Memo1.Lines.Append(Text);
end;

procedure TForm1.Log(Number: Integer);
begin
  Memo1.Lines.Append(IntToStr(Number));
end;

procedure TForm1.ButtonParseClick(Sender: TObject);
begin
  Parse;
  ActiveControl := TapDisplay1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  WAVFile := TWAVFile.Create;
  Caption := APPLICATION_NAME;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  Delta: Integer;
  Point: TPoint;
begin
  Point := ScreenToClient(MousePos);
  if PtInRect(TapDisplay1.BoundsRect, Point) then
  begin
    Handled := True;
    Delta := WheelDelta div 120;
    if ssCtrl in Shift then
      TapDisplay1.Zoom := TapDisplay1.Zoom - Delta
    else
      TapDisplay1.Position := TapDisplay1.Position - Trunc(TapDisplay1.PageSize * Delta / 10);
  end;
end;

procedure TForm1.Parse;
var
  BufferLength: Integer;
  Threshold: Integer;
  Acceleration: Double;
  PulseDutyCycleRadius: Double;
  Reading: TReading;
begin
  Log;
  if WAVFile.IsChanged then
    OpenWAVFile;

  if not WAVFile.Valid then
    Exit;

  Reading.Inverse := CheckBoxInvert.Checked;
  Reading.Channel := SpinEditChn.Value;
  Reading.MARadius := SpinEditMA.Value;
  WAVFile.Reading := Reading;
  Threshold := Trunc(WAVFile.ValueRange / 100.0 * SpinEditThr.Value + 0.5);
  Acceleration := 1 + SpinEditAcc.Value / 100;
  PulseDutyCycleRadius := 0.1 * SpinEditDC.Value;

  TapDisplay1.TriggerBuffer := nil;
  BufferLength := Trunc(WAVFile.NumberOfSamples * 2000.0 / WAVFile.WaveFormat.SampleRate);
  SetLength(TapDisplay1.TriggerBuffer, BufferLength);

  case ComboBoxAlgorithm.ItemIndex of
    0:
      BufferLength := ParsingAlgorithm1(Threshold, Acceleration);
    1:
      BufferLength := ParsingAlgorithm2(Threshold, Acceleration, PulseDutyCycleRadius);
    2:
      BufferLength := ParsingAlgorithm3(Threshold, Acceleration, PulseDutyCycleRadius);
  else
    BufferLength := 0;
  end;
  SetLength(TapDisplay1.TriggerBuffer, BufferLength);

  TapDisplay1.RefreshAll;

end;

{ Algorithm from Tape64 }

function TForm1.ParsingAlgorithm1(Threshold: Integer; Acceleration: Double): Integer;
var
  i: Integer;
  TriggerBufferIndex: Integer;
  SampleState: TSampleState;
  TapValueLarge: Int64;
begin
  TriggerBufferIndex := 0;
  SampleState.PrevTrigger.Position := 0;
  for i := 0 to WAVFile.NumberOfSamples - 1 do
  begin
    ShowProgress(i, WAVFile.NumberOfSamples - 1);
    SampleState.Sample.Value := WAVFile.ReadSampleAverage(i);
    SampleState.Sample.Position := i;
    if SampleState.PrevSample.Value > SampleState.Sample.Value then
      SampleState.Direction := wdDown
    else
      SampleState.Direction := wdUp;
    if (SampleState.PrevDirection = wdUp) and (SampleState.Direction = wdDown) then
    begin
      SampleState.Maximum := SampleState.PrevSample;
      if (SampleState.Maximum.Value - SampleState.Minimum.Value) > Threshold then
      begin
        // Trigger detected
        TapValueLarge := Trunc((i - SampleState.PrevTrigger.Position) * C64_FREQUENCY / WAVFile.WaveFormat.SampleRate * Acceleration + 0.5);
        if (TapValueLarge > MAX_TRIGGER_LENGTH) then
          SampleState.PrevTrigger.Value := MAX_TRIGGER_LENGTH
        else
          SampleState.PrevTrigger.Value := TapValueLarge;
        SampleState.PrevTrigger.Position := i;
        if SampleState.PrevTrigger.Position > 0 then
        begin
          if TriggerBufferIndex >= Length(TapDisplay1.TriggerBuffer) then
            SetLength(TapDisplay1.TriggerBuffer, Trunc(Length(TapDisplay1.TriggerBuffer) * 1.1));
          TapDisplay1.TriggerBuffer[TriggerBufferIndex].Length := SampleState.PrevTrigger.Value;
          TapDisplay1.TriggerBuffer[TriggerBufferIndex].TAPValue := Trunc(SampleState.PrevTrigger.Value / 8 + 0.5);
          TapDisplay1.TriggerBuffer[TriggerBufferIndex].Position := SampleState.PrevTrigger.Position;
          TriggerBufferIndex := TriggerBufferIndex + 1;
        end;
      end;
    end
    else if (SampleState.PrevDirection = wdDown) and (SampleState.Direction = wdUp) then
    begin
      SampleState.Minimum := SampleState.PrevSample;
    end;
    SampleState.PrevSample := SampleState.Sample;
    SampleState.PrevDirection := SampleState.Direction;
  end;
  Result := TriggerBufferIndex;
end;

function TForm1.ParsingAlgorithm2(Threshold: Integer; Acceleration: Double; PulseDutyCycleRadius: Double): Integer;
var
  i: Cardinal;
  TriggerBufferIndex: Integer;
  SampleState: TSampleState;
  TriggerLengthLarge: Int64;
  SamplesInPeriod: Integer;
  PulseDutyCycle: Double;
  PulseDutyCycleMin: Double;
  PulseDutyCycleMax: Double;
  ClockCyclesInSample: Double;
  NewTrigger: PTrigger;
  PrevPause: PTrigger;
begin
  PulseDutyCycleMin := 0.5 - PulseDutyCycleRadius;
  PulseDutyCycleMax := 0.5 + PulseDutyCycleRadius;
  ClockCyclesInSample := C64_FREQUENCY / WAVFile.WaveFormat.SampleRate * Acceleration;
  TriggerBufferIndex := 0;
  ZeroMemory(@SampleState, SizeOf(SampleState));
  SampleState.PrevTrigger.Position := 0;
  PrevPause := nil;
  for i := 0 to WAVFile.NumberOfSamples - 1 do
  begin
    ShowProgress(i, WAVFile.NumberOfSamples - 1);
    SampleState.Sample.Value := WAVFile.ReadSampleAverage(i);
    SampleState.Sample.Position := i;
    if SampleState.PrevSample.Value > SampleState.Sample.Value then
      SampleState.Direction := wdDown
    else if SampleState.PrevSample.Value < SampleState.Sample.Value then
      SampleState.Direction := wdUp
    else
      SampleState.Direction := wdStraight;
    if (SampleState.PrevDirection = wdUp) and (SampleState.Direction <> wdUp) then
    begin
      if (SampleState.SearchPhase = spMinimum) and (SampleState.PrevSample.Value > SampleState.Maximum.Value) or (SampleState.SearchPhase <> spMinimum) and (Abs(SampleState.PrevSample.Value - SampleState.Minimum.Value) > Threshold) then
      begin
        // Maximum detected
        SampleState.Maximum := SampleState.PrevSample; // Now we can store new maximum
        SampleState.SearchPhase := spMinimum;
      end;
    end
    else if (SampleState.PrevDirection = wdDown) and (SampleState.Direction <> wdDown) then
    begin
      if (SampleState.SearchPhase = spMaximum) and (SampleState.PrevSample.Value < SampleState.Minimum.Value) or (SampleState.SearchPhase <> spMaximum) and (Abs(SampleState.Maximum.Value - SampleState.PrevSample.Value) > Threshold) then
      begin
        // Minimum detected
        if SampleState.SearchPhase = spMinimum then
        begin
          SamplesInPeriod := (SampleState.Maximum.Position - SampleState.PrevTrigger.Position);
          TriggerLengthLarge := Trunc(SamplesInPeriod * ClockCyclesInSample + 0.5);
          if (TriggerLengthLarge > MAX_TRIGGER_LENGTH) then
            SampleState.PrevTrigger.Value := MAX_TRIGGER_LENGTH
          else
            SampleState.PrevTrigger.Value := TriggerLengthLarge;
          SampleState.PrevTrigger.Position := SampleState.Maximum.Position;
          if SampleState.PrevTrigger.Position > 0 then
          begin
            if (SampleState.PrevTrigger.Value < PAUSE_MIN_TRIGGER_LENGTH) then
            begin
              PulseDutyCycle := (SampleState.Maximum.Position - SampleState.Minimum.Position) / SamplesInPeriod;
              if (PulseDutyCycle < PulseDutyCycleMin) or (PulseDutyCycle > PulseDutyCycleMax) then
                SampleState.PrevTrigger.Value := PAUSE_DEFAULT_TRIGGER_LENGTH;
            end;
            if (SampleState.PrevTrigger.Value >= PAUSE_MIN_TRIGGER_LENGTH) and (PrevPause <> nil) then
            begin
              NewTrigger := PrevPause;
              NewTrigger^.Length := NewTrigger^.Length + SampleState.PrevTrigger.Value;
            end
            else
            begin
              if TriggerBufferIndex >= Length(TapDisplay1.TriggerBuffer) then
                SetLength(TapDisplay1.TriggerBuffer, Trunc(Length(TapDisplay1.TriggerBuffer) * 1.1)); // Grow Buffer
              NewTrigger := @TapDisplay1.TriggerBuffer[TriggerBufferIndex];
              NewTrigger^.Length := SampleState.PrevTrigger.Value;
              TriggerBufferIndex := TriggerBufferIndex + 1;
              if (SampleState.PrevTrigger.Value >= PAUSE_MIN_TRIGGER_LENGTH) then
                PrevPause := NewTrigger
              else
                PrevPause := nil;
            end;
            NewTrigger^.TAPValue := SampleState.PrevTrigger.Value shr 3;
            NewTrigger^.Position := SampleState.PrevTrigger.Position;
          end;
        end;
        SampleState.Minimum := SampleState.PrevSample;
        SampleState.SearchPhase := spMaximum;
      end;
    end;
    SampleState.PrevSample := SampleState.Sample;
    SampleState.PrevDirection := SampleState.Direction;
  end;
  Result := TriggerBufferIndex;
end;

function TForm1.ParsingAlgorithm3(Threshold: Integer; Acceleration, PulseDutyCycleRadius: Double): Integer;
var
  i, j: Integer;
  TriggerBufferIndex: Integer;
  SampleState: TSampleState;
  TriggerLengthLarge: Int64;
  SamplesInPeriod: Integer;
  //PulseDutyCycle: Double;
  //PulseDutyCycleMin: Double;
  //PulseDutyCycleMax: Double;
  ClockCyclesInSample: Double;
  NewTrigger: PTrigger;
  PrevPause: PTrigger;
  MaxMinBuffer: TSampleDynArray;          // [0] - Max, [1] - Min ...
  MaxMinBufferIndex: Integer;
  DeltaValue: Integer;
  KMax, KMin: Double;
  ZeroSlopeValue: Double;
  DX: Integer;
  PrevMax, CurrMax: TSample;
  PrevMin, CurrMin, NextMin: TSample;
begin
  //PulseDutyCycleMin := 0.5 - PulseDutyCycleRadius;
  //PulseDutyCycleMax := 0.5 + PulseDutyCycleRadius;
  ClockCyclesInSample := C64_FREQUENCY / WAVFile.WaveFormat.SampleRate * Acceleration;

  SetLength(MaxMinBuffer, Length(TapDisplay1.TriggerBuffer) * 4);
  MaxMinBufferIndex := -1;
  ZeroMemory(@SampleState, SizeOf(SampleState));
  SampleState.SearchPhase := spMaximum;

  // Search for Max/Min
  for i := 0 to WAVFile.NumberOfSamples - 1 do
  begin
    ShowProgress(i, WAVFile.NumberOfSamples - 1);
    SampleState.Sample.Value := WAVFile.ReadSampleAverage(i);
    SampleState.Sample.Position := i;
    SampleState.Direction := TWaveDirection(Sign(SampleState.Sample.Value - SampleState.PrevSample.Value));
    if (SampleState.PrevDirection = wdUp) and (SampleState.Direction <> wdUp) then
    begin
      DeltaValue := SampleState.PrevSample.Value - MaxMinBuffer[MaxMinBufferIndex].Value;
      case SampleState.SearchPhase of
        spMaximum:
          if Abs(DeltaValue) > Threshold then
          begin
            MaxMinBufferIndex := MaxMinBufferIndex + 1;
            MaxMinBuffer[MaxMinBufferIndex] := SampleState.PrevSample;
            SampleState.SearchPhase := spMinimum;
          end;
        spMinimum:
          if (DeltaValue > 0) and (MaxMinBufferIndex >= 0) then
          begin
            MaxMinBuffer[MaxMinBufferIndex] := SampleState.PrevSample;
          end;
      end;
    end
    else if (SampleState.PrevDirection = wdDown) and (SampleState.Direction <> wdDown) then
    begin
      DeltaValue := SampleState.PrevSample.Value - MaxMinBuffer[MaxMinBufferIndex].Value;
      case SampleState.SearchPhase of
        spMinimum:
          if Abs(DeltaValue) > Threshold then
          begin
            MaxMinBufferIndex := MaxMinBufferIndex + 1;
            MaxMinBuffer[MaxMinBufferIndex] := SampleState.PrevSample;
            SampleState.SearchPhase := spMaximum;
          end;
        spMaximum:
          if (DeltaValue < 0) and (MaxMinBufferIndex >= 0) then
          begin
            MaxMinBuffer[MaxMinBufferIndex] := SampleState.PrevSample;
          end;
      end;
    end;
    SampleState.PrevSample := SampleState.Sample;
    SampleState.PrevDirection := SampleState.Direction;
  end;
  SetLength(MaxMinBuffer, MaxMinBufferIndex);

  // Calculate Edges
  TriggerBufferIndex := 0;
  ZeroMemory(@SampleState, SizeOf(SampleState));
  PrevPause := nil;
  //KMax := 0;
  KMin := 0;
  for i := 0 to High(MaxMinBuffer) do
  begin
    ShowProgress(i, High(MaxMinBuffer));
    case Odd(i) of
      // Maximum
      False:
        begin
          CurrMax := MaxMinBuffer[i];
          if i = 0 then
          begin
            KMax := 0;
            PrevMin.Position := 0;
            PrevMin.Value := 0;
          end
          else
            KMax := (CurrMax.Value - PrevMax.Value) / (CurrMax.Position - PrevMax.Position);

          for j := PrevMin.Position to CurrMax.Position do
          begin
            DX := j - PrevMin.Position;
            ZeroSlopeValue := PrevMin.Value + KMin * DX;
            DX := CurrMax.Position - j;
            ZeroSlopeValue := ZeroSlopeValue + CurrMax.Value - KMax * DX;
            ZeroSlopeValue := ZeroSlopeValue / 2 + 0.5;
            if WAVFile.ReadSampleAverage(j) > ZeroSlopeValue then
            begin
              SamplesInPeriod := (j - SampleState.PrevTrigger.Position);
              TriggerLengthLarge := Trunc(SamplesInPeriod * ClockCyclesInSample + 0.5);
              if (TriggerLengthLarge > MAX_TRIGGER_LENGTH) then
                SampleState.PrevTrigger.Value := MAX_TRIGGER_LENGTH
              else
                SampleState.PrevTrigger.Value := TriggerLengthLarge;
              SampleState.PrevTrigger.Position := j;
              if SampleState.PrevTrigger.Position > 0 then
              begin
                {if (SampleState.PrevTrigger.Value < PAUSE_MIN_TRIGGER_LENGTH) then
                begin
                  PulseDutyCycle := (SampleState.Maximum.Position - SampleState.Minimum.Position) / SamplesInPeriod;
                  if (PulseDutyCycle < PulseDutyCycleMin) or (PulseDutyCycle > PulseDutyCycleMax) then
                    SampleState.PrevTrigger.Value := PAUSE_DEFAULT_TRIGGER_LENGTH;
                end;}
                if (SampleState.PrevTrigger.Value >= PAUSE_MIN_TRIGGER_LENGTH) and (PrevPause <> nil) then
                begin
                  NewTrigger := PrevPause;
                  NewTrigger^.Length := NewTrigger^.Length + SampleState.PrevTrigger.Value;
                end
                else
                begin
                  if TriggerBufferIndex >= Length(TapDisplay1.TriggerBuffer) then
                    SetLength(TapDisplay1.TriggerBuffer, Trunc(Length(TapDisplay1.TriggerBuffer) * 1.1)); // Grow Buffer
                  NewTrigger := @TapDisplay1.TriggerBuffer[TriggerBufferIndex];
                  NewTrigger^.Length := SampleState.PrevTrigger.Value;
                  TriggerBufferIndex := TriggerBufferIndex + 1;
                  if (SampleState.PrevTrigger.Value >= PAUSE_MIN_TRIGGER_LENGTH) then
                    PrevPause := NewTrigger
                  else
                    PrevPause := nil;
                end;
                NewTrigger^.TAPValue := SampleState.PrevTrigger.Value shr 3;
                NewTrigger^.Position := SampleState.PrevTrigger.Position;
              end;
              Break;
            end;
          end;
          PrevMax := CurrMax;
        end;
      // Minimum
      True:
        begin
          if i = 1 then
            CurrMin := MaxMinBuffer[i]
          else
            CurrMin := NextMin;
          NextMin := MaxMinBuffer[i + 2];
          KMin := (NextMin.Value - CurrMin.Value) / (NextMin.Position - CurrMin.Position);
          PrevMin := CurrMin;
        end;
    end;
  end;

  Result := TriggerBufferIndex;
end;

procedure TForm1.CheckBoxInvertClick(Sender: TObject);
begin
  Parse;
end;

procedure TForm1.SpinEditChnChange(Sender: TObject);
begin
  if SpinEditChn.Value > SpinEditChn.MaxValue then
    SpinEditChn.Value := SpinEditChn.MaxValue;
  if SpinEditChn.Value < SpinEditChn.MinValue then
    SpinEditChn.Value := SpinEditChn.MinValue;
end;

procedure TForm1.ButtonZoomOutClick(Sender: TObject);
begin
  TapDisplay1.ZoomOut;
  ActiveControl := TapDisplay1;
end;

procedure TForm1.ButtonSetClick(Sender: TObject);
var
  NewTAPValue: Integer;
begin
  if TryStrToInt(EditSet.Text, NewTAPValue) then
  begin
    TapDisplay1.SetTAPValueInSelection(NewTAPValue);
  end;
end;

procedure TForm1.ButtonSetValueClick(Sender: TObject);
begin
  TapDisplay1.SetTAPValueInSelection((Sender as TButton).Tag);
end;

procedure TForm1.ButtonSetAvgClick(Sender: TObject);
begin
  TapDisplay1.SetTAPValueInSelection(TapDisplay1.GetAvegareTAPValueInSelection);
end;

procedure TForm1.RadioGroupEndiannessClick(Sender: TObject);
begin
  TapDisplay1.Endianness := TEndianness(RadioGroupEndianness.ItemIndex);
  ActiveControl := TapDisplay1;
end;

procedure TForm1.ShowProgress(Position, Max: Integer);
var
  Progress: Integer;
begin
  Progress := (Position * 10 div Max);
  if FOldProgress <> Progress then
  begin
    ProgressBar1.Position := Progress;
    FOldProgress := Progress;
    if Progress < 10 then
      ProgressBar1.Visible := True
    else
      ProgressBar1.Visible := False;
  end;
end;

procedure TForm1.SpinEditKeyDownParse(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Parse;
end;

procedure TForm1.TapDisplay1MouseMoveGCellYChanged(Sender: TObject; MouseMoveGCellY: Integer);
var
  TriggerIndex: Integer;
  TriggerPosition: Integer;
  i: Integer;
  PX, PY: Integer;
  SamplesToShow: Integer;
  SamplesPerPixel: Double;
  ValuePerPixel: Double;
  FrameWidth: Integer;
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Brush.Style := bsSolid;
  Image1.Canvas.FillRect(Rect(0, 0, Image1.Width, Image1.Height));

  if not WAVFile.Valid then
  begin
    Image1.Canvas.TextOut(0, 0, 'No valid WAV data');
    Exit;
  end;

  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Polyline([Point(0, Image1.Height div 2), Point(Image1.Width, Image1.Height div 2)]);
  Image1.Canvas.Pen.Color := clRed;
  Image1.Canvas.Polyline([Point(Image1.Width div 2, 0), Point(Image1.Width div 2, Image1.Height)]);
  Image1.Canvas.Pen.Color := clDkGray;

  SamplesToShow := WAVFile.WaveFormat.SampleRate div 500;
  if SamplesToShow > 0 then
  begin
    TriggerIndex := MouseMoveGCellY;
    if TapDisplay1.IsValidTriggerBufferIndex(TriggerIndex) then
    begin
      TriggerPosition := TapDisplay1.TriggerBuffer[TriggerIndex].Position;
      if TriggerPosition >= 0 then
      begin
        SamplesPerPixel := SamplesToShow / Image1.Width;
        ValuePerPixel := WAVFile.ValueRange / Image1.Height;
        FrameWidth := SamplesToShow div 2;

        if TapDisplay1.IsValidTriggerBufferIndex(TriggerIndex - 1) then
        begin
          PX := Image1.Width div 2 - Trunc((TriggerPosition - TapDisplay1.TriggerBuffer[TriggerIndex - 1].Position) / SamplesPerPixel);
          Image1.Canvas.Polyline([Point(PX, 0), Point(PX, Image1.Height)]);
        end;
        if TapDisplay1.IsValidTriggerBufferIndex(TriggerIndex + 1) then
        begin
          PX := Image1.Width div 2 - Trunc((TriggerPosition - TapDisplay1.TriggerBuffer[TriggerIndex + 1].Position) / SamplesPerPixel);
          Image1.Canvas.Polyline([Point(PX, 0), Point(PX, Image1.Height)]);
        end;

        for i := -FrameWidth to FrameWidth do
        begin
          PX := Image1.Width div 2 + Trunc(i / SamplesPerPixel);
          PY := Image1.Height div 2 - Trunc(WAVFile.ReadSample(Integer(TriggerPosition) + i) / ValuePerPixel);
          if i = -FrameWidth then
            Image1.Canvas.MoveTo(PX, PY);
          Image1.Canvas.LineTo(PX, PY);
        end;

        Image1.Canvas.Pen.Color := clFuchsia;
        for i := -FrameWidth to FrameWidth do
        begin
          PX := Image1.Width div 2 + Trunc(i / SamplesPerPixel);
          PY := Image1.Height div 2 - Trunc(WAVFile.ReadSampleAverage(Integer(TriggerPosition) + i) / ValuePerPixel);
          if i = -FrameWidth then
            Image1.Canvas.MoveTo(PX, PY);
          Image1.Canvas.LineTo(PX, PY);
        end;
      end;
    end;
  end;

end;

procedure TForm1.EditSetKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonSetClick(Sender);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: Integer;
begin
  for i := TapDisplay1.Position + 1 to High(TapDisplay1.TriggerBuffer) do
  begin
    if TapDisplay1.TriggerBuffer[i].TAPValue > $FF then
    begin
      TapDisplay1.Position := i;
      Break;
    end;
  end;
  ActiveControl := TapDisplay1;
end;

procedure TForm1.OpenWAVFile;
begin
  if WAVFile.Open(FWorkFileName) then
  begin
    ValueListEditor1.Values['SampleRate'] := IntToStr(WAVFile.WaveFormat.SampleRate);
    ValueListEditor1.Values['BitsPerSample'] := IntToStr(WAVFile.WaveFormat.BitsPerSample);
    ValueListEditor1.Values['NumChannels'] := IntToStr(WAVFile.WaveFormat.NumChannels);
    ValueListEditor1.Values['NumberOfSamples'] := IntToStr(WAVFile.NumberOfSamples);
    SpinEditChn.MaxValue := WAVFile.WaveFormatChunk^.NumChannels;
  end;
  if SpinEditChn.Value > SpinEditChn.MaxValue then
    SpinEditChn.Value := SpinEditChn.MaxValue;
end;

procedure TForm1.OpenTAP(Sender: TObject);
var
  TAPFile: TTAPFile;
begin
  if OpenDialog2.Execute then
  begin
    WAVFile.Close;
    TapDisplay1.Clear;
    FWorkFileName := OpenDialog2.FileName;
    TAPFile := TTAPFile.Create;
    if TAPFile.Load(OpenDialog2.FileName) then
    begin
      ValueListEditor1.Strings.Clear;
      ValueListEditor1.Values['Identifier'] := TAPFile.Header.Identifier;
      ValueListEditor1.Values['Version'] := IntToStr(TAPFile.Header.Version);
      ValueListEditor1.Values['DataSize'] := IntToStr(TAPFile.Header.DataSize);

      TAPFile.FileToTrigger(TapDisplay1.TriggerBuffer);
      TapDisplay1.RefreshAll;
      SetTitles;
    end;
    TAPFile.Free;
  end;
end;

procedure TForm1.OpenWAV(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ValueListEditor1.Strings.Clear;
    FWorkFileName := OpenDialog1.FileName;
    TapDisplay1.Clear;
    OpenWAVFile;
    SetTitles;
  end;
end;

procedure TForm1.SaveAs(Sender: TObject);
var
  TAPFile: TTAPFile;
begin
  SaveDialog1.FileName := FWorkFileName + '.tap';
  if SaveDialog1.Execute then
  begin
    TAPFile := TTAPFile.Create;
    TAPFile.TriggerToFile(TapDisplay1.TriggerBuffer);
    TAPFile.Save(SaveDialog1.FileName);
    TAPFile.Free;
  end;
end;

procedure TForm1.MenuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := TapDisplay1.Position - 1 downto 0 do
  begin
    if TapDisplay1.TriggerBuffer[i].TAPValue > $FF then
    begin
      TapDisplay1.Position := i;
      Break;
    end;
  end;
  ActiveControl := TapDisplay1;
end;

procedure TForm1.ButtonZoomInClick(Sender: TObject);
begin
  TapDisplay1.Zoom := 8;
  ActiveControl := TapDisplay1;
end;

procedure TForm1.SetTitles;
begin
  Caption := FWorkFileName;
  Application.Title := ExtractFileName(FWorkFileName) + ' - ' + APPLICATION_NAME;
  StatusBar1.SimpleText := FWorkFileName;
end;

procedure TForm1.VisualTAPhelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

end.
