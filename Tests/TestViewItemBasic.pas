unit TestViewItemBasic;

interface
uses
  DUnitX.TestFramework;

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
  System.SysUtils, FMX.Controls, FMX.Types, FMX.ListBox,
  ViewItemTestForm,
  DevMax.View.Types, DevMax.View.Factory, DevMax.ViewItem.ListBox;

procedure TTestViewItemBasic.Setup;
begin
  frmViewItem := TfrmViewItem.Create(nil);
//  frmViewItem.Show;
end;

procedure TTestViewItemBasic.TearDown;
begin
//  frmViewItem.Close;
  frmViewItem.Free;
end;

procedure TTestViewItemBasic.TestCreateViewItem(AItemId: string);
var
  ItemInstance: TControl;
begin
  // Factory를 이용한 컨트롤 생성
  ItemInstance := TViewItemFactory.Instance.CreateControl(AItemId, frmViewItem);
  Assert.IsNotNull(ItemInstance);

  ItemInstance.Parent := frmViewItem.Panel1;
  ItemInstance.Align := TAlignLayout.Top;
end;

procedure TTestViewItemBasic.TestContainerViewItem;
var
  ListInstance, ItemInstance1, ItemInstance2, Container: TControl;
  ItemClass: TViewItemClass;
begin
  // Get ListBox ViewItem
  ListInstance := TViewItemFactory.Instance.CreateControl('ListBox', frmViewItem);
  Assert.IsNotNull(ListInstance);

  ListInstance.Parent := frmViewItem.Panel1;
  ListInstance.Align := TAlignLayout.Top;

  // Get ListBox Object
  Container := nil;
  if Supports(ListInstance, IViewItemContainer) then
    Container := (ListInstance as IViewItemContainer).GetContainerObject;

  Assert.IsNotNull(Container);

  Assert.AreEqual<Integer>(TListBox(Container).Count, 0);

  // ViewItem Class로 ViewItem 생성
  ItemClass := TViewItemFactory.Instance.GetClass('ListBoxItemRightText.RightText');

  ItemInstance1 := ItemClass.Create(Container);
  ItemInstance1.Parent := Container;
  Assert.AreEqual<Integer>(TListBox(Container).Count, 1);

  ItemInstance2 := ItemClass.Create(Container);
  ItemInstance2.Parent := Container;
  Assert.AreEqual<Integer>(TListBox(Container).Count, 2);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestViewItemBasic);
end.
