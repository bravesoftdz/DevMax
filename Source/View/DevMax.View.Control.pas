unit DevMax.View.Control;

interface

uses
  FMX.Controls, FMX.Types,
  DevMax.View.Types;

type
  TViewPageControlItem = class;

  /// 여러개의 ViewPageControlItem 보유
  TViewPageControl = class(TControl)
  private
    FActivePage: TViewPageControlItem;
  protected
    procedure Resize; override;
  public
    procedure ChangePage(AViewPage: TViewPageControlItem; const ATransition: TPageChangeTransition = None;
      const ADirection: TPageChangeTransitionDirection = Normal); overload;
  end;

  /// 페이지 표시 컨트롤
  TViewPageControlItem = class(TControl)
  protected
    procedure DoRealign; override;{TControl.DoRealign}
  end;

implementation

uses
  FMX.Ani;

{ TViewPageControl }

procedure TViewPageControl.ChangePage(AViewPage: TViewPageControlItem;
  const ATransition: TPageChangeTransition;
  const ADirection: TPageChangeTransitionDirection);
const
  Duration = 0.25;
var
  Page, Page2: TViewPageControlItem;
  SourceX, TargetX: Single;
begin
  if FActivePage = AViewPage then
    Exit;

  if ATransition = TPageChangeTransition.None then
  begin
    if Assigned(FACtivePage) then
      FActivePage.Visible := False;
    FActivePage := AViewPage;
  end
  else if ATransition = Slide then
  begin
    Page := FActivePage;
    Page2 := AViewPage;

    if ADirection = Normal then
    begin
      SourceX := Page.Width;
      TargetX := -Page.Width
    end
    else
    begin
      SourceX := -Page.Width;
      TargetX := Page.Width;
    end;

    Page2.Position.X := SourceX;
    Page2.Visible := True;

    TAnimator.AnimateFloat(Page, 'Position.X', TargetX, Duration, TAnimationType.In, TInterpolationType.Linear);
    TAnimator.AnimateFloatWait(Page2, 'Position.X', 0, Duration, TAnimationType.In, TInterpolationType.Linear);

    Page.Visible := False;
    FActivePage := AViewPage;
    FActivePage.Realign;
  end;
end;

procedure TViewPageControl.Resize;
begin
  inherited;

  if Assigned(FActivePage) then
    FActivePage.Realign;
end;

{ TViewPageControlItem }

procedure TViewPageControlItem.DoRealign;
begin
  inherited;

  SetBoundsRect(ParentControl.BoundsRect);
end;

end.
