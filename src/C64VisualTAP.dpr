program
  C64VisualTAP;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitWAVFile in 'UnitWAVFile.pas',
  UnitTAPFile in 'UnitTAPFile.pas',
  UnitAbout in 'UnitAbout.pas' {FormAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'C64 Visual TAP';
  Application.HelpFile := 'C64 Visual TAP.chm';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.
