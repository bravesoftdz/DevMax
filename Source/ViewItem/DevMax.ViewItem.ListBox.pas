unit DevMax.ViewItem.ListBox;

interface

uses
  DevMax.View.Types,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox;

type
  TfrListBox = class(TFrame, IViewItem, IViewItemContainer)
    ListBox1: TListBox;
  private
    { Private declarations }
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;

    function GetContainerObject: TControl;
  public
    { Public declarations }
  end;

implementation

uses
  DevMax.View.Factory;

{$R *.fmx}

{ TFrame2 }

function TfrListBox.GetContainerObject: TControl;
begin
  Result := ListBox1;
end;

function TfrListBox.GetDataControls: TViewItemDataControls;
begin

end;

function TfrListBox.GetControlEvents: TViewItemControlEvents;
begin

end;

initialization
  TViewItemFactory.Instance.Regist('ListBox', TfrListBox);

end.
