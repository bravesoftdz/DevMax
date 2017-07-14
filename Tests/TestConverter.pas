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
  DevMax.Utils.Converter, DevMax.Types.ViewInfo, TestViewInfoData;

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
  Item: TViewItemInfo;
begin
  JsonString := TestJsonString;

  Obj := TJSONObject.Create;
  Obj.Parse(TEncoding.ASCII.GetBytes(JsonString), 0);
//  Value := TJSONObject.ParseJSONValue(JsonString);

  TDataConverter.JSONToRecord<TViewInfo>(Obj, ViewInfo);

  Assert.AreEqual<string>(ViewInfo.VIEW_ID, 'V00000000001');

  Assert.AreEqual<string>(ViewInfo.ViewPages[0].PAGE_ID, 'P00000000001');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestConverter);
end.
