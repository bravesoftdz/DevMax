unit DevMax.View.Manager;

interface

uses
  System.Classes, System.SysUtils,
  System.Generics.Collections, FMX.Controls,
  DevMax.Types, DevMax.Types.ViewInfo,
  DevMax.View.Types, DevMax.View,
  DevMax.Service.Manifest;

type
  TViewManager = class
  private
    FViewContainer: TControl;
    FViews: TDictionary<string, TView>;
    FActiveView: TView;

    FManifestService: IManifestService;

    function CreateView(AViewId: string): TView;
    function GetOrCreateView(AViewId: string): TView;
    procedure ClearViews;
    function GetViews: TArray<TView>;
    function GetManifestService: IManifestService;
  public
    constructor Create;
    destructor Destroy; override;

    property ViewContainer: TControl read FViewContainer write FViewContainer;
    property ManifestService: IManifestService read GetManifestService {$IFDEF TEST}write FManifestService{$ENDIF};
    property Views: TArray<TView> read GetViews;

    procedure ShowView(AViewId: string);

    property ActiveView: TView read FActiveView;
  end;

implementation

uses
  FMX.Dialogs;

{ TViewManager }

constructor TViewManager.Create;
begin
  FViews := TDictionary<string, TView>.Create;
end;

destructor TViewManager.Destroy;
begin
  ClearViews;
  FViews.Free;

  inherited;
end;

procedure TViewManager.ClearViews;
var
  View: TView;
begin
  for View in FViews.Values do
    View.Free;
  FViews.Clear;
end;

function TViewManager.CreateView(AViewId: string): TView;
var
  ViewInfo: TViewInfo;
begin
  if not Assigned(ManifestService) then
    raise Exception.Create('Not assigned IManifestManager');

  { TODO : View�� �����Ǵ� ���� UI ǥ�� }

  if not ManifestService.TryGetViewInfo(AViewId, ViewInfo) then
    raise Exception.Create('View ������ ������ �� �����ϴ�.');

  Result := TView.Create(AViewId, FViewContainer, ViewInfo);

  FViews.Add(AViewId, Result);
end;

function TViewManager.GetManifestService: IManifestService;
begin
  if not Assigned(FManifestService) then
    FManifestService := TManifestService.Create; // ARC ����Ǿ� �������� �ʾƵ� ��
  Result := FManifestService;
end;

function TViewManager.GetOrCreateView(AViewId: string): TView;
begin
  if not FViews.TryGetValue(AViewId, Result) then
    Result := CreateView(AViewId);
end;

function TViewManager.GetViews: TArray<TView>;
begin
  Result := FViews.Values.ToArray;
end;

procedure TViewManager.ShowView(AViewId: string);
var
  View: TView;
begin
  View := GetOrCreateView(AViewId);

  if not Assigned(View) then
  begin
    ShowMessageFmt('Not found view.(View Id: %s)', [AViewId]);
    Exit;
  end;

  if Assigned(FActiveView) then
    FActiveView.Hide;
  FActiveView := View;
  FActiveView.Show;
end;

end.
