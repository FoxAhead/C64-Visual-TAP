unit UnitTAPFile;

interface

uses
  Classes,
  SysUtils,
  Types,
  TapDisplayTypes,
  Windows;

type
  TTapHeader = packed record
    Identifier: array[0..11] of Char;
    Version: Byte;
    Future: array[0..2] of Byte;
    DataSize: Integer;
  end;

  PTapHeader = ^TTapHeader;

  TTAPFile = class
  private
    FileBuffer: TByteDynArray;
  public
    Header: TTapHeader;
    destructor Destroy; override;
    function Load(FileName: string): Boolean;
    procedure Save(FileName: string);
    procedure FileToTrigger(var TriggerBuffer: TTriggerBuffer);
    procedure TriggerToFile(var TriggerBuffer: TTriggerBuffer);
  end;

const
  TAP_IDENTIFIER = 'C64-TAPE-RAW';
  TAP_HEADER_SIZE = SizeOf(TTapHeader);

implementation

{ TTAPFile }

destructor TTAPFile.Destroy;
begin
  FileBuffer := nil;
  inherited;
end;

function TTAPFile.Load(FileName: string): Boolean;
var
  FileStream: TFileStream;
  TapHeader: PTapHeader;
begin
  Result := False;
  FileBuffer := nil;
  ZeroMemory(@Header, SizeOf(Header));

  if FileName = '' then
    Exit;
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  SetLength(FileBuffer, FileStream.Size);
  FileStream.Read(Pointer(FileBuffer)^, FileStream.Size);
  FileStream.Free;
  TapHeader := @FileBuffer[0];
  if TapHeader^.Identifier <> TAP_IDENTIFIER then
    Exit;
  Header := TapHeader^;
  Result := True;

end;

procedure TTAPFile.Save(FileName: string);
var
  FileStream: TFileStream;
begin
  if Length(FileBuffer) > TAP_HEADER_SIZE then
  begin
    FileStream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
    FileStream.Write(Pointer(FileBuffer)^, Length(FileBuffer));
    FileStream.Free;
  end;
end;

procedure TTAPFile.FileToTrigger(var TriggerBuffer: TTriggerBuffer);
var
  TapHeader: PTapHeader;
  i, j: Integer;
  DataBegin: Integer;
  DataEnd: Integer;
begin
  TriggerBuffer := nil;
  DataBegin := TAP_HEADER_SIZE;
  if Length(FileBuffer) < DataBegin then
    Exit;
  TapHeader := @FileBuffer[0];
  if TapHeader^.Identifier <> TAP_IDENTIFIER then
    Exit;
  DataEnd := DataBegin + TapHeader.DataSize;

  SetLength(TriggerBuffer, TapHeader.DataSize);

  i := DataBegin;
  j := 0;
  while (i > 0) and (i <= DataEnd) and (i <= High(FileBuffer)) do
  begin
    if FileBuffer[i] = $00 then
    begin
      case TapHeader.Version of
        0:
          begin
            TriggerBuffer[j].Length := PAUSE_DEFAULT_TRIGGER_LENGTH;
            i := i + 1;
          end;
        1:
          begin
            TriggerBuffer[j].Length := FileBuffer[i + 1] or (FileBuffer[i + 2] shl 8) or (FileBuffer[i + 3] shl 16);
            i := i + 4;
          end;
      end;
      TriggerBuffer[j].TAPValue := TriggerBuffer[j].Length div 8;
    end
    else
    begin
      TriggerBuffer[j].TAPValue := FileBuffer[i];
      TriggerBuffer[j].Length := FileBuffer[i] * 8;
      i := i + 1;
    end;
    TriggerBuffer[j].Position := -1;
    j := j + 1;
  end;
  SetLength(TriggerBuffer, j);
end;

procedure TTAPFile.TriggerToFile(var TriggerBuffer: TTriggerBuffer);
var
  TapHeader: PTapHeader;
  i, j: Integer;
  TAPValue: Integer;
begin
  FileBuffer := nil;
  SetLength(FileBuffer, TAP_HEADER_SIZE + Length(TriggerBuffer));
  TapHeader := @FileBuffer[0];
  TapHeader.Identifier := TAP_IDENTIFIER;
  TapHeader.Version := $01;
  j := TAP_HEADER_SIZE;
  for i := 0 to High(TriggerBuffer) do
  begin
    TAPValue := TriggerBuffer[i].TAPValue;
    if TAPValue > $FF then
    begin
      SetLength(FileBuffer, Length(FileBuffer) + 3);
      FileBuffer[j] := $00;
      FileBuffer[j + 1] := $FF and TriggerBuffer[i].Length;
      FileBuffer[j + 2] := $FF and (TriggerBuffer[i].Length shr 8);
      FileBuffer[j + 3] := $FF and (TriggerBuffer[i].Length shr 16);
      j := j + 4;
    end
    else
    begin
      FileBuffer[j] := TAPValue;
      j := j + 1;
    end;
  end;
  TapHeader.DataSize := Length(FileBuffer) - TAP_HEADER_SIZE;
end;

end.
