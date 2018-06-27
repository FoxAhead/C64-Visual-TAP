unit UnitWAVFile;

interface

uses
  Classes,
  SysUtils,
  Types,
  Windows;

type
  TWaveRIFFHeader = packed record
    ChunkID: array[0..3] of char;
    ChunkSize: Integer;
    Format: array[0..3] of char;
  end;

  PWaveRIFFHeader = ^TWaveRIFFHeader;

  TWaveChunk = packed record
    ChunkID: array[0..3] of char;
    ChunkSize: Integer;
  end;

  PWaveChunk = ^TWaveChunk;

  TWaveFormatChunk = packed record
    ChunkID: array[0..3] of char;
    ChunkSize: Integer;
    AudioFormat: Smallint;
    NumChannels: Smallint;
    SampleRate: Integer;
    ByteRate: Integer;
    BlockAlign: Smallint;
    BitsPerSample: Smallint;
  end;

  PWaveFormatChunk = ^TWaveFormatChunk;

  TMovingAverage = record
    Sum: Integer;
    N: Integer;
    PrevIndex: Integer;
    PrevAverage: Integer;
  end;

  TReading = record
    Channel: Integer;
    Inverse: Boolean;
    MARadius: Integer;
  end;

type
  TWAVFile = class
  private
    FFileName: string;
    FileBuffer: TByteDynArray;
    MovingAverage: TMovingAverage;
    FReading: TReading;
    FChannelOffset: Integer;
    FFileAge: Integer;
    function GetWaveFormat: TWaveFormatChunk;
    function GetValueRange: Integer;
    procedure SetReading(const Value: TReading);
    function GetValid: Boolean;
    procedure ClearAll;
  public
    WaveRIFFHeader: PWaveRIFFHeader;
    WaveFormatChunk: PWaveFormatChunk;
    WaveDataChunk: PWaveChunk;
    WaveDataOffset: Integer;
    NumberOfSamples: Integer;
    destructor Destroy; override;
    procedure Load;
    function Open(FileName: string): Boolean;
    procedure Close;
    function ReadSample(SapmpleIndex: Integer): Integer;
    function ReadSampleAverage(SapmpleIndex: Integer): Integer;
    function IsChanged: Boolean;
    property WaveFormat: TWaveFormatChunk read GetWaveFormat;
    property ValueRange: Integer read GetValueRange;
    property Reading: TReading read FReading write SetReading;
    property Valid: Boolean read GetValid;
  end;

implementation

{ TWAV }

procedure TWAVFile.ClearAll;
begin
  FileBuffer := nil;
  WaveRIFFHeader := nil;
  WaveFormatChunk := nil;
  WaveDataChunk := nil;
  WaveDataOffset := 0;
  NumberOfSamples := 0;
  FFileAge := 0;
end;

procedure TWAVFile.Close;
begin
  ClearAll;
  FFileName := '';
end;

destructor TWAVFile.Destroy;
begin
  Close;
  inherited;
end;

function TWAVFile.GetValid: Boolean;
begin
  Result := False;
  if FFileName = '' then
    Exit;
  if not (Assigned(FileBuffer) and Assigned(WaveRIFFHeader) and Assigned(WaveFormatChunk) and Assigned(WaveDataChunk)) then
    Exit;
  if (WaveDataOffset <= 0) or (NumberOfSamples <= 0) then
    Exit;
  Result := True;
end;

function TWAVFile.GetValueRange: Integer;
begin
  Result := 1 shl WaveFormat.BitsPerSample;
end;

function TWAVFile.GetWaveFormat: TWaveFormatChunk;
begin
  if WaveFormatChunk <> nil then
    Result := WaveFormatChunk^
  else
    ZeroMemory(@Result, SizeOf(Result));
end;

function TWAVFile.IsChanged: Boolean;
begin
  Result := False;
  if FFileName = '' then
    Exit;
  Result := FFileAge <> FileAge(FFileName);
end;

procedure TWAVFile.Load;
var
  FileStream: TFileStream;
  WaveChunk: PWaveChunk;
  Pos: Integer;
begin
  ClearAll;

  if FFileName = '' then
    Exit;
  FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
  SetLength(FileBuffer, FileStream.Size);
  FileStream.read(Pointer(FileBuffer)^, FileStream.Size);
  FileStream.Free;

  FFileAge := FileAge(FFileName);

  Pos := Low(FileBuffer);
  WaveRIFFHeader := PWaveRIFFHeader(@FileBuffer[0]);
  Pos := Pos + SizeOf(TWaveRIFFHeader);
  while Pos <= (High(FileBuffer) - SizeOf(TWaveChunk)) do
  begin
    WaveChunk := PWaveChunk(@FileBuffer[Pos]);
    Pos := Pos + SizeOf(TWaveChunk);
    if WaveChunk^.ChunkID = 'fmt ' then
    begin
      WaveFormatChunk := Pointer(WaveChunk);
    end;
    if WaveChunk^.ChunkID = 'data' then
    begin
      WaveDataChunk := Pointer(WaveChunk);
      WaveDataOffset := Pos;
    end;
    if Assigned(WaveFormatChunk) and Assigned(WaveDataChunk) then
    begin
      if (WaveRIFFHeader^.ChunkID = 'RIFF') and (WaveRIFFHeader^.Format = 'WAVE') and (WaveFormatChunk^.AudioFormat = 1) and (WaveDataOffset > 0) then
      begin
        NumberOfSamples := WaveDataChunk^.ChunkSize div WaveFormatChunk^.BlockAlign;
      end;
      Break;
    end;
    Pos := Pos + WaveChunk^.ChunkSize;
  end;
end;

function TWAVFile.Open(FileName: string): Boolean;
begin
  FFileName := FileName;
  Load;
  Result := Valid;
end;

function TWAVFile.ReadSample(SapmpleIndex: Integer): Integer;
var
  BufferPosition: Integer;
begin
  Result := 0;
  if (SapmpleIndex >= 0) and (SapmpleIndex < NumberOfSamples) then
  begin

    BufferPosition := WaveDataOffset + SapmpleIndex * WaveFormatChunk^.BlockAlign + FChannelOffset;
    if (BufferPosition >= 0) and (BufferPosition <= High(FileBuffer)) then
    begin
      case WaveFormatChunk^.BitsPerSample of
        8:
          begin
            Result := FileBuffer[BufferPosition];
            if FReading.Inverse then
              Result := 255 - Result;
          end;
        16:
          begin
            Result := PSmallInt(@FileBuffer[BufferPosition])^;
            if (Result > $7FFF) then
              Result := Cardinal(Result) or $FFFF0000;
            if FReading.Inverse then
              Result := -Result;
          end;
        24:
          begin
            Result := PInteger(@FileBuffer[BufferPosition])^ and $00FFFFFF;
            if (Result > $7FFFFF) then
              Result := Cardinal(Result) or $FF000000;
            if FReading.Inverse then
              Result := -Result;
          end;
        32:
          ;                               //TODO
      end;
    end;
  end;
end;

function TWAVFile.ReadSampleAverage(SapmpleIndex: Integer): Integer;
var
  i: Integer;
  DeltaIndex: Integer;
begin
  DeltaIndex := SapmpleIndex - MovingAverage.PrevIndex;

  case Abs(DeltaIndex) of
    0:
      begin
        Result := MovingAverage.PrevAverage;
        Exit;
      end;
    1:
      begin
        MovingAverage.Sum := MovingAverage.Sum - ReadSample(MovingAverage.PrevIndex - Reading.MARadius * DeltaIndex);
        MovingAverage.Sum := MovingAverage.Sum + ReadSample(SapmpleIndex + Reading.MARadius * DeltaIndex);
      end;
  else
    begin
      MovingAverage.Sum := 0;
      for i := -Reading.MARadius to Reading.MARadius do
      begin
        MovingAverage.Sum := MovingAverage.Sum + ReadSample(SapmpleIndex + i);
      end;
    end;
  end;

  MovingAverage.PrevIndex := SapmpleIndex;
  MovingAverage.PrevAverage := Trunc(MovingAverage.Sum / MovingAverage.N + 0.5);
  Result := MovingAverage.PrevAverage;
end;

procedure TWAVFile.SetReading(const Value: TReading);
begin
  FReading := Value;
  MovingAverage.N := FReading.MARadius * 2 + 1;
  if (FReading.Channel <= 0) or (FReading.Channel > WaveFormatChunk^.NumChannels) then
    FReading.Channel := 1;
  FChannelOffset := (FReading.Channel - 1) * WaveFormatChunk^.BlockAlign div WaveFormatChunk^.NumChannels;
end;

end.
