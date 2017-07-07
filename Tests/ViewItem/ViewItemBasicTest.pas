unit ViewItemBasicTest;

interface
uses
  DUnitX.TestFramework, ViewItemTestForm,
  DevMax.View.Factory,
  DevMax.View.Types;

type

  [TestFixture]
  TTestViewItemBasic = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [TestCase('ToolbarRightButton', 'ToolbarRightButton')]
    procedure TestCreateViewItem(AItemId: string);

    [Test]
    procedure TestContainerViewItem;
  end;

implementation

uses
  System.SysUtils,
  FMX.Controls, FMX.Types, FMX.ListBox,
  DevMax.ViewItem.ListBox;

procedure TTestViewItemBasic.Setup;
begin
  frmViewItem := TfrmViewItem.Create(nil);
  frmViewItem.Show;
end;

procedure TTestViewItemBasic.TearDown;
begin
  frmViewItem.Close;
  frmViewItem.Free;
end;

procedure TTestViewItemBasic.TestCreateViewItem(AItemId: string);
var
  ItemInstance: TControl;
  C: Integer;
begin
  // Factory를 이용한 컨트롤 생성
  ItemInstance := TViewItemFactory.Instance.CreateControl(AItemId);
  Assert.IsNotNull(ItemInstance);

  ItemInstance.Parent := frmViewItem.Panel1;
  ItemInstance.Align := TAlignLayout.Top;
end;

procedure TTestViewItemBasic.TestContainerViewItem;
var
  ListInstance, ItemInstance, Container: TControl;
  ItemClass: TViewItemClass;
begin
  ListInstance := TViewItemFactory.Instance.CreateControl('ListBox');
  Assert.IsNotNull(ListInstance);

  ListInstance.Parent := frmViewItem.Panel1;
  ListInstance.Align := TAlignLayout.Top;

  // ListBox
  if Supports(ListInstance, IViewItemContainer) then
    Container := (ListInstance as IViewItemContainer).GetContainerObject;

  Assert.IsNotNull(Container);

  Assert.AreEqual(TListBox(Container).Count, 0);

  // ViewItem Class로 ViewItem 생성
  ItemClass := TViewItemFactory.Instance.GetClass('ListBoxItemRightText.RightText');

  ItemInstance := ItemClass.Create(Container);
  ItemInstance.Parent := Container;
  Assert.AreEqual(TListBox(Container).Count, 1);

  ItemInstance := ItemClass.Create(Container);
  ItemInstance.Parent := Container;
  Assert.AreEqual(TListBox(Container).Count, 2);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestViewItemBasic);
end.
