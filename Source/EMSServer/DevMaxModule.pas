unit DevMaxModule;

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
    [ResourceSuffix('manifest/views/{ViewSeq}')]
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
  ViewSeq: Integer;
  JSONValue: TJSONValue;
begin
  ViewSeq := StrToIntDef(ARequest.Params.Values['ViewSeq'], 0);
  // Sample code

//  AResponse.Body.SetValue();

  JSONValue := TDataAccessObject.Instance.GetViewInfo(ViewSeq) as TJSONValue;

  AResponse.Body.SetValue(JSONValue, True);

//  AResponse.Body.SetValue(TJSONString.Create('DevMax/Manifest ' + LItem), True)
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TDevMaxManifestResource1));
end;

initialization
  Register;
end.


