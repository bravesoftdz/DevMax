unit DevMax.View;

interface

uses
  System.Generics.Collections,
  FMX.Controls,
  DevMax.Types.ViewInfo, DevMax.View.Types, DevMax.View.Control;

type
  TViewPage = class;

  /// View는 여러 페이지(TViewPage)를 갖는다
  TView = class
  private
    FViewId: string;
    FViewInfo: TViewInfo;

    FActivePage: TViewPage;
    FViewPages: TDictionary<string, TViewPage>;
    FVisible: Boolean;

    FPageControl: TViewPageControl;

    function CreatePage(APageId: string): TViewPage;
    function GetOrCreatePage(APageId: string): TViewPage;

    procedure SetVisible(const Value: Boolean);
    procedure SetActivePage(const Value: TViewPage);
  public
    constructor Create(AViewId: string; AContainer: TControl;
  AViewInfo: TViewInfo);
    destructor Destroy; override;

    procedure ChangePage(APageId: string; const ATransition: TPageChangeTransition = None;
      const ADirection: TPageChangeTransitionDirection = Normal); overload;
    procedure ChangePage(APage: TViewPage; const ATransition: TPageChangeTransition = None;
      const ADirection: TPageChangeTransitionDirection = Normal); overload;

    procedure Show;
    procedure Hide;

    property ActivePage: TViewPage read FActivePage write SetActivePage;
    property Visible: Boolean read FVisible write SetVisible;

    property Id: string read FViewId;
    property Control: TViewPageControl read FPageControl;
  end;

  TViewPage = class
  private
    FPageId: string;
    FView: TView;
    FViewItems: TDictionary<string, IViewItem>;

    procedure CreateViewItems(AParent: TControl; AViewItems: TArray<TViewItemInfo>);
  public
    constructor Create(APageId: string; AView: TView;
  APageInfo: TViewPageInfo);
    destructor Destroy; override;

    property Id: string read FPageId;
  end;

implementation

uses
  System.SysUtils,
  DevMax.View.Factory;

{ TView }

constructor TView.Create(AViewId: string; AContainer: TControl;
  AViewInfo: TViewInfo);
begin
  FViewId := AViewId;

  FViewInfo := AViewInfo;
  FViewPages := TDictionary<string, TViewPage>.Create;

  FPageControl := TViewPageControl.Create(nil);
end;

destructor TView.Destroy;
var
  ViewPage: TViewPage;
begin
  for ViewPage in FViewPages.Values do
    ViewPage.Free;
  FViewPages.Free;
  FPageControl.Free;
end;

function TView.CreatePage(APageId: string): TViewPage;
var
  PageInfo: TViewPageInfo;
begin
  if not FViewInfo.TryGetPageInfo(APageId, PageInfo) then
    Exit(nil);
  Result := TViewPage.Create(APageId, Self, PageInfo);
  FViewPages.Add(APageId, Result);
end;

function TView.GetOrCreatePage(APageId: string): TViewPage;
begin
  if not FViewPages.TryGetValue(APageId, Result) then
    Result := CreatePage(APageId);
end;

procedure TView.ChangePage(APageId: string;
  const ATransition: TPageChangeTransition;
  const ADirection: TPageChangeTransitionDirection);
var
  Page: TViewPage;
begin
  Page := GetOrCreatePage(APageId);
  ChangePage(Page, ATransition, ADirection);
end;

procedure TView.ChangePage(APage: TViewPage;
  const ATransition: TPageChangeTransition;
  const ADirection: TPageChangeTransitionDirection);
begin
  if FActivePage = APage then
    Exit;

  // Control 처리

  FActivePage := APage;
end;

procedure TView.Show;
var
  ViewPage: TViewPage;
begin
  if not Assigned(FActivePage) then
  begin
    ViewPage := GetOrCreatePage(FViewInfo.MAIN_PAGE_ID);

    ActivePage := ViewPage;
  end;
end;

procedure TView.Hide;
begin

end;

procedure TView.SetActivePage(const Value: TViewPage);
begin
  ChangePage(Value);
end;

procedure TView.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then
    Exit;

  FVisible := Value;

  if FVisible then
    Show
  else
    Hide;
end;

{ TViewPage }

constructor TViewPage.Create(APageId: string; AView: TView;
  APageInfo: TViewPageInfo);
begin
  FPageId := APageId;
  FView := AView;

  FViewItems := TDictionary<string, IViewItem>.Create;

  CreateViewItems(AView.Control, APageInfo.ViewItems);
end;

destructor TViewPage.Destroy;
begin
  FViewItems.Free;

  inherited;
end;

procedure TViewPage.CreateViewItems(AParent: TControl; AViewItems: TArray<TViewItemInfo>);
var
  ItemInfo: TViewItemInfo;
  ItemInstance, ContainControl: TControl;
  ViewItem: IViewItem;
begin
  for ItemInfo in AViewItems do
  begin
    ItemInstance := TViewItemFactory.Instance.CreateControl(ItemInfo.ITEM_ID);
    if not Assigned(ItemInstance) then
      Continue;

    ItemInstance.Parent := AParent;
    ItemInstance.Align := ItemInfo.ALIGN;

    if Supports(ItemInstance, IViewItem, ViewItem) then
      FViewItems.Add(ItemInfo.ITEM_ID, ViewItem);

    if Length(ItemInfo.ViewItems) > 0 then
    begin
      if Supports(ItemInstance, IViewItemContainer) then
      begin
        ContainControl := (ItemInstance as IViewItemContainer).GetContainerObject;
        CreateViewItems(ContainControl, ItemInfo.ViewItems);
      end;
    end;
  end;
end;

end.
