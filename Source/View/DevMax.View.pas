unit DevMax.View;

interface

uses
  FMX.Controls, DevMax.Types.ViewInfo;

type
  TView = class
  public
    constructor Create(AViewId: string; AContainer: TControl; AViewInfo: TViewInfo);
    destructor Destroy; override;

    procedure Show;
    procedure Hide;
  end;

implementation

{ TView }

constructor TView.Create(AViewId: string; AContainer: TControl; AViewInfo: TViewInfo);
begin

end;

destructor TView.Destroy;
begin

  inherited;
end;

procedure TView.Hide;
begin

end;

procedure TView.Show;
begin

end;

end.
