unit DevMax.Types;

interface

uses
  DevMax.Types.ViewInfo;

type
  IManifestManager = interface
    ['{C5ECE5B9-2D3D-44C5-9291-ADFE0425AEF2}']
    function GetViewInfo(AViewId: string): TViewInfo;
  end;

implementation

end.
