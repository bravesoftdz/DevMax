unit DevMax.Types.ViewInfo;

interface

uses
  FMX.Types;

type
  TViewItemInfo = record
    Id: string;
    ItemId: string;
    Align: TAlignLayout;
    ViewItems: TArray<TViewItemInfo>; // Child item
  end;

  TViewItemBinding = record
    type
      TValueBinding = record
        ViewItemId: string;
        ControlName: string;
        Value: string;
      end;

      TFieldBinding = record
        ViewItemId: string;
        ControlName: string;
        DataName: string;
        FieldName: string;
      end;

      TListBinidngItem = record
        ControlName: string;
        FieldName: string;
      end;

      TListBinding = record
        ViewItemId: string;
        ControlName: string;
        DataName: string;
        FieldName: string;
        ListItems: TArray<TListBinidngItem>;
      end;
    public
      ValueBindings: TArray<TValueBinding>;
      FieldBindings: TArray<TFieldBinding>;
      ListBindings: TArray<TListBinding>;
  end;

  TViewPageInfo = record
    Id: string;
    ViewItems: TArray<TViewItemInfo>;
    Bindings: TViewItemBinding;
  end;

  TViewDataInfo = record
    Id: string;
    Name: string;
  end;

  TViewInfo = record
    Id: string;
    MainPageId: string;
    ViewPages: TArray<TViewPageInfo>;
    ViewDatas: TArray<TViewDataInfo>;

    function TryGetPageInfo(APageId: string; out PageInfo: TViewPageInfo): Boolean;
  end;

implementation

{ TViewInfo }

function TViewInfo.TryGetPageInfo(APageId: string;
  out PageInfo: TViewPageInfo): Boolean;
var
  Info: TViewPageInfo;
begin
  Result := False;
  for Info in ViewPages do
  begin
    if Info.Id = APageId then
    begin
      PageInfo := Info;
      Exit(True);
    end;
  end;
end;

end.
