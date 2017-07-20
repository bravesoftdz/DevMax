unit DevMax.Types.ViewInfo;

interface

uses
  FMX.Types, DevMax.Utils.Marshalling;

type
  TViewItemInfo = record
    ITEM_ID: string;
    ITEM_CLS_ID: string;
    ALIGN: TAlignLayout;
    HEIGHT: Single;
    ViewItems: TArray<TViewItemInfo>; // Child item
  end;

  TViewItemBinding = record
    type
      TValueBinding = record
        ITEM_ID: string;
        ControlName: string;
        Value: string;
      end;

      TFieldBinding = record
        ITEM_ID: string;
        ControlName: string;
        DataName: string;
        FieldName: string;
      end;

      TListBinidngItem = record
        ControlName: string;
        FieldName: string;
      end;

      TListBinding = record
        ITEM_ID: string;
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
    PAGE_ID: string;
    ViewItems: TArray<TViewItemInfo>;
    Bindings: TViewItemBinding;
  end;

  TViewDataInfo = record
    Id: string;
    Name: string;
  end;

  TViewInfo = record
    VIEW_ID: string;
    MAIN_PAGE_ID: string;
    ALIGN: TAlignLayout;
    [FieldNameDef('Pages')]
    ViewPages: TArray<TViewPageInfo>;
//    ViewDatas: TArray<TViewDataInfo>;

    function TryGetPageInfo(APageId: string;
  out PageInfo: TViewPageInfo): Boolean;
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
    if Info.PAGE_ID = APageId then
    begin
      PageInfo := Info;
      Exit(True);
    end;
  end;
end;

end.
