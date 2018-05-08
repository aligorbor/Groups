unit FindUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls;

type
  TfFind = class(TForm)
    edFindStr: TEdit;
    rgUsrGr: TRadioGroup;
    grFind: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure edFindStrChange(Sender: TObject);
    procedure rgUsrGrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFind: TfFind;

implementation

uses DMUnit;

{$R *.dfm}

procedure TfFind.edFindStrChange(Sender: TObject);
begin
  DM.Find_Usr_Grp(edFindStr.Text, rgUsrGr.ItemIndex);
end;

procedure TfFind.rgUsrGrClick(Sender: TObject);
begin
  if rgUsrGr.ItemIndex = 0 then grFind.DataSource := DM.dsFindUsr
  else  grFind.DataSource := DM.dsFindGr;
  DM.Find_Usr_Grp(edFindStr.Text, rgUsrGr.ItemIndex);
end;

end.
