unit GRPMAIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, Grids, DBGrids, SysUtils, DBCtrls, Mask, DB;

type
  TfGrpApp = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    grParent: TDBGrid;
    grChild: TDBGrid;
    grUsr: TDBGrid;
    bbParent: TBitBtn;
    bbChild: TBitBtn;
    imPhoto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lGrcount: TLabel;
    edGrp: TDBEdit;
    lUsrcount: TLabel;
    edUsrName: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edPhone: TDBEdit;
    edAdr: TDBEdit;
    edNote: TDBEdit;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnNew: TBitBtn;
    btnDel: TBitBtn;
    Label8: TLabel;
    Label9: TLabel;
    btnMove: TBitBtn;
    btnFind: TBitBtn;
    cbDisabled: TDBCheckBox;
    btnLoadPhoto: TBitBtn;
    btnSavePhoto: TBitBtn;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure bbParentClick(Sender: TObject);
    procedure bbChildClick(Sender: TObject);
    procedure grParentEnter(Sender: TObject);
    procedure grChildEnter(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure grUsrEnter(Sender: TObject);
    procedure grParentDblClick(Sender: TObject);
    procedure grChildDblClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edGrpChange(Sender: TObject);
    procedure edUsrNameChange(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure grUsrDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grParentDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grChildDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnLoadPhotoClick(Sender: TObject);
    procedure btnSavePhotoClick(Sender: TObject);
    procedure cbDisabledClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure enbl_dsbl(ed: integer);
  end;


var
  fGrpApp: TfGrpApp;

implementation

uses about, DMUnit, FindUnit, ConnectUnit;

{$R *.dfm}

procedure TfGrpApp.enbl_dsbl(ed: integer);
begin
  if ed = 0 then begin
    btnMove.Enabled := true;
    btnNew.Enabled := true;
    btnDel.Enabled := true;
    btnFind.Enabled := true;
    btnSave.Enabled := false;
    btnCancel.Enabled := false;
    edUsrName.Color := clWindow;
    edPhone.Color := clWindow;
    edAdr.Color := clWindow;
    edNote.Color := clWindow;
    edGrp.Color := clWindow;
  end else
  begin
    btnMove.Enabled := false;
    btnNew.Enabled := false;
    btnDel.Enabled := false;
    btnFind.Enabled := false;
    btnSave.Enabled := true;
    btnCancel.Enabled := true;
    if (Type_ins = INS_USER)  then begin
       edUsrName.Color := clInfoBk;
       edPhone.Color := clInfoBk;
       edAdr.Color := clInfoBk;
       edNote.Color := clInfoBk;
    end;
    if (Type_ins = INS_PARENT) or (Type_ins = INS_CHILD) then
        edGrp.Color := clInfoBk;

  end;
end;

procedure TfGrpApp.FileNew1Execute(Sender: TObject);
begin
  { Do nothing }
end;

procedure TfGrpApp.FileOpen1Execute(Sender: TObject);
begin
  OpenDialog.Execute;
end;

procedure TfGrpApp.FileSave1Execute(Sender: TObject);
begin
  SaveDialog.Execute;
end;

procedure TfGrpApp.FormShow(Sender: TObject);
var sl :TStringList;
begin
  grParent.Color := clInfoBk;
  enbl_dsbl(0);
  with  fConnect do begin
    sl := TStringList.Create();
    try
    Load_From_Ini(sl);
     if (sl.Count=0) or not DM.Connect_DM(Write_Conn_Str(sl)) then
       if (fConnect.ShowModal = mrOK) then  begin
        if not DM.Connect_DM(Write_Conn_Str(fConnect.vle1.Strings)) then  begin
           MessageDLG('Невозможно установить соединение с базой данных!', mtError, [mbCancel], 0);
           fGrpApp.Close;
        end;
       end
       else fGrpApp.Close;
    finally
      sl.Free
    end;
  end;

end;

procedure TfGrpApp.bbChildClick(Sender: TObject);
begin
DM.Up_Gr();
end;

procedure TfGrpApp.bbParentClick(Sender: TObject);
begin
DM.Down_Gr();
end;

procedure TfGrpApp.btnCancelClick(Sender: TObject);
begin
  with DM do begin
    if tUsrLdet.State in [dsEdit,dsInsert ] then begin
      tUsrLdet.Cancel;
      edUsrName.Color := clWindow;
    end;
    if tGrLdet.State in [dsEdit, dsInsert] then begin
      tGrLdet.Cancel;
      edGrp.Color := clWindow;
    end;
  end;
  if (Type_ins = MOVE_PARENT) or (Type_ins = MOVE_CHILD)
        or (Type_ins = MOVE_USER) then begin
         Type_ins := BROWSE;
         grParent.Refresh;
         grChild.Refresh;
         grUsr.Refresh;
        end;
    enbl_dsbl(0);
end;

procedure TfGrpApp.btnDelClick(Sender: TObject);
var is_empty : integer;
begin
   with DM do begin
   if grUsr.Color = clInfoBk then Type_ins := DEL_USER;
   if grParent.Color = clInfoBk then Type_ins := DEL_PARENT;
   if grChild.Color = clInfoBk then Type_ins := DEL_CHILD;
   Usr_GR_Del(is_empty);
   if is_empty > 0 then  MessageDLG('Невозможно удалить, группа не пуста!', mtError, [mbCancel], 0);
   end;
end;

procedure TfGrpApp.btnFindClick(Sender: TObject);
begin
  if (fFind.ShowModal = mrOK) then  DM.Find_Locate();
end;

procedure TfGrpApp.btnLoadPhotoClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    if not DM.Load_Photo(OpenDialog.FileName) then
      MessageDLG('Ошибка загрузки файла фотографии', mtError, [mbCancel], 0);
  end;
end;

procedure TfGrpApp.btnMoveClick(Sender: TObject);
begin

   with DM do begin
     if grUsr.Color = clInfoBk then Type_ins := MOVE_USER;
     if grParent.Color = clInfoBk then Type_ins := MOVE_PARENT;
     if grChild.Color = clInfoBk then Type_ins := MOVE_CHILD;
     Want_Move();
   end;
   grParent.Refresh;
   grChild.Refresh;
   grUsr.Refresh;
   enbl_dsbl(1);
end;

procedure TfGrpApp.btnNewClick(Sender: TObject);
begin
  with DM do begin
   if grUsr.Color = clInfoBk then begin
      tUsrLdet.Insert;
      Type_ins := INS_USER;
      edUsrName.SetFocus;
   end;
   if grParent.Color = clInfoBk then begin
     tGrLdet.Insert;
     Type_ins := INS_PARENT;
     edGrp.SetFocus;
   end;
   if grChild.Color = clInfoBk then begin
     tGrLdet.Insert;
     Type_ins := INS_CHILD;
     edGrp.SetFocus;
   end;
  end;
  enbl_dsbl(1);
end;

procedure TfGrpApp.btnSaveClick(Sender: TObject);
begin
  enbl_dsbl(0);
  with DM do begin
    if tUsrLdet.State in [dsEdit, dsInsert] then begin
       if (edUsrName.Text = '')  then  begin
         MessageDLG('Имя пользователя не может быть пустым!', mtError, [mbCancel], 0);
         enbl_dsbl(1);
          edUsrName.SetFocus;
       end
      else begin
        tUsrLdet.Post;
      end;
    end;
    if tGrLdet.State in [dsEdit, dsInsert] then begin
      if (edGrp.Text = '') then  begin
         MessageDLG('Название группы не может быть пустым!', mtError, [mbCancel], 0);
         enbl_dsbl(1);
         edGrp.SetFocus;
      end
      else begin
         tGrLdet.Post;
      end;
    end;
    if (Type_ins = MOVE_PARENT) or (Type_ins = MOVE_CHILD)
        or (Type_ins = MOVE_USER) then
    begin
       if grParent.Color = clInfoBk then  Move_id.where_move := MOVE_PARENT;
       if grChild.Color = clInfoBk then  Move_id.where_move := MOVE_CHILD;
       if grUsr.Color = clInfoBk then  Move_id.where_move := MOVE_USER;
       Move_Here();
       Type_ins := BROWSE;
         grParent.Refresh;
         grChild.Refresh;
         grUsr.Refresh;
    end;
  end;
end;

procedure TfGrpApp.btnSavePhotoClick(Sender: TObject);
begin
   if not DM.tUsrLdet.FieldByName('Photo').IsNull then  begin
      SaveDialog.FileName := DM.tUsrLdet.FieldByName('DisplayName').AsString;
      if SaveDialog.Execute then  DM.Save_Photo(SaveDialog.FileName);
   end;
end;

procedure TfGrpApp.cbDisabledClick(Sender: TObject);
begin
  if DM.tUsrLdet.State in [dsEdit] then enbl_dsbl(1);
end;

procedure TfGrpApp.edGrpChange(Sender: TObject);
begin
   if DM.tGrLdet.State in [dsEdit] then enbl_dsbl(1);
end;

procedure TfGrpApp.edUsrNameChange(Sender: TObject);
begin
  if DM.tUsrLdet.State in [dsEdit] then enbl_dsbl(1);
   if  DM.tUsrTr.FieldByName('AccountEnabled').AsInteger = -1 then begin
       edUsrName.Color := cl3DLight;
       edPhone.Color := cl3DLight;
       edAdr.Color := cl3DLight;
       edNote.Color := cl3DLight;
   end else begin
      edUsrName.Color := clWindow;
      edPhone.Color := clWindow;
       edAdr.Color := clWindow;
       edNote.Color := clWindow;
   end;
end;

procedure TfGrpApp.grChildDblClick(Sender: TObject);
begin
  bbParentClick(self);
end;

procedure TfGrpApp.grChildDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if  gdSelected  in State then begin
		TDBGrid(Sender).Canvas.Brush.Color:= clHighLight;
		TDBGrid(Sender).Canvas.Font.Color := clHighLightText;
	end;
  if (Type_ins = MOVE_CHILD)
  and (Move_id.id_child = TDBGrid(Sender).DataSource.DataSet.FieldByName('GroupID').AsInteger) then
  begin
      TDBGrid(Sender).Canvas.Brush.Color:= clMenu;
			TDBGrid(Sender).Canvas.Font.Color:=clWhite;
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TfGrpApp.grChildEnter(Sender: TObject);
begin
  grChild.Color := clInfoBk;
  grParent.Color := clWindow;
  grUsr.Color := clWindow;
end;

procedure TfGrpApp.grParentDblClick(Sender: TObject);
begin
  bbChildClick(self);
end;

procedure TfGrpApp.grParentDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if  gdSelected  in State then begin
		TDBGrid(Sender).Canvas.Brush.Color:= clHighLight;
		TDBGrid(Sender).Canvas.Font.Color := clHighLightText;
	end;
  if (Type_ins = MOVE_PARENT)
  and (Move_id.id_parent = TDBGrid(Sender).DataSource.DataSet.FieldByName('GroupID').AsInteger) then
  begin
      TDBGrid(Sender).Canvas.Brush.Color:= clMenu;
			TDBGrid(Sender).Canvas.Font.Color:=clWhite;
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TfGrpApp.grParentEnter(Sender: TObject);
begin
  grParent.Color := clInfoBk;
  grChild.Color := clWindow;
  grUsr.Color := clWindow;
end;

procedure TfGrpApp.grUsrDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if  TDBGrid(Sender).DataSource.DataSet.FieldByName('AccountEnabled').AsInteger = -1 then
       TDBGrid(Sender).Canvas.Brush.Color:= cl3DLight;
  if  gdSelected  in State then begin
		TDBGrid(Sender).Canvas.Brush.Color:= clHighLight;
		TDBGrid(Sender).Canvas.Font.Color := clHighLightText;
	end;
  if (Type_ins = MOVE_USER)
  and (Move_id.id_user = TDBGrid(Sender).DataSource.DataSet.FieldByName('UserID').AsInteger) then
  begin
      TDBGrid(Sender).Canvas.Brush.Color:= clMenu;
			TDBGrid(Sender).Canvas.Font.Color:=clWhite;
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TfGrpApp.grUsrEnter(Sender: TObject);
begin
  grUsr.Color := clInfoBk;
  grParent.Color := clWindow;
  grChild.Color := clWindow;
end;

procedure TfGrpApp.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TfGrpApp.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
