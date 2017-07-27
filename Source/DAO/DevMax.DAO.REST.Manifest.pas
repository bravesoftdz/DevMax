unit DevMax.DAO.REST.Manifest;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo,
  IPPeerClient, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope // REST Client
  ;

type
  TManifestRESTDAO = class(TInterfacedObject, IManifestDAO)
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
  public
    constructor Create;
    destructor Destroy; override;

    function TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
  end;

implementation

uses DevMax.Utils.Marshalling, System.JSON;

{ TManifestDAO }

constructor TManifestRESTDAO.Create;
begin
  FRESTClient := TRESTClient.Create(nil);
//{$IFDEF WIN32}
//  FRESTClient.BaseURL := 'http://localhost:8080';
//{$ELSE}
  FRESTClient.BaseURL := 'http://192.168.168.106:8080';
//{$ENDIF}

  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Resource := 'devmax/manifest/views/{view_id}';
end;

destructor TManifestRESTDAO.Destroy;
begin
  FRESTRequest.Free;
  FRESTResponse.Free;
  FRESTClient.Free;

  inherited;
end;

function TManifestRESTDAO.TryGetViewInfo(AViewId: string;
  out ViewInfo: TViewInfo): Boolean;
begin
  try
    FRESTRequest.Params.ParameterByName('view_id').Value := AViewId;
    FRESTRequest.Execute;

    Result := True;
    TMarshall.JSONToRecord<TViewInfo>(FRESTResponse.JSONValue as TJSONObject, ViewInfo);
  except
    Exit(False);
  end;
end;

end.
