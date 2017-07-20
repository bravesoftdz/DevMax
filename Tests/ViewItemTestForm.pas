unit ViewItemTestForm;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo, TestViewInfoData,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmViewItem = class(TForm, IManifestService)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }

    { IManifestService }
    function TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
  end;

var
  frmViewItem: TfrmViewItem;

implementation

{$R *.fmx}

{ TfrmViewItem }

function TfrmViewItem.TryGetViewInfo(AViewId: string;
  out ViewInfo: TViewInfo): Boolean;
begin
  ViewInfo := GetViewInfoData;
  Result := True;
end;

end.
