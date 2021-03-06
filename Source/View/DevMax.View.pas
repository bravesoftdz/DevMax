unit DevMax.View;

interface

uses
  FMX.Controls, FMX.Types,
  System.Generics.Collections,
  DevMax.Types.ViewInfo, DevMax.View.Types, DevMax.View.Control,
  DevMax.Utils.Binder;

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

    FControl: TViewPageControlItem;

    procedure CreateViewItems(AParent: TControl; AViewItems: TArray<TViewItemInfo>);
    procedure BindViewItems(ABindInfo: TViewItemBindInfo);
  public
    constructor Create(APageId: string; AView: TView; APageInfo: TViewPageInfo);
    destructor Destroy; override;

    property Id: string read FPageId;
    property Control: TViewPageControlItem read FControl;
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
  FPageControl.Align := TAlignLayout.Client;
  FPageControl.Parent := AContainer;
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
  FPageControl.ChangePage(APage.Control);

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

procedure TViewPage.BindViewItems(ABindInfo: TViewItemBindInfo);
  function TryGetControl(AViewId, AControlName: string; out DataControl: TViewItemDataControl): Boolean;
  var
    ViewItem: IViewItem;
  begin
    Result := False;
    // Find ViewItem
    if FViewItems.TryGetValue(AViewId, ViewItem) then
      // Find DataControl
      Result := ViewItem.DataControls.TryGetValue(AControlName, DataControl);
  end;

  procedure BindValue(ABindInfos: TArray<TViewItemBindInfo.TBindValueInfo>);
  var
    Info: TViewItemBindInfo.TBindValueInfo;
    Control: TViewItemDataControl;
  begin
    for Info in ABindInfos do
    begin
      if TryGetControl(Info.ITEM_ID, Info.CTRL_NAME, Control) then
        TDataBinder.BindValue(Control.Control, Control.PropertyName, Info.STR_VALUE);
    end;
  end;
begin
  BindValue(ABindInfo.BindValues);
end;

constructor TViewPage.Create(APageId: string; AView: TView;
  APageInfo: TViewPageInfo);
begin
  FPageId := APageId;
  FView := AView;

  FViewItems := TDictionary<string, IViewItem>.Create;

  FControl := TViewPageControlItem.Create(nil);
  FControl.Parent := AView.Control;

  CreateViewItems(FControl, APageInfo.ViewItems);
  BindViewItems(APageInfo.BindInfo);
end;

destructor TViewPage.Destroy;
begin
  FViewItems.Free;
  FControl.Free;

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
    ItemInstance := TViewItemFactory.Instance.CreateControl(ItemInfo.ITEM_CLS_ID);
    if not Assigned(ItemInstance) then
      Continue;

    ItemInstance.Parent := AParent;
    ItemInstance.Align := ItemInfo.ALIGN;

    if Supports(ItemInstance, IViewItem, ViewItem) then
      FViewItems.Add(ItemInfo.ITEM_ID, ViewItem);

    // Child Item 생성
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
