program cad_versioner;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, unit_settingform, unit_adform, unit_layoutform
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm_Setting, Form_Setting);
  Application.CreateForm(TForm_Ad, Form_Ad);
  Application.CreateForm(TForm_Layout, Form_Layout);
  Application.Run;
end.

