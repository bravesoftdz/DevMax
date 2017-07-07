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
  ItemInstance := TViewItemFactory.Instance.CreateControl(AItemId);
  Assert.IsNotNull(ItemInstance);

  ItemInstance.Parent := frmViewItem.Panel1;
  ItemInstance.Align := TAlignLayout.Top;

  Assert.AreEqual(frmViewItem.Panel1.ChildrenCount, 1);
end;

procedure TTestViewItemBasic.TestContainerViewItem;
var
  ItemInstance, ItemCtrl, Container: TControl;
begin
  ItemInstance := TViewItemFactory.Instance.CreateControl('ListBox');
  Assert.IsNotNull(ItemInstance);

  ItemInstance.Parent := frmViewItem.Panel1;
  ItemInstance.Align := TAlignLayout.Top;

  Assert.IsTrue(Supports(ItemInstance, IViewItemContainer));

  Assert.AreEqual(TfrListBox(ItemInstance).ListBox1.Count, 0);

  Container := (ItemInstance as IViewItemContainer).GetContainerObject;

  ItemCtrl := TViewItemFactory.Instance.CreateControl('ListBoxItemRightText.RightText');
  ItemCtrl.Parent := Container;

  Assert.AreEqual(TfrListBox(ItemInstance).ListBox1.Count, 1);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestViewItemBasic);
end.
