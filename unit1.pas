//在打开方式为有非ascii码的情况下会出错

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
   {Apiglio_Useful, }hardware_identify, Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, Menus, StdCtrls, Registry, Windows, Dos, LazUtf8;

const
  version = '2.0';
  reg_key='HKCU\Software\ApiglioToolBox\Apiglio Versioner';   //'HKCU\Software\ApiglioToolBox\Apiglio CAD Versioner'


type

  { TVersionButton }

  TVersionButton = class(TButton)
    public
      ID:byte;
      Path:ansistring;
      Exef:ansistring;
      Para:ansistring;
      procedure ButtonClick(Sender: TObject);
      procedure ButtonRightClick(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
    public
      procedure LoadFromReg;
      procedure SaveToReg;
      procedure RunExe;
      constructor Create(AOwner:TComponent;ids:byte);
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem_About: TMenuItem;
    MenuItem_Guidance: TMenuItem;
    MenuItem_Option: TMenuItem;
    MenuItem_Layout: TMenuItem;
    MenuItem_Manual: TMenuItem;
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem_AboutClick(Sender: TObject);
    procedure MenuItem_LayoutClick(Sender: TObject);
    procedure MenuItem_ManualClick(Sender: TObject);
  private
    Buttons:array[0..99] of TVersionButton;
    { private declarations }
  public
    {}
  end;

var
  Form1: TForm1;
  i:integer;
  col,row:byte;
  filepath:ansistring;

implementation
uses unit_settingform, unit_adform, unit_layoutform;

{$R *.lfm}


{ TVersionButton }

procedure TVersionButton.LoadFromReg;
begin
  Self.Caption:=WinCPToUtf8(Ahi.reg_query(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'caption'));
  if Self.Caption='' then Self.Caption:='未使用';
  Exef:=Ahi.reg_query(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'address');
  Path:=Exef;
  while pos('\',Exef)>0 do delete(Exef,1,1);
  delete(Path,length(Path)-length(Exef),300);
  Para:=Ahi.reg_query(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'param');
end;
procedure TVersionButton.SaveToReg;
begin
  if Self.Caption<>'未使用' then
    Ahi.reg_add(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'caption',Utf8ToWinCP(Self.Caption))
  else Ahi.reg_add(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'caption','');
  Ahi.reg_add(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'address',Self.Path+'\'+Self.Exef);
  Ahi.reg_add(reg_key,Ahi.zeroplus(Self.ID,2)+'_'+'param',Self.Para);
end;
procedure TVersionButton.RunExe;
begin
  if filepath<>'::<_break>' then
    begin
      winexec(PChar(Self.Path+'\'+Self.Exef+' '+Self.Para+' "'+filepath+'"'),SW_SHOWDEFAULT);
    end
  else messagebox(0,PChar(UTF8toWinCP('未指定文件名！')),PChar(UTF8toWinCP('警告')),MB_OK);
end;

procedure TVersionButton.ButtonClick(Sender: TObject);
var str_buffer:ansistring;
begin
  RunExe;
  halt;
end;
procedure TVersionButton.ButtonRightClick(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
begin
  if (Button<>mbRight)or(Shift<>[]) then exit;
  Form_Setting.TargetButton:=Sender as TButton;
  Form_Setting.Show;
end;

constructor TVersionButton.Create(AOwner:TComponent;ids:byte);
begin
  inherited Create(AOwner);
  Self.ID:=ids;
  Self.parent:=AOwner as TWinControl;
  Self.OnClick:=@(Self.ButtonClick);
  Self.OnMouseUp:=@(Self.ButtonRightClick);

end;

{ TForm1 }




procedure TForm1.FormActivate(Sender: TObject);
begin
  Form_Layout.Hide;
  Form_Setting.Hide;
  Form_Ad.Hide;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
  try
    col:=StrToInt(Ahi.reg_query(reg_key+'\LAYOUT','column'));
  except
    col:=3;
  end;
  try
    row:=StrToInt(Ahi.reg_query(reg_key+'\LAYOUT','row'));
  except
    row:=3;
  end;
  if (row*col=0)or(row*col>100) then begin row:=3;col:=3 end;

  Height:=125+40*row;
  Width:=25+175*col;

  //Position:=poScreenCenter;
  Edit1.Width:=Width-50;
  Edit1.Left:=25;

  Label1.Left:=(Width-136) div 2;

  for i:=0 to row*col-1 do begin
    Self.Buttons[i]:=TVersionButton.Create(Self,i);
    Self.Buttons[i].LoadFromReg;
    with Self.Buttons[i] do begin
      Left:=25+(ID div col)*175;
      Top:=110+(ID mod col)*40;
      Width:=150;
      Height:=25;
    end;
  end;

  if paramcount<>0 then begin
    i:=0;
    filepath:='';
    repeat
      inc(i);
      filepath:=filepath+' '+paramstr(i);
    until (filepath[2]<>'"') or (filepath[length(filepath)]='"');
    while filepath[1] in ['"',' '] do delete(filepath,1,1);
    if filepath[length(filepath)]='"' then delete(filepath,length(filepath),1);
    //filepath:=Utf8toansi(filepath);
  end
  else filepath:='::<_break>';
  Edit1.text:=ansitoutf8(filepath);
  Ahi.reg_add(reg_key+'\RUN','zz_last_rec',filepath);
end;

procedure TForm1.MenuItem_AboutClick(Sender: TObject);
begin
  Form_Ad.Show;
end;

procedure TForm1.MenuItem_LayoutClick(Sender: TObject);
begin
  Form_Layout.TrackBar_Col.Position:=col;
  Form_Layout.TrackBar_Row.Position:=row;
  Form_Layout.Show;
end;

procedure TForm1.MenuItem_ManualClick(Sender: TObject);
begin
  messagebox(0,pchar(utf8towincp('将该应用程序设置为打开方式后，打开文件就会弹出选择界面。'
  +#13+#10+#13+#10+'右键单击按键：打开详细的设置窗口设置每一个按键的打开参数；'
  +#13+#10+'左键单击按键：根据按键的设置选择具体的文件打开方式。')),pchar(utf8towincp('操作指南')),MB_OK)
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  filepath:=Utf8towincp(Edit1.Text);
end;




end.

