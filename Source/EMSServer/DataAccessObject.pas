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
    FDQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;

    function GetViewInfo(AViewSeq: Integer): TJSONObject;

    class function Instance: TDataAccessObject;
    class procedure ReleaseInstance;
  end;

implementation

{ TDataAccessObject }

uses DevMax.Utils.Converter;

constructor TDataAccessObject.Create;
begin
  FDConnection := TFDConnection.Create(nil);
  FDConnection.DriverName := 'IB';
  FDConnection.Params.Values['Database'] := 'D:\Projects\DevMax\Source\EMSServer\DB\DEVMAXMAINTENANCE.IB';
  FDConnection.Params.Values['User_Name'] := 'sysdba';
  FDConnection.Params.Values['Password'] := 'masterkey';
  FDConnection.Params.Values['CharacterSet'] := 'UTF8';

  FDQuery := TFDQuery.Create(nil);
  FDQUery.Connection := FDConnection;
end;

destructor TDataAccessObject.Destroy;
begin
  FDQuery.Free;
  FDConnection.Free;

  inherited;
end;

function TDataAccessObject.GetViewInfo(AViewSeq: Integer): TJSONObject;
begin
  Result := TJSONObject.Create;
  FDQuery.Close;
  FDQuery.SQL.Text := 'SELECT VIEW_SEQ, MAIN_PAGE_SEQ FROM DMX_VIEW WHERE VIEW_SEQ = :VIEW_SEQ';
  FDQUery.ParamByName('VIEW_SEQ').AsInteger := AViewSeq;
  FDQuery.Open;

  TDataConverter.DataSetToJSONObject(FDQuery, Result);
end;

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

initialization
finalization
  TDataAccessObject.ReleaseInstance;

end.
