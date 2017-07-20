unit TestConverter;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestConverter = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestJOSNToRecord;
  end;

implementation

uses
  System.JSON, System.SysUtils,
  DevMax.Utils.Marshalling, DevMax.Types.ViewInfo, TestViewInfoData;

procedure TTestConverter.Setup;
begin
end;

procedure TTestConverter.TearDown;
begin
end;


procedure TTestConverter.TestJOSNToRecord;
var
  JsonString: string;
  Obj: TJSONObject;
  ViewInfo: TViewInfo;
begin
  JsonString := TestJsonString;

  Obj := TJSONObject.Create;
  Obj.Parse(TEncoding.ASCII.GetBytes(JsonString), 0);

  TMarshall.JSONToRecord<TViewInfo>(Obj, ViewInfo);

  Assert.AreEqual<string>(ViewInfo.VIEW_ID, 'V00000000001');
  Assert.AreEqual<string>(ViewInfo.ViewPages[0].PAGE_ID, 'P00000000001');
  Assert.AreEqual<string>(ViewInfo.ViewPages[1].ViewItems[1].ITEM_ID, 'I00000000004');
  Assert.AreEqual<string>(ViewInfo.ViewPages[1].ViewItems[1].ViewItems[1].ITEM_ID, 'I00000000006');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConverter);
end.
