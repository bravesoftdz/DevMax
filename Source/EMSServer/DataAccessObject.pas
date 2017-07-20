unit DataAccessObject;

interface

uses
  System.JSON,
  FireDAC.Comp.Client;

type
  TDataAccessObject = class
  private
    class var FInstance: TDataAccessObject;
  private
    FDConnection: TFDConnection;
//    FDQuery: TFDQuery;

    function GetQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;

    function GetViewInfo(AViewId: string): TJSONObject;
    function GetPagesInfo(AViewId: string): TJSONArray;
    function GetViewItemsInfo(APageId: string; AParentItemId: string = ''): TJSONArray;

    class function Instance: TDataAccessObject;
    class procedure ReleaseInstance;
  end;

implementation

{ TDataAccessObject }

uses DevMax.Utils.Marshalling;

const
  SQL_VIEW_ITEM = 'SELECT VIEW_ID, MAIN_PAGE_ID FROM DMX_VIEW WHERE VIEW_ID = :VIEW_ID';
  SQL_PAGE_LIST = 'SELECT PAGE_ID FROM DMX_VIEW_PAGE WHERE VIEW_ID = :VIEW_ID';
  SQL_VIEW_ITEM_LIST        = 'SELECT ITEM_ID, ITEM_CLS_ID, ALIGN, HEIGHT FROM DMX_VIEW_ITEM WHERE PAGE_ID = :PAGE_ID AND PARENT_ITEM_ID IS NULL';
  SQL_VIEW_ITEM_LIST_CHILD  = 'SELECT ITEM_ID, ITEM_CLS_ID, ALIGN, HEIGHT FROM DMX_VIEW_ITEM WHERE PAGE_ID = :PAGE_ID AND PARENT_ITEM_ID = :PARENT_ITEM_ID';

class function TDataAccessObject.Instance: TDataAccessObject;
begin
  if not Assigned(FInstance) then
    FInstance := Create;
  Result := FInstance;
end;

class procedure TDataAccessObject.ReleaseInstance;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

constructor TDataAccessObject.Create;
begin
  FDConnection := TFDConnection.Create(nil);
  FDConnection.DriverName := 'IB';
  FDConnection.Params.Values['Database'] := 'D:\Projects\DevMax\Source\EMSServer\DB\DEVMAXMAINTENANCE.IB';
  FDConnection.Params.Values['User_Name'] := 'sysdba';
  FDConnection.Params.Values['Password'] := 'masterkey';
  FDConnection.Params.Values['CharacterSet'] := 'UTF8';
end;

destructor TDataAccessObject.Destroy;
begin
//  FDQuery.Free;
  FDConnection.Free;

  inherited;
end;

function TDataAccessObject.GetQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDConnection;
end;

function TDataAccessObject.GetViewInfo(AViewId: string): TJSONObject;
var
  Query: TFDQuery;
begin
  Result := TJSONObject.Create;
  Query := GetQuery;
  try
    Query.SQL.Text := SQL_VIEW_ITEM;
    Query.ParamByName('VIEW_ID').AsString := AViewId;
    Query.Open;

    if Query.RecordCount = 0 then
      Exit(nil);

    TMarshall.DataSetToJSONObject(Query, Result);

    Result.AddPair('Pages', GetPagesInfo(AViewId));
  finally
    Query.Free;
  end;
end;

function TDataAccessObject.GetPagesInfo(AViewId: string): TJSONArray;
var
  Query: TFDQuery;
begin
  Result := TJSONArray.Create;
  Query := GetQuery;
  try
    Query.SQL.Text := SQL_PAGE_LIST;
    Query.ParamByName('VIEW_ID').AsString := AViewId;
    Query.Open;

    TMarshall.DataSetToJSONArray(Query, Result, procedure(AObj: TJSONObject)
      var
        PageId: string;
        Items: TJSONArray;
      begin
        PageId := AObj.GetValue<string>('PAGE_ID');
        Items := GetViewItemsInfo(PageId);
        if Items.Count > 0 then
          AObj.AddPair('ViewItems', Items);
      end
    );
  finally
    Query.Free;
  end;
end;

function TDataAccessObject.GetViewItemsInfo(APageId: string; AParentItemId: string): TJSONArray;
var
  Query: TFDQuery;
begin
  Result := TJSONArray.Create;
  Query := GetQuery;
  try
    if AParentItemId = '' then
      Query.SQL.Text := SQL_VIEW_ITEM_LIST
    else
      Query.SQL.Text := SQL_VIEW_ITEM_LIST_CHILD;
    Query.ParamByName('PAGE_ID').AsString := APageId;
    if AParentItemId <> '' then
      Query.ParamByName('PARENT_ITEM_ID').AsString := AParentItemId;
    Query.Open;

    TMarshall.DataSetToJSONArray(Query, Result, procedure(AObj: TJSONObject)
      var
        ItemId: string;
        ChildItems: TJSONArray;
      begin
        ItemId := AObj.GetValue<string>('ITEM_ID');
        ChildItems := GetViewItemsInfo(APageId, ItemId);
        if ChildItems.Count > 0 then
          AObj.AddPair('ViewItems', ChildItems);

      end);
  finally
    Query.Free;
  end;
end;

initialization
finalization
  TDataAccessObject.ReleaseInstance;

end.
