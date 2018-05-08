unit DMUnit;

interface

uses
  SysUtils, Classes, DB, ADODB, Jpeg;

type

  TDM = class(TDataModule)
    connectGroups: TADOConnection;
    tGrL: TADOTable;
    dsGrL: TDataSource;
    dsGrChild: TDataSource;
    dsUsrL: TDataSource;
    tGrChild: TADOTable;
    tUsrL: TADOTable;
    tUsrTr: TADOTable;
    dsUsrTr: TDataSource;
    tGrParent: TADOTable;
    tGrChildParentID: TIntegerField;
    tGrChildGroupID: TIntegerField;
    tGrChildname: TStringField;
    dsGrParent: TDataSource;
    tGrParentParentID: TIntegerField;
    tGrParentGroupID: TIntegerField;
    tGrParentname: TStringField;
    tUsrTrGroupID: TIntegerField;
    tUsrTrUserID: TIntegerField;
    tUsrTrname: TStringField;
    tUsrLUserID: TAutoIncField;
    tUsrLDisplayName: TWideStringField;
    tUsrLAccountEnabled: TBooleanField;
    tUsrLPhoto: TBlobField;
    tUsrLPhone: TWideStringField;
    tUsrLAddress: TWideStringField;
    tUsrLNote: TWideStringField;
    tUsrLdet: TADOTable;
    AutoIncField1: TAutoIncField;
    WideStringField1: TWideStringField;
    BooleanField1: TBooleanField;
    BlobField1: TBlobField;
    WideStringField2: TWideStringField;
    WideStringField3: TWideStringField;
    WideStringField4: TWideStringField;
    dsUsrLdet: TDataSource;
    tGrLdet: TADOTable;
    dsGrLdet: TDataSource;
    tGrLdetGroupID: TAutoIncField;
    tGrLdetDisplayName: TWideStringField;
    qInsertUsrTr: TADOQuery;
    qInsertGrTr: TADOQuery;
    qDelUsr: TADOQuery;
    qDelGr: TADOQuery;
    qIs_Empty_Gr: TADOQuery;
    qIs_Empty_Gris_empty: TIntegerField;
    qMoveUsr: TADOQuery;
    qMoveGr: TADOQuery;
    qFindUsr: TADOQuery;
    dsFindUsr: TDataSource;
    qFindGr: TADOQuery;
    dsFindGr: TDataSource;
    tUsrTrAccountEnabled: TIntegerField;
    procedure tUsrLdetAfterScroll(DataSet: TDataSet);
    procedure tGrParentAfterScroll(DataSet: TDataSet);
    procedure tUsrLdetAfterPost(DataSet: TDataSet);
    procedure tGrLdetAfterPost(DataSet: TDataSet);
    procedure tUsrLdetBeforeInsert(DataSet: TDataSet);
    procedure tGrLdetBeforeInsert(DataSet: TDataSet);
    procedure tUsrLdetAfterCancel(DataSet: TDataSet);
    procedure tGrLdetAfterCancel(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure  Usr_Refresh(id_user :integer);
    procedure  Gr_Refresh(id_user, id_parent, id_child :integer);
  public
    { Public declarations }
    procedure  Usr_GR_Del(var is_empty :integer);
    procedure  Up_Gr();
    procedure  Down_Gr();
    procedure  Want_Move();
    procedure  Move_Here();
    procedure  Find_Usr_Grp(findstr: string; usr_grp: integer);
    procedure  Find_Locate();
    function   Load_Photo(image_file: string) :boolean;
    procedure  Save_Photo(image_file: string);
    function  Connect_DM(conn_str: string):boolean;
  end;

  TType_of_Insert = (INS_PARENT, INS_CHILD, INS_USER,
                     DEL_PARENT, DEL_CHILD, DEL_USER,
                     MOVE_PARENT, MOVE_CHILD, MOVE_USER, BROWSE);
  TMove_User_Group = record
    id_parent	: integer;
    id_child	: integer;
    id_user	  : integer;
    parentID  : integer;
    where_move :TType_of_Insert;
  end;

var
  DM: TDM;
  Type_ins: TType_of_Insert;
  Move_id:  TMove_User_Group;
implementation

uses grpmain;

{$R *.dfm}

function  TDM.Connect_DM(conn_str: string):boolean;
begin
  result := true;
  connectGroups.Connected := false;
  connectGroups.ConnectionString := conn_str;
  try
    connectGroups.Connected := true;
  except
  end;
  if connectGroups.Connected then  begin
    tGrL.Open;
    tUsrL.Open;
    tGrParent.Open;
    tGrLdet.Open;
    tGrChild.Open;
    tUsrTr.Open;
    tUsrLdet.Open;
  end else  result := false;
end;

procedure  TDM.Save_Photo(image_file: string);
var msPict: TMemoryStream;
    jp: TJPEGImage;
begin
  if Not(tUsrLdet.Bof and tUsrLdet.Eof) and not (tUsrLdet.State in [dsInsert])
   and not tUsrLdet.FieldByName('Photo').IsNull then  begin
     msPict:= TMemoryStream.Create;
     jp:= TJPEGImage.Create;
   try
      TBlobField(tUsrLdet.FieldByName('Photo')).SaveToStream(msPict);
      msPict.Position:= 0;
      jp.LoadFromStream(msPict);
      jp.SaveToFile(image_file);
   finally
      msPict.Free;
      jp.Free;
   end;
 end;
end;

function  TDM.Load_Photo(image_file: string) :boolean;
var msPict: TMemoryStream;
    jp: TJPEGImage;
    post_here: boolean;
begin
 result := true;
 post_here := not (tUsrLdet.State in [dsInsert, dsEdit]);
 if Not(tUsrLdet.Bof and tUsrLdet.Eof) then  begin
     msPict:= TMemoryStream.Create;
     jp:= TJPEGImage.Create;
   try
      jp.LoadFromFile(image_file);
      jp.SaveToStream(msPict);
      msPict.Position:= 0;
      if post_here then tUsrLdet.Edit;
      TBlobField(tUsrLdet.FieldByName('Photo')).LoadFromStream(msPict);
      if post_here and (tUsrLdet.State in [dsEdit]) then tUsrLdet.Post;
      fGrpApp.imPhoto.Picture.Assign(jp);
      fGrpApp.imPhoto.Visible :=true;
   except
      msPict.Free;
      jp.Free;
      fGrpApp.imPhoto.Visible :=false;
      result := false;
   end;
   msPict.Free;
   jp.Free;
 end;
end;


procedure  TDM.Find_Locate();
var  id_user, id_parent,  parentID : integer;
begin
   id_parent := 0;  id_user := 0; parentID :=0;
  if qFindUsr.Active then  begin
    parentID :=  qFindUsr.FieldByName('ParentID').AsInteger;
    id_parent := qFindUsr.FieldByName('GroupID').AsInteger;
    id_user := qFindUsr.FieldByName('UserID').AsInteger;
  end;
  if qFindGr.Active then  begin
    parentID :=  qFindGr.FieldByName('ParentID').AsInteger;
    id_parent := qFindGr.FieldByName('GroupID').AsInteger;
    id_user := 0;
  end;
  if id_parent>0 then  begin
    tGrParent.Filter :=  'ParentID = '+ IntToStr(parentID);
    tGrParent.Filtered := true;
    tGrParent.Locate('GroupID', id_parent, []);
    if id_user >0 then tUsrTr.Locate('UserID', id_user, []);
  end;
end;

procedure  TDM.Find_Usr_Grp(findstr: string; usr_grp: integer);
begin
  qFindUsr.Close;
  qFindGr.Close;
  findstr := trim(findstr);
  if (findstr <> '') then begin
    findstr :=  '%'+ UpperCase(findstr) + '%';
    qFindUsr.Parameters.ParamByName('findstr').Value := findstr;
    qFindGr.Parameters.ParamByName('findstr').Value := findstr;
    if usr_grp = 0 then  qFindUsr.Open
    else qFindGr.Open;
  end;
end;

procedure  TDM.Move_Here();
var id_user, id_parent, id_child,
    id_group_upd, id_parent_upd,
    parentID :integer;
begin
  id_parent := tGrParent.FieldByName('GroupID').AsInteger;
  id_child := tGrChild.FieldByName('GroupID').AsInteger;
  id_user := tUsrTr.FieldByName('UserID').AsInteger;
  parentID := tGrParent.FieldByName('ParentID').AsInteger;
  id_group_upd := 0;  id_parent_upd := 0;
  if (Type_ins = MOVE_PARENT) or (Type_ins = MOVE_CHILD) then
  begin
    case Type_ins of
      MOVE_PARENT:  id_group_upd := Move_id.id_parent;
      MOVE_CHILD :  id_group_upd := Move_id.id_child;
    end;
    case Move_id.where_move of
      MOVE_PARENT: begin
                     if (Move_id.parentID = parentID) and
                        not (Move_id.id_parent = id_parent) then begin
                          id_parent_upd := id_parent;
                          id_child := id_group_upd;
                      end else begin
                       id_parent_upd := parentID;
                       id_parent := id_group_upd;
                       id_child := 0;
                       id_user := 0;
                      end;
                     if (id_parent = id_child) then begin
                       id_child := 0;
                       id_user := 0;
                     end;
                   end;
      MOVE_CHILD, MOVE_USER : begin
                     id_parent_upd := id_parent;
                     id_child := id_group_upd;
                   end;
    end;
    if (id_parent <> id_child) and (id_parent_upd <> id_group_upd) then   begin
      qMoveGr.Parameters.ParamByName('ParentID').Value := id_parent_upd;
      qMoveGr.Parameters.ParamByName('GroupID').Value := id_group_upd;
      qMoveGr.ExecSQL;
      Gr_Refresh(id_user, id_parent, id_child);
    end;

  end;
  if (Type_ins = MOVE_USER) then
  begin
    id_group_upd := id_parent;
    if (id_group_upd <> Move_id.id_parent) then   begin
      qMoveUsr.Parameters.ParamByName('GroupID').Value := id_group_upd;
      qMoveUsr.Parameters.ParamByName('UserID').Value := Move_id.id_user;
      qMoveUsr.ExecSQL;
      Usr_Refresh(Move_id.id_user);
    end;
  end;
end;

procedure  TDM.Want_Move();
begin
  Move_id.id_parent := tGrParent.FieldByName('GroupID').AsInteger;
  Move_id.id_child := tGrChild.FieldByName('GroupID').AsInteger;
  Move_id.id_user := tUsrTr.FieldByName('UserID').AsInteger;
  Move_id.parentID := tGrParent.FieldByName('ParentID').AsInteger;
  Move_id.where_move := Type_ins;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
//  Connect_DM('Provider=SQLOLEDB.1;Password=1qaz@WSX;Persist Security Info=True;User ID=sa;Initial Catalog=Groups;Data Source=IGOR-PC\SQLEXPRESS;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=IGOR-PC;Use Encryption for Data=False;Tag with column collation when possible=False');
end;

procedure  TDM.Down_Gr();
var id_parent, id_child :integer;
begin
  if Not (tGrChild.Bof and tGrChild.Eof) then  begin
    id_parent := tGrChild.FieldByName('ParentID').AsInteger;
    id_child := tGrChild.FieldByName('GroupID').AsInteger;
    tGrParent.Filter :=  'ParentID = '+ IntToStr(id_parent);
    tGrParent.Filtered := true;
    tGrParent.Locate('GroupID', id_child, []);
  end;
end;

procedure  TDM.Up_Gr();
var id_parent, id_child :integer;
begin
   id_parent := tGrParent.FieldByName('ParentID').AsInteger;
   id_child := tGrParent.FieldByName('GroupID').AsInteger;
   if id_parent > 0 then   begin
     tGrParent.Filtered := false;
     tGrParent.Locate('GroupID', id_parent, []);
     tGrParent.Filter :=  'ParentID = '+ tGrParent.FieldByName('ParentID').AsString;
     tGrParent.Filtered := true;
     tGrParent.Locate('GroupID', id_parent, []);
     tGrChild.Locate('GroupID', id_child, []);
   end;
end;

procedure  TDM.Gr_Refresh(id_user, id_parent, id_child :integer);
begin
      tGrL.close;
      tGrL.Open;
      tGrParent.close;
      tGrParent.Open;
      tGrChild.close;
      tGrChild.Open;
      tUsrTr.close;
      tUsrTr.Open;
      if id_parent >0 then tGrParent.Locate('GroupID', id_parent, []);
      if id_child >0 then tGrChild.Locate('GroupID', id_child, []);
      if id_user >0 then tUsrTr.Locate('UserID', id_user, []);
end;

procedure  TDM.Usr_Refresh(id_user :integer);
begin
      tUsrL.close;
      tUsrL.Open;
      tUsrTr.close;
      tUsrTr.Open;
      if id_user >0 then tUsrTr.Locate('UserID', id_user, []);
end;

procedure TDM.Usr_GR_Del(var is_empty :integer);
var  id_user, id_group, id_parent, id_child : integer;
begin
  is_empty := 0;
  if (Type_ins = DEL_USER) and (tUsrTr.RecordCount >0) then begin
    id_user := tUsrTr.FieldByName('UserID').AsInteger;
    qDelUsr.Parameters.ParamByName('UserID1').Value := id_user;
    qDelUsr.Parameters.ParamByName('UserID2').Value := id_user;
    tUsrTr.Prior;
    id_user := tUsrTr.FieldByName('UserID').AsInteger;
    qDelUsr.ExecSQL;
    Usr_Refresh(id_user);
  end;
  if ((Type_ins = DEL_PARENT) and not ((tGrParent.RecordCount = 1) and (tGrParent.FieldByName('ParentID').AsInteger = 0)))
     or ((Type_ins = DEL_CHILD) and (tGrChild.RecordCount >0)) then begin
    id_group := 0;
    case Type_ins of
      DEL_PARENT:  id_group := tGrParent.FieldByName('GroupID').AsInteger;
      DEL_CHILD :  id_group := tGrChild.FieldByName('GroupID').AsInteger;
    end;
    qIs_Empty_Gr.Parameters.ParamByName('GroupID1').Value := id_group;
    qIs_Empty_Gr.Parameters.ParamByName('GroupID2').Value := id_group;
    qIs_Empty_Gr.Open;
    is_empty := qIs_Empty_Gr.Fields[0].AsInteger;
    qIs_Empty_Gr.Close;
    if is_empty = 0 then  begin
       case Type_ins of
         DEL_PARENT:  if tGrParent.RecordCount >1 then tGrParent.Prior else Up_Gr();
         DEL_CHILD :  if tGrChild.RecordCount >1 then tGrChild.Prior else Up_Gr();
       end;
       id_parent := tGrParent.FieldByName('GroupID').AsInteger;
       id_child := tGrChild.FieldByName('GroupID').AsInteger;
       id_user := tUsrTr.FieldByName('UserID').AsInteger;
       qDelGr.Parameters.ParamByName('GroupID1').Value := id_group;
       qDelGr.Parameters.ParamByName('GroupID2').Value := id_group;
       qDelGr.ExecSQL;
       Gr_Refresh(id_user, id_parent, id_child);
    end;
  end;
end;

procedure TDM.tGrLdetAfterCancel(DataSet: TDataSet);
begin
  if tGrLdet.MasterSource = nil then begin
     tGrLdet.Close;
     tGrLdet.MasterSource := dsGrParent;
     tGrLdet.MasterFields :='GroupID';
     tGrLdet.Open;
  end;
end;

procedure TDM.tGrLdetAfterPost(DataSet: TDataSet);
var id_user, id_parent, id_child, id_group_ins, id_parent_ins :integer;
begin
      id_parent := tGrParent.FieldByName('GroupID').AsInteger;
      id_child := tGrChild.FieldByName('GroupID').AsInteger;
      id_user := tUsrTr.FieldByName('UserID').AsInteger;

       if tGrLdet.MasterSource = nil then begin
        id_child :=0;
        id_user  :=0;
        id_group_ins := tGrLdet.FieldByName('GroupID').AsInteger;
        if Type_ins = INS_PARENT then  begin
                 id_parent_ins :=  tGrParent.FieldByName('ParentID').AsInteger;
                 id_parent :=  id_group_ins;
        end
        else  begin
                 id_parent_ins :=  id_parent;
                 id_parent := id_parent_ins;
                 id_child := id_group_ins;
        end;
        qInsertGrTr.Parameters.ParamByName('ParentID').Value := id_parent_ins;
        qInsertGrTr.Parameters.ParamByName('GroupID').Value := id_group_ins;
        qInsertGrTr.ExecSQL;
        tGrLdet.Close;
        tGrLdet.MasterSource := dsGrParent;
        tGrLdet.MasterFields :='GroupID';
        tGrLdet.Open;
      end;
      Gr_Refresh(id_user, id_parent, id_child);
      fGrpApp.enbl_dsbl(0);
end;

procedure TDM.tGrLdetBeforeInsert(DataSet: TDataSet);
begin
  if tGrLdet.MasterSource <> nil then begin
    tGrLdet.Close;
    tGrLdet.MasterSource := nil;
    tGrLdet.MasterFields :='';
    tGrLdet.Open;
    tGrLdet.Insert;
  end;
end;

procedure TDM.tGrParentAfterScroll(DataSet: TDataSet);
begin
  with fGrpApp  do begin
    if tGrChild.Active and tUsrTr.Active then begin
      lGrcount.Caption := IntToStr(tGrChild.RecordCount);
      lUsrcount.Caption := IntToStr(tUsrTr.RecordCount);
    end;
  end;
end;

procedure TDM.tUsrLdetAfterCancel(DataSet: TDataSet);
begin
  if tUsrLdet.MasterSource = nil then begin
    tUsrLdet.Close;
    tUsrLdet.MasterSource := dsUsrTr;
    tUsrLdet.MasterFields :='UserID';
    tUsrLdet.Open;
    fGrpApp.enbl_dsbl(0);
  end;
end;

procedure TDM.tUsrLdetAfterPost(DataSet: TDataSet);
var id_user, id_group :integer;
begin
      id_user := tUsrTr.FieldByName('UserID').AsInteger;
      if tUsrLdet.MasterSource = nil then begin
        id_user := tUsrLdet.FieldByName('UserID').AsInteger;
        id_group :=  tGrParent.FieldByName('GroupID').AsInteger;
        qInsertUsrTr.Parameters.ParamByName('GroupID').Value := id_group;
        qInsertUsrTr.Parameters.ParamByName('UserID').Value := id_user;
        qInsertUsrTr.ExecSQL;
        tUsrLdet.Close;
        tUsrLdet.MasterSource := dsUsrTr;
        tUsrLdet.MasterFields :='UserID';
        tUsrLdet.Open;
      end;
     Usr_Refresh(id_user);
     fGrpApp.enbl_dsbl(0);
end;

procedure TDM.tUsrLdetAfterScroll(DataSet: TDataSet);
var msPict: TMemoryStream;
    jp: TJPEGImage;
begin
 if Not(tUsrLdet.Bof and tUsrLdet.Eof) and not (tUsrLdet.State in [dsInsert])
   and not tUsrLdet.FieldByName('Photo').IsNull then  begin
     fGrpApp.imPhoto.Visible :=true;
     msPict:= TMemoryStream.Create;
     jp:= TJPEGImage.Create;
   try
      TBlobField(tUsrLdet.FieldByName('Photo')).SaveToStream(msPict);
      msPict.Position:= 0;
      jp.LoadFromStream(msPict);
      fGrpApp.imPhoto.Picture.Assign(jp);
   finally
      msPict.Free;
      jp.Free;
   end;
 end else fGrpApp.imPhoto.Visible :=false;
end;

procedure TDM.tUsrLdetBeforeInsert(DataSet: TDataSet);
begin
  if tUsrLdet.MasterSource <> nil then begin
    tUsrLdet.Close;
    tUsrLdet.MasterSource := nil;
    tUsrLdet.MasterFields :='';
    tUsrLdet.Open;
    tUsrLdet.Insert;
  end;
end;

end.
