unit unit_settingform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  windows, LazUTF8;

type

  { TForm_Setting }

  TForm_Setting = class(TForm)
    Button_Cancel: TButton;
    Button_Reset: TButton;
    Button_Open: TButton;
    Button_Okay: TButton;
    Edit_Caption: TEdit;
    Edit_Address: TEdit;
    Edit_Parameter: TEdit;
    Edit_PreView: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog: TOpenDialog;
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OkayClick(Sender: TObject);
    procedure Button_OpenClick(Sender: TObject);
    procedure Button_ResetClick(Sender: TObject);
    procedure Edit_AddressChange(Sender: TObject);
    procedure Edit_CaptionChange(Sender: TObject);
    procedure Edit_ParameterChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    _exef,_path:string;
  public
    TargetButton:TButton;
    procedure SaveToTarget;
    procedure LoadFromTarget;
    procedure RefreshPreView;
  end;

var
  Form_Setting: TForm_Setting;

implementation
uses Unit1;

{$R *.lfm}

{ TForm_Setting }

procedure TForm_Setting.SaveToTarget;
begin
  with TargetButton as TVersionButton do
    begin
      Caption:=Self.Edit_Caption.Caption;
      //Exef:=Self.Edit_Address.Caption;
      //Path:=Exef;
      //while pos('\',Exef)>0 do delete(Exef,1,1);
      //delete(Path,length(Path)-length(Exef),300);
      Path:=_path;
      Exef:=_exef;
      Para:=Self.Edit_Parameter.Caption;
    end;
end;
procedure TForm_Setting.LoadFromTarget;
begin
  with TargetButton as TVersionButton do
    begin
      Self.Edit_Caption.Caption:=Caption;
      Self.Edit_Parameter.Caption:=Para;
      _path:=Path;
      _exef:=Exef;
      Self.Edit_Address.Caption:=WinCPtoUTF8(Path+'\'+Exef);
    end;
end;

procedure TForm_Setting.RefreshPreView;
var tmp:TVersionButton;
begin
  tmp:=TargetButton as TVersionButton;
  Self.Edit_PreView.Caption:=WinCPtoUTF8(Self._path+'\'+Self._exef+' '+Self.Edit_Parameter.Caption+' "filename"');
end;

procedure TForm_Setting.FormHide(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm_Setting.Button_OkayClick(Sender: TObject);
begin
  Self.SaveToTarget;
  (TargetButton as TVersionButton).SaveToReg;
  Self.Hide;
end;

procedure TForm_Setting.Button_OpenClick(Sender: TObject);
begin
  OpenDialog.Title:='选择打开方式';
  OpenDialog.InitialDir:=ExtractFilePath(Self.Edit_Address.Caption);
  OpenDialog.Filter:='应用程序(*.exe)|*.exe|全部文件(*.*)|*.*';
  OpenDialog.DefaultExt:='*.exe';
  if Self.OpenDialog.Execute then
    begin
      Self.Edit_Address.Caption:=Self.OpenDialog.FileName;
      Self.RefreshPreview;
    end;
end;

procedure TForm_Setting.Button_CancelClick(Sender: TObject);
begin
  Self.Hide;
end;

procedure TForm_Setting.Button_ResetClick(Sender: TObject);
begin
  if messagebox(0,pchar(utf8towincp('是否清空当前按键设置？')),pchar(utf8towincp('复位确认')),MB_OKCANCEL) <> IDOK then exit;
  Self.Edit_Caption.Caption:='未使用';
  Self.Edit_Address.Caption:='';
  Self.Edit_Parameter.Caption:='';
end;

procedure TForm_Setting.Edit_AddressChange(Sender: TObject);
begin
  _exef:=UTF8toWinCP(Self.Edit_Address.Caption);
  _path:=_exef;
  while pos('\',_exef)>0 do delete(_exef,1,1);
  delete(_path,length(_path)-length(_exef),300);
  RefreshPreView;
end;

procedure TForm_Setting.Edit_CaptionChange(Sender: TObject);
begin
  RefreshPreView;
end;

procedure TForm_Setting.Edit_ParameterChange(Sender: TObject);
begin
  RefreshPreView;
end;

procedure TForm_Setting.FormShow(Sender: TObject);
begin
  //Form1.Hide;
  LoadFromTarget;
end;

end.

