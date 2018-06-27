unit TapDisplay;

interface

uses
  Windows,
  Classes,
  Controls,
  Forms,
  Graphics,
  Math,
  Messages,
  StdCtrls,
  Types,
  TapDisplayTypes,
  SysUtils,
  Contnrs,
  UnitCRC32,
  Clipbrd;

type
  TRepaintMode = (rmFull, rmOverlayOnly);

  THAlign = (haLeft, haRight);

  TPaintDrawProc = procedure(TargetBitmap: TBitmap) of object;

  TMouseMoveGCellYChangedEvent = procedure(Sender: TObject; MouseMoveGCellY: Integer) of object;

type
  TTapDisplay = class(TCustomControl)
  private
    { Private declarations }
    FZoom: Integer;
    FZoomOutSnap: Boolean;
    FNoPaint: Boolean;
    FPainting: Boolean;
    FRepaintLayer: Integer;
    FMouseDownGCell: TPoint;
    FMouseMoveGCell: TPoint;
    FMouseDownPoint: TPoint;
    FMouseMovePoint: TPoint;
    FMouseUpPoint: TPoint;
    FMouseButtonLeft: Boolean;
    FMouseButtonRight: Boolean;
    FMouseButtonMiddle: Boolean;
    FTriggerCursor: Integer;
    FTriggerThreshold: Integer;
    FSelection: TRect;
    FDebugString: string;
    FFonts: TObjectList;
    FEndianness: TEndianness;
    FLayerBitmap: array[0..2] of TBitmap;
    FMouseOverTrigger: TTrigger;
    FCRC32List: TCardinalDynArray;
    FOnMouseMoveGCellYChanged: TMouseMoveGCellYChangedEvent;
    function PixelToCell(ClientX, ClientY: Integer): TPoint; overload;
    function PixelToCell(ClientPoint: TPoint): TPoint; overload;
    function CellToPixel(CellX, CellY: Integer): TPoint; overload;
    function CellToPixel(CellPoint: TPoint): TPoint; overload;
    function CellToGCell(CellPoint: TPoint): TPoint;
    function GCellToCell(GCellPoint: TPoint): TPoint;
    procedure CallRepaint(RepaintLayer: Integer = 0);
    procedure PaintLayer(Layer: Integer; PaintDrawProc: TPaintDrawProc);
    procedure PaintDrawTap(TargetBitmap: TBitmap);
    procedure PaintDrawGrid(TargetBitmap: TBitmap);
    procedure PaintDrawOverlay(TargetBitmap: TBitmap);
    procedure ZTextOut(TargetCanvas: TCanvas; X, Y: Integer; const TextToDraw: string; BoundsToFit: TRect; HAlign: THAlign = haLeft);
    function ZRectFromPoints(A, B: TPoint): TRect;
    procedure ZOffsetPoint(var Point: TPoint; DX, DY: Integer);
    function ReadScrollInfo: TScrollInfo;
    procedure CalcCRC32List;
    // Get/Set
    procedure SetPosition(const Value: Integer);
    procedure SetPageSize(const Value: Integer);
    function GetPosition: Integer;
    function GetPageSize: Integer;
    function GetMax: Integer;
    function GetMin: Integer;
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetZoom(const Value: Integer);
    procedure SetEndianness(const Value: TEndianness);
    procedure SetSelection(const Value: TRect);
    procedure SetMouseMoveGCell(const Value: TPoint);
    property MouseMoveGCell: TPoint read FMouseMoveGCell write SetMouseMoveGCell;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure WMVScroll(var MSG: TWMVScroll); message WM_VSCROLL;
    procedure WMGetDlgCode(var MSG: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMMouseleave(var message: TMessage); message CM_MOUSELEAVE;
  public
    { Public declarations }
    TriggerBuffer: TTriggerBuffer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ZoomOut;
    function IsValidTriggerBufferIndex(Index: Integer): Boolean;
    procedure SetTAPValueInSelection(NewTAPValue: Integer);
    function GetAvegareTAPValueInSelection: Integer;
    procedure RefreshAll;
    procedure Clear;
  published
    { Published declarations }
    property Min: Integer read GetMin write SetMin default 0;
    property Max: Integer read GetMax write SetMax default 9;
    property PageSize: Integer read GetPageSize write SetPageSize default 10;
    property Position: Integer read GetPosition write SetPosition default 0;
    property Zoom: Integer read FZoom write SetZoom default 0;
    property Selection: TRect read FSelection write SetSelection;
    property Endianness: TEndianness read FEndianness write SetEndianness default LSbF;
    property BoundsRect;
    property ClientWidth;
    property ClientHeight;
    property Anchors;
    property OnMouseMoveGCellYChanged: TMouseMoveGCellYChangedEvent read FOnMouseMoveGCellYChanged write FOnMouseMoveGCellYChanged;
    property MouseOverTrigger: TTrigger read FMouseOverTrigger;
  end;

procedure Register;

implementation

{ TTapDisplay }

type
  TRGBQuad = packed record
    case Integer of
      0:
      (rgbBlue: Byte;
        rgbGreen: Byte;
        rgbRed: Byte;
        rgbReserved: Byte);
      1:
      (rgbValue: Cardinal);
  end;

  TRGB32Array = packed array[0..MaxInt div SizeOf(TRGBQuad) - 1] of TRGBQuad;

  PRGB32Array = ^TRGB32Array;

  TScanline = TRGB32Array;

  PScanline = ^TScanline;

const
  CELLS_IN_ROW = 256;
  ZOOM_FACTOR = 1.5;
  ZOOM_HIGH = 100;

procedure Register;
begin
  RegisterComponents('TapDisplay', [TTapDisplay]);
end;

constructor TTapDisplay.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
  TabStop := True;
  ControlStyle := ControlStyle + [csOpaque];

  FFonts := TObjectList.Create;
  FFonts.Add(TFont.Create);
  (FFonts.Last as TFont).Color := clWhite;
  (FFonts.Last as TFont).Name := 'Courier New';
  (FFonts.Last as TFont).Size := 9;
  FFonts.Add(TFont.Create);
  (FFonts.Last as TFont).Color := clDkGray;
  (FFonts.Last as TFont).Name := 'Small Fonts';
  (FFonts.Last as TFont).Size := 8;

end;

destructor TTapDisplay.Destroy;
begin
  TriggerBuffer := nil;
  FFonts.Free;
  inherited Destroy;
end;

procedure TTapDisplay.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_VSCROLL;
end;

procedure TTapDisplay.CreateWnd;
begin
  inherited;
  Min := 0;
  Max := 100;
  PageSize := 10;
  Position := 0;
end;

function TTapDisplay.ReadScrollInfo: TScrollInfo;
begin
  Result.cbSize := SizeOf(TScrollInfo);
  Result.fMask := SIF_ALL;
  GetScrollInfo(Handle, SB_VERT, Result);
end;

function TTapDisplay.GetMin: Integer;
begin
  Result := ReadScrollInfo.nMin;
end;

procedure TTapDisplay.SetMin(const Value: Integer);
var
  NewScrollInfo: TScrollInfo;
begin
  NewScrollInfo.cbSize := SizeOf(NewScrollInfo);
  NewScrollInfo.fMask := SIF_RANGE;
  NewScrollInfo.nMin := Value;
  NewScrollInfo.nMax := Max;
  SetScrollInfo(Handle, SB_VERT, NewScrollInfo, True);
end;

function TTapDisplay.GetMax: Integer;
begin
  Result := ReadScrollInfo.nMax;
end;

procedure TTapDisplay.SetMax(const Value: Integer);
var
  NewScrollInfo: TScrollInfo;
begin
  if Max = Value then
    Exit;
  NewScrollInfo.cbSize := SizeOf(NewScrollInfo);
  NewScrollInfo.fMask := SIF_RANGE + SIF_DISABLENOSCROLL;
  NewScrollInfo.nMin := Min;
  NewScrollInfo.nMax := Value;
  if NewScrollInfo.nMax < 9 then
    NewScrollInfo.nMax := 9;
  SetScrollInfo(Handle, SB_VERT, NewScrollInfo, True);
  if FZoomOutSnap then
    ZoomOut;
end;

function TTapDisplay.GetPosition: Integer;
begin
  Result := ReadScrollInfo.nPos;
end;

procedure TTapDisplay.SetPosition(const Value: Integer);
var
  OldPosition: Integer;
  NewScrollInfo: TScrollInfo;
begin
  OldPosition := Position;
  if OldPosition = Value then
    Exit;
  NewScrollInfo.cbSize := SizeOf(NewScrollInfo);
  NewScrollInfo.fMask := SIF_POS + SIF_DISABLENOSCROLL;
  NewScrollInfo.nPos := Value;
  SetScrollInfo(Handle, SB_VERT, NewScrollInfo, True);
  if Position <> OldPosition then
    CallRepaint;
end;

function TTapDisplay.GetPageSize: Integer;
begin
  Result := ReadScrollInfo.nPage;
end;

procedure TTapDisplay.SetPageSize(const Value: Integer);
var
  NewScrollInfo: TScrollInfo;
begin
  if PageSize = Value then
    Exit;
  NewScrollInfo.cbSize := SizeOf(NewScrollInfo);
  NewScrollInfo.fMask := SIF_PAGE + SIF_DISABLENOSCROLL;
  NewScrollInfo.nPage := Value;
  if NewScrollInfo.nPage > Cardinal(Length(TriggerBuffer)) + 1 then
    NewScrollInfo.nPage := Length(TriggerBuffer) + 1;
  if NewScrollInfo.nPage < 10 then
    NewScrollInfo.nPage := 10;
  SetScrollInfo(Handle, SB_VERT, NewScrollInfo, True);
  CallRepaint;
end;

procedure TTapDisplay.SetZoom(const Value: Integer);
var
  OldPageSize: Integer;
  k: Double;
  CursorVisible: Boolean;
  PivotY: Integer;
begin
  FNoPaint := True;
  CursorVisible := (FTriggerCursor - Position >= 0) and (FTriggerCursor - Position < PageSize);
  if CursorVisible then
    PivotY := FTriggerCursor
  else
    PivotY := FMouseMoveGCell.Y;
  k := (PivotY - Position) / PageSize;
  OldPageSize := PageSize;
  FZoom := Value;
  if FZoom < 0 then
    FZoom := 0;
  PageSize := Trunc(10 * Power(ZOOM_FACTOR, FZoom));
  if PageSize > High(TriggerBuffer) then
  begin
    FZoom := Ceil(LogN(ZOOM_FACTOR, PageSize / 10));
    FZoomOutSnap := True;
  end
  else
    FZoomOutSnap := False;
  if PageSize <> OldPageSize then
    Position := PivotY - Trunc(k * PageSize + 0.5);
  FNoPaint := False;
  CallRepaint;
end;

procedure TTapDisplay.SetEndianness(const Value: TEndianness);
begin
  FEndianness := Value;
  CallRepaint(2);
end;

procedure TTapDisplay.SetSelection(const Value: TRect);
begin
  IntersectRect(FSelection, Value, Rect(0, 0, 256, Length(TriggerBuffer)));
end;

procedure TTapDisplay.WMVScroll(var MSG: TWMVScroll);
begin
  MSG.Result := 0;
  case MSG.ScrollCode of
    SB_LINEDOWN:
      Position := Position + 1;
    SB_LINEUP:
      Position := Position - 1;
    SB_PAGEDOWN:
      Position := Position + PageSize;
    SB_PAGEUP:
      Position := Position - PageSize;
    SB_THUMBPOSITION, SB_THUMBTRACK:
      Position := ReadScrollInfo.nTrackPos;
  end;
end;

procedure TTapDisplay.CallRepaint(RepaintLayer: Integer);
begin
  if not FNoPaint then
  begin
    if not FPainting then
    begin
      FRepaintLayer := RepaintLayer;
      Repaint;
    end;
  end;
end;

procedure TTapDisplay.Paint;
begin
  FPainting := True;
  Max := High(TriggerBuffer);
  inherited;

  if FLayerBitmap[0] = nil then
    FRepaintLayer := 0;
  if FRepaintLayer <= 0 then
    PaintLayer(0, PaintDrawTap);
  if FRepaintLayer <= 1 then
    PaintLayer(1, PaintDrawGrid);
  if FRepaintLayer <= 2 then
    PaintLayer(2, PaintDrawOverlay);
  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(0, 0, FLayerBitmap[2]);

  if Focused then
  begin
    SetTextColor(Canvas.Handle, ColorToRGB(clWindowText));
    Canvas.Brush.Color := clWhite;
    Canvas.DrawFocusRect(ClientRect);
  end;

  FRepaintLayer := 0;
  FPainting := False;
end;

procedure TTapDisplay.PaintLayer(Layer: Integer; PaintDrawProc: TPaintDrawProc);
begin
  if FLayerBitmap[Layer] = nil then
    FLayerBitmap[Layer] := TBitmap.Create;
  FLayerBitmap[Layer].Width := ClientWidth;
  FLayerBitmap[Layer].Height := ClientHeight;
  if Layer > 0 then
  begin
    if FLayerBitmap[Layer - 1] = nil then
      Exit;
    FLayerBitmap[Layer].Canvas.CopyMode := cmSrcCopy;
    FLayerBitmap[Layer].Canvas.Draw(0, 0, FLayerBitmap[Layer - 1]);
  end;
  PaintDrawProc(FLayerBitmap[Layer]);
end;

procedure TTapDisplay.PaintDrawTap(TargetBitmap: TBitmap);
var
  Bitmap: TBitmap;
  i, j, k: Integer;
  Y: Integer;
  PrevY: Integer;
  NumberOfTriggers: Integer;
  TriggersToShow: Integer;
  TAPValue: Integer;
  ScanLine: PScanline;
begin
  TargetBitmap.Width := Width;
  TargetBitmap.Height := Height;
  TargetBitmap.Canvas.Brush.Color := clBlack;
  TargetBitmap.Canvas.Brush.Style := bsSolid;
  TargetBitmap.Canvas.FillRect(Rect(0, 0, TargetBitmap.Width, TargetBitmap.Height));

  NumberOfTriggers := Length(TriggerBuffer);
  if NumberOfTriggers >= 0 then
  begin
    Bitmap := TBitmap.Create;

    Bitmap.PixelFormat := pf32bit;
    Bitmap.Canvas.Pen.Color := $33FF33;
    Bitmap.Canvas.Brush.Color := clBlack;
    Bitmap.Width := CELLS_IN_ROW;

    TriggersToShow := PageSize;
    if TriggersToShow = 0 then
      TriggersToShow := Height;
    if TriggersToShow < Height then
      Bitmap.Height := TriggersToShow
    else
      Bitmap.Height := Height;

    if Bitmap.Height < 1 then
      Bitmap.Height := 1;

    Bitmap.Canvas.Brush.Color := $C80000;
    Bitmap.Canvas.FillRect(Rect($30 - 3, 0, $30 + 4, Bitmap.Height));
    Bitmap.Canvas.FillRect(Rect($42 - 3, 0, $42 + 4, Bitmap.Height));
    Bitmap.Canvas.FillRect(Rect($56 - 3, 0, $56 + 4, Bitmap.Height));
    Bitmap.Canvas.Brush.Color := clBlack;

    i := Position;
    j := 0;
    PrevY := -1;
    while (j < TriggersToShow) and (i < NumberOfTriggers) do
    begin
      if i >= 0 then
      begin
        Y := Trunc(j * Bitmap.Height / TriggersToShow);
        if (Y <> PrevY) or (ScanLine = nil) then
        begin
          PrevY := Y;
          ScanLine := Bitmap.ScanLine[Y];
        end;
        TAPValue := TriggerBuffer[i].TAPValue;
        //TapValue := i mod 256;
        if TAPValue > $FF then
        begin
          for k := 0 to Bitmap.Width - 1 do
            if ScanLine^[k].rgbGreen <> $FF then
            begin
              ScanLine^[k].rgbValue := $CC0000;
            end;
        end
        else
        begin
          ScanLine^[TAPValue].rgbValue := $33FF33;
        end;
      end;
      i := i + 1;
      j := j + 1;
    end;
    TargetBitmap.Canvas.CopyMode := cmSrcCopy;
    TargetBitmap.Canvas.StretchDraw(Rect(0, 0, Width - 16, Height), Bitmap);
    Bitmap.Free;

  end;
end;

procedure TTapDisplay.PaintDrawGrid(TargetBitmap: TBitmap);
var
  CellHeight: Integer;
  i: Integer;
  TextBuffer: string;
  LineFrom: TPoint;
  TriggerNumber: Integer;
begin
  CellHeight := ClientHeight div PageSize;
  if CellHeight > 1 then
  begin
    TargetBitmap.Canvas.Pen.Mode := pmCopy;
    TargetBitmap.Canvas.Pen.Style := psDot;
    TargetBitmap.Canvas.Pen.Color := TColor($202020);
    TargetBitmap.Canvas.Brush.Style := bsClear;
    TargetBitmap.Canvas.Font := FFonts[1] as TFont;
    for i := 0 to PageSize - 1 do
    begin
      TriggerNumber := Position + i;
      // Line
      LineFrom := CellToPixel(0, i);
      if (TriggerNumber - FTriggerCursor) mod 8 = 0 then
        TargetBitmap.Canvas.Pen.Style := psSolid
      else
        TargetBitmap.Canvas.Pen.Style := psDot;
      if (CellHeight > 10) or (TargetBitmap.Canvas.Pen.Style = psSolid) then
      begin
        TargetBitmap.Canvas.PenPos := LineFrom;
        TargetBitmap.Canvas.LineTo(ClientWidth, LineFrom.Y);
        // Number
        TextBuffer := Format('%d', [Position + i]);
        TargetBitmap.Canvas.TextOut(2, LineFrom.Y + CellHeight div 2 - 5, TextBuffer);
      end;
    end;
  end;
end;

procedure TTapDisplay.PaintDrawOverlay(TargetBitmap: TBitmap);
var
  TextBuffer: string;
  CellUnderMouse: TPoint;
  TriggerNumber: Integer;
  ClientSelection: TRect;
  CellHeight: Integer;
  i: Integer;
  Y: Integer;
  TAPValue: Integer;
  LineFrom: TPoint;
  ShiftRegister: Byte;
  ShiftRegisterChar: Char;
begin
  TargetBitmap.Canvas.Brush.Style := bsClear;
  TargetBitmap.Canvas.Font := FFonts[0] as TFont;

  CellHeight := ClientHeight div PageSize;
  CellUnderMouse := PixelToCell(FMouseMovePoint);
  TriggerNumber := CellUnderMouse.Y + Position;

  // Position
  TextBuffer := Format('Pos: %d  Max: %d  PgSz: %d', [Position, Max, PageSize]);
  ZTextOut(TargetBitmap.Canvas, ClientRect.Right - 10, 10, TextBuffer, ClientRect, haRight);

  if IsValidTriggerBufferIndex(TriggerNumber) then
  begin
    TextBuffer := Format('X: $%.2x  Tr: %d  TrLen: %d  TrPos: %d', [TriggerBuffer[FTriggerCursor].TAPValue, FTriggerCursor, TriggerBuffer[FTriggerCursor].Length, TriggerBuffer[FTriggerCursor].Position]);
    ZTextOut(TargetBitmap.Canvas, ClientRect.Right - 10, 30, TextBuffer, ClientRect, haRight);

    TextBuffer := Format('Sel: %d,%d - %d,%d (%d,%d)', [FSelection.Left, FSelection.Top, FSelection.Right, FSelection.Bottom, FSelection.Right - FSelection.Left, FSelection.Bottom - FSelection.Top]);
    ZTextOut(TargetBitmap.Canvas, ClientRect.Right - 10, 50, TextBuffer, ClientRect, haRight);

    if PtInRect(ClientRect, ScreenToClient(Mouse.CursorPos)) then
    begin
      // Text next to mouse cursor
      TextBuffer := Format('X: $%.2x  Tr: %d  TrLen: %d  TrPos: %d', [CellUnderMouse.X, TriggerNumber, TriggerBuffer[TriggerNumber].Length, TriggerBuffer[TriggerNumber].Position]);
      ZTextOut(TargetBitmap.Canvas, FMouseMovePoint.X + 10, FMouseMovePoint.Y - 15, TextBuffer, ClientRect);
      // Highlight cell under mouse cursor
      TargetBitmap.Canvas.Brush.Color := clYellow;
      TargetBitmap.Canvas.FrameRect(Classes.Rect(CellToPixel(CellUnderMouse), CellToPixel(CellUnderMouse.X + 1, CellUnderMouse.Y + 1)));
      TargetBitmap.Canvas.Brush.Style := bsClear;
    end;
  end;

  // CRC32List
  for i := 0 to High(FCRC32List) do
  begin
    TextBuffer := Format('CRC[%d]: $%.8x', [i, FCRC32List[i]]);
    Y := 70 + i * 11;
    if Y > ClientHeight - 15 then
      Break;
    ZTextOut(TargetBitmap.Canvas, ClientRect.Right - 10, 70 + i * 11, TextBuffer, ClientRect, haRight);
  end;

  {if FMouseButtonRight then
  begin}
  //TextBuffer := Format('DEBUG:TapY=%d;ClientHeight=%d;CellHeight=%g', [TapY, ClientHeight, CellHeight]);
  //TextBuffer := Format('DEBUG:FMouseDown/Up %d,%d / %d,%d', [FMouseDownPoint.X, FMouseDownPoint.Y, FMouseUpPoint.X, FMouseUpPoint.Y]);
  //TextBuffer := Format('DEBUG:FMouseDownCell %d,%d', [FMouseDownCell.X, FMouseDownCell.Y]);
  //TextBuffer := FDebugString;
  //TargetBitmap.Canvas.Brush.Style := bsClear;
  //TargetBitmap.Canvas.TextOut(5, Height - 16, TextBuffer);
  {end;}

  // Trigger Cursor
  if (FTriggerCursor >= Position) and (FTriggerCursor < (Position + PageSize)) then
  begin
    TargetBitmap.Canvas.Pen.Mode := pmXor;
    TargetBitmap.Canvas.Pen.Style := psDot;
    TargetBitmap.Canvas.Pen.Color := clWhite;
    TargetBitmap.Canvas.PenPos := CellToPixel(0, FTriggerCursor - Position);
    TargetBitmap.Canvas.LineTo(ClientWidth, TargetBitmap.Canvas.PenPos.Y);
  end;

  // Trigger Threshold
  if (FTriggerThreshold > 0) and (FTriggerThreshold < CELLS_IN_ROW) then
  begin
    TargetBitmap.Canvas.Pen.Mode := pmXor;
    TargetBitmap.Canvas.Pen.Style := psDot;
    TargetBitmap.Canvas.Pen.Color := clWhite;
    TargetBitmap.Canvas.PenPos := CellToPixel(FTriggerThreshold, 0);
    TargetBitmap.Canvas.LineTo(TargetBitmap.Canvas.PenPos.X, ClientHeight);
  end;

  // 0 / 1
  if CellHeight > 0 then
  begin
    TargetBitmap.Canvas.Pen.Mode := pmCopy;
    TargetBitmap.Canvas.Pen.Style := psDot;
    TargetBitmap.Canvas.Pen.Color := TColor($202020);
    //TargetBitmap.Canvas.Brush.Style := bsClear;
    //TargetCanvas.Font := FFonts[0];
    ShiftRegister := 0;
    for i := 0 to PageSize - 1 do
    begin
      TriggerNumber := Position + i;
      if (FTriggerThreshold > 0) and (FTriggerThreshold < CELLS_IN_ROW) then
      begin
        if IsValidTriggerBufferIndex(TriggerNumber) then
        begin
          LineFrom := CellToPixel(FTriggerThreshold, i);
          TAPValue := TriggerBuffer[TriggerNumber].TAPValue;
          if TAPValue < FTriggerThreshold then
          begin
            TextBuffer := '0';
            case FEndianness of
              LSbF:
                ShiftRegister := ShiftRegister shr 1;
              MSbF:
                ShiftRegister := ShiftRegister shl 1;
            end;
          end
          else if TAPValue <= $FF then
          begin
            TextBuffer := '1';
            case FEndianness of
              LSbF:
                ShiftRegister := ShiftRegister shr 1 or $80;
              MSbF:
                ShiftRegister := ShiftRegister shl 1 or $01;
            end;
          end
          else
            TextBuffer := '';
          if CellHeight > 7 then
            TargetBitmap.Canvas.TextOut(LineFrom.X + 5, LineFrom.Y + CellHeight div 2 - 8, TextBuffer);
          if (TriggerNumber - FTriggerCursor) and 7 = 7 then
          begin
            if ShiftRegister > 31 then
              ShiftRegisterChar := Chr(ShiftRegister)
            else
              ShiftRegisterChar := '.';
            TextBuffer := ShiftRegisterChar + ' ' + Format('%.2x', [ShiftRegister]);
            TargetBitmap.Canvas.TextOut(LineFrom.X - 45, LineFrom.Y + CellHeight div 2 - 8, TextBuffer);
          end;
        end;
      end;
    end;
  end;

  // Selection
  if not IsRectEmpty(FSelection) then
  begin
    ClientSelection := Classes.Rect(CellToPixel(FSelection.Left, FSelection.Top - Position), CellToPixel(FSelection.Right, FSelection.Bottom - Position));
    if IntersectRect(ClientSelection, ClientSelection, ClientRect) then
    begin
      TargetBitmap.Canvas.CopyMode := cmDstInvert;
      TargetBitmap.Canvas.CopyRect(ClientSelection, TargetBitmap.Canvas, ClientSelection);
      TargetBitmap.Canvas.CopyMode := cmSrcCopy;
    end;
  end;

end;

procedure TTapDisplay.DoEnter;
begin
  inherited;
  CallRepaint(3);
end;

procedure TTapDisplay.DoExit;
begin
  inherited;
  CallRepaint(3);
end;

procedure TTapDisplay.WMGetDlgCode(var MSG: TWMGetDlgCode);
begin
  MSG.Result := DLGC_WANTARROWS;
end;

procedure TTapDisplay.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_UP:
      Position := Position - 1;
    VK_DOWN:
      Position := Position + 1;
    VK_PRIOR:
      Position := Position - PageSize;
    VK_NEXT:
      Position := Position + PageSize;
    VK_HOME:
      Position := Min;
    VK_END:
      Position := Max;
  end;
end;

procedure TTapDisplay.KeyPress(var Key: Char);
begin
  inherited;
  case Key of
    ^C:
      begin
        Clipboard.AsText := IntToStr(FMouseOverTrigger.Position);
      end;
  end;
end;

procedure TTapDisplay.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClientA: TPoint;
  ClientB: TPoint;
  PointC: TPoint;
  VectorFromC: TPoint;
  Quadrant: Integer;
  RepaintLevel: Integer;
begin
  inherited;
  RepaintLevel := 2;
  SetFocus;

  case Button of
    mbLeft:
      if not FMouseButtonLeft then
      begin
        FMouseButtonLeft := True;
        FMouseDownPoint := Point(X, Y);
        if ssShift in Shift then
        begin
          ClientA := CellToPixel(GCellToCell(FSelection.TopLeft));
          ClientB := CellToPixel(GCellToCell(FSelection.BottomRight));
          PointC := CenterPoint(Classes.Rect(ClientA, ClientB));
          VectorFromC := Point(X - PointC.X, Y - PointC.Y);
          Quadrant := (VectorFromC.X shr 31) or (VectorFromC.Y shr 31 shl 1);
          case Quadrant of
            0:
              FMouseDownGCell := FSelection.TopLeft;
            1:
              FMouseDownGCell := Point(FSelection.Right - 1, FSelection.Top);
            2:
              FMouseDownGCell := Point(FSelection.Left, FSelection.Bottom - 1);
            3:
              FMouseDownGCell := Point(FSelection.Right - 1, FSelection.Bottom - 1);
          end;
          MouseMove(Shift, X, Y);
        end
        else
        begin
          FMouseDownGCell := CellToGCell(PixelToCell(FMouseDownPoint));
        end;
      end;
    mbMiddle:
      if not FMouseButtonMiddle then
      begin
        FMouseButtonMiddle := True;
        FTriggerThreshold := PixelToCell(X, Y).X;
      end;
    mbRight:
      if not FMouseButtonRight then
      begin
        FMouseButtonRight := True;
        FTriggerCursor := CellToGCell(PixelToCell(X, Y)).Y;
        if IsRectEmpty(FSelection) then
          FSelection := Rect(0, FTriggerCursor, 0, FTriggerCursor);
        RepaintLevel := 1;
      end;
  end;

  CallRepaint(RepaintLevel);
end;

procedure TTapDisplay.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  RepaintLevel: Integer;
begin
  inherited;
  RepaintLevel := 2;
  FMouseMovePoint := Point(X, Y);
  MouseMoveGCell := CellToGCell(PixelToCell(FMouseMovePoint));
  if FMouseButtonLeft then
  begin
    if not PointsEqual(FMouseDownPoint, FMouseMovePoint) or not PointsEqual(FMouseDownGCell, FMouseMoveGCell) then
      Selection := ZRectFromPoints(FMouseDownGCell, FMouseMoveGCell);
  end;
  if FMouseButtonMiddle then
  begin
    FTriggerThreshold := PixelToCell(X, Y).X;
  end;
  if FMouseButtonRight then
  begin
    FTriggerCursor := CellToGCell(PixelToCell(X, Y)).Y;
    if IsRectEmpty(FSelection) then
      FSelection := Rect(0, FTriggerCursor, 0, FTriggerCursor);
    RepaintLevel := 1;
  end;
  if IsValidTriggerBufferIndex(FMouseMoveGCell.Y) then
    FMouseOverTrigger := TriggerBuffer[FMouseMoveGCell.Y];
  CallRepaint(RepaintLevel);
end;

procedure TTapDisplay.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MouseUpGCell: TPoint;
begin
  inherited;
  case Button of
    mbLeft:
      if FMouseButtonLeft then
      begin
        FMouseButtonLeft := False;
        FMouseUpPoint := Point(X, Y);
        MouseUpGCell := CellToGCell(PixelToCell(FMouseUpPoint));
        if PointsEqual(FMouseDownPoint, FMouseUpPoint) and PointsEqual(FMouseDownGCell, MouseUpGCell) then
          FSelection := Rect(0, FTriggerCursor, 0, FTriggerCursor);
      end;
    mbMiddle:
      if FMouseButtonMiddle then
      begin
        FMouseButtonMiddle := False;
      end;
    mbRight:
      if FMouseButtonRight then
      begin
        FMouseButtonRight := False;
      end;
  end;
  CallRepaint(2);
end;

procedure TTapDisplay.CMMouseleave(var message: TMessage);
begin
  FMouseButtonMiddle := False;
  FMouseButtonRight := False;
  CallRepaint(2);
end;

procedure TTapDisplay.Resize;
begin
  inherited;
  CallRepaint;
end;

{ Pixel perfect magic to align with Canvas.StretchDraw }

function TTapDisplay.PixelToCell(ClientX, ClientY: Integer): TPoint;
var
  CellX: Integer;
  CellY: Integer;
begin
  if ClientWidth > CELLS_IN_ROW then
    CellX := Trunc((ClientX + 0.5) * CELLS_IN_ROW / ClientWidth)
  else
    CellX := ClientX * CELLS_IN_ROW div ClientWidth;
  if ClientHeight > PageSize then
    CellY := Trunc((ClientY + 0.5) * PageSize / ClientHeight)
  else
    CellY := ClientY * PageSize div ClientHeight;
  Result := Point(CellX, CellY);
end;

function TTapDisplay.PixelToCell(ClientPoint: TPoint): TPoint;
begin
  Result := PixelToCell(ClientPoint.X, ClientPoint.Y);
end;

{ Pixel perfect magic to align with Canvas.StretchDraw }

function TTapDisplay.CellToPixel(CellX, CellY: Integer): TPoint;
var
  PixelX: Integer;
  PixelY: Integer;
begin
  if ClientWidth > CELLS_IN_ROW then
    PixelX := -Floor(0.5 - CellX * ClientWidth / CELLS_IN_ROW)
  else
    PixelX := CellX * ClientWidth div CELLS_IN_ROW;
  if ClientHeight > PageSize then
    PixelY := -Floor(0.5 - CellY * ClientHeight / PageSize)
  else
    PixelY := CellY * ClientHeight div PageSize;
  Result := Point(PixelX, PixelY);
end;

function TTapDisplay.CellToPixel(CellPoint: TPoint): TPoint;
begin
  Result := CellToPixel(CellPoint.X, CellPoint.Y);
end;

procedure TTapDisplay.ZoomOut;
begin
  Zoom := ZOOM_HIGH;
end;

procedure TTapDisplay.ZTextOut(TargetCanvas: TCanvas; X, Y: Integer; const TextToDraw: string; BoundsToFit: TRect; HAlign: THAlign);
var
  TextToDrawExtent: TSize;
  X1, Y1: Integer;
begin
  TextToDrawExtent := TargetCanvas.TextExtent(TextToDraw);
  case HAlign of
    haLeft:
      X1 := X;
    haRight:
      X1 := X - TextToDrawExtent.cx;
  else
    X1 := X;
  end;
  X1 := Math.Min(X1, BoundsToFit.Right - TextToDrawExtent.cx);
  Y1 := Math.Min(Y, BoundsToFit.Bottom - TextToDrawExtent.cy);
  X1 := Math.Max(X1, BoundsToFit.Left);
  Y1 := Math.Max(Y1, BoundsToFit.Top);
  TargetCanvas.TextOut(X1, Y1, TextToDraw);
end;

{ Get rectangle based on two opposite corner points
  Both points are in rectangle }

function TTapDisplay.ZRectFromPoints(A, B: TPoint): TRect;
var
  C, D: TPoint;
begin
  C.X := Math.Min(A.X, B.X);
  C.Y := Math.Min(A.Y, B.Y);
  D.X := Math.Max(A.X, B.X) + 1;
  D.Y := Math.Max(A.Y, B.Y) + 1;
  Result := Classes.Rect(C, D);
end;

procedure TTapDisplay.ZOffsetPoint(var Point: TPoint; DX, DY: Integer);
begin
  Point.X := Point.X + DX;
  Point.Y := Point.Y + DY;
end;

function TTapDisplay.CellToGCell(CellPoint: TPoint): TPoint;
begin
  Result := Point(CellPoint.X, CellPoint.Y + Position);
end;

function TTapDisplay.GCellToCell(GCellPoint: TPoint): TPoint;
begin
  Result := Point(GCellPoint.X, GCellPoint.Y - Position);
end;

procedure TTapDisplay.SetTAPValueInSelection(NewTAPValue: Integer);
var
  i: Integer;
  TAPValue: Integer;
  TAPPoint: TPoint;
  //NewTAPPoint: TPoint;
begin
  for i := Selection.Top to Selection.Bottom - 1 do
  begin
    if IsValidTriggerBufferIndex(i) then
    begin
      TAPValue := TriggerBuffer[i].TAPValue;
      TAPPoint := Point(TAPValue, i);
      //NewTAPPoint := Point(NewTAPValue, i);
      if PtInRect(Selection, TAPPoint) {and PtInRect(Selection, NewTAPPoint)} then
      begin
        TriggerBuffer[i].TAPValue := NewTAPValue;
        TriggerBuffer[i].Length := NewTAPValue * 8;
      end;
    end;
  end;
  RefreshAll;
end;

function TTapDisplay.GetAvegareTAPValueInSelection: Integer;
var
  i: Integer;
  TAPValue: Integer;
  TAPValueSum: Integer;
  TAPCount: Integer;
  TAPPoint: TPoint;
begin
  TAPValueSum := 0;
  TAPCount := 0;
  for i := Selection.Top to Selection.Bottom - 1 do
  begin
    if IsValidTriggerBufferIndex(i) then
    begin
      TAPValue := TriggerBuffer[i].TAPValue;
      TAPPoint := Point(TAPValue, i);
      if PtInRect(Selection, TAPPoint) then
      begin
        TAPValueSum := TAPValueSum + TAPValue;
        TAPCount := TAPCount + 1;
      end;
    end;
  end;
  if TAPCount <> 0 then
    Result := Trunc(TAPValueSum / TAPCount + 0.5)
  else
    Result := -1;
end;

function TTapDisplay.IsValidTriggerBufferIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0) and (Index < Length(TriggerBuffer));
end;

procedure TTapDisplay.CalcCRC32List;
var
  i, j: Integer;
  CRC32Opened: Boolean;
  TAPValueByte: Byte;
begin
  CRC32Opened := False;
  j := -1;
  SetLength(FCRC32List, 0);
  for i := 0 to High(TriggerBuffer) do
  begin
    if TriggerBuffer[i].TAPValue <= $FF then
    begin
      if not CRC32Opened then
      begin
        j := j + 1;
        SetLength(FCRC32List, j + 1);
        FCRC32List[j] := $FFFFFFFF;
        CRC32Opened := True;
      end;
      TAPValueByte := TriggerBuffer[i].TAPValue;
      TCRC32.CalcByte(FCRC32List[j], TAPValueByte);
    end
    else
      CRC32Opened := False;
  end;
  for i := 0 to j do
  begin
    FCRC32List[i] := not FCRC32List[i];
  end;
end;

procedure TTapDisplay.RefreshAll;
begin
  CalcCRC32List;
  CallRepaint;
end;

procedure TTapDisplay.SetMouseMoveGCell(const Value: TPoint);
var
  YChanged: Boolean;
begin
  YChanged := (FMouseMoveGCell.Y <> Value.Y);
  if (FMouseMoveGCell.X <> Value.X) or YChanged then
    FMouseMoveGCell := Value;
  if YChanged and Assigned(FOnMouseMoveGCellYChanged) then
    FOnMouseMoveGCellYChanged(Self, FMouseMoveGCell.Y);
end;

procedure TTapDisplay.Clear;
begin
  TriggerBuffer := nil;
  RefreshAll;
end;

end.
