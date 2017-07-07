unit DevMax.View.Manager;

interface

uses
  System.Generics.Collections, FMX.Controls,
  DevMax.View.Types, DevMax.View;

type
  TViewManager = class
  private
    FViewControl: TControl;
    FViews: TDictionary<string, TView>;
    FActiveView: TView;

    function CreateView(AViewId: string): TView;
    function GetOrCreateView(AViewId: string): TView;
    procedure ClearViews;
  public
    constructor Create;
    destructor Destroy; override;

    property ViewContainer: TControl read FViewControl write FViewControl;

    procedure ShowView(AViewId: string);
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
begin
  Result := TView.Create;

  FViews.Add(AViewId, Result);
end;

function TViewManager.GetOrCreateView(AViewId: string): TView;
begin
  if not FViews.TryGetValue(AViewId, Result) then
    Result := CreateView(AViewId);
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