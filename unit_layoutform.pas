unit unit_layoutform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, hardware_identify;

type

  { TForm_Layout }

  TForm_Layout = class(TForm)
    Button_Apply: TButton;
    Button_Cancel: TButton;
    LabeledEdit_Col: TLabeledEdit;
    LabeledEdit_Row: TLabeledEdit;
    TrackBar_Col: TTrackBar;
    TrackBar_Row: TTrackBar;
    procedure Button_ApplyClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit_ColChange(Sender: TObject);
    procedure LabeledEdit_RowChange(Sender: TObject);
    procedure TrackBar_ColChange(Sender: TObject);
    procedure TrackBar_RowChange(Sender: TObject);
  private

  public
    col,row:byte;
  end;

var
  Form_Layout: TForm_Layout;

implementation
uses Unit1;

{$R *.lfm}

{ TForm_Layout }

procedure TForm_Layout.FormHide(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm_Layout.Button_ApplyClick(Sender: TObject);
begin
  Ahi.reg_add(reg_key+'\LAYOUT','column',IntToStr(Self.col));
  Ahi.reg_add(reg_key+'\LAYOUT','row',IntToStr(Self.row));
  Self.Hide;
end;

procedure TForm_Layout.Button_CancelClick(Sender: TObject);
begin
  Self.Hide;
end;

procedure TForm_Layout.FormShow(Sender: TObject);
begin
  //Form1.Hide;
end;

procedure TForm_Layout.LabeledEdit_ColChange(Sender: TObject);
begin
  try
    Self.col:=StrToInt((Sender as TLabeledEdit).Text);
    TrackBar_Col.Position:=Self.col;
  except
    //
  end;
end;

procedure TForm_Layout.LabeledEdit_RowChange(Sender: TObject);
begin
  try
    Self.row:=StrToInt((Sender as TLabeledEdit).Text);
    TrackBar_Row.Position:=Self.row;
  except
    //
  end;
end;

procedure TForm_Layout.TrackBar_ColChange(Sender: TObject);
begin
  LabeledEdit_Col.Text:=IntToStr((Sender as TTrackBar).position);
end;

procedure TForm_Layout.TrackBar_RowChange(Sender: TObject);
begin
  LabeledEdit_Row.Text:=IntToStr((Sender as TTrackBar).position);
end;

end.

