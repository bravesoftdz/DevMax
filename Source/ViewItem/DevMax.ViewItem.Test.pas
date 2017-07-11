unit DevMax.ViewItem.Test;

interface

uses
  DevMax.View.Types,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TFrame1 = class(TFrame, IViewItem)
    Button1: TButton;
    Edit1: TEdit;
  private
    { Private declarations }
    function GetDataControls: TViewItemDataControls;
    function GetControlEvents: TViewItemControlEvents;
  public
    { Public declarations }
  end;

implementation

uses
  DevMax.View.Factory;

{$R *.fmx}

{ TFrame1 }

function TFrame1.GetDataControls: TViewItemDataControls;
begin
  Result := [
    TViewItemDataControl.Create('ButtonCaption',  Button1,  'Text'),
    TViewItemDataControl.Create('EditText',       Edit1,   'Text')
  ];
end;

function TFrame1.GetControlEvents: TViewItemControlEvents;
begin

end;

initialization
  TViewItemFactory.Instance.Regist('TestViewItem', TFrame1);

end.
