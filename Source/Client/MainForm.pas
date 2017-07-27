unit MainForm;

interface

uses
  DevMax.View.Manager,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.StdCtrls;

type
  TfrmClientMain = class(TForm)
    lytMain: TLayout;
    MultiView1: TMultiView;
    Button1: TButton;
    lytContainer: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FViewManager: TViewManager;
  public
    { Public declarations }
  end;

var
  frmClientMain: TfrmClientMain;

implementation

{$R *.fmx}

procedure TfrmClientMain.Button1Click(Sender: TObject);
begin
  FViewManager.ShowView('V00000000001');
//  Layout1.BringToFront;
//  MultiView1.HideMaster;
//  MultiView1.BringToFront;
end;

procedure TfrmClientMain.FormCreate(Sender: TObject);
begin
  FViewManager := TViewManager.Create;
  FViewManager.ViewContainer := lytContainer;
end;

procedure TfrmClientMain.FormDestroy(Sender: TObject);
begin
  FViewManager.Free;
end;

end.
