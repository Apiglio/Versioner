unit unit_adform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm_Ad }

  TForm_Ad = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label_version: TLabel;
    Label_version1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form_Ad: TForm_Ad;

implementation
uses Unit1;

{$R *.lfm}

{ TForm_Ad }

procedure TForm_Ad.FormHide(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm_Ad.FormCreate(Sender: TObject);
begin
  Self.Label_version.Caption:='Apiglio Versioner '+version+' by Apiglio';
end;

procedure TForm_Ad.FormShow(Sender: TObject);
begin
  //Form1.Hide;
end;

end.

