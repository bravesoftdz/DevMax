unit DevMaxResource;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes;

type
  [ResourceName('devmax')]
  TDevMaxManifestResource1 = class(TDataModule)
  published
    [ResourceSuffix('manifest/views')]
    procedure GetManifestViews(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [ResourceSuffix('manifest/views/{item}')]
    procedure GetManifestViewsItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses DataAccessObject;

{$R *.dfm}

procedure TDevMaxManifestResource1.GetManifestViews(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
begin
  // Sample code
  AResponse.Body.SetValue(TJSONString.Create('DevMax/Manifest'), True)
end;

procedure TDevMaxManifestResource1.GetManifestViewsItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  ViewId: string;
  JSONValue: TJSONValue;
begin

  ViewId := ARequest.Params.Values['item'];

  JSONValue := TDataAccessObject.Instance.GetViewInfo(ViewId) as TJSONValue;

  AResponse.Body.SetValue(JSONValue, True);
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TDevMaxManifestResource1));
end;

initialization
  Register;
end.


