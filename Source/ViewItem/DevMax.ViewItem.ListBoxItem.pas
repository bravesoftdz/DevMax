unit DevMax.ViewItem.ListBoxItem;

interface

uses
  DevMax.View.Types, DevMax.View.Factory,
  System.Classes,
  FMX.Types, FMX.ListBox, FMX.StdCtrls;

type
  TListBoxItemTitleImage = class(TListBoxItem, IViewItem)
  private
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TListBoxItemRightText = class(TListBoxItem, IViewItem)
  private
    FLabel: TLabel;

    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TListBoxItemTitleImage }

constructor TListBoxItemTitleImage.Create(AOwner: TComponent);
begin
  inherited;

  Text := 'Text';
end;

function TListBoxItemTitleImage.GetDataControls: TViewItemDataControls;
begin
  Result := [
    TViewItemDataControl.Create('ItemText', Self, 'Text')
  ];
end;

function TListBoxItemTitleImage.GetControlEvents: TViewItemControlEvents;
begin

end;

{ TListBoxItemRightText }

constructor TListBoxItemRightText.Create(AOwner: TComponent);
begin
  inherited;

  Text := 'Text';

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Align := TAlignLayout.Client;
  FLabel.Margins.Left := 100;
  FLabel.Margins.Right := 4;
  FLabel.Text := 'Label';
  FLabel.TextSettings.HorzAlign := TTextAlign.Trailing;
end;

function TListBoxItemRightText.GetDataControls: TViewItemDataControls;
begin
  Result := [
    TViewItemDataControl.Create('ItemText',     Self,     'Text'),
    TViewItemDataControl.Create('ItemDetail',   FLabel,   'Text')
  ];
end;

function TListBoxItemRightText.GetControlEvents: TViewItemControlEvents;
begin

end;

initialization
  TViewItemFactory.Instance.Regist('ListBoxItemRightText.Image', TListBoxItemTitleImage);
  TViewItemFactory.Instance.Regist('ListBoxItemRightText.RightText', TListBoxItemRightText);

end.
