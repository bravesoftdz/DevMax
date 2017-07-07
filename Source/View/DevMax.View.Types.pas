unit DevMax.View.Types;

interface

uses
  FMX.Types, FMX.Controls, System.Generics.Collections;

type
  TViewItemClass = class of TControl;

  TViewItemDataControl = record
    Name: string;
    Control: TControl;
    PropertyName: string;

    constructor Create(AName: string; AControl: TControl; APropertyName: string);
  end;

  TViewItemControlEvent = record

  end;

  TViewItemDataControls = TArray<TViewItemDataControl>;
  TViewItemControlEvents = TArray<TViewItemControlEvent>;

  TViewItemDataControlsHelper = record Helper for TViewItemDataControls
  public
    function TryGetValue(const AName: string; out Value: TViewItemDataControl): Boolean;
  end;

  IViewItem = interface
    ['{5A3BC083-7696-4011-AA2C-54A87EA8A2D4}']
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;

    property DataControls: TViewItemDataControls read GetDataControls;
  end;

  IViewItemContainer = interface
    ['{CF366043-A495-4C6C-B91B-4471E79AA4E2}']
    function GetContainerObject: TControl;
  end;

implementation

{ TViewItemDataField }

constructor TViewItemDataControl.Create(AName: string; AControl: TControl;
  APropertyName: string);
begin
  Name := AName;
  Control := AControl;
  PropertyName := APropertyName;
end;

{ TViewItemDataControlsHelper }

function TViewItemDataControlsHelper.TryGetValue(const AName: string;
  out Value: TViewItemDataControl): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to Length(Self) - 1 do
  begin
    if Self[I].Name = AName then
    begin
      Value := Self[I];
      Exit(True);
    end;
  end;
end;

end.
