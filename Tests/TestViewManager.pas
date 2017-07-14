unit TestViewManager;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestViewManager = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestGetManifestData; // View 설정 정보 취득

    // Cteate View(with ViewItem)

    // Binding ViewItem and Data
  end;

implementation

uses
  ViewItemTestForm,
  DevMax.Types.ViewInfo, TestViewInfoData,
  DevMax.View.Manager;

procedure TTestViewManager.Setup;
begin
  frmViewItem := TfrmViewItem.Create(nil);
//  frmViewItem.Show;
end;

procedure TTestViewManager.TearDown;
begin
//  frmViewItem.Close;
  frmViewItem.Free;
end;


procedure TTestViewManager.TestGetManifestData;
var
  TestViewInfo: TViewInfo;
  ViewManager: TViewManager;
begin
  TestViewInfo := GetViewInfoData;

  ViewManager := TViewManager.Create;

  ViewManager.ViewContainer := frmViewItem.Panel1;
  ViewManager.ManifestManager := frmViewItem;
  ViewManager.ShowView(TestViewInfo.VIEW_ID);

  Assert.AreEqual<Integer>(Length(ViewManager.Views), 1);

  Assert.AreEqual<string>(ViewManager.ActiveView.ActivePage.Id, TestViewInfo.MAIN_PAGE_ID);

  ViewManager.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestViewManager);
end.
