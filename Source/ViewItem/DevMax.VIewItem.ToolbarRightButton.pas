unit DevMax.VIewItem.ToolbarRightButton;

interface

uses
  DevMax.View.Types,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TToolbarRightButton = class(TFrame, IViewItem)
    ToolBar1: TToolBar;
    Button1: TButton;
    Label1: TLabel;
  private
    { Private declarations }
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  DevMax.View.Factory;

{ TToolbarRightButton }

function TToolbarRightButton.GetDataControls: TViewItemDataControls;
begin
  Result := [
    TViewItemDataControl.Create('ButtonCaption',  Button1,  'Text'),
    TViewItemDataControl.Create('TitleLabel',     Label1,   'Text')
  ];
end;

function TToolbarRightButton.GetControlEvents: TViewItemControlEvents;
begin

end;

initialization
  TViewItemFactory.Instance.Regist('ToolbarRightButton', TToolbarRightButton);

end.

