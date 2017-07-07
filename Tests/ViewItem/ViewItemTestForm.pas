unit ViewItemTestForm;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmViewItem = class(TForm, IManifestManager)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetViewInfo(AViewId: string): TViewInfo;
  end;

var
  frmViewItem: TfrmViewItem;

implementation

{$R *.fmx}

{ TfrmViewItem }

function TfrmViewItem.GetViewInfo(AViewId: string): TViewInfo;
var
  ViewInfo: TViewInfo;
begin
  ViewInfo.Id := 'V0001';

  SetLength(ViewInfo.ViewPages, 2);

  ViewInfo.ViewPages[0].Id := 'P0001';
  SetLength(ViewInfo.ViewPages[0].ViewItems, 2);

  ViewInfo.ViewPages[0].ViewItems[0].Id := 'I0001';
  ViewInfo.ViewPages[0].ViewItems[0].ItemId := '1001';
  ViewInfo.ViewPages[0].ViewItems[0].Align := TAlignLayout.Top;

  ViewInfo.ViewPages[0].ViewItems[1].Id := 'I0002';
  ViewInfo.ViewPages[0].ViewItems[1].ItemId := '1002';
  ViewInfo.ViewPages[0].ViewItems[1].Align := TAlignLayout.Client;

  SetLength(ViewInfo.ViewPages[0].Bindings.ValueBindings, 1);
  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].Value := 'Runtime Test';
  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].ViewItemId := 'I0001';
  ViewInfo.ViewPages[0].Bindings.ValueBindings[0].ControlName := 'TitleLabel';




  ViewInfo.ViewPages[1].Id := 'P0002';
  SetLength(ViewInfo.ViewPages[1].ViewItems, 2);

  ViewInfo.ViewPages[1].ViewItems[0].Id := 'I0003';
  ViewInfo.ViewPages[1].ViewItems[0].ItemId := '1001';
  ViewInfo.ViewPages[1].ViewItems[0].Align := TAlignLayout.Top;

  ViewInfo.ViewPages[1].ViewItems[1].Id := 'I0004';
  ViewInfo.ViewPages[1].ViewItems[1].ItemId := '1003';
  ViewInfo.ViewPages[1].ViewItems[1].Align := TAlignLayout.Client;

  SetLength(ViewInfo.ViewPages[1].ViewItems[1].ViewItems, 2);
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[0].Id := 'I0005';
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[0].ItemId := 'LBIRIMG';
//  ViewInfo.Pages[1].ViewItems[1].ViewItems[0].Align := TAlignLayout.Client;

  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[1].Id := 'I0006';
  ViewInfo.ViewPages[1].ViewItems[1].ViewItems[1].ItemId := 'LBIRText';
//  ViewInfo.Pages[1].ViewItems[1].ViewItems[1].Align := TAlignLayout.Client;


  SetLength(ViewInfo.ViewPages[1].Bindings.FieldBindings, 1);
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].DataName := 'Employee';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].FieldName := 'name';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].ViewItemId := 'I0003';
  ViewInfo.ViewPages[1].Bindings.FieldBindings[0].ControlName := 'TitleLabel';


  Result := ViewInfo;
end;

end.
