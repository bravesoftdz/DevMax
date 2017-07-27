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

  TViewItemBindInfo = record
  type
    TBindValueInfo = record
      ITEM_ID: string;
      CTRL_NAME: string;
      STR_VALUE: string;
    end;

    TBindFieldInfo = record
      ITEM_ID: string;
      ControlName: string;
      DataName: string;
      FieldName: string;
    end;

    TBindListItem = record
      ControlName: string;
      FieldName: string;
    end;

    TBindListInfo = record
      ITEM_ID: string;
      ControlName: string;
      DataName: string;
      FieldName: string;
      ListItems: TArray<TBindListItem>;
    end;
  public
    BindValues: TArray<TBindValueInfo>;
//    BindFields: TArray<TFieldBinding>;
//    BindLists: TArray<TListBinding>;
  end;

  TViewPageInfo = record
    PAGE_ID: string;
    ViewItems: TArray<TViewItemInfo>;
    BindInfo: TViewItemBindInfo;
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
