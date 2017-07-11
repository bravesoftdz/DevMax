unit DevMax.ViewItem.ListViewTextRightDetail;

interface

uses
  DevMax.View.Types,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TListViewTextRightDetail = class(TFrame, IViewItem)
    ListView1: TListView;
  private
    { Private declarations }
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;
  public
    { Public declarations }
  end;

implementation

uses
  DevMax.View.Factory;

{$R *.fmx}

{ TListViewTextRightDetail }

function TListViewTextRightDetail.GetDataControls: TViewItemDataControls;
begin
//  Result := [
//    TViewItemDataField.Init('ButtonCaption', Button1, 'Text'),
//    TViewItemDataField.Init('TitleLabel', Label1, 'Text')
//  ];
//  ARegister.RegistViewItemEvent(AId, TViewItemEvent.GetInstance('ListViewItemClick', ListView1, 'OnItemClick'));
//  ARegister.RegistViewItemEvent(AId, TViewItemEvent.GetInstance('ListViewTap', ListView1, 'OnTap'));
//
//  ARegister.RegistViewItemDataField(AId, TViewItemListControl.Create('List', ListView1, ['Detail']));
end;

function TListViewTextRightDetail.GetControlEvents: TViewItemControlEvents;
begin

end;

initialization
  TViewItemFactory.Instance.Regist('1002', TListViewTextRightDetail);

end.
