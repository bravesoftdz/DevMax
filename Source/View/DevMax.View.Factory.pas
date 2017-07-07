unit DevMax.View.Factory;

interface

uses
  System.Generics.Collections, FMX.Controls,
  DevMax.View.Types;

type
  TViewItemClassInfo = record
    Id: string;
    ViewItemClass: TViewItemClass;

    constructor Create(AId: string; AItemClass: TViewItemClass);
  end;

  TViewItemFactory = class
  private
    class var FInstance: TViewItemFactory;
  private
    FViewItems: TDictionary<string, TViewItemClassInfo>;
    function GetList: TArray<TViewItemClassInfo>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Regist(AId: string; AItemClass: TViewItemClass);
    function GetClass(AId: string): TViewItemClass;
    function CreateControl(AId: string): TControl;

    property List: TArray<TViewItemClassInfo> read GetList;

    class function Instance: TViewItemFactory;
    class procedure ReleaseInstance;
  end;


implementation

{ TViewItemClassInfo }

constructor TViewItemClassInfo.Create(AId: string; AItemClass: TViewItemClass);
begin
  Id := AId;
  ViewItemClass := AItemClass;
end;

{ TViewItemFactory }

class function TViewItemFactory.Instance: TViewItemFactory;
begin
  if not Assigned(FInstance) then
    FInstance := Create;
  Result := FInstance;
end;

class procedure TViewItemFactory.ReleaseInstance;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

constructor TViewItemFactory.Create;
begin
  FViewItems := TDictionary<string, TViewItemClassInfo>.Create;
end;

function TViewItemFactory.CreateControl(AId: string): TControl;
var
  ItemClass: TViewItemClass;
begin
  ItemClass := GetClass(AId);
  if not Assigned(ItemClass) then
    Exit(nil);
  Result := ItemClass.Create(nil);
end;

destructor TViewItemFactory.Destroy;
begin
  FViewItems.Free;

  inherited;
end;

function TViewItemFactory.GetClass(AId: string): TViewItemClass;
var
  Info: TViewItemClassInfo;
begin
  Result := nil;
  if FViewItems.TryGetValue(AId, Info) then
    Result := Info.ViewItemClass;
end;

function TViewItemFactory.GetList: TArray<TViewItemClassInfo>;
begin
  Result := FViewItems.Values.ToArray;
end;

procedure TViewItemFactory.Regist(AId: string; AItemClass: TViewItemClass);
begin
  FViewItems.Add(AId, TViewItemClassInfo.Create(AId, AItemClass));
end;


initialization
finalization
  TViewItemFactory.ReleaseInstance;

end.
