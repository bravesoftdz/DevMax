unit ViewItemTestForm;

interface

uses
  DevMax.Types, DevMax.Types.ViewInfo, TestViewInfoData,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmViewItem = class(TForm, IManifestManager)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetViewInfo(AViewId: string): TViewInfo;
  end;

var
  frmViewItem: TfrmViewItem;

implementation

{$R *.fmx}

{ TfrmViewItem }

function TfrmViewItem.GetViewInfo(AViewId: string): TViewInfo;
begin
  Result := GetViewInfoData;
//  Result := GetViewInfoData;
end;

end.
