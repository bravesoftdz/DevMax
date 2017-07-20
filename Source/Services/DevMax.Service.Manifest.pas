unit DevMax.Service.Manifest;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo,
  DevMax.DAO.REST.Manifest;

type
  TManifestService = class(TInterfacedObject, IManifestService)
  private
    FManifestDAO: IManifestDAO;
  public
    constructor Create;
    destructor Destroy; override;

    function TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
  end;

implementation

{ TViewController }

constructor TManifestService.Create;
begin
  { TODO : DAO ã�� ���� �ʿ�(Factory??) }
  FManifestDAO := TManifestRESTDAO.Create
end;

destructor TManifestService.Destroy;
begin

  inherited;
end;

function TManifestService.TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
begin
  { TODO : Thread ó�� �ʿ�??? }
  Result := FManifestDAO.TryGetViewInfo(AViewId, ViewInfo);
end;

end.
