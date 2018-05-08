unit ConnectUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Inifiles, Grids, ValEdit, ComCtrls;

type
  TfConnect = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    pc1: TPageControl;
    tsConn: TTabSheet;
    tsAll: TTabSheet;
    vle1: TValueListEditor;
    edServer: TEdit;
    edDatabase: TEdit;
    edUser: TEdit;
    edPassw: TEdit;
    btTry: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btTryClick(Sender: TObject);
    procedure edServerChange(Sender: TObject);
    procedure edDatabaseChange(Sender: TObject);
    procedure edUserChange(Sender: TObject);
    procedure edPasswChange(Sender: TObject);
    procedure pc1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure  Load_From_Ini(param_strgs: TStrings);
    procedure Save_To_Ini(param_strgs: TStrings);
    procedure Read_Conn_Str(conn_str: string; param_strgs: TStrings);
    function  Write_Conn_Str(param_strgs: TStrings): string;
    procedure Fill_ed();
  end;

var
  fConnect: TfConnect;

implementation

uses DMUnit;

{$R *.dfm}

procedure TfConnect.Fill_ed();
begin
  edServer.Text := vle1.Strings.Values['Data Source'];
  edDatabase.Text := vle1.Strings.Values['Initial Catalog'];
  edUser.Text := vle1.Strings.Values['User ID'];
  edPassw.Text := vle1.Strings.Values['Password'];
end;

function  TfConnect.Write_Conn_Str(param_strgs: TStrings): string;
begin
  Result:= StringReplace(param_strgs.Text, #13#10,';',[rfReplaceAll, rfIgnoreCase]);
end;

procedure TfConnect.Read_Conn_Str(conn_str: string; param_strgs: TStrings);
begin
  param_strgs.Text:=StringReplace(conn_str, ';',#13#10,[rfReplaceAll, rfIgnoreCase]);
end;

procedure TfConnect.Save_To_Ini(param_strgs: TStrings);
var fIni: TIniFile;
    i: integer;
begin
  fIni:=TIniFile.Create(ExtractFilePath(ParamStr(0))+ ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini'));
  for i := 0 to param_strgs.Count - 1 do begin
     fIni.WriteString('DATABASE',param_strgs.Names[i],param_strgs.ValueFromIndex [i]);
  end;
  fIni.Free;
end;

procedure TfConnect.Load_From_Ini(param_strgs: TStrings);
var fIni: TIniFile;
begin
  fIni:=TIniFile.Create(ExtractFilePath(ParamStr(0))+ ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini'));
  fIni.ReadSectionValues('DATABASE',param_strgs);
  fIni.Free;
end;

procedure TfConnect.pc1Change(Sender: TObject);
begin
  Fill_ed();
end;

procedure TfConnect.btnOkClick(Sender: TObject);
begin
  Save_To_Ini(vle1.Strings);
end;

procedure TfConnect.btTryClick(Sender: TObject);
begin
  if DM.Connect_DM(Write_Conn_Str(vle1.Strings)) then
    MessageDLG('Cоединение с базой данных установлено!', mtInformation, [mbOk], 0)
  else
   MessageDLG('Ќевозможно установить соединение с базой данных!', mtError, [mbCancel], 0);
end;

procedure TfConnect.edDatabaseChange(Sender: TObject);
begin
  vle1.Strings.Values['Initial Catalog'] := edDatabase.Text;
end;

procedure TfConnect.edPasswChange(Sender: TObject);
begin
  vle1.Strings.Values['Password'] := edPassw.Text;
end;

procedure TfConnect.edServerChange(Sender: TObject);
begin
  vle1.Strings.Values['Data Source'] := edServer.Text;
end;

procedure TfConnect.edUserChange(Sender: TObject);
begin
  vle1.Strings.Values['User ID'] := edUser.Text;
end;

procedure TfConnect.FormShow(Sender: TObject);
begin
  Load_From_Ini(vle1.Strings);
  if (vle1.Strings.Count = 0) then Read_Conn_Str(DM.connectGroups.ConnectionString, vle1.Strings);
  Fill_ed();
end;

end.
