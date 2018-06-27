unit UnitAbout;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  ShellAPI;

type
  TFormAbout = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

function CurrentFileInfo(NameApp: string): string;
var
  dump: DWORD;
  size: Integer;
  buffer: PChar;
  VersionPointer, TransBuffer: PChar;
  Temp: Integer;
  CalcLangCharSet: string;
begin
  size := GetFileVersionInfoSize(PChar(NameApp), dump);
  buffer := StrAlloc(size + 1);
  try
    GetFileVersionInfo(PChar(NameApp), 0, size, buffer);

    VerQueryValue(buffer, '\VarFileInfo\Translation', Pointer(TransBuffer), dump);
    if dump >= 4 then
    begin
      Temp := 0;
      StrLCopy(@Temp, TransBuffer, 2);
      CalcLangCharSet := IntToHex(Temp, 4);
      StrLCopy(@Temp, TransBuffer + 2, 2);
      CalcLangCharSet := CalcLangCharSet + IntToHex(Temp, 4);
    end;

    VerQueryValue(buffer, PChar('\StringFileInfo\' + CalcLangCharSet + '\' + 'FileVersion'), Pointer(VersionPointer), dump);
    if (dump > 1) then
    begin
      SetLength(Result, dump);
      StrLCopy(PChar(Result), VersionPointer, dump);
    end
    else
      Result := '0.0.0.0';
  finally
    StrDispose(buffer);
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Label2.Caption := CurrentFileInfo(Application.ExeName);

end;

procedure TFormAbout.Label3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'https://github.com/FoxAhead/C64-Visual-TAP', nil, nil, SW_SHOW);
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
